using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Cathedral.Web.Models
{
    public class PreWalk
    {
        public int Id { get; set; }
        public PropertyModel Property { get; set; }
        public AppStatus? Status { get; set; }
        public bool? ExtensionRequested { get; set; }
        public bool? ExtensionApproved { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? Created { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public string UpdatedBy { get; set; }
    }

    public class KickOff
    {
        public int Id { get; set; }
        public PropertyModel Property { get; set; }
        public AppStatus? Status { get; set; }
        public bool? ExtensionRequested { get; set; }
        public bool? ExtensionApproved { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? Created { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public string UpdatedBy { get; set; }
    }

    public class WalkThrough
    {
        public int Id { get; set; }
        public PropertyModel Property { get; set; }
        public AppStatus? Status { get; set; }
        public bool? ExtensionRequested { get; set; }
        public bool? ExtensionApproved { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? Created { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public string UpdatedBy { get; set; }
    }

    public class PropertyModel
    {
        public int Id { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string City { get; set; }
        public StateModel State { get; set; }
        public int? Stories { get; set; }
        public CommunityModel Community { get; set; }
        public BuilderModel Builder { get; set; }
        public SupervisorModel Supervisor { get; set; }
        public AreaManagerModel AreaManager { get; set; }
        public SubContractorModel SubContractor { get; set; }
        public PunchManModel PunchMan1 { get; set; }
        public PunchManModel PunchMan2 { get; set; }
        public string PlanFile { get; set; }
        public RoughInModel RoughIn { get; set; }
        public TopInModel TopIn { get; set; }
        public TopOutModel TopOut { get; set; }
        public DateTime Created { get; set; }
        public string CreatedBy { get; set; }
        public DateTime Updated { get; set; }
        public string UpdatedBy { get; set; }
    }

    public class CommunityModel
    {
        public int? Id { get; set; }
        public string Name { get; set; }
        public string City  { get; set; }
        public StateModel State { get; set; }
        public List<PropertyModel> Properties { get; set; }
    }

    public class BuilderModel
    {
        public int? Id { get; set; }
        public string Name { get; set; }
    }

    public class SubContractorModel
    {
        public int? Id { get; set; }
        public string Name { get; set; }
        public string ContactPerson { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
    }

    public class PunchManModel
    {
        public int? Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
    }

    public class SupervisorModel
    {
        public int? Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
    }

    public class AreaManagerModel
    {
        public int? Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
    }

    public class PlanModel
    {
        public int? Id { get; set; }
        public string Name { get; set; }
        public string File { get; set; }
    }

    public class StateModel
    {
        public int? Id { get; set; }
        public string Name { get; set; }
    }

    public class RoughInModel
    {
        public AppStatus? Status { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? Started { get; set; }
        public SupervisorModel Supervisor { get; set; }
    }

    public class TopInModel
    {
        public AppStatus? Status { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? Started { get; set; }
        public SupervisorModel Supervisor { get; set; }
    }

    public class TopOutModel
    {
        public AppStatus? Status { get; set; }
        public DateTime? DueDate { get; set; }
        public DateTime? Started { get; set; }
        public SupervisorModel Supervisor { get; set; }
    }
}