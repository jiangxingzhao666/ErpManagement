using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class ShipmentMap : EntityTypeConfiguration<Shipment>
    {
        public ShipmentMap()
        {
            ToTable("shipments");

            HasKey(s => s.id);

            Property(s => s.id).HasColumnName("id");
            Property(s => s.salesOrderId).HasColumnName("salesorderid");
            Property(s => s.trackingNumber).HasColumnName("trackingnumber");
            Property(s => s.carrier).HasColumnName("carrier");
            Property(s => s.recipientName).HasColumnName("recipientname");
            Property(s => s.recipientPhone).HasColumnName("recipientphone");
            Property(s => s.recipientAddress).HasColumnName("recipientaddress");
            Property(s => s.shippingFee).HasColumnName("shippingfee");
            Property(s => s.status).HasColumnName("status");
            Property(s => s.remark).HasColumnName("remark");
            Property(s => s.createdAt).HasColumnName("createdat");
            Property(s => s.updatedAt).HasColumnName("updatedat");

            HasRequired(s => s.salesOrder).WithMany().HasForeignKey(s => s.salesOrderId);
        }
    }
}
