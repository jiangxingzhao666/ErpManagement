using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Services;
using Entities;

namespace Views
{
    public partial class ShipmentEdit : Page
    {
        private ShipmentService shipSvc = new ShipmentService();
        private SalesService saleSvc = new SalesService();

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.AuthHelper.RequireLogin();
            var role = Helpers.AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("shipments", role);
            litUserInfo.Text = Helpers.AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
            {
                string idStr = Request.QueryString["id"];
                string orderIdStr = Request.QueryString["orderId"];

                if (!string.IsNullOrEmpty(idStr))
                {
                    var ship = shipSvc.GetById(int.Parse(idStr));
                    LoadShipment(ship);
                }
                else if (!string.IsNullOrEmpty(orderIdStr))
                {
                    var orderId = long.Parse(orderIdStr);
                    var existing = shipSvc.GetBySalesOrderId(orderId);
                    if (existing != null)
                    {
                        LoadShipment(existing);
                    }
                    else
                    {
                        hidSalesOrderId.Value = orderIdStr;
                        var order = saleSvc.GetById((int)orderId);
                        litOrderNo.Text = order.orderNo;
                        litOrderAmount.Text = "¥" + order.actualAmount.ToString("F2");
                        litTrackingNo.Text = "自动生成";
                        litFormTitle.Text = "新建快递 - " + order.orderNo;
                    }
                }
            }
        }

        private void LoadShipment(Shipment ship)
        {
            hidId.Value = ship.id.ToString();
            hidSalesOrderId.Value = ship.salesOrderId.ToString();
            litOrderNo.Text = ship.salesOrder?.orderNo;
            litOrderAmount.Text = "¥" + ship.salesOrder?.actualAmount.ToString("F2");
            litTrackingNo.Text = ship.trackingNumber;
            ddlCarrier.SelectedValue = ship.carrier;
            txtRecipientName.Text = ship.recipientName;
            txtRecipientPhone.Text = ship.recipientPhone;
            txtRecipientAddress.Text = ship.recipientAddress;
            txtShippingFee.Text = ship.shippingFee.ToString();
            ddlStatus.SelectedValue = ship.status;
            txtRemark.Text = ship.remark;
            litFormTitle.Text = "快递详情 - " + ship.trackingNumber;
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hidId.Value))
            {
                var ship = new Shipment
                {
                    salesOrderId = long.Parse(hidSalesOrderId.Value),
                    carrier = ddlCarrier.SelectedValue,
                    recipientName = txtRecipientName.Text,
                    recipientPhone = txtRecipientPhone.Text,
                    recipientAddress = txtRecipientAddress.Text,
                    shippingFee = decimal.Parse(string.IsNullOrEmpty(txtShippingFee.Text) ? "0" : txtShippingFee.Text),
                    remark = txtRemark.Text
                };
                shipSvc.Add(ship);
            }
            else
            {
                var ship = new Shipment
                {
                    id = long.Parse(hidId.Value),
                    carrier = ddlCarrier.SelectedValue,
                    recipientName = txtRecipientName.Text,
                    recipientPhone = txtRecipientPhone.Text,
                    recipientAddress = txtRecipientAddress.Text,
                    shippingFee = decimal.Parse(string.IsNullOrEmpty(txtShippingFee.Text) ? "0" : txtShippingFee.Text),
                    status = ddlStatus.SelectedValue,
                    remark = txtRemark.Text
                };
                shipSvc.Update(ship);
            }

            Response.Redirect("Default.aspx");
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            Helpers.AuthHelper.Logout();
            Response.Redirect("../Products/Default.aspx");
        }
    }
}
