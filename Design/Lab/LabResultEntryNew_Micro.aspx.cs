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
using System.IO;
using System.Web.Script.Services;
using System.Web.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Web.Script.Serialization;
using SD = System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
public partial class Design_Lab_LabResultEntryNew_Micro : System.Web.UI.Page
{

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    public string DoctorID = "LSHHI233";
    public string isApproval = "0", IsHold = "0", SampleReceive = "0";
    public string RoleID = string.Empty, Test_ID = string.Empty, Investigation_Id = string.Empty, ID = string.Empty, ReportType = string.Empty, rowColor = string.Empty, Othersample = string.Empty;
    public static string LabNo = "";//, Barcodeno = "";
    public static string TestID = "";
    public string isapproved = "0";
    public string isresult = "0";
    public string approvedby = "";
    public string approveddate = "";
    public DateTime SampleReceiveDate;
    protected void Page_Load(object sender, EventArgs e)
    {
        TestID = Request.QueryString["TestID"].ToString();
        LabNo = Request.QueryString["LabNo"].ToString();
        Investigation_Id = Request.QueryString["InvId"].ToString();
        txtreportdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

        if (!IsPostBack)
        {
            bindComments();

        }
        if (Session["RoleID"] == null)
        {
            Response.Redirect("~/Design/Default.aspx");
        }

        bindfields();
      
    }
    private void holdreason()
    {
        ddlholdreason.DataSource = StockReports.GetDataTable("SELECT id,NAME FROM f_holdreason_master WHERE active=1 ORDER BY NAME");
        ddlholdreason.DataTextField = "NAME";
        ddlholdreason.DataValueField = "NAME";
        ddlholdreason.DataBind();
        ddlholdreason.Items.Insert(0, new ListItem("", ""));
    }

    private void bindfields()
    {

        /***Bind Organism Master***/

        ddlOrganism.DataSource = StockReports.GetDataTable("SELECT id,NAME FROM micro_master WHERE isactive=1 AND typename='Organism Master' order by name ");
        ddlOrganism.DataTextField = "NAME";
        ddlOrganism.DataValueField = "id";
        ddlOrganism.DataBind();
        ddlOrganism.Items.Insert(0, new ListItem("Select", "0"));

        /***Field isApproval***/

        string str = " SELECT IFNULL(( SELECT Approval FROM f_approval_labemployee WHERE EmployeeID='" + Session["id"].ToString() + "' " +
        " AND RoleID='" + Session["RoleID"].ToString() + "' ORDER BY Approval DESC LIMIT 1 ) ,  " +
        " ( " +
        " SELECT Approval FROM f_approval_labemployee  " +
        " WHERE TechnicalId='" + Session["id"].ToString() + "'  " +
        " AND RoleID='" + Session["RoleID"].ToString() + "' LIMIT 1 " +
        " ) ) a2 ";
        DataTable strDT = StockReports.GetDataTable(str);
        if (strDT != null && strDT.Rows.Count > 0 && Util.GetString(strDT.Rows[0][0]) != "")
            isApproval = Util.GetString(strDT.Rows[0][0]);

        /***Public Mandatory Fields From patient_labinvestigation_opd***/

        DataTable dt = StockReports.GetDataTable("SELECT barcodeno,Approved,IsHold,result_flag,ApprovedName,DATE_FORMAT(ApprovedDate,'%d-%b-%Y %h:%i') ApprovedDate,IF(IFNULL(SampleReceiveDate,'')='',DATE,SampleReceiveDate) SampleReceiveDate,sampletypename SampleType,'' othersampletype,CASE  WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' WHEN pli.IsFOReceive='1' THEN '#E9967A' WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF' WHEN pli.Approved='1' And pli.isHold='0' THEN '#90EE90' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='0'AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R' THEN '#FFC0CB' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='0' AND isPartial_Result='1'  THEN '#A9A9A9' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='1' THEN '#3399FF' when pli.Result_Flag='0' and pli.isrerun='1' then '#F781D8'  WHEN pli.Result_Flag='0' And (SELECT COUNT(*) FROM mac_data mac WHERE mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 THEN '#E2680A' WHEN pli.isHold='1' THEN '#FFFF00'  WHEN pli.IsSampleCollected='N' OR pli.IsSampleCollected='S' THEN '#CC99FF' WHEN pli.IsSampleCollected='R' THEN '#B0C4DE' ELSE '#FFFFFF' END rowColor FROM patient_labinvestigation_opd pli where test_id='" + TestID + "' ");
      //  Barcodeno = dt.Rows[0]["barcodeno"].ToString();
        isapproved = dt.Rows[0]["Approved"].ToString();
        isresult = dt.Rows[0]["result_flag"].ToString();
        if (isapproved == "1")
        {
            approvedby = dt.Rows[0]["ApprovedName"].ToString();
            approveddate = dt.Rows[0]["ApprovedDate"].ToString();
        }
        lblOtherAndSampleType.Text = dt.Rows[0]["SampleType"].ToString();
        IsHold = dt.Rows[0]["IsHold"].ToString();
        Othersample = dt.Rows[0]["othersampletype"].ToString();
        rowColor = dt.Rows[0]["rowColor"].ToString();
        SampleReceiveDate = DateTime.Parse(dt.Rows[0]["SampleReceiveDate"].ToString()).AddHours(48);
        txtSchedulerDate.Text = SampleReceiveDate.ToString("dd-MMM-yyyy");
        txtSchedulerTime.Text = SampleReceiveDate.ToString("HH:mm:ss");
        if (DateTime.Now < SampleReceiveDate)
        { SampleReceive = "1"; }
        /***Public Mandatory Fields From patient_labobservation_opd_mic***/

        DataTable dt1 = StockReports.GetDataTable("SELECT reporttype,DATE_FORMAT(ResultEntrydateTime,'%d-%b-%Y %h:%m') ResultEntrydateTime FROM patient_labobservation_opd_mic WHERE TestID='" + TestID + "' LIMIT 1 ");

        if (dt1.Rows.Count > 0)
        {
            lbstatus.Text = Util.GetString(dt1.Rows[0]["reporttype"].ToString());
            lbrptime.Text = Util.GetString(dt1.Rows[0]["ResultEntrydateTime"].ToString());
        }
        
        txtComments.InnerHtml = StockReports.ExecuteScalar("SELECT comments FROM patient_labinvestigation_opd_comments WHERE Test_ID='" + TestID + "'");
    }
    private string PatientDetail(string TestID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select CONCAT('BarCodeNo : ',plo.`BarCodeNo`,'   `     Patient Name : ',pm.Title,pm.Pname,'   `     Age : ',pm.Age,'/',LEFT(pm.`Gender`,1) ,'   `     Doctor : ',df.`Name`,'   `     Panel Name : ',fpm.`Company_Name`,'   `     SampleTypeName : ',IFNULL(plo.`SampleTypeName`,''),' ~ ',IFNULL(plo.`OtherSampleType`,''))PatientDetail ");
        sb.Append(" from  `f_ledgertransaction` lt  ");
        sb.Append(" inner join doctor_referal df on df.`Doctor_ID`=lt.`Doctor_ID` inner join f_panel_master fpm on fpm.`Panel_ID`=lt.`Panel_ID` ");
        sb.Append(" inner join `patient_master` pm on pm.`Patient_ID`=lt.`Patient_ID` INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionNo`=lt.`LedgerTransactionNo`    WHERE plo.`Test_ID`='" + TestID + "' ; ");
       
        string _rtn = StockReports.ExecuteScalar(sb.ToString());
        return _rtn;
    }
    [WebMethod]
    public static string BindSampleType(string Investigation_Id)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT SampleTypeID,SampleTypeName FROM investigations_sampletype where Investigation_ID='" + Investigation_Id + "' order by IsDefault DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count == 0)
        {
            sb = new StringBuilder();
            sb.Append("SELECT ID SampleTypeID,Samplename SampleTypeName FROM `sampletype_master` WHERE IFNULL(Samplename,'')<>'' order by Samplename ");
            dt = StockReports.GetDataTable(sb.ToString());
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    //bilal
    [WebMethod]
    public static string SchedulerApproval(string testid, string DateTime)
    {
        MySqlConnection con =  Util.GetMySqlCon();
        con.Open();
        try
        {
           string str = "update patient_labinvestigation_opd set isHold=1,  ";
           str += " IsSchedulerApproval=1,SchedulerApprovalDateTime=@SchedulerApprovalDateTime";
           str += " where test_id=@test_id ";
          
           MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str,
           new MySqlParameter("@SchedulerApprovalDateTime", Util.GetDateTime(DateTime)),
           new MySqlParameter("@test_id", testid)
            );
           return "1";
          //  string isap = StockReports.ExecuteScalar("SELECT Approval FROM f_approval_labemployee WHERE EmployeeID='233' AND RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "' and TechnicalId='" + HttpContext.Current.Session["id"].ToString() + "' ");
          //  if (isap == "3" || isap == "4")
          //  {
          //      string str = "update patient_labinvestigation_opd set isHold=1,  ";
          //      str += " IsSchedulerApproval=1,SchedulerApprovalDateTime=@SchedulerApprovalDateTime";
          //      str += " where test_id=@test_id ";
          //
          //      MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str,
          //      new MySqlParameter("@SchedulerApprovalDateTime", Util.GetDateTime(DateTime)),
          //      new MySqlParameter("@test_id", testid)
          //       );
          //      return "1";
          //  }
          //  else
            //    return "You don't have rights of schedule approval!! ";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
           
            return "-1";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindMICOrganismAnti(string Barcodeno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT  distinct mm.`id`,mm.`Name` name ,mov.reading  FROM   micro_master mm INNER JOIN " + Util.getApp("MachineDB") + ".`mac_observation_bd` mov ON mov.`Machine_ParamID`=mm.`Machine_ParamID`  ");
        sb.Append(" WHERE mov.labno='" + Barcodeno + "' AND mov.type='1'");// AND mov.type='1'  GROUP BY mov.Machine_ParamID ");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT OrganismID id,OrganismName name  FROM `patient_labobservation_opd_mic` WHERE testid='"+TestID+"' AND OrganismName<>''");
            dt = StockReports.GetDataTable(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }


    [WebMethod]
    public static string Bindobsgroupenzyme(string obid, string obname, string testid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT distinct '" + obid + "' obid,'" + obname + "' obname, mm.name,mm.id,mm.Method,IFNULL(plo.enzymevalue,'') VALUE, plo.value mmvalue,'0' Approved,'' ReadingFormat ,'0' Result_Flag,masterid groupid,(SELECT NAME FROM micro_master WHERE id=masterid) groupname FROM  micro_master_mapping mmm ");
        sb.Append(" INNER JOIN micro_master mm ON mmm.mapmasterid=mm.id ");
        sb.Append(" AND masterid = ");
        //sb.Append(" (SELECT masterid FROM micro_master_mapping WHERE maptypeid='6' AND masterid='" + obid + "' LIMIT 1) ");
       // sb.Append("  LEFT JOIN patient_labobservation_opd_mic plo ON plo.testid='" + testid + "' AND plo.`EnzymeId`= mm.id and organismid='" + obid + "' GROUP BY mm.id  order by mm.name ");//AND OrganismGroupToEnzyme='1'
        sb.Append(" (SELECT masterid FROM micro_master_mapping WHERE maptypeid='2' AND mapmasterid='" + obid + "') ");
        sb.Append(" AND OrganismGroupToEnzyme='1' LEFT JOIN patient_labobservation_opd_mic plo ON plo.testid='" + testid + "' AND plo.`EnzymeId`= mm.id and organismid='" + obid + "' GROUP BY mm.id  order by mm.name ");
		//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\org.txt",sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindInvestigationobsearvation(string Test_ID, string Investigation_Id, string LabNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT distinct  IFNULL( ( SELECT GROUP_CONCAT(HELP ORDER BY HELP ASC SEPARATOR '|' ) FROM LabObservation_Help loh ");
        sb.Append(" INNER JOIN LabObservation_Help_Master lhm ON lhm.id=loh.HelpId AND isactive=1 ");
        sb.Append(" WHERE LabObservation_ID=lm.`LabObservation_ID` ORDER BY HELP),'0') helpoption, ");
        sb.Append("  lom.`labObservation_ID`,lm.`Name` obName, '' Method, pli.Result_Flag ,pli.Approved,DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%m') sampledate,DATE_FORMAT(pli.sampleCollectionDate,'%d-%b-%Y %h:%m') sampleCollectionDate,DATE_FORMAT(now(),'%d-%b-%Y %h:%m') reportdate,");
        sb.Append(" IF(pli.Approved=0 AND IFNULL(plo.value,'')='',md.`Reading`,IFNULL(plo.value,'')) VALUE  ,  ");
        sb.Append("  IF(IFNULL(plo.Unit,'')<>'' AND pli.result_flag=1, plo.Unit,'')ReadingFormat,lm.iscomment,'' Description, ");
        sb.Append(" ifnull((SELECT GROUP_CONCAT( DISTINCT OrganismID) FROM patient_labobservation_opd_mic WHERE testid='" + Test_ID + "'  AND OrganismID<>''),'0') organism,(SELECT MethodName FROM labobservation_range lr WHERE lr.`LabObservation_ID`=lom.`labObservation_ID` and lr.MethodName<>'' AND pli.centreid=lr.centreid limit 1 ) MethodName,pli.Barcodeno ");
        sb.Append(" FROM `labobservation_investigation` lom ");
        sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=lom.`labObservation_ID` ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.`LedgerTransactionNo`='" + LabNo + "' AND pli.`Test_ID`='" + Test_ID + "' ");
        //
        sb.Append(" LEFT JOIN mac_data md ON md.`Test_id`=pli.`Test_ID` AND md.`LabObservation_ID`=lm.`LabObservation_ID` ");
        sb.Append(" LEFT JOIN `patient_labobservation_opd_mic` plo ON plo.`TestID`=pli.`Test_ID` AND plo.`LabObservation_ID`=lom.`labObservation_ID` ");
        sb.Append(" WHERE lom.investigation_id='" + Investigation_Id + "' ORDER BY lom.`printOrder` ");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    

    [WebMethod]
    public static string Bindantibiotics(string obid, string obname, string testid, string Barcodeno)
    {
		
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  distinct IFNULL(mov.reading,'') machinereading, IFNULL(mov.`mic`,'') Interpretation, '" + obid + "' obid,'" + obname + "' obname, mm.name,mm.id, ");
        sb.Append("( CASE WHEN  (IF(plo.AntibioticInterpreatation<>'',plo.AntibioticInterpreatation,IFNULL(mov.`mic`,''))='I') THEN   'Intermediate' ");
        sb.Append(" WHEN  (IF(plo.AntibioticInterpreatation<>'',plo.AntibioticInterpreatation,IFNULL(mov.`mic`,''))='S') THEN   'Sensitive'  WHEN  (IF(plo.AntibioticInterpreatation<>'',plo.AntibioticInterpreatation,IFNULL(mov.`mic`,''))='R') THEN   'Resistant' ");
        sb.Append(" ELSE   IFNULL(plo.AntibioticInterpreatation,'')   END)  VALUE, ");
        sb.Append(" '0' Approved,'' ReadingFormat ,'0' Result_Flag,ifnull(plo.breakpoint,mmm.`breakpoint`) breakpoint,");
        sb.Append(" IF(plo.mic<>'',plo.mic,IFNULL(mov.reading,''))   mic,ifnull(plo.mic_bp,'') mic_bp,  ");
     // sb.Append(" (SELECT ID FROM micro_master WHERE id=(SELECT masterid FROM micro_master_mapping WHERE mapmasterid=mm.id AND typeid=2 limit 1) limit 1) AntibioticGroupID, ");
     // sb.Append(" (SELECT NAME FROM micro_master WHERE id=(SELECT masterid FROM micro_master_mapping WHERE mapmasterid=mm.id AND typeid=2 limit 1) limit 1) AntibioticGroupName ");
     // sb.Append(" FROM  micro_master_mapping mmm INNER JOIN micro_master mm ON mmm.mapmasterid=mm.id   ");
     // sb.Append(" AND masterid = ");
     // sb.Append(" (SELECT masterid FROM micro_master_mapping WHERE maptypeid='6' AND masterid='" + obid + "' Limit 1) ");
     // sb.Append("     LEFT  JOIN  " + AllGlobalFunction.MachineDB + ".`mac_observation_bd` mov ON  mm.`Machine_ParamID`=mov.`Machine_ParamID` AND mov.`Type`='2' and mov.labno='" + Barcodeno + "' AND mm.`Machine_ParamID` IS NOT NULL   LEFT JOIN patient_labobservation_opd_mic plo ON plo.testid='" + testid + "' AND plo.`Antibioticid`= mm.id  AND plo.`OrganismID` ='" + obid + "' GROUP BY id order by mm.name ");  //AND OrganismGroupToAntibiotic='1'

        sb.Append(" (SELECT ID FROM micro_master WHERE id=(SELECT masterid FROM micro_master_mapping WHERE mapmasterid=mm.id AND typeid=3 limit 1) limit 1) AntibioticGroupID, ");
        sb.Append(" (SELECT NAME FROM micro_master WHERE id=(SELECT masterid FROM micro_master_mapping WHERE mapmasterid=mm.id AND typeid=3 limit 1) limit 1) AntibioticGroupName ");
        sb.Append(" FROM  micro_master_mapping mmm INNER JOIN micro_master mm ON mmm.mapmasterid=mm.id   ");
        sb.Append(" AND masterid = ");
        sb.Append(" (SELECT masterid FROM micro_master_mapping WHERE maptypeid='2' AND mapmasterid='" + obid + "') ");
        sb.Append(" AND OrganismGroupToAntibiotic='1'    LEFT  JOIN  " + AllGlobalFunction.MachineDB + ".`mac_observation_bd` mov ON  mm.`Machine_ParamID`=mov.`Machine_ParamID` AND mov.`Type`='2' and mov.labno='" + Barcodeno + "' AND mm.`Machine_ParamID` IS NOT NULL   LEFT JOIN patient_labobservation_opd_mic plo ON plo.testid='" + testid + "' AND plo.`Antibioticid`= mm.id  AND plo.`OrganismID` ='" + obid + "' GROUP BY id order by mm.name ");
		//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\org2.txt",sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string Bindantibioticsagainsanzyme(string enyid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  mapmasterid FROM micro_master_mapping mmm WHERE typeid='5' AND maptypeid='4' AND masterid='" + enyid + "' ");
       
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string SaveResult(List<string[]> observationdata, List<string[]> orgasismandenzyme, List<string[]> organismantibiotics, string Approved, string DeliveryDateTime, string Comments, string Sample_Type, string Sample_ID, string OtherSample_Type, string Investigation_Id, string Method)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            string Reporttype = "";
            string strDelete = "delete from patient_labobservation_opd_mic where testid=@testid";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strDelete,
                new MySqlParameter("@testid", Util.GetString(observationdata[0][0])));

            //string strDelete1 = "DELETE from patientwise_interpretation where Test_ID=@testid";
            //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strDelete1,
            //    new MySqlParameter("@testid", Util.GetString(observationdata[0][0])));

            //StringBuilder sb = new StringBuilder();
            //sb.Append("INSERT INTO patientwise_interpretation(LedgertransactionNo,Investigation_ID,LabObservation_ID,Test_ID,UserID,UserName,dtEntry,IpAddress,Interpretation,Updatedate) ");
            //sb.Append(" VALUES('" + LabNo.Trim() + "','" + Investigation_Id + "',0,'" + Util.GetString(observationdata[0][0]) + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["UserName"].ToString() + "',NOW(),'" + StockReports.getip() + "',(SELECT Interpretation FROM investigation_master WHERE Investigation_ID='" + Investigation_Id + "' ),NOW()); ");
            //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
            foreach (string[] obs in observationdata)
            {
                Reporttype = Util.GetString(obs[5]);
                Patient_lab_ObservationOPD_MIC plo = new Patient_lab_ObservationOPD_MIC(Tnx);
                plo.testid = Util.GetString(obs[0]);
                plo.labobservation_id = Util.GetString(obs[1]);
                plo.labobservation_name = Util.GetString(obs[2]);
                plo.value = Util.GetString(obs[3]);
                plo.unit = Util.GetString(obs[4]);
                plo.LabObservationComment = "";
                plo.Reporttype = Util.GetString(obs[5]);
                if (Util.GetString(obs[5]) == "Final")
                {
                    plo.ResultEntrydateTime = Util.GetDateTime(System.DateTime.Now);
                }
                else
                {
                    plo.ResultEntrydateTime = Util.GetDateTime(obs[6]);
                }
                plo.Result_flag = 1;
                plo.IPAddress = StockReports.getip();
                plo.Insert();
                //sb = new StringBuilder();
                //sb.Append("INSERT INTO patientwise_interpretation(LedgertransactionNo,Investigation_ID,LabObservation_ID,Test_ID,UserID,UserName,dtEntry,IpAddress,Interpretation,Updatedate) ");
                //sb.Append(" VALUES('" + LabNo.Trim() + "',0,'" + Util.GetString(obs[1]) + "','" + Util.GetString(obs[0]) + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["UserName"].ToString() + "',NOW(),'" + StockReports.getip() + "',(SELECT Interpretation FROM labobservation_master WHERE LabObservation_ID='" + Util.GetString(obs[1]) + "' ),NOW()); ");
                //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
            }
            foreach (string[] obs in orgasismandenzyme)
            {
                Reporttype = Util.GetString(obs[9]);
                Patient_lab_ObservationOPD_MIC plo = new Patient_lab_ObservationOPD_MIC(Tnx);
                plo.testid = Util.GetString(obs[0]);
                plo.OrganismID = Util.GetString(obs[1]);
                plo.OrganismName = Util.GetString(obs[2]);
                plo.OrganismGroupID = Util.GetString(obs[3]);
                plo.OrganismGroupName = Util.GetString(obs[4]);
                plo.EnzymeId = Util.GetString(obs[5]);
                plo.Enzymename = Util.GetString(obs[6]);
                plo.Enzymevalue = Util.GetString(obs[7]);
                plo.EnzymeUnit = Util.GetString(obs[8]);
                plo.Reporttype = Util.GetString(obs[9]);
              
                if (Util.GetString(obs[9]) == "FINAL")
                {
                    plo.ResultEntrydateTime = Util.GetDateTime(System.DateTime.Now);
                }
                else
                {
                    plo.ResultEntrydateTime = Util.GetDateTime(obs[10]);
                }
                plo.value = Util.GetString(obs[11]);
                plo.Result_flag = 1;
                plo.Approved = 0;
                plo.IPAddress = StockReports.getip();
                plo.Insert();
            }
            foreach (string[] obs in organismantibiotics)
            {
                Reporttype = Util.GetString(obs[11]);
                Patient_lab_ObservationOPD_MIC plo = new Patient_lab_ObservationOPD_MIC(Tnx);
                plo.testid = Util.GetString(obs[0]);
                plo.OrganismID = Util.GetString(obs[1]);
                plo.OrganismName = Util.GetString(obs[2]);
                plo.Antibioticid = Util.GetString(obs[3]);
                plo.AntibioticName = Util.GetString(obs[4]);
                plo.AntibioticGroupid = Util.GetString(obs[5]);
                plo.AntibioticGroupname = Util.GetString(obs[6]);
                plo.AntibioticInterpreatation = Util.GetString(obs[7]);
                plo.MIC = Util.GetString(obs[8]);
                plo.BreakPoint = Util.GetString(obs[9]);
                plo.MIC_BP = Util.GetString(obs[10]);

                plo.Reporttype = Util.GetString(obs[11]);

                if (Util.GetString(obs[11]) == "FINAL")
                {
                    plo.ResultEntrydateTime = Util.GetDateTime(System.DateTime.Now);
                }
                else
                {
                    plo.ResultEntrydateTime = Util.GetDateTime(obs[12]);
                }
                plo.Result_flag = 1;
                plo.Approved = 0;
                plo.IPAddress = StockReports.getip();
                plo.Insert();
            }

            DateTime DeliveryDT = Util.GetDateTime(DeliveryDateTime);
            string str = "update patient_labinvestigation_opd set ReportNumber=@ReportNumber,Method=@Method,  Result_Flag=1, ResultEnteredBy=@ResultEnteredBy,ResultEnteredDate=NOW(),ResultEnteredName=@ResultEnteredName, `SampleTypeID`=@SampleTypeID,SampleTypeName=@SampleTypeName  ";
            if (Approved == "1")
            {
                str += ",isHold=0,isprint=0, Approved=1,ApprovedBy=@ApprovedBy,ApprovedDate=now(),ApprovedName=@ApprovedName ";
            }
            str += " where test_id=@test_id ";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str,
                new MySqlParameter("@ReportNumber", Reporttype),
                new MySqlParameter("@Method", Method),
                new MySqlParameter("@ResultEnteredBy",UserInfo.ID),
                new MySqlParameter("@ResultEnteredName",UserInfo.LoginName),
                new MySqlParameter("@ApprovedBy", UserInfo.ID),
                new MySqlParameter("@ApprovedName", UserInfo.LoginName),
                new MySqlParameter("@SampleTypeID", Sample_ID),
                new MySqlParameter("@SampleTypeName", Sample_Type),
                new MySqlParameter("@test_id", Util.GetString(observationdata[0][0])));


            string strdel = "DELETE FROM patient_labinvestigation_opd_comments WHERE Test_ID =@testid ";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strdel,
                new MySqlParameter("@testid", TestID));

            string strinsert = " INSERT INTO patient_labinvestigation_opd_comments(LedgerTransactionNo,Test_ID,comments,UserID,UserName) VALUES(@LedgerTransactionNo,@Test_ID,@comments,@UserID,@UserName) ";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strinsert,
                new MySqlParameter("@LedgerTransactionNo", LabNo),
                new MySqlParameter("@Test_ID", TestID),
                new MySqlParameter("@comments", Comments),
                new MySqlParameter("@UserID", UserInfo.ID),
                new MySqlParameter("@UserName", UserInfo.LoginName));

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "Result Not Saved...";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string Approved(string testid)
    {
        try
        {
            string str = "update patient_labinvestigation_opd set   ";
            str += " isHold=0,isprint=0,Approved=1,ApprovedBy=" + UserInfo.ID + ",ApprovedDate=now(),ApprovedName='" + HttpContext.Current.Session["LoginName"].ToString() + "' ";
            str += " where test_id='" + testid + "' ";
            StockReports.ExecuteDML(str);
            return HttpContext.Current.Session["LoginName"].ToString() + "_" + System.DateTime.Now.ToString("dd-MMM-yyyy hh:mm") + "_1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.InnerException.Message;
        }
    }
    [WebMethod]
    public static string Hold(string testid, string HoldComment)
    {
        try
        {
            string checkSplCase = "SELECT  Approved,isForward,Test_ID,LedgerTransactionNo,ApprovedBy,ForwardBy FROM patient_labinvestigation_opd  WHERE Test_ID='" + testid + "'";
            DataTable dtCheckSplCase = StockReports.GetDataTable(checkSplCase);

            if (dtCheckSplCase.Rows[0]["Approved"].ToString() == "1" && dtCheckSplCase.Rows[0]["isForward"].ToString() == "1" && dtCheckSplCase.Rows[0]["ApprovedBy"].ToString() == dtCheckSplCase.Rows[0]["ForwardBy"].ToString())
            {
                StockReports.ExecuteDML("Update patient_labinvestigation_opd Set Approved=0,isForward=0,isHold=1,Hold_Reason='" + HoldComment + "',HoldBy='" + HttpContext.Current.Session["ID"].ToString() + "',HoldByName='" + HttpContext.Current.Session["LoginName"].ToString() + "' where Test_ID='" + testid + "'");
            }
            else
            {
                StockReports.ExecuteDML("Update patient_labinvestigation_opd Set Approved=0,isHold=1,Hold_Reason='" + HoldComment + "',HoldBy='" + HttpContext.Current.Session["ID"].ToString() + "',HoldByName='" + HttpContext.Current.Session["LoginName"].ToString() + "' where Test_ID='" + testid + "'");
            }
            StockReports.ExecuteDML("INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,Roleid,CentreID,OLDID,NEWID) Values ('" + Util.GetString(dtCheckSplCase.Rows[0]["LedgerTransactionNo"]) + "','" + Util.GetString(dtCheckSplCase.Rows[0]["Test_ID"]) + "','Hold','" + HttpContext.Current.Session["ID"] + "','" + HttpContext.Current.Session["LoginName"] + "',NOW(),'" + StockReports.getip() + "','" + HttpContext.Current.Session["RoleID"].ToString() + "','" + Util.GetString(UserInfo.Centre) + "','','')");
           
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.InnerException.Message;
        }
    }
    [WebMethod]
    public static string UnHold(string testid)
    {
        try
        {
            string checkSplCase = "SELECT  Approved,isForward,Test_ID,LedgerTransactionNo,ApprovedBy,ForwardBy FROM patient_labinvestigation_opd  WHERE Test_ID='" + testid + "'";
            DataTable dtCheckSplCase = StockReports.GetDataTable(checkSplCase);
            StockReports.ExecuteDML("update patient_labinvestigation_opd set isHold=0,UnHoldBy='" + HttpContext.Current.Session["ID"].ToString() + "',UnHoldByName='" + HttpContext.Current.Session["LoginName"].ToString() + "',unHolddt=now() where Test_ID='" + testid + "' ");
            StockReports.ExecuteDML("INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,Roleid,CentreID,OLDID,NEWID) Values ('" + Util.GetString(dtCheckSplCase.Rows[0]["LedgerTransactionNo"]) + "','" + Util.GetString(dtCheckSplCase.Rows[0]["Test_ID"]) + "','UnHold','" + HttpContext.Current.Session["ID"] + "','" + HttpContext.Current.Session["LoginName"] + "',NOW(),'" + StockReports.getip() + "','" + HttpContext.Current.Session["RoleID"].ToString() + "','" + Util.GetString(UserInfo.Centre) + "','','')");

            return "1"; ;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.InnerException.Message;
        }
    }
    [WebMethod]
    public static string NotApproved(string testid)
    {
        try
        {
            string str = "update patient_labinvestigation_opd set   ";
            str += " Approved=0,NotApprovedBy="+UserInfo.ID+",NotApprovedDate=now(),NotApprovedName='" + HttpContext.Current.Session["LoginName"].ToString() + "' ";
            str += " where test_id='" + testid + "' ";
            StockReports.ExecuteDML(str);
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.InnerException.Message;
        }
    }
    private void bindComments()
    {
        ddlComments.DataSource = StockReports.GetDataTable(" SELECT Investigation_ID,Comments_ID,Comments_Head,Comments FROM `investigation_comments` WHERE  Investigation_ID='" + Investigation_Id + "' ");

        ddlComments.DataTextField = "Comments_Head";
        ddlComments.DataValueField = "Comments_ID";
        ddlComments.DataBind();
        if(UserInfo.Centre == 10)
        {
            ddlComments.Items.Insert(0, new ListItem("ALL", "ALL"));
        }
        else
        {

        }
    }
    [WebMethod]
    public static string GetComment(string cId)
    {
        try
        {
            string str = "SELECT Comments FROM `investigation_comments` WHERE Comments_ID='" + cId + "' ";
            DataTable dt = StockReports.GetDataTable(str);
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.InnerException.Message;
        }
    }
}
