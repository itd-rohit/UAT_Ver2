using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_PROApp_MobileImage : System.Web.UI.Page
{
    public DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt1 = StockReports.GetDataTable("select UniqueId from app_appointment_attachment where AppointmentID='" + Util.GetString(Request.QueryString["id"]) + "'; ");
        dt.Columns.Add("Filename");
        for (int a = 0; a < dt1.Rows.Count; a++)
        {
            DataRow dw = dt.NewRow();
            dw["Filename"] = "Prescription/" + dt1.Rows[a]["UniqueId"];
            dt.Rows.Add(dw);
        }
    }
}