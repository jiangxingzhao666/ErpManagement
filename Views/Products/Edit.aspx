<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Views.ProductEdit" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>商品编辑 - 超市进销存管理系统</title>
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
                    <div class="form-group" style="flex:1;min-width:160px;">
                        <label>编号</label>
                        <asp:TextBox ID="txtCode" runat="server" />
                    </div>
                    <div class="form-group" style="flex:2;min-width:200px;">
                        <label>名称</label>
                        <asp:TextBox ID="txtName" runat="server" />
                    </div>
                </div>
                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="flex:1;min-width:160px;">
                        <label>分类</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" />
                    </div>
                    <div class="form-group" style="flex:1;min-width:160px;">
                        <label>供应商</label>
                        <asp:DropDownList ID="ddlSupplier" runat="server">
                            <asp:ListItem Value="" Text="不选" />
                        </asp:DropDownList>
                    </div>
                    <div class="form-group" style="max-width:100px;">
                        <label>单位</label>
                        <asp:TextBox ID="txtUnit" runat="server" />
                    </div>
                </div>
                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <div class="form-group" style="max-width:140px;">
                        <label>进价</label>
                        <asp:TextBox ID="txtPurchasePrice" runat="server" TextMode="Number" Text="0" step="0.01" />
                    </div>
                    <div class="form-group" style="max-width:140px;">
                        <label>售价</label>
                        <asp:TextBox ID="txtSellingPrice" runat="server" TextMode="Number" Text="0" step="0.01" />
                    </div>
                    <div class="form-group" style="max-width:100px;">
                        <label>库存</label>
                        <asp:TextBox ID="txtStock" runat="server" TextMode="Number" Text="0" />
                    </div>
                    <div class="form-group" style="max-width:120px;">
                        <label>最低库存</label>
                        <asp:TextBox ID="txtMinStock" runat="server" TextMode="Number" Text="10" />
                    </div>
                </div>
                <div class="form-group">
                    <label>描述</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="2" />
                </div>
                <div class="form-group">
                    <label>商品图片</label>
                    <div style="display:flex;gap:12px;align-items:flex-start;">
                        <div>
                            <asp:FileUpload ID="fuImage" runat="server" />
                            <asp:Image ID="imgPreview" runat="server" style="max-width:160px;max-height:160px;margin-top:8px;display:block;border:1px solid #ddd;border-radius:4px;" />
                            <asp:CheckBox ID="chkDelImage" runat="server" Text="删除图片" style="margin-top:4px;display:none;" />
                        </div>
                    </div>
                    <asp:HiddenField ID="hidOldImagePath" runat="server" />
                </div>
                <div>
                    <asp:Button ID="btnSave" runat="server" Text="保存" CssClass="btn btn-primary" OnClick="BtnSave_Click" />
                    <a href="Products/Default.aspx" class="btn" style="margin-left:8px;">取消</a>
                </div>
            </div>
        </div>
    </div>
</form>
</body>
</html>
