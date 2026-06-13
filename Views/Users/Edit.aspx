<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Views.UserEdit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>用户编辑 - 超市进销存管理系统</title>
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
            <asp:Literal ID="litMsg" runat="server" />
            <div class="card">
                <h3><asp:Literal ID="litFormTitle" runat="server" /></h3>
                <asp:HiddenField ID="hidId" runat="server" />
                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="flex:1;min-width:180px;">
                        <label>用户名</label>
                        <asp:TextBox ID="txtUsername" runat="server" />
                    </div>
                    <div class="form-group" style="flex:1;min-width:180px;">
                        <label>显示名</label>
                        <asp:TextBox ID="txtDisplayName" runat="server" />
                    </div>
                </div>
                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="flex:1;min-width:180px;">
                        <label>密码</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                    </div>
                    <div class="form-group" style="flex:1;min-width:180px;">
                        <label>角色</label>
                        <asp:DropDownList ID="ddlRole" runat="server">
                            <asp:ListItem Value="操作员" Text="操作员" />
                            <asp:ListItem Value="店长" Text="店长" />
                            <asp:ListItem Value="管理员" Text="管理员" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div>
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                    <a href="../Users/Default.aspx" class="btn" style="margin-left:8px;">取消</a>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
