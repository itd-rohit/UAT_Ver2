using System;
using System.Data;

public partial class Design_Online_Lab_ContactUs : System.Web.UI.Page
{
    private DataSet dataSet = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.GetString(Session["islogin"]) != "true")
        {
            dataSet.Clear();
            dataSet.Reset();
            dataSet.Dispose();
            Response.Redirect("~/Design/OnlineLab/Default.aspx");
        }

        if (!IsPostBack)
        {
            try
            {
                binddata();
            }
            catch
            {
            }
        }
    }

    private void binddata()
    {
        string xmlpath = Server.MapPath("~/Design/OnlineLab/Images/OnlineLabDetail.xml");
        dataSet.ReadXml(xmlpath);
        lbname.InnerText = dataSet.Tables[0].Rows[0]["labName"].ToString();
        lbadd.InnerText = dataSet.Tables[0].Rows[0]["labaddress"].ToString();
        myweb.Attributes.Add("src", dataSet.Tables[0].Rows[0]["labweburl"].ToString());
    }

    protected void Btn_logout_Click(object sender, EventArgs e)
    {
        dataSet.Clear();
        dataSet.Reset();
        dataSet.Dispose();
        Session.Clear();
        Session.Abandon();
        Response.Redirect("~/Design/OnlineLab/Default.aspx");
    }

    protected void ink_Click(object sender, EventArgs e)
    {
        dataSet.Clear();
        dataSet.Reset();
        dataSet.Dispose();
        Session.Clear();
        Session.Abandon();
        Response.Redirect("~/Design/OnlineLab/Default.aspx");
    }
}