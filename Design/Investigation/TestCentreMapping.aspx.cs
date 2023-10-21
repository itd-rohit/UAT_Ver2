using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;
public partial class Design_Investigation_TestCentreMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ddlDepartment.DataSource = StockReports.GetDataTable("SELECT SubCategoryID,NAME FROM `f_subcategorymaster` scm WHERE categoryId='LSHHI3' and active=1 ORDER BY NAME");
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        ddlDepartment.Items.Insert(0, new ListItem("", ""));

        AllLoad_Data.bindAllCentreLab(ddlCentre);
        AllLoad_Data.bindAllCentreLab(ddlTestCentre1);
        AllLoad_Data.bindAllCentreLab(ddlTestCentre2);
        AllLoad_Data.bindAllCentreLab(ddlTestCentre3);
        AllLoad_Data.bindAllCentreLab(DropDownList1);
        AllLoad_Data.bindAllCentreLab(DropDownList2);
        AllLoad_Data.bindAllCentreLab(DropDownList3);
        
    }
    [WebMethod]
    public static string SaveTestCentre(object testCentre)
    {
        List<TestCentre> dataTestCentre = new JavaScriptSerializer().ConvertToType<List<TestCentre>>(testCentre);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

         
            string investigationID = String.Join(",", dataTestCentre.Select(a => String.Join(", ", a.AllInvestigation_ID)));
            StringBuilder sb_1 = new StringBuilder();
            sb_1.Append("SELECT Booking_Centre,(SELECT cm.`Centre` FROM `centre_master` cm  WHERE cm.`CentreID`= Test_Centre)Test_Centre,(SELECT cm.`Centre` FROM `centre_master` cm  WHERE cm.`CentreID`= Test_Centre2)Test_Centre2,(SELECT cm.`Centre` FROM `centre_master` cm  WHERE cm.`CentreID`= Test_Centre3)Test_Centre3,Investigation_ID FROM test_centre_mapping ");
            sb_1.Append(" WHERE Booking_Centre='" + dataTestCentre[0].BookingCentre + "' and Investigation_ID IN(" + investigationID + ")  ");
            sb_1.Append(" ");
            DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());


            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM test_centre_mapping WHERE Booking_Centre='" + dataTestCentre[0].BookingCentre + "' and Investigation_ID IN(" + investigationID + ")");



            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM investigations_outsrclab WHERE Investigation_ID IN(" + investigationID + ")  and CentreID='" + dataTestCentre[0].BookingCentre + "' ");


            string Command = "INSERT INTO test_centre_mapping (Booking_Centre,Test_Centre,Test_Centre2,Test_Centre3,Investigation_ID,UserID,Username) VALUES (@Booking_Centre, @Test_Centre,@Test_Centre2,@Test_Centre3,@Investigation_ID,@UserID,@Username);";


            using (MySqlCommand myCmd = new MySqlCommand(Command, con, Tranx))
            {
                myCmd.CommandType = CommandType.Text;
                for (int i = 0; i < dataTestCentre.Count; i++)
                {

                    myCmd.Parameters.Clear();
                    myCmd.Parameters.AddWithValue("@Booking_Centre", dataTestCentre[i].BookingCentre);
                    myCmd.Parameters.AddWithValue("@Test_Centre", dataTestCentre[i].TestCentre1);

                    myCmd.Parameters.AddWithValue("@Test_Centre2", dataTestCentre[i].TestCentre2);
                    myCmd.Parameters.AddWithValue("@Test_Centre3", dataTestCentre[i].TestCentre3);
                    myCmd.Parameters.AddWithValue("@Investigation_ID", dataTestCentre[i].Investigation_ID);
                    myCmd.Parameters.AddWithValue("@UserID", UserInfo.ID);
                    myCmd.Parameters.AddWithValue("@Username", UserInfo.LoginName);
                    myCmd.ExecuteNonQuery();


                }

                 sb_1 = new StringBuilder();
                 sb_1.Append("SELECT Booking_Centre,(SELECT cm.`Centre` FROM `centre_master` cm  WHERE cm.`CentreID`= Test_Centre)Test_Centre,(SELECT cm.`Centre` FROM `centre_master` cm  WHERE cm.`CentreID`= Test_Centre2)Test_Centre2,(SELECT cm.`Centre` FROM `centre_master` cm  WHERE cm.`CentreID`= Test_Centre3)Test_Centre3,Investigation_ID FROM test_centre_mapping ");               
                 sb_1.Append(" WHERE Booking_Centre='" + dataTestCentre[0].BookingCentre + "' and Investigation_ID IN(" + investigationID + ")  ");
                 sb_1.Append(" ");
                 DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb_1.ToString()).Tables[0];

                 if (dt_LTD_1.Rows.Count > 0)
                 {
                     for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
                     {
                         string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                         if ((Util.GetString(dt_LTD_1.Rows[0][i]) != Util.GetString(dt_LTD_2.Rows[0][i])))
                         {
                             sb_1 = new StringBuilder();
                             sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                             sb_1.Append("  values('','TestCentreMapping','" + Util.GetString(dt_LTD_1.Rows[0][i]) + "','" + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + Util.GetString(UserInfo.ID) + "','" + Util.GetString(UserInfo.LoginName) + "',NOW(),'" + Util.GetString(UserInfo.RoleID) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2.Rows[0]["Test_Centre"] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_1.Rows[0][i]) + " to " + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + StockReports.getip() + "',61);  ");
                             MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb_1.ToString());
                         }
                     }
                 }




                Tranx.Commit();
            }



            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}