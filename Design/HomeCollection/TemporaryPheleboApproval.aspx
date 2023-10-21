<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TemporaryPheleboApproval.aspx.cs" Inherits="Design_HomeCollection_TemporaryPheleboApproval" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <style type="text/css">
        .multiselect {
            width: 100%;
        }

        .txtClass {
            margin-top: 10px;
            width: 222px;
            height: 20px;
        }

        .chosen-container {
            width: 215px !important;
        }

        .multiselect {
          
        }
    </style>
    <script src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript">
        $(function () {
            jQuery("#tblitemlist").tableHeadFixer({

            });
        });
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager runat="server" ID="sc"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Temporary Phelebo Approval</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>


        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Label ID="lbl_Status" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>

            <div class="Purchaseheader">

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"><b>No of Record</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:DropDownList ID="ddlnoofrecord" runat="server" Font-Bold="true">
                            <asp:ListItem Value="50">50</asp:ListItem>
                            <asp:ListItem Value="100">100</asp:ListItem>
                            <asp:ListItem Value="200">200</asp:ListItem>
                            <asp:ListItem Value="500">500</asp:ListItem>
                            <asp:ListItem Value="1000">1000</asp:ListItem>
                            <asp:ListItem Value="2000">2000</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlSearchState" runat="server" ClientIDMode="Static" class="ddlSearchState chosen-select" onchange="bindSearchCity(this.value);"></asp:DropDownList>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlSearchCity" runat="server" class="ddlSearchCity chosen-select" ClientIDMode="Static">
                            <asp:ListItem Value="">--Select City--</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtsearchvalue" runat="server" placeholder="By Name" />
                    </div>
                    <div class="col-md-2">
                        <input type="button" value="Search" class="searchbutton" onclick="searchitem('')" /></div>
                    <div class="col-md-2">
                        <input type="button" value="Excel" class="searchbutton" onclick="searchitemexcel()" /></div>
                </div>


            </div>
            <div class="row">
                <div class="col-md-6"></div>
                <div class="col-md-1" style="width: 25px; height: 20px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;"
                    onclick="searchitem('0')  ">
                </div>
                <div class="col-md-2">Pending</div>

                <div class="col-md-1" style="width: 25px; height: 20px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;"
                    onclick="searchitem('1')  ">
                </div>

                <div class="col-md-2">Approved</div>
                <div class="col-md-1" style="width: 25px; height: 20px;border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: red;"
                    onclick="searchitem('2')  ">
                </div>
                <div class="col-md-2">Rejected</div>
            </div>
            <div class="row">

                <div style="height: 400px; overflow: auto;">
                    <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr id="header">

                                <th class="GridViewHeaderStyle" style="width: 20px;">#</th>

                                <th class="GridViewHeaderStyle" style="width: 40px;">Name</th>
                                <th class="GridViewHeaderStyle">DOB</th>
                                <th class="GridViewHeaderStyle">Gender</th>
                                <th class="GridViewHeaderStyle">Mobile</th>
                                <th class="GridViewHeaderStyle">Email</th>
                                <th class="GridViewHeaderStyle">Date</th>
                                <th class="GridViewHeaderStyle" style="width: 90px;">Address</th>
                                <th class="GridViewHeaderStyle">City</th>
                                <th class="GridViewHeaderStyle">Pincode</th>
                                <th class="GridViewHeaderStyle">Ducument</th>
                                <th class="GridViewHeaderStyle">Work Location</th>
                                <th class="GridViewHeaderStyle">Join From Date</th>
                                <th class="GridViewHeaderStyle">Join To Date</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                                <th class="GridViewHeaderStyle">Approve</th>
                                <th class="GridViewHeaderStyle">Reject</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>


    </div>
    <div id="popup" style="display: none;">
        <div style="background-color: #000; opacity: 0.7; z-index: 99999; position: fixed; left: 0; top: 0; height: 100%; width: 100%;"></div>
        <div style="background-color: #e9ddde; z-index: 100000; position: absolute; left: 25%; top: 25%; height: 350px; width: 1000px; border: 1px solid #ccc; overflow: auto;">
            <div class="Purchaseheader"><span id="spnTestName">Edit Information</span></div>
            <img src="../../App_Images/Close.png" style="width: 30px; height: 25px; position: absolute; right: 0px; top: -3px; cursor: pointer" onclick="HidePopup();" />


            <asp:Label ID="lblEmployee_ID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Name</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtName"  disabled="true" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left"><b>Age</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDOB" runat="server"  TabIndex="2" ToolTip="Select Date DOB" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtDOB" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Gender</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:DropDownList ID="ddlGender" runat="server" Width="300px" class="ddlGender chosen-select" ClientIDMode="Static">
                        <asp:ListItem Value="Male">Male</asp:ListItem>
                        <asp:ListItem Value="Female">Female</asp:ListItem>
                    </asp:DropDownList>

                </div>
                <div class="col-md-4">
                    <label class="pull-left"><b>City</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtCity" runat="server" Width="210px" ></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Address</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtAddress" runat="server" ></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <label class="pull-left"><b>Pincode</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtPincode" runat="server" ></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Mobile</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtMobile" disabled="true" runat="server" ></asp:TextBox>
                </div>



                <div class="col-md-4">
                    <label class="pull-left"><b>Email</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtEmail" runat="server" ></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Document Type</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:DropDownList ID="ddlDocumentType" runat="server"  class="ddlDocumentType chosen-select" ClientIDMode="Static">
                            <asp:ListItem Text="-Select Document-" Value=""></asp:ListItem>
                            <asp:ListItem Value="PAN No"></asp:ListItem>
                            <asp:ListItem Value="Aadhar Card No"></asp:ListItem>
                            <asp:ListItem Value="Vehicle No"></asp:ListItem>
                            <asp:ListItem Value="Driving Licence No"></asp:ListItem>
                            <asp:ListItem Value="Passport No"></asp:ListItem>
                        </asp:DropDownList>

                    </div>
                <div class="col-md-4">
                    <label class="pull-left"><b>Document No.</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                     <asp:TextBox ID="txtDocumentNo" runat="server"  ></asp:TextBox>
                     </div>
                 </div>

              <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Work-Area State</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                     <asp:ListBox ID="ddlState" CssClass="multiselect" SelectionMode="Multiple"  runat="server" onchange="bindCity();" ClientIDMode="Static"></asp:ListBox>
                    </div>

                   <div class="col-md-4">
                    <label class="pull-left"><b>Work-Area City</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:ListBox ID="ddlCity" CssClass="multiselect" Style="margin-top: 10px;" SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
                    </div>
                  </div>

             <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Vehicle No.</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                     <asp:TextBox ID="txtVehicleNumber" runat="server"  ></asp:TextBox>
                    </div>
                 <div class="col-md-4">
                    <label class="pull-left"><b>Driving License No.</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                     <asp:TextBox ID="txtDrivingLicence" runat="server"  ></asp:TextBox>
                    </div>

                 </div>
               <div class="row" style="text-align:center">
                    <input type="button" id="btnUpdate" value="Update" class="searchbutton"  onclick="UpdateData()" />
               </div>           
        </div>      
    </div>
    <div id="EditJoingDate" style="display:none;">
        <div style="background-color: #000; opacity: 0.7; z-index: 99999; position: fixed; left: 0; top: 0; height: 100%; width: 100%;"></div>
        <div style="background-color: #e9ddde; z-index: 100000; position: absolute; left: 25%; top: 25%; height: 300px; width:400px; border: 1px solid #ccc;overflow:auto;">
            <div class="Purchaseheader"><span id="Span2">Edit Joing Date </span></div>
            <img src="../../App_Images/Close.png" style="width: 30px; height: 25px; position: absolute; right: 0px; top: -3px;cursor:pointer" onclick="HideDatePopup();" />

         <div class="row">
       <div class="col-md-8">
                    <label class="pull-left"><b>Joing To Date.</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtJoinTodate_New" runat="server"  disable="flase"  TabIndex="2" ToolTip="Joing To Date" ClientIDMode="Static"></asp:TextBox>
                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtJoinTodate_New" Format="dd-MMM-yyyy"></cc1:CalendarExtender>    
                </div>
              </div>
             <div class="row" style="text-align:center">
                 <input type="button" id="Button2" value="Update" class="searchbutton"  onclick="UpdateJoingDate()" />
                 </div>            
              </div>           
        </div>
   
    <div id="Approve_popup" style="display:none;">
        <div style="background-color: #000; opacity: 0.7; z-index: 99999; position: fixed; left: 0; top: 0; height: 100%; width: 100%;"></div>
        <div style="background-color: #e9ddde; z-index: 100000; position: absolute; left: 25%; top: 25%; height: 300px; width:400px; border: 1px solid #ccc;overflow:auto;">
            <div class="Purchaseheader"><span id="Span1">Approve Phelebonist </span></div>
            <img src="../../App_Images/Close.png" style="width: 30px; height: 25px; position: absolute; right: 0px; top: -3px;cursor:pointer" onclick="HideApprovePopup();" />

         <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Joing From Date</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txt_joinFromDate"  runat="server"    TabIndex="2" ToolTip="Select Joing From Date" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txt_joinFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
              </div>
              <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Joing To Date</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txt_joinTodate" runat="server"   disable="flase"  TabIndex="2" ToolTip="Joing To Date" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_joinTodate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>

                  </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>User Name</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtUserName" runat="server"  ></asp:TextBox>
                    </div>
                </div>
             <div class="row">
                <div class="col-md-4">
                    <label class="pull-left"><b>Password</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtPassword"  runat="server"   ></asp:TextBox>
                    </div>

                 </div>
             <div class="row" style="text-align:center">
                 <input type="button" id="Button1" value="Approve" class="searchbutton"  onclick="Approval()" />
                 </div>                
              </div>            
        </div>
 
    <script type="text/javascript">
        function HidePopup() {
            $('#popup').hide();
        }
        function HideDatePopup() {
            $('#EditJoingDate').hide();
        }

        function HideApprovePopup() {
            $('#Approve_popup').hide();
        }

        jQuery(function () {
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


            jQuery('[id*=ddlState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=ddlCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('#ddlGender').trigger('chosen:updated');
            jQuery('#ddlDocumentType').trigger('chosen:updated');
        });
        function bindCity() {
            var ddlCity = "";
            var StateId = $("#<%=ddlState.ClientID %>").val();
            ddlCity = $("#<%=ddlCity.ClientID %>");
            $("#<%=ddlCity.ClientID %> option").remove();
            serverCall('TemporaryPheleboApproval.aspx/bindCityUpdate', { StateId: StateId }, function (result) {
                CityData = jQuery.parseJSON(result);
                if (CityData.length > 0) {
                    for (i = 0; i < CityData.length; i++) {
                        ddlCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                    }
                }
                jQuery('[id*=ddlCity]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });       
        }
       function searchitem(Status) {
            $('#<%=lbl_Status.ClientID%>').text(Status)

           $('#tblitemlist tr').slice(1).remove();
           serverCall('TemporaryPheleboApproval.aspx/GetData', { searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(), NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val(), SearchState: $('#<%=ddlSearchState.ClientID%>').val(),SearchCity: $('#<%=ddlSearchCity.ClientID%>').val(), Status: Status }, function (result) {
               ItemData = jQuery.parseJSON(result);
               if (ItemData.length == 0) {
                   toast('Info', "No Item Found");

               }
               else {
                   for (var i = 0; i <= ItemData.length - 1; i++) {
                       var mydata = [];
                       if (ItemData[i].IsVerify == '1') {
                           mydata.push("<tr style='background-color:#90EE90;'>");
                       }
                       else if (ItemData[i].IsVerify == '2') {
                           mydata.push("<tr style='background-color:red;'>");
                       }
                       else {
                           mydata.push("<tr style='background-color:bisque;'>");
                       }
                       mydata.push('<td class="GridViewLabItemStyle"  id="" >'); mydata.push((i + 1)); mydata.push('</td>');

                       mydata.push('<td class="GridViewLabItemStyle"  id="tdRouteName" >'); mydata.push(ItemData[i].NAME); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle"  id="tdBusinessZone" >'); mydata.push(ItemData[i].Age); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle"  id="tdState" >'); mydata.push(ItemData[i].Gender); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdCity">'); mydata.push(ItemData[i].Mobile); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].Email); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].dtentry); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].P_Address); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].P_City); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].P_Pincode); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].DucumentNo); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].WorkLocation); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].JoinFromDate); mydata.push('</td>');
                       mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].JoinToDate); mydata.push('</td>');
                       if (ItemData[i].IsVerify == '0') {
                           mydata.push('<td class="GridViewLabItemStyle" id="tdEdit"><input type="button" value="Edit" onclick="showdetailtoupdate('); mydata.push(ItemData[i].Temp_PhlebotomistID); mydata.push(')"   /></td>');
                           mydata.push('<td class="GridViewLabItemStyle" id="tdApproved"><input type="button" value="Approve" onclick="showApproval('); mydata.push(ItemData[i].Temp_PhlebotomistID); mydata.push(')"   /></td>');
                           mydata.push('<td class="GridViewLabItemStyle" id="tdReject"><input type="button" value="Reject" onclick="Reject('); mydata.push(ItemData[i].Temp_PhlebotomistID); mydata.push(')"   /></td>');
                       }
                       else {
                           if (ItemData[i].PhlebotomistID != '') {
                               mydata.push('<td class="GridViewLabItemStyle" id="tdEdit"><input type="button" value="Edit" onclick="BindJoinDatePhelebotomist('); mydata.push(ItemData[i].PhlebotomistID); mydata.push(')"   /></td>');

                           }
                           else {
                               mydata.push('<td class="GridViewLabItemStyle" id="tdEdit"><b>-<b/></td>');
                           }
                           if (ItemData[i].IsVerify == '1') {
                               mydata.push('<td class="GridViewLabItemStyle" id="tdApproved"><b>Approved<b/></td>');
                           }
                           else {
                               mydata.push('<td class="GridViewLabItemStyle" id="tdApproved"><b>Rejected<b/></td>');
                           }
                           mydata.push('<td class="GridViewLabItemStyle" id="tdReject"><b>-<b/></td>');
                       }


                       mydata.push("</tr>");
                       mydata = mydata.join("")
                       $('#tblitemlist').append(mydata);
                   }

               }

           });
           
        }


        function bindSearchCity(StateId) {
            var ddlSearchCity = "";
            ddlSearchCity = $("#<%=ddlSearchCity.ClientID %>");
            $("#<%=ddlSearchCity.ClientID %> option").remove();
            ddlSearchCity.append($("<option></option>").val("").html("--Select City---"));
            serverCall('RouteMaster.aspx/bindSearchCity', { StateId: StateId }, function (result) {
                CityData = jQuery.parseJSON(result);
                if (CityData.length > 0) {
                    for (i = 0; i < CityData.length; i++) {

                        ddlSearchCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                    }
                    jQuery('#ddlSearchCity').trigger('chosen:updated');
                }

            });
            
        }
        function Approval() {
            if ($.trim($("#<%=txt_joinFromDate.ClientID%>").val()) == "") {
                toast('Error', "Please Select From Joing Date.");
                $("#<%=txt_joinFromDate.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txt_joinTodate.ClientID%>").val()) == "") {
                toast('Error', "Please Select To Joing Date.");
                $("#<%=txt_joinTodate.ClientID%>").focus();

                return false;
            }
            if ($.trim($("#<%=txtUserName.ClientID%>").val()) == "") {
                toast('Error', "Please Entre User Name.");
                $("#<%=txtUserName.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtPassword.ClientID%>").val()) == "") {
                toast('Error', "Please Entre Password.");
                $("#<%=txtPassword.ClientID%>").focus();
                return false;
            }
            var tempphelboid = $('#<%=lblEmployee_ID.ClientID%>').text();
            serverCall('TemporaryPheleboApproval.aspx/Approval', { tempphelboid: tempphelboid, JoinFromDate: $.trim($("#<%=txt_joinFromDate.ClientID%>").val()), JoinToDate: $.trim($("#<%=txt_joinTodate.ClientID%>").val()), UserName: $.trim($("#<%=txtUserName.ClientID%>").val()), Password: $.trim($("#<%=txtPassword.ClientID%>").val()) }, function (result) {
                if (result == "-1") {
                    toast('Error', "Your Session Expired...Please Login Again");
                }
                else if (result == "1") {
                    searchitem($('#<%=lbl_Status.ClientID%>').text());
                        toast('Success', "Phelebo Successfully Approved");
                        HideApprovePopup();
                        $("#<%=txt_joinFromDate.ClientID%>").val('');
                        $("#<%=txt_joinTodate.ClientID%>").val('');
                        $("#<%=txtUserName.ClientID%>").val('');
                        $("#<%=txtPassword.ClientID%>").val('');
                    }
                    else if (result.d == "2") {
                        toast('Error', "User name already Exists");
                        $('#<%=txtUserName.ClientID%>').focus()
                    }

                    else {
                        toast('Error', "Please Try Again Later");

                    }
            });
            
        }
        function UpdateJoingDate() {
            if ($.trim($("#<%=txtJoinTodate_New.ClientID%>").val()) == "") {
                toast('Error', "Please Select To Joing Date.");
                $("#<%=txtJoinTodate_New.ClientID%>").focus();
                return false;
            }
            var tempphelboid = $('#<%=lblEmployee_ID.ClientID%>').text();
            serverCall('TemporaryPheleboApproval.aspx/UpdateJoingDate', { tempphelboid: tempphelboid, JoinToDate: $.trim($("#<%=txtJoinTodate_New.ClientID%>").val()) }, function (result) {
                if (result == "-1") {
                    toast('Error', "Your Session Expired...Please Login Again");
                }
                else if (result == "1") {
                    searchitem($('#<%=lbl_Status.ClientID%>').text());
                    toast('Success', "Phelebo Joing ToDate Successfully Update");
                    HideDatePopup();
                    $("#<%=txtJoinTodate_New.ClientID%>").val('');
                }
                else {
                    toast('Error', "Please Try Again Later");
                }
            });
        }
    </script>
    <script type="text/javascript">
        function showdetailtoupdate(Pheleboid) {
            serverCall('TemporaryPheleboApproval.aspx/BindSavePhelebotomist', { Pheleboid: Pheleboid }, function (result) {
                PhelebotomistData = jQuery.parseJSON(result);
                $('#<%=lblEmployee_ID.ClientID%>').text(Pheleboid);
                $('#<%=txtName.ClientID%>').val(PhelebotomistData[0].NAME);
                $('#<%=txtDOB.ClientID%>').val(PhelebotomistData[0].Age);
                $('#<%=ddlGender.ClientID%>').val(PhelebotomistData[0].Gender);
                $('#<%=txtMobile.ClientID%>').val(PhelebotomistData[0].Mobile);
                $('#<%=txtEmail.ClientID%>').val(PhelebotomistData[0].Email);
                $('#<%=txtAddress.ClientID%>').val(PhelebotomistData[0].P_Address);
                $('#<%=txtCity.ClientID%>').val(PhelebotomistData[0].P_City);
                $('#<%=txtPincode.ClientID%>').val(PhelebotomistData[0].P_Pincode);
                $('#<%=txtVehicleNumber.ClientID%>').val(PhelebotomistData[0].Vehicle_Num);
                $('#<%=txtDrivingLicence.ClientID%>').val(PhelebotomistData[0].DrivingLicence);
                $('#<%=ddlDocumentType.ClientID%>').val(PhelebotomistData[0].DucumentType);
                $('#<%=txtDocumentNo.ClientID%>').val(PhelebotomistData[0].DucumentNo);
                jQuery('#ddlGender').trigger('chosen:updated');
                jQuery('#ddlDocumentType').trigger('chosen:updated');
                var State = PhelebotomistData[0].StateId.split(',')
                $('#<%=ddlState.ClientID%>').val(State);
                $('#<%=ddlState.ClientID%>').multipleSelect('refresh');
                bindCity();
                var City = PhelebotomistData[0].CityId.split(',')
                $('#<%=ddlCity.ClientID%>').val(City);
                    $('#<%=ddlCity.ClientID%>').multipleSelect('refresh');
                $('#popup').show();
            });            
        }
        function BindJoinDatePhelebotomist(Pheleboid) {
            serverCall('TemporaryPheleboApproval.aspx/BindJoinDatePhelebotomist', { Pheleboid: Pheleboid }, function (result) {
                PhelebotomistData = jQuery.parseJSON(result);
                $('#<%=lblEmployee_ID.ClientID%>').text(Pheleboid);
                $('#<%=txtJoinTodate_New.ClientID%>').val(PhelebotomistData[0].JoinToDate);
                $('#EditJoingDate').show();
            });
        }
        function UpdateData() {
            if (Validation() == false) {
                return;
            }
            jQuery('#btnUpdate').attr('disabled', true).val("Submitting...");
            var resultPhelebotomistMaster = PhelebotomistMaster();
            serverCall('TemporaryPheleboApproval.aspx/UpdateTempPhelebotomist', { obj: resultPhelebotomistMaster, CityStateId: $('#<%=ddlCity.ClientID%>').val() }, function (result) {
                if (result == "1") {
                    toast('Success', "Record Update Successfully");
                    clearform();
                    searchitem($('#<%=lbl_Status.ClientID%>').text());
                        HidePopup();
                    }
                    else {
                        toast('Error', 'Error...');
                    }
                jQuery('#btnUpdate').attr('disabled', false).val("Update");

            });          
        }
        function Validation() {
            if ($.trim($("#<%=txtName.ClientID%>").val()) == "") {
                toast('Error', "Please Entre Name.");
                $("#<%=txtName.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtDOB.ClientID%>").val()) == "") {
                toast('Error', "Please Select Age.");
                $("#<%=txtDOB.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtAddress.ClientID%>").val()) == "") {
                toast('Error', "Please Entre Address.");
                $("#<%=txtAddress.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtMobile.ClientID%>").val()) == "") {
                toast('Error', "Please Entre Mobile.");
                $("#<%=txtMobile.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=ddlDocumentType.ClientID%>").val()) == "") {
                toast('Error', "Please Select Document Type.");
                $("#<%=ddlDocumentType.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtDocumentNo.ClientID%>").val()) == "") {
                toast('Error', "Please Entre Document No.");
                $("#<%=txtDocumentNo.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=ddlState.ClientID%>").val()) == "") {
                toast('Error', "Please Select Work-Area State.");
                $("#<%=ddlState.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=ddlCity.ClientID%>").val()) == "") {
                toast('Error', "Please Select Work-Area City.");
                $("#<%=ddlCity.ClientID%>").focus();
                return false;
            }
        }
        function PhelebotomistMaster() {
            var objPhelebotomist = new Object();
            objPhelebotomist.PhelebotomistId = $('#<%=lblEmployee_ID.ClientID%>').text();
            objPhelebotomist.NAME = $('#<%=txtName.ClientID%>').val();
            objPhelebotomist.IsActive = "1";
            objPhelebotomist.Age = $('#<%=txtDOB.ClientID%>').val();
            objPhelebotomist.Gender = $('#<%=ddlGender.ClientID%>').val();
            objPhelebotomist.Mobile = $('#<%=txtMobile.ClientID%>').val();
            objPhelebotomist.Other_Contact = '';
            objPhelebotomist.Email = $('#<%=txtEmail.ClientID%>').val();
            objPhelebotomist.FatherName = '';
            objPhelebotomist.MotherName = '';
            objPhelebotomist.P_Address = $('#<%=txtAddress.ClientID%>').val();
            objPhelebotomist.P_City = $('#<%=txtCity.ClientID%>').val();
            objPhelebotomist.P_Pincode = $('#<%=txtPincode.ClientID%>').val();
            objPhelebotomist.BloodGroup = "";
            objPhelebotomist.Qualification = '';
            objPhelebotomist.Vehicle_Num = $('#<%=txtVehicleNumber.ClientID%>').val();
            objPhelebotomist.DrivingLicence = $('#<%=txtDrivingLicence.ClientID%>').val();
            objPhelebotomist.PanNo = '';
            objPhelebotomist.DucumentType = $('#<%=ddlDocumentType.ClientID%>').val();
            objPhelebotomist.DucumentNo = $('#<%=txtDocumentNo.ClientID%>').val();
            objPhelebotomist.JoiningDate = "";
            objPhelebotomist.UserName = "";
            objPhelebotomist.Password = "";
            return objPhelebotomist;
        }
        function clearform() {
            $('#<%=lblEmployee_ID.ClientID%>').text('');
            $('#<%=txtName.ClientID%>').val('');
            $('#<%=txtDOB.ClientID%>').val('');
            $('#<%=ddlGender.ClientID%>').val('Male');
            $('#<%=txtMobile.ClientID%>').val('');
            $('#<%=txtEmail.ClientID%>').val('');
            $('#<%=txtCity.ClientID%>').val('');
            $('#<%=txtAddress.ClientID%>').val('');
            $('#<%=txtPincode.ClientID%>').val('');
            $('#<%=txtVehicleNumber.ClientID%>').val('');
            $('#<%=txtDrivingLicence.ClientID%>').val('');
            $('#<%=ddlDocumentType.ClientID%>').val(0);
            $('#<%=txtDocumentNo.ClientID%>').val('');
            $('#ddlCity option').remove();
            $('#ddlCity').multipleSelect("refresh");
            $('#<%=ddlState.ClientID%>').val('');
            $('#<%=ddlState.ClientID%>').multipleSelect('refresh');
        }

    </script>

    <script type="text/javascript">
        function showApproval(Pheleboid) {
            $('#<%=lblEmployee_ID.ClientID%>').text(Pheleboid);
            $('#Approve_popup').show();
        }
        function Reject(Pheleboid) {
            var answer = confirm('Are you sure you want to reject this?');
            if (answer) {
                serverCall('TemporaryPheleboApproval.aspx/Reject', { Pheleboid: Pheleboid }, function (result) {
                    if (result == "1") {
                        toast('Success', "Temporary Phelebo Deactvated");
                        searchitem($('#<%=lbl_Status.ClientID%>').text());
                    }
                    else {
                        toast('Error', 'Error...');
                    }
                });
            }
            else {
                searchitem($('#<%=lbl_Status.ClientID%>').text());
            }
        }
    </script>

</asp:Content>



