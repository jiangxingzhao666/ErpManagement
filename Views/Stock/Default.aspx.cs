using System;
using System.Web.UI;
using Services;

namespace Views
{
    public partial class StockAlert : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("stock", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                BindGrid();
        }

        private void BindGrid()
        {
            var svc = new ProductService();
            bool showDeleted = Helpers.AuthHelper.CanSeeDeleted();
            var alerts = svc.GetStockAlerts(showDeleted);

            gvAlerts.DataSource = alerts;
            gvAlerts.DataBind();

            pnlEmpty.Visible = alerts.Count == 0;
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
