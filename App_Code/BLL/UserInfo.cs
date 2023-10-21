using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for UserInfo
/// </summary>
public class UserInfo
{
  
    public static int Centre
    {
        get
        {

            return Util.GetInt(HttpContext.Current.Session["Centre"].ToString());
        }
    }
	 public static string AccessPROIDs
    {
        get
        {

            return Util.GetString(HttpContext.Current.Session["AccessPROIDs"].ToString());
        }
    }
    public static string LoginType
    {
        get
        {

            return HttpContext.Current.Session["LoginType"].ToString();
        }
    }

    public static string UserName
    {
        get
        {

            return HttpContext.Current.Session["UserName"].ToString();
        }
    }
    public static int ID
    {
        get
        {

            return Util.GetInt(HttpContext.Current.Session["ID"].ToString());
        }
    }

    public static string LoginName
    {
        get
        {


            return HttpContext.Current.Session["LoginName"].ToString();
        }
    }
    

  
    public static int RoleID
    {
        get
        {

            return Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
        }
    }

    public static string CentreName
    {
        get
        {

            return HttpContext.Current.Session["CentreName"].ToString();
        }
    }
    public static string CentreType
    {
        get
        {

            return HttpContext.Current.Session["CentreType"].ToString();
        }
    }
    public static string AccessStoreLocation
    {
        get
        {

            return HttpContext.Current.Session["AccessStoreLocation"].ToString();
        }
    }
    public static int IsSalesTeamMember
    {
        get
        {

            return Util.GetInt(HttpContext.Current.Session["IsSalesTeamMember"].ToString());
        }
    }
    public static string PanelType
    {
        get
        {

            return Util.GetString(HttpContext.Current.Session["PanelType"].ToString());
        }
    }
    public static string PCC_PanelID
    {
        get
        {

            return Util.GetString(HttpContext.Current.Session["PCC_PanelID"].ToString());
        }
    }

  
  }