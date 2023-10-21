using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

/// <summary>
/// Summary description for Sales_Email_Record
/// </summary>
public class Sales_Email_Record
{
	 MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public Sales_Email_Record(MySqlTransaction objTrans)
    {
        if (objTrans != null)
        {
            this.objTrans = objTrans;
            this.IsLocalConn = false;

        }
        else
        {
            objCon = Util.GetMySqlCon();
            this.IsLocalConn = true;
        }
    }
    public string EmailType { get; set; }
    public int EmailTypeID { get; set; }
    public int EmailStatus { get; set; }
    public int CreatedByID { get; set; }
    public string CreatedBy { get; set; }
    public string EmailContent { get; set; }
    public string EmailTo { get; set; }
    public string EmailCC { get; set; }
    public string EmailBCC { get; set; }
    public string IDType1 { get; set; }
    public int? IDType1ID { get; set; }
    public string IDType2 { get; set; }
    public int? IDType2ID { get; set; }
    public string IDType3 { get; set; }
    public string IDType3ID { get; set; }
    public string LedgertransactionNo { get; set; }
    public int LedgertransactionID { get; set; }
    public string AttachmentPath { get; set; }
    public byte? IsAttachment { get; set; }
    public int SalesEmailRecord { get; set; }
    public string EmailSubject { get; set; }
    
    

    public int Insert()
    {
        try
        {
            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@SalesEmailRecord", MySqlDbType = MySqlDbType.VarChar, Size = 30, Direction = ParameterDirection.Output };


            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand("Insert_Sales_Email_Record", objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };
            cmd.Parameters.Add(new MySqlParameter("@EmailType", EmailType));
            cmd.Parameters.Add(new MySqlParameter("@EmailTypeID", EmailTypeID));
            cmd.Parameters.Add(new MySqlParameter("@EmailStatus", Util.GetInt(EmailStatus)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", Util.GetString(CreatedBy)));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", Util.GetInt(CreatedByID)));
            cmd.Parameters.Add(new MySqlParameter("@EmailContent", EmailContent));
            cmd.Parameters.Add(new MySqlParameter("@EmailTo", Util.GetString(EmailTo)));
            cmd.Parameters.Add(new MySqlParameter("@EmailCC", Util.GetString(EmailCC)));
            cmd.Parameters.Add(new MySqlParameter("@EmailBCC", Util.GetString(EmailBCC)));
            cmd.Parameters.Add(new MySqlParameter("@IDType1", Util.GetString(IDType1)));
            cmd.Parameters.Add(new MySqlParameter("@IDType1ID", Util.GetInt(IDType1ID)));
            cmd.Parameters.Add(new MySqlParameter("@IDType2", Util.GetString(IDType2)));
            cmd.Parameters.Add(new MySqlParameter("@IDType2ID", Util.GetInt(IDType2ID)));
            cmd.Parameters.Add(new MySqlParameter("@IDType3", Util.GetString(IDType3)));
            cmd.Parameters.Add(new MySqlParameter("@IDType3ID", Util.GetString(IDType3ID)));
            cmd.Parameters.Add(new MySqlParameter("@LedgertransactionNo", Util.GetString(LedgertransactionNo)));
            cmd.Parameters.Add(new MySqlParameter("@LedgertransactionID", Util.GetInt(LedgertransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@AttachmentPath", Util.GetString(AttachmentPath)));
            cmd.Parameters.Add(new MySqlParameter("@IsAttachment", Util.GetInt(IsAttachment)));
            cmd.Parameters.Add(new MySqlParameter("@EmailSubject", Util.GetString(EmailSubject)));
            cmd.Parameters.Add(paramTnxID);
            SalesEmailRecord = Util.GetInt(cmd.ExecuteScalar());
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();

            }
            return SalesEmailRecord;

        }
        catch (Exception ex)
        {

            throw (ex);
        }
    }
}