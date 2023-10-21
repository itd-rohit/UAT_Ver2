using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InterpretationMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindMachine(ddlMachine);
            AllLoad_Data.bindMachine(ddlMappingMachine);
            AllLoad_Data.bindCentreDefault(ddlCentre);
            AllLoad_Data.bindCentreDefault(ddlMappingCentre);

            ddlMappingCentre.Items.Insert(0, new ListItem("Select", "0"));
            bindDepartment();
        }
    }

    private void bindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("Select Name,ObservationType_ID from observationtype_master where isActive=1 Order By Name");

        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "Name";
        ddlDepartment.DataValueField = "ObservationType_ID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("ALL", "0"));
    }
}