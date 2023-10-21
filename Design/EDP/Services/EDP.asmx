<%@ WebService Language="C#" Class="EDP" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.IO;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class EDP  : System.Web.Services.WebService {

[WebMethod(EnableSession = true)]
    public string BindNonRegisterPage(string Employee_ID , int RoleID)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT upm.ID,CONCAT(PageName,'(',upm.URL,')')PageName  FROM user_pageauthorisation_master upm LEFT JOIN user_pageauthorisation upa ON upa.MasterID=upm.ID AND upa.EmployeeID='" + Employee_ID + "'  AND upa.RoleID='" + RoleID + "' ");
        sb.Append(" WHERE if(upa.ID IS NULL,upa.ID IS NULL,upa.isactive='0') AND upm.IsActive='1' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }
	[WebMethod]
    public string SetRoleDefaultPage(int id, int roleID, string empID)
    {
        try
        {

            string pageURL = StockReports.ExecuteScalar("SELECT upm.URL FROM user_pageauthorisation upa INNER JOIN user_pageauthorisation_master upm ON upa.MasterID = upm.ID WHERE upa.RoleID = " + roleID + " AND upa.EmployeeID = '" + empID + "' AND upa.IsActive = '1' AND upa.MasterID="+id);
			
            if (!string.IsNullOrEmpty(pageURL))
            {
                DefaultPageMaster defaultPageMaster = new DefaultPageMaster();
                defaultPageMaster.roleID=roleID;
                defaultPageMaster.UserID = empID;
                defaultPageMaster.pageURL = pageURL;
                    
                System.Xml.Serialization.XmlSerializer reader = new System.Xml.Serialization.XmlSerializer(typeof(List<DefaultPageMaster>));
                System.IO.StreamReader file = new System.IO.StreamReader(HttpContext.Current.Server.MapPath("~/Design/MenuData/Default/DefaultPageMaster.xml"));
                List<DefaultPageMaster> defaultPageMasterList = (List<DefaultPageMaster>)reader.Deserialize(file);
                file.Close();

                var isAlreadyExits= defaultPageMasterList.Where(i => (i.UserID == empID && i.roleID == roleID)).FirstOrDefault();
                if(isAlreadyExits==null)
                    defaultPageMasterList.Add(defaultPageMaster);
                else
                    defaultPageMasterList.Where(i => (i.UserID == empID && i.roleID == roleID)).FirstOrDefault().pageURL = pageURL;                
                
                System.Xml.Serialization.XmlSerializer serializer = new System.Xml.Serialization.XmlSerializer(typeof(List<DefaultPageMaster>));
                using (TextWriter writer = new StreamWriter(HttpContext.Current.Server.MapPath("~/Design/MenuData/Default/DefaultPageMaster.xml")))
                {
                    serializer.Serialize(writer, defaultPageMasterList);
                }

                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });

            }
            else
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Page Not Found"});
        }
         catch (Exception ex)
        {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Error occurred, Please contact administrator", message = ex.Message });
            
        }
    }
    [WebMethod(EnableSession = true)]
    public string BindRegisterPage(string Employee_ID, int RoleID)
    {
        string rtrn = "";
        StringBuilder sb = new StringBuilder();
      sb.Append(" SELECT upa.MasterID,CONCAT(PageName,'(',URL,')')PageName FROM user_pageauthorisation upa INNER JOIN user_pageauthorisation_master upm ON upa.MasterID = upm.ID ");
      sb.Append(" WHERE upa.RoleID='" + RoleID  + "' AND upa.EmployeeID='" + Employee_ID + "' AND upa.IsActive='1' ");
	 // System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\16-Feb-2021\edp.txt",sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
        else
        {
            return rtrn;
        }
    }
[WebMethod(EnableSession = true)]
    public string InsertRegisterPage(List<InsertRole> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {

                    int Count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM user_pageauthorisation where MasterID='" + Data[i].MasterId + "' AND RoleID='" + Data[i].RoleID + "' AND EmployeeID='" + Data[i].Employee_ID + "' "));
                    if (Count == 0)
                    {

                        string str = "Insert into user_pageauthorisation(MasterID,RoleID,EmployeeID,CreatedBy) " +
                  " values('" + Data[i].MasterId + "','" + Data[0].RoleID + "','" + Data[0].Employee_ID + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);

                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE user_pageauthorisation SET IsActive=1 WHERE MasterID='" + Data[i].MasterId + "' AND RoleID='" + Data[i].RoleID + "' and EmployeeID='" + Data[i].Employee_ID + "' ");
                    }
                }
                tranX.Commit();
                return "1";
            }


            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        else
        {
            return "0";
        }

    }   
    [WebMethod(EnableSession = true)]
    public string NewRightUpdate(List<RightUpdate> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE user_pageauthorisation SET IsActive=0 WHERE MasterID='" + Data[i].MasterId + "' AND RoleID='" + Data[i].RoleID + "' and EmployeeID='" + Data[i].Employee_ID + "' ");
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }

    }
