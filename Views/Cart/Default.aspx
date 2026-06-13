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
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 12px; }
        .product-card { background: #fff; border: 1px solid #e8e8e8; border-radius: 8px; overflow: hidden; cursor: pointer; transition: all .2s; }
        .product-card:hover { border-color: #1890ff; box-shadow: 0 2px 8px rgba(24,144,255,.15); transform: translateY(-2px); }
        .product-card .card-img { width: 100%; height: 140px; display: flex; align-items: center; justify-content: center; background: #fafafa; overflow: hidden; }
        .product-card .card-img img { max-width: 100%; max-height: 100%; object-fit: contain; }
        .product-card .card-img .no-img { color: #ccc; font-size: 36px; }
        .product-card .card-body { padding: 10px 12px; }
        .product-card .card-name { font-size: 14px; font-weight: 600; color: #333; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .product-card .card-code { font-size: 11px; color: #999; }
        .product-card .card-footer { display: flex; justify-content: space-between; align-items: center; padding: 8px 12px; border-top: 1px solid #f0f0f0; background: #fafafa; }
        .product-card .card-price { font-size: 16px; font-weight: bold; color: #ff4d4f; }
        .product-card .card-stock { font-size: 11px; color: #999; }
        .product-card.out-of-stock { opacity: .45; cursor: not-allowed; }
        .product-card.out-of-stock:hover { border-color: #e8e8e8; box-shadow: none; transform: none; }
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
                        <h3>选择商品</h3>
                        <div style="display:flex;gap:8px;margin-bottom:12px;align-items:center;">
                            <asp:TextBox ID="txtKeyword" runat="server" placeholder="搜索商品名称/编码" style="flex:1;min-width:0;" />
                            <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn" OnClick="BtnSearch_Click" />
                        </div>
                        <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="RptProducts_ItemCommand">
                            <HeaderTemplate><div class="product-grid"></HeaderTemplate>
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkCard" runat="server"
                                    CssClass='<%# (int)Eval("StockQuantity") <= 0 ? "product-card out-of-stock" : "product-card" %>'
                                    CommandName="AddToCart"
                                    CommandArgument='<%# Eval("Id") %>'
                                    Enabled='<%# (int)Eval("StockQuantity") > 0 %>'>
                                    <div class="card-img">
                                        <asp:Image ID="imgProduct" runat="server" ImageUrl='<%# Eval("ImageUrl") %>' style="max-width:100%;max-height:100%;object-fit:contain;" Visible='<%# !string.IsNullOrEmpty(Eval("ImageUrl")?.ToString()) %>' />
                                        <span class="no-img" visible='<%# string.IsNullOrEmpty(Eval("ImageUrl")?.ToString()) %>' runat="server">&#128230;</span>
                                    </div>
                                    <div class="card-body">
                                        <div class="card-name"><%# Eval("Name") %></div>
                                        <div class="card-code"><%# Eval("Code") %></div>
                                    </div>
                                    <div class="card-footer">
                                        <span class="card-price">¥<%# Eval("SellingPrice", "{0:F2}") %></span>
                                        <span class="card-stock">库存: <%# Eval("StockQuantity") %></span>
                                    </div>
                                </asp:LinkButton>
                            </ItemTemplate>
                            <FooterTemplate></div></FooterTemplate>
                        </asp:Repeater>
                        <asp:Panel ID="pnlNoProducts" runat="server" Visible="false">
                            <div style="text-align:center;padding:40px;color:#999;">没有匹配的商品</div>
                        </asp:Panel>
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
