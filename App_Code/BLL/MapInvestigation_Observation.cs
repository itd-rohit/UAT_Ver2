using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for MapInvestigation_Observation
/// </summary>
public class MapInvestigation_Observation
{
    
   
    public DataTable Get_Observation(string InvestigationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT LOM.LabObservation_ID, LOM.Name as ObsName,LOM.Minimum,LOM.Maximum,LOM.MinFemale,LOM.MaxFemale,LOM.MinChild,LOM.MaxChild,LOM.ReadingFormat, '0' printOrder,'0' Child_Flag  FROM labobservation_master lom WHERE lom.LabObservation_ID NOT IN   ");
            sb.Append(" (SELECT loi.labObservation_ID FROM labobservation_investigation loi WHERE   ");
            sb.Append(" loi.Investigation_Id=@InvID) GROUP BY lom.name ORDER BY lom.name ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@InvID", InvestigationID)).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public DataTable Bind_Investigation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select inv.Name ,inv.Investigation_id from f_itemmaster im  inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID");
        sb.Append(" inner join f_configrelation c on c.CategoryID=sc.CategoryID inner join investigation_master inv on inv.Investigation_id=im.Type_id");
        sb.Append(" and c.ConfigRelationID='3' and inv.ReportType=1 and im.IsActive=1 order by inv.Name ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public DataTable BindInvListBox()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        
        try
        {
         StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.Name,CAST(concat(ifnull(om.ObservationType_ID,''),'$',ifnull(om.Name,''),'$',ifnull(im.Name,''),'$',ifnull(im.Type,''),'$',  ");
        sb.Append(" ifnull(im.ReportType,''),'$',ifnull(im.Print_Sequence,''),'$',ifnull(im.Investigation_Id,''),'$',ifnull(io.Investigation_ObservationType_ID,''),'$',ifnull(it.ItemID,''),'$',ifnull(im.TimeLimit,''),'$',ifnull(it.Inv_ShortName,''),'$',ifnull(it.IsTrigger,''),'$', ");
        sb.Append(" ifnull(im.SampleQty,''),'$',ifnull(im.SampleRemarks,''),'$',ifnull(im.GenderInvestigate,''),'$',ifnull(im.container,'1'),'$',ifnull(im.printHeader,''),'$',ifnull(im.ShowFlag,''),'$',ifnull(im.ShowOnline,''),'$',ifnull(im.isAutoStore,''),'$',ifnull(it.TestCode,''),'$',ifnull(im.isUrgent,''),'$',ifnull(im.Reporting,''),'$',ifnull(it.MaxDiscount,''),'$',ifnull(it.Booking,''),'$' ");
        sb.Append(" ,IFNULL(it.BillCategoryID, ''),'$',it.IsActive,'$', IFNULL(im.IsOrganism,''),'$',IFNULL(im.IsCulture,''),'$',IFNULL(im.PrintSampleName,''), '$',");
        sb.Append("  IFNULL(GROUP_CONCAT(CONCAT(ios.`SampleTypeID`,'|',ios.`SampleTypeName`)ORDER BY ios.`IsDefault` DESC SEPARATOR '#'),'') ,'$',IFNULL(im.IsMic,''),'$',IFNULL(im.PrintSeparate, ''),'$'  ,IFNULL(fr.Rate, '0'),'$',ifnull(autoconsumeoption,'0'),'$',ifnull(it.Bill_Category,'0'),'$',ifnull(im.ConsentType,''),'$',ifnull(im.labalert,''),'$',ifnull(im.smsonalert,''),'$',ifnull(im.logistictemp,''),'$',ifnull(im.fromage,''),'$',ifnull(im.toage,''),'$',ifnull(im.invtype,''),'$',ifnull(im.SampleDefined,'0'),'$' ,ifnull(im.RequiredAttachmentID,''),'$',ifnull(it.IsRequiredQuantity,''),'$',IFNULL(im.PrintTestCentre, 0),'$'  ) ");
        sb.Append(" AS CHAR) newValue FROM observationtype_master om  ");
        sb.Append(" INNER JOIN investigation_observationtype io ON om.ObservationType_ID = io.ObservationType_Id   ");
        
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id = io.Investigation_ID   ");
        sb.Append(" AND im.Name<>'' ");
        sb.Append(" INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID and it.isactive=0 ");
        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID    ");
        sb.Append(" INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigRelationID=3   ");
        sb.Append(" LEFT JOIN `investigations_sampletype` ios ON ios.`Investigation_ID`=im.`Investigation_Id` ");
        sb.Append(" LEFT JOIN f_ratelist fr on fr.itemID=it.ItemID and fr.Panel_Id='78' ");
        sb.Append(" GROUP BY im.`Investigation_Id` ");
        sb.Append(" ORDER BY im.Name ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
                       
             
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

    public DataTable BindInvListBox(string Dept)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.Name,it.Bill_Category,CAST(concat(ifnull(om.ObservationType_ID,''),'$',ifnull(om.Name,''),'$',ifnull(im.Name,''),'$',ifnull(im.Type,''),'$',  ");
            sb.Append(" ifnull(im.ReportType,''),'$',ifnull(im.Print_Sequence,''),'$',ifnull(im.Investigation_Id,''),'$',ifnull(io.Investigation_ObservationType_ID,''),'$',ifnull(it.ItemID,''),'$',ifnull(im.TimeLimit,''),'$',ifnull(it.Inv_ShortName,''),'$',ifnull(it.IsTrigger,''),'$', ");
            sb.Append(" ifnull(im.SampleQty,''),'$',ifnull(im.SampleRemarks,''),'$',ifnull(im.GenderInvestigate,''),'$',ifnull(im.container,'1'),'$',ifnull(im.printHeader,''),'$',ifnull(im.ShowFlag,''),'$',ifnull(im.ShowOnline,''),'$',ifnull(im.isAutoStore,''),'$',ifnull(it.TestCode,''),'$',ifnull(im.isUrgent,''),'$',ifnull(im.Reporting,''),'$',ifnull(it.MaxDiscount,''),'$',ifnull(it.Booking,''),'$' ");
            sb.Append(" ,IFNULL(it.BillCategoryID, ''),'$',it.IsActive,'$', IFNULL(im.IsOrganism,''),'$',IFNULL(im.IsCulture,''),'$',IFNULL(im.PrintSampleName,''), '$',");
            sb.Append("  IFNULL(GROUP_CONCAT(CONCAT(ios.`SampleTypeID`,'|',ios.`SampleTypeName`)ORDER BY ios.`IsDefault` DESC SEPARATOR '#'),'') ,'$',IFNULL(im.IsMic,''),'$',IFNULL(im.PrintSeparate, ''),'$'  ,IFNULL(fr.Rate, '0'),'$',ifnull(autoconsumeoption,'0'),'$',ifnull(it.Bill_Category,'0'),'$',ifnull(im.ConsentType,''),'$',ifnull(im.labalert,''),'$',ifnull(im.smsonalert,''),'$',ifnull(im.logistictemp,''),'$',ifnull(im.fromage,''),'$',ifnull(im.toage,''),'$',ifnull(im.invtype,''),'$',ifnull(im.SampleDefined,'0'),'$' ,ifnull(im.RequiredAttachmentID,''),'$',IFNULL(it.`BaseRate`,''),'$',IFNULL(im.`AttchmentRequiredAt`,''),'$',ifnull(im.IsLMPRequired,''),'$',ifnull(im.LMPFormDay,''),'$',ifnull(im.LMPToDay,''),'$' ,ifNULL(it.IsRequiredQuantity,0),'$',ifNULL(im.tatintimation,0),'$',IFNULL(it.ShowInRateList, 0),'$',IFNULL(im.PrintTestCentre, 0),'$' ,IFNULL(im.Show_In_TAT, 0),'$' ) ");//,ifNULL(im.IsDeptNo,0),'$' 
            sb.Append(" AS CHAR) newValue FROM observationtype_master om  ");
            sb.Append(" INNER JOIN investigation_observationtype io ON om.ObservationType_ID = io.ObservationType_Id   ");
            if (Dept != "ALL")
                sb.Append(" and io.ObservationType_Id=@Dept");
            sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id = io.Investigation_ID   ");
            sb.Append(" AND im.Name<>'' ");
            sb.Append(" INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID and it.isactive=1 ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID    ");
            sb.Append(" INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigRelationID=3   ");
            sb.Append(" LEFT JOIN `investigations_sampletype` ios ON ios.`Investigation_ID`=im.`Investigation_Id` ");
            sb.Append(" LEFT JOIN f_ratelist fr on fr.itemID=it.ItemID and fr.Panel_Id='78' ");
            sb.Append(" GROUP BY im.`Investigation_Id` ");
            sb.Append(" ORDER BY im.Name ");
			//System.IO.File.WriteAllText(@"C:\itdose\Livecode\Droplet_Live_New\Droplet\App_Code\BLL\invent.txt",sb.ToString());
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Dept", Dept)).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetObservation_Data(string InvestigationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select IM.Investigation_Id,IM.Name,LOM.LabObservation_ID,Concat(Loi.Prefix,LOM.Name) as ObsName,LOI.IsCritical,loi.Child_Flag,LOI.SampleTypeID,LOI.SampleTypeName,LOI.MethodName,Loi.Prefix,LOM.IsComment,'' Help,'' ReadingFormat,loi.IsBold,loi.IsUnderLine,IM.IsMic,loi.SepratePrint,loi.isautoconsume,loi.isamr,loi.isreflex,loi.helpvalueonly chkhelp,loi.MICROSCOPY,loi.ParentId  from investigation_master IM inner join labobservation_investigation LOI");
            sb.Append(" on IM.Investigation_Id=LOI.Investigation_Id inner join labobservation_master LOM on");
            sb.Append(" LOI.labObservation_ID=LOM.LabObservation_ID and  IM.Investigation_Id=@InvestigationID ");
            sb.Append(" order by loi.printOrder");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@InvestigationID", InvestigationID)).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetObservation_Data2(string InvestigationID, string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select IM.Investigation_Id,IM.Name,LOM.LabObservation_ID,Concat(Loi.Prefix,LOM.Name) as ObsName,LOI.IsCritical,loi.Child_Flag,LOI.SampleTypeID,LOI.SampleTypeName,LOI.MethodName,Loi.Prefix,LOM.IsComment,h.Help,lr2.ReadingFormat,IM.IsMic,loi.IsBold,loi.IsUnderLine from investigation_master IM inner join labobservation_investigation LOI");
            sb.Append(" on IM.Investigation_Id=LOI.Investigation_Id inner join labobservation_master LOM on");
            sb.Append(" LOI.labObservation_ID=LOM.LabObservation_ID and  IM.Investigation_Id=@InvestigationID ");
            sb.Append(" LEFT OUTER JOIN ");
            sb.Append(" (SELECT GROUP_CONCAT(concat(lhm.Help,'#',if(ifnull(lhm.ShortKey,'')='',lhm.Help,lhm.ShortKey) ) ORDER BY IF(IFNULL(lhm.ShortKey,'')='',lhm.Help,lhm.ShortKey) SEPARATOR '|' )Help,loh.labObservation_ID  ");
            sb.Append(" FROM LabObservation_Help loh  ");
            sb.Append(" INNER JOIN LabObservation_Help_Master lhm ON lhm.id=loh.HelpId  ");
            sb.Append(" GROUP BY loh.LabObservation_ID ) h ON h.LabObservation_ID = lom.LabObservation_ID ");
            sb.Append(" INNER JOIN (   ");
            sb.Append(" SELECT lt.Patient_ID,IF(pm.DOB = '0001-01-01',pm.Age,DATEDIFF(NOW(),pm.DOB)/365)AGE,  ");
            sb.Append(" IF(pm.DOB = '0001-01-01',  ");
            sb.Append(" (CASE WHEN pm.AGE LIKE '%DAY%' THEN ((TRIM(REPLACE(pm.AGE,'DAY(S)',''))+0))  ");
            sb.Append(" WHEN pm.AGE LIKE '%MONTH%' THEN ((TRIM(REPLACE(pm.AGE,'MONTH(S)',''))+0)*30)  ");
            sb.Append(" ELSE ((TRIM(REPLACE(pm.AGE,'YRS',''))+0)*365) END),   ");
            sb.Append(" DATEDIFF(NOW(),pm.DOB))AGE_in_Days,pm.Gender,lt.LedgerTransactionNo   ");
            sb.Append(" FROM f_ledgertransaction lt INNER JOIN patient_master pm ON pm.Patient_ID = lt.Patient_ID    ");
            sb.Append(" WHERE lt.LedgerTransactionNo=@LabNo	)aa ON 1=1  ");
            sb.Append(" LEFT OUTER JOIN labobservation_range lr2 ON lr2.Gender=LEFT(aa.Gender,1) ");
            sb.Append(" AND lr2.FromAge<=if(aa.AGE_in_Days=0,4381,aa.AGE_in_Days) AND lr2.ToAge>=if(aa.AGE_in_Days=0,4381,aa.AGE_in_Days)  ");
            sb.Append(" AND lr2.LabObservation_ID=lom.LabObservation_ID AND   IFNULL(lr2.macID,'1') = '1' and lr2.CentreID=@Centre ");
            sb.Append(" order by loi.printOrder");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@InvestigationID", InvestigationID), new MySqlParameter("@LabNo", LabNo), new MySqlParameter("@Centre", UserInfo.Centre)).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetMapObservation(string LabObservationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT GROUP_CONCAT(concat(im.Name,'-',im.TestCode) SEPARATOR ' ,')InvName FROM labobservation_investigation li INNER JOIN investigation_master im ON li.Investigation_Id=im.Investigation_Id AND li.labObservation_ID=@LabObservationID");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@LabObservationID", LabObservationID)).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public string SaveMapping(string InvestigationID, string ObsData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // ObsData= ObservationId|Prefix|SampleTypeName|SampleTypeID|Method|Header|IsCritical#
            ObsData = ObsData.TrimEnd('#');
            StringBuilder sb = new StringBuilder();
            int len = Util.GetInt(ObsData.Split('#').Length);
            string[] Data = new string[len];
            Data = ObsData.Split('#');
            for (int i = 0; i < len; i++)
            {
                sb = new StringBuilder();
                sb.Append("Update labobservation_investigation Set printOrder=@printOrder,Prefix=@Prefix,SampleTypeName=@SampleTypeName,MethodName=@MethodName,");
                sb.Append(" Child_Flag=@Child_Flag,IsCritical=@IsCritical,UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateRemarks='',UpdateDate=@UpdateDate,");
                sb.Append(" IsBold=@IsBold,IsUnderLine=@IsUnderLine,SepratePrint=@SepratePrint,isautoconsume=@isautoconsume,isamr=@isamr,isreflex=@isreflex,");
                sb.Append(" helpvalueonly=@helpvalueonly,MICROSCOPY=@MICROSCOPY,ParentId=@ParentId ");
                sb.Append(" where labObservation_ID=@labObservation_ID AND Investigation_Id=@Investigation_Id ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(), new MySqlParameter("@printOrder", (Util.GetInt(i) + 1)),
                   new MySqlParameter("@Prefix", Util.GetString(Data[i].Split('|')[1])), new MySqlParameter("@UpdateDate", DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss")),
                   new MySqlParameter("@SampleTypeName", Util.GetString(Data[i].Split('|')[2])),
                   new MySqlParameter("@MethodName", Util.GetString(Data[i].Split('|')[4])),
                   new MySqlParameter("@Child_Flag", Data[i].Split('|')[5].ToString()),
                   new MySqlParameter("@IsCritical", Data[i].Split('|')[6].ToString()),
                   new MySqlParameter("@UpdateID", HttpContext.Current.Session["ID"].ToString()),
                   new MySqlParameter("@UpdateName", HttpContext.Current.Session["LoginName"].ToString()),
                   new MySqlParameter("@IsBold", Data[i].Split('|')[8].ToString()),
                   new MySqlParameter("@IsUnderLine", Data[i].Split('|')[9].ToString()),
                   new MySqlParameter("@SepratePrint", Data[i].Split('|')[10].ToString()),
                   new MySqlParameter("@isautoconsume", Data[i].Split('|')[11].ToString()),
                   new MySqlParameter("@isamr", Data[i].Split('|')[12].ToString()),
                   new MySqlParameter("@isreflex", Data[i].Split('|')[13].ToString()),
                   new MySqlParameter("@helpvalueonly", Data[i].Split('|')[14].ToString()),
                   new MySqlParameter("@MICROSCOPY", Data[i].Split('|')[15].ToString()),
                   new MySqlParameter("@ParentId", Data[i].Split('|')[16].ToString()),
                   new MySqlParameter("@labObservation_ID", Data[i].Split('|')[0].ToString()),
                   new MySqlParameter("@Investigation_Id", InvestigationID)
                   );
                sb = new StringBuilder();
                sb.Append("Update labobservation_master Set IsComment = @IsComment where LabObservation_ID=@LabObservation_ID");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(), new MySqlParameter("@IsComment", Data[i].Split('|')[7].ToString()),
                   new MySqlParameter("@LabObservation_ID", Data[i].Split('|')[0]));
            }

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveObservation(string InvestigationID, string ObservationId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            string InvName = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select Name from investigation_master where Investigation_Id= @Investigation_Id", new MySqlParameter("@Investigation_Id", InvestigationID)));

            string ObsName = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT NAME FROM `labobservation_master` WHERE labobservation_ID= @labobservation_ID", new MySqlParameter("@labobservation_ID", ObservationId)));

            int MaxPrintOrder = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select max(printOrder) from labobservation_investigation where Investigation_Id= @Investigation_Id", new MySqlParameter("@Investigation_Id", InvestigationID)));
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Insert into labobservation_investigation(Investigation_Id,labObservation_ID,printOrder,Creator_ID) values(@Investigation_Id,@ObservationId,@printOrder,@Creator_ID)  ",
                new MySqlParameter("@Investigation_Id", InvestigationID),
                new MySqlParameter("@ObservationId", ObservationId),
                new MySqlParameter("@printOrder", MaxPrintOrder + 1),
                new MySqlParameter("@Creator_ID", UserInfo.ID));

            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,`Status`, ");
            sb1.Append(" UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID,OLDNAME,NEWNAME,Remarks,StatusID) ");
            sb1.Append(" VALUES('','Observation Changes','" + HttpContext.Current.Session["ID"].ToString() + "', ");
            sb1.Append(" '" + HttpContext.Current.Session["LoginName"].ToString() + "',NOW(), ");
            sb1.Append(" '" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb1.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',");
            sb1.Append(" '','',");
            sb1.Append(" '','',");
            sb1.Append(" '" + ObsName + " Observation Added In " + InvName + "',59 ); ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb1.ToString());

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string RemoveObservation(string InvestigationID, string ObservationId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string InvName = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select Name from investigation_master where Investigation_Id= @Investigation_Id", new MySqlParameter("@Investigation_Id", InvestigationID)));

            string ObsName = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT NAME FROM `labobservation_master` WHERE labobservation_ID= @labobservation_ID", new MySqlParameter("@labobservation_ID", ObservationId)));

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from  labobservation_investigation where labObservation_ID=@ObservationId and Investigation_Id=@InvestigationID  ", new MySqlParameter("@ObservationId", ObservationId), new MySqlParameter("@InvestigationID", InvestigationID));

            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,`Status`, ");
            sb1.Append(" UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID,OLDNAME,NEWNAME,Remarks,StatusID) ");
            sb1.Append(" VALUES('','Observation Changes','" + HttpContext.Current.Session["ID"].ToString() + "', ");
            sb1.Append(" '" + HttpContext.Current.Session["LoginName"].ToString() + "',NOW(), ");
            sb1.Append(" '" + StockReports.getip() + "','" + UserInfo.Centre + "', ");
            sb1.Append(" '" + HttpContext.Current.Session["RoleID"].ToString() + "',");
            sb1.Append(" '','',");
            sb1.Append(" '','',");
            sb1.Append(" '" + ObsName + " Observation Removed In " + InvName + "',59 ); ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb1.ToString());

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveNewInvestigation(string InvName, string TestCode, string DepartmentID, string DepartmentName, string ReportType, string SampleType, string ShortName, string IsOutSrc, string TimeLimit, string SampleQty, string SampleRmks, string ColorCode, string Gender, string showPtRpt, string ShowAnlysRpt, string ShowOnlnRpt, string IsAutoStore, string isUrgent, string SampleTypeID, string MaxDiscount, string Reporting, string Booking, int IsActive, string BillCategoryID, string IsOrganism, string IsCulture, string IsMic, string PrintSeparate, string PrintSampleName, string Rate, string autoconsume, string BillingCategory, string ConsentType, string labalert, string smstext, string temp, string fromage, string toage, string invtype, string sampledefined, string RequiredAttachment, string BaseRate, string AttchmentRequiredAt, string IsLMPRequired, string LMPDay, string IsQuantity, string TatIntimate, string ShowInRateList,  string ShowinTAT, string PrintTestCentre)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(14);
        int ReqCount = MT.GetIPCount(14);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int InvCount = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select count(1) from investigation_master where LOWER(TRIM(NAME))=@InvName",
                new MySqlParameter("@InvName", InvName.Trim().ToLower())));
            if (InvCount > 0)
            {
                Tranx.Rollback();
                return "0";
            }
            int testCodeQty = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select count(1) from investigation_master where LOWER(TRIM(testcode))=@Testcode",
                new MySqlParameter("@Testcode", TestCode.Trim().ToLower())));
            if (testCodeQty > 0)
            {
                Tranx.Rollback();
                return "-1";
            }
            int maxprintseq = 0;
            maxprintseq = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT MAX(Print_Sequence) Print_Sequence FROM investigation_master im INNER JOIN investigation_observationtype io ON io.Investigation_ID=im.Investigation_Id WHERE ObservationType_Id=@DeptID ",
                new MySqlParameter("@DeptID", DepartmentID)));

            //if (ColorCode == "" || ColorCode == "null")
            //{
            //    ColorCode = "#";
            //}
            int Investigation_ID = 0;
            Investigation_Master objInvestigation_Master = new Investigation_Master(Tranx);
            objInvestigation_Master.Creator_ID = HttpContext.Current.Session["ID"].ToString();
            objInvestigation_Master.Name = InvName.Trim();
            objInvestigation_Master.Description = "";
            objInvestigation_Master.Ownership = "Public";
            objInvestigation_Master.ReportType = Util.GetInt(ReportType);
            objInvestigation_Master.FileLimitationName = "";
            objInvestigation_Master.Group_ID = "";
            objInvestigation_Master.Type = SampleType;
            objInvestigation_Master.Print_Sequence = Util.GetInt(maxprintseq + 1);
            objInvestigation_Master.TimeLimit = TimeLimit.Trim();
            objInvestigation_Master.SampleQty = Util.GetString(SampleQty);
            objInvestigation_Master.SampleRemarks = SampleRmks;
            objInvestigation_Master.GenderInvestigate = Gender;
            objInvestigation_Master.ColorCode = ColorCode;
            objInvestigation_Master.printHeader = Util.GetInt(showPtRpt);
            objInvestigation_Master.ShowFlag = Util.GetInt(ShowAnlysRpt);
            objInvestigation_Master.ShowOnline = Util.GetInt(ShowOnlnRpt);
            objInvestigation_Master.isAutoStore = Util.GetInt(IsAutoStore);
            objInvestigation_Master.isUrgent = Util.GetInt(isUrgent);
            objInvestigation_Master.ShowinTAT = Util.GetInt(ShowinTAT);
            objInvestigation_Master.Reporting = Util.GetInt(Reporting);
            objInvestigation_Master.IsOrganism = Util.GetInt(IsOrganism);
            objInvestigation_Master.IsCulture = Util.GetInt(IsCulture);
            objInvestigation_Master.PrintSampleName = Util.GetInt(PrintSampleName);
            objInvestigation_Master.TestCode = Util.GetString(TestCode);
            objInvestigation_Master.IsMic = Util.GetInt(IsMic);
            objInvestigation_Master.PrintSeparate = Util.GetInt(PrintSeparate);

            Investigation_ID =Util.GetInt( objInvestigation_Master.Insert());

            if (ReportType == "1" || ReportType == "3")
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_investigation_role (Investigation_ID,roleid,invname,rolename,updatedate) VALUES(@InvID,@roleid,@invname,@rolename,NOW())", new MySqlParameter("@InvID", Investigation_ID),
                    new MySqlParameter("@roleid", 11),
                    new MySqlParameter("@invname", InvName.Trim()),
                    new MySqlParameter("@rolename", "Laboratory"));
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_investigation_role (Investigation_ID,roleid,invname,rolename,updatedate) VALUES(@InvID,@roleid,@invname,@rolename,NOW())", new MySqlParameter("@InvID", Investigation_ID),
                   new MySqlParameter("@roleid", 15),
                   new MySqlParameter("@invname", InvName.Trim()),
                   new MySqlParameter("@rolename", "Radiology"));
            }

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO f_investigation_role (Investigation_ID,roleid,invname,rolename,updatedate) VALUES(@InvID,@roleid,@invname,@rolename,NOW())", new MySqlParameter("@InvID", Investigation_ID),
                   new MySqlParameter("@roleid", 6),
                   new MySqlParameter("@invname", InvName.Trim()),
                   new MySqlParameter("@rolename", "EDP"));

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update investigation_master set PrintTestCentre=@PrintTestCentre, tatintimation=@tatintimation, labalert=@labalert,smsonalert=@smstext,logistictemp=@temp, ConsentType=@ConsentType, autoconsumeoption=@autoconsume,fromage=@fromage,toage=@toage,container=@ColorCode,invtype=@invtype,SampleDefined=@sampledefined,RequiredAttachment=@RequiredAttachment,RequiredAttachmentID=@RequiredAttachmentID,IsLMPRequired=@IsLMPRequired,LMPFormDay=@LMPFormDay,LMPToDay=@LMPToDay where Investigation_Id=@Investigation_ID ",
                new MySqlParameter("@PrintTestCentre", PrintTestCentre),
                   new MySqlParameter("@tatintimation", TatIntimate),
                   new MySqlParameter("@labalert", labalert),
                   new MySqlParameter("@smstext", smstext),
                   new MySqlParameter("@temp", temp),
                   new MySqlParameter("@ConsentType", ConsentType),
                   new MySqlParameter("@autoconsume", autoconsume),
                   new MySqlParameter("@fromage", fromage),
                   new MySqlParameter("@toage", toage),
                   new MySqlParameter("@ColorCode", ColorCode),
                   new MySqlParameter("@invtype", invtype),
                   new MySqlParameter("@sampledefined", sampledefined),
                   new MySqlParameter("@RequiredAttachment", RequiredAttachment.Split('#')[0].TrimEnd('|')),
                   new MySqlParameter("@Investigation_ID", Investigation_ID),
                   new MySqlParameter("@RequiredAttachmentID", RequiredAttachment.Split('#')[1].TrimEnd('|')),
                   new MySqlParameter("@IsLMPRequired", IsLMPRequired),
                   new MySqlParameter("@LMPFormDay", LMPDay.Split('|')[0]),
                   new MySqlParameter("@LMPToDay", LMPDay.Split('|')[1]));

            Investigation_ObservationType objInves_ObservationType = new Investigation_ObservationType(Tranx)
            {
                ObservationType_ID = Util.GetInt(DepartmentID),
                Investigation_ID = Investigation_ID,
                Ownership = "Public",
                Creator_ID = UserInfo.ID
            };

            int InvObsId = objInves_ObservationType.Insert();

            int SubCategoryID = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select sc.SubCategoryID from f_subcategorymaster sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID where cf.ConfigRelationID=3 and sc.Name=@DepartmentName",
                new MySqlParameter("@DepartmentName", DepartmentName)));
            int ItemId = 0;
            if (SubCategoryID != 0)
            {
                ItemMaster objIMaster = new ItemMaster(Tranx);
                objIMaster.Type_ID = Investigation_ID;
                objIMaster.TypeName = InvName.Trim();
                objIMaster.SubCategoryID = SubCategoryID;
                objIMaster.IsActive = IsActive;
                objIMaster.Inv_ShortName = ShortName;
                objIMaster.IsTrigger = IsOutSrc;
                objIMaster.TestCode = TestCode;
                objIMaster.MaxDiscount = Util.GetInt(MaxDiscount);
                objIMaster.Booking = Util.GetInt(Booking);
                objIMaster.BillCategoryID = Util.GetInt(BillingCategory);
                ItemId =Util.GetInt( objIMaster.Insert().ToString());

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update f_itemmaster set BaseRate=@BaseRate,FromAge=@fromage,ToAge=@toage,Gender=@Gender,IsRequiredQuantity=@IsQuantity,ShowInRateList=@ShowInRateList where ItemID=@ItemId",
                    new MySqlParameter("@BaseRate", BaseRate),
                    new MySqlParameter("@fromage", fromage),
                    new MySqlParameter("@toage", toage),
                    new MySqlParameter("@Gender", Gender),
                    new MySqlParameter("@ItemId", ItemId),
                    new MySqlParameter("@IsQuantity", IsQuantity),
                    new MySqlParameter("@ShowInRateList", ShowInRateList));
                   

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update investigation_master set  AttchmentRequiredAt=@AttchmentRequiredAt, TestCode = @ItemId  WHERE Investigation_Id = @Investigation_ID",
                    new MySqlParameter("@AttchmentRequiredAt", AttchmentRequiredAt),
                    new MySqlParameter("@ItemId", ItemId),
                    new MySqlParameter("@Investigation_ID", Investigation_ID));
            }
            else
            {
                Tranx.Rollback();
                return "Error";
            }

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE ItemID =@ItemID AND  Panel_ID=@Panel_ID ",
              new MySqlParameter("@DeletedByID", UserInfo.ID),
              new MySqlParameter("@DeletedBy", UserInfo.LoginName),
              new MySqlParameter("@ItemID", ItemId),
              new MySqlParameter("@Panel_ID", "78"));

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from f_ratelist where ItemID=@ItemID and Panel_ID=@Panel_ID ", new MySqlParameter("@ItemID", ItemId), new MySqlParameter("@Panel_ID", "78"));

            RateList objRateList = new RateList(Tranx);
            objRateList.Panel_ID = 78;
            objRateList.ItemID = ItemId;
            objRateList.Rate =Util.GetDecimal( Rate);
            objRateList.IsTaxable = 0;
            objRateList.FromDate = DateTime.Now;
            objRateList.ToDate = DateTime.Now;
            objRateList.IsCurrent = 1;
            objRateList.IsService = "YES";
            objRateList.ItemDisplayName = Util.GetString(InvName);

            objRateList.ItemCode = Util.GetString(TestCode);
            objRateList.UpdateBy = HttpContext.Current.Session["LoginName"].ToString();
            objRateList.UpdateRemarks = "From Investigation Master";
            objRateList.UpdateDate = DateTime.Now;
            objRateList.Insert();          
            SampleTypeID = SampleTypeID.TrimEnd('#');
            if (SampleTypeID != "")
            {
                int len = Util.GetInt(SampleTypeID.Split('#').Length);
                string[] Data = new string[len];
                Data = SampleTypeID.Split('#');
                for (int i = 0; i < len; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("Insert into investigations_sampletype (`Investigation_ID`,`SampleTypeID`,`SampleTypeName`,`CreatedUserID`,`IsDefault`) values (@Investigation_ID,@SampleTypeID,@SampleTypeName,@CreatedUserID,@IsDefault)");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@Investigation_ID", Investigation_ID),
                      new MySqlParameter("@SampleTypeID", Util.GetString(Data[i].Split('|')[0])),
                      new MySqlParameter("@SampleTypeName", Util.GetString(Data[i].Split('|')[1])),
                      new MySqlParameter("@CreatedUserID", HttpContext.Current.Session["ID"].ToString()),
                      new MySqlParameter("@IsDefault", Util.GetString(Data[i].Split('|')[2])));
                }
            }
            StringBuilder sbbb = new StringBuilder();
            sbbb.Append(" insert into master_update_status(MasterName,MasterID,MasterIDName,Status,UserID,UserName,dtEntry,RoleID,CentreID,IpAddress,Remarks) ");
            sbbb.Append(" Values ('Investigation Master','" + Investigation_ID + "','" + InvName.Trim() + "','NEW','" + UserInfo.ID + "','" + UserInfo.LoginName + "',NOW(),'" + UserInfo.RoleID + "','" + UserInfo.Centre + "','" + StockReports.getip() + "','');");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbbb.ToString());
            Tranx.Commit();
            return string.Format("{0}${1}${2}${3}${4}${5}${6}${7}${8}${9}${10}${11}${12}${13}${14}${15}${16}${17}${18}${19}${20}${21}${22}|1", DepartmentID, DepartmentName, InvName, SampleType, ReportType, maxprintseq + 1, Investigation_ID, InvObsId, ItemId, TimeLimit, ShortName, IsOutSrc, SampleQty, SampleRmks, Gender, ColorCode, showPtRpt, ShowAnlysRpt, ShowOnlnRpt, IsAutoStore, TestCode, isUrgent, SampleTypeID);
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "Error";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string UpdateInvestigation(string InvName, string TestCode, string InvID, string ItemID, string DepartmentID, string InvObsId, string DepartmentName, string ReportType, string SampleType, string ShortName, string IsOutSrc, string TimeLimit, string SampleQty, string SampleRmks, string ColorCode, string Gender, string showPtRpt, string ShowAnlysRpt, string ShowOnlnRpt, string IsAutoStore, string isUrgent, string SampleTypeID, string MaxDiscount, string Reporting, string Booking, int IsActive, string BillCategoryID, string IsOrganism, string IsCulture, string IsMic, string PrintSeparate, string PrintSampleName, string Rate, string autoconsume, string BillingCategory, string ConsentType, string labalert, string smstext, string temp, string fromage, string toage, string invtype, string sampledefined, string RequiredAttachment, string BaseRate, string AttchmentRequiredAt, string IsLMPRequired, string LMPDay, string IsQuantity, string TatIntimate, string ShowInRateList, string ShowinTAT, string PrintTestCentre)
    {
        ManageIpAddressToManyRequest MT = new ManageIpAddressToManyRequest();
        bool b = MT.SaveRequestCount(15);
        int ReqCount = MT.GetIPCount(15);
        if (ReqCount > ABHABasicData.MaxRequestCountAllowed)
        {
            return "Too Many Request,Try Again after some";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            StringBuilder sb_1 = new StringBuilder();
            sb_1.Append(" SELECT Name,Description,ReportType,TimeLimit,isAutoStore,GenderInvestigate,ShowOnline,ShowFlag,");
            sb_1.Append(" printHeader,SampleRemarks,SampleQty,ColorCode,TestCode,isUrgent,Reporting,IsOrganism,isCulture,isMic, ");
            sb_1.Append(" PrintSeparate,PrintSampleName,autoconsumeoption,ConsentType,labalert,smsonalert,logistictemp,fromage,");
            sb_1.Append(" toage,container,invtype,SampleDefined,RequiredAttachment,AttchmentRequiredAt,RequiredAttachmentID, ");
            sb_1.Append(" IsLMPRequired,LMPFormDay,LMPToDay,tatintimation from Investigation_master ");
            sb_1.Append(" WHERE Investigation_ID='" + InvID + "';");
            DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());

            //isctive Log
            StringBuilder sb_2 = new StringBuilder();
            sb_2.Append(" SELECT TypeName,IsActive from f_Itemmaster ");
            sb_2.Append(" Where ItemID= '" + ItemID + "'  ");
            DataTable dt_LTD_2_1 = StockReports.GetDataTable(sb_2.ToString());

            //SampleType Log
            StringBuilder sb_3 = new StringBuilder();
            sb_3.Append(" SELECT im.name,ism.`SampleTypeName`,ism.`IsDefault` FROM investigations_sampletype ism ");
            sb_3.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=ism.`Investigation_ID`  ");
            sb_3.Append(" Where ism.`Investigation_ID`= '" + InvID + "'  ");
            DataTable dt_LTD_3_1 = StockReports.GetDataTable(sb_3.ToString());
            

            int testCodeQty = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select count(*) from investigation_master where LOWER(TRIM(testcode))=@TestCode AND Investigation_ID !=@InvID",
                   new MySqlParameter("@TestCode", TestCode.Trim().ToLower()),
                   new MySqlParameter("@InvID", InvID)));
            if (testCodeQty > 1)
            {
                Tranx.Rollback();
                return "-1";
            }
            //if (ColorCode == "" || ColorCode == "null")
            //{
            //    ColorCode = "#";
            //}
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update Investigation_master Set PrintTestCentre=@PrintTestCentre,Name =@InvName,");
            sb.Append(" Description ='',");
            sb.Append(" ReportType =@ReportType,");
            sb.Append(" Type =@SampleType,");
            sb.Append(" TimeLimit=@TimeLimit, ");
            sb.Append(" isAutoStore=@IsAutoStore, ");
            sb.Append(" GenderInvestigate=@Gender, ");
            sb.Append(" ShowOnline=@ShowOnlnRpt, ");
            sb.Append(" ShowFlag=@ShowAnlysRpt, ");
            sb.Append(" printHeader=@showPtRpt, ");
            sb.Append(" SampleRemarks=@SampleRmks, ");
            sb.Append(" SampleQty=@SampleQty, ");
            sb.Append(" ColorCode=@ColorCode, ");
            sb.Append(" TestCode=@TestCode, ");
            sb.Append(" isUrgent=@isUrgent, ");
            sb.Append(" Reporting=@Reporting, ");
            sb.Append(" IsOrganism=@IsOrganism, ");
            sb.Append(" isCulture=@IsCulture,");
            sb.Append(" isMic=@IsMic,");
            sb.Append(" PrintSeparate=@PrintSeparate,");
            sb.Append(" PrintSampleName=@PrintSampleName");
            sb.Append("  ,autoconsumeoption=@autoconsume,ConsentType=@ConsentType, labalert=@labalert,smsonalert=@smstext,logistictemp=@temp,fromage=@fromage,toage=@toage,container=@ColorCode1,invtype=@invtype,SampleDefined=@sampledefined ");
            sb.Append(" , RequiredAttachment=@RequiredAttachment ");
            sb.Append(" , AttchmentRequiredAt=@AttchmentRequiredAt ");
            sb.Append(" ,RequiredAttachmentID=@RequiredAttachmentID");
            sb.Append(" ,IsLMPRequired=@IsLMPRequired");
            sb.Append(" ,LMPFormDay=@LMPFormDay");
            sb.Append(" ,LMPToDay=@LMPToDay");
            sb.Append(" ,Show_In_TAT=@ShowinTat");
            //sbtr.Append(" BillCategoryID='" + BillCategoryID + "'");
            sb.Append(" , tatintimation=@tatintimation");
            sb.Append(" Where Investigation_ID =@InvID");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@PrintTestCentre", PrintTestCentre),
                new MySqlParameter("@tatintimation", TatIntimate), new MySqlParameter("@InvName", InvName),
                new MySqlParameter("@ReportType", ReportType),
                new MySqlParameter("@SampleType", SampleType),
                new MySqlParameter("@TimeLimit", TimeLimit),
                new MySqlParameter("@IsAutoStore", IsAutoStore),
                new MySqlParameter("@Gender", Gender),
                new MySqlParameter("@ShowOnlnRpt", ShowOnlnRpt),
                new MySqlParameter("@ShowAnlysRpt", ShowAnlysRpt),
                new MySqlParameter("@showPtRpt", showPtRpt),
                new MySqlParameter("@SampleRmks", SampleRmks),
                new MySqlParameter("@SampleQty", SampleQty),
                new MySqlParameter("@ColorCode", ColorCode),
                new MySqlParameter("@TestCode", TestCode),
                new MySqlParameter("@isUrgent", isUrgent),
                new MySqlParameter("@Reporting", Reporting),
                new MySqlParameter("@IsOrganism", IsOrganism),
                new MySqlParameter("@IsCulture", IsCulture),
                new MySqlParameter("@IsMic", IsMic), 
                new MySqlParameter("@PrintSeparate", PrintSeparate),
                new MySqlParameter("@PrintSampleName", PrintSampleName),
                new MySqlParameter("@autoconsume", autoconsume),
                new MySqlParameter("@ConsentType", ConsentType),
                new MySqlParameter("@labalert", labalert),
                new MySqlParameter("@smstext", smstext),
                new MySqlParameter("@temp", temp),
                new MySqlParameter("@fromage", fromage),
                new MySqlParameter("@toage", toage),
                new MySqlParameter("@ColorCode1", ColorCode),
                new MySqlParameter("@invtype", invtype),
                new MySqlParameter("@sampledefined", sampledefined),
                new MySqlParameter("@RequiredAttachment", RequiredAttachment.Split('#')[0].TrimEnd('|')),
                new MySqlParameter("@AttchmentRequiredAt", AttchmentRequiredAt),
                new MySqlParameter("@InvID", InvID),
                new MySqlParameter("@RequiredAttachmentID", RequiredAttachment.Split('#')[1].TrimEnd('|')),
                new MySqlParameter("@IsLMPRequired", IsLMPRequired),
                new MySqlParameter("@LMPFormDay", LMPDay.Split('|')[0]),
                new MySqlParameter("@LMPToDay", LMPDay.Split('|')[1]),
            new MySqlParameter("@ShowinTat", ShowinTAT));

            sb = new StringBuilder();
            sb.Append(" Update Investigation_observationtype Set ");
            sb.Append(" Investigation_ID =@InvID,");
            sb.Append(" ObservationType_Id =@DepartmentID");
            sb.Append(" Where Investigation_ObservationType_ID =@InvObsId");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(), new MySqlParameter("@InvID", Util.GetString(InvID)),
                new MySqlParameter("@DepartmentID", DepartmentID),
                new MySqlParameter("@InvObsId", InvObsId));

            string SubCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select sc.SubCategoryID from f_subcategorymaster sc inner join f_configrelation cf on sc.CategoryID = cf.CategoryID where cf.ConfigRelationID=3 and sc.Name=@DepartmentName and sc.Active=1",
                   new MySqlParameter("@DepartmentName", DepartmentName)));
            if (SubCategoryID != string.Empty)
            {
                sb = new StringBuilder();
                sb.Append(" Update f_Itemmaster Set TypeName =@InvName,SubCategoryID =@SubCategoryID,Inv_ShortName =@ShortName,");
                sb.Append(" IsTrigger=@IsOutSrc,TestCode=@TestCode,MaxDiscount=@MaxDiscount ,Booking=@Booking ,IsActive=@IsActive,Bill_Category=@BillingCategory,BaseRate=@BaseRate, ");
                sb.Append(" FromAge=@fromage,ToAge=@toage,Gender=@Gender,IsRequiredQuantity=@IsQuantity,ShowInRateList=@ShowInRateList Where ItemID =@ItemID ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@InvName", InvName.Trim()),
                    new MySqlParameter("@SubCategoryID", Util.GetString(SubCategoryID)),
                    new MySqlParameter("@ShortName", ShortName),
                    new MySqlParameter("@IsOutSrc", Util.GetString(IsOutSrc)),
                    new MySqlParameter("@TestCode", TestCode),
                    new MySqlParameter("@MaxDiscount", MaxDiscount),
                    new MySqlParameter("@Booking", Booking),
                    new MySqlParameter("@IsActive", IsActive),
                    new MySqlParameter("@BillingCategory", BillingCategory),
                    new MySqlParameter("@BaseRate", BaseRate),
                    new MySqlParameter("@fromage", fromage),
                    new MySqlParameter("@toage", toage),
                    new MySqlParameter("@Gender", Gender),
                    new MySqlParameter("@ItemID", ItemID),
                    new MySqlParameter("@IsQuantity", IsQuantity),
                    new MySqlParameter("@ShowInRateList", ShowInRateList));
                  
            }
            else
            {
                Tranx.Rollback();
                return "0";
            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE ItemID =@ItemID AND  Panel_ID=@Panel_ID ",
             new MySqlParameter("@DeletedByID", UserInfo.ID), 
             new MySqlParameter("@DeletedBy", UserInfo.LoginName),
             new MySqlParameter("@ItemID", ItemID),
             new MySqlParameter("@Panel_ID", "78"));

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete from f_ratelist where ItemID=@ItemID and Panel_ID=@Panel_ID",
                new MySqlParameter("@ItemID", ItemID),
                new MySqlParameter("@Panel_ID", "78"));
            RateList objRateList = new RateList(Tranx);
            objRateList.Panel_ID = 78;
            objRateList.ItemID =Util.GetInt( ItemID);
            objRateList.Rate = Util.GetDecimal(Rate);
            objRateList.IsTaxable = 0;
            objRateList.FromDate = DateTime.Now;
            objRateList.ToDate = DateTime.Now;
            objRateList.IsCurrent = 1;
            objRateList.IsService = "YES";
            objRateList.ItemDisplayName = Util.GetString(InvName);

            objRateList.ItemCode = Util.GetString(TestCode);
            objRateList.UpdateBy = HttpContext.Current.Session["LoginName"].ToString();
            objRateList.UpdateRemarks = string.Empty;
            objRateList.UpdateDate = DateTime.Now;
            objRateList.Insert();

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM `investigations_sampletype` WHERE `Investigation_ID`=@InvID",
                new MySqlParameter("@InvID", InvID));

            SampleTypeID = SampleTypeID.TrimEnd('#');
            if (SampleTypeID != "")
            {
                int len = Util.GetInt(SampleTypeID.Split('#').Length);
                string[] Data = new string[len];
                Data = SampleTypeID.Split('#');
                for (int i = 0; i < len; i++)
                {
                    sb = new StringBuilder();
                    sb.Append("Insert into investigations_sampletype (`Investigation_ID`,`SampleTypeID`,`SampleTypeName`,`CreatedUserID`,`IsDefault`) values (@InvID,@SampleTypeID,@SampleTypeName,@CreatedUserID,@IsDefault)");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@InvID", InvID), 
                        new MySqlParameter("@SampleTypeID", Util.GetString(Data[i].Split('|')[0])),
                        new MySqlParameter("@SampleTypeName", Util.GetString(Data[i].Split('|')[1])),
                        new MySqlParameter("@CreatedUserID", UserInfo.ID),
                        new MySqlParameter("@IsDefault", Util.GetString(Data[i].Split('|')[2])));
                }
            }


            sb_1 = new StringBuilder();
            sb_1.Append(" SELECT Name,Description,ReportType,TimeLimit,isAutoStore,GenderInvestigate,ShowOnline,ShowFlag,");
            sb_1.Append(" printHeader,SampleRemarks,SampleQty,ColorCode,TestCode,isUrgent,Reporting,IsOrganism,isCulture,isMic, ");
            sb_1.Append(" PrintSeparate,PrintSampleName,autoconsumeoption,ConsentType,labalert,smsonalert,logistictemp,fromage,");
            sb_1.Append(" toage,container,invtype,SampleDefined,RequiredAttachment,AttchmentRequiredAt,RequiredAttachmentID, ");
            sb_1.Append(" IsLMPRequired,LMPFormDay,LMPToDay,tatintimation from Investigation_master ");
            sb_1.Append(" WHERE Investigation_ID='" + InvID + "';");

            DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb_1.ToString()).Tables[0];
            for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
            {
                string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                if ((Util.GetString(dt_LTD_1.Rows[0][i]) != Util.GetString(dt_LTD_2.Rows[0][i])))
                {
                    sb_1 = new StringBuilder();
                    sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                    sb_1.Append("  values('','Investigation Update','" + Util.GetString(dt_LTD_1.Rows[0][i]) + "','" + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2.Rows[0]["Name"] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_1.Rows[0][i]) + " to " + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + StockReports.getip() + "',58);  ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb_1.ToString());
                }
            }

         //   isactive  change log
            sb_2 = new StringBuilder();
            sb_2.Append(" SELECT TypeName,IsActive from f_Itemmaster ");
            sb_2.Append(" Where ItemID= '" + ItemID + "'  ");
            DataTable dt_LTD_2_2 = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb_2.ToString()).Tables[0];
          
            for (int i = 0; i < dt_LTD_2_1.Columns.Count; i++)
            {
                string _ColumnName = dt_LTD_2_1.Columns[i].ColumnName;
                if ((Util.GetString(dt_LTD_2_1.Rows[0][i]) != Util.GetString(dt_LTD_2_2.Rows[0][i])))
                {
                    sb_1 = new StringBuilder();
                    sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                    sb_1.Append("  values('','Investigation Update','" + Util.GetString(dt_LTD_2_1.Rows[0][i]) + "','" + Util.GetString(dt_LTD_2_2.Rows[0][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2_2.Rows[0]["TypeName"] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_2_1.Rows[0][i]) + " to " + Util.GetString(dt_LTD_2_2.Rows[0][i]) + "','" + StockReports.getip() + "',58);  ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb_1.ToString());
                }
            }
            //  Sample  Type  Change log
            sb_3 = new StringBuilder();
            sb_3.Append(" SELECT im.name,ism.`SampleTypeName`,ism.`IsDefault` FROM investigations_sampletype ism ");
            sb_3.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=ism.`Investigation_ID`  ");
            sb_3.Append(" Where ism.`Investigation_ID`= '" + InvID + "'  ");
            DataTable dt_LTD_3_2 = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb_3.ToString()).Tables[0];

            int dt_LTD_3_2_count = dt_LTD_3_2.Rows.Count;

            int dt_LTD_3_1_count = dt_LTD_3_1.Rows.Count;

            

                if (dt_LTD_3_1.Rows.Count > 0 && dt_LTD_3_1_count == dt_LTD_3_2_count)
                {
                    for (int i = 0; i < dt_LTD_3_1.Columns.Count; i++)
                    {
                        string _ColumnName = dt_LTD_3_1.Columns[i].ColumnName;
                        if ((Util.GetString(dt_LTD_3_1.Rows[0][i]) != Util.GetString(dt_LTD_3_2.Rows[0][i])))
                        {
                            sb_1 = new StringBuilder();
                            sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                            sb_1.Append("  values('','Investigation Update','" + Util.GetString(dt_LTD_3_1.Rows[0][i]) + "','" + Util.GetString(dt_LTD_3_2.Rows[0][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_3_2.Rows[0]["name"] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_3_1.Rows[0][i]) + " to " + Util.GetString(dt_LTD_3_2.Rows[0][i]) + "','" + StockReports.getip() + "',58);  ");
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb_1.ToString());
                        }
                    }

                }
            
            StringBuilder sbbb = new StringBuilder();
            sbbb.Append(" insert into master_update_status(MasterName,MasterID,MasterIDName,Status,UserID,UserName,dtEntry,RoleID,CentreID,IpAddress,Remarks) ");
            sbbb.Append(" Values ('Investigation Master','" + InvID + "','" + InvName.Trim() + "','Update','" + UserInfo.ID + "','" + UserInfo.LoginName + "',NOW(),'" + UserInfo.RoleID + "','" + UserInfo.Centre + "','" + StockReports.getip() + "','');");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sbbb.ToString());

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetObservation_Details(string ObservationID, string InvestigationID, string Gender, string MacID, string MethodName, int CentreID, string type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Select ShowDeltaReport,ShowAbnormalAlert,AbnormalValue,ID,FromAge,ToAge,MinReading,MaxReading,MinCritical,MaxCritical,");
            sb.Append("  AutoApprovedMin,AutoApprovedMax,AMRMin,AMRMax,reflexmin,reflexmax,IFNULL(ReadingFormat,'')ReadingFormat,IFNULL(REPLACE(DisplayReading,'\n','<br />'),'')DisplayReading,");
            sb.Append(" IFNULL(DefaultReading,'')DefaultReading, ifnull((select MethodName from labobservation_range where  LabObservation_ID=@ObservationID and MacID=@MacID ");
            sb.Append(" and centreID=@CentreID  and Gender=@Gender  order by MethodName desc limit 1 ),'')MethodName,(select ShowMethod from labobservation_range where  LabObservation_ID=@ObservationID ");
            sb.Append(" and MacID=@MacID and centreID=@CentreID and Gender=@Gender  order by ShowMethod desc limit 1 )ShowMethod from labobservation_range where LabObservation_ID=@ObservationID ");
            sb.Append("  and Gender=@Gender and MacID=@MacID and centreID=@CentreID and RangeType=@type ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ObservationID", ObservationID),
                new MySqlParameter("@MacID", Util.GetInt(MacID)),
                new MySqlParameter("@CentreID", CentreID), 
                new MySqlParameter("@Gender", Gender),
                new MySqlParameter("@type", type)).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetObs_MasterData(string ObservationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Select ResultRequired,Name,Shortname,Suffix,Culture_flag,ShowFlag,RoundUpto,Gender,PrintSeparate,PrintInLabReport,AllowDuplicateBooking from labobservation_master where  LabObservation_ID=@ObservationID ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@ObservationID", ObservationID)).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public string updtObsRangesForAllInv(string ObservationName, string ObservationID, string ObsRangeData, string Gender, string ShortName, string Suffix, string AnylRpt, string IsCulture, string MacID, string RoundOff, String MethodName)
    {
        ObservationName = ObservationName.Trim();
        ObservationID = ObservationID.Trim();
        ObsRangeData = ObsRangeData.Trim();
        Gender = Gender.Trim();
        ShortName = ShortName.Trim();
        Suffix = Suffix.Trim();
        AnylRpt = AnylRpt.Trim();
        IsCulture = IsCulture.Trim();

        //ObsRangeData=FromAge|ToAge|MinReading|MaxReading|MinCritical|MaxCritical|ReadingFormat#

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        DataTable dt = new DataTable();

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("Update labobservation_master set Name=@ObservationName,Shortname=@ShortName,Suffix=@Suffix,ShowFlag=@AnylRpt,Culture_flag=@IsCulture ,RoundUpto = @Roundoff   where LabObservation_ID=@ObservationID");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(), new MySqlParameter("@ObservationName", ObservationName), new MySqlParameter("@ShortName", ShortName.Trim())
                , new MySqlParameter("@Suffix", Suffix.Trim()), new MySqlParameter("@AnylRpt", Util.GetInt(AnylRpt))
                , new MySqlParameter("@IsCulture", Util.GetInt(IsCulture)), new MySqlParameter("@Roundoff", Util.GetInt(RoundOff))
                , new MySqlParameter("@ObservationID", ObservationID), new MySqlParameter());

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Delete From labobservation_range where LabObservation_ID=@ObservationID and Gender=@Gender and MacID=@MacID"
                , new MySqlParameter("@ObservationID", ObservationID), new MySqlParameter("@Gender", Gender), new MySqlParameter("@MacID", Util.GetInt(MacID)));

            ObsRangeData = ObsRangeData.TrimEnd('#');
            int len = Util.GetInt(ObsRangeData.Split('#').Length);
            string[] Obs = new string[len];
            Obs = ObsRangeData.Split('#');

            dt = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "select Investigation_Id from labobservation_investigation where labObservation_ID=@ObservationID"
               , new MySqlParameter("@ObservationID", ObservationID.Trim())).Tables[0];
            if (dt != null && dt.Rows.Count > 0)
            {
                if (ObsRangeData != "")
                {
                    for (int j = 0; j < dt.Rows.Count; j++)
                    {
                        for (int i = 0; i < len; i++)
                        {
                            LabObservation_Range obj = new LabObservation_Range(Tranx);
                            obj.LabObservation_ID = ObservationID.Trim();
                            obj.Investigation_ID = dt.Rows[j]["Investigation_Id"].ToString().Trim();
                            obj.FromAge = Util.GetFloat(Obs[i].Split('|')[0]);
                            obj.ToAge = Util.GetFloat(Obs[i].Split('|')[1]);
                            obj.Gender = Gender.Trim();
                            obj.MinReading = Util.GetString(Obs[i].Split('|')[2]).Trim();
                            obj.maxReading = Util.GetString(Obs[i].Split('|')[3]).Trim();
                            obj.MinCritical = Util.GetFloat(Obs[i].Split('|')[4]);
                            obj.MaxCritical = Util.GetFloat(Obs[i].Split('|')[5]);
                            obj.ReadingFormat = Util.GetString(Obs[i].Split('|')[6]).Trim();
                            obj.DisplayReading = Util.GetStringWithoutReplace(Obs[i].Split('|')[7]).Trim();
                            obj.DefaultReading = Util.GetString(Obs[i].Split('|')[8]).Trim();
                            obj.UserID = HttpContext.Current.Session["ID"].ToString();
                            obj.Entdatetime = DateTime.Now;
                            obj.UpdateID = HttpContext.Current.Session["ID"].ToString();
                            obj.UpdateName = HttpContext.Current.Session["LoginName"].ToString();
                            obj.UpdateRemarks = string.Empty;
                            obj.updateDate = DateTime.Now;
                            obj.MacID = Util.GetInt(MacID);
                            obj.MethodName = Util.GetString(MethodName);

                            obj.Insert();
                        }
                    }
                }
            }

            Tranx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string updtObsRanges(string ObservationName, string ObservationID, string InvestigationID, string ObsRangeData, string Gender, string ShortName, string Suffix, string AnylRpt, string IsCulture, string MacID, string RoundOff, string MethodName, int CheckMethod, int MaleFemale, int CentreID, int ResultRequired, string MasterGender, string PrintSeparate, string Type, int AllCentre, int PrintInLabReport, int AllowDuplicateBooking, int ShowAbnormalAlert, int ShowDelta)
    {
        //ObsRangeData=FromAge|ToAge|MinReading|MaxReading|MinCritical|MaxCritical|ReadingFormat|DisplayReading|DefaultReading#

        ObservationName = ObservationName.Trim();
        ObservationID = ObservationID.Trim();
        InvestigationID = InvestigationID.Trim();
        ObsRangeData = ObsRangeData.Trim();
        Gender = Gender.Trim();
        ShortName = ShortName.Trim();
        Suffix = Suffix.Trim();
        AnylRpt = AnylRpt.Trim();
        IsCulture = IsCulture.Trim();

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sb_1 = new StringBuilder();
            sb_1.Append(" SELECT Name,Shortname,Suffix,ShowFlag,Culture_flag,RoundUpto,");
            sb_1.Append(" ResultRequired,Gender,PrintSeparate,PrintInLabReport,AllowDuplicateBooking  from labobservation_master ");
            sb_1.Append(" WHERE LabObservation_ID='" + ObservationID + "';");
            DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());

            StringBuilder sb_2 = new StringBuilder();
            sb_2.Append(" SELECT FromAge,ToAge,MinReading,MaxReading,MinCritical,MaxCritical,AutoApprovedMin,AutoApprovedMax,AmrMin,AmrMax,ReflexMin,ReflexMax, ");
            sb_2.Append(" ReadingFormat,DisplayReading,DefaultReading ");
            sb_2.Append(" from labobservation_range WHERE LabObservation_ID='" + ObservationID + "' and MacID=" + Util.GetInt(MacID) + " and RangeType='" + Type + "' ");
            if (AllCentre == 0)
            {
                sb_2.Append("and CentreID = '" + CentreID + "' ");
            }
            if (MaleFemale == 0)
            {
                sb_2.Append(" and Gender='" + Gender + "' ");
            }

            DataTable dt_LTD_2 = StockReports.GetDataTable(sb_2.ToString());

            // Method  Name
            StringBuilder sb_21 = new StringBuilder();
            sb_21.Append(" SELECT MethodName ");
        //    sb_21.Append(" ");
            sb_21.Append(" from labobservation_range WHERE LabObservation_ID='" + ObservationID + "' and MacID=" + Util.GetInt(MacID) + " and RangeType='" + Type + "' ");
            if (AllCentre == 0)
            {
                sb_21.Append("and CentreID = '" + CentreID + "' ");
            }
            if (MaleFemale == 0)
            {
                sb_21.Append(" and Gender='" + Gender + "' ");
            }

            DataTable dt_LTD_21 = StockReports.GetDataTable(sb_21.ToString());



            StringBuilder sb = new StringBuilder();
            sb.Append("Update labobservation_master set Name=@ObservationName,Shortname=@ShortName,Suffix=@Suffix,ShowFlag=@AnylRpt,Culture_flag=@IsCulture,RoundUpto=@RoundOff,");
            sb.Append(" ResultRequired=@ResultRequired,Gender=@MasterGender,PrintSeparate=@PrintSeparate,PrintInLabReport=@PrintInLabReport,AllowDuplicateBooking=@AllowDuplicateBooking  where LabObservation_ID=@ObservationID");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ObservationName", ObservationName), new MySqlParameter("@ShortName", ShortName.Trim()),
                new MySqlParameter("@Suffix", Suffix.Trim()), new MySqlParameter("@AnylRpt", Util.GetInt(AnylRpt)),
                new MySqlParameter("@IsCulture", Util.GetInt(IsCulture)), new MySqlParameter("@RoundOff", Util.GetInt(RoundOff)),
                new MySqlParameter("@ResultRequired", ResultRequired), new MySqlParameter("@MasterGender", MasterGender),
                new MySqlParameter("@PrintSeparate", PrintSeparate), new MySqlParameter("@PrintInLabReport", PrintInLabReport),
                new MySqlParameter("@AllowDuplicateBooking", AllowDuplicateBooking), new MySqlParameter("@ObservationID", ObservationID));


            sb = new StringBuilder();
            sb.Append("Delete From labobservation_range where LabObservation_ID=@ObservationID  and MacID=@MacID and RangeType=@Type ");
            if (AllCentre == 0)
            {
                sb.Append("and CentreID = @CentreID ");
            }
            if (MaleFemale == 0)
            {
                sb.Append(" and Gender=@Gender ");
            }


            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ObservationID", ObservationID), 
                new MySqlParameter("@MacID", Util.GetInt(MacID)),
                new MySqlParameter("@Type", Type),
                new MySqlParameter("@CentreID", CentreID), 
                new MySqlParameter("@Gender", Gender));

            sb = new StringBuilder();
            sb.Append("UPDATE  labobservation_range set MethodName=@MethodName where  LabObservation_ID=@ObservationID and MacID=@MacID and centreID=@CentreID");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@MethodName", Util.GetString(MethodName)), 
                new MySqlParameter("@ObservationID", ObservationID),
                new MySqlParameter("@MacID", Util.GetInt(MacID)),
                new MySqlParameter("@CentreID", CentreID));

            ObsRangeData = ObsRangeData.TrimEnd('#');
            int len = Util.GetInt(ObsRangeData.Split('#').Length);
            string[] Obs = new string[len];
            Obs = ObsRangeData.Split('#');


            if (ObsRangeData != string.Empty)
            {
                if (MaleFemale == 0)
                {
                    for (int i = 0; i < len; i++)
                    {
                        LabObservation_Range obj = new LabObservation_Range(Tranx);
                        obj.LabObservation_ID = ObservationID.Trim();
                        obj.Investigation_ID = InvestigationID.Trim();
                        obj.FromAge = Util.GetFloat(Obs[i].Split('|')[0]);
                        obj.ToAge = Util.GetFloat(Obs[i].Split('|')[1]);
                        obj.Gender = Gender.Trim();
                        obj.MinReading = Util.GetString(Obs[i].Split('|')[2]).Trim();
                        obj.maxReading = Util.GetString(Obs[i].Split('|')[3]).Trim();
                        obj.MinCritical = Util.GetFloat(Obs[i].Split('|')[4]);
                        obj.MaxCritical = Util.GetFloat(Obs[i].Split('|')[5]);

                        obj.AutoApprovedMin = Util.GetFloat(Obs[i].Split('|')[10]);
                        obj.AutoApprovedMax = Util.GetFloat(Obs[i].Split('|')[11]);
                        obj.AMRMin = Util.GetFloat(Obs[i].Split('|')[12]);
                        obj.AMRMax = Util.GetFloat(Obs[i].Split('|')[13]);
                        obj.ReflexMin = Util.GetFloat(Obs[i].Split('|')[14]);
                        obj.ReflexMax = Util.GetFloat(Obs[i].Split('|')[15]);
                        obj.ReadingFormat = Util.GetString(Obs[i].Split('|')[6]).Trim();
                        obj.DisplayReading = Util.GetStringWithoutReplace(Obs[i].Split('|')[7]).Trim();
                        obj.DefaultReading = Util.GetString(Obs[i].Split('|')[8]).Trim();
                        obj.AbnormalValue = Util.GetString(Obs[i].Split('|')[9]).Trim();
                        obj.UserID = Util.GetString(UserInfo.ID);
                        obj.Entdatetime = DateTime.Now;
                        obj.UpdateID = HttpContext.Current.Session["ID"].ToString();
                        obj.UpdateName = HttpContext.Current.Session["LoginName"].ToString();
                        obj.UpdateRemarks = "";
                        obj.updateDate = DateTime.Now;
                        obj.MacID = Util.GetInt(MacID);
                        obj.MethodName = Util.GetString(MethodName);
                        obj.ShowMethod = Util.GetInt(CheckMethod);
                        obj.CentreID = Util.GetInt(CentreID);
                        obj.RangeType = Util.GetString(Type);
                        obj.ShowAbnormalAlert = Util.GetInt(ShowAbnormalAlert);
                        obj.ShowDelta = Util.GetInt(ShowDelta);
                        obj.Insert();
                    }
                }
                else
                {
                    for (int i = 0; i < len; i++)
                    {
                        LabObservation_Range obj = new LabObservation_Range(Tranx);
                        obj.LabObservation_ID = ObservationID.Trim();
                        obj.Investigation_ID = InvestigationID.Trim();
                        obj.FromAge = Util.GetFloat(Obs[i].Split('|')[0]);
                        obj.ToAge = Util.GetFloat(Obs[i].Split('|')[1]);
                        obj.Gender = "M";
                        obj.MinReading = Util.GetString(Obs[i].Split('|')[2]).Trim();
                        obj.maxReading = Util.GetString(Obs[i].Split('|')[3]).Trim();
                        obj.MinCritical = Util.GetFloat(Obs[i].Split('|')[4]);
                        obj.MaxCritical = Util.GetFloat(Obs[i].Split('|')[5]);
                        obj.AutoApprovedMin = Util.GetFloat(Obs[i].Split('|')[10]);
                        obj.AutoApprovedMax = Util.GetFloat(Obs[i].Split('|')[11]);
                        obj.AbnormalValue = Util.GetString(Obs[i].Split('|')[9]).Trim();
                        obj.AMRMin = Util.GetFloat(Obs[i].Split('|')[12]);
                        obj.AMRMax = Util.GetFloat(Obs[i].Split('|')[13]);
                        obj.ReflexMin = Util.GetFloat(Obs[i].Split('|')[14]);
                        obj.ReflexMax = Util.GetFloat(Obs[i].Split('|')[15]);
                        obj.ReadingFormat = Util.GetString(Obs[i].Split('|')[6]).Trim();
                        obj.DisplayReading = Util.GetStringWithoutReplace(Obs[i].Split('|')[7]).Trim();
                        obj.DefaultReading = Util.GetString(Obs[i].Split('|')[8]).Trim();
                        obj.UserID = Util.GetString(UserInfo.ID);
                        obj.Entdatetime = DateTime.Now;
                        obj.UpdateID = HttpContext.Current.Session["ID"].ToString();
                        obj.UpdateName = HttpContext.Current.Session["LoginName"].ToString();
                        obj.UpdateRemarks = "";
                        obj.updateDate = DateTime.Now;
                        obj.MacID = Util.GetInt(MacID);
                        obj.MethodName = Util.GetString(MethodName);
                        obj.ShowMethod = Util.GetInt(CheckMethod);
                        obj.CentreID = Util.GetInt(CentreID);
                        obj.RangeType = Util.GetString(Type);
                        obj.ShowAbnormalAlert = Util.GetInt(ShowAbnormalAlert);
                        obj.ShowDelta = Util.GetInt(ShowDelta);
                        obj.Insert();

                        obj = new LabObservation_Range(Tranx);
                        obj.LabObservation_ID = ObservationID.Trim();
                        obj.Investigation_ID = InvestigationID.Trim();
                        obj.FromAge = Util.GetFloat(Obs[i].Split('|')[0]);
                        obj.ToAge = Util.GetFloat(Obs[i].Split('|')[1]);
                        obj.Gender = "F";
                        obj.MinReading = Util.GetString(Obs[i].Split('|')[2]).Trim();
                        obj.maxReading = Util.GetString(Obs[i].Split('|')[3]).Trim();
                        obj.MinCritical = Util.GetFloat(Obs[i].Split('|')[4]);
                        obj.MaxCritical = Util.GetFloat(Obs[i].Split('|')[5]);
                        obj.AutoApprovedMin = Util.GetFloat(Obs[i].Split('|')[10]);
                        obj.AutoApprovedMax = Util.GetFloat(Obs[i].Split('|')[11]);
                        obj.AMRMin = Util.GetFloat(Obs[i].Split('|')[12]);
                        obj.AMRMax = Util.GetFloat(Obs[i].Split('|')[13]);
                        obj.AbnormalValue = Util.GetString(Obs[i].Split('|')[9]).Trim();
                        obj.ReflexMin = Util.GetFloat(Obs[i].Split('|')[14]);
                        obj.ReflexMax = Util.GetFloat(Obs[i].Split('|')[15]);
                        obj.ReadingFormat = Util.GetString(Obs[i].Split('|')[6]).Trim();
                        obj.DisplayReading = Util.GetStringWithoutReplace(Obs[i].Split('|')[7]).Trim();
                        obj.DefaultReading = Util.GetString(Obs[i].Split('|')[8]).Trim();
                        obj.UserID = Util.GetString(UserInfo.ID);
                        obj.Entdatetime = DateTime.Now;
                        obj.UpdateID = HttpContext.Current.Session["ID"].ToString();
                        obj.UpdateName = HttpContext.Current.Session["LoginName"].ToString();
                        obj.UpdateRemarks = "";
                        obj.updateDate = DateTime.Now;
                        obj.MacID = Util.GetInt(MacID);
                        obj.MethodName = Util.GetString(MethodName);
                        obj.ShowMethod = Util.GetInt(CheckMethod);
                        obj.CentreID = Util.GetInt(CentreID);
                        obj.RangeType = Util.GetString(Type);
                        obj.ShowAbnormalAlert = Util.GetInt(ShowAbnormalAlert);
                        obj.ShowDelta = Util.GetInt(ShowDelta);
                        obj.Insert();
                    }
                }
            }

            if (AllCentre == 1)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO labobservation_range(Investigation_ID,LabObservation_ID,Gender,FromAge,ToAge,MinReading,MaxReading,");
                sb.Append(" DisplayReading,DefaultReading,MinCritical,MaxCritical,ReadingFormat,Interpretation,UserID,EntDateTime,UpdateID,");
                sb.Append(" UpdateName,UpdateRemarks,Updatedate,MacID,MethodName,ShowMethod,CentreID,AbnormalValue,RangeType,AutoApprovedMin,");
                sb.Append(" AutoApprovedMax,AMRMin,AMRMax,reflexmin,reflexmax,ShowAbnormalAlert,ShowDeltaReport)");
                sb.Append(" SELECT lr.Investigation_ID,lr.LabObservation_ID,lr.Gender,lr.FromAge,lr.ToAge,lr.MinReading,lr.MaxReading,  ");
                sb.Append(" lr.DisplayReading,lr.DefaultReading,lr.MinCritical,lr.MaxCritical,lr.ReadingFormat,lr.Interpretation,lr.UserID,lr.EntDateTime,lr.UpdateID,");
                sb.Append(" lr.UpdateName,lr.UpdateRemarks,lr.Updatedate,MacID,MethodName,ShowMethod,cm.CentreID,AbnormalValue,RangeType,AutoApprovedMin,");
                sb.Append(" lr.AutoApprovedMax,lr.AMRMin,lr.AMRMax,lr.reflexmin,lr.reflexmax,lr.ShowAbnormalAlert,lr.ShowDeltaReport ShowDelta ");
                sb.Append(" FROM labobservation_range lr ");
                sb.Append(" CROSS JOIN centre_master cm  ");
                sb.Append(" WHERE cm.isActive=1  AND lr.centreid=@CentreID AND cm.centreid!=@CentreID and lr.LabObservation_ID=@ObservationID ");


                sb.Append("   and lr.MacID=@MacID and lr.RangeType=@Type ");

                if (MaleFemale == 0)
                {
                    sb.Append(" and lr.Gender=@Gender ");
                }

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreID", CentreID),
                    new MySqlParameter("@ObservationID", ObservationID.Trim()),
                    new MySqlParameter("@MacID", Util.GetInt(MacID)),
                    new MySqlParameter("@Type", Type),
                    new MySqlParameter("@Gender", Gender));
            }

            sb_1 = new StringBuilder();
            sb_1.Append(" SELECT Name,Shortname,Suffix,ShowFlag,Culture_flag,RoundUpto,");
            sb_1.Append(" ResultRequired,Gender,PrintSeparate,PrintInLabReport,AllowDuplicateBooking  from labobservation_master ");
            sb_1.Append(" WHERE LabObservation_ID='" + ObservationID + "';");

            DataTable dt_LTD_3 = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb_1.ToString()).Tables[0];
            for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
            {
                string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                if ((Util.GetString(dt_LTD_1.Rows[0][i]) != Util.GetString(dt_LTD_3.Rows[0][i])))
                {
                    sb_1 = new StringBuilder();
                    sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                    sb_1.Append("  values('','Observation Changes','" + Util.GetString(dt_LTD_1.Rows[0][i]) + "','" + Util.GetString(dt_LTD_3.Rows[0][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "',' Observation " + Util.GetString(dt_LTD_3.Rows[0]["Name"]) + " " + _ColumnName + " Change from " + Util.GetString(dt_LTD_1.Rows[0][i]) + " to " + Util.GetString(dt_LTD_3.Rows[0][i]) + "','" + StockReports.getip() + "',59);  ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb_1.ToString());
                }
            }

            sb_2 = new StringBuilder();
            sb_2.Append(" SELECT FromAge,ToAge,MinReading,MaxReading,MinCritical,MaxCritical,AutoApprovedMin,AutoApprovedMax,AmrMin,AmrMax,ReflexMin,ReflexMax, ");
            sb_2.Append(" ReadingFormat,DisplayReading,DefaultReading ");
            sb_2.Append(" from labobservation_range WHERE LabObservation_ID='" + ObservationID + "' and MacID=" + Util.GetInt(MacID) + " and RangeType='" + Type + "' ");
            if (AllCentre == 0)
            {
                sb_2.Append("and CentreID = '" + CentreID + "' ");
            }
            if (MaleFemale == 0)
            {
                sb_2.Append(" and Gender='" + Gender + "' ");
            }

            DataTable dt_LTD_4 = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb_2.ToString()).Tables[0];
            for (int i = 0; i < dt_LTD_2.Columns.Count; i++)
            {
                if(dt_LTD_2.Rows.Count>0)
                {
                string _ColumnName = dt_LTD_2.Columns[i].ColumnName;
                if ((Util.GetString(dt_LTD_2.Rows[0][i]) != Util.GetString(dt_LTD_4.Rows[0][i])))
                {
                    sb_1 = new StringBuilder();
                    sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                    sb_1.Append("  values('','Observation Changes','" + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + Util.GetString(dt_LTD_4.Rows[0][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "',' Observation " + Util.GetString(dt_LTD_3.Rows[0]["Name"]) + " Range " + _ColumnName + " Change from " + Util.GetString(dt_LTD_2.Rows[0][i]) + " to " + Util.GetString(dt_LTD_4.Rows[0][i]) + "','" + StockReports.getip() + "',59);  ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb_1.ToString());
                }
              }
            }

            //08/Aug22 Method  Name  Update Log  
            sb_21 = new StringBuilder();
            sb_21.Append(" SELECT MethodName ");
       //     sb_21.Append(" ReadingFormat,DisplayReading,DefaultReading ");
            sb_21.Append(" from labobservation_range WHERE LabObservation_ID='" + ObservationID + "' and MacID=" + Util.GetInt(MacID) + " and RangeType='" + Type + "' ");
            if (AllCentre == 0)
            {
                sb_21.Append("and CentreID = '" + CentreID + "' ");
            }
            if (MaleFemale == 0)
            {
                sb_21.Append(" and Gender='" + Gender + "' ");
            }

            DataTable dt_LTD_51 = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb_21.ToString()).Tables[0];
            for (int i = 0; i < dt_LTD_21.Columns.Count; i++)
            {
                if (dt_LTD_21.Rows.Count > 0)
                {
                    string _ColumnName = dt_LTD_21.Columns[i].ColumnName;
                    if ((Util.GetString(dt_LTD_21.Rows[0][i]) != Util.GetString(dt_LTD_51.Rows[0][i])))
                    {
                        sb_1 = new StringBuilder();
                        sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                        sb_1.Append("  values('','Observation Changes','" + Util.GetString(dt_LTD_21.Rows[0][i]) + "','" + Util.GetString(dt_LTD_51.Rows[0][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + CentreID + "',' Observation " + Util.GetString(dt_LTD_3.Rows[0]["Name"]) + "  " + _ColumnName + " Change from " + Util.GetString(dt_LTD_21.Rows[0][i]) + " to " + Util.GetString(dt_LTD_51.Rows[0][i]) + "','" + StockReports.getip() + "',59);  ");
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb_1.ToString());
                    }
                }
            }

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Convert.ToString(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveNewObservation(string ObsName, string ShortName, string Suffix, string IsCulture, string ObsAnylRpt, string RoundOff, string Gender, string PrintSeparate, int PrintInLabReport, int AllowDuplicateBooking)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            int Obscount = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select count(1) from labobservation_master where LOWER(TRIM(NAME))=@NAME",
                 new MySqlParameter("@NAME", ObsName.Trim().ToLower())));
            if (Obscount > 0)
            {
                Tranx.Rollback();
                return "0";
            }

            string Observation_Id = "";
            Labobservation_master objLabobservation_master = new Labobservation_master(Tranx);
            objLabobservation_master.Creator_ID = HttpContext.Current.Session["ID"].ToString();
            objLabobservation_master.Name = ObsName;
            objLabobservation_master.Shortname = ShortName;
            objLabobservation_master.Suffix = Suffix;
            objLabobservation_master.Culture_Flag = Util.GetInt(IsCulture);
            objLabobservation_master.ShowFlag = Util.GetInt(ObsAnylRpt);
            objLabobservation_master.RoundUpto = Util.GetInt(RoundOff);
            objLabobservation_master.Gender = Gender;
            objLabobservation_master.PrintSeparate = Util.GetInt(PrintSeparate);
            objLabobservation_master.PrintInLabReport = Util.GetInt(PrintInLabReport);
            objLabobservation_master.AllowDuplicateBooking = Util.GetInt(AllowDuplicateBooking);
            Observation_Id = objLabobservation_master.Insert();
            Tranx.Commit();
            return Observation_Id;
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "Error";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public DataTable Get_InvPriorty(string SubCategoryId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT inv.Name,inv.Investigation_Id as ID,inv.Print_Sequence,im.SubCategoryID ");
            sb.Append(" FROM f_itemmaster im ");
            sb.Append(" INNER JOIN investigation_master inv ON inv.Investigation_Id = im.Type_ID ");
            sb.Append(" AND im.IsActive=1 AND im.SubCategoryID=@SubCategoryId ");
            sb.Append(" ORDER BY  inv.Print_Sequence ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@SubCategoryId", SubCategoryId)).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public DataTable Get_DeptPriorty()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sc.Name, CONCAT(sc.SubcategoryID,'#',om.ObservationType_ID)ID ");
        sb.Append(" FROM f_subcategorymaster sc INNER JOIN ");
        sb.Append(" f_configrelation c ON c.CategoryID=sc.CategoryID ");//AND c.ConfigRelationId='3'
        sb.Append(" INNER JOIN observationtype_master om ON om.ObservationType_ID=sc.SubcategoryID and sc.Active=1");
        sb.Append(" ORDER BY om.Print_Sequence ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public string SaveInvOrdering(string InvOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            // ObsData= Order|ObservationId|Header|IsCritical#
            InvOrder = InvOrder.TrimEnd('|');
            StringBuilder sb = new StringBuilder();
            int len = Util.GetInt(InvOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = InvOrder.Split('|');
            for (int i = 0; i < len; i++)
            {
                sb = new StringBuilder();
                sb.Append(" UPDATE f_itemmaster im INNER JOIN investigation_master inv ON inv.Investigation_Id=im.Type_Id INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID");
                sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID AND c.ConfigRelationID='3'  SET im.ShowFlag=@ShowFlag, inv.Print_Sequence=@Print_Sequence WHERE inv.Investigation_Id=@Investigation_Id ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@ShowFlag", (Util.GetInt(i) + 1)),
                    new MySqlParameter("@Print_Sequence", (Util.GetInt(i) + 1)),
                    new MySqlParameter("@Investigation_Id", Data[i].ToString()));
            }

            Tranx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveDeptOrdering(string DeptOrder)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DeptOrder = DeptOrder.TrimEnd('|');
            int len = Util.GetInt(DeptOrder.Split('|').Length);
            string[] Data = new string[len];
            Data = DeptOrder.Split('|');
            for (int i = 0; i < len; i++)
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update observationtype_master set Print_Sequence=@Print_Sequence where ObservationType_ID=@ObservationType_ID ",
                    new MySqlParameter("@Print_Sequence", (Util.GetInt(i) + 1)),
                    new MySqlParameter("@ObservationType_ID", Data[i].Split('#')[1]));
            }

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public DataTable getTestCentre(string BookingCentre, string Department, string TestName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.`Type_ID`,im.`TypeName`,IF(IFNULL(tcm.`Test_Centre`,0)=0,'1','0')TestCentre1,IF(IFNULL(tcm.`Test_Centre2`,0)=0,'1','0')TestCentre2,IF(IFNULL(tcm.`Test_Centre3`,0)=0,'1','0')TestCentre3,IFNULL(tcm.`Test_Centre`,@BookingCentre) Test_Centre,IFNULL(tcm.`Test_Centre2`,@BookingCentre) Test_Centre2,IFNULL(tcm.`Test_Centre3`,@BookingCentre) Test_Centre3 FROM `f_itemmaster` im  ");
            sb.Append(" INNER JOIN `f_subcategorymaster` scm ON im.`SubCategoryID`=scm.`SubCategoryID`   ");
            if (Department != string.Empty)
                sb.Append(" and  im.`SubCategoryID`=@Department ");
            if (TestName != string.Empty)
                sb.Append(" and  im.TypeName like @TestName ");
            sb.Append(" AND scm.`CategoryID`='LSHHI3' AND im.`IsActive`=1  ");
            sb.Append(" LEFT JOIN `test_centre_mapping` tcm ON tcm.`Booking_Centre`=@BookingCentre  AND im.`Type_ID`=tcm.`Investigation_ID`  ");
            sb.Append(" ORDER BY im.`TypeName`  ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@BookingCentre", BookingCentre),
                new MySqlParameter("@Department", Department),
                new MySqlParameter("@TestName", string.Concat("%", TestName, "%"))).Tables[0];
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return dt;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public string SaveTestCentre(string BookingCentre, string Investigation_ID, string TestCentre, string TestCentre1, string TestCentre2)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            //obj.UpdateID = HttpContext.Current.Session["ID"].ToString();
            //obj.UpdateName = HttpContext.Current.Session["LoginName"].ToString();

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from test_centre_mapping where Booking_Centre=@BookingCentre and Investigation_ID=@Investigation_ID",
                new MySqlParameter("@BookingCentre", BookingCentre),
                new MySqlParameter("@Investigation_ID", Investigation_ID));

            StringBuilder sb = new StringBuilder();
            sb.Append("insert into test_centre_mapping(Booking_Centre,Test_Centre,Test_Centre2,Test_Centre3,Investigation_ID,UserID,Username) ");
            sb.Append("values(@BookingCentre,@TestCentre,@TestCentre1,@TestCentre2,@Investigation_ID,@UserID,@UserName)");

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@BookingCentre", BookingCentre),
                new MySqlParameter("@TestCentre", TestCentre),
                new MySqlParameter("@TestCentre1", TestCentre1),
                new MySqlParameter("@TestCentre2", TestCentre2),
                new MySqlParameter("@Investigation_ID", Investigation_ID),
                new MySqlParameter("@UserID", UserInfo.ID),
                new MySqlParameter("@UserName", UserInfo.LoginName));
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public string mappingInterpretation(string fromCentre, string toCentre, string fromMachine, string toMachine, string departmentID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" DELETE lmi FROM labobservation_master_interpretation  lmi");
            if (departmentID != "0")
            {
                sb.Append("  INNER JOIN labobservation_investigation  li ON lmi.LabObservation_ID=li.LabObservation_ID ");
                sb.Append(" INNER JOIN f_itemmaster  im ON li.Investigation_ID=im.type_id AND im.subcategoryID=@departmentID ");
            }
            sb.Append(" WHERE lmi.CentreID=@toCentre AND lmi.macID=@toMachine ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@departmentID", departmentID),
                new MySqlParameter("@toCentre", toCentre), 
                new MySqlParameter("@toMachine", toMachine));

            sb = new StringBuilder();

            sb.Append(" INSERT INTO labobservation_master_interpretation(LabObservation_ID,CentreID,macID,flag,Interpretation,PrintInterTest,PrintInterPackage,EntryDate,EntryBy)");
            sb.Append(" SELECT lmi.LabObservation_ID,@toCentre,@toMachine,lmi.flag,lmi.Interpretation,lmi.PrintInterTest,lmi.PrintInterPackage,NOW(),@ID ");
            sb.Append(" FROM labobservation_master_interpretation lmi ");
            if (departmentID != "0")
            {
                sb.Append(" INNER JOIN labobservation_investigation  li ON lmi.LabObservation_ID=li.LabObservation_ID ");
                sb.Append(" INNER JOIN f_itemmaster  im ON li.Investigation_ID=im.type_id AND im.subcategoryID=@departmentID ");
            }
            sb.Append("  WHERE lmi.CentreID=@fromCentre AND lmi.macID=@fromMachine");

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@toCentre", toCentre),
                new MySqlParameter("@toMachine", toMachine),
                new MySqlParameter("@ID", UserInfo.ID),
                new MySqlParameter("@departmentID", departmentID),
                new MySqlParameter("@fromCentre", fromCentre),
                new MySqlParameter("@fromMachine", fromMachine));

            sb = new StringBuilder();

            sb.Append(" DELETE imi FROM investigation_master_interpretation imi ");
            if (departmentID != "0")
                sb.Append("  INNER JOIN f_itemmaster  im ON imi.investigation_ID=im.type_id AND im.subcategoryID=@departmentID ");
            sb.Append(" WHERE imi.CentreID=@toCentre AND imi.macID=@toMachine ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@departmentID", departmentID),
                new MySqlParameter("@toCentre", toCentre),
                new MySqlParameter("@toMachine", toMachine));

            sb = new StringBuilder();

            sb.Append(" INSERT INTO investigation_master_interpretation(Investigation_ID,CentreID,macID,Interpretation,PrintInterTest,PrintInterPackage,EntryDate,EntryBy)");
            sb.Append(" SELECT imi.Investigation_ID,@toCentre,@toMachine,imi.Interpretation,imi.PrintInterTest,imi.PrintInterPackage,NOW(),@ID ");
            sb.Append(" FROM investigation_master_interpretation imi  ");
            if (departmentID != "0")
                sb.Append(" INNER JOIN f_itemmaster  im ON imi.investigation_ID=im.type_id AND im.subcategoryID=@departmentID");
            sb.Append(" WHERE imi.CentreID=@fromCentre AND imi.macID=@fromMachine ");

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@toCentre", toCentre),
                 new MySqlParameter("@toMachine", toMachine),
                 new MySqlParameter("@ID", UserInfo.ID),
                 new MySqlParameter("@departmentID", departmentID),
                 new MySqlParameter("@fromCentre", fromCentre), 
                 new MySqlParameter("@fromMachine", fromMachine));

            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}