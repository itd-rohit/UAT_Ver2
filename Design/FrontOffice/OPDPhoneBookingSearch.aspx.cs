using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_FrontOffice_OPDPhoneBookingSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindDoctor();
            bindTitle();

        }
    }

    private void BindDoctor()
    {
        string str = "select Doctor_ID,name   from doctor_master order by name";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        ddldoctor.DataSource = dt;
        ddldoctor.DataTextField = "name";
        ddldoctor.DataValueField = "Doctor_ID";
        ddldoctor.DataBind();

        ddldoctor.Items.Insert(0, new ListItem("Select","0"));




    }

    private void bindTitle()
    {
        ddltitle.DataSource = AllGlobalFunction.NameTitle;
        ddltitle.DataBind();

    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        lblmsg.Text = "";
        sb.Append("");
        sb.Append(" SELECT app_id, CONCAT(app.title,app.pname) pname,app.Age,pm.gender,pm.mobile,LedgerTransactionNO,app.patient_id,  ");
        sb.Append(" (SELECT NAME FROM doctor_master WHERE doctor_id=app.doctor_id) dname ,  ");
        sb.Append(" DATE_FORMAT(DATE,'%d-%b-%Y') Appdate,TIME_FORMAT(Appointment_time,'%r') AppTime,  ");
        sb.Append(" CASE when flag='3' then 'Canceled' WHEN LedgerTransactionNO='' THEN 'NotRegister' ELSE 'Register' END STATUS  ");
        sb.Append(" FROM appointment app inner join patient_master pm on pm.patient_id=app.patient_id   ");

        sb.Append(" where date(DATE)>='" + Util.GetDateTime(txtfromdate.Text.Trim()).ToString("yyyy-MM-dd") + "'");
        sb.Append(" and date(DATE)<='" + Util.GetDateTime(txttodate.Text.Trim()).ToString("yyyy-MM-dd") + "'");

        if (ddldoctor.SelectedValue != "0")
        {
            sb.Append(" and app.doctor_id='"+ddldoctor.SelectedValue.ToString()+"' ");
        }

        if (txtpname.Text != "")
        {
            sb.Append(" and app.pname like '%" + txtpname.Text + "%' ");
        }
        if (txtmobile.Text != "")
        {
            sb.Append(" and pm.mobile ='" + txtmobile.Text + "' ");
        }
        if (ddlstatus.SelectedValue == "0")
        {

            sb.Append(" and flag in(0,1) and  LedgerTransactionNO<>'' ");
        }
        else if (ddlstatus.SelectedValue == "1")
        {

            sb.Append(" and flag in(1) and  LedgerTransactionNO='' ");
        }
        else
        {
            sb.Append(" and flag=3  ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grdapp.DataSource = dt;
        grdapp.DataBind();

        if (dt.Rows.Count == 0)
        {
            lblmsg.Text = "No Record Found..!";
        }
    }

    protected void grdapp_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "imbRemove")
            {
                int args = Util.GetInt(e.CommandArgument);

                string id = grdapp.DataKeys[args].Value.ToString();

                StockReports.ExecuteDML("update appointment set  flag='3' where app_id='" + id + "'");
                btnsearch_Click(sender,e);

            }

            else if (e.CommandName == "editbooking")
            {
                
                int args = Util.GetInt(e.CommandArgument);
                string id = grdapp.DataKeys[args].Value.ToString();
                
                ViewState["pid"] = ((Label)grdapp.Rows[args].FindControl("lblpid")).Text;


                DataTable dtc = StockReports.GetDataTable("select title,pname,age,gender,house_no,city,mobile  from patient_master where patient_id='" + ViewState["pid"].ToString() + "'");
               if (dtc.Rows.Count > 0)
               {
                   ddltitle.SelectedIndex = ddltitle.Items.IndexOf(ddltitle.Items.FindByText(dtc.Rows[0]["title"].ToString()));
                   ddlGender.SelectedIndex = ddlGender.Items.IndexOf(ddlGender.Items.FindByText(dtc.Rows[0]["gender"].ToString()));
                   txtpnameedit.Text = dtc.Rows[0]["pname"].ToString();
                   txtAge.Text = dtc.Rows[0]["age"].ToString().Split(' ')[0].ToString();
                   ddlAge.SelectedIndex = ddlAge.Items.IndexOf(ddlAge.Items.FindByText(dtc.Rows[0]["age"].ToString().Split(' ')[1].ToString()));
                   txtmobileedit.Text = dtc.Rows[0]["mobile"].ToString();
                   txtadddressedit.Text = dtc.Rows[0]["house_no"].ToString();
                   txtcityedit.Text = dtc.Rows[0]["city"].ToString();
                   ModalPopupExtender2.Show();
               }

              
            }
            else if (e.CommandName == "cancelbooking")
            {
                int args = Util.GetInt(e.CommandArgument);
                string id = grdapp.DataKeys[args].Value.ToString();
                ModalPopupExtender1.Show();
                ViewState["labno"] = ((Label)grdapp.Rows[args].FindControl("labno")).Text;
            }
        }
        catch
        {
        }
    }

    protected void grdapp_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ImageButton im = (ImageButton)e.Row.FindControl("imbRemove");
            ImageButton im1 = (ImageButton)e.Row.FindControl("imbRemove2");
            ImageButton im2 = (ImageButton)e.Row.FindControl("imbRemove1");
            
            im1.Visible = false;
            im2.Visible = false;
            im.Attributes.Add("onclick", "javascript:return confirm('Are you sure you want to cancel this appointment ..?')");

           


            if (e.Row.Cells[8].Text == "Register")
            {
                im.Visible = false;
                im1.Visible = true;
                im2.Visible = true;
                e.Row.BackColor = System.Drawing.Color.LightGreen;

            }
            else if (e.Row.Cells[8].Text == "Canceled")
            {
                im.Visible = false;
                e.Row.BackColor = System.Drawing.Color.Pink;
            }
        }
    }

    protected void btncancelbooking_Click(object sender, EventArgs e)
    {

      

        string labo = ViewState["labno"].ToString();

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update appointment set  flag='3'  where LedgerTransactionNo='" +labo + "' ");
            string sql = " call ReceiptCancelLab('" + labo + "','LAB','" + HttpContext.Current.Session["ID"].ToString() + "','" + txtcancereason.Text + "','" + StockReports.getip() + "')";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql);

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update doctor_integration.appointment_interface set  isCancel=1,CancelReason='" + txtcancereason.Text + "',IsSync=2 where LedgerTnxNo='" + labo + "' ");

            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
           
            btnsearch_Click( sender,  e);
            lblmsg.Text = "Booking Cancel..!";
        } 

        catch (Exception ex)
        {
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblmsg.Text = ex.InnerException.ToString();
        }

        ModalPopupExtender1.Hide();
    }

    protected void btnedtbooking_Click(object sender, EventArgs e)
    {
        StockReports.ExecuteDML("update patient_master set title='" + ddltitle.SelectedItem.Text + "',pname='" + txtpnameedit.Text + "',age='" + txtAge.Text + " " + ddlAge.SelectedItem.Text + "',gender='" + ddlGender.SelectedItem.Text + "',house_no='" + txtadddressedit.Text + "',city='" + txtcityedit.Text + "',mobile='" + txtmobileedit.Text + "'  where patient_id='" + ViewState["pid"].ToString() + "'  ");
        StockReports.ExecuteDML("update appointment set title='" + ddltitle.SelectedItem.Text + "',pname='" + txtpnameedit.Text + "',age='" + txtAge.Text + " " + ddlAge.SelectedItem.Text + "' where patient_id='" + ViewState["pid"].ToString() + "' ");

        StockReports.ExecuteDML("update doctor_integration.appointment_interface set pname='" + txtpnameedit.Text + "',age='" + txtAge.Text + " " + ddlAge.SelectedItem.Text + "',Sex='" + ddlGender.SelectedItem.Text + "',ContactNo='" + txtmobileedit.Text + "',IsSync=2 where patientid='" + ViewState["pid"].ToString() + "' ");

        btnsearch_Click(sender, e);
        lblmsg.Text = "Record Updated..!";

        ModalPopupExtender2.Hide();
    }

}