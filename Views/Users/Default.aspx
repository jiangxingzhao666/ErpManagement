<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.Users" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>用户管理 - 超市进销存管理系统</title>
    <link rel="stylesheet" href="../Content/site.css" />
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
                    <h3>用户列表</h3>
                    <a href="Users/Edit.aspx" class="btn btn-primary">新增用户</a>
                </div>
                <asp:GridView ID="gvUsers" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table" GridLines="None"
                    OnRowCommand="GvUsers_RowCommand"
                    OnRowDataBound="GvUsers_RowDataBound"
                    DataKeyNames="id">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="username" HeaderText="用户名" />
                        <asp:BoundField DataField="displayName" HeaderText="显示名" />
                        <asp:BoundField DataField="role" HeaderText="角色" />
                        <asp:TemplateField HeaderText="状态">
                            <ItemTemplate>
                                <asp:Literal ID="litStatus" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <asp:Button ID="btnEdit" runat="server" Text="编辑" CssClass="btn btn-primary" CommandName="EditItem" CommandArgument='<%# Eval("id") %>' />
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
