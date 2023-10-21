using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;

public partial class Design_Master_B2CCancelReasion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            txtcancelReason.Text = "";
            bindSampleRejection();
            btnSampleRejection.Text = "Save";
        }
        
    }
    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM App_b2c_CancelReason_master WHERE CancelReason='" + txtcancelReason.Text.Trim() + "'"));
        if (count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    protected void BtnSampleRejection_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        string message = "";
        try
        {
            if (txtcancelReason.Text == "")
            {
                
                ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Cancel Reason can't be empty ', '');", true);
                return;
            }
            if (btnSampleRejection.Text == "Update")
            {
                string str = "update App_b2c_CancelReason_master set IsActive='" + ddlActive.SelectedValue + "',CancelReason=@CancelReason,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,UpdatedOn=NOW() where ID=@ID";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                                                new MySqlParameter("@IsActive", ddlActive.SelectedValue), new MySqlParameter("@CancelReason", txtcancelReason.Text), new MySqlParameter("@UpdatedBy", UserInfo.LoginName), new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@ID", txtID.Text));

                message = "Updated";
                bindSampleRejection();
                btnSampleRejection.Text = "Save";
                txtcancelReason.Text = "";
                ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', " + message + ", '');", true);

            }
            else
            {
                if (CheckDuplicate())
                {                    
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Rejection Reason already Exist....', '');", true);
                    return;
                }
                else
                {

                    string instCentre = "insert into App_b2c_CancelReason_master (CancelReason,IsActive,CreatedByID,CreatedBy,CreatedOn) values(@CancelReason,@IsActive,@CreatedByID,@CreatedBy,NOW())";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, instCentre.ToString(),
                                               new MySqlParameter("@IsActive", ddlActive.SelectedValue), new MySqlParameter("@CancelReason", txtcancelReason.Text), new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName));

                    message = "Saved";
                    txtcancelReason.Text = "";
                    bindSampleRejection();
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', " + message + ", '');", true);
                }


            }
           
            tranX.Commit();
        }

        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void bindSampleRejection()
    {
        string mystr = "SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,CancelReason FROM App_b2c_CancelReason_master";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        GrdSampleRejection.DataSource = dt;
        GrdSampleRejection.DataBind();
    }
    protected void GrdCentres_SelectedIndexChanged(object sender, EventArgs e)
    {
       
        btnSampleRejection.Text = "Update";

        string ID = ((Label)GrdSampleRejection.SelectedRow.FindControl("local_ID")).Text;

        txtID.Text = ID;
        //DataTable dt = StockReports.GetDataTable("select * from centre_master where centreid=" + CentreId);


        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,CancelReason FROM App_b2c_CancelReason_master where ID=" + ID);
        if (dt.Rows.Count > 0)
        {
            txtcancelReason.Text = dt.Rows[0]["CancelReason"].ToString();
            if (dt.Rows[0]["Active"].ToString() == "No")
            {
                ddlActive.SelectedIndex = 0;
            }
            else
            {
                ddlActive.SelectedIndex = 1;
            }
        }


    }
}

