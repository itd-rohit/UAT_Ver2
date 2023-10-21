using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_MemberShipCard_MembershipCardMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string bindMembershipData()
    {
        using (DataTable dt = bindMembershipDetail())
        {
            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(new { status = "true", responseDetail = Util.getJson(dt) });
            else
                return JsonConvert.SerializeObject(new { status = false, responseDetail = string.Empty });
        }
    }

    public static DataTable bindMembershipDetail()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,NAME CardName,Description,No_of_dependant,ValidYear,ValidMonth,ValidDays,CONCAT(ValidYear,' ','Years ',ValidMonth,' ','Months ',ValidDays,' ','Days')Validity,DATE_FORMAT(ValidUpTo,'%d-%b-%Y')ValidUpTo,Amount,Image,IF(IsActive = 1,'Active','De-Active')Active,IsActive FROM membership_card_master  "))
        {
            return dt;
        }
    }

    [WebMethod]
    public static string saveMembership(object MembershipData)
    {
        List<MemberShipDetail> MembershipDataDetail = new JavaScriptSerializer().ConvertToType<List<MemberShipDetail>>(MembershipData);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO membership_card_master(NAME,Description,No_of_dependant,Amount,CreatedByID,CreatedBy,Image,IsActive,SubCategoryID,ValidYear,ValidMonth,ValidDays,ValidUpTo)");
            sb.Append(" VALUES (@NAME,@Description,@No_of_dependant,@Amount,@CreatedByID,@CreatedByID,@Image,@IsActive,27,@ValidYear,@ValidMonth,@ValidDays,@ValidUpTo) ");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@NAME", MembershipDataDetail[0].CardName),
                new MySqlParameter("@Description", MembershipDataDetail[0].Description),
                new MySqlParameter("@No_of_dependant", MembershipDataDetail[0].NoOfDependant),
                new MySqlParameter("@Amount", MembershipDataDetail[0].Amount),
                new MySqlParameter("@CreatedByID", UserInfo.ID),
                new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                new MySqlParameter("@Image", ""),
                new MySqlParameter("@IsActive", MembershipDataDetail[0].IsActive),
                new MySqlParameter("@ValidYear", MembershipDataDetail[0].ValidYear),
                new MySqlParameter("@ValidMonth", MembershipDataDetail[0].ValidMonth),
                new MySqlParameter("@ValidDays", MembershipDataDetail[0].ValidDays),
                new MySqlParameter("@ValidUpTo", MembershipDataDetail[0].ValidUpTo)
                );
            int id = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));

            ItemMaster im = new ItemMaster(tnx);
            im.SubCategoryID = 27;
            im.Type_ID = id;
            im.TypeName = MembershipDataDetail[0].CardName.Trim();
            im.CreaterID = UserInfo.ID;
            string ItemID = im.Insert();

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update membership_card_master SET ItemID=@ItemID where ID=@id",
                new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@id", id));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string updateMembership(object MembershipData)
    {
        List<MemberShipDetail> MembershipDataDetail = new JavaScriptSerializer().ConvertToType<List<MemberShipDetail>>(MembershipData);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE membership_card_master SET NAME=@NAME,Description=@Description,Amount=@Amount,No_of_dependant=@No_of_dependant,");
            sb.Append(" IsActive=@IsActive,UpdatedByID=@UpdatedByID,UpdatedDate=NOW(),UpdatedBy=@UpdatedBy,Image=@SETImage,ValidYear=@ValidYear,ValidMonth=@ValidMonth,ValidDays=@ValidDays,ValidUpTo=@ValidUpTo WHERE ID=@ID");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@NAME", MembershipDataDetail[0].CardName.Trim()),
               new MySqlParameter("@Description", MembershipDataDetail[0].Description),              
               new MySqlParameter("@Amount", MembershipDataDetail[0].Amount),
               new MySqlParameter("@No_of_dependant", MembershipDataDetail[0].NoOfDependant),
               new MySqlParameter("@IsActive", MembershipDataDetail[0].IsActive),
               new MySqlParameter("@UpdatedByID", UserInfo.ID),
               new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
               new MySqlParameter("@ID", MembershipDataDetail[0].ID),
               new MySqlParameter("@ValidYear", MembershipDataDetail[0].ValidYear),
               new MySqlParameter("@ValidMonth", MembershipDataDetail[0].ValidMonth),
               new MySqlParameter("@ValidDays", MembershipDataDetail[0].ValidDays),
               new MySqlParameter("@ValidUpTo", MembershipDataDetail[0].ValidUpTo),
               new MySqlParameter("@SETImage", ""));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", response = "Membership Card Updated Sucessfully", responseDetail = Util.getJson(bindMembershipDetail()) });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class MemberShipDetail
    {
        public string CardName { get; set; }
        public string Description { get; set; }
        public int NoOfDependant { get; set; }
        public decimal Amount { get; set; }
        public int? ValidYear { get; set; }
        public int? ValidMonth { get; set; }
        public int? ValidDays { get; set; }
        public sbyte IsActive { get; set; }
        public int? ID { get; set; }
        public DateTime? ValidUpTo { get; set; }
    }
}