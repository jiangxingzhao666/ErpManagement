using System;
using System.Web.UI;
using Services;

namespace Views
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Helpers.AuthHelper.IsLogin())
            {
                string returnUrl = Request.QueryString["ReturnUrl"];
                if (!string.IsNullOrEmpty(returnUrl))
                    Response.Redirect(returnUrl);
                else
                    Response.Redirect(Helpers.AuthHelper.IsStaff() ? "Cart/Default.aspx" : "Products/Default.aspx");
            }
        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            var username = txtUsername.Text.Trim();
            var password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowAlert("请输入用户名和密码");
                return;
            }

            var svc = new UserService();
            var user = svc.Login(username, password);

            if (user != null)
            {
                Helpers.AuthHelper.SetLogin(user.id, user.role, user.displayName);
                string returnUrl = Request.QueryString["ReturnUrl"];
                if (!string.IsNullOrEmpty(returnUrl))
                    Response.Redirect(returnUrl);
                else
                    Response.Redirect(user.role == "操作员" ? "Cart/Default.aspx" : "Products/Default.aspx");
            }
            else
            {
                ShowAlert("用户名或密码错误");
            }
        }

        private void ShowAlert(string msg)
        {
            alert.InnerText = msg;
            alert.Visible = true;
        }
    }
}
