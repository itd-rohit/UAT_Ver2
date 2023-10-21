using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Master_Doctor_Booking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.FillDateTime(txtFromDate, txtToDate);
            BindCenter();
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
        ddlCentre.DataSource = StockReports.GetDataTable(str);
        ddlCentre.DataTextField = "Centre";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        if (UserInfo.Centre == 1)
        {
            ddlCentre.Items.Insert(0, new ListItem("All", "0"));
        }
        else
        {
            ddlCentre.SelectedValue = Util.GetString(UserInfo.Centre);
        }
    }

    [WebMethod]
    public static string getDocData(DoctorBooking searchdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT dro.ID,dro.DoctorName,dro.Mobile,dro.CentreID,dro.Email,IFNULL(dr.`Name`,'') MergeDoctorName,IFNULL(dr.`Doctor_ID`,'') MergeDoctorID,IFNULL(cm.Centre,'')MergeDoctorCentre ");
            sb.Append(" FROM doctor_otherfrombooking dro ");
            sb.Append(" LEFT JOIN `doctor_referal` dr ON dr.`Mobile`=dro.`Mobile` and dr.mobile <>'' and dr.IsActive=1 ");
            sb.Append(" LEFT JOIN doctor_referal_centre drc ON drc.`Doctor_ID`=dr.`Doctor_ID`  ");
            sb.Append(" LEFT JOIN centre_master cm ON cm.`CentreID`=drc.`CentreID` ");
            sb.Append(" WHERE dro.IsRegister=0  ");
            if (Util.GetString(searchdata.FromDate) != string.Empty)
                sb.Append(" AND dro.entryDate >=@FromDate ");
            if (Util.GetString(searchdata.ToDate) != string.Empty)
                sb.Append(" AND dro.entryDate<=@ToDate ");
            if (Util.GetInt(searchdata.CentreID) != 0)
                sb.Append(" AND dro.centreID =@centreID");
            sb.Append(" group by dro.ID ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@FromDate", Util.GetDateTime(searchdata.FromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@ToDate", Util.GetDateTime(searchdata.ToDate).ToString("yyyy-MM-dd") + " 23:59:59"),
                new MySqlParameter("@centreID", Util.GetInt(searchdata.CentreID))).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record Found...!" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string removeDocData(object Data)
    {
        List<DoctorMasterReferal> docReferal = new JavaScriptSerializer().ConvertToType<List<DoctorMasterReferal>>(Data);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            for (int i = 0; i < docReferal.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE doctor_otherfrombooking SET IsRegister=2,RemovedBy=@RemovedBy WHERE ID=@ID",
                    new MySqlParameter("@RemovedBy", UserInfo.ID),
                    new MySqlParameter("@ID", docReferal[i].ID));
            }
            tranX.Commit();
            docReferal.Clear();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string saveDocData(object Data)
    {
        List<DoctorMasterReferal> docReferal = new JavaScriptSerializer().ConvertToType<List<DoctorMasterReferal>>(Data);

        MySqlConnection con = Util.GetMySqlCon();

        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        int docExits = 0;
        try
        {
            DataTable dt = new DataTable();
            DataRow dr;
            dt.Columns.Add("ID", typeof(System.Int32));
            dt.Columns.Add("Message", typeof(System.String));
            for (int i = 0; i < docReferal.Count; i++)
            {
                if (docReferal[i].Mobile != "0000000000" && docReferal[i].Mobile.Trim() != string.Empty)
                {
                    string DocName = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select Name from doctor_referal where IsActive=1 AND  Mobile like @Mobile ",
                        new MySqlParameter("@Mobile", "%" + docReferal[i].Mobile)));
                    if (DocName != string.Empty)
                    {
                        docExits += 1;
                        dr = dt.NewRow();
                        dr["ID"] = Util.GetInt(docReferal[i].ID);
                        dr["Message"] = string.Concat("This Mobile No. : ", docReferal[i].Mobile.Trim(), " is already Register with Dr.", DocName);
                        dt.Rows.Add(dr);
                    }
                }
            }
            if (docExits == 0)
            {
                for (int j = 0; j < docReferal.Count; j++)
                {
                    int GroupID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ZoneID FROM centre_master WHERE CentreID=@CentreID",
                        new MySqlParameter("@CentreID", docReferal[j].CentreID)));
                    if (GroupID == 0)
                    {
                        tranX.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, ErrorMag = "ZoneID not found..!" });
                    }
                    DoctorMasterReferal objDMR = new DoctorMasterReferal(tranX);

                    objDMR.Title = "Dr.";
                    objDMR.Name = docReferal[j].Name;
                    objDMR.Mobile = docReferal[j].Mobile;
                    objDMR.CentreID = docReferal[j].CentreID;
                    objDMR.AddedBy = Util.GetString(UserInfo.ID);
                    objDMR.GroupID = GroupID;
                    objDMR.IsVisible = "1";
                    objDMR.IsLock = "0";
                    objDMR.doctortype = "Refer Doctor";
                    objDMR.Email = docReferal[j].Email;
                    string Doctor_ID = objDMR.Insert();

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE doctor_otherfrombooking SET doctor_ID=@doctor_ID,IsRegister=1,RegisterBy=@RegisterBy WHERE ID=@ID",
                        new MySqlParameter("@doctor_ID", Doctor_ID),
                        new MySqlParameter("@RegisterBy", UserInfo.ID),
                        new MySqlParameter("@ID", docReferal[j].ID));

                    StringBuilder sbRefDocMap = new StringBuilder();
                    sbRefDocMap.Append(" insert into doctor_referal_centre (Doctor_ID,CentreID,UserID,UserName,dtEntry,IpAddress)");
                    sbRefDocMap.Append(" values(@Doctor_ID,@CentreID,@UserID,@UserName,now(),@IpAddress)");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sbRefDocMap.ToString(),
                        new MySqlParameter("@Doctor_ID", Doctor_ID),
                        new MySqlParameter("@CentreID", docReferal[j].CentreID),
                        new MySqlParameter("@UserID", Util.GetString(UserInfo.ID)),
                        new MySqlParameter("@UserName", Util.GetString(UserInfo.LoginName)),
                        // new MySqlParameter("@dtEntry", "now()"),
                        new MySqlParameter("@IpAddress", Util.GetString(StockReports.getip())));

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE doctor_referal SET DoctorCode=doctor_ID where doctor_ID=@doctor_ID",
                        new MySqlParameter("@doctor_ID", Doctor_ID));

                    // Update LT
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " update f_ledgertransaction set Doctor_ID=@Doctor_ID,DoctorName=@DoctorName where Doctor_ID_Temp=@Doctor_ID_Temp ",
                        new MySqlParameter("@Doctor_ID", Doctor_ID.Trim()),
                        new MySqlParameter("@DoctorName", docReferal[j].Name.Trim()),
                        new MySqlParameter("@OtherDoctorName", ""),
                        new MySqlParameter("@Doctor_ID_Temp", docReferal[j].ID));
                }

                tranX.Commit();
                docReferal.Clear();
                return JsonConvert.SerializeObject(new { status = true });
            }
            else
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string mergeDoctor(DoctorBooking MergeDoctor)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE doctor_otherfrombooking SET doctor_ID=@doctor_ID,IsRegister=1,RegisterBy=@RegisterBy WHERE ID=@ID",
                new MySqlParameter("@doctor_ID", MergeDoctor.MergeDoctorID),
                new MySqlParameter("@RegisterBy", UserInfo.ID),
                new MySqlParameter("@ID", MergeDoctor.TempDocID));
            // Update LT
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " update f_ledgertransaction set Doctor_ID=@Doctor_ID,DoctorName=@DoctorName where Doctor_ID_Temp=@Doctor_ID_Temp ",
                new MySqlParameter("@Doctor_ID", MergeDoctor.MergeDoctorID),
                new MySqlParameter("@DoctorName", MergeDoctor.MergeDoctorName),

                new MySqlParameter("@Doctor_ID_Temp", MergeDoctor.TempDocID));

            tranX.Commit();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string ModifyDoctor(DoctorBooking ModifyDoctor)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE doctor_otherfrombooking SET DoctorName=@DoctorName,Mobile=@Mobile,Email=@Email WHERE ID=@ID",
                new MySqlParameter("@DoctorName", ModifyDoctor.DoctorName),
                new MySqlParameter("@Mobile", ModifyDoctor.Mobile),
                new MySqlParameter("@Email", ModifyDoctor.Email),
                new MySqlParameter("@ID", ModifyDoctor.DoctorID));
            // Update LT
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, " update f_ledgertransaction set DoctorName=@OtherDoctorName where Doctor_ID_Temp=@Doctor_ID_Temp ",
                new MySqlParameter("@OtherDoctorName", ModifyDoctor.DoctorName),
                new MySqlParameter("@Doctor_ID_Temp", ModifyDoctor.DoctorID));

            tranX.Commit();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class DoctorBooking
    {
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public int CentreID { get; set; }
        public string DoctorID { get; set; }
        public string DoctorName { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
        public string TempDocID { get; set; }
        public string MergeDoctorID { get; set; }
        public string MergeDoctorName { get; set; }
        public int ID { get; set; }
    }
}