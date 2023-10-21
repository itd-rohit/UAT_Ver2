using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_TATReportGraph : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            bindCenterChl();
            BindDepartment();
            btnshowtest.Enabled = false;
        }
       // BindTestName();
    }
    public void bindCenterChl()
    {
       DataTable dt = AllLoad_Data.getCentreByLogin();
        if (dt.Rows.Count > 0)
        {
            ChlCenters.DataSource = dt;
            ChlCenters.DataTextField = "Centre";
            ChlCenters.DataValueField = "CentreID";
            ChlCenters.DataBind();
        }
    }
    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
       
        sb.Append(" where ot.isActive=1  ORDER BY ot.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            cbDepatment.DataSource = dt;
            cbDepatment.DataValueField = "ObservationType_ID";
            cbDepatment.DataTextField = "Name";
            cbDepatment.DataBind();
        }
    }
    private void BindTestName()
    {
       string department= StockReports.GetSelection(cbDepatment);
       lblMsg.Text = "";
       if (department == "")
       {
           lblMsg.Text = "Please Select Department..!";
           return;
       }
       StringBuilder sb = new StringBuilder();
       sb.Append(" SELECT inv.Name,inv.Investigation_Id FROM investigation_master inv ");
       sb.Append(" INNER JOIN  investigation_observationtype io ON io.Investigation_ID=inv.Investigation_Id  AND io.ObservationType_Id IN (" + department + ") ");
       sb.Append(" INNER JOIN f_itemmaster im ON im.Type_ID=inv.Investigation_Id  and isactive=1 ");
       sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID AND sc.CategoryID='LSHHI3' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        cblTest.DataSource = dt;

        cblTest.DataTextField = "Name";
        cblTest.DataValueField = "Investigation_Id";
        cblTest.DataBind();

    }

    protected void btnshowtest_Click(object sender, EventArgs e)
    {
        BindTestName();
    }
    protected void rptype_SelectedIndexChanged(object sender, EventArgs e)
    {
        cblTest.Items.Clear();
        if (rptype.SelectedValue == "1")
        {
            btnshowtest.Enabled = false;
            
        }
        else if (rptype.SelectedValue == "2")
        {
            btnshowtest.Enabled = true;
        }
        else
        {
            btnshowtest.Enabled = false;
        }
    }
    public DataTable getdepatwisedt()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Department");
        dt.Columns.Add("Investigation");
        dt.Columns.Add("TATInTime", typeof(int));
        dt.Columns.Add("TATBeyondTime", typeof(int));
        dt.Columns.Add("MasterNotDefined", typeof(int));
        dt.Columns.Add("TotalTest", typeof(int));

        return dt;
    }
    public DataTable getdepatinvwisedt()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Department");
        dt.Columns.Add("Investigation");
        dt.Columns.Add("TATInTime", typeof(int));
        dt.Columns.Add("TATBeyondTime", typeof(int));
        dt.Columns.Add("MasterNotDefined", typeof(int));
        dt.Columns.Add("TotalTest", typeof(int));
        return dt;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            string centername = AllLoad_Data.GetSelection(ChlCenters);
            lblMsg.Text = "";
            if (rptype.SelectedValue == "1")
            {
                DataTable dtdept = new DataTable();
                DataTable dtdeptwise = getdepatwisedt();
                string department = AllLoad_Data.GetSelection(cbDepatment);
                if (department == "")
                {
                    lblMsg.Text = "Please select Department..!";
                    return;
                }

                sb = new StringBuilder();
                sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM observationtype_master ot where ot.ObservationType_ID in (" + department + ") order by name ");
                dtdept = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];


                foreach (DataRow dw in dtdept.Rows)
                {
                    DataRow dwde = dtdeptwise.NewRow();
                    dwde["Department"] = dw["name"].ToString();

                    sb = new StringBuilder();
                    sb.Append("SELECT COUNT(*) FROM patient_labinvestigation_opd plo ");
                    sb.Append("INNER JOIN  investigation_observationtype io ON io.Investigation_ID=plo.Investigation_Id AND io.ObservationType_Id='" + dw["ObservationType_ID"].ToString() + "' ");
                    sb.Append(" INNER  JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo ");
                    if (centername != "")
                    {
                        sb.Append(" and lt.CentreId in (" + centername + ") ");
                    }

                    sb.Append("where  plo.Approveddate<=plo.DeliveryDate AND Approved=1 and plo.DeliveryDate <>'0001-01-01 00:00:00' ");
                    sb.Append(" and plo.date>= @fromdate and plo.date<= @todate");
                    dwde["TATInTime"] = MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                        new MySqlParameter("@todate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));


                    sb = new StringBuilder();
                    sb.Append("SELECT COUNT(*) FROM patient_labinvestigation_opd plo ");
                    sb.Append("INNER JOIN  investigation_observationtype io ON io.Investigation_ID=plo.Investigation_Id AND io.ObservationType_Id='" + dw["ObservationType_ID"].ToString() + "' ");

                    sb.Append(" INNER  JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo ");
                    if (centername != "")
                    {
                        sb.Append(" and lt.CentreId in (" + centername + ") ");
                    }

                    sb.Append("where  plo.Approveddate>plo.DeliveryDate AND Approved=1 and  plo.DeliveryDate <>'0001-01-01 00:00:00' ");
                    sb.Append(" and plo.date>= @fromdate and plo.date<= @todate");
                    dwde["TATBeyondTime"] = MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                        new MySqlParameter("@todate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));


                    sb = new StringBuilder();
                    sb.Append("SELECT COUNT(*) FROM patient_labinvestigation_opd plo ");
                    sb.Append("INNER JOIN  investigation_observationtype io ON io.Investigation_ID=plo.Investigation_Id AND io.ObservationType_Id='" + dw["ObservationType_ID"].ToString() + "' ");
                    sb.Append(" INNER  JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo ");
                    if (centername != "")
                    {
                        sb.Append(" and lt.CentreId in (" + centername + ") ");
                    }


                    sb.Append("where   Approved=1 and  plo.DeliveryDate ='0001-01-01 00:00:00' ");
                    sb.Append(" and plo.date>= @fromdate and plo.date<= @todate");
                    dwde["MasterNotDefined"] = MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                        new MySqlParameter("@todate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));

                    int total = Util.GetInt(dwde["TATBeyondTime"]) + Util.GetInt(dwde["TATInTime"]) + Util.GetInt(dwde["MasterNotDefined"]);
                    dwde["TotalTest"] = total.ToString();
                    if (total > 0)
                    {
                        dtdeptwise.Rows.Add(dwde);
                    }
                }
                if (dtdeptwise.Rows.Count > 0)
                {
                    DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
                    dc.DefaultValue = "From Date : " + txtfromdate.Text + " To Date :" + txttodate.Text;
                    dtdeptwise.Columns.Add(dc);
                    Session["TATGraph"] = dtdeptwise;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('TATGraph.aspx');", true);
                }
                else
                {
                    lblMsg.Text = "No Data Found..!";
                }
            }
            else if (rptype.SelectedValue == "2")
            {
                string investigation = StockReports.GetSelection(cblTest);
                if (investigation == "")
                {
                    lblMsg.Text = "Please Select Test..!";
                    return;
                }

                sb = new StringBuilder();
                sb.Append("  SELECT DISTINCT ot.name department ,im.Name,im.Investigation_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
                sb.Append("  ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id where im.investigation_id in(" + investigation + ")");
                sb.Append("  ORDER BY ot.name ,im.name ");
                DataTable dtdept = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
                DataTable dtdeptitemwise = getdepatinvwisedt();

                foreach (DataRow dw in dtdept.Rows)
                {
                    DataRow dwde = dtdeptitemwise.NewRow();
                    dwde["Department"] = dw["department"].ToString();
                    dwde["Investigation"] = dw["Name"].ToString();

                    sb = new StringBuilder();
                    sb.Append("SELECT COUNT(*) FROM patient_labinvestigation_opd plo ");
                    sb.Append(" INNER  JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo ");
                    if (centername != "")
                    {
                        sb.Append(" and lt.CentreId in (" + centername + ") ");
                    }


                    sb.Append("where plo.investigation_id='" + dw["Investigation_ID"].ToString() + "' ");
                    sb.Append("and  plo.Approveddate<=plo.DeliveryDate AND Approved=1 and plo.DeliveryDate <>'0001-01-01 00:00:00' ");
                    sb.Append(" and plo.date>=@fromdate and plo.date<=@todate");
                    dwde["TATInTime"] = MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                        new MySqlParameter("@todate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));

                    sb = new StringBuilder();
                    sb.Append("SELECT COUNT(*) FROM patient_labinvestigation_opd plo ");

                    sb.Append(" INNER  JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo ");
                    if (centername != "")
                    {
                        sb.Append(" and lt.CentreId in (" + centername + ") ");
                    }


                    sb.Append("where plo.investigation_id='" + dw["Investigation_ID"].ToString() + "' ");
                    sb.Append("and  plo.Approveddate>plo.DeliveryDate AND Approved=1 and plo.DeliveryDate <>'0001-01-01 00:00:00' ");
                    sb.Append(" and plo.date>= @fromdate and plo.date<= @todate");
                    dwde["TATBeyondTime"] = MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                        new MySqlParameter("@todate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));

                    sb = new StringBuilder();
                    sb.Append("SELECT COUNT(*) FROM patient_labinvestigation_opd plo ");

                    sb.Append(" INNER  JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo ");
                    if (centername != "")
                    {
                        sb.Append(" and lt.CentreId in (" + centername + ") ");
                    }


                    sb.Append("where plo.investigation_id='" + dw["Investigation_ID"].ToString() + "' ");
                    sb.Append(" AND Approved=1 and plo.DeliveryDate ='0001-01-01 00:00:00' ");
                    sb.Append(" and plo.date>= @fromdate and plo.date<= @todate");
                    dwde["MasterNotDefined"] = MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                        new MySqlParameter("@todate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));

                    int total = Util.GetInt(dwde["TATBeyondTime"]) + Util.GetInt(dwde["TATInTime"]) + Util.GetInt(dwde["MasterNotDefined"]);
                    dwde["TotalTest"] = total.ToString();
                    if (total > 0)
                    {
                        dtdeptitemwise.Rows.Add(dwde);
                    }
                }
                if (dtdeptitemwise.Rows.Count > 0)
                {
                    DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
                    dc.DefaultValue = "From Date : " + txtfromdate.Text + " To Date :" + txttodate.Text;
                    dtdeptitemwise.Columns.Add(dc);
                    Session["TATGraph"] = dtdeptitemwise;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('TATGraph.aspx');", true);
                }
                else
                {
                    lblMsg.Text = "No Data Found..!";
                }

            }
        }
        catch (Exception ex)
        {
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}