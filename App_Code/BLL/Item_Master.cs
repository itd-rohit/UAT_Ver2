using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for Item_Master
/// </summary>
public class Item_Master
{
    public Item_Master()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataTable Get_NablInvestigations(string CentreId, string CategoryId, string SubCategoryId)
    {


        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sc.`SubCategoryID`,sc.`Name` AS DeptName,im.`Type_ID`,im.`TypeName` AS InvName,ifnull(id.isNABL,0)isNABL ");
        sb.Append(" FROM `f_itemmaster` im ");
        sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
        if (SubCategoryId.ToUpper() != "ALL")
            sb.Append(" AND sc.`SubcategoryID`='" + SubCategoryId + "' ");
        sb.Append(" AND sc.`CategoryID`='" + CategoryId + "' ");
        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT * FROM `investiagtion_isNABL` WHERE  `CentreID`='" + CentreId + "' ");
        if (SubCategoryId.ToUpper() != "ALL")
            sb.Append(" AND `SubCategoryID`='" + SubCategoryId + "' ");
        sb.Append(" ) id ");
        sb.Append(" ON id.Investigation_id=im.`Type_ID` AND id.SubCategoryID=im.`SubCategoryID` ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return dt;
    }

    public string Save_isNABLInv(string CentreId, string CategoryId, string SubCategoryId, string ItemData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // Itemdata= 0)SubCategoryID|1)InvID|2)isNABL
            ItemData = ItemData.TrimEnd('#');

            string str = string.Empty;
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            for (int i = 0; i < len; i++)
            {
                SubCategoryId = Util.GetString(Item[i].Split('|')[0]).Split('#')[0];
                str = "Delete from investiagtion_isnabl where CentreID=@CentreID and SubcategoryID=@SubcategoryID and Investigation_ID=@Investigation_ID";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str,
                   new MySqlParameter("@CentreID", CentreId), new MySqlParameter("@SubcategoryID", SubCategoryId),
                   new MySqlParameter("@Investigation_ID", Util.GetString(Item[i].Split('|')[1])));

                string strins = " Insert into investiagtion_isnabl (`CentreID`,`SubcategoryID`, `Investigation_ID`,isNABL) " +
                       " values (@CentreID,@SubCategoryId,@Investigation_ID,@isNABL) ";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strins,
                   new MySqlParameter("@CentreID", CentreId), new MySqlParameter("@SubCategoryId", SubCategoryId),
                   new MySqlParameter("@Investigation_ID", Util.GetString(Item[i].Split('|')[1])), new MySqlParameter("@isNABL", Util.GetInt(Item[i].Split('|')[2])));
            }

            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveOutSource_LabInv(string CentreID, string ItemData)
    {
        // ItemData=(1)InvID|(2)OutsrcLabID,OutsrcLabName,IsDefault$#
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = string.Empty;
            ItemData = ItemData.TrimEnd('#');
            int len = Util.GetInt(ItemData.Split('#').Length);

            string[] Item = new string[len];
            Item = ItemData.Split('#');
            for (int i = 0; i < len; i++)
            {
                string invID = Item[i].Split('|')[0];
                string outSrc = Item[i].Split('|')[1];

                string strdel = "DELETE FROM investigations_outsrclab WHERE CentreID =@CentreID AND Investigation_ID =@Investigation_ID  ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strdel,
                    new MySqlParameter("@CentreID", CentreID), new MySqlParameter("@Investigation_ID", invID));

                outSrc = outSrc.TrimEnd('$');
                int outlen = Util.GetInt(outSrc.Split('$').Length);
                string[] outSrcData = new string[outlen];
                outSrcData = outSrc.Split('$');
                for (int j = 0; j < outlen; j++)
                {
                    string UserID = HttpContext.Current.Session["ID"].ToString();
                    if (outSrcData[j].ToString() != string.Empty)
                    {
                        str = "insert into investigations_outsrclab(OutSrcLabID,OutSrcLabName,IsDefault, Investigation_ID ,CentreID,CreatedUserID,CreatedDate) values(@OutSrcLabID,@OutSrcLabName,@IsDefault,@Investigation_ID,@CentreID,@UserID,NOW()) ";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str,
                            new MySqlParameter("@OutSrcLabID", outSrcData[j].Split(',')[0]), new MySqlParameter("@OutSrcLabName", outSrcData[j].Split(',')[1]), new MySqlParameter("@IsDefault", outSrcData[j].Split(',')[2]),
                             new MySqlParameter("@Investigation_ID", invID), new MySqlParameter("@CentreID", CentreID), new MySqlParameter("@UserID", UserID));


                        str = "update f_itemmaster set IsTrigger=1 where type_id=@type_id AND SubCategoryID<>'LSHHI24'";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str,
                           new MySqlParameter("@type_id", invID));
                    }
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
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetOutsource_LabInvestigation(string CentreID, string CategoryId, string SubCategoryId)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT im.ItemID,im.Type_ID,  cm.Name CategoryName, cm.CategoryID, sc.Name  SubCategoryName, sc.SubCategoryId, im.TypeName, ");
        sb.Append(" GROUP_CONCAT(CONCAT(ios.OutSrcLabID,'|',ios.OutSrcLabName) ORDER BY ios.IsDefault DESC SEPARATOR '$')OutSrcLabName ");
        sb.Append(" FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = im.SubCategoryID ");
        sb.Append(" AND im.IsActive = 1  AND sc.CategoryID = '" + CategoryId + "' ");
        if (SubCategoryId != "All")
        {
            sb.Append(" and sc.SubCategoryID='" + SubCategoryId + "'  ");
        }
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID = sc.CategoryID  ");

        sb.Append(" LEFT OUTER JOIN investigations_outsrclab ios ON ios.Investigation_ID = im.Type_ID AND ios.CentreID ='" + CentreID + "' ");
        sb.Append(" GROUP BY im.Type_ID ORDER BY cm.Name,sc.Name,im.TypeName ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return dt;
    }

    public DataTable Getpanelitems(string GroupID)
    {
        string str = "SELECT Company_Name,CONCAT(Panel_ID,'#',ReferenceCodeOPD)PanelID FROM f_panel_master WHERE PanelGroupID='" + GroupID + "' AND Panel_ID=ReferenceCodeOPD";
        using (DataTable dt = StockReports.GetDataTable(str))
            return dt;
    }

    public DataTable Getsubcategoryitems(string CategoryID)
    {
        string str = "Select sc.Name,concat(sc.SubcategoryID,'#',if(sm.Department is null,'0','1'))SubcategoryID from (Select Name,SubCategoryID from f_Subcategorymaster where CategoryID ='" + CategoryID + "' and Active=1 order by Name)sc left join  (Select distinct department from f_surgery_master) sm on sm.Department = sc.Name";
        using (DataTable dt = StockReports.GetDataTable(str))
            return dt;
    }

