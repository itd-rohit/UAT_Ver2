using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_OPD_DiscountApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);

            bindCentreMaster();
            string labno = Common.Decrypt(Util.GetString(Request.QueryString["VisitNo"]));
            string type = Common.Decrypt(Util.GetString(Request.QueryString["type"]));
            string AppByID = Common.Decrypt(Util.GetString(Request.QueryString["AppBy"]));

            ddlappby.DataSource = StockReports.GetDataTable("SELECT dm.EmployeeID,em.`Name` label  FROM discount_approval_master dm INNER JOIN employee_master em ON dm.`EmployeeID`=em.`Employee_ID` AND dm.isactive=1 GROUP BY em.Employee_ID");
            ddlappby.DataValueField = "EmployeeID";
            ddlappby.DataTextField = "label";
            ddlappby.DataBind();

            ListItem selectedListItem = ddlappby.Items.FindByValue(UserInfo.ID.ToString());

            if (selectedListItem != null)
            {
                selectedListItem.Selected = true;
            }
            else
            {
                lblMsg.Text = "You are not authorized to access this page";
            }
        }
    }

    private void bindCentreMaster()
    {
        DataTable dt = AllLoad_Data.getCentreByLogin();
        if (dt.Rows.Count > 0)
        {
            ddlcentre.DataSource = dt;
            ddlcentre.DataTextField = "Centre";
            ddlcentre.DataValueField = "CentreID";
            ddlcentre.DataBind();
        }
        ddlcentre.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod]
    public static string bindDisAmt(string fromdate, string todate, string visitno, string pname, string centre, string empid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.LedgerTransactionNo Labno,plo.Barcodeno, DATE_FORMAT(lt.DATE,'%d-%b-%Y')DATE,GrossAmount,NetAmount,DiscountOnTotal,lt.LedgerTransactionID,pm.PName,pm.Gender,pm.Age,");
        sb.Append(" (select DiscountReason from f_ledgertransaction_DiscountReason where ledgertransactionID=lt.ledgertransactionID LIMIT 1)DisReason,lt.CreatedBy, ");
        sb.Append("(select Group_Concat(Distinct Remarks) from patient_labinvestigation_opd_remarks where  LedgerTransactionID=lt.LEdgertransactionID) Remarks,");
        sb.Append(" cm.Centre BookingCentre FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN patient_master pm ON lt.Patient_ID=pm.Patient_ID  ");
        sb.Append(" INNER JOIN patient_labinvestigation_OPD plo ON plo.ledgertransactionID=lt.ledgertransactionID  ");
        if (pname != string.Empty)
        {
            sb.Append(" and pm.pname like '%" + pname + "%'");
        }
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID");
        if (centre != "0")
        {
            sb.Append(" and lt.centreid='" + centre + "'");
        }

        if (visitno != string.Empty)
        {
            sb.Append(" and lt.LedgerTransactionNo='" + visitno + "'");
        }
        sb.Append(" WHERE   lt.IsDiscountApproved=0 AND lt.DiscountOnTotal>0 ");
        sb.Append(" AND lt.date>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND lt.date<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
        sb.Append(" AND DiscountApprovedByID in(" + empid + ") ");
        sb.Append(" group by lt.ledgertransactionID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }

    [WebMethod]
    public static string bindAllDisAmt(string fromdate, string todate, string visitno, string pname, string centre, string empid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT lt.LedgerTransactionNo Labno,plo.Barcodeno,IsDiscountApproved,DATE_FORMAT(lt.DATE,'%d-%b-%Y')DATE,GrossAmount,DiscountOnTotal,NetAmount,lt.LedgerTransactionID,pm.PName,pm.Gender,pm.Age,cm.Centre BookingCentre");
        sb.Append(" ,(select DiscountReason from f_ledgertransaction_DiscountReason where ledgertransactionID=lt.ledgertransactionID LIMIT 1)DisReason,lt.CreatedBy ");
        sb.Append(",(select Group_Concat(Distinct Remarks) from patient_labinvestigation_opd_remarks where  LedgerTransactionID=lt.LEdgertransactionID) Remarks");
        sb.Append(" FROM f_ledgertransaction lt INNER JOIN patient_master pm ON lt.Patient_ID=pm.Patient_ID INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID ");
        sb.Append(" INNER JOIN patient_labinvestigation_OPD plo ON plo.ledgertransactionID=lt.ledgertransactionID  ");
        sb.Append(" WHERE   lt.IsDiscountApproved IN (1,-1) AND lt.DiscountOnTotal>0  and DiscountApprovedByID='" + UserInfo.ID + "'");
        if (visitno != string.Empty)
        {
            sb.Append(" and lt.LedgerTransactionNo='" + visitno + "'");
        }
        else
        {
            if (pname != string.Empty)
            {
                sb.Append(" and pm.pname like '%" + pname + "%'");
            }
            if (centre != "0")
            {
                sb.Append(" and lt.centreid='" + centre + "'");
            }


            sb.Append(" AND lt.date>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" AND lt.date<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
            sb.Append(" group by lt.ledgertransactionID ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }

    [WebMethod]
    public static int updateDiscApproved(string LedgerTransactionID, string IsDiscountApproved)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            string[] LabID = LedgerTransactionID.Split(',');
            for (int i = 0; i < LabID.Length; i++)
            {
                int isDiscApproved = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsDiscountApproved FROM f_ledgertransaction WHERE LedgerTransactionID =@LedgerTransactionID ",
                 new MySqlParameter("@LedgerTransactionID", LabID[i])));
                if (isDiscApproved == 1 || isDiscApproved == -1)
                {
                    return isDiscApproved;
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE  f_ledgertransaction SET IsDiscountApproved=@IsDiscountApproved,DiscountApprovedByID=@DiscountApprovedByID,DiscountApprovedByName=@DiscountApprovedByName,DiscountApprovedDate=NOW() WHERE LedgerTransactionID =@LedgerTransactionID",
                       new MySqlParameter("@IsDiscountApproved", IsDiscountApproved), new MySqlParameter("@DiscountApprovedByID", UserInfo.ID),
                       new MySqlParameter("@DiscountApprovedByName", UserInfo.LoginName),
                       new MySqlParameter("@LedgerTransactionID", LabID[i]));
                }
            }
            tranX.Commit();
            return 2;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Rollback();
            return 0;
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}