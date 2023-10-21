using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OnlineLab_ReportAPI : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string UserName = Util.GetString(Request.Form["UserName"]);
        string Password = Util.GetString(Request.Form["Password"]);
        string VisitNo = Util.GetString(Request.Form["VisitNo"]);
        string TestCode = Util.GetString(Request.Form["TestCode"]);

        if (UserName == "PHR" || UserName == "INSTA")
        {
            if ((UserName == "PHR" && Password == "PHR90VU456BMK3345") || (UserName == "INSTA" && Password == "INSTA0VU4FH7K3345"))
            {



                string s = "";

                if (UserName == "INSTA")
                {
                    s = " SELECT COUNT(*) from  `f_ledgertransaction` lt   WHERE lt.`LedgerTransactionNo_Interface`=@LedgerTransactionNo  ";
                }
                else
                {
                    s = "SELECT COUNT(*) from `f_ledgertransaction` lt   WHERE lt.`LedgerTransactionNo`=@LedgerTransactionNo   ";
                }

                int CheckLabNo = Util.GetInt(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, s,
                    new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", VisitNo.Trim())));

                if (CheckLabNo == 0)
                {
                    Response.Write("VisitNo not found !!");
                    return;
                }

                if (TestCode != "" && UserName == "PHR")
                {

                    s = "SELECT count(*) TestID FROM `patient_labinvestigation_opd`  plo  WHERE LedgertransactionNo=@LedgerTransactionNo AND TestCode=@TestCode  GROUP BY LedgertransactionNo  ";


                    CheckLabNo = Util.GetInt(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, s,
                        new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", VisitNo.Trim()),
                        new MySql.Data.MySqlClient.MySqlParameter("@TestCode", TestCode.Trim())));
                    if (CheckLabNo == 0)
                    {
                        Response.Write("TestCode not found !!");
                        return;
                    }
                
                }




                string TestID = "";

                if (TestCode.Trim() == "")
                {

                    if (UserName == "INSTA")
                    {
                        s = " SELECT GROUP_CONCAT( plo.test_id) TestID FROM `patient_labinvestigation_opd`  plo INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   WHERE lt.`LedgerTransactionNo_Interface`=@LedgerTransactionNo AND plo.Approved=1 AND plo.ApprovedDate >= DATE_ADD(NOW(), INTERVAL -30 DAY ) GROUP BY lt.`LedgerTransactionNo_Interface` ";
                    }
                    else
                    {
                        s = "SELECT GROUP_CONCAT( plo.test_id) TestID FROM `patient_labinvestigation_opd`  plo  WHERE LedgertransactionNo=@LedgerTransactionNo AND Approved=1 AND ApprovedDate >= DATE_ADD(NOW(), INTERVAL -30 DAY ) GROUP BY LedgertransactionNo  ";
                    }

                    TestID = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, s,
                        new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", VisitNo.Trim())));


                }
                else if (TestCode != "" && UserName == "PHR")
                {

                    s = "SELECT GROUP_CONCAT( plo.test_id) TestID FROM `patient_labinvestigation_opd`  plo  WHERE LedgertransactionNo=@LedgerTransactionNo AND TestCode=@TestCode AND Approved=1 AND ApprovedDate >= DATE_ADD(NOW(), INTERVAL -30 DAY ) GROUP BY LedgertransactionNo  ";


                    TestID = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, s,
                        new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", VisitNo.Trim()),
                         new MySql.Data.MySqlClient.MySqlParameter("@TestCode", TestCode.Trim())));
                
                
                }


                if (TestID != "")
                {
                    //Response.Write("Salek !!");
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('" + string.Format("../lab/labreportnew.aspx?TestID={0}&isOnlinePrint={1}&PHead={2}&app={3}", HttpUtility.UrlEncode(Common.Encrypt(Util.GetString(dtTestID.Rows[0]["TestID"]))), HttpUtility.UrlEncode(Common.Encrypt("1")), HttpUtility.UrlEncode(Common.Encrypt("1")), HttpUtility.UrlEncode(Common.Encrypt("1"))) + "');", true);
                    if (UserName == "INSTA")
                    {
                        Response.Redirect(string.Format("../lab/labreportnew.aspx?TestID={0}&isOnlinePrint={1}&PHead={2}&app={3}", Common.Encrypt(Util.GetString(TestID)), Common.Encrypt("1"), Common.Encrypt("0"), Common.Encrypt("1")));
                    }
                    else
                    {
                        Response.Redirect(string.Format("../lab/labreportnew.aspx?TestID={0}&isOnlinePrint={1}&PHead={2}&app={3}", Common.Encrypt(Util.GetString(TestID)), Common.Encrypt("1"), Common.Encrypt("1"), Common.Encrypt("1")));
                    }
                    //  string redirect = string.Format("../lab/labreportnew.aspx?TestID={0}&isOnlinePrint={1}&PHead={2}&app={3}", Common.Encrypt(Util.GetString(TestID)), Common.Encrypt("1"), Common.Encrypt("1"), Common.Encrypt("1"));
                    //         
                    //ClientScript.RegisterStartupScript(this.GetType(), "Key1", String.Format("<script>window.open('{0}');</script>", redirect),false);

                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('" + redirect + "');", true);  
                }

                else
                {
                    Response.Write("Reports are not ready !!");
                }


            }
            else
            {
                Response.Write("Invalid Password !!");
            }

        }
        else
        {
            Response.Write("Invalid UserName !!");
        
        }


    }
}