using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_CallCentreQuestion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindCateDropDown()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,Category,Category_Type FROM call_centre_Option WHERE IsActive='1' ");
        DataTable dtdoctor = StockReports.GetDataTable(sb.ToString());
        string retrn = Newtonsoft.Json.JsonConvert.SerializeObject(dtdoctor);
        return retrn;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DeleteFeedOption(int ID)
    {
        string retr = "";
        try
        {
            bool result = StockReports.ExecuteDML("delete from call_centre_question where ID='" + ID + "' ");
            if (result == true)
            {
                retr = "1";
            }
            else
            {
                retr = "0";
            }
            return retr;
        }
        catch (Exception ex)
        {
            return retr = "2";
        }
    }
}