    public DataTable GetPanelwise_Itemrate(string PanelId, string CategoryId, string SubCategoryId, string billcategory)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select  im.`TestCode`,im.ItemID,cm.Name CategoryName,cm.CategoryID,sc.Name SubCategoryName,sc.SubCategoryId ,im.TypeName,ifnull(round(r.Rate," + Resources.Resource.BaseCurrencyRound + "),'0')Rate,ifnull(round(r.mrp_rate," + Resources.Resource.BaseCurrencyRound + "),'0')ERate,r.ItemCode,r.ItemDisplayName, r.`SpecialFlag`");
        sb.Append(" from f_itemmaster im inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID ");
        sb.Append(" and im.IsActive=1 AND im.ShowInRateList=1 and sc.CategoryID='" + CategoryId + "' ");
        if (billcategory == "0")
        {
            if (SubCategoryId != "All")
            {
                sb.Append(" and sc.SubCategoryID='" + SubCategoryId + "'  ");
            }
        }
        else
        {
            sb.Append(" and im.Bill_Category='" + billcategory + "'");
        }
        sb.Append(" inner join f_categorymaster cm on cm.CategoryID=sc.CategoryID ");
        sb.Append(" INNER JOIN f_panel_master pm ON pm.panel_id='" + PanelId + "' ");
        sb.Append(" left outer join f_ratelist r on r.ItemID=im.ItemID ");
        sb.Append(" and r.IsCurrent=1 and r.Panel_ID=pm.panel_id order by cm.Name,sc.Name,im.TypeName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return dt;
    }

    public DataTable GetDoctorwise_ItemDiscount(string Doctor_ID, string CategoryId, string SubCategoryId, string billcategory)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT '" + Doctor_ID + "' doctor_id, im.ItemID,cm.Name CategoryName,cm.CategoryID,sc.Name SubCategoryName,sc.SubCategoryId ,im.TypeName,IFNULL(pm.discountper,'0')discountper,IFNULL(pm.discountamt,'0')discountamt ");
        sb.Append(" FROM f_itemmaster im INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
        sb.Append(" AND im.IsActive=1 AND sc.CategoryID='" + CategoryId + "' ");

        if (billcategory == "0")
        {
            if (SubCategoryId != "All")
            {
                sb.Append(" and sc.SubCategoryID='" + SubCategoryId + "'");
            }
        }
        else
        {
            sb.Append(" and im.Bill_Category='" + billcategory + "'");
        }
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID=sc.CategoryID ");
        sb.Append(" LEFT JOIN referdoctor_discountmaster pm ON pm.item_id=im.`ItemID` AND pm.`doctor_id`='" + Doctor_ID + "' ");
        sb.Append(" ORDER BY cm.Name,sc.Name,im.TypeName ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return dt;
    }

    public DataTable Get_Role(string RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select ID, RoleName,MaxDiscount,EditInfo,EditPriscription,Settlement,DiscAfterBill,ChangePanel,ChangePayMode,ReceiptCancel,LabRefund ");
        sb.Append(" from f_rolemaster ");
        sb.Append(" Where Active=1 and ID='" + RoleID + "' ");
        sb.Append(" order by RoleName ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return dt;
    }

    public string SavePanelwiseItemrate(string PanelId, string ItemData, int TaggedPUP)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // Itemdata= Itemid|ItemName|Rate|DisplayName|Itemcode#
            ItemData = ItemData.TrimEnd('#');

            string str = string.Empty;
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            //VIVEK  START



            DataTable dt_LTD_NEW1 = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, " select  *,im.`TestCode`,im.ItemID,cm.Name CategoryName,cm.CategoryID,sc.Name SubCategoryName,sc.SubCategoryId ,im.TypeName,r.Rate,r.mrp_rate ERate,r.ItemCode,r.ItemDisplayName, r.`SpecialFlag` ,IFNULL(im.BaseRate,0)BaseRate from f_itemmaster im inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID and im.IsActive=1  inner join f_categorymaster cm on cm.CategoryID=sc.CategoryID  INNER JOIN f_panel_master pm ON pm.panel_id=@panel_id inner join f_ratelist r on r.ItemID=im.ItemID and r.IsCurrent=1 and r.Panel_ID=pm.panel_id order by cm.Name,sc.Name,im.TypeName",
                new MySqlParameter("@panel_id", PanelId.Split('#')[0].ToString())).Tables[0];
          //  DataTable dt_LTD_NEW1 = StockReports.GetDataTable(sb_NEW1.ToString());


            //VIVEK END



            StringBuilder sb_1 = new StringBuilder();
            sb_1.Append(" SELECT ID,Hospital_ID,RateListID,StockID,Rate , mrp_rate,ERate,IsTaxable,FromDate,ToDate,IsCurrent,ItemID,IsService,Commission,Panel_ID,ItemDisplayName,ItemCode,UpdateBy,UpdateRemarks,ReferedPanel_ID,ReferedSharePer,SpecialFlag,DeletedByID,DeletedBy,DeletedDate,Location,Hospcode   FROM f_ratelist WHERE ItemID ='" + Item[0].Split('|')[0].ToString() + "' and panel_id='" + PanelId.Split('#')[0].ToString() + "'");
            DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());

