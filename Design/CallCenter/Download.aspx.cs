using System;
using System.Data;

public partial class Design_SUPPORT_Download : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DownloadFile();
        }
    }

    private void DownloadFile()
    {
        DataTable dt = new DataTable();
        dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text,
            "SELECT `FileName`,`FilePath`,FileExt FROM `support_uploadedfile` WHERE `FileId`=@FileId",
            new MySql.Data.MySqlClient.MySqlParameter("@FileId", Util.GetString(Request.QueryString["FileId"]))).Tables[0];
        string filePath = Util.GetString(dt.Rows[0]["FilePath"]);
        if (filePath != "")
        {
            Response.ContentType = ContentType;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Util.GetString(dt.Rows[0]["FilePath"]));
            Response.WriteFile(filePath);
            Response.End();
        }
        else
        {
            Response.Write("This file does not exist.");
        }
    }
}