using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Cathedral.Web.Models;
using Cathedral.Web.Repository;

namespace Cathedral.Web.Controllers
{
    public class AccountController : Controller
    {
        [HttpGet]
        public ActionResult Login(int logout=0)
        {
            Session.Abandon();

            return View();
        }

        [HttpPost]
        public ActionResult Login(string uid, string pwd, string targetUrl)
        {
            //authenticate user
            Result resAuth = new Result();
            AccountRepository.Authenticate(uid, pwd, out resAuth);

            //login success
            if (resAuth.Success)
            {
                //save user to session
                Session["User"] = resAuth.ReturnObj;

                //calculate redirect url
                targetUrl = string.IsNullOrEmpty(targetUrl) ? "~/home/" : targetUrl;

                return Redirect(targetUrl);
            }

            //login failed
            else {
                Session.Abandon();
                ViewBag.Err = true;
                ViewBag.MsgForUser = resAuth.MsgForUser;

                return View();
            }
        }
    }

    public class VerifyUserAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var user = filterContext.HttpContext.Session["User"];
            if (user == null)
                filterContext.Result = new RedirectResult(string.Format("/account/login?targetUrl={0}", filterContext.HttpContext.Request.Url.AbsolutePath));
        }
    }
}