using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_DocAccount_DocShareMaster : System.Web.UI.Page
{
	
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
				string id =Util.GetInt(Session["Centre"]).ToString();
            ddlPanelDept.DataSource = StockReports.GetDataTable("Select Panel_ID,Company_Name from f_panel_master where IsActive=1 and TagBusinessLabID='" + id + "' order by company_name;");
            ddlPanelDept.DataTextField = "Company_Name";
            ddlPanelDept.DataValueField = "Panel_ID";
            ddlPanelDept.DataBind();
          //  ddlPanelDept.Items.Insert(0,new ListItem("select","0"));
            ddlPanelItem.DataSource = StockReports.GetDataTable("Select Panel_ID,Company_Name from f_panel_master where IsActive=1 and TagBusinessLabID='" + id + "' order by company_name;");
            ddlPanelItem.DataTextField = "Company_Name";
            ddlPanelItem.DataValueField = "Panel_ID";
            ddlPanelItem.DataBind();
            ddlPanelItem.Items.Insert(0, new ListItem("select", "0"));

            ddlcategory.DataSource = StockReports.GetDataTable(" SELECT ID,NAME FROM `billingcategory_master` WHERE IsActive=1 ORDER BY NAME ");
            ddlcategory.DataTextField = "NAME";
            ddlcategory.DataValueField = "ID";
            ddlcategory.DataBind();
            ddlcategory.Items.Insert(0, new ListItem("select", "0"));
        }
    }

    [WebMethod]
    public static string getDoctorReferal()
    {
		string id = Util.GetInt(HttpContext.Current.Session["Centre"]).ToString();
        return Util.getJson(StockReports.GetDataTable("SELECT Doctor_ID,Name FROM doctor_referal WHERE isReferal=1 and centreid='" + id + "'"));
    }
    [WebMethod]
    public static string getDepartment(int searchType, string Doctor_ID,int Panel_ID)
    {       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("SELECT sub.SubCategoryID,sub.Name,IFNULL(doc.DocSharePer,0)DocSharePer ");         
            sb.Append(" FROM f_subcategorymaster sub");
            sb.Append(" LEFT JOIN  doctor_referral_share_items doc ON sub.SubCategoryID=doc.SubCategoryID and ifnull(doc.ItemID,'')=''  ");               
                
                if (searchType == 1)
                {
                    sb.Append("  AND doc.Doctor_ID=0  ");
                }
                else
                {
                    if (Doctor_ID != "0")
                        sb.Append("  AND doc.Doctor_ID=@Doctor_ID ");
                }
                if (Panel_ID != 0)
                    sb.Append("  AND doc.Panel_ID=@Panel_ID ");          
                sb.Append(" WHERE sub.ACTIVE='1' Order by sub.Name ");
				//System.IO.File.WriteAllText(@"C:\kolitem.txt", sb.ToString());
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@Doctor_ID", Doctor_ID),
                     new MySqlParameter("@Panel_ID", Panel_ID)).Tables[0];
           
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
    public static string getItem(int searchType, string SubCategoryID, string Doctor_ID, int CategoryBill, int Panel_ID)
    {        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            DataTable dt = new DataTable();

            sb.Append("SELECT im.ItemID,im.TypeName,im.TestCode ,IFNULL(doc.DocSharePer,0)DocSharePer,IFNULL(doc.DocShareAmt,0)DocShareAmt");
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
                sb.Append("  AND doc.Panel_ID=@Panel_ID ");
            if (Util.GetString(SubCategoryID) != "0")
                sb.Append(" Where im.SubCategoryID=@SubCategoryID ");
            if (CategoryBill != 0)
                sb.Append("  and im.BillCategoryID=@BillCategoryID ");
            sb.Append(" AND IM.ISACTIVE='1' Order by im.TypeName ");
			//System.IO.File.WriteAllText(@"C:\kolitem.txt", sb.ToString());
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Doctor_ID", Doctor_ID),
                   new MySqlParameter("@SubCategoryID", SubCategoryID),
                   new MySqlParameter("@BillCategoryID", CategoryBill),
                   new MySqlParameter("@Panel_ID", Panel_ID)).Tables[0];
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
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID and Panel_ID=@Panel_ID  AND SubCategoryID=@SubCategoryID ",
                               new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                               new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID),
                                new MySqlParameter("@Panel_ID", Data[0].PanelID));

                
              

                for (int i = 0; i < Data.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID AND Panel_ID=@Panel_ID  AND  SubCategoryID=@SubCategoryID ",
                          new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID),
                            new MySqlParameter("@SubCategoryID",  Data[i].Subcategory_ID),
                           new MySqlParameter("@Panel_ID", Data[i].PanelID));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,SubCategoryID,DocSharePer,CreatedByID,Panel_ID)VALUES(@Doctor_ID,@SubCategoryID,@DocSharePer,@CreatedByID,@Panel_ID)",
                            new MySqlParameter("@DocSharePer", Data[i].DocSharePer), 
                            new MySqlParameter("@SubCategoryID", Data[i].Subcategory_ID),
                            new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID),
                            new MySqlParameter("@Panel_ID", Data[i].PanelID));
                                         
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
                
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referral_share_items SET DeletedOn=NOW(),DeletedBy=@DeletedBy WHERE Doctor_ID=@Doctor_ID  AND Panel_ID=@Panel_ID AND ItemID=@ItemID  AND SubCategoryID=@SubCategoryID ",
                              new MySqlParameter("@Doctor_ID", Data[0].Doctor_ID), new MySqlParameter("@DeletedBy", UserInfo.ID),
                              new MySqlParameter("@ItemID", Data[0].ItemID),
                              new MySqlParameter("@Panel_ID", Data[0].PanelID),new MySqlParameter("@SubCategoryID", Data[0].Subcategory_ID));

               
                for (int i = 0; i < Data.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM doctor_referral_share_items WHERE Doctor_ID=@Doctor_ID  AND Panel_ID=@Panel_ID AND  ItemID=@ItemID ",
                                           new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@ItemID", Data[i].ItemID), new MySqlParameter("@Panel_ID", Data[i].PanelID));
                    
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO doctor_referral_share_items(Doctor_ID,ItemID,DocSharePer,DocShareAmt,CreatedByID,Panel_ID,SubCategoryID)VALUES(@Doctor_ID,@ItemID,@DocSharePer,@DocShareAmt,@CreatedByID,@Panel_ID,@SubCategoryID)",
                            new MySqlParameter("@DocSharePer", Data[i].DocSharePer), new MySqlParameter("@DocShareAmt", Data[i].DocShareAmt), new MySqlParameter("@ItemID", Data[i].ItemID),
                            new MySqlParameter("@Doctor_ID", Data[i].Doctor_ID), new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@Panel_ID", Data[i].PanelID), new MySqlParameter("@SubCategoryID",Data[i].Subcategory_ID)); //new MySqlParameter("@SubCategoryID","0"));                                       
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


    public class DocShareDetail
    {
        public string Doctor_ID { get; set; }
        public float DocSharePer { get; set; }
        public float DocShareAmt { get; set; }
        public string Subcategory_ID { get; set; }
        public string ItemID { get; set; }
        public Int16 SearchType { get; set; }
        public int PanelID { get; set; }
    }
}