<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.Suppliers" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>供应商管理 - 超市进销存管理系统</title>
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
                    <h3>供应商列表</h3>
                    <a href="Suppliers/Edit.aspx" class="btn btn-primary">新增供应商</a>
                </div>
                <div style="margin-bottom:12px;">
                    <asp:TextBox ID="txtKeyword" runat="server" placeholder="搜索名称" style="width:200px;" />
                    <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-primary" OnClick="BtnSearch_Click" />
                </div>
                <asp:GridView ID="gvSuppliers" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table" GridLines="None"
                    OnRowCommand="GvSuppliers_RowCommand"
                    DataKeyNames="id">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="name" HeaderText="名称" />
                        <asp:BoundField DataField="contactPerson" HeaderText="联系人" />
                        <asp:BoundField DataField="phone" HeaderText="电话" />
                        <asp:BoundField DataField="email" HeaderText="邮箱" />
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <a href='Suppliers/Edit.aspx?id=<%# Eval("id") %>' class="btn btn-primary">编辑</a>
                                <asp:Button ID="btnDel" runat="server" Text="删除" CssClass="btn btn-danger" CommandName="DeleteItem" CommandArgument='<%# Eval("id") %>' />
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
