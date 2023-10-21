using System;
using System.Data;
using System.Web.Services;

public partial class Design_Investigation_ObservationManage : System.Web.UI.Page
{
    public string Investigation_ID = "";
    public string isautoconsume = "";
    public string autoconsumeoption = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Investigation_ID = Convert.ToString(Request.QueryString["InvID"]);
            if (Util.getApp("Autoconsumestore") != "Y")
            {
                isautoconsume = "0";
                autoconsumeoption = "0";
            }
            else
            {
                isautoconsume = "1";
                autoconsumeoption = StockReports.ExecuteScalar(string.Format("select autoconsumeoption from investigation_master where Investigation_Id='{0}'", Convert.ToString(Request.QueryString["InvID"])));
            }
            BindObservation();
        }
    }

    private void BindObservation()
    {
        lblInvestigation.Text = StockReports.ExecuteScalar(string.Format("select name from investigation_master where investigation_ID='{0}'  ", Investigation_ID));
        string str = " SELECT LOM.LabObservation_ID, CONCAT(LOM.Name,' - ',LOM.LabObservation_ID) as ObsName,LOM.Minimum,LOM.Maximum,LOM.MinFemale,LOM.MaxFemale,LOM.MinChild,LOM.MaxChild,LOM.ReadingFormat, '0' printOrder,'0' Child_Flag  FROM labobservation_master lom  ORDER BY lom.name ";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlObservation.DataSource = dt;
            ddlObservation.DataTextField = "ObsName";
            ddlObservation.DataValueField = "LabObservation_ID";
            ddlObservation.DataBind();
        }
    }
    [WebMethod]
    public static string CheckCritical(string LabObservationID)
    {

        //var count = Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT COUNT(*) FROM `labobservation_range`  WHERE  `LabObservation_ID` ='{0}'  AND `AbnormalValue`='' AND `MaxCritical`=0 and centreid='"+UserInfo.Centre+"' ", LabObservationID)));
        // Added By Vaseem 03jun23
        var count = Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT COUNT(*) FROM `labobservation_range`  WHERE  `LabObservation_ID` ='{0}'  And `MinCritical`<> 0  AND `MaxCritical`<> 0 and centreid='" + UserInfo.Centre + "' ", LabObservationID)));
        if (count > 0)
            return "1";
        else
            return "0";
    }

}