using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Appointment_Appointment_Delta : System.Web.UI.Page
{
    public DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        #region For Quary string Values..!!
        string AppointDetails = Util.GetString(Request.QueryString["Appointment_detail"]);
        string Timeslot = Util.GetString(Request.QueryString["Times_lot"]);
        string dtfrom = Util.GetString(Request.QueryString["dt_SelctDate"]);
        string CentrID = Util.GetString(Request.QueryString["dtCentrID"]);
        #endregion

        if (AppointDetails != "Timeslot" && AppointDetails != "" && dtfrom != "" && CentrID!="")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(ard.Address, ' ', IFNULL(ard.Address1, ''), ' ', IFNULL(ard.Address2, ''), ' ', IFNULL(ard.pincode, '') ) Address, ");
            sb.Append(" ard.DeptID,IFNULL(`ard`.`Remarks`, '') Remarks,ard.Mobile,ard.Investigation ");            
            sb.Append(" FROM appointment_radiology_details ard  ");
            sb.Append(" LEFT JOIN appointment_radiology_details_update_status ardstatus ON ard.`ReferenceID` = `ardstatus`.`AppointmentID`  ");
            sb.Append(" WHERE ard.Iscancel = 0 AND ard.DeptID ='" + AppointDetails.Split('_')[1].ToString() + "' AND ard.CentreID ='" + CentrID + "'  ");
            sb.Append(" and appdate='" + Util.GetDateTime(dtfrom).ToString("yyyy-MM-dd") + "' and apptime='" + Util.GetDateTime(Timeslot).ToString("HH:mm:ss") + "' LIMIT 1; ");

            dt = StockReports.GetDataTable(sb.ToString());
            
            if (dt.Rows.Count == 0)
            {
                show.Style.Add("display","none");
            }
            else
            {
                //for (int i = 0; i < dt.Rows.Count; i++)
                //{
                //    string ItemData = dt.Rows[i]["Investigation"].ToString();
                //    ItemData = ItemData.TrimEnd('#');
                //    int len = Util.GetInt(ItemData.Split('#').Length);
                //    string[] Item = new string[len];
                //    Item = ItemData.Split('#');

                //    dt.Rows[i]["Investigation"] = "";
                //    for (int j = 0; j < len; j++)
                //    {
                //        dt.Rows[i]["Investigation"] += Util.GetString(Item[j].Split('_')[1].Split('@')[0].Trim()) + ",";
                //    }
                //    dt.Rows[i]["Investigation"] = dt.Rows[i]["Investigation"].ToString().TrimEnd(',');
                //}
                show.Style.Add("display", "display");
            }
        }        
    }

    
}