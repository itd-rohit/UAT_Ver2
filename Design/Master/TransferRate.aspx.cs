using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web;
public partial class Design_EDP_TransferRate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindGroup();
            bindSPanel();
            bindTPanel();
            BindDepartment();
            bindbillingCategory();
        }
    }

    private void bindSPanel()
    {
        DataTable dt = new DataTable();
        if (ddlSGroup.SelectedIndex > 0)
            dt = StockReports.GetDataTable("SELECT Company_Name,Panel_ID FROM f_panel_master WHERE Panel_ID=ReferenceCodeOPD and PanelGroupID=" + ddlSGroup.SelectedValue + " order by Company_Name");
        else
            dt = StockReports.GetDataTable("SELECT Company_Name,Panel_ID FROM f_panel_master where Panel_ID=ReferenceCodeOPD order by Company_Name");

        ddlSPanel.DataSource = dt;
        ddlSPanel.DataTextField = "Company_Name";
        ddlSPanel.DataValueField = "Panel_ID";
        ddlSPanel.DataBind();
        ListItem list = new ListItem("", "");
        ddlSPanel.Items.Insert(0, list);
    }

    private void bindTPanel()
    {
        DataTable dt = new DataTable();
        if (ddlTGroup.SelectedIndex > 0)
            dt = StockReports.GetDataTable("SELECT Company_Name,Panel_ID FROM f_panel_master WHERE panel_id=ReferenceCodeOPD and  PanelGroupID=" + ddlTGroup.SelectedValue + " order by Company_Name");
        else
            dt = StockReports.GetDataTable("SELECT Company_Name,Panel_ID FROM f_panel_master WHERE panel_id=ReferenceCodeOPD order by Company_Name");

        ddlTPanel.DataSource = dt;
        ddlTPanel.DataTextField = "Company_Name";
        ddlTPanel.DataValueField = "Panel_ID";
        ddlTPanel.DataBind();
        ListItem list = new ListItem("", "");
        ddlTPanel.Items.Insert(0, list);
    }

    private void bindGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT PanelGroup,PanelGroupID FROM f_panelgroup WHERE active=1");
        ddlSGroup.DataSource = dt;
        ddlSGroup.DataTextField = "PanelGroup";
        ddlSGroup.DataValueField = "PanelGroupID";
        ddlSGroup.DataBind();
        ddlSGroup.Items.Insert(0, "--Select--");

        ddlTGroup.DataSource = dt;
        ddlTGroup.DataTextField = "PanelGroup";
        ddlTGroup.DataValueField = "PanelGroupID";
        ddlTGroup.DataBind();
        ddlTGroup.Items.Insert(0, "--Select--");
    }

    protected void btnRate_Click(object sender, EventArgs e)
    {
        if (ddlSPanel.SelectedValue == "")
        {
            lblMsg.Text = "Please Select Source Panel";
            ddlSPanel.Focus();
            return;
        }

        if (ddlTPanel.SelectedValue == "")
        {
            lblMsg.Text = "Please Select Target Panel";
            ddlTPanel.Focus();
            return;
        }
        if (ddlSPanel.SelectedValue == ddlTPanel.SelectedValue)
        {
            lblMsg.Text = "Source Panel and Target Panel cannot be same.";
            ddlSPanel.Focus();
            return;
        }
        ratetoratetransfersp();
    }

    private void ratetomrprate()
    {
        float rate = 0f;

        rate = Util.GetFloat(txtRate.Text.Trim());
        if (ddlSPanel.SelectedValue == ddlTPanel.SelectedValue)
        {
            lblMsg.Text = "Source Panel and Target Panel cannot be same.";
            return;
        }
        else if ((ddlSPanel.Items.Count == 0) || (ddlTPanel.Items.Count == 0))
        {
            lblMsg.Text = "Source Panel or Target Panel cannot be Empty.";
            return;
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if ((ddlDepartment.SelectedIndex == 0))
            {
                string sql = "select count(*) from f_ratelist WHERE Panel_ID='" + ddlSPanel.SelectedValue + "'";
                int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sql));

                if (flag == 0)
                {
                    lblMsg.Text = " Wrong source panel selected !!! ";
                    objTran.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, "SELECT rate,itemid FROM f_ratelist WHERE panel_id='" + ddlSPanel.SelectedValue + "' ").Tables[0];
                foreach (DataRow dw in dtrate.Rows)
                {
                    sql = "update f_ratelist set mrp_rate=round(" + dw["rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
                }
            }
            else
            {
                StringBuilder sb2 = new StringBuilder();
                sb2.Append("   select count(*) FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
                sb2.Append("   INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID  ");
                sb2.Append("   WHERE rt.panel_id='" + ddlSPanel.SelectedValue + "' AND itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "' ");

                int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb2.ToString()));

                if (flag == 0)
                {
                    lblMsg.Text = " Wrong source panel selected !!! ";
                    objTran.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                string sql = "";
                sql = @"SELECT rl.rate,rl.itemid,mrp_rate FROM f_ratelist rl
INNER JOIN f_itemmaster itm ON itm.ItemID=rl.itemid
INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID
WHERE panel_id='" + ddlSPanel.SelectedValue + "' and itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "'";

                DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, sql).Tables[0];
                foreach (DataRow dw in dtrate.Rows)
                {
                    sql = "update f_ratelist set mrp_rate=round(" + dw["rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
                }
            }

            objTran.Commit();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Record saved successfully.";
        }
        catch (Exception ex)
        {
            objTran.Rollback();
            con.Close();
            con.Dispose();
        }
    }

    private void mrpratetorate()
    {
        float rate = 0f;

        rate = Util.GetFloat(txtRate.Text.Trim());
        if (ddlSPanel.SelectedValue == ddlTPanel.SelectedValue)
        {
            lblMsg.Text = "Source Panel and Target Panel cannot be same.";
            return;
        }
        else if ((ddlSPanel.Items.Count == 0) || (ddlTPanel.Items.Count == 0))
        {
            lblMsg.Text = "Source Panel or Target Panel cannot be Empty.";
            return;
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if ((ddlDepartment.SelectedIndex == 0))
            {
                string sql = "select count(*) from f_ratelist WHERE Panel_ID='" + ddlSPanel.SelectedValue + "'";
                int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sql));

                if (flag == 0)
                {
                    lblMsg.Text = " Wrong source panel selected !!! ";
                    objTran.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, "SELECT mrp_rate ,itemid FROM f_ratelist WHERE panel_id='" + ddlSPanel.SelectedValue + "' ").Tables[0];
                foreach (DataRow dw in dtrate.Rows)
                {
                    sql = "update f_ratelist set rate=round(" + dw["mrp_rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
                }
            }
            else
            {
                StringBuilder sb2 = new StringBuilder();
                sb2.Append("   select count(*) FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
                sb2.Append("   INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID  ");
                sb2.Append("   WHERE rt.panel_id='" + ddlSPanel.SelectedValue + "' AND itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "' ");

                int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb2.ToString()));

                if (flag == 0)
                {
                    lblMsg.Text = " Wrong source panel selected !!! ";
                    objTran.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                string sql = "";
                sql = @"SELECT rl.mrp_rate,rl.itemid FROM f_ratelist rl
INNER JOIN f_itemmaster itm ON itm.ItemID=rl.itemid
INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID
WHERE panel_id='" + ddlSPanel.SelectedValue + "' and itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "'";

                DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, sql).Tables[0];
                foreach (DataRow dw in dtrate.Rows)
                {
                    sql = "update f_ratelist set rate=round(" + dw["mrp_rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
                }
            }

            objTran.Commit();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Record saved successfully.";
        }
        catch (Exception ex)
        {
            objTran.Rollback();
            con.Close();
            con.Dispose();
        }
    }

    private void ratetoratetransfer()
    {
        float rate = 0f;

        rate = Util.GetFloat(txtRate.Text.Trim());
        if (ddlSPanel.SelectedValue == ddlTPanel.SelectedValue)
        {
            lblMsg.Text = "Source Panel and Target Panel cannot be same.";
            return;
        }
        else if ((ddlSPanel.Items.Count == 0) || (ddlTPanel.Items.Count == 0))
        {
            lblMsg.Text = "Source Panel or Target Panel cannot be Empty.";
            return;
        }

        // DataTable dt = StockReports.GetDataTable("SELECT ItemDisplayName,ItemID,Rate,itemcode FROM f_ratelist WHERE Panel_ID='" + ddlSPanel.SelectedValue + "' ");

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if ((ddlDepartment.SelectedIndex == 0))
            {
                string sql = "select count(*) from f_ratelist WHERE Panel_ID='" + ddlSPanel.SelectedValue + "'";
                int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sql));

                if (flag == 0)
                {
                    lblMsg.Text = " Wrong source panel selected !!! ";
                    objTran.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE Panel_ID=@Panel_ID ",
             new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
             new MySqlParameter("@Panel_ID", ddlTPanel.SelectedValue));

                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "delete from f_ratelist where panel_id='" + ddlTPanel.SelectedValue + "'");

                sql = " INSERT INTO f_ratelist ( ";
                sql += " Location,Hospcode,Hospital_ID,Rate,ERate,FromDate,IsCurrent,ItemID,Panel_ID, ";
                sql += " itemcode,ItemDisplayName,UpdateBy,UpdateRemarks,UpdateDate) ";
                sql += " SELECT Location,Hospcode,Hospital_ID,round(Rate*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) Rate,ERate,CURRENT_DATE() FromDate,'1' IsCurrent,ItemID,'" + ddlTPanel.SelectedValue + "' Panel_ID, ";
                sql += " '' itemcode,ItemDisplayName,'" + UserInfo.LoginName + "'UpdateBy,'Transfer panel rate from " + ddlSPanel.SelectedValue + " ' UpdateRemarks,NOW() UpdateDate FROM f_ratelist WHERE Panel_ID='" + ddlSPanel.SelectedValue + "' ";
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);

                sql = "UPDATE f_ratelist SET RateListID=CONCAT('LSHHI',ID) ";
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);

                //foreach (DataRow dr in dt.Rows)
                //{
                //    RateList objRate = new RateList(objTran);
                //    objRate.Panel_ID = ddlTPanel.SelectedValue;
                //    objRate.ItemDisplayName = Util.GetString(dr["ItemDisplayName"]);
                //    objRate.ItemCode = Util.GetString(dr["itemcode"]);
                //    objRate.ItemID = Util.GetString(dr["ItemID"]);
                //    objRate.Rate = Util.GetDouble(dr["Rate"]) + (Util.GetDouble(dr["Rate"]) * rate / 100);
                //    objRate.Insert();
                //}
            }
            else
            {
                StringBuilder sb2 = new StringBuilder();
                sb2.Append("   select count(*) FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
                sb2.Append("   INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID  ");
                sb2.Append("   WHERE rt.panel_id='" + ddlSPanel.SelectedValue + "' AND itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "' ");

                int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb2.ToString()));

                if (flag == 0)
                {
                    lblMsg.Text = " Wrong source panel selected !!! ";
                    objTran.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                StringBuilder sb = new StringBuilder();
                sb.Append("   UPDATE f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
                sb.Append("   INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID  ");
                sb.Append("   SET rt.DeletedByID=@DeletedByID,rt.DeletedBy=@DeletedBy,rt.DeletedDate=NOW() ");
                sb.Append("   WHERE rt.panel_id='" + ddlTPanel.SelectedValue + "' AND itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "' ");
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName));

                sb = new StringBuilder();
                sb.Append("   DELETE rt.* FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
                sb.Append("   INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID  ");
                sb.Append("   WHERE rt.panel_id='" + ddlTPanel.SelectedValue + "' AND itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "' ");
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString());

                string sql = " INSERT INTO f_ratelist ( ";
                sql += " Rate,ERate,FromDate,IsCurrent,ItemID,Panel_ID, ";
                sql += " itemcode,ItemDisplayName,UpdateBy,UpdateRemarks,UpdateDate) ";
                sql += " SELECT round(rt.Rate*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) Rate,rt.ERate,CURRENT_DATE() FromDate,'1' IsCurrent,rt.ItemID,'" + ddlTPanel.SelectedValue + "' Panel_ID, ";
                sql += " '' itemcode,ItemDisplayName,'" + UserInfo.LoginName + "'UpdateBy,'Transfer panel rate from " + ddlSPanel.SelectedValue + " ' UpdateRemarks,NOW() UpdateDate FROM f_ratelist rt  ";
                sql += "  INNER JOIN f_itemmaster itm ON itm.itemid= rt.itemid   INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID  ";

                sql += "  WHERE rt.Panel_ID='" + ddlSPanel.SelectedValue + "' and itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "'  ";
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);

                sql = "UPDATE f_ratelist SET RateListID=CONCAT('LSHHI',ID) ";
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
            }

            objTran.Commit();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Record saved successfully.";
        }
        catch (Exception ex)
        {
            objTran.Rollback();
            con.Close();
            con.Dispose();
        }
    }

    private void mrptomrp()
    {
        float rate = 0f;

        rate = Util.GetFloat(txtRate.Text.Trim());
        if (ddlSPanel.SelectedValue == ddlTPanel.SelectedValue)
        {
            lblMsg.Text = "Source Panel and Target Panel cannot be same.";
            return;
        }
        else if ((ddlSPanel.Items.Count == 0) || (ddlTPanel.Items.Count == 0))
        {
            lblMsg.Text = "Source Panel or Target Panel cannot be Empty.";
            return;
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if ((ddlDepartment.SelectedIndex == 0))
            {
                string sql = "select count(*) from f_ratelist WHERE Panel_ID='" + ddlSPanel.SelectedValue + "'";
                int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sql));

                if (flag == 0)
                {
                    lblMsg.Text = " Wrong source panel selected !!! ";
                    objTran.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, "SELECT mrp_rate ,itemid FROM f_ratelist WHERE panel_id='" + ddlSPanel.SelectedValue + "' ").Tables[0];
                foreach (DataRow dw in dtrate.Rows)
                {
                    sql = "update f_ratelist set mrp_rate=round(" + dw["mrp_rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
                }
            }
            else
            {
                StringBuilder sb2 = new StringBuilder();
                sb2.Append("   select count(*) FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
                sb2.Append("   INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID  ");
                sb2.Append("   WHERE rt.panel_id='" + ddlSPanel.SelectedValue + "' AND itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "' ");

                int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb2.ToString()));

                if (flag == 0)
                {
                    lblMsg.Text = " Wrong source panel selected !!! ";
                    objTran.Rollback();
                    con.Close();
                    con.Dispose();
                    return;
                }

                string sql = "";
                sql = @"SELECT rl.mrp_rate,rl.itemid FROM f_ratelist rl
INNER JOIN f_itemmaster itm ON itm.ItemID=rl.itemid
INNER JOIN f_subcategorymaster otm  ON otm.SubCategoryID = itm.SubCategoryID
WHERE panel_id='" + ddlSPanel.SelectedValue + "' and itm.SubCategoryID='" + ddlDepartment.SelectedValue.ToString() + "'";

                DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, sql).Tables[0];
                foreach (DataRow dw in dtrate.Rows)
                {
                    sql = "update f_ratelist set mrp_rate=round(" + dw["mrp_rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
                    MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
                }
            }

            objTran.Commit();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Record saved successfully.";
        }
        catch (Exception ex)
        {
            objTran.Rollback();
            con.Close();
            con.Dispose();
        }
    }

    protected void ddlTGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindTPanel();
    }

    protected void ddlSGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindSPanel();
    }

    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT scm.Name ,scm.SubCategoryID FROM f_subcategorymaster  scm   where scm.`Active`=1 ORDER BY  scm.Name     ");
        //sb.Append(" where ot.Active=1 ORDER BY ot.Name  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "SubCategoryID";
            ddlDepartment.DataTextField = "Name";

            ddlDepartment.DataBind();
            ListItem list = new ListItem("", "");
            ddlDepartment.Items.Insert(0, list);

            chlDept.DataSource = dt;
            chlDept.DataTextField = "Name";
            chlDept.DataValueField = "SubCategoryID";
            chlDept.DataBind();
        }
    }

    //special case

    //    private void ratetomrpratesp()
    //  {
    //      float rate = 0f;

    //      rate = Util.GetFloat(txtRate.Text.Trim());
    //      if (ddlSPanel.SelectedValue == ddlTPanel.SelectedValue)
    //      {
    //          lblMsg.Text = "Source Panel and Target Panel cannot be same.";
    //          return;
    //      }
    //      else if ((ddlSPanel.Items.Count == 0) || (ddlTPanel.Items.Count == 0))
    //      {
    //          lblMsg.Text = "Source Panel or Target Panel cannot be Empty.";
    //          return;
    //      }

    //      MySqlConnection con = new MySqlConnection();
    //      con = Util.GetMySqlCon();
    //      con.Open();

    //      MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);
    //      try
    //      {
    //              StringBuilder sb2 = new StringBuilder();
    //              sb2.Append("   select count(*) FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
    //              sb2.Append("   WHERE rt.panel_id='" + ddlSPanel.SelectedValue + "' AND itm.Bill_Category='" + ddlbillcategory.SelectedValue.ToString() + "' ");

    //              int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb2.ToString()));

    //              if (flag == 0)
    //              {
    //                  lblMsg.Text = " Wrong source panel selected !!! ";
    //                  objTran.Rollback();
    //                  con.Close();
    //                  con.Dispose();
    //                  return;
    //              }

    //              string sql = "";
    //              sql = @"SELECT rl.rate,rl.itemid,mrp_rate FROM f_ratelist rl
    //INNER JOIN f_itemmaster itm ON itm.ItemID=rl.itemid
    //WHERE panel_id='" + ddlSPanel.SelectedValue + "' AND itm.Bill_Category='" + ddlbillcategory.SelectedValue.ToString() + "' ";

    //              DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, sql).Tables[0];
    //              foreach (DataRow dw in dtrate.Rows)
    //              {
    //                  sql = "update f_ratelist set mrp_rate=round(" + dw["mrp_rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
    //                  MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
    //              }

    //          objTran.Commit();
    //          con.Close();
    //          con.Dispose();
    //          lblMsg.Text = "Record saved successfully.";
    //      }
    //      catch (Exception ex)
    //      {
    //          objTran.Rollback();
    //          con.Close();
    //          con.Dispose();
    //      }

    //  }

    //    private void mrpratetoratesp()
    //  {
    //      float rate = 0f;

    //      rate = Util.GetFloat(txtRate.Text.Trim());
    //      if (ddlSPanel.SelectedValue == ddlTPanel.SelectedValue)
    //      {
    //          lblMsg.Text = "Source Panel and Target Panel cannot be same.";
    //          return;
    //      }
    //      else if ((ddlSPanel.Items.Count == 0) || (ddlTPanel.Items.Count == 0))
    //      {
    //          lblMsg.Text = "Source Panel or Target Panel cannot be Empty.";
    //          return;
    //      }

    //      MySqlConnection con = new MySqlConnection();
    //      con = Util.GetMySqlCon();
    //      con.Open();

    //      MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);
    //      try
    //      {
    //              StringBuilder sb2 = new StringBuilder();
    //              sb2.Append("   select count(*) FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
    //              sb2.Append("   WHERE rt.panel_id='" + ddlSPanel.SelectedValue + "' AND itm.Bill_Category='" + ddlbillcategory.SelectedValue.ToString() + "' ");

    //              int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb2.ToString()));

    //              if (flag == 0)
    //              {
    //                  lblMsg.Text = " Wrong source panel selected !!! ";
    //                  objTran.Rollback();
    //                  con.Close();
    //                  con.Dispose();
    //                  return;
    //              }

    //              string sql = "";
    //              sql = @"SELECT rl.mrp_rate,rl.itemid FROM f_ratelist rl
    //INNER JOIN f_itemmaster itm ON itm.ItemID=rl.itemid
    //WHERE panel_id='" + ddlSPanel.SelectedValue + "' AND itm.Bill_Category='" + ddlbillcategory.SelectedValue.ToString() + "'";

    //              DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, sql).Tables[0];
    //              foreach (DataRow dw in dtrate.Rows)
    //              {
    //                  sql = "update f_ratelist set rate=round(" + dw["mrp_rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
    //                  MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
    //              }

    //          objTran.Commit();
    //          con.Close();
    //          con.Dispose();
    //          lblMsg.Text = "Record saved successfully.";
    //      }
    //      catch (Exception ex)
    //      {
    //          objTran.Rollback();
    //          con.Close();
    //          con.Dispose();
    //      }

    //  }

    private void ratetoratetransfersp()
    {
        lblMsg.Text = "";
        float rate = 0f;
        rate = Util.GetFloat(txtRate.Text.Trim());
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string DeptString = AllLoad_Data.GetSelection(chlDept);
        if (DeptString.Trim() == "" && ddlbillcategory.SelectedIndex == 0)
        {
            lblMsg.Text = "Please Select any Department Or Billing Category";
            return;
        }
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb_1 = new StringBuilder();
            sb_1.Append("   select  * FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID='" + ddlTPanel.SelectedValue + "' ");
            sb_1.Append("   WHERE rt.panel_id='" + ddlTPanel.SelectedValue + "'");
            DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());


            StringBuilder sb2 = new StringBuilder();
            sb2.Append("   select count(*) FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
            sb2.Append("   WHERE rt.panel_id=@panel_id ");
            if (DeptString.Trim() != "")
            {
                sb2.Append("   AND itm.SubCategoryID in(" + DeptString + ") ");
            }
            else
            {
                sb2.Append(" AND itm.Bill_Category=@Bill_Category ");
            }
            int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb2.ToString(),
                new MySqlParameter("@panel_id", ddlSPanel.SelectedValue),
                new MySqlParameter("@Bill_Category", ddlbillcategory.SelectedValue.ToString())));

            if (flag == 0)
            {
                lblMsg.Text = " Wrong Source Panel Selected";
                objTran.Rollback();
                return;
            }
            if (rdoType.SelectedValue == "1")
            {
                // For All Item Whose Rate Is >0 From Source Panel
                StringBuilder sb = new StringBuilder();

                sb.Append("   UPDATE f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid  ");
                sb.Append("   SET rt.DeletedByID=@DeletedByID,rt.DeletedBy=@DeletedBy,rt.DeletedDate=NOW() ");
                sb.Append("   WHERE rt.panel_id=@panel_id ");
                if (DeptString.Trim() != "")
                {
                    sb.Append("   AND itm.SubCategoryID in(" + DeptString + ") ");
                }
                else
                {
                    sb.Append(" AND itm.Bill_Category=@Bill_Category ");
                }
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@panel_id", ddlTPanel.SelectedValue),
                  new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
                  new MySqlParameter("@Bill_Category", ddlbillcategory.SelectedValue.ToString()));

                sb = new StringBuilder();
                sb.Append("   DELETE rt.* FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid  ");
                sb.Append("   WHERE rt.panel_id=@panel_id ");
                if (DeptString.Trim() != "")
                {
                    sb.Append("   AND itm.SubCategoryID in(" + DeptString + ") ");
                }
                else
                {
                    sb.Append(" AND itm.Bill_Category=@Bill_Category ");
                }
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@panel_id", ddlTPanel.SelectedValue),
                    new MySqlParameter("@Bill_Category", ddlbillcategory.SelectedValue.ToString()));

                StringBuilder sbInsert = new StringBuilder();
                sbInsert.Append(" INSERT INTO f_ratelist (  ");
                sbInsert.Append(" Rate,ERate,FromDate,IsCurrent,ItemID,Panel_ID, ");
                sbInsert.Append(" itemcode,ItemDisplayName,UpdateBy,UpdateRemarks,UpdateDate) ");
                sbInsert.Append(" SELECT round(rt.Rate*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) Rate,rt.ERate,CURRENT_DATE,'1' IsCurrent,rt.ItemID,'" + ddlTPanel.SelectedValue + "' Panel_ID,");
                sbInsert.Append("  itemcode,ItemDisplayName,'" + UserInfo.ID + "','Transfer panel rate from " + ddlSPanel.SelectedValue + " ' UpdateRemarks,NOW() UpdateDate FROM f_ratelist rt  ");
                sbInsert.Append(" INNER JOIN f_itemmaster itm ON itm.itemid= rt.itemid     ");
                sbInsert.Append(" WHERE rt.Panel_ID=@Panel_ID ");
                if (DeptString.Trim() != "")
                {
                    sbInsert.Append("   AND itm.SubCategoryID in(" + DeptString + ") ");
                }
                else
                {
                    sbInsert.Append(" AND itm.Bill_Category=@Bill_Category ");
                }
                sbInsert.Append("   and rt.`SpecialFlag`=0 ");
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sbInsert.ToString(),
                    new MySqlParameter("@Panel_ID", ddlSPanel.SelectedValue),
                    new MySqlParameter("@Bill_Category", ddlbillcategory.SelectedValue.ToString()));
            }
            else
            {
                // For All Item Whose Rate Is 0 From Source Panel

                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, "DROP TABLE IF EXISTS rateTemp");
                StringBuilder sbTemp = new StringBuilder();
                sbTemp.Append(" CREATE TEMPORARY TABLE  rateTemp (ItemID varchar(50) NOT NULL,INDEX (ItemID)) as ");
                sbTemp.Append(" SELECT itm.ItemID FROM f_itemmaster itm ");
                sbTemp.Append(" LEFT JOIN f_ratelist rt ON rt.`ItemID`=itm.`ItemID` AND rt.`Panel_ID`=@Panel_ID  ");
                sbTemp.Append(" WHERE IFNULL(rt.Rate,0)=0 ");
                if (DeptString.Trim() != "")
                {
                    sbTemp.Append("   AND itm.SubCategoryID in(" + DeptString + ") ");
                }
                else
                {
                    sbTemp.Append(" AND itm.Bill_Category=@Bill_Category ");
                }
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sbTemp.ToString(),
                    new MySqlParameter("@Panel_ID", ddlTPanel.SelectedValue),
                    new MySqlParameter("@Bill_Category", ddlbillcategory.SelectedValue.ToString()));

                StringBuilder sb = new StringBuilder();

                sb.Append("   UPDATE f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid  ");
                sb.Append("   SET rt.DeletedByID=@DeletedByID,rt.DeletedBy=@DeletedBy,rt.DeletedDate=NOW() ");
                sb.Append("   WHERE rt.panel_id=@panel_id and rt.Rate=0 ");
                if (DeptString.Trim() != "")
                {
                    sb.Append("   AND itm.SubCategoryID in(" + DeptString + ") ");
                }
                else
                {
                    sb.Append(" AND itm.Bill_Category=@Bill_Category ");
                }

                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@DeletedByID", UserInfo.ID),
                    new MySqlParameter("@panel_id", ddlTPanel.SelectedValue),
                    new MySqlParameter("@Bill_Category", ddlbillcategory.SelectedValue.ToString()));

                sb = new StringBuilder();
                sb.Append("   DELETE rt.* FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid   ");
                sb.Append("   WHERE rt.panel_id=@panel_id and rt.Rate=0 ");
                if (DeptString.Trim() != "")
                {
                    sb.Append("   AND itm.SubCategoryID in(" + DeptString + ") ");
                }
                else
                {
                    sb.Append(" AND itm.Bill_Category=@Bill_Category ");
                }
                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@panel_id", ddlTPanel.SelectedValue),
                    new MySqlParameter("@Bill_Category", ddlbillcategory.SelectedValue.ToString()));

                StringBuilder sbInsert = new StringBuilder();
                sbInsert.Append(" INSERT INTO f_ratelist (  ");
                sbInsert.Append(" Rate,ERate,FromDate,IsCurrent,ItemID,Panel_ID, ");
                sbInsert.Append(" itemcode,ItemDisplayName,UpdateBy,UpdateRemarks,UpdateDate) ");
                sbInsert.Append(" SELECT round(rt.Rate*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) Rate,rt.ERate,CURRENT_DATE,'1' IsCurrent,rt.ItemID,'" + ddlTPanel.SelectedValue + "' Panel_ID,");
                sbInsert.Append("  itemcode,ItemDisplayName,'" + UserInfo.ID + "'UpdateBy,'Transfer panel rate from " + ddlSPanel.SelectedValue + " ' UpdateRemarks,NOW() UpdateDate  ");
                sbInsert.Append("  FROM f_ratelist rt  ");
                sbInsert.Append(" INNER JOIN rateTemp itm ON itm.itemid= rt.itemid     ");
                sbInsert.Append(" WHERE rt.Panel_ID=@Panel_ID ");
                sbInsert.Append("  and rt.`SpecialFlag`=0 ");

                MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sbInsert.ToString(),
                    new MySqlParameter("@Panel_ID", ddlSPanel.SelectedValue));
            }


            sb_1 = new StringBuilder();
            sb_1.Append("   select  * FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID='" + ddlTPanel.SelectedValue + "' ");
            sb_1.Append("   WHERE rt.panel_id='" + ddlTPanel.SelectedValue + "'");
          
            DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, sb_1.ToString()).Tables[0];

            for (int j = 0; j < dt_LTD_1.Rows.Count; j++)
            {


                for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
                {
                    string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                    if ((Util.GetString(dt_LTD_1.Rows[j][i]) != Util.GetString(dt_LTD_2.Rows[j][i])))
                    {
                        sb_1 = new StringBuilder();
                        sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress) ");
                        sb_1.Append("  values('TransferRate Update','" + Util.GetString(dt_LTD_1.Rows[j][i]) + "','" + Util.GetString(dt_LTD_2.Rows[j][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2.Rows[j][i] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_1.Rows[j][i]) + " to " + Util.GetString(dt_LTD_2.Rows[j][i]) + "','" + StockReports.getip() + "');  ");
                        MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sb_1.ToString());
                    }
                }
            }


            objTran.Commit();

            // resetData();
            lblMsg.Text = "Record saved successfully.";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            objTran.Rollback();
        }
        finally
        {
            objTran.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void resetData()
    {
        ddlSPanel.SelectedIndex = 0;
        ddlDepartment.SelectedIndex = 0;
        rdoType.SelectedValue = "1";
        txtRate.Text = "0";
        ddlTPanel.SelectedIndex = 0;
    }

    //    private void mrptomrpsp()
    //  {
    //      float rate = 0f;

    //      rate = Util.GetFloat(txtRate.Text.Trim());
    //      if (ddlSPanel.SelectedValue == ddlTPanel.SelectedValue)
    //      {
    //          lblMsg.Text = "Source Panel and Target Panel cannot be same.";
    //          return;
    //      }
    //      else if ((ddlSPanel.Items.Count == 0) || (ddlTPanel.Items.Count == 0))
    //      {
    //          lblMsg.Text = "Source Panel or Target Panel cannot be Empty.";
    //          return;
    //      }

    //      MySqlConnection con = new MySqlConnection();
    //      con = Util.GetMySqlCon();
    //      con.Open();

    //      MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.Serializable);
    //      try
    //      {
    //              StringBuilder sb2 = new StringBuilder();
    //              sb2.Append("   select count(*) FROM f_ratelist rt INNER JOIN f_itemmaster itm ON itm.ItemID=rt.itemid ");
    //              sb2.Append("   WHERE rt.panel_id='" + ddlSPanel.SelectedValue + "' AND itm.Bill_Category='" + ddlbillcategory.SelectedValue.ToString() + "' ");

    //              int flag = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb2.ToString()));

    //              if (flag == 0)
    //              {
    //                  lblMsg.Text = " Wrong source panel selected !!! ";
    //                  objTran.Rollback();
    //                  con.Close();
    //                  con.Dispose();
    //                  return;
    //              }

    //              string sql = "";
    //              sql = @"SELECT rl.mrp_rate,rl.itemid FROM f_ratelist rl
    //INNER JOIN f_itemmaster itm ON itm.ItemID=rl.itemid
    //WHERE panel_id='" + ddlSPanel.SelectedValue + "' AND itm.Bill_Category='" + ddlbillcategory.SelectedValue.ToString() + "'";

    //              DataTable dtrate = MySqlHelper.ExecuteDataset(objTran, CommandType.Text, sql).Tables[0];
    //              foreach (DataRow dw in dtrate.Rows)
    //              {
    //                  sql = "update f_ratelist set mrp_rate=round(" + dw["mrp_rate"] + "*(100" + ddlCalc.SelectedValue + "" + Util.GetFloat(txtRate.Text) + ")*0.01) where itemid='" + dw["itemid"].ToString() + "' and panel_id='" + ddlTPanel.SelectedValue + "' ";
    //                  MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sql);
    //              }

    //          objTran.Commit();
    //          con.Close();
    //          con.Dispose();
    //          lblMsg.Text = "Record saved successfully.";
    //      }
    //      catch (Exception ex)
    //      {
    //          objTran.Rollback();
    //          con.Close();
    //          con.Dispose();
    //      }

    //  }
    [WebMethod]
    public static string getDisc(string Panel_ID)
    {
        string DiscPer = StockReports.ExecuteScalar("Select ifnull(DiscPercent,'0') from f_panel_master where panel_id='" + Panel_ID.Trim() + "'");
        return DiscPer;
    }

    private void bindbillingCategory()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Name FROM billingCategory_master where IsActive=1 ORDER BY Name ");
        ddlbillcategory.DataSource = dt;
        ddlbillcategory.DataTextField = "Name";
        ddlbillcategory.DataValueField = "ID";
        ddlbillcategory.DataBind();
        ddlbillcategory.Items.Insert(0, new ListItem("Select", "0"));
    }
    [WebMethod]
    public static string getpaneldetail(string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string Panelname = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Company_Name FROM f_panel_master WHERE Panel_ID IN(SELECT ReferenceCodeOpd FROM f_panel_master WHERE Panel_ID=@PanelID)",
                      new MySqlParameter("@PanelID", PanelID)));
                return Panelname;
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}