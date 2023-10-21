using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for CenterMaster
/// </summary>
public class CenterMaster
{

    #region All Memory Variables

    private string _type1;
    private int _type1ID;
    private string _Centre;
    private string _CentreCode;
    private string _UHIDCode;
    private int _isActive;
    private string _Address;
    private string _Address2;
    private string _City;
    private string _State;
    private string _Landline;
    private string _Mobile;
    private string _Email;
    private string _contactperson;
    private string _contactpersonmobile;
    private string _contactpersonemail;
    private string _contactpersondesignation;
    private string _zone;
    private int _ZoneID;
    private string _businessunit;
    private int _BusinessUnitID;
    private string _subbusinessunit;
    private int _SubBusinessUnitID;
    private string _unithead;
    private int _UnitHeadID;
    private string _ReferalRate;
    private int _TagProcessingLabID;
    private string _TagProcessingLab;
    private string _OnLineUserName;
    private string _OnlinePassword;
    private int _CentreID;
    private string _SavingType;

    private int _StateID;
    private int _CityID;
    private int _LocalityID;
    private string _BusinessZoneName;
    private int _BusinessZoneID;
    private int _SalesHierarchyID;
    private string _SalesHierarchyName;
    private string _Locality;
    private string _IndentType;
    private string _Category;
    private string _UserName;
    private string _UserPassword;
    private int _CountryID;
    private string _CountryName;
    #endregion All Memory Variables

    #region All Global Variables

    private MySqlConnection objCon;
    private MySqlTransaction objTrans;
    private bool IsLocalConn;

    #endregion All Global Variables

    #region Overloaded Constructor

