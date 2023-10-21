using System;
using System.Data;
using System.Text;

public partial class Design_Store_IndentLastIssueQty : System.Web.UI.Page
{
    public DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        string aa = Request.QueryString["Rate"].ToString();
        //DataColumn dc = new DataColumn();
        //dc.ColumnName = "Rate";
        //dc.DefaultValue = Request.QueryString["Rate"].ToString();
        //dt.Columns.Add(dc);
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT '" + Request.QueryString["Rate"].ToString() + "' Rate,'" + Request.QueryString["Tax"].ToString() + "' Tax,'" + Request.QueryString["Disc"].ToString() + "' Disc, ");
        sb.Append(" ReceiveQty,DATE_FORMAT(IssueDate,'%d-%b-%Y')IssueDate FROM st_indent_detail WHERE ItemID='" + Request.QueryString["ItemID"].ToString() + "' AND ");
        sb.Append(" FromLocationID= '" + Request.QueryString["FromLocationID"].ToString() + "' AND ReceiveQty>0 ORDER BY IssueDate DESC LIMIT 1  ");

        dt = StockReports.GetDataTable(sb.ToString());


        if (dt.Rows.Count == 0)
        {
            DataRow dr = dt.NewRow();
            dr["Rate"] = Request.QueryString["Rate"].ToString();
            dr["Tax"] = Request.QueryString["Tax"].ToString();
            dr["Disc"] = Request.QueryString["Disc"].ToString();
            dr["ReceiveQty"] = "0"; dr["IssueDate"] = "";
            dt.Rows.Add(dr);
          
        }
        else
        {


        }

    }
}