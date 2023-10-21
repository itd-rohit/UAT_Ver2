using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for PatientTransaction
/// </summary>
public class PatientTransaction
{



    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;


    public PatientTransaction()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public PatientTransaction(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }


    public enum Eventtype
    {
        Booking = 1,
        SampleCollection = 2,
        SampleTransfer = 3,
        PatientReceiptPrint = 4,
        PatientReportPrint = 5,
        HistoGrossingAndSliding = 6,
        MicroPlating = 7,
        SampleProcessing=8
    }


    public int savepatienttransaction(string eventtype, string eventid, string LedgertransactionID, int panelid, int centreid, string investigaationid, string barcodeno, string Test_id = "0", string LabObservation_ID = "0")
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            int iPkValue;


            objSQL.Append("INSERT INTO st_PatientTransaction(EventtypeID,EventtypeName, LedgertransactionID, PanelId, CentreID ,InvestigationID,BarcodeNo");
            objSQL.Append(" ,EntryDate,EntryByUserID,EntryByUserName,Test_id,LabObservation_ID)");
            objSQL.Append(" values ");

            objSQL.Append("(@EventtypeID,@EventtypeName, @LedgertransactionID, @PanelId, @CentreID ,@InvestigationID,@BarcodeNo");
            objSQL.Append(" ,now(),@EntryByUserID,@EntryByUserName,@Test_id,@LabObservation_ID)");




            iPkValue = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),
                 new MySqlParameter("@EventtypeID", eventid),
                 new MySqlParameter("@EventtypeName", eventtype),
                 new MySqlParameter("@LedgertransactionID", LedgertransactionID),
                 new MySqlParameter("@PanelId", panelid),
                 new MySqlParameter("@CentreID", centreid),
                 new MySqlParameter("@InvestigationID", investigaationid),
                 new MySqlParameter("@BarcodeNo", barcodeno),
                 new MySqlParameter("@EntryByUserID", UserInfo.ID),
                 new MySqlParameter("@EntryByUserName", UserInfo.LoginName),
                  new MySqlParameter("@Test_id", Test_id),
                 new MySqlParameter("@LabObservation_ID", LabObservation_ID));


            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return iPkValue;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }

          //  ex = new Exception(objSQL.ToString());



            throw (ex);
        }
    }



}