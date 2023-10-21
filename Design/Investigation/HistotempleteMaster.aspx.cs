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
using System.Text;

public partial class Design_Investigation_HistotempleteMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtAntibiotic.Focus();
            BindDepartment();
            BindGrid("");
            btnUpdate.Visible = false;
        }

    }
    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
        sb.Append("  and  SubCategoryID in ('44','48') ");
        sb.Append(" ORDER BY NAME");
        ddlDepartment.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlDepartment.DataTextField = "NAME";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
        // ddlDepartment.Items.Insert(0, new ListItem("Histo and Cyto Dept", ""));
    }
    private void BindGrid(string testname)
    {
       // txtAntibiotic.Text = "";
        chkActive.Checked = true;
        string query = "SELECT Template_ID `SpecimenID`,Template_Name `SpecimenName`,`IsActive`,if(isactive='1','Active','Deactive') status,Name Subcategory,htm.SubCategoryID FROM `histo_template_master` htm left join f_subcategorymaster sb on sb.SubcategoryID=htm.SubcategoryID where Template_Name<>'' ";
        if (testname != "")
        {
            query += " and Template_Name like '%" + testname + "%' ";
        }
    //    if (ddlDepartment.SelectedValue != "")
  //      {
           // query += " and htm.Subcategoryid ="+ ddlDepartment.SelectedValue +"";
//        }
        query += " order by Template_Name ";
        DataTable dt = StockReports.GetDataTable(query);
        GridView1.DataSource = dt;
        GridView1.DataBind();

    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)GridView1.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)GridView1.SelectedRow.FindControl("Label2")).Text;
        string Status = ((Label)GridView1.SelectedRow.FindControl("Label3")).Text;
        string deptid = ((Label)GridView1.SelectedRow.FindControl("Labelsubid")).Text;
        txtAntibiotic.Text = Name;
        if(deptid !="0")
        ddlDepartment.SelectedValue = deptid;
        setdata(ID);
        txtId.Text = ID;
        if (Status == "1")
        {
            chkActive.Checked = true;
        }
        else
        {
            chkActive.Checked = false;
        }
        btnSave.Visible = false;
        btnUpdate.Visible = true;

    }
    void setdata(string id)
    {
       string data= StockReports.ExecuteScalar("select " + ddltype.SelectedValue + " from histo_template_master where Template_ID='" + id + "' order by Template_Id ");
      txtLimit.Text= Server.HtmlDecode(Util.GetString(data));
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (txtAntibiotic.Text == "")
        {
            lblMsg.Text = "Please Enter Template Name";
            return;
        }
        string header = "";
        header = txtLimit.Text;
        header = header.Replace("\'", "");
        header = header.Replace("–", "-");
        header = header.Replace("'", "");
        header = header.Replace("µ", "&micro;");
        header = header.Replace("ᴼ", "&deg;");
        header = header.Replace("#aaaaaa 1px dashed", "none");
        header = header.Replace("dashed", "none");
        if (header == "")
        {
            lblMsg.Text = "Please Enter Template in Editor";
            return;
        }

        bool dt;
        string IsActive = "0";
        if (chkActive.Checked == true)
        {
            IsActive = "1";
        }
        

       string issaved= StockReports.ExecuteScalar("select Template_ID from histo_template_master where Template_Name='"+txtAntibiotic.Text+"' and SubcategoryID ='"+ ddlDepartment.SelectedValue +"'");
       if (issaved == "")
       {
           string s = StockReports.ExecuteScalar("select max(Template_ID) from histo_template_master");
           int id = Util.GetInt(s) + 1;
           StringBuilder sb = new StringBuilder();
           sb.Append("INSERT  INTO histo_template_master(Template_ID,Template_Name,IsActive,CreatedByUserID,CreateDateTime," + ddltype.SelectedValue + ",SubcategoryID) VALUES (" + id + ",'" + txtAntibiotic.Text + "','" + IsActive + "','" + HttpContext.Current.Session["ID"].ToString() + "',now(),'" + Util.GetString(header).Replace("'", "") + "','" + ddlDepartment.SelectedValue + "')");
           dt = StockReports.ExecuteDML(sb.ToString());
           if (dt == true)
           {
               lblMsg.Text = "Record Saved..!";
              
           }
       }
       else
       {
           StringBuilder sb = new StringBuilder();
           sb.Append("update  histo_template_master set " + ddltype.SelectedValue + "='" + Util.GetString(header).Replace("'", "") + "' where Template_ID='"+issaved+"'");
           dt = StockReports.ExecuteDML(sb.ToString());
           if (dt == true)
           {
               lblMsg.Text = "Record Updated..!";
               
               
           }
       }
      

       txtAntibiotic.Text = "";
       txtLimit.Text = "";
       BindGrid("");
       
    }
    protected void Unnamed_Click(object sender, EventArgs e)
    {
        if (txtAntibiotic.Text == "")
        {
            lblMsg.Text = "Please Enter Template Name";
            return;
        }
        string header = "";
        header = txtLimit.Text;
        header = header.Replace("\'", "");
        header = header.Replace("–", "-");
        header = header.Replace("'", "");
        header = header.Replace("µ", "&micro;");
        header = header.Replace("ᴼ", "&deg;");
        header = header.Replace("#aaaaaa 1px dashed", "none");
        header = header.Replace("dashed", "none");
        if (header == "")
        {
            lblMsg.Text = "Please Enter Template in Editor";
            return;
        }
        bool dt;
        string IsActive = "0";
        if (chkActive.Checked == true)
        {
            IsActive = "1";
        }
        StringBuilder sb = new StringBuilder();


        sb.Append("update  histo_template_master set " + ddltype.SelectedValue + "='" + Util.GetString(header).Replace("'", "") + "',Template_Name='" + txtAntibiotic.Text + "',IsActive='" + IsActive + "' where Template_ID='" + txtId.Text + "'");
        dt = StockReports.ExecuteDML(sb.ToString());
        if (dt == true)
        {
            lblMsg.Text = "Record Updated..!";
            BindGrid("");
        }
        txtAntibiotic.Text = "";
        txtId.Text = "";
        chkActive.Checked = true;
        btnSave.Visible = true;
        btnUpdate.Visible = false;
        txtLimit.Text = "";
    }
    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string status = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label3")).Text;
        string ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label1")).Text;
        if (status == "1")
        {
            StockReports.ExecuteDML("update  Specimen_master set IsActive='0' where SpecimenID='" + ID + "' ");
        }
        else
        {
            StockReports.ExecuteDML("update  Specimen_master set IsActive='1' where SpecimenID='" + ID + "' ");
        }

        lblMsg.Text = "Record Updated..!";
        BindGrid("");
    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            string status = ((Label)e.Row.FindControl("Label3")).Text;
            string Name = ((Label)e.Row.FindControl("Label2")).Text;
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
    protected void txtsearch_TextChanged(object sender, EventArgs e)
    {

    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtsearch.Text);
    }
    protected void ddltype_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (txtAntibiotic.Text != "")
        {
            string issaved = StockReports.ExecuteScalar("select Template_ID from histo_template_master where Template_Name='" + txtAntibiotic.Text + "'");
            setdata(issaved);
        }
    }
}