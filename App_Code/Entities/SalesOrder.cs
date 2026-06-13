using System;
using System.Collections.Generic;

namespace Entities
{
    public class SalesOrder
    {
        public long id { get; set; }
        public string orderNo { get; set; }
        public long? customerId { get; set; }
        public decimal totalAmount { get; set; }
        public decimal discountAmount { get; set; }
        public decimal actualAmount { get; set; }
        public string paymentMethod { get; set; }
        public string status { get; set; }
        public string remark { get; set; }
        public long createdBy { get; set; }
        public DateTime createdAt { get; set; }
        public DateTime? updatedAt { get; set; }

        public Customer customer { get; set; }
        public List<SalesOrderItem> items { get; set; }
    }
}
