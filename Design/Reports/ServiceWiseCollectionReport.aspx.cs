using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_ServiceWiseCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
          
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;

            ddlItem.DataSource = StockReports.GetDataTable("SELECT itemid,CONCAT(testcode,'~',typename)itemname FROM f_itemmaster ORDER BY itemname ");
            ddlItem.DataValueField = "itemid";
            ddlItem.DataTextField = "itemname";
            ddlItem.DataBind();
            bindCheckBox();

        }
        
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    public class colectionReport
    {
        public string ID { get; set; }
        public string ColumnName { get; set; }
        public string ColumnValue { get; set; }
        public int IsDefault { get; set; }
    }

    public void bindCheckBox()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT CONCAT(ID,'#',IsDefault)ID,ColumnName,ColumnValue,IsDefault FROM ServiceWiseCollectionReport_Column WHERE IsActive=1"))
        {
            var aaa = dt.Columns["ID"].DataType;
            List<colectionReport> CollectionList = dt.AsEnumerable().Select(i => new colectionReport
            {
                ID = i.Field<string>("ID"),
                ColumnName = i.Field<string>("ColumnName"),
                ColumnValue = i.Field<string>("ColumnValue")
            }).ToList();
            if (Session["RoleID"].ToString() == "6" || Session["RoleID"].ToString() == "177" || Session["RoleID"].ToString() == "250")
            {
                CollectionList.Add(new colectionReport { ID = "200#0", ColumnName = "MobileNumber", ColumnValue = "pm.Mobile MobileNumber" });
                CollectionList.Add(new colectionReport { ID = "201#0", ColumnName = "MailId", ColumnValue = "pm.Email MailId" });
            }
            if (dt.Rows.Count > 0)
            {
                chkDetail.DataSource = CollectionList;
                chkDetail.DataTextField = "ColumnName";
                chkDetail.DataValueField = "ID";
                chkDetail.DataBind();
                foreach (ListItem li in chkDetail.Items.Cast<ListItem>())
                {
                    li.Attributes.Add("class", "chk");
                    if (li.Value.Split('#')[1] == "1")
                    {
                        li.Attributes.Add("class", "chk chkDefault");
                        li.Selected = true;
                    }
                }
            }
        }
    }


    protected void btnReport_Click(object sender, EventArgs e)
    {
        try
        {

            DateTime dateFrom = Convert.ToDateTime(txtFromDate.Text);
            DateTime dateTo = Convert.ToDateTime(txtToDate.Text);
            string BillNo = txtBillNo.Text;
            string CentreID = hdnCenterIds.Value;
            string itemid = HiddenField1.Value;
            string doctorid = HiddenField2.Value;
            string isPreBooking = "0";

            if (chkPreBooking.Checked)
                isPreBooking = "1";

            string checkedID = string.Join(",", chkDetail.Items.Cast<ListItem>().Where(a => a.Selected).Select(a => a.Value.Split('#')[0]));

            string selectQuery = StockReports.ExecuteScalar("SELECT CONCAT('SELECT ', GROUP_CONCAT(REPLACE(ColumnValue,'$','') ))ColumnValue FROM ServiceWiseCollectionReport_Column WHERE ID IN (" + checkedID + ")");

            if (Session["RoleID"].ToString() == "6" || Session["RoleID"].ToString() == "177" || Session["RoleID"].ToString() == "250")
            {


                List<ListItem> extraColumn = chkDetail.Items.Cast<ListItem>()
                                         .Where(a => a.Selected).Where(s => s.Value.Split('#')[0] == "200" || s.Value.Split('#')[0] == "201").ToList();

                if (extraColumn.Count > 0)
                {
                    if (extraColumn.Where(s => s.Value.Split('#')[0] == "200").Count() > 0)
                    {
                        if (selectQuery.Trim() != string.Empty)
                            selectQuery = string.Concat(selectQuery, ",", "pm.Mobile ");
                        else
                            selectQuery = string.Concat("SELECT ", " pm.Mobile ");
                    }
                    if (extraColumn.Where(s => s.Value.Split('#')[0] == "201").Count() > 0)
                    {
                        if (selectQuery.Trim() != string.Empty)
                            selectQuery = string.Concat(selectQuery, ",", "pm.Email ");
                        else
                            selectQuery = string.Concat("SELECT ", " pm.Email ");
                    }
                }
                extraColumn.Clear();
            }
            if (selectQuery.Trim() == string.Empty)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "sh234", "alert('Please Select Report Column');", true);
                return;
            }

            StringBuilder sb = new StringBuilder();

            sb.AppendFormat("{0}", selectQuery);
            sb.Append("  FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo AND plo.rate <>0 ");
            sb.Append(" AND lt.Date>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
            sb.Append(" AND lt.Date<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND lt.CentreID IN (" + CentreID.TrimEnd(',') + " ) ");
            if (isPreBooking == "1")
                sb.Append(" and lt.PreBookingID > 0");

            if (chiscancel.Checked == true)
            {
                sb.Append(" and plo.IsActive=0");
            }

            if (chkhomecollection.Checked)
            {
                sb.Append(" and lt.VisitType='Home Collection' ");
            }

            if (BillNo.Trim() != "")
                sb.Append("     AND plo.BillNo='" + BillNo.Trim() + "'");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemId   ");
            if (itemid != "")
            {
                sb.Append(" and im.itemid in (" + itemid + ")");
            }
            if (chkDetail.Items.Cast<ListItem>().Where(a => a.Selected).Where(s => s.Value.Split('#')[0] == "35").Count() > 0)
            {

                //  sb.Append(" INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=plo.`SubCategoryID` ");
            }
            sb.Append("  INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");


            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID");
            if (doctorid != "")
            {
                sb.Append(" and dr.Doctor_ID in (" + doctorid + ")");
            }
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
            sb.Append(" INNER JOIN centre_master cm2 ON fpm.`TagProcessingLabID`=cm2.CentreID ");


            sb.Append(" UNION ALL ");

            sb.AppendFormat("{0}", selectQuery);
            sb.Append("   FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo  ");
            sb.Append(" AND lt.Date>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
            sb.Append(" AND lt.Date<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (isPreBooking == "1")
                sb.Append(" and lt.PreBookingID > 0");


            if (chiscancel.Checked == true)
            {
                sb.Append(" and plo.IsActive=0");
            }

            if (chkhomecollection.Checked)
            {
                sb.Append(" and lt.VisitType='Home Collection' ");
            }

            if (BillNo.Trim() != "")
                sb.Append("     AND plo.BillNo='" + BillNo.Trim() + "'");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemId  ");
            if (itemid != "")
            {
                sb.Append(" and im.itemid in (" + itemid + ")");
            }
            if (chkDetail.Items.Cast<ListItem>().Where(a => a.Selected).Where(s => s.Value.Split('#')[0] == "35").Count() > 0)
            {

                //  sb.Append(" INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=plo.`SubCategoryID` ");
            }
            sb.Append(" INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id ");

            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID");
            if (doctorid != "")
            {
                sb.Append(" and dr.Doctor_ID in (" + doctorid + ")");
            }
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID`  AND fpm.`PanelType`='camp' ");
            sb.Append(" INNER JOIN centre_master cm2 ON cm2.CentreID=lt.CentreID  ");
            sb.Append(" AND cm2.CentreID IN (" + CentreID.TrimEnd(',') + " )");


            List<ListItem> OpenDate = chkDetail.Items.Cast<ListItem>()
                                         .Where(a => a.Selected).Where(s => s.Value.Split('#')[0] == "13").ToList();

            if (OpenDate.Count > 0)
            {
                sb.Append(" ORDER BY OpenDate ");
            }

            OpenDate.Clear();

            NameValueCollection collections = new NameValueCollection();
            collections.Add("Query", sb.ToString());
            collections.Add("ReportName", "Service Wise Collection Report");
            collections.Add("Period", "From : " + dateFrom.ToString("dd-MMM-yyyy") + " To : " + dateTo.ToString("dd-MMM-yyyy"));
            collections.Add("IsAutoIncrement", "0");
            ScriptManager.RegisterStartupScript(this, GetType(), "", "OpenReport();", true);
            string strForm = AllLoad_Data.PreparePOSTForm(collections, 2);
            Page.Controls.Add(new LiteralControl(strForm));

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, GetType(), "", "alert('Error Occured....!');", true);
        }
    }
}