using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_OpdSettelment : System.Web.UI.Page
{
    public static string labno = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindData();
            if (Util.GetString(Request.QueryString["labno"]) != string.Empty)
            {
                labno = Common.Decrypt(Util.GetString(Request.QueryString["labno"]));
                txtLedgerTransactionNo.Text = Common.Decrypt(Util.GetString(Request.QueryString["labno"]));
                txtFormDate.Text = Common.Decrypt(Util.GetString(Request.QueryString["regdate"]));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "$searchData();", true);
            }
            else
            {
                labno = string.Empty;
            }
        }
    }

    private void bindData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select distinct cm.CentreID,CONCAT(cm.CentreCode,'-',cm.Centre) as Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID =@CentreID and AccessType=2 ) or cm.CentreID = @CentreID) and cm.isActive=1 order by cm.CentreCode  ",
                new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
            {
                ddlCentreAccess.DataSource = dt;
                ddlCentreAccess.DataTextField = "Centre";
                ddlCentreAccess.DataValueField = "CentreID";
                ddlCentreAccess.DataBind();
                if (UserInfo.Centre == 1)
                    ddlCentreAccess.Items.Insert(0, new ListItem("ALL Centre", "ALL"));
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetDoctorMaster()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("select doctor_id,name from doctor_referal WHERE isActive=1  order by name"));
    }

    [WebMethod(EnableSession = true)]
    public static string GetPanelMaster()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("select panel_id,company_name from f_panel_master WHERE isActive=1  order by company_name"));
    }

    [WebMethod(EnableSession = true)]
    public static string SearchReceiptData(SearchData searchdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string Roleid = Util.GetString(UserInfo.RoleID); string permissiontype = "Settlement"; string Labno = searchdata.LabNo;
        string rresult = Util.RolePermission(Roleid, permissiontype, Labno);

        if (rresult == "true")
        {
            // return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
            return "-1";
        }
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append(" SELECT lt.centreid, lt.panel_id,lt.patient_id, lt.`LedgerTransactionID`,  DATE_FORMAT(plo.`Date`,'%d-%b-%y %h:%i %p') EntryDate,");
            sb.Append(" lt.`LedgerTransactionNo` LabNo,lt.PName, GROUP_CONCAT(distinct plo.itemname) AS ItemName,");
            sb.Append(" lt.`DoctorName` DoctorName,lt.`PanelName`, pm.mobile,pm.PName,");
            sb.Append(" cm.Centre CentreName,cm.type1ID,");
            sb.Append(" lt.`GrossAmount`,lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`,(round(lt.NetAmount)-round(lt.Adjustment)) DueAmt,");
            sb.Append(" iF(lt.iscredit=1,1,0) PanelCredit ,if((round(lt.NetAmount)-round(lt.Adjustment))!=0,'#FFC0CB','#90EE90')rowColor, ");
            sb.Append(" IFNULL((SELECT  SUM(oa.AdvanceAmount-oa.BalanceAmount) FROM opd_advance oa WHERE oa.IsCancel = 0  AND   oa.Patient_ID = lt.Patient_ID),0) OPDAdvanceAmount ");
            sb.Append(" FROM `f_ledgertransaction` lt ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`");
            sb.Append(" INNER JOIN centre_master cm on cm.centreID=lt.centreid ");
            sb.Append(" INNER JOIN  patient_master pm on pm.Patient_ID=lt.Patient_ID ");
            if (Util.GetString(searchdata.LabNo) != string.Empty)
            {
                if (Util.GetString(searchdata.SearchType) == "lt.PName")
                    sb.Append(" AND  " + Util.GetString(searchdata.SearchType) + " LIKE @SearchType");
                else if (Util.GetString(searchdata.SearchType) == "pm.Mobile")
                    sb.Append("  AND pm.mobile = @LabNo  ");
                else
                    sb.Append(" AND  " + Util.GetString(searchdata.SearchType) + "=@LabNo");
            }
            sb.Append(" WHERE  lt.date>=@FromDate AND lt.date<=@ToDate  ");
            if (Util.GetString(searchdata.Centre) != "ALL")
            {
                sb.Append(" AND  lt.centreid=@Centre");
            }
            if (Util.GetString(searchdata.Panel) != string.Empty && Util.GetString(searchdata.Panel) != "null")
            {
                sb.Append(" AND  lt.panel_id=@Panel");
            }
            if (Util.GetString(searchdata.ReferBy) != string.Empty && Util.GetString(searchdata.ReferBy) != "null")
            {
                sb.Append(" AND  lt.`Doctor_ID`=@ReferBy");
            }
            sb.Append(" GROUP BY lt.LedgerTransactionNo ORDER BY lt.LedgerTransactionNo");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@SearchType", "%" + searchdata.LabNo + "%"),
                new MySqlParameter("@LabNo", searchdata.LabNo), new MySqlParameter("@Centre", Util.GetString(searchdata.Centre)),
                new MySqlParameter("@Panel", searchdata.Panel), new MySqlParameter("@ReferBy", searchdata.ReferBy),
                new MySqlParameter("@FromDate", searchdata.FromDate.ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@ToDate", searchdata.ToDate.ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveSettlement(List<Receipt> Rcdata, List<patientdetail> Patientdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();

            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM f_ledgertransaction WHERE LedgerTransactionID=@LedgerTransactionID AND ROUND(IFNULL(Adjustment,0))=ROUND(NetAmount)",
                   new MySqlParameter("@PaidAmount", Util.GetDecimal(Rcdata.Select(x => x.Amount).Sum())),
                   new MySqlParameter("@LedgerTransactionID", Rcdata[0].LedgerTransactionID)));
            if (count > 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Lab No. already settled" });
            }


            sb.Append("UPDATE f_ledgertransaction set Adjustment=Adjustment+@Adjustment+@Currency_RoundOff,AdjustmentDate=now(),UpdateID=@UpdateID, UpdateName=@UpdateName,");
            sb.Append(" UpdateRemarks='Settlement',Currency_RoundOff=Currency_RoundOff+@Currency_RoundOff WHERE LedgerTransactionID=@LedgerTransactionID ");

            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Adjustment", Rcdata.Select(x => x.Amount).Sum()),
                new MySqlParameter("@UpdateID", UserInfo.ID),
                new MySqlParameter("@UpdateName", UserInfo.LoginName),
                new MySqlParameter("@LedgerTransactionID", Rcdata[0].LedgerTransactionID),
                new MySqlParameter("@Currency_RoundOff", Rcdata[0].Currency_RoundOff));
            if (a == 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in LT update" });
            }
            DateTime billData = DateTime.Now;
            foreach (Receipt rrc in Rcdata)
            {
                Receipt objRC = new Receipt(tnx)
                {
                    LedgerNoCr = "HOSP0005",
                    LedgerTransactionID = rrc.LedgerTransactionID,
                    LedgerTransactionNo = rrc.LedgerTransactionNo,
                    CreatedByID = UserInfo.ID,
                    Patient_ID = rrc.Patient_ID,
                    PayBy = rrc.PayBy,
                    PaymentMode = rrc.PaymentMode,
                    PaymentModeID = rrc.PaymentModeID,
                    Amount = rrc.Amount,
                    BankName = rrc.BankName,
                    CardNo = rrc.CardNo,
                    CardDate = rrc.CardDate,
                    IsCancel = 0,
                    Narration = rrc.Narration,
                    CentreID = rrc.CentreID,
                    Panel_ID = rrc.Panel_ID,
                    CreatedDate = billData,
                    S_Amount = rrc.S_Amount,
                    S_CountryID = rrc.S_CountryID,
                    S_Currency = rrc.S_Currency,
                    S_Notation = rrc.S_Notation,
                    C_Factor = rrc.C_Factor,
                    Currency_RoundOff = rrc.Currency_RoundOff,
                    Converson_ID = rrc.Converson_ID,
                    CurrencyRoundDigit = rrc.CurrencyRoundDigit,
                    transactionid = rrc.transactionid,
                    CreatedBy = UserInfo.LoginName
                };
                string ReceiptNo = objRC.Insert();
                if (ReceiptNo == string.Empty)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
                }
                var patientAdvancePaymentMode = Rcdata.Where(p => p.PaymentModeID == 9).ToList();
                for (int i = 0; i < patientAdvancePaymentMode.Count; i++)
                {
                    using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,(AdvanceAmount-IFNULL(BalanceAmount,0))RemAmt,ReceiptNo FROM OPD_Advance WHERE Patient_ID =@Patient_ID  AND IsCancel=0 AND (AdvanceAmount-IFNULL(BalanceAmount,0))>0 ORDER BY ID+0",
                        new MySqlParameter("@Patient_ID", rrc.Patient_ID)).Tables[0])
                    {
                        if (dt.Rows.Count > 0)
                        {
                            decimal advanceAmount = patientAdvancePaymentMode[i].Amount;
                            for (int s = 0; s < dt.Rows.Count; s++)
                            {
                                decimal paidAmt = 0;
                                if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) >= Util.GetDecimal(advanceAmount))
                                {
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmount =BalanceAmount+@advanceAmount WHERE ID =@ID ",
                                        new MySqlParameter("@advanceAmount", Util.GetDecimal(advanceAmount)), new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));
                                    paidAmt = advanceAmount;
                                    advanceAmount = 0;
                                }
                                else if (Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString()) < Util.GetDecimal(advanceAmount))
                                {
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update OPD_Advance SET BalanceAmount =BalanceAmount+@BalanceAmount WHERE ID =@ID ",
                                       new MySqlParameter("@BalanceAmount", Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString())), new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));

                                    advanceAmount = advanceAmount - Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                    paidAmt = Util.GetDecimal(dt.Rows[s]["RemAmt"].ToString());
                                }
                                OPD_Advance_Detail adv = new OPD_Advance_Detail(tnx)
                                {
                                    PaidAmount = Util.GetDecimal(paidAmt),
                                    Patient_ID = rrc.Patient_ID,
                                    LedgerTransactionID = rrc.LedgerTransactionID,
                                    LedgerTransactionNo = rrc.LedgerTransactionNo,
                                    ReceiptNo = ReceiptNo,
                                    CentreID = rrc.CentreID,
                                    Panel_ID = rrc.Panel_ID,
                                    CreatedBy = UserInfo.LoginName,
                                    CreatedByID = UserInfo.ID,
                                    AdvanceID = Util.GetInt(dt.Rows[s]["ID"].ToString()),
                                    ReceiptNoAgainst = dt.Rows[s]["ReceiptNo"].ToString()
                                };
                                adv.Insert();
                                if (advanceAmount == 0)
                                    break;
                            }
                            if (advanceAmount > 0)
                            {
                                tnx.Rollback();
                                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                            }
                        }
                        else
                        {
                            tnx.Rollback();
                            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Un-Sufficient OPD Advance Balance", message = "Error In OPD Advance" });
                        }
                    }
                }
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                             new MySqlParameter("@LedgertransactionNo", Rcdata[0].LedgerTransactionNo),
                                                             new MySqlParameter("@SinNo",""), new MySqlParameter("@Test_ID", "0"),
                                                             new MySqlParameter("@Status", "OPD Sattelment of " + Util.GetString(Rcdata.Select(x => x.Amount).Sum())), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                             new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty), new MySqlParameter("@dtEntry", billData), new MySqlParameter("@LedgerTransactionID", Rcdata[0].LedgerTransactionID));
            sb = new StringBuilder();
            sb.Append(" SELECT COUNT(1) ");
            sb.Append("   FROM (SELECT lt.LedgerTransactionID,lt.NetAmount, ");
            sb.Append("          (SELECT SUM(re.Amount) FROM f_receipt  re  ");
            sb.Append("    WHERE re.IsCancel=0 AND re.LedgerTransactionID = lt.LedgerTransactionID AND re.LedgerTransactionID=@LedgerTransactionID) AS totalPaidAmt ");
            sb.Append(" FROM f_ledgertransaction lt WHERE lt.LedgerTransactionID=@LedgerTransactionID");
            sb.Append(" )t1 ");
            sb.Append(" WHERE t1.totalPaidAmt > t1.NetAmount ");

            count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionID", Rcdata[0].LedgerTransactionID)));
            if (count > 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Lab No. already settled" });
            }
            if (Patientdata[0].MobileNo != string.Empty)
            {
                    SMSDetail sd = new SMSDetail();
                    List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>  
                        {  
                            new SMSDetailListRegistration {
                                                LabNo=Rcdata[0].LedgerTransactionNo,
                                                PName = Patientdata[0].PName,
                                                PaidAmout=Util.GetString(Rcdata.Select(x => x.Amount).Sum())
                                                                       
                                               }   
                        };
                    if (Rcdata.Select(x => x.Amount).Sum() > 0)
                    {
                        JSONResponse SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(9, Util.GetInt(Rcdata[0].Panel_ID), Util.GetInt(Patientdata[0].CentreTypeID), "Patient", Patientdata[0].MobileNo, Rcdata[0].LedgerTransactionID, con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                        }
                    }
                    if (Rcdata.Select(x => x.Amount).Sum() < 0)
                    {
                        JSONResponse SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(10, Rcdata[0].Panel_ID, Util.GetInt(Patientdata[0].CentreTypeID), "Patient", Patientdata[0].MobileNo, Rcdata[0].LedgerTransactionID, con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                        }
                    }
                    SMSDetail.Clear();
                
            }

	    //---Settlement Email-----
            try
            {
                ReportEmailClass objEmail = new ReportEmailClass();
                objEmail.SendSettlementMail(Util.GetInt(Rcdata[0].LedgerTransactionID), tnx);
            }
            catch
            {

            }
            //------------------

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", LabID = Common.Encrypt(Util.GetString(Rcdata[0].LedgerTransactionID)) });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = true, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class GetData
    {
        public decimal Amount { get; set; }
        public int PaymentModeID { get; set; }
        public string PaymentMode { get; set; }
        public int LedgerTransactionID { get; set; }
        public string LedgerTransactionNo { get; set; }
        public string BankName { get; set; }
        public string CardNo { get; set; }
        public DateTime CardDate { get; set; }
        public string Naration { get; set; }
        public string Refund { get; set; }
        public string Patient_ID { get; set; }
        public int Panel_ID { get; set; }
        public int CentreID { get; set; }
        public string PayBy { get; set; }
    }

    public class SearchData
    {
        public string SearchType { get; set; }
        public string LabNo { get; set; }
        public string Centre { get; set; }
        public string Panel { get; set; }
        public string ReferBy { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
    }
    public class patientdetail
    {
        public string MobileNo { get; set; }
        public string CentreTypeID { get; set; }
        public string PName { get; set; }
    }
}