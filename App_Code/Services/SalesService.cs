using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using Entities;

namespace Services
{
    public class SalesService
    {
        public List<SalesOrder> GetAll(int page, int pageSize)
        {
            using (var db = new ErpDbContext())
            {
                return db.SalesOrders
                    .Include("customer")
                    .OrderByDescending(o => o.id)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();
            }
        }

        public SalesOrder GetById(int id)
        {
            using (var db = new ErpDbContext())
            {
                return db.SalesOrders
                    .Include("customer")
                    .Include("items.product")
                    .FirstOrDefault(o => o.id == id);
            }
        }

        public List<SalesOrder> GetAllCompleted()
        {
            using (var db = new ErpDbContext())
            {
                return db.SalesOrders
                    .Include("customer")
                    .Where(o => o.status == "已完成")
                    .ToList();
            }
        }

        public List<SalesOrderItem> GetAllSaleItems()
        {
            using (var db = new ErpDbContext())
            {
                return db.SalesOrderItems
                    .Include("product.category")
                    .ToList();
            }
        }

        public List<SalesOrder> GetAllCompletedWithDetails()
        {
            using (var db = new ErpDbContext())
            {
                return db.SalesOrders
                    .Include("customer")
                    .Include("items.product")
                    .Where(o => o.status == "已完成")
                    .OrderBy(o => o.createdAt)
                    .ToList();
            }
        }

        public int CreateSale(SalesOrder order, List<SalesOrderItem> items, long userId)
        {
            using (var db = new ErpDbContext())
            {
                order.orderNo = GenerateOrderNo("XS", db);
                order.createdBy = userId;
                order.status = "已完成";
                order.createdAt = DateTime.Now;
                order.totalAmount = 0;
                order.actualAmount = 0;

                foreach (var item in items)
                {
                    var product = db.Products.Find(item.productId);
                    if (product.stockQuantity < item.quantity)
                        return -1;

                    product.stockQuantity -= item.quantity;
                    product.updatedAt = DateTime.Now;

                    item.unitPrice = product.sellingPrice;
                    item.subTotal = item.unitPrice * item.quantity;
                    item.createdAt = DateTime.Now;
                    order.totalAmount += item.subTotal;
                }

                order.actualAmount = order.totalAmount - order.discountAmount;

                if (order.customerId.HasValue)
                {
                    var customer = db.Customers.Find(order.customerId.Value);
                    customer.totalSpent += order.actualAmount;
                    customer.updatedAt = DateTime.Now;

                    if (customer.totalSpent >= 10000m)
                        customer.memberLevel = "金卡";
                    else if (customer.totalSpent >= 5000m)
                        customer.memberLevel = "银卡";
                    else
                        customer.memberLevel = "普通";
                }

                order.items = items;
                db.SalesOrders.Add(order);
                db.SaveChanges();
                return (int)order.id;
            }
        }

        private string GenerateOrderNo(string prefix, ErpDbContext db)
        {
            var today = DateTime.Now.ToString("yyyyMMdd");
            var todayOrders = db.SalesOrders
                .Where(o => o.orderNo.StartsWith(prefix + today))
                .ToList();
            int seq = 1;
            if (todayOrders.Count > 0)
            {
                var maxNo = todayOrders.Max(o => o.orderNo);
                var lastSeq = maxNo.Substring(maxNo.Length - 3);
                seq = int.Parse(lastSeq) + 1;
            }
            return prefix + today + seq.ToString("D3");
        }
    }
}
