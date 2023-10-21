using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_Investigation_ObservationInterpretation : System.Web.UI.Page
{
    DataTable dtDetails;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            StringBuilder sbSpace = new StringBuilder();
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            string DeptID = Util.GetString(Session["DeptIDs"]);
            dtDetails = BindDetails(DeptID);

            if (dtDetails.Rows.Count > 0)
            {
                Label[] lblDept = new Label[dtDetails.Rows.Count];
                Label[] lblInvName = new Label[dtDetails.Rows.Count];
                for (int i = 0; i <= dtDetails.Rows.Count - 1; i++)
                {
                    string isBr = Util.GetString(dtDetails.Rows[i]["Interpretation"]);
                    if (isBr.Trim() != "<br />" && isBr.Trim() != "")
                    {
                        System.Web.UI.HtmlControls.HtmlGenericControl dynDiv =
                            new System.Web.UI.HtmlControls.HtmlGenericControl("DIV");
                        dynDiv.ID = "divInv" + i.ToString();
                        dynDiv.Attributes.Add("class", "myClass");
                        dynDiv.InnerHtml = Util.GetString(dtDetails.Rows[i]["Interpretation"]);
                        lblDept[i] = new Label();
                        lblDept[i].Text = sbSpace.ToString() + "<b>Observation Name:</b> " + Util.GetString(dtDetails.Rows[i]["ObsName"]);
                        this.Controls.Add(lblDept[i]);                        
                        this.Controls.Add(dynDiv);
                    }
                }
            }
        }
    }

    protected DataTable BindDetails(string DeptIDs)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        sb.Append(" SELECT LOM.LabObservation_ID, ");
        sb.Append(" concat(LOM.Name,' ( ',lmi.`flag`,' )') AS ObsName,lmi.`Interpretation` ");
        sb.Append(" FROM  labobservation_master LOM   ");
        sb.Append(" INNER JOIN `labobservation_master_interpretation` lmi ");
        sb.Append(" ON lmi.`labObservation_ID`=lom.`LabObservation_ID` ");
        sb.Append(" AND lom.`IsActive`=1 ");
        sb.Append(" AND lmi.`Interpretation`<>'' ");
        sb.Append("  GROUP BY lom.`LabObservation_ID`,lmi.`flag` ORDER BY ObsName,lmi.`flag`  ");
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}
