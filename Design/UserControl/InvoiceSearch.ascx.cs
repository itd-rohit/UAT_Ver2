using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_UserControl_InvoiceSearch : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
    }
    [WebMethod]
    public static string bindPanel(int BusinessZoneID, int StateID, int? CityID, int SearchType)
    {
        StringBuilder sb = new StringBuilder();
        if (SearchType == 1 || SearchType == 3)
        {
            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
            sb.Append(" WHERE  cm.BusinessZoneID='" + BusinessZoneID + "' ");
            if (StateID != -1)
                sb.Append("  AND cm.StateID='" + StateID + "' ");
            if (CityID != -1)
                sb.Append(" AND cm.CityID='" + CityID + "'  ");
            sb.Append("    AND fpm.Panel_ID=fpm.InvoiceTo   ");
            if (SearchType == 1)
                sb.Append(" AND (cm.type1ID=8 OR cm.type1ID=9) ");
            else
                sb.Append(" AND cm.type1ID=1 ");

        }
        else
        {

            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID FROM f_panel_master fpm ");
            sb.Append(" WHERE fpm.TagProcessingLabID IN (SELECT CentreID FROM centre_master WHERE  BusinessZoneID='" + BusinessZoneID + "'");
            if (StateID != -1)
                sb.Append("  AND StateID='" + StateID + "' ");
            if (CityID != -1)
                sb.Append(" AND CityID='" + CityID + "'  ");

            sb.Append(" ) AND fpm.PanelType='PUP'  ");
        }
        sb.Append("   AND fpm.IsInvoice=1 ");
        sb.Append(" ORDER BY fpm.Company_Name");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return null;
        }
    }
}