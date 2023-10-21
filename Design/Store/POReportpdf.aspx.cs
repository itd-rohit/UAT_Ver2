using HiQPdf;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;

public partial class Design_Store_POReportpdf : System.Web.UI.Page
{
    private PdfDocument document;
    private PdfDocument tempDocument;
    private PdfLayoutInfo html1LayoutInfo;
    private DataTable dtObs;
    private DataTable dtSettlement;
    private DataTable dtRefund;

    //Page Property

    private int MarginLeft = 20;
    private int MarginRight = 30;
    private int PageWidth = 550;
    private int BrowserWidth = 800;
    private string path = "../../App_Images/ITdoseLogo.png";
    //Header Property
    //bool HeaderImage = false;
    //string HeaderImg = "";
    //string nabllogo = "../App_Images/mynabl.jpg";
    private float HeaderHeight = 30;//207

    private int XHeader = 20;//20
    private int YHeader = 60;//80
    private int HeaderBrowserWidth = 800;

    // BackGround Property
    private bool HeaderImage = true;

    private bool FooterImage = false;
    private bool BackGroundImage = false;
    private string HeaderImg = "";

    //Footer Property 80
    private float FooterHeight = 60;

    private int XFooter = 20;

    private DataRow drcurrent;

    private string id = "";
    private string name = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            id = Util.GetString(UserInfo.ID);
            name = Util.GetString(UserInfo.LoginName);
        }
        catch { }
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;

        if (!IsPostBack)
        {
            BindData();
        }

    }

    protected void BindData()
    {
        try
        {
            DataSet DsInvoice = ((DataSet)Session["ItemsDetail"]);
            DataTable dtInvoice = DsInvoice.Tables[0];
            //DataTable dtCm = DsInvoice.Tables[1];
           // DataTable dtAccountSumm = DsInvoice.Tables[2];
            if (dtInvoice != null && dtInvoice.Rows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();

             sb.Append("<div>"); 
            sb.Append("<table style='border: 0px solid;border-collapse:collapse'>");
            sb.Append("<tr>");
            sb.Append("<td style='border-style: solid; border-width: 1pt; width:1022pt;height:74pt;'>");
            sb.Append("<img  src='D:/GITNEW/Uat_ver1/App_Images/ITdoseLogo.png' />");
            sb.Append("<b>&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;&nbsp;&nbsp&nbsp;Purchase Order</b></td>");
           //  sb.Append("<img  src='../../App_Images/yoda_logo1.png' style='width: 239px; height: 123px' />");  
           // sb.Append(" <td><img style='width:100px;height:80px;' src='../../App_Images/yoda_logo1.png' /></td>");
	        sb.Append("</tr>");
        
            sb.Append("<tr style='height:20pt'>"); 
			sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
			   
            sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:12px;'>");
            sb.Append("<tr>");
            sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
            sb.Append("<span> <b>PO No:</b> " + Util.GetString(dtInvoice.Rows[0]["PONumber"]) + " ");  
	        sb.Append("</span>");
                    
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("<span><b> PO  Date: </b>" + Util.GetString(dtInvoice.Rows[0]["PODate"]) + " "); 
			sb.Append("</span>");
     
			sb.Append("</td>");
			sb.Append("</tr>");
            sb.Append("</table>");    
             sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr style='height:20pt'>");   
			sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
            sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
            sb.Append("<tr>");
            sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
            sb.Append("<span> <b>Ordered By </b>");

		    sb.Append("</span>");
                    
            sb.Append("</td>");
            sb.Append("<td>");
            sb.Append("<span><b> Vendor Details </b>");  
		    sb.Append("</span>");
     
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");    
            sb.Append("</td>");
            sb.Append("</tr>");
             sb.Append("<tr style='height:20pt'>");   
			 sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
             sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
             sb.Append("<tr>");
             sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
             sb.Append("<span><b>Itdose Infosystem Pvt Ltd </b>");  
		     sb.Append("</span>");
                    
             sb.Append("</td>");
             sb.Append("<td>");
             sb.Append("<span><b> Vendor Details </b>"); 
		     sb.Append("</span>");
     
             sb.Append("</td>");
                       sb.Append("</tr>");
                       sb.Append("</table>");    
                       sb.Append("</td>");
                       sb.Append("</tr>");
           
					   sb.Append("<tr>");
                       sb.Append("<td  style='width: 100%; text-align: left; vertical-align: top; '>");
                       sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                       sb.Append("<tr style='height:50pt'>");
                       sb.Append("<td style=' width: 50%; border-right: 1px solid; '><span><b>Address:</b>" + Util.GetString(dtInvoice.Rows[0]["DeliveryAddress"]) + "  </span></br>");
                       //sb.Append("<span>Address:" + Util.GetString(dtInvoice.Rows[0]["deliveryGSTINAddress"]) + "");
                       sb.Append("<span> <b>Contact: </b>" + Util.GetString(dtInvoice.Rows[0]["MakerUser"]) + "");  
					   sb.Append("</span>"); 
					   sb.Append("</br>");
                       sb.Append("<span><b>Gsttin:</b> " + Util.GetString(dtInvoice.Rows[0]["GSTTin"]) + ""); 
					   sb.Append("</span>");
                       sb.Append("</td>");
                       // sb.Append("<td> <span><b>Address:</b>" + Util.GetString(dtInvoice.Rows[0]["VendorAddress"]) + "  </span></br>");
                       // sb.Append("<span> <b>Contact: </b>" + Util.GetString(dtInvoice.Rows[0]["VendorMobile"]) + "");  
					   // sb.Append("</span>");   
					   // sb.Append("</br>");
                       // sb.Append("<span> <b>Gsttin:</b> " + Util.GetString(dtInvoice.Rows[0]["VendorGSTIN"]) + "");   
					   // sb.Append("</span>");
                       // sb.Append("</td>");
					    sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
                       sb.Append("<span><b>Vendor Name: </b>" + Util.GetString(dtInvoice.Rows[0]["VendorName"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Vendor Address:</b> " + Util.GetString(dtInvoice.Rows[0]["VendorAddress"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Contact Person:</b>" + Util.GetString(dtInvoice.Rows[0]["VendorContactPerson"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Vendor Mobile:</b> " + Util.GetString(dtInvoice.Rows[0]["VendorMobile"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Vendor Email: </b>" + Util.GetString(dtInvoice.Rows[0]["VendorEmail"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span> <b>Gsttin: </b>" + Util.GetString(dtInvoice.Rows[0]["VendorGSTIN"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</td>");
                       sb.Append("</tr>");
                       sb.Append("</table>");   
                       sb.Append("</td>");
                       sb.Append("</tr>");
                       sb.Append("<tr style='height:20pt'>");   
				       sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                       sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                       sb.Append("<tr>");
                       sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
                       sb.Append("<span> <b>Delivery State : </b>" + Util.GetString(dtInvoice.Rows[0]["deliveryState"]) + " ");  
					   sb.Append("</span>");                  
                       sb.Append("</td>");
                       sb.Append("<td>");
                       sb.Append("<span><b>Delivery Centre :</b>" + Util.GetString(dtInvoice.Rows[0]["centrecode"]) + " ~ " + Util.GetString(dtInvoice.Rows[0]["centre"]) + "");  
					   sb.Append("</span>");
     
                       sb.Append("</td>");
					   sb.Append("</tr>");
                       sb.Append("</table>");
                       sb.Append("</td>");
                       sb.Append("</tr>");
                       sb.Append("<tr style='height:20pt'>");
                       sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                       sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                       sb.Append("<tr>");
                       sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
                       sb.Append("<span><b>Bill to Itdose Infosystem GST Address  </b>");
                       sb.Append("</span>");

                       sb.Append("</td>");
                       sb.Append("<td>");
                       sb.Append("<span><b>Shipp to Address </b>");
                       sb.Append("</span>");

                       sb.Append("</td>");
                       sb.Append("</tr>");
                       sb.Append("</table>");    
                       sb.Append("</td>");
                       sb.Append("</tr>");
                       sb.Append("<tr>");
                       sb.Append("<td  style='width: 100%; text-align: left; vertical-align: top; '>");
                       sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                       sb.Append("<tr style='height:50pt'>");
                       sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
                       sb.Append("<span><b>Name: </b>" + Util.GetString(dtInvoice.Rows[0]["Location"]) + " "); 
					   sb.Append("</span>");  
					   sb.Append("</br>");
                       sb.Append("<span><b>Address:</b> " + Util.GetString(dtInvoice.Rows[0]["DeliveryAddress"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Contact Person:</b>" + Util.GetString(dtInvoice.Rows[0]["ContactPerson"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Mobile:</b> " + Util.GetString(dtInvoice.Rows[0]["MakerUser"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Email: </b>" + Util.GetString(dtInvoice.Rows[0]["ContactPersonEmail"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span> <b>Gsttin: </b>" + Util.GetString(dtInvoice.Rows[0]["GSTTin"]) + " ");  
					   sb.Append("</span>");
                       sb.Append("</td>");
					   sb.Append("<td>");
						   
					   sb.Append("</td>");
                       // sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
                       // sb.Append("<span><b>Vendor Name: </b>" + Util.GetString(dtInvoice.Rows[0]["VendorName"]) + " ");
                       // sb.Append("</span>");
                       // sb.Append("</br>");
                       // sb.Append("<span><b>Vendor Address:</b> " + Util.GetString(dtInvoice.Rows[0]["VendorAddress"]) + " ");
                       // sb.Append("</span>");
                       // sb.Append("</br>");
                       // sb.Append("<span><b>Contact Person:</b>" + Util.GetString(dtInvoice.Rows[0]["VendorContactPerson"]) + " ");
                       // sb.Append("</span>");
                       // sb.Append("</br>");
                       // sb.Append("<span><b>Vendor Mobile:</b> " + Util.GetString(dtInvoice.Rows[0]["VendorMobile"]) + " ");
                       // sb.Append("</span>");
                       // sb.Append("</br>");
                       // sb.Append("<span><b>Vendor Email: </b>" + Util.GetString(dtInvoice.Rows[0]["VendorEmail"]) + " ");
                       // sb.Append("</span>");
                       // sb.Append("</br>");
                       // sb.Append("<span> <b>Gsttin: </b>" + Util.GetString(dtInvoice.Rows[0]["VendorGSTIN"]) + " ");
                       // sb.Append("</span>");
                       // sb.Append("</td>");
					    sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
                       sb.Append("<span><b>Name: </b>" + Util.GetString(dtInvoice.Rows[0]["Location"]) + " "); 
					   sb.Append("</span>");  
					   sb.Append("</br>");
                       sb.Append("<span><b>Address:</b> " + Util.GetString(dtInvoice.Rows[0]["DeliveryAddress"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Contact Person:</b>" + Util.GetString(dtInvoice.Rows[0]["ContactPerson"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Mobile:</b> " + Util.GetString(dtInvoice.Rows[0]["MakerUser"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span><b>Email: </b>" + Util.GetString(dtInvoice.Rows[0]["ContactPersonEmail"]) + " ");
                       sb.Append("</span>");
                       sb.Append("</br>");
                       sb.Append("<span> <b>Gsttin: </b>" + Util.GetString(dtInvoice.Rows[0]["GSTTin"]) + " ");  
					   sb.Append("</span>");
                       sb.Append("</td>");
					   sb.Append("</tr>");
					   sb.Append("</table>");   
					   sb.Append("</td>");
					   sb.Append("</tr>");
                       sb.Append("<tr style='height:20pt'>"); 
					   sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                       sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                       sb.Append("<tr>");
                       sb.Append("<td style=' width: 50%; border-right: 1px solid; '>");
                       sb.Append("<span><b>Vendor State:</b> " + Util.GetString(dtInvoice.Rows[0]["VendorState"]) + " ");
 					   sb.Append("</span>");                  
                       sb.Append("</td>");
                       sb.Append("<td>");   
                       sb.Append("</td>");
                       sb.Append("</tr>");
					   sb.Append("</table>");    
                       sb.Append("</td>");
                       sb.Append("</tr>");   
                       sb.Append("</table>");   
                       sb.Append("<table style='border: 1px solid;:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px; border-bottom: 1px solid; border-left: 1px solid; border-right: 1px solid;'>");
                       sb.Append("<tr style='height: 40px; border-bottom: 1px solid;'>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>S.No </b> ");
					   sb.Append("</td>");
                       sb.Append("<td style='width: 10%;  border-right: 1px solid;'><b>ItemName/Item Code</b>");  
                       sb.Append("</td>");					   
                       sb.Append("<td style='width: 5%;  border-right: 1px solid;'><b>HSN Code </b> "); 
				       sb.Append("</td>");
					   sb.Append("<td style='width: 5%;  border-right: 1px solid;'><b>Cat No.</b>");  
                       sb.Append("</td>");
                       sb.Append("<td style='width: 10%;  border-right: 1px solid;'><b>MFD</b> "); 
				       sb.Append("</td>");
                       sb.Append("<td style='width: 6%;  border-right: 1px solid;'><b>Machine </b>"); 
				       sb.Append("</td>");
                       sb.Append("<td style='width: 5%;  border-right: 1px solid;'><b>Unit</b>");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Pack Size</b>");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Qty</b>");   
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Price</b> ");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Disc </b>");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Tax %</b>");  
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>GST  Amnt.(Rs)</b>");   
				       sb.Append("</td>");
                       sb.Append("<td style='width: 3%;  border-right: 1px solid;'><b>Amnt.(Rs)</b> ");    
				       sb.Append("</td>");
                       sb.Append("</tr>");
                          // For Add  Dynamic Data
                       //float totalCGST = 0;
                       //float totalQty = 0;
                       //float totalUnitPrice = 0;
                       //float totalDisc = 0;
                       //float totalTax = 0;
                       //float totalIGST = 0;
                       float totalAmount = 0;
                     //  float alltotal = 0;
                       for (int k = 0; k < dtInvoice.Rows.Count; k++)
                       {
                           int J = k + 1;
                           sb.Append("<tr style='height: 40px; border-bottom: 1px solid;'>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'> "+J+"  ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 10%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["ItemName"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["HSN_SAC_CODE"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 4%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["User"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 10%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["status"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 6%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["Warranty"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 5%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["UOM"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["CGST"]) + "");//pack size
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["Qty"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["UnitPrice"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["Disc"]) + " ");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["Tax"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["IGST"]) + "");
                           sb.Append("</td>");
                           sb.Append("<td style='width: 3%;  border-right: 1px solid;'>" + Util.GetString(dtInvoice.Rows[k]["Amount"]) + " ");
                           sb.Append("</td>");
                           sb.Append("</tr>");
                           //totalCGST = Util.GetFloat(dtInvoice.Rows[0]["CGST"]);
                           //totalQty = Util.GetFloat(dtInvoice.Rows[0]["Qty"]);
                           //totalUnitPrice = Util.GetFloat(dtInvoice.Rows[0]["UnitPrice"]);
                           //totalDisc = Util.GetFloat(dtInvoice.Rows[0]["Disc"]);
                           //totalTax = Util.GetFloat(dtInvoice.Rows[0]["Tax"]);
                           //totalIGST = Util.GetFloat(dtInvoice.Rows[0]["IGST"]);
                           totalAmount =totalAmount+Util.GetFloat(dtInvoice.Rows[k]["Amount"]);

                           //alltotal=totalCGST*totalQty*totalUnitPrice+
                       }
                    sb.Append("</table>"); 

               sb.Append("<table style='border: 1px solid;border-collapse:collapse'>"); 
                sb.Append("<tr>");
             
                sb.Append("<td style='width: 10%; text-align: right; border-right: 1px solid; font-weight: bold;  padding-right: 10px;'>");
                sb.Append("<span>Total : " + totalAmount + " ");  
                sb.Append("</span>"); 
				sb.Append("</td>");
                sb.Append("</tr>");          
                sb.Append("</table>"); 
                sb.Append("<table style='border-collapse:collapse'>");
                sb.Append("<tr style='height:20pt'>"); 
				sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
                sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
                sb.Append("<tr>");
                sb.Append("<td style='width: 100%; border-right: 1px solid;'>");
                sb.Append("<span>Note : All conditions, warranty, service and support as per PO. Prices are F.O.R. Itdose Infosystem Pvt Ltd");
                sb.Append("</span>");
                    
                sb.Append("</td>");
                  
               sb.Append("</tr>");
               sb.Append("</table>");    
               sb.Append("</td>");
               sb.Append("</tr>");
               sb.Append("<tr style='height:20pt'>"); 
			   sb.Append("<td style='width: 100%; text-align: left; vertical-align: top;'>");
               sb.Append("<table style='border: 1px solid;width: 100%; font-family:Times New Roman;font-size:15px;'>");
               sb.Append("<tr>");
               sb.Append("<td style=' width: 100%; border-right: 1px solid; '> &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; ");
               sb.Append("<span><b>Terms and Conditions<b>");
               sb.Append("</span>");                   
               sb.Append("</td>");                 
               sb.Append("</tr>");
               
               sb.Append("</table>");    
               sb.Append("</td>");
               sb.Append("</tr>");
               sb.Append("<tr>");
               sb.Append("<td style=' width: 100%;  '>");
               sb.Append("<span>1. Please ensure that your invoice margin matches the margin shown in this PO. Product will be rejected if cost  and margin do not match. ");
               sb.Append("</span>");               
               sb.Append("</td>");
               sb.Append("</tr>");
               sb.Append("<tr>");
               sb.Append("<td style=' width: 100%;  '>");
               sb.Append("<span>2. Delivery is said to be completed only when goods inward receipt is made by Itdose Infosystem Pvt Ltd, which requires the following set of papers:</br>");
               sb.Append("a - Copy of the PO with signature & stamp of vendor`s </br>");
               sb.Append("b - Printed GST Invoice from vendor.");
               sb.Append("</span>");
               sb.Append("</td>");
               sb.Append("</tr>");
               sb.Append("<tr>");
               sb.Append("<td style=' width: 100%;  '>");
               sb.Append("<span>3. All disputes between the parties will be governed by the laws of India and subject to jurisdiction of  Hyderabad Court. ");
               sb.Append("</span>");
               sb.Append("</td>");
               sb.Append("</tr>");
               sb.Append("<tr>");
               sb.Append("<td style=' width: 100%;  '>");
               sb.Append("<span>4. Itdose Infosystem Pvt Ltd. reserves the right to reject the goods whenever the product is not adhering to quality   standards.");
               sb.Append("</span>");
               sb.Append("</td>");
               sb.Append("</tr>");
               sb.Append("<tr>");
               sb.Append("<td style=' width: 100%;  '>");
               sb.Append("<span>5. Purchase order number must be mentioned in the invoice for each material.");
               sb.Append("</span>");
               sb.Append("</td>");
               sb.Append("</tr>");
               sb.Append("<tr>");
               sb.Append("<td style=' width: 100%;  '>");
               sb.Append("<span>6. Please revert within 24 hours for any changes you may require.");
               sb.Append("</span>");
               sb.Append("</td>");
               sb.Append("</tr>");
               //sb.Append("<tr>");
               //sb.Append("<td style=' width: 100%;  '>");
               //sb.Append("<span>7. Please ensure that you do not include more than one PO in one tax invoice. If one invoice includes more than one PO, we shall be constraint to reject your invoice.However you may include more than one delivery invoice against one PO");
               //sb.Append("</span>");
               //sb.Append("</td>");
               //sb.Append("</tr>");
               //sb.Append("<tr>");
               sb.Append("<td style=' width: 100%;  '>");
               sb.Append("<span>7. Product not found acceptable as per Itdose Infosystem Pvt Ltd evaluation scale Returned back.");
               sb.Append("</span>");
               sb.Append("</td>");

               sb.Append("</tr>");
               sb.Append("</table>");
               sb.Append("</div>");
               AddContent(sb.ToString());
               SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
               mergeDocument();
               byte[] pdfBuffer = document.WriteToMemory();
               HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
               HttpContext.Current.Response.BinaryWrite(pdfBuffer);
               HttpContext.Current.Response.End();
            }
        }

        catch (Exception Ex)
        {
            //lblmsg.Text = Ex.Message;
        }
        finally
        {
            Session["dtInvoice"] = "";
            Session.Remove("dtInvoice");
        }

    }

    private void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        if (BackGroundImage == true)
        {
            HeaderImg = "";
            page1.Layout(getPDFBackGround(HeaderImg));
        }

        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
    }

    private PdfImage getPDFImage(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader - 80, YHeader - 40, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);
        string path = "../../App_Images/yoda_logo1.jpg";
        
        if (HeaderImage)
        {
            //page.Header.Layout(getPDFImageHeader(path));
        }
    }

    private PdfImage getPDFImageHeader(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(10, 3, 150, Server.MapPath(SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }
    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
            if (FooterImage)
            {
                page.Footer.Layout(getPDFImageFooter(drcurrent["FooterImage"].ToString()));
            }
        }
    }

    private PdfImage getPDFImageforbarcode(float X, float Y, string labno)
    {
        string image = "";
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Base64StringToImage(image));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }
    public System.Drawing.Image Base64StringToImage(string base64String)
    {
        byte[] imageBytes = Convert.FromBase64String(base64String.Replace("data:image/png;base64,", ""));
        MemoryStream memStream = new MemoryStream(imageBytes, 0, imageBytes.Length);

        memStream.Write(imageBytes, 0, imageBytes.Length);
        System.Drawing.Image image = System.Drawing.Image.FromStream(memStream);
        Bitmap newImage = new Bitmap(240, 30);
        using (Graphics graphics = Graphics.FromImage(newImage))
            graphics.DrawImage(image, 0, 0, 240, 30);
        return newImage;
    }

    private PdfImage getPDFBackGround(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(225, 110, 200, Server.MapPath("~/" + SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }

    private PdfImage getPDFImageFooter(string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(20, 0, Server.MapPath(SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        return transparentResizedPdfImage;
    }

    private string MakeHeader()
    {
        string headertext = "";
        StringBuilder Header = new StringBuilder();
       // Header.Append("<div style='width:1000px;'>");
       // Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
       // Header.Append("<tr>");
       // Header.Append("    <td class='auto-style1'><img style='width:200px;height:80px;' src='../../App_Images/yoda_logo1.png' /></td>");
       // Header.Append("     <td style='text-align:left;'>");
       //// Header.Append("         <h2>Bill of Supply</h2>");
       // Header.Append("     </td>");
       // Header.Append("</tr>");
       // Header.Append("</table>");
        return Header.ToString();
    }
    private void AddContent(string Content)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(MarginLeft, ((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height), PageWidth, Content, null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;
        html1.ImagesCutAllowed = false;
        html1LayoutInfo = page1.Layout(html1);
    }

    private void mergeDocument()
    {
        DataSet DsInvoice = ((DataSet)Session["ItemsDetail"]);
        DataTable dtInvoice = DsInvoice.Tables[0];
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            PdfHtml linehtml = new PdfHtml(XFooter, -5, "<div style='width:1140px;border-top:3px solid black;'></div>", null);
            PdfHtml satushtml = new PdfHtml(XFooter, -2, "<table style='border: 1px solid;width: 1150px; font-family:Times New Roman;font-size:20px;'><tr><td style='border-right: 1px solid;'><span><b>Created By :" + Util.GetString(dtInvoice.Rows[0]["CreatedByName"]) + "</b></span></td><td style=' border-right: 1px solid; '><span><b>Checked By :" + Util.GetString(dtInvoice.Rows[0]["CheckedByName"]) + " </b></span></td><td><span><b>Approved By :" + Util.GetString(dtInvoice.Rows[0]["AppprovedByName"]) + "</b></span></td></tr></table>", null);
            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth - 20, FooterHeight - 40, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;

            PdfText printdatetime = new PdfText(PageWidth - 520, FooterHeight - 40, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;

            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);
            }
            p.Footer.Layout(linehtml);
            p.Footer.Layout(satushtml);
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }

    public void test()
    {
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
}