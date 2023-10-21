using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_FrontOffice_DoctorReferal : System.Web.UI.Page
{
    private string DocID = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            

            AllLoad_Data.bindAllCentre(ddlCenter, null, null);
            ddlCenter.Items.Insert(0, new ListItem("", "0"));
            

            BindPRO();

            if (Request.QueryString["DocID"] != null)
            {
                DocID = Request.QueryString["DocID"];
                Div1.Visible = false;
                BindInvestigation();
                grdInv.SelectedIndex = 0;
                grdInv_SelectedIndexChanged(grdInv, null);
            }
        }
        txtDob.Attributes.Add("readOnly", "true");
        txtAnniversary.Attributes.Add("readOnly", "true");
    }

    private void BindPRO()
    {
        DataTable dt = StockReports.GetDataTable("SELECT PROID,PROName FROM pro_master WHERE IsActive=1 order by PROName");
        ddlPRO.DataSource = dt;
        ddlPRO.DataTextField = "PROName";
        ddlPRO.DataValueField = "PROID";
        ddlPRO.DataBind();
        ddlPRO.Items.Insert(0, new ListItem("Select", "0"));
    //DataTable dt = StockReports.GetDataTable("SELECT `Employee_ID` PROID, NAME PROName FROM `employee_master`  WHERE `Designation`='pro' AND `isactive`=1");
    //    ddlPRO.DataSource = dt;
    //    ddlPRO.DataTextField = "PROName";
    //    ddlPRO.DataValueField = "PROID";
    //    ddlPRO.DataBind();
    //    ddlPRO.Items.Insert(0, new ListItem("Select", "0"));
    }
    private void BindDegree()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID, Degree from f_degreemaster order by degree");
        ddlDegree.DataSource = dt;
        ddlDegree.DataTextField = "Degree";
        ddlDegree.DataValueField = "ID";
        ddlDegree.DataBind();
        ddlDegree.Items.Insert(0, " ");
    }

    private DataTable Search()
    {
        int isActive = 0;
        if (chkSearchIsActive.Checked == true)
        {
            isActive = 1;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT (select proname from pro_master where proid=dr.proid limit 1) Proname,CASE allowsharing WHEN '1' THEN 'Yes' WHEN '2' THEN 'Gift' ELSE 'No' END IpType,dr.category, dr.ProfesionalSummary, dr.Title, dr.Degree, dr.AreaName,dr.ClinicAddress,dr.ClinicName,dr.HospitalName,dr.HospitalAddress,dr.Phone2,dr.Email,dr.Name,dr.Phone1,dr.Street_Name,Mobile,dr.Specialization, dr.Doctor_ID,dr.ProID,dr.IsVisible,if(dr.ReferMasterShare=1,'Yes','No') as ReferMasterShare,if(dr.isReferal=1,'Yes','No') as isReferal,dr.allowsharing,dr.discountapproved,dr.UserName,dr.IsActive,if(IsActive=1,'Yes','No') as Active,dr.category,doctortype,visitday,dr.Address1, ");
            sb.Append(" dr.Address2,IF(dr.Doctor_ID=dr.doctorgroup,'Master','Slave')DocType,dr.DoctorCode,dr.State,dr.City,dr.Locality,dr.ZoneID FROM  doctor_referal dr where dr.name <>''  ");

            if (txtDoctorName.Text != "")
            {
                sb.Append(" and  dr.NAME like @docname ");
            }
            if (txtMobileNo.Text != "")
            {
                sb.Append(" and  dr.Mobile like @mobile ");
            }

            sb.Append(" and IsActive=@isActive ");

            if (ddlCenter.SelectedIndex > 0)
            {
                sb.Append(" AND CentreID = @center");
            }
            if (DocID != "")
            {
                sb.Append(" and dr.Doctor_id=  @DocID");
            }
            sb.Append(" and doctorType=@doctype");
            sb.Append(" order by Name");
            return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@docname", string.Concat("%", txtDoctorName.Text.Trim(), "%")), new MySqlParameter("@mobile", string.Concat("%", txtMobileNo.Text.Trim(), "%"))
                , new MySqlParameter("@isActive", isActive), new MySqlParameter("@center", ddlCenter.SelectedValue), new MySqlParameter("@DocID", DocID)
                , new MySqlParameter("@doctype", ddldoctortype.SelectedValue)).Tables[0];
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
	
	 public void GetReportData()
    {
        int isActive = 0;
        if (chkSearchIsActive.Checked == true)
        {
            isActive = 1;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT dr.Name AS 'Doctor Name',dr.`Mobile`,(SELECT proname FROM pro_master WHERE proid = dr.proid LIMIT 1) ProName,dr.Degree,IF(IsActive = 1, 'Yes', 'No') AS IsActive, ");			
            sb.Append(" IF(dr.isReferal = 1, 'Yes', 'No') AS 'Refer Share',IF(dr.ReferMasterShare = 1,'Yes','No') AS 'Refer Master Share' FROM  doctor_referal dr where dr.name <>''  ");
            if (txtDoctorName.Text != "")
            {
                sb.Append(" and  dr.NAME like '"+string.Concat("%", txtDoctorName.Text.Trim(), "%")+"' ");
            }
            if (txtMobileNo.Text != "")
            {
                sb.Append(" and  dr.Mobile like '"+string.Concat("%", txtMobileNo.Text.Trim(), "%")+"' ");
            }

            sb.Append(" and IsActive='"+isActive+"' ");

            if (ddlCenter.SelectedIndex > 0)
            {
                sb.Append(" AND CentreID = '"+ddlCenter.SelectedValue+"'");
            }
            if (DocID != "")
            {
                sb.Append(" and dr.Doctor_id= '"+DocID+"'");
            }
            sb.Append(" and doctorType='"+ddldoctortype.SelectedValue+"'");
            sb.Append(" order by Name");
			
			DataTable dt = StockReports.GetDataTable(sb.ToString());
			if (dt.Rows.Count > 0)
			{
				HttpContext.Current.Session["dtExport2Excel"] = dt;
				HttpContext.Current.Session["ReportName"] = " DoctorReferalReport";	
				HttpContext.Current.Response.Redirect("~/Design/common/ExportToExcel.aspx");
			}
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());            
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
	
	

    private void BindInvestigation()
    {
        DataTable dt = Search();

        if (dt != null && dt.Rows.Count > 0)
        {
            grdInv.DataSource = dt;
            grdInv.DataBind();
            lblMsg.Text = dt.Rows.Count + " Record Found";
        }
        else
        {
            grdInv.DataSource = null;
            grdInv.DataBind();
            lblMsg.Text = grdInv.Rows.Count + " Record Not Found";
        }
    }
	
	private void GetReport()
    {
        GetReportData();

    }
	
    protected void btnSearch_Click(object sender, EventArgs e)
    {

        BindInvestigation();

    }
	
	protected void btnReport_Click(object sender, EventArgs e)
    {

        GetReport();

    }

    protected void grdInv_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        DataTable dt = Search();
        grdInv.PageIndex = e.NewPageIndex;
        grdInv.DataSource = dt;
        grdInv.DataBind();
    }



    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            string UserID = Session["id"].ToString();
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select count(*) from doctor_referal where Name=@DocName", new MySqlParameter("@DocName", txtDocName.Text.Replace("'", "''"))));
            if (count > 0)
            {
                lblMsg.Text = "Doctor Name Already Exist";
                return;
            }

            DoctorMasterReferal objDMR = new DoctorMasterReferal(tranX);

            objDMR.Name = txtDocName.Text;
            objDMR.Phone1 = txtPhone.Text;
            objDMR.Street_Name = txtAddress.Text;
            objDMR.DateOfBirth = Util.GetDateTime(txtDob.Text);
            objDMR.Mobile = txtMobile.Text;
            objDMR.Specialization = ddlSpecialization.SelectedValue;
            objDMR.UserName = UserID;
            objDMR.Anniversary = Util.GetDateTime(txtAnniversary.Text);
            objDMR.AreaName = ddlArea.SelectedItem.Text;

            string Doctor_ID = objDMR.Insert();

            tranX.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "CallParentFunction();", true);
        }
        catch (Exception ex)
        {
            tranX.Rollback();

            lblMsg.Text = "Record Not Saved ..";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    private void bindgrid()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string str = "Select * from doctor_referal where doctor_ID=@DocID ";
            DataTable dt =MySqlHelper.ExecuteDataset(con,CommandType.Text,str,new MySqlParameter("@DocID",ViewState["Doctor_ID"].ToString())).Tables[0];
            if (dt != null && dt.Rows.Count > 0)
            {
                grdInv.DataSource = dt;
                grdInv.DataBind();
            }
            else
            {
                grdInv.DataSource = null;
                grdInv.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void grdInv_SelectedIndexChanged(object sender, EventArgs e)
    {

        AllLoad_Data.bindDocTypeList(ddlSpecial, 3, "");
        BindDegree();
        int info = Convert.ToInt32(((Label)grdInv.SelectedRow.FindControl("lblinfo")).Text);

        string IsActive = ((Label)grdInv.SelectedRow.FindControl("lblActive")).Text;
      
        if (IsActive == "1")
            chkActive.Checked = true;
        else
            chkActive.Checked = false;

        string ReferShare = ((Label)grdInv.SelectedRow.FindControl("lblReferShare")).Text;
        if (ReferShare == "Yes")
            chkRefershare.Checked = true;
        else
            chkRefershare.Checked = false;

        string ReferMaster = ((Label)grdInv.SelectedRow.FindControl("lblReferMaster")).Text;
        if (ReferMaster == "Yes")
            ChkRefersharemaster.Checked = true;
        else
            ChkRefersharemaster.Checked = false;

        lblDoctor_ID.Text = ((Label)grdInv.SelectedRow.FindControl("lblDoctorID")).Text;

        txtDocCode.Text = ((Label)grdInv.SelectedRow.FindControl("lblDoctorCode")).Text;
        cmbTitle.SelectedIndex = cmbTitle.Items.IndexOf(cmbTitle.Items.FindByText(((Label)grdInv.SelectedRow.FindControl("lblTitle")).Text));

        txtUpdateDocName.Text = ((Label)grdInv.SelectedRow.FindControl("lblname")).Text;
        txtClinicName.Text=((Label)grdInv.SelectedRow.FindControl("lblClinicName")).Text;


        txtEmail.Text = ((Label)grdInv.SelectedRow.FindControl("lblEmail")).Text;
        txtAdd.Text=((Label)grdInv.SelectedRow.FindControl("LblStreet_Name")).Text;
        txtPhone2.Text = ((Label)grdInv.SelectedRow.FindControl("lblPhone2")).Text;
        txtxtUpdateMobile.Text = ((Label)grdInv.SelectedRow.FindControl("lblMobile")).Text;
        
        ddlSpecial.SelectedIndex = ddlSpecial.Items.IndexOf(ddlSpecial.Items.FindByText(((Label)grdInv.SelectedRow.FindControl("lblSpecialization")).Text));
        ddlDegree.SelectedIndex = ddlDegree.Items.IndexOf(ddlDegree.Items.FindByText(((Label)grdInv.SelectedRow.FindControl("lblDegree")).Text));
        if (ddlPRO.Items.FindByValue(Util.GetString(((Label)grdInv.SelectedRow.FindControl("lblPRO")).Text)) != null)
            ddlPRO.SelectedIndex = Util.GetInt(((Label)grdInv.SelectedRow.FindControl("lblPRO")).Text);

        AllLoad_Data.bindState(ddlState, "Select");

        ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByValue(((Label)grdInv.SelectedRow.FindControl("lblStateID")).Text));




        AllLoad_Data.bindCity(ddlCity,Util.GetInt(((Label)grdInv.SelectedRow.FindControl("lblStateID")).Text));
        ddlCity.SelectedIndex = ddlCity.Items.IndexOf(ddlCity.Items.FindByValue(((Label)grdInv.SelectedRow.FindControl("lblCityID")).Text));


        AllLoad_Data.bindZone(ddlZone, Util.GetInt(((Label)grdInv.SelectedRow.FindControl("lblCityID")).Text));
        ddlZone.SelectedIndex = ddlZone.Items.IndexOf(ddlZone.Items.FindByValue(((Label)grdInv.SelectedRow.FindControl("lblZoneID")).Text));


        AllLoad_Data.bindLocalityByZone(ddlLocality, Util.GetInt(((Label)grdInv.SelectedRow.FindControl("lblZoneID")).Text));
        ddlLocality.SelectedIndex = ddlLocality.Items.IndexOf(ddlLocality.Items.FindByValue(((Label)grdInv.SelectedRow.FindControl("lblLocalityID")).Text));

        mpeCreateGroup.Show();
    }


    protected void grdInv_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "CentreMapping") //we could get the data which will be transfered from e.CommandArgument
        {
            string Doctor_ID = Common.Encrypt(e.CommandArgument.ToString());

            string Fullurl = "DoctorReferalCentreMapping.aspx?Doctor_ID=" + Doctor_ID + "";
            OpenNewBrowserWindow(Fullurl, this);

        }


    }
    public static void OpenNewBrowserWindow(string Url, Control control)
    {

        ScriptManager.RegisterStartupScript(control, control.GetType(), "Open", "window.open('" + Url + "');", true);

    }
    

    

   



    [WebMethod]
    public static string updateDoctor(string Title, string Name, string Phone1, string Mobile, string Street_Name, string Specialization, string DocCode, string Email, string ClinicName, string Degree, string doctype, string visitday, int GroupID, string StateID, string CityID, string ZoneID, string LocalityID, string Doctor_ID, string IsActive,string ReferShare,string ReferMaster,string PRO)
    {
        string DocName = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            DocName = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select Name from doctor_referal where IsActive=1 AND  DoctorCode = @DocCode AND Doctor_ID!=@DocID", new MySqlParameter("@DocCode", DocCode), new MySqlParameter("@DocID", Doctor_ID)));
        if (DocName != "")
        {
            return JsonConvert.SerializeObject(new { status = false, response = string.Concat("0", "#", "Doctor Code :" + DocCode + " is already Register with Dr." + DocName) });
        }
        DocName = "";
        if (Mobile != "0000000000" && Mobile.Trim() != "")
        {
            DocName = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select Name from doctor_referal where IsActive=1 AND  Mobile like @Mobile AND Doctor_ID!=@DocID ", new MySqlParameter("@Mobile", string.Concat("%", Mobile, "%")), new MySqlParameter("@DocID", Doctor_ID)));
            if (DocName != "")
            {
                return JsonConvert.SerializeObject(new { status = false, response = string.Concat("1", "#", "This Mobile No:" + Mobile + " is already Register with Dr." + DocName) });
            }
        }


        string upd = "UPDATE doctor_referal  SET PROID=@PROID ,Title=@Title,Name=@Name,Phone1=@Phone1,Mobile=@Mobile,Street_Name=@Street_Name,Specialization=@Specialization,DoctorCode=@DocCode,Email=@Email,ClinicName=@ClinicName,degree=@Degree,DoctorType=@doctype,IsActive=@isactive,State=@StateID,City=@CityID,Locality=@LocalityID,ZoneID=@ZoneID,isReferal=@isReferal,ReferMasterShare=@ReferMasterShare where Doctor_ID= @DocID";
        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, upd, new MySqlParameter("@PROID", PRO), new MySqlParameter("@Title", Title), new MySqlParameter("@Name", Name), new MySqlParameter("@Phone1", Phone1),
        new MySqlParameter("@Mobile", Mobile), new MySqlParameter("@Street_Name", Street_Name), new MySqlParameter("@Specialization", Specialization),
        new MySqlParameter("@DocCode", DocCode), new MySqlParameter("@Email", Email), new MySqlParameter("@ClinicName", ClinicName),
        new MySqlParameter("@Degree", Degree), new MySqlParameter("@doctype", doctype), new MySqlParameter("@isactive", Util.GetInt(IsActive)),
        new MySqlParameter("@StateID", StateID), new MySqlParameter("@CityID", CityID), new MySqlParameter("@LocalityID", LocalityID),
        new MySqlParameter("@ZoneID", ZoneID), new MySqlParameter("@DocID", Doctor_ID.ToString()),
        new MySqlParameter("@isReferal", ReferShare), new MySqlParameter("@ReferMasterShare", ReferMaster));
        tnx.Commit();
        return JsonConvert.SerializeObject(new { status = true, response = "Record Updated" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    
   

}