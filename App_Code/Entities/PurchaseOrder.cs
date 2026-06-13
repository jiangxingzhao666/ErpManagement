using System;
using System.Collections.Generic;

namespace Entities
{
    public class PurchaseOrder
    {
        public long id { get; set; }
        public string orderNo { get; set; }
        public long supplierId { get; set; }
        public decimal totalAmount { get; set; }
        public string status { get; set; }
        public string remark { get; set; }
        public long createdBy { get; set; }
        public DateTime createdAt { get; set; }
        public DateTime? updatedAt { get; set; }

        public Supplier supplier { get; set; }
        public List<PurchaseOrderItem> items { get; set; }
    }
}
