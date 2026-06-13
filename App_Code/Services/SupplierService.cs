using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using Entities;

namespace Services
{
    public class SupplierService
    {
        /// <summary>分页获取供应商列表，支持关键字搜索</summary>
        public List<Supplier> GetAll(string keyword, int page, int pageSize)
        {
            using (var db = new ErpDbContext())
            {
                var query = db.Suppliers.AsQueryable();
                if (!string.IsNullOrEmpty(keyword))
                    query = query.Where(s => s.name.Contains(keyword));
                return query
                    .OrderBy(s => s.id)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();
            }
        }

        /// <summary>根据ID获取单个供应商</summary>
        public Supplier GetById(int id)
        {
            using (var db = new ErpDbContext())
            {
                return db.Suppliers.Find(id);
            }
        }

        public List<Supplier> GetAllSimple()
        {
            using (var db = new ErpDbContext())
            {
                return db.Suppliers.OrderBy(s => s.name).ToList();
            }
        }

        /// <summary>新增供应商</summary>
        public int Add(Supplier supplier)
        {
            using (var db = new ErpDbContext())
            {
                supplier.createdAt = DateTime.Now;
                db.Suppliers.Add(supplier);
                return db.SaveChanges();
            }
        }

        /// <summary>更新供应商信息</summary>
        public int Update(Supplier supplier)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Suppliers.Find(supplier.id);
                exist.name = supplier.name;
                exist.contactPerson = supplier.contactPerson;
                exist.phone = supplier.phone;
                exist.email = supplier.email;
                exist.address = supplier.address;
                exist.remark = supplier.remark;
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        /// <summary>删除供应商</summary>
        public int Delete(int id)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Suppliers.Find(id);
                db.Suppliers.Remove(exist);
                return db.SaveChanges();
            }
        }
    }
}
