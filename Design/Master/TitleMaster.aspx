<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TitleMaster.aspx.cs" Inherits="Design_Master_TitleMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>


      <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Title With Gender Master</b>
           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Manage Title
            </div>
            <div class="row">
                 <div class="col-md-5">
&nbsp;
                     </div>
                <div class="col-md-2">
                    <label class="pull-left">Title</label>
                                <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-3">
                     <asp:DropDownList ID="ddlTitle" runat="server" CssClass="requiredField" ></asp:DropDownList>
                     </div>
                <div class="col-md-1">
                                  <input type="button" class="ItDoseButton" value="New" id="btnNew"  title="Click to Add New Titler"  onclick="$openNewTitile()" />

                     </div>

                </div>
            <div class="row">
                <div class="col-md-5">
&nbsp;
                     </div>
                <div class="col-md-2">
                    <label class="pull-left">Gender</label>
                                <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-3">
                     <asp:DropDownList ID="ddlGender" runat="server" CssClass="requiredField"  >
                         <asp:ListItem  Value="Male">Male</asp:ListItem>
                         <asp:ListItem Value="Female">Female</asp:ListItem>
                          <asp:ListItem Value="Trans">Transgender</asp:ListItem>
                         <asp:ListItem Value="UnKnown">UnKnown</asp:ListItem>
                     </asp:DropDownList>
                     <span id="spnTitleID"  style="display:none"></span>
                     </div>
            </div>
          </div>
          <div class="POuter_Box_Inventory" style="text-align: center">           
              <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="$saveData()" />&nbsp;&nbsp;
                <input type="button" id="btnCancel" value="Cancel" class="ItDoseButton" onclick="$cancelData()"  style="display:none"/>
                </div>
          <div class="POuter_Box_Inventory" style="text-align: center">
          <div id="divTitleDetail" style="height: 300px;margin-left:36%;overflow:auto;">
                                   
                            <table id="tblTitle" style="border-collapse: collapse;width:40%" >
                                <thead>
                    <tr id="Header" >                                                                                                       
                    <th class="GridViewHeaderStyle" scope="col" style="width:6%">S.No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:10%" >Title</th>
					<th class="GridViewHeaderStyle" scope="col" style="width:10%">Gender</th> 
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

      <div id="divAddTitle" tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:30%">
				<div class="modal-header">
                    <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">New Title </h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt">
					Press esc or click<button type="button" class="closeModel" data-dismiss="divAddTitle" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-6">
							   <label class="pull-left">Title</label>
							   <b class="pull-right">:</b>
						  </div>
						   <div  class="col-md-8" >
							  <input type="text" autocomplete="off"  id="txtTitle" class="requiredField"  maxlength="10" data-title="Enter Title" />    
						  </div>
                        <div  class="col-md-10" >
                            </div>
					</div>	
                    <div class="row">
                    <div id="divTitleMaster" style="height: 300px;">
                                   
                            <table id="tblTitleMaster" style="border-collapse: collapse;width:100%" >
                                <thead>
                                <tr id="trTitleHeader" >                                                                                                       
                                   <th class="GridViewHeaderStyle" scope="col" style="width:6%">S.No</th>
                                   <th class="GridViewHeaderStyle" scope="col" style="width:20%" >Title</th>														                            
                                </tr>
                                    </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    
                    </div>
                    								                                       
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveTitle({Title:jQuery.trim(jQuery('#txtTitle').val())})">Save</button>
						 <button type="button"  data-dismiss="divAddTitle" >Close</button>
				</div>
			</div>
		</div>
	</div>
    <script type="text/javascript">

        function $bindTitleMasterDetail() {
            jQuery("#tblTitleMaster tr:not(#trTitleHeader)").remove();
            serverCall('TitleMaster.aspx/titleMasterDetail', {}, function (response) {
                var $responseData = JSON.parse(response);
                jQuery('#tblTitleMaster').css('display', 'block');
                if ($responseData != null) {
                    for (var i = 0; i < $responseData.length; i++) {
                        var $appendText = [];
                        $appendText.push('<tr class="GridViewItemStyle" '); $appendText.push('">');
                        $appendText.push('<td  style="font-weight:bold;text-align: center"> '); $appendText.push(i + 1); $appendText.push('</td>');
                        $appendText.push('<td id="tdTitle" style="font-weight:bold;text-align: left" class="tdTitleMaster_'); $appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].Title); $appendText.push('</td>');
                        $appendText.push('<td id="tdID"  style="font-weight:bold;display:none"> '); $appendText.push($responseData[i].ID); $appendText.push('</td>');

                        $appendText.push("</tr>");
                        $appendText = $appendText.join("");
                        jQuery('#tblTitleMaster').append($appendText);
                    }
                }
            });
        }


        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divAddTitle').is(':visible')) {
                    jQuery('#divAddTitle').hideModel();
                }           
            }
        }
        $openNewTitile = function () {
            jQuery('#divAddTitle input[type=text]').val('');
            jQuery('#divAddTitle').showModel();
            jQuery('#txtTitle').focus();
            $bindTitleMasterDetail();
        }
        $saveData = function () {
            if ($("#btnSave").val() == "Update" && $.trim($("#spnTitleID").text()) == "") {
                toast("Error", "Please Select Title", "");
                return;
            }
            serverCall('TitleMaster.aspx/saveData', { title: $("#ddlTitle").val(), gender: $("#ddlGender").val(), typeData: $("#btnSave").val(), ID: $.trim($("#spnTitleID").text()) }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                    if ($("#btnSave").val() == "Update") {
                        $("#tblTitle tbody tr").find("".concat('.tdTitle_', $.trim($("#spnTitleID").text()))).text($("#ddlTitle").val());
                        $("#tblTitle tbody tr").find("".concat('.tdGender_', $.trim($("#spnTitleID").text()))).text($("#ddlGender").val());
                    }
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
        $saveTitle = function (titleDetails) {
            if (titleDetails.Title.trim() == "") {
                toast("Error", "Please Enter Title", "");
                titleDetails.Title.focus();
                return;
            }
            serverCall('TitleMaster.aspx/saveTitle', { titleName: titleDetails.Title }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                    jQuery('#divAddTitle').hideModel();
                    $("#ddlTitle").append($('<option />').val($responseData.title).text($responseData.title));
                    $("#ddlTitle").val($responseData.title);
                  
                    var $appendText = [];
                    $appendText.push('<tr class="GridViewItemStyle" '); $appendText.push('">');
                    $appendText.push('<td  style="font-weight:bold;text-align: center"> '); $appendText.push(jQuery('#tblTitleMaster tr').length); $appendText.push('</td>');
                    $appendText.push('<td id="tdTitle" style="font-weight:bold;text-align: left" class="tdTitleMaster_'); $appendText.push($responseData.lastID); $appendText.push('">'); $appendText.push($responseData.title); $appendText.push('</td>');
                    $appendText.push('<td id="tdID"  style="font-weight:bold;display:none"> '); $appendText.push($responseData.lastID); $appendText.push('</td>');
                    $appendText.push("</tr>");
                    $appendText = $appendText.join("");
                    jQuery('#tblTitleMaster').append($appendText);

                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
        function $bindTitleDetail() {
            jQuery("#tblTitle tr:not(#Header)").remove();
            serverCall('TitleMaster.aspx/titleDetail', {}, function (response) {
               var $responseData = JSON.parse(response);
               jQuery('#tblTitle').css('display', 'block');
               if ($responseData != null) {
                   for (var i = 0; i < $responseData.length; i++) {
                       var $appendText = [];
                       $appendText.push('<tr class="GridViewItemStyle" id="trTitle_'); $appendText.push($responseData[i].ID); $appendText.push('">');
                       $appendText.push('<td  style="font-weight:bold;text-align: center"> '); $appendText.push(i + 1); $appendText.push('</td>');
                       $appendText.push('<td id="tdTitle" style="font-weight:bold;text-align: left" class="tdTitle_'); $appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].Title); $appendText.push('</td>');
                       $appendText.push('<td id="tdGender" style="font-weight:bold;text-align: left" class="tdGender_'); $appendText.push($responseData[i].ID); $appendText.push('">'); $appendText.push($responseData[i].Gender); $appendText.push('</td>');
                       $appendText.push('<td id="tdStatus" style="font-weight:bold;text-align: left">'); $appendText.push($responseData[i].Status); $appendText.push('</td>');
                       $appendText.push('<td  style="font-weight:bold;">'); $appendText.push("<img onclick='$selectTitle(this)' src='../../App_Images/view.gif' style='width: 15px; cursor:pointer'/>"); $appendText.push('</td>');
                       $appendText.push('<td id="tdID"  style="font-weight:bold;display:none"> '); $appendText.push($responseData[i].ID); $appendText.push('</td>');

                       $appendText.push("</tr>");
                       $appendText = $appendText.join("");
                       jQuery('#tblTitle').append($appendText);
                   }
               }
            });         
        }
        $selectTitle = function (rowID) {
            $("#ddlTitle").val(jQuery(rowID).closest('tr').find("#tdTitle").text());
            $("#ddlGender").val(jQuery(rowID).closest('tr').find("#tdGender").text());
            $("#spnTitleID").text(jQuery(rowID).closest('tr').find("#tdID").text());
            $("#btnSave").val('Update');
            $("#btnCancel").show();
        }

        $(function () {
            $bindTitleDetail();
        });
        $cancelData = function () {
            $("#btnSave").val('Save');
            $("#btnCancel").hide();
            $("#spnTitleID").text('');
        }

    </script>
</asp:Content>

