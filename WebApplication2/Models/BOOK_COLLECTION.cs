//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebApplication2.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class BOOK_COLLECTION
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public BOOK_COLLECTION()
        {
            this.BOOK_EDITION = new HashSet<BOOK_EDITION>();
        }
    
        public int BookCollectionID { get; set; }
        public string BookCollectionName { get; set; }
        public int ManagerID { get; set; }
    
        public virtual MANAGER MANAGER { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<BOOK_EDITION> BOOK_EDITION { get; set; }
    }
}
