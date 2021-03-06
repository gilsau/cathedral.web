﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class CathedralEntities : DbContext
    {
        public CathedralEntities()
            : base("name=CathedralEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<AppRole> AppRoles { get; set; }
        public virtual DbSet<AppUser> AppUsers { get; set; }
        public virtual DbSet<Builder> Builders { get; set; }
        public virtual DbSet<Community> Communities { get; set; }
        public virtual DbSet<History> Histories { get; set; }
        public virtual DbSet<HistoryByColumn> HistoryByColumns { get; set; }
        public virtual DbSet<Plan> Plans { get; set; }
        public virtual DbSet<Property> Properties { get; set; }
        public virtual DbSet<PropertyXKickOff> PropertyXKickOffs { get; set; }
        public virtual DbSet<PropertyXPreWalk> PropertyXPreWalks { get; set; }
        public virtual DbSet<PropertyXWalkThrough> PropertyXWalkThroughs { get; set; }
        public virtual DbSet<PunchMan> PunchMen { get; set; }
        public virtual DbSet<State> States { get; set; }
        public virtual DbSet<Status> Status { get; set; }
        public virtual DbSet<SubContractor> SubContractors { get; set; }
    }
}
