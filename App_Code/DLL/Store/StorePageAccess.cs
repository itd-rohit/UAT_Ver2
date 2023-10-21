using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for StorePageAccess
/// </summary>
public static class StorePageAccess
{

    public static string OpenStockPhysicalVerificationPage(string locationid)
    {
        if (Util.getApp("StoreLockStockPhysicalVerification") == "1")
        {

            int cnt = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(1) FROM `st_pageaccess` WHERE `LocationID`=" + locationid + " AND `FromDate`<= CURRENT_DATE AND `ToDate` >= CURRENT_DATE   AND `IsActive`=1 AND YEAR(CURRENT_DATE)=EntryYear AND MONTH(CURRENT_DATE)=entryMonth"));

            if (cnt > 0)
                return "1";
            else
                return "Physical verification is not open for today. Please contact to admin department ";

        }
        else
        {
            return "1";
        }
    }

    public static string OpenOtherStockPages(string locationid)
    {
        if (Util.getApp("StoreLockStockPhysicalVerification") == "1")
        {

            int cnt = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(1) FROM `st_pageaccess` WHERE `LocationID`=" + locationid + " AND `FromDate`<= CURRENT_DATE AND `ToDate` >= CURRENT_DATE   AND `IsActive`=1 AND YEAR(CURRENT_DATE)=EntryYear AND MONTH(CURRENT_DATE)=entryMonth"));

            if (cnt > 0)
                return "This page is not open for today. Please contact to admin department ";
            else
                return "1";
                


        }
        else
        {
            return "1";
        }
    }
}