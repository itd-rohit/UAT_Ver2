<%@ WebService Language="C#" Class="VendorPortal" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
[System.Web.Script.Services.ScriptService]
public class VendorPortal  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }


    [WebMethod(EnableSession = true)]
    public string LogOut(string supplierid)
    {
        Session.RemoveAll();
        Session.Abandon();
        StockReports.ExecuteDML(" UPDATE st_vendorlogindetail ld INNER JOIN (SELECT MAX(ID)ID, SupplierID FROM st_vendorlogindetail WHERE  SupplierID ='" + supplierid + "' GROUP BY  SupplierID) ld2 ON ld.ID=ld2.ID SET ld.LogOutTime =NOW()");
        return "logout";
    }

    
}