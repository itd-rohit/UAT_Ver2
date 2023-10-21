using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_StoreItemMasterUpdate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnsaearch_Click(object sender, EventArgs e)
    {
        BindData();
    }

    private void BindData()
    {
        lbmsg.Text = "";
        if (txtitemsearch.Text == "")
        {
            lbmsg.Text = "Plaese Enter Item Name";
            txtitemsearch.Focus();
            return;
        }

        grditem.DataSource = StockReports.GetDataTable(@"SELECT itemid,st.itemidgroup,(SELECT itemnamegroup FROM st_itemmaster_group WHERE itemidgroup=st.itemidgroup)ItemName  ,
st.`MachineID`,st.`MachineName`,st.`ManufactureID`,st.`ManufactureName`,st.`PackSize`,st.`CatalogNo`,
st.`MajorUnitId`,st.`MajorUnitName`,st.`MinorUnitId`,st.`MinorUnitName`,trimzero(st.`Converter`)Converter ,trimzero(GSTNTax)GSTNTax,Expdatecutoff,HsnCode,IssueMultiplier,BarcodeOption,BarcodeGenrationOption,IssueInFIFO,MajorUnitInDecimal,MinorUnitInDecimal,st.IssueMultiplier
FROM  st_itemmaster st where isactive=1 and typename like '" + txtitemsearch.Text + "%' order by itemidgroup,typename limit 20");


        grditem.DataBind();


        if (grditem.Rows.Count == 0)
        {
            lbmsg.Text = "No Item Found";
            txtitemsearch.Focus();
            return;
        }
    }

    protected void btn_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton btn1 = (ImageButton)sender;
        GridViewRow gvr = (GridViewRow)btn1.NamingContainer;
        int rowindex = gvr.RowIndex;

        ddlmachine.DataSource = StockReports.GetDataTable("SELECT id,NAME FROM macmaster ORDER BY NAME ");
        ddlmachine.DataValueField = "id";
        ddlmachine.DataTextField = "NAME";
        ddlmachine.DataBind();

        ddlmanufacture.DataSource = StockReports.GetDataTable("SELECT MAnufactureID,NAME FROM st_manufacture_master ORDER BY NAME");
        ddlmanufacture.DataValueField = "MAnufactureID";
        ddlmanufacture.DataTextField = "NAME";
        ddlmanufacture.DataBind();

        DataTable dt = StockReports.GetDataTable("SELECT id,unitname FROM st_unit_master ORDER BY unitname");
        ddlpurchaseunit.DataSource = dt;
        ddlpurchaseunit.DataValueField = "id";
        ddlpurchaseunit.DataTextField = "unitname";
        ddlpurchaseunit.DataBind();

        ddlconsumeunit.DataSource = dt;
        ddlconsumeunit.DataValueField = "id";
        ddlconsumeunit.DataTextField = "unitname";
        ddlconsumeunit.DataBind();

        lbmsg1.Text = "";
        lbitemidedit.Text = ((Label)grditem.Rows[rowindex].FindControl("lbitemid")).Text;
        lbitemidgroupedit.Text = ((Label)grditem.Rows[rowindex].FindControl("lbitemidgroup")).Text;

        
        txtitemidedit.Text= ((Label)grditem.Rows[rowindex].FindControl("lbItemName")).Text;
        string MachineID = ((Label)grditem.Rows[rowindex].FindControl("lbMachineID")).Text;

        ListItem item = ddlmachine.Items.FindByValue(MachineID.ToString());
        if (item != null)
        {
            ddlmachine.SelectedValue = MachineID.ToString();
        }



        string ManufactureID = ((Label)grditem.Rows[rowindex].FindControl("lbManufactureID")).Text;

        ListItem item1 = ddlmanufacture.Items.FindByValue(ManufactureID.ToString());
        if (item1 != null)
        {
            ddlmanufacture.SelectedValue = ManufactureID.ToString();
        }

        txtpacksize.Text  = ((Label)grditem.Rows[rowindex].FindControl("lbPackSize")).Text;
        txtcatalogno.Text = ((Label)grditem.Rows[rowindex].FindControl("lbCatalogNo")).Text;
        txtissuemultiplier.Text = ((Label)grditem.Rows[rowindex].FindControl("lbissuemultiplier")).Text;
        string MajorUnitId = ((Label)grditem.Rows[rowindex].FindControl("lbMajorUnitId")).Text;
        ListItem item2 = ddlpurchaseunit.Items.FindByValue(MajorUnitId.ToString());
        if (item2 != null)
        {
            ddlpurchaseunit.SelectedValue = MajorUnitId.ToString();
        }
        string MinorUnitId = ((Label)grditem.Rows[rowindex].FindControl("lbMinorUnitId")).Text;
        ListItem item3 = ddlconsumeunit.Items.FindByValue(MinorUnitId.ToString());
        if (item3 != null)
        {
            ddlconsumeunit.SelectedValue = MinorUnitId.ToString();
        }
        txtConverter.Text = ((Label)grditem.Rows[rowindex].FindControl("lbConverter")).Text;
        txtgstntax.Text = ((Label)grditem.Rows[rowindex].FindControl("lbGSTNTax")).Text;
        txtgstntaxold.Text = ((Label)grditem.Rows[rowindex].FindControl("lbGSTNTax")).Text;
        txtExpdatecutoff.Text = ((Label)grditem.Rows[rowindex].FindControl("lbExpdatecutoff")).Text;
        txtHsnCode.Text= ((Label)grditem.Rows[rowindex].FindControl("lbHsnCode")).Text;

        mode.Show();

    }

    protected void btnupdate_Click(object sender, EventArgs e)
    {
        lbmsg1.Text = "";
        if (txtitemidedit.Text == "")
        {
            txtitemidedit.Focus();
            lbmsg1.Text = "Please Enter Item Name";
            return;

        }
        if (txtpacksize.Text == "")
        {
            txtpacksize.Focus();
            lbmsg1.Text = "Please Enter Pack Size";
            return;

        }
        if (txtgstntax.Text == "" || txtgstntax.Text == "0")
        {
            txtgstntax.Focus();
            lbmsg1.Text = "Please Enter GST Tax %";
            return;

        }

        // if (txtHsnCode.Text == "")
        // {
            // txtHsnCode.Focus();
            // lbmsg1.Text = "Please Enter HSNCode";
            // return;

        // }

        if (txtConverter.Text == "")
        {
            txtConverter.Focus();
            lbmsg1.Text = "Please Enter Converter";
            return;

        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  st_itemmaster_group set ItemNameGroup=@ItemNameGroup where ItemIDGroup=@ItemIDGroup",
                new MySqlParameter("@ItemNameGroup", txtitemidedit.Text),
                new MySqlParameter("@ItemIDGroup", lbitemidgroupedit.Text));

            string itemname = txtitemidedit.Text+ " " + ddlmachine.SelectedItem.Text + " " + ddlmanufacture.SelectedItem.Text+ " " + txtpacksize.Text;

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  st_itemmaster set typename=@typename,GSTNTax=@GSTNTax, HsnCode=@HsnCode, ManufactureID=@ManufactureID, ManufactureName=@ManufactureName,  MachineID=@MachineID, MachineName=@MachineName, MajorUnitId=@MajorUnitId, MajorUnitName=@MajorUnitName, PackSize=@PackSize, Converter=@Converter , MinorUnitId=@MinorUnitId,MinorUnitName=@MinorUnitName,Expdatecutoff=@Expdatecutoff,CatalogNo=@CatalogNo,IssueMultiplier=@IssueMultiplier where ItemID=@ItemID",
               new MySqlParameter("@typename", itemname),
               new MySqlParameter("@GSTNTax", txtgstntax.Text),
               new MySqlParameter("@HsnCode", txtHsnCode.Text),
               new MySqlParameter("@ManufactureID", ddlmanufacture.SelectedValue),
               new MySqlParameter("@ManufactureName", ddlmanufacture.SelectedItem.Text),
               new MySqlParameter("@MachineID", ddlmachine.SelectedValue),
               new MySqlParameter("@MachineName", ddlmachine.SelectedItem.Text),
               new MySqlParameter("@MajorUnitId", ddlpurchaseunit.SelectedValue),
               new MySqlParameter("@MajorUnitName", ddlpurchaseunit.SelectedItem.Text),
               new MySqlParameter("@PackSize", txtpacksize.Text),
               new MySqlParameter("@Converter", txtConverter.Text),
               new MySqlParameter("@MinorUnitId", ddlconsumeunit.SelectedValue),
               new MySqlParameter("@MinorUnitName", ddlconsumeunit.SelectedItem.Text),
               new MySqlParameter("@Expdatecutoff", txtExpdatecutoff.Text),
               new MySqlParameter("@CatalogNo", txtcatalogno.Text),
               new MySqlParameter("@IssueMultiplier", txtissuemultiplier.Text),
               new MySqlParameter("@ItemID", lbitemidedit.Text));

            // Tax Change For This Item
            if (txtgstntax.Text != txtgstntaxold.Text)
            {
                // update quotation table
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE st_vendorqutation SET ");
                sb.Append(" IGSTPer=IF(VendorStateId=DeliveryStateID ,0," + txtgstntax.Text + "), ");
                sb.Append(" SGSTPer=IF(VendorStateId=DeliveryStateID," + txtgstntax.Text + "/2,0), ");
                sb.Append(" CGSTPer=IF(VendorStateId=DeliveryStateID," + txtgstntax.Text + "/2,0), ");
                sb.Append(" GSTAmount=((rate-DiscountAmt)*" + txtgstntax.Text + "*0.01), ");
                sb.Append(" BuyPrice=((rate-DiscountAmt)+((rate-DiscountAmt)*" + txtgstntax.Text + "*0.01)), ");
                sb.Append(" FinalPrice=((rate-DiscountAmt)+((rate-DiscountAmt)*" + txtgstntax.Text + "*0.01)), ");
                sb.Append(" updatedate=NOW(), ");
                sb.Append(" updatebyid=" + UserInfo.ID + " ");
                sb.Append(" WHERE itemid='" + lbitemidedit.Text + "' and (IGSTPer+SGSTPer+CGSTPer)=" + txtgstntaxold.Text + " ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                // update pending pi 

                sb = new StringBuilder();
                sb.Append(" UPDATE st_indent_detail SET ");
                sb.Append(" TaxPerIGST=IF(TaxPerIGST=0,0," + txtgstntax.Text + "), ");
                sb.Append(" TaxPerCGST=IF(TaxPerCGST=0,0," + txtgstntax.Text + "/2), ");
                sb.Append(" TaxPerSGST=IF(TaxPerSGST=0,0," + txtgstntax.Text + "/2),  ");
                sb.Append(" unitprice=((rate-(rate*DiscountPer*0.01))+(rate-(rate*DiscountPer*0.01))*(" + txtgstntax.Text + ")*0.01), ");
                sb.Append(" NetAmount=((rate-(rate*DiscountPer*0.01))+(rate-(rate*DiscountPer*0.01))*(" + txtgstntax.Text + ")*0.01) ");
                sb.Append(" *IF(ApprovedQty<>0,ApprovedQty,IF(CheckedQty<>0,CheckedQty,ReqQty)),dtUpdate=NOW(),UpdatedBy='"+UserInfo.LoginName+"',UpdatedByID='" + UserInfo.ID + "' ");
                sb.Append(" WHERE IndentType='PI' AND POQty=0 AND itemid='" + lbitemidedit.Text + "'   ");
                sb.Append(" AND (TaxPerIGST+TaxPerCGST+TaxPerSGST)=" + txtgstntaxold.Text + " ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            }



            tnx.Commit();
          
            mode.Hide();
            BindData();
            lbmsg.Text = "item Updated";
        }
        catch (Exception ex)
        {
            mode.Show();
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lbmsg1.Text = Util.GetString(ex.GetBaseException());
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
}