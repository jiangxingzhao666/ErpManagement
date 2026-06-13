<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Views.ShipmentEdit" MaintainScrollPositionOnPostback="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>快递编辑 - 超市进销存管理系统</title>
    <link rel="stylesheet" href="/Content/site.css" />
</head>
<body>
<form id="form1" runat="server">
    <div class="header">
        <div class="logo">超市进销存管理系统</div>
        <div class="user-info">
            <asp:Panel ID="pnlLoggedIn" runat="server" Visible="false">
                <asp:Literal ID="litUserInfo" runat="server" />
                <asp:Button ID="btnLogout" runat="server" Text="退出" CssClass="btn-logout" OnClick="BtnLogout_Click" />
            </asp:Panel>
        </div>
    </div>
    <div class="layout">
        <div class="sidebar" id="sidebar" runat="server"></div>
        <div class="main">
            <div class="card">
                <h3><asp:Literal ID="litFormTitle" runat="server" /></h3>
                <asp:HiddenField ID="hidId" runat="server" />
                <asp:HiddenField ID="hidSalesOrderId" runat="server" />

                <div class="form-group">
                    <label>关联销售单号</label>
                    <asp:Literal ID="litOrderNo" runat="server" />
                </div>
                <div class="form-group">
                    <label>销售金额</label>
                    <asp:Literal ID="litOrderAmount" runat="server" />
                </div>

                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="flex:1;min-width:160px;">
                        <label>快递单号</label>
                        <asp:Literal ID="litTrackingNo" runat="server" />
                    </div>
                    <div class="form-group" style="flex:1;min-width:160px;">
                        <label>快递公司</label>
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
                </div>

                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="flex:2;min-width:160px;">
                        <label>收件人</label>
                        <asp:TextBox ID="txtRecipientName" runat="server" />
                    </div>
                    <div class="form-group" style="flex:1;min-width:140px;">
                        <label>电话</label>
                        <asp:TextBox ID="txtRecipientPhone" runat="server" />
                    </div>
                </div>

                <div class="form-group">
                    <label>收件地址</label>
                    <asp:TextBox ID="txtRecipientAddress" runat="server" TextMode="MultiLine" Rows="2" />
                </div>

                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="max-width:140px;">
                        <label>运费 (¥)</label>
                        <asp:TextBox ID="txtShippingFee" runat="server" TextMode="Number" Text="0" step="0.01" />
                    </div>
                    <div class="form-group" style="max-width:160px;">
                        <label>状态</label>
                        <asp:DropDownList ID="ddlStatus" runat="server">
                            <asp:ListItem Value="待发货" Text="待发货" />
                            <asp:ListItem Value="运输中" Text="运输中" />
                            <asp:ListItem Value="已签收" Text="已签收" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="form-group">
                    <label>备注</label>
                    <asp:TextBox ID="txtRemark" runat="server" TextMode="MultiLine" Rows="2" />
                </div>

                <div>
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                    <a href="Default.aspx" class="btn" style="margin-left:8px;">返回列表</a>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
