using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_DownloadConcentForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string BindData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT GROUP_CONCAT(IM.Name) Investigations,ICF.ConcentFormName ConcernForm, CONCAT('Design/ConcentForm/',ICF.FileName) AS FileName  ");
        sb.Append(" FROM investigation_concentform ICF ");
        sb.Append(" INNER JOIN investigation_concernform CONL ON ICF.ConcentFormName=CONL.ConcernForm ");
        sb.Append(" INNER JOIN investigation_master IM ON IM.Investigation_Id=CONL.InvestigationId ");
        sb.Append(" GROUP BY ICF.ConcentFormName ORDER BY ICF.ConcentFormName ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }





}