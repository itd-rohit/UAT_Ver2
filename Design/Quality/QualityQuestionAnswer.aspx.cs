using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_QualityQuestionAnswer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            lbheader.Text = Util.GetString(Request.QueryString["type"]) + " Check List of " + Util.GetString(Request.QueryString["qctype"]);

        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindquestionall(string type,string qctype,string savedid)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ifnull(qas.EntryByname,'')lastsavedby, ifnull(qas.id,'0') ansid,ifnull(qas.answeroption,'') savedanswer, qa.questionid, qa.questionheadid,");
        sb.Append(" IFNULL((SELECT QuestionHead FROM qc_questionhead WHERE id=qa.QuestionHeadid),'')QuestionHead,");
        sb.Append(" if(ifnull(qas.entrydate,'')='','',date_format(qas.entrydate,'%d-%b-%Y')) lastsaveddate,");
        sb.Append(" qa.question,qa.answertype,GROUP_CONCAT(qa.answeroption order by qa.id) answeroption FROM `qc_questionanswer` qa ");
        sb.Append(" left join qc_questionanswer_saved qas on qas.questionid=qa.questionid and qas.type='" + type + "' and qas.qctype='" + qctype + "' ");
        sb.Append(" and qas.savedid=" + savedid + " and qas.isactive=1");
        sb.Append(" WHERE qa.isactive=1 AND " + type + "=1 AND " + qctype + "=1 ");
        sb.Append(" GROUP BY questionid ");
       
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public static string SaveQuestionAnswer(List<QuestionAnswerData> questiondata)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction tnx = conn.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_questionanswer_saved set IsActive=@IsActive,Updatedate=@Updatedate,UpdatebyId=@UpdatebyId,UpdateByname=@UpdateByname where SavedId=@SavedId and  Type=@Type and QCType=@QCType",
                new MySqlParameter("@IsActive", "0"),
                new MySqlParameter("@Updatedate", DateTime.Now),
                new MySqlParameter("@UpdateByID", UserInfo.ID),
                new MySqlParameter("@UpdateByname", UserInfo.LoginName),
                new MySqlParameter("@SavedId", questiondata[0].SavedID),
                new MySqlParameter("@Type", questiondata[0].Type),
                new MySqlParameter("@QCType", questiondata[0].QCType)
                );
            if(questiondata[0].QCType=="QC")
            {
                if (questiondata[0].Type == "RCA")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set RCAType='CheckList' where id=@id",
                        new MySqlParameter("@id", questiondata[0].SavedID));
                }
                else if (questiondata[0].Type == "CorrectiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set CAType='CheckList' where id=@id",
                       new MySqlParameter("@id", questiondata[0].SavedID));
                }
                else if (questiondata[0].Type == "PreventiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set PAType='CheckList' where id=@id",
                       new MySqlParameter("@id", questiondata[0].SavedID));
                }
            }
            else if (questiondata[0].QCType == "ILC")
            {
                if (questiondata[0].Type == "RCA")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcregistration set RCAType='CheckList' where Test_id=@id",
                        new MySqlParameter("@id", questiondata[0].SavedID));
                }
                else if (questiondata[0].Type == "CorrectiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcregistration set CAType='CheckList' where Test_id=@id",
                       new MySqlParameter("@id", questiondata[0].SavedID));
                }
                else if (questiondata[0].Type == "PreventiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcregistration set PAType='CheckList' where Test_id=@id",
                       new MySqlParameter("@id", questiondata[0].SavedID));
                }
            }
            else if (questiondata[0].QCType == "EQAS")
            {
                if (questiondata[0].Type == "RCA")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set RCAType='CheckList' where Test_id=@id",
                        new MySqlParameter("@id", questiondata[0].SavedID));
                }
                else if (questiondata[0].Type == "CorrectiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set CAType='CheckList' where Test_id=@id",
                       new MySqlParameter("@id", questiondata[0].SavedID));
                }
                else if (questiondata[0].Type == "PreventiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set PAType='CheckList' where Test_id=@id",
                       new MySqlParameter("@id", questiondata[0].SavedID));
                }
            }
            foreach (QuestionAnswerData qq in questiondata)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_questionanswer_saved(QuestionID,Question,AnswerType,AnswerOption,Type,QCType,SavedId,EntryDate,EntryByID,EntryByName) values (@QuestionID,@Question,@AnswerType,@AnswerOption,@Type,@QCType,@SavedId,@EntryDate,@EntryByID,@EntryByName)",
                  new MySqlParameter("@QuestionID", qq.QuestionID),
                  new MySqlParameter("@Question", qq.Question),
                  new MySqlParameter("@AnswerType", qq.AnswerType),
                  new MySqlParameter("@AnswerOption", qq.Answer),
                  new MySqlParameter("@Type", qq.Type),
                  new MySqlParameter("@QCType", qq.QCType),
                  new MySqlParameter("@SavedId", qq.SavedID),
                  new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                  new MySqlParameter("@EntryByID", UserInfo.ID),
                  new MySqlParameter("@EntryByName", UserInfo.LoginName)
                  );
            }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;

        }
        finally
        {
            tnx.Dispose();
            conn.Close();
            conn.Dispose();

        }

    }

    [WebMethod(EnableSession = true)]
    public static string RemoveQuestionAnswer(string Type, string QCType, string SavedID)
    {
         MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction tnx = conn.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_questionanswer_saved set IsActive=@IsActive,Updatedate=@Updatedate,UpdatebyId=@UpdatebyId,UpdateByname=@UpdateByname where SavedId=@SavedId and  Type=@Type and QCType=@QCType",
               new MySqlParameter("@IsActive", "0"),
               new MySqlParameter("@Updatedate", DateTime.Now),
               new MySqlParameter("@UpdateByID", UserInfo.ID),
               new MySqlParameter("@UpdateByname", UserInfo.LoginName),
               new MySqlParameter("@SavedId", SavedID),
               new MySqlParameter("@Type", Type),
               new MySqlParameter("@QCType", QCType)
               );

            if (QCType == "QC")
            {
                if (Type == "RCA")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set RCAType='' where id=@id",
                        new MySqlParameter("@id", SavedID));
                }
                else if (Type == "CorrectiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set CAType='' where id=@id",
                       new MySqlParameter("@id", SavedID));
                }
                else if (Type == "PreventiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update " + Util.getApp("MachineDB") + ".mac_observation_qc set PAType='' where id=@id",
                       new MySqlParameter("@id", SavedID));
                }
            }
            else if (QCType == "ILC")
            {
                if (Type == "RCA")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcregistration set RCAType='' where Test_id=@id",
                        new MySqlParameter("@id", SavedID));
                }
                else if (Type == "CorrectiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcregistration set CAType='' where Test_id=@id",
                       new MySqlParameter("@id", SavedID));
                }
                else if (Type == "PreventiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcregistration set PAType='' where Test_id=@id",
                       new MySqlParameter("@id", SavedID));
                }
            }

            else if (QCType == "EQAS")
            {
                if (Type == "RCA")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set RCAType='' where Test_id=@id",
                        new MySqlParameter("@id", SavedID));
                }
                else if (Type == "CorrectiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set CAType='' where Test_id=@id",
                       new MySqlParameter("@id", SavedID));
                }
                else if (Type == "PreventiveAction")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set PAType='' where Test_id=@id",
                       new MySqlParameter("@id", SavedID));
                }
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;

        }
        finally
        {
            tnx.Dispose();
            conn.Close();
            conn.Dispose();

        }
    }
}

public class QuestionAnswerData
{
    public string QuestionID { get; set; }
    public string Question { get; set; }
    public string AnswerType { get; set; }
    public string Answer { get; set; }
    public string Type { get; set; }
    public string QCType { get; set; }
    public string SavedID { get; set; }

}