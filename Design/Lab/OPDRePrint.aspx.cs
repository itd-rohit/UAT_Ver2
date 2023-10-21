using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_OPDRePrint : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
			 //if (AllLoad_Data.checkPageAuthorisation(Session["RoleID"].ToString(), Session["ID"].ToString(), HttpContext.Current.Request.Url.AbsolutePath.Remove(0, VirtualPathUtility.ToAbsolute("~/").Length - 1)) == 0)
            //{
             //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Common/UserAuthorization.aspx?msg=You are not authoried to access OPD Reprint Page!!';", true);
               //return;
            //}
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindMethod();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string encryptData(string LabNo)
    {
        return JsonConvert.SerializeObject(new { LabNo = Common.Encrypt(LabNo) });

    }
    private void BindMethod()
    {
        string pro_id = Session["PROID"].ToString();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string str = "";
            if (UserInfo.CentreType == "PUP" || UserInfo.LoginType == "PCC" || UserInfo.LoginType== "SUBPCC")
                str = " SELECT distinct cm.CentreID,cm.Centre Centre FROM centre_master cm where ( cm.CentreID = @Centre) and cm.isActive=1 order by cm.centrecode,cm.Centre  ";
            else 
                str= " SELECT distinct cm.CentreID,cm.Centre Centre FROM centre_master cm where ( cm.CentreID in (SELECT CentreAccess from centre_access where CentreID =@Centre ) or cm.CentreID = @Centre) and cm.isActive=1 order by cm.centrecode,cm.Centre  ";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
                new MySqlParameter("@Centre", UserInfo.Centre)).Tables[0])
            {
                ddlCentreAccess.DataSource = dt;
                ddlCentreAccess.DataTextField = "Centre";
                ddlCentreAccess.DataValueField = "CentreID";
                ddlCentreAccess.DataBind();
                if (UserInfo.CentreType != "PUP" || UserInfo.LoginType == "PCC" || UserInfo.LoginType == "SUBPCC") ddlCentreAccess.Items.Insert(0, new ListItem("ALL Centre", "ALL"));
              //  ddlCentreAccess.SelectedIndex = ddlCentreAccess.Items.IndexOf(ddlCentreAccess.Items.FindByValue(Util.GetString(UserInfo.Centre)));

            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT em.Name,em.Employee_ID Employee_ID FROM f_login f INNER JOIN employee_master em ON em.Employee_ID=f.EmployeeID  AND em.`IsActive`=1  AND f.RoleID IN(9,214,211,11) AND f.`CentreID`=@CentreID GROUP BY `Employee_ID` ORDER BY Name ",
                new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
 {
                if (UserInfo.LoginType == "PCC" || UserInfo.LoginType == "SUBPCC")
                {
                    ddlUser.Items.Insert(0, new ListItem("ALL User", "All"));
                }
                else
            {
                ddlUser.DataSource = dt;
                ddlUser.DataTextField = "Name";
                ddlUser.DataValueField = "Employee_ID";
                ddlUser.DataBind();
                ddlUser.Items.Insert(0, new ListItem("ALL User", "ALL"));
                if (UserInfo.RoleID !=177 && UserInfo.RoleID !=220)
                ddlUser.SelectedIndex = ddlUser.Items.IndexOf(ddlUser.Items.FindByValue(Util.GetString(UserInfo.ID)));
}

            }
            HttpContext ctx = HttpContext.Current;
            string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(panel_code,'~',company_name) panelName ,panel_id FROM  f_panel_master  WHERE isActive=1  and  panel_Id  in(SELECT PanelId FROM centre_panel WHERE IsActive=1 AND CentreId=" + UserInfo.Centre + " )");
            if (Util.GetString(ctx.Session["PanelType"]) == "PCC")
            {
                sb.Append(" and InvoiceTo =" + InvoicePanelID + "");
            }
            else if (Util.GetString(ctx.Session["PanelType"]).ToUpper() == "SUBPCC")
            {
                sb.Append(" and employee_ID=" + Util.GetString(ctx.Session["ID"]) + "");
            }
            else if (UserInfo.RoleID == 220 && pro_id == "0")
            {
                sb.Append(" and Panel_ID in(select cm.PanelID from centre_panel cm where cm.centreID= " + UserInfo.Centre + ")   ");
            }
            else if (UserInfo.RoleID == 220 && pro_id != "0")
            {
                sb.Append(" and Panel_ID in(select cm.PanelID from centre_panel cm where cm.centreID= " + UserInfo.Centre + ") and PROID='" + pro_id + "' ");
            }
            //sb.Append("  ORDER BY panel_code");
			
			 //System.IO.File.WriteAllText("C:\\ITDose\\444455.txt", sb.ToString());
			
            ddlPanel.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            ddlPanel.DataTextField = "panelName";
            ddlPanel.DataValueField = "panel_id";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("All Panel", "0"));
        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchReceiptData(SearchData searchdata, string stype, string PageNo, string PageSize)
    {
         HttpContext ctx = HttpContext.Current;

         string pro_id = HttpContext.Current.Session["PROID"].ToString();

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
            StringBuilder sb = new StringBuilder();
            sb.Append("");
            sb.Append("SELECT IFNULL((SELECT COUNT(*) FROM document_detail WHERE Labno=lt.Ledgertransactionno AND isactive=1),0) DocAttach,lt.LedgerTransactionID ,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i %p') EntryDate,DATE_FORMAT(lt.`Date`,'%d-%b-%Y')RegDate ,");
            sb.Append(" lt.`LedgerTransactionNo` LabNo,CONCAT(pm.`Title`,pm.`PName`) PName,CONCAT(pm.`Age`,'/',LEFT(pm.`Gender`,1)) Pinfo,");
            sb.Append(" pm.`Mobile`,lt.`DoctorName` DoctorName,lt.`PanelName`,lt.IsOPDConsultation,");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreID=lt.centreid)CentreName,");//CAST((COUNT(DISTINCT barcodeno)) AS DECIMAL(2)) AS SampleCount
            sb.Append(" lt.CreatedBy UserName,lt.`GrossAmount`,lt.`DiscountOnTotal`,lt.`NetAmount`,CAST((lt.`NetAmount`) AS DECIMAL)NetAmount1,lt.`Adjustment`,");
            sb.Append("  GROUP_CONCAT(REPLACE(inv.Name,',',' ')) AS ItemName,        ");
            sb.Append("  GROUP_CONCAT(IF(plo.Result_Flag=1 AND plo.Approved=0 ,'Y','N'))Result_Flag,   ");
            sb.Append("  GROUP_CONCAT(IF(plo.Approved=1 AND plo.isPrint=0,'Y','N'))Approved, ");
            sb.Append("  GROUP_CONCAT(IF(plo.isPrint=1 AND plo.Approved=1 ,'Y','N'))ReportPrint,CASE WHEN GROUP_CONCAT(DISTINCT plo.BarcodeNo SEPARATOR ',<br/>') !='undefined' THEN GROUP_CONCAT(DISTINCT plo.BarcodeNo SEPARATOR ',<br/>') ELSE '' END BarcodeNo,");
            sb.Append("  CASE    ");
            if (stype == "5")
            {
                sb.Append(" when (select count(*) from patient_labinvestigation_opd_update_status where Ledgertransactionno=lt.ledgertransactionno and (ifnull(BarcodeNo,'')='' or status  like'%Added New Item%' ) and status not like '%Registration Done%'  )>0 then '#FFFF00'");
            }
            else
            {
                sb.Append(" WHEN  (SELECT SUM(Amount) FROM patient_labinvestigation_opd WHERE  LedgerTransactionID = plo.`LedgerTransactionID`)=0 and plo.isactive=0 THEN '#6699ff'  ");
                sb.Append(" WHEN (lt.NetAmount-lt.Adjustment)=0  AND lt.iscredit=0 THEN '#00FA9A'  ");
                sb.Append(" WHEN (lt.iscredit =1) THEN '#F0FFF0'  ");
                sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment>0 AND lt.iscredit=0 THEN '#F6A9D1'  ");
                // sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0 AND lt.iscredit=0 THEN '#DDA0DD' ");
                sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0 AND lt.iscredit=0 THEN '#FF457C' ");
            }
            
            sb.Append(" ELSE '#F6A9D1'  END  rowColor,lt.Iscredit");
            sb.Append(" ,lt.IsDiscountApproved,lt.DiscountApprovedByID,IFNULL(lt.DiscountApprovedByName,'') DiscountApprovedByName,IFNULL(fpm.ReceiptType,'')ReceiptType   ");
            sb.Append(" ,(SELECT SUM(Amount) FROM patient_labinvestigation_opd WHERE  LedgerTransactionID = plo.`LedgerTransactionID`) Amount,(lt.NetAmount-lt.Adjustment)Due ");
            sb.Append(",(SELECT COUNT(*) FROM investigation_concernform ivc WHERE ivc.investigationid=plo.Investigation_id) IsConcernForm ");
            sb.Append(" FROM `f_ledgertransaction` lt ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  AND plo.IsActive=1");//AND plo.IsActive=1
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
            sb.Append(" INNER JOIN investigation_master inv ON inv.investigation_id = plo.investigation_id");
        
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID = lt.Panel_ID");

            if ((Util.GetString(searchdata.PanelID) == "0"))
            {

                if (UserInfo.RoleID == 220 && pro_id != "0")
                {
                   // sb.Append(" And lt.Panel_ID IN(SELECT Panel_ID FROM f_panel_master WHERE PROID='" + pro_id + "' ) ");
				    sb.Append(" And lt.ProID='" + pro_id + "' ");
                }

                else
                {
                    sb.Append(" And lt.Panel_ID IN(SELECT Panel_ID FROM f_panel_master ) ");
                }
            }
            else
            {
                sb.Append(" AND lt.Panel_ID=@Panel_ID");
            }
            //else
            //{
            //    if (Util.GetString(searchdata.PanelID) != "0")
            //    {
            //        sb.Append(" AND lt.Panel_ID=@Panel_ID");
            //    }
            //}
            //if (Util.GetString(searchdata.User) != "ALL")
            //{
            //    sb.Append(" and fpm.Panel_ID =@Panel_ID");
            //}
            if (Util.GetString(ctx.Session["PanelType"]) == "PCC")
            {
                sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + "");
            }
            else if (Util.GetString(ctx.Session["PanelType"]).ToUpper() == "SUBPCC")
            {
                sb.Append(" and fpm.employee_ID=" + Util.GetString(ctx.Session["ID"]) + "");
            }
            if (Util.GetString(searchdata.LabNo) == string.Empty || Util.GetString(searchdata.SearchType) == "PM.PName")
            {
                sb.Append(" where lt.date>=@fromDate AND lt.date<=@toDate ");
            }
            if (Util.GetString(searchdata.Centre) != "ALL")
            {
                sb.Append(" AND  lt.centreid=@Centre");
            }
            else
            {
                sb.Append(" AND (lt.CentreID in ( SELECT DISTINCT `CentreAccess` FROM `centre_access` WHERE `CentreID`=@LoginCentre  ) or lt.CentreID=@LoginCentre ) ");
            }


            if (Util.GetString(searchdata.SearchType) == "PM.PName")
            {
                sb.Append(" AND "); sb.Append(searchdata.SearchType); sb.Append(" LIKE @PName ");
            }
            if (Util.GetString(searchdata.LabNo) != string.Empty && (Util.GetString(searchdata.SearchType) != "PM.PName"))
            {
                sb.Append(" AND "); sb.Append(searchdata.SearchType); sb.Append(" =@LabNo");
            }
            switch (stype)
            {
                case "1": sb.Append(" AND (lt.NetAmount-lt.Adjustment)=0 ");//Cash Paid
                    break;
                case "2":
                    sb.Append(" AND (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment>0 AND lt.iscredit=0 ");//Full Un-Paid
                    break;
                case "3": sb.Append(" AND (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0 AND lt.iscredit=0 ");//Partial Paid
                    break;
                case "4": sb.Append(" AND lt.iscredit =1  "); //Credit
                    break;
                case "5": sb.Append(" and (select count(*) from patient_labinvestigation_opd_update_status where Ledgertransactionno=lt.ledgertransactionno and (ifnull(BarcodeNo,'')='' or status  like'%Added New Item%' )  and status not like '%Registration Done%' )>0 ");
                    break;
                case "6": sb.Append(" and (SELECT SUM(Amount) FROM patient_labinvestigation_opd WHERE  LedgerTransactionID = plo.`LedgerTransactionID`)=0 and plo.isactive=0");
                    break;

            }

            sb.Append(" GROUP BY lt.LedgerTransactionNo order by lt.date desc");
            if (PageNo != "0")
            {
                int from = Util.GetInt(PageSize) * Util.GetInt(PageNo);
                int to = Util.GetInt(PageSize);
                sb.Append(" LIMIT "); sb.Append(from); sb.Append(","); sb.Append(to); sb.Append(" ");
            }
            DataTable dtN = new DataTable();

            //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\aa.txt", searchdata.Centre + "::::" + string.Concat(Util.GetDateTime(searchdata.ToDate).ToString("yyyy-MM-dd"), " ", searchdata.ToTime) + "::::" + string.Concat(Util.GetDateTime(searchdata.FromDate).ToString("yyyy-MM-dd"), " ", searchdata.FromTime));
            //System.IO.File.WriteAllText(@"C:\ITDOSE\UAT_Ver1\ErrorLog\aa2.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Employee_ID", Util.GetString(searchdata.User)),
                    new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(searchdata.FromDate).ToString("yyyy-MM-dd"), " ", searchdata.FromTime)),
                    new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(searchdata.ToDate).ToString("yyyy-MM-dd"), " ", searchdata.ToTime)),
                    new MySqlParameter("@Centre", searchdata.Centre),
                    new MySqlParameter("@LoginCentre", UserInfo.Centre),
                    new MySqlParameter("@LoginUser", UserInfo.ID),
                    new MySqlParameter("@LabNo", Util.GetString(searchdata.LabNo)),
                    new MySqlParameter("@SearchType", Util.GetString(searchdata.SearchType)),
                    new MySqlParameter("@PName", string.Concat("%", Util.GetString(searchdata.LabNo), "%")),
                    new MySqlParameter("@Panel_ID",Util.GetString(searchdata.PanelID))).Tables[0])
            {
              //  if (PageNo == "0")
               // {
                string totalnetam;
                totalnetam = dt.AsEnumerable().Sum(x => x.Field<decimal>("NetAmount1")).ToString();
    
  

                    if (dt.Rows.Count > 0)
                    {

                        dt.Columns.Add("TotalRecord");
                        dt.Columns.Add("EncryptID");
                        dt.Columns.Add("ttlNetAmount");
                        dt.Rows[0]["ttlNetAmount"] = totalnetam;
                        foreach (DataRow dw in dt.Rows)
                        {
                           
                            dw["TotalRecord"] = dt.Rows.Count.ToString();
                            //dw["ttlNetAmount"] = totalnetam;
                            dw["EncryptID"] = Common.Encrypt(Util.GetString(dw["LedgerTransactionID"]));
                        }
                        dt.AcceptChanges();
                        dtN = dt.AsEnumerable().Skip(0).Take(Util.GetInt(PageSize)).CopyToDataTable();
                    }
               // }
               
            }
            return JsonConvert.SerializeObject(dtN);

        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public static string ResendDiscountVerificationMail(string Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string str = " SELECT dem.Email,dem.Body FROM discountemail_log dem INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionId=dem.LedgertransactionId WHERE lt.LedgertransactionID=@LedgertransactionID ";
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
                new MySqlParameter("@LedgertransactionID", Common.Decrypt(Id))).Tables[0])
            {
                try
                {
                    if (dt.Rows.Count > 0)
                    {
                        ReportEmailClass res = new ReportEmailClass();
                        string status = res.sendDiscountApproval(dt.Rows[0]["Email"].ToString(), "Discount Approval/Rejection", dt.Rows[0]["Body"].ToString());
                        if (status == "1")
                            return JsonConvert.SerializeObject(new { status = true, response = "Email Sent" });
                        else
                            return JsonConvert.SerializeObject(new { status = false, response = "Email Not Sent" });
                    }
                    else
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Email Not Sent" });
                    }

                }
                catch (Exception ex)
                {
                    ClassLog CL = new ClassLog();
                    CL.errLog(ex);
                    return JsonConvert.SerializeObject(new { status = false, response = "Email Not Sent" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Email Not Sent" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetDiscountApprovalStatus(string Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(EM.Title,' ',EM.NAme) Name,dem.Email,lt.IsDiscountApproved FROM discountemail_log dem ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionId=dem.LedgertransactionId ");
            sb.Append(" INNER JOIN Employee_Master EM ON EM.Employee_ID=lt.DiscountApprovedById");
            sb.Append(" WHERE lt.LedgertransactionID=@LedgertransactionID");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@LedgertransactionID", Common.Decrypt(Id))).Tables[0])
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string loadSmsdetail(string MobileNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Mobile_No,IF(Issend=0,'failed','Send')STATUS,DATE_FORMAT(EntDate,'%d-%b-%y %h:%s %p')EntDate,Sms_Type  FROM sms where Mobile_No=@Mobile_No order by EntDate desc,Sms_Type",
                  new MySqlParameter("@Mobile_No", MobileNo)).Tables[0];
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string sendtinysms(string MobileNo, int LabNo, string BillType, string smstype)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string SMS_text = "";
            string Tinylink = "";
            string smstypemsg = "";
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Round(NetAmount)NetAmount,Round(Adjustment)Adjustment,Pname,LedgerTransactionNo FROM f_ledgertransaction WHERE LedgerTransactionID=@LedgerTransactionID",
                  new MySqlParameter("@LedgerTransactionID", LabNo)).Tables[0];
            if (dt.Rows.Count== 0)
                return JsonConvert.SerializeObject(new { status = false, response = "No Record found..!" });

                SMSDetail sd = new SMSDetail();
                if (smstype == "Receipt")
                {
                    SMS_text = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Template  FROM sms_configuration where ID=11"));
                    Tinylink = sd.tinysmsbill(Util.GetString(LabNo), Util.GetInt(BillType), "Bill");
                    SMS_text = SMS_text.Replace("{PName}", dt.Rows[0]["Pname"].ToString()).Replace("{TinyURL}", Tinylink).Replace("{NetAmount}", dt.Rows[0]["NetAmount"].ToString()).Replace("{PaidAmout}", dt.Rows[0]["Adjustment"].ToString());
                    smstypemsg = "Tiny SMS Bill";
                }
                else
                {
                    SMS_text = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Template  FROM sms_configuration where ID=12"));
                    Tinylink = sd.tinysmsbill(Util.GetString(dt.Rows[0]["LedgerTransactionNo"]), Util.GetInt(BillType), "LabReport");
                    SMS_text = SMS_text.Replace("{PName}", dt.Rows[0]["Pname"].ToString()).Replace("{TinyURL}", Tinylink).Replace("{LabNo}", dt.Rows[0]["LedgerTransactionNo"].ToString());
                    smstypemsg = "Tiny SMS Lab Report";
                }
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO sms(Mobile_No,SMS_text,SMS_Type,LedgertransactionID,UserID)VALUES(@MobileNo,@SMS_text,@SMS_Type,@LedgertransactionID,@UserID)",
                                          new MySqlParameter("@MobileNo", MobileNo),
                                          new MySqlParameter("@SMS_text", SMS_text),
                                          new MySqlParameter("@SMS_Type", smstypemsg),
                                          new MySqlParameter("@LedgertransactionID", LabNo),
                                          new MySqlParameter("@UserID", UserInfo.ID));
                return JsonConvert.SerializeObject(new { status = true, response = "SMS Send Successfully..!" });
            
          
        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error in sending SMS..!" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public class SearchData
    {
        public string SearchType { get; set; }
        public string LabNo { get; set; }
        public string Centre { get; set; }
        public string User { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string FromTime { get; set; }
        public string ToTime { get; set; }
        public string PanelID { get; set; }

    }

    [WebMethod]
    public static string PostData(string ID)
    {
        return Util.getJson(new { LabID = Common.Encrypt(ID) });

    }

    [WebMethod]
    public static string ConcentFormData(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.`Patient_ID`,lt.Son,lt.Children,lt.AgeSon,lt.Daughter,lt.AgeDaughter,lt.`LedgerTransactionNo` LabNo, lt.`PName`,lt.`DoctorName`,lt.`PanelName`,plo.`ItemName`,lt.`Gender`, ");
        sb.Append(" lt.`Age`,DATE_FORMAT(lt.`Date`,'%d-%b-%Y')RegDate,DATE_FORMAT(lt.`Pregnancydate`,'%d-%b-%Y')Pregnancydate,pm.House_No,pm.`Mobile`,dr.`Name`, incf.`ConcentFormName` `ConcernFormid`,incf.`Type`,dr.`Mobile` DocMobile ");
        sb.Append(" FROM `f_ledgertransaction` lt ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN patient_master pm ON lt.`Patient_ID`=pm.`Patient_ID` ");
        sb.Append(" INNER JOIN doctor_referal dr ON lt.`Doctor_ID`=dr.`Doctor_ID` ");
        sb.Append(" INNER JOIN investigation_concernform inc ON plo.`Investigation_ID`=inc.`investigationid` ");
        sb.Append(" INNER JOIN investigation_concentform incf ON inc.`ConcernForm`=incf.`ConcentFormName` ");
        sb.Append(" WHERE lt.`ledgerTransactionNo`='"+LabNo+"' AND plo.`IsActive`=1 ");
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@ledgerTransactionNo", LabNo)).Tables[0])
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


    [WebMethod(EnableSession = true)]
    public static string GetPanelMaster()
    {
        string pro_id = HttpContext.Current.Session["PROID"].ToString();
        StringBuilder sb = new StringBuilder();
        HttpContext ctx = HttpContext.Current;
        string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
        sb.Append("SELECT fpm.`Panel_ID`, CONCAT(IF(IFNULL(fpm.panel_code,'')='',fpm.`Panel_ID`,fpm.panel_code), ' ~ ',fpm.company_name) company_name  FROM f_panel_master fpm  WHERE isactive=1 ");
        if (UserInfo.RoleID == 220 && pro_id != "0")
        {
            sb.Append(" and fpm.Panel_ID in(select cm.PanelID from centre_panel cm where cm.centreID= " + UserInfo.Centre + ") and fpm.PROID='" + pro_id + "' ");
        }
   //     sb.Append("SELECT panel_code, IF(fpm.panel_code='',company_name,CONCAT (fpm.panel_code,'~',company_name))company_name  FROM f_panel_master fpm  WHERE isactive=1 ");
        if (Util.GetString(ctx.Session["PanelType"]) == "PCC")
        {
            sb.Append(" and InvoiceTo =" + InvoicePanelID + " ");
        }
        else if (Util.GetString(ctx.Session["PanelType"]).ToUpper() == "SUBPCC")
        {
            sb.Append(" and employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
        }
        else if (UserInfo.CentreType == "PUP")
            sb.Append(" and Panel_ID=" + UserInfo.LoginType + "");
        
        sb.Append(" order by company_name ");
        return JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
        
    }
    [WebMethod(EnableSession = true)]
    public static string GetDoctorMaster()
    {

        return JsonConvert.SerializeObject(StockReports.GetDataTable("select doctor_id,name from doctor_referal WHERE isactive=1  order by name"));
      
    }
}