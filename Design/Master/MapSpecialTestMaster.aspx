<%@ Page Title="" Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MapSpecialTestMaster.aspx.cs" Inherits="Design_Master_MapSpecialTestMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
      
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
        <%: Scripts.Render("~/bundles/handsontable") %>
   <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
<style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>
    <style type="text/css">
        .compareRate {
            background-color: #90EE90;
        }
    </style>
     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

    <div id="Pbody_box_inventory" ">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
           </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Mapping Special Test Master<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"  />
              
        </div>
        
    <div class="POuter_Box_Inventory" style="text-align: left;">
              <div class="Purchaseheader">
                Manage Item
            </div>
            <table style="width: 100%;border-collapse:collapse">
               <tr>
                   <td style="text-align:right;width:20%">
                       Business Zone :&nbsp;
                   </td>
                   <td style="text-align:left;width:30%">
                       <asp:DropDownList ID="ddlBusinessZone" runat="server" Width="170px" onchange="bindState()"></asp:DropDownList>
                   </td>
                    <td style="text-align:right;width:20%">
                       State :&nbsp;
                   </td>
                   <td style="text-align:left;width:30%">
                       <asp:DropDownList ID="ddlState" runat="server" Width="170px" onchange="bindCity()"></asp:DropDownList>
                   </td>
               </tr>
               <tr>
                   <td style="text-align:right;width:20%">
                       City :&nbsp;
                   </td>
                  <td style="text-align:left;width:30%">
                       <asp:DropDownList ID="ddlCity" runat="server" Width="170px" onchange="bindPanel()"></asp:DropDownList>
                   </td>
                    <td style="text-align:right;width:20%">
                     Panel :&nbsp;
                   </td>
                    <td style="text-align:left;width:30%">
                      
                        <asp:ListBox ID="lstPanel" runat="server"  CssClass="multiselect"   SelectionMode="Multiple" Width="260px"></asp:ListBox>
                   </td>
               </tr>
                <tr>
                    <td colspan="4" style="text-align:center">
                        <input type="button" id="btnSearch" onclick="search()" value="Search"  class="ItDoseButton"/>&nbsp;&nbsp;
                        <input type="button" id="btnApprovalSearch" onclick="ApprovalSearch()" value="Approval Search"  class="ItDoseButton" style="display:none"/>
                    </td>
                </tr>
                </table>
              
        </div>
         <div class="POuter_Box_Inventory" style="text-align: left;">
        
              <div id="divTestDetail" style="overflow:auto; height:400px"></div>  
             
              </div>
         <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="div_Save">
              <input type="button" id="btnSave" onclick="saveSpecialTest()" value="Save"  class="ItDoseButton"/>&nbsp;&nbsp;
             <input type="button" id="btnApprove" onclick="approveSpecialTest()" value="Approve"  class="ItDoseButton"/>
             </div>
    </div>
    <script type="text/javascript">

        $(function () {
            $('[id*=lstPanel]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }

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
        function bindState() {
            jQuery("#lblMsg").text('');
            jQuery("#ddlState option").remove();
            jQuery("#ddlCity option").remove();
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            $('#lstPanel').multipleSelect("refresh");
            CommonServices.bindState(jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
        }
        function onSucessState(result) {
            var stateData = jQuery.parseJSON(result);
            if (stateData.length == 0) {
                jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
                jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < stateData.length; i++) {
                    jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                }
                
            }
        }
        function onFailureState() {

        }
        function bindCity() {
            jQuery("#ddlCity option").remove();
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            $('#lstPanel').multipleSelect("refresh");
            CommonServices.bindCity(jQuery("#ddlState").val(), onSucessCity, onFailureCity)
        }
        function onSucessCity(result) {
            var cityData = jQuery.parseJSON(result);
            if (cityData.length == 0) {
                jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
                jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("Select"));
                for (i = 0; i < cityData.length; i++) {
                    jQuery("#ddlCity").append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                }

            }
        }
        function onFailureCity() {

        }
        function bindPanel() {

            PageMethods.bindPanel($("#ddlBusinessZone").val(), $("#ddlState").val(), $("#ddlCity").val(), onSuccessPanel, OnfailurePanel);
        }
        function onSuccessPanel(result) {
            var panelData = jQuery.parseJSON(result);
            if (panelData.length == 0) {
                jQuery("#lstPanel").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }


            for (i = 0; i < panelData.length; i++) {
                jQuery('#<%=lstPanel.ClientID%>').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
        }
        $('[id*=lstPanel]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });

    }
    function OnfailurePanel() {

    }
    </script>
    <script type="text/javascript">

        var testDetail="";
        function search() {
            jQuery("#lblMsg").text('');
            if (jQuery("#ddlBusinessZone").val() == 0) {
                showerrormsg('Please Select Business Zone');
                jQuery("#ddlBusinessZone").focus();
                return;
            }
            if (jQuery("#ddlState").val() == 0) {
                showerrormsg('Please Select State');
                jQuery("#ddlState").focus();
                return;
            }
            if (jQuery("#ddlCity").val() == 0) {
                showerrormsg('Please Select City');
                jQuery("#ddlCity").focus();
                return;
            }           
            var panelCount = 0;
            jQuery('#lstPanel :selected').each(function (i, selected) {
            
                panelCount += 1;
            });

            if (panelCount == 0) {
                showerrormsg('Please Select Panel');
                return;
            }
            jQuery("#btnSearch").attr('disabled', 'disabled').val('Searching...');
            var PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
            searchType = 0;
            PageMethods.getSpecialTest(PanelID, 1, onSuccessTest, OnfailureTest);

        }
        
        var colList; var searchType=0;
        function onSuccessTest(result) {
            jQuery("#lblMsg").text('');
            jQuery("#div_Save").show();
            testDetail = jQuery.parseJSON(result);           
            var container1 = document.getElementById('divTestDetail');
            $(container1).html('');
            colList = Object.keys(testDetail[0]);
            
            hot3 = new Handsontable(container1, {
                data: testDetail,
                stretchH: 'all',
                autoWrapRow: true,
                rowHeaders: true,
                colHeaders: colList,
                cells: function (row, col, prop) {
                    var cellProperties = {};                                        
                    cellProperties.renderer = chkBlankValue; // uses lookup map
                    return cellProperties;
                },
                beforeChange: function (change, source) {
                    var cellProperties = {};
                    updateItem(change, source);                                   
                    return cellProperties;
                },
                afterRender: function () {
                    render_color(this);
                },
                afterChange: function (changes, data) {
                    if (!changes) {
                        return;
                    }
                   // var instance = hot3;
                    //$.each(changes, function (index, element) {
                    //    var change = element;
                        

                    //    var row = changes[0][0];
                    //    var col = colList.indexOf(changes[0][1]);                      
                    //    var cell = hot3.getCell(row, col);
                    //    var foreColor = 'black';
                    //    var backgroundColor = 'white';
                        
                    //    if (hot3.getData()[row][col] < hot3.getData()[row][2]) {                                                     
                    //         foreColor = 'white';
                    //         backgroundColor = 'red';
                            
                    //    }

                    //    cell.style.color = foreColor;
                    //    cell.style.background = backgroundColor;
                    //});
                    render_color(this);
                }               
            });
           
            hot3.updateSettings({
                cells: function (row, col, prop) {
                    var cellProperties = {};                  
                    if (col < 3) {
                        cellProperties.readOnly = true;                       
                    }
                    if (col > 2) {
                        cellProperties.type = 'numeric';
                        cellProperties.format = '0.00';                       
                    }                    
                    return cellProperties;
                }
            })
            hot3.render();

            $("#btnSearch").removeAttr('disabled').val('Search');
            if($("#btnApprovalSearch").is(":visible"))
                $("#btnApprovalSearch").removeAttr('disabled').val('Approval Search');
            if (searchType == 1) {
                jQuery("#btnSave").hide();
                jQuery("#btnApprove").show();
            }
            else if (searchType == 0) {
                jQuery("#btnSave").show();
                jQuery("#btnApprove").hide();
            }
           
        }
        function chkBlankValue(instance, td, row, col, prop, value, cellProperties) {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            
            if (value == null) {
                cellProperties.readOnly = 'true'
            }
            return td;
        }
        function render_color(ht) {
            for (var i = 0; i < ht.countRows() ; i++) {
                for (var p = 2; p < ht.countCols() ; p++) {                   
                    var cell = ht.getCell(i, p);
                    var foreColor = 'black';
                    var backgroundColor = 'white';                  
                    if (searchType == 1) {
                        if (ht.getData()[i][p] == "" || ht.getData()[i][p] == null) {
                            cell.style.display = 'none';
                        }
                    }
                    if (ht.getData()[i][p] < ht.getData()[i][2]) {
                        foreColor = 'white';
                        backgroundColor = 'red';
                    }                 
                    cell.style.color = foreColor;
                    cell.style.background = backgroundColor;
                }
            }
        }
        function OnfailureTest() {
            $("#btnSearch").removeAttr('disabled').val('Search');
        }
        var dataItem = new Array();
        var ObjItem = new Object();
        function updateItem(change, source) {
           
            var row = change[0][0]; 
           
           
            ObjItem.ItemID = testDetail[row].ItemID;
            ObjItem.RateBasic = testDetail[row].Rate;
            // ObjItem.Panel_ID = change[0][1].split('#')[1];
            ObjItem.Panel_ID = change[0][1].substring(change[0][1].lastIndexOf('#')).replace('#', '');
            ObjItem.Rate = change[0][3];



            if (change[0][3] != "") {
                //var found = jQuery.inArray(newFilter, filters);
                //if (found >= 0) {

                //    filters.splice(found, 1);
                //} else {
                //    // Element was not found, add it.
                //    filters.push(newFilter);
                //}

                dataItem.push(ObjItem);
                ObjItem = new Object();
            }
            
            
        }
    </script>
    <script type="text/javascript">
        function saveSpecialTest() {
            jQuery("#lblMsg").text('');
            if (dataItem.length == 0) {
                showerrormsg('Please Change Test Rate');
                return;
            }
            jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
            
            PageMethods.saveSpecialTest(dataItem, onSuccess, Onfailure);

        }
        function onSuccess(result) {
            jQuery("#btnSave").removeAttr('disabled').val('Save');
            if (result == 1) {
                showerrormsg('Record Saved Successfully');

                dataItem.splice(0, dataItem.length);
                clearData();

            }
            else {
                jQuery("#lblMsg").text('Error');
            }
        }
        function Onfailure() {
            jQuery("#btnSave").removeAttr('disabled').val('Save');
            jQuery("#lblMsg").text('Error');
        }
        function clearData() {
            jQuery("#ddlBusinessZone").prop('selectedIndex', 0);
            jQuery("#ddlState option").remove();
            jQuery("#ddlCity option").remove();
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            jQuery("#div_Save").hide();
            jQuery('#divTestDetail').html('');
        }
    </script>
       <script type="text/javascript">
           $(function () {
               chkApprovalRight();
           });
           function chkApprovalRight() {             
               PageMethods.approvalRight(onSuccessAppRight, OnfailureAppRight);
           }
           function onSuccessAppRight(result) {
               if (result == 1) {
                   jQuery("#btnApprovalSearch").show();
               }
               else {
                   jQuery("#btnApprovalSearch").hide();
               }
           }
           function OnfailureAppRight() {

           }
           function ApprovalSearch() {
               searchType = 1;
               $("#btnApprovalSearch").attr('disabled', 'disabled').val('Searching...');
               var PanelID = $('#lstPanel').multipleSelect("getSelects").join();
               PageMethods.getSpecialTest(PanelID, 0, onSuccessTest, OnfailureTest);
           }

           function approveSpecialTest() {
              

               jQuery("#lblMsg").text('');
               if (dataItem.length == 0) {
                   showerrormsg('Please Change Test Rate');
                   return;
               }
               jQuery("#btnApprove").attr('disabled', 'disabled').val('Submitting...');

               PageMethods.approveSpecialTest(dataItem, onSuccessApproval, OnfailureApproval);

           }
           function onSuccessApproval(result) {
               jQuery("#btnApprove").removeAttr('disabled').val('Approve');
               if (result == 1) {
                   showerrormsg('Record Saved Successfully');

                   dataItem.splice(0, dataItem.length);
                   clearData();

               }
               else {
                   jQuery("#lblMsg").text('Error');
               }
           }
           function OnfailureApproval() {
               jQuery("#btnApprove").removeAttr('disabled').val('Approve');
               jQuery("#lblMsg").text('Error');
           }
       </script>
</asp:Content>

