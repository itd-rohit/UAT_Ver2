using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_VendorMaster : System.Web.UI.Page
{
    public string approvaltypemaker = "0";
    public string approvaltypechecker = "0";
    public string approvaltypeapproval = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindalldata();
            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='VM' AND employeeid='" + UserInfo.ID + "' ");
            if (dt != "0")
            {
                if (dt.Contains("Checker"))
                {
                    approvaltypechecker = "1";
                }
                if (dt.Contains("Approval"))
                {
                    approvaltypeapproval = "1";
                }
                if (dt.Contains("Maker"))
                {
                    approvaltypemaker = "1";
                }


            }
          
        }
    }

    void bindalldata()
    {
        ddlsupplier.DataSource = StockReports.GetDataTable("select ID,Name from st_supplierType where Type='Category'");
        ddlsupplier.DataValueField = "ID";
        ddlsupplier.DataTextField = "Name";
        ddlsupplier.DataBind();
        ddlsupplier.Items.Insert(0,new ListItem("Select","0"));

        ddlsuppliersearch.DataSource = StockReports.GetDataTable("select ID,Name from st_supplierType where Type='Category'");
        ddlsuppliersearch.DataValueField = "ID";
        ddlsuppliersearch.DataTextField = "Name";
        ddlsuppliersearch.DataBind();
        ddlsuppliersearch.Items.Insert(0, new ListItem("Select", "0"));

        ddlSupplierOrganizationType.DataSource = StockReports.GetDataTable("select ID,Name from st_supplierType where Type='Organization'");
        ddlSupplierOrganizationType.DataValueField = "ID";
        ddlSupplierOrganizationType.DataTextField = "Name";
        ddlSupplierOrganizationType.DataBind();
        ddlSupplierOrganizationType.Items.Insert(0, new ListItem("Select", "0"));

        ddlSupplierOrganizationTypesearch.DataSource = StockReports.GetDataTable("select ID,Name from st_supplierType where Type='Organization'");
        ddlSupplierOrganizationTypesearch.DataValueField = "ID";
        ddlSupplierOrganizationTypesearch.DataTextField = "Name";
        ddlSupplierOrganizationTypesearch.DataBind();
        ddlSupplierOrganizationTypesearch.Items.Insert(0, new ListItem("Select", "0"));

        ddlState.DataSource = StockReports.GetDataTable("SELECT  ID,State Name FROM state_master where IsActive=1 ORDER BY State");
        ddlState.DataValueField = "ID";
        ddlState.DataTextField = "Name";
        ddlState.DataBind();
        ddlState.Items.Insert(0, new ListItem("Select", "0"));

        ddlstategstn.DataSource = StockReports.GetDataTable("SELECT  ID,State Name FROM state_master where IsActive=1 ORDER BY State");
        ddlstategstn.DataValueField = "ID";
        ddlstategstn.DataTextField = "Name";
        ddlstategstn.DataBind();
        ddlstategstn.Items.Insert(0, new ListItem("Select", "0"));
        

        ddlCountry.DataSource = StockReports.GetDataTable("SELECT '1'  ID,'India' Name");
        ddlCountry.DataValueField = "ID";
        ddlCountry.DataTextField = "Name";
        ddlCountry.DataBind();

        for(int a=2010;a<=DateTime.Now.Year;a++)
        {
            ddlyear.Items.Add(a.ToString());
        }
        
        
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveVendorMaster(StoreVendormaster vendormaster, List<SupplierFinancial> vendorfidetail, List<SupplierGSTN> vendorgstndetail, string filename)
    {
        if (vendormaster.IsLoginRequired == "1" && Util.GetInt(StockReports.ExecuteScalar("select count(1) from st_vendormaster where LoginUserName='" + vendormaster .LoginUserName+ "'"))>0)
        {

            return "0#User Name Already In Used Please Choose Other User Name.!";

        }

        if (vendormaster.PANCardNo != "" && Util.GetInt(StockReports.ExecuteScalar("select count(1) from st_vendormaster where PANCardNo='" + vendormaster.PANCardNo + "'")) > 0)
        {

            return "2#Pan Card No Already Register With " + Util.GetInt(StockReports.ExecuteScalar("select SupplierName from st_vendormaster where PANCardNo='" + vendormaster.PANCardNo + "' limit 1"));

        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string VednorID = "";
            StoreVendormaster objsm = new StoreVendormaster(tnx);
            objsm.SupplierName = vendormaster.SupplierName;
            objsm.SupplierCode = vendormaster.SupplierCode;
            objsm.SupplierType = vendormaster.SupplierType;
            objsm.SupplierCategory = vendormaster.SupplierCategory;
            objsm.OrganizationType = vendormaster.OrganizationType;
            objsm.HouseNo = vendormaster.HouseNo;
            objsm.Street = vendormaster.Street;
            objsm.Country = vendormaster.Country;
            objsm.State = vendormaster.State;
            objsm.PinCode = vendormaster.PinCode;
            objsm.Landline = vendormaster.Landline;
            objsm.FaxNo = vendormaster.FaxNo;
            objsm.EmailId = vendormaster.EmailId;
            objsm.Website = vendormaster.Website;
            objsm.PrimaryContactPerson = vendormaster.PrimaryContactPerson;
            objsm.PrimaryContactPersonDesignation = vendormaster.PrimaryContactPersonDesignation;
            objsm.PrimaryContactPersonMobileNo = vendormaster.PrimaryContactPersonMobileNo;
            objsm.PrimaryContactPersonEmailId = vendormaster.PrimaryContactPersonEmailId;
            objsm.SecondaryContactPerson = vendormaster.SecondaryContactPerson;
            objsm.SecondaryContactPersonDesignation = vendormaster.SecondaryContactPersonDesignation;
            objsm.SecondaryContactPersonMobileNo = vendormaster.SecondaryContactPersonMobileNo;
            objsm.SecondaryContactPersonEmailId = vendormaster.SecondaryContactPersonEmailId;
            objsm.CINNo = vendormaster.CINNo;
            objsm.PFRegistartionNo = vendormaster.PFRegistartionNo;
            objsm.NameonPANCard = vendormaster.NameonPANCard;
            objsm.PANCardNo = vendormaster.PANCardNo;
            objsm.ROCNo = vendormaster.ROCNo;
            objsm.ESIRegistrationNo = vendormaster.ESIRegistrationNo;
            objsm.ISOCertificationNo = vendormaster.ISOCertificationNo;
            objsm.ISOValidUpto = vendormaster.ISOValidUpto;
            objsm.PollutioncontrolBoardCertificationNo = vendormaster.PollutioncontrolBoardCertificationNo;
            objsm.PollutionValidUpto = vendormaster.PollutionValidUpto;
            objsm.Bank1 = vendormaster.Bank1;
            objsm.Bank1Branch = vendormaster.Bank1Branch;
            objsm.Bank1AccountsNo = vendormaster.Bank1AccountsNo;
            objsm.Bank1IFSCCode = vendormaster.Bank1IFSCCode;
            objsm.Bank1Address1 = vendormaster.Bank1Address1;
            objsm.Bank1Address2 = vendormaster.Bank1Address2;
            objsm.Bank1City = vendormaster.Bank1City;
            objsm.Bank1State =vendormaster.Bank1City;
            objsm.Bank2 = vendormaster.Bank2;
            objsm.Bank2Branch = vendormaster.Bank2Branch;
            objsm.Bank2AccountsNo = vendormaster.Bank2AccountsNo;
            objsm.Bank2IFSCCode = vendormaster.Bank2IFSCCode;
            objsm.Bank2Address1 = vendormaster.Bank2Address1;
            objsm.Bank2Address2 = vendormaster.Bank2Address2;
            objsm.Bank2City = vendormaster.Bank2City;
            objsm.Bank2State = vendormaster.Bank2State;
            objsm.PaymentTerms = vendormaster.PaymentTerms ;
            objsm.Taxes =vendormaster.Taxes;
            objsm.DeliveryTerms = vendormaster.DeliveryTerms;
            objsm.VendorToNotes = vendormaster.VendorToNotes;
            objsm.CreditLimit = vendormaster.CreditLimit;
            objsm.IsLoginRequired = vendormaster.IsLoginRequired;
            objsm.LoginUserName = vendormaster.LoginUserName;
            objsm.LoginPassword = vendormaster.LoginPassword;
            objsm.IsAutoRejectPO = vendormaster.IsAutoRejectPO;
            objsm.AutoRejectPOAfterDays = vendormaster.AutoRejectPOAfterDays;
            objsm.IsMSMERegistration = vendormaster.IsMSMERegistration;
            objsm.MSMERegistrationNo = vendormaster.MSMERegistrationNo;
            objsm.MSMERegistrationValidDate = vendormaster.MSMERegistrationValidDate;
            objsm.OracleVendorCode = vendormaster.OracleVendorCode;
            objsm.OracleVendorSite = vendormaster.OracleVendorSite;
           
            VednorID = objsm.Insert();
            if (VednorID == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "0#Error";

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_supplier_financial where supplierID='" + VednorID + "'");
            StringBuilder sb = new StringBuilder();
            foreach (SupplierFinancial obj in vendorfidetail)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO st_supplier_financial(supplierID,supplier,FinancialYear,AnnualTurnover)");
                sb.Append(" VALUES('" + VednorID + "','" + obj.Supplier + "','" + obj.FinancialYear + "','" + obj.AnnualTurnover + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_supplier_gstn where supplierID='" + VednorID + "'");
            foreach (SupplierGSTN myarr in vendorgstndetail)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO st_supplier_gstn(supplierID,supplier,StateID,State,GST_No,Address)");
                sb.Append(" VALUES ('" + VednorID + "','" + myarr.Supplier + "','" + myarr.StateID + "','" + myarr.State + "','" + myarr.GST_No + "','" + myarr.Address + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }

            if (filename != "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_Vendor_Document set VendorID='"+VednorID+"' where newfilename='"+filename+"'");
            }
            tnx.Commit();

            return "1#";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string searchtype, string searchvalue, string SupplierCategory, string OrganizationType, string Status, string NoofRecord)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT SupplierType,  ifnull(IsAutoRejectPO,0)IsAutoRejectPO,ifnull(AutoRejectPOAfterDays,0)AutoRejectPOAfterDays, ifnull(IsLoginRequired,0)IsLoginRequired,ifnull(LoginUserName,'')LoginUserName,ifnull(LoginPassword,'')LoginPassword, ApprovalStatus,case when ApprovalStatus=0 then 'bisque' when ApprovalStatus=1 then 'pink' when ApprovalStatus=2 then 'lightgreen'  end rowcolor, ");
        sb.Append(" SupplierID,SupplierName, SupplierCode,(select Name from st_supplierType where id=SupplierCategory)SupplierCategoryName, SupplierCategory, ");
        sb.Append(" (select Name from st_supplierType where id=OrganizationType)OrganizationTypename, OrganizationType, HouseNo,Street, Country, State,  ");
        sb.Append(" PinCode, Landline,FaxNo,EmailId, Website, PrimaryContactPerson, PrimaryContactPersonDesignation,  ");
        sb.Append(" PrimaryContactPersonMobileNo,PrimaryContactPersonEmailId,SecondaryContactPerson, SecondaryContactPersonDesignation,  ");
        sb.Append(" SecondaryContactPersonMobileNo,SecondaryContactPersonEmailId,CINNo, PFRegistartionNo, NameonPANCard, PANCardNo,  ");
        sb.Append(" ROCNo, ESIRegistrationNo, ISOCertificationNo, ISOValidUpto,PollutioncontrolBoardCertificationNo, PollutionValidUpto,  ");
        sb.Append(" Bank1, Bank1Branch, Bank1AccountsNo, Bank1IFSCCode, Bank1Address1,Bank1Address2,  ");
        sb.Append(" Bank1City,Bank1State, Bank2, Bank2Branch, Bank2AccountsNo,Bank2IFSCCode,  ");
        sb.Append(" Bank2Address1, Bank2Address2, Bank2City,Bank2State,PaymentTerms,Taxes,  ");
        sb.Append(" DeliveryTerms,VendorToNotes, CreditLimit, IsActive,ApprovalStatus,  ");
        sb.Append(" IsMSMERegistration,MSMERegistrationNo,MSMERegistrationValidDate,ifnull(OracleVendorCode,'') as OracleVendorCode,  ifnull(OracleVendorSite,'') as OracleVendorSite ");
        sb.Append(" FROM st_vendormaster vm ");
        sb.Append(" where 1=1 ");
        if (searchvalue != "")
        {
            sb.Append(" and "+searchtype+" like '%"+searchvalue+"%' ");
        }

        if (SupplierCategory != "0")
        {
            sb.Append(" and SupplierCategory='" + SupplierCategory + "'");
        }
        if (OrganizationType != "0")
        {
            sb.Append(" and OrganizationType='" + OrganizationType + "'");
        }

        if (Status != "")
        {
            sb.Append(" and ApprovalStatus='" + Status + "'");
        }
        sb.Append(" order by vm.SupplierID desc limit " + NoofRecord + "  ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindFinData(string vendorid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT financialyear,ROUND(AnnualTurnover) AnnualTurnover FROM st_supplier_financial WHERE supplierid='" + vendorid + "' "));
     
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindgstnData(string vendorid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT stateid,state,gst_no,address FROM st_supplier_gstn WHERE supplierid='" + vendorid + "' "));
     
    }
    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchDataExcel(string searchtype, string searchvalue, string SupplierCategory, string OrganizationType, string Status, string NoofRecord)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ");
        sb.Append(" SupplierID,SupplierName, SupplierCode,SupplierType,(select Name from st_supplierType where id=SupplierCategory)SupplierCategory, ");
        sb.Append(" (select Name from st_supplierType where id=OrganizationType)OrganizationType, HouseNo,Street, Country, State,  ");
        sb.Append(" PinCode, Landline,FaxNo,EmailId, Website, PrimaryContactPerson, PrimaryContactPersonDesignation,  ");
        sb.Append(" PrimaryContactPersonMobileNo,PrimaryContactPersonEmailId,SecondaryContactPerson, SecondaryContactPersonDesignation,  ");
        sb.Append(" SecondaryContactPersonMobileNo,SecondaryContactPersonEmailId,CINNo, PFRegistartionNo, NameonPANCard, PANCardNo,  ");
        sb.Append(" ROCNo, ESIRegistrationNo, ISOCertificationNo, ISOValidUpto,PollutioncontrolBoardCertificationNo, PollutionValidUpto,  ");
        sb.Append(" Bank1, Bank1Branch, Bank1AccountsNo, Bank1IFSCCode, Bank1Address1,Bank1Address2,  ");
        sb.Append(" Bank1City,Bank1State, Bank2, Bank2Branch, Bank2AccountsNo,Bank2IFSCCode,  ");
        sb.Append(" Bank2Address1, Bank2Address2, Bank2City,Bank2State,PaymentTerms,Taxes,  ");
        sb.Append(" DeliveryTerms,VendorToNotes, CreditLimit,  ");
        sb.Append(" (select group_concat(state) from st_supplier_gstn where supplierID=vm.supplierID) DeliveryState,");
        sb.Append(" (select group_concat(GST_No) from st_supplier_gstn where supplierID=vm.supplierID) GSTNo,");
        sb.Append(" if(IsMSMERegistration=0,'No','Yes')IsMSMERegistration,MSMERegistrationNo,MSMERegistrationValidDate,ifnull(OracleVendorCode,'') as OracleVendorCode,ifnull(OracleVendorSite,'') as OracleVendorSite, ");
        sb.Append(" DATE_FORMAT(vm.CreaterDateTime, '%d/%m/%Y') CreatedDate,(SELECT NAME FROM employee_master WHERE employee_id=vm.CreaterID) CreatedBy, ");
        sb.Append(" DATE_FORMAT(vm.CheckedDate, '%d/%m/%Y') CheckedDate,(SELECT NAME FROM employee_master WHERE employee_id=vm.CheckedBy) CheckedBy, ");
        sb.Append(" DATE_FORMAT(vm.ApprovedDate, '%d/%m/%Y') ApprovedDate,(SELECT NAME FROM employee_master WHERE employee_id=vm.ApprovedBy) ApprovedBy, ");
        sb.Append(" IF(vm.updatedby IS NULL,'',DATE_FORMAT(vm.updateDate, '%d/%m/%Y')) UpdatedDate,(SELECT NAME FROM employee_master WHERE employee_id=vm.updatedby) UpdatedBy ");
        sb.Append(" FROM st_vendormaster vm ");

        sb.Append(" where 1=1 ");
        if (searchvalue != "")
        {
            sb.Append(" and " + searchtype + " like '%" + searchvalue + "%' ");
        }

        if (SupplierCategory != "0")
        {
            sb.Append(" and SupplierCategory='" + SupplierCategory + "'");
        }
        if (OrganizationType != "0")
        {
            sb.Append(" and OrganizationType='" + OrganizationType + "'");
        }

        if (Status != "")
        {
            sb.Append(" and ApprovalStatus='" + Status + "'");
        }
        sb.Append(" order by vm.SupplierID desc  ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = " Store Supplier Master";
            return "true";
        }
        else
        {
            return "false";
        }


    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SetStatus(int itemId, int Status)
    {
        string str = "";
        if (Status == 1)
        {
            str = "update st_vendormaster set ApprovalStatus='" + Status + "',CheckedBy='" + UserInfo.ID + "',CheckedDate=now() where SupplierID='" + itemId + "'";

        }

        if (Status == 2)
        {
            str = "update st_vendormaster set ApprovalStatus='" + Status + "',ApprovedBy='" + UserInfo.ID + "',ApprovedDate=now() where SupplierID='" + itemId + "'";

        }

        StockReports.ExecuteScalar(str);
        return "true";
    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateVendorMaster(StoreVendormaster vendormaster, List<SupplierFinancial> vendorfidetail, List<SupplierGSTN> vendorgstndetail)
    {

        if (vendormaster.IsLoginRequired == "1" && Util.GetInt(StockReports.ExecuteScalar("select count(1) from st_vendormaster where LoginUserName='" + vendormaster.LoginUserName + "' and SupplierID<>'" + vendormaster.SupplierID + "' ")) > 0)
        {

            return "0#User Name Already In Used Please Choose Other User Name.!";

        }

        if (vendormaster.PANCardNo != "" && Util.GetInt(StockReports.ExecuteScalar("select count(1) from st_vendormaster where PANCardNo='" + vendormaster.PANCardNo + "' and SupplierID<>'" + vendormaster.SupplierID + "'")) > 0)
        {

            return "2#Pan Card No Already Register With " + Util.GetString(StockReports.ExecuteScalar("select SupplierName from st_vendormaster where PANCardNo='" + vendormaster.PANCardNo + "' limit 1"));

        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int vendorid = 0;
            StoreVendormaster objsm = new StoreVendormaster(tnx);
            objsm.SupplierID = vendormaster.SupplierID;
            objsm.SupplierName = vendormaster.SupplierName;
            objsm.SupplierCode = vendormaster.SupplierCode;
            objsm.SupplierType = vendormaster.SupplierType;
            objsm.SupplierCategory = vendormaster.SupplierCategory;
            objsm.OrganizationType = vendormaster.OrganizationType;
            objsm.HouseNo = vendormaster.HouseNo;
            objsm.Street = vendormaster.Street;
            objsm.Country = vendormaster.Country;
            objsm.State = vendormaster.State;
            objsm.PinCode = vendormaster.PinCode;
            objsm.Landline = vendormaster.Landline;
            objsm.FaxNo = vendormaster.FaxNo;
            objsm.EmailId = vendormaster.EmailId;
            objsm.Website = vendormaster.Website;
            objsm.PrimaryContactPerson = vendormaster.PrimaryContactPerson;
            objsm.PrimaryContactPersonDesignation = vendormaster.PrimaryContactPersonDesignation;
            objsm.PrimaryContactPersonMobileNo = vendormaster.PrimaryContactPersonMobileNo;
            objsm.PrimaryContactPersonEmailId = vendormaster.PrimaryContactPersonEmailId;
            objsm.SecondaryContactPerson = vendormaster.SecondaryContactPerson;
            objsm.SecondaryContactPersonDesignation = vendormaster.SecondaryContactPersonDesignation;
            objsm.SecondaryContactPersonMobileNo = vendormaster.SecondaryContactPersonMobileNo;
            objsm.SecondaryContactPersonEmailId = vendormaster.SecondaryContactPersonEmailId;
            objsm.CINNo = vendormaster.CINNo;
            objsm.PFRegistartionNo = vendormaster.PFRegistartionNo;
            objsm.NameonPANCard = vendormaster.NameonPANCard;
            objsm.PANCardNo = vendormaster.PANCardNo;
            objsm.ROCNo = vendormaster.ROCNo;
            objsm.ESIRegistrationNo = vendormaster.ESIRegistrationNo;
            objsm.ISOCertificationNo = vendormaster.ISOCertificationNo;
            objsm.ISOValidUpto = vendormaster.ISOValidUpto;
            objsm.PollutioncontrolBoardCertificationNo = vendormaster.PollutioncontrolBoardCertificationNo;
            objsm.PollutionValidUpto = vendormaster.PollutionValidUpto;
            objsm.Bank1 = vendormaster.Bank1;
            objsm.Bank1Branch = vendormaster.Bank1Branch;
            objsm.Bank1AccountsNo = vendormaster.Bank1AccountsNo;
            objsm.Bank1IFSCCode = vendormaster.Bank1IFSCCode;
            objsm.Bank1Address1 = vendormaster.Bank1Address1;
            objsm.Bank1Address2 = vendormaster.Bank1Address2;
            objsm.Bank1City = vendormaster.Bank1City;
            objsm.Bank1State =vendormaster.Bank1City;
            objsm.Bank2 = vendormaster.Bank2;
            objsm.Bank2Branch = vendormaster.Bank2Branch;
            objsm.Bank2AccountsNo = vendormaster.Bank2AccountsNo;
            objsm.Bank2IFSCCode = vendormaster.Bank2IFSCCode;
            objsm.Bank2Address1 = vendormaster.Bank2Address1;
            objsm.Bank2Address2 = vendormaster.Bank2Address2;
            objsm.Bank2City = vendormaster.Bank2City;
            objsm.Bank2State = vendormaster.Bank2State;
            objsm.PaymentTerms = vendormaster.PaymentTerms ;
            objsm.Taxes =vendormaster.Taxes;
            objsm.DeliveryTerms = vendormaster.DeliveryTerms;
            objsm.VendorToNotes = vendormaster.VendorToNotes;
            objsm.CreditLimit = vendormaster.CreditLimit;
            objsm.IsActive = vendormaster.IsActive;

            objsm.IsLoginRequired = vendormaster.IsLoginRequired;
            objsm.LoginUserName = vendormaster.LoginUserName;
            objsm.LoginPassword = vendormaster.LoginPassword;
            objsm.IsAutoRejectPO = vendormaster.IsAutoRejectPO;
            objsm.AutoRejectPOAfterDays = vendormaster.AutoRejectPOAfterDays;

            objsm.IsMSMERegistration = vendormaster.IsMSMERegistration;
            objsm.MSMERegistrationNo = vendormaster.MSMERegistrationNo;
            objsm.MSMERegistrationValidDate = vendormaster.MSMERegistrationValidDate;
            objsm.OracleVendorCode = vendormaster.OracleVendorCode;
            objsm.OracleVendorSite = vendormaster.OracleVendorSite;
           


            vendorid = objsm.Update();
            if (vendorid == 0)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "0#Error";

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_supplier_financial where supplierID='" + vendormaster.SupplierID + "'");
            StringBuilder sb = new StringBuilder();
            foreach (SupplierFinancial obj in vendorfidetail)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO st_supplier_financial(supplierID,supplier,FinancialYear,AnnualTurnover)");
                sb.Append(" VALUES('" + vendormaster.SupplierID + "','" + obj.Supplier + "','" + obj.FinancialYear + "','" + obj.AnnualTurnover + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_supplier_gstn where supplierID='" + vendormaster.SupplierID + "'");
            foreach (SupplierGSTN myarr in vendorgstndetail)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO st_supplier_gstn(supplierID,supplier,StateID,State,GST_No,Address)");
                sb.Append(" VALUES ('" + vendormaster.SupplierID + "','" + myarr.Supplier + "','" + myarr.StateID + "','" + myarr.State + "','" + myarr.GST_No + "','" + myarr.Address + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            }


            tnx.Commit();

            return "1#";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }

    
}


public class SupplierFinancial
{

    public string SupplierID { get; set; }
    public string Supplier { get; set; }
    public string FinancialYear { get; set; }
    public string AnnualTurnover { get; set; }
  


}


public class SupplierGSTN
{

    public string SupplierID { get; set; }
    public string Supplier { get; set; }
    public string StateID { get; set; }
    public string State { get; set; }
    public string GST_No { get; set; }
    public string Address { get; set; }

}