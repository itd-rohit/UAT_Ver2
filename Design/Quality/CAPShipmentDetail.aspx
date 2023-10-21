<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CAPShipmentDetail.aspx.cs" Inherits="Design_Quality_CAPShipmentDetail" %>
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
                          <b>CAP PT Shipping Detail</b>  
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
                            Processing Lab :</td>

                        <td>
                             <asp:DropDownList ID="ddlcentretype" runat="server" class="ddlcentretype chosen-select chosen-container"   Width="80px" onchange="bindcentre()">
                             </asp:DropDownList>
                            

                           

                            <asp:DropDownList ID="ddlprocessinglab" onchange="getsavedmapping()" class="ddlprocessinglab chosen-select chosen-container"   Width="365px" runat="server"></asp:DropDownList>

                        </td>
                        <td style="font-weight: 700">
                            CAP Program :
                        </td>
                        <td>
                            <asp:ListBox ID="ddleqasprogram" onchange="getprogramdata()" CssClass="multiselect" SelectionMode="Multiple" Width="400px" runat="server"></asp:ListBox>
                        </td>
                     </tr>

                    <tr>
                        <td style="font-weight: 700; color: #FF0000;">
                            Shipment No :</td>

                        <td colspan="3">
                             <asp:TextBox ID="txtshipmentno" runat="server" Width="120px"></asp:TextBox>

                        &nbsp;&nbsp; <strong>&nbsp;&nbsp;&nbsp; Ship Date :</strong>&nbsp;&nbsp;
                            <asp:TextBox ID="txtshipdate" runat="server" Width="100px" />
                              <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtshipdate" PopupButtonID="txtshipdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>

                        &nbsp;&nbsp; <strong>Due Date :</strong>&nbsp;&nbsp;
                                                        <asp:TextBox ID="txtduedate" runat="server" Width="100px" />
                              <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtduedate" PopupButtonID="txtduedate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>

                        
                        &nbsp;&nbsp;<strong>Mailing :</strong>&nbsp;&nbsp;
                        <asp:TextBox ID="txtmailing" runat="server" Width="120px"></asp:TextBox>&nbsp;&nbsp;<strong>Note :</strong>
                            <asp:TextBox ID="txtnote" runat="server" Width="213px" />
                        </td>
                     </tr>

                     <tr>
                        <td style="font-weight: 700">
                            Test List :</td>

                        <td colspan="3">
                            <div style="width:100%;overflow:auto;max-height:400px;">
                        <table id="tbl">
                            
                        </table>   
                        </div>
                        </td>
                     </tr>
                    <tr>
                        <td style="font-weight: 700; text-align: center;" colspan="4">
                            
                        <input type="button" value="Save" class="savebutton" onclick="saveme()" />&nbsp;&nbsp;
                            <input type="button" value="Reset" class="resetbutton" onclick="resetme()" />
                        <input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()"  /></td>

                     </tr>

                    </table>
                </div>
                 </div>


           <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">


                  <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
           <table id="tbl1" style="width:99%;border-collapse:collapse;text-align:left;">


                  
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle">Processing Lab</td>
                                        <td class="GridViewHeaderStyle">ShipmentNo</td>
                                        <td class="GridViewHeaderStyle">Ship Date</td>
                                        <td class="GridViewHeaderStyle">Due Date</td>
                                        <td class="GridViewHeaderStyle">Mailing</td>
                                        <td class="GridViewHeaderStyle">Note</td>
                                        <td class="GridViewHeaderStyle">CAP Program</td>
                                        <td class="GridViewHeaderStyle"">Tests</td>
                                        <td class="GridViewHeaderStyle">EntryDate</td>
                                        <td class="GridViewHeaderStyle">EntryBy</td>
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
           

             $('[id=<%=ddleqasprogram.ClientID%>]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
         
         bindprogram();

             //bindilclab();

          

         });

         function bindcentre() {

             var TypeId = $('#<%=ddlcentretype.ClientID%>').val();
             jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
             jQuery('#<%=ddlprocessinglab.ClientID%>').trigger('chosen:updated')
             if (TypeId == "0") {


                 return;

             }
             $.blockUI();
             $.ajax({
                 url: "CAPShipmentDetail.aspx/bindCentre",
                 data: '{TypeId: "' + TypeId + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                
                 dataType: "json",
                 success: function (result) {
                     centreData = $.parseJSON(result.d);
                     jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val("0").html("Select Centre"));
                     for (i = 0; i < centreData.length; i++) {
                         jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val(centreData[i].centreid).html(centreData[i].centre));
                     }
                     jQuery('#<%=ddlprocessinglab.ClientID%>').trigger('chosen:updated')
                     $.unblockUI();
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                     $.unblockUI();
                 }
             });

           
         }

        function bindprogram() {
            $('#tbl tr').remove();

          
             $.blockUI();
             $.ajax({
                 url: "CAPShipmentDetail.aspx/bindprogram",
                 data: '{}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,

                 dataType: "json",
                 success: function (result) {
                     centreData = $.parseJSON(result.d);
                     for (i = 0; i < centreData.length; i++) {
                         jQuery("#<%=ddleqasprogram.ClientID%>").append(jQuery("<option></option>").val(centreData[i].programid).html(centreData[i].programname));
                     }
                     $('[id=<%=ddleqasprogram.ClientID%>]').multipleSelect({
                         includeSelectAllOption: true,
                         filter: true, keepOpen: false
                     });
                     $.unblockUI();
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                     $.unblockUI();
                 }
             });
         }


        function getprogramdata() {

            $('#tbl tr').remove();

            var programid = $('#<%=ddleqasprogram.ClientID%>').val();
             if (programid == "") {
                 return;
             }
             $.blockUI();
             $.ajax({
                 url: "CAPShipmentDetail.aspx/bindprogramdata",
                 data: '{programid: "' + programid + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,

                 dataType: "json",
                 success: function (result) {
                     PanelData = $.parseJSON(result.d);
                     var programname = "";
                     var co = 0;
                     for (i = 0; i < PanelData.length; i++) {
                         co = parseInt(co + 1);
                         var mydata = "";
                         if (programname != PanelData[i].programname) {

                             mydata = "<tr style='background-color:white'><td colspan='3' style='font-weight:bold;'>ProgramID:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].programid + "</span>&nbsp;ProgramName:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].programname + "</span>&nbsp;Description:<span style='background-color:aquamarine'>" + PanelData[i].description + "</span></td></tr>";
                             programname = PanelData[i].programname;
                             co = 1;
                         }

                         mydata += '<tr style="background-color:bisque;" class="GridViewItemStyle" id=>';

                         mydata += '<td  align="left" >' + co + '</td>';


                         mydata += '<td align="left">' + PanelData[i].departmentname + '</td>';
                         mydata += '<td align="left">' + PanelData[i].investigationname + '</td>';





                         mydata += '</tr>';

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
        function resetme() {
          

            jQuery('#<%=ddleqasprogram.ClientID%> option').remove();
            jQuery('#<%=ddleqasprogram.ClientID%>').multipleSelect("refresh");
            bindprogram();
           
            $('#<%=ddlcentretype.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
            jQuery('#<%=ddlprocessinglab.ClientID%>').trigger('chosen:updated');
            $('#<%=txtshipmentno.ClientID%>').val('');
            $('#<%=txtmailing.ClientID%>').val('');
            $('#<%=txtnote.ClientID%>').val('');
        }
        function resetmenew() {
            $('#tbl tr').remove();
            jQuery('#<%=ddleqasprogram.ClientID%> option').remove();
            jQuery('#<%=ddleqasprogram.ClientID%>').multipleSelect("refresh");
            bindprogram();
            $('#<%=txtshipmentno.ClientID%>').val('');
            $('#<%=txtmailing.ClientID%>').val('');
            $('#<%=txtnote.ClientID%>').val('');
          

        }



        function getmappingdata() {
            var dataIm = new Array();
         


                $('#<%=ddleqasprogram.ClientID%> > option:selected').each(function () {
                    var ProData = new Object();
                   
                    ProData.LabID = $('#<%=ddlprocessinglab.ClientID%>').val();
                    ProData.ProgramID = $(this).val();
                    ProData.ShipMentNo = $('#<%=txtshipmentno.ClientID%>').val();
                    ProData.ShipDate = $('#<%=txtshipdate.ClientID%>').val();
                    ProData.DueDate = $('#<%=txtduedate.ClientID%>').val();
                    ProData.Mailing = $('#<%=txtmailing.ClientID%>').val();
                    ProData.Note = $('#<%=txtnote.ClientID%>').val();

                    dataIm.push(ProData);
                });

            
            return dataIm;
        }

        function saveme() {

            var length = $('#<%=ddlprocessinglab.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("Please Select Centre");
                $('#<%=ddlprocessinglab.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlprocessinglab.ClientID%>').val() == "0") {
                showerrormsg("Please Select Centre");
                $('#<%=ddlprocessinglab.ClientID%>').focus();
                return;
            }
           

            if ($('#<%=txtshipmentno.ClientID%>').val() == "") {
                showerrormsg("Please Enter Shipment No");
                $('#<%=txtshipmentno.ClientID%>').focus();
                return;
            }
           
        
            var eqasprogram = jQuery('#<%=ddleqasprogram.ClientID%>').val();

          
            

            if (eqasprogram == "") {
                showerrormsg("Please Select CAP Program");
                return;
            }

            var data = getmappingdata();

            $.blockUI();
            $.ajax({
                url: "CAPShipmentDetail.aspx/saveprogrammapping",
                data: JSON.stringify({ data: data }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,

                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Mapping Saved..!");
                        getsavedmapping();
                        resetmenew();
                    }
                    else {
                        showerrormsg(result.d);
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




        function getsavedmapping() {



            $('#tbl1 tr').slice(1).remove();

            var processinglabid = $('#<%=ddlprocessinglab.ClientID%>').val();

            var length = $('#<%=ddlprocessinglab.ClientID%> > option').length;
            if (length == 0 || processinglabid=="0") {
                showerrormsg("Please Select Centre");
                $('#<%=ddlprocessinglab.ClientID%>').focus();
                return;
            }
            $.blockUI();
            $.ajax({
                url: "CAPShipmentDetail.aspx/getprogramlist",
                data: '{processinglabid: "' + processinglabid + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,

                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);

                    for (i = 0; i < PanelData.length; i++) {

                        var mydata = "";
                        mydata += '<tr style="background-color:lightgreen;" class="GridViewItemStyle" name="' + PanelData[i].id + '" id="' + PanelData[i].programid + '">';
                        mydata += '<td  align="left" >' + parseInt(i + 1) + '</td>';
                        mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownew(this)"/></td>';
                        mydata += '<td align="left">' + PanelData[i].centre + '</td>';

                       
                        mydata += '<td align="left">' + PanelData[i].ShipmentNo + '</td>';
                        mydata += '<td align="left">' + PanelData[i].ShipDate + '</td>';
                        mydata += '<td align="left">' + PanelData[i].DueDate + '</td>';
                        mydata += '<td align="left">' + PanelData[i].Mailing + '</td>';
                        mydata += '<td align="left">' + PanelData[i].Note + '</td>';
                        mydata += '<td align="left">' + PanelData[i].programname + '</td>';
                        mydata += '<td align="left">' + PanelData[i].testname + '</td>';
                        mydata += '<td align="left">' + PanelData[i].entrydatetime + '</td>';
                        mydata += '<td align="left">' + PanelData[i].EntryByName + '</td>';
                        mydata += '</tr>';

                        $('#tbl1').append(mydata);
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



        function deleterownew(itemid) {
            if (confirm("Do You Want To Delete This Mapping?")) {
                var id = $(itemid).closest('tr').attr('name');




                jQuery.ajax({
                    url: "CAPShipmentDetail.aspx/deletedata",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        showmsg("Data Deleted..");
                        var table = document.getElementById('tbl1');
                        table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                    },


                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });


            }
        }
    </script>

    <script type="text/javascript">


        function exporttoexcel() {
            var processinglabid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var length = $('#<%=ddlprocessinglab.ClientID%> > option').length;
            if (length == 0 || processinglabid=="0") {
                showerrormsg("Please Select Centre");
                $('#<%=ddlprocessinglab.ClientID%>').focus();
                return;
            }



          


            jQuery.ajax({
                url: "CAPShipmentDetail.aspx/exporttoexcel",
                data: '{ processinglabid: "' + processinglabid + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d == "false") {
                        showerrormsg("No Item Found");
                        $.unblockUI();
                    }
                    else {
                        window.open('../Common/exporttoexcel.aspx');
                        $.unblockUI();
                    }

                },


                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }


  </script>

</asp:Content>

