using System;
using cfg = System.Configuration.ConfigurationManager;
using System.Collections.Generic;
/// <summary>
/// Summary description for AllGlobalFunction
/// </summary>
public class AllGlobalFunction
{
    public static string MachineDB = cfg.AppSettings["MachineDB"];
    public static string PrintFlag = "0";
    public static string IsWorkstation = cfg.AppSettings["IsWorkstation"];
    public static string showqrcodeinprintlabreport = cfg.AppSettings["showqrcodeinprintlabreport"];
    public static string LockDueReport = cfg.AppSettings["LockDueReport"];
    public static string[] NameTitle = { "Mr.", "Mrs.", "Miss.", "Baby.", "Baba.", "Master.", "Dr.", "B/O", "Ms.", "C/O", " " };
    public static string[] BloobGroup = { "NA", "O+", "O-", "A+", "B+", "AB+", "A-", "B-" };
    //shat 15.04.19
    public static object[] NameTitleWithGender = { new { title = "Mr.", gender = "Male" }, new { title = "Mrs.", gender = "Female" }, new { title = "Miss.", gender = "Female" }, new { title = "Master", gender = "Male" }, new { title = "Baby.", gender = "Female" }, new { title = "B/O.", gender = "UnKnown" }, new { title = "Dr.", gender = "UnKnown" }, new { title = "Prof.", gender = "UnKnown" }, new { title = "Madam.", gender = "Female" }, new { title = "Sister.", gender = "Female" }, new { title = "Mohd.", gender = "Male" }, new { title = "Mx", gender = "Transgender" }, new { title = "Ms.", gender = "Female" }, new { title = "Trans.", gender = "Trans" }, new { title = "NA", gender = "UnKnown" } };
   public static string errorMessage = "Error occurred, Please contact administrator.", saveMessage = "Record Saved Successfully.", maxDiscountValidationErrorMessage = "Invalid Discount ! </br><b class=" + "patientInfo" + " style=" + "font-size: 11px;" + ">Max Discount Eligible : ";

    public object CardHolderRelation()
    {
      return  new List<string>(new string[] { "Self", "Father", "Mother", "Husband", "Wife", "Son", "Daughter", "Uncle", "Aunty", "Sister", "Brother", "Spouse" });

    }
}