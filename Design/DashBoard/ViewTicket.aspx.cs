using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_DashBoardNew_ViewTicket : System.Web.UI.Page
{
    string txtDate = "";
   
    protected void Page_Load(object sender, EventArgs e)
    {

        txtDate = Util.GetString(Request.QueryString["txtDate"]);
        labDetail(txtDate);
       
    }

    public void labDetail(string txtDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  cgm.GroupName,ifnull((SELECT `TicketStatus` FROM support_error_reply WHERE `TicketID`=s.ID  AND `Employee_Id`='" + UserInfo.ID + "' AND `active`=1  ORDER BY dtEntry DESC LIMIT 1),'New') AS Status,s.Status as CurrentStatus,s.`ID`,dtl.Message,s.`Subject`, ");
        sb.Append("  cat.CategoryName, ");
        sb.Append(" IF(s.StatusId<>4, CONCAT(FLOOR(HOUR(TIMEDIFF(NOW(),dtAdd)) / 24), ' days ',MOD(HOUR(TIMEDIFF(NOW(),dtAdd)), 24), ' hr ',MINUTE(TIMEDIFF(NOW(),dtAdd)), ' min'),'')ElapsedTime, ");
        sb.Append(" IF(`Employee_Id`<>'"+UserInfo.ID+"', s.`EmpName`,'') CreateBy ");
        sb.Append(" FROM `support_error_record` s ");
        sb.Append(" INNER JOIN `support_error_textdetails` dtl on dtl.TicketID=s.ID ");
        sb.Append(" INNER JOIN `cutomercare_category_master` cat on cat.ID=s.categoryID ");
        sb.Append(" INNER JOIN support_error_access sea ON sea.TicketID=s.ID AND sea.EmployeeID='" + UserInfo.ID + "' AND AccessDateTime<NOW()");
        sb.Append(" INNER JOIN `cutomercare_Group_master` cgm on cgm.GroupID=s.GroupID ");
        sb.Append("  WHERE s.`active` = 1  AND s.`dtAdd` >='" + string.Concat(Util.GetDateTime(txtDate).ToString("yyyy-MM-dd"), " 00:00:00") + "'  AND s.`dtAdd` <='" + string.Concat(Util.GetDateTime(txtDate).ToString("yyyy-MM-dd"), " 23:59:59") + "'");
        sb.Append(" GROUP BY ID   ORDER BY s.`ID` ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count == 0)
        {
            lblerrmsg.Text = "No Status Found";
        }

        grd.DataSource = dt;
        grd.DataBind();

    }
}