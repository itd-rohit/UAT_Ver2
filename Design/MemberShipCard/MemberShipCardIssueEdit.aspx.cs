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

public partial class Design_MemberShipCard_MemberShipCardIssueEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.GetString(Request.QueryString["CardNo"]) != "")
        {
            txtCardNo.Text = Common.Decrypt(Util.GetString(Request.QueryString["CardNo"]));
            txtCardNo.Enabled = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "search();", true);
        }
        else
        {
            txtCardNo.Enabled = true;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindMembershipCard(string CardNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT pm.familymemberrelation, pm.patient_id,pm.title,pm.pname,pm.house_no,pm.mobile,pm.email,pm.ageyear,pm.agemonth,pm.agedays,pm.gender,");
            sb.Append(" DATE_FORMAT(pm.dob,'%d-%b-%Y') dob,pm.age,DATE_FORMAT(pm.dtEntry,'%d-%b-%Y %h:%I %p') visitdate,");
            sb.Append(" pm.FamilyMemberGroupID,pm.FamilyMemberIsPrimary,pm.MembershipCardNo,pm.MembershipCardID,me.CardType SavingCardType,pm.CentreID,");
            sb.Append(" me.MembershipCardName MembershipCardName,me.Amount MembershipCardAmount,me.CardDependent MembershipCardDependent,DATE_FORMAT(me.ValidTo,'%d-%b-%Y')ValidTo,IF(me.CardType=1,'Manual','PrePrinted')CardType ");
            sb.Append(" FROM patient_master pm INNER JOIN membershipcard me ON pm.MembershipCardNo=me.CardNo WHERE pm.MembershipCardNo=@MembershipCardNo AND pm.`FamilyMemberGroupID`!=0  order by pm.FamilyMemberIsPrimary desc ");


            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@MembershipCardNo", CardNo)).Tables[0])
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "Record not found on this Card" });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, response = ex.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string RemoveMember(string familyGroupID, string UHID, int IsPrimaryMember, string MembershipCardNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            int chkPreviousBooking = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM f_ledgertransaction WHERE Patient_ID=@Patient_ID AND MembershipCardNo=@MembershipCardNo ",
               new MySqlParameter("@Patient_ID", UHID),
               new MySqlParameter("@MembershipCardNo", MembershipCardNo)));
            if (chkPreviousBooking > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "You cannot remove because allready booking done" });
            }
            if (IsPrimaryMember == 0)
            {
                sb = new StringBuilder();
                sb.Append(" UPDATE patient_master SET FamilyMemberGroupID=0,FamilyMemberRelation='' ,FamilyMemberIsPrimary=0,MembershipCardNo='',MembershipCardValidTo='0001-01-01' ");
                sb.Append(" WHERE FamilyMemberGroupID=@FamilyMemberGroupID AND Patient_ID=@Patient_ID AND FamilyMemberIsPrimary=0 AND MembershipCardNo=@MembershipCardNo ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@FamilyMemberGroupID", familyGroupID), new MySqlParameter("@Patient_ID", UHID),
                    new MySqlParameter("@MembershipCardNo", MembershipCardNo));

                sb = new StringBuilder();
                sb.Append(" DELETE FROM membershipcard_member WHERE FamilyMemberGroupID=@FamilyMemberGroupID AND Patient_ID=@Patient_ID AND MembershipCardNo=@MembershipCardNo");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@FamilyMemberGroupID", familyGroupID), new MySqlParameter("@Patient_ID", UHID),
                   new MySqlParameter("@MembershipCardNo", MembershipCardNo));


                sb = new StringBuilder();
                sb.Append(" INSERT INTO membershipcard_detail_bkp(bkp_ID,Patient_ID,MembershipCardID,MembershipCardNo,FamilyMemberIsPrimary,ItemID,");
                sb.Append(" SelfDisc,DependentDisc,SelfFreeTest,SelfFreeTestCount,DependentFreeTest,DependentFreeTestCount,SelfFreeTestConsume,DependentFreeTestConsume,");
                sb.Append(" CardValid,IsActive,CreatedDate,FamilyMemberGroupID,CardType,UpdatedByID,UpdatedBy,UpdatedDate,SubCategoryID) ");
                sb.Append(" SELECT ID,Patient_ID,MembershipCardID,MembershipCardNo,FamilyMemberIsPrimary,ItemID,");
                sb.Append(" SelfDisc,DependentDisc,SelfFreeTest,SelfFreeTestCount,DependentFreeTest,DependentFreeTestCount,SelfFreeTestConsume,DependentFreeTestConsume, ");
                sb.Append(" CardValid,IsActive,CreatedDate,FamilyMemberGroupID,CardType,@UpdatedByID,@UpdatedBy,NOW(),SubCategoryID ");
                sb.Append(" FROM membershipcard_Detail WHERE FamilyMemberGroupID=@FamilyMemberGroupID AND Patient_ID=@Patient_ID AND MembershipCardNo=@MembershipCardNo");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@FamilyMemberGroupID", familyGroupID), new MySqlParameter("@Patient_ID", UHID),
                   new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                   new MySqlParameter("@MembershipCardNo", MembershipCardNo));


                sb = new StringBuilder();
                sb.Append(" DELETE FROM membershipcard_Detail WHERE FamilyMemberGroupID=@FamilyMemberGroupID AND Patient_ID=@Patient_ID AND MembershipCardNo=@MembershipCardNo");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@FamilyMemberGroupID", familyGroupID), new MySqlParameter("@Patient_ID", UHID),
                   new MySqlParameter("@MembershipCardNo", MembershipCardNo));

            }

            else
            {
                sb = new StringBuilder();
                sb.Append(" UPDATE patient_master SET FamilyMemberGroupID=0,FamilyMemberRelation='' ,FamilyMemberIsPrimary=0,MembershipCardNo='',MembershipCardValidTo='0001-01-01' ");
                sb.Append(" WHERE FamilyMemberGroupID=@FamilyMemberGroupID  AND MembershipCardNo=@MembershipCardNo  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@FamilyMemberGroupID", familyGroupID),
                    new MySqlParameter("@MembershipCardNo", MembershipCardNo));


                sb = new StringBuilder();
                sb.Append(" INSERT INTO membershipcard_detail_bkp(bkp_ID,Patient_ID,MembershipCardID,MembershipCardNo,FamilyMemberIsPrimary,ItemID,");
                sb.Append(" SelfDisc,DependentDisc,SelfFreeTest,SelfFreeTestCount,DependentFreeTest,DependentFreeTestCount,SelfFreeTestConsume,DependentFreeTestConsume,");
                sb.Append(" CardValid,IsActive,CreatedDate,FamilyMemberGroupID,CardType,UpdatedByID,UpdatedBy,UpdatedDate,SubCategoryID) ");
                sb.Append(" SELECT ID,Patient_ID,MembershipCardID,MembershipCardNo,FamilyMemberIsPrimary,ItemID,");
                sb.Append(" SelfDisc,DependentDisc,SelfFreeTest,SelfFreeTestCount,DependentFreeTest,DependentFreeTestCount,SelfFreeTestConsume,DependentFreeTestConsume, ");
                sb.Append(" CardValid,IsActive,CreatedDate,FamilyMemberGroupID,CardType,@UpdatedByID,@UpdatedBy,NOW(),SubCategoryID ");
                sb.Append(" FROM membershipcard_Detail WHERE FamilyMemberGroupID=@FamilyMemberGroupID AND Patient_ID=@Patient_ID AND MembershipCardNo=@MembershipCardNo");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@FamilyMemberGroupID", familyGroupID), new MySqlParameter("@Patient_ID", UHID),
                   new MySqlParameter("@UpdatedByID", UserInfo.ID), new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                   new MySqlParameter("@MembershipCardNo", MembershipCardNo));



                sb = new StringBuilder();
                sb.Append(" DELETE me.*,med.* FROM   membershipcard_member me INNER JOIN membershipcard_Detail med ON me.FamilyMemberGroupID=med.FamilyMemberGroupID WHERE me.FamilyMemberGroupID=@FamilyMemberGroupID AND me.MembershipCardNo=@MembershipCardNo");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@FamilyMemberGroupID", familyGroupID),
                   new MySqlParameter("@MembershipCardNo", MembershipCardNo));



                sb = new StringBuilder();
                sb.Append(" UPDATE membershipcard SET IsActive=0,Updatedate=NOW(),UpdatedByID=@UpdatedByID, UpdatedBy=@UpdatedBy WHERE FamilyMemberGroupID=@FamilyMemberGroupID AND MembershipCardNo=@MembershipCardNo");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@FamilyMemberGroupID", familyGroupID), new MySqlParameter("@UpdatedByID", UserInfo.ID),
                   new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                   new MySqlParameter("@MembershipCardNo", MembershipCardNo));

            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", response = "Member Removed Sucessfully" });

        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public static string savedata(List<Patient_Master> PatientData, int FamilyMemberGroupID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string ConcatPatient_ID = string.Format("{0}", string.Join(",", PatientData.Where(s => s.Patient_ID != string.Empty).Select(a => String.Join(", ", a.Patient_ID))));

            if (ConcatPatient_ID != string.Empty)
            {
                string[] Patient_IDTags = String.Join(",", ConcatPatient_ID).Split(',');
                string[] Patient_IDParamNames = Patient_IDTags.Select((s, i) => "@tag" + i).ToArray();
                string Patient_IDClause = string.Join(", ", Patient_IDParamNames);
                sb.Append("SELECT IFNULL(CAST(GROUP_CONCAT(Patient_ID SEPARATOR '<br/>' ) AS CHAR),'')Patient_ID FROM patient_master WHERE Patient_ID IN({0}) AND MembershipCardID!=0 AND MembershipCardValidTo>CURRENT_DATE ");
                using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), Patient_IDClause), con))
                {
                    for (int i = 0; i < Patient_IDParamNames.Length; i++)
                    {
                        cmd.Parameters.AddWithValue(Patient_IDParamNames[i], Patient_IDTags[i]);
                    }
                    string exitPatientID = Util.GetString(cmd.ExecuteScalar());
                    if (exitPatientID.ToString() != string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("This UHID No. : ", exitPatientID, " , Already Exits in MemberShip") });
                    }
                }
            }
            using (DataTable dtCardDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ValidFrom,ValidTo,CardType,CardNo,CardDependent,MembershipCardID FROM membershipcard WHERE FamilyMemberGroupID=@FamilyMemberGroupID",
                  new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID)).Tables[0])
            {

                int FamilyMemberCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT COUNT(*) FROM membershipcard_member WHERE FamilyMemberGroupID=@FamilyMemberGroupID AND FamilyMemberIsPrimary=0",
                   new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID)));

                FamilyMemberCount = FamilyMemberCount + Util.GetInt(PatientData.Count);
                if (FamilyMemberCount > Util.GetInt(dtCardDetail.Rows[0]["CardDependent"].ToString()))
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Maximun Family Member Exceed" });
                }
                sb = new StringBuilder();
                string PatientID = string.Empty;
                string PrimaryPatientID = string.Empty;
                string Country = string.Empty;
                foreach (Patient_Master pm in PatientData)
                {
                    if (pm.Patient_ID == string.Empty)
                    {
                        if (Country == string.Empty)
                        {
                            Country = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Name FROM `country_master` WHERE CountryID=@CountryID",
                               new MySqlParameter("@CountryID", Resources.Resource.BaseCurrencyID)));
                        }
                        Patient_Master objPM = new Patient_Master(tnx);
                        objPM.Title = pm.Title;
                        objPM.PName = pm.PName.ToUpper();
                        objPM.House_No = pm.House_No;
                        objPM.Street_Name = pm.Street_Name;
                        objPM.Locality = pm.Locality;
                        objPM.City = pm.City;
                        objPM.Pincode = pm.Pincode;
                        objPM.State = pm.State;
                        objPM.Country = pm.Country;
                        objPM.Phone = pm.Phone;
                        objPM.Mobile = pm.Mobile;

                        objPM.DOB = pm.DOB;
                        objPM.Age = pm.Age;
                        objPM.AgeYear = pm.AgeYear;
                        objPM.AgeMonth = pm.AgeMonth;
                        objPM.AgeDays = pm.AgeDays;
                        objPM.TotalAgeInDays = pm.TotalAgeInDays;
                        objPM.Gender = pm.Gender;
                        objPM.CentreID = pm.CentreID;
                        objPM.StateID = pm.StateID;
                        objPM.CityID = pm.CityID;
                        objPM.LocalityID = pm.LocalityID;
                        objPM.IsOnlineFilterData = pm.IsOnlineFilterData;
                        objPM.IsDuplicate = pm.IsDuplicate;
                        objPM.IsDOBActual = pm.IsDOBActual;

                        objPM.Relation = pm.Relation;
                        objPM.FamilyMemberGroupID = FamilyMemberGroupID;
                        objPM.FamilyMemberRelation = pm.FamilyMemberRelation;
                        objPM.FamilyMemberIsPrimary = pm.FamilyMemberIsPrimary;

                        objPM.MembershipCardID = Util.GetInt(dtCardDetail.Rows[0]["MembershipCardID"].ToString());
                        objPM.MembershipCardNo = Util.GetString(dtCardDetail.Rows[0]["CardNo"].ToString());
                        objPM.MembershipCardValidFrom = Util.GetDateTime(dtCardDetail.Rows[0]["ValidFrom"]);
                        objPM.MembershipCardValidTo = Util.GetDateTime(dtCardDetail.Rows[0]["ValidTo"]);
                        objPM.CountryID = Util.GetInt(Resources.Resource.BaseCurrencyID);
                        objPM.Country = Util.GetString(Country);
                        try
                        {
                            string pid = objPM.Insert();
                            if (pm.FamilyMemberIsPrimary == 1)
                            {
                                PrimaryPatientID = pid;
                            }
                            PatientID = pid;
                            pm.Patient_ID = pid;
                        }
                        catch (Exception exPm)
                        {
                            if (exPm.Message.Contains("Duplicate entry") && exPm.Message.Contains("Patient_ID"))
                            {
                                PatientID = objPM.Insert();
                            }
                            else
                            {
                                tnx.Rollback();
                                return JsonConvert.SerializeObject(new { status = false, response = "Patient Master Error" });
                            }
                        }
                    }
                    else
                    {
                        if (pm.FamilyMemberIsPrimary == 1)
                        {
                            PrimaryPatientID = pm.Patient_ID;
                        }

                        PatientID = pm.Patient_ID;
                        sb = new StringBuilder();
                        sb.Append("  UPDATE patient_master ");
                        sb.Append(" SET  ");
                        sb.Append(" Age = @Age,AgeYear = @AgeYear,AgeMonth = @AgeMonth, AgeDays = @AgeDays,TotalAgeInDays = @TotalAgeInDays,");
                        sb.Append(" dob= @dob,UpdateID = @UpdateID,IsDOBActual = @IsDOBActual,UpdateName = @UpdateName,UpdateDate = NOW(),House_no=@House_no ");
                        sb.Append(" FamilyMemberGroupID=@FamilyMemberGroupID,FamilyMemberIsPrimary=@FamilyMemberIsPrimary,FamilyMemberRelation=@FamilyMemberRelation, ");
                        sb.Append(" MembershipCardID=@MembershipCardID,MembershipCardNo=@MembershipCardNo,MembershipCardValidFrom=NOW(),");
                        sb.Append(" MembershipCardValidTo=@MembershipCardValidTo,MembershipCardValidFrom=@MembershipCardValidFrom WHERE Patient_ID = @Patient_ID");


                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@Age", pm.Age), new MySqlParameter("@AgeYear", pm.AgeYear),
                           new MySqlParameter("@AgeMonth", pm.AgeMonth), new MySqlParameter("@AgeDays", pm.AgeDays),
                           new MySqlParameter("@TotalAgeInDays", pm.TotalAgeInDays),
                           new MySqlParameter("@dob", Util.GetDateTime(pm.DOB).ToString("yyyy-MM-dd")),
                           new MySqlParameter("@UpdateID", UserInfo.ID),
                           new MySqlParameter("@IsDOBActual", pm.IsDOBActual),
                           new MySqlParameter("@UpdateName", UserInfo.LoginName),
                           new MySqlParameter("@House_no", pm.House_No),
                           new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID),
                           new MySqlParameter("@FamilyMemberIsPrimary", pm.FamilyMemberIsPrimary),
                           new MySqlParameter("@FamilyMemberRelation", pm.FamilyMemberRelation),
                           new MySqlParameter("@MembershipCardID", Util.GetInt(dtCardDetail.Rows[0]["MembershipCardID"].ToString())),
                           new MySqlParameter("@MembershipCardNo", Util.GetString(dtCardDetail.Rows[0]["CardNo"].ToString())),
                           new MySqlParameter("@MembershipCardValidTo", Util.GetDateTime(dtCardDetail.Rows[0]["ValidTo"])),
                           new MySqlParameter("@MembershipCardValidFrom", Util.GetDateTime(dtCardDetail.Rows[0]["ValidFrom"])),
                           new MySqlParameter("@Patient_ID", pm.Patient_ID));

                    }


                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO membershipcard_member(MembershipCardNo,PName,Patient_ID,Age,Gender,Relation,CreatedByID,Mobile,MembershipCardID,CreatedBy,FamilyMemberIsPrimary,CardValid,FamilyMemberGroupID,CardType) ");
                    sb.Append(" values (@CardNo,@PName,@Patient_ID,@Age,@Gender,@Relation,@CreatedByID,@Mobile,@MembershipCardID,@CreatedBy,@FamilyMemberIsPrimary,@CardValid,@FamilyMemberGroupID,@CardType)");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@CardNo", Util.GetString(dtCardDetail.Rows[0]["CardNo"].ToString())),
                         new MySqlParameter("@MembershipCardID", Util.GetInt(dtCardDetail.Rows[0]["MembershipCardID"].ToString())),
                         new MySqlParameter("@PName", pm.Title + pm.PName.ToUpper()),
                         new MySqlParameter("@Patient_ID", pm.Patient_ID),
                         new MySqlParameter("@Age", pm.Age),
                         new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID),
                         new MySqlParameter("@Gender", pm.Gender),
                         new MySqlParameter("@Relation", pm.FamilyMemberRelation),
                         new MySqlParameter("@CardType", dtCardDetail.Rows[0]["CardType"]),
                         new MySqlParameter("@CreatedByID", UserInfo.ID),
                         new MySqlParameter("@FamilyMemberIsPrimary", pm.FamilyMemberIsPrimary),
                         new MySqlParameter("@Mobile", pm.Mobile),
                         new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                         new MySqlParameter("@CardValid", Util.GetDateTime(dtCardDetail.Rows[0]["ValidTo"])));

                    int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM membershipcard_Detail WHERE FamilyMemberIsPrimary=0 AND FamilyMemberGroupID=@FamilyMemberGroupID",
                        new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID)));
                    if (count > 0)
                    {

                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO membershipcard_Detail(Patient_ID,MembershipCardID,MembershipCardNo,FamilyMemberIsPrimary,ItemID,SelfDisc,DependentDisc,SelfFreeTest,SelfFreeTestCount,DependentFreeTest,DependentFreeTestCount,CardValid,FamilyMemberGroupID,CardType,SubCategoryID)");
                        sb.Append(" SELECT @Patient_ID Patient_ID,mem.`MembershipCardID`,mem.`MembershipCardNo`,0 FamilyMemberIsPrimary,");
                        sb.Append(" me.`ItemID`,0 SelfDisc,me.DependentDisc,0 SelfFreeTest,0 SelfFreeTestCount,me.DependentFreeTest,me.DependentFreeTestCount,@CardValid,mem.FamilyMemberGroupID,@CardType,me.SubCategoryID ");
                        sb.Append(" FROM membershipcard_member mem INNER JOIN membershipcard_Detail me  ON me.`MembershipCardID`=mem.`MembershipCardID` AND me.FamilyMemberGroupID=@FamilyMemberGroupID");
                        sb.Append(" AND me.FamilyMemberIsPrimary=0 AND mem.Patient_ID=@Patient_ID WHERE mem.MembershipCardID=@MembershipCardID GROUP BY me.`ItemID` ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                  new MySqlParameter("@MembershipCardNo", Util.GetString(dtCardDetail.Rows[0]["CardNo"].ToString())),
                                  new MySqlParameter("@MembershipCardID", Util.GetInt(dtCardDetail.Rows[0]["MembershipCardID"].ToString())),
                                  new MySqlParameter("@CardType", dtCardDetail.Rows[0]["CardType"]),
                                  new MySqlParameter("@CardValid", Util.GetDateTime(dtCardDetail.Rows[0]["ValidTo"])),
                                  new MySqlParameter("@Patient_ID", PatientID),
                                  new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID));

                    }
                    else
                    {
                        int testCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM membershipcard_tests_master WHERE  MemberShipID=@MemberShipID",
                   new MySqlParameter("@MemberShipID", Util.GetInt(dtCardDetail.Rows[0]["MembershipCardID"].ToString()))));
                        if (testCount == 0)
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = "Please Add Test in MemberShip Card" });
                        }
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO membershipcard_Detail(Patient_ID,MembershipCardID,MembershipCardNo,FamilyMemberIsPrimary,ItemID,SelfDisc,DependentDisc,SelfFreeTest,SelfFreeTestCount,DependentFreeTest,DependentFreeTestCount,CardValid,FamilyMemberGroupID,CardType,SubCategoryID)");
                        sb.Append(" SELECT shi.`Patient_ID`,mem.`MemberShipID`,shi.`MembershipCardNo`,shi.`FamilyMemberIsPrimary`,");
                        sb.Append(" mem.`ItemID`,0 SelfDisc,mem.DependentDisc,0 SelfFreeTest,0 SelfFreeTestCount,mem.DependentFreeTest,mem.DependentFreeTestCount,@CardValid,shi.FamilyMemberGroupID,@CardType,mem.SubCategoryID ");
                        sb.Append(" FROM membershipcard_tests_master mem INNER JOIN membershipcard_member shi  ON mem.`MemberShipID`=shi.`MembershipCardID` AND shi.Patient_ID=@Patient_ID AND shi.FamilyMemberIsPrimary=0 AND shi.FamilyMemberGroupID=@FamilyMemberGroupID");
                        sb.Append(" WHERE mem.MemberShipID=@MembershipCardID ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                  new MySqlParameter("@MembershipCardNo", Util.GetString(dtCardDetail.Rows[0]["CardNo"].ToString())),
                                  new MySqlParameter("@FamilyMemberGroupID", FamilyMemberGroupID),
                                  new MySqlParameter("@MembershipCardID", Util.GetInt(dtCardDetail.Rows[0]["MembershipCardID"].ToString())),
                                  new MySqlParameter("@CardType", dtCardDetail.Rows[0]["CardType"]),
                                  new MySqlParameter("@Patient_ID", PatientID),
                                  new MySqlParameter("@CardValid", Util.GetDateTime(dtCardDetail.Rows[0]["ValidTo"])));
                    }
                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", respons="Membership Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

}