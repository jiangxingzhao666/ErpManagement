<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="Views.Reports" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>销售报表</title>
    <link rel="stylesheet" href="../Content/site.css" />
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.5.0/dist/echarts.min.js"></script>
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

            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
                <h2 style="margin:0;">销售报表</h2>
                <div style="display:flex;gap:8px;align-items:center;">
                    <asp:DropDownList ID="ddlFormat" runat="server">
                        <asp:ListItem Value="excel" Text="Excel (.xlsx)" />
                        <asp:ListItem Value="csv" Text="CSV (.csv)" />
                    </asp:DropDownList>
                    <asp:Button ID="btnExport" runat="server" Text="导出" CssClass="btn btn-primary" OnClick="BtnExport_Click" />
                </div>
            </div>

            <div class="stats">
                <div class="stat-item">
                    <div class="num"><asp:Literal ID="litTotalSales" runat="server" Text="0" /></div>
                    <div class="label">总销售额</div>
                </div>
                <div class="stat-item">
                    <div class="num"><asp:Literal ID="litOrderCount" runat="server" Text="0" /></div>
                    <div class="label">销售单数</div>
                </div>
                <div class="stat-item">
                    <div class="num"><asp:Literal ID="litAvgAmount" runat="server" Text="0" /></div>
                    <div class="label">平均客单价</div>
                </div>
                <div class="stat-item">
                    <div class="num"><asp:Literal ID="litTotalDiscount" runat="server" Text="0" /></div>
                    <div class="label">总优惠额</div>
                </div>
            </div>

            <div style="display:flex;gap:16px;flex-wrap:wrap;">
                <div class="card" style="flex:1;min-width:500px;">
                    <h3>月度销售趋势</h3>
                    <div id="chartMonthly" style="width:100%;height:380px;"></div>
                </div>
                <div class="card" style="flex:1;min-width:380px;">
                    <h3>分类销售占比</h3>
                    <div id="chartCategory" style="width:100%;height:380px;"></div>
                </div>
            </div>

            <div style="display:flex;gap:16px;flex-wrap:wrap;">
                <div class="card" style="flex:1;min-width:480px;">
                    <h3>商品销量排行 TOP 10</h3>
                    <div id="chartTop" style="width:100%;height:400px;"></div>
                </div>
                <div class="card" style="flex:1;min-width:380px;">
                    <h3>客户消费排行 TOP 10</h3>
                    <div id="chartCustomer" style="width:100%;height:400px;"></div>
                </div>
            </div>

        </div>
    </div>

    <script>
        var chartMonthly = echarts.init(document.getElementById('chartMonthly'));
        chartMonthly.setOption({
            tooltip: { trigger: 'axis' },
            legend: { data: ['销售额', '订单数'] },
            xAxis: { type: 'category', data: <%= monthlyLabels %> },
            yAxis: [
                { type: 'value', name: '销售额' },
                { type: 'value', name: '订单数' }
            ],
            series: [
                { name: '销售额', type: 'line', data: <%= monthlySales %>, smooth: true,
                    itemStyle: { color: '#1890ff' }, areaStyle: { color: 'rgba(24,144,255,0.1)' } },
                { name: '订单数', type: 'bar', yAxisIndex: 1, data: <%= monthlyCounts %>,
                    itemStyle: { color: '#52c41a' }, barWidth: 20 }
            ]
        });

        var chartCategory = echarts.init(document.getElementById('chartCategory'));
        chartCategory.setOption({
            tooltip: { trigger: 'item', formatter: '{b}: {c} 件 ({d}%)' },
            legend: { orient: 'vertical', left: 0, top: 20 },
            series: [{
                type: 'pie', radius: ['40%', '70%'], center: ['55%', '50%'],
                data: <%= categoryData %>,
                label: { formatter: '{b}\n{d}%' },
                emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0,0,0,0.5)' } }
            }]
        });

        var chartTop = echarts.init(document.getElementById('chartTop'));
        chartTop.setOption({
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
            grid: { left: '3%', right: '10%', containLabel: true },
            xAxis: { type: 'value', name: '销量' },
            yAxis: { type: 'category', data: <%= topNames %>, inverse: true },
            series: [{
                type: 'bar', data: <%= topQuantities %>,
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
                        { offset: 0, color: '#1890ff' }, { offset: 1, color: '#36cfc9' }
                    ])
                },
                label: { show: true, position: 'right' }
            }]
        });

        var chartCustomer = echarts.init(document.getElementById('chartCustomer'));
        chartCustomer.setOption({
            tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
            grid: { left: '3%', right: '10%', containLabel: true },
            xAxis: { type: 'value', name: '消费额' },
            yAxis: { type: 'category', data: <%= customerNames %>, inverse: true },
            series: [{
                type: 'bar', data: <%= customerAmounts %>,
                itemStyle: {
                    color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
                        { offset: 0, color: '#fa8c16' }, { offset: 1, color: '#fadb14' }
                    ])
                },
                label: { show: true, position: 'right', formatter: '¥{c}' }
            }]
        });

        window.addEventListener('resize', function(){
            chartMonthly.resize();
            chartCategory.resize();
            chartTop.resize();
            chartCustomer.resize();
        });
    </script>

</form>
</body>
</html>
