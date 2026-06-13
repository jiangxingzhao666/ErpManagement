using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using Entities;

namespace Services
{
    public class ShipmentService
    {
        public List<Shipment> GetAll(int page, int pageSize)
        {
            using (var db = new ErpDbContext())
            {
                return db.Shipments
                    .Include("salesOrder.customer")
                    .OrderByDescending(s => s.id)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();
            }
        }

        public Shipment GetById(int id)
        {
            using (var db = new ErpDbContext())
            {
                return db.Shipments
                    .Include("salesOrder.customer")
                    .Include("salesOrder.items.product")
                    .FirstOrDefault(s => s.id == id);
            }
        }

        public Shipment GetBySalesOrderId(long salesOrderId)
        {
            using (var db = new ErpDbContext())
            {
                return db.Shipments
                    .FirstOrDefault(s => s.salesOrderId == salesOrderId);
            }
        }

        public int Add(Shipment shipment)
        {
            using (var db = new ErpDbContext())
            {
                shipment.trackingNumber = GenerateTrackingNo(db);
                shipment.status = "待发货";
                shipment.createdAt = DateTime.Now;
                db.Shipments.Add(shipment);
                return db.SaveChanges();
            }
        }

        public int Update(Shipment shipment)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Shipments.Find(shipment.id);
                exist.carrier = shipment.carrier;
                exist.recipientName = shipment.recipientName;
                exist.recipientPhone = shipment.recipientPhone;
                exist.recipientAddress = shipment.recipientAddress;
                exist.shippingFee = shipment.shippingFee;
                exist.status = shipment.status;
                exist.remark = shipment.remark;
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        public int UpdateStatus(int id, string status)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Shipments.Find(id);
                exist.status = status;
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        private string GenerateTrackingNo(ErpDbContext db)
        {
            var today = DateTime.Now.ToString("yyyyMMdd");
            var prefix = "KD" + today;
            var todayList = db.Shipments
                .Where(s => s.trackingNumber.StartsWith(prefix))
                .ToList();
            int seq = 1;
            if (todayList.Count > 0)
            {
                var maxNo = todayList.Max(s => s.trackingNumber);
                seq = int.Parse(maxNo.Substring(maxNo.Length - 4)) + 1;
            }
            return prefix + seq.ToString("D4");
        }
    }
}
