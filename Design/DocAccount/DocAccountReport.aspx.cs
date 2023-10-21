using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

public partial class Design_DocAccount_DocAccountReport : System.Web.UI.Page
{

    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    //Page Property

    int MarginLeft = 20;
 
    int PageWidth = 550;
    int BrowserWidth = 800;



    //Header Property
    float HeaderHeight = 80;//207
    int XHeader = 20;//20
    int YHeader = 60;//80
    int HeaderBrowserWidth = 800;




    // BackGround Property
 
    bool BackGroundImage = false;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;
 
    DataTable dt = new DataTable();
    string ReportTypeforHeader = "";
    string Period = "";   
    protected void Page_Load(object sender, EventArgs e)
    {
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        if (!IsPostBack)
        {                                   
            if (Request.Form["ReportType"].ToString() != string.Empty && Request.Form["toDate"].ToString() != string.Empty && Request.Form["fromDate"].ToString()!=string.Empty)
                BindData(Request.Form["fromDate"].ToString(), Request.Form["toDate"].ToString(), Request.Form["ReportType"].ToString());
        }
    }
    protected void BindData(string fromDate, string toDate, string ReportType)
    {
        string ChkCredit =Util.GetString(Request.Form["ChkCredit"]);
        string CentreID = Request.Form["CentreID"].ToString();
        string DoctorID = Request.Form["DoctorID"].ToString();
		DoctorID = Regex.Replace(DoctorID, ",+", ",").Trim(',');
        string DepartmentID = Request.Form["DepartmentID"].ToString();
        string PanelID = Util.GetString(Request.Form["PanelID"]);
        string CategoryID = Util.GetString(Request.Form["CategoryID"]);

        string ddlPatientCount = Request.Form["PatientCount"].ToString();
        string txtPatientCount = Request.Form["PatientValue"].ToString();
        string ddlRefAmount = Request.Form["ShareAmtType"].ToString();
        string txtRefAmount = Request.Form["ShareAmtvalue"].ToString();
        ReportTypeforHeader = ReportType;
       string PrintSeperate = Request.Form["Printseparate"].ToString();
       
        try
        {
            MySqlConnection con = Util.GetMySqlCon();            
             Period = string.Concat(" Period From :", Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy"), " Period To :", Util.GetDateTime(toDate).ToString("dd-MMM-yyyy"));


            StringBuilder sb = new StringBuilder();
            //Patient Wise Doctor Share Report
            if (ReportType == "1")
            {

                sb.AppendLine("   SELECT  ");
                sb.AppendLine("   t.Patient PatientName,t.LedgerTransactionNo LabNo,t.DoctorName,Group_Concat(DISTINCT t.ItemName)ItemName  ,DATE_FORMAT(t.dtEntry,'%d-%b-%y')dtEntry,  ");
                sb.AppendLine("  SUM(t.Rate * t.Quantity) ItemGrossAmt,SUM(t.DiscountAmt) DiscountAmt,SUM(t.Amount) ItemNetAmt,sum(t.DoctorShare) DoctorShareAmount,(sum(t.DoctorShare)-sum(t.DiscountAmt))DoctorDiscountShareAmount, t.Doctor_ID  ");
                sb.AppendLine("  FROM (  "); 
                sb.AppendLine(" SELECT ua.LedgerTransactionNo ,ua.Date AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.AppendLine(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.AppendLine("  IF(ua.DoctorMasterShareAllow ='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.AppendLine(" IF(ua.ReferMasterShare=1,'Y','N') MasterShare, "); 
                sb.AppendLine(" IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0  ");
                sb.AppendLine(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2)  ");
                sb.AppendLine(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0  ");
                sb.AppendLine(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
                sb.AppendLine(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.AppendLine(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2)  ");
                sb.AppendLine(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.AppendLine(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2)  ");
                sb.AppendLine(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.AppendLine(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
                sb.AppendLine(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.AppendLine(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2)  ");
                sb.AppendLine(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.AppendLine(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.AppendLine(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.AppendLine(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2)  ");
                sb.AppendLine(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.AppendLine(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2)  ");
                sb.AppendLine(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.AppendLine(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.AppendLine(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.AppendLine(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2)  ");
                sb.AppendLine(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.AppendLine(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2) ");
                sb.AppendLine(" END,2),0) AS DoctorShare  ");  
                sb.AppendLine(" FROM utility_accountdata ua ");
                sb.AppendLine(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0  ");//and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1
						 
                 sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID <> 78  AND ds.Panel_ID=ua.Panel_ID ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID`  AND ds1.Panel_ID <> 78  AND IFNULL(ds1.ItemID,0)=0   AND ds1.Panel_ID=ua.Panel_ID ");
                sb.AppendLine(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
                sb.AppendLine(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
						 
                sb.AppendLine(" WHERE ua.date>=@fromdate AND ua.date<=@todate AND ua.ReferMasterShare=1  ");
                if (CategoryID != string.Empty)
                {        
                   // sb.AppendLine(" and im.Category in (" + CategoryID + ") ");
                }         
                if (PanelID != string.Empty)
                {         
                    sb.AppendLine(" and ua.Panel_ID IN (" + PanelID + ") ");
                }         
                if (CentreID != string.Empty)
                {         
                    sb.AppendLine(" and ua.CentreID in (" + CentreID + ") ");
                }         
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                    sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }
                       
                sb.Append("	 GROUP BY ua.Test_ID	)t  ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionNo=t.LedgerTransactionNo  ");
                sb.Append(" group by t.LedgerTransactionNo ");
                if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
                {
                    if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having t.Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having t.Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                    }
                    else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                    {
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 HAVING t.SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 HAVING t.SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                    else
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having t.Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having t.Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 and t.SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                }
             
                // salek 


                sb.Append(" UNION ALL   ");

                sb.AppendLine("   SELECT  ");
                sb.AppendLine("   t.Patient PatientName,t.LedgerTransactionNo LabNo,t.DoctorName,Group_Concat(DISTINCT t.ItemName)ItemName  ,DATE_FORMAT(t.dtEntry,'%d-%b-%y')dtEntry,  ");
                sb.AppendLine("   SUM(t.Rate * t.Quantity) ItemGrossAmt, SUM(t.DiscountAmt) DiscountAmt, SUM(t.Amount) ItemNetAmt,sum(t.DoctorShare) DoctorShareAmount,(sum(t.DoctorShare)-sum(t.DiscountAmt))DoctorDiscountShareAmount, t.Doctor_ID  ");
                sb.AppendLine("  FROM (  ");

                sb.Append(" SELECT ua.LedgerTransactionNo ,ua.Date AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName ,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare =1,'Y','N') MasterShare, ");

                sb.Append("  IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0  AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND ds2.DocShareAmt=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0   AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2)  END,2),0) AS DoctorShare   ");

                sb.Append(" FROM utility_accountdata ua  ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0  ");//and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1 


                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID <> 78  AND ds.Panel_ID=ua.Panel_ID ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID`  AND ds1.Panel_ID <> 78  AND IFNULL(ds1.ItemID,0)=0   AND ds1.Panel_ID=ua.Panel_ID ");
                sb.Append("  LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate  AND ua.ReferMasterShare=0  ");
                if (CategoryID != string.Empty)
                {
                    // sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                    sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }
                sb.Append(" GROUP BY ua.Test_ID	)t  ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionNo=t.LedgerTransactionNo  ");
                sb.Append(" group by t.LedgerTransactionNo ");
                if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
                {
                    if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having t.Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having t.Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                    }
                    else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                    {
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 HAVING t.SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 HAVING t.SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                    else
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 and t.SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 and t.SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                }
             
                sb.Append(" order by dtEntry ,LabNo ");//LedgerTransactionNo,
				
				// System.IO.File.WriteAllText(@"C:\Rohit1.txt", sb.ToString());
                con.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00'"));
                    da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59'"));
                    da.Fill(dt);
                    con.Close();
                if (Request.Form["ReportFormate"].ToString() == "0")
				{
                    if (dt.Rows.Count > 0)
                    {
                        List<getDetail> Doctor_ID = new List<getDetail>();
                     
                        StringBuilder Header = new StringBuilder();
                      //  Header.Append("<div style='width:1000px;'>");
                       
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (Doctor_ID.Where(g => g.Doctor_ID == Util.GetInt(dt.Rows[i]["Doctor_ID"].ToString())).Count() == 0)
                            {
                                using (DataTable dt1 = dt.AsEnumerable().Where(s => s.Field<string>("Doctor_ID") == Util.GetString(dt.Rows[i]["Doctor_ID"].ToString())).CopyToDataTable())
                                {
                                    if (PrintSeperate == "1")
                                    {
                                        Header = new StringBuilder();
                                    }
                                    for (int j = 0; j < dt1.Rows.Count; j++)
                                    {
                                        if (j == 0)
                                        {
                                            Doctor_ID.Add(new getDetail { Doctor_ID = Util.GetInt(dt.Rows[i]["Doctor_ID"].ToString()) });
                                            Header.Append("<div style='width:1000px;'>");
                                            Header.Append("<table style='width:1000px;border:1px solid #000; font-family:Times New Roman;font-size:16px;'>");
                                            Header.Append("<tr>");
                                            Header.Append("<td style='width:120px;font-weight:bold;' >Doctor Name : </td>");
                                            Header.AppendFormat("<td style='text-align:left;font-weight:bold;' colspan='7'>{0}</td>", dt1.Rows[j]["DoctorName"].ToString());
                                            Header.Append("</tr>");
                                        }                                      
                                        Header.Append("<tr>");                                      
                                        Header.AppendFormat("<td style='width:120px;'>{0}</td>", dt1.Rows[j]["LabNo"].ToString());
                                        Header.AppendFormat("<td style='width:140px;text-align:left; word-wrap: break-word;'>{0}</td>", dt1.Rows[j]["PatientName"].ToString());
                                        Header.AppendFormat("<td style='width:120px;text-align:left;word-wrap: break-word;'>{0}</td>", dt1.Rows[j]["dtEntry"].ToString());
                                        Header.AppendFormat("<td style='width:240px;text-align:left;word-wrap: break-word;'>{0}</td>", dt1.Rows[j]["ItemName"].ToString());
                                        Header.AppendFormat("<td style='width:80px;text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["ItemGrossAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:60px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["DiscountAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:60px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["ItemNetAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:60px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["DoctorShareAmount"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                      
                                        Header.Append("</tr>");
                                        if (j == dt1.Rows.Count - 1)
                                        {                                            
                                            Header.Append("<tr>");
                                            Header.AppendFormat("<td colspan='4' style='text-align:right;font-weight:bold;'>{0}</td>", string.Concat("Total (", dt1.Rows[j]["DoctorName"].ToString(),") :"));
                                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.AsEnumerable().Sum(x => x.Field<Decimal>("ItemGrossAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            Header.AppendFormat("<td  style='width:60px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.AsEnumerable().Sum(x => x.Field<Decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            Header.AppendFormat("<td  style='width:60px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.AsEnumerable().Sum(x => x.Field<Decimal>("ItemNetAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            Header.AppendFormat("<td  style='width:60px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.AsEnumerable().Sum(x => x.Field<Decimal>("DoctorShareAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                         
                                            Header.Append("</tr>");
                                            if (PrintSeperate == "1")
                                            {
                                                AddContent(Header.ToString());
                                            }
                                        }
                                    }
                                    Header.Append("</table></div>");
                                }
                            }
                        }
                        if (PrintSeperate == "0")
                        {
                            Header.Append("<div style='width:1000px;'>");
                            Header.Append("<table style='width:1000px;border:2px solid #000; font-family:Times New Roman;font-size:16px;'>");
                            Header.Append("<tr><td colspan='4' style='text-align:right;font-weight:bold;' >Total : </td>");
                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("ItemGrossAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("ItemNetAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("DoctorShareAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.Append("</tr></table></div>");                           
                            AddContent(Header.ToString());
                        }
                        Doctor_ID.Clear();       

						
                    } 
				}	
				else
				{
					Session["dtExport2Excel"] = dt;                               
					Session["ReportName"] = "Patient Wise Report";                                
					Response.Redirect("../common/ExportToExcel.aspx");
				}


					
                }
            }
            else if (ReportType == "0")
            {              
                sb.Append("   SELECT  ");
                sb.Append("   Patient PatientName,LedgerTransactionNo LabNo,DoctorName,ItemName  ,dtEntry,  ");
                sb.Append(" (Rate * Quantity) ItemGrossAmt,DiscountAmt,Amount ItemNetAmt,DoctorShare DoctorShareAmount, Doctor_ID  ");
                sb.Append("  FROM (  ");

                sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d/%m/%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow ='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare='1','Y','N') MasterShare, ");

                sb.Append("IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0  ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0  ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2) ");
                sb.Append(" END,2),0) AS DoctorShare  ");

                sb.Append(" FROM utility_accountdata ua ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0 and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1 and ua.DeptAllowshare=1 ");
               
             
                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON  ds.itemID=ua.`ItemId`  AND ds.Panel_ID=ua.Panel_ID  AND ds.Doctor_ID =0 ");
                sb.Append("  LEFT JOIN doctor_referral_share_items ds1 ON  ds1.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds1.ItemID,0)=0  AND ds1.Panel_ID=ua.Panel_ID AND ds1.Doctor_ID=0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate AND ua.ReferMasterShare=1  ");
                if (CategoryID != string.Empty)
                {
                    sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                   sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }             
                sb.Append("		)t  ");
                if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
                {
                    if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                    }
                    else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                    {
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                    else
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                }
                // salek 
                sb.Append(" UNION ALL   ");

                sb.Append("   SELECT  ");
                sb.Append("   Patient PatientName,LedgerTransactionNo LabNo,DoctorName,ItemName  ,dtEntry,  ");
                sb.Append(" (Rate * Quantity) ItemGrossAmt,DiscountAmt,Amount ItemNetAmt,DoctorShare DoctorShareAmount, Doctor_ID  ");
                sb.Append("  FROM (  ");

                sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d/%m/%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName ,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare ='1','Y','N') MasterShare, ");

                sb.Append(" IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0  AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND ds2.DocShareAmt=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0   AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2)  END,2),0) AS DoctorShare   ");

                sb.Append(" FROM utility_accountdata ua  ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0 and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1 and ua.DeptAllowshare=1 ");


                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID=ua.Panel_ID ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds1.ItemID,0)=0  AND ds1.Panel_ID=ua.Panel_ID ");
                sb.Append("  LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID`AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate  AND ua.ReferMasterShare=0  ");
                if (CategoryID != string.Empty)
                {
                    sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                    sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }
                sb.Append("		)t  ");
                if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
                {
                    if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                    }
                    else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                    {
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                    else
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                }

                sb.Append(" order by LedgerTransactionNo ");
				//System.IO.File.WriteAllText(@"C:\docreportreporttype0.txt", sb.ToString());
                con.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00'"));
                    da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59'"));
                    da.Fill(dt);
                    con.Close();
					if (Request.Form["ReportFormate"].ToString() == "0")
				{
                    if (dt.Rows.Count > 0)
                    {
                        List<getDetail> Doctor_ID = new List<getDetail>();
                        StringBuilder Header = new StringBuilder();
                       // Header.Append("<div style='width:1000px;'>");
                       
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (Doctor_ID.Where(g => g.Doctor_ID == Util.GetInt(dt.Rows[i]["Doctor_ID"].ToString())).Count() == 0)
                            {
                                using (DataTable dt1 = dt.AsEnumerable().Where(s => s.Field<string>("Doctor_ID") == Util.GetString(dt.Rows[i]["Doctor_ID"].ToString())).CopyToDataTable())
                                {
                                    if (PrintSeperate == "1")
                                    {
                                        Header = new StringBuilder();
                                    }
                                    for (int j = 0; j < dt1.Rows.Count; j++)
                                    {
                                        
                                        if (j == 0)
                                        {
                                            Doctor_ID.Add(new getDetail { Doctor_ID = Util.GetInt(dt.Rows[i]["Doctor_ID"].ToString()) });
                                            Header.Append("<div style='width:1000px;'>");
                                            Header.Append("<table style='width:1000px;border:1px solid #000; font-family:Times New Roman;font-size:16px;'>");
                                            Header.Append("<tr>");
                                            Header.Append("<td style='width:120px;font-weight:bold;' >Doctor Name : </td>");
                                            Header.AppendFormat("<td style='text-align:left;font-weight:bold;' colspan='7'>{0}</td>", dt1.Rows[j]["DoctorName"].ToString());
                                            Header.Append("</tr>");
                                        }
                                        Header.Append("<tr>");
                                        Header.AppendFormat("<td style='width:120px;'>{0}</td>", dt1.Rows[j]["LabNo"].ToString());
                                        Header.AppendFormat("<td style='width:140px;text-align:left; word-wrap: break-word;'>{0}</td>", dt1.Rows[j]["PatientName"].ToString());
                                        Header.AppendFormat("<td style='width:120px;text-align:left;word-wrap: break-word;'>{0}</td>", dt1.Rows[j]["dtEntry"].ToString());
                                        Header.AppendFormat("<td style='width:240px;text-align:left;word-wrap: break-word;'>{0}</td>", dt1.Rows[j]["ItemName"].ToString());
                                        Header.AppendFormat("<td style='width:80px;text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["ItemGrossAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["DiscountAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["ItemNetAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["DoctorShareAmount"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.Append("</tr>");
                                        if (j == dt1.Rows.Count - 1)
                                        {                                            
                                            Header.Append("<tr>");
                                            Header.AppendFormat("<td colspan='4' style='text-align:right;font-weight:bold;'>{0}</td>", string.Concat("Total (", dt1.Rows[j]["DoctorName"].ToString(), ") :"));
                                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.AsEnumerable().Sum(x => x.Field<Decimal>("ItemGrossAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.AsEnumerable().Sum(x => x.Field<Decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.AsEnumerable().Sum(x => x.Field<Decimal>("ItemNetAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.AsEnumerable().Sum(x => x.Field<Decimal>("DoctorShareAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                            Header.Append("</tr>");
                                            Header.Append("</table></div>");
                                            if (PrintSeperate == "1")
                                            {
                                                AddContent(Header.ToString());
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        if (PrintSeperate == "0")
                        {
                            Header.Append("<div style='width:1000px;'>");
                            Header.Append("<table style='width:1000px;border:2px solid #000; font-family:Times New Roman;font-size:16px;'>");
                            Header.Append("<tr><td colspan='4' style='text-align:right;font-weight:bold;' >Total : </td>");
                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("ItemGrossAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("ItemNetAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("DoctorShareAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.Append("</tr></table></div>");
                            AddContent(Header.ToString());
                        }
                       
                        Doctor_ID.Clear();
                        
                    }
				}
				else
				{
					Session["dtExport2Excel"] = dt;                               
					Session["ReportName"] = "Item Wise Report";                                
					Response.Redirect("../common/ExportToExcel.aspx");
				}
                }
            }
                // doctor wise Share Report
            else if (ReportType == "2")
            {
                sb.Append("   SELECT COUNT(DISTINCT LedgerTransactionNo) AS Total, ");
                sb.Append("   DoctorName,sum(Rate * Quantity) ItemGrossAmt,sum(DiscountAmt)DiscountAmt,sum(Amount) ItemNetAmt,sum(DoctorShare) DoctorShareAmount, Doctor_ID  ");
                sb.Append("  FROM (  ");

                sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d/%m/%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow ='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare='1','Y','N') MasterShare, ");

                sb.Append("IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0  ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0  ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2) ");
                sb.Append(" END,2),0) AS DoctorShare  ");

                sb.Append(" FROM utility_accountdata ua ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0 and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1 and ua.DeptAllowshare=1 ");
               
            
                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON  ds.itemID=ua.`ItemId`  AND ds.Panel_ID=ua.Panel_ID  AND ds.Doctor_ID =0 ");
                sb.Append("  LEFT JOIN doctor_referral_share_items ds1 ON  ds1.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds1.ItemID,0)=0  AND ds1.Panel_ID=ua.Panel_ID AND ds1.Doctor_ID=0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate AND ua.ReferMasterShare=1  ");
                if (CategoryID != string.Empty)
                {
                    sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                   sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }             
                     
                sb.Append("		)t  ");
                sb.Append(" group by Doctor_ID ");
                if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
                {
                    if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                    }
                    else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                    {
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                    else
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                }

                // salek 
                sb.Append(" UNION ALL   ");

                sb.Append("   SELECT COUNT(DISTINCT LedgerTransactionNo) AS Total, ");
                sb.Append("   DoctorName,sum(Rate * Quantity) ItemGrossAmt,sum(DiscountAmt)DiscountAmt,sum(Amount) ItemNetAmt,sum(DoctorShare) DoctorShareAmount, Doctor_ID  ");
                sb.Append("  FROM (  ");

                sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d/%m/%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName ,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare ='1','Y','N') MasterShare, ");

                sb.Append(" IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0  AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND ds2.DocShareAmt=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0   AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2)  END,2),0) AS DoctorShare   ");

                sb.Append(" FROM utility_accountdata ua  ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0 and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1 and ua.DeptAllowshare=1 ");


                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID=ua.Panel_ID ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds1.ItemID,0)=0   AND ds1.Panel_ID=ua.Panel_ID ");
                sb.Append("  LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID`AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate  AND ua.ReferMasterShare=0  ");
                if (CategoryID != string.Empty)
                {
                    sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                    sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }
                sb.Append("		)t  ");
                sb.Append(" group by Doctor_ID ");
                if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
                {
                    if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                    }
                    else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                    {
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                    else
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                }

                sb.Append(" order by Doctor_ID ");
                con.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00'"));
                    da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59'"));
                    da.Fill(dt);
                    con.Close();
                    if (dt.Rows.Count > 0)
                    {
                        StringBuilder Header = new StringBuilder();
                        Header.Append("<div style='width:1000px;'>");
                       
                        Header.Append("<div style='width:1000px;'>");
                        Header.Append("<table style='width:1000px;border:1px solid #000; font-family:Times New Roman;font-size:16px;'>");
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            Header.Append("<tr>");
                            Header.AppendFormat("<td style='width:380px; word-wrap: break-word;'>{0}</td>", dt.Rows[i]["DoctorName"].ToString());
                            Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt.Rows[i]["Total"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt.Rows[i]["ItemGrossAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt.Rows[i]["DiscountAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt.Rows[i]["ItemNetAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt.Rows[i]["DoctorShareAmount"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                            Header.Append("<td style='width:80px;font-weight:bold;' >&nbsp;</td>");
                            Header.Append("</tr>");
                        }
                        Header.Append("<tr >");
                        Header.AppendFormat("<td  style='text-align:right;font-weight:bold;width:380px;'></td>");
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", "Total :");
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;border-top:1px solid #000;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("ItemGrossAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;border-top:1px solid #000;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;border-top:1px solid #000;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("ItemNetAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;border-top:1px solid #000;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("DoctorShareAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        Header.Append("</tr></table></div>");
                        AddContent(Header.ToString());
                        
                    }                  
                }
            }
            // Department wise doctor  Share Report
            else if (ReportType == "3")
            {

                sb.Append("   SELECT COUNT(DISTINCT LedgerTransactionNo) AS Total, ");
                sb.Append("   Patient PatientName,LedgerTransactionNo LabNo,DoctorName,Group_Concat(ItemName)ItemName  ,Name DeptName,  ");
                sb.Append(" sum(Rate * Quantity) ItemGrossAmt,sum(DiscountAmt)DiscountAmt,sum(Amount) ItemNetAmt,sum(DoctorShare) DoctorShareAmount, Doctor_ID  ");
                sb.Append("  FROM (  ");

                sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d/%m/%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow ='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare='1','Y','N') MasterShare,ua.DeptName Name, ");

                sb.Append("IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0  ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0  ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds1.DocSharePer*0.01)) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2)  ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0  ");
                sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2) ");
                sb.Append(" END,2),0) AS DoctorShare  ");
                sb.Append(" FROM utility_accountdata ua ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0 and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1 and ua.DeptAllowshare=1 ");             
                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON  ds.itemID=ua.`ItemId`  AND ds.Panel_ID=ua.Panel_ID  AND ds.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON  ds1.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds1.ItemID,0)=0  AND ds1.Panel_ID=ua.Panel_ID AND ds1.Doctor_ID=0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate AND ua.ReferMasterShare=1  ");
                if (CategoryID != string.Empty)
                {
                    sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                  sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }               
                           
                sb.Append("		)t  ");
                sb.Append(" group by DeptName ");
                if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
                {
                    if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                    }
                    else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                    {
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                    else
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                }

                // salek 
                sb.Append(" UNION ALL   ");

                sb.Append("   SELECT COUNT(DISTINCT LedgerTransactionNo) AS Total, ");
                sb.Append("   Patient PatientName,LedgerTransactionNo LabNo,DoctorName,Group_Concat(ItemName)ItemName  ,Name DeptName,  ");
                sb.Append(" sum(Rate * Quantity) ItemGrossAmt,sum(DiscountAmt)DiscountAmt,sum(Amount) ItemNetAmt,sum(DoctorShare) DoctorShareAmount, Doctor_ID  ");
                sb.Append("  FROM (  ");

              
                sb.Append(" SELECT ua.LedgerTransactionNo ,DATE_FORMAT(ua.Date,'%d/%m/%Y') AS dtEntry,UPPER(ua.PName) Patient, ua.GrossAmount,ua.DiscountOnTotal,");
                sb.Append(" ua.NetAmount, (ua.NetAmount- ua.FinalAdjustment) AS Balance,    ua.ItemName ,ua.Rate,ua.Quantity,ua.`DiscountAmt`,ua.Amount,ua.itemid,ua.RemoveDocShareItemWise, ");
                sb.Append("  IF(ua.DoctorMasterShareAllow='1','Y','N') Referal ,ua.DoctorGroup Doctor_ID,ua.`DoctorName`,ua.`Mobile`,ua.`Specialization`,ua.`Phone1`,ua.`Phone2`,ua.Doctor_ID Doctor_ID1,");
                sb.Append(" IF(ua.ReferMasterShare ='1','Y','N') MasterShare,ua.DeptName Name, ");

                sb.Append(" IFNULL(ROUND(CASE WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND(((ds.DocShareAmt*ua.Quantity)),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0  AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds.DocSharePer*0.01)) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ds2.DocShareAmt*ua.Quantity)),2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds2.DocSharePer*0.01)) ,2) ");
                sb.Append(" WHEN ua.DiscountByLab=0 AND IFNULL(ds2.DocSharePer,0)=0 AND IFNULL(ds2.DocShareAmt,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND(((ua.Amount*ds3.DocSharePer*0.01)) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocShareAmt,0)!=0 ");
                sb.Append(" THEN ROUND((ds.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)!=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds1.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds1.DocSharePer*0.01) ,2) ");

                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocShareAmt,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ds2.DocShareAmt*ua.Quantity),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)!=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds2.DocSharePer*0.01),2) ");
                sb.Append(" WHEN ua.DiscountByLab=1 AND IFNULL(ds2.DocSharePer,0)=0 AND ds2.DocShareAmt=0 AND IFNULL(ds.DocShareAmt,0)=0 AND IFNULL(ds.DocSharePer,0)=0 AND IFNULL(ds1.`DocSharePer`,0)=0   AND IFNULL(ds3.`DocSharePer`,0)>0 ");
                sb.Append(" THEN ROUND((ua.Amount*ds3.DocSharePer*0.01) ,2)  END,2),0) AS DoctorShare   ");

                sb.Append(" FROM utility_accountdata ua  ");
                sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=ua.`ItemID` AND ua.RemoveDocShareItemWise=0 and ua.PanelDoctorShareAllow=1 and ua.DoctorMasterShareAllow=1 and ua.DeptAllowshare=1 ");


                sb.Append(" LEFT JOIN doctor_referral_share_items ds ON ds.Doctor_ID=ua.Doctor_ID AND ds.itemID=ua.`ItemId` AND ds.Panel_ID=ua.Panel_ID ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds1 ON ds1.Doctor_ID=ua.Doctor_ID AND ds1.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds1.ItemID,0)=0  AND ds1.Panel_ID=ua.Panel_ID ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds2 ON  ds2.itemID=ua.`ItemId`  AND ds2.Panel_ID=78  AND ds2.Doctor_ID =0 ");
                sb.Append(" LEFT JOIN doctor_referral_share_items ds3 ON  ds3.SubcategoryID=ua.`SubCategoryID` AND IFNULL(ds3.ItemID,0)=0  AND ds3.Panel_ID=78 AND ds3.Doctor_ID=0 ");
                sb.Append(" WHERE ua.date>=@fromdate AND ua.date<=@todate  AND ua.ReferMasterShare=0  ");
                if (CategoryID != string.Empty)
                {
                    sb.Append(" and im.Category in (" + CategoryID + ") ");
                }
                if (PanelID != string.Empty)
                {
                    sb.Append(" and ua.Panel_ID IN (" + PanelID + ") ");
                }
                if (CentreID != string.Empty)
                {
                    sb.Append(" and ua.CentreID in (" + CentreID + ") ");
                }
                if (DepartmentID != string.Empty)
                {
                    sb.Append("	and ua.SubCategoryID  in (" + DepartmentID + ")  ");
                }
                if (DoctorID != string.Empty)
                {
                    // sb.Append("	and ua.Doctor_ID  in (" + DoctorID + ")  ");
                }
                sb.Append("		)t  ");
                sb.Append(" group by DeptName ");
                if (txtPatientCount.Trim() != "" || txtRefAmount.Trim() != "")
                {
                    if (txtPatientCount.Trim() != "" && txtRefAmount.Trim() == "")
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                    }
                    else if (txtPatientCount.Trim() == "" && txtRefAmount.Trim() != "")
                    {
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 HAVING SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                    else
                    {
                        if (ddlPatientCount == "between")
                        {
                            sb.Append("	 having Total " + ddlPatientCount + " " + txtPatientCount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 having Total  " + ddlPatientCount + " " + txtPatientCount + "  ");
                        }
                        if (ddlRefAmount == "between")
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                        else
                        {
                            sb.Append("	 and SharedAmount " + ddlRefAmount + " " + txtRefAmount.Replace(",", " and ") + "  ");
                        }
                    }
                }

                sb.Append(" order by DeptName ");
                con.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00'"));
                    da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59'"));
                    da.Fill(dt);
                    con.Close();

                    if (dt.Rows.Count > 0)
                    {
                        List<getDetail> Doctor_ID = new List<getDetail>();

                        StringBuilder Header = new StringBuilder();
                        Header.Append("<div style='width:1000px;'>");
                       
                        for (int i = 0; i < dt.Rows.Count; i++)
                        {
                            if (Doctor_ID.Where(g => g.Doctor_ID == Util.GetInt(dt.Rows[i]["Doctor_ID"].ToString())).Count() == 0)
                            {
                                using (DataTable dt1 = dt.AsEnumerable().Where(s => s.Field<string>("Doctor_ID") == Util.GetString(dt.Rows[i]["Doctor_ID"].ToString())).CopyToDataTable())
                                {
                                    for (int j = 0; j < dt1.Rows.Count; j++)
                                    {
                                        if (j == 0)
                                        {
                                            Doctor_ID.Add(new getDetail { Doctor_ID = Util.GetInt(dt.Rows[i]["Doctor_ID"].ToString()) });
                                            Header.Append("<div style='width:1000px;'>");
                                            Header.Append("<table style='width:1000px;border:1px solid #000; font-family:Times New Roman;font-size:16px;'>");
                                            Header.Append("<tr>");
                                            Header.Append("<td style='font-weight:bold;' >Doctor Name : </td>");
                                            Header.AppendFormat("<td style='text-align:left;font-weight:bold;'>{0}</td>", dt1.Rows[j]["DoctorName"].ToString());
                                            Header.Append("</tr>");
                                        }
                                        Header.Append("<tr>");
                                        Header.AppendFormat("<td style='width:240px;'>{0}</td>", dt1.Rows[j]["DeptName"].ToString());                                  
                                        Header.AppendFormat("<td style='width:80px;text-align:right;'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["ItemGrossAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["DiscountAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["ItemNetAmt"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.AppendFormat("<td style='width:80px;text-align:right'>{0}</td>", Math.Round(Util.GetDecimal(dt1.Rows[j]["DoctorShareAmount"].ToString()), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                        Header.Append("</tr>");                                      
                                    }
                                    Header.Append("</table></div>");
                                }
                            }
                        }

                        Header.Append("<div style='width:1000px;'>");
                        Header.Append("<table style='width:1000px;border:2px solid #000; font-family:Times New Roman;font-size:16px;'>");
                        Header.Append("<tr><td style='text-align:right;font-weight:bold;width:240px;' >Total : </td>");
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("ItemGrossAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("DiscountAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("ItemNetAmt"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        Header.AppendFormat("<td  style='width:80px;text-align:right;font-weight:bold;'>{0}</td>", Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Decimal>("DoctorShareAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                        Header.Append("</tr></table></div>");
                        Doctor_ID.Clear();
                        AddContent(Header.ToString());                        
                    }
                }
            }           
            if (dt.Rows.Count > 0)
            {              
                mergeDocument();           
                byte[] pdfBuffer = document.WriteToMemory();
                HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                HttpContext.Current.Response.End();
                dt.Dispose();
            }
            else
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'>No Record Found <span><br/></center>");
                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            PdfHtml linehtml = new PdfHtml(XFooter, -4, "<div style='width:1140px;border-top:3px solid black;'></div>", null);

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
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }
    private void AddContent(string Content)
    {

        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(MarginLeft, 0, PageWidth, Content, null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;
        html1.ImagesCutAllowed = false;
        html1LayoutInfo = page1.Layout(html1);
    }
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;
        if (BackGroundImage == true)
        {
            HeaderImg = "";
            page1.Layout(getPDFBackGround(HeaderImg));
        }
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);       
    }
    private string MakeHeader()
    {
        StringBuilder Header = new StringBuilder();
        if (dt.Rows.Count > 0)
        {
            //ItemWise Header
            if (ReportTypeforHeader == "0")
            {
                Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
                Header.Append("<tr><td style='text-align:center;padding:15px 5px;'><span style='font-size:20px !important;font-weight:bold; text-align:center;'>Item Wise Report </span>");
                Header.Append("</br>");
                Header.AppendFormat("<span style='font-size:16px !important;font-weight:bold; text-align:center;'>{0}</span>", Period);
                Header.Append("</td></tr></table>");
                Header.Append("<div style='width:1000px;'>");
                Header.Append("<table style='width:1000px;border:1px solid #000; font-family:Times New Roman;font-size:16px;'>");
                Header.Append("<tr>");
                Header.Append("<td style='width:120px;font-weight:bold;' >LabNo</td>");
                Header.Append("<td style='width:140px;font-weight:bold;text-align:left;' >Patient Name</td>");
                Header.Append("<td style='width:120px;font-weight:bold;text-align:left' >Date</td>");
                Header.Append("<td style='width:240px;font-weight:bold;text-align:left' >Test Name</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >GrossAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >DiscAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >NetAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >ShareAmt</td>");
                Header.Append("</tr></table></div>");
            }
                //PatientWise Header
            else if (ReportTypeforHeader == "1")
            {               
                Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
                Header.Append("<tr>");
                Header.Append("<td style='text-align:center;padding:15px 5px;'><span style='font-size:20px !important;font-weight:bold; text-align:center;'>Patient Wise Report </span>");
                Header.Append("</br>");
                Header.AppendFormat("<span style='font-size:16px !important;font-weight:bold; text-align:center;'>{0}</span>", Period);
                Header.Append("</td></tr></table>");
                Header.Append("<div style='width:1000px;'>");
                Header.Append("<table style='width:1000px;border:1px solid #000; font-family:Times New Roman;font-size:16px;'>");
                Header.Append("<tr>");
                Header.Append("<td style='width:120px;font-weight:bold;' >LabNo</td>");
                Header.Append("<td style='width:140px;font-weight:bold;text-align:left;' >Patient Name</td>");
                Header.Append("<td style='width:120px;font-weight:bold;text-align:left' >Date</td>");
                Header.Append("<td style='width:240px;font-weight:bold;text-align:left' >Test Name</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >GrossAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >DiscAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >NetAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >ShareAmt</td>");
                Header.Append("</tr></table></div>");
            }
                //DoctorWise Header
            else if (ReportTypeforHeader == "2")
            {
                Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
                Header.Append("<tr>");
                Header.Append("<td style='text-align:center;padding:15px 5px;'><span style='font-size:20px !important;font-weight:bold; text-align:center;'>Doctor Wise Report </span>");
                Header.Append("</br>");
                Header.AppendFormat("<span style='font-size:16px !important;font-weight:bold; text-align:center;'>{0}</span>", Period);
                Header.Append("</td>");
                Header.Append("</tr>");
                Header.Append("</table>");
                Header.Append("<div style='width:1000px;'>");
                Header.Append("<table style='width:1000px;border:1px solid #000; font-family:Times New Roman;font-size:16px;'>");
                Header.Append("<tr>");
                Header.Append("<td style='width:380px;font-weight:bold;' >Doctor Name</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >TotalPatient</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >GrossAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >DiscAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >NetAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >ShareAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;' >&nbsp;</td>");
                Header.Append("</tr></table></div>");
            }
                //DepartmentWise Header
            else if (ReportTypeforHeader == "3")
            {
                Header.Append("<table style='width:1000px;border-collapse:collapse;font-family:Times New Roman;font-size:15px;'");
                Header.Append("<tr>");
                Header.Append("<td style='text-align:center;padding:15px 5px;'><span style='font-size:20px !important;font-weight:bold; text-align:center;'>Deprtment Wise Share Report </span>");
                Header.Append("</br>");
                Header.AppendFormat("<span style='font-size:16px !important;font-weight:bold; text-align:center;'>{0}</span>", Period);
                Header.Append("</td></tr></table>");
                Header.Append("<div style='width:1000px;'>");
                Header.Append("<table style='width:1000px;border:1px solid #000; font-family:Times New Roman;font-size:16px;'>");
                Header.Append("<tr>");
                Header.Append("<td style='width:240px;font-weight:bold;' >Department Name</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >GrossAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >DiscAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >NetAmt</td>");
                Header.Append("<td style='width:80px;font-weight:bold;text-align:right' >ShareAmt</td>");
                Header.Append("</tr></table></div>");
            }
        }
        return Header.ToString();
    }
    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader - 40, PageWidth, MakeHeader(), null);
        //   page.Header.Layout(getPDFImageforbarcode(15, 140, drcurrent["LedgerTransactionNo"].ToString()));
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

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

    public class getDetail
    {
        public int Doctor_ID { get; set; }
    }
  
}