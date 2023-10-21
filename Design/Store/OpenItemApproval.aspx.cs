using System;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_OpenItemApproval : System.Web.UI.Page
{
    public string approvaltypemaker = "0";
    public string approvaltypechecker = "0";
    public string approvaltypeapproval = "0";
    public string itemgorupid = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            itemgorupid = Request.QueryString["itemgroupid"].ToString();
            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='IM' AND employeeid='" + UserInfo.ID + "' ");
            if (dt != "0")
            {
                if (dt.Contains("Checker"))
                {
                    approvaltypechecker = "1";
                }
                if (dt.Contains("Approval"))
                {
                    approvaltypeapproval = "1";
                }
                if (dt.Contains("Maker"))
                {
                    approvaltypemaker = "1";
                }


            }

        }

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindSavedManufacture(string itemid)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ApprovalStatus,case when ApprovalStatus=0 then 'bisque' when ApprovalStatus=1 then 'pink' when ApprovalStatus=2 then 'lightgreen'  end rowcolor, ItemId,ManufactureID,ManufactureName,CatalogNo,MachineID,isactive");
        sb.Append(" ,typename,MachineName,MajorUnitId,MajorUnitName,PackSize, Converter,IssueMultiplier,MinorUnitId,MinorUnitName ,barcodeoption,`BarcodeGenrationOption`");
        sb.Append("  FROM st_itemmaster where ItemIdGroup='" + itemid + "' and isactive=1  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

}