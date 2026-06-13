using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;
using Entities;

namespace Views
{
    public partial class Purchases : Page
    {
        private PurchaseService purSvc = new PurchaseService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("purchases", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
            {
                BindGrid();
                BindProductDropdowns();
            }
        }

        private void BindGrid()
        {
            var status = ddlStatus.SelectedValue;
            gvOrders.DataSource = purSvc.GetAll(status, 1, 100);
            gvOrders.DataBind();
        }

        private void BindProductDropdowns()
        {
            var prodSvc = new ProductService();
            var products = prodSvc.GetActiveForSale();
            ddlProduct0.DataSource = products;
            ddlProduct0.DataTextField = "name";
            ddlProduct0.DataValueField = "id";
            ddlProduct0.DataBind();

            var supSvc = new SupplierService();
            var suppliers = supSvc.GetAllSimple();
            ddlSupplier.DataSource = suppliers;
            ddlSupplier.DataTextField = "name";
            ddlSupplier.DataValueField = "id";
            ddlSupplier.DataBind();
        }

        protected void BtnFilter_Click(object sender, EventArgs e) { BindGrid(); }

        protected void GvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "Detail")
            {
                var order = purSvc.GetById(id);
                litDetailTitle.Text = "进货单详情 - " + order.orderNo;
                litDetailSupplier.Text = order.supplier?.name;
                litDetailStatus.Text = order.status;
                litDetailAmount.Text = order.totalAmount.ToString("F2");
                gvItems.DataSource = order.items;
                gvItems.DataBind();
                pnlDetail.Visible = true;
            }
            else if (e.CommandName == "Confirm")
            {
                purSvc.ConfirmStockIn(id);
                BindGrid();
            }
            else if (e.CommandName == "Cancel")
            {
                purSvc.CancelOrder(id);
                BindGrid();
            }
        }

        protected void BtnShowCreate_Click(object sender, EventArgs e)
        {
            BindProductDropdowns();
            pnlCreate.Visible = true;
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

            purSvc.CreateOrder(order, items, Helpers.AuthHelper.GetUserId());
            pnlCreate.Visible = false;
            BindGrid();
        }

        protected void BtnBack_Click(object sender, EventArgs e) { pnlDetail.Visible = false; }
        protected void BtnCreateCancel_Click(object sender, EventArgs e) { pnlCreate.Visible = false; }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Default.aspx");
        }
    }
}
