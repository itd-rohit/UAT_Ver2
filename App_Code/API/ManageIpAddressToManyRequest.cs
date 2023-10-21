using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for ManageIpAddressToManyRequest
/// </summary>
public class ManageIpAddressToManyRequest
{
    public string NewClientIPAddress()
    {
        string IpAddress = "";
        if (string.IsNullOrEmpty(HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"]))
            IpAddress = HttpContext.Current.Request.UserHostAddress;
        else
            IpAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        return IpAddress;
    }

    public static string ClientIPAddress()
    {
        string IpAddress = "";
        if (string.IsNullOrEmpty(HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"]))
            IpAddress = HttpContext.Current.Request.UserHostAddress;
        else
            IpAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        return IpAddress;
    }


    public bool SaveRequestCount(int Type)
    {
        ExcuteCMD excuteCMD = new ExcuteCMD();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();


            sb.Append(" insert into wasa_maxrequest_validate (IPAddress,Type,EntryDateTime) values(@IPAddress,@Type,now())");
            excuteCMD.DML(tnx, sb.ToString(), CommandType.Text, new
          {
              IPAddress = NewClientIPAddress(),
              Type = Type,
          });


            tnx.Commit();


            return true;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return false;

        }
        finally
        {


            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    public int GetIPCount(int Type)
    {
        string IPAddress = NewClientIPAddress();
        int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(wm.ID) FROM wasa_maxrequest_validate  wm WHERE wm.Type=" + Util.GetInt(Type) + " AND wm.EntryDateTime>=DATE_ADD(NOW(),INTERVAL -1 MINUTE) AND wm.IPAddress='" + IPAddress + "'"));
        return Count;
    }

    public int GetAbhaSendSmsCount(string Mobile, string RequesterID)
    {
        int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(wm.ID) FROM abha_sendmobilesms  wm WHERE wm.MobileNo=" + Mobile + " AND wm.TimeStamp>=DATE_ADD(NOW(),INTERVAL -30 SECOND) AND wm.HipId='" + RequesterID + "'"));
        return Count;
    }

    public bool IsInjectedString(string inputValue)
    {
        bool isSQLInjection = false;

        string[] sqlCheckList = { "--",
                                    ";--",
                                       ";",
                                       "/*",
                                       "*/",
                                        "@@", 
                                      //  "char",
                                      // "nchar",
                                       "varchar",
                                       "nvarchar",
                                       "alter",
                                       "begin",
                                       "cast",
                                       "create",
                                       "cursor",
                                       "declare",
                                       "delete",
                                       "drop",
                                       "end",
                                       "exec",
                                       "execute",
                                       "fetch",
                                        "insert",
                                          "kill",
                                             "select",
                                           "sys",
                                            "sysobjects",
                                            "syscolumns",
                                           "table",
                                           "update",
                                           "<script",
                                           "alert",
                                           "<",
                                           ">", 
                                            "UNION ALL",
                                               "UNION",                                    
"<applet>",
"<body>",
"<embed>",
"<frame>",
"<script>",
"<frameset>",
"<html>",
"<iframe>",
"<img>",
"<style>",
"<layer>",
"<link>",
"<ilayer>",
"<meta>",
"<object>"
                                       };


        foreach (string item in sqlCheckList)
        {
            if (inputValue.IndexOf(item) >= 0)
            {
                isSQLInjection = true;
            }
        }

        return isSQLInjection;


    }

    public bool IsValidValueForPurpose(string Input, int Type)
    {
        bool IsValidString = true;
        string[] PurposeValue = { "CAREMGT", "BTG", "PUBHLTH", "DSRCH", "PATRQT" };

        string[] PurposeText = { "Care Management", "Break the Glass", "Public Health", "Disease Specific Healthcare Research", "Self Requested" };

        string[] InputArrey = Input.Split(',');

        foreach (string item in InputArrey)
        {
            if (Type == 0)
            {
                if (!PurposeValue.Contains(item))
                {
                    IsValidString = false;
                }
            }
            else
            {

                if (!PurposeText.Contains(item))
                {
                    IsValidString = false;
                }
            }


        }



        return IsValidString;

    }

    public int GetNationalIdCount(string NationalID, MySqlTransaction Tranx, string PatientID = "")
    {
        string IPAddress = NewClientIPAddress();
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT COUNT(pm.NationalID) FROM patient_master pm WHERE pm.NationalID=@NationalID AND pm.NationalID<>'' ");

        sb.Append(" GROUP BY pm.NationalID ");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        int Count = Util.GetInt(excuteCMD.ExecuteScalar(sb.ToString(), new
        {
            NationalID = NationalID
        }));
        return Count;
    }
    public DataTable ToDataTable<T>(List<T> items)
    {
        DataTable dataTable = new DataTable(typeof(T).Name);
        PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
        foreach (PropertyInfo prop in Props)
        {
            var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
            dataTable.Columns.Add(prop.Name, type);
        }
        foreach (T item in items)
        {
            var values = new object[Props.Length];
            for (int i = 0; i < Props.Length; i++)
            {
                values[i] = Props[i].GetValue(item, null);
            }
            dataTable.Rows.Add(values);
        }
        return dataTable;
    }

    public bool IsCenterAccess(string CenterID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT COUNT(id) FROM centre_access ca WHERE ca.IsActive=1 AND ca.CentreAccess=@CenterID AND ca.EmployeeID=@EmployeeID");
        ExcuteCMD excuteCMD = new ExcuteCMD();
        int Count = Util.GetInt(excuteCMD.ExecuteScalar(sb.ToString(), new
        {
            CenterID = CenterID,
            EmployeeID = HttpContext.Current.Session["ID"].ToString()
        }));
        ///int Count = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));

        if (Count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }

    }


    public bool ValidImmutableData(string value, int Type, MySqlTransaction tnx)
    {

        bool IsValid = true;
        int count = 0;
        string NewVal = value;
        if (string.IsNullOrEmpty(NewVal) || NewVal == "0" || NewVal.ToLower() == "select")
        {
            return IsValid;
        }
        ExcuteCMD excuteCMD = new ExcuteCMD();
        if (Type == 0) // Title
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(id) FROM patienttitle_master pt WHERE pt.title=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 1)  // Panel Id
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(pnl.PanelID) FROM f_panel_master pnl WHERE pnl.IsActive=1 AND pnl.PanelID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 2) // Panel Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(pnl.PanelID) FROM f_panel_master pnl WHERE pnl.IsActive=1 AND pnl.Company_Name=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 3) // Gender Check
        {
            if (value != "Male" && value != "Female" && value != "TransGender")
            {
                IsValid = false;
            }
        }
        else if (Type == 4) // Age unit Check
        {
            if (value != "YRS" || value != "MONTH(S)" || value != "DAYS(S)")
            {
                IsValid = false;
            }
        }
        else if (Type == 5) // Marrital status
        {
            if (value != "Select" && value != "Unmarried" && value != "Married" && value != "Divorced" && value != "Widow" && value != "0" && value != "1" && value != "2" && value != "3" && value != "4" && value != "5")
            {
                IsValid = false;
            }
        }
        else if (Type == 6) // Country ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.CountryID) FROM country_master cm WHERE cm.CountryID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 7) // Country Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.CountryID) FROM country_master cm WHERE cm.NAME=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 8) // state id 
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.StateID) FROM master_State cm WHERE cm.StateID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 9) // state Name 
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.StateID) FROM master_State cm WHERE cm.StateName=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 10) // District ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.DistrictID) FROM Master_District cm WHERE cm.DistrictID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 11) // District Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.DistrictID) FROM Master_District cm WHERE cm.District=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 12) //City ID 
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM city_master cm WHERE cm.ID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 13) // City Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM city_master cm WHERE cm.City=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 14)// Taluka ID 
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.TalukaID) FROM Master_Taluka cm WHERE cm.TalukaID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 15) //Taluka Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.TalukaID) FROM Master_Taluka cm WHERE cm.Taluka=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 16)//Purpose ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.PurposeID) FROM master_purposeofvisit  cm WHERE cm.PurposeID=@value", CommandType.Text, new
             {
                 value = value
             }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 17)//Purpose Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.PurposeID) FROM master_purposeofvisit  cm WHERE cm.PurposeName=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 18)//Patient Req.Dept id
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(Id) FROM type_master WHERE TYPE='Doctor-Department' AND NAME=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 19) //Patient Req.Dept Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(Id) FROM type_master WHERE TYPE='Doctor-Department' AND Id=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 20) // Id Proof Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM PatientID_proof_master  cm WHERE cm.IDProofName=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 21)// Id Proof ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM PatientID_proof_master  cm WHERE cm.ID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 22)// Religion Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.religionId) FROM patient_Religion  cm WHERE cm.ReligionName=@value", CommandType.Text, new
             {
                 value = value
             }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 23)// Religion ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.religionId) FROM patient_Religion  cm WHERE cm.religionId=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 24)// Relation Name //EMG.Relation Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM KinRelation_master  cm WHERE cm.KinRelation=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 25)// Relation ID //EMG.Relation ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM KinRelation_master  cm WHERE cm.ID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 26) //Is International
        {
            if (value.ToLower() != "0" && value.ToLower() != "1" && value.ToLower() != "2" && value.ToLower() != "yes" && value.ToLower() != "no" && value.ToLower() != "select")
            {
                IsValid = false;
            }
        }
        else if (Type == 27) //Patient Type Name 
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM patient_type  cm WHERE cm.PatientType=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 28)//Patient Type ID 
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM patient_type  cm WHERE cm.ID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 29)//Reffrence Type Name 
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM typeofreference_master  cm WHERE cm.TypeOfReference=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 30) //Reffrence Type ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM typeofreference_master  cm WHERE cm.ID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 31)//Refferal Type 
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM referraltype_master  cm WHERE cm.ReferalType=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 32)//Refferal Type ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM referraltype_master  cm WHERE cm.ID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 33)//MLC Type
        {
            if (value != "RTA" || value != "Poisoining" || value != "Burns" || value != "Hanging" || value != "Assaults")
            {
                IsValid = false;
            }
        }
        else if (Type == 34) //Language Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM language_master  cm WHERE cm.LANGUAGE=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 35) //Language ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.ID) FROM language_master  cm WHERE cm.ID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 36) //Refferal Dr Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.Pro_ID) FROM f_pro_master  cm WHERE cm.ProName=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 37)//Refferal Dr ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.Pro_ID) FROM f_pro_master  cm WHERE cm.Pro_ID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 38)//Docotr Name
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.DoctorID) FROM doctor_master  cm WHERE cm.NAME LIKE CONCAT('%',@value,'%')", CommandType.Text, new
                       {
                           value = value
                       }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 39)//Docotr ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.DoctorID) FROM doctor_master  cm WHERE cm.DoctorID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 40) //Category Validation
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.CategoryID) FROM f_categorymaster  cm WHERE  cm.CategoryID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 41)//Sub Category Validation
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.SubCategoryID) FROM f_subcategorymaster  cm WHERE  cm.SubCategoryID=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 42) //report dispatchmaster
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.id) FROM report_dispatchmaster  cm WHERE  cm.DispatchMode=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 43) //report dispatchmaster ID
        {
            count = Util.GetInt(excuteCMD.ExecuteScalar(tnx, "SELECT COUNT(cm.id) FROM report_dispatchmaster  cm WHERE  cm.DispatchMode=@value", CommandType.Text, new
            {
                value = value
            }));
            if (count <= 0)
            {
                IsValid = false;
            }
        }
        else if (Type == 44)//PMH Type
        {
            if (value.ToLower() != "opd" && value.ToLower() != "ipd" && value.ToLower() != "emg" )
            {
                IsValid = false;
            }
        }
        return IsValid;
    }
}