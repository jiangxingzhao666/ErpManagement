using System;

namespace Entities
{
    public class Product
    {
        public long id { get; set; }
        public string code { get; set; }
        public string name { get; set; }
        public long categoryId { get; set; }
        public long? supplierId { get; set; }
        public string unit { get; set; }
        public decimal purchasePrice { get; set; }
        public decimal sellingPrice { get; set; }
        public int stockQuantity { get; set; }
        public int minStock { get; set; }
        public string imagePath { get; set; }
        public string description { get; set; }
        public bool isActive { get; set; }
        public DateTime createdAt { get; set; }
        public DateTime? updatedAt { get; set; }

        public Category category { get; set; }
        public Supplier supplier { get; set; }
    }
}
