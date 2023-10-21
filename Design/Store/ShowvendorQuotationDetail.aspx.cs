using System;
using System.Text;

public partial class Design_Store_ShowvendorQuotationDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            showdetail(Request.QueryString["QutationNo"].ToString());
        }
    }

    void showdetail(string Qutationno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT date_format(entrydatefrom,'%d-%b-%Y')EntryDateFrom,date_format(entrydateTo,'%d-%b-%Y')EntryDateTo,DeliveryLocationName,Qutationno,Quotationrefno,VendorName,VendorAddress,VednorStateName,VednorStateGstnno,DeliveryStateName,DeliveryCentreName,ItemCategoryName, ");
        sb.Append("  ItemName,HSNCode,ManufactureName,MachineName,trimZero(Rate)Rate,Qty,FreeQty,trimZero(IGSTPer)IGSTPer,trimZero(DiscountPer)DiscountPer,trimZero(SGSTPer)SGSTPer,trimzero(CGSTPer)CGSTPer,trimzero(BuyPrice)BuyPrice,trimzero(DiscountAmt)DiscountAmt,trimzero(GSTAmount)GSTAmount, ");
        sb.Append(" trimzero(FinalPrice)FinalPrice, ");
        sb.Append(" DATE_FORMAT(sm.CreaterDateTime, '%d/%m/%Y') CreatedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.CreaterID) CreatedBy, ");
        sb.Append(" DATE_FORMAT(sm.CheckedDate, '%d/%m/%Y') CheckedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.CheckedBy) CheckedBy ,");
        sb.Append(" DATE_FORMAT(sm.ApprovedDate, '%d/%m/%Y') ApprovedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.ApprovedBy) ApprovedBy ");
        sb.Append(" FROM st_vendorqutation sm  ");


        sb.Append("  where  sm.Qutationno='" + Qutationno + "'");

        grd1.DataSource = StockReports.GetDataTable(sb.ToString());
        grd1.DataBind();

        GridView1.DataSource = grd1.DataSource;
        GridView1.DataBind();
        
        sb = new StringBuilder();

        sb.Append(" SELECT TermsCondition");
        sb.Append(" ");
        sb.Append("  FROM st_qutationtermsconditions where Qutationno='" + Qutationno + "'");

        grd.DataSource = StockReports.GetDataTable(sb.ToString());
        grd.DataBind();

        




    }
}