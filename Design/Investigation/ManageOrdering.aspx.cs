using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Investigation_ManageOrdering : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategory();
        }
    }

    private void LoadCategory()
    {
        StringBuilder str = new StringBuilder();
        str.Append(" SELECT sc.Name, CONCAT(sc.SubcategoryID,'#',om.ObservationType_ID)ID ");
        str.Append(" FROM f_subcategorymaster sc INNER JOIN ");
        str.Append(" f_configrelation c ON c.CategoryID=sc.CategoryID AND c.ConfigRelationId='3' ");
        str.Append(" INNER JOIN observationtype_master om ON om.ObservationType_ID=sc.SubcategoryID where sc.Active=1 ");
        str.Append(" ORDER BY sc.Name ");
        DataTable dt = StockReports.GetDataTable(str.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "Name";
            ddlSubCategory.DataValueField = "ID";
            ddlSubCategory.DataBind();
            ddlSubCategory.Items.Insert(0, new ListItem("---Select---", "0#0"));
        }
    }
}