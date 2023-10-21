using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Configuration;

public partial class Design_Websitedata_FeedBackInfo : System.Web.UI.Page
{

   // string myconstr = ConfigurationManager.ConnectionStrings["constring"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDOV.Text = DateTime.Now.ToString("dd-MM-yyyy");
        }

    }
    


    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        string date = txtDOV.Text.Split('-')[0].ToString();
        string month = txtDOV.Text.Split('-')[1].ToString();
        string year = txtDOV.Text.Split('-')[2].ToString();

        string mydatetime = year + "-" + month + "-" + date;

        string knowoverview="";
        string chose="";
        if(radKnow.SelectedValue.ToString()=="0")
        {
            knowoverview=txtAnyOth.Text;
        }
        else
        {
            knowoverview=radKnow.SelectedValue.ToString();
        }

        if(radChose.SelectedValue.ToString()=="0")
        {
            chose=txtChose.Text;
        }
        else
        {
            chose=radChose.SelectedValue.ToString();
        }

        try
        {
            
            string myconstr = "server=112.196.49.139;user id=root;  password=!td0se@123!;database=surbhi;port=3333; pooling=false;Respect Binary Flags=false;Allow Zero Datetime=true;";
            string query = "INSERT INTO FEEDBACK (FBNAME, FBDOV, FBADDRESS, FBMBNO, FBEMAILID, FBVISTITIME, FBKNOWABT, FBWHYCCL, FBREGPROCESS, FBSTAFF, FBBLOODTIME, FBTECH, FBREPORT, FBREPSERVICE, FBRATE, FBRECMMEND, FBFEEDBACK,Date) VALUES('" + txtName.Text + "','" + Convert.ToDateTime(mydatetime).ToString("yyyy-MM-dd") + "','" + txtAdd.Text + "','" + txtMbNo.Text + "','" + txtEmail.Text + "','" + radTime.SelectedValue.ToString() + "','" + knowoverview + "','" + chose + "','" + radRegProcess.SelectedValue.ToString() + "','" + radStaff.SelectedValue.ToString() + "','" + radBlood.SelectedValue.ToString() + "','" + radTech.SelectedValue.ToString() + "','" + radRep.SelectedValue.ToString() + "','" + radAware.SelectedValue.ToString() + "','" + radSer.SelectedValue.ToString() + "','" + radRecommend.SelectedValue.ToString() + "','" + txtFeedback.Text + "',Now())";

            MySqlConnection con = new MySqlConnection(myconstr);
            MySqlCommand cmd = new MySqlCommand(query,con);
            MySqlDataReader sdr;
            con.Open();
            sdr = cmd.ExecuteReader();
            lblMsg.Text = "Record Save Successfully";
            con.Close();
            txtAdd.Text = "";
            txtAnyOth.Text = "";
            txtChose.Text = "";
            txtDOV.Text = DateTime.Now.ToString("dd-MM-yyyy");
            txtEmail.Text = "";
            txtFeedback.Text = "";
            txtMbNo.Text = "";
            txtName.Text = "";
            radAware.SelectedIndex = -1;
            radBlood.SelectedIndex = -1;
            radChose.SelectedIndex = -1;
            radKnow.SelectedIndex = -1;
            radRecommend.SelectedIndex = -1;
            radRegProcess.SelectedIndex = -1;
            radRep.SelectedIndex = -1;
            radSer.SelectedIndex = -1;
            radStaff.SelectedIndex = -1;
            radTech.SelectedIndex = -1;
            radTime.SelectedIndex = -1;
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Record Not Save";
        }

    }
}