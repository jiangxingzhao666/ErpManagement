using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class SalesOrderItemMap : EntityTypeConfiguration<SalesOrderItem>
    {
        public SalesOrderItemMap()
        {
            ToTable("salesorderitems");

            HasKey(i => i.id);

            Property(i => i.id).HasColumnName("id");
            Property(i => i.salesOrderId).HasColumnName("salesorderid");
            Property(i => i.productId).HasColumnName("productid");
            Property(i => i.quantity).HasColumnName("quantity");
            Property(i => i.unitPrice).HasColumnName("unitprice");
            Property(i => i.subTotal).HasColumnName("subtotal");
            Property(i => i.createdAt).HasColumnName("createdat");
            Property(i => i.updatedAt).HasColumnName("updatedat");

            HasRequired(i => i.salesOrder).WithMany(o => o.items).HasForeignKey(i => i.salesOrderId);
            HasRequired(i => i.product).WithMany().HasForeignKey(i => i.productId);
        }
    }
}
