using System;
using System.Collections.Generic;
using System.Web.UI;
using Services;
using Entities;

namespace Views
{
    public partial class SaleCreate : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("sales", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                BindDropdowns();
        }

        private void BindDropdowns()
        {
            var prodSvc = new ProductService();
            var products = prodSvc.GetActiveForSale();
            ddlProduct0.DataSource = products;
            ddlProduct0.DataTextField = "name";
            ddlProduct0.DataValueField = "id";
            ddlProduct0.DataBind();

            var cusSvc = new CustomerService();
            var customers = cusSvc.GetAllSimple();
            ddlCustomer.DataSource = customers;
            ddlCustomer.DataTextField = "name";
            ddlCustomer.DataValueField = "id";
            ddlCustomer.DataBind();
            ddlCustomer.Items.Insert(0, new System.Web.UI.WebControls.ListItem("散客（不选）", ""));
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            var items = new List<SalesOrderItem>();
            var productIds = new List<string>();
            var quantities = new List<string>();

            foreach (string key in Request.Form.AllKeys)
            {
                if (key.StartsWith("ddlProduct"))
                    productIds.Add(Request.Form[key]);
                if (key.StartsWith("txtQty"))
                    quantities.Add(Request.Form[key]);
            }

            for (int i = 0; i < productIds.Count; i++)
            {
                if (string.IsNullOrEmpty(productIds[i])) continue;
                items.Add(new SalesOrderItem
                {
                    productId = long.Parse(productIds[i]),
                    quantity = int.Parse(string.IsNullOrEmpty(quantities[i]) ? "1" : quantities[i])
                });
            }

            if (items.Count == 0)
            {
                litError.Text = "<div class='alert alert-error'>请添加商品</div>";
                return;
            }

            long? customerId = null;
            if (!string.IsNullOrEmpty(ddlCustomer.SelectedValue))
                customerId = long.Parse(ddlCustomer.SelectedValue);

            var order = new SalesOrder
            {
                customerId = customerId,
                discountAmount = decimal.Parse(string.IsNullOrEmpty(txtDiscount.Text) ? "0" : txtDiscount.Text),
                paymentMethod = ddlPayment.SelectedValue,
                remark = txtRemark.Text
            };

            var saleSvc = new SalesService();
            int result = saleSvc.CreateSale(order, items, Helpers.AuthHelper.GetUserId());

            if (result == -1)
            {
                litError.Text = "<div class='alert alert-error'>库存不足，请检查商品库存</div>";
                return;
            }

            Response.Redirect("Sales/Default.aspx");
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
