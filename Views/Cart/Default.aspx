<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.Cart" EnableEventValidation="false" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>购物车</title>
    <link rel="stylesheet" href="/Content/site.css" />
    <style>
        .cart-layout { display: flex; gap: 20px; }
        .cart-left { flex: 1; }
        .cart-right { width: 340px; }
        .cart-summary { background: #fafafa; border-radius: 6px; padding: 20px; position: sticky; top: 76px; }
        .cart-summary .total { font-size: 22px; font-weight: bold; color: #ff4d4f; margin: 12px 0; }
        .product-search { display: flex; gap: 8px; margin-bottom: 16px; align-items: center; }
        .product-search select { flex: 1; min-width: 0; }
        .product-search input { width: 70px; flex-shrink: 0; }
        .product-search .btn { flex-shrink: 0; min-width: 110px; }
    </style>
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

            <div class="cart-layout">
                <div class="cart-left">
                    <div class="card">
                        <h3>添加商品</h3>
                        <div style="display:flex;gap:8px;margin-bottom:8px;align-items:center;">
                            <asp:TextBox ID="txtKeyword" runat="server" placeholder="搜索商品名称/编码" style="flex:1;min-width:0;" />
                            <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn" OnClick="BtnSearch_Click" />
                        </div>
                        <div class="product-search">
                            <asp:DropDownList ID="ddlProduct" runat="server" />
                            <asp:TextBox ID="txtQty" runat="server" TextMode="Number" Text="1" style="width:70px;" />
                            <asp:Button ID="btnAdd" runat="server" Text="加入购物车" CssClass="btn btn-primary" OnClick="BtnAdd_Click" />
                        </div>
                    </div>

                    <div class="card">
                        <h3>购物车</h3>
                        <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
                            <div style="text-align:center;padding:30px;color:#999;">购物车为空，请添加商品</div>
                        </asp:Panel>

                        <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="False"
                            CssClass="table" GridLines="None"
                            OnRowCommand="GvCart_RowCommand"
                            DataKeyNames="ProductId">
                            <Columns>
                                <asp:TemplateField HeaderText="#">
                                    <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ProductCode" HeaderText="编号" />
                                <asp:TemplateField HeaderText="商品">
                                    <ItemTemplate><%# Eval("ProductName") %> <span style="color:#999;">/<%# Eval("Unit") %></span></ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="UnitPrice" HeaderText="单价" DataFormatString="{0:F2}" />
                                <asp:TemplateField HeaderText="数量">
                                    <ItemTemplate>
                                        <asp:Button ID="btnMinus" runat="server" Text="-" CssClass="btn" CommandName="Minus" CommandArgument='<%# Eval("ProductId") %>' />
                                        <span style="padding:0 6px;"><%# Eval("Quantity") %></span>
                                        <asp:Button ID="btnPlus" runat="server" Text="+" CssClass="btn btn-primary" CommandName="Plus" CommandArgument='<%# Eval("ProductId") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="SubTotal" HeaderText="小计" DataFormatString="{0:F2}" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:Button ID="btnRemove" runat="server" Text="删除" CssClass="btn btn-danger" CommandName="Remove" CommandArgument='<%# Eval("ProductId") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <div class="cart-right">
                    <div class="cart-summary">
                        <h3 style="margin-bottom:16px;">结算</h3>
                        <div class="form-group">
                            <label>客户</label>
                            <asp:DropDownList ID="ddlCustomer" runat="server">
                                <asp:ListItem Value="" Text="散客" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>支付方式</label>
                            <asp:DropDownList ID="ddlPayment" runat="server">
                                <asp:ListItem Value="现金" Text="现金" />
                                <asp:ListItem Value="微信" Text="微信" />
                                <asp:ListItem Value="支付宝" Text="支付宝" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>优惠金额</label>
                            <asp:TextBox ID="txtDiscount" runat="server" TextMode="Number" Text="0" />
                        </div>
                        <div style="border-top:1px solid #e8e8e8; margin:12px 0; padding-top:12px;">
                            <div style="display:flex;justify-content:space-between;"><span>商品总额</span><span><asp:Literal ID="litSubTotal" runat="server" Text="0.00" /></span></div>
                            <div style="display:flex;justify-content:space-between;"><span>优惠</span><span style="color:#999;">-<asp:Literal ID="litDiscount" runat="server" Text="0.00" /></span></div>
                            <div class="total">实收: ¥<asp:Literal ID="litTotal" runat="server" Text="0.00" /></div>
                        </div>
                        <asp:Button ID="btnCheckout" runat="server" Text="确认结算" CssClass="btn btn-primary" OnClick="BtnCheckout_Click" style="width:100%;padding:12px;font-size:16px;" />
                        <asp:Button ID="btnClear" runat="server" Text="清空购物车" CssClass="btn" OnClick="BtnClear_Click" style="width:100%;margin-top:8px;" />
                    </div>
                </div>
            </div>

        </div>
    </div>

</form>
</body>
</html>
