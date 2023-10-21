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

public partial class Design_EDP_DiscountOnCashBulk : System.Web.UI.Page
{
   // string _NewPanelID = "89";
    int _SameDayCash = 1;
    string _BackupDatatase = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            _BackupDatatase=Request.Url.AbsolutePath.Split('/')[1] + "_utility_panel";
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
            //lblNewPanel.Text = "Note : Target Panel is " + StockReports.ExecuteScalar("select company_name from f_panel_master where Panel_ID='"+_NewPanelID+"' ");
            
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


        string str = "SELECT distinct displayName FROM f_subcategorymaster WHERE active='1' ORDER BY displayName ";
        DataTable dt = StockReports.GetDataTable(str);

        ckdepartment.DataSource = dt;
        ckdepartment.DataTextField = "displayName";
        ckdepartment.DataValueField = "displayName";
        ckdepartment.DataBind();


    }
    public void bindPanel()
    {


        string str = "SELECT Company_Name,Panel_ID FROM f_panel_master where IsActive=1 ORDER BY Company_Name";
        DataTable dt = StockReports.GetDataTable(str);

        chkPanel.DataSource = dt;
        chkPanel.DataTextField = "Company_Name";
        chkPanel.DataValueField = "Panel_ID";
        chkPanel.DataBind();


        str = "SELECT Panel_ID,Company_Name FROM f_panel_master WHERE  IsActive=1 ORDER BY company_name";
        dt = StockReports.GetDataTable(str);

        chkTargetPanel.DataSource = dt;
        chkTargetPanel.DataTextField = "Company_Name";
        chkTargetPanel.DataValueField = "Panel_ID";
        chkTargetPanel.DataBind();

        for (int i = 0; i < chkTargetPanel.Items.Count; i++)
        {
            chkTargetPanel.Items[i].Selected = true;

        }



    }
    public void bindCenter()
    {
        string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' and AccessType=2 ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  ";
        
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
            lblMsg.Text = "Please Select Doctor...!!!";
            return "";
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




        sb.Append(" DROP TABLE IF EXISTS _utility;  ");
        sb.Append(" CREATE TABLE _utility  ");
        sb.Append(" SELECT lt.`LedgerTransactionNo`,ltd.`ItemID`,ltd.`Amount`,ltd.`Rate`,ltd.`DiscountPercentage`,sc.`Description`, lt.NetAmount,lt.GrossAmount,lt.DiscountOnTotal,lt.Panel_ID, ltd.`Rate` NewGross,0000000000000.00 NewDisc,ltd.`Rate` NewNet, ");
        sb.Append(" ifnull(round((SELECT pnl1.Panel_ID FROM `f_panel_master` pnl1 inner join f_ratelist rt on rt.panel_id=pnl1.Panel_id  and rt.rate>0 WHERE pnl1.panel_id in (" + PanelListTarget + ") and rt.itemid=ltd.itemid  ORDER BY RAND() LIMIT 1),0),lt.Panel_ID)NewPanelID,0 IsRepeat ");
        sb.Append(" FROM `f_ledgertransaction` lt  ");
        sb.Append(" INNER JOIN   ");
        sb.Append(" (SELECT SUM(r.`AmountPaid`)`AmountPaid`,r.AsainstLedgerTnxNo FROM `f_reciept` r   ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo` = r.`AsainstLedgerTnxNo`  ");
        sb.Append(" AND r.`IsCancel`=0 AND r.`AmtCheque`=0 AND r.`AmtCredit`=0 AND r.`AmtCreditCard`=0     ");
        if (_SameDayCash == 1)
        {
            sb.Append(" and r.`Date` >='" + dtFrom + "' ");
            sb.Append(" AND r.`Date` <= '" + dtTo + "' AND lt.`IsCancel`=0 ");
        }
        else
        {
            sb.Append(" and LT.`Date` >='" + dtFrom + "' ");
            sb.Append(" AND LT.`Date` <= '" + dtTo + "' AND lt.`IsCancel`=0 ");
        }
        sb.Append(" AND lt.`IsCancel`=0  ");
        sb.Append(" AND lt.`CentreID` IN (" + CentreList + ") ");
        sb.Append(" AND lt.`Panel_ID` IN (" + PanelList + ")  ");
        sb.Append(" GROUP BY  r.AsainstLedgerTnxNo  ) r ON lt.`LedgerTransactionNo` = r.`AsainstLedgerTnxNo`  ");
        sb.Append(" AND lt.`NetAmount` = r.AmountPaid  ");
        sb.Append(" AND lt.`Date` >= '" + dtFrom + "'   ");
        sb.Append(" AND lt.`Date` <= '" + dtTo + "'  ");
        sb.Append(" AND lt.`IsCancel`=0  ");
        sb.Append(" AND lt.`CentreID` IN (" + CentreList + ") ");
        sb.Append(" AND lt.`Panel_ID` IN (" + PanelList + ")  ");
        sb.Append(" AND lt.`NetAmount`>0 ");
        if (!chkDiscount.Checked)
            sb.Append(" AND lt.`DiscountOnTotal`=0 ");
        sb.Append(" INNER JOIN `f_ledgertnxdetail` ltd ON ltd.`LedgerTransactionNo`=lt.`LedgerTransactionNo` and ltd.`DiscountPercentage`<100 ");
        sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=ltd.`SubCategoryID`   ");
        sb.Append(" INNER JOIN `patient_medical_history` pmh ON pmh.`Transaction_ID`=lt.`Transaction_ID` ");
        sb.Append(" and pmh.`ReferedBy` in (" + DoctorList + ") ");
        sb.Append(" order by rand() ;  ");

        StockReports.ExecuteDML(sb.ToString());

        // Delete departments 
        sb = new StringBuilder();
        sb.Append(" DELETE FROM _utility WHERE Description NOT IN (" + DepartmentList + ")");
        StockReports.ExecuteDML(sb.ToString());

        // Delete minimum amount
        sb = new StringBuilder();
        sb.Append(" DELETE a.* FROM _utility a INNER JOIN ");
        sb.Append(" ( SELECT LedgerTransactionNo,SUM(Amount) FROM _utility GROUP BY LedgerTransactionNo HAVING SUM(Amount) < " + Util.GetInt(txtMinAmount.Text) + " ) b ");
        sb.Append(" ON a.LedgerTransactionNo=b.LedgerTransactionNo ");
        StockReports.ExecuteDML(sb.ToString());

        sb = new StringBuilder();
        sb.Append(" UPDATE _utility a INNER JOIN  ");
        sb.Append(" ( SELECT LedgerTransactionNo,NewPanelID FROM _utility GROUP BY LedgerTransactionNo ) b ");
        sb.Append(" ON a.LedgerTransactionNo=b.LedgerTransactionNo ");
        sb.Append(" SET a.NewPanelID=b.NewPanelID ");


        sb = new StringBuilder();
        sb.Append(" ALTER TABLE _utility ADD KEY aa(LedgerTransactionNo), ADD INDEX (`ItemID`, `NewPanelID`);  ");
        StockReports.ExecuteDML(sb.ToString());

        sb = new StringBuilder();
        sb.Append(" UPDATE _utility ut1 ");
        sb.Append(" inner join f_panel_master pm on pm.panel_id=ut1.NewPanelID ");
        sb.Append(" inner JOIN `f_ratelist` r ON  r.`ItemID`=ut1.`ItemID` AND  r.`Panel_ID`=pm.`ReferenceCode` and IFNULL(r.`Rate`,0)> 0 ");
        sb.Append(" SET ut1.NewGross = r.`Rate` ");
         StockReports.ExecuteDML(sb.ToString());

        // -----------------------------------

        //sb.Append(" SELECT COUNT(*) PtCount,SUM(lt.`GrossAmount`)GrossAmount,SUM(lt.`DiscountOnTotal`)DiscountOnTotal, ");
        //sb.Append(" SUM(lt.`NetAmount`)NetAmount,SUM(ifnull(r.`AmountPaid`,0))AmountPaid,sum(ifnull(NewGross,0))NewGross  ");        
        //sb.Append(" FROM `f_ledgertransaction` lt ");
        //sb.Append(" INNER JOIN  ");
        //sb.Append(" (SELECT SUM(ifnull(r.`AmountPaid`,0))`AmountPaid`,r.AsainstLedgerTnxNo FROM `f_reciept` r  ");
        //sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo` = r.`AsainstLedgerTnxNo` ");
        //sb.Append(" AND r.`IsCancel`=0 AND r.`AmtCheque`=0 AND r.`AmtCredit`=0 AND r.`AmtCreditCard`=0   ");
        //if (_SameDayCash == 1)
        //{
        //    sb.Append(" AND r.`Date` >='" + dtFrom + "' ");
        //    sb.Append(" AND r.`Date` <= '" + dtTo + "' AND lt.`IsCancel`=0 ");
        //}
        //else
        //{
        //    sb.Append(" AND LT.`Date` >='" + dtFrom + "' ");
        //    sb.Append(" AND LT.`Date` <= '" + dtTo + "' AND lt.`IsCancel`=0 ");
        //}
        //sb.Append(" AND lt.`CentreID` IN (" + CentreList + ") ");
        //sb.Append(" AND lt.`Panel_ID` IN (" + PanelList + ") GROUP BY r.AsainstLedgerTnxNo  ) r ON lt.`LedgerTransactionNo` = r.`AsainstLedgerTnxNo` ");
        //sb.Append(" AND lt.`NetAmount` = r.AmountPaid ");
        //sb.Append(" AND LT.`Date` >= '" + dtFrom + "'  ");
        //sb.Append(" AND LT.`Date` <= '" + dtTo + "'  ");
        //sb.Append(" AND lt.`IsCancel`=0 ");
        //sb.Append(" AND lt.`CentreID` IN (" + CentreList + ") ");
        //sb.Append(" AND lt.`Panel_ID` IN (" + PanelList + ") ");
        //sb.Append(" AND lt.`NetAmount`>0 AND lt.`DiscountOnTotal`=0  ");
        //// get new panel rate
        //sb.Append(" INNER JOIN (SELECT SUM(if(ifnull(r.`Rate`,0)=0,ltd.Rate,r.rate))NewGross,lt.`LedgerTransactionNo` FROM `f_ledgertnxdetail` ltd ");
        //sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=ltd.`LedgerTransactionNo` ");
        //sb.Append(" AND LT.`Date` >= '" + dtFrom + "'  ");
        //sb.Append(" AND LT.`Date` <= '" + dtTo + "'  ");
        //sb.Append(" AND lt.`IsCancel`=0 ");
        //sb.Append(" AND lt.`CentreID` IN (" + CentreList + ") ");
        //sb.Append(" AND lt.`Panel_ID` IN (" + PanelList + ") ");
        //sb.Append(" left JOIN `f_ratelist`  r ON r.`Panel_ID`='" + _NewPanelID + "' AND r.`ItemID`=ltd.`ItemID` ");
        //sb.Append(" GROUP BY lt.`LedgerTransactionNo` ");
        //sb.Append(" ) ng on ng.`LedgerTransactionNo`=lt.`LedgerTransactionNo` "); 

        //-------------------------------------


        sb = new StringBuilder();
        sb.Append(" SELECT COUNT(DISTINCT `LedgerTransactionNo`) PtCount, ROUND(SUM(Amount))NetAmount,round(SUM(Rate))GrossAmount,ROUND(SUM(`Rate`-Amount))DiscountOnTotal,  ");
        sb.Append(" SUM(NewGross)NewGross FROM _utility ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());


        if (dt.Rows.Count > 0)
        {
            lblEditCountEt.Text = dt.Rows[0]["PtCount"].ToString();
            lblGrossAmtEditPt.Text = dt.Rows[0]["GrossAmount"].ToString();
            lblDiscAmtEditPt.Text = dt.Rows[0]["DiscountOnTotal"].ToString();
            lblNetAmtEditPt.Text = dt.Rows[0]["NetAmount"].ToString();

            lblPtCountNewPnl.Text = dt.Rows[0]["PtCount"].ToString();
            // lblDiscAmtNewPnl.Text = dt.Rows[0]["DiscountOnTotal"].ToString();
            lblDiscAmtNewPnl.Text = "0";
            lblGrossAmtNewPnl.Text = dt.Rows[0]["NewGross"].ToString();
            lblNetAmtNewPnl.Text = dt.Rows[0]["NewGross"].ToString();
            lblNetAmtNewPnlFinal.Text = dt.Rows[0]["NewGross"].ToString();
        }


        sb = new StringBuilder();
        sb.Append(" SELECT round(SUM(AmtCash),2)AmtCash ");
        sb.Append(" FROM `f_reciept`  ");
        sb.Append(" where ");
        sb.Append(" `Date` >= '" + dtFrom + "'  ");
        sb.Append(" AND `Date` <= '" + dtTo + "'  ");
        sb.Append(" AND `IsCancel`=0 ");
        sb.Append(" AND `CentreID` IN (" + CentreList + ") ");
        double TotalCash = Util.GetDouble(StockReports.ExecuteScalar(sb.ToString()));

        lblTotalCash.Text = TotalCash + "";


        sb = new StringBuilder();

        sb.Append(" SELECT COUNT(*) PtCount,round(SUM(lt.`GrossAmount`),2)GrossAmount,round(SUM(lt.`DiscountOnTotal`),2)DiscountOnTotal, ");
        sb.Append(" round(SUM(lt.`NetAmount`),2)NetAmount  ");
        sb.Append(" FROM `f_ledgertransaction` lt ");
        sb.Append(" where ");
        sb.Append(" LT.`Date` >= '" + dtFrom + "'  ");
        sb.Append(" AND LT.`Date` <= '" + dtTo + "'  ");
        sb.Append(" AND lt.`IsCancel`=0 ");
        sb.Append(" AND lt.`CentreID` IN (" + CentreList + ") ");
        //sb.Append(" AND lt.`Panel_ID` IN (" + PanelList + ") ");





        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblPtCountAll.Text = dt.Rows[0]["PtCount"].ToString();
            lbGrossAmtAll.Text = dt.Rows[0]["GrossAmount"].ToString();
            lblDiscAmtAll.Text = dt.Rows[0]["DiscountOnTotal"].ToString();
            lblNetAmtAll.Text = dt.Rows[0]["NetAmount"].ToString();

            //lblNetAmtAllFinal.Text = Util.GetString(Util.GetDouble(dt.Rows[0]["NetAmount"].ToString()) - (Util.GetDouble(lblNetAmtEditPt.Text) - Util.GetDouble(lblNetAmtNewPnl.Text)));
            lblNetAmtAllFinal.Text = Util.GetString(Util.GetDouble(dt.Rows[0]["NetAmount"].ToString()) + Util.GetDouble(lblDiscAmtEditPt.Text) - (Util.GetDouble(lblGrossAmtEditPt.Text) - Util.GetDouble(lblGrossAmtNewPnl.Text)));
            lblGrossAmtAllFinal.Text = Util.GetString(Util.GetDouble(dt.Rows[0]["GrossAmount"].ToString()) - (Util.GetDouble(lblGrossAmtEditPt.Text) - Util.GetDouble(lblGrossAmtNewPnl.Text)));
            lblCashAfterUtility.Text = Util.GetString(Util.GetDouble(lblTotalCash.Text) + Util.GetDouble(lblDiscAmtEditPt.Text) - (Util.GetDouble(lblGrossAmtEditPt.Text) - Util.GetDouble(lblGrossAmtNewPnl.Text)));
          //  lblCashAfterUtility.Text = Util.GetString(Util.GetDouble(lblTotalCash.Text) + Util.GetDouble(lblDiscAmtEditPt.Text) - (Util.GetDouble(lblNetAmtEditPt.Text) - Util.GetDouble(lblNetAmtNewPnl.Text)));
        }



        return "";
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

        if (txtDisc.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter the Discount...!!!";
            txtDisc.Focus();
            return;
        }

        StringBuilder sb = new StringBuilder();
        if (Session["ID"] != null)
        {

            string dtFrom = FrmDate.GetDateForDataBase() + " 00:00:00";
            string dtTo = ToDate.GetDateForDataBase() + " 23:59:59";

            double _DiscAmount = Util.GetDouble(txtDisc.Text.Trim());

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);


            try
            {
                MySqlCommand cmd;



                sb = new StringBuilder();
                // create dummmy table 
                
                

              //  cmd = new MySqlCommand("call `utility`('" + _NewPanelID + "' , '" + _DiscAmount + "')", tnx.Connection, tnx);
              // cmd.ExecuteNonQuery();


                // Lt Backup IsRepeat 
                #region Backup
                sb.Append(" update " + _BackupDatatase + ".f_ledgertransaction lt  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=lt.`LedgerTransactionNo`  ");
                sb.Append(" set ut.IsRepeat=1;  ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();
                sb.Append(" INSERT INTO " + _BackupDatatase + ".f_ledgertransaction  ");
                sb.Append(" SELECT distinct lt.*  ");
                sb.Append(" FROM `f_ledgertransaction` lt  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=lt.`LedgerTransactionNo` and ut.IsRepeat=0 ");
                // sb.Append(" group by lt.`LedgerTransactionNo`  ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();
                               

                sb = new StringBuilder();
                //Ltd Backup
                sb.Append(" INSERT INTO " + _BackupDatatase + ".f_ledgertnxdetail  ");
                sb.Append(" SELECT ltd.*  ");
                sb.Append(" FROM `f_ledgertnxdetail` ltd  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=ltd.`LedgerTransactionNo`  and ut.IsRepeat=0  ");
                sb.Append(" group by ltd.`LedgerTransactionNo`,ltd.ItemID  ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();
                                          
                sb = new StringBuilder();
                // Backup r
                sb.Append(" INSERT INTO " + _BackupDatatase + ".f_reciept  ");
                sb.Append(" SELECT distinct r2.*  ");
                sb.Append(" FROM `f_reciept` r2    ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=r2.`AsainstLedgerTnxNo`  and ut.IsRepeat=0  ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();
                // Backup Pa
                sb.Append(" INSERT INTO " + _BackupDatatase + ".f_patientaccount  ");
                sb.Append(" SELECT distinct pa.*  ");
                sb.Append(" FROM `f_patientaccount` pa   ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=pa.`LedgerTransactionNo`  and ut.IsRepeat=0  ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                # endregion

                sb = new StringBuilder();

                #region UpdatePanelRate

                sb.Append(" UPDATE ");
                sb.Append(" `f_ledgertnxdetail` ltd  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=ltd.`LedgerTransactionNo` and ut.ItemID=ltd.ItemID ");               
                sb.Append(" SET ltd.Rate=ut.NewGross, ltd.Amount=ut.NewGross, ");
                sb.Append(" ltd.`DiscountPercentage`=0; ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();


                #endregion


                #region UpdateDiscount
                // update f_ledgertnxdetail
                //sb.Append(" UPDATE `f_ledgertnxdetail` ltd  ");
                //sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=ltd.`LedgerTransactionNo`  ");
                //sb.Append(" SET ltd.`DiscountPercentage`='" + txtDisc.Text.Trim() + "',  ");
                //sb.Append(" ltd.`Amount` = ROUND(ltd.`Rate`*(100-'" + txtDisc.Text.Trim() + "')*0.01);  ");

                // update f_ledgertransaction
                sb.Append(" UPDATE `f_ledgertransaction` lt  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=lt.`LedgerTransactionNo`  ");
                sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID ");
                sb.Append(" SET ");
                sb.Append(" lt.`DiscountOnTotal` = (SELECT SUM((ltd.`Rate`*ltd.`Quantity`)- ltd.amount) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo),  ");
                sb.Append(" lt.`NetAmount`= (SELECT SUM(ltd.amount) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo),  ");
                //sb.Append(" lt.`AmtCash`= (SELECT SUM(ltd.amount) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo),  ");
                sb.Append(" lt.`GrossAmount`= (SELECT SUM(ltd.Rate) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo),  ");
                //sb.Append(" lt.`AmtCheque`=0,  ");
                //sb.Append(" lt.`AmtCredit`=0,  ");
                //sb.Append(" lt.`AmtCreditCard`=0,  ");
                //sb.Append(" lt.`Adjustment`= (SELECT SUM(ltd.amount) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo),  ");
                sb.Append(" lt.`IsReturnable`=1, ");
                sb.Append(" lt.`AdjustmentDate`=lt.`Date`,  ");
                sb.Append(" pm.PName=concat(pm.PName,'.');  ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();


                //sb.Append(" UPDATE _utility u ");
                //sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON u.`LedgerTransactionNo`=ltd.`LedgerTransactionNo` and ltd.itemid=u.itemid ");
                //sb.Append(" SET u.`GrossAmount`=ltd.`Amount`, ");
                //sb.Append(" u.`NetAmount`=lt.`NetAmount`; ");
                //cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                //cmd.ExecuteNonQuery();

                sb = new StringBuilder();
                sb.Append(" SET @runtot:=0; ");
                sb.Append(" UPDATE _utility  ");
                //sb.Append(" SET `NewDisc` = ifnull(ROUND((('" + _DiscAmount + "'-(@runtot := @runtot + `NewGross`))*100)/NewGross,2),0); ");
                sb.Append(" SET `NewDisc` = ifnull(ROUND('" + _DiscAmount + "'-(@runtot := @runtot + `NewGross`)),0); ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();
                sb.Append(" UPDATE `f_ledgertnxdetail` ltd  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=ltd.`LedgerTransactionNo`  and ltd.ItemID=ut.ItemID  ");
                //sb.Append(" SET ltd.`DiscountPercentage`= (CASE WHEN NewDisc >=0 THEN 100 WHEN  NewDisc < (-1)*100 THEN 0 ELSE (100+NewDisc) END),  ");
                //sb.Append(" ltd.Amount=(ltd.Rate*(100-(CASE WHEN NewDisc >=0 THEN 100 WHEN  NewDisc < (-1)*100 THEN 0 ELSE (100+NewDisc) END))*(0.01));   ");

                sb.Append(" SET ltd.`DiscountPercentage`= (CASE WHEN NewDisc >=0 THEN 100 WHEN NewDisc <0 and (NewGross+NewDisc) > 0 THEN (((NewGross+NewDisc)*100)/NewGross) ELSE 0 END),  ");
                sb.Append(" ltd.Amount=(CASE WHEN NewDisc >=0 THEN 0 WHEN NewDisc <0 and (NewGross+NewDisc) > 0 THEN (NewGross-(NewGross+NewDisc)) ELSE NewGross END);   ");

                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();


                // update f_ledgertransaction
                sb.Append(" UPDATE `f_ledgertransaction` lt  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=lt.`LedgerTransactionNo`  ");
                sb.Append(" SET ");
                sb.Append(" lt.`DiscountOnTotal` = (SELECT SUM((ltd.`Rate`*ltd.`Quantity`)- ltd.amount) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo),  ");
                sb.Append(" lt.`NetAmount`= (SELECT SUM(ltd.amount) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo),  ");
                sb.Append(" lt.`AmtCash`= round((SELECT SUM(ltd.amount) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo)),  ");
                sb.Append(" lt.`GrossAmount`= (SELECT SUM(ltd.Rate) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo),  ");
                sb.Append(" lt.`AmtCheque`=0,  ");
                sb.Append(" lt.`AmtCredit`=0,  ");
                sb.Append(" lt.`AmtCreditCard`=0,  ");
                sb.Append(" lt.`Adjustment`= round((SELECT SUM(ltd.amount) FROM `f_ledgertnxdetail` ltd WHERE ltd.`LedgerTransactionNo`=lt.LedgerTransactionNo)),  ");
                sb.Append(" lt.`AdjustmentDate`=lt.`Date`;  ");

                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();

                // update f_reciept
                sb.Append(" UPDATE `f_reciept` r  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=r.`AsainstLedgerTnxNo`  ");
                sb.Append(" AND r.`LedgerNoCr` !='OPD003'  ");
                sb.Append(" AND r.`IsCancel`='0'  ");
                sb.Append(" SET r.`IsCancel`='1',r.`CancelDate`=r.`Date`,r.`Cancel_UserID`=r.`Reciever`,r.`CancelReason`='**WRONG ENTRY**',  ");
                sb.Append(" r.`Updatedate`=NOW(),r.`UpdateID`='',r.`UpdateRemarks`='**WRONG ENTRY**';  ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();


                // update f_reciept
                sb.Append(" UPDATE `f_reciept` r  ");
                sb.Append(" INNER JOIN _utility ut ON ut.`LedgerTransactionNo`=r.`AsainstLedgerTnxNo`  ");
                sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=ut.`LedgerTransactionNo`  ");
                sb.Append(" AND r.`LedgerNoCr` ='OPD003'  ");
                sb.Append(" AND r.`IsCancel`='0'  ");
                sb.Append(" SET r.`AmountPaid`=round(lt.`NetAmount`),  ");
                sb.Append(" r.`AmtCash`=round(lt.`NetAmount`),  ");
                sb.Append(" r.`AmtCheque`=0,  ");
                sb.Append(" r.`AmtCreditCard`=0;  ");
                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();

                sb = new StringBuilder();


                // update f_patientaccount
                sb.Append(" UPDATE `f_patientaccount` pa  ");
                sb.Append(" INNER JOIN _utility ut ON pa.`LedgerTransactionNo`=ut.LedgerTransactionNo AND pa.`Active`=1  ");
                sb.Append(" SET active=0,`UpdateID`='', `UpdateRemarks`='**WRONG ENTRY**',`Updatedate`=NOW();  ");

                #endregion

                cmd = new MySqlCommand(sb.ToString(), tnx.Connection, tnx);
                cmd.ExecuteNonQuery();
                
               // Search();


                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                lblMsg.Text = "Record Saved successfully ";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Please Contact to It Admin" + "\n" + ex.ToString();
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return;

            }

        }
    }
}
