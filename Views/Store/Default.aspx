<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Views.StoreFront" MaintainScrollPositionOnPostback="true" %>
<%@ Import Namespace="Helpers" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>便民超市 - 您身边的好邻居</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family: 'Segoe UI','Microsoft YaHei',sans-serif; background:#f5f5f5; color:#333; }
        a { text-decoration:none; color:inherit; }

        .top-bar { background:#1a1a2e; color:#fff; padding:6px 40px; display:flex; justify-content:flex-end; gap:24px; font-size:13px; }
        .top-bar a { color:#ccc; transition:color .2s; }
        .top-bar a:hover { color:#fff; }

        .navbar { background:#fff; padding:0 40px; display:flex; align-items:center; justify-content:space-between; height:64px; box-shadow:0 1px 4px rgba(0,0,0,.08); position:sticky; top:0; z-index:100; }
        .navbar .brand { font-size:24px; font-weight:800; color:#e94560; display:flex; align-items:center; gap:8px; }
        .navbar .brand span { font-size:14px; font-weight:400; color:#999; }
        .navbar .nav-links { display:flex; gap:28px; align-items:center; }
        .navbar .nav-links a { font-size:14px; color:#555; transition:color .2s; }
        .navbar .nav-links a:hover { color:#e94560; }
        .btn-backend { background:linear-gradient(135deg,#e94560,#c23152); color:#fff!important; padding:8px 20px; border-radius:6px; font-weight:600!important; transition:opacity .2s!important; }
        .btn-backend:hover { opacity:.85; }

        .hero { background:linear-gradient(135deg,#0f3460 0%,#16213e 50%,#1a1a2e 100%); color:#fff; padding:80px 40px; text-align:center; position:relative; overflow:hidden; }
        .hero::before { content:''; position:absolute; top:-50%; left:-50%; width:200%; height:200%; background:radial-gradient(circle,rgba(233,69,96,.15) 0%,transparent 60%); animation:heroPulse 6s ease-in-out infinite; }
        @keyframes heroPulse { 0%,100% { transform:scale(1); } 50% { transform:scale(1.08); } }
        .hero h1 { font-size:48px; font-weight:800; position:relative; margin-bottom:16px; }
        .hero h1 span { color:#e94560; }
        .hero p { font-size:18px; color:#aaa; position:relative; max-width:600px; margin:0 auto 32px; line-height:1.7; }
        .hero .badges { display:flex; gap:16px; justify-content:center; flex-wrap:wrap; position:relative; }
        .hero .badge { background:rgba(255,255,255,.1); border:1px solid rgba(255,255,255,.15); border-radius:8px; padding:12px 24px; font-size:14px; backdrop-filter:blur(4px); }

        .section { max-width:1240px; margin:0 auto; padding:60px 24px; }
        .section h2 { font-size:28px; font-weight:700; margin-bottom:8px; }
        .section .sub { color:#999; margin-bottom:32px; font-size:14px; }

        .features { display:grid; grid-template-columns:repeat(4,1fr); gap:20px; }
        .feature-card { background:#fff; border-radius:12px; padding:32px 24px; text-align:center; box-shadow:0 2px 8px rgba(0,0,0,.06); transition:transform .2s,box-shadow .2s; }
        .feature-card:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,.1); }
        .feature-card .icon { width:56px; height:56px; border-radius:14px; display:flex; align-items:center; justify-content:center; margin:0 auto 16px; font-size:26px; }
        .feature-card h4 { font-size:16px; margin-bottom:8px; }
        .feature-card p { font-size:13px; color:#888; line-height:1.6; }

        .product-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(220px,1fr)); gap:16px; }
        .product-card { background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 2px 8px rgba(0,0,0,.06); transition:all .25s; cursor:pointer; border:1px solid transparent; }
        .product-card:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,.12); border-color:#e94560; }
        .product-card .card-img { height:180px; background:#fafafa; display:flex; align-items:center; justify-content:center; overflow:hidden; }
        .product-card .card-img img { max-width:80%; max-height:80%; object-fit:contain; }
        .product-card .card-img .no-img { font-size:48px; color:#ddd; }
        .product-card .card-info { padding:14px 16px; }
        .product-card .card-name { font-size:15px; font-weight:600; margin-bottom:4px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .product-card .card-code { font-size:11px; color:#bbb; margin-bottom:8px; }
        .product-card .card-bottom { display:flex; justify-content:space-between; align-items:center; padding:0 16px 14px; }
        .product-card .card-price { font-size:20px; font-weight:700; color:#e94560; }
        .product-card .card-price .yen { font-size:14px; }
        .product-card .card-add { background:#e94560; color:#fff; border:none; width:32px; height:32px; border-radius:50%; font-size:20px; cursor:pointer; line-height:32px; text-align:center; transition:background .2s; display:inline-block; }
        .product-card .card-add:hover { background:#c23152; }
        .product-card.out-of-stock { opacity:.45; cursor:not-allowed; }
        .product-card.out-of-stock:hover { transform:none; box-shadow:0 2px 8px rgba(0,0,0,.06); border-color:transparent; }

        .cart-panel { background:#fff; border-radius:12px; box-shadow:0 2px 12px rgba(0,0,0,.1); padding:24px; position:sticky; top:80px; max-height:calc(100vh - 100px); overflow-y:auto; }
        .cart-panel h3 { font-size:18px; margin-bottom:16px; display:flex; align-items:center; gap:8px; }
        .cart-item { display:flex; gap:10px; padding:10px 0; border-bottom:1px solid #f0f0f0; align-items:center; }
        .cart-item .ci-info { flex:1; min-width:0; }
        .cart-item .ci-name { font-size:13px; font-weight:500; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .cart-item .ci-price { font-size:12px; color:#999; }
        .cart-item .ci-qty { display:flex; align-items:center; gap:6px; }
        .cart-item .ci-qty button { width:24px; height:24px; border:1px solid #ddd; border-radius:4px; background:#fff; cursor:pointer; font-size:14px; line-height:24px; text-align:center; }
        .cart-item .ci-qty span { font-size:13px; min-width:20px; text-align:center; }
        .cart-summary { border-top:2px solid #e94560; margin-top:16px; padding-top:16px; }
        .cart-summary .row { display:flex; justify-content:space-between; font-size:14px; margin-bottom:8px; }
        .cart-summary .total { font-size:22px; font-weight:700; color:#e94560; }
        .btn-checkout { display:block; width:100%; padding:12px; background:linear-gradient(135deg,#e94560,#c23152); color:#fff; border:none; border-radius:8px; font-size:16px; font-weight:600; cursor:pointer; margin-top:16px; transition:opacity .2s; }
        .btn-checkout:hover { opacity:.85; }
        .btn-checkout:disabled { opacity:.4; cursor:not-allowed; }
        .cart-empty { text-align:center; padding:30px 0; color:#ccc; }

        .footer { background:#1a1a2e; color:#666; text-align:center; padding:32px; margin-top:60px; font-size:13px; }
        .footer a { color:#e94560; }

        .two-col { display:flex; gap:24px; }
        .two-col .col-main { flex:1; min-width:0; }
        .two-col .col-side { width:360px; flex-shrink:0; }

        .search-box { width:100%; padding:10px 16px; border:2px solid #eee; border-radius:10px; font-size:14px; margin-bottom:20px; transition:border .2s; }
        .search-box:focus { border-color:#e94560; outline:none; }

        @media(max-width:768px){ .two-col{flex-direction:column;} .two-col .col-side{width:100%;} .features{grid-template-columns:repeat(2,1fr);} .hero h1{font-size:32px;} }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <div class="top-bar">
        <a href="#features">关于我们</a>
        <span style="color:#555;">|</span>
        <a href="#products">商品浏览</a>
        <span style="color:#555;">|</span>
            <a href="../Login.aspx">登录后台</a>
    </div>

    <nav class="navbar">
        <a href="#" class="brand">&#127978; 便民超市<span>.com</span></a>
        <div class="nav-links">
            <a href="#features">服务特色</a>
            <a href="#products">全部商品</a>
            <a href="#cart">购物车</a>
            <a href="../Login.aspx" class="btn-backend">登录后台</a>
        </div>
    </nav>

    <section class="hero">
        <h1>欢迎来到<span>便民超市</span></h1>
        <p>品质生活，触手可及。我们精选千款好物，以最优价格、最快配送，服务每一位邻居。线上线下同步，让购物变得更简单。</p>
        <div class="badges">
            <div class="badge">&#128666; 30分钟送达</div>
            <div class="badge">&#127793; 新鲜直供</div>
            <div class="badge">&#128176; 天天低价</div>
            <div class="badge">&#11088; 品质保证</div>
        </div>
    </section>

    <div class="section" id="features">
        <h2>为什么选择我们</h2>
        <p class="sub">用心服务每一位顾客，让购物变成享受</p>
        <div class="features">
            <div class="feature-card">
                <div class="icon" style="background:#fff0f0;">&#127793;</div>
                <h4>新鲜食材</h4>
                <p>每日新鲜到货，严格品控，从源头保障品质</p>
            </div>
            <div class="feature-card">
                <div class="icon" style="background:#f0f4ff;">&#128666;</div>
                <h4>极速配送</h4>
                <p>下单30分钟内送达，专业冷链，新鲜不等待</p>
            </div>
            <div class="feature-card">
                <div class="icon" style="background:#f0fff0;">&#128176;</div>
                <h4>实惠价格</h4>
                <p>厂家直供，减少中间环节，把实惠留给您</p>
            </div>
            <div class="feature-card">
                <div class="icon" style="background:#fff8f0;">&#128222;</div>
                <h4>贴心服务</h4>
                <p>7x24小时客服，退换无忧，您的满意是我们的追求</p>
            </div>
        </div>
    </div>

    <div class="section" id="products">
        <h2>精选商品</h2>
        <p class="sub">点击商品卡片即可加入购物车</p>
        <div class="two-col">
            <div class="col-main">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" placeholder="搜索商品名称..." AutoPostBack="true" OnTextChanged="TxtSearch_TextChanged" />
                <asp:Literal ID="litMsg" runat="server" />
                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="RptProducts_ItemCommand">
                    <HeaderTemplate><div class="product-grid"></HeaderTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkCard" runat="server"
                            CssClass='<%# (int)Eval("StockQuantity") <= 0 ? "product-card out-of-stock" : "product-card" %>'
                            CommandName="Add"
                            CommandArgument='<%# Eval("Id") %>'
                            Enabled='<%# (int)Eval("StockQuantity") > 0 %>'>
                            <div class="card-img">
                                <asp:Image ID="imgProduct" runat="server" ImageUrl='<%# Eval("ImagePath") %>' style="max-width:80%;max-height:80%;object-fit:contain;" Visible='<%# !string.IsNullOrEmpty((string)Eval("ImagePath")) %>' />
                                <span class="no-img" Visible='<%# string.IsNullOrEmpty((string)Eval("ImagePath")) %>' runat="server">&#128722;</span>
                            </div>
                            <div class="card-info">
                                <div class="card-name"><%# Eval("Name") %></div>
                                <div class="card-code"><%# Eval("Code") %> · 库存 <%# Eval("StockQuantity") %></div>
                            </div>
                            <div class="card-bottom">
                                <span class="card-price"><span class="yen">¥</span><%# Eval("SellingPrice","{0:F2}") %></span>
                                <span class="card-add">+</span>
                            </div>
                        </asp:LinkButton>
                    </ItemTemplate>
                    <FooterTemplate></div></FooterTemplate>
                </asp:Repeater>
            </div>

            <div class="col-side" id="cart">
                <div class="cart-panel">
                    <h3>&#128722; 购物车 <span style="font-size:13px;color:#999;font-weight:400;">(<%# CartHelper.Count %>件)</span></h3>
                    <asp:Repeater ID="rptCart" runat="server" OnItemCommand="RptCart_ItemCommand">
                        <ItemTemplate>
                            <div class="cart-item">
                                <div class="ci-info">
                                    <div class="ci-name"><%# Eval("ProductName") %></div>
                                    <div class="ci-price">¥<%# Eval("UnitPrice","{0:F2}") %> x <%# Eval("Quantity") %></div>
                                </div>
                                <div class="ci-qty">
                                    <asp:LinkButton ID="btnMinus" runat="server" Text="-" CommandName="Minus" CommandArgument='<%# Eval("ProductId") %>' style="display:inline-block;width:24px;height:24px;border:1px solid #ddd;border-radius:4px;text-align:center;line-height:24px;font-size:14px;color:#555;" />
                                    <span><%# Eval("Quantity") %></span>
                                    <asp:LinkButton ID="btnPlus" runat="server" Text="+" CommandName="Plus" CommandArgument='<%# Eval("ProductId") %>' style="display:inline-block;width:24px;height:24px;border:1px solid #ddd;border-radius:4px;text-align:center;line-height:24px;font-size:14px;color:#555;" />
                                </div>
                                <span style="color:#e94560;font-weight:600;font-size:14px;">¥<%# Eval("SubTotal","{0:F2}") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlCartEmpty" runat="server" Visible="true">
                        <div class="cart-empty">购物车是空的<br/>点击商品卡片添加吧 &#128522;</div>
                    </asp:Panel>

                    <div class="cart-summary">
                        <div class="row"><span>商品总额</span><span>¥<asp:Literal ID="litSubtotal" runat="server" Text="0.00" /></span></div>
                        <div class="row" style="margin-bottom:12px;"><span>共 <asp:Literal ID="litItemCount" runat="server" Text="0" /> 件</span></div>
                        <div class="total">合计 ¥<asp:Literal ID="litTotal" runat="server" Text="0.00" /></div>
                        <asp:Button ID="btnCheckout" runat="server" Text="去结算" CssClass="btn-checkout" OnClick="BtnCheckout_Click" OnClientClick="return confirm('确定结算当前购物车？')" />
                        <div style="text-align:center;margin-top:8px;">
                            <asp:LinkButton ID="btnClear" runat="server" Text="清空购物车" OnClick="BtnClear_Click" style="font-size:12px;color:#999;" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2025 便民超市 ErpManagement · <a href="../Login.aspx">管理后台</a></p>
        <p style="margin-top:4px;">地址：xx市xx区xx路100号 | 电话：400-888-8888 | 营业时间：07:00 - 22:00</p>
    </footer>

</form>
</body>
</html>
