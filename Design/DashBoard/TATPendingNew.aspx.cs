using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using MySql.Data.MySqlClient;
using System.Linq;

public partial class Design_Store_MIS_TATPendingNew : System.Web.UI.Page
{

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            dtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            DataTable dt = StockReports.GetDataTable("select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.centreId");
            if (dt.Rows.Count > 0)
            {
                lstCentre.DataSource = dt;
                lstCentre.DataTextField = "Centre";
                lstCentre.DataValueField = "CentreID";
                lstCentre.DataBind();
            }
            BindDepartment();
        }
    }
    private void BindDepartment()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            List<string> ObservationType_ID = Util.GetString(HttpContext.Current.Session["AccessDepartment"]).TrimEnd(',').Split(',').ToList<string>();

            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
            if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != string.Empty)
            {
                sb.Append("  and  SubCategoryID in ({0}) ");
            }
            sb.Append(" ORDER BY NAME");
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", ObservationType_ID)), con))
                {
                    for (int i = 0; i < ObservationType_ID.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@ObservationType_IDParam", i), ObservationType_ID[i]);
                    }
                    da.Fill(dt);
                    sb = new StringBuilder();
                    ObservationType_ID.Clear();
                }
                ddlDepartment.DataSource = dt;
                ddlDepartment.DataTextField = "NAME";
                ddlDepartment.DataValueField = "SubCategoryID";
                ddlDepartment.DataBind();
                ddlDepartment.Items.Insert(0, new ListItem("All Department", string.Empty));
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
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string dtFrom, string dtTo, string CentreID,string UserID, string ReportType, string compare,string Department)
    {
        try
        {
            string _checkSession = Util.GetString(UserInfo.Centre);
        }
        catch
        {
            return "-1";
        }
        if (CentreID != "")
        {
            CentreID = "'" + CentreID + "'";
            CentreID = CentreID.Replace(",", "','");
        } 
        if (UserID != "")
        {
            UserID = "'" + UserID + "'";
            UserID = UserID.Replace(",", "','");
        }
        DataTable dt =new DataTable();
        StringBuilder sb = new StringBuilder();
        if (ReportType == "1")///OUTSide TAT
        {
            sb.AppendLine(@" SELECT 
                       IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > pli.DeliveryDate,'OutSide TAT','') TATDelay,pli.`LedgerTransactionNo`,  Count(distinct pli.Test_ID)TestCount ,                
                        CONCAT(pm.`PName`,'/',pm.age,'/',pm.Gender) AS pattinfo,CONCAT(pm.`Patient_ID`,' / ', pli.`BarcodeNo`)UHID_SINNO,
                        pli.`SubCategoryName` As Dept, GROUP_CONCAT(DISTINCT  im.Name) AS Tests,TIMEDIFF(pli.`DeliveryDate`,IF(pli.Approved=0,NOW(),pli.ApprovedDate)) TimeLeft
                        FROM patient_labinvestigation_opd pli
                        INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID`
                        INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID  AND im.isCulture=0 AND im.ReportType<>7 AND im.ReportType<> 5
                        INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`
                        INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`
                        INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=pli.Investigation_ID ");
            sb.AppendLine(" WHERE pli.`Date`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and pli.`Date`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.AppendLine(" AND IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > pli.DeliveryDate,'1','0') = 1 "); 
              if (Department != string.Empty)
              {
                  sb.AppendLine("  and iot.ObservationType_ID=" + Department + " ");
              }
              else if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != string.Empty)
              {
                  sb.AppendLine("  and iot.ObservationType_ID in (" + Util.GetString(HttpContext.Current.Session["AccessDepartment"]) + ")  ");
              }
            if (CentreID != "")
            {
                sb.AppendLine(" and cm.CentreID IN (" + CentreID + ") ");
            }
            sb.AppendLine("GROUP BY pli.Test_id ORDER BY pli.SRADate DESC,TATDelay DESC, pli.SampleReceiveDate ASC; ");
           
        }
        if (ReportType == "2")///Near TAT
        {
            sb.AppendLine(@" SELECT                         
                          IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF(IF(pli.Approved=0,NOW(),pli.ApprovedDate) > DATE_ADD(pli.DeliveryDate ,INTERVAL im.tatintimation*-1 MINUTE),'Near TAT','')) TATIntimate,   
                            pli.`LedgerTransactionNo`,  Count(distinct pli.Test_ID)TestCount ,                          
                            CONCAT(pm.`PName`,'/',pm.age,'/',pm.Gender) AS pattinfo,CONCAT(pm.`Patient_ID`,' / ', pli.`BarcodeNo`)UHID_SINNO,
                         pli.`SubCategoryName` As Dept,GROUP_CONCAT(DISTINCT  im.Name) AS Tests,TIMEDIFF(pli.`DeliveryDate`,IF(pli.Approved=0,NOW(),pli.ApprovedDate)) TimeLeft
                        FROM patient_labinvestigation_opd pli
                        INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID`
                        INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID  AND im.isCulture=0 AND im.ReportType<>7 AND im.ReportType<> 5
                        INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`
                        INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`
                        INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=pli.Investigation_ID ");
            sb.AppendLine(" WHERE pli.`Date`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and pli.`Date`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.AppendLine(" AND IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF(IF(pli.Approved=0,NOW(),pli.ApprovedDate) > DATE_ADD(pli.DeliveryDate ,INTERVAL im.tatintimation*-1 MINUTE),'1','0')) = 1 ");
            if (Department != string.Empty)
            {
                sb.AppendLine("  and iot.ObservationType_ID=" + Department + " ");
            }
            else if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != string.Empty)
            {
                sb.AppendLine("  and iot.ObservationType_ID in (" + Util.GetString(HttpContext.Current.Session["AccessDepartment"]) + ")  ");
            }
            if (CentreID != "")
            {
                sb.AppendLine(" and cm.CentreID IN (" + CentreID + ") ");
            }
            sb.AppendLine("GROUP BY pli.Test_id ORDER BY pli.SRADate DESC,TATIntimate DESC, pli.SampleReceiveDate ASC; ");
           
        }
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            int TotalTest = Convert.ToInt32(dt.Compute("SUM(TestCount)", string.Empty));
            DataColumn dc = new DataColumn("TotalTestPatient", typeof(Int32));
            dc.DefaultValue = TotalTest;
            dt.Columns.Add(dc);

            int CountPatient = 0;
            var LabNo = "";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Util.GetString(dt.Rows[i]["LedgerTransactionNo"]) != LabNo)
                {
                    CountPatient = CountPatient + 1;
                    LabNo = Util.GetString(dt.Rows[i]["LedgerTransactionNo"]);
                }
            }
            DataColumn dc1 = new DataColumn("TotalTest", typeof(Int32));
            dc1.DefaultValue = CountPatient;
            dt.Columns.Add(dc1);
        }
        return JsonConvert.SerializeObject(new { status = true, response = dt });
     

    }
    public static DataTable changedatatableMIS(DataTable dt)
    {
        DataTable dtnew = new DataTable();
        DataView view = new DataView(dt);
        view.Sort = "RegBy asc";
        DataTable distinctuserValues = view.ToTable(true, "RegBy");
        DataView view1 = new DataView(dt);
        DataTable distinctstatusValues = view1.ToTable(true, "Status");
        dtnew.Columns.Add("User");
        foreach (DataRow dw in distinctstatusValues.Rows)
        {
            dtnew.Columns.Add(dw["Status"].ToString());
            dtnew.Columns[dw["Status"].ToString()].DataType = typeof(int);
        }
        
        foreach (DataRow du in distinctuserValues.Rows)
        {
            DataRow rr = dtnew.NewRow();
            foreach (DataColumn dc1 in dtnew.Columns)
            {
                string nn = dc1.ToString();
                if (dc1.ToString() == "User")
                {
                    rr[dc1] = du["RegBy"].ToString();
                }
                else
                {
                    rr[dc1] = 0; 
                }
            }
            dtnew.Rows.Add(rr);
        }
        for (int k = 1; k < dtnew.Columns.Count; k++)
        {
            for (int i = 0; i < dtnew.Rows.Count; i++)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if ((dt.Rows[j]["Status"].ToString()) == dtnew.Columns[k].ToString())
                    {
                        if (dtnew.Rows[i]["User"].ToString() == dt.Rows[j]["RegBy"].ToString())
                        {
                            dtnew.Rows[i][dtnew.Columns[k].ToString()] = dt.Rows[j]["StatusCount"].ToString();
                        }

                    }

                }
            }
        }
        dtnew.AcceptChanges();
        return dtnew;
    }
    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }

    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        string CentreID = ""; //GetSelection(lstCentre);
       
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();

        if (ddlReportType.SelectedItem.Value.ToString() == "1")///OUTSide TAT
        {
            sb.AppendLine(@"SELECT 
                       IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > pli.DeliveryDate,'OutSide TAT','') TATDelay, pli.`LedgerTransactionNo`,  Count(distinct pli.Test_ID)TestCount ,                   
                        CONCAT(pm.`PName`,'/',pm.age,'/',pm.Gender) AS pattinfo,CONCAT(pm.`Patient_ID`,' / ', pli.`BarcodeNo`)UHID_SINNO,
                       pli.`SubCategoryName` As Dept, GROUP_CONCAT(DISTINCT  im.Name) AS Tests,TIMEDIFF(pli.`DeliveryDate`,IF(pli.Approved=0,NOW(),pli.ApprovedDate)) TimeLeft
                        FROM patient_labinvestigation_opd pli
                        INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID`
                        INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID  AND im.isCulture=0 AND im.ReportType<>7 AND im.ReportType<> 5
                        INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`
                        INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`
                        INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=pli.Investigation_ID ");
            sb.AppendLine(" WHERE  pli.`Date`>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  pli.`Date`<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.AppendLine(" AND IF( IF(pli.Approved=0,NOW(),pli.ApprovedDate) > pli.DeliveryDate,'1','0') = 1 ");
            if (ddlDepartment.SelectedItem.Value.ToString() != string.Empty)
            {
                sb.AppendLine("  and iot.ObservationType_ID=" + ddlDepartment.SelectedItem.Value.ToString() + " ");
            }
            else if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != string.Empty)
            {
                sb.AppendLine("  and iot.ObservationType_ID in (" + Util.GetString(HttpContext.Current.Session["AccessDepartment"]) + ")  ");
            }

            if (CentreID != "")
            {
                sb.AppendLine(" and cm.CentreID IN (" + CentreID + ") ");
            }
            sb.AppendLine("GROUP BY pli.Test_id ORDER BY pli.SRADate DESC,TATDelay DESC, pli.SampleReceiveDate ASC; ");
           
        }
        if (ddlReportType.SelectedItem.Value.ToString() == "2")///Near TAT
        {
            sb.AppendLine(@"SELECT 
                       IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF(IF(pli.Approved=0,NOW(),pli.ApprovedDate) > DATE_ADD(pli.DeliveryDate ,INTERVAL im.tatintimation*-1 MINUTE),'Near TAT','')) TATIntimate,                   
                       pli.`LedgerTransactionNo`,  Count(distinct pli.Test_ID)TestCount ,  
                        CONCAT(pm.`PName`,'/',pm.age,'/',pm.Gender) AS pattinfo,CONCAT(pm.`Patient_ID`,' / ', pli.`BarcodeNo`)UHID_SINNO,
                       pli.`SubCategoryName` As Dept,  GROUP_CONCAT(DISTINCT  im.Name) AS Tests,TIMEDIFF(pli.`DeliveryDate`,IF(pli.Approved=0,NOW(),pli.ApprovedDate)) TimeLeft
                        FROM patient_labinvestigation_opd pli
                        INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID`
                        INNER JOIN `investigation_master` im ON im.investigation_ID=pli.investigation_ID  AND im.isCulture=0 AND im.ReportType<>7 AND im.ReportType<> 5
                        INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`
                        INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`
                        INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=pli.Investigation_ID ");
            sb.AppendLine(" WHERE  pli.`Date`>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  pli.`Date`<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.AppendLine(" and IF(pli.`DeliveryDate`='0001-01-01 00:00:00','0',IF(IF(pli.Approved=0,NOW(),pli.ApprovedDate) > DATE_ADD(pli.DeliveryDate ,INTERVAL im.tatintimation*-1 MINUTE),'1','0')) = 1 ");
            if (ddlDepartment.SelectedItem.Value.ToString() != string.Empty)
            {
                sb.AppendLine("  and iot.ObservationType_ID=" + ddlDepartment.SelectedItem.Value.ToString() + " ");
            }
            else if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != string.Empty)
            {
                sb.AppendLine("  and iot.ObservationType_ID in (" + Util.GetString(HttpContext.Current.Session["AccessDepartment"]) + ")  ");
            }
            if (CentreID != "")
            {
                sb.AppendLine(" and cm.CentreID IN (" + CentreID + ") ");
            }
            sb.AppendLine("GROUP BY pli.Test_id ORDER BY pli.SRADate DESC,TATIntimate DESC, pli.SampleReceiveDate ASC; ");
          
        }

        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            int TotalTest = Convert.ToInt32(dt.Compute("SUM(TestCount)", string.Empty));
            DataColumn dc = new DataColumn("TotalTestPatient", typeof(Int32));
            dc.DefaultValue = TotalTest;
            dt.Columns.Add(dc);

            int CountPatient = 0;
            var LabNo = "";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (Util.GetString(dt.Rows[i]["LedgerTransactionNo"]) != LabNo)
                {
                    CountPatient = CountPatient + 1;
                    LabNo = Util.GetString(dt.Rows[i]["LedgerTransactionNo"]);
                }
            }
            DataColumn dc1 = new DataColumn("TotalTest", typeof(Int32));
            dc1.DefaultValue = CountPatient;
            dt.Columns.Add(dc1);
        }
        Session["ReportName"] = "TAT Pending Report";
        Session["dtExport2Excel"] = dt;
        Session["Period"] = " From : " + dtFrom.Text + " To : " + dtTo.Text;

        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Common/ExportToExcel.aspx');", true);
    }
    private string GetSelection(ListBox cbl)
    {
        string str = "";

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
}