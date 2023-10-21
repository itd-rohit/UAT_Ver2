using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_Coupon_coupon_master : System.Web.UI.Page
{
    public string approvaltypemaker = "0";
    public string approvaltypereject = "0";
    public string approvaltypestatuschange = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        string dt = Util.GetString(StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM Coupan_approvalright WHERE apprightfor='Coupon' and active=1 AND employeeid=" + UserInfo.ID + " "));
        if (dt != "0" || dt != "")
        {
            if (dt.Contains("Maker"))
            {
                approvaltypemaker = "1";
            }
            if (dt.Contains("Reject"))
            {
                approvaltypereject = "1";
            }
            if (dt.Contains("StatusChange"))
            {
                approvaltypestatuschange = "1";
            }
        }
        calFromDate.StartDate = DateTime.Now;
        if (!IsPostBack)
        {
            txtentrydatefrom.Attributes.Add("readOnly", "readOnly");
            txtentrydateto.Attributes.Add("readOnly", "readOnly");
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Savecoupon(List<couponlist> Allitem, string filename, string filenametype, string filenametypewithcoupon)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            int Couponnameexist = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT count(1) FROM `coupan_master` where UPPER(CoupanName)=@CoupanName",
                                                          new MySqlParameter("@CoupanName", Allitem[0].CouponName.ToUpper())));
            if (Couponnameexist > 0)
            {
                Tranx.Rollback();
                return "2#";
            }
            if (filename != "")
            {
                int Couponnameexist1 = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT count(1) FROM `coupan_code_temp` where filename=@filename ",
                    new MySqlParameter("@filename", filename)));
                if (Couponnameexist1 == 0)
                {
                    Tranx.Rollback();
                    return "8#";
                }
            }
            if (filenametype != "")
            {
                int Couponnameexist1 = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT count(1) FROM `coupan_billtype_temp` where filename=@filenametype ",
                                                               new MySqlParameter("@filenametype", filenametype)));
                if (Couponnameexist1 == 0)
                {
                    Tranx.Rollback();
                    return "13#";
                }
            }
            if (filenametypewithcoupon != "")
            {
                int Couponnameexist2 = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT count(1) FROM `coupan_code_temp_withdata` where filename=@filenametypewithcoupon ",
                                                               new MySqlParameter("@filenametypewithcoupon", filenametypewithcoupon)));
                if (Couponnameexist2 == 0)
                {
                    Tranx.Rollback();
                    return "14#";
                }
            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into coupan_master(CoupanName,CoupanTypeId,CoupanType,CoupanCategory,CoupanCategoryId,ValidFrom,ValidTo,MinBookingAmount,Type,DiscountAmount,DiscountPercentage,IsActive,dtEntry,EntryById,EntryByName,Issuetype,ApplicableFor,IsmultipleCouponApply,IsMultiplePatientCoupon,IsOneTimePatientCoupon,WeekEnd,HappyHours,DaysApplicable,OneCouponOneMobileMultipleBilling) values(@CoupanName,@CoupanTypeId,@CoupanType,@CoupanCategory,@CoupanCategoryId,@ValidFrom,@ValidTo,@MinBookingAmount,@Type,@DiscountAmount,@DiscountPercentage,@IsActive,now(),@EntryById,@EntryByName,@Issuetype,@ApplicableFor,@IsmultipleCouponApply,@IsMultiplePatientCoupon,@IsOneTimePatientCoupon,@WeekEnd,@HappyHours,@DaysApplicable,@OneCouponOneMobileMultipleBilling)",
                        new MySqlParameter("@CoupanName", Allitem[0].CouponName),
                        new MySqlParameter("@CoupanTypeId", Allitem[0].CouponTypeId),
                        new MySqlParameter("@CoupanCategory", Allitem[0].CouponCategory),
                        new MySqlParameter("@CoupanCategoryId", Allitem[0].CouponCategoryId),
                        new MySqlParameter("@CoupanType", Allitem[0].CouponType),
                        new MySqlParameter("@ValidFrom", Convert.ToDateTime(Allitem[0].fromdate)),
                        new MySqlParameter("@ValidTo", Convert.ToDateTime(Allitem[0].todate)),
                        new MySqlParameter("@MinBookingAmount", Allitem[0].minimumamount),
                        new MySqlParameter("@Type", Allitem[0].billtype),
                        new MySqlParameter("@DiscountAmount", Allitem[0].discountamount),
                        new MySqlParameter("@DiscountPercentage", Allitem[0].discountpercent),
                        new MySqlParameter("@IsActive", 1),
                        new MySqlParameter("@EntryById", UserInfo.ID),
                        new MySqlParameter("@EntryByName", UserInfo.LoginName),
                        new MySqlParameter("@Issuetype", Allitem[0].Issuefor),
                        new MySqlParameter("@ApplicableFor", Allitem[0].ApplicableFor.TrimEnd(',')),
                        new MySqlParameter("@IsmultipleCouponApply", Allitem[0].IsmultipleCouponApply),
                        new MySqlParameter("@IsMultiplePatientCoupon", Allitem[0].IsMultiplePatientCoupon),
                        new MySqlParameter("@IsOneTimePatientCoupon", Allitem[0].IsOneTimePatientCoupon),
                        new MySqlParameter("@WeekEnd", Allitem[0].WeekEnd),
                        new MySqlParameter("@HappyHours", Allitem[0].HappyHours),
                        new MySqlParameter("@DaysApplicable", Allitem[0].DaysApplicable.TrimEnd(',')),
                        new MySqlParameter("@OneCouponOneMobileMultipleBilling", Allitem[0].OneCouponOneMobileMultipleBilling));
            string couponid = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT IFNULL(MAX(CoupanId),1) FROM `coupan_master`"));
            if (Allitem[0].TempId != "")
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(1) FROM Voucher_Document WHERE TempID=@TempID ",
                                                    new MySqlParameter("@TempID", Allitem[0].TempId)));
                if (count != 0)
                {
                    sb = new StringBuilder();
                    sb.Append("UPDATE Voucher_Document SET CoupanId=@couponid WHERE TempID IN(" + Allitem[0].TempId + ")");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@couponid", couponid));
                }
            }
            List<string> Rows = new List<string>();
            StringBuilder sCommand = new StringBuilder("INSERT into coupan_applicable_panel(CoupanId,panel_id) values ");
            for (int i = 0; i < Allitem[0].centers.Split(',').Length; i++)
            {
                Rows.Add(string.Format("({0},{1})",
                                       couponid,
                                       Allitem[0].centers.Split(',')[i]
                                       ));
            }
            sCommand.Append(string.Join(",", Rows));
            sCommand.Append(";");
            using (MySqlCommand myCmd = new MySqlCommand(sCommand.ToString(), con, Tranx))
            {
                myCmd.CommandType = CommandType.Text;
                myCmd.ExecuteNonQuery();
            }
            if (Allitem[0].Issuefor == "UHIDWithCoupan" || Allitem[0].Issuefor == "MobileWithCoupan")
            {
                sb = new StringBuilder();
                sb.Append("insert into coupan_code(CoupanId,CoupanCode,IssueType,IssueValue)  ");
                sb.Append("Select @couponid,coupan_code,IssueType,IssueValue from coupan_code_temp_withdata where filename=@filenametypewithcoupon ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString().Trim(),
                            new MySqlParameter("@filenametypewithcoupon", filenametypewithcoupon),
                            new MySqlParameter("@couponid", couponid));
            }
            else
            {
                StringBuilder Cd = new StringBuilder();
                if (filename != "")
                {
                    Cd.Append("insert into coupan_code(CoupanId,CoupanCode,issuetype) ");
                    Cd.Append("Select '" + couponid + "',coupan_code,'" + Allitem[0].Issuefor + "' from  coupan_code_temp where filename='" + filename + "' ");
                }
                else if (Allitem[0].CoupanCode != "")
                {
                    Cd.Append("insert into coupan_code(CoupanId,CoupanCode,issuetype) values ");
                    for (int i = 0; i < Allitem[0].CoupanCode.Split(',').Length; i++)
                    {
                        string Couponcodeexist = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT cm.CoupanName FROM `coupan_code` cc INNER JOIN coupan_master cm ON cm.coupanid=cc.coupanid WHERE Upper(cc.CoupanCode)=@CoupanCode ",
                                                                            new MySqlParameter("@CoupanCode", Allitem[0].CoupanCode.Split(',')[i].Split('#')[0].ToUpper())));
                        if (Couponcodeexist != "")
                        {
                            Tranx.Rollback();
                            return "3#" + Couponcodeexist;
                        }
                        Cd.Append(" (");
                        Cd.Append("'" + couponid + "',");
                        Cd.Append("'" + Allitem[0].CoupanCode.Split(',')[i].Split('#')[0] + "','" + Allitem[0].Issuefor + "'");
                        Cd.Append(" ),");
                    }
                }
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Cd.ToString().Trim().TrimEnd(','));

                // UHID
                if (Allitem[0].Issuefor == "UHID")
                {
                    Rows.Clear();
                    StringBuilder sUHID = new StringBuilder("insert into coupan_Billtype(CoupanId,Type,Value) values ");
                    if (filenametype != "")
                    {
                        using (DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "SELECT value FROM coupan_billtype_temp where filename=@filenametype and type='UHID' ",
                                                    new MySqlParameter("@filenametype", filenametype)).Tables[0])
                        {
                            foreach (DataRow dw in dt.Rows)
                            {
                                int uhidexist = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select count(1) from patient_master pm where pm.patient_id=@patient_id",
                                                                        new MySqlParameter("@patient_id", dw["value"].ToString())));
                                if (uhidexist == 0)
                                {
                                    Tranx.Rollback();
                                    return "11#" + "UHID Not Exist :" + dw["value"].ToString();
                                }
                                Rows.Add(string.Format("({0},'{1}','{2}')",
                                           couponid,
                                           "UHID",
                                           dw["value"].ToString()
                                           ));
                            }
                        }
                    }
                    else if (Allitem[0].UHID != "")
                    {
                        for (int i = 0; i < Allitem[0].UHID.Split(',').Length; i++)
                        {
                            int uhidexist = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select count(1) from patient_master pm where pm.patient_id=@patient_id ",
                                                                    new MySqlParameter("@patient_id", Allitem[0].UHID.Split(',')[i].Split('#')[0])));
                            if (uhidexist == 0)
                            {
                                Tranx.Rollback();
                                return "11#" + "UHID Not Exist :" + Allitem[0].UHID.Split(',')[i].Split('#')[0];
                            }
                            Rows.Add(string.Format("({0},'{1}','{2}')",
                                       couponid,
                                       "UHID",
                                       Allitem[0].UHID.Split(',')[i].Split('#')[0]
                                       ));
                        }
                    }
                    sUHID.Append(string.Join(",", Rows));
                    sUHID.Append(";");
                    using (MySqlCommand myCmd = new MySqlCommand(sUHID.ToString(), con, Tranx))
                    {
                        myCmd.CommandType = CommandType.Text;
                        myCmd.ExecuteNonQuery();
                    }
                }
                // Mobile
                if (Allitem[0].Issuefor == "Mobile")
                {
                    Rows.Clear();
                    StringBuilder sMobile = new StringBuilder("insert into coupan_Billtype(CoupanId,Type,Value) values ");
                    if (filenametype != "")
                    {
                        using (DataTable dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "SELECT value FROM coupan_billtype_temp where filename=@filenametype and type='Mobile' ",
                                                    new MySqlParameter("@filenametype", filenametype)).Tables[0])
                        {
                            foreach (DataRow dw in dt.Rows)
                            {
                                int mobilelength = Util.GetInt(dw["value"].ToString().Length);
                                if (mobilelength != 10)
                                {
                                    Tranx.Rollback();
                                    return "12#" + "Incorrect Mobile No :" + dw["value"].ToString();
                                }
                                Rows.Add(string.Format("({0},'{1}','{2}')",
                                          couponid,
                                          "Mobile",
                                          dw["value"].ToString()
                                          ));
                            }
                        }
                    }
                    else if (Allitem[0].Mobile != "")
                    {
                        for (int i = 0; i < Allitem[0].Mobile.Split(',').Length; i++)
                        {
                            int mobilelength = Util.GetInt(Allitem[0].Mobile.Split(',')[i].Split('#')[0].Length);
                            if (mobilelength < 10)
                            {
                                Tranx.Rollback();
                                return "12#" + "Incorrect Mobile No :" + Allitem[0].Mobile.Split(',')[i].Split('#')[0];
                            }
                            Rows.Add(string.Format("({0},'{1}','{2}')",
                                     couponid,
                                     "Mobile",
                                     Allitem[0].Mobile.Split(',')[i].Split('#')[0]
                                     ));
                        }
                    }
                    sMobile.Append(string.Join(",", Rows));
                    sMobile.Append(";");

                    using (MySqlCommand myCmd = new MySqlCommand(sMobile.ToString(), con, Tranx))
                    {
                        myCmd.CommandType = CommandType.Text;
                        myCmd.ExecuteNonQuery();
                    }
                }
                
            }
            if (Allitem[0].billtype == "2")
            {
                Rows.Clear();
                StringBuilder sTestWise = new StringBuilder("INSERT INTO Coupan_TestWise(coupanid,subcategoryid,itemid,discper,DiscAmount) VALUES ");
                foreach (var data in Allitem)
                {
                    Rows.Add(string.Format("({0},{1},{2},'{3}','{4}')",
                                       Util.GetInt(couponid),
                                       Util.GetInt(data.subcategoryids),
                                       Util.GetInt(data.items),
                                       Util.GetDouble(data.discountpercent),
                                       Util.GetDouble(data.discountamount)
                                       ));
                }
                sTestWise.Append(string.Join(",", Rows));
                sTestWise.Append(";");
                using (MySqlCommand myCmd = new MySqlCommand(sTestWise.ToString(), con, Tranx))
                {
                    myCmd.CommandType = CommandType.Text;
                    myCmd.ExecuteNonQuery();
                }
            }
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + ex.ToString();
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindcentermodal(string CouponID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CouponIDTags = CouponID.Split(',');
            string[] CouponIDParamNames = CouponIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CouponIDClause = string.Join(", ", CouponIDParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT Concat(pm.panel_code,'~',pm.company_name)Centre FROM `coupan_applicable_panel` CAC INNER JOIN f_panel_master pm ON CAC.panel_id=pm.panel_id WHERE CAC.CoupanID IN({0})", CouponIDClause), con))
            {
                for (int i = 0; i < CouponIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(CouponIDParamNames[i], CouponIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
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

    [WebMethod(EnableSession = true)]
    public static string bindtestmodal(string CouponID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CouponIDTags = CouponID.Split(',');
            string[] CouponIDParamNames = CouponIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CouponIDClause = string.Join(", ", CouponIDParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT Concat(fi.TestCode,'~',fi.typename)typename,ct.discper,ct.discamount FROM f_itemmaster fi INNER JOIN coupan_testwise ct ON ct.itemid=fi.itemid WHERE coupanid IN({0})", CouponIDClause), con))
            {
                for (int i = 0; i < CouponIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(CouponIDParamNames[i], CouponIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
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

    [WebMethod(EnableSession = true)]
    public static string bindtypemodal(string CouponID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CouponIDTags = CouponID.Split(',');
            string[] CouponIDParamNames = CouponIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CouponIDClause = string.Join(", ", CouponIDParamNames);
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT `value`,`type` from coupan_Billtype where coupanid IN({0})", CouponIDClause), con))
            {
                for (int i = 0; i < CouponIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(CouponIDParamNames[i], CouponIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
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

    [WebMethod(EnableSession = true)]
    public static string bindtypemodalwithdata(string CouponID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT coupancode,issuetype,issuevalue FROM `coupan_code` where coupanid =@CouponID",
                                                           new MySqlParameter("@CouponID", CouponID)).Tables[0]);
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

    [WebMethod(EnableSession = true)]
    public static string binddepartmenttype()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT CONCAT(subcategoryid,'#',NAME)subcategoryid,NAME FROM f_subcategorymaster"));
    }

    [WebMethod(EnableSession = true)]
    public static string bindtest(string scid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CouponIDTags = scid.Split(',');
            string[] CouponIDParamNames = CouponIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CouponIDClause = string.Join(", ", CouponIDParamNames);

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT CONCAT(IM.itemid,'#',IM.subcategoryid,'#',IM.Testcode,'#',IM.typename,'#',SCM.Name) itemid,Concat(IM.Testcode,'~',IM.typename)typename FROM f_itemmaster IM INNER JOIN f_subcategoryMaster SCM ON IM.`SubCategoryID`=SCM.SubcategoryId  WHERE IM.subcategoryid IN({0}) AND IF(IM.subcategoryid=15,DiscountApplicable=1,1=1) ORDER BY typename", CouponIDClause), con))
            {
                for (int i = 0; i < CouponIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(CouponIDParamNames[i], CouponIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
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

    [WebMethod(EnableSession = true)]
    public static string InsertCtype(string CouponType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into CoupanType_master(CoupanType,CreatedById,CreatedBy,CreatedDateTime)values(@CoupanType,@CreatedById,@CreatedBy,now())",
                         new MySqlParameter("@CoupanType", CouponType),
                         new MySqlParameter("@CreatedById", UserInfo.ID),
                         new MySqlParameter("@CreatedBy", UserInfo.LoginName));
            Tranx.Commit();
            int ID = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));
            return JsonConvert.SerializeObject(new { status = true, ID = ID });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string InsertCCategory(string Couponcategory)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "insert into CoupanCategory_master(CoupanCategory,CreatedById,CreatedBy,CreatedDateTime)values(@CoupanCategory,@CreatedById,@CreatedBy,now())",
                        new MySqlParameter("@CoupanCategory", Couponcategory),
                        new MySqlParameter("@CreatedById", UserInfo.ID),
                        new MySqlParameter("@CreatedBy", UserInfo.LoginName)
            );
            int ID = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, ID = ID });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindcoupontypedb()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,CoupanType FROM CoupanType_master"));
    }

    [WebMethod(EnableSession = true)]
    public static string bindcouponcategorydb()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,CoupanCategory FROM CoupanCategory_master"));
    }

    [WebMethod(EnableSession = true)]
    public static string bindtypedb()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT DISTINCT type1id ID,type1 TEXT FROM centre_master WHERE Type1ID!=7 AND Type1ID!=1 ORDER BY Type1ID "));
    }

    [WebMethod(EnableSession = true)]
    public static string bindtable()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT `TYPE` ctt,CASE WHEN cm.isactive=1 THEN 'Active' ELSE 'DeActive' END isactive, cm.coupanid,IFNULL(GROUP_CONCAT(DISTINCT cc.LedgertransactionNo),'')LedgertransactionNo,cm.coupantypeid,cm.coupanname,cm.coupantype,cm.coupancategory,DATE_FORMAT(cm.validfrom,'%d-%b-%Y')validfrom,DATE_FORMAT(cm.validto,'%d-%b-%Y')validto,cm.minbookingamount,cm.issuetype,cm.Approved,");
        sb.Append("CASE WHEN TYPE=1 THEN 'Total Bill' ELSE 'Test Wise' END TYPE,if(type=1,cm.discountamount,0)discountamount,if(type=1,cm.discountpercentage,0)discountpercentage,ifnull(cm.ApplicableFor,'')ApplicableFor,CASE WHEN IsMultipleCouponApply=1 THEN 'Yes' ELSE 'NO' END IsMultipleCouponApply, ");
        sb.Append(" IF(IsMultiplePatientCoupon=1,'Yes','No')MultiplePatientCoupon,IF(IsOneTimePatientCoupon=1,'Yes','No')OneTimePatientCoupon,CASE WHEN WeekEnd=1 THEN 'WeekEnd' WHEN HappyHours=1 THEN 'HappyHours' ELSE '' END WeekEnd,DaysApplicable FROM coupan_master cm  ");
        sb.Append(" INNER JOIN coupan_code cc ON cc.coupanid=cm.coupanid   GROUP BY cm.coupanid order by cm.validfrom desc");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string removerow(string id, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Type == "0")
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from Coupan_TestWise WHERE coupanid=@id ",
                            new MySqlParameter("@id", id));
            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from coupan_applicable_panel WHERE coupanid=@id",
                        new MySqlParameter("@id", id));
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from Coupan_master WHERE coupanid=@id",
                        new MySqlParameter("@id", id));
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from coupan_code WHERE coupanid=@id ",
                        new MySqlParameter("@id", id));
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindCentreLoad(string Type1, string btype, string StateID, string ZoneId, string tagprocessinglab)
    {
        string qry = "SELECT CentreID,CONCAT(CentreID,'#',zone,'#',state,'#',city,'#')CentreID1,Concat(centrecode,'~',Centre)Centre,type1 FROM centre_master cm where isactive=1";
        if (ZoneId != "")
            qry += " AND BusinessZoneID IN(" + ZoneId + ")";
        if (StateID != "")
            qry += "  AND cm.StateID IN(" + StateID + ")";
        if (Type1 != "")
            qry += "  AND cm.Type1Id IN(" + Type1 + ")";
        if (btype != "0")
            qry += " and coco_foco='" + btype + "'";
        if (tagprocessinglab != "0" && tagprocessinglab != "-1" && tagprocessinglab != "null")
            qry += " and TagProcessingLabID='" + tagprocessinglab + "'";
        return JsonConvert.SerializeObject(StockReports.GetDataTable(qry));
    }

    [WebMethod]
    public static string bindtagprocessinglabLoad(string Type1, string btype, string StateID, string ZoneId)
    {
        string qry = "SELECT CentreID,CONCAT(CentreID,'#',zone,'#',state,'#',city,'#')CentreID1,Concat(centrecode,'~',Centre)Centre,type1 FROM centre_master cm where isactive=1";
        if (ZoneId != "")
            qry += " AND BusinessZoneID IN(" + ZoneId + ")";
        if (StateID != "")
            qry += "  AND cm.StateID IN(" + StateID + ")";
        if (btype != "0")
            qry += " and coco_foco='" + btype + "'";
        qry += " AND cm.CentreID=cm.TagProcessingLabID order by Centre ";
        return JsonConvert.SerializeObject(StockReports.GetDataTable(qry));
    }

    [WebMethod]
    public static string bindCentreLoadinner(string centreid, string btype)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CentreIDTags = centreid.Split(',');
            string[] CentreIDParamNames = CentreIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreIDClause = string.Join(", ", CentreIDParamNames);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT pm.Panel_ID CentreID,concat(pm.`Panel_code`,'~',pm.company_name)Centre FROM centre_panel cp INNER JOIN f_panel_master pm ON cp.`PanelID`=pm.Panel_ID ");
            sb.Append(" and pm.`IsActive`=1 WHERE cp.centreid  IN ({0}) AND pm.PanelType='Centre' ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), CentreIDClause), con))
            {
                for (int i = 0; i < CentreIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(CentreIDParamNames[i], CentreIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    return JsonConvert.SerializeObject(dt);
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

    [WebMethod]
    public static string BindOldPatient(string searchmobile)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string mobile = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select ifnull(Mobile,0) from patient_master where Mobile=@Mobile",
                                                       new MySqlParameter("@Mobile", searchmobile)));
            if (mobile == null || mobile == "")
                mobile = "0";
            else
                mobile = "1";
            return mobile;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindOldPatientuhid(string searchuhid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string uhid = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select ifnull(Patient_ID,0) from patient_master where Patient_ID=@Patient_ID",
                                                     new MySqlParameter("@Patient_ID", searchuhid)));
            if (uhid == null || uhid == "")
                uhid = "0";
            else
                uhid = "1";
            return uhid;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string UpdateStatus(string id, string status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE coupan_master SET IsActive=@status WHERE coupanid=@id ",
                        new MySqlParameter("@status", status),
                        new MySqlParameter("@id", id));
            return status;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return status;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string checkfilesaved(string filename)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select count(1) from coupan_code_temp where filename=@filename",
                                              new MySqlParameter("@filename", filename)));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public class couponlist
    {
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string minimumamount { get; set; }
        public string discountpercent { get; set; }
        public string discountamount { get; set; }
        public string billtype { get; set; }
        public string centers { get; set; }
        public string subcategoryids { get; set; }
        public string items { get; set; }
        public string CouponName { get; set; }
        public string CouponTypeId { get; set; }
        public string CouponType { get; set; }
        public string CouponCategoryId { get; set; }
        public string CouponCategory { get; set; }
        public string CoupanCode { get; set; }
        public string TempId { get; set; }
        public string Issuefor { get; set; }
        public string Mobile { get; set; }
        public string UHID { get; set; }
        public string ApplicableFor { get; set; }
        public string IsmultipleCouponApply { get; set; }
        public int IsMultiplePatientCoupon { get; set; }
        public int IsOneTimePatientCoupon { get; set; }
        public int WeekEnd { get; set; }
        public int HappyHours { get; set; }
        public string DaysApplicable { get; set; }
        public int OneCouponOneMobileMultipleBilling { get; set; }
    }
}