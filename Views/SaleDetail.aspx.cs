using System;
using System.Web.UI;
using Services;

namespace Views
{
    public partial class SaleDetail : Page
    {
        private SalesService saleSvc = new SalesService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireRole("管理员,店长");
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("sales", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
            {
                string idStr = Request.QueryString["id"];
                if (string.IsNullOrEmpty(idStr))
                {
                    Response.Redirect("Sales.aspx");
                    return;
                }

                var order = saleSvc.GetById(int.Parse(idStr));
                litDetailTitle.Text = "销售单详情 - " + order.orderNo;
                litDetailCustomer.Text = order.customer?.name ?? "散客";
                litDetailPay.Text = order.paymentMethod;
                litDetailAmount.Text = order.actualAmount.ToString("F2");
                gvItems.DataSource = order.items;
                gvItems.DataBind();
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("Default.aspx");
        }
    }
}
