<%@ WebService Language="C#" Class="CommonScheduler" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class CommonScheduler : System.Web.Services.WebService
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }

   
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    [WebMethod(EnableSession = true)]
    public string HelloWorld() {
        return "Hello World";
    }

    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    [WebMethod(EnableSession = true)]
    public string CommonSchedulerFunction()
    {
        try
        {
            CommonSchedulerClass obj = new CommonSchedulerClass();
            obj.LoadTinySMS();         
            return "Sucess";
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return "Failure";
        }
    } 

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    private void processData(DataTable dtParam, string LabNo)
    {
        StringBuilder sb = new StringBuilder();
	ClassLog cl = new ClassLog();
        cl.GeneralLog("ProcessData");
        foreach (DataRow dr in dtParam.Rows)
        {
            if (!(dr["Formula"].ToString() == ""))
            {
                return;
            }
            if (dr["Value"].ToString() == "" || dr["Minimum"].ToString() == "" || dr["Maximum"].ToString() == "")
            {
                return;
            }
            if (!this.getTags(dr["value"].ToString(), dr["Minimum"].ToString(), dr["Maximum"].ToString()))
            {
                return;
            }
            sb.Append(string.Concat(new string[]
			{
				dr["PLIID"].ToString(),
				"|",
				dr["InvName"].ToString(),
				"|",
				dr["ID"].ToString(),
				"|",
				dr["obName"].ToString(),
				"|",
				dr["value"].ToString(),
				"|",
				dr["ReadingFormat"].ToString(),
				"|"
			}));
            sb.Append(string.Concat(new string[]
			{
				dr["Minimum"].ToString(),
				"|",
				dr["Maximum"].ToString(),
				"|",
				dr["DisplayReading"].ToString(),
				"|",
				dr["IsCritical"].ToString(),
				"|",
				dr["MinCritical"].ToString(),
				"|",
				dr["MaxCritical"].ToString(),
				"|"
			}));
            sb.Append(string.Concat(new string[]
			{
				dr["Description"].ToString(),
				"|",
				dr["Test_ID"].ToString(),
				"|",
				dr["Priorty"].ToString(),
				"|",
				dr["LabObservation_ID"].ToString(),
				"|",
				dr["Comments"].ToString(),
				"|",
				dr["OrganismID"].ToString(),
				"|",
				dr["isOrganism"].ToString(),
				"|",
				dr["MacReading"].ToString(),
				"|",
				dr["dtMacEntry"].ToString(),
				"|",
				dr["MachineID"].ToString(),
				"|",
				dr["MAchineNAme"].ToString(),
				"|",
				dr["MethodName"].ToString(),
				"#"
			}));
        }
        if (sb.ToString() != "")
        {
          
           // LabResultEntry objSave = new LabResultEntry();
           // string output = objSave.SaveResult(LabNo, sb.ToString());  
        }
    }
    
    public bool getTags(string Value, string MinRange, string MaxRange)
    {
        bool result;
        try
        {
            if (Util.GetFloat(Value) >= Util.GetFloat(MinRange) && Util.GetFloat(Value) <= Util.GetFloat(MaxRange))
            {
                result = true;
                return result;
            }
        }
        catch (Exception ex_2D)
        {
            
        }
        result = false;
        return result;
    }
    public string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }
}
