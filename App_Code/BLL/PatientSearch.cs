using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for PatientSearch
/// </summary>
public class PatientSearch
{
    public PatientSearch()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable SearchWorkSheet(string LabNo, string RegNo,
       string PName, string CentreID, string dtFrom, string dtTo, string SearchByDate, string wrkst, string Status,
       string PhoneNo, string Mobile, string refrdby, string Ptype, string TimeFrm, string TimeTo, string FromLabNo, string ToLabNo, string PanelID, string CardNoFrom, string CardNoTo, string InvestigationID, string isUrgent, string slidenumber, string macid, string rerun, string colorCode, string SinNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            PanelID = PanelID.Split('#')[0];
            PanelID = PanelID.Replace(",", "','");
            StringBuilder sb = new StringBuilder();

            sb.Append("select  pli.BarCodeNo,'' as ReportDate,'OPD' Type,IFNULL(IF(pli.LabOutsrcID=0, im.Name,CONCAT(im.name,'(OutSrc-',pli.LabOutsrcName,')')),im.name)  ObservationName,io.ObservationType_Id, im.Investigation_Id,PM.Patient_ID, Replace(PM.Patient_ID,'LSHHI','')PID,PM.pname,CONCAT(pm.age,'/',LEFT(pm.gender,1)) age,pm.gender,concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.Test_ID,pli.LedgerTransactionNo,pli.LedgerTransactionNo LTD,im.Name,pli.slidenumber");
            sb.Append(" ,if(PLI.Result_Flag = 0,'false','true')IsResult,date_format(pli.date,'%d-%b-%y')InDate,pli.Approved,if(pli.Approved='1','True','False') chkWork,IM.ReportType, ");
            sb.Append(" CASE   WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' "); //Dispatched
            sb.Append(" WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF'  "); //Printed
            sb.Append(" WHEN pli.isFOReceive='0' AND pli.Approved='1'  THEN '#90EE90' "); //Approved
            sb.Append(" WHEN pli.Result_Flag='1' AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R'  THEN '#FFC0CB'  "); //Tested
            sb.Append(" WHEN pli.Result_Flag='0' AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R' And pli.isrerun='1'  THEN '#F781D8'  "); //Tested
            sb.Append(" WHEN pli.isHold='1' THEN '#FFFF00' "); //Hold
            sb.Append(" WHEN pli.IsSampleCollected='N' THEN '#CC99FF'  ");//New
            sb.Append(" WHEN pli.IsSampleCollected='S' THEN 'bisque'  ");//Sample Collected
            sb.Append(" WHEN pli.IsSampleCollected='Y' THEN '#FFFFFF' "); //Department Receive
            sb.Append(" ELSE '#FFFFFF' END rowColor  ");
            sb.Append(" ,(select Company_Name from f_panel_master where Panel_ID= lt.panel_ID)PanelName");

            sb.Append(", obm.Name as Dept ");
            sb.Append(" ,IF(lt.Doctor_id=2,'Other',DoctorName) ReferBy ");
            sb.Append(" ,pli.IsSampleCollected,if(im.TYPE<>'N' and pli.IsSampleCollected='Y',date_format(pli.SampleCollectionDate,'%d-%b-%y %h:%i %p'),'')SampleDate ");
            sb.Append(" ,lt.PatientType  from patient_labinvestigation_opd pli  ");
            sb.Append(" inner join f_ledgertransaction lt on lt.LedgerTransactionID=pli.LedgerTransactionID   ");

            if (SinNo.Trim() != string.Empty)
            {
                sb.Append(" AND pli.BarCodeNo=@Barcodeno ");
            }
            if (dtFrom != string.Empty)
            {
                if (Status == "Pending")
                {
                    sb.Append(" AND PLI.DeliveryDate >= @fromdate and pli.Approved=0 ");
                }
                else
                {
                    if (SearchByDate == "Sample Receiving Date")
                    {
                        sb.Append(" AND PLI.SampleReceiveDate >= @fromdate");
                    }
                    else if (SearchByDate == "Approved Date")
                    {
                        sb.Append(" and PLI.ApprovedDate >= @fromdate");
                    }
                    else if (SearchByDate == "Sample Collection Date")
                    {
                        sb.Append(" and PLI.SampleCollectionDate >= @fromdate ");
                    }
                    else
                    {
                        sb.Append(" and PLI.Date >= @fromdate ");
                    }
                }
            }

            if (dtTo != string.Empty)
            {
                if (Status == "Pending")
                {
                    sb.Append(" AND PLI.DeliveryDate <= @todate and pli.Approved=0 ");
                }
                else
                {
                    if (SearchByDate == "Sample Receiving Date")
                    {
                        sb.Append(" and PLI.SampleReceiveDate <= @todate");
                    }
                    else if (SearchByDate == "Approved Date")
                    {
                        sb.Append(" and PLI.ApprovedDate <= @todate");
                    }
                    else if (SearchByDate == "Sample Collection Date")
                    {
                        sb.Append(" and PLI.SampleCollectionDate <= @fromdate ");
                    }
                    else
                    {
                        sb.Append(" and PLI.Date <= @todate ");
                    }
                }
            }
            if (LabNo != string.Empty)
            {
                sb.Append(" and PLI.LedgerTransactionNo = @LabNo");
            }

            if (slidenumber != "")
            {
                sb.Append(" and PLI.slidenumber=@slidenumber");
            }

            if (Status == "Approved")
            {
                sb.Append(" and pli.Approved=1");
            }
            else if (Status == "Not Approved")
            {
                sb.Append(" and pli.Approved=0");
            }
            else if (Status == "Result Done")
            {
                sb.Append(" and pli.Result_Flag=1  and (pli.Approved is null or pli.Approved=0) and isForward=0 and pli.isHold=0  AND pli.isPartial_Result=0  ");
            }
            else if (Status == "Result Not Done")
            {
                sb.Append(" and pli.Result_Flag=0  and pli.`IsSampleCollected` <>'R' ");
            }
            else if (Status == "Incomplete")
            {
                sb.Append(" and pli.Result_Flag='1' AND pli.isPartial_Result='1' and pli.Approved=0 and isForward=0 and pli.isHold=0 ");
            }
            else if (Status == "Forward")
            {
                sb.Append(" and pli.isForward=1 and (pli.Approved is null or pli.Approved=0) and pli.isHold=0 ");
            }
            else if (Status == "Hold")
            {
                sb.Append(" and pli.isHold=1 ");
            }
            else if (Status == "Pending")
            {
                sb.Append(" AND PLI.DeliveryDate >= @fromdate and pli.Approved=0 ");
            }

            if (InvestigationID != "")
            {
                sb.Append(" and pli.Investigation_Id in(" + InvestigationID + ")  ");
            }
            if (isUrgent == "1")
            {
                sb.Append(" and pli.isUrgent=1  ");
            }
            if (rerun == "1")
            {
                sb.Append(" and pli.isrerun=1 ");
            }
            if (CentreID != "")
            {
                sb.Append(" and pli.TestCentreID in(" + CentreID + ") ");
            }

            if (Ptype == "1")
                sb.Append(" and lt.PatientType='Urgent' ");

            sb.Append("       ");

            if (PanelID != "")
            {
                sb.Append(" and lt.panel_ID =@PanelID ");
            }

            sb.Append(" inner join patient_master PM on lt.Patient_ID = PM.Patient_ID  ");
            if (RegNo != string.Empty)
                sb.Append(" and PM.Patient_ID=@RegNo");
            if (PName != string.Empty)
                sb.Append(" and PM.PName like @PName");

            if (PhoneNo.Trim() != "")
                sb.Append(" and PM.Phone =@PhoneNo");

            if (Mobile.Trim() != "")
                sb.Append(" and PM.Mobile = @Mobile");

            switch (colorCode)
            {
                case "1":
                    sb.Append("  AND pli.IsSampleCollected='N'  ");//New
                    break;
                case "2":
                    sb.Append(" AND pli.IsSampleCollected = 'S' ");//Sample Collected
                    break;
                case "3":
                    sb.Append(" AND pli.IsSampleCollected = 'Y' and pli.Result_Flag=0  ");//Department Receive
                    break;
                case "4":
                    sb.Append(" and pli.Result_Flag='0' And (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=pli.LedgerTransactionNO AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 "); //Mac Data
                    break;
                case "5":
                    sb.Append(" and pli.isrerun=1  AND pli.Result_flag=0 "); //Rerun
                    break;
                case "6":
                    sb.Append(" AND  pli.Result_Flag='1' AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='1' AND   pli.Approved='0'   ");//Incomplete
                    break;
                case "7":
                    sb.Append(" AND  pli.Result_Flag=1  and (pli.Approved is null or pli.Approved=0) and isForward=0 and pli.isHold=0  AND pli.isPartial_Result=0 and pli.Preliminary=0 "); //Tested
                    break;
                case "8":
                    sb.Append(" AND   pli.Approved='1' AND pli.isHold='0' and pli.isPrint=0  "); //Approved
                    break;
                case "9":
                    sb.Append(" AND   pli.Approved='1' AND pli.isHold='0' and pli.isPrint=1 and pli.IsFOReceive='0'  "); //Printed
                    break;
                case "10":
                    sb.Append(" AND   pli.isHold='1'   "); //Hold
                    break;
                case "11":
                    sb.Append(" AND  pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='1'  ");//Forward
                    break;
                case "12":
                    sb.Append(" AND  pli.IsFOReceive='1' and pli.IsDispatch='0'  "); //Received
                    break;
                case "13":
                    sb.Append(" AND  pli.IsDispatch='1' AND pli.isFOReceive='1'  "); //Dispatched
                    break;

            }
            sb.Append(" inner join investigation_master im on pli.Investigation_ID = im.Investigation_Id ");
            sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID  ");
            if (wrkst != "")
            {
                sb.Append(" and io.observationtype_id in(" + wrkst + ") ");
            }

            if (macid != "" && macid != "null")
            {
                sb.Append(" inner JOIN investigation_machinemaster imm ON  imm.`Investigation_ID` = pli.`Investigation_ID`  ");
                sb.Append(" and imm.MachineID=@macid ");
            }
            sb.Append(" INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");

            if (macid != "")
            {
                sb.Append(" group by lt.LedgerTransactionNo,im.name ");
            }
            sb.Append(" order by lt.LedgerTransactionNo,obm.Name,im.Print_Sequence ");

            using (DataTable dtItem = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd"), " ", TimeFrm)),
                   new MySqlParameter("@todate", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " ", TimeTo)),
                   new MySqlParameter("@Barcodeno", SinNo.Trim()),
                   new MySqlParameter("@LabNo", LabNo.Trim()),
                   new MySqlParameter("@slidenumber", slidenumber),
                   new MySqlParameter("@macid", macid),
                   new MySqlParameter("@RegNo", RegNo.Trim()),
                   new MySqlParameter("@PName" ,string.Concat("%", PName.Trim(),"%")),
                   new MySqlParameter("@PhoneNo", PhoneNo.Trim()),
                   new MySqlParameter("@Mobile", Mobile.Trim()),
                   new MySqlParameter("@PanelID", PanelID)).Tables[0])
            {
                return dtItem;
            }
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}