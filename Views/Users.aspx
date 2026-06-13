<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Users.aspx.cs" Inherits="Views.Users" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>用户管理</title>
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
                    <h3>用户管理</h3>
                    <asp:Button ID="btnShowAdd" runat="server" Text="新增用户" CssClass="btn btn-primary" OnClick="BtnShowAdd_Click" />
                </div>

                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False"
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
                                <%# ((Entities.User)Container.DataItem).isActive ? "<span class='tag tag-ok'>正常</span>" : "<span class='tag tag-danger'>已禁用</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="lastLoginAt" HeaderText="最后登录" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <asp:Button ID="btnEdit" runat="server" Text="编辑" CssClass="btn btn-primary" CommandName="EditItem" CommandArgument='<%# Eval("id") %>' />
                                <asp:Button ID="btnDel" runat="server" Text="禁用" CssClass="btn btn-danger" CommandName="DeleteItem" CommandArgument='<%# Eval("id") %>' Visible='<%# Eval("isActive") %>' OnClientClick="return confirm('确定禁用？')" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <asp:Panel ID="pnlForm" runat="server" Visible="false">
            <div class="card">
                <h3><asp:Literal ID="litFormTitle" runat="server" /></h3>
                <asp:HiddenField ID="hidId" runat="server" />
                <div class="form-group"><label>用户名</label><asp:TextBox ID="txtUsername" runat="server" /></div>
                <div class="form-group"><label>密码</label><asp:TextBox ID="txtPassword" runat="server" /></div>
                <div class="form-group"><label>显示名</label><asp:TextBox ID="txtDisplayName" runat="server" /></div>
                <div class="form-group"><label>角色</label>
                    <asp:DropDownList ID="ddlRole" runat="server">
                        <asp:ListItem Value="操作员" Text="操作员" />
                        <asp:ListItem Value="店长" Text="店长" />
                        <asp:ListItem Value="管理员" Text="管理员" />
                    </asp:DropDownList>
                </div>
                <div>
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn" OnClick="BtnCancel_Click" />
                </div>
            </div>
            </asp:Panel>
        </div>
    </div>

</form>
</body>
</html>
