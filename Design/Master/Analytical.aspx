<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Analytical.aspx.cs" Inherits="Design_Master_Analytical" ClientIDMode="Static" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
    <%: System.Web.Optimization.Scripts.Render("~/bundles/WebFormsJs") %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
    <title></title>
</head>
<body>
    
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="width: 900px;">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="width: 896px; text-align: center">

                <b>
                    <asp:Label ID="lblHeder" Font-Bold="true" runat="server"></asp:Label>
                </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: left; width: 896px;">
                <div class="Purchaseheader">
                    Pre Analytical
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="font-weight: bold; color: red;" colspan="2">Centre Name :&nbsp;<asp:Label ID="lblCentreName" runat="server"></asp:Label>
                            <asp:Label ID="lblCentreID" runat="server" Style="display: none"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>
                            <em><span style="font-size: 7.5pt">(Average Time in Min.)</span></em>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 40%; text-align: right">Registration to Sample Collection :&nbsp;
                        </td>
                        <td>
                            <asp:TextBox ID="txtRegSample" runat="server" Width="100px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbRegSample" runat="server" TargetControlID="txtRegSample" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 40%; text-align: right">Sample Collection to Sample Send :&nbsp;
                        </td>
                        <td>
                            <asp:TextBox ID="txtSamColl" runat="server" Width="100px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbSamColl" runat="server" TargetControlID="txtSamColl" FilterType="Numbers"></cc1:FilteredTextBoxExtender>

                        </td>
                    </tr>
                    <tr>
                        <td style="width: 40%; text-align: right">Sample Send to Lab :&nbsp;
                        </td>
                        <td>
                            <asp:TextBox ID="txtSamSend" runat="server" Width="100px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbSamSend" runat="server" TargetControlID="txtSamSend" FilterType="Numbers"></cc1:FilteredTextBoxExtender>

                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="width: 896px; text-align: center">
                <input type="button" class="itdosebutton" value="Save" onclick="SaveAna()" id="btnSave" />
            </div>
        </div>
    </form>
    <script type="text/javascript">
        function SaveAna() {
            if (jQuery.trim(jQuery('#txtRegSample').val()) == "") {
                jQuery('#lblMsg').text('Please Enter Registration to Sample Collection');
                jQuery('#txtRegSample').focus();
                return;
            }
            if (jQuery.trim(jQuery('#txtSamColl').val()) == "") {
                jQuery('#lblMsg').text('Please Enter Sample Collection to Sample Send');
                jQuery('#txtSamColl').focus();
                return;
            }
            if (jQuery.trim(jQuery('#txtSamSend').val()) == "") {
                jQuery('#lblMsg').text('Please Enter Sample Send to Lab');
                jQuery('#txtSamSend').focus();
                return;
            }
            jQuery('#btnSave').attr('disabled', true).val("Submitting...");
            jQuery.ajax({
                url: "Analytical.aspx/saveAnalytical",
                data: '{PreRegToSample:"' + jQuery('#txtRegSample').val() + '",PreSampToSampSend:"' + jQuery('#txtSamColl').val() + '", PreSampSendToLab:"' + jQuery('#txtSamSend').val() + '",CentreID:"' + jQuery('#lblCentreID').text() + '"}', // parameter map 
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        alert("Record Saved Successfully");
                        window.close();
                    }
                    else {
                        alert('Error...');
                    }
                    jQuery('#btnSave').attr('disabled', false).val('Save');
                },
                error: function (xhr, status) {
                }
            });

        }
    </script>
</body>
</html>
