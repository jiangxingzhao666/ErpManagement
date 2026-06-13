using System;
using System.Web.UI;
using Services;
using Entities;

namespace Views
{
    public partial class CustomerEdit : Page
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
            {
                string idStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idStr))
                {
                    var c = svc.GetById(int.Parse(idStr));
                    hidId.Value = c.id.ToString();
                    txtName.Text = c.name;
                    txtPhone.Text = c.phone;
                    txtEmail.Text = c.email;
                    txtAddress.Text = c.address;
                    ddlLevel.SelectedValue = c.memberLevel;
                    litFormTitle.Text = "编辑客户";
                }
                else
                {
                    ddlLevel.SelectedValue = "普通";
                    litFormTitle.Text = "新增客户";
                }
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            var cus = new Customer
            {
                name = txtName.Text,
                phone = txtPhone.Text,
                email = txtEmail.Text,
                address = txtAddress.Text,
                memberLevel = ddlLevel.SelectedValue
            };

            if (string.IsNullOrEmpty(hidId.Value))
                svc.Add(cus);
            else
            {
                cus.id = long.Parse(hidId.Value);
                svc.Update(cus);
            }

            Response.Redirect("Customers/Default.aspx");
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
