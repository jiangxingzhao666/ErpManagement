<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Create.aspx.cs" Inherits="Views.PurchaseCreate" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>新建进货单 - 超市进销存管理系统</title>
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
                <h3>新建进货单</h3>
                <div class="form-group"><label>供应商</label>
                    <asp:DropDownList ID="ddlSupplier" runat="server" />
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
                <asp:Button ID="btnSubmit" runat="server" Text="提交进货单" CssClass="btn btn-primary" OnClick="BtnSubmit_Click" style="margin-top:12px;" />
                <a href="Purchases/Default.aspx" class="btn" style="margin-left:8px;">取消</a>
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
