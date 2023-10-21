using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_ServiceWiseCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            // BindCenter();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;

            ddlItem.DataSource = StockReports.GetDataTable("SELECT itemid,CONCAT(testcode,'~',typename)itemname FROM f_itemmaster ORDER BY itemname ");
            ddlItem.DataValueField = "itemid";
            ddlItem.DataTextField = "itemname";
            ddlItem.DataBind();
            bindCheckBox();

        }
        
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    public class colectionReport
    {
        public string ID { get; set; }
        public string ColumnName { get; set; }
        public string ColumnValue { get; set; }
        public int IsDefault { get; set; }
    }

    public void bindCheckBox()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT CONCAT(ID,'#',IsDefault)ID,ColumnName,ColumnValue,IsDefault FROM ServiceWiseCollectionReport_Column WHERE IsActive=1"))
        {
            var aaa = dt.Columns["ID"].DataType;
            List<colectionReport> CollectionList = dt.AsEnumerable().Select(i => new colectionReport
            {
                ID = i.Field<string>("ID"),
                ColumnName = i.Field<string>("ColumnName"),
                ColumnValue = i.Field<string>("ColumnValue")
            }).ToList();
            if (Session["RoleID"].ToString() == "6" || Session["RoleID"].ToString() == "177" || Session["RoleID"].ToString() == "250")
            {
                CollectionList.Add(new colectionReport { ID = "200#0", ColumnName = "MobileNumber", ColumnValue = "pm.Mobile MobileNumber" });
                CollectionList.Add(new colectionReport { ID = "201#0", ColumnName = "MailId", ColumnValue = "pm.Email MailId" });
            }
            if (dt.Rows.Count > 0)
            {
                chkDetail.DataSource = CollectionList;
                chkDetail.DataTextField = "ColumnName";
                chkDetail.DataValueField = "ID";
                chkDetail.DataBind();
                foreach (ListItem li in chkDetail.Items.Cast<ListItem>())
                {
                    li.Attributes.Add("class", "chk");
                    if (li.Value.Split('#')[1] == "1")
                    {
                        li.Attributes.Add("class", "chk chkDefault");
                        li.Selected = true;
                    }
                }
            }
        }
    }
    public void BindCenter()
    {
        string str = string.Empty;
        if (UserInfo.Centre == 1)
        {
            str = " SELECT cm.CentreID,cm.Centre FROM centre_master cm  ";
        }
        else
        {
            str = " SELECT DISTINCT cm.CentreID,cm.Centre FROM centre_master cm INNER JOIN f_login fl ON fl.`CentreID`=cm.`CentreID` AND fl.`EmployeeID`='" + UserInfo.ID + "'  ";
        }

        DataTable dt = StockReports.GetDataTable(str);
    }

    [WebMethod]
    public static string getReport(string dtFrom, string dtTo, string BillNo, string CentreID, string isPreBooking)
    {
        string retValue = "0";

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT  if(fpm.paneltype<>'Centre',fpm.paneltype,if(cm.type1='PCC',concat(cm.type1,'-',cm.coco_foco),cm.type1)) BusinessType, cm.CentreID LOCATIONID, lt.BillNo BILLNO,lt.OtherLabRefNo,IF(pm.`Pincode`=0,'',pm.`Pincode`)Pincode,plo.Patient_ID UHID,lt.PName PATIENTNAME,lt.Age,lt.`Gender`,lt.Creator_UserID EmployeeID,");
        sb.Append(" DATE_FORMAT(lt.Date,'%d-%b-%Y') billdate,DATE_FORMAT(lt.Date,'%d-%b-%Y %I%:%i%p') OpenDate,lt.Doctor_ID DoctorID,");
        sb.Append(" IF(lt.`Doctor_ID`='2',lt.`OtherDoctorName`,IF(lt.Doctor_ID=1,dr.Name,CONCAT(dr.Title,' ',dr.Name)))REFERALDOCTOR, ");
        sb.Append(" IF(lt.`Doctor_ID`='2','',IF(lt.Doctor_ID=1,'',IFNULL(dr.Specialization,'')))Speciality,''SpecialityID,");
        // sb.Append(" IF(lt.`Doctor_ID`='2',lt.`OtherDoctorName`,IF(lt.Doctor_ID=1,dr.Name,CONCAT(dr.Title,' ',dr.Name)))REFERALDOCTOR,");
        sb.Append(" IF(lt.IsCredit=1,'Credit','Cash')BILLINGTYPE,im.TestCode serviceid,im.TypeName SERVICENAME,'Diagnosis' Servicetype,''ChargeHead, ''AGREEMENTID,'' AGREEMENTNAME,");
        sb.Append(" cm.CentreCode CUSTOMERID,cm2.Centre TaggedLabName, ");
        sb.Append(" cm.`BusinessZoneName`,cm.`State`,cm.`City`,cm.`Locality`,IF(fpm.`PanelType`='PUP','Yes','No')IsPUP,lt.`PanelName` `PCC/PUP Name`, ");
        sb.Append(" ''PARENTDEPARTMENT,plo.SubCategoryID Deptid,scm.`Name` DEPARTMENT, ");
        sb.Append("  (plo.Rate*plo.Quantity) ServiceGrossAmt,lt.CreatorName USERNAME,plo.DiscountAmt DiscountAmt,plo.Amount NetAmt, ");
        sb.Append(" (plo.CouponAmt*plo.Quantity) CouponAmt,");
        sb.Append(" ''PrimaryPayerId,''RetailCorpFlag,IF(cm.type1='PCC',concat(cm.type1,'-',cm.`COCO_FOCO`),cm.type1) `Type`,''PackageCategory,lt.HLMOPDIPDNo referencenumber,IF(lt.HLMPatientType='IPD','IP','OP') OPIPFlag,");
        sb.Append(" ''ServiceTypeId,IF(lt.IsCancel=1,'DeActive','Active')`Status`, ");
        sb.Append(" IF(lt.IsCancel=1,'Y','N')DelFlag,''BedType,''NICU,cm.Centre PCCName,IF(lt.VisitType='Home Collection','Yes','No') HomeCollection, IF(plo.IsPackage=1, im.TypeName,'')PackageName,lt.PatientSource,");
        sb.Append(" IF(plo.IsPackage=1 ,(plo.Rate*plo.Quantity),'0')PackageCost,  IF(plo.IsPackage=1, im.TestCode,'')PackageId, ");
        sb.Append(" ''SpecialityInDP,''TypeInDP, ''DoctorCategoryInDP,'Laboratory'PatientDept,'Itdose' SFlag, ");
        sb.Append(" DATE_FORMAT(lt.Date,'%d-%b-%Y %I%:%i%p') CreatedDate,IF(lt.Updatedate='0000-00-00 00:00:00','',DATE_FORMAT(lt.Updatedate,'%d-%b-%Y')) updateddate,fpm.Payment_mode,lt.PreBookingID,if(plo.CouponAmt>0,lt.ApolloCouponCode,'') CouponCode,if(plo.CouponAmt>0,lt.ApolloCouponName,'') CouponName,if(plo.CouponAmt>0,lt.ApolloCouponID,'') CouponID,lt.BPLCardNumber ");
        sb.Append(" ,lt.DiscountReason,'5101105' GLCode,'Income from Diagnosis services' GLName FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo AND plo.rate <>0 ");
        sb.Append(" AND lt.Date>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND lt.Date<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" AND lt.CentreID IN (" + CentreID.TrimEnd(',') + " ) ");
        if (isPreBooking == "1")
            sb.Append(" and lt.PreBookingID > 0");

        if (BillNo.Trim() != "")
            sb.Append("     AND lt.BillNo='" + BillNo.Trim() + "'");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemId  INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=plo.`SubCategoryID` INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
        sb.Append(" INNER JOIN centre_master cm2 ON fpm.`TagProcessingLabID`=cm2.CentreID ");


        // sb.Append(" ORDER BY lt.Date ");
        sb.Append(" UNION ALL ");
        sb.Append("  SELECT   if(fpm.paneltype<>'Centre',fpm.paneltype,if(cm.type1='PCC',concat(cm.type1,'-',cm.coco_foco),cm.type1)) BusinessType,cm.CentreID LOCATIONID, lt.BillNo BILLNO,lt.OtherLabRefNo,IF(pm.`Pincode`=0,'',pm.`Pincode`)Pincode,plo.Patient_ID UHID,lt.PName PATIENTNAME,lt.Age,lt.`Gender`,lt.Creator_UserID EmployeeID,");
        sb.Append(" DATE_FORMAT(lt.Date,'%d-%b-%Y') billdate,DATE_FORMAT(lt.Date,'%d-%b-%Y %I%:%i%p') OpenDate,lt.Doctor_ID DoctorID,");
        sb.Append(" IF(lt.`Doctor_ID`='2',lt.`OtherDoctorName`,IF(lt.Doctor_ID=1,dr.Name,CONCAT(dr.Title,' ',dr.Name)))REFERALDOCTOR, ");
        sb.Append(" IF(lt.`Doctor_ID`='2','',IF(lt.Doctor_ID=1,'',IFNULL(dr.Specialization,'')))Speciality,''SpecialityID,");
        //sb.Append(" IF(lt.`Doctor_ID`='2',lt.`OtherDoctorName`,IF(lt.Doctor_ID=1,dr.Name,CONCAT(dr.Title,' ',dr.Name)))REFERALDOCTOR,");
        sb.Append(" IF(lt.IsCredit=1,'Credit','Cash')BILLINGTYPE,im.TestCode serviceid,im.TypeName SERVICENAME,'Diagnosis' Servicetype,''ChargeHead, ''AGREEMENTID,'' AGREEMENTNAME,");
        sb.Append(" cm.CentreCode CUSTOMERID,cm2.Centre TaggedLabName,  ");
        sb.Append(" cm.`BusinessZoneName`,cm.`State`,cm.`City`,cm.`Locality`,IF(fpm.`PanelType`='PUP','Yes','No')IsPUP,lt.`PanelName` `PCC/PUP Name`, ");
        sb.Append(" ''PARENTDEPARTMENT,plo.SubCategoryID Deptid,scm.`Name` DEPARTMENT, ");
        sb.Append("  (plo.Rate*plo.Quantity) ServiceGrossAmt,lt.CreatorName USERNAME,plo.DiscountAmt DiscountAmt,plo.Amount NetAmt, ");
        sb.Append(" (plo.CouponAmt*plo.Quantity) CouponAmt,");
        sb.Append(" ''PrimaryPayerId,''RetailCorpFlag,IF(cm.type1='PCC',concat(cm.type1,'-',cm.`COCO_FOCO`),cm.type1) `Type`,''PackageCategory,lt.HLMOPDIPDNo referencenumber,IF(lt.HLMPatientType='IPD','IP','OP') OPIPFlag,");
        sb.Append(" ''ServiceTypeId,IF(lt.IsCancel=1,'DeActive','Active')`Status`, ");
        sb.Append(" IF(lt.IsCancel=1,'Y','N')DelFlag,''BedType,''NICU,cm.Centre PCCName,IF(lt.VisitType='Home Collection','Yes','No') HomeCollection, IF(plo.IsPackage=1, im.TypeName,'')PackageName,lt.PatientSource,");
        sb.Append(" IF(plo.IsPackage=1 ,(plo.Rate*plo.Quantity),'0')PackageCost,  IF(plo.IsPackage=1, im.TestCode,'')PackageId, ");
        sb.Append(" ''SpecialityInDP,''TypeInDP, ''DoctorCategoryInDP,'Laboratory'PatientDept,'Itdose' SFlag, ");
        sb.Append(" DATE_FORMAT(lt.Date,'%d-%b-%Y %I%:%i%p') CreatedDate,IF(lt.Updatedate='0000-00-00 00:00:00','',DATE_FORMAT(lt.Updatedate,'%d-%b-%Y')) updateddate,fpm.Payment_mode,lt.PreBookingID,if(plo.CouponAmt>0,lt.ApolloCouponCode,'') CouponCode,if(plo.CouponAmt>0,lt.ApolloCouponName,'') CouponName,if(plo.CouponAmt>0,lt.ApolloCouponID,'') CouponID,lt.BPLCardNumber ");
        sb.Append(" ,lt.DiscountReason,'5101105' GLCode,'Income from Diagnosis services' GLName FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo AND plo.rate <>0 ");
        sb.Append(" AND lt.Date>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" AND lt.Date<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (isPreBooking == "1")
            sb.Append(" and lt.PreBookingID > 0");

        if (BillNo.Trim() != "")
            sb.Append("     AND lt.BillNo='" + BillNo.Trim() + "'");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemId  INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=plo.`SubCategoryID` INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID`  AND fpm.`PanelType`='camp' ");
        sb.Append(" INNER JOIN centre_master cm2 ON fpm.`TagProcessingLabID`=cm2.CentreID ");
        sb.Append(" INNER JOIN  centre_panel cpl ON cpl.`PanelId`=fpm.`Panel_ID` AND cpl.`isActive`=1 AND cpl.CentreID IN (" + CentreID.TrimEnd(',') + " ) ");
        sb.Append(" ORDER BY OpenDate ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataTable dtIncremented = new DataTable(dt.TableName);
            DataColumn dc = new DataColumn("ID");
            dc.AutoIncrement = true;
            dc.AutoIncrementSeed = 1;
            dc.AutoIncrementStep = 1;
            dc.DataType = System.Type.GetType("System.Int32");
            dtIncremented.Columns.Add(dc);
            dtIncremented.BeginLoadData();
            DataTableReader dtReader = new DataTableReader(dt);
            dtIncremented.Load(dtReader);
            dtIncremented.EndLoadData();
            dtIncremented.AcceptChanges();
            if (dt != null && dt.Rows.Count > 0)
            {
                //HttpContext.Current.Session["dtExport2Excel"] = dt;
                //HttpContext.Current.Session["ReportName"] = "Service Wise Collection Report";
                //HttpContext.Current.Session["Period"] = "From : " + dateFrom.ToString("dd-MMM-yyyy") + " To : " + dateTo.ToString("dd-MMM-yyyy");


                retValue = "1";
            }
        }
        return retValue;
    }

    [WebMethod]
    public static string bindCentreLoad(string BusinessZoneID, string StateID, string CityID)
    {
        BusinessZoneID = BusinessZoneID.TrimEnd(',');
        StateID = StateID.TrimEnd(',');
        CityID = CityID.TrimEnd(',');
        StringBuilder sb = new StringBuilder();
        if (UserInfo.Centre == 1)
        {
            sb.Append(" SELECT CentreID,Centre FROM centre_master cm  WHERE cm.IsActive=1");
        }
        else
        {
            sb.Append(" SELECT DISTINCT cm.CentreID,cm.Centre FROM centre_master cm  ");
            sb.Append(" INNER JOIN f_login fl ON fl.`CentreID`=cm.`CentreID` AND fl.`EmployeeID`='" + UserInfo.ID + "'");
        }
        if (BusinessZoneID != "0" && BusinessZoneID != "-1")
            sb.Append(" AND cm.BusinessZoneID in(" + BusinessZoneID + ") ");
        if (StateID != "0" && StateID != "-1")
            sb.Append(" AND cm.StateID in (" + StateID + ") ");
        if (CityID != "0" && CityID != "-1")
            sb.Append(" AND cm.CityID in (" + CityID + " )");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }


    protected void btnReport_Click(object sender, EventArgs e)
    {
        try
        {

            DateTime dateFrom = Convert.ToDateTime(txtFromDate.Text);
            DateTime dateTo = Convert.ToDateTime(txtToDate.Text);
            string BillNo = txtBillNo.Text;
            string CentreID = hdnCenterIds.Value;
            string itemid = HiddenField1.Value;
            string doctorid = HiddenField2.Value;
            string isPreBooking = "0";

            if (chkPreBooking.Checked)
                isPreBooking = "1";

            string checkedID = string.Join(",", chkDetail.Items.Cast<ListItem>().Where(a => a.Selected).Select(a => a.Value.Split('#')[0]));

            string selectQuery = StockReports.ExecuteScalar("SELECT CONCAT('SELECT ', GROUP_CONCAT(REPLACE(ColumnValue,'$','') ))ColumnValue FROM ServiceWiseCollectionReport_Column WHERE ID IN (" + checkedID + ")");

            if (Session["RoleID"].ToString() == "6" || Session["RoleID"].ToString() == "177" || Session["RoleID"].ToString() == "250")
            {


                List<ListItem> extraColumn = chkDetail.Items.Cast<ListItem>()
                                         .Where(a => a.Selected).Where(s => s.Value.Split('#')[0] == "200" || s.Value.Split('#')[0] == "201").ToList();

                if (extraColumn.Count > 0)
                {
                    if (extraColumn.Where(s => s.Value.Split('#')[0] == "200").Count() > 0)
                    {
                        if (selectQuery.Trim() != string.Empty)
                            selectQuery = string.Concat(selectQuery, ",", "pm.Mobile ");
                        else
                            selectQuery = string.Concat("SELECT ", " pm.Mobile ");
                    }
                    if (extraColumn.Where(s => s.Value.Split('#')[0] == "201").Count() > 0)
                    {
                        if (selectQuery.Trim() != string.Empty)
                            selectQuery = string.Concat(selectQuery, ",", "pm.Email ");
                        else
                            selectQuery = string.Concat("SELECT ", " pm.Email ");
                    }
                }
                extraColumn.Clear();
            }
            if (selectQuery.Trim() == string.Empty)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "sh234", "alert('Please Select Report Column');", true);
                return;
            }

            StringBuilder sb = new StringBuilder();

            sb.AppendFormat("{0}", selectQuery);           
            sb.Append("  FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo AND plo.rate <>0 ");
            sb.Append(" AND lt.Date>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
            sb.Append(" AND lt.Date<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" AND lt.CentreID IN (" + CentreID.TrimEnd(',') + " ) ");
            if (isPreBooking == "1")
                sb.Append(" and lt.PreBookingID > 0");

            if (!chiscancel.Checked)
            {
                sb.Append(" and lt.iscancel=0");
            }

            if (chkhomecollection.Checked)
            {
                sb.Append(" and lt.VisitType='Home Collection' ");
            }

            if (BillNo.Trim() != "")
                sb.Append("     AND lt.BillNo='" + BillNo.Trim() + "'");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemId   ");
            if (itemid != "")
            {
                sb.Append(" and im.itemid in (" + itemid + ")");
            }
          if (chkDetail.Items.Cast<ListItem>().Where(a => a.Selected).Where(s => s.Value.Split('#')[0] == "35").Count() > 0)
            {

              //  sb.Append(" INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=plo.`SubCategoryID` ");
            }
            sb.Append("  INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");

        
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID");
            if (doctorid != "")
            {
                sb.Append(" and dr.Doctor_ID in (" + doctorid + ")");
            }
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
            sb.Append(" INNER JOIN centre_master cm2 ON fpm.`TagProcessingLabID`=cm2.CentreID ");


            sb.Append(" UNION ALL ");

            sb.AppendFormat("{0}", selectQuery);          
            sb.Append("   FROM f_ledgertransaction lt INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo  ");
            sb.Append(" AND lt.Date>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00'");
            sb.Append(" AND lt.Date<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (isPreBooking == "1")
                sb.Append(" and lt.PreBookingID > 0");


            if (!chiscancel.Checked)
            {
                sb.Append(" and lt.iscancel=0");
            }

            if (chkhomecollection.Checked)
            {
                sb.Append(" and lt.VisitType='Home Collection' ");
            }

            if (BillNo.Trim() != "")
                sb.Append("     AND lt.BillNo='" + BillNo.Trim() + "'");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemId  ");
            if (itemid != "")
            {
                sb.Append(" and im.itemid in (" + itemid + ")");
            }
       if (chkDetail.Items.Cast<ListItem>().Where(a => a.Selected).Where(s => s.Value.Split('#')[0] == "35").Count() > 0)
            {

              //  sb.Append(" INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=plo.`SubCategoryID` ");
            }
            sb.Append(" INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id ");
         
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID");
            if (doctorid != "")
            {
                sb.Append(" and dr.Doctor_ID in (" + doctorid + ")");
            }
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID`  AND fpm.`PanelType`='camp' ");
            sb.Append(" INNER JOIN centre_master cm2 ON cm2.CentreID=lt.CentreID  ");//fpm.`TagProcessingLabID`=cm2.CentreID
            sb.Append(" AND cm2.CentreID IN (" + CentreID.TrimEnd(',') + " )");

            //    sb.Append(" INNER JOIN  centre_panel cpl ON cpl.`PanelId`=fpm.`Panel_ID` AND cpl.`isActive`=1 AND cpl.CentreID IN (" + CentreID.TrimEnd(',') + " ) ");



            List<ListItem> OpenDate = chkDetail.Items.Cast<ListItem>()
                                         .Where(a => a.Selected).Where(s => s.Value.Split('#')[0] == "13").ToList();

            if (OpenDate.Count > 0)
            {
                sb.Append(" ORDER BY OpenDate ");
            }

            OpenDate.Clear();

            NameValueCollection collections = new NameValueCollection();
            collections.Add("Query", sb.ToString());
            collections.Add("ReportName", "Service Wise Collection Report");
            collections.Add("Period", "From : " + dateFrom.ToString("dd-MMM-yyyy") + " To : " + dateTo.ToString("dd-MMM-yyyy"));
            collections.Add("IsAutoIncrement", "0");
            ScriptManager.RegisterStartupScript(this, GetType(), "", "OpenReport();", true);
            string strForm = AllLoad_Data.PreparePOSTForm(collections,2);
            Page.Controls.Add(new LiteralControl(strForm));

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, GetType(), "", "alert('Error Occured....!');", true);
        }
    }
}