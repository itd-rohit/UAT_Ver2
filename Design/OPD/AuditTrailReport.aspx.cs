using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text.RegularExpressions;
using Newtonsoft.Json;

public partial class Design_Store_MIS_AuditTrailReport : System.Web.UI.Page
{

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            DataTable dt = StockReports.GetDataTable("select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.centreId");
            if (dt.Rows.Count > 0)
            {
                lstCentre.DataSource = dt;
                lstCentre.DataTextField = "Centre";
                lstCentre.DataValueField = "CentreID";
                lstCentre.DataBind();
            } 
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string dtFrom, string dtTo, string CentreID,string UserID, string ReportType, string compare,string labno)
    {
        try
        {
            string _checkSession = Util.GetString(UserInfo.Centre);
        }
        catch
        {
            return "-1";
        }
        if (CentreID != "")
        {
            CentreID = "'" + CentreID + "'";
            CentreID = CentreID.Replace(",", "','");
        } 
        if (UserID != "")
        {
            UserID = "'" + UserID + "'";
            UserID = UserID.Replace(",", "','");
        }
        DataTable dt =new DataTable();
        StringBuilder sb = new StringBuilder();
        if (ReportType == "1")///Demographic Summary
        {
            sb.AppendLine(@" SELECT plous.`LedgerTransactionNo` LabNo,(SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.CreatedByID) RegBy,
                             DATE_FORMAT(lt.`Date`,'%d-%b-%Y %H:%i %p') RegDate,plous.`Status`,plous.`UserName` StatusBy,DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') StatusDate,
                            IFNULL(plous.`OLDNAME`,'')OLDNAME,IFNULL(plous.`NEWNAME`,'')NEWNAME,plous.`Remarks` 
                            FROM patient_labinvestigation_opd_update_status plous
                            INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`");
                          //  INNER JOIN patient_labinvestigation_opd_update_status_master plousm ON plous.`Status`=plousm.`Status` AND plousm.`StatusType`='LabNo' and AllowAuditTrail=1 ");
            sb.AppendLine(" WHERE plous.`dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and plous.`dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and plous.CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and plous.UserID IN (" + UserID + ") ");
            }
            if (labno != "")
            {
                sb.AppendLine(" and plous.LedgerTransactionNo ='" + labno + "' ");
            }
            sb.AppendLine(" ORDER BY plous.`ID` Desc; ");//,plous.`LedgerTransactionNo`
            dt = StockReports.GetDataTable(sb.ToString());
        }
        else if (ReportType == "2")//Panel Summary
        {
            sb.AppendLine(@" SELECT plous.`LedgerTransactionNo` LabNo,(SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.CreatedByID) RegBy,
                             DATE_FORMAT(lt.`Date`,'%d-%b-%Y %H:%i %p') RegDate,plous.`Status`,plous.`UserName` StatusBy,DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') StatusDate,
                            IFNULL(plous.`OLDNAME`,'')OLDNAME,IFNULL(plous.`NEWNAME`,'')NEWNAME,plous.`Remarks` 
                            FROM patient_labinvestigation_opd_update_status plous
                            LEFT JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`
                            INNER JOIN patient_labinvestigation_opd_update_status_master plousm ON plous.`Status`=plousm.`Status` AND plousm.`StatusType`='PanelMaster' and AllowAuditTrail=1 ");
            sb.AppendLine(" WHERE plous.`dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and plous.`dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and plous.CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and plous.UserID IN (" + UserID + ") ");
            }
            sb.AppendLine(" ORDER BY plous.`LedgerTransactionNo`; ");
            dt = StockReports.GetDataTable(sb.ToString());
            //if (dtuser.Rows.Count > 0)
            //{
            //    dt = changedatatableMIS(dtuser);
            //}
            //if (dt.Rows.Count > 0)
            //{
            //    DataRow dr = dt.NewRow();
            //    for (int i = 1; i < dt.Columns.Count; i++)
            //    {
            //        dr[dt.Columns[i].ColumnName] = dt.Compute("sum([" + dt.Columns[i].ColumnName + "])", "");
            //    }
            //    dr["User"] = "Grand Total ::";
            //    dt.Rows.Add(dr);
            //}
            //dt = StockReports.GetDataTable(sb.ToString());
        }
        else if (ReportType == "3")//Investigation Summary
        {
            sb.AppendLine(@" SELECT plous.`LedgerTransactionNo` LabNo,(SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.CreatedByID) RegBy,
                             DATE_FORMAT(lt.`Date`,'%d-%b-%Y %H:%i %p') RegDate,plous.`Status`,plous.`UserName` StatusBy,DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') StatusDate,
                            IFNULL(plous.`OLDNAME`,'')OLDNAME,IFNULL(plous.`NEWNAME`,'')NEWNAME,plous.`Remarks` 
                            FROM patient_labinvestigation_opd_update_status plous
                            LEFT JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`
                            INNER JOIN patient_labinvestigation_opd_update_status_master plousm ON plous.`Status`=plousm.`Status` AND plousm.`StatusType`='InvestigationMaster' and AllowAuditTrail=1 ");
            sb.AppendLine(" WHERE plous.`dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and plous.`dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and plous.CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and plous.UserID IN (" + UserID + ") ");
            }
            sb.AppendLine(" ORDER BY plous.`LedgerTransactionNo`; ");
           // System.IO.File.AppendAllText(@"C:\\ITDose\\aumm.txt", sb.ToString()); 
            dt = StockReports.GetDataTable(sb.ToString());
            //if (dtuser.Rows.Count > 0)
            //{
            //    dt = changedatatableMIS(dtuser);
            //}
            //if (dt.Rows.Count > 0)
            //{
            //    DataRow dr = dt.NewRow();
            //    for (int i = 1; i < dt.Columns.Count; i++)
            //    {
            //        dr[dt.Columns[i].ColumnName] = dt.Compute("sum([" + dt.Columns[i].ColumnName + "])", "");
            //    }
            //    dr["User"] = "Grand Total ::";
            //    dt.Rows.Add(dr);
            //}
            //dt = StockReports.GetDataTable(sb.ToString());
        }
        else if (ReportType == "4")//Observation Summary
        {
            sb.AppendLine(@" SELECT plous.`LedgerTransactionNo` LabNo,(SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.CreatedByID) RegBy,
                             DATE_FORMAT(lt.`Date`,'%d-%b-%Y %H:%i %p') RegDate,plous.`Status`,plous.`UserName` StatusBy,DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') StatusDate,
                            IFNULL(plous.`OLDNAME`,'')OLDNAME,IFNULL(plous.`NEWNAME`,'')NEWNAME,plous.`Remarks` 
                            FROM patient_labinvestigation_opd_update_status plous
                            LEFT JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`
                            INNER JOIN patient_labinvestigation_opd_update_status_master plousm ON plous.`Status`=plousm.`Status` AND plousm.`StatusType`='Observation Changes' and AllowAuditTrail=1 ");
            sb.AppendLine(" WHERE plous.`dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and plous.`dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and plous.CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and plous.UserID IN (" + UserID + ") ");
            }
            sb.AppendLine(" ORDER BY plous.`dtEntry` Desc; ");
            dt = StockReports.GetDataTable(sb.ToString());
          
        }
        else if (ReportType == "5")//Employee Summary
        {
            sb.AppendLine(@" SELECT plous.`LedgerTransactionNo` LabNo,(SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.CreatedByID) RegBy,
                             DATE_FORMAT(lt.`Date`,'%d-%b-%Y %H:%i %p') RegDate,plous.`Status`,plous.`UserName` StatusBy,DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') StatusDate,
                            IFNULL(plous.`OLDNAME`,'')OLDNAME,IFNULL(plous.`NEWNAME`,'')NEWNAME,plous.`Remarks` 
                            FROM patient_labinvestigation_opd_update_status plous
                            LEFT JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`   ");


            sb.AppendLine(" WHERE plous.`dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and plous.`dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59'  AND plous.Status='Employee Update' ");
          //  if (CentreID != "")
          //  {
          //      sb.AppendLine(" and plous.CentreID IN (" + CentreID + ") ");
         //   }
            // if (UserID != "")
            // {
                // sb.AppendLine(" and plous.UserID IN (" + UserID + ") ");
            // }
             sb.AppendLine(" ORDER BY plous.`dtEntry` Desc; ");
            dt = StockReports.GetDataTable(sb.ToString());
        }

        else if (ReportType == "6")//Item wise  Summary
        {
            sb.AppendLine(@" SELECT Panel_ID,ItemID,Company_Name,ItemName,OLDRate,NewRate,OLDRate_CreatedBy,DATE_FORMAT(`OLDRate_dtEntry`,'%d-%b-%Y %H:%i %p') OLDRate_dtEntry,NewRate_CreatedByID,NewRate_CreatedBy,DATE_FORMAT(`NewRate_dtEntry`,'%d-%b-%Y %H:%i %p')NewRate_dtEntry      
             FROM f_ratelist_log   ");
            sb.AppendLine(" WHERE `NewRate_dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and `NewRate_dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' and STATUS='ItemsWiserate Update' ");
            //if (CentreID != "")
            //{
            //    sb.AppendLine(" and CentreID IN (" + CentreID + ") ");
            //}
            //if (UserID != "")
            //{
            //    sb.AppendLine(" and UserID IN (" + UserID + ") ");
            //}
           
            dt = StockReports.GetDataTable(sb.ToString());

        }

        else if (ReportType == "7")//Client wise  Summary
        {
//            sb.AppendLine(@" SELECT `LedgerTransactionNo` LabNo, `Status`,`UserName` StatusBy,DATE_FORMAT(`dtEntry`,'%d-%b-%Y %r') StatusDate,
//IFNULL(`OLDNAME`,'')OLDNAME,IFNULL(`NEWNAME`,'')NEWNAME,`Remarks`       FROM patient_labinvestigation_opd_update_status   ");

            sb.Append(" SELECT Panel_ID,ItemID,  ItemName,DATE_FORMAT(`OLDRate_dtEntry`,'%d-%b-%Y %H:%i %p') OLDRate_dtEntry,NewRate_CreatedByID,NewRate_CreatedBy,DATE_FORMAT(`NewRate_dtEntry`,'%d-%b-%Y %H:%i %p')NewRate_dtEntry,DATE_FORMAT(`FromDate`,'%d-%b-%Y')FromDate,DATE_FORMAT(`ToDate`,'%d-%b-%Y')ToDate,TestCode,OldName,NewName,Remarks ,STATUS  FROM f_ratelist_log   ");

            sb.AppendLine(" WHERE `NewRate_dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and `NewRate_dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' and STATUS='ClientItems Update'  ");
            //if (CentreID != "")
            //{
            //    sb.AppendLine(" and CentreID IN (" + CentreID + ") ");
            //}
            //if (UserID != "")
            //{
            //    sb.AppendLine(" and UserID IN (" + UserID + ") ");
            //}

            dt = StockReports.GetDataTable(sb.ToString());

        }
        else if (ReportType == "8")//ShedulRateList wise  Summary
        {
            sb.AppendLine(@" SELECT `LedgerTransactionNo` LabNo, `Status`,`UserName` StatusBy,DATE_FORMAT(`dtEntry`,'%d-%b-%Y %r') StatusDate,
IFNULL(`OLDNAME`,'')OLDNAME,IFNULL(`NEWNAME`,'')NEWNAME,`Remarks`       FROM patient_labinvestigation_opd_update_status plius  ");
            sb.AppendLine(" WHERE `dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and `dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' and `StatusID`='11' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and UserID IN (" + UserID + ") ");
            }

            dt = StockReports.GetDataTable(sb.ToString());

        }

        else if (ReportType == "9")//TransferRate Update   Summary
        {
            sb.AppendLine(@" SELECT `LedgerTransactionNo` LabNo, `Status`,`UserName` StatusBy,DATE_FORMAT(`dtEntry`,'%d-%b-%Y %r') StatusDate,
IFNULL(`OLDNAME`,'')OLDNAME,IFNULL(`NEWNAME`,'')NEWNAME,`Remarks`       FROM patient_labinvestigation_opd_update_status   ");
            sb.AppendLine(" WHERE `dtEntry`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' and `dtEntry`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' and `Status`='TransferRate Update' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and UserID IN (" + UserID + ") ");
            }

            dt = StockReports.GetDataTable(sb.ToString());

        }
        else if (ReportType == "10")//TATMaster  
        {
            sb.AppendLine(@"  SELECT STATUS,idl.CentreID,cm.centre,labstarttime,labendtime,Processtype,(SELECT typename FROM f_itemmaster im WHERE im.type_id=Investigation_ID)Testname,SR_To_DR,SR_To_ST,ST_To_SLR,SLR_To_DR,idl.SubcategoryID,Investigation_ID,im.`TypeName` AS InvName,ifnull(TATType,'Days')TATType,woringhours,nonworinghours,stathours,MorningHours,EveningHours,DayType,Days,Sun,Mon,Tue,Wed,Thu,Fri,Sat,CutOffTime,
 samedaydeliverytime,nextdaydeliverytime,Approval_To_Dispatch,DATE_FORMAT(idl.updatedate, '%d-%b-%Y %h:%i %p') UpdateDate,UserID,UserName,IpAddress 
  FROM investiagtion_delivery_log idl
  INNER JOIN centre_master cm ON cm.`CentreID`=idl.`CentreID`
  INNER JOIN f_itemmaster im ON im.`Type_ID`=idl.`Investigation_ID` ");
            sb.Append("where idl.Updatedate>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00'  and  idl.Updatedate<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ORDER BY STATUS ");
            if (CentreID != "")
            {
                sb.AppendLine(" and idl.CentreID IN (" + CentreID + ") ");
            }
            //if (UserID != "")
            //{
            //    sb.AppendLine(" and UserID IN (" + UserID + ") ");
            //}

            dt = StockReports.GetDataTable(sb.ToString());

        }
        
        //return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return JsonConvert.SerializeObject(new { status = true, response = dt });
       // return makejsonoftable(dt, makejson.e_without_square_brackets);

    }
    public static DataTable changedatatableMIS(DataTable dt)
    {
        DataTable dtnew = new DataTable();
        DataView view = new DataView(dt);
        view.Sort = "RegBy asc";
        DataTable distinctuserValues = view.ToTable(true, "RegBy");
        DataView view1 = new DataView(dt);
        DataTable distinctstatusValues = view1.ToTable(true, "Status");
        dtnew.Columns.Add("User");
        foreach (DataRow dw in distinctstatusValues.Rows)
        {
            dtnew.Columns.Add(dw["Status"].ToString());
            dtnew.Columns[dw["Status"].ToString()].DataType = typeof(int);
        }
        
        foreach (DataRow du in distinctuserValues.Rows)
        {
            DataRow rr = dtnew.NewRow();
            foreach (DataColumn dc1 in dtnew.Columns)
            {
                string nn = dc1.ToString();
                if (dc1.ToString() == "User")
                {
                    rr[dc1] = du["RegBy"].ToString();
                }
                else
                {
                    rr[dc1] = 0; 
                }
            }
            dtnew.Rows.Add(rr);
        }
        for (int k = 1; k < dtnew.Columns.Count; k++)
        {
            for (int i = 0; i < dtnew.Rows.Count; i++)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if ((dt.Rows[j]["Status"].ToString()) == dtnew.Columns[k].ToString())
                    {
                        if (dtnew.Rows[i]["User"].ToString() == dt.Rows[j]["RegBy"].ToString())
                        {
                            dtnew.Rows[i][dtnew.Columns[k].ToString()] = dt.Rows[j]["StatusCount"].ToString();
                        }

                    }

                }
            }
        }
        dtnew.AcceptChanges();
        return dtnew;
    }
    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }

    protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
    {
        string CentreID = ""; //GetSelection(lstCentre);
        string UserID = "";
        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
        if (ddlReportType.SelectedItem.Value.ToString() == "1")
        {
            sb.AppendLine(@" SELECT plous.`LedgerTransactionNo` LabNo,(SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.CreatedByID) RegBy,
                             DATE_FORMAT(lt.`Date`,'%d-%b-%Y %H:%i %p') RegDate,plous.`Status`,plous.`UserName` StatusBy,DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') StatusDate,
                            IFNULL(plous.`OLDNAME`,'')OLDNAME,IFNULL(plous.`NEWNAME`,'')NEWNAME,plous.`Remarks` 
                            FROM patient_labinvestigation_opd_update_status plous
                            left JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`");
                           // INNER JOIN patient_labinvestigation_opd_update_status_master plousm ON plous.`Status`=plousm.`Status` AND plousm.`StatusType`='LabNo' and AllowAuditTrail=1 ");
            sb.AppendLine(" WHERE plous.`dtEntry`>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and plous.`dtEntry`<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and plous.CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and plous.UserID IN (" + UserID + ") ");
            }
            if (txtLab.Text != "")
            {
                sb.AppendLine(" and plous.LedgerTransactionNo ='" + txtLab.Text.Trim() + "' ");
            }
            sb.AppendLine(" ORDER BY plous.`LedgerTransactionNo`; ");
            dt = StockReports.GetDataTable(sb.ToString());
        }
        else if (ddlReportType.SelectedItem.Value.ToString() == "2")
        {
            sb.AppendLine(@" SELECT em.Name RegBy,plous.`Status`,Count(plous.`Status`) StatusCount
                            FROM patient_labinvestigation_opd_update_status plous
                            left JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`
                            INNER JOIN `Employee_master` em ON em.`Employee_ID`=lt.`CreatedByID`
                            INNER JOIN patient_labinvestigation_opd_update_status_master plousm ON plous.`Status`=plousm.`Status` AND plousm.`StatusType`='LabNo' and AllowAuditTrail=1 ");
            sb.AppendLine(" WHERE plous.`dtEntry`>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and plous.`dtEntry`<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and plous.CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and plous.UserID IN (" + UserID + ") ");
            }
            sb.AppendLine(" Group by lt.CreatedByID,plous.`Status` ORDER BY em.Name; ");
            DataTable dtuser = StockReports.GetDataTable(sb.ToString());
            if (dtuser.Rows.Count > 0)
            {
                dt = changedatatableMIS(dtuser);
            }
            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.NewRow();
                for (int i = 1; i < dt.Columns.Count; i++)
                {
                    dr[dt.Columns[i].ColumnName] = dt.Compute("sum([" + dt.Columns[i].ColumnName + "])", "");
                }
                dr["User"] = "Grand Total ::";
                dt.Rows.Add(dr);
            }
            //dt = StockReports.GetDataTable(sb.ToString());
        }
        else if (ddlReportType.SelectedItem.Value.ToString() == "3")
        {
            sb.AppendLine(@" SELECT em.Name RegBy,plous.`Status`,Count(plous.`Status`) StatusCount
                            FROM patient_labinvestigation_opd_update_status plous
                            left JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`
                            INNER JOIN `Employee_master` em ON em.`Employee_ID`=lt.`UpdateID`
                            INNER JOIN patient_labinvestigation_opd_update_status_master plousm ON plous.`Status`=plousm.`Status` AND plousm.`StatusType`='LabNo' and AllowAuditTrail=1 ");
            sb.AppendLine(" WHERE plous.`dtEntry`>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and plous.`dtEntry`<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (CentreID != "")
            {
                sb.AppendLine(" and plous.CentreID IN (" + CentreID + ") ");
            }
            if (UserID != "")
            {
                sb.AppendLine(" and plous.UserID IN (" + UserID + ") ");
            }
            sb.AppendLine(" Group by lt.UpdateID,plous.`Status` ORDER BY em.Name; ");
            DataTable dtuser = StockReports.GetDataTable(sb.ToString());
            if (dtuser.Rows.Count > 0)
            {
                dt = changedatatableMIS(dtuser);
            }
            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.NewRow();
                for (int i = 1; i < dt.Columns.Count; i++)
                {
                    dr[dt.Columns[i].ColumnName] = dt.Compute("sum([" + dt.Columns[i].ColumnName + "])", "");
                }
                dr["User"] = "Grand Total ::";
                dt.Rows.Add(dr);
            }
          
        }
        Session["ReportName"] = "Audit Trail Report";
        Session["dtExport2Excel"] = dt;
        Session["Period"] = " From : " + dtFrom.Text + " To : " + dtTo.Text;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../Common/ExportToExcel.aspx');", true);
    }
    private string GetSelection(ListBox cbl)
    {
        string str = "";

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
}