using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Investigation_MapOrganismAntibiotics : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindOrganism();
            BindObservation();
        }
    }

    private void BindOrganism()
    {
        string str = "SELECT OrganismID,OrganismName FROM organism_master WHERE isActive=1  ORDER BY OrganismName  ";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlOrganism.DataSource = dt;
            ddlOrganism.DataValueField = "OrganismID";
            ddlOrganism.DataTextField = "OrganismName";
            ddlOrganism.DataBind();
            ddlOrganism.Items.Insert(0, new ListItem("----Select Investigation----", ""));
        }
    }

    private void BindObservation()
    {
        string str = " SELECT LOM.LabObservation_ID, LOM.Name as ObsName,LOM.Minimum,LOM.Maximum,LOM.MinFemale,LOM.MaxFemale,LOM.MinChild,LOM.MaxChild,LOM.ReadingFormat, '0' printOrder,'0' Child_Flag  FROM labobservation_master lom where lom.Culture_flag=1 and isActive=1  ORDER BY lom.name ";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlObservation.DataSource = dt;
            ddlObservation.DataTextField = "ObsName";
            ddlObservation.DataValueField = "LabObservation_ID";
            ddlObservation.DataBind();
        }
    }
}