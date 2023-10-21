using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;


public partial class Design_Common_CommonJsonData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = string.Empty;
        switch (cmd)
        {
            case "ReferDoctor":
                {
                    rtrn = JsonConvert.SerializeObject(BindReferDoctor());
                    break;
                }
            case "Panel":
                {
                    rtrn = JsonConvert.SerializeObject(BindPanel());
                    break;

                }
            case "GetTestList":
                {
                    rtrn = JsonConvert.SerializeObject(GetTestList());
                    break;
                }
            case "LedgerPanel":
                {
                    rtrn = JsonConvert.SerializeObject(bindLedgerPanel());
                    break;
                }

            case "GetCentreList":
                {
                    rtrn = JsonConvert.SerializeObject(GetCentreList());
                    break;
                }

            case "LedgerPanelPUP":
                {
                    rtrn = JsonConvert.SerializeObject(LedgerPanelPUP());
                    break;
                }
            case "SecondReference":
                {
                    rtrn = JsonConvert.SerializeObject(BindSecondReference());
                    break;
                }
            
            case "DoctorShareStatus":
                {
                    rtrn = JsonConvert.SerializeObject(DoctorShareStatus());
                    break;
                }
            case "GetTestEstimateList":
                {
                    rtrn = JsonConvert.SerializeObject(GetTestEstimateList());
                    break;
                }
            case "LedgerPanelNew":
                {
                    rtrn = JsonConvert.SerializeObject(bindLedgerPanelNew());
                    break;
                }
            case "bindPanelAdvPay":
                {
                    rtrn = JsonConvert.SerializeObject(bindPanelAdvPay());
                    break;
                }
            case "GetEmployee":
                {
                    rtrn = JsonConvert.SerializeObject(bindEmployee());
                    break;
                }
            case "GetCampTestDetail":
                {
                    rtrn = JsonConvert.SerializeObject(GetCampTestDetail());
                    break;
                }
        }

        Response.Clear();
        Response.ContentType = "application/json; charset=utf-8";
        Response.Write(rtrn);
        Response.End();
    }
    private DataTable BindReferDoctor()
    {
        string centreid = Util.GetString(Request.QueryString["centreid"]);
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT doctor_id value, NAME label FROM doctor_referal WHERE doctor_id <=2 AND NAME LIKE @docname  ");
            sb.Append(" UNION ALL  ");
            sb.Append(" SELECT dr.doctor_id value,CONCAT(dr.NAME,IF(IFNULL(dr.Mobile,'')='','',CONCAT(' # ',dr.Mobile)), ");
            sb.Append(" IF(IFNULL(dr.Specialization,'')='','',CONCAT(' # ',dr.Specialization)),IF(IFNULL(dr.Degree,'')='','',CONCAT(' # ',dr.Degree))) label  ");
            sb.Append(" FROM doctor_referal dr ");
            //sb.Append(" INNER JOIN `doctor_referal_centre` drc ON drc.`Doctor_ID`=dr.`Doctor_ID` AND drc.`CentreID`=@CentreID ");
            sb.Append(" WHERE dr.isactive=1  ");
            sb.Append(" AND dr.name LIKE @docname  ");
            sb.Append(" ORDER BY label LIMIT 20 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CentreID", centreid), new MySqlParameter("@docname", string.Format("{0}%", Util.GetString(Request.QueryString["docname"])))).Tables[0])
                return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    private DataTable BindPanel()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT concat(pn.panel_id,'#',pn.ReferenceCode,'#',Payment_Mode )value,pn.company_name label  FROM Centre_Panel cp ");
            sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id and cp.CentreId=@CentreId  ");
            sb.Append(" AND cp.isActive=1 AND pn.isActive=1 ");
            sb.Append(" WHERE pn.company_name LIKE @company_name ");
            sb.Append(" order by pn.company_name limit 20 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                          new MySqlParameter("@CentreId", Util.GetString(Request.QueryString["centreid"])),
                          new MySqlParameter("@company_name", string.Format("{0}%", Util.GetString(Request.QueryString["centreid"])))).Tables[0])
                return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    private DataTable GetTestList()
    {
        if (Util.GetString(Request.QueryString["ReferenceCodeOPD"]) == string.Empty)
        {
            return null;
        }
        string DeptID = Util.GetString(Request.QueryString["DeptID"]);
        string Gender = Util.GetString(Request.QueryString["Gender"]);
        string DOB = Util.GetString(Request.QueryString["DOB"]);
        double AgeInDays = 0;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.itemid value,CONCAT(typeName,' # ',Name) label,if(im.subcategoryid='15','Package','Test') type, ");
            //shatrughan 10.03.17 for schedule date wise rate
            sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,@ReferenceCodeOPD,if(@PrescribeDate <>'',@PrescribeDateTime,  CURRENT_DATE()),@Panel_Id)),0)Rate, ");
            sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,@PanelID_MRP,if(@PrescribeDate <>'',@PrescribeDateTime,  CURRENT_DATE()),@Panel_Id)),0)MRP, ");
            if (Request.QueryString["MemberShipCardNo"] == string.Empty)
            {
                if (Request.QueryString["DiscountTypeID"] != string.Empty)
                    sb.Append(" IFNULL((SELECT get_discountPer(@DiscountTypeID ,im.itemid)),0)DiscPer ");
                else
                    sb.Append(" 0 DiscPer ");
            }
            else
            {
               sb.Append(" 0 DiscPer ");
               // sb.Append(" IFNULL((SELECT get_membershipcard_discount(@MemberShipCardNo ,im.itemid)),0)DiscPer ");
            }
            sb.Append(" from f_itemmaster im ");
            sb.Append(" INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=im.SubcategoryID ");
            if (DeptID != "")
            {
                sb.Append(" AND sub.SubcategoryID IN (" + DeptID + ") ");
            }

            if (Request.QueryString["PanelType"].ToUpper() == "CAMP")
                sb.Append(" INNER JOIN f_ratelist rl ON rl.`ItemID`=im.`ItemID` AND rl.`Panel_ID`=@ReferenceCodeOPD   ");

            sb.Append(" WHERE isActive=1 ");

            if (Request.QueryString["SearchType"] == "1")
                sb.Append(" AND (typeName LIKE @TestName  OR inv_shortName LIKE @TestName) ");
            else if (Request.QueryString["SearchType"] == "0")
                sb.Append(" AND im.testcode LIKE @TestCode ");
            else
                sb.Append(" AND  (typeName LIKE @typeName  OR inv_shortName LIKE @typeName) ");
            if (Gender != string.Empty)
            {
                sb.Append(" AND `Gender` IN ('B',@Gender) ");
            }
            if (DOB != string.Empty)
            {
                AgeInDays = (DateTime.Now - Util.GetDateTime(DOB)).TotalDays;
                sb.Append(" and FromAge <= @AgeInDays and `ToAge` >= @AgeInDays  ");
            }
            if (Request.QueryString["PanelType"].ToUpper() != "CAMP")
                sb.Append(" HAVING IFNULL(Rate,0)<>0 ");

           

            sb.Append("  order by label limit 20 ");
            
            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@ReferenceCodeOPD", Util.GetInt(Request.QueryString["ReferenceCodeOPD"]));
                if (Request.QueryString["SearchType"] == "1")
                    da.SelectCommand.Parameters.AddWithValue("@TestName", string.Format("{0}%", Request.QueryString["TestName"]));
                else if (Request.QueryString["SearchType"] == "0")
                    da.SelectCommand.Parameters.AddWithValue("@TestCode", string.Format("{0}%", Request.QueryString["TestName"]));
                else
                    da.SelectCommand.Parameters.AddWithValue("@typeName", string.Format("%{0}%", Request.QueryString["TestName"]));
                if (Request.QueryString["DiscountTypeID"] != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@DiscountTypeID", Request.QueryString["DiscountTypeID"]);

                if (Request.QueryString["MemberShipCardNo"] != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@MemberShipCardNo", Request.QueryString["MemberShipCardNo"]);

                //if (Util.GetString(Request.QueryString["SubcategoryID"]) != string.Empty)
                //    da.SelectCommand.Parameters.AddWithValue("@SubCategoryID", Request.QueryString["SubcategoryID"]);

                da.SelectCommand.Parameters.AddWithValue("@Panel_Id", Util.GetInt(Request.QueryString["Panel_Id"]));
                da.SelectCommand.Parameters.AddWithValue("@PrescribeDate", Util.GetString(Request.QueryString["PrescribeDate"]));
                da.SelectCommand.Parameters.AddWithValue("@PrescribeDateTime", Util.GetDateTime(Request.QueryString["PrescribeDate"]).ToString("yyyy-MM-dd"));
                da.SelectCommand.Parameters.AddWithValue("@Gender", Gender.Substring(0, 1));
                da.SelectCommand.Parameters.AddWithValue("@AgeInDays", AgeInDays);
                da.SelectCommand.Parameters.AddWithValue("@PanelID_MRP", Request.QueryString["PanelID_MRP"]);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    private DataTable bindLedgerPanel()
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Request.QueryString["SearchType"] != "7")
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)label,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID)  value FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
                sb.Append(" WHERE (Company_Name like @Company_Name or fpm.Panel_Code like @Company_Name) ");
                sb.Append("    AND fpm.Panel_ID=fpm.InvoiceTo   ");
                if (Request.QueryString["SearchType"] != string.Empty)
                    sb.Append(" AND cm.type1ID=@type1ID ");
            }
            else
            {

                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)label,CONCAT(fpm.Panel_ID,'#','PUP','#','7') value FROM f_panel_master fpm ");
                sb.Append(" WHERE   ");
                sb.Append("  fpm.PanelType='PUP'  AND  (fpm.Company_Name like @Company_Name or fpm.Panel_Code like @Company_Name)");
            }
            sb.Append("   AND fpm.IsInvoice=1 ");
            
            if (Request.QueryString["IsInvoicePanel"] == "2")
                sb.Append(" AND fpm.InvoiceCreatedOn=2 ");
            else if(Request.QueryString["IsInvoicePanel"] == "1")
                sb.Append("  AND fpm.InvoiceCreatedOn=2 AND MonthlyInvoiceType=1");
            else if(Request.QueryString["IsInvoicePanel"] == "3")
                sb.Append("  AND fpm.InvoiceCreatedOn=2 AND MonthlyInvoiceType=2");
            else
                 sb.Append(" AND fpm.InvoiceCreatedOn=1 ");

            sb.Append(" ORDER BY fpm.Company_Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Company_Name", string.Format("{0}%", Util.GetString(Request.QueryString["PanelName"]))),
                 new MySqlParameter("@type1ID",Request.QueryString["SearchType"])).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return dt;
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    private DataTable GetCentreList()
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Centre label FROM centre_master cm WHERE cm.CentreID<>'' ");
            if (Request.QueryString["CentreName"] != string.Empty)
                sb.Append(" AND cm.Centre LIKE @CentreName ");
            sb.Append(" LIMIT 20 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CentreName", string.Format("%{0}%", Util.GetString(Request.QueryString["CentreName"])))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return dt;
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    private DataTable LedgerPanelPUP()
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Request.QueryString["SearchType"] != "7")
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)label,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID)  value FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
                sb.Append(" WHERE (Company_Name LIKE @Company_Name or fpm.Panel_Code LIKE '@Company_Name) ");
                sb.Append("    AND fpm.Panel_ID=fpm.InvoiceTo   ");
            }
            else
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)label,CONCAT(fpm.Panel_ID,'#','PUP','#','7') value FROM f_panel_master fpm ");
                sb.Append(" WHERE   ");
                sb.Append("  fpm.PanelType='PUP'  AND  (fpm.Company_Name LIKE @Company_Name or fpm.Panel_Code like @Company_Name)");
            }
            sb.Append(" ORDER BY fpm.Company_Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Company_Name", string.Format("{0}%", Util.GetString(Request.QueryString["PanelName"])))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return dt;
                else
                    return null;

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private DataTable BindSecondReference()
    {
        string centreid = Util.GetString(Request.QueryString["centreid"]);
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT doctor_id value, NAME label FROM doctor_referal WHERE doctor_id <=2 AND NAME LIKE @docname  ");
            sb.Append(" UNION ALL  ");
            sb.Append(" SELECT dr.doctor_id value,CONCAT(dr.NAME,IF(IFNULL(dr.Mobile,'')='','',CONCAT(' # ',dr.Mobile)), ");
            sb.Append(" IF(IFNULL(dr.Specialization,'')='','',CONCAT(' # ',dr.Specialization)),IF(IFNULL(dr.Degree,'')='','',CONCAT(' # ',dr.Degree))) label  ");
            sb.Append(" FROM doctor_referal dr ");
            sb.Append(" INNER JOIN `doctor_referal_centre` drc ON drc.`Doctor_ID`=dr.`Doctor_ID` AND drc.`CentreID`=@CentreID ");
            sb.Append(" WHERE dr.isactive=1  ");
            sb.Append(" AND dr.name LIKE @docname  ");
            sb.Append(" ORDER BY label LIMIT 20 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CentreID", centreid),
               new MySqlParameter("@docname", string.Format("{0}%", Util.GetString(Request.QueryString["docname"])))).Tables[0])
                return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    private DataTable DoctorShareStatus()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT dr.Name label,dr.Doctor_ID value FROM `doctor_referal` dr  WHERE ReferMasterShare=0 ");
            if (Request.QueryString["DoctorName"] != string.Empty)
                sb.Append(" AND dr.`Name` LIKE @DoctorName ");
            sb.Append(" ORDER BY dr.`Name`  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@DoctorName", string.Format("{0}%", Util.GetString(Request.QueryString["DoctorName"])))).Tables[0])
                return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
  private DataTable GetTestEstimateList()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Util.GetString(Request.QueryString["ReferenceCodeOPD"]) == "")
            {
                return null;
            }

            string Gender = Util.GetString(Request.QueryString["Gender"]);
            string DOB = Util.GetString(Request.QueryString["DOB"]);
            double AgeInDays = 0;

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.itemid value,CONCAT(typeName,' # ',Name) label,if(im.subcategoryid='15','Package','Test') type, ");
            //shatrughan 10.03.17 for schedule date wise rate

            sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,@ReferenceCodeOPD,if(@PrescribeDate <>'',@PrescribeDate,  CURRENT_DATE()),@Panel_Id)),0)Rate ,");
            sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,@PanelID_MRP,if(@PrescribeDate <>'',@PrescribeDateTime,  CURRENT_DATE()),@Panel_Id)),0)MRP ");



            sb.Append(" from f_itemmaster im ");
            sb.Append(" INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=im.SubcategoryID ");

            sb.Append(" WHERE isActive=1 ");

            if (Request.QueryString["SearchType"] == "1")
                sb.Append(" AND typeName like @TestName ");
            else if (Request.QueryString["SearchType"] == "0")
                sb.Append(" AND im.testcode LIKE @TestCode ");
            else
                sb.Append(" AND typeName like @typeName ");
            if (Gender != string.Empty)
            {
                sb.Append(" AND `Gender` IN ('B',@Gender) ");
            }
            if (DOB != string.Empty)
            {
                AgeInDays = (DateTime.Now - Util.GetDateTime(DOB)).TotalDays;
                sb.Append(" and FromAge <= @AgeInDays and `ToAge` >= @AgeInDays  ");
            }
            sb.Append(" HAVING IFNULL(Rate,0)<>0 ");
            sb.Append("  order by label limit 20 ");


            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@ReferenceCodeOPD", Util.GetInt(Request.QueryString["ReferenceCodeOPD"]));
                if (Request.QueryString["SearchType"] == "1")
                    da.SelectCommand.Parameters.AddWithValue("@TestName", string.Format("{0}%", Request.QueryString["TestName"]));
                else if (Request.QueryString["SearchType"] == "0")
                    da.SelectCommand.Parameters.AddWithValue("@TestCode", string.Format("%{0}%", Request.QueryString["TestName"]));
                else
                    da.SelectCommand.Parameters.AddWithValue("@typeName", string.Format("%{0}%", Request.QueryString["TestName"]));


                da.SelectCommand.Parameters.AddWithValue("@Panel_Id", Util.GetInt(Request.QueryString["Panel_Id"]));
                da.SelectCommand.Parameters.AddWithValue("@PrescribeDate", Util.GetString(Request.QueryString["PrescribeDate"]));
                da.SelectCommand.Parameters.AddWithValue("@PrescribeDateTime", Util.GetDateTime(Request.QueryString["PrescribeDate"]).ToString("yyyy-MM-dd"));
                da.SelectCommand.Parameters.AddWithValue("@PanelID_MRP", Request.QueryString["PanelID_MRP"]);
                da.SelectCommand.Parameters.AddWithValue("@Gender", Gender.Substring(0, 1));
                da.SelectCommand.Parameters.AddWithValue("@AgeInDays", AgeInDays);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
  private DataTable bindPanelAdvPay()
  {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            HttpContext ctx = HttpContext.Current;
            string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
            StringBuilder sb = new StringBuilder();
           
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)label,CONCAT(fpm.Panel_ID,'#','PUP','#','7','#',fpm.InvoiceCreatedOn,'#',fpm.MonthlyInvoiceType) value FROM f_panel_master fpm ");
                sb.Append(" WHERE   fpm.IsInvoice=1  ");
                sb.Append(" and (Company_Name like @Company_Name or fpm.Panel_Code like @Company_Name) ");
                if (Util.GetString(Request.QueryString["SearchType"]) == "9")
                {
                    sb.Append(" and fpm.Payment_mode <> 'CASH'");
                }
                else if (Util.GetString(Request.QueryString["SearchType"]) == "11")
                {
                    sb.Append(" and fpm.Payment_mode='CREDIT'");
                }
                if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
                {
                    sb.Append(" and InvoiceTo =" + InvoicePanelID + " ORDER BY fpm.Employee_ID desc");
                }
                else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
                {
                    sb.Append(" and employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ORDER BY fpm.Employee_ID desc");
                }
                else if (UserInfo.RoleID == 220)
                {
                    sb.Append(" and Panel_ID in(select PanelID from centre_panel where centreID= " + UserInfo.Centre + ") ORDER BY fpm.Company_Name desc");
                }
                else if (Util.GetString(Request.QueryString["SearchType"]) != "0")
                {
                    sb.Append(" and fpm.PanelGroupID=@type1ID ");
                }
                else
                    sb.Append(" ORDER BY fpm.Company_Name");

                  using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Company_Name", string.Format("{0}%", Util.GetString(Request.QueryString["PanelName"]))),
                 new MySqlParameter("@type1ID", Request.QueryString["SearchType"])).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return dt;
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

  }
    private DataTable bindLedgerPanelNew()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
           // if (Request.QueryString["SearchType"] != "7")
           // {
              //  sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)label,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID,'#',fpm.InvoiceCreatedOn,'#',fpm.MonthlyInvoiceType)  value FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
              //  sb.Append(" WHERE (Company_Name like @Company_Name or fpm.Panel_Code like @Company_Name) ");
              //  sb.Append("    AND fpm.Panel_ID=fpm.InvoiceTo ");
             //   if (Request.QueryString["SearchType"] != string.Empty)
               //     sb.Append(" AND cm.type1ID=@type1ID ");
           // }
           // else
          //  {

            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)label,CONCAT(fpm.Panel_ID,'#','PUP','#','7','#',fpm.InvoiceCreatedOn,'#',fpm.MonthlyInvoiceType) value FROM f_panel_master fpm ");
           // sb.Append(" WHERE   fpm.PanelType='B2B' ");
                sb.Append("   where  (fpm.Company_Name like @Company_Name or fpm.Panel_Code like @Company_Name)");
            // }
            //sb.Append("   AND fpm.IsInvoice=1 ");
            sb.Append(" ORDER BY fpm.Company_Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Company_Name", string.Format("{0}%", Util.GetString(Request.QueryString["PanelName"]))),
                 new MySqlParameter("@type1ID", Request.QueryString["SearchType"])).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return dt;
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
private DataTable bindEmployee()
  {
      MySqlConnection con = Util.GetMySqlCon();
      con.Open();
      try
      {
          StringBuilder sb = new StringBuilder();
          sb.Append(" SELECT Employee_ID `id`,CONCAT(Title,'',NAME) `value`  FROM employee_master WHERE IsActive=1 AND NAME LIKE @NAME");
          using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@NAME", string.Format("{0}%", Util.GetString(Request.QueryString["term"])))).Tables[0])
          {
              if (dt.Rows.Count > 0)
                  return dt;
              else
                  return null;
          }
      }
      catch (Exception ex)
      {
          ClassLog cl = new ClassLog();
          cl.errLog(ex);
          return null;
      }
      finally
      {
          con.Close();
          con.Dispose();
      }
  }
