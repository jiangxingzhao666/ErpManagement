<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Views.CustomerEdit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>客户编辑 - 超市进销存管理系统</title>
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
                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="flex:2;min-width:200px;">
                        <label>名称</label>
                        <asp:TextBox ID="txtName" runat="server" />
                    </div>
                    <div class="form-group" style="flex:1;min-width:160px;">
                        <label>等级</label>
                        <asp:DropDownList ID="ddlLevel" runat="server">
                            <asp:ListItem Value="普通" Text="普通" />
                            <asp:ListItem Value="银卡" Text="银卡" />
                            <asp:ListItem Value="金卡" Text="金卡" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="flex:1;min-width:160px;">
                        <label>电话</label>
                        <asp:TextBox ID="txtPhone" runat="server" />
                    </div>
                    <div class="form-group" style="flex:1;min-width:160px;">
                        <label>邮箱</label>
                        <asp:TextBox ID="txtEmail" runat="server" />
                    </div>
                </div>
                <div class="form-group">
                    <label>地址</label>
                    <asp:TextBox ID="txtAddress" runat="server" />
                </div>
                <div>
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                    <a href="../Customers/Default.aspx" class="btn" style="margin-left:8px;">取消</a>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
