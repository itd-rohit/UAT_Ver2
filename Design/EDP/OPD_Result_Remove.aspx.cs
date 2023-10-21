using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_OPD_Result_Remove : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = "";
            if (Request.QueryString["LabNo"] != null)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch", "document.getElementById('ctl00_ContentPlaceHolder1_txtRecipt').value='" + Request.QueryString["LabNo"].ToString() + "';document.getElementById('ctl00_ContentPlaceHolder1_btnSearch').click();", true);
            }
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (txtRecipt.Text.Trim() != "")
        {
            Search();
        }
        else
        {
            lblMsg.Text = "Please Enter The Lab No.......";
        }
    }

    private void Search()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        try
        {
            string LedgerTransactionNO = txtRecipt.Text.Trim();
            sb.Append(" SELECT dm.Name Doctor, lt.Panel_ID,dm.Doctor_ID, ");
            sb.Append(" lt.Adjustment,lt.netamount,lt.typeoftnx,pm.PName,IF(pm.DOB='0001-01-01',pm.Age,DATE_FORMAT(pm.DOB,'%d-%b-%Y'))DOB, ");
            sb.Append(" pm.Patient_ID , lt.LedgerTransactionNo,lt.Doctor_ID ReferedBy,'' Source,'' OtherDr ");
            sb.Append(" ,pnl.Company_Name Panel, IF(lt.IsCredit=1,'Credit','Non-Credit')TYPE  FROM ");
            sb.Append(" (SELECT Adjustment,netamount,typeoftnx,Panel_ID,LedgerTransactionNo,Doctor_ID,IsCredit,Patient_ID ");
            sb.Append(" FROM f_ledgertransaction WHERE LedgerTransactionNO=@LedgerTransactionNO) lt ");
            sb.Append(" INNER JOIN doctor_referal dm ON dm.Doctor_ID = lt.Doctor_ID ");
            sb.Append(" INNER JOIN patient_master pm ON lt.Patient_ID =pm.Patient_ID ");
            sb.Append(" INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID ");

            using (dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionNO", LedgerTransactionNO)).Tables[0])

                if (dt != null && dt.Rows.Count > 0)
                {
                    lblAmount.Text = Util.GetString(dt.Rows[0]["Adjustment"]);
                    string CRNO = Util.GetString(dt.Rows[0]["Patient_ID"]);
                    lblCRNumber.Text = CRNO.Replace("LSHHI", "");
                    //lblCRNumber.Attributes["Transaction_ID"] = Util.GetString(dt.Rows[0]["Transaction_ID"]);
                    lbllabno.Text = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);
                    lbltypetnx.Text = Util.GetString(dt.Rows[0]["typeoftnx"]);
                    lblPanel.Text = Util.GetString(dt.Rows[0]["Panel"]);
                    lblType.Text = Util.GetString(dt.Rows[0]["TYPE"]);
                    lblNetAmt.Text = Util.GetString(dt.Rows[0]["netamount"]);
                    lblDOB.Text = Util.GetString(dt.Rows[0]["DOB"]);
                    lblName.Text = Util.GetString(dt.Rows[0]["PName"]);
                    lblDoctor.Text = Util.GetString(dt.Rows[0]["Doctor"]);
                    lblDoctor.Attributes["Doctor_ID"] = Util.GetString(dt.Rows[0]["Doctor_ID"]);
                    lblDoctor.Attributes["Panel_ID"] = Util.GetString(dt.Rows[0]["Panel_ID"]);
                    lblDoctor.Attributes["ReferedBy"] = Util.GetString(dt.Rows[0]["ReferedBy"]);
                    lblDoctor.Attributes["Source"] = Util.GetString(dt.Rows[0]["Source"]);
                    //lblDoctor.Attributes["OtherDr"] = Util.GetString(dt.Rows[0]["OtherDr"]);
                    lblCRNumber.Attributes["LedgerTransactionNo"] = Util.GetString(dt.Rows[0]["LedgerTransactionNo"]);

                    sb = new StringBuilder();
                    sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE,inv.Name ItemName,inv.Investigation_Id ,pli.test_id as TestID, ");
                    sb.Append(" lt.LedgerTransactionNo, pli.Test_ID ItemID,Result_Flag,Approved,pli.IsSampleCollected,pli.isPrint, ");
                    sb.Append(" CASE   WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' ");
                    sb.Append(" WHEN pli.isFOReceive='1' THEN '#E9967A' ");
                    sb.Append(" WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF' ");
                    sb.Append(" WHEN pli.isFOReceive='0' AND pli.Approved='1'  THEN '#90EE90' ");
                    sb.Append(" WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R'  THEN '#FFC0CB' ");
                    sb.Append(" WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='1'  THEN '#A9A9A9' ");
                    sb.Append(" WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='1' THEN '#3399FF' ");
                    sb.Append(" WHEN pli.Result_Flag='0' ");
                    sb.Append(" AND (SELECT COUNT(*) FROM mac_data mac WHERE mac.labno=pli.LedgerTransactionNO AND mac.Test_ID=pli.Test_ID ");
                    sb.Append(" AND IFNULL(Reading,'')<>'')>0 THEN '#E2680A' ");
                    sb.Append(" WHEN pli.isHold='1' THEN '#FFFF00' WHEN pli.IsSampleCollected='N'  OR pli.IsSampleCollected='S' THEN '#CC99FF' ");
                    sb.Append(" WHEN pli.IsSampleCollected='R' THEN '#B0C4DE' ELSE '#FFFFFF' END rowColor ");
                    sb.Append(" FROM ");
                    sb.Append(" (SELECT LedgerTransactionNo,Date FROM  f_ledgertransaction WHERE LedgerTransactionNo = @LedgerTransactionNo ) lt ");
                    sb.Append(" INNER JOIN patient_labinvestigation_opd pli ON lt.LedgerTransactionNo = pli.LedgerTransactionNo AND pli.ReportType=1 ");
                    sb.Append(" INNER JOIN investigation_master inv ON inv.Investigation_Id=pli.Investigation_Id ");

                    using (dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNO)).Tables[0])

                        grdItemRate.DataSource = dt;

                    grdItemRate.DataBind();

                    if (dt.Rows.Count > 0)
                    {
                        btnSave.Visible = true;
                    }
                    else
                    {
                        btnSave.Visible = false;
                    }
                }
                else
                {
                    lblAmount.Text = "";
                    lblCRNumber.Text = "";
                    lblDOB.Text = "";
                    lblName.Text = "";
                    lblMsg.Text = "Record Not Found";
                    grdItemRate.DataSource = null;
                    grdItemRate.DataBind();
                }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            return;
        }
    }

    protected void grdItemRate_RowCommand(object sender, GridViewCommandEventArgs e)
    {
    }

    protected void grdItemRate_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblPrint")).Text == "1" && ((Label)e.Row.FindControl("lblapprove")).Text == "1" && ((Label)e.Row.FindControl("lblresult")).Text == "1" && ((Label)e.Row.FindControl("lblSampleColl")).Text == "Y")
            {
                e.Row.BackColor = System.Drawing.Color.SkyBlue;
                ((CheckBox)e.Row.FindControl("chkItem")).Visible = true;
            }
            if (((Label)e.Row.FindControl("lblapprove")).Text == "1" && ((Label)e.Row.FindControl("lblresult")).Text == "1" && ((Label)e.Row.FindControl("lblSampleColl")).Text == "Y")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
                ((CheckBox)e.Row.FindControl("chkItem")).Visible = true;
            }
            if (((Label)e.Row.FindControl("lblresult")).Text == "1" && ((Label)e.Row.FindControl("lblapprove")).Text == "0" && ((Label)e.Row.FindControl("lblSampleColl")).Text == "Y")
            {
                e.Row.BackColor = System.Drawing.Color.Pink;
                ((CheckBox)e.Row.FindControl("chkItem")).Visible = true;
            }

            if (((Label)e.Row.FindControl("lblresult")).Text == "0" && ((Label)e.Row.FindControl("lblapprove")).Text == "0" && ((Label)e.Row.FindControl("lblSampleColl")).Text == "Y")
            {
                e.Row.BackColor = System.Drawing.Color.White;
                ((CheckBox)e.Row.FindControl("chkItem")).Visible = true;
            }
            if (((Label)e.Row.FindControl("lblresult")).Text == "0" && ((Label)e.Row.FindControl("lblapprove")).Text == "0" && ((Label)e.Row.FindControl("lblSampleColl")).Text == "N")
            {
                e.Row.BackColor = System.Drawing.Color.Violet;
                ((CheckBox)e.Row.FindControl("chkItem")).Visible = false;
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtRecipt.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter the Lab No";
            return;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            for (int i = 0; i < grdItemRate.Rows.Count; i++)
            {
                if (i >= 0)
                {
                    if (((CheckBox)grdItemRate.Rows[i].FindControl("chkItem")).Checked)
                    {
                        string Item = "UPDATE patient_labinvestigation_opd SET Result_Flag=0,Approved=0,IsSampleCollected='N',MacStatus=0 WHERE Test_ID=@Test_ID ";
                        string strMacData = "Delete FROM mac_data WHERE test_id=@test_id and Reading<>''";
                        string strPtObservation = "Delete FROM patient_labobservation_opd WHERE test_id=@test_id ";

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Item,
                            new MySqlParameter("@Test_ID", ((Label)grdItemRate.Rows[i].FindControl("lblItem")).Text));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strMacData,
                            new MySqlParameter("@test_id", ((Label)grdItemRate.Rows[i].FindControl("lblTestID")).Text));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strPtObservation,
                            new MySqlParameter("@test_id", ((Label)grdItemRate.Rows[i].FindControl("lblTestID")).Text));

                        tnx.Commit();
                        lblMsg.Text = "Result Remove Successfully ..";
                        Search();
                    }
                }
                else
                {
                    lblMsg.Text = "Please Select the Investigation";
                }
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            tnx.Rollback();
            return;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grdItemRate_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
}