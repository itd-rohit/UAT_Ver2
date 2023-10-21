using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Design_FrontOffice_DoctorEdit : System.Web.UI.Page
{
    DataTable dtTime;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Resources.Resource.OPDHomeCollection == "0")
            Response.Redirect("../UnAuthorized.aspx");
        if (!IsPostBack)
        {
            txtName.Focus();

            bindAccessCentre();
            BindDetail();
            Bind();
            if(Request.QueryString["DID"]!="")
            {
                BindDoctorDetail(Request.QueryString["DID"]);
                ViewState["DID"] = Request.QueryString["DID"].ToString();
            }
        }
    }

   

    private void BindDoctorDetail(string DocID)
    {
       // DataTable dt = StockReports.GetDataTable(string.Format("select Doctor_ID,Title,Name,Specialization,Phone1,Mobile,Street_Name,DocType,ConsultantFee from doctor_master where Doctor_ID={0}",DocID));

        DataTable dt = StockReports.GetDataTable(string.Format("SELECT Doctor_ID,Title,NAME,Specialization,Phone1,dm.`Mobile`,Street_Name,Centre,DocType,ConsultantFee FROM doctor_master dm INNER JOIN  `centre_master`  cm  ON cm.`CentreID`=dm.`CentreId` where Doctor_ID={0}", DocID));
        if (dt.Rows.Count > 0)
        {          
            cmbTitle.SelectedIndex = cmbTitle.Items.IndexOf(cmbTitle.Items.FindByText(Util.GetString(dt.Rows[0]["Title"]).ToUpper()));
            txtName.Text = Util.GetString(dt.Rows[0]["Name"]);
            
            txtAdd.Text = Util.GetString(dt.Rows[0]["Street_Name"]);
            TxtMobileNo.Text = Util.GetString(dt.Rows[0]["Mobile"]);
            txtPhone1.Text = Util.GetString(dt.Rows[0]["Phone1"]);
            ddlSpecial.SelectedIndex = ddlSpecial.Items.IndexOf(ddlSpecial.Items.FindByText(Util.GetString(dt.Rows[0]["Specialization"])));

            ddlCentreAccess.SelectedIndex = ddlCentreAccess.Items.IndexOf(ddlCentreAccess.Items.FindByText(Util.GetString(dt.Rows[0]["Centre"])));
           
            txtfee.Text = Util.GetString(dt.Rows[0]["ConsultantFee"]);

          
            dt = StockReports.GetDataTable(string.Format("select * from doctor_hospital where doctor_id={0}",DocID));

            if (dt != null && dt.Rows.Count > 0)
            {
                cmbDept.SelectedIndex = cmbDept.Items.IndexOf(cmbDept.Items.FindByText(dt.Rows[0]["Department"].ToString()));
                ddlduration.SelectedIndex = ddlduration.Items.IndexOf(ddlduration.Items.FindByText(dt.Rows[0]["AvgTime"].ToString()));
                
                if (ViewState["dtTime"] != null)
                {
                    dtTime = ((DataTable)ViewState["dtTime"]);
                }

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dtTime = AddTime(dt.Rows[i]["Day"].ToString(), Util.GetDateTime(dt.Rows[i]["StartTime"]).ToString("hh:mmtt"), Util.GetDateTime(dt.Rows[i]["EndTime"]).ToString("hh:mmtt"), dt.Rows[i]["AvgTime"].ToString(), dtTime);
                }

                grdTime.DataSource = dtTime;
                grdTime.DataBind();

                string EndTime = dt.Rows[0]["EndTime"].ToString();
                txtRoomNo.Text = dt.Rows[0]["Room_No"].ToString();
                
                if (ViewState["dtTime"] != null)
                {
                    ViewState["dtTime"] = dtTime;
                }
                else
                {
                    ViewState.Add("dtTime", dtTime);
                }
            }   
            
        }
    }

    private DataTable AddTime(string Day, string StartTime, string EndTime, string AvgTime, DataTable dt)
    {
        if (dt == null)
        {
            dt = new DataTable();
            dt.Columns.Add("Day");
            dt.Columns.Add("StartTime");
            dt.Columns.Add("EndTime");
            dt.Columns.Add("AvgTime");
        }

        if (dt != null)
        {
            DataRow dr = dt.NewRow();
            dr["Day"] = Day;
            dr["StartTime"] = StartTime;
            dr["EndTime"] = EndTime;
            dr["AvgTime"] = AvgTime;
            dt.Rows.Add(dr);
        }
        return dt;
    }

    private void bindAccessCentre()
    {
        DataTable dt = AllLoad_Data.getCentreByLogin();
        ddlCentreAccess.DataSource = dt;
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();
        string da = DateTime.Now.ToString("yyyy-MM-dd hh:hh:hh");
    }


    private void BindDetail()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            ddlSpecial.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select TRIM(BOTH FROM NAME) Name from type_master where TypeID ='3' order by Name").Tables[0];
            ddlSpecial.DataTextField = "Name";
            ddlSpecial.DataValueField = "Name";
            ddlSpecial.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }


    }

    public void Bind()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            cmbDept.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select TRIM(BOTH FROM NAME) Name from type_master where TypeID ='5' order by Name").Tables[0];
            cmbDept.DataTextField = "Name";
            cmbDept.DataValueField = "Name";
            cmbDept.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
      
    }
    protected void  btnSave_Click(object sender, EventArgs e)
    {
        if (txtName.Text.Trim() == "")
        {
            lblerrmsg.Text = "Please Enter Doctor Name ...";
            txtName.Focus();
            return;
        }
        if (grdTime.Rows == null || grdTime.Rows.Count == 0)
        {
            lblerrmsg.Text = "Please Add Doctor's Timing ...";
            btntimings.Focus();
            return;
        }

        int iFlag = 0;

        if (chkMon.Checked == true || chkMon.Checked == true || chkTues.Checked == true || chkWed.Checked == true || chkThur.Checked == true || chkFri.Checked == true || chkSat.Checked == true || chkSun.Checked == true)
            iFlag = 1;

        if (grdTime.Rows.Count == 0 && iFlag == 0)
        {
            lblerrmsg.Text = "Please Specify Day of OPD Timings..";
            chkMon.Focus();
            return;
        }

        SaveDetail();
    }

    protected void btntimings_Click(object sender, EventArgs e)
    {
        try
        {
            lblerrmsg.Text = "";
            if (ViewState["dtTime"] != null)
            {
                dtTime = ((DataTable)ViewState["dtTime"]);
            }

            DateTime EndTime = Convert.ToDateTime(txtHr2.Text.Trim() + ":" + txtMin2.Text.Trim() + cmbAMPM2.SelectedItem.Text.Trim());
            DateTime StartTime = Convert.ToDateTime(txtHr1.Text.Trim() + ":" + txtMin1.Text.Trim() + cmbAMPM1.SelectedItem.Text.Trim());


            if (ViewState["dtTime"] != null)
            {
                string day = "";
                if (chkMon.Checked == true)
                {
                    day = "Monday";
                }
                else if (chkTues.Checked == true)
                {
                    day = "Tuesday";
                }
                else if (chkWed.Checked == true)
                {
                    day = "Wednesday";
                }
                else if (chkThur.Checked == true)
                {
                    day = "Thursday";
                }
                else if (chkFri.Checked == true)
                {
                    day = "Friday";
                }
                else if (chkSat.Checked == true)
                {
                    day = "Saturday";
                }
                else if (chkSun.Checked == true)
                {
                    day = "Sunday";
                }
                DataRow[] dr = dtTime.Select("Day='" + day + "' AND StartTime='" + StartTime.ToString("hh:mmtt") + "' AND EndTime='" + EndTime.ToString("hh:mmtt") + "'");

                if (dr.Length > 0)
                {
                    lblerrmsg.Text = "This Time already exits";
                    return;
                }
            }
            if (chkMon.Checked == true)
            {
                if (ValidateItems("Monday"))
                {
                    dtTime = AddTime("Monday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), dtTime);
                }
            }
            if (chkTues.Checked == true)
            {
                if (ValidateItems("Tuesday"))
                {
                    dtTime = AddTime("Tuesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), dtTime);
                }
            }
            if (chkWed.Checked == true)
            {
                if (ValidateItems("Wednesday"))
                {
                    dtTime = AddTime("Wednesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), dtTime);
                   
                }
            }
            if (chkThur.Checked == true)
            {
                if (ValidateItems("Thursday"))
                {
                    dtTime = AddTime("Thursday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), dtTime);
                  
                }
            }
            if (chkFri.Checked == true)
            {
                if (ValidateItems("Friday"))
                {
                    dtTime = AddTime("Friday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), dtTime);
                   
                }
            }
            if (chkSat.Checked == true)
            {
                if (ValidateItems("Saturday"))
                {
                    dtTime = AddTime("Saturday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), dtTime);
                   
                }
            }
            if (chkSun.Checked == true)
            {
                if (ValidateItems("Sunday"))
                {
                    dtTime = AddTime("Sunday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), ddlduration.SelectedValue.ToString().Trim(), dtTime);
                   
                }
            }

            grdTime.DataSource = dtTime;
            grdTime.DataBind();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private bool ValidateItems(string day)
    {
        foreach (DataRow row in dtTime.Rows)
        {
            if (row["Day"].ToString() == day)
            {
                return false;
                break;
            }
        }
        return true;
    }

    protected void SaveDetail()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        
        string returnStr="";
        string HospID = "SHHI";
        string Dept = cmbDept.SelectedItem.Text;

        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update doctor_master set Title=@Title,Name=@Name,Specialization=@Specialization,Phone1=@Phone1,Mobile=@Mobile,Street_Name=@Street_Name,ConsultantFee=@ConsultantFee,Centreid=@Centre where Doctor_ID=@Doctor_ID",
                new MySqlParameter("@Title", cmbTitle.SelectedItem.Text), new MySqlParameter("@Name", txtName.Text.Trim()), new MySqlParameter("@Specialization", ddlSpecial.SelectedItem.Text),
                 new MySqlParameter("@Phone1", txtPhone1.Text.Trim()), new MySqlParameter("@Mobile", TxtMobileNo.Text.Trim()), new MySqlParameter("@Street_Name", txtAdd.Text.Trim()), new MySqlParameter("@Centre", ddlCentreAccess.SelectedItem.Value),
                  new MySqlParameter("@ConsultantFee", txtfee.Text), new MySqlParameter("@Doctor_ID", ViewState["DID"].ToString()));
            ///Update Doctor Name in ItemMaster

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update f_configrelation c inner join f_subcategorymaster sc on sc.CategoryID = c.CategoryID inner join f_itemmaster im on im.SubCategoryID = sc.SubCategoryID  set im.TypeName =@TypeName where ConfigRelationID=5 and im.Type_ID=@Type_ID",
                new MySqlParameter("@TypeName", txtName.Text.Trim()), new MySqlParameter("@Type_ID",ViewState["DID"].ToString()));

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update f_ratelist rl  inner join f_itemmaster im on im.Itemid = rl.Itemid and rl.Panel_ID=81  inner join f_subcategorymaster sc on im.SubCategoryID = sc.SubCategoryID and sc.CategoryID ='LSHHI7'  set rl.Rate =@Rate where  im.Type_ID=@Type_ID",
               new MySqlParameter("@Rate", txtfee.Text.Trim()==""?"0":txtfee.Text.Trim()), new MySqlParameter("@Type_ID", ViewState["DID"].ToString()));

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from doctor_hospital where Doctor_ID=@Doctor_ID",
             new MySqlParameter("@Doctor_ID", ViewState["DID"].ToString()));
            
            if (grdTime.Rows.Count == 0)
            {
                DateTime EndTime = Convert.ToDateTime(txtHr2.Text.Trim() + ":" + txtMin2.Text.Trim() + cmbAMPM2.SelectedItem.Text.Trim());
                DateTime StartTime = Convert.ToDateTime(txtHr1.Text.Trim() + ":" + txtMin1.Text.Trim() + cmbAMPM1.SelectedItem.Text.Trim());
                int AvgTime = Convert.ToInt32(ddlduration.SelectedValue.ToString().Trim());
                
                if (chkMon.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Monday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
                }
                if (chkTues.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Tuesday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
                }
                if (chkWed.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Wednesday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
                }
                if (chkThur.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Thursday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
                }
                if (chkFri.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Friday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
                }
                if (chkSat.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Saturday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
                }
                if (chkSun.Checked == true)
                {
                    returnStr = saveData(ViewState["DID"].ToString(), "Sunday", HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
                }
            }

            else
            {
                for (int i = 0; i < grdTime.Rows.Count; i++)
                {
                    DateTime EndTime = Util.GetDateTime(grdTime.Rows[i].Cells[2].Text);
                    DateTime StartTime = Util.GetDateTime(grdTime.Rows[i].Cells[1].Text);
                    string Day = grdTime.Rows[i].Cells[0].Text;
                    int AvgTime = Convert.ToInt32(grdTime.Rows[i].Cells[3].Text.ToString().Trim());

                    returnStr = saveData(ViewState["DID"].ToString(), Day, HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
                   
                }
            }
            tranX.Commit();
            con.Close();
            con.Dispose();
            ClearFields();
            lblerrmsg.Text = "Record Updated Succesfully";
            
        }


        catch (Exception ex)
        {
             ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Rollback();
            con.Close();
            con.Dispose();
            lblerrmsg.Text = "Record Not Saved ..";
            return;
        }
    }

    private string saveData(string DID, string Day, string HospID, DateTime StartTime, DateTime EndTime, string Roomno, string Dept, int avgtime, MySqlTransaction Trans)
    {
        DoctorReg objDocOPD = new DoctorReg();
        string returnStr = objDocOPD.SaveDocOPD(DID, HospID, Day, StartTime, EndTime, Roomno, Dept, avgtime, Trans);
        return "";
    }

    protected void grdTime_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        if (ViewState["dtTime"] != null)
        {
            dtTime = ((DataTable)ViewState["dtTime"]);
        }

        string Day = dtTime.Rows[e.RowIndex]["Day"].ToString();

        switch (Day)
        {
            case "Monday":
                chkMon.Checked = false;
                break;
            case "Tuesday":
                chkTues.Checked = false;
                break;
            case "Wednesday":
                chkWed.Checked = false;
                break;
            case "Thursday":
                chkThur.Checked = false;
                break;
            case "Friday":
                chkFri.Checked = false;
                break;
            case "Saturday":
                chkSat.Checked = false;
                break;
            case "Sunday":
                chkSun.Checked = false;
                break;
        }

        dtTime.Rows.RemoveAt(e.RowIndex);
        ViewState["dtTime"] = dtTime as DataTable;
        grdTime.DataSource = dtTime;
        grdTime.DataBind();

        DataRow[] drDay = dtTime.Select("Day='" + Day + "'");
        if (drDay.Length > 0)
        {
            switch (Day)
            {
                case "Monday":
                    chkMon.Checked = true;
                    break;
                case "Tuesday":
                    chkTues.Checked = true;
                    break;
                case "Wednesday":
                    chkWed.Checked = true;
                    break;
                case "Thursday":
                    chkThur.Checked = true;
                    break;
                case "Friday":
                    chkFri.Checked = true;
                    break;
                case "Saturday":
                    chkSat.Checked = true;
                    break;
                case "Sunday":
                    chkSun.Checked = true;
                    break;
            }
        }
    }

    private void ClearFields()
    {
        txtfee.Text = "";
        txtAdd.Text = "";
        txtHr1.Text = "";
        txtHr2.Text = "";
        txtMin1.Text = "";
        txtMin2.Text = "";
        TxtMobileNo.Text = "";
        txtName.Text = "";
        txtPhone1.Text = "";
        txtRoomNo.Text = "";

        ddlSpecial.SelectedIndex = 0;
        cmbTitle.SelectedIndex = 0;
        if (chkMon.Checked || chkTues.Checked || chkWed.Checked || chkThur.Checked || chkFri.Checked || chkSat.Checked || chkSun.Checked)
        {

            chkMon.Checked = false;
            chkTues.Checked = false;
            chkWed.Checked = false;
            chkThur.Checked = false;
            chkFri.Checked = false;
            chkSat.Checked = false;
            chkSun.Checked = false;
        }

        grdTime.DataSource = null;
        grdTime.DataBind();

        ViewState["dtTime"] = null;

    }

}
   
   

    

    

    

   
        

