<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ChangeInvestigationReportType.aspx.cs" Inherits="Design_Lab_ChangeInvestigationReportType" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>

     <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>

    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
  <div id="Pbody_box_inventory" style="width:97%;">
          <div class="POuter_Box_Inventory" style="width:99.6%;">
<div class="content" style="text-align:center; ">   
<b>Change Report Type</b>&nbsp;<br />
<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
   
</div>
</div>
      <div class="POuter_Box_Inventory" style="width:99.6%;">
            <div class="content">

                <table width="99%">
                  
                    <tr>
                    <td style="width: 21%; text-align: right"> From Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">

                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">To Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                   
                </tr>

                    <tr>
                        <td style="width: 21%; text-align: right" >Lab No &nbsp;:  &nbsp;</td>
                          <td style="text-align: left; width: 30%;">
                            <asp:TextBox ID="txtLabNo" runat="server" Width="110px" /> 
                              </td>
                        
                   <td style="width: 20%; text-align: right">Test :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                         <asp:DropDownList ID="ddlinvestigation" class="ddlinvestigation  chosen-select" Width="280px" runat="server">
                        </asp:DropDownList>
                        </td>
                            
                    </tr>

                    <tr>
                        <td></td>
                        <td></td>
                        <td >
                            <input type="button" id="btnsearch" onclick="GetData()" value="Search"  class="savebutton" />
                       
                        </td>
                    </tr>
                </table>
               
                </div>
              </div> 
         
         <div class="POuter_Box_Inventory" style="width:99.6%;">
             <div class="Purchaseheader">
                Report Type Search &nbsp; &nbsp; 
            </div>
            <div class="content"> 
    <div class="TestDetail" style="margin-top: 5px; max-height: 405px; overflow: scroll; width: 100%;" border="1">
                                            <table id="tbItemList" style="width: 99%; border-collapse: collapse">
                                                <tr id="header">
                                                    <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                                    <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Lab No</td>
                                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Test</td>
                                                     <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Report Type In Transaction</td>
                                                     <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Report Type In Master</td>
                                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Action</td>

                                                </tr>
                                            </table>
                                        </div>
                </div>
             </div>
   
  </div>
   
            <script type="text/javascript">
                $(document).ready(function () {
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
                   
                    BindTest();
                });



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
        function BindTest() {
            $modelBlockUI();

            var ddlDoctor = $("#<%=ddlinvestigation.ClientID %>");

                 $("#<%=ddlinvestigation.ClientID %> option").remove();
                   ddlDoctor.append($("<option></option>").val("").html(""));



                   $.ajax({

                       url: "ChangeInvestigationReportType.aspx/GetTestMaster",
                       data: '{}', // parameter map
                       type: "POST", // data has to be Posted    	        
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       dataType: "json",
                       success: function (result) {
                           PanelData = $.parseJSON(result.d);
                           if (PanelData.length == 0) {
                           }
                           else {
                               ddlDoctor.append($("<option></option>").val(0).html("select"));
                               for (i = 0; i < PanelData.length; i++) {

                                   ddlDoctor.append($("<option></option>").val(PanelData[i]["testid"]).html(PanelData[i]["testname"]));
                               }
                           }
                           ddlDoctor.trigger('chosen:updated');

                           $modelUnBlockUI();
                       },
                       error: function (xhr, status) {
                           // alert("Error ");

                           ddlDoctor.trigger('chosen:updated');

                           $modelUnBlockUI();
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });

              
           };


  
    </script>


     <script type="text/javascript">


         function GetData() {
             debugger;
             $modelBlockUI();
             var fromdate = $('#<%=txtFromDate.ClientID%>').val();
             var todate = $('#<%=txtToDate.ClientID%>').val();
             var labno = $('#<%=txtLabNo.ClientID%>').val();
             var itemid = $('#<%=ddlinvestigation.ClientID%> option:selected').val();
             if (labno == "") {
                 if (itemid == "" || itemid == "0")
                 {
                     showerrormsg("please select test");
                     $modelUnBlockUI();
                     return;
                 }
             }
             $.ajax({
                 url: "ChangeInvestigationReportType.aspx/GetData",
                 data: '{ fromdate: "' +fromdate + '",todate:"'+todate+'",labno:"'+labno+'",itemid:"'+itemid+'"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                  
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        $('#tbItemList tr').slice(1).remove();
                        $modelUnBlockUI();
                    }
                    else {
                        $modelUnBlockUI();
                     
                        $('#tbItemList tr').slice(1).remove();
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr >";
                            mydata += '<td >' + parseInt(i + 1) + '</td>';
                            mydata += '<td id="LedgerTransactionNO">' + ItemData[i].LedgerTransactionNO + '</td>';
                            mydata += '<td id="testname">' + ItemData[i].ItemName + '</td>';
                            mydata += '<td id="treport">' + ItemData[i].treport + '</td>';
                            mydata += '<td id="mreport">' + ItemData[i].mreport + '</td>';
                            mydata += '<td id="reportype" style="display:none;" > <input type="text"   name="reporttype"  value=' + ItemData[i].ReportType + ' ></td>';
                            mydata += '<td id="masterReportType"  style="display:none;" >' + ItemData[i].masterReportType + '</td> '
                            mydata += '<td id="testid" style="display:none;">' + ItemData[i].Test_ID + '</td> '
                            mydata += ' <td>  <input id="btnUpdate" type="button" value="Update" class="searchbutton" onclick="UpdateData(this);" /> </td></tr>'
                            $('#tbItemList').append(mydata);
                        }
                      
                       
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                  
                }
            });
         }




         function UpdateData(ctrl) {
             $modelBlockUI();
             var testid = $(ctrl).closest('tr').find("#testid").text();
         
             var masterreporttype = $(ctrl).closest('tr').find("#masterReportType").text();
             

                 $.ajax({
                     url: "ChangeInvestigationReportType.aspx/UpdateData",
                     data: '{ testid: "' + testid + '",reporttype:"' + masterreporttype + '"}', // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             $modelUnBlockUI();
                             showmsg("Update successfully");
                             GetData();
                         }
                         else {
                             showerrormsg("somthing went wrong");
                             $modelUnBlockUI();
                         }
                     }
                 });

            



         }
          </script>
</asp:Content>


