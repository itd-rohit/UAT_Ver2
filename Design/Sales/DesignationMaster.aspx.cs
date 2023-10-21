using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Sales_DesignationMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string GetDesignation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ID,Name,SequenceNo,IsActive,if(IsActive=1,'Active','DeActive')CurrentStatus,dm.IsShowSpecialRate,dm.IsNewTestApprove,dm.IsDirectApprove, ");
        sb.Append(" IFNULL((SELECT COUNT(1) FROM employee_master em WHERE `DesignationID`= dm.id AND em.`IsSalesTeamMember`=1 AND em.isactive=1) ,0) EmpCount ");
        sb.Append(" FROM f_designation_msater dm WHERE IsSales=1 ORDER BY SequenceNo");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string GetEmployee(string DesignationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Employee_ID, Title, NAME, Mobile, Email,House_No as EmpCode FROM `employee_master` WHERE IsSalesTeamMember=1 and IsActive=1 and DesignationID='" + DesignationID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string Save(string Name, string ID, int IsNewTestApprove, int IsDirectApprove, int IsShowSpecialRate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (ID == "0")
            {
                var count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(*) FROM f_designation_msater WHERE IsSales=1 and  Name='" + Name.Trim() + "'"));
                if (count > 0)
                {
                    return "2";
                }

                var Sequence = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(SequenceNo+1) FROM f_designation_msater WHERE IsSales=1");
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO f_designation_msater(Name,SequenceNo,IsActive,IsSales,CreatedByID,CreatedBy,IsNewTestApprove,IsDirectApprove,IsShowSpecialRate)");
                sb.Append("VALUES(@Name,@SequenceNo,@IsActive,@IsSales,@CreatedByID,@CreatedBy,@IsNewTestApprove,@IsDirectApprove,@IsShowSpecialRate)");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                cmd.Parameters.AddWithValue("@Name", Name);
                cmd.Parameters.AddWithValue("@SequenceNo", Sequence);
                cmd.Parameters.AddWithValue("@IsActive", "1");
                cmd.Parameters.AddWithValue("@IsSales", "1");
                cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@IsNewTestApprove", IsNewTestApprove);
                cmd.Parameters.AddWithValue("@IsDirectApprove", IsDirectApprove);
                cmd.Parameters.AddWithValue("@IsShowSpecialRate", IsShowSpecialRate);

                cmd.ExecuteNonQuery();
                tnx.Commit();
                return "1";
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_designation_msater SET Name=@Name,UpdateDate=@UpdateDate,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,IsNewTestApprove=@IsNewTestApprove,IsDirectApprove=@IsDirectApprove,IsShowSpecialRate=@IsShowSpecialRate where ID=@ID ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                cmd.Parameters.AddWithValue("@Name", Name);
                cmd.Parameters.AddWithValue("@UpdateDate", System.DateTime.Now);

                cmd.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@IsNewTestApprove", IsNewTestApprove);
                cmd.Parameters.AddWithValue("@IsDirectApprove", IsDirectApprove);
                cmd.Parameters.AddWithValue("@IsShowSpecialRate", IsShowSpecialRate);
                cmd.Parameters.AddWithValue("@ID", ID);
                cmd.ExecuteNonQuery();
                tnx.Commit();
                return "1";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string Delete(string Status, string DesignationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            var EmployeeCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(*) FROM employee_master where IsSalesTeamMember=1 and DesignationID=" + DesignationID + ""));
            if (EmployeeCount > 0)
            {
                return "2";
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE f_designation_msater SET IsActive=@IsActive,UpdateDate=@UpdateDate,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy where ID=@ID ");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
            cmd.Parameters.AddWithValue("@IsActive", Status);
            cmd.Parameters.AddWithValue("@UpdateDate", DateTime.Now);

            cmd.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
            cmd.Parameters.AddWithValue("@ID", DesignationID);
            cmd.ExecuteNonQuery();
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string SaveGridChanges(string ItemDetail)
    {
        List<ItemData> result = new List<ItemData>();
        result = JsonConvert.DeserializeObject<List<ItemData>>(ItemDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (var item in result)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_designation_msater SET SequenceNo=@SequenceNo,UpdateDate=@UpdateDate,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,IsShowSpecialRate=@IsShowSpecialRate,IsNewTestApprove=@IsNewTestApprove,IsDirectApprove=@IsDirectApprove where ID=@ID ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                cmd.Parameters.AddWithValue("@SequenceNo", item.Sequence);
                cmd.Parameters.AddWithValue("@UpdateDate", DateTime.Now);

                cmd.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@IsShowSpecialRate", item.ShowSpecialRate);
                cmd.Parameters.AddWithValue("@IsNewTestApprove", item.IsNewTestApprove);
                cmd.Parameters.AddWithValue("@IsDirectApprove", item.IsDirectApprove);
                cmd.Parameters.AddWithValue("@ID", item.ID);
                cmd.ExecuteNonQuery();
            }
            tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnexport_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID AS DesignationID,Name AS Designation,SequenceNo AS Priority,IF(IsActive=1,'Active','Deactive')Status FROM f_designation_msater where IsSales=1 order by SequenceNo");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "DesignationMaster";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            }
            else
                lblerrmsg.Text = "No Record Found";
        }
        catch (Exception ex)
        {
            lblerrmsg.Text = ex.Message;
        }
        finally
        {
        }
    }

    public class ItemData
    {
        public string ID { get; set; }
        public string Sequence { get; set; }
        public int ShowSpecialRate { get; set; }
        public int IsDirectApprove { get; set; }
        public int IsNewTestApprove { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string bindAppVerify()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  ct.ID,ct.Type1 Type,sh.Name DesignationName,sh.ID DesignationID,IF(IFNULL(sv.IsVerify,0)=0,0,1)IsVerify,IF(IFNULL(sv.IsApprove,0)=0,0,1)IsApprove,  ");
        sb.Append(" CASE WHEN  IFNULL(sv.IsVerify,0)=0 THEN 0 WHEN sv.IsVerify=1 AND sv.IsApprove=1 THEN 2 WHEN sv.IsVerify=1 THEN 1 END SelectedValue FROM centre_type1master ct   ");
        sb.Append(" CROSS JOIN f_designation_msater sh LEFT JOIN sales_VerificationApprovalMaster sv ON ct.ID=sv.TypeID AND sv.DesignationID=sh.ID  ");

        sb.Append(" WHERE ct.IsActive =1 AND sh.IsActive=1 AND sh.IsSales=1 ORDER BY sh.SequenceNo+0 DESC  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable dtMerge = new DataTable();
        if (dt.Rows.Count > 0)
        {
            dtMerge.Columns.Add("ID");
            dtMerge.Columns.Add("Type");

            DataRow newrow = dtMerge.NewRow();
            foreach (DataRow dr in dt.Rows)
            {
                DataRow[] RowCreated = dtMerge.Select("ID='" + dr["ID"].ToString() + "'");
                if (RowCreated.Length == 0)
                {
                    DataRow[] RowExist = dt.Select("ID='" + dr["ID"].ToString() + "'");
                    if (RowExist.Length > 0)
                    {
                        DataRow row = dtMerge.NewRow();

                        row["ID"] = RowExist[0]["ID"].ToString();
                        row["Type"] = RowExist[0]["Type"].ToString();

                        for (int i = 0; i < RowExist.Length; i++)
                        {
                            if (!dtMerge.Columns.Contains(RowExist[i]["DesignationName"].ToString() + "#" + RowExist[i]["DesignationID"].ToString()))
                            {
                                dtMerge.Columns.Add(RowExist[i]["DesignationName"].ToString() + "#" + RowExist[i]["DesignationID"].ToString());
                            }
                            row[RowExist[i]["DesignationName"].ToString() + "#" + RowExist[i]["DesignationID"].ToString()] = RowExist[i]["SelectedValue"].ToString();
                        }

                        dtMerge.Rows.Add(row);
                    }
                }
            }
        }

        return Util.getJson(dtMerge);
    }

    public class AppVerifyData
    {
        public int TypeID { get; set; }
        public int DesignationID { get; set; }
        public int IsApprove { get; set; }
        public int IsVerify { get; set; }
        public string TypeName { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string saveAppVerify(string AppVerifyDetail)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            List<AppVerifyData> AppVerifyDetails = Serializer.Deserialize<List<AppVerifyData>>(AppVerifyDetail);

            for (int k = 0; k < AppVerifyDetails.Count; k++)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO sales_VerificationApprovalMaster(DesignationID,TypeID,TypeName,IsApprove,IsVerify,CreatedByID,CreatedBy)");
                sb.Append(" VALUES(@DesignationID,@TypeID,@TypeName,@IsApprove,@IsVerify,@CreatedByID,@CreatedBy)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@DesignationID", AppVerifyDetails[k].DesignationID),
                     new MySqlParameter("@TypeID", AppVerifyDetails[k].TypeID), new MySqlParameter("@TypeName", AppVerifyDetails[k].TypeName),
                     new MySqlParameter("@IsApprove", AppVerifyDetails[k].IsApprove), new MySqlParameter("@IsVerify", AppVerifyDetails[k].IsVerify),
                     new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName)

                     );
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
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