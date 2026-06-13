using System;
using System.IO;
using System.Web.UI;
using Services;
using Entities;

namespace Views
{
    public partial class ProductEdit : Page
    {
        private ProductService prodSvc = new ProductService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("products", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
            {
                BindDropdowns();

                string idStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idStr))
                {
                    var p = prodSvc.GetById(int.Parse(idStr));
                    hidId.Value = p.id.ToString();
                    txtCode.Text = p.code;
                    txtName.Text = p.name;
                    if (p.categoryId > 0) ddlCategory.SelectedValue = p.categoryId.ToString();
                    if (p.supplierId.HasValue && p.supplierId > 0) ddlSupplier.SelectedValue = p.supplierId.Value.ToString();
                    txtUnit.Text = p.unit;
                    txtPurchasePrice.Text = p.purchasePrice.ToString();
                    txtSellingPrice.Text = p.sellingPrice.ToString();
                    txtStock.Text = p.stockQuantity.ToString();
                    txtMinStock.Text = p.minStock.ToString();
                    txtDescription.Text = p.description;

                    if (!string.IsNullOrEmpty(p.imagePath))
                    {
                        imgPreview.ImageUrl = p.imagePath;
                        imgPreview.Visible = true;
                        hidOldImagePath.Value = p.imagePath;
                        chkDelImage.Visible = true;
                    }

                    litFormTitle.Text = "编辑商品";
                }
                else
                {
                    litFormTitle.Text = "新增商品";
                }
            }
        }

        private void BindDropdowns()
        {
            var catSvc = new CategoryService();
            ddlCategory.DataSource = catSvc.GetAll();
            ddlCategory.DataTextField = "name";
            ddlCategory.DataValueField = "id";
            ddlCategory.DataBind();

            var supSvc = new SupplierService();
            ddlSupplier.DataSource = supSvc.GetAllSimple();
            ddlSupplier.DataTextField = "name";
            ddlSupplier.DataValueField = "id";
            ddlSupplier.DataBind();
            ddlSupplier.Items.Insert(0, new System.Web.UI.WebControls.ListItem("不选", ""));
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            var prod = new Product
            {
                code = txtCode.Text,
                name = txtName.Text,
                categoryId = long.Parse(ddlCategory.SelectedValue),
                supplierId = string.IsNullOrEmpty(ddlSupplier.SelectedValue) ? (long?)null : long.Parse(ddlSupplier.SelectedValue),
                unit = txtUnit.Text,
                purchasePrice = decimal.Parse(txtPurchasePrice.Text),
                sellingPrice = decimal.Parse(txtSellingPrice.Text),
                stockQuantity = int.Parse(txtStock.Text),
                minStock = int.Parse(txtMinStock.Text),
                description = txtDescription.Text,
                imagePath = HandleImageUpload()
            };

            if (string.IsNullOrEmpty(hidId.Value))
                prodSvc.Add(prod);
            else
            {
                prod.id = long.Parse(hidId.Value);
                prodSvc.Update(prod);
            }

            Response.Redirect("../Products/Default.aspx");
        }

        private string HandleImageUpload()
        {
            bool deleteImage = chkDelImage.Checked;
            string oldPath = hidOldImagePath.Value;

            if (deleteImage)
            {
                DeleteImageFile(oldPath);
                return "";
            }

            if (fuImage.HasFile)
            {
                string ext = Path.GetExtension(fuImage.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".svg")
                    return oldPath;

                string dir = Server.MapPath("~/Content/images/products/");
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);

                string fileName = "prod_" + DateTime.Now.Ticks + ext;
                fuImage.SaveAs(Path.Combine(dir, fileName));

                DeleteImageFile(oldPath);

                return "~/Content/images/products/" + fileName;
            }

            return oldPath;
        }

        private void DeleteImageFile(string path)
        {
            if (!string.IsNullOrEmpty(path))
            {
                string fullPath = Server.MapPath(path);
                if (File.Exists(fullPath))
                    File.Delete(fullPath);
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("../Products/Default.aspx");
        }
    }
}
