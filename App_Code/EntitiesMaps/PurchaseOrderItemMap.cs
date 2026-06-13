using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class PurchaseOrderItemMap : EntityTypeConfiguration<PurchaseOrderItem>
    {
        public PurchaseOrderItemMap()
        {
            ToTable("purchaseorderitems");

            HasKey(i => i.id);

            Property(i => i.id).HasColumnName("id");
            Property(i => i.purchaseOrderId).HasColumnName("purchaseorderid");
            Property(i => i.productId).HasColumnName("productid");
            Property(i => i.quantity).HasColumnName("quantity");
            Property(i => i.unitPrice).HasColumnName("unitprice");
            Property(i => i.subTotal).HasColumnName("subtotal");
            Property(i => i.createdAt).HasColumnName("createdat");
            Property(i => i.updatedAt).HasColumnName("updatedat");

            HasRequired(i => i.purchaseOrder).WithMany(o => o.items).HasForeignKey(i => i.purchaseOrderId);
            HasRequired(i => i.product).WithMany().HasForeignKey(i => i.productId);
        }
    }
}
