using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps {

    public class UserMap : EntityTypeConfiguration<User> {
        public UserMap() {
            ToTable("users");

            HasKey(u => u.id);

            Property(u => u.id).HasColumnName("id");
            Property(u => u.username).HasColumnName("username");
            Property(u => u.passwordHash).HasColumnName("passwordhash");
            Property(u => u.displayName).HasColumnName("displayname");
            Property(u => u.role).HasColumnName("role");
            Property(u => u.isActive).HasColumnName("isactive");
            Property(u => u.lastLoginAt).HasColumnName("lastloginat");
            Property(u => u.createdAt).HasColumnName("createdat");
            Property(u => u.updatedAt).HasColumnName("updatedat");
        }
    }
}