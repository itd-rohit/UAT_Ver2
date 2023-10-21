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

public partial class Design_Lab_SampleReceiveDepartment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            AllLoad_Data.getCurrentDate(txtFormDate, txtToDate);
            bindAllData();
        }
    }

    private void bindAllData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            ddlPanel.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(panel_code,'~',company_name) panelName ,panel_id FROM  f_panel_master WHERE isActive=1 ORDER BY panel_code ").Tables[0];
            ddlPanel.DataTextField = "panelName";
            ddlPanel.DataValueField = "panel_id";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("All Panel", "0"));

            ddlInvestigation.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select IF(im.TestCode='',typeName,CONCAT(im.TestCode,' ~ ',typeName)) Name,im.`ItemID` id from f_itemmaster im where isactive=1 and im.subcategoryid<>'LSHHI44' order by Name").Tables[0];
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "id";
            ddlInvestigation.DataBind();
            ddlInvestigation.Items.Insert(0, new ListItem("All Test", ""));

            ddlMachine.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,NAME FROM macMaster WHERE isActive=1").Tables[0];
            ddlMachine.DataTextField = "NAME";
            ddlMachine.DataValueField = "ID";
            ddlMachine.DataBind();
            ddlMachine.Items.Insert(0, new ListItem("All Machine", ""));

            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
            sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
            sb.Append(" aND ot.IsActive=1 order by ot.Name");
            ddlDepartment.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataBind();
            // ddlDepartment.Items.Insert(0, new ListItem("All Department", ""));


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
    public static List<departmentReceive> SearchType()
    {
        List<departmentReceive> deptReceiveSearchType = new List<departmentReceive>();
        deptReceiveSearchType.Add(new departmentReceive() { SearchType = "pli.LedgertransactionNo" });
        deptReceiveSearchType.Add(new departmentReceive() { SearchType = "lt.patient_id" });
        deptReceiveSearchType.Add(new departmentReceive() { SearchType = "pli.BarcodeNo" });
        deptReceiveSearchType.Add(new departmentReceive() { SearchType = "lt.PName" });
        return deptReceiveSearchType;
    }
    [WebMethod]
    public static string SearchSampleReceive(object searchdata)
    {
        try
        {
            string checkSession = UserInfo.LoginName;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Session Expired" });
        }
        List<departmentReceive> deptReceive = new JavaScriptSerializer().ConvertToType<List<departmentReceive>>(searchdata);
        string departmentID = String.Join(",", deptReceive[0].Department.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Split('#')[0]).ToList());

        string[] departmentIDTags = departmentID.Split(',');
        string[] departmentIDNames = departmentIDTags.Select((s, i) => "@tag" + i).ToArray();
        string departmentIDClause = string.Join(", ", departmentIDNames);

        HashSet<string> SearchTypes = new HashSet<string>(deptReceive.Select(s => s.SearchType));
        if (SearchType().Where(m => SearchTypes.Contains(m.SearchType)).Count() == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT IFNULL(pli.slidenumber,'')slidenumber, pli.result_flag, pli.subcategoryid,if(im.Container=7,'', pli.sampleqty)sampleqty, pli.IsUrgent,pli.HistoCytoSampleDetail,(select name from employee_master where employee_id=pli.HistoCytoPerformingDoctor limit 1) Performingdoctor ,pli.test_id, pli.IsSampleCollected, pli.BarcodeNo,lt.PName,pli.ledgerTransactionNO,pli.patient_id,pli.`SampleTypeID`,pli.`SampleTypeName`,'' Formalin, ");
            sbQuery.Append(" pli.itemname,");
            sbQuery.Append(" case when pli.IsSampleCollected='S' then  'lightyellow' when pli.IsSampleCollected='Y' then 'lightgreen'  when pli.IsSampleCollected='R' then 'pink' else 'white' end rowcolor, ");
            sbQuery.Append(" case when pli.IsSampleCollected='S' then  'Pending' when pli.IsSampleCollected='Y' then 'Received'  when pli.IsSampleCollected='R' then 'Rejected' else 'white' end `status`,im.Container reporttype, ");
            sbQuery.Append(" lt.panelname PanelName,im.RequiredAttachment,im.AttchmentRequiredAt, (SELECT COUNT(id) FROM document_detail WHERE LabNo=lt.ledgerTransactionNo) AttachmentCount");
            sbQuery.Append(" ,DATE_FORMAT(pli.`Date`,'%d-%b-%Y %h:%i %p')RegDate,ifnull(DATE_FORMAT(pli.`SRADate`,'%d-%b-%Y %h:%i %p'),'')SRADate");
            sbQuery.Append(" FROM  patient_labinvestigation_opd pli  ");
            sbQuery.Append(" INNER JOIN investigation_master im on im.investigation_ID=pli.investigation_ID");
            sbQuery.Append(" INNER JOIN investigation_observationtype iot ON pli.investigation_ID=iot.investigation_ID ");
            if (deptReceive[0].Department != string.Empty)
                sbQuery.Append(" AND iot.ObservationType_ID in({0}) ");
            if (deptReceive[0].InvestigationID != string.Empty)
                sbQuery.Append(" AND pli.investigation_ID=@InvestigationID ");
            sbQuery.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgerTransactionID=pli.ledgerTransactionID  ");
            if (deptReceive[0].SearchValue != string.Empty)
            {
                if (deptReceive[0].SearchType == "lt.PName")
                    sbQuery.AppendFormat(" AND {0} LIKE @SearchValue ", deptReceive[0].SearchType);
                else
                    sbQuery.AppendFormat(" AND {0} LIKE @SearchValue ", deptReceive[0].SearchType);
            }
            if (deptReceive[0].PanelID != 0)
            {
                sbQuery.Append(" AND lt.Panel_ID=@Panel_ID");
            }
            if (deptReceive[0].Type != "0")
            {
                sbQuery.Append(" and pli.IsSampleCollected=@IsSampleCollected");
            }
            if (deptReceive[0].MachineID != string.Empty)
            {
                sbQuery.Append(" INNER JOIN investigation_machinemaster imm ON imm.`CentreID`=@CentreID AND imm.`Investigation_ID` = pli.`Investigation_ID`  ");
                sbQuery.Append(" AND imm.MachineID=@MachineID ");
            }
            if (Resources.Resource.SRARequired == "1")
            {
                sbQuery.Append(" inner JOIN sample_logistic sl on sl.barcodeno=pli.barcodeno  AND sl.`testid` = pli.`Test_ID` ");
				if(deptReceive[0].Type != "R")
				{
				sbQuery.Append(" AND sl.isactive=1  ");
				}

                sbQuery.Append(" AND sl.tocentreid=@CentreID ");
                sbQuery.Append(" AND sl.status='Received' ");
                if (deptReceive[0].SinNo == String.Empty)
                {
                    sbQuery.Append("  AND sl.dtLogisticReceive >=@fromDate ");
                    sbQuery.Append(" AND sl.dtLogisticReceive <=@toDate ");
                }
                else
                    sbQuery.Append(" and sl.BarcodeNo=@BarcodeNo");
                sbQuery.Append("   order by sl.`BarcodeNo` ");
            }
            else
            {

                sbQuery.Append(" AND pli.CentreID=@CentreID ");
                if (deptReceive[0].SinNo == String.Empty)
                {
                    sbQuery.Append("  AND pli.SampleCollectionDate >=@fromDate ");
                    sbQuery.Append(" AND pli.SampleCollectionDate <=@toDate ");
                }
                else
                    sbQuery.Append(" and pli.BarcodeNo=@BarcodeNo");
                sbQuery.Append(" GROUP BY pli.test_ID,pli.Investigation_ID  order by pli.`BarcodeNo` ");
            }
            DataTable dt = new DataTable();
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sbQuery.ToString(), departmentIDClause), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.Centre);
                da.SelectCommand.Parameters.AddWithValue("@SearchValue", string.Format("%{0}%", deptReceive[0].SearchValue));
                da.SelectCommand.Parameters.AddWithValue("@Department", deptReceive[0].Department);
                da.SelectCommand.Parameters.AddWithValue("@IsSampleCollected", deptReceive[0].Type);
                da.SelectCommand.Parameters.AddWithValue("@InvestigationID", deptReceive[0].InvestigationID);
                da.SelectCommand.Parameters.AddWithValue("@BarcodeNo", deptReceive[0].SinNo);
                da.SelectCommand.Parameters.AddWithValue("@MachineID", deptReceive[0].MachineID);
                da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(deptReceive[0].FormDate).ToString("yyyy-MM-dd"), ' ', deptReceive[0].FromTime));
                da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(deptReceive[0].ToDate).ToString("yyyy-MM-dd"), ' ', deptReceive[0].ToTime));
                da.SelectCommand.Parameters.AddWithValue("@Panel_ID", deptReceive[0].PanelID);
                for (int i = 0; i < departmentIDNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(departmentIDNames[i], departmentIDTags[i]);
                }
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                   
                }
            }
            //System.IO.File.WriteAllText (@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\cap.txt", sbQuery.ToString());
            //DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
            //     new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@SearchValue", string.Format("%{0}%", deptReceive[0].SearchValue)),
            //     new MySqlParameter("@Department", deptReceive[0].Department), new MySqlParameter("@IsSampleCollected", deptReceive[0].Type),
            //     new MySqlParameter("@InvestigationID", deptReceive[0].InvestigationID), new MySqlParameter("@BarcodeNo", deptReceive[0].SinNo),
            //     new MySqlParameter("@MachineID", deptReceive[0].MachineID),
            //     new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(deptReceive[0].FormDate).ToString("yyyy-MM-dd"), ' ', deptReceive[0].FromTime)),
            //     new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(deptReceive[0].ToDate).ToString("yyyy-MM-dd"), ' ', deptReceive[0].ToTime)),
            //     new MySqlParameter("@Panel_ID", deptReceive[0].PanelID)
            //     ).Tables[0];
            deptReceive.Clear();
            return JsonConvert.SerializeObject(new { status = true, response = dt });
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
    public class departmentReceive
    {
        public string SampleStatus { get; set; }
        public string SearchType { get; set; }
        public string SearchValue { get; set; }
        public string Department { get; set; }
        public string FormDate { get; set; }
        public string FromTime { get; set; }
        public string ToDate { get; set; }
        public string ToTime { get; set; }
        public string SinNo { get; set; }
        public string Type { get; set; }
        public string InvestigationID { get; set; }
        public string MachineID { get; set; }
        public int PanelID { get; set; }
    }

    public class departmentSampleReceive
    {
        public int Test_ID { get; set; }
        public string HistoCytoSampleDetail { get; set; }
        public string performingDocID { get; set; }
        public string ReportType { get; set; }
        public string SpecimenType { get; set; }
        public string BarcodeNo { get; set; }
        public string SubcategoryID { get; set; }
        public string Formalin { get; set; }
        public string RequiredAttachment { get; set; }
        public string RequiredAttchmentAt { get; set; }
        public string Patient_ID { get; set; }
    }


    [WebMethod]
    public static string saveSampleReceive(List<departmentSampleReceive> data)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(5);
        int ReqCount = MT.GetIPCount(5);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {

            //            if (data.Select(x => x.RequiredAttchmentAt == "2").Count() > 0)
            //            {
            //                List<patientDocumentList> reqAttachment = new List<patientDocumentList>();

            //                var dataCount = data.Where(s => s.RequiredAttachment == "2").GroupBy(t => t.Patient_ID).Select(s => s.OrderByDescending(a => a.Patient_ID)).ToList();




            //                dataCount.ToList().ForEach(obj =>
            //{
            //    foreach (var item in obj.OrderBy(s => s.Patient_ID))
            //    {
            //        for (int req = 0; req < item.RequiredAttachment.Split('|').Length; req++)
            //        {
            //            reqAttachment.Add(new patientDocumentList { DocumentName = item.RequiredAttachment.Split('|')[req], Patient_ID = item.Patient_ID });
            //        }
            //    }
            //});

            //                reqAttachment = reqAttachment.GroupBy(x => new { x.DocumentName, x.Patient_ID }).Select(g => g.First()).ToList();
            //                if (reqAttachment.Count > 0)
            //                {

            //                    for (int s = 0; s < reqAttachment.Count; s++)
            //                    {

            //                        var patientDocumentList1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DocumentName,DocumentID FROM document_detail WHERE PatientID=@PatientID AND IsActive=1",
            //                            new MySqlParameter("@PatientID", reqAttachment[s].Patient_ID)).Tables[0];



            //                        var patientDocumentList = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DocumentName,DocumentID FROM document_detail WHERE PatientID=@PatientID AND IsActive=1",
            //                             new MySqlParameter("@PatientID", reqAttachment[s].Patient_ID)).Tables[0].AsEnumerable().Select(j => new
            //                             {
            //                                 DocumentID = j.Field<int>("DocumentID"),
            //                                 DocumentName = j.Field<string>("DocumentName")
            //                             }).ToList();
            //                        if (reqAttachment.Count(b => b.DocumentName == "Doctor Prescription") > 0 && patientDocumentList.Where(s => s.DocumentName == "Doctor Prescription").Count() == 0)
            //                        {
            //                            tnx.Rollback();
            //                            return JsonConvert.SerializeObject(new { status = false, response = "Doctor Prescription Required to Attach With Booked Test" });
            //                        }
            //                        patientDocumentList = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DocumentName,DocumentID FROM document_detail WHERE PatientID=@PatientID AND IsActive=1 AND DocumentID<>2 UNION ALL SELECT DocumentName,DocumentID FROM document_detail WHERE PatientID=@PatientID AND IsActive=1 ",
            //                          new MySqlParameter("@PatientID", reqAttachment[s].Patient_ID)).Tables[0].AsEnumerable().Select(j => new
            //                          {
            //                              DocumentID = j.Field<int>("DocumentID"),
            //                              DocumentName = j.Field<string>("DocumentName")
            //                          }).ToList();

            //                        HashSet<string> reqID = new HashSet<string>(reqAttachment.Select(s => s.DocumentName));
            //                        if (patientDocumentList.Where(m => reqID.Contains(m.DocumentName) && m.DocumentName != "Doctor Prescription").Count() == 0)
            //                        {
            //                            tnx.Rollback();
            //                            return JsonConvert.SerializeObject(new { status = false, response = string.Concat(string.Join(",", reqAttachment.Select(x => x.DocumentName).Distinct()), " Required to Attach With Booked Test") });
            //                        }

            //                        reqAttachment.Clear();
            //                    }
            //                }                
            //            }


            for (int i = 0; i < data.Count; i++)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT  plo.`SubcategoryID`,Left(Upper(NAME),4) Name,DepartmentSequence FROM patient_labinvestigation_opd plo ");
                sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.subcategoryid=plo.subcategoryid ");
                sb.Append(" WHERE barcodeNo=@barcodeNo group by plo.`SubcategoryID` ORDER BY DepartmentSequence");

                DataTable dtcombine = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@barcodeNo", data[i].BarcodeNo)).Tables[0];

                if (dtcombine.Rows.Count > 1)
                {
                    sb = new StringBuilder();
                    sb.Append("update patient_labinvestigation_opd set CombinationSample=1,CurrentSampleDept=@CurrentSampleDept,ToSampleDept=@ToSampleDept where  barcodeno=@barcodeNo");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@CurrentSampleDept", dtcombine.Select(string.Format("SubcategoryID='{0}'", data[i].SubcategoryID))[0]["NAME"]),
                         new MySqlParameter("@ToSampleDept", ((dtcombine.Select(string.Format("DepartmentSequence>{0}", dtcombine.Select(string.Format("SubcategoryID='{0}'", data[i].SubcategoryID))[0]["DepartmentSequence"])).Length == 0) ? "" : dtcombine.Select(string.Format("DepartmentSequence>{0}", dtcombine.Select(string.Format("SubcategoryID='{0}'", data[i].SubcategoryID))[0]["DepartmentSequence"]))[0]["NAME"])),
                         new MySqlParameter("@barcodeNo", data[i].BarcodeNo));
                }
              //  System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\sampl.txt", "select Tocentreid from sample_logistic where testid=@Test_ID" + "#" + UserInfo.Centre + "#" + data[i].Test_ID);
                if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Tocentreid from sample_logistic where testid=@Test_ID  AND isactive=1 AND STATUS='Received'", new MySqlParameter("@Test_ID", data[i].Test_ID))) != UserInfo.Centre)
                {
                    tnx.Rollback();
                     return JsonConvert.SerializeObject(new { status = false, response = "Kindly Receive Sample in Testing Centre !!" });
                }
                sb = new StringBuilder();
                sb.Append("update patient_labinvestigation_opd set TestCentreID=@TestCentreID,IsSampleCollected='Y',SampleReceiver=@SampleReceiver,SampleReceivedBy=@SampleReceivedBy,SampleReceiveDate=NOW(),HistoCytoSampleDetail=@HistoCytoSampleDetail,HistoCytoPerformingDoctor=@HistoCytoPerformingDoctor,SampleTypeName=@SampleTypeName ");
                sb.Append("where Test_ID=@Test_ID  and IsSampleCollected='S'  ");
                int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@TestCentreID", UserInfo.Centre),
                  new MySqlParameter("@SampleReceiver", UserInfo.LoginName),
                  new MySqlParameter("@SampleReceivedBy", UserInfo.ID),
                  new MySqlParameter("@HistoCytoSampleDetail", data[i].HistoCytoSampleDetail),
                  new MySqlParameter("@HistoCytoPerformingDoctor", data[i].performingDocID),
                  new MySqlParameter("@SampleTypeName", data[i].SpecimenType),
                  new MySqlParameter("@Test_ID", data[i].Test_ID));

              //   MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL insert_Mac_Detail(@CentreID,@BarcodeNo,'Receive');",
                 //           new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@BarcodeNo", data[i].BarcodeNo));
			   string cultureno = "";
                if (dtcombine.Rows.Count > 0)
                {
                    if (dtcombine.Rows[0]["subcategoryID"].ToString() == "42")
                    {
                         string uhid = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT  UHIDCode FROM `centre_master`  cm  Where cm.`CentreID`= '" + UserInfo.Centre + "' "));
                        
                        cultureno = uhid + "-" + Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select LPAD(MAX(REPLACE(Cultureno,'" + uhid + "',''))+1,4,'0000') from patient_labinvestigation_opd where SubcategoryID=42 and MONTH(DATE)=" + DateTime.Now.Month + " and YEAR(DATE)=" + DateTime.Now.Year + ""));
                        sb = new StringBuilder();
                        sb.Append("update patient_labinvestigation_opd set cultureno='" + cultureno + "' ");
                        sb.Append("where Test_ID=@Test_ID  and cultureno =''  ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@Test_ID", data[i].Test_ID));
                    }
                }
                sb = new StringBuilder();
                if (cnt > 0)
                {
                    sb = new StringBuilder();
                    string subcategory = data[i].SubcategoryID;
                    string slidenumber = string.Empty;
                    string UpdateSN = string.Empty;
                    if (subcategory == "4")
                    {
                        string CentreCode = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT UHIDCode FROM centre_master where CentreID=@CentreID ",
                            new MySqlParameter("@CentreID", UserInfo.Centre)));
                        sb.Append("SELECT get_Tran_id(@CentreCode)");
                        slidenumber = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@CentreCode", string.Concat(CentreCode, "_Cyto"))));
                        UpdateSN = string.Concat(CentreCode, "CY", slidenumber);
                    }
                    else if (subcategory == "7")
                    {
                        string CentreCode = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT UHIDCode FROM centre_master where CentreID=@CentreID ",
                            new MySqlParameter("@CentreID", UserInfo.Centre)));
                        sb.Append("SELECT get_Tran_id(@CentreCode)");
                        slidenumber = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@CentreCode", string.Concat(CentreCode, "_Histo"))));
                        UpdateSN = string.Concat(CentreCode, "HS", slidenumber);
                    }
                    sb = new StringBuilder();
                    sb.Append("update patient_labinvestigation_opd set slideNumber=@slideNumber,HistoCytoStatus='Assigned' where Test_ID=@Test_ID");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@slideNumber", UpdateSN), new MySqlParameter("@Test_ID", data[i].Test_ID));
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                    sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Department Receive (',ItemName,')'),@UserID,@UserName,@IpAddress,@CentreID, ");
                    sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@UserID", UserInfo.ID),
                        new MySqlParameter("@UserName", UserInfo.LoginName),
                        new MySqlParameter("@IpAddress", StockReports.getip()),
                        new MySqlParameter("@CentreID", UserInfo.Centre),
                        new MySqlParameter("@RoleID", UserInfo.RoleID),
                        new MySqlParameter("@Test_ID", data[i].Test_ID));
                    if (data[i].SubcategoryID == "7" || data[i].SubcategoryID == "4")
                    {
                        string BiopsyNumber = data[i].SubcategoryID == "7" ? " & Biopsy number is : " + UpdateSN : "";
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                        sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Assigned to ',CONCAT(em.Title,' ',em.Name),@Status),@UserID,@UserName,@IpAddress,@CentreID, ");
                        sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd plo ");
                        sb.Append(" INNER JOIN  employee_Master em ON plo.HistoCytoPerformingDoctor=em.Employee_id ");
                        sb.Append(" WHERE  Test_ID =@Test_ID");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Test_ID", data[i].Test_ID),
                             new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                             new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@Status", BiopsyNumber),
                             new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID));
                    }
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
    public class sampleReceiveDepartment
    {
        public int Test_ID { get; set; }
        public string BarCodeNo { get; set; }
        public string Patient_ID { get; set; }
        public string LedgertransactionNo { get; set; }

    }

    [WebMethod]
    public static string saveTranferData(List<sampleReceiveDepartment> data)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(6);
        int ReqCount = MT.GetIPCount(6);
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
                StringBuilder sb = new StringBuilder();
                sb.Append("update patient_labinvestigation_opd set IsSampleCollected='S',UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=NOW() where Test_ID=@Test_ID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@UpdateID", UserInfo.ID),
                    new MySqlParameter("@UpdateName", UserInfo.LoginName),
                    new MySqlParameter("@Test_ID", data[i].Test_ID));

                sb = new StringBuilder();
                sb.Append("update sample_logistic set Status='Transferred' where BarcodeNo =@BarcodeNo and Status='Received' and `ToCentreID`=@ToCentreID;");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@BarcodeNo", data[i].BarCodeNo), new MySqlParameter("@ToCentreID", UserInfo.Centre));

                sb = new StringBuilder();
                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Tranfer From Department (',ItemName,')'),@UserID,@UserName,@IpAddress,@CentreID, ");
                sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                  new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre),
                  new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@Test_ID", data[i].Test_ID));

                string barcode = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select BarCodeNo from patient_labinvestigation_opd WHERE  Test_ID =@Test_ID ",
                    new MySqlParameter("@Test_ID", data[i].Test_ID)));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL insert_Mac_Detail(@CentreID,@barcode,'Delete');",
                    new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@barcode", barcode));
            }
            tnx.Commit();
            data.Clear();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public static string getdoclist()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.`Name` FROM f_login fl ");
            sbQuery.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
            sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
            sbQuery.Append("  WHERE centreID=@centreID ");
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                new MySqlParameter("@centreID", UserInfo.Centre)).Tables[0]);


        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}