//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Cathedral.Web.Data
{
    using System;
    using System.Collections.Generic;
    
    public partial class Property
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Property()
        {
            this.PropertyXKickOffs = new HashSet<PropertyXKickOff>();
            this.PropertyXPreWalks = new HashSet<PropertyXPreWalk>();
            this.PropertyXWalkThroughs = new HashSet<PropertyXWalkThrough>();
        }
    
        public int Id { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public int StateId { get; set; }
        public int Stories { get; set; }
        public int CommunityId { get; set; }
        public Nullable<int> BuilderId { get; set; }
        public Nullable<int> SupervisorId { get; set; }
        public Nullable<int> AreaManagerId { get; set; }
        public Nullable<int> SubContractorId { get; set; }
        public Nullable<int> PunchMan1Id { get; set; }
        public Nullable<int> PunchMan2Id { get; set; }
        public Nullable<int> PlanId { get; set; }
        public Nullable<int> RoughInStatus { get; set; }
        public Nullable<System.DateTime> RoughInDueDate { get; set; }
        public Nullable<System.DateTime> RoughInStarted { get; set; }
        public Nullable<int> RoughInSupervisorId { get; set; }
        public Nullable<int> TopInStatus { get; set; }
        public Nullable<System.DateTime> TopInDueDate { get; set; }
        public Nullable<System.DateTime> TopInStarted { get; set; }
        public Nullable<int> TopInSupervisorId { get; set; }
        public Nullable<int> TopOutStatus { get; set; }
        public Nullable<System.DateTime> TopOutDueDate { get; set; }
        public Nullable<System.DateTime> TopOutStarted { get; set; }
        public Nullable<int> TopOutSupervisorId { get; set; }
        public System.DateTime Created { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime Updated { get; set; }
        public string UpdatedBy { get; set; }
    
        public virtual AppUser AppUser { get; set; }
        public virtual AppUser AppUser1 { get; set; }
        public virtual AppUser AppUser2 { get; set; }
        public virtual AppUser AppUser3 { get; set; }
        public virtual AppUser AppUser4 { get; set; }
        public virtual Builder Builder { get; set; }
        public virtual Community Community { get; set; }
        public virtual Plan Plan { get; set; }
        public virtual PunchMan PunchMan { get; set; }
        public virtual PunchMan PunchMan1 { get; set; }
        public virtual Status Status { get; set; }
        public virtual State State { get; set; }
        public virtual SubContractor SubContractor { get; set; }
        public virtual Status Status1 { get; set; }
        public virtual Status Status2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PropertyXKickOff> PropertyXKickOffs { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PropertyXPreWalk> PropertyXPreWalks { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PropertyXWalkThrough> PropertyXWalkThroughs { get; set; }
    }
}