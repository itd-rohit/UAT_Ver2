using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_Utility_DiscountOnCashBulk : System.Web.UI.Page
{
    // string _NewPanelID = "89";
    int _SameDayCash = 1;
    string _BackupDatatase = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            _BackupDatatase = "mdrc_utility";
            if (Session["RoleID"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            FrmDate.SetCurrentDate();
            ToDate.SetCurrentDate();
            bindCenter();
            bindPanel();
            binddepartment();
            binddoctor();

        }
    }

    public void binddoctor()
    {


        string str = "SELECT NAME,doctor_id FROM `doctor_referal` WHERE isactive=1 ORDER BY NAME ";
        DataTable dt = StockReports.GetDataTable(str);

        chkdoctor.DataSource = dt;
        chkdoctor.DataTextField = "NAME";
        chkdoctor.DataValueField = "doctor_id";
        chkdoctor.DataBind();


    }

    public void binddepartment()
    {


        string str = "SELECT distinct displayName FROM f_subcategorymaster WHERE active=1 ORDER BY displayName ";
        DataTable dt = StockReports.GetDataTable(str);

        ckdepartment.DataSource = dt;
        ckdepartment.DataTextField = "displayName";
        ckdepartment.DataValueField = "displayName";
        ckdepartment.DataBind();


    }
    public void bindPanel()
    {


        string str = "SELECT Company_Name,Panel_ID FROM f_panel_master where IsActive=1 and Payment_Mode='CASH' ORDER BY IF(Panel_ID=78,1,Company_Name); ";
        DataTable dt = StockReports.GetDataTable(str);

        chkPanel.DataSource = dt;
        chkPanel.DataTextField = "Company_Name";
        chkPanel.DataValueField = "Panel_ID";
        chkPanel.DataBind();


        str = "SELECT Panel_ID,Company_Name FROM f_panel_master WHERE  IsActive=1 and Payment_Mode='CASH' ORDER BY company_name";
        dt = StockReports.GetDataTable(str);
        chkTargetPanel.DataSource = dt;
        chkTargetPanel.DataTextField = "Company_Name";
        chkTargetPanel.DataValueField = "Panel_ID";
        chkTargetPanel.DataBind();
        /*for (int i = 0; i < chkTargetPanel.Items.Count; i++)
        {
            chkTargetPanel.Items[i].Selected = true;

        }*/
    }
    public void bindCenter()
    {
        string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where cm.CentreID in (1,44) and cm.isActive=1 order by cm.Centre  ";

        DataTable dt = StockReports.GetDataTable(str);
        chkCentre.DataSource = dt;
        chkCentre.DataTextField = "Centre";
        chkCentre.DataValueField = "CentreID";
        chkCentre.DataBind();
        for (int i = 0; i < chkCentre.Items.Count; i++)
        {
            chkCentre.Items[i].Selected = true;
        }


    }
    public string Search()
    {

        lblMsg.Text = "";
        string PanelList = StockReports.GetSelection(chkPanel);

        if (PanelList == "")
        {
            lblMsg.Text = "Please Select Panel...!!!";
            return "";
        }


        string PanelListTarget = StockReports.GetSelection(chkTargetPanel);
        if (PanelListTarget == "")
        {
            lblMsg.Text = "Please Select Target Panel...!!!";
            return "";
        }


        string CentreList = StockReports.GetSelection(chkCentre);
        if (CentreList == "")
        {
            lblMsg.Text = "Please Select Centre...!!!";
            return "";
        }

        string DoctorList = StockReports.GetSelection(chkdoctor);
        if (DoctorList == "")
        {
            //  lblMsg.Text = "Please Select Doctor...!!!";
            //  return "";
        }

        string DepartmentList = StockReports.GetSelection(ckdepartment);
        if (DepartmentList == "")
        {
            lblMsg.Text = "Please Select Department...!!!";
            return "";
        }
        StringBuilder sb = new StringBuilder();
        string dtFrom = FrmDate.GetDateForDataBase() + " 00:00:00";
        string dtTo = ToDate.GetDateForDataBase() + " 23:59:59";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            sb.AppendLine("  DELETE FROM utility_change_panel;  ");
            sb.AppendLine("  INSERT INTO utility_change_panel(LedgerTransactionID,LedgerTransactionNo,ItemID,Amount,Rate,DiscountPercentage,Description,NetAmount,GrossAmount,DiscountOnTotal,Panel_ID,NewGross,NewDisc,NewNet,NewPanelID,IsRepeat)   ");
            sb.AppendLine("  SELECT lt.LedgerTransactionID,lt.`LedgerTransactionNo`,ltd.`ItemID`,ltd.`Amount`,ltd.`Rate`,0 `DiscountPercentage`,sc.`Description`, lt.NetAmount,lt.GrossAmount,lt.DiscountOnTotal,lt.Panel_ID, ltd.`Rate` NewGross,0000000000000.00 NewDisc,ltd.`Rate` NewNet, ");
            // sb.AppendLine("  ifnull(round((SELECT pnl1.Panel_ID FROM `f_panel_master` pnl1 inner join f_ratelist rt on rt.panel_id=pnl1.Panel_id  and rt.rate>0 WHERE pnl1.panel_id in (" + PanelListTarget + ") and rt.itemid=ltd.itemid  ORDER BY RAND() LIMIT 1),0),lt.Panel_ID)NewPanelID,0 IsRepeat ");
            sb.AppendLine("  ifnull((SELECT pnl1.Panel_ID FROM `f_panel_master` pnl1 WHERE pnl1.panel_id in (" + PanelListTarget + ") ORDER BY RAND() LIMIT 1),lt.Panel_ID)NewPanelID,0 IsRepeat ");

            sb.AppendLine("  FROM `f_ledgertransaction` lt  ");
            sb.AppendLine("  INNER JOIN (SELECT SUM(r.`Amount`) Amount,r.LedgerTransactionID FROM f_receipt r   ");
            sb.AppendLine("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID = r.LedgerTransactionID  ");
            sb.AppendLine("  AND r.IsCancel=0 AND r.PaymentModeID=1 AND lt.IsCredit=0    ");
            if (_SameDayCash == 1)
            {
                sb.AppendLine("  and r.CreatedDate >='" + dtFrom + "' ");
                sb.AppendLine("  AND r.CreatedDate <= '" + dtTo + "' ");
            }
            else
            {
                sb.AppendLine("  and LT.Date >='" + dtFrom + "' ");
                sb.AppendLine("  AND LT.Date <= '" + dtTo + "'  ");
            }
            sb.AppendLine("  AND lt.CentreID IN (" + CentreList + ") ");
            sb.AppendLine("  AND lt.Panel_ID IN (" + PanelList + ")  ");
            sb.AppendLine("  GROUP BY  r.LedgerTransactionID  ) r ON lt.LedgerTransactionID = r.LedgerTransactionID  ");
            sb.AppendLine("  AND lt.NetAmount = r.Amount  ");
            sb.AppendLine("  AND lt.Date >= '" + dtFrom + "'   ");
            sb.AppendLine("  AND lt.Date <= '" + dtTo + "'  ");
            sb.AppendLine("  AND lt.CentreID IN (" + CentreList + ") ");
            sb.AppendLine("  AND lt.Panel_ID IN (" + PanelList + ")  ");
            sb.AppendLine("  AND lt.NetAmount>0 ");
            sb.AppendLine("  AND lt.DiscountOnTotal=0 ");
            sb.AppendLine("  INNER JOIN patient_labinvestigation_opd ltd ON ltd.LedgerTransactionID=lt.LedgerTransactionID AND IF(isPackage=1,SubCategoryID=15,SubCategoryID!=15) ");
            sb.AppendLine("  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=ltd.SubCategoryID   ");
            if (DoctorList != "")
            {
                sb.AppendLine("  and lt.Doctor_ID in (" + DoctorList + ") ");

            }
            sb.AppendLine("  order by rand() ;  ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_1.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.AppendLine("  DELETE t.* FROM utility_change_panel t Inner JOIN patient_labinvestigation_opd plo ON t.LedgerTransactionID=plo.LedgerTransactionID WHERE plo.BarcodeNo=''; ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_2.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());


            sb = new StringBuilder();
            sb.AppendLine("  DELETE FROM utility_change_panel WHERE Description NOT IN (" + DepartmentList + "); ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_2.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.AppendLine("  DELETE a.* FROM utility_change_panel a INNER JOIN ");
            sb.AppendLine("  ( SELECT LedgerTransactionID,SUM(Amount) FROM utility_change_panel GROUP BY LedgerTransactionID HAVING SUM(Amount) < " + Util.GetInt(txtMinAmount.Text) + " ) b ");
            sb.AppendLine("  ON a.LedgerTransactionID=b.LedgerTransactionID; ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_3.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.AppendLine("  UPDATE utility_change_panel a INNER JOIN  ");
            sb.AppendLine("  ( SELECT LedgerTransactionID,NewPanelID FROM utility_change_panel GROUP BY LedgerTransactionID) b ");
            sb.AppendLine("  ON a.LedgerTransactionID=b.LedgerTransactionID SET a.NewPanelID=b.NewPanelID ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_4.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.AppendLine("  UPDATE utility_change_panel ut1 ");
            sb.AppendLine("  inner join f_panel_master pm on pm.panel_id=ut1.NewPanelID ");
            sb.AppendLine("  inner JOIN f_ratelist r ON  r.ItemID=ut1.ItemID AND  r.Panel_ID=pm.ReferenceCode and IFNULL(r.Rate,0)> 0 ");
            sb.AppendLine("  SET ut1.NewGross = r.Rate ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_5.txt", sb.ToString());
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());

            sb = new StringBuilder();
            sb.AppendLine("  SELECT COUNT(DISTINCT LedgerTransactionID) PtCount, ROUND(SUM(Amount))NetAmount,round(SUM(Rate))GrossAmount,ROUND(SUM(Rate-Amount))DiscountOnTotal,  ");
            sb.AppendLine("  SUM(NewGross)NewGross FROM utility_change_panel; ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_6.txt", sb.ToString());           
            DataTable dt = MySqlHelper.ExecuteDataset(tranX, CommandType.Text, sb.ToString()).Tables[0];


            if (dt.Rows.Count > 0)
            {
                lblEditCountEt.Text = dt.Rows[0]["PtCount"].ToString();
                lblGrossAmtEditPt.Text = dt.Rows[0]["GrossAmount"].ToString();
                lblDiscAmtEditPt.Text = dt.Rows[0]["DiscountOnTotal"].ToString();
                lblNetAmtEditPt.Text = dt.Rows[0]["NetAmount"].ToString();

                lblPtCountNewPnl.Text = dt.Rows[0]["PtCount"].ToString();
                lblDiscAmtNewPnl.Text = "0";
                lblGrossAmtNewPnl.Text = dt.Rows[0]["NewGross"].ToString();
                lblNetAmtNewPnl.Text = dt.Rows[0]["NewGross"].ToString();
                lblNetAmtNewPnlFinal.Text = dt.Rows[0]["NewGross"].ToString();
            }


            sb = new StringBuilder();
            sb.AppendLine(" SELECT round(SUM(Amount),2)AmtCash FROM f_receipt where CreatedDate >= '" + dtFrom + "' AND CreatedDate <= '" + dtTo + "' and PaymentModeID=1  AND IsCancel=0  AND CentreID IN (" + CentreList + ")  AND Panel_ID IN (" + PanelList + "); ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_7.txt", sb.ToString());
            double TotalCash = Util.GetDouble(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, sb.ToString()));

            lblTotalCash.Text = TotalCash + "";


            sb = new StringBuilder();

            sb.AppendLine(" SELECT COUNT(1) PtCount,round(SUM(lt.GrossAmount),2)GrossAmount,round(SUM(lt.DiscountOnTotal),2)DiscountOnTotal, ");
            sb.AppendLine(" round(SUM(lt.NetAmount),2)NetAmount  ");
            sb.AppendLine(" FROM f_ledgertransaction lt  where LT.Date >= '" + dtFrom + "' AND LT.Date <= '" + dtTo + "'  AND lt.CentreID IN (" + CentreList + ")  AND Panel_ID IN (" + PanelList + "); ");
            System.IO.File.WriteAllText("C:\\LedgerTransaction_8.txt", sb.ToString());
            dt = MySqlHelper.ExecuteDataset(tranX, CommandType.Text, sb.ToString()).Tables[0];
            if (dt.Rows.Count > 0)
            {
                lblPtCountAll.Text = dt.Rows[0]["PtCount"].ToString();
                lbGrossAmtAll.Text = dt.Rows[0]["GrossAmount"].ToString();
                lblDiscAmtAll.Text = dt.Rows[0]["DiscountOnTotal"].ToString();
                lblNetAmtAll.Text = dt.Rows[0]["NetAmount"].ToString();
                lblNetAmtAllFinal.Text = Util.GetString(Util.GetDouble(dt.Rows[0]["NetAmount"].ToString()) + Util.GetDouble(lblDiscAmtEditPt.Text) - (Util.GetDouble(lblGrossAmtEditPt.Text) - Util.GetDouble(lblGrossAmtNewPnl.Text)));
                lblGrossAmtAllFinal.Text = Util.GetString(Util.GetDouble(dt.Rows[0]["GrossAmount"].ToString()) - (Util.GetDouble(lblGrossAmtEditPt.Text) - Util.GetDouble(lblGrossAmtNewPnl.Text)));
                lblCashAfterUtility.Text = Util.GetString(Util.GetDouble(lblTotalCash.Text) + Util.GetDouble(lblDiscAmtEditPt.Text) - (Util.GetDouble(lblGrossAmtEditPt.Text) - Util.GetDouble(lblGrossAmtNewPnl.Text)));

            }
            return "";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error";
			return "";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnShow_Click(object sender, EventArgs e)
    {
        Search();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string PanelList = StockReports.GetSelection(chkPanel);
        if (PanelList == "")
        {
            lblMsg.Text = "Please Select Panel...!!!";
            return;
        }
        string CentreList = StockReports.GetSelection(chkCentre);
        if (CentreList == "")
        {
            lblMsg.Text = "Please Select Centre...!!!";
            return;
        }



        StringBuilder sb = new StringBuilder();
        if (Session["ID"] != null)
        {

            string dtFrom = FrmDate.GetDateForDataBase() + " 00:00:00";
            string dtTo = ToDate.GetDateForDataBase() + " 23:59:59";

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                
                sb = new StringBuilder();
                #region Backup
                sb.AppendLine(" update " + _BackupDatatase + ".f_ledgertransaction lt  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=lt.LedgerTransactionID  ");
                sb.AppendLine(" set ut.IsRepeat=1;  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.AppendLine(" INSERT INTO " + _BackupDatatase + ".f_ledgertransaction  ");
                sb.AppendLine(" SELECT distinct lt.*  ");
                sb.AppendLine(" FROM f_ledgertransaction lt  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=lt.LedgerTransactionID and ut.IsRepeat=0; ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                sb = new StringBuilder();
                sb.AppendLine(" INSERT INTO " + _BackupDatatase + ".patient_labinvestigation_opd  ");
                sb.AppendLine(" SELECT ltd.*  ");
                sb.AppendLine(" FROM patient_labinvestigation_opd ltd  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=ltd.LedgerTransactionID  and ut.IsRepeat=0 GROUP BY ltd.Test_ID;");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.AppendLine(" INSERT INTO " + _BackupDatatase + ".patient_labinvestigation_opd_share  ");
                sb.AppendLine(" SELECT ltd.*  ");
                sb.AppendLine(" FROM patient_labinvestigation_opd_share ltd  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=ltd.LedgerTransactionID  and ut.IsRepeat=0 GROUP BY ltd.Test_ID;");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.AppendLine(" INSERT INTO " + _BackupDatatase + ".f_receipt  ");
                sb.AppendLine(" SELECT distinct r2.* FROM f_receipt r2    ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=r2.LedgerTransactionID  and ut.IsRepeat=0  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                # endregion
                sb = new StringBuilder();

                #region UpdatePanelRate

                sb.AppendLine(" UPDATE patient_labinvestigation_opd ltd  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=ltd.LedgerTransactionID and ut.ItemID=ltd.ItemID AND  IF(ltd.isPackage=1,ltd.`SubCategoryID`=15,ltd.`SubCategoryID`!=15)  ");
                sb.AppendLine(" SET ltd.Rate=ut.NewGross, ltd.Amount=ut.NewGross; ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                #endregion
                #region UpdateDiscount

                sb.AppendLine(" UPDATE f_ledgertransaction lt  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=lt.LedgerTransactionID  ");
                sb.AppendLine(" INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID ");
                sb.AppendLine(" SET lt.NetAmount= (SELECT SUM(ltd.amount) FROM patient_labinvestigation_opd ltd WHERE ltd.LedgerTransactionID=lt.LedgerTransactionID),  ");
                sb.AppendLine(" lt.GrossAmount= (SELECT SUM(ltd.Rate) FROM patient_labinvestigation_opd ltd WHERE ltd.LedgerTransactionID=lt.LedgerTransactionID),  ");
                sb.AppendLine(" lt.Adjustment= (SELECT SUM(ltd.amount) FROM patient_labinvestigation_opd ltd WHERE ltd.LedgerTransactionID=lt.LedgerTransactionID),  ");
                sb.AppendLine(" lt.IsReturnable=1, ");
                sb.AppendLine(" lt.AdjustmentDate=lt.Date,  ");
                sb.AppendLine(" pm.PName=concat(pm.PName,'.'),lt.PName=CONCAT(lt.PName,'.');  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                /*sb = new StringBuilder();
                sb = new StringBuilder();
                sb.AppendLine(" SET @runtot:=0; ");
                sb.AppendLine(" UPDATE utility_change_panel SET NewDisc = ifnull(ROUND('" + _DiscAmount + "'-(@runtot := @runtot + NewGross)),0); ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();
                sb.AppendLine(" UPDATE patient_labinvestigation_opd ltd  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=ltd.LedgerTransactionID  and ltd.ItemID=ut.ItemID  ");
                sb.AppendLine(" SET ltd.DiscountPercentage= (CASE WHEN NewDisc >=0 THEN 100 WHEN NewDisc <0 and (NewGross+NewDisc) > 0 THEN (((NewGross+NewDisc)*100)/NewGross) ELSE 0 END),  ");
                sb.AppendLine(" ltd.Amount=(CASE WHEN NewDisc >=0 THEN 0 WHEN NewDisc <0 and (NewGross+NewDisc) > 0 THEN (NewGross-(NewGross+NewDisc)) ELSE NewGross END);   "); 
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();
                

                sb = new StringBuilder();
                sb.AppendLine(" UPDATE f_ledgertransaction lt  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionNo=lt.LedgerTransactionNo  ");
                sb.AppendLine(" SET lt.NetAmount= (SELECT SUM(ltd.amount) FROM patient_labinvestigation_opd ltd WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo),  ");
                sb.AppendLine(" lt.AmtCash= round((SELECT SUM(ltd.amount) FROM patient_labinvestigation_opd ltd WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo)),  ");
                sb.AppendLine(" lt.GrossAmount= (SELECT SUM(ltd.Rate) FROM patient_labinvestigation_opd ltd WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo),  ");
                sb.AppendLine(" lt.AmtCheque=0,  ");
                sb.AppendLine(" lt.AmtCredit=0,  ");
                sb.AppendLine(" lt.AmtCreditCard=0,  ");
                sb.AppendLine(" lt.Adjustment= round((SELECT SUM(ltd.amount) FROM patient_labinvestigation_opd ltd WHERE ltd.LedgerTransactionNo=lt.LedgerTransactionNo)),  ");
                sb.AppendLine(" lt.AdjustmentDate=lt.Date;  "); 
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();
                 */

                sb = new StringBuilder();
                sb.AppendLine(" UPDATE f_receipt r  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=r.LedgerTransactionID  ");
                sb.AppendLine(" AND r.LedgerNoCr !='OPD003'  ");
                sb.AppendLine(" AND r.IsCancel=0  ");
                sb.AppendLine(" SET r.IsCancel=1,r.CancelDate=NOW(),r.Cancel_UserID=1,r.CancelReason='**WRONG ENTRY**',  ");
                sb.AppendLine(" r.Updatedate=NOW(),r.UpdateRemarks='**WRONG ENTRY**';  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.AppendLine(" UPDATE f_receipt r  ");
                sb.AppendLine(" INNER JOIN utility_change_panel ut ON ut.LedgerTransactionID=r.LedgerTransactionID  ");
                sb.AppendLine(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=ut.LedgerTransactionID  ");
                sb.AppendLine(" AND r.LedgerNoCr ='OPD003' AND r.IsCancel=0  ");
                sb.AppendLine(" SET r.Amount=round(lt.NetAmount),S_Amount=round(lt.NetAmount);  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                #endregion

             

                tnx.Commit();
                lblMsg.Text = "Record Saved successfully ";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Please Contact to It Admin" + "\n" + ex.ToString();
                tnx.Rollback();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return;

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

        }
    }
}
