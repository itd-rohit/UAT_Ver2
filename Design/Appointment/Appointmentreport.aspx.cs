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
using System.Text;
using System.Runtime.InteropServices;

public partial class Appointmentreport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
          string aa=  macAddress.macAddressDetail(Request.UserHostAddress);
          string bb = macAddress.GetMacAddress(Request.UserHostAddress);
            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            HomeVisitBoy();
            bindPanel();
            BindCenter(); 
        }
        txtFormDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void bindPanel()
    {
       
    }
    public void BindCenter()
    {
        string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' and AccessType=2 ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstCenter.DataSource = dt;
        chklstCenter.DataTextField = "Centre";
        chklstCenter.DataValueField = "CentreID";
        chklstCenter.DataBind();
        for (int i = 0; i < chklstCenter.Items.Count; i++)
        {
            chklstCenter.Items[i].Selected = true;
        }
    }
    public void HomeVisitBoy()
    {
        string str = "  select FeildboyID ID,Name from feildboy_master where IsActive = 1 order by name ";
        ddlhomevisit.DataSource = StockReports.GetDataTable(str);
        ddlhomevisit.DataTextField = "Name";
        ddlhomevisit.DataValueField = "ID";
        ddlhomevisit.DataBind();
        ddlhomevisit.Items.Insert(0, new ListItem("",""));
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string chkCenter = AllLoad_Data.GetSelection(chklstCenter);
        if (chkCenter == "")
        {
            lblMsg.Text = "!!! Please Select Centre !!!";
            return;
        }
        lblMsg.Text = "";
        StringBuilder sb=new StringBuilder();
        //sb.Append(" SELECT AppointmentID,CONCAT(Title,PName) AS PName,Age,IF(DOB='0001-01-01','',DATE_FORMAT(DOB,'%d-%M-%y')) AS DateOfBirth,Gender,Mobile,Phone,House_No AS Address,Email,FieldBoyName Phlebotomist,Comments, ");
        //sb.Append(" GROUP_CONCAT(ItemName)AS Investigation, ");
        //sb.Append(" IFNULL((SELECT CONCAT(Title,'',NAME) FROM doctor_referal df WHERE df.doctor_id=lad.doctor_id),'') AS DoctorName, ");
        //sb.Append(" IFNULL((SELECT company_name FROM f_panel_master fpm WHERE fpm.panel_id=lad.panel_id),'') AS Panel , ");
        //sb.Append(" (SELECT centre FROM centre_master WHERE centreid=lad.CentreID) Center, ");
        //sb.Append(" DATE_FORMAT(AppointmentDate,'%d-%M-%y') AS AppointmentDate, ");
        //sb.Append(" TIME_FORMAT(AppointmentTime,'%h:%i %p') AS AppointmentTime, ");
        //sb.Append(" IF(IFNULL(LedgertransactionNo,0)=0,IF(IsCancelled=1,'Cancel','Pending'),'Booked') STATUS,CreatorName BookingBy,CancelReason,CancelByUser, ");
        //sb.Append(" DATE_FORMAT(DateEnrolled,'%d-%M-%y %h:%i%p') BookingOn    ");
        //sb.Append(" FROM lab_appointment_details lad  ");
        //sb.Append(" WHERE  Date(" + ddlDateType.SelectedValue + ")>='" + ucFromDate.GetDateForDataBase() + "' AND Date(" + ddlDateType.SelectedValue + ")<='" + ucToDate.GetDateForDataBase() + "' ");
         sb.Append("SELECT a.ID AS AppointmentID,CONCAT(a.Title,a.PatientName) AS PName,a.AgeYear AS Age,");
        // sb.Append("a.Gender,a.Mobile,CONCAT(a.Address,a.Address1,a.Address2) AS Address,a.EmailID AS Email,a.PhlebotomistName AS  Phlebotomist,");
         sb.Append("a.Gender,a.Mobile,CONCAT(a.Address,a.Address1,a.Address2) AS Address,a.EmailID AS Email,");
         sb.Append("a.Investigation, (SELECT centre FROM centre_master WHERE CentreID=a.CentreID) Center,'' AS Comments,'' AS DateOfBirth,'' AS Phone,'' AS DoctorName,'' AS Panel, ");
  sb.Append("DATE_FORMAT(AppDate,'%d-%M-%y') AS AppointmentDate,TIME_FORMAT(AppTime,'%h:%i %p') AS AppointmentTime,");
  sb.Append("IF(IFNULL(LedgertransactionNo,0)=0,IF(Iscancel=1,'Cancel','Pending'),'Booked') STATUS,BookedBy AS BookingBy,CancelReason,");
  sb.Append("CancelByName AS CancelByUser,DATE_FORMAT(BookedDate,'%d-%M-%y %h:%i%p') BookingOn FROM appointment_radiology_details a");
  sb.Append(" WHERE  AppDate >='" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND AppDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'");
  
        
        if(chkCenter!="")
        {
            sb.Append(" and CentreID IN (1)  ");
        } 
        if (iscancel.Checked)
        {
            sb.Append("  and Iscancel=1  ");
        }
        else
        {
            sb.Append("  and Iscancel=0   ");
        }
        if (ddlhomevisit.SelectedItem.Text != "")
        {
            sb.Append("  and PhlebotomistID ='" + ddlhomevisit.SelectedValue + "'  ");
        }
        if (ddlpanel.SelectedItem.Text.ToUpper() != "ALL")
        {

            if (ddlpanel.SelectedItem.Text.ToUpper() == "PANEL")
            {
            sb.Append("  and panel_id='00'   ");
            }
            else
            {
                sb.Append("  and panel_id='78'   ");
            }
        }
        
            sb.Append(" GROUP BY AppointmentID; "); 
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count>0)
            {
                if (rblReportFormat.SelectedItem.Value != "Excel")
                {
                    DataColumn dc = new DataColumn();
                    dc.ColumnName = "User";
                    dc.DefaultValue = StockReports.GetDataTable(Convert.ToString(Session["ID"])).Rows[0][0];
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "Period";
                    dc.DefaultValue = "Period From : " + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
                    dt.Columns.Add(dc);

                    dc = new DataColumn();
                    dc.ColumnName = "CentreHeader";
                    dc.DefaultValue = StockReports.ExecuteScalar("SELECT HeaderInfo FROM centre_master WHERE CentreID='" + UserInfo.Centre + "'"); ;
                    dt.Columns.Add(dc);
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());


                   // ds.WriteXmlSchema(@"D:\AppointmentReport.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "AppointmentReport";
                    //if (rblReportFormat.SelectedItem.Value == "PDF")
                    //{
                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/Commonreport.aspx');", true);
                    //}
                    //else
                    //{
                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/CommonCrystalReport.aspx');", true);
                    //}
                }
                else if (rblReportFormat.SelectedValue == "Excel")
                {
                    Session["ReportName"] = "Appointment Report";
                    Session["Period"] = "Period From : " + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");
                    Session["dtExport2Excel"] = dt;


                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                }
            }
            else
            {
                lblMsg.Text = "No Record Found..!";
            } 
           
    }

  
}
