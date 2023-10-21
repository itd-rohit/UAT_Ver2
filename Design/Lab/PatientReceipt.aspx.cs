using System;
using MW6BarcodeASPNet;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using System.Text.RegularExpressions;

public partial class Design_Lab_PatientReceipt : System.Web.UI.Page
{
    Bitmap objBitmap;
    protected void Page_Load(object sender, EventArgs e)
    {
        ReportDocument rpt = new ReportDocument();
        try
        {
            string labid = Util.GetString(Common.Decrypt( Request.QueryString["LabID"]));
            string isRefund = StockReports.ExecuteScalar(" SELECT count(*) FROM opd_refund WHERE old_LedgerTransactionNo=(select LedgerTransactionNo from patient_labinvestigation_opd where LedgerTransactionID='" + labid + "' limit 1) ");
            // For Settlement
            StringBuilder sbSettlement = new StringBuilder();
            sbSettlement.Append(" SELECT rt.ReceiptNo,rt.PaymentMode,rt.Amount,DATE_FORMAT(rt.EntryDateTime,'%d-%m-%Y') EntryDateTime,rt.UserId,rt.UserName FROM f_reciept rt INNER JOIN employee_master em ON rt.UserID=em.Employee_ID WHERE `LedgerTransactionID`='" + labid + "'  ");
            DataTable dtSettlement = StockReports.GetDataTable(sbSettlement.ToString());

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT sm.State,sm.GSTIN,IFNULL(sm.GSTINAddress,'')GSTINAddress,IF(lt.DATE>'2017-07-01',1,0)ShowGST,fpm.HideReceiptRate,LT.Password_web,lt.Username_web,lt.Bill_Count,cm.Mobile CenterContact,replace(cm.`Address`,',',', ') CenterAddress1,cm.Locality CenterAddress2,CONCAT(pm.title,pm.pname) pname,pm.`Patient_ID`,lt.`LedgerTransactionNo`,lt.`BillNo`,cm.`Centre`,lt.`IsCancel`, plo.`Barcode_Group`,DATE_FORMAT(plo.`DeliveryDate`,'%d-%b-%Y %h:%i%p') DeliveryDate,cm.HeaderImage,cm.FooterImage, ");//cm.HeaderImage,cm.FooterImage,  ");
            if (Util.GetInt(isRefund) > 0)
            {
                sb.Append(" '1' IsRefund,");
            }
            else
            {
                sb.Append(" '0' IsRefund,");
            }
            if (dtSettlement.Rows.Count > 0)
            {
                sb.Append(" '1' IsSettlementEntry,");
            }
            else
            {
                sb.Append(" '0' IsSettlementEntry,");
            }
            sb.Append(" pm.`Age`,pm.`Gender`,pm.`Mobile`, lt.`PanelName`,IF(lt.`Doctor_ID`='2', ");
            sb.Append(" lt.`OtherDoctorName`,Concat('Dr.',lt.`DoctorName`)) Doctorname, DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i%p') RegDate, ");
            sb.Append(" TRIM(BOTH ',' FROM CONCAT(IFNULL(pm.House_No,''),',',IFNULL(pm.`Locality`,''),',',IFNULL(pm.`City`,''))) Address,plo.IsPackage, ");
            
            sb.Append(" itm.TypeName ItemName, ");
            sb.Append(" itm.TestCode ,plo.MRP as rate,(plo.MRP-plo.`Amount`) as `DiscountAmt`,plo.`Amount`, DATE_FORMAT(plo.deliverydate,'%d-%b-%Y %h:%i%p')deliverydate,  lt.`GrossAmount`, ");
            sb.Append(" lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`, ");
            sb.Append(" (SELECT em.name FROM employee_master em WHERE em.employee_id=lt.`Creator_UserID`)UserName , ");
            sb.Append(" sc.`Name`DepartmentName     FROM patient_labinvestigation_opd plo  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15) ");
            sb.Append(" AND lt.`LedgerTransactionID`='" + labid + "' ");
            sb.Append("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.`Panel_ID` ");
            sb.Append(" INNER JOIN f_itemmaster itm on itm.ItemID=plo.ItemID ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sb.Append(" INNER JOIN state_master sm ON sm.ID=cm.StateID ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`  GROUP BY plo.`ItemId` ");
            sb.Append(" ORDER BY sc.`Name`,plo.ispackage,plo.itemname ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

                 
            string refundLedgerTransactionID = string.Empty;
            if (Util.GetInt(isRefund) > 0)
            {
                string oldLabNo = StockReports.ExecuteScalar(" select LedgerTransactionNo from f_ledgertransaction where LedgerTransactionID='" + labid + "' ");
                string newLabNo = StockReports.ExecuteScalar(" select new_LedgerTransactionNo from opd_refund orf INNER JOIN f_ledgertransaction lt ON orf.new_LedgerTransactionNo=lt.LedgerTransactionNo  where  orf.old_LedgerTransactionNo='" + oldLabNo.Trim() + "' AND lt.IsCancel=0 ");
                refundLedgerTransactionID = StockReports.ExecuteScalar(" SELECT LedgerTransactionID from f_ledgertransaction where LedgerTransactionNo='" + newLabNo.Trim() + "' ");
            }
            StringBuilder sbRefund = new StringBuilder();
            sbRefund.Append(" SELECT LT.Password_web,lt.Bill_Count,cm.Mobile CenterContact,replace(cm.`Address`,',',', ') CenterAddress1,cm.Locality CenterAddress2,CONCAT(pm.title,pm.pname) pname,pm.`Patient_ID`,lt.`LedgerTransactionNo`,lt.`BillNo`,cm.`Centre`,lt.`IsCancel`, plo.`Barcode_Group`,DATE_FORMAT(plo.`DeliveryDate`,'%d-%b-%Y %h:%i%p') DeliveryDate,cm.HeaderImage,cm.FooterImage, ");//cm.HeaderImage,cm.FooterImage,  ");
            sbRefund.Append("  r.ReceiptNo,r.PaymentMode,r.Amount,DATE_FORMAT(r.EntryDateTime,'%d-%m-%Y') EntryDateTime,r.UserId, ");
            sbRefund.Append(" pm.`Age`,pm.`Gender`,pm.`Mobile`, lt.`PanelName`,IF(lt.`Doctor_ID`='2', ");
            sbRefund.Append(" lt.`OtherDoctorName`,Concat('Dr.',lt.`DoctorName`)) Doctorname, DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i%p') RegDate, ");
            sbRefund.Append(" TRIM(BOTH ',' FROM CONCAT(IFNULL(pm.House_No,''),',',IFNULL(pm.`Locality`,''),',',IFNULL(pm.`City`,''))) Address, ");
            sbRefund.Append(" plo.IsPackage, itm.TypeName ItemName ,itm.TestCode ,plo.rate, plo.`DiscountAmt`,plo.`Amount`, ");
            sbRefund.Append(" DATE_FORMAT(plo.deliverydate,'%d-%b-%Y %h:%i%p')deliverydate,  lt.`GrossAmount`, ");
            sbRefund.Append(" lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`, ");
            sbRefund.Append(" (SELECT em.name FROM employee_master em WHERE em.employee_id=lt.`Creator_UserID`)UserName , ");
            sbRefund.Append(" sc.`Name`DepartmentName     FROM patient_labinvestigation_opd plo  ");
            sbRefund.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`");
            sbRefund.Append(" AND lt.`LedgerTransactionID`='" + refundLedgerTransactionID.Trim() + "' ");
            sbRefund.Append(" INNER JOIN f_itemmaster itm on itm.ItemID=plo.ItemID ");
            sbRefund.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sbRefund.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=plo.`SubCategoryID` ");
            sbRefund.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID` ");
            sbRefund.Append(" left JOIN f_reciept r ON r.LedgerTransactionID=lt.LedgerTransactionID and r.iscancel=0 ");
            sbRefund.Append("  GROUP BY plo.`ItemId`  ORDER BY sc.`Name`,plo.ispackage,plo.itemname ");
            using (DataTable dtRefund = StockReports.GetDataTable(sbRefund.ToString()))
            {
                //System.IO.File.WriteAllText (@"F:\Shat\aa.txt", sb.ToString());
                if (dt.Rows.Count > 0)
                {

                    string barcode = new Barcode_alok().Save(Util.GetString(dt.Rows[0]["LedgerTransactionNo"].ToString())).Trim();

                    if (!string.IsNullOrEmpty(barcode))
                    {
                        string x = barcode.Replace("data:image/png;base64,", "");

                        byte[] imageBytes = Convert.FromBase64String(x);

                        DataColumn dcImage = new DataColumn("Image");
                        dcImage.DataType = System.Type.GetType("System.Byte[]");
                        dcImage.DefaultValue = imageBytes;
                        dt.Columns.Add(dcImage);
                    }


                    dt.Columns.Add("AmountInWord", typeof(string));
                    string amtWord = changeNumericToWords(Util.GetString(dt.Rows[0]["Adjustment"]));
                    if (amtWord.Trim() != "")
                    {
                        dt.Rows[dt.Rows.Count - 1]["AmountInWord"] = amtWord.Trim() + " only";
                    }
                    else
                    {
                        dt.Rows[dt.Rows.Count - 1]["AmountInWord"] = "";
                    }

                    string headerimage = dt.Rows[0]["HeaderImage"].ToString();
                    if (!string.IsNullOrEmpty(headerimage))
                    {

                        string HImage = headerimage;
                        string path1 = HttpContext.Current.Server.MapPath(HImage);
                        FileStream fs = new FileStream(path1, FileMode.Open, System.IO.FileAccess.Read);
                        byte[] imgbyte = new byte[fs.Length + 1];
                        fs.Read(imgbyte, 0, (int)fs.Length);
                        fs.Close();
                        byte[] bytes = System.Text.Encoding.UTF8.GetBytes((headerimage));


                        DataColumn dcHeaderImageData = new DataColumn("HeaderImageData");
                        dcHeaderImageData.DataType = System.Type.GetType("System.Byte[]");
                        dcHeaderImageData.DefaultValue = imgbyte; ;
                        dt.Columns.Add(dcHeaderImageData);
                    }



                    string Footerimage = dt.Rows[0]["FooterImage"].ToString();
                    if (!string.IsNullOrEmpty(Footerimage))
                    {

                        string FImage = Footerimage;
                        string path = HttpContext.Current.Server.MapPath(FImage);
                        FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);
                        byte[] imgbyte = new byte[fs.Length + 1];
                        fs.Read(imgbyte, 0, (int)fs.Length);
                        fs.Close();
                        fs.Dispose();

                        byte[] bytes = System.Text.Encoding.UTF8.GetBytes((Footerimage));


                        DataColumn dcFooterImageData = new DataColumn("FooterImageData");
                        dcFooterImageData.DataType = System.Type.GetType("System.Byte[]");
                        dcFooterImageData.DefaultValue = imgbyte;
                        dt.Columns.Add(dcFooterImageData);
                    }



                    dt.AcceptChanges();


                    using (DataSet ds = new DataSet())
                    {
                        ds.Tables.Add(dt.Copy());
                        dtSettlement.TableName = "Settlement";
                        ds.Tables.Add(dtSettlement.Copy());
                        dtRefund.TableName = "Refund";
                        ds.Tables.Add(dtRefund.Copy());
                        // ds.WriteXmlSchema("d:/Receipt.xml");
                        rpt.Load(Server.MapPath(@"~\Reports\Receipt.rpt"));
                        rpt.SetDataSource(ds);
                        //Updation Of Bill Count
                        StockReports.ExecuteDML(" update f_ledgertransaction set Bill_Count=Bill_Count+1 where LedgerTransactionID='" + labid.Trim() + "' ");


                        System.IO.Stream oStream = null;
                        byte[] byteArray = null;
                        using (oStream = rpt.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
                        {
                            byteArray = new byte[oStream.Length];
                            oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                            Response.ClearContent();
                            Response.ClearHeaders();
                            Response.ContentType = "application/pdf";
                            Response.BinaryWrite(byteArray);
                            Response.Flush();
                            Response.Close();

                            oStream.Close();
                            oStream.Dispose();

                        }
                    }

                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            rpt.Close();
            rpt.Dispose();
        }
    }
    public String changeNumericToWords(string numb)
    {
        String num = numb.ToString();
        return changeToWords(num, false);
    }

    private String changeToWords(String numb, bool isCurrency)
    {
        String val = "", wholeNo = numb, points = "", andStr = "", pointStr = "";
        String endStr = (isCurrency) ? ("Only") : ("");
        try
        {
            int decimalPlace = numb.IndexOf(".");
            if (decimalPlace > 0)
            {
                wholeNo = numb.Substring(0, decimalPlace);
                points = numb.Substring(decimalPlace + 1);
                if (Convert.ToInt32(points) > 0)
                {
                    andStr = (isCurrency) ? ("and") : ("point");// just to separate whole numbers from points/cents
                    endStr = (isCurrency) ? ("Cents " + endStr) : ("");
                    pointStr = translateCents(points);
                }
            }
            val = String.Format("{0} {1}{2} {3}", translateWholeNumber(wholeNo).Trim(), andStr, pointStr, endStr);
        }
        catch { ;}
        return val;
    }
    private String translateWholeNumber(String number)
    {
        string word = "";
        try
        {
            bool beginsZero = false;//tests for 0XX
            bool isDone = false;//test if already translated
            double dblAmt = (Convert.ToDouble(number));
            //if ((dblAmt > 0) && number.StartsWith("0"))
            if (dblAmt > 0)
            {//test for zero or digit zero in a nuemric
                beginsZero = number.StartsWith("0");

                int numDigits = number.Length;
                int pos = 0;//store digit grouping
                String place = "";//digit grouping name:hundres,thousand,etc...
                switch (numDigits)
                {
                    case 1://ones' range
                        word = ones(number);
                        isDone = true;
                        break;
                    case 2://tens' range
                        word = tens(number);
                        isDone = true;
                        break;
                    case 3://hundreds' range
                        pos = (numDigits % 3) + 1;
                        place = " Hundred ";
                        break;
                    case 4://thousands' range
                    case 5:
                    case 6:
                        pos = (numDigits % 4) + 1;
                        place = " Thousand ";
                        break;
                    case 7://millions' range
                    case 8:
                    case 9:
                        pos = (numDigits % 7) + 1;
                        place = " Million ";
                        break;
                    case 10://Billions's range
                        pos = (numDigits % 10) + 1;
                        place = " Billion ";
                        break;
                    //add extra case options for anything above Billion...
                    default:
                        isDone = true;
                        break;
                }
                if (!isDone)
                {//if transalation is not done, continue...(Recursion comes in now!!)
                    word = translateWholeNumber(number.Substring(0, pos)) + place + translateWholeNumber(number.Substring(pos));
                    //check for trailing zeros
                    if (beginsZero) word = " and " + word.Trim();
                }
                //ignore digit grouping names
                if (word.Trim().Equals(place.Trim())) word = "";
            }
        }
        catch { ;}
        return word.Trim();
    }
    private String tens(String digit)
    {
        int digt = Convert.ToInt32(digit);
        String name = null;
        switch (digt)
        {
            case 10:
                name = "Ten";
                break;
            case 11:
                name = "Eleven";
                break;
            case 12:
                name = "Twelve";
                break;
            case 13:
                name = "Thirteen";
                break;
            case 14:
                name = "Fourteen";
                break;
            case 15:
                name = "Fifteen";
                break;
            case 16:
                name = "Sixteen";
                break;
            case 17:
                name = "Seventeen";
                break;
            case 18:
                name = "Eighteen";
                break;
            case 19:
                name = "Nineteen";
                break;
            case 20:
                name = "Twenty";
                break;
            case 30:
                name = "Thirty";
                break;
            case 40:
                name = "Fourty";
                break;
            case 50:
                name = "Fifty";
                break;
            case 60:
                name = "Sixty";
                break;
            case 70:
                name = "Seventy";
                break;
            case 80:
                name = "Eighty";
                break;
            case 90:
                name = "Ninety";
                break;
            default:
                if (digt > 0)
                {
                    name = tens(digit.Substring(0, 1) + "0") + " " + ones(digit.Substring(1));
                }
                break;
        }
        return name;
    }
    private String ones(String digit)
    {
        int digt = Convert.ToInt32(digit);
        String name = "";
        switch (digt)
        {
            case 1:
                name = "One";
                break;
            case 2:
                name = "Two";
                break;
            case 3:
                name = "Three";
                break;
            case 4:
                name = "Four";
                break;
            case 5:
                name = "Five";
                break;
            case 6:
                name = "Six";
                break;
            case 7:
                name = "Seven";
                break;
            case 8:
                name = "Eight";
                break;
            case 9:
                name = "Nine";
                break;
        }
        return name;
    }
    private String translateCents(String cents)
    {
        String cts = "", digit = "", engOne = "";
        for (int i = 0; i < cents.Length; i++)
        {
            digit = cents[i].ToString();
            if (digit.Equals("0"))
            {
                engOne = "Zero";
            }
            else
            {
                engOne = ones(digit);
            }
            cts += " " + engOne;
        }
        return cts;
    }
    private void OutputImg(string LedgerTranNo)   // For Bar Code - 
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
        MyBarcode.NarrowBarWidth = 0.02F;
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
}