<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MappingStoreLocationWithMachine.aspx.cs" Inherits="Design_Store_MappingStoreLocationWithMachine" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

     
     <div id="Pbody_box_inventory" style="width:1304px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Mapping Location With Machine</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>

         <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
                <div class="Purchaseheader">Location Details</div>
                 <table width="99%">
                                       
                                        <tr>
                                            <td >CentreType:&nbsp;
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                                            </td>


                                            <td >Zone :&nbsp;
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="440px" ClientIDMode="Static" onchange="bindState($(this).val())"></asp:ListBox>
                                            </td>



                                        </tr>
                                        <tr>
                                            <td >State :&nbsp;
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" Width="440px" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                                            </td>


                                            <td >Centre :&nbsp;
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" onchange="bindlocation()"></asp:ListBox>
                                            </td>
                                        </tr>


                                        <tr>
                                            <td >Location :</td>
                                            <td>
                                                <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                            </td>


                                            <td >&nbsp;</td>
                                            <td>
                                                &nbsp;</td>
                                        </tr>


                                    </table>
                    
               </div>
              </div>

         <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
                <div class="Purchaseheader">
                      Machine Detail</div>
            
                                    <table width="99%">
                                     
                                        <tr> 
                                            <td>Machine:
                                            </td>
                                            <td>
                                                <asp:ListBox ID="lstmachine" CssClass="multiselect " SelectionMode="Multiple" Width="440px" runat="server" ClientIDMode="Static" ></asp:ListBox>
                                            </td> 
                                            <td >
                                            </td>
                                            <td>
                                               
                                            </td> 
                                        </tr>
                                        </table>
               </div>
             </div>

          <div class="POuter_Box_Inventory" style="width:1300px; text-align:center;">
               <div class="content">
                   <input type="button" value="Save" class="savebutton" onclick="SaveData();" id="btnsave" />
                   <input type="button" value="Reset" class="resetbutton" onclick="Refresh();" />
                   <input type="button" value="Search" class="searchbutton" onclick="SearchRecords()" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
                   <input type="button" value="Export To Excel" class="searchbutton" onclick="ExportToExcel()" />
                   
                   </div>
               </div>

           <div  style="width:1295px; height:200px;overflow:scroll;">
                   <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        
                                        <td class="GridViewHeaderStyle">Centre</td>
                                        <td class="GridViewHeaderStyle">Location</td>
                                        <td class="GridViewHeaderStyle">Machine</td>
                                     
                                        <td class="GridViewHeaderStyle" width="120px"><input type="checkbox" onclick="call()" id="hd" />&nbsp;&nbsp;<input onclick="    DeleteRows()" type="button" value="Delete" style="cursor:pointer;background-color:pink; font-weight: 700;" /></td>
                                     </tr>
                                 </table></div>
         </div>



    <script type="text/javascript">
        $(function () {
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            
          
            $('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=lstlocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstmachine]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindmachine();
            bindcentertype();
            bindZone();

        });
    </script>

    <script type="text/javascript">
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            $.ajax({
                url: "MappingStoreItemWithCentre.aspx/bindcentertype",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    typedata = jQuery.parseJSON(result.d);
                    for (var a = 0; a <= typedata.length - 1; a++) {
                        jQuery('#lstCentreType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));
                    }

                    jQuery('[id*=lstCentreType]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            $.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZone",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    BusinessZoneID = jQuery.parseJSON(result.d);
                    for (i = 0; i < BusinessZoneID.length; i++) {
                        jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                    }
                    $('[id*=lstZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });


                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                jQuery.ajax({
                    url: "MappingStoreItemWithCentre.aspx/bindState",
                    data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        stateData = jQuery.parseJSON(result.d);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id*=lstState]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });


                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
            bindCentre();
        }

        function bindCentre() {
            var StateID = jQuery('#lstState').val();
            var TypeId = jQuery('#lstCentreType').val();
            var ZoneId = jQuery('#lstZone').val();
            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");
            if (TypeId != "") {
                jQuery.ajax({
                    url: "MappingStoreItemWithCentre.aspx/bindCentre",
                    data: '{ZoneId: "' + ZoneId + '",StateID: "' + StateID + '",TypeId: "' + TypeId + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var centreData = jQuery.parseJSON(result.d);
                        for (i = 0; i < centreData.length; i++) {
                            jQuery("#lstCentre").append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                        }
                        $('[id*=lstCentre]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }

            bindlocation();
        }

        function bindlocation() {
            var centreid = jQuery('#lstCentre').val();
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");

            jQuery.ajax({
                url: "MappingStoreItemWithCentre.aspx/bindlocation",
                data: '{centreid: "' + centreid + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstlocation").append(jQuery("<option></option>").val(centreData[i].LocationID).html(centreData[i].Location));
                    }
                    $('[id*=lstlocation]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });

        }


        function bindmachine() {
           
            jQuery('#<%=lstmachine.ClientID%> option').remove();
            jQuery('#lstmachine').multipleSelect("refresh");

            jQuery.ajax({
                url: "MappingStoreLocationWithMachine.aspx/bindmachine",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstmachine").append(jQuery("<option></option>").val(centreData[i].ID).html(centreData[i].NAME));
                    }
                    $('[id*=lstmachine]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });

        }
       
        
    </script>



    <script type="text/javascript">
        function SaveData() {

            
            if ((JSON.stringify($('#lstmachine').val()) == '[]')) {
                showerrormsg("Please Select Machine");
                $('#lstmachine').focus();
                return;
            }
            if ((JSON.stringify($('#lstCentreType').val()) == '[]')) {
                showerrormsg("Please Select Centre Type");
                $('#lstCentreType').focus();
                return;
            }
            if ((JSON.stringify($('#lstlocation').val()) == '[]')) {
                showerrormsg("Please Select Location");
                $('#lstlocation').focus();
                return;
            }

            var Machine = $("#lstmachine").val();
            var Centres = $('#lstlocation').val();

            $.ajax({
                url: "MappingStoreLocationWithMachine.aspx/SaveData",
                data: JSON.stringify({ Machines: Machine, Centres: Centres }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Machine Mapped Successfully");
                        Refresh();
                        SearchRecords();
                    }
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });
        }


        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>

    <script type="text/javascript">

        function SearchRecords() {

            var Machine = $("#lstlocation").val();
            var location = $('#lstlocation').val();
            $('#tblitemlist tr').slice(1).remove();

            $.ajax({
                url: "MappingStoreLocationWithMachine.aspx/SearchData",
                data: JSON.stringify({ Machine: JSON.stringify(Machine), location: JSON.stringify(location) }),
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        $.unblockUI();
                       

                    }
                    else {
                        
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:palegreen;' id='" + ItemData[i].mapid + "'>";


                            mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "</td>";
                            mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].Centre + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].Location + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].MachineName + '</td>';
                           
                            mydata += '<td class="GridViewLabItemStyle" align="left"><input type="checkbox" class="mmchk"  id="' + ItemData[i].mapid + '"/></td>';





                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                        }
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }


        function call() {

            if ($('#hd').prop('checked') == true) {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        $(this).closest("tr").find('.mmchk').prop('checked', true);

                    }
                });
            }
            else {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        $(this).closest("tr").find('.mmchk').prop('checked', false);

                    }
                });
            }
        }



        function DeleteRows() {

            var data = '';
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {

                    if ($(this).closest("tr").find('.mmchk').prop('checked') == true) {
                        data = data + "," + id;
                    }
                }
            });


            if (data == '') {
                showerrormsg("Please Select Record.");
                return;
            }

            jQuery.ajax({
                url: "MappingStoreLocationWithMachine.aspx/DeleteRows",
                data: JSON.stringify({ Id: data.substr(1, data.length - 1) }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Record Deleted successfully");
                        SearchRecords();
                        $(':checkbox').prop('checked', false);
                    }
                },
                error: function (xhr, status) {
                    alert('Error...');
                }
            });



        }
        function Refresh() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");

            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");

            jQuery('#<%=lstCentre.ClientID%> option').remove();
            jQuery('#lstCentre').multipleSelect("refresh");

            

            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");

            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");

           
            jQuery('#lstmachine').multipleSelect("refresh");

            $(':checkbox').prop('checked', false);
           
            bindcentertype();
            bindZone();
            $('#tblitemlist tr').slice(1).remove();
           
        }



        function ExportToExcel() {
            var Machine = $("#lstlocation").val();
            var location = $('#lstlocation').val();
            $.ajax({
                url: "MappingStoreLocationWithMachine.aspx/ExportToExcel",
                data: JSON.stringify({ Machine: JSON.stringify(Machine), location: JSON.stringify(location) }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {
                        showerrormsg("No Record Found..!");
                    }
                }
            });
        }
    </script>
</asp:Content>

