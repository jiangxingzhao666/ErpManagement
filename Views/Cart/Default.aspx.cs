using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Helpers;
using Services;
using Entities;

namespace Views
{
    public partial class Cart : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireLogin();
            var role = AuthHelper.GetRole();
            sidebar.InnerHtml = SidebarHelper.Build("cart", role);
            litUserInfo.Text = AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
            {
                var cusSvc = new CustomerService();
                var cus = cusSvc.GetAllSimple();
                ddlCustomer.DataSource = cus;
                ddlCustomer.DataTextField = "name";
                ddlCustomer.DataValueField = "id";
                ddlCustomer.DataBind();
                ddlCustomer.Items.Insert(0, new ListItem("散客", ""));
            }

            BindProductCards(txtKeyword.Text.Trim());
            BindCart();
            UpdateSummary();
        }

        private void BindProductCards(string keyword)
        {
            var prodSvc = new ProductService();
            var prods = prodSvc.GetActiveForSale();
            if (!string.IsNullOrEmpty(keyword))
                prods = prods.FindAll(p =>
                    p.name.IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0 ||
                    p.code.IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0);

            var cardData = prods.Select(p => new
            {
                Id = p.id,
                Code = p.code,
                Name = p.name,
                SellingPrice = p.sellingPrice,
                StockQuantity = p.stockQuantity,
                ImageUrl = string.IsNullOrEmpty(p.imagePath) ? "" : ResolveUrl(p.imagePath)
            }).ToList();

            rptProducts.DataSource = cardData;
            rptProducts.DataBind();
            pnlNoProducts.Visible = cardData.Count == 0;
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
        }

        protected void RptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                var productId = long.Parse(e.CommandArgument.ToString());
                var prodSvc = new ProductService();
                var product = prodSvc.GetById((int)productId);

                if (product == null || !product.isActive)
                    return;

                var cart = CartHelper.GetCart();
                var existing = cart.Find(c => c.ProductId == product.id);
                if (existing != null && existing.Quantity >= product.stockQuantity)
                {
                    litMsg.Text = "<div class='alert alert-error'>库存不足！当前库存: " + product.stockQuantity + "</div>";
                    return;
                }

                CartHelper.AddItem(product.id, product.name, product.code, product.unit, product.sellingPrice, 1, product.stockQuantity);

                BindCart();
                UpdateSummary();
            }
        }

        private void BindCart()
        {
            var cart = CartHelper.GetCart();
            gvCart.DataSource = cart;
            gvCart.DataBind();

            pnlEmpty.Visible = cart.Count == 0;
            btnCheckout.Enabled = cart.Count > 0;
        }

        private void UpdateSummary()
        {
            var subtotal = CartHelper.TotalAmount;
            var discount = string.IsNullOrEmpty(txtDiscount.Text) ? 0m : decimal.Parse(txtDiscount.Text);
            var total = subtotal - discount;
            if (total < 0) total = 0;
            litSubTotal.Text = subtotal.ToString("F2");
            litDiscount.Text = discount.ToString("F2");
            litTotal.Text = total.ToString("F2");
        }

        protected void GvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Header") return;

            var productId = long.Parse(e.CommandArgument.ToString());
            var cart = CartHelper.GetCart();
            var idx = cart.FindIndex(c => c.ProductId == productId);
            if (idx < 0) return;

            if (e.CommandName == "Plus")
            {
                var item = cart[idx];
                if (item.Quantity < item.StockAvailable)
                    CartHelper.UpdateQuantity(idx, item.Quantity + 1);
                else
                    litMsg.Text = "<div class='alert alert-error'>库存不足！</div>";
            }
            else if (e.CommandName == "Minus")
            {
                CartHelper.UpdateQuantity(idx, cart[idx].Quantity - 1);
            }
            else if (e.CommandName == "Remove")
            {
                CartHelper.RemoveItem(idx);
            }

            BindCart();
            UpdateSummary();
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            CartHelper.ClearCart();
            BindCart();
            UpdateSummary();
        }

        protected void BtnCheckout_Click(object sender, EventArgs e)
        {
            var cart = CartHelper.GetCart();
            if (cart.Count == 0) return;

            var items = new List<SalesOrderItem>();
            foreach (var ci in cart)
            {
                items.Add(new SalesOrderItem
                {
                    productId = ci.ProductId,
                    quantity = ci.Quantity
                });
            }

            long? customerId = null;
            if (!string.IsNullOrEmpty(ddlCustomer.SelectedValue))
                customerId = long.Parse(ddlCustomer.SelectedValue);

            var discount = string.IsNullOrEmpty(txtDiscount.Text) ? 0m : decimal.Parse(txtDiscount.Text);

            var order = new SalesOrder
            {
                customerId = customerId,
                discountAmount = discount,
                paymentMethod = ddlPayment.SelectedValue,
                remark = "购物车结算"
            };

            var svc = new SalesService();
            int result = svc.CreateSale(order, items, AuthHelper.GetUserId());

            if (result == -1)
            {
                litMsg.Text = "<div class='alert alert-error'>库存不足</div>";
                BindCart();
                UpdateSummary();
                return;
            }

            CartHelper.ClearCart();
            litMsg.Text = "<div class='alert alert-success'>结算成功！实收: ¥" + order.actualAmount.ToString("F2") + "</div>";
            BindCart();
            UpdateSummary();
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            AuthHelper.Logout();
            Response.Redirect("../Products/Default.aspx");
        }
    }
}
