using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
/// <summary>
/// Summary description for Store_AllLoadData
/// </summary>
public class Store_AllLoadData
{
	public Store_AllLoadData()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public string getApprovalRightEnail(MySqlConnection con,string TypeID,string AppRightFor)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CAST(GROUP_CONCAT(em.Email  SEPARATOR ',')AS CHAR)Email FROM st_approvalright ar ");
        sb.Append(" INNER JOIN employee_master em ON ar.EmployeeID=em.Employee_ID ");
        sb.Append(" WHERE  IFNULL(em.Email,'')<>'' AND ar.TypeID=@TypeID AND ar.AppRightFor=@AppRightFor ");
        string emailData = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@TypeID", TypeID), new MySqlParameter("@AppRightFor", AppRightFor)
            ));
             
        {
            return emailData;
        }
    }


    public string getApprovalRightEnail(MySqlTransaction tnx, string TypeID, string AppRightFor)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CAST(GROUP_CONCAT(em.Email  SEPARATOR ',')AS CHAR)Email FROM st_approvalright ar ");
        sb.Append(" INNER JOIN employee_master em ON ar.EmployeeID=em.Employee_ID ");
        sb.Append(" WHERE  IFNULL(em.Email,'')<>'' AND ar.TypeID=@TypeID AND ar.AppRightFor=@AppRightFor ");
        string emailData = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
            new MySqlParameter("@TypeID", TypeID), new MySqlParameter("@AppRightFor", AppRightFor)
            ));

        {
            return emailData;
        }
    }
}