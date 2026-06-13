using System;
using System.Web.UI;
using Services;
using Entities;

namespace Views
{
    public partial class SupplierEdit : Page
    {
        private SupplierService svc = new SupplierService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("suppliers", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
            {
                string idStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idStr))
                {
                    var s = svc.GetById(int.Parse(idStr));
                    hidId.Value = s.id.ToString();
                    txtName.Text = s.name;
                    txtContact.Text = s.contactPerson;
                    txtPhone.Text = s.phone;
                    txtEmail.Text = s.email;
                    txtAddress.Text = s.address;
                    txtRemark.Text = s.remark;
                    litFormTitle.Text = "编辑供应商";
                }
                else
                {
                    litFormTitle.Text = "新增供应商";
                }
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            var sup = new Supplier
            {
                name = txtName.Text,
                contactPerson = txtContact.Text,
                phone = txtPhone.Text,
                email = txtEmail.Text,
                address = txtAddress.Text,
                remark = txtRemark.Text
            };

            if (string.IsNullOrEmpty(hidId.Value))
                svc.Add(sup);
            else
            {
                sup.id = long.Parse(hidId.Value);
                svc.Update(sup);
            }

            Response.Redirect("Suppliers.aspx");
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Default.aspx");
        }
    }
}
