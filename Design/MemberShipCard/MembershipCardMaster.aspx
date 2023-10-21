<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MembershipCardMaster.aspx.cs" Inherits="Design_MemberShipCard_MembershipCardMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Membership Card Master<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-3 ">&nbsp;</div>
                <div class="col-md-3 ">
                    <label class="pull-left">Card Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtCardName" runat="server"  MaxLength="50" CssClass="requiredField"></asp:TextBox>

                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Description   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtDescription" runat="server"  MaxLength="100" CssClass="requiredField"></asp:TextBox>

                </div>
            </div>


            <div class="row">
                <div class="col-md-3 ">&nbsp;</div>
                <div class="col-md-3 ">
                    <label class="pull-left">No. of Dependant   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:DropDownList ID="ddlDependant" runat="server"  CssClass="requiredField" class="ddlDependant chosen-select">
                        <asp:ListItem Value="0">Select</asp:ListItem>
                        <asp:ListItem Value="1">1</asp:ListItem>
                        <asp:ListItem Value="2">2</asp:ListItem>
                        <asp:ListItem Value="3">3</asp:ListItem>
                        <asp:ListItem Value="4">4</asp:ListItem>
                        <asp:ListItem Value="5">5</asp:ListItem>
                        <asp:ListItem Value="6">6</asp:ListItem>
                        <asp:ListItem Value="7">7</asp:ListItem>
                        <asp:ListItem Value="8">8</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Card Amount   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtCardAmount" runat="server"  MaxLength="6" AutoCompleteType="Disabled" CssClass="requiredField"></asp:TextBox>              
                                <cc1:FilteredTextBoxExtender ID="ftCardAmount" runat="server" TargetControlID="txtCardAmount" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>


                </div>
            </div>
            <div class="row">
                <div class="col-md-3 ">&nbsp;</div>
                <div class="col-md-3 ">
                    <label class="pull-left">Validity   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                   <input type="text" id="txtYears" style="width:33%;float:left" onlynumber="5"  onkeyup="$getValidity();"  class="requiredField"   max-value="10"  autocomplete="off"  maxlength="3"   placeholder="Years"/>          
                     <input type="text" id="txtMonths" style="width:33%;float:left" onlynumber="5" onkeyup="$getValidity();" class="requiredField"   max-value="12"  autocomplete="off"  maxlength="2"    placeholder="Months"/>                      
                     <input type="text" id="txtDays" style="width:33%;float:left"  onlynumber="5" onkeyup="$getValidity();" class="requiredField"  max-value="30"  autocomplete="off"  maxlength="2"   placeholder="Days"/>							         

                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Valid Upto</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <input type="text"  id="txtValidUpTo" disabled="disabled" />
                     
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 ">&nbsp;</div>
                <div class="col-md-3 ">
                    <label class="pull-left">Status</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:RadioButtonList ID="rblIsActive" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                        <asp:ListItem Value="0">De-Active</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left"></label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5 ">
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveMembership()" />
            <input type="button" id="btnUpdate" style="display: none" class="ItDoseButton" value="Update" onclick="$updateMembership()" />
            <input type="button" id="btnCancel" style="display: none" class="ItDoseButton" value="Cancel" onclick="$cancelMembership()" />
            <span id="spnID" style="display:none"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div style="height: 460px; max-height: 460px; min-height: 460px; overflow: hidden; overflow-y: auto; width: 100%; overflow-x: auto">
                <table style="border-collapse: collapse; width: 100%" id="tblMembership">
                    <thead>
                        <tr id="DefaultHead">
                            <th class="GridViewHeaderStyle" style="width: 30px;">S.No.</th>
                            <th class="GridViewHeaderStyle" style="width: 120px;">Card Name</th>
                            <th class="GridViewHeaderStyle" style="width: 220px;">Description</th>
                            <th class="GridViewHeaderStyle" style="width: 80px;">No.of Dependant</th>
                            <th class="GridViewHeaderStyle" style="width: 80px;">Card Amount</th>
                            <th class="GridViewHeaderStyle" style="width: 80px;">Validity</th>
                            <th class="GridViewHeaderStyle" style="width: 60px;">Valid UpTo</th>
                            <th class="GridViewHeaderStyle" style="width: 60px;">Status</th>
                            <th class="GridViewHeaderStyle" style="width: 60px;">Select</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyData">
                    </tbody>
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
            $("#ddlDependant").chosen('destroy').chosen();
        });
        $validation = function () {
            if ($.trim($("#txtCardName").val()) == "") {
                toast("Error", "Please Enter Card Name", "");
                $("#txtCardName").focus();
                return false;
            }
            if ($.trim($("#txtDescription").val()) == "") {
                toast("Error", "Please Enter Card Description", "");
                $("#txtDescription").focus();
                return false;
            }
            if ($("#ddlDependant").val() == "0") {
                toast("Error", "Please Select No. of Dependant", "");
                $("#ddlDependant").focus();
                return false;
            }
            if ($.trim($("#txtCardAmount").val()) == "") {
                toast("Error", "Please Enter Card Amount", "");
                $("#txtCardAmount").focus();
                return false;
            }
            if ($.trim($("#txtYears").val()) == "") {
                toast("Error", "Please Enter Card Validity in years", "");
                $("#txtYears").focus();
                return false;
            }
            if ($.trim($("#txtMonths").val()) == "") {
                toast("Error", "Please Enter Card Validity in months", "");
                $("#txtMonths").focus();
                return false;
            }
            if ($.trim($("#txtDays").val()) == "") {
                toast("Error", "Please Enter Card Validity in days", "");
                $("#txtDays").focus();
                return false;
            }

            return true;
        }
        $(function () {
            $bindDetail();
            var $table = $("#tblMembership");
            $table.delegate("tr.clickablerow", "click", function () {
                $table.find("tr.clickablerow").removeClass('rowColor');
                $(this).addClass('rowColor');
            });
        });
        $bindDetail = function () {
            jQuery("#tblMembership tr:not(#DefaultHead)").remove();
            serverCall('MembershipCardMaster.aspx/bindMembershipData', {}, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    MembershipDetails = jQuery.parseJSON($responseData.responseDetail);
                    if (MembershipDetails != null) {

                        for (var i = 0; i < MembershipDetails.length; i++) {
                            var $Tr = [];
                            $Tr.push("<tr class='clickablerow'>");

                            $Tr.push("<td class='GridViewLabItemStyle'  style='text-align:left'> "); $Tr.push(i + 1); $Tr.push("</td>");

                            $Tr.push("<td style='text-align:left' id='tdCardName' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].CardName); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' id='tdDescription' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].Description); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:right' id='tdNoofdependant' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].No_of_dependant); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:right' id='tdAmount' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].Amount); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' id='tdValidity' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].Validity); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:center' id='tdValiditUpTo' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].ValidUpTo); $Tr.push("</td>");

                            $Tr.push("<td style='text-align:left' id='tdActive' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].Active); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:center' valign='top' class='GridViewLabItemStyle'><img style='cursor:pointer' src='../../App_Images/Post.gif' onclick='$selectMembershio(this)'> "); $Tr.push("</td>");


                            $Tr.push("<td style='text-align:left;display:none' id='tdID' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].ID); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left;display:none' id='tdIsActive' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].IsActive); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left;display:none' id='tdValidYear' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].ValidYear); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left;display:none' id='tdValidMonth' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].ValidMonth); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left;display:none' id='tdValidDays' valign='top' class='GridViewLabItemStyle'>"); $Tr.push(MembershipDetails[i].ValidDays); $Tr.push("</td>");

                            $Tr.push("</tr>");
                            $Tr = $Tr.join("");
                            jQuery("#tblMembership").append($Tr);
                        }

                    }
                };

            })
        }
        $selectMembershio = function (rowID) {
            $modelBlockUI();
            $("#btnUpdate,#btnCancel").show();
            $("#btnSave").hide();
            $("#spnID").text($(rowID).closest('tr').find("#tdID").html());
            $("#txtCardName,#txtDescription,#txtCardAmount,#txtYears,#txtMonths,#txtDays,#txtValidUpTo").val('');
            $("#txtCardName").val($(rowID).closest('tr').find("#tdCardName").html());
            $("#txtDescription").val($(rowID).closest('tr').find("#tdDescription").html());
            $("#txtCardAmount").val($(rowID).closest('tr').find("#tdAmount").html());          
            $("#ddlDependant").val($(rowID).closest('tr').find("#tdNoofdependant").html());
            jQuery("#txtYears").val($(rowID).closest('tr').find("#tdValidYear").html()),
            jQuery("#txtMonths").val($(rowID).closest('tr').find("#tdValidMonth").html()),
            jQuery("#txtDays").val($(rowID).closest('tr').find("#tdValidDays").html()),
            jQuery("#txtValidUpTo").val($(rowID).closest('tr').find("#tdValiditUpTo").html()),
            
            $("#rblIsActive input[value=" + $(rowID).closest('tr').find("#tdIsActive").html() + "]").prop("checked", "checked");
            $modelUnBlockUI();
        }
        $saveMembership = function () {
            if (!$validation())
                return false;
            var $membershipData = $membershipDetail();
            serverCall('MembershipCardMaster.aspx/saveMembership', { MembershipData: $membershipData }, function (response) {
                var $responseData = JSON.parse(response);

                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                    $cancelMembership();
                    $bindDetail();
                }
                else {
                    toast("Error", $responseData.response, "");
                }

            });
        };

        $updateMembership = function () {
            if (!$validation())
                return false;
            var $membershipData = $membershipDetail();
            serverCall('MembershipCardMaster.aspx/updateMembership', { MembershipData: $membershipData }, function (response) {
                var $responseData = JSON.parse(response);

                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                    $cancelMembership();
                    $bindDetail();
                }
                else {
                    toast("Error", $responseData.response, "");
                }

            });
        };
        $cancelMembership = function () {
            $("#txtCardName,#txtDescription,#txtCardAmount").val('');
            $("#ddlDependant").prop('selectedIndex', 0);
            $("#btnUpdate,#btnCancel").hide();
            $("#btnSave").show();
            $("#spnID").text('');
            var $table = $("#tblMembership");
          
                $table.find("tr.clickablerow").removeClass('rowColor');
             
                
        };
        var $getValidity = function () {
           
            var $Validyear = "0";
            var $Validmonth = "0";
            var $Validday = "0";
            if (jQuery('#txtYears').val() != "") {
                if (jQuery('#txtYears').val() > 10) {
                    toast("Error", "Please Enter Valid Validity in Years", "");
                    jQuery('#txtYears').val('');
                }
                $Validyear = jQuery('#txtYears').val();
            }
            if (jQuery('#txtMonths').val() != "") {
                if (jQuery('#txtMonths').val() > 12) {
                    toast("Error", "Please Enter Valid Validity in Months", "");
                    jQuery('#txtMonths').val('');
                }
                $Validmonth = jQuery('#txtMonths').val();

            }
            if (jQuery('#txtDays').val() != "") {
                if (jQuery('#txtDays').val() > 30) {
                    toast("Error", "Please Enter Valid Validity in Days", "");
                    jQuery('#txtDays').val('');
                }
                $Validday = jQuery('#txtDays').val();
            }
            var d = new Date(); // today!
            if ($Validday != "")
                d.setDate(parseInt(d.getDate()) + parseInt($Validday));
            if ($Validmonth != "")
                d.setMonth(parseInt(d.getMonth()) + parseInt($Validmonth));
            if ($Validyear != "")
                d.setFullYear(parseInt(d.getFullYear()) + parseInt($Validyear));
            var m_names = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            jQuery('#txtValidUpTo').val(xxx);
           
        }
        minTwoDigits = function (n) {
            return (n < 10 ? '0' : '') + n;
        }
        $membershipDetail = function () {
            var $objMem = new Array();
            $objMem.push({
                CardName: jQuery.trim(jQuery('#txtCardName').val()),
                Description: jQuery.trim(jQuery("#txtDescription").val()),
                NoOfDependant: jQuery('#ddlDependant').val(),
                Amount: jQuery.trim(jQuery('#txtCardAmount').val()),
             
                IsActive: jQuery('#rblIsActive input[type=radio]:checked').val(),
                ValidYear: jQuery("#txtYears").val(),
                ValidMonth: jQuery("#txtMonths").val(),
                ValidDays: jQuery("#txtDays").val(),
                ValidUpTo: jQuery("#txtValidUpTo").val(),
                ID: $("#spnID").text()
            });
            return $objMem;
        }
    </script>
</asp:Content>

