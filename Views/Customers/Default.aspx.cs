using System;
using System.Web.UI;
using Services;

namespace Views
{
    public partial class Customers : Page
    {
        private CustomerService svc = new CustomerService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("customers", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                BindGrid();
        }

        private void BindGrid()
        {
            var keyword = txtKeyword.Text.Trim();
            gvCustomers.DataSource = svc.GetAll(keyword, 1, 100);
            gvCustomers.DataBind();
        }

        protected void BtnSearch_Click(object sender, EventArgs e) { BindGrid(); }

        protected void GvCustomers_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteItem")
            {
                var id = int.Parse(e.CommandArgument.ToString());
                svc.Delete(id);
                BindGrid();
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
