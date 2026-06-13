<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Detail.aspx.cs" Inherits="Views.SaleDetail" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>销售单详情 - 超市进销存管理系统</title>
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
                <h3><asp:Literal ID="litDetailTitle" runat="server" /></h3>
                <div style="margin:12px 0;">
                    <b>客户：</b><asp:Literal ID="litDetailCustomer" runat="server" />
                    <span style="margin-left:20px;"><b>支付：</b><asp:Literal ID="litDetailPay" runat="server" /></span>
                    <span style="margin-left:20px;"><b>实收：</b><asp:Literal ID="litDetailAmount" runat="server" /></span>
                </div>
                <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="False" CssClass="table" GridLines="None">
                    <Columns>
                        <asp:TemplateField HeaderText="商品"><ItemTemplate><%# ((Entities.SalesOrderItem)Container.DataItem).product?.name %></ItemTemplate></asp:TemplateField>
                        <asp:BoundField DataField="quantity" HeaderText="数量" />
                        <asp:BoundField DataField="unitPrice" HeaderText="单价" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="subTotal" HeaderText="小计" DataFormatString="{0:F2}" />
                    </Columns>
                </asp:GridView>
                <a href="../Sales/Default.aspx" class="btn" style="margin-top:12px;">返回</a>
            </div>
        </div>
    </div>
</form>
</body>
</html>
