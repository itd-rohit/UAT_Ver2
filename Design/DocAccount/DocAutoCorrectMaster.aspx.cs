using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using System.Text;

public partial class Design_DocAccount_DocShareMaster : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ddlDept.DataSource = StockReports.GetDataTable(" SELECT SubcategoryID,NAME FROM f_subcategorymaster WHERE active=1 ;");
            ddlDept.DataTextField = "NAME";
            ddlDept.DataValueField = "SubcategoryID";
            ddlDept.DataBind();
            
        }
    }

    [WebMethod]
    public static string getDoctorReferal()
    {
        return Util.getJson(StockReports.GetDataTable("SELECT Doctor_ID,Name FROM doctor_referal WHERE ReferMasterShare=0"));
    }
    [WebMethod]
    public static string getAutoKey(string DepartmentID)
    {       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT ID,AutoKey,AutoDescription,SubCategoryID FROM `autocorrect_detail` WHERE IsActive=1 ");
            sb.Append(" AND SubCategoryID=@SubCategoryID");
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@SubCategoryID", DepartmentID)).Tables[0];
           
            return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public static string getItem(int searchType, string SubCategoryID, string Doctor_ID, int CategoryBill, int Panel_ID, string DocCategory)
    {        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            DataTable dt = new DataTable();

            
            if (Panel_ID == 0)
            {
                sb.Append("SELECT DISTINCT im.ItemID,im.TypeName,im.TestCode ,");
                sb.Append("0 DocSharePer,0 DocShareAmt ");
            }
            else
            {
                sb.Append("SELECT im.ItemID,im.TypeName,im.TestCode ,");
                sb.Append("IFNULL(doc.DocSharePer,0)DocSharePer,IFNULL(doc.DocShareAmt,0)DocShareAmt ");
            }
            sb.Append(" FROM f_ItemMaster im LEFT JOIN  doctor_referral_share_items doc ON im.ItemID=doc.ItemID   ");
            if (searchType == 1)
            {
                sb.Append("  AND doc.Doctor_ID=0  ");
            }
            else
            {
                if (Doctor_ID != "0")
                    sb.Append(" AND doc.Doctor_ID=@Doctor_ID ");
            }                                   
            if (Panel_ID != 0)
                sb.Append("  AND doc.CentreID=@CentreID ");
            if (DocCategory != "")
                sb.Append("  and doc.CityID=@CityID "); 
            if (Util.GetString(SubCategoryID) != "0")
                sb.Append(" Where im.SubCategoryID=@SubCategoryID ");
            if (CategoryBill != 0)
                sb.Append("  and im.BillCategoryID=@BillCategoryID ");
          
            sb.Append(" Order by im.TypeName ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Doctor_ID", Doctor_ID),
                   new MySqlParameter("@SubCategoryID", SubCategoryID),
                   new MySqlParameter("@BillCategoryID", CategoryBill),
                   new MySqlParameter("@CentreID", Panel_ID),
                   new MySqlParameter("@CityID", DocCategory)).Tables[0];
            return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    public static string SaveDocDepartmentShare(List<DocShareDetail> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {

                if (Data[0].SearchType == 1)
                {
                    if (Data[0].PanelID == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID  and CityID=@CityID   AND SubCategoryID=@SubCategoryID ",
                              new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                              new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                               new MySqlParameter("@Panel_ID", 0),
                                new MySqlParameter("@CityID", Data[0].DocCategory));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID AND  SubCategoryID=@SubCategoryID and CityID=@CityID",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID),
                                  new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                                 new MySqlParameter("@CityID", Data[0].DocCategory));

                        DataTable dtCentre = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT CentreID FROM centre_master WHERE isActive=1").Tables[0];
                        for (int i = 0; i < Data.Count; i++)
                        {
                            for (int j = 0; j < dtCentre.Rows.Count; j++)
                            {

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,SubCategoryID,DocSharePer,CreatedByID,Panel_ID,CentreID,CityID)VALUES(@Doctor_ID,@SubCategoryID,@DocSharePer,@CreatedByID,@Panel_ID,@CentreID,@CityID)",
                                    new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID),
                                    new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                     new MySqlParameter("@Panel_ID", 0),
                                     new MySqlParameter("@CentreID", Util.GetInt(dtCentre.Rows[j]["CentreID"])),
                                     new MySqlParameter("@CityID", Data[0].DocCategory));
                            }

                        }
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID  and CentreID=@CentreID and CityID=@CityID   AND SubCategoryID=@SubCategoryID ",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                                new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                                 new MySqlParameter("@Panel_ID", 0),
                                  new MySqlParameter("@CentreID", Data[0].PanelID),
                                  new MySqlParameter("@CityID", Data[0].DocCategory));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID AND CentreID=@CentreID AND  SubCategoryID=@SubCategoryID and CityID=@CityID",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID),
                                  new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                                 new MySqlParameter("@CentreID", Data[0].PanelID),
                                 new MySqlParameter("@CityID", Data[0].DocCategory));

                        for (int i = 0; i < Data.Count; i++)
                        {

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,SubCategoryID,DocSharePer,CreatedByID,Panel_ID,CentreID,CityID)VALUES(@Doctor_ID,@SubCategoryID,@DocSharePer,@CreatedByID,@Panel_ID,@CentreID,@CityID)",
                                new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID),
                                new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                 new MySqlParameter("@Panel_ID", 0),
                                 new MySqlParameter("@CentreID", Data[0].PanelID),
                                 new MySqlParameter("@CityID", Data[0].DocCategory));

                        }
                    }
                }
                else
                {
                    if (Data[0].PanelID == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID AND SubCategoryID=@SubCategoryID ",
                                       new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                                       new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID AND  SubCategoryID=@SubCategoryID ",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID),
                                  new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID));

                        DataTable dtCentre = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT CentreID FROM centre_master WHERE isActive=1").Tables[0];
                        for (int i = 0; i < Data.Count; i++)
                        {
                            for (int j = 0; j < dtCentre.Rows.Count; j++)
                            {

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,SubCategoryID,DocSharePer,CreatedByID,Panel_ID,CentreID)VALUES(@Doctor_ID,@SubCategoryID,@DocSharePer,@CreatedByID,@Panel_ID,@CentreID)",
                                    new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID),
                                    new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                    new MySqlParameter("@CentreID", Util.GetInt(dtCentre.Rows[j]["CentreID"])),
                                     new MySqlParameter("@Panel_ID", 0));
                            }
                        }
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID and CentreID=@CentreID  AND SubCategoryID=@SubCategoryID ",
                                       new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                                       new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                                        new MySqlParameter("@CentreID", Data[0].PanelID));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID AND CentreID=@CentreID AND  SubCategoryID=@SubCategoryID ",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID),
                                  new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                                 new MySqlParameter("@CentreID", Data[0].PanelID));


                        for (int i = 0; i < Data.Count; i++)
                        {

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,SubCategoryID,DocSharePer,CreatedByID,Panel_ID,CentreID)VALUES(@Doctor_ID,@SubCategoryID,@DocSharePer,@CreatedByID,@Panel_ID,@CentreID)",
                                new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID),
                                new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                new MySqlParameter("@CentreID", Data[i].PanelID),
                                 new MySqlParameter("@Panel_ID", 0));

                        }
                    }
                }
                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

                return "0";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }

    }
    [WebMethod(EnableSession = true)]
    public static string SaveDocItemShare(List<DocShareDetail> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                DataTable dt = new DataTable();
                if (Data[0].SearchType == 1)
                {
                    if (Data[0].PanelID == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID AND ItemID=@ItemID  AND SubCategoryID=@SubCategoryID and CityID=@CityID  ",
                                    new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                                    new MySqlParameter("@ItemID", Data[0].ItemID),
                                    new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                                    new MySqlParameter("@CityID", Data[0].DocCategory));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID  AND  ItemID=@ItemID AND SubCategoryID=@SubCategoryID  and CityID=@CityID ",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@ItemID", Data[0].ItemID), new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID), new MySqlParameter("@CityID", Data[0].DocCategory));

                        DataTable dtCentre = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT CentreID FROM centre_master WHERE isActive=1").Tables[0];
                        for (int i = 0; i < Data.Count; i++)
                        {
                            for (int j = 0; j < dtCentre.Rows.Count; j++)
                            {

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,ItemID,DocSharePer,DocShareAmt,CreatedByID,CentreID,SubCategoryID,CityID)VALUES(@Doctor_ID,@ItemID,@DocSharePer,@DocShareAmt,@CreatedByID,@CentreID,@SubCategoryID,@CityID)",
                                        new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@DocShareAmt", Data[i].DocShareAmt), new MySqlParameter("@ItemID", Data[i].ItemID),
                                        new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CentreID", Util.GetInt(dtCentre.Rows[j]["CentreID"])), new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID), new MySqlParameter("@CityID", Data[0].DocCategory));
                            }
                        }
                    }
                    else
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID  AND CentreID=@CentreID AND ItemID=@ItemID  AND SubCategoryID=@SubCategoryID and CityID=@CityID  ",
                                      new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                                      new MySqlParameter("@ItemID", Data[0].ItemID),
                                      new MySqlParameter("@CentreID", Data[0].PanelID), new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                                      new MySqlParameter("@CityID", Data[0].DocCategory));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID  AND CentreID=@CentreID AND  ItemID=@ItemID AND SubCategoryID=@SubCategoryID  and CityID=@CityID ",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@ItemID", Data[0].ItemID), new MySqlParameter("@CentreID", Data[0].PanelID), new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID), new MySqlParameter("@CityID", Data[0].DocCategory));

                        for (int i = 0; i < Data.Count; i++)
                        {

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,ItemID,DocSharePer,DocShareAmt,CreatedByID,CentreID,SubCategoryID,CityID)VALUES(@Doctor_ID,@ItemID,@DocSharePer,@DocShareAmt,@CreatedByID,@CentreID,@SubCategoryID,@CityID)",
                                    new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@DocShareAmt", Data[i].DocShareAmt), new MySqlParameter("@ItemID", Data[i].ItemID),
                                    new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CentreID", Data[i].PanelID), new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID), new MySqlParameter("@CityID", Data[0].DocCategory));
                        }
                    }
                }
                else
                {
                    if (Data[0].PanelID == 0)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID  AND ItemID=@ItemID  AND SubCategoryID=@SubCategoryID ",
                                        new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                                        new MySqlParameter("@ItemID", Data[0].ItemID),
                                        new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID AND  ItemID=@ItemID AND SubCategoryID=@SubCategoryID ",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@ItemID", Data[0].ItemID), new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID));

                        DataTable dtCentre = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT CentreID FROM centre_master WHERE isActive=1").Tables[0];
                        for (int i = 0; i < Data.Count; i++)
                        {
                            for (int j = 0; j < dtCentre.Rows.Count; j++)
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,ItemID,DocSharePer,DocShareAmt,CreatedByID,CentreID,SubCategoryID)VALUES(@Doctor_ID,@ItemID,@DocSharePer,@DocShareAmt,@CreatedByID,@CentreID,@SubCategoryID)",
                                        new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@DocShareAmt", Data[i].DocShareAmt), new MySqlParameter("@ItemID", Data[i].ItemID),
                                        new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CentreID", Util.GetInt(dtCentre.Rows[j]["CentreID"])), new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID));
                            }
                        }
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID  AND CentreID=@CentreID  AND SubCategoryID=@SubCategoryID ",
                                      new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                                      new MySqlParameter("@ItemID", Data[0].ItemID),
                                      new MySqlParameter("@CentreID", Data[0].PanelID), new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID  AND CentreID=@CentreID  AND SubCategoryID=@SubCategoryID ",
                                new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@ItemID", Data[0].ItemID), new MySqlParameter("@CentreID", Data[0].PanelID), new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID));

                        for (int i = 0; i < Data.Count; i++)
                        {

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,ItemID,DocSharePer,DocShareAmt,CreatedByID,CentreID,SubCategoryID)VALUES(@Doctor_ID,@ItemID,@DocSharePer,@DocShareAmt,@CreatedByID,@CentreID,@SubCategoryID)",
                                    new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@DocShareAmt", Data[i].DocShareAmt), new MySqlParameter("@ItemID", Data[i].ItemID),
                                    new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CentreID", Data[i].PanelID), new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID));
                        }
                    }
                }
                tnx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

                return "0";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }

    }
    [WebMethod(EnableSession = true)]
    public static string transferDocShare(string FromDoctorID, string ToDoctorID)
    {
        if (FromDoctorID == ToDoctorID)
            return "2";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            int docShareCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID",
                  new MySqlParameter("@Doctor_ID", FromDoctorID)));
            if (docShareCount > 0)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID ",
                                 new MySqlParameter("@Doctor_ID", ToDoctorID), new MySqlParameter("@DeletedBy", UserInfo.ID));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID ",
                    new MySqlParameter("@Doctor_ID", ToDoctorID));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,ItemID,DocSharePer,DocShareAmt,CreatedByID) SELECT @ToDoctorID,ItemID,DocSharePer,DocShareAmt,CreatedByID FROM doctor_referral_share_items WHERE Doctor_ID=@FromDoctorID",
                    new MySqlParameter("@FromDoctorID", FromDoctorID), new MySqlParameter("@ToDoctorID", ToDoctorID));

                tnx.Commit();
                return "1";
            }
            else
                return "3";
        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string SaveAutoCorrect(int SubcategoryID, string AutoKey, string AutoDescription)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO autocorrect_detail(AutoKey,AutoDescription,SubCategoryID,CreatedDate,CreateBy) values (@AutoKey,@AutoDescription,@SubCategoryID,@CreatedDate,@CreateBy)",
                      new MySqlParameter("@AutoKey", AutoKey.ToLower()),
                      new MySqlParameter("@AutoDescription", AutoDescription.ToLower()),
                       new MySqlParameter("@SubCategoryID", SubcategoryID),
                        new MySqlParameter("@CreatedDate", DateTime.Now.Date),
                         new MySqlParameter("@CreateBy", UserInfo.LoginName));

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    public static string RemoveAutoCorrect(int id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update autocorrect_detail set IsActive=0,UpdatedDate=@UpdatedDate,UpdatedBy=@UpdatedBy where ID=@ID ",
                      new MySqlParameter("@ID", id),
                      new MySqlParameter("@UpdatedDate", DateTime.Now.Date),
                       new MySqlParameter("@UpdatedBy", UserInfo.LoginName));

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }
    


    public class DocShareDetail
    {
        public string Doctor_ID { get; set; }
        public float DocSharePer { get; set; }
        public float DocShareAmt { get; set; }
        public string Subcategory_ID { get; set; }
        public string ItemID { get; set; }
        public Int16 SearchType { get; set; }
        public int PanelID { get; set; }
        public string DocCategory { get; set; }
    }
}