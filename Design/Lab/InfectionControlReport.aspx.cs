using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_Lab_InfectionControlReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {

            dtFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            lstCentre.DataSource = StockReports.GetDataTable(Util.GetCentreAccessQuery());
            lstCentre.DataTextField = "Centre";
            lstCentre.DataValueField = "CentreID";
            lstCentre.DataBind();

            bindinvestigation();
        }


    }

    void bindinvestigation()
    {
        chkinv.DataSource = StockReports.GetDataTable(@"select name,investigation_id from investigation_master WHERE  ShowInInfectionControl =1  order by name");
        chkinv.DataTextField = "name";
        chkinv.DataValueField = "investigation_id";
        chkinv.DataBind();
    }



    protected void btngetreport_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";

        string InvestigationID = "";


        foreach (ListItem item in chkinv.Items)
        {
            if (item.Selected == true)
            {
                InvestigationID = InvestigationID + "'" + item.Value + "',";
            }
        }

        InvestigationID = InvestigationID.TrimEnd(',');
        string _CentreList = "";
        foreach (ListItem item in lstCentre.Items)
        {
            if (item.Selected == true)
            {
                _CentreList = _CentreList + "'" + item.Value + "',";
            }
        }
        _CentreList = _CentreList.TrimEnd(',');
        if (InvestigationID == "")
        {
            lblMsg.Text = "Please select Investigation(s)";
            return;

        }

        DateTime dtF = Util.GetDateTime(dtFrom.Text);
        DateTime dtT = Util.GetDateTime(dtToDate.Text);

        //if (dtT.Subtract(dtF).TotalDays > 31)
        //{
        //    lblMsg.Text = "You can't select the date range more than 31 day(s)";
        //    return;
        //}
        StringBuilder sb = new StringBuilder();

      

        if (rdreporttype.Value == "2")
        {
            sb = new StringBuilder();

            sb.Append(@"SELECT BookingDate `REG. DATE`,
                            sampleCollectionDate `SAMPLE REGN DATE`,
                            sampleReceiveDate `SAMPLE COLL DATE`,
                            patient_ID `REGN NO`,
                           SRFNo,Source,
                            LabNo `LAB NO`,
                            BarcodeNo `BARCODE NO`,
                            PName `Patient Name`,
                            Age,
                            Gender,Mobile,
                            DoctorName `REF BY`,
                            PanelName `Panel Name`,
                            InvestigationName `TEST NAME`,
                            TestCode `TEST CODE`,
                            SampleTypeName `SAMPLE TYPE`,
                            VALUE `RESULT`,
                            
                            DeliveryDate `DELEVERY DATE`,
                            dueAmount `DUE AMOUNT`,
                            `Status`,History
                            FROM( ");
            sb.Append(@" SELECT (Case  when pli.Approved=1 then 'Approved' when pli.isHold=1 then 'Hold'  when pli.Result_Flag=1 then 'Result Done'  ELSE 'Result Done' END  ) `Status`,  DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y %h:%i %p') sampleCollectionDate,
                         DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%i %p') sampleReceiveDate,
                         pli.`Patient_ID`, dr.Name DoctorName ,itm.TestCode,pli.SampleTypeName,
                         DATE_FORMAT(pli.DeliveryDate,'%d-%b-%Y %h:%i %p') DeliveryDate,
                         (lt.NetAmount-lt.Adjustment) dueAmount,");
            sb.Append("  (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append("  (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append("  date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.srfno SRFNo,'' Source,");
            sb.Append("  lt.LedgerTransactionNo LabNo,pli.BarcodeNo, Plo.LabObservationName,");
            sb.Append(" pm.PName, pm.Age, pm.Gender,pm.Mobile, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.name InvestigationName,plo.Value,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate, '' History ");
            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(@"  
                          INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID 
                          INNER JOIN doctor_referal dr ON lt.Doctor_ID=dr.Doctor_ID");

            sb.Append(@" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID  
                         INNER JOIN `f_itemmaster` itm ON itm.Type_ID=im.Investigation_ID 
                         INNER JOIN `f_subcategorymaster` scm ON scm.SubCategoryID=itm.SubCategoryID AND scm.CategoryID='LSHHI3' ");


            sb.Append(" INNER JOIN patient_labobservation_opd plo ON plo.Test_ID=pli.Test_ID  ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")   "); // AND pli.Approved=1
            if (ch.Checked)
            {
                sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            }

            sb.Append(" WHERE pli.SampleReceiveDate>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.SampleReceiveDate<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' and pli.isreporting=1 and pli.Result_flag=1 AND im.`IsCulture`=0 ");
            sb.Append(" UNION ALL ");


            sb.Append(@" SELECT ");
            sb.Append(@" (Case  when pli.Approved=1 then 'Approved' when pli.isHold=1 then 'Hold'  when pli.Result_Flag=1 then 'Result Done'  ELSE 'Result Done' END  ) `Status`, DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y %h:%i %p') sampleCollectionDate,
                         DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%i %p') sampleReceiveDate,
                         pli.`Patient_ID`, dr.Name DoctorName ,itm.TestCode,pli.SampleTypeName,
                         DATE_FORMAT(pli.DeliveryDate,'%d-%b-%Y %h:%i %p') DeliveryDate,
                         (lt.NetAmount-lt.Adjustment) dueAmount,");
            sb.Append(" (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append(" (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append(" date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.srfno SRFNo,'' Source,");


            sb.Append(" lt.LedgerTransactionNo LabNo,pli.BarcodeNo, Plo.LabObservation_Name LabObservationName,");

            sb.Append(" pm.PName, pm.Age, pm.Gender,pm.Mobile, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.name InvestigationName ,plo.Value,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate , '' History ");


            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(@" 
                         INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID 
                         INNER JOIN doctor_referal dr ON lt.Doctor_ID=dr.Doctor_ID");

            sb.Append(@" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID  
                         INNER JOIN `f_itemmaster` itm ON itm.Type_ID=im.Investigation_ID 
                         INNER JOIN `f_subcategorymaster` scm ON scm.SubCategoryID=itm.SubCategoryID AND scm.CategoryID='LSHHI3' ");

            sb.Append(" INNER JOIN patient_labobservation_opd_mic plo ON plo.TestID=pli.Test_ID  AND plo.`LabObservation_ID`='LSHHI262' ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")  "); //AND pli.Approved=1
            if (ch.Checked)
            {
                sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            }

            sb.Append(" WHERE pli.SampleReceiveDate>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.SampleReceiveDate<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' and pli.isreporting=1 and pli.Result_flag=1 AND im.`IsCulture`=1 )t");

            sb.Append(" ORDER BY t.ResultEnteredDate,t.LabNo,t.InvestigationName");
        }
        else if (rdreporttype.Value == "3")
        {

            sb = new StringBuilder();
            // VALUE `RESULT`,
            sb.Append(@"SELECT BookingDate `REG. DATE`,
                            sampleCollectionDate `SAMPLE REGN DATE`,
                            sampleReceiveDate `SAMPLE COLL DATE`,
                            patient_ID `REGN NO`,
                            SRFNo,Source,
                            LabNo `LAB NO`,
                            BarcodeNo `BARCODE NO`,
                            PName `Patient Name`,
                            Age,
                            Gender,Mobile,
                            DoctorName `REF BY`,
                            PanelName `Panel Name`,
                            InvestigationName `TEST NAME`,
                            TestCode `TEST CODE`,
                            SampleTypeName `SAMPLE TYPE`,
                           
                            DeliveryDate `DELEVERY DATE`,
                            dueAmount `DUE AMOUNT`,
                            `Status`,
                            IF(DocCount>0,'YES', 'NO') `Doc Attached`, History
                            FROM( ");
            sb.Append(@" SELECT (Case  when pli.Approved=1 then 'Approved' when pli.isHold=1 then 'Hold'  when pli.Result_Flag=1 then 'Result Done' when pli.Result_Flag=0 AND pli.IsSampleCollected='Y' THEN 'Sample Received' when pli.Result_Flag=0 AND pli.IsSampleCollected='N' THEN 'Wokr Order Done' when pli.Result_Flag=0 AND pli.IsSampleCollected='S' THEN 'Sample Collected' when  pli.IsSampleCollected='R' THEN 'Sample Rejected'  ELSE '' END  ) `Status`, IF(pli.IsSampleCollected!='N',DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y %h:%i %p'),'') sampleCollectionDate,
                         IF(pli.IsSampleCollected!='N',DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%i %p'),'') sampleReceiveDate,
                         pli.`Patient_ID`, dr.Name DoctorName ,itm.TestCode,pli.SampleTypeName,
                         DATE_FORMAT(pli.DeliveryDate,'%d-%b-%Y %h:%i %p') DeliveryDate,
                         (lt.NetAmount-lt.Adjustment) dueAmount,");
            sb.Append("  (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append("  (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append("  date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.srfno SRFNo,'' Source,");
            sb.Append("  lt.LedgerTransactionNo LabNo,pli.BarcodeNo, '' LabObservationName,");
            sb.Append(" pm.PName, pm.Age, pm.Gender,pm.Mobile, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.name InvestigationName,'' Value,IF(pli.Result_Flag=1,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p'),'') ResultEnteredDate, '' History, ");
            sb.Append(" (Select Count(1) from patient_labinvestigation_attachment where Test_ID=pli.Test_ID) DocCount   ");
            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(@"   
                          INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID 
                          INNER JOIN doctor_referal dr ON lt.Doctor_ID=dr.Doctor_ID");

            sb.Append(@" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID  
                         INNER JOIN `f_itemmaster` itm ON itm.Type_ID=im.Investigation_ID 
                         INNER JOIN `f_subcategorymaster` scm ON scm.SubCategoryID=itm.SubCategoryID AND scm.CategoryID='LSHHI3' ");


            // sb.Append(" INNER JOIN patient_labobservation_opd plo ON plo.Test_ID=pli.Test_ID  ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")   ");
            //if (ch.Checked)
            //{
            //    sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            //}

            sb.Append(" WHERE pli.date>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "' AND pli.date<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + "' and pli.isreporting=1  AND im.`IsCulture`=0 "); //and pli.Result_flag=1
            sb.Append(" UNION ALL ");


            sb.Append(@" SELECT ");
            sb.Append(@" (Case  when pli.Approved=1 then 'Approved' when pli.isHold=1 then 'Hold'  when pli.Result_Flag=1 then 'Result Done' when pli.Result_Flag=0 AND pli.IsSampleCollected='Y' THEN 'Sample Received' when pli.Result_Flag=0 AND pli.IsSampleCollected='N' THEN 'Wokr Order Done' when pli.Result_Flag=0 AND pli.IsSampleCollected='S' THEN 'Sample Collected' when  pli.IsSampleCollected='R' THEN 'Sample Rejected'  ELSE '' END  ) `Status`, IF(pli.IsSampleCollected!='N',DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y %h:%i %p'),'') sampleCollectionDate,
                         IF(pli.IsSampleCollected!='N',DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%i %p'),'') sampleReceiveDate,
                         pli.`Patient_ID`, dr.Name DoctorName ,itm.TestCode,pli.SampleTypeName,
                         DATE_FORMAT(pli.DeliveryDate,'%d-%b-%Y %h:%i %p') DeliveryDate,
                         (lt.NetAmount-lt.Adjustment) dueAmount,");
            sb.Append(" (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append(" (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append(" date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.srfno SRFNo,'' Source,");


            sb.Append(" lt.LedgerTransactionNo LabNo,pli.BarcodeNo, '' LabObservationName,");

            sb.Append(" pm.PName, pm.Age, pm.Gender,pm.Mobile, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.name InvestigationName ,'' Value,IF(pli.Result_Flag=1,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p'),'')  ResultEnteredDate, '' History  ");
            sb.Append(", (Select Count(1) from patient_labinvestigation_attachment where Test_ID=pli.Test_ID) DocCount   ");

            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(@" 
                         INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID 
                         INNER JOIN doctor_referal dr ON lt.Doctor_ID=dr.Doctor_ID");

            sb.Append(@" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID  
                         INNER JOIN `f_itemmaster` itm ON itm.Type_ID=im.Investigation_ID 
                         INNER JOIN `f_subcategorymaster` scm ON scm.SubCategoryID=itm.SubCategoryID AND scm.CategoryID='LSHHI3' ");

            //sb.Append(" INNER JOIN patient_labobservation_opd_mic plo ON plo.TestID=pli.Test_ID  AND plo.`LabObservation_ID`='LSHHI262' ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")  ");
            //if (ch.Checked)
            //{
            //    sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            //}

            sb.Append(" WHERE pli.date>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "' AND pli.date<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + "' and pli.isreporting=1 and  im.`IsCulture`=1 )t"); //pli.Result_flag=1 AND

            sb.Append(" ORDER BY t.BookingDate,t.LabNo,t.InvestigationName");


        }

        else if (rdreporttype.Value == "4")
        {
            sb = new StringBuilder();

            sb.Append(@"SELECT BookingDate `REG. DATE`,
                            sampleCollectionDate `SAMPLE REGN DATE`,
                            sampleReceiveDate `SAMPLE COLL DATE`,
                            patient_ID `REGN NO`,
                           SRFNo,Source,
                            LabNo `LAB NO`,
                            BarcodeNo `BARCODE NO`,
                            PName `Patient Name`,
                            Age,
                            Gender,Mobile,
                            DoctorName `REF BY`,
                            PanelName `Panel Name`,
                            InvestigationName `TEST NAME`,
                            TestCode `TEST CODE`,
                            SampleTypeName `SAMPLE TYPE`,
                            VALUE `RESULT`,
                            
                            DeliveryDate `DELEVERY DATE`,
                            dueAmount `DUE AMOUNT`,
                            `Status`,History
                            FROM( ");
            sb.Append(@" SELECT (Case  when pli.Approved=1 then 'Approved' when pli.isHold=1 then 'Hold'  when pli.Result_Flag=1 then 'Result Done'  ELSE 'Result Done' END  ) `Status`,  DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y %h:%i %p') sampleCollectionDate,
                         DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%i %p') sampleReceiveDate,
                         pli.`Patient_ID`, dr.Name DoctorName ,itm.TestCode,pli.SampleTypeName,
                         DATE_FORMAT(pli.DeliveryDate,'%d-%b-%Y %h:%i %p') DeliveryDate,
                         (lt.NetAmount-lt.Adjustment) dueAmount,");
            sb.Append("  (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append("  (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append("  date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.srfno SRFNo,'' Source,");
            sb.Append("  lt.LedgerTransactionNo LabNo,pli.BarcodeNo, Plo.LabObservationName,");
            sb.Append(" pm.PName, pm.Age, pm.Gender,pm.Mobile, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.name InvestigationName,plo.Value,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate,'' History ");
            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(@"   
                          INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID 
                          INNER JOIN doctor_referal dr ON lt.Doctor_ID=dr.Doctor_ID");

            sb.Append(@" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID  
                         INNER JOIN `f_itemmaster` itm ON itm.Type_ID=im.Investigation_ID 
                         INNER JOIN `f_subcategorymaster` scm ON scm.SubCategoryID=itm.SubCategoryID AND scm.CategoryID='LSHHI3' ");


            sb.Append(" INNER JOIN patient_labobservation_opd plo ON plo.Test_ID=pli.Test_ID  ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")   "); // AND pli.Approved=1
            if (ch.Checked)
            {
                sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            }

            sb.Append(" WHERE pli.date>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "' AND pli.date<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + "' and pli.isreporting=1 and  im.`IsCulture`=0 "); //pli.Result_flag=1 AND
            sb.Append(" UNION ALL ");
            sb.Append(@" SELECT ");
            sb.Append(@" (Case  when pli.Approved=1 then 'Approved' when pli.isHold=1 then 'Hold'  when pli.Result_Flag=1 then 'Result Done'  ELSE 'Result Done' END  ) `Status`, DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y %h:%i %p') sampleCollectionDate,
                         DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%i %p') sampleReceiveDate,
                         pli.`Patient_ID`, dr.Name DoctorName ,itm.TestCode,pli.SampleTypeName,
                         DATE_FORMAT(pli.DeliveryDate,'%d-%b-%Y %h:%i %p') DeliveryDate,
                         (lt.NetAmount-lt.Adjustment) dueAmount,");
            sb.Append(" (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append(" (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append(" date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.srfno SRFNo,'' Source,");


            sb.Append(" lt.LedgerTransactionNo LabNo,pli.BarcodeNo, Plo.LabObservation_Name LabObservationName,");

            sb.Append(" pm.PName, pm.Age, pm.Gender,pm.Mobile, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.name InvestigationName ,plo.Value,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate, '' History  ");


            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(@"  
                         INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID 
                         INNER JOIN doctor_referal dr ON lt.Doctor_ID=dr.Doctor_ID");

            sb.Append(@" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID  
                         INNER JOIN `f_itemmaster` itm ON itm.Type_ID=im.Investigation_ID 
                         INNER JOIN `f_subcategorymaster` scm ON scm.SubCategoryID=itm.SubCategoryID AND scm.CategoryID='LSHHI3' ");

            sb.Append(" INNER JOIN patient_labobservation_opd_mic plo ON plo.TestID=pli.Test_ID  AND plo.`LabObservation_ID`='LSHHI262' ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")  "); //AND pli.Approved=1
            if (ch.Checked)
            {
                sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            }

            sb.Append(" WHERE pli.date>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "' AND pli.date<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + "' and pli.isreporting=1  AND im.`IsCulture`=1 )t"); //and pli.Result_flag=1

            sb.Append(" ORDER BY t.BookingDate,t.LabNo,t.InvestigationName");
        }
		else if(rdreporttype.Value == "5")
        {
            sb = new StringBuilder();

            sb.Append(@"SELECT BookingDate `REG. DATE`,
                            sampleCollectionDate `SAMPLE REGN DATE`,
                            sampleReceiveDate `SAMPLE COLL DATE`,
                            patient_ID `REGN NO`,
                           SRFNo,Source,
                            LabNo `LAB NO`,
                            BarcodeNo `BARCODE NO`,
                            PName `Patient Name`,
                            Age,
                            Gender,Mobile,
                            DoctorName `REF BY`,
                            PanelName `Panel Name`,
                            InvestigationName `TEST NAME`,
                            TestCode `TEST CODE`,
                            SampleTypeName `SAMPLE TYPE`,
                            VALUE `RESULT`,
                            
                            DeliveryDate `DELEVERY DATE`,
                            dueAmount `DUE AMOUNT`,
                            `Status`,History
                            FROM( ");
            sb.Append(@" SELECT (Case  when pli.Approved=1 then 'Approved' when pli.isHold=1 then 'Hold'  when pli.Result_Flag=1 then 'Result Done'  ELSE 'Result Done' END  ) `Status`,  DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y %h:%i %p') sampleCollectionDate,
                         DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%i %p') sampleReceiveDate,
                         pli.`Patient_ID`, dr.Name DoctorName ,itm.TestCode,pli.SampleTypeName,
                         DATE_FORMAT(pli.DeliveryDate,'%d-%b-%Y %h:%i %p') DeliveryDate,
                         (lt.NetAmount-lt.Adjustment) dueAmount,");
            sb.Append("  (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append("  (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append("  date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.srfno SRFNo,'' Source,");
            sb.Append("  lt.LedgerTransactionNo LabNo,pli.BarcodeNo, Plo.LabObservationName,");
            sb.Append(" pm.PName, pm.Age, pm.Gender,pm.Mobile, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.name InvestigationName,plo.Value,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate,'' History ");
            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(@"   
                          INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID 
                          INNER JOIN doctor_referal dr ON lt.Doctor_ID=dr.Doctor_ID");

            sb.Append(@" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID  
                         INNER JOIN `f_itemmaster` itm ON itm.Type_ID=im.Investigation_ID 
                         INNER JOIN `f_subcategorymaster` scm ON scm.SubCategoryID=itm.SubCategoryID AND scm.CategoryID='LSHHI3' ");


            sb.Append(" INNER JOIN patient_labobservation_opd plo ON plo.Test_ID=pli.Test_ID  ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")   "); // AND pli.Approved=1
            if (ch.Checked)
            {
                sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            }

            sb.Append(" WHERE pli.ApprovedDate>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.ApprovedDate<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' and pli.isreporting=1 and  im.`IsCulture`=0 "); //pli.Result_flag=1 AND
            sb.Append(" UNION ALL ");
            sb.Append(@" SELECT ");
            sb.Append(@" (Case  when pli.Approved=1 then 'Approved' when pli.isHold=1 then 'Hold'  when pli.Result_Flag=1 then 'Result Done'  ELSE 'Result Done' END  ) `Status`, DATE_FORMAT(pli.SampleCollectionDate,'%d-%b-%Y %h:%i %p') sampleCollectionDate,
                         DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %h:%i %p') sampleReceiveDate,
                         pli.`Patient_ID`, dr.Name DoctorName ,itm.TestCode,pli.SampleTypeName,
                         DATE_FORMAT(pli.DeliveryDate,'%d-%b-%Y %h:%i %p') DeliveryDate,
                         (lt.NetAmount-lt.Adjustment) dueAmount,");
            sb.Append(" (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append(" (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append(" date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,lt.srfno SRFNo,'' Source,");


            sb.Append(" lt.LedgerTransactionNo LabNo,pli.BarcodeNo, Plo.LabObservation_Name LabObservationName,");

            sb.Append(" pm.PName, pm.Age, pm.Gender,pm.Mobile, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.name InvestigationName ,plo.Value,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate,'' History  ");


            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(@" 
                         INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID 
                         INNER JOIN doctor_referal dr ON lt.Doctor_ID=dr.Doctor_ID");

            sb.Append(@" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID  
                         INNER JOIN `f_itemmaster` itm ON itm.Type_ID=im.Investigation_ID 
                         INNER JOIN `f_subcategorymaster` scm ON scm.SubCategoryID=itm.SubCategoryID AND scm.CategoryID='LSHHI3' ");

            sb.Append(" INNER JOIN patient_labobservation_opd_mic plo ON plo.TestID=pli.Test_ID  AND plo.`LabObservation_ID`='LSHHI262' ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")  "); //AND pli.Approved=1
            if (ch.Checked)
            {
                sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            }

            sb.Append(" WHERE pli.ApprovedDate>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.ApprovedDate<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' and pli.isreporting=1  AND im.`IsCulture`=1 )t"); //and pli.Result_flag=1

            sb.Append(" ORDER BY t.BookingDate,t.LabNo,t.InvestigationName");
        }
        if (rdreporttype.Value == "1" || rdreporttype.Value == "0")
        {
            sb = new StringBuilder();
            if (rdreporttype.Value == "1")
            {
                sb.Append("SELECT BookingCentre,TestCentre,BookingDate,LabNo,BarcodeNo,PatientName,Mobile,Address,Age,Gender,PanelName,Investigation_id,InvestigationName,ResultEnteredDate,ApprovedDate,LabObservationName,VALUE,History FROM( ");
            }
            else
            {
                sb.Append("SELECT BookingCentre,TestCentre,BookingDate,LabNo,UHID,PatientName,Age,Gender,PanelName,Investigation_id,InvestigationName,ResultEnteredDate,ApprovedDate,LabObservationName,VALUE FROM( ");
            }

            sb.Append(" SELECT (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append(" (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append(" date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,");

            if (rdreporttype.Value == "1")
            {
                sb.Append(" '' History, lt.LedgerTransactionNo LabNo,pli.BarcodeNo, pm.PName PatientName, pm.Mobile  , pm.House_No Address,");
            }
            else
                sb.Append(" lt.LedgerTransactionNo LabNo,pli.BarcodeNo UHID, Concat(pm.PName,'/',pm.Mobile,'/',pm.House_No) PatientName,");

            sb.Append(" pm.Age, pm.Gender, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.Investigation_id,im.name InvestigationName,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate, ");
            sb.Append("  date_format(pli.ApprovedDate,'%d-%b-%Y %h:%i %p')ApprovedDate,Plo.LabObservationName,plo.Value  ");


            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(" INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID  ");
            sb.Append(" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID ");
            sb.Append(" INNER JOIN patient_labobservation_opd plo ON plo.Test_ID=pli.Test_ID  ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ")  AND pli.Approved=1 ");
            if (ch.Checked)
            {
                sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            }

            sb.Append(" WHERE pli.SampleReceiveDate>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.SampleReceiveDate<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' and pli.isreporting=1 and pli.Result_flag=1 AND im.`IsCulture`=0 ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT (select centre from centre_master where centreid=lt.centreid)BookingCentre, ");
            sb.Append(" (select centre from centre_master where centreid=pli.testcentreID)TestCentre, ");
            sb.Append(" date_format(lt.Date,'%d-%b-%Y %h:%i %p') BookingDate ,");

            if (rdreporttype.Value == "1")
            {
                sb.Append(" '' History, lt.LedgerTransactionNo LabNo,pli.BarcodeNo, pm.PName PatientName, pm.Mobile  , pm.House_No Address,");
            }
            else
                sb.Append(" lt.LedgerTransactionNo LabNo,pli.BarcodeNo UHID, Concat(pm.PName,'/',pm.Mobile,'/',pm.House_No) PatientName,");

            sb.Append(" pm.Age, pm.Gender, (SELECT Company_Name from f_panel_master where Panel_ID=lt.Panel_ID) PanelName,");
            sb.Append(" im.Investigation_id,im.name InvestigationName,date_format(pli.ResultEnteredDate,'%d-%b-%Y %h:%i %p') ResultEnteredDate, ");
            sb.Append("  date_format(pli.ApprovedDate,'%d-%b-%Y %h:%i %p')ApprovedDate,Plo.LabObservation_Name LabObservationName,plo.Value  ");


            sb.Append(" FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            if (_CentreList != "")
            {
                sb.AppendLine(" AND lt.CentreID IN (" + _CentreList + ")    ");
            }
            sb.Append(" INNER JOIN patient_Master pm ON pm.Patient_ID=lt.Patient_ID  ");
            sb.Append(" INNER JOIN investigation_master im ON im.Investigation_ID=pli.Investigation_ID ");
            sb.Append(" INNER JOIN patient_labobservation_opd_mic plo ON plo.TestID=pli.Test_ID  AND plo.`LabObservation_ID`='LSHHI262' ");

            sb.Append(" AND pli.Investigation_ID IN (" + InvestigationID + ") AND pli.Approved=1 ");
            if (ch.Checked)
            {
                sb.Append(" and upper(plo.value) in ('REACTIVE','POSITIVE')");
            }

            sb.Append(" WHERE pli.SampleReceiveDate>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' AND pli.SampleReceiveDate<='" + Util.GetDateTime(dtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' and pli.isreporting=1 and pli.Result_flag=1 AND im.`IsCulture`=1 )t");

            sb.Append(" ORDER BY t.ResultEnteredDate,t.LabNo,t.InvestigationName");

        }


       // System.IO.File.WriteAllText(@"C:\Sonu.txt", sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {

            lblMsg.Text = dt.Rows.Count + " Record Found..!";
            if (rdreporttype.Value == "0")
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = " From : " + dtFrom.Text + " To : " + dtToDate.Text;
                dt.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                Session["ds"] = ds;
                //ds.WriteXmlSchema(@"D:\PostitiveValuereport.xml"); 
                Session["ReportName"] = "PostitiveValuereport";



                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);

            }
            else
            {
                //Session["ReportName"] = "Infection Report";
                //Session["Period"] = "Period From : " + dtFrom.Text + " To : " + dtToDate.Text;
                //Session["dtExport2Excel"] = dt;
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);


                string attachment = "attachment; filename=Infection Report.xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/vnd.ms-excel";
                string tab = "";
                foreach (DataColumn dc in dt.Columns)
                {
                    Response.Write(tab + dc.ColumnName);
                    tab = "\t";
                }
                Response.Write("\n");
                int i;
                foreach (DataRow dr in dt.Rows)
                {
                    tab = "";
                    for (i = 0; i < dt.Columns.Count; i++)
                    {
                        Response.Write(tab + dr[i].ToString());
                        tab = "\t";
                    }
                    Response.Write("\n");
                }
                Response.End();
            }
        }
        else
        {
            lblMsg.Text = "No Record Found..!";

            return;
        }

    }

    public void CovidTestReport()
    {

    }
}