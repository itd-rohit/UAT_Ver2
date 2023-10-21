<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="InvestigationAutoApproveMaster.aspx.cs" Inherits="Design_Investigation_InvestigationAutoApproveMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        function ViewDetails(country) {
            var ss = ' ../OPD/Signature/' + country + '.jpg';
            $find("<%=modelurgent.ClientID%>").show();
            $('#mmc').attr('src', ss);
            return false;
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Test AutoApprove Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>


        <div class="POuter_Box_Inventory">
            
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Business Zone   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" CssClass="ddlBusinessZone chosen-select chosen-container">
                    </asp:DropDownList>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">State   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlState" runat="server" onchange="bindcentre()">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Test Centre  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddltestcentre" runat="server" onchange="binddoctor()" />
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">Doctor Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlappby" runat="server"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Department Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="ddlDepartment chosen-select chosen-container"/>
                </div>
                <div class="col-md-3"> </div>
                <div class="col-md-6">
                    <a style="font-weight: bold;" href="InvestigationAutoApproveCentre.aspx">Set Test For AutoApproved</a>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" class="savebutton" value="Save" onclick="SaveData()" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Saved data
            </div>
            <div class="row">
                <div style="width: 100%; overflow: auto; height: 410px;">
                    <table style="width: 100%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                        <tr id="saheader">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px; text-align: left;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align: left;">Centre</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align: left;">Department</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align: left;">Doctor</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align: left;">View Sign</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 50px; text-align: left;">Delete</th>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <asp:Panel ID="panelurgent" runat="server" BackColor="#EAF3FD" BorderStyle="None" Style="display: none;">
        <div class="Outer_Box_Inventory" style="width: 400px; text-align: center">

            <div style="text-align: center;">
                <img id="mmc" />
                <br />
                <asp:Button ID="btncloseurgent" runat="server" Text="Close" />
            </div>

        </div>
    </asp:Panel>
    <asp:Button ID="Button1" runat="server" Style="display: none;" />
    <cc1:ModalPopupExtender ID="modelurgent" runat="server" CancelControlID="btncloseurgent" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelurgent">
    </cc1:ModalPopupExtender>
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
                binddata();
            });

            function bindState() {
                jQuery("#ddlState option").remove();
                jQuery("#ddltestcentre option").remove();
                jQuery("#ddlappby option").remove();
                serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: 0, BusinessZoneID: jQuery("#ddlBusinessZone").val() }, function (response) {
                    stateData = jQuery.parseJSON(response);
                    if (stateData.length == 0) {
                        jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#ddlState").bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });
                    
                    };
                });
            }




            function bindcentre() {

                jQuery("#ddltestcentre option").remove();
                jQuery("#ddlappby option").remove();
                serverCall('InvestigationAutoApproveMaster.aspx/bindcentre', { StateID:jQuery("#ddlState").val() }, function (response) {           
                    zoneData = jQuery.parseJSON(response);
                    if (zoneData.length == 0) {
                        jQuery("#ddltestcentre").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#ddltestcentre").bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'centreid', textField: 'centre', isSearchAble: true });

                   
                    }

                });
            
            }

            function binddoctor() {

                jQuery("#ddlappby option").remove();
                serverCall('InvestigationAutoApproveMaster.aspx/binddoctor', { centreid:jQuery("#ddltestcentre").val() }, function (response) {           
                    zoneData = jQuery.parseJSON(response);
                    if (zoneData.length == 0) {
                        jQuery("#ddlappby").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#ddlappby").bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'employeeid', textField: 'Name', isSearchAble: true });

                    
                    }

                });
            
            }

            function SaveData() {

                $('#lblMsg').html('');
                var length1 = $('#<%=ddltestcentre.ClientID %>  option').length;
            if ($("#<%=ddltestcentre.ClientID %> option:selected").val() == "0" || length1 == 0) {
                toast('Error',"Please Select Centre");
                $("#<%=ddltestcentre.ClientID %>").focus();
                return;
            }
            var length2 = $('#<%=ddlappby.ClientID %>  option').length;
            if ($("#<%=ddlappby.ClientID %> option:selected").val() == "0" || length2 == 0) {
                toast('Error',"Please Select Doctor");
                $("#<%=ddlappby.ClientID %>").focus();
                return;
            }

            var length3 = $('#<%=ddlDepartment.ClientID %>  option').length;
            if ($("#<%=ddlDepartment.ClientID %> option:selected").val() == "0" || length3 == 0) {
                toast('Error',"Please Select Department");
                $("#<%=ddlDepartment.ClientID %>").focus();
                return;
            }
            serverCall('InvestigationAutoApproveMaster.aspx/savedata', { centreid:jQuery("#ddltestcentre").val(),docid:  jQuery("#ddlappby").val() ,deptid:  jQuery("#ddlDepartment").val()  }, function (response) {           
                if (response == "1") {
                    toast('Success',"Record Saved");
                    binddata();
                }
                else {
                    toast('Error',response);
                }
            });
            
        }

        function binddata() {
            $('#tb_ItemList tr').slice(1).remove();
            serverCall('InvestigationAutoApproveMaster.aspx/binddata', {  }, function (response) {           
                TestData = $.parseJSON(response);

                if (TestData.length == 0) {
                    return;
                }
                else {

                    for (var i = 0; i <= TestData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push("<tr id='");$Tr.push(TestData[i].id);$Tr.push("'  style='background-color:white;'>");
                        $Tr.push('<td class="GridViewLabItemStyle">');$Tr.push(parseInt(i + 1));$Tr.push('</td>');
                        $Tr.push('<td class="GridViewLabItemStyle"><b>');$Tr.push(TestData[i].centre);$Tr.push('</b></td>');
                        $Tr.push('<td class="GridViewLabItemStyle"><b>');$Tr.push(TestData[i].Department);$Tr.push('</b></td>');
                        $Tr.push('<td class="GridViewLabItemStyle"><b>');$Tr.push(TestData[i].ApproveByName);$Tr.push('</b></td>');
                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:left;"><img src="../../App_Images/view.gif" style="cursor:pointer;" ');
                        $Tr.push('onclick="ViewDetails(\'');$Tr.push(TestData[i].approvebyid);$Tr.push('\')"/></td>');
                        $Tr.push('<td class="GridViewLabItemStyle"><img src="../../App_Images/delete.gif" style="cursor:pointer;width:20px;height:20px;" ');
                        $Tr.push('onclick="deleteme(\'');$Tr.push(TestData[i].id);$Tr.push('\')"/></td>');
                        $Tr.push("</tr>");
                        $Tr = $Tr.join("");
                        $('#tb_ItemList').append($Tr);
                    }
                }

            });
           

        }

        function deleteme(id) {
            serverCall('InvestigationAutoApproveMaster.aspx/deletedata', { ID: id }, function (response) {

                if (response == "1") {
                    toast('Success', "Record Deleted");
                    binddata();
                }
                else {
                    toast('Error', response);
                }
            });

        }
    </script>

</asp:Content>

