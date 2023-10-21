using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
public partial class Design_Lab_AddPanelAttachment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           // bindAttachment();
            LoadPanel();
            ddlPanel.SelectedValue = Util.GetString(Request.QueryString["PanelID"]);
            bindAttachment();
        }
        lblMsg.Text = "";
    }

    private void bindAttachment()
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT pli.`id`,pli.`AttachedFile`,plo.Approved,CONCAT_WS('/',DATE_FORMAT(pli.`dtEntry`,'%Y%m%d'), pli.`FileUrl`)FileUrl,em.`Name` AS UploadedBy,DATE_FORMAT(pli.`dtEntry`,'%d-%b-%y') AS dtEntry  ");
        //sb.Append(" FROM `patient_labinvestigation_attachment` pli  ");
        //sb.Append(" inner join `patient_labinvestigation_opd` plo on pli.Test_ID=plo.Test_ID  ");

        //sb.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=pli.`UploadedBy` and pli.Test_ID='" + Util.GetString(Request.QueryString["Test_ID"]) + "' ");
         sb.Append(" SELECT fpa.`id`,fpa.`AttachedFile`,CONCAT_WS('/',DATE_FORMAT(fpa.`dtEntry`,'%Y%m%d'), fpa.`FileUrl`)FileUrl,em.`Name` AS UploadedBy,DATE_FORMAT(fpa.`dtEntry`,'%d-%b-%y') AS dtEntry  ");
         sb.Append(" FROM `f_panel_master_attachment` fpa ");
         sb.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=fpa.`UploadedBy` AND fpa.Panel_ID='" + Util.GetString(ddlPanel.SelectedValue) + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grvAttachment.DataSource = dt;
        grvAttachment.DataBind();
      //string roleid = Session["RoleID"].ToString();
      //  if (roleid!="6")
      //  {
      //          grvAttachment.Columns[0].Visible = false;
         
      //  }

    }
    private void LoadPanel()
    {
        DataTable dt;
        dt = StockReports.GetDataTable("select Company_Name,Panel_ID from f_panel_master ORDER BY Company_Name");
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "Panel_ID";
        ddlPanel.DataBind();
        ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string Panel_ID=ddlPanel.SelectedValue;
        if ( Panel_ID== "0")
        {
            lblMsg.Text = "Please Select Panel";
            return;
        }
      //  if ((Panel_ID == ""))
        //    return;

        string RootDir = string.Concat(Resources.Resource.DocumentPath, "/Panel_Document");//Server.MapPath("~/Uploaded Document")
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);



        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
           


        string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        string FileName = "Panel_"+Panel_ID + "_" + fu_Upload.FileName.Replace(fileExt, "").Trim() + "_" + DateTime.Now.ToString("yyyyMMdd") + "" + fileExt;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            //patient_labinvestigation_attachment plo = new patient_labinvestigation_attachment(tnx);
            //plo.Test_ID_varchar = Test_ID;
            //plo.AttachedFile_varchar = fu_Upload.FileName;
            //plo.FileUrl_varchar = FileName;
            //plo.UploadedBy_varchar = Session["ID"].ToString();
            //plo.Insert();
              StringBuilder sb = new StringBuilder();
              sb.Append(" INSERT INTO f_panel_master_attachment( `Panel_ID`,`AttachedFile`,`FileUrl`,`UploadedBy`,`dtEntry`)  ");
              sb.Append("  VALUES( '" + Panel_ID + "','" + fu_Upload.FileName + "','" + FileName + "','" + Session["ID"].ToString() + "',now());  ");
              StockReports.ExecuteDML(sb.ToString());
            fu_Upload.SaveAs(RootDir + @"\" + FileName);
            
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "File uploaded successfully.";
            bindAttachment();

        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            tnx.Rollback();
            con.Close();
            con.Dispose();
        }

        


    }
    protected void grvAttachment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            GridViewRow gvr = ((Control)e.CommandSource).Parent.Parent as GridViewRow;
            Label lblPath = (Label)gvr.FindControl("lblPath");
            string RootDir = Server.MapPath("~/Uploadedpanel Document");
            if (File.Exists(RootDir + lblPath.Text))
            {
                File.Delete(RootDir + lblPath.Text);
            }
            StockReports.ExecuteDML("delete from f_panel_master_attachment where id='" + e.CommandArgument.ToString() + "'");
        }
        bindAttachment();
    }
    protected void ddlPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindAttachment();
    }
}