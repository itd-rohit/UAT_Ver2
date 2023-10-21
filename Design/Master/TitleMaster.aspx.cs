using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.IO;
using System.Text;
public partial class Design_Master_TitleMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindTitle();
          
        }
    }
    public string BulkChangePanel()
    {
        System.IO.File.WriteAllText("F:\\BulkChangePanel_0.txt", "Prashant");
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb = new StringBuilder();
            sb.Append(@" SELECT round((lt.DiscountOnTotal/lt.GrossAmount * 100 ),2)  DisPer,lt.LedgerTransactionID, lt.CentreID,lt.Panel_ID,lt.NetAmount,lt.Adjustment,if(lt.IsCredit=1,lt.NetAmount,0) AmtCredit,fpm.`Company_Name`,cm.`Centre` ,t.LedgerTransactionNO LabNo,t.`panel_id` OldPanel,t.`panel_id` NewPanel,fpm.`ReferenceCode` RefferanceCode,IF(fpm.`PanelID_MRP`=0,78,fpm.`PanelID_MRP`) PanelID_MRP 
                         FROM `_P1` t
                         INNER Join f_ledgertransaction lt on lt.LedgerTransactionID=t.`LedgerTransactionID` 
                         INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`
                         INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`panel_id`;");
            System.IO.File.WriteAllText("F:\\BulkChangePanel_1.txt", sb.ToString());
            DataTable dtBulk = MySqlHelper.ExecuteDataset(tranX, CommandType.Text, sb.ToString()).Tables[0];


            sb = new StringBuilder();
            sb.Append(@" UPDATE _P1 t
                         INNER JOIN `f_receipt` r ON r.`LedgerTransactionID`=t.`LedgerTransactionID`
                         SET r.`IsCancel`=1,r.`CancelDate`=NOW(),r.`CancelReason`='Cash to Credit',r.`Cancel_UserID`=1,
                         r.`Narration`='Cancel By Rohit & Prashant'
                         WHERE r.`IsCancel`=0 AND r.`Amount`<>0; ");
            System.IO.File.WriteAllText("F:\\BulkChangePanel_2.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(@" UPDATE f_ledgertransaction lt  
                         INNER JOIN `_P1` t on lt.LedgerTransactionID=t.LedgerTransactionID
                         INNER JOIN patient_labInvestigation_opd ltd ON ltd.LedgerTransactionID=lt.LedgerTransactionID AND IF(ltd.isPackage=1,ltd.`SubCategoryID`=15,ltd.`SubCategoryID`!=15)  
                         INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID 
                         INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID=lt.Panel_ID # NewPanelID
                         SET lt.Panel_ID=pm2.Panel_ID,
                         ltd.Amount = (substring_index(get_item_rate(ltd.ItemID,pm2.ReferenceCodeOPD,NOW(),pm2.Panel_ID),'#',1) * (100-t.DisPer)*0.01),
                         ltd.Rate=(substring_index(get_item_rate(ltd.ItemID,pm2.ReferenceCodeOPD,NOW(),pm2.Panel_ID),'#',1)),
                         ltd.MRP= (substring_index(get_item_rate(ltd.ItemID,pm2.ReferenceCodeOPD,NOW(),pm2.Panel_ID),'#',1)),
                         ltd.paybypatient=(substring_index(get_item_rate(ltd.ItemID,pm2.ReferenceCodeOPD,NOW(),pm2.Panel_ID),'#',1)  * (100-t.DisPer)*0.01),
                         ltd.DisCountAmt=(ltd.Rate-ltd.Amount) ;  ");
            System.IO.File.WriteAllText("F:\\BulkChangePanel_3.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(@" UPDATE f_ledgertransaction lt 
                         INNER JOIN `_P1` t on lt.LedgerTransactionID=t.LedgerTransactionID
                         INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID 
                         SET lt.NetAmount=(SELECT SUM(ltd.Amount) FROM patient_labInvestigation_opd ltd WHERE LedgerTransactionID=lt.LedgerTransactionID), 
                         lt.DisCountOnTotal=(SELECT SUM(ltd.DiscountAmt) FROM patient_labInvestigation_opd ltd WHERE LedgerTransactionID=lt.LedgerTransactionID), 
                         lt.isCredit=IF(pm.Payment_Mode='CREDIT',1,0),
                         lt.GrossAmount=(SELECT SUM(ltd.Rate*ltd.Quantity) FROM patient_labInvestigation_opd ltd WHERE LedgerTransactionID=lt.LedgerTransactionID) ; ");
            System.IO.File.WriteAllText("F:\\BulkChangePanel_4.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.Append(@" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,`Status`,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID,Remarks)
            select lt.LedgerTransactionNo,'ChangePanel' Status,1 UserID,'ITDOSE' UserName,NOW() dtEntry,'127.0.0.1' IpAddress,lt.CentreID CentreID,6 RoleID,lt.Panel_ID,lt.Panel_ID,'Cancel By Rohit & Prashant' Remarks
            FROM _P1 t
            INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=t.`LedgerTransactionID`");
            System.IO.File.WriteAllText("F:\\BulkChangePanel_5.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());


            for (int i = 0; i < dtBulk.Rows.Count; i++)
            {
                System.IO.File.AppendAllText("F:\\BulkChangePanel_6_" + dtBulk.Rows[i]["LedgerTransactionID"].ToString() + ".txt", System.Environment.NewLine + Util.GetString(dtBulk.Rows[i]["LedgerTransactionID"].ToString()));
                Panel_Share ps = new Panel_Share();
                JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(Util.GetInt(dtBulk.Rows[i]["LedgerTransactionID"].ToString()), tranX, con));
                if (IPS.status == false)
                {
                    tranX.Rollback();
                    return "0";
                }
                sb = new StringBuilder();
                sb.Append(" DELETE FROM _P1 where LedgerTransactionID='" + dtBulk.Rows[i]["LedgerTransactionID"].ToString() + "'; ");
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                System.IO.File.AppendAllText("F:\\BulkChangePanel_7_" + dtBulk.Rows[i]["LedgerTransactionID"].ToString() + ".txt", sb.ToString());

                System.IO.File.AppendAllText("F:\\BulkChangePanel_8_" + dtBulk.Rows[i]["LedgerTransactionID"].ToString() + ".txt", System.Environment.NewLine + Util.GetString(dtBulk.Rows[i]["LedgerTransactionID"].ToString()));
            }

            tranX.Commit();
            System.IO.File.WriteAllText("F:\\BulkChangePanel_9.txt","Done");
            return "1";
        }
        catch (Exception ex)
        {
            System.IO.File.WriteAllText("F:\\BulkChangePanel_10.txt", ex.GetBaseException().ToString());
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            tranX.Rollback();
            return "-1";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    public static DataTable getTitleDetail()
    {
        return StockReports.GetDataTable("SELECT ID,Title FROM Title_Master WHERE IsActive=1");
    }
    private void bindTitle()
    {
        using (DataTable dt = getTitleDetail())
        {
            if (dt.Rows.Count > 0)
            {
                ddlTitle.DataSource = dt;
                ddlTitle.DataTextField = "Title";
                ddlTitle.DataValueField = "Title";
                ddlTitle.DataBind();
            }
        }
    }
    [WebMethod(EnableSession = true)]
    public static string titleMasterDetail()
    {
        return Util.getJson(getTitleDetail());
    }

    [WebMethod(EnableSession = true)]
    public static string saveTitle(string titleName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM title_master WHERE Title=@Title",
                new MySqlParameter("@Title", titleName)));
            if (count > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Title already exits" });
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO title_master(Title,CreatedByID,CreatedBy)VALUES(@Title,@CreatedByID,@CreatedBy)",
                   new MySqlParameter("@Title", titleName),
                   new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                int ID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully", lastID = ID, title = titleName });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string titleDetail()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,Title,Gender,if(IsActive=1,'Active','DeActive')Status FROM title_gender_master"))
        {
            return Util.getJson(dt);
        }
    }
    [WebMethod(EnableSession = true)]
    public static string saveData(string title, string gender, string typeData, string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (typeData.ToUpper() == "SAVE")
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM title_gender_master WHERE Title=@Title",
                    new MySqlParameter("@Title", title)));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Title already exits" });
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO title_gender_master(Title,Gender,CreatedByID,CreatedBy)VALUES(@Title,@Gender,@CreatedByID,@CreatedBy)",
                       new MySqlParameter("@Title", title), new MySqlParameter("@Gender", gender),
                       new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName));

                    using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT Title,Gender FROM title_gender_master WHERE IsActive=1").Tables[0])
                    {
                        File.WriteAllText(HttpContext.Current.Server.MapPath("~/Scripts/titleWithGender.js"), string.Concat("titleWithGenderData = function (callback) { callback(", Util.getJson(dt).Replace("\r\n", ""), ")}"));
                        tnx.Commit();
                        return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
                    }
                }
            }
            else
            {
                int patientCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_master WHERE Title=@Title",
                   new MySqlParameter("@Title", title)));
                if (patientCount > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Patient already registered with this Title" });
                }
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM title_gender_master WHERE Title=@Title AND ID!=@ID",
                   new MySqlParameter("@Title", title), new MySqlParameter("@ID", ID)));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Title already exits" });
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE title_gender_master SET Title=@Title,Gender=@Gender WHERE ID=@ID ",
                       new MySqlParameter("@Title", title), new MySqlParameter("@Gender", gender),
                       new MySqlParameter("@ID", ID));

                    using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT Title,Gender FROM title_gender_master WHERE IsActive=1").Tables[0])
                    {
                        File.WriteAllText(HttpContext.Current.Server.MapPath("~/Scripts/titleWithGender.js"), string.Concat("titleWithGenderData = function (callback) { callback(", Util.getJson(dt).Replace("\r\n", ""), ")}"));
                        tnx.Commit();
                        return JsonConvert.SerializeObject(new { status = true, response = "Record Updated Successfully" });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}