using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_OPD_ManagePackage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadInvestigations();
            BindPackage();
            AddDoctor();
            getlastcode();

            if (rbtNewEdit.SelectedValue == "1")
            {
                ddlPackage.Visible = false;
                txtPkg.Visible = true;
            }
            else
            {
                ddlPackage.Visible = true;
                txtPkg.Visible = false;
            }
        }
    }

    public void getlastcode()
    {
        lastcode.Text = StockReports.ExecuteScalar("SELECT MAX(testcode) FROM f_itemmaster WHERE subcategoryid=(SELECT subcategoryid FROM f_subcategorymaster WHERE categoryid=(SELECT CategoryID FROM f_configrelation WHERE ConfigRelationID = 23))");
    }

    protected void ddlPackage_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlPackage.SelectedIndex > 0)
        {
            txtPkg.Visible = true;
            txtPkg.Text = ddlPackage.SelectedItem.Text;
        }
        else
        {
            txtPkg.Visible = false;
            txtPkg.Text = "";
        }
        bindbilcat();
        BindInvestigation();
        BindDoctors();
    }

    public void bindbilcat()
    {
        string bill = StockReports.ExecuteScalar("SELECT `Bill_Category` FROM f_itemmaster WHERE `Type_ID`='" + ddlPackage.SelectedValue + "' AND `subcategoryid`=(SELECT SubCategoryID FROM f_subcategorymaster WHERE `CategoryID`='LSHHI44' LIMIT 1) ");
        ddlbillcategory.SelectedValue = bill;
    }

    private void LoadInvestigations()
    {
        ddlInv.Items.Clear();
        string str = "SELECT concat(im.Name,'#',sc.name)Item,im.Investigation_ID FROM  investigation_master im " +
        "   INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID AND it.IsActive=1 " +
        "   INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID  " +
        "   INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigRelationID=3 " +
        "   INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID order by im.Name";
        StringBuilder sb = new StringBuilder();

        DataTable dtInv = new DataTable();
        dtInv = StockReports.GetDataTable(str);

        if (dtInv != null)
        {
            ddlInv.DataSource = dtInv;
            ddlInv.DataTextField = "Item";
            ddlInv.DataValueField = "Investigation_ID";
            ddlInv.DataBind();
            ddlInv.Items.Insert(0, new ListItem("--Select--", "0"));
        }
    }

    private void BindInvestigation()
    {
        if (ddlPackage.SelectedValue != "0")
        {
            string str = "select * from investigation_master where Investigation_Id in"
                        + " (select InvestigationID from package_labdetail where PlabID = '" + ddlPackage.SelectedValue + "') order by Name";

            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(str);
            StringBuilder sb = new StringBuilder();
            if (dt.Rows.Count > 0)
            {
                chkInv.DataSource = dt;
                chkInv.DataTextField = "Name";
                chkInv.DataValueField = "Investigation_ID";
                chkInv.DataBind();

                int index = 0;
                foreach (DataRow dr in dt.Rows)
                {
                    chkInv.Items[index].Selected = true;
                    index += 1;
                }
            }
            else sb.Append("No Investigations defined");

            StringBuilder strRate = new StringBuilder();
            strRate.Append(" SELECT r.Rate,ifnull(im.TestCode,'')TestCode,if(im.IsActive=1,'true','false') as IsActive FROM f_itemmaster im ");
            strRate.Append(" INNER JOIN f_subcategorymaster sc ON im.SubCategoryID=sc.SubCategoryID ");
            strRate.Append(" INNER JOIN f_configrelation c ON c.CategoryID=sc.CategoryID ");
            strRate.Append(" INNER JOIN f_ratelist r ON r.ItemID=im.ItemID AND r.panel_id='78' ");
            strRate.Append(" WHERE c.ConfigRelationID = 23 AND Type_ID = '" + ddlPackage.SelectedValue + "'  ");

            DataTable rate = new DataTable();
            rate = StockReports.GetDataTable(strRate.ToString());
            if (rate.Rows.Count > 0)
            {
                txtAmount.Text = Util.GetString(rate.Rows[0]["Rate"]);
                txttestcode.Text = Util.GetString(rate.Rows[0]["TestCode"]);
                chkIsActive.Checked = Util.GetBoolean(rate.Rows[0]["IsActive"]);
            }
            else
                txtAmount.Text = "0";
        }
    }

    protected void BindDoctors()
    {
        chldoctor.Items.Clear();

        string s = "select distinct dm.Name,dm.Doctor_Id from doctor_master dm,package_doctordetail pd ,package_labdetail pl where pl.PlabID=pd.PlabID AND pd.DoctorID =dm.Doctor_ID AND pd.IsActive=1 AND pl.PlabID='" + ddlPackage.SelectedValue.ToString().Trim() + "'";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(s);

        chldoctor.DataSource = dt;
        chldoctor.DataTextField = "Name";
        chldoctor.DataValueField = "Doctor_Id";

        chldoctor.DataBind();

        int index = 0;
        foreach (DataRow dr in dt.Rows)
        {
            chldoctor.Items[index].Selected = true;
            index += 1;
        }
    }

    private void BindPackage()
    {
        string str = "Select PlabID,Name from packagelab_master Where IsActive=1 order by Name";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlPackage.DataSource = dt;
            ddlPackage.DataTextField = "Name";
            ddlPackage.DataValueField = "PlabID";
            ddlPackage.DataBind();
            ddlPackage.Items.Insert(0, new ListItem("--Select--", "0"));

            ddlSubPackage.DataSource = dt;
            ddlSubPackage.DataTextField = "Name";
            ddlSubPackage.DataValueField = "PlabID";
            ddlSubPackage.DataBind();
            ddlSubPackage.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        else
        {
            ddlPackage.Items.Insert(0, new ListItem("--No Package--", "0"));
            ddlSubPackage.Items.Insert(0, new ListItem("--No Package--", "0"));
        }
    }

    protected void AddDoctor()
    {
        ddlDoctor.Items.Clear();
        string str = "SELECT Doctor_ID,NAME FROM doctor_referal WHERE IsActive = 1 AND TRIM(NAME)<>'' ORDER BY NAME";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);

        if (dt != null)
        {
            ddlDoctor.DataSource = dt;
            ddlDoctor.DataTextField = "Name";
            ddlDoctor.DataValueField = "Doctor_ID";
            ddlDoctor.DataBind();
        }
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        int f = 0;
        for (int i = 0; i < chldoctor.Items.Count; i++)
        {
            if (chldoctor.Items[i].Value == ddlDoctor.SelectedValue)
            {
                lblMsg.Text = "Doctor Already Added";
                f = 1;
            }
        }

        if (f == 0)
        {
            if (ddlDoctor.SelectedIndex != -1)
            {
                chldoctor.Items.Insert(chldoctor.Items.Count, new ListItem(ddlDoctor.SelectedItem.Text, ddlDoctor.SelectedValue));
                chldoctor.Items[chldoctor.Items.Count - 1].Selected = true;
                lblMsg.Text = "Doctor Added";
            }
        }
    }

    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM packagelab_master WHERE NAME='" + txtPkg.Text.Trim() + "'"));
        if (count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private bool CheckInvestigationAdd()
    {
        int a = 0;
        for (int i = 0; i < chkInv.Items.Count; i++)
        {
            if (chkInv.Items[i].Selected)
            {
                a += 1;
            }
        }
        if (a > 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    protected void butSave_Click(object sender, EventArgs e)
    {
        if (ddlPackage.SelectedValue == "0")
        {
        }
        if (rbtNewEdit.SelectedValue == "1")
        {
            if (CheckDuplicate())
            {
                lblMsg.Text = "!!! Package Name Already Exist !!!";
                return;
            }
        }
        if (rbtNewEdit.SelectedValue == "2")
        {
            if (ddlPackage.SelectedValue == "0")
            {
                lblMsg.Text = "!!! Please Select Package !!!";
                return;
            }
        }
        if (CheckInvestigationAdd())
        {
            lblMsg.Text = "!!! Please Select Investigation !!!";
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            PackageLab_Detail objLM = new PackageLab_Detail(tranX);
            string PackageID = ddlPackage.SelectedValue;

            int isactive = 0;
            if (chkIsActive.Checked)
                isactive = 1;

            if (rbtNewEdit.SelectedValue == "2")
            {
                objLM.PLabID = ddlPackage.SelectedValue;
                int RowEffected = objLM.Delete();
                string sql = "update packagelab_master set Name='" + txtPkg.Text.Trim() + "',IsActive='" + isactive + "' where PlabID='" + PackageID.Trim() + "'";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sql);
            }
            else
            {
                PackageLab_Master objPLM = new PackageLab_Master(tranX);
                objPLM.Name = txtPkg.Text.Trim();
                objPLM.Description = "";
                objPLM.CreaterID = Util.GetString(Session["ID"]);
                objPLM.Creator_Date = DateTime.Now;
                objPLM.IsActive = isactive;
                PackageID = objPLM.Insert();
            }

            for (int i = 0; i < chkInv.Items.Count; i++)
            {
                if (chkInv.Items[i].Selected == true)
                {
                    objLM.PLabID = PackageID;
                    objLM.InvestigationID = chkInv.Items[i].Value;
                    objLM.Insert();
                }
            }

            string update = "update package_doctordetail set IsActive=0 where PlabID='" + ddlPackage.SelectedValue.ToString().Trim() + "'";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, update);

            for (int i = 0; i < chldoctor.Items.Count; i++)
            {
                if (chldoctor.Items[i].Selected)
                {
                    string insert = "insert into package_doctordetail(PlabID,DoctorID,UserID,DateModified)" +
                    " values('" + PackageID + "'," +
                    "'" + chldoctor.Items[i].Value.Trim() + "','" + Session["ID"].ToString() + "'," +
                    "'" + Util.GetDateTime(DateTime.Now.ToString().Trim()).ToString("yyyy-MM-dd HH:mm:ss") + "')";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, insert);
                }
            }

            string ItemID = "", PkgName = ""; ;

            if (rbtNewEdit.SelectedValue == "2")
            {
                ItemID = "select ItemID from f_itemmaster"
                    + " where Type_ID = '" + ddlPackage.SelectedValue + "' and SubCategoryID = (select SubCategoryID from f_subcategorymaster"
                    + " where CategoryID = (select CategoryID from f_configrelation where ConfigRelationID = 23 ))";

                ItemID = StockReports.ExecuteScalar(ItemID);

                if (ItemID != "")
                {
                    string str = "update f_itemmaster set TypeName='" + txtPkg.Text + "',TestCode='" + txttestcode.Text + "',IsActive='" + isactive + "',Bill_Category='" + ddlbillcategory.SelectedValue + "' where ItemID='" + ItemID + "'";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE ItemID =@ItemID AND  Panel_ID=@Panel_ID ",
               new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
               new MySqlParameter("@ItemID", ItemID),
               new MySqlParameter("@Panel_ID", "78"));


                    update = "Delete from f_rateList where ItemID='" + ItemID + "' and Panel_ID='78'";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, update);


                }

                PkgName = ddlPackage.SelectedItem.Text;
            }
            else
            {
                PkgName = txtPkg.Text.Trim();

                string SubcategoryID = "select SubCategoryID from f_subcategorymaster" +
                " where CategoryID = (select CategoryID from f_configrelation where ConfigRelationID = '23' )";

                SubcategoryID = StockReports.ExecuteScalar(SubcategoryID);

                ItemMaster objIMaster = new ItemMaster(tranX);
                objIMaster.TypeName = PkgName;
                objIMaster.Type_ID = Util.GetInt( PackageID);
                objIMaster.SubCategoryID =  Util.GetInt( SubcategoryID);
                objIMaster.IsTrigger = "YES";
                objIMaster.IsActive = isactive;
                objIMaster.TestCode = txttestcode.Text;
                objIMaster.BillCategoryID = Util.GetInt(ddlbillcategory.SelectedValue);
                ItemID = objIMaster.Insert().ToString();
            }

            tranX.Commit();

            lblMsg.Text = "Record Saved";
            chkInv.Items.Clear();
            rbtNewEdit.SelectedIndex = 0;
            ddlPackage.Visible = false;

            chldoctor.Items.Clear();
            BindPackage();
            LoadInvestigations();
            BindInvestigation();
            txtAmount.Text = "0";
            txtPkg.Text = "";
            txttestcode.Text = "";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.InnerException.ToString();
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected bool SendCircular(string Test, string PackageId)
    {
        try
        {
            string Roleid = Session["RoleID"].ToString();
            string EmpID = Session["ID"].ToString();
            string Deptid = "9";//Circular to be Sent only for Front Office
            string Message = " New Package Created :" + Test + " ";
            string Sub = "Package Created";
            string Documentno = PackageId;
            DataTable dt = StockReports.GetDataTable("SELECT fl.EmployeeID,fl.RoleID FROM f_login fl WHERE fl.roleid IN (" + Deptid + ") and fl.Active=1  group by fl.EmployeeID ");
            if (dt != null && dt.Rows.Count > 0)
            {
                StockReports.ExecuteDML("INSERT INTO Circular_Master(Message,FromId,FromDept,Sub,DocumentNo) values('" + Message + "','" + EmpID + "','" + Roleid + "','" + Sub + "','" + Documentno + "')");
                string circularid = StockReports.ExecuteScalar("select max(id) from circular_master");
                foreach (DataRow dr in dt.Rows)
                {
                    insertCircular(Roleid,
                                        Util.GetString(dr["RoleID"]), EmpID, Util.GetString(dr["EmployeeID"]), Sub, circularid);
                }
            }
            return true;
        }
        catch (Exception)
        {
            return false;
        }
    }

    protected void insertCircular(string from_dept, string to_dept, string from_id, string to_id, string sub, string message)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("insert into circular_inbox(from_dept,to_dept,from_id,message,sub,to_id) values('" + from_dept + "',");

        sb.Append(" '" + to_dept + "', ");

        sb.Append(" '" + from_id + "','" + message + "','" + sub + "', ");
        sb.Append(" '" + to_id + "')");

        StockReports.ExecuteDML(sb.ToString());
    }

    protected void btnAddSubPackage_Click(object sender, EventArgs e)
    {
        if (ddlSubPackage.SelectedIndex != 0)
        {
            lblMsg.Text = "";
            string chkPackage = AllLoad_Data.GetSelection(chkInv);
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT inv.`Investigation_Id` as InvID,inv.`Name` AS InvName FROM investigation_master inv INNER JOIN package_labdetail pld ON pld.`InvestigationID`=inv.`Investigation_Id` ");
            sb.Append(" and pld.`PlabID`in ('" + ddlSubPackage.SelectedValue + "','" + ddlPackage.SelectedValue + "') ");
            if (chkPackage.Trim() != "")
            {
                sb.Append(" OR inv.`Investigation_Id` in (" + AllLoad_Data.GetSelection(chkInv) + ")");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            chkInv.DataSource = dt;
            chkInv.DataTextField = "InvName";
            chkInv.DataValueField = "InvID";
            chkInv.DataBind();
            for (int i = 0; i < chkInv.Items.Count; i++)
            {
                chkInv.Items[i].Selected = true;
            }
        }
        else
        {
            lblMsg.Text = "!!! Please Select Package !!!";
        }
    }

    protected void btnAddInv_Click(object sender, EventArgs e)
    {
        int f = 0;
        for (int i = 0; i < chkInv.Items.Count; i++)
        {
            if (chkInv.Items[i].Value == ddlInv.SelectedValue)
            {
                lblMsg.Text = "Investigation Already Added";
                f = 1;
            }
        }

        if (f == 0)
        {
            if (ddlInv.SelectedIndex != 0)
            {
                lblMsg.Text = "";
                string name = ddlInv.SelectedItem.Text.Split('#')[0].ToString();
                chkInv.Items.Insert(chkInv.Items.Count, new ListItem(name, ddlInv.SelectedValue));
                chkInv.Items[chkInv.Items.Count - 1].Selected = true;
                lblMsg.Text = "Investigation Added";
            }
            else
            {
                lblMsg.Text = "1!! Please Select Investigation !!!";
            }
        }
    }

    protected void rbtNewEdit_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtNewEdit.SelectedValue == "1")
        {
            ddlPackage.Visible = false;
            txtPkg.Visible = true;
            txtAmount.Text = "0";
            chkInv.Items.Clear();
            chldoctor.Items.Clear();
            lblab.Visible = true;
            lastcode.Visible = true;
        }
        else
        {
            ddlPackage.Visible = true;
            txtPkg.Visible = false;
            txtAmount.Text = "0";
            chkInv.Items.Clear();
            chldoctor.Items.Clear();
            lblab.Visible = false;
            lastcode.Visible = false;
        }
    }
}