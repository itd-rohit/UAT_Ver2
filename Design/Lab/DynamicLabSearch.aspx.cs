using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Lab_DynamicLabSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.Form["LabNo"] != null)
            {
                txtDynamicSearch.Text = Common.Decrypt(Request.Form["LabNo"]);
                if (txtDynamicSearch.Text != string.Empty)
                {
                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "shat123", "PatientLabSearch();", true);

                }
                setPrintCheck();
            }
        }
    }
    private void setPrintCheck()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT COUNT(*) FROM centre_master cm ");
            sb.Append(" INNER JOIN `businesszone_master` bzm ON bzm.`BusinessZoneID`=cm.`BusinessZoneID` ");
            sb.Append(" WHERE bzm.`BusinessZoneID`=1 AND  cm.IsActive=1 And cm.`CentreID`=@CentreID ");
            int isEastCentre = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CentreID", UserInfo.Centre)));
            if (isEastCentre > 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "myFuncToCheck", "document.getElementById('chheader').checked=true;", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "myFuncToCheck", "document.getElementById('chheader').checked=false;", true);
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
    public static string SearchDynamic(string DynamicSearch)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            int IsBarcode = 0;
            int IsLabNo = 0;
            int IsMobileNo = 0;
            int IsUHIDNo = 0;
            int IsSlideNo = 0;
            int IsBillNo = 0;
            string ItemData = DynamicSearch.TrimEnd(',');
            int len = Util.GetInt(ItemData.Split(',').Length);
            List<string> strDataList = new List<string>();
            strDataList = ItemData.Split(',').ToList<string>();
            strDataList = ItemData.Split(',').Select(x => string.Format("'{0}'", x)).ToList<string>();

            DynamicSearch = ItemData.TrimEnd(',');
           
            using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT COUNT(1) FROM `patient_labinvestigation_opd` plo WHERE plo.`BarcodeNo` IN({0})", string.Join(",", strDataList)), con))
            {
                for (int i = 0; i < strDataList.Count; i++)
                {
                    cmd.Parameters.Add(string.Concat("@p", i), strDataList[i]);
                }
                IsBarcode = Convert.ToInt32(cmd.ExecuteScalar());
            }
            if (IsBarcode == 0)
            {
                using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT COUNT(1) FROM `patient_labinvestigation_opd` plo WHERE plo.`LedgerTransactionNo` IN({0})", string.Join(",", strDataList)), con))
                {
                    for (int i = 0; i < strDataList.Count; i++)
                    {
                        cmd.Parameters.Add(string.Concat("@p", i), strDataList[i]);
                    }
                    IsLabNo = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            if (IsBarcode == 0 && IsLabNo == 0)
            {
                
                using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT COUNT(1) FROM `patient_master` pm WHERE pm.`Mobile` IN({0})", string.Join(",", strDataList)), con))
                {
                    for (int i = 0; i < strDataList.Count; i++)
                    {
                        cmd.Parameters.Add(string.Concat("@p", i), strDataList[i]);
                    }
                    IsMobileNo = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            if (IsBarcode == 0 && IsLabNo == 0 && IsMobileNo == 0)
            {
                
                using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT COUNT(1) FROM `patient_master` pm WHERE pm.`Patient_ID` IN({0})", string.Join(",", strDataList)), con))
                {
                    for (int i = 0; i < strDataList.Count; i++)
                    {
                        cmd.Parameters.Add(string.Concat("@p", i), strDataList[i]);
                    }
                    IsUHIDNo = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            if (IsBarcode == 0 && IsLabNo == 0 && IsMobileNo == 0 && IsUHIDNo == 0)
            {
                
                using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT COUNT(1) FROM `patient_labinvestigation_opd` plo WHERE plo.`SlideNumber` IN({0})", string.Join(",", strDataList)), con))
                {
                    for (int i = 0; i < strDataList.Count; i++)
                    {
                        cmd.Parameters.Add(string.Concat("@p", i), strDataList[i]);
                    }
                    IsSlideNo = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            if (IsBarcode == 0 && IsLabNo == 0 && IsMobileNo == 0 && IsUHIDNo == 0 && IsSlideNo == 0)
            {
                using (MySqlCommand cmd = new MySqlCommand(" SELECT COUNT(1) FROM `patient_labinvestigation_opd` WHERE `BillNo`= @BillNo ", con))
                {
                    cmd.Parameters.Add(new MySqlParameter("@BillNo", DynamicSearch));
                    IsBillNo = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            if (IsBarcode == 0 && IsLabNo == 0 && IsMobileNo == 0 && IsUHIDNo == 0 && IsSlideNo == 0 && IsBillNo == 0)
            {
                strDataList.Clear();
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT lt.`PatientSource`,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i %p') EntryDate,lt.`LedgerTransactionNo`,pli.`BarcodeNo`,pli.barcode_group,lt.Patient_ID ,");
            sb.Append(" IF((SELECT Count(LabNo)  FROM `document_detail` dt WHERE dt.`LabNo`=lt.LedgerTransactionNo AND dt.isRequestDocument=1 LIMIT 1)>0,'Yes','No')DocUploded,");
            sb.Append(" (SELECT pm.`Mobile`  FROM `patient_master` pm WHERE pm.`Patient_ID`=lt.Patient_ID LIMIT 1)PMob,");
            sb.Append(" (SELECT dr.`Mobile` FROM `doctor_referal` dr WHERE dr.`Doctor_ID`=lt.Doctor_ID LIMIT 1)DocMob,Prm.PROName, ");
            sb.Append(" (SELECT COUNT(1) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= pli.Test_ID and isActive=1 ) Remarks, ");
            sb.Append(" lt.`PName`,CONCAT(lt.`Age`,'/',lt.`Gender`) pinfo,(SELECT centre FROM centre_master WHERE centreid=lt.centreid)centre,");
            sb.Append(" lt.`DoctorName`,lt.`PanelName`,obm.Name AS Dept,pli.`ItemName`,pli.`Test_ID`,");
            sb.Append(" pli.Approved,'' SampleStatus,");
            sb.Append(" IFNULL((SELECT ID FROM document_detail dd WHERE dd.`labNo`=lt.`LedgerTransactionNo` And IsActive=1 LIMIT 1 ),'')DocumentStatus,");
            sb.Append(" CASE   WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' "); //Dispatched
            sb.Append(" WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF'  "); //Printed
            sb.Append(" WHEN pli.isFOReceive='0' AND pli.Approved='1'  THEN '#90EE90' "); //Approved
            sb.Append(" WHEN pli.Result_Flag='1' AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R'  THEN '#FFC0CB'  "); //Tested      
            sb.Append(" WHEN pli.isHold='1' THEN '#FFFF00' "); //Hold
            sb.Append(" WHEN pli.IsSampleCollected='N' THEN '#CC99FF'  ");//New
            sb.Append(" WHEN pli.IsSampleCollected='S' THEN 'bisque'  ");//Sample Collected
            sb.Append(" WHEN pli.IsSampleCollected='Y' THEN '#FFFFFF' "); //Department Receive
            sb.Append(" WHEN pli.IsSampleCollected='R' THEN '#CCC' "); //Rejected Test
            sb.Append(" ELSE '#FFFFFF' END rowColor,  ");
            sb.Append(" if(pli.IsSampleCollected='S',(SELECT `Status` FROM  patient_labinvestigation_opd_update_status plus WHERE plus.BarcodeNo=pli.BarcodeNo ORDER BY dtEntry DESC LIMIT 1 ),'') LogisticStatus  ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli  ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON pli.`LedgerTransactionID`=lt.`LedgerTransactionID` AND pli.isreporting=1 ");
            //  sb.Append("  and IF(pli.IsSampleCollected<>'R', pli.isreporting=1,pli.isreporting=0)  ");

            if (IsMobileNo != 0)
            {
                sb.Append(" INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id ");
            }
            sb.Append(" Left JOIN pro_master prm ON prm.PROID=(select PROID from doctor_referal where doctor_ID=lt.doctor_ID) ");
            sb.Append(" INNER JOIN f_subcategorymaster obm ON obm.subcategoryid=pli.subcategoryid ");
            sb.Append(" WHERE pli.IsActive=1 and investigation_id !=0 ");
            if (UserInfo.Centre != 1 && UserInfo.Centre != 2 && UserInfo.Centre != 4 && UserInfo.Centre != 3)
            {
                sb.Append(" and  ( lt.CentreId in (SELECT  CentreID  FROM centre_master cm WHERE ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID =@CentreID ) OR cm.CentreID =@CentreID) AND cm.isActive=1 ORDER BY cm.CentreCode)  ");
                sb.Append(" or pli.TestCentreID in (SELECT  CentreID  FROM centre_master cm WHERE ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID =@CentreID ) OR cm.CentreID =@CentreID) AND cm.isActive=1 ORDER BY cm.CentreCode))  ");
            }
            if (IsLabNo != 0)
            {
                sb.Append(" AND  pli.LedgerTransactionNo IN ({0})  ");
            }
            else if (IsBarcode != 0)
            {
                sb.Append(" AND  pli.`BarcodeNo` IN ({0}) ");
            }
            else if (IsMobileNo != 0)
            {
                sb.Append(" AND pm.`Mobile` IN ({0}) ");
            }
            else if (IsUHIDNo != 0)
            {
                sb.Append(" AND lt.Patient_ID IN ({0})  ");
            }
            else if (IsSlideNo != 0)
            {
                sb.Append(" AND pli.SlideNumber IN ({0})  ");
            }
            else if (IsBillNo != 0)
            {
                sb.Append(" AND pli.`BillNo`= @BillNo  ");
            }


            sb.Append(" ORDER BY lt.date DESC,pli.LedgerTransactionNo,pli.barcodeno, pli.`ItemName` ");
         //   System.IO.File.AppendAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\aasdalsjdklaj.txt", sb.ToString());
            strDataList = ItemData.Split(',').Select(x => string.Format("'{0}'", x)).ToList<string>();
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), string.Join(",", strDataList)), con))
            {                             
                da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.Centre);
                if (IsBillNo == 0)
                {
                    for (int i = 0; i < strDataList.Count; i++)
                    {                       
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@LedgerTransactionNoParam", i), strDataList[i]);
                    }
                }                
                else if (IsBillNo != 0)
                    da.SelectCommand.Parameters.AddWithValue("@BillNo", DynamicSearch);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    strDataList.Clear();
                    return JsonConvert.SerializeObject(new { status = true, response = dt });
                }
            }           
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string labDetail(string BarcodeNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT DATE_FORMAT(plis.dtEntry,'%d-%b-%Y %h:%i %p')EntryDate,CONCAT(em.Title,' ',Em.Name)EntryBy,plis.Status ");
            sb.Append(" FROM patient_labinvestigation_opd_update_status plis  ");
            sb.Append(" inner join patient_labinvestigation_opd plo on plo.BarcodeNo=plis.BarcodeNo ");
            sb.Append(" INNER JOIN employee_master em on em.Employee_ID=plis.UserID ");
            sb.Append(" WHERE    plo.Barcode_group=@BarcodeNo  ");

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@BarcodeNo", BarcodeNo)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string encryptData(string barcodeno)
    {
        return JsonConvert.SerializeObject(new { barcodeno = Common.Encrypt(barcodeno) });

    }
    [WebMethod]
    public static string PostRemarksData(string TestID, string TestName, string VisitNo)
    {
        return Util.getJson(new { TestID = Common.EncryptRijndael(TestID), TestName = Common.EncryptRijndael(TestName), VisitNo = Common.EncryptRijndael(VisitNo) });

    }
}