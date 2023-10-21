using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_ABHA_ViewData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
           
        if (!string.IsNullOrEmpty(Request.QueryString["ConsentID"]))
        {
            Session["ConsentID"] = Request.QueryString["ConsentID"].ToString();
        }
        else
        { 
            Session["ConsentID"] = "9822bbe0-0838-4b38-9393-ee1cc5fc7ffd";
          
        }
         
    }


    [WebMethod(EnableSession = true)]
    public static string ViewData()
    {
        string[] Conarray = HttpContext.Current.Session["ConsentID"].ToString().Split(',');
        string NewConsentID = "";
        int Count = 0;
        foreach (string item in Conarray)
        {
            if (Count==0)
            {
                NewConsentID = "'"+item+"'";
            }
            else
            {
                NewConsentID = NewConsentID+",'" + item + "'";
            }
        }
        
        DataTable dt = new DataTable();

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT adr.ContentDecrypted FROM abha_datarequesttohip ab  ");
        sb.Append(" INNER JOIN abha_datarequestresfromhip adr ON adr.TransactionId=ab.TransactionId  ");
        sb.Append(" WHERE ab.ConsentId in '" + NewConsentID + "'");
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt.Rows[0]["ContentDecrypted"].ToString(), message = "" });
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "", message = "" });

        }
    }

}