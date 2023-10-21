﻿using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Lab_Lab_PrescriptionOPD : System.Web.UI.Page
{
    public string AppointmentNo = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(Util.GetString(Request.QueryString["AppoinmentNo"])))
        {
            AppointmentNo = Common.Decrypt(Util.GetString(Request.QueryString["AppoinmentNo"]));
            lblheader.Text = "Appointment Registration";
            txtappointment.Text = AppointmentNo;                        
        }   
        if (!IsPostBack)
        {
            txtPreg.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            // if (Session["IsHideRate"].ToString() == "1")
            if (Util.GetString(Session["IsHideRate"]) == "1")
                divPaymentControl.Attributes.Add("style", "display:none;");

            txtSearchModelFromDate.Text = txtSerachModelToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            callMethod();

        }
        txtSearchModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtSerachModelToDate.Attributes.Add("readOnly", "readOnly");
    }
    public static async Task<DataTable> bindCentre1(MySqlConnection con)
    {
        DataTable dt = new DataTable();
        using (dt as IDisposable)
        {
            HttpContext ctx = HttpContext.Current;
            await Task.Run(() =>
            {
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(CentreID,'#',type1id,'#',IFNULL(CityID,''),'#',IFNULL(StateID,''),'#',IFNULL(contactperson,''),'#',IFNULL(contactpersonmobile,''),'#',IFNULL(contactpersonemail,''),'#',IFNULL(LocalityID,''),'#',IF(IFNULL(cm.`PaytmMid`,'')<>'' AND IFNULL(cm.`PaytmGuid`,'')<>'' AND IFNULL(cm.`PaytmKey`,'')<>'','1','0'),'#',IFNULL(cm.`COCO_FOCO`,''),'#',0,'#',IFNULL(CountryID,'')) CentreID,Centre FROM centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@CentreID) or cm.CentreID =@CentreID) and cm.isActive=1 order by cm.CentreCode",
               new MySqlParameter("@CentreID", ctx.Session["Centre"])).Tables[0];

            });


            return dt;
        }
    }
    public static async Task<DataSet> bindAllData(MySqlConnection con)
    {
        DataSet ds = new DataSet();
        DataTable dt = new DataTable();

        using (dt as IDisposable)
        {
            HttpContext ctx = HttpContext.Current;
            await Task.Run(() =>
            {
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT panelGroupID,PanelGroup FROM `f_panelgroup` WHERE Active=1 ORDER BY printOrder ").Tables[0];
            });
            DataTable PanelGroup = dt.Copy();
            PanelGroup.TableName = "PanelGroup";
            ds.Tables.Add(PanelGroup);
            await Task.Run(() =>
            {
                if(Util.GetString(ctx.Session["LoginType"]) == "PCC")
                {
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(CentreID,'#',type1id,'#',IFNULL(CityID,''),'#',IFNULL(StateID,''),'#',IFNULL(contactperson,''),'#',IFNULL(contactpersonmobile,''),'#',IFNULL(contactpersonemail,''),'#',IFNULL(LocalityID,''),'#',IF(IFNULL(cm.`PaytmMid`,'')<>'' AND IFNULL(cm.`PaytmGuid`,'')<>'' AND IFNULL(cm.`PaytmKey`,'')<>'','1','0'),'#',IFNULL(cm.`COCO_FOCO`,''),'#',0,'#',IFNULL(CountryID,'')) CentreID,Centre FROM centre_master cm where ( cm.CentreID  =@CentreID) and cm.isActive=1 order by cm.CentreCode",
                                   new MySqlParameter("@CentreID", ctx.Session["Centre"])).Tables[0];
                }
                else
                {
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(CentreID,'#',type1id,'#',IFNULL(CityID,''),'#',IFNULL(StateID,''),'#',IFNULL(contactperson,''),'#',IFNULL(contactpersonmobile,''),'#',IFNULL(contactpersonemail,''),'#',IFNULL(LocalityID,''),'#',IF(IFNULL(cm.`PaytmMid`,'')<>'' AND IFNULL(cm.`PaytmGuid`,'')<>'' AND IFNULL(cm.`PaytmKey`,'')<>'','1','0'),'#',IFNULL(cm.`COCO_FOCO`,''),'#',0,'#',IFNULL(CountryID,'')) CentreID,Centre FROM centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@CentreID) or cm.CentreID =@CentreID) and cm.isActive=1 order by cm.CentreCode",
                                   new MySqlParameter("@CentreID", ctx.Session["Centre"])).Tables[0];
                }
            });

            DataTable Centre = dt.Copy();
            Centre.TableName = "Centre";
            ds.Tables.Add(Centre);
            return ds;
        }
    }

    public async void callMethod()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            Task<DataSet> AllTask = bindAllData(con);
            DataSet[] results = await Task.WhenAll(new Task<DataSet>[] { AllTask });
            if (results[0].Tables["PanelGroup"].Columns.Count > 0)
            {
                ddlPatientType.DataSource = results[0].Tables["PanelGroup"];
                ddlPatientType.DataValueField = "panelGroupID";
                ddlPatientType.DataTextField = "PanelGroup";
                ddlPatientType.DataBind();
            }
            if (results[0].Tables["Centre"].Columns.Count > 0)
            {
                ddlCentre.DataSource = results[0].Tables["Centre"];
                ddlCentre.DataValueField = "CentreID";
                ddlCentre.DataTextField = "Centre";
                ddlCentre.DataBind();
                ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByText(Session["CentreName"].ToString()));
               
            }
            ddlPNTDDocotor.DataSource = StockReports.GetDataTable("SELECT ID,NAME FROM `pndt_doctor` WHERE Active=1");
            ddlPNTDDocotor.DataValueField = "ID";
            ddlPNTDDocotor.DataTextField = "NAME";
            ddlPNTDDocotor.DataBind();
           
            AllTask.Dispose();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public void callMethod1()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {




            //var tasks = new Task[] { PatientTypeTask, CentreTask };
            //DataTable[] results1 = await Task.WhenAll(tasks);


            //ddlCentre.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(CentreID,'#',type1id,'#',IFNULL(CityID,''),'#',IFNULL(StateID,''),'#',IFNULL(contactperson,''),'#',IFNULL(contactpersonmobile,''),'#',IFNULL(contactpersonemail,''),'#',IFNULL(LocalityID,''),'#',IF(IFNULL(cm.`PaytmMid`,'')<>'' AND IFNULL(cm.`PaytmGuid`,'')<>'' AND IFNULL(cm.`PaytmKey`,'')<>'','1','0'),'#',IFNULL(cm.`COCO_FOCO`,''),'#',0,'#',IFNULL(CountryID,'')) CentreID,Centre FROM centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@CentreID) or cm.CentreID =@CentreID) and cm.isActive=1 order by cm.CentreCode",
            //   new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
            //ddlCentre.DataValueField = "CentreID";
            //ddlCentre.DataTextField = "Centre";
            //ddlCentre.DataBind();


            //ddlPatientType.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT panelGroupID,PanelGroup FROM `f_panelgroup` WHERE Active=1 ORDER BY printOrder ").Tables[0];
            //ddlPatientType.DataValueField = "panelGroupID";
            //ddlPatientType.DataTextField = "PanelGroup";
            //ddlPatientType.DataBind();

            // PatientTypeTask.Dispose();
            //  CentreTask.Dispose();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }


    }

    [WebMethod(EnableSession = true)]
    public static string SaveNewRegistration(object PatientData, Ledger_Transaction LTData, List<Patient_Lab_InvestigationOPD> PLO, List<Receipt> Rcdata, List<BookingRequiredField> RequiredField, List<Sample_Barcode> sampledata, string sampledategiven, byte isVipM, object patientScanDocument)
    {
        //ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        //bool b = MT.SaveRequestCount(1);
        //int ReqCount = MT.GetIPCount(1);
        //if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        //{
           // return "Too Many Request,Try Again after some";
        //}
        byte ReVisit = 0;
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Your Session Expired Please Login Again" });
        }
        if (LTData.Adjustment > 0)
        {
            if (Util.GetDecimal(LTData.Adjustment + LTData.Currency_RoundOff) != Util.GetDecimal(Rcdata.Select(s => s.Amount).Sum()))
            {
                string Msg = string.Concat("ClientName :", LTData.PanelName, " ;UserName :", UserInfo.LoginName, " ;ActualPaidAmt: ", Rcdata.Select(s => s.Amount).Sum(), " ;ChangePaidAmt : ", Util.GetDecimal(LTData.Adjustment + LTData.Currency_RoundOff), " ;DateTime :", DateTime.Now.ToString("dd-MM-yyyy hh:mm tt"));
                CreateFolder cf = new CreateFolder();
                cf.CreateNewFolder(Msg, "PaidAmount");
                return JsonConvert.SerializeObject(new { status = false, response = "Paid Amount Mismatch" });
            }
        }
        //var resultData = (from PLOOrder in PLO
        //                  where
        //                  (PLOOrder.ItemId == Util.GetInt(Common.Decrypt(PLOOrder.EncryptedItemID)) && PLOOrder.Rate != Util.GetDecimal(Common.Decrypt(PLOOrder.EncryptedRate)))
        //                  select PLOOrder).ToList();
        //if (resultData.Count > 0)
        //{
        //    string ItemID = string.Join(", ", resultData.Select(z => Common.Decrypt(z.EncryptedItemID)));
        //    string actualRate = string.Join(", ", resultData.Select(z => Common.Decrypt(z.EncryptedRate)));
        //    string changeRate = string.Join(", ", resultData.Select(z => z.Rate));

        //    string Msg = string.Concat("ClientName :", LTData.PanelName, " ;UserName :", UserInfo.LoginName, " ;ItemID: ", ItemID, " ;ActualRate: ", actualRate, " ;ChangeRate : ", changeRate, " ;DateTime :", DateTime.Now.ToString("dd-MM-yyyy hh:mm tt"));
        //    CreateFolder cf = new CreateFolder();
        //    cf.CreateNewFolder(Msg, "RateChange");
        //    return JsonConvert.SerializeObject(new { status = false, response = "Item Rate Mismatch" });
        //}
        (from PLOData in PLO
         select PLOData).ToList().ForEach((PLOData) =>
             {
                 //PLOData.Rate = Util.GetDecimal(Common.Decrypt(PLOData.EncryptedRate));
                 //PLOData.Amount = Util.GetDecimal(Common.Decrypt(PLOData.EncryptedAmount)) * PLOData.Quantity;// sunil change for qnty
                 //PLOData.DiscountAmt = Util.GetDecimal(Common.Decrypt(PLOData.EncryptedDiscAmt));
                 //PLOData.MRP = Util.GetDecimal(Common.Decrypt(PLOData.EncryptedMRP));
                 PLOData.Rate = Util.GetDecimal(PLOData.Rate);
                 PLOData.Amount = Util.GetDecimal(PLOData.Amount) * PLOData.Quantity;// sunil change for qnty
                 PLOData.DiscountAmt = Util.GetDecimal(PLOData.DiscountAmt);
                 PLOData.MRP = Util.GetDecimal(PLOData.MRP);
             });

        sbyte isItemWiseDisc = 0; decimal totalDiscAmt = 0;
        if (PLO.Select(x => x.DiscountAmt).Sum() > 0)
        {
            isItemWiseDisc = 1;

        }
        decimal getTotalRate = PLO.Sum(x => Util.GetDecimal(x.Rate));

        if (isItemWiseDisc == 0 && LTData.CouponID == 0)
        {
            if (getTotalRate != 0)
            {
                foreach (Patient_Lab_InvestigationOPD objPlo in PLO)
                {
                    decimal discountAmt = 0;
                    var discper = Math.Round((Util.GetDecimal(LTData.DiscountOnTotal) * 100) / Util.GetDecimal(getTotalRate), 2, MidpointRounding.AwayFromZero);
                    if (PLO.Last().ItemId == objPlo.ItemId)
                    {
                        discountAmt = Math.Round(Util.GetDecimal(LTData.DiscountOnTotal) - Util.GetDecimal(totalDiscAmt), 0, MidpointRounding.AwayFromZero);
                    }
                    else
                    {
                        discountAmt = Math.Round(Util.GetDecimal((Util.GetDecimal(objPlo.Rate) * Util.GetDecimal(discper)) / 100), 0, MidpointRounding.AwayFromZero);
                        totalDiscAmt += discountAmt;
                    }

                    (from PLOData in PLO
                     select PLOData).Where(s => s.ItemId == objPlo.ItemId).ToList().ForEach((PLOData) =>
                     {
                         PLOData.Amount = Util.GetDecimal((objPlo.Rate * objPlo.Quantity) - discountAmt);//sunil change for qnty
                         PLOData.DiscountAmt = Util.GetDecimal(discountAmt);
                     });
                }
            }
        }
        else if (isItemWiseDisc == 1 && LTData.CouponID != 0)
        {
            foreach (Patient_Lab_InvestigationOPD objPlo in PLO)
            {
                (from PLOData in PLO
                 select PLOData).Where(s => s.ItemId == objPlo.ItemId).ToList().ForEach((PLOData) =>
                 {
                     PLOData.Amount = Util.GetDecimal((objPlo.Rate * objPlo.Quantity) - objPlo.DiscountAmt);
                     PLOData.DiscountAmt = Util.GetDecimal(objPlo.DiscountAmt);
                     PLOData.CouponAmt = Util.GetDecimal(objPlo.DiscountAmt);
                 });
            }
        }
        else
        {
            if (LTData.CouponID != 0)
            {
                decimal TotalCouponAmt = 0;
                var CouponAmtDetail = LTData.CouponAmtDetail.ToList();
                for (int p = 0; p < CouponAmtDetail.Count(); p++)
                {
                    TotalCouponAmt += Util.GetDecimal(Common.Decrypt(CouponAmtDetail[p]));
                }


                if (LTData.CouponType == 1) //Total Bill
                {
                    decimal discper = 0;
                    if (getTotalRate != 0)
                        discper = Math.Round((Util.GetDecimal(TotalCouponAmt) * 100) / Util.GetDecimal(getTotalRate), 2, MidpointRounding.AwayFromZero);
                    foreach (Patient_Lab_InvestigationOPD objPlo in PLO)
                    {
                        decimal discountAmt = 0;

                        if (PLO.Last().ItemId == objPlo.ItemId)
                        {
                            discountAmt = Math.Round(Util.GetDecimal(TotalCouponAmt) - Util.GetDecimal(totalDiscAmt), 0, MidpointRounding.AwayFromZero);
                        }
                        else
                        {
                            discountAmt = Math.Round(Util.GetDecimal((Util.GetDecimal(objPlo.Rate) * Util.GetDecimal(discper)) / 100), 0, MidpointRounding.AwayFromZero);
                            totalDiscAmt += discountAmt;
                        }

                        (from PLOData in PLO
                         select PLOData).Where(s => s.ItemId == objPlo.ItemId).ToList().ForEach((PLOData) =>
                         {
                             PLOData.Amount = Util.GetDecimal((objPlo.Rate * objPlo.Quantity) - discountAmt);//sunil change for qnty
                             PLOData.DiscountAmt = Util.GetDecimal(discountAmt);
                             PLOData.PayByPatient = Util.GetDecimal((objPlo.Rate * objPlo.Quantity) - discountAmt);
                             PLOData.CouponAmt = Util.GetDecimal(discountAmt);
                         });
                    }
                }
                else
                {

                }
            }
        }




        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<Patient_Master> PatientDetail = new JavaScriptSerializer().ConvertToType<List<Patient_Master>>(PatientData);

            if (LTData.CouponID != 0 && LTData.CouponType == 2)//Test Wise
            {
                decimal TotalCouponAmt = 0;
                var CouponAmtDetail = LTData.CouponAmtDetail.ToList();
                for (int p = 0; p < CouponAmtDetail.Count(); p++)
                {
                    TotalCouponAmt += Util.GetDecimal(Common.Decrypt(CouponAmtDetail[p]));
                }


                string ItemID = string.Join(",", PLO.Select(s => s.ItemId).ToArray());

                using (DataTable dtCouponTestDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT IFNULL(discper,'0')discPer,IFNULL(discamount,'0')discAmount,ItemID FROM coupan_testwise WHERE coupanid=@CouponID AND ItemID IN(" + ItemID + ")",
                                                           new MySqlParameter("@CouponID", LTData.CouponID)).Tables[0])
                {
                    if (dtCouponTestDetail.Rows.Count > 0)
                    {
                        foreach (Patient_Lab_InvestigationOPD objPlo in PLO)
                        {
                            decimal discountAmt = 0;
                            decimal discper = 0;
                            var CouponItemFound = dtCouponTestDetail.AsEnumerable().Where(s => Util.GetInt(s["ItemID"]) == Util.GetInt(objPlo.ItemId));
                            if (CouponItemFound.Any())
                            {
                                using (DataTable dtDetail = CouponItemFound.CopyToDataTable())
                                {
                                    if (PLO.Last().ItemId == objPlo.ItemId)
                                    {
                                        discountAmt = Math.Round(Util.GetDecimal(TotalCouponAmt) - Util.GetDecimal(totalDiscAmt), 0, MidpointRounding.AwayFromZero);
                                    }
                                    else

                                        if (Util.GetDecimal(dtDetail.Rows[0]["discPer"].ToString()) > 0)
                                        {
                                            discountAmt = Math.Round(Util.GetDecimal((Util.GetDecimal(objPlo.Rate) * Util.GetDecimal(dtDetail.Rows[0]["discPer"])) / 100), 0, MidpointRounding.AwayFromZero);
                                            totalDiscAmt += discountAmt;
                                        }
                                        else if (Util.GetDecimal(dtDetail.Rows[0]["discAmount"].ToString()) > 0)
                                        {
                                            discper = Math.Round((Util.GetDecimal(dtDetail.Rows[0]["discAmount"].ToString()) * 100) / Util.GetDecimal(getTotalRate), 2, MidpointRounding.AwayFromZero);
                                            discountAmt = Math.Round(Util.GetDecimal((Util.GetDecimal(objPlo.Rate) * Util.GetDecimal(discper)) / 100), 0, MidpointRounding.AwayFromZero);
                                            totalDiscAmt += discountAmt;
                                        }
                                    (from PLOData in PLO
                                     select PLOData).Where(s => s.ItemId == objPlo.ItemId).ToList().ForEach((PLOData) =>
                                     {
                                         PLOData.Amount = Util.GetDecimal((objPlo.Rate * objPlo.Quantity) - discountAmt);//sunil change for qnty
                                         PLOData.DiscountAmt = Util.GetDecimal(discountAmt);
                                         PLOData.PayByPatient = Util.GetDecimal((objPlo.Rate * objPlo.Quantity) - discountAmt);
                                         PLOData.CouponAmt = Util.GetDecimal(discountAmt);
                                     });
                                }
                            }
                        }
                    }


                }

            }
            int CreatedByID = UserInfo.ID;
            string CreatedBy = UserInfo.LoginName;

            List<PatientDocuments> patientDocumentsDetails = new JavaScriptSerializer().ConvertToType<List<PatientDocuments>>(patientScanDocument);

            PatientDocument.SaveDocument(patientScanDocument, PatientDetail[0].Patient_ID);
            if (LTData.OutstandingEmployeeId != 0)
            {
                decimal MaxOutstandingBillPercent = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IFNULL(MaxBill,0)MaxBill FROM `cashoutstandingMaster` WHERE EmployeeID=@EmployeeID AND centerID=@centerID AND IsActive=1",
                                                                                              new MySqlParameter("@EmployeeID", LTData.OutstandingEmployeeId),
                                                                                              new MySqlParameter("@centerID", LTData.CentreID)));
                if (LTData.CashOutstandingPer > MaxOutstandingBillPercent)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Max Outstanding Bill Percent is ", MaxOutstandingBillPercent, " %") });
                }

                decimal MaxOutstanding = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IFNULL(MaxOutstandingAmt,0)MaxOutstandingAmt FROM cashoutstandingMaster WHERE employeeID=@employeeID AND centerID=@CentreID AND IsActive=1",
                                                                                   new MySqlParameter("@employeeID", LTData.OutstandingEmployeeId),
                                                                                   new MySqlParameter("@CentreID", LTData.CentreID)));

                decimal TotalOutstandingdiscount = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT SUM(NetAmount-Adjustment) FROM f_ledgertransaction WHERE OutstandingEmployeeId=@OutstandingEmployeeId AND OutstandingStatus!='-1' AND CentreID=@CentreID ",
                                                                                             new MySqlParameter("@OutstandingEmployeeId", LTData.OutstandingEmployeeId),
                                                                                             new MySqlParameter("@CentreID", LTData.CentreID)));
                TotalOutstandingdiscount = TotalOutstandingdiscount + Util.GetDecimal(LTData.CashOutstanding);

                if (TotalOutstandingdiscount > MaxOutstanding)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Max Outstanding  Limit Exceed" });
                }
            }

            int isPanelLocked = 0;
            if (LTData.PatientType == "CC" || LTData.PatientType == "FC" || LTData.PatientType == "B2B" || LTData.PatientType == "HLM")
            {
                if (LTData.showBalanceAmt == "1")
                {
                    int PanelShareID = 0;
                    if (PanelShareID == 0 && LTData.PatientType == "CC")
                    {
                        PanelShareID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT PanelShareID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                                                                             new MySqlParameter("@Panel_ID", LTData.Panel_ID)));
                    }
                    decimal InvoiceAmt = 0;
                    if (LTData.PatientType == "FC")
                    {
                        InvoiceAmt = Util.GetDecimal(PLO.Sum(x => x.Rate));
                    }
                    else if (LTData.PatientType == "B2B")
                    {
                        InvoiceAmt = Util.GetDecimal(PLO.Sum(x => x.Rate));
                    }
                    else if (LTData.PatientType == "HLM")
                    {
                        InvoiceAmt = Util.GetDecimal(PLO.Sum(x => x.Rate));
                    }

                    if (LTData.PatientType == "CC")
                    {

                        foreach (Patient_Lab_InvestigationOPD PLIO in PLO)
                        {
                            if (LTData.PatientType == "CC")
                            {
                                string ClientRate = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT `get_item_rate`(@ItemId,@PanelShareID,NOW(),@Panel_ID)",
                                                                                              new MySqlParameter("@ItemId", PLIO.ItemId),
                                                                                              new MySqlParameter("@PanelShareID", PanelShareID),
                                                                                              new MySqlParameter("@Panel_ID", LTData.Panel_ID)));
                                InvoiceAmt = Util.GetDecimal(InvoiceAmt) + Util.GetDecimal(ClientRate.Split('#')[0]);
                            }
                            
                        }
                    }

                    isPanelLocked = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT `isPanelLock`(@Panel_ID,'Booking',@InvoiceAmt) ",
                                                                          new MySqlParameter("@Panel_ID", LTData.Panel_ID),
                                                                          new MySqlParameter("@InvoiceAmt", InvoiceAmt)));
                    if (isPanelLocked > 0 && LTData.showBalanceAmt == "1")
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Credit limit exceeded and your account is locked, Kindly contact to account department" });
                    }
                }
            }

            // comment 262 to 375 
        //  if (PLO.Select(x => x.DiscountAmt).Sum() > 0)
        //  {
        //      foreach (Patient_Lab_InvestigationOPD PLIO in PLO)
        //      {
        //          if (PLIO.DiscountAmt > 0 && LTData.AppBelowBaseRate == 0 && PLIO.BaseRate > 0 && PLIO.Amount < PLIO.BaseRate)
        //          {
        //              //tnx.Rollback();
        //              //return JsonConvert.SerializeObject(new { status = false, response = "Base Limit Exceed" });
        //          }
        //          else
        //          {
        //
        //          }
        //      }
        //  }
            if (PLO.Select(x => x.DiscountAmt).Sum() == 0 && LTData.DiscountOnTotal > 0 && LTData.AppBelowBaseRate == 0)
            {
                decimal discPer = Math.Round(Util.GetDecimal(LTData.DiscountOnTotal * 100) / LTData.GrossAmount);
                foreach (Patient_Lab_InvestigationOPD PLIO in PLO)
                {
                    decimal netAmt = Util.GetDecimal(PLIO.Rate - (PLIO.Rate * discPer) / 100);
                    if (PLIO.BaseRate > 0 && netAmt < PLIO.BaseRate)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Base Limit Exceed" });
                    }
                }
            }

            if (PLO.Select(x => x.RequiredAttachment).Count() > 0)
            {
                List<patientDocumentList> reqAttachment = new List<patientDocumentList>();
                foreach (Patient_Lab_InvestigationOPD PLIO in PLO)
                {
                    if (PLIO.RequiredAttachment != string.Empty)
                    {
                        if (PLIO.IsPackage == 0)
                        {
                            for (int req = 0; req < PLIO.RequiredAttachment.Split('|').Length; req++)
                            {
                                reqAttachment.Add(new patientDocumentList { DocumentName = PLIO.RequiredAttachment.Split('|')[req] });
                            }
                        }
                        else
                        {
                            if (PLIO.IsPackage == 1)
                            {
                                var requiredAttachment = PLIO.RequiredAttachment.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                                for (int req = 0; req < requiredAttachment.Length; req++)
                                {
                                    if (requiredAttachment[req].Contains("|"))
                                    {
                                        for (int req1 = 0; req1 < requiredAttachment[req].Split('|').Length; req1++)
                                        {
                                            var reqAtt = requiredAttachment[req].Split('|')[req1];
                                            reqAttachment.Add(new patientDocumentList { DocumentName = requiredAttachment[req].Split('|')[req1] });
                                        }
                                    }
                                    else
                                    {
                                        reqAttachment.Add(new patientDocumentList { DocumentName = requiredAttachment[req] });

                                    }
                                    // reqAttachment.Add(new patientDocumentList { DocumentName = String.Join(",", PLIO.RequiredAttachment.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)) });

                                }
                            }
                        }
                    }

                }
                reqAttachment = reqAttachment.GroupBy(s => s.DocumentName).Select(g => g.First()).ToList();
                if (reqAttachment.Count > 0)
                {
                    var patientDocumentList = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DocumentName,DocumentID FROM document_detail WHERE labNo=@labNo AND IsActive=1",
                           new MySqlParameter("@labNo", LTData.AttachedFileName)).Tables[0].AsEnumerable().Select(i => new
                           {
                               DocumentID = i.Field<int>("DocumentID"),
                               DocumentName = i.Field<string>("DocumentName")
                           }).ToList();
                    if (reqAttachment.Count(b => b.DocumentName == "Doctor Prescription") > 0 && patientDocumentList.Where(s => s.DocumentName == "Doctor Prescription").Count() == 0)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Doctor Prescription Required to Attach With Booked Test" });
                    }

                    if (PatientDetail[0].Patient_ID == string.Empty)
                    {
                        HashSet<string> reqID = new HashSet<string>(reqAttachment.Select(s => s.DocumentName));
                        if (patientDocumentList.Where(m => reqID.Contains(m.DocumentName) && m.DocumentName != "Doctor Prescription" && m.DocumentName !="Consent Form").Count() == 0)
                        {
                           // tnx.Rollback();
                           // return JsonConvert.SerializeObject(new { status = false, response = string.Concat(string.Join(",", reqAttachment.Select(x => x.DocumentName).Distinct()), " Required to Attach With Booked Test") });
                        }
                    }
                    else
                    {

                        patientDocumentList = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DocumentName,DocumentID FROM document_detail dd INNER JOIN document_master dm on dd.DocumentID=dm.ID and dm.isAddressProof=1 WHERE PatientID=@PatientID AND dd.IsActive=1  UNION ALL SELECT DocumentName,DocumentID FROM document_detail WHERE labNo=@labNo AND IsActive=1 ",
                          new MySqlParameter("@PatientID", PatientDetail[0].Patient_ID), new MySqlParameter("@labNo", LTData.AttachedFileName)).Tables[0].AsEnumerable().Select(i => new
                          {
                              DocumentID = i.Field<int>("DocumentID"),
                              DocumentName = i.Field<string>("DocumentName")
                          }).ToList();

                        HashSet<string> reqID = new HashSet<string>(reqAttachment.Select(s => s.DocumentName));
                        if (patientDocumentList.Where(m => reqID.Contains(m.DocumentName) && m.DocumentName != "Doctor Prescription").Count() == 0)
                        {
                          //  tnx.Rollback();
                          //  return JsonConvert.SerializeObject(new { status = false, response = string.Concat(string.Join(",", reqAttachment.Select(x => x.DocumentName).Distinct()), " Required to Attach With Booked Test") });
                        }
                    }
                    reqAttachment.Clear();
                }
            }
            if (PLO.Select(x => x.IsMemberShipFreeTest).Count() > 0)
            {
                foreach (Patient_Lab_InvestigationOPD PLIO in PLO)
                {
                    if (PLIO.IsMemberShipFreeTest == 1)
                    {
                        sb = new StringBuilder();
                        if (LTData.IsSelfPatient == 0)
                            sb.Append(" SELECT (mem.`DependentFreeTestCount`-mem.`DependentFreeTestConsume`+@Quantity ) FreeTestBalance  FROM ");
                        else
                            sb.Append(" SELECT (mem.`SelfFreeTestCount`-mem.`SelfFreeTestConsume`+@Quantity ) FreeTestBalance  FROM ");
                        sb.Append(" `membershipcard_Detail` mem WHERE mem.cardvalid >=CURRENT_DATE AND ");
                        sb.Append("  mem.ID=@MemberShipTableID  AND mem.IsActive=1   ");

                        using (DataTable FreeTestBalance = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                             new MySqlParameter("@MemberShipTableID", PLIO.MemberShipTableID),
                             new MySqlParameter("@Quantity", PLIO.Quantity)).Tables[0])
                        {
                            if (FreeTestBalance.Rows.Count > 0)
                            {
                                if (Util.GetInt(FreeTestBalance.Rows[0]["FreeTestBalance"].ToString()) < 0)
                                {
                                    tnx.Rollback();
                                    return JsonConvert.SerializeObject(new { status = false, response = "MemberShip FreeTest Mismatch,Please Search Again" });
                                }
                            }
                            else
                            {
                                tnx.Rollback();
                                return JsonConvert.SerializeObject(new { status = false, response = "MemberShip FreeTest Mismatch,Please Search Again" });
                            }
                        }
                    }
                }
            }
            // comment 377 to 389 
            if (LTData.DiscountOnTotal > 0 && LTData.MemberShipCardNo == string.Empty)
            {

                decimal discthismonth = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT SUM(DiscountOnTotal) FROM f_ledgertransaction WHERE MembershipCardID=0 AND DiscountApprovedByID=@DiscountApprovedByID AND MONTH(DATE) =MONTH(NOW()) AND YEAR(DATE)=YEAR(NOW())  ",
                   new MySqlParameter("@DiscountApprovedByID", LTData.DiscountApprovedByID)));
                discthismonth = discthismonth + LTData.DiscountOnTotal;
                if (discthismonth >= Util.GetDecimal(LTData.DiscountPending))
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Discount Limit For this Month Exceed" });
                }
                decimal discPer = Math.Round(Util.GetDecimal(LTData.DiscountOnTotal * 100) / LTData.GrossAmount);
                if (discPer > LTData.DiscountPendingPer)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Max Discount is " + LTData.DiscountPendingPer + " % for this EmploPer Bill" });
                }
            }
            if (sampledata.Count > 0)
            {
                foreach (Sample_Barcode bar in sampledata)
                {
                    int a = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd where BarcodeNo=@BarcodeNo AND BarcodeNo<>'SNR'  ",
                                                                  new MySqlParameter("@BarcodeNo", bar.BarcodeNo)));
                    if (a > 0)
                    {
                        if (bar.BarcodeNo != string.Empty)
                        {
                          //  tnx.Rollback();
                           // return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Barcode No. Already Exist.Please Change Barcode No. for :", bar.InvestigationName) });
                        }
                    }
                }
            }
            string PatientID = string.Empty;
            int LedgerTransactionID = 0;
            string LedgerTransactionNo = string.Empty;
            if (PatientDetail[0].Patient_ID == string.Empty)
            {
                //if (Util.GetString(PatientDetail[0].Mobile).Trim() != string.Empty)
                //{
                //    int totPatientOnMob = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM patient_master  WHERE Mobile=@Mobile  ",
                //        new MySqlParameter("@Mobile", PatientDetail[0].Mobile)));
                //    if (totPatientOnMob >= 5)
                //    {
                //        tnx.Rollback();
                //        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Already More Than 5 Patient Registered With that Mobile No. : ", PatientDetail[0].Mobile, " Kindly Use Another Mobile No.") });
                //    }
                //}
                Patient_Master objPM = new Patient_Master(tnx)
                {
                    Title = isVipM == 1 ? "XX-XXXXXX" : PatientDetail[0].Title,
                    PName = isVipM == 1 ? "XX-XXXXXX" : PatientDetail[0].PName.ToUpper(),
                    House_No = PatientDetail[0].House_No,
                    Street_Name = PatientDetail[0].Street_Name,
                    Pincode = PatientDetail[0].Pincode,
                    Country = PatientDetail[0].Country,
                    State = PatientDetail[0].State,
                    City = PatientDetail[0].City,
                    Locality = PatientDetail[0].Locality,
                    CountryID = PatientDetail[0].CountryID,
                    StateID = PatientDetail[0].StateID,
                    CityID = PatientDetail[0].CityID,
                    LocalityID = PatientDetail[0].LocalityID,
                    Phone = PatientDetail[0].Phone,
                    Mobile = isVipM == 1 ? "XX-XXXXXX" : PatientDetail[0].Mobile,
                    Email = isVipM == 1 ? "XX-XXXXXX" : PatientDetail[0].Email,
                    DOB = PatientDetail[0].DOB,
                    Age = PatientDetail[0].Age,
                    AgeYear = PatientDetail[0].AgeYear,
                    AgeMonth = PatientDetail[0].AgeMonth,
                    AgeDays = PatientDetail[0].AgeDays,
                    TotalAgeInDays = PatientDetail[0].TotalAgeInDays,
                    Gender = PatientDetail[0].Gender,
                    CentreID = PatientDetail[0].CentreID,
                    IsOnlineFilterData = PatientDetail[0].IsOnlineFilterData,
                    IsDuplicate = PatientDetail[0].IsDuplicate,
                    IsDOBActual = PatientDetail[0].IsDOBActual,
                    ClinicalHistory = PatientDetail[0].ClinicalHistory,
                    VIP = PatientDetail[0].VIP
                };
                try
                {
                    PatientID = objPM.Insert();
                }
                catch (Exception exPm)
                {
                    if (exPm.Message.Contains("Duplicate entry") && exPm.Message.Contains("Patient_ID"))
                    {
                        PatientID = objPM.Insert();
                    }
                    else
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Patient Master Error" });
                    }
                }
            }
            else
            {
                PatientID = PatientDetail[0].Patient_ID;
                sb = new StringBuilder();
                sb.Append("  UPDATE patient_master ");
                sb.Append(" SET  ");
                sb.Append(" Email = @Email,Age = @Age,AgeYear =@AgeYear,CountryID=@CountryID, StateID =@StateID,CityID =@CityID,localityID =@localityID,");
                sb.Append(" Country=@Country,State =@State,City = @City,Locality =@Locality,AgeMonth =@AgeMonth, AgeDays =@AgeDays,TotalAgeInDays =@TotalAgeInDays,dob=@DOB,");
                sb.Append(" UpdateID =@UpdateID,IsDOBActual =@IsDOBActual,UpdateName =@UpdateName,UpdateDate = NOW(),ClinicalHistory=@ClinicalHistory,Vip=@Vip ");
                sb.Append(" WHERE Patient_ID =@Patient_ID;");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@Email", PatientDetail[0].Email),
                                            new MySqlParameter("@Age", PatientDetail[0].Age),
                                            new MySqlParameter("@AgeYear", PatientDetail[0].AgeYear),
                                            new MySqlParameter("@CountryID", PatientDetail[0].CountryID),
                                            new MySqlParameter("@StateID", PatientDetail[0].StateID),
                                            new MySqlParameter("@CityID", PatientDetail[0].CityID),
                                            new MySqlParameter("@localityID", PatientDetail[0].LocalityID),
                                            new MySqlParameter("@Country", PatientDetail[0].Country),
                                            new MySqlParameter("@State", PatientDetail[0].State),
                                            new MySqlParameter("@City", PatientDetail[0].City),
                                            new MySqlParameter("@Locality", PatientDetail[0].Locality),
                                            new MySqlParameter("@AgeMonth", PatientDetail[0].AgeMonth),
                                            new MySqlParameter("@AgeDays", PatientDetail[0].AgeDays),
                                            new MySqlParameter("@TotalAgeInDays", PatientDetail[0].TotalAgeInDays),
                                            new MySqlParameter("@DOB", Util.GetDateTime(PatientDetail[0].DOB).ToString("yyyy-MM-dd")),
                                            new MySqlParameter("@UpdateID", UserInfo.ID),
                                            new MySqlParameter("@IsDOBActual", PatientDetail[0].IsDOBActual),
                                            new MySqlParameter("@UpdateName", CreatedBy),
                                            new MySqlParameter("@Patient_ID", PatientDetail[0].Patient_ID),
                                            new MySqlParameter("@ClinicalHistory", PatientDetail[0].ClinicalHistory),
                                            new MySqlParameter("@Vip", PatientDetail[0].VIP));
                ReVisit = 1;
            }

            if (PatientID == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Patient Master Error" });
            }
            string EmployeeList = string.Empty;
            int SalesManager = 0;
            //int SalesManager = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SalesManager FROM f_Panel_Master WHERE Panel_Id=@Panel_Id",
            //                                                         new MySqlParameter("@Panel_Id", LTData.Panel_ID)));
            //if (SalesManager != 0)
            //    EmployeeList = AllLoad_Data.getSalesChildNode(con, SalesManager);

            DateTime billData = DateTime.Now;

             string proidnew = "0";

             proidnew = StockReports.ExecuteScalar("SELECT dr.`PROID`  FROM doctor_referal  dr  WHERE  dr.`Doctor_ID`='" + LTData.Doctor_ID + "' And dr.DoctorCode<>1 ");

            Ledger_Transaction objlt = new Ledger_Transaction(tnx)
            {
                DiscountOnTotal = LTData.DiscountOnTotal,
                NetAmount = PLO.Select(x => x.Amount).Sum(),
                GrossAmount = PLO.Select(x => x.Rate * x.Quantity).Sum(),//sunil cahnge for qnty
                isMask = LTData.isMask,
                IsCredit = LTData.IsCredit,
                Patient_ID = PatientID,
                Age = PatientDetail[0].Age,
                Gender = PatientDetail[0].Gender,
                VIP = LTData.VIP,
                Panel_ID = LTData.Panel_ID,
                PanelName = LTData.PanelName,
                Doctor_ID = LTData.Doctor_ID,
                DoctorName = LTData.DoctorName,
                OtherReferLabID = LTData.OtherReferLabID,
                CentreID = LTData.CentreID,
                Adjustment = Util.GetDecimal(LTData.Adjustment + LTData.Currency_RoundOff),
                CreatedByID = CreatedByID,
                HomeVisitBoyID = LTData.HomeVisitBoyID,
                PatientIDProof = LTData.PatientIDProof,
                PatientIDProofNo = LTData.PatientIDProofNo,
                PatientSource = LTData.PatientSource,
                PatientType = LTData.PatientType,
                VisitType = LTData.VisitType,
                HLMPatientType = LTData.HLMPatientType,
                HLMOPDIPDNo = LTData.HLMOPDIPDNo,
                DiscountApprovedByID = LTData.DiscountApprovedByID,
                DiscountApprovedByName = LTData.DiscountApprovedByName,
                CorporateIDCard = LTData.CorporateIDCard,
                CorporateIDType = LTData.CorporateIDType,
                AttachedFileName = LTData.AttachedFileName,
                ReVisit = ReVisit,
                CreatedBy = CreatedBy,
                DiscountID = LTData.DiscountID,
                OtherLabRefNo = LTData.OtherLabRefNo,
                WorkOrderID = LTData.WorkOrderID,
                PreBookingID = LTData.PreBookingID,
                Doctor_ID_Temp = LTData.Doctor_ID_Temp,
                IsDiscountApproved = LTData.IsDiscountApproved,
                CashOutstanding = LTData.CashOutstanding,
                OutstandingEmployeeId = LTData.OutstandingEmployeeId,
                BarCodePrintedType = LTData.BarCodePrintedType,
                BarCodePrintedCentreType = LTData.BarCodePrintedCentreType,
                BarCodePrintedHomeColectionType = LTData.BarCodePrintedHomeColectionType,
                setOfBarCode = LTData.setOfBarCode,
                SampleCollectionOnReg = LTData.SampleCollectionOnReg,
                InvoiceToPanelId = LTData.InvoiceToPanelId,
                PatientGovtType = LTData.PatientGovtType,
                CardHolderRelation = LTData.CardHolderRelation,
                CardHolderName = LTData.CardHolderName.ToUpper(),
                TempSecondRef = LTData.TempSecondRef,
                SecondReferenceID = LTData.SecondReferenceID,
                SecondReference = LTData.SecondReference,
                BillDate = billData,
                SalesTagEmployee = SalesManager,
                PName = isVipM == 1 ? "XX-XXXXXX" : string.Concat(PatientDetail[0].Title, PatientDetail[0].PName.ToUpper()),
                Currency_RoundOff = LTData.Currency_RoundOff,
                MemberShipCardNo = LTData.MemberShipCardNo,
                MembershipCardID = LTData.MembershipCardID,
                IsSelfPatient = LTData.IsSelfPatient,
                AppointmentID = LTData.AppointmentID,
                HomeCollectionAppID = LTData.HomeCollectionAppID,
                PassPortNo=LTData.PassPortNo,
                ECHS=LTData.ECHS,
                Nationality=LTData.Nationality,
                ICMRNo=LTData.ICMRNo,
                PureHealthID=LTData.PureHealthID,
                PROID = LTData.PROID,
                SRFNo=LTData.SRFNo,
                CouponID = LTData.CouponID,
                CouponName = LTData.CouponName,
                CouponCode = LTData.CouponCodeDetail,
                OneCouponOneMobileMultipleBilling = LTData.OneCouponOneMobileMultipleBilling,
                CouponClientShareType = LTData.CouponClientShareType,
                Children = LTData.Children,
                Son = LTData.Son,
                Daughter = LTData.Daughter,
                Pregnancydate = LTData.Pregnancydate,
                AgeSon = LTData.AgeSon,
                AgeDaughter = LTData.AgeDaughter,
                PndtDoctorId = LTData.PndtDoctorId



            };
            if (LTData.CouponID != 0)
                LTData.DiscountApprovedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            string retvalue = objlt.Insert();
            if (retvalue == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "LT Error" });
            }
            LedgerTransactionID = Util.GetInt(retvalue.Split('#')[0]);
            LedgerTransactionNo = retvalue.Split('#')[1];

            if (LTData.DispatchModeID != 0)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO f_ledgertransaction_DispatchMode(DispatchModeName,DispatchModeID,LedgerTransactionID,LedgerTransactionNo,CreatedDate) ");
                sb.Append(" VALUES(@DispatchModeName,@DispatchModeID,@LedgerTransactionID,@LedgerTransactionNo,@CreatedDate)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@DispatchModeName", LTData.DispatchModeName),
                                            new MySqlParameter("@DispatchModeID", LTData.DispatchModeID),
                                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                            new MySqlParameter("@CreatedDate", billData));
            }

            sb = new StringBuilder();
            sb.Append(" INSERT INTO f_ledgertransaction_Sales(LedgerTransactionID,LedgerTransactionNo,Sales,CreatedDate) ");
            sb.Append(" VALUES(@LedgerTransactionID,@LedgerTransactionNo,@Sales,@CreatedDate)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                        new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                        new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                        new MySqlParameter("@Sales", EmployeeList),
                                        new MySqlParameter("@CreatedDate", billData));

            if (isVipM == 1)
            {
                int isAlreadyInsert = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT COUNT(1) FROM  Patient_master_VIP WHERE Paitent_ID=@Paitent_ID",
                                                                            new MySqlParameter("@Paitent_ID", PatientID)));
                try
                {
                    if (isAlreadyInsert > 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Patient_master_VIP set title=@Title, Paitent_name=@Paitent_name,Mobile=@Mobile,emailID=@emailID, isActive=1 WHERE Paitent_ID=@Paitent_ID",
                                                    new MySqlParameter("@Title", PatientDetail[0].Title),
                                                    new MySqlParameter("@Paitent_name", PatientDetail[0].PName),
                                                    new MySqlParameter("@Mobile", PatientDetail[0].Mobile),
                                                    new MySqlParameter("@emailID", PatientDetail[0].Email),
                                                    new MySqlParameter("@Paitent_ID", PatientDetail[0].Patient_ID));
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO Patient_master_VIP (Paitent_ID,Paitent_name,Mobile,emailID,title) values(@Paitent_ID,@Paitent_name,@Mobile,@emailID,@Title) ",
                                                    new MySqlParameter("@Paitent_ID", PatientDetail[0].Patient_ID),
                                                    new MySqlParameter("@Paitent_name", PatientDetail[0].PName),
                                                    new MySqlParameter("@Mobile", PatientDetail[0].Mobile),
                                                    new MySqlParameter("@emailID", PatientDetail[0].Email),
                                                    new MySqlParameter("@Title", PatientDetail[0].Title));
                    }
                }
                catch (Exception ex)
                {
                    ClassLog CL = new ClassLog();
                    CL.errLog(ex);
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "VIP Patient Error" });
                }
            }
            if (objlt.AttachedFileName != string.Empty)
            {
                int filecount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM document_detail WHERE  labNo=@labNo",
                   new MySqlParameter("@labNo", LTData.AttachedFileName)));
                //    if (filecount == 0)
                //    {
                //        tnx.Rollback();
                //        return JsonConvert.SerializeObject(new { status = false, response = "Document Not Uploaded, Kindly Upload The Document" });

                //    }
                if (filecount > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  document_detail SET labNo=@LedgerTransactionNo,PatientID=@PatientID WHERE  labNo=@labNo",
                                                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                                new MySqlParameter("@labNo", LTData.AttachedFileName),
                                                new MySqlParameter("@PatientID", PatientID));
                }
                //else
                //{
                //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  f_ledgertransaction SET AttachedFileName='' WHERE  LedgerTransactionNo=@LedgerTransactionNo",
                //        new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
                //}
            }

            DataTable dtSample = new DataTable();
            dtSample.Columns.Add("SampleType");
            dtSample.Columns.Add("SubCategoryID");
            dtSample.Columns.Add("BarcodeNo");
            string Barcode = string.Empty;
            byte barcodePreprinted = 0;
            int DepartmentTokenNo = 0;
            List<DepartmentTokenNoDetail> DepartmentTokenNoDetail = new List<DepartmentTokenNoDetail>();
            string BillNo = AllLoad_Data.getBillNo(LTData.CentreID, "B", con, tnx);
            if (BillNo == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "BillNo Error" });
            }

            if (LTData.DiscountOnTotal > 0)
            {
                string DiscountReason = LTData.DiscountReason;
                if (LTData.MemberShipCardNo != string.Empty)
                    DiscountReason = "MemberShip Discount";
                sb = new StringBuilder();
                sb.Append(" INSERT INTO f_ledgertransaction_DiscountReason(LedgerTransactionID,LedgerTransactionNo,DiscountReason,CreatedByID,CreatedBy,BillNo,CreatedDate) ");
                sb.Append(" VALUES(@LedgerTransactionID,@LedgerTransactionNo,@DiscountReason,@CreatedByID,@CreatedBy,@BillNo,@CreatedDate)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                            new MySqlParameter("@DiscountReason", LTData.DiscountReason),
                                            new MySqlParameter("@CreatedByID", CreatedByID),
                                            new MySqlParameter("@CreatedBy", CreatedBy),
                                            new MySqlParameter("@BillNo", BillNo),
                                            new MySqlParameter("@CreatedDate", billData));
            }

            string BillType = "Credit-Test Add";
            foreach (Patient_Lab_InvestigationOPD plo in PLO)
            {
                if (plo.IsPackage == 0 && plo.DepartmentDisplayName != string.Empty)
                {
                    if (DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == plo.DepartmentDisplayName).Count() > 0)
                    {
                        DepartmentTokenNo = DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == plo.DepartmentDisplayName).Select(s => s.DepartmentTokenNo).First();
                    }
                    else
                    {
                        DepartmentTokenNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_department_tokenNo(@CentreID,@DepartmentDisplayName,@CreatedDate)",
                                                            new MySqlParameter("@CentreID", plo.CentreID),
                                                            new MySqlParameter("@DepartmentDisplayName", plo.DepartmentDisplayName),
                                                            new MySqlParameter("@CreatedDate", DateTime.Now.ToString("yyyy-MM-dd"))));

                        DepartmentTokenNoDetail.Add(new DepartmentTokenNoDetail { DepartmentTokenNo = DepartmentTokenNo, DepartmentDisplayName = plo.DepartmentDisplayName });
                    }
                }
                else
                {
                    DepartmentTokenNo = 0;
                }

                string sampleType = string.Empty;
                sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAt(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`=@Investigation_Id AND ist.`IsDefault`=1 ",
                                                                      new MySqlParameter("@Investigation_Id", plo.Investigation_ID)));
                int BarcodeCount;
                if (LTData.BarcodeManual != string.Empty)
                {
                    BarcodeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Count(1) FROM patient_labinvestigation_opd ist where barcodeno=@barcodeno and LedgertransactionID <>@LabID",
                                                                          new MySqlParameter("@barcodeno", LTData.BarcodeManual), new MySqlParameter("@LabID", LedgerTransactionID)));
                    if (BarcodeCount > 0)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "BarcodeNo already exist !!" });
                    }
                }
                if (LTData.BarcodeManual == string.Empty)
                {
                    if (LTData.BarCodePrintedType == "System")
                    {
                        barcodePreprinted = 0;
                        if (plo.IsPackage == 0)
                        {
                           // if (dtSample.Select(string.Format("SampleType='{0}' and SubCategoryID='{1}'", sampleType.Split('#')[0], plo.SubCategoryID)).Length == 0)
                            if (dtSample.Select(string.Format("BarcodeNo='{0}'", Barcode)).Length == 0)
                            {
                                Barcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                                                                    new MySqlParameter("@SubCategoryID", plo.SubCategoryID)).ToString();
                                DataRow dr = dtSample.NewRow();
                                dr["SampleType"] = sampleType.Split('#')[0];
                                dr["SubCategoryID"] = plo.SubCategoryID;
                                dr["BarcodeNo"] = Barcode;
                                dtSample.Rows.Add(dr);
                                dtSample.AcceptChanges();
                            }
                            else
                            Barcode = dtSample.Rows[0]["BarcodeNo"].ToString();
                        }
                    }
                    else
                    {
                        barcodePreprinted = 1;
                    }
                }
                string PackName = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IF(im.`SubCategoryID`=15,IF(IFNULL(im.`Inv_ShortName`,'')='',im.`TypeName`,im.`Inv_ShortName`),'')PackName  FROM f_itemmaster im WHERE im.itemid=@ItemId ",
                                                                           new MySqlParameter("@ItemId", plo.ItemId)));


                //if (PLO.Select(x => x.DiscountAmt).Sum() > 0)
                //{
                //    isItemWiseDisc = 1;
                //}

                Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
                objPlo.LedgerTransactionID = LedgerTransactionID;
                objPlo.LedgerTransactionNo = LedgerTransactionNo;
                objPlo.Patient_ID = PatientID;
                objPlo.AgeInDays = PatientDetail[0].TotalAgeInDays;
                objPlo.Gender = PatientDetail[0].Gender;
                if (LTData.BarcodeManual == "")
                {
                    if (barcodePreprinted == 1)
                    {
                        try
                        {
                            if (sampledata.Count > 0)
                            {
                                objPlo.BarcodeNo = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).BarcodeNo;
                                if (objPlo.BarcodeNo != string.Empty && sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).IsSNR == 0)
                                {
                                    objPlo.IsSampleCollected = "S";

                            }
                            else
                            {
                                objPlo.IsSampleCollected = "N";
                            }
                        }
                        else
                        {
                            objPlo.BarcodeNo = string.Empty;
                        }
                    }
                    catch
                    {
                        objPlo.BarcodeNo = "SNR";
                    }
                }
                else
                {
                    objPlo.BarcodeNo = Barcode;
      }
                }
            
                else
                {
                    objPlo.BarcodeNo = LTData.BarcodeManual;
                }


                objPlo.ItemId = plo.ItemId;
                objPlo.ItemCode = plo.ItemCode.ToUpper();
                objPlo.ItemName = plo.ItemName.ToUpper();
                objPlo.PackageName = PackName.ToUpper();
                objPlo.PackageCode = plo.PackageCode;
                objPlo.Investigation_ID = plo.Investigation_ID;
                objPlo.IsPackage = plo.IsPackage;
                objPlo.SubCategoryID = plo.SubCategoryID;
                objPlo.Rate = plo.Rate;


                objPlo.DiscountAmt = plo.DiscountAmt;
                objPlo.Amount = plo.Amount;

                objPlo.DiscountByLab = plo.DiscountByLab;
                objPlo.CouponAmt = plo.CouponAmt;
                objPlo.PayByPanel = plo.PayByPanel;
                objPlo.PayByPanelPercentage = plo.PayByPanelPercentage;
                objPlo.PayByPatient = plo.PayByPatient;
                objPlo.Quantity = plo.Quantity;
                objPlo.IsRefund = 0;
                objPlo.IsReporting = plo.IsReporting;
                objPlo.ReportType = plo.ReportType;
                objPlo.CentreID = plo.CentreID;
                objPlo.TestCentreID = plo.TestCentreID;
                objPlo.IsSampleCollected = plo.IsSampleCollected;
                objPlo.barcodePreprinted = barcodePreprinted;
                try
                {
                    if (objPlo.barcodePreprinted == 1)
                    {
                        objPlo.SampleTypeID = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeID;
                        objPlo.SampleTypeName = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeName;
                        if (sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).IsSNR == 1 || sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).BarcodeNo == string.Empty)
                        {
                            objPlo.IsSampleCollected = "N";
                        }
                        else
                        {
                            objPlo.IsSampleCollected = "S";
                        }
                    }
                    else
                    {
                        objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                        objPlo.SampleTypeName = sampleType.Split('#')[1];
                    }
                }
                catch
                {
                    objPlo.IsSampleCollected = plo.IsSampleCollected;
                }
                if (objPlo.IsSampleCollected == "S")
                {
                    objPlo.SampleCollector = CreatedBy;
                    objPlo.SampleCollectionBy = CreatedByID;
                    if (LTData.VisitType == "Home Collection")
                    {
                        objPlo.SampleCollectionDate = Util.GetDateTime(plo.SampleCollectionDate);
                    }
                    else
                    {
                        objPlo.SampleCollectionDate = Util.GetDateTime(DateTime.Now);
                    }
                }
                objPlo.SampleBySelf = plo.SampleBySelf;
                objPlo.isUrgent = plo.isUrgent;
                objPlo.DeliveryDate = plo.DeliveryDate;
                objPlo.SRADate = plo.SRADate;

                objPlo.IsScheduleRate = plo.IsScheduleRate;
                objPlo.MRP = plo.MRP == 0 ? plo.Rate : plo.MRP;
                objPlo.Date = billData;
                objPlo.PanelItemCode = plo.PanelItemCode;


                if (objPlo.ReportType == 5 || objPlo.ReportType == 11)
                {
                    objPlo.IsSampleCollected = "Y";
                    objPlo.TestCentreID = objPlo.CentreID;
                    objPlo.SampleCollectionDate = Util.GetDateTime(DateTime.Now);
                    objPlo.SampleCollector = CreatedBy;
                    objPlo.SampleCollectionBy = CreatedByID;

                    //objPlo.SampleReceiveDate = Util.GetDateTime(DateTime.Now);

                    //objPlo.SampleReceiver = CreatedBy;
                    //objPlo.SampleReceivedBy = CreatedByID;
                }
                objPlo.BillNo = BillNo;
                objPlo.BillType = string.Empty;
                objPlo.IsActive = 1;
                objPlo.CreatedBy = CreatedBy;
                objPlo.CreatedByID = CreatedByID;
                objPlo.BaseCurrencyRound = Util.GetByte(Resources.Resource.BaseCurrencyRound);
                objPlo.BillType = BillType;
                objPlo.IsSampleCollectedByPatient = plo.IsSampleCollectedByPatient;
                objPlo.DepartmentTokenNo = DepartmentTokenNo;

                objPlo.IsMemberShipFreeTest = plo.IsMemberShipFreeTest;
                objPlo.MemberShipDisc = plo.MemberShipDisc;
                objPlo.MemberShipTableID = plo.MemberShipTableID;
                objPlo.IsMemberShipDisc = plo.IsMemberShipDisc;
                objPlo.SubCategoryName = plo.SubCategoryName;
                string ID = objPlo.Insert();

                if (ID == string.Empty)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "PLO Error" });
                }
                if (plo.IsMemberShipFreeTest == 1)
                {
                    if (LTData.MemberShipCardNo != string.Empty)
                    {
                        sb = new StringBuilder();
                        sb.Append(" UPDATE membershipcard_Detail SET ");
                        if (LTData.IsSelfPatient == 0)
                            sb.Append(" DependentFreeTestConsume=DependentFreeTestConsume+@Quantity");
                        else
                            sb.Append(" SelfFreeTestConsume=SelfFreeTestConsume+@Quantity");
                        sb.Append("  WHERE ID=@MemberShipTableID ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@MemberShipTableID", plo.MemberShipTableID),
                           new MySqlParameter("@Quantity", plo.Quantity));


                    }
                    else
                    {
                        sb = new StringBuilder();
                        sb.Append(" UPDATE EmployeeDiscount_Detail SET ");
                        if (LTData.IsSelfPatient == 0)
                            sb.Append(" DependentFreeTestConsume=DependentFreeTestConsume+@Quantity");
                        else
                            sb.Append(" SelfFreeTestConsume=SelfFreeTestConsume+@Quantity");
                        sb.Append("  WHERE ID=@MemberShipTableID ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@MemberShipTableID", plo.MemberShipTableID),
                           new MySqlParameter("@Quantity", plo.Quantity));
                    }
                }
                if (LTData.MemberShipCardNo != string.Empty)
                {

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO membershiptest_workorder (ItemID,MembershipCardNo,LedgerTransactionID,dtEntry,CreatedByID,CreatedByName,Test_Id)");
                    sb.Append(" values ");
                    sb.Append(" (@ItemID,@MembershipCardNo,@LedgerTransactionID,@dtEntry,@CreatedByID,@CreatedByName,@Test_Id) ");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@ItemID", objPlo.ItemId),
                                                new MySqlParameter("@MembershipCardNo", LTData.MemberShipCardNo),
                                                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                                new MySqlParameter("@CreatedByID", UserInfo.ID),
                                                new MySqlParameter("@Test_Id", ID),
                                                new MySqlParameter("@dtEntry", billData),
                                                new MySqlParameter("@CreatedByName", UserInfo.LoginName));



                }

                if (LTData.Remarks != string.Empty)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO patient_labinvestigation_opd_remarks  ");
                    sb.Append("  (`UserID`,`UserName`,`Test_ID`,`Remarks`,`LedgerTransactionNo`,`ShowOnline`,DATE,LedgerTransactionID) ");
                    sb.Append("  VALUES (@UserID,@UserName,@Test_ID,@Remarks,@LedgerTransactionNo,1,@DATE,@LedgerTransactionID)");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@UserID", CreatedByID),
                                                new MySqlParameter("@UserName", CreatedBy),
                                                new MySqlParameter("@Test_ID", ID),
                                                new MySqlParameter("@Remarks", LTData.Remarks.Replace("'", string.Empty)),
                                                new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                                new MySqlParameter("@DATE", billData),
                                                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                }
                if (plo.IsPackage == 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                                                new MySqlParameter("@SinNo", objPlo.BarcodeNo),
                                                new MySqlParameter("@Test_ID", ID),
                                                new MySqlParameter("@Status", string.Format("Registration Done ({0})", plo.ItemName.ToUpper())),
                                                new MySqlParameter("@UserID", CreatedByID),
                                                new MySqlParameter("@UserName", CreatedBy),
                                                new MySqlParameter("@IpAddress", StockReports.getip()),
                                                new MySqlParameter("@CentreID", LTData.CentreID),
                                                new MySqlParameter("@RoleID", UserInfo.RoleID),
                                                new MySqlParameter("@dtEntry", billData),
                                                new MySqlParameter("@DispatchCode", string.Empty),
                                                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                    if (objPlo.IsSampleCollected == "S")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                    new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                                                    new MySqlParameter("@SinNo", objPlo.BarcodeNo),
                                                    new MySqlParameter("@Test_ID", ID),
                                                    new MySqlParameter("@Status", string.Format("Sample Collected ({0})", plo.ItemName.ToUpper())),
                                                    new MySqlParameter("@UserID", CreatedByID),
                                                    new MySqlParameter("@UserName", CreatedBy),
                                                    new MySqlParameter("@IpAddress", StockReports.getip()),
                                                    new MySqlParameter("@CentreID", LTData.CentreID),
                                                    new MySqlParameter("@RoleID", UserInfo.RoleID),
                                                    new MySqlParameter("@dtEntry", billData),
                                                    new MySqlParameter("@DispatchCode", string.Empty),
                                                    new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));

                        if (Resources.Resource.SRARequired == "0")
                        {
                            sb = new StringBuilder();
                            sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,testID) ");
                            sb.Append(" VALUES(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,@dtLogisticReceive,@LogisticReceiveDate,@LogisticReceiveBy,@Test_ID);");

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                        new MySqlParameter("@BarcodeNo", objPlo.BarcodeNo),
                                                        new MySqlParameter("@FromCentreID", UserInfo.Centre),
                                                        new MySqlParameter("@ToCentreID", UserInfo.Centre),
                                                        new MySqlParameter("@DispatchCode", string.Empty),
                                                        new MySqlParameter("@Qty", 1),
                                                        new MySqlParameter("@EntryBy", CreatedByID),
                                                        new MySqlParameter("@STATUS", "Received"),
                                                        new MySqlParameter("@dtLogisticReceive", billData),
                                                        new MySqlParameter("@LogisticReceiveDate", DateTime.Now),
                                                        new MySqlParameter("@LogisticReceiveBy", CreatedByID),
                                                        new MySqlParameter("@Test_ID", ID));


                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                         new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                                                         new MySqlParameter("@SinNo", objPlo.BarcodeNo),
                                                         new MySqlParameter("@Test_ID", ID),
                                                         new MySqlParameter("@Status", string.Format("SIN No. {0} {1}", objPlo.BarcodeNo, "Received")),
                                                         new MySqlParameter("@UserID", CreatedByID),
                                                         new MySqlParameter("@UserName", CreatedBy),
                                                         new MySqlParameter("@IpAddress", StockReports.getip()),
                                                       new MySqlParameter("@CentreID", UserInfo.Centre),
                                                       new MySqlParameter("@RoleID", UserInfo.RoleID),
                                                         new MySqlParameter("@dtEntry", billData),
                                                         new MySqlParameter("@DispatchCode", string.Empty),
                                                         new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));

                        }
                    }
                }
                if (plo.IsPackage == 1)
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT imm.`Name` ,imm.`Investigation_Id`,imm.`Type` sampleData,imm.`Reporting`,imm.`ReportType`,");
                    sb.Append(" Get_DeliveryDate(@CentreID,imm.Investigation_ID,now())DeliveryDate,");
                    sb.Append(" (SELECT IFNULL(DisplayName,'')DisplayName FROM f_itemmaster fim INNER JOIN f_subcategorymaster sb ON sb.subcategoryid=fim.subcategoryid WHERE type_id=imm.`Investigation_Id` AND fim.isactive=1 limit 1) DepartmentDisplayName, ");
                    sb.Append(" (SELECT IFNULL(Name,'')SubCategoryName FROM f_itemmaster fim INNER JOIN f_subcategorymaster sb ON sb.subcategoryid=fim.subcategoryid WHERE type_id=imm.`Investigation_Id` AND fim.isactive=1 limit 1) SubCategoryName, ");
                    sb.Append(" (SELECT `SubCategoryID` FROM f_itemmaster WHERE type_id=imm.`Investigation_Id` AND isactive=1 limit 1)subcategoryID,pld.SampleDefinedPackage,imm.TestCode ");
                    sb.Append("     ,UPPER(IF(IFNULL(im.`Inv_ShortName`,'')='',im.`TypeName`,im.`Inv_ShortName`))PackName  ");
                    sb.Append("      FROM f_itemmaster im  ");

                    sb.Append("      INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID   ");
                    sb.Append("     INNER JOIN investigation_master imm  ON imm.Investigation_Id=pld.InvestigationID ");
                    sb.Append("     AND  im.`ItemID`=@ItemID ");

                    using (DataTable dtpackinfo = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                                            new MySqlParameter("@ItemID", plo.ItemId),
                                                                            new MySqlParameter("@CentreID", LTData.CentreID)).Tables[0])
                    {
                        decimal totalpackagemrp = 0;

                        List<string> pacitem = new List<string>();
                        foreach (DataRow dw in dtpackinfo.Rows)
                        {
                            pacitem.Add(dw["Investigation_Id"].ToString());
                        }
                        string[] pacitemTags = String.Join(",", pacitem).Split(',');
                        string[] pacitemParamNames = pacitemTags.Select(
                          (s, i) => "@tag" + i).ToArray();
                        string pacitemClause = string.Join(", ", pacitemParamNames);

                        pacitem.Clear();
                        sb = new StringBuilder();
                        sb.Append("SELECT sum(rate) FROM f_ratelist WHERE ItemID in({0}) AND panel_id=(SELECT `ReferenceCodeOPD` ");
                        sb.Append(" FROM f_panel_master WHERE centreID=@CentreID and  panelType='Centre' )");  
                         
                        using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), pacitemClause), con))
                        {
                            for (int i = 0; i < pacitemParamNames.Length; i++)
                            {
                                cmd.Parameters.AddWithValue(pacitemParamNames[i], pacitemTags[i]);
                            }
                            cmd.Parameters.AddWithValue("@CentreID", LTData.CentreID);
                            totalpackagemrp = Util.GetDecimal(cmd.ExecuteScalar());
                        }
						//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\25-Mar-2021\iop2.txt",sb.ToString() +";;" + LTData.CentreID.ToString());
                        foreach (DataRow dw in dtpackinfo.Rows)
                        {
                            if (Util.GetString(dw["DepartmentDisplayName"]).ToString() != string.Empty)
                            {
                                if (DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == Util.GetString(dw["DepartmentDisplayName"])).Count() > 0)
                                {
                                    DepartmentTokenNo = DepartmentTokenNoDetail.Where(s => s.DepartmentDisplayName == Util.GetString(dw["DepartmentDisplayName"])).Select(s => s.DepartmentTokenNo).First();
                                }
                                else
                                {
                                    DepartmentTokenNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_department_tokenNo(@CentreID,@DepartmentDisplayName,@CreatedDate)",
                                                                        new MySqlParameter("@CentreID", plo.CentreID),
                                                                        new MySqlParameter("@DepartmentDisplayName", dw["DepartmentDisplayName"]),
                                                                        new MySqlParameter("@CreatedDate", DateTime.Now.ToString("yyyy-MM-dd"))));

                                    DepartmentTokenNoDetail.Add(new DepartmentTokenNoDetail { DepartmentTokenNo = DepartmentTokenNo, DepartmentDisplayName = Util.GetString(dw["DepartmentDisplayName"]) });
                                }
                            }
                            else
                            {
                                DepartmentTokenNo = 0;
                            }

                            sampleType = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where  `Investigation_Id`=@Investigation_Id AND ist.`IsDefault`=1",
                                                                                  new MySqlParameter("@Investigation_Id", dw["Investigation_ID"].ToString())));

                            if (LTData.BarcodeManual != "")
                            {
                                BarcodeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Count(*) FROM patient_labinvestigation_opd ist where barcodeno=@barcodeno and LedgertransactionID <>@LabID",
                                                                                      new MySqlParameter("@barcodeno", LTData.BarcodeManual), new MySqlParameter("@LabID", LedgerTransactionID)));
                                if (BarcodeCount > 0)
                                {
                                    tnx.Rollback();
                                    return JsonConvert.SerializeObject(new { status = false, response = "BarcodeNo already exist !!" });
                                }
                            }

                            if (LTData.BarCodePrintedType == "System")
                            {
                                barcodePreprinted = 0;

                                if (dtSample.Select(string.Format("BarcodeNo='{0}'", Barcode)).Length == 0)
                                {
                                    Barcode = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                                                                        new MySqlParameter("@SubCategoryID", dw["SubCategoryID"].ToString())).ToString();
                                    DataRow dr = dtSample.NewRow();
                                    dr["SampleType"] = sampleType.Split('#')[0];
                                    dr["SubCategoryID"] = dw["SubCategoryID"].ToString();
                                    dr["BarcodeNo"] = Barcode;
                                    dtSample.Rows.Add(dr);
                                    dtSample.AcceptChanges();
                                }
                                else
                                    Barcode = dtSample.Rows[0]["BarcodeNo"].ToString();
                            }
                            else
                            {
                                barcodePreprinted = 1;
                            }

                            objPlo = new Patient_Lab_InvestigationOPD(tnx);
                            objPlo.LedgerTransactionID = LedgerTransactionID;
                            objPlo.LedgerTransactionNo = LedgerTransactionNo;
                            objPlo.Patient_ID = PatientID;
                            objPlo.AgeInDays = PatientDetail[0].TotalAgeInDays;
                            objPlo.Gender = PatientDetail[0].Gender;
                            if (LTData.BarcodeManual == "")
                            {
                                if (barcodePreprinted == 1)
                                {
                                    try
                                    {
                                        if (sampledata.Count > 0)
                                        {
                                            objPlo.BarcodeNo = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).BarcodeNo;
                                        }
                                        else
                                        {
                                            objPlo.BarcodeNo = string.Empty;
                                        }
                                    }
                                    catch
                                    {
                                        objPlo.BarcodeNo = "SNR";
                                    }
                                }
                                else
                                {
                                    objPlo.BarcodeNo = Barcode;
                                }
                            }
                            else
                            {
                                objPlo.BarcodeNo = LTData.BarcodeManual;
                            }
                            objPlo.ItemId = plo.ItemId;
                            objPlo.ItemCode = dw["TestCode"].ToString().ToUpper();
                            objPlo.ItemName = dw["name"].ToString().ToUpper();
                            objPlo.PackageName = dw["PackName"].ToString();
                            objPlo.PackageCode = plo.PackageCode;

                            objPlo.Investigation_ID = Util.GetInt(dw["Investigation_Id"].ToString());
                            objPlo.IsPackage = 1;
                            objPlo.SubCategoryID = Util.GetInt(dw["SubCategoryID"].ToString());
                            objPlo.Rate = 0;
                            objPlo.Amount = 0;
                            objPlo.DiscountAmt = 0;
                            objPlo.CouponAmt = 0;
                            objPlo.PayByPanel = 0;
                            objPlo.PayByPanelPercentage = 0;
                            objPlo.PayByPatient = 0;

                            objPlo.Quantity = plo.Quantity;
                            objPlo.IsRefund = 0;
                            objPlo.IsReporting = Util.GetByte(dw["Reporting"].ToString());
                            objPlo.ReportType = Util.GetByte(dw["ReportType"].ToString());
                            objPlo.CentreID = plo.CentreID;
                            objPlo.TestCentreID = plo.TestCentreID;
                            if (dw["SampleDefinedPackage"].ToString() == "0")
                            {
                                objPlo.IsSampleCollected = "N";
                            }
                            else
                            {
                                objPlo.IsSampleCollected = plo.IsSampleCollected;
                            }
                            objPlo.barcodePreprinted = barcodePreprinted;
                            try
                            {
                                if (objPlo.barcodePreprinted == 1)
                                {
                                    if (sampledata.Count > 0)
                                    {
                                        objPlo.SampleTypeID = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeID;
                                        objPlo.SampleTypeName = sampledata.FirstOrDefault(p => p.InvestigationID == plo.Investigation_ID).SampleTypeName;
                                    }
                                    else
                                    {
                                        objPlo.SampleTypeID = 0;
                                        objPlo.SampleTypeName = string.Empty;
                                    }
                                }
                                else
                                {
                                    objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                                    objPlo.SampleTypeName = sampleType.Split('#')[1];
                                }
                            }
                            catch
                            {
                            }
                            if (objPlo.IsSampleCollected == "S")
                            {
                                objPlo.SampleCollector = CreatedBy;
                                objPlo.SampleCollectionBy = CreatedByID;
                                if (plo.BarcodeNo != string.Empty && plo.BarcodeNo != null)
                                {
                                    objPlo.SampleCollectionDate = Util.GetDateTime(plo.SampleCollectionDate);
                                }
                                else
                                {
                                    objPlo.SampleCollectionDate = billData;
                                }
                            }
                            if (objPlo.ReportType == 5 )
                            {
                                objPlo.IsSampleCollected = "Y";
                                objPlo.TestCentreID = objPlo.CentreID;
                                objPlo.SampleCollectionDate = Util.GetDateTime(DateTime.Now);
                                objPlo.SampleCollector = CreatedBy;
                                objPlo.SampleCollectionBy = CreatedByID;

                                //objPlo.SampleReceiveDate = Util.GetDateTime(DateTime.Now);

                                //objPlo.SampleReceiver = CreatedBy;
                                //objPlo.SampleReceivedBy = CreatedByID;
                            }
                            objPlo.SampleBySelf = plo.SampleBySelf;
                            objPlo.isUrgent = plo.isUrgent;
                            objPlo.DeliveryDate = plo.DeliveryDate;
                            objPlo.SRADate = plo.SRADate;

                            objPlo.Date = billData;

                           decimal PackageMRP =0;// Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Rate FROM f_ratelist WHERE ItemID=@ItemID AND panel_id=(SELECT `ReferenceCodeOPD` FROM f_panel_master WHERE centreID=@centreID AND panelType='Centre')",
                        //                                                                   new MySqlParameter("@ItemID", dw["Investigation_Id"].ToString()),
                        //                                                                   new MySqlParameter("@centreID", LTData.CentreID)));
                            //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\25-Mar-2021\iop.txt",Util.GetString(plo.Amount)+";;"+ Util.GetString(PackageMRP) +";;" + totalpackagemrp.ToString());
                            decimal PackageMRPPercentage = 0;// (PackageMRP * 100) / totalpackagemrp;

                            decimal PackageMRPNet = 0;// (Util.GetDecimal(plo.Amount) * PackageMRPPercentage) / 100;

                            objPlo.PackageMRP = PackageMRP;
                            objPlo.PackageMRPPercentage = PackageMRPPercentage;
                            objPlo.PackageMRPNet = PackageMRPNet;
                            objPlo.BillNo = BillNo;
                            objPlo.BillType = string.Empty;
                            objPlo.IsActive = 1;
                            objPlo.CreatedBy = CreatedBy;
                            objPlo.CreatedByID = CreatedByID;
                            objPlo.BaseCurrencyRound = Util.GetByte(Resources.Resource.BaseCurrencyRound);
                            objPlo.BillType = BillType;
                            objPlo.IsSampleCollectedByPatient = plo.IsSampleCollectedByPatient;
                            objPlo.DepartmentTokenNo = DepartmentTokenNo;
                            objPlo.SubCategoryName = dw["SubCategoryName"].ToString();
                            string ID1 = objPlo.Insert();

                            if (ID1 == string.Empty)
                            {
                                tnx.Rollback();
                                return JsonConvert.SerializeObject(new { status = false, response = "PLO Package Error" });
                            }
                            if (LTData.Remarks != string.Empty)
                            {
                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO patient_labinvestigation_opd_remarks(`UserID`,`UserName`,`Test_ID`,`Remarks`,`LedgerTransactionNo`,`ShowOnline`,DATE,LedgerTransactionID)");
                                sb.Append("  VALUES (@UserID,@UserName,@Test_ID,@Remarks,@LedgerTransactionNo,@ShowOnline,@DATE,@LedgerTransactionID)");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                            new MySqlParameter("@UserID", CreatedByID),
                                                            new MySqlParameter("@UserName", CreatedBy),
                                                            new MySqlParameter("@Test_ID", ID1),
                                                            new MySqlParameter("@Remarks", LTData.Remarks),
                                                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                                            new MySqlParameter("@ShowOnline", "1"),
                                                            new MySqlParameter("@DATE", billData), new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                            }
                            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                            //                            new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                            //                            new MySqlParameter("@SinNo", objPlo.BarcodeNo),
                            //                            new MySqlParameter("@Test_ID", ID1),
                            //                            new MySqlParameter("@Status", string.Format("Registration Done ({0})", objPlo.ItemName.ToUpper())),
                            //                            new MySqlParameter("@UserID", CreatedByID),
                            //                            new MySqlParameter("@UserName", CreatedBy),
                            //                            new MySqlParameter("@IpAddress", StockReports.getip()),
                            //                            new MySqlParameter("@CentreID", LTData.CentreID),
                            //                            new MySqlParameter("@RoleID", UserInfo.RoleID),
                            //                            new MySqlParameter("@dtEntry", billData),
                            //                            new MySqlParameter("@DispatchCode", string.Empty),
                            //                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                            if (objPlo.IsSampleCollected == "S")
                            {
                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                //                            new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                                //                            new MySqlParameter("@SinNo", objPlo.BarcodeNo), new MySqlParameter("@Test_ID", ID1),
                                //                            new MySqlParameter("@Status", string.Format("Sample Collected ({0})", objPlo.ItemName.ToUpper())), new MySqlParameter("@UserID", CreatedByID), new MySqlParameter("@UserName", CreatedBy), new MySqlParameter("@dtEntry", billData),
                                //                            new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", LTData.CentreID), new MySqlParameter("@RoleID", UserInfo.RoleID),
                                //                            new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));


                                if (Resources.Resource.SRARequired == "0")
                                {
                                    sb = new StringBuilder();
                                    sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,testID) ");
                                    sb.Append(" VALUES(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,@dtLogisticReceive,@LogisticReceiveDate,@LogisticReceiveBy,@Test_ID);");

                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                                new MySqlParameter("@BarcodeNo", objPlo.BarcodeNo),
                                                                new MySqlParameter("@FromCentreID", UserInfo.Centre), new MySqlParameter("@ToCentreID", UserInfo.Centre),
                                                                new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@Qty", 1),
                                                                new MySqlParameter("@EntryBy", CreatedByID),
                                                                new MySqlParameter("@STATUS", "Received"), new MySqlParameter("@dtLogisticReceive", DateTime.Now),
                                                                new MySqlParameter("@LogisticReceiveDate", DateTime.Now), new MySqlParameter("@LogisticReceiveBy", CreatedByID),
                                                                new MySqlParameter("@Test_ID", ID1));


                                    //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                    //                            new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                                    //                            new MySqlParameter("@SinNo", objPlo.BarcodeNo), new MySqlParameter("@Test_ID", ID1),
                                    //                            new MySqlParameter("@Status", string.Format("SIN No. {0} {1}", objPlo.BarcodeNo, "Received")), new MySqlParameter("@UserID", CreatedByID), new MySqlParameter("@UserName", CreatedBy),
                                    //                            new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@dtEntry", billData),
                                    //                            new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));

                                }
                            }
                        }
                    }
                }
            }
            if (objlt.Adjustment > 0)
            {
                foreach (Receipt rrc in Rcdata)
                {
                    Receipt objRC = new Receipt(tnx)
                    {
                        LedgerNoCr = "OPD003",
                        LedgerTransactionID = LedgerTransactionID,
                        LedgerTransactionNo = LedgerTransactionNo,
                        CreatedByID = CreatedByID,
                        Patient_ID = PatientID,
                        PayBy = rrc.PayBy,
                        PaymentMode = rrc.PaymentMode,
                        PaymentModeID = rrc.PaymentModeID,
                        Amount = rrc.Amount,
                        BankName = rrc.BankName,
                        CardNo = rrc.CardNo,
                        CardDate = rrc.CardDate,
                        IsCancel = 0,
                        Narration = rrc.Narration,
                        CentreID = rrc.CentreID,
                        Panel_ID = LTData.Panel_ID,
                        CreatedDate = billData,
                        S_Amount = rrc.S_Amount,
                        S_CountryID = rrc.S_CountryID,
                        S_Currency = rrc.S_Currency,
                        S_Notation = rrc.S_Notation,
                        C_Factor = rrc.C_Factor,
                        Currency_RoundOff = rrc.Currency_RoundOff,
                        CurrencyRoundDigit = rrc.CurrencyRoundDigit,
                        CreatedBy = CreatedBy,
                        Converson_ID = rrc.Converson_ID,
                        transactionid = rrc.transactionid
                    };
                    string ReceiptNo = objRC.Insert();
                    if (ReceiptNo == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
                    }

                    var patientAdvancePaymentMode = Rcdata.Where(p => p.PaymentModeID == 9).ToList();
                    for (int i = 0; i < patientAdvancePaymentMode.Count; i++)
                    {
                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmount,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE Patient_ID =@Patient_ID  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmount,0))>0 AND AdvanceType='Patient' ORDER BY ID+0",
                            new MySqlParameter("@Patient_ID", PatientID)).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                decimal advanceAmount = patientAdvancePaymentMode[i].Amount;
                                for (int s = 0; s < dt.Rows.Count; s++)
                                {
                                    decimal paidAmt = 0;
                                    if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                                    {
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmount =BalanceAmount+@advanceAmount WHERE ID =@ID ",
                                                                    new MySqlParameter("@advanceAmount", Util.GetDecimal(advanceAmount)),
                                                                    new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));
                                        paidAmt = advanceAmount;
                                        advanceAmount = 0;
                                    }
                                    else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                                    {
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmount =BalanceAmount+@BalanceAmount WHERE ID =@ID ",
                                                                    new MySqlParameter("@BalanceAmount", Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString())),
                                                                    new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));

                                        advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                        paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                    }

                                    OPD_Advance_Detail adv = new OPD_Advance_Detail(tnx)
                                    {
                                        PaidAmount = Util.GetDecimal(paidAmt),
                                        Patient_ID = PatientID,
                                        LedgerTransactionID = LedgerTransactionID,
                                        LedgerTransactionNo = LedgerTransactionNo,
                                        ReceiptNo = ReceiptNo,
                                        CentreID = LTData.CentreID,
                                        Panel_ID = LTData.Panel_ID,
                                        CreatedBy = CreatedBy,
                                        CreatedByID = CreatedByID,
                                        AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString()),
                                        ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString(),
                                        AdvanceType = "Patient"
                                    };

                                    adv.Insert();
                                    if (advanceAmount == 0)
                                        break;
                                }
                                if (advanceAmount > 0)
                                {
                                    tnx.Rollback();
                                    return JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                                }
                            }
                            else
                            {
                                tnx.Rollback();
                                return JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                            }
                        }
                    }
                }
            }



            //sb = new StringBuilder();
            //sb.Append(" SELECT lm.`LabObservation_ID`,lm.`Name`,plo.`ItemName` FROM `patient_labinvestigation_opd` plo ");
            //sb.Append(" INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=plo.`Investigation_ID` ");
            //sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` ");
            //sb.Append(" WHERE AllowDuplicateBooking=0 AND `LedgerTransactionID`>0 AND  plo.`LedgerTransactionID`=@LedgerTransactionID ");
            //sb.Append(" GROUP BY lm.`LabObservation_ID` HAVING COUNT(*) >1  ");
            //using (DataTable dtDuplicate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
            //   new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)).Tables[0])
            //{
            //    if (dtDuplicate.Rows.Count > 0)
            //    {
            //        tnx.Rollback();
            //        return JsonConvert.SerializeObject(new { status = false, response = string.Concat(dtDuplicate.Rows[0]["Name"].ToString(), " Found duplicate in ", dtDuplicate.Rows[0]["ItemName"].ToString()) });
            //    }
            //}

            foreach (BookingRequiredField objrequired in RequiredField)
            {
                BookingRequiredField objrequ = new BookingRequiredField(tnx)
                {
                    FieldID = objrequired.FieldID,
                    FieldName = objrequired.FieldName,
                    FieldValue = objrequired.FieldValue,
                    Unit = objrequired.Unit,
                    LedgerTransactionID = LedgerTransactionID,
                    LedgerTransactionNo = LedgerTransactionNo
                };
                if (objrequ.Insert() == 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Required Field Error" });

                }
            }
            Panel_Share ps = new Panel_Share();
            JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(LedgerTransactionID, tnx, con));
            if (IPS.status == false)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = IPS.response });
            }


            //Pyatm Payment
            //Receipt PayTm = Rcdata.Where(x => x.PaymentModeID == 9 && x.PaymentMode == "PayTM").FirstOrDefault();
            //JavaScriptSerializer js = new JavaScriptSerializer();
            //string walletSystemTxnId = string.Empty;
            //string PaytmLedgerTransactionID = string.Empty;
            //string PaytmPosID = string.Empty;
            //string PaytmOrderID = string.Empty;
            //string PaytmAmount = "0";
            //string PaytmMobile = string.Empty;
            //string PaytmOtp = string.Empty;
            //if (Rcdata.Any(item => item.PaymentModeID == 8))
            //{
            //    PaytmAmount = Util.GetString(PayTm.Amount);
            //    PaytmMobile = Util.GetString(PayTm.PayTmMobile);
            //    PaytmOtp = Util.GetString(PayTm.PayTmOtp);
            //    PaytmOrderID = Util.GetString(Guid.NewGuid().ToString());
            //    PaytmPosID = Util.GetString(LedgerTransactionNo);
            //    if (Resources.Resource.PayTM == "1" && PayTm.PaymentModeID == 9 && PayTm.PaymentMode == "PayTM")
            //    {
            //        PaytmLedgerTransactionID = Util.GetString(LedgerTransactionID);
            //        var response = js.Deserialize<PaymentResponse>(PaymentGateway.withdrawal(PaytmMobile, PaytmOtp, PaytmPosID, "Payment", PaytmAmount, PaytmOrderID));
            //        if (response.status == "SUCCESS" && response.statusCode == "SUCCESS" && response.statusMessage == "SUCCESS")
            //        {
            //            walletSystemTxnId = response.response.walletSystemTxnId;
            //            // PaymentGateway.SavePaytm(PaytmOrderID, PaytmLedgerTransactionID, PaytmPosID, PaytmAmount, "WITHDRAW_MONEY", "1", PaytmMobile, PaytmOtp, walletSystemTxnId);
            //        }
            //        if (response.status != "SUCCESS" && response.statusCode != "SUCCESS" && response.statusMessage != "SUCCESS")
            //        {
            //            tnx.Rollback();
            //            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(response.statusMessage) });
            //        }
            //    }
            //}

            if (LTData.AppointmentID != 0)
            {
                try
                {
                    int isAlreadyBook = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM appointment_radiology_details WHERE AppointmentID=@AppointmentID AND IsBooked=1",
                       new MySqlParameter("@AppointmentID", LTData.AppointmentID)));
                    if (isAlreadyBook > 0)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Appointment Already Booked...!" });
                    }                    

                    decimal appamt = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT ROUND(Adjustment)Adjustment FROM appointment_radiology_details WHERE AppointmentID=@AppointmentID limit 1",
                        new MySqlParameter("@AppointmentID", LTData.AppointmentID)));
                    if (appamt > 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_receipt SET LedgertransactionID=@LedgertransactionID,LedgerTransactionNo=@LedgerTransactionNo,Patient_ID=@Patient_ID WHERE AppointmentID=@AppointmentID",
                           new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                           new MySqlParameter("@LedgertransactionID", LedgerTransactionID),
                           new MySqlParameter("@Patient_ID", LTData.Patient_ID), 
                           new MySqlParameter("@AppointmentID", LTData.AppointmentID));



                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction SET Adjustment=Adjustment + @PaidAmount,AdjustmentDate=NOW() WHERE LedgertransactionID=@LedgertransactionID",
                           new MySqlParameter("@PaidAmount", appamt), new MySqlParameter("@LedgertransactionID", LedgerTransactionID));
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE appointment_radiology_details SET Adjustment=Adjustment+@Adjustment,LedgerTransactionNo=@LedgertransactionNo,BookedDate=Now(),BookedByID=@BookingByID,BookedBy=@BookingByName,IsBooked=1 WHERE AppointmentID=@AppointmentID",
                        new MySqlParameter("@Adjustment", LTData.Adjustment),
                       new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo), new MySqlParameter("@LedgertransactionID", LedgerTransactionID),
                       new MySqlParameter("@AppointmentID", LTData.AppointmentID),
                       new MySqlParameter("@BookingByID", UserInfo.ID), new MySqlParameter("@BookingByName", UserInfo.LoginName));
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Appointment Error" });
                }
            }
            if (LTData.HomeCollectionAppID != 0)
            {
                try
                {
                    int isAlreadyBook = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM app_appointment WHERE ID=@HomeCollectionAppID AND IsBooking=1",
                       new MySqlParameter("@HomeCollectionAppID", LTData.HomeCollectionAppID)));
                    if (isAlreadyBook > 0)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "HomeCollectionAppID Already Booked...!" });
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE app_appointment SET labno=@LedgertransactionNo,IsBooking=1 WHERE ID=@HomeCollectionAppID",
                       new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                       new MySqlParameter("@HomeCollectionAppID", LTData.HomeCollectionAppID));
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "HomeCollection Error" });
                }
            }
            if (LTData.PreBookingID != 0)
            {
                try
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd_prebooking SET LedgertransactionID=@LedgertransactionID,BookingDate=@BookingDate,BookingByID=@BookingByID,BookingByName=@BookingByName,BookingCentreID=@BookingCentreID WHERE PreBookingID=@PreBookingID",
                                                new MySqlParameter("@LedgertransactionID", LedgerTransactionID),
                                                new MySqlParameter("@PreBookingID", LTData.PreBookingID),
                                                new MySqlParameter("@BookingDate", billData),
                                                new MySqlParameter("@BookingByID", CreatedByID),
                                                new MySqlParameter("@BookingByName", CreatedBy),
                                                new MySqlParameter("@BookingCentreID", LTData.CentreID));
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "PreBooking Error" });
                }
            }
            try
            {
                if (LTData.CashOutstanding > 0)
                {
                    string emailto = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT email FROM `employee_master` WHERE employee_id=@employee_id",
                        new MySqlParameter("@employee_id", LTData.OutstandingEmployeeId)));
                    if (emailto != string.Empty)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO Email_Cashoutstanding(Employee_ID,Email,LedgerTransactionID)VALUES(@Employee_ID,@Email,@LedgerTransactionID) ",
                                                    new MySqlParameter("@Employee_ID", LTData.OutstandingEmployeeId),
                                                    new MySqlParameter("@Email", emailto),
                                                    new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));


                    }
                    else
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "CashOutstanding Email not Set" });
                    }
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Cash Outstanding Error" });
            }
            if (PatientDetail[0].isCapTure == "1")
            {
                try
                {
                    DateTime patientEnrolledDate = DateTime.Now;

                    patientEnrolledDate = Util.GetDateTime(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT pm.dtEntry FROM  patient_master pm  WHERE pm.Patient_ID=@Patient_ID",
                                                                                    new MySqlParameter("@Patient_ID", PatientDetail[0].Patient_ID)));

                    var directoryPath = new DirectoryInfo(string.Concat(Resources.Resource.DocumentPath, "\\PatientPhoto\\", patientEnrolledDate.Year.ToString(), "\\", patientEnrolledDate.Month.ToString()));


                    if (directoryPath.Exists == false)
                        directoryPath.Create();

                    string filePath = Path.Combine(directoryPath.ToString(), PatientID.Replace("/", "_"), ".jpg");
                    if (File.Exists(filePath))
                        File.Delete(filePath);

                    string strImage = PatientDetail[0].base64PatientProfilePic.Replace(PatientDetail[0].base64PatientProfilePic.Split(',')[0] + ",", string.Empty);
                    File.WriteAllBytes(filePath, Convert.FromBase64String(strImage));

                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Error on Patient Image Upload" });
                }
            }
            //Employee Email not set  Validation
            if (LTData.DiscountOnTotal > 0 && LTData.MemberShipCardNo == string.Empty)
            {
                AllLoad_Data sd = new AllLoad_Data();
                JSONResponse discApproval = JsonConvert.DeserializeObject<JSONResponse>(sd.sendDiscountVerificationMail(LedgerTransactionNo, objlt.PName, objlt.Age, objlt.Gender, LTData.DiscountApprovedByID, LTData.GrossAmount, LTData.DiscountOnTotal, LTData.NetAmount, LTData.DiscountReason, LTData.CentreID, LedgerTransactionID, con, tnx));
                if (discApproval.status == false)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = discApproval.response });
                }
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmount,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE Panel_ID =@Panel_ID  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmount,0))>0 AND AdvanceType='Client' ORDER BY ID+0",
                                                             new MySqlParameter("@Panel_ID", LTData.Panel_ID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {

                    decimal advanceAmount = LTData.NetAmount;
                    for (int s = 0; s < dt.Rows.Count; s++)
                    {
                        decimal paidAmt = 0;
                        if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmount =BalanceAmount+@advanceAmount WHERE ID =@ID ",
                                                        new MySqlParameter("@advanceAmount", Util.GetDecimal(advanceAmount)),
                                                        new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));
                            paidAmt = advanceAmount;
                            advanceAmount = 0;
                        }
                        else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmount =BalanceAmount+@BalanceAmount WHERE ID =@ID ",
                                                        new MySqlParameter("@BalanceAmount", Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString())),
                                                        new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));

                            advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                            paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                        }

                        OPD_Advance_Detail adv = new OPD_Advance_Detail(tnx)
                        {
                            PaidAmount = Util.GetDecimal(paidAmt),
                            Patient_ID = PatientID,
                            LedgerTransactionID = LedgerTransactionID,
                            LedgerTransactionNo = LedgerTransactionNo,
                            ReceiptNo = string.Empty,
                            CentreID = LTData.CentreID,
                            Panel_ID = LTData.Panel_ID,
                            CreatedBy = CreatedBy,
                            CreatedByID = CreatedByID,
                            AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString()),
                            ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString(),
                            AdvanceType = "Client"
                        };

                        adv.Insert();
                        if (advanceAmount == 0)
                            break;
                    }
                    //if (advanceAmount > 0)
                    //{
                    //    tnx.Rollback();
                    //    return JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient Client Advance Balance", message = "Error In Client Advance" });
                    //}
                }
                else
                {
                    //tnx.Rollback();
                    //return JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient Client Advance Balance", message = "Error In Client Advance" });
                }
               //sms configuration
                try
                {
        
                    if (PatientDetail[0].Mobile != string.Empty && PatientDetail[0].Mobile != null)
                    {
                        string smsText = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Template FROM sms_template WHERE SMS_type='Billing'"));
                        smsText = smsText.Replace("<PName>", objlt.PName.ToUpper()).Replace("<LabNo>", LedgerTransactionNo);
                        if (smsText != null && smsText != string.Empty)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO SMS(Mobile_no,SMS_Text,SMS_Type,Issend)VALUES(@Mobile_no,@SMS_Text,'Billing',0)",
                                new MySqlParameter("@Mobile_no",PatientDetail[0].Mobile), new MySqlParameter("@SMS_Text", smsText));
                        }
                    }
		
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Error on SMS" });
                }

            }
	
		 tnx.Commit();
           
	      //---Registration Email-----
            try
            {
                ReportEmailClass objEmail = new ReportEmailClass();
                objEmail.SendRegistrationMail(LedgerTransactionID);
            }
            catch { 
            
            }
            //------------------	

           // tnx.Commit();
            int MRPBill = 0;
            if ((LTData.PatientTypeID == 9 || LTData.PatientTypeID == 10 || LTData.PatientTypeID == 3) && LTData.IsMRPBill == 1)
                MRPBill = 1;
            return JsonConvert.SerializeObject(new { status = true, LabID = Common.Encrypt(Util.GetString(LedgerTransactionID)), No = LedgerTransactionNo, MRPBill = Common.Encrypt(Util.GetString(MRPBill)) });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { Status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindAllRequiredField(string item)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] itemTags = item.Split(',');
            string[] itemNames = itemTags.Select((s, i) => "@tag" + i).ToArray();
            string itemClause = string.Join(", ", itemNames);
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT id,FieldName,InputType,IF(IsUnit=1,Unit,'') Unit,IF(InputType='DropDownList',DropDownOption,'')DropDownOption");
            sb.Append(" FROM `requiredfield_master` WHERE id IN ({0}) AND ID NOT IN (12)");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), itemClause), con))
            {
                for (int i = 0; i < itemNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(itemNames[i], itemTags[i]);
                }

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string PreBookingData(string PreBookingNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  DATE_FORMAT(COALESCE(ActualHomeCollectionDateTime,SampleCollectionDateTime),'%d-%b-%Y %h:%i %p')ActualHomeCollectionDateTime,Patient_ID,Title,PName,House_No,Mobile,Gender,IF(PinCode=0,'',PinCode)PinCode,Email,DATE_FORMAT(dob,'%d-%b-%Y')DOB,Age,StateID,CityID,LocalityID,");
            sb.Append(" VisitType,VIP,IFNULL(PatientIDProof,'')PatientIDProof,PatientIDProofNo,IFNULL(PatientSource,'')PatientSource,DispatchModeName,Remarks,IsDOBActual,AgeYear,AgeMonth,AgeDays,");
            sb.Append(" ItemId value,ItemName label,CONCAT(Rate,'#',0)MRP,CONCAT(Rate,'#',0)Rate,SubCategoryID,TestCode,IsPackage,Panel_ID,if(SubCategoryID='15','Package','Test') `type`, ");
            sb.Append(" PaymentMode,DATE_FORMAT(SampleCollectionDateTime,'%d-%b-%Y')SampleCollectionDate,DATE_FORMAT(SampleCollectionDateTime,'%h:%i %p')SampleCollectionTime,ReferedDoctor,OtherDoctor,PaymentModeID,PaymentRefNo ");
            sb.Append(",(SELECT COUNT(1) FROM document_detail  WHERE labno=@PreBookingID )DocCount,0 DiscPer");
            sb.Append(" FROM patient_labinvestigation_opd_prebooking WHERE PreBookingID=@PreBookingID  AND IsCancel=0 AND CancelTest=0 AND IsConfirm=1 AND IFNULL(LedgertransactionID,'')='' ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@PreBookingID", PreBookingNo)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    return Util.getJson(dt);
                }
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindPreBookingPanel(int PanelID, string PaymentMode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendFormat(" SELECT CONCAT(pn.panel_id,'#',pn.ReferenceCode,'#',pn.Payment_Mode,'#',pn.MinBalReceive,'#',pn.hiderate,'#',pn.PanelType,'#',pn.Panel_Code,'#',IFNULL(pn.`Contact_Person`,''),'#',pn.Mobile,'#',IFNULL(pn.EmailID,''),'#',pn.InvoiceTo,'#',pn.`showBalanceAmt`,'#',isPanelLock(pn.panel_id,'Booking',0),'#',pn.DiscountAllowed,'#',pn.ShowCollectionCharge,'#',pn.CollectionCharge,'#',pn.ShowDeliveryCharge,'#',pn.DeliveryCharge,'#',pn.PanelID_MRP,'#',IsOtherLabReferenceNo,'#',pn.CoPaymentApplicable,'#',pn.CoPaymentEditonBooking,'#',ReceiptType,'#',pn.MRPBill,'#',pn.panelgroupid,'#',pn.proid  )value,CONCAT(pn.`Panel_Code`,' ',pn.company_name)label, ", PaymentMode);
            sb.Append(" pn.ReferenceCode,pn.Panel_ID,pn.PanelType,pn.BarCodePrintedType,pn.BarCodePrintedCentreType,pn.BarCodePrintedHomeColectionType,pn.setOfBarCode,pn.SampleCollectionOnReg  FROM  ");
            sb.Append("  f_panel_master pn WHERE pn.panel_id=@PanelID  ");
            sb.Append("  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@PanelID", PanelID)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string RecommendedPackage(string TestId, string referenceCodeOPD, string TotalAmount)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] itemTags = TestId.Split(',');
            string[] itemNames = itemTags.Select((s, i) => "@tag" + i).ToArray();
            string itemClause = string.Join(", ", itemNames);

            StringBuilder sb = new StringBuilder();


            sb.Append(" SELECT DISTINCT fm.TypeName as Name,fm.ItemId, fr.Rate, fr.rate-@rate AS Diff, ");
            sb.Append("     IFNULL((SELECT GROUP_CONCAT(imm.name SEPARATOR '##')ItemDetail  ");
            sb.Append("     FROM  f_itemmaster im   ");
            sb.Append("     INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID  ");
            sb.Append("     INNER JOIN investigation_master imm ON imm.Investigation_Id=pld.InvestigationID  ");
            sb.Append("     WHERE  im.`ItemID`=fm.itemID GROUP BY im.ItemID   ),'')ItemDetail ");
            sb.Append("  FROM package_labdetail pd ");
            sb.Append("  INNER JOIN f_itemMaster fm ON pd.plabId=fm.ItemId AND fm.`IsActive`=1");
            sb.Append("  INNER JOIN f_ratelist fr ON fr.itemid=pd.plabid AND fr.Rate<>0");
            //  sb.Append("  AND fr.rate>=@rate-500 AND fr.rate<=@rate+500");
            sb.Append("  AND pd.plabId IN (    SELECT plabId FROM package_labdetail ");
            sb.Append("   WHERE investigationID IN ({0}) AND IsActive=1 ");
            sb.Append("   GROUP BY plabID ");
            sb.Append("   HAVING COUNT(1)>=" + itemTags.Length + ") ");
            sb.Append("  AND fr.panel_id = @referenceCodeOPD;");



            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), itemClause), con))
            {
                for (int i = 0; i < itemNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(itemNames[i], itemTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@referenceCodeOPD", referenceCodeOPD);
                da.SelectCommand.Parameters.AddWithValue("@rate", TotalAmount);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindOutstandingEmployee(string CentreID)
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable(string.Format("SELECT CONCAT(co.employeeid,'#',MaxOutstandingAmt,'#',MaxBill)EmployeeID,em.`Name` FROM CashOutStandingMaster co INNER JOIN employee_master em ON em.employee_id=co.employeeid WHERE co.`CenterId`={0}", CentreID)));
    }

    [WebMethod(EnableSession = true)]
    public static string bindPromotionlTest(string ItemID, string PanelID, string CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL(GROUP_CONCAT(ItemID_suggestion),0) FROM f_itemmaster_suggestion where IsActive=1 and ItemID=@ItemID AND CentreID=@CentreID");
            string alltest = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@CentreID", CentreID)));
            string codeandname = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(TypeName,'#',IFNULL(TestCode,'')) from f_itemmaster where ItemID=@ItemID ",
              new MySqlParameter("@ItemID", ItemID)));

            string[] ItemIDTags = alltest.Split(',');
            string[] ItemIDParamNames = ItemIDTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string ItemIDClause = string.Join(", ", ItemIDParamNames);
            sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT @codeandName SelectedTestName,@SelectedTestCode SelectedTestCode,  im.TypeName TestName,im.TestCode,rl.rate FROM f_itemmaster im");
            sb.Append(" INNER JOIN f_ratelist rl on rl.itemid=im.itemid and rl.panel_id=@panel_id ");
            sb.Append("  where im.itemid IN ({0}) ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), ItemIDClause), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@panel_id", PanelID);
                da.SelectCommand.Parameters.AddWithValue("@SelectedTestCode", codeandname.Split('#')[1]);
                da.SelectCommand.Parameters.AddWithValue("@codeandName", codeandname.Split('#')[0]);
                for (int i = 0; i < ItemIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(ItemIDParamNames[i], ItemIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SuggestedTest(string PatientID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  DISTINCT pli.itemname TestName,pli.ItemCode,DATE_FORMAT(pli.`Date`,'%d-%b-%Y')DATE,pli.`Test_ID`,  ");
            sb.Append(" plo.`Flag` STATUS  ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli   ");
            sb.Append(" INNER JOIN `patient_labobservation_opd` plo ON pli.`Test_ID`=plo.`Test_ID`  ");
            sb.Append(" WHERE pli.`Approved`=1  AND pli.`Patient_ID`=@Patient_ID  ");
            sb.Append(" AND pli.Date >DATE_ADD(NOW(),INTERVAL -6 MONTH) AND plo.`Flag` IN ('High','Low')  ");
            sb.Append(" GROUP BY pli.`Investigation_ID`  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@Patient_ID", PatientID)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string manualEncryptDocument(string fileName, string filePath)
    {
        return JsonConvert.SerializeObject(new { status = "true", fileName = Common.Encrypt(fileName), filePath = Common.Encrypt(filePath), type = Common.Encrypt("1") });
    }

    [WebMethod(EnableSession = true)]
    public static string bindmembershipcarddata(string cardno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT mm.cardno,pm.patient_id,pm.`Title`,pm.`PName`,pm.`Mobile`,pm.`AgeDays`,pm.`AgeMonth`,pm.`AgeYear`,pm.`Gender`,pm.age ,mm.Relation,");
            sb.Append(" pm.house_no,pm.Country,pm.State,pm.City,pm.Locality,pm.CountryID,pm.StateID,pm.CityID,pm.LocalityID,IF(pm.PinCode=0,'',pm.PinCode)PinCode,pm.email, ");
            sb.Append(" DATE_FORMAT(pm.dob,'%d-%b-%Y') dob,pm.ClinicalHistory,Date_Format(dtEntry,'%d-%c-%Y')dtEntry,mmm.`MembershipCardID`");
            sb.Append(" FROM membershipcard_member mm  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=mm.`Patient_ID`  ");
            sb.Append(" INNER JOIN `membershipcard` mmm ON mmm.`CardNo`=mm.`CardNo` AND mmm.`IsActive`=1 AND mmm.`ValidTo`>CURRENT_DATE");
            sb.Append(" WHERE mm.cardno=@cardno  ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@cardno", cardno)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string CheckConcentForm(string LabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
           StringBuilder sb = new StringBuilder();
          // if (TestType == "Package")
          // {
          //     sb.Append(" SELECT ict.ConcernForm ConcernForm ");
          //     sb.Append(" FROM `package_labdetail` pld ");
          //     sb.Append(" INNER JOIN `packagelab_master` pck ON pck.`PlabID`=pld.`PlabID` ");
          //     sb.Append(" INNER JOIN investigation_concernform ict ON ict.`investigationid`=pld.`InvestigationID` ");
          //     sb.Append(" WHERE pld.`PlabID`=@InvestigationID AND pld.`IsActive`=1 AND pck.`IsActive`=1 ");
          // }
          // else
          // {
          //     sb.Append("SELECT ConcernForm FROM investigation_concernform WHERE InvestigationID=@InvestigationID");
          // }
          // using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
          //      new MySqlParameter("@InvestigationID", InvestigationID)).Tables[0])

           sb.Append(" SELECT lt.`Patient_ID`,lt.`LedgerTransactionNo` LabNo,lt.Son,lt.Children,lt.AgeSon,lt.Daughter,lt.AgeDaughter, lt.`PName`,lt.`DoctorName`,lt.`PanelName`,plo.`ItemName`,lt.`Gender`, ");
           sb.Append(" lt.`Age`,DATE_FORMAT(lt.`Date`,'%d-%b-%Y')RegDate,DATE_FORMAT(lt.`Pregnancydate`,'%d-%b-%Y')Pregnancydate,pm.House_No,pm.House_No,pm.`Mobile`,dr.`Name`, incf.`ConcentFormName` `ConcernFormid`,incf.`Type`,dr.`Mobile` DocMobile ");
            sb.Append(" FROM `f_ledgertransaction` lt ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN patient_master pm ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sb.Append(" INNER JOIN doctor_referal dr ON lt.`Doctor_ID`=dr.`Doctor_ID` ");
            sb.Append(" INNER JOIN investigation_concernform inc ON plo.`Investigation_ID`=inc.`investigationid` ");
            sb.Append(" INNER JOIN investigation_concentform incf ON inc.`ConcernForm`=incf.`ConcentFormName` ");
            sb.Append(" WHERE lt.`ledgerTransactionID`=@ledgerTransactionID AND plo.`IsActive`=1 ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@ledgerTransactionID", Common.Decrypt(LabID))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {

                    return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                }
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string searchappointmentData(string AppointmentID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT DATE_FORMAT(COALESCE(app.AppDate,app.AppTime),'%d-%b-%Y %h:%i %p')ActualHomeCollectionDateTime,app.`Address`,app.`Address1`,app.`Address2`,
                 app.`PatientName`,app.`AgeYear`,app.`AgeMonth`,app.`AgeDays`,app.`AppointmentID`,app.`DeptID`,app.`DeptName`,app.`CentreID`,app.`EmailID`,app.`Gender`,
                app.`Investigation`,app.`ItemID` value,'' label,app.`Mobile`,app.`PanelID`,app.`PanelType`,app.`PatientType`,app.`PinCode`,app.`Referdoctor`,dr.`Name` docname,app.`Title`,CONCAT(app.Rate,'#',0,'#',0,'#',app.PanelID)Rate,
                app.`GrossAmount`,app.`NetAmount`,app.`Adjustment`,IF(app.DeptID='15','Package','Test') `type`,pn.StateID,
                '' Patient_ID,CONCAT(pn.`Panel_Code`,' ',pn.company_name)PanelName ,cm.Centre,0 DiscPer, CONCAT(app.Rate,'#','') MRP
               FROM appointment_radiology_details app
               INNER JOIN f_panel_master pn ON app.PanelID=pn.Panel_ID
               INNER JOIN `doctor_referal` dr ON dr.`Doctor_ID`=app.`Referdoctor`                          
               INNER JOIN  centre_master cm on cm.CentreID=app.CentreID where
               app.AppointmentID=@AppointmentID AND IFNULL(Ledgertransactionno,'')='' AND app.IsBooked=0 AND app.`IsConfirmed`=1 AND app.IsCancel=0  AND app.CentreID=@CentreID   ");          

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@AppointmentID", AppointmentID),
                new MySqlParameter("@CentreID", Util.GetString(UserInfo.Centre))).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string searchHomeCollectionData(string AppointmentID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(@" SELECT app.Name PatientName,App.Title,App.Mobile,App.State,DATE_FORMAT(app.App_Date,'%d-%b-%y')AppDate,app.Email,'' PinCode,
                    app.Address,app.Gender ,SUBSTRING(Age,1,2)AgeYear,0 AgeMonth,0 AgeDays,DATE_FORMAT(app.Dob,'%y-%m-%d')Dob,app.BillAmount,app.GrossAmount,app.NetAmount,app.Dicountontotal,
                    app.PaidAmount Adjustment,app.CentreID,app.PanelID,app.DoctorID,appinv.investigationID Investigation,
                   appinv.investigationID value,'Test' type,CONCAT(rl.Rate,'#',0,'#',0,'#','78')Rate,0 DiscPer,CONCAT(rl.Rate,'#','0') MRP
                    FROM app_appointment  app
                    INNER JOIN app_appointment_inv appinv ON app.ID=appinv.AppID
                    LEFT JOIN f_ratelist rl ON rl.itemid=appinv.investigationID AND rl.panel_ID='78'
                    WHERE app.IsCancel=0 AND app.IsBooking=0 AND app.isConfirmed=1 AND  app.ID=@AppointmentID    ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@AppointmentID", AppointmentID)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string CheckValidation(string ItemId){
        string Mobile = StockReports.ExecuteScalar("Select Count(1) from investigation_requiredfield where Investigationid in ("+ItemId.TrimEnd(',')+") AND FieldId=17 ");


        string Address = StockReports.ExecuteScalar("Select Count(1) from investigation_requiredfield where Investigationid in (" + ItemId.TrimEnd(',') + ") AND FieldId=18 ");

        return JsonConvert.SerializeObject(new { Mobile = Mobile, Address = Address });
    }

    public class getCouponItemDetail
    {
        public int ItemID { get; set; }
        public int CoupanId { get; set; }
        public double discPer { get; set; }
        public double discAmount { get; set; }
        public decimal Rate { get; set; }
    }

    [WebMethod]
    public static string ValidateCoupanGetOTP(string CouponNo, string mobileno, string PatientName, string Panelid, string uhid, string itemid, int tablecount, int bookingamt, string oldcouponID, string ispackage)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT cpm.`CoupanType`, cpm.CoupanId,cpm.coupanName,cpm.coupanCategory,cc.Coupancode,IFNULL(cc.LedgerTransactionNo,'')LedgerTransactionNo,DATE_FORMAT(cpm.ValidFrom,'%d-%b-%Y')ValidFrom,DATE_FORMAT(cpm.validTo,'%d-%b-%Y')validTo,");
            sb.Append("IFNULL(cpm.MinBookingAmount,0)MinBookingAmount,IFNULL(cpm.DiscountPercentage,0)DiscountPercentage,cpm.IsMultipleCouponApply,");
            sb.Append("IFNULL(cpm.DiscountAmount,0)DiscountAmount,cpm.UHID,cpm.Mobile,cpm.Issuetype ");
            sb.Append(",IF(cpm.Type=1,'Total Bill','Test Wise')Applicable ,IFNULL(cpm.isused,0)isused,cpm.Type CouponType,cpm.WeekEnd,cpm.HappyHours,cpm.DaysApplicable,cpm.IsOneTimePatientCoupon,cc.IsPreBooking,cc.PreBookingID,cpm.IsHappyBirthdayCoupon,cc.CouponValidFrom,cc.CouponValidTo ");
            sb.Append(" FROM coupan_master cpm INNER JOIN coupan_code cc ON cpm.`CoupanId`=cc.CoupanId AND cpm.IsActive=1 ");
            sb.Append(" INNER JOIN coupan_applicable_panel cac  ON cac.CoupanId=cpm.`CoupanId`");
            sb.Append(" WHERE cc.coupanCode=@coupanCode AND cac.panel_id=@panelid AND cpm.approved=2 And cpm.ApplicableFor like '%1%' ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                       new MySqlParameter("@coupanCode", CouponNo),
                                       new MySqlParameter("@panelid", Panelid)).Tables[0];

            if (dt.Rows.Count == 0)
            {
                if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) from coupan_code WHERE coupanCode=@coupanCode",
                                            new MySqlParameter("@coupanCode", CouponNo))) == 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Coupon Not Found. Please Enter Valid Coupon No." });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Coupon is not available for this Centre" });
                }
            }
            else
            {
                if (dt.Rows[0]["LedgerTransactionNo"].ToString() != string.Empty)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Coupon is already Used for Visit No. ", dt.Rows[0]["LedgerTransactionNo"].ToString()) });
                }
                if (dt.Rows[0]["PreBookingID"].ToString() != string.Empty)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Coupon is already Used for PreBookingID ", dt.Rows[0]["PreBookingID"].ToString()) });
                }
                if (Util.GetInt(dt.Rows[0]["IsOneTimePatientCoupon"].ToString()) == 1)
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT COUNT(1) FROM `f_ledgertransaction` lt  ");
                    sb.Append(" INNER JOIN `patient_master` pm ON lt.`Patient_ID`=pm.`Patient_ID` WHERE pm.`Mobile`=@mobileNo");
                    int IsFirstPatient = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                                                 new MySqlParameter("@mobileNo", mobileno)));
                    if (IsFirstPatient > 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = string.Format("Coupon {0} is Valid for OneTime Patient ", dt.Rows[0]["Coupancode"].ToString()) });
                    }
                }
                if (Util.GetInt(dt.Rows[0]["WeekEnd"].ToString()) == 1 || Util.GetInt(dt.Rows[0]["HappyHours"].ToString()) == 1)
                {
                    List<string> DaysApplicable = new List<string>();
                    if (dt.AsEnumerable().Where(r => r.Field<SByte>("WeekEnd") > 0).Count() > 0)
                    {
                        DaysApplicable = dt.AsEnumerable().Where(r => r.Field<SByte>("WeekEnd") == 1).Select(s => s.Field<string>("DaysApplicable")).FirstOrDefault().Split(',').ToList();
                    }
                    else if (dt.AsEnumerable().Where(r => r.Field<SByte>("HappyHours") > 0).Count() > 0)
                    {
                        DaysApplicable = dt.AsEnumerable().Where(r => r.Field<SByte>("HappyHours") == 1).Select(s => s.Field<string>("DaysApplicable")).FirstOrDefault().Split(',').ToList();

                    }
                    if (DaysApplicable.Count == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Invalid Coupon ", dt.Rows[0]["Coupancode"].ToString()) });
                    }
                    string VisitDay = CultureInfo.CurrentCulture.DateTimeFormat.GetAbbreviatedDayName(Util.GetDateTime(DateTime.Now).DayOfWeek);
                    if (!DaysApplicable.Any(cus => cus == VisitDay))
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = string.Format("Coupon ({0}) not applied in {1} ", dt.Rows[0]["Coupancode"].ToString(), VisitDay) });

                    }
                    if (Util.GetInt(dt.Rows[0]["HappyHours"].ToString()) == 1)
                    {
                        string VisitTime = DateTime.Now.ToString("HH:mm:ss");
                        //12-2PM
                        TimeSpan AppStartTime = new TimeSpan(Util.GetDateTime(VisitTime).Hour, Util.GetDateTime(VisitTime).Minute, Util.GetDateTime(VisitTime).Second);

                        TimeSpan StartTime = new TimeSpan(12, 0, 0);
                        TimeSpan EndTime = new TimeSpan(14, 0, 0);

                        if (!(StartTime <= AppStartTime && EndTime >= AppStartTime))
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = string.Format("Coupon ({0}) not applied in VisitTime {1} ", dt.Rows[0]["Coupancode"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss")) });

                        }
                    }
                }
                if (dt.Rows[0]["Issuetype"].ToString() == "Mobile")
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_Billtype WHERE Type='Mobile' AND Coupanid=@Coupanid AND Value=@mobileno",
                                                new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                                new MySqlParameter("@mobileno", mobileno))) == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Not Valid for this Mobile No." });
                    }
                }
                if (dt.Rows[0]["Issuetype"].ToString() == "UHID")
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE Issuetype='UHID' AND Coupanid=@Coupanid AND IssueValue=@uhid",
                                                new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                                new MySqlParameter("@uhid", uhid))) == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Not Valid for this UHID No." });
                    }
                }
                if (dt.Rows[0]["IsHappyBirthdayCoupon"].ToString() == "1")
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE Issuetype='UHID' AND Coupanid=@Coupanid AND IssueValue=@uhid AND CouponValidFrom<=CONCAT(CURRENT_DATE(),' ','00:00:00') AND CouponValidTo>=CONCAT(CURRENT_DATE(),' ','23:59:59')",
                                                new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                                new MySqlParameter("@uhid", uhid))) == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Expired" });
                    }
                }

                if (dt.Rows[0]["Issuetype"].ToString() == "UHIDWithCoupan")
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE issuetype='UHID' AND CoupanId=@Coupanid AND issuevalue=@uhid and coupancode=@coupancode",
                                                new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                                new MySqlParameter("@uhid", uhid),
                                                new MySqlParameter("@coupancode", dt.Rows[0]["Coupancode"].ToString()))) == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Coupon Code is Not Valid for this UHID No." });
                    }
                }
                if (dt.Rows[0]["Issuetype"].ToString() == "MobileWithCoupan")
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE issuetype='Mobile' AND CoupanId=@Coupanid AND issuevalue=@mobileno and coupancode=@coupancode",
                                                new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                                new MySqlParameter("@mobileno", mobileno),
                                                new MySqlParameter("@coupancode", dt.Rows[0]["Coupancode"].ToString()))) == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Coupon Code is Not Valid for this Mobile No." });
                    }
                }
                if (dt.Rows[0]["Issuetype"].ToString() == "OneCoupanOneMobile")
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE issuetype='OneCoupanOneMobile' AND Coupanid=@Coupanid AND MobileNo=@mobileno AND CoupanCode=@coupancode ",
                                                new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                                new MySqlParameter("@mobileno", mobileno),
                                                new MySqlParameter("@coupancode", dt.Rows[0]["Coupancode"].ToString()))) == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Not Valid for this Mobile No." });
                    }
                }

                if (System.DateTime.Now > Util.GetDateTime(dt.Rows[0]["validTo"].ToString() + " 23:59:59"))
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Expired" });
                }

                if (tablecount > 1 && dt.Rows[0]["IsMultipleCouponApply"].ToString() == "0")
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "This Coupon not Applicable with Multiple" });

                }
                if (tablecount > 1 && dt.Rows[0]["IsMultipleCouponApply"].ToString() == "1")
                {
                    foreach (string s in oldcouponID.Split('#'))
                    {
                        if (s != "" && s.ToUpper() != dt.Rows[0]["CoupanId"].ToString().ToUpper())
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = "Diffrent Coupon Name are Not Allowed" });
                        }
                    }
                }
                if (Util.GetInt(dt.Rows[0]["MinBookingAmount"].ToString()) > 0 && Util.GetInt(dt.Rows[0]["MinBookingAmount"].ToString()) > bookingamt)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Coupon is Valid For Minimum  ", Util.GetInt(dt.Rows[0]["MinBookingAmount"].ToString())) });
                }
                if (Util.GetString(dt.Rows[0]["Applicable"]) == "Test Wise")
                {

                    int testcount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_testwise WHERE CoupanId=@CoupanId AND ItemId IN (" + itemid.TrimEnd(',') + ")",
                                                            new MySqlParameter("@CoupanId", dt.Rows[0]["CoupanId"].ToString())));
                    if (testcount == 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Not Valid for Selected Items" });
                    }
                }
                else if (Util.GetString(dt.Rows[0]["Applicable"]) == "Total Bill" && ispackage == "1")
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Package Not Allowed with Total Bill Coupon" });
                }
            }
            string chars = "0123456789";
            char[] stringChars = new char[6];
            Random random = new Random();
            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            string finalString = new String(stringChars);
            string uniqueid = Guid.NewGuid().ToString();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO coupan_otp(UniqueID,CouponCode,MobileNo,OTP,EntryDate,ExpiryDate) values (@uniqueid,@CouponNo,@mobileno,@finalString,NOW(),DATE_ADD(NOW(),INTERVAL 15 MINUTE)) ",
                            new MySqlParameter("@uniqueid", uniqueid),
                            new MySqlParameter("@CouponNo", CouponNo),
                            new MySqlParameter("@mobileno", mobileno),
                            new MySqlParameter("@finalString", finalString));
                // SMS
                StringBuilder smsText = new StringBuilder();
                StringBuilder sbSMS = new StringBuilder();

                smsText.Append("Dear {#var#}, OTP to redeem your Coupon is {#var1#} .Your OTP is valid for only 15 minutes. Lupin Diagnostics");
                smsText.Replace("{#var#}", Util.GetString(PatientName).ToUpper());
                smsText.Replace("{#var1#}", Util.GetString(finalString) + " ");

                sbSMS.Append(" insert into sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID,TemplateID) ");
                sbSMS.Append(" values(@mobileno,@smsText,'0',@UserID,NOW(),'Coupon','0','0',@TemplateID) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@mobileno", Util.GetString(mobileno)),
                            new MySqlParameter("@smsText", smsText),
                            new MySqlParameter("@UserID", UserInfo.ID),
                            new MySqlParameter("@TemplateID", Util.getApp("SMSCouponTemplateID")));

                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = uniqueid });
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { status = false, response = "Error On sending SMS" });
            }
            finally
            {
                tnx.Dispose();
            }

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.Message.ToString() });
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string resendOTPCoupan(string CouponNo, string mobileno, string PatientName, string uniqueid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string otp = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT otp FROM coupan_otp WHERE uniqueid=@uniqueid",
                                                    new MySqlParameter("@uniqueid", uniqueid)));
            StringBuilder smsText = new StringBuilder();
            StringBuilder sbSMS = new StringBuilder();

            smsText.Append("Dear {#var#}, OTP to redeem your Coupon is {#var1#} .Your OTP is valid for only 15 minutes. Lupin Diagnostics");
            smsText.Replace("{#var#}", Util.GetString(PatientName).ToUpper());
            smsText.Replace("{#var1#}", Util.GetString(otp) + " ");

            sbSMS.Append("INSERT INTO sms(MOBILE_NO,SMS_TEXT,IsSend,UserID,EntDate,SMS_Type,LedgerTransactionID,LabObservation_ID,TemplateID) ");
            sbSMS.Append(" values(@mobileno,@smsText,'0',@UserID,NOW(),'Coupon','0','0',@TemplateID) ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                        new MySqlParameter("@mobileno", Util.GetString(mobileno)),
                        new MySqlParameter("@smsText", smsText),
                        new MySqlParameter("@UserID", UserInfo.ID),
                        new MySqlParameter("@TemplateID", Util.getApp("SMSCouponTemplateID")));
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.Message.ToString() });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod]
    public static string ValidateCoupan(string CouponNo, string Panelid, string OTP, string uniqueid, string MobileNo, string UHID, int bookingamt)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (OTP == string.Empty || uniqueid == string.Empty)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "OTP Not Found" });
            }
            int a = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM coupan_otp WHERE otp=@otp AND uniqueid=@uniqueid AND NOW()<expirydate AND isused=0 ",
                                            new MySqlParameter("@otp", OTP),
                                            new MySqlParameter("@uniqueid", uniqueid)));
            if (a == 1)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT cpm.`CoupanType`, cpm.CoupanId,cpm.coupanName,cpm.coupanCategory,cc.Coupancode,IFNULL(cc.LedgerTransactionNo,'')LedgerTransactionNo,DATE_FORMAT(cpm.ValidFrom,'%d-%b-%Y')ValidFrom,DATE_FORMAT(cpm.validTo,'%d-%b-%Y')validTo,");
                sb.Append("IFNULL(cpm.MinBookingAmount,0)MinBookingAmount,IFNULL(cpm.DiscountPercentage,0)DiscountPercentage,");
                sb.Append("IFNULL(cpm.DiscountAmount,0)DiscountAmount,cpm.UHID,cpm.Mobile,cpm.Issuetype,cpm.IsMultipleCouponApply ");
                sb.Append(" ,IF(cpm.Type=1,'Total Bill','Test Wise')Applicable ,IFNULL(cpm.isused,0)isused,cpm.Type CouponType,cpm.OneCouponOneMobileMultipleBilling,cc.IsPreBooking,cc.PreBookingID,cpm.IsHappyBirthdayCoupon,cpm.ClientShareType ");
                sb.Append(" FROM coupan_master cpm INNER JOIN coupan_code cc ON cpm.`CoupanId`=cc.CoupanId    ");
                sb.Append(" INNER JOIN coupan_applicable_panel cac  ON cac.CoupanId=cpm.`CoupanId` ");
                sb.Append(" WHERE cc.coupanCode=@coupanCode AND cac.panel_id=@Panelid AND cpm.approved=2 And cpm.ApplicableFor like '%1%'");
                using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                                                  new MySqlParameter("@coupanCode", CouponNo),
                                                  new MySqlParameter("@Panelid", Panelid)).Tables[0])
                {
                    if (dt.Rows[0]["LedgerTransactionNo"].ToString() != string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Coupon is already Used for Visit No. ", dt.Rows[0]["LedgerTransactionNo"].ToString()) });
                    }
                    if (dt.Rows[0]["PreBookingID"].ToString() != string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Coupon is already Used for PreBookingID ", dt.Rows[0]["PreBookingID"].ToString()) });
                    }
                    if (dt.Rows[0]["Issuetype"].ToString() == "Mobile")
                    {

                        if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_Billtype WHERE Type='Mobile' AND Coupanid=@Coupanid AND Value=@mobileno",
                                               new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                               new MySqlParameter("@mobileno", MobileNo))) == 0)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Not Valid for this Mobile No." });
                        }
                    }
                    else if (dt.Rows[0]["Issuetype"].ToString() == "UHID")
                    {

                        if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE IssueType='UHID' AND Coupanid=@Coupanid AND IssueValue=@IssueValue",
                                               new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                               new MySqlParameter("@IssueValue", UHID))) == 0)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Not Valid for this Mobile No." });
                        }
                    }

                    else if (dt.Rows[0]["Issuetype"].ToString() == "OneCoupanOneMobile")
                    {
                        if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE issuetype='OneCoupanOneMobile' AND Coupanid=@Coupanid AND MobileNo=@mobileno AND CoupanCode=@coupancode ",
                                                    new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                                    new MySqlParameter("@mobileno", MobileNo),
                                                    new MySqlParameter("@coupancode", CouponNo))) == 0)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Not Valid for this Mobile No." });
                        }
                    }
                    if (dt.Rows[0]["IsHappyBirthdayCoupon"].ToString() == "1")
                    {
                        if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE Issuetype='UHID' AND Coupanid=@Coupanid AND IssueValue=@uhid AND CouponValidFrom<=CONCAT(CURRENT_DATE(),' ','00:00:00') AND CouponValidTo>=CONCAT(CURRENT_DATE(),' ','23:59:59')",
                                                    new MySqlParameter("@Coupanid", dt.Rows[0]["CoupanId"].ToString()),
                                                    new MySqlParameter("@uhid", UHID))) == 0)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Expired" });
                        }
                    }
                    if (Util.GetInt(dt.Rows[0]["MinBookingAmount"].ToString()) > 0 && Util.GetInt(dt.Rows[0]["MinBookingAmount"].ToString()) > bookingamt)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Coupon is Valid For Minimum  ", Util.GetInt(dt.Rows[0]["MinBookingAmount"].ToString())) });

                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE coupan_otp SET isused=1 WHERE otp=@otp AND uniqueid=@uniqueid",
                                new MySqlParameter("@otp", OTP),
                                new MySqlParameter("@uniqueid", uniqueid));
                    tnx.Commit();
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                }
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Invalid OTP" });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return JsonConvert.SerializeObject(new { status = false, response = "Invalid OTP" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string getcouponitemdisc(List<string[]> dataIm)
    {
        double finalvalue = 0;
        string itemwisedata = "";
        double itemwisefinal = 0;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            foreach (string[] ss in dataIm)
            {
                int itemid = Util.GetInt(ss[0]);
                double rate = Util.GetFloat(ss[1]);
                int couponid = Util.GetInt(ss[2]);

                string s = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(IFNULL(discper,'0'),'#',IFNULL(discamount,'0')) FROM coupan_testwise WHERE coupanid=@couponid AND itemid=@itemid",
                                                      new MySqlParameter("@couponid", couponid),
                                                      new MySqlParameter("@itemid", itemid)));
                if (s != string.Empty)
                {
                    //discper
                    if (Util.GetInt(s.Split('#')[0]) > 0)
                    {
                        finalvalue += rate * Util.GetFloat(s.Split('#')[0]) * 0.01;
                        itemwisefinal = rate * Util.GetFloat(s.Split('#')[0]) * 0.01;
                    }
                    //discamt
                    else if (Util.GetInt(s.Split('#')[1]) > 0)
                    {
                        if (Util.GetDouble(s.Split('#')[1]) > rate)
                        {
                            finalvalue += rate;
                            itemwisefinal = rate;
                        }
                        else
                        {
                            finalvalue += Util.GetDouble(s.Split('#')[1]);
                            itemwisefinal = Util.GetDouble(s.Split('#')[1]);
                        }

                    }
                }
                itemwisedata += Convert.ToString(itemid) + "^" + Convert.ToString(itemwisefinal) + "#";
            }
            return JsonConvert.SerializeObject(new { status = true, response = Convert.ToString(finalvalue) + "#" + itemwisedata });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.Message.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string getCouponAmt(string couponAmt)
    {
        return Common.Encrypt(couponAmt);
    }
}