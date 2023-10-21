using CrystalDecisions.CrystalReports.Engine;
using MW6BarcodeASPNet;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_Lab_Default : System.Web.UI.Page
{
    Bitmap objBitmap;
    ReportDocument obj1 = new ReportDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string _TestID = Request.QueryString["TestID"].ToString();
        DataTable dt1 = StockReports.GetDataTable("select AllowWorksheet,AllowDuplicateWorksheet from employee_master where Employee_ID='" + UserInfo.ID + "';");
        if (dt1.Rows.Count > 0)
        {
            if (Util.GetString(dt1.Rows[0]["AllowWorksheet"]) == "0")
            {
                Response.Write("<h2 style='color:Red;'>You are not authorised to access the microbiology worksheet.</h2>");
                return;
            }
            if (Util.GetString(dt1.Rows[0]["AllowDuplicateWorksheet"]) == "0")
            {
                if (Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT  `IsWorksheetPrint` FROM `patient_labinvestigation_opd` where test_id=@testid ",
                    new MySqlParameter("@testid", _TestID))) == "1")
                {
                    Response.Write("<h2 style='color:Red;'>You are not authorised to access the duplicate microbiology worksheet.</h2>");
                    return;
                }
            }
        }
        string _LabNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT `LedgertransactionNo` FROM patient_labinvestigation_opd WHERE test_id=@testid",
            new MySqlParameter("@testid", _TestID)));

        string _OtherInvestigation = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Group_concat(inv.Name) FROM investigation_master inv INNER JOIN patient_labinvestigation_opd plo ON inv.Investigation_ID=plo.Investigation_id AND plo.LedgerTransactionNo=@labno AND plo.Test_ID<>@testid ",
            new MySqlParameter("@testid", _TestID),
            new MySqlParameter("@labno", _LabNo)));
        
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ifnull(plo.SlideNumber,'')DepartmentNo,  lt.Patient_ID UHID ,inv.WorkSheetName,");
        sb.Append(" DATE_FORMAT(SampleCollectiondate,'%d-%b-%Y %r') SampleDate,DATE_FORMAT(SampleReceiveDate,'%d-%b-%Y %r') SampleReceiveDate, lt.PName, lt.Age , lt.Gender,  ");
        sb.Append(" plo.LedgertransactionNo, SampleTypeName SampleTypeName,plo.Test_ID,plo.barcodeno,");
        sb.Append(" plo.CultureNo Location ,");
        sb.Append(" lt.PanelName PanelName, inv.Name TestName,'" + _OtherInvestigation + "' OtherTest, ");
        sb.Append("lt.DoctorName Doctor ");
        sb.Append(" FROM  patient_labinvestigation_opd plo ");
        sb.Append(" inner join f_ledgertransaction lt on lt.LedgerTransactionNo=plo.LedgerTransactionNo ");
        sb.Append(" inner join investigation_master inv on inv.Investigation_ID=plo.Investigation_id ");
        sb.Append(" WHERE plo.test_id=@testid");
        dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@testid", _TestID)).Tables[0];
        if (dt.Rows.Count > 0)
        {
            OutputImg(Util.GetString(dt.Rows[0]["barcodeno"].ToString()));
            dt.Columns.Add("Image", System.Type.GetType("System.Byte[]"));
            dt.Rows[0]["Image"] = GetBitmapBytes(objBitmap);
            dt.Columns.Add("Image1", System.Type.GetType("System.Byte[]"));
        }

        DataSet ds = new DataSet();
        ds.Tables.Add(dt.Copy());
        // ds.WriteXmlSchema("D:/Aerobic.xml");
        if (dt.Rows[0]["WorkSheetName"].ToString() == "Aerobic")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\Aerobic.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "WESTERN BLOT")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\WesternBlot.rpt"));
        }

        if (dt.Rows[0]["WorkSheetName"].ToString() == "Cryptococcus Antigen")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\CryptococcusAntigenWorksheet.rpt"));
        }

        if (dt.Rows[0]["WorkSheetName"].ToString() == "AFB")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\AFB.rpt"));
        }

        if (dt.Rows[0]["WorkSheetName"].ToString() == "AFB Culture")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\AFBCulture.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "BloodCultureAutomated")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\BloodCultureAutomated.rpt"));
        }

        if (dt.Rows[0]["WorkSheetName"].ToString() == "Blood")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\Blood.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "Fungal Elements")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\FungalElements.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "Single Blood")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\SingleBlood.rpt"));
        }

        if (dt.Rows[0]["WorkSheetName"].ToString() == "PUS")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\CultureWorkSheetPus.rpt"));
        }

        if (dt.Rows[0]["WorkSheetName"].ToString() == "Sterile Body Fluid")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\BodyFluid.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "BLOOD CULTURE")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\worksheetbloodculture - New.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "BLOOD CULTURE22")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\worksheetbloodculture - New.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "AEROBIC CULTURE")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\Worksheet_Except_BloodCulture - New.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "AEROBIC CULTURE22")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\Worksheet_Except_BloodCulture - New.rpt"));
        }
       
        if (dt.Rows[0]["WorkSheetName"].ToString() == "TB CULTURE")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\TB_CULTURE.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "GRAM STAIN")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\GRAM_STAIN.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "FUNGAL STAIN")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\FUNGALSTAIN.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "FUNGAL CULTURE")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\FUNGALCULTURE.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "HLA B27")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\HLAB27.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "MTB-PCR")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\MTB_PCR.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "VIRAL DNA-RNA PCR")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\VIRAL_DNA_RNA_PCR.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "WATER CULTURE")
        {
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\WATERCULTURE.rpt"));
        }
        if (dt.Rows[0]["WorkSheetName"].ToString() == "COVID-19")
        {
            
            obj1.Load(Server.MapPath(@"~\Reports\WorkSheet\COVID-19.rpt"));
        }
        obj1.SetDataSource(ds);
     //   System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);

 System.IO.Stream oStream = null;
            byte[] byteArray = null;
            oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            byteArray = new byte[oStream.Length];
            oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
       
        MySqlTransaction tnx = con.BeginTransaction();
        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsWorksheetPrint='1', WorksheetPrintBy ='" + Util.GetString(Session["ID"]) + "',WorksheetPrintedByName='" + Util.GetString(Session["LoginName"]) + "',WorksheetPrintDate=now() where  test_id='" + Request.QueryString["TestID"].ToString() + "' ");
        tnx.Commit();
        con.Close();
        con.Dispose();
        obj1.Close();
        obj1.Dispose();
        Response.ClearContent();
        Response.ClearHeaders();
        Response.Buffer = true;
        Response.ContentType = "application/pdf";
        Response.BinaryWrite(byteArray);
        oStream.Flush();
        oStream.Close();
        oStream.Dispose();
    }



    protected void btnGet_Click(object sender, EventArgs e)
    {
       
    }
    private void OutputImg(string LedgerTranNo)
    {

        string FontName = "";
        Graphics objGraphics;
        Point p;

        //Response.ContentType = "image/Jpeg";
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = Color.White;
        MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = true;
        MyBarcode.CheckDigitToText = true;
        MyBarcode.Data = LedgerTranNo;
        MyBarcode.BarHeight = 1.0F;
        MyBarcode.NarrowBarWidth = 0.03F;
        MyBarcode.Orientation = MW6BarcodeASPNet.enumOrientation.or0;
        MyBarcode.SymbologyType = MW6BarcodeASPNet.enumSymbologyType.syCode128;
        MyBarcode.ShowText = false;
        MyBarcode.Wide2NarrowRatio = 0.5F;
        FontName = "Verdana, Arial, sans-serif";
        MyBarcode.TextFont = new Font(FontName, 8.0F);
        MyBarcode.SetSize(300, 45);
        objBitmap = new Bitmap(300, 45);
        objGraphics = Graphics.FromImage(objBitmap);
        p = new Point(0, 0);
        MyBarcode.Render(objGraphics, p);
        objGraphics.Flush();
        if (System.IO.File.Exists(Server.MapPath(@"~\Design\2.jpeg")))
        {
            System.IO.File.Delete(Server.MapPath(@"~\Design\2.jpeg"));
        }
    }
    private static byte[] GetBitmapBytes(Bitmap Bitmap1)    //  getting Stream of Bar Code image
    {
        MemoryStream memStream = new MemoryStream();
        byte[] bytes;

        try
        {
            // Save the bitmap to the MemoryStream.
            Bitmap1.Save(memStream, System.Drawing.Imaging.ImageFormat.Jpeg);

            // Create the byte array.
            bytes = new byte[memStream.Length];

            // Rewind.
            memStream.Seek(0, SeekOrigin.Begin);

            // Read the MemoryStream to get the bitmap's bytes.
            memStream.Read(bytes, 0, bytes.Length);

            // Return the byte array.
            return bytes;
        }

        finally
        {
            // Cleanup.
            memStream.Close();
            memStream.Dispose();
        }
    }
    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (obj1 != null)
        {
            obj1.Close();
            obj1.Dispose();
            GC.Collect();
        }
    }
}
