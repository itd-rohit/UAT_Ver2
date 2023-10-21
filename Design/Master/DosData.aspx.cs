using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Services;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Master_DosData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        hdnvalue.Value = Util.GetString(string.Format("{0}#{1}#{2}#{3}", Request.QueryString["investigationid"], Request.QueryString["centerid"], Request.QueryString["type"], Request.QueryString["IsUrgent"]));
    }


    [WebMethod(EnableSession = true)]
    public static string searchdataTAT(string investigationid, string centerid, string type, int isurgent)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string deliverydate = string.Empty;
            string testcenter = string.Empty;
            if (type == "Test")
            {
                deliverydate = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "call get_delivery_date_with_logistic(@centerid,@investigationid,now(),@IsUrgent)",
                   new MySqlParameter("@centerid", centerid),new MySqlParameter("@IsUrgent", isurgent),
                   new MySqlParameter("@investigationid", investigationid)));
            }

            if (type == "Test")
            {
                testcenter = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Test_Centre FROM test_centre_mapping WHERE `Booking_Centre`=@centerid  AND `Investigation_ID`=@Investigation_ID",
                    new MySqlParameter("@centerid", centerid),
                    new MySqlParameter("@Investigation_ID", investigationid)));

                if (testcenter != string.Empty)
                {
                    centerid = testcenter;
                }
            }
           // if (type != "Test")
           // investigationid = string.Join(", ", investigationid.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => "'" + s.Trim() + "'"));

            StringBuilder sb = new StringBuilder();
            sb.Append("");

            sb.Append("  SELECT cm.centreid LocationID,  cm.centre LocationName,im.`TestCode`,im.Investigation_Id Itemid,iom.name DepartmentName,im.name InvestigationName,ifnull(mac.name,'') MachineName,ifnull(mac.id,'') MachineId,ifnull(icm.`Method`,'')Method,if(ifnull(tcm.Booking_Centre,0)=ifnull(tcm.Test_Centre,0),'InHouse','OutHouse') In_Out_House,if(ifnull(iol.OutSrcLabName,'')='','',OutSrcLabName)OutSourceLab ,");
            sb.Append("  IFNULL(id.DayType,'')DayType,IFNULL(Sun_Proc, '0') Sun_Proc,IFNULL(Mon_Proc, '0') Mon_Proc,IFNULL(Tue_Proc, '0') Tue_Proc,IFNULL(Wed_Proc, '0') Wed_Proc,IFNULL(Thu_Proc, '0') Thu_Proc,IFNULL(Fri_Proc, '0') Fri_Proc,IFNULL(Sat_Proc, '0') Sat_Proc, ");
            sb.Append("  IFNULL(Sun, '0') Sun,IFNULL(Mon, '0') Mon,IFNULL(Tue, '0') Tue,IFNULL(Wed, '0') Wed,IFNULL(Thu, '0') Thu,IFNULL(Fri, '0') Fri,IFNULL(Sat, '0') Sat ");
            sb.Append(" , IFNULL(testprocessingday,'0')testprocessingday,IFNULL(reportingcutoff,'06:30 pm')reportingcutoff,IFNULL(bookingcutoff,'01:00 pm') bookingcutoff,IFNULL(sracutoff,'01:30 pm')  sracutoff");
            if (type == "Test")
            {
                sb.AppendFormat(",'{0}' deliverydate, '{1}' prolab ", deliverydate.Split('#')[1], deliverydate.Split('#')[3]);
            }
            else
            {

                sb.Append(",'' deliverydate, '' prolab ");
            }
            //sb.Append(,fr.rate);
            sb.Append(" FROM investigation_master im ");




            sb.Append(" INNER JOIN investigation_observationtype io on io.investigation_id=im.investigation_id");
            if (investigationid != "0")
            {
                if (type == "Test")
                {
                    sb.Append(" and im.investigation_id={0} ");
                }
                else
                {
                    sb.Append(" and im.investigation_id in({0})");
                }
            }


            sb.Append(" INNER JOIN observationtype_master iom on iom.observationtype_id=io.observationtype_id");



            sb.Append(" INNER JOIN centre_master cm  ");
            if (centerid != "0")
                sb.Append(" on cm.CentreID=@centreid ");

            sb.Append(" LEFT JOIN test_centre_mapping tcm on tcm.Investigation_ID=im.Investigation_ID and tcm.Booking_Centre=cm.`CentreID`");
            sb.Append(" LEFT JOIN investigations_outsrclab iol on iol.Investigation_ID=im.Investigation_ID and iol.CentreID=cm.`CentreID`");
            sb.Append(" LEFT JOIN investigation_centre_method icm ON icm.`investigationid`=im.`Investigation_Id` ");
            sb.Append(" LEFT JOIN macmaster mac ON mac.`ID`=icm.`machineid` ");
            sb.Append(" INNER JOIN `f_itemmaster` fim INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID` = fim.`SubCategoryID` AND fim.typename=im.Name ");
            sb.Append(" LEFT JOIN (SELECT * FROM `investiagtion_delivery` WHERE `CentreID` ='2') id  ON id.Investigation_id = fim.`Type_ID` ");

            sb.Append(" ORDER BY centre,departmentname,testcode,InvestigationName,machinename ");
            DataTable dt = new DataTable();
            

            string[] tags = investigationid.Split(',');
            string[] paramNames = tags.Select(
                  (s, i) => "@tag" + i).ToArray();
            string inClause = string.Join(", ", paramNames);
            using (MySqlDataAdapter da5 = new MySqlDataAdapter(String.Format(sb.ToString(), inClause), con))
            {
                for (int i = 0; i < paramNames.Length; i++)
                {
                    da5.SelectCommand.Parameters.AddWithValue(paramNames[i], tags[i].Trim());
                }
                da5.SelectCommand.Parameters.AddWithValue("@centreid", centerid);
                da5.Fill(dt);
            }



            if (type != "Test")
            {
                foreach (DataRow dw in dt.Rows)
                {
                    deliverydate = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "call get_delivery_date_with_logistic(@centerid,@Itemid,now(),@isurgent)",
                         new MySqlParameter("@centerid", centerid),
                    new MySqlParameter("@Itemid", dw["Itemid"].ToString()),
                    new MySqlParameter("@isurgent",isurgent)));
                    dw["deliverydate"] = deliverydate.Split('#')[1];
                    dw["prolab"] = deliverydate.Split('#')[3];


                }
            }


            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
}