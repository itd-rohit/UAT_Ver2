using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_QCAlert : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT qcil.ProcessingLabID,qcil.ProcessingLabName,COUNT(1) TotalMappedTest, ");
            sb.Append(" (SELECT COUNT(1) FROM `qc_ilcregistration`  WHERE centreid=qcil.ProcessingLabID AND isreject=0 AND entrymonth=" + DateTime.Now.Month + " AND entryyear=" + DateTime.Now.Year + ") RegisteredTest, ");
            sb.Append(" (SELECT COUNT(1) FROM `qc_ilcresultentry`  WHERE ProcessingLabID=qcil.ProcessingLabID AND entrymonth="+DateTime.Now.Month+" AND entryyear="+DateTime.Now.Year+") ResultDone, ");
            sb.Append(" (SELECT COUNT(1) FROM `qc_ilcresultentry`  WHERE ProcessingLabID=qcil.ProcessingLabID AND entrymonth=" + DateTime.Now.Month + " AND entryyear=" + DateTime.Now.Year + " AND approved=1) Approved, ");


            sb.Append(" CONCAT(CONCAT(qil.todate,'-',DATE_FORMAT(NOW(),'%b-%Y')),' (',DATEDIFF(CONCAT(DATE_FORMAT(NOW(),'%Y-%m'),'-',qil.todate),NOW())   ,' Days to Go)') LastDateofregis, ");
            sb.Append(" CONCAT(CONCAT(qil1.todate,'-',DATE_FORMAT(NOW(),'%b-%Y')),' (',DATEDIFF(CONCAT(DATE_FORMAT(NOW(),'%Y-%m'),'-',qil1.todate),NOW())   ,' Days to Go)') LastDateofsave  ");




            sb.Append(" FROM f_login fl ");
            sb.Append(" INNER JOIN `qc_ilcparametermapping` qcil ON qcil.processinglabid=fl.centreid AND isactive=1 ");
            sb.Append(" INNER JOIN qc_ilcschedule qil ON qil.ProcessingLabID=qcil.ProcessingLabID  AND qil.isspecial=0 AND qil.isactive=1 AND qil.scheduletype=1 ");
            sb.Append(" INNER JOIN qc_ilcschedule qil1 ON qil1.ProcessingLabID=qcil.ProcessingLabID  AND qil1.isspecial=0 AND qil1.isactive=1 AND qil1.scheduletype=2 ");
            sb.Append(" WHERE employeeid="+UserInfo.ID+" AND roleid=237 AND centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ");
            sb.Append(" GROUP BY qcil.ProcessingLabID ");

            grd.DataSource = StockReports.GetDataTable(sb.ToString());
            grd.DataBind();
        }
    }
}