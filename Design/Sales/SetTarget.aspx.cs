using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Store_SetTarget : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategory();
        }
    }

    private void BindCategory()
    {
        string Sql = "SELECT s.Id,s.SalesCategory FROM f_SalesCategory_master s WHERE s.IsActive=1";
        DataTable dt = StockReports.GetDataTable(Sql);
        if (dt != null && dt.Rows.Count > 0)
        {
            rbtCategory.DataSource = dt;
            rbtCategory.DataTextField = "SalesCategory";
            rbtCategory.DataValueField = "Id";
            rbtCategory.DataBind();
            rbtCategory.SelectedIndex = rbtCategory.Items.IndexOf(rbtCategory.Items.FindByValue("1"));
        }
    }

    [WebMethod]
    public static string BindSalesAnnualTarget(string SalesCategoryID, string FilterID, string FinancialYear)
    {
        try
        {
            string SalesCategory = "";
            int CurrentFinancialYear = 0;
            if (SalesCategoryID == "2")
            {
                SalesCategory = Util.GetString(StockReports.ExecuteScalar(" SELECT IM.TypeName FROM pathcare.f_itemmaster im WHERE im.IsActive=1 AND im.ItemID='" + FilterID + "'  "));
            }
            else
            {
                SalesCategory = Util.GetString(StockReports.ExecuteScalar("SELECT s.SalesCategory FROM f_SalesCategory_master s WHERE s.Id=" + SalesCategoryID + " "));
                FilterID = SalesCategoryID;
            }
            StringBuilder sb = new StringBuilder();

            int IsExist = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_annualtargetdetails ad WHERE ad.FinancialYearId=" + FinancialYear + " AND ad.TargetTypeId=" + SalesCategoryID + " AND ad.IsCancel=0 "));

            if (IsExist == 0 && FilterID == "0" && SalesCategoryID == "2")
            {
                return "";
            }

            CurrentFinancialYear = Util.GetInt(StockReports.ExecuteScalar(" SELECT DATE_FORMAT(f.FromDate,'%Y')FinancialYearStart FROM f_financialyear_master f WHERE f.id=" + FinancialYear + " "));
            sb.Append(" SELECT '" + IsExist + "' IsExist, '" + FinancialYear + "' FinacialYearID, '" + SalesCategoryID + "' SalesID, ");

            //sb.Append(" IF( CURDATE()>='" + CurrentFinancialYear + "-04-01','true','false')FinalDisable, ");
            //sb.Append(" IF(H.Id=1,IF(CURDATE()>='" + CurrentFinancialYear + "-04-01','true','false'), IF(CURDATE()>='" + CurrentFinancialYear + "-10-01','true','false'))HalfYearlyDisable, ");
            //sb.Append(" IF(q.Id=1,IF(CURDATE()>='" + CurrentFinancialYear + "-04-01' ,'true','false'),IF(q.Id=2,IF(CURDATE()>='" + CurrentFinancialYear + "-07-01','true','false'), IF(q.Id=3,IF(CURDATE()>='" + CurrentFinancialYear + "-10-01','true','false'),IF(CURDATE()>=CONCAT(" + CurrentFinancialYear + "+1,'-01-01'),'true','false'))))QuarterDisable, ");
            //sb.Append(" IF(DATE_FORMAT(CURDATE(),'%Y-%m')>=IF(m.id<10,CONCAT('" + CurrentFinancialYear + "-',LPAD(m.Month,2,0)),CONCAT(" + CurrentFinancialYear + "+1,'-',LPAD(m.Month,2,0))),'true','false')MonthDisable,  ");

            sb.Append(" IF( CURDATE()>='" + CurrentFinancialYear + "-05-01','true','false')FinalDisable, ");
            sb.Append(" IF(H.Id=1,IF(CURDATE()>='" + CurrentFinancialYear + "-05-01','true','false'), IF(CURDATE()>='" + CurrentFinancialYear + "-11-01','true','false'))HalfYearlyDisable, ");
            sb.Append(" IF(q.Id=1,IF(CURDATE()>='" + CurrentFinancialYear + "-05-01' ,'true','false'),IF(q.Id=2,IF(CURDATE()>='" + CurrentFinancialYear + "-08-01','true','false'), IF(q.Id=3,IF(CURDATE()>='" + CurrentFinancialYear + "-11-01','true','false'),IF(CURDATE()>=CONCAT(" + CurrentFinancialYear + "+1,'-02-01'),'true','false'))))QuarterDisable, ");
            sb.Append(" IF(DATE_FORMAT(CURDATE(),'%Y-%m')>IF(m.id<10,CONCAT('" + CurrentFinancialYear + "-',LPAD(m.Month,2,0)),CONCAT(" + CurrentFinancialYear + "+1,'-',LPAD(m.Month,2,0))),'true','false')MonthDisable,  ");

            if (IsExist == 0)
                sb.Append(" '" + FilterID + "' SalesCategoryID,'" + SalesCategory + "' SalesCategory ");
            else
            {
                if (SalesCategoryID != "2")
                    sb.Append(" '" + FilterID + "' SalesCategoryID,'" + SalesCategory + "' SalesCategory ");
                else
                    sb.Append(" ad.ItemID SalesCategoryID,im.TypeName SalesCategory ");
            }

            sb.Append(" ,m.IsRowSpan IsQuarterRowSpan,IF(m.IsRowSpan=1 AND q.IsRowSpan=1,1,0) IsHalfRowSpan,IF(m.IsRowSpan=1 AND q.IsRowSpan=1 AND h.IsRowSpan=1,1,0) IsAnnualRowSpan, ");
            sb.Append(" IFNULL((SELECT COUNT(*) FROM f_month_master m1 INNER JOIN f_quarter_master q1 ON q1.Id=m1.QuarterId INNER JOIN f_halfyearly_master h1 ON H1.Id=Q1.HalfYearlyId WHERE H1.AnnualId=A.Id ),0)AnnualRowSpan, ");
            sb.Append(" IFNULL((SELECT COUNT(*) FROM f_month_master m1 INNER JOIN f_quarter_master q1 ON q1.Id=m1.QuarterId WHERE q1.HalfYearlyId=h.Id ),0)HalfYearlyRowSpan, ");
            sb.Append(" IFNULL((SELECT COUNT(*) FROM f_month_master m1 WHERE m1.QuarterId=Q.Id ),0)QuarterRowSpan, ");
            if (SalesCategoryID == "1")
            {
                sb.Append(" a.Id AnnualID,CONCAT(A.DisplayName,' ( ',A.Format,' ) <span class=Amt>₹</span>')AnnualFormat,h.Id HalfYearlyID,CONCAT(h.DisplayName,' ( ',h.Format,' ) <span class=Amt>₹</span>')HalfYearlyFormat, ");
                sb.Append(" q.Id QuarterID,CONCAT(q.DisplayName,' ( ',q.Format,' ) <span class=Amt>₹</span>')QuarterFormat,m.Id MonthID,concat(m.DisplayName,' <span class=Amt>₹</span>') MonthFormat ");
            }
            else
            {
                sb.Append(" a.Id AnnualID,CONCAT(A.DisplayName,' ( ',A.Format,' ) ')AnnualFormat,h.Id HalfYearlyID,CONCAT(h.DisplayName,' ( ',h.Format,' ) ')HalfYearlyFormat, ");
                sb.Append(" q.Id QuarterID,CONCAT(q.DisplayName,' ( ',q.Format,' ) ')QuarterFormat,m.Id MonthID,m.DisplayName MonthFormat ");
            }
            if (IsExist == 0)
            {
                sb.Append(" ,'' MonthTargetValue,'' QuarterTargetValue,'' HalfYearlyTargetValue,'' AnnualTargetValue FROM f_month_master m  ");
            }
            else
            {
                sb.Append(" ,ad.MonthTargetValue,ad.QuarterTargetValue,ad.HalfYearlyTargetValue,ad.AnnualTargetValue from f_annualtargetdetails ad INNER JOIN f_month_master m ON m.id=ad.MonthId ");
                if (SalesCategoryID == "2")
                {
                    sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=ad.ItemID ");
                }
            }
            sb.Append(" INNER JOIN f_quarter_master q ON q.Id=m.QuarterId ");
            sb.Append(" INNER JOIN f_halfyearly_master h ON h.Id=q.HalfYearlyId  ");
            sb.Append(" INNER JOIN f_annual_master a ON a.Id=h.AnnualId ");
            if (IsExist > 0)
            {
                sb.Append(" where ad.FinancialYearId=" + FinancialYear + " AND ad.TargetTypeId=" + SalesCategoryID + " AND ad.IsCancel=0  ORDER BY ad.id");
            }
            else
            {
                sb.Append(" ORDER BY a.id,h.id,q.id,m.id ");
            }
            DataTable dtDetail = StockReports.GetDataTable(sb.ToString());
            if (dtDetail.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetail);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string SearchTest(string TestName)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.ItemID  as value ,IM.TypeName AS label FROM f_itemmaster im WHERE im.IsActive=1 and im.TypeName LIKE '%" + TestName + "%' ORDER BY im.TypeName ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string BindFinancialYear()
    {
        try
        {
            string sql = "SELECT CONCAT(f.FinancialYear,' ( ',f.Format,' ) ')FinancialYear,f.ID FROM f_financialyear_master f WHERE IsActive=1 ORDER BY f.ID";
            DataTable dt = StockReports.GetDataTable(sql);
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string BindFromYear()
    {
        try
        {
            string sql = "SELECT Year FROM year_master WHERE YEAR>=YEAR(CURDATE()) ";
            DataTable dt = StockReports.GetDataTable(sql);
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string BindToYear(string FromYear)
    {
        try
        {
            string sql = "SELECT Year FROM year_master where Year>" + FromYear + " ";
            DataTable dt = StockReports.GetDataTable(sql);
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod]
    public static string BindFinancialYearList()
    {
        try
        {
            string sql = "SELECT IF(IFNULL((SELECT COUNT(*) FROM f_annualtarget a WHERE a.IsCancel=0 AND a.FinancialYearId=f.ID),0)>0,0,1)IsDelete ,ID,FinancialYear,ID,FinancialYear,DATE_FORMAT(FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT(ToDate,'%d-%b-%Y')ToDate FROM f_financialyear_master f WHERE IsActive=1 ";
            DataTable dt = StockReports.GetDataTable(sql);
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string DeleteFinancialYear(string Id)
    {
        try
        {
            string sql = "UPDATE f_financialyear_master SET IsActive=0 ,UpdatedBy='" + HttpContext.Current.Session["ID"].ToString() + "',UpdatedDateTime=NOW() WHERE ID=" + Id + "";
            StockReports.ExecuteDML(sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveFinancialYear(string FromYear, string ToYear, string FinancialYear)
    {
        try
        {
            FromYear = FromYear + "-04-01";
            ToYear = ToYear + "-03-31";
            string sql = "select count(*) from f_financialyear_master where FinancialYear ='" + FinancialYear + "' and IsActive=1 ";
            int IsExist = Util.GetInt(StockReports.ExecuteScalar(sql));
            if (IsExist > 0)
            {
                return "2";
            }

            sql = "INSERT INTO f_financialyear_master(FinancialYear,`Format`,FromDate,ToDate,EntryBy,EntryDateTime) VALUES('" + FinancialYear + "','Apr-Mar','" + FromYear + "','" + ToYear + "','" + HttpContext.Current.Session["ID"].ToString() + "',NOW()) ";
            StockReports.ExecuteDML(sql);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "";
        }
    }

    public class SValue
    {
        private string _id;
        private decimal _value;
        public string id { get { return _id; } set { _id = value; } }
        public decimal value { get { return _value; } set { _value = value; } }
    }

    public class SMonth
    {
        private string _className;
        private SValue _a = new SValue();
        private SValue _h = new SValue();
        private SValue _q = new SValue();
        private SValue _m = new SValue();
        public string className { get { return _className; } set { _className = value; } }
        public SValue a { get { return _a; } set { _a = value; } }
        public SValue h { get { return _h; } set { _h = value; } }
        public SValue q { get { return _q; } set { _q = value; } }
        public SValue m { get { return _m; } set { _m = value; } }
    }

    public class STarget
    {
        private SMonth _m1 = new SMonth();
        private SMonth _m2 = new SMonth();
        private SMonth _m3 = new SMonth();
        private SMonth _m4 = new SMonth();
        private SMonth _m5 = new SMonth();
        private SMonth _m6 = new SMonth();
        private SMonth _m7 = new SMonth();
        private SMonth _m8 = new SMonth();
        private SMonth _m9 = new SMonth();
        private SMonth _m10 = new SMonth();
        private SMonth _m11 = new SMonth();
        private SMonth _m12 = new SMonth();
        public SMonth m1 { get { return _m1; } set { _m1 = value; } }
        public SMonth m2 { get { return _m2; } set { _m2 = value; } }
        public SMonth m3 { get { return _m3; } set { _m3 = value; } }
        public SMonth m4 { get { return _m4; } set { _m4 = value; } }
        public SMonth m5 { get { return _m5; } set { _m5 = value; } }
        public SMonth m6 { get { return _m6; } set { _m6 = value; } }
        public SMonth m7 { get { return _m7; } set { _m7 = value; } }
        public SMonth m8 { get { return _m8; } set { _m8 = value; } }
        public SMonth m9 { get { return _m9; } set { _m9 = value; } }
        public SMonth m10 { get { return _m10; } set { _m10 = value; } }
        public SMonth m11 { get { return _m11; } set { _m11 = value; } }
        public SMonth m12 { get { return _m12; } set { _m12 = value; } }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveFinancialYearTarget(string SalesCategoryID, string FinancialYear, List<STarget> SalesTarget, string TargetSetBy)
    {
        string InvalidValue = string.Empty;
        decimal TotalAnnualTarget = 0;
        for (int i = 0; i < SalesTarget.Count; i++)
        {
            decimal Q1M = SalesTarget[i].m1.m.value + SalesTarget[i].m2.m.value + SalesTarget[i].m3.m.value;
            decimal Q2M = SalesTarget[i].m4.m.value + SalesTarget[i].m5.m.value + SalesTarget[i].m6.m.value;
            decimal Q3M = SalesTarget[i].m7.m.value + SalesTarget[i].m8.m.value + SalesTarget[i].m9.m.value;
            decimal Q4M = SalesTarget[i].m10.m.value + SalesTarget[i].m11.m.value + SalesTarget[i].m12.m.value;
            decimal H1Q = SalesTarget[i].m1.q.value + SalesTarget[i].m4.q.value;
            decimal H2Q = SalesTarget[i].m7.q.value + SalesTarget[i].m10.q.value;
            decimal A1H = SalesTarget[i].m1.h.value + SalesTarget[i].m7.h.value;
            TotalAnnualTarget = TotalAnnualTarget + SalesTarget[i].m1.a.value;
            if (TargetSetBy == "3")
            {
                if (Q1M < SalesTarget[i].m1.q.value)
                {
                    InvalidValue = InvalidValue + "," + SalesTarget[i].m1.q.id;
                }
                if (Q2M < SalesTarget[i].m4.q.value)
                {
                    InvalidValue = InvalidValue + "," + SalesTarget[i].m4.q.id;
                }
                if (Q3M < SalesTarget[i].m7.q.value)
                {
                    InvalidValue = InvalidValue + "," + SalesTarget[i].m7.q.id;
                }
                if (Q4M < SalesTarget[i].m10.q.value)
                {
                    InvalidValue = InvalidValue + "," + SalesTarget[i].m10.q.id;
                }
            }
            if (TargetSetBy == "2")
            {
                if (H1Q < SalesTarget[i].m1.h.value)
                {
                    InvalidValue = InvalidValue + "," + SalesTarget[i].m1.h.id;
                }
                if (H2Q < SalesTarget[i].m7.h.value)
                {
                    InvalidValue = InvalidValue + "," + SalesTarget[i].m7.h.id;
                }
            }
            if (TargetSetBy == "1")
            {
                if (A1H < SalesTarget[i].m1.a.value)
                {
                    InvalidValue = InvalidValue + "," + SalesTarget[i].m1.a.id;
                }
            }
            if (InvalidValue != "")
                return InvalidValue;
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Format = "";
            if (SalesCategoryID == "1")
                Format = "Amount";
            else
                Format = "Count";

            string Sqlupdate = "UPDATE f_annualtarget a INNER JOIN f_annualtargetdetails ad ON ad.AnnualTargetId=a.ID SET ad.IsCancel=1,ad.LastUpdatedBy='" + UserInfo.ID + "',ad.LastUpdatedDateTime=NOW(), a.IsCancel=1 ,a.LastUpdatedDateTime=NOW(),a.LastUpdatedBy='" + UserInfo.ID + "' WHERE a.IsCancel=0 AND a.FinancialYearId=" + FinancialYear + " AND a.TargetTypeId=" + SalesCategoryID + " ";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Sqlupdate);

            int TargetNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IFNULL(MAX(TargetNumber),0)+1 FROM f_annualtarget "));
            int MaxID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT ifnull(MAX(ID),0)+1 FROM f_annualtarget "));
            StringBuilder sb = new StringBuilder();
            for (int j = 0; j < SalesTarget.Count; j++)
            {
                if (j == 0)
                {
                    sb.Length = 0;
                    sb.Append(" INSERT INTO f_annualtarget (FinancialYearID ,TargetTypeId ,TotalAnnualTargetValue ,Format ,TargetNumber ,EntryDateTime ,EntryBy,TargetSetBy)  ");
                    sb.Append(" VALUES(@FinancialYearID ,@TargetTypeId ,@TotalAnnualTargetValue ,@Format ,@TargetNumber ,now() ,@EntryBy,@TargetSetBy)");
                    MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
                    cmd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                    cmd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                    cmd.Parameters.AddWithValue("@TotalAnnualTargetValue", Util.GetDecimal(TotalAnnualTarget));
                    cmd.Parameters.AddWithValue("@Format", Format);
                    cmd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                    cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                    cmd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                    cmd.ExecuteNonQuery();
                }

                sb.Length = 0;
                sb.Append(" INSERT INTO f_annualtargetdetails (FinancialYearId ,TargetTypeId ,`Format`,TargetNumber ,ItemId ,AnnualId ,AnnualTargetValue ,HalfYearlyId ,HalfYearlyTargetValue ,");
                sb.Append(" QuarterId ,QuarterTargetValue ,MonthId ,MonthTargetValue ,AnnualTargetId ,EntryDateTime ,EntryBy,TargetSetBy ) ");
                sb.Append(" VALUES(@FinancialYearId ,@TargetTypeId ,@Format ,@TargetNumber ,@ItemId ,@AnnualId ,@AnnualTargetValue ,@HalfYearlyId ,@HalfYearlyTargetValue ,");
                sb.Append(" @QuarterId ,@QuarterTargetValue ,@MonthId ,@MonthTargetValue ,@AnnualTargetId ,now() ,@EntryBy,@TargetSetBy ) ");

                //Insert 1st Month Target
                MySqlCommand cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m1.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m1.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m1.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m1.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m1.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m1.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m1.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m1.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m1.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 2nd Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m2.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m2.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m2.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m2.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m2.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m2.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m2.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m2.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m2.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 3rd Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m3.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m3.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m3.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m3.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m3.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m3.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m3.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m3.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m3.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 4th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m4.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m4.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m4.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m4.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m4.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m4.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m4.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m4.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m4.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 5th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m5.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m5.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m5.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m5.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m5.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m5.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m5.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m5.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m5.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 6th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m6.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m6.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m6.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m6.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m6.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m6.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m6.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m6.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m6.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 7th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m7.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m7.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m7.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m7.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m7.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m7.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m7.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m7.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m7.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 8th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m8.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m8.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m8.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m8.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m8.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m8.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m8.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m8.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m8.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 9th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m9.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m9.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m9.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m9.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m9.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m9.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m9.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m9.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m9.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 10th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m10.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m10.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m10.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m10.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m10.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m10.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m10.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m10.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m10.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 11th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m11.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m11.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m11.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m11.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m11.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m11.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m11.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m11.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m11.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();

                //Insert 12th Month Target
                cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@FinancialYearID", Util.GetInt(FinancialYear));
                cmdd.Parameters.AddWithValue("@TargetTypeId", Util.GetInt(SalesCategoryID));
                cmdd.Parameters.AddWithValue("@Format", Format);
                cmdd.Parameters.AddWithValue("@TargetNumber", Util.GetInt(TargetNo));
                if (SalesCategoryID == "2")
                    cmdd.Parameters.AddWithValue("@ItemId", SalesTarget[j].m12.className);
                else
                    cmdd.Parameters.AddWithValue("@ItemId", "");

                cmdd.Parameters.AddWithValue("@AnnualId", Util.GetInt(SalesTarget[j].m12.a.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@AnnualTargetValue", Util.GetDecimal(SalesTarget[j].m12.a.value));
                cmdd.Parameters.AddWithValue("@HalfYearlyId", Util.GetInt(SalesTarget[j].m12.h.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@HalfYearlyTargetValue", Util.GetDecimal(SalesTarget[j].m12.h.value));
                cmdd.Parameters.AddWithValue("@QuarterId", Util.GetInt(SalesTarget[j].m12.q.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@QuarterTargetValue", Util.GetDecimal(SalesTarget[j].m12.q.value));
                cmdd.Parameters.AddWithValue("@MonthId", Util.GetInt(SalesTarget[j].m12.m.id.Split('_')[1].ToString()));
                cmdd.Parameters.AddWithValue("@MonthTargetValue", Util.GetDecimal(SalesTarget[j].m12.m.value));
                cmdd.Parameters.AddWithValue("@AnnualTargetId", Util.GetInt(MaxID));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@TargetSetBy", TargetSetBy);
                cmdd.ExecuteNonQuery();
            }

            tnx.Commit();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return "1";
    }
}