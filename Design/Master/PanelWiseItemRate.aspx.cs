using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_EDP_PanelWiseItemRate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindgroup();
            BindPanel();
            LoadCategory();
            bindbillingCategory();
        }
    }

    private void bindgroup()
    {
        string str = "SELECT PanelGroupID,PanelGroup FROM f_panelgroup WHERE Active=1 ORDER BY printOrder";
        DataTable dt = StockReports.GetDataTable(str);
        DdlGroup.DataSource = dt;
        DdlGroup.DataTextField = "PanelGroup";
        DdlGroup.DataValueField = "PanelGroupID";
        DdlGroup.DataBind();
    }

    private void BindPanel()
    {
        string str = "SELECT Company_Name,CONCAT(Panel_ID,'#',ReferenceCodeOPD)PanelID FROM f_panel_master WHERE PanelGroupID='" + DdlGroup.SelectedItem.Value + "' AND Panel_ID=ReferenceCodeOPD ORDER BY Company_Name";

        DataTable dtPanel = StockReports.GetDataTable(str);
        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            ddlPanel.DataSource = dtPanel;
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "PanelID";
            ddlPanel.DataBind();
            //ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue("78#78"));
        }
        else
        {
            ddlPanel.Items.Clear();
            ddlPanel.Items.Add("-");
        }

        //Centre.bindPanel(ddlPanel);
    }

    private void LoadCategory()
    {
        string str = "";
        str = "Select DISTINCT(cm.Name),concat(cm.CategoryID,'#',if(cf.ConfigRelationID=3,1,0))CategoryID from f_categorymaster cm inner join f_configrelation cf on cm.categoryid = cf.categoryid where cf.ConfigRelationID in ";
        str = str + "(3,23) order by cm.Name";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("---Select---", "0#"));
        }
    }
    void bindbillingCategory()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Name FROM billingCategory_master where IsActive=1 ORDER BY Name ");
        ddlbillcategory.DataSource = dt;
        ddlbillcategory.DataTextField = "Name";
        ddlbillcategory.DataValueField = "ID";
        ddlbillcategory.DataBind();
        ddlbillcategory.Items.Insert(0, new ListItem("Select", "0"));
    }
    [WebMethod(EnableSession = true)]
    public static string searchdataexcel(string PanelID)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(@" SELECT scm.`Name` Department,im.`TestCode`,im.`TypeName` TestName,IFNULL(inv.`SampleType`,'')SampleType,
            inv.`SampleQty` SampleVolume,IFNULL((SELECT `containername` FROM samplecontainer_master WHERE id=inv.`container`),'')Container,IFNULL(inv.`Temp_Id`,'') Temp,
            IFNULL(rl.`Rate`,'')LabRate,IFNULL(rl1.`Rate`,'')StandardRate,IFNULL(inv.`SampleRemarks`,'')Remarks,inv.tatintimation ReportingTime
            FROM f_itemmaster im
            INNER JOIN `investigation_master` inv ON im.`Type_ID`=inv.`Investigation_Id` AND im.`IsActive`=1
            INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=im.`SubCategoryID`
            LEFT JOIN f_ratelist rl ON rl.`ItemID`=im.`ItemID` AND rl.`Panel_ID`=@Panel_ID
            LEFT JOIN f_ratelist rl1 ON rl1.`ItemID`=im.`ItemID` AND rl1.`Panel_ID`=78 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Panel_ID", PanelID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataColumn column = new DataColumn();
                    column.ColumnName = "S.No";
                    column.DataType = System.Type.GetType("System.Int32");
                    column.AutoIncrement = true;
                    column.AutoIncrementSeed = 0;
                    column.AutoIncrementStep = 1;

                    dt.Columns.Add(column);
                    int index = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        row.SetField(column, ++index);
                    }
                    dt.Columns["S.No"].SetOrdinal(0);

                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "RatelistReport";
                    return JsonConvert.SerializeObject(new { status = true, response = 1 });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found !" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}