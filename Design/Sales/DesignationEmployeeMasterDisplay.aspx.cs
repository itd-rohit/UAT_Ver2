using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Designation_DesignationEmployeeMasterDisplay : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        GetDesignationwithEmployee();
    }

    private void GetNewDepenedent(string DependentID)
    {
        DataTable dtNew = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(IFNULL((SELECT COUNT(*) FROM employee_master e INNER JOIN f_designation_msater dm ON dm.ID=e.DesignationID WHERE em.IsSalesTeamMember=1 AND dm.SequenceNo<>1 AND em.Employee_ID=e.Reporting_Employee_ID),0)>0,1,0)IsDependent,em.Employee_ID,dm.ID DesignationID, dm.SequenceNo, CONCAT('<b><span style=''color:',IFNULL(dm.DisplayColor,'black'),''' /> ',dm.Name,'</b> ( ',em.Name,' )') AS EmployeeName FROM employee_master em INNER JOIN f_designation_msater dm ON dm.ID=em.DesignationID WHERE em.IsSalesTeamMember=1 AND dm.SequenceNo<>1 AND em.Reporting_Employee_ID='" + DependentID + "' ");
        dtNew = StockReports.GetDataTable(sb.ToString());
        if (dtNew.Rows.Count > 0)
        {
            pl1.Controls.Add(new LiteralControl("<div class='expander'></div><ul>"));
            for (int k = 0; k < dtNew.Rows.Count; k++)
            {
                pl1.Controls.Add(new LiteralControl(" <li>" + dtNew.Rows[k]["EmployeeName"].ToString() + " "));
                if (dtNew.Rows[k]["IsDependent"].ToString() == "1")
                {
                    GetNewDepenedent(dtNew.Rows[k]["Employee_ID"].ToString());
                }
                pl1.Controls.Add(new LiteralControl(" </li>"));
            }
            pl1.Controls.Add(new LiteralControl("</ul>"));
        }
    }

    public void GetDesignationwithEmployee()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(IFNULL((SELECT COUNT(*) FROM employee_master e INNER JOIN f_designation_msater dm ON dm.ID=e.DesignationID WHERE em.IsSalesTeamMember=1 AND dm.SequenceNo<>1 AND em.Employee_ID=e.Reporting_Employee_ID),0)>0,1,0)IsDependent, em.Employee_ID,dm.ID DesignationID, dm.SequenceNo,CONCAT('<b><span style=''color:',IFNULL(dm.DisplayColor,'black'),''' /> ',dm.Name,'</b> ( ',em.Name,' )') AS EmployeeName FROM employee_master em INNER JOIN f_designation_msater dm ON dm.ID=em.DesignationID WHERE em.IsSalesTeamMember=1 AND dm.SequenceNo=1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            pl1.Controls.Add(new LiteralControl("<ul class='tree'>"));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                pl1.Controls.Add(new LiteralControl(" <li>" + dt.Rows[i]["EmployeeName"].ToString() + " "));

                if (dt.Rows[i]["IsDependent"].ToString() == "1")
                {
                    GetNewDepenedent(dt.Rows[i]["Employee_ID"].ToString());
                }
                pl1.Controls.Add(new LiteralControl(" </li>"));
            }
            pl1.Controls.Add(new LiteralControl("</ul>"));
        }
    }
}