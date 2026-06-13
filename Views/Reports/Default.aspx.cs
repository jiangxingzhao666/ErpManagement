using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.UI;
using Services;
using Helpers;
using Entities;

namespace Views
{
    public partial class Reports : Page
    {
        protected string monthlyLabels = "[]";
        protected string monthlySales = "[]";
        protected string monthlyCounts = "[]";
        protected string topNames = "[]";
        protected string topQuantities = "[]";
        protected string categoryData = "[]";
        protected string customerNames = "[]";
        protected string customerAmounts = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireRole("管理员,店长");
            var role = AuthHelper.GetRole();
            sidebar.InnerHtml = Helpers.SidebarHelper.Build("reports", role);
            litUserInfo.Text = AuthHelper.GetDisplayName() + " (" + role + ")";
            pnlLoggedIn.Visible = true;

            if (!IsPostBack)
                LoadReportData();
        }

        private void LoadReportData()
        {
            var js = new JavaScriptSerializer();
            var svc = new SalesService();

            var sales = svc.GetAllCompleted();
            litTotalSales.Text = sales.Sum(o => o.actualAmount).ToString("F0");
            litOrderCount.Text = sales.Count.ToString();
            litAvgAmount.Text = sales.Count > 0 ? (sales.Sum(o => o.actualAmount) / sales.Count).ToString("F0") : "0";
            litTotalDiscount.Text = sales.Sum(o => o.discountAmount).ToString("F0");

            var monthly = sales.GroupBy(o => new { o.createdAt.Year, o.createdAt.Month })
                .OrderBy(g => g.Key.Year).ThenBy(g => g.Key.Month)
                .Select(g => new
                {
                    Label = g.Key.Year + "-" + g.Key.Month.ToString("D2"),
                    Amount = g.Sum(o => o.actualAmount),
                    Count = g.Count()
                }).ToList();

            monthlyLabels = js.Serialize(monthly.Select(m => m.Label));
            monthlySales = js.Serialize(monthly.Select(m => m.Amount));
            monthlyCounts = js.Serialize(monthly.Select(m => m.Count));

            var allItems = svc.GetAllSaleItems();
            var topProducts = allItems
                .GroupBy(i => new { i.productId, i.product.name })
                .Select(g => new { Name = g.Key.name, Qty = g.Sum(i => i.quantity) })
                .OrderByDescending(g => g.Qty)
                .Take(10).ToList();

            topNames = js.Serialize(topProducts.Select(p => p.Name));
            topQuantities = js.Serialize(topProducts.Select(p => p.Qty));

            var categorySales = allItems
                .GroupBy(i => i.product?.category?.name ?? "其他")
                .Select(g => new { name = g.Key, value = g.Sum(i => i.quantity) })
                .OrderByDescending(g => g.value)
                .ToList();
            categoryData = js.Serialize(categorySales);

            var cusSvc = new CustomerService();
            var topCustomers = cusSvc.GetTopBySpending(10);
            customerNames = js.Serialize(topCustomers.Select(c => c.name));
            customerAmounts = js.Serialize(topCustomers.Select(c => c.totalSpent));
        }

        protected void BtnExport_Click(object sender, EventArgs e)
        {
            var svc = new SalesService();
            var orders = svc.GetAllCompletedWithDetails();
            var cusSvc = new CustomerService();

            if (ddlFormat.SelectedValue == "csv")
            {
                ExportCsv(orders);
            }
            else
            {
                ExportExcel(orders, svc, cusSvc);
            }
        }

        private void ExportCsv(List<SalesOrder> orders)
        {
            var sb = new StringBuilder();
            sb.AppendLine("订单号,日期,客户,支付方式,商品,数量,单价,小计,总金额,优惠,实收");

            foreach (var order in orders)
            {
                var date = order.createdAt.ToString("yyyy-MM-dd HH:mm");
                var customer = order.customer?.name ?? "散客";
                var payment = order.paymentMethod ?? "";

                if (order.items != null && order.items.Count > 0)
                {
                    foreach (var item in order.items)
                    {
                        var productName = item.product?.name ?? "";
                        if (productName.Contains(",")) productName = "\"" + productName + "\"";
                        sb.AppendFormat("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10}",
                            order.orderNo, date, customer, payment,
                            productName, item.quantity, item.unitPrice, item.subTotal,
                            order.totalAmount, order.discountAmount, order.actualAmount);
                        sb.AppendLine();
                    }
                }
                else
                {
                    sb.AppendFormat("{0},{1},{2},{3},,,,,{4},{5},{6}",
                        order.orderNo, date, customer, payment,
                        order.totalAmount, order.discountAmount, order.actualAmount);
                    sb.AppendLine();
                }
            }

            var bytes = Encoding.UTF8.GetBytes(sb.ToString());
            var bom = Encoding.UTF8.GetPreamble();
            Response.Clear();
            Response.ContentType = "text/csv; charset=utf-8";
            Response.AddHeader("Content-Disposition", "attachment; filename=SalesReport_" + DateTime.Now.ToString("yyyyMMdd") + ".csv");
            Response.BinaryWrite(bom);
            Response.BinaryWrite(bytes);
            Response.End();
        }

