using MySql.Data.MySqlClient;
using System;
using System.Data;

public class ExcuteCMD
{
    public dynamic DML(MySqlTransaction tnx, MySqlConnection con, string sqlCmd, CommandType commandType, object inParameters = null, object outParameters = null)
    {
        try
        {
            using (MySqlCommand cmd = new MySqlCommand(sqlCmd.ToString(), tnx.Connection, tnx))
            {
                cmd.CommandType = commandType;
                createCmdParameters(cmd, inParameters, outParameters);
                dynamic response = null;
                if (outParameters != null)
                    response = cmd.ExecuteScalar();
                else
                    response = cmd.ExecuteNonQuery();
                return response;
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    public dynamic DML(MySqlTransaction tnx, string sqlCmd, CommandType commandType, object inParameters = null, object outParameters = null)
    {
        try
        {
            using (MySqlCommand cmd = new MySqlCommand(sqlCmd.ToString(), tnx.Connection, tnx))
            {
                cmd.CommandType = commandType;
                createCmdParameters(cmd, inParameters, outParameters);
                dynamic response = null;
                if (outParameters != null)
                    response = cmd.ExecuteScalar();
                else
                    response = cmd.ExecuteNonQuery();
                return response;
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    public dynamic DML(string sqlCmd, CommandType commandType, object inParameters = null, object outParameters = null)
    {
        try
        {
            MySqlConnection conn;
            conn = Util.GetMySqlCon();
            if (conn.State == ConnectionState.Closed)
                conn.Open();
            using (MySqlCommand cmd = new MySqlCommand(sqlCmd, conn))
            {
                cmd.CommandType = CommandType.Text;
                createCmdParameters(cmd, inParameters, null);
                dynamic response = null;
                response = cmd.ExecuteNonQuery();
                if (conn.State == ConnectionState.Open)
                    conn.Close();
                if (conn != null)
                {
                    conn.Dispose();
                    conn = null;
                }
                return response;
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    public dynamic ExecuteScalar(string sqlCmd, object inParameters)
    {
        MySqlConnection conn;
        conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();

        using (MySqlCommand cmd = new MySqlCommand(sqlCmd, conn))
        {
            cmd.CommandType = CommandType.Text;
            createCmdParameters(cmd, inParameters, null);
            dynamic response = null;
            response = cmd.ExecuteScalar();
            if (conn.State == ConnectionState.Open)
                conn.Close();
            if (conn != null)
            {
                conn.Dispose();
                conn = null;
            }
            return response;
        }
    }

    public dynamic ExecuteScalar(MySqlTransaction tnx, string sqlCmd, CommandType commandType, object inParameters = null, object outParameters = null)
    {
        try
        {
            using (MySqlCommand cmd = new MySqlCommand(sqlCmd.ToString(), tnx.Connection, tnx))
            {
                cmd.CommandType = commandType;
                createCmdParameters(cmd, inParameters, outParameters);
                return cmd.ExecuteScalar();
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }

    private void createCmdParameters(MySqlCommand cmd, object inParameters, object outParameters)
    {
        if (inParameters != null)
        {
            foreach (var prop in inParameters.GetType().GetProperties(System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.Public))
            {
                cmd.Parameters.Add(new MySqlParameter(string.Concat("@", prop.Name), prop.GetValue(inParameters, null)));
            }
        }

        if (outParameters != null)
        {
            MySqlParameter outParameter = new MySqlParameter();
            outParameter.ParameterName = "@ID";
            outParameter.MySqlDbType = MySqlDbType.VarChar;
            outParameter.Size = 50;
            outParameter.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(outParameter);
        }
    }

    private void createCmdOutParameters(MySqlCommand cmd, object outParameters)
    {
        if (outParameters != null)
        {
            MySqlParameter outParameter = new MySqlParameter();
            outParameter.ParameterName = "@ID";
            outParameter.MySqlDbType = MySqlDbType.VarChar;
            outParameter.Size = 50;
            outParameter.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(outParameter);
        }
    }

    public DataTable GetDataTable(string sqlCmd, CommandType commandType, object inParameters = null)
    {
        try
        {
            MySqlConnection conn;
            conn = Util.GetMySqlCon();
            if (conn.State == ConnectionState.Closed)
                conn.Open();
            using (MySqlCommand cmd = new MySqlCommand(sqlCmd.ToString(), conn))
            {
                cmd.CommandType = commandType;
                createCmdParameters(cmd, inParameters, null);
                using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                {
                    using (DataSet ds = new DataSet())
                    {
                        da.Fill(ds);
                        if (conn.State == ConnectionState.Open)
                            conn.Close();
                        if (conn != null)
                            conn.Dispose();
                        conn = null;
                        return ds.Tables[0];
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw (ex);
        }
    }
}