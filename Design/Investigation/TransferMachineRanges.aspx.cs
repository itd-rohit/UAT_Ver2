using System;
using System.Data;
using System.Web;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
public partial class Design_Investigation_TransferMachineRanges : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCentre();
            BindCentre2();
            BindMac();
            BindMac2();            
        }        
    }

    private void BindCentre()
    {
        string str = "SELECT centreid, centre FROM centre_master";
        DataTable dt = StockReports.GetDataTable(str);
        ddlCentreSource.DataSource = dt;
        ddlCentreSource.DataTextField = "Centre";
        ddlCentreSource.DataValueField = "CentreID";
        ddlCentreSource.DataBind();
        ddlCentreSource.Items.Insert(0, new ListItem ("--Select Centre--", "0#"));    
    }

    private void BindCentre2()
    {
        string str = "SELECT centreid, centre FROM centre_master";
        DataTable dt = StockReports.GetDataTable(str);
        ddlCentreTarget.DataSource = dt;
        ddlCentreTarget.DataTextField = "Centre";
        ddlCentreTarget.DataValueField = "CentreID";
        ddlCentreTarget.DataBind();
        ddlCentreTarget.Items.Insert(0, new ListItem("--Select Centre--", "0#"));
    }

    private void BindMac()
    {
        string str = "SELECT ID, NAME FROM macmaster";
        DataTable dt = StockReports.GetDataTable(str);
        ddlMacSource.DataSource = dt;
        ddlMacSource.DataTextField = "NAME";
        ddlMacSource.DataValueField = "ID";
        ddlMacSource.DataBind();
        ddlMacSource.Items.Insert(0, new ListItem("--Select Machine--", "0#"));
    }

    private void BindMac2()
    {
        string str = "SELECT ID, NAME FROM macmaster";
        DataTable dt = StockReports.GetDataTable(str);
        ddlMacTarget.DataSource = dt;
        ddlMacTarget.DataTextField = "NAME";
        ddlMacTarget.DataValueField = "ID";
        ddlMacTarget.DataBind();
        ddlMacTarget.Items.Insert(0, new ListItem("--Select Machine--", "0#"));
    }

    protected void btntrnsfr_Click(object sender, EventArgs e)
    {
        string url = HttpContext.Current.Request.Url.AbsoluteUri;
        if (ddlCentreSource.SelectedIndex == 0 && ddlMacSource.SelectedIndex == 0)
        {           
            Response.Write("<script>alert('Please Select Centre Name and Machine Name......');</script>");
        }
        else if (ddlCentreSource.SelectedIndex != 0 && ddlMacSource.SelectedIndex == 0)
        {
            Response.Write("<script>alert('Please Select Machine Name...');</script>");            
        }
        else if (ddlCentreTarget.SelectedIndex == 0 && ddlMacTarget.SelectedIndex == 0)
        {
            Response.Write("<script>alert('Please Select Centre and Machine Name, to which the data is to be sent...');</script>");            
        }
        else if (ddlCentreTarget.SelectedIndex != 0 && ddlMacTarget.SelectedIndex == 0)
        {
            Response.Write("<script>alert('Please Select Machine Name, to which the data is to be sent...');</script>");            
        }    

		else if (ddlCentreSource.SelectedIndex == ddlCentreTarget.SelectedIndex)
            {
                Response.Write("<script>alert('Can't Send Range in Same Centre!');</script>");                
            }		
        if (ddlCentreSource.SelectedIndex != 0 && ddlMacSource.SelectedIndex != 0 && ddlCentreTarget.SelectedIndex != 0 && ddlMacTarget.SelectedIndex != 0)
        {
            
            if (ddlCentreSource.SelectedValue == ddlCentreTarget.SelectedValue && ddlMacSource.SelectedValue == ddlMacTarget.SelectedValue)
            {
                Response.Write("<script>alert('Same Centre and Machine chosen!');</script>");                
            }
            else
            {               
                   MySqlConnection con = Util.GetMySqlCon();
                   con.Open();
                   MySqlTransaction tnx = con.BeginTransaction();

                      string str = "SELECT COUNT(*) FROM labobservation_range WHERE CentreID='"+ddlCentreSource.SelectedItem.Value+"' AND MacID='"+ddlMacSource.SelectedItem.Value+"';";
                      DataTable dt = StockReports.GetDataTable(str);
                      string count = dt.Rows[0]["COUNT(*)"].ToString();
                      if (count == "0")
                      {
                          Response.Write("<script>alert('No record found in source machine!');</script>");
                      }
                      else
                      {
                          str = " DELETE FROM labobservation_range WHERE CentreID='" + ddlCentreTarget.SelectedItem.Value + "' AND MacID='" + ddlMacTarget.SelectedItem.Value + "'";
                          MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                          StringBuilder sb = new StringBuilder();
                          sb.Append(" INSERT INTO labobservation_range ");
                          sb.Append(" ( ");
                          sb.Append(" Investigation_ID,LabObservation_ID,Gender,FromAge,ToAge,MinReading,MaxReading,DisplayReading, ");
                          sb.Append(" DefaultReading,MinCritical,MaxCritical,ReadingFormat,Interpretation,UserID,EntDateTime,UpdateID, ");
                          sb.Append(" UpdateName,UpdateRemarks,Updatedate,MacID,MethodName,ShowMethod,CentreID,AbnormalValue,RangeType, ");
                          sb.Append(" AutoApprovedMin,AutoApprovedMax,AMRMin,AMRMax,reflexmin,reflexmax ");
                          sb.Append(" ) ");
                          sb.Append(" SELECT  ");
                          sb.Append(" Investigation_ID,LabObservation_ID,Gender,FromAge,ToAge,MinReading,MaxReading,DisplayReading, ");
                          sb.Append(" DefaultReading,MinCritical,MaxCritical,ReadingFormat,Interpretation,'" + UserInfo.ID + "' UserID,now() as EntDateTime,'" + UserInfo.ID + "' UpdateID, ");
                          sb.Append(" '" + UserInfo.LoginName + "' UpdateName,UpdateRemarks,Updatedate,'" + ddlMacTarget.SelectedItem.Value + "' MacID,MethodName,ShowMethod,'" + ddlCentreTarget.SelectedItem.Value + "' CentreID,AbnormalValue,RangeType, ");
                          sb.Append(" AutoApprovedMin,AutoApprovedMax,AMRMin,AMRMax,reflexmin,reflexmax ");
                          sb.Append(" FROM labobservation_range");
                          sb.Append(" WHERE CentreID='" + ddlCentreSource.SelectedItem.Value + "' AND MacID='" + ddlMacSource.SelectedItem.Value + "' ");

                          MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                          //====================================Interpretation transferred**Start===========================================================//
                          string str_Deactivate = " UPDATE investigation_master_interpretation SET `IsActive`=0,Updatedate=NOW()  WHERE CentreID='" + ddlCentreTarget.SelectedItem.Value + "' AND MacID='" + ddlMacTarget.SelectedItem.Value + "'";
                         MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str_Deactivate);
                          StringBuilder sb_interpretation = new StringBuilder();
                         sb_interpretation.Append(" INSERT INTO investigation_master_interpretation ");
                         sb_interpretation.Append(" (Investigation_Id,centreid,macid,Interpretation,PrintInterTest,PrintInterPackage,entrydate,entryby,IsActive) ");
                         sb_interpretation.Append(" SELECT Investigation_Id,'" + ddlCentreTarget.SelectedItem.Value + "' ,'" + ddlMacTarget.SelectedItem.Value + "',Interpretation,PrintInterTest,PrintInterPackage,NOW(),'" + UserInfo.ID + "',IsActive ");
                         sb_interpretation.Append(" FROM investigation_master_interpretation ");
                         sb_interpretation.Append(" WHERE CentreID='" + ddlCentreSource.SelectedItem.Value + "' AND MacID='" + ddlMacSource.SelectedItem.Value + "' and IsActive=1 ");
                         MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb_interpretation.ToString());
                          //====================================Interpretation transferred**END============================================================//
                          tnx.Commit();
                          con.Close();
                          Response.Write("<script>alert('Transfer Complete!');</script>");   
                          ddlCentreSource.SelectedIndex = 0;
                          ddlMacSource.SelectedIndex = 0;
                          ddlCentreTarget.SelectedIndex = 0;
                          ddlMacTarget.SelectedIndex = 0;
                      }                     
                  }                 
            }
            
        }
        
    }

