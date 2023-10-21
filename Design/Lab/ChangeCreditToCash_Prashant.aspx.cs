using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ChangeCreditToCash_Prashant : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Response.Write("Page Start");
            UpdatePaymentMode("", 0, 0, 0, 0, 0);
        }
    }
    public string UpdatePaymentMode(string LabNo, int OldPanel, int NewPanel, int RefferanceCode, int type, int PanelID_MRP)
    {

      //  Response.Write("\nProcess Start");
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            DataTable dtBulk=MySqlHelper.ExecuteDataset(tranX,CommandType.Text,@"SELECT LedgerTransactionNO LabNo,t.`panel_id` OldPanel,t.`panel_id` NewPanel,fpm.`ReferenceCode` RefferanceCode,IF(fpm.`PanelID_MRP`=0,78,fpm.`PanelID_MRP`) PanelID_MRP FROM `_pk` t
                                    INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=t.`panel_id`;").Tables[0];
            if (dtBulk.Rows.Count > 0)
            {
                for (int i = 0; i <= dtBulk.Rows.Count; i++)
                {
                    LabNo = dtBulk.Rows[i]["LabNo"].ToString();
                    OldPanel = Util.GetInt(dtBulk.Rows[i]["OldPanel"]);
                    NewPanel =Util.GetInt(dtBulk.Rows[i]["NewPanel"]);
                    RefferanceCode = Util.GetInt(dtBulk.Rows[i]["RefferanceCode"]);
                    type =  1;
                    PanelID_MRP = Util.GetInt(dtBulk.Rows[i]["PanelID_MRP"]);
                    int IsCredit = 0;
                    if (type == 1)
                    {
                        IsCredit = 1;
                        int IsActiveReceipt = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "  SELECT Count(1) FROM f_receipt WHERE LedgerTransactionNo='" + LabNo + "' AND iScancel=0 AND Amount>0 "));
                        if (IsActiveReceipt > 0)
                        {
                            return "2";
                        }
                    }
                    Response.Write("\n LedgerTransaction_" + LabNo + "_Start");
                   // System.IO.File.WriteAllText("E:\\Prashant\\LedgerTransaction_" + LabNo + "_Start.txt", LabNo);
                    DataTable dtOLD = MySqlHelper.ExecuteDataset(tranX,CommandType.Text,"SELECT lt.LedgerTransactionID, lt.CentreID,lt.Panel_ID,lt.NetAmount,lt.Adjustment,if(lt.IsCredit=1,lt.NetAmount,0) AmtCredit,fpm.`Company_Name`,cm.`Centre`  FROM f_ledgertransaction lt INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` WHERE lt.LedgerTransactionNo='" + LabNo + "';").Tables[0];
                    double DisPer = Util.GetDouble(StockReports.ExecuteScalar(" Select round(( DiscountOnTotal/GrossAmount * 100 ),2) from f_ledgertransaction where LedgerTransactionNo= '" + LabNo + "'; "));
                    StringBuilder sb = new StringBuilder();

                    sb.Append(@" UPDATE f_ledgertransaction lt  
                         INNER JOIN patient_labInvestigation_opd ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND IF(ltd.isPackage=1,ltd.`SubCategoryID`=15,ltd.`SubCategoryID`!=15)  
                         INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID 
                         INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID=" + NewPanel + @" 
                         SET lt.Panel_ID=pm2.Panel_ID,
                         ltd.Amount = (substring_index(get_item_rate(ltd.ItemID," + RefferanceCode + ",NOW()," + NewPanel + @"),'#',1) 
                        * (100-" + DisPer + @")*0.01),
                         ltd.Rate=(substring_index(get_item_rate(ltd.ItemID," + RefferanceCode + ",NOW()," + NewPanel + @"),'#',1)),");
                    if (PanelID_MRP != 0)
                        sb.Append("  ltd.MRP=(substring_index(get_item_rate(ltd.ItemID," + PanelID_MRP + ",NOW()," + NewPanel + @"),'#',1)),");
                    else
                        sb.Append("  ltd.MRP= (substring_index(get_item_rate(ltd.ItemID," + RefferanceCode + ",NOW()," + NewPanel + @"),'#',1)),");
                    sb.Append(@"         ltd.paybypatient=(substring_index(get_item_rate(ltd.ItemID," + RefferanceCode + ",NOW()," + NewPanel + @"),'#',1) 
                        * (100-" + DisPer + @")*0.01),
                         ltd.DisCountAmt=(ltd.Rate-ltd.Amount)
                         WHERE lt.LedgerTransactionNo='" + LabNo + "';  ");

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
                    sb = new StringBuilder();
                    sb.Append(@" UPDATE f_ledgertransaction lt 
                         SET lt.NetAmount=(SELECT SUM(ltd.Amount) FROM patient_labInvestigation_opd ltd WHERE LedgerTransactionNo='" + LabNo + @"'), 
                         lt.DisCountOnTotal=(SELECT SUM(ltd.DiscountAmt) FROM patient_labInvestigation_opd ltd WHERE LedgerTransactionNo='" + LabNo + @"'), 
                         lt.isCredit=" + IsCredit + @",
                         lt.GrossAmount=(SELECT SUM(ltd.Rate*ltd.Quantity) FROM patient_labInvestigation_opd ltd WHERE LedgerTransactionNo='" + LabNo + @"')  WHERE lt.LedgerTransactionNo='" + LabNo + "' ");

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());


                    string str_LTD_2 = "SELECT lt.CentreID,lt.Panel_ID,lt.NetAmount,lt.Adjustment,if(lt.IsCredit=1,lt.NetAmount,0) AmtCredit,fpm.`Company_Name`,cm.`Centre`  FROM f_ledgertransaction lt INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` WHERE lt.LedgerTransactionNo='" + LabNo + "';";

                    DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(tranX, CommandType.Text, str_LTD_2).Tables[0];

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,`Status`, ");
                    sb.Append(" UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID,Remarks) ");
                    sb.Append(" VALUES('" + LabNo + "','Change Panel','" + HttpContext.Current.Session["ID"].ToString() + "', ");
                    sb.Append(" '" + HttpContext.Current.Session["LoginName"].ToString() + "',NOW(), ");
                    sb.Append(" '" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
                    sb.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',");
                    sb.Append(" '" + dtOLD.Rows[0]["Panel_ID"].ToString() + "','" + dt_LTD_2.Rows[0]["Panel_ID"].ToString() + "',");
                    sb.Append(" 'OLD Net Amount : " + Util.GetString(dtOLD.Rows[0]["NetAmount"]) + ", New Net Amount : " + Util.GetString(dt_LTD_2.Rows[0]["NetAmount"]) + "' ); ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());

                    Panel_Share ps = new Panel_Share();
                    JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(Util.GetInt(dtOLD.Rows[0]["LedgerTransactionID"].ToString()), tranX, con));
                    if (IPS.status == false)
                    {
                        tranX.Rollback();
                        return "0";
                    }
                    Response.Write("/nLedgerTransaction_" + LabNo + "_End");
                   // System.IO.File.WriteAllText("E:\\Prashant\\LedgerTransaction_" + LabNo + "_Done.txt", LabNo);
                }
            }
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            tranX.Rollback();
            return "-1";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }


}