using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_StockStatusReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindalldata();
        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();
            //ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
        }
    }
    [WebMethod(EnableSession = true)]
    public static string binditem(string CategoryTypeId, string SubCategoryTypeId, string CategoryId, string LocationID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT st.ItemId,typename ItemName FROM st_itemmaster st ");
        if (LocationID != "")
        {
            sb.Append(" inner join st_mappingitemmaster sm on sm.itemid=st.itemid ");
            sb.Append("  and sm.locationid='" + LocationID.Split('#')[0] + "' ");
        }
        sb.Append(" WHERE CategoryTypeID IN(" + CategoryTypeId + ")");
        if (SubCategoryTypeId != "")
            sb.Append(" AND SubCategoryTypeID IN(" + SubCategoryTypeId + ") ");
        if (CategoryId != "")
            sb.Append(" AND SubCategoryID IN(" + CategoryId + ") ");

        sb.Append("  and st.isactive=1 and approvalstatus=2  group by st.itemid order by typename");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string getreport(string location, string Items, string manu, string machine, string reportType)
    {
        string ReportPath = string.Empty;
       
        if (reportType == "PDF")
        {
            ReportPath = "StockStatusReportPDF.aspx";
        }
        else
        {
            ReportPath = "../Common/ExportToExcelEncrypt.aspx";
        }
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,            
                ItemID = Common.EncryptRijndael(Util.GetString(Items)),
                ManufactureID = Common.EncryptRijndael(manu),
                MacID = Common.EncryptRijndael(machine),
                LocationID = Common.EncryptRijndael(location),
                ReportType = Common.EncryptRijndael("StockStatus"),
                ReportDisplayName= Common.EncryptRijndael("Stock Status Report"),
                IsAutoIncrement = Common.EncryptRijndael("1"),
                ReportPath = ReportPath
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false

            });
        }
    }
  

}