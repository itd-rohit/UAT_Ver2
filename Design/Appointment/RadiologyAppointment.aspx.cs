using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Globalization;
using System.Collections.Generic;
using System.Threading.Tasks;
using Newtonsoft.Json;


public partial class Design_Appointment_RadiologyAppointment : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    public int cR;
    public int lR;
    public static string starttime = "06:30:00";
    public static string endtime = "19:00:00";
    public static string avg = "30";    

    public DataTable dt = new DataTable();
    public DataTable dtTest = new DataTable();
    public static string dt_from = "";
    public static string dt_CentrID = "";
    public string status = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtredate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dt_from = dtFrom.Text;
            bindTitle();
            bindslot();
            bindAccessCentre();
            dt_CentrID = ddlCentreAccess.SelectedItem.Value.ToString();
            getdata(dtFrom.Text, ddlCentreAccess.SelectedItem.Value.ToString(), status);
            BindFlashmsg(Util.GetString(UserInfo.Centre));
            BindPatientType();
        }
    }
    public void BindPatientType()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT panelGroupID,PanelGroup FROM `f_panelgroup` WHERE Active=1 ORDER BY panelGroupID ").Tables[0])
            {
                ddlPatientType.DataSource = dt;
                ddlPatientType.DataValueField = "panelGroupID";
                ddlPatientType.DataTextField = "PanelGroup";
                ddlPatientType.DataBind();
            }
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
    public void BindFlashmsg(string centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string abc =Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Appointmentflashmsg FROM centre_master WHERE CentreID=@CentreID ",
                 new MySqlParameter("@CentreID", centreid)));
            lblflashmsg.Text = abc;
            if (lblflashmsg.Text == "")
            {
                divdisplay.Visible = false;
            }
            else
            {
                divdisplay.Visible = true;
            }
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
    private void bindAccessCentre()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {            
            StringBuilder sb = new StringBuilder();
            sb.Append(@"SELECT fl.centreID CentreID,cm.Centre Centre FROM f_login fl INNER JOIN centre_master cm ON cm.CentreID=fl.centreID  
                 WHERE cm.isactive='1' and employeeID=@employeeID AND fl.RoleID=@RoleID ORDER BY cm.centre");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@employeeID", UserInfo.ID),
                new MySqlParameter("@RoleID", UserInfo.RoleID)).Tables[0])
            {
                ddlCentreAccess.DataSource = dt;
                ddlCentreAccess.DataTextField = "Centre";
                ddlCentreAccess.DataValueField = "CentreID";
                ddlCentreAccess.DataBind();
                foreach (ListItem li in ddlCentreAccess.Items)
                {
                    if (li.Value.ToString() == Util.GetString(UserInfo.Centre))
                    {
                        li.Selected = true;
                        break;
                    }
                }
                ddlCentreAccess.Items.Insert(0, new ListItem("--Select--", ""));
                ddlCentreAccess1.DataSource = dt;
                ddlCentreAccess1.DataTextField = "Centre";
                ddlCentreAccess1.DataValueField = "CentreID";
                ddlCentreAccess1.DataBind(); 
            }
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
    private void bindslot()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string abc = StockReports.ExecuteScalar("SELECT VALUE FROM appointment_radiology_setup WHERE FIELD='Timecount'");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID, VALUE FROM appointment_timeslot WHERE ID <= @ID",
                new MySqlParameter("@ID", abc)).Tables[0])
            {
                ddltimeslot.DataSource = dt;
                ddltimeslot.DataTextField = "VALUE";
                ddltimeslot.DataValueField = "ID";
                ddltimeslot.DataBind();
                ddltimeslot.Items.Insert(0, new ListItem("", ""));
            }
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
    private void bindTitle()
    {
        cmbTitle.DataSource = AllGlobalFunction.NameTitle;
        cmbTitle.DataBind();
    }  

    [WebMethod]    
    public static string getinvlist(string PanelID, string deptid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT im.itemid,typename,CONCAT(im.itemid,'#',IFNULL(rl.rate,'0')) myid ");
            sb.Append(" FROM f_itemmaster im ");
            sb.Append("LEFT  JOIN f_ratelist rl ON rl.itemid=im.itemid AND rl.panel_id=(SELECT ReferenceCodeOPD FROM f_panel_master WHERE panel_id=@panel_id) ");
            sb.Append(" WHERE isactive=1 AND Booking=1  AND SubCategoryID=@SubCategoryID   ORDER BY typename");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@panel_id", PanelID),
                new MySqlParameter("@SubCategoryID", deptid)).Tables[0])
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
    public void getdata(string date, string CentreID, string status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dtre = new DataTable();
            dtre.Columns.Add("Timeslot");

            dt.Columns.Add("PhlebotomistID");
            dt.Columns.Add("Department");
            dt.Columns.Add("HolidayDate");

            DateTime starttimeday = DateTime.Parse(StockReports.ExecuteScalar(" SELECT VALUE FROM appointment_radiology_setup WHERE FIELD='Starttime'"));
            DateTime endtimeday = DateTime.Parse(StockReports.ExecuteScalar(" SELECT VALUE FROM appointment_radiology_setup WHERE FIELD='Endtime'"));

            int avgtime = Convert.ToInt32(StockReports.ExecuteScalar(" SELECT VALUE FROM appointment_radiology_setup WHERE FIELD='Slotgap'"));
            TimeSpan span = endtimeday.Subtract(starttimeday);

            int total_min = Util.GetInt(span.TotalMinutes);

            int noslots = total_min / avgtime;
            int add = 0;



            for (int i = 0; i < noslots; i++)
            {
                string madetime = Util.GetDateTime((starttimeday.AddMinutes(add)).ToShortTimeString()).ToString("HH:mm");
                add += avgtime;
                dt.Columns.Add(madetime);
                DataRow dr = dtre.NewRow();
                dr["Timeslot"] = madetime.ToString();
                dtre.Rows.Add(dr);

            }           
            try
            {
                ddlretimeslot.DataSource = dtre;
                ddlretimeslot.DataValueField = "Timeslot";
                ddlretimeslot.DataTextField = "Timeslot";
                ddlretimeslot.DataBind();
            }
            catch
            {
            }

            DataTable ph = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT scm.SubCategoryID as SubCategoryID, scm.NAME as NAME FROM f_subcategorymaster scm INNER JOIN f_subcategorymaster_centre scmc ON scmc.SubCategoryID=scm.SubCategoryID WHERE scmc.centreid=@centreid AND scm.`Active`=1  ORDER BY scmc.Priority,scm.NAME ",
                  new MySqlParameter("@centreid", CentreID)).Tables[0];
            
                ddlphe.DataSource = ph;
                ddlphe.DataValueField = "SubCategoryID";
                ddlphe.DataTextField = "Name";
                ddlphe.DataBind();
            

            StringBuilder sb = new StringBuilder();
            sb.Append("select group_concat(DISTINCT concat(ard.AppointmentID,'#',ard.PatientName,'#',ard.Mobile,'#', ");
            sb.Append(" concat(ard.Address,' ',ifnull(ard.Address1,''),' ',ifnull(ard.Address2,''),' ',ifnull(ard.pincode,'')),'#',ard.Iscancel,'#',ard.`IsBooked`,'#',ard.`PatientType`,'#',ard.`ReferenceID`,'#',IFNULL(`ardstatus`.`Remarks`,''),'#',ard.IsConfirmed) SEPARATOR '~') `Data`, ");
            sb.Append("  ard.DeptID,cast(ards.apptime as char)apptime ");
            sb.Append(" from appointment_radiology_details ard");
            sb.Append(" INNER JOIN appointment_radiology_details_slots ards ON ards.`AppointmentID`=ard.`AppointmentID` ");
            sb.Append(" left join (SELECT * FROM appointment_radiology_details_update_status a1 WHERE a1.`Remarks`<>''  GROUP BY AppointmentID)  ardstatus ON ardstatus.AppointmentID=ard.`AppointmentID` ");
            sb.Append(" where  ard.appdate=@appdate and ard.CentreID=@CentreID  ");

            if (status == "1")
            {
                sb.Append(" AND PatientType='Normal' AND IsConfirmed=0 ");
            }

            if (status == "2")
            {
                sb.Append(" AND PatientType='VIP' AND IsConfirmed=0 ");
            }

            if (status == "3")
            {
                sb.Append(" AND PatientType='Normal' AND IsBooked=1 ");
            }

            if (status == "4")
            {
                sb.Append(" AND PatientType='VIP' AND IsBooked=1 ");
            }

            if (status == "5")
            {
                sb.Append(" AND Iscancel=1 ");
            }
            else
            {
                sb.Append(" AND Iscancel=0 ");
            }

            if (status == "6")
            {
                sb.Append(" AND PatientType='Normal' AND IsConfirmed=1 ");
            }

            if ( status== "7")
            {
                sb.Append(" AND PatientType='VIP' AND IsConfirmed=1 ");
            }

           
            sb.Append(" GROUP BY ard.DeptID,ards.apptime ");

            DataTable dttime = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@appdate", Util.GetDateTime(date).ToString("yyyy-MM-dd")),
                    new MySqlParameter("@CentreID", CentreID)).Tables[0];

            foreach (DataRow dw in ph.Rows)
            {
                DataRow dwc = dt.NewRow();
                dwc["PhlebotomistID"] = dw["SubCategoryID"].ToString();
                dwc["Department"] = dw["Name"].ToString();
                
                foreach (DataColumn dc in dt.Columns)
                {
                    if (dc.ColumnName != "PhlebotomistID" && dc.ColumnName != "Department" && dc.ColumnName != "HolidayDate")
                    {
                        string ss = "DeptID='" + dw["SubCategoryID"].ToString() + "' AND apptime='" + Util.GetDateTime(dc.ColumnName).ToString("HH:mm:ss") + "'";
                        DataRow[] drTemp = dttime.Select(ss); 
                        if (drTemp.Length > 0)
                        {
                            dwc[dc.ColumnName] = drTemp[0]["Data"].ToString();
                        }
                    }
                }

                dt.Rows.Add(dwc);
            }

            //
            DataTable dtTimeN = new DataTable();
            DataColumn dc1 = new DataColumn("Timeslot", typeof(string));
            dtTimeN.Columns.Add(dc1);
            foreach (DataRow dw in ph.Rows)
            {
                DataColumn dc2 = new DataColumn(dw["Name"].ToString() + "#" + dw["SubCategoryID"].ToString(), typeof(string));
                dtTimeN.Columns.Add(dc2);


            }
            sb = new StringBuilder();
            sb.Append(" Select group_concat(DISTINCT concat(ard.AppointmentID,'#',ard.PatientName,'#',ard.Mobile,'#', ");
            sb.Append(" concat(ard.Address,' ',ifnull(ard.Address1,''),' ',ifnull(ard.Address2,''),' ',ifnull(ard.pincode,'')),'#',ard.Iscancel,'#',ard.`IsBooked`,'#',ard.`PatientType`,'#',ard.`ReferenceID`,'#',IFNULL(`ardstatus`.`Remarks`,''),'#',ard.IsConfirmed) SEPARATOR '~') Data,ard.DeptID,ards.apptime  ");
            sb.Append(" from appointment_radiology_details ard");
            sb.Append(" INNER JOIN appointment_radiology_details_slots ards ON ards.`AppointmentID`=ard.`AppointmentID` ");
            sb.Append(" left join (SELECT * FROM appointment_radiology_details_update_status a1 WHERE a1.`Remarks`<>''  GROUP BY AppointmentID)  ardstatus ON ardstatus.AppointmentID=ard.`AppointmentID` ");
            sb.Append("  ");

            sb.Append(" where     ards.appdate=@appdate and ard.CentreID=@CentreID GROUP BY ard.DeptID,ards.apptime ");                        
            DataTable dtFinal = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@appdate", Util.GetDateTime(date).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@CentreID", CentreID)).Tables[0];

            DataTable dtKillwish = dtTimeN.Clone();
            for (int i = 0; i < dtre.Rows.Count; i++)
            {
                DataRow drTem = dtKillwish.NewRow();
                drTem["Timeslot"] = dtre.Rows[i]["Timeslot"];
                dtKillwish.Rows.Add(drTem);
                DataRow drTem1 = dtKillwish.NewRow();
                foreach (DataColumn dc3 in dtKillwish.Columns)
                {
                    if (dc3.ColumnName != "Timeslot")
                    {
                        string ss = "DeptID='" + dc3.ColumnName.Split('#')[1] + "' AND apptime='" + Util.GetDateTime(drTem["Timeslot"].ToString()).ToString("HH:mm:ss") + "'";
                        DataRow[] drTemp = dttime.Select(ss);  
                        if (drTemp.Length > 0)
                        {
                            drTem[dc3.ColumnName] = drTemp[0]["Data"].ToString();
                        }                        
                    }

                }               
            }
            dtTest = dtKillwish.Copy();           

            //s
            lR = dtTest.Rows.Count;
                      
        }
        catch (Exception ex)
        {
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }    

    [WebMethod]
    public static string savealldate(List<Receipt> Rcdata, List<SaveAppointment> Appdata)
    {
       
        if (Appdata[0].Bookingnum != "")
        {
            int Booknum = Convert.ToInt32(StockReports.ExecuteScalar(" SELECT VALUE FROM appointment_radiology_setup WHERE FIELD='Noofbooking'"));
            int abc = Convert.ToInt32(Appdata[0].Bookingnum);
            if (Booknum <= abc)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "You can not Booked Test b'coz this slot is already booked...!" });
            }
        }
        if (Appdata[0].Booked == "1")
        {
            return JsonConvert.SerializeObject(new { status = false, response = "You can not edit this. It is already booked...!" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
         MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {                        
      
            StringBuilder sb = new StringBuilder();
            string appdate = Util.GetDateTime(Appdata[0].date).ToString("yyyy-MM-dd");
            if (Appdata[0].Appid == "")
            {

                string appdatetime = Util.GetDateTime(Appdata[0].date + " " + Appdata[0].Time).ToString("yyyy-MM-dd hh:mm:ss");
                string curtime = Util.GetDateTime(Appdata[0].date).ToString("yyyy-MM-dd");

                DateTime dt1 = Convert.ToDateTime(appdate).Date;
                DateTime dt2 = DateTime.Now.Date;
                if (dt1 < dt2)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "You can not Booked Test in  Past date...!" });
                }
               
                int AppointmentID = Convert.ToInt32(StockReports.ExecuteScalar("SELECT get_appointment_id();"));
                foreach (SaveAppointment app in Appdata)
                {
                    sb = new StringBuilder();
                    sb.Append(@" INSERT INTO appointment_radiology_details  
                                (AppointmentID,DeptID,DeptName,AppDate,AppTime,PatientName,Mobile,Address,EntryDateTime,EntryById,EntryByName,  
                               Address1,Address2,PinCode,EmailID,Investigation,Rate,AgeYear, AgeMonth, AgeDays, Gender,PanelID,Referdoctor,Title,
                               CentreID,ReferenceID,PatientType,TimeSlotCount,Remarks,PanelType,GrossAmount,NetAmount,Adjustment,ItemID,IsConfirmed,ConfirmDate,ConfirmById, ConfirmByName )
                            VALUES (@AppointmentID,@DeptID, @DeptName,@AppDate,@AppTime,@PatientName,@Mobile,@Address,NOW(), @EntryById,@EntryByName, 
                           @Address1,@Address2,@PinCode,@EmailID,@Investigation,@Rate,@AgeYear,@AgeMonth ,@AgeDays,@Gender,@PanelID,@Referdoctor,@Title,
                          @CentreID,@ReferenceID,@PatientType,@TimeSlotCount,@Remarks,@PanelType,@GrossAmount,@NetAmount,@Adjustment,@ItemID,1,now(),@ConfirmById,@ConfirmByName) ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@AppointmentID", AppointmentID),
                        new MySqlParameter("@DeptID", app.SubcategoryID),
                        new MySqlParameter("@DeptName", app.SubcategoryName),
                        new MySqlParameter("@AppDate", appdate),
                        new MySqlParameter("@AppTime", app.Time),
                        new MySqlParameter("@PatientName", app.PName),
                        new MySqlParameter("@Mobile", app.Mobile),
                        new MySqlParameter("@Address", app.Address),
                        new MySqlParameter("@EntryById", Util.GetString(UserInfo.ID)),
                        new MySqlParameter("@EntryByName", Util.GetString(UserInfo.LoginName)),
                        new MySqlParameter("@Address1", app.Address1),
                        new MySqlParameter("@Address2", app.Address2),
                        new MySqlParameter("@PinCode", app.Pinno),
                        new MySqlParameter("@EmailID", app.Emailid),
                         new MySqlParameter("@Investigation", app.ItemName),
                        new MySqlParameter("@Rate", app.Rate),
                        new MySqlParameter("@AgeYear", Util.GetInt(app.Ageyear)),
                        new MySqlParameter("@AgeMonth", Util.GetInt(app.Agemonth)),
                        new MySqlParameter("@AgeDays", Util.GetInt(app.Agedays)),
                        new MySqlParameter("@Gender", app.Gender),
                        new MySqlParameter("@PanelID", app.PanelID),
                        new MySqlParameter("@Referdoctor", app.DoctorID),
                        new MySqlParameter("@Title", app.Title),
                        new MySqlParameter("@CentreID", app.Centre),
                        new MySqlParameter("@ReferenceID", AppointmentID),
                        new MySqlParameter("@PatientType", app.PatientType),
                        new MySqlParameter("@TimeSlotCount", app.Bookingnumber),
                        new MySqlParameter("@Remarks", app.Remarks),
                        new MySqlParameter("@PanelType", app.PanelType),
                        new MySqlParameter("@GrossAmount", app.GrossAmount),
                        new MySqlParameter("@NetAmount", app.NetAmount),
                        new MySqlParameter("@Adjustment", app.Adjustment),
                        new MySqlParameter("@ItemID", app.ItemID),
                        new MySqlParameter("@ConfirmById", Util.GetString(UserInfo.ID)),
                        new MySqlParameter("@ConfirmByName", Util.GetString(UserInfo.LoginName)));

                }
                int avgtime = Convert.ToInt32(StockReports.ExecuteScalar(" SELECT VALUE FROM appointment_radiology_setup WHERE FIELD='Slotgap'"));
               
                TimeSpan interval = TimeSpan.Parse(Appdata[0].Time);
                TimeSpan newtime = new TimeSpan();
                for (int slotcount = 1; slotcount <= Util.GetInt(Appdata[0].Bookingnumber); slotcount++)
                {
                    if (slotcount == 1)
                    {
                        newtime = interval;
                    }
                    else
                    {
                        TimeSpan span2 = TimeSpan.FromMinutes(avgtime);
                        newtime = newtime.Add(span2);
                    }

                    string str = "insert into appointment_radiology_details_Slots (AppointmentID,AppDate,AppTime) VALUES(@AppointmentID,@AppDate,@AppTime);";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str,
                  new MySqlParameter("@AppointmentID", AppointmentID),
                  new MySqlParameter("@AppDate", appdate),
                 new MySqlParameter("@AppTime", newtime));
                }

                foreach (Receipt rrc in Rcdata)
                {
                    Receipt objRC = new Receipt(Tranx)
                    {
                        LedgerNoCr = "OPD003",
                        LedgerTransactionID = 0,
                        LedgerTransactionNo = "",
                        CreatedByID = UserInfo.ID,
                        Patient_ID = "",
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
                        Panel_ID = Util.GetInt(Appdata[0].PanelID),
                        CreatedDate = System.DateTime.Now,
                        S_Amount = rrc.S_Amount,
                        S_CountryID = rrc.S_CountryID,
                        S_Currency = rrc.S_Currency,
                        S_Notation = rrc.S_Notation,
                        C_Factor = rrc.C_Factor,
                        Currency_RoundOff = rrc.Currency_RoundOff,
                        CurrencyRoundDigit = rrc.CurrencyRoundDigit,
                        CreatedBy = UserInfo.LoginName,
                        Converson_ID = rrc.Converson_ID
                    };
                    string ReceiptNo = objRC.Insert();
                    if (ReceiptNo == string.Empty)
                    {
                        Tranx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
                    }
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE f_Receipt SET AppointmentID=@AppointmentID WHERE ReceiptNo=@ReceiptNo",
              new MySqlParameter("@AppointmentID", AppointmentID),
              new MySqlParameter("@ReceiptNo", ReceiptNo));
                }

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE appointment_radiology_details_attachment SET AppID=@newAppID WHERE AppID=@oldAppID",
           new MySqlParameter("@newAppID", AppointmentID),
           new MySqlParameter("@oldAppID", Appdata[0].fAppId));
                if (Appdata[0].Mobile != string.Empty)
                {
                   int centretypeid=Util.GetInt(MySqlHelper.ExecuteScalar(con,CommandType.Text,"SELECT CentreType1ID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                       new MySqlParameter("@Panel_ID",Appdata[0].PanelID)));

                    SMSDetail sd = new SMSDetail();
                    List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>  
                        {  
                            new SMSDetailListRegistration {
                                                AppointmentID=Util.GetString(AppointmentID),
                                                PName = Appdata[0].PName,
                                                Gender = Appdata[0].Gender,
                                                GrossAmount=Util.GetString(Appdata[0].GrossAmount),
                                                NetAmount=Util.GetString(Appdata[0].NetAmount),
                                                PaidAmout=Util.GetString(Appdata[0].Adjustment) ,
                                                AppointmentDate=appdatetime
                                               }   
                        };
                    JSONResponse SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(1, Util.GetInt(Appdata[0].PanelID), centretypeid, "Patient", Appdata[0].Mobile,Util.GetInt(AppointmentID), con, Tranx, SMSDetail));

                    if (SMSResponse.status == false)
                    {
                        Tranx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                    }
                    SMSDetail.Clear();
                }

                Tranx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = "saved", Appdata = AppointmentID });
            }
            else
            {               
                try
                {                    
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from appointment_radiology_details where AppointmentID=@AppointmentID",
                        new MySqlParameter("@AppointmentID", Appdata[0].Appid));
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from appointment_radiology_details_slots where AppointmentID=@AppointmentID",
                        new MySqlParameter("@AppointmentID", Appdata[0].Appid));

                    foreach (SaveAppointment app in Appdata)
                    {
                        sb = new StringBuilder();
                        sb.Append(@" INSERT INTO appointment_radiology_details  
                                (AppointmentID,DeptID,DeptName,AppDate,AppTime,PatientName,Mobile,Address,EntryDateTime,EntryById,EntryByName,  
                               Address1,Address2,PinCode,EmailID,Investigation,Rate,AgeYear, AgeMonth, AgeDays, Gender,PanelID,Referdoctor,Title,
                               CentreID,ReferenceID,PatientType,TimeSlotCount,Remarks,PanelType,GrossAmount,NetAmount,Adjustment,ItemID)
                            VALUES (@AppointmentID,@DeptID, @DeptName,@AppDate,@AppTime,@PatientName,@Mobile,@Address,NOW(), @EntryById,@EntryByName, 
                           @Address1,@Address2,@PinCode,@EmailID,@Investigation,@Rate,@AgeYear,@AgeMonth ,@AgeDays,@Gender,@PanelID,@Referdoctor,@Title,
                          @CentreID,@ReferenceID,@PatientType,@TimeSlotCount,@Remarks,@PanelType,@GrossAmount,@NetAmount,@Adjustment,@ItemID) ");
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                             new MySqlParameter("@AppointmentID", Appdata[0].Appid),
                            new MySqlParameter("@DeptID", app.SubcategoryID),
                            new MySqlParameter("@DeptName", app.SubcategoryName),
                            new MySqlParameter("@AppDate", appdate),
                            new MySqlParameter("@AppTime", app.Time),
                            new MySqlParameter("@PatientName", app.PName),
                            new MySqlParameter("@Mobile", app.Mobile),
                            new MySqlParameter("@Address", app.Address),
                            new MySqlParameter("@EntryById", Util.GetString(UserInfo.ID)),
                            new MySqlParameter("@EntryByName", Util.GetString(UserInfo.LoginName)),
                            new MySqlParameter("@Address1", app.Address1),
                            new MySqlParameter("@Address2", app.Address2),
                            new MySqlParameter("@PinCode", app.Pinno),
                            new MySqlParameter("@EmailID", app.Emailid),
                             new MySqlParameter("@Investigation", app.ItemName),
                            new MySqlParameter("@Rate", app.Rate),
                            new MySqlParameter("@AgeYear",Util.GetInt(app.Ageyear)),
                            new MySqlParameter("@AgeMonth",Util.GetInt( app.Agemonth)),
                            new MySqlParameter("@AgeDays",Util.GetInt( app.Agedays)),
                            new MySqlParameter("@Gender", app.Gender),
                            new MySqlParameter("@PanelID", app.PanelID),
                            new MySqlParameter("@Referdoctor", app.DoctorID),
                            new MySqlParameter("@Title", app.Title),
                            new MySqlParameter("@CentreID", app.Centre),
                            new MySqlParameter("@ReferenceID", Appdata[0].Appid),
                            new MySqlParameter("@PatientType", app.PatientType),
                            new MySqlParameter("@TimeSlotCount", app.Bookingnumber),
                            new MySqlParameter("@Remarks", app.Remarks),
                            new MySqlParameter("@PanelType", app.PanelType),
                            new MySqlParameter("@GrossAmount", app.GrossAmount),
                            new MySqlParameter("@NetAmount", app.NetAmount),
                            new MySqlParameter("@Adjustment", app.Adjustment),
                            new MySqlParameter("@ItemID", app.ItemID));
                    }
                    int avgtime = Convert.ToInt32(StockReports.ExecuteScalar(" SELECT VALUE FROM appointment_radiology_setup WHERE FIELD='Slotgap'"));

                    TimeSpan interval = TimeSpan.Parse(Appdata[0].Time);
                    TimeSpan newtime = new TimeSpan();
                    for (int slotcount = 1; slotcount <= Util.GetInt(Appdata[0].Bookingnumber); slotcount++)
                    {
                        if (slotcount == 1)
                        {
                            newtime = interval;
                        }
                        else
                        {
                            TimeSpan span2 = TimeSpan.FromMinutes(avgtime);
                            newtime = newtime.Add(span2);
                        }

                        string str = "insert into appointment_radiology_details_Slots (AppointmentID,AppDate,AppTime) VALUES(@AppointmentID,@AppDate,@AppTime);";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str,
                      new MySqlParameter("@AppointmentID",Appdata[0].Appid),
                      new MySqlParameter("@AppDate", appdate),
                     new MySqlParameter("@AppTime", newtime));
                    }

                   
                    if (Appdata[0].Type == "1")
                    {
                        StringBuilder sb1 = new StringBuilder();
                        sb1.Append(@" INSERT INTO `appointment_radiology_details_update_status`(AppointmentID,DATETIME,UserID,UserName,STATUS,Remarks) 
                                      VALUES (@AppointmentID ,NOW(), @UserID,@UserName, 'Edit', @Remarks )");
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb1.ToString(),
                            new MySqlParameter("@AppointmentID",Appdata[0].Appid),
                            new MySqlParameter("@UserID", Util.GetString(UserInfo.ID)),
                            new MySqlParameter("@UserName", Util.GetString(UserInfo.LoginName)),
                            new MySqlParameter("@Remarks",Appdata[0].Remarks));
                    }                   
                    Tranx.Commit();

                    return JsonConvert.SerializeObject(new { status = true, response = "updated", Appdata = Appdata[0].Appid });
                }
                catch (Exception ex)
                {
                    Tranx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = ex.InnerException.Message.ToString() });
                }
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);           
            return JsonConvert.SerializeObject(new { status = false, response = ex.InnerException.Message.ToString()});
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]    
    public static string getoldpatient(string mobile)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID,DeptID,DeptName,PatientName,Gender,AgeYear,AgeMonth,DATE_FORMAT(AppDate,'%d-%b-%Y')AppDate,TIME_FORMAT(AppTime,'%h:%i %p')AppTime, ");
            sb.Append(" AgeDays,Mobile,EmailID,Address,Address1,Address2,Pincode FROM appointment_radiology_details where Mobile=@Mobile AND Iscancel=0 ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Mobile", mobile)).Tables[0])
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
    public static string getoldpatientdetail(string ID, string Mobile)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DeptID,DeptName,PatientName,Gender,AgeYear,AgeMonth,AgeDays,DATE_FORMAT(AppDate,'%d-%b-%Y')AppDate,TIME_FORMAT(AppTime,'%h:%i %p')AppTime, ");
            sb.Append(" Mobile,EmailID,Address,Address1,Address2,Pincode,Investigation,TimeSlotCount FROM appointment_radiology_details where Mobile=@Mobile and ID=@ID ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Mobile", Mobile),
                new MySqlParameter("@ID", ID)).Tables[0])
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
    public static string changeappdatetime(string appid, string date, string time, string deptid, string deptname, string remarks, string Centre, string oldapptime)
    {                        

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "select adjustment,CentreID,PanelID,mobile,Patientname,Gender,GrossAmount,`netamount`,`Adjustment` from  appointment_radiology_details where AppointmentID=@AppointmentID",
               new MySqlParameter("@AppointmentID", appid)).Tables[0];

            string appdate = Util.GetDateTime(date).ToString("yyyy-MM-dd");
           // System.IO.File.AppendAllText("E:\\abc.txt", appdate);  
            string appdatetime = Util.GetDateTime(date + " " + time).ToString("yyyy-MM-dd hh:mm:ss");
            StringBuilder sb = new StringBuilder();
            sb.Append(@" update appointment_radiology_details ad inner join appointment_radiology_details_slots ads
                    on  ads.AppointmentID=ad.AppointmentID
                        set  ad.isReschedule=1,ad.RescheduleDate=now(),ad.RescheduleRemarks=@RescheduleRemarks,
                        ad.RescheduleByName=@RescheduleByName, ad.RescheduleByID=@RescheduleByID,ads.AppDate=@AppDate,ads.AppTime=@AppTime,
                        ad.DeptID=@DeptID,ad.DeptName=@DeptName,ad.CentreID=@CentreID
                        where ads.AppointmentID=@AppointmentID and ads.AppTime=@oldAppTime ;");
            //,ad.AppDate=@AppDate,ad.AppTime=@AppTime

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@RescheduleRemarks", remarks),
                 new MySqlParameter("@RescheduleByName", Util.GetString(UserInfo.LoginName)),
               new MySqlParameter("@RescheduleByID", Util.GetString(UserInfo.ID)),
                new MySqlParameter("@AppDate", appdate),
                 new MySqlParameter("@AppTime", time),
                  new MySqlParameter("@DeptID", deptid),
                  new MySqlParameter("@DeptName", deptname),
                  new MySqlParameter("@CentreID", Centre.ToString()),
               new MySqlParameter("@AppointmentID", appid),
               new MySqlParameter("@oldAppTime", oldapptime));

            sb = new StringBuilder();
            sb.Append(@" INSERT INTO `appointment_radiology_details_update_status`(AppointmentID,DATETIME,UserID,UserName,STATUS,Remarks) 
                VALUES( @AppointmentID ,NOW(), @UserID,@UserName,'Update', @Remarks )");

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@AppointmentID", appid),
                 new MySqlParameter("@UserName", Util.GetString(UserInfo.LoginName)),
               new MySqlParameter("@UserID", Util.GetString(UserInfo.ID)),
                new MySqlParameter("@Remarks", remarks));

            if (Util.GetString(dt.Rows[0]["mobile"]) != string.Empty)
            {
                int centretypeid = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CentreType1ID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                    new MySqlParameter("@Panel_ID", Util.GetInt(dt.Rows[0]["PanelID"]))));

                SMSDetail sd = new SMSDetail();
                List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>  
                        {  
                            new SMSDetailListRegistration {
                                                AppointmentID=Util.GetString(appid),
                                                PName = Util.GetString(dt.Rows[0]["Patientname"]),
                                                Gender = Util.GetString(dt.Rows[0]["Gender"]),
                                                GrossAmount=Util.GetString(dt.Rows[0]["GrossAmount"]),
                                                NetAmount=Util.GetString(dt.Rows[0]["netamount"]),
                                                PaidAmout=Util.GetString(dt.Rows[0]["Adjustment"]),
                                                AppointmentDate=appdatetime
                                               }   
                        };
                JSONResponse SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(3, Util.GetInt(dt.Rows[0]["PanelID"]), centretypeid, "Patient", Util.GetString(dt.Rows[0]["mobile"]), Util.GetInt(appid), con, Tranx, SMSDetail));

                if (SMSResponse.status == false)
                {
                    Tranx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                }
                SMSDetail.Clear();
            }
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Appointment Reschedule Successfully...!" });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.GetBaseException() });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        } 
    }

    [WebMethod]    
    public static string getappdata(string deptid, string date, string time, string Centre)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select isedited,ifnull(UpdateByName,'')UpdateByName,IsBooked, (CASE WHEN Iscancel = '1' THEN 'Pink' WHEN IsBooked='0' AND  PatientType='VIP' AND IsConfirmed='0' THEN '#E9967A' WHEN IsBooked='0' AND  PatientType='Normal' AND IsConfirmed='0' THEN '#FFFFFF' WHEN IsBooked='0' AND  PatientType='Normal' AND IsConfirmed='1' THEN 'yellow' WHEN IsBooked='0' AND  PatientType='VIP' AND IsConfirmed='1' THEN 'orange' WHEN IsBooked='1' AND  PatientType='VIP' THEN '#00FFFF' WHEN  IsBooked='1' AND PatientType='Normal' THEN '#90EE90'    WHEN IsBooked = '0' ");
            sb.Append(" THEN 'yellow'  WHEN IsBooked = '1' THEN '#90EE90'  ELSE  '#90EE90'    END)RowColor , ifnull(cancelreason,'')cancelreason,Iscancel");
            sb.Append(" , ad.AppointmentID id, PatientName,PatientType, CONCAT(CONCAT(IF(ageyear<>0,CONCAT(ageyear,' Y'),''),IF(agemonth<>0,CONCAT(' ',agemonth,' M'),''),");
            sb.Append("IF(agedays<>0,CONCAT(' ',agedays,' D'),'')),'/',LEFT(gender,1)) pinfo");
            sb.Append(" ,Mobile, Address ,EmailID,Round(GrossAmount)TotalAmt,Round(Adjustment)Paidamt,");
            sb.Append(" Group_concat(Investigation)Investigation,DATE_FORMAT(ads.AppDate,'%d-%m-%Y') appdate,DATE_FORMAT(ads.apptime,'%h:%i %p')apptime,DATE_FORMAT(ad.EntryDateTime,'%d-%m-%Y %h:%i %p')Reg_DateTime,EntryByName,IsConfirmed,(SELECT COUNT(1) FROM  appointment_radiology_details_attachment WHERE AppID=ad.id ) filecount ");
            sb.Append(" FROM appointment_radiology_details ad ");
            sb.Append(" inner join appointment_radiology_details_slots ads on ads.AppointmentID=ad.AppointmentID");
            sb.Append(" where  ads.appdate=@appdate and CentreID=@CentreID ");
            sb.Append(" and DeptID=@DeptID and ads.apptime=@apptime GROUP BY ad.AppointmentID,ads.apptime");
//System.IO.File.AppendAllText("C:\\abc.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@appdate", Util.GetDateTime(date).ToString("yyyy-MM-dd")),
                  new MySqlParameter("@CentreID", Centre),
                  new MySqlParameter("@DeptID", deptid),
                  new MySqlParameter("@apptime", Util.GetDateTime(time).ToString("HH:mm:ss"))).Tables[0])
            {
                //DataColumn dcm = new DataColumn();
                //dcm.ColumnName = "mytest";
                //dt.Columns.Add(dcm);
                //string ss = "";

                //foreach (DataRow dwc in dt.Rows)
                //{
                //    ss = "";
                //    try
                //    {
                //        foreach (string ss1 in dwc["Investigation"].ToString().Split('#'))
                //        {
                //            if (ss1 != "")
                //            {
                //                ss += ss1.Split('_')[1] + "^";
                //            }
                //        }
                //        dwc["mytest"] = ss;
                //    }
                //    catch
                //    {
                //        dwc["mytest"] = ss;
                //    }
                //}

                //dt.AcceptChanges();
                return makejsonoftable(dt, makejson.e_without_square_brackets);
            }

            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(null);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }          
    }

    [WebMethod]    
    public static string editappgetdata(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"SELECT PatientName,PatientType,AgeYear,AgeMonth,AgeDays,Gender,Mobile,EmailID,PanelID,Referdoctor,PanelType,ItemID,Rate,
                     Address,Address1,Address2,PinCode,DeptName,Investigation,CentreID,IsBooked,TimeSlotCount ,Round(GrossAmount)GrossAmount,Round(NetAmount)NetAmount,Round(Adjustment)Adjustment
                      FROM appointment_radiology_details WHERE AppointmentID=@ID");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ID", id)).Tables[0])
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
    public static string cencelapp(string id, string reason, string Booked)
    {
        if (Booked == "1")
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Appointment Already Booked...!" });
        }              
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "select adjustment,CentreID,PanelID,mobile,Patientname,Gender,GrossAmount,`netamount`,`Adjustment` from  appointment_radiology_details where AppointmentID=@AppointmentID",
                new MySqlParameter("@AppointmentID", id)).Tables[0];

            StringBuilder sb = new StringBuilder();
            sb.Append(" update appointment_radiology_details set Iscancel=1,CancelDate=now(),CancelById=@CancelById, ");
            sb.Append(" CancelByName=@CancelByName,cancelreason=@cancelreason where AppointmentID=@AppointmentID");

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CancelById", Util.GetString(UserInfo.ID)),
               new MySqlParameter("@CancelByName", Util.GetString(UserInfo.LoginName)),
               new MySqlParameter("@cancelreason", reason),
               new MySqlParameter("@AppointmentID", id));
            if (Util.GetFloat(dt.Rows[0]["adjustment"]) > 0)
            {
                Receipt objRC = new Receipt(Tranx)
                {
                    LedgerNoCr = "HOSP0005",
                    LedgerTransactionID = 0,
                    LedgerTransactionNo = "",
                    CreatedByID = UserInfo.ID,
                    Patient_ID = "",
                    PayBy = "P",
                    PaymentMode = "Cash",
                    PaymentModeID = 1,
                    Amount = Util.GetDecimal(dt.Rows[0]["adjustment"])*-1,
                    BankName = "",
                    CardNo = "",
                    IsCancel = 0,
                    Narration = reason,
                    CentreID = UserInfo.Centre,
                    Panel_ID = Util.GetInt(dt.Rows[0]["PanelID"]),
                    CreatedDate = System.DateTime.Now,
                    S_Amount = Util.GetDecimal(dt.Rows[0]["adjustment"])*-1,
                    S_CountryID = 14,
                    S_Currency = "INR",
                    S_Notation = "INR",
                    C_Factor = 1,
                    Currency_RoundOff = 0,
                    CurrencyRoundDigit = 2,
                    CreatedBy = UserInfo.LoginName,                 
                };
                string ReceiptNo = objRC.Insert();
                if (ReceiptNo == string.Empty)
                {
                    Tranx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
                }
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE f_Receipt SET AppointmentID=@AppointmentID WHERE ReceiptNo=@ReceiptNo",
             new MySqlParameter("@AppointmentID", id),
             new MySqlParameter("@ReceiptNo", ReceiptNo));
            }
            if (Util.GetString(dt.Rows[0]["mobile"]) != string.Empty)
            {
                int centretypeid = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CentreType1ID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                    new MySqlParameter("@Panel_ID", Util.GetInt(dt.Rows[0]["PanelID"]))));

                SMSDetail sd = new SMSDetail();
                List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>  
                        {  
                            new SMSDetailListRegistration {
                                                AppointmentID=Util.GetString(id),
                                                PName = Util.GetString(dt.Rows[0]["Patientname"]),
                                                Gender = Util.GetString(dt.Rows[0]["Gender"]),
                                                GrossAmount=Util.GetString(dt.Rows[0]["GrossAmount"]),
                                                NetAmount=Util.GetString(dt.Rows[0]["netamount"]),
                                                PaidAmout=Util.GetString(dt.Rows[0]["Adjustment"]) 
                                               }   
                        };
                JSONResponse SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(2, Util.GetInt(dt.Rows[0]["PanelID"]), centretypeid, "Patient", Util.GetString(dt.Rows[0]["mobile"]), Util.GetInt(id), con, Tranx, SMSDetail));

                if (SMSResponse.status == false)
                {
                    Tranx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                }
                SMSDetail.Clear();
            }
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Appointment Cancel Successfully...!" });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.GetBaseException() });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        } 
    }
    [WebMethod]    
    public static string ConfirmAppointment(string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" update appointment_radiology_details set IsConfirmed=1,ConfirmDate=now(),ConfirmById=@ConfirmById, ");
            sb.Append(" ConfirmByName=@ConfirmByName where AppointmentID=@AppointmentID");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@ConfirmById", Util.GetString(UserInfo.ID)),
               new MySqlParameter("@ConfirmByName", Util.GetString(UserInfo.LoginName)),
               new MySqlParameter("@AppointmentID", ID));

            return JsonConvert.SerializeObject(new { status = true, response = "Appointment Confirmed...!" });            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex .GetBaseException()});   
        }
        finally
        {
            con.Close();
            con.Dispose();
        }           
    }

    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }   
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        string status = hdnstatus.Value;
        dt_from = dtFrom.Text;
        if (ddlCentreAccess.SelectedItem.Value == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "alert('Please select centre.....');", true);           
        }
        getdata(dtFrom.Text, ddlCentreAccess.SelectedItem.Value.ToString(), status);
        dt_CentrID = ddlCentreAccess.SelectedItem.Value.ToString();
        ScriptManager.RegisterStartupScript(Page, GetType(), "showDeptName", "<script>showDeptName()</script>", false);     
    }
    protected void ddlCentreAccess_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindFlashmsg(ddlCentreAccess.SelectedValue);
    }
    public class SaveAppointment
    {
        public string ItemName { get; set; }
        public float Rate { get; set; }
        public int ItemID { get; set; }
        public decimal GrossAmount { get; set; }
        public decimal NetAmount { get; set; }
        public decimal Adjustment { get; set; }
        public string DoctorID { get; set; }
        public string SubcategoryID { get; set; }
        public string SubcategoryName { get; set; }
        public string date { get; set; }
        public string Time { get; set; }
        public string PName { get; set; }
        public string Mobile { get; set; }
        public string Address { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Emailid { get; set; }
        public string Pinno { get; set; }
        public string Ageyear { get; set; }
        public string Agemonth { get; set; }
        public string Agedays { get; set; }
        public string Gender { get; set; }
        public string Appid { get; set; }
        public string PanelID { get; set; }
        public string Title { get; set; }
        public string Centre { get; set; }
        public string Type { get; set; }
        public string Booked { get; set; }
        public string Bookingnumber { get; set; }
        public string Bookingnum { get; set; }
        public string PatientType { get; set; }
        public string Remarks { get; set; }
        public string fAppId { get; set; }
        public string PanelType { get; set; }
    }
}