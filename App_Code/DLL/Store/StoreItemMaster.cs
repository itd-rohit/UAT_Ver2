using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for StoreItemMaster
/// </summary>
public class StoreItemMaster
{
	

    
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    public StoreItemMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
       
    }
    public StoreItemMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }


    public int ItemID { get; set; }
    public int CategoryTypeID { get; set; }
    public int SubCategoryTypeID { get; set; }
    public int SubCategoryID { get; set; }
    public string TypeName { get; set; }
    public string Description { get; set; }
    public string Specification { get; set; }
    public string MakeandModelNo { get; set; }
    public string ClientItemCode { get; set; }
    public string HsnCode { get; set; }
    public int Expdatecutoff { get; set; }
    public float GSTNTax { get; set; }
    public int IsExpirable { get; set; }
    public string TemperatureStock { get; set; }
    public int IsActive { get; set; }
    public string ManufactureID { get; set; }
    public string ManufactureName { get; set; }
    public string CatalogNo { get; set; }
    public string MachinId { get; set; }
    public string MachinName { get; set; }
    public string MajorUnitId { get; set; }
    public string MajorUnitName { get; set; }
    public string PackSize { get; set; }
    public float Converter { get; set; }
    public string MinorUnitId { get; set; }
    public string MinorUnitName { get; set; }
    public int ItemIDGroup { get; set; }
    public int IssueMultiplier { get; set; }
    public int BarcodeOption { get; set; }
    public int BarcodeGenrationOption { get; set; }
    public int IssueInFIFO { get; set; }
    public int MajorUnitInDecimal { get; set; }
    public int MinorUnitInDecimal { get; set; }
    public string Insert()
    {
        try
        {
            string saveditemid = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("store_itemmaster");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@Item_ID";

            paramTnxID.MySqlDbType = MySqlDbType.VarChar;
            paramTnxID.Size = 15;

            paramTnxID.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;


            cmd.Parameters.Add(new MySqlParameter("@CategoryTypeID", Util.GetInt(CategoryTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryTypeID", Util.GetInt(SubCategoryTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryID", Util.GetInt(SubCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@TypeName", Util.GetString(TypeName).ToUpper()));
            cmd.Parameters.Add(new MySqlParameter("@Description", Util.GetString(Description)));
            cmd.Parameters.Add(new MySqlParameter("@Specification", Util.GetString(Specification)));
            cmd.Parameters.Add(new MySqlParameter("@MakeandModelNo", Util.GetString(MakeandModelNo)));
            cmd.Parameters.Add(new MySqlParameter("@ClientItemCode", Util.GetString(ClientItemCode)));
            cmd.Parameters.Add(new MySqlParameter("@HsnCode", Util.GetString(HsnCode)));
            cmd.Parameters.Add(new MySqlParameter("@Expdatecutoff", Util.GetInt(Expdatecutoff)));
            cmd.Parameters.Add(new MySqlParameter("@GSTNTax", Util.GetFloat(GSTNTax)));
            cmd.Parameters.Add(new MySqlParameter("@TemperatureStock", Util.GetString(TemperatureStock)));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", Util.GetInt(IsActive)));
            cmd.Parameters.Add(new MySqlParameter("@CreaterID", Util.GetInt(UserInfo.ID)));

            cmd.Parameters.Add(new MySqlParameter("@ManufactureID", Util.GetString(ManufactureID)));
            cmd.Parameters.Add(new MySqlParameter("@ManufactureName", Util.GetString(ManufactureName)));
            cmd.Parameters.Add(new MySqlParameter("@CatalogNo", Util.GetString(CatalogNo)));
            cmd.Parameters.Add(new MySqlParameter("@MachineID", Util.GetString(MachinId)));
            cmd.Parameters.Add(new MySqlParameter("@MachineName", Util.GetString(MachinName)));
            cmd.Parameters.Add(new MySqlParameter("@MajorUnitId", Util.GetString(MajorUnitId)));
            cmd.Parameters.Add(new MySqlParameter("@MajorUnitName", Util.GetString(MajorUnitName)));
            cmd.Parameters.Add(new MySqlParameter("@Converter", Util.GetFloat(Converter)));
            cmd.Parameters.Add(new MySqlParameter("@PackSize", Util.GetString(PackSize)));
            

            cmd.Parameters.Add(new MySqlParameter("@MinorUnitId", Util.GetString(MinorUnitId)));
            cmd.Parameters.Add(new MySqlParameter("@MinorUnitName", Util.GetString(MinorUnitName)));
            cmd.Parameters.Add(new MySqlParameter("@ItemIDGroup", Util.GetInt(ItemIDGroup)));
            cmd.Parameters.Add(new MySqlParameter("@IsExpirable", Util.GetInt(IsExpirable)));

            cmd.Parameters.Add(new MySqlParameter("@IssueMultiplier", Util.GetInt(IssueMultiplier)));
            cmd.Parameters.Add(new MySqlParameter("@BarcodeOption", Util.GetInt(BarcodeOption)));
            cmd.Parameters.Add(new MySqlParameter("@BarcodeGenrationOption", Util.GetInt(BarcodeGenrationOption)));
            cmd.Parameters.Add(new MySqlParameter("@IssueInFIFO", Util.GetInt(IssueInFIFO)));

            cmd.Parameters.Add(new MySqlParameter("@MajorUnitInDecimal", Util.GetInt(MajorUnitInDecimal)));
            cmd.Parameters.Add(new MySqlParameter("@MinorUnitInDecimal", Util.GetInt(MinorUnitInDecimal)));
            cmd.Parameters.Add(paramTnxID);
            saveditemid = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return saveditemid.ToString();


        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }

    public int Update()
    {

        try
        {
            int saveditemid = 0;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append(" update st_itemmaster set CategoryTypeID='" + Util.GetInt(CategoryTypeID) + "',SubCategoryTypeID='" + Util.GetInt(SubCategoryTypeID) + "' ,");
            objSQL.Append(" SubCategoryID='" + Util.GetInt(SubCategoryID) + "',TypeName='" + Util.GetString(TypeName).ToUpper() + "',Description='" + Util.GetString(Description) + "',Specification='" + Util.GetString(Specification) + "',MakeandModelNo='" + Util.GetString(MakeandModelNo) + "', ");
            objSQL.Append(" ApolloItemCode='" + Util.GetString(ClientItemCode) + "' ,HsnCode='" + Util.GetString(HsnCode) + "',Expdatecutoff='" + Util.GetInt(Expdatecutoff) + "',");
            objSQL.Append(" GSTNTax='" + Util.GetFloat(GSTNTax) + "',TemperatureStock='" + Util.GetString(TemperatureStock) + "',IsActive='" + Util.GetInt(IsActive) + "',");

            objSQL.Append(" ManufactureID='" + Util.GetString(ManufactureID) + "',ManufactureName='" + Util.GetString(ManufactureName) + "',MachineID='" + Util.GetString(MachinId) + "',");
            objSQL.Append(" MachineName='" + Util.GetString(MachinName) + "',CatalogNo='" + Util.GetString(CatalogNo) + "',MajorUnitId='" + Util.GetString(MajorUnitId) + "',");
            objSQL.Append(" MajorUnitName='" + Util.GetString(MajorUnitName) + "',PackSize='" + Util.GetString(PackSize) + "',MinorUnitId='" + Util.GetString(MinorUnitId) + "',");
            objSQL.Append(" MinorUnitName='" + Util.GetString(MajorUnitName) + "',ItemIDGroup='" + Util.GetString(ItemIDGroup) + "',IsExpirable='" + Util.GetInt(IsExpirable) + "',IssueMultiplier='" + Util.GetInt(IssueMultiplier) + "',Converter='" + Util.GetFloat(Converter) + "',");
            objSQL.Append(" BarcodeOption='" + Util.GetInt(BarcodeOption) + "',BarcodeGenrationOption='" + Util.GetInt(BarcodeGenrationOption) + "',IssueInFIFO='" + Util.GetInt(IssueInFIFO) + "',");

            objSQL.Append(" UpdatedBy='" + UserInfo.ID + "',UpdateDate=now(),MajorUnitInDecimal='" + MajorUnitInDecimal + "',MinorUnitInDecimal='" + MinorUnitInDecimal + "' where itemid='" + Util.GetInt(ItemID) + "'");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

           
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.Text;



            saveditemid = cmd.ExecuteNonQuery();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return saveditemid;


        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }
}