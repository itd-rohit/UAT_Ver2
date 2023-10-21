using ClosedXML.Excel;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Interfacer_ItemMasterInterface : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["LoginName"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            BindCompany();
            BindDepartment();
            if (Request.QueryString["ID"] != null)
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT InterfaceClientID, InterfaceClient,ItemId_interface,ItemName_interface FROM booking_data WHERE ID=@ID",
                         new MySqlParameter("@ID", Common.DecryptRijndael(Request.QueryString["ID"].ToString().Replace(" ", "+")))).Tables[0])
                    {
                        if (dt.Rows.Count > 0)
                        {
                            txttestcode.Text = dt.Rows[0]["ItemId_interface"].ToString();
                            txttestname.Text = dt.Rows[0]["ItemName_interface"].ToString();
                            ddlCompany.SelectedIndex = ddlCompany.Items.IndexOf(ddlCompany.Items.FindByValue(dt.Rows[0]["InterfaceClientID"].ToString()));
                        }
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {
                    con.Close();
                    con.Dispose();
                }
            }
        }
    }

    private void BindCompany()
    {
        using (DataTable dt = StockReports.GetDataTable("Select ID,CompanyName from f_Interface_Company_Master  order by CompanyName"))
        {
            ddlCompany.DataSource = dt;
            ddlCompany.DataTextField = "CompanyName";
            ddlCompany.DataValueField = "ID";
            ddlCompany.DataBind();
        }
    }

    private void BindDepartment()
    {
        using (DataTable dt = StockReports.GetDataTable("Select DISTINCT sc.SubCategoryID, sc.Displayname FROM f_subcategorymaster sc WHERE  active=1 order by Displayname"))
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "Displayname";
            ddlDepartment.DataValueField = "SubCategoryID";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, "");
            ddlDepartment.Items.Insert(1, "All");
        }
    }

    [WebMethod]
    public static string bindItems(string SubCategoryID)
    {
        StringBuilder sb = new StringBuilder();
        if (SubCategoryID == "All")
        {
            sb.Append(" SELECT ItemID,CONCAT(TestCode,' ~ ',TypeName)TypeName FROM f_itemmaster WHERE IsActive=1 ORDER BY TypeName; ");
        }
        else
        {
            sb.Append(" SELECT ItemID,CONCAT(TestCode,' ~ ',TypeName)TypeName FROM f_itemmaster WHERE SubcategoryID=@SubcategoryID AND IsActive=1 ORDER BY TypeName; ");
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@SubcategoryID", SubCategoryID)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetTest(string CompanyID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT fitem.ID,fitem.ItemID,fitem.TestCode,item.`TypeName`, fitem.ItemID_interface,fitem.ItemName_interface,fitem.Interface_companyName,fitem.CreatedBy, ");
        sb.Append(" IF(fitem.`isActive` = '1', 'Active', 'Deactive') AS IsActive,DATE_FORMAT(fitem.dtEntry,'%d-%b-%Y') AS EntryDate,");
        sb.Append(" sc.Displayname AS Department,fitem.UpdatedBy , DATE_FORMAT(fitem.`UpdateDate`,'%d-%b-%Y') AS UpdatedDate ");
        sb.Append(" FROM f_itemmaster_interface fitem INNER JOIN f_itemmaster item ON item.`ItemID`=fitem.`ItemID` ");
        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=item.`SubCategoryID` ");
        sb.Append("  WHERE fitem.Interface_CompanyID=@CompanyID");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@CompanyID", CompanyID)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string saveTest(string ItemID, string TestCode, string ItemID_interface, string ItemName_interface, string Interface_companyName, string Interface_CompanyID, bool IsUpdate = false)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string[]  TestCode1 = TestCode.Split('~');
            TestCode = TestCode1[0].Trim();          
            int ItemID_AsItdose = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT COUNT(1) FROM f_interface_company_master WHERE ItemID_AsItdose=1 AND ID=@ID ",
                 new MySqlParameter("@ID", Interface_CompanyID)));
            if (ItemID_AsItdose > 0)
            {
                return "4";
            }

            if (IsUpdate)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_itemmaster_interface SET isActive=@IsActive, UpdateDate=@UpdateDate, UpdateID=@UpdateByID, UpdatedBy=@UpdatedBy where ItemID=@ItemID and ItemID_interface=@ItemID_interface and Interface_CompanyID=@Interface_CompanyID ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                cmd.Parameters.AddWithValue("@IsActive", "1");
                cmd.Parameters.AddWithValue("@UpdateDate", System.DateTime.Now);
                cmd.Parameters.AddWithValue("@UpdateByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@ItemID", ItemID);
                cmd.Parameters.AddWithValue("@ItemID_interface", ItemID_interface);
                cmd.Parameters.AddWithValue("@Interface_CompanyID", Interface_CompanyID);
                cmd.ExecuteNonQuery();
                tnx.Commit();
                return "1";
            }
            else
            {
                string sqlstr = "SELECT ID,isActive FROM f_itemmaster_interface WHERE ItemID=@ItemID AND ItemID_interface=@ItemID_interface AND Interface_CompanyID=@Interface_CompanyID";
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sqlstr.ToString(),
                                          new MySqlParameter("@ItemID", ItemID),
                                          new MySqlParameter("@ItemID_interface", ItemID_interface),
                                          new MySqlParameter("@Interface_CompanyID", Interface_CompanyID)).Tables[0];
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    if (row["isActive"].ToString() == "1")
                        return "2";
                    else
                        return "3";
                }
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO f_itemmaster_interface(ItemID,TestCode,ItemID_interface,ItemName_interface,Interface_companyName,UserID,CreatedBy,Interface_CompanyID)");
                sb.Append("VALUES(@ItemID,@TestCode,@ItemID_interface,@ItemName_interface,@Interface_companyName,@UserID,@CreatedBy,@Interface_CompanyID)");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                cmd.Parameters.AddWithValue("@ItemID", ItemID);
                cmd.Parameters.AddWithValue("@TestCode", TestCode);
                cmd.Parameters.AddWithValue("@ItemID_interface", ItemID_interface);
                cmd.Parameters.AddWithValue("@ItemName_interface", ItemName_interface);
                cmd.Parameters.AddWithValue("@Interface_companyName", Interface_companyName);
                cmd.Parameters.AddWithValue("@UserID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@Interface_CompanyID", Interface_CompanyID);
                cmd.ExecuteNonQuery();
                tnx.Commit();
                return "1";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string UpdateStatus(string ID, string Status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE f_itemmaster_interface SET IsActive=@IsActive, UpdateDate=@UpdateDate,UpdateID=@UpdateByID,UpdatedBy=@UpdatedBy where ID=@ID ");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
            cmd.Parameters.AddWithValue("@IsActive", Status);
            cmd.Parameters.AddWithValue("@UpdateDate", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@UpdateByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
            cmd.Parameters.AddWithValue("@ID", ID);
            cmd.ExecuteNonQuery();
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
    }

    protected void btnexport_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT fitem.ID ,fitem.ItemID,fitem.TestCode,item.`TypeName` AS TestName, sc.Displayname AS Department, fitem.ItemID_interface as InterfaceItemID,fitem.ItemName_interface as InterfaceItemName,fitem.Interface_companyName as InterfaceCompany,fitem.CreatedBy, ");
            sb.Append(" DATE_FORMAT(fitem.dtEntry,'%d-%b-%Y') AS EntryDate,");
            sb.Append(" fitem.UpdatedBy , DATE_FORMAT(fitem.`UpdateDate`,'%d-%b-%Y') AS UpdatedDate,  IF(fitem.`isActive` = '1', 'Active', 'Deactive') AS Status ");
            sb.Append(" FROM f_itemmaster_interface fitem INNER JOIN f_itemmaster item ON item.`ItemID`=fitem.`ItemID` ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=item.`SubCategoryID`");
            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {
                if (dt.Rows.Count > 0)
                {
                    Session["dtExport2Excel"] = dt;
                    Session["ReportName"] = "ItemInterFaceMsater";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
                }
                else
                    lblerrmsg.Text = "No Record Found";
            }
        }
        catch (Exception ex)
        {
            lblerrmsg.Text = ex.Message;
        }
        finally
        {
        }
    }
}