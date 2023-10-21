using ClosedXML.Excel;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Common_ExportToExcelReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form.Count > 0)
        {

            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                NameValueCollection nvc = Request.Form;
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    List<string> keys = Request.Form.AllKeys.ToList();

                    Dictionary<string[], string[]> inParameter = new Dictionary<string[], string[]>();
                    List<string> listJoin = new List<string>();
                    for (int i = 0; i < keys.Count; i++)
                    {
                        List<String> split = keys[i].Split(new Char[] { '#' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                        if (split.Count > 1)
                        {
                            if (split[1] == "1")
                            {
                                string[] itemTags = Common.DecryptRijndael(Request.Form[keys[i]]).Split(',');
                                string[] itemNames = itemTags.Select((s, j) => string.Concat("@tag", i, "_") + j).ToArray();
                                string itemClause = string.Join(", ", itemNames);
                                inParameter.Add(itemTags, itemNames);
                                listJoin.Add(string.Join(",", itemClause));
                            }
                        }
                    }
                    string Query = Common.DecryptRijndael(Request.Form["Query"]);
                    if (inParameter.Count > 0)
                    {
                        Query = string.Format(Query, listJoin.ToArray());
                    }
                    using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
                    {
                        for (int i = 0; i < keys.Count; i++)
                        {
                            List<String> split = keys[i].Split(new Char[] { '#' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                            if (split.Count > 1)
                            {
                                if (split[1] == "0")
                                {
                                    da.SelectCommand.Parameters.AddWithValue(string.Format("@{0}", keys[i].Split('#')[0]), Common.DecryptRijndael(Request.Form[keys[i]]));
                                }
                                else if (split[1] == "2")
                                {
                                    da.SelectCommand.Parameters.AddWithValue(string.Format("@{0}", keys[i].Split('#')[0]), string.Format("{0}%",Common.DecryptRijndael(Request.Form[keys[i]])));                                    
                                }
                                else if (split[1] == "3")
                                {
                                    da.SelectCommand.Parameters.AddWithValue(string.Format("@{0}", keys[i].Split('#')[0]), string.Format("%{0}%", Common.DecryptRijndael(Request.Form[keys[i]])));
                                }
                            }
                        }
                        if (inParameter.Count > 0)
                        {
                            foreach (KeyValuePair<string[], string[]> Parameter in inParameter)
                            {
                                for (int t = 0; t < Parameter.Key.Length; t++)
                                {
                                    da.SelectCommand.Parameters.AddWithValue(Parameter.Value[t], Parameter.Key[t]);
                                }
                            }
                        }
                        da.Fill(dt);
                    }

                    // System.IO.File.WriteAllText(@"D:\Shat\aa.txt", "aa");

                    //  System.IO.File.WriteAllText(@"D:\Shat\aa.txt",Util.GetString( dt.Rows.Count));
                    if (dt.Rows.Count > 0)
                    {
                        string Period = string.Empty;
                        string ReportDisplayName = Common.DecryptRijndael(Request.Form["ReportDisplayName"]);
                        if (Request.Form["Period"] != null)
                        {
                            Period = Common.DecryptRijndael(Request.Form["Period"]);
                        }
                        if (Request.Form["IsAutoIncrement"] != null)
                        {
                            if (Common.DecryptRijndael(Request.Form["IsAutoIncrement"]) == "1")
                            {
                                DataTable dtIncremented = new DataTable(dt.TableName);
                                DataColumn dc = new DataColumn("ID");
                                dc.AutoIncrement = true;
                                dc.AutoIncrementSeed = 1;
                                dc.AutoIncrementStep = 1;
                                dc.DataType = System.Type.GetType("System.Int32");
                                dtIncremented.Columns.Add(dc);
                                dtIncremented.BeginLoadData();
                                DataTableReader dtReader = new DataTableReader(dt);
                                dtIncremented.Load(dtReader);
                                dtIncremented.EndLoadData();
                                dtIncremented.AcceptChanges();
                            }
                        }
                        BindData(dt, ReportDisplayName, Period);
                    }
                    else
                    {
                        lblmsg.Text = "No Record Found";
                    }
                    keys.Clear();
                    inParameter.Clear();
                    listJoin.Clear();
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
        }
    }

    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        using (MemoryStream fs = new MemoryStream())
        {
            excelWorkbook.SaveAs(fs);
            fs.Position = 0;
            return fs;
        }
    }

    protected void BindData(DataTable dt, String ReportDisplayName, string Period)
    {
        lblmsg.Text = string.Empty;
        try
        {
            dt.TableName = "data";
            using (var wb = new XLWorkbook())
            {
                string WorksheetName = ReportDisplayName.ToString().Length > 30 ? ReportDisplayName.Substring(0, 30) : ReportDisplayName.ToString();
                var ws = wb.Worksheets.Add(WorksheetName);
                ws.Cell(1, 4).Style.Font.Bold = true;
                ws.Cell(1, 4).InsertData(new System.Collections.Generic.List<string[]> { new string[] { ReportDisplayName } });
                if (Period != string.Empty)
                {
                    ws.Cell(2, 4).Style.Font.Bold = true;
                    ws.Cell(2, 4).InsertData(new System.Collections.Generic.List<string[]> { new string[] { string.Concat(Period, " (Print Date Time : ", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), ")") } });
                    ws.Cell(3, 1).InsertTable(dt);
                }
                else
                {
                    ws.Cell(3, 1).InsertTable(dt);
                }

                using (MemoryStream stream = GetStream(wb))
                {
                    string attachment = "attachment; filename=" + WorksheetName.ToString() + ".xlsx";
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.BinaryWrite(stream.ToArray());
                    stream.Close();
                    stream.Dispose();
                    // Response.End();
                    Response.Flush();
                    // Response.Clear();
                    HttpContext.Current.Response.SuppressContent = true;
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
        finally
        {
            Request.Form.Clear();
        }
    }

}