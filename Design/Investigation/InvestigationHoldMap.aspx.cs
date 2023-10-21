using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InvestigationHoldMap : System.Web.UI.Page
{
    string InvID = "";
    string obsid = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        InvID = Request.QueryString["InvID"].ToString();
        obsid = Request.QueryString["obsid"].ToString();
        if (!IsPostBack)
        {
          
            // lb.Text = StockReports.ExecuteScalar("select name from investigation_master where Investigation_Id='" + InvID + "'");
             lbobs.Text = StockReports.ExecuteScalar("SELECT name FROM labobservation_master WHERE labobservation_id='" + obsid + "'");
             bindinv();
        }
    }

    void bindinv( )
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT `LabObservation_ID`,NAME  FROM labobservation_master WHERE isactive=1 and labobservation_id<>'" + obsid + "' ORDER BY NAME    ");

        grd.DataSource = dt;
        grd.DataBind();
        ViewState["mydt"] = dt;

     


    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        
        foreach (GridViewRow grdrow in grd.Rows)
        {
            CheckBox ck = (CheckBox)grdrow.FindControl("chk");
            string mapid = ((Label)grdrow.FindControl("Label2")).Text;
            if (ck.Checked)
            {
                StockReports.ExecuteDML("delete from investigation_maphold where LabObservationIDfrom='" + obsid + "' and LabObservationIDto='" + mapid + "'");
                StockReports.ExecuteDML("insert into investigation_maphold (LabObservationIDfrom,LabObservationIDto,createdate,createbyuser) values('" + obsid + "','" + mapid + "',now(),'" + Util.GetString(Session["LoginName"]) + "')");
                StockReports.ExecuteDML("delete from investigation_maphold where LabObservationIDfrom='" + mapid + "' and LabObservationIDto='" + obsid + "'");
                StockReports.ExecuteDML("insert into investigation_maphold (LabObservationIDfrom,LabObservationIDto,createdate,createbyuser) values('" + mapid + "','" + obsid + "',now(),'" + Util.GetString(Session["LoginName"]) + "')");
            }
        }

        lblMsg.Text = " Map Sucessfully..!";
    }
    
    protected void btnsearch_Click(object sender, EventArgs e)
    {

        TextBox tx = (TextBox)grd.HeaderRow.FindControl("txtearch");
        DataTable dt = (ViewState["mydt"] as DataTable);
        dt.DefaultView.RowFilter = string.Format("[name] LIKE '%{0}%'", tx.Text.Trim());
        grd.DataSource = dt;
        grd.DataBind();
    }
    protected void grd_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            CheckBox ck = (CheckBox)e.Row.FindControl("chk");
            string mapid = ((Label)e.Row.FindControl("Label2")).Text;

            string cc = StockReports.ExecuteScalar("select count(*) from investigation_maphold where LabObservationIDfrom='" + obsid + "'  and LabObservationIDto='" + mapid + "'");
            if (cc == "1")
            {
                ck.Checked = true;
            }
            else
            {
                ck.Checked = false;
            }
        }
    }
}