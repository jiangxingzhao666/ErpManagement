using System;

namespace Entities
{
    public class Shipment
    {
        public long id { get; set; }
        public long salesOrderId { get; set; }
        public string trackingNumber { get; set; }
        public string carrier { get; set; }
        public string recipientName { get; set; }
        public string recipientPhone { get; set; }
        public string recipientAddress { get; set; }
        public decimal shippingFee { get; set; }
        public string status { get; set; }
        public string remark { get; set; }
        public DateTime createdAt { get; set; }
        public DateTime? updatedAt { get; set; }

        public SalesOrder salesOrder { get; set; }
    }
}
