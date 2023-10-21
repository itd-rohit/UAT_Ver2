<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ILCScheduleSpecial.aspx.cs" Inherits="Design_Quality_ILCScheduleSpecial" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <style type="text/css">
        
    .ajax__calendar_container .ajax__calendar_other .ajax__calendar_day,
.ajax__calendar_container .ajax__calendar_other .ajax__calendar_year,

    .ajax__calendar_next,.ajax__calendar_prev,.ajax__calendar_title
{
	display:none;
}
    </style>
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
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
                          <b>ILC Schedule Special Date</b>  

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
                        <td style="font-weight: 700">
                            Processing Lab : </td>

                        <td>
                         
                            

                           

                            <asp:DropDownList ID="ddlprocessinglab" onchange="GetAllDate()" class="ddlprocessinglab chosen-select chosen-container" Width="455px" runat="server"></asp:DropDownList>

                        </td>

                        <td style="font-weight: 700">
                            Schedule Type :
                        </td>
                        <td>
                            <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True">ILC Registration</asp:ListItem>
                                <asp:ListItem Value="2">ILC Result Entry and Approval</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        </tr>
                    <tr>
                        <td style="font-weight: 700">
                            From Day :</td>

                        <td>
                          <asp:TextBox ID="txtfromdate" runat="server" Width="150px"></asp:TextBox> 

                             <cc1:CalendarExtender ID="calFromDate" runat="server"  TargetControlID="txtfromdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>

                        <td style="font-weight: 700">
                            To Day :</td>
                        <td>
                              <asp:TextBox ID="txttodate" runat="server" Width="150px"></asp:TextBox>

                             <cc1:CalendarExtender ID="CalendarExtender1" runat="server"  TargetControlID="txttodate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Reason :</td>

                        <td>
                            <asp:TextBox ID="txtreason" runat="server" Width="400px" MaxLength="200"></asp:TextBox> </td>

                        <td style="font-weight: 700">
                            &nbsp;</td>
                        <td>
                              &nbsp;</td>
                        </tr>
                    <tr>
                        <td style="font-weight: 700; text-align: center;" colspan="4">
                        <input type="button" value="Save" class="savebutton" onclick="saveme()" /> 
                            
                            <input type="button" value="Reset" class="resetbutton" onclick="resetForm()" />   
                        </td>

                        </tr>
                    </table>
                </div>
              </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

           <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
           <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">
              
                    <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle">Lab Code</td>
                                        <td class="GridViewHeaderStyle">Processing Lab</td>
                                        <td class="GridViewHeaderStyle">Schedule Type</td>
                                        <td class="GridViewHeaderStyle">From Date</td>
                                        <td class="GridViewHeaderStyle">To Date</td>
                                        <td class="GridViewHeaderStyle">Reason</td>
                                        <td class="GridViewHeaderStyle">Entry Date</td>
                                        <td class="GridViewHeaderStyle">Entry By</td>

               </tr>
               </table>
               </div>
                </div>

         </div>

         </div>
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
           
            bindcentre();
           // GetAllDate();
        });

        function bindcentre() {

            
             $.ajax({
                 url: "ILCScheduleSpecial.aspx/bindCentre",
                 data: '{}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 async: false,
                 dataType: "json",
                 success: function (result) {
                     centreData = $.parseJSON(result.d);
                     jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val("0").html("Select Processing Lab"));
                     for (i = 0; i < centreData.length; i++) {
                         jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val(centreData[i].centreid).html(centreData[i].centre));
                     }
                    
                     $("#<%=ddlprocessinglab.ClientID%>").trigger('chosen:updated');
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
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
        function saveme() {

            var centreid = $('#<%=ddlprocessinglab.ClientID%>').val();
            if (centreid == "0") {
                showerrormsg("Please Select Processing Lab");
                return;
            }


            var fromdate = $('#<%=txtfromdate.ClientID%>').val();
           

            var todate = $('#<%=txttodate.ClientID%>').val();
           
            var fromdatetime = new Date(fromdate);
            var todatetime = new Date(todate);

            if (fromdatetime > todatetime) {
                showerrormsg("Start date should be greater then To Date");
                return;
            }
            var scheduletype = $('#<%=rd.ClientID%> input:checked').val();


            var reason = $('#<%=txtreason.ClientID%>').val();
            if (reason == "") {
                showerrormsg("Please Enter Reason");
                $('#<%=txtreason.ClientID%>').focus();
                return;

            }

            $.blockUI();
            $.ajax({
                url: "ILCScheduleSpecial.aspx/SaveData",
                data: '{centreid: "' + centreid + '",fromdate:"' + fromdate + '",todate:"' + todate + '",scheduletype:"' + scheduletype + '",reason:"' + reason + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    var save = result.d;
                    if (save == "1") {
                        showmsg("Record Saved Successfully");

                       

                        GetAllDate();
                        clearForm();
                    }
                    else {
                        showerrormsg(save);

                        // console.log(save);
                    }
                },
                error: function (xhr, status) {
                    $.unblockUI()
                    showerrormsg("Some Error Occure Please Try Again..!");

                    console.log(xhr.responseText);
                }
            });

        }


        function clearForm() {
            $('#<%=txtreason.ClientID%>').val('');
            //jQuery('#<%=ddlprocessinglab.ClientID%> option').prop('selectedIndex', 0).trigger('chosen:updated');
            
           
           
            //$('#<%=rd.ClientID %>').find("input[value='1']").prop("checked", true);

        }


        function resetForm() {
            $('#<%=txtreason.ClientID%>').val('');
            jQuery('#<%=ddlprocessinglab.ClientID%> option').prop('selectedIndex', 0).trigger('chosen:updated');



            $('#<%=rd.ClientID %>').find("input[value='1']").prop("checked", true);

        }

        function GetAllDate() {

            if ($('#<%=ddlprocessinglab.ClientID%>').val() == "0") {
                $('#tbl tr').slice(1).remove();
                return;
            }

            $.blockUI();
            $('#tbl tr').slice(1).remove();
            $.ajax({
                url: "ILCScheduleSpecial.aspx/GetAllDate",
                data: '{centreid:"'+$('#<%=ddlprocessinglab.ClientID%>').val()+'"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    ItemData = $.parseJSON(result.d);
                    if (ItemData.length === 0) {
                        $.unblockUI();
                        return;
                    }

                    for (i = 0; i < ItemData.length; i++) {
                        var mydata = "<tr style='background-color:lightgreen;' id='" + ItemData[i].id + "'>";
                        mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].CentreCode + '</td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].Centre + '</td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].ScheduleType + '</td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].fromdate + '</td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].todate + '</td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].SpecialRemarks + '</td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].EntryDate + '</td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].entryby + '</td>';
                        mydata += "</tr>";
                        $('#tbl').append(mydata);
                    }
                    $.unblockUI();

                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                    $.unblockUI();
                }
            });
        }



        function deleterow(itemid) {
            if (confirm("Do You Want To Delete This Data?")) {
                var id = $(itemid).closest('tr').attr('id');




                jQuery.ajax({
                    url: "ILCScheduleSpecial.aspx/deletedata",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg("Data Deleted..");
                            var table = document.getElementById('tbl');
                            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                        }
                        else {
                            showerrormsg("Some Error ..");
                        }


                    },


                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });


            }
        }

    </script>

</asp:Content>


