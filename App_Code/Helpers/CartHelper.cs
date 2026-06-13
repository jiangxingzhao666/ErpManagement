using System;
using System.Collections.Generic;
using System.Web;

namespace Helpers
{
    [Serializable]
    public class CartItem
    {
        public long ProductId { get; set; }
        public string ProductName { get; set; }
        public string ProductCode { get; set; }
        public string Unit { get; set; }
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }
        public decimal SubTotal { get { return UnitPrice * Quantity; } }
        public int StockAvailable { get; set; }
    }

    public class CartHelper
    {
        private const string CartKey = "ShoppingCart";

        public static List<CartItem> GetCart()
        {
            var cart = HttpContext.Current.Session[CartKey] as List<CartItem>;
            if (cart == null)
            {
                cart = new List<CartItem>();
                HttpContext.Current.Session[CartKey] = cart;
            }
            return cart;
        }

        public static void AddItem(long productId, string productName, string productCode, string unit, decimal unitPrice, int quantity, int stockAvailable)
        {
            var cart = GetCart();
            var exist = cart.Find(c => c.ProductId == productId);
            if (exist != null)
            {
                exist.Quantity += quantity;
                exist.UnitPrice = unitPrice;
                exist.StockAvailable = stockAvailable;
            }
            else
            {
                cart.Add(new CartItem
                {
                    ProductId = productId,
                    ProductName = productName,
                    ProductCode = productCode,
                    Unit = unit,
                    UnitPrice = unitPrice,
                    Quantity = quantity,
                    StockAvailable = stockAvailable
                });
            }
        }

        public static void UpdateQuantity(int index, int quantity)
        {
            var cart = GetCart();
            if (index >= 0 && index < cart.Count)
            {
                if (quantity <= 0)
                    cart.RemoveAt(index);
                else
                    cart[index].Quantity = quantity;
            }
        }

        public static void RemoveItem(int index)
        {
            var cart = GetCart();
            if (index >= 0 && index < cart.Count)
                cart.RemoveAt(index);
        }

        public static void ClearCart()
        {
            HttpContext.Current.Session.Remove(CartKey);
        }

        public static int Count { get { return GetCart().Count; } }

        public static decimal TotalAmount
        {
            get
            {
                var cart = GetCart();
                decimal total = 0;
                foreach (var item in cart)
                    total += item.SubTotal;
                return total;
            }
        }
    }
}
