using System;
using System.Web.UI;


public partial class Design_EDP_UserRight : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int uid = UserInfo.ID;
            int rid = UserInfo.RoleID;
            if (uid != 1 || rid != 6)
            {
                Session["userid"] = uid;
                Session["roleid"] = rid;
                //System.Web.UI.ScriptManager.RegisterStartupScript(this, GetType(), "displayalertmessage", "alert('This menu is for EDP role & Itdose team Only...!');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';toast('Error','This menu is for EDP role & Itdose team Only...!');", true);
            }

        }
       
    }


}