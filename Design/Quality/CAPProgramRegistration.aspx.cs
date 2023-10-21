using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_CAPProgramRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            string dt = StockReports.ExecuteScalar("SELECT count(1) FROM qc_approvalright WHERE apprightfor='CAP' and typeid=13 AND active=1 AND employeeid='" + UserInfo.ID + "' ");
            if (dt == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right Register CAP Program');", true);
                return;
            }


            ddlcentre.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlcentre.DataValueField = "centreid";
            ddlcentre.DataTextField = "centre";
            ddlcentre.DataBind();
        }
        
    }

    [WebMethod(EnableSession = true)]
    public static string bindshipment(string labid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT shipmentno FROM qc_capshippingdetail WHERE isactive=1 AND centreid=" + labid + " GROUP BY centreid,shipmentno "));
    }
    
    
   

    [WebMethod(EnableSession = true)]
    public static string SearchProgram(string centreid, string shipmentno,string type)
    {

        StringBuilder sb = new StringBuilder();
        if (type == "0")
        {
            sb.Append(" SELECT ifnull(qcpp.test_id,0) test_id, if(ifnull(qcpp.test_id,0)=0,'',date_format(qcpp.entrydate,'%d-%b-%Y')) visitdate, ifnull(plo.LedgerTransactionNo,'') visitno, ifnull(qcpp.LedgerTransactionID,0)LedgerTransactionID, ifnull((select grade from qc_capprogramperformance where programid=qc.`ProgramID` and InvestigationID=im.Investigation_ID order by capdonedate desc limit 1),'')lastStatus,");
            sb.Append("  qcp.`CentreId`, qcp.`ShipmentNo`,DATE_FORMAT(qcp.`ShipDate`,'%d-%b-%Y')ShipDate,DATE_FORMAT(qcp.`DueDate`,'%d-%b-%Y') `DueDate`, ");
            sb.Append("qc.`ProgramName`,qc.`ProgramID`,qc.`InvestigationID`,qc.`InvestigationName`,im.`ReportType`,imm.`TestCode`,imm.`ItemID`, ");
            sb.Append(" imm.`TypeName` Itemname,imm.`SubCategoryID`,IFNULL(qcpp.`BarcodeNo`,'') sinno,IFNULL(qcpp.`Specimen`,'')Specimen FROM qc_capshippingdetail qcp  ");
            sb.Append(" INNER JOIN `qc_capprogrammaster` qc ON qcp.`ProgramID`=qc.`ProgramID` AND qc.`IsActive`=1 AND qcp.`IsActive`=1 ");
            sb.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=qc.`InvestigationID` ");
            sb.Append(" INNER JOIN f_itemmaster imm ON imm.`Type_ID`=im.`Investigation_Id` ");
            sb.Append(" LEFT JOIN qc_capregistration qcpp ON qcpp.`ProgramID`=qc.`ProgramID` AND qcpp.`CentreID`=qcp.`CentreId` AND ");
            sb.Append(" qcpp.`ShipmentNo`=qcp.`ShipmentNo` AND qcpp.`InvestigationID`=qc.`InvestigationID` AND qcpp.`IsActive`=1 ");
            sb.Append(" left join patient_labinvestigation_opd plo on plo.test_id=qcpp.test_id ");

            sb.Append(" WHERE qcp.`ShipmentNo`='" + shipmentno + "' AND qcp.`CentreId`=" + centreid + " group by ifnull(qcpp.test_id,0) ,qc.`InvestigationID` order by qc.`ProgramID`,ifnull(qcpp.LedgerTransactionID,0),qc.`InvestigationName`  ");
        }
        else
        {
            sb.Append(" SELECT * FROM (");
            sb.Append(" SELECT ifnull(qcpp.test_id,0) test_id, if(ifnull(qcpp.test_id,0)=0,'',date_format(qcpp.entrydate,'%d-%b-%Y')) visitdate,ifnull(plo.LedgerTransactionNo,'') visitno, ifnull(qcpp.LedgerTransactionID,0)LedgerTransactionID, ifnull((select grade from qc_capprogramperformance where programid=qc.`ProgramID` and InvestigationID=im.Investigation_ID order by capdonedate desc limit 1),'')lastStatus,");
            sb.Append("  qcp.`CentreId`, qcp.`ShipmentNo`,DATE_FORMAT(qcp.`ShipDate`,'%d-%b-%Y')ShipDate,DATE_FORMAT(qcp.`DueDate`,'%d-%b-%Y') `DueDate`, ");
            sb.Append("qc.`ProgramName`,qc.`ProgramID`,qc.`InvestigationID`,qc.`InvestigationName`,im.`ReportType`,imm.`TestCode`,imm.`ItemID`, ");
            sb.Append(" imm.`TypeName` Itemname,imm.`SubCategoryID`,IFNULL(qcpp.`BarcodeNo`,'') sinno,IFNULL(qcpp.`Specimen`,'')Specimen FROM qc_capshippingdetail qcp  ");
            sb.Append(" INNER JOIN `qc_capprogrammaster` qc ON qcp.`ProgramID`=qc.`ProgramID` AND qc.`IsActive`=1 AND qcp.`IsActive`=1 ");
            sb.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=qc.`InvestigationID` ");
            sb.Append(" INNER JOIN f_itemmaster imm ON imm.`Type_ID`=im.`Investigation_Id` ");
            sb.Append(" LEFT JOIN qc_capregistration qcpp ON qcpp.`ProgramID`=qc.`ProgramID` AND qcpp.`CentreID`=qcp.`CentreId` AND ");
            sb.Append(" qcpp.`ShipmentNo`=qcp.`ShipmentNo` AND qcpp.`InvestigationID`=qc.`InvestigationID` AND qcpp.`IsActive`=1 ");
            sb.Append(" left join patient_labinvestigation_opd plo on plo.test_id=qcpp.test_id ");
            sb.Append(" WHERE qcp.`ShipmentNo`='" + shipmentno + "' AND qcp.`CentreId`=" + centreid + "  ");
          
            sb.Append(" union all ");
            sb.Append(" SELECT 0  test_id,'' visitdate,'' visitno, 0 LedgerTransactionID, ifnull((select grade from qc_capprogramperformance where programid=qc.`ProgramID` and InvestigationID=im.Investigation_ID order by capdonedate desc limit 1),'')lastStatus,");
            sb.Append("  qcp.`CentreId`, qcp.`ShipmentNo`,DATE_FORMAT(qcp.`ShipDate`,'%d-%b-%Y')ShipDate,DATE_FORMAT(qcp.`DueDate`,'%d-%b-%Y') `DueDate`, ");
            sb.Append("qc.`ProgramName`,qc.`ProgramID`,qc.`InvestigationID`,qc.`InvestigationName`,im.`ReportType`,imm.`TestCode`,imm.`ItemID`, ");
            sb.Append(" imm.`TypeName` Itemname,imm.`SubCategoryID`,'' sinno,''Specimen FROM qc_capshippingdetail qcp  ");
            sb.Append(" INNER JOIN `qc_capprogrammaster` qc ON qcp.`ProgramID`=qc.`ProgramID` AND qc.`IsActive`=1 AND qcp.`IsActive`=1 ");
            sb.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=qc.`InvestigationID` ");
            sb.Append(" INNER JOIN f_itemmaster imm ON imm.`Type_ID`=im.`Investigation_Id` ");
            sb.Append(" WHERE qcp.`ShipmentNo`='" + shipmentno + "' AND qcp.`CentreId`=" + centreid + "  ");
            sb.Append(" ) t");
            sb.Append(" group by test_id,`InvestigationID` order by `ProgramID`,LedgerTransactionID,`InvestigationName` ");
        }

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string savedata(List<CAPRegister> DataToSave)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string PatientID = string.Empty;
            string LedgerTransactionID = string.Empty;
            string LedgerTransactionNo = string.Empty;

            PatientID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select patient_id from patient_master where patient_id='EQAS'"));

            if (PatientID == "")
            {
                Exception ex = new Exception("Patient ID Not Found for EQAS.Please Contract To Admin");
                throw (ex);
            }

          
                Ledger_Transaction objlt = new Ledger_Transaction(tnx);
                objlt.TypeOfTnx = "OPD - LAB";
                objlt.DiscountOnTotal = 0;
                objlt.NetAmount = 0;
                objlt.GrossAmount = 0;
                objlt.IsCredit = 0;
                objlt.Patient_ID = PatientID;

                objlt.PName = "Mr.CAP EQAS Program";

                objlt.Age = "51 Y 0 M 0 D ";
                objlt.Gender ="Male";
               
               
                objlt.Panel_ID = 78;
                objlt.PanelName = "Standard";
                objlt.Doctor_ID = "1";
                objlt.DoctorName = "SELF";

                objlt.CentreID = DataToSave[0].CentreID;
                objlt.Adjustment = 0;
                objlt.Creator_UserID = UserInfo.ID;
               
                objlt.ReVisit = 0;
                objlt.CreatorName = UserInfo.LoginName;
                objlt.DiscountID = 0;
              
                objlt.IsApolloOnePush = 0;

                
                string retvalue = objlt.Insert();
                if (retvalue == string.Empty)
                {
                    tnx.Rollback();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }
                LedgerTransactionID = retvalue.Split('#')[0];
                LedgerTransactionNo = retvalue.Split('#')[1];

                DataTable dtSample = new DataTable();
                dtSample.Columns.Add("SampleType");
                dtSample.Columns.Add("SubCategoryID");
                dtSample.Columns.Add("BarcodeNo");
                string Barcode = "";
             
                foreach (CAPRegister proda in DataToSave)
                {
                    string sampleType = "";
                    sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT concat(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`='" + proda.InvestigationID + "' AND ist.`IsDefault`=1 "));

                        if (dtSample.Select("SampleType='" + sampleType.Split('#')[0] + "' and SubCategoryID='" + proda.SubCategoryID + "'").Length == 0)
                        {
                            Barcode = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_barcode('" + proda.SubCategoryID + "')").ToString();
                            DataRow dr = dtSample.NewRow();
                            dr["SampleType"] = sampleType.Split('#')[0];
                            dr["SubCategoryID"] = proda.SubCategoryID;
                            dr["BarcodeNo"] = Barcode;
                            dtSample.Rows.Add(dr);
                            dtSample.AcceptChanges();
                        }
                        else
                            Barcode = dtSample.Select("SampleType='" + sampleType.Split('#')[0] + "' and SubCategoryID='" + proda.SubCategoryID + "'")[0]["BarcodeNo"].ToString();
                   

                    Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
                    objPlo.LedgerTransactionID = LedgerTransactionID;
                    objPlo.LedgerTransactionNo = LedgerTransactionNo;
                    objPlo.Patient_ID = PatientID;
                    objPlo.AgeInDays = 18615;
                    objPlo.Gender = "Male";
                    objPlo.BarcodeNo = Barcode;
                    objPlo.ItemId = proda.ItemId;

                    objPlo.ItemName = proda.ItemName.ToUpper();
                    objPlo.TestCode = proda.TestCode;
                    objPlo.InvestigationName = proda.InvestigationName.ToUpper();
                    objPlo.PackageName = "";
                    objPlo.PackageCode = "";

                    objPlo.Investigation_ID = Util.GetString(proda.InvestigationID);
                    objPlo.IsPackage = "0";
                    objPlo.SubCategoryID = proda.SubCategoryID;
                    objPlo.Rate = 0;
                    objPlo.Amount = 0;
                    objPlo.DiscountAmt = 0;
                    objPlo.DiscountByLab = 0;
                    objPlo.CouponAmt = 0;
                    objPlo.SBICardAmt = 0;
                    objPlo.ISSBIDiscByLab = 0;
                    objPlo.Quantity = 1;
                    objPlo.IsRefund = 0;
                    objPlo.IsReporting = 1;
                    objPlo.ReportType = proda.ReportType;
                    objPlo.CentreID = proda.CentreID;
                    objPlo.TestCentreID = 0;
                    objPlo.IsSampleCollected = "S";

                    if (objPlo.IsSampleCollected == "S")
                    {
                        objPlo.SampleCollector = UserInfo.LoginName;
                        objPlo.SampleCollectionBy = UserInfo.ID;

                        objPlo.Sampledate = Util.GetDateTime(DateTime.Now);
                        objPlo.SampleCollectionDate = Util.GetDateTime(DateTime.Now);

                        try
                        {
                            objPlo.SampleTypeID = sampleType.Split('#')[0];
                            objPlo.SampleTypeName = sampleType.Split('#')[1];
                        }
                        catch
                        {
                        }
                    }
                    objPlo.SampleBySelf = 1;
                    objPlo.isUrgent = 0;

                    objPlo.MRP = 0;
                    objPlo.Date = DateTime.Now;
                    objPlo.ApolloOneFreeTest = 0;
                    objPlo.ItemID_Interface = "";

                    string ID = objPlo.Insert();

                    if (ID == string.Empty)
                    {
                        tnx.Rollback();
                        tnx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }
                    DataTable dt_LabObservation = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT lm.`LabObservation_ID`,lm.`Name` AS LabObservationName FROM `labobservation_investigation` li INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` WHERE li.`Investigation_Id`='" + objPlo.Investigation_ID + "'").Tables[0];
                  
                     if (dt_LabObservation.Rows.Count > 0)
                     {
                         for (int i = 0; i < dt_LabObservation.Rows.Count; i++)
                         {
                             StringBuilder sb = new StringBuilder();
                             sb.Append(" insert into qc_capregistration (CentreID,ShipmentNo,ProgramID,ItemID,Specimen,Test_ID,LedgerTransactionID, ");
                             sb.Append(" BarcodeNo,InvestigationID,InvestigationName,EntryDate,EntryBy,EntryByName,LabObservationID,LabObservationName) ");
                             sb.Append(" values ");
                             sb.Append("(@CentreID,@ShipmentNo,@ProgramID,@ItemID,@Specimen,@Test_ID,@LedgerTransactionID,");
                             sb.Append(" @BarcodeNo,@InvestigationID,@InvestigationName,@EntryDate,@EntryBy,@EntryByName,@LabObservationID,@LabObservationName)");

                             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                 new MySqlParameter("@CentreID", proda.CentreID),
                                  new MySqlParameter("@ShipmentNo", proda.ShipmentNo),
                                   new MySqlParameter("@ProgramID", proda.ProgramID),
                                    new MySqlParameter("@ItemID", proda.ItemId),
                                     new MySqlParameter("@Specimen", proda.Specimen),
                                      new MySqlParameter("@Test_ID", ID),
                                       new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                        new MySqlParameter("@BarcodeNo", Barcode),
                                          new MySqlParameter("@InvestigationID", proda.InvestigationID),
                                           new MySqlParameter("@InvestigationName", proda.InvestigationName),
                                            new MySqlParameter("@EntryDate", DateTime.Now),
                                             new MySqlParameter("@EntryBy", UserInfo.ID),
                                              new MySqlParameter("@EntryByName", UserInfo.LoginName),
                                            new MySqlParameter("@LabObservationID", dt_LabObservation.Rows[i]["LabObservation_ID"].ToString()),
                                             new MySqlParameter("@LabObservationName", dt_LabObservation.Rows[i]["LabObservationName"].ToString()));
                         }
                     }
                    else
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" insert into qc_capregistration (CentreID,ShipmentNo,ProgramID,ItemID,Specimen,Test_ID,LedgerTransactionID, ");
                        sb.Append(" BarcodeNo,InvestigationID,InvestigationName,EntryDate,EntryBy,EntryByName,LabObservationID,LabObservationName) ");
                        sb.Append(" values ");
                        sb.Append("(@CentreID,@ShipmentNo,@ProgramID,@ItemID,@Specimen,@Test_ID,@LedgerTransactionID,");
                        sb.Append(" @BarcodeNo,@InvestigationID,@InvestigationName,@EntryDate,@EntryBy,@EntryByName,@LabObservationID,@LabObservationName)");

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@CentreID", proda.CentreID),
                             new MySqlParameter("@ShipmentNo", proda.ShipmentNo),
                              new MySqlParameter("@ProgramID", proda.ProgramID),
                               new MySqlParameter("@ItemID", proda.ItemId),
                                new MySqlParameter("@Specimen", proda.Specimen),
                                 new MySqlParameter("@Test_ID", ID),
                                  new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                   new MySqlParameter("@BarcodeNo", Barcode),
                                     new MySqlParameter("@InvestigationID", proda.InvestigationID),
                                      new MySqlParameter("@InvestigationName", proda.InvestigationName),
                                       new MySqlParameter("@EntryDate", DateTime.Now),
                                        new MySqlParameter("@EntryBy", UserInfo.ID),
                                         new MySqlParameter("@EntryByName", UserInfo.LoginName),
                                         new MySqlParameter("@LabObservationID", 0),
                                         new MySqlParameter("@LabObservationName", ""));
                    }



                }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();

        }
    }
    
    
}

public class CAPRegister
{

    public int CentreID { get; set; }
    public string ShipmentNo { get; set; }
    public int ProgramID { get; set; }
    public int InvestigationID { get; set; }
    public string Specimen { get; set; }

    public string SubCategoryID { get; set; }
    public string ItemId { get; set; }
    public string ItemName { get; set; }
    public string TestCode { get; set; }
    public string InvestigationName { get; set; }
    public int ReportType { get; set; }

}