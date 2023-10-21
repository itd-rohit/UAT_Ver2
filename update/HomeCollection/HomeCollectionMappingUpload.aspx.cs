using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_HomeCollectionMappingUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlzone.DataSource = StockReports.GetDataTable("SELECT businesszoneid,businesszonename FROM `businesszone_master`");
            ddlzone.DataValueField = "businesszoneid";
            ddlzone.DataTextField = "businesszonename";
            ddlzone.DataBind();
            ddlzone.Items.Insert(0, new ListItem("Select Zone", "0"));

        }
    }
    protected void ddlzone_SelectedIndexChanged(object sender, EventArgs e)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
        ddlstate.Items.Clear();
        ddlcity.Items.Clear();

        ddlstate.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,state FROM state_master WHERE businesszoneid=@businesszoneid order by state",
           new MySqlParameter("@businesszoneid", ddlzone.SelectedValue)).Tables[0];
        ddlstate.DataValueField = "id";
        ddlstate.DataTextField = "state";
        ddlstate.DataBind();
        ddlstate.Items.Insert(0, new ListItem("Select State", "0"));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

        }

        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    protected void ddlstate_SelectedIndexChanged(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            ddlcity.Items.Clear();
            ddlcity.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,city FROM city_master WHERE stateid=@stateid order by city ",
                 new MySqlParameter("@stateid", ddlstate.SelectedValue)).Tables[0];
            ddlcity.DataValueField = "id";
            ddlcity.DataTextField = "city";
            ddlcity.DataBind();
            ddlcity.Items.Insert(0, new ListItem("Select City", "0"));
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

        }

        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    protected void btndownloadexcel_Click(object sender, EventArgs e)
    {
        if (ddlcity.Items.Count == 0)
        {
            lblMsg.Text = "Please Select City";
            return;
        }
        if (ddlcity.SelectedValue == "0")
        {
            lblMsg.Text = "Please Select City";
            return;
        }

        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT '" + ddlzone.SelectedItem.Text + "' Zone,  '" + ddlstate.SelectedItem.Text + "' State,  ");
        sb.Append(" '" + ddlcity.SelectedItem.Text + "' City, ");
        sb.Append(" ID LocalityID ,REPLACE(NAME ,',','') LocalityName,PinCode, '' DropLocationName ,'' DropLocationCode,'' Route,'' PhelebotomistName,'' PhelebotomistUserName  ");
        sb.Append(" FROM `f_locality` ");
        sb.Append(" WHERE active=1 AND cityid=" + ddlcity.SelectedValue + " ");
        sb.Append(" ORDER BY NAME ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        Response.Clear();
        Response.ContentType = "text/csv";
        Response.AddHeader("content-disposition", "attachment;filename=HomeCollectionMapping.csv");

        sb = new StringBuilder();

        for (int i = 0; i < dt.Columns.Count; i++)
        {
            sb.Append(dt.Columns[i].ColumnName + ',');
        }
        sb.Append(Environment.NewLine);

        for (int j = 0; j < dt.Rows.Count; j++)
        {
            for (int k = 0; k < dt.Columns.Count; k++)
            {
                sb.Append(dt.Rows[j][k].ToString() + ',');
            }
            sb.Append(Environment.NewLine);
        }
        Response.Write(sb.ToString());
        Response.End();
    }
    protected void btnupload_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (file1.HasFile)
        {
            string FileExtension = Path.GetExtension(file1.PostedFile.FileName);

            if (FileExtension.ToLower() != ".csv")
            {
                lblMsg.Text = "Kindly Upload Correct files...";
                return;
            }
        }
        else
        {
            lblMsg.Text = "Please Select File..!";
            return;

        }


        string FileName = "";
        string Mypath = "";




        if (!Directory.Exists(Server.MapPath("~/Design/HomeCollection/TempFiles/")))
            Directory.CreateDirectory(Server.MapPath("~/Design/HomeCollection/TempFiles/"));

        FileName = Path.GetFileName(file1.FileName);
        Mypath = Server.MapPath("~/Design/HomeCollection/TempFiles/" + FileName);

        if (File.Exists(Mypath))
            File.Delete(Mypath);

        file1.SaveAs(Mypath);


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            //Delete OLd Table
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Drop Table if Exists _homecollectionmapping ;");

            //Create New Table
            string strQuery = CreateTable("_homecollectionmapping", Mypath);
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strQuery);


            Mypath = Mypath.Replace(@"\", @"\\");

            string ENCLOSEDBY = @"'""'";
            string ESCAPEDBY = @"'""'";

            strQuery = " LOAD DATA LOCAL INFILE '" + Mypath + "' INTO TABLE _homecollectionmapping FIELDS TERMINATED BY ',' ENCLOSED BY " + ENCLOSEDBY + " ESCAPED BY " + ESCAPEDBY + " LINES TERMINATED BY '\\n'  IGNORE 1 LINES ";
            StockReports.ExecuteDML(strQuery);
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strQuery);
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "ALTER TABLE _homecollectionmapping ADD centreid INT(11);");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "ALTER TABLE _homecollectionmapping ADD panelid INT(11);");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "ALTER TABLE _homecollectionmapping ADD routeid INT(11);");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "ALTER TABLE _homecollectionmapping ADD PhelbotomistID INT(11);");


            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, @"UPDATE _homecollectionmapping hm 
