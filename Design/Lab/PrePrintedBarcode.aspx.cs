using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using System.Web.Services;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using CrystalDecisions.CrystalReports.Engine;
using System.IO;

[Serializable]
public partial class Design_Lab_PrePrintedBarcode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getBarcode()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT `Prefix1`,`Prefix2`,`Prefix3`,CHAR(`Prefix1`,`Prefix2`,`Prefix3`)Prefix,MAX(`MaxID`)+1 MaxID FROM barcodesequence");
        sb.Append(" WHERE MaxID <99999  ");

        DataTable dt = new DataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string NewSeriesBarcode()
    {
        string RetrunMsg = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL generate_barcode_prefix();");
            tnx.Commit();
            
            RetrunMsg = "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            RetrunMsg = "0";
        }
	finally
	{
            tnx.Dispose();
            con.Close();
            con.Dispose();
	}

        return RetrunMsg;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveBarcode(string Suffix, int LastNo, int NoOfBarcode, string suffix1, string suffix2, string suffix3, string DuplicateCopy, string Size, string Color)
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb1 = new StringBuilder();
        int total1 = Util.GetInt(LastNo + NoOfBarcode - 1);

        DataTable dt = new DataTable();
        //MySqlConnection con = Util.GetMySqlCon();
        //con.Open();
        //MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string ReturnMsg = "";

        try
        {
            sb1.Append("UPDATE barcodesequence SET MaxID=MAxID + " + NoOfBarcode + " WHERE  `Prefix1`='" + suffix1 + "' AND `Prefix2`='" + suffix2 + "' AND `Prefix3`='" + suffix3 + "';");
            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb1.ToString(),

            //    new MySqlParameter("@Prefix1", suffix1),
            //    new MySqlParameter("@Prefix2", suffix2),
            //    new MySqlParameter("@Prefix3", suffix3)
            //    );
            StockReports.ExecuteDML(sb1.ToString());

            sb.Append("insert Into  barcodesequencedetail(FromBarCode,Tobarcode,Center_ID,PrintedDate,PrintedByEmpId,EmpName) ");
            sb.Append(" values('" + LastNo + "','" + total1 + "','" + UserInfo.Centre + "',Now(),'" + UserInfo.ID + "','" + UserInfo.LoginName + "') ");
            StockReports.ExecuteDML(sb.ToString());
            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
            //    new MySqlParameter("@FromBarCode", LastNo),
            //     new MySqlParameter("@Tobarcode", total1),
            //      new MySqlParameter("@Center_ID", UserInfo.Centre),
            //        new MySqlParameter("@PrintedByEmpId", UserInfo.ID),
            //         new MySqlParameter("@EmpName", UserInfo.LoginName)
            //    );

            //---------------------Print Barcode------------------

            string str_Data = "";
            int total = Util.GetInt(LastNo + NoOfBarcode);
            int FromBarcode = Util.GetInt(LastNo);
            //  int ToBarcode = Util.GetInt(To);
            int n = NoOfBarcode;

            int i;
            for (i = 0; i < n; i++)
            {

                str_Data = str_Data + "" + (str_Data == "" ? "" : "^") + "" + " ," +
                    "" + ",," + Suffix + FromBarcode.ToString().PadLeft(5, '0') + "" + "" + "," +
                    "" + ",";
                FromBarcode++;


            }
            str_Data = str_Data.Replace(",", "").Trim();

           // string PrintingCtr = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select IF((SELECT COUNT(1) FROM PrintedBarcode)='0','0',MAX(PrintingCtr)+1) as PrintingCtr from PrintedBarcode"));
            string PrintingCtr = StockReports.ExecuteScalar("Select IF((SELECT COUNT(1) FROM PrintedBarcode)='0','0',MAX(PrintingCtr)+1) as PrintingCtr from PrintedBarcode");
            string sbQry = string.Empty;
            sbQry = " INSERT INTO PrintedBarcode(Barcode,PrintingCtr) VALUES ";
            string[] BarcodeArr = str_Data.Split('^');
            for (int k = 0; k < BarcodeArr.Length; k++)
            {
                sbQry += " ('" + BarcodeArr[k].Trim() + "'," + PrintingCtr.Trim() + "),";
            }

            sbQry = sbQry.Substring(0, sbQry.Length - 1);
           // MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbQry);
            StockReports.ExecuteDML(sbQry);
            int NoOfCopy = Convert.ToInt32(DuplicateCopy);

            string BarcodeCopy = string.Empty;

            for (int x = 0; x < NoOfCopy; x++)
            {
                BarcodeCopy += " SELECT Barcode FROM PrintedBarcode WHERE PrintingCtr=" + PrintingCtr;
                BarcodeCopy += " UNION ALL";
            }
            string LogoPath = string.Empty;
            if (Color == "Red")
            {
                LogoPath = HttpContext.Current.Server.MapPath("~/App_Images/logo_Red.png");
            }
            else if (Color == "Orange")
            {
                LogoPath = HttpContext.Current.Server.MapPath("~/App_Images/logo_Orange.png");
            }
            else if (Color == "Green")
            {
                LogoPath = HttpContext.Current.Server.MapPath("~/App_Images/logo_Green.png");
            }
            else if (Color == "Purple")
            {
                LogoPath = HttpContext.Current.Server.MapPath("~/App_Images/logo_Purple.png");
            }
            else if (Color == "Blue")
            {
                LogoPath = HttpContext.Current.Server.MapPath("~/App_Images/logo_Blue.png");
            }
            else if (Color == "Gray")
            {
                LogoPath = HttpContext.Current.Server.MapPath("~/App_Images/logo_Gray.png");
            }


            BarcodeCopy = BarcodeCopy.Substring(0, BarcodeCopy.Length - 10).Trim();
            BarcodeCopy = "SELECT * FROM (" + BarcodeCopy.Trim() + ") T Order BY Barcode";
          
            DataTable Pbdt = StockReports.GetDataTable(BarcodeCopy); //MySqlHelper.ExecuteDataset(con,CommandType.Text,BarcodeCopy).Tables[0];
            
            DataColumn dcBarcodeImage = new DataColumn("BarcodeImage");
            dcBarcodeImage.DataType = System.Type.GetType("System.Byte[]");
            //-----------------------------------
            DataColumn LogoImage = new DataColumn("LogoImage");
            LogoImage.DataType = System.Type.GetType("System.Byte[]");

            Pbdt.Columns.Add(dcBarcodeImage);
            Pbdt.Columns.Add(LogoImage);

            foreach (DataRow dr in Pbdt.Rows)
            {
                string barcode = new Barcode_alok().Save(Util.GetString(dr["Barcode"].ToString())).Trim();
                string x = barcode.Replace("data:image/png;base64,", "");
                byte[] imageBytes = Convert.FromBase64String(x);
              //  using (MemoryStream ms = new MemoryStream(imageBytes, 0, imageBytes.Length))
                //{
                    dr["BarcodeImage"] = imageBytes;
                    //------------------------------------------
                    string LogoImageArrayRepresentation = ImageToBase64(LogoPath);
                    byte[] LogoImageByte = Convert.FromBase64String(LogoImageArrayRepresentation);
                    //using (MemoryStream ms1 = new MemoryStream(LogoImageByte, 0, LogoImageByte.Length))
                    //{
                        dr["LogoImage"] = LogoImageByte;
                    //}

              //  }
            }

            if (Size == "1")
            {

                DataTable dtAll = Pbdt.Clone();
                dtAll.Columns.Add("Barcode1", typeof(string));
                DataColumn dc1 = new DataColumn("BarcodeImage1");
                dc1.DataType = System.Type.GetType("System.Byte[]");
                dtAll.Columns.Add(dc1);
                int rowPos = 1;
                int c = 0;
                foreach (DataRow dr in Pbdt.Rows)
                {
                    if (rowPos % 2 != 0)
                    {
                        DataRow drTemp = dtAll.NewRow();
                        drTemp["Barcode"] = dr["Barcode"];
                        drTemp["BarcodeImage"] = dr["BarcodeImage"];
                        drTemp["LogoImage"] = dr["LogoImage"];
                        dtAll.Rows.Add(drTemp);
                        dtAll.AcceptChanges();
                        rowPos++;
                        continue;
                    }
                    else
                    {
                        dtAll.Rows[c]["Barcode1"] = dr["Barcode"];
                        dtAll.Rows[c]["BarcodeImage1"] = dr["BarcodeImage"];
                        dtAll.Rows[c]["LogoImage"] = dr["LogoImage"];
                        dtAll.AcceptChanges();
                        rowPos++;
                    }
                    c++;
                }
                DataSet ds = new DataSet();
                dtAll.TableName = "Table";
                ds.Tables.Add(dtAll.Copy());
                // ds.WriteXmlSchema("G:/dtInvoice.xml");
                HttpContext.Current.Session["BarcodeData"] = ds;
                HttpContext.Current.Session["PaperSize"] = "1";
                
            }
            else
            {
                DataSet ds = new DataSet();
                Pbdt.TableName = "Table";
                ds.Tables.Add(Pbdt.Copy());
                //ds.WriteXmlSchema("G:/dtInvoice.xml");
                HttpContext.Current.Session["BarcodeData"] = ds;
                HttpContext.Current.Session["PaperSize"] = "2";
                
            }

            //------------------------------------------------------


            //tnx.Commit();
            ReturnMsg = "1";
        }
        catch (Exception ex)
        {
            
            //tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            ReturnMsg = "0";
        }
        //finally
        //{
        //    tnx.Dispose();
        //    con.Close();
        //    con.Dispose();
        //}
        return ReturnMsg;
    }
   
    //static string base64String = null;
    public static string ImageToBase64(string LogoPath)
    {
        string path = LogoPath;
        using (System.Drawing.Image image = System.Drawing.Image.FromFile(path))
        {
            using (MemoryStream m = new MemoryStream())
            {
                image.Save(m, image.RawFormat);
                byte[] imageBytes = m.ToArray();
                string base64String = Convert.ToBase64String(imageBytes);
                return base64String;
            }
        }
    }
}