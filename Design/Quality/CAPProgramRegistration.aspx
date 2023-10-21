<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CAPProgramRegistration.aspx.cs" Inherits="Design_Quality_CAPProgramRegistration" %>
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
                          <b>CAP Program Registration</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>

              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                          <td style="font-weight: 700">Processing Lab :</td>
                          <td><asp:DropDownList ID="ddlcentre" runat="server" Width="400px" class="ddlprocessinglab chosen-select chosen-container" onchange="bindshipment()"></asp:DropDownList></td>
                          <td style="font-weight: 700">Shipment No:</td>
                          <td><asp:DropDownList ID="ddlshipment" runat="server" class="ddlshipment chosen-select chosen-container" Width="350px" ></asp:DropDownList>&nbsp;<input type="button" value="Add Program" class="searchbutton" onclick="addmenow('0')" id="btnadd" />&nbsp;&nbsp;
                              <input type="button" value="Reset" class="resetbutton" onclick="resetme()" />
                          </td>
                    </tr>
                   
                    <tr>
                          <td style="font-weight: 700" colspan="4">
                               <div class="Purchaseheader">
                    
                  <table>
                <tr>
                 
                     <td>Test List</td>
                     <td> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                          &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                     </td>
                    <td>Saved Test</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>New Test</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:lemonchiffon;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                   
                    
                </tr>
            </table>
                  
                  </div>
                              <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
           <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">


                  
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle">Shipment</td>
                                        <td class="GridViewHeaderStyle">Ship Date</td>
                                        <td class="GridViewHeaderStyle">Due Date</td>
                                        <td class="GridViewHeaderStyle">Program</td>
                                        <td class="GridViewHeaderStyle">Last Status</td>
                                        <td class="GridViewHeaderStyle">Test</td>
                                        <td class="GridViewHeaderStyle">Specimen <input type="text" id="txtsphead" placeholder="Set For All" style="width:80px" onkeyup="showme2(this)" name="t1"  /></td>
                                        <td class="GridViewHeaderStyle">RegDate</td>
                                        <td class="GridViewHeaderStyle">VisitId</td>
                                        <td class="GridViewHeaderStyle">SinNo</td>
                                        <td class="GridViewHeaderStyle" style="width:50px;"><input type="checkbox" id="chall" onclick="checkall(this)" /></td>
                                        
                                        
                                       
                            </tr>
                            </table>
                      </div>

                              </td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">

                             <input type="button" value="New Specimen" class="searchbutton" onclick="addmenow('1')" id="btnnew" style="display:none;" />
                          
                            &nbsp;&nbsp;&nbsp;
                            <input type="button" value="Save" class="savebutton" onclick="savemenow()" />
                        </td>
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
         

             bindshipment();

         });

            function showme2(ctrl) {
                var val = $(ctrl).val();
                var name = $(ctrl).attr("name");
                $('input[name="' + name + '"]').each(function () {
                    $(this).val(val);
                });
            }

            function checkall(ctrl) {
                if ($(ctrl).prop('checked') == true) {
                    $('#tbl tr').each(function () {
                        $(this).closest("tr").find('#ch').prop('checked', true);
                    });
                }
                else {
                    $('#tbl tr').each(function () {
                        $(this).closest("tr").find('#ch').prop('checked', false);
                    });
                }
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



         function bindshipment() {
          

             var labid = $('#<%=ddlcentre.ClientID%>').val();
             jQuery('#<%=ddlshipment.ClientID%> option').remove();
             $('#<%=ddlshipment.ClientID%>').trigger('chosen:updated');
             
             if (labid != "0" && labid !=null) {


                 $.blockUI();
                 $.ajax({
                     url: "CAPProgramRegistration.aspx/bindshipment",
                     data: '{labid: "' + labid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Shipment Found");
                         }

                         jQuery("#<%=ddlshipment.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Shipment No"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlshipment.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].shipmentno).html(CentreLoadListData[i].shipmentno));
                         }

                         $("#<%=ddlshipment.ClientID%>").trigger('chosen:updated');





                         $.unblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                         $.unblockUI();
                     }
                 });
             }
         }

               




           </script>

    <script type="text/javascript">
        function addmenow(type) {
            var length = $('#<%=ddlcentre.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlcentre.ClientID%>').val() == "0") {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }


            var length1 = $('#<%=ddlshipment.ClientID%> > option').length;
            if (length1 == 0) {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlshipment.ClientID%>').val() == "0") {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlshipment.ClientID%>').focus();
                return;
            }


           




            $('#tbl tr').slice(1).remove();
            $('#txtsphead').val('');
            $('#chall').prop('checked', false);
            $.blockUI();
            jQuery.ajax({
                url: "CAPProgramRegistration.aspx/SearchProgram",
                data: '{centreid: "' + $('#<%=ddlcentre.ClientID%>').val() + '",shipmentno:"' + $('#<%=ddlshipment.ClientID%>').val() + '",type:"'+type+'"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        showerrormsg("No Program Found");
                        $.unblockUI();
                        return;
                    }
                    var labid = "";
                   
                    for (var i = 0; i <= PanelData.length - 1; i++) {

                       
                        var color = "lemonchiffon";
                        if (PanelData[i].sinno != "") {
                           
                            color = "lightgreen";
                        }
                        var mydata = "";
                       
                        mydata += '<tr style="background-color:' + color + ';" class="GridViewItemStyle tr_clone" id=' + PanelData[i].InvestigationID + '>';
                        
                        mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';
                      
                        mydata += '<td align="left" id="shipment">' + PanelData[i].ShipmentNo + '</td>';
                        mydata += '<td align="left" id="shipdate">' + PanelData[i].ShipDate + '</td>';
                        mydata += '<td align="left" id="duedate">' + PanelData[i].DueDate + '</td>';
                        mydata += '<td align="left" id="programname">' + PanelData[i].ProgramName + '</td>';
                        mydata += '<td align="left" id="laststatus">' + PanelData[i].lastStatus + '</td>';
                       
                        mydata += '<td align="left" id="testname">' + PanelData[i].InvestigationName + '</td>';
                        if (PanelData[i].sinno == "") {
                            mydata += '<td align="left" id="specimen"><input type="text" id="txtspecimen" name="t1" value="' + PanelData[i].Specimen + '" /></td>';
                        }
                        else {
                            mydata += '<td align="left" id="specimen"><input type="text" id="txtspecimen" readonly="readonly" value="' + PanelData[i].Specimen + '" /></td>';
                        }
                        mydata += '<td align="left" id="visitdate">' + PanelData[i].visitdate + '</td>';
                        mydata += '<td align="left" id="isitid">' + PanelData[i].visitno + '</td>';
                        mydata += '<td align="left" id="sinno">' + PanelData[i].sinno + '</td>';
                        if (PanelData[i].sinno == "") {
                            mydata += '<td align="left"><input type="checkbox" id="ch"/></td>';
                        }
                        else {
                            mydata += '<td align="left"></td>';
                        }
                       
                        mydata += '<td align="left" id="centreid" style="display:none;">' + PanelData[i].CentreId + '</td>';
                        mydata += '<td align="left" id="shipmentno" style="display:none;">' + PanelData[i].ShipmentNo + '</td>';
                        mydata += '<td align="left" id="programid" style="display:none;">' + PanelData[i].ProgramID + '</td>';
                        mydata += '<td align="left" id="testid" style="display:none;">' + PanelData[i].InvestigationID + '</td>';

                        mydata += '<td align="left" id="SubCategoryID" style="display:none;">' + PanelData[i].SubCategoryID + '</td>';
                        mydata += '<td align="left" id="Itemname" style="display:none;">' + PanelData[i].Itemname + '</td>';
                        mydata += '<td align="left" id="ItemID" style="display:none;">' + PanelData[i].ItemID + '</td>';
                        mydata += '<td align="left" id="TestCode" style="display:none;">' + PanelData[i].TestCode + '</td>';
                        mydata += '<td align="left" id="ReportType" style="display:none;">' + PanelData[i].ReportType + '</td>';
                        mydata += '</tr>';
                       
                        $('#tbl').append(mydata);
                    }
                    if (PanelData[PanelData.length-1].LedgerTransactionID != "0") {
                        $('#btnnew').show();
                    }
                    else {
                        $('#btnnew').hide();
                    }

                    $("#<%=ddlcentre.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                    $("#<%=ddlshipment.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                    $("#btnadd").attr("disabled", true);
                    
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert("Error ");
                }
            });


        }

       
        function resetme() {
            $("#<%=ddlcentre.ClientID%>").attr("disabled", false).prop('selectedIndex', 0).trigger('chosen:updated');
            $("#<%=ddlshipment.ClientID%>").attr("disabled", false).prop('selectedIndex', 0).trigger('chosen:updated');
            $("#btnadd").attr("disabled", false);
            $('#tbl tr').slice(1).remove();
            $('#txtsphead').val('');
            $('#chall').prop('checked', false);
        }

    </script>

    <script type="text/javascript">

        function GetDataToSave() {

            var dataIm = new Array();
            $('#tbl tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "tblheader" && $(this).closest("tr").find('#ch').prop('checked')) {
                    var ProData = new Object();

                    ProData.CentreID = $(this).closest("tr").find('#centreid').html();
                    ProData.ShipmentNo = $(this).closest("tr").find('#shipmentno').html();
                    ProData.ProgramID = $(this).closest("tr").find('#programid').html();
                    ProData.InvestigationID = $(this).closest("tr").find('#testid').html();
                    ProData.Specimen = $(this).closest("tr").find('#txtspecimen').val();

                    ProData.SubCategoryID = $(this).closest("tr").find('#SubCategoryID').html();
                    ProData.ItemId = $(this).closest("tr").find('#ItemID').html();
                    ProData.ItemName = $(this).closest("tr").find('#Itemname').html();
                    ProData.TestCode = $(this).closest("tr").find('#TestCode').html();
                    ProData.InvestigationName = $(this).closest("tr").find('#testname').html();
                    ProData.ReportType = $(this).closest("tr").find('#ReportType').html();
                    dataIm.push(ProData);
                }
            });



           

            return dataIm;
        }


        function savemenow() {

            var length = $('#<%=ddlcentre.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlcentre.ClientID%>').val() == "0") {
                showerrormsg("Please Select Centre");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }


            var length1 = $('#<%=ddlshipment.ClientID%> > option').length;
            if (length1 == 0) {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlcentre.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlshipment.ClientID%>').val() == "0") {
                showerrormsg("Please Select Shipment No");
                $('#<%=ddlshipment.ClientID%>').focus();
                return;
            }
            var count = $('#tbl tr').length;
            if (count == 0 || count == 1) {
                showerrormsg("Please Add Program");
                return;
            }



            var sn11 = 0;
            $('#tbl tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "tblheader" && $(this).closest("tr").find('#ch').prop('checked')) {
                    if ($(this).find('#txtspecimen').val() == "") {
                        sn11 = 1;
                        $(this).find('#txtspecimen').focus();
                        return;
                    }
                }
            });

            if (sn11 == 1) {
                showerrormsg("Please Enter Specimen ");
                return;
            }


            var DataToSave = GetDataToSave();

            if (DataToSave.length == 0) {
                showerrormsg("Please Select Test");
                return;
            }

            $.blockUI();
            $.ajax({
                url: "CAPProgramRegistration.aspx/savedata",
                data: JSON.stringify({ DataToSave: DataToSave }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {
                       
                        showmsg("CAP Program Registered Successfully");
                        addmenow('0');
                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    console.log(xhr.responseText);
                }
            });
        }

    </script>
</asp:Content>

