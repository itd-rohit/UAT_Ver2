using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public partial class Design_Investigation_AddInterpretation : System.Web.UI.Page
{
    public string InvestigationID = "0";
    public string observationid = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindMachine(ddlMac);
            AllLoad_Data.bindAllCentre(ddlCentre);
            if (!string.IsNullOrEmpty(Request.QueryString["TestID"]))
            {
               
                InvestigationID = StockReports.ExecuteScalar("select Investigation_ID from patient_labinvestigation_opd where Test_ID=" + Request.QueryString["TestID"] + "");
                RadioButtonList1.SelectedIndex = 1;
                mm.Visible = false;
                mm2.Visible = false;
                BindInvestigation();
                showinvsaved();
            }
            if (!string.IsNullOrEmpty(Request.QueryString["invID"]))
            {
                InvestigationID = Request.QueryString["invID"].ToString();
                RadioButtonList1.SelectedIndex = 1;
                mm.Visible = false;
                mm2.Visible = false;
                BindInvestigation();
                showinvsaved();
            }
            if (!string.IsNullOrEmpty(Request.QueryString["obsid"]))
            {
                observationid = Request.QueryString["obsid"].ToString();
                RadioButtonList1.SelectedIndex = 0;
                mm.Visible = true;
                mm2.Visible = true;
                BindObservation();
                showobssaved();
            }
            BindInvestigation();
            BindObservation();
        }
    }

    private void BindInvestigation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select CONCAT(inv.Name,' - ',inv.TestCode) as Name ,inv.Investigation_id from f_itemmaster im   ");
        sb.Append(" inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  ");
        sb.Append(" inner join f_configrelation c on c.CategoryID=sc.CategoryID ");
        sb.Append(" inner join investigation_master inv on inv.Investigation_id=im.Type_id ");
        if (InvestigationID != "0")
        {
            sb.Append(" Where inv.Investigation_id= " + InvestigationID + " ");
        }
        sb.Append(" and c.ConfigRelationID='3' and inv.ReportType=1 and im.IsActive=1 order by inv.Name ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "Investigation_id";
            ddlInvestigation.DataBind();
            
            // ddlInvestigation.Items.Insert(0, "---Select Investigation---");
            //if (InvestigationID != "0" || InvestigationID == "")
            //{
            //    ddlInvestigation.Items.FindByValue(InvestigationID).Selected = true;

            //}
        }
    }

    protected void ddlObservation_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        txtInvInterpretaion.Text = StockReports.ExecuteScalar(string.Format("select Interpretation from labobservation_master where LabObservation_ID='{0}'", ddlObservation.SelectedValue));
        if (ddlObservation.SelectedIndex != 0)
        {
            shwobs();
        }
    }

    protected void ddlInvestigation_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        BindObservation();
        //if (ddlInvestigation.SelectedIndex != 0)
        //{
        //    shwinv();
        //}
    }

    private void BindObservation()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (RadioButtonList1.SelectedIndex == 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("select IM.Investigation_Id,IM.Name,LOM.LabObservation_ID,Concat(Loi.Prefix,LOM.Name) as ObsName,LOI.IsCritical,LOM.Minimum,LOM.Maximum,LOM.MinFemale,LOM.MaxFemale,LOM.MinChild,LOM.MaxChild,LOM.ReadingFormat,loi.printOrder,loi.Child_Flag,LOI.SampleTypeID,LOI.SampleTypeName,LOI.MethodName from investigation_master IM inner join labobservation_investigation LOI");
                sb.Append(" on IM.Investigation_Id=LOI.Investigation_Id inner join labobservation_master LOM on");
                sb.Append(" LOI.labObservation_ID=LOM.LabObservation_ID ");//where  IM.Investigation_Id=@InvID and LOM.labObservation_ID=@ObvID              
                sb.Append(" where  IM.Investigation_Id=@InvID  ");//and LOM.labObservation_ID=@ObvID
               
                if (observationid !="0")
                {
                    sb.Append(" and LOM.labObservation_ID=@ObvID ");
                }
                sb.Append(" order by ObsName ");
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                      new MySqlParameter("@InvID", ddlInvestigation.SelectedValue),
                      new MySqlParameter("@ObvID", observationid)).Tables[0])
                {
                    ddlObservation.DataSource = dt;
                    ddlObservation.DataTextField = "ObsName";
                    ddlObservation.DataValueField = "LabObservation_ID";
                    ddlObservation.DataBind();

                    // ddlObservation.Items.Insert(0, "---Select Observation---");
                }
            }
            else
            {
                showinvsaved();
            }
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

    protected void btnsave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        int PrintInterTest = 0;
        int PrintInterPackage = 0;
        if (chkshwinv.Checked == true)
        {
            PrintInterTest = 1;
        }
        else
        {
            PrintInterTest = 0;
        }

        if (chkshwpkg.Checked == true)
        {
            PrintInterPackage = 1;
        }
        else
        {
            PrintInterPackage = 0;
        }

        string header = "";
        header = txtInvInterpretaion.Text;
        header = header.Replace("\'", "");
        header = header.Replace("–", "-");
        header = header.Replace("'", "");
        header = header.Replace("µ", "&micro;");
        header = header.Replace("ᴼ", "&deg;");
        header = header.Replace("#aaaaaa 1px dashed", "none");
        header = header.Replace("dashed", "none");

        try
        {
            string str = "";
            if (RadioButtonList1.SelectedIndex == 0)
            {

                string ibservalue=ddlObservation.SelectedValue;

                if (ibservalue == "")
                {
                    lblMsg.Text = "Please  Select Observation";
                    return;
                }
                StringBuilder sb = new StringBuilder();
                sb.Append(" update  labobservation_master_Interpretation set IsActive=0,updatedate=now(),updatebyid="+UserInfo.ID+",updatebyname='"+UserInfo.LoginName+"' where labObservation_ID='" + ddlObservation.SelectedValue + "' AND macID='" + ddlMac.SelectedValue + "' and flag='" + ddlstatus.SelectedValue + "' ");
                if (!chkAllCentre.Checked)
                {                   
                        sb.Append(" AND CentreID = '" + ddlCentre.SelectedValue + "' ");                  
                }
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

                str = "INSERT INTO labobservation_master_Interpretation(labObservation_ID,centreID,macID,Interpretation,flag,PrintInterTest,PrintInterPackage,entryDate,entryBy) values ('" + ddlObservation.SelectedValue + "','" + ddlCentre.SelectedValue + "','" + ddlMac.SelectedValue + "','" + header + "','" + ddlstatus.SelectedValue + "','1','1',now(),'" + Session["ID"].ToString() + "')";

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                if (chkAllCentre.Checked)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO labobservation_master_Interpretation(labObservation_ID,centreID,macID,Interpretation,flag,PrintInterTest,PrintInterPackage,entryDate,entryBy)");
                    sb.Append(" SELECT lmi.labObservation_ID,cm.centreID,lmi.macID,lmi.Interpretation,lmi.flag,lmi.PrintInterTest,lmi.PrintInterPackage,lmi.entryDate,lmi.entryBy ");
                    sb.Append(" FROM labobservation_master_Interpretation lmi CROSS JOIN centre_master cm  ");
                    sb.Append(" WHERE cm.isActive=1 AND lmi.`IsActive`=1  AND lmi.centreid='" + ddlCentre.SelectedValue + "' AND cm.centreid!='" + ddlCentre.SelectedValue + "' AND lmi.LabObservation_ID='" + ddlObservation.SelectedValue + "' ");
                    sb.Append(" AND lmi.MacID='" + Util.GetInt(ddlMac.SelectedValue) + "' AND lmi.flag='" + ddlstatus.SelectedValue + "' GROUP BY lmi.labObservation_ID,cm.centreid   ");

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                }
                Tranx.Commit();
                lblMsg.Text = "Record saved Successfully";
                showobssaved();
            }
            else
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" update  investigation_master_Interpretation set IsActive=0 ,updatedate=now(),updatebyid=" + UserInfo.ID + ",updatebyname='" + UserInfo.LoginName + "'  where Investigation_id ='" + ddlInvestigation.SelectedValue + "' AND macID='" + ddlMac.SelectedValue + "' ");
                if (!chkAllCentre.Checked)
                {
                    sb.Append("  AND centreID='" + ddlCentre.SelectedValue + "' ");
                }
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text,sb.ToString());

                str = "INSERT INTO investigation_master_Interpretation(Investigation_id,centreID,macID,Interpretation,PrintInterTest,PrintInterPackage,entryDate,entryBy) values ('" + ddlInvestigation.SelectedValue + "','" + ddlCentre.SelectedValue + "','" + ddlMac.SelectedValue + "','" + header + "','" + PrintInterTest + "','" + PrintInterPackage + "',now(),'" + Session["ID"].ToString() + "')";

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

                if (chkAllCentre.Checked)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO investigation_master_Interpretation(Investigation_id,centreID,macID,Interpretation,PrintInterTest,PrintInterPackage,entryDate,entryBy) ");
                    sb.Append(" SELECT imi.Investigation_id,cm.centreID,imi.macID,imi.Interpretation,imi.PrintInterTest,imi.PrintInterPackage,imi.entryDate,imi.entryBy");
                    sb.Append(" FROM investigation_master_Interpretation imi CROSS JOIN centre_master cm  ");
                    sb.Append(" WHERE cm.isActive=1 AND imi.`IsActive`=1 AND imi.centreid='" + ddlCentre.SelectedValue + "' AND cm.centreid!='" + ddlCentre.SelectedValue + "' AND imi.Investigation_id='" + ddlInvestigation.SelectedValue + "' ");
                    sb.Append(" AND imi.MacID='" + Util.GetInt(ddlMac.SelectedValue) + "' GROUP BY imi.Investigation_id,cm.centreid  ");

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                }
                Tranx.Commit();              
                lblMsg.Text = "Record saved Successfully";
                showinvsaved();
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            lblMsg.Text = "Error";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        if (RadioButtonList1.SelectedIndex == 1)
        {
            lblObs.Visible = false;
            ddlObservation.Visible = false;
        }
        else
        {
            lblObs.Visible = true;
            ddlObservation.Visible = true;
        }

        clearform();
    }

    private void clearform()
    {
        txtInvInterpretaion.Text = "";
        ddlObservation.SelectedIndex = -1;
        ddlInvestigation.SelectedIndex = -1;
        BindObservation();
    }

    public void shwinv()
    {
        string str = string.Format("Select PrintInterTest,PrintInterPackage From investigation_master_Interpretation where Investigation_id = '{0}' and macid='{1}' and centreid='{2}'", ddlInvestigation.SelectedValue, ddlMac.SelectedValue, ddlCentre.SelectedValue);
        DataTable dt = StockReports.GetDataTable(str);
        string shwinv1 = dt.Rows[0]["PrintInterTest"].ToString();
        string shwinv2 = dt.Rows[0]["PrintInterPackage"].ToString();

        if (shwinv1 == "1")
        {
            chkshwinv.Checked = true;
        }
        else
        {
            chkshwinv.Checked = false;
        }

        if (shwinv2 == "1")
        {
            chkshwpkg.Checked = true;
        }
        else
        {
            chkshwpkg.Checked = false;
        }
    }

    public void shwobs()
    {
        string shwobs = string.Format("select PrintInterTest,PrintInterPackage from labobservation_master where LabObservation_ID = '{0}'", ddlObservation.SelectedValue);
        DataTable dt = StockReports.GetDataTable(shwobs);
        string shwobs1 = dt.Rows[0]["PrintInterTest"].ToString();
        string shwobs2 = dt.Rows[0]["PrintInterPackage"].ToString();

        if (shwobs1 == "1")
        {
            chkshwinv.Checked = true;
        }
        else if (shwobs1 == "0")
        {
            chkshwinv.Checked = false;
        }

        if (shwobs2 == "1")
        {
            chkshwpkg.Checked = true;
        }
        else if (shwobs2 == "0")
        {
            chkshwpkg.Checked = false;
        }
    }

    protected void ddlCentre_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (RadioButtonList1.SelectedIndex == 0)
        {
            showobssaved();
        }
        else
        {
            showinvsaved();
        }
    }

    protected void ddlMac_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (RadioButtonList1.SelectedIndex == 0)
        {
            showobssaved();
        }
        else
        {
            showinvsaved();
        }
    }

    public void showinvsaved()
    {
        string str = string.Format("Select PrintInterTest,PrintInterPackage,Interpretation From investigation_master_Interpretation where Investigation_id = '{0}' and macid='{1}' and centreid='{2}' and isActive=1", ddlInvestigation.SelectedValue, ddlMac.SelectedValue, ddlCentre.SelectedValue);
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            txtInvInterpretaion.Text = dt.Rows[0]["Interpretation"].ToString();
            string shwinv1 = dt.Rows[0]["PrintInterTest"].ToString();
            string shwinv2 = dt.Rows[0]["PrintInterPackage"].ToString();

            if (shwinv1 == "1")
            {
                chkshwinv.Checked = true;
            }
            else
            {
                chkshwinv.Checked = false;
            }

            if (shwinv2 == "1")
            {
                chkshwpkg.Checked = true;
            }
            else
            {
                chkshwpkg.Checked = false;
            }
        }
        else
        {
            txtInvInterpretaion.Text = "";
            chkshwpkg.Checked = false;
            chkshwinv.Checked = false;
        }
    }

    public void showobssaved()
    {
        string str = string.Format("Select PrintInterTest,PrintInterPackage,Interpretation From labobservation_master_Interpretation where labObservation_ID = '{0}' and macid='{1}' and centreid='{2}' and flag='{3}' AND isactive=1", ddlObservation.SelectedValue, ddlMac.SelectedValue, ddlCentre.SelectedValue, ddlstatus.SelectedValue);
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            txtInvInterpretaion.Text = dt.Rows[0]["Interpretation"].ToString();
            string shwinv1 = dt.Rows[0]["PrintInterTest"].ToString();
            string shwinv2 = dt.Rows[0]["PrintInterPackage"].ToString();

            if (shwinv1 == "1")
            {
                chkshwinv.Checked = true;
            }
            else
            {
                chkshwinv.Checked = false;
            }

            if (shwinv2 == "1")
            {
                chkshwpkg.Checked = true;
            }
            else
            {
                chkshwpkg.Checked = false;
            }
        }
        else
        {
            txtInvInterpretaion.Text = "";
            chkshwpkg.Checked = false;
            chkshwinv.Checked = false;
        }
    }

    protected void ddlstatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (RadioButtonList1.SelectedIndex == 0)
        {
            showobssaved();
        }
        else
        {
            showinvsaved();
        }
    }
}