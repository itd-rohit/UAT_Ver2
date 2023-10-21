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
public class FrameData
{

    #region All Memory Variables

    private string _FileName;
    private string _URL;
   
    #endregion All Memory Variables

  

    #region Set All Property

    public virtual string FileName { get { return _FileName; } set { _FileName = value; } }
    public virtual string URL { get { return _URL; } set { _URL = value; } }
   
    #endregion Set All Property

    #region All Public Member Function

  

    #endregion All Public Member Function

}