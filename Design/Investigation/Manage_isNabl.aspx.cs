using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.Text;
using System.IO;

public partial class Design_Investigation_Manage_isNabl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //bindcentre();
            LoadCategory();

        }

    }

    private void LoadCategory()
    {
        string str = "";
        str = "Select DISTINCT(cm.Name),concat(cm.CategoryID,'#',if(cf.ConfigRelationID=3,1,0))CategoryID from f_categorymaster cm inner join f_configrelation cf on cm.categoryid = cf.categoryid where cf.ConfigRelationID in ";
        str = str + "(3) order by cm.Name";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "Name";
            ddlCategory.DataValueField = "CategoryID";
            ddlCategory.DataBind();
            // ddlCategory.Items.Insert(0, new ListItem("---Select---", "0#"));

            LoadSubCategory(ddlCategory.SelectedValue.Split('#')[0].Trim());
        }

    }

    private void LoadSubCategory(string CategoryID)
    {
        string str = "Select sc.Name,concat(sc.SubcategoryID,'#',if(sm.Department is null,'0','1'))SubcategoryID from (Select Name,SubCategoryID from f_Subcategorymaster where CategoryID ='" + CategoryID + "' order by Name)sc left join  (Select distinct department from f_surgery_master) sm on sm.Department = sc.Name";

        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "Name";
            ddlSubCategory.DataValueField = "SubCategoryID";
            ddlSubCategory.DataBind();
            ddlSubCategory.SelectedIndex = 0;

            ddlSubCategory.Items.Add(new ListItem("All", "All"));
        }
        else
            ddlSubCategory.Items.Insert(0, new ListItem("---Select---", "0#"));
    }
    private void bindcentre()
    {
        string mystr = "SELECT CentreID,Centre FROM centre_master  where isActive='1' order by centre";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        ddlCentre.DataSource = dt;
        ddlCentre.DataTextField = "Centre";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        // ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(UserInfo.Centre));
    }
    [WebMethod]
    public static string bindCentreLoadType(string BusinessZoneID, string StateID, string CityID, string TypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE IsActive=1 ");
        if (BusinessZoneID != "0" && BusinessZoneID != "-1")
            sb.Append(" AND BusinessZoneID in(" + BusinessZoneID + ") ");
        if (StateID != "0" && StateID != "-1")
            sb.Append(" AND StateID in (" + StateID + ") ");
        if (CityID != "0" && CityID != "-1")
            sb.Append(" AND CityID in (" + CityID + " )");
        if (TypeID != "0" && TypeID != "-1")
            sb.Append(" AND type1ID in (" + TypeID + " )");
        sb.Append("  order by centre ");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public static string UploadLogo(string Based64BinaryString, string IsNable, string CentreID)
    {
        string result = "";
        string Message = "";
        try
        {
            string format = "";
            string path = HttpContext.Current.Server.MapPath("../../App_Images/ManageNable");
            string name = DateTime.Now.ToString("hhmmss");

            if (Based64BinaryString.Contains("data:image/jpeg;base64,"))
            {
                format = "jpg";
            }
            if (Based64BinaryString.Contains("data:image/png;base64,"))
            {
                format = "png";
            }
            if (Based64BinaryString.Contains("data:text/plain;base64,"))
            {
                format = "txt";
            }
            if (Based64BinaryString.Contains("data:application/pdf;base64,"))
            {
                format = "pdf";
            }
            if (Based64BinaryString.Contains("data:image/gif;base64,")) {
                format = "gif";
            }
            string str = Based64BinaryString.Replace("data:image/jpeg;base64,", " ");//jpg check
            str = str.Replace("data:image/png;base64,", " ");//png check
            str = str.Replace("data:text/plain;base64,", " ");//text file check
            str = str.Replace("data:application/pdf;base64,", " ");//pdf file check
            str = str.Replace("data:;base64,", " ");//zip file check
            str = str.Replace("data:image/gif;base64,"," ");//gif image check

            string attachment = "";
            string Hascode = Guid.NewGuid().ToString();
            byte[] data = Convert.FromBase64String(str);

            System.IO.MemoryStream ms = new System.IO.MemoryStream(data, 0, data.Length);
            ms.Write(data, 0, data.Length);
            System.Drawing.Image image = System.Drawing.Image.FromStream(ms, true);
            if (IsNable == "1")
            {
                attachment = "/ManageNable/" + CentreID + "_NABL." + format;
                if (File.Exists(@path + "/" + CentreID + "_NABL." + format))
                {
                    File.Delete(@path + "/" + CentreID + "_NABL." + format);
                }
                image.Save(path + "/" + CentreID + "_NABL." + format);
            }
            if (IsNable == "2")
            {
                attachment = "/ManageNable/" + CentreID + "_CAP." + format;
                if (File.Exists(@path + "/" + CentreID + "_CAP." + format))
                {
                    File.Delete(@path + "/" + CentreID + "_CAP." + format);
                }
                image.Save(path + "/" + CentreID + "_CAP." + format);
            }
            if (IsNable == "3")
            {
                attachment = "/ManageNable/" + CentreID + "_NABH." + format;
                if (File.Exists(@path + "/" + CentreID + "_NABH." + format))
                {
                    File.Delete(@path + "/" + CentreID + "_NABH." + format);
                }
                image.Save(path + "/" + CentreID + "_NABH." + format);
            }
            if (IsNable == "1")
            {
                string isnab = "update centre_master set NablLogoPath='" + attachment + "',IsNabl='1' where centreID='" + CentreID + "'";
                StockReports.ExecuteDML(isnab);
            }
            if (IsNable == "2")
            {
                string isCap = "update centre_master set CapLogoPath='" + attachment + "',IsCap='1' where centreID='" + CentreID + "'";
                StockReports.ExecuteDML(isCap);
            }
            if (IsNable == "3")
            {
                string isNabh = "update centre_master set NabhLogoPath='" + attachment + "',IsNabh='1' where centreID='" + CentreID + "'";
                StockReports.ExecuteDML(isNabh);
            }
            Message = "1";
            return Message;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Message = "Error occure please try again";
            return Message;
        }
    }
    [WebMethod]
    public static string getLogo(string CentreID,string IsNable) {
        string str = "";
        if (IsNable == "1")
        {
            str = "Select NablLogoPath from centre_master where centreID='" + CentreID + "' and IsNabl='1' ";
        }
        if (IsNable == "2") {
            str = "Select CapLogoPath from centre_master where centreID='" + CentreID + "' and IsCap='1' ";
        }
        if (IsNable == "3") {
            str = "Select NabhLogoPath from centre_master where centreID='" + CentreID + "' and IsNabh='1' ";
        }
        DataTable dt = StockReports.GetDataTable(str);
       return  Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}
