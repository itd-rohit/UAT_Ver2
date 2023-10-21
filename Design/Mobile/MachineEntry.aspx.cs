using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mobile_MachineEntry : System.Web.UI.Page
{
    public string index;
   public string SearchType;
   public string SearchValue;
   public string FromDate;
   public string ToDate;
   public string CentreID;
   public string SmpleColl;
   public string TimeFrm;
   public string TimeTo;
   public string SampleStatusText;
   public string ApprovalId = "";
   public string IsDefaultSing = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            index = Request.QueryString["index"]; 
             SearchType = Request.QueryString["SearchType"];
             SearchValue = Request.QueryString["SearchValue"];
             FromDate = Request.QueryString["FromDate"];
             ToDate = Request.QueryString["ToDate"];
             CentreID = Request.QueryString["CentreID"];
             SmpleColl = Request.QueryString["SmpleColl"];
             TimeFrm = Request.QueryString["TimeFrm"];
             TimeTo = Request.QueryString["TimeTo"];
             SampleStatusText = Request.QueryString["SampleStatusText"];
             if (Request.QueryString["TimeFrm"] == "")
             {
                 TimeFrm="00:00:00";
                 
             }
             if (Request.QueryString["TimeTo"] == "")
             {
                 
                 TimeTo = "23:59:59";
             }
             string RoleID = Util.GetString(UserInfo.RoleID);
             ApprovalId = StockReports.ExecuteScalar("SELECT max(`Approval`)  FROM `f_approval_labemployee` WHERE `RoleID`='" + RoleID + "' AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)='" + UserInfo.ID + "'");
             IsDefaultSing = StockReports.ExecuteScalar("SELECT DefaultSignature  FROM `f_approval_labemployee` WHERE `RoleID`='" + RoleID + "' AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)='" + UserInfo.ID + "' Limit 1 ");
        }

    }

   


}