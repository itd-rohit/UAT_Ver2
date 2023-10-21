using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_TicketDashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.AddDays(-30).ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string bindTicketStatusCount(string fromDate, string toDate,string Isfilter)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT COUNT(*)StatusCount,sm.Status  FROM support_error_record sr INNER JOIN support_status_master sm  ON sr.StatusID=sm.ID ");
        sb.Append(" WHERE sr.dtAdd>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND sr.dtAdd<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (Isfilter != "0")
            sb.Append(" AND sr.centreID='" + Util.GetString(UserInfo.Centre) + "'");
        sb.Append(" GROUP BY StatusID ORDER BY sm.Priority+0");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    [WebMethod(EnableSession = true)]
    public static string GetIssueList(string Status, string fromDate, string toDate, string Isfilter)
    {
        
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT cgm.GroupName,emp.Email,CONCAT('PIM',s.`ID`)IssueCode,s.Status,s.`ID`,s.`EmpId`,s.`EmpName`,s.`Subject`,dtl.Message,s.`VialId`,s.`RegNo`, ");
        sb.Append(" DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p')dtAdd, ");
        sb.Append(" IFNULL(cm.`CentreCode`,'')CentreCode,IF(s.itemid=0,'',s.itemid)itemid, cat.CategoryName,scat.SubCategoryName,cm.Centre, ");
        sb.Append(" CONCAT(emp.Title,'',emp.NAME) AS EmpName,item.typeName, ");
        sb.Append(" CONCAT(emp1.Title,'',emp1.NAME) AS ResolvedBy, ");
        sb.Append(" (SELECT COUNT(*) FROM support_uploadedfile WHERE ticketID=s.id) AS Attachment, ");
        sb.Append(" (SELECT IFNULL(CONCAT(CONCAT('/',DATE_FORMAT(dtEntry,'%Y%m%d'),'/',filename),'',FileExt),'') FROM support_uploadedfile su WHERE su.TicketID=s.`ID` order by su.TicketID asc limit 1)FileUrl, ");       
       
        sb.Append(" IF(s.StatusId<>4, CONCAT(FLOOR(HOUR(TIMEDIFF(NOW(),dtAdd)) / 24), ' days ',MOD(HOUR(TIMEDIFF(NOW(),dtAdd)), 24), ' hr ',MINUTE(TIMEDIFF(NOW(),dtAdd)), ' min'),'')ElapsedTime, ");
        sb.Append(" IF(s.StatusId=4, CONCAT(FLOOR(HOUR(TIMEDIFF(resolveDateTime,dtAdd)) / 24), ' days ',MOD(HOUR(TIMEDIFF(resolveDateTime,dtAdd)), 24), ' hr ',MINUTE(TIMEDIFF(resolveDateTime,dtAdd)), ' min'),'')ResolvedDate ");
        sb.Append(" FROM `support_error_record` s ");
        sb.Append(" INNER JOIN `support_error_textdetails` dtl on dtl.TicketID=s.ID ");
        sb.Append(" INNER JOIN `cutomercare_category_master` cat on cat.ID=s.categoryID ");
        sb.Append(" INNER JOIN `cutomercare_subcategory_master` scat on scat.ID=s.SubCategoryID ");
        sb.Append(" INNER JOIN `cutomercare_Group_master` cgm on cgm.GroupID=s.GroupID ");
        sb.Append(" INNER JOIN `employee_master` emp on emp.Employee_ID=s.EmpId ");
        sb.Append(" LEFT JOIN `f_itemmaster` item on item.ItemID=s.itemid ");
        sb.Append(" LEFT JOIN `employee_master` emp1 on emp1.Employee_ID=s.ResolvedBy ");
        sb.Append("  INNER JOIN `centre_master` cm ON cm.`centreID`=s.`centreID` ");
        sb.Append("  INNER JOIN `support_status_master` ser ON s.`StatusId`=ser.`ID`  "); 
            sb.Append(" WHERE s.`Status`='" + Status + "'");
            if (Isfilter != "0")
                sb.Append(" AND s.centreID='" + Util.GetString(UserInfo.Centre) + "'");

       sb.Append(" AND s.dtAdd>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND s.dtAdd<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  GROUP BY s.id ORDER BY  s.dtAdd DESC"); 

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        
        return Util.getJson(dt);
    }
}