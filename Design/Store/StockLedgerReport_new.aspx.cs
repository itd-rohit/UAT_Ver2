using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_StockLedgerReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtfromdate.Text = "1-"+DateTime.Now.ToString("MMM-yyyy");
            txttodate.Text = DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month) + "-" + DateTime.Now.ToString("MMM-yyyy");
            bindalldata();
        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();
            //ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
        }

    }

    [WebMethod(EnableSession = true)]
    public static string getstockstatusreportexcel(string location, string Items, string manu, string machine, string fromdate, string todate, string subcat)
    {
		
        StringBuilder sb = new StringBuilder();
        sb.Append(" select cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemTypeName, ");
        sb.Append(" im.typename ItemName ,");
        sb.Append(" im.`ManufactureName`,im.`MachineName`,im.`PackSize`, im.`CatalogNo`,im.`HsnCode`,");
        
         sb.Append("  temp5.ItemID,sum(OpenQty) OpenQty,SUM(OpenAmt)OpenAmt, SUM(PurQty) PurchaseQty,SUM(PurAmt)PurchaseAmt,");
         sb.Append("  SUM(DeptRetQty)IssueReturnQty,SUM(DeptRetAmt) IssueReturnAmt,sum(VenReplacementQty)VenReplacementQty, sum(VenReplacementAmt)VenReplacementAmt,sum(GatherpQty)GatherQty,sum(GatherAmt)GatherAmt,sum(DeptRecQty)LocationReceiveQty,sum(DeptRecAmt)LocationReceiveAmt,SUM(AdjAdQty)`AdjustmentQty(+)`,SUM(AdjAddAmt)`AdjustmentAmt(+)`,");
         sb.Append(" SUM(DeptSoldQty)IssueQty,SUM(DeptSelAmt)IssueAmt,sum(ConsumeQty)ConsumeQty,sum(ConsumeAmt)ConsumeAmt,sum(AutoConsumeQty) AutoConsumeQty,sum(AutoConsumeAmt) AutoConsumeAmt,SUM(AdjustSubTQty)`ProcessQty(-)`,SUM(AdjustSubTAmt)`ProcessAmt(-)`,");
         sb.Append(" SUM(VenRetQty)VendorReturnQty,SUM(VenRetAmt)VendorReturnAmt,");

         sb.Append("  ROUND((-SUM(IFNULL(PurQty,0)+IFNULL(OpenQty,0)+IFNULL(DeptRecQty,0)+IFNULL(AdjAdQty,0)+IFNULL(PtRtnQty,0)+IFNULL(DeptRetQty,0)+IFNULL(GatherpQty,0)+IFNULL(VenReplacementQty,0))+SUM(IFNULL(DeptSoldQty,0)+IFNULL(VenRetQty,0)+IFNULL(ConsumeQty,0)+IFNULL(AdjustSubTQty,0)+IFNULL(PetsoldQty,0))),1)ClosingQty ,");
         sb.Append("  ROUND((-SUM(IFNULL(PurAmt,0)+IFNULL(OpenAmt,0)+IFNULL(DeptRecAmt,0)+IFNULL(AdjAddAmt,0)+IFNULL(PtRtnAmt,0)+IFNULL(DeptRetAmt,0)+IFNULL(GatherAmt,0)+IFNULL(VenReplacementAmt,0))+SUM(IFNULL(DeptSelAmt,0)+IFNULL(VenRetAmt,0)+IFNULL(ConsumeAmt,0)+IFNULL(AdjustSubTAmt,0)+IFNULL(PetsoldAmt,0))),1)ClosingAmt ");
        sb.Append("  From (");
        sb.Append("              Select LocationID,StockID,ItemID,(sum(InitialCount)+sum(RtnQty)-sum(SellQty))OpenQty,(sum(InitAmt)+sum(RtnAmt)-sum(SellAmt))OpenAmt,");
        sb.Append("              0 AS PurQty,0 DeptRecQty,0 AS PtRtnQty,0 AS AdjAdQty,0 AS PurAmt,0 DeptRecAmt,0 AS PtRtnAmt,0 AS AdjAddAmt, 0 As DeptSoldQty,0 As DeptRetQty,");
        sb.Append("              0 As PetSoldQty,0 As VenRetQty,0 As AdjustSubTQty, 0 As DeptSelAmt,0 As DeptRetAmt,0 As VenRetAmt, 0 As AdjustSubTAmt,");
        sb.Append("              0 As PetsoldAmt, 0 ConsumeQty,0 AutoConsumeQty, 0 GatherpQty, 0 ConsumeAmt,0 AutoConsumeAmt, 0 GatherAmt, 0 VenReplacementQty, 0 VenReplacementAmt   FROM (");

        // OLD Purchase and Adjustment 

        sb.Append("                  Select LocationID,StockID,ItemID,InitialCount,(InitialCount*UnitPrice)As InitAmt, 0 As RtnQty,0 As SellQty,0 AS RtnAmt,");
        sb.Append("                  0 As SellAmt FROM st_nmstock WHERE PostDate < '" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'  And IsPost = 1");
        //sb.Append("   and locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (location != "[]")
        {
            sb.Append(" and LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
        }

        // OLD consume/issue/return  

        sb.Append("                  Union All ");
        sb.Append("                  Select sd.fromLocationID LocationID,sd.StockID,st.ItemID,0 As InitialCount,0 As InitAmt, ");
        sb.Append("                  IFNULL((Case When sd.TrasactionTypeID in(7) Then sd.`Quantity` End),0) As RtnQty, ");
        sb.Append("                  IFNULL((Case When sd.TrasactionTypeID in(1,2,3,4,5,6) Then sd.`Quantity` End),0) As SellQty, ");
        sb.Append("                  IFNULL((Case When sd.TrasactionTypeID in(7) Then sd.`Quantity`*st.`UnitPrice` End),0) As RtnAmt, ");
        sb.Append("                  IFNULL((Case When sd.TrasactionTypeID in(1,2,3,4,5,6) Then sd.`Quantity`*st.`UnitPrice` End),0) As SellAmt ");
        sb.Append("                  FROM st_nmsalesdetails sd  ");
        sb.Append("                  INNER JOIN `st_nmstock` st ON st.`StockID`=sd.`StockID`  ");
        sb.Append("                  WHERE sd.TrasactionTypeID IN(1,2,3,4,5,6) ");
        sb.Append("                  And sd.DateTime < '" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");

        sb.Append("   and sd.fromLocationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (location != "[]")
        {
            sb.Append("              and sd.fromLocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
        }

       // sb.Append("              )temp1 group by LocationID,ItemID ");
        sb.Append("              )temp1 group by ItemID ");
        sb.Append("              Union All ");

        // Current Adjustment/'Purchase'

        sb.Append("              Select LocationID,StockID,ItemID,0 AS OpenQty,0 as OpenAmt,sum(PurchaseQty)PurQty,sum(DeptRecQty)DeptRecQty,sum(PetRtnQty)PtRtnQty, ");
        sb.Append("              sum(AdjustAddQty)AdjAdQty,sum(PurchaseAmt)PurAmt,sum(DeptRecAmt)DeptRecAmt,sum(PetRtnAmt)PtRtnAmt,sum(AdjustAddAmt)AdjAddAmt, ");
        sb.Append("              0 As DeptSoldQty, 0 As DeptRetQty,0 As PetSoldQty,0 As VenRetQty,0 As AdjustSubTQty,0 As DeptSelAmt, ");
        sb.Append("              0 As DeptRetAmt, 0 As VenRetAmt,0 As AdjustSubTAmt,0 As PetsoldAmt,");
        sb.Append(" 	         0 ConsumeQty,0 AutoConsumeQty, 0 GatherpQty, 0 ConsumeAmt,0 AutoConsumeAmt, 0 GatherAmt,sum(VendorReplacementAddQty) VenReplacementQty, sum(VendorReplacementAddAmt) VenReplacementAmt From ( ");

        sb.Append("                  SELECT st.LocationID, st.StockID, st.ItemID, st.UnitPrice, ");
        sb.Append("                  if(ifnull(lt.Typeoftnx,'')='Purchase', st.InitialCount,0) PurchaseQty,  ");
        sb.Append("                  if(ifnull(lt.Typeoftnx,'')='Purchase', st.InitialCount*st.UnitPrice ,0) PurchaseAmt, ");
        sb.Append("                  if(st.fromstockID<>0,st.InitialCount,0) and lt.Typeoftnx != 'VendorReplacement' AS DeptRecQty, ");
        sb.Append("                  0 AS PetRtnQty, ");
        sb.Append("                  if(ifnull(lt.Typeoftnx,'')='StockAdjustment', st.InitialCount,0) AS AdjustAddQty, ");
        sb.Append("                  if(st.fromstockID<>0,st.InitialCount*st.UnitPrice,0) AS DeptRecAmt, ");
        sb.Append("                  0 AS PetRtnAmt, ");
        sb.Append("                  if(ifnull(lt.Typeoftnx,'')='StockAdjustment', st.InitialCount*st.UnitPrice ,0) AS AdjustAddAmt, ");
        sb.Append("                  if(ifnull(lt.Typeoftnx,'')='VendorReplacement', st.InitialCount,0) AS VendorReplacementAddQty, ");
        sb.Append("                  if(ifnull(lt.Typeoftnx,'')='VendorReplacement', st.InitialCount*st.UnitPrice ,0) AS VendorReplacementAddAmt ");
        sb.Append("                  FROM st_nmstock st LEFT join st_ledgertransaction lt on lt.LedgerTransactionID = st.LedgerTransactionID");
        sb.Append("                  WHERE st.IsPost = 1  And st.PostDate >= '" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append("                  And st.PostDate <= '" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        sb.Append("   and st.LocationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (location != "[]")
        {
            sb.Append("              and st.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
        }
     //   sb.Append("              )Temp1 group by LocationID,ItemID ");
        sb.Append("              )Temp1 group by ItemID ");



        sb.Append("              union All ");

        sb.Append("              SELECT LocationID,StockID,ItemID,0 As OpenQty,0 As OpenAmt,sum(VenRecpQty) AS PurQty,0 DeptRecQty,sum(RetPetQty) AS PtRtnQty,0 AS AdjAdQty, ");
        sb.Append("              sum(VenRecpAmt) AS PurAmt,0 DeptRecAmt, sum(RetPetAmt) AS PtRtnAmt,0 AS AdjAddAmt,SUM(OutDeptQty)DeptSoldQty,SUM(RetDeptQty)DeptRetQty, ");
        sb.Append("              SUM(OutPetQty)PetSoldQty, SUM(RetVenQty)VenRetQty,SUM(AdjustQty)AdjustSubTQty,SUM(OutDeptAmt)DeptSelAmt, ");
        sb.Append("              SUM(RetDeptAmt)DeptRetAmt,SUM(RetVenAmt)VenRetAmt, SUM(AdjAmt)AdjustSubTAmt,SUM(OutPetAmt)PetsoldAmt, ");
        sb.Append(" 	         sum(ConsumeQty)ConsumeQty,sum(AutoConsumeQty) AutoConsumeQty,sum(GatherpQty)GatherpQty,sum(ConsumeAmt)ConsumeAmt,sum(AutoConsumeAmt) AutoConsumeAmt,sum(GatherAmt)GatherAmt, 0 VenReplacementQty, 0 VenReplacementAmt  FROM ( ");
        sb.Append("                  SELECT LocationID, StockID,ItemID,(CASE WHEN TrasactionTypeID = 2 Then Qty else 0 END)AS OutDeptQty, ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 6 Then Qty  else 0 END),0) AS RetDeptQty, ");
        sb.Append("                  0 AS OutPetQty, ");
        sb.Append("                  0 AS RetPetQty, ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 4 Then Qty  else 0 END),0) AS RetVenQty, ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 3 Then Qty  else 0 END),0) AS AdjustQty, ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 12 Then Qty  else 0 END),0) AS VenRecpQty, ");
        sb.Append("    		         IFNULL((CASE WHEN TrasactionTypeID = 1  Then Qty  else 0 END),0) AS ConsumeQty,  ");
        sb.Append("    		         IFNULL((CASE WHEN TrasactionTypeID = 5  Then Qty  else 0 END),0) AS AutoConsumeQty,  ");
        sb.Append("         	     IFNULL((CASE WHEN TrasactionTypeID = 14 Then Qty  else 0 END),0) AS GatherpQty,  ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 2 Then Qty*PerUnitBuyPrice  else 0 END),0) AS OutDeptAmt, ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 6 Then Qty*PerUnitBuyPrice  else 0 END),0) AS RetDeptAmt, ");
        sb.Append("                  0 AS OutPetAmt, ");
        sb.Append("                  0 AS RetPetAmt, ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 4 Then Qty*PerUnitBuyPrice  else 0 END),0) AS RetVenAmt, ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 12 Then Qty*PerUnitBuyPrice  else 0 END),0) AS VenRecpAmt, ");
        sb.Append("                  IFNULL((CASE WHEN TrasactionTypeID = 3 Then Qty*PerUnitBuyPrice  else 0 END),0) AS AdjAmt, ");
        sb.Append("         		 IFNULL((CASE WHEN TrasactionTypeID = 1  Then Qty*PerUnitBuyPrice  else 0 END),2) AS ConsumeAmt,  ");
        sb.Append("         		 IFNULL((CASE WHEN TrasactionTypeID = 5  Then Qty*PerUnitBuyPrice  else 0 END),0) AS AutoConsumeAmt,  ");
        sb.Append("         		 IFNULL((CASE WHEN TrasactionTypeID = 14 Then Qty*PerUnitBuyPrice  else 0 END),0) AS GatherAmt ");
        sb.Append(" 			     FROM ( ");
        sb.Append("          	        SELECT sd.FromLocationID LocationID, sd.StockID,st.ItemID,SUM(sd.`Quantity`)AS Qty,sd.TrasactionTypeID,st.UnitPrice PerUnitBuyPrice,'' IsService ");
        sb.Append("                     FROM st_nmsalesdetails sd  ");
        sb.Append("                     INNER JOIN `st_nmstock` st ON st.`StockID`=sd.`StockID`  ");
        sb.Append("                     WHERE sd.DateTime >= '" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' And sd.DateTime <= '" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        //sb.Append("   and sd.FromLocationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        if (location != "[]")
        {
            sb.Append("              and sd.FromLocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
        }

        sb.Append("          	        AND sd.TrasactionTypeID IN(1,2,3,4,5,6) ");//
        sb.Append("          	        GROUP BY sd.StockID,st.ItemID,sd.TrasactionTypeID ");
        sb.Append("                  )temp1  GROUP BY StockID,ItemID,TrasactionTypeID ");
        sb.Append("              )temp2  GROUP BY ItemID ");
        
        //sb.Append("          	        GROUP BY sd.FromLocationID,sd.StockID,st.ItemID,sd.TrasactionTypeID ");
        //sb.Append("                  )temp1  GROUP BY LocationID,StockID,ItemID,TrasactionTypeID ");
        //sb.Append("              )temp2  GROUP BY LocationID,ItemID ");
        sb.Append("          ) Temp5    ");
        sb.Append("          inner join st_itemmaster IM on Temp5.ItemID  = IM.ItemID  ");
        if (Items != "[]")
        {
            sb.Append(" and IM.itemid in (" + Util.GetString(Items).Replace("[", "").Replace("]", "") + ")");
        }


        sb.Append("        inner join st_subcategorymaster SM  ON IM.SubCategoryID = SM.SubCategoryID  ");
		 if (subcat != "[]")
         {
             sb.Append(" and IM.subcategorytypeid in (" + Util.GetString(subcat).Replace("[", "").Replace("]", "") + ")");
         }

        //sb.Append(" INNER JOIN `st_locationmaster` sl ON Temp5.`LocationID`=sl.`LocationId` ");
        //if (location != "[]")
        //{
        //    sb.Append(" and sl.LocationID in (" + Util.GetString(location).Replace("[", "").Replace("]", "") + ")");
        //}


        if (manu != "0")
        {
            sb.Append(" and im.ManufactureID='" + manu + "'");
        }
        if (machine != "0")
        {
            sb.Append(" and im.MachineID ='" + machine + "'");
        }
        sb.Append(" inner join st_categorytypemaster cat on cat.categorytypeid=im.categorytypeid  ");
		// if (cattype != "[]")
        // {
            // sb.Append(" and IM.categorytypeid in (" + Util.GetString(cattype).Replace("[", "").Replace("]", "") + ")");
        // }
        sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID   ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID  ");

        //---------------------------------


        sb.Append("          GROUP BY Temp5.ItemID ");
       // sb.Append("          GROUP BY Temp5.ItemID,sl.LocationID  ");
        sb.Append("           having ( OpenQty > 0 or  PurchaseQty > 0 or  `AdjustmentQty(+)` > 0 or  IssueQty > 0 or  IssueReturnQty > 0 or  VendorReturnQty > 0 or  `ProcessQty(-)` > 0 or  GatherQty > 0 or LocationReceiveQty > 0  ) ");
        // sb.Append("          order by  sl.LocationID,CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName,ManufactureName,MachineName,packsize ");
       // sb.Append("          ORDER BY  sl.LocationID,CategoryTypeName,SubCategoryTypeName,im.`TypeName`,ManufactureName,MachineName,packsize  ");

  sb.Append("          ORDER BY  CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName,ManufactureName,MachineName,packsize   ");



		System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\ledger.txt",sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
           
           

            DataColumn column = new DataColumn();
            column.ColumnName = "S.No";
            column.DataType = System.Type.GetType("System.Int32");
            column.AutoIncrement = true;
            column.AutoIncrementSeed = 0;
            column.AutoIncrementStep = 1;

            dt.Columns.Add(column);
            int index = 0;
            foreach (DataRow row in dt.Rows)
            {
                row.SetField(column, ++index);
            }
            dt.Columns["S.No"].SetOrdinal(0);





            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "StockMovementReport_FromDate_" + fromdate + "_ToDate_" + todate;
            return "1";
        }
        else
        {
            return "No Record Found";
        }








       
    }
    
}