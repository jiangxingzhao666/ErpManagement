<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.StockAlert" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>库存预警</title>
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
                <h3>库存预警列表</h3>
                <p style="color:#999;margin-bottom:12px;">库存数量 &le; 最低库存 的商品</p>

                <asp:GridView ID="gvAlerts" runat="server" AutoGenerateColumns="False"
                    CssClass="table" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="code" HeaderText="编号" />
                        <asp:BoundField DataField="name" HeaderText="商品名称" />
                        <asp:TemplateField HeaderText="分类">
                            <ItemTemplate><%# ((Entities.Product)Container.DataItem).category?.name %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="stockQuantity" HeaderText="当前库存" />
                        <asp:BoundField DataField="minStock" HeaderText="最低库存" />
                        <asp:TemplateField HeaderText="状态">
                            <ItemTemplate>
                                <span class="tag tag-danger">库存不足</span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                    <div style="text-align:center;padding:30px;color:#52c41a;">所有商品库存正常</div>
                </asp:Panel>
            </div>
        </div>
    </div>

</form>
</body>
</html>
