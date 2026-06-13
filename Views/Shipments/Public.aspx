<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Public.aspx.cs" Inherits="Views.ShipmentPublic" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>填写快递信息 - 便民超市</title>
    <style>
        :root {
            --primary: #0d9488;
            --primary-dark: #0f766e;
            --text: #333;
            --text-light: #777;
            --border: #ddd;
            --bg: #f7f7f7;
            --white: #fff;
            --radius: 8px;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif; background: linear-gradient(135deg, #0d9488, #0f766e); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .container { background: var(--white); border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,.2); width: 100%; max-width: 520px; overflow: hidden; }
        .head { background: linear-gradient(135deg, #0d9488, #0f766e); color: #fff; padding: 28px 32px; text-align: center; }
        .head h1 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
        .head p { font-size: 13px; opacity: .85; }
        .body { padding: 28px 32px; }
        .order-info { background: #f8f9fa; border-radius: var(--radius); padding: 14px 16px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        .order-info .label { font-size: 12px; color: var(--text-light); }
        .order-info .value { font-size: 16px; font-weight: 700; color: var(--primary); }
        .form-row { margin-bottom: 16px; }
        .form-row label { display: block; font-size: 13px; font-weight: 600; color: var(--text); margin-bottom: 6px; }
        .form-row label .req { color: var(--primary); }
        .form-row input, .form-row select, .form-row textarea { width: 100%; padding: 10px 14px; border: 2px solid var(--border); border-radius: var(--radius); font-size: 14px; font-family: inherit; transition: border .2s; }
        .form-row input:focus, .form-row select:focus, .form-row textarea:focus { border-color: var(--primary); outline: none; }
        .form-row textarea { resize: vertical; min-height: 60px; }
        .form-inline { display: flex; gap: 12px; }
        .form-inline > div { flex: 1; }
        .form-row label .req { color: var(--primary); font-size: 1.2em; font-weight: 700; }
        .form-row input:required, .form-row textarea.required { border-color: var(--primary); background: #f0fdfa; }
        .form-row input:required:focus, .form-row textarea.required:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(13,148,136,.15); }
        .form-row .hint { font-size: 11px; color: #999; margin-top: 2px; }
        .btn-submit { width: 100%; padding: 13px; background: linear-gradient(135deg, #0d9488, #0f766e); color: #fff; border: none; border-radius: var(--radius); font-size: 16px; font-weight: 600; cursor: pointer; transition: opacity .2s; margin-top: 8px; }
        .btn-submit:hover { opacity: .9; }
        .btn-skip { display: block; text-align: center; margin-top: 14px; color: #999; font-size: 13px; text-decoration: none; }
        .btn-skip:hover { color: var(--primary); }
        .tracking { background: #e8f5e9; border-radius: var(--radius); padding: 12px 16px; margin-bottom: 20px; font-size: 14px; color: #2e7d32; text-align: center; }
        .tracking b { font-size: 16px; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="container">
        <div class="head">
            <h1><asp:Literal ID="litHeadTitle" runat="server" /></h1>
            <p>请填写收货信息，我们将尽快为您发货</p>
        </div>
        <div class="body">
            <asp:HiddenField ID="hidSalesOrderId" runat="server" />

            <div class="order-info">
                <div>
                    <div class="label">订单号</div>
                    <div class="value"><asp:Literal ID="litOrderNo" runat="server" /></div>
                </div>
                <div style="text-align:right;">
                    <div class="label">金额</div>
                    <div class="value"><asp:Literal ID="litOrderAmount" runat="server" /></div>
                </div>
            </div>

            <asp:Panel ID="pnlForm" runat="server">
            <div class="form-inline">
                <div class="form-row">
                    <label><span class="req">*</span> <b>收件人</b></label>
                    <asp:TextBox ID="txtRecipientName" runat="server" placeholder="请填写收货人姓名" />
                </div>
                <div class="form-row">
                    <label><span class="req">*</span> <b>电话</b></label>
                    <asp:TextBox ID="txtRecipientPhone" runat="server" placeholder="请填写手机号" />
                    <div class="hint">用于快递员联系您</div>
                </div>
            </div>
            <div class="form-row">
                <label><span class="req">*</span> <b>收件地址</b></label>
                <asp:TextBox ID="txtRecipientAddress" runat="server" TextMode="MultiLine" Rows="2" placeholder="请填写省/市/区/详细地址" />
                <div class="hint">请确保地址准确，以免影响配送</div>
            <div class="form-inline">
                <div class="form-row">
                    <label>快递公司 <span style="color:#999;font-weight:400;font-size:11px;">(选填)</span></label>
                    <asp:DropDownList ID="ddlCarrier" runat="server">
                        <asp:ListItem Value="顺丰快递" Text="顺丰快递" />
                        <asp:ListItem Value="中通快递" Text="中通快递" />
                        <asp:ListItem Value="圆通快递" Text="圆通快递" />
                        <asp:ListItem Value="韵达快递" Text="韵达快递" />
                        <asp:ListItem Value="申通快递" Text="申通快递" />
                        <asp:ListItem Value="京东物流" Text="京东物流" />
                        <asp:ListItem Value="邮政EMS" Text="邮政EMS" />
                    </asp:DropDownList>
                </div>
                <div class="form-row">
                    <label>运费 ¥ <span style="color:#999;font-weight:400;font-size:11px;">(选填)</span></label>
                    <asp:TextBox ID="txtShippingFee" runat="server" TextMode="Number" Text="0" step="0.01" />
                </div>
            </div>
            <div class="form-row">
                <label>备注 <span style="color:#999;font-weight:400;font-size:11px;">(选填)</span></label>
                <asp:TextBox ID="txtRemark" runat="server" TextMode="MultiLine" Rows="1" placeholder="如有特殊要求请注明" />
            </div>
            <asp:Button ID="btnSubmit" runat="server" Text="提交快递单" CssClass="btn-submit" OnClick="BtnSubmit_Click" />
            </asp:Panel>

            <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                <div class="tracking" style="background:#e8f5e9;color:#2e7d32;">
                    快递单已创建<br/>
                    <b><asp:Literal ID="litTrackingNo" runat="server" /></b>
                </div>
                <p style="text-align:center;color:#666;font-size:13px;">我们将尽快为您发货，感谢您的惠顾！</p>
            </asp:Panel>

            <a href="../Store/Default.aspx" class="btn-skip">继续购物</a>
        </div>
    </div>
</form>
</body>
</html>
