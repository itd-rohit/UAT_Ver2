using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_QualityQuestionMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string bindquestionhead()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select id,QuestionHead from qc_questionhead order by id desc "));
    }
    [WebMethod(EnableSession = true)]
    public static string bindquestionheadall()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select id,QuestionHead,date_format(EntryDate,'%d-%b-%Y')EntryDate,EntryByName from qc_questionhead order by id asc "));
    }
    
    [WebMethod(EnableSession = true)]
    public static string SaveQuestionHead(string questionhead)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            int isduplicate = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, "select count(1) from qc_questionhead where QuestionHead=@QuestionHead and isactive=@isactive",
                  new MySqlParameter("@QuestionHead", questionhead), 
                  new MySqlParameter("@isactive", "1")));
            if (isduplicate > 0)
            {
                return "2";
            }

            MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "insert  into qc_questionhead(QuestionHead,EntryDate,EntryById,EntryByName) values (@QuestionHead,@EntryDate,@EntryById,@EntryByName)",
                 new MySqlParameter("@QuestionHead", questionhead),
                 new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                 new MySqlParameter("@EntryById", UserInfo.ID),
                 new MySqlParameter("@EntryByName", UserInfo.LoginName));
            return "1";
        }

        catch (Exception ex)
        {
           
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;

        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }

        }
    }


    [WebMethod(EnableSession = true)]
    public static string UpdateQuestionHead(string questionhead, string questionheadid)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();

        try
        {
            int isduplicate = Util.GetInt(MySqlHelper.ExecuteScalar(conn, CommandType.Text, "select count(1) from qc_questionhead where QuestionHead=@QuestionHead and isactive=@isactive and id<>@questionheadid",
                  new MySqlParameter("@QuestionHead", questionhead),
                  new MySqlParameter("@isactive", "1"),
                  new MySqlParameter("@questionheadid", questionheadid)));
            if (isduplicate > 0)
            {
                return "2";
            }

            MySqlHelper.ExecuteNonQuery(conn, CommandType.Text, "update qc_questionhead set QuestionHead=@QuestionHead,UpdateDate=@UpdateDate,UpdateById=@UpdateById,UpdateByName=@UpdateByName where id=@questionheadid",
                 new MySqlParameter("@QuestionHead", questionhead),
                 new MySqlParameter("@UpdateDate", Util.GetDateTime(DateTime.Now)),
                 new MySqlParameter("@UpdateById", UserInfo.ID),
                 new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                 new MySqlParameter("@questionheadid", questionheadid));
            return "1";
        }

        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;

        }
        finally
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }

        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindquestionall()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  ");
        sb.Append(" SELECT questionid,IFNULL((SELECT QuestionHead FROM qc_questionhead WHERE id=QuestionHeadid),'')QuestionHead,question,QuestionHeadid,");
        sb.Append(" answertype,GROUP_CONCAT(answeroption)answeroption,rca,`CorrectiveAction`,");
        sb.Append(" `PreventiveAction`,ilc,eqas,qc,cap,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate,EntryByName");
        sb.Append(" FROM qc_questionanswer qq WHERE isactive=1  GROUP BY questionid");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    

    [WebMethod(EnableSession = true)]
    public static string SaveQuestion(List<QualityQuestion> questiondata)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction tnx = conn.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string questionid = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT qc_get_question_id();"));
            foreach (QualityQuestion qq in questiondata)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_questionanswer(QuestionID,QuestionHeadID,Question,AnswerType,AnswerOption,EntryDate,EntryByID,EntryByName,RCA,CorrectiveAction,PreventiveAction,ILC,EQAS,QC,CAP) values (@QuestionID,@QuestionHeadID,@Question,@AnswerType,@AnswerOption,@EntryDate,@EntryByID,@EntryByName,@RCA,@CorrectiveAction,@PreventiveAction,@ILC,@EQAS,@QC,@CAP)",
                  new MySqlParameter("@QuestionID", questionid),
                  new MySqlParameter("@QuestionHeadID", qq.QuestionHeadID),
                  new MySqlParameter("@Question", qq.Question),
                  new MySqlParameter("@AnswerType", qq.AnswerType),
                  new MySqlParameter("@AnswerOption", qq.AnswerOption),
                  new MySqlParameter("@RCA", qq.RCA),
                  new MySqlParameter("@CorrectiveAction", qq.CorrectiveAction),
                  new MySqlParameter("@PreventiveAction", qq.PreventiveAction),
                  new MySqlParameter("@ILC", qq.ILC),
                  new MySqlParameter("@EQAS", qq.EQAS),
                  new MySqlParameter("@QC", qq.QC),
                  new MySqlParameter("@CAP", qq.CAP),
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
    public static string UpdateQuestion(List<QualityQuestion> questiondata)
    {
        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction tnx = conn.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string questionid = questiondata[0].QuestionID;



            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_questionanswer set IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where QuestionID=@QuestionID",
                new MySqlParameter("@IsActive","0"),
                new MySqlParameter("@UpdateDate",DateTime.Now),
                new MySqlParameter("@UpdateByID",UserInfo.ID),
                new MySqlParameter("@UpdateByName",UserInfo.LoginName),
                new MySqlParameter("@QuestionID",questiondata[0].QuestionID)
                );

            foreach (QualityQuestion qq in questiondata)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_questionanswer(QuestionID,QuestionHeadID,Question,AnswerType,AnswerOption,EntryDate,EntryByID,EntryByName,RCA,CorrectiveAction,PreventiveAction,ILC,EQAS,QC,CAP) values (@QuestionID,@QuestionHeadID,@Question,@AnswerType,@AnswerOption,@EntryDate,@EntryByID,@EntryByName,@RCA,@CorrectiveAction,@PreventiveAction,@ILC,@EQAS,@QC,@CAP)",
                  new MySqlParameter("@QuestionID", questionid),
                  new MySqlParameter("@QuestionHeadID", qq.QuestionHeadID),
                  new MySqlParameter("@Question", qq.Question),
                  new MySqlParameter("@AnswerType", qq.AnswerType),
                  new MySqlParameter("@AnswerOption", qq.AnswerOption),
                  new MySqlParameter("@RCA", qq.RCA),
                  new MySqlParameter("@CorrectiveAction", qq.CorrectiveAction),
                  new MySqlParameter("@PreventiveAction", qq.PreventiveAction),
                  new MySqlParameter("@ILC", qq.ILC),
                  new MySqlParameter("@EQAS", qq.EQAS),
                  new MySqlParameter("@QC", qq.QC),
                  new MySqlParameter("@CAP", qq.CAP),
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
    public static string deletequestion(string questionid)
    {
        StockReports.ExecuteDML("update qc_questionanswer set IsActive=0,UpdateDate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='" + UserInfo.LoginName + "' where QuestionID='" + questionid + "'");
        return "1";
    }
    
}

public class QualityQuestion
{
    public string QuestionHeadID { get; set; }
    public string Question { get; set; }
    public string AnswerType { get; set; }
    public string AnswerOption { get; set; }
    public int RCA { get; set; }
    public int CorrectiveAction { get; set; }
    public int PreventiveAction { get; set; }
    public int ILC { get; set; }
    public int EQAS { get; set; }
    public int QC { get; set; }
    public int CAP { get; set; }
    public string QuestionID { get; set; }
}