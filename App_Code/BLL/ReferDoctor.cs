using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for ReferDoctor
/// </summary>
public class ReferDoctor
{
    public ReferDoctor()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable BindDept(string Type)
    {
        string str = "SELECT sc.Name,sc.SubCategoryID  FROM f_subcategorymaster sc  INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID   WHERE sc.active=1 AND c.ConfigRelationID IN ('3','23') order by sc.Name";
        return StockReports.GetDataTable(str);
    }
    public string AddNewDoctor(string Title, string Name, string Phone1, string Mobile, string Street_Name, string Specialization, string DocCode, string Email, string ClinicName, string Degree, string doctype, string visitday, int GroupID, string StateID, string CityID, string ZoneID, string LocalityID, string ReferShare, string ReferMaster,string PRO)
    {
        
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();       
        DocCode = getUniqueNumber(Name.Trim().ToUpper());
        try
        {

            string UserID = HttpContext.Current.Session["ID"].ToString();

            int count1 = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, " select Count(1) from doctor_referal where IsActive=1 AND  Mobile like @Mobile",
            new MySqlParameter("@Mobile", string.Concat("%",Mobile,"%"))));
            if (count1 > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Doctor Mobile :", Mobile, " is already Register with Dr.", Name), Doctor_ID = 0 });
            }            

            DoctorMasterReferal objDMR = new DoctorMasterReferal(tranX);
            objDMR.Title = Title;
            objDMR.Name = Name;
            objDMR.Phone1 = Phone1;
            objDMR.Mobile = Mobile;
            objDMR.Street_Name = Street_Name;
            objDMR.Specialization = Specialization;
            objDMR.Email = Email;
            objDMR.AddedBy = HttpContext.Current.Session["ID"].ToString();
            objDMR.ClinicName = ClinicName;
            objDMR.Degree = Degree;
            objDMR.State = StateID;
            objDMR.City = CityID;
            objDMR.Locality = LocalityID;
            objDMR.ZoneID = Util.GetInt(ZoneID);
            objDMR.DoctorCode = DocCode;
            objDMR.IsVisible = "1";
            objDMR.IsLock = "1";
            string Doctor_ID = objDMR.Insert();
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update doctor_referal set PROID='"+ PRO +"', isReferal='" + ReferShare + "',ReferMasterShare='" + ReferMaster + "',doctorType=@doctype,visitDay=@visitday ,DoctorGroup=Doctor_ID where Doctor_ID=@Doctor_ID",
                   new MySqlParameter("@doctype", doctype),
                   new MySqlParameter("@visitday", visitday),
                   new MySqlParameter("@Doctor_ID", Doctor_ID));

            tranX.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = Doctor_ID });
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred", Doctor_ID = 0 });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    private string getUniqueNumber(string name)
    {
        Random random = new Random();
        string r = "";
        int i;
        for (i = 1; i < 5; i++)
        {
            r += random.Next(0, 3).ToString();
        }

        return string.Concat(name.Substring(0, 2), r); 
    }
}