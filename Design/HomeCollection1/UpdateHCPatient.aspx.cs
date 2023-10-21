using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_UpdateHCPatient : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddltitle.DataSource = AllGlobalFunction.NameTitle;
            ddltitle.DataBind();
            AllLoad_Data.bindState(ddlstate);
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    [WebMethod]
    public static string BindOldPatient(string searchdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(title,pname) NAME,Age,Gender,Patient_id,house_no,localityid,Locality,cityid,City,Pincode,stateid,State,Mobile,Email,title,pname ");
            sb.Append(" ,DATE_FORMAT(dob,'%d-%b-%Y')DOB,AgeYear,AgeMonth,AgeDays,Street_Name");
            sb.Append(" ,DATE_FORMAT(pm.dtEntry,'%d-%b-%Y %h:%I %p') visitdate,");
            sb.Append(" ifnull((select currentstatus from " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking where patient_id=pm.patient_id order by id desc limit 1),'') lasthcstatus");
            sb.Append(",(select count(1) from f_ledgertransaction where patient_id=pm.Patient_id) isreg,");
            sb.Append(" 0 iseditd");
            sb.Append(" FROM patient_master pm WHERE mobile='" + searchdata + "' ");

            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@mobile", searchdata)).Tables[0]);
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
    public static string UpdatePatient(Patient_Master PatientDatamain)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sbpa = new StringBuilder();
            sbpa.Append(" select Title,PName,House_No,Street_Name,Locality,City,Pincode,State,Mobile,Email,Age,AgeYear,AgeMonth, AgeDays,TotalAgeInDays,Gender,");
            sbpa.Append(" DATE_FORMAT(dob,'%d-%b-%Y')DOB,StateID,cityID,LocalityID,Patient_ID from patient_master ");
            sbpa.Append(" WHERE Patient_ID = '" + PatientDatamain.Patient_ID + "';");

            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sbpa.ToString()).Tables[0];
            string jsondata = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            jsondata = jsondata.Replace("[", "").Replace("]", "");

            Patient_Master pmold = JsonConvert.DeserializeObject<Patient_Master>(jsondata);

            sbpa = new StringBuilder();
            sbpa.Append("  UPDATE patient_master ");
            sbpa.Append(" SET  ");
            sbpa.Append(" Title = @Title,PName = @PName, House_No = @House_No, ");
            sbpa.Append(" Street_Name = @Street_Name, Locality = @Locality,City = @City, ");
            sbpa.Append(" Pincode = @Pincode,State = @State, Mobile = @Mobile, ");
            sbpa.Append(" Email = @Email,Age = @Age,AgeYear = @AgeYear,");
            sbpa.Append("  AgeMonth = @AgeMonth, AgeDays = @AgeDays,  ");
            sbpa.Append(" TotalAgeInDays = @TotalAgeInDays,Gender = @Gender,StateID=@StateID,cityID=@cityID, LocalityID=@LocalityID,");
            sbpa.Append(" UpdateID = @UpdatedByID,dob=@DOB, ");
            sbpa.Append(" UpdateName = @UpdatedBy,UpdateRemarks = 'Update in Home Collection',Updatedate = NOW()");
            sbpa.Append(" WHERE Patient_ID = @Patient_ID");

            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbpa.ToString(),
               new MySqlParameter("@Title", PatientDatamain.Title),
                new MySqlParameter("@PName", PatientDatamain.PName.ToUpper()),
                new MySqlParameter("@House_No", PatientDatamain.House_No),
                new MySqlParameter("@Street_Name", PatientDatamain.Street_Name),
                new MySqlParameter("@Locality", PatientDatamain.Locality),
                new MySqlParameter("@City", PatientDatamain.City),
                new MySqlParameter("@Pincode", PatientDatamain.Pincode),
                new MySqlParameter("@State", PatientDatamain.State),
                new MySqlParameter("@Mobile", PatientDatamain.Mobile),
                new MySqlParameter("@Email", PatientDatamain.Email),
                new MySqlParameter("@Age", PatientDatamain.Age),
                new MySqlParameter("@AgeYear", PatientDatamain.AgeYear),
                new MySqlParameter("@AgeMonth", PatientDatamain.AgeMonth),
                new MySqlParameter("@AgeDays", PatientDatamain.AgeDays),
                new MySqlParameter("@TotalAgeInDays", PatientDatamain.TotalAgeInDays),
                new MySqlParameter("@Gender", PatientDatamain.Gender),
                new MySqlParameter("@StateID", PatientDatamain.StateID),
                new MySqlParameter("@cityID", PatientDatamain.CityID),
                new MySqlParameter("@LocalityID", PatientDatamain.LocalityID),

                new MySqlParameter("@UpdatedByID", UserInfo.ID),
                new MySqlParameter("@DOB", Util.GetDateTime(PatientDatamain.DOB).ToString("yyyy-MM-dd")),
                new MySqlParameter("@UpdatedBy", UserInfo.LoginName),

                new MySqlParameter("@Patient_ID", PatientDatamain.Patient_ID));
            if (a == 0)
            {
                Exception ex = new Exception("Data Not Update");
                throw ex;
            }

            sbpa = new StringBuilder();
            sbpa.Append("  UPDATE patient_labinvestigation_opd_prebooking ");
            sbpa.Append(" SET  ");
            sbpa.Append(" Title = @Title,PName = @PName, House_No = @House_No,Locality = @Locality,City = @City,Pincode = @Pincode,State = @State, Mobile = @Mobile,  ");
            sbpa.Append(" Email = @Email,Age = @Age,AgeYear = @AgeYear,AgeMonth = @AgeMonth, AgeDays = @AgeDays, ");
            sbpa.Append(" TotalAgeInDays = @TotalAgeInDays,Gender = @Gender,StateID=@StateID,cityID=@cityID, LocalityID=@LocalityID,UpdatedByID = @UpdatedByID,dob=@DOB,");
            sbpa.Append(" UpdatedBy = @UpdatedBy,Updateddate = NOW()");
            sbpa.Append(" WHERE Patient_ID = @Patient_ID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbpa.ToString(),
                new MySqlParameter("@Title", PatientDatamain.Title),
                new MySqlParameter("@PName", PatientDatamain.PName.ToUpper()),
                new MySqlParameter("@House_No", PatientDatamain.House_No),
                new MySqlParameter("@Locality", PatientDatamain.Locality),
                new MySqlParameter("@City", PatientDatamain.City),
                new MySqlParameter("@Pincode", PatientDatamain.Pincode),
                new MySqlParameter("@State", PatientDatamain.State),
                new MySqlParameter("@Mobile", PatientDatamain.Mobile),
                new MySqlParameter("@Email", PatientDatamain.Email),
                new MySqlParameter("@Age", PatientDatamain.Age),
                new MySqlParameter("@AgeYear", PatientDatamain.AgeYear),
                new MySqlParameter("@AgeMonth", PatientDatamain.AgeMonth),
                new MySqlParameter("@AgeDays", PatientDatamain.AgeDays),
                new MySqlParameter("@TotalAgeInDays", PatientDatamain.TotalAgeInDays),
                new MySqlParameter("@Gender", PatientDatamain.Gender),
                new MySqlParameter("@StateID", PatientDatamain.StateID),
                new MySqlParameter("@cityID", PatientDatamain.CityID),
                new MySqlParameter("@LocalityID", PatientDatamain.LocalityID),

                new MySqlParameter("@UpdatedByID", UserInfo.ID),
                new MySqlParameter("@DOB", Util.GetDateTime(PatientDatamain.DOB).ToString("yyyy-MM-dd")),
                new MySqlParameter("@UpdatedBy", UserInfo.LoginName),

                new MySqlParameter("@Patient_ID", PatientDatamain.Patient_ID));

            sbpa = new StringBuilder();
            sbpa.Append(" UPDATE " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking ");
            sbpa.Append(" SET  ");
            sbpa.Append(" PatientName = @PatientName,Address=@Address,Locality = @Locality,City = @City,Pincode = @Pincode,State = @State, MobileNo = @Mobile, ");
            sbpa.Append(" StateID=@StateID,cityID=@cityID, LocalityID=@LocalityID");
            sbpa.Append(" WHERE Patient_ID = @Patient_ID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbpa.ToString(),
                new MySqlParameter("@PatientName", PatientDatamain.Title + PatientDatamain.PName.ToUpper()),
                new MySqlParameter("@Address", PatientDatamain.House_No),
                new MySqlParameter("@Locality", PatientDatamain.Locality),
                new MySqlParameter("@City", PatientDatamain.City),
                new MySqlParameter("@Pincode", PatientDatamain.Pincode),
                new MySqlParameter("@State", PatientDatamain.State),
                new MySqlParameter("@Mobile", PatientDatamain.Mobile),
                new MySqlParameter("@StateID", PatientDatamain.StateID),
                new MySqlParameter("@cityID", PatientDatamain.CityID),
                new MySqlParameter("@LocalityID", PatientDatamain.LocalityID),
                new MySqlParameter("@Patient_ID", PatientDatamain.Patient_ID));

            sbpa = new StringBuilder();
            //var oType = pmold.GetType();

            //foreach (var oProperty in oType.GetProperties())
            //{
            //    var oOldValue = oProperty.GetValue(pmold, null);
            //    var oNewValue = oProperty.GetValue(PatientDatamain, null);

            //    if (!object.Equals(oOldValue, oNewValue))
            //    {
            //        var sOldValue = oOldValue == null ? "" : oOldValue.ToString();
            //        var sNewValue = oNewValue == null ? "" : oNewValue.ToString();

            //        if (!(sOldValue == "" && sNewValue == ""))
            //        {
            //            if (oProperty.Name != "CentreID" && oProperty.Name != "Country" && oProperty.Name != "CityID" && oProperty.Name != "localityid" && oProperty.Name != "StateID")
            //            {
            //                sbpa.Append(" insert into patient_master_update_log (Patient_id,FieldName,OldValue,NewValue,UpdateDate,UpdateByID,UpdateByName) values ");
            //                sbpa.Append(" ('" + PatientDatamain.Patient_ID + "' ,'" + oProperty.Name + "','" + sOldValue + "','" + sNewValue + "',now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "');");
            //            }
            //        }
            //    }
            //}

            //if (sbpa.Length > 0)
            //{
            //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbpa.ToString());
            //}

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindLog(string patient_id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Patient_ID,FieldName,OldValue,NewValue,DATE_FORMAT(UpdateDate,'%d-%b-%Y %h:%I %p') UpdateDate,UpdateByName from patient_master_update_log");
            sb.Append(" WHERE Patient_ID=@Patient_ID order by id desc");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Patient_ID", patient_id)).Tables[0]);
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
}