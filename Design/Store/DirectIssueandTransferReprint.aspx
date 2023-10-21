<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DirectIssueandTransferReprint.aspx.cs" Inherits="Design_Store_DirectIssueandTransferReprint" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

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
                          <b>Direct Issue/Stock Transfer Reprint
                            
                          </b>  
                        </td>
                    </tr>
                    </table>
                </div>


              </div>

        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                 <div class="Purchaseheader">
                      </div>
                </div>

              <table width="99%">
                  <tr>
                   <td style="font-weight: 700">Indent No :</td>
                           <td>
                              <asp:TextBox ID="txtindentno" runat="server" Width="160px"></asp:TextBox> </td>

                           <td>
                               From Date :</td>
                           <td>
                            <asp:TextBox ID="txtentrydatefrom" runat="server" Width="160px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </td>

                      <td>To Date :</td>
                      <td>
                            <asp:TextBox ID="txtentrydateto" runat="server" Width="160px" ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </td>


                       <td style="font-weight: 700">&nbsp;</td>
                      <td>
                              &nbsp;</td>
</tr>
                  <tr>
                   <td colspan="6" style="text-align: center">

                       <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />         

                       
                   </td>

                   
</tr>
              </table>


              </div>

        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                 <div class="Purchaseheader">
                      Detail
                      </div>
               
                            <div style="width:99%;max-height:375px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                    <%--  <td class="GridViewHeaderStyle"  style="width:50px;">View Item</td>--%>
                                        <td class="GridViewHeaderStyle" style="width:85px;">Invoice No</td>
                                        <td class="GridViewHeaderStyle">Date</td>
                                       
                                        <td class="GridViewHeaderStyle">Issue From Location</td>
                                       <td class="GridViewHeaderStyle">Issue To Location</td>
                                        <td class="GridViewHeaderStyle">Created User</td>
                                   
                                        <td class="GridViewHeaderStyle">Status</td>
                                        <%--<td class="GridViewHeaderStyle">ExpectedDate</td>--%>
                                       
                                       <td class="GridViewHeaderStyle" style="width:20px;">Invoice</td>
                                       
                                        
                                     
                        </tr>
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

    </script>

     <script type="text/javascript">

         function searchdata() {
            

           
             var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
             var todate = $('#<%=txtentrydateto.ClientID%>').val();
         
             var indentno = $("#<%=txtindentno.ClientID%>").val();
           


             $.blockUI();
             $('#tblitemlist tr').slice(1).remove();
        
             
            
            
            $.ajax({
                url: "DirectIssueandTransferReprint.aspx/SearchData",
                data: '{fromdate:"' + fromdate + '",todate:"' + todate + '",indentno:"' + indentno + '"}', // parameter map      
                type: "POST",
                timeout: 120000,
              
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Indent Found");
                        $.unblockUI();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:" + ItemData[i].Rowcolor + ";' id='" + ItemData[i].indentno + "'>";
                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                            // mydata += '<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>';


                            var c="";
                            mydata += '<td class="GridViewLabItemStyle" ><a style="font-weight:bold;color:blue;cursor:pointer;" onclick="showdetail(this,\'' + c + '\')"> ' + ItemData[i].IssueInvoiceNo + '</a></td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].IndentDate + '</td>';
                            
                           
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ToLocation + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].FromLocation + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].Username + '</td>';
                           
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].Status + '</td>';
                            //mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ExpectedDate + '</td>';
                          
                            
                            mydata += '<td class="GridViewLabItemStyle" style="text-align:center;" >';
                            if (ItemData[i].Status != 'New' && ItemData[i].Status != 'Reject') {
                                mydata += '<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Invoice" onclick="printmeinvoice(this)" />';
                            }
                            mydata += '</td>';

                         

                            mydata += '<td style="display:none;" id="tdlocid" >' + ItemData[i].tolocationid + '</td>';
                            mydata += '<td style="display:none;" id="tdIssueInvoiceNo" >' + ItemData[i].IssueInvoiceNo + '</td>';
                            mydata += "</tr>";


                            $('#tblitemlist').append(mydata);

                        }
                        $.unblockUI();
                        $('.issuediv1').show();

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $.unblockUI();

                }
            });
           
         }


         function printmeinvoice(ctrl) {

             var tdIssueInvoiceNo = $(ctrl).closest('tr').find("#tdIssueInvoiceNo").html();


             if (tdIssueInvoiceNo != "") {
                 for (var a = 0; a <= tdIssueInvoiceNo.split(',').length - 1; a++) {

                     var BatchNumber = tdIssueInvoiceNo.split(',')[a];

                     window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + BatchNumber);
                 }
             }


         }
       </script>
</asp:Content>

