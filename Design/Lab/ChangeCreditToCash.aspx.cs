using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ChangeCreditToCash : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod(EnableSession = true)]
    public static string Getrecieptdata(string search)
    {

        MySqlConnection con = Util.GetMySqlCon();
        string Roleid = Util.GetString(UserInfo.RoleID); string permissiontype = "ChangePanel"; string Labno = search;
        string rresult = Util.RolePermission(Roleid, permissiontype, Labno);

        if (rresult == "true")
        {
            // return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
            return "-3";
        }
        try
        {
            string Command = "select lt.LedgerTransactionID,lt.IsCredit ,lt.LedgerTransactionNo,DATE_FORMAT(lt.Date ,'%d-%b-%Y %h:%i %p') `Date`,lt.PName,lt.Patient_ID,lt.Age,lt.Gender,lt.Panel_ID,concat(pm.panel_code,' - ',pm.Company_Name)Company_Name ,TIMESTAMPDIFF(MINUTE,lt.DATE,NOW()) BillTimeDiff from f_ledgertransaction lt inner join f_panel_master pm on pm.Panel_ID=lt.Panel_ID  Where LedgerTransactionNo=@LedgerTransactionNo";
            con.Open();
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, Command, new MySqlParameter("@LedgerTransactionNo", search), new MySqlParameter("@Patient_ID", search)).Tables[0];

            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsCredit"].ToString() == "0")
                {
                    int IsActiveReceipt = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "  SELECT Count(1) FROM f_receipt WHERE LedgerTransactionNo='" + search + "' AND iScancel=0 AND Amount>0 "));
                    if (IsActiveReceipt > 0)
                    {
                        return "2";
                    }
                }
                //DataTable dt2 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select plo.ItemId,plo.ItemName,f_ratelist.Rate from patient_labinvestigation_opd  plo inner Join f_ratelist on f_ratelist.ItemID=plo.ItemId and f_ratelist.Panel_ID=@Panel_ID Where plo.LedgerTransactionID=@LedgerTransactionID",
                //    new MySqlParameter("@LedgerTransactionID", dt.Rows[0]["LedgerTransactionID"].ToString()),
                //    new MySqlParameter("@Panel_ID", dt.Rows[0]["Panel_ID"].ToString())).Tables[0];

                //DataTable dt2 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select plo.ItemId,plo.ItemName,f_ratelist.Rate from patient_labinvestigation_opd  plo inner Join f_ratelist on f_ratelist.ItemID=plo.ItemId  Where plo.LedgerTransactionno='"+search+"'").Tables[0];
                DataTable dt2 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select plo.ItemId,plo.ItemName,plo.Rate,IF(plo.IsActive=1,'Active','De-Active')IsActive from patient_labinvestigation_opd  plo INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  where lt.Panel_ID=@Panel_ID and plo.LedgerTransactionID=@LedgerTransactionID ",
                    new MySqlParameter("@LedgerTransactionID", dt.Rows[0]["LedgerTransactionID"].ToString()),
                    new MySqlParameter("@Panel_ID", dt.Rows[0]["Panel_ID"].ToString())).Tables[0];
                if (dt2.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new { Details = dt, Tests = dt2 });
                }
            }
            return "1";
        }
        catch (Exception e)
        {
            con.Dispose();
            con.Close();
            return "-1";
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetPanelList()
    {
        try
        {

            string Command = "select concat(Panel_ID,'#',ReferenceCode,'#',if(Payment_Mode='Cash',0,1),'#',PanelID_MRP) Panel_ID,concat(Panel_Code,' - ',Company_Name)Company_Name from f_panel_master where IsActive=1 and Company_name <>'' Order By Panel_ID+0 ";
            DataTable dt = StockReports.GetDataTable(Command);
            if (dt.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(dt);
            }

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "-1";
        }
    }


    [WebMethod(EnableSession = true)]
    public static string UpdatePaymentMode(string LabNo, int OldPanel, int NewPanel, int RefferanceCode, int type, int PanelID_MRP)
    {
        if (OldPanel == NewPanel)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Old Panel and New Panel Can't be Same" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int IsCredit = 0;
            if (type == 1)
            {
                IsCredit = 1;
                int IsActiveReceipt = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "  SELECT Count(1) FROM f_receipt WHERE LedgerTransactionNo='" + LabNo + "' AND iScancel=0 AND Amount>0 "));
                if (IsActiveReceipt > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Patient already paid in cash" });

                }
            }
            int InvoiceCreated = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "  SELECT Count(*) FROM patient_labInvestigation_opd_share WHERE LedgerTransactionNo='" + LabNo + "' AND InvoiceNo <>'' "));
            if (InvoiceCreated > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Patient invoice is already created" });

            }

            //int OldIsCreditStatus = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IsCredit FROM f_ledgertransaction WHERE LedgerTransactionNo=@LedgerTransactionNo",
            //                                                  new MySqlParameter("@LedgerTransactionNo", LabNo)));

            DataTable dtDisPer = MySqlHelper.ExecuteDataset(tranX, CommandType.Text, " Select round(( DiscountOnTotal/GrossAmount * 100 ),2)DisPer,DiscountOnTotal,Date BookingDate from f_ledgertransaction where LedgerTransactionNo= '" + LabNo + "'; ").Tables[0];

            if (Util.GetDecimal(dtDisPer.Rows[0]["DiscountOnTotal"].ToString()) > 0 && IsCredit == 1)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Please Remove Discount from Discount after Bill Page" });
            }

            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT IFNULL(GROUP_CONCAT(DISTINCT t.ItemCode),'')TestCode FROM ( ");
            sb.Append("     SELECT rat.`ID`,plo.ItemCode ItemCode FROM patient_labInvestigation_opd plo ");
            sb.Append("     LEFT JOIN  `f_ratelist` rat ON rat.`ItemID`=plo.`ItemID`  AND rat.`Panel_ID`=@Panel_ID  AND rat.Rate!=0 ");
            sb.Append("     WHERE plo.LedgerTransactionNo=@LedgerTransactionNo AND rat.`ID` IS NULL");
            sb.Append(" )t ");
            string RateZeroTestCode = Util.GetString(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, sb.ToString(),
                                                                 new MySqlParameter("@Panel_ID", RefferanceCode),
                                                                 new MySqlParameter("@LedgerTransactionNo", LabNo)));
            if (RateZeroTestCode != string.Empty)
            {
                return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Test Code Having Zero Rates are ", RateZeroTestCode) });
            }

            DataTable dtOLD = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT lt.LedgerTransactionID, lt.CentreID,lt.Panel_ID,lt.NetAmount,lt.Adjustment,if(lt.IsCredit=1,lt.NetAmount,0) AmtCredit,fpm.`Company_Name`,cm.`Centre`  FROM f_ledgertransaction lt INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` WHERE lt.LedgerTransactionNo='" + LabNo + "';").Tables[0];

            //            if (Util.GetDecimal(dtDisPer.Rows[0]["DisPer"].ToString()) == 0)
            //            {

            //                sb = new StringBuilder();
            //                sb.Append(@" UPDATE f_ledgertransaction lt  
            //                         INNER JOIN patient_labInvestigation_opd ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo AND IF(ltd.isPackage=1,ltd.`SubCategoryID`=15,ltd.`SubCategoryID`!=15)  
            //                         INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID 
            //                         INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID=" + NewPanel + @" 
            //                         SET lt.Panel_ID=pm2.Panel_ID,lt.InvoiceToPanelID=pm2.InvoiceTo,
            //                         ltd.Amount = (substring_index(get_item_rate(ltd.ItemID," + RefferanceCode + ",NOW()," + NewPanel + @"),'#',1)*ltd.Quantity 
            //                      * IF(ltd.DisCountAmt>0,(100-" + Util.GetDecimal(dtDisPer.Rows[0]["DisPer"].ToString()) + @" *0.01),1)),
            //                         ltd.Rate=(substring_index(get_item_rate(ltd.ItemID," + RefferanceCode + ",NOW()," + NewPanel + @"),'#',1)),");
            //                if (PanelID_MRP != 0)
            //                    sb.Append("  ltd.MRP=(substring_index(get_item_rate(ltd.ItemID," + PanelID_MRP + ",NOW()," + NewPanel + @"),'#',1)),");
            //                else
            //                    sb.Append("  ltd.MRP= (substring_index(get_item_rate(ltd.ItemID," + RefferanceCode + ",NOW()," + NewPanel + @"),'#',1)),");
            //                sb.Append(@"     ltd.paybypatient=(substring_index(get_item_rate(ltd.ItemID," + RefferanceCode + ",NOW()," + NewPanel + @"),'#',1)*ltd.Quantity 
            //                       * IF(ltd.DisCountAmt>0, (100-" + Util.GetDecimal(dtDisPer.Rows[0]["DisPer"].ToString()) + @" *0.01),1)),
            //                         ltd.DisCountAmt=((ltd.Rate*ltd.Quantity)-ltd.Amount),
            //                         lt.PanelName=pm2.Company_Name
            //                         WHERE lt.LedgerTransactionNo='" + LabNo + "';  ");
            //                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            //            }
            //            else
            //            {

            sb = new StringBuilder();
            sb.Append(" UPDATE f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID ");
            sb.Append(" INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID=@Panel_ID");
            sb.Append("  SET lt.Panel_ID=pm2.Panel_ID,lt.InvoiceToPanelID=pm2.InvoiceTo,lt.PanelName=pm2.Company_Name");
            sb.Append("  WHERE lt.LedgerTransactionNo=@LedgerTransactionNo ");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@LedgerTransactionNo", LabNo),
                        new MySqlParameter("@Panel_ID", NewPanel));

            DataTable dtOLDPLO = MySqlHelper.ExecuteDataset(tranX, CommandType.Text, "SELECT Test_ID,ItemID,Rate,DisCountAmt,Amount,Quantity,BillType FROM patient_labInvestigation_opd WHERE LedgerTransactionNo=@LedgerTransactionNo AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15)",
                                            new MySqlParameter("@LedgerTransactionNo", LabNo)).Tables[0];

            var OLDPLORate = dtOLDPLO.AsEnumerable().Where(s => s.Field<decimal>("Rate") > 0);
            if (OLDPLORate.Any())
            {
                // decimal DiscOnTotalAmt = 0;
                // decimal totalDiscount = Util.GetDecimal(dtDisPer.Rows[0]["DiscountOnTotal"].ToString());
                DataTable dtOLDPLORate = OLDPLORate.CopyToDataTable();
                for (int j = 0; j < dtOLDPLORate.Rows.Count; j++)
                {
                    //  round(( DiscountOnTotal/GrossAmount * 100 ),2)DisPer

                    decimal ItemMRPRate = 0;
                    decimal ItemRate = Util.GetDecimal(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT substring_index(get_item_rate(@ItemID," + RefferanceCode + ",NOW()," + NewPanel + "),'#',1)",
                                                                   new MySqlParameter("@ItemID", dtOLDPLORate.Rows[j]["ItemID"].ToString())));
                    if (PanelID_MRP != 0)
                        ItemMRPRate = Util.GetDecimal(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT substring_index(get_item_rate(@ItemID," + PanelID_MRP + ",NOW()," + NewPanel + "),'#',1)",
                                                                   new MySqlParameter("@ItemID", dtOLDPLORate.Rows[j]["ItemID"].ToString())));
                    decimal DiscAmt = 0;
                    if (Util.GetDecimal(dtOLDPLORate.Rows[j]["DisCountAmt"].ToString()) > 0)
                    {
                        decimal discPer = Util.GetDecimal(Util.GetDecimal(dtOLDPLORate.Rows[j]["DisCountAmt"].ToString()) / Util.GetDecimal(dtOLDPLORate.Rows[j]["Rate"].ToString()) * 100);
                        DiscAmt = Math.Round(Util.GetDecimal(ItemRate * discPer * Util.GetDecimal(0.01)), 0);

                    }
                    //if (j == dtOLDPLORate.Rows.Count - 1)
                    //{
                    //    DiscAmt = totalDiscount - DiscOnTotalAmt;
                    //}
                    //else
                    //{
                    //    DiscOnTotalAmt += DiscAmt;
                    //}

                    sb = new StringBuilder();
                    sb.Append("UPDATE patient_labInvestigation_opd plo SET ");
                    sb.Append(" plo.Rate=@ItemRate,");
                    sb.Append(" plo.Amount = (@ItemRate*plo.Quantity)-@DiscAmt,");
                    if (PanelID_MRP != 0)
                        sb.Append("  plo.MRP=@ItemMRPRate,");
                    else
                        sb.Append("  plo.MRP= @ItemRate,");
                    sb.Append("  plo.DisCountAmt=@DiscAmt, ");
                    sb.Append("  plo.paybypatient = (@ItemRate*plo.Quantity)-@DiscAmt");
                    sb.Append(" WHERE plo.Test_ID=@Test_ID ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@Test_ID", dtOLDPLORate.Rows[j]["Test_ID"].ToString()),
                                new MySqlParameter("@ItemRate", ItemRate),
                                new MySqlParameter("@DiscAmt", DiscAmt));
                }
            }

            var OLDPLORateZero = dtOLDPLO.AsEnumerable().Where(s => s.Field<decimal>("Rate") == 0);
            if (OLDPLORateZero.Any())
            {
                DataTable dtOLDPLORateZero = OLDPLORateZero.CopyToDataTable();
                // decimal DiscOnTotalAmt = 0;
                // decimal totalDiscount = Util.GetDecimal(dtDisPer.Rows[0]["DiscountOnTotal"].ToString());
                for (int j = 0; j < dtOLDPLORateZero.Rows.Count; j++)
                {
                    decimal ItemMRPRate = 0;
                    decimal ItemRate = Util.GetDecimal(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT substring_index(get_item_rate(@ItemID," + RefferanceCode + ",NOW()," + NewPanel + "),'#',1)",
                                                                   new MySqlParameter("@ItemID", dtOLDPLORateZero.Rows[j]["ItemID"].ToString())));
                    if (PanelID_MRP != 0)
                        ItemMRPRate = Util.GetDecimal(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, "SELECT substring_index(get_item_rate(@ItemID," + PanelID_MRP + ",NOW()," + NewPanel + "),'#',1)",
                                                                   new MySqlParameter("@ItemID", dtOLDPLORateZero.Rows[j]["ItemID"].ToString())));


                    decimal Rate = Util.GetDecimal(dtOLDPLO.AsEnumerable().Where(s => s.Field<Int32>("ItemID") == Util.GetInt(dtOLDPLORateZero.Rows[j]["ItemID"].ToString()) && s.Field<decimal>("Rate") > 0).Select(s => s.Field<decimal>("Rate")).FirstOrDefault());

                    // decimal DiscAmt = Math.Round(Util.GetDecimal(ItemRate * Util.GetDecimal(dtDisPer.Rows[0]["DisPer"].ToString()) * Util.GetDecimal(0.01)), 0);

                    decimal discPer = Util.GetDecimal(Util.GetDecimal(dtOLDPLORateZero.Rows[j]["DisCountAmt"].ToString()) / Rate) * Util.GetDecimal(100);
                    decimal DiscAmt = Math.Round(Util.GetDecimal(ItemRate * discPer * Util.GetDecimal(0.01)), 0);


                    //if (j == dtOLDPLORateZero.Rows.Count - 1)
                    //{
                    //    DiscAmt = totalDiscount - DiscOnTotalAmt;
                    //}
                    //else
                    //{
                    //    DiscOnTotalAmt += DiscAmt;
                    //}


                    sb = new StringBuilder();
                    sb.Append("UPDATE patient_labInvestigation_opd plo SET ");
                    sb.Append(" Amount = @DiscAmt*-1,");
                    if (PanelID_MRP != 0)
                        sb.Append("  MRP=@ItemMRPRate,");
                    else
                        sb.Append("  MRP= @ItemRate,");
                    sb.Append("  plo.DisCountAmt=@DiscAmt, ");
                    sb.Append("  plo.paybypatient = @DiscAmt*-1");

                    sb.Append(" WHERE Test_ID=@Test_ID ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@Test_ID", dtOLDPLORateZero.Rows[j]["Test_ID"].ToString()),
                                new MySqlParameter("@ItemRate", ItemRate),
                                new MySqlParameter("@DiscAmt", DiscAmt));
                }
            }

            // }


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
            sb.Append(" UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDNAME,NEWNAME,Remarks) ");
            sb.Append(" VALUES('" + LabNo + "','Change Panel','" + HttpContext.Current.Session["ID"].ToString() + "', ");
            sb.Append(" '" + HttpContext.Current.Session["LoginName"].ToString() + "',NOW(), ");
            sb.Append(" '" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',");
            sb.Append(" '" + dtOLD.Rows[0]["Panel_ID"].ToString() + "','" + dt_LTD_2.Rows[0]["Panel_ID"].ToString() + "',");
            sb.Append(" 'OLD Net Amount : " + Util.GetString(dtOLD.Rows[0]["NetAmount"]) + ", New Net Amount : " + Util.GetString(dt_LTD_2.Rows[0]["NetAmount"]) + "' ); ");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            string BookingDate = Util.GetDateTime(dtDisPer.Rows[0]["BookingDate"].ToString()).ToString("yyyy-MM-dd HH:mm:ss");
            Panel_Share ps = new Panel_Share();
            JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(Util.GetInt(dtOLD.Rows[0]["LedgerTransactionID"].ToString()), tranX, con,Util.GetDateTime(BookingDate)));
            if (IPS.status == false)
            {
                tranX.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = IPS.response });
            }
            sb = new StringBuilder();
            sb.Append("INSERT INTO f_ClientChange(OldPanel_ID,NewPanel_ID,LedgerTransactionNo,CreatedByID,CreatedBy,OLDNetAmount,NewNetAmount) ");
            sb.Append(" VALUES(@OldPanel_ID,@NewPanel_ID,@LedgerTransactionNo,@CreatedByID,@CreatedBy,@OLDNetAmount,@NewNetAmount)");
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@OldPanel_ID", OldPanel),
                        new MySqlParameter("@NewPanel_ID", NewPanel),
                        new MySqlParameter("@LedgerTransactionNo", LabNo),
                        new MySqlParameter("@CreatedByID", UserInfo.ID),
                        new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                        new MySqlParameter("@OLDNetAmount", Util.GetDecimal(dtOLD.Rows[0]["NetAmount"].ToString())),
                        new MySqlParameter("@NewNetAmount", Util.GetDecimal(dt_LTD_2.Rows[0]["NetAmount"].ToString())));
            tranX.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Panel Changed Successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            tranX.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = ex.Message.ToString() });

        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }

    }


}