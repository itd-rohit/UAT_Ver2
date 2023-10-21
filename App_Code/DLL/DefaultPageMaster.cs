using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for CenterMaster
/// </summary>
public class DefaultPageMaster
{

    #region All Memory Variables

    private int _roleID;
    private string _UserID ;
	private string _pageURL;
   
    #endregion All Memory Variables

  

    #region Set All Property

    public virtual int roleID { get { return _roleID; } set { _roleID = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
	public virtual string pageURL { get { return _pageURL; } set { _pageURL = value; } }
   
    #endregion Set All Property

    #region All Public Member Function

  

    #endregion All Public Member Function

}