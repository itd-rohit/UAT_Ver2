using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_IndentDispatchDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            grd.DataSource = StockReports.GetDataTable(@"SELECT  DATE_FORMAT(dispatchdate,'%d-%b-%Y')DispatchDate,BatchNumber,
DATE_FORMAT(batchcreateddatetime,'%d-%b-%Y') BatchCreatedDatetime,
DispatchOption,CourierName,AWBNumber,IF(FieldBoyName='',OtherName,FieldBoyName) FieldBoy ,NoofBox FROM st_indentissuedetail
WHERE indentno='" + Request.QueryString["IndentNo"].ToString() + "' GROUP BY  batchnumber");
            grd.DataBind();
        }
    }
}