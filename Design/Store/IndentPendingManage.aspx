<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="IndentPendingManage.aspx.cs" Inherits="Design_Store_IndentPendingManage" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
     
     <%: Scripts.Render("~/bundles/JQueryStore") %>


    <style type="text/css">

        .chosen-container {
            width:800px !important;
        }
    </style>
     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

     

    <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" >
               <div class="row"  style="text-align: center">
                <div class="col-md-24">
              <b>Indent Pending Manage</b>
                     </div>
                    </div>
                <div class="row"  style="text-align: center">
                     <div class="col-md-5">
                         </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Current Location </b> </label>
                    <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <asp:DropDownList ID="ddllocation" runat="server"  ></asp:DropDownList>
                        </div>
                     <div class="col-md-4">
                         <input type="button" value="Search Pending Stock" onclick="binddata()" class="searchbutton" />
                         </div>
                     <div class="col-md-4">
                         <input type="button" class="savebutton" onclick="savealldata()" id="btnsave" style="display:none;" value="Save" />
                         </div>
                    </div>
            <div class="content">

                
                </div>
              </div>
          <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-24">
             <div style="width:100%;max-height:375px;overflow:auto;">
                <table id="tblitemlist" style="width:100%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">                                       
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>                                        
                                        <td class="GridViewHeaderStyle">Item</td>
                                        <td class="GridViewHeaderStyle">Batch Number</td>
                                        <td class="GridViewHeaderStyle">Expiry Date</td>
                                        <td class="GridViewHeaderStyle">Pending Qty</td>
                                        <td class="GridViewHeaderStyle">Pending Remarks</td>
                                        <td class="GridViewHeaderStyle">Indent No</td>                                                                            
                                        <td class="GridViewHeaderStyle" style="display:none;">Consume&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="consumeremarks" onkeyup="showme2(this)"  placeholder="All Consume Remarks" /> </td>
                                        <td class="GridViewHeaderStyle">Stock In</td>
                                        <td  class="GridViewHeaderStyle">#</td>                                                                                                                 
                        </tr>
                </table>
                </div></div></div>             
              </div>
        </div>   
    <asp:Panel ID="pnl" runat="server" style="display:none;border:1px solid;" BackColor="aquamarine" Width="1100px" >

       
                 <div class="Purchaseheader">
                      Indent Detail
                      </div>

        <div class="row">
                <div class="col-md-24">
         <div style="width:100%;max-height:375px;overflow:auto;">



                <table id="Table1" style="width:100%;border-collapse:collapse;text-align:left;">
                    <tr id="tr1">
                                        
                                   
                                        <td class="GridViewHeaderStyle">Indent Date</td>
                                        <td class="GridViewHeaderStyle">Indent No.</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">Indent From Loccation</td>
                                        <td class="GridViewHeaderStyle">Indent To Loccation</td>
                                        <td class="GridViewHeaderStyle">Approved Qty.</td>
                                        <td class="GridViewHeaderStyle">Unit</td>
                                        <td class="GridViewHeaderStyle">IssueQty</td>
                                        <td class="GridViewHeaderStyle">ReceiveQty</td>
                                        <td class="GridViewHeaderStyle">RejectQty</td>
                                              
                                     
                                       
                                        
                                     
                        </tr>
                </table>
             </div></div>
                </div>
         <div class="row"  style="text-align: center">
                <div class="col-md-24">
                <asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" /> 
               </div></div>
    </asp:Panel>

         <cc1:ModalPopupExtender ID="modelpopup1" runat="server"   TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button2" runat="server" style="display:none" />    
    <script type="text/javascript">     
        function binddata() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                $('#tblitemlist tr').slice(1).remove();
                toast("Error", "Please Select Location");
                return;              
            }         
            $('#tblitemlist tr').slice(1).remove();
            serverCall('IndentPendingManage.aspx/bindcompletedata', { locationid: $('#<%=ddllocation.ClientID%>').val() }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Pending Stock Found");
                    $('#btnsave').hide();
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr style='background-color:white;' id='");$Tr.push(ItemData[i].stockid); $Tr.push("'>");
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(parseInt(i + 1));$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" >');$Tr.push(ItemData[i].ItemName);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].batchnumber);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].ExpiryDate);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdissueqty" style="font-weight:bold;">');$Tr.push(precise_round(ItemData[i].pendingqty, 5));$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" id="tdissueqty" style="font-weight:bold;">');$Tr.push(ItemData[i].PendingRemarks);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" ><a style="font-weight:bold;cursor:pointer;color:blue" onclick="showme(this)">');$Tr.push(ItemData[i].IndentNo);$Tr.push('</a></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="background-color:aqua;display:none;"><input type="text" onkeyup="showme1(this);" style="width:80px;" id="txtconsume" placeholder="Consume Qty"  />&nbsp;&nbsp;<input type="text" placeholder="Consume Remarks" maxlength="180" id="txtconsumeremarks" name="consumeremarks"/>   <input style="cursor:pointer;font-weight:bold;display:none;" type="button" value="Consume" onclick="consumeme(this)" /></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="background-color:pink;"><input type="text" onkeyup="showme1(this);" style="width:80px;" id="txtstockin" placeholder="Stock IN Qty"/><input style="cursor:pointer;font-weight:bold;display:none;" type="button" value="Stock In" onclick="stockinme(this)"  /></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" ><input type="checkbox" id="chk"  /></td>');
                        $Tr.push('<td style="display:none;" id="tdlocationid">');$Tr.push(ItemData[i].locationid);$Tr.push('</td>');
                        $Tr.push('<td style="display:none;" id="tdpanelid">');$Tr.push(ItemData[i].panel_id);$Tr.push('</td>');
                        $Tr.push('<td style="display:none;" id="tdItemID">');$Tr.push(ItemData[i].itemid);$Tr.push('</td>');
                        $Tr.push('<td style="display:none;" id="tdIndentNo">');$Tr.push(ItemData[i].IndentNo);$Tr.push('</td>');
                        $Tr.push('<td style="display:none;" id="tdMinorUnitInDecimal">');$Tr.push(ItemData[i].MinorUnitInDecimal);$Tr.push('</td>');
                        $Tr.push('<td style="display:none;" id="tdIssueInvoiceNo">');$Tr.push(ItemData[i].IssueInvoiceNo);$Tr.push('</td>');
                        $Tr.push("</tr>");
                        $Tr = $Tr.join("");
                        $('#tblitemlist').append($Tr);
                    }
                    $('#btnsave').show();
                }
            });         
        }
        function showme2(ctrl) {           
            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");

            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function showme(ctrl) {
            var indentno = $(ctrl).text();
            $('#Table1 tr').slice(1).remove();
            serverCall('IndentPendingManage.aspx/Indentdata', { indentno: indentno }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error","No Item Found");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr style='background-color:lightyellow;height:35px;font-weight:bold;'>");
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].IndentDate);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].IndentNo);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].ItemName);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].IndentFromLoccation);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].IndentToLoccation);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(precise_round(ItemData[i].ReqQty, 5));$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(ItemData[i].MinorUnitName);$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(precise_round(ItemData[i].PendingQty, 5));$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(precise_round(ItemData[i].ReceiveQty, 5));$Tr.push('</td>');                            
                        $Tr.push('<td class="GridViewLabItemStyle" >');$Tr.push(precise_round(ItemData[i].RejectQty, 5));$Tr.push('</td>');                       
                        $Tr.push("</tr>");
                        $Tr = $Tr.join("");
                        $('#Table1').append($Tr);
                    }
                    $find("<%=modelpopup1.ClientID%>").show();
                    }
            });
            
        }

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function showme1(ctrl) {
            if ($(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "0") {

                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            // alert($(ctrl).closest("tr").find("#txttddisc").text());

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');
                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }
            var recqty = parseFloat($(ctrl).closest('tr').find('#tdissueqty').html());
            var total = recqty;           
            var a = $(ctrl).closest("tr").find("#txtconsume").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtconsume").val());
            var b = $(ctrl).closest("tr").find("#txtstockin").val() == "" ? 0 : parseFloat($(ctrl).closest("tr").find("#txtstockin").val());
            var t1 = parseFloat(a) + parseFloat(b);      
            if (parseFloat(t1) > parseFloat(total)) {
                showerrormsg("Can Not Consume or Stock In  More Then Pending Qty.!");
                $(ctrl).closest("tr").find("#txtconsume").val('');
                $(ctrl).closest("tr").find("#txtstockin").val('');
                $(ctrl).closest('tr').find('#chk').prop('checked', false);
                return;
            }
            if ($(ctrl).closest("tr").find("#txtconsume").val().length > 0 || $(ctrl).closest("tr").find("#txtstockin").val().length > 0) {
                $(ctrl).closest('tr').find('#chk').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#chk').prop('checked', false)
            }
        }
    </script>
    <script type="text/javascript">
        function getconsumedata() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked') && parseFloat($(this).find("#txtconsume").val()) > 0) {
                    var qty = $(this).find("#txtconsume").val() == "" ? 0 : parseFloat($(this).find("#txtconsume").val());
                    if (qty > 0) {
                        var tempData = [];
                        tempData.push($(this).find('#tdlocationid').html());
                        tempData.push($(this).find('#tdpanelid').html());
                        tempData.push($(this).attr("id"));
                        tempData.push($(this).find('#txtconsume').val());
                        tempData.push($(this).find('#tdItemID').html());
                        tempData.push($(this).find('#tdIndentNo').html());
                        tempData.push($(this).find('#tdIssueInvoiceNo').html());
                        tempData.push($(this).find('#txtconsumeremarks').val());
                        dataIm.push(tempData);
                    }
                }
            });
            return dataIm;
        }

        function getstockindata() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked') && parseFloat($(this).find("#txtstockin").val()) > 0) {
                    var qty = $(this).find("#txtstockin").val() == "" ? 0 : parseFloat($(this).find("#txtstockin").val());
                    if (qty > 0) {
                        var tempData = [];
                        tempData.push($(this).find('#tdlocationid').html());
                        tempData.push($(this).find('#tdpanelid').html());
                        tempData.push($(this).attr("id"));
                        tempData.push($(this).find('#txtstockin').val());
                        tempData.push($(this).find('#tdItemID').html());
                        tempData.push($(this).find('#tdIndentNo').html());
                        tempData.push($(this).find('#tdIssueInvoiceNo').html());
                        tempData.push('');
                        dataIm.push(tempData);
                    }
                }
            });
            return dataIm;
        }
        function savealldata() {
            var consumedata = getconsumedata();
            var stockindata = getstockindata();
            if (consumedata.length == 0 && stockindata.length == 0) {
                toast("Error", "Please Select Item To Save");
                return;
            }
            serverCall('IndentPendingManage.aspx/savestock', { consumedata: consumedata, stockindata: stockindata }, function (response) {
                if (response== "1") {
                    toast("Success", "Stock Updated Successfully..!");
                    binddata();
                }
                else {
                    toast("Error", response);
                }
            });          
        }

    </script>
</asp:Content>

