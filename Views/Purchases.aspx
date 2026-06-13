<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Purchases.aspx.cs" Inherits="Views.Purchases" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>进货管理</title>
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
                    <h3>进货单列表</h3>
                    <asp:Button ID="btnShowCreate" runat="server" Text="新建进货单" CssClass="btn btn-primary" OnClick="BtnShowCreate_Click" />
                </div>

                <div style="margin-bottom:12px;">
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Value="" Text="全部" />
                        <asp:ListItem Value="待入库" Text="待入库" />
                        <asp:ListItem Value="已入库" Text="已入库" />
                        <asp:ListItem Value="已取消" Text="已取消" />
                    </asp:DropDownList>
                    <asp:Button ID="btnFilter" runat="server" Text="筛选" CssClass="btn btn-primary" OnClick="BtnFilter_Click" />
                </div>

                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False"
                    CssClass="table" GridLines="None"
                    OnRowCommand="GvOrders_RowCommand"
                    DataKeyNames="id">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="orderNo" HeaderText="单号" />
                        <asp:TemplateField HeaderText="供应商">
                            <ItemTemplate><%# ((Entities.PurchaseOrder)Container.DataItem).supplier?.name %></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="totalAmount" HeaderText="金额" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="status" HeaderText="状态" />
                        <asp:BoundField DataField="createdAt" HeaderText="创建时间" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <asp:Button ID="btnDetail" runat="server" Text="详情" CssClass="btn btn-primary" CommandName="Detail" CommandArgument='<%# Eval("id") %>' />
                                <asp:Button ID="btnConfirm" runat="server" Text="入库" CssClass="btn btn-primary" CommandName="Confirm" CommandArgument='<%# Eval("id") %>' Visible='<%# Eval("status").ToString() == "待入库" %>' OnClientClick="return confirm('确认入库？库存将增加')" />
                                <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn btn-danger" CommandName="Cancel" CommandArgument='<%# Eval("id") %>' Visible='<%# Eval("status").ToString() == "待入库" %>' OnClientClick="return confirm('确定取消？')" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <asp:Panel ID="pnlDetail" runat="server" Visible="false">
            <div class="card">
                <h3><asp:Literal ID="litDetailTitle" runat="server" /></h3>
                <div style="margin:12px 0;">
                    <b>供应商：</b><asp:Literal ID="litDetailSupplier" runat="server" />
                    <span style="margin-left:20px;"><b>状态：</b><asp:Literal ID="litDetailStatus" runat="server" /></span>
                    <span style="margin-left:20px;"><b>金额：</b><asp:Literal ID="litDetailAmount" runat="server" /></span>
                </div>
                <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="False" CssClass="table" GridLines="None">
                    <Columns>
                        <asp:TemplateField HeaderText="商品"><ItemTemplate><%# ((Entities.PurchaseOrderItem)Container.DataItem).product?.name %></ItemTemplate></asp:TemplateField>
                        <asp:BoundField DataField="quantity" HeaderText="数量" />
                        <asp:BoundField DataField="unitPrice" HeaderText="单价" DataFormatString="{0:F2}" />
                        <asp:BoundField DataField="subTotal" HeaderText="小计" DataFormatString="{0:F2}" />
                    </Columns>
                </asp:GridView>
                <asp:Button ID="btnBack" runat="server" Text="返回" CssClass="btn" OnClick="BtnBack_Click" style="margin-top:12px;" />
            </div>
            </asp:Panel>

            <asp:Panel ID="pnlCreate" runat="server" Visible="false">
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
                <asp:Button ID="btnCreateCancel" runat="server" Text="取消" CssClass="btn" OnClick="BtnCreateCancel_Click" />
            </div>
            </asp:Panel>
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