    public CenterMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }

    public CenterMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    #endregion Overloaded Constructor

    #region Set All Property

    public virtual string type1 { get { return _type1; } set { _type1 = value; } }
    public virtual int type1ID { get { return _type1ID; } set { _type1ID = value; } }
    public virtual string Centre { get { return _Centre; } set { _Centre = value; } }
    public virtual string CentreCode { get { return _CentreCode; } set { _CentreCode = value; } }
    public virtual string UHIDCode { get { return _UHIDCode; } set { _UHIDCode = value; } }
    public virtual int isActive { get { return _isActive; } set { _isActive = value; } }
    public virtual string Address { get { return _Address; } set { _Address = value; } }
    public virtual string Address2 { get { return _Address2; } set { _Address2 = value; } }
    public virtual string City { get { return _City; } set { _City = value; } }
    public virtual string State { get { return _State; } set { _State = value; } }
    public virtual string Landline { get { return _Landline; } set { _Landline = value; } }
    public virtual string Mobile { get { return _Mobile; } set { _Mobile = value; } }
    public virtual string Email { get { return _Email; } set { _Email = value; } }
    public virtual string contactperson { get { return _contactperson; } set { _contactperson = value; } }
    public virtual string contactpersonmobile { get { return _contactpersonmobile; } set { _contactpersonmobile = value; } }
    public virtual string contactpersonemail { get { return _contactpersonemail; } set { _contactpersonemail = value; } }
    public virtual string contactpersondesignation { get { return _contactpersondesignation; } set { _contactpersondesignation = value; } }
    public virtual string zone { get { return _zone; } set { _zone = value; } }
    public virtual int ZoneID { get { return _ZoneID; } set { _ZoneID = value; } }
    public virtual string businessunit { get { return _businessunit; } set { _businessunit = value; } }
    public virtual int BusinessUnitID { get { return _BusinessUnitID; } set { _BusinessUnitID = value; } }
    public virtual string subbusinessunit { get { return _subbusinessunit; } set { _subbusinessunit = value; } }
    public virtual int SubBusinessUnitID { get { return _SubBusinessUnitID; } set { _SubBusinessUnitID = value; } }
    public virtual string unithead { get { return _unithead; } set { _unithead = value; } }
    public virtual int UnitHeadID { get { return _UnitHeadID; } set { _UnitHeadID = value; } }
    public virtual string ReferalRate { get { return _ReferalRate; } set { _ReferalRate = value; } }
    public virtual int TagProcessingLabID { get { return _TagProcessingLabID; } set { _TagProcessingLabID = value; } }
    public virtual string TagProcessingLab { get { return _TagProcessingLab; } set { _TagProcessingLab = value; } }
    public virtual string OnLineUserName { get { return _OnLineUserName; } set { _OnLineUserName = value; } }
    public virtual string OnlinePassword { get { return _OnlinePassword; } set { _OnlinePassword = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string SavingType { get { return _SavingType; } set { _SavingType = value; } }

    public virtual int StateID { get { return _StateID; } set { _StateID = value; } }
    public virtual int CityID { get { return _CityID; } set { _CityID = value; } }
    public virtual int LocalityID { get { return _LocalityID; } set { _LocalityID = value; } }

    public virtual string BusinessZoneName { get { return _BusinessZoneName; } set { _BusinessZoneName = value; } }
    public virtual int BusinessZoneID { get { return _BusinessZoneID; } set { _BusinessZoneID = value; } }
    public virtual int SalesHierarchyID { get { return _SalesHierarchyID; } set { _SalesHierarchyID = value; } }
    public virtual string SalesHierarchyName { get { return _SalesHierarchyName; } set { _SalesHierarchyName = value; } }
    public virtual string Locality { get { return _Locality; } set { _Locality = value; } }
    public virtual string IndentType { get { return _IndentType; } set { _IndentType = value; } }
    public virtual string Category { get { return _Category; } set { _Category = value; } }

    public virtual string UserName { get { return _UserName; } set { _UserName = value; } }
    public virtual string UserPassword { get { return _UserPassword; } set { _UserPassword = value; } }
    public virtual int CountryID { get { return _CountryID; } set { _CountryID = value; } }
    public string CountryName { get { return _CountryName; } set { _CountryName = value; } }
    #endregion Set All Property

    #region All Public Member Function

    public int Insert()
    {
        try
        {
            int iPkValue = 0;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_center");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@vcenterID", MySqlDbType = MySqlDbType.VarChar, Size = 50, Direction = ParameterDirection.Output };
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };

            this.type1 = Util.GetString(type1);
            this.type1ID = Util.GetInt(type1ID);
            this.Centre = Util.GetString(Centre);
            this.CentreCode = Util.GetString(CentreCode);
            this.UHIDCode = Util.GetString(UHIDCode);
            this.isActive = Util.GetInt(isActive);
            this.Address = Util.GetString(Address);
            this.Address2 = Util.GetString(Address2);
            this.City = Util.GetString(City);
            this.State = Util.GetString(State);
            this.Landline = Util.GetString(Landline);
            this.Mobile = Util.GetString(Mobile);
            this.Email = Util.GetString(Email);
            this.contactperson = Util.GetString(contactperson);
            this.contactpersonmobile = Util.GetString(contactpersonmobile);
            this.contactpersonemail = Util.GetString(contactpersonemail);
            this.contactpersondesignation = Util.GetString(contactpersondesignation);
            this.zone = Util.GetString(zone);
            this.ZoneID = Util.GetInt(ZoneID);
            this.businessunit = Util.GetString(businessunit);
            this.BusinessUnitID = Util.GetInt(BusinessUnitID);
            this.subbusinessunit = Util.GetString(subbusinessunit);
            this.SubBusinessUnitID = Util.GetInt(SubBusinessUnitID);
            this.unithead = Util.GetString(unithead);
            this.UnitHeadID = Util.GetInt(UnitHeadID);
            this.ReferalRate = Util.GetString(ReferalRate);
            this.TagProcessingLabID = Util.GetInt(TagProcessingLabID);
            this.TagProcessingLab = Util.GetString(TagProcessingLab);
            this.OnLineUserName = Util.GetString(OnLineUserName);
            this.OnlinePassword = Util.GetString(OnlinePassword);
            this.SavingType = Util.GetString(SavingType);

            this.StateID = Util.GetInt(StateID);
            this.CityID = Util.GetInt(CityID);
            this.LocalityID = Util.GetInt(LocalityID);
            this.BusinessZoneID = Util.GetInt(BusinessZoneID);
            this.BusinessZoneName = Util.GetString(BusinessZoneName);
            this.SalesHierarchyID = Util.GetInt(SalesHierarchyID);
            this.SalesHierarchyName = Util.GetString(SalesHierarchyName);
            this.Locality = Util.GetString(Locality);
            this.IndentType = Util.GetString(IndentType);
            this.Category = Util.GetString(Category);
			this.CountryID=Util.GetInt(CountryID);
            this.CountryName = Util.GetString(CountryName);
            cmd.Parameters.Add(new MySqlParameter("@type1", type1));
            cmd.Parameters.Add(new MySqlParameter("@type1ID", type1ID));
            cmd.Parameters.Add(new MySqlParameter("@Centre", Centre));
            cmd.Parameters.Add(new MySqlParameter("@centercode", CentreCode));
            cmd.Parameters.Add(new MySqlParameter("@UHIDCode", UHIDCode));
            cmd.Parameters.Add(new MySqlParameter("@isActive", isActive));
            cmd.Parameters.Add(new MySqlParameter("@Address", Address));
            cmd.Parameters.Add(new MySqlParameter("@Address2", Address2));
            cmd.Parameters.Add(new MySqlParameter("@City", City));
            cmd.Parameters.Add(new MySqlParameter("@State", State));
            cmd.Parameters.Add(new MySqlParameter("@Landline", Landline));
            cmd.Parameters.Add(new MySqlParameter("@Mobile", Mobile));
            cmd.Parameters.Add(new MySqlParameter("@Email", Email));
            cmd.Parameters.Add(new MySqlParameter("@contactperson", contactperson));
            cmd.Parameters.Add(new MySqlParameter("@contactpersonmobile", contactpersonmobile));
            cmd.Parameters.Add(new MySqlParameter("@contactpersonemail", contactpersonemail));
            cmd.Parameters.Add(new MySqlParameter("@contactpersondesignation", contactpersondesignation));
            cmd.Parameters.Add(new MySqlParameter("@zone", zone));
            cmd.Parameters.Add(new MySqlParameter("@ZoneID", ZoneID));
            cmd.Parameters.Add(new MySqlParameter("@businessunit", businessunit));
            cmd.Parameters.Add(new MySqlParameter("@BusinessUnitID", BusinessUnitID));
            cmd.Parameters.Add(new MySqlParameter("@subbusinessunit", subbusinessunit));
            cmd.Parameters.Add(new MySqlParameter("@SubBusinessUnitID", SubBusinessUnitID));
            cmd.Parameters.Add(new MySqlParameter("@unithead", unithead));
            cmd.Parameters.Add(new MySqlParameter("@UnitHeadID", UnitHeadID));
            cmd.Parameters.Add(new MySqlParameter("@ReferalRate", ReferalRate));
            cmd.Parameters.Add(new MySqlParameter("@TagProcessingLabID", TagProcessingLabID));
            cmd.Parameters.Add(new MySqlParameter("@TagProcessingLab", TagProcessingLab));
            cmd.Parameters.Add(new MySqlParameter("@OnLineUserName", OnLineUserName));
            cmd.Parameters.Add(new MySqlParameter("@OnlinePassword", OnlinePassword));
            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", HttpContext.Current.Session["ID"].ToString()));
            cmd.Parameters.Add(new MySqlParameter("@SavingType", SavingType));

            cmd.Parameters.Add(new MySqlParameter("@StateID", StateID));
            cmd.Parameters.Add(new MySqlParameter("@CityID", CityID));
            cmd.Parameters.Add(new MySqlParameter("@LocalityID", LocalityID));
            cmd.Parameters.Add(new MySqlParameter("@BusinessZoneID", BusinessZoneID));
            cmd.Parameters.Add(new MySqlParameter("@BusinessZoneName", BusinessZoneName));

            cmd.Parameters.Add(new MySqlParameter("@Sales_HierarchyID", SalesHierarchyID));
            cmd.Parameters.Add(new MySqlParameter("@Sales_HierarchyName", SalesHierarchyName));
            cmd.Parameters.Add(new MySqlParameter("@Locality", Locality));
            cmd.Parameters.Add(new MySqlParameter("@IndentType", IndentType));
            cmd.Parameters.Add(new MySqlParameter("@Category", Category));
            cmd.Parameters.Add(new MySqlParameter("@CountryID", CountryID));
            cmd.Parameters.Add(new MySqlParameter("@CountryName", CountryName));
            cmd.Parameters.Add(paramTnxID);

            CentreID = Util.GetInt(cmd.ExecuteScalar());

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return CentreID;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            throw (ex);

        }
    }

    #endregion All Public Member Function

}