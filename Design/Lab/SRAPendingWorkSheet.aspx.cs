using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_SRAPendingWorkSheet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["LoginName"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }

            lblMsg.Text = "";
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindCenterDDL();

        }
    }

    void bindCenterDDL()
    {
        DataTable dt = StockReports.GetDataTable(" select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.centrecode,cm.Centre ");



        ddlcentre.DataSource = dt;
        ddlcentre.DataValueField = "CentreID";
        ddlcentre.DataTextField = "Centre";
        ddlcentre.DataBind();


        ListItem selectedListItem = ddlcentre.Items.FindByValue(UserInfo.Centre.ToString());

        if (selectedListItem != null)
        {
            selectedListItem.Selected = true;
        }




    }

    protected void btn_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT (select centre from centre_master where centreid=sl.tocentreid) Centre, date_format(sl.ReceivedDate,'%d-%b-%Y %h:%i %p')SRADate,(select name from employee_master where employee_id=sl.ReceivedBy)SRAByUser, pli.BarcodeNo SINNo,pli.ledgerTransactionNO VisitID,pli.patient_id MAXID,lt.PName,pli.`SampleTypeName`, ");
        sbQuery.Append(" ot.Name Department,pli.itemname TestName");
        sbQuery.Append(" FROM  patient_labinvestigation_opd pli  ");

        sbQuery.Append(" INNER JOIN investigation_observationtype iot ON pli.investigation_ID=iot.investigation_ID ");
        sbQuery.Append(" inner join observationtype_master ot on ot.ObservationType_ID=iot.ObservationType_ID");
        sbQuery.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgerTransactionID=pli.ledgerTransactionID   AND lt.IsCancel=0   ");
        sbQuery.Append(" inner join sample_logistic sl on sl.barcodeno=pli.barcodeno and sl.isactive=1 and pli.issamplecollected<>'Y'");

        sbQuery.Append(" and sl.tocentreid='" + ddlcentre.SelectedValue + "' AND sl.status='Received' ");

        if (txtsinno.Text == "" && txtLabNo.Text == "")
        {
            sbQuery.Append("  AND sl.ReceivedDate >='" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sbQuery.Append(" AND sl.ReceivedDate <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        else if (txtsinno.Text != "")
        {
            sbQuery.Append(" and sl.BarcodeNo='" + txtsinno.Text + "'");
        }
        else if (txtLabNo.Text != "")
        {
            sbQuery.Append(" and pli.ledgerTransactionNO='" + txtLabNo.Text + "'");
        }

        sbQuery.Append("  AND pli.IsReporting='1' order by sl.`BarcodeNo` ");

        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());

        if (dt.Rows.Count > 0)
        {
            if (rd.SelectedValue == "Excel")
            {
                Session["ReportName"] = " SRA Pending WorkList";
                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
            else
            {

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                dt.TableName = "WorkList";
                //ds.WriteXmlSchema(@"E:\\PendingWorkList.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "SRAWorkList";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            }
        }
        else
        {
            lblMsg.Text = "No Record Found.";
        }


    }
}