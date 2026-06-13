using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;
using Entities;

namespace Views
{
    public partial class Users : Page
    {
        private UserService svc = new UserService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("users", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                BindGrid();
        }

        private void BindGrid()
        {
            bool showDeleted = Helpers.AuthHelper.CanSeeDeleted();
            gvUsers.DataSource = svc.GetAll(showDeleted);
            gvUsers.DataBind();
        }

        protected void GvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Header") return;

            var id = int.Parse(e.CommandArgument.ToString());
            var target = svc.GetById(id);

            if (e.CommandName == "EditItem")
            {
                if (Helpers.AuthHelper.IsManager() && target.role == "管理员")
                    return;

                Response.Redirect("Users/Edit.aspx?id=" + id);
            }
            else if (e.CommandName == "DeleteItem")
            {
                if (Helpers.AuthHelper.IsManager() && target.role == "管理员")
                    return;

                svc.Delete(id);
                BindGrid();
            }
        }

        protected void GvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var user = (User)e.Row.DataItem;
                var litStatus = (Literal)e.Row.FindControl("litStatus");

                litStatus.Text = user.isActive
                    ? "<span class='tag tag-ok'>正常</span>"
                    : "<span class='tag tag-danger'>已删除</span>";

                if (Helpers.AuthHelper.IsManager() && user.role == "管理员")
                {
                    var btnEdit = (Button)e.Row.FindControl("btnEdit");
                    var btnDel = (Button)e.Row.FindControl("btnDel");
                    if (btnEdit != null) btnEdit.Visible = false;
                    if (btnDel != null) btnDel.Visible = false;
                }
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
