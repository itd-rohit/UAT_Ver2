using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_SalesReportDateWise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            binddept();

        }
    }

    void binddept()
    {
        ddldepartment.DataSource = StockReports.GetDataTable("select SubCategoryID,name from f_subcategorymaster where active=1 order by name");
        ddldepartment.DataTextField = "name";
        ddldepartment.DataValueField = "SubCategoryID";
        ddldepartment.DataBind();
        ddldepartment.Items.Insert(0, new ListItem("Select", "0"));
    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        string fromdate = Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00";
        string todate = Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd") + " 23:59:59";
        StringBuilder sb;

        if (rd.SelectedValue == "0")
        {
            sb = new StringBuilder();

            sb.Append("   SELECT  sm.name Department,  DAY(lt.date) DAY,ROUND(SUM( plo.`Amount` ),0) netamount FROM f_ledgertransaction lt   ");
            sb.Append(" INNER JOIN `Patient_labInvestigation_OPD` plo ON plo.`LedgerTransactionId`=lt.`LedgerTransactionId` AND lt.IsCancel = 0 /* AND plo.IsSampleCollected='Y' */  ");
            sb.Append(" AND lt.DATE >= '" + fromdate + "' AND  lt.DATE <= '" + todate + "'   ");
            sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` AND active=1  ");
            sb.Append(" GROUP BY sm.name,DAY(lt.date)  ORDER BY sm.name,DAY(lt.date) ");


            DataTable dtme = StockReports.GetDataTable(sb.ToString());
            if (dtme.Rows.Count > 0)
            {
                DataTable dt = changedatatablepaneldetail(dtme, "Department");

                lblMsg.Text = "";
                grd.DataSource = dt;
                grd.DataBind();
                try
                {
                    int i = 0;
                    int j = 0;
                    int sum = 0;
                    for (i = 1; i <= dt.Columns.Count - 1; i++)
                    {
                        for (j = 0; j <= dt.Rows.Count - 1; j++)
                        {
                            sum += Util.GetInt(dt.Rows[j][i].ToString());
                        }
                        grd.FooterRow.Cells[0].Text = "Total";
                        grd.FooterRow.Cells[i].Text = sum.ToString();
                        sum = 0;
                    }
                }
                catch
                {
                }
            }
            else
            {
                grd.DataSource = "";
                grd.DataBind();
                lblMsg.Text = "No Record Found..!";
                return;
            }
        }
        else if (rd.SelectedValue == "1")
        {
            if (ddldepartment.SelectedValue == "0")
            {
                lblMsg.Text = "Please Select Department";
                return;
            }
            sb = new StringBuilder();
            //sb.Append(" SELECT ");
            //sb.Append(" concat(im.testcode,'-', im.typename) TestName, ");
            //sb.Append(" day(lt.date) Day,round(SUM( ltd.`Amount` ),0) netamount FROM f_ledgertransaction lt ");
            //sb.Append(" INNER JOIN patient_medical_history pmh  ");
            //sb.Append(" ON pmh.Transaction_ID = lt.Transaction_ID   ");

            //sb.Append(" AND lt.IsCancel = 0  ");
            //sb.Append(" AND lt.DATE >= '" + fromdate + "' AND  lt.DATE <= '" + todate + "' ");


            //sb.Append(" INNER JOIN `f_ledgertnxdetail` ltd ON ltd.`LedgerTransactionNo`=lt.`LedgerTransactionNo`   AND lt.`Panel_ID`<>1065  ");
            //sb.Append(" INNER JOIN `f_itemmaster` im ON im.`itemid`=ltd.`itemid`  ");
            //sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=im.`SubCategoryID` and sm.SubCategoryID='" + ddldepartment.SelectedValue + "' and active=1 ");



            //sb.Append(" GROUP BY im.itemid,day(lt.date) ");
            //sb.Append(" ORDER BY TestName,day(lt.date)");

            sb.Append("  SELECT  plo.ItemName TestName,  DAY(lt.date) DAY,ROUND(SUM( plo.`Amount` ),0) netamount  ");
            sb.Append(" FROM f_ledgertransaction lt   ");
            sb.Append(" INNER JOIN patient_labInvestigation_OPD plo   ON plo.ledgertransactionId = lt.ledgertransactionId     ");
            sb.Append(" AND lt.IsCancel = 0 AND lt.DATE >= '" + fromdate + "' AND  lt.DATE <= '" + todate + "' ");
            sb.Append(" INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.`SubCategoryID` AND sm.SubCategoryID='" + ddldepartment.SelectedValue + "'  AND active=1   ");
            // sb.Append(" and plo.SubCategoryID='" + ddldepartment.SelectedValue + "'  AND active=1   ");
            sb.Append(" GROUP BY plo.itemid,DAY(lt.date)  ORDER BY TestName,DAY(lt.date) ");


            DataTable dtme = StockReports.GetDataTable(sb.ToString());
            if (dtme.Rows.Count > 0)
            {
                DataTable dt = changedatatablepaneldetail1(dtme, "Department");

                lblMsg.Text = "";
                grd.DataSource = dt;
                grd.DataBind();
                try
                {
                    int i = 0;
                    int j = 0;
                    int sum = 0;
                    for (i = 1; i <= dt.Columns.Count - 1; i++)
                    {
                        for (j = 0; j <= dt.Rows.Count - 1; j++)
                        {
                            sum += Util.GetInt(dt.Rows[j][i].ToString());
                        }
                        grd.FooterRow.Cells[0].Text = "Total";
                        grd.FooterRow.Cells[i].Text = sum.ToString();
                        sum = 0;
                    }
                }
                catch
                {
                }
            }
            else
            {
                grd.DataSource = "";
                grd.DataBind();
                lblMsg.Text = "No Record Found..!";
                return;
            }
        }
        else if (rd.SelectedValue == "2")
        {
            sb = new StringBuilder();
            sb.Append(" 	SELECT t1.Company_Name as PCC,IFNULL(t2.day,DAY('" + fromdate + "'))DAY,t2.netamount FROM             ");
            sb.Append(" 	(SELECT fpm.`Panel_ID`,CONCAT(fpm.`Panel_Code`,' = ',fpm.`Company_Name`) AS Company_Name  FROM `f_panel_master` fpm   ");
            sb.Append(" 	WHERE fpm.`CreatorDate`>='" + fromdate + "' AND fpm.`CreatorDate`<='" + todate + "' AND fpm.`ReferenceCodeOPD`<>fpm.`Panel_ID` ) t1   ");
            sb.Append(" 	LEFT JOIN (SELECT DAY(lt.date) DAY,ROUND(SUM( lt.`NetAmount` ),0) netamount, fpm.InvoiceTo `invoicepanelid` FROM f_ledgertransaction lt   ");
            sb.Append(" 	INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` INNER JOIN patient_labInvestigation_OPD plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`   	   ");
            sb.Append(" 	WHERE  lt.IsCancel = 0 /* AND plo.IsSampleCollected='Y' */    ");
            sb.Append(" 	AND lt.DATE >= '" + fromdate + "' AND  lt.DATE <= '" + todate + "' GROUP BY lt.`Panel_ID`,DAY(lt.`Date`)) t2   ");
            sb.Append(" 	ON t2.invoicepanelid=t1.Panel_ID ORDER BY t1.Company_Name,t2.Day  ");


            DataTable dtme = StockReports.GetDataTable(sb.ToString());
            if (dtme.Rows.Count > 0)
            {
                DataTable dt = changedatatablePCCdetail(dtme, "PCC");

                lblMsg.Text = "";
                grd.DataSource = dt;
                grd.DataBind();
                try
                {
                    int i = 0;
                    int j = 0;
                    int sum = 0;
                    for (i = 1; i <= dt.Columns.Count - 1; i++)
                    {
                        for (j = 0; j <= dt.Rows.Count - 1; j++)
                        {
                            sum += Util.GetInt(dt.Rows[j][i].ToString());
                        }
                        grd.FooterRow.Cells[0].Text = "Total";
                        grd.FooterRow.Cells[i].Text = sum.ToString();
                        sum = 0;
                    }
                }
                catch
                {
                }
            }
            else
            {
                grd.DataSource = "";
                grd.DataBind();
                lblMsg.Text = "No Record Found..!";
                return;
            }


        }
        else if (rd.SelectedValue == "3")
        {
            sb = new StringBuilder();

            sb.Append("  SELECT fpm3.`Company_Name` AS RateType, DAY(lt.date) DAY,ROUND(SUM( lt.`NetAmount` ),0) netamount FROM f_ledgertransaction lt     ");
            sb.Append("  INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID`     ");
            sb.Append("  INNER JOIN f_panel_master fpm2 ON fpm2.`Panel_ID`=fpm.`invoiceTo`   ");
            sb.Append("  INNER JOIN `f_panel_master` fpm3 ON fpm3.`Panel_ID`=fpm2.`ReferenceCodeOPD`      ");
            sb.Append(" INNER JOIN Patient_labInvestigation_OPD plo ON plo.LedgertransactionId=lt.`LedgerTransactionID` ");
            sb.Append("  WHERE  lt.IsCancel = 0  /* AND plo.IsSampleCollected='Y' */   ");
            sb.Append("  AND lt.DATE >= '" + fromdate + "' AND  lt.DATE <= '" + todate + "'   ");
            sb.Append("  GROUP BY fpm3.`Panel_ID`,DAY(lt.`Date`) ORDER BY fpm3.`Company_Name`  ");


            DataTable dtme = StockReports.GetDataTable(sb.ToString());
            if (dtme.Rows.Count > 0)
            {
                DataTable dt = CrossTabDatatable(dtme, "RateType");

                lblMsg.Text = "";
                grd.DataSource = dt;
                grd.DataBind();
                try
                {
                    int i = 0;
                    int j = 0;
                    int sum = 0;
                    for (i = 1; i <= dt.Columns.Count - 1; i++)
                    {
                        for (j = 0; j <= dt.Rows.Count - 1; j++)
                        {
                            sum += Util.GetInt(dt.Rows[j][i].ToString());
                        }
                        grd.FooterRow.Cells[0].Text = "Total";
                        grd.FooterRow.Cells[i].Text = sum.ToString();
                        sum = 0;
                    }
                }
                catch
                {
                }
            }
            else
            {
                grd.DataSource = "";
                grd.DataBind();
                lblMsg.Text = "No Record Found..!";
                return;
            }


        }




    }



    DataTable changedatatablepaneldetail(DataTable dt, string type)
    {
        try
        {
            DataTable dtc = new DataTable();
            dtc.Columns.Add("Department");


            DataView dv = dt.DefaultView.ToTable(true, "day").DefaultView;
            dv.Sort = "day asc";
            DataTable day = dv.ToTable();

            foreach (DataRow dw in day.Rows)
            {
                dtc.Columns.Add(dw["day"].ToString());
            }

            dtc.Columns.Add("Total");
            DataView dvmonth = dt.DefaultView.ToTable(true, "Department").DefaultView;
            dvmonth.Sort = "Department asc";
            DataTable dept = dvmonth.ToTable();



            foreach (DataRow dw in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr["Department"] = dw["Department"].ToString();



                DataRow[] dwme = dt.Select("Department='" + dw["Department"].ToString() + "'");
                int a = 0;
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["day"].ToString()] = dwm["netamount"].ToString();
                    int c = 0;
                    if (int.TryParse(dwm["netamount"].ToString(), out c))
                    {
                        a = a + c;
                    }
                }
                dwr["Total"] = a.ToString();
                dtc.Rows.Add(dwr);

            }
            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }

    }

    DataTable changedatatablepaneldetail1(DataTable dt, string type)
    {
        try
        {
            DataTable dtc = new DataTable();
            dtc.Columns.Add("TestName");


            DataView dv = dt.DefaultView.ToTable(true, "day").DefaultView;
            dv.Sort = "day asc";
            DataTable day = dv.ToTable();

            foreach (DataRow dw in day.Rows)
            {
                dtc.Columns.Add(dw["day"].ToString());
            }
            dtc.Columns.Add("Total");

            DataView dvmonth = dt.DefaultView.ToTable(true, "TestName").DefaultView;
            dvmonth.Sort = "TestName asc";
            DataTable dept = dvmonth.ToTable();



            foreach (DataRow dw in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr["TestName"] = dw["TestName"].ToString();



                DataRow[] dwme = dt.Select("TestName='" + dw["TestName"].ToString() + "'");
                int a = 0;
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["day"].ToString()] = dwm["netamount"].ToString();
                    int c = 0;
                    if (int.TryParse(dwm["netamount"].ToString(), out c))
                    {
                        a = a + c;
                    }
                }

                dtc.Rows.Add(dwr);
                dwr["Total"] = a.ToString();
            }
            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }

    }

    DataTable CrossTabDatatable(DataTable dt, string type)
    {
        try
        {
            DataTable dtc = new DataTable();
            dtc.Columns.Add(type);


            DataView dv = dt.DefaultView.ToTable(true, "day").DefaultView;
            dv.Sort = "day asc";
            DataTable day = dv.ToTable();

            foreach (DataRow dw in day.Rows)
            {
                dtc.Columns.Add(dw["day"].ToString());
            }
            dtc.Columns.Add("Total");

            DataView dvmonth = dt.DefaultView.ToTable(true, type).DefaultView;
            dvmonth.Sort = type + " asc";
            DataTable dept = dvmonth.ToTable();



            foreach (DataRow dw in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr[type] = dw[type].ToString();



                DataRow[] dwme = dt.Select(type + "='" + dw[type].ToString() + "'");
                int a = 0;
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["day"].ToString()] = dwm["netamount"].ToString();
                    int c = 0;
                    if (int.TryParse(dwm["netamount"].ToString(), out c))
                    {
                        a = a + c;
                    }
                }

                dtc.Rows.Add(dwr);
                dwr["Total"] = a.ToString();
            }
            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }

    }

    DataTable changedatatablePCCdetail(DataTable dt, string type)
    {
        try
        {
            DataTable dtc = new DataTable();
            dtc.Columns.Add("PCC");


            DataView dv = dt.DefaultView.ToTable(true, "day").DefaultView;
            dv.Sort = "day asc";
            DataTable day = dv.ToTable();

            foreach (DataRow dw in day.Rows)
            {
                dtc.Columns.Add(dw["day"].ToString());
            }

            dtc.Columns.Add("Total");
            DataView dvmonth = dt.DefaultView.ToTable(true, "PCC").DefaultView;
            dvmonth.Sort = "PCC asc";
            DataTable dept = dvmonth.ToTable();



            foreach (DataRow dw in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr["PCC"] = dw["PCC"].ToString();



                DataRow[] dwme = dt.Select("PCC='" + dw["PCC"].ToString() + "'");
                int a = 0;
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["day"].ToString()] = dwm["netamount"].ToString();
                    int c = 0;
                    if (int.TryParse(dwm["netamount"].ToString(), out c))
                    {
                        a = a + c;
                    }
                }
                dwr["Total"] = a.ToString();
                dtc.Rows.Add(dwr);

            }
            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }

    }



    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (grd.Rows.Count == 0)
        {
            lblMsg.Text = "No Data To Export..!";
            return;

        }
        //string filename = "DoctorShare" + ".xls";
        Response.ClearContent();
        if (rd.SelectedValue == "0")
        {
            Response.AddHeader("content-disposition", "attachment; filename=SalesDeptDayWise.xls");
        }
        else
        {
            Response.AddHeader("content-disposition", "attachment; filename=SalesTestDayWise.xls");
        }

        Response.ContentType = "application/excel";
        StringWriter sw = new StringWriter();
        HtmlTextWriter htw = new HtmlTextWriter(sw);
        grd.RenderControl(htw);
        //grdallshare.RenderControl(htw);
        string style = @"<style> td { mso-number-format:\@;} </style>";
        // Response.Write(style);
        Response.Write(sw.ToString());
        Response.End();
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
           server control at run time. */
    }
    protected void rd_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        grd.DataSource = "";
        grd.DataBind();
        if ((rd.SelectedValue == "0") || (rd.SelectedValue == "2"))
        {
            lblMsg.Text = "";
            mytr.Visible = false;
        }
        else if (rd.SelectedValue == "1")
        {
            mytr.Visible = true;
        }
    }
}