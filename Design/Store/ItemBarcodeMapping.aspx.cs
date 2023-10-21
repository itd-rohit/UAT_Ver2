using System;

public partial class Design_Store_ItemBarcodeMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlitem.DataSource = StockReports.GetDataTable("select itemid,typename from st_itemmaster where itemid='" + Request.QueryString["itemid"].ToString() + "'");
            ddlitem.DataValueField = "itemid";
            ddlitem.DataTextField = "typename";
            ddlitem.DataBind();
        }
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {

        string olditemid = Util.GetString(StockReports.ExecuteScalar("select itemid from st_itemmaster_barcode where Barcode='" + txtbarcodeno.Text + "'"));
        if (olditemid == "")
        {
            lbmsg.Text = "";
            StockReports.ExecuteDML("insert into st_itemmaster_barcode(ItemID,Barcode,EntryDateTime,UserID) values ('" + ddlitem.SelectedValue + "','" + txtbarcodeno.Text + "',now(),'" + UserInfo.ID + "')");
            lbmsg.Text = "Barcode Mapped";
        }
        else
        {
            string s = StockReports.ExecuteScalar("select typename from st_itemmaster where itemid='" + olditemid + "'");
            lbmsg.Text = "Barcode Already Mapped With :- "+s;
        }
       
    }
}