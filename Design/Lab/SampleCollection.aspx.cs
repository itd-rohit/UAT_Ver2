using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI.WebControls;


public partial class Design_Lab_SampleCollection : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            AllLoad_Data.getCurrentDate(txtToDate, txtFormDate);
            BindMethod();

        }
    }
    private void BindMethod()
    {
        string roleid = UserInfo.RoleID.ToString();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT em.Name,em.Employee_ID Employee_ID FROM f_login f  INNER JOIN employee_master em ON em.Employee_ID=f.EmployeeID");
            if (roleid == "214")
            {
                sb.Append(" and em.Employee_ID=@Employee_ID");
            }
            sb.Append(" AND f.roleid IN('9','211','214','11') and f.centreid=@Centre GROUP BY `Employee_ID` ORDER BY Name ");


            ddlUser.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@Employee_ID", UserInfo.ID), new MySqlParameter("@Centre", UserInfo.Centre)).Tables[0];
            ddlUser.DataTextField = "Name";
            ddlUser.DataValueField = "Employee_ID";
            ddlUser.DataBind();

            if (roleid != "214")
                ddlUser.Items.Insert(0, new ListItem("ALL User", "All"));
            sb = new StringBuilder();



            ddlCentreAccess.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select distinct cm.CentreID,CONCAT(cm.CentreCode,'-',cm.Centre) as Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@Centre ) or cm.CentreID = @Centre) and cm.isActive=1 order by cm.CentreCode  ",
             new MySqlParameter("@Centre", UserInfo.Centre)).Tables[0];
            ddlCentreAccess.DataTextField = "Centre";
            ddlCentreAccess.DataValueField = "CentreID";
            ddlCentreAccess.DataBind();
            ddlCentreAccess.Items.Insert(0, new ListItem("ALL Centre", "ALL"));

            sb = new StringBuilder();
            sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
            sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
            sb.Append(" aND ot.IsActive=1 order by ot.Name");
            ddlDepartment.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("All Department", ""));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindPanel(object CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CentreIDTags = CentreID.ToString().Split(',');
            string[] CentreIDParamNames = CentreIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreIDClause = string.Join(", ", CentreIDParamNames);
            StringBuilder sb = new StringBuilder();
            sb.Append(" Select Panel_ID,Company_Name from f_panel_master where TagProcessingLabID in({0}) ");
            sb.Append(" and IsActive=1 order by Company_Name");
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
    public class sampleSearchType
    {
        public string SearchType { get; set; }
    }

    public static List<sampleSearchType> SearchType()
    {
        List<sampleSearchType> collectionSearchType = new List<sampleSearchType>();
        collectionSearchType.Add(new sampleSearchType() { SearchType = "plo.BarcodeNo" });
        collectionSearchType.Add(new sampleSearchType() { SearchType = "plo.LedgertransactionNo" });
        collectionSearchType.Add(new sampleSearchType() { SearchType = "lt.PName" });
        return collectionSearchType;
    }
    [WebMethod]
    public static string SearchSampleCollection(object searchdata)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Session Expired,Please Login" });
        }
        List<SampleCollection> SampleCollection = new JavaScriptSerializer().ConvertToType<List<SampleCollection>>(searchdata);
        HashSet<string> SearchTypes = new HashSet<string>(SampleCollection.Select(s => s.SearchType));
        if (SearchType().Where(m => SearchTypes.Contains(m.SearchType)).Count() == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }

        if (SampleStatusData().Any(s => s.Contains(SampleCollection[0].SampleStatus)) == false)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }
        StringBuilder sbQuery = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sbQuery.Append(" SELECT plo.ledgertransactionID, plo.IsSampleCollected,group_concat(distinct plo.BarcodeNo) BarcodeNo,CONCAT(lt.PName,'/',lt.age) as PName,plo.ledgerTransactionNO,  ");
            sbQuery.Append(" lt.panelname PanelName FROM  patient_labinvestigation_opd plo  ");
            sbQuery.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgerTransactionID=plo.ledgerTransactionID  AND plo.IsActive=1 ");
            if (SampleCollection[0].UserID != "All")
                sbQuery.Append(" AND lt.`CreatedByID`=@UserID ");
            if (SampleCollection[0].Department != string.Empty)
                sbQuery.Append(" INNER JOIN investigation_observationtype iot ON plo.investigation_ID=iot.investigation_ID ");
            sbQuery.Append(" INNER JOIN f_panel_master fpm on fpm.panel_id=lt.panel_Id ");
            if (SampleCollection[0].CentreID != "ALL")
                sbQuery.Append("  AND lt.CentreID=@CentreID ");
            else
                sbQuery.Append("  AND ( lt.CentreID in ( SELECT ca.CentreAccess FROM  centre_access ca where ca.Centreid=@AccessCentreID )  or lt.CentreID=@AccessCentreID) ");
            if (SampleCollection[0].PanelID != "ALL" && SampleCollection[0].PanelID != "0")
                sbQuery.Append("  AND fpm.panel_id=@PanelID ");
            switch (SampleCollection[0].SampleStatus)
            {
                case "N": sbQuery.Append(" AND plo.IsSampleCollected='N' AND plo.IsReporting=1 ");
                    break;
                case "Y": sbQuery.Append(" AND plo.IsSampleCollected='Y' AND plo.IsReporting=1 ");
                    break;
                case "S": sbQuery.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
                    break;
                case "R": sbQuery.Append(" AND plo.IsSampleCollected='R'  ");
                    break;
            }
            if (SampleCollection[0].SearchValue.Trim() != string.Empty)
                sbQuery.AppendFormat(" AND {0} like @SearchValue ", SampleCollection[0].SearchType);
            if (SampleCollection[0].Department != string.Empty)
                sbQuery.Append(" AND iot.ObservationType_ID=@ObservationType_ID ");
           // if (SampleCollection[0].SearchValue.Trim() == string.Empty)
                sbQuery.Append(" AND lt.date >=@fromDate AND lt.date <=@toDate ");
            sbQuery.Append("  AND plo.Reporttype <> 5 ");
            sbQuery.Append("  GROUP BY plo.ledgertransactionNo  ");
            sbQuery.Append(" order by plo.`BarcodeNo` ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(sbQuery.ToString(), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@UserID", SampleCollection[0].UserID);
                da.SelectCommand.Parameters.AddWithValue("@AccessCentreID", UserInfo.Centre);
                da.SelectCommand.Parameters.AddWithValue("@CentreID", SampleCollection[0].CentreID);
                da.SelectCommand.Parameters.AddWithValue("@PanelID", SampleCollection[0].PanelID);
                da.SelectCommand.Parameters.AddWithValue("@ObservationType_ID", SampleCollection[0].Department);
                da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(SampleCollection[0].FormDate).ToString("yyyy-MM-dd"), ' ', SampleCollection[0].FromTime));
                da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(SampleCollection[0].ToDate).ToString("yyyy-MM-dd"), ' ', SampleCollection[0].ToTime));
                da.SelectCommand.Parameters.AddWithValue("@SearchValue",string.Format("%{0}%", SampleCollection[0].SearchValue));
                da.SelectCommand.Parameters.Add("@SearchType", MySqlDbType.Text).Value = SampleCollection[0].SearchType;
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(new { status = true, response = dt });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SearchInvestigation(string LabNo, string SmpleColl, string Department, string sinNo)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Session Expired" });
        }
        StringBuilder sbQuery = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sbQuery.Append(" SELECT  IFNULL(if(im.IsLMPRequired=0,(SELECT GROUP_CONCAT(CAST(fieldid AS CHAR)) FROM investigation_requiredfield WHERE investigationID=im.`Investigation_Id` and ShowOnSampleCollection=1),''),'') RequiredFields, ");
            sbQuery.Append("  im.reporttype, plo.SampleQty, plo.HistoCytoSampleDetail, im.reporttype reporttype1, plo.patient_id,plo.IsSampleCollectedByPatient,");
            sbQuery.Append(" plo.SampleCollector,date_format(SampleCollectionDate,'%d-%b-%Y %h:%i %p') colldate,plo.SampleReceiver,date_format(SampleReceiveDate,'%d-%b-%Y %h:%i %p') recdate, ");
            sbQuery.Append(" case when plo.IsSampleCollected='S' then  'bisque' when plo.IsSampleCollected='Y' then 'lightgreen'  when plo.IsSampleCollected='R' then 'pink' else 'white' end rowcolor, ");
            sbQuery.Append(" lt.PName,plo.Test_ID,plo.IsSampleCollected, im.name,plo.`SampleTypeID`,plo.`SampleTypeName`,plo.`BarcodeNo`,plo.`LedgerTransactionNo`,pnl.SampleRecollectAfterReject,im.SampleQty MasterSampleQty,im.SampleRemarks, ");
            sbQuery.Append(" IF(IFNULL(plo.SampleTypeID,0)=0,   ");
            sbQuery.Append(" IFNULL((SELECT CONCAT(ist.SampleTypeID ,'^',ist.SampleTypeName) FROM investigations_SampleType ist   ");
            sbQuery.Append("  WHERE ist.Investigation_Id =plo.Investigation_ID ORDER BY ist.isDefault DESC,ist.SampleTypeName LIMIT  1),'1|')  ");
            sbQuery.Append(" ,CONCAT(plo.`SampleTypeID`,'|',plo.`SampleTypeName`))  SampleID,    ");
            sbQuery.Append(" GROUP_CONCAT(DISTINCT CONCAT(inv_smpl.SampleTypeID,'|',inv_smpl.SampleTypeName)ORDER BY  inv_smpl.SampleTypeName SEPARATOR '$')SampleTypes,IFNULL(lt.Interface_companyName,'')Interface_companyName,    ");
            if (SmpleColl == "N")
                sbQuery.Append(" (SELECT IFNULL(color,'') FROM sampletype_master WHERE id=(SELECT SampleTypeId FROM investigations_SampleType WHERE Investigation_id=im.`Investigation_Id` AND IsDefault=1  order by SampleTypeId LIMIT 1))ColorCode ");
            else
                sbQuery.Append(" (SELECT IFNULL(color,'') FROM sampletype_master WHERE id=(SELECT SampleTypeId FROM investigations_SampleType WHERE Investigation_id=plo.`SampleTypeID` LIMIT 1))ColorCode ");
            sbQuery.Append(" ,lt.BarCodePrintedType, lt.setOfBarCode,lt.BarCodePrintedCentreType,lt.BarCodePrintedHomeColectionType FROM `patient_labinvestigation_opd` plo ");
            sbQuery.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgerTransactionID=plo.ledgerTransactionID   AND plo.`LedgerTransactionNo`=@LedgerTransactionNo AND plo.reporttype <> 5 ");
            sbQuery.Append(" INNER JOIN f_panel_master pnl  ON lt.Panel_ID=pnl.Panel_ID ");
            sbQuery.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` ");
            if (Department != string.Empty)
                sbQuery.Append(" INNER JOIN investigation_observationtype iot on iot.Investigation_ID=plo.Investigation_ID AND iot.ObservationType_ID=@ObservationType_ID ");
            sbQuery.Append(" LEFT JOIN `investigations_SampleType` inv_smpl  ");
            sbQuery.Append(" ON inv_smpl.`Investigation_ID`=im.`Investigation_Id` ");
            if (sinNo.Trim() != string.Empty)
                sbQuery.Append(" WHERE plo.`barcodeno` IN({0}) ");
            else
                sbQuery.Append(" WHERE plo.`LedgerTransactionNo`=@LedgerTransactionNo  ");
            sbQuery.Append(" AND plo.IsReporting=1 AND plo.IsActive=1 ");
            if (SmpleColl != string.Empty)
                sbQuery.Append(" AND plo.IsSampleCollected=@IsSampleCollected ");
            sbQuery.Append("  GROUP BY plo.LedgerTransactionNo,plo.Investigation_ID order by plo.SampleTypeId  ");
            string[] BarcodeTags = String.Join(",", sinNo).Split(',');
            string[] BarcodeParamNames = BarcodeTags.Select((s, i) => "@tag" + i).ToArray();
            string BarcodeClause = string.Join(", ", BarcodeParamNames);
           // System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\KOLL.TXT", sbQuery.ToString());
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sbQuery.ToString(), BarcodeClause), con))
            {
                for (int i = 0; i < BarcodeParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(BarcodeParamNames[i], BarcodeTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionNo", LabNo);
                da.SelectCommand.Parameters.AddWithValue("@ObservationType_ID", Department);
                da.SelectCommand.Parameters.AddWithValue("@IsSampleCollected", SmpleColl);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(new { status = true, response = dt });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string ChangeSampleTypeColor(string SampleTypeId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select IFNULL(color,'')color from sampleType_master where id=@SampleTypeId",
               new MySqlParameter("@SampleTypeId", SampleTypeId)));
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
    public class sampleCollection
    {
        public int Test_ID { get; set; }
        public string SampleTypeID { get; set; }
        public string SampleTypeName { get; set; }
        public int ReportType { get; set; }
        public string HistoCytoSampleDetail { get; set; }
        public string BarcodeNo { get; set; }
        public string Interface_companyName { get; set; }
        public string LedgertransactionNo { get; set; }
        public int IsSampleCollectedByPatient { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string saveSamplecollection(List<sampleCollection> data)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(2);
        int ReqCount = MT.GetIPCount(2);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            for (int i = 0; i < data.Count; i++)
            {
				//System.IO.File.WriteAllText(@"D:\Lims 6.0\live_Code\Mdrc\ErrorLog\21-Dec-2020\uikj1.txt","SELECT COUNT(1) FROM patient_labinvestigation_opd where `LedgerTransactionNo` <> @LedgerTransactionNo AND BarcodeNo=@BarcodeNo   ");
                int a = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd where `LedgerTransactionNo` <> @LedgerTransactionNo AND BarcodeNo=@BarcodeNo   ",
                   new MySqlParameter("@LedgerTransactionNo", data[i].LedgertransactionNo.Trim()),
                   new MySqlParameter("@BarcodeNo", data[i].BarcodeNo.Trim())));
                if (a > 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "BarcodeNo Already Exist" });
                }
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE patient_labinvestigation_opd set IsSampleCollectedByPatient=@IsSampleCollectedByPatient,IsSampleCollected='S',SampleCollector=@SampleCollector,SampleCollectionBy=@SampleCollectionBy,SampleCollectionDate=NOW(),SampleTypeID=@SampleTypeID,SampleTypeName=@SampleTypeName,HistoCytoSampleDetail=@HistoCytoSampleDetail,BarcodeNo=@BarcodeNo,Barcode_Group=@Barcode_Group WHERE Test_ID=@Test_ID AND IsSampleCollected !='S' ");//,BarcodeNo=@BarcodeNo,Barcode_Group=@Barcode_Group
				//System.IO.File.WriteAllText(@"D:\Lims 6.0\live_Code\Mdrc\ErrorLog\21-Dec-2020\uikj.txt",sb.ToString());
                int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@SampleCollector", UserInfo.LoginName),
                     new MySqlParameter("@BarcodeNo", data[i].BarcodeNo.Trim()), new MySqlParameter("@Barcode_Group", data[i].BarcodeNo.Trim()),
                     new MySqlParameter("@SampleCollectionBy", UserInfo.ID), new MySqlParameter("@Test_ID", data[i].Test_ID),
                     new MySqlParameter("@SampleTypeID", data[i].SampleTypeID), new MySqlParameter("@SampleTypeName", data[i].SampleTypeName),
                     new MySqlParameter("@HistoCytoSampleDetail", data[i].HistoCytoSampleDetail),
                     new MySqlParameter("@IsSampleCollectedByPatient", data[i].IsSampleCollectedByPatient));
                sb = new StringBuilder();
                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE patient_labinvestigation_opd SET MacStatus=0 WHERE MacStatus=2 AND Test_ID=@Test_ID",
                //   new MySqlParameter("@Test_ID", data[i].Test_ID));
                if (cnt > 0)
                {
                    sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                    sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Sample Collected (',ItemName,')'),@ID,@LoginName,IPAddress,@Centre, ");
                    sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@ID", UserInfo.ID),
                        new MySqlParameter("@LoginName", UserInfo.LoginName), new MySqlParameter("@IPAddress", StockReports.getip()),
                        new MySqlParameter("@Centre", UserInfo.Centre), new MySqlParameter("@Test_ID", data[i].Test_ID));
                }
                if (Resources.Resource.SRARequired == "1")
                {
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,testID) ");
                    sb.Append(" values(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,@dtLogisticReceive,@LogisticReceiveDate,@LogisticReceiveBy,@Test_ID);");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@BarcodeNo", data[i].BarcodeNo.Trim()),
                        new MySqlParameter("@FromCentreID", UserInfo.Centre), new MySqlParameter("@ToCentreID", UserInfo.Centre),
                        new MySqlParameter("@DispatchCode", ""), new MySqlParameter("@Qty", 1),
                        new MySqlParameter("@EntryBy", UserInfo.ID),
                        new MySqlParameter("@STATUS", "Received at Hub"), new MySqlParameter("@dtLogisticReceive", DateTime.Now),
                        new MySqlParameter("@LogisticReceiveDate", DateTime.Now), new MySqlParameter("@LogisticReceiveBy", UserInfo.ID),
                        new MySqlParameter("@Test_ID", data[i].Test_ID));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                           new MySqlParameter("@LedgertransactionNo", data[i].LedgertransactionNo.Trim()),
                           new MySqlParameter("@SinNo", data[i].BarcodeNo.Trim()), new MySqlParameter("@Test_ID", data[i].Test_ID),
                           new MySqlParameter("@Status", string.Format("SIN No. {0} {1}", data[i].BarcodeNo.Trim(), "Received at Hub")), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                           new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID),
                           new MySqlParameter("@DispatchCode", string.Empty));

                }
                else if (Resources.Resource.SRARequired == "0")
                {
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,testID) ");
                    sb.Append(" VALUES(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,@dtLogisticReceive,@LogisticReceiveDate,@LogisticReceiveBy,@Test_ID);");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                new MySqlParameter("@BarcodeNo", data[i].BarcodeNo.Trim()),
                                                new MySqlParameter("@FromCentreID", UserInfo.Centre),
                                                new MySqlParameter("@ToCentreID", UserInfo.Centre),
                                                new MySqlParameter("@DispatchCode", string.Empty),
                                                new MySqlParameter("@Qty", 1),
                                                new MySqlParameter("@EntryBy", UserInfo.ID),
                                                new MySqlParameter("@STATUS", "Received"),
                                                new MySqlParameter("@dtLogisticReceive", DateTime.Now),
                                                new MySqlParameter("@LogisticReceiveDate", DateTime.Now),
                                                new MySqlParameter("@LogisticReceiveBy", UserInfo.ID),
                                                new MySqlParameter("@Test_ID", data[i].Test_ID));


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode) ",
                                                new MySqlParameter("@LedgertransactionNo", data[i].LedgertransactionNo),
                                                new MySqlParameter("@SinNo", data[i].BarcodeNo.Trim()),
                                                new MySqlParameter("@Test_ID", data[i].Test_ID),
                                                new MySqlParameter("@Status", string.Format("SIN No. {0} {1}", data[i].BarcodeNo, "Received")),
                                                new MySqlParameter("@UserID", UserInfo.ID),
                                                new MySqlParameter("@UserName", UserInfo.LoginName),
                                                new MySqlParameter("@IpAddress", StockReports.getip()),
                                                new MySqlParameter("@CentreID", UserInfo.Centre),
                                                new MySqlParameter("@RoleID", UserInfo.RoleID),
                                                new MySqlParameter("@dtEntry", DateTime.Now),
                                                new MySqlParameter("@DispatchCode", string.Empty));

                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        catch (Exception ex)
        {
			
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string saverejectdata(List<string> data, string RejectionReason, string labno, string pid, string RejectionReason_ID)
    {
        Exception aa = new Exception("WRONG REJECTION CODE IN SAMPLE COLLECTION SCREEN ");
        ClassLog objLog = new ClassLog();
        objLog.errLog(aa);
        return "0";
    }
    [WebMethod(EnableSession = true)]
    public static string AddTube(string TestID, string qty)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update patient_labinvestigation_opd SET SampleQty=@SampleQty WHERE BarcodeNo=@BarcodeNo ",
               new MySqlParameter("@SampleQty", qty), new MySqlParameter("@BarcodeNo", TestID));
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindAllRequiredField(string requiredFiled, string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] itemTags = requiredFiled.Split(',');
            string[] itemNames = itemTags.Select((s, i) => "@tag" + i).ToArray();
            string itemClause = string.Join(", ", itemNames);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL(pr.FieldValue,'')FieldValue,IFNULL(pr.unit,'') savedUnit, rm.id,rm.FieldName,InputType,IF(rm.IsUnit=1,rm.Unit,'') Unit,IF(InputType='DropDownList',DropDownOption,'')DropDownOption ");
            sb.Append(" FROM `requiredfield_master` rm LEFT JOIN patient_labinvestigation_opd_requiredField pr on rm.id=pr.fieldid ");
            sb.Append(" AND pr.LedgerTransactionNo=@LedgerTransactionNo  WHERE rm.id IN ({0}) AND rm.id not in ('12') ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), itemClause), con))
            {
                for (int i = 0; i < itemNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(itemNames[i], itemTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionNo", LabNo);
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
    public static string SaveRequiredField(List<BookingRequiredField> RequiredField)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(3);
        int ReqCount = MT.GetIPCount(3);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);


        try
        {

            foreach (BookingRequiredField objrequired in RequiredField)
            {
                BookingRequiredField objrequ = new BookingRequiredField(tnx)
                {
                    FieldID = objrequired.FieldID,
                    FieldName = objrequired.FieldName,
                    FieldValue = objrequired.FieldValue,
                    Unit = objrequired.Unit,
                    LedgerTransactionID = objrequired.LedgerTransactionID,
                    LedgerTransactionNo = objrequired.LedgerTransactionNo
                };
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE from patient_labinvestigation_opd_requiredField where LedgerTransactionID=@LedgerTransactionID AND FieldID=@FieldID",
                   new MySqlParameter("@LedgerTransactionID", RequiredField[0].LedgerTransactionID),
                   new MySqlParameter("@FieldID", objrequired.FieldID));

                int issave = objrequ.Insert();
                if (issave == 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Error" });
                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class SampleCollection
    {
        public string CentreID { get; set; }
        public string SampleStatus { get; set; }
        public string SearchType { get; set; }
        public string SearchValue { get; set; }
        public string Department { get; set; }
        public string FormDate { get; set; }
        public string FromTime { get; set; }
        public string ToDate { get; set; }
        public string ToTime { get; set; }
        public string PanelID { get; set; }
        public string UserID { get; set; }
    }
    public static List<string> SampleStatusData()
    {
        List<string> sampleStatusType = new List<string>();
        sampleStatusType.Add("N");
        sampleStatusType.Add("S");
        sampleStatusType.Add("Y");
        sampleStatusType.Add("R");
        return sampleStatusType;
    }

}