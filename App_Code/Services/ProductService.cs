using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using Entities;

namespace Services
{
    public class ProductService
    {
        /// <summary>分页获取商品列表，支持按名称/编码搜索和按分类筛选</summary>
        public List<Product> GetAll(string keyword, long? categoryId, int page, int pageSize, bool includeDeleted = false)
        {
            using (var db = new ErpDbContext())
            {
                var query = db.Products.Include("category").AsQueryable();
                if (!string.IsNullOrEmpty(keyword))
                    query = query.Where(p => p.name.Contains(keyword) || p.code.Contains(keyword));
                if (categoryId.HasValue)
                    query = query.Where(p => p.categoryId == categoryId.Value);
                if (!includeDeleted)
                    query = query.Where(p => p.isActive == true);
                return query
                    .OrderBy(p => p.id)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();
            }
        }

        /// <summary>根据ID获取单个商品（含分类和供应商导航属性）</summary>
        public Product GetById(int id)
        {
            using (var db = new ErpDbContext())
            {
                return db.Products.Include("category").Include("supplier").FirstOrDefault(p => p.id == id);
            }
        }

        /// <summary>新增商品</summary>
        public int Add(Product product)
        {
            using (var db = new ErpDbContext())
            {
                product.createdAt = DateTime.Now;
                product.isActive = true;
                db.Products.Add(product);
                return db.SaveChanges();
            }
        }

        /// <summary>更新商品信息</summary>
        public int Update(Product product)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Products.Find(product.id);
                exist.code = product.code;
                exist.name = product.name;
                exist.categoryId = product.categoryId;
                exist.supplierId = product.supplierId;
                exist.unit = product.unit;
                exist.purchasePrice = product.purchasePrice;
                exist.sellingPrice = product.sellingPrice;
                exist.stockQuantity = product.stockQuantity;
                exist.minStock = product.minStock;
                exist.imagePath = product.imagePath;
                exist.description = product.description;
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        /// <summary>软删除商品（设置IsActive=false）</summary>
        public int Delete(int id)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Products.Find(id);
                exist.isActive = false;
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        /// <summary>获取可售商品列表（活跃且有库存）</summary>
        public List<Product> GetActiveForSale()
        {
            using (var db = new ErpDbContext())
            {
                return db.Products
                    .Where(p => p.isActive && p.stockQuantity > 0)
                    .OrderBy(p => p.name)
                    .ToList();
            }
        }

        /// <summary>获取库存预警列表（StockQuantity &lt;= MinStock）</summary>
        public List<Product> GetStockAlerts(bool includeDeleted = false)
        {
            using (var db = new ErpDbContext())
            {
                var query = db.Products.Include("category")
                    .Where(p => p.stockQuantity <= p.minStock);
                if (!includeDeleted)
                    query = query.Where(p => p.isActive == true);
                return query.OrderBy(p => p.stockQuantity).ToList();
            }
        }
    }
}
