<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SMSConfigurations.aspx.cs" Inherits="Design_Master_ReportBackGound" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <title></title>
    <style type="text/css">
        #MainImages {
            width: 200px;
            height: 200px;
        }

            #MainImages img {
                cursor: pointer;
                height: 90%;
            }

        #Fullscreen {
            width: 100%;
            display: none;
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            background-color: pink;
        }

            #Fullscreen img {
                display: block;
                height: 100%;
                width: 600px;
                margin: 0 auto;
            }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {

        });
    </script>
</head>
<body>

    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory" style="width: 904px;">
            <div class="POuter_Box_Inventory" style="width: 900px;">
                <div class="content">

                    <table width="99%">
                        <tr>
                            <td align="center">
                                <b>SMS Configuration</b>
                                <br />
                                <strong>Current Panel :</strong>&nbsp;&nbsp;
                                <asp:DropDownList ID="ddlcentre" runat="server"></asp:DropDownList>
                                <asp:HiddenField ID="hdnPanelId" runat="server" />

                                <br />
                                <asp:Label ID="lb" runat="server" Font-Bold="true" ForeColor="Red" />


                            </td>
                        </tr>
                    </table>
                </div>


            </div>
            <div class="POuter_Box_Inventory" style="width: 900px;">
                <div class="content">
                    <table id="tblData" class="GridViewStyle" width="100%">
                        <tr>
                            <th class="GridViewHeaderStyle">SNo.</th>
                            <th class="GridViewHeaderStyle">SMS Event</th>
                            <th class="GridViewHeaderStyle">Template</th>
                            <th class="GridViewHeaderStyle">
                                <input type="checkbox" id="chkAll" onchange="CheckAll();" /></th>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 900px;text-align:center;">
                <input type="button" id="btnSaveSMSConfig" onclick="SaveSMSConfig();" value="Update" class="savebutton" />
            </div>
        </div>
    </form>

    <script type="text/javascript">
        $(document).ready(function () {
            bindData();
        });
        function bindData() {
            $.ajax({
                url: "SMSConfigurations.aspx/bindData",
                async: true,
                data: '{PanelId:"' + $('[id$=hdnPanelId]').val() + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    debugger
                    var data = $.parseJSON(result.d);
                    if (data.length > 0) {
                        var html = '';
                        for (var i = 0; i < data.length; i++) {
                           
                            html += '<tr>';
                            html += '<td class="GridViewItemStyle">' + (i + 1) + ' </td>';
                            html += '<td class="GridViewItemStyle">' + data[i].SMSFor + '</td>';
                            html += '<td class="GridViewItemStyle">' + data[i].Templete + '</td>';
                            html += '<td class="GridViewItemStyle" style="text-align:center;"><input type="checkbox" id="chkItem" ';
                            if (data[i].IsSelected != '0')
                            {
                                html += ' checked="checked" ';
                            }
                            html += '/> <input type="hidden" id="hdnId" value="' + data[i].Id + '" /> </td>';
                            html += '</tr>';
                        }
                        $('#tblData').append(html);
                    }
                }
            });
        }

        function SaveSMSConfig() {
            var data = '';
            $('#tblData tr').find('input[type=checkbox]').each(function (index) {
                if (index > 0) {

                    if ($(this).is(':checked')) {
                        data += $(this).next().val() + ',';
                    }
                }
            });
            if (data.length > 0)
                data = data.substring(0, data.length - 1);

            $.ajax({
                url: "SMSConfigurations.aspx/SaveSMSConfig",
                async: true,
                data: JSON.stringify({ PanelId: $('[id$=ddlcentre]').val(), SMSId: data }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        alert('Settings Updated Successfully');
                    } else {
                        alert('Some Error Occured, Please try again later');
                    }
                }
            });



        }

        function CheckAll()
        {
            $('#tblData tr').find('input[type=checkbox]').each(function (index) {
                if (index > 0) {
                    if ($('[id$=chkAll]').is(':checked')) {
                        $(this).prop('checked', true);
                    } else {
                        $(this).prop('checked', false);
                    }
                }
            });
        }

    </script>
</body>
</html>
