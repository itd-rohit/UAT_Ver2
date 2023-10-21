using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using MySql.Data.MySqlClient;
using System.IO;
using System.Data.SqlClient;



public partial class Design_PROApp_Aboutus : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ImageData();
            HeaderData();

        }
    }
    protected void ImageData()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT ID,ButtomText,Concat('~/Design/B2CMobile/Images/','',if(HeaderImage='','default.jpg',HeaderImage))HeaderImage,IF(IsActive=1,'Yes','No') IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y %I:%i %p') Entrydate FROM app_B2c_aboutus_image ORDER BY PrintOrder ");
        gvImage.DataSource = dt;
        gvImage.DataBind();
    }
    protected void HeaderData()
    {
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable("SELECT ID,HeaderText,Content,IF(IsActive=1,'Yes','No') IsActive,DATE_FORMAT(EntryDateTime,'%d-%b-%y %I:%i %p') Entrydate FROM app_b2c_aboutus_content ORDER BY PrintOrder ");
        gvImage1.DataSource = dt;
        gvImage1.DataBind();
    }

    protected void btnBindGrid_Click(object sender, EventArgs e)
    {
        ImageData();
    }

    protected void btnBindGrid1_Click(object sender, EventArgs e)
    {
        HeaderData();
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (btnsave.Text == "Save")
            {
                int IsActive;
                if (chkActive.Checked)
                {
                    IsActive = 1;
                }
                else
                {
                    IsActive = 0;
                }
                string recQty = StockReports.ExecuteScalar("select count(*) from app_b2c_aboutus_image;");
                if (Util.GetInt(recQty) > 0)
                {
                    //lblMsg.Text = "Record is Available in Table, Kindly Update.";
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Record is Available in Table, Kindly Update.', '');", true);
                    return;
                }
                if (FileUpload1.HasFile)
                {
                    //To Check Record Available or Not.                
                    if (txttext.Text.Trim() == "")
                    {
                       // lblMsg.Text = "Buttom Text Can't Be Empty.";
                        ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Buttom Text Can't Be Empty.', '');", true);
                        return;
                    }
                    string filename = Path.GetFileName(FileUpload1.PostedFile.FileName);
                    string directoryPath = HttpContext.Current.Server.MapPath("~/Design/B2CMobile/Images/");
                    if (!Directory.Exists(directoryPath))
                    {
                        Directory.CreateDirectory(directoryPath);
                    }
                    FileUpload1.SaveAs(directoryPath + filename);

                    string str = "insert INTO app_B2c_aboutus_image(ButtomText,HeaderImage,IsActive,UserID) values(@ButtomText,@HeaderImage,@IsActive,@UserID)";
                    int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                                     new MySqlParameter("@ButtomText", txttext.Text), new MySqlParameter("@HeaderImage", filename), new MySqlParameter("@IsActive", IsActive), new MySqlParameter("@UserID", UserInfo.ID));
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Saved', '');", true);
                    chkActive.Checked = false;
                    ImageData();
                    txttext.Text = "";
                }
                else
                {
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Please Select File..', '');", true);
                    lblMsg.Text = "";
                    return;

                }
            }
            else
            {

                int IsActive;
                if (chkActive.Checked)
                {
                    IsActive = 1;
                }
                else
                {
                    IsActive = 0;
                }
                if (FileUpload1.HasFile)
                {
                    string filename = Path.GetFileName(FileUpload1.PostedFile.FileName);
                    FileUpload1.SaveAs(Server.MapPath("~/Design/B2CMobile/Images/") + filename);
                    string str = "update app_B2c_aboutus_image set ButtomText=@ButtomText , HeaderImage=@HeaderImage,isActive=@IsActive ,UpdateID=@UserID ,UpdateName=@UpdateName ,UpdateDate=NOW() where ID=@ID";
                    int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                                     new MySqlParameter("@ButtomText", txttext.Text), new MySqlParameter("@HeaderImage", filename), new MySqlParameter("@IsActive", IsActive), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UpdateName", UserInfo.LoginName), new MySqlParameter("@ID", lblImageId.Text));
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Updated', '');", true);
                    lblMsg.Text = " ";
                    chkActive.Checked = false;
                    ImageData();
                    btnsave.Text = "Save";
                    imgHeader.Visible = false;
                    txttext.Text = "";

                }
                else
                {
                    string str = "update app_B2c_aboutus_image set ButtomText=@ButtomText ,isActive=@IsActive ,UpdateID=@UserID ,UpdateName=@UpdateName ,UpdateDate=NOW() where ID=@ID";
                    int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str.ToString(),
                                      new MySqlParameter("@ButtomText", txttext.Text), new MySqlParameter("@IsActive", IsActive), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UpdateName", UserInfo.LoginName), new MySqlParameter("@ID", lblImageId.Text));
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Updated', '');", true);
                    lblMsg.Text = " ";
                    chkActive.Checked = false;
                    ImageData();
                    btnsave.Text = "Save";
                    imgHeader.Visible = false;
                    txttext.Text = "";

                }


            }
            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    protected void btnsave1_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            if (btnsave1.Text == "Save")
            {
                if (txtheader1.Text.Trim() == "")
                {
                   // lblMsg.Text = "Content Header Can't be Empty. ";
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Content Header Can't be Empty. ', '');", true);
                    return;
                }
                if (txtContent.Text.Trim() == "")
                {
                    //lblMsg.Text = "Content  Can't be Empty. ";
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Content  Can't be Empty. ', '');", true);
                    return;
                }
                int IsActive;
                if (chkAct.Checked)
                {
                    IsActive = 1;
                }
                else
                {
                    IsActive = 0;
                }
                string str = "insert INTO app_b2c_aboutus_content(HeaderText,Content,IsActive,UserID) values(@HeaderText,@Content,@IsActive,@UserID)";
                int a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString(),
                                     new MySqlParameter("@HeaderText", txtheader1.Text), new MySqlParameter("@Content", txtContent.Text), new MySqlParameter("@IsActive", IsActive), new MySqlParameter("@UserID", UserInfo.ID));
                ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Saved', '');", true);
                lblMsg.Text = "Save Record ";
                chkAct.Checked = false;
                HeaderData();
                txtContent.Text = "";
                txtheader1.Text = "";
            }
            else
            {
                int IsActive;
                if (chkAct.Checked)
                {
                    IsActive = 1;
                }
                else
                {
                    IsActive = 0;
                }
                string str = "update app_b2c_aboutus_content set HeaderText=@HeaderText,Content=@Content, isActive=@IsActive ,UpdateID=@UpdateID ,UpdateName=@UpdateName ,UpdateDate=NOW() where ID=@ID";
                int a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString(),
                                    new MySqlParameter("@HeaderText", txtheader1.Text), new MySqlParameter("@Content", txtContent.Text), new MySqlParameter("@IsActive", IsActive), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UpdateName", UserInfo.LoginName), new MySqlParameter("@ID", lblImageId.Text));
                ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Saved', '');", true);
                lblMsg.Text = "Update Record ";
                chkAct.Checked = false;
                HeaderData();
                btnsave1.Text = "Save";
                txtContent.Text = "";
                txtheader1.Text = "";


            }
            Tranx.Commit();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void gvImage_SelectedIndexChanged(object sender, EventArgs e)
    {
        btnsave.Text = "Update";
        string ImageId = ((Label)gvImage.SelectedRow.FindControl("lblImageId")).Text;
        lblImageId.Text = ImageId;
        DataTable dt = StockReports.GetDataTable("SELECT ID,ButtomText,Concat('~/Design/B2CMobile/Images/','',HeaderImage)HeaderImage,IsActive FROM app_b2c_aboutus_image where ID=" + ImageId);

        imgHeader.ImageUrl = dt.Rows[0]["HeaderImage"].ToString();
        imgHeader.Visible = true;


        txttext.Text = dt.Rows[0]["ButtomText"].ToString();
        if (dt.Rows.Count > 0)
        {

            if (dt.Rows[0]["IsActive"].ToString() == "1")
            {
                chkActive.Checked = true;
            }
            else
            {
                chkActive.Checked = false;
            }

        }

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveAboutUsImageOrdering(string HTOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            // ObsData= Order|ObservationId|Header|IsCritical#
            HTOrder = HTOrder.TrimEnd('|');

            string str = "";
            int len = Util.GetInt(HTOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = HTOrder.Split('|');
            for (int i = 0; i < len; i++)
            {

                str = " UPDATE app_b2c_aboutus_image SET  PrintOrder=@PrintOrder WHERE ID=@ID";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str, new MySqlParameter("@PrintOrder", (Util.GetInt(i) + 1)),
                                      new MySqlParameter("@ID", Data[i].ToString()));
            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveAboutUsHeaderOrdering(string HTOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // ObsData= Order|ObservationId|Header|IsCritical#
            HTOrder = HTOrder.TrimEnd('|');

            string str = "";
            int len = Util.GetInt(HTOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = HTOrder.Split('|');
            for (int i = 0; i < len; i++)
            {
                str = " UPDATE app_b2c_aboutus_content SET  PrintOrder=@PrintOrder WHERE ID=@ID";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str, new MySqlParameter("@PrintOrder", (Util.GetInt(i) + 1)),
                                      new MySqlParameter("@ID", Data[i].ToString()));
            }


            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }

    }
    protected void gvImage1_SelectedIndexChanged(object sender, EventArgs e)
    {
        btnsave1.Text = "Update";
        string ImageId = ((Label)gvImage1.SelectedRow.FindControl("lblImageId")).Text;
        lblImageId.Text = ImageId;
        DataTable dt = StockReports.GetDataTable("SELECT ID,HeaderText,Content,IsActive FROM app_b2c_aboutus_content where ID=" + ImageId);
        txtContent.Text = dt.Rows[0]["Content"].ToString();
        txtheader1.Text = dt.Rows[0]["HeaderText"].ToString();
        if (dt.Rows.Count > 0)
        {

            if (dt.Rows[0]["IsActive"].ToString() == "1")
            {
                chkAct.Checked = true;
            }
            else
            {
                chkAct.Checked = false;
            }

        }

    }
}