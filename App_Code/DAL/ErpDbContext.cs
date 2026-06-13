using System.Data.Entity;
using Entities;
using EntitiesMaps;

namespace DAL {

    public class ErpDbContext : DbContext {
        public ErpDbContext() : base("name=ErpDbContext") {
        }

        public DbSet<Category>          Categories          { get; set; }
        public DbSet<Supplier>          Suppliers           { get; set; }
        public DbSet<Product>           Products            { get; set; }
        public DbSet<Customer>          Customers           { get; set; }
        public DbSet<PurchaseOrder>     PurchaseOrders      { get; set; }
        public DbSet<PurchaseOrderItem> PurchaseOrderItems  { get; set; }
        public DbSet<SalesOrder>        SalesOrders         { get; set; }
        public DbSet<SalesOrderItem>    SalesOrderItems     { get; set; }
        public DbSet<User>              Users               { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder) {
            modelBuilder.HasDefaultSchema("public");
            modelBuilder.Configurations.Add(new CategoryMap());
            modelBuilder.Configurations.Add(new SupplierMap());
            modelBuilder.Configurations.Add(new ProductMap());
            modelBuilder.Configurations.Add(new CustomerMap());
            modelBuilder.Configurations.Add(new PurchaseOrderMap());
            modelBuilder.Configurations.Add(new PurchaseOrderItemMap());
            modelBuilder.Configurations.Add(new SalesOrderMap());
            modelBuilder.Configurations.Add(new SalesOrderItemMap());
            modelBuilder.Configurations.Add(new UserMap());
        }
    }
}