[WebMethod(EnableSession = true)]
    public string SaveAuthorizePage(List<FrameData> Data)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            int Count = Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from user_pageauthorisation_master where URL='" + Data[0].URL + "'"));
            if (Count == 0)
            {
                string str = "Insert into user_pageauthorisation_master(PageName,URL,CreatedBy) " +
                    " values('" + Data[0].FileName + "', '" + Data[0].URL + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                tranX.Commit();
                return "1";
            }

            else
            {
                return "2";
            }
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string UpdateMenuSNo(string RoleID, string RoleName, List<FileRole> fileRoleList)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < fileRoleList.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE f_file_Role SET  SNo=@SNo WHERE UrlID=@UrlID AND RoleID=@RoleID ",
                   new MySqlParameter("@SNo", fileRoleList[i].SNo), new MySqlParameter("@UrlID", fileRoleList[i].UrlID),
                   new MySqlParameter("@RoleID", RoleID));
            }
            tnx.Commit();
            //generate Menu
            StockReports.GenerateMenuData(RoleName);
            return "1";
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Dispose();
            con.Close();
        }
    }

    [WebMethod]
    public string bindMenu(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select distinct(mm.MenuName)MenuName,mm.ID MenuID from f_file_role fr inner join f_filemaster fm");
        sb.Append(" on fr.UrlID = fm.ID inner join f_menumaster mm on fm.MenuID = mm.ID ");
        sb.Append(" LEFT JOIN f_role_menu_Sno rsm ON rsm.MenuID=fm.MenuID AND rsm.RoleID=fr.RoleID  where fr.Active = 1 and fr.RoleID =" + RoleID + " order by rsm.SNo,mm.menuname");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
    }
    [WebMethod(EnableSession = true)]
    public string UpdateMenu(List<MenuData> menu)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " DELETE FROM f_role_menu_Sno WHERE RoleID=" + menu[0].RoleID + " ");

            for (int i = 0; i < menu.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Insert INTO f_role_menu_Sno(RoleID,MenuID,SNo,UserID) VALUES(@RoleID,@MenuID,@SNo,@UserID )",
                   new MySqlParameter("@RoleID",menu[i].RoleID),new MySqlParameter("@MenuID",menu[i].MenuID),
                   new MySqlParameter("@SNo", menu[i].SNo),
                   new MySqlParameter("@UserID",HttpContext.Current.Session["ID"].ToString())
                   );

            }
            tnx.Commit();
            return "1";

        }

        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string bindLoginType()
    {
        using (DataTable dt = StockReports.GetDataTable("select ID,RoleName from f_rolemaster where active=1 order by RoleName"))
        {

            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }

    }
    [WebMethod]
    public string bindLoadMenu()
    {
        using (DataTable dt = StockReports.GetDataTable("select ID,MenuName from f_menumaster where active = 1 order by MenuName"))
        {

            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
    }
    [WebMethod]
    public string LoadAvailMenu(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select distinct(mm.MenuName) from f_file_role fr inner join f_filemaster fm");
        sb.Append(" on fr.UrlID = fm.ID inner join f_menumaster mm on fm.MenuID = mm.ID ");
        sb.Append("LEFT JOIN f_role_menu_Sno rsm ON rsm.MenuID=fm.MenuID AND rsm.RoleID=fr.RoleID  ");
        sb.Append(" where fr.Active = 1 and fr.RoleID =" + RoleID + " ORDER BY rsm.SNo,mm.menuname");


        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            string str = string.Empty;

            foreach (DataRow dr in dt.Rows)
                if (str != string.Empty)
                    str += " , " + Util.GetString(dr[0]);
                else
                    str = Util.GetString(dr[0]);

            return str;
        }
    }

    [WebMethod]
    public string BindAvailRight(string RoleID, string MenuId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select CONCAT(fm.DispName,'(',fm.Description,')')FileName,FM.ID from f_filemaster FM inner join f_file_Role Fr on FM.Id=Fr.urlid and Fr.RoleID=" + RoleID + " and fm.menuid=" + MenuId + " and Fr.Active=1 order by Fr.SNo ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }

    }
    [WebMethod]
    public string BindPage(string LoginType, string MenuId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select t1.FileName,t1.id from ( select CONCAT(fm.DispName,'(',fm.Description,')')FileName,fm.id from f_filemaster fm inner join f_MenuMaster mm on fm.menuid=mm.id");
        sb.Append(" where fm.Active = 1 and mm.Active = 1  and FM.MenuId=" + MenuId);
        sb.Append(" )t1 left join ( select fm.DispName,fm.id from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
        sb.Append("  inner join f_rolemaster rm on fr.RoleID = rm.ID where fm.Active = 1 and fr.Active = 1 ");
        sb.Append(" and rm.ID = " + LoginType + " and FM.MenuId=" + MenuId + ")t2 on t1.id = t2.id where t2.id is null order by T1.FileName");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";

        }
    }
    [WebMethod(EnableSession = true)]
    public string RoleUpdate(List<Role> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE f_file_Role SET Active=0 WHERE UrlID=@UrlID AND RoleID=@RoleID",
                       new MySqlParameter("@UrlID", Data[i].URLId), new MySqlParameter("@RoleID", Data[i].RoleID));
                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }
    }


    [WebMethod(EnableSession = true)]
    public string RoleInsert(List<Role> Data)
    {
        int len = Data.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction();
            try
            {
                for (int i = 0; i < Data.Count; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "call InsertRight(" + Util.GetString(Data[i].URLId) + "," + Data[i].RoleID + ")");


                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "0";
        }

    }
    public class FileRole
{
    public int UrlID { get; set; }
    public int SNo { get; set; }
}
public class MenuData
{
    public int RoleID { get; set; }
    public int MenuID { get; set; }
    public int SNo { get; set; }
}
public class Role
{
    public string URLId { get; set; }
    public int RoleID { get; set; }


}
}