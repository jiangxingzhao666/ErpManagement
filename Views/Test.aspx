<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="DefaultNamespace.Test" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>数据库功能测试</title>
    <style>
        body { font-family: 'Microsoft YaHei', sans-serif; margin: 20px; background: #f0f2f5; }
        h2 { border-bottom: 2px solid #1890ff; padding-bottom: 8px; color: #333; }
        h3 { color: #555; margin-top: 30px; }
        .section { background: #fff; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,.1); }
        .btn { display: inline-block; padding: 6px 16px; margin: 4px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; color: #fff; }
        .btn-add { background: #52c41a; }
        .btn-query { background: #1890ff; }
        .btn-update { background: #faad14; }
        .btn-del { background: #ff4d4f; }
        .btn-special { background: #722ed1; }
        .btn:hover { opacity: 0.85; }
        pre { background: #1e1e1e; color: #d4d4d4; padding: 15px; border-radius: 6px; overflow-x: auto; font-size: 13px; line-height: 1.6; max-height: 600px; overflow-y: auto; }
        .log-success { color: #52c41a; }
        .log-error { color: #ff4d4f; }
        .log-info { color: #1890ff; }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <h1 style="text-align:center; color:#1890ff;">数据库 CRUD 功能测试</h1>

    <!-- 商品分类 -->
    <div class="section">
        <h2>1. 商品分类 Categories</h2>
        <asp:Button ID="btnCatQuery"  runat="server" Text="查询所有"   CssClass="btn btn-query"   OnClick="BtnCatQuery_Click" />
        <asp:Button ID="btnCatAdd"    runat="server" Text="新增"       CssClass="btn btn-add"     OnClick="BtnCatAdd_Click" />
        <asp:Button ID="btnCatUpdate" runat="server" Text="修改第1条"  CssClass="btn btn-update"  OnClick="BtnCatUpdate_Click" />
        <asp:Button ID="btnCatDel"    runat="server" Text="删除最后一条" CssClass="btn btn-del"    OnClick="BtnCatDel_Click" />
    </div>

    <!-- 供应商 -->
    <div class="section">
        <h2>2. 供应商 Suppliers</h2>
        <asp:Button ID="btnSupQuery"  runat="server" Text="查询所有"   CssClass="btn btn-query"   OnClick="BtnSupQuery_Click" />
        <asp:Button ID="btnSupAdd"    runat="server" Text="新增"       CssClass="btn btn-add"     OnClick="BtnSupAdd_Click" />
        <asp:Button ID="btnSupUpdate" runat="server" Text="修改第1条"  CssClass="btn btn-update"  OnClick="BtnSupUpdate_Click" />
        <asp:Button ID="btnSupDel"    runat="server" Text="删除最后一条" CssClass="btn btn-del"    OnClick="BtnSupDel_Click" />
    </div>

    <!-- 商品 -->
    <div class="section">
        <h2>3. 商品 Products</h2>
        <asp:Button ID="btnProdQuery"  runat="server" Text="查询所有"   CssClass="btn btn-query"   OnClick="BtnProdQuery_Click" />
        <asp:Button ID="btnProdAdd"    runat="server" Text="新增"       CssClass="btn btn-add"     OnClick="BtnProdAdd_Click" />
        <asp:Button ID="btnProdUpdate" runat="server" Text="修改第1条"  CssClass="btn btn-update"  OnClick="BtnProdUpdate_Click" />
        <asp:Button ID="btnProdDel"    runat="server" Text="软删除第1条" CssClass="btn btn-del"    OnClick="BtnProdDel_Click" />
        <asp:Button ID="btnStockAlert" runat="server" Text="库存预警"   CssClass="btn btn-special" OnClick="BtnStockAlert_Click" />
    </div>

    <!-- 客户 -->
    <div class="section">
        <h2>4. 客户 Customers</h2>
        <asp:Button ID="btnCusQuery"  runat="server" Text="查询所有"   CssClass="btn btn-query"   OnClick="BtnCusQuery_Click" />
        <asp:Button ID="btnCusAdd"    runat="server" Text="新增"       CssClass="btn btn-add"     OnClick="BtnCusAdd_Click" />
        <asp:Button ID="btnCusUpdate" runat="server" Text="修改第1条"  CssClass="btn btn-update"  OnClick="BtnCusUpdate_Click" />
        <asp:Button ID="btnCusDel"    runat="server" Text="删除最后一条" CssClass="btn btn-del"    OnClick="BtnCusDel_Click" />
    </div>

    <!-- 进货单 -->
    <div class="section">
        <h2>5. 进货管理 Purchase</h2>
        <asp:Button ID="btnPurQuery"   runat="server" Text="查询进货单" CssClass="btn btn-query"   OnClick="BtnPurQuery_Click" />
        <asp:Button ID="btnPurCreate"  runat="server" Text="新建进货单" CssClass="btn btn-add"     OnClick="BtnPurCreate_Click" />
        <asp:Button ID="btnPurConfirm" runat="server" Text="确认入库(最后一条)" CssClass="btn btn-special" OnClick="BtnPurConfirm_Click" />
        <asp:Button ID="btnPurCancel"  runat="server" Text="取消(最后一条)" CssClass="btn btn-del" OnClick="BtnPurCancel_Click" />
    </div>

    <!-- 销售单 -->
    <div class="section">
        <h2>6. 销售管理 Sales</h2>
        <asp:Button ID="btnSaleQuery"  runat="server" Text="查询销售单" CssClass="btn btn-query"   OnClick="BtnSaleQuery_Click" />
        <asp:Button ID="btnSaleCreate" runat="server" Text="新建销售单" CssClass="btn btn-add"     OnClick="BtnSaleCreate_Click" />
    </div>

    <!-- 用户 -->
    <div class="section">
        <h2>7. 用户 Users</h2>
        <asp:Button ID="btnUserQuery"  runat="server" Text="查询所有"   CssClass="btn btn-query"   OnClick="BtnUserQuery_Click" />
        <asp:Button ID="btnUserAdd"    runat="server" Text="新增"       CssClass="btn btn-add"     OnClick="BtnUserAdd_Click" />
        <asp:Button ID="btnUserLogin"  runat="server" Text="测试登录"   CssClass="btn btn-special" OnClick="BtnUserLogin_Click" />
        <asp:Button ID="btnUserDel"    runat="server" Text="删除最后一条" CssClass="btn btn-del"    OnClick="BtnUserDel_Click" />
        <asp:Button ID="btnUserInactive" runat="server" Text="查看含禁用" CssClass="btn btn-special" OnClick="BtnUserInactive_Click" />
    </div>

    <!-- Token -->
    <div class="section">
        <h2>8. 认证 Token</h2>
        <asp:Button ID="btnTokenTest"  runat="server" Text="Token 状态" CssClass="btn btn-query"   OnClick="BtnTokenTest_Click" />
        <asp:Button ID="btnTokenClean" runat="server" Text="清理过期Token" CssClass="btn btn-del" OnClick="BtnTokenClean_Click" />
    </div>

    <!-- 综合 -->
    <div class="section">
        <h2>9. 综合测试</h2>
        <asp:Button ID="btnAll"  runat="server" Text="逐模块全测" CssClass="btn btn-special" OnClick="BtnAll_Click" />
    </div>

    <!-- 输出 -->
    <div class="section">
        <h2>执行结果</h2>
        <pre id="output" runat="server"></pre>
    </div>

</form>
</body>
</html>
