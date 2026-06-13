using System;
using System.Web.UI;
using Services;
using Entities;

namespace Views
{
    public partial class ShipmentPublic : Page
    {
        private ShipmentService shipSvc = new ShipmentService();
        private SalesService saleSvc = new SalesService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string orderIdStr = Request.QueryString["orderId"];
                if (string.IsNullOrEmpty(orderIdStr))
                {
                    Response.Redirect("Default.aspx");
                    return;
                }

                var orderId = long.Parse(orderIdStr);
                var existing = shipSvc.GetBySalesOrderId(orderId);
                if (existing != null)
                {
                    litHeadTitle.Text = "快递已创建";
                    pnlForm.Visible = false;
                    pnlSuccess.Visible = true;
                    litOrderNo.Text = existing.salesOrder?.orderNo ?? "";
                    litOrderAmount.Text = "¥" + existing.salesOrder?.actualAmount.ToString("F2");
                    litTrackingNo.Text = existing.trackingNumber;
                    return;
                }

                hidSalesOrderId.Value = orderIdStr;
                var order = saleSvc.GetById((int)orderId);
                if (order == null)
                {
                    Response.Redirect("Default.aspx");
                    return;
                }

                litHeadTitle.Text = "填写快递信息";
                litOrderNo.Text = order.orderNo;
                litOrderAmount.Text = "¥" + order.actualAmount.ToString("F2");
            }
        }

        protected void BtnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtRecipientName.Text.Trim()))
                return;

            var ship = new Shipment
            {
                salesOrderId = long.Parse(hidSalesOrderId.Value),
                carrier = ddlCarrier.SelectedValue,
                recipientName = txtRecipientName.Text.Trim(),
                recipientPhone = txtRecipientPhone.Text.Trim(),
                recipientAddress = txtRecipientAddress.Text.Trim(),
                shippingFee = decimal.Parse(string.IsNullOrEmpty(txtShippingFee.Text) ? "0" : txtShippingFee.Text),
                remark = txtRemark.Text.Trim()
            };

            shipSvc.Add(ship);

            pnlForm.Visible = false;
            pnlSuccess.Visible = true;
            litTrackingNo.Text = ship.trackingNumber;
            litHeadTitle.Text = "提交成功";
        }
    }
}
