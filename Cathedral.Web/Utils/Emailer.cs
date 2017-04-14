using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net.Mail;
using System.Configuration;
using Cathedral.Web.Models;
 
namespace Cathedral.Web.Utils
{
    public static class Emailer
    {
        public static bool SendMail(string subject, string body, string fromAddress, string fromName, string toAddress, out Result scr)
        {
            scr = new Result();

            //Prepare email
            MailMessage message = new MailMessage();
            message.From = new MailAddress(fromAddress, fromName);
            message.To.Add(toAddress);
            message.Subject = subject;
            message.Body = body;
            message.IsBodyHtml = true;

            message.Priority = System.Net.Mail.MailPriority.Normal;

            System.Net.Mail.SmtpClient client = new System.Net.Mail.SmtpClient();
            client.Host = ConfigurationManager.AppSettings["SMTP_Host"];

            //THIS NEXT FOUR LINES ARE IN CASE YOU NEED MORE CONTROL OVER SPECIFICS AND CANNOT USE THE web.config FILE OPTION
            //PASSWORD SHOULD BE SEEN AS A SECURITY RISK SO USING ENCRIPTION WOULD BE IDEAL - THESE ARE ALL HANDLED BY web.config INCLUDING THE client.Credentials LINE. SWEET STUFF IMHO.
            System.Net.NetworkCredential netwrkCrd = new System.Net.NetworkCredential();
            netwrkCrd.UserName = ConfigurationManager.AppSettings["SMTP_UID"];
            netwrkCrd.Password = ConfigurationManager.AppSettings["SMTP_PWD"];
            client.Credentials = netwrkCrd;

            //Send email
            try
            {
                client.Send(message);
            }
            catch (Exception ex)
            {
                scr.MsgForUser = "There was a problem sending email.";
                Logger.LogError(ex);
            }

            return scr.Success;
        }
    }
}