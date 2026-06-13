using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;
using Entities;

namespace Views
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireLogin();
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("products", role);

            if (Helpers.AuthHelper.IsLogin())
            {
                pnlLoggedIn.Visible = true;
                pnlLoggedOut.Visible = false;
                litUserInfo.Text = Helpers.AuthHelper.GetDisplayName()
                    + " (" + role + ")";
            }
            else
            {
                pnlLoggedIn.Visible = false;
                pnlLoggedOut.Visible = true;
            }

            if (!IsPostBack)
                LoadData();
        }

        private void LoadData()
        {
            var prodSvc = new ProductService();
            var supSvc = new SupplierService();
            var cusSvc = new CustomerService();

            bool showDeleted = Helpers.AuthHelper.CanSeeDeleted();
            long? categoryId = null;
            if (!string.IsNullOrEmpty(ddlCatFilter.SelectedValue))
                categoryId = long.Parse(ddlCatFilter.SelectedValue);

            var products = prodSvc.GetAll(txtKeyword.Text.Trim(), categoryId, 1, 1000, showDeleted);
            var alerts = prodSvc.GetStockAlerts();

            gvProducts.DataSource = products;
            gvProducts.DataBind();

            litTotalProducts.Text = products.Count.ToString();
            litTotalSuppliers.Text = supSvc.GetAll(null, 1, 1000).Count.ToString();
            litTotalCustomers.Text = cusSvc.GetAll(null, 1, 1000).Count.ToString();
            litStockAlerts.Text = alerts.Count.ToString();

            BindCategoryFilter();
        }

        private void BindCategoryFilter()
        {
            var catSvc = new CategoryService();
            var cats = catSvc.GetAll();
            ddlCatFilter.DataSource = cats;
            ddlCatFilter.DataTextField = "name";
            ddlCatFilter.DataValueField = "id";
            ddlCatFilter.DataBind();
            ddlCatFilter.Items.Insert(0, new ListItem("全部分类", ""));
        }

        private void BindFormDropdowns()
        {
            var catSvc = new CategoryService();
            ddlCategory.DataSource = catSvc.GetAll();
            ddlCategory.DataTextField = "name";
            ddlCategory.DataValueField = "id";
            ddlCategory.DataBind();

            var supSvc = new SupplierService();
            var sups = supSvc.GetAllSimple();
            ddlSupplier.DataSource = sups;
            ddlSupplier.DataTextField = "name";
            ddlSupplier.DataValueField = "id";
            ddlSupplier.DataBind();
            ddlSupplier.Items.Insert(0, new ListItem("不选", ""));
        }

        protected void BtnSearch_Click(object sender, EventArgs e) { LoadData(); }

        protected void GvProducts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                var row = (Product)e.Row.DataItem;
                var litStock = (Literal)e.Row.FindControl("litStock");
                var litStatus = (Literal)e.Row.FindControl("litStatus");

                litStock.Text = row.stockQuantity.ToString();

                if (!row.isActive)
                {
                    litStatus.Text = "<span class='tag tag-danger'>已删除</span>";
                    e.Row.Style.Add("opacity", "0.5");
                }
                else if (row.stockQuantity <= row.minStock)
                {
                    litStock.Text += " <span class='tag tag-warn'>低库存</span>";
                    litStatus.Text = "<span class='tag tag-warn'>预警</span>";
                }
                else
                {
                    litStatus.Text = "<span class='tag tag-ok'>正常</span>";
                }
            }
        }

        protected void GvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Header") return;
            var id = long.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "EditItem")
            {
                var prodSvc = new ProductService();
                var p = prodSvc.GetById((int)id);
                BindFormDropdowns();

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

                litFormTitle.Text = "编辑商品";
                pnlForm.Visible = true;
            }
            else if (e.CommandName == "DeleteItem")
            {
                var prodSvc = new ProductService();
                prodSvc.Delete((int)id);
                LoadData();
            }
        }

        protected void BtnShowAdd_Click(object sender, EventArgs e)
        {
            BindFormDropdowns();
            hidId.Value = "";
            txtCode.Text = txtName.Text = txtUnit.Text = txtDescription.Text = "";
            txtPurchasePrice.Text = txtSellingPrice.Text = txtStock.Text = "0";
            txtMinStock.Text = "10";
            litFormTitle.Text = "新增商品";
            pnlForm.Visible = true;
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
                description = txtDescription.Text
            };

            var prodSvc = new ProductService();
            if (string.IsNullOrEmpty(hidId.Value))
            {
                prodSvc.Add(prod);
            }
            else
            {
                prod.id = long.Parse(hidId.Value);
                prodSvc.Update(prod);
            }

            pnlForm.Visible = false;
            LoadData();
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
