<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" CodeFile="PackageRateMaster.aspx.cs" Inherits="Design_Investigation_PackageRateMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server" id="Head1">
   <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
          <%: Scripts.Render("~/bundles/WebFormsJs") %>
   
   
     <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>


    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/Chosen") %>
    <style>
        #lstPanel_chosen {
            text-align: left;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory" class="POuter_Box_Inventory" style="width: 904px;">
             <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
            <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
            <div class="POuter_Box_Inventory" style="width: 900px;text-align: center;">             
                    <h3><b>Package Rate Master</b></h3>                
            </div>
            <div class="POuter_Box_Inventory" style="width: 900px;">             
                    <table>
                        <tr>
                            <td style="text-align: center;" colspan="4">
                                <h3><b>Package Name  :   
                                    <asp:Label ID="lblpackage" runat="server" Style="font: bold;"></asp:Label></b></h3>
                            </td>
                            <asp:Label ID="lblItemID" runat="server" Style="display: none;"></asp:Label>
                        </tr>
                        <tr>
                            <td>Package Rate:</td>
                            <td> <asp:TextBox ID="txtPackageRate" runat="server" Font-Bold="true"  Style="width: 80px;"  ClientIDMode="Static"></asp:TextBox>                              
                                 <cc1:filteredtextboxextender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtPackageRate">
                                </cc1:filteredtextboxextender>
                                Total Rate:&nbsp;&nbsp;                             
                                <asp:TextBox ID="txtTotalRate" runat="server" CssClass="overallrate" Font-Bold="true" Style="width: 80px;" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>                                
                            </td>
                            <td>Base Rate : </td>
                            <td>
                                <asp:DropDownList ID="lstPanel" Style="height: 23px; width: 400px;"  class="lstPanel  chosen-select" onchange="BindRate()" runat="server"  ClientIDMode="Static"></asp:DropDownList></td>
                        </tr>
                    </table>            
            </div>
            <div class="POuter_Box_Inventory" style="width: 900px;">
                <div class="content" style="text-align: center; width: 900px;">
                    <table id="tblTestDetail" style="width: 99%; border-collapse: collapse; text-align: center; height: 40px;">
                        <tr id="trItemHeader">
                            <td class="GridViewHeaderStyle" style="text-align: center;">S.No.</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Item ID</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Test Code</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Investigation   </td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">AtulyaMRP</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">AtulyaMRP(%)</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">Rate</td>
                            <td class="GridViewHeaderStyle" style="text-align: center;">(%)</td>
                        </tr>                     
                    </table>                 
                    <input type="button" class="savebutton" value="Save" id="btnSave" onclick="SaveData()" />
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">   
        function showmsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', '#04b076');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>
    <script type="text/javascript">
        jQuery(document).ready(function () {
            bindPanel();
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
            jQuery(".chosen-select").chosen();
        });                                    
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

       
    </script>
    <script type="text/javascript">
        function calRate(ctrl) {
            if (jQuery(ctrl).val().indexOf(" ") != -1) {
                jQuery(ctrl).val(jQuery(ctrl).val().replace(' ', ''));
            }
            var nbr = jQuery(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                jQuery(ctrl).val(jQuery(ctrl).val().substring(0, jQuery(ctrl).val().length - 1));
            }
          //  if (jQuery(ctrl).val().length > 1) {
          //      if (isNaN(jQuery(ctrl).val() / 1) == true) {
          //          jQuery(ctrl).val(jQuery(ctrl).val().substring(0, jQuery(ctrl).val().length - 1));
          //      }
          //  }
            if (isNaN(jQuery(ctrl).val() / 1) == true) {
                jQuery(ctrl).val('0');
                getPacRate();
                return;
            }
            else if (jQuery(ctrl).val() < 0) {
                jQuery(ctrl).val('0');
                getPacRate();
                return;
            }

            var total = 0;
            total = jQuery('#<%=txtPackageRate.ClientID%>').val();
            if (isNaN(total)) {
                total = 0;
            }
            var rate = jQuery(ctrl).val();
            if (isNaN(rate)) {
                rate = 0;
            }
            var Per = precise_round((rate * 100) / total, 3);
            if (isNaN(Per)) {
                Per = 0;
            }
            jQuery(ctrl).closest('tr').find('#txtTestPer').val(Per);
            getPacRate();
        }

        function calPer(ctrl) {
            //if (jQuery(ctrl).val().indexOf(" ") != -1) {
            //    jQuery(ctrl).val(jQuery(ctrl).val().replace(' ', ''));
            //}
            var nbr = jQuery(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                jQuery(ctrl).val(jQuery(ctrl).val().substring(0, jQuery(ctrl).val().length - 1));
            }
            //if (jQuery(ctrl).val().length > 1) {
            //    if (isNaN(jQuery(ctrl).val() / 1) == true) {
            //        jQuery(ctrl).val(jQuery(ctrl).val().substring(0, jQuery(ctrl).val().length - 1));
            //    }
            //}
            if (isNaN(jQuery(ctrl).val() / 1) == true) {
                jQuery(ctrl).val('');
                getPacRate();
                return;
            }
            else if (jQuery(ctrl).val() < 0) {
                jQuery(ctrl).val('');
                getPacRate();
                return;
            }
            if (jQuery(ctrl).val() > 100) {
                jQuery(ctrl).val('');
                showmsg("Please Enter Valid Percentage");
                jQuery(ctrl).closest('tr').find('#txtTestPer').focus();
                jQuery(ctrl).closest('tr').find('#txtTestRate').val('0');
                getPacRate();
                return;
            }

            var total = 0;
            total = jQuery('#<%=txtPackageRate.ClientID%>').val();
            if (isNaN(total)) {
                total = 0;
            }

            var rate = jQuery(ctrl).val();
            if (isNaN(rate)) {
                rate = 0;
            }
            var ratePer = jQuery(ctrl).val();
            if (isNaN(ratePer) || ratePer > 100) {
                ratePer = 0;
            }
            var rate = precise_round((total * ratePer) / 100, 3);
            if (isNaN(rate)) {
                rate = 0;
            }
            jQuery(ctrl).closest('tr').find('#txtTestRate').val(rate);
            getPacRate();
        }
        function getPacRate() {
            var calculated_total_sum = 0;

            jQuery('#tblTestDetail tr').each(function () {
                if (jQuery(this).attr('id') != 'trItemHeader' && jQuery(this).attr('id') != 'trItemFooter') {
                    var get_textbox_value = jQuery(this).closest('tr').find("#txtTestRate").val();
                    if (isNaN(get_textbox_value)) {
                        get_textbox_value = 0;
                    }
                    if (jQuery.isNumeric(get_textbox_value)) {
                        calculated_total_sum += parseFloat(get_textbox_value);
                    }
                }
            });
            
            jQuery('#txtTotalRate').val(calculated_total_sum);

        }
         </script>
    <script type="text/javascript">
        function SaveData() {
            var AllData = new Array();
            var obj = new Object();
            jQuery('#tblTestDetail tr').each(function () {
                if (jQuery(this).attr('id') != 'trItemHeader' && jQuery(this).attr('id') != 'trItemFooter') {
                    obj.TestItemId = jQuery(this).find("#tdItemID").text();
                    obj.TestCode = jQuery(this).find("#tdTestCode").text();
                    obj.Rate = jQuery(this).find("#txtTestRate").val();
                    obj.Per = jQuery(this).find("#txtTestPer").val();
                    AllData.push(obj);
                    obj = new Object();
                }
            });
            var ItemID = jQuery('#<%=lblItemID.ClientID%>').text();
            var PackageRate = jQuery('#txtTotalRate').val();
            var PRate = jQuery('#txtPackageRate').val();
            var panelid = jQuery('#<%=lstPanel.ClientID%>').val();

            if (PackageRate == "" || PackageRate == null || PackageRate == "0") {
                showerrormsg("Please Enter Total Rate");
                jQuery('#txtTotalRate').focus();
                return false;

            }
            if (PRate == "" || PRate == null || PRate == "0") {
                showerrormsg("Please Enter Package Rate");
                jQuery('#txtPackageRate').focus();
                return false;
            }
            if (jQuery('#lstPanel').val() == "null" || jQuery('#lstPanel').val() == "0") {
                showerrormsg("Please Select Panel");
                jQuery('#lstPanel').focus();
                return false;
            }
            if (PackageRate != PRate) {
                showerrormsg("Package Rate and Total Rate is Different");
                jQuery('#<%=txtPackageRate.ClientID%>').focus();
                return false;
            }
            jQuery('#btnSave').attr('disabled', true).val("Submitting...");
            jQuery.ajax({
                url: "PackageRateMaster.aspx/SaveItemWisePanelRate",
                data: JSON.stringify({ ItemID: ItemID, PackageRate: PackageRate, PRate: PRate, PanelId: panelid, Allitem: AllData }),
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Data Save Successfully");

                    }
                    else {
                        showmsg(result.d);
                    }
                    jQuery('#btnSave').attr('disabled', false).val("Save");
                },
                error: function (xhr, status) {
                    jQuery('#btnSave').attr('disabled', false).val("Save");
                }
            });                    
        }
        function BindRate() {
            jQuery.ajax({
                url: "PackageRateMaster.aspx/BindRate",
                data: '{ItemID: "' + jQuery('#<%=lblItemID.ClientID %>').html() + '",PanelID: "' + jQuery('#<%=lstPanel.ClientID %>').val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    TestData = jQuery.parseJSON(result.d);
                    if (TestData.length == 0) {
                        jQuery('#tblTestDetail tr').slice(1).remove();
                    }
                    else {                      
                        if (TestData.dt[0].prate > 0) {
                            jQuery('#txtTotalRate').val(TestData.dt[0].PackageRate);
                            jQuery('#txtPackageRate').val(TestData.dt[0].prate);
                        }
                        else {
                            jQuery('#txtTotalRate,#txtPackageRate').val("");

                        }
                        jQuery('#tblTestDetail tr').slice(1).remove();
                        for (var i = 0; i < TestData.dt.length; i++) {
                            var mydata = "<tr  id='" + TestData.dt[i].ItemID + "' class='tr_clone'>";
                            mydata += '<td class="GridViewLabItemStyle" style="text-align: left;" >' + (i + 1) + '</td>';
                            mydata += '<td id="tdItemID" class="GridViewLabItemStyle" style="text-align: left;" >' + TestData.dt[i].ItemID + '</td>';
                            mydata += '<td id="tdTestCode"  class="GridViewLabItemStyle" style="text-align: left;" >' + TestData.dt[i].testcode + '</td>';
                            mydata += '<td id="tdInvestigation" class="GridViewLabItemStyle" style="text-align: left; "  >' + TestData.dt[i].Investigation + '</td>';
                            mydata += '<td id="tdMRP" class="GridViewLabItemStyle" style="text-align: right; "  >' + TestData.dt[i].MRP + '</td>';
                            mydata += '<td id="tdMRPPer" class="GridViewLabItemStyle" style="text-align: right; "  >' + TestData.dt[i].MRPPer + ' %</td>';
                            if (TestData.dt[i].TestRate > 0) {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" class="rates" id="txtTestRate" style="width:80px;" value=' + TestData.dt[i].TestRate + ' onkeyup="calRate(this);"  ></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" class="rates" id="txtTestRate" style="width:80px;" onkeyup="calRate(this);"  ></td>';
                            }
                            if (TestData.dt[i].TestPer > 0) {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" class="ratePer" id="txtTestPer" value=' + TestData.dt[i].TestPer + ' style="width:80px;" onkeyup="calPer(this);" ></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" class="ratePer" id="txtTestPer" style="width:80px;" onkeyup="calPer(this);" ></td>';
                            }
                            mydata += '</tr>';
                            jQuery('#tblTestDetail').append(mydata);
                        }

                        var mydata = "<tr id='trItemFooter'>";
                        mydata += '<td>&nbsp;</td>';
                        mydata += '<td>&nbsp;</td>';
                        mydata += '<td>&nbsp;</td>';
                        mydata += '<td style="text-align: right;font-weight:bold">Total :</td>';
                        mydata += '<td style="text-align: right;font-weight:bold">' + TestData.totalMRP + '</td>';
                        mydata += '<td>&nbsp;</td>';
                        mydata += '<td>&nbsp;</td>';
                        jQuery('#tblTestDetail').append(mydata);
                    }                
                }
            });
        }
        function bindPanel() {
            jQuery.ajax({
                url: "PackageRateMaster.aspx/bindPanel",
                data: '{}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    panelData = jQuery.parseJSON(result.d);
                    jQuery('#<%=lstPanel.ClientID%>').append(jQuery("<option></option>").val(0).html("select"));
                    for (i = 0; i < panelData.length; i++) {
                        jQuery('#<%=lstPanel.ClientID%>').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].NAME));
                    }
                    jQuery('#<%=lstPanel.ClientID%>').val('79#79');
                    BindRate();
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
    </script>
</body>
</html>
