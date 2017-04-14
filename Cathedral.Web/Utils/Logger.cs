using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Web;
using Cathedral.Web.Models;

namespace Cathedral.Web.Utils
{
    public static class Logger
    {
        public static void LogError(Exception ex)
        {
            if (HttpContext.Current != null)
            {

                string dir = string.Format("{0}Logs", HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"].Replace("\\", "\\\\"));
                string dateStamp = string.Format("{0:yyyy.MM.dd}", DateTime.Now);
                string timeStamp = string.Format("{0:yyyy.MM.dd HH:mm:ss}", DateTime.Now);
                string fullPath = string.Format("{0}\\{1}.txt", dir, dateStamp);

                StreamWriter sw;

                //Create today's log file
                if (!File.Exists(fullPath))
                {
                    sw = File.CreateText(fullPath);
                }

                //Open today's log file
                else
                {
                    sw = File.AppendText(fullPath);
                }

                //Current user
                string name = "Not Available";
                string email = "Not Available";
                
                try
                {
                    SessionUser user = (SessionUser)HttpContext.Current.Session["User"];
                    name = string.Format("{0} {1}", user.FirstName, user.LastName);
                    email = user.Email;
                }
                catch { }

                //Write error and time to log file
                sw.WriteLine();
                sw.WriteLine("*************************************************************************************************");

                string innerMsg = ex.InnerException != null ? ex.InnerException.Message : string.Empty;
                string msg = string.Format("MESSAGE{0}{1}{2}{1}INNER-EXCEPTION{0}{1}{3}{1}SOURCE{0}{1}{4}{1}STACK-TRACE{0}{1}{5}{1}", "------------------", Environment.NewLine, ex.Message, innerMsg, ex.Source, ex.StackTrace);

                sw.WriteLine(string.Format("{0}{0}{1} ||| {2} ||| {3} ||| {4}", Environment.NewLine, timeStamp, name, email, msg));

                sw.Close();
                sw.Dispose();
            }
        }
    }
}