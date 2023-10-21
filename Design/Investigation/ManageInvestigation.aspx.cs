using System;
using System.Data;
using System.Web.UI.WebControls;
using System.Web.Services;

public partial class Design_Investigation_ManageInvestigation : System.Web.UI.Page
{
    public string reportType = "1";
    public string investigationID = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindSampleChkList();
            BindDepartment();
            BindInvListBox();
            BindOutSrcLab();
            Bindcolors();
            BindContainer();
           // bindconcentform();
// bindsubgroup();
            binddocument();
            bindbillingCategory();
        }
    }
	
	    [WebMethod]
    public static int testcodenumber()
    {
        int chkTestCode = Util.GetInt(StockReports.ExecuteScalar(" SELECT MAX(id) FROM `f_itemmaster` "));
        int chkTestnumber = (chkTestCode + 1);
        return chkTestnumber;

    }

	
  //public void bindsubgroup()
  //  {
  //      DataTable dt = StockReports.GetDataTable("SELECT ID,SubgroupName FROM `f_itemsubgroup`");
  //      if (dt != null && dt.Rows.Count > 0)
  //      {

  //          ddlsubgroup.DataSource = dt;
  //          ddlsubgroup.DataTextField = "SubgroupName";
  //          ddlsubgroup.DataValueField = "ID";
  //          ddlsubgroup.DataBind();
  //      }
  //      ddlsubgroup.Items.Insert(0, new ListItem("", ""));
  //  }
    void bindbillingCategory()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Name FROM billingCategory_master where IsActive=1 ORDER BY Name ");
        ddlBillingCategory.DataSource = dt;
        ddlBillingCategory.DataTextField = "Name";
        ddlBillingCategory.DataValueField = "ID";
        ddlBillingCategory.DataBind();
       // ddlBillingCategory.Items.Insert(0, new ListItem("Select", "0"));
    }
    public void binddocument()
    {
        chkdocument.DataSource = StockReports.GetDataTable("SELECT ID,Name FROM `document_master` WHERE isactive=1 AND ID NOT IN(1,6,10) ORDER BY NAME ");
        chkdocument.DataTextField = "Name";
        chkdocument.DataValueField = "ID";
        chkdocument.DataBind();
    }
    public void bindconcentform()
    {
        DataTable dt = StockReports.GetDataTable("Select concentformname from investigation_concentform");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlConcernFormType.DataSource = dt;
            ddlConcernFormType.DataTextField = "concentformname";
            ddlConcernFormType.DataValueField = "concentformname";
            ddlConcernFormType.DataBind();
        }
        ddlConcernFormType.Items.Insert(0, new ListItem("", ""));
    }

    protected void chkSample_DataBound(object sender, EventArgs e)
    {
        CheckBoxList chkList = (CheckBoxList)(sender);
        foreach (ListItem item in chkList.Items)
        {
            item.Attributes.Add("id", item.Value);
            item.Attributes.Add("chk_text", item.Text);
        }
    }

    private void BindContainer()
    {
        DataTable dt = StockReports.GetDataTable("Select containername containername,id id from samplecontainer_master");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlcontainer.DataSource = dt;
            ddlcontainer.DataTextField = "containername";
            ddlcontainer.DataValueField = "id";
            ddlcontainer.DataBind();
        }
       // ddlcontainer.Items.Insert(0, new ListItem("", ""));
    }

    private void Bindcolors()
    {
        DataTable dt = StockReports.GetDataTable("Select ColorName,ColorCode from ColorMaster");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlcolor.DataSource = dt;
            ddlcolor.DataTextField = "ColorName";
            ddlcolor.DataValueField = "ColorCode";
            ddlcolor.DataBind();
        }
    }

    private void BindOutSrcLab()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,NAME FROM outsourcelabmaster WHERE Active=1 ORDER BY NAME");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlOutSrcLab.DataSource = dt;
            ddlOutSrcLab.DataTextField = "Name";
            ddlOutSrcLab.DataValueField = "ID";
            ddlOutSrcLab.DataBind();
            ddlOutSrcLab.Items.Insert(0, "");
        }
    }

    private void BindDepartment()
    {
        //BindInvestigation();
        DataTable dt = StockReports.GetDataTable("Select Name,ObservationType_ID from observationtype_master where isActive=1 Order By Name");
        ddlGroupHead.DataSource = dt;
        ddlGroupHead.DataTextField = "Name";
        ddlGroupHead.DataValueField = "ObservationType_ID";
        ddlGroupHead.DataBind();

        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "Name";
        ddlDepartment.DataValueField = "ObservationType_ID";
        ddlDepartment.DataBind();
        //ddlDepartment.Items.Add(new ListItem("All Investigations", "ALL"));
        ddlDepartment.Items.Insert(0, new ListItem("All Investigations", "ALL"));
    }

    private void BindInvListBoxInActive()
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt1 = ObjMapInvObs.BindInvListBox();

        lstInvestigation.DataSource = dt1;
        lstInvestigation.DataTextField = "Name";
        lstInvestigation.DataValueField = "newValue";
        lstInvestigation.DataBind();
        ListBox2.DataSource = dt1;
        ListBox2.DataTextField = "Name";
        ListBox2.DataValueField = "newValue";
        ListBox2.DataBind();
    }

    private void BindInvListBox()
    {
        MapInvestigation_Observation ObjMapInvObs = new MapInvestigation_Observation();
        DataTable dt1 = ObjMapInvObs.BindInvListBox(ddlDepartment.SelectedValue);

        lstInvestigation.DataSource = dt1;
        lstInvestigation.DataTextField = "Name";
        lstInvestigation.DataValueField = "newValue";
        lstInvestigation.DataBind();
        ListBox2.DataSource = dt1;
        ListBox2.DataTextField = "Name";
        ListBox2.DataValueField = "newValue";
        ListBox2.DataBind();
    }

    public void bindSampleChkList()
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,SampleName from sampletype_master WHERE IsActive=1 ORDER BY SampleName ");
        chkSample.DataSource = dt;
        chkSample.DataTextField = "SampleName";
        chkSample.DataValueField = "id";
        chkSample.DataBind();
    }

    protected void ChkInActive_CheckedChanged(object sender, EventArgs e)
    {
        if (ChkInActive.Checked == true)
            BindInvListBoxInActive();
        else
            BindInvListBox();
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
    }
    protected void chkdocument_DataBound(object sender, EventArgs e)
    {
        CheckBoxList chkList = (CheckBoxList)(sender);
        foreach (ListItem item in chkList.Items)
        {
            item.Attributes.Add("id", item.Value);
            item.Attributes.Add("chk_text", item.Text);
        }
    }
}