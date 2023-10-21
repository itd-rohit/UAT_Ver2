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

public partial class Design_Investigation_InvestigationInterpretation : System.Web.UI.Page
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
    }

    protected DataTable BindDetails(string DeptIDs)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();        
        sb.Append(" SELECT itm.`TypeName` Investigation,imi.`Interpretation`,scm.`Name` Department FROM f_itemmaster itm ");
        sb.Append(" INNER JOIN  `investigation_master_interpretation` imi  ");
        sb.Append(" ON imi.`Investigation_Id`=itm.`Type_ID` ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON  ");
        sb.Append(" scm.`SubCategoryID`=itm.`SubCategoryID` ");       
        sb.Append(" AND itm.`IsActive`=1 ");
        sb.Append(" AND imi.`Interpretation`<>'' "); 
        dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}
