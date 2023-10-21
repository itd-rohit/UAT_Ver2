﻿using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_MemberShipCard_Membership_Card_Design1 : System.Web.UI.UserControl
{
    string _CardNo = "";
    public string CardNo
    {
        get { return _CardNo; }
        set { _CardNo = value; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {

        string CardNumber = Session["MembershipCards1"].ToString();
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("  SELECT DATE_FORMAT(Mc.ValidFRom,'%d-%b-%Y')ValidFrom,DATE_FORMAT(MC.ValidTo,'%d-%b-%Y')ValidUpto,MCMEM.Pname NAME,MCMEM.Relation, MCMEM.Age, ");
            sb.Append(" Mc.ValidTo CardValid,MCM.Name CardName,MCM.Image AS CardImage ,IF(MCMEM.Photo IS NULL OR MCMEM.Photo = '', 'NoImage.png',MCMEM.Photo) AS Photo FROM membershipcard MC ");
            sb.Append(" INNER JOIN membership_card_master MCM ON MC.MembershipCardID = MCM.ID INNER JOIN membershipcard_member MCMEM ON MCMEM.`FamilyMemberGroupID` = MC.FamilyMemberGroupID");
            sb.Append(" WHERE MC.CardNo = @CardNo");

            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CardNo", CardNumber)).Tables[0];
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        sb = new StringBuilder();
        if (dt.Rows.Count > 0)
        {
            imgPatient.ImageUrl = string.Concat("~/Design/OPD/MemberShipCard/Photo/", dt.Rows[0]["Photo"].ToString().Trim());
            lblCardNo.Text = string.Concat("Card No, : ", CardNumber);
            lblName.Text = dt.Rows[0]["Name"].ToString().Trim();
            //lblValidity.Text = "Validity : " + dt.Rows[0]["CardValid"].ToString().Trim() +" Years";
            imgFront.ImageUrl = dt.Rows[0]["CardImage"].ToString().Trim();
            //lblDiscount.Text = "Discount : " + dt.Rows[0]["DiscountInPercentage"].ToString().Trim() + "%";
            lblValidUpto.Text = string.Concat("Valid From : ", dt.Rows[0]["ValidFrom"].ToString());
            lblValidity.Text = string.Concat("Valid UpTo : ", dt.Rows[0]["ValidUpto"].ToString());
            int PatientMembers = dt.Rows.Count;
            switch (PatientMembers)
            {
                case 1:
                    {
                        imgMember1.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[0]["Photo"].ToString().Trim();
                        lblRelation1.Text = dt.Rows[0]["Relation"].ToString().Trim();
                        lblName1.Text = ": " + dt.Rows[0]["Name"].ToString().Trim();
                        imgMember2.Visible = false;
                        imgMember3.Visible = false;
                        imgMember4.Visible = false;
                        imgMember5.Visible = false;
                        imgMember6.Visible = false;
                        break;
                    }
                case 2:
                    {
                        imgMember1.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[0]["Photo"].ToString().Trim();
                        lblRelation1.Text = dt.Rows[0]["Relation"].ToString().Trim();
                        lblName1.Text = dt.Rows[0]["Name"].ToString().Trim();
                        imgMember2.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[1]["Photo"].ToString().Trim();
                        lblRelation2.Text = dt.Rows[1]["Relation"].ToString().Trim();
                        lblName2.Text = dt.Rows[1]["Name"].ToString().Trim();

                        imgMember3.Visible = false;
                        imgMember4.Visible = false;
                        imgMember5.Visible = false;
                        imgMember6.Visible = false;
                        break;
                    }
                case 3:
                    {
                        imgMember1.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[0]["Photo"].ToString().Trim();
                        lblRelation1.Text = dt.Rows[0]["Relation"].ToString().Trim();
                        lblName1.Text = dt.Rows[0]["Name"].ToString().Trim();
                        imgMember2.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[1]["Photo"].ToString().Trim();
                        lblRelation2.Text = dt.Rows[1]["Relation"].ToString().Trim();
                        lblName2.Text = dt.Rows[1]["Name"].ToString().Trim();
                        imgMember3.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[2]["Photo"].ToString().Trim();
                        lblRelation3.Text = dt.Rows[2]["Relation"].ToString().Trim();
                        lblName3.Text = dt.Rows[2]["Name"].ToString().Trim();

                        imgMember4.Visible = false;
                        imgMember5.Visible = false;
                        imgMember6.Visible = false;
                        break;
                    }
                case 4:
                    {
                        imgMember1.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[0]["Photo"].ToString().Trim();
                        lblRelation1.Text = dt.Rows[0]["Relation"].ToString().Trim();
                        lblName1.Text = dt.Rows[0]["Name"].ToString().Trim();
                        imgMember2.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[1]["Photo"].ToString().Trim();
                        lblRelation2.Text = dt.Rows[1]["Relation"].ToString().Trim();
                        lblName2.Text = dt.Rows[1]["Name"].ToString().Trim();
                        imgMember3.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[2]["Photo"].ToString().Trim();
                        lblRelation3.Text = dt.Rows[2]["Relation"].ToString().Trim();
                        lblName3.Text = dt.Rows[2]["Name"].ToString().Trim();
                        imgMember4.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[3]["Photo"].ToString().Trim();
                        lblRelation4.Text = dt.Rows[3]["Relation"].ToString().Trim();
                        lblName4.Text = dt.Rows[3]["Name"].ToString().Trim();

                        imgMember5.Visible = false;
                        imgMember6.Visible = false;
                        break;
                    }
                case 5:
                    {
                        imgMember1.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[0]["Photo"].ToString().Trim();
                        lblRelation1.Text = dt.Rows[0]["Relation"].ToString().Trim();
                        lblName1.Text = ": " + dt.Rows[0]["Name"].ToString().Trim();
                        imgMember2.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[1]["Photo"].ToString().Trim();
                        lblRelation2.Text = dt.Rows[1]["Relation"].ToString().Trim();
                        lblName2.Text = ": " + dt.Rows[1]["Name"].ToString().Trim();
                        imgMember3.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[2]["Photo"].ToString().Trim();
                        lblRelation3.Text = dt.Rows[2]["Relation"].ToString().Trim();
                        lblName3.Text = ": " + dt.Rows[2]["Name"].ToString().Trim();
                        imgMember4.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[3]["Photo"].ToString().Trim();
                        lblRelation4.Text = dt.Rows[3]["Relation"].ToString().Trim();
                        lblName4.Text = ": " + dt.Rows[3]["Name"].ToString().Trim();
                        imgMember5.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[4]["Photo"].ToString().Trim();
                        lblRelation5.Text = dt.Rows[4]["Relation"].ToString().Trim();
                        lblName5.Text = ": " + dt.Rows[4]["Name"].ToString().Trim();

                        imgMember6.Visible = false;
                        break;
                    }
                case 6:
                    {
                        imgMember1.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[0]["Photo"].ToString().Trim();
                        lblRelation1.Text = dt.Rows[0]["Relation"].ToString().Trim();
                        lblName1.Text = ": " + dt.Rows[0]["Name"].ToString().Trim();
                        imgMember2.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[1]["Photo"].ToString().Trim();
                        lblRelation2.Text = dt.Rows[1]["Relation"].ToString().Trim();
                        lblName2.Text = ": " + dt.Rows[1]["Name"].ToString().Trim();
                        imgMember3.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[2]["Photo"].ToString().Trim();
                        lblRelation3.Text = dt.Rows[2]["Relation"].ToString().Trim();
                        lblName3.Text = ": " + dt.Rows[2]["Name"].ToString().Trim();
                        imgMember4.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[3]["Photo"].ToString().Trim();
                        lblRelation4.Text = dt.Rows[3]["Relation"].ToString().Trim();
                        lblName4.Text = ": " + dt.Rows[3]["Name"].ToString().Trim();
                        imgMember5.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[4]["Photo"].ToString().Trim();
                        lblRelation5.Text = dt.Rows[4]["Relation"].ToString().Trim();
                        lblName5.Text = ": " + dt.Rows[4]["Name"].ToString().Trim();
                        imgMember6.ImageUrl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[5]["Photo"].ToString().Trim();
                        lblRelation6.Text = dt.Rows[5]["Relation"].ToString().Trim();
                        lblName6.Text = ": " + dt.Rows[5]["Name"].ToString().Trim();
                        break;
                    }
            }

        }

    }
}