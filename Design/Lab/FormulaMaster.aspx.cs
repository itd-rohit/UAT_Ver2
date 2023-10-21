using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_FormulaMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindInvestigations();
            LoadObservations();
        }
    }

    private void LoadObservations()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select LOM.LabObservation_ID,CONCAT(LOM.Name,'#',LOM.LabObservation_ID) as ObsName from labobservation_investigation LOI");
        sb.Append("  inner join labobservation_master LOM on");
        sb.Append(" LOI.labObservation_ID=LOM.LabObservation_ID and   loi.Investigation_Id='" + ddlInvestigations.SelectedValue + "' order by loi.printOrder");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        lstObservations.DataSource = dt;
        lstObservations.DataTextField = "ObsName";
        lstObservations.DataValueField = "LabObservation_ID";
        lstObservations.DataBind();
    }

    private void BindInvestigations()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select inv.Name ,inv.Investigation_id from f_itemmaster im ");
        sb.Append("inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  ");
        sb.Append("inner join f_configrelation c on c.CategoryID=sc.CategoryID ");
        sb.Append(" inner join investigation_master inv on inv.Investigation_id=im.Type_id");
        sb.Append(" and c.ConfigRelationID='3' and inv.ReportType=1 and im.IsActive=1 order by inv.Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlInvestigations.DataSource = dt;
            ddlInvestigations.DataTextField = "Name";
            ddlInvestigations.DataValueField = "Investigation_Id";
            ddlInvestigations.DataBind();
            ddlInvestigations.Items.Insert(0, new ListItem("----Select Investigation----", ""));
        }
    }

    protected void ddlInvestigations_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadObservations();
    }

    protected void btnLeft_Click(object sender, EventArgs e)
    {
        if (lstObservations.DataTextField != "")
        {
            string str = "SELECT loi.formula,loi.LabObservation_ID,lom.Name FROM labobservation_investigation loi INNER JOIN labobservation_master lom ON  loi.LabObservation_ID=lom.LabObservation_ID where loi.labobservation_id='" + lstObservations.SelectedItem.Value + "' and Investigation_Id='" + ddlInvestigations.SelectedValue + "'";
            DataTable dt = StockReports.GetDataTable(str);
            if (dt.Rows[0]["formula"].ToString() != "")
            {
                txtRight.Text = dt.Rows[0]["formula"].ToString();
                txtObservationID.Text = dt.Rows[0]["LabObservation_ID"].ToString();
                txtLeft.Text = dt.Rows[0]["NAME"].ToString();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Formula Already Exists...');", true);
            }
            else
            {
                txtObservationID.Text = lstObservations.SelectedItem.Value;
                txtLeft.Text = lstObservations.SelectedItem.Text;
                txtRight.Text = "";
            }
        }
    }

    protected void BtnRight_Click(object sender, EventArgs e)
    {
        if (txtLeft.Text != "")
        {
            txtRight.Text = txtRight.Text + lstObservations.SelectedItem.Value + "@";
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Use The LEFT Button...');", true);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string txtobserid = txtObservationID.Text.ToString(); string investigationid = ddlInvestigations.SelectedValue.ToString();

            StringBuilder sb_1 = new StringBuilder();
            sb_1.Append(" SELECT li.formula,CONCAT(invm.`Name`,' Formula Changes ',obsm.`Name`)NAME FROM   labobservation_investigation li ");
            sb_1.Append("  INNER JOIN labobservation_master obsm  ON obsm.`LabObservation_ID` = li.`labObservation_ID`  ");
            sb_1.Append("  INNER JOIN investigation_master invm  ON invm.`Investigation_Id` = li.`Investigation_ID`  ");
            sb_1.Append(" WHERE li.LabObservation_ID='" + txtobserid + "'and li.Investigation_Id='" + investigationid + "'  ");
            DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());

            if (txtLeft.Text != "")
            {
                string str = "UPDATE labobservation_investigation SET formula='" + txtRight.Text.ToString() + "'WHERE LabObservation_ID='" + txtObservationID.Text.ToString() + "'and Investigation_Id='" + ddlInvestigations.SelectedValue + "' ";
                StockReports.ExecuteDML(str);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Formula Saved...');", true);
                clear();
            }

            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Kindly Enter the Formula...');", true);
            }


            sb_1 = new StringBuilder();
            sb_1.Append(" SELECT li.formula,CONCAT(invm.`Name`,' Formula Changes ',obsm.`Name`)NAME FROM   labobservation_investigation li ");
            sb_1.Append("  INNER JOIN labobservation_master obsm  ON obsm.`LabObservation_ID` = li.`labObservation_ID`  ");
            sb_1.Append("  INNER JOIN investigation_master invm  ON invm.`Investigation_Id` = li.`Investigation_ID`  ");
            sb_1.Append(" WHERE li.LabObservation_ID='" + txtobserid + "'and li.Investigation_Id='" + investigationid + "' ; ");

            //DataTable dt_LTD_3 = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, sb_1.ToString()).Tables[0];
            DataTable dt_LTD_2 = StockReports.GetDataTable(sb_1.ToString());
          

            for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
            {
                string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                if ((Util.GetString(dt_LTD_1.Rows[0][i]) != Util.GetString(dt_LTD_2.Rows[0][i])))
                {
                    sb_1 = new StringBuilder();
                    sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`LedgertransactionNo`,`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,StatusID) ");
                    sb_1.Append("  values('','FormulaMaster Update','" + Util.GetString(dt_LTD_1.Rows[0][i]) + "','" + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "',' investigation " + Util.GetString(dt_LTD_2.Rows[0]["NAME"]) + " " + _ColumnName + "  from " + Util.GetString(dt_LTD_1.Rows[0][i]) + " to " + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + StockReports.getip() + "',66);  ");
                    //sb_1.Append("  values('','Investigation Update','" + Util.GetString(dt_LTD_1.Rows[0][i]) + "','" + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2.Rows[0]["Name"] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_1.Rows[0][i]) + " to " + Util.GetString(dt_LTD_2.Rows[0][i]) + "','" + StockReports.getip() + "');  ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb_1.ToString());
                }
            }

            Tranx.Commit();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //  return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void clear()
    {
        txtRight.Text = "";
        txtLeft.Text = "";
        txtObservationID.Text = "";
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        if (txtLeft.Text != "")
        {
            string str = " UPDATE labobservation_investigation SET Formula='' WHERE labObservation_ID='" + txtObservationID.Text.ToString() + "' and Investigation_Id='" + ddlInvestigations.SelectedValue + "' ";
            StockReports.ExecuteDML(str);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Formula Deleted...');", true);
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Kindly Select Observation...');", true);
        }
        clear();
    }
}