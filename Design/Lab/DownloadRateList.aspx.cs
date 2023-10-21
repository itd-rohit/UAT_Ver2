using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
public partial class DayWiseDiscountReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int IsHideRate = Util.GetInt(StockReports.ExecuteScalar("SELECT IsHideRate FROM employee_master WHERE Employee_ID='" + UserInfo.ID + "'"));
            if (IsHideRate == 1)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "disableControl();", true);

            }
        }
    }

    [WebMethod]
    public static string CheckLedgerPassword(string LedgerPassword)
    {
        //string PanelID =Util.GetString(HttpContext.Current.Session["Panel_ID"]);
        try
        {
          
            StringBuilder sb=new StringBuilder();
                    sb.Append("   SELECT sc.`Name` DeptName, im.ItemID,im.testcode,im.typeName ItemName,IFNULL(r1.Rate,0)MRP  ,IFNULL(r.Rate,0)PatientRate  ");
                    sb.Append(" FROM f_itemmaster im   ");
                    sb.Append(" INNER JOIN f_ratelist r ON r.itemid=im.ItemID AND im.IsActive=1  AND r.`Rate` > 0 ");
                    sb.Append(" INNER JOIN f_panel_master pm ON r.panel_id=pm.`ReferenceCodeOPD` AND pm.Panel_ID='" + UserInfo.PCC_PanelID + "'   ");
                    //sb.Append(" AND pm.`PanelType`='Centre'  ");
                    sb.Append(" INNER JOIN f_ratelist r1 ON r1.itemid=im.ItemID AND r1.Panel_id=pm.Panel_id  AND r1.`Rate` > 0 ");
                    sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
                    sb.Append(" ORDER BY im.typeName ");
              

                DataTable dt = StockReports.GetDataTable(sb.ToString());
                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtratelist"] = dt;
                    
                    return "1";

                }
                else
                {
                    return "0";
                }

          
            
        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "-1";
        }
    }

}