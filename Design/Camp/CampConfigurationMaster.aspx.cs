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

public partial class Design_Camp_CampConfigurationMaster : System.Web.UI.Page
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
    public static DataTable getClientType(MySqlConnection con, string type)
    {
        using (DataTable ClientType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Type1 FROM centre_type1master WHERE IsActive=1 AND ID!=7").Tables[0])
        {
            return ClientType;
        }
    }
    public static DataTable getTagBusinesLab(MySqlConnection con, string type)
    {
        using (DataTable ClientType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT TagBusinessLabID,`TagBusinessLab` FROM f_panel_master WHERE IsActive=1 and TagBusinessLab!='' GROUP BY TagBusinessLabID").Tables[0])
        {
            return ClientType;
        }
    }
    [WebMethod]
    public static string bindClient(int BusinessZoneID, string StateID, string ClientTypeID, string TagBusinessLabID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fpm.Panel_ID ClientID,CONCAT(fpm.`Panel_Code`,' ~ ', fpm.`Company_Name`)ClientName  ");
            sb.Append(" FROM `f_panel_master` fpm  ");
            sb.Append(" WHERE fpm.IsActive=1 AND fpm.PanelType='Centre'");
          //  if (BusinessZoneID != 0)
          //  {
          //      sb.Append(" AND fpm.BusinessZoneID=@BusinessZoneID");
          //  }
          //  if (StateID != "-1" && StateID != null)
          //  {
          //      sb.Append("  AND fpm.StateID=@StateID ");
          //  }
          //  if (ClientTypeID != string.Empty)
          //  {
             //   sb.Append(" AND fpm.CentreType1ID IN(" + ClientTypeID + ")");
          //  }
           // if (TagBusinessLabID != string.Empty)
           // {
          //      sb.Append(" AND fpm.TagBusinessLabID IN(" + TagBusinessLabID + ")");
           // }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                                             // new MySqlParameter("@BusinessZoneID", BusinessZoneID),
                                             // new MySqlParameter("@StateID", StateID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, responseDetail = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, responseDetail = string.Empty });
            }
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
    public static string bindDetail(string FinancialYear, string ClientID, int SearchType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fpm.Panel_ID ClientID,fpm.CentreType1 ClientType, fpm.`Panel_Code` ClientCode, fpm.`Company_Name` ClientName, ");
            sb.Append(" IFNULL(ca.FinancialYear,'')FinancialYear,");
            sb.Append(" IFNULL(ca.AprCount,31)Apr,IFNULL(ca.MayCount,31)May,IFNULL(ca.JunCount,31)Jun,IFNULL(ca.JulCount,31)Jul,IFNULL(ca.AugCount,31)Aug,");
            sb.Append(" IFNULL(ca.SepCount,31)Sep,IFNULL(ca.OctCount,31)`Oct`,IFNULL(ca.NovCount,31)Nov,IFNULL(ca.DecCount,31)`Dec`,IFNULL(ca.JanCount,31)Jan, ");
            sb.Append(" IFNULL(ca.FebCount,31)Feb,IFNULL(ca.MarCount,31)Mar,372 Total,IFNULL(fpm.TagBusinessLab,'')TagBusinessLab,IFNULL(ca.IsApproved,0) ApprovedStatus ");
            sb.Append(" ");
            sb.Append(" FROM `f_panel_master` fpm ");
            sb.Append(" LEFT JOIN camp_configurationmaster ca ON ca.Panel_ID=fpm.Panel_ID AND ca.IsActive=1 AND ca.FinancialYearID=@FinancialYear");
            sb.Append("  WHERE  fpm.`IsActive`=1");
            if (ClientID != string.Empty)
                sb.Append(" AND fpm.Panel_ID IN (" + ClientID + ") ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@FinancialYear", FinancialYear.Split('#')[1])).Tables[0])
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
                        drTotal[18] = string.Empty;
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
        public string ID { get; set; }
        public int ClientID { get; set; }
        public int ApprovedStatus { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveCampConfig(object CampConfigDetail, string FinacialYearDetail)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string FinacialYear = FinacialYearDetail.Split('#')[0];
            int FinancialYearID = Util.GetInt(FinacialYearDetail.Split('#')[1]);

            List<string> Rows = new List<string>();

            List<CampConfigData> CampConfigDetails = new JavaScriptSerializer().ConvertToType<List<CampConfigData>>(CampConfigDetail);
            CampConfigDetails.RemoveAll(r => r.Apr == 0 && r.Mar == 0 && r.Jun == 0 && r.Jul == 0 && r.Aug == 0 && r.Sep == 0 && r.Oct == 0 && r.Nov == 0 && r.Dec == 0 && r.Jan == 0 && r.Feb == 0 && r.Mar == 0);
            
            if (CampConfigDetails.Count == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Please Enter Camp Configuration Count" });
            }
            CampConfigDetails.RemoveAll(r => r.ApprovedStatus == 1);
            if (CampConfigDetails.Count == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Allready All Camp Configuration Approved" });
            }

            string Panel_ID = string.Join(",", CampConfigDetails.Select(s => s.ClientID).Distinct().ToArray());

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM camp_configurationmaster WHERE Panel_ID IN(" + Panel_ID + ") AND FinancialYearID=@FinancialYearID",
                        new MySqlParameter("@FinancialYearID", FinancialYearID));

            StringBuilder sCommand = new StringBuilder("INSERT INTO camp_configurationmaster (Panel_ID,FinancialYear,IsActive,CreatedByID,CreatedBy,FinancialYearID,`AprCount`,`MayCount`,`JunCount`,`JulCount`,`AugCount`,`SepCount`,`OctCount`,`NovCount`,`DecCount`,`JanCount`,`FebCount`,`MarCount`) VALUES ");

            for (int i = 0; i < CampConfigDetails.Count; i++)
            {
                Rows.Add(string.Format("({0},'{1}',{2},{3},'{4}',{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17})",
                                       CampConfigDetails[i].ClientID,
                                       FinacialYear,
                                       1,
                                       UserInfo.ID,
                                       UserInfo.LoginName,
                                       FinancialYearID,
                                       CampConfigDetails[i].Apr,
                                       CampConfigDetails[i].May,
                                       CampConfigDetails[i].Jun,
                                       CampConfigDetails[i].Jul,
                                       CampConfigDetails[i].Aug,
                                       CampConfigDetails[i].Sep,
                                       CampConfigDetails[i].Oct,
                                       CampConfigDetails[i].Nov,
                                       CampConfigDetails[i].Dec,
                                       CampConfigDetails[i].Jan,
                                       CampConfigDetails[i].Feb,
                                       CampConfigDetails[i].Mar
                                       ));
            }
            sCommand.Append(string.Join(",", Rows));
            sCommand.Append(";");
            using (MySqlCommand myCmd = new MySqlCommand(sCommand.ToString(), con, tnx))
            {
                myCmd.CommandType = CommandType.Text;
                myCmd.ExecuteNonQuery();
            }

            tnx.Commit();
            Rows.Clear();
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