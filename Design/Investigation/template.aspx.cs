using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Investigation_template : System.Web.UI.Page
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
                    dynDiv.InnerHtml = Util.GetString(dtDetails.Rows[i]["Template"]);
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
        sb.Append("  SELECT scm.SubCategoryID DepartmentID,scm.Name Department,inv.Name Investigation,invt.Template_Desc Template ");
        sb.Append(" FROM investigation_master inv  ");
        sb.Append(" INNER JOIN investigation_template invt ON inv.Investigation_Id=invt.Investigation_Id  AND invt.`Template_Desc` IS NOT NULL ");
        sb.Append("  INNER JOIN f_itemmaster im ON im.`Type_ID`=inv.`Investigation_Id` ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`SubCategoryID` IN (" + DeptIDs.Trim() + ")   ");
        sb.Append(" AND scm.`CategoryID`='LSHHI3' ORDER BY scm.`Name`,inv.`Name`  ");
        //System.IO.File.WriteAllText("E://Template.text", sb.ToString());
        dt = StockReports.GetDataTable(sb.ToString());

        return dt;
    }
}