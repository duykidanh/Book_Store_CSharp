﻿using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using WebApplication2.Models;

namespace WebApplication2.Areas.Manager.Controllers
{
    [Authorize(Roles = "Manager")]
    public class HomeController : Controller
    {
        private BookStoreManagerEntities db = new BookStoreManagerEntities();
        // GET: Manager/Home
        public ActionResult Index()
        {
            ViewBag.revenue = db.V_revenue_of_each_year.ToList();

            return View();
        }
        public ActionResult Dashboard()
        {
            return View();
        }
        public ActionResult GetBuyCountOfCurrentMonth()
        {

            var totalBuyCount = db.V_edition_buy_count.OrderByDescending(m => m.BuyCount).OrderByDescending(m => m.TotalPrice).ToList();

            return View(totalBuyCount);
        }

        public ActionResult GetRevenueOfEachYear()
        {
            var revenue = db.V_revenue_of_each_year.ToDictionary(i => i.ID, i => new
            {
                Year = i.Year,
                Revenue = i.Revenue
            });
            var revenueJSON = JsonConvert.SerializeObject(revenue);
            return Json(revenueJSON, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetRevenueOfEachMonthInYear()
        {
            var revenue = db.V_revenue_of_each_month.ToDictionary(i => i.ID, i => new
            {
                Month = i.Month,
                Year = i.Year,
                Revenue = i.Revenue
            });
            var revenueJSON = JsonConvert.SerializeObject(revenue);
            return Json(revenueJSON, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetRevenueOfEachDayInMonthOfYear()
        {
            var revenue = db.V_revenue_of_each_day.ToDictionary(i => i.ID, i => new
            {
                Month = i.Month,
                Year = i.Year,
                Day = i.Day,
                Revenue = i.Revenue
            });
            var revenueJSON = JsonConvert.SerializeObject(revenue);
            return Json(revenueJSON, JsonRequestBehavior.AllowGet);
        }
        public ActionResult RevenueInOneMonth(string date)
        {
            if(date != null)
            {
                string[] dateFormat = date.Split('-');

                bool areNumber = dateFormat.All(element => int.TryParse(element, out _));

                if (areNumber)
                {
                    if(dateFormat[0].Length == 2 && dateFormat[1].Length == 4)
                    {
                        int[] numbers = Array.ConvertAll(dateFormat, int.Parse);
                        ViewBag.Month = numbers[0];
                        ViewBag.Year = numbers[1];
                    }
                    else
                    {
                        return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                    }
                }
                else
                {
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                }

                if (int.Parse(dateFormat[0]) >= 1 && int.Parse(dateFormat[1]) <=12)
                {
                    ViewBag.Month = dateFormat[0];
                    ViewBag.Year = dateFormat[1];
                }
            }
            else
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            return PartialView("_RevenueInOneMonthPartialView");
        }

        // GET: Manager/Home/Details/5
        public ActionResult Details(string year)
        {
            if (!string.IsNullOrEmpty(year) && year.Length == 4)
            {
                int checkYear;
                bool isYear = int.TryParse(year, out checkYear);
                if (isYear)
                {
                    ViewBag.Year = checkYear;
                    return View();
                }
                else
                    return new HttpNotFoundResult("404");
            }
            else
                return new HttpNotFoundResult("404");
        }

        // GET: Manager/Home/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Manager/Home/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Manager/Home/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Manager/Home/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Manager/Home/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Manager/Home/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
