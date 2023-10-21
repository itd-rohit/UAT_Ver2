using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Design_Employee_Registration_ViewDoctorDetail : System.Web.UI.Page
{
    DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Resources.Resource.OPDHomeCollection == "0")
            Response.Redirect("../UnAuthorized.aspx");
        if (!IsPostBack)
        {
            try
            {
                Panel1.Visible = false;
                BindSpecializtion();
                BindDept();
            }
            catch (Exception ex)
            {
            }
            
        }
    }
    private void BindSpecializtion()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            lstSpecial.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select TRIM(BOTH FROM NAME) Name from type_master where TypeID ='3' order by Name").Tables[0];
            lstSpecial.DataTextField = "Name";
            lstSpecial.DataValueField = "Name";
            lstSpecial.DataBind();
            lstSpecial.Items.Insert(0, new ListItem("select","0"));
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
    public void BindDept()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            cmbDept.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select TRIM(BOTH FROM NAME) Name from type_master where TypeID ='5' order by Name").Tables[0];
            cmbDept.DataTextField = "Name";
            cmbDept.DataValueField = "Name";
            cmbDept.DataBind();
            cmbDept.Items.Insert(0, new ListItem("select",""));
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

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            GridView1.DataSource = null;
            GridView1.DataBind();
            string DName = "", Specialization = "", Deptartment = "", DID = "";
            if (txtName.Text != "")
            {
                DName = txtName.Text.Trim();

            }
            if (lstSpecial.SelectedIndex > 0)
            {
                Specialization = lstSpecial.SelectedItem.Value;
            }
            if (cmbDept.SelectedIndex != 0)
            {
                Deptartment = cmbDept.SelectedItem.Value;
            }


            dt = DoctorReg.GetDoctorDetail(DName, Specialization, Deptartment, DID);

            if (dt != null && dt.Rows.Count > 0)
            {
                dt.Columns.Add("updateFlag");
            }
            if (dt != null && dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    dt.Rows[i]["updateFlag"] = "1";

                }
            }
            if (dt != null && dt.Rows.Count > 0)
            {
                lblMsg.Text = dt.Rows.Count + "Record Found";
                GridView1.DataSource = dt;
                GridView1.DataBind();

                if (ViewState["dt"] == null)
                {
                    ViewState.Add("dt", dt);
                }
                else
                {
                    ViewState["dt"] = dt;
                }
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }
        }
        catch (Exception ex)
        {

        }
    }
    private void BindSubCategory()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            cmbSubCategory.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Name,SubCategoryID from f_Subcategorymaster where CategoryID in (select CategoryID from f_configrelation where ConfigRelationID=5)").Tables[0];
            cmbSubCategory.DataTextField = "Name";
            cmbSubCategory.DataValueField = "SubCategoryID";
            cmbSubCategory.DataBind();
           
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
 
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        Panel1.Visible = true;
        GridView2.DataSource = null;
        GridView2.DataBind();
        lblMsg.Text = "";
        string Doctor_ID = ((Label)GridView1.SelectedRow.FindControl("lblDID")).Text;
        DataTable dtDoctor = DoctorReg.LoadDoctorByDoctorID(Doctor_ID);
        if (dtDoctor != null && dtDoctor.Rows.Count > 0)
        {
            lblDName.Text = dtDoctor.Rows[0]["Name"].ToString();
        }
        ViewState["DID"] = Doctor_ID;
        
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            string Type = "", IsUpdate = "",Panel="",ItemId;
            if (rdbOPD.Checked == true)
            {
                Type = "OPD";

                for (int i = 0; i < GridView2.Rows.Count; i++)
                {
                    decimal Rate = Util.GetDecimal(((TextBox)GridView2.Rows[i].FindControl("txtRate")).Text);
                    ItemId = ((Label)GridView2.Rows[i].FindControl("lblItemID")).Text;
                    bool IsCheck = ((CheckBox)GridView2.Rows[i].FindControl("chkSelect")).Checked;
                    Panel = "81"; //standard

                  

                    if (IsCheck)
                    {
                        StockReports.ExecuteDML("Delete from f_ratelist where itemid='" + ItemId + "' and Panel_ID='81'");
                        RateList objRate = new RateList();
                        objRate.Rate = Util.GetDecimal(Rate);
                        objRate.ItemID =Convert.ToInt16(ItemId);
                        objRate.IsCurrent = Util.GetInt(1);
                        objRate.Panel_ID = Convert.ToInt16(Panel);
                        IsUpdate = objRate.Insert();
                       
                    }  
                    

                }
               //if (IsUpdate != "")
               // {
                    lblMsg.Text = "Record Saved Successfully";
                    GridView2.DataSource = null;
                    GridView2.DataBind();
               // }
               //else
               // {
               //   lblMsg.Text = "Record Not Saved";
               // }
            }
            
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.ToString();
        }

    }
    protected void btnView_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            string Type = "", Reference = "" ;
            string DID = ViewState["DID"] as string;
            Reference = "81";
        
            Type = "OPD";


            DataTable dt = StockReports.GetDataTable(@"SELECT temp1.ItemID,temp1.name,
IF(fl.Rate IS NULL,0,fl.Rate) AS Rate,SubCategoryID,Doctor_ID  FROM (SELECT im.ItemID,scm.name,im.ShowFlag,scm.SubCategoryID,im.Type_ID Doctor_ID FROM f_itemmaster im INNER JOIN f_subcategorymaster  scm ON scm.SubCategoryID = im.subcategoryid INNER JOIN f_configrelation con   ON con.CategoryID = scm.CategoryID WHERE im.Type_ID = '" + DID + "'  AND scm.Active=1) temp1 LEFT OUTER JOIN f_ratelist fl ON  temp1.ItemID = fl.ItemID AND iscurrent=1 AND fl.Panel_ID='81'");
            if (dt != null && dt.Rows.Count > 0)
            {
                lblMsg.Text = dt.Rows.Count + " Record Found";
                btnSave.Visible = true;
                GridView2.DataSource = dt;
                GridView2.DataBind();

               
                
               
            }
            else
            {
                lblMsg.Text = "No Record Found";
                GridView2.DataSource = null;
                GridView2.DataBind();
               
            }
        }
        catch (Exception ex)
        {
        }
    }
    protected void rdbIPD_CheckedChanged(object sender, EventArgs e)
    {
        GridView2.DataSource = null;
        GridView2.DataBind();
       
      
        BindSubCategory();
       

    }
    protected void rdbOPD_CheckedChanged(object sender, EventArgs e)
    {
        GridView2.DataSource = null;
        GridView2.DataBind();
      
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        
        if (ViewState["dt"] != null)
        {
            dt = ((DataTable)ViewState["dt"]);
            GridView1.DataSource = dt;
            GridView1.DataBind();
            ViewState["dt"] = dt;
        }
       
    }
}
