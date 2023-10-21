using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Reports_LabReport_TATGraph : System.Web.UI.Page
{
   
    public string headding1 = "";
    public string headding2 = "";
    public string headding3 = "";
    public string Period = "";
    public string ReportName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           

            StringBuilder sbdata = new StringBuilder();

            StringBuilder sb = new StringBuilder();
       
            DataTable dtdeptwise = getdepatwisedt();
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                dtdeptwise = ((DataTable)Session["TATGraph"]);
                if (dtdeptwise.Rows.Count > 0)
                {

                    Period = dtdeptwise.Rows[0]["Period"].ToString();

                    div_contain.Style.Add("display", "block");

                    if (dtdeptwise.Rows[0]["Investigation"].ToString().Length == 0)
                    {
                        ReportName = "Department Wise TAT Report";
                        sbdata = new StringBuilder();
                        sbdata.Append("  <table style='text-align:center; font-size:13px;  width:100%; height:100%; '> ");
                        sbdata.Append("    <tr > ");
                        sbdata.Append("    <td colspan='5' > ");
                        sbdata.AppendFormat("<b style='font-size:20px'>{0}</b>" ,ReportName );
                        sbdata.Append("</td> ");
                        sbdata.Append("</tr> ");

                        sbdata.Append("<tr><td colspan='5'><b>Period " + dtdeptwise.Rows[0]["Period"] + "</td> </tr> ");
                        sbdata.Append("<tr> <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>Department</td> <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>TATInTime</b></td> <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>TATBeyondTime</b></td>  <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>MasterNotDefined</b></td> <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>TotalTest</b></td> </tr> ");

                        for (int i = 0; i < dtdeptwise.Rows.Count; i++)
                        {
                            sbdata.Append("  <tr> ");
                            sbdata.AppendFormat(" <td>{0}</td>" , dtdeptwise.Rows[i]["Department"].ToString());
                            sbdata.AppendFormat(" <td>{0}</td>" , dtdeptwise.Rows[i]["TATInTime"].ToString());
                            sbdata.AppendFormat(" <td>{0}</td>" , dtdeptwise.Rows[i]["TATBeyondTime"].ToString());
                            sbdata.AppendFormat(" <td>{0}</td>" , dtdeptwise.Rows[i]["MasterNotDefined"].ToString());
                            sbdata.AppendFormat("  <td>{0}</td>", dtdeptwise.Rows[i]["TotalTest"].ToString());
                            sbdata.Append(" </tr> ");
                        }

                        sbdata.Append("  <tr> ");
                        sbdata.AppendFormat("<td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", "Total:");
                        sbdata.AppendFormat(" <td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", dtdeptwise.AsEnumerable().Sum(x => x.Field<int>("TATInTime")));
                        sbdata.AppendFormat(" <td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", dtdeptwise.AsEnumerable().Sum(x => x.Field<int>("TATBeyondTime")));
                        sbdata.AppendFormat(" <td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", dtdeptwise.AsEnumerable().Sum(x => x.Field<int>("MasterNotDefined")));
                        sbdata.AppendFormat("  <td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", dtdeptwise.AsEnumerable().Sum(x => x.Field<int>("TotalTest")));
                        sbdata.AppendFormat(" </tr> ");
                        sbdata.Append(" </table> ");
                      
                    }
                    else
                    {
                        ReportName = "Test Wise TAT Report";
                        sbdata = new StringBuilder();
                        sbdata.Append("<table style='text-align:center;font-size:13px;   width:100%; height:100%; '> ");
                        sbdata.Append("<tr > ");
                        sbdata.Append("<td colspan='6' > ");
                        sbdata.AppendFormat("<b style='font-size:20px'>{0}</b>", ReportName);

                        sbdata.Append("</td> ");

                        sbdata.Append("</tr> ");

                        sbdata.Append("<tr><td colspan='6'><b>Period " + dtdeptwise.Rows[0]["Period"] + "</td> </tr> ");
                        sbdata.Append("<tr> <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>Department</td><td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>Investigation</td> <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>TATInTime</b></td> <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>TATBeyondTime</b></td>  <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>MasterNotDefined</b></td> <td style='border-bottom: 1px solid;border-top: 1px solid;' class='auto-style1'><b>TotalTest</b></td> </tr> ");

                        for (int i = 0; i < dtdeptwise.Rows.Count; i++)
                        {
                            sbdata.Append("  <tr> ");
                            sbdata.AppendFormat(" <td>{0}</td>", dtdeptwise.Rows[i]["Department"].ToString());
                            sbdata.AppendFormat(" <td>{0}</td>" , dtdeptwise.Rows[i]["Investigation"].ToString());
                            sbdata.AppendFormat(" <td>{0}</td>", dtdeptwise.Rows[i]["TATInTime"].ToString());
                            sbdata.AppendFormat(" <td>{0}</td>", dtdeptwise.Rows[i]["TATBeyondTime"].ToString());
                            sbdata.AppendFormat(" <td>{0}</td>", dtdeptwise.Rows[i]["MasterNotDefined"].ToString());
                            sbdata.AppendFormat("  <td>{0}</td>", dtdeptwise.Rows[i]["TotalTest"].ToString());
                            sbdata.Append(" </tr> ");
                        }

                        sbdata.Append("  <tr> ");
                        sbdata.AppendFormat("<td colspan='2' style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", "Total:");
                        sbdata.AppendFormat(" <td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", dtdeptwise.AsEnumerable().Sum(x => x.Field<int>("TATInTime")));
                        sbdata.AppendFormat(" <td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", dtdeptwise.AsEnumerable().Sum(x => x.Field<int>("TATBeyondTime")));
                        sbdata.AppendFormat(" <td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", dtdeptwise.AsEnumerable().Sum(x => x.Field<int>("MasterNotDefined")));
                        sbdata.AppendFormat("  <td style='border-bottom: 1px solid;border-top: 1px solid;'>{0}</td>", dtdeptwise.AsEnumerable().Sum(x => x.Field<int>("TotalTest")));
                        sbdata.AppendFormat(" </tr> ");
                        sbdata.Append(" </table> ");
                    }

                    headding1 = Util.GetString(dtdeptwise.Compute("Sum(TATInTime)", string.Empty));
                    headding2 = Util.GetString(dtdeptwise.Compute("Sum(TATBeyondTime)", string.Empty));
                    headding3 = Util.GetString(dtdeptwise.Compute("Sum(MasterNotDefined)", string.Empty));
                }
                else
                {
                    div_contain.Style.Add("display", "none");
                }
                divData.InnerHtml = sbdata.ToString();

            }
            catch (Exception ex)
            {
            }
            finally
            {
                Session["TATGraph"] = "";
                Session.Remove("TATGraph");
            }
        }

    }
   
    public DataTable getdepatwisedt()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Department");
        dt.Columns.Add("TATInTime");
        dt.Columns.Add("TATBeyondTime");
        dt.Columns.Add("MasterNotDefined");
        dt.Columns.Add("TotalTest");

        return dt;
    }
  
}