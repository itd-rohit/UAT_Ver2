using System;
using System.Text;

public partial class Design_EDP_MenuAccessReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.RoleName,t.MenuName,t.SubMenu FROM  ( ");
        sb.Append(" SELECT rm.RoleName, (mm.MenuName)MenuName,GROUP_CONCAT(fm.dispName  separator  '\n' )SubMenu,fm.MenuID,mm.Priority  ");
        sb.Append(" FROM f_filemaster fm INNER JOIN f_file_role fr ON fm.ID = fr.UrlID ");
        sb.Append(" INNER JOIN f_rolemaster rm ON fr.RoleID = rm.ID AND rm.Active=1 INNER JOIN f_menumaster mm ON fm.MenuID = mm.ID  ");
        sb.Append(" WHERE fm.Active = 1 AND fr.Active = 1 AND mm.Active = 1  ");
        sb.Append(" GROUP BY fr.RoleID,fm.MenuID ORDER BY RoleName,MenuName  )t ");
        sb.Append(" ORDER BY t.RoleName,t.Priority  ");

        AllLoad_Data.exportToCrystalReport(sb.ToString(), "E:/MenuAccessReport.xml", "~/Reports/MenuAccessReport.rpt", Page);
    }
}