using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;



public partial class Design_SampleStorage_StorageDeviceMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            ddlBusinessZone_SelectedIndexChanged(sender, e);
            binddepartment();
            BindStorageType();
            ddlBusinessZone.Focus();
            BindGrid("");
            btnUpdate.Visible = false;
            btn.Visible = false;
        }
    }
    void binddepartment()
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
            sb.Append(" ORDER BY NAME");

            //ddldepartment.DataSource = StockReports.GetDataTable(sb.ToString());
            
            //ddldepartment.DataBind();
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            {
                ddldepartment.DataTextField = "NAME";
                ddldepartment.DataValueField = "SubCategoryID";
                ddldepartment.DataSource = dt;
                ddldepartment.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
      
    }
    private void BindStorageType()
    {
      
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            
           
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,StorageType FROM `ss_storagetypemaster` where isactive=1").Tables[0])
            {
                ddlstoragetype.DataValueField = "id";
                ddlstoragetype.DataTextField = "StorageType";
                ddlstoragetype.DataSource = dt;
                ddlstoragetype.DataBind();
            }
            //ddlstoragetype.DataSource = StockReports.GetDataTable("");
            //ddlstoragetype.DataBind();
            ddlstoragetype.Items.Insert(0, new ListItem("Select", "0"));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    void clearform()
    {
        ddlstoragetype.SelectedIndex = 0;
        ddlBusinessZone.SelectedIndex = 0;
        ddlState.SelectedIndex = 0;
        ddlCity.SelectedIndex = 0;
        ddlcentre.SelectedIndex = 0;
        txtdeptname.Text = "";
        txtmfname.Text = "";
        txtmodelno.Text = "";
        txtnoofrack.Text = "";
        txtserialno.Text = "";
       

        foreach (ListItem li in ddldepartment.Items)
        {
           
                li.Selected = false;
           
        }
    }

    private void BindGrid(string testname)
    {
        txtdeptname.Text = "";
        chkActive.Checked = true;
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT  sss.ManufactureName,sss.id, cm.centre,sss.centreid,'' DeptName ,departmentid,sst.StorageType,StorageTypeID, ");
            sb.Append(" cm.StateID,cm.CityID,cm.BusinessUnitID,sss.CreatedBy ,date_format(sss.CreatedOn,'%d-%b-%y %h:%i %p') CreatedOn,");
            sb.Append(" devicename name,ModelNumber,SerialNumber,NumberOfRack,");
            sb.Append(" sss.`isActive` IsActive, IF(sss.IsActive=1,'Active','Deactive') STATUS FROM ss_StorageDeviceMaster sss");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=sss.centreid");
            sb.Append(" INNER JOIN `ss_StorageTypeMaster` sst ON sst.id=sss.StorageTypeID");
            if (testname != "")
            {
                sb.Append(" where devicename like @testname");
            }
            sb.Append(" order by centre,DeptName,StorageType, devicename");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@testname", string.Format("%{0}%", testname))).Tables[0])
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string status = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label3")).Text;
        string ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label1")).Text;
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (status == "1")
            {
                sb.Append("update  ss_StorageDeviceMaster set isactive=0 where ID=@id");
            }
            else
            {
                sb.Append("update  ss_StorageDeviceMaster set isactive=1 where ID=@id");
            }
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@id", ID));
            lblMsg.Text = "Record Updated..!";
            BindGrid("");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = ((Label)e.Row.FindControl("Label3")).Text;
            string Name = ((Label)e.Row.FindControl("lbname")).Text;
            LinkButton lb = (LinkButton)e.Row.FindControl("LinkButton2");
            if (lb != null)
            {
                lb.Attributes.Add("onclick", "return ConfirmOnDelete('" + Name + "','" + status + "');");
            }

            if (status == "1")
            {
                lb.Text = "Deactive";
            }
            else
            {
                lb.Text = "Active";
            }
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            clearform();
            string ID = ((Label)GridView1.SelectedRow.FindControl("lbid")).Text;
            string Name = ((Label)GridView1.SelectedRow.FindControl("lbname")).Text;
            string Status = ((Label)GridView1.SelectedRow.FindControl("Label3")).Text;
            string deptid = ((Label)GridView1.SelectedRow.FindControl("lbdeptid")).Text;
            string Manufat = ((Label)GridView1.SelectedRow.FindControl("lbmfby")).Text;
            string Model = ((Label)GridView1.SelectedRow.FindControl("lbmodel")).Text;
            string ce = ((Label)GridView1.SelectedRow.FindControl("lbcentreid")).Text;
            string Serial = ((Label)GridView1.SelectedRow.FindControl("lbseri")).Text;
            string noofrack = ((Label)GridView1.SelectedRow.FindControl("lbnorack")).Text;
            string lbstorate = ((Label)GridView1.SelectedRow.FindControl("lbstorate")).Text;
            ddlstoragetype.SelectedValue = lbstorate;
            txtmfname.Text = Manufat;
            txtmodelno.Text = Model;
            txtserialno.Text = Serial;
            txtnoofrack.Text = noofrack;
            if (deptid != "")
            {
                foreach (string s in deptid.Split(','))
                {
                    foreach (ListItem li in ddldepartment.Items)
                    {
                        if (li.Value == s)
                        {
                            li.Selected = true;
                        }
                    }
                }
            }
            txtdeptname.Text = Name;
            txtId.Text = ID;
            if (Status == "1")
            {
                chkActive.Checked = true;
            }
            else
            {
                chkActive.Checked = false;
            }
            ddlcentre.Items.Clear();
            ddlcentre.DataValueField = "centreid";
            ddlcentre.DataTextField = "centre";
            sb.Append("SELECT centreid,centre FROM centre_master WHERE  centreid=@ce ORDER BY centre  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@ce", ce)).Tables[0])
            {
                ddlcentre.DataSource = dt;
                ddlcentre.DataBind();
            }
            btnSave.Visible = false;
            btnUpdate.Visible = true;
            //btn.Visible = true;
        }
        catch(Exception ex)
        {
            lblMsg.Text = ex.Message;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtsearch.Text);
    }
    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += "," + li.Value + "";
                else
                    str = "" + li.Value + "";
            }
        }

        return str;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string dept = GetSelection(ddldepartment);

       
        int st = chkActive.Checked ? 1 : 0;

       StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("insert into ss_StorageDeviceMaster (CentreID,DepartmentID,StorageTypeID,DeviceName,ManufactureName,");
            sb.Append(" ModelNumber,SerialNumber,NumberOfRack,IsActive, CreatedByID, CreatedBy, CreatedOn) ");
            sb.Append(" values (@ddlcentre,@dept,@ddlstoragetype,@txtdeptname,");
            sb.Append(" @txtmfname,@txtmodelno,@txtserialno,@txtnoofrack, ");
            sb.Append("@st,@ID,@LoginName,NOW())");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@ddlcentre", ddlcentre.SelectedValue),
            new MySqlParameter("@dept", dept),
            new MySqlParameter("@ddlstoragetype", ddlstoragetype.SelectedValue),
            new MySqlParameter("@txtdeptname", txtdeptname.Text),
            new MySqlParameter("@txtmfname", txtmfname.Text),
            new MySqlParameter("@txtmodelno", txtmodelno.Text),
            new MySqlParameter("@txtserialno", txtserialno.Text),
            new MySqlParameter("@txtnoofrack", txtnoofrack.Text),
            new MySqlParameter("@st", st),
            new MySqlParameter("@ID", UserInfo.ID),
            new MySqlParameter("@LoginName", UserInfo.LoginName)
            );
            lblMsg.Text = "Record Saved";
            BindGrid("");
            clearform();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        string id = txtId.Text;
        string dept = GetSelection(ddldepartment);
        int st = chkActive.Checked ? 1 : 0;

         StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("update ss_StorageDeviceMaster set CentreID=@ddlcentre, ");
            sb.Append(" DepartmentID=@dept ,StorageTypeID=@ddlstoragetype ,DeviceName=@txtdeptname, ");
            sb.Append(" ManufactureName=@txtmfname,ModelNumber=@txtmodelno, SerialNumber=@txtserialno, NumberOfRack=@txtnoofrack ");
            sb.Append(",IsActive=@st,UpdatedOn=NOW(),UpdatedByID=@id,UpdatedBy=@LoginName ");

            sb.Append(" where id=@id");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@ddlcentre",  ddlcentre.SelectedValue),
            new MySqlParameter("@dept", dept),
            new MySqlParameter("@ddlstoragetype", ddlstoragetype.SelectedValue),
            new MySqlParameter("@txtdeptname", txtdeptname.Text),
            new MySqlParameter("@txtmfname", txtmfname.Text),
            new MySqlParameter("@txtmodelno", txtmodelno.Text),
            new MySqlParameter("@txtserialno", txtserialno.Text),      
            new MySqlParameter("@txtnoofrack", txtnoofrack.Text),
            new MySqlParameter("@st", st),
            new MySqlParameter("@id", UserInfo.ID),
            new MySqlParameter("@LoginName", UserInfo.LoginName));

            lblMsg.Text = "Record Updated";
            btnUpdate.Visible = false;
            //btn.Visible = false;
            btnSave.Visible = true;

            txtId.Text = "";
            BindGrid("");
            txtdeptname.Focus();
            clearform();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    protected void ddlBusinessZone_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlState.Items.Clear();
        ddlCity.Items.Clear();
        ddlcentre.Items.Clear();
        ddlState.DataSource = AllLoad_Data.loadState(0,Util.GetInt(ddlBusinessZone.SelectedValue));

        ddlState.DataValueField = "ID";
        ddlState.DataTextField = "State";
        ddlState.DataBind();
        ddlCity.Items.Insert(0, new ListItem("Select", "0"));
        ddlState.Items.Insert(0, new ListItem("Select","0"));
        ddlcentre.Items.Insert(0, new ListItem("Select", "0"));


    }
    protected void ddlState_SelectedIndexChanged(object sender, EventArgs e)
    {

        ddlCity.Items.Clear();
        ddlcentre.Items.Clear();

        ddlCity.DataSource = AllLoad_Data.loadCity(Util.GetInt(ddlState.SelectedValue));
        ddlCity.DataValueField = "ID";
        ddlCity.DataTextField = "City";
        ddlCity.DataBind();
        ddlCity.Items.Insert(0, new ListItem("Select", "0"));
        ddlcentre.Items.Insert(0, new ListItem("Select", "0"));

    }
    protected void ddlCity_SelectedIndexChanged(object sender, EventArgs e)
    {
        ddlcentre.Items.Clear();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
           
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT centreid,centre FROM centre_master WHERE isactive=1 and CityID=@ddlCity ORDER BY centre  ",
               new MySqlParameter("@ddlCity", ddlCity.SelectedValue)).Tables[0])
            {
                ddlcentre.DataValueField = "centreid";
                ddlcentre.DataTextField = "centre";
                ddlcentre.DataSource = dt;
                ddlcentre.DataBind();
            }
            //ddlcentre.DataSource = StockReports.GetDataTable("");
            //ddlcentre.DataBind();
            ddlcentre.Items.Insert(0, new ListItem("Select", "0"));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindTray()
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
             dt = StockReports.GetDataTable(@"SELECT CONCAT(id,'#',CONCAT(IFNULL(capacity1,''),'X',IFNULL(capacity2,'')),'#',CONCAT(IFNULL(expiryunit,''),' ',IFNULL(expirytype,'')),'#',SampleTypeName )id
                                                    ,trayname FROM ss_StorageTrayMaster");
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
  
}