using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class CustomerMap : EntityTypeConfiguration<Customer>
    {
        public CustomerMap()
        {
            ToTable("customers");

            HasKey(c => c.id);

            Property(c => c.id).HasColumnName("id");
            Property(c => c.name).HasColumnName("name");
            Property(c => c.phone).HasColumnName("phone");
            Property(c => c.email).HasColumnName("email");
            Property(c => c.address).HasColumnName("address");
            Property(c => c.memberLevel).HasColumnName("memberlevel");
            Property(c => c.totalSpent).HasColumnName("totalspent");
            Property(c => c.createdAt).HasColumnName("createdat");
            Property(c => c.updatedAt).HasColumnName("updatedat");
        }
    }
}
