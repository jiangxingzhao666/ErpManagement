using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using Entities;

namespace Services
{
    public class CustomerService
    {
        public List<Customer> GetAll(string keyword, int page, int pageSize)
        {
            using (var db = new ErpDbContext())
            {
                var query = db.Customers.AsQueryable();
                if (!string.IsNullOrEmpty(keyword))
                    query = query.Where(c => c.name.Contains(keyword) || c.phone.Contains(keyword));
                return query
                    .OrderBy(c => c.id)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();
            }
        }

        public Customer GetById(int id)
        {
            using (var db = new ErpDbContext())
            {
                return db.Customers.Find(id);
            }
        }

        public List<Customer> GetAllSimple()
        {
            using (var db = new ErpDbContext())
            {
                return db.Customers.OrderBy(c => c.name).ToList();
            }
        }

        public List<Customer> GetTopBySpending(int topN)
        {
            using (var db = new ErpDbContext())
            {
                return db.Customers
                    .OrderByDescending(c => c.totalSpent)
                    .Take(topN)
                    .ToList();
            }
        }

        public int Add(Customer customer)
        {
            using (var db = new ErpDbContext())
            {
                customer.createdAt = DateTime.Now;
                if (string.IsNullOrEmpty(customer.memberLevel))
                    customer.memberLevel = "普通";
                customer.totalSpent = 0;
                db.Customers.Add(customer);
                return db.SaveChanges();
            }
        }

        public int Update(Customer customer)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Customers.Find(customer.id);
                exist.name = customer.name;
                exist.phone = customer.phone;
                exist.email = customer.email;
                exist.address = customer.address;
                exist.memberLevel = customer.memberLevel;
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        public int Delete(int id)
        {
            using (var db = new ErpDbContext())
            {
                var exist = db.Customers.Find(id);
                db.Customers.Remove(exist);
                return db.SaveChanges();
            }
        }
    }
}
