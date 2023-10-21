using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_MemberShipCard_MembershipCardSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);

            ddlCardType.DataSource = StockReports.GetDataTable("SELECT ID,NAME FROM membership_card_master WHERE IsActive=1");
            ddlCardType.DataValueField = "ID";
            ddlCardType.DataTextField = "Name";
            ddlCardType.DataBind();
            ddlCardType.Items.Insert(0, new ListItem("Select", "0"));

            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
    }

    [WebMethod]
    public static string searchcard(string fromdate, string todate, string cardtype, string cardno, string UHIDNo, string mobileno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT mm.ID,mm.cardno,mm.name,mm.age,mm.gender,mm.mobile,mm.`MembershipCardID`,DATE_FORMAT(mm.validfrom,'%d-%b-%Y')validfrom, ");
            sb.Append(" DATE_FORMAT(mm.ValidTo,'%d-%b-%Y') ValidTo,mm.amount,DATE_FORMAT(mm.CreatedDate,'%d-%b-%Y %h:%i %p')entrydate, ");
            sb.Append(" mmi.name cardName,mm.LedgerTransactionID,mm.`CreatedBy` issueby,mm.LedgerTransactionID,mm.FamilyMemberGroupID ");
            sb.Append(" FROM `membershipcard` mm INNER JOIN `membership_card_master` mmi ON mmi.id=mm.MembershipCardID ");
            if (UHIDNo != string.Empty || mobileno != string.Empty)
            {
                sb.Append("  INNER JOIN `membershipcard_member` mem ON mem.FamilyMemberGroupID=mm.FamilyMemberGroupID ");
            }
            sb.Append(" WHERE mm.`IsActive`=1 ");
            if (cardtype == "0" && cardno == string.Empty && UHIDNo == string.Empty && mobileno == string.Empty)
            {
                sb.Append(" and mm.CreatedDate>=@fromDate");
                sb.Append(" and mm.CreatedDate<=@toDate");

            }
            if (cardtype != "0")
            {
                sb.Append(" and mm.MembershipCardID=@cardtype");
            }
            if (cardno != string.Empty)
            {
                sb.Append(" and mm.cardno=@cardno");
            }
            if (UHIDNo != string.Empty)
            {
               sb.Append(" AND mem.Patient_ID = @Patient_ID");
            }
            if (mobileno != string.Empty)
            {
                sb.Append(" and mem.mobile like @mobileno");
            }
            sb.Append(" ORDER BY mm.CreatedDate ");
           //System.IO.File.WriteAllText (@"D:\Shat\aa.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                     new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59")),
                     new MySqlParameter("@cardtype", cardtype),
                     new MySqlParameter("@cardno", cardno), new MySqlParameter("@mobileno", string.Format("%{0}%", mobileno)),
                     new MySqlParameter("@Patient_ID", UHIDNo)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false,
                response = "Error"
            });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindMembershipMember(string FamilyMemberGroupID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT MembershipCardNo,patient_id,pname,age,gender,relation,Mobile, ");
            sb.Append(" IF(FamilyMemberIsPrimary=1,'Yes','No')FamilyMemberIsPrimary,FamilyMemberIsPrimary IsPrimary ");
            sb.Append(" FROM `membershipcard_member` where FamilyMemberGroupID=@FamilyMemberGroupID");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID)).Tables[0])
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false,
                response = "Error"
            });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string EncryptData(string data)
    {
        return Common.Encrypt(data);
    }

    [WebMethod]
    public static string getcarddetail(int FamilyMemberGroupID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.TestCode,im.`TypeName` ItemName,sm.`Name` deptname,t1.* FROM ( ");
            sb.Append(" SELECT ItemID,SUM(SelfDisc)SelfDisc,SUM(DependentDisc)DependentDisc, ");
            sb.Append(" SUM(SelfFreeTestCount)SelfFreeTestCount, SUM(DependentFreeTestCount)DependentFreeTestCount ");
            sb.Append(" FROM ( ");
            sb.Append("       SELECT mem.`ItemID`, SelfDisc,0 DependentDisc,SelfFreeTestCount,0 DependentFreeTestCount ,FamilyMemberIsPrimary ");
            sb.Append("       FROM membershipcard_Detail  mem WHERE FamilyMemberIsPrimary=1 AND FamilyMemberGroupID=@FamilyMemberGroupID ");
            sb.Append(" UNION ALL ");
            sb.Append("       SELECT mem.`ItemID`, 0 SelfDisc,DependentDisc,0 SelfFreeTestCount,DependentFreeTestCount ,FamilyMemberIsPrimary ");
            sb.Append("       FROM membershipcard_Detail  mem WHERE FamilyMemberIsPrimary=0 AND FamilyMemberGroupID=@FamilyMemberGroupID GROUP BY mem.`ItemID`  ");
            sb.Append("      )t  GROUP BY t.ItemID  )t1 ");
            sb.Append(" INNER JOIN `f_itemmaster` im ON im.`ItemID`=t1.`ItemID` INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=im.`Subcategoryid` ");
            sb.Append(" ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID)).Tables[0])
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false,
                response = "Error"
            });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string getAllCardDetail(string Patient_ID, int FamilyMemberIsPrimary)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT im.TestCode,im.`TypeName` ItemName,sm.`Name` deptname, ");
            if (FamilyMemberIsPrimary == 1)
                sb.Append("       mem.`ItemID`, SelfDisc,0 DependentDisc,SelfFreeTestCount,0 DependentFreeTestCount ,FamilyMemberIsPrimary,SelfFreeTestConsume,0 DependentFreeTestConsume ");
            else
                sb.Append("       mem.`ItemID`,0 SelfDisc,DependentDisc,0 SelfFreeTestCount,DependentFreeTestCount ,FamilyMemberIsPrimary,0 SelfFreeTestConsume,DependentFreeTestConsume ");

            sb.Append("       FROM membershipcard_Detail  mem  ");
            sb.Append(" INNER JOIN `f_itemmaster` im ON im.`ItemID`=mem.`ItemID` INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=im.`Subcategoryid` ");
            sb.Append(" WHERE  mem.Patient_ID=@Patient_ID");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Patient_ID", Patient_ID)).Tables[0])
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false,
                response = "Error"
            });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string encryptCardNo(string CardNo)
    {

        return Common.Encrypt(CardNo);
    }
}