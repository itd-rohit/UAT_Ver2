using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Investigation_AddAbnormalImage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindlabobservation();
            bindimage();
        }
    }

    private void bindimage()
    {
        DataTable dt = StockReports.GetDataTable("SELECT abnormalimage, labobservation_id, concat('~/Design/AbnormalImage/',abnormalimage) img,NAME FROM `labobservation_master` WHERE abnormalimage<>'' and isactive=1 oRDER BY NAME");
        mygrd.DataSource = dt;
        mygrd.DataBind();
    }

    private void bindlabobservation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT labobservation_id id,NAME  FROM `labobservation_master` WHERE isactive=1 ");
        sb.Append("  ORDER BY NAME ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        ddllabobservation.DataSource = dt;
        ddllabobservation.DataValueField = "id";
        ddllabobservation.DataTextField = "Name";
        ddllabobservation.DataBind();
        ddllabobservation.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        string RootDir = Server.MapPath("~/Design/AbnormalImage");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = System.IO.Path.GetExtension(file1.FileName);
        string FileName = ddllabobservation.SelectedValue + fileExt;

        file1.SaveAs(RootDir + @"\" + FileName);
        StockReports.ExecuteDML("update labobservation_master set abnormalimage='" + FileName + "' where labobservation_id='" + ddllabobservation.SelectedValue + "'");

        lblMsg.Text = "Image Saved..!";
        ddllabobservation.SelectedIndex = -1;
        bindimage();
    }

    protected void mygrd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)mygrd.SelectedRow.FindControl("Label1")).Text;
        string filename = ((Label)mygrd.SelectedRow.FindControl("Label5")).Text;

        StockReports.ExecuteDML("update labobservation_master set abnormalimage='' where labobservation_id='" + ID + "'");
        string RootDir = Server.MapPath("~/Design/AbnormalImage");
        if (File.Exists(RootDir + filename))
        {
            File.Delete(RootDir + filename);
        }

        lblMsg.Text = "Image Delete..!";
        bindimage();
    }
}