using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Cathedral.Web.Data;
using Cathedral.Web.Models;
using Cathedral.Web.Repository;

namespace Cathedral.Web.Controllers
{
    [VerifyUser]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            SessionUser sUser = (SessionUser)Session["User"];

            //get prewalks
            Result resPropPre = new Result();
            PropertyRepository.GetPreWalksByUser(sUser.Id, DateTime.Now, out resPropPre);
            if (resPropPre.Success)
            {
                ViewBag.PropertiesPre = (List<PreWalk>)resPropPre.ReturnObj;
            }
            else {
                ViewBag.ErrMsg = resPropPre.MsgForUser;
            }

            //get kickoffs
            Result resPropKick = new Result();
            PropertyRepository.GetKickOffsByUser(sUser.Id, DateTime.Now, out resPropKick);
            if (resPropKick.Success)
            {
                ViewBag.PropertiesKick = (List<KickOff>)resPropKick.ReturnObj;
            }
            else
            {
                ViewBag.ErrMsg = resPropKick.MsgForUser;
            }

            //get walk-throughs
            Result resPropWalk = new Result();
            PropertyRepository.GetWalkThroughsByUser(sUser.Id, DateTime.Now, out resPropWalk);
            if (resPropWalk.Success)
            {
                ViewBag.PropertiesWalk = (List<WalkThrough>)resPropWalk.ReturnObj;
            }
            else
            {
                ViewBag.ErrMsg = resPropWalk.MsgForUser;
            }

            return View();
        }
    }
}