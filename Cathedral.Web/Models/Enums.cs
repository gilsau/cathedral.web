using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Cathedral.Web.Models
{
    public enum AppRoleEnum
    {
        Admin = 1,
        AreaManager = 2,
        Supervisor = 3,
        SubContractor = 4,
        PunchMan = 5,
        Controller = 6
    }

    public enum AppStatus
    {
        Complete = 1,
        InProgress = 2,
        NotReady = 3,
        Received = 4
    }
}