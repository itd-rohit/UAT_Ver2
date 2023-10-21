<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SuggestedItemMaster.aspx.cs" Inherits="Design_Lab_SuggestedItemMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>      
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <center>
                <asp:Label ID="llheader" runat="server" Text="Promotional Test Master" Font-Size="16px" Font-Bold="true"></asp:Label></center>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">

                Suggest Test Master
            </div>
            <div class="row" style="margin-top: 0px;">
              
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Business Zone</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>

                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">State</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox onchange="bindtagprocessingtab()" ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Type</label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <asp:ListBox ID="lstType" CssClass="multiselect" SelectionMode="Multiple" runat="server"  onchange="$bindCenterData()"></asp:ListBox>
                        </div>
                    </div>
              

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Tag Processing Lab</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="lstTagprocessingLab" class="lstTagprocessingLab chosen-select" runat="server" ClientIDMode="Static" onchange="$bindCenterData()"></asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Centre</label>
                        <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-5">
                        <asp:ListBox ID="ddlCentreSuggested" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="BindSuggestionTest()"></asp:ListBox>
                    </div>
                    <div class="col-md-8">
                    </div>
                </div>


                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Test</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlTest" runat="server" onchange="BindSuggestionTest();" class="ddlTest chosen-select"></asp:DropDownList>

                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Promotional Test</label>
                        <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-5">
                        <asp:ListBox ID="lstSuggestTest" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </div>
                    <div class="col-md-8">
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <input type="button" id="btnSave" value="Save" onclick="existingdata();" tabindex="9" class="savebutton" />
            <input type="button" value="Cancel" onclick=" clearForm();" class="resetbutton" />
            <input type="button" value="Export To Exccel" onclick="exporttoexcel();" class="searchbutton" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Suggestion Test Detail
            </div>
            <div style="width: 99%; max-height: 375px; overflow: auto;">
                <table id="tblItemList" style="width: 99%; border-collapse: collapse; text-align: left;">
                    <tr id="trIteHeader">
                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                        <td class="GridViewHeaderStyle">Centre Name</td>
                        <td class="GridViewHeaderStyle">Test Name</td>
                        <td class="GridViewHeaderStyle">Suggestion Test Name</td>
                        <td class="GridViewHeaderStyle">Create By</td>
                        <td class="GridViewHeaderStyle">Create Date</td>
                        <td class="GridViewHeaderStyle">Remove</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">       
        function bindtable() {                    
            $('#tblItemList tr').slice(1).remove();
            serverCall('SuggestedItemMaster.aspx/bindtableData', { centreid: $('#ddlCentreSuggested').val(), testid: $('#ddlTest').val() }, function (response) {
              var  $responseData = JSON.parse(response);
              if ($responseData != null) {
                  for (var i = 0; i <= $responseData.length - 1; i++) {
                      var $mydata = [];
                      $mydata.push("<tr style='background-color:lightyellow; id='");                    
                      $mydata.push($responseData[i].id );
                      $mydata.push("'>");
                      $mydata.push('<td  id="itemid" style="display:none;">');
                      $mydata.push($responseData[i].ID);
                      $mydata.push('</td><td class="GridViewLabItemStyle" >');
                      $mydata.push(parseInt(i + 1));
                      $mydata.push('</td><td class="GridViewLabItemStyle" >');
                      $mydata.push($responseData[i].centre);
                      $mydata.push('</td><td class="GridViewLabItemStyle" >');
                      $mydata.push($responseData[i].TestName);
                      $mydata.push('</td>');
                      $mydata.push('<td class="GridViewLabItemStyle" >');
                      $mydata.push($responseData[i].SuggestTestName);
                      $mydata.push('</td><td class="GridViewLabItemStyle" >');
                      $mydata.push($responseData[i].CreateBy);
                      $mydata.push('</td><td class="GridViewLabItemStyle" >');
                      $mydata.push($responseData[i].CreatedDate);
                      $mydata.push('</td><td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>');
                      $mydata.push("</tr>");
                      $mydata = $mydata.join("");
                      jQuery('#tblItemList').append($mydata);
                  }
              }
            });
        }
        function deleterow(itemid) {
            var table = document.getElementById('tblItemList');
            var r = confirm("Are you sure Remove this item !!");
            if (r == true) {
                $("tr").click(function () {
                    var txt = $(this).find("td").first().text();
                    serverCall('SuggestedItemMaster.aspx/removerow', { id: txt}, function (response) {
                        var  $responseData = JSON.parse(response);
                        if ($responseData.status) {
                            toast("Success", $responseData.response, "");
                        }
                        else{
                            toast("Error", $responseData.response, "");
                        }                   
                    });
                });
                table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                $('td.order').text(function (i) {             
                    return i + 1;
                });
            } else {
                return false;
            }
        }

    </script>
    <script type="text/javascript">
        $(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            bindtable();
        });
        function Savedata() {
            if ($('#ddlCentreSuggested').val() == "0") {
                toast("Error", "Please Select Centre", "");
                return;
            }
            if ($('#ddlTest').val() == "0") {
                toast("Error", "Please Select Test", "");
                return;
            }
            if (jQuery('#lstSuggestTest').val() == "") {
                toast("Error", "Please Select Promotional", "");
                return;
            }
            $("#btnSave").attr('disabled', true).val("Submiting...");

            serverCall('SuggestedItemMaster.aspx/Savesuggesttest', { centreid: $('#ddlCentreSuggested').val(), TestId: $('#ddlTest').val(), SuggestedId: jQuery('#lstSuggestTest').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {                   
                    clearForm();
                    toast("Success", $responseData.status, "");
                }
                else
                {
                    toast("Error", $responseData.status, "");              
                }
                $('#btnSave').attr('disabled', false).val("Save");
            });           
        }
        function clearForm() {
            $('#ddlTest').prop('selectedIndex', 0);
            $("#ddlTest").trigger('chosen:updated');
            jQuery('#lstZone option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            jQuery('#lstState option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            jQuery('#lstType option').remove();
            jQuery('#lstType').multipleSelect("refresh");
            jQuery('#lstTagprocessingLab option').remove();
            $("#lstTagprocessingLab").trigger('chosen:updated');
            bindZone();
            bindtype();
            jQuery('#ddlCentreSuggested option').remove();
            jQuery('#ddlCentreSuggested').multipleSelect("refresh");
            jQuery('#lstSuggestTest').val("");
            jQuery('#lstSuggestTest').multipleSelect("refresh");
            bindtable();
        }
        function existingdata() {
            var TestId = $('#ddlTest').val();
            if ((JSON.stringify($('#ddlCentreSuggested').val()) == '[]')) {
                toast("Error", "Please Select Centre", "");
                $('#lstSuggestTest').focus();
                return;
            }
            if (TestId == "0") {
                toast("Error", "Please Select Test", "");
                return;
            }
            if ((JSON.stringify($('#lstSuggestTest').val()) == '[]')) {
                toast("Error", "Please Select suggestion Test", "");
                $('#lstSuggestTest').focus();
                return;
            }
            serverCall('SuggestedItemMaster.aspx/Savesuggesttest', { centreid: jQuery('#ddlCentreSuggested').val(), TestId: $('#ddlTest').val(), SuggestedId: jQuery('#lstSuggestTest').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.length == 0) {
                    Savedata();
                }
                else {
                    var r = confirm("These Test are already Exist !! do you want to remove ??");
                    if (r == true) {
                        removemultipledata();
                        Savedata();
                    } else {
                        clearForm();
                        toast("Error", "Please Remove Existing Test", "");
                    }
                }
            });           
        }   
        function removemultipledata() {
            serverCall('SuggestedItemMaster.aspx/updatemultiRecords', { TestId: $('#ddlTest').val(), SuggestedId: jQuery('#lstSuggestTest').val(), centreid: jQuery('#ddlCentreSuggested').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.status, "");
                }
                else {
                    toast("Error", $responseData.status, "");
                }
            });
        }

    </script>
    <script type="text/javascript">
        $(function () {
            $('[id=lstSuggestTest]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=ddlCentreSuggested]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=ddlCentreSuggested]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindZone();
            bindtype();
        });
    </script>
    <script type="text/javascript">
        function bindZone() {
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {  }, function (response) {
                var $responseData = JSON.parse(response);
                for (i = 0; i < $responseData.length; i++) {
                    jQuery('#lstZone').append($("<option></option>").val($responseData[i].BusinessZoneID).html($responseData[i].BusinessZoneName));
                }
                $('[id*=lstZone]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });          
        }
        $('#lstZone').on('change', function () {
            jQuery('#lstState option').remove();
            jQuery('#ddlCentreSuggested option').remove();
            jQuery('#ddlCentreSuggested option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            jQuery('#ddlCentreSuggested').multipleSelect("refresh");
            var BusinessZoneID = $(this).val(); 
            bindBusinessZoneWiseState($.parseJSON(JSON.stringify(BusinessZoneID)).join(","));
        });
        function bindBusinessZoneWiseState(BusinessZoneID) {
            if (BusinessZoneID != "") {
                serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    var $responseData = JSON.parse(response);
                    for (i = 0; i < $responseData.length; i++) {
                        jQuery("#lstState").append(jQuery("<option></option>").val($responseData[i].ID).html($responseData[i].State));
                    }
                    jQuery('[id*=lstState]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });            
            }
        }
        function bindtype() {
            serverCall('SuggestedItemMaster.aspx/bindtypedb', {  }, function (response) {
                var $responseData = JSON.parse(response);
                for (var a = 0; a <= $responseData.length - 1; a++) {
                    $('#lstType').append($("<option></option>").val($responseData[a].ID).html($responseData[a].TEXT));
                }
                $('[id*=lstType]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });          
        }
        function bindtagprocessingtab() {
            var btype = "0";
            jQuery('#lstTagprocessingLab option').remove();
            $("#lstTagprocessingLab").trigger('chosen:updated');
            jQuery('#ddlCentreSuggested option').remove();
            jQuery('#ddlCentreSuggested').multipleSelect("refresh");
            var StateID = jQuery('#lstState').val();
         
            var ZoneId = jQuery('#lstZone').val();
            serverCall('SuggestedItemMaster.aspx/bindtagprocessinglabLoad', { btype:btype,StateID:StateID,ZoneId:ZoneId }, function (response) {
                var $responseData = JSON.parse(response);
                jQuery('#lstCentreLoadList').html('');
                var CenterData = '';
                jQuery("#lstTagprocessingLab").append(jQuery('<option></option>').val("-1").html("Select"));
                jQuery("#lstTagprocessingLab").append(jQuery('<option></option>').val("0").html("ALL"));
                for (i = 0; i < $responseData.length; i++) {
                    CenterData += $responseData[i].CentreID + ',';
                    jQuery("#lstTagprocessingLab").append(jQuery('<option></option>').val($responseData[i].CentreID).html($responseData[i].Centre));
                }
                CenterData = CenterData.substring(0, CenterData.length - 1);
                $("#lstTagprocessingLab").trigger('chosen:updated');         
            });
        }
        function $bindCenterData() {
            var btype = "0";
            jQuery('#ddlCentreSuggested option').remove();
            jQuery('#ddlCentreSuggested').multipleSelect("refresh");
            var StateID = jQuery('#lstState').val();
            var TypeId = jQuery('#lstType').val();
            var ZoneId = jQuery('#lstZone').val();

            serverCall('SuggestedItemMaster.aspx/bindCentreLoad', { Type1:TypeId,btype:btype,StateID:StateID,ZoneId:ZoneId,tagprocessinglab:jQuery('#lstTagprocessingLab').val() }, function (response) {
                var $responseData = JSON.parse(response);

                jQuery('#lstCentreLoadList').html('');
                var CenterData = '';
                for (i = 0; i < $responseData.length; i++) {
                    CenterData += $responseData[i].CentreID + ',';
                    jQuery("#ddlCentreSuggested").append(jQuery('<option></option>').val($responseData[i].CentreID).html($responseData[i].Centre));
                }
                CenterData = CenterData.substring(0, CenterData.length - 1);
                jQuery('[id*=ddlCentreSuggested]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });          
            });
        }
    </script>
    <script type="text/javascript">
        function BindSuggestionTest() {
            bindtable();
        }
        function exporttoexcel() {          
            serverCall('SuggestedItemMaster.aspx/exportdatatoexcel', { centreid: $('#ddlCentreSuggested').val(), testid: $('#ddlTest').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if($responseData.status)
                {
                    window.open('../Common/exporttoexcel.aspx');
                }
                else{
                    toast("Error", "No Item Found", "");
                }          
            });
        }
    </script>
</asp:Content>


