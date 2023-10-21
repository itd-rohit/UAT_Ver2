﻿using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;
using System.Xml;

public partial class Design_Master_CountryMaster : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ValidatePage())
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                if (ChkIsBaseCurrency.Checked == true)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update country_master set IsBasecurrency=0 ");
                }
                CountryMaster ObjConMaster = new CountryMaster(tnx);
                ObjConMaster.NAME = Util.GetString(txtCountryName.Text);
                ObjConMaster.Currency = Util.GetString(txtCurrency.Text);
                ObjConMaster.Address = Util.GetString(txtCounsellorAddress.Text);
                ObjConMaster.FaxNo = Util.GetString(txtFaxNoCounsellor.Text);
                ObjConMaster.PhoneNo = Util.GetString(txtPhoneNoCounsellor.Text);
                ObjConMaster.Notation = Util.GetString(txtNotation.Text);
                ObjConMaster.EmbassyAddress = Util.GetString(txtAddressEmbassy.Text);
                ObjConMaster.EmbassyPhoneNo = Util.GetString(txtPhoneNoEmbassy.Text);
                ObjConMaster.EmbessyFaxNo = Util.GetString(txtFaxNoEmbassy.Text);
                ObjConMaster.EntryUserID = Util.GetString(ViewState["UserID"].ToString());
                if (ChkIsBaseCurrency.Checked == true)
                    ObjConMaster.IsBaseCurrency = 1;
                else
                    ObjConMaster.IsBaseCurrency = 0;
                string CountryID = ObjConMaster.Insert();
                if (CountryID == string.Empty)
                {
                    tnx.Rollback();
                    return;
                }

                tnx.Commit();

                if (ChkIsBaseCurrency.Checked == true)
                {
                    XmlDocument loResource = new XmlDocument();
                    loResource.Load(Server.MapPath("~/App_GlobalResources/Resource.resx"));
                    XmlNode xDefaultCountry = loResource.SelectSingleNode("root/data[@name='DefaultCountry']/value");
                    xDefaultCountry.InnerText = txtCountryName.Text;
                    XmlNode xBaseCurrencyID = loResource.SelectSingleNode("root/data[@name='BaseCurrencyID']/value");
                    xBaseCurrencyID.InnerText = ddlCountry.SelectedValue;

                    loResource.Save(Server.MapPath("~/App_GlobalResources/Resource.resx"));
                }
                lblMsg.Text = "Record Saved Successfully";
                Clear();
                DropCache();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();
                lblMsg.Text = "Error occurred, Please contact administrator";
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (ValidatePage())
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                if (ChkIsBaseCurrency.Checked == true)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update country_master set IsBasecurrency=0 ");
                }
                CountryMaster ObjConMaster = new CountryMaster(tnx);
                ObjConMaster.NAME = Util.GetString(txtCountryName.Text);
                ObjConMaster.Currency = Util.GetString(txtCurrency.Text);
                ObjConMaster.Address = Util.GetString(txtCounsellorAddress.Text);
                ObjConMaster.FaxNo = Util.GetString(txtFaxNoCounsellor.Text);
                ObjConMaster.PhoneNo = Util.GetString(txtPhoneNoCounsellor.Text);
                ObjConMaster.Notation = Util.GetString(txtNotation.Text);
                ObjConMaster.EmbassyAddress = Util.GetString(txtAddressEmbassy.Text);
                ObjConMaster.EmbassyPhoneNo = Util.GetString(txtPhoneNoEmbassy.Text);
                ObjConMaster.EmbessyFaxNo = Util.GetString(txtFaxNoEmbassy.Text);
                ObjConMaster.UpdateByID = Util.GetString(ViewState["UserID"].ToString());
                ObjConMaster.Updatedate = DateTime.Now;
                ObjConMaster.Isactive = Util.GetInt(rdoIsActive.SelectedValue);
                ObjConMaster.CountryID = Util.GetString(ddlCountry.SelectedValue);
                if (ChkIsBaseCurrency.Checked == true)
                    ObjConMaster.IsBaseCurrency = 1;
                else
                    ObjConMaster.IsBaseCurrency = 0;

                ObjConMaster.Update();
                tnx.Commit();

                if (ChkIsBaseCurrency.Checked == true)
                {
                    XmlDocument loResource = new XmlDocument();
                    loResource.Load(Server.MapPath("~/App_GlobalResources/Resource.resx"));
                    XmlNode xDefaultCountry = loResource.SelectSingleNode("root/data[@name='DefaultCountry']/value");
                    xDefaultCountry.InnerText = txtCountryName.Text;
                    XmlNode xBaseCurrencyID = loResource.SelectSingleNode("root/data[@name='BaseCurrencyID']/value");
                    xBaseCurrencyID.InnerText = ddlCountry.SelectedValue;
                    loResource.Save(Server.MapPath("~/App_GlobalResources/Resource.resx"));
                }
                lblMsg.Text = "Record Updated Successfully";
                DropCache();
                Clear();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();
                lblMsg.Text = "Error occurred, Please contact administrator";

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void ddlCountry_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCountry.SelectedItem.Text != "Select")
        {
            DataTable dtCountryDetail = AllLoad_Data.LoadCountryByID(ddlCountry.SelectedValue);
            txtCountryName.Text = dtCountryDetail.Rows[0]["NAME"].ToString();
            txtCurrency.Text = dtCountryDetail.Rows[0]["Currency"].ToString();
            txtNotation.Text = dtCountryDetail.Rows[0]["Notation"].ToString();
            txtCounsellorAddress.Text = dtCountryDetail.Rows[0]["Address"].ToString();
            txtPhoneNoCounsellor.Text = dtCountryDetail.Rows[0]["PhoneNo"].ToString();
            txtFaxNoCounsellor.Text = dtCountryDetail.Rows[0]["FaxNo"].ToString();
            txtAddressEmbassy.Text = dtCountryDetail.Rows[0]["EmbassyAddress"].ToString();
            txtPhoneNoEmbassy.Text = dtCountryDetail.Rows[0]["EmbassyPhoneNo"].ToString();
            txtFaxNoEmbassy.Text = dtCountryDetail.Rows[0]["EmbessyFaxNo"].ToString();
            rdoIsActive.SelectedIndex = rdoIsActive.Items.IndexOf(rdoIsActive.Items.FindByValue(dtCountryDetail.Rows[0]["Isactive"].ToString()));
            if (dtCountryDetail.Rows[0]["IsBaseCurrency"].ToString() == "1")
                ChkIsBaseCurrency.Checked = true;
            else
                ChkIsBaseCurrency.Checked = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCountry();
            ViewState["UserID"] = Session["ID"].ToString();
        }
    }

    protected void rdoEdit_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoEdit.SelectedValue == "2")
        {
            ddlCountry.Visible = true;
            btnUpdate.Visible = true;
            txtCountryName.Visible = false;
            btnSave.Visible = false;
            BindCountry();
           
        }
        else
        {
            ddlCountry.Visible = false;
            btnUpdate.Visible = false;
            txtCountryName.Visible = true;
            btnSave.Visible = true;
           
        }
        Clear();
    }

    private void BindCountry()
    {
        ddlCountry.DataSource = AllLoad_Data.LoadCountry();
        ddlCountry.DataTextField = "NAME";
        ddlCountry.DataValueField = "CountryID";
        ddlCountry.DataBind();
        ddlCountry.Items.Insert(0, "Select");
    }

    private void Clear()
    {
        txtCountryName.Text = string.Empty;
        txtCurrency.Text = string.Empty;
        txtNotation.Text = string.Empty;
        txtCounsellorAddress.Text = string.Empty;
        txtAddressEmbassy.Text = string.Empty;
        txtPhoneNoCounsellor.Text = string.Empty;
        txtPhoneNoEmbassy.Text = string.Empty;
        txtFaxNoCounsellor.Text = string.Empty;
        txtFaxNoEmbassy.Text = string.Empty;
        rdoIsActive.SelectedIndex = 0;
        ddlCountry.SelectedIndex = 0;
        ChkIsBaseCurrency.Checked = false;
    }



    private bool ValidatePage()
    {
        if (txtCountryName.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Country Name";
            txtCountryName.Focus();
            return false;
        }
        if (txtCurrency.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Enter Currency";
            txtCurrency.Focus();
            return false;
        }
        if (txtNotation.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Notation";
            txtNotation.Focus();
            return false;
        }
        if (txtCounsellorAddress.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Counsellor Address";
            txtNotation.Focus();
            return false;
        }
        if (txtAddressEmbassy.Text == "")
        {
            lblMsg.Text = "Please Enter Embassy Address";
            txtNotation.Focus(); 
            return false;
        }

        return true;
    }
    private void DropCache()
    {
        CacheQuery.dropCache("Country");
        CacheQuery.dropCache("Currency");
    }
}