INNER JOIN centre_master cm ON REPLACE(REPLACE(hm.DROPLOCATIONCODE, '\r', ''), '\n', '')=cm.centrecode SET hm.centreid=cm.centreid;");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, @"UPDATE _homecollectionmapping hm 
INNER JOIN f_panel_master pm ON pm.centreid=hm.centreid AND pm.`PanelType`='Centre' SET hm.panelid=pm.panel_id;");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, @"UPDATE _homecollectionmapping hm 
INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_routemaster` hc ON REPLACE(REPLACE(hm.ROUTE, '\r', ''), '\n', '')=hc.Route SET hm.routeid=hc.Routeid;");


            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, @"UPDATE _homecollectionmapping hm 
INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hc ON REPLACE(REPLACE(hm.PHELEBOTOMISTUSERNAME, '\r', ''), '\n', '')=hc.UserName SET hm.PhelbotomistID=hc.PhlebotomistID;");


            grd.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select Distinct * from _homecollectionmapping where ifnull(centreid,0)<>0 and ifnull(panelid,0)<>0 and ifnull(PhelbotomistID,0)<>0 ").Tables[0];
            grd.DataBind();




        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

        }

        finally
        {

            con.Close();
            con.Dispose();
        }

    }

    public static string CreateTable(string tableName, string Path)
    {
        string CSVFilePathName = Path;
        string[] Lines = File.ReadAllLines(CSVFilePathName);
        string[] Fields;
        Fields = Lines[0].Split(new char[] { ',' });
        int Cols = Fields.GetLength(0);

        string sqlsc = "", strFieldsOnly = "";
        sqlsc = "CREATE TABLE " + tableName + "(\n";


        for (int i = 0; i < Cols; i++)
        {
            if (Fields[i].Trim().ToUpper() != "")
            {
                sqlsc += "\n" + Fields[i].Trim().ToUpper();
                sqlsc += " varchar(500) ";
                sqlsc += ",";
            }

            strFieldsOnly += Fields[i].Trim().ToUpper() + ",";
        }
        sqlsc = sqlsc.Substring(0, sqlsc.Length - 1) + ")";

        strFieldsOnly = strFieldsOnly.Substring(0, strFieldsOnly.Length - 1);

        return sqlsc + "#" + strFieldsOnly;
    }


    protected void btnsave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            StringBuilder sb = new StringBuilder();

            foreach (GridViewRow dw in grd.Rows)
            {
                CheckBox ck = (CheckBox)dw.FindControl("chk");
                if (ck.Checked)
                {
                    if (dw.Cells[13].Text.Trim() == "" || dw.Cells[13].Text.Trim() == "&nbsp;")
                    {
                        lblMsg.Text = "Centre ID Not Correct in Row No " + (dw.RowIndex + 1);
                        break;
                    }
                    if (dw.Cells[16].Text.Trim() == "" || dw.Cells[16].Text.Trim() == "&nbsp;")
                    {
                        lblMsg.Text = "Phlebotomist ID Not Correct in Row No " + (dw.RowIndex + 1);
                        break;
                    }
                    if (dw.Cells[15].Text.Trim() == "" || dw.Cells[15].Text.Trim() == "&nbsp;")
                    {
                        lblMsg.Text = "Route ID Not Correct in Row No " + (dw.RowIndex + 1);
                        break;
                    }
                    sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".`hc_area_droplocation_mapping` (localityid,droplocationID,PanelId,EntryDate,EntryBy,EntryByname)");
                    sb.Append(" values ");
                    sb.Append(" (" + dw.Cells[5].Text.Trim() + "," + dw.Cells[13].Text.Trim() + "," + dw.Cells[14].Text.Trim() + ",now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "'); ");

                    sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` (localityid,PhlebotomistID,EntryDate,EntryBy,EntryByname)");
                    sb.Append(" values ");
                    sb.Append(" (" + dw.Cells[5].Text.Trim() + "," + dw.Cells[16].Text.Trim() + ",now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "'); ");

                    sb.Append(" insert into  " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` (localityid,Routeid,EntryDate,EntryBy,EntryByname)");
                    sb.Append(" values ");
                    sb.Append(" (" + dw.Cells[5].Text.Trim() + "," + dw.Cells[15].Text.Trim() + ",now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "'); ");
                }
            }

            //File.WriteAllText("C:\\ErrorLog\\mytxt.txt", sb.ToString());
            int ct = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
            int dtt = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "DELETE t1 FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_area_droplocation_mapping` t1 INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_area_droplocation_mapping` t2 WHERE t1.id < t2.id AND t1.localityid = t2.localityid and t1.droplocationID=t2.droplocationID;");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "DELETE t1 FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` t1 INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` t2 WHERE t1.id < t2.id AND t1.localityid = t2.localityid and t1.PhlebotomistID=t2.PhlebotomistID;");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "DELETE t1 FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` t1 INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_area_route_mapping` t2 WHERE t1.id < t2.id AND t1.localityid = t2.localityid and t1.Routeid=t2.Routeid;");

            lblMsg.Text = ct / 3 + " Mapping Saved.! " + dtt + " Found Duplicate";
            grd.DataSource = null;
            grd.DataBind();
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

        }

        finally
        {

            con.Close();
            con.Dispose();
        }
    }
}