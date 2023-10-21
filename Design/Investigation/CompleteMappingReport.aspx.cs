using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_CompleteMappingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindMachine();
            BindCenter();
            BindDepartment();
        }
    }

    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

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

    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        string chkCenter = GetSelection(chklstCenter);
        string chkDepartment = GetSelection(chklstDept);
        string chkMachine = GetSelection(chklstMac);
        if (chkCenter == "")
        {
            lblMsg.Text = "!!! Please Select Centre !!!";
            return;
        }

        if (chkDepartment == "")
        {
            lblMsg.Text = "!!! Please Select Department !!!";
            return;
        }

        if (chkMachine == "")
        {
            lblMsg.Text = "!!! Please Select Machine !!!";
            return;
        }
        lblMsg.Text = "";

        sb.Append(" SELECT cm.Centre Centre,im.ItemID AS TestCode,inv.Investigation_Id,inv.Name AS Investigation,lom.Name AS Observation, '' Interpretation,'' ObsInterpretation,'" + rblInter.SelectedValue + "' as ShowInter , ");
        sb.Append(" lor.FromAge,lor.ToAge,lor.MaxReading,lor.MinReading,lor.MinCritical,lor.MaxCritical,lor.AutoApprovedMin,lor.AutoApprovedMax,lor.AMRMin,lor.AMRMax,lor.ReadingFormat AS Unit,lor.MethodName  AS Method, ");
        sb.Append(" lor.Gender,lor.DisplayReading,mm.Name AS Machine FROM investigation_master inv ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.Type_ID=inv.Investigation_Id  ");
        sb.Append(" and im.SubCategoryID  IN (" + chkDepartment + ")  and  im.SubCategoryID<>'LSHHI44'  AND im.IsActive=1 and inv.Name<>''   ");
        sb.Append(" INNER JOIN labobservation_investigation loi ON loi.Investigation_Id=inv.Investigation_Id ");
        sb.Append(" INNER JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
        sb.Append(" LEFT JOIN labobservation_range lor ON lor.LabObservation_ID=lom.LabObservation_ID ");
        if (rblGender.SelectedValue != "Both")
        {
            sb.Append("  and lor.Gender='" + rblGender.SelectedValue + "' ");
        }
        sb.Append(" INNER JOIN macmaster mm ON mm.ID=lor.MacID and lor.MacID in (" + chkMachine + ")");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreID=lor.`CentreID` and cm.CentreID in (" + chkCenter + ") ");
        sb.Append(" WHERE inv.Name<>''  ");
        sb.Append(" ORDER BY inv.Name,loi.printOrder,lor.MacID,lom.Name,lor.Gender,lor.FromAge; ");


        if (rblReportFormate.SelectedValue != "PDF")
        {
            string period = "";// string.Concat("From : ", Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy"));
            AllLoad_Data.exportToExcel(sb.ToString(), "Complete Mapping Report", period, "1", this.Page);
        }
        else
        {
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                if (rblReportFormate.SelectedValue == "PDF")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());

                    // ds.WriteXmlSchema(@"D:\CompleteMappingReport.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "CompleteMappingReport";
                    lblMsg.Text = "Total Record " + Util.GetString(dt.Rows.Count);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                }
                //else
                //{
                //    Session["ReportName"] = "CompleteMappingReport";
                //    Session["Period"] = "";
                //    Session["dtExport2Excel"] = dt;

                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                //}
            }
            else
            {
                lblMsg.Text = "No Record Found..";
            }
        }
    }

    public void BindCenter()
    {
        

        using (DataTable dt = StockReports.GetDataTable("select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' and AccessType=2 ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  "))
        {
            chklstCenter.DataSource = dt;
            chklstCenter.DataTextField = "Centre";
            chklstCenter.DataValueField = "CentreID";
            chklstCenter.DataBind();
        }
    }

    public void BindDepartment()
    {
     

        using (DataTable dt = StockReports.GetDataTable("SELECT SubcategoryID,NAME FROM f_subcategorymaster WHERE active=1 AND SubcategoryID<>'LSHHI44' AND CategoryID='LSHHI3' order by name"))
        {
            chklstDept.DataSource = dt;
            chklstDept.DataTextField = "NAME";
            chklstDept.DataValueField = "SubcategoryID";
            chklstDept.DataBind();
        }
    }

    public void BindMachine()
    {
        
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,NAME FROM macmaster ORDER BY ID"))
        {
            chklstMac.DataSource = dt;
            chklstMac.DataTextField = "NAME";
            chklstMac.DataValueField = "ID";
            chklstMac.DataBind();
        }
    }

    protected void btnInterpretationReport_Click(object sender, EventArgs e)
    {
        string chkDepartment = GetSelection(chklstDept);
        if (chkDepartment.Trim() != "")
        {
            Session["DeptIDs"] = "";
            Session["DeptIDs"] = chkDepartment;
            //  Response.Redirect("InterpretationReport.aspx");
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "window.open('../../Design/Investigation/InterpretationReport.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "alert('Kindly Select Any Department....!');", true);
        }
    }

    protected void btnTemplate_Click(object sender, EventArgs e)
    {
        string chkDepartment = AllLoad_Data.GetSelection(chklstDept);
        if (chkDepartment.Trim() != "")
        {
            Session["DeptIDs"] = "";
            Session["DeptIDs"] = chkDepartment;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "window.open('../../Design/Investigation/template.aspx');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "alert('Kindly Select Any Department....!');", true);
        }
    }
}