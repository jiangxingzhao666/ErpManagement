using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using Entities;

namespace Services
{
    public class PurchaseService
    {
        public List<PurchaseOrder> GetAll(string status, int page, int pageSize)
        {
            using (var db = new ErpDbContext())
            {
                var query = db.PurchaseOrders.Include("supplier").AsQueryable();
                if (!string.IsNullOrEmpty(status))
                    query = query.Where(o => o.status == status);
                return query
                    .OrderByDescending(o => o.id)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();
            }
        }

        public PurchaseOrder GetById(int id)
        {
            using (var db = new ErpDbContext())
            {
                return db.PurchaseOrders
                    .Include("supplier")
                    .Include("items.product")
                    .FirstOrDefault(o => o.id == id);
            }
        }

        public int CreateOrder(PurchaseOrder order, List<PurchaseOrderItem> items, long userId)
        {
            using (var db = new ErpDbContext())
            {
                order.orderNo = GenerateOrderNo("JH", db);
                order.createdBy = userId;
                order.status = "待入库";
                order.createdAt = DateTime.Now;
                order.totalAmount = 0;

                foreach (var item in items)
                {
                    var product = db.Products.Find(item.productId);
                    item.unitPrice = product.purchasePrice;
                    item.subTotal = item.unitPrice * item.quantity;
                    item.createdAt = DateTime.Now;
                    order.totalAmount += item.subTotal;
                }

                order.items = items;
                db.PurchaseOrders.Add(order);
                return db.SaveChanges();
            }
        }

        public int ConfirmStockIn(int orderId)
        {
            using (var db = new ErpDbContext())
            {
                var order = db.PurchaseOrders
                    .Include("items")
                    .FirstOrDefault(o => o.id == orderId);

                if (order == null || order.status != "待入库")
                    return 0;

                foreach (var item in order.items)
                {
                    var product = db.Products.Find(item.productId);
                    product.stockQuantity += item.quantity;
                    product.purchasePrice = item.unitPrice;
                    product.updatedAt = DateTime.Now;
                }

                order.status = "已入库";
                order.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        public int CancelOrder(int orderId)
        {
            using (var db = new ErpDbContext())
            {
                var order = db.PurchaseOrders.Find(orderId);
                if (order == null || order.status != "待入库")
                    return 0;
                order.status = "已取消";
                order.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        private string GenerateOrderNo(string prefix, ErpDbContext db)
        {
            var today = DateTime.Now.ToString("yyyyMMdd");
            var todayOrders = db.PurchaseOrders
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
