<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.Sales" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>销售管理 - 超市进销存管理系统</title>
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
                    <h3>销售单列表</h3>
                    <a href="Sales/Create.aspx" class="btn btn-primary">新建销售单</a>
                </div>
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False"
                    CssClass="table" GridLines="None"
                    DataKeyNames="id">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="orderNo" HeaderText="单号" />
                        <asp:TemplateField HeaderText="客户">
                            <ItemTemplate><%# ((Entities.SalesOrder)Container.DataItem).customer?.name ?? "散客" %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="totalAmount" HeaderText="总金额" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="discountAmount" HeaderText="优惠" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="actualAmount" HeaderText="实收" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="paymentMethod" HeaderText="支付方式" />
                        <asp:BoundField DataField="createdAt" HeaderText="时间" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <a href='Sales/Detail.aspx?id=<%# Eval("id") %>' class="btn btn-primary">详情</a>
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
