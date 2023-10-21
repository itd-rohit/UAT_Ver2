using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Web.Services;
using System.Web.UI;

public partial class Design_EDP_MenuMasterNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnResizeImage_Click(object sender, EventArgs e)
    {
        string newFile = string.Empty;
        if (fileUpload.HasFile)
        {
            const int width = 32;
            const int height = 32;
            Stream inp_Stream = fileUpload.PostedFile.InputStream;
            using (var image = System.Drawing.Image.FromStream(inp_Stream))
            {
                Bitmap myImg = new Bitmap(width, height);
                Graphics myImgGraph = Graphics.FromImage(myImg);
                myImgGraph.CompositingQuality = CompositingQuality.HighQuality;
                myImgGraph.SmoothingMode = SmoothingMode.HighQuality;
                myImgGraph.InterpolationMode = InterpolationMode.HighQualityBicubic;
                var imgRectangle = new Rectangle(0, 0, width, height);
                myImgGraph.DrawImage(image, imgRectangle);
                ImageConverter converter = new ImageConverter();
                var data = (byte[])converter.ConvertTo(myImg, typeof(byte[]));
                imgPreview.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(data);
                imgPreview.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "imgPreviewShow()", true);
                imgActualImg.ImageUrl = txtBase.Text;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Please Select File');", true);
        }

    }
    [WebMethod(EnableSession = true)]
    public static string SaveMenu(string id, string MenuName, string imageData)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            



            string msg = string.Empty;
            if (id != "0")
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_menumaster WHERE MenuName=@MenuName AND ID!=ID",
                    new MySqlParameter("@MenuName", MenuName),
                    new MySqlParameter("@ID", id)));
                if (count == 0)
                {
                    MySqlHelper.ExecuteScalar(con, CommandType.Text, "UPDATE f_menumaster SET MenuName=@MenuName,image=@Image WHERE id=@id",
                            new MySqlParameter("@MenuName", MenuName),
                            new MySqlParameter("@Image", imageData),
                            new MySqlParameter("@id", id));
                    msg = "Record Updated Successfully";
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Menu Already Exits" });
                }
            }
            else
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_menumaster WHERE MenuName=@MenuName",
                    new MySqlParameter("@MenuName", MenuName)));
                if (count == 0)
                {
                    MySqlHelper.ExecuteScalar(con, CommandType.Text, "insert into f_menumaster(MenuName,Active,image,CreatedByID,CreatedBy) values(@MenuName,1,@Image,@CreatedByID,@CreatedBy)",
                           new MySqlParameter("@MenuName", MenuName),
                           new MySqlParameter("@CreatedByID", UserInfo.ID),
                           new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                           new MySqlParameter("@Image", imageData));

                    msg = "Record Saved Successfully";
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Menu Already Exits" });
                }
            }
            //DataTable dtRole = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT RM.id,RM.RoleName FROM f_filemaster fm INNER JOIN f_file_role fr ON fm.ID = fr.UrlID INNER JOIN f_rolemaster rm ON fr.RoleID = rm.ID AND rm.Active=1 INNER JOIN f_menumaster fmm ON fmm.id=fm.MenuID WHERE fm.Active = 1 AND fr.Active = 1 AND MenuName=@role ORDER BY fm.Priority "
            //    , new MySqlParameter("@MenuName", MenuName)).Tables[0];

            //foreach (DataRow dr in dtRole.Rows)
            //{
            //    StockReports.GenerateMenuData(dr["RoleName"].ToString());
            //}
            return JsonConvert.SerializeObject(new { status = true, response = msg });
        }
        catch (Exception e)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(e);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}