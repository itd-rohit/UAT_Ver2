using System;
using System.Collections.Generic;
using System.Linq;
public partial class Design_Master_OutSourceTestToOtherLab : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        //if (Util.GetString(Session["RoleId"]) == "220")
        //{
        //    B2BUserManual.Visible = true;
        //}
        //else if (Util.GetString(Session["RoleId"]) == "218")
        //{
        //    CCUserManual.Visible = true;
        //}
        //else if (Util.GetString(Session["RoleId"]) == "219")
        //{
        //    FCUserManual.Visible = true;
        //}
         if (Util.GetString(Session["RoleId"]) == "1")//Account
        {
            UserManualAccounts.Visible = true;
            Account.Visible = true;

        }
        else if (Util.GetString(Session["RoleId"]) == "9")//front office
        {
            UserManualFrontOffice.Visible = true;
        }
        else if (Util.GetString(Session["RoleId"]) == "11")//Laboratory
        {
            Laboratory.Visible = true;
            UserManualLaboratory.Visible = true;
        }
        else if (Util.GetString(Session["RoleId"]) == "11")
        {
            Laboratory.Visible = true;
        }
        else if(Util.GetString(Session["RoleId"]) == "250")
        {
             Account.Visible = true;
             Laboratory.Visible = true;
             Laboratorymaster.Visible = true;
             Registration.Visible = true;
             SampleManagement.Visible = true;
             UserManualLaboratory.Visible = true;
             UserManualFrontOffice.Visible = true;
             UserManualLaboratoryMaster.Visible = true;
             UserManualAccounts.Visible = true;
        }

        else {
           // B2BUserManual.Visible = true;
           // CCUserManual.Visible = true;
           // FCUserManual.Visible = true;
           // Account.Visible = true;
           // Laboratory.Visible = true;
           // Laboratorymaster.Visible = true;
           // Registration.Visible = true;
           // SampleManagement.Visible = true;
           // UserManualLaboratory.Visible = true;
           // UserManualFrontOffice.Visible = true;
           // UserManualLaboratoryMaster.Visible = true;
           // UserManualAccounts.Visible = true;
        }
    }
    
}