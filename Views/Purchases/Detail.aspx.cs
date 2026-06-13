using System;
using System.Web.UI;
using Services;

namespace Views
{
    public partial class PurchaseDetail : Page
    {
        private PurchaseService purSvc = new PurchaseService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("purchases", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
            {
                string idStr = Request.QueryString["id"];
                if (string.IsNullOrEmpty(idStr))
                {
                    Response.Redirect("Purchases/Default.aspx");
                    return;
                }

                var order = purSvc.GetById(int.Parse(idStr));
                litDetailTitle.Text = "进货单详情 - " + order.orderNo;
                litDetailSupplier.Text = order.supplier?.name;
                litDetailStatus.Text = order.status;
                litDetailAmount.Text = order.totalAmount.ToString("F2");
                gvItems.DataSource = order.items;
                gvItems.DataBind();
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Products/Default.aspx");
        }
    }
}
