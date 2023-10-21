using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System;
using System.Data;
using System.Text;
using System.Web;

public partial class Design_Lab_DeltacheckNew : System.Web.UI.Page
{
    private DataTable dtDepartment = new DataTable();

    private DataTable dt;

    public string PID = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // PID = StockReports.ExecuteScalar("select patient_id from f_ledgertransaction where LedgerTransactionNo='" + Util.GetString(Request.QueryString["LedgerTransactionNo"]) + "'  ");

            loadotherata();
        }
    }

    private DataTable GetDistinctRecords(DataTable dt, string[] Columns)
    {
        DataTable dtUniqRecords = new DataTable();
        dtUniqRecords = dt.DefaultView.ToTable(true, Columns);
        return dtUniqRecords;
    }

    public void bind_Dep()
    {
        string[] TobeDistinct = { "DEPARTMENT", "PARAM_NAME" };
        DataTable dtSet = GetDistinctRecords(dt, TobeDistinct);
        //DataTable dttem = dt;

        int aa = 0;

        foreach (DataRow dr in dtSet.Rows)
        {
            //sb.Append("   SELECT    TST_DATE,TST_TIME,LAB_NO,  ");
            //sb.Append(" LIS_NO,  IPD_NO,OPD_NO, pm.Title PATTITLE,   ");
            dtDepartment.Rows.Add(dt.Rows[aa]["TST_DATE"].ToString(), dt.Rows[aa]["TST_TIME"].ToString().TrimStart(' ').Trim(), dt.Rows[aa]["LAB_NO"].ToString(), dt.Rows[aa]["LIS_NO"].ToString(), dt.Rows[aa]["IPD_NO"].ToString(), dt.Rows[aa]["OPD_NO"].ToString(), dt.Rows[aa]["PATTITLE"].ToString(), dt.Rows[aa]["PATIENT_NAME"].ToString(), dt.Rows[aa]["AGE"].ToString(), dr["DEPARTMENT"].ToString(), dr["PARAM_NAME"].ToString(), "", dt.Rows[aa]["DOCTOR"].ToString());

            //sb.Append("   PARAM_NAME,   ");
            //sb.Append("  plo.Value , CONCAT(dm.Title,' ',dm.Name) DOCTOR   ");

            //dtDepartment.Rows.Add(dr["TST_DATE"], dr["TST_TIME"].ToString().TrimStart(' ').Trim(), dr["LAB_NO"].ToString(), dr["LIS_NO"].ToString(), dr["IPD_NO"].ToString(), dr["OPD_NO"].ToString(), dr["PATTITLE"].ToString(), dr["PATIENT_NAME"].ToString(), dr["AGE"].ToString(), dr["DEPARTMENT"].ToString(), dr["PARAM_NAME"].ToString(), "", dr["DOCTOR"].ToString());
            //    dtDepartment.Rows.Add(dt.Rows[aa]["TST_DATE"].ToString(), dr["TST_TIME"].ToString().TrimStart(' ').Trim(), dr["LAB_NO"].ToString(), dr["LIS_NO"].ToString(), dr["IPD_NO"].ToString(), dr["OPD_NO"].ToString(), dr["PATTITLE"].ToString(), dr["PATIENT_NAME"].ToString(), dr["AGE"].ToString(), dr["DEPARTMENT"].ToString(), dr["PARAM_NAME"].ToString(), "", dr["DOCTOR"].ToString());
            //  dt.Rows.Add(a, b, c, d);
            aa++;
        }
        dtDepartment.Columns.Add("P1");
        dtDepartment.Columns.Add("P2");
        dtDepartment.Columns.Add("P3");
        dtDepartment.Columns.Add("P4");
        dtDepartment.Columns.Add("P5");
        dtDepartment.Columns.Add("P6");
        dtDepartment.Columns.Add("P7");
        dtDepartment.Columns.Add("P8");
        dtDepartment.Columns.Add("P9");
        dtDepartment.Columns.Add("P10");
        dtDepartment.Columns.Add("P11");
        dtDepartment.AcceptChanges();
        //   DataTable T = dtDepartment;
    }

    public void loadotherata()
    {
        ReportDocument obj1 = new ReportDocument();
        System.IO.Stream oStream = null;
        try
        {
            PID = StockReports.ExecuteScalar("select patient_id from f_ledgertransaction where LedgerTransactionNo='" + Util.GetString(Request.QueryString["LedgerTransactionNo"]) + "'  ");

            StringBuilder sb = new StringBuilder();
            /*        sb.Append(" SELECT GROUP_CONCAT(plo.Test_Id) Test_Id FROM f_ledgertransaction lt ");
                    sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.LedgertransactionId=plo.LedgertransactionId  ");
                    sb.Append(" WHERE lt.Patient_Id='"+PID+"' GROUP BY lt.Patient_Id ");

                    string testid = StockReports.ExecuteScalar(sb.ToString()); //Util.GetString(Request.QueryString["Test_ID"]);
                    testid = "'" + testid + "'";
                    testid = testid.Replace(",", "','");
            */

            sb = new StringBuilder();
            sb.Append("   SELECT    DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%y %h:%i:%s') as TST_DATE, DATE_FORMAT(plo.ResultDateTime,'%h:%i:%s')  AS TST_TIME, pli.LedgerTransactionNo AS LAB_NO,  ");
            sb.Append("  pli.SlideNumber LIS_NO, '' IPD_NO,REPLACE(pli.Patient_ID,'LSHHI','') OPD_NO, pm.Title PATTITLE,   ");
            sb.Append("  pm.Pname PATIENT_NAME, pm.Age AS AGE, replace(otm.Name,' ','') DEPARTMENT,   ");
            sb.Append("   REPLACE(plo.LabObservationName,' ','') PARAM_NAME,   ");
            sb.Append("  plo.Value , '' DOCTOR   ");
            sb.Append("   FROM patient_labobservation_opd plo INNER JOIN patient_labinvestigation_opd pli ON plo.test_ID=pli.Test_ID  ");

            sb.Append("  AND pli.Patient_ID='" + PID + "' AND pli.Approved=1 inner JOIN investigation_master im ON im.investigation_ID=pli.investigation_id   ");
            sb.Append("  INNER JOIN investigation_observationtype iot ON iot.investigation_ID=im.investigation_ID ");
            sb.Append("  INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_ID ");
            sb.Append("  INNER JOIN patient_master pm ON pm.Patient_ID=pli.Patient_ID  and plo.Value<>'HEAD'  order by plo.ResultDateTime");
            dt = new DataTable();

            dt = StockReports.GetDataTable(sb.ToString());
            dtDepartment = dt.Clone();

            bind_Dep();

            //dtDepartment

            string DATE = "";
            int ii = 0;
            DataTable dtColumn = new DataTable();
            dtColumn.Columns.Add("Field");
            dtColumn.Columns.Add("value");
            dtColumn.AcceptChanges();
            for (int a = 0; a <= dt.Rows.Count - 1; a++)
            {
                if (string.IsNullOrEmpty(DATE) || DATE != dt.Rows[a]["TST_DATE"].ToString())
                {
                    DATE = dt.Rows[a]["TST_DATE"].ToString();
                    ii++;
                } DataRow[] result = dt.Select(" DEPARTMENT='" + dt.Rows[a]["DEPARTMENT"].ToString() + "' and TST_DATE='" + dt.Rows[a]["TST_DATE"].ToString() + "'  AND PARAM_NAME='" + dt.Rows[a]["PARAM_NAME"].ToString() + "' ");

                DataRow[] Department = dtDepartment.Select(" DEPARTMENT='" + dt.Rows[a]["DEPARTMENT"].ToString() + "'  AND PARAM_NAME='" + dt.Rows[a]["PARAM_NAME"].ToString() + "' ");

                string val = "";
                if (Department.Length != 0)
                    foreach (DataRow row in result)
                    {
                        val = "P" + ii;
                        string param = "P0";
                        param = param + ii;
                        if (dtDepartment.Columns.Contains(val))
                        {
                            //  dtDepartment.Columns[val].ColumnName = DATE;
                            Department[0][val] = row["value"];
                            dtColumn.Rows.Add(param, DATE);
                        }
                    }
            }

            DataTable dtnew = dtDepartment;
            DataTable PIVOT = new DataTable();
            PIVOT = dt.Clone();
            DataSet DS_Rep_At_a_Glance = new DataSet();

            string[] TobeDistinct = { "Field", "value" };
            DataTable dtSet = GetDistinctRecords(dtColumn, TobeDistinct);

            DS_Rep_At_a_Glance.Tables.Add(dtDepartment.Copy());
            DS_Rep_At_a_Glance.Tables[0].TableName = "PIVOT";

            DataTable Centre = new DataTable();

            //  DS_Rep_At_a_Glance.WriteXml(@"D:\ALOK.xml");

            obj1.Load(Server.MapPath(@"~\Reports\Deltacheckreport.rpt"));
            obj1.SetDataSource(DS_Rep_At_a_Glance);

            CrystalReportViewer1.ReportSource = obj1;
            CrystalReportViewer1.RefreshReport();

            string str = "P0";
            if (dtSet.Rows.Count < 20)
            {
                for (int io = dtSet.Rows.Count + 1; io <= 20; io++)
                {
                    str = "P0";
                    if (io > 9)
                    {
                        str = "P";
                    }
                    str = str + io;
                    dtSet.Rows.Add(str, str);
                }
            }
            ParameterFieldDefinitions crParameterFieldDefinitions;
            ParameterFieldDefinition crParameterFieldDefinition;
            ParameterValues crParameterValues = new ParameterValues();
            ParameterDiscreteValue crParameterDiscreteValue = new ParameterDiscreteValue();

            DataRow[] rowList = dtSet.Select();
            foreach (DataRow dr in rowList)
            {
                if (dr["Field"].ToString() == "P010")
                {
                    dr["Field"] = "P10";
                }
                else if (dr["Field"].ToString() == "P011")
                {
                    dr["Field"] = "P11";
                }
                else if (dr["Field"].ToString() == "P012")
                {
                    dr["Field"] = "P12";
                }
                else if (dr["Field"].ToString() == "P013")
                {
                    dr["Field"] = "P13";
                }
                else if (dr["Field"].ToString() == "P014")
                {
                    dr["Field"] = "P14";
                }
                else if (dr["Field"].ToString() == "P015")
                {
                    dr["Field"] = "P15";
                }
                else if (dr["Field"].ToString() == "P016")
                {
                    dr["Field"] = "P16";
                }
                else if (dr["Field"].ToString() == "P017")
                {
                    dr["Field"] = "P17";
                }
                else if (dr["Field"].ToString() == "P018")
                {
                    dr["Field"] = "P18";
                }
                else if (dr["Field"].ToString() == "P019")
                {
                    dr["Field"] = "P19";
                }
                else if (dr["Field"].ToString() == "P020")
                {
                    dr["Field"] = "P20";
                }
            }

            int iii = 0;
            foreach (DataRow dra in dtSet.Rows)
            {
                //if (iii == 2)
                //    return;
                //iii++;
                //  crParameterDiscreteValue = new ParameterDiscreteValue();

                crParameterDiscreteValue.Value = dra["value"];
                crParameterFieldDefinitions = obj1.DataDefinition.ParameterFields;
                crParameterFieldDefinition = crParameterFieldDefinitions[dra["field"].ToString()];
                crParameterValues = crParameterFieldDefinition.CurrentValues;
                crParameterValues.Clear();
                crParameterValues.Add(crParameterDiscreteValue);
                crParameterFieldDefinition.ApplyCurrentValues(crParameterValues);

                //crParameterDiscreteValue.Value = dtSet.Rows[1]["value"];
                //crParameterFieldDefinitions = obj1.DataDefinition.ParameterFields;
                //crParameterFieldDefinition = crParameterFieldDefinitions["P02"];
                //crParameterValues = crParameterFieldDefinition.CurrentValues;

                //crParameterDiscreteValue.Value = dtSet.Rows[2]["value"];
                //crParameterFieldDefinitions = obj1.DataDefinition.ParameterFields;
                //crParameterFieldDefinition = crParameterFieldDefinitions["P03"];
                //crParameterValues = crParameterFieldDefinition.CurrentValues;
            }

            this.CrystalReportViewer1.DataBind();

            byte[] byteArray = null;
            oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
            byteArray = new byte[oStream.Length];
            oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
            Response.ClearContent();
            Response.ClearHeaders();
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(byteArray);
            Response.Flush();
            Response.Clear();
            HttpContext.Current.Response.SuppressContent = true;
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            obj1.Close();
            obj1.Dispose();
            oStream.Close();
            oStream.Dispose();
        }
    }
}