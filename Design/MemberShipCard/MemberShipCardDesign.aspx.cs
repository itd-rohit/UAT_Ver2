using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_MemberShipCard_MemberShipCardDesign : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.getApp("MemberShipCard") == "N")
        {
            Response.Redirect("../../Store/UnAuthorized.aspx");
        }

        if (Util.GetString(Request.QueryString["CardNumber"]) != "")
        {
            string CardNumber = Common.Decrypt(Util.GetString(Request.QueryString["CardNumber"]));
            Session["MembershipCards1"] = CardNumber;
            phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design1.ascx"));
        }
        else
        {
            string[] MembershipCards = Util.GetString(Request.QueryString["CardNo"]).Split('_');

            int Len = MembershipCards.Length - 2;

            switch (Len)
            {
                case 1:
                    {
                        Session["MembershipCards1"] = MembershipCards[1];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design1.ascx"));

                        break;
                    }
                case 2:
                    {
                        Session["MembershipCards1"] = MembershipCards[1];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design1.ascx"));
                        Session["MembershipCards2"] = MembershipCards[2];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design2.ascx"));
                        break;
                    }
                case 3:
                    {
                        Session["MembershipCards1"] = MembershipCards[1];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design1.ascx"));
                        Session["MembershipCards2"] = MembershipCards[2];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design2.ascx"));
                        Session["MembershipCards3"] = MembershipCards[3];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design3.ascx"));
                        break;
                    }
                case 4:
                    {
                        Session["MembershipCards1"] = MembershipCards[1];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design1.ascx"));
                        Session["MembershipCards2"] = MembershipCards[2];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design2.ascx"));
                        Session["MembershipCards3"] = MembershipCards[3];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design3.ascx"));
                        Session["MembershipCards4"] = MembershipCards[4];
                        phUserInfoBox.Controls.Add(LoadControl("~/Design/MemberShipCard/UserControls/Membership_Card_Design4.ascx"));
                        break;
                    }

            }

        }


    }
}