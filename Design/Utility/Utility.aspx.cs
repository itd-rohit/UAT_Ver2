using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_Utility : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

    }
    [WebMethod(EnableSession = true)]
    public static string GetAmount(string FromDate, string ToDate, string SearchType, string FromLabNo, string ToLabNo, string CentreID, string PanelID, string LabNo)
    {
        try
        {
            int checkSession = UserInfo.ID;
        }
        catch
        {
            return "-1";
        }
        string PanelIDTarget = "3625"; //"78";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            //  System.IO.File.WriteAllText("E:\\LedgerTransaction1.txt", sb.ToString());

            string PanelIDSource = "261";//78
            CentreID = "1,44";

            sb.AppendLine(" DELETE FROM Utility_total_display; ");
            sb.AppendLine(" INSERT INTO Utility_total_display(LedgerTransactionID,Diff,OldAmount,NewRate) ");
            sb.AppendLine(" SELECT lt.LedgerTransactionID,Sum(plo.Amount)-sum(ifnull(r.Rate,0)) Diff,Sum(plo.Amount)OldAmount,sum(ifnull(r.Rate,0)) NewRate ");
            sb.AppendLine(" FROM f_ledgertransaction lt ");
            sb.AppendLine(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID ");
            if (CentreID != "")
            {
                sb.AppendLine(" AND lt.CentreID in (" + CentreID + ")");
            }
            if (PanelID != "")
            {
                sb.AppendLine(" AND lt.Panel_ID=" + PanelIDSource + " ");
            }
            sb.AppendLine(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID ");
            sb.AppendLine(" LEFT JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID='" + PanelIDTarget + "' ");
            sb.AppendLine(" WHERE lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.AppendLine(" and lt.date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' and lt.InvoiceNo=''");
            if (LabNo != "")
                sb.AppendLine("  and lt.LedgerTransactionNo='" + LabNo + "' ");
            sb.AppendLine(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) AND (Round(lt.NetAmount)-Round(lt.`Adjustment`))=0  and lt.NetAmount>0 ");
            sb.AppendLine(" GROUP BY lt.LedgerTransactionID; ");
            StockReports.ExecuteDML(sb.ToString());


            sb = new StringBuilder();
            sb.AppendLine(" DELETE t.* FROM Utility_total_display t INNER JOIN `f_receipt` r ON r.`LedgerTransactionID`=t.`LedgerTransactionID` WHERE r.`PaymentModeID`>1; ");
            //   System.IO.File.WriteAllText("E:\\LedgerTransaction1.txt", sb.ToString());
            StockReports.ExecuteDML(sb.ToString());

            sb = new StringBuilder();
            sb.AppendLine(" select SUM(Diff) Diff,SUM(OldAmount) OldAmount,SUM(NewRate) NewRate from Utility_total_display; ");
            // System.IO.File.WriteAllText("E:\\LedgerTransaction2.txt", sb.ToString());
            return Util.getJson(StockReports.GetDataTable(sb.ToString()));


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.GeneralLog("BulkChangePanel : " + ex.GetBaseException().ToString());
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string PatientSearch(string FromDate, string ToDate, string SearchType, string FromLabNo, string ToLabNo, string CentreID, string PanelID)
    {
        try
        {
            int checkSession = UserInfo.ID;
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string PanelIDSource = "261";//78
            CentreID = "1,44";
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.AppendLine(" SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y') RegDate, ");
            sbQuery.AppendLine(" CONCAT(pm.Title,' ',pm.PName) PName,CONCAT(pm.Age,' ',LEFT(pm.Gender,1)) AgeGender,");
            sbQuery.AppendLine(" lt.LedgerTransactionNo LabNo,");
            sbQuery.AppendLine(" ROUND(lt.GrossAmount,2) GrossAmt,ROUND(lt.DiscountOnTotal,2) DiscAmt,ROUND(lt.NetAmount,2) NetAmt,ROUND(lt.Adjustment,2) RecAmt,");
            sbQuery.AppendLine(" ROUND(lt.NetAmount-lt.Adjustment,2) BalAmt,");
            sbQuery.AppendLine(" cm.Centre CentreName,");
            sbQuery.AppendLine(" lt.PanelName,lt.Panel_ID PanelID, lt.`Adjustment` ");
            sbQuery.AppendLine(" FROM f_ledgertransaction lt");
            sbQuery.AppendLine("  INNER JOIN  f_receipt r  ON lt.LedgerTransactionID=r.LedgerTransactionID  ");

            if (CentreID != "")
            {
                sbQuery.AppendLine(" AND lt.CentreID in (" + CentreID + ")");
            }
            if (PanelID != "")
            {
                sbQuery.AppendLine(" AND lt.Panel_ID=" + PanelIDSource + " ");
            }
            sbQuery.AppendLine(" INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID");
            sbQuery.AppendLine(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID");
            sbQuery.AppendLine(" WHERE  lt.Date>=@fromdate and lt.date<=@todate and lt.InvoiceNo=''");
            sbQuery.AppendLine(" AND (Round(lt.NetAmount)-Round(lt.`Adjustment`))=0 and lt.NetAmount>0 ");
            sbQuery.AppendLine(" GROUP BY lt.LedgerTransactionNo having sum(if(r.PaymentModeID=1,r.Amount,0)) = Round(lt.`Adjustment`) ");
            sbQuery.AppendLine(" ORDER BY lt.Date");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                 new MySqlParameter("@fromdate", Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                 new MySqlParameter("@todate", Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0])
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            return "[]";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
   [WebMethod(EnableSession = true)]
    public static string SearchItemDetail(string LabNo, string PanelID)
    {
        try
        {
            int checkSession = UserInfo.ID;
        }
        catch
        {
            return "-1";
        }
        string PanelIDTarget = "3625"; //"78";
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine(" SELECT lt.LedgerTransactionNo,plo.ItemName,plo.Amount, ");
            sb.AppendLine(" plo.Rate,ifnull(r.Rate,0) NewRate,plo.DiscountAmt DiscountPercentage,plo.Quantity ");
            sb.AppendLine(" FROM f_ledgertransaction lt ");
            sb.AppendLine(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID ");
            sb.AppendLine(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID ");
            sb.AppendLine(" LEFT JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID='" + PanelIDTarget + "' ");
            sb.AppendLine(" WHERE lt.LedgerTransactionNo='" + LabNo + "' ");
            sb.AppendLine(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) AND (Round(lt.NetAmount)-Round(lt.`Adjustment`))=0 and lt.NetAmount>0; ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            string rtrn = Util.getJson(dt);
            return rtrn;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.GeneralLog("BulkChangePanel : " + ex.GetBaseException().ToString());
            return "0";
        }

    }
     [WebMethod(EnableSession = true)]
    public static string SaveNewPanelRatesUtility(string FromDate, string ToDate, string CentreID, string SourcePanelID, string TargetPanelID, string Selectedpatient)
    {
        try
        {
            int checkSession = UserInfo.ID;
        }
        catch
        {
            return "-1";
        }
        Selectedpatient = Selectedpatient.TrimEnd(',');
        Selectedpatient = Selectedpatient.Replace(",", "','");
        if (Selectedpatient == "")
        {
            return "-2";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            CentreID = "1,44"; //1,2
            string PanelIDTarget = "3625";
            string PanelNameTarget = "INTERNATIONAL II";
           

            StringBuilder sbCheck = new StringBuilder();
            sbCheck.AppendLine(" DELETE FROM  _ratelist_int;  ");
            sbCheck.AppendLine(" INSERT INTO _ratelist_int(Itemid,Panel_ID,Rate)  ");
            sbCheck.AppendLine(" SELECT  im.Itemid,3625 Panel_ID ,MIN(plo.`Rate`) Rate");
            sbCheck.AppendLine(" FROM  f_ledgertransaction lt ");
            sbCheck.AppendLine(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID  ");
            sbCheck.AppendLine(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) AND (Round(lt.NetAmount)-Round(lt.`Adjustment`))=0 and lt.NetAmount>0 ");
            sbCheck.AppendLine(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemID ");
            sbCheck.AppendLine(" WHERE lt.LedgerTransactionNo in ('" + Selectedpatient + "') Group by plo.itemid; ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_1.txt", sbCheck.ToString());
            StockReports.ExecuteDML(sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" DELETE FROM f_ratelist where panel_id=" + PanelIDTarget + " and Rate=0; ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_2.txt", sbCheck.ToString());
            StockReports.ExecuteDML(sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" DELETE t.* FROM  _ratelist_int t inner join f_ratelist r on r.itemid=t.itemid  and r.Panel_ID=" + PanelIDTarget + "; ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_3.txt", sbCheck.ToString());
            StockReports.ExecuteDML(sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" INSERT INTO f_ratelist(ItemID,Panel_ID,Rate) ");
            sbCheck.AppendLine(" SELECT ItemId,Panel_ID,Rate from _ratelist_int r  ;  ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_4.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());

            /* Backup - Start */
            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" INSERT INTO mdrc_utility.f_receipt ");
            sbCheck.AppendLine(" SELECT * FROM f_receipt r WHERE r.ledgertransactionno IN ('" + Selectedpatient + "');  ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_5.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" INSERT INTO mdrc_utility.`f_ledgertransaction` ");
            sbCheck.AppendLine(" SELECT * FROM `f_ledgertransaction` lt WHERE lt.ledgertransactionno IN ('" + Selectedpatient + "'); ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_6.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" INSERT INTO mdrc_utility.`patient_labinvestigation_opd` ");
            sbCheck.AppendLine(" SELECT * FROM `patient_labinvestigation_opd` plo WHERE plo.ledgertransactionno IN ('" + Selectedpatient + "'); ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_7.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" DELETE FROM `patient_labinvestigation_opd_share`  WHERE ledgertransactionno IN ('" + Selectedpatient + "'); ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_8.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" UPDATE f_ledgertransaction lt ");
            sbCheck.AppendLine(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID ");
            sbCheck.AppendLine(" AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) AND (Round(lt.NetAmount)-Round(lt.`Adjustment`))=0 and lt.NetAmount>0 ");
            sbCheck.AppendLine(" inner JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID='" + PanelIDTarget + "' ");
            sbCheck.AppendLine(" SET lt.IsReturnable=1,lt.Panel_ID=" + PanelIDTarget + ",PanelName='" + PanelNameTarget + "', ");
            sbCheck.AppendLine(" plo.Amount = IFNULL((r.Rate*plo.Quantity ),0),");
            sbCheck.AppendLine(" plo.Rate=IFNULL(r.Rate,0),plo.DiscountAmt='0',lt.DiscountOnTotal='0' ");
            sbCheck.AppendLine(" WHERE lt.LedgerTransactionNo in ('" + Selectedpatient + "') ; ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_9.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" UPDATE f_receipt r  ");
            sbCheck.AppendLine(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionid=r.LedgerTransactionid  AND (Round(lt.NetAmount)-Round(lt.`Adjustment`))=0 and lt.NetAmount>0  ");
            sbCheck.AppendLine(" SET r.IsCancel=1,r.CancelReason='New Utility',r.CancelDate=NOW(),r.Cancel_UserID='" + HttpContext.Current.Session["ID"].ToString() + "', ");
            sbCheck.AppendLine(" r.Updatedate=NOW(),r.UpdateID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
            sbCheck.AppendLine(" WHERE IFNULL(lt.InvoiceNo,'')='' and r.LedgerNoCr!='OPD003'  ");
            sbCheck.AppendLine(" and lt.LedgerTransactionNo in ('" + Selectedpatient + "') ; ");
            System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_10.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" UPDATE f_ledgertransaction lt ");
            sbCheck.AppendLine(" SET lt.NetAmount=(SELECT SUM(Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionID=plo.LedgerTransactionID and IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) GROUP BY plo.LedgerTransactionID ),");
            sbCheck.AppendLine(" lt.GrossAmount=(SELECT SUM(Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionID=plo.LedgerTransactionID and IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  GROUP BY plo.LedgerTransactionID ),");
            sbCheck.AppendLine(" lt.Adjustment=(SELECT SUM(Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionID=plo.LedgerTransactionID and IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)  GROUP BY plo.LedgerTransactionID )");
            sbCheck.AppendLine(" WHERE  lt.LedgerTransactionNo in ('" + Selectedpatient + "') ; ");
            // System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_11.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());

            sbCheck = new StringBuilder();
            sbCheck.AppendLine(" UPDATE f_receipt r  ");
            sbCheck.AppendLine(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=r.LedgerTransactionID ");
            sbCheck.AppendLine(" SET r.Amount=lt.Adjustment,r.S_Amount=lt.Adjustment,r.Panel_ID=" + PanelIDTarget + ", ");
            sbCheck.AppendLine(" r.Updatedate=NOW(),r.UpdateID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
            sbCheck.AppendLine(" WHERE IFNULL(lt.InvoiceNo,'')='' and r.LedgerNoCr='OPD003'  ");
            sbCheck.AppendLine(" and lt.LedgerTransactionNo in ('" + Selectedpatient + "') ; ");
            // System.IO.File.WriteAllText("C:\\Int_LedgerTransaction_12.txt", sbCheck.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbCheck.ToString());
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Rollback();
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}