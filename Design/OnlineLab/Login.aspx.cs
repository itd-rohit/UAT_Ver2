using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class Design_Online_Lab_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      
        string Username = ""; Request.QueryString["LabNo"].ToString();        
        string Password = ""; Request.QueryString["WebPassword"].ToString();   
		
        if(Util.GetString(Request.QueryString["IsTinySMS"])=="1")
		{
			  Username = Request.QueryString["LabNo"].ToString(); 
              Password = Request.QueryString["WebPassword"].ToString();
		}	  
        else
		{
			 Username = Common.Decrypt(HttpUtility.UrlDecode(Util.GetString(Request.QueryString["LabNo"])).Trim().Replace(" ", "+"));
             Password =  Common.Decrypt(HttpUtility.UrlDecode(Util.GetString(Request.QueryString["WebPassword"])).Trim().Replace(" ", "+"));
		}		
		
        string IsTinySMS = "0";
        try
        {
            IsTinySMS = Util.GetString(Request.QueryString["IsTinySMS"]).Trim();
            if (IsTinySMS.Trim() == "")
            {
                IsTinySMS = "0";
            }
        }
        catch
        {
            IsTinySMS = "0";
        }
       // Username = Username.Replace("IT", "");

       // string s = "select pname from f_ledgertransaction  where  Password_web=@Password_web and LedgerTransactionNo=@LedgerTransactionNo ";	
	string s = "select pname from f_ledgertransaction  where  Password_web=@Password_web and Username_web=@LedgerTransactionNo ";
        DataTable dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, s,
            new MySql.Data.MySqlClient.MySqlParameter("@Password_web", Password.Trim()),
            new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", Username.Trim())).Tables[0];

        if (dt.Rows.Count == 0)
        {
            lblError.Text = "Invalid Username or Password.";
            Username = "";
            lblError.Visible = true;

        }
        else
        {

            string due = "select (NetAmount - Adjustment )DueAmt from f_ledgertransaction where Username_web=@LedgerTransactionNo and IsCredit=0 and NetAmount > Adjustment";
          
            decimal dueAmt =Util.GetDecimal( MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, due,
            new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", Username.Trim())));
            if (dueAmt == 0)
            {
                lblError.Text = "valid";


                string testtoprint = "";
                string query = "select group_concat(plo.test_id) from patient_labinvestigation_opd plo inner join f_ledgertransaction lt on lt.LedgerTransactionID=plo.LedgerTransactionID where lt.Username_web=@LedgerTransactionNo and plo.approved=1";
                 testtoprint = MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, query,
                 new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", Username.Trim())).ToString();
              
                    //if (tests.Tables[0].Rows.Count > 0)
                 if (testtoprint != string.Empty)
                    {
                        lblError.Visible = false;
                        if (IsTinySMS.Trim() == "1")
                        {
                            string reportURLToGet = Resources.Resource.RemoteLink;
                           // string reportURLToGet = "http://itd-saas.cl-srv.ondgni.com/UAT_Ver1";
                            reportURLToGet +=string.Format("/Design/lab/labreportnew.aspx?TestID={0}&isOnlinePrint={1}&PHead={2}&app={3}", HttpUtility.UrlEncode(Common.Encrypt(testtoprint.Trim())), HttpUtility.UrlEncode(Common.Encrypt("1")), HttpUtility.UrlEncode(Common.Encrypt("1")), HttpUtility.UrlEncode(Common.Encrypt("1")));
                            MemoryStream file = this.ConvertToStreamFile(reportURLToGet);
                            byte[] byteArray = file.ToArray();
                            file.Flush();
                            file.Close();
                            Response.Clear();
                            Response.AddHeader("Content-Disposition", "attachment; filename=report.pdf");
                            Response.AddHeader("Content-Length", byteArray.Length.ToString());
                            Response.ContentType = "application/pdf";
                            Response.BinaryWrite(byteArray);
                            Response.End();
                        }
                        else
                        {
                           
                            Response.Redirect(string.Format("../lab/labreportnew.aspx?TestID={0}&isOnlinePrint={1}&PHead={2}&app={3}", HttpUtility.UrlEncode(Common.Encrypt(testtoprint.Trim())), HttpUtility.UrlEncode(Common.Encrypt("1")), HttpUtility.UrlEncode(Common.Encrypt("1")), HttpUtility.UrlEncode(Common.Encrypt("1"))));
                        }
                    }

               // Response.Redirect("../lab/labreportnew.aspx?TestID=" + testtoprint + "&isOnlinePrint=1&app=1&PHead=1");
             
              
            }
            else
            {

               
                lblError.Text = "Kindly pay due Amount Rs." + dueAmt.ToString();
                lblError.Visible = true;
            }

        }

    }
    public MemoryStream ConvertToStreamFile(string fileUrl)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(fileUrl);
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        MemoryStream result;
        try
        {
            MemoryStream mem = this.CopyStream(response.GetResponseStream());
            result = mem;
        }
        finally
        {
            response.Close();
        }
        return result;
    }
    public MemoryStream CopyStream(Stream input)
    {
        MemoryStream output = new MemoryStream();
        byte[] buffer = new byte[16384];
        int read;
        while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
        {
            output.Write(buffer, 0, read);
        }
        return output;
    }
}
