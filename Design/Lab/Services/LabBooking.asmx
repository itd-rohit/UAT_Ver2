<%@ WebService Language="C#" Class="LabBooking" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft;
using System.Data;
using System.Text;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.Linq;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class LabBooking : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod(EnableSession = true)]
    public string GetitemRate(string ItemID, string type, string Rate, string addedtest, string centreID, decimal DiscPer, string DeliveryDate, string MRP, string IsCopayment, string panelid, string MembershipCardNo, int? IsSelfPatient,string UHIDNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string Ratetype = "0";
            if (type == string.Empty)
            {
                type = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT if(SubcategoryID='15','Package','Test') type from f_itemmaster where ItemID=@ItemID",
                   new MySqlParameter("@ItemID", ItemID)));
            }

            Ratetype = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT imm.reporttype FROM investigation_master imm INNER JOIN  f_itemmaster im ON im.`Type_ID`=imm.`Investigation_Id`  where ItemID=@ItemID",
                   new MySqlParameter("@ItemID", ItemID)));
            decimal DiscAmt = 0; decimal Amount = 0;
            if (DiscPer > 0)
            {
                DiscAmt = Math.Ceiling(Math.Round(Util.GetDecimal(Util.GetDecimal(Rate) * Util.GetDecimal(DiscPer)) / 100, 2, MidpointRounding.AwayFromZero));
                Amount = Math.Round(Util.GetDecimal(Rate) - Util.GetDecimal(DiscAmt), 2, MidpointRounding.AwayFromZero);
            }
            else
            {
                Amount = Util.GetDecimal(Rate);
            }
            decimal paybypanelper = 0;
            decimal paybypanel = 0;
            decimal paybypatient = 100;
            if (IsCopayment == "1")
            {
                paybypanelper = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT get_copayment_percentage(@ItemID,@panelid); ",
                  new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@panelid", panelid)));


                paybypanel = Math.Ceiling(Math.Round(Util.GetDecimal(Util.GetDecimal(Amount) * Util.GetDecimal(paybypanelper)) / 100, 2, MidpointRounding.AwayFromZero));
                paybypatient = Amount - paybypanel;


            }
            StringBuilder sb = new StringBuilder();
            if (MembershipCardNo != string.Empty)
            {
                sb.Append("  SELECT t.* ,");
                sb.Append("  IF(IFNULL(plc.FreeTestBalance,0) > 0 ,1,0) IsFreeTest,IF(IFNULL(plc.FreeTestBalance,0) > 0,0,IFNULL(plc1.MemberShipDisc,0))MemberShipDisc, ");
                sb.Append("  IFNULL(plc.MemberShipTableID,0)MemberShipTableID,IF(IFNULL(plc.FreeTestBalance,0) > 0,0,1) IsMemberShipDisc,IF(IFNULL(plc.FreeTestBalance,0) > 0 ,plc.FreeTestBalance,0) FreeTestQuantity FROM ( ");
            }
            if (type == "Test")
            {
                sb.Append(" SELECT im.IsOutSrc,LEFT(sm.NAME,4) Dept,sm.NAME AS SubcategoryName ,sm.SubcategoryID as SubID,IFNULL(sm.DisplayName,'')DepartmentDisplayName,IFNULL(sm.deptinterpretaion,'')deptinterpretaion, @type type,");
                sb.Append(" IFNULL((SELECT GROUP_CONCAT(CAST(fieldID AS CHAR)) FROM investigation_requiredfield WHERE investigationID=imm.`Investigation_Id` AND ShowOnBooking=1),'') RequiredFields,");
                sb.Append(" im.baserate,IFNULL(imm.RequiredAttachment,'')RequiredAttachment, IFNULL(imm.RequiredAttachmentID,'')RequiredAttachmentID,IFNULL(AttchmentRequiredAt,'')AttchmentRequiredAt, imm.SampleDefined, imm.reporttype, '0' ispackage,imm.reporting,IFNULL( im.testcode,'')testCode,typeName,");
                sb.Append(" IF(im.TestCode='',typeName,CONCAT(im.TestCode,'~',typeName)) Item,im.`ItemID`, @Rate Rate,im.subcategoryid, @MRP MRP,");
                if (Ratetype == "1")
                {
                    sb.Append(" CAST(imm.`Investigation_Id` AS CHAR)Investigation_Id,IFNULL(imm.TYPE,'N') Sample ,CONCAT(IFNULL(imm.SampleRemarks,''),'<br/>',GROUP_CONCAT(LOM.`Name` SEPARATOR '<br/>')) SampleRemarks, imm.GenderInvestigate,imm.IsLMPRequired,imm.LMPFormDay,imm.LMPToDay,im.IsRequiredQuantity, ");
                }
                else
                {
                    sb.Append(" CAST(imm.`Investigation_Id` AS CHAR)Investigation_Id,IFNULL(imm.TYPE,'N') Sample ,IFNULL(imm.SampleRemarks,'') SampleRemarks, imm.GenderInvestigate,imm.IsLMPRequired,imm.LMPFormDay,imm.LMPToDay,im.IsRequiredQuantity, ");
                }
                    if (DeliveryDate.Trim() != string.Empty)
                {
                    sb.Append("  IFNULL(Get_DeliveryDate_client(@centreID,imm.Investigation_ID,@DeliveryDate,0),'01-Jan-0001 12:00 AM#01-Jan-0001 12:00 AM')DeliveryDate, ");
                }
                else
                {
                    sb.Append("  IFNULL(Get_DeliveryDate_client(@centreID,imm.Investigation_ID,now(),0),'01-Jan-0001 12:00 AM#01-Jan-0001 12:00 AM')DeliveryDate, ");
                }
                sb.Append(" @DiscAmt DiscAmt,@Amount Amount,@EncryptedRate EncryptedRate,@EncryptedAmount EncryptedAmount,@EncryptedDiscAmt EncryptedDiscAmt,@EncryptedItemID EncryptedItemID,@EncryptedMRP EncryptedMRP");

                if (IsCopayment == "1")
                {
                    sb.Append(" ,@paybypatient paybypatient, @paybypanel paybypanel,@paybypanelper paybypanelper");
                }
                else
                {
                    sb.Append(" ,@Amount paybypatient, @paybypanel paybypanel,@paybypanelper paybypanelper");
                }
                sb.Append(" FROM f_itemmaster im INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.subcategoryid INNER JOIN investigation_master imm ON im.`Type_ID`=imm.`Investigation_Id` ");
                if (Ratetype == "1")
                {
                    sb.Append("  INNER JOIN labobservation_investigation LOI ON imm.Investigation_Id=LOI.Investigation_Id INNER JOIN labobservation_master LOM ON  ");
                    sb.Append(" LOI.labObservation_ID=LOM.LabObservation_ID AND  imm.Investigation_Id =im.type_id ");
                }
                sb.Append(" AND im.`ItemID`=@ItemID ");
            }
            else
            {
                sb.Append("SELECT im.IsOutSrc,'PACK' as Dept,'Package' as SubcategoryName,SubcategoryID as SubID,''DepartmentDisplayName,'' deptinterpretaion, @type type,im.baserate,IFNULL(GROUP_CONCAT(CAST(fieldID AS CHAR)),'') RequiredFields,");
                sb.Append(" IFNULL(group_concat(CAST(imm.RequiredAttachment AS CHAR)),'') RequiredAttachment,IFNULL(group_concat(CAST(imm.RequiredAttachmentID AS CHAR)),'') RequiredAttachmentID,IFNULL(group_concat(CAST(imm.AttchmentRequiredAt AS CHAR)),'')AttchmentRequiredAt,'1' SampleDefined,");
                sb.Append(" '0' reporttype, '1' ispackage,'0' reporting, IFNULL( im.testcode,'')testCode,typeName,IF(im.TestCode='',typeName,CONCAT(im.TestCode,'~',typeName)) Item,im.`ItemID`,");
                sb.Append(" @Rate Rate, im.subcategoryid,@MRP MRP,");
                sb.Append(" GROUP_CONCAT(CAST(imm.Investigation_Id AS CHAR)) Investigation_Id ,IFNULL(imm.TYPE,'N') Sample ,GROUP_CONCAT(imm.name SEPARATOR '##') SampleRemarks, imm.GenderInvestigate,imm.IsLMPRequired,imm.LMPFormDay,imm.LMPToDay,im.IsRequiredQuantity, ");
                if (DeliveryDate.Trim() != string.Empty)
                {
                    sb.Append("  IFNULL(Get_DeliveryDate_client(@centreID,imm.Investigation_ID,@DeliveryDate,0),'01-Jan-0001 12:00 AM#01-Jan-0001 12:00 AM')DeliveryDate, ");
                }
                else
                {
                    sb.Append("  IFNULL(Get_DeliveryDate_client(@centreID,imm.Investigation_ID,now(),0),'01-Jan-0001 12:00 AM#01-Jan-0001 12:00 AM')DeliveryDate, ");
                }
                sb.Append(" @DiscAmt DiscAmt,@Amount Amount,@EncryptedRate EncryptedRate,@EncryptedAmount EncryptedAmount,@EncryptedDiscAmt EncryptedDiscAmt,@EncryptedItemID EncryptedItemID,@EncryptedMRP EncryptedMRP");
                if (IsCopayment == "1")
                {
                    sb.Append(" ,@paybypatient paybypatient, @paybypanel paybypanel,@paybypanelper paybypanelper");
                }
                else
                {
                    sb.Append(" ,@Amount paybypatient, @paybypanel paybypanel,@paybypanelper paybypanelper");
                }

                sb.Append(" FROM f_itemmaster im  ");
                sb.Append(" INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID   ");
                sb.Append(" INNER JOIN investigation_master imm  ON imm.Investigation_Id=pld.InvestigationID AND  im.`ItemID`=@ItemID ");
                sb.Append("  LEFT JOIN  investigation_requiredfield ir ON ir.`investigationid`=imm.`Investigation_Id` AND ShowOnBooking=1 ");
                sb.Append(" GROUP BY im.ItemID  ");
            }
            if (MembershipCardNo != string.Empty)
            {
                if (IsSelfPatient == 1)
                {
                    sb.Append(" )t ");
                    sb.Append(" LEFT JOIN ( SELECT mem.ID MemberShipTableID,mem.`ItemId`,(mem.`SelfFreeTestCount`-mem.`SelfFreeTestConsume` ) FreeTestBalance  FROM ");
                    sb.Append(" `membershipcard_Detail` ");
                    sb.Append(" mem  WHERE mem.ItemId=@ItemID  AND mem.Patient_ID=@Patient_ID ");
                    sb.Append(" AND MembershipCardNo=@MembershipCardNo AND mem.cardvalid >=CURRENT_DATE  ");
                    sb.Append("  AND SelfFreeTestCount > SelfFreeTestConsume  AND mem.IsActive=1 ORDER BY mem.ID LIMIT 1 ) plc ON plc.ItemId=t.ItemId  ");

                    sb.Append(" LEFT JOIN ( SELECT mem.ID MemberShipTableID,mem.`ItemId`,SelfDisc MemberShipDisc FROM ");
                    sb.Append(" `membershipcard_Detail` ");
                    sb.Append(" mem  WHERE mem.ItemId=@ItemID  AND mem.Patient_ID=@Patient_ID ");
                    sb.Append(" AND MembershipCardNo=@MembershipCardNo AND mem.cardvalid >=CURRENT_DATE ");
                    sb.Append("  AND mem.IsActive=1 ORDER BY mem.ID LIMIT 1 ) plc1 ON plc1.ItemId=t.ItemId ");
                    sb.Append(" ");

                }
                else
                {
                    sb.Append(" )t ");
                    sb.Append(" LEFT JOIN ( SELECT mem.ID MemberShipTableID,mem.`ItemId`,(mem.`DependentFreeTestCount`-mem.`DependentFreeTestConsume` ) FreeTestBalance  FROM ");
                    sb.Append(" `membershipcard_Detail` ");
                    sb.Append("   mem  WHERE mem.ItemId=@ItemID AND mem.Patient_ID=@Patient_ID ");
                    sb.Append(" AND MembershipCardNo=@MembershipCardNo AND mem.cardvalid >=CURRENT_DATE ");
                    sb.Append("  AND DependentFreeTestCount > DependentFreeTestConsume AND mem.IsActive=1 ORDER BY mem.ID LIMIT 1 ) plc ON plc.ItemId=t.ItemId  ");
                    sb.Append(" LEFT JOIN ( SELECT mem.ID MemberShipTableID,mem.`ItemId`,DependentDisc MemberShipDisc FROM ");
                    sb.Append(" `membershipcard_Detail` ");
                    sb.Append(" mem WHERE mem.ItemId=@ItemID AND mem.Patient_ID=@Patient_ID  ");
                    sb.Append(" AND MembershipCardNo=@MembershipCardNo AND mem.cardvalid >=CURRENT_DATE  ");
                    sb.Append(" AND mem.IsActive=1 ORDER BY mem.ID LIMIT 1 ) plc1 ON plc1.ItemId=t.ItemId ");
                    sb.Append(" ");
                }
            }

            

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@centreID", centreID), new MySqlParameter("@DeliveryDate", DeliveryDate.Trim()),
               new MySqlParameter("@DiscAmt", DiscAmt), new MySqlParameter("@Amount", Amount), new MySqlParameter("@type", type),
               new MySqlParameter("@Rate", Rate), new MySqlParameter("@MRP", MRP), new MySqlParameter("@ItemID", ItemID),
               new MySqlParameter("@EncryptedRate", Common.Encrypt(Rate)), new MySqlParameter("@EncryptedAmount", Common.Encrypt(Util.GetString(Amount))),
               new MySqlParameter("@EncryptedDiscAmt", Common.Encrypt(Util.GetString(DiscAmt))),
               new MySqlParameter("@EncryptedItemID", Common.Encrypt(ItemID)), new MySqlParameter("@EncryptedMRP", Common.Encrypt(MRP)),
               new MySqlParameter("@paybypatient", paybypatient),
               new MySqlParameter("@paybypanel", paybypanel), new MySqlParameter("@paybypanelper", paybypanelper),
               new MySqlParameter("@MembershipCardNo", MembershipCardNo), new MySqlParameter("@Patient_ID", UHIDNo)).Tables[0])
            {

                if (MembershipCardNo != string.Empty)
                {
                    if (Util.GetString(dt.Rows[0]["IsFreeTest"]) == "1")
                    {
                        dt.Rows[0]["DiscAmt"] = dt.Rows[0]["Rate"];
                        dt.Rows[0]["EncryptedDiscAmt"] = Common.Encrypt(Util.GetString(dt.Rows[0]["Rate"]));
                        dt.Rows[0]["Amount"] = "0";
                        dt.Rows[0]["EncryptedAmount"] = Common.Encrypt(Util.GetString("0"));
                        dt.Rows[0]["IsMemberShipDisc"] = "0";
                    }
                    else
                    {
                        if (Util.GetInt(dt.Rows[0]["MemberShipDisc"]) > 0)
                        {
                            DiscAmt = Math.Ceiling(Math.Round(Util.GetDecimal(Util.GetDecimal(Rate) * Util.GetDecimal(dt.Rows[0]["MemberShipDisc"])) / 100, 2, MidpointRounding.AwayFromZero));
                            Amount = Math.Round(Util.GetDecimal(Rate) - Util.GetDecimal(DiscAmt), 2, MidpointRounding.AwayFromZero);
                            dt.Rows[0]["DiscAmt"] = DiscAmt;
                            dt.Rows[0]["EncryptedDiscAmt"] = Common.Encrypt(Util.GetString(DiscAmt));
                            dt.Rows[0]["Amount"] = Amount;
                            dt.Rows[0]["EncryptedAmount"] = Common.Encrypt(Util.GetString(Amount));
                            dt.Rows[0]["IsMemberShipDisc"] = "1";
                        }
                    }
                }
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string geturgentTAT(string InvID, string CentreID, string Isurgent)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string deliverydate = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Get_DeliveryDate_client(@CentreID,@InvID,NOW(),@Isurgent)",
                new MySqlParameter("@CentreID", CentreID),
                new MySqlParameter("@InvID", InvID),
                new MySqlParameter("@Isurgent", Isurgent)));

            return JsonConvert.SerializeObject(new { status = "true", response = deliverydate.Split('#')[1] });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = "false", response = string.Empty });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    public string GetsampleType(string investigationid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] ItemIDTags = investigationid.Split(',');
            string[] ItemIDParamNames = ItemIDTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string ItemIDClause = string.Join(", ", ItemIDParamNames);
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.investigation_id,NAME,im.Container,IFNULL(GROUP_CONCAT(CONCAT(sampletypeid,'|',sampletypename) ORDER BY  isdefault DESC SEPARATOR  '^'  ),'1|NA') sampleinfo ");
            sb.Append("   FROM investigation_master im ");
            sb.Append(" LEFT JOIN investigations_sampletype inv ON inv.investigation_id=im.investigation_id where im.investigation_id IN ({0}) AND IFNULL(sampletypename,'')!='' GROUP BY im.investigation_id ORDER BY sampletypeName ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), ItemIDClause), con))
            {
                for (int i = 0; i < ItemIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(ItemIDParamNames[i], ItemIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string GetItemInsidePackage(string itemid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("     SELECT imm.`Name` ,imm.`Investigation_Id`,imm.`Type` sampledata,imm.`Reporting`,imm.`ReportType`,");
            sb.Append("     DATE_FORMAT(`Get_DeliveryDate`('1',imm.Investigation_ID,NOW()),'%d-%b-%Y %I:%i %p') DeliveryDate, ");
            sb.Append("     (SELECT `SubCategoryID` FROM f_itemmaster WHERE type_id=imm.`Investigation_Id`)subcategoryid ");
            sb.Append("     FROM f_itemmaster im  ");
            sb.Append("     INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID   ");
            sb.Append("     INNER JOIN investigation_master imm  ON imm.Investigation_Id=pld.InvestigationID ");
            sb.Append("     AND  im.`ItemID`=@ItemID ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ItemID", itemid)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetLastLabNo(string center)
    {
        string labno = StockReports.ExecuteScalar("SELECT LedgerTransactionNO FROM patient_labinvestigation_opd where LedgerTransactionNO<>'' and CentreID='" + center + "' ORDER BY LedgerTransactionID DESC LIMIT 1");
        return labno;

    } 
    
    [WebMethod(EnableSession = true)]
    public string GetPatientInfoData(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        string Roleid = Util.GetString(UserInfo.RoleID); string permissiontype = "EditInfo"; string Labno = LabNo;
        string rresult = Util.RolePermission(Roleid, permissiontype, Labno);

        if (rresult == "true")
        {          
            return "-1";
        }
        
        
        try
        {
            HttpContext ctx = HttpContext.Current;
            string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT (SELECT Remarks FROM patient_labinvestigation_opd_remarks WHERE Ledgertransactionno=@LabNo)Remarks, lt.Children,lt.Son,lt.Pregnancydate,lt.PndtDoctorId,lt.AgeDaughter,lt.AgeSon,lt.Daughter,lt.SRFNo,lt.`DiscountID`,lt.CentreID,lt.HomeVisitBoyID,lt.LedgerTransactionNo,lt.LedgerTransactionID,pm.Patient_ID,pm.Gender,pm.AgeDays,pm.AgeMonth,pm.AgeYear,Pm.Title,Pm.PName ,Pm.Mobile ,Pm.Email ,");
            sb.Append(" (SELECT COUNT(*) FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionID`=lt.LedgerTransactionID AND `Investigation_ID`<>'' LIMIT 1)TotalTest, ");
            sb.Append(" (SELECT SUM(approved) FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionID`=lt.LedgerTransactionID AND `Investigation_ID`<>'' LIMIT 1)TotalApprovedTest, ");
            sb.Append(" pm.PinCode,pm.State,pm.City,pm.CountryID,pm.StateID,pm.CityID,pm.LocalityID,pm.House_No,pm.Locality,DATE_FORMAT(pm.dob,'%d-%b-%Y') dob, ");
            sb.Append(" lt.DoctorName,lt.Doctor_ID,lt.PatientIDProof,lt.PatientIDProofNo,lt.PatientSource, ");
            sb.Append(" lt.HLMOPDIPDNo,lt.HLMPatientType,lt.VisitType,lt.PatientType,lt.PROID,lt.Nationality,lt.ECHS,lt.ICMRNo,lt.PureHealthID,lt.PassportNo, ");
            sb.Append(" lt.VIP,fpm.Contact_Person PUPContact,fpm.Mobile PUPMobileNo,fpm.Panel_Code PUPRefNo,IFNULL(dis.DispatchModeName,'')DispatchModeName,IFNULL(dis.DispatchModeID,0)DispatchModeID,TIMESTAMPDIFF(MINUTE,lt.DATE,NOW()) BillTimeDiff ");
            sb.Append(" FROM f_ledgertransaction lt ");
            sb.Append(" INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID LEFT JOIN f_ledgertransaction_DispatchMode dis ON dis.LedgertransactionID=lt.LedgertransactionID AND dis.IsActive=1");
            sb.Append(" WHERE (lt.`LedgerTransactionNo`=@LabNo or plo.Barcodeno=@LabNo) ");
            if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
            {
                sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + "");
            }
            else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
            {
                sb.Append(" and fpm.employee_ID=" + Util.GetString(ctx.Session["ID"]) + "");
            }
            sb.Append("  Group by lt.LedgerTransactionID");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@LabNo", LabNo)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string GetPatientReceiptData(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string Roleid = Util.GetString(UserInfo.RoleID); string permissiontype = "EditPriscription"; string Labno = LabNo;
        string rresult = Util.RolePermission(Roleid, permissiontype, Labno);

        if (rresult == "true")
        {
            // return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
            return "-1";
        }
        try
        {
            //string timediffin = StockReports.ExecuteScalar("SELECT TIMESTAMPDIFF(HOUR,  if(SampleCollectionDate='0001-01-01 00:00:00',now(),SampleCollectionDate),NOW())   FROM  patient_labinvestigation_opd WHERE LedgerTransactionNo='" + LabNo + "' ORDER BY SampleCollectionDate ASC LIMIT 1");
            //int timediff = (timediffin == "") ? 0 : Util.GetInt(timediffin);
            //if (timediff > 24)
            //    return "-1";
            StringBuilder sb = new StringBuilder();
            sb.Append(" select itm.IsOutSrc,lt.SRFNo,( SELECT IFNULL(GROUP_CONCAT(cast(fieldid AS CHAR) SEPARATOR ',' ),'') FROM investigation_requiredfield ir WHERE ir.`investigationid`=invm.`Investigation_Id` AND ShowOnBooking=1 ) RequiredFields,  ");

            sb.Append(" IFNULL(GROUP_CONCAT(CAST(invm.AttchmentRequiredAt AS CHAR)),'')AttchmentRequiredAt ,IFNULL(group_concat(CAST(invm.RequiredAttachmentID AS CHAR)),'') RequiredAttachmentID,IFNULL(group_concat(CAST(invm.RequiredAttachment AS CHAR)),'') RequiredAttachment,");
            sb.Append(" (SELECT COUNT(*) FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionID`=lt.LedgerTransactionID AND `Investigation_ID`<>'' LIMIT 1)TotalTest, ");
            sb.Append(" (SELECT SUM(approved) FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionID`=lt.LedgerTransactionID AND `Investigation_ID`<>'' LIMIT 1 )TotalApprovedTest, ");
            sb.Append(" lt.OtherLabRefNo,");
            sb.Append("  plo.barcodePreprinted,plo.barcodeno,plo.MRP, sum(plo.DiscountAmt)DiscountAmt, (select name from employee_master where employee_id=lt.DiscountApprovedByID) discby,");
            sb.Append(" IFNULL((select DiscShareType from Discount_Approval_Master where EmployeeID=lt.DiscountApprovedByID limit 1),0) DiscShareType,lt.HomeVisitBoyID,");
            sb.Append(" lt.LedgerTransactionNo,lt.LedgerTransactionID,pm.patient_id,pm.Title,pm.PName,pm.Gender,pm.AgeDays,pm.AgeMonth,pm.AgeYear,  ");
            sb.Append(" lt.CentreID,pm.Pincode,pm.State,pm.City,pm.House_No,pm.Locality,pm.StateID,pm.CityID,pm.LocalityID,pm.Mobile,pm.Email,DATE_FORMAT(pm.dob,'%d-%b-%Y') dob,   ");
            sb.Append(" lt.DoctorName,lt.Doctor_ID,lt.PatientIDProof,lt.PatientIDProofNo,lt.PatientSource,IFNULL(dis.DispatchModeID,0)DispatchModeID,  ");
            sb.Append(" lt.HLMOPDIPDNo,lt.HLMPatientType,lt.VisitType,lt.Patienttype,lt.CorporateIDCard,lt.CorporateIDType,lt.BarCodePrintedType,lt.BarCodePrintedCentreType,lt.BarCodePrintedHomeColectionType,lt.setOfBarCode,   ");
            sb.Append(" lt.VIP ,lt.`GrossAmount`,lt.`NetAmount`,lt.`DiscountOnTotal`,lt.`DiscountApprovedByID`,lt.`DiscountApprovedByName`,  ");
            sb.Append(" lt.`Adjustment`,lt.`IsCredit`,CONCAT(lt.Panel_ID,'#',pmm.ReferenceCode,'#',pmm.Payment_Mode,'#',pmm.PanelType,'#',(SELECT IsHideRate FROM Employee_Master WHERE Employee_Id=@Employee_Id LIMIT 1),'#',pmm.PanelID_MRP,'#',pmm.CoPaymentApplicable,'#',pmm.CoPaymentEditonBooking  ) `Panel_ID`,lt.`PanelName`,  ");
            sb.Append("  itm.typename item,itm.testcode testcode,itm.IsRequiredQuantity,plo.Quantity,sum(plo.rate)rate,sum(plo.amount)amount,plo.ItemID,plo.ispackage,plo.reporttype,plo.issamplecollected,IF(plo.ispackage=1 , IF(SUM(plo.result_flag)>0,1,0),plo.result_flag)result_flag,plo.IsReporting");
            sb.Append(" ,IF(plo.ispackage=0, CAST(plo.Investigation_ID AS CHAR),");
            sb.Append(" CAST((SELECT  GROUP_CONCAT(plo2.investigation_id  SEPARATOR ',' )     FROM patient_labinvestigation_opd plo2 WHERE itemid=plo.`ItemId` and plo2.LedgerTransactionID=plo.LedgerTransactionID AND investigation_id<>'') AS CHAR)) Investigation_ID, plo.Test_ID, ");
            sb.Append(" plo.`SubCategoryID`, '' DispatchModeName,DATE_FORMAT(plo.`DeliveryDate`,'%d-%b-%Y %I:%i %p') DeliveryDate,DATE_FORMAT(plo.`SRADate`,'%d-%b-%Y %I:%i %p') SRADate,  ");
            sb.Append(" IFNULL(invm.TYPE,'N') Sample ,IF(plo.ispackage=0,IFNULL(invm.SampleRemarks, ''),'')  SampleRemarks, invm.GenderInvestigate ,");
            sb.Append(" '0' PaidAmount,'4' PaymentModeID,'' `CardNo`,'' `BankName`, ");
            sb.Append(" '' carddate,IF(plo.ispackage=1 , IF(SUM(plo.IsRefund)>0,1,0),plo.IsRefund)IsRefund,DATE_FORMAT(lt.Date,'%Y-%m-%d')PrescribeDate,lt.DiscountID,plo.IsScheduleRate,'' InvoiceNo,pmm.SampleCollectionOnReg,1 SampleDefined ");
            sb.Append(" ,plo.PayByPanel paybypanel,plo.PayByPanelPercentage paybypanelper,plo.PayByPatient paybypatient,IFNULL(plo.SubCategoryName,'')SubCategoryName,TIMESTAMPDIFF(MINUTE,lt.DATE,NOW()) BillTimeDiff ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  INNER JOIN f_panel_master pmm ON pmm.panel_id=lt.panel_id ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID  and plo.isrefund=0 ");
            sb.Append("  INNER JOIN f_Itemmaster itm ON itm.ItemID=plo.ItemID  ");
            sb.Append(" ");
            sb.Append("  LEFT OUTER JOIN Investigation_master invm ON invm.Investigation_Id=itm.Type_ID   ");
            sb.Append("  LEFT JOIN f_ledgertransaction_DispatchMode dis ON dis.LedgerTransactionID=lt.LedgerTransactionID   ");
            sb.Append("  WHERE (lt.`LedgerTransactionNo`=@LabNo or plo.Barcodeno=@LabNo)   AND Plo.IsActive=1 GROUP BY plo.`ItemId` ORDER BY plo.test_id");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@LabNo", LabNo), new MySqlParameter("@Employee_Id", UserInfo.ID),
                 new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    public string GetPanelGroup(string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT DISTINCT panelGroupID value,PanelGroup label FROM `f_panel_master` WHERE Panel_ID=@PanelID  ORDER BY PanelGroup");
           // sb.Append(" order by cp.isDefault+0  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@PanelID", PanelID)).Tables[0])
                return JsonConvert.SerializeObject(dt);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string GetPanel(string CentreID, string VisitType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            HttpContext ctx = HttpContext.Current;
            string pro_id = HttpContext.Current.Session["PROID"].ToString();
            string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID="+ Util.GetString(ctx.Session["ID"]) +" ");
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Distinct pn.Panel_ID,CONCAT(pn.panel_id,'#',pn.ReferenceCode,'#',pn.Payment_Mode,'#',pn.MinBalReceive,'#',pn.hiderate,'#',pn.PanelType,'#',pn.Panel_Code,'#',IFNULL(pn.`Contact_Person`,''),'#',pn.Mobile,'#',IFNULL(pn.EmailID,''),'#',pn.InvoiceTo,'#',pn.`showBalanceAmt`,'#',isPanelLock(pn.panel_id,'Booking',0),'#',pn.DiscountAllowed,'#',pn.ShowCollectionCharge,'#',pn.CollectionCharge,'#',pn.ShowDeliveryCharge,'#',pn.DeliveryCharge,'#',pn.PanelID_MRP,'#',IsOtherLabReferenceNo,'#',pn.CoPaymentApplicable,'#',pn.CoPaymentEditonBooking,'#',ReceiptType,'#',pn.MRPBill,'#',pn.panelgroupid,'#',pn.proid  )value,CONCAT(pn.`Panel_Code`,' ',pn.company_name)label, ");
            sb.Append(" pn.Mobile,pn.EmailID,pn.BarCodePrintedType,pn.BarCodePrintedCentreType,pn.BarCodePrintedHomeColectionType,pn.setOfBarCode,pn.SampleCollectionOnReg,pn.InvoiceTo  FROM Centre_Panel cp ");
            sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id AND cp.CentreId=@CentreID  ");
            sb.Append(" AND cp.isActive=1 AND pn.isActive=1 ");
            if (UserInfo.RoleID == 220 && pro_id != "0")
            {
                sb.Append(" AND pn.PROID='" + pro_id + "' ");
            }
            if (VisitType != "" && VisitType != null)
            {
               // sb.Append(" WHERE pn.panelgroupid =@VisitType ");
            }
            if (Util.GetString(ctx.Session["PanelType"]) == "PCC")
            {
                sb.Append(" and InvoiceTo ='" + InvoicePanelID  + "'");
            }
            else if (Util.GetString(ctx.Session["PanelType"]).ToUpper() == "SUBPCC")
            {
                sb.Append(" and employee_ID=" + Util.GetString(ctx.Session["ID"]) + "");
            }
            sb.Append(" AND CURRENT_DATE() >= IF(cp.IsCamp=1,cp.`FromCampValidityDate`,CURRENT_DATE()) ");
            sb.Append(" AND CURRENT_DATE() <= IF(cp.IsCamp=1,cp.`ToCampValidityDate`,CURRENT_DATE()) ");
          //  sb.Append(" order by pn.Panel_ID ");
			sb.Append(" order by pn.Panel_ID IN(SELECT DefaultPanelId FROM Centre_master WHERE CentreID=@CentreID) DESC ");
			
			if(Util.GetString(ctx.Session["ID"])=="4874"){
			 System.IO.File.WriteAllText("F:\\Lims 6.0\\live_Code\\Mdrc\\ErrorLog\\BindPanel_CentreID_rk.txt", CentreID+"_"+VisitType);
			 System.IO.File.WriteAllText("F:\\Lims 6.0\\live_Code\\Mdrc\\ErrorLog\\BindPanel_6_rk.txt", sb.ToString());
			}
         //   System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\pnl.txt","select Invoiceto from f_panel_master where employee_ID="+ Util.GetString(ctx.Session["ID"]) +" "+ sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@VisitType", VisitType), new MySqlParameter("@CentreID", CentreID),
                 new MySqlParameter("@Employee_Id", UserInfo.ID)).Tables[0])
                return JsonConvert.SerializeObject(dt);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string GetPRO()
    {
        MySqlConnection con = Util.GetMySqlCon();
        HttpContext ctx = HttpContext.Current;
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            if (Util.GetString(ctx.Session["LoginType"]) != "PCC")
            {
                sb.Append(" SELECT PROID,PROName from  PRO_Master where isactive='1' order by PROName ");

                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                    return JsonConvert.SerializeObject(dt);

            }
            else
            {

                string proid = StockReports.ExecuteScalar("select proid from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");

                sb.Append(" SELECT PROID,PROName from  PRO_Master where PROID='" + proid + "'  and isactive='1' order by PROName ");

                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                    return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string saveNewdoctorfrombooking(string DoctorName, string Mobile, string centreid, string Email, string Address)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Mobile.Trim() != string.Empty)
            {

                sb.Append(" SELECT dr.Name DoctorName FROM `doctor_referal` dr  ");
                sb.Append(" INNER JOIN doctor_referal_centre drc ON drc.`Doctor_ID`=dr.`Doctor_ID` ");
                sb.Append(" AND drc.`CentreID`=@CentreID AND dr.Mobile=@Mobile AND dr.`IsActive`=1");
                using (DataTable dtTemp = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@Mobile", Mobile.Trim()),
                      new MySqlParameter("@CentreID", centreid.Trim())).Tables[0])
                {
                    if (dtTemp.Rows.Count > 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, responseMsg = dtTemp.Rows[0]["DoctorName"], response = string.Empty });
                    }
                }
            }
            sb = new StringBuilder();
            sb.Append(" INSERT INTO doctor_otherfrombooking (DoctorName,Mobile,CentreID,UserID,Email,Address) ");
            sb.Append(" values (@DoctorName,@Mobile,@CentreID,@UserID,@Email,@Address); ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@DoctorName", DoctorName.Trim()),
                 new MySqlParameter("@Mobile", Mobile.Trim()),
                 new MySqlParameter("@CentreID", centreid),
                 new MySqlParameter("@UserID", UserInfo.ID),
                 new MySqlParameter("@Email", Email.Trim()),
                 new MySqlParameter("@Address", Address.Trim()));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@Identity ") });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = string.Empty, responseMsg = string.Empty });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string BindOldPatient(string MobileNo, string Patient_ID, string PName, string FromRegDate, string ToRegDate, string MemberShipCardNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Patient_ID,title,PName,house_no,Country,State,City,Locality,CountryID,StateID,CityID,LocalityID,IF(PinCode=0,'',PinCode)PinCode,mobile, email,");
            sb.Append(" ageYear,ageMonth,ageDays,gender,DATE_FORMAT(dob,'%d-%b-%Y') dob,age,DATE_FORMAT(CreatedDate,'%d-%b-%Y %h:%I %p') visitDate,  ");
            sb.Append(" PreBookingID,VisitType,VIP,IFNULL(PatientIDProof,'')PatientIDProof,PatientIDProofNo,PatientSource,'' DispatchModeName,Remarks,PaymentMode,Panel_ID ,");
            sb.Append(" CAST(GROUP_CONCAT(ItemID SEPARATOR ',' ) AS CHAR)ItemID,CAST(GROUP_CONCAT(CONCAT(Rate,'#',IsScheduleRate) SEPARATOR ',' ) AS CHAR)Rate,");
            sb.Append(" CAST(GROUP_CONCAT(IF(SubCategoryID='15','Package','Test') SEPARATOR ',') AS CHAR)`type`,0 totalRow,'' dtEntry,'' ClinicalHistory,");
            sb.Append(" 0 OPDAdvanceAmount,'' MembershipCardNo,0 MembershipCardID,0 FamilyMemberIsPrimary ");
            sb.Append(" ");
            sb.Append(" FROM patient_labinvestigation_opd_prebooking where  IFNULL(LedgertransactionID,'')='' AND patient_id=@Patient_ID ");
            if (MobileNo != string.Empty)
                sb.Append(" AND mobile=@MobileNo");
            sb.Append(" GROUP BY PreBookingID  ");
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT Patient_ID,title,PName,house_no,pm.Country,pm.State,pm.City,pm.Locality,pm.CountryID,pm.StateID,pm.CityID,pm.LocalityID,IF(PinCode=0,'',PinCode)PinCode,mobile, email,");
            sb.Append(" ageYear,ageMonth,ageDays,gender,DATE_FORMAT(dob,'%d-%b-%Y') dob,age,DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%I %p') visitDate,");
            sb.Append(" 0 PreBookingID,  ");
            sb.Append(" '' VisitType, VIP,'' PatientIDProof,'' PatientIDProofNo,'' PatientSource,'' DispatchModeName,'' Remarks,''PaymentMode,'' Panel_ID ,");
            sb.Append(" '' ItemID ,''Rate,'' `type`,0 totalRow,Date_Format(dtEntry,'%d-%c-%Y')dtEntry,ClinicalHistory, ");
            sb.Append(" IFNULL((SELECT  SUM(oa.AdvanceAmount-oa.BalanceAmount) FROM opd_advance oa WHERE oa.IsCancel = 0  AND oa.Patient_ID = pm.Patient_ID),0) OPDAdvanceAmount, ");
            sb.Append(" IF(MembershipCardValidTo>=CURRENT_DATE,IFNULL(MembershipCardNo,''),'')MembershipCardNo,IF(MembershipCardValidTo>=CURRENT_DATE,MembershipCardID,0),FamilyMemberIsPrimary ");
            sb.Append(" FROM patient_master pm WHERE  Patient_ID<>'' ");
            if (MobileNo != string.Empty)
                sb.Append(" AND mobile=@MobileNo");
            else if (Patient_ID != string.Empty)
                sb.Append(" AND patient_id=@Patient_ID");
            else if (MemberShipCardNo != string.Empty)
                sb.Append(" AND MemberShipCardNo=@MemberShipCardNo AND MembershipCardValidTo>CURRENT_DATE");
            else
            {
                sb.Append(" AND dtEntry>=@FromRegDate AND dtEntry<=@ToRegDate ");
                if (PName != string.Empty)
                    sb.Append(" AND PName LIKE @PName ");
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                if (MobileNo != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@MobileNo", MobileNo);
                else if (Patient_ID != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@Patient_ID", Patient_ID);
                else if (MemberShipCardNo != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@MemberShipCardNo", MemberShipCardNo);
                else
                {
                    da.SelectCommand.Parameters.AddWithValue("@FromRegDate", string.Concat(Util.GetDateTime(FromRegDate).ToString("yyyy-MM-dd"), " 00:00:00"));
                    da.SelectCommand.Parameters.AddWithValue("@ToRegDate", string.Concat(Util.GetDateTime(ToRegDate).ToString("yyyy-MM-dd"), " 23:59:59"));
                    if (PName != string.Empty)
                        da.SelectCommand.Parameters.AddWithValue("@PName", string.Format("{0}%", PName));

                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string BindOldPatientFromMoreFilter(string PName, string DOB, string Patient_ID, string MobileNo, string fromDate, string toDate, string stateID, string cityID, string localityID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  pm.Patient_ID, pm.Title, pm.PName,'' PLastName, pm.House_No, pm.localityID, pm.CityID,IF(pm.pincode = 0, '', pm.pincode) PinCode, pm.StateID, ");
            sb.Append(" pm.country,  pm.`CountryID`, pm.mobile, pm.email, pm.ageyear, pm.agemonth, pm.agedays, pm.Gender, DATE_FORMAT(pm.dob, '%d-%b-%Y') dob, ");
            sb.Append("  pm.Age, DATE_FORMAT(pm.dob, '%d-%b-%Y') dob,DATE_FORMAT(max(lt.Date), '%d-%b-%Y %h:%I %p') visitdate, pm.State, pm.City, pm.Locality,0 PreBookingID,Date_Format(pm.dtEntry,'%d-%c-%Y')dtEntry  ");
            sb.Append(" FROM patient_master pm ");
            sb.Append("INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` ");

            if (Patient_ID != string.Empty)
            {
                sb.Append(" Where pm.patient_id= '"+Patient_ID +"' ");
            }
            else
            {
                sb.Append(" WHERE pm.patient_id <> ''  ");
            }

            if (PName == string.Empty && Patient_ID == string.Empty && MobileNo == string.Empty)
            {
                sb.Append(" AND lt.Date>=@FromRegDate AND lt.Date<=@ToRegDate ");
            }
            if (PName != string.Empty)
                sb.Append(" AND pm.pname LIKE @PName ");
            if (MobileNo != string.Empty)
                sb.Append(" AND pm.mobile = @MobileNo ");
            if (DOB != string.Empty)
                sb.Append(" AND pm.dob=@DOB ");
            if (localityID != "0" && localityID != string.Empty && localityID != null && MobileNo == string.Empty && PName == string.Empty && Patient_ID == string.Empty)
                sb.Append(" AND pm.localityid=@localityid ");
            if (cityID != "0" && cityID != string.Empty && cityID != null && MobileNo == string.Empty && PName == string.Empty && Patient_ID == string.Empty)
                sb.Append("  AND pm.cityid=@cityid ");
            if (stateID != string.Empty && MobileNo == string.Empty && PName == string.Empty && Patient_ID == string.Empty)
                sb.Append(" AND pm.stateid=@stateid ");
            sb.Append(" group by pm.`Patient_ID` order by lt.Date desc ");

            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {



                  da.SelectCommand.Parameters.AddWithValue("@FromRegDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00"));
                  da.SelectCommand.Parameters.AddWithValue("@ToRegDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59"));
                if (PName != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@PName", string.Format("{0}%", PName));
                if (MobileNo != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@MobileNo", MobileNo);
                if (DOB != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@DOB", Util.GetDateTime(DOB).ToString("yyyy-MM-dd"));
                if (localityID != "0" && localityID != string.Empty && localityID != null && MobileNo == string.Empty && PName == string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@localityid", localityID);
                if (cityID != "0" && cityID != string.Empty && cityID != null && MobileNo == string.Empty && PName == string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@cityid", cityID);
                if (stateID != string.Empty && MobileNo == string.Empty && PName == string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@stateid", stateID);

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    return JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string getBarcode(List<SampleSearch> data)
    {
        string Test_ID = string.Empty;
        if (Util.GetString(data[0].Test_ID).Trim() != string.Empty)
            Test_ID = String.Join(",", data.Select(a => String.Join(", ", a.Test_ID)));
        if (Util.GetString(data[0].LedgerTransactionNo).Trim() == string.Empty && Util.GetString(data[0].BarcodeNo).Trim() == string.Empty && Test_ID == string.Empty)
        {
            return string.Empty;
        }
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT  ");
            sb.Append(" CONCAT_WS(',', ");
            //sb.Append(" pm.`Patient_ID`,SUBSTR(pm.`PName`,1,20) ,CONCAT(pm.`AgeYear`,'Y-',pm.`AgeMonth`,'M-',pm.`AgeDays`,'D' ),pli.`BarcodeNo`,SUBSTR(pm.`Gender`,1,1), ");
            //sb.Append(" pli.`SampleTypeName`,GROUP_CONCAT(im.`TestCode` SEPARATOR '/'),pli.`LedgerTransactionNo`, ");
            //sb.Append(" DATE_FORMAT(pli.`SampleCollectionDate`,'%d-%b-%y %h:%i %p') ");
            //sb.Append(" ) str ");
            sb.Append(" CONCAT(SUBSTR(pm.`PName`, 1, 20),' ',CONCAT(pm.`AgeYear`,'Y'),'/',SUBSTR(pm.`Gender`, 1, 1)),SUBSTR(sb.Name,1,3),'',Concat(pli.`BarcodeNo`,IFNULL(lm.`Suffix`, '')),'',");
            sb.Append(" CONCAT(pli.`SampleTypeName`,'  ', DATE_FORMAT(pli.`SampleCollectionDate`,'%d-%b-%y')),GROUP_CONCAT(distinct im.`TestCode` SEPARATOR '/'),pli.`LedgerTransactionNo`,'') str");
            sb.Append(" FROM `patient_labinvestigation_opd` pli  ");
            sb.Append("  INNER JOIN f_subcategorymaster sb ON pli.subcategoryid=sb.subcategoryID");
            sb.Append(" INNER JOIN `f_itemmaster` im ON im.`Type_ID`=pli.`Investigation_ID` and (pli.`IsSampleCollected`='S' OR pli.`IsSampleCollected`='Y' ) ");
            sb.Append(" INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=pli.`Investigation_ID` AND ist.`IsDefault`=1  ");
            sb.Append("  LEFT JOIN   `labobservation_investigation` li ON pli.Investigation_id=li.Investigation_id ");
            sb.Append(" LEFT JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=li.`labObservation_ID` ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=pli.`Patient_ID` where pli.`IsRefund`=0  ");
            if (Util.GetString(data[0].LedgerTransactionNo).Trim() != string.Empty)
                sb.Append(" AND  pli.`LedgerTransactionNo`=@LedgerTransactionNo ");
            if (Util.GetString(data[0].BarcodeNo).Trim() != string.Empty)
                sb.Append(" AND  pli.`BarcodeNo`=@BarcodeNo ");
            if (Test_ID != string.Empty)
                sb.Append(" AND  pli.`Test_ID` IN ({0})  ");
          //  if (Test_ID != string.Empty)
            //    sb.Append(" GROUP BY pli.test_Id;");
          // else 
             //   sb.Append(" GROUP BY ist.SampleTypeID,lm.Suffix; ");
            sb.Append(" GROUP BY ist.SampleTypeID ORDER BY lm.suffix;");
          //  if (UserInfo.ID==1)
//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\bar.txt",sb.ToString());
            string[] ItemIDParamNames = null;
            string[] ItemIDTags = null; string ItemIDClause = string.Empty;
            if (Test_ID != string.Empty)
            {
                ItemIDTags = Test_ID.Split(',');
                ItemIDParamNames = ItemIDTags.Select((s, i) => "@tag" + i).ToArray();
                ItemIDClause = string.Join(", ", ItemIDParamNames);
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), ItemIDClause), con))
            {
                if (Util.GetString(data[0].LedgerTransactionNo).Trim() != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionNo", data[0].LedgerTransactionNo);
                if (Util.GetString(data[0].BarcodeNo).Trim() != string.Empty)
                    da.SelectCommand.Parameters.AddWithValue("@BarcodeNo", data[0].BarcodeNo);

                if (Test_ID != string.Empty)
                {
                    for (int i = 0; i < ItemIDParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(ItemIDParamNames[i], ItemIDTags[i]);
                    }
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    foreach (DataRow dr in dt.Rows)
                        sb.Append(dr["str"] + "^");
                    string s = sb.ToString().Trim('^');
                    return s;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string getDiscountApproval(string centreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(dm.`EmployeeID`,'#',em.DiscountPerBill_per,'#',em.DiscountPerMonth,'#',em.DiscountOnPackage,'#',em.AppBelowBaseRate,'#',dm.DiscShareType)value,");
            sb.Append(" em.`Name` label ");
            sb.Append(" FROM discount_approval_master dm ");
            sb.Append(" INNER JOIN employee_master em ON dm.`EmployeeID`=em.`Employee_ID` AND dm.`CentreID`=@CentreID AND dm.isActive=1 group by em.Employee_ID ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CentreID", centreID)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string getfieldboy(string centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT fm.Name ,fm.FeildboyID id FROM feildboy_master fm ");
            sb.Append("  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fm.`FeildboyID` ");
            sb.Append("  AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID`=@CentreID) ");
            sb.Append("  WHERE fm.isactive=1 ORDER BY NAME ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreID", centreid)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string bindDiscountType(string Gender, DateTime DOB, int PanelID)
    {
        int age = ((DateTime.Now.Year - DOB.Year) * 372 + (DateTime.Now.Month - DOB.Month) * 31 + (DateTime.Now.Day - DOB.Day)) / 372;
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT dm.DiscountID,CONCAT(dm.DiscountName,'#',dm.DiscountPercentage,'#',dm.DiscShareType)DiscPer FROM discount_master dm WHERE IsActive=1 AND PanelID in('" + PanelID + "','0') AND (CURRENT_DATE() BETWEEN dm.FromDate AND dm.ToDate) ");
        if (Gender != string.Empty)
            sb.Append(" AND GENDER IN ('B', '" + Gender.Substring(0, 1) + "')");
        sb.Append(" AND (" + age + " BETWEEN dm.FromAge AND dm.ToAge)");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(dt);
            else
                return null;
        }
    }
    [WebMethod]
    public string bindDisType(string discountid, string panelid)
    {
        return StockReports.ExecuteScalar("select CONCAT(dm.DiscountName,'#',dm.DiscountPercentage,'#',dm.DiscShareType)  from discount_master dm where discountid='" + discountid + "' and panelid in ('" + panelid + "','0') ");
    }
    [WebMethod]
    public string updateDiscountType(string[] ItemData, int DiscountID, int PanelID)
    {
        string Item_ID = "'" + string.Join("','", ItemData) + "'";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT dm.DiscountID,dmi.ItemID,IFNULL(dm.DiscountPercentage,0)DiscountPercentage ");
        sb.Append(" FROM discount_master dm ");
        sb.Append(" INNER JOIN discount_master_item dmi ON dm.DiscountID=dmi.DiscountID  ");
        sb.Append(" WHERE dm.IsActive=1 AND dmi.IsActive=1  AND dmi.DiscountID='" + DiscountID + "'   AND dm.PanelID in('" + PanelID + "','0') AND dmi.ItemID IN (" + Item_ID + ") ");
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT '" + DiscountID + "' DiscountID,im.ItemID,0 DiscountPercentage FROM f_itemmaster im  ");
        sb.Append(" LEFT JOIN discount_master_item dmi ON dmi.ItemID=im.itemid AND dmi.DiscountID='" + DiscountID + "' AND dmi.IsActive=1  ");
        sb.Append("   WHERE  im.ItemID IN (" + Item_ID + ")  AND dmi.ItemID IS NULL ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(dt);
            else
                return null;
        }
    }
    [WebMethod(EnableSession = true)]
    public string GetsampleTypeWithLabNo(string investigationid, string LabNo)
    {
        investigationid = "'" + investigationid.TrimEnd(',') + "'";
        investigationid = investigationid.Replace(",", "','");
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(plo.HistoCytoSampleDetail,'')HistoCytoSampleDetail, IFNULL(plo.barcodeno,'')barcodeno,im.investigation_id,NAME,im.Container, ");
        sb.Append(" if(IFNULL(plo.barcodeno,'')='',IFNULL(GROUP_CONCAT(CONCAT(inv.sampletypeid,'|',inv.sampletypename) ORDER BY isdefault DESC SEPARATOR  '^'  ),'1|NA'),CONCAT(plo.sampletypeid,'|',plo.sampletypename)) sampleinfo ");
        sb.Append(" FROM investigation_master im  LEFT JOIN investigations_sampletype inv ON inv.investigation_id=im.investigation_id  ");
        sb.Append(" left join patient_labinvestigation_opd plo on plo.investigation_id=im.investigation_id  and plo.LedgerTransactionID='" + LabNo + "'");
        sb.Append(" where im.investigation_id in (" + investigationid + ") GROUP BY im.investigation_id ORDER BY barcodeno,inv.sampletypename ");
        sb.Append("");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public Tuple<string, int> BindPatientImage(string PatientID, string dtEntry)
    {
        if (Resources.Resource.ShowPatientPhoto == "1")
        {
            var base64Image = string.Empty;
            string pathname = string.Concat(Resources.Resource.DocumentPath, "\\PatientPhoto\\", dtEntry.ToString().Split('-')[2] + "\\", dtEntry.ToString().Split('-')[1] + "\\", PatientID.ToString().Replace("/", "_").Replace("/", "_").Replace("/", "_") + ".jpg");
            if (System.IO.File.Exists(pathname))
            {
                byte[] byteArray = System.IO.File.ReadAllBytes(pathname);
                string base64 = Convert.ToBase64String(byteArray);
                base64Image = string.Format("data:image/jpg;base64,{0}", base64);
            }
            int documentCount = 0;
            string documentFolderPath = string.Concat(Resources.Resource.DocumentPath, "\\PatientDocument\\", PatientID.ToString().Replace("/", "_").Replace("/", "_").Replace("/", "_"), "\\");
            System.IO.DirectoryInfo dir = new System.IO.DirectoryInfo(documentFolderPath);
            if (dir.Exists)
            {
                documentCount = dir.GetFiles().Length;
            }
            return Tuple.Create(base64Image, documentCount);

        }
        else
        {
            return Tuple.Create(default(string), default(int));
        }

    }
    [WebMethod(EnableSession = true)]
    public string saveSecondRef(string SecondRefName, string Mobile, string centreid, string Email, string Address)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Mobile.Trim() != string.Empty)
            {

                sb.Append(" SELECT COUNT(1) FROM `secondreference_booking` dr  ");
                sb.Append(" WHERE dr.`CentreID`=@CentreID AND dr.Mobile=@Mobile AND dr.`IsActive`=1");
                if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                      new MySql.Data.MySqlClient.MySqlParameter("@Mobile", Mobile.Trim()),
                      new MySql.Data.MySqlClient.MySqlParameter("@CentreID", centreid.Trim()))) > 0)
                {

                    return JsonConvert.SerializeObject(new { status = false, responseMsg = SecondRefName, response = string.Empty });
                }

            }
            sb = new StringBuilder();
            sb.Append(" INSERT INTO secondreference_booking (SecondRefName,Mobile,CentreID,CreatedByID,Email,Address,CreatedBy) ");
            sb.Append(" values (@DoctorName,@Mobile,@CentreID,@CreatedByID,@Email,@Address,@CreatedBy); ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@DoctorName", SecondRefName.Trim()),
                 new MySqlParameter("@Mobile", Mobile.Trim()),
                 new MySqlParameter("@CentreID", centreid),
                 new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                 new MySqlParameter("@Email", Email.Trim()),
                 new MySqlParameter("@Address", Address.Trim()));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT @@Identity ") });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred", responseMsg = "Error Occurred" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public string GetRequestedCamp(string ItemID, string type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            List<string> ItemIDLength = ItemID.Split(',').ToList();
            StringBuilder sb = new StringBuilder();
            DataTable dtMerge = new DataTable();
            for (int i = 0; i < ItemIDLength.Count; i++)
            {
                if (type == string.Empty)
                {
                    type = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT if(SubcategoryID='15','Package','Test') type from f_itemmaster where ItemID=@ItemID",
                                                      new MySqlParameter("@ItemID", ItemIDLength[i])));
                }
                sb = new StringBuilder();
                if (type == "Test")
                {
                    sb.Append(" SELECT  @type type,IFNULL( im.testcode,'')testCode,typeName,");
                    sb.Append(" IF(im.TestCode='',typeName,CONCAT(im.TestCode,'~',typeName)) Item,im.`ItemID`,im.subcategoryid, ");
                    sb.Append(" CAST(imm.`Investigation_Id` AS CHAR)Investigation_Id ");
                    sb.Append(" FROM f_itemmaster im INNER JOIN investigation_master imm ON im.`Type_ID`=imm.`Investigation_Id` AND im.`ItemID`=@ItemID");
                }
                else
                {
                    sb.Append("SELECT  @type type, IFNULL( im.testcode,'')testCode,typeName,");
                    sb.Append(" IF(im.TestCode='',typeName,CONCAT(im.TestCode,'~',typeName)) Item,im.`ItemID`,im.subcategoryid,");
                    sb.Append(" GROUP_CONCAT(CAST(imm.Investigation_Id AS CHAR)) Investigation_Id  ");
                    sb.Append(" FROM f_itemmaster im  ");
                    sb.Append(" INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID   ");
                    sb.Append(" INNER JOIN investigation_master imm  ON imm.Investigation_Id=pld.InvestigationID AND  im.`ItemID`=@ItemID ");
                    sb.Append(" GROUP BY im.ItemID  ");
                }
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                  new MySqlParameter("@type", type),
                                                  new MySqlParameter("@ItemID", ItemIDLength[i].ToString())).Tables[0])
                    dtMerge.Merge(dt);
            }
            return JsonConvert.SerializeObject(dtMerge);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}