            for (int i = 0; i < len; i++)
            {
                if (TaggedPUP == 1)
                {
                    DataTable dtPaneType = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, "SELECT PanelType FROM f_panel_master WHERE panel_id=@panel_id",
                        new MySqlParameter("@panel_id", PanelId.Split('#')[0].ToString())).Tables[0];
                    if (dtPaneType.Rows.Count > 0 && Util.GetString(dtPaneType.Rows[0]["PanelType"]) == "PUP")
                    {
                        continue;
                    }
                }

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE ItemID =@ItemID AND  Panel_ID=@Panel_ID ",
              new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
              new MySqlParameter("@ItemID", Item[i].Split('|')[0].ToString()),
              new MySqlParameter("@Panel_ID", PanelId.Split('#')[0].ToString()));

                str = "DELETE FROM f_ratelist WHERE ItemID =@ItemID AND Panel_ID=@Panel_ID";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str,
                    new MySqlParameter("@ItemID", Item[i].Split('|')[0].ToString()), new MySqlParameter("@Panel_ID", PanelId.Split('#')[0].ToString()));
                RateList objRateList = new RateList(Tnx);
                objRateList.Panel_ID = Util.GetInt(PanelId.Split('#')[0].ToString());
                objRateList.ItemID = Util.GetInt(Item[i].Split('|')[0].Trim());
                objRateList.Rate = Util.GetDecimal(Item[i].Split('|')[2].Trim());
                objRateList.ERate = Util.GetDecimal(Item[i].Split('|')[3].Trim());
                objRateList.IsTaxable = 0;
                objRateList.FromDate = DateTime.Now;
                objRateList.ToDate = DateTime.Now;
                objRateList.IsCurrent = 1;
                objRateList.IsService = "YES";
                objRateList.MrpRate = Util.GetDecimal(Item[i].Split('|')[6].Trim());
                objRateList.ItemDisplayName = Util.GetString(Item[i].Split('|')[4].Trim());
                objRateList.ItemCode = Util.GetString(Item[i].Split('|')[5].Trim());
                objRateList.UpdateBy = HttpContext.Current.Session["LoginName"].ToString();
                objRateList.UpdateRemarks = string.Empty;
                objRateList.UpdateDate = System.DateTime.Now;
                objRateList.Insert();

                // For Tagged PUP
                // To Check Panel Centre Type
                if (TaggedPUP == 1)
                {
                    StringBuilder sbPanelCentre = new StringBuilder();
                    sbPanelCentre.Append(" SELECT CentreID FROM f_panel_master where  ");
                    sbPanelCentre.Append(" `Panel_ID`=" + PanelId.Split('#')[0].ToString() + " AND `IsActive`=1 ");

                    DataTable dtPanelCentre = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sbPanelCentre.ToString()).Tables[0];
                    if (dtPanelCentre.Rows.Count > 0 && Util.GetString(dtPanelCentre.Rows[0]["CentreID"]) != "0")
                    {
                        DataTable dtPUP = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, " SELECT `Panel_ID`,`Company_Name`,`ReferenceCode`,`DiscPercent` FROM f_panel_master WHERE `TagProcessingLabID`=@TagProcessingLabID AND paneltype='PUP' AND IsActive=1 ",
                           new MySqlParameter("@TagProcessingLabID", Util.GetString(dtPanelCentre.Rows[0]["CentreID"]))).Tables[0];
                        foreach (DataRow drPUP in dtPUP.Rows)
                        {
                            int IsSpecialFlag = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, " Select count(*) from f_ratelist where panel_id=@panel_id and Itemid=@Itemid and SpecialFlag=1 ",
                               new MySqlParameter("@panel_id", Util.GetString(drPUP["ReferenceCode"])), new MySqlParameter("@Itemid", Item[i].Split('|')[0].ToString())));
                            if (IsSpecialFlag == 0)
                            {

                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE ItemID =@ItemID AND  Panel_ID=@Panel_ID AND SpecialFlag=0",
                                              new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
                                              new MySqlParameter("@ItemID", Item[i].Split('|')[0].ToString()),
                                              new MySqlParameter("@Panel_ID", Util.GetString(drPUP["ReferenceCode"])));

                                string strPUP = string.Empty;
                                strPUP = "DELETE FROM f_ratelist WHERE ItemID =@ItemID and  panel_id=@panel_id and SpecialFlag=0 ";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strPUP,
                                   new MySqlParameter("@ItemID", Item[i].Split('|')[0].ToString()), new MySqlParameter("@panel_id", Util.GetString(drPUP["ReferenceCode"])));
                                double PUPItemRate = (Util.GetInt(drPUP["DiscPercent"]) == 0) ? Util.GetDouble(Item[i].Split('|')[2].Trim()) : (Util.GetDouble(Item[i].Split('|')[2].Trim()) * (100 - Util.GetInt(drPUP["DiscPercent"])) * 0.01);

                                RateList objRateListPUP = new RateList(Tnx);
                                objRateListPUP.Panel_ID = Util.GetInt(drPUP["ReferenceCode"]);
                                objRateListPUP.ItemID = Util.GetInt(Item[i].Split('|')[0].Trim());
                                objRateListPUP.Rate = Util.GetDecimal(Math.Round(PUPItemRate));
                                objRateListPUP.ERate = Util.GetDecimal(Item[i].Split('|')[2].Trim());
                                objRateListPUP.IsTaxable = 0;
                                objRateListPUP.FromDate = DateTime.Now;
                                objRateListPUP.ToDate = DateTime.Now;
                                objRateListPUP.IsCurrent = 1;
                                objRateListPUP.IsService = "YES";
                                objRateListPUP.MrpRate = Util.GetDecimal(Item[i].Split('|')[6].Trim());
                                objRateListPUP.ItemDisplayName = Util.GetString(Item[i].Split('|')[4].Trim());
                                objRateListPUP.ItemCode = Util.GetString(Item[i].Split('|')[5].Trim());
                                objRateListPUP.UpdateBy = HttpContext.Current.Session["LoginName"].ToString();
                                objRateListPUP.UpdateRemarks = "ItemWisePanelRate_TaggedPUP";
                                objRateListPUP.UpdateDate = System.DateTime.Now;
                                objRateListPUP.Insert();
                            }
                        }
                    }
                }
                string SubCategoryID = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SubCategoryID FROM f_itemmaster WHERE ItemID=@ItemID",
                   new MySqlParameter("@ItemID", Util.GetString(Item[i].Split('|')[0].Trim()))).ToString();
                if (SubCategoryID == "15")
                {
                    int IsBaserate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_ratelist_PackageDetails WHERE PackageItemID=@PackageItemID AND PanelID=@Panel_ID AND IsBaseRate=1 ",
                                new MySqlParameter("@PackageItemID", Util.GetString(Item[i].Split('|')[0].Trim())),
                                new MySqlParameter("@Panel_ID", PanelId.Split('#')[0].ToString())));

                    StringBuilder sb = new StringBuilder();

                    if (IsBaserate > 0)
                    {
                        sb.Clear();
                        sb.Append(" UPDATE  ");
                        sb.Append(" `package_labdetail` pld ");
                        sb.Append(" INNER JOIN f_itemmaster im  ON im.`Type_ID`=inv.`Investigation_Id` ");
                        sb.Append(" INNER JOIN f_ratelist_PackageDetails frp  ON frp.PackageItemID=pld.PlabID AND frp.TestItemID=im.ItemID AND IsBaseRate=1 ");
                        sb.Append(" AND pld.`PlabID`=@PackageItemID   AND frp.PanelID=@Panel_ID ");
                        sb.Append(" SET PackageRate=@PackageRate,TestRate=ROUND(@PackageRate * frp.TestPer * 0.01,2) ");

                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PackageItemID", Util.GetString(Item[i].Split('|')[0].Trim())),
                            new MySqlParameter("@PackageRate", Util.GetDouble(Item[i].Split('|')[1].Trim())),
                            new MySqlParameter("@Panel_ID", PanelId.Split('#')[0].ToString()), new MySqlParameter("@CreatedByID", UserInfo.ID));

                    }
                    else
                    {
                        sb.Clear();

                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM f_ratelist_PackageDetails WHERE PackageItemID=@PackageItemID AND PanelID=@PanelID AND IsBaseRate=0 ",
                            new MySqlParameter("@PackageItemID", Util.GetString(Item[i].Split('|')[0].Trim())),
                            new MySqlParameter("@PanelID", PanelId.Split('#')[0].ToString()));


                        sb.Append(" INSERT INTO f_ratelist_PackageDetails(PackageItemID,PackageRate,PanelId,TestItemId,TestRate,TestPer,CreatedByID,IsBaseRate) ");
                        sb.Append(" SELECT @PackageItemID,@Rate,@Panel_ID,im.ItemID TestItemId,ROUND(@Rate * frp.TestPer * 0.01,2),frp.TestPer,@CreatedByID,0 IsBaseRate ");
                        sb.Append(" FROM `package_labdetail` pld  ");
                        sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
                        sb.Append(" INNER JOIN f_itemmaster im  ON im.`Type_ID`=inv.`Investigation_Id` ");
                        sb.Append(" INNER JOIN f_ratelist_PackageDetails frp  ON frp.PackageItemID=pld.PlabID AND frp.TestItemID=im.ItemID AND IsBaseRate=1 ");
                        sb.Append(" AND pld.`PlabID`=@PackageItemID    ");
                        sb.Append(" ");
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PackageItemID", Util.GetString(Item[i].Split('|')[0].Trim())),
                            new MySqlParameter("@Panel_ID", PanelId.Split('#')[0].ToString()),
                            new MySqlParameter("@Rate", Util.GetDouble(Item[i].Split('|')[2].Trim())),
                            new MySqlParameter("@CreatedByID", UserInfo.ID));

                    }

                }
            }

            //VIVEK SATART



            DataTable dt_LTD_NEW2 = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, " select  *,im.`TestCode`,im.ItemID,cm.Name CategoryName,cm.CategoryID,sc.Name SubCategoryName,sc.SubCategoryId ,im.TypeName,r.Rate,r.mrp_rate ERate,r.ItemCode,r.ItemDisplayName, r.`SpecialFlag` ,IFNULL(im.BaseRate,0)BaseRate from f_itemmaster im inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID and im.IsActive=1  inner join f_categorymaster cm on cm.CategoryID=sc.CategoryID  INNER JOIN f_panel_master pm ON pm.panel_id=@panel_id inner join f_ratelist r on r.ItemID=im.ItemID and r.IsCurrent=1 and r.Panel_ID=pm.panel_id order by cm.Name,sc.Name,im.TypeName",
                 new MySqlParameter("@panel_id", PanelId.Split('#')[0].ToString())).Tables[0];


            for (int j = 0; j < dt_LTD_NEW1.Rows.Count; j++)
            {


                for (int i = 0; i < dt_LTD_NEW1.Columns.Count; i++)
                {
                    string _ColumnName = dt_LTD_NEW1.Columns[i].ColumnName;
                    if ((Util.GetString(dt_LTD_NEW1.Rows[j][i]) != Util.GetString(dt_LTD_NEW2.Rows[j][i])))
                    {

                        string dateTimeFrom =Util.GetDateTime(Util.GetString(dt_LTD_NEW1.Rows[j]["FromDate"])).ToString("yyyy-MM-dd");
                        string dateTimeTo = Util.GetDateTime(Util.GetString(dt_LTD_NEW1.Rows[j]["ToDate"])).ToString("yyyy-MM-dd");
                     

                        sb_1 = new StringBuilder();
                        sb_1.Append("  INSERT INTO f_ratelist_log(Panel_ID,ItemID,ItemName,OldName,NewName,OLDRate_CreatedByID,OLDRate_CreatedBy,OLDRate_dtEntry,NewRate_CreatedByID,NewRate_CreatedBy,NewRate_dtEntry,FromDate,ToDate,TestCode,Remarks,Status) ");
                        sb_1.Append("  values('" + PanelId.Split('#')[0].ToString() + "','" + Util.GetInt(Item[0].Split('|')[0].Trim()) + "','" + Util.GetString(dt_LTD_NEW1.Rows[j]["TypeName"]) + "','" + Util.GetString(dt_LTD_NEW1.Rows[j][i]) + "','" + Util.GetString(dt_LTD_NEW2.Rows[j][i]) + "','','" + Util.GetString(dt_LTD_NEW1.Rows[j]["UpdateBy"]) + "',Now(),'" + UserInfo.ID + "','" + UserInfo.LoginName + "',NOW(),'" + dateTimeFrom + "','" + dateTimeTo + "','" + Util.GetString(dt_LTD_NEW1.Rows[j]["TestCode"]) + "','Change " + dt_LTD_NEW2.Rows[j][i] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_NEW1.Rows[j][i]) + " to " + Util.GetString(dt_LTD_NEW2.Rows[j][i]) + "','ClientItems Update' );  ");
                       
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb_1.ToString());
                    }
                
                }
            
            }

            //VIVEK END


            sb_1 = new StringBuilder();
            sb_1.Append(" SELECT ID,Hospital_ID,RateListID,StockID,Rate , mrp_rate,ERate,IsTaxable,FromDate,ToDate,IsCurrent,ItemID,IsService,Commission,Panel_ID,ItemDisplayName,ItemCode,UpdateBy,UpdateRemarks,ReferedPanel_ID,ReferedSharePer,SpecialFlag,DeletedByID,DeletedBy,DeletedDate,Location,Hospcode   FROM f_ratelist WHERE ItemID ='" + Item[0].Split('|')[0].ToString() + "' and panel_id='" + PanelId.Split('#')[0].ToString() + "'");
            //sb_1.Append(" from f_ratelist_PackageDetails fpm left join f_panel_share_items_category psc on psc.Panel_ID=fpm.Panel_ID where fpm.Panel_ID ='" + panelMasterData[0].Panel_ID + "';");

            DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sb_1.ToString()).Tables[0];

            for (int j = 0; j < dt_LTD_1.Rows.Count; j++)
            {


                for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
                {
                    string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                    if ((Util.GetString(dt_LTD_1.Rows[j][i]) != Util.GetString(dt_LTD_2.Rows[j][i])))
                    {
                        sb_1 = new StringBuilder();
                        sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress) ");
                        sb_1.Append("  values('ClientItems Update','" + Util.GetString(dt_LTD_1.Rows[j][i]) + "','" + Util.GetString(dt_LTD_2.Rows[j][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2.Rows[j][i] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_1.Rows[j][i]) + " to " + Util.GetString(dt_LTD_2.Rows[j][i]) + "','" + StockReports.getip() + "');  ");
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb_1.ToString());
                    }
                }
            }


            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveDoctorwiseItemDiscount(List<string[]> itemdata)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            foreach (string[] mydata in itemdata)
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "delete from referdoctor_discountmaster where Doctor_ID=@Doctor_ID and Item_ID=@Item_ID",
                   new MySqlParameter("@Doctor_ID", mydata[0].ToString()), new MySqlParameter("@Item_ID", mydata[1].ToString()));

                string str = " INSERT INTO referdoctor_discountmaster(Doctor_ID,Subcategory_ID,Item_ID,discountper,Discountamt,type)VALUES( @Doctor_ID,@Subcategory_ID,@Item_ID,@discountper,@Discountamt,'Doctor')";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str,
                   new MySqlParameter("@Doctor_ID", mydata[0].ToString()), new MySqlParameter("@Subcategory_ID", mydata[2].ToString()),
                   new MySqlParameter("@Item_ID", mydata[1].ToString()), new MySqlParameter("@discountper", mydata[3].ToString()), new MySqlParameter("@Discountamt", mydata[4].ToString()));
            }

            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string Save_Role(string RoleID, string ItemData)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            ItemData = ItemData.TrimEnd('#');

            string str = string.Empty;
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            str = " UPDATE f_RoleMaster set MaxDiscount='" + Util.GetInt(Item[0].Split('|')[0].Trim()) + "', EditInfo='" + Util.GetInt(Item[0].Split('|')[1].Trim()) + "', EditPriscription='" + Util.GetInt(Item[0].Split('|')[2].Trim()) + "',Settlement='" + Util.GetInt(Item[0].Split('|')[3].Trim()) + "',DiscAfterBill='" + Util.GetInt(Item[0].Split('|')[4].Trim()) + "',ChangePanel='" + Util.GetInt(Item[0].Split('|')[5].Trim()) + "',ChangePayMode='" + Util.GetInt(Item[0].Split('|')[6].Trim()) + "',ReceiptCancel='" + Util.GetInt(Item[0].Split('|')[7].Trim()) + "',LabRefund='" + Util.GetInt(Item[0].Split('|')[8].Trim()) + "'    where id='" + RoleID + "'";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            Tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetPanelwise_Items(string PanelId, string CategoryId, string SubCategoryId)
    {
        StringBuilder sb = new StringBuilder();

        if (CategoryId == "LSHHI3")
        {
            sb.Append("  SELECT  im.ItemID,cm.Name CategoryName,cm.CategoryID,sc.Name SubCategoryName,sc.SubCategoryId ,im.TypeName,IFNULL(r.Rate,'0')Rate, ");
            sb.Append("  r.ItemCode,r.ItemDisplayName, ");
            sb.Append("   inv.ReportType,inv.ColorCode,TRIM(BOTH ',' FROM GROUP_CONCAT(DISTINCT li.SampleTypeName))SampleTypeName,TRIM(BOTH ',' FROM GROUP_CONCAT(DISTINCT li.MethodName))MethodName, ");
            sb.Append("     GROUP_CONCAT(IF(li.Child_Flag='1',CONCAT('<b>',lm.Name,'</b>'),if(ifnull(li.MethodName,'')<>'',CONCAT(lm.Name,' ,by ',li.MethodName),lm.Name) ) ORDER BY li.printOrder SEPARATOR '<br/>' )Data ");
            sb.Append("   FROM f_itemmaster im  ");
            sb.Append("   INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
            if (SubCategoryId != "All")
            {
                sb.Append(" and sc.SubCategoryID='" + SubCategoryId + "'  ");
            }
            sb.Append("   AND im.IsActive=1  ");
            sb.Append("  INNER JOIN f_categorymaster cm ON cm.CategoryID=sc.CategoryID ");
            sb.Append("  INNER JOIN f_panel_master pm ON pm.panel_id='" + PanelId + "' ");
            sb.Append("  LEFT OUTER JOIN f_ratelist r ON r.ItemID=im.ItemID ");
            sb.Append("  AND r.IsCurrent=1 AND r.Panel_ID=pm.panel_id ");
            sb.Append("  INNER JOIN  investigation_master inv ON inv. investigation_id=im.Type_id  ");
            sb.Append("  LEFT JOIN labobservation_investigation li ON li.Investigation_Id=inv.Investigation_Id ");
            sb.Append("  LEFT JOIN labobservation_master lm ON lm.LabObservation_ID=li.labObservation_ID ");
            sb.Append("  GROUP BY im.ItemID ORDER BY li.printOrder ");
        }
        else
        {
            sb.Append(" select  im.ItemID,cm.Name CategoryName,cm.CategoryID,sc.Name SubCategoryName,sc.SubCategoryId ,im.TypeName,ifnull(r.Rate,'0')Rate,r.ItemCode,r.ItemDisplayName ");
            sb.Append(" ,( SELECT concat(GROUP_CONCAT(inv.Name SEPARATOR '<br/>'),'<br/><b>Total No. of Investigations ',(COUNT(*)),'</b>') FROM package_labdetail pld  INNER JOIN investigation_master inv ON pld.InvestigationID=inv.Investigation_ID  WHERE pld.PlabID=im.Type_ID GROUP BY pld.PlabID )Data ");
            sb.Append(" from f_itemmaster im inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID ");
            sb.Append(" and im.IsActive=1 and sc.CategoryID='" + CategoryId + "' ");
            if (SubCategoryId != "All")
            {
                sb.Append(" and sc.SubCategoryID='" + SubCategoryId + "'  ");
            }
            sb.Append(" inner join f_categorymaster cm on cm.CategoryID=sc.CategoryID ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.panel_id='" + PanelId + "' ");
            sb.Append(" left outer join f_ratelist r on r.ItemID=im.ItemID ");
            sb.Append(" and r.IsCurrent=1 and r.Panel_ID=pm.panel_id order by cm.Name,sc.Name,im.TypeName ");
        }

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return dt;
    }

    public string savepanelwiseitemlock(string PanelId, string ItemData, string SubCategoryId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (SubCategoryId == "All")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_item_lock WHERE   Panel_ID =@Panel_ID",
                   new MySqlParameter("@Panel_ID", PanelId.Split('#')[0].ToString()));
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_item_lock WHERE SubCategoryId =@SubCategoryId AND Panel_ID =@Panel_ID",
                    new MySqlParameter("@Panel_ID", PanelId.Split('#')[0].ToString()), new MySqlParameter("@SubCategoryId", SubCategoryId.Split('#')[0].ToString()));
            }
            string str = string.Empty;
            ItemData = ItemData.TrimEnd('#');
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            string UserID = HttpContext.Current.Session["ID"].ToString();
            if (ItemData != string.Empty)
            {
                for (int i = 0; i < len; i++)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into f_item_lock(ItemID,Panel_ID ,SubCategoryId,UserID) values(@ItemID,@Panel_ID,@SubCategoryId,@UserID) ",
                        new MySqlParameter("@ItemID", Item[i].Split('-')[1].ToString()),
                        new MySqlParameter("@Panel_ID", PanelId.Split('#')[0].ToString()), new MySqlParameter("@SubCategoryId", Item[i].Split('-')[0].ToString()),
                        new MySqlParameter("@UserID", UserID));
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
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetPanelwise_Itemlock(string PanelId, string CategoryId, string SubCategoryId)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT im.ItemID,cm.Name CategoryName,cm.CategoryID, sc.Name  SubCategoryName,sc.SubCategoryId,im.TypeName,IFNULL(r.Rate,'0')Rate,r.ItemCode,");
        sb.Append(" r.ItemDisplayName,IF(IFNULL(li.ID,'')='','false','checked')chk FROM f_itemmaster im INNER JOIN f_subcategorymaster sc");
        sb.Append(" ON sc.SubCategoryID = im.SubCategoryID AND im.IsActive = 1 AND sc.CategoryID = '" + CategoryId + "'   ");
        if (SubCategoryId != "All")
        {
            sb.Append(" and sc.SubCategoryID='" + SubCategoryId + "'  ");
        }
        sb.Append(" INNER JOIN f_categorymaster cm ON cm.CategoryID = sc.CategoryID INNER JOIN f_panel_master pm ON pm.panel_id = '" + PanelId + "'  ");
        sb.Append(" LEFT OUTER JOIN f_ratelist r ON r.ItemID = im.ItemID AND r.IsCurrent = 1 AND r.Panel_ID = pm.panel_id ");
        sb.Append(" LEFT OUTER JOIN f_item_lock li ON im.ItemID = li.ItemID AND li.Panel_ID= '" + PanelId + "' ORDER BY cm.Name,sc.Name,im.TypeName");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public DataTable GetDoctor_Master()
    {
        string sql = "SELECT Doctor_ID,CONCAT(NAME,'#',ifnull(AreaName,''))NAME FROM doctor_referal WHERE IsActive = 1 AND TRIM(NAME)<>'' ORDER BY NAME ";
        return StockReports.GetDataTable(sql);
    }

    public DataTable GetPanelMaster_All()
    {
        return StockReports.GetDataTable(" SELECT Company_Name, Panel_ID FROM f_panel_master  order by Company_Name  ");
    }

    public DataTable GetCPTCode_All()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(cm.CPTCode='','',CONCAT(cm.CPTCode,' # ',IFNULL(otm.Name,' ALL ')))CPTCodeText,cm.CPTCode FROM CPTCode_Master cm ");
        sb.Append(" LEFT OUTER JOIN observationtype_master otm ON cm.SubCategoryID =  otm.Description ");
        sb.Append(" WHERE cm.isActive=1 ORDER BY CPTCode ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public DataTable GetPanelMaster_CurrentCentre()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT concat(pn.Company_Name,'#',ifnull(ADD2,''))Company_Name,pn.Panel_ID  FROM Centre_Panel cp ");
        sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId='" + UserInfo.Centre + "' cp.isActive=1 order by pn.Company_Name ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public DataTable get_Investigation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT im.name,im.Investigation_ID FROM investigation_master im   ");
        sb.Append("   INNER JOIN investigation_observationtype io ON im.Investigation_Id=io.Investigation_ID   ");
        sb.Append("   ORDER BY im.Name     ");

        return StockReports.GetDataTable(sb.ToString());
    }

    public DataTable get_Package()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT im.ItemID Investigation_ID,im.TypeName name   ");
        sb.Append("  FROM f_itemmaster im    INNER JOIN f_subcategorymaster scm   ");
        sb.Append("  ON scm.SubCategoryID=im.SubCategoryID AND im.IsActive=1     ");
        sb.Append("  INNER JOIN f_configrelation cr ON cr.CategoryID=scm.CategoryID       ");
        sb.Append("  INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID     ");
        sb.Append("  INNER JOIN investigation_master inv  ON inv.Investigation_Id=pld.InvestigationID     ");
        sb.Append("  AND cr.ConfigRelationID=23 GROUP BY im.ItemID  ");
        return StockReports.GetDataTable(sb.ToString());
    }

    public string SaveCenterHoliday(string CentreID, string Holiday, int IsActive)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string strcmp = " SELECT Holiday FROM centre_holiday WHERE CentreID='" + CentreID + "' and Holiday='" + Util.GetDateTime(Holiday).ToString("yyyy-MM-dd") + "'  ";
            string strDate = Util.GetString(StockReports.ExecuteScalar(strcmp));
            if (strDate != string.Empty)
            {
                return "Date is already exist";
            }
            else
            {
                string strcmd = " INSERT INTO  centre_holiday(CentreID,Holiday,IsActive,Created_By) VALUES ('" + CentreID + "','" + Util.GetDateTime(Holiday).ToString("yyyy-MM-dd") + "','" + Util.GetInt(IsActive) + "','" + HttpContext.Current.Session["UserName"] + "')";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strcmd);

                Tnx.Commit();
                return "1";
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable GetCentreHoliday(string CentreID)
    {
        DataTable dt = new DataTable();
        string strcmd = "  SELECT  CM.Centre,  DATE_FORMAT(CH.Holiday,'%d-%b-%y')Holiday,if(CH.IsActive=1,'Yes','No')IsActive,ID FROM  centre_holiday CH INNER JOIN centre_master CM ON CM.CentreID=CH.CentreID  WHERE CH.CentreID='" + CentreID + "' order by CH.Holiday ";
        dt = StockReports.GetDataTable(strcmd.ToString());
        return dt;
    }

    public string GetDateUpdated(string CentreID, string Holiday, int IsActive, string HolidayID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE centre_holiday SET Holiday='" + Util.GetDateTime(Holiday).ToString("yyyy-MM-dd") + "',");
            sb.Append("  IsActive='" + Util.GetInt(IsActive) + "',Updated_By='" + HttpContext.Current.Session["UserName"] + "',");
            sb.Append(" Updated_Date='" + System.DateTime.Now.ToString("yyyy-MM-dd") + "' ");
            sb.Append(" where ID='" + Util.GetInt(HolidayID) + "' ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString());
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tnx.Rollback();
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public string SaveInvDeliveryDays(string CentreId, string CategoryId, string SubCategoryId, string ItemData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // Itemdata= 0)SubCategoryID|1)InvID|2)DayType|3)Days|4)sun|5)Monn|6)Tue|7)Wed|8)Thu|9)Fri|10)sat#
            ItemData = ItemData.TrimEnd('#');

            string str = string.Empty;
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            for (int i = 0; i < len; i++)
            {
                SubCategoryId = Util.GetString(Item[i].Split('|')[0]).Split('#')[0];
                str = "Delete from investiagtion_delivery where CentreID='" + CentreId + "'  and Investigation_ID='" + Util.GetString(Item[i].Split('|')[1]) + "'";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

                string strins = " Insert into investiagtion_delivery (`CentreID`,`SubcategoryID`, `Investigation_ID`,`DayType`, `Days`,`Sun`,`Mon`,`Tue`,`Wed`,`Thu`,`Fri`,`Sat`,`CutOffTime`) " +
                      " values ('" + CentreId + "','" + SubCategoryId + "','" + Util.GetString(Item[i].Split('|')[1]) + "','" + Util.GetString(Item[i].Split('|')[2]) + "','" + Util.GetInt(Item[i].Split('|')[11]) + "', " +
                      " '" + Util.GetInt(Item[i].Split('|')[4]) + "','" + Util.GetInt(Item[i].Split('|')[5]) + "','" + Util.GetInt(Item[i].Split('|')[6]) + "','" + Util.GetInt(Item[i].Split('|')[7]) + "' ," +
                      " '" + Util.GetInt(Item[i].Split('|')[8]) + "','" + Util.GetInt(Item[i].Split('|')[9]) + "','" + Util.GetInt(Item[i].Split('|')[10]) + "','" + Util.GetDateTime(Item[i].Split('|')[12]).ToString("HH:mm:ss") + "')";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strins);
            }

            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tnx.Rollback();
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public DataTable Get_DeliveryDays(string CentreId, string CategoryId, string SubCategoryId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sc.`SubCategoryID`,sc.`Name` AS DeptName,im.`Type_ID`,im.`TypeName` AS InvName,ifnull(id.DayType,'DAY')DayType,ifnull(id.Days,0)Days, ");
        sb.Append(" ifnull(id.Sun,0)Sun,ifnull(id.Mon,0)Mon,ifnull(id.Tue,0)Tue,ifnull(id.Wed,0)Wed,ifnull(id.Thu,0)Thu,ifnull(id.Fri,0)Fri,ifnull(id.Sat,0)Sat,ifnull(id.CutOffTime,'14:00 PM')CutOffTime ");
        sb.Append(" FROM `f_itemmaster` im ");
        sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
        if (SubCategoryId.ToUpper() != "ALL")
            sb.Append(" AND sc.`SubcategoryID`='" + SubCategoryId + "' ");
        sb.Append(" AND sc.`CategoryID`='" + CategoryId + "' ");
        sb.Append(" LEFT JOIN ");
        sb.Append(" (SELECT * FROM `investiagtion_delivery` WHERE  `CentreID`='" + CentreId + "' ");
        if (SubCategoryId.ToUpper() != "ALL")
            sb.Append(" AND `SubCategoryID`='" + SubCategoryId + "' ");
        sb.Append(" ) id ");
        sb.Append(" ON id.Investigation_id=im.`Type_ID` AND id.SubCategoryID=im.`SubCategoryID` where im.isActive=1 ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return dt;
    }

    public DataTable GetItemWisePanelRate(string ItemID)
    {
        StringBuilder sb = new StringBuilder();
        
        sb.Append(" SELECT pnl.Panel_ID,'" + ItemID + "' ItemID,Company_Name AS PanelName,rt.`SpecialFlag`,IFNULL(rt.Rate,0) Rate,IFNULL(rt.mrp_rate,0) erate, IFNULL(rt.ItemDisplayname,'') ItemDisplayname,IFNULL(rt.ItemCode,'') ItemCode  FROM ");
        sb.Append(" (SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,Panel_ID,ReferenceCode, ");
        sb.Append(" ReferenceCodeOPD FROM f_panel_master WHERE Panel_ID = ReferenceCodeOPD  ) pnl ");
        sb.Append(" LEFT JOIN (SELECT Panel_ID,Rate,mrp_rate,ItemDisplayname,SpecialFlag,ItemCode FROM f_ratelist WHERE ItemID ='" + ItemID + "')rt ON pnl.panel_ID = rt.Panel_ID ORDER BY Company_Name; ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    public DataTable GetDepartmentWiseItem(string SubCategoryID, string billcategory)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (billcategory == "0")
            {
                if (SubCategoryID.Trim() != "All")
                    sb.Append(" SELECT ItemID,CONCAT(TestCode,' ~ ',TypeName)TypeName FROM f_itemmaster WHERE SubcategoryID=@SubcategoryID AND IsActive=1 AND ShowInRateList=1 ORDER BY TypeName; ");
                else
                    sb.Append(" SELECT ItemID,CONCAT(TestCode,' ~ ',TypeName)TypeName FROM f_itemmaster where ShowInRateList=1 ORDER BY TypeName; ");
            }
            else
            {
                sb.Append(" SELECT ItemID,CONCAT(TestCode,' ~ ',TypeName)TypeName FROM f_itemmaster WHERE Bill_Category=@Bill_Category AND ShowInRateList=1 ORDER BY TypeName; ");
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@SubcategoryID", SubCategoryID),
                new MySqlParameter("@Bill_Category", billcategory)).Tables[0])

                return dt;
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public string SaveItemWisePanelRate(string ItemID, string ItemData, int TaggedPUP)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // Itemdata= Itemid|ItemName|Rate|DisplayName|Itemcode#
            ItemData = ItemData.TrimEnd('#');

            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');

            for (int i = 0; i < len; i++)
            {


                StringBuilder sb_1 = new StringBuilder();
                sb_1.Append(" SELECT rl.Panel_ID,rl.Rate,rl.ItemID,rl.UpdateBy,Date_format(rl.UpdateDate,'%Y/%m/%d %H:%i:%s')UpdateDate,im.TypeName,fpm.Company_Name");

                //sb_1.Append(" SELECT rl.Panel_ID,rl.Rate,rl.ItemID,rl.UpdateBy,rl.UpdateDate,im.TypeName,fpm.Company_Name");
                sb_1.Append(" FROM f_ratelist rl ");
                sb_1.Append(" INNER JOIN f_itemmaster im ON im.ItemID=rl.ItemID ");
                sb_1.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=rl.Panel_ID ");
                sb_1.Append(" WHERE rl.ItemID ='" + Util.GetString(ItemID.Split('#')[0].Trim()) + "' AND rl.Panel_ID='" + Util.GetString(Item[i].Split('|')[0].Trim()) + "'");
                DataTable dt_LTD_1 = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sb_1.ToString()).Tables[0];


                if (TaggedPUP == 1)
                {
                   using(DataTable dtPaneType = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, "SELECT PanelType FROM f_panel_master WHERE panel_id=@panel_id",
                        new MySqlParameter("@panel_id", Util.GetString(Item[i].Split('|')[0].Trim()))).Tables[0])
                    if (dtPaneType.Rows.Count > 0 && Util.GetString(dtPaneType.Rows[0]["PanelType"]) == "PUP")
                    {
                        continue;
                    }
                }

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE ItemID =@ItemID AND  Panel_ID=@Panel_ID ",
               new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
               new MySqlParameter("@ItemID", Util.GetString(ItemID.Split('#')[0].Trim())),
               new MySqlParameter("@Panel_ID", Util.GetString(Item[i].Split('|')[0].Trim())));

                string str = string.Empty;
                str = "DELETE FROM f_ratelist WHERE ItemID =@ItemID and  panel_id=@panel_id";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str,
                    new MySqlParameter("@ItemID", Util.GetString(ItemID.Split('#')[0].Trim())),
                    new MySqlParameter("@panel_id", Util.GetString(Item[i].Split('|')[0].Trim())));

                RateList objRateList = new RateList(Tnx);
                objRateList.Panel_ID = Util.GetInt(Item[i].Split('|')[0].Trim());
                objRateList.ItemID = Util.GetInt(ItemID.Split('#')[0].Trim());
                objRateList.Rate = Util.GetDecimal(Item[i].Split('|')[1].Trim());
                objRateList.ERate = 0;
                objRateList.IsTaxable = 0;
                objRateList.FromDate = DateTime.Now;
                objRateList.ToDate = DateTime.Now;
                objRateList.IsCurrent = 1;
                objRateList.IsService = "YES";
                objRateList.ItemDisplayName = Util.GetString(Item[i].Split('|')[2].Trim());
                objRateList.ItemCode = Util.GetString(Item[i].Split('|')[4].Trim());
                objRateList.MrpRate = Util.GetDecimal(Item[i].Split('|')[5].Trim());
                objRateList.UpdateBy = HttpContext.Current.Session["LoginName"].ToString();
                objRateList.UpdateRemarks = "ItemWisePanelRate";
                objRateList.UpdateDate = System.DateTime.Now;
                objRateList.Insert();



                StringBuilder sb_2 = new StringBuilder();
                sb_2.Append(" SELECT rl.Panel_ID,rl.Rate,rl.ItemID,im.TypeName,fpm.Company_Name");
                sb_2.Append(" FROM f_ratelist rl ");
                sb_2.Append(" INNER JOIN f_itemmaster im ON im.ItemID=rl.ItemID ");
                sb_2.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=rl.Panel_ID ");
                sb_2.Append(" WHERE rl.ItemID ='" + Util.GetString(ItemID.Split('#')[0].Trim()) + "' AND rl.Panel_ID='" + Util.GetString(Item[i].Split('|')[0].Trim()) + "'");
                DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sb_2.ToString()).Tables[0];

                if (dt_LTD_2.Rows.Count > 0 && dt_LTD_1.Rows.Count > 0)
                {
                    if ((Util.GetString(dt_LTD_1.Rows[0]["Rate"]) != Util.GetString(dt_LTD_2.Rows[0]["Rate"])))
                    {



                        sb_1 = new StringBuilder();
                        sb_1.Append("  INSERT INTO f_ratelist_log(Panel_ID,ItemID,Company_Name,ItemName,OLDRate,NewRate,OLDRate_CreatedByID,OLDRate_CreatedBy,OLDRate_dtEntry,NewRate_CreatedByID,NewRate_CreatedBy,NewRate_dtEntry,Status) ");
                        sb_1.Append("  values('" + Util.GetString(Item[i].Split('|')[0].Trim()) + "','" + Util.GetString(ItemID.Split('#')[0].Trim()) + "','" + Util.GetString(dt_LTD_1.Rows[0]["Company_Name"]) + "','" + Util.GetString(dt_LTD_1.Rows[0]["TypeName"]) + "','" + Util.GetString(dt_LTD_1.Rows[0]["Rate"]) + "','" + Util.GetString(dt_LTD_2.Rows[0]["Rate"]) + "','','" + Util.GetString(dt_LTD_1.Rows[0]["UpdateBy"]) + "','" + dt_LTD_1.Rows[i]["UpdateDate"] + "','" + UserInfo.ID + "','" + UserInfo.LoginName + "',NOW(),'ItemsWiserate Update');  ");
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb_1.ToString());

                    }
                }
                // For Tagged PUP
                // To Check Panel Centre Type
                if (TaggedPUP == 1)
                {
                    StringBuilder sbPanelCentre = new StringBuilder();
                    sbPanelCentre.Append(" SELECT CentreID FROM f_panel_master where  ");
                    sbPanelCentre.Append(" `Panel_ID`=" + Util.GetString(Item[i].Split('|')[0].Trim()) + " AND `IsActive`=1 ");

                    DataTable dtPanelCentre = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, sbPanelCentre.ToString()).Tables[0];
                    if (dtPanelCentre.Rows.Count > 0 && Util.GetString(dtPanelCentre.Rows[0]["CentreID"]) != "0")
                    {
                        DataTable dtPUP = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, " SELECT `Panel_ID`,`Company_Name`,`ReferenceCode`,`DiscPercent` FROM f_panel_master WHERE `TagProcessingLabID`=@TagProcessingLabID AND paneltype='PUP' AND IsActive=1 ",
                            new MySqlParameter("@TagProcessingLabID", Util.GetString(dtPanelCentre.Rows[0]["CentreID"]))).Tables[0];
                        foreach (DataRow drPUP in dtPUP.Rows)
                        {
                            int IsSpecialFlag = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, " Select count(*) from f_ratelist where panel_id=@panel_id and Itemid=@Itemid and SpecialFlag=1 ",
                                new MySqlParameter("@panel_id", Util.GetString(drPUP["ReferenceCode"])),
                                new MySqlParameter("@Itemid", Util.GetString(ItemID.Split('#')[0].Trim()))));
                            if (IsSpecialFlag == 0)
                            {

                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE ItemID =@ItemID AND  Panel_ID=@Panel_ID AND SpecialFlag=0",
          new MySqlParameter("@DeletedByID", UserInfo.ID), new MySqlParameter("@DeletedBy", UserInfo.LoginName),
          new MySqlParameter("@ItemID", Util.GetString(ItemID.Split('#')[0].Trim())),
          new MySqlParameter("@Panel_ID", Util.GetString(drPUP["ReferenceCode"])));

                                string strPUP = string.Empty;
                                strPUP = "DELETE FROM f_ratelist WHERE ItemID =@ItemID and  panel_id=@panel_id and SpecialFlag=0 ";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, strPUP,
                                    new MySqlParameter("@ItemID", Util.GetString(ItemID.Split('#')[0].Trim())),
                                    new MySqlParameter("@panel_id", Util.GetString(drPUP["ReferenceCode"])));
                                double PUPItemRate = (Util.GetInt(drPUP["DiscPercent"]) == 0) ? Util.GetDouble(Item[i].Split('|')[1].Trim()) : (Util.GetDouble(Item[i].Split('|')[1].Trim()) * (100 - Util.GetInt(drPUP["DiscPercent"])) * 0.01);

                                RateList objRateListPUP = new RateList(Tnx);
                                objRateListPUP.Panel_ID = Util.GetInt(drPUP["ReferenceCode"]);
                                objRateListPUP.ItemID = Util.GetInt(ItemID.Split('#')[0].Trim());
                                objRateListPUP.Rate = Util.GetDecimal(Math.Round(PUPItemRate));
                                objRateListPUP.ERate = Util.GetDecimal(Item[i].Split('|')[1].Trim());
                                objRateListPUP.IsTaxable = 0;
                                objRateListPUP.FromDate = DateTime.Now;
                                objRateListPUP.ToDate = DateTime.Now;
                                objRateListPUP.IsCurrent = 1;
                                objRateListPUP.IsService = "YES";
                                objRateListPUP.ItemDisplayName = Util.GetString(Item[i].Split('|')[2].Trim());
                                objRateListPUP.ItemCode = Util.GetString(Item[i].Split('|')[4].Trim());
                                objRateListPUP.MrpRate = Util.GetDecimal(Item[i].Split('|')[5].Trim());
                                objRateListPUP.UpdateBy = HttpContext.Current.Session["LoginName"].ToString();
                                objRateListPUP.UpdateRemarks = "ItemWisePanelRate_TaggedPUP";
                                objRateListPUP.UpdateDate = System.DateTime.Now;
                                objRateListPUP.Insert();
                            }
                        }
                    }
                }

                string SubCategoryID = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SubCategoryID FROM f_itemmaster WHERE ItemID=@ItemID",
                  new MySqlParameter("@ItemID", Util.GetString(ItemID.Split('#')[0].Trim()))).ToString();
                if (SubCategoryID == "15")
                {


                    int IsBaserate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_ratelist_PackageDetails WHERE PackageItemID=@PackageItemID AND PanelID=@Panel_ID  AND IsBaseRate=1 ",
                        new MySqlParameter("@PackageItemID", Util.GetString(ItemID.Split('#')[0].Trim())),
                        new MySqlParameter("@Panel_ID", Util.GetString(Item[i].Split('|')[0].Trim()))));

                    StringBuilder sb = new StringBuilder();

                    if (IsBaserate > 0)
                    {
                        sb.Clear();
                        sb.Append(" UPDATE  ");
                        sb.Append(" `package_labdetail` pld ");
                        sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
                        sb.Append(" INNER JOIN f_itemmaster im  ON im.`Type_ID`=inv.`Investigation_Id` ");
                        sb.Append(" INNER JOIN f_ratelist_PackageDetails frp  ON frp.PackageItemID=pld.PlabID AND frp.TestItemID=im.ItemID AND IsBaseRate=1 ");
                        sb.Append(" AND pld.`PlabID`=@PackageItemID  AND frp.PanelID=@Panel_ID  ");
                        sb.Append(" SET PackageRate=@PackageRate,TestRate=ROUND(@PackageRate * frp.TestPer * 0.01,2) ");


                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PackageItemID", Util.GetString(ItemID.Split('#')[0].Trim())),
                            new MySqlParameter("@PackageRate", Util.GetDouble(Item[i].Split('|')[1].Trim())),
                            new MySqlParameter("@Panel_ID", Util.GetString(Item[i].Split('|')[0].Trim())));

                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM f_ratelist_PackageDetails WHERE PackageItemID=@PackageItemID AND PanelID=@Panel_ID AND IsBaseRate=0",
                            new MySqlParameter("@PackageItemID", Util.GetString(ItemID.Split('#')[0].Trim())),
                            new MySqlParameter("@Panel_ID", Util.GetString(Item[i].Split('|')[0].Trim())));


                        sb.Clear();

                        sb.Append(" INSERT INTO f_ratelist_PackageDetails(PackageItemID,PackageRate,PanelId,TestItemId,TestRate,TestPer,CreatedByID,IsBaseRate) ");
                        sb.Append(" SELECT @PackageItemID,@Rate,@Panel_ID,im.ItemID TestItemId,ROUND(@Rate * frp.TestPer * 0.01,2),frp.TestPer,@CreatedByID,0 IsBaseRate ");
                        sb.Append(" FROM `package_labdetail` pld  ");
                        sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
                        sb.Append(" INNER JOIN f_itemmaster im  ON im.`Type_ID`=inv.`Investigation_Id` ");
                        sb.Append(" INNER JOIN f_ratelist_PackageDetails frp  ON frp.PackageItemID=pld.PlabID AND frp.TestItemID=im.ItemID AND IsBaseRate=1 ");
                        sb.Append(" AND pld.`PlabID`=@PackageItemID    ");


                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PackageItemID", Util.GetString(ItemID.Split('#')[0].Trim())),
                            new MySqlParameter("@Panel_ID", Util.GetString(Item[i].Split('|')[0].Trim())),
                            new MySqlParameter("@Rate", Util.GetDouble(Item[i].Split('|')[1].Trim())),
                            new MySqlParameter("@CreatedByID", UserInfo.ID));
                    }
                }


            }
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}