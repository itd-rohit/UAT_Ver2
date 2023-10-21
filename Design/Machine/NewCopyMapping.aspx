<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="NewCopyMapping.aspx.cs" Inherits="Design_Lab_NewCopyMapping" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24 ">
                    <b>Copy Mapping From One Machine To Another </b>
                </div>
            </div>
           
        </div>

        <div class="POuter_Box_Inventory" id="SearchFilteres">
         
            <div class="content">
                        <table style="width:99%">
                            <tr>
                                 <td class="required"><b> From Centre :</b></td>
                                <td> <asp:DropDownList ID="ddlfromcentre" runat="server"  Width="400px" class="ddlfromcentre chosen-select" onchange="bindmachine()"></asp:DropDownList></td>
                                 <td class="required"><b>To Centre :</b></td>
                                 <td> <asp:DropDownList ID="ddltocentre" runat="server"  Width="400px" class="ddltocentre chosen-select"  onchange="bindtomachine()"></asp:DropDownList></td>
                                
                            </tr>
                            <tr>
                                 <td class="required"><b>From Machine :</b></td>
                                <td> <asp:DropDownList ID="ddlmachine" runat="server"  Width="400px" class="ddlmachine chosen-select" onchange="getmapping('1')" ></asp:DropDownList></td>
                                <td class="required"><b>To Machine :</b></td>
                                <td> <asp:DropDownList ID="ddltomachine" runat="server"  Width="400px" class="ddltomachine chosen-select" ></asp:DropDownList></td>
                              
                            </tr>  
                              
                          
                        
                          
                            <tr>
                                 <td  colspan="4" align="center">
                                       <input type="button" value="Copy Mapping" class="savebutton" onclick="transfernow()" id="btnsave" />    
                                       <input type="button" value="Reset" class="resetbutton" onclick="resetdata()" />   
                                 </td>
                            </tr>
                            </table>
                        </div>


        </div>

        <div class="POuter_Box_Inventory">
           
             <div class="content">
                         <div  style="width:1295px; max-height:390px;overflow:auto;">

                    <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">
                        </table>
                             </div>
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




         });
        </script>
      <script type="text/javascript">
          function bindmachine() {
              var centreid = $('#<%=ddlfromcentre.ClientID%>').val();
             jQuery('#<%=ddlmachine.ClientID%> option').remove();
             $('#<%=ddlmachine.ClientID%>').trigger('chosen:updated');

             if (centreid != "0" && centreid != null) {
              //   $.blockUI();
                 $.ajax({
                     url: "NewCopyMapping.aspx/bindmachine",
                     data: '{centreid: "' + centreid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Machine Found");
                         }

                         jQuery("#<%=ddlmachine.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Equipment(Machine)"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlmachine.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].MACHINEID).html(CentreLoadListData[i].MACHINENAME));
                         }

                         $("#<%=ddlmachine.ClientID%>").trigger('chosen:updated');
                       //  $.unblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                       //  $.unblockUI();
                     }
                 });
             }
         }

         function bindtomachine() {
             var centreid = $('#<%=ddltocentre.ClientID%>').val();
             jQuery('#<%=ddltomachine.ClientID%> option').remove();
             $('#<%=ddltomachine.ClientID%>').trigger('chosen:updated');

             if (centreid != "0" && centreid != null) {
                // $.blockUI();
                 $.ajax({
                     url: "NewCopyMapping.aspx/bindmachine",
                     data: '{centreid: "' + centreid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Machine Found");
                         }

                         jQuery("#<%=ddltomachine.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Equipment(Machine)"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddltomachine.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].MACHINEID).html(CentreLoadListData[i].MACHINENAME));
                         }

                         $("#<%=ddltomachine.ClientID%>").trigger('chosen:updated');
                       //  $.unblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                        // $.unblockUI();
                     }
                 });
             }
         }
         </script>
    <script type="text/javascript">
        function transfernow() {
            if ($('#<%=ddlfromcentre.ClientID%>').val() == "0") {
                showerrormsg("Please Select From Centre");
                return;
            }
            if ($('#<%=ddltocentre.ClientID%>').val() == "0") {
                showerrormsg("Please Select To Centre");
                return;
            }
            if ($('#<%=ddlmachine.ClientID%>').val() == "" || $('#<%=ddlmachine.ClientID%>').val() == "0") {
                showerrormsg("Please Select From Machine");
                return;
            }
            if ($('#<%=ddltomachine.ClientID%>').val() == "" || $('#<%=ddltomachine.ClientID%>').val() == "0") {
                showerrormsg("Please Select To Machine");
                return;
            }
            if ($('#<%=ddlmachine.ClientID%>').val() == $('#<%=ddltomachine.ClientID%>').val()) {
                showerrormsg("From Machine and To Machine can't be same");
                return;
            }


          //  $.blockUI();
            $.ajax({
                url: "NewCopyMapping.aspx/transfermapping",
                data: '{frommachine: "' + $('#<%=ddlmachine.ClientID%>').val() + '",tomachine:"' + $('#<%=ddltomachine.ClientID%>').val() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                 //   $.unblockUI();
                    if (result.d == "1") {
                        showmsg("Machine Mapping Copied Successfully");
                        resetdata();
                        // getmapping('2');

                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                 //   $.unblockUI();
                }
            });
        }

        function resetdata() {
            $("#<%=ddlfromcentre.ClientID%>").prop('selectedIndex', 0).trigger('chosen:updated');
            $("#<%=ddltocentre.ClientID%>").prop('selectedIndex', 0).trigger('chosen:updated');

            jQuery('#<%=ddlmachine.ClientID%> option').remove();
            jQuery('#<%=ddltomachine.ClientID%> option').remove();
            $('#<%=ddlmachine.ClientID%>').trigger('chosen:updated');
            $('#<%=ddltomachine.ClientID%>').trigger('chosen:updated');
            $('#tbl tr').remove();
        }


        function getmapping(type) {

            $('#tbl tr').remove();
            var macid = '';
            if (type == "1") {
                macid = jQuery('#<%=ddlmachine.ClientID%>').val();
            }
            if (type == "2") {
                macid = jQuery('#<%=ddltomachine.ClientID%>').val();
            }
            if (macid == "" || macid == "0") {
                return;
            }
         //   $.blockUI();
            $.ajax({
                url: "NewCopyMapping.aspx/getdata",
                data: '{macid:"' + macid + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        showerrormsg(" No Data Found");
                       // $.unblockUI();
                        return;
                    }

                    var mydatahead = "<tr id='trheader'>";
                    mydatahead += '<td class="GridViewHeaderStyle" style="width: 20px;">#</td>';
                    mydatahead += '<td class="GridViewHeaderStyle">Machine</td>';
                    mydatahead += '<td class="GridViewHeaderStyle">Machine_ParamID</td>';
                    mydatahead += '<td class="GridViewHeaderStyle">LabObservationId</td>';
                    mydatahead += '<td class="GridViewHeaderStyle">LabObservationName</td>';
                    mydatahead += '<td class="GridViewHeaderStyle">AssayNo</td>';
                    mydatahead += '<td class="GridViewHeaderStyle">Machine_Param</td>';
                    mydatahead += '<td class="GridViewHeaderStyle">RoundUpTo</td>';
                    mydatahead += "</tr>";
                    $('#tbl').append(mydatahead);
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var mydata = "<tr style='background-color:lightgreen;' id='" + ItemData[i].id + "'>";
                        mydata += '<td class="GridViewLabItemStyle"  id="srno" >' + parseInt(i + 1) + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="MACHINEID" >' + ItemData[i].MACHINEID + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="Machine_ParamID" >' + ItemData[i].Machine_ParamID + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_id" >' + ItemData[i].LabObservation_id + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservationname" >' + ItemData[i].LabObservationname + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="AssayNo">' + ItemData[i].AssayNo + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="Machine_Param"  >' + ItemData[i].Machine_Param + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="RoundUpTo"  >' + ItemData[i].RoundUpTo + '</td>';
                        mydata += "</tr>";
                        $('#tbl').append(mydata);
                    }
                  //  $.unblockUI();

                },
                error: function (xhr, status) {
                   // $.unblockUI();
                }
            });
        }
    </script>
</asp:Content>



