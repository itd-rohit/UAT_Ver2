using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

/// <summary>
/// Summary description for OutsourceReportAPIVM
/// </summary>
public class B2BPatientRegistrationVM
{
    public string EmployeeId { get; set; }
    public string Id { get; set; }
    public string PanelId { get; set; }
    public string PageNo { get; set; }
    public string Investigation { get; set; }



    public string password { get; set; }
    public string clientcode { get; set; }
    public string workorderid { get; set; }
    public string uniquesampleid { get; set; }
    public string reportbase64 { get; set; }
    public string apollovisitno { get; set; }
    public string servicecode { get; set; }
    public string status { get; set; }
    public string statusupdatedon { get; set; }
    public string statusupdatedby { get; set; }




}