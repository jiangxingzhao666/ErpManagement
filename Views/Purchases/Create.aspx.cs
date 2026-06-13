using System;
using System.Collections.Generic;
using System.Web.UI;
using Services;
using Entities;

namespace Views
{
    public partial class PurchaseCreate : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("purchases", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                BindDropdowns();
        }

        private void BindDropdowns()
        {
            var supSvc = new SupplierService();
            var suppliers = supSvc.GetAllSimple();
            ddlSupplier.DataSource = suppliers;
            ddlSupplier.DataTextField = "name";
            ddlSupplier.DataValueField = "id";
            ddlSupplier.DataBind();

            var prodSvc = new ProductService();
            var products = prodSvc.GetActiveForSale();
            ddlProduct0.DataSource = products;
            ddlProduct0.DataTextField = "name";
            ddlProduct0.DataValueField = "id";
            ddlProduct0.DataBind();
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            var items = new List<PurchaseOrderItem>();
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
                items.Add(new PurchaseOrderItem
                {
                    productId = long.Parse(productIds[i]),
                    quantity = int.Parse(string.IsNullOrEmpty(quantities[i]) ? "1" : quantities[i])
                });
            }

            if (items.Count == 0) return;

            var order = new PurchaseOrder
            {
                supplierId = long.Parse(ddlSupplier.SelectedValue),
                remark = txtRemark.Text
            };

            var purSvc = new PurchaseService();
            purSvc.CreateOrder(order, items, Helpers.AuthHelper.GetUserId());

            Response.Redirect("Purchases/Default.aspx");
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
