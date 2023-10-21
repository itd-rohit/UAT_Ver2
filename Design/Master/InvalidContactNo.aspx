<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InvalidContactNo.aspx.cs" Inherits="Design_Master_InvalidContactNo" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
     <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Invalid ContactNo Master</b>         
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Manage ContactNo
            </div>
            <div class="row">
                 <div class="col-md-3">
                     &nbsp;
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">Contact No.</label>
                                <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:TextBox ID="txtContactNo" runat="server" MaxLength="10" CssClass="requiredField"></asp:TextBox>
                     <cc1:FilteredTextBoxExtender ID="ftbContactNo" runat="server" TargetControlID="txtContactNo"  FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                     </div>
                <div class="col-md-1">                                  
                     </div>
                </div>
            <div class="row">
                 <div class="col-md-3">
                     &nbsp;
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">Status</label>
                                <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal">
                         <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                         <asp:ListItem  Value="0">DeActive</asp:ListItem>
                     </asp:RadioButtonList>
                                          </div>
                <div class="col-md-1">                                  
                     </div>
                </div>
             </div>
             <div class="POuter_Box_Inventory" style="text-align: center">           
              <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="$saveData()" />&nbsp;&nbsp;
                <input type="button" id="btnCancel" value="Cancel" class="ItDoseButton" onclick="$cancelData()"  style="display:none"/>
                </div>
          <div class="POuter_Box_Inventory" style="text-align: center">
              <span id="spnID" style="display:none"></span>
          <div id="divContactDetail" style="width: 100%; height: 300px;margin-left:20%">                                  
                            <table id="tblContact" style="border-collapse: collapse;width:40%" >
                                <thead>
                                <tr id="Header" >                                                                                                       
                                   <th class="GridViewHeaderStyle" scope="col" style="width:6%">S.No</th>
                                   <th class="GridViewHeaderStyle" scope="col" style="width:10%" >Contact No.</th>					
					               <th class="GridViewHeaderStyle" scope="col" style="width:10%">Status</th> 
					               <th class="GridViewHeaderStyle" scope="col" style="width:6%">Select</th>                                   
                                </tr>
                                    </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
               </div>
          </div>
     <script type="text/javascript">
         $selectContactNo = function (rowID) {
             $("#txtContactNo").val(jQuery(rowID).closest('tr').find("#tdContact").text());            
             $("#rblStatus input[value=" + (jQuery(rowID).closest('tr').find("#tdIsActive").text() + "]")).prop('checked','checked');             
             $("#spnID").text(jQuery(rowID).closest('tr').find("#tdID").text());
             $("#btnSave").val('Update');
             $("#btnCancel").show();
         }
         $saveData = function () {
             if ($("#txtContactNo").val() == "") {
                 toast("Error", "Please Enter ContactNo", "");
                 $("#txtContactNo").focus();
                 return;
             }
             serverCall('InvalidContactNo.aspx/saveContactNo', { ContactNo: $("#txtContactNo").val(), typeData: $("#btnSave").val(), ID: $.trim($("#spnID").text()), StatusID: $("#rblStatus input[type=radio]:checked").val() }, function (response) {
                 $responseData = JSON.parse(response);
                 if ($responseData.status) {
                     toast("Success", $responseData.response, "");
                     if ($("#btnSave").val() == "Update") {
                         $("#tblContact tbody tr").find("".concat('.tdContact_', $.trim($("#spnID").text()))).text($("#txtContactNo").val());
                         $("#tblContact tbody tr").find("".concat('.tdStatus_', $.trim($("#spnID").text()))).text($("#rblStatus input[type=radio]:checked").next().text());
                         $("#tblContact tbody tr").find("".concat('.tdStatusID_', $.trim($("#spnID").text()))).text($("#rblStatus input[type=radio]:checked").val());
                     }
                     else {
                         $bindContactDetail($responseData);
                     }
                 }
                 else {
                     toast("Error", $responseData.response, "");
                 }
                 $cancelData();
             });
         }
    $(function () {
        $bindContact();
    });
    $cancelData = function () {
        $("#btnSave").val('Save');
        $("#btnCancel").hide();
        $("#spnID").text('');
        $("#txtContactNo").val('');
        $("#rblStatus input[value=1]").prop('checked', 'checked');
    }
    $bindContact = function () {
        jQuery("#tblContact tr:not(#Header)").remove();
        serverCall('InvalidContactNo.aspx/contactDetail', {}, function (response) {
            $bindContactDetail(JSON.parse(response));
        });
    }
    $bindContactDetail = function (response) {
        jQuery("#tblContact tr:not(#Header)").remove();
        var $responseData = jQuery.parseJSON(response.responseDetail);
        jQuery('#tblContact').css('display', 'block');
        if ($responseData != null) {
            for (var i = 0; i < $responseData.length; i++) {
                var $appendText = [];
                $appendText.push('<tr class="GridViewItemStyle" id="trContact_'); $appendText.push($responseData[i].ID); $appendText.push('">');
                $appendText.push('<td  style="font-weight:bold;text-align: center"> '); $appendText.push(i + 1); $appendText.push('</td>');
                $appendText.push('<td id="tdContact" style="font-weight:bold;text-align: left" class="tdContact_'); $appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].ContactNo); $appendText.push('</td>');
                $appendText.push('<td id="tdStatus" style="font-weight:bold;text-align: left" class="tdStatus_');$appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].Status); $appendText.push('</td>');
                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push("<img onclick='$selectContactNo(this)' src='../../App_Images/view.gif' style='width: 15px; cursor:pointer'/>"); $appendText.push('</td>');
                $appendText.push('<td id="tdID"  style="font-weight:bold;display:none"> '); $appendText.push($responseData[i].ID); $appendText.push('</td>');
                $appendText.push('<td id="tdIsActive"  style="font-weight:bold;display:none" class="tdStatusID_'); $appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].IsActive); $appendText.push('</td>');
                $appendText.push("</tr>");
                $appendText = $appendText.join("");
                jQuery('#tblContact').append($appendText);
            }
        }
    }
      </script>
</asp:Content>

