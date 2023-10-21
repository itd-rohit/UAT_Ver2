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

public partial class Design_FrontOffice_DoctorReg : System.Web.UI.Page
{
    DataTable dtSlot, dtTime;
    DataTable dtSpecialization;
    string returnStr;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Resources.Resource.OPDHomeCollection == "0")
            Response.Redirect("../UnAuthorized.aspx");
            if (!IsPostBack)
            {
                txtName.Focus();                
                BindDetail();
                Bind();
                bindAccessCentre();
            }
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
    private void SaveDoctorReg()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        string HospID = "SHHI"; 
        string Dept = cmbDept.SelectedItem.Text;
        try
        {
            DoctorMaster objDoctorMaster = new DoctorMaster(tranX);
            objDoctorMaster.Title = cmbTitle.SelectedItem.Text.Trim();
            objDoctorMaster.Name = txtName.Text.Trim();
            objDoctorMaster.Phone1 = txtPhone1.Text.Trim();
            objDoctorMaster.Mobile = TxtMobileNo.Text.Trim();
            objDoctorMaster.Street_Name = txtAdd.Text.Trim();
            objDoctorMaster.Specialization = ddlSpecial.SelectedItem.Text.Trim();
            objDoctorMaster.DoctorTime = UpdateDoctorTiming();
          //  objDoctorMaster.CentreID = UserInfo.Centre;//ddlCentreAccess
            objDoctorMaster.CentreID = Convert.ToInt32(ddlCentreAccess.SelectedItem.Value);
            objDoctorMaster.ConsultantFee = txtfee.Text;
            string DID = objDoctorMaster.Insert();

            DataTable dtSubCategoryID = DoctorReg.LoadSubCategoryByCategory(DoctorReg.LoadCategoryByConfigRelationID("5"));

            foreach (DataRow dw in dtSubCategoryID.Rows)
            {
                ItemMaster im = new ItemMaster(tranX);

                im.SubCategoryID = Convert.ToInt16(dw["SubCategoryID"].ToString());
                im.Type_ID = Convert.ToInt16(DID); ;
                im.TypeName = txtName.Text.Trim();
                im.CreaterID = UserInfo.ID;
                string itemid = im.Insert();

                //MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_ratelist where itemid=@itemid and Panel_ID='81'",
                //    new MySqlParameter("@itemid", itemid));

                RateList objRate = new RateList(tranX);
                objRate.Rate = Util.GetInt(txtfee.Text);
                objRate.ItemID = Convert.ToInt16(itemid);
                objRate.IsCurrent = Util.GetInt(1);
                objRate.Panel_ID = 78;
                string IsUpdate = objRate.Insert();
            }

            for (int i = 0; i < grdTime.Rows.Count; i++)
            {
                DateTime EndTime = Util.GetDateTime(grdTime.Rows[i].Cells[2].Text);
                DateTime StartTime = Util.GetDateTime(grdTime.Rows[i].Cells[1].Text);
                string Day = grdTime.Rows[i].Cells[0].Text;
                int AvgTime = Convert.ToInt32(grdTime.Rows[i].Cells[3].Text.ToString().Trim());
                returnStr = saveData(DID, Day, HospID, StartTime, EndTime, Util.GetString(txtRoomNo.Text), Dept, AvgTime, tranX);
            }
            tranX.Commit();
            con.Close();
            con.Dispose();
            ClearFields();
            lblerrmsg.Text = "Record Saved Succesfully";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            con.Close();
            con.Dispose();
            lblerrmsg.Text = "Record Not Saved ..";
            return;
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtName.Text.Trim() == "")
        {
            lblerrmsg.Text = "Please Enter Doctor Name ...";
            txtName.Focus();
            return;
        }
        if (grdTime.Rows.Count == 0)
        {
            lblerrmsg.Text = "Please Specify Day of OPD Timings..";
            chkMon.Focus();
            return;
        }

        SaveDoctorReg();
    }
    private void BindDetail()
    {
        DoctorReg obj = new DoctorReg();

        ddlSpecial.DataSource = obj.getSpecializationList();
        ddlSpecial.DataTextField = "Name";
        ddlSpecial.DataValueField = "Name";
        ddlSpecial.DataBind();
    }

    private void DataTableSlot()
    {
        dtSlot = new DataTable();
        dtSlot.Columns.Add("SlotNo");
        dtSlot.Columns.Add("StartTime");
    }
    
    private string saveData(string DID, string Day, string HospID, DateTime StartTime, DateTime EndTime, string Roomno,string Dept,int avgtime, MySqlTransaction Trans)
    {
        DoctorReg objDocOPD = new DoctorReg();
       string returnStr = objDocOPD.SaveDocOPD(DID, "1", Day, StartTime, EndTime, Roomno, Dept, avgtime, Trans);
        return "";
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

    private string UpdateDoctorTiming()
    {

        DateTime EndTim = Convert.ToDateTime(txtHr2.Text.Trim() + ":" + txtMin2.Text.Trim() + cmbAMPM2.SelectedItem.Text.Trim());
        DateTime StartTim = Convert.ToDateTime(txtHr1.Text.Trim() + ":" + txtMin1.Text.Trim() + cmbAMPM1.SelectedItem.Text.Trim());
        string Etime = EndTim.ToShortTimeString();
        string Stime = StartTim.ToShortTimeString();
        string Day = "";
        if (chkMon.Checked == true)
        {
            Day = "Mon" + ",";
        }
        if (chkTues.Checked == true)
        {
            Day += "Tue" + ",";
        }
        if (chkWed.Checked == true)
        {
            Day += "Wed" + ",";
        }
        if (chkThur.Checked == true)
        {
            Day += "Thur" + ",";
        }
        if (chkFri.Checked == true)
        {
            Day += "Fri" + ",";
        }

        if (chkSat.Checked == true)
        {
            Day += "Sat" + ",";
        }
        if (chkSun.Checked == true)
        {
            Day += "Sun" + ",";
        }

        if (Day == "" && grdTime.Rows.Count > 0)
        {
            foreach (GridViewRow row in grdTime.Rows)
            {
                Day += row.Cells[0].Text.Substring(0,3) + ",";
            }
        }

        int userlength = Day.Length - 1;
        Day = Day.Remove(userlength, 1);
        Day += "  " + Stime + "-" + Etime;
        return Day;
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
            string avgtime = ddlduration.SelectedValue.ToString().Trim();

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
                dtTime = AddTime("Monday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"),avgtime, dtTime);
            }
            if (chkTues.Checked == true)
            {
                dtTime = AddTime("Tuesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, dtTime);
               
            }
            if (chkWed.Checked == true)
            {
                dtTime = AddTime("Wednesday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, dtTime);
                
            }
            if (chkThur.Checked == true)
            {
                dtTime = AddTime("Thursday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, dtTime);
                
            }
            if (chkFri.Checked == true)
            {
                dtTime = AddTime("Friday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, dtTime);
                
            }
            if (chkSat.Checked == true)
            {
                dtTime = AddTime("Saturday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, dtTime);
                
            }
            if (chkSun.Checked == true)
            {
                dtTime = AddTime("Sunday", StartTime.ToString("hh:mmtt"), EndTime.ToString("hh:mmtt"), avgtime, dtTime);
                
            }

            if (ViewState["dtTime"] != null)
            {
                ViewState["dtTime"] = dtTime;
            }
            else
            {
                ViewState.Add("dtTime", dtTime);
            }

            chkMon.Checked = false;
            chkTues.Checked = false;
            chkWed.Checked = false;
            chkThur.Checked = false;
            chkFri.Checked = false;
            chkSat.Checked = false;
            chkSun.Checked = false;

            grdTime.DataSource = dtTime;
            grdTime.DataBind();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private DataTable AddTime(string Day, string StartTime, string EndTime,string AvgTime, DataTable dt)
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

        txtAdd.Text = "";
        txtHr1.Text = "";
        txtHr2.Text = "";
        txtMin1.Text = "";
        txtMin2.Text = "";
        TxtMobileNo.Text = "";
        txtName.Text = "";
        txtPhone1.Text = "";
        txtRoomNo.Text = "";
        txtfee.Text = "";
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
