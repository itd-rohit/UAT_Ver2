<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SetQuotation.aspx.cs" Inherits="Design_Store_SetQuotation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
      <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
 <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

     <div id="Pbody_box_inventory" style="width:1304px;">
              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Set Quotation</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>

             <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td width="49%" valign="top">
                           <div class="Purchaseheader">From Location</div>
                            <table width="100%">
                                <tr>
                                    <td>Location:</td>
                                    <td>  <asp:DropDownList ID="ddllocation" runat="server" Width="480px" class="ddllocation chosen-select chosen-container" onchange="getfromrate()"></asp:DropDownList></td>

                                      <td>Machine:</td>
                                    <td> <asp:ListBox ID="ddlmachine" CssClass="multiselect" SelectionMode="Multiple" Width="200px" runat="server" onchange="getfromrate()"></asp:ListBox></td>
                                     <td>Supplier:</td>
                                    <td> <asp:ListBox ID="ddlsupplier" CssClass="multiselect" SelectionMode="Multiple" Width="300px" runat="server" onchange="getfromrate()"></asp:ListBox></td>

                                </tr>

                             

                                <tr>
                                    <td>Item:</td>
                                    <td colspan="3">  <asp:ListBox ID="ddlitem" CssClass="multiselect" SelectionMode="Multiple" Width="799px" runat="server" onchange="getfromrate()"></asp:ListBox></td>

                                     <td>&nbsp;</td>
                                    <td> &nbsp;</td>

                                </tr>

                             

                            </table>
                        </td>
                       
                      
                    </tr>

                     <tr>
                         <td  style="text-align:center;">

                             <table width="99%">
                                 <tr>
                                    <td width="40%">
                                              <table width="80%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: palegreen;"  >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Rate Set</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: white;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Rate Not Set</td>
                    
                    
                </tr>
            </table>
                                     </td>
                                       
                                       <td width="60%" align="left"> <input type="button" value="Set Quotation" class="savebutton" onclick="savenow()" />&nbsp;&nbsp; 
                                          
                                       </td>
                                       
                                 </tr>
                             </table>
                            
                         </td>
                     </tr>
                </table>
                </div>
                 </div>
           <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
               <div style="max-height:400px;overflow:auto;">
                 <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                         
                                               
                                          <td class="GridViewHeaderStyle">Supplier</td>
                                        <td class="GridViewHeaderStyle">Supplier State</td>
                                         <td class="GridViewHeaderStyle">MachineName</td>
                                         <td class="GridViewHeaderStyle">ItemID</td>
                                        <td class="GridViewHeaderStyle">ItemName</td>
                                     
                                         <td class="GridViewHeaderStyle">Rate</td>
                                      <td class="GridViewHeaderStyle">DiscountPer</td>
                                           <td class="GridViewHeaderStyle">DiscountAmt</td>
                                         
                                         <td class="GridViewHeaderStyle">IGSTPer</td>
                                           <td class="GridViewHeaderStyle">SGSTPer</td>
                                           <td class="GridViewHeaderStyle">CGSTPer</td>
                                          <td class="GridViewHeaderStyle">GSTAmount</td>
                                         <td class="GridViewHeaderStyle">BuyPrice</td>
                                         
                                         <td class="GridViewHeaderStyle">Select</td>
                                         
                                         
                                        
                                     </tr>
                                 </table></div>
               </div>
                </div>
         </div>

    <script type="text/javascript">

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

        $(document).ready(function () {
            $('#<%=ddlmachine.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('#<%=ddlsupplier.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('#<%=ddlitem.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

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

            bindlocation();
            bindmachine();
            binditem();
            bindsupplier();
        });
    </script>

     <script type="text/javascript">

         function bindlocation() {

             var dropdown = $("#<%=ddllocation.ClientID%>");
            $("#<%=ddllocation.ClientID%> option").remove();



            $.ajax({
                url: "SetQuotation.aspx/bindlocation",
                data: '{}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        dropdown.append($("<option></option>").val("0").html("--No Location Found--"));

                    }
                    else {
                        dropdown.append($("<option></option>").val("0").html("Select From Location"));

                        for (i = 0; i < PanelData.length; i++) {
                            dropdown.append($("<option></option>").val(PanelData[i].deliverylocationid).html(PanelData[i].deliverylocationname));

                        }
                    }
                    dropdown.trigger('chosen:updated');


                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindmachine() {

            $('#<%=ddlmachine.ClientID%> option').remove();
            $('#<%=ddlmachine.ClientID%>').multipleSelect("refresh");


            $.ajax({
                url: "SetQuotation.aspx/bindmachine",
                data: '{}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $('#<%=ddlmachine.ClientID%>').append($("<option></option>").val("0").html("--No Machine Found--"));

                      }
                      else {


                          for (i = 0; i < PanelData.length; i++) {
                              $('#<%=ddlmachine.ClientID%>').append($("<option></option>").val(PanelData[i].MachineID).html(PanelData[i].MachineName));

                          }
                      }
                      $('[id=<%=ddlmachine.ClientID%>]').multipleSelect({
                          includeSelectAllOption: true,
                          filter: true, keepOpen: false
                      });


                  },
                  error: function (xhr, status) {
                      //  alert(status + "\r\n" + xhr.responseText);
                      window.status = status + "\r\n" + xhr.responseText;
                  }
              });
          }

          function bindsupplier() {

              $('#<%=ddlsupplier.ClientID%> option').remove();
            $('#<%=ddlsupplier.ClientID%>').multipleSelect("refresh");


            $.ajax({
                url: "SetQuotation.aspx/bindsupplier",
                data: '{}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $('#<%=ddlsupplier.ClientID%>').append($("<option></option>").val("0").html("--No Supplier Found--"));

                    }
                    else {


                        for (i = 0; i < PanelData.length; i++) {
                            $('#<%=ddlsupplier.ClientID%>').append($("<option></option>").val(PanelData[i].VendorId).html(PanelData[i].VendorName));

                          }
                      }
                    $('[id=<%=ddlsupplier.ClientID%>]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });


                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

         function binditem() {

             $('#<%=ddlitem.ClientID%> option').remove();
               $('#<%=ddlitem.ClientID%>').multipleSelect("refresh");


               $.ajax({
                   url: "SetQuotation.aspx/binditem",
                   data: '{}', // parameter map 
                   type: "POST", // data has to be Posted    	        
                   contentType: "application/json; charset=utf-8",
                   timeout: 120000,
                   async: false,
                   dataType: "json",
                   success: function (result) {
                       PanelData = $.parseJSON(result.d);
                       if (PanelData.length == 0) {
                           $('#<%=ddlitem.ClientID%>').append($("<option></option>").val("0").html("--No Item Found--"));

                    }
                    else {


                        for (i = 0; i < PanelData.length; i++) {
                            $('#<%=ddlitem.ClientID%>').append($("<option></option>").val(PanelData[i].itemid).html(PanelData[i].typename));

                        }
                    }
                    $('[id=<%=ddlitem.ClientID%>]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });


                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        
    </script>

      <script type="text/javascript">
          function getfromrate() {
              if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                $('#tblitemlist tr').slice(1).remove();
                return;
            }
            var machineid = $('#<%=ddlmachine.ClientID%>').val();
              var supplier = $('#<%=ddlsupplier.ClientID%>').val();
              var itemid = $('#<%=ddlitem.ClientID%>').val();
            $('#tblitemlist tr').slice(1).remove();
            $.blockUI();
            jQuery.ajax({
                url: "SetQuotation.aspx/SearchFromRecords",
                data: '{locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '",machineid:"' + machineid + '",supplier:"' + supplier + '",itemid:"' + itemid + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                       
                        showerrormsg("No Item Rate Found This Location");
                        $.unblockUI();
                       

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {

                            var color = "palegreen";
                            if (ItemData[i].ComparisonStatus == "0") {
                                color = "white";
                            }
                            var mydata = "<tr style='background-color:" + color + ";'>";

                            mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "</td>";
                          
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].vendorname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].VednorStateName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].MachineName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" >' + ItemData[i].itemid + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ItemName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].Rate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].DiscountPer + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].DiscountAmt + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].IGSTPer + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].SGSTPer + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].CGSTPer + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].GSTAmount + '</td>';

                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].FinalPrice + '</td>';

                            if (ItemData[i].ComparisonStatus == "0") {
                                mydata += '<td class="GridViewLabItemStyle"><input type="checkbox" id="ch" /></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle"></td>';
                            }

                            mydata += '<td class="GridViewLabItemStyle" style="display:none;">' + ItemData[i].ComparisonStatus + '</td>';

                            mydata += '<td class="GridViewLabItemStyle" id="itemid" style="display:none;">' + ItemData[i].itemid + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="deliverylocationid" style="display:none;">' + ItemData[i].deliverylocationid + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="mapid" style="display:none;">' + ItemData[i].mapid + '</td>';
                            
                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                           
                        }
                        $.unblockUI();
                    }
                },
                error: function (xhr, status) {
                    showerrormsg("Error ");
                    $.unblockUI();
                }
            });
          }

                 
    </script>

    <script type="text/javascript">

        function savenow() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#ch").is(':checked')) {

                    var objStockMaster = new Object();
                    objStockMaster.locationid = $(this).find("#deliverylocationid").html();
                    objStockMaster.itemid = $(this).find("#itemid").html();
                    objStockMaster.mapid = $(this).find("#mapid").html();
                    
                    dataIm.push(objStockMaster);
                }
            });

           
            if (dataIm.length == 0) {
                showerrormsg("Please Select Item To Set");
                return;
            }
            $.blockUI();
            $.ajax({
                url: "SetQuotation.aspx/savedata",
                data: JSON.stringify({ dataIm: dataIm }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {
                        showmsg("Quotation  Set Successfully..!");

                        getfromrate();

                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });


        }
    </script>

</asp:Content>

