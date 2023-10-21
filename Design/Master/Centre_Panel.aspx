<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Centre_Panel.aspx.cs" Inherits="Design_Master_Centre_Panel" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
       <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <title>Centre Panel</title>
</head>
<body>
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
     <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Label ID="lblHeder" Font-Bold="true" runat="server"></asp:Label>
                <asp:Label ID="lblCentreID" Style="display: none" runat="server" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left">Client   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <asp:ListBox ID="lstPanelLoadList" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                            </div>
                            <div class="col-md-5 ">
                                &nbsp;
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="SaveCentrePanel()" />
                <input type="button" id="btnSaveOrder" value="Save Client Order" class="ItDoseButton" onclick="SaveOrder()" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row"><input type="text" id="txtClient" data-title="Enter Client Name/Code" onkeyup="bindCentrePanellDetail('');" /></div>
                
            <div id="divCentre"  style="max-height: 800px; overflow-y: auto; overflow-x: hidden;">
                
            </div>
 </div>
        </div>
    </form>
    <script type="text/javascript">
        $(function () {
            $("#Pbody_box_inventory").css('margin-top', 0);
            $('[id*=lstPanelLoadList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            loadPanel();
          
            bindCentrePanellDetail($("#lblCentreID").text());
        });
        function SaveCentrePanel() {
            $("#btnSave").attr('disabled', 'disabled').val('Submitting...');
            var ItemData = '';
            var SelectedLaength = $('#lstPanelLoadList').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                ItemData += $('#lstPanelLoadList').multipleSelect("getSelects").join().split(',')[i] + '#';
            }
            if (ItemData == "#") {
                alert('Please Select Panel');
                $("#btnSave").removeAttr('disabled').val('Save');
                return;
            }
             jQuery.ajax({
                url: "Centre_Panel.aspx/saveCentrePanel",
                data: '{ CentreID:"' + $("#lblCentreID").text() + '",ItemData:"' + ItemData + '"}', // parameter map 
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    if (mydata.d == '1') {
						debugger;
                        $("[id*=lstPanelLoadList] option").remove();
                        loadPanel();
                        bindCentrePanellDetail('');
                        alert('Record Saved Successfully');
                        $("#btnSave").removeAttr('disabled').val('Save');
                        window.close();
                    }
                    else {
                        alert('Error..');
                        $("#btnSave").removeAttr('disabled').val('Save');
                    }

                },
                error: function (xhr, status) {
                    $("#btnSave").removeAttr('disabled').val('Save');
                }
            });          
        }
    </script>
    <script type="text/javascript">
        function bindCentrePanel() {         
            serverCall('Centre_Panel.aspx/bindCentrePanel', { CentreID: $("#lblCentreID").text() }, function (response) {
                var selectedPanelData = jQuery.parseJSON(response);
                if (selectedPanelData.length > 0) {
                    for (var i = 0; i < selectedPanelData.length; i++) {
                        $('#lstPanelLoadList').find(":checkbox[value='" + selectedPanelData[i].PanelId + "']").attr("checked", "checked");
                        $("[id*=lstPanelLoadList] option[value='" + selectedPanelData[i].PanelId + "']").attr("selected", 1);
                        $('#lstPanelLoadList').multipleSelect("refresh");
                    }
                }
            });
            
        }
       
        function loadPanel() {
            serverCall('Centre_Panel.aspx/bindPanel', { CentreID: $("#lblCentreID").text() }, function (response) {
                var PanelLoadData = jQuery.parseJSON(response);
                for (i = 0; i < PanelLoadData.length; i++) {
                    jQuery('#lstPanelLoadList').append($("<option></option>").val(PanelLoadData[i].Panel_ID).html(PanelLoadData[i].Company_Name));
                }
                $('[id*=lstPanelLoadList]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
               // bindCentrePanel();
            });          
        }
        bindCentrePanellDetail = function (centreID) {
            if (centreID == '') centreID = $("#lblCentreID").text();

            serverCall('Centre_Panel.aspx/bindCentrePanelDetail', { centreID: centreID,Panel:$('#txtClient').val() }, function (response) {
                var responseDetail = JSON.parse(response);
                bindCentreClient(responseDetail);
            });
        }
        bindCentreClient = function (responseDetail) {
            $("#divCentre").empty();
            var $table = [];
            $table.push("<table id='tbSelected' rules='all' border='1' style='border-collapse: collapse; width: 100%;' class='GridViewStyle'><tr id='Header'> <th class='GridViewHeaderStyle' style='width:20px; ' scope='col'>S.No.</th> <th class='GridViewHeaderStyle' style='width:100px;'>Client Code</th><th class='GridViewHeaderStyle' style='width:300px;'>Client Name</th><th class='GridViewHeaderStyle' style='width:40px;'>Remove</th></tr><tbody>");
            for (var i = 0; i < responseDetail.length ; i++) {
                var $Tr = [];
                $Tr.push("<tr>");
                $Tr.push('<td class="GridViewLabItemStyle">');
                $Tr.push((i + 1)); $Tr.push("</td>");
                $Tr.push('<td style="text-align:left">');
                $Tr.push(responseDetail[i].Panel_Code); $Tr.push("</td>");
                $Tr.push('<td id="tdClientName" style="text-align:left">');
                $Tr.push(responseDetail[i].Company_Name); $Tr.push("</td>");
                $Tr.push('<td id="tdID" style="text-align:left;display:none">');
                $Tr.push(responseDetail[i].ID); $Tr.push("</td>");
                $Tr.push('<td id="tdpanelID" style="text-align:left;display:none">');
                $Tr.push(responseDetail[i].panel_id); $Tr.push("</td>");
                
                $Tr.push("<td class='GridViewLabItemStyle' style='text-align:left;'>");
                $Tr.push('<img  class="btn" alt=""  src="../../App_Images/Delete.gif" onclick="$removeClient(this)"  /></td>');
                $Tr = $Tr.join("");            
                $table.push($Tr);
               
            }
            $table.push("</tbody></table>");
            $table = $table.join("");
            $("#divCentre").append($table);
            $("#tbSelected").tableDnD({
                onDragClass: "GridViewDragItemStyle",
                onDragStart: function (table, row) {
                }
            });
        }
        $removeClient = function (rowID) {
            var panelid = $(rowID).closest('tr').find("#tdpanelID").text(); 
            var ID = $(rowID).closest('tr').find("#tdID").text();
            var ClientName = $(rowID).closest('tr').find("#tdClientName").text();
            $confirmationBox("".concat('Do You want to remove?<br/>Client Name :<b>', ClientName, '</b>'), ID+"##"+ panelid);
            
        }
        $confirmationClient = function (ID) {
            serverCall('Centre_Panel.aspx/removeClient', { ID: ID.split('##')[0], centreID: $("#lblCentreID").text(), panelid: ID.split('##')[1] }, function (response) {
                var responseStatus = JSON.parse(response);
                if (responseStatus.status) {
                    toast('Success', 'Panel Unmapped Successfully');
                    var responseDetail = jQuery.parseJSON(responseStatus.responseDetail);
                    bindCentreClient(responseDetail);
                    loadPanel();
                   // bindCentrePanel();
                }
                else {
                    toast('Error', 'Error..');
                }
            });
        }
        $confirmationBox = function (contentMsg, ID) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: contentMsg,
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '480px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            $confirmationClient(ID);
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearActionClient(ID);
                        }
                    },
                }
            });
        }
        $clearActionClient = function (ID) {

        }

        SaveOrder = function () {
            var dataClient = new Array();
            var ObjClient = new Object();
            var SNo = 1;
            $("#tbSelected tr").each(function () {
                var id = $(this).closest("tr").attr("id");
                $rowid = $(this).closest('tr');
                if (id != "Header") {
                    ObjClient.SNo = SNo;
                    ObjClient.ID = $.trim($rowid.find("#tdID").text());
                    dataClient.push(ObjClient);
                    SNo = SNo + 1;
                    ObjClient = new Object();
                }              
            });
            serverCall('Centre_Panel.aspx/UpdateClientSNo', { ClientData: dataClient, centreID: $("#lblCentreID").text() }, function (response) {
                var responseStatus = JSON.parse(response);
                if (responseStatus.status) {
                    toast('Success', 'Record Updated Successfully');
                    var responseDetail = jQuery.parseJSON(responseStatus.responseDetail);
                    bindCentreClient(responseDetail);

                }
                else {
                    toast('Error', 'Error..');

                }
            });

        };
        
    </script>
</body>
</html>
