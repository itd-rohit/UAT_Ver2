using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ShowRerun : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('masterheaderid').style.display='none';", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch12", "document.getElementById('mastertopcorner').style.display='none';", true);

        if (!IsPostBack)
        {
            lbmsg.Text = "";
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT itemname,lom.`Name`,li.`labObservation_ID`,li.`Child_Flag`, IFNULL(IFNULL(ploo.Value,mac.Reading),'') VALUE,plo.BarCodeNo ");
            sb.Append("  FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN investigation_master im ON plo.`Investigation_ID`=im.`Investigation_Id` AND plo.test_id='" + Request.QueryString["TestID"].ToString() + "'");
            sb.Append(" INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=im.`Investigation_Id` AND li.`Child_Flag`=0");
            sb.Append(" INNER JOIN `labobservation_master` lom ON lom.`LabObservation_ID`=li.`labObservation_ID`");
            sb.Append(" LEFT JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`LabObservation_ID`=li.`labObservation_ID`");
            sb.Append(" LEFT OUTER JOIN   ( SELECT Reading ,Test_ID,LabObservation_ID, ");
            sb.Append(" LabNo FROM  mac_data WHERE LedgerTransactionNo='" + Request.QueryString["LabNo"].ToString() + "' AND Reading<>''  ");
            sb.Append("  GROUP BY Test_ID,LabObservation_ID ) mac ");
            sb.Append("  ON mac.Test_ID=plo.Test_ID  AND mac.LabObservation_ID= lom.LabObservation_ID  AND mac.LabNo = plo.`BarcodeNo`  ");
            sb.Append(" ORDER BY PrintOrder ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                lbtestname.Text = dt.Rows[0]["itemname"].ToString();
                grd.DataSource = dt;
                grd.DataBind();
            }
            else
            {
                lbmsg.Text = "No Parameter To Rerun";
                grd.DataSource = "";
                grd.DataBind();
            }
        }
    }
    protected void chheade_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ck = (CheckBox)sender;
        foreach (GridViewRow grdd in grd.Rows)
        {
            CheckBox ckk = (CheckBox)grdd.FindControl("ch");
            ckk.Checked = ck.Checked;
        }
    }
    protected void Unnamed_Click(object sender, EventArgs e)
    {
        lb.Text = "";
        int a = 0;
        foreach (GridViewRow grdd in grd.Rows)
        {
            CheckBox ckk = (CheckBox)grdd.FindControl("ch");
            if (ckk.Checked)
            {
                a = a + 1;
            }
        }

        if (a == 0)
        {
            lb.Text = "Please Select Parameter To Rerun";
            return;
        }

        if (txtreason.Text == "")
        {
            lb.Text = "Please Enter Reason";
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string q1 = @"UPDATE patient_labinvestigation_opd SET ReRunReason='"+txtreason.Text+"',Result_Flag=0,Approved=0,isHold=0,isForward=0,isrerun=1,ReRunDate=NOW(),ReRunByID='" + UserInfo.ID + "',ReRunByName='" + UserInfo.LoginName + "' WHERE test_id=" + Request.QueryString["TestID"].ToString() + "";

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q1);
            foreach (GridViewRow grdd in grd.Rows)
            {
                CheckBox ckk = (CheckBox)grdd.FindControl("ch");
                if (ckk.Checked)
                {
Label lb1 = (Label)grdd.FindControl("label1");
                    DataTable dtMac = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT * FROM mac_data  where test_id='" + Request.QueryString["TestID"].ToString() + "' and labObservation_ID='" + lb1.Text + "' and Reading!='' AND CentreID='" + UserInfo.Centre + "' AND Status='Receive' ;").Tables[0];
                    if (dtMac.Rows.Count > 0)
                    {

                        
                        string q2 = "update patient_labobservation_opd set Rerun=1 where test_id='" + Request.QueryString["TestID"].ToString() + "' and labObservation_ID='" + lb1.Text + "'";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q2);

                        string q4 = "INSERT INTO patient_labobservation_opd_rerun(Test_ID,LedgerTransactionNo,LabObservation_ID,Value,UserId,Reason,BarcodeNo)VALUES('" + Request.QueryString["TestID"].ToString() + "','" + Request.QueryString["LabNo"].ToString() + "','" + lb1.Text + "','" + ((Label)grdd.FindControl("lblValue")).Text + "','" + UserInfo.ID + "','" + txtreason.Text.Trim() + "','" + ((Label)grdd.FindControl("lblBarCodeNo")).Text + "')";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q4);


                        StringBuilder sb = new StringBuilder();
                        sb.Append(" INSERT INTO mac_data(centreid,LabNo,LabObservation_ID,Reading,machineid,RerunReason,reading1,machineid1,RerunReason1,reading2,machineid2,RerunReason2,reading3,machineid3,RerunReason3,dtEntry,PName,Age,Gender,MachineName,Test_id,BarcodeNo,LedgerTransactionNo,InvestigationName,LabObservationName,Temprature,VialID,STATUS)");
                        sb.Append(" value ");
                        sb.Append(" ('" + dtMac.Rows[0]["centreid"] + "','" + dtMac.Rows[0]["LabNo"] + "','" + dtMac.Rows[0]["LabObservation_ID"] + "',");
                        sb.Append("'',"); // Reading, 
                        sb.Append("'',"); // machineid

                        sb.Append("'" + txtreason.Text + "',"); //RerunReason,
                        sb.Append("'" + dtMac.Rows[0]["Reading"] + "',"); // reading1
                        sb.Append("'" + dtMac.Rows[0]["machineid"] + "',"); //,machineid1,
                        sb.Append("'" + txtreason.Text + "',"); // RerunReason1

                        sb.Append("'" + dtMac.Rows[0]["reading1"] + "',"); // reading2
                        sb.Append("'" + dtMac.Rows[0]["machineid1"] + "',"); //,machineid2,
                        sb.Append("'" + dtMac.Rows[0]["RerunReason1"] + "',"); // RerunReason2

                        sb.Append("'" + dtMac.Rows[0]["reading2"] + "',"); // reading3
                        sb.Append("'" + dtMac.Rows[0]["machineid2"] + "',"); //,machineid3,
                        sb.Append("'" + dtMac.Rows[0]["RerunReason2"] + "',"); // RerunReason3

                        sb.Append("'" + dtMac.Rows[0]["dtEntry"] + "',"); //dtEntry
                        sb.Append("'" + dtMac.Rows[0]["PName"] + "',"); //PName
                        sb.Append("'" + dtMac.Rows[0]["Age"] + "',"); //Age
                        sb.Append("'" + dtMac.Rows[0]["Gender"] + "',"); //Gender
                        sb.Append("'" + dtMac.Rows[0]["MachineName"] + "',"); //MachineName
                        sb.Append("'" + dtMac.Rows[0]["Test_id"] + "',"); //Test_id
                        sb.Append("'" + dtMac.Rows[0]["BarcodeNo"] + "',"); //BarcodeNo
                        sb.Append("'" + dtMac.Rows[0]["LedgerTransactionNo"] + "',"); //LedgerTransactionNo
                        sb.Append("'" + dtMac.Rows[0]["InvestigationName"] + "',"); //InvestigationName
                        sb.Append("'" + dtMac.Rows[0]["LabObservationName"] + "',"); //LabObservationName
                        sb.Append("'" + dtMac.Rows[0]["Temprature"] + "',"); //Temprature
                        sb.Append("'" + dtMac.Rows[0]["VialID"] + "',"); //VialID
                        sb.Append("'" + dtMac.Rows[0]["STATUS"] + "');"); //STATUS

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                      //  int _maxID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(ID)+1 FROM mac_data"));

                      //  string q3 = "update mac_data  set ID=" + _maxID + ", reading3=reading2,reading2=reading1,reading1=Reading, Reading='',RerunReason='" + txtreason.Text + "' where test_id='" + Request.QueryString["TestID"].ToString() + "' and labObservation_ID='" + lb1.Text + "' and Reading!=''";
                        string q3 = " delete from mac_data where id = " + dtMac.Rows[0]["id"];

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q3);
                    }

                }
            }

            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb1.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb1.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('ReRun (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb1.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + Request.QueryString["TestID"].ToString() + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            lb.Text = "Test Rerun Success";
        }
        catch(Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            lb.Text = ex.Message;
        }
       
    }
}