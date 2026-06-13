using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class SupplierMap : EntityTypeConfiguration<Supplier>
    {
        public SupplierMap()
        {
            ToTable("suppliers");

            HasKey(s => s.id);

            Property(s => s.id).HasColumnName("id");
            Property(s => s.name).HasColumnName("name");
            Property(s => s.contactPerson).HasColumnName("contactperson");
            Property(s => s.phone).HasColumnName("phone");
            Property(s => s.email).HasColumnName("email");
            Property(s => s.address).HasColumnName("address");
            Property(s => s.remark).HasColumnName("remark");
            Property(s => s.createdAt).HasColumnName("createdat");
            Property(s => s.updatedAt).HasColumnName("updatedat");
        }
    }
}
