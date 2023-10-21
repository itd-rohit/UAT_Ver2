using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InterpretationReport : System.Web.UI.Page
{
    private DataTable dtDetails;

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
            //   sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            //   sbSpace.Append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
            string DeptID = Util.GetString(Session["DeptIDs"]);
            dtDetails = BindDetails(DeptID);

            if (dtDetails.Rows.Count > 0)
            {
                Label[] lblDept = new Label[dtDetails.Rows.Count];
                Label[] lblInvName = new Label[dtDetails.Rows.Count];
                for (int i = 0; i <= dtDetails.Rows.Count - 1; i++)
                {
                    System.Web.UI.HtmlControls.HtmlGenericControl dynDiv =
                        new System.Web.UI.HtmlControls.HtmlGenericControl("DIV");
                    dynDiv.ID = "divInv" + i.ToString();
                    dynDiv.Attributes.Add("class", "myClass");
                    dynDiv.InnerHtml = Util.GetString(dtDetails.Rows[i]["Interpretation"]);
                    lblDept[i] = new Label();
                    lblDept[i].Text = sbSpace.ToString() + "<b>Department Name:</b> " + Util.GetString(dtDetails.Rows[i]["Department"]) + "</br>";
                    this.Controls.Add(lblDept[i]);
                    lblInvName[i] = new Label();
                    lblInvName[i].Text = sbSpace.ToString() + "<b>Investigation Name:</b> " + Util.GetString(dtDetails.Rows[i]["Investigation"]);
                    this.Controls.Add(lblInvName[i]);
                    this.Controls.Add(dynDiv);
                }
            }
        }
    }

    protected DataTable BindDetails(string DeptIDs)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        sb.Append(" SELECT otm.`ObservationType_ID` DepartmentID,otm.`Name` Department,inv.`Name` Investigation,inv.`Interpretation` FROM investigation_master inv ");
        sb.Append(" INNER JOIN `investigation_observationtype` iot ON iot.`Investigation_ID`=inv.`Investigation_Id` ");
        sb.Append(" INNER JOIN `observationtype_master` otm ON otm.`ObservationType_ID`=iot.`ObservationType_Id` ");
        sb.Append(" AND otm.`ObservationType_ID` IN (" + DeptIDs.Trim() + ") ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.`Investigation_Id` ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND im.`IsActive`=1 AND scm.`Active`=1 AND scm.`CategoryID`='LSHHI3' ");
        sb.Append(" AND inv.`Interpretation`<>'' ORDER BY otm.`Name`,inv.`Name` ");
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}