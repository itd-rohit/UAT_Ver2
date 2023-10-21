<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CentreLog.aspx.cs" Inherits="Design_Master_CentreLog" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
         <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
        <%: Scripts.Render("~/bundles/WebFormsJs") %>
         <%: Scripts.Render("~/bundles/MsAjaxJs") %>
            <%: Scripts.Render("~/bundles/JQueryUIJs") %>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
     <div id="Pbody_box_inventory" style="width:554px">
        <div class="POuter_Box_Inventory" style="text-align: center;width:550px">
            <asp:Label ID="lblHeder" Font-Bold="true" runat="server"></asp:Label>
            <asp:Label ID="lblCentreID" Style="display: none" runat="server" ClientIDMode="Static"></asp:Label>
            <br />
            <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;width:550px">
            <div id="divCentreLog" style="margin-top: 5px; max-height: 500px; overflow-y: auto; overflow-x: hidden; width: 100%;">
                <table id="tblCentreLog" style="width: 98%; border-collapse: collapse; display: none">
                    <tr id="trCentreLog">
                        <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">S.No</td>
                        <td class="GridViewHeaderStyle" style="width: 60px; text-align: center">Log Type</td>
                        <td class="GridViewHeaderStyle" style="width: 160px; text-align: center">Created By</td>
                        <td class="GridViewHeaderStyle" style="width: 180px; text-align: center">Created Date Time</td>
                        <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Log</td>

                    </tr>
                </table>
            </div>
        </div>

    </div>
    <script type="text/javascript">
        $(function () {
            getCentreLog();
        });
        function getCentreLog() {
            jQuery('#lblMsg').text('');
            PageMethods.bindCentreLog($("#lblCentreID").text(), onSucessCentreLog, onFailureCentreLog);

        }
        function onSucessCentreLog(result) {
            CentreLog = jQuery.parseJSON(result);
            alert(CentreLog);
            if (CentreLog != null) {
             
                for (var a = 0; a <= CentreLog.length - 1; a++) {
                    
                    if (jQuery('#tblCentreLog tr:not(#trCentreLog)').length == 0)
                        jQuery('#tblCentreLog,#divCentreLog').show();


                    var mydata = [];

                    mydata.push("<tr id='" + CentreLog[a].ID + "' class='GridViewItemStyle' >");
                    mydata.push('<td id="tdSNo" style="font-weight:bold;">' + (a + 1) + '</td>');
                    mydata.push('<td id="tdLogType" style="font-weight:bold;">' + CentreLog[a].LogType + '</td>');
                    mydata.push('<td id="tdCreatedBy" style="font-weight:bold;text-align:left">' + CentreLog[a].CreatedBy + '</td>');
                    mydata.push('<td id="tdCreatedDate" style="font-weight:bold;">' + CentreLog[a].CreatedDate + '</td>');
                    mydata.push('<td id="tdID" style="font-weight:bold;display:none">' + CentreLog[a].ID + '</td>');
                    mydata.push('<td id="tdCreatedDate" style="font-weight:bold;"><input type="button" id="btnSave" value="Open" class="ItDoseButton"  onclick="OpenCentreLog(this)" /></td>');
                    mydata.push("</tr>");
                    mydata = mydata.join(" ");

                    jQuery('#tblCentreLog').append(mydata);
                    jQuery('#tblCentreLog').css('display', 'block');
                }
            }
            else {
                jQuery('#tblCentreLog,#divCentreLog').hide();
                jQuery('#lblMsg').text('No Log Found');
            }
        }
        function onFailureCentreLog(result) {

        }
        function OpenCentreLog(rowID) {
            var ID = jQuery(rowID).closest('tr').find('#tdID').text();
            PageMethods.EncryptCentreLog(ID, onSucessEncrypt, onFailureCentreLog);

        }
        function onSucessEncrypt(result) {
            var result1 = jQuery.parseJSON(result);
            window.open('CentreMasterReport.aspx?LogID=' + result1[0] + '');
        }
    </script>
    </form>
</body>
</html>
