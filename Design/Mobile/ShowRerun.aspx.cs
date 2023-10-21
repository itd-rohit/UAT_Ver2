using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mobile_ShowRerun : System.Web.UI.Page
{
    public DataTable datatable = new DataTable();
    public static string LabNo = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            if (Request.QueryString["LabNo"] != null)
            {
                LabNo = Request.QueryString["LabNo"].ToString();
            }
            
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT itemname,lom.`Name`,li.`labObservation_ID`,li.`Child_Flag`, IFNULL(IFNULL(ploo.Value,mac.Reading),'') VALUE, plo.BarCodeNo ");
            sb.Append("  FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN investigation_master im ON plo.`Investigation_ID`=im.`Investigation_Id` AND plo.test_id='" + Request.QueryString["TestID"].ToString() + "'");
            sb.Append(" INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=im.`Investigation_Id` AND li.`Child_Flag`=0");
            sb.Append(" INNER JOIN `labobservation_master` lom ON lom.`LabObservation_ID`=li.`labObservation_ID`");
            sb.Append(" LEFT JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`LabObservation_ID`=li.`labObservation_ID`");
            sb.Append(" LEFT OUTER JOIN   ( SELECT Reading ,Test_ID,LabObservation_ID, ");
            sb.Append(" LabNo FROM  mac_data WHERE LedgerTransactionNo='" + LabNo + "' AND Reading<>''  ");
            sb.Append("  GROUP BY Test_ID,LabObservation_ID ) mac ");
            sb.Append("  ON mac.Test_ID=plo.Test_ID  AND mac.LabObservation_ID= lom.LabObservation_ID  AND mac.LabNo = plo.`BarcodeNo`  ");
            sb.Append(" ORDER BY PrintOrder ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                lbtestname.Text = dt.Rows[0]["itemname"].ToString();
                datatable = dt;
            }
             
        }
    }
     [WebMethod]
    public static string Save(string ItemDetail, string resion, string TestID)
    {
        List<ItemData> result = new List<ItemData>();
        result = JsonConvert.DeserializeObject<List<ItemData>>(ItemDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string q1 = @"UPDATE patient_labinvestigation_opd SET ReRunReason='" + resion + "',Result_Flag=0,Approved=0,isHold=0,isForward=0,isrerun=1,ReRunDate=NOW(),ReRunByID='" + UserInfo.ID + "',ReRunByName='" + UserInfo.LoginName + "' WHERE test_id=" + TestID + "";

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q1);
            foreach (var item in result)
            { 
                    string q2 = "update patient_labobservation_opd set Rerun=1 where test_id='" + TestID + "' and labObservation_ID='" + item.labObservation_ID + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q2);

                    string q4 = "INSERT INTO patient_labobservation_opd_rerun(Test_ID,LedgerTransactionNo,LabObservation_ID,Value,UserId,Reason,BarcodeNo)VALUES('" + TestID + "','" + LabNo + "','" + item.labObservation_ID + "','" + item.Value + "','" + UserInfo.ID + "','" + resion + "','" + item.BarCodeNo + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q4);

                    string q3 = "update mac_data  set reading3=reading2,reading2=reading1,reading1=Reading, Reading='',RerunReason='" + resion + "' where test_id='" + TestID + "' and labObservation_ID='" + item.labObservation_ID + "'";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q3);
                   
                //string q3 = "update mac_data  set reading3=reading2,reading2=reading1,reading1=Reading, Reading='',RerunReason='" + resion + "' where test_id='" + TestID + "' and labObservation_ID='" + item.labObservation_ID + "'";
                    //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q3);
             }

            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb1.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb1.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('ReRun (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb1.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + TestID + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
           return ex.Message;
        }
    }
    public class ItemData
    {
        public bool Chk { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }
        public string labObservation_ID { get; set; }       
        public string BarCodeNo { get; set; }
    }
    //protected void Unnamed_Click(object sender, EventArgs e)
    //{
    //    lb.Text = "";
    //    int a = 0;
    //    foreach (GridViewRow grdd in grd.Rows)
    //    {
    //        CheckBox ckk = (CheckBox)grdd.FindControl("ch");
    //        if (ckk.Checked)
    //        {
    //            a = a + 1;
    //        }
    //    }

    //    if (a == 0)
    //    {
    //        lb.Text = "Please Select Parameter To Rerun";
    //        return;
    //    }

    //    if (txtreason.Text == "")
    //    {
    //        lb.Text = "Please Enter Reason";
    //        return;
    //    }
    //    MySqlConnection con = Util.GetMySqlCon();
    //    con.Open();
    //    MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
    //    try
    //    {
    //        string q1 = @"UPDATE patient_labinvestigation_opd SET ReRunReason='" + txtreason.Text + "',Result_Flag=0,Approved=0,isHold=0,isForward=0,isrerun=1,ReRunDate=NOW(),ReRunByID='" + UserInfo.ID + "',ReRunByName='" + UserInfo.LoginName + "' WHERE test_id=" + Request.QueryString["TestID"].ToString() + "";

    //        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q1);
    //        foreach (GridViewRow grdd in grd.Rows)
    //        {
    //            CheckBox ckk = (CheckBox)grdd.FindControl("ch");
    //            if (ckk.Checked)
    //            {
    //                Label lb1 = (Label)grdd.FindControl("label1");
    //                string q2 = "update patient_labobservation_opd set Rerun=1 where test_id='" + Request.QueryString["TestID"].ToString() + "' and labObservation_ID='" + lb1.Text + "'";
    //                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q2);

    //                string q3 = "update mac_data  set reading3=reading2,reading2=reading1,reading1=Reading, Reading='',RerunReason='" + txtreason.Text + "' where test_id='" + Request.QueryString["TestID"].ToString() + "' and labObservation_ID='" + lb1.Text + "'";
    //                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q3);
    //            }
    //        }

    //        StringBuilder sb1 = new StringBuilder();
    //        sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
    //        sb1.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
    //        sb1.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('ReRun (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
    //        sb1.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + Request.QueryString["TestID"].ToString() + "'");

    //        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
    //        tnx.Commit();
    //        tnx.Dispose();
    //        con.Close();
    //        con.Dispose();
    //        lb.Text = "Test Rerun Success";
    //    }
    //    catch (Exception ex)
    //    {
    //        tnx.Rollback();
    //        tnx.Dispose();
    //        con.Close();
    //        con.Dispose();
    //        ClassLog objerror = new ClassLog();
    //        objerror.errLog(ex);
    //        lb.Text = ex.Message;
    //    }

    //}

}