private DataTable GetCampTestDetail()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.itemid value,CONCAT(typeName,' # ',Name) label,if(im.subcategoryid='15','Package','Test') type ");
            sb.Append(" ,IFNULL((SELECT get_item_rate(im.`ItemID`,@ReferenceCodeOPD,if(@PrescribeDate <>'',@PrescribeDate,  CURRENT_DATE()),@Panel_Id)),0)Rate ,");
            sb.Append(" IFNULL((SELECT get_item_rate(im.`ItemID`,@PanelID_MRP,if(@PrescribeDate <>'',@PrescribeDateTime,  CURRENT_DATE()),@Panel_Id)),0)MRP ");

            sb.Append(" from f_itemmaster im ");
            sb.Append(" INNER JOIN f_subcategorymaster sub ON sub.SubcategoryID=im.SubcategoryID ");
            sb.Append(" WHERE isActive=1 ");
            if (Request.QueryString["SearchType"] == "1")
                sb.Append(" AND typeName like @TestName ");
            else if (Request.QueryString["SearchType"] == "0")
                sb.Append(" AND im.testcode LIKE @TestCode ");
            else
                sb.Append(" AND typeName like @typeName ");
            sb.Append("  order by label limit 20 ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@Panel_Id", Util.GetInt(Request.QueryString["Panel_Id"]));
                da.SelectCommand.Parameters.AddWithValue("@PanelID_MRP", Util.GetInt(Request.QueryString["PanelID_MRP"]));
                da.SelectCommand.Parameters.AddWithValue("@ReferenceCodeOPD", Util.GetInt(Request.QueryString["ReferenceCodeOPD"]));
                if (Request.QueryString["SearchType"] == "1")
                    da.SelectCommand.Parameters.AddWithValue("@TestName", string.Format("{0}%", Request.QueryString["TestName"]));
                else if (Request.QueryString["SearchType"] == "0")
                    da.SelectCommand.Parameters.AddWithValue("@TestCode", string.Format("%{0}%", Request.QueryString["TestName"]));
                else
                    da.SelectCommand.Parameters.AddWithValue("@typeName", string.Format("%{0}%", Request.QueryString["TestName"]));


               
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}