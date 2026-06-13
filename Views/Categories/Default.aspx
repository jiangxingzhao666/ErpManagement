<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.Categories" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>分类管理 - 超市进销存管理系统</title>
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
                    <h3>分类列表</h3>
                    <a href="Categories/Edit.aspx" class="btn btn-primary">新增分类</a>
                </div>
                <asp:GridView ID="gvCategories" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table" GridLines="None"
                    OnRowCommand="GvCategories_RowCommand"
                    DataKeyNames="id">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="name" HeaderText="名称" />
                        <asp:BoundField DataField="description" HeaderText="描述" />
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <a href='Categories/Edit.aspx?id=<%# Eval("id") %>' class="btn btn-primary">编辑</a>
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
