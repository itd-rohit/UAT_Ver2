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


public partial class Design_Quality_ILCRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            //ddlprocessinglab.Items.Insert(0, new ListItem("Select Processing Lab", "0"));

           

            

            txtcurrentyear.Text = DateTime.Now.Year.ToString();
            ddlcurrentmonth.Items.Add(new ListItem(DateTime.Now.ToString("MMMM"), DateTime.Now.Month.ToString()));
           

            if (ddlprocessinglab.Items.Count > 0)
            {
                //int AccessDays = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=1 AND DAY(NOW()) BETWEEN fromdate AND todate and IsSpecial=0"));

                ////if (AccessDays == 0)
                ////{
                ////    int AccessDaysSpecial = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=1  AND DATE(NOW()) BETWEEN `Specialfrom` AND SpecialToDate and IsSpecial=1"));
                ////    if (AccessDaysSpecial == 0)
                ////    {
                ////        string s = StockReports.ExecuteScalar("select concat(fromdate,'-',todate) from qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=1 and IsSpecial=0 ");

                ////        string msg = "This page only accessible between " + s + " (Every Month). Send request for increase time";
                ////        //ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "$('#btnsearch').hide();$('#disp1').show();$('#disp1').text('" + msg + "');showerrormsg('" + msg + "');", true);
                ////       // return;
                ////    }
                ////}

            }
            else
            {
                string msg = "No Processing Lab Found. Please Select Proper Centre.";
              //  ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "$('#btnsearch').hide();$('#disp1').show();$('#disp1').text('" + msg + "');showerrormsg('" + msg + "');", true);
              //  return;
            }




        }
    }
   

    [WebMethod]
    public static string bindilc(string processingcentre)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT * FROM(SELECT CONCAT(ilclabtypeid,'#',ilclabid)labid,CONCAT(ilclabname,'#',ilclabtype)labname FROM qc_ilcparametermapping ");
        sb.Append(" WHERE processinglabid=" + processingcentre + " AND isactive=1  ");
        sb.Append(" UNION  ALL  ");

        sb.Append(" SELECT CONCAT(ilclabtypeid,'#',ilclabid)labid,CONCAT(ilclabname,'#',ilclabtype)labname FROM `qc_ilcparametermapping_special` ");
        sb.Append("  WHERE processinglabid=" + processingcentre + " AND isactive=1 AND cyear=" + DateTime.Now.Year + " AND cmonth="+DateTime.Now.Month+")t  ");

        sb.Append("  GROUP BY labid ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public static string getparametercentre(string TestID, string ILCLab)
    {
        TestID = TestID.TrimEnd(',');

        string str = "SELECT TestType, TestID, TestName,`ILCLabTypeID`,`ILCLabType`,`ILCLabName`,`ILCLabID`,ProcessingLabID,ProcessingLabName,Rate,MONTH(NOW())CurrentMonth,YEAR(NOW())CurrentYear,`Fequency`,AcceptablePer,(SELECT GROUP_CONCAT(CONCAT(labid,'|',ilclabname) SEPARATOR '$')  centre  FROM qc_ilclabmaster WHERE isactive=1)centre FROM qc_ilcparametermapping WHERE Isactive=1 AND testID in(" + TestID + ") and ILCLabID=" + ILCLab.Split('#')[1] + "";
        DataTable dt=StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string BindLabCentre(string Type)
    {
        string str = "";
        if (Type == "1")
        {
            str = "SELECT GROUP_CONCAT(CONCAT(centreid,'|',centre) ORDER BY centre SEPARATOR '$') centre FROM centre_master WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre";
        }
        else
        {
            str = "SELECT GROUP_CONCAT(CONCAT(labid,'|',ilclabname) ORDER BY ilclabname SEPARATOR '$')  centre FROM qc_ilclabmaster WHERE isactive=1 ORDER BY ilclabname";
        }

        string rtrn = StockReports.ExecuteScalar(str);// Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.ExecuteScalar(str));
        return rtrn;
    }

       
    [WebMethod]
    public static string getparameterlist(string processingcentre, string ilclab, string regisyearandmonth)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select TestType,TestID,TestName,regisid,newbarcode,SquenceNo  from (");
        sb.Append(" SELECT TestType,TestID,TestName,ifnull(qil.id,'')regisid,ifnull(qil.barcodeno,'') newbarcode,qc.SquenceNo   ");
        sb.Append(" FROM qc_ilcparametermapping qc ");
        sb.Append(" left join qc_ilcregistration qil  ON (qc.TestID = qil.investigationid  OR qc.`TestID`=qil.`LabObservationID`) and qil.MapType=qc.TestType and qil.centreid=qc.processinglabid AND qil.ILCLabID=qc.`ILCLabID` AND qil.SquenceNo=0 ");
        sb.Append(" and qil.isReject=0 and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

      
        sb.Append(" WHERE isactive=1");
        sb.Append(" AND processinglabid=" + processingcentre + " ");
        sb.Append(" AND ilclabtypeid=" + ilclab.Split('#')[0]+ "");
        sb.Append(" AND qc.ilclabid=" + ilclab.Split('#')[1] + "");

        sb.Append(" union all ");


        sb.Append(" SELECT TestType,TestID,TestName,ifnull(qil.id,'')regisid,ifnull(qil.barcodeno,'') newbarcode,qc.SquenceNo   ");
        sb.Append(" FROM qc_ilcparametermapping_special qc ");
        sb.Append(" left join qc_ilcregistration qil on( qc.TestID=qil.investigationid or qc.`TestID`=qil.`LabObservationID`) and qil.MapType=qc.TestType and qil.centreid=qc.processinglabid and  qil.ILCLabID=qc.`ILCLabID`  AND  qil.SquenceNo=qc.SquenceNo ");
        sb.Append(" and qil.isReject=0 and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");


        sb.Append(" WHERE isactive=1");
        sb.Append(" AND processinglabid=" + processingcentre + " ");
        sb.Append(" AND ilclabtypeid=" + ilclab.Split('#')[0] + "");
        sb.Append(" AND qc.ilclabid=" + ilclab.Split('#')[1] + "");
        sb.Append(" AND cyear=" + regisyearandmonth.Split('#')[1] + " AND cmonth=" + regisyearandmonth.Split('#')[0] + " ");

        sb.Append(" )t order by SquenceNo,TestType desc,TestName asc");//group by TestType ,TestID 




        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string getpatientdata(string processingcentre, string searchvalue, string regisyearandmonth)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.`Patient_ID`,lt.`PName`,CONCAT(lt.`Age`,'/',lt.`Gender`)PDetail,plo.`ReportType`, 'Investigation' `MapType`,qil.ILCLabID,");
        sb.Append(" plo.test_id,plo.`LedgerTransactionNo`,plo.barcodeno,itemid,itemname,ifnull(qil1.id,'') savedid FROM `patient_labinvestigation_opd` plo ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` and plo.IsReporting=1 ");
        sb.Append(" inner join qc_ilcparametermapping qil on qil.testtype='Investigation' and qil.testid=plo.investigation_id");
        sb.Append(" and qil.ProcessingLabID=plo.TestCentreID and qil.isactive=1");

        sb.Append(" left join qc_ilcregistration qil1 on qil1.investigationid=plo.Investigation_ID and qil1.MapType='Investigation' and qil1.centreid=plo.TestCentreID AND  qil1.SquenceNo=qil.SquenceNo ");
        sb.Append(" and qil1.isReject=0 and qil1.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil1.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        sb.Append(" WHERE approved=1 AND TestCentreID='" + processingcentre + "' ");
        sb.Append(" and (plo.LedgerTransactionNo='" + searchvalue + "' or plo.barcodeno='"+searchvalue+"') ");

        



        sb.Append(" union all ");

        sb.Append(" SELECT lt.`Patient_ID`,lt.`PName`,CONCAT(lt.`Age`,'/',lt.`Gender`)PDetail,plo.`ReportType`, 'Observation' `MapType`,qil.ILCLabID,");
        sb.Append(" plo.test_id,plo.`LedgerTransactionNo`,plo.barcodeno,itemid,itemname,ifnull(qil1.id,'') savedid FROM `patient_labinvestigation_opd` plo ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` and plo.IsReporting=1 ");
        sb.Append(" inner join patient_labobservation_opd ploo on plo.test_id=ploo.test_id ");
        sb.Append(" inner join qc_ilcparametermapping qil on qil.testtype='Observation' and qil.testid=ploo.LabObservation_ID");
        sb.Append(" and qil.ProcessingLabID=plo.TestCentreID and qil.isactive=1");


        sb.Append(" left join qc_ilcregistration qil1 on qil1.MapType='Observation' and qil1.centreid=plo.TestCentreID AND  qil1.SquenceNo=qil.SquenceNo ");
        sb.Append(" and qil1.isReject=0 and qil1.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil1.EntryYear=" + regisyearandmonth.Split('#')[1] + "");
        sb.Append(" and qil1.LabObservationID=ploo.LabObservation_ID");


        sb.Append(" WHERE plo.approved=1 AND TestCentreID='" + processingcentre + "' ");



        sb.Append(" and (plo.LedgerTransactionNo='" + searchvalue + "' or plo.barcodeno='" + searchvalue + "') ");
        sb.Append(" group by test_id ");

         // Non Register Test
        sb.Append(" union all ");

        sb.Append(" SELECT lt.`Patient_ID`,lt.`PName`,CONCAT(lt.`Age`,'/',lt.`Gender`)PDetail,plo.`ReportType`, 'Investigation' `MapType`,qil.ILCLabID,");
        sb.Append(" plo.test_id,plo.`LedgerTransactionNo`,plo.barcodeno,itemid,itemname,ifnull(qil1.id,'') savedid FROM `patient_labinvestigation_opd` plo ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` and plo.IsReporting=1 ");
        sb.Append(" inner join qc_ilcparametermapping_special qil on qil.testtype='Investigation' and qil.testid=plo.investigation_id");
        sb.Append(" AND qil.cyear=" + regisyearandmonth.Split('#')[1] + " AND qil.cmonth=" + regisyearandmonth.Split('#')[0] + " ");
        sb.Append(" and qil.ProcessingLabID=plo.TestCentreID and qil.isactive=1");

        sb.Append(" left join qc_ilcregistration qil1 on qil1.investigationid=plo.Investigation_ID and qil1.MapType='Investigation' and qil1.centreid=plo.TestCentreID   AND qil1.ILCLabID = qil.`ILCLabID` AND  qil1.SquenceNo=qil.SquenceNo  ");
        sb.Append(" and qil1.isReject=0 and qil1.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil1.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        sb.Append(" WHERE approved=1 AND TestCentreID='" + processingcentre + "' ");
        sb.Append(" and (plo.LedgerTransactionNo='" + searchvalue + "' or plo.barcodeno='" + searchvalue + "') ");


        sb.Append(" union all ");

        sb.Append(" SELECT lt.`Patient_ID`,lt.`PName`,CONCAT(lt.`Age`,'/',lt.`Gender`)PDetail,plo.`ReportType`, 'Observation' `MapType`,qil.ILCLabID,");
        sb.Append(" plo.test_id,plo.`LedgerTransactionNo`,plo.barcodeno,itemid,itemname,ifnull(qil1.id,'') savedid FROM `patient_labinvestigation_opd` plo ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` and plo.IsReporting=1 ");
        sb.Append(" inner join patient_labobservation_opd ploo on plo.test_id=ploo.test_id ");
        sb.Append(" inner join qc_ilcparametermapping_special qil on qil.testtype='Observation' and qil.testid=ploo.LabObservation_ID");
        sb.Append(" AND qil.cyear=" + regisyearandmonth.Split('#')[1] + " AND qil.cmonth=" + regisyearandmonth.Split('#')[0] + " ");
        sb.Append(" and qil.ProcessingLabID=plo.TestCentreID  and qil.isactive=1");

        sb.Append(" left join qc_ilcregistration qil1 on  qil1.MapType='Observation' and qil1.centreid=plo.TestCentreID AND qil1.ILCLabID = qil.`ILCLabID` AND  qil1.SquenceNo=qil.SquenceNo");
        sb.Append(" and qil1.isReject=0 and qil1.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil1.EntryYear=" + regisyearandmonth.Split('#')[1] + "");
        sb.Append(" and qil1.LabObservationID=ploo.LabObservation_ID");


        sb.Append(" WHERE plo.approved=1 AND TestCentreID='" + processingcentre + "' ");
        sb.Append(" and (plo.LedgerTransactionNo='" + searchvalue + "' or plo.barcodeno='" + searchvalue + "')  ");

        sb.Append(" group by test_id ");      


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindTestParameter(string test_id, string regisyearandmonth)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ifnull(qil.id,'') mapid, IFNULL(qil1.id,'') savedid, ifnull(b.investigation_id,0)investigation_id, plo.`LabObservation_ID`,`LabObservationName`, ");
        sb.Append(" `value`,IFNULL(minvalue,'')minvalue,IFNULL(`maxvalue`,'')`maxvalue`,IFNULL(readingformat,'')readingformat, ");
        sb.Append(" IFNULL(displayreading,'')displayreading, IFNULL(plo.method,'')method FROM `patient_labobservation_opd` plo");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plo.`Test_ID` ");
        sb.Append(" left JOIN qc_ilcparametermapping qil ON qil.testtype='Observation' AND qil.testid=plo.LabObservation_ID ");
        sb.Append(" AND qil.ProcessingLabID=pli.TestCentreID AND qil.isactive=1");
        sb.Append(" LEFT JOIN  (SELECT im.investigation_id,im.name,lom.LabObservation_ID FROM investigation_master im ");
        sb.Append(" INNER JOIN `labobservation_investigation` lom ON lom.`Investigation_Id`=im.`Investigation_Id` AND im.`ReportType`=1  ");
        sb.Append("  GROUP BY im.investigation_id HAVING COUNT(*)=1) b ON plo.LabObservation_ID=b.LabObservation_ID   ");

        sb.Append(" LEFT JOIN qc_ilcregistration qil1 ON qil1.investigationid=b.Investigation_ID AND qil1.MapType='Observation' AND qil1.centreid=pli.TestCentreID ");
        sb.Append(" AND qil1.isReject=0 AND qil1.EntryMonth=" + regisyearandmonth.Split('#')[0] + " AND qil1.EntryYear=" + regisyearandmonth.Split('#')[1] + " ");
        sb.Append(" AND qil1.LabObservationID=plo.LabObservation_ID ");
        sb.Append("    WHERE plo.test_id=" + test_id + " ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string saveregister(List<ILCDataToSave> datatosave, string regisyearandmonth)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string LedgerTransactionID = string.Empty;
            string LedgerTransactionNo = string.Empty;



            var result = string.Join(",", datatosave.Select(i => i.TestID).ToArray());
            StringBuilder sb = new StringBuilder();
            sb.Append(" select lt.Patient_ID,lt.Pname,lt.age,lt.gender,lt.Panel_ID,lt.PanelName,lt.Doctor_ID,lt.DoctorName,'' OtherDoctorName,lt.ReferLab,");
            sb.Append(" lt.OtherReferLab,plo.TestCentreID CentreID,lt.PatientType,lt.VisitType,plo.Investigation_ID,plo.SubCategoryID,");
            sb.Append(" plo.AgeInDays,plo.ItemId,plo.itemname,plo.itemcode TestCode,plo.itemname  InvestigationName,plo.ReportType,plo.barcodeno");
            sb.Append(" ,plo.`Test_ID`, lt.LedgerTransactionID,lt.LedgerTransactionNo ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append(" ");
            sb.Append(" AND plo.`Test_ID` in (" + result.ToString() + ") ");
			
            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];


          
            if (dt.Rows.Count > 0)
            {
                int barcodecnt = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(1) FROM qc_ilcregistration  WHERE LabObservationID='" + dt.Rows[0]["Investigation_ID"] + "' And OLDbarcodeNo='" + dt.Rows[0]["barcodeno"] + "' AND CentreID='" + dt.Rows[0]["CentreID"] + "'  "));

                if (barcodecnt > 0)
                {
                    return "0#sample already registered with this centre";
                }
                Ledger_Transaction objlt = new Ledger_Transaction(tnx);
               
                objlt.DiscountOnTotal = 0;
                objlt.NetAmount = 0;
                objlt.GrossAmount = 0;
                objlt.IsCredit = 0;
                objlt.Patient_ID = Util.GetString(dt.Rows[0]["Patient_ID"]);
                objlt.PName = Util.GetString(dt.Rows[0]["Pname"]);
                objlt.Age = Util.GetString(dt.Rows[0]["Age"]);
                objlt.Gender = Util.GetString(dt.Rows[0]["gender"]);
                objlt.VIP = 0;
                objlt.Remarks = "ILC Registration";
                objlt.Panel_ID = Util.GetInt(dt.Rows[0]["Panel_ID"]);
                objlt.PanelName = Util.GetString(dt.Rows[0]["PanelName"]);
                objlt.Doctor_ID = Util.GetString(dt.Rows[0]["Doctor_ID"]);
                objlt.DoctorName = Util.GetString(dt.Rows[0]["DoctorName"]);
              
                objlt.OtherReferLab = Util.GetString(dt.Rows[0]["OtherReferLab"]);
           
                objlt.CentreID = Util.GetInt(dt.Rows[0]["CentreID"]);
                objlt.Adjustment = 0;
                objlt.CreatedByID = UserInfo.ID;
                objlt.PatientType = Util.GetString(dt.Rows[0]["PatientType"]);
                objlt.VisitType = Util.GetString(dt.Rows[0]["VisitType"]);
                objlt.CreatedBy = UserInfo.LoginName;


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

                foreach (ILCDataToSave ilc in datatosave)
                {
                    DataRow dw;
                    if (ilc.InvestigationID == 0)
                    {
                        dw = dt.Select("test_id=" + ilc.TestID + "")[0];
                    }
                    else{
                        sb = new StringBuilder();
                        sb.Append(" select lt.Patient_ID,lt.Pname,lt.age,lt.gender,lt.Panel_ID,lt.PanelName,lt.Doctor_ID,lt.DoctorName,'' OtherDoctorName,lt.ReferLab,");
                        sb.Append(" lt.OtherReferLab,plo.TestCentreID CentreID,lt.PatientType,lt.VisitType,im.investigation_id,imm.SubCategoryID,");
                        sb.Append(" plo.AgeInDays,imm.ItemId,concat(imm.testcode,' ~ ',imm.typename) itemname,imm.TestCode,im.name InvestigationName,im.ReportType,plo.barcodeno");
                        sb.Append(" ,plo.`Test_ID`, lt.LedgerTransactionID,lt.LedgerTransactionNo ");
                        sb.Append(" FROM `patient_labinvestigation_opd` plo INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
                        sb.Append(" inner join investigation_master im on im.investigation_id=" + ilc.InvestigationID + " ");
                        sb.Append(" inner join f_itemmaster imm on imm.type_id=im.investigation_id");
                        sb.Append(" ");
                        sb.Append(" AND plo.`Test_ID`=" + ilc .TestID+ " ");

                        DataTable dtc = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];
                        dw = dtc.Rows[0];


                    }

                        string sampleType = "";
                        sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT concat(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where `Investigation_Id`='" + dw["Investigation_ID"].ToString() + "' AND ist.`IsDefault`=1 "));

                        if (dtSample.Select("SampleType='" + sampleType.Split('#')[0] + "' and SubCategoryID='" + dw["SubCategoryID"].ToString() + "'").Length == 0)
                        {
                            Barcode = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_barcode('" + dw["SubCategoryID"].ToString() + "')").ToString();
                            DataRow dr = dtSample.NewRow();
                            dr["SampleType"] = sampleType.Split('#')[0];
                            dr["SubCategoryID"] = dw["SubCategoryID"].ToString();
                            dr["BarcodeNo"] = Barcode;
                            dtSample.Rows.Add(dr);
                            dtSample.AcceptChanges();
                        }
                        else
                            Barcode = dtSample.Select("SampleType='" + sampleType.Split('#')[0] + "' and SubCategoryID='" + dw["SubCategoryID"].ToString() + "'")[0]["BarcodeNo"].ToString();


                        Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
                        objPlo.LedgerTransactionID =Util.GetInt(LedgerTransactionID);
                        objPlo.LedgerTransactionNo = LedgerTransactionNo;
                        objPlo.Patient_ID = Util.GetString(dw["Patient_ID"]);
                        objPlo.AgeInDays = Util.GetInt(dw["AgeInDays"]);
                        objPlo.Gender = Util.GetString(dw["Gender"]);
                        objPlo.BarcodeNo = Barcode;
                        objPlo.ItemId = Util.GetInt(dw["ItemId"]);

                        objPlo.ItemName = Util.GetString(dw["ItemName"]).ToUpper();
                        objPlo.ItemCode = Util.GetString(dw["TestCode"]);
                       // objPlo.InvestigationName = Util.GetString(dw["InvestigationName"]).ToUpper();
                        objPlo.PackageName = "";
                        objPlo.PackageCode = "";

                        objPlo.Investigation_ID = Util.GetInt(dw["Investigation_ID"]);
                        objPlo.IsPackage = 0;
                        objPlo.SubCategoryID = Util.GetInt(dw["SubCategoryID"]);
                        objPlo.Rate = 0;
                        objPlo.Amount = 0;
                        objPlo.DiscountAmt = 0;
                        objPlo.DiscountByLab = 0;
                        objPlo.CouponAmt = 0;
                      
                        objPlo.Quantity = 1;
                        objPlo.IsRefund = 0;
                        objPlo.IsReporting = 1;
                        objPlo.ReportType = Util.GetByte(dw["ReportType"]);
                        objPlo.CentreID = Util.GetInt(dw["CentreID"]);
                        objPlo.TestCentreID = 0;
                        objPlo.IsSampleCollected = "S";
                        objPlo.barcodePreprinted = 0;

                        objPlo.SampleCollector = UserInfo.LoginName;
                        objPlo.SampleCollectionBy = UserInfo.ID;


                       // objPlo.Sampledate = Util.GetDateTime(DateTime.Now);
                        objPlo.SampleCollectionDate = Util.GetDateTime(DateTime.Now);

                        try
                        {
                            objPlo.SampleTypeID =Util.GetInt(sampleType.Split('#')[0]);
                            objPlo.SampleTypeName = sampleType.Split('#')[1];
                        }
                        catch
                        {
                        }

                        objPlo.SampleBySelf = 0;
                        objPlo.isUrgent = 0;
                        objPlo.DeliveryDate = Util.GetDateTime(DateTime.Now);
                        objPlo.SRADate = Util.GetDateTime(DateTime.Now);


                        objPlo.IsScheduleRate = 0;
                        objPlo.MRP = 0;
                        objPlo.Date = DateTime.Now;
                       
                        string ID = objPlo.Insert();

                        if (ID == string.Empty)
                        {
                            tnx.Rollback();
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }
  sb = new StringBuilder();
                        sb.Append(" insert into sample_logistic(testid,barcodeno,barcode_group,fromcentreid,tocentreid,status,EntryBy) ");
                        sb.Append(" values ");
                        sb.Append(" (@testid,@barcodeno,@barcode_group,@fromcentreid,@tocentreid,@status,@EntryBy) ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                             new MySqlParameter("@testid", ID),
                             new MySqlParameter("@BarcodeNo", objPlo.BarcodeNo),
                               new MySqlParameter("@barcode_group", objPlo.BarcodeNo),
                                    new MySqlParameter("@fromcentreid", Util.GetInt(dt.Rows[0]["CentreID"])),
                                      new MySqlParameter("@tocentreid", Util.GetInt(dt.Rows[0]["CentreID"])),
                                     new MySqlParameter("@status", "Transferred"),
                                    new MySqlParameter("@EntryBy", UserInfo.ID));

                        if (ilc.MapType == "Investigation")
                        {
                            int maxseqno = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1) FROM qc_ilcregistration WHERE InvestigationID=" + objPlo.Investigation_ID + " and EntryMonth=" + regisyearandmonth.Split('#')[0] + " and EntryYear=" + regisyearandmonth.Split('#')[1] + " and CentreID=" + Util.GetInt(dt.Rows[0]["CentreID"]) + " and MapType='Investigation' and isreject=0 "));
                           
                            sb = new StringBuilder();
                            sb.Append(" insert into qc_ilcregistration");
                            sb.Append("(CentreID,OLDLedgerTransactionID,OLDLedgerTransactionNo,OLDTest_id,OLDbarcodeNo,BarcodeNo,");
                            sb.Append(" LedgerTransactionID,LedgerTransactionNo,Test_id,InvestigationID,LabObservationID, ");
                            sb.Append("MapType,EntryMonth,EntryYear,EntryDateTime,EntryByUserID,EntryByName,ILCLabID,SquenceNo) ");
                            sb.Append(" values ");
                            sb.Append("(@CentreID,@OLDLedgerTransactionID,@OLDLedgerTransactionNo,@OLDTest_id,@OLDbarcodeNo,@BarcodeNo,");
                            sb.Append(" @LedgerTransactionID,@LedgerTransactionNo,@Test_id,@InvestigationID,@LabObservationID, ");
                            sb.Append("@MapType,@EntryMonth,@EntryYear,@EntryDateTime,@EntryByUserID,@EntryByName,@ILCLabID,@SquenceNo) ");

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@CentreID", Util.GetInt(dt.Rows[0]["CentreID"])),
                                 new MySqlParameter("@OLDLedgerTransactionID", Util.GetInt(dt.Rows[0]["LedgerTransactionID"])),
                                  new MySqlParameter("@OLDLedgerTransactionNo", Util.GetString(dt.Rows[0]["LedgerTransactionNo"])),
                                    new MySqlParameter("@OLDTest_id", Util.GetInt(dw["Test_ID"])),
                                      new MySqlParameter("@OLDbarcodeNo", Util.GetString(dw["barcodeNo"])),
                                        new MySqlParameter("@BarcodeNo", objPlo.BarcodeNo),
                                         new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                          new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                           new MySqlParameter("@Test_id", ID),
                                            new MySqlParameter("@InvestigationID", objPlo.Investigation_ID),
                                             new MySqlParameter("@LabObservationID", "0"),
                                              new MySqlParameter("@MapType", "Investigation"),
                                               new MySqlParameter("@EntryMonth", regisyearandmonth.Split('#')[0]),
                                                new MySqlParameter("@EntryYear", regisyearandmonth.Split('#')[1]),
                                                 new MySqlParameter("@EntryDateTime", DateTime.Now),
                                                  new MySqlParameter("@EntryByUserID", UserInfo.ID),
                                                   new MySqlParameter("@EntryByName", UserInfo.LoginName),
                                                   new MySqlParameter("@ILCLabID", ilc.ILCLabID),
                                                   new MySqlParameter("@SquenceNo", maxseqno));

                        }

                        if (ilc.MapType == "Observation")
                        {

                            DataTable dtc = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT labObservation_ID FROM (SELECT loi.labObservation_ID FROM `labobservation_investigation` loi INNER JOIN qc_ilcparametermapping ql ON ql.TestID=loi.labObservation_ID AND ql.TestType='Observation' AND ql.ProcessingLabID=" + Util.GetInt(dt.Rows[0]["CentreID"]) + " and ql.isactive=1 WHERE loi.investigation_id=" + objPlo.Investigation_ID + " union all  SELECT loi.labObservation_ID FROM `labobservation_investigation` loi INNER JOIN qc_ilcparametermapping_special ql ON ql.TestID=loi.labObservation_ID AND ql.TestType='Observation' AND ql.ProcessingLabID=" + Util.GetInt(dt.Rows[0]["CentreID"]) + " and ql.isactive=1 WHERE loi.investigation_id=" + objPlo.Investigation_ID + " )a GROUP BY labObservation_ID").Tables[0];

                            foreach (DataRow dr in dtc.Rows)
                            {
                                int maxseqno = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1) FROM qc_ilcregistration WHERE LabObservationID=" + dr["labObservation_ID"] + " and EntryMonth=" + regisyearandmonth.Split('#')[0] + " and EntryYear=" + regisyearandmonth.Split('#')[1] + " and CentreID=" + Util.GetInt(dt.Rows[0]["CentreID"]) + " and MapType='Observation' and isreject=0 "));
                               
                                sb = new StringBuilder();
                                sb.Append(" insert into qc_ilcregistration");
                                sb.Append("(CentreID,OLDLedgerTransactionID,OLDLedgerTransactionNo,OLDTest_id,OLDbarcodeNo,BarcodeNo,");
                                sb.Append(" LedgerTransactionID,LedgerTransactionNo,Test_id,InvestigationID,LabObservationID, ");
                                sb.Append("MapType,EntryMonth,EntryYear,EntryDateTime,EntryByUserID,EntryByName,ILCLabID,SquenceNo) ");
                                sb.Append(" values ");
                                sb.Append("(@CentreID,@OLDLedgerTransactionID,@OLDLedgerTransactionNo,@OLDTest_id,@OLDbarcodeNo,@BarcodeNo,");
                                sb.Append(" @LedgerTransactionID,@LedgerTransactionNo,@Test_id,@InvestigationID,@LabObservationID, ");
                                sb.Append("@MapType,@EntryMonth,@EntryYear,@EntryDateTime,@EntryByUserID,@EntryByName,@ILCLabID,@SquenceNo) ");

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@CentreID", Util.GetInt(dt.Rows[0]["CentreID"])),
                                      new MySqlParameter("@OLDLedgerTransactionID", Util.GetInt(dt.Rows[0]["LedgerTransactionID"])),
                                  new MySqlParameter("@OLDLedgerTransactionNo", Util.GetString(dt.Rows[0]["LedgerTransactionNo"])),
                                      new MySqlParameter("@OLDTest_id", Util.GetInt(dw["Test_ID"])),
                                       new MySqlParameter("@OLDbarcodeNo", Util.GetString(dw["barcodeNo"])),
                                        new MySqlParameter("@BarcodeNo", objPlo.BarcodeNo),
                                     new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                      new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                       new MySqlParameter("@Test_id", ID),
                                        new MySqlParameter("@InvestigationID", objPlo.Investigation_ID),
                                         new MySqlParameter("@LabObservationID", dr["labObservation_ID"]),
                                          new MySqlParameter("@MapType", "Observation"),
                                           new MySqlParameter("@EntryMonth", regisyearandmonth.Split('#')[0]),
                                            new MySqlParameter("@EntryYear", regisyearandmonth.Split('#')[1]),
                                             new MySqlParameter("@EntryDateTime", DateTime.Now),
                                              new MySqlParameter("@EntryByUserID", UserInfo.ID),
                                                new MySqlParameter("@EntryByName", UserInfo.LoginName),
                                                new MySqlParameter("@ILCLabID", ilc.ILCLabID),
                                                new MySqlParameter("@SquenceNo", maxseqno)
                                    );
                            }

                        }                   
                }
            }

            tnx.Commit();
            return "1#" + LedgerTransactionID + "_" + LedgerTransactionNo;
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string SaveData(List<ILCDataMonth1> ilcdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            foreach (ILCDataMonth1 ilc in ilcdata)
            {
                int maxseqno = Util.GetInt(StockReports.ExecuteScalar("SELECT MAX(SquenceNo) FROM qc_ilcparametermapping_special WHERE TestID=" + ilc.TestID + " and CMonth=" + ilc.CMonth + " and CYear=" + ilc.CYear + ""));
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO qc_ilcparametermapping_special ");
                    sb.Append("  (ProcessingLabID,ProcessingLabName,ILCLabTypeID,ILCLabType,ILCLabID,ILCLabName, ");
                    sb.Append("   TestType,TestID,TestName,AcceptablePer,Rate,Cmonth,Cyear, EntryDate,EntryByID,EntryByName,AddedParameter,SquenceNo) ");
                    sb.Append("  VALUES (@ProcessingLabID,@ProcessingLabName,@ILCLabTypeID,@ILCLabType,@ILCLabID,@ILCLabName, ");
                    sb.Append("             @TestType,@TestID,@TestName,@AcceptablePer,@Rate,@CMonth,@CYear,@EntryDate,@EntryByID,@EntryByName,1,@SquenceNo); ");

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@ProcessingLabID", ilc.ProcessingLabID),
                       new MySqlParameter("@ProcessingLabName", ilc.ProcessingLabName),
                       new MySqlParameter("@ILCLabTypeID", ilc.ILCLabTypeID),
                       new MySqlParameter("@ILCLabType", ilc.ILCLabType),
                       new MySqlParameter("@ILCLabID", ilc.ILCLabID),
                       new MySqlParameter("@ILCLabName", ilc.ILCLabName),
                       new MySqlParameter("@TestType", ilc.TestType),
                       new MySqlParameter("@TestID", ilc.TestID),
                       new MySqlParameter("@TestName", ilc.TestName),
                       new MySqlParameter("@AcceptablePer", ilc.AcceptablePer),
                       new MySqlParameter("@Rate", ilc.Rate),
                       new MySqlParameter("@CMonth", ilc.CMonth),
                       new MySqlParameter("@CYear", ilc.CYear),
                       new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                       new MySqlParameter("@EntryByID", UserInfo.ID),
                       new MySqlParameter("@EntryByName", UserInfo.LoginName),
                       new MySqlParameter("@SquenceNo", maxseqno + 1)
                       );                             

            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());
        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }
  
}


public class ILCDataToSave
{
    public int TestID {get;set;}
    public int InvestigationID {get;set;}
    public string MapType {get;set;}
    public string ILCLabID { get; set; }    
}
public class ILCDataMonth1
{   
    public string ProcessingLabID { get; set; }
    public string ProcessingLabName { get; set; }

    public string ILCLabTypeID { get; set; }
    public string ILCLabType { get; set; }

    public string ILCLabID { get; set; }
    public string ILCLabName { get; set; }

    public string TestType { get; set; }
    public string TestID { get; set; }
    public string TestName { get; set; }
    public string Rate { get; set; }
    public string AcceptablePer { get; set; }
    public string CMonth { get; set; }
    public string CYear { get; set; }
    public string Fequency { get; set; }

}

 