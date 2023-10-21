using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using SD = System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;

public partial class Design_Lab_LabResultEntryNew_Histo : System.Web.UI.Page
{
    public  string TestID = string.Empty;
    public  string LabNo = string.Empty;
    public  string PatinetID = string.Empty;
    public  string isApproval = string.Empty;
    public  string approved = string.Empty;
    public  string sampletype = string.Empty;
    public string Year = DateTime.Now.Year.ToString();
    public string Month = DateTime.Now.ToString("MMM");
    protected void Page_Load(object sender, EventArgs e)
    {
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append("  IF(HistoCytoSampleDetail<>'', ");
        sbQuery.Append(" CONCAT(");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), '^', -1)<>'0',CONCAT('Container:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 1), "); sbQuery.Append("'^', -1)),''),");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2), '^', -1)<>'0',CONCAT(' , Slides:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 2),"); sbQuery.Append("'^', -1)),''),");
        sbQuery.Append(" IF(SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3), '^', -1)<>'0',CONCAT(', Blocks:',SUBSTRING_INDEX(SUBSTRING_INDEX(HistoCytoSampleDetail, '^', 3),"); sbQuery.Append(" '^', -1)),''))");
        sbQuery.Append(" ,'') SampleInfo ");


        DataTable dtpinfo = StockReports.GetDataTable("select "+sbQuery.ToString()+", plo.sampletypename, plo.approved, plo.itemname, plo.barcodeno, plo.slidenumber histosecno, concat(title,pname) pname,pm.patient_id,pm.gender,pm.age from patient_master pm inner join patient_labinvestigation_opd plo on plo.patient_id=pm.patient_id and ledgertransactionno='" + Util.GetString(Request.QueryString["LabNo"]) + "' and test_id='" + Util.GetString(Request.QueryString["TestID"]) + "' limit 1");
      if (dtpinfo.Rows.Count > 0)
      {
          lbpatient.Text = dtpinfo.Rows[0]["pname"].ToString();
          PatinetID = dtpinfo.Rows[0]["patient_id"].ToString();
          lbsecno.Text = dtpinfo.Rows[0]["histosecno"].ToString();
          lbage.Text = dtpinfo.Rows[0]["age"].ToString() + "/" + dtpinfo.Rows[0]["gender"].ToString();
          lbbarcde.Text = dtpinfo.Rows[0]["barcodeno"].ToString();
          lbtestname.Text = dtpinfo.Rows[0]["itemname"].ToString();
          labno.Text = Util.GetString(Request.QueryString["LabNo"]);
          approved = dtpinfo.Rows[0]["approved"].ToString();
          sampletype = dtpinfo.Rows[0]["sampletypename"].ToString();

          lbtestname0.Text = dtpinfo.Rows[0]["SampleInfo"].ToString();
      }
      bindSlides(Util.GetString(Request.QueryString["TestID"]));
      TestID = Util.GetString(Request.QueryString["TestID"]);
      LabNo = Util.GetString(Request.QueryString["LabNo"]);
      PreviousTest(TestID);
      string str = " SELECT IFNULL(( SELECT Approval FROM f_approval_labemployee WHERE EmployeeID='" + Session["id"].ToString() + "' " +
                      " AND RoleID='" + Session["RoleID"].ToString() + "' ORDER BY Approval DESC LIMIT 1 ) ,  " +
                      " ( " +
                      " SELECT '1' Approval FROM f_approval_labemployee  " +
                      " WHERE TechnicalId='" + Session["id"].ToString() + "'  " +
                      " AND RoleID='" + Session["RoleID"].ToString() + "' LIMIT 1 " +
                      " ) ) a2 ";
      DataTable strDT = StockReports.GetDataTable(str);
      if (strDT != null && strDT.Rows.Count > 0 && Util.GetString(strDT.Rows[0][0]) != "")
          isApproval = Util.GetString(strDT.Rows[0][0]);

    
      if (!IsPostBack)
      {
         // getdoclist();
          //bindSpecimen_master();
         // bindreason();
          getdata();
      }
    }
    void bindreason()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ReasonID,ReasonName  FROM histopendingreason_master WHERE isactive=1 ORDER BY ReasonName");
        ddlpending.DataSource = dt;
        ddlpending.DataValueField = "ReasonID";
        ddlpending.DataTextField = "ReasonName";
        ddlpending.DataBind();
        ddlpending.Items.Insert(0, new ListItem("", "0"));
    }
    void getdata()
    {
        DataTable dt = StockReports.GetDataTable("select * from patient_labobservation_histo where Test_ID='"+TestID+"'");
        if (dt.Rows.Count > 0)
        {
            txtspecimen.Text = dt.Rows[0]["Specimen_Title"].ToString().ToUpper();

            txtHistoDatafinal.Text = dt.Rows[0]["Impression"].ToString();
            txtHistoDatagross.Text = dt.Rows[0]["Gross"].ToString();
            txtHistoDatamicro.Text = dt.Rows[0]["Microscopic"].ToString();
            txtcomment.Text = dt.Rows[0]["Advice"].ToString();
            txtimage.Text = dt.Rows[0]["detail"].ToString();
            txtclinicalhistory.Text = dt.Rows[0]["ClinicalHistory"].ToString();
        }
        else
        {
            txtspecimen.Text = sampletype.ToUpper();
            txtHistoDatagross.Text = StockReports.ExecuteScalar("select grosscomment from patient_labhisto_gross where TestID='" + TestID + "' limit 1");
        }
    }

    public void bindSlides(string testid)
    {
        tblslides.Visible = false;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select plg.blockid Blocks,Count(distinct pls.slideno) Slides from patient_labhisto_gross plg ");
            sb.Append(" inner join patient_labhisto_slides pls on plg.blockid=pls.blockid ");
            sb.Append(" where plg.testid=@testid group by plg.blockid ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@testid", testid)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                tblslides.Visible = true;
                tblslides.DataSource = dt;
                tblslides.DataBind();
            }
        }
        catch (Exception)
        {

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public void PreviousTest(string testid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select Patient_ID from patient_labinvestigation_opd where Test_ID=@testid");
            string PatientID = MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(), new MySqlParameter("@testid", testid)).ToString();
            if (!string.IsNullOrEmpty(PatientID))
            {
                sb.Clear();
                sb.Append("select GROUP_CONCAT(DISTINCT LedgerTransactionNo) VisitID from patient_labinvestigation_opd where Patient_ID=@Patient_ID and ReportType=7");
                string OldVisitID = MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Patient_ID", PatientID)).ToString();
                if (!string.IsNullOrEmpty(OldVisitID))
                {
                    lblOldVisitID.Text = OldVisitID;
                }
            }
        }
        catch (Exception)
        {

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public void  getdoclist()
    {
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.`Name` FROM f_login fl ");
        sbQuery.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
        sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
        // sbQuery.Append(" AND fl.`RoleID`="+UserInfo.RoleID+" ");
        sbQuery.Append("  WHERE centreid=" + UserInfo.Centre + " ");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());

        ddldoc.DataSource = dt;
        ddldoc.DataValueField = "employeeid";
        ddldoc.DataTextField = "Name";
        ddldoc.DataBind();
        ddldoc.Items.Insert(0, new ListItem("Select Doctor","0"));
        
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveHistoReport(string Test_ID, string LedgerTransactionNo, string Patient_ID, string Specimen_ID, string Specimen_Title, string Detail, string Gross, string Microscopic, string Impression, string Advice,string clinicalhistory, string type, string typeofreport, string pendingreason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string _Test_ID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Test_ID from patient_labobservation_histo where Test_ID='" + Test_ID + "'"));
          
             typeofreport = "Final";
           
            if (_Test_ID == "")
            {
                sb.Append("insert into patient_labobservation_histo(`Test_ID`,ClinicalHistory,`LedgerTransactionNo`,`Patient_ID`,");
                sb.Append("`Specimen_ID`,`Specimen_Title`,Employee_ID,Detail,Gross,Microscopic,Impression,Advice,isGrossed,typeofreport, pendingreason) values(");
                sb.Append("'" + Test_ID + "','" + clinicalhistory + "',");
                sb.Append("'" + LedgerTransactionNo + "',");
                sb.Append("'" + Patient_ID + "',");
                sb.Append("'" + Specimen_ID + "',");
                sb.Append("'" + Specimen_Title + "',");
                sb.Append("'" + Util.GetString(HttpContext.Current.Session["ID"]) + "',");
                sb.Append("'" + Detail + "',");
                sb.Append("'" + Gross + "',");
                sb.Append("'" + Microscopic + "',");
                sb.Append("'" + Impression + "',");
                sb.Append("'" + Advice + "',");
                sb.Append("'1','" + typeofreport + "','" + pendingreason + "')");

            }
            else
            {
                sb.Append("update patient_labobservation_histo set ");
                sb.Append("LedgerTransactionNo='" + LedgerTransactionNo + "',");
                sb.Append("Patient_ID='" + Patient_ID + "',");
                sb.Append("Specimen_ID='" + Specimen_ID + "',");
                sb.Append("Specimen_Title='" + Specimen_Title + "',");
                sb.Append("Employee_ID='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',");
                sb.Append("Detail='" + Detail + "', ");
                sb.Append("Gross='" + Gross + "', ");
                sb.Append("Microscopic='" + Microscopic + "', ");
                sb.Append("Impression='" + Impression + "', ");
                sb.Append("Advice='" + Advice + "', ");
                sb.Append("typeofreport='" + typeofreport + "', ");
                sb.Append("pendingreason='" + pendingreason + "', ");
                sb.Append("ClinicalHistory='" + clinicalhistory + "' ");
                sb.Append("where Test_ID='" + Test_ID + "' ");


            }


            int i = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
          "update patient_labinvestigation_opd set Result_Flag=1,isForward=0,ReportType='7', ResultEnteredBy='"
          + HttpContext.Current.Session["ID"].ToString() + "',ResultEnteredDate=NOW(),ResultEnteredName='"
          + HttpContext.Current.Session["LoginName"].ToString() + "' where Test_ID='" + Test_ID + "' AND LedgerTransactionNo='" + LedgerTransactionNo + "'");


            if (i != 1)
            {
                tnx.Rollback();
                con.Close();
                con.Dispose();

                throw (new Exception("Unknown error occured"));
            }
            // }


            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Result Saved (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + Test_ID + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();

            return "1";

        }
        catch (Exception ex)
        
       
        {


            tnx.Rollback();
            con.Close();
            con.Dispose();

            throw (ex);
        }
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string FinalDone(string Test_ID, string LedgerTransactionNo, string Patient_ID, string Specimen_ID, string Specimen_Title, string Detail, string Gross, string Microscopic, string Impression, string Advice,string clinicalhistory, string type, string typeofreport, string pendingreason, string Approved, string notapprovalcomment)
    {
        string rtnvalue = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            



            if (Approved == "1")
            {
                StringBuilder sb1 = new StringBuilder();
                string _Test_ID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Test_ID from patient_labobservation_histo where Test_ID='" + Test_ID + "'"));

                typeofreport = "Final";

                if (_Test_ID == "")
                {
                    sb1.Append("insert into patient_labobservation_histo(`Test_ID`,clinicalhistory,`LedgerTransactionNo`,`Patient_ID`,");
                    sb1.Append("`Specimen_ID`,`Specimen_Title`,Employee_ID,Detail,Gross,Microscopic,Impression,Advice,isGrossed,typeofreport, pendingreason) values(");
                    sb1.Append("'" + Test_ID + "','" + clinicalhistory + "',");
                    sb1.Append("'" + LedgerTransactionNo + "',");
                    sb1.Append("'" + Patient_ID + "',");
                    sb1.Append("'" + Specimen_ID + "',");
                    sb1.Append("'" + Specimen_Title + "',");
                    sb1.Append("'" + Util.GetString(HttpContext.Current.Session["ID"]) + "',");
                    sb1.Append("'" + Detail + "',");
                    sb1.Append("'" + Gross + "',");
                    sb1.Append("'" + Microscopic + "',");
                    sb1.Append("'" + Impression + "',");
                    sb1.Append("'" + Advice + "',");
                    sb1.Append("'1','" + typeofreport + "','" + pendingreason + "')");

                }
                else
                {
                    sb1.Append("update patient_labobservation_histo set ");
                    sb1.Append("LedgerTransactionNo='" + LedgerTransactionNo + "',");
                    sb1.Append("Patient_ID='" + Patient_ID + "',");
                    sb1.Append("Specimen_ID='" + Specimen_ID + "',");
                    sb1.Append("Specimen_Title='" + Specimen_Title + "',");
                    sb1.Append("Employee_ID='" + Util.GetString(HttpContext.Current.Session["ID"]) + "',");
                    sb1.Append("Detail='" + Detail + "', ");
                    sb1.Append("Gross='" + Gross + "', ");
                    sb1.Append("Microscopic='" + Microscopic + "', ");
                    sb1.Append("Impression='" + Impression + "', ");
                    sb1.Append("Advice='" + Advice + "', ");
                    sb1.Append("typeofreport='" + typeofreport + "', ");
                    sb1.Append("pendingreason='" + pendingreason + "', ");
                    sb1.Append("clinicalhistory='" + clinicalhistory + "' ");
                    sb1.Append("where Test_ID='" + Test_ID + "' ");


                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());

              int a=  MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, ApprovedBy = @ApprovedBy, ApprovedName = @ApprovedName,ApprovedDoneBy=@ApprovedDoneBy,ApprovedDate=@ApprovedDate, ResultEnteredBy=if(Result_Flag=0,'" + UserInfo.ID + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',ResultEnteredName),Result_Flag=1 WHERE Test_ID=@Test_ID AND approved=0 and isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@Approved", 1), new MySqlParameter("@ApprovedBy", UserInfo.ID), new MySqlParameter("@ApprovedName", UserInfo.LoginName),
                            new MySqlParameter("@ApprovedDoneBy", UserInfo.ID), new MySqlParameter("@ApprovedDate", DateTime.Now),
                            new MySqlParameter("@Test_ID", Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                if (a == 1)
                {
                    StringBuilder sb = new StringBuilder();
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                    sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Result Approved (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
                    sb.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + Test_ID + "'");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                    rtnvalue = "1";
                }
                else
                { rtnvalue = "0"; }


            }
            else
            {
                string entrydatetime = System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                

                // Save Not Approval Data in New Table
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "call Insert_UnApprove_Plo(@Test_ID,@UnapproveDate,@LedgerTransactionNo,@UnapprovebyID,@Unapproveby,@Comments,@ipaddress,@ReportType)",
                    new MySqlParameter("@Test_ID", Test_ID), new MySqlParameter("@UnapproveDate", entrydatetime), new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                   new MySqlParameter("@UnapprovebyID", Util.GetString(UserInfo.ID)), new MySqlParameter("@Unapproveby", Util.GetString(UserInfo.LoginName)),
                   new MySqlParameter("@Comments", notapprovalcomment.ToUpper()),
                   new MySqlParameter("@ipaddress", StockReports.getip()),
                    new MySqlParameter("@ReportType", 7));

                int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET NotApprovedCount=NotApprovedCount+1 ,Approved = 0,isPrint=0 WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and Result_Flag=1 ",
                                    new MySqlParameter("@Test_ID", Test_ID),
                                    new MySqlParameter("@isSampleCollected", 'Y'));

                StringBuilder sb = new StringBuilder();
                sb = new StringBuilder();
                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Result Not Approved (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
                sb.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + Test_ID + "'");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                              
                rtnvalue = "1";
            }
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        catch(Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);
        }
        return rtnvalue;
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string LoadSpecimenTemplate(string favonly)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT htm.`Template_ID`,upper(htm.`Template_Name`)Template_Name,IF(IFNULL(htm.`Gross`,'')='','0','1')    Gross ");
        sb.Append(" ,IF(IFNULL(htm.`MicroScopic`,'')='','0','1')    MicroScopic ");
        sb.Append(" ,IF(IFNULL(htm.`Impression`,'')='','0','1')    Impression ");


        sb.Append(" FROM `histo_template_master` htm  where isactive=1 ");
        if (favonly == "0")
        {
          //  sb.Append(" and doctorid in(0,'" + HttpContext.Current.Session["ID"].ToString() + "')");

        }
        else
        {
            sb.Append(" and doctorid in('" + HttpContext.Current.Session["ID"].ToString() + "')");
        }
        sb.Append(" ORDER BY htm.Template_Name  ");



        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

      
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveDataAsTemplate(string Type, string TemplateData, string TemplateName)
    {
        try
        {
            string header = "";
            header = TemplateData;
            header = header.Replace("\'", "");
            header = header.Replace("–", "-");
            header = header.Replace("'", "");
            header = header.Replace("µ", "&micro;");
            header = header.Replace("ᴼ", "&deg;");
            header = header.Replace("#aaaaaa 1px dashed", "none");
            header = header.Replace("dashed", "none");

            string s = StockReports.ExecuteScalar("select max(Template_ID) from histo_template_master");
            int id = Util.GetInt(s) + 1;
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT  INTO histo_template_master(Template_ID,Template_Name,IsActive,CreatedByUserID,CreateDateTime," + Type + ",DoctorID) VALUES (" + id + ",'" + TemplateName + "','1','" + HttpContext.Current.Session["ID"].ToString() + "',now(),'" + Util.GetString(header).Replace("'", "") + "','" + HttpContext.Current.Session["ID"].ToString() + "')");

            StockReports.ExecuteDML(sb.ToString());

            return "1";
        }
        catch(Exception ex)
        {
            return ex.Message;
        }
    }
    

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getTemplateHisto(string Template_ID, string Type)
    {
        //Gross,MicroScopic,Impression
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT " + Type.Replace("ing", "") + " as Template from histo_template_master where Template_ID='" + Template_ID + "' ");



        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            dt.Rows[0]["Template"] = HttpUtility.HtmlDecode(dt.Rows[0]["Template"].ToString());
        }



       
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }



    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Crop(string W, string H, string X, string Y, string ImgPath)
    {
        string ImageName = HttpContext.Current.Session["WorkingImage"].ToString();
        string filename = HttpContext.Current.Session["filename"].ToString();
        string SaveTo = "";

        int w = Convert.ToInt32(W);

        int h = Convert.ToInt32(H);

        int x = Convert.ToInt32(X);

        int y = Convert.ToInt32(Y);


        string timestamp = DateTime.Now.ToShortTimeString().Replace(":", "");

        String path = HttpContext.Current.Request.PhysicalApplicationPath + "HistoUploads\\";
        byte[] CropImage = Crop(path + ImageName, w, h, x, y);

        using (System.IO.MemoryStream ms = new System.IO.MemoryStream(CropImage, 0, CropImage.Length))
        {

            ms.Write(CropImage, 0, CropImage.Length);

            using (SD.Image CroppedImage = SD.Image.FromStream(ms, true))
            {

                SaveTo = path + ImageName + timestamp + ".jpg";

                CroppedImage.Save(SaveTo, CroppedImage.RawFormat);

            }

        }
        return filename + timestamp + ".jpg";
    }

    static byte[] Crop(string Img, int Width, int Height, int X, int Y)
    {

        try
        {

            using (SD.Image OriginalImage = SD.Image.FromFile(Img))
            {

                using (SD.Bitmap bmp = new SD.Bitmap(Width, Height))
                {

                    bmp.SetResolution(OriginalImage.HorizontalResolution, OriginalImage.VerticalResolution);

                    using (SD.Graphics Graphic = SD.Graphics.FromImage(bmp))
                    {

                        Graphic.SmoothingMode = SmoothingMode.AntiAlias;

                        Graphic.InterpolationMode = InterpolationMode.HighQualityBicubic;

                        Graphic.PixelOffsetMode = PixelOffsetMode.HighQuality;

                        Graphic.DrawImage(OriginalImage, new SD.Rectangle(0, 0, Width, Height), X, Y, Width, Height, SD.GraphicsUnit.Pixel);

                        MemoryStream ms = new MemoryStream();

                        bmp.Save(ms, OriginalImage.RawFormat);

                        return ms.GetBuffer();

                    }

                }

            }

        }

        catch (Exception Ex)
        {

            throw (Ex);

        }

    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savedataslide(List<string[]> mydataadj)
    {
       
        StockReports.ExecuteDML("delete from patient_labhisto_slides where testid='" + Util.GetString(mydataadj[0][0]) + "' and blockid='" + Util.GetString(mydataadj[0][2]) + "'");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string[] ss in mydataadj)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_slides ");
                sb.Append("(testid,labno,blockid,slideno,slidecomment,entrydate,entrybyname,entryby,Reslide,ReslideOption)");
                sb.Append("VALUES('" + ss[0].ToString() + "','" + ss[1].ToString() + "','" + ss[2].ToString() + "','" + ss[3].ToString() + "','" + ss[4].ToString() + "'");
                sb.Append(",NOW(),'" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','1','" + ss[5].ToString() + "')");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());




            }
           
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update patient_labinvestigation_opd set HistoCytoStatus='Slided' where test_id='" + Util.GetString(mydataadj[0][0]) + "'");
            
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status ");
            sb1.Append(" (LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb1.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('ReSliding (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb1.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + Util.GetString(mydataadj[0][0]) + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString());
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();

            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();

            throw (ex);
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdetailblock(string testid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(labno,' / ',blockid) value,blockid FROM patient_labhisto_gross where testid='" + testid + "' order by testid");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdetaildatablock(string testid, string blockid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select testid,labno,blockid,slideno,slidecomment from patient_labhisto_slides where testid='" + testid + "' and blockid='" + blockid + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Forward(string testid, string doc, string centre)
    {
        string issaved=StockReports.ExecuteScalar("select result_flag from patient_labinvestigation_opd where  Test_ID="+testid);
        if( issaved=="0")
        {
            return "Please Save Report Before Forward";
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET isForward = @isForward, ForwardBy = @ForwardBy, ForwardByName = @ForwardByName,ForwardDate=@ForwardDate,ForwardToCentre=@ForwardToCentre,ForwardToDoctor=@ForwardToDoctor WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                new MySqlParameter("@isForward", 1), new MySqlParameter("@ForwardBy", UserInfo.ID), new MySqlParameter("@ForwardByName", UserInfo.LoginName),
                new MySqlParameter("@ForwardDate", DateTime.Now), new MySqlParameter("@ForwardToCentre", centre), new MySqlParameter("@ForwardToDoctor", doc),
                new MySqlParameter("@Test_ID", testid),
                new MySqlParameter("@isSampleCollected", 'Y'));

            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Forward (',ItemName,')'),'" + UserInfo.ID + "','" + UserInfo.LoginName + "','" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb.Append(" '" + UserInfo.RoleID + "',NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID ='" + testid + "'");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);

        }



    }



    protected void btnAdobeReader_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('https://get.adobe.com/flashplayer/');", true);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindCentreToForward()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT centreid,centre FROM centre_master WHERE centreid=" + UserInfo.Centre + "   union all SELECT centreid,centre FROM centre_master WHERE type1<>'PCC' and centreid<>" + UserInfo.Centre + "     ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindDoctorToForward(string centre)
    {
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT DISTINCT fl.employeeid,em.`Name` FROM f_login fl ");
        sbQuery.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
        sbQuery.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
        sbQuery.Append("  WHERE centreid=" + centre + " and fl.employeeid<>" + UserInfo.ID + "");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string PostRemarksData1(string TestID, string TestName, string VisitNo)
    {
        return Util.getJson(new { TestID = Common.EncryptRijndael(TestID), TestName = Common.EncryptRijndael(TestName), VisitNo = Common.EncryptRijndael(VisitNo) });

    }
}