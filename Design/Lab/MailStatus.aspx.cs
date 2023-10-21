using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Linq;
using System.Net;
using System.Text;


using System.Web.Services;
using System.Web.Script.Services;
using MySql.Data.MySqlClient;

public partial class Design_Lab_MailStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtLabNo.Focus();
            bindAllData();
            if (Session["RoleID"].ToString() == "15")
            {
                txtToTime.Visible = false;
                txtFromTime.Visible = false;
            }
        }
    }

    private void bindAllData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pn.Company_Name,concat(pn.Panel_ID,'#',pn.ReferenceCodeOPD)PanelID  FROM Centre_Panel cp ");
            sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId=@centre AND cp.isActive=1 order by pn.Company_Name ");
            DataTable dtPanel = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@centre", Util.GetInt(Session["Centre"].ToString()))).Tables[0];
            if (dtPanel != null && dtPanel.Rows.Count > 0)
            {
                ddlPanel.DataSource = dtPanel;
                ddlPanel.DataTextField = "Company_Name";
                ddlPanel.DataValueField = "PanelID";
                ddlPanel.DataBind();
                ddlPanel.Items.Insert(0, "");
            }
            else
            {
                ddlPanel.Items.Clear();
                ddlPanel.Items.Add("-");
            }
            DataTable dtDoc = StockReports.GetDataTable("select Doctor_ID,Name from doctor_referal where IsActive = 1 order by name ");
            if (dtDoc != null && dtDoc.Rows.Count > 0)
            {
                ddlReferDoctor.DataSource = dtDoc;
                ddlReferDoctor.DataTextField = "Name";
                ddlReferDoctor.DataValueField = "Doctor_ID";
                ddlReferDoctor.DataBind();
            }
            ddlReferDoctor.Items.Insert(0, "--Select---");

            string str = " SELECT fl.centreID,cm.Centre  FROM f_login fl INNER JOIN centre_master cm ON cm.CentreID=fl.centreID  WHERE cm.isactive='1' and employeeID=@EmployeeId  ORDER BY cm.Centre  ";
            DataTable dat2 = MySqlHelper.ExecuteDataset(con, CommandType.Text, str.ToString(),
                new MySqlParameter("@EmployeeId", Session["ID"].ToString())).Tables[0];
            ddlCentreAccess.DataSource = dat2;
            ddlCentreAccess.DataTextField = "Centre";
            ddlCentreAccess.DataValueField = "CentreID";
            ddlCentreAccess.DataBind();
            ddlCentreAccess.Items.Insert(0, new ListItem("--Select--", ""));
            sb = new StringBuilder();
            sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
            sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
            if (Convert.ToString(Session["LoginType"]).ToUpper() == "RADIOLOGY")
                sb.Append("  WHERE im.ReportType=5  and ot.isActive=1 ORDER BY ot.Name");
            else
                sb.Append("  WHERE im.ReportType<>5  and ot.isActive=1 ORDER BY ot.Name ");
            DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            if (dt1.Rows.Count > 0)
            {
                ddlDepartment.DataSource = dt1;
                ddlDepartment.DataValueField = "ObservationType_ID";
                ddlDepartment.DataTextField = "Name";
                ddlDepartment.DataBind();
                ListItem list = new ListItem("", "");
                ddlDepartment.Items.Insert(0, list);
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

    [WebMethod]
    public static string SearchMail(string LabNo, string RegNo,
        string PName, string CentreID, string dtFrom, string dtTo, string Dept, string Status,
        string PhoneNo, string Mobile, string refrdby, string Ptype, string TimeFrm, string TimeTo, string FromLabNo, string ToLabNo, string PanelID, string CardNoFrom, string CardNoTo, string type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string LabType = "OPD";
            StringBuilder sb = new StringBuilder();
            string RolID = HttpContext.Current.Session["RoleID"].ToString();
            sb.Append("select drr.email DoctorEmailId , Concat(drr.Title,'',drr.Name)Doctor,'' as ReportDate,'OPD' Type,im.Name ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.Patient_ID, PM.Patient_ID PID,PM.pname,CONCAT(pm.age,'/',LEFT(pm.gender,1)) age,pm.gender, fpm.EmailID AS PanelMailID,fpm.Company_Name as PanelName,pm.Email as PatientMailID,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.LedgertransactionId as Transaction_ID,pli.Test_ID,pli.LedgerTransactionNo,pli.LedgerTransactionNo LTD,im.Name,'' CardNo,lt.panel_ID as PanelID");
            sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved=1,'True','False') chkWork,DATE_FORMAT(pli.DAte,'%h:%i %p') Time,if(PLI.IsSampleCollected = 'Y','YES','NO')IsSample,DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y')SampleDate,obm.Name as Dept,IM.ReportType,Concat('clsP','_',fpm.Panel_ID)panelClass, Concat('cls','_',drr.Doctor_ID)DoctorClass,");
            if (type == "1")
            {
                sb.Append(" er.IsSend,er.EmailId,");
                sb.Append(" CASE WHEN pli.Approved=1 And er.isSend is null   THEN '#90EE90' WHEN pli.Approved=1 And er.isSend=0  THEN '#FFC0CB' WHEN pli.Approved=1 And er.isSend=1  THEN '#3399FF' when er.isSend=-1 THEN '#E2680A' ELSE '#FFFFFF'  END rowColor   ");
            }
            else
            {
               
                sb.Append(" erb.isSent as IsSend ,erb.EmailAddress as EmailId,");
                sb.Append(" CASE WHEN pli.Approved=1 And  erb.isSent is null  THEN '#90EE90' WHEN pli.Approved=1 And  erb.isSent=0 THEN '#FFC0CB' WHEN pli.Approved=1 And erb.isSent=1 THEN '#3399FF'  ELSE '#FFFFFF'  END rowColor   ");
            }

            sb.Append(" from patient_labinvestigation_opd pli  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt on lt.LedgerTransactionID=pli.LedgerTransactionID AND pli.IsActive=1 AND pli.IsSampleCollected='Y'  ");// lt.IsCancel=0 and
            if (dtFrom != string.Empty)
                sb.Append(" AND PLI.ApprovedDate >=@dtFrom ");
            if (dtTo != string.Empty)
                sb.Append(" AND PLI.ApprovedDate <=@dtTo ");
            if (FromLabNo != string.Empty)
            {
                sb.Append(" AND PLI.LedgerTransactionNo >=@FromLabNo ");
            }
            if (FromLabNo != string.Empty && ToLabNo != string.Empty)
            {
                sb.Append(" AND PLI.LedgerTransactionNo >=@FromLabNo");
                sb.Append(" AND pLI.LedgerTransactionNo <=@ToLabNo ");
            }
            if (LabNo != string.Empty)
            {
                sb.Append(" AND PLI.LedgerTransactionNo Like @LabNo");
            }
            if (CentreID != "")
                sb.Append(" AND lt.CentreID=@CentreID ");
            else
                sb.Append(" AND lt.CentreID=@centerSession ");

            if (Ptype == "1")
                sb.Append(" AND lt.PatientType='Urgent' ");
            if (PanelID != "")
            {
                sb.Append(" AND lt.panel_ID  IN ({0})  ");
            }
            sb.Append(" INNER JOIN patient_master PM on lt.Patient_ID = PM.Patient_ID  ");
            if (RegNo != string.Empty)
                if (LabType == "OPD")
                    sb.Append(" and PM.Patient_ID=@RegNo ");
                else
                    sb.Append(" and PM.Patient_ID=@RegNo");
            if (PName != string.Empty)
                sb.Append(" and PM.PName like @PName");

            if (PhoneNo.Trim() != "")
                sb.Append(" and PM.Phone like @PhoneNo");

            if (Mobile.Trim() != "")
                sb.Append(" and PM.Mobile like @Mobile");

            if (refrdby != "--Select---")
            {
                sb.Append(" AND lt.Doctor_Id=@refrdby ");
            }
            sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID = lt.Panel_ID  ");
            sb.Append(" INNER JOIN doctor_referal drr ON drr.doctor_id = lt.Doctor_Id ");
            sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID ");
            if (Dept != "")
            {
                sb.Append(" AND io.ObservationType_ID=@Dept");
            }
            sb.Append(" INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");

            if (type == "1")
            {
                sb.Append(" Left Join (SELECT * FROM email_record_patient  GROUP BY LedgerTransactionId)er on  er.LedgerTransactionId=pli.LedgerTransactionId where ''='' ");
            }
            else
            {
                sb.Append(" Left Join( SELECT * from  email_record_bill GROUP BY LedgerTransactionId)  erb on  erb.`LedgerTransactionId`=pli.`LedgerTransactionId` where ''=''  ");

            }
            if (Status == "1")
            {
                sb.Append(" AND pli.Approved=1");
            }
            else if (Status == "2")
            {
                sb.Append(" AND er.IsSend=0");
            }
            else if (Status == "3")
            {
                sb.Append(" AND er.IsSend=1");
            }
            else
            {
                sb.Append(" AND er.IsSend=-1");

            }
            if (type == "2")
            {
                sb.Append(" GROUP BY PLI.LedgerTransactionID ");
            }
            else {
            
            
            }
            sb.Append(" order by lt.LedgerTransactionNo,obm.Name,im.Print_Sequence ");

            PanelID = PanelID.Split('#')[0];
            string[] tags = PanelID.Replace("'", "").Split(',');
            tags = tags.Take(tags.Count() - 1).ToArray();
            string[] paramNames = tags.Select(
                  (s, i) => "@tag" + i).ToArray();
            string inClause = string.Join(", ", paramNames);

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), inClause), con))
            {
                for (int i = 0; i < paramNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@dtFrom", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd"), " 00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@dtTo", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " 23:59:59"));
                da.SelectCommand.Parameters.AddWithValue("@FromLabNo", FromLabNo.Trim());
                da.SelectCommand.Parameters.AddWithValue("@ToLabNo", ToLabNo);
                da.SelectCommand.Parameters.AddWithValue("@PanelID", PanelID);
                da.SelectCommand.Parameters.AddWithValue("@RegNo", RegNo.Trim());
                da.SelectCommand.Parameters.AddWithValue("@PName", PName.Trim() + "%");
                da.SelectCommand.Parameters.AddWithValue("@PhoneNo", PhoneNo.Trim() + "%");
                da.SelectCommand.Parameters.AddWithValue("@Mobile", Mobile.Trim() + "%");
                da.SelectCommand.Parameters.AddWithValue("@refrdby", refrdby);
                da.SelectCommand.Parameters.AddWithValue("@Dept", Dept);
                da.SelectCommand.Parameters.AddWithValue("@CentreID", CentreID);
                da.SelectCommand.Parameters.AddWithValue("@centerSession", HttpContext.Current.Session["Centre"].ToString());
                da.SelectCommand.Parameters.AddWithValue("@LabNo", "%" + LabNo);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                }
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}
