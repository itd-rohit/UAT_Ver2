using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_RequiredFieldMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string binddata()
    {

        DataTable dt = StockReports.GetDataTable(@" SELECT if(isunit=1,'Yes','No') hasunit, id,fieldname,inputtype,isunit,unit,dropdownoption,DATE_FORMAT(createdate,'%d-%b-%Y') Entrydate,(SELECT NAME FROM employee_master WHERE employee_id=createby LIMIT 1) EnteredBy,IFNULL(DATE_FORMAT(Updateddate,'%d-%b-%Y'),'') Updatedate,
IFNULL((SELECT NAME FROM employee_master WHERE employee_id=updateby LIMIT 1),'') updateby FROM requiredfield_master");

       return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

   


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savecompletedata(string FieldName, string id, string InputType, string IsUnit, string Unit, string DropDownOption)
    {
        try
        {
            if (id == "")
            {
                int ss = Util.GetInt(StockReports.ExecuteScalar("select count(*) from requiredfield_master where fieldname='" + FieldName.ToUpper() + "' "));
                if (ss > 0)
                {
                    return "2";
                }
                StringBuilder sb = new StringBuilder();
                sb.Append(" insert into requiredfield_master(FieldName,InputType,IsUnit,Unit,DropDownOption,CreateDate,CreateBy)");
                sb.Append(" values ('" + FieldName.ToUpper() + "','" + InputType + "','" + IsUnit + "','" + Unit.TrimEnd('|').ToUpper() + "','" + DropDownOption.TrimEnd('|').ToUpper() + "',now(),'" + UserInfo.ID + "')");

                StockReports.ExecuteDML(sb.ToString());
                return "1";
            }
            else
            {
                int ss = Util.GetInt(StockReports.ExecuteScalar("select count(*) from requiredfield_master where fieldname='" + FieldName.ToUpper() + "' and ID<>'" + id + "' "));
                if (ss > 0)
                {
                    return "3";
                }
                StringBuilder sb = new StringBuilder();
                sb.Append(" update  requiredfield_master set FieldName='" + FieldName.ToUpper() + "',InputType='" + InputType + "',IsUnit='" + IsUnit + "'");
                sb.Append(" ,Unit='" + Unit.TrimEnd('|').ToUpper() + "',DropDownOption='" + DropDownOption.TrimEnd('|').ToUpper() + "',UpdatedDate=now(),UpdateBy='" + UserInfo.ID + "' ");
                sb.Append(" where id='"+id+"' ");

                StockReports.ExecuteDML(sb.ToString());
                return "4";

            }
           
        }
        catch (Exception ex)
        {
            return "Data Not Saved";
        }



        
    }
}