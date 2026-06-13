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
    public partial class StoreFront : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            BindProducts();
            BindCart();
            UpdateCartSummary();
        }

        private void BindProducts()
        {
            var prodSvc = new ProductService();
            var prods = prodSvc.GetActiveForSale();
            var keyword = txtSearch.Text.Trim();

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
                ImagePath = p.imagePath
            }).ToList();

            rptProducts.DataSource = cardData;
            rptProducts.DataBind();
        }

        private void BindCart()
        {
            var cart = CartHelper.GetCart();
            rptCart.DataSource = cart;
            rptCart.DataBind();
            pnlCartEmpty.Visible = cart.Count == 0;
        }

        private void UpdateCartSummary()
        {
            var cart = CartHelper.GetCart();
            litSubtotal.Text = CartHelper.TotalAmount.ToString("F2");
            litItemCount.Text = cart.Sum(c => c.Quantity).ToString();
            litTotal.Text = CartHelper.TotalAmount.ToString("F2");
            btnCheckout.Enabled = cart.Count > 0;
        }

        protected void TxtSearch_TextChanged(object sender, EventArgs e)
        {
        }

        protected void RptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Add")
            {
                var productId = long.Parse(e.CommandArgument.ToString());
                var prodSvc = new ProductService();
                var product = prodSvc.GetById((int)productId);

                if (product == null || !product.isActive || product.stockQuantity <= 0)
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
                UpdateCartSummary();
            }
        }

        protected void RptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
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

            BindCart();
            UpdateCartSummary();
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            CartHelper.ClearCart();
            BindCart();
            UpdateCartSummary();
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

            var order = new SalesOrder
            {
                discountAmount = 0,
                paymentMethod = "现金",
                remark = "前台结算"
            };

            var svc = new SalesService();
            int result = svc.CreateSale(order, items, 0);

            if (result == -1)
            {
                litMsg.Text = "<div class='alert alert-error'>库存不足，结算失败</div>";
                BindCart();
                UpdateCartSummary();
                return;
            }

            CartHelper.ClearCart();
            litMsg.Text = "<div class='alert alert-success'>结算成功！合计: ¥" + order.actualAmount.ToString("F2") + "，感谢您的惠顾！</div>";
            BindCart();
            UpdateCartSummary();
        }
    }
}
