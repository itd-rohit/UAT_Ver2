using ClosedXML.Excel;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_HomeCollectionLocationMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlZone, "Select");
            bindState(ddlSearchState);
        }
    }

    public static void bindState(DropDownList ddlObject)
    {
        using (DataTable dtData = StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE IsActive=1 ORDER BY state"))
        {
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "State";
                ddlObject.DataValueField = "ID";
                ddlObject.DataBind();

                ddlObject.Items.Insert(0, new ListItem("-Select State-"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindSearchCity(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,City FROM city_master WHERE stateid=@stateid And IsActive=1 order by City",
               new MySqlParameter("@stateid", StateId)).Tables[0]);
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
    public static string bindCity(string HeadquarterId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,City FROM city_master WHERE stateid=@HeadquarterId And IsActive=1 order by City",
              new MySqlParameter("@HeadquarterId", HeadquarterId)).Tables[0]);
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

    protected void chkRoles_DataBound(object sender, EventArgs e)
    {
        CheckBoxList chkList = (CheckBoxList)(sender);
        foreach (ListItem item in chkList.Items)
        {
            item.Attributes.Add("id", item.Value);
            item.Attributes.Add("chk_text", item.Text);
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveLocality(List<AreaDetails> AriaDetailsData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < AriaDetailsData.Count; i++)
            {
                int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_locality WHERE CityId=@CityId  AND NAME=@AreaName ",
                                                           new MySqlParameter("@CityId", AriaDetailsData[i].CityID),
                                                           new MySqlParameter("@AreaName", Util.GetString(AriaDetailsData[i].AreaName))));
                if (valDuplicate > 0)
                {
                    Tnx.Rollback();
                    return AriaDetailsData[i].AreaName;
                }

                sb = new StringBuilder();
                sb.Append(" INSERT INTO f_locality (NAME,StateID,HeadQuarterID,CityID,ZoneID,BusinessZoneID,Pincode,active,CreatedByID,CreatedBy,CreatedOn,StartTime,EndTime,AvgTime,isHomeCollection,NoofSlotForApp) ");
                sb.Append("VALUES(@NAME,@StateID,@HeadQuarterID,@CityID,@ZoneID,@BusinessZoneID,@Pincode,@active,@CreatedByID,@CreatedBy,@CreatedOn,@StartTime,@EndTime,@AvgTime,@isHomeCollection,@NoofSlotForApp)");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
                cmd.Parameters.AddWithValue("@NAME", AriaDetailsData[i].AreaName);
                cmd.Parameters.AddWithValue("@StateID", AriaDetailsData[i].StateID);
                cmd.Parameters.AddWithValue("@HeadQuarterID", Util.GetInt(AriaDetailsData[i].HeadquarterID));
                cmd.Parameters.AddWithValue("@CityID", AriaDetailsData[i].CityID);
                cmd.Parameters.AddWithValue("@ZoneID", Util.GetInt(AriaDetailsData[i].CityZoneId));
                cmd.Parameters.AddWithValue("@BusinessZoneID", AriaDetailsData[i].BusinessZoneID);
                cmd.Parameters.AddWithValue("@Pincode", AriaDetailsData[i].Pincode);
                cmd.Parameters.AddWithValue("@active", AriaDetailsData[i].IsActive);
                cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.UserName);
                cmd.Parameters.AddWithValue("@CreatedOn", System.DateTime.Now);
                cmd.Parameters.AddWithValue("@StartTime", AriaDetailsData[i].OpenTime);
                cmd.Parameters.AddWithValue("@EndTime", AriaDetailsData[i].CloseTime);
                cmd.Parameters.AddWithValue("@AvgTime", AriaDetailsData[i].AvgTime);
                cmd.Parameters.AddWithValue("@isHomeCollection", AriaDetailsData[i].IsHomeColection);
                cmd.Parameters.AddWithValue("@NoofSlotForApp", AriaDetailsData[i].NoofSlotForApp);
                cmd.ExecuteNonQuery();
            }
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class AreaDetails
    {
        public string AreaName { get; set; }
        public string AvgTime { get; set; }
        public string BusinessZoneID { get; set; }
        public string CityID { get; set; }
        public string CityZoneId { get; set; }
        public string CloseTime { get; set; }
        public string HeadquarterID { get; set; }
        public string IsActive { get; set; }
        public string IsHomeColection { get; set; }
        public string OpenTime { get; set; }
        public string Pincode { get; set; }
        public string StateID { get; set; }
        public string NoofSlotForApp { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateRecord(string LocalityId, string Locality, string BusinessZoneID, string StateID, string HeadquarterID, string CityID, string CityZoneId, string Pincode, string IsActive, string startTime, string endTime, string AvgTime, string isHomeCollection, string TimeSlot)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int valDuplicate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_locality WHERE CityId=@CityID  AND NAME=@Locality and ID<>@LocalityId ",
                                                        new MySqlParameter("@CityID", CityID),
                                                        new MySqlParameter("@Locality", Util.GetString(Locality.Trim())),
                                                        new MySqlParameter("@LocalityId", LocalityId)));
            if (valDuplicate > 0)
            {
                //Tnx.Rollback();
                //return "2";
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update f_locality set NAME=@NAME,StateID=@StateID,CityID=@CityID,BusinessZoneID=@BusinessZoneID,Pincode=@Pincode,active=@active,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdatedOn=@UpdatedOn,StartTime=@StartTime,EndTime=@EndTime,AvgTime=@AvgTime,isHomeCollection=@isHomeCollection,NoofSlotForApp=@NoofSlotForApp where Id=@ID ");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tnx);
            cmd.Parameters.AddWithValue("@Id", LocalityId);
            cmd.Parameters.AddWithValue("@NAME", Locality);
            cmd.Parameters.AddWithValue("@StateID", StateID);
            cmd.Parameters.AddWithValue("@CityID", CityID);
            
            cmd.Parameters.AddWithValue("@BusinessZoneID", BusinessZoneID);
            cmd.Parameters.AddWithValue("@Pincode", Pincode);
            cmd.Parameters.AddWithValue("@active", IsActive);
            cmd.Parameters.AddWithValue("@StartTime", startTime);
            cmd.Parameters.AddWithValue("@EndTime", endTime);
            cmd.Parameters.AddWithValue("@AvgTime", AvgTime);
            cmd.Parameters.AddWithValue("@isHomeCollection", isHomeCollection);
            cmd.Parameters.AddWithValue("@NoofSlotForApp", TimeSlot);
            cmd.Parameters.AddWithValue("@UpdatedOn", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@UpdatedBy", UserInfo.UserName);
            cmd.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
            cmd.ExecuteNonQuery();
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetData(string searchvalue, int NoofRecord, string SearchState, string SearchCity)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fl.ID,fl.NAME,IF(fl.active='1','Active','DeActive') `Status`,fl.active,fl.StateID,sm.state,fl.CityID,cm.City,fl.ZoneID,'' Zone,");
            sb.Append(" ifnull(fl.PinCode,'')PinCode,bm.BusinessZoneID,bm.BusinessZoneName,fl.HeadquarterID,'' headquarter,ifnull(TIME_FORMAT(fl.StartTime,'%H:%i'),'') StartTime,");
            sb.Append(" ifnull(TIME_FORMAT(fl.EndTime,'%H:%i'),'')EndTime,ifnull(fl.AvgTime,'')AvgTime,IF(fl.isHomeCollection='1','Yes','No') HomeCollectionStatus,fl.isHomeCollection,");
            sb.Append(" fl.NoofSlotForApp from f_locality fl ");
            sb.Append(" INNER JOIN state_master sm ON sm.id=fl.StateID ");
            sb.Append(" INNER JOIN city_master cm ON cm.ID=fl.CityID ");
            sb.Append(" INNER JOIN businesszone_master bm ON bm.BusinessZoneID=sm.BusinessZoneID ");
            sb.Append(" where 1=1 ");
            if (SearchState != "-Select State-")
            {
                sb.Append(" AND  fl.StateID=@StateID ");
            }
            if (SearchCity != string.Empty)
            {
                sb.Append(" AND  fl.CityID=@CityID ");
            }
            if (searchvalue != string.Empty)
            {
                sb.Append(" AND  fl.NAME like @searchvalue");
            }
            sb.Append("  order by fl.NAME desc  limit @NoofRecord  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@StateID", SearchState),
                                              new MySqlParameter("@CityID", SearchCity),
                                              new MySqlParameter("@NoofRecord", NoofRecord),
                                              new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue))).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchDataExcel(string searchvalue, string NoofRecord, string SearchState, string SearchCity)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fl.ID LocationID, fl.NAME 'Location Name', bm.BusinessZoneName'Business Zone', sm.state as State,cm.City,ifnull(fl.PinCode,'')PinCode,IF(fl.active='1','Active','DeActive') Status,IF(fl.isHomeCollection='1','Yes','No') IsHocollection,ifnull(TIME_FORMAT(fl.StartTime,'%H:%i'),'') 'Opening Time',ifnull(TIME_FORMAT(fl.EndTime,'%H:%i'),'')EndTime,ifnull(fl.AvgTime,'') 'AvgTime', fl.NoofSlotForApp as 'Time Slot' from f_locality fl ");
            sb.Append(" INNER JOIN state_master sm ON sm.id=fl.StateID ");
            sb.Append(" INNER JOIN city_master cm ON cm.ID=fl.CityID ");
            sb.Append(" INNER JOIN businesszone_master bm ON bm.BusinessZoneID=sm.BusinessZoneID ");
            sb.Append(" where 1=1 ");
            if (SearchState != "-Select State-")
            {
                sb.Append(" and  fl.StateID=@StateID ");
            }
            if (SearchCity != string.Empty)
            {
                sb.Append(" and  fl.CityID=@CityID ");
            }
            if (searchvalue != string.Empty)
            {
                sb.Append(" and  fl.NAME like @searchvalue");
            }
            sb.Append("  order by bm.BusinessZoneName,sm.state,cm.City,fl.NAME    ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                 new MySqlParameter("@StateID", SearchState),
                                                 new MySqlParameter("@CityID", SearchCity),
                                                 new MySqlParameter("@NoofRecord", NoofRecord),
                                                 new MySqlParameter("@searchvalue", string.Format("%{0}%", searchvalue))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Area Master";
                    return "true";
                }
                else
                {
                    HttpContext.Current.Session["dtExport2Excel"] = "";
                    return "false";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindHeadquarter(string StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,headquarter FROM headquarter_master WHERE StateID=@StateID And IsActive=1 order by headquarter",
               new MySqlParameter("@StateID", StateID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindState(string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,State FROM state_master WHERE BusinessZoneID=@BusinessZoneID and BusinessZoneID<>0 AND IsActive=1 ORDER BY state ",
                new MySqlParameter("@BusinessZoneID", BusinessZoneID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindSaveLocation(string Locationid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fl.ID,fl.NAME,IF(fl.active='1','Yes','No') `Status`,fl.active,fl.StateID,fl.CityID,fl.ZoneID,ifnull(fl.PinCode,'')PinCode,");
            sb.Append(" fl.BusinessZoneID,fl.HeadquarterID,ifnull(fl.StartTime,'') StartTime,ifnull(fl.EndTime,'')EndTime,ifnull(fl.AvgTime,'')AvgTime,IF(fl.isHomeCollection='1','Yes','No') HomeCollectionStatus,fl.isHomeCollection from f_locality  ");
            sb.Append(" where fl.ID=@Locationid");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                            new MySqlParameter("@Locationid", Locationid)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindZone(string StateID, string CityID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "  SELECT ZoneID,Zone FROM centre_zonemaster WHERE IsActive=1 And StateID=@StateID AND CityID=@CityID   ORDER BY Zone ",
                                                           new MySqlParameter("@StateID", StateID.Trim()),
                                                           new MySqlParameter("@CityID", CityID.Trim())).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnupload_Click(object sender, EventArgs e)
    {
        StringBuilder sbOldData = new StringBuilder();
        sbOldData.Append("  <table width='99%' id='tblAreaDetails'><tbody>  <tr>    ");
        sbOldData.Append("     <th class='GridViewHeaderStyle' style='width:15px' align='left'>Add</th> ");
        sbOldData.Append("           <th class='GridViewHeaderStyle' style='width:200px' align='left'>Location</th> ");
        sbOldData.Append("           <th class='GridViewHeaderStyle' style='width:90px' align='left'>Pincode~<input name='ctl00$ContentPlaceHolder1$txtHeaderPincode' type='text' maxlength='6' id='ContentPlaceHolder1_txtHeaderPincode' onkeyup='checkPicodeHeader(this)' placeholder='Pincode' style='width:63%;'></th> ");
        sbOldData.Append("      <th class='GridViewHeaderStyle' style='width:50px' align='left'>Start Time<input name='ctl00$ContentPlaceHolder1$txtHeader_OpenTime' type='text' id='ContentPlaceHolder1_txtHeader_OpenTime' style='width:54%;display:none;' onchange='CloneStartTime(this);' onkeypress='return false;' class='bookingcutoff timepiker ui-timepicker-input' value='08:00' autocomplete='off'></th> ");
        sbOldData.Append("      <th class='GridViewHeaderStyle' style='width:50px' align='left'>Closing Time<input name='ctl00$ContentPlaceHolder1$txtHeader_CloseTime' type='text' id='ContentPlaceHolder1_txtHeader_CloseTime' style='width:45%;display:none;' onchange='CloneCloseTime(this);' onkeypress='return false;' class='bookingcutoff timepiker ui-timepicker-input' value='18:00' autocomplete='off'></th> ");
        sbOldData.Append("      <th class='GridViewHeaderStyle' style='width:55px' align='left'>Avg Time<select name='ctl00$ContentPlaceHolder1$ddslot_Header' id='ContentPlaceHolder1_ddslot_Header' onchange='CloneAvgTime(this);' style='width:59%;display:none;'> ");
        sbOldData.Append("  <option value='10'>10-Min</option> ");
        sbOldData.Append("  <option value='15'>15-Min</option> ");
        sbOldData.Append("  <option selected='selected' value='30'>30-Min</option> ");
        sbOldData.Append("  <option value='45'>45-Min</option> ");
        sbOldData.Append("  <option value='60'>60-Min</option> ");
        sbOldData.Append("  </select> </th> ");
        sbOldData.Append("   <th class='GridViewHeaderStyle' style='width:55px; display:none;' align='left'>No of slot</th> ");
        sbOldData.Append("      <th class='GridViewHeaderStyle' style='width:90px' align='left'>Time Slot~<select name='ctl00$ContentPlaceHolder1$ddNewslot_Header' id='ContentPlaceHolder1_ddNewslot_Header' onchange='CloneNewslot(this);' style='width:44%;'> ");
        sbOldData.Append("  <option value='1'>1-Slot</option> ");
        sbOldData.Append("  <option value='2'>2-Slot</option> ");
        sbOldData.Append("  <option selected='selected' value='3'>3-Slot</option> ");
        sbOldData.Append("  <option value='6'>6-Slot</option> ");
        sbOldData.Append("  </select> </th> ");
        sbOldData.Append("         <th class='GridViewHeaderStyle' align='left' style='width:50px'>Remove</th> ");
        sbOldData.Append("   </tr> ");
        sbOldData.Append("  <tr id='tr_dynamic' class='tr_remove'> ");
        sbOldData.Append(" <td id='td1' style='text-align:center'><img src='../../App_Images/plus.png' style='width: 15px; cursor: pointer' onclick='addfidetail();'></td> ");
        sbOldData.Append("      <td id='td3'> <input name='ctl00$ContentPlaceHolder1$txtMoreArea' type='text' id='ContentPlaceHolder1_txtMoreArea' placeholder='Area' style='width:99%;' value=''></td> ");
        sbOldData.Append("     <td id='td4'><input name='ctl00$ContentPlaceHolder1$txtMorePincode' type='text' maxlength='6' id='ContentPlaceHolder1_txtMorePincode' onkeyup='checkPicode(this)' placeholder='Pincode' style='width:99%;' value=''></td> ");
        sbOldData.Append("    <td id='td5'><input name='ctl00$ContentPlaceHolder1$txtMore_OpenTime' type='text' id='ContentPlaceHolder1_txtMore_OpenTime' style='width:99%;' onchange='getNoSlot_More(this);' onkeypress='return false;' class='bookingcutoff timepiker ui-timepicker-input' value='06:00'  disabled='disabled' autocomplete='off'></td> ");
        sbOldData.Append("    <td id='td6'><input name='ctl00$ContentPlaceHolder1$txtMore_CloseTime' type='text' id='ContentPlaceHolder1_txtMore_CloseTime' style='width:99%;' onchange='getNoSlot_More(this);' onkeypress='return false;' class='bookingcutoff timepiker ui-timepicker-input' value='20:00'  disabled='disabled' autocomplete='off'></td> ");
        sbOldData.Append("   <td id='td7'><select disabled='disabled' name='ctl00$ContentPlaceHolder1$ddslot_more' id='ContentPlaceHolder1_ddslot_more' onchange='getNoSlot_More(this);' style='width:99%;'> ");
        sbOldData.Append("<option selected='selected'  value='10'>10-Min</option> ");
        sbOldData.Append("<option  value='15'>15-Min</option> ");
        sbOldData.Append("<option  value='30'>30-Min</option> ");
        sbOldData.Append("<option value='45'>45-Min</option> ");
        sbOldData.Append("<option  value='60'>60-Min</option> ");
        sbOldData.Append("</select> </td> ");
        sbOldData.Append("        <td id='td8' style='text-align:center;width:50px; display:none;'><span id='ContentPlaceHolder1_spnMore_NoSlot' style='color:red;'>" + 12 + "</span></td> ");
        sbOldData.Append("  <td id='td2'><select name='ctl00$ContentPlaceHolder1$ddNewslot_more' id='ContentPlaceHolder1_ddNewslot_more' style='width:99%;'> ");
        sbOldData.Append("  <option value='1'>1-Slot</option> ");
        sbOldData.Append("  <option value='2'>2-Slot</option> ");
        sbOldData.Append("  <option selected='selected' value='3'>3-Slot</option> ");
        sbOldData.Append("  <option value='6'>6-Slot</option> ");
        sbOldData.Append("  </select> </td> ");
        sbOldData.Append("   <td id='td9' style='width:50px'><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deleterow2(this)'></td> ");
        sbOldData.Append("   </tr> ");
        sbOldData.Append("    </tbody></table> ");
        try
        {
            lblMsg.Text = "";
            if (file1.HasFile)
            {
                string FileExtension = Path.GetExtension(file1.PostedFile.FileName);
                if (FileExtension.ToLower() != ".xlsx" && FileExtension.ToLower() != ".xls")
                {
                    lblMsg.Text = "Kindly Upload xlsx files...";
                    return;
                }
                else
                {
                    tblData.InnerHtml = sbOldData.ToString();
                }
            }
            else
            {
                tblData.InnerHtml = sbOldData.ToString();
                lblMsg.Text = "Please Select File..!";
                return;
            }

            string FileName = "";
            string Mypath = "";
            FileName = Path.GetFileName(file1.FileName);
            Mypath = Server.MapPath("~/Uploads/" + FileName);
            if (File.Exists(Mypath))
                File.Delete(Mypath);

            file1.SaveAs(Mypath);

            DataTable dt = CreateDataTableHeader(Mypath);
            DataTable dtc = Getdata(Mypath, dt);
            if (dtc.Rows.Count > 0)
            {
                StringBuilder str = new StringBuilder();

                str.Append("  <table width='99%' id='tblAreaDetails'><tbody>  <tr>    ");
                str.Append("     <th class='GridViewHeaderStyle' style='width:15px' align='left'>Add</th> ");
                str.Append("           <th class='GridViewHeaderStyle' style='width:200px' align='left'>Location</th> ");
                str.Append("           <th class='GridViewHeaderStyle' style='width:90px' align='left'>Pincode~<input name='ctl00$ContentPlaceHolder1$txtHeaderPincode' type='text' maxlength='6' id='ContentPlaceHolder1_txtHeaderPincode' onkeyup='checkPicodeHeader(this)' placeholder='Pincode' style='width:63%;'></th> ");
                str.Append("      <th class='GridViewHeaderStyle' style='width:50px' align='left'>Start Time<input name='ctl00$ContentPlaceHolder1$txtHeader_OpenTime' type='text' id='ContentPlaceHolder1_txtHeader_OpenTime' style='width:54%;display:none;' onchange='CloneStartTime(this);' onkeypress='return false;' class='bookingcutoff timepiker ui-timepicker-input' value='08:00' autocomplete='off'></th> ");
                str.Append("      <th class='GridViewHeaderStyle' style='width:50px' align='left'>Closing Time<input name='ctl00$ContentPlaceHolder1$txtHeader_CloseTime' type='text' id='ContentPlaceHolder1_txtHeader_CloseTime' style='width:45%;display:none;' onchange='CloneCloseTime(this);' onkeypress='return false;' class='bookingcutoff timepiker ui-timepicker-input' value='18:00' autocomplete='off'></th> ");
                str.Append("      <th class='GridViewHeaderStyle' style='width:55px' align='left'>Avg Time<select name='ctl00$ContentPlaceHolder1$ddslot_Header' id='ContentPlaceHolder1_ddslot_Header' onchange='CloneAvgTime(this);' style='width:59%;display:none;'> ");
                str.Append("  <option value='10'>10-Min</option> ");
                str.Append("  <option value='15'>15-Min</option> ");
                str.Append("  <option selected='selected' value='30'>30-Min</option> ");
                str.Append("  <option value='45'>45-Min</option> ");
                str.Append("  <option value='60'>60-Min</option> ");
                str.Append("  </select> </th> ");
                str.Append("   <th class='GridViewHeaderStyle' style='width:55px; display:none;' align='left'>No of slot</th> ");
                str.Append("      <th class='GridViewHeaderStyle' style='width:90px' align='left'>Time Slot~<select name='ctl00$ContentPlaceHolder1$ddNewslot_Header' id='ContentPlaceHolder1_ddNewslot_Header' onchange='CloneNewslot(this);' style='width:44%;'> ");
                str.Append("  <option value='1'>1-Slot</option> ");
                str.Append("  <option value='2'>2-Slot</option> ");
                str.Append("  <option selected='selected' value='3'>3-Slot</option> ");
                str.Append("  <option value='6'>6-Slot</option> ");
                str.Append("  </select> </th> ");
                str.Append("         <th class='GridViewHeaderStyle' align='left' style='width:50px'>Remove</th> ");
                str.Append("   </tr> ");
                for (int i = 0; i < dtc.Rows.Count; i++)
                {
                    if (dt.Rows[i]["Location"].ToString().Trim() != "")
                    {
                        str.Append("  <tr id='tr_dynamic' class='tr_remove'> ");
                        str.Append(" <td id='td1' style='text-align:center'><img src='../../App_Images/plus.png' style='width: 15px; cursor: pointer' onclick='addfidetail();'></td> ");
                        str.Append("      <td id='td3'> <input name='ctl00$ContentPlaceHolder1$txtMoreArea' type='text' id='ContentPlaceHolder1_txtMoreArea' placeholder='Area' style='width:99%;' value='" + dt.Rows[i]["Location"].ToString() + "'></td> ");
                        str.Append("     <td id='td4'><input name='ctl00$ContentPlaceHolder1$txtMorePincode' type='text' maxlength='6' id='ContentPlaceHolder1_txtMorePincode' onkeyup='checkPicode(this)' placeholder='Pincode' style='width:99%;' value='" + dt.Rows[i]["Pincode"].ToString() + "'></td> ");
                        str.Append("    <td id='td5'><input name='ctl00$ContentPlaceHolder1$txtMore_OpenTime' type='text' id='ContentPlaceHolder1_txtMore_OpenTime' style='width:99%;' onchange='getNoSlot_More(this);' onkeypress='return false;' class='bookingcutoff timepiker ui-timepicker-input' value='06:00'  disabled='disabled' autocomplete='off'></td> ");
                        str.Append("    <td id='td6'><input name='ctl00$ContentPlaceHolder1$txtMore_CloseTime' type='text' id='ContentPlaceHolder1_txtMore_CloseTime' style='width:99%;' onchange='getNoSlot_More(this);' onkeypress='return false;' class='bookingcutoff timepiker ui-timepicker-input' value='20:00'  disabled='disabled' autocomplete='off'></td> ");
                        str.Append("   <td id='td7'><select disabled='disabled' name='ctl00$ContentPlaceHolder1$ddslot_more' id='ContentPlaceHolder1_ddslot_more' onchange='getNoSlot_More(this);' style='width:99%;'> ");
                        str.Append("<option selected='selected'  value='10'>10-Min</option> ");
                        str.Append("<option  value='15'>15-Min</option> ");
                        str.Append("<option  value='30'>30-Min</option> ");
                        str.Append("<option value='45'>45-Min</option> ");
                        str.Append("<option  value='60'>60-Min</option> ");
                        str.Append("</select> </td> ");
                        var TimeSlot = dt.Rows[i]["TimeSlot"].ToString();
                        var timeIntervel = "1";
                        str.Append("        <td id='td8' style='text-align:center;width:50px; display:none;'><span id='ContentPlaceHolder1_spnMore_NoSlot' style='color:red;'>" + timeIntervel + "</span></td> ");
                        str.Append("  <td id='td2'><select name='ctl00$ContentPlaceHolder1$ddNewslot_more' id='ContentPlaceHolder1_ddNewslot_more' style='width:99%;'> ");
                        str.Append(" <option ");
                        if (dt.Rows[i]["TimeSlot"].ToString() == "1")
                        {
                            str.Append("  selected='selected' ");
                        }
                        str.Append(" value='1'>1-Slot</option>");

                        str.Append(" <option ");
                        if (dt.Rows[i]["TimeSlot"].ToString() == "2")
                        {
                            str.Append("  selected='selected' ");
                        }
                        str.Append(" value='2'>2-Slot</option>");
                        str.Append(" <option ");
                        if (dt.Rows[i]["TimeSlot"].ToString() == "3")
                        {
                            str.Append("  selected='selected' ");
                        }
                        str.Append(" value='3'>3-Slot</option>");
                        str.Append(" <option ");
                        if (dt.Rows[i]["TimeSlot"].ToString() == "6")
                        {
                            str.Append("  selected='selected' ");
                        }
                        str.Append(" value='6'>6-Slot</option>");
                        str.Append(" </select> </td> ");
                        str.Append("   <td id='td9' style='width:50px'><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deleterow2(this)'></td> ");
                        str.Append("   </tr> ");
                    }
                }
                str.Append("    </tbody></table> ");
                tblData.InnerHtml = str.ToString();
            }
            else
            {
                lblMsg.Text = "No Record Found..!";
            }
            if (File.Exists(Mypath))
                File.Delete(Mypath);
        }
        catch (Exception ex)
        {
            tblData.InnerHtml = sbOldData.ToString();
            lblMsg.Text = "Please Select Valid Excel Sheet..!";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    public int convertToMin(string inputTime)
    {
        string[] NewTime = inputTime.Split(':');
        var hrinseconds = Util.GetInt(NewTime[0]) * 3600;
        var mininseconds = Util.GetInt(NewTime[1]) * 60;
        return Util.GetInt(hrinseconds) + Util.GetInt(mininseconds) + Util.GetInt(NewTime[2]);
    }

    // Create DataTable
    public DataTable Getdata(string pFilePath, DataTable dt)
    {
        try
        {
            var wb = new XLWorkbook(pFilePath);
            IXLWorksheet ws;
            ws = wb.Worksheet("data");
            StringBuilder sb = new StringBuilder();
            int j = 0;
            foreach (IXLRow r in ws.Rows())
            {
                DataRow tempRow = dt.NewRow();
                for (int i = 1; i <= dt.Columns.Count; i++)
                {
                    if (j != 0)
                    {
                        tempRow[i - 1] = r.Cell(i).Value.ToString();
                    }
                }
                dt.Rows.Add(tempRow);
                j++;
            }
            dt.Rows.RemoveAt(0);
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();
        }
        ViewState["mydata"] = dt;
        return dt;
    }

    // Create Header
    public static DataTable CreateDataTableHeader(string fileName)
    {
        DataTable dataTable = new DataTable();
        using (SpreadsheetDocument spreadSheetDocument = SpreadsheetDocument.Open(fileName, false))
        {
            WorkbookPart workbookPart = spreadSheetDocument.WorkbookPart;
            IEnumerable<Sheet> sheets = spreadSheetDocument.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>();
            string relationshipId = sheets.First().Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)spreadSheetDocument.WorkbookPart.GetPartById(relationshipId);
            Worksheet workSheet = worksheetPart.Worksheet;
            SheetData sheetData = workSheet.GetFirstChild<SheetData>();
            IEnumerable<Row> rows = sheetData.Descendants<Row>();
            try
            {
                foreach (Cell cell in rows.ElementAt(0))
                {
                    dataTable.Columns.Add(GetCellValue(spreadSheetDocument, cell));
                }
            }
            catch
            {
            }
        }
        return dataTable;
    }

    private static string GetCellValue(SpreadsheetDocument document, Cell cell)
    {
        SharedStringTablePart stringTablePart = document.WorkbookPart.SharedStringTablePart;
        string value = cell.CellValue.InnerXml;
        if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
        {
            return stringTablePart.SharedStringTable.ChildElements[Int32.Parse(value)].InnerText;
        }
        else
        {
            return value;
        }
    }
}