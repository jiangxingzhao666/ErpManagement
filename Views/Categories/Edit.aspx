<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Views.CategoryEdit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>分类编辑 - 超市进销存管理系统</title>
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
                <div class="form-group">
                    <label>名称</label>
                    <asp:TextBox ID="txtName" runat="server" />
                </div>
                <div class="form-group">
                    <label>描述</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="2" />
                </div>
                <div>
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                    <a href="../Categories/Default.aspx" class="btn" style="margin-left:8px;">取消</a>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
