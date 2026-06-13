using System;
using System.Collections.Generic;
using System.Linq;
using DAL;
using Entities;
using Helpers;

namespace Services {

    public class UserService {
        /// <summary>获取所有有效用户</summary>
        public List<User> GetAll(bool includeDeleted = false) {
            using (var db = new ErpDbContext()) {
                var query = db.Users.AsQueryable();
                if (!includeDeleted)
                    query = query.Where(u => u.isActive == true);
                return query.OrderBy(u => u.id).ToList();
            }
        }

        /// <summary>根据ID获取单个用户</summary>
        public User GetById(int id) {
            using (var db = new ErpDbContext()) {
                return db.Users.Find(id);
            }
        }

        /// <summary>新增用户，密码加盐SHA256哈希存储</summary>
        public int Add(User user) {
            using (var db = new ErpDbContext()) {
                user.passwordHash = HashHelper.HashPassword(user.passwordHash);
                user.isActive = true;
                user.createdAt = DateTime.Now;
                db.Users.Add(user);
                return db.SaveChanges();
            }
        }

        /// <summary>更新用户信息，密码重新加盐SHA256哈希</summary>
        public int Update(User user) {
            using(var db = new ErpDbContext()) {
                var exist = db.Users.Find(user.id);
                exist.username = user.username;
                exist.displayName = user.displayName;
                exist.role = user.role;
                exist.passwordHash = HashHelper.HashPassword(user.passwordHash);
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        /// <summary>软删除用户（设置IsActive=false）</summary>
        public int Delete(int id) {
            using (var db = new ErpDbContext()) {
                var exist = db.Users.Find(id);
                exist.isActive = false;
                exist.updatedAt = DateTime.Now;
                return db.SaveChanges();
            }
        }

        /// <summary>用户登录：加盐SHA256密码比对，成功则更新最后登录时间</summary>
        public User Login(string username, string password) {
            using (var db = new ErpDbContext()) {
                var users = db.Users.Where(u => u.username == username && u.isActive == true).ToList();
                var user = users.FirstOrDefault(u => HashHelper.VerifyPassword(password, u.passwordHash));
                if (user != null) {
                    user.lastLoginAt = DateTime.Now;
                    db.SaveChanges();
                }
                return user;
            }
        }

    }
}
