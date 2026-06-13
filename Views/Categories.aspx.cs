using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;
using Entities;

namespace Views
{
    public partial class Categories : Page
    {
        private CategoryService svc = new CategoryService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("categories", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                BindGrid();
        }

        private void BindGrid()
        {
            gvCategories.DataSource = svc.GetAll();
            gvCategories.DataBind();
        }

        protected void BtnShowAdd_Click(object sender, EventArgs e)
        {
            hidId.Value = "";
            txtName.Text = txtDescription.Text = "";
            litFormTitle.Text = "新增分类";
            pnlForm.Visible = true;
        }

        protected void GvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            var id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditItem")
            {
                var c = svc.GetById(id);
                hidId.Value = c.id.ToString();
                txtName.Text = c.name;
                txtDescription.Text = c.description;
                litFormTitle.Text = "编辑分类";
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
            var cat = new Category
            {
                name = txtName.Text,
                description = txtDescription.Text
            };

            if (string.IsNullOrEmpty(hidId.Value))
                svc.Add(cat);
            else
            {
                cat.id = long.Parse(hidId.Value);
                svc.Update(cat);
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
