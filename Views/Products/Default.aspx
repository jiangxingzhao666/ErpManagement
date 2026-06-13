<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>超市进销存管理系统</title>
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
            <asp:Panel ID="pnlLoggedOut" runat="server" Visible="true">
                <a href="Login.aspx" class="btn-login">登 录</a>
            </asp:Panel>
        </div>
    </div>

    <div class="layout">
        <div class="sidebar" id="sidebar" runat="server"></div>

        <div class="main">
            <div class="stats">
                <div class="stat-item">
                    <div class="num"><asp:Literal ID="litTotalProducts" runat="server" Text="0" /></div>
                    <div class="label">商品总数</div>
                </div>
                <div class="stat-item">
                    <div class="num"><asp:Literal ID="litTotalSuppliers" runat="server" Text="0" /></div>
                    <div class="label">供应商数量</div>
                </div>
                <div class="stat-item">
                    <div class="num"><asp:Literal ID="litTotalCustomers" runat="server" Text="0" /></div>
                    <div class="label">客户数量</div>
                </div>
                <div class="stat-item">
                    <div class="num"><asp:Literal ID="litStockAlerts" runat="server" Text="0" /></div>
                    <div class="label">库存预警</div>
                </div>
            </div>

            <div class="card">
                <div style="display:flex;justify-content:space-between;align-items:center;">
                    <h3>商品列表</h3>
                    <a href="Products/Edit.aspx" class="btn btn-primary">新增商品</a>
                </div>

                <div style="display:flex;gap:8px;margin-bottom:12px;align-items:center;">
                    <asp:TextBox ID="txtKeyword" runat="server" placeholder="搜索名称/编号" style="width:200px;" />
                    <asp:DropDownList ID="ddlCatFilter" runat="server" />
                    <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-primary" OnClick="BtnSearch_Click" />
                </div>

                <asp:GridView ID="gvProducts" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="table" GridLines="None"
                    OnRowDataBound="GvProducts_RowDataBound"
                    OnRowCommand="GvProducts_RowCommand"
                    DataKeyNames="id">
                    <Columns>
                        <asp:BoundField DataField="code" HeaderText="编号" />
                        <asp:BoundField DataField="name" HeaderText="商品名称" />
                        <asp:TemplateField HeaderText="分类">
                            <ItemTemplate><%# ((Entities.Product)Container.DataItem).category?.name %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="unit" HeaderText="单位" />
                        <asp:BoundField DataField="purchasePrice" HeaderText="进价" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="sellingPrice" HeaderText="售价" DataFormatString="{0:F2}" />
                        <asp:TemplateField HeaderText="库存">
                            <ItemTemplate>
                                <asp:Literal ID="litStock" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="状态">
                            <ItemTemplate>
                                <asp:Literal ID="litStatus" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <a href='Products/Edit.aspx?id=<%# Eval("id") %>' class="btn btn-primary">编辑</a>
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
