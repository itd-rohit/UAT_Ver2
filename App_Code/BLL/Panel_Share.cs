using System;
using System.Collections.Generic;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using Newtonsoft.Json;
using System.Web.Script.Serialization;
/// <summary>
/// Summary description for Panel_Share
/// </summary>
public class Panel_Share
{

    public string InsertPanel_Share(int LedgerTransactionID, MySqlTransaction tnx, MySqlConnection con, DateTime? _RegDate = null)
    {
        try
        {
            if (!_RegDate.HasValue)
                _RegDate = DateTime.Now;

            string RegDateTime = string.Concat(Util.GetDateTime(_RegDate).ToString("yyyy-MM-dd")," 00:00:00");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " DELETE FROM patient_labinvestigation_opd_share WHERE LedgerTransactionID = @LedgerTransactionID AND Date>=@RegDate",
                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                new MySqlParameter("@RegDate",RegDateTime));

            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT plo.Test_ID,plo.LedgerTransactionID,plo.LedgerTransactionNo,plo.ItemId,CAST(plo.DATE AS CHAR)DATE,plo.Rate,plo.MRP,plo.Amount,plo.DiscountAmt,plo.Quantity,plo.DiscountByLab,lt.Panel_ID,plo.CouponAmt,lt.CouponID,  
                         pm.IsMultipleShare,lt.CentreID,plo.IsScheduleRate,plo.ItemName,pm.InvoiceTo,pm.PanelType,pm.IsInvoice,DATE_FORMAT(plo.date,'%d-%b-%Y %H:%i:%s') BookingDate,plo.IsSRA,IF(IFNULL(plo.SRADate,''),'',DATE_FORMAT(plo.SRADate,'%d-%b-%Y %H:%i:%s'))SRADate,BillNo,PayByPanel,PayByPatient,pm.CentreType1,pm.CentreType1ID,pm.PanelGroup,pm.AllowSharing,plo.IsSampleCollected 
                         FROM patient_labinvestigation_opd plo  
                         INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` 
                         AND lt.LedgerTransactionID=@LedgerTransactionID AND  IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15)   
                         INNER JOIN f_panel_master pm ON lt.Panel_id=pm.Panel_ID AND plo.Date>=@RegDate; ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                new MySqlParameter("@RegDate", RegDateTime)
                ).Tables[0])
            {
                string _BarcodeNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "Select BarcodeNo from patient_labinvestigation_opd Where LedgerTransactionID = @LedgerTransactionID and BarcodeNo<>'' LIMIT 1;",
                    new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)));

                if (dt.Rows.Count == 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "No Row Found in Share Data" });
                }
                string PanelType = Util.GetString(dt.Rows[0]["CentreType1"].ToString());
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (Util.GetDecimal(dt.Rows[i]["Quantity"].ToString()) < 0)
                    {

                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO patient_labinvestigation_opd_share(Centre_PanelID,Panel_ID,LedgerTransactionID,LedgerTransactionNo,ItemId,");
                        sb.Append(" DATE,Rate,Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,PCCGrossAmt,PCCDiscAmt,PCCNetAmt,PCCSpecialFlag,PCCInvoiceAmt,PCCPercentage,");
                        sb.Append(" Mrp,BillNo,Test_ID,IsSRA,SRADate,IsSampleCollected) ");
                        sb.Append(" SELECT @Centre_PanelID,@Panel_ID,@LedgerTransactionID,@LedgerTransactionNo,@ItemId,");
                        sb.Append(" @DATE,SUM(plos.Rate),SUM(Amount)*-1,SUM(plos.DiscountAmt)*-1,SUM(plos.CouponAmt)*-1,plos.Quantity*-1,plos.DiscountByLab,SUM(plos.PCCGrossAmt)*-1,SUM(plos.PCCDiscAmt)*-1, ");
                        sb.Append(" SUM(plos.PCCNetAmt)*-1,plos.PCCSpecialFlag,SUM(plos.PCCInvoiceAmt)*-1,plos.PCCPercentage,plos.Mrp,@BillNo,@Test_ID,plos.IsSRA,plos.SRADate,plos.IsSampleCollected   ");
                        sb.Append(" FROM patient_labinvestigation_opd_share plos ");
                        sb.Append(" WHERE plos.ItemId=@ItemId AND plos.LedgerTransactionID=@LedgerTransactionID GROUP BY plos.ItemId");


                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@BarcodeNo", _BarcodeNo),
                            new MySqlParameter("@Centre_PanelID", Util.GetInt(dt.Rows[i]["Panel_ID"].ToString())),
                            new MySqlParameter("@Panel_ID", Util.GetInt(dt.Rows[i]["InvoiceTo"].ToString())),
                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                            new MySqlParameter("@LedgerTransactionNo", dt.Rows[i]["LedgerTransactionNo"].ToString()),
                            new MySqlParameter("@ItemId", dt.Rows[i]["ItemId"].ToString()),
                            new MySqlParameter("@DATE", Util.GetDateTime(dt.Rows[i]["BookingDate"].ToString())),
                            new MySqlParameter("@BillNo", dt.Rows[i]["BillNo"].ToString()),
                            new MySqlParameter("@Test_ID", dt.Rows[i]["Test_ID"].ToString())
                            );
                    }
                    else
                    {
                        patient_labinvestigation_opd_share plos = new patient_labinvestigation_opd_share(tnx);
                        plos.BarcodeNo = _BarcodeNo;
                        plos.Centre_PanelID = Util.GetInt(dt.Rows[i]["Panel_ID"].ToString());
                        plos.Panel_ID = Util.GetInt(dt.Rows[i]["InvoiceTo"].ToString());
                        plos.LedgerTransactionID = LedgerTransactionID;
                        plos.LedgerTransactionNo = dt.Rows[i]["LedgerTransactionNo"].ToString();
                        plos.ItemId = Util.GetInt(dt.Rows[i]["ItemId"].ToString());
                        plos.Rate = Util.GetDecimal(dt.Rows[i]["Rate"].ToString());
                        plos.Amount = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
                        plos.DiscountAmt = Util.GetDecimal(dt.Rows[i]["DiscountAmt"].ToString());
                        plos.Quantity = Util.GetDecimal(dt.Rows[i]["Quantity"].ToString());
                        plos.DiscountByLab = Util.GetInt(dt.Rows[i]["DiscountByLab"].ToString());
                        plos.Date = Util.GetDateTime(dt.Rows[i]["BookingDate"].ToString());
                        plos.MRP = Util.GetDecimal(dt.Rows[i]["MRP"].ToString());
                        plos.Test_ID = Util.GetInt(dt.Rows[i]["Test_ID"].ToString());
                        plos.IsSampleCollected = Util.GetString(dt.Rows[i]["IsSampleCollected"].ToString());
                        plos.IsSRA = Util.GetByte(dt.Rows[i]["IsSRA"].ToString());
                        plos.SRADate = Util.GetDateTime(dt.Rows[i]["SRADate"].ToString());
                        plos.BillNo = dt.Rows[i]["BillNo"].ToString();
                        plos.PCCGrossAmt = Util.GetDecimal(dt.Rows[i]["Rate"].ToString()) * Util.GetDecimal(dt.Rows[i]["Quantity"].ToString());
                        plos.PCCDiscAmt = 0;
                        plos.PCCNetAmt = Util.GetDecimal(dt.Rows[i]["Rate"].ToString()) * Util.GetDecimal(dt.Rows[i]["Quantity"].ToString());

                        if (Util.GetInt(dt.Rows[i]["AllowSharing"].ToString()) == 1)
                        {
                            string PCCRate = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT get_pccshare(@InvoiceTo,@ItemID,@Panel_ID,@CouponAmt,@CouponID)",
                                                                        new MySqlParameter("@InvoiceTo", Util.GetInt(dt.Rows[i]["InvoiceTo"].ToString())),
									new MySqlParameter("@Panel_ID", Util.GetInt(dt.Rows[i]["Panel_ID"].ToString())),
									new MySqlParameter("@CouponAmt", Util.GetDecimal(dt.Rows[i]["CouponAmt"].ToString())),
									new MySqlParameter("@CouponID", Util.GetInt(dt.Rows[i]["CouponID"].ToString())),
                                                                        new MySqlParameter("@ItemID", Util.GetInt(dt.Rows[i]["ItemId"].ToString()))));
                            if (PCCRate != string.Empty)
                            {
                                if (PCCRate.Split('#')[1] == "Amount")
                                {
                                    if (Util.GetDecimal(PCCRate.Split('#')[0]) > Util.GetDecimal(dt.Rows[i]["Amount"].ToString()))
                                    {
                                        plos.PCCInvoiceAmt = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());

                                    }
                                    else
                                    {
                                        plos.PCCInvoiceAmt = Util.GetDecimal(PCCRate.Split('#')[0]);
                                        plos.PCCSpecialFlag = 1;
                                    }
                                }
                                else
                                {
                                    if (Util.GetDecimal(PCCRate.Split('#')[0]) > 0)
                                    {
                                        plos.PCCInvoiceAmt = Util.GetDecimal(Util.GetDecimal(plos.Amount) * Util.GetDecimal(PCCRate.Split('#')[0]) * Util.GetDecimal(0.01));
                                        plos.PCCPercentage = Util.GetDecimal(PCCRate.Split('#')[0]);
                                        plos.PCCSpecialFlag = 1;
                                    }
                                    else
                                    {
                                        plos.PCCInvoiceAmt = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
                                    }
                                }

                            }
                            else
                            {
                                plos.PCCInvoiceAmt = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
                            }
                        }
                        else
                        {
                            plos.PCCInvoiceAmt = Util.GetDecimal(dt.Rows[i]["Amount"].ToString());
                        }
                        plos.Insert();
                    }
                }
                return JsonConvert.SerializeObject(new { status = true, response = "Success" });

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Share Error" });

        }


    }
}