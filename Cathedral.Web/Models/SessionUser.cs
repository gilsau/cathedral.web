using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Cathedral.Web.Data;

namespace Cathedral.Web.Models
{
    public class SessionUser
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Photo { get; set; }
        public AppRoleModel Role { get; set; }
    }

    public class AppRoleModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
}