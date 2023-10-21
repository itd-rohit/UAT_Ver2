using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Camp_CampConfigurationApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                ddlFinacial.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(FinancialYear,'#',ID,'#',FinancialYearStart,'#',FinancialYearEnd)ID,FinancialYear FROM sales_FinancialYearMaster WHERE IsActive=1").Tables[0];
                ddlFinacial.DataTextField = "FinancialYear";
                ddlFinacial.DataValueField = "ID";
                ddlFinacial.DataBind();
                ddlFinacial.Items.Insert(0, new ListItem("Select", "0"));
                lstClientType.DataSource = getClientType(con, "0");
                lstClientType.DataTextField = "Type1";
                lstClientType.DataValueField = "ID";
                lstClientType.DataBind();
                lstTagBusinessLab.DataSource = getTagBusinesLab(con, "0");
                lstTagBusinessLab.DataTextField = "TagBusinessLab";
                lstTagBusinessLab.DataValueField = "TagBusinessLabID";
                lstTagBusinessLab.DataBind();

                if (checkApprovalRight(con) == 0)
                {
                    lblMsg.Text = "You do not have right to access this page";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "accessRight();", true);
                    return;
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
    }
    public static int checkApprovalRight(MySqlConnection con)
    {
        return Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM camp_approvalright_master WHERE VerificationType='CampConfiguration' AND IsActive=1 AND ApprovalID=@ApprovalID",
                                            new MySqlParameter("@ApprovalID", UserInfo.ID)));
    }
    public static DataTable getClientType(MySqlConnection con, string type)
    {
        using (DataTable ClientType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Type1 FROM centre_type1master WHERE IsActive=1 AND Category='CC'").Tables[0])
        {
            return ClientType;
        }
    }
    public static DataTable getTagBusinesLab(MySqlConnection con, string type)
    {
        using (DataTable ClientType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT TagBusinessLabID,`TagBusinessLab` FROM f_panel_master WHERE IsActive=1 GROUP BY TagBusinessLabID").Tables[0])
        {
            return ClientType;
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindDetail(string FinancialYear, string ClientID, int SearchType, int Status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (checkApprovalRight(con) == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "You do not have right to access this page" });

            }

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fpm.Panel_ID ClientID,fpm.CentreType1 ClientType, fpm.`Panel_Code` ClientCode, fpm.`Company_Name` ClientName, ");
            sb.Append(" IFNULL(ca.FinancialYear,'')FinancialYear,");
            sb.Append(" IFNULL(ca.AprCount,0)Apr,IFNULL(ca.MayCount,0)May,IFNULL(ca.JunCount,0)Jun,IFNULL(ca.JulCount,0)Jul,IFNULL(ca.AugCount,0)Aug,");
            sb.Append(" IFNULL(ca.SepCount,0)Sep,IFNULL(ca.OctCount,0)`Oct`,IFNULL(ca.NovCount,0)Nov,IFNULL(ca.DecCount,0)`Dec`,IFNULL(ca.JanCount,0)Jan, ");
            sb.Append(" IFNULL(ca.FebCount,0)Feb,IFNULL(ca.MarCount,0)Mar,0 Total,IFNULL(ca.IsApproved,0)IsApproved,ca.ID,IFNULL(ca.IsApproved,0)ApprovedStatus, ");
            sb.Append(" IFNULL(fpm.TagBusinessLab,'')TagBusinessLab");
            sb.Append(" FROM `f_panel_master` fpm ");
            sb.Append(" INNER JOIN camp_configurationmaster ca ON ca.Panel_ID=fpm.Panel_ID AND ca.IsActive=1 AND ca.FinancialYearID=@FinancialYear");
            if (Status != -1)
            {
                sb.Append(" AND ca.IsApproved=@IsApproved");
            }
            sb.Append("  WHERE  fpm.`IsActive`=1");
            if (ClientID != string.Empty)
                sb.Append(" AND fpm.Panel_ID IN (" + ClientID + ") ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@FinancialYear", FinancialYear.Split('#')[1]),
                                              new MySqlParameter("@IsApproved", Status)).Tables[0])
            {

                if (dt.Rows.Count > 0)
                {
                    if (SearchType == 0)
                    {
                        DataRow drTotal = dt.NewRow();
                        drTotal[3] = "Total :";
                        drTotal[5] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Apr")).Cast<Int64?>().Sum();
                        drTotal[6] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("May")).Cast<Int64?>().Sum();
                        drTotal[7] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Jun")).Cast<Int64?>().Sum();
                        drTotal[8] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Jul")).Cast<Int64?>().Sum();
                        drTotal[9] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Aug")).Cast<Int64?>().Sum();
                        drTotal[10] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Sep")).Cast<Int64?>().Sum();
                        drTotal[11] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Oct")).Cast<Int64?>().Sum();
                        drTotal[12] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Nov")).Cast<Int64?>().Sum();
                        drTotal[13] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Dec")).Cast<Int64?>().Sum();
                        drTotal[14] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Jan")).Cast<Int64?>().Sum();
                        drTotal[15] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Feb")).Cast<Int64?>().Sum();
                        drTotal[16] = dt.AsEnumerable().Select(tr => tr.Field<Int64>("Mar")).Cast<Int64?>().Sum();
                        drTotal[17] = Util.GetInt(drTotal[5]) + Util.GetInt(drTotal[6])
                            + Util.GetInt(drTotal[7]) + Util.GetInt(drTotal[8]) + Util.GetInt(drTotal[9])
                            + Util.GetInt(drTotal[10]) + Util.GetInt(drTotal[11]) + Util.GetInt(drTotal[12])
                            + Util.GetInt(drTotal[13]) + Util.GetInt(drTotal[14]) + Util.GetInt(drTotal[15]);
                        drTotal[18] = 0;
                        dt.Rows.Add(drTotal);
                        dt.AcceptChanges();
                        return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
                    }
                    else
                    {
                        dt.Columns.Remove("ClientID");
                        dt.Columns.Remove("FinancialYear");
                        HttpContext.Current.Session["dtExport2Excel"] = dt;

                        HttpContext.Current.Session["ReportName"] = string.Concat("CampConfiguration_", FinancialYear.Split('#')[0]);
                        return JsonConvert.SerializeObject(new { status = true, response = "", SearchType = SearchType });
                    }
                }
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found", responseDetail = string.Empty });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetail = string.Empty });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public class CampConfigData
    {
        public int? Apr { get; set; }
        public int? May { get; set; }
        public int? Jun { get; set; }
        public int? Jul { get; set; }
        public int? Aug { get; set; }
        public int? Sep { get; set; }
        public int? Oct { get; set; }
        public int? Nov { get; set; }
        public int? Dec { get; set; }
        public int? Jan { get; set; }
        public int? Feb { get; set; }
        public int? Mar { get; set; }
        public int ID { get; set; }
        public int ClientID { get; set; }
        public int IsApproved { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string ApproveCampConfig(object CampConfigDetail, string FinacialYearDetail)
    {
        List<CampConfigData> CampConfigDetails = new JavaScriptSerializer().ConvertToType<List<CampConfigData>>(CampConfigDetail);

        CampConfigDetails = CampConfigDetails.Where(x => x.IsApproved == 2).ToList();
        if (CampConfigDetails.Count == 0)
            return JsonConvert.SerializeObject(new { status = false, response = "Please Select Client" });

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (checkApprovalRight(con) == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "You do not have right to access this page" });

            }
            string FinacialYear = FinacialYearDetail.Split('#')[0];
            int FinancialYearID = Util.GetInt(FinacialYearDetail.Split('#')[1]);

            List<string> Rows = new List<string>();

            StringBuilder sb = new StringBuilder();
            string Panel_ID = string.Join(",", CampConfigDetails.Select(s => s.ClientID).Distinct().ToArray());


            int approvedCampCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1)  FROM camp_configurationmaster WHERE Panel_ID IN(" + Panel_ID + ") AND FinancialYearID=@FinancialYearID AND IsApproved=1",
                                                            new MySqlParameter("@FinancialYearID", FinancialYearID)));
            if (approvedCampCount > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Some Camp already Approved,Please Search Again" });

            }

            //DataTable campDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Panel_ID,FinancialYear,IsActive,FinancialYearID,`AprCount`,`MayCount`,`JunCount`,`JulCount`,`AugCount`,`SepCount`,`OctCount`,`NovCount`,`DecCount`,`JanCount`,`FebCount`,`MarCount` FROM camp_configurationmaster WHERE  Panel_ID IN(" + Panel_ID + ") AND FinancialYearID=@FinancialYearID",
            //                                   new MySqlParameter("@FinancialYearID", FinancialYearID)).Tables[0];
            for (int i = 0; i < CampConfigDetails.Count; i++)
            {
                //var varOld = campDetail.AsEnumerable().Where(x => (Util.GetInt(x["AprCount"]) != Util.GetInt(CampConfigDetails[i].Apr)
                //                    || (Util.GetInt(x["MayCount"]) != Util.GetInt(CampConfigDetails[i].May))
                //                    || (Util.GetInt(x["JunCount"]) != Util.GetInt(CampConfigDetails[i].Jun))
                //                    || (Util.GetInt(x["JulCount"]) != Util.GetInt(CampConfigDetails[i].Jul))
                //                    || (Util.GetInt(x["AugCount"]) != Util.GetInt(CampConfigDetails[i].Aug))
                //                    || (Util.GetInt(x["SepCount"]) != Util.GetInt(CampConfigDetails[i].Sep))
                //                    || (Util.GetInt(x["OctCount"]) != Util.GetInt(CampConfigDetails[i].Oct))
                //                    || (Util.GetInt(x["NovCount"]) != Util.GetInt(CampConfigDetails[i].Nov))
                //                    || (Util.GetInt(x["DecCount"]) != Util.GetInt(CampConfigDetails[i].Dec))
                //                    || (Util.GetInt(x["JanCount"]) != Util.GetInt(CampConfigDetails[i].Jan))
                //                    || (Util.GetInt(x["FebCount"]) != Util.GetInt(CampConfigDetails[i].Feb))
                //                    || (Util.GetInt(x["MarCount"]) != Util.GetInt(CampConfigDetails[i].Mar))
                //                    ) && Util.GetInt(x["ID"]) == Util.GetInt(CampConfigDetails[i].ID));
                //{
                //    if (varOld.Any())
                //    {
                //        using (DataTable dtCamp = varOld.CopyToDataTable())
                //        {
                sb = new StringBuilder();
                sb.Append("INSERT INTO camp_configurationmasterApproved_log(ID,Panel_ID,FinancialYearID,FinancialYear,IsActive,CreatedByID,CreatedBy,CreatedDate,");
                sb.Append(" AprCount_Request,AprCount_Approve,MayCount_Request,MayCount_Approve,JunCount_Request,JunCount_Approve,JulCount_Request,");
                sb.Append(" JulCount_Approve,AugCount_Request,AugCount_Approve,SepCount_Request,SepCount_Approve,OctCount_Request,OctCount_Approve,");
                sb.Append(" NovCount_Request,NovCount_Approve,DecCount_Request,DecCount_Approve,JanCount_Request,JanCount_Approve,FebCount_Request,");
                sb.Append(" FebCount_Approve,MarCount_Request,MarCount_Approve,IsApproved,ApprovedByID,ApprovedBy,ApprovedDate)");
                sb.Append(" SELECT ID,Panel_ID,FinancialYearID,FinancialYear,IsActive,CreatedByID,CreatedBy,CreatedDate,");
                sb.Append(" AprCount,@AprCount_Approve,MayCount,@MayCount_Approve,JunCount,@JunCount_Approve,JulCount,");
                sb.Append(" @JulCount_Approve,AugCount,@AugCount_Approve,SepCount,@SepCount_Approve,OctCount,@OctCount_Approve,");
                sb.Append(" NovCount,@NovCount_Approve,DecCount,@DecCount_Approve,JanCount,@JanCount_Approve,FebCount,");
                sb.Append(" @FebCount_Approve,MarCount,@MarCount_Approve,1,@ApprovedByID,@ApprovedBy,NOW()");
                sb.Append("");
                sb.Append("");
                sb.Append(" FROM camp_configurationmaster WHERE ID=@ID");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@ID", CampConfigDetails[i].ID),
                            new MySqlParameter("@AprCount_Approve", CampConfigDetails[i].Apr),
                            new MySqlParameter("@MayCount_Approve", CampConfigDetails[i].May),
                            new MySqlParameter("@JunCount_Approve", CampConfigDetails[i].Jun),
                            new MySqlParameter("@JulCount_Approve", CampConfigDetails[i].Jul),
                            new MySqlParameter("@AugCount_Approve", CampConfigDetails[i].Aug),
                            new MySqlParameter("@SepCount_Approve", CampConfigDetails[i].Sep),
                            new MySqlParameter("@OctCount_Approve", CampConfigDetails[i].Oct),
                            new MySqlParameter("@NovCount_Approve", CampConfigDetails[i].Nov),
                            new MySqlParameter("@DecCount_Approve", CampConfigDetails[i].Dec),
                            new MySqlParameter("@JanCount_Approve", CampConfigDetails[i].Jan),
                            new MySqlParameter("@FebCount_Approve", CampConfigDetails[i].Feb),
                            new MySqlParameter("@MarCount_Approve", CampConfigDetails[i].Mar),
                            new MySqlParameter("@ApprovedByID", UserInfo.ID),
                            new MySqlParameter("@ApprovedBy", UserInfo.LoginName));
                //}

                //}
                //}
                sb = new StringBuilder();
                sb.Append(" UPDATE camp_configurationmaster SET IsApproved=1,ApprovedByID=@ApprovedByID,ApprovedDate=NOW(),ApprovedBy=@ApprovedBy, ");
                sb.Append(" `AprCount`=@AprCount,`MayCount`=@MayCount,`JunCount`=@JunCount,`JulCount`=@JulCount,`AugCount`=@AugCount,`SepCount`=@SepCount,");
                sb.Append(" `OctCount`=@OctCount,`NovCount`=@NovCount,`DecCount`=@DecCount,`JanCount`=@JanCount,`FebCount`=@FebCount,`MarCount`=@MarCount");
                sb.Append(" WHERE ID=@ID  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@ID", CampConfigDetails[i].ID),
                            new MySqlParameter("@ApprovedByID", UserInfo.ID),
                            new MySqlParameter("@AprCount", CampConfigDetails[i].Apr),
                            new MySqlParameter("@MayCount", CampConfigDetails[i].May),
                            new MySqlParameter("@JunCount", CampConfigDetails[i].Jun),
                            new MySqlParameter("@JulCount", CampConfigDetails[i].Jul),
                            new MySqlParameter("@AugCount", CampConfigDetails[i].Aug),
                            new MySqlParameter("@SepCount", CampConfigDetails[i].Sep),
                            new MySqlParameter("@OctCount", CampConfigDetails[i].Oct),
                            new MySqlParameter("@NovCount", CampConfigDetails[i].Nov),
                            new MySqlParameter("@DecCount", CampConfigDetails[i].Dec),
                            new MySqlParameter("@JanCount", CampConfigDetails[i].Jan),
                            new MySqlParameter("@FebCount", CampConfigDetails[i].Feb),
                            new MySqlParameter("@MarCount", CampConfigDetails[i].Mar),
                            new MySqlParameter("@ApprovedBy", UserInfo.LoginName));
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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