<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="VendorQuotationChangeFromToDate.aspx.cs" Inherits="Design_Store_VendorQuotationChangeFromToDate" %>

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
                          <b>Supplier Quotation From And To Date Change</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
              
                           <div class="Purchaseheader">Store Location and Supplier</div>
                            <table width="100%">
                                <tr>
                                    <td>Location:</td>
                                    <td>  <asp:ListBox ID="ddllocation" CssClass="multiselect" SelectionMode="Multiple" Width="480px" runat="server" ></asp:ListBox></td>
                                    <td>Supplier:</td>
                                    <td> <asp:ListBox ID="ddlsupplier" CssClass="multiselect" SelectionMode="Multiple" Width="480px" runat="server" ></asp:ListBox></td>
                                </tr>
                                
                                <tr>
                                      <td>Item:</td>
                                    <td> <asp:ListBox ID="ddlitem" CssClass="multiselect" SelectionMode="Multiple" Width="480px" runat="server" ></asp:ListBox></td>
                                    <td>Machine:</td>
                                    <td> <asp:ListBox ID="ddlmachine" CssClass="multiselect" SelectionMode="Multiple" Width="480px" runat="server" ></asp:ListBox></td>
                                </tr>

                                <tr>
                                      <td colspan="2">
                          <b>Quotation Expiry With In Days :</b>&nbsp;
                                          <asp:TextBox ID="txtdate" runat="server" Width="92px" AutoCompleteType="Disabled" MaxLength="3" ></asp:TextBox> 
                            <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtdate">
                            </cc1:FilteredTextBoxExtender>
                                      &nbsp;<span style="color: #FF0000; font-size: 13px"><strong><em>* Blank or 0 for expired Quotation</em></strong></span></td>
                                    <td style="font-weight: 700">Max Record :</td>
                                    <td>   <asp:TextBox ID="txtmaxrecord" runat="server" Width="92px" AutoCompleteType="Disabled" MaxLength="3" Text="100"></asp:TextBox> 
                                        &nbsp;<span style="color: #FF0000; font-size: 13px"><strong><em>* Change Max Record To View More Data</em></strong></span>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txtmaxrecord">
                            </cc1:FilteredTextBoxExtender>
                                       
                                    </td>
                                </tr>

                                <tr>
                                      <td colspan="4" style="text-align: center">
                                      <input type="button" value="Search" class="searchbutton" onclick="searchme()" />   
                                      &nbsp;&nbsp;
                                           <input type="button" value="Save" id="btnsave" style="display:none;" class="savebutton" onclick="saveme()" />   
                                      </td>
                                </tr>

                                </table>
                      
                </div>
                 </div>

               <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
               <div style="max-height:380px;overflow:auto;">
                 <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                      <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                         
                                               
                                          <td class="GridViewHeaderStyle">Location</td>
                                          <td class="GridViewHeaderStyle">Location State</td>
                                          <td class="GridViewHeaderStyle">Supplier</td>
                                          <td class="GridViewHeaderStyle">Supplier State</td>
                                          <td class="GridViewHeaderStyle">ItemID</td>
                                          <td class="GridViewHeaderStyle">ItemName</td>
                                          <td class="GridViewHeaderStyle">Manufacture</td>
                                          <td class="GridViewHeaderStyle">MachineName</td>
                                          <td class="GridViewHeaderStyle">PackSize</td>
                                          <td class="GridViewHeaderStyle">HSNCode</td>
                                          <td class="GridViewHeaderStyle" style="width:85px;">From Date</td>
                                          <td class="GridViewHeaderStyle" style="width:85px;">
                                              <input type="text" name="txttodatehead" id="txttodatehead" readonly="readonly" style="width:80px" placeholder="Set For All" />

                                              
                                          </td>
                                         <td class="GridViewHeaderStyle"  width="20px"><input type="checkbox" onclick="checkall(this)" id="chall"  /></td>
                                         
                                         
                                         
                                         
                                        
                                     </tr>
                     </table>
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
            $('#<%=ddllocation.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
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


            var newdate = new Date();



            var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
       "Aug", "Sep", "Oct", "Nov", "Dec"];

            var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();




            $("#txttodatehead").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                changeYear: true, yearRange: "-0:+50", minDate: val

            });



            $("#txttodatehead").on('change keyup paste', function () {
                var val = $("#txttodatehead").val();
                var name = $("#txttodatehead").attr("name");
                $('input[name="' + name + '"]').each(function () {
                    $(this).val(val);
                });
                $("#txttodatehead").closest("tr").find("#chall").prop('checked', true);
                
                checkall($("#txttodatehead").closest("tr").find("#chall"));
            });
        });
    </script>

    <script type="text/javascript">

        function bindlocation() {

            $('#<%=ddllocation.ClientID%> option').remove();
            $('#<%=ddllocation.ClientID%>').multipleSelect("refresh");



            $.ajax({
                url: "VendorQuotationChangeFromToDate.aspx/bindlocation",
                data: '{}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $('#<%=ddllocation.ClientID%>').append($("<option></option>").val("0").html("--No Location Found--"));

                    }
                    else {
                        

                        for (i = 0; i < PanelData.length; i++) {
                            $('#<%=ddllocation.ClientID%>').append($("<option></option>").val(PanelData[i].deliverylocationid).html(PanelData[i].deliverylocationname));

                        }
                    }
                    $('[id=<%=ddllocation.ClientID%>]').multipleSelect({
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

        function bindmachine() {

            $('#<%=ddlmachine.ClientID%> option').remove();
            $('#<%=ddlmachine.ClientID%>').multipleSelect("refresh");


            $.ajax({
                url: "VendorQuotationChangeFromToDate.aspx/bindmachine",
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
                url: "VendorQuotationChangeFromToDate.aspx/bindsupplier",
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
                url: "VendorQuotationChangeFromToDate.aspx/binditem",
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
       function searchme() {

           var maxrecord = $('#<%=txtmaxrecord.ClientID%>').val() == "" ? 0 : $('#<%=txtmaxrecord.ClientID%>').val();
           var expiry = $('#<%=txtdate.ClientID%>').val() == "" ? 0 : $('#<%=txtdate.ClientID%>').val();

           var machineid = $('#<%=ddlmachine.ClientID%>').val();
           var supplier = $('#<%=ddlsupplier.ClientID%>').val();
           var location = $('#<%=ddllocation.ClientID%>').val();
           var item = $('#<%=ddlitem.ClientID%>').val();

           $('#tblitemlist tr').slice(1).remove();
           $.blockUI();
           jQuery.ajax({
               url: "VendorQuotationChangeFromToDate.aspx/SearchFromRecords",
               data: '{locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '",machineid:"' + machineid + '",supplier:"' + supplier + '",maxrecord:"' + maxrecord + '",expiry:"' + expiry + '"}',
               type: "POST",
               contentType: "application/json; charset=utf-8",
               timeout: 120000,
               dataType: "json",

               success: function (result) {
                   ItemData = jQuery.parseJSON(result.d);

                   if (ItemData.length == 0) {

                       showerrormsg("No Item Rate Found This Location");
                       $.unblockUI();
                       $('#btnsave').hide();


                   }
                   else {
                       for (var i = 0; i <= ItemData.length - 1; i++) {
                           var mydata = "<tr style='background-color:pink;' id='" + ItemData[i].ID + "'>";

                           mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "</td>";

                           mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].DeliveryLocationName + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].DeliveryStateName + '</td>';

                           mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].VendorName + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].VednorStateName + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + ItemData[i].itemid + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ItemName + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ManufactureName + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].MachineName + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].PackSize + '</td>';
                           mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].HSNCode + '</td>';
                           
                           mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="txtfromdate" style="width:80px;" value="' + ItemData[i].EntryDateFrom + '" readonly="true" /></td>';
                           mydata += '<td class="GridViewLabItemStyle" ><input type="text" name="txttodatehead"  class="datepick" id="txttodate' + ItemData[i].ID + '" style="width:80px;" readonly="readonly" value="' + ItemData[i].EntryDateTo + '" /></td>';
                          
                           mydata += '<td class="GridViewLabItemStyle" id="tdse"><input type="checkbox" id="chk"  /></td>';
                         


                           mydata += "</tr>";
                           $('#tblitemlist').append(mydata);

                          
                           var newdate = new Date();

                          

                           var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                      "Aug", "Sep", "Oct", "Nov", "Dec"];

                           var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();




                           $("#txttodate" + ItemData[i].ID).datepicker({
                               dateFormat: "dd-M-yy",
                               changeMonth: true,
                               changeYear: true, yearRange: "-0:+50", minDate: val

                           });


                       }
                       $('#btnsave').show();
                       $.unblockUI();
                   }
               },
               error: function (xhr, status) {
                   showerrormsg("Error ");
                   $.unblockUI();
                   $('#btnsave').hide();
               }
           });


       }


       function checkall(ctr) {
           $('#tblitemlist tr').each(function () {
               if ($(this).attr('id') != "triteheader") {

                   if ($(ctr).is(":checked")) {

                       $(this).find('#chk').attr('checked', true);
                   }
                   else {
                       $(this).find('#chk').attr('checked', false);
                   }


               }
           });
       }



       function getitemdata() {
           var dataIm = new Array();
           $('#tblitemlist tr').each(function () {
               if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked')) {
                   var id = $(this).attr("id");
                   var todate = $(this).find("#txttodate" + id).val();
                   var finddata = id + "#" + todate;
                   dataIm.push(finddata);
               }
           });
           return dataIm;
       }


       function saveme() {
           var data = getitemdata();
           if (data.length == 0) {
               showerrormsg("Please Select Item To Save");
               return;
           }


           $.blockUI();
           $.ajax({
               url: "VendorQuotationChangeFromToDate.aspx/Savedata",
               data: JSON.stringify({ data: data }),
               type: "POST", // data has to be Posted    	        
               contentType: "application/json; charset=utf-8",
               timeout: 120000,
               dataType: "json",
               success: function (result) {
                   TestData1 = result.d;
                   if (TestData1 == "1") {

                       showmsg("Record Save Sucessfully");
                       searchme();
                       $('#txttodatehead').val('');
                       $('#chall').attr('checked', false);
                   }
                   else {
                       showerrormsg(TestData1);
                   }
                   $.unblockUI();
               },
               error: function (xhr, status) {
                   // alert(status + "\r\n" + xhr.responseText);
                   window.status = status + "\r\n" + xhr.responseText;
                   $.unblockUI();
               }
           });
       }
   </script>
</asp:Content>

