using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_InqueryCategory_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindGroup();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindSubCategory()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT scat.ID,scat.SubCategoryName,cat.CategoryName,scat.IsActive,scat.ShowBarcodeNumber,scat.ShowVisitNo,scat.ShowDepartment,");
        sb.Append(" scat.ShowInvestigationID,scat.ShowPatientID,scat.CategoryID,scat.GroupID,cgm.GroupName,scat.MandatoryBarcodeNumber,scat.MandatoryInvestigationID,scat.MandatoryPatientID,scat.MandatoryVisitNo,scat.MandatoryDepartment FROM cutomercare_Subcategory_master scat  ");
        sb.Append(" INNER JOIN cutomercare_category_master cat ON scat.`CategoryID`=cat.`ID` ");
        sb.Append(" INNER JOIN CutomerCare_Group_Master cgm ON cgm.GroupID=cat.GroupID ORDER BY ID DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
    }

    [WebMethod(EnableSession = true)]
    public static string SaveSubCategory(string CategoryName, string IsActive, string Id, string CategoryID, string ShowBarcodeNumber, string ShowInvestigationID, string ShowPatientID, string ShowVisitNo, string ShowDepartment, string GroupID, int MandatoryBarcodeNumber, int MandatoryInvestigationID, int MandatoryPatientID, int MandatoryVisitNo, int MandatoryDepartment)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Id == "")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM cutomercare_Subcategory_master WHERE SubCategoryName='" + CategoryName + "' and CategoryID='" + CategoryID + "' "));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    sb.Append(" INSERT INTO cutomercare_Subcategory_master(SubCategoryName,GroupID,CategoryID,IsActive,ShowBarcodeNumber,ShowInvestigationID,ShowPatientID,ShowVisitNo,ShowDepartment,CreatedBy,CreatedID,CreatedDate,MandatoryBarcodeNumber,MandatoryInvestigationID,MandatoryPatientID,MandatoryVisitNo,MandatoryDepartment)  VALUES('" + CategoryName + "','" + GroupID + "','" + CategoryID + "','" + IsActive + "','" + ShowBarcodeNumber + "','" + ShowInvestigationID + "','" + ShowPatientID + "','" + ShowVisitNo + "','" + ShowDepartment + "','" + UserInfo.LoginName + "','" + UserInfo.ID + "',Now(),'" + MandatoryBarcodeNumber + "','" + MandatoryInvestigationID + "','" + MandatoryPatientID + "','" + MandatoryVisitNo + "','" + MandatoryDepartment + "')");
                }
            }
            else
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM cutomercare_Subcategory_master WHERE SubCategoryName='" + CategoryName + "'and CategoryID='" + CategoryID + "' and  ID<>'" + Id + "'"));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    sb.Append("update CutomerCare_SubCategory_Master set ShowPatientID='" + ShowPatientID + "',ShowInvestigationID='" + ShowInvestigationID + "',ShowBarcodeNumber='" + ShowBarcodeNumber + "',GroupID='" + GroupID + "', CategoryID='" + CategoryID + "', SubCategoryName='" + CategoryName + "', IsActive='" + IsActive + "',ShowBarcodeNumber='" + ShowBarcodeNumber + "',ShowInvestigationID='" + ShowInvestigationID + "',ShowPatientID='" + ShowPatientID + "',ShowVisitNo='" + ShowVisitNo + "',ShowDepartment='" + ShowDepartment + "',UpdatedBy='" + UserInfo.LoginName + "',UpdatedID='" + UserInfo.ID + "',UpdatedDate=Now(),MandatoryBarcodeNumber='" + MandatoryBarcodeNumber + "',MandatoryInvestigationID='" + MandatoryInvestigationID + "',MandatoryPatientID='" + MandatoryPatientID + "',MandatoryVisitNo='" + MandatoryVisitNo + "',MandatoryDepartment='" + MandatoryDepartment + "' ");
                    sb.Append(" Where  ID='" + Id + "' ");
                }
            }
            StockReports.ExecuteDML(sb.ToString());
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    public void bindGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT GroupID,GroupName FROM CutomerCare_Group_Master where IsActive=1 ORDER BY GroupName asc ");
        ddlgroup.DataSource = dt;
        ddlgroup.DataTextField = "GroupName";
        ddlgroup.DataValueField = "GroupID";
        ddlgroup.DataBind();
        ddlgroup.Items.Insert(0, new ListItem { Text = "-----Select-----", Value = "0" });
    }
     [WebMethod(EnableSession = true)]
    public static string bindCategory(string GroupID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,CategoryName FROM CutomerCare_Category_Master where IsActive=1 and GroupID='" + GroupID + "' ORDER BY CategoryName asc ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
}