using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for LabStatusAPIVM
/// </summary>
public class LabStatusAPIVM
{
    public string UserName { get; set; }
    public string Password { get; set; }
    public string InterfaceClient { get; set; }
    public string CentreID_interface { get; set; }
    public string WorkOrderID { get; set; }
}