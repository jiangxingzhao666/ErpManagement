<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Suppliers.aspx.cs" Inherits="Views.Suppliers" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>供应商管理</title>
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
                    <h3>供应商管理</h3>
                    <asp:Button ID="btnShowAdd" runat="server" Text="新增供应商" CssClass="btn btn-primary" OnClick="BtnShowAdd_Click" />
                </div>

                <div style="margin-bottom:12px;">
                    <asp:TextBox ID="txtKeyword" runat="server" placeholder="搜索供应商名称" style="width:240px;" />
                    <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-primary" OnClick="BtnSearch_Click" />
                </div>

                <asp:GridView ID="gvSuppliers" runat="server" AutoGenerateColumns="False"
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
                                <asp:Button ID="btnEdit" runat="server" Text="编辑" CssClass="btn btn-primary" CommandName="EditItem" CommandArgument='<%# Eval("id") %>' />
                                <asp:Button ID="btnDel" runat="server" Text="删除" CssClass="btn btn-danger" CommandName="DeleteItem" CommandArgument='<%# Eval("id") %>' OnClientClick="return confirm('确定删除？')" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <asp:Panel ID="pnlForm" runat="server" Visible="false">
            <div class="card">
                <h3><asp:Literal ID="litFormTitle" runat="server" /></h3>
                <asp:HiddenField ID="hidId" runat="server" />
                <div class="form-group"><label>名称</label><asp:TextBox ID="txtName" runat="server" /></div>
                <div class="form-group"><label>联系人</label><asp:TextBox ID="txtContact" runat="server" /></div>
                <div class="form-group"><label>电话</label><asp:TextBox ID="txtPhone" runat="server" /></div>
                <div class="form-group"><label>邮箱</label><asp:TextBox ID="txtEmail" runat="server" /></div>
                <div class="form-group"><label>地址</label><asp:TextBox ID="txtAddress" runat="server" /></div>
                <div class="form-group"><label>备注</label><asp:TextBox ID="txtRemark" runat="server" TextMode="MultiLine" Rows="3" /></div>
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
