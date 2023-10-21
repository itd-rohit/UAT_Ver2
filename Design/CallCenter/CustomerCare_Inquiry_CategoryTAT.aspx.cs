using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_CallCenter_CustomerCare_Inquiry_CategoryTAT : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        txtSubCategoryID.Text = Util.GetString(Request.QueryString["Id"]);

        if (txtSubCategoryID.Text != string.Empty)
        {
            string InqSubCategory = StockReports.ExecuteScalar("SELECT SubCategoryName FROM `cutomercare_subcategory_master` WHERE ID='" + txtSubCategoryID.Text.Trim() + "' AND IsActive='1'");
            if (InqSubCategory != string.Empty)
            {
                txtType.Text = "TAT";

                lblInqSubCategory.Text = InqSubCategory.ToString();
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindEnquery(string SubCategoryID, string InqueryType)
    {
        DataTable dt = new DataTable();
        DataTable dtre = StockReports.GetDataTable(" SELECT EmpLavel FROM `call_centre_employeelavel` WHERE IsActive='1' ");
        dt.Columns.Add("ID");
        dt.Columns.Add("Name");
        dt.Columns.Add("InqueryType");
        int count = dtre.Rows.Count;
        for (int i = 0; i < count; i++)
        {
            dt.Columns.Add(dtre.Rows[i]["EmpLavel"].ToString());
            DataRow dr = dtre.NewRow();
            dr["EmpLavel"] = dtre.Rows[i]["EmpLavel"].ToString();
            dtre.Rows.Add(dr);
        }

        DataTable ph = StockReports.GetDataTable(" SELECT `ID`,`Name` FROM CustomerCare_InquiryType ");

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,SubCategoryID,`CC_InqType`,`Lavel1Time`,`Lavel2Time`,`Lavel3Time` FROM customercare_inquery_categoryTAT WHERE SubCategoryID='" + SubCategoryID + "' AND IsActive=1 ");
        DataTable dttime = StockReports.GetDataTable(sb.ToString());

        foreach (DataRow dw in ph.Rows)
        {
            DataRow dwc = dt.NewRow();
            dwc["ID"] = dw["ID"].ToString();
            dwc["Name"] = dw["Name"].ToString();
            dwc["InqueryType"] = InqueryType;
            foreach (DataColumn dc in dt.Columns)
            {
                if (dc.ColumnName != "ID" && dc.ColumnName != "Name" && dc.ColumnName != "InqueryType")
                {
                    try
                    {
                        string ss = "CC_InqType=" + dw["ID"].ToString() + " ";
                        DataRow[] drTemp = dttime.Select(ss);
                        if (drTemp.Length > 0)
                            if (dc.ColumnName == "Level1")
                            {
                                dwc[dc.ColumnName] = drTemp[0]["Lavel1Time"].ToString();
                            }
                        if (dc.ColumnName == "Level2")
                        {
                            dwc[dc.ColumnName] = drTemp[0]["Lavel2Time"].ToString();
                        }
                        if (dc.ColumnName == "Level3")
                        {
                            dwc[dc.ColumnName] = drTemp[0]["Lavel3Time"].ToString();
                        }
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                    }
                }
            }

            dt.Rows.Add(dwc);
        }
        return Util.getJson(dt);
    }

    [WebMethod]
    public static string SaveEnquery(string EnqueryDetail, string SubCategoryID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            JavaScriptSerializer Serializer = new JavaScriptSerializer();
            List<Inquiry> ItemDetails = Serializer.Deserialize<List<Inquiry>>(EnqueryDetail);

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE customercare_inquery_categoryTAT SET IsActive=@IsActive,UpdatedBy=@UpdatedBy,UpdatedID=@UpdatedID,UpdatedDate=@UpdatedDate   WHERE SubCategoryID=@SubCategoryID",
                new MySqlParameter("@SubCategoryID", SubCategoryID), new MySqlParameter("@IsActive", "0"), new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                new MySqlParameter("@UpdatedID", UserInfo.ID), new MySqlParameter("@UpdatedDate", DateTime.Now));
            StringBuilder sb = new StringBuilder();
            for (int k = 0; k < ItemDetails.Count; k++)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO customercare_inquery_categorytat(CreatedBy,CreatedID,CC_InqType,Lavel1Time,Lavel2Time,`Lavel3Time`,`Name`,SubCategoryID)");
                sb.Append(" VALUES(@CreatedBy,@CreatedID,@CC_InqType,@Lavel1Time,@Lavel2Time,@Lavel3Time,@Name,@SubCategoryID)");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),

                     new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedID", UserInfo.ID),
                     new MySqlParameter("@CC_InqType", ItemDetails[k].InqType),
                     new MySqlParameter("@Lavel1Time", ItemDetails[k].Lavel1), new MySqlParameter("@Lavel2Time", ItemDetails[k].Lavel2),
                     new MySqlParameter("@Lavel3Time", ItemDetails[k].Lavel3), new MySqlParameter("@Name", ItemDetails[k].Name),
                     new MySqlParameter("@SubCategoryID", SubCategoryID)
                     );
            }
            tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}

public class Inquiry
{
    public string Name { get; set; }
    public string Lavel1 { get; set; }
    public string Lavel2 { get; set; }
    public string Lavel3 { get; set; }
    public int InqType { get; set; }
    public int ID { get; set; }
}