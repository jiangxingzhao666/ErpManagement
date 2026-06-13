<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.Shipments" MaintainScrollPositionOnPostback="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>快递管理 - 超市进销存管理系统</title>
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
                <div style="display:flex;justify-content:space-between;align-items:center;">
                    <h3>快递管理</h3>
                </div>
                <asp:GridView ID="gvShipments" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table" GridLines="None"
                    OnRowCommand="GvShipments_RowCommand"
                    DataKeyNames="id">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="trackingNumber" HeaderText="快递单号" />
                        <asp:TemplateField HeaderText="销售单号">
                            <ItemTemplate><%# ((Entities.Shipment)Container.DataItem).salesOrder?.orderNo %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="客户">
                            <ItemTemplate><%# ((Entities.Shipment)Container.DataItem).salesOrder?.customer?.name ?? "散客" %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="carrier" HeaderText="快递公司" />
                        <asp:BoundField DataField="recipientName" HeaderText="收件人" />
                        <asp:BoundField DataField="recipientPhone" HeaderText="电话" />
                        <asp:BoundField DataField="shippingFee" HeaderText="运费" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="status" HeaderText="状态" />
                        <asp:BoundField DataField="createdAt" HeaderText="创建时间" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <a href='Edit.aspx?id=<%# Eval("id") %>' class="btn btn-primary">详情</a>
                                <asp:Button ID="btnShip" runat="server" Text="发货" CssClass="btn btn-primary" CommandName="Ship" CommandArgument='<%# Eval("id") %>' Visible='<%# Eval("status").ToString() == "待发货" %>' />
                                <asp:Button ID="btnSign" runat="server" Text="签收" CssClass="btn btn-primary" CommandName="Sign" CommandArgument='<%# Eval("id") %>' Visible='<%# Eval("status").ToString() == "运输中" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</form>
</body>
</html>
