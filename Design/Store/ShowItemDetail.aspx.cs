using System;
using System.Text;

public partial class Design_Store_ShowItemDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            showdetail(Request.QueryString["itemid"].ToString(),Util.GetString(Request.QueryString["type"]));
        }
    }
    void showdetail(string itemid,string type)
    {
        
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name ItemGroupName,sm.itemid,sm.TypeName ItemName, ");
        sb.Append(" sm.hsncode HSNCode,sm.apolloitemcode ApolloitemCode,if(sm.isactive=1,'Yes','No') IsActive ,sm.Description,sm.Specification,sm.MakeandModelNo,if(sm.IsExpirable='1','Yes','No') Expirable,sm.Expdatecutoff,sm.TemperatureStock,sm.GSTNTax, ");
        sb.Append(" ManufactureName,CatalogNo,MachineName,MajorUnitName PurchasedUnit, Converter,PackSize,MinorUnitName ConsumptionUnit,IssueMultiplier, ");
        sb.Append(" DATE_FORMAT(sm.CreaterDateTime, '%d/%m/%Y') CreatedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.CreaterID) CreatedBy, ");
        sb.Append(" DATE_FORMAT(sm.CheckedDate, '%d/%m/%Y') CheckedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.CheckedBy) CheckedBy ,");
        sb.Append(" DATE_FORMAT(sm.ApprovedDate, '%d/%m/%Y') ApprovedDate,(SELECT NAME FROM employee_master WHERE employee_id=sm.ApprovedBy) ApprovedBy ");
        sb.Append(" FROM st_itemmaster sm ");
        sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID ");
        if (type == "1")
        {
            sb.Append(" where ItemId='" + itemid + "'");
        }
        else
        {
            sb.Append(" where ItemIdgroup='" + itemid + "'");
        }
        grd.DataSource = StockReports.GetDataTable(sb.ToString());
        grd.DataBind();

       

     

    }
}