using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_Lab_BarCodeReprint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblLedgertransactionNo.Text = Common.Decrypt(Request.QueryString["LabID"].ToString());
        }
    }
    [WebMethod]
    public static string bindBarCodeReprint(string LedgertransactionNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT plo.Test_Id,plo.BarcodeNo,pm.PName,plo.ItemName,sub.Name Department,IF(IsSampleCollected NOT IN('N','R'),'1','0')IsSampleCollected FROM patient_labinvestigation_opd plo INNER JOIN patient_master pm ");
            sb.Append(" ON plo.Patient_ID=pm.Patient_ID INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID=plo.SubCategoryID WHERE Plo.IsRefund=0 and plo.isreporting=1 ");
            sb.Append(" AND plo.LedgertransactionNo=@LedgertransactionNo");

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgertransactionNo", LedgertransactionNo)).Tables[0]);
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