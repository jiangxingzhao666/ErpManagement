using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;
using Entities;

namespace Views
{
    public partial class Suppliers : Page
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
                BindGrid();
        }

        private void BindGrid()
        {
            var keyword = txtKeyword.Text.Trim();
            gvSuppliers.DataSource = svc.GetAll(keyword, 1, 100);
            gvSuppliers.DataBind();
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            BindGrid();
        }

        protected void BtnShowAdd_Click(object sender, EventArgs e)
        {
            hidId.Value = "";
            txtName.Text = txtContact.Text = txtPhone.Text = txtEmail.Text = txtAddress.Text = txtRemark.Text = "";
            litFormTitle.Text = "新增供应商";
            pnlForm.Visible = true;
        }

        protected void GvSuppliers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditItem")
            {
                var s = svc.GetById(id);
                hidId.Value = s.id.ToString();
                txtName.Text = s.name;
                txtContact.Text = s.contactPerson;
                txtPhone.Text = s.phone;
                txtEmail.Text = s.email;
                txtAddress.Text = s.address;
                txtRemark.Text = s.remark;
                litFormTitle.Text = "编辑供应商";
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

            pnlForm.Visible = false;
            BindGrid();
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Default.aspx");
        }
    }
}
