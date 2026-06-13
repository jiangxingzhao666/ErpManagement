using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;
using Entities;

namespace Views
{
    public partial class UserEdit : Page
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
            {
                string idStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idStr))
                {
                    var user = svc.GetById(int.Parse(idStr));
                    if (Helpers.AuthHelper.IsManager() && user.role == "管理员")
                    {
                        litMsg.Text = "<div class='alert alert-error'>无权限编辑该用户</div>";
                        btnSave.Enabled = false;
                    }

                    hidId.Value = user.id.ToString();
                    txtUsername.Text = user.username;
                    txtDisplayName.Text = user.displayName;
                    txtPassword.Text = "";
                    ddlRole.SelectedValue = user.role;
                    litFormTitle.Text = "编辑用户";
                }
                else
                {
                    ddlRole.SelectedValue = "操作员";
                    litFormTitle.Text = "新增用户";
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
                svc.Add(user);
            else
            {
                user.id = long.Parse(hidId.Value);
                svc.Update(user);
            }

            Response.Redirect("../Users/Default.aspx");
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("../Products/Default.aspx");
        }
    }
}
