using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class ProductMap : EntityTypeConfiguration<Product>
    {
        public ProductMap()
        {
            ToTable("products");

            HasKey(p => p.id);

            Property(p => p.id).HasColumnName("id");
            Property(p => p.code).HasColumnName("code");
            Property(p => p.name).HasColumnName("name");
            Property(p => p.categoryId).HasColumnName("categoryid");
            Property(p => p.supplierId).HasColumnName("supplierid");
            Property(p => p.unit).HasColumnName("unit");
            Property(p => p.purchasePrice).HasColumnName("purchaseprice");
            Property(p => p.sellingPrice).HasColumnName("sellingprice");
            Property(p => p.stockQuantity).HasColumnName("stockquantity");
            Property(p => p.minStock).HasColumnName("minstock");
            Property(p => p.imagePath).HasColumnName("imagepath");
            Property(p => p.description).HasColumnName("description");
            Property(p => p.isActive).HasColumnName("isactive");
            Property(p => p.createdAt).HasColumnName("createdat");
            Property(p => p.updatedAt).HasColumnName("updatedat");

            HasOptional(p => p.supplier).WithMany().HasForeignKey(p => p.supplierId);
            HasRequired(p => p.category).WithMany().HasForeignKey(p => p.categoryId);
        }
    }
}
