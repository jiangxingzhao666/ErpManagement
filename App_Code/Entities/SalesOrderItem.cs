using System;

namespace Entities
{
    public class SalesOrderItem
    {
        public long id { get; set; }
        public long salesOrderId { get; set; }
        public long productId { get; set; }
        public int quantity { get; set; }
        public decimal unitPrice { get; set; }
        public decimal subTotal { get; set; }
        public DateTime createdAt { get; set; }
        public DateTime? updatedAt { get; set; }

        public SalesOrder salesOrder { get; set; }
        public Product product { get; set; }
    }
}
