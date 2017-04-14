using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Web;

using Cathedral.Web.Data;
using Cathedral.Web.Models;
using Cathedral.Web.Utils;

namespace Cathedral.Web.Repository
{
    public static class PropertyRepository
    {
        private static CathedralEntities _db = new CathedralEntities();

        public static void CompletePreWalk(int preWalkId) {
            PropertyXPreWalk preWalk = _db.PropertyXPreWalks.FirstOrDefault(pw => pw.Id == preWalkId);
            preWalk.StatusId = 1;
            _db.SaveChanges();
        }

        public static void GetPreWalksByUser(int userId, DateTime date, out Result result) {
            result = new Result();
            List<PreWalk> preWalks = new List<PreWalk>();

            preWalks = _db.PropertyXPreWalks.Select(pw => new PreWalk()
            {
                Id = pw.Id,
                Status = (AppStatus)pw.StatusId,
                ExtensionRequested = pw.ExtensionRequested,
                ExtensionApproved = pw.ExtensionApproved,
                DueDate = pw.DueDate,
                Created = pw.Created,
                CreatedBy = pw.CreatedBy,
                Updated = pw.Updated,
                UpdatedBy = pw.UpdatedBy,
                Property = new PropertyModel()
                {
                    Community = new CommunityModel()
                    {
                        Id = pw.Property.Community.Id,
                        Name = pw.Property.Community.Name,
                        City = pw.Property.Community.City,
                        State = new StateModel()
                        {
                            Id = pw.Property.Community.State.Id,
                            Name = pw.Property.Community.State.Name
                        }
                    },
                    Id = pw.Property.Id,
                    Address1 = pw.Property.Address1,
                    Address2 = pw.Property.Address2,
                    City = pw.Property.City,
                    State = new StateModel()
                    {
                        Id = pw.Property.State.Id,
                        Name = pw.Property.State.Name
                    },
                    Stories = pw.Property.Stories,
                    Builder = new BuilderModel()
                    {
                        Id = pw.Property.Builder.Id,
                        Name = pw.Property.Builder.Name
                    },
                    Supervisor = new SupervisorModel()
                    {
                        Id = pw.Property.AppUser2.Id,
                        FirstName = pw.Property.AppUser2.FirstName,
                        LastName = pw.Property.AppUser2.LastName,
                        Email = pw.Property.AppUser2.Email,
                        Phone = pw.Property.AppUser2.Phone
                    },
                    AreaManager = new AreaManagerModel()
                    {
                        Id = pw.Property.AppUser.Id,
                        FirstName = pw.Property.AppUser.FirstName,
                        LastName = pw.Property.AppUser.LastName,
                        Email = pw.Property.AppUser.Email,
                        Phone = pw.Property.AppUser.Phone
                    },
                    SubContractor = new SubContractorModel()
                    {
                        Id = pw.Property.SubContractor.Id,
                        Name = pw.Property.SubContractor.Name,
                        ContactPerson = pw.Property.SubContractor.ContactPerson,
                        Phone = pw.Property.SubContractor.Phone,
                        Email = pw.Property.SubContractor.Email
                    },
                    PunchMan1 = new PunchManModel()
                    {
                        Id = pw.Property.PunchMan.Id,
                        FirstName = pw.Property.PunchMan.FirstName,
                        LastName = pw.Property.PunchMan.LastName,
                        Email = pw.Property.PunchMan.Email,
                        Phone = pw.Property.PunchMan.Phone
                    },
                    PunchMan2 = new PunchManModel()
                    {
                        Id = pw.Property.PunchMan1.Id,
                        FirstName = pw.Property.PunchMan1.FirstName,
                        LastName = pw.Property.PunchMan1.LastName,
                        Email = pw.Property.PunchMan1.Email,
                        Phone = pw.Property.PunchMan1.Phone
                    },
                    PlanFile = pw.Property.Plan.File,
                    RoughIn = new RoughInModel()
                    {
                        Status = (AppStatus)pw.Property.RoughInStatus,
                        DueDate = pw.Property.RoughInDueDate,
                        Started = pw.Property.RoughInStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser1.Id,
                            FirstName = pw.Property.AppUser1.FirstName,
                            LastName = pw.Property.AppUser1.LastName,
                            Email = pw.Property.AppUser1.Email,
                            Phone = pw.Property.AppUser1.Phone
                        }
                    },
                    TopIn = new TopInModel()
                    {
                        Status = (AppStatus)pw.Property.TopInStatus,
                        DueDate = pw.Property.TopInDueDate,
                        Started = pw.Property.TopInStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser3.Id,
                            FirstName = pw.Property.AppUser3.FirstName,
                            LastName = pw.Property.AppUser3.LastName,
                            Email = pw.Property.AppUser3.Email,
                            Phone = pw.Property.AppUser3.Phone
                        }
                    },
                    TopOut = new TopOutModel()
                    {
                        Status = (AppStatus)pw.Property.TopOutStatus,
                        DueDate = pw.Property.TopOutDueDate,
                        Started = pw.Property.TopOutStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser4.Id,
                            FirstName = pw.Property.AppUser4.FirstName,
                            LastName = pw.Property.AppUser4.LastName,
                            Email = pw.Property.AppUser4.Email,
                            Phone = pw.Property.AppUser4.Phone
                        }
                    },
                    Created = pw.Property.Created,
                    CreatedBy = pw.Property.CreatedBy,
                    Updated = pw.Property.Updated,
                    UpdatedBy = pw.Property.UpdatedBy
                }
            }).ToList();

            result.ReturnObj = preWalks;
            result.Success = true;
        }

        public static void GetKickOffsByUser(int userId, DateTime date, out Result result)
        {
            result = new Result();
            List<KickOff> kickOffs = new List<KickOff>();

            kickOffs = _db.PropertyXKickOffs.Select(pw => new KickOff()
            {
                Id = pw.Id,
                Status = (AppStatus)pw.StatusId,
                ExtensionRequested = pw.ExtensionRequested,
                ExtensionApproved = pw.ExtensionApproved,
                DueDate = pw.DueDate,
                Created = pw.Created,
                CreatedBy = pw.CreatedBy,
                Updated = pw.Updated,
                UpdatedBy = pw.UpdatedBy,
                Property = new PropertyModel()
                {
                    Community = new CommunityModel()
                    {
                        Id = pw.Property.Community.Id,
                        Name = pw.Property.Community.Name,
                        City = pw.Property.Community.City,
                        State = new StateModel()
                        {
                            Id = pw.Property.Community.State.Id,
                            Name = pw.Property.Community.State.Name
                        }
                    },
                    Id = pw.Property.Id,
                    Address1 = pw.Property.Address1,
                    Address2 = pw.Property.Address2,
                    City = pw.Property.City,
                    State = new StateModel()
                    {
                        Id = pw.Property.State.Id,
                        Name = pw.Property.State.Name
                    },
                    Stories = pw.Property.Stories,
                    Builder = new BuilderModel()
                    {
                        Id = pw.Property.Builder.Id,
                        Name = pw.Property.Builder.Name
                    },
                    Supervisor = new SupervisorModel()
                    {
                        Id = pw.Property.AppUser2.Id,
                        FirstName = pw.Property.AppUser2.FirstName,
                        LastName = pw.Property.AppUser2.LastName,
                        Email = pw.Property.AppUser2.Email,
                        Phone = pw.Property.AppUser2.Phone
                    },
                    AreaManager = new AreaManagerModel()
                    {
                        Id = pw.Property.AppUser.Id,
                        FirstName = pw.Property.AppUser.FirstName,
                        LastName = pw.Property.AppUser.LastName,
                        Email = pw.Property.AppUser.Email,
                        Phone = pw.Property.AppUser.Phone
                    },
                    SubContractor = new SubContractorModel()
                    {
                        Id = pw.Property.SubContractor.Id,
                        Name = pw.Property.SubContractor.Name,
                        ContactPerson = pw.Property.SubContractor.ContactPerson,
                        Phone = pw.Property.SubContractor.Phone,
                        Email = pw.Property.SubContractor.Email
                    },
                    PunchMan1 = new PunchManModel()
                    {
                        Id = pw.Property.PunchMan.Id,
                        FirstName = pw.Property.PunchMan.FirstName,
                        LastName = pw.Property.PunchMan.LastName,
                        Email = pw.Property.PunchMan.Email,
                        Phone = pw.Property.PunchMan.Phone
                    },
                    PunchMan2 = new PunchManModel()
                    {
                        Id = pw.Property.PunchMan1.Id,
                        FirstName = pw.Property.PunchMan1.FirstName,
                        LastName = pw.Property.PunchMan1.LastName,
                        Email = pw.Property.PunchMan1.Email,
                        Phone = pw.Property.PunchMan1.Phone
                    },
                    PlanFile = pw.Property.Plan.File,
                    RoughIn = new RoughInModel()
                    {
                        Status = (AppStatus)pw.Property.RoughInStatus,
                        DueDate = pw.Property.RoughInDueDate,
                        Started = pw.Property.RoughInStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser1.Id,
                            FirstName = pw.Property.AppUser1.FirstName,
                            LastName = pw.Property.AppUser1.LastName,
                            Email = pw.Property.AppUser1.Email,
                            Phone = pw.Property.AppUser1.Phone
                        }
                    },
                    TopIn = new TopInModel()
                    {
                        Status = (AppStatus)pw.Property.TopInStatus,
                        DueDate = pw.Property.TopInDueDate,
                        Started = pw.Property.TopInStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser3.Id,
                            FirstName = pw.Property.AppUser3.FirstName,
                            LastName = pw.Property.AppUser3.LastName,
                            Email = pw.Property.AppUser3.Email,
                            Phone = pw.Property.AppUser3.Phone
                        }
                    },
                    TopOut = new TopOutModel()
                    {
                        Status = (AppStatus)pw.Property.TopOutStatus,
                        DueDate = pw.Property.TopOutDueDate,
                        Started = pw.Property.TopOutStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser4.Id,
                            FirstName = pw.Property.AppUser4.FirstName,
                            LastName = pw.Property.AppUser4.LastName,
                            Email = pw.Property.AppUser4.Email,
                            Phone = pw.Property.AppUser4.Phone
                        }
                    },
                    Created = pw.Property.Created,
                    CreatedBy = pw.Property.CreatedBy,
                    Updated = pw.Property.Updated,
                    UpdatedBy = pw.Property.UpdatedBy
                }
            }).ToList();

            result.ReturnObj = kickOffs;
            result.Success = true;
        }

        public static void GetWalkThroughsByUser(int userId, DateTime date, out Result result)
        {
            result = new Result();
            List<WalkThrough> walks = new List<WalkThrough>();

            walks = _db.PropertyXWalkThroughs.Select(pw => new WalkThrough()
            {
                Id = pw.Id,
                Status = (AppStatus)pw.StatusId,
                ExtensionRequested = pw.ExtensionRequested,
                ExtensionApproved = pw.ExtensionApproved,
                DueDate = pw.DueDate,
                Created = pw.Created,
                CreatedBy = pw.CreatedBy,
                Updated = pw.Updated,
                UpdatedBy = pw.UpdatedBy,
                Property = new PropertyModel()
                {
                    Community = new CommunityModel()
                    {
                        Id = pw.Property.Community.Id,
                        Name = pw.Property.Community.Name,
                        City = pw.Property.Community.City,
                        State = new StateModel()
                        {
                            Id = pw.Property.Community.State.Id,
                            Name = pw.Property.Community.State.Name
                        }
                    },
                    Id = pw.Property.Id,
                    Address1 = pw.Property.Address1,
                    Address2 = pw.Property.Address2,
                    City = pw.Property.City,
                    State = new StateModel()
                    {
                        Id = pw.Property.State.Id,
                        Name = pw.Property.State.Name
                    },
                    Stories = pw.Property.Stories,
                    Builder = new BuilderModel()
                    {
                        Id = pw.Property.Builder.Id,
                        Name = pw.Property.Builder.Name
                    },
                    Supervisor = new SupervisorModel()
                    {
                        Id = pw.Property.AppUser2.Id,
                        FirstName = pw.Property.AppUser2.FirstName,
                        LastName = pw.Property.AppUser2.LastName,
                        Email = pw.Property.AppUser2.Email,
                        Phone = pw.Property.AppUser2.Phone
                    },
                    AreaManager = new AreaManagerModel()
                    {
                        Id = pw.Property.AppUser.Id,
                        FirstName = pw.Property.AppUser.FirstName,
                        LastName = pw.Property.AppUser.LastName,
                        Email = pw.Property.AppUser.Email,
                        Phone = pw.Property.AppUser.Phone
                    },
                    SubContractor = new SubContractorModel()
                    {
                        Id = pw.Property.SubContractor.Id,
                        Name = pw.Property.SubContractor.Name,
                        ContactPerson = pw.Property.SubContractor.ContactPerson,
                        Phone = pw.Property.SubContractor.Phone,
                        Email = pw.Property.SubContractor.Email
                    },
                    PunchMan1 = new PunchManModel()
                    {
                        Id = pw.Property.PunchMan.Id,
                        FirstName = pw.Property.PunchMan.FirstName,
                        LastName = pw.Property.PunchMan.LastName,
                        Email = pw.Property.PunchMan.Email,
                        Phone = pw.Property.PunchMan.Phone
                    },
                    PunchMan2 = new PunchManModel()
                    {
                        Id = pw.Property.PunchMan1.Id,
                        FirstName = pw.Property.PunchMan1.FirstName,
                        LastName = pw.Property.PunchMan1.LastName,
                        Email = pw.Property.PunchMan1.Email,
                        Phone = pw.Property.PunchMan1.Phone
                    },
                    PlanFile = pw.Property.Plan.File,
                    RoughIn = new RoughInModel()
                    {
                        Status = (AppStatus)pw.Property.RoughInStatus,
                        DueDate = pw.Property.RoughInDueDate,
                        Started = pw.Property.RoughInStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser1.Id,
                            FirstName = pw.Property.AppUser1.FirstName,
                            LastName = pw.Property.AppUser1.LastName,
                            Email = pw.Property.AppUser1.Email,
                            Phone = pw.Property.AppUser1.Phone
                        }
                    },
                    TopIn = new TopInModel()
                    {
                        Status = (AppStatus)pw.Property.TopInStatus,
                        DueDate = pw.Property.TopInDueDate,
                        Started = pw.Property.TopInStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser3.Id,
                            FirstName = pw.Property.AppUser3.FirstName,
                            LastName = pw.Property.AppUser3.LastName,
                            Email = pw.Property.AppUser3.Email,
                            Phone = pw.Property.AppUser3.Phone
                        }
                    },
                    TopOut = new TopOutModel()
                    {
                        Status = (AppStatus)pw.Property.TopOutStatus,
                        DueDate = pw.Property.TopOutDueDate,
                        Started = pw.Property.TopOutStarted,
                        Supervisor = new SupervisorModel()
                        {
                            Id = pw.Property.AppUser4.Id,
                            FirstName = pw.Property.AppUser4.FirstName,
                            LastName = pw.Property.AppUser4.LastName,
                            Email = pw.Property.AppUser4.Email,
                            Phone = pw.Property.AppUser4.Phone
                        }
                    },
                    Created = pw.Property.Created,
                    CreatedBy = pw.Property.CreatedBy,
                    Updated = pw.Property.Updated,
                    UpdatedBy = pw.Property.UpdatedBy
                }
            }).ToList();

            result.ReturnObj = walks;
            result.Success = true;
        }
    }
}