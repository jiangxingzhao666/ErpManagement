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

            if (Helpers.AuthHelper.IsManager())
            {
                ddlRole.Items.Clear();
                ddlRole.Items.Add(new ListItem("操作员", "操作员"));
            }

            if (!IsPostBack)
                BindGrid();
        }

        private void BindGrid()
        {
            bool showDeleted = Helpers.AuthHelper.CanSeeDeleted();
            gvUsers.DataSource = svc.GetAll(showDeleted);
            gvUsers.DataBind();
        }

        protected void BtnShowAdd_Click(object sender, EventArgs e)
        {
            hidId.Value = "";
            txtUsername.Text = txtDisplayName.Text = txtPassword.Text = "";
            ddlRole.SelectedValue = "操作员";
            litFormTitle.Text = "新增用户";
            pnlForm.Visible = true;
        }

        protected void GvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var id = int.Parse(e.CommandArgument.ToString());
            var target = svc.GetById(id);

            if (e.CommandName == "EditItem")
            {
                if (Helpers.AuthHelper.IsManager() && target.role == "管理员")
                    return;

                hidId.Value = target.id.ToString();
                txtUsername.Text = target.username;
                txtDisplayName.Text = target.displayName;
                txtPassword.Text = "";
                ddlRole.SelectedValue = target.role;
                litFormTitle.Text = "编辑用户";
                pnlForm.Visible = true;
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
                if (Helpers.AuthHelper.IsManager() && user.role == "管理员")
                {
                    var btnEdit = (Button)e.Row.FindControl("btnEdit");
                    var btnDel = (Button)e.Row.FindControl("btnDel");
                    if (btnEdit != null) btnEdit.Visible = false;
                    if (btnDel != null) btnDel.Visible = false;
                }
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hidId.Value))
            {
                var existing = svc.GetById(int.Parse(hidId.Value));
                if (Helpers.AuthHelper.IsManager() && existing.role == "管理员")
                    return;
            }

            var allowedRole = Helpers.AuthHelper.IsManager() ? "操作员" : ddlRole.SelectedValue;
            var user = new User
            {
                username = txtUsername.Text,
                passwordHash = txtPassword.Text,
                displayName = txtDisplayName.Text,
                role = allowedRole
            };

            if (string.IsNullOrEmpty(hidId.Value))
            {
                svc.Add(user);
            }
            else
            {
                user.id = long.Parse(hidId.Value);
                svc.Update(user);
            }

            pnlForm.Visible = false;
            BindGrid();
        }

        protected void BtnCancel_Click(object sender, EventArgs e) { pnlForm.Visible = false; }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Default.aspx");
        }
    }
}
