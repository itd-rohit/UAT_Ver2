using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Store_POStatus_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
    }


    [WebMethod]
    public static string searchPODStatus(string PODNumber)
    {
        StringBuilder sb = new StringBuilder();

      sb.Append(" SELECT spd.`podnumber`,'Create By' AS STATUS,em.`Name` AS USER,DATE_FORMAT(spd.`PODgendate`,'%d-%b-%Y %h:%i %p') AS DATE,''To_Employee FROM st_pod_details spd ");
sb.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=spd.PODcreated_by ");
sb.Append(" WHERE  spd.`podnumber`='" + PODNumber + "'  ");
sb.Append(" UNION ALL ");
sb.Append(" SELECT  st.`podnumber`,st.STATUS,em.`Name` AS USER,DATE_FORMAT(st.Date,'%d-%b-%Y %h:%i %p') AS DATE , ");
 sb.Append(" IFNULL((SELECT em2.`Name`  FROM st_pod_employeetagging pt INNER JOIN employee_master em2 ON pt.EMPLOYEEIDto=em2.`Employee_ID`  AND pt.isactive=1 WHERE EMPLOYEEIDFROM=st.EmployeeId  AND st.`Status`='Transfer' LIMIT 1 ),'')To_Employee ");
sb.Append(" FROM st_PodTransfer_Log st  ");
sb.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=st.EmployeeId ");
sb.Append(" WHERE st.`podnumber`='" + PODNumber + "'  ");
     

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {

            StringBuilder sbData = new StringBuilder();
            if (dt.Rows.Count > 0)
            {
                sbData.Append(" <table style='width:99%;border-collapse:collapse' id='tb_ItemList' class='GridViewStyle'>");
                sbData.Append(" <tr id='header'><td class='GridViewHeaderStyle' style='width:30px'>S.No.</td>");
                sbData.Append("<td class='GridViewHeaderStyle' style='width:100px'>POD Number</td>");
                sbData.Append("<td class='GridViewHeaderStyle' style='width:100px'>Status</td>");
                sbData.Append("<td class='GridViewHeaderStyle' style='width:100px'>User</td>");
                sbData.Append("<td class='GridViewHeaderStyle' style='width:100px'>Date</td>");
                sbData.Append("<td class='GridViewHeaderStyle' style='width:100px'>To Employee</td><tr/>");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    sbData.Append("<tr style='background-color:bisque;'>");
                    sbData.Append("<td class='GridViewLabItemStyle'>" + (i + 1) + "</td>");
                    sbData.Append("<td class='GridViewLabItemStyle'>" + dt.Rows[i]["podnumber"].ToString() + "</td>");
                    sbData.Append("<td class='GridViewLabItemStyle'>" + dt.Rows[i]["STATUS"].ToString() + "</td>");
                    sbData.Append("<td class='GridViewLabItemStyle'>" + dt.Rows[i]["USER"].ToString() + "</td>");
                    sbData.Append("<td class='GridViewLabItemStyle'>" + dt.Rows[i]["DATE"].ToString() + "</td>");
                    sbData.Append("<td class='GridViewLabItemStyle'>" + dt.Rows[i]["To_Employee"].ToString() + "</td></tr>");
                    
                }
                sbData.Append("</table>");
                return sbData.ToString();
            }

            else
            {
                return "";
            }
        }
    }
    [WebMethod]
    public static string encryptData(string PanelID, string Type)
    {
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(PanelID));
        addEncrypt.Add(Common.Encrypt(Type));
        return JsonConvert.SerializeObject(addEncrypt);
    }
}