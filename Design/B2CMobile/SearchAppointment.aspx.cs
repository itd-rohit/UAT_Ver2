using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using MySql.Data.MySqlClient;

public partial class Design_PROApp_SearchAppointment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        //if (Util.MobileApp() == "N")
        //{
        //    //  Response.Redirect("../NotAuthorized.aspx");
        //}
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtappdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //      txtapptime.Text = DateTime.Now.AddMinutes(30).ToString("hh:mm tt");

            txtassigndate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //txtassigtime.Text = DateTime.Now.AddMinutes(30).ToString("hh:mm tt");
            DataTable dt = StockReports.GetDataTable("SELECT proname NAME ,proid FROM pro_master WHERE proname<>'' ORDER BY proname");
            if (dt.Rows.Count > 0)
            {
                ddlProName.DataSource = dt;
                ddlProName.DataTextField = "name";
                ddlProName.DataValueField = "proid";
                ddlProName.DataBind();
                ddlProName.Items.Insert(0, new ListItem("N/A", ""));

            }
            BindInvestigation();
        }
    }
    protected void rdbItem_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindInvestigation();

    }

    private void BindInvestigation()
    {


        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT TypeName,   item ,CAST(concat(ItemID,TypeName,'#',isUrgent,'#',DeliveryDate,'#',InvID,'#',IsOutSrc,'#',GenderInvestigate,'#',IF(`Description` = 'Non path','1', '0' )) AS CHAR) ItemID FROM  ( ");
        sb.Append("   SELECT testcode, TypeName,isUrgent,DeliveryDate,InvID,IsOutSrc,item,cast(CONCAT(ItemID,'#',SubCategoryID,'#',CAST(LabType AS BINARY),'#',IFNULL(Type_ID,''),'#',IF(Sample='N','N',Sample),'#',SampleRemarks,'#X#')as char) ItemID,GenderInvestigate,Description    ");
        sb.Append(" FROM(SELECT  IF(IFNULL(im.TestCode,'')='',IF(IFNULL(im.Inv_ShortName,'')='',im.TypeName,im.Inv_ShortName),CONCAT(IF(IFNULL(im.Inv_ShortName,'')='',im.TypeName,im.Inv_ShortName)))Item");
        sb.Append(" ,date_format(DATE_ADD(DATE(NOW()), INTERVAL IF(HOUR(NOW())>=16,IFNULL(inv.TimeLimit,0)+1,IFNULL(inv.TimeLimit,0)) DAY),'%d-%b-%Y') DeliveryDate ");
        sb.Append(" ,im.TestCode,im.TypeName ,ifnull(inv.isUrgent,0)isUrgent,inv.Investigation_Id as InvID,ifnull(im.IsTrigger,0)IsOutSrc,im.ItemID,im.SubCategoryID,im.Type_ID,  (CASE WHEN cr.ConfigRelationID=3 THEN 'LAB' WHEN cr.ConfigRelationID=25 THEN 'PRO'  ");
        sb.Append(" WHEN cr.ConfigRelationID =26  THEN 'OTH' END)LabType,  ifnull(inv.TYPE,'N') Sample ,IFNULL(inv.SampleRemarks,'') SampleRemarks, inv.GenderInvestigate ,sm.Description  ");
        sb.Append("  FROM f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = im.subcategoryid ");
        sb.Append("INNER JOIN f_configrelation  cr ON cr.categoryid = sm.categoryid ");
        sb.Append(" LEFT JOIN Investigation_master inv ON inv.Investigation_ID=im.Type_ID ");
        sb.Append(" WHERE cr.ConfigRelationID =3 ");
        sb.Append(" AND im.IsActive=1 AND sm.Active=1  )t1  ");

        sb.Append(" UNION ALL   ");

        sb.Append(" SELECT im.testcode, im.TypeName,'0' isUrgent,0 DeliveryDate,GROUP_CONCAT(inv.Investigation_Id ) InvID ,'0' IsOutSrc, IF(IFNULL(im.TestCode,'')='',IF(IFNULL(im.Inv_ShortName,'')='',im.TypeName,im.Inv_ShortName),CONCAT(IF(IFNULL(im.Inv_ShortName,'')='',im.TypeName,im.Inv_ShortName)))Item,    ");
        sb.Append(" cast(CONCAT(im.ItemID,'#',im.SubCategoryID,'#','OPK','#',IFNULL(im.Type_ID,''),'#','X','#',CAST(CONCAT('<b>Investigation</b><br>',GROUP_CONCAT(inv.Name SEPARATOR '<br>')) AS CHAR),'#OPK','#') as char) ItemID, inv.GenderInvestigate, scm.Description   FROM f_itemmaster im   ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=im.SubCategoryID AND im.IsActive=1  ");
        sb.Append(" INNER JOIN f_configrelation cr ON cr.CategoryID=scm.CategoryID   ");

        sb.Append("  INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID  ");
        sb.Append("  INNER JOIN investigation_master inv  ON inv.Investigation_Id=pld.InvestigationID ");

        sb.Append(" AND cr.ConfigRelationID=23 GROUP BY im.ItemID ) AS t2 ORDER BY TypeName  ");
        DataTable dtInv = new DataTable();
        dtInv = StockReports.GetDataTable(sb.ToString());
        //dtInv.ReadXml(Server.MapPath("~/Design/Lab/LabItems/" + rdbItem.SelectedValue + ".xml"));
        if (dtInv != null && dtInv.Rows.Count > 0)
        {

            //    dtInv.WriteXml(Server.MapPath("~/Design/Lab/LabItems/" + rdbItem.SelectedValue + ".xml"));
            lstInv.DataSource = dtInv;
            lstInv.DataTextField = "Item";
            lstInv.DataValueField = "ItemID";
            lstInv.DataBind();
        }
        else
        {
            lstInv.Items.Clear();

        }

    }
    [WebMethod(EnableSession = true)]
    public static string getItemRate(string ItemID, string Panel_id, string mrp, string doctor, string DiscPanelID, string age, string CardNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Rate = "0", FRate = "0";
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Get_DeliveryDate(@centreid,im.`Type_ID`,now()) DeliveryDate,IFNULL(im.ItemID,'')chk,'0' IsLock,fr.Rate FROM ");
            sb.Append(" (SELECT * FROM `f_itemmaster` WHERE ItemID=@ItemID) im ");
            sb.Append(" inner join  f_panel_master pm  on  pm.Panel_ID=@Panel_id ");
            sb.Append(" inner join f_ratelist fr on fr.ItemId=im.Itemid and fr.Panel_ID=pm.Panel_ID");
            DataTable dtRate = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@centreid", UserInfo.Centre), new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@Panel_id", Panel_id)).Tables[0];

            string mrprate = MySqlHelper.ExecuteScalar(con, "select ifnull(mrp_rate,0) from `f_ratelist` WHERE `ItemID`=@ItemID AND `Panel_ID`=@Panel_id limit 1", new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@Panel_id", Panel_id)).ToString();
            if (mrprate == "0")
            {
                mrprate = MySqlHelper.ExecuteScalar(con, "select ifnull(mrp_rate,0) from `f_ratelist` WHERE `ItemID`=@ItemID AND `Panel_ID`=@Panel_id limit 1", new MySqlParameter("@ItemID", ItemID), new MySqlParameter("@Panel_id", Panel_id)).ToString();
            }
            if (mrp == "0")
            {
                if (dtRate != null && dtRate.Rows.Count > 0)
                    Rate = Util.GetString(Util.GetString(dtRate.Rows[0]["Rate"]) + '#' + Util.GetString(dtRate.Rows[0]["chk"]) + '#' + Util.GetString(dtRate.Rows[0]["DeliveryDate"]) + '#' + Util.GetString(dtRate.Rows[0]["IsLock"]) + '#' + FRate);
                //string itemid = StockReports.ExecuteScalar(" select li.ItemID from f_item_lock li where li.ItemID='" + ItemID + "' and li.Panel_ID='" + Panel_id + "' ");
            }
            else
            {
                if (dtRate != null && dtRate.Rows.Count > 0)
                    Rate = Util.GetString(mrprate + '#' + Util.GetString(dtRate.Rows[0]["chk"]) + '#' + Util.GetString(dtRate.Rows[0]["DeliveryDate"]) + '#' + Util.GetString(dtRate.Rows[0]["IsLock"]) + '#' + FRate);
                //string itemid = StockReports.ExecuteScalar(" select li.ItemID from f_item_lock li where li.ItemID='" + ItemID + "' and li.Panel_ID='" + Panel_id + "' ");
            }
            //Rate = Rate + '#' + itemid;
            string discount = "", disctype = "", Discby = "", discountapp = "", AllowTest = "";

            if (mrprate == "")
            {
                mrprate = "0";
            }
            return Rate + "#" + discount + "#" + discountapp + "#" + disctype + "#" + mrprate + "#" + Discby + "#" + AllowTest;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);           
            return ex.InnerException.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveCalldata(string Title, string Pname, string Mobile, string Age, string Gender, string Email, string Address, string Appdate, string itemdata, string TotalAmount, string Discountamount, string DiscountReason, string PaidAmount, string Remarks, string dob, string Appid, string TimeSlot)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string StartTime = Util.GetDateTime(TimeSlot.Split('-')[0]).ToString("HH:mm:ss");
            string EndTime = Util.GetDateTime(TimeSlot.Split('-')[1]).ToString("HH:mm:ss");

            bool a = false;
            string[] itemRow = itemdata.Split(',');
            int itemRowLength = itemRow.Length;
            double grossamount = Util.GetDouble(Discountamount) + Util.GetDouble(TotalAmount);
            DateTime dt = Util.GetDateTime(Appdate);
            DateTime dobt = Util.GetDateTime(dob);
            string str = StockReports.ExecuteScalar(" select MAX(Id+1) From  app_appointment");

            if (Appid != "")
            {
                string instCentre = @"UPDATE app_appointment set TimeSlot=@TimeSlot,Starttime=TIME_FORMAT(@StartTime,'%h:%i:%s'),EndTime=TIME_FORMAT(@EndTime,'%h:%i:%s'),
                Title=@Title,NAME=@Pname,mobile=@Mobile,email=@Email,address=@Address,
gender=@Gender,age=@Age,grossamount=@grossamount,
netamount=@TotalAmount,
                dicountontotal=@Discountamount 
                ,paymentmode='CASH',paidamount=@PaidAmount,appfrom='MOBILE',remarks=@remarks,
                dob=@dobt where id=@Appid";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, instCentre,
                                      new MySqlParameter("@TimeSlot", TimeSlot),
                                      new MySqlParameter("@StartTime", StartTime),
                                      new MySqlParameter("@EndTime", EndTime),
                                      new MySqlParameter("@Title", Title),
                                       new MySqlParameter("@Pname", Pname),
                                      new MySqlParameter("@Mobile", Mobile),
                                      new MySqlParameter("@Email", Email),
                                       new MySqlParameter("@Address", Address),
                                      new MySqlParameter("@Gender", Gender),
                                      new MySqlParameter("@Age", Age),
                                       new MySqlParameter("@grossamount", grossamount),
                                      new MySqlParameter("@TotalAmount", Util.GetDouble(TotalAmount)),
                                      new MySqlParameter("@Discountamount", Util.GetDouble(Discountamount)),
                                      new MySqlParameter("@PaidAmount", Util.GetDouble(PaidAmount)),
                                      new MySqlParameter("@remarks", Remarks),
                                       new MySqlParameter("@dobt", dobt.ToString("yyyy-MM-dd HH:mm:ss")),
                                      new MySqlParameter("@Appid", Appid)

                                      );


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete  from  app_appointment_inv where appid=@Appid ", new MySqlParameter("@Appid", Appid)
                                      );

                a = true;

            }
            else
            {
                string atr = "INSERT INTO app_appointment(TimeSlot,Starttime,EndTime,Title,NAME,mobile,App_Date,email,address,gender,status,age,AppBook_By,AppBook_ByName,grossamount,netamount,dicountontotal,paymentmode,paidamount,DiscountReason,appfrom,remarks,dob) VALUE (@TimeSlot,TIME_FORMAT(@StartTime,'%h:%i:%s'),TIME_FORMAT(@EndTime,'%h:%i:%s'), @Title,@Pname,@Mobile,@dt ,@Email,@Address,@Gender,'Open',@Age,@UserId,@UserName,@grossamount ,@TotalAmount,@Discountamount,'CASH',@PaidAmount,@DiscountReason,'LISCall',@Remarks ,@dobt)";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, atr,
                                     new MySqlParameter("@TimeSlot", TimeSlot),
                                     new MySqlParameter("@StartTime", StartTime),
                                     new MySqlParameter("@EndTime", EndTime),
                                     new MySqlParameter("@Title", Title),
                                      new MySqlParameter("@Pname", Pname),
                                     new MySqlParameter("@Mobile", Mobile),
                                     new MySqlParameter("@Email", Email),
                                      new MySqlParameter("@Address", Address),
                                     new MySqlParameter("@Gender", Gender),
                                     new MySqlParameter("@Age", Age),
                                      new MySqlParameter("@dt", dobt.ToString("yyyy-MM-dd HH:mm:ss")),
                                      new MySqlParameter("@grossamount", grossamount),
                                     new MySqlParameter("@TotalAmount", Util.GetDouble(TotalAmount)),
                                     new MySqlParameter("@Discountamount", Util.GetDouble(Discountamount)),
                                     new MySqlParameter("@PaidAmount", Util.GetDouble(PaidAmount)),
                                     new MySqlParameter("@remarks", Remarks),
                                      new MySqlParameter("@dobt", dobt.ToString("yyyy-MM-dd HH:mm:ss")),
                                     new MySqlParameter("@UserName", UserInfo.UserName),
                                       new MySqlParameter("@UserId", UserInfo.ID)

                                     );
                a = true;
            }
            for (int i = 0; i < itemRowLength - 1; i++)
            {
                if (Appid != "")
                {
                    string str1 = "insert into app_appointment_inv(appid,investigationid) value(@appid ,@test)";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str1.ToString(),
                    new MySqlParameter("@appid", Util.GetString(Appid)),
                     new MySqlParameter("@test", itemRow[i]));
                }
                else
                {
                    string str1 = "insert into app_appointment_inv(appid,investigationid) value(@appid ,@test)";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str1.ToString(),
                    new MySqlParameter("@appid", Util.GetInt(str)),
                     new MySqlParameter("@test", itemRow[i]));
                }
            }
            tnx.Commit();
            return a.ToString();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return ex.InnerException.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string popupData(string id)
    {
        //DataTable dt= StockReports.GetDataTable("SELECT id,NAME as Name,Mobile,Age,Gender,Address,DATE_FORMAT(app_date,'%d-%b-%y %h:%m %p') App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %h:%m %p') Entrydate,STATUS,assign_Pro FROM app_appointment");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT remarks, IF(STATUS='Cancel',CONCAT(IFNULL(cancel_reason,''),' User-',cancelbyname),'') cancel_reason, IFNULL(appbook_byname,'')appbook_byname, IFNULL(appfrom,'')appfrom, id,CONCAT(IFNULL(aa.Title,''),NAME) NAME,aa.Mobile,IF(age='',(SELECT Get_Age (dob)),age) Age,aa.Gender,IF(assign_date='0001-01-01 00:00:00','',DATE_FORMAT(assign_date,'%d-%b-%y %I:%i %p')) assign_date,DATE_FORMAT(app_date,'%d-%b-%y %I:%i %p') App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %I:%i %p') Entrydate, ");
            sb.Append(" STATUS,IFNULL(proname,'') proname,CASE WHEN STATUS = 'Open' THEN 'White' WHEN STATUS = 'AppConfirm' THEN '#B0C4DE' WHEN STATUS = 'PhleboAssign' THEN '#CC99FF' WHEN STATUS = 'SampleCollectedHome'  ");
            sb.Append(" THEN 'Pink' WHEN STATUS = 'BookingDone' THEN '#00FFFF' WHEN STATUS = 'ResultDone' THEN '#90EE90' WHEN STATUS = 'Dispatched' THEN '#44A3AA' ");
            sb.Append(" WHEN STATUS = 'Acknowledged' THEN '#3399FF' WHEN STATUS = 'Closed' THEN '#FFFF00' ELSE '#E2680A' ");
            sb.Append("  END rowColor, ");
            sb.Append(" (select group_concat(IFNULL(typename,''))  from app_appointment_inv inner join f_itemmaster on itemid=investigationid where appid=aa.id) TestName ");
            sb.Append(" FROM app_appointment aa left join pro_master pr on aa.assign_Pro=pr.proid ");

            sb.Append(" where id=@ID ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@centreid", UserInfo.Centre), new MySqlParameter("@ID", id)).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Searchdata(string Fromdate, string Todate, string status, string dateoption, string ProAssign)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT if(imagePath!='',1,0) pathcount,ifNULL(remarks,'')remarks, IF(STATUS='Cancel',CONCAT(IFNULL(cancel_reason,''),' User-',cancelbyname),'') cancel_reason, IFNULL(appbook_byname,'')appbook_byname, ifNULL(appfrom,'')appfrom, id,CONCAT(IFNULL(aa.Title,''),NAME) NAME,aa.Mobile,aa.age,aa.Gender,IF(assign_date='0001-01-01 00:00:00','',IFNULL(DATE_FORMAT(assign_date,'%d-%b-%y %I:%i %p'),'')) assign_date, IFNULL(CONCAT(DATE_FORMAT(App_date,'%d-%b-%Y'),' ',TimeSlot),'') App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %I:%i %p') Entrydate, "); // IF(IFNULL(age,'')='',IFNULL((SELECT Get_Age (dob)),age),'') Age
            sb.Append(" STATUS,IFNULL(proname,'') proname,CASE WHEN STATUS = 'Open' THEN 'White' WHEN STATUS = 'AppConfirm' THEN '#B0C4DE' WHEN STATUS = 'PhleboAssign' THEN '#CC99FF' WHEN STATUS = 'SampleCollectedHome'  ");
            sb.Append(" THEN 'Pink' WHEN STATUS = 'BookingDone' THEN '#00FFFF' WHEN STATUS = 'ResultDone' THEN '#90EE90' WHEN STATUS = 'Dispatched' THEN '#44A3AA' ");
            sb.Append(" WHEN STATUS = 'Acknowledged' THEN '#3399FF' WHEN STATUS = 'Closed' THEN '#FFFF00' ELSE '#E2680A' ");
            sb.Append("  END rowColor, ");
            sb.Append(" (select IFNULL(GROUP_CONCAT(REPLACE(typename,',',' ') SEPARATOR '<br/>'),'')  from app_appointment_inv inner join f_itemmaster im on itemid=investigationid AND im.isActive=1 where appid=aa.id) TestName ");
            sb.Append(" FROM app_appointment aa left join pro_master pr on aa.assign_Pro=pr.proid  ");
            if (dateoption == "EntryDate")
            {
                sb.Append(" where  aa.IsPatientApp= 1 and  dtEntry>=@Fromdate and dtEntry<=@Todate ");
            }
            else
            {
                sb.Append(" where  aa.IsPatientApp= 1 and  app_date>=@Fromdate and app_date<=@Todate ");
            }

            if (status != "")
            {
                sb.Append(" and status=@status");
            }
            if (ProAssign != "N/A")
            {
                sb.Append(" and proname=@ProAssign");
            }
            sb.Append("  ORDER BY id DESC ");
            if (Util.GetString(HttpContext.Current.Session["ID"]) == "1")
            {
                // System.IO.File.WriteAllText("C:\\LedgerTransaction.txt", sb.ToString());
            }
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Fromdate", string.Concat(Util.GetDateTime(Fromdate).ToString("yyyy-MM-dd"), " 00:00:00")),
                 new MySqlParameter("@Todate", string.Concat(Util.GetDateTime(Todate).ToString("yyyy-MM-dd"), " 23:59:59")),
                  new MySqlParameter("@status", status),
                   new MySqlParameter("@ProAssign", ProAssign)
                 ).Tables[0];


            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }


    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getAppointment(string ids)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL(aa.TimeSlot,'Select') TimeSlot,aa.IsPrescription pathcount,ifNULL(remarks,'')remarks, IF(STATUS='Cancel',CONCAT(IFNULL(cancel_reason,''),' User-',cancelbyname),'') cancel_reason, IFNULL(appbook_byname,'')appbook_byname, ifNULL(appfrom,'')appfrom, id,CONCAT(IFNULL(aa.Title,''),NAME) NAME,aa.Mobile,IF(IFNULL(age,'')='',IFNULL((SELECT Get_Age (dob)),age),'') Age,aa.Gender,IF(assign_date='0001-01-01 00:00:00','',IFNULL(DATE_FORMAT(assign_date,'%d-%b-%y %I:%i %p'),'')) assign_date, CONCAT(DATE_FORMAT(App_date,'%d-%b-%Y'),' ',TimeSlot) App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %I:%i %p') Entrydate,IFNULL(dob,'')dob,IFNULL(aa.Address,'')Address, ");
            sb.Append(" STATUS,IFNULL(proname,'') proname,CASE WHEN STATUS = 'Open' THEN 'White' WHEN STATUS = 'AppConfirm' THEN '#B0C4DE' WHEN STATUS = 'PhleboAssign' THEN '#CC99FF' WHEN STATUS = 'SampleCollectedHome'  ");
            sb.Append(" THEN 'Pink' WHEN STATUS = 'BookingDone' THEN '#00FFFF' WHEN STATUS = 'ResultDone' THEN '#90EE90' WHEN STATUS = 'Dispatched' THEN '#44A3AA' ");
            sb.Append(" WHEN STATUS = 'Acknowledged' THEN '#3399FF' WHEN STATUS = 'Closed' THEN '#FFFF00' ELSE '#E2680A' ");
            sb.Append("  END rowColor, ");
            sb.Append(" (select IFNULL( GROUP_CONCAT(itemID) ,'') from app_appointment_inv inner join f_itemmaster im on itemID=investigationid AND im.isActive=1 where appid=aa.id) TestName ");
            sb.Append(" FROM app_appointment aa left join pro_master pr on aa.assign_Pro=pr.proid and aa.IsPatientApp= 1 ");
            sb.Append(" Where aa.id=@id");

            sb.Append("  ORDER BY id DESC ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),

                  new MySqlParameter("@id", ids)
                ).Tables[0];
            //System.IO.File.WriteAllText("C:\\LedgerTransaction.txt", sb.ToString());           

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }


    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetItemDetails(string itemId)
    {
        //DataTable dt= StockReports.GetDataTable("SELECT id,NAME as Name,Mobile,Age,Gender,Address,DATE_FORMAT(app_date,'%d-%b-%y %h:%m %p') App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %h:%m %p') Entrydate,STATUS,assign_Pro FROM app_appointment");

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine(@" SELECT testcode, TypeName,isUrgent,DeliveryDate,InvID,IsOutSrc,item,CONCAT(Rate,'##0001-01-01##0#0##',Rate,'##') Rate,
                 CAST(CONCAT(ItemID,'#',SubCategoryID,'#',CAST(LabType AS BINARY),'#',IFNULL(Type_ID,''),'#',IF(Sample='N','N',Sample),'#',SampleRemarks,'#X#')AS CHAR) ItemID,
                 GenderInvestigate,Description     FROM(SELECT  IF(IFNULL(im.TestCode,'')='',IF(IFNULL(im.Inv_ShortName,'')='',im.TypeName,im.Inv_ShortName),
                 CONCAT(IF(IFNULL(im.Inv_ShortName,'')='',im.TypeName,im.Inv_ShortName)))Item ,DATE_FORMAT(DATE_ADD(DATE(NOW()), INTERVAL IF(HOUR(NOW())>=16,
                 IFNULL(inv.TimeLimit,0)+1,IFNULL(inv.TimeLimit,0)) DAY),'%d-%b-%Y') DeliveryDate  ,im.TestCode,im.TypeName ,IFNULL(inv.isUrgent,0)isUrgent,inv.Investigation_Id AS InvID,
                 IFNULL(im.IsTrigger,0)IsOutSrc,im.ItemID,im.SubCategoryID,im.Type_ID,  (CASE WHEN cr.ConfigRelationID=3 THEN 'LAB' WHEN cr.ConfigRelationID=25 THEN 'PRO' 
                 WHEN cr.ConfigRelationID =26  THEN 'OTH' END)LabType,  IFNULL(inv.TYPE,'N') Sample ,IFNULL(inv.SampleRemarks,'') SampleRemarks, 
                 inv.GenderInvestigate ,sm.Description,get_itemrate(im.ItemID,'78') Rate     FROM f_itemmaster im ");
            sb.AppendLine("  INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = im.subcategoryid  AND im.ItemID=@itemId ");
            sb.AppendLine(@" INNER JOIN f_configrelation  cr ON cr.categoryid = sm.categoryid  
                 LEFT JOIN Investigation_master inv ON inv.Investigation_ID=im.Type_ID  
                 WHERE  im.IsActive=1 AND sm.Active=1 GROUP BY im.ItemID )t1 ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),

                 new MySqlParameter("@itemId", itemId)
               ).Tables[0];


            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }


    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static Dictionary<string, string> SearchdataExcel(string Fromdate, string Todate, string status, string dateoption, string ProAssign)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            DateTime dateFrom = Convert.ToDateTime(Fromdate);
            DateTime dateTo = Convert.ToDateTime(Todate);      
            sb.Append(" SELECT  aa.id,CONCAT(IFNULL(aa.Title,''),aa.NAME) NAME,aa.Mobile,IF(aa.age='',(SELECT Get_Age (dob)),age) Age,aa.Gender,IF(assign_date='0001-01-01 00:00:00','',DATE_FORMAT(assign_date,'%d-%b-%y %I:%i %p')) assign_date,DATE_FORMAT(app_date,'%d-%b-%y %I:%i %p') App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %I:%i %p') Entrydate, ");
            sb.Append(" STATUS,proname,remarks,appbook_byname, appfrom, cancel_reason,cancelbyname, ");
            sb.Append(" (select group_concat(typename)  from app_appointment_inv inner join f_itemmaster on itemid=investigationid where appid=aa.id) TestName ");
            sb.Append(" FROM app_appointment aa left join pro_master pr on aa.assign_Pro=pr.proid ");
            if (dateoption == "EntryDate")
            {
                sb.Append(" where  aa.IsPatientApp= 1 and  dtEntry>=@FromDate and dtEntry<=@ToDate ");
            }
            else
            {
                sb.Append(" where  aa.IsPatientApp= 1 and  app_date>=@FromDate and app_date<=@ToDate ");
            }

            if (status != "")
            {
                sb.Append(" and status=@status");
            }
            if (ProAssign != "N/A")
            {
                sb.Append(" and proname=@ProAssign");
            }
            sb.Append("  ORDER BY id DESC ");
            string Period = string.Concat("From : ", Util.GetDateTime(dateFrom).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(dateTo).ToString("dd-MMM-yyyy"));

            Dictionary<string, string> returnData = new Dictionary<string, string>();
            returnData.Add("ReportDisplayName", Common.EncryptRijndael("Mobile App Booking"));
            returnData.Add("status#0", Common.EncryptRijndael(status));
            returnData.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(dateFrom).ToString("yyyy-MM-dd"), " ", "00:00:00")));
            returnData.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(dateTo).ToString("yyyy-MM-dd"), " ", "23:59:59")));
            returnData.Add("Query", Common.EncryptRijndael(sb.ToString()));
            returnData.Add("Period", Common.EncryptRijndael(Period));
            returnData.Add("ReportPath", "../Common/ExportToExcelReport.aspx");
            returnData.Add("ProAssign", Common.EncryptRijndael(ProAssign));
            returnData.Add("entrymonth", Common.EncryptRijndael("1"));
            return returnData;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }

    }   
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ConfirmApp(string Appid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE app_appointment SET STATUS='AppConfirm' ,Statusdate=NOW(),AppConfirm_ByName=@AppConfirm_ByName WHERE id=@Appid",
                                 new MySqlParameter("@AppConfirm_ByName", UserInfo.LoginName),

                                 new MySqlParameter("@Appid", Appid));
            tnx.Commit();
            return "True".ToString();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BookingDone(string Appid)
    {
        //CommonSchedulerClass cls = new CommonSchedulerClass();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string result = "0";
            bool IsTestEx = false;
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL(aa.dob,'')dob, remarks, IF(STATUS='Cancel',CONCAT(IFNULL(cancel_reason,''),' User-',cancelbyname),'') cancel_reason, appbook_byname, appfrom, id,IFNULL(aa.Title,'') Title ,aa.NAME,aa.Mobile,IF(age='',(SELECT Get_Age (dob)),age) Age,aa.Gender,IF(assign_date='0001-01-01 00:00:00','',DATE_FORMAT(assign_date,'%d-%b-%y %I:%i %p')) assign_date,DATE_FORMAT(app_date,'%d-%b-%y %I:%i %p') App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %I:%i %p') Entrydate, ");
            sb.Append(" STATUS,proname proname,doctorid, aa.Address,");
            sb.Append(" (SELECT GROUP_CONCAT(itemid) FROM app_appointment_inv INNER JOIN f_itemmaster ON itemid=investigationid WHERE appid=aa.id) TestName");
            sb.Append(" FROM app_appointment aa left join pro_master pr on aa.assign_Pro=pr.proid ");

            sb.Append(" where id=@Appid");


            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Appid", Appid)
              ).Tables[0];
            // sb.Append("  ORDER BY id DESC ");

            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["TestName"].ToString() != "")
                {
                    //IsTestEx = true;
                    //cls.BarcodeNo = "";
                    //cls.AppointmentId = dt.Rows[0]["id"].ToString();
                    //cls.Panel_Id = "78";
                    //cls.IsCredit = "0";
                    //cls.CenterId = "1";
                    //cls.CentreCode = "1";
                    //cls.Doctor = dt.Rows[0]["doctorid"].ToString();
                    //cls.PName = dt.Rows[0]["NAME"].ToString();
                    //cls.MobileNo = dt.Rows[0]["Mobile"].ToString();
                    //cls.Title = dt.Rows[0]["Title"].ToString();
                    //cls.AGE_in_Days = dt.Rows[0]["Age"].ToString();
                    //cls.Gender = dt.Rows[0]["Gender"].ToString();
                    //cls.Address = dt.Rows[0]["Address"].ToString();
                    //cls.Test_ID = dt.Rows[0]["TestName"].ToString();
                    //cls.OtherDoctor = "DR.OTHER";
                    //cls.TotalAmount = 0;
                    //cls.dob = dt.Rows[0]["dob"].ToString();
                    ////cls.CollectionDateTime = CollectionDateTime;
                    //result = cls.HisToLisBooking();


                }
                else
                {
                    IsTestEx = false;
                }

            }
            if (!IsTestEx)
            {
                return "0#Please Add Test";
            }
            else if (result == "0")
            {
                return "0#Unable to Booking done";
            }
            else
            {
                return "1#" + result;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    //[WebMethod(EnableSession = true)]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static string Booking_Edit(string Appid, string PatientID, string LabNo)
    //{
    //    CommonSchedulerClass cls = new CommonSchedulerClass();
    //    MySqlConnection con = Util.GetMySqlCon();
    //    con.Open();
    //    MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
    //    try
    //    {
    //        bool a = false;
    //        StringBuilder sb = new StringBuilder();
    //        sb.Append(" SELECT remarks, IF(STATUS='Cancel',CONCAT(IFNULL(cancel_reason,''),' User-',cancelbyname),'') cancel_reason, appbook_byname, appfrom, id,IFNULL(aa.Title,'') Title ,aa.NAME,aa.Mobile,IF(age='',(SELECT Get_Age (dob)),age) Age,aa.Gender,IF(assign_date='0001-01-01 00:00:00','',DATE_FORMAT(assign_date,'%d-%b-%y %I:%i %p')) assign_date,DATE_FORMAT(app_date,'%d-%b-%y %I:%i %p') App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %I:%i %p') Entrydate, ");
    //        sb.Append(" STATUS,proname proname,doctorid, aa.Address,");
    //        sb.Append(" (select group_concat(Investigation_ID)  from app_appointment_inv inner join investigation_master inv ON inv.Investigation_ID=investigationid where appid=aa.id) TestName ");
    //        sb.Append(" FROM app_appointment aa left join pro_master pr on aa.assign_Pro=pr.proid ");

    //        sb.Append(" where id=@Appid");


    //        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
    //            new MySqlParameter("@Appid", Appid)
    //          ).Tables[0];
    //        if (dt.Rows.Count > 0)
    //        {
    //            cls.BarcodeNo = "";
    //            cls.AppointmentId = dt.Rows[0]["id"].ToString();
    //            cls.Panel_Id = "78";
    //            cls.IsCredit = StockReports.ExecuteScalar("select if(Payment_Mode='Credit',1,0) from f_Panel_Master where Panel_ID=" + "78" + "");
    //            cls.CenterId = "1";
    //            cls.CentreCode = "1";
    //            cls.Doctor = dt.Rows[0]["doctorid"].ToString();
    //            cls.PName = dt.Rows[0]["NAME"].ToString();
    //            cls.MobileNo = dt.Rows[0]["Mobile"].ToString();
    //            cls.Title = dt.Rows[0]["Title"].ToString();
    //            cls.AGE_in_Days = dt.Rows[0]["Age"].ToString();
    //            cls.Gender = dt.Rows[0]["Gender"].ToString();
    //            cls.Address = dt.Rows[0]["Address"].ToString();
    //            cls.Test_ID = dt.Rows[0]["TestName"].ToString();
    //            cls.OtherDoctor = "DR.OTHER";
    //            cls.TotalAmount = 0;
    //            cls.PatientIDNew = PatientID;
    //            cls.LabNo = LabNo;
    //            //cls.CollectionDateTime = CollectionDateTime;
    //            string result = cls.HisToLisBooking_Edit();
    //            if (result == "1")
    //            {
    //                // a = StockReports.ExecuteDML("  UPDATE app_appointment SET STATUS='BookingDone' ,Statusdate=NOW(),AppConfirm_ByName='" + HttpContext.Current.Session["LoginName"].ToString() + "' WHERE id='" + Appid + "'");

    //                //dt = StockReports.GetDataTable("SELECT id, NAME FROM app_appointment  WHERE id='" + appid + "' ");
    //                //dr["status"] = "success";
    //                //dr["message"] = "Appointment Added successfully!";
    //                //dr["data"] = makejsonoftable(dt, makejson.e_with_square_brackets);
    //            }
    //        }
    //        //  bool a = true;
    //        return a.ToString();
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);

    //        return ex.InnerException.Message;
    //    }
    //    finally
    //    {

    //        con.Close();
    //        con.Dispose();
    //    }
    //}

    //[WebMethod(EnableSession = true)]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static string SampleCollectedApp(string Appid)
    //{
    //    MySqlConnection con = Util.GetMySqlCon();
    //    con.Open();
    //    MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
    //    try
    //    {
    //        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE app_appointment SET STATUS='SampleCollectedHome' ,Statusdate=NOW(),samplecollectby=@samplecollectby ,samplecollectiondate=now() WHERE id=@Appid",
    //                                 new MySqlParameter("@samplecollectby", UserInfo.LoginName),
    //                                 new MySqlParameter("@Appid", Appid));
    //        tnx.Commit();
    //        return "true";
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //        tnx.Rollback();
    //        return ex.InnerException.Message;
    //    }
    //    finally
    //    {

    //        con.Close();
    //        con.Dispose();
    //    }
    //}

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindPro()
    {
        DataTable dt = StockReports.GetDataTable("SELECT proname NAME ,proid FROM pro_master WHERE proname<>'' ORDER BY proname");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SavePro(string Appid, string ProId, string Assign_date, string TimeSlot)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string StartTime = Util.GetDateTime(TimeSlot.Split('-')[0]).ToString("HH:mm:ss");
            string EndTime = Util.GetDateTime(TimeSlot.Split('-')[1]).ToString("HH:mm:ss");

            string str = "  UPDATE app_appointment SET App_Date=@Assign_date,STATUS='PhleboAssign' ,Statusdate=NOW(),assign_pro=@assign_pro, TimeSlot=@TimeSlot,Starttime=TIME_FORMAT(@StartTime,'%h:%i:%s'),EndTime=TIME_FORMAT(@EndTime,'%h:%i:%s'),dtAssign=NOW(),Assign_Date=NOW() WHERE id=@Appid";

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str,
                                     new MySqlParameter("@Assign_date", string.Concat(Util.GetDateTime(Assign_date).ToString("yyyy-MM-dd"), " 00:00:00")),
                                     new MySqlParameter("@assign_pro", ProId),
                                     new MySqlParameter("@StartTime", StartTime),
                                     new MySqlParameter("@EndTime", EndTime),
            new MySqlParameter("@Appid", Appid));

            bool b = SendSMS(Appid, "SMS For Patient Assigned Phlebo");
            string sb = "SELECT proname NAME ,Mobile FROM pro_master WHERE proname<>'' and Mobile<>'' and ProId=@ProId ";
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Appid", Appid)
               ).Tables[0];
            if (dt.Rows.Count > 0)
            {
                string SMSText = StockReports.ExecuteScalar(" SELECT REPLACE(REPLACE(SMSTemplate,'<NAME>','" + dt.Rows[0]["NAME"].ToString() + "'),'<DATE>','" + Util.GetDateTime(Assign_date).ToString("dd-MM-yyyy HH:mm:ss tt") + "')SMSTemplate FROM `sms_template` WHERE SMS_Type='Phlebo Assign SMS For Phlebo' and IsActive=1; ").ToString();
                StockReports.ExecuteDML("INSERT INTO sms (MOBILE_NO,SMS_TEXT,IsSend,USerID,EntDate) VALUES('" + dt.Rows[0]["Mobile"].ToString() + "','" + SMSText + "','0','',now())");
            }
            tnx.Commit();
            return "True".ToString();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchPro(string ProAssign, string ProId, string FromDate, string ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DateTime From = System.DateTime.Now;
            DateTime To = System.DateTime.Now;
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT id,NAME,App_Date,assign_pro,DATE_FORMAT(assign_date,'%d-%b-%Y') Assign_Date,  TIME_FORMAT(assign_date,'%h:%i %p') Assign_Time FROM `app_appointment` WHERE assign_pro <>'' AND assign_pro=@ProId AND Date(assign_date)>=@From AND DATE(assign_date)<=@To   ORDER BY TIME_FORMAT(assign_date,'%h:%i %p')  DESC");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@ProId", ProId),
                  new MySqlParameter("@From", From.ToString("yyyy-MM-dd")),
                   new MySqlParameter("@To", To.ToString("yyyy-MM-dd"))
               ).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdatePro(string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE app_appointment SET Status='Open' ,Assign_pro='0',Assign_Date='0001-01-01 00:00:00' WHERE id=@Appid",
            new MySqlParameter("@Appid", id));
            tnx.Commit();
            return "true";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return ex.InnerException.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindCancelReason()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,CancelReason FROM App_b2c_CancelReason_master Where IsActive=1 order by CancelReason ;");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string CancelApp(string Appid, string Cancelreason, string OtherReason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE app_appointment SET iscancel='1', STATUS='Cancel' ,dtcancel=NOW(),cancelby=@cancelby,cancelbyname=@cancelbyname ,cancel_reason=@Cancelreason,Cancel_ReasonOther=@OtherReason  WHERE id=@Appid",
           new MySqlParameter("@Cancelreason", Cancelreason),
            new MySqlParameter("@OtherReason", OtherReason),
            new MySqlParameter("@cancelbyname", UserInfo.LoginName),
            new MySqlParameter("@cancelby", UserInfo.ID),
            new MySqlParameter("@Appid", Appid));
            bool b = SendSMS(Appid, "Appointment Cancel");
            tnx.Commit();
            return "True".ToString();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ReopenApp(string Appid, string Reopenreason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE app_appointment SET statusdate=now(), STATUS='Open' ,reopenbyname=@reopenbyname,remarks=@Reopenreason  WHERE id=@Appid",
new MySqlParameter("@Reopenreason", Reopenreason),
new MySqlParameter("@reopenbyname", UserInfo.LoginName),
new MySqlParameter("@Appid", Appid));
            tnx.Commit();
            return "True".ToString();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindSingleAppDetail(string RefId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Cancel_Reason, isCancel, AppConfirm_ByName, appid,CONCAT(aa.Title,NAME) NAME,aa.Mobile,aa.Email,Concat(Age,'/',aa.Gender) agegen,aa.Address,DATE_FORMAT(assign_date,'%d-%b-%y %I:%i %p') assign_date,DATE_FORMAT(app_date,'%d-%b-%y %I:%i %p') App_date,DATE_FORMAT(dtEntry,'%d-%b-%y %I:%i %p') Entrydate,AppBook_ByName,Assign_ByName,DATE_FORMAT(dtCancel,'%d-%b-%y %I:%i %p') dtCancel,CancelByName,Cancel_Reason  ");
            sb.Append(" STATUS,CONCAT(pr.Title,proname) proname,CASE WHEN STATUS = 'Open' THEN 'White' WHEN STATUS = 'AppConfirm' THEN '#B0C4DE' WHEN STATUS = 'ProAssign' THEN '#CC99FF' WHEN STATUS = 'SampleCollected'  ");
            sb.Append(" THEN 'Pink' WHEN STATUS = 'BookingDone' THEN '#00FFFF' WHEN STATUS = 'ResultDone' THEN '#90EE90' WHEN STATUS = 'Dispatched' THEN '#44A3AA' ");
            sb.Append(" WHEN STATUS = 'Acknowledged' THEN '#3399FF' WHEN STATUS = 'Closed' THEN '#FFFF00' ELSE '#E2680A' ");
            sb.Append("  END rowColor ");
            sb.Append(" FROM app_appointment_log aa left join pro_master pr on aa.assign_Pro=pr.proid ");
            sb.Append(" where refid=@RefId");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@RefId", RefId)
              ).Tables[0];

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string OpenLog(string Appid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT refid,appid,DATE_FORMAT(changedate,'%d-%b-%y %I:%i %p') changedate FROM app_appointment_log where appid=@Appid order by changedate ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@Appid", Appid)
                ).Tables[0];

            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return ex.InnerException.Message;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetTimeSlot()
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT  CONCAT(TIME_FORMAT(StartTime, '%h:%i%p'),'-',TIME_FORMAT(EndTime, '%h:%i%p'))TimeSlot,AvgTimeMin FROM app_b2c_slot_master group by StartTime; ");
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

            }
            else
            {
                return "[]";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return ex.InnerException.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    private static bool SendSMS(string Appid, string Type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT Mobile,Name from app_appointment Where id=@Appid;",
              new MySqlParameter("@Appid", Appid)
            ).Tables[0];
            string SMSText = MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT REPLACE(REPLACE(SMSTemplate,'<NAME>','" + dt.Rows[0]["Name"].ToString() + "'),'<DATE>','" + Util.GetDateTime(DateTime.Now).ToString("dd-MM-yyyy HH:mm:ss tt") + "')SMSTemplate FROM `sms_template` WHERE SMS_Type=@Type  and IsActive=1",
              new MySqlParameter("@Type", Type)).ToString();
            if (SMSText != "")
            {
                string str1 = "INSERT INTO sms (MOBILE_NO,SMS_TEXT,IsSend,USerID,EntDate) VALUES(@mobileNos,@dtSMSText,'0','',now())";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str1.ToString(),
                new MySqlParameter("@mobileNos", dt.Rows[0]["Mobile"].ToString()),
                 new MySqlParameter("@dtSMSText", SMSText));
            }
            tnx.Commit();
            return true;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return false;
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }

}