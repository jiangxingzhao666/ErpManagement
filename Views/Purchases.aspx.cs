using System;
using System.Web.UI;
using Services;

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
                BindGrid();
        }

        private void BindGrid()
        {
            var status = ddlStatus.SelectedValue;
            gvOrders.DataSource = purSvc.GetAll(status, 1, 100);
            gvOrders.DataBind();
        }

        protected void BtnFilter_Click(object sender, EventArgs e) { BindGrid(); }

        protected void GvOrders_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            var id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "Confirm")
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

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Default.aspx");
        }
    }
}
