using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class PurchaseOrderMap : EntityTypeConfiguration<PurchaseOrder>
    {
        public PurchaseOrderMap()
        {
            ToTable("purchaseorders");

            HasKey(o => o.id);

            Property(o => o.id).HasColumnName("id");
            Property(o => o.orderNo).HasColumnName("orderno");
            Property(o => o.supplierId).HasColumnName("supplierid");
            Property(o => o.totalAmount).HasColumnName("totalamount");
            Property(o => o.status).HasColumnName("status");
            Property(o => o.remark).HasColumnName("remark");
            Property(o => o.createdBy).HasColumnName("createdby");
            Property(o => o.createdAt).HasColumnName("createdat");
            Property(o => o.updatedAt).HasColumnName("updatedat");

            HasRequired(o => o.supplier).WithMany().HasForeignKey(o => o.supplierId);
        }
    }
}
