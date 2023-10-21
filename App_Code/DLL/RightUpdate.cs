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
public class RightUpdate
{

    #region All Memory Variables

    private string _MasterId;
    private string _RoleID;
	private string _Employee_ID;
   
    #endregion All Memory Variables

  

    #region Set All Property

    public virtual string MasterId { get { return _MasterId; } set { _MasterId = value; } }
    public virtual string RoleID { get { return _RoleID; } set { _RoleID = value; } }
	public virtual string Employee_ID { get { return _Employee_ID; } set { _Employee_ID = value; } }
   
    #endregion Set All Property

    #region All Public Member Function

  

    #endregion All Public Member Function

}