<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LedgerPassword.aspx.cs" Inherits="Design_Master_LedgerPassword" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">


            <b>Change Ledger Password<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>


        </div>
            <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Basic Information
            </div>

            <table style="width: 775px; float: left;border-collapse:collapse">
                
                <tr>
                    <td  style="width: 34%;" >&nbsp;</td>
                    <td style="width: 17%;text-align:right " >Centre Name :&nbsp;
                    </td>
                    <td  style="width: 60%">
                       <asp:Label ID="lblCentreName" runat="server" Font-Bold="true" Font-Size="Large"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td  style="width: 34%;" >&nbsp;</td>
                    <td style="width: 17%;text-align:right" >
                        <span style="color: red ">Old Password :&nbsp;</span>
                    </td>
                    <td  style="width: 60%">
                        <asp:TextBox ID="txtOldPassword" runat="server"  MaxLength="20" AutoCompleteType="Disabled"
                            TextMode="Password" Width="134px"></asp:TextBox>                      
                    </td>
                </tr>
                <tr>
                    <td  style="width: 34%;" >&nbsp;</td>
                    <td style="width: 17%;text-align:right" >
                        <span style="color: red; ">New Password :&nbsp;</span>
                    </td>
                    <td  colspan="1" style="width: 60%">
                        <asp:TextBox ID="txtNewPassword" runat="server" MaxLength="20" AutoCompleteType="Disabled"
                            TextMode="Password" Width="134px"></asp:TextBox><span style="color: red;">*</span>
                    </td>
                </tr>
                <tr>
                    <td   style="width: 34%">&nbsp;</td>
                    <td  style="width: 17%;text-align:right">
                        <span style="color: red;">Confirm&nbsp;Password&nbsp;:&nbsp;</span>
                    </td>
                    <td  colspan="1" style="width: 60%">
                        <asp:TextBox ID="txtConfirmPassword" runat="server"   MaxLength="20" AutoCompleteType="Disabled"
                            TextMode="Password" Width="134px"></asp:TextBox><span style="color: red;">*</span>
                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToCompare="txtNewPassword"
                            ControlToValidate="txtConfirmPassword" ErrorMessage="New Password Not Matched"></asp:CompareValidator>
                    </td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" value="Save" class="savebutton" id="btnSave" onclick="SaveLedgerPassword()"  />
           
        </div>
         </div>
    <script type="text/javascript">
        function SaveLedgerPassword() {
            jQuery('#lblMsg').html('');
            if (jQuery.trim( jQuery("#txtOldPassword").val()) == "") {
                jQuery("#lblMsg").text('Please Enter Old Password');
                jQuery("#txtOldPassword").focus();
                return false;
            }
            if (jQuery.trim(jQuery("#txtNewPassword").val()) == "") {
                jQuery("#lblMsg").text('Please Enter New Password');
                jQuery("#txtNewPassword").focus();
                return false;
            }
            if (jQuery.trim(jQuery("#txtConfirmPassword").val()) == "") {
                jQuery("#lblMsg").text('Please Enter Confirm Password');
                jQuery("#txtConfirmPassword").focus();
                return false;
            }
            if (jQuery.trim(jQuery("#txtNewPassword").val()).length <3) {
                jQuery('#lblMsg').html('Please Enter Valid Ledger Password.Ledger Password Must Contain At least 3 Characters');
                jQuery("#txtNewPassword").focus();
                return false;
            }
            var resultPassword = LedgerPassword();
            jQuery.ajax({
                url: "LedgerPassword.aspx/UpdateLedgerPassword",
                data: JSON.stringify({ LedPassword: resultPassword}),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        jQuery('#lblMsg').html('Record Updated');
                        jQuery("#txtNewPassword,#txtOldPassword,#txtConfirmPassword").val('');
                    }                    
                    else if (result.d == "-2")
                        jQuery('#lblMsg').html('Please Enter Correct Old Password');
                    else if (result.d == "-3")
                        jQuery('#lblMsg').html('New Password does not match with the confirmed Password.');
                    else if (result.d == "0")
                        jQuery('#lblMsg').html('Error Occurred');
                }

            });
        }
        function LedgerPassword() {
            var dataLedger = new Array();
            var objLedger = new Object();

            objLedger.OldPassword = jQuery.trim(jQuery("#txtOldPassword").val());
            objLedger.NewPassword = jQuery.trim(jQuery("#txtNewPassword").val())
            objLedger.ConfirmPassword = jQuery.trim(jQuery("#txtConfirmPassword").val())
            dataLedger.push(objLedger);
            return dataLedger;
        }
    </script>
</asp:Content>

