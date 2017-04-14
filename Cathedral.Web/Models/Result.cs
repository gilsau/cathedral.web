using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Cathedral.Web.Models
{
    public class Result
    {
        public Result()
        {
            Success = false;
        }

        public bool Success { get; set; }
        public string MsgForUser { get; set; }
        public string MsgForLog { get; set; }
        public object ReturnObj { get; set; }
        public Exception Err { get; set; }
    }
}