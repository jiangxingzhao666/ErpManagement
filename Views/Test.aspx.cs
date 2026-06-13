using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Entities;
using Services;

namespace DefaultNamespace
{
    public partial class Test : Page
    {
        protected void OutputLine(string msg, string cls = "log-info")
        {
            output.InnerHtml += $"<span class=\"{cls}\">{DateTime.Now:HH:mm:ss}  {msg}</span>\n";
        }

        protected void OutputDivider()
        {
            output.InnerHtml += "----------------------------------------\n";
        }

        #region 1. Categories

        protected void BtnCatQuery_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new CategoryService();
                var list = svc.GetAll();
                OutputLine($"查询成功，共 {list.Count} 条", "log-success");
                foreach (var c in list)
                    OutputLine($"  ID={c.id}, Name={c.name}, Desc={c.description}");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnCatAdd_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new CategoryService();
                svc.Add(new Category { name = "测试分类_" + DateTime.Now.Ticks, description = "自动测试新增" });
                OutputLine("新增成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnCatUpdate_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new CategoryService();
                var list = svc.GetAll();
                if (list.Count == 0) { OutputLine("无数据可修改", "log-error"); return; }
                var first = list[0];
                svc.Update(new Category { id = first.id, name = "已修改_" + DateTime.Now.ToString("HHmmss"), description = "已修改描述" });
                OutputLine($"修改 ID={first.id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnCatDel_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new CategoryService();
                var list = svc.GetAll();
                if (list.Count == 0) { OutputLine("无数据可删除", "log-error"); return; }
                var last = list[list.Count - 1];
                svc.Delete((int)last.id);
                OutputLine($"删除 ID={last.id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        #endregion

        #region 2. Suppliers

        protected void BtnSupQuery_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new SupplierService();
                var list = svc.GetAll(null, 1, 100);
                OutputLine($"查询成功，共 {list.Count} 条", "log-success");
                foreach (var s in list)
                    OutputLine($"  ID={s.id}, Name={s.name}, Contact={s.contactPerson}, Phone={s.phone}");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnSupAdd_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new SupplierService();
                svc.Add(new Supplier { name = "测试供应商_" + DateTime.Now.Ticks, contactPerson = "张三", phone = "13800000000", email = "test@test.com", address = "测试地址", remark = "自动测试" });
                OutputLine("新增成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnSupUpdate_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new SupplierService();
                var list = svc.GetAll(null, 1, 100);
                if (list.Count == 0) { OutputLine("无数据可修改", "log-error"); return; }
                var first = list[0];
                svc.Update(new Supplier { id = first.id, name = first.name + "_已改", contactPerson = first.contactPerson, phone = first.phone, email = first.email, address = first.address, remark = "已修改" });
                OutputLine($"修改 ID={first.id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnSupDel_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new SupplierService();
                var list = svc.GetAll(null, 1, 100);
                if (list.Count == 0) { OutputLine("无数据可删除", "log-error"); return; }
                var last = list[list.Count - 1];
                svc.Delete((int)last.id);
                OutputLine($"删除 ID={last.id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        #endregion

        #region 3. Products

        protected void BtnProdQuery_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new ProductService();
                var list = svc.GetAll(null, null, 1, 100);
                OutputLine($"查询成功，共 {list.Count} 条", "log-success");
                foreach (var p in list)
                    OutputLine($"  ID={p.id}, Code={p.code}, Name={p.name}, Stock={p.stockQuantity}, Price={p.sellingPrice}, Category={p.category?.name}");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnProdAdd_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var catSvc = new CategoryService();
                var cats = catSvc.GetAll();
                if (cats.Count == 0) { OutputLine("请先新增分类", "log-error"); return; }
                var svc = new ProductService();
                svc.Add(new Product
                {
                    code = "TEST" + DateTime.Now.ToString("HHmmss"),
                    name = "测试商品_" + DateTime.Now.Ticks,
                    categoryId = cats[0].id,
                    unit = "个",
                    purchasePrice = 5.0m,
                    sellingPrice = 8.0m,
                    stockQuantity = 100,
                    minStock = 10,
                    description = "自动测试新增"
                });
                OutputLine("新增成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnProdUpdate_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new ProductService();
                var list = svc.GetAll(null, null, 1, 100);
                if (list.Count == 0) { OutputLine("无数据可修改", "log-error"); return; }
                var first = list[0];
                var exist = svc.GetById((int)first.id);
                svc.Update(new Product
                {
                    id = exist.id,
                    code = exist.code,
                    name = exist.name + "_已改",
                    categoryId = exist.categoryId,
                    supplierId = exist.supplierId,
                    unit = exist.unit,
                    purchasePrice = exist.purchasePrice + 1,
                    sellingPrice = exist.sellingPrice + 1,
                    stockQuantity = exist.stockQuantity,
                    minStock = exist.minStock,
                    imagePath = exist.imagePath,
                    description = "已修改"
                });
                OutputLine($"修改 ID={first.id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnProdDel_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new ProductService();
                var list = svc.GetAll(null, null, 1, 100);
                if (list.Count == 0) { OutputLine("无数据可删除", "log-error"); return; }
                svc.Delete((int)list[0].id);
                OutputLine($"软删除 ID={list[0].id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnStockAlert_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new ProductService();
                var list = svc.GetStockAlerts();
                OutputLine($"库存预警查询成功，共 {list.Count} 条", list.Count > 0 ? "log-error" : "log-success");
                foreach (var p in list)
                    OutputLine($"  ⚠ ID={p.id}, {p.name}, 当前库存={p.stockQuantity}, 最低库存={p.minStock}");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        #endregion

        #region 4. Customers

        protected void BtnCusQuery_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new CustomerService();
                var list = svc.GetAll(null, 1, 100);
                OutputLine($"查询成功，共 {list.Count} 条", "log-success");
                foreach (var c in list)
                    OutputLine($"  ID={c.id}, Name={c.name}, Phone={c.phone}, Level={c.memberLevel}, Spent={c.totalSpent}");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnCusAdd_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new CustomerService();
                svc.Add(new Customer { name = "测试客户_" + DateTime.Now.Ticks, phone = "13900000000", email = "cus@test.com", address = "测试地址" });
                OutputLine("新增成功（默认等级=普通，累计消费=0）", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnCusUpdate_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new CustomerService();
                var list = svc.GetAll(null, 1, 100);
                if (list.Count == 0) { OutputLine("无数据可修改", "log-error"); return; }
                var first = list[0];
                svc.Update(new Customer { id = first.id, name = first.name + "_已改", phone = first.phone, email = first.email, address = first.address, memberLevel = "银卡" });
                OutputLine($"修改 ID={first.id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnCusDel_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new CustomerService();
                var list = svc.GetAll(null, 1, 100);
                if (list.Count == 0) { OutputLine("无数据可删除", "log-error"); return; }
                var last = list[list.Count - 1];
                svc.Delete((int)last.id);
                OutputLine($"删除 ID={last.id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        #endregion

        #region 5. PurchaseOrders

        protected void BtnPurQuery_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new PurchaseService();
                var list = svc.GetAll(null, 1, 100);
                OutputLine($"查询成功，共 {list.Count} 条", "log-success");
                foreach (var o in list)
                    OutputLine($"  ID={o.id}, OrderNo={o.orderNo}, Supplier={o.supplier?.name}, Amount={o.totalAmount}, Status={o.status}");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnPurCreate_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var prodSvc = new ProductService();
                var supSvc = new SupplierService();
                var userSvc = new UserService();
                var products = prodSvc.GetAll(null, null, 1, 100);
                var suppliers = supSvc.GetAll(null, 1, 100);
                var users = userSvc.GetAll();
                if (products.Count == 0) { OutputLine("请先新增商品", "log-error"); return; }
                if (suppliers.Count == 0) { OutputLine("请先新增供应商", "log-error"); return; }
                if (users.Count == 0) { OutputLine("请先新增用户", "log-error"); return; }

                var items = new List<PurchaseOrderItem>
                {
                    new PurchaseOrderItem { productId = products[0].id, quantity = 10 },
                    new PurchaseOrderItem { productId = products.Count > 1 ? products[1].id : products[0].id, quantity = 5 }
                };

                var svc = new PurchaseService();
                svc.CreateOrder(new PurchaseOrder { supplierId = suppliers[0].id, remark = "测试进货单" }, items, users[0].id);
                OutputLine("新建进货单成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnPurConfirm_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new PurchaseService();
                var list = svc.GetAll("待入库", 1, 100);
                if (list.Count == 0) { OutputLine("无待入库单据", "log-error"); return; }
                var last = list[list.Count - 1];
                svc.ConfirmStockIn((int)last.id);
                OutputLine($"确认入库 ID={last.id} 成功，库存已更新", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnPurCancel_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new PurchaseService();
                var list = svc.GetAll("待入库", 1, 100);
                if (list.Count == 0) { OutputLine("无待入库单据可取消", "log-error"); return; }
                var last = list[list.Count - 1];
                svc.CancelOrder((int)last.id);
                OutputLine($"取消进货单 ID={last.id} 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        #endregion

        #region 6. SalesOrders

        protected void BtnSaleQuery_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new SalesService();
                var list = svc.GetAll(1, 100);
                OutputLine($"查询成功，共 {list.Count} 条", "log-success");
                foreach (var o in list)
                    OutputLine($"  ID={o.id}, OrderNo={o.orderNo}, Customer={o.customer?.name}, Total={o.totalAmount}, Actual={o.actualAmount}, Status={o.status}");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnSaleCreate_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var prodSvc = new ProductService();
                var cusSvc = new CustomerService();
                var userSvc = new UserService();
                var products = prodSvc.GetAll(null, null, 1, 100);
                var customers = cusSvc.GetAll(null, 1, 100);
                var users = userSvc.GetAll();
                if (products.Count == 0) { OutputLine("请先新增商品", "log-error"); return; }
                if (users.Count == 0) { OutputLine("请先新增用户", "log-error"); return; }

                var sellProduct = products.FirstOrDefault(p => p.stockQuantity >= 3);
                if (sellProduct == null) { OutputLine("无库存充足的可用商品（需库存≥3）", "log-error"); return; }

                var items = new List<SalesOrderItem>
                {
                    new SalesOrderItem { productId = sellProduct.id, quantity = 2 }
                };

                long? customerId = null;
                if (customers.Count > 0) customerId = customers[0].id;

                var svc = new SalesService();
                int result = svc.CreateSale(
                    new SalesOrder { customerId = customerId, discountAmount = 1.0m, paymentMethod = "现金", remark = "测试销售单" },
                    items, users[0].id);

                if (result == -1)
                    OutputLine("创建失败: 库存不足", "log-error");
                else
                    OutputLine($"创建成功，扣减 {sellProduct.name} ×2，客户会员等级自动更新", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        #endregion

        #region 7. Users

        protected void BtnUserQuery_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new UserService();
                var list = svc.GetAll();
                OutputLine($"查询成功，共 {list.Count} 条", "log-success");
                foreach (var u in list)
                    OutputLine($"  ID={u.id}, Username={u.username}, DisplayName={u.displayName}, Role={u.role}, IsActive={u.isActive}, LastLogin={u.lastLoginAt}");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnUserAdd_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new UserService();
                svc.Add(new User { username = "test" + DateTime.Now.ToString("HHmmss"), passwordHash = "123456", displayName = "测试用户", role = "操作员" });
                OutputLine("新增成功（密码=123456，加盐存储）", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnUserLogin_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new UserService();
                var user = svc.Login("admin", "admin123");
                if (user != null)
                    OutputLine($"登录成功: {user.displayName}({user.role}), LastLogin已更新", "log-success");
                else
                    OutputLine("登录失败: 账号或密码错误", "log-error");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        protected void BtnUserDel_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new UserService();
                var list = svc.GetAll();
                var last = list.LastOrDefault(u => u.username.StartsWith("test"));
                if (last == null) { OutputLine("无测试用户可删除", "log-error"); return; }
                svc.Delete((int)last.id);
                OutputLine($"软删除用户 ID={last.id} ({last.username}) 成功", "log-success");
            }
            catch (Exception ex) { OutputLine($"失败: {ex.Message}", "log-error"); }
        }

        #endregion

        #region 8. Token

        protected void BtnTokenTest_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var isLogin = Helpers.AuthHelper.IsLogin();
                OutputLine("登录状态: " + (isLogin ? "已登录" : "未登录"), isLogin ? "log-success" : "log-error");
                if (isLogin)
                {
                    OutputLine("  用户ID: " + Helpers.AuthHelper.GetUserId());
                    OutputLine("  角色: " + Helpers.AuthHelper.GetRole());
                    OutputLine("  显示名: " + Helpers.AuthHelper.GetDisplayName());
                }
                var sessionToken = Session["AuthToken"] as string;
                OutputLine("Session Token: " + (sessionToken ?? "无"));
                var cookieToken = Request.Cookies["AuthToken"]?.Value;
                OutputLine("Cookie Token: " + (cookieToken ?? "无"));
                if (!string.IsNullOrEmpty(sessionToken))
                {
                    var info = Helpers.TokenHelper.ValidateToken(sessionToken);
                    OutputLine("Token 有效性: " + (info != null ? "有效 (过期: " + info.ExpiresAt + ")" : "无效或已过期"), info != null ? "log-success" : "log-error");
                }
            }
            catch (Exception ex) { OutputLine("失败: " + ex.Message, "log-error"); }
        }

        protected void BtnTokenClean_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var before = (Application["ActiveTokens"] as List<string>)?.Count ?? 0;
                Helpers.TokenHelper.RemoveExpiredTokens();
                var after = (Application["ActiveTokens"] as List<string>)?.Count ?? 0;
                OutputLine("清理完成: " + before + " → " + after + " (清理 " + (before - after) + " 个)", "log-success");
            }
            catch (Exception ex) { OutputLine("失败: " + ex.Message, "log-error"); }
        }

        #endregion

        #region 9. 综合全测

        protected void BtnAll_Click(object sender, EventArgs e)
        {
            OutputDivider();
            OutputLine("=== 开始逐模块测试 ===", "log-info");

            // Categories
            try { var list = new CategoryService().GetAll(); OutputLine("[Categories] 查询成功 " + list.Count + " 条", "log-success"); } catch (Exception ex) { OutputLine("[Categories] 失败: " + ex.Message, "log-error"); }
            // Suppliers
            try { var list = new SupplierService().GetAll(null, 1, 100); OutputLine("[Suppliers] 查询成功 " + list.Count + " 条", "log-success"); } catch (Exception ex) { OutputLine("[Suppliers] 失败: " + ex.Message, "log-error"); }
            // Products
            try { var list = new ProductService().GetAll(null, null, 1, 100); OutputLine("[Products] 查询成功 " + list.Count + " 条", "log-success"); } catch (Exception ex) { OutputLine("[Products] 失败: " + ex.Message, "log-error"); }
            // Customers
            try { var list = new CustomerService().GetAll(null, 1, 100); OutputLine("[Customers] 查询成功 " + list.Count + " 条", "log-success"); } catch (Exception ex) { OutputLine("[Customers] 失败: " + ex.Message, "log-error"); }
            // PurchaseOrders
            try { var list = new PurchaseService().GetAll(null, 1, 100); OutputLine("[PurchaseOrders] 查询成功 " + list.Count + " 条", "log-success"); } catch (Exception ex) { OutputLine("[PurchaseOrders] 失败: " + ex.Message, "log-error"); }
            // SalesOrders
            try { var list = new SalesService().GetAll(1, 100); OutputLine("[SalesOrders] 查询成功 " + list.Count + " 条", "log-success"); } catch (Exception ex) { OutputLine("[SalesOrders] 失败: " + ex.Message, "log-error"); }
            // Users
            try { var list = new UserService().GetAll(); OutputLine("[Users] 查询成功 " + list.Count + " 条", "log-success"); } catch (Exception ex) { OutputLine("[Users] 失败: " + ex.Message, "log-error"); }
            // Token
            try { OutputLine("[Token] 登录状态: " + (Helpers.AuthHelper.IsLogin() ? "已登录" : "未登录"), "log-success"); } catch (Exception ex) { OutputLine("[Token] 失败: " + ex.Message, "log-error"); }

            OutputLine("=== 测试完成 ===", "log-info");
        }

        protected void BtnUserInactive_Click(object sender, EventArgs e)
        {
            OutputDivider();
            try
            {
                var svc = new UserService();
                var list = svc.GetAll(true);
                OutputLine("查询成功（含禁用），共 " + list.Count + " 条", "log-success");
                foreach (var u in list)
                    OutputLine("  ID=" + u.id + ", " + u.username + ", " + u.displayName + ", " + u.role + ", Active=" + u.isActive, u.isActive ? "log-success" : "log-error");
            }
            catch (Exception ex) { OutputLine("失败: " + ex.Message, "log-error"); }
        }

        #endregion
    }
}
