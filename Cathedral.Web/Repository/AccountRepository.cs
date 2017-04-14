using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Collections;
using System.Web;

using Cathedral.Web.Data;
using Cathedral.Web.Models;

namespace Cathedral.Web.Repository
{
    public static class AccountRepository
    {
        private static CathedralEntities _db = new CathedralEntities();

        public static void Authenticate(string uid, string pwd, out Result result) {
            result = new Result();

            //check user's credentials
            AppUser au = _db.AppUsers.SingleOrDefault(u => u.Username == uid && u.Password == pwd);

            //no access
            if (au == null) {
                result.Success = false;
                result.MsgForUser = "Invalid username/password combination. Please try again or contact your administrator.";
            }

            //access
            else {
                result.ReturnObj = new SessionUser()
                {
                    Id = au.Id,
                    FirstName = au.FirstName,
                    LastName = au.LastName,
                    Username = au.Username,
                    Email = au.Email,
                    Phone = au.Phone,
                    Photo = au.Photo,
                    Role = new AppRoleModel() {
                        Id = au.AppRole.Id,
                        Name = au.AppRole.Name
                    }
                };

                result.Success = true;
            }
        }
    }
}