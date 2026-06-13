using System;
using System.Web.UI;
using Services;

namespace Views
{
    public partial class Sales : Page
    {
        private SalesService saleSvc = new SalesService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("sales", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                BindGrid();
        }

        private void BindGrid()
        {
            gvOrders.DataSource = saleSvc.GetAll(1, 100);
            gvOrders.DataBind();
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
