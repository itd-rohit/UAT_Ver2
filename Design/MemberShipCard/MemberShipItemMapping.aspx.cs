using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_MemberShipCard_MemberShipItemMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      if (!Page.IsPostBack)
        bindDepartment();
    }
    private void bindDepartment()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT SubCategoryID,Name FROM f_subcategorymaster WHERE Active=1"))
        {
            if (dt.Rows.Count > 0)
            {
                ddlDepartment.DataSource = dt;
                ddlDepartment.DataTextField = "Name";
                ddlDepartment.DataValueField = "SubCategoryID";
                ddlDepartment.DataBind();
                ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
            }
        }
    }
    [WebMethod]
    public static string geType()
    {
        return JsonConvert.SerializeObject(new
        {
            status = "true",
            response = Util.getJson(StockReports.GetDataTable("SELECT ID,Name FROM membership_card_master WHERE IsActive = 1 ORDER BY NAME "))

        });

    }
    [WebMethod]
    public static string getItem(int SubCategoryID, int MemberShipID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT im.ItemID,im.SubcategoryID,im.TypeName,im.TestCode,IFNULL(met.SelfDisc,'')SelfDisc,IFNULL(met.DependentDisc,'')DependentDisc,   ");
            sb.Append(" IFNULL(met.SelfFreeTest,'')SelfFreeTest,IFNULL(met.DependentFreeTest,'')DependentFreeTest, ");
            sb.Append(" IFNULL(met.SelfFreeTestCount,'')SelfFreeTestCount,IFNULL(met.DependentFreeTestCount,'')DependentFreeTestCount ");
            sb.Append(" FROM f_ItemMaster im ");
            sb.Append(" LEFT JOIN  membershipcard_tests_master met ON im.ItemID=met.ItemID AND met.MemberShipID=@MemberShipID ");
            sb.Append(" WHERE im.SubCategoryID=@SubCategoryID ");


            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@MemberShipID", MemberShipID), new MySqlParameter("@SubCategoryID", SubCategoryID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = string.Empty });
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SaveMapping(List<ItemMapping> MemberShipItemMapping, int MembershipCardID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("UPDATE membershipcard_tests_master SET UpdatedDate=NOW(),UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID WHERE MemberShipID=@MemberShipID AND SubcategoryID=@SubcategoryID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@SubcategoryID", MemberShipItemMapping[0].SubcategoryID),
                  new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                  new MySqlParameter("@UpdatedByID", UserInfo.ID),
                  new MySqlParameter("@MemberShipID", MembershipCardID));

            sb = new StringBuilder();
            sb.Append(" DELETE FROM membershipcard_tests_master WHERE MemberShipID=@MemberShipID AND SubcategoryID=@SubcategoryID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@SubcategoryID", MemberShipItemMapping[0].SubcategoryID),
                 new MySqlParameter("@MemberShipID", MembershipCardID));


            for (int i = 0; i < MemberShipItemMapping.Count; i++)
            {
                if (MemberShipItemMapping[i].SelfDisc > 0 || MemberShipItemMapping[i].DependentDisc > 0 || MemberShipItemMapping[i].SelfFreeTest != 0 || MemberShipItemMapping[i].DependentFreeTest != 0)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO membershipcard_tests_master(SubcategoryID,ItemID,MemberShipID,SelfDisc,DependentDisc,SelfFreeTest,DependentFreeTest,SelfFreeTestCount,DependentFreeTestCount,CreatedBy,CreatedByID)");
                    sb.Append(" VALUES(@SubcategoryID,@ItemID,@MemberShipID,@SelfDisc,@DependentDisc,@SelfFreeTest,@DependentFreeTest,@SelfFreeTestCount,@DependentFreeTestCount,@CreatedBy,@CreatedByID)");


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@SubcategoryID", MemberShipItemMapping[i].SubcategoryID), new MySqlParameter("@ItemID", MemberShipItemMapping[i].ItemId),
                        new MySqlParameter("@MemberShipID", MembershipCardID), new MySqlParameter("@SelfDisc", MemberShipItemMapping[i].SelfDisc ?? 0),
                        new MySqlParameter("@DependentDisc", MemberShipItemMapping[i].DependentDisc ?? 0), new MySqlParameter("@SelfFreeTest", MemberShipItemMapping[i].SelfFreeTest ?? 0),
                        new MySqlParameter("@DependentFreeTest", MemberShipItemMapping[i].DependentFreeTest ?? 0), new MySqlParameter("@SelfFreeTestCount", MemberShipItemMapping[i].SelfFreeTestCount ?? 0),
                        new MySqlParameter("@DependentFreeTestCount", MemberShipItemMapping[i].DependentFreeTestCount ?? 0), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                        new MySqlParameter("@CreatedByID", UserInfo.ID));
                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class ItemMapping
    {
        public int SubcategoryID { get; set; }
        public int ItemId { get; set; }
        public int? SelfDisc { get; set; }
        public int? DependentDisc { get; set; }
        public int? SelfFreeTest { get; set; }
        public int? SelfFreeTestCount { get; set; }
        public int? DependentFreeTest { get; set; }
        public int? DependentFreeTestCount { get; set; }
    }
}