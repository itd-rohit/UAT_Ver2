using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Specialized;
using System.Linq;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_UserBy_Discount_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.FillDateTime(txtFromDate, txtToDate, txtFromTime, txtToTime);
            bindCenterDDL();
            BindUser();
            reportaccess();
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(10));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtFromDate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rdoReportFormat.Items[0].Enabled = true;
                rdoReportFormat.Items[1].Enabled = false;
                rdoReportFormat.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rdoReportFormat.Items[1].Enabled = true;
                rdoReportFormat.Items[0].Enabled = false;
                rdoReportFormat.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rdoReportFormat.Visible = false;
                lblMsg.Text = "Report format not allowed contect to admin";
                return false;
            }
        }
        else
        {
            divcentre.Visible = false;
            divuser.Visible = false;
            divsave.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    

    public void bindCenterDDL()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                ddlcenter.DataSource = dt;
                ddlcenter.DataTextField = "Centre";
                ddlcenter.DataValueField = "CentreID";
                ddlcenter.DataBind();
                ListItem li = new ListItem();
                li.Text = "ALL";
                li.Value = "ALL";
                ddlcenter.Items.Add(li);
                ddlcenter.SelectedIndex = ddlcenter.Items.IndexOf(ddlcenter.Items.FindByValue("ALL"));
            }
        }
    }

    private void BindUser()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = new DataTable();
            string str = "Select CONCAT(em.Title,' ',Name)As Name,em.Employee_ID from employee_master em inner join f_login flg on flg.EmployeeID = em.Employee_ID where em.IsActive=1 and flg.Active=1 and flg.RoleID=9 and flg.CentreID=@CentreID" ;
            dt = MySqlHelper.ExecuteDataset(con,CommandType.Text,str,
                new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
            if (dt.Rows.Count > 0)
            {
                cblUser.DataSource = dt;
                cblUser.DataTextField = "Name";
                cblUser.DataValueField = "Employee_ID";
                cblUser.DataBind();
            }

            if (Session["LoginType"].ToString().ToLower() == "Billing")
            {
                for (int i = 0; i < cblUser.Items.Count; i++)
                {
                    if (Session["ID"].ToString() != cblUser.Items[i].Value)
                    {
                        cblUser.Items[i].Attributes.Add("style", "display:none;");
                    }
                    else
                    {
                        cblUser.Items[i].Selected = true;
                        cblUser.Items[i].Enabled = false;
                    }
                }
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

    protected void btnPreview_Click(object sender, EventArgs e)
    {
        if (!reportaccess())
            return; 
        string UsrID = string.Empty;
        if ((txtFromDate.Text == string.Empty) || (txtToDate.Text == string.Empty))
        {
            lblMsg.Text = "Please select date !";
            return;
        }
        string rresult = Util.DateDiffReportSearch(Util.GetDateTime(txtToDate.Text), Util.GetDateTime(txtFromDate.Text));
        if (rresult == "true")
        {
            lblMsg.Text = "Your From date ,To date Diffrence is too  Long";
            return;
            //return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
        }
        string fromDate = string.Empty, toDate = string.Empty;

        if (txtFromDate.Text != string.Empty)
            if (txtFromTime.Text.Trim() != string.Empty)
                fromDate =string.Concat(Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") , " " , txtFromTime.Text.Trim());
            else
                fromDate = Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd");

        if (txtToDate.Text != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") , " " , txtToTime.Text.Trim());
            else
                toDate = Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd");

        UsrID = GetSelection(cblUser);
        lblMsg.Text = "";
        try
        {
            NameValueCollection collections = new NameValueCollection();
            collections.Add("fromDate", fromDate);
            collections.Add("toDate", toDate);
            collections.Add("CentreID", ddlcenter.SelectedItem.Value);
            collections.Add("UserID", UsrID);
            collections.Add("ReportFormat", rdoReportFormat.SelectedValue);
            AllLoad_Data.POSTForm(collections, "Design/Reports/BusinessReport/DiscountReportPdf.aspx", this.Page);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private string GetSelection(CheckBoxList cbl)
    {
        return string.Join(", ", cbl.Items.Cast<ListItem>().Where(s => s.Selected).Select(x => x.Value).ToArray());
    }
}