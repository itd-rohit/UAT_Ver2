using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_TatTransfer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSourceCentre();
            BindTargetCentre();
            BindDepartment();
        }
    }

    protected void ddlDept_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void rblMasterType_SelectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Validate() == true)
            {
                StringBuilder sb1 = new StringBuilder();
                StringBuilder sb2 = new StringBuilder();

                if (rblMasterType.SelectedItem.Value == "TAT")
                {
                    #region For Delete Records Centre And Department Wise..!!
                    sb2.Append(" Delete invd.* from investiagtion_delivery invd ");
                    if (ddlDept.SelectedItem.Value != "")
                    {
                        sb2.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=invd.`Investigation_ID`");
                        sb2.Append(" INNER JOIN `investigation_observationtype` iot ON iot.`Investigation_ID`=inv.`Investigation_Id` ");
                    }
                    sb2.Append(" where invd.CentreID='" + ddlTargetCentre.SelectedValue + "'  ");

                    if (ddlDept.SelectedItem.Value != "")
                    {
                        sb2.Append(" AND iot.`ObservationType_Id`='" + ddlDept.SelectedItem.Value + "' ");
                    }
                    #endregion

                    #region For Insert Records Centre And Department Wise..!!
                    sb1.Append("INSERT INTO investiagtion_delivery(CentreID,SubcategoryID,Investigation_ID,TATType,MorningHours,EveningHours,DayType,Days,Sun,Mon,Tue,Wed,Thu,Fri,Sat,CutOffTime,UserID,UserName,UpdateDate,IpAddress,labstarttime,labendtime,samedaydeliverytime,nextdaydeliverytime,samedaydeliverytime1,samedaydeliverytime2,cutofftime1,cutofftime2,isapplicable,isapplicable1,isapplicable2,stathours) ");
                    sb1.Append(" SELECT '" + ddlTargetCentre.SelectedValue + "' CentreID,invd.SubcategoryID,invd.Investigation_ID,invd.TATType,invd.MorningHours,invd.EveningHours,invd.DayType,invd.Days,invd.Sun,invd.Mon,invd.Tue,invd.Wed,invd.Thu,invd.Fri,invd.Sat,invd.CutOffTime,'" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "',NOW(),'" + StockReports.getip() + "',labstarttime,labendtime,samedaydeliverytime,nextdaydeliverytime,samedaydeliverytime1,samedaydeliverytime2,cutofftime1,cutofftime2,isapplicable,isapplicable1,isapplicable2,stathours FROM investiagtion_delivery invd ");
                    if (ddlDept.SelectedItem.Value != "")
                    {
                        sb1.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=invd.`Investigation_ID`");
                        sb1.Append(" INNER JOIN `investigation_observationtype` iot ON iot.`Investigation_ID`=inv.`Investigation_Id` ");
                    }
                    sb1.Append("    WHERE CentreID='" + ddlSourceCentre.SelectedValue + "' ");
                    if (ddlDept.SelectedItem.Value != "")
                    {
                        sb1.Append(" AND iot.`ObservationType_Id`='" + ddlDept.SelectedItem.Value + "' ");
                    }
                    #endregion
                }

                #region For Update plo Update Status..!!
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb2.ToString());
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb1.ToString());
                string strLog = "INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,Roleid,CentreID,OLDID,NEWID) Values ('" + ddlTargetCentre.SelectedValue + "','','DeliveryDays-CopyMaster','" + HttpContext.Current.Session["ID"] + "','" + HttpContext.Current.Session["LoginName"] + "',NOW(),'" + StockReports.getip() + "','" + HttpContext.Current.Session["RoleID"].ToString() + "','" + Util.GetString(UserInfo.Centre) + "','','')";
             //   MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strLog);
                #endregion

                clearform();
                lblStatus.Text = "Record saved Successfully";
                lblStatus.ForeColor = System.Drawing.Color.Green;
                con.Close();
                con.Dispose();
            }
        }

        catch (Exception ex)
        {
            lblStatus.Text = ex.Message;
            con.Close();
            con.Dispose();
        }
    }

    private void BindSourceCentre()
    {
        ddlSourceCentre.DataSource = AllLoad_Data.getCentreByTagBusinessLab();
        ddlSourceCentre.DataTextField = "Centre";
        ddlSourceCentre.DataValueField = "CentreID";        
        ddlSourceCentre.DataBind();
        ddlSourceCentre.Items.Insert(0, "Select");
    }

    private void BindTargetCentre()
    {
        ddlTargetCentre.DataSource = AllLoad_Data.getCentreByTagBusinessLab();
        ddlTargetCentre.DataTextField = "Centre";
        ddlTargetCentre.DataValueField = "CentreID";        
        ddlTargetCentre.DataBind();
        ddlTargetCentre.Items.Insert(0, "Select");
    }

    private void BindDepartment()
    {
        ddlDept.DataSource = AllLoad_Data.getDepartment();
        ddlDept.DataTextField = "NAME";
        ddlDept.DataValueField = "SubcategoryID";
        ddlDept.DataBind();
        ddlDept.Items.Add(new ListItem(" ", "", true));
        ddlDept.Items.Insert(0, "Select");
    }

    private void clearform()
    {       
        ddlSourceCentre.SelectedIndex =0;
        ddlTargetCentre.SelectedIndex =0;
        ddlDept.SelectedIndex = 0;
    }

    private bool Validate()
    {
        if (ddlSourceCentre.SelectedIndex == 0)
        {
            lblStatus.Text = "Please Select Source Centre..!!";
            ddlSourceCentre.Focus();

            return false;
        }
        if (ddlTargetCentre.SelectedIndex == 0)
        {
            lblStatus.Text = "Please Select target Centre..!!";
            ddlSourceCentre.Focus();

            return false;
        }
        if (ddlDept.SelectedIndex ==0)
        {
            lblStatus.Text = " Please Select Department..!!";
            ddlDept.Focus();

            return false;
        }
        return true;
    }
}