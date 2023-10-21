using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_EDP_DiscountMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindDesignation(ddlDesignation, "Select");
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindCenter(string state, string city)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        sb.Append(" SELECT Centre, CentreID  FROM centre_master WHERE isActive='1'");
        if (state.Trim() != "")
        {
            sb.Append(" AND State='" + state.Trim() + "'  ");
        }
        if (city.Trim() != "")
        {
            sb.Append(" AND City='" + city.Trim() + "'  ");
        }

        dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string InsertData(string ItemData, string DiscountMonth, string DiscountBill, string Employee_ID, int DiscountOnPackage, int AppBelowBaseRate, int sharetype)
    {
        // List<empData> empDetails = new JavaScriptSerializer().ConvertToType<List<empData>>(Employee_ID);

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ItemData = ItemData.TrimEnd('#');
            string str = "";
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            //string empID = string.Join(",", empDetails
            //                            .Select(x=>string.Format("'{0}'",x.EmployeeID)));

            DataTable dt = StockReports.GetDataTable("SELECT EmployeeID,CentreID FROM Discount_Approval_Master WHERE IsActive=1 AND  EmployeeID='" + Employee_ID + "'");
            for (int i = 0; i < len; i++)
            {
                //for (int j = 0; j < empDetails.Count; j++)
                //{
                //    DataRow[] fountRow = dt.Select("EmployeeID = '" + empDetails[j].EmployeeID.ToString() + "' AND CentreID='" + Item[i].ToString() + "' ");
                //    if (fountRow.Length == 0)
                //    {
                //        str = "insert into Discount_Approval_Master(EmployeeID,CentreID,EntryDate,UserID)values('" + empDetails[j].EmployeeID.ToString() + "','" + Item[i].ToString() + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["ID"]) + "') ";
                //        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                //    }
                //}

                //  int strTep = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(*) from Discount_Approval_Master where EmployeeID='" + Employee_ID + "' and CentreID='" + Item[i].ToString() + "' and IsActive=1 "));
                DataRow[] fountRow = dt.Select("CentreID='" + Item[i].ToString() + "' ");
                if (fountRow.Length == 0)
                {
                    str = "INSERT into Discount_Approval_Master(EmployeeID,CentreID,EntryDate,UserID,DiscShareType)values('" + Employee_ID + "','" + Item[i].ToString() + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + sharetype + "') ";
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                }

                //else
                //{
                //    str = "update Discount_Approval_Master set CentreID='" + Item[i].Split('|')[1] + "',EntryDate=now(),UserID='" + Util.GetString(HttpContext.Current.Session["ID"]) + "' where  EmployeeID ='" + Item[i].Split('|')[0] + "' and CentreID='" + Item[i].Split('|')[1] + "' And IsActive=1 ";
                //    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                //}
            }
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE employee_master SET DiscountOnPackage='" + DiscountOnPackage + "',AppBelowBaseRate='" + AppBelowBaseRate + "', DiscountPerMonth='" + DiscountMonth + "',DiscountPerBill_per='" + DiscountBill + "' WHERE Employee_ID='" + Employee_ID + "'");

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE Discount_Approval_Master SET DiscShareType='" + sharetype + "' WHERE EmployeeID='" + Employee_ID + "'");

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string getDetailsStatewise(string state)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreID,cm.Centre,cm.CentreCode,sm.State,ct.City FROM centre_master cm INNER JOIN state_master sm ON cm.state=sm.id");
        sb.Append("INNER JOIN city_master ct ON cm.city=ct.id WHERE cm.isactive=1 ORDER BY cm.centre");
        if (state.Trim() != "")
        {
            sb.Append(" WHERE State='" + state + "' ");
        }
        sb.Append(" order by centre; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string SearchEmployee(string EmployeeID)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT employee_ID,NAME,Designation FROM employee_master WHERE Employee_ID='" + EmployeeID + "' AND IsActive=1  ");
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string Remove(string DisAppID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE  discount_approval_master SET IsActive=0,UpdatedBy='" + UserInfo.ID + "',UpdatedDate=NOW() where ID='" + DisAppID + "'");
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Search(string EmployeeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreID,cm.Centre,cm.CentreCode,sm.State,ct.City,dam.EmployeeID,  dam.`ID` DisAppID,CONCAT(em.Title,' ',em.Name)EmpName,");
        sb.Append(" DiscountPerMonth,DiscountPerBill_per,em.DiscountOnPackage,em.AppBelowBaseRate,dam.DiscShareType,IFNULL(fpm.Company_Name,'') PanelName  FROM Discount_Approval_Master dam  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=dam.CentreID ");
        sb.Append(" INNER JOIN employee_master em ON em.Employee_ID=dam.EmployeeID ");
        if (EmployeeID.Trim() != string.Empty)
        {
            sb.Append(" AND em.Employee_ID='" + EmployeeID.Trim() + "' ");
        }
        sb.Append(" INNER JOIN state_master sm ON cm.stateid=sm.id ");
        sb.Append(" INNER JOIN city_master ct ON cm.cityID=ct.id ");
        sb.Append(" LEFT JOIN f_Panel_master fpm ON fpm.Panel_ID=dam.Panel_ID ");
        sb.Append(" WHERE cm.isactive=1 AND dam.IsActive=1");

        sb.Append(" ORDER BY cm.centre ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindEmpDisc(string EmployeeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT em.DiscountPerMonth,em.DiscountPerBill_per,em.DiscountOnPackage,em.AppBelowBaseRate, ");
        sb.Append(" (SELECT IFNULL(SUM(DiscountOnTotal),0) FROM f_ledgertransaction WHERE iscancel=0 AND DiscountApprovedByID=em.Employee_id ");
        sb.Append(" AND MONTH(DATE)=MONTH(NOW()) AND YEAR(DATE)=YEAR(NOW())) DiscountGiven");
        sb.Append(" FROM employee_master em WHERE em.Employee_ID='" + EmployeeID + "' ");
        sb.Append(" ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string bindEmployee(int DesignationID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT Name,Employee_ID from Employee_master WHERE IsActive=1 AND DesignationID='" + DesignationID + "' order by Name ");
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    public class empData
    {
        public string EmployeeID { get; set; }
    }
}