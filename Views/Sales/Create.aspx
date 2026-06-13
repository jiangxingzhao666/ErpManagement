<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SaleCreate.aspx.cs" Inherits="Views.SaleCreate" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>新建销售单 - 超市进销存管理系统</title>
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
                <h3>新建销售单</h3>
                <asp:Literal ID="litError" runat="server" />
                <div class="form-group"><label>客户</label>
                    <asp:DropDownList ID="ddlCustomer" runat="server">
                        <asp:ListItem Value="" Text="散客（不选）" />
                    </asp:DropDownList>
                </div>
                <div class="form-group"><label>支付方式</label>
                    <asp:DropDownList ID="ddlPayment" runat="server">
                        <asp:ListItem Value="现金" Text="现金" />
                        <asp:ListItem Value="微信" Text="微信" />
                        <asp:ListItem Value="支付宝" Text="支付宝" />
                    </asp:DropDownList>
                </div>
                <div class="form-group"><label>优惠金额</label>
                    <asp:TextBox ID="txtDiscount" runat="server" TextMode="Number" Text="0" />
                </div>
                <div class="form-group"><label>备注</label>
                    <asp:TextBox ID="txtRemark" runat="server" />
                </div>
                <h4 style="margin-top:16px;">商品明细</h4>
                <div id="itemRows" style="margin:8px 0;">
                    <div class="item-row" style="display:flex;gap:8px;margin-bottom:8px;align-items:center;">
                        <asp:DropDownList ID="ddlProduct0" runat="server" />
                        <asp:TextBox ID="txtQty0" runat="server" TextMode="Number" Text="1" style="width:80px;" placeholder="数量" />
                        <button type="button" class="btn btn-primary" onclick="addRow()">+</button>
                    </div>
                </div>
                <asp:Button ID="btnSubmit" runat="server" Text="提交销售单" CssClass="btn btn-primary" OnClick="BtnSubmit_Click" style="margin-top:12px;" />
                <a href="Sales.aspx" class="btn" style="margin-left:8px;">取消</a>
            </div>
        </div>
    </div>
    <script>
        var rowCount = 1;
        function addRow(){
            var container = document.getElementById('itemRows');
            var div = document.createElement('div');
            div.className = 'item-row';
            div.style.cssText = 'display:flex;gap:8px;margin-bottom:8px;align-items:center;';
            var sel = document.createElement('select');
            sel.name = 'ddlProduct' + rowCount;
            sel.innerHTML = document.getElementsByName('ddlProduct0')[0].innerHTML;
            var qty = document.createElement('input');
            qty.name = 'txtQty' + rowCount;
            qty.type = 'number';
            qty.value = '1';
            qty.style.width = '80px';
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn btn-danger';
            btn.textContent = '-';
            btn.onclick = function(){ container.removeChild(div); };
            div.appendChild(sel);
            div.appendChild(qty);
            div.appendChild(btn);
            container.appendChild(div);
            rowCount++;
        }
    </script>
</form>
</body>
</html>
