using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_HomecollectionSearch : System.Web.UI.Page
{
    public int roleid = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            roleid = UserInfo.RoleID;
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoad_Data.bindState(ddlstate);
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));
            CalendarExtender1.StartDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now.AddDays(3);

            if (UserInfo.RoleID != 212)
            {
                ddlcentre.Items.Insert(0, new ListItem(UserInfo.CentreName.ToString(), UserInfo.Centre.ToString()));
                more.Attributes.Add("style", "display:none");

                ddlphelbo.DataSource = StockReports.GetDataTable(@"SELECT hcp.`name`,hcp.PhlebotomistID FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hcp   INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` hcr ON hcr. phlebotomistid =hcp.phlebotomistid INNER JOIN `f_locality` fl ON fl.ID=hcr.localityid AND fl.cityid IN (SELECT cmm.id FROM centre_master cm INNER JOIN city_master cmm ON cm.cityid=cmm.id and cm.centreid=" + UserInfo.Centre + ") group by hcp.PhlebotomistID");
                ddlphelbo.DataValueField = "PhlebotomistID";
                ddlphelbo.DataTextField = "name";
                ddlphelbo.DataBind();
                ddlphelbo.Items.Insert(0, new ListItem("Select Phelbo", "0"));
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindcentre(string areaid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT droplocationid,centre FROM " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping hc INNER JOIN centre_master cm ON cm.centreid=hc.droplocationid WHERE hc.localityid=@areaid",
               new MySqlParameter("@areaid", areaid)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindphelbo(string Cityid, string areaid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hc.PhlebotomistID,cm.`name` FROM " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping hc INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster cm ON cm.PhlebotomistID=hc.PhlebotomistID ");
            sb.Append(" INNER JOIN f_locality fl ON fl.id=hc.`localityid` ");
            sb.Append(" WHERE fl.cityid=@Cityid ");
            if (areaid != "0" && areaid != "null")
            {
                sb.Append("  and hc.localityid=@areaid ");
            }
            sb.Append("GROUP BY hc.PhlebotomistID ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@areaid", areaid),
                                             new MySqlParameter("@Cityid", Cityid)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string getdata(string fromdate, string todate, string stateId, string cityid, string areaid, string pincode, string centre, string phelbo, string mobileno, string pname, string status, string dateoption, string prebookingno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select hc.RouteName, hc.PhlebotomistID, DATE_FORMAT(hc.EntryDateTime,'%d-%b-%Y %h:%i %p')EntryDateTime,hc.EntryByName, phl.Mobile PMobile,plo.Remarks");
            sb.Append(" , DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %h:%i %p')appdate, plo.prebookingid,plo.Mobile,plo.Patient_ID, ");
            sb.Append(" concat(title,pname)patientname,plo.age,plo.gender,plo.locality,plo.city,plo.state,plo.pincode,if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre) as centre, ");
            sb.Append(" IFNULL(patientrating,'')patientrating,IFNULL(PatientFeedback,'')PatientFeedback,IFNULL(phelborating,'')phelborating ");
            sb.Append(" ,IFNULL(phelbofeedback,'')phelbofeedback,IF(checkin=1,DATE_FORMAT(checkindatetime,'%d-%b-%Y %h:%i %p'),'')checkindatetime, ");
            sb.Append(" IF(isbooked=1,DATE_FORMAT(bookeddate,'%d-%b-%Y %h:%i %p'),'')bookeddate,plo.vip,HardCopyRequired, ");
            sb.Append(" IF(isfinaldone=1,DATE_FORMAT(finaldonedate,'%d-%b-%Y %h:%i %p'),'')finaldonedate,");
            sb.Append(" hc.currentstatus cstatus ,DATE_FORMAT(currentstatusdate,'%d-%b-%Y %h:%i %p')currentstatusdate,phl.name phleboname,ifnull(hc.LedgerTransactionNo,'') visitid,");
            sb.Append(" hc.Alternatemobileno,hc.Client,hc.SourceofCollection,IF(Doctorid='2',OtherDoctor,ReferedDoctor) doctor, ");
            sb.Append(" if(isfinaldone=1,ifnull((SELECT GROUP_CONCAT(concat(id,'#',documentname)) FROM document_detail WHERE labno=hc.LedgerTransactionNo),''),");
            sb.Append(" ifnull((SELECT GROUP_CONCAT(concat(id,'#',documentname)) FROM document_detail WHERE labno=hc.PreBookingID),''))filename,");
            sb.Append(" hc.CancelReason,hc.cancelbyname,DATE_FORMAT(hc.canceldatetime,'%d-%b-%Y %h:%i %p')canceldatetime");
            sb.Append(" ,if(hc.currentstatus='CancelRequest',(select remark from " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionnotavilable where prebookingid=hc.prebookingid and reason='CancelRequest' order by id desc limit 1) ,'') cancelremarks,");
            sb.Append(" if(hc.currentstatus='RescheduleRequest',(select remark from " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionnotavilable where prebookingid=hc.prebookingid and reason='RescheduleRequest' order by id desc limit 1) ,'') requestedremarks,");
            sb.Append(" if(hc.currentstatus='RescheduleRequest',(select DATE_FORMAT(sechduledate,'%d-%b-%Y') from " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionnotavilable where prebookingid=hc.prebookingid and reason='RescheduleRequest' order by id desc limit 1) ,'') requestdate");

            sb.Append(" ,plo.House_No,plo.landmark,hc.VerificationCode");
            sb.Append(" ,IF(phl.`IsTemp`=0,'Permanent Phelbo','Temporary Phelbo') AS PhelboType,IFNULL (PhelboSource,'') PhelboSource ");
            sb.Append(" FROM `patient_labinvestigation_opd_prebooking` plo ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON hc.`PreBookingID`=plo.`PreBookingID`  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=plo.PreBookingCentreID");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` phl ON phl.PhlebotomistID=hc.PhlebotomistID");

            sb.Append(" WHERE ");
            sb.Append(" " + dateoption + ">=@fromdate ");
            sb.Append(" and " + dateoption + "<=@todate ");

            if (stateId != "0")
            {
                sb.Append(" and plo.stateid=@stateId ");
            }
            if (cityid != "0" && cityid != null && cityid != "")
            {
                sb.Append(" and plo.cityid=@cityid ");
            }
            if (areaid != "0" && areaid != null && areaid != "")
            {
                sb.Append(" and plo.localityid=@areaid ");
            }
            if (pincode != "")
            {
                sb.Append(" and plo.pincode=@pincode ");
            }
            if (centre != "0" && centre != null && centre != "")
            {
                sb.Append(" and plo.PreBookingCentreID=@PreBookingCentreID ");
            }
            if (phelbo != "0" && phelbo != null && phelbo != "")
            {
                sb.Append(" and hc.PhlebotomistID=@PhlebotomistID ");
            }

            if (pname != "")
            {
                sb.Append(" and plo.pname like @pname ");
            }
            if (mobileno != "")
            {
                sb.Append(" and plo.mobile=@mobile ");
            }
            if (prebookingno != "")
            {
                sb.Append("and plo.prebookingid=@prebookingid ");
            }
            if (status != "")
            {
                sb.Append(" and hc.currentstatus=@currentstatus");
            }
            sb.Append(" GROUP BY plo.prebookingid ORDER BY prebookingid ");
// return sb.ToString();
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@currentstatus", status),
                                             new MySqlParameter("@prebookingid", prebookingno),
                                             new MySqlParameter("@mobile", mobileno),
                                             new MySqlParameter("@PhlebotomistID", phelbo),
                                             new MySqlParameter("@PreBookingCentreID", centre),

                                             new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " 00:00:00")),
                                             new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " 23:59:59")),
                                             new MySqlParameter("@stateId", stateId),
                                             new MySqlParameter("@cityid", cityid),
                                             new MySqlParameter("@areaid", areaid),
                                             new MySqlParameter("@pincode", pincode),
                                             new MySqlParameter("@pname", string.Format("%{0}%", pname))).Tables[0])

                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindItemDetail(string prebookingid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT itemid,itemname,IF(subcategoryid=15,'Package','Test')itemtype,rate,discamt,netamt ,paymentmode");
            sb.Append(" FROM patient_labinvestigation_opd_prebooking where prebookingid=@prebookingid and iscancel=0  order by itemname");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@prebookingid", prebookingid)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string exporttoexcel(string fromdate, string todate, string stateId, string cityid, string areaid, string pincode, string centre, string phelbo, string mobileno, string pname, string dateoption, string prebookingno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre) as centre,hc.currentstatus  , DATE_FORMAT(hc.EntryDateTime,'%d-%b-%Y %h:%i %p')EntryDateTime,hc.EntryByName,");
            sb.Append(" DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %h:%i %p')AppointmentDate, plo.prebookingid,plo.Mobile,plo.Patient_ID, ");
            sb.Append(" concat(title,pname)patientname,plo.age,plo.gender,plo.locality,plo.city,plo.state,plo.pincode, ");
            sb.Append(" group_concat(itemname) TestName,sum(Rate) Rate,sum(DiscAmt) DiscAmt,sum(NetAmt) NetAmt,");
            sb.Append(" phl.name phleboname, phl.Mobile PMobile,IFNULL (PhelboSource,'') PhelboSource,IF(phl.`IsTemp`=0,'Permanent Phelbo','Temporary Phelbo') AS PhelboType,ifnull(hc.LedgerTransactionNo,'') visitid,");
            sb.Append(" hc.Alternatemobileno,hc.Client,hc.SourceofCollection,IF(Doctorid='2',OtherDoctor,ReferedDoctor) doctor ,");
            sb.Append(" IFNULL(patientrating,'0')patientrating,IFNULL(PatientFeedback,'')PatientFeedback,IFNULL(phelborating,'0')phelborating ");
            sb.Append(" ,IFNULL(phelbofeedback,'')phelbofeedback,IF(checkin=1,DATE_FORMAT(checkindatetime,'%d-%b-%Y %h:%i %p'),'')checkindatetime, ");
            sb.Append(" IF(isbooked=1,DATE_FORMAT(bookeddate,'%d-%b-%Y %h:%i %p'),'')bookeddate,plo.vip,HardCopyRequired,plo.Remarks,hc.RouteName ");
            sb.Append(" ");
            sb.Append(" FROM `patient_labinvestigation_opd_prebooking` plo ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON hc.`PreBookingID`=plo.`PreBookingID`  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=plo.PreBookingCentreID");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` phl ON phl.PhlebotomistID=hc.PhlebotomistID");
            sb.Append(" WHERE ");
            sb.Append(" " + dateoption + ">=@fromdate ");
            sb.Append(" and " + dateoption + "@todate");
            if (stateId != "0")
            {
                sb.Append(" and plo.stateid=@stateId ");
            }
            if (cityid != "0" && cityid != "null" && cityid != string.Empty)
            {
                sb.Append(" and plo.cityid=@cityid ");
            }
            if (areaid != "0" && areaid != "null" && areaid != string.Empty)
            {
                sb.Append(" and plo.localityid=@areaid ");
            }
            if (pincode != string.Empty)
            {
                sb.Append(" and plo.pincode=@pincode ");
            }
            if (centre != "0" && centre != "null" && centre != string.Empty)
            {
                sb.Append(" and plo.PreBookingCentreID=@PreBookingCentreID ");
            }
            if (phelbo != "0" && phelbo != "null" && phelbo != string.Empty)
            {
                sb.Append(" and plo.PhlebotomistID=@PhlebotomistID ");
            }
            if (pname != string.Empty)
            {
                sb.Append(" and plo.pname like @pname");
            }
            if (mobileno != string.Empty)
            {
                sb.Append(" and plo.mobile=@mobileno ");
            }
            if (prebookingno != string.Empty)
            {
                sb.Append("and plo.prebookingid=@prebookingid ");
            }
            sb.Append(" GROUP BY plo.prebookingid ORDER BY prebookingid ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@prebookingid", prebookingno),
                                             new MySqlParameter("@mobileno", mobileno),
                                             new MySqlParameter("@PhlebotomistID", phelbo),
                                             new MySqlParameter("@PreBookingCentreID", centre),
                                             new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " 00:00:00")),
                                             new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " 23:59:59")),
                                             new MySqlParameter("@stateId", stateId),
                                             new MySqlParameter("@cityid", cityid),
                                             new MySqlParameter("@areaid", areaid),
                                             new MySqlParameter("@pincode", pincode),
                                             new MySqlParameter("@pname", string.Format("%{0}%", pname))).Tables[0])
            {
                DataColumn column = new DataColumn();
                column.ColumnName = "S.No";
                column.DataType = System.Type.GetType("System.Int32");
                column.AutoIncrement = true;
                column.AutoIncrementSeed = 0;
                column.AutoIncrementStep = 1;

                dt.Columns.Add(column);
                int index = 0;
                foreach (DataRow row in dt.Rows)
                {
                    row.SetField(column, ++index);
                }
                dt.Columns["S.No"].SetOrdinal(0);
                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "HomeCollectionReport";
                    return "true";
                }
                else
                {
                    return "false";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}