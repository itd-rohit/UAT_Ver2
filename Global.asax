<%@ Application Language="C#" %>
<%@ Import Namespace="Bundle" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="System.Web.Routing" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.Http" %>
<script runat="server">
void Application_PreRequestHandlerExecute(Object sender, EventArgs e)
    {
        CheckIncomming(sender, e);
        if (Context.Handler is IRequiresSessionState || Context.Handler is IReadOnlySessionState)
        {
            var page = (Context.Handler as System.Web.UI.Page);
            var pageName = System.IO.Path.GetFileName(Request.Url.AbsolutePath);
            int LoginStatus = 1;
            if (pageName != "Default.aspx" && pageName != "Welcome.aspx")
            {
                HttpCookie cookie = Request.Cookies["Login"];
                if (cookie != null)
                {
                    if (string.IsNullOrEmpty(cookie.Value) || Session["CookiesLoginDateTime"] == null || Util.GetDateTime(Session["CookiesLoginDateTime"]) < Util.GetDateTime(DateTime.UtcNow) || Session["CookiesLogin"] == null || Session["CookiesLogin"].ToString() != cookie.Value)
                    {
                        LoginStatus = 0;
                    }
                }
                else
                {
                    LoginStatus = 0;
                }


                if (LoginStatus==0)
                {
                     //  HttpContext.Current.Response.Redirect("~/LogOut.aspx?sessionTimeOut=true", false);
                }




            }
        }

    }
    void Application_Start(object sender, EventArgs e) 
    {       
        CacheQuery.loadAllDataonCache();
        BundleConfig.RegisterBundles(BundleTable.Bundles);

        RegisterRoutes(RouteTable.Routes);
        GlobalConfiguration.Configure(WebApiConfig.Register);
    }
    static void RegisterRoutes(RouteCollection routes)
    {
        //routes.MapPageRoute("Welcome", "Welcome", "~/Design/Welcome.aspx", true);
        //routes.MapPageRoute("Welcome1", "Lab_PrescriptionOPD13", "~/Design/Lab/ViewDocument.aspx", false);
        //routes.MapPageRoute("Welcome56", "Welcome", "~/Design/Welcome.aspx", true);

        //routes.MapPageRoute("Lab_PrescriptionOPD", "Lab_PrescriptionOPD1", "~/Design/Lab/Lab_PrescriptionOPD.aspx",true);
    }
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
       //public static string[] blackList = {";--","/*","*/","truncate ",
       //                                    "update ","alter ","cursor","declare","delete ","drop ",
       //                                    "fetch ","insert ","kill ","sysobjects","syscolumns","tablespace"};

    public static string[] blackList = {";--","/*","*/","truncate ",
                                         "update ","alter ","cursor","declare","delete ","drop ",
                                       "fetch ","insert ","kill ","sysobjects","syscolumns","tablespace",                                
"<applet>",
"<body>",
"<embed>",
"<frame>",
"<script>",
"<frameset>",
"<html>",
"<iframe>",
"<img>",
"<style>",
"<layer>",
"<link>",
"<ilayer>",
"<meta>",
"<object>",
                                       
                                       };                                  
                                   
       
void CheckIncomming(Object sender, EventArgs e)
    {
        try
        {
            var context = HttpContext.Current;
            var response = context.Response;

            HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "*");

            if (HttpContext.Current.Request.HttpMethod == "OPTIONS")
            {
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "POST,GET,OPTIONS,PUT,DELETE");
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept");
                HttpContext.Current.Response.End();
            }

            HttpRequest Request = (sender as HttpApplication).Context.Request;
            string message = (new System.IO.StreamReader(Request.InputStream)).ReadToEnd();

            if (Request.Form.Count > 0)
            {
                foreach (string key in Request.Form)
                    CheckInput(Request.Form[key]);
            }
            else if (Request.QueryString.Count > 0)
            {
                foreach (string key in Request.QueryString)
                    CheckInput(Request.QueryString[key]);
            }
            //else if (Request.Cookies.Count > 0)
            //{
            //    foreach (string key in Request.Cookies)
            //        CheckInput(Request.Cookies[key].Value);
            //}
            else
            {

                HttpContext.Current.Request.InputStream.Position = 0;
                CheckInput(message);
            }



        }
        catch (Exception ex)
        {
            HttpContext.Current.Response.StatusCode = 500;
        }
        if (Context.Handler is IRequiresSessionState || Context.Handler is IReadOnlySessionState)
        {
            try
            {
                Page page = (Context.Handler as System.Web.UI.Page);
                string pageName = System.IO.Path.GetFileName(Request.Url.AbsolutePath);
                if (pageName != "Default.aspx" && pageName != "Welcome.aspx" && pageName.ToLower() != "labreportmicro.aspx" && pageName.ToLower() != "labreportnewhisto.aspx" && pageName.ToLower() != "printlabreport_pdf.aspx" && pageName.ToLower() != "createzip.aspx" && pageName.ToLower() != "result.aspx")
                {
                   // if (Session["ID"] == null)
                     //   this.Context.Response.Redirect("~/Default.aspx?sessionTimeOut=true",false);
                }
            }
            catch (Exception ex)
            {

            }
        }
    }

    public void CheckInput(string parameter)
    {
        if (!ValidateAntiXSS(parameter))
        {
            HttpContext.Current.Response.Redirect("~/Default.aspx?sessionTimeOut=true");
            return;
        }
        for (int i = 0; i < blackList.Length; i++)
        {
            if ((parameter.IndexOf(blackList[i], StringComparison.OrdinalIgnoreCase)) >= 0)
            {
                string userID = string.Empty;
                try
                {
                    userID = Util.GetString(HttpContext.Current.Session["ID"].ToString());
                }
                catch (Exception) { }

                System.IO.File.WriteAllText(@"C:\aaa_Injection\" + blackList[i] + "--" + userID + "--" + System.IO.Path.GetFileName(Request.Url.AbsolutePath) + ".txt", parameter.ToString());
                HttpContext.Current.Response.Redirect("~/Design/Default.aspx?sessionTimeOut=true", false);
                System.IO.File.AppendAllText("D:\\abc.txt", parameter);  
            }
        }
    }
    void Application_AcquireRequestState(object sender, EventArgs e)
    {
                
        if (System.Web.HttpContext.Current.Session != null)
        {            
            Page page = (Context.Handler as System.Web.UI.Page);
            string pageName = System.IO.Path.GetFileName(Request.Url.AbsolutePath);           
            if (ValidationSkipPage.notCheckSessionState().Where(x => x.ToLower() == pageName.ToLower()).Count() == 0)
            {
                if (HttpContext.Current.Session["ID"] == null)
                {
                   // HttpContext.Current.Response.Redirect("~/LogOut.aspx?sessionTimeOut=true", false);
                }
                else
                {
                    if ((HttpContext.Current.Request.Headers["AuthToken"] ?? "").Trim().Length > 0)
                    {
                        if (HttpContext.Current.Session["ID"].ToString() != HttpContext.Current.Request.Headers.GetValues("AuthToken").FirstOrDefault().ToString())
                        {
                            HttpContext.Current.Response.Redirect("~/LogOut.aspx?sessionTimeOut=true", false);
                        }
                    }
                }
            }            
        }
    }          
void Application_BeginRequest(object sender, EventArgs e)
    {
        
    }

public static bool ValidateAntiXSS(string inputParameter)
{
    if (string.IsNullOrEmpty(inputParameter))
        return true;

    // Following regex convers all the js events and html tags mentioned in followng links.
    //https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet                 
    //https://msdn.microsoft.com/en-us/library/ff649310.aspx

    var pattren = new StringBuilder();

    //Checks any js events i.e. onKeyUp(), onBlur(), alerts and custom js functions etc.             
    pattren.Append(@"((alert|on\w+|function\s+\w+)\s*\(\s*(['+\d\w](,?\s*['+\d\w]*)*)*\s*\))");

    //Checks any html tags i.e. <script, <embed, <object etc.
    pattren.Append(@"|(<(script|iframe|embed|frame|frameset|object|img|applet|body|html|style|layer|link|ilayer|meta|bgsound))");

    return !Regex.IsMatch(System.Web.HttpUtility.UrlDecode(inputParameter), pattren.ToString(), RegexOptions.IgnoreCase | RegexOptions.Compiled);
}
        
</script>
