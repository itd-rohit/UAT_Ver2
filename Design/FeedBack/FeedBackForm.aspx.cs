using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_FeedBack_FeedBackForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      // txtdob.Text = DateTime.Now.ToString("dd-MM-yyyy");
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveFeedBack(string pName, string pMobile,string pID, string pEmail, string pDob, string pAddress, string pVisit, string pOverview, string pccLlAB, string prgProcess, string prgstaff, string pdrblood, string ptechCout, string preport, string prptdelivery, string poverAllreport, string prcommServices, string PRecommneded)
    {
        try
        {
            string query = "INSERT INTO FEEDBACK (FBNAME, FBDOV, FBADDRESS, FBMBNO, FBEMAILID, FBVISTITIME, FBKNOWABT, FBWHYCCL, FBREGPROCESS, FBSTAFF, FBBLOODTIME, FBTECH, FBREPORT, FBREPSERVICE, FBRATE, FBRECMMEND, FBFEEDBACK,Date,INID) VALUES('" + pName + "','" + Convert.ToDateTime(pDob).ToString("yyyy-MM-dd") + "','" + pAddress + "','" + pMobile + "','" + pEmail + "','" + pVisit + "','" + pOverview + "','" + pccLlAB + "','" + prgProcess + "','" + prgstaff + "','" + pdrblood + "','" + ptechCout + "','" + preport + "','" + prptdelivery + "','" + poverAllreport + "','" + prcommServices + "','" + PRecommneded + "',Now(),'" + pID + "')";
            StockReports.ExecuteDML(query.ToString());
            return "0";
        }
        catch (Exception ex) {
            return "1";
        }
    }
    protected void btnsendmail_Click(object sender, EventArgs e)
    {
        try
        {
            string mail = txtmail.Text;
            string comment = txtcomment.Text;
            using (MailMessage mm = new MailMessage(Util.getApp("FromMail"), mail))
            {
                mm.Subject = "FeedBack Reply";
                mm.Body = "Hi Sir/Madam :" + comment;
                //  mm.Attachments.Add(new Attachment(new MemoryStream(body), "PurchaseOrder.pdf"));
                mm.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                smtp.Host = "smtp.gmail.com";
                smtp.EnableSsl = true;
                NetworkCredential NetworkCred = new NetworkCredential(Util.getApp("FromMail"), Util.getApp("MailPwd"));
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                smtp.Port = 587;
                smtp.Send(mm);
            }
            Response.Write("<script>alert('Mail Send Successfully...');</script>");

        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }


    }
    protected void btnExcel_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT FBNAME Name,FBDOV DateOfVisit,FBADDRESS Address,FBMBNO MobileNo, ");
        sb.Append("  FBEMAILID EmailID,FBVISTITIME VisitTime,FBKNOWABT HowToKnow,FBWHYCCL WhyChooseCCL,FBREGPROCESS HowRegProcess,FBSTAFF StaffBehaviour,FBBLOODTIME WaitingTime, ");
        sb.Append(" FBTECH TechnicianBehaviour,FBREPORT HowToCollectReport,FBREPSERVICE KnowOurServices,FBRATE Rating,FBFEEDBACK FeedBack FROM feedback ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["ReportName"] = "FeedBack and Suggestion";
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found..";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewFeedBackLog(string MobileNo, string CallBy, string CallByID, string CallType, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ID = "";
            Patient_Estimate_Log pelObj = new Patient_Estimate_Log(tnx);
            pelObj.Mobile = MobileNo;
            pelObj.Call_By = CallBy;
            pelObj.Call_By_ID = CallByID;
            pelObj.Call_Type = CallType;
            pelObj.UserName = UserInfo.LoginName;
            pelObj.UserID = UserInfo.ID;
            pelObj.Remarks = Remarks;
            ID = pelObj.Insert();

            if (ID == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
            else
            {
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
        }
        finally { }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindFeedBack(string ID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT ID,FBNAME,DATE_FORMAT(FBDOV,'%d-%b-%Y')FBDOV,FBADDRESS,FBMBNO,FBEMAILID,FBVISTITIME,FBKNOWABT,FBWHYCCL,FBREGPROCESS,FBSTAFF,FBBLOODTIME,FBTECH,FBREPORT,FBREPSERVICE,FBRATE FROM feedback  WHERE INID LIKE '%" + ID + "' order by id ");
            string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retr;
        }
        catch (Exception ex)
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DeleteFeedBack(int ID)
    {
        string retr = "";
        try
        {
            bool result = StockReports.ExecuteDML("delete from feedback where id='" + ID + "' ");
            if (result == true)
            {
                retr = "1";
            }
            else
            {
                retr = "0";
            }
            return retr;
        }
        catch (Exception ex)
        {
            return retr = "2";
        }
    }
    protected void lnksendmail_Click(object sender, EventArgs e)
    {
        LinkButton btnsubmit = sender as LinkButton;
        GridViewRow grdrow = (GridViewRow)btnsubmit.NamingContainer;
        //lblid.Text = grd.DataKeys[grdrow.RowIndex].Value.ToString();
        txtmail.Text = grdrow.Cells[6].Text;
        this.modelmail.Show();
    }

}