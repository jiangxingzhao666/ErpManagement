using System;
using System.Web.UI;
using Services;

namespace Views
{
    public partial class Shipments : Page
    {
        private ShipmentService svc = new ShipmentService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireLogin();
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("shipments", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                BindGrid();
        }

        private void BindGrid()
        {
            gvShipments.DataSource = svc.GetAll(1, 200);
            gvShipments.DataBind();
        }

        protected void GvShipments_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Header") return;
            var id = int.Parse(e.CommandArgument.ToString());

            if (e.CommandName == "Ship")
            {
                svc.UpdateStatus(id, "运输中");
                BindGrid();
            }
            else if (e.CommandName == "Sign")
            {
                svc.UpdateStatus(id, "已签收");
                BindGrid();
            }
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("../Products/Default.aspx");
        }
    }
}
