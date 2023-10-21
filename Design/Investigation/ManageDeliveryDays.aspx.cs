using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_ManageDeliveryDays : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcentre();
            LoadSubCategory();
        }
    }   
    private void LoadSubCategory()
    {       
        ddlDepartment.DataSource = StockReports.GetDataTable("SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3' ORDER BY NAME");
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        
    }
    private void bindcentre()
    {  
        ddlCentreAccess.DataSource = StockReports.GetDataTable("SELECT CentreID,Centre FROM centre_master  where isActive=1 order by centre"); ;
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();
        ddlCentreAccess.SelectedIndex = ddlCentreAccess.Items.IndexOf(ddlCentreAccess.Items.FindByValue(UserInfo.Centre.ToString()));
    }   
    [WebMethod(EnableSession = true)]
    public static string GetDeliveryDays(object searchData)
    {
        List<SearchDeliveryDay> search = new JavaScriptSerializer().ConvertToType<List<SearchDeliveryDay>>(searchData);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT id.Id as RowId,  @CentreID  CentreId, ifnull(id.TATType,'Days')TATType,  ifnull(id.woringhours,'0') woringhours,ifnull(id.nonworinghours,'0') nonworinghours,ifnull(id.stathours,'0') stathours, ifnull(id.labstarttime,'8:00 AM')labstarttime,ifnull(id.labendtime,'06:00 PM')labendtime,ifnull(id.samedaydeliverytime,'06:00 PM')samedaydeliverytime ,ifnull(id.samedaydeliverytime1,'06:00 PM')samedaydeliverytime1,ifnull(id.samedaydeliverytime2,'06:00 PM')samedaydeliverytime2,ifnull(id.nextdaydeliverytime,'12:00 PM')nextdaydeliverytime, sc.`SubCategoryID`,sc.`Name` AS DeptName,im.`Type_ID`,im.`TypeName` AS InvName,ifnull(id.DayType,'DAY')DayType,ifnull(id.Days,0)Days, ");
            sb.Append(" ifnull(id.Sun,0)Sun,ifnull(id.Mon,0)Mon,ifnull(id.Tue,0)Tue,ifnull(id.Wed,0)Wed,ifnull(id.Thu,0)Thu,ifnull(id.Fri,0)Fri,ifnull(id.Sat,0)Sat,IFNULL(id.CutOffTime, '10:00 AM')CutOffTime,ifnull(id.CutOffTime1,'12:00 AM')CutOffTime1,ifnull(id.CutOffTime2,'02:00 PM')CutOffTime2, ");

            sb.Append("if((SELECT COUNT(*) FROM `test_centre_mapping` WHERE `Booking_Centre`=@CentreID AND `Test_Centre`<> @CentreID  AND `Investigation_ID`=im.Type_ID)=0,'InHouse','OutHouse') Processtype,");

            //sb.Append(" ifnull(Processtype,'InHouse') Processtype,");
            sb.Append(" ifnull(SR_To_DR,'0') SR_To_DR,ifnull(SR_To_ST,'0') SR_To_ST,ifnull(ST_To_SLR,'0') ST_To_SLR,ifnull(SLR_To_DR,'0') SLR_To_DR, ");
            sb.Append(" ifnull(Approval_To_Dispatch,'0') Approval_To_Dispatch,id.IsApplicable,id.IsApplicable1,id.IsApplicable2,sc.Depttype ");
            sb.Append(" ");

            sb.Append(" FROM `f_itemmaster` im ");
            sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
            sb.Append(" Inner join investigation_master inv on inv.Investigation_id=im.Type_ID and Show_In_TAT='1'");
            if (Util.GetString(search[0].TestName) != string.Empty)
            {
                sb.AppendFormat(" AND im.typename LIKE @LikeSearchValue ", search[0].TestName);
            }
            sb.Append(" AND sc.`SubcategoryID`=@SubcategoryID ");

            sb.Append(" LEFT JOIN ");
            sb.Append(" (SELECT * FROM `investiagtion_delivery` WHERE  `CentreID`=@CentreID ");
            sb.Append(" AND `SubCategoryID`=@SubcategoryID ");
            sb.Append(" ) id ");
            sb.Append(" ON id.Investigation_id=im.`Type_ID` AND id.SubCategoryID=im.`SubCategoryID` where im.isActive=1 order by typename ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LikeSearchValue", string.Concat(Util.GetString(search[0].TestName), "%")),
                new MySqlParameter("@SubcategoryID", Util.GetString(search[0].SubCategoryId)),
                new MySqlParameter("@CentreID", search[0].CentreId)).Tables[0])
            {              
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);              
            }
        }
        catch (Exception ex)
        {
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }             
    }

    [WebMethod(EnableSession = true)]   
    public static string SaveInvDeliveryDays(List<InvestigationDeliveryDate> objsavedata)
    {
        string _UID = Guid.NewGuid().ToString();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            foreach (InvestigationDeliveryDate savedata in objsavedata)
            {


                sb = new StringBuilder();
                sb.Append(" INSERT INTO investiagtion_delivery_log (status,CentreID,labstarttime,labendtime,Processtype,SR_To_DR,SR_To_ST,");
                sb.Append(" ST_To_SLR,SLR_To_DR,SubcategoryID,Investigation_ID,TATType,woringhours,nonworinghours,stathours,");
                sb.Append(" Days,Sun,Mon,Tue,Wed,Thu,Fri,Sat,");
                sb.Append(" CutOffTime,samedaydeliverytime,nextdaydeliverytime,Approval_To_Dispatch,dtEntry,UserID,IpAddress,UserName,UniqueId,LogByID,LogBy,dtLog)");
                sb.Append(" Select 'old' status,CentreID,labstarttime,labendtime,Processtype,SR_To_DR,SR_To_ST,");
                sb.Append(" ST_To_SLR,SLR_To_DR,SubcategoryID,Investigation_ID,TATType,woringhours,nonworinghours,stathours,");
                sb.Append(" Days,Sun,Mon,Tue,Wed,Thu,Fri,Sat,");
                sb.Append(" CutOffTime,samedaydeliverytime,nextdaydeliverytime,Approval_To_Dispatch,dtEntry,UserID,IpAddress,UserName, ");
                sb.Append(" '" + _UID + "' UniqueId,'" + UserInfo.ID + "' LogByID,'" + UserInfo.LoginName + "' LogBy,NOW() dtLog ");
                sb.Append(" FROM investiagtion_delivery  where CentreID='" + objsavedata[0].CentreID + "'  and Investigation_ID='" + savedata.Investigation_ID + "'; ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());


                string str = "Delete from investiagtion_delivery where CentreID=@CentreID  and SubcategoryID=@SubcategoryID and Investigation_ID=@Investigation_ID ";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str,
                    new MySqlParameter("@CentreID", objsavedata[0].CentreID),
                    new MySqlParameter("@SubcategoryID", objsavedata[0].SubcategoryID),
                    new MySqlParameter("@ID", savedata.RowId));
             
               

                sb.Append(" INSERT INTO investiagtion_delivery (CentreID,labstarttime,labendtime,Processtype,SR_To_DR,SR_To_ST,");
                sb.Append(" ST_To_SLR,SLR_To_DR,SubcategoryID,Investigation_ID,TATType,woringhours,nonworinghours,stathours,");
                sb.Append(" Days,Sun,Mon,Tue,Wed,Thu,Fri,Sat,");
                sb.Append(" CutOffTime,samedaydeliverytime,CutOffTime1,samedaydeliverytime1,CutOffTime2,samedaydeliverytime2,nextdaydeliverytime,Approval_To_Dispatch,dtEntry,UserID,IpAddress,UserName,IsApplicable,IsApplicable1,IsApplicable2)");
                sb.Append(" VALUES ");
                sb.Append(" (@CentreID,@labstarttime,@labendtime,@Processtype,@SR_To_DR,@SR_To_ST,");
                sb.Append(" @ST_To_SLR,@SLR_To_DR,@SubcategoryID,@Investigation_ID,@TATType,@woringhours,@nonworinghours,@stathours,");
                sb.Append(" @Days,@Sun,@Mon,@Tue,@Wed,@Thu,@Fri,@Sat,");
                sb.Append(" @CutOffTime,@samedaydeliverytime,@CutOffTime1,@samedaydeliverytime1,@CutOffTime2,@samedaydeliverytime2,@nextdaydeliverytime,@Approval_To_Dispatch,now(),@UserID,@IpAddress,@UserName,@IsApplicable,@IsApplicable1,@IsApplicable2)");

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@CentreID",savedata.CentreID), new MySqlParameter("@labstarttime",Util.GetDateTime(savedata.labstarttime).ToString("HH:mm:ss")),
                    new MySqlParameter("@labendtime",Util.GetDateTime(savedata.labendtime).ToString("HH:mm:ss")), new MySqlParameter("@Processtype",savedata.Processtype),
                    new MySqlParameter("@SR_To_DR",savedata.SR_To_DR), new MySqlParameter("@SR_To_ST",savedata.SR_To_ST), new MySqlParameter("@ST_To_SLR",savedata.ST_To_SLR),
                    new MySqlParameter("@SLR_To_DR",savedata.SLR_To_DR), new MySqlParameter("@SubcategoryID",savedata.SubcategoryID),
                    new MySqlParameter("@Investigation_ID",savedata.Investigation_ID), new MySqlParameter("@TATType",savedata.TATType),
                    new MySqlParameter("@woringhours",savedata.woringhours), new MySqlParameter("@nonworinghours",savedata.nonworinghours),
                    new MySqlParameter("@stathours",savedata.stathours),
                     new MySqlParameter("@Days",savedata.Days), new MySqlParameter("@Sun",savedata.Sun),
                     new MySqlParameter("@Mon",savedata.Mon), new MySqlParameter("@Tue",savedata.Tue), new MySqlParameter("@Wed",savedata.Wed),
                    new MySqlParameter("@Thu",savedata.Thu), new MySqlParameter("@Fri",savedata.Fri), new MySqlParameter("@Sat",savedata.Sat),
                    new MySqlParameter("@CutOffTime",Util.GetDateTime(savedata.CutOffTime).ToString("HH:mm:ss")),
                    new MySqlParameter("@samedaydeliverytime",Util.GetDateTime(savedata.samedaydeliverytime).ToString("HH:mm:ss")),
                     new MySqlParameter("@CutOffTime1", Util.GetDateTime(savedata.CutOffTime1).ToString("HH:mm:ss")),
                    new MySqlParameter("@samedaydeliverytime1", Util.GetDateTime(savedata.samedaydeliverytime1).ToString("HH:mm:ss")),
                     new MySqlParameter("@CutOffTime2", Util.GetDateTime(savedata.CutOffTime2).ToString("HH:mm:ss")),
                    new MySqlParameter("@samedaydeliverytime2", Util.GetDateTime(savedata.samedaydeliverytime2).ToString("HH:mm:ss")),
                    new MySqlParameter("@nextdaydeliverytime",Util.GetDateTime(savedata.nextdaydeliverytime).ToString("HH:mm:ss")),
                    new MySqlParameter("@Approval_To_Dispatch",savedata.Approval_To_Dispatch),
                    new MySqlParameter("@UserID",UserInfo.ID),
                    new MySqlParameter("@IpAddress",StockReports.getip()),
                    new MySqlParameter("@UserName",UserInfo.LoginName),
                    new MySqlParameter("@IsApplicable", savedata.IsApplicable),
                    new MySqlParameter("@IsApplicable1", savedata.IsApplicable1),
                    new MySqlParameter("@IsApplicable2", savedata.IsApplicable2));

                sb = new StringBuilder();
                sb.Append(" INSERT INTO investiagtion_delivery_log (status,CentreID,labstarttime,labendtime,Processtype,SR_To_DR,SR_To_ST,");
                sb.Append(" ST_To_SLR,SLR_To_DR,SubcategoryID,Investigation_ID,TATType,woringhours,nonworinghours,stathours,");
                sb.Append(" Days,Sun,Mon,Tue,Wed,Thu,Fri,Sat,");
                sb.Append(" CutOffTime,samedaydeliverytime,nextdaydeliverytime,Approval_To_Dispatch,dtEntry,UserID,IpAddress,UserName,UniqueId,LogByID,LogBy,dtLog)");
                sb.Append(" Select 'NEW' status,CentreID,labstarttime,labendtime,Processtype,SR_To_DR,SR_To_ST,");
                sb.Append(" ST_To_SLR,SLR_To_DR,SubcategoryID,Investigation_ID,TATType,woringhours,nonworinghours,stathours,");
                sb.Append(" Days,Sun,Mon,Tue,Wed,Thu,Fri,Sat,");
                sb.Append(" CutOffTime,samedaydeliverytime,nextdaydeliverytime,Approval_To_Dispatch,dtEntry,UserID,IpAddress,UserName, ");
                sb.Append(" '" + _UID + "' UniqueId,'" + UserInfo.ID + "' LogByID,'" + UserInfo.LoginName + "' LogBy,NOW() dtLog ");
                sb.Append(" FROM investiagtion_delivery  where CentreID='" + objsavedata[0].CentreID + "'  and Investigation_ID='" + savedata.Investigation_ID + "'; ");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
            }
            Tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Success" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = ex.InnerException.ToString() });
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }   
}


public class InvestigationDeliveryDate
{
    public string RowId { get; set; }

   public string CentreID { get; set; }
   public string labstarttime { get; set; }
   public string labendtime { get; set; }
   public string Processtype { get; set; }
   public string SR_To_DR { get; set; }
   public string SR_To_ST { get; set; }
   public string ST_To_SLR { get; set; }
   public string SLR_To_DR { get; set; }
   public string SubcategoryID { get; set; }
   public string Investigation_ID { get; set; }
   public string TATType { get; set; }
   public string woringhours { get; set; }
   public string nonworinghours { get; set; }
   public string stathours { get; set; }
   public string Days { get; set; }

   public string Sun { get; set; }
   public string Mon { get; set; }
   public string Tue { get; set; }
   public string Wed { get; set; }
   public string Thu { get; set; }
   public string Fri { get; set; }
   public string Sat { get; set; }
   public string CutOffTime { get; set; }
   public string samedaydeliverytime { get; set; }
   public int IsApplicable { get; set; }
   public string CutOffTime1 { get; set; }
   public string samedaydeliverytime1 { get; set; }
   public int IsApplicable1 { get; set; }
   public string CutOffTime2 { get; set; }
   public string samedaydeliverytime2 { get; set; }
   public int IsApplicable2 { get; set; }
   public string nextdaydeliverytime { get; set; }
   public string Approval_To_Dispatch { get; set; }
  
}
public class SearchDeliveryDay
{
    public string TestName { get; set; }
    public string CentreId { get; set; }
    public string SubCategoryId { get; set; }
}