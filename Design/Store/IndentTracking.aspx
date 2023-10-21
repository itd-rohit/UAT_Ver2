<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="IndentTracking.aspx.cs" Inherits="Design_Store_IndentTracking" %>

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
                          <b>Indent Tracking</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table>
                    <tr>
                        <td style="font-weight:bold;">
                            Enter Indent No:
                        </td>
                       <td>
                           <asp:TextBox ID="txtindentno" runat="server" Width="180px" />
                       </td>
                        <td>
                            <input type="button" value="Search" onclick="searchindent()" class="searchbutton" />
                        </td>
                    </tr>
                </table>
                </div>
              </div>


            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div style="height:450px;overflow:auto;">
                <table width="99%">
                    <tr>

                        <td width="34%" valign="top">
                            <div class="Purchaseheader">Indent Detail
                      </div>

                            <table width="99%" style="background-color:aqua;font-weight:bold;">
                                <tr>
                                    <td id="tdindenttype"></td>
                                    <td id="tdindentno"></td>

                                   
                                </tr>

                                  <tr>
                                    <td id="tdindentdate" colspan="2"></td>
                                </tr>
                                 <tr>
                                    <td id="tdfromlocation" colspan="2"></td>
                                </tr>
                                 <tr>
                                    <td id="tdtolocation" colspan="2"></td>
                                </tr>
                            </table>

                            
                        </td>
                          <td width="1%"></td>
                        <td width="65%" valign="top">
                              <div class="Purchaseheader">Item Detail
                      </div>
                         <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        <td class="GridViewHeaderStyle">Sr.No</td>
                                        <td class="GridViewHeaderStyle">ItemID</td>
                                        <td class="GridViewHeaderStyle">ItemName</td>
                                        <td class="GridViewHeaderStyle">ReqQty</td>
                                        <td class="GridViewHeaderStyle">CheckQty</td>
                                        <td class="GridViewHeaderStyle">ApproveQty</td>
                                        <td class="GridViewHeaderStyle">RejectQty</td>
                                        <td class="GridViewHeaderStyle">IssueQty</td>
                                        <td class="GridViewHeaderStyle">ReceiveQty</td>
                                       
                        </tr>
                             </table>
                        </td>
                      
                        
                    </tr>

                    <tr>
                        <td colspan="3">
                              <div class="Purchaseheader">Dispatch Detail
                              </div>

                              <table id="mytable" width="99%" style="width:99%;border-collapse:collapse;text-align:left;">
                                  <tr id="tr1">
                                        <td class="GridViewHeaderStyle">Sr.No</td>
                                        <td class="GridViewHeaderStyle">ItemID</td>
                                        <td class="GridViewHeaderStyle">ItemName</td>
                                        <td class="GridViewHeaderStyle">IssueInvoiceNo</td>
                                        <td class="GridViewHeaderStyle">SendDate</td>
                                        <td class="GridViewHeaderStyle">BatchNumber</td>
                                        <td class="GridViewHeaderStyle">BatchCreatedDate</td>
                                        <td class="GridViewHeaderStyle">NoofBoxSend</td>
                                        <td class="GridViewHeaderStyle">DispatchOption</td>
                                        <td class="GridViewHeaderStyle">DispatchDate</td>
                                        <td class="GridViewHeaderStyle">CourierName</td>
                                        <td class="GridViewHeaderStyle">AWBNumber</td>
                                        <td class="GridViewHeaderStyle">ReceiveDate</td>
                                        <td class="GridViewHeaderStyle">NoofBoxReceive</td>
                                      
                                      
                                      
                                       
                        </tr>
                                  </table>
                        </td>
                    </tr>
                </table>
                </div></div>
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

         function searchindent() {

             if ($('#<%=txtindentno.ClientID%>').val() == "") {
                 $('#<%=txtindentno.ClientID%>').focus();
                 showerrormsg("Please Enter Indent No To Search");
                 return;
             }

             $.blockUI();
             $('#tblitemlist tr').slice(1).remove();
             $.ajax({
                 url: "IndentTracking.aspx/BindItemDetail",
                 data: '{IndentNo:"' + $('#<%=txtindentno.ClientID%>').val() + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                        $.unblockUI();

                    }
                    else {
                        
                        $('#tdindenttype').html("Indent Type: "+ItemData[0].indenttype);
                        $('#tdindentno').html("Indent No: " + ItemData[0].indentno);
                        $('#tdindentdate').html("Indent Date: " + ItemData[0].IndentDate);
                        $('#tdfromlocation').html("From Location: " + ItemData[0].FromLocation);
                        $('#tdtolocation').html("To Location: " + ItemData[0].ToLocation);

                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = '';
                            mydata += "<tr style='background-color:lightgreen;' id='" + ItemData[i].itemid + "'>";


                            mydata += '<td  class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].itemid + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].itemname + '</td>';

                         
                            mydata += '<td  class="GridViewLabItemStyle">' + precise_round(ItemData[i].reqqty, 5) + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + precise_round(ItemData[i].checkedqty, 5) + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + precise_round(ItemData[i].approvedqty, 5) + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + precise_round(ItemData[i].rejectqty, 5) + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + precise_round(ItemData[i].IssueQty, 5) + '</td>';
                            mydata += '<td  class="GridViewLabItemStyle">' + precise_round(ItemData[i].ReceiveQty, 5) + '</td>';
                           
                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);
                        }


                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $.unblockUI();

                }
             });

             binddetail();
         }


         function binddetail() {

             if ($('#<%=txtindentno.ClientID%>').val() == "") {
                  $('#<%=txtindentno.ClientID%>').focus();
                 showerrormsg("Please Enter Indent No To Search");
                 return;
             }

             $.blockUI();
             $('#mytable tr').slice(1).remove();
             $.ajax({
                 url: "IndentTracking.aspx/binddispatchdetail",
                 data: '{IndentNo:"' + $('#<%=txtindentno.ClientID%>').val() + '"}', // parameter map      
                 type: "POST",
                 timeout: 120000,

                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (result) {
                     ItemData = jQuery.parseJSON(result.d);

                     if (ItemData.length == 0) {
                         showerrormsg("No Dispatch Detail Found");
                         $.unblockUI();

                     }
                     else {

                        

                         for (var i = 0; i <= ItemData.length - 1; i++) {
                             var mydata = '';
                             mydata += "<tr style='background-color:lightgoldenrodyellow;' id='" + ItemData[i].itemid + "'>";


                             mydata += '<td  class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].itemid + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].Itemname + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].issueinvoiceno + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].senddate + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].BatchNumber + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].BatchCreatedDateTime + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].NoofBox + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].DispatchOption + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].DispatchDate + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].CourierName + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].AWBNumber + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].ReceiveDate + '</td>';
                             mydata += '<td  class="GridViewLabItemStyle">' + ItemData[i].NoofBoxReceive + '</td>';

                             mydata += "</tr>";
                             $('#mytable').append(mydata);
                         }


                         $.unblockUI();

                     }

                 },
                 error: function (xhr, status) {
                     alert(xhr.responseText);
                     $.unblockUI();

                 }
             });
         }
         function precise_round(num, decimals) {
             return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
         }

     </script>
</asp:Content>

