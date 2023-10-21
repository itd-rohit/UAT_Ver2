<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ILCSchedule.aspx.cs" Inherits="Design_Quality_ILCSchedule" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

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
	   <script src="http://malsup.github.io/jquery.blockUI.js"></script>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:13000"><%--durga msg changes--%>
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
                          <b>ILC/EQAS Schedule</b>  

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
                             <asp:DropDownList ID="ddlcentretype" runat="server" class="ddlcentretype chosen-select chosen-container"   Width="80px" onchange="bindcentre()">
                             </asp:DropDownList>
                            

                           

                            <asp:ListBox ID="ddlprocessinglab" onchange="getmydata()" CssClass="multiselect" SelectionMode="Multiple" Width="455px" runat="server"></asp:ListBox>

                        </td>

                        <td style="font-weight: 700">
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                        </tr>
                    <tr>
                        <td style="font-weight: 700">
                            From Day(Every Month) :</td>

                        <td>
                        <asp:DropDownList id="ddlfromdate" runat="server" Width="150px"></asp:DropDownList>
                        </td>

                        <td style="font-weight: 700">
                            To Day(Every Month) :</td>
                        <td>
                             <asp:DropDownList id="ddltodate" runat="server" Width="150px"></asp:DropDownList></td>
                        </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Schedule Type :</td>

                        <td colspan="3">
                            <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True">ILC Registration</asp:ListItem>
                                <asp:ListItem Value="2">ILC Result Entry and Approval</asp:ListItem>
                                <asp:ListItem Value="3">EQAS Registration</asp:ListItem>
                                 <asp:ListItem Value="4">EQAS Result Entry and Approval</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>

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
                                        <td class="GridViewHeaderStyle">From Date(Every Month)</td>
                                        <td class="GridViewHeaderStyle">To Date(Every Month)</td>
                                        <td class="GridViewHeaderStyle">Entry Date</td>
                                        <td class="GridViewHeaderStyle">Entry By</td>

               </tr>
               </table>
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
            $('#<%=ddlprocessinglab.ClientID%>').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
            });

            GetAllDate();
         });

         function bindcentre() {

             var TypeId = $('#<%=ddlcentretype.ClientID%>').val();
             jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
             jQuery('#<%=ddlprocessinglab.ClientID%>').multipleSelect("refresh");
             if (TypeId == "0") {


                 return;

             }

             $.ajax({
                 url: "ILCSchedule.aspx/bindCentre",
                 data: '{TypeId: "' + TypeId + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 async: false,
                 dataType: "json",
                 success: function (result) {
                     centreData = $.parseJSON(result.d);
                     for (i = 0; i < centreData.length; i++) {
                         jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val(centreData[i].centreid).html(centreData[i].centre));
                     }
                     $('[id=<%=ddlprocessinglab.ClientID%>]').multipleSelect({
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
            if (centreid == "") {
                showerrormsg("Please Select Processing Lab");
                return;
            }


            var fromdate = $('#<%=ddlfromdate.ClientID%>').val();
            if (fromdate == "0") {
                showerrormsg("Please Select Start Date");
                return;
            }

            var todate = $('#<%=ddltodate.ClientID%>').val();
            if (todate == "0") {
                showerrormsg("Please Select To Date");
                return;
            }


            if(Number(fromdate)>Number(todate))
            {
                showerrormsg("Start date should be greater then To Date");
                return;
            }
            var scheduletype = $('#<%=rd.ClientID%> input:checked').val();


            //$.blockUI();
            $.ajax({
                url: "ILCSchedule.aspx/SaveData",
                data: '{centreid: "' + centreid + '",fromdate:"' + fromdate + '",todate:"' + todate + '",scheduletype:"' + scheduletype + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    //$.UNblockUI();
                    var save = result.d;
                    if (save == "1") {
                        showmsg("Record Saved Successfully");

                        clearForm();

                        GetAllDate();
                    }
                    else {
                        showerrormsg(save);

                        // console.log(save);
                    }
                },
                error: function (xhr, status) {
                    //$.UNblockUI()
                    showerrormsg("Some Error Occure Please Try Again..!");

                    console.log(xhr.responseText);
                }
            });

        }


        function clearForm() {

           // jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
            //jQuery('#<%=ddlprocessinglab.ClientID%>').multipleSelect("refresh");
            //$("#<%=ddlcentretype.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
            //$("#<%=ddlfromdate.ClientID%>").prop('selectedIndex', 0);
            //$("#<%=ddltodate.ClientID%>").prop('selectedIndex', 0);
            $('#<%=rd.ClientID %>').find("input[value='1']").prop("checked", true);

        }

        function resetForm() {

             jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
            jQuery('#<%=ddlprocessinglab.ClientID%>').multipleSelect("refresh");
           $("#<%=ddlcentretype.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
            $("#<%=ddlfromdate.ClientID%>").prop('selectedIndex', 0);
           $("#<%=ddltodate.ClientID%>").prop('selectedIndex', 0);
            $('#<%=rd.ClientID %>').find("input[value='1']").prop("checked", true);

        }

        function GetAllDate() {


            //$.blockUI();
            $('#tbl tr').slice(1).remove();
            $.ajax({
                url: "ILCSchedule.aspx/GetAllDate",
                data: '{}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    ItemData = $.parseJSON(result.d);
                    if (ItemData.length === 0) {
                        //$.UNblockUI();
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
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].EntryDate + '</td>';
                        mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].entryby + '</td>';
                        mydata += "</tr>";
                        $('#tbl').append(mydata);
                     }
                    //$.UNblockUI();

                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                     //$.UNblockUI();
                 }
             });
        }



        function deleterow(itemid) {
            if (confirm("Do You Want To Delete This Data?")) {
                var id = $(itemid).closest('tr').attr('id');




                jQuery.ajax({
                    url: "ILCSchedule.aspx/deletedata",
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

