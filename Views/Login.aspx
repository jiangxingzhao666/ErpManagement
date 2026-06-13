<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Views.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>用户登录</title>
    <link rel="stylesheet" href="/Content/site.css" />
</head>
<body>
<form id="form1" runat="server">
    <div class="login-box">
        <h2>超市进销存管理系统</h2>
        <div id="alert" class="alert alert-error" runat="server" visible="false"></div>
        <div class="form-group">
            <label>用户名</label>
            <asp:TextBox ID="txtUsername" runat="server" />
        </div>
        <div class="form-group">
            <label>密码</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
        </div>
        <asp:Button ID="btnLogin" runat="server" Text="登 录" CssClass="btn btn-primary" OnClick="BtnLogin_Click" />
    </div>
</form>
</body>
</html>
