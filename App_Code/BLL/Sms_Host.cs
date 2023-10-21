using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;


    public class Sms_Host
    {
        private string SmsTo;
        private string Msg;
        public string _SmsTo { get { return SmsTo; } set { SmsTo = value; } }
        public string _Msg { get { return Msg; } set { Msg = value; } }
        
        public Sms_Host()
        {
            //dt = StockReports.GetDataTable("select * from global_data where key_data='Sms_api'");
            
        }


        public void sendSms()
        {
            string Sms_api = "";
            String Result = "";
            try
            {
                Sms_api = StockReports.ExecuteScalar("select key_value from global_data where key_data='Sms_api'");
                Sms_api = Sms_api.Replace("{Mobile}", _SmsTo);
                Sms_api = Sms_api.Replace("{Sms}", _Msg);
                WebClient Client = new WebClient();
                String RequestURL, RequestData;

                RequestURL = Sms_api;

                RequestData = "";

                byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                byte[] Response = Client.UploadData(RequestURL, PostData);

                Result = Encoding.ASCII.GetString(Response);
                //int ResultCode = System.Convert.ToInt32(Result.Substring(0, 4));

            }
            catch (Exception ex) {

                Result = ex.InnerException.ToString();
            }



        }
        public void sendSmsHomeCollection()
        {
            string Sms_api = "";
            String Result = "";
            try
            {
                Sms_api = StockReports.ExecuteScalar("select key_value from global_data where key_data='Sms_api'");
                Sms_api = Sms_api.Replace("{Mobile}", _SmsTo);
                Sms_api = Sms_api.Replace("{Sms}", _Msg);
                WebClient Client = new WebClient();
                String RequestURL, RequestData;

                RequestURL = Sms_api;

                RequestData = "";

                byte[] PostData = Encoding.ASCII.GetBytes(RequestData);
                byte[] Response = Client.UploadData(RequestURL, PostData);

                Result = Encoding.ASCII.GetString(Response);
                //int ResultCode = System.Convert.ToInt32(Result.Substring(0, 4));

            }
            catch (Exception ex)
            {

                Result = ex.InnerException.ToString();
            }



        }
    }