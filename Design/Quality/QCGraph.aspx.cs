using System;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using HiQPdf;
using System.Web;
using System.Drawing.Drawing2D;
using MySql.Data.MySqlClient;

public partial class Design_Quality_QCGraph : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;
    DataTable dtObs;

    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 850;
    int BrowserWidth = 1100;

    float FooterHeight = 40;
    

    DataRow drcurrent;

    public string SigBase64 = "";
    float ones_neg = 230f;
    float ones_pos = 118f;

    float twos_neg = 296f;
    float twos_pos = 56f;


    float threes_neg = 355f;
    float threes_pos = 0f;

    float meanvalue = 177f;
  
    protected void Page_Load(object sender, EventArgs e)
    {
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = "RAwtFRQg-IggtJjYl-Nj11dGp0-ZHVkcGR9-cXNkd3Vq-dXZqfX19-fQ==";
          try
        {


            StringBuilder sb = new StringBuilder();
            string levelid=Common.Decrypt(Util.GetString(Request.QueryString["levelid"]));
            if (levelid == "" || levelid=="0")
            {
                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" SELECT group_concat(DISTINCT levelid order by levelid)  FROM qc_control_centre_mapping ");
                sb1.Append(" WHERE centreid=" + Common.Decrypt(Util.GetString(Request.QueryString["labid"])) + " ");
                sb1.Append(" AND controlid='" + Common.Decrypt(Util.GetString(Request.QueryString["controlid"])) + "'  ");
                sb1.Append(" and  LabObservation_ID=" +  Common.Decrypt(Util.GetString(Request.QueryString["parameterid"])) + "");
             
                levelid=StockReports.ExecuteScalar(sb1.ToString());

            }
           
            foreach (string level in levelid.Split(','))
            {
                BindData(Common.Decrypt(Util.GetString(Request.QueryString["labid"])), Common.Decrypt(Util.GetString(Request.QueryString["controlid"])), Common.Decrypt(Util.GetString(Request.QueryString["parameterid"])), level, Common.Decrypt(Util.GetString(Request.QueryString["fromdate"])), Common.Decrypt(Util.GetString(Request.QueryString["todate"])), Common.Decrypt(Util.GetString(Request.QueryString["type"])), Common.Decrypt(Util.GetString(Request.QueryString["macid"])));
              //  BindData(Common.Decrypt(Util.GetString(Request.QueryString["labid"])), Common.Decrypt(Util.GetString(Request.QueryString["controlid"])), Common.Decrypt(Util.GetString(Request.QueryString["parameterid"])), level, Common.Decrypt(Util.GetString(Request.QueryString["fromdate"])), Common.Decrypt(Util.GetString(Request.QueryString["todate"])), Common.Decrypt(Util.GetString(Request.QueryString["type"])), Common.Decrypt(Util.GetString(Request.QueryString["macid"])));

                if (dtObs.Rows.Count == 0)
                {
                    continue;
                }
                drcurrent = dtObs.Rows[0];
                sb.Append("<div style='width:1085px;page-break-inside:avoid;'>");
                sb.Append("<table style='width:1080px;border-collapse:collapse;font-family:Arial;'>");
                // Heading
                sb.Append("<tr><td colspan='2' ><br/><br/></td></tr>");
                sb.Append("<tr style='border-top:2px solid black;border-bottom:2px solid black;'>");
                //sb.Append("<td colspan='2' align='center' style='font-size:18px;font-weight:bold;'>Levey Jenning Chart based on Dr. Jems Westgard QC Rules</td>");
                sb.Append("<td colspan='2' align='center' style='font-size:18px;font-weight:bold;'>Levey Jenning Chart based on Multi QC Rules</td>");
                sb.Append("</tr>");
                // QC Data

                sb.Append("<tr>");
                sb.Append("<td style='width:60%' valign='top'>");
                sb.Append("<table box='frame' rules='all' border='1' style='width:99%;border-collapse:collapse;font-family:Arial;font-size:12px;margin-top:10px;'>");
                sb.Append("<tr>");
                sb.Append("<td style='padding-left:5px;'><b>Date Range :</b></td><td style='padding-left:5px;'><b>" + Util.GetString(drcurrent["StartDate"]) + "</b></td>");
                sb.Append("<td style='padding-left:5px;'><b>Centre :</b></td><td style='padding-left:5px;'><b>" + Util.GetString(drcurrent["Centre"]) + "</b></td>");
                sb.Append("</tr>");

                sb.Append("<tr>");
                sb.Append("<td style='padding-left:5px;'><b>Department :</b></td><td style='padding-left:5px;'>" + Util.GetString(drcurrent["Subcategoryname"]) + "</td>");
                sb.Append("<td style='padding-left:5px;'><b>Parameter :</b></td><td style='padding-left:5px;'><b>" + Util.GetString(drcurrent["Parametername"]) + "</b></td>");
                sb.Append("</tr>");

                sb.Append("<tr>");
                sb.Append("<td style='padding-left:5px;'><b>Machine :</b></td><td style='padding-left:5px;'>" + Util.GetString(drcurrent["Machine_Id"]) + "</td>");
                sb.Append("<td style='padding-left:5px;'><b>Unit :</b></td><td style='padding-left:5px;'>" + Util.GetString(drcurrent["Unit"]) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Temperature :</b>" + Util.GetString(drcurrent["Temperature"]) + "</td>");
                sb.Append("</tr>");

                sb.Append("<tr>");
                sb.Append("<td style='padding-left:5px;'><b>Control :</b></td><td colspan='3' style='padding-left:5px;'><b>" + Util.GetString(drcurrent["ControlName"]) + "</b></td>");
                sb.Append("</tr>");

                sb.Append("<tr>");
                sb.Append("<td style='padding-left:5px;'><b>Lot Number :</b></td><td colspan='3' style='padding-left:5px;'><b>" + Util.GetString(drcurrent["lotnumber"]) + "</b>&nbsp;&nbsp;&nbsp;&nbsp;<b>Lot Expiry :</b>" + Util.GetString(drcurrent["LotExpiry"]) + "&nbsp;&nbsp;&nbsp;&nbsp;<b>Level :" + Util.GetString(drcurrent["Level"]) + "</b></td>");
                sb.Append("</tr>");
                sb.Append("</table>");
                sb.Append("</td>");

                sb.Append("<td style='width:40%' valign='top'>");
                sb.Append("<table box='frame' rules='all' border='1' style='width:99%;border-collapse:collapse;font-family:Arial;font-size:11px;margin-top:10px;'>");
                sb.Append("<tr>");
                sb.Append("<td style='width:15%;font-weight:bold;padding-left:5px;'>Min Value</td>");
                sb.Append("<td style='width:15%;font-weight:bold;padding-left:5px;'>Max Value</td>");

                if (Common.Decrypt(Util.GetString(Request.QueryString["type"])) == "0")
                {
                    sb.Append("<td style='width:25%;font-weight:bold;padding-left:5px;'>Base Mean Value</td>");


                }
                else
                {
                    sb.Append("<td style='width:25%;font-weight:bold;padding-left:5px;'>Record Mean Value</td>");
                }

               
                sb.Append("<td style='width:25%;font-weight:bold;padding-left:5px;'>Base SD Value</td>");
                sb.Append("<td style='width:20%;font-weight:bold;padding-left:5px;'>Base CV(%)</td>");
                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td style='width:15%;padding-left:5px;'>" + Util.GetString(drcurrent["minvalue"]) + "</td>");
                sb.Append("<td style='width:15%;padding-left:5px;'>" + Util.GetString(drcurrent["maxvalue"]) + "</td>");
                sb.Append("<td style='width:25%;padding-left:5px;'>" + Util.GetString(drcurrent["BaseMeanvalue"]) + "</td>");
                sb.Append("<td style='width:25%;padding-left:5px;'>" + Util.GetString(drcurrent["BaseSDvalue"]) + "</td>");
                sb.Append("<td style='width:20%;padding-left:5px;'>" + Util.GetString(drcurrent["BaseCVPercentage"]) + "</td>");
                sb.Append("</tr>");
                sb.Append("</table>");

                sb.Append("<span style='font-size:12px;'><b>SD Range :<b></span>");

                sb.Append("<table box='frame' rules='all' border='1' style='width:99%;border-collapse:collapse;font-family:Arial;font-size:11px;margin-top:3px;'>");
                sb.Append("<tr>");
                sb.Append("<td style='width:14%;font-weight:bold;padding-left:5px;'>3s (-)</td>");
                sb.Append("<td style='width:14%;font-weight:bold;padding-left:5px;'>2s (-)</td>");
                sb.Append("<td style='width:14%;font-weight:bold;padding-left:5px;'>1s (-)</td>");
                sb.Append("<td style='width:16%;font-weight:bold;padding-left:5px;'>Mean</td>");
                sb.Append("<td style='width:14%;font-weight:bold;padding-left:5px;'>1s (+)</td>");
                sb.Append("<td style='width:14%;font-weight:bold;padding-left:5px;'>2s (+)</td>");
                sb.Append("<td style='width:14%;font-weight:bold;padding-left:5px;'>3s (+)</td>");

                sb.Append("</tr>");
                sb.Append("<tr>");
                sb.Append("<td style='width:14%;padding-left:5px;'>" + Util.GetString(drcurrent["SD3_Neg"]) + "</td>");
                sb.Append("<td style='width:14%;padding-left:5px;'>" + Util.GetString(drcurrent["SD2_Neg"]) + "</td>");
                sb.Append("<td style='width:14%;padding-left:5px;'>" + Util.GetString(drcurrent["SD1_Neg"]) + "</td>");
                sb.Append("<td style='width:16%;padding-left:5px;'>" + Util.GetString(drcurrent["BaseMeanvalue"]) + "</td>");
                sb.Append("<td style='width:14%;padding-left:5px;'>" + Util.GetString(drcurrent["SD1_Pos"]) + "</td>");
                sb.Append("<td style='width:14%;padding-left:5px;'>" + Util.GetString(drcurrent["SD2_Pos"]) + "</td>");
                sb.Append("<td style='width:14%;padding-left:5px;'>" + Util.GetString(drcurrent["SD3_Pos"]) + "</td>");
                sb.Append("</tr>");
                sb.Append("</table>");




                sb.Append("</td>");

                sb.Append("</tr>");

                sb.Append("<tr style='border-bottom:2px solid black;'>");
                if (Common.Decrypt(Util.GetString(Request.QueryString["type"])) == "0")
                {
                    sb.Append("<td  align='center'>Base Mean Report</td>");

                   
                }
                else
                {
                    sb.Append("<td  align='center'>Record Mean Report</td>");
                }
                sb.Append("<td><table><tr>");
                sb.Append("<td><span style=' height: 15px;width: 15px;background-color:black;border-radius: 50%;display: inline-block;'></span></td><td>&nbsp;&nbsp;Pass&nbsp;&nbsp;</td>");
                sb.Append("<td><span style=' height: 15px;width: 15px;background-color:blue;border-radius: 50%;display: inline-block;'></span></td><td>&nbsp;&nbsp;Warn&nbsp;&nbsp;</td>");
                sb.Append("<td><span style=' height: 15px;width: 15px;background-color:red;border-radius: 50%;display: inline-block;'></span></td><td>&nbsp;&nbsp;Fail&nbsp;&nbsp;</td>");
                sb.Append("</tr></table></td>");
                sb.Append("</tr>");



                sb.Append("<tr>");
                sb.Append("<td colspan='2' ><br/></td>");
                sb.Append("</tr>");

                // Chart

                string graphdata = creategraphdata(dtObs);
                sb.Append("<tr>");
                sb.Append("<td  colspan='2' style='padding:5px;vertical-align:top;  '> ");
                sb.Append("<img src='data:image/png;base64," + graphdata + "'  /></td>");
                sb.Append("</tr>");


                sb.Append("</table>");
                sb.Append("</div>");
            }

            if (sb.ToString() == "")
            {
                sb.Append("<center><span style='font-weight:bold;font-size:40px;color:gray;'><br/><br/><br/><br/>No Data To Display  Data:" + dtObs .Rows.Count+ "</span></center>");
            }
            AddContent(sb.ToString());
           
            mergeDocument();
            byte[] pdfBuffer = document.WriteToMemory();
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
            HttpContext.Current.Response.End();
          }

          catch (Exception ex)
          {
              ClassLog objerror = new ClassLog();
              objerror.errLog(ex);
              Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> SomeThing Went Wrong . Please Refresh Page Or Contact To Admin..!<span><br/><input type='button' value='Refresh' style='cursor:pointer;font-weight:bold;' onclick='window.location.reload();'/></center>");
          }

          finally
          {
              if (document != null)
              {
                  document.Close();

              }
              if (tempDocument != null)
              {
                  tempDocument.Close();
              }
          }
    }

    private void AddContent(string Content)
    {

        //File.AppendAllText("D:\\apollo.txt", Content);
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty,PdfPageOrientation.Landscape);
        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(MarginLeft, ((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height), PageWidth, Content, null);
      


        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;

        html1.ImagesCutAllowed = false;
        html1LayoutInfo = page1.Layout(html1);
    }


   

    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {



            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, FontStyle.Bold);


            PdfLine pd = new PdfLine(new PointF(20, 2), new PointF(830, 2));


            PdfText printdatetime = new PdfText(MarginLeft, 10, "Print Date Time : " + DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;

            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }
            p.Footer.Layout(pd);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }

        tempDocument = new PdfDocument();
    }


    void BindData(string labid, string controlid, string parameterid, string levelid, string fromdate, string todate, string type,string macid)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT '" + fromdate + " - " + todate + "' StartDate ,DATE_FORMAT(qcm.LotExpiry,'%d-%b-%Y')LotExpiry,MachineName,Subcategoryname,");
            sb.Append(" if('" + type + "'=0,'Base Mean Value','Record Mean Value') ID, DATE_FORMAT(moq.dtEntry,'%d-%m %H:%i')EntryDateTime, moq.centreid, cm.Centre,moq.ControlName, ");
            sb.Append(" moq.LotNumber,moq.LabObservation_ID ParameterID,moq.Machine_Id,moq.LevelID,moq.controlid,");
            sb.Append(" moq.LabObservation_Name Parametername,moq.Level,moq.Reading,moq.labno,moq.qcstatus,moq.QCRule,");

            sb.Append(" ifnull(qcc.Minvalue,qcd.Minvalue)Minvalue,ifnull(qcc.Maxvalue,qcd.Maxvalue)`Maxvalue`,ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)BaseMeanvalue,");
            sb.Append(" ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)BaseSDvalue,ifnull(qcc.BaseCVPercentage,qcd.BaseCVPercentage)BaseCVPercentage,");

            sb.Append(" qcd.Unit,qcd.Temperature,qcd.Method, ");

           


            sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)+(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*3)) SD3_Pos,");
            sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)+(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*2)) SD2_Pos,");
            sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)+(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*1)) SD1_Pos,");

            sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)-(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*3)) SD3_Neg,");
            sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)-(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*2)) SD2_Neg,");
            sb.Append(" (ifnull(qcc.BaseMeanvalue,qcd.BaseMeanvalue)-(ifnull(qcc.BaseSDvalue,qcd.BaseSDvalue)*1)) SD1_Neg,");


            sb.Append("  DATE_FORMAT(moq.dtEntry,'%y%m%d%H%i') oldreading,ifnull(moq.UpdateReason,'')UpdateReason,ifnull(moq.UpdateBy,'')UpdateBy, ");
            sb.Append(" ifnull(DATE_FORMAT(moq.Updatedate,'%d-%b-%Y %h:%i %p'),'')updatedate ");
            sb.Append(" FROM " + Util.getApp("MachineDB") + ".mac_observation_qc moq  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=moq.centreid ");
            sb.Append(" and cm.centreid=" + labid + " ");
            sb.Append(" INNER JOIN qc_controlparameter_detail qcd ON qcd.ControlID=moq.controlid  ");
            sb.Append(" AND qcd.LabObservation_ID=moq.LabObservation_ID AND qcd.LevelID=moq.LevelID ");

            sb.Append(" INNER JOIN qc_control_centre_mapping qcc ON qcd.ControlID=qcc.controlid  ");
            sb.Append(" AND qcd.LabObservation_ID=qcc.LabObservation_ID AND qcd.LevelID=qcc.LevelID and qcc.centreid=cm.centreid ");
            sb.Append(" and qcc.machineid=moq.Machine_Id");

            sb.Append(" inner join qc_controlmaster qcm on qcm.ControlID=qcd.controlid");
            sb.Append(" and qcm.isactive=1  and qcm.LotExpiry>=current_date ");

            sb.Append(" WHERE moq.isActive=1 and ShowInQC=1 and moq.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and moq.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
            if (controlid != "")
            {
                sb.Append(" and moq.ControlID='" + controlid + "' ");
            }
            if (parameterid != "")
            {
                sb.Append(" and moq.LabObservation_ID='" + parameterid + "' ");
            }
            if (levelid != "")
            {
                sb.Append(" and moq.LevelID='" + levelid + "' ");
            }
            if (macid != "" || macid != "0")
            {
                sb.Append("and moq.Machine_Id='"+macid+"' ");
            }

            sb.Append(" order by moq.ControlName,moq.LabObservation_Name,moq.levelid,moq.dtEntry ");

           
            dtObs = MySqlHelper.ExecuteDataset(con,CommandType.Text,sb.ToString()).Tables[0];


            if (dtObs.Rows.Count > 0)
            {

                if (type == "1")
                {
                    DataColumn DC = new DataColumn("Cal_Mean");
                    DC.DefaultValue = Math.Round(Util.GetDouble(calculate_Mean(dtObs)), 2);
                    dtObs.Columns.Add(DC);

                    foreach (DataRow dr in dtObs.Rows)
                    {
                        dr["BaseMeanvalue"] = Math.Round(Util.GetDouble(dr["Cal_Mean"]), 2);
                        dr["SD3_Pos"] = Math.Round(Util.GetDouble(dr["Cal_Mean"]) + (Util.GetDouble(dr["BaseSDvalue"]) * 3), 2);
                        dr["SD3_Neg"] = Math.Round(Util.GetDouble(dr["Cal_Mean"]) - (Util.GetDouble(dr["BaseSDvalue"]) * 3), 2);
                        dr["SD2_Pos"] = Math.Round(Util.GetDouble(dr["Cal_Mean"]) + (Util.GetDouble(dr["BaseSDvalue"]) * 2), 2);
                        dr["SD2_Neg"] = Math.Round(Util.GetDouble(dr["Cal_Mean"]) - (Util.GetDouble(dr["BaseSDvalue"]) * 2), 2);
                        dr["Minvalue"] = Math.Round(Util.GetDouble(dr["SD2_Neg"]), 2);
                        dr["MaxValue"] = Math.Round(Util.GetDouble(dr["SD2_Pos"]), 2);
                        dr["SD1_Pos"] = Math.Round(Util.GetDouble(dr["Cal_Mean"]) + (Util.GetDouble(dr["BaseSDvalue"]) * 1), 2);
                        dr["SD1_Neg"] = Math.Round(Util.GetDouble(dr["Cal_Mean"]) - (Util.GetDouble(dr["BaseSDvalue"]) * 1), 2);

                        string qcresult = QualityWestGardRule.ApplyWestGardRule(Util.GetString(dr["Reading"]), Util.GetString(dr["BaseMeanvalue"]),
                            Util.GetString(dr["BaseSDvalue"]), Util.GetString(dr["BaseCVPercentage"]), dtObs,
                            Util.GetString(dr["centreid"]), Util.GetString(dr["machine_id"]),
                            Util.GetString(dr["ParameterID"]),
                            Util.GetString(dr["LevelID"]), Util.GetString(dr["controlid"]), con);

                        dr["qcstatus"] = qcresult.Split('#')[0];
                        dr["QCRule"] = qcresult.Split('#')[1];
                    }
                }

            }
        }
        catch (Exception ex)
        {

            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);


        }
        finally
        {

            con.Close();
            con.Dispose();
        }


    }

    private static string calculate_Mean(DataTable dt)
    {
        double _sd = 0;
        foreach (DataRow dr in dt.Rows)
        {
            _sd += Util.GetDouble(dr["Reading"]);
        }
        _sd = _sd / Util.GetDouble(dt.Rows.Count);

        return _sd.ToString();
    }



    string creategraphdata(DataTable dt)
    {
        string imageFilePath = "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";
        Bitmap newBitmap;

        using (var bitmap = (Bitmap)Image.FromStream(new MemoryStream(Convert.FromBase64String(imageFilePath))))//load the image file
        {
         
            Pen grayPen = new Pen(Color.Gray, 1);
            grayPen.DashStyle = DashStyle.Dot;
            using (Graphics graphics = Graphics.FromImage(bitmap))
            {
                graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
              
                using (Font arialFont = new Font("Arial", 9, FontStyle.Bold))
                {

                    graphics.DrawString(dt.Rows[0]["SD1_Neg"].ToString() + " (-1s)", arialFont, Brushes.Black, new PointF(6f, ones_neg));
                    graphics.DrawString(dt.Rows[0]["SD1_Pos"].ToString() + " (+1s)", arialFont, Brushes.Black, new PointF(6f, ones_pos));

                    graphics.DrawString(dt.Rows[0]["SD2_Neg"].ToString() + " (-2s)", arialFont, Brushes.Black, new PointF(6f, twos_neg));
                    graphics.DrawString(dt.Rows[0]["SD2_Pos"].ToString() + " (+2s)", arialFont, Brushes.Black, new PointF(6f, twos_pos));


                    graphics.DrawString(dt.Rows[0]["SD3_Neg"].ToString() + " (-3s)", arialFont, Brushes.Black, new PointF(6f, threes_neg));
                    graphics.DrawString(dt.Rows[0]["SD3_Pos"].ToString() + " (+3s)", arialFont, Brushes.Black, new PointF(6f, threes_pos));


                    graphics.DrawString(dt.Rows[0]["BaseMeanvalue"].ToString() + " (Mean)", arialFont, Brushes.Black, new PointF(6f, meanvalue));


                    graphics.DrawLine(grayPen, new PointF(80f, meanvalue+5), new PointF(1070f, meanvalue+5));



                   
                }


                
                float fromleft = 40f;
                float lastfromleft = 0f;
                int counter = 1;
                Pen redPen = new Pen(Color.Black, 1);
              
                float lastvalue = 0f;
                foreach (DataRow dw in dt.Rows)
                {

                    using (Font arialFont = new Font("Arial", 9, FontStyle.Bold))
                    {
                        System.Drawing.StringFormat drawFormat = new System.Drawing.StringFormat();
                        drawFormat.FormatFlags = StringFormatFlags.DirectionVertical;

                        graphics.DrawString(dw["Entrydatetime"].ToString(), arialFont, Brushes.Black, new PointF(fromleft + 30f, 365f), drawFormat);
                    }

                    float getValuePoint = getValuePrintXaxis(Util.GetFloat(dw["minvalue"]), Util.GetFloat(dw["maxvalue"]), Util.GetFloat(dw["reading"]));


                    if (Util.GetString(dw["qcstatus"]) == "Fail")
                    {
                        graphics.FillEllipse(new SolidBrush(System.Drawing.ColorTranslator.FromHtml("#FF0000")), fromleft + 30f, getValuePoint, 10, 10);
                        using (Font arialFont = new Font("Arial", 9))
                        {
                            graphics.DrawString(Util.GetString(dw["reading"]) + "(" + Util.GetString(dw["QCRule"]) + ")", arialFont, Brushes.Red, new PointF(fromleft + 30f, getValuePoint + 15));


                        }
                    }
                    else if (Util.GetString(dw["qcstatus"]) == "Warn")
                    {
                        graphics.FillEllipse(new SolidBrush(System.Drawing.ColorTranslator.FromHtml("#0000ff")), fromleft + 30f, getValuePoint, 10, 10);
                        using (Font arialFont = new Font("Arial", 9))
                        {
                            graphics.DrawString(Util.GetString(dw["reading"]) + "(" + Util.GetString(dw["QCRule"]) + ")", arialFont, Brushes.Blue, new PointF(fromleft + 30f, getValuePoint + 15));


                        }
                    }
                    else
                    {
                        graphics.FillEllipse(new SolidBrush(System.Drawing.ColorTranslator.FromHtml("#000000")), fromleft + 30f, getValuePoint, 10, 10);
                        using (Font arialFont = new Font("Arial", 9))
                        {
                            graphics.DrawString(Util.GetString(dw["reading"]), arialFont, Brushes.Black, new PointF(fromleft + 30f, getValuePoint + 15));


                        }
                    }
                   



                    if (counter > 1)
                    {
                        graphics.DrawLine(redPen, new PointF(lastfromleft + 38, lastvalue + 5), new PointF(fromleft + 38, getValuePoint + 5));

                    }

                    lastvalue = getValuePoint;
                    lastfromleft = fromleft;
                    fromleft = fromleft + (930/dt.Rows.Count);
                    counter++;
                }
            }
            newBitmap = new Bitmap(bitmap);
        }
        System.IO.MemoryStream ms = new MemoryStream();
        newBitmap.Save(ms, ImageFormat.Png);
        byte[] byteImage = ms.ToArray();
        SigBase64 = Convert.ToBase64String(byteImage);
        newBitmap.Dispose();

        
        return SigBase64;
    }

    private float getValuePrintXaxis(float MinValue, float MaxValue, float Value)
    {
        float Point = 0f;
        if ((Value > MinValue) && (Value < MaxValue))
        {
            Point = MaxValue - MinValue;
            Point = (twos_pos - twos_neg) / Point;
            Point = twos_neg + Point * (Value - MinValue);
           
        }
        else if (Value < MinValue)
        {

         
            Point = 330f;
           


        }
        else if (Value > MaxValue)
        {
            Point = 10f;
           
        }

        else if (Value == MinValue)
        {
           
            Point = twos_neg;

        }
        else if (Value == MaxValue)
        {          
            Point = twos_pos;

        }


        return Point;
    }
   
}