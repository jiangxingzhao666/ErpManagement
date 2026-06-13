using System.Text;

namespace Helpers
{
    public class SidebarHelper
    {
        public static string Build(string active, string role)
        {
            var isStaff = AuthHelper.IsStaff();
            var sb = new StringBuilder();

            if (!isStaff)
            {
                sb.Append("<div class='menu-title'>基础数据</div>");
                sb.Append("<a href='Default.aspx' class='" + (active == "products" ? "active" : "") + "'>商品管理</a>");
                sb.Append("<a href='Categories.aspx' class='" + (active == "categories" ? "active" : "") + "'>分类管理</a>");
                sb.Append("<a href='Suppliers.aspx' class='" + (active == "suppliers" ? "active" : "") + "'>供应商管理</a>");
                sb.Append("<a href='Customers.aspx' class='" + (active == "customers" ? "active" : "") + "'>客户管理</a>");
                sb.Append("<div class='menu-title'>后台业务管理</div>");
                sb.Append("<a href='Purchases.aspx' class='" + (active == "purchases" ? "active" : "") + "'>进货管理</a>");
                sb.Append("<a href='Sales.aspx' class='" + (active == "sales" ? "active" : "") + "'>销售管理</a>");
                sb.Append("<div class='menu-title'>统计报表</div>");
                sb.Append("<a href='StockAlert.aspx' class='" + (active == "stock" ? "active" : "") + "'>库存预警</a>");
                sb.Append("<a href='Reports.aspx' class='" + (active == "reports" ? "active" : "") + "'>销售报表</a>");
                sb.Append("<div class='menu-title'>系统设置</div>");
                sb.Append("<a href='Users.aspx' class='" + (active == "users" ? "active" : "") + "'>用户管理</a>");
            }

            sb.Append("<div class='menu-title'>门店业务</div>");
            sb.Append("<a href='Cart.aspx' class='" + (active == "cart" ? "active" : "") + "'>购物车</a>");

            return sb.ToString();
        }
    }
}
