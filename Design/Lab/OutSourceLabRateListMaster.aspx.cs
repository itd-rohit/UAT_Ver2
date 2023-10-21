using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Linq;
using System.Web.UI.WebControls;
public partial class Design_Lab_OutSourceLabRateListMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["RoleID"] == null)
            {
                lblMsg.Text = "Your Session Expired....Please Login Again";
                return;
            }
            string str = "select CentreID,Concat(CentreCode,' ',Centre)Centre from centre_master where IsActive=1 ";
            ddlCentre.DataSource = StockReports.GetDataTable(str.ToString());
            ddlCentre.DataTextField = "Centre";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
            ddlCentre.Items.Insert(0,new ListItem("","0"));
            ddlOutSourceLab.DataSource = AllLoad_Data.loadOutSourceLab();
            ddlOutSourceLab.DataTextField = "Name";
            ddlOutSourceLab.DataValueField = "ID";
            ddlOutSourceLab.DataBind();
            ddlOutSourceLab.Items.Insert(0, "");

            ddlDepartment.DataSource = AllLoad_Data.loadObservationType();
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, "ALL");

            ddlItem.DataSource = StockReports.GetDataTable("SELECT inv.`Investigation_Id`, IF(im.TestCode='',typename,CONCAT(im.TestCode,' ~ ',typename)) NAME FROM `investigation_master` inv INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.`Investigation_Id` WHERE im.`IsActive`=1   ORDER BY im.`TestCode` ");
            ddlItem.DataTextField = "Name";
            ddlItem.DataValueField = "Investigation_ID";
            ddlItem.DataBind();
            ddlItem.Items.Insert(0, "ALL");
        }
    }

    [WebMethod]
    public static string BindDepartmentTable(string DepartmentID, string InvestigationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbDepartment = new StringBuilder();
            sbDepartment.Append(" SELECT otm.`ObservationType_ID`,otm.`Name` FROM `observationtype_master`  otm ");
            sbDepartment.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=otm.`Description` AND scm.CategoryID='LSHHI3' and scm.Active=1 ");
            sbDepartment.Append(" INNER JOIN `investigation_observationtype` iot ON iot.`ObservationType_Id`=otm.`ObservationType_ID` ");
            if (DepartmentID != "ALL")
            {
                sbDepartment.Append(" and otm.ObservationType_ID=@ObservationType_ID");
            }
            sbDepartment.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=iot.`Investigation_ID` ");
            if (InvestigationID != "ALL")
            {
                sbDepartment.Append(" and inv.Investigation_Id=@Investigation_ID");
            }
            sbDepartment.Append(" GROUP BY otm.`ObservationType_ID` ORDER BY otm.`Name`  ");
			//System.IO.File.WriteAllText (@"F:\q.txt", sbDepartment.ToString());

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbDepartment.ToString(),
                new MySqlParameter("@ObservationType_ID", DepartmentID),
                new MySqlParameter("@Investigation_ID", InvestigationID)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindRateListTable(string CentreID, string CentreName, string DepartmentID, string LabID, string LabName, string InvestigationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT (select count(*) from investigations_outsrclab_othertest where InvID=inv.`Investigation_Id` and Outsrclabid=@LabID and BookingCentreID=@CentreID) othercount, @CentreID CentreID,@CentreName CentreName, @LabID LabID,@LabName LabName, ");
            sb.Append(" inv.`Investigation_Id`, IF(im.TestCode='',typename,CONCAT(im.TestCode,' ~ ',typename)) Investigation,IFNULL(iol.`OutsourceRate`,'') OutsourceRate,IFNULL(iol.isDefault,0) IsDefault,TATType,TAT,IFNULL(IsFileRequired,0) IsFileRequired  FROM `investigation_master` inv ");
            sb.Append(" INNER JOIN `f_itemmaster` im ON im.`Type_ID`=inv.`Investigation_Id` AND im.`SubCategoryID`<>'LSHHI24' AND im.`IsActive`=1 ");
            if (InvestigationID != "ALL")
            {
                sb.Append(" and inv.`Investigation_Id`=@Investigation_ID ");
            }
            sb.Append(" INNER JOIN `investigation_observationtype` iot ON iot.`Investigation_ID`=inv.`Investigation_Id`   ");
            sb.Append(" AND iot.`ObservationType_Id`=@DepartmentID ");

            sb.Append(" LEFT JOIN `investigations_outsrclab` iol ON iol.`Investigation_ID`=inv.`Investigation_Id` AND iol.`OutSrcLabID`=@LabID and iol.CentreID=@CentreID ");
            sb.Append(" ORDER BY im.testcode; ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CentreID", CentreID),
                new MySqlParameter("@CentreName", CentreName),
                new MySqlParameter("@LabName", LabName),
                new MySqlParameter("@LabID", LabID),
                new MySqlParameter("@Investigation_ID", InvestigationID),
                new MySqlParameter("@DepartmentID", DepartmentID)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindItemRateListTable(string CentreID, string CentreName, string InvestigationID, string Investigation)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT @CentreID CentreID,@CentreName CentreName,olm.`ID` LabID, ");
            sb.Append(" olm.`Name` LabName,@Investigation_ID Investigation_Id,@@Investigation Investigation, ");
            sb.Append(" IFNULL(iol.`OutsourceRate`,'') OutsourceRate,IFNULL(iol.isDefault,0) isDefault ");
            sb.Append(" FROM `outsourcelabmaster`  olm   ");
            sb.Append(" LEFT JOIN (SELECT * FROM investigations_outsrclab WHERE Investigation_ID =@Investigation_ID and CentreID=@CentreID ) iol ON olm.ID = iol.OutSrcLabID ");
            sb.Append(" ORDER BY olm.`Name` ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CentreID", CentreID),
                new MySqlParameter("@CentreName", CentreName),
                new MySqlParameter("@Investigation_ID", InvestigationID),
                new MySqlParameter("@Investigation", Investigation)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveRateList(List<OutSourceRateListMaster> data, string Type)
    {
        int noOfRowsUpdated = data.Count;
       
        data = data.AsEnumerable().Where(r => r.IsDefault == 1).ToList();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (OutSourceRateListMaster objRateDetailArr in data)
            {
                StringBuilder sb_1 = new StringBuilder();
                sb_1.Append("SELECT Investigation_ID,OutSrcLabName,CentreID FROM investigations_outsrclab ");
                sb_1.Append(" WHERE Investigation_ID =" + objRateDetailArr.Investigation_Id + " AND   CentreID=" + objRateDetailArr.CentreID + "  ");
                sb_1.Append(" ");
                DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());


               
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM investigations_outsrclab WHERE Investigation_ID =@Investigation_ID AND   CentreID=@CentreID ",
                    new MySqlParameter("@Investigation_ID", objRateDetailArr.Investigation_Id),
                    new MySqlParameter("@CentreID", objRateDetailArr.CentreID));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM test_centre_mapping WHERE Investigation_ID =@Investigation_ID AND Test_Centre=@Test_Centre ",
                    new MySqlParameter("@Investigation_ID", objRateDetailArr.Investigation_Id),
                    new MySqlParameter("@Test_Centre", objRateDetailArr.CentreID));
                              
                    if (Type == "Save")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  f_itemmaster SET IsOutSrc=1 WHERE  Type_ID=@Investigation_Id",
                                                       new MySqlParameter("@Investigation_ID", objRateDetailArr.Investigation_Id));
                    }
                    if (Type == "Remove")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  f_itemmaster SET IsOutSrc=0 WHERE  Type_ID=@Investigation_Id",
                                                     new MySqlParameter("@Investigation_ID", objRateDetailArr.Investigation_Id));
                    }

                
                if (Type == "Save")
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO investigations_outsrclab(Investigation_ID,OutSrcLabID,OutSrcLabName,CentreID,IsDefault,CreatedUserID,CreatedDate,OutsourceRate,TATType,TAT,IsFileRequired) ");
                    sb.Append(" Values(@Investigation_ID,@OutSrcLabID,@OutSrcLabName,@CentreID,@IsDefault,@CreatedUserID,NOW(),@OutsourceRate,@TATType,@TAT,@IsFileRequired) ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@Investigation_ID", objRateDetailArr.Investigation_Id),
                        new MySqlParameter("@OutSrcLabID", objRateDetailArr.LabID),
                        new MySqlParameter("@OutSrcLabName", objRateDetailArr.LabName),
                        new MySqlParameter("@CentreID", objRateDetailArr.CentreID),
                        new MySqlParameter("@IsDefault", objRateDetailArr.IsDefault),
                        new MySqlParameter("@CreatedUserID", UserInfo.ID),
                        new MySqlParameter("@OutsourceRate", Util.GetDecimal(objRateDetailArr.OutsourceRate)),
                        new MySqlParameter("@TATType", objRateDetailArr.TATType),
                        new MySqlParameter("@TAT", objRateDetailArr.TAT),
                        new MySqlParameter("@IsFileRequired", objRateDetailArr.IsFileRequired));   
                }

                sb_1 = new StringBuilder();
                sb_1.Append("SELECT Investigation_ID,OutSrcLabName,CentreID FROM investigations_outsrclab ");
                sb_1.Append(" WHERE Investigation_ID =" + objRateDetailArr.Investigation_Id + " AND   CentreID=" + objRateDetailArr.CentreID + "  ");
                sb_1.Append(" ");
                DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb_1.ToString()).Tables[0];

                if (dt_LTD_1.Rows.Count > 0 && dt_LTD_2.Rows.Count > 0)
                {
                    for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
                    {
                        string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                        if ((Util.GetString(dt_LTD_1.Rows[0][i]) != Util.GetString(dt_LTD_2.Rows[0][i])))
                        {
                            sb_1 = new StringBuilder();
                            sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                            sb_1.Append("  values('','OutsourceCentreMapping','" + Util.GetString(dt_LTD_1.Rows[0][i]) + "','" + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + Util.GetString(UserInfo.ID) + "','" + Util.GetString(UserInfo.LoginName) + "',NOW(),'" + Util.GetString(UserInfo.RoleID) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2.Rows[0]["OutSrcLabName"] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_1.Rows[0][i]) + " to " + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + StockReports.getip() + "',62);  ");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb_1.ToString());
                        }
                    }
                }


            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}