using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Reports_CollectionReport_MobileWallletCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            bindCentreMaster();
            bindAllData();
            reportaccess();
            bindwallet();
        }  
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(6));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(ucFromDate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rdoReportFormat.Items[0].Enabled = true;
                rdoReportFormat.Items[1].Enabled = false;
                rdoReportFormat.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rdoReportFormat.Items[1].Enabled = true;
                rdoReportFormat.Items[0].Enabled = false;
                rdoReportFormat.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rdoReportFormat.Visible = false;
                lblMsg.Text = "Report format not allowed contect to admin";
                return false;
            }
            //else
            //{
            //    rdoReportFormat.Items[0].Selected = true;
            //}
        }
        else
        {
            divcentre.Visible = false;
            divuser.Visible = false;
            divsave.Visible = false;

            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    private void bindCentreMaster()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                chklCentres.DataSource = dt;
                chklCentres.DataTextField = "Centre";
                chklCentres.DataValueField = "CentreID";
                chklCentres.DataBind();
            }
        }
    }
    private void bindAllData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {


            var strCentres = string.Join(", ", chklCentres.Items.Cast<ListItem>().Select(x => x.Value).ToArray());

            StringBuilder sb = new StringBuilder();
            sb.Append(" Select em.Name As Name,em.Employee_ID from employee_master em INNER JOIN f_login flg on flg.EmployeeID = em.Employee_ID WHERE em.IsActive=1 ");
            sb.Append(" AND flg.Active=1 and flg.CentreID IN({0})  ");

            if (Session["RoleId"].ToString() == "9" || Session["RoleId"].ToString() == "214")
            {
                sb.Append(" AND em.Employee_ID=@Employee_ID ");
            }

            sb.Append(" group by em.Employee_ID ");
            sb.Append(" order by em.Name ");


            List<string> strDataList = new List<string>();
            strDataList = strCentres.Split(',').ToList<string>();
            // strDataList = strCentres.Split(',').Select(x => string.Format("'{0}'", x)).ToList<string>();


            DataTable dt1 = new DataTable();
            using (dt1 as IDisposable)
            {
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", strDataList)), con))
                {
                    for (int i = 0; i < strDataList.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), strDataList[i]);
                    }
                    da.SelectCommand.Parameters.AddWithValue("@Employee_ID", Session["ID"].ToString());
                    da.Fill(dt1);

                    if (dt1.Rows.Count > 0)
                    {
                        chklUser.DataSource = dt1;
                        chklUser.DataTextField = "Name";
                        chklUser.DataValueField = "Employee_ID";
                        chklUser.DataBind();

                        if (Session["RoleId"].ToString() == "9" || Session["RoleId"].ToString() == "214")
                        {
                            (from i in chklUser.Items.Cast<ListItem>() select i).ToList().ForEach(i => i.Selected = true);

                        }
                    }
                }
            }
            strDataList.Clear();
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
    private void bindwallet()
    {
        using (DataTable dt = AllLoad_Data.bindPaymentMode())
        {
            cblwallet.DataSource = dt;
            cblwallet.DataTextField = "PaymentMode";
            cblwallet.DataValueField = "PaymentModeID";
            cblwallet.DataBind();
        }
    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        if (!reportaccess())
            return;

        string startDate = string.Empty, toDate = string.Empty, user;

        string rresult = Util.DateDiffReportSearch(Util.GetDateTime(ucToDate.Text), Util.GetDateTime(ucFromDate.Text));
        if (rresult == "true")
        {
            lblMsg.Text = "Your From date ,To date Diffrence is too  Long";
            return;
            //return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
        }

        if (ucFromDate.Text != string.Empty)
            if (txtFromTime.Text.Trim() != string.Empty)
                startDate = string.Concat(Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd"), " ", txtFromTime.Text.Trim());
            else
                startDate = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");

        if (ucToDate.Text != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = string.Concat(Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd"), " ", txtToTime.Text.Trim());
            else
                toDate = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");

        user = GetSelection(chklUser);

        GetCollectionData(startDate, toDate, user);
    }
    private void GetCollectionData(string fromDate, string toDate, string userID)
    {
        lblMsg.Text = "";
        string Centres = GetSelection(chklCentres);
        string wallet = GetSelection(cblwallet);

        if (Centres.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        if (wallet.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Select wallet";
            return;
        }
      // try
      // {
      //     NameValueCollection collections = new NameValueCollection();
      //     collections.Add("fromDate", fromDate.Trim());
      //     collections.Add("toDate", toDate.Trim());
      //     collections.Add("UserID", userID);
      //     collections.Add("CentreID", Centres);
      //     collections.Add("ReportType", rbtReportType.SelectedValue);
      //     collections.Add("wallet", wallet);
      //     collections.Add("ReportFormat", rdoReportFormat.SelectedValue);
      //     AllLoad_Data.POSTForm(collections, "Design/Reports/CollectionReport/MobileWallletCollectionReportPdf.aspx", this.Page);
      // }
      // catch (Exception ex)
      // {
      //     ClassLog cl = new ClassLog();
      //     cl.errLog(ex);
      // }
        StringBuilder sb = new StringBuilder();
        if (rbtReportType.SelectedValue == "0")
        {
            sb.Append(" SELECT   ");
            sb.Append(" sum(Rec.`Amount`)Amount,rec.PaymentMode , rec.`PaymentModeID`,rec.CentreID,cm.Centre,rec.BankName FROM f_receipt rec  ");
            sb.Append(" INNER JOIN Centre_Master cm on cm.CentreID=rec.CentreID ");
            sb.Append(" WHERE rec.`IsCancel`=0 ");
            //   if (Request.Form["UserID"].ToString() != string.Empty)
            //     sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

            sb.Append(" AND rec.`CentreID` IN ({0}) ");
            if (wallet.Trim() != string.Empty)
                sb.Append(" AND rec.`PaymentModeID` IN ({1}) ");

            sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate  GROUP BY rec.`PaymentModeID`,rec.BankName ");
        }
        else
        {
            sb.Append(" SELECT   cm.Centre,lt.PanelName,lt.ledgertransactionno Visitno,DATE_FORMAT(Rec.CreatedDate,'%d-%b-%Y')RecDate,lt.PName,Concat(lt.Age,'/',Left(Gender,1))AgeGender, ");
            sb.Append(" rec.PaymentMode,rec.BankName,Rec.`Amount` PaidAmount,rec.TransactionID FROM f_receipt rec  ");
            sb.Append(" inner join f_ledgertransaction lt on lt.ledgertransactionid=rec.ledgertransactionid ");
            sb.Append(" INNER JOIN Centre_Master cm on cm.CentreID=rec.CentreID ");
            sb.Append(" WHERE rec.`IsCancel`=0 ");
            //   if (Request.Form["UserID"].ToString() != string.Empty)
            //     sb.Append(" AND rec.`CreatedByID` IN ({0}) ");

            sb.Append(" AND rec.`CentreID` IN ({0}) ");
            if (wallet.Trim() != string.Empty)
                sb.Append(" AND rec.`PaymentModeID` IN ({1}) ");

            sb.Append(" AND rec.`CreatedDate` >=@fromDate AND rec.`CreatedDate` <= @toDate ");
        }
        List<string> CentreIDDataList = new List<string>();
        CentreIDDataList = Centres.Split(',').ToList<string>();

        List<string> walletDataList = new List<string>();
        walletDataList = wallet.Split(',').ToList<string>();
        DataTable dt = new DataTable();
         MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", CentreIDDataList), string.Join(",", walletDataList)), con))
                    {

                        for (int i = 0; i < CentreIDDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), CentreIDDataList[i]);
                        }
                        for (int i = 0; i < walletDataList.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@b", i), walletDataList[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", fromDate);
                        da.SelectCommand.Parameters.AddWithValue("@toDate", toDate);
                        da.Fill(dt);
                        Session["dtExport2Excel"] = dt;
                        Session["ReportName"] = "Mobile Wallet Report";
                        Response.Redirect("../../common/ExportToExcel.aspx");
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

    private string GetSelection(CheckBoxList cbl)
    {
        return string.Join(", ", cbl.Items.Cast<ListItem>().Where(s => s.Selected).Select(x => x.Value).ToArray());

    }
}