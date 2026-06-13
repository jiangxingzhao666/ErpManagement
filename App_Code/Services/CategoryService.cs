using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using Entities;

namespace Services
{
    public class CategoryService
    {
        /// <summary>获取所有商品分类</summary>
        public List<Category> GetAll()
        {
            using (var db = new ErpDbContext())
            {
                return db.Categories
                    .OrderBy(c => c.id)
                    .ToList();
            }
        }

        /// <summary>根据ID获取单个分类</summary>
        public Category GetById(int id)
        {
            using (var db = new ErpDbContext())
            {
                return db.Categories.Find(id);
            }
        }

        /// <summary>新增商品分类</summary>
        public int Add(Category category)
        {
            using (var db = new ErpDbContext())
            {
                category.createdAt = DateTime.Now;
                db.Categories.Add(category);
                return db.SaveChanges();
            }
        }

        /// <summary>更新商品分类</summary>
        public int Update(Category category)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Categories.Find(category.id);
                exist.name = category.name;
                exist.description = category.description;
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        /// <summary>删除商品分类</summary>
        public int Delete(int id)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Categories.Find(id);
                db.Categories.Remove(exist);
                return db.SaveChanges();
            }
        }
    }
}
