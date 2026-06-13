using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;
using Entities;

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

        protected void BtnShowAdd_Click(object sender, EventArgs e)
        {
            hidId.Value = "";
            txtName.Text = txtPhone.Text = txtEmail.Text = txtAddress.Text = "";
            ddlLevel.SelectedValue = "普通";
            litFormTitle.Text = "新增客户";
            pnlForm.Visible = true;
        }

        protected void GvCustomers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditItem")
            {
                var c = svc.GetById(id);
                hidId.Value = c.id.ToString();
                txtName.Text = c.name;
                txtPhone.Text = c.phone;
                txtEmail.Text = c.email;
                txtAddress.Text = c.address;
                ddlLevel.SelectedValue = c.memberLevel;
                litFormTitle.Text = "编辑客户";
                pnlForm.Visible = true;
            }
            else if (e.CommandName == "DeleteItem")
            {
                svc.Delete(id);
                BindGrid();
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
