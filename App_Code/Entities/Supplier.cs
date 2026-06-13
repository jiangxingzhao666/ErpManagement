using System;

namespace Entities
{
    public class Supplier
    {
        public long id { get; set; }
        public string name { get; set; }
        public string contactPerson { get; set; }
        public string phone { get; set; }
        public string email { get; set; }
        public string address { get; set; }
        public string remark { get; set; }
        public DateTime createdAt { get; set; }
        public DateTime? updatedAt { get; set; }
    }
}
