using System;
using System.Web.UI;
using Services;
using Entities;

namespace Views
{
    public partial class CategoryEdit : Page
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
            {
                string idStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idStr))
                {
                    var cat = svc.GetById(int.Parse(idStr));
                    hidId.Value = cat.id.ToString();
                    txtName.Text = cat.name;
                    txtDescription.Text = cat.description;
                    litFormTitle.Text = "编辑分类";
                }
                else
                {
                    litFormTitle.Text = "新增分类";
                }
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

            Response.Redirect("Categories/Default.aspx");
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
