using System.Data.Entity.ModelConfiguration;
using Entities;

namespace EntitiesMaps
{
    public class CategoryMap : EntityTypeConfiguration<Category>
    {
        public CategoryMap()
        {
            ToTable("categories");

            HasKey(c => c.id);

            Property(c => c.id).HasColumnName("id");
            Property(c => c.name).HasColumnName("name");
            Property(c => c.description).HasColumnName("description");
            Property(c => c.createdAt).HasColumnName("createdat");
            Property(c => c.updatedAt).HasColumnName("updatedat");
        }
    }
}
