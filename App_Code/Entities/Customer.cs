using System;

namespace Entities
{
    public class Customer
    {
        public long id { get; set; }
        public string name { get; set; }
        public string phone { get; set; }
        public string email { get; set; }
        public string address { get; set; }
        public string memberLevel { get; set; }
        public decimal totalSpent { get; set; }
        public DateTime createdAt { get; set; }
        public DateTime? updatedAt { get; set; }
    }
}
