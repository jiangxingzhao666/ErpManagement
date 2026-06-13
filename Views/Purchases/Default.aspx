<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.Purchases" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>进货管理 - 超市进销存管理系统</title>
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
                    <h3>进货单列表</h3>
                    <a href="../Purchases/Create.aspx" class="btn btn-primary">新建进货单</a>
                </div>
                <div style="margin-bottom:12px;">
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Value="" Text="全部" />
                        <asp:ListItem Value="待入库" Text="待入库" />
                        <asp:ListItem Value="已入库" Text="已入库" />
                        <asp:ListItem Value="已取消" Text="已取消" />
                    </asp:DropDownList>
                    <asp:Button ID="btnFilter" runat="server" Text="筛选" CssClass="btn btn-primary" OnClick="BtnFilter_Click" />
                </div>
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False"
                    CssClass="table" GridLines="None"
                    OnRowCommand="GvOrders_RowCommand"
                    DataKeyNames="id">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="orderNo" HeaderText="单号" />
                        <asp:TemplateField HeaderText="供应商">
                            <ItemTemplate><%# ((Entities.PurchaseOrder)Container.DataItem).supplier?.name %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="totalAmount" HeaderText="金额" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="status" HeaderText="状态" />
                        <asp:BoundField DataField="createdAt" HeaderText="创建时间" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <a href='../Purchases/Detail.aspx?id=<%# Eval("id") %>' class="btn btn-primary">详情</a>
                                <asp:Button ID="btnConfirm" runat="server" Text="入库" CssClass="btn btn-primary" CommandName="Confirm" CommandArgument='<%# Eval("id") %>' Visible='<%# Eval("status").ToString() == "待入库" %>' OnClientClick="return confirm('确认入库？库存将增加')" />
                                <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn btn-danger" CommandName="Cancel" CommandArgument='<%# Eval("id") %>' Visible='<%# Eval("status").ToString() == "待入库" %>' OnClientClick="return confirm('确定取消？')" />
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