        private void ExportExcel(List<SalesOrder> orders, SalesService svc, CustomerService cusSvc)
        {
            var xlsx = new XlsxWriterHelper();
            var drawingRefs = new List<string>();

            // ========== Sheet 1: 销售明细 ==========
            var rows = new List<string[]>();
            rows.Add(new[] { "订单号", "日期", "客户", "支付方式", "商品", "数量", "单价", "小计", "总金额", "优惠", "实收" });
            foreach (var order in orders)
            {
                var date = order.createdAt.ToString("yyyy-MM-dd HH:mm");
                var customer = order.customer?.name ?? "散客";
                var payment = order.paymentMethod ?? "";
                if (order.items != null && order.items.Count > 0)
                {
                    foreach (var item in order.items)
                    {
                        rows.Add(new[] {
                            order.orderNo, date, customer, payment, item.product?.name ?? "",
                            item.quantity.ToString(), item.unitPrice.ToString("F2"), item.subTotal.ToString("F2"),
                            order.totalAmount.ToString("F2"), order.discountAmount.ToString("F2"), order.actualAmount.ToString("F2")
                        });
                    }
                }
                else
                {
                    rows.Add(new[] { order.orderNo, date, customer, payment, "", "", "", "",
                        order.totalAmount.ToString("F2"), order.discountAmount.ToString("F2"), order.actualAmount.ToString("F2") });
                }
            }
            xlsx.AddEntry("xl/worksheets/sheet1.xml",
                XlsxWriterHelper.BuildSheetDataXml(rows, new[] { 16, 16, 10, 8, 22, 6, 8, 10, 10, 8, 10 }, null, "销售明细报告"));

            // ========== Sheet 2: 月度销售趋势 ==========
            var monthly = orders.GroupBy(o => new { o.createdAt.Year, o.createdAt.Month })
                .OrderBy(g => g.Key.Year).ThenBy(g => g.Key.Month)
                .Select(g => new { L = g.Key.Year + "-" + g.Key.Month.ToString("D2"), A = g.Sum(o => o.actualAmount) })
                .ToList();

            var chartRows2 = new List<string[]>();
            chartRows2.Add(new[] { "月份", "销售额" });
            foreach (var m in monthly) chartRows2.Add(new[] { m.L, m.A.ToString("F2") });

            var draw2 = xlsx.AddChartImage("月度销售趋势",
                monthly.Select(m => m.L).ToArray(),
                monthly.Select(m => m.A).ToArray());
            drawingRefs.Add(draw2);

            xlsx.AddEntry("xl/worksheets/sheet2.xml",
                XlsxWriterHelper.BuildSheetDataXml(chartRows2, new[] { 14, 14 }, draw2, "月度销售趋势报告"));
            var r2 = XlsxWriterHelper.BuildSheetRelsXml(draw2);
            if (r2 != null) xlsx.AddEntry("xl/worksheets/_rels/sheet2.xml.rels", r2);

            // ========== Sheet 3: 商品销量排行 ==========
            var allItems = svc.GetAllSaleItems();
            var topProds = allItems.GroupBy(i => new { i.productId, i.product?.name })
                .Select(g => new { N = g.Key.name ?? "", Q = g.Sum(i => i.quantity) })
                .OrderByDescending(g => g.Q).Take(10).ToList();

            var chartRows3 = new List<string[]>();
            chartRows3.Add(new[] { "商品", "销量" });
            foreach (var p in topProds) chartRows3.Add(new[] { p.N, p.Q.ToString() });

            var draw3 = xlsx.AddChartImage("商品销量 TOP 10",
                topProds.Select(p => p.N).ToArray(),
                topProds.Select(p => (decimal)p.Q).ToArray());
            drawingRefs.Add(draw3);

            xlsx.AddEntry("xl/worksheets/sheet3.xml",
                XlsxWriterHelper.BuildSheetDataXml(chartRows3, new[] { 22, 14 }, draw3, "商品销量 TOP 10 报告"));
            var r3 = XlsxWriterHelper.BuildSheetRelsXml(draw3);
            if (r3 != null) xlsx.AddEntry("xl/worksheets/_rels/sheet3.xml.rels", r3);

            // ========== Sheet 4: 客户消费排行 ==========
            var topCus = cusSvc.GetTopBySpending(10);
            var chartRows4 = new List<string[]>();
            chartRows4.Add(new[] { "客户", "累计消费" });
            foreach (var c in topCus) chartRows4.Add(new[] { c.name, c.totalSpent.ToString("F2") });

            var draw4 = xlsx.AddChartImage("客户消费排行 TOP 10",
                topCus.Select(c => c.name).ToArray(),
                topCus.Select(c => c.totalSpent).ToArray());
            drawingRefs.Add(draw4);

            xlsx.AddEntry("xl/worksheets/sheet4.xml",
                XlsxWriterHelper.BuildSheetDataXml(chartRows4, new[] { 20, 14 }, draw4, "客户消费排行 TOP 10 报告"));
            var r4 = XlsxWriterHelper.BuildSheetRelsXml(draw4);
            if (r4 != null) xlsx.AddEntry("xl/worksheets/_rels/sheet4.xml.rels", r4);

            // ========== Sheet 5: 分类销量 ==========
            var catSales = allItems.GroupBy(i => i.product?.category?.name ?? "其他")
                .Select(g => new { N = g.Key, Q = g.Sum(i => i.quantity) })
                .OrderByDescending(g => g.Q).ToList();

            var chartRows5 = new List<string[]>();
            chartRows5.Add(new[] { "分类", "销量" });
            foreach (var c in catSales) chartRows5.Add(new[] { c.N, c.Q.ToString() });

            var draw5 = xlsx.AddChartImage("分类销量分布",
                catSales.Select(c => c.N).ToArray(),
                catSales.Select(c => (decimal)c.Q).ToArray());
            drawingRefs.Add(draw5);

            xlsx.AddEntry("xl/worksheets/sheet5.xml",
                XlsxWriterHelper.BuildSheetDataXml(chartRows5, new[] { 20, 14 }, draw5, "分类销量分布报告"));
            var r5 = XlsxWriterHelper.BuildSheetRelsXml(draw5);
            if (r5 != null) xlsx.AddEntry("xl/worksheets/_rels/sheet5.xml.rels", r5);

            // ========== Structural ==========
            var sheetNames = new List<string> { "销售明细", "月度趋势", "商品排行", "客户排行", "分类分布" };
            xlsx.AddEntry("[Content_Types].xml", XlsxWriterHelper.BuildContentTypesXml(sheetNames, drawingRefs.Count));
            xlsx.AddEntry("_rels/.rels", XlsxWriterHelper.BuildRelsXml());
            xlsx.AddEntry("xl/workbook.xml", XlsxWriterHelper.BuildWorkbookXml(sheetNames));
            xlsx.AddEntry("xl/_rels/workbook.xml.rels", XlsxWriterHelper.BuildWorkbookRelsXml(sheetNames, drawingRefs));
            xlsx.AddEntry("xl/styles.xml", XlsxWriterHelper.BuildStylesXml());

            xlsx.WriteToResponse("SalesReport_" + DateTime.Now.ToString("yyyyMMdd") + ".xlsx");
        }

        protected void BtnLogout_Click(object sender, EventArgs e)
        {
            AuthHelper.Logout();
            Response.Redirect("../Products/Default.aspx");
        }
    }
}
