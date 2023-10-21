using ClosedXML.Excel;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;

public partial class Design_Master_CampRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindAllData();
        }
    }

    private void bindAllData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            //bindCentre()
            ddlCentreName.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CentreID,CONCAT(CentreCode,' ~ ', Centre)Centre FROM Centre_master WHERE IsActive=1  ORDER BY Centre").Tables[0];
            ddlCentreName.DataValueField = "CentreID";
            ddlCentreName.DataTextField = "Centre";
            ddlCentreName.DataBind();
            ddlCentreName.Items.Insert(0, new ListItem("Select ", "0"));


            bindCamp(con);
            //  bindInvestigation()

            ddlinvestigation.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(im.testCode,' ~ ',im.typeName) name,CONCAT(im.ItemID,'#',im.SubCategoryID,'#',im.Type_ID) ItemID FROM f_itemmaster im  WHERE im.isActive=1 ORDER BY im.testCode ").Tables[0];
            ddlinvestigation.DataValueField = "ItemID";
            ddlinvestigation.DataTextField = "name";
            ddlinvestigation.DataBind();
            ddlinvestigation.Items.Insert(0, new ListItem("Select Test", "0"));

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CentreID,CONCAT(CentreCode,' ~ ', Centre)Centre FROM Centre_master WHERE IsActive=1 AND Category='Lab' ORDER BY Centre ").Tables[0])
            {
                ddlProcessingCentre.DataSource = dt;
                ddlProcessingCentre.DataValueField = "CentreID";
                ddlProcessingCentre.DataTextField = "Centre";
                ddlProcessingCentre.DataBind();
                ddlProcessingCentre.Items.Insert(0, new ListItem("Select ", "0"));
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void bindCamp(MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.id CampID,cm.CentreID,CONCAT(ce.CentreCode,' ~ ', ce.Centre)CentreName,cm.campName,cm.CampCoordinator, ");
        sb.Append(" cm.CampAddress1,cm.CampAddress2,cm.CampContact1,cm.CampContact2,date_format(cm.CreatedDate,'%d-%b-%Y') EntryDateTime, ");
        sb.Append(" cm1.Centre ProcessingCentreName,cm.TagProcessingLabID ,(SELECT group_concat(itemName) FROM camp_test ");
        sb.Append("  where campID=cm.id AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15)) testName FROM camp_master ");
        sb.Append(" cm INNER JOIN Centre_master ce ON cm.CentreID=ce.CentreID INNER JOIN Centre_master cm1 ON cm1.CentreID=cm.TagProcessingLabID ");
        if (con == null)
            grdsave.DataSource = StockReports.GetDataTable(sb.ToString());
        else
            grdsave.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString());
        grdsave.DataBind();
    }
    DataTable cretetable()
    {
        DataTable mydt = new DataTable();
        mydt.Columns.Add("ItemID");
        mydt.Columns.Add("ItemName");
        mydt.Columns.Add("SampleType");
        mydt.Columns.Add("SampleTypeID");
        mydt.Columns.Add("SubCategoryID", typeof(System.Int32));

        mydt.Columns.Add("TestCode");
        mydt.Columns.Add("Investigation_Id");
        mydt.Columns.Add("InvestigationName");
        mydt.Columns.Add("IsPackage");
        mydt.Columns.Add("PackageName");

        mydt.Columns.Add("PackageCode");
        mydt.Columns.Add("ReportType");
        mydt.Columns.Add("IsReporting");
        mydt.Columns.Add("Rate");
        return mydt;
    }
    protected void btnadd_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        if (ddlinvestigation.SelectedValue == "0")
        {
            lblMsg.Text = "Select Test To Add";
            return;
        }
        bindgrid();
    }

    private void bindgrid()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            lblMsg.Text = string.Empty;
            DataTable dt = new DataTable();
            if (ViewState["myTable"] == null || ViewState["myTable"] == string.Empty)
            {
                dt = cretetable();
            }
            else
            {
                dt = (DataTable)ViewState["myTable"];
            }
            DataRow[] dtr = dt.Select(string.Format("ItemID='{0}'", ddlinvestigation.SelectedValue.Split('#')[0]));

            if (dtr.Length > 0)
            {
                lblMsg.Text = "Test Already in List";
                return;
            }

            DataRow[] dtr1 = dt.Select(string.Format("Investigation_Id='{0}'", ddlinvestigation.SelectedValue.Split('#')[2]));

            if (dtr1.Length > 0)
            {
                lblMsg.Text = "Test Already in List";
                return;
            }
            if (dt.Rows.Count > 0)
            {
                if (dt.AsEnumerable().Where(r => r.Field<int>("SubCategoryID") == 15).Count() >= 1 && Util.GetInt(ddlinvestigation.SelectedValue.Split('#')[1]) == 15)
                {
                    lblMsg.Text = "You can add Only One Package in Camp";
                    return;
                }
            }

            DataRow dw = dt.NewRow();
            dw["ItemID"] = ddlinvestigation.SelectedValue.Split('#')[0];
            dw["ItemName"] = ddlinvestigation.SelectedItem.Text;
            dw["SubCategoryID"] = ddlinvestigation.SelectedValue.Split('#')[1];
            dw["TestCode"] = ddlinvestigation.SelectedItem.Text.Split('~')[0];
            dw["Rate"] = "0";
            StringBuilder sb = new StringBuilder();
            if (ddlinvestigation.SelectedValue.Split('#')[1] == "15")
            {
                dw["Investigation_Id"] = 0;
                dw["InvestigationName"] = string.Empty;
                dw["IsPackage"] = 1;
                dw["PackageName"] = ddlinvestigation.SelectedItem.Text.Split('~')[1];
                dw["PackageCode"] = ddlinvestigation.SelectedItem.Text.Split('~')[0];
                dw["ReportType"] = "0";
                dw["IsReporting"] = "0";

                dt.Rows.Add(dw);

                sb = new StringBuilder();
                sb.Append(" SELECT imm.`Name` ,imm.`Investigation_Id`,im.`TypeName`,IFNULL( im.testcode,'')PackageCode,");
                sb.Append(" (SELECT `SubCategoryID` FROM f_itemmaster WHERE type_id=imm.`Investigation_Id`)subcategoryID,imm.TestCode,imm.ReportType ");
                sb.Append("     ,UPPER(IF(IFNULL(im.`Inv_ShortName`,'')='',im.`TypeName`,im.`Inv_ShortName`))PackName  ");
                sb.Append("      FROM f_itemmaster im  ");
                sb.Append("      INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID   ");
                sb.Append("     INNER JOIN investigation_master imm  ON imm.Investigation_Id=pld.InvestigationID ");
                sb.Append("     AND  im.`ItemID`=@ItemID");
                using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@ItemID", ddlinvestigation.SelectedValue.Split('#')[0])).Tables[0])
                {
                    if (dt1.Rows.Count > 0)
                    {
                        for (int i = 0; i < dt1.Rows.Count; i++)
                        {
                            dw = dt.NewRow();
                            dw["ItemID"] = ddlinvestigation.SelectedValue.Split('#')[0];
                            dw["ItemName"] = string.Concat(dt1.Rows[i]["TestCode"].ToString(), "~", dt1.Rows[i]["Name"].ToString()).ToUpper();
                            dw["SubCategoryID"] = dt1.Rows[i]["subcategoryID"].ToString();
                            dw["Investigation_Id"] = dt1.Rows[i]["Investigation_Id"].ToString();
                            dw["InvestigationName"] = dt1.Rows[i]["Name"].ToString();
                            dw["IsPackage"] = 1;
                            dw["PackageName"] = dt1.Rows[i]["PackName"].ToString();
                            dw["TestCode"] = dt1.Rows[i]["TestCode"].ToString();
                            dw["PackageCode"] = dt1.Rows[i]["PackageCode"].ToString();
                            dw["ReportType"] = dt1.Rows[i]["ReportType"].ToString();
                            dw["IsReporting"] = "1";
                            dt.Rows.Add(dw);
                        }
                    }
                }
            }
            else
            {
                dw["InvestigationName"] = ddlinvestigation.SelectedItem.Text.Split('~')[1];
                dw["Investigation_Id"] = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Investigation_Id FROM investigation_master WHERE Investigation_Id=@Investigation_Id ",
                    new MySqlParameter("@Investigation_Id", ddlinvestigation.SelectedValue.Split('#')[2]));
                dw["IsPackage"] = 0;
                dw["PackageName"] = string.Empty;
                dw["PackageCode"] = string.Empty;
                dw["ReportType"] = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ReportType FROM investigation_master WHERE Investigation_Id=@Investigation_Id ",
                   new MySqlParameter("@Investigation_Id", ddlinvestigation.SelectedValue.Split('#')[2]));
                dw["IsReporting"] = "1";
                dt.Rows.Add(dw);
            }
            var Investigation_ID = string.Join(",", dt.AsEnumerable().Where(s => s.Field<string>("Investigation_Id") != "0").Select(s => s.Field<string>("Investigation_Id")).ToList());

            string[] InvTags = Investigation_ID.Split(',');
            string[] InvNames = InvTags.Select((s, i) => "@tag" + i).ToArray();
            string InvClause = string.Join(", ", InvNames);

            sb = new StringBuilder();
            sb.Append(" SELECT lm.`LabObservation_ID`,lm.`Name` ObservationName,im.Name InvestigationName FROM `investigation_master` im ");
            sb.Append(" INNER JOIN `labobservation_investigation` li ON li.`Investigation_Id`=im.`Investigation_ID` ");
            sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` ");
            sb.Append(" WHERE AllowDuplicateBooking=0  AND  li.`Investigation_ID` IN ({0}) ");
            sb.Append(" GROUP BY lm.`LabObservation_ID` HAVING COUNT(*) >1  ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), InvClause), con))
            {
                for (int i = 0; i < InvNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(InvNames[i], InvTags[i]);
                }

                DataTable dtInv = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dtInv);
                    if (dtInv.Rows.Count > 0)
                    {
                        lblMsg.Text = string.Concat(dtInv.Rows[0]["ObservationName"].ToString(), " Found duplicate in ", dtInv.Rows[0]["InvestigationName"].ToString());
                        return;
                    }
                }
            }
            
            grd.DataSource = dt;
            grd.DataBind();
            ViewState["myTable"] = dt;
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void grd_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {



        string itemid = ((Label)grd.Rows[e.RowIndex].FindControl("lblItemID")).Text;
        DataTable dt = (DataTable)ViewState["myTable"];
        DataRow[] dtr = dt.Select(string.Format("ItemID='{0}'", itemid));
        foreach (DataRow drow in dtr)
        {
            drow.Delete();
        }
        dt.AcceptChanges();
        grd.DataSource = dt;
        grd.DataBind();
        ViewState["myTable"] = dt;

    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        if (ddlCentreName.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select Centre Name";
            ddlCentreName.Focus();
            return;
        }
        if (txtcampname.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Enter Camp Name";
            txtcampname.Focus();
            return;
        }
        foreach (GridViewRow dwr in grd.Rows)
        {
            if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "1" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) != 0 && (((DropDownList)dwr.FindControl("ddlSampleType")).SelectedValue) == "-1")
            {
                lblMsg.Text = "Pleaser Select Sample Type";
                ((DropDownList)dwr.FindControl("ddlSampleType")).Focus();
                return;
            }
            if (((((TextBox)dwr.FindControl("txtRate")).Text) == string.Empty || Util.GetInt((((TextBox)dwr.FindControl("txtRate")).Text)) == 0) && (((TextBox)dwr.FindControl("txtRate")).Visible))
            {
                lblMsg.Text = "Pleaser Enter Rate";
                ((TextBox)dwr.FindControl("txtRate")).Focus();
                return;
            }
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM camp_master WHERE campName=@campName",
               new MySqlParameter("@campName", txtcampname.Text.Trim())));
            if (count > 0)
            {
                lblMsg.Text = "Camp Name Already Exits";
                txtcampname.Focus();
                return;
            }
            else
            {

                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO camp_master (CentreID,campName,CampCoordinator,CampAddress1,CampAddress2,CampContact1,CampContact2,CreatedByID,CreatedBy,TagProcessingLabID) ");
                sb.Append(" VALUES ( @CentreID,@campName,@CampCoordinator,@CampAddress1,@CampAddress2,@CampContact1,@CampContact2,@CreatedByID,@CreatedBy,@TagProcessingLabID) ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@CentreID", ddlCentreName.SelectedItem.Value), new MySqlParameter("@campName", txtcampname.Text.Trim()), new MySqlParameter("@CampCoordinator", txtcampcoordinate.Text.Trim()),
                     new MySqlParameter("@CampAddress1", txtadd1.Text.Trim()), new MySqlParameter("@CampAddress2", txtadd2.Text.Trim()),
                     new MySqlParameter("@CampContact1", txtph1.Text.Trim()), new MySqlParameter("@CampContact2", txtph2.Text.Trim()),
                     new MySqlParameter("@CreatedByID", Session["ID"].ToString()), new MySqlParameter("@CreatedBy", Session["LoginName"].ToString()),
                     new MySqlParameter("@TagProcessingLabID", ddlProcessingCentre.SelectedItem.Value));

                int campID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@identity"));

                foreach (GridViewRow dwr in grd.Rows)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO camp_test (campID,ItemID,ItemName,SampleTypeID,SampleTypeName,SubCategoryID,TestCode,Investigation_ID,  ");
                    sb.Append(" IsPackage,InvestigationName,PackageName,PackageCode,CreatedByID,CreatedBy,IsReporting,ReportType,Rate) ");
                    sb.Append(" VALUES(@campID,@ItemID,@ItemName,@SampleTypeID,@SampleTypeName,@SubCategoryID,@TestCode,@Investigation_ID,");
                    sb.Append(" @IsPackage,@InvestigationName,@PackageName,@PackageCode,@CreatedByID,@CreatedBy,@IsReporting,@ReportType,@Rate)");
                    sb.Append("");
                    MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                    cmd.Parameters.AddWithValue("@campID", campID);
                    cmd.Parameters.AddWithValue("@ItemID", ((Label)dwr.FindControl("lblItemID")).Text);
                    cmd.Parameters.AddWithValue("@itemName", ((Label)dwr.FindControl("lblItemName")).Text);
                    if (Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) == 0)
                    {
                        cmd.Parameters.AddWithValue("@SampleTypeID", "0");
                        cmd.Parameters.AddWithValue("@SampleTypeName", string.Empty);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@SampleTypeID", ((DropDownList)dwr.FindControl("ddlSampleType")).SelectedValue);
                        cmd.Parameters.AddWithValue("@SampleTypeName", ((DropDownList)dwr.FindControl("ddlSampleType")).SelectedItem.Text);
                    }
                    cmd.Parameters.AddWithValue("@SubCategoryID", ((Label)dwr.FindControl("lblSubCategoryID")).Text);

                    if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "1" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) == 0)
                    {
                        cmd.Parameters.AddWithValue("@TestCode", string.Empty);
                        cmd.Parameters.AddWithValue("@InvestigationName", string.Empty);
                        cmd.Parameters.AddWithValue("@PackageCode", ((Label)dwr.FindControl("lblPackageCode")).Text);
                        cmd.Parameters.AddWithValue("@PackageName", ((Label)dwr.FindControl("lblPackageName")).Text);
                        cmd.Parameters.AddWithValue("@Investigation_ID", 0);
                        cmd.Parameters.AddWithValue("@IsReporting", "0");
                        cmd.Parameters.AddWithValue("@ReportType", "0");

                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@TestCode", ((Label)dwr.FindControl("lblTestCode")).Text);
                        cmd.Parameters.AddWithValue("@InvestigationName", ((Label)dwr.FindControl("lblInvestigationName")).Text);
                        cmd.Parameters.AddWithValue("@PackageCode", string.Empty);
                        cmd.Parameters.AddWithValue("@PackageName", string.Empty);
                        cmd.Parameters.AddWithValue("@Investigation_ID", ((Label)dwr.FindControl("lblInvestigation_Id")).Text);
                        cmd.Parameters.AddWithValue("@IsReporting", ((Label)dwr.FindControl("lblIsReporting")).Text);
                        cmd.Parameters.AddWithValue("@ReportType", ((Label)dwr.FindControl("lblReportType")).Text);

                    }
                    if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "1" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) == 0)
                    {
                        cmd.Parameters.AddWithValue("@Rate", ((TextBox)dwr.FindControl("txtRate")).Text);
                    }
                    else if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "1" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) != 0)
                    {
                        cmd.Parameters.AddWithValue("@Rate", 0);
                    }
                    else if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "0" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) != 0)
                    {
                        cmd.Parameters.AddWithValue("@Rate", ((TextBox)dwr.FindControl("txtRate")).Text);
                    }
                    cmd.Parameters.AddWithValue("@IsPackage", ((Label)dwr.FindControl("lblIsPackage")).Text);
                    cmd.Parameters.AddWithValue("@CreatedByID", Session["ID"].ToString());
                    cmd.Parameters.AddWithValue("@CreatedBy", Session["LoginName"].ToString());
                    cmd.ExecuteNonQuery();
                }
                clearform();
                lblMsg.Text = "Record Saved Successfully";
                tnx.Commit();
                bindCamp(null);

            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error...";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private void clearform()
    {
        grdsave.SelectedIndex = -1;
        btnsave.Visible = true;
        btnupdate.Visible = false;
        btnCancel.Visible = false;
        lblMsg.Text = string.Empty;
        txtcampname.Text = string.Empty;
        txtcampcoordinate.Text = string.Empty;
        txtadd1.Text = string.Empty;
        txtadd2.Text = string.Empty;
        txtph1.Text = string.Empty;
        txtph2.Text = string.Empty;
        ddlinvestigation.SelectedIndex = 0;
        ddlCentreName.SelectedIndex = 0;
        ddlProcessingCentre.SelectedIndex = 0;
        grd.DataSource = null;
        grd.DataBind();
        ViewState["myTable"] = null;
        ViewState["campID"] = "";
    }
    protected void btnupdate_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        if (ddlCentreName.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select Centre Name";
            ddlCentreName.Focus();
            return;
        }
        if (txtcampname.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Enter Camp Name";
            txtcampname.Focus();
            return;
        }
        string CampId = "";
        foreach (GridViewRow dwr in grd.Rows)
        {
            if (CampId == string.Empty)
                CampId = ((Label)grdsave.SelectedRow.FindControl("lblCampId")).Text;
            if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "1" && (((Label)dwr.FindControl("lblInvestigation_Id")).Text) != string.Empty && (((DropDownList)dwr.FindControl("ddlSampleType")).SelectedValue) == "-1")
            {
                lblMsg.Text = "Pleaser Select Sample Type";
                return;
            }
            if (((((TextBox)dwr.FindControl("txtRate")).Text) == string.Empty || Util.GetInt((((TextBox)dwr.FindControl("txtRate")).Text)) == 0) && (((TextBox)dwr.FindControl("txtRate")).Visible))
            {
                lblMsg.Text = "Pleaser Enter Rate";
                ((TextBox)dwr.FindControl("txtRate")).Focus();
                return;
            }
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM camp_master WHERE campName=@campName AND ID<>@CampID",
               new MySqlParameter("@campName", txtcampname.Text.Trim()), new MySqlParameter("@CampID", ViewState["campID"].ToString())));
            if (count > 0)
            {
                lblMsg.Text = "Camp Name Already Exits";
                txtcampname.Focus();
                return;
            }


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE camp_master set CentreID=@CentreID,campName=@campName,CampCoordinator=@CampCoordinator,CampAddress1=@CampAddress1,CampAddress2=@CampAddress2,CampContact1=@CampContact1,CampContact2=@CampContact2,UpdateDateTime=now(),UpdateByID=@UpdateByID,UpdateBy=@UpdateBy where id=@campID ",
              new MySqlParameter("@CentreID", ddlCentreName.SelectedItem.Value), new MySqlParameter("@campName", txtcampname.Text.Trim()), new MySqlParameter("@CampCoordinator", txtcampcoordinate.Text.Trim()),
                 new MySqlParameter("@CampAddress1", txtadd1.Text.Trim()), new MySqlParameter("@CampAddress2", txtadd2.Text.Trim()),
                 new MySqlParameter("@CampContact1", txtph1.Text.Trim()), new MySqlParameter("@CampContact2", txtph2.Text.Trim()),
                 new MySqlParameter("@UpdateByID", Session["ID"].ToString()), new MySqlParameter("@UpdateBy", Session["LoginName"].ToString()), new MySqlParameter("@campID", ViewState["campID"].ToString()));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM camp_test where campID=@campID",
                 new MySqlParameter("@campID", ViewState["campID"].ToString()));
            StringBuilder sb = new StringBuilder();
            foreach (GridViewRow dwr in grd.Rows)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO camp_test (campID,ItemID,ItemName,SampleTypeID,SampleTypeName,SubCategoryID,TestCode,Investigation_ID,  ");
                sb.Append(" IsPackage,InvestigationName,PackageName,PackageCode,CreatedByID,CreatedBy,IsReporting,ReportType,Rate) ");
                sb.Append(" VALUES(@campID,@ItemID,@ItemName,@SampleTypeID,@SampleTypeName,@SubCategoryID,@TestCode,@Investigation_ID,");
                sb.Append(" @IsPackage,@InvestigationName,@PackageName,@PackageCode,@CreatedByID,@CreatedBy,@IsReporting,@ReportType,@Rate)");
                sb.Append("");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                cmd.Parameters.AddWithValue("@campID", ViewState["campID"].ToString());
                cmd.Parameters.AddWithValue("@ItemID", ((Label)dwr.FindControl("lblItemID")).Text);
                cmd.Parameters.AddWithValue("@itemName", ((Label)dwr.FindControl("lblItemName")).Text);
                if (Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) == 0)
                {
                    cmd.Parameters.AddWithValue("@SampleTypeID", "0");
                    cmd.Parameters.AddWithValue("@SampleTypeName", string.Empty);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@SampleTypeID", ((DropDownList)dwr.FindControl("ddlSampleType")).SelectedValue);
                    cmd.Parameters.AddWithValue("@SampleTypeName", ((DropDownList)dwr.FindControl("ddlSampleType")).SelectedItem.Text);
                }
                cmd.Parameters.AddWithValue("@SubCategoryID", ((Label)dwr.FindControl("lblSubCategoryID")).Text);
                if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "1" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) == 0)
                {
                    cmd.Parameters.AddWithValue("@TestCode", string.Empty);
                    cmd.Parameters.AddWithValue("@InvestigationName", string.Empty);
                    cmd.Parameters.AddWithValue("@PackageCode", ((Label)dwr.FindControl("lblPackageCode")).Text);
                    cmd.Parameters.AddWithValue("@PackageName", ((Label)dwr.FindControl("lblPackageName")).Text);
                    cmd.Parameters.AddWithValue("@Investigation_ID", "0");
                    cmd.Parameters.AddWithValue("@ReportType", "0");
                    cmd.Parameters.AddWithValue("@IsReporting", "0");
                }
                else
                {
                    cmd.Parameters.AddWithValue("@TestCode", ((Label)dwr.FindControl("lblTestCode")).Text);
                    cmd.Parameters.AddWithValue("@InvestigationName", ((Label)dwr.FindControl("lblInvestigationName")).Text);
                    cmd.Parameters.AddWithValue("@PackageCode", string.Empty);
                    cmd.Parameters.AddWithValue("@PackageName", string.Empty);
                    cmd.Parameters.AddWithValue("@Investigation_ID", ((Label)dwr.FindControl("lblInvestigation_Id")).Text);
                    cmd.Parameters.AddWithValue("@ReportType", ((Label)dwr.FindControl("lblReportType")).Text);
                    cmd.Parameters.AddWithValue("@IsReporting", ((Label)dwr.FindControl("lblIsReporting")).Text);
                }
                if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "1" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) == 0)
                {
                    cmd.Parameters.AddWithValue("@Rate", ((TextBox)dwr.FindControl("txtRate")).Text);
                }
                else if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "1" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) != 0)
                {
                    cmd.Parameters.AddWithValue("@Rate", 0);
                }
                else if ((((Label)dwr.FindControl("lblIsPackage")).Text) == "0" && Util.GetInt((((Label)dwr.FindControl("lblInvestigation_Id")).Text)) != 0)
                {
                    cmd.Parameters.AddWithValue("@Rate", ((TextBox)dwr.FindControl("txtRate")).Text);
                }
                cmd.Parameters.AddWithValue("@IsPackage", ((Label)dwr.FindControl("lblIsPackage")).Text);
                cmd.Parameters.AddWithValue("@CreatedByID", Session["ID"].ToString());
                cmd.Parameters.AddWithValue("@CreatedBy", Session["LoginName"].ToString());
                cmd.ExecuteNonQuery();
            }

            clearform();
            lblMsg.Text = "Record Updated Successfully";
            bindCamp(null);
            tnx.Commit();
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error...";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private DataTable getCampRowDetail()
    {
        DataTable dt = new DataTable() { TableName = "Orders" };
        dt.Columns.Add("Title");
        dt.Columns.Add("NAME");
        dt.Columns.Add("DOB", typeof(DateTime));
        dt.Columns.Add("AGE ( in YEARS)");
        dt.Columns.Add("AGE ( in MONTHS)");
        dt.Columns.Add("AGE ( in DAYS)");
        dt.Columns.Add("Gender");
        dt.Columns.Add("Mobile");
        dt.Columns.Add("Address");
        dt.Columns.Add("DoctorName");
        dt.Columns.Add("SampleDate", typeof(DateTime));
        dt.Columns.Add("ClientCode");
        dt.Columns.Add("ReferLabNo");
        dt.Columns.Add("AadharNo");
        dt.Columns.Add("Height");
        dt.Columns.Add("Weight");
        return dt;
    }
    private DataTable getCampSampleTypeDetail(string CampId, DataTable dt, MySqlConnection con)
    {
        DataTable dtmy = new DataTable();
        dtmy.Columns.Add("SampleType");
        using (DataTable dtc = MySqlHelper.ExecuteDataset(con, CommandType.Text, @" SELECT Distinct SampleTypeName FROM camp_test ct    WHERE CampId=@CampId AND Investigation_ID<>''",
              new MySqlParameter("@CampId", CampId)).Tables[0])
        {
            foreach (DataRow dw in dtc.Rows)
            {
                DataRow dc = dtmy.NewRow();
                dc["SampleType"] = dw["SampleTypeName"].ToString();
                dtmy.Rows.Add(dc);
            }
            DataView dv = dtmy.DefaultView.ToTable(true, "SampleType").DefaultView;
            dv.Sort = "SampleType asc";
            DataTable dept = dv.ToTable();
            foreach (DataRow dc in dept.Rows)
            {
                dt.Columns.Add(dc["SampleType"].ToString());
            }
        }
        return dt;
    }

    protected void grdsave_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

        string CampId = ((Label)grdsave.Rows[e.RowIndex].FindControl("lblCampId")).Text;
        string campName = ((Label)grdsave.Rows[e.RowIndex].FindControl("lblCampName")).Text;

        DataTable dt = getCampRowDetail();

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string CampPackageItemID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ItemID FROM camp_test WHERE IsPackage=1 AND CampID=@CampID",
                new MySqlParameter("@CampID", CampId)));
            if (CampPackageItemID != string.Empty)
            {
                using (DataTable campPackageDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ct.Investigation_Id,im.`Name` FROM `camp_test` ct INNER JOIN `investigation_master` im ON ct.`Investigation_Id`=im.`Investigation_Id` WHERE ct.CampID=@CampID AND IsPackage=1",
                     new MySqlParameter("@CampID", CampId)).Tables[0])
                {
                    if (campPackageDetail.Rows.Count > 0)
                    {
                        using (DataTable actualPackageDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT pld.InvestigationID,im.`Name` FROM `package_labdetail` pld INNER JOIN `investigation_master` im ON pld.`InvestigationID`=im.`Investigation_Id` WHERE pld.PlabID=@PlabID",
                      new MySqlParameter("@PlabID", CampPackageItemID)).Tables[0])
                        {
                            List<getCampPackageDetail> getCampPackageItemID = campPackageDetail.AsEnumerable()
                                     .Select(row => new getCampPackageDetail
                                     {
                                         Investigation_ID = row.Field<int>("Investigation_Id"),
                                         Name = row.Field<string>("Name")

                                     }).ToList();


                            List<getCampPackageDetail> getActualPackageItemID = actualPackageDetail.AsEnumerable()
                                    .Select(row => new getCampPackageDetail
                                    {
                                        Investigation_ID = row.Field<int>("InvestigationID"),
                                        Name = row.Field<string>("Name")

                                    }).ToList();

                            // get added item in main Package
                            HashSet<int> diffids = new HashSet<int>(getCampPackageItemID.Select(s => s.Investigation_ID));
                            List<getCampPackageDetail> getUnmatchedItemName = getActualPackageItemID.Where(m => !diffids.Contains(m.Investigation_ID)).ToList();
                            getUnmatchedItemName = getUnmatchedItemName.GroupBy(i => i.Name).Select(group => group.First()).ToList();


                            // get removed item in main Package
                            HashSet<int> diffids1 = new HashSet<int>(getActualPackageItemID.Select(s => s.Investigation_ID));
                            List<getCampPackageDetail> getUnmatchedItemName1 = getCampPackageItemID.Where(m => !diffids1.Contains(m.Investigation_ID)).ToList();
                            getUnmatchedItemName1 = getUnmatchedItemName1.GroupBy(i => i.Name).Select(group => group.First()).ToList();


                            if (getUnmatchedItemName.Count > 0 || getUnmatchedItemName1.Count > 0)
                            {
                                string AddedItemName = string.Join("##", getUnmatchedItemName.Select(s => s.Name));
                                string RemovedItemName = string.Join("##", getUnmatchedItemName1.Select(s => s.Name));
                                //string msg = string.Empty;


                                //if (getUnmatchedItemName.Count > 0)
                                //    msg = string.Concat("<b>AddedItemName :</b>", string.Join("##", getUnmatchedItemName.Select(s => s.Name)));
                                //if (getUnmatchedItemName.Count > 0 && getUnmatchedItemName1.Count > 0)
                                //    msg = string.Concat(msg, "<br/><br/>");
                                //if (getUnmatchedItemName1.Count > 0)
                                //    msg = string.Concat(msg, "<b>RemovedItemName :</b>", string.Join("##", getUnmatchedItemName1.Select(s => s.Name)));

                                lblCampRegName.Text = campName;
                                lblShowCampID.Text = CampId;
                                ClientScript.RegisterStartupScript(GetType(), "ShowCampStatus", string.Format("CampConfirmation('{0}','{1}');", AddedItemName, RemovedItemName), true);
                                getUnmatchedItemName.Clear();
                                getUnmatchedItemName1.Clear();
                                return;
                            }
                        }
                    }
                }
            }
            dt = getCampSampleTypeDetail(CampId, dt, con);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error";
            return;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        using (XLWorkbook wb = new XLWorkbook())
        {
            campName = campName.Replace(",", "");
            wb.Worksheets.Add(dt, campName.Trim());
            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", string.Format("attachment;filename={0}.xls", campName));
            using (MemoryStream MyMemoryStream = new MemoryStream())
            {
                wb.SaveAs(MyMemoryStream);
                MyMemoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }

    protected void btnCampHide_Click(object sender, EventArgs e)
    {
        DataTable dt = getCampRowDetail();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {


            dt = getCampSampleTypeDetail("2", dt, con);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

        //using (XLWorkbook wb = new XLWorkbook())
        //{
        //    string campName = lblCampRegName.Text.Replace(",", "");
        //    wb.Worksheets.Add(dt, campName.Trim());
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.Charset = "";
        //    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        //    Response.AddHeader("content-disposition", "attachment;filename=" + campName + ".xls");
        //    using (MemoryStream MyMemoryStream = new MemoryStream())
        //    {
        //        wb.SaveAs(MyMemoryStream);
        //        MyMemoryStream.WriteTo(Response.OutputStream);
        //        Response.Flush();
        //        Response.End();
        //    }
        //}
    }
    public static void CreateCSVfile(DataTable dtable, string strFilePath)
    {
        StreamWriter sw = new StreamWriter(strFilePath, false);
        int icolcount = dtable.Columns.Count;
        foreach (DataRow drow in dtable.Rows)
        {
            for (int i = 0; i < icolcount; i++)
            {
                if (!Convert.IsDBNull(drow[i]))
                {
                    sw.Write(drow[i].ToString());
                }
                if (i < icolcount - 1)
                {
                    sw.Write(",");
                }
            }
            sw.Write(sw.NewLine);
        }
        sw.Close();
        sw.Dispose();
    }
    protected void grdsave_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Upload")
        {
            int index = Convert.ToInt32(e.CommandArgument.ToString());
            string CampId = ((Label)grdsave.Rows[index].FindControl("lblCampId")).Text;
            string CentreID = ((Label)grdsave.Rows[index].FindControl("lblCentreID")).Text;
            string CampName = ((Label)grdsave.Rows[index].FindControl("lblCampName")).Text;
            string TagProcessingLabID = ((Label)grdsave.Rows[index].FindControl("lblTagProcessingLabID")).Text;
            if (!((FileUpload)grdsave.Rows[index].FindControl("fuAttachment")).HasFile)
            {
                lblMsg.Text = "Please Select Excel to Upload Data";
                return;
            }
            string[] validFileTypes = { "xlsx", "xls" };
            string ext = Path.GetExtension(((FileUpload)grdsave.Rows[index].FindControl("fuAttachment")).FileName);
            bool isValidFile = false;
            for (int i = 0; i < validFileTypes.Length; i++)
            {
                if (ext == "." + validFileTypes[i])
                {
                    isValidFile = true;
                    break;
                }
            }
            if (!isValidFile)
            {
                lblMsg.Text = "Invalid File. Please upload a File with extension " + string.Join(",", validFileTypes);
                return;
            }
            FileUpload fl = ((FileUpload)grdsave.Rows[index].FindControl("fuAttachment"));
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {

                if (fl != null)
                {
                    BinaryReader b = new BinaryReader(fl.PostedFile.InputStream);
                    byte[] binData = b.ReadBytes(fl.PostedFile.ContentLength);
                    using (DataTable dt = AllLoad_Data.getExcelDatatable(binData))
                    {

                        List<string> dtColumnNames = dt.Columns.Cast<DataColumn>().Select(x => x.ColumnName).ToList();
                        using (DataTable chlColumn = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT SampleTypeName FROM camp_test WHERE CampID=@CampID AND SampleTypeName<>'' ",
                             new MySqlParameter("@CampID", CampId)).Tables[0])
                        {
                            DataRow dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "Title";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "NAME";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "DOB";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "AGE ( in YEARS)";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "AGE ( in MONTHS)";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "AGE ( in DAYS)";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "Gender";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "Mobile";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "Address";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "DoctorName";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "SampleDate";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "ClientCode";
                            chlColumn.Rows.Add(dw);
                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "ReferLabNo";
                            chlColumn.Rows.Add(dw);

                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "AadharNo";
                            chlColumn.Rows.Add(dw);

                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "Height";
                            chlColumn.Rows.Add(dw);

                            dw = chlColumn.NewRow();
                            dw["SampleTypeName"] = "Weight";
                            chlColumn.Rows.Add(dw);

                            //IList<string> lsColumns = new List<string>();

                            List<TableColumnHeader> TC = new List<TableColumnHeader>();
                            TC = (from DataRow row in chlColumn.Rows
                                  select new TableColumnHeader
                                  {
                                      ColumnName = row["SampleTypeName"].ToString()
                                  }).ToList();
                            var notMachColumn = dtColumnNames.Except(TC.Select(P => P.ColumnName), StringComparer.OrdinalIgnoreCase).ToList();
                            if (notMachColumn.Count > 0)
                            {
                                lblMsg.Text = "Please Enter Valid Header,Invalid Header Is " + string.Join(",", notMachColumn.ToArray());
                                return;
                            }
                            TC.Clear();
                        }
                        using (DataTable dtIncremented = new DataTable(dt.TableName))
                        {
                            DataColumn dc = new DataColumn("ID");
                            dc.AutoIncrement = true;
                            dc.AutoIncrementSeed = 1;
                            dc.AutoIncrementStep = 1;
                            dc.DataType = System.Type.GetType("System.Int32");
                            dtIncremented.Columns.Add(dc);
                            dtIncremented.BeginLoadData();
                            DataTableReader dtReader = new DataTableReader(dt);
                            dtIncremented.Load(dtReader);
                            dtIncremented.EndLoadData();
                            dtIncremented.AcceptChanges();

                            var TitleCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Title"].ToString())).AsDataView().Count;
                            if (TitleCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Title in Excel S.No. : ", string.Join(",", dtIncremented.AsEnumerable().Where(p => p.Field<string>("Title") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            var TitleGender = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Title,UPPER(Gender)Gender FROM title_gender_master WHERE IsActive=1 ").Tables[0]
                                .AsEnumerable().Select(i => new
                                {
                                    Title = i.Field<string>("Title"),
                                    Gender = i.Field<string>("Gender").ToUpper()
                                }).ToList();

                            var dtTitle = from data in dtIncremented.AsEnumerable()
                                          select new
                                          {
                                              Title = data.Field<string>("Title"),
                                              ID = data.Field<int>("ID"),
                                          };



                            var TitleList = dtTitle.Where(s => !TitleGender.Any(l => (l.Title == s.Title))).ToList();

                            if (TitleList.Count > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid Title : ", string.Join(" ,", TitleGender.Select(s => s.Title).ToArray()), " in Excel S.No. ", string.Join(",", TitleList.Select(s => s.ID + 1).ToArray()));
                                return;
                            }

                            //TitleCount = dt.AsEnumerable().Where(c => c.Field<String>("Title") != "Mr." && c.Field<String>("Title") != "Mrs." && c.Field<String>("Title") != "Miss." && c.Field<String>("Title") != "Baby." && c.Field<String>("Title") != "Baba." && c.Field<String>("Title") != "Master." && c.Field<String>("Title") != "Dr." && c.Field<String>("Title") != "B/O" && c.Field<String>("Title") != "Ms." && c.Field<String>("Title") != "C/O" && c.Field<String>("Title") != "Capt").Count();
                            //if (TitleCount > 0)
                            //{
                            //    lblMsg.Text = string.Concat("Please Enter Valid Title(Mr., Mrs., Miss., Baby., Baba., Master., Dr., B/O, Ms., C/O, Capt) in Excel S.No. " , dtIncremented.AsEnumerable().Where(c => c.Field<String>("Title") != "Mr." && c.Field<String>("Title") != "Mrs." && c.Field<String>("Title") != "Miss." && c.Field<String>("Title") != "Baby." && c.Field<String>("Title") != "Baba." && c.Field<String>("Title") != "Master." && c.Field<String>("Title") != "Dr." && c.Field<String>("Title") != "B/O" && c.Field<String>("Title") != "Ms." && c.Field<String>("Title") != "C/O" && c.Field<String>("Title") != "Capt").Select(cc => cc.Field<int>("ID") + 1).First());
                            //    return;
                            //}


                            var NameCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Name"].ToString())).AsDataView().Count;
                            if (NameCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Name in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("Name") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            DateTime date;

                            var DOBInvalidDates = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => !DateTime.TryParse(myRow.Field<String>("DOB"), out date)).Count();
                            if (DOBInvalidDates > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid DOB in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !DateTime.TryParse(myRow.Field<String>("DOB"), out date)).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            DOBInvalidDates = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("DOB")) > DateTime.Now).Count();
                            if (DOBInvalidDates > 0)
                            {
                                lblMsg.Text = string.Concat("DOB Can not be Future Date,Please Enter Valid DOB in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("DOB")) > DateTime.Now).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            DOBInvalidDates = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("DOB")) < DateTime.Now.Date.AddYears(-110)).Count();
                            if (DOBInvalidDates > 0)
                            {
                                lblMsg.Text = string.Concat("DOB Can not be greater than 110 Years,Please Enter Valid DOB in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("DOB")) < DateTime.Now.Date.AddYears(-110)).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }


                            var DOBCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["DOB"].ToString()) && string.IsNullOrWhiteSpace(r["AGE ( in YEARS)"].ToString()) && string.IsNullOrWhiteSpace(r["AGE ( in MONTHS)"].ToString()) && string.IsNullOrWhiteSpace(r["AGE ( in DAYS)"].ToString())).AsDataView().Count;
                            if (DOBCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter DOB in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("DOB") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            var AgeYears = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["AGE ( in YEARS)"].ToString()) && string.IsNullOrWhiteSpace(r["DOB"].ToString())).AsDataView().Count;
                            if (AgeYears > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter AGE ( in YEARS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("AGE ( in YEARS)") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            var AgeMonths = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["AGE ( in MONTHS)"].ToString()) && string.IsNullOrWhiteSpace(r["DOB"].ToString())).AsDataView().Count;
                            if (AgeMonths > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter AGE ( in MONTHS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("AGE ( in MONTHS)") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            var AgeDays = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["AGE ( in DAYS)"].ToString()) && string.IsNullOrWhiteSpace(r["DOB"].ToString())).AsDataView().Count;
                            if (AgeDays > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter AGE ( in DAYS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("AGE ( in DAYS)") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            var GenderCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Gender"].ToString())).AsDataView().Count;
                            if (GenderCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Gender in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("Gender") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            var MobileCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Mobile"].ToString())).AsDataView().Count;
                            if (MobileCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Mobile No. in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("Mobile") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            var AddressCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Address"].ToString())).AsDataView().Count;
                            if (AddressCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Address in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("Address") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }


                            var SampleDateCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["SampleDate"].ToString())).AsDataView().Count;
                            if (SampleDateCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter SampleDate in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("SampleDate") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            SampleDateCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["SampleDate"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("SampleDate")) > DateTime.Now).Count();
                            if (SampleDateCount > 0)
                            {
                                lblMsg.Text = string.Concat("SampleDate Can not be Future Date,Please Enter Valid SampleDate in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["SampleDate"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("SampleDate")) > DateTime.Now).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            SampleDateCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["SampleDate"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("SampleDate")) < DateTime.Now.Date.AddDays(-10)).Count();
                            if (SampleDateCount > 0)
                            {
                                lblMsg.Text = string.Concat("SampleDate Can not be less then 10 Days,Please Enter Valid SampleDate in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["SampleDate"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("SampleDate")) < DateTime.Now.Date.AddDays(-10)).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            var ClientCodeCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["ClientCode"].ToString())).AsDataView().Count;
                            if (ClientCodeCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter ClientCode in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("ClientCode") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            var ReferLabNoCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["ReferLabNo"].ToString())).AsDataView().Count;
                            if (ReferLabNoCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter ReferLabNo in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("ReferLabNo") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            int GenderMFCount = dt.AsEnumerable().Where(c => c.Field<String>("Gender").ToUpper() != "MALE" && c.Field<String>("Gender").ToUpper() != "FEMALE" && c.Field<String>("Gender").ToUpper() != "TRANS").Count();
                            if (GenderMFCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid Gender in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(c => c.Field<String>("Gender").ToUpper() != "MALE" && c.Field<String>("Gender").ToUpper() != "FEMALE" && c.Field<String>("Gender").ToUpper() != "TRANS").Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            int num1;


                            var YearsChkInt = dt.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => !int.TryParse(myRow.Field<String>("AGE ( in YEARS)"), out num1)).Count();

                            if (YearsChkInt > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid AGE ( in YEARS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !int.TryParse(myRow.Field<String>("AGE ( in YEARS)"), out num1)).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            var chkMultipleAge = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE ( in YEARS)"))).Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE ( in MONTHS)"))).Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE ( in DAYS)"))).Count();

                            if (chkMultipleAge > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter DOB OR AGE ( in YEARS),AGE ( in MONTHS),AGE ( in DAYS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE ( in YEARS)"))).Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE ( in MONTHS)"))).Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE ( in DAYS)"))).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }




                            var MonthsChkInt = dt.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => !int.TryParse(myRow.Field<String>("AGE ( in MONTHS)"), out num1)).Count();
                            if (MonthsChkInt > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid AGE ( in MONTHS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !int.TryParse(myRow.Field<String>("AGE ( in MONTHS)"), out num1)).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            var DaysChkInt = dt.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["DOB"].ToString())).Where(myRow => !int.TryParse(myRow.Field<String>("AGE ( in DAYS)"), out num1)).Count();
                            if (DaysChkInt > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid AGE ( in DAYS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !int.TryParse(myRow.Field<String>("AGE ( in DAYS)"), out num1)).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            var YearsCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE ( in YEARS)"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in YEARS)")) > 110).Count();
                            if (YearsCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid AGE ( in YEARS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE ( in YEARS)"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in YEARS)")) > 110).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            var MonthsCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE ( in MONTHS)"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in MONTHS)")) > 12).Count();
                            if (MonthsCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid AGE ( in MONTHS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE ( in MONTHS)"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in MONTHS)")) > 12).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }

                            var DaysCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE ( in DAYS)"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in DAYS)")) > 30).Count();
                            if (DaysCount > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid AGE ( in DAYS) in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE ( in DAYS)"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in DAYS)")) > 30).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }



                            long num2;
                            var MobileChkInt = dt.AsEnumerable().Where(myRow => !long.TryParse(myRow.Field<String>("Mobile"), out num2)).Count();
                            if (MobileChkInt > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid Mobile in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !long.TryParse(myRow.Field<String>("Mobile"), out num2)).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }


                            var SampleDateInvalidDates = dt.AsEnumerable().Where(myRow => !DateTime.TryParse(myRow.Field<String>("SampleDate"), out date)).Count();
                            if (SampleDateInvalidDates > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid SampleDate in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !DateTime.TryParse(myRow.Field<String>("SampleDate"), out date)).Select(cc => cc.Field<int>("ID") + 1)));
                                return;
                            }
                            //To Check Mobile Length
                            List<string> MobileLength = dt.AsEnumerable().Select(row => row.Field<string>("Mobile")).ToList();
                            if (MobileLength.Count > 0)
                            {
                                if (MobileLength.Where(x => x.Length > 10).Count() > 0)
                                {
                                    lblMsg.Text = string.Concat("Please Enter Valid Mobile No. Invalid Mobile No. is :", string.Join(" ,", MobileLength.Where(x => x.Length > 10).ToList()));
                                    return;
                                }
                            }
                            MobileLength.Clear();

                            //Title with gender check
                            var dtTitleGender = from data in dtIncremented.AsEnumerable()
                                                select new
                                                {
                                                    Title = data.Field<string>("Title"),
                                                    Gender = data.Field<string>("Gender").ToUpper(),
                                                    ID = data.Field<int>("ID")
                                                };
                            var TitleGenderList = dtTitleGender.Where(s => !TitleGender.Any(l => (l.Title == s.Title && s.Gender.ToUpper() == l.Gender.ToUpper()))).Where(s => TitleGender.Any(l => (l.Title == s.Title && l.Gender.ToUpper() != "UNKNOWN"))).ToList();

                            if (TitleGenderList.Count > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid Title with Gender,Invalid data in Excel S.No. : ", string.Join(",", TitleGenderList.Select(s => s.ID + 1).ToArray()));
                                return;

                            }

                            TitleGenderList.Clear();

                            //check valid ClientCode
                            var distinctClientCode = dt.AsEnumerable().Select(row => row.Field<string>("ClientCode")).Distinct().ToList();
                            using (DataTable Panel_Code = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Panel_Code FROM f_panel_master ").Tables[0])
                            {
                                List<Panel_Code> PC = new List<Panel_Code>();
                                PC = (from DataRow row in Panel_Code.Rows
                                      select new Panel_Code
                                      {
                                          ClientCode = row["Panel_Code"].ToString()
                                      }).ToList();

                                var notMachClientCode = distinctClientCode.Except(PC.Select(P => P.ClientCode), StringComparer.OrdinalIgnoreCase).ToList();
                                if (notMachClientCode.Count > 0)
                                {
                                    lblMsg.Text = string.Concat("Please Enter Valid Client Code,Invalid ClientCodes are ", string.Join(",", notMachClientCode.ToArray()));
                                    return;
                                }

                                PC.Clear();
                            }
                            //End check valid ClientCode
                            // check Valid SampleName
                            using (DataTable sampleType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,SampleName FROM sampletype_master WHERE IsActive=1").Tables[0])
                            {
                                // List<string> listSampleType = sampleType.AsEnumerable().Select(myRow => myRow.Field<string>("SampleName")).ToList();

                                List<string> dtSampleType = new List<string>();
                                List<sampleTypeName> ST = new List<sampleTypeName>();
                                ST = (from DataRow row in sampleType.Rows
                                      select new sampleTypeName
                                       {
                                           sampleType = row["SampleName"].ToString(),
                                           sampleTypeID = Util.GetInt(row["ID"].ToString())
                                       }).ToList();

                                // End Valid SampleName

                                string RootDir = AppDomain.CurrentDomain.BaseDirectory + "CampDocument\\";// Util.getApp("ApolloImagePath") + "\\CampDocument";
                                if (!Directory.Exists(RootDir))
                                    Directory.CreateDirectory(RootDir);

                                RootDir = string.Format(@"{0}\{1:yyyyMMdd}", RootDir, DateTime.Now);
                                if (!Directory.Exists(RootDir))
                                    Directory.CreateDirectory(RootDir);

                                string fileExt = System.IO.Path.GetExtension(((FileUpload)grdsave.Rows[index].FindControl("fuAttachment")).FileName);
                                string FileName = string.Concat(CampId, "##", Guid.NewGuid().ToString(), fileExt);
                                ((FileUpload)grdsave.Rows[index].FindControl("fuAttachment")).SaveAs(string.Format(@"{0}\{1}", RootDir, FileName));

                                HashSet<string> dtSampleTypeID = new HashSet<string>();
                                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                                try
                                {
                                    int GroupID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT (MaxID+1) FROM id_master WHERE GroupName='booking_data_excel' "));
                                    StringBuilder sb = new StringBuilder();
                                    sb.Append(" INSERT INTO `booking_data_excel_bkg`(CampID,CampName,CentreID,TagProcessingLabID,`WorkOrderID`,ReferenceID,`RegistrationDate`,`Patient_ID`,`Title`,`PatientName`,`PatientAddress`,`Mobile`,`Email`,Age,DOB,IsDOBActual,AgeYear,AgeMonth,`AgeDays`,TotalAgeInDays,`Gender`,`Doctor_ID`,`DoctorName`,`DoctorMobile`,`SampleCollectionDate`,`Comments`,`BarcodeNo`,`isUrgent`,`DeliveryDate`,`Panel_Code`,SampleTypeName,GroupID,SampleTypeID,IsReporting,AadharNo,Height,Weight) ");
                                    sb.Append(" VALUES (@CampID,@CampName,@CentreID,@TagProcessingLabID,@WorkOrderID,@ReferenceID,now(),@Patient_ID,@Title,@PatientName,@PatientAddress,@Mobile,@Email,@Age,@DOB,@IsDOBActual,@AgeYear,@AgeMonth,@AgeDays,@TotalAgeInDays,@Gender,@Doctor_ID,@DoctorName,@DoctorMobile,@SampleCollectionDate,@Comments,@BarcodeNo,@isUrgent,now(),@Panel_Code,@SampleTypeName,@GroupID,@SampleTypeID,@IsReporting,@AadharNo,@Height,@Weight);");

                                    MySqlCommand myCmd = new MySqlCommand(sb.ToString(), con, tnx);
                                    myCmd.CommandType = CommandType.Text;
                                    foreach (DataRow dr in dtIncremented.Rows)
                                    {
                                        ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "key1", string.Format("getdob({0},{1},{2});", Util.GetInt(dr["AGE ( in YEARS)"].ToString()), Util.GetInt(dr["AGE ( in MONTHS)"].ToString()), Util.GetInt(dr["AGE ( in DAYS)"].ToString())), true);



                                        myCmd.Parameters.Clear();
                                        string WorkOrderID = Guid.NewGuid().ToString();
                                        var age = string.Empty; var TotalAgeInDays = 0; var IsDOBActual = 0; var AgeYear = 0; var AgeMonth = 0; var AgeDay = 0;
                                        if (dr["DOB"].ToString() != string.Empty)
                                        {

                                            TimeSpan ts = DateTime.Now - Convert.ToDateTime(dr["DOB"].ToString());
                                            DateTime Age = DateTime.MinValue.AddDays(ts.Days);
                                            age = string.Concat(Age.Year - 1, " Y ", Age.Month - 1, " M ", Age.Day - 1, " D ");
                                            TotalAgeInDays = Util.GetInt((Age.Year - 1) * 365 + (Age.Month - 1) * 30 + (Age.Day - 1));
                                            AgeYear = Age.Year - 1;
                                            AgeMonth = Age.Month - 1;
                                            AgeDay = Age.Day - 1;
                                            IsDOBActual = 1;
                                        }
                                        else
                                        {
                                            age = string.Format("{0} Y {1} M {2} D ", dr["AGE ( in YEARS)"], dr["AGE ( in MONTHS)"], dr["AGE ( in DAYS)"]);

                                            TotalAgeInDays = Util.GetInt(dr["AGE ( in YEARS)"].ToString()) * 365 + Util.GetInt(dr["AGE ( in MONTHS)"].ToString()) * 30 + Util.GetInt(dr["AGE ( in DAYS)"].ToString());
                                            IsDOBActual = 0;
                                            AgeYear = Util.GetInt(dr["AGE ( in YEARS)"].ToString());
                                            AgeMonth = Util.GetInt(dr["AGE ( in MONTHS)"].ToString());
                                            AgeDay = Util.GetInt(dr["AGE ( in DAYS)"].ToString());
                                        }
                                        myCmd.Parameters.AddWithValue("@GroupID", GroupID);
                                        myCmd.Parameters.AddWithValue("@CampID", CampId);
                                        myCmd.Parameters.AddWithValue("@CampName", CampName);
                                        myCmd.Parameters.AddWithValue("@CentreID", CentreID);
                                        myCmd.Parameters.AddWithValue("@TagProcessingLabID", TagProcessingLabID);
                                        myCmd.Parameters.AddWithValue("@WorkOrderID", WorkOrderID);
                                        myCmd.Parameters.AddWithValue("@ReferenceID", dr["ReferLabNo"].ToString());
                                        myCmd.Parameters.AddWithValue("@Patient_ID", string.Empty);
                                        myCmd.Parameters.AddWithValue("@Title", dr["title"].ToString());
                                        myCmd.Parameters.AddWithValue("@PatientName", dr["name"].ToString());
                                        myCmd.Parameters.AddWithValue("@PatientAddress", dr["address"].ToString());
                                        myCmd.Parameters.AddWithValue("@Mobile", dr["mobile"].ToString());
                                        myCmd.Parameters.AddWithValue("@Email", string.Empty);
                                        myCmd.Parameters.AddWithValue("@Age", age);
                                        if (dr["DOB"].ToString() != string.Empty)
                                        {
                                            myCmd.Parameters.AddWithValue("@DOB", DateTime.ParseExact(dr["DOB"].ToString(), "dd-MM-yyyy HH:mm:ss", CultureInfo.InstalledUICulture, DateTimeStyles.None));

                                        }
                                        else
                                        {
                                            myCmd.Parameters.AddWithValue("@DOB", Util.GetDateTime(txtDOB.Text).ToString("yyyy-MM-dd"));
                                        }
                                        myCmd.Parameters.AddWithValue("@IsDOBActual", IsDOBActual);
                                        myCmd.Parameters.AddWithValue("@AgeYear", AgeYear);
                                        myCmd.Parameters.AddWithValue("@AgeMonth", AgeMonth);
                                        myCmd.Parameters.AddWithValue("@AgeDays", AgeDay);
                                        myCmd.Parameters.AddWithValue("@TotalAgeInDays", TotalAgeInDays);
                                        myCmd.Parameters.AddWithValue("@Gender", dr["gender"].ToString().ToUpper());
                                        if (dr["DoctorName"].ToString().Trim() == string.Empty)
                                        {
                                            myCmd.Parameters.AddWithValue("@Doctor_ID", "1");
                                            myCmd.Parameters.AddWithValue("@DoctorName", "SELF");
                                        }
                                        else
                                        {
                                            myCmd.Parameters.AddWithValue("@Doctor_ID", "2");
                                            myCmd.Parameters.AddWithValue("@DoctorName", dr["DoctorName"].ToString());
                                        }

                                        myCmd.Parameters.AddWithValue("@DoctorMobile", string.Empty);
                                        myCmd.Parameters.AddWithValue("@Comments", string.Empty);
                                        // myCmd.Parameters.AddWithValue("@BarcodeNo", "SNR");
                                        myCmd.Parameters.AddWithValue("@isUrgent", "0");
                                        myCmd.Parameters.AddWithValue("@SampleCollectionDate", DateTime.ParseExact(dr["SampleDate"].ToString(), "dd-MM-yyyy HH:mm:ss", CultureInfo.InstalledUICulture, DateTimeStyles.None));
                                        myCmd.Parameters.AddWithValue("@Panel_Code", dr["ClientCode"].ToString());



                                        myCmd.Parameters.AddWithValue("@AadharNo", dr["AadharNo"].ToString());
                                        myCmd.Parameters.AddWithValue("@Height", dr["Height"].ToString());
                                        myCmd.Parameters.AddWithValue("@Weight", dr["Weight"].ToString());
                                        int firstRow = 0;
                                        foreach (DataColumn column in dt.Columns)
                                        {

                                            if (firstRow == 0)
                                            {
                                                int packageCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM camp_master cm INNER JOIN camp_test ct ON cm.ID=ct.Campid WHERE cm.ID=@CampID AND SubcategoryID=15",
                                                new MySqlParameter("@CampID", CampId)));

                                                if (packageCount > 0)
                                                {
                                                    using (DataTable packageDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ct.ItemID,ct.ItemName FROM camp_master cm INNER JOIN camp_test ct ON cm.ID=ct.Campid WHERE cm.ID=@CampID AND SubcategoryID=15",
                                                        new MySqlParameter("@CampID", CampId)).Tables[0])
                                                    {
                                                        if (packageDetail.Rows.Count > 0)
                                                        {
                                                            myCmd.Parameters.AddWithValue("@SampleTypeName", string.Empty);
                                                            myCmd.Parameters.AddWithValue("@BarCodeNo", string.Empty);
                                                            myCmd.Parameters.AddWithValue("@SampleTypeID", Util.GetInt(0));
                                                            myCmd.Parameters.AddWithValue("@IsReporting", Util.GetInt(0));
                                                            myCmd.ExecuteNonQuery();

                                                            myCmd.Parameters.RemoveAt("@SampleTypeName");
                                                            myCmd.Parameters.RemoveAt("@BarCodeNo");
                                                            myCmd.Parameters.RemoveAt("@SampleTypeID");
                                                            myCmd.Parameters.RemoveAt("@IsReporting");
                                                        }
                                                    }
                                                }
                                            }

                                            var ColumnName = column.ColumnName;
                                            if (ColumnName != "Title" && ColumnName != "NAME" && ColumnName != "DOB" && ColumnName != "AGE ( in YEARS)" && ColumnName != "AGE ( in MONTHS)" && ColumnName != "AGE ( in DAYS)" && ColumnName != "Gender" && ColumnName != "Mobile" && ColumnName != "Address" && ColumnName != "DoctorName" && ColumnName != "SampleDate" && ColumnName != "ClientCode" && ColumnName != "ReferLabNo" && ColumnName != "AadharNo" && ColumnName != "Height" && ColumnName != "Weight")
                                            {
                                                myCmd.Parameters.AddWithValue("@SampleTypeName", ColumnName);
                                                myCmd.Parameters.AddWithValue("@BarCodeNo", dr[ColumnName].ToString().Trim());
                                                if (dr[ColumnName].ToString().Trim() == string.Empty && ColumnName != "NA")
                                                {
                                                    lblMsg.Text = string.Format("Please Enter BarCode No. In {0} Column In Excel S.No. {1}", ColumnName, Util.GetInt(dr["ID"].ToString()) + 1);
                                                    return;
                                                }
                                                if (ColumnName != "NA")
                                                {
                                                    var duplicatesBarcode = dt.AsEnumerable().GroupBy(r => r.Field<string>(ColumnName.ToString())).Where(gr => gr.Count() > 1).ToList();
                                                    if (duplicatesBarcode.Any())
                                                    {
                                                        lblMsg.Text = string.Format("Duplicate Barcode Found In SampleType :{0} Column In Excel S.No. {1} and Barcode Nos are : {2}", ColumnName, Util.GetInt(dr["ID"].ToString()) + 1, string.Join(", ", duplicatesBarcode.Select(dupl => dupl.Key)));
                                                        return;
                                                    }
                                                }
                                                var SampleTypeID = ST.Where(P => P.sampleType.ToLower() == ColumnName.ToLower()).Select(P => P.sampleTypeID).ToList();
                                                myCmd.Parameters.AddWithValue("@SampleTypeID", Util.GetInt(SampleTypeID[0].ToString()));
                                                dtSampleTypeID = new HashSet<string>(dt.AsEnumerable().Select(s => s.Field<string>(ColumnName)));
                                                dtSampleType.Add(ColumnName);
                                                myCmd.Parameters.AddWithValue("@IsReporting", Util.GetInt(1));


                                                myCmd.ExecuteNonQuery();

                                                myCmd.Parameters.RemoveAt("@SampleTypeName");
                                                myCmd.Parameters.RemoveAt("@BarCodeNo");
                                                myCmd.Parameters.RemoveAt("@SampleTypeID");
                                                myCmd.Parameters.RemoveAt("@IsReporting");
                                            }
                                            firstRow = 1;
                                        }
                                    }

                                    var notMachItemID = dtSampleType.Except(ST.Select(P => P.sampleType), StringComparer.OrdinalIgnoreCase).ToList();
                                    if (notMachItemID.Count > 0)
                                    {
                                        lblMsg.Text = "Please Enter Valid Sample Type In Excel Header";
                                        return;
                                    }
                                    ST.Clear();


                                    sb = new StringBuilder();

                                    sb.Append(" SELECT COUNT(*) FROM  booking_data_excel_bkg bd INNER JOIN patient_labinvestigation_opd plo ");
                                    sb.Append(" ON bd.BarcodeNo=plo.BarcodeNo INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionID=plo.LedgertransactionID  WHERE  bd.GroupID=@GroupID AND bd.BarcodeNo<>''");//AND lt.IsCancel=0
                                    int BarCodeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                                       new MySqlParameter("@GroupID", GroupID)));
                                    if (BarCodeCount > 0)
                                    {
                                        using (DataTable duplicateBarcode = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT bd.BarcodeNo FROM  booking_data_excel_bkg bd INNER JOIN patient_labinvestigation_opd plo ON bd.BarcodeNo=plo.BarcodeNo WHERE  bd.GroupID=@GroupID ",
                                              new MySqlParameter("@GroupID", GroupID)).Tables[0])
                                        {

                                            lblMsg.Text = string.Concat("Duplicate Barcode Found; Barcodes are ", string.Join(",", duplicateBarcode.AsEnumerable().Select(P => P.Field<string>("BarcodeNo")).ToArray()));
                                            return;

                                        }
                                    }
                                    sb = new StringBuilder();
                                    sb.Append("INSERT INTO booking_data_excel(CampID,CampName,ReferenceID,WorkOrderID,RegistrationDate,Title,PatientName,PatientAddress,Mobile,Email,Gender,Age,AgeYear,AgeMonth,AgeDays,DOB,");
                                    sb.Append(" TotalAgeInDays,Doctor_ID,DoctorName,SampleCollectionDate,Comments,isUrgent,Panel_Code,Panel_ID,Status,Response,SampleTypeID,SampleTypeName,BarcodeNo,SubCategoryID,ItemID,TestCode,");
                                    sb.Append(" ItemName,Investigation_ID,IsPackage,InvestigationName,PackageName,PackageCode,CentreID,TagProcessingLabID,GroupID,IsDOBActual,ReportType,IsReporting,Rate,SalesManager,AadharNo,Height,Weight )");

                                    sb.Append(" SELECT bd.CampID,bd.CampName,bd.ReferenceID,bd.WorkOrderID,bd.RegistrationDate,bd.Title,bd.PatientName,bd.PatientAddress,bd.Mobile,bd.Email,bd.Gender,bd.Age,bd.AgeYear,bd.AgeMonth,bd.AgeDays,if(IsDOBActual=1,bd.DOB,DATE_FORMAT(DATE_ADD(NOW(),INTERVAL - bd.TotalAgeInDays DAY),'%Y-%m-%d'))DOB,");
                                    sb.Append(" bd.TotalAgeInDays,bd.Doctor_ID,bd.DoctorName,bd.SampleCollectionDate,bd.Comments,bd.isUrgent,bd.Panel_Code,fpm.Panel_ID,bd.Status,bd.Response,bd.SampleTypeID,bd.SampleTypeName,bd.BarcodeNo, ");
                                    sb.Append(" ct.SubCategoryID,ct.ItemID,ct.TestCode,ct.ItemName,ct.Investigation_ID,ct.IsPackage,ct.InvestigationName,ct.PackageName,ct.PackageCode,@CentreID,@TagProcessingLabID,@GroupID,bd.IsDOBActual,ct.ReportType,ct.IsReporting,ct.Rate,fpm.SalesManager,bd.AadharNo,bd.Height,bd.Weight");
                                    sb.Append(" ");
                                    sb.Append(" FROM  booking_data_excel_bkg bd INNER JOIN camp_test ct ON bd.CampID=ct.CampID AND bd.SampleTypeID=ct.SampleTypeID INNER JOIN f_panel_master fpm on fpm.Panel_Code=bd.Panel_Code WHERE bd.GroupID=@GroupID");

                                    int Count = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                          new MySqlParameter("@GroupID", GroupID), new MySqlParameter("@CentreID", CentreID), new MySqlParameter("@TagProcessingLabID", TagProcessingLabID)
                                          );
                                    if (Count > 0)
                                    {
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE id_master SET MaxID=(MaxID+1) WHERE GroupName='booking_data_excel' ");


                                        sb = new StringBuilder();


                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DROP TABLE IF EXISTS _shat");

                                        sb = new StringBuilder();
                                        sb.Append(" CREATE TEMPORARY TABLE _shat (ID int(11)) ");
                                        sb.Append(" SELECT ID FROM `booking_data_excel` WHERE `IsBooked`=0 AND GroupID=@GroupID; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                           new MySqlParameter("@GroupID", GroupID));


                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " ALTER TABLE _shat ADD KEY aa(ID); ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " DROP TABLE IF EXISTS _shat2; ");

                                        sb = new StringBuilder();
                                        sb.Append(" CREATE TEMPORARY TABLE _shat2 (WorkOrderID VARCHAR(50),LedgerTransactionNo  VARCHAR(50),Patient_ID  VARCHAR(15),Username_web  VARCHAR(20),Password_web  VARCHAR(10),CentreID int(11),SalesManager int(11)) ");
                                        sb.Append(" SELECT bdx.WorkOrderID,bdx.LedgerTransactionNo,bdx.Patient_ID,bdx.Username_web,bdx.Password_web ,bdx.`CentreID`,bdx.SalesManager ");
                                        sb.Append(" FROM `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID  GROUP BY `WorkOrderID` ; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());



                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " ALTER TABLE _shat2 ADD KEY aa(WorkOrderID); ");


                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE _shat2 ");
                                        sb.Append(" SET `LedgerTransactionNo` = get_ledgertransaction_centre(`CentreID`) ");
                                        sb.Append(" WHERE IFNULL(LedgerTransactionNo,'') = ''; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE _shat2 ");
                                        sb.Append(" SET `Patient_ID` = get_patientid_centre(`CentreID`) ");
                                        sb.Append(" WHERE IFNULL(Patient_ID,'') = ''; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE _shat2 ");
                                        sb.Append(" SET Username_web = `get_userid`(CentreId) ");
                                        sb.Append(" WHERE IFNULL(Username_web,'') = ''; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE _shat2 ");
                                        sb.Append(" SET Password_web = randString(6) ");
                                        sb.Append(" WHERE IFNULL(Password_web,'') = ''; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());



                                        int _SalesEmployeeID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT SalesManager FROM booking_data_excel WHERE GroupID=@GroupID",
                                           new MySqlParameter("@GroupID", GroupID)));

                                        string salesEmployeeID = string.Empty;

                                        if (_SalesEmployeeID != 0)
                                        {
                                            salesEmployeeID = MySqlHelper.ExecuteScalar(con, CommandType.Text, "CALL get_ParentNode_proc('',@sales,@_EmployeeIDOut)",
                                              new MySqlParameter("@sales", _SalesEmployeeID)).ToString();
                                        }

                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE _shat2 ");
                                        sb.Append(" INNER JOIN booking_data_excel bdx ON bdx.`WorkOrderID`=_shat2.`WorkOrderID` ");
                                        sb.Append(" SET bdx.LedgerTransactionNo=_shat2.LedgerTransactionNo, ");
                                        sb.Append(" bdx.Patient_ID=_shat2.Patient_ID, ");
                                        sb.Append(" bdx.Username_web=_shat2.Username_web, ");
                                        sb.Append(" bdx.Password_web =_shat2.Password_web;   ");

                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                                        // sb.Append(" -- patient_master  ");
                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO patient_master(Patient_ID,Title, PName,   House_No,Street_Name, Locality, City, PinCode, ");
                                        sb.Append(" State, Country,  Phone,  Mobile, Email, ");
                                        sb.Append(" DOB, Age,  AgeYear,   AgeMonth, AgeDays, TotalAgeInDays,Gender, CentreID,ipAddress,StateID,CityID,localityid,UserID,Patient_ID_Interface,IsOnlineFilterData,IsDuplicate,IsDOBActual)       ");//,AadharNo,Height,Weight
                                        sb.Append(" SELECT bdx.Patient_ID,bdx.Title, bdx.PatientName, bdx.`PatientAddress`  House_No,''  Street_Name,'' Locality,''  City,0 Pincode, ");
                                        sb.Append(" '' State,'India' Country,''  Phone, bdx.`Mobile` Mobile,bdx.`Email` Email, ");
                                        sb.Append(" bdx.DOB, bdx.Age,  bdx.AgeYear,   bdx.AgeMonth, bdx.AgeDays, bdx.TotalAgeInDays,CONCAT(UCASE(LEFT(bdx.Gender, 1)), LCASE(SUBSTRING(bdx.Gender, 2))), bdx.CentreID,'00:00:00' ipaddress,0 StateID, ");
                                        sb.Append(" 0 CityID,0 localityID,@UserID,'' Patient_ID_Interface,'0' IsOnlineFilterData,'0' IsDuplicate,bdx.IsDOBActual IsDOBActual ");//,bdx.AadharNo,bdx.Height,bdx.Weight
                                        sb.Append(" FROM `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID ");
                                        sb.Append(" WHERE bdx.GroupID=@GroupID GROUP BY bdx.Patient_ID; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@GroupID", GroupID), new MySqlParameter("@UserID", UserInfo.ID));


                                        // sb.Append(" -- f_ledgertransaction ");
                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO f_ledgertransaction(DATE,LedgerTransactionNo,DiscountOnTotal ,NetAmount , GrossAmount , IsCredit , ");
                                        sb.Append(" Patient_ID , PName ,Age , Gender ,VIP,   Panel_ID ,PanelName , Doctor_ID , DoctorName  , ReferLab ,OtherReferLab ,  ");
                                        sb.Append(" CentreId , Adjustment , AdjustmentDate , CreatedByID , HomeVisitBoyID , ipaddress ,  PatientIDProof , PatientIDProofNo , ");
                                        sb.Append(" PatientSource , PatientType ,  VisitType ,  ");
                                        sb.Append("  HLMPatientType , HLMOPDIPDNo ,DiscountApprovedByID,DiscountApprovedByName,");
                                        sb.Append(" CorporateIDType,CorporateIDCard ");
                                        sb.Append(" ,Username_web, Password_web,ReVisit,CreatedBy,LedgerTransactionNo_InterfaceExcel,Interface_companyName,");
                                        sb.Append(" DiscountID,OtherLabRefNo,IsCamp,CampID,InvoiceToPanelId");
                                        sb.Append(" ) ");
                                        sb.Append(" SELECT NOW(),LedgerTransactionNo, ");
                                        sb.Append(" 0 DiscountOnTotal,0 NetAmount , 0 GrossAmount  , '1' IsCredit ,");
                                        sb.Append(" bdx.Patient_ID ,CONCAT(bdx.Title, bdx.patientName) PName ,bdx.Age , CONCAT(UCASE(LEFT(bdx.Gender, 1)), LCASE(SUBSTRING(bdx.Gender, 2))) ,0 VIP, pm.InvoiceTo Panel_ID ,");
                                        sb.Append(" pm.Company_Name PanelName ,'2' Doctor_ID , bdx.DoctorName  ,0 ReferLab ,");
                                        sb.Append(" '' OtherReferLab ,");
                                        sb.Append(" bdx.CentreId ,0 Adjustment , NOW() ,@Creator_UserID ,");
                                        sb.Append(" 0 HomeVisitBoyID ,'00:00:00' ipAddress , '' PatientIDProof ,'' PatientIDProofNo ,");
                                        sb.Append(" '' PatientSource ,'CAMP' PatientType ,'Home Collection' VisitType ,");
                                        sb.Append(" '' HLMPatientType ,'' HLMOPDIPDNo,0 DiscountApprovedByID,'' DiscountApprovedByName,");
                                        sb.Append(" '' CorporateIDType,'' CorporateIDCard,");
                                        sb.Append(" bdx.Username_web, bdx.Password_web,0 ReVisit,'OfflineCamp' CreatorName,bdx.WorkOrderID,");
                                        sb.Append(" '' Interface_companyName,0 DiscountID,bdx.ReferenceId OtherLabRefNo,1 IsCamp,bdx.CampID CampID,pm.InvoiceTo");
                                        sb.Append(" FROM `booking_data_excel` bdx ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID ");
                                        sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=bdx.Panel_ID");
                                        sb.Append(" GROUP BY bdx.Patient_ID;");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                    new MySqlParameter("@Creator_UserID", UserInfo.ID));


                                        // sb.Append("-- patient_labinvestigation_opd");
                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO `patient_labinvestigation_opd`(");
                                        sb.Append(" `LedgerTransactionID`,`LedgerTransactionNo`,`BarcodeNo`,`ItemId`,`Investigation_ID`,");
                                        sb.Append(" `IsPackage`,`Date`,`SubCategoryID`,`Rate`,`Amount`,`DiscountAmt`,`Quantity`,`DiscountByLab`,");
                                        sb.Append(" `IsRefund`,`IsReporting`,`Patient_ID`,`AgeInDays`,`Gender`,`ReportType`,`CentreID`,`CentreIDSession`,");
                                        sb.Append(" `TestCentreID`,`IsNormalResult`,`IsCriticalResult`,`PrintSeparate`,`isPartial_Result`,`Result_Flag`,");
                                        sb.Append(" `ResultEnteredBy`,`ResultEnteredDate`,`ResultEnteredName`,`Approved`,`AutoApproved`,`MobileApproved`,");
                                        sb.Append(" `ApprovedBy`,`ApprovedDate`,`ApprovedName`,`ApprovedDoneBy`,");
                                        sb.Append(" `IsSampleCollected`,`SampleReceiveDate`,`SampleReceivedBy`,`SampleReceiver`,`SampleBySelf`,");
                                        sb.Append(" `SampleCollectionBy`,`SampleCollector`,`SampleCollectionDate`,`LedgerTransactionNoOLD`,`isHold`,`HoldBy`,`HoldByName`,");
                                        sb.Append(" `UnHoldBy`,`UnHoldByName`,`UnHoldDate`,`Hold_Reason`,`isForward`,`ForwardToCentre`,`ForwardToDoctor`,`ForwardBy`,");
                                        sb.Append(" `ForwardByName`,`ForwardDate`,`isPrint`,`IsFOReceive`,`FOReceivedBy`,`FOReceivedByName`,`FOReceivedDate`,");
                                        sb.Append(" `IsDispatch`,`DispatchedBy`,`DispatchedByName`,`DispatchedDate`,`isUrgent`,`DeliveryDate`,`SlideNumber`,");
                                        sb.Append(" `SampleTypeID`,`SampleTypeName`,`SampleQty`,`LabOutsrcID`,`LabOutsrcName`,`LabOutSrcUserID`,`LabOutSrcBy`,");
                                        sb.Append(" `LabOutSrcDate`,`LabOutSrcRate`,`isHistoryReq`,`CPTCode`,`MacStatus`,`isEmail`,");
                                        sb.Append(" `isrerun`,`ReRunReason`,");

                                        sb.Append(" `UpdateID`,`UpdateName`,`UpdateRemarks`,`UpdateDate`,`ipAddress`,`Barcode_Group`,`IsLabOutSource`,");
                                        sb.Append(" `barcodePreprinted`,`CultureStatus`,`CultureStatusDate`,`reportNumber`,`HistoCytoSampleDetail`,`incubationDatetime`,");
                                        sb.Append(" `HistoCytoPerformingDoctor`,`HistoCytoStatus`,`ItemCode`,`ItemName`,`PackageName`,`PackageCode`,`ReRunDate`,");
                                        sb.Append(" `ReRunByID`,`ReRunByName`,");
                                        sb.Append(" `ItemID_Interface`,`Interface_companyName`,`CancelByInterface`,");
                                        sb.Append(" `MachineID_Manual`,`IsScheduleRate`,`MRP`) ");
                                        sb.Append(" SELECT  ");
                                        sb.Append(" lt.`LedgerTransactionID`,lt.`LedgerTransactionNo`,bdx.`BarcodeNo`,bdx.`ItemId`,bdx.`Investigation_ID`, ");
                                        sb.Append(" bdx.`IsPackage`,lt.`Date`,bdx.`SubCategoryID`,bdx.Rate `Rate`,bdx.Rate `Amount`,0 `DiscountAmt`,1 `Quantity`,0 `DiscountByLab`, ");
                                        sb.Append(" 0 `IsRefund`,bdx.`IsReporting`,bdx.`Patient_ID`,bdx.`TotalAgeInDays`,bdx.`Gender`,bdx.`ReportType`,bdx.`CentreID`,bdx.`CentreID` `CentreIDSession`, ");
                                        sb.Append(" bdx.`TagProcessingLabID` `TestCentreID`,0 `IsNormalResult`,0 `IsCriticalResult`,0 `PrintSeparate`,0 `isPartial_Result`,0 `Result_Flag`, ");
                                        sb.Append(" NULL`ResultEnteredBy`,NULL `ResultEnteredDate`,NULL `ResultEnteredName`,0 `Approved`,0 `AutoApproved`,0 `MobileApproved`, ");
                                        sb.Append(" NULL `ApprovedBy`,NULL `ApprovedDate`,NULL `ApprovedName`,NULL `ApprovedDoneBy`, ");
                                        //----------- Changed By Apurva : 05-12-2019------------
                                        //sb.Append(" 'Y'`IsSampleCollected`,bdx.`SampleCollectionDate` `SampleDate`,NOW()  `SampleReceiveDate`, '1' `SampleReceivedBy`,'Camp' `SampleReceiver`,0 `SampleBySelf`, ");
                                        sb.Append("  IF(bdx.`ReportType`='5','Y','S') `IsSampleCollected`,'0001-01-01 00:00:00'  `SampleReceiveDate`, '0' `SampleReceivedBy`,'' `SampleReceiver`,0 `SampleBySelf`, ");
                                        sb.Append(" '1'  `SampleCollectionBy`,'Camp' `SampleCollector`,bdx.`SampleCollectionDate` `SampleCollectionDate`,'' `LedgerTransactionNoOLD`,0 `isHold`,0 `HoldBy`,NULL `HoldByName`, ");
                                        sb.Append(" 0 `UnHoldBy`,NULL `UnHoldByName`,NULL `UnHoldDate`,NULL `Hold_Reason`,0 `isForward`,0 `ForwardToCentre`,0 `ForwardToDoctor`,0 `ForwardBy`, ");
                                        sb.Append(" NULL `ForwardByName`,NULL `ForwardDate`,0 `isPrint`,0 `IsFOReceive`,0 `FOReceivedBy`,NULL `FOReceivedByName`,NULL `FOReceivedDate`, ");
                                        sb.Append(" 0 `IsDispatch`,0 `DispatchedBy`,NULL `DispatchedByName`,NULL `DispatchedDate`,0 `isUrgent`,NOW() `DeliveryDate`,'' `SlideNumber`, ");
                                        sb.Append(" bdx.`SampleTypeID`,bdx.`SampleTypeName`,'1' `SampleQty`,0 `LabOutsrcID`,NULL `LabOutsrcName`,NULL `LabOutSrcUserID`,NULL `LabOutSrcBy`, ");
                                        sb.Append(" NULL `LabOutSrcDate`,0 `LabOutSrcRate`,0 `isHistoryReq`,'' `CPTCode`,0 `MacStatus`,0 `isEmail`, ");
                                        sb.Append(" 0 `isrerun`,NULL `ReRunReason`, ");


                                        sb.Append(" '1' `UpdateID`,'OfflineCamp'`UpdateName`,'OfflineCamp'`UpdateRemarks`,NOW()`Updatedate`,''`ipaddress`,bdx.Barcodeno `Barcode_Group`, ");
                                        sb.Append(" 0 `IsLabOutSource`, ");
                                        sb.Append(" 0 `barcodePreprinted`,NULL `CultureStatus`,NULL `CultureStatusDate`,NULL `reportnumber`,NULL `HistoCytoSampleDetail`,NULL  `incubationdatetime`, ");
                                        sb.Append(" NULL `HistoCytoPerformingDoctor`,NULL `HistoCytoStatus`,bdx.`TestCode`,bdx.`InvestigationName`,bdx.`PackageName`,bdx.`PackageCode`, ");
                                        sb.Append(" NULL `ReRunDate`, NULL `ReRunByID`,NULL `ReRunByName`, ");
                                        sb.Append(" NULL `ItemID_Interface`,NULL `Interface_companyName`,0 `CancelByInterface`, ");
                                        sb.Append(" '0' `MachineID_Manual`,0 `IsScheduleRate`,0 `MRP` ");
                                        sb.Append(" FROM `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID  ");
                                        sb.Append(" INNER JOIN  f_ledgertransaction lt ON lt.LedgerTransactionNo=bdx.LedgerTransactionNo; ");

                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@UpdateID", UserInfo.ID));


                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO `patient_labinvestigation_opd_share`( ");
                                        sb.Append(" Centre_PanelID,Panel_ID,`LedgerTransactionID`,`LedgerTransactionNo`,`ItemId`,`Date`,`Rate`,Amount,DiscountAmt,Quantity,");
                                        sb.Append(" DiscountByLab,PCCGrossAmt,PCCDiscAmt,PCCNetAmt,PCCSpecialFlag,PCCInvoiceAmt,PCCPercentage)");
                                        sb.Append(" SELECT ");
                                        sb.Append(" pm.InvoiceTo Centre_PanelID,pm.InvoiceTo Panel_ID,plo.`LedgerTransactionID`,plo.`LedgerTransactionNo`,plo.`ItemId`,plo.`Date`,plo.`Rate`,plo.Amount,plo.DiscountAmt,plo.Quantity,");
                                        sb.Append(" 0 DiscountByLab,plo.Amount PCCGrossAmt,0 PCCDiscAmt,plo.Amount PCCNetAmt,0 PCCSpecialFlag,plo.Amount PCCInvoiceAmt,0 PCCPercentage");
                                        sb.Append(" FROM `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID  ");
                                        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=bdx.LedgerTransactionNo AND plo.ItemId=bdx.ItemId  AND  IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                                        sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=bdx.Panel_ID ");
                                        sb.Append(" WHERE bdx.GroupID=@GroupID  AND  IF(bdx.isPackage=1,bdx.`SubCategoryID`=15,bdx.`SubCategoryID`!=15)   ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@GroupID", GroupID));

                                        // Update IsBooked 
                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID ");
                                        sb.Append(" SET IsBooked=1 ,dtAccepted=NOW(); ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                                        sb.Append(" SELECT bdx.LedgerTransactionNo,bdx.`BarcodeNo`,plo.Test_ID,CONCAT('Camp Registration Done (', plo.ItemName, ')'), ");
                                        sb.Append(" @UserID,@LoginName,@IpAddress,plo.CentreID,@RoleID,NOW(),'' ");
                                        sb.Append(" FROM `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID  ");
                                        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=bdx.LedgerTransactionNo AND plo.Investigation_ID=bdx.Investigation_ID  ");
                                        sb.Append(" WHERE bdx.GroupID=@GroupID  GROUP BY plo.Test_ID  ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@LoginName", UserInfo.LoginName),
                                            new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IpAddress", StockReports.getip()),
                                            new MySqlParameter("@GroupID", GroupID));



                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,");
                                        sb.Append(" `Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,ReceivedDate,testID) ");
                                        sb.Append(" SELECT bdx.`BarcodeNo`,bdx.Barcodeno,plo.CentreID,bdx.`TagProcessingLabID`,'',1,@EntryBy,'Received',NOW(),NOW(),@LogisticReceiveBy,NOW(),plo.Test_ID ");
                                        sb.Append(" FROM `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID  ");
                                        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=bdx.LedgerTransactionNo AND plo.Investigation_ID=bdx.Investigation_ID ");
                                        sb.Append(" WHERE bdx.GroupID=@GroupID  ");


                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@EntryBy", UserInfo.ID), new MySqlParameter("@LogisticReceiveBy", UserInfo.ID),
                                            new MySqlParameter("@GroupID", GroupID));

                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                                        sb.Append(" SELECT bdx.LedgerTransactionNo,bdx.`BarcodeNo`,plo.Test_ID,CONCAT('SRA done (', plo.ItemName, ')'), ");
                                        sb.Append(" @UserID,@LoginName,@IpAddress,plo.CentreID,@RoleID,NOW(),'' ");
                                        sb.Append(" FROM `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID  ");
                                        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=bdx.LedgerTransactionNo  AND plo.Investigation_ID=bdx.Investigation_ID ");
                                        sb.Append(" WHERE bdx.GroupID=@GroupID  GROUP BY plo.Test_ID  ");

                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@LoginName", UserInfo.LoginName),
                                            new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IpAddress", StockReports.getip()),
                                            new MySqlParameter("@GroupID", GroupID));

                                        // Insert Mac Data
                                        sb = new StringBuilder();

                                        sb.Append(" DROP TABLE IF EXISTS _mac_data_dummy; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                        sb = new StringBuilder();
                                        sb.Append(" CREATE TEMPORARY TABLE _mac_data_dummy (Test_ID int(11),LabNo varchar(50),LabObservation_ID varchar(50),dtEntry double,pname varchar(20),LedgerTransactionNo varchar(15),InvestigationName varchar(100),LabObservationName varchar(100),Status varchar(7),centreID INT(11),VialID varchar(15),SampleTypeID varchar(15))  ");
                                        sb.Append(" SELECT plo.test_ID Test_ID,CONCAT(bdx.BarcodeNo,IFNULL(lom.suffix,'')) AS LabNo,lom.LabObservation_ID,DATE_FORMAT(NOW(),'%Y%m%d%H%i%s') dtEntry, ");
                                        sb.Append(" IF(LENGTH(pm.PName)>20,LPAD(pm.pname,20,''),pm.pname) pname ,bdx.`LedgerTransactionNo`,inv.`Name` InvestigationName , ");
                                        sb.Append(" lom.`Name` LabObservationName ,plo.SampleTypeID ,bdx.TagProcessingLabID  centreID     ");
                                        sb.Append(" FROM `booking_data_excel` bdx  ");
                                        sb.Append(" INNER JOIN _shat t ON t.ID = bdx.ID  ");
                                        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=bdx.LedgerTransactionNo AND plo.Investigation_ID=bdx.Investigation_ID ");
                                        sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=plo.Patient_ID  ");
                                        sb.Append(" INNER JOIN labobservation_investigation loi ON plo.Investigation_ID=loi.Investigation_Id  ");
                                        sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` ");
                                        sb.Append(" INNER JOIN labobservation_master lom ON loi.labObservation_ID=lom.LabObservation_ID  ");
                                        sb.Append(" AND plo.BarcodeNo=bdx.`BarcodeNo`  ");
                                        sb.Append(" AND plo.`IsReporting`=1 AND bdx.GroupID=@GroupID");
                                        sb.Append(" GROUP BY plo.Test_ID,lom.LabObservation_ID; ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@GroupID", GroupID));

                                        sb = new StringBuilder();
                                        sb.Append(" ALTER TABLE _mac_data_dummy ADD KEY aa(Test_ID); ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO mac_data(Test_ID,LabNo,LabObservation_ID,dtEntry,pname,LedgerTransactionNo,InvestigationName,LabObservationName,`Status`,centreid,`VialID`) ");
                                        sb.Append(" SELECT Test_ID,LabNo,LabObservation_ID,dtEntry,pname,LedgerTransactionNo,InvestigationName,LabObservationName,'Receive',CentreId,SampleTypeID ");
                                        sb.Append(" FROM _mac_data_dummy;   ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE patient_labinvestigation_opd plo  ");
                                        sb.Append(" INNER JOIN _mac_data_dummy mdd ON plo.Test_ID=mdd.Test_ID SET plo.MacStatus=1;  ");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE ( ");
                                        sb.Append("         SELECT   SUM(plo.Rate)Rate,SUM(plo.Amount)Amount,plo.LedgerTransactionID FROM  ");
                                        sb.Append("         `booking_data_excel` bdx INNER JOIN  patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=bdx.LedgerTransactionNo  ");
                                        sb.Append("         AND plo.ItemId=bdx.ItemID AND  IF(bdx.isPackage=1,bdx.`SubCategoryID`=15,bdx.`SubCategoryID`!=15)  ");
                                        sb.Append("         AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)    ");
                                        sb.Append("         AND bdx.GroupID=@GroupID   GROUP BY plo.LedgerTransactionID )t  ");
                                        sb.Append(" INNER JOIN f_ledgertransaction lt  ON t.LedgerTransactionID=lt.LedgerTransactionID  ");
                                        sb.Append(" SET lt.grossamount=Rate,lt.netamount=Amount ");

                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@GroupID", GroupID));



                                        tnx.Commit();
                                        lblMsg.Text = "Data uploaded successfully.";
                                    }
                                    else
                                    {
                                        lblMsg.Text = "Please Enter Valid Client Code";
                                        return;
                                    }
                                }
                                catch (Exception ex)
                                {
                                    tnx.Rollback();
                                    lblMsg.Text = ex.GetBaseException().ToString();
                                    ClassLog objerror = new ClassLog();
                                    objerror.errLog(ex);
                                }
                                finally
                                {
                                    tnx.Dispose();

                                    ((FileUpload)grdsave.Rows[index].FindControl("fuAttachment")).PostedFile.InputStream.Flush();
                                    ((FileUpload)grdsave.Rows[index].FindControl("fuAttachment")).PostedFile.InputStream.Close();
                                    ((FileUpload)grdsave.Rows[index].FindControl("fuAttachment")).FileContent.Dispose();
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {

                lblMsg.Text = ex.GetBaseException().ToString();
                ClassLog objerror = new ClassLog();
                objerror.errLog(ex);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
    }
    protected void grdsave_SelectedIndexChanged(object sender, EventArgs e)
    {
        ViewState["campID"] = ((Label)grdsave.SelectedRow.FindControl("lblCampId")).Text;
        txtcampname.Text = ((Label)grdsave.SelectedRow.FindControl("lblCampName")).Text.Replace("&nbsp;", string.Empty);
        txtcampcoordinate.Text = ((Label)grdsave.SelectedRow.FindControl("lblCampCoordinator")).Text.Replace("&nbsp;", string.Empty);
        txtadd1.Text = ((Label)grdsave.SelectedRow.FindControl("lblCampAddress1")).Text.Replace("&nbsp;", string.Empty);
        txtadd2.Text = string.Empty;
        txtph1.Text = ((Label)grdsave.SelectedRow.FindControl("lblCampContact1")).Text.Replace("&nbsp;", string.Empty);
        txtph2.Text = string.Empty;
        ddlCentreName.SelectedIndex = ddlCentreName.Items.IndexOf(ddlCentreName.Items.FindByValue(((Label)grdsave.SelectedRow.FindControl("lblCentreID")).Text));
        ddlProcessingCentre.SelectedIndex = ddlProcessingCentre.Items.IndexOf(ddlProcessingCentre.Items.FindByValue(((Label)grdsave.SelectedRow.FindControl("lblTagProcessingLabID")).Text));

        btnsave.Visible = false;
        btnupdate.Visible = true;
        btnCancel.Visible = true;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dtc = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select ItemID,itemName,SampleTypeID,SampleTypeName SampleType,SubCategoryID,TestCode,Investigation_Id,InvestigationName,IsPackage,PackageName,PackageCode,ReportType,IsReporting,ROUND(Rate,0)Rate FROM camp_test WHERE campID=@campID",
               new MySqlParameter("@campID", ViewState["campID"].ToString())).Tables[0])
            {
                grd.DataSource = dtc;
                grd.DataBind();
                ViewState["myTable"] = dtc;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    protected void grd_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                row = (DataRowView)e.Row.DataItem;
                string SubCategoryID = ((Label)e.Row.FindControl("lblSubCategoryID")).Text;
                DataTable dt = new DataTable();
                //            if (SubCategoryID == "15")
                //            {
                //                dt = StockReports.GetDataTable(@" SELECT DISTINCT sampleTypeName,iss.SampleTypeID FROM investigations_sampletype iss 
                //                                    INNER JOIN `package_labdetail` pld ON pld.InvestigationID=iss.Investigation_ID INNER JOIN f_itemmaster im ON pld.PlabID=im.type_id WHERE im.itemid='" + ((Label)e.Row.FindControl("lblItemID")).Text + "'");
                //            }
                //            else
                //            {
                //                dt = StockReports.GetDataTable("SELECT DISTINCT sampleTypeName,iss.SampleTypeID FROM investigations_sampletype iss WHERE investigation_id=(select type_id from f_itemmaster where ItemID='" + ((Label)e.Row.FindControl("lblItemID")).Text + "')");

                //            }
                if ((((Label)e.Row.FindControl("lblIsPackage")).Text) == "1" && Util.GetInt(((Label)e.Row.FindControl("lblInvestigation_Id")).Text) != 0)
                {
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT DISTINCT sampleTypeName,iss.SampleTypeID FROM investigations_sampletype iss  INNER JOIN `package_labdetail` pld ON pld.InvestigationID=iss.Investigation_ID WHERE iss.Investigation_ID=@Investigation_ID",
                       new MySqlParameter("@Investigation_ID", ((Label)e.Row.FindControl("lblInvestigation_Id")).Text)).Tables[0];

                }
                else if ((((Label)e.Row.FindControl("lblIsPackage")).Text) == "0" && ((Label)e.Row.FindControl("lblItemID")).Text != string.Empty)
                {
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT sampleTypeName,iss.SampleTypeID FROM investigations_sampletype iss WHERE investigation_id=(select type_id from f_itemmaster where ItemID=@ItemID)",
                       new MySqlParameter("@ItemID", ((Label)e.Row.FindControl("lblItemID")).Text)).Tables[0];

                }
                if (dt.Rows.Count > 0)
                {
                    ((DropDownList)e.Row.FindControl("ddlSampleType")).DataSource = dt;
                    ((DropDownList)e.Row.FindControl("ddlSampleType")).DataTextField = "sampleTypeName";
                    ((DropDownList)e.Row.FindControl("ddlSampleType")).DataValueField = "SampleTypeID";
                    ((DropDownList)e.Row.FindControl("ddlSampleType")).DataBind();
                    if (dt.Rows.Count > 1)
                    {
                        ((DropDownList)e.Row.FindControl("ddlSampleType")).Items.Insert(0, new ListItem("", "-1"));
                    }
                }
                if ((((Label)e.Row.FindControl("lblSampleTypeID")).Text) != string.Empty)
                {
                    ((DropDownList)e.Row.FindControl("ddlSampleType")).SelectedIndex =
                     ((DropDownList)e.Row.FindControl("ddlSampleType")).Items.IndexOf(
                        ((DropDownList)e.Row.FindControl("ddlSampleType")).Items.FindByValue(((Label)e.Row.FindControl("lblSampleTypeID")).Text));
                }
                if (Util.GetInt((((Label)e.Row.FindControl("lblInvestigation_Id")).Text)) == 0 && (((Label)e.Row.FindControl("lblIsPackage")).Text) == "1")
                    ((DropDownList)e.Row.FindControl("ddlSampleType")).Visible = false;
                if (Util.GetInt((((Label)e.Row.FindControl("lblInvestigation_Id")).Text)) != 0 && (((Label)e.Row.FindControl("lblIsPackage")).Text) == "1")
                {
                    ((ImageButton)e.Row.FindControl("btnDelete")).Visible = false;
                    ((TextBox)e.Row.FindControl("txtRate")).Visible = false;
                }
                //int aa = e.Row.RowIndex;
                //if (e.Row.RowIndex > 0)
                //{
                //    GridViewRow prevrow = grd.Rows[e.Row.RowIndex - 1];
                //    if (prevrow.RowType == DataControlRowType.DataRow)
                //    {

                //    }
                //}
            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
    }
    public class sampleTypeName
    {
        public string sampleType { get; set; }
        public int sampleTypeID { get; set; }
    }
    public class Panel_Code
    {
        public string ClientCode { get; set; }
    }
    public class TableColumnHeader
    {
        public string ColumnName { get; set; }
    }
    public class BarCodeData
    {
        public string BarCode_No { get; set; }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        clearform();
    }
    public class getCampPackageDetail
    {
        public string Name { get; set; }
        public int Investigation_ID { get; set; }

    }

}