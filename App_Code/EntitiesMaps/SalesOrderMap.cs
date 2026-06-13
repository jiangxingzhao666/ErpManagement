using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class SalesOrderMap : EntityTypeConfiguration<SalesOrder>
    {
        public SalesOrderMap()
        {
            ToTable("salesorders");

            HasKey(o => o.id);

            Property(o => o.id).HasColumnName("id");
            Property(o => o.orderNo).HasColumnName("orderno");
            Property(o => o.customerId).HasColumnName("customerid");
            Property(o => o.totalAmount).HasColumnName("totalamount");
            Property(o => o.discountAmount).HasColumnName("discountamount");
            Property(o => o.actualAmount).HasColumnName("actualamount");
            Property(o => o.paymentMethod).HasColumnName("paymentmethod");
            Property(o => o.status).HasColumnName("status");
            Property(o => o.remark).HasColumnName("remark");
            Property(o => o.createdBy).HasColumnName("createdby");
            Property(o => o.createdAt).HasColumnName("createdat");
            Property(o => o.updatedAt).HasColumnName("updatedat");

            HasOptional(o => o.customer).WithMany().HasForeignKey(o => o.customerId);
        }
    }
}
