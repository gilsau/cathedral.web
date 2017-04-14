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
    public static class MessageRepository
    {
        private static CathedralEntities _db = new CathedralEntities();

        public static void GetMessages(out Result result) {
            result = new Result();
        }
    }
}