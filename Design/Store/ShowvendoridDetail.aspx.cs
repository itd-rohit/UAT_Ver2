using System;
using System.Text;

public partial class Design_Store_ShowvendoridDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            showdetail(Request.QueryString["vendorid"].ToString());
        }
    }
    void showdetail(string vendorid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  ");
        sb.Append(" SupplierName, SupplierCode,(select Name from st_supplierType where id=SupplierCategory)SupplierCategoryName, ");
        sb.Append(" (select Name from st_supplierType where id=OrganizationType)OrganizationTypename, HouseNo,Street, Country, State,  ");
        sb.Append(" PinCode, Landline,FaxNo,EmailId, Website, PrimaryContactPerson, PrimaryContactPersonDesignation,  ");
        sb.Append(" PrimaryContactPersonMobileNo,PrimaryContactPersonEmailId,SecondaryContactPerson, SecondaryContactPersonDesignation,  ");
        sb.Append(" SecondaryContactPersonMobileNo,SecondaryContactPersonEmailId,CINNo, PFRegistartionNo, NameonPANCard, PANCardNo,  ");
        sb.Append(" ROCNo, ESIRegistrationNo, ISOCertificationNo, ISOValidUpto,PollutioncontrolBoardCertificationNo, PollutionValidUpto,  ");
        sb.Append(" Bank1, Bank1Branch, Bank1AccountsNo, Bank1IFSCCode, Bank1Address1,Bank1Address2,  ");
        sb.Append(" Bank1City,Bank1State, Bank2, Bank2Branch, Bank2AccountsNo,Bank2IFSCCode,  ");
        sb.Append(" Bank2Address1, Bank2Address2, Bank2City,Bank2State,PaymentTerms,Taxes,  ");
        sb.Append(" DeliveryTerms,VendorToNotes, CreditLimit, IsActive,  ");

        sb.Append(" DATE_FORMAT(vm.CreaterDateTime, '%d/%m/%Y') CreatedDate,(SELECT NAME FROM employee_master WHERE employee_id=vm.CreaterID) CreatedBy, ");
        sb.Append(" DATE_FORMAT(vm.CheckedDate, '%d/%m/%Y') CheckedDate,(SELECT NAME FROM employee_master WHERE employee_id=vm.CheckedBy) CheckedBy ,");
        sb.Append(" DATE_FORMAT(vm.ApprovedDate, '%d/%m/%Y') ApprovedDate,(SELECT NAME FROM employee_master WHERE employee_id=vm.ApprovedBy) ApprovedBy, ");

        sb.Append(" if(IsMSMERegistration=0,'No','Yes')IsMSMERegistration,MSMERegistrationNo,MSMERegistrationValidDate");

        sb.Append(" FROM st_vendormaster vm ");

        sb.Append(" where SupplierID='" + vendorid + "' ");

        grd1.DataSource = StockReports.GetDataTable(sb.ToString());
        grd1.DataBind();


        sb = new StringBuilder();

        sb.Append(" SELECT FinancialYear,AnnualTurnover");

        sb.Append("  FROM st_supplier_financial where SupplierID='" + vendorid + "'");

        grd.DataSource = StockReports.GetDataTable(sb.ToString());
        grd.DataBind();

        sb = new StringBuilder();

        sb.Append(" SELECT state, Address,gst_no `GSTN No.`   ");
        sb.Append(" FROM  st_supplier_gstn WHERE SupplierID='" + vendorid + "' ");

        grd2.DataSource = StockReports.GetDataTable(sb.ToString());
        grd2.DataBind();

        sb = new StringBuilder();
        sb.Append(" SELECT  ID,FileName,file AttachedFile,OriginalFileName FROM st_vendor_document WHERE VendorID='" + vendorid + "' ");



        
        grvAttachment.DataSource = StockReports.GetDataTable(sb.ToString());
        grvAttachment.DataBind();

    }
}