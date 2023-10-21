<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PhelebotomistMaster.aspx.cs" Inherits="Design_HomeCollection_PhelebotomistMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">  
      
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />  
    <style type="text/css">
        .multiselect {
            width: 100%;
        }
    </style>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager runat="server" ID="sc"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-9">
                </div>
                <div class="col-md-8">
                    <b>Phelebotomist Registration</b>
                </div>
            </div>
            <asp:Label ID="lblIsEdit" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
            <asp:Label ID="lblEmployee_ID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
            <asp:Label ID="lblProfile_ID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-4">Phelebotomist Details</div>
                    <div class="col-md-15"></div>
                    <div class="col-md-5" style="font-size: 11px;">
                        <a class="im" style="cursor: pointer" href="TemporaryPhelebotomist.aspx" target="_blank">Add New Temporary Phelebotomist</a>
                    </div>
                </div>
            </div>
            <div class="col-md-18">
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Name   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtName" runat="server" CssClass="requiredField"
                            MaxLength="35" ToolTip="Enter Name" ClientIDMode="Static"></asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <label class="pull-left">DOB   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtDOB" runat="server" ToolTip="Select Date DOB" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtDOB" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Gender   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4" style="text-align: left">
                        <asp:DropDownList ID="ddlGender" TabIndex="3" runat="server" ToolTip="Gender">
                            <asp:ListItem Value="Male"></asp:ListItem>
                            <asp:ListItem Value="Female"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <asp:CheckBox ID="chkIsactive" TabIndex="5" ClientIDMode="Static" Checked="true" runat="server" Text="IsActive" />
                    </div>
                    <div class="col-md-5">
                        <label class="pull-left">Address   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Height="30" TabIndex="6" CssClass="requiredField"
                            MaxLength="150" ToolTip="Enter Address" ClientIDMode="Static"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">City   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtCity" runat="server" TabIndex="7" CssClass="requiredField"
                            MaxLength="35" ToolTip="Enter City" ClientIDMode="Static"></asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <label class="pull-left">Pincode   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtPincode" runat="server" TabIndex="8"
                            MaxLength="6" ToolTip="Enter Pincode" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbPicode" runat="server" TargetControlID="txtPincode" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Mobile   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtMobile" runat="server" TabIndex="9" CssClass="requiredField"
                            MaxLength="10" ToolTip="Enter Mobile" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-5">
                        <label class="pull-left">Phone No.   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txt_Phone" runat="server" TabIndex="10"
                            MaxLength="15" ToolTip="Enter Phone No" ClientIDMode="Static"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbPhone" runat="server" TargetControlID="txt_Phone" FilterType="Numbers"></cc1:FilteredTextBoxExtender>


                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Email   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtEmail" runat="server" TabIndex="11"
                            ToolTip="Enter E-Mail Address" MaxLength="100" ClientIDMode="Static"></asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <label class="pull-left">Blood Group</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:DropDownList ID="cmgBloodGroup" runat="server" TabIndex="14" ToolTip="Select Blood Group">
                            <asp:ListItem Text="-Select Blood Group-" Value=""></asp:ListItem>
                            <asp:ListItem Value="A Positive"></asp:ListItem>
                            <asp:ListItem Value="A Negative"></asp:ListItem>
                            <asp:ListItem Value="B Positive"></asp:ListItem>
                            <asp:ListItem Value="B Negative"></asp:ListItem>
                            <asp:ListItem Value="AB Positive"></asp:ListItem>
                            <asp:ListItem Value="AB Negative"></asp:ListItem>
                            <asp:ListItem Value="O Positive"></asp:ListItem>
                            <asp:ListItem Value="O Negative"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Father's Name   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtFather" runat="server" TabIndex="12" MaxLength="100"
                            ToolTip="Enter Father / Husband Name ( max Character 100 )" ClientIDMode="Static"></asp:TextBox>
                    </div>
                    <div class="col-md-5">
                        <label class="pull-left">Mother's Name   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtMother" runat="server" TabIndex="13" MaxLength="100"
                            ToolTip="Enter Father / Husband Name ( max Character 100 )" ClientIDMode="Static"></asp:TextBox>
                    </div>


                </div>
            </div>
            <div class="col-md-6">
                <img runat="server" id="PheleboProfile" src="../../App_Images/NoimagePhelebo.jpg" style="height: 150px; width: 150px; margin-left: 100px" alt="" />
            </div>

        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-4">Personal Details</div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Qualification   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtqualification" runat="server" TabIndex="15"
                        ToolTip="Enter Qualification" MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Vehicle Number   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtVehicleNumber" runat="server" TabIndex="16" ToolTip="Enter Vehicle Number."
                        MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Driving Licence  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDrivingLicence" runat="server" TabIndex="17" ToolTip="Enter Driving Licence."
                        MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>


            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">PAN No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPAN" runat="server" TabIndex="18" ToolTip="Enter PAN No."
                        MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Document Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDocumentType" runat="server" TabIndex="19" ToolTip="Select Document Type" CssClass="requiredField">
                        <asp:ListItem Text="-Select Document-" Value=""></asp:ListItem>
                        <asp:ListItem Value="PAN No"></asp:ListItem>
                        <asp:ListItem Value="Aadhar Card No"></asp:ListItem>
                        <asp:ListItem Value="Vehicle No"></asp:ListItem>
                        <asp:ListItem Value="Driving Licence No"></asp:ListItem>
                        <asp:ListItem Value="Passport No"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Document No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDocumentNo" runat="server" TabIndex="20" CssClass="requiredField"
                        ToolTip="Enter Document No." MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-4">
                        Work Area Details
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Joining Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtStartTime" runat="server" TabIndex="21" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calStartDate" runat="server" TargetControlID="txtStartTime" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlState" CssClass="multiselect" SelectionMode="Multiple" runat="server" onchange="bindCity();" ClientIDMode="Static"></asp:ListBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">City   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlCity" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Device Id   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDeviceid" runat="server" TabIndex="24" disabled="false"
                        MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-1">
                    <a style="margin-left: 6px; cursor: pointer" title="Reset Device Id" onclick="ResetDeviceId()">
                        <img src="../../App_Images/Reload.jpg" alt="" /></a>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">User Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtUserName" runat="server" TabIndex="24" ToolTip="Enter User Name" CssClass="requiredField"
                        MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Password   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Style="position: static" TabIndex="25" ToolTip="Enter Password" CssClass="requiredField"
                        MaxLength="35" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Phelbo Source   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPhelboSource" runat="server" TabIndex="19" ToolTip="Select Phelbo Source">
                        <asp:ListItem Text="-Select Phelbo Source-" Value=""></asp:ListItem>
                        <asp:ListItem Value="Franchise"></asp:ListItem>
                        <asp:ListItem Value="Lab"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-4">
                        Phlebo Charge Details
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Select Charge    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlcharge" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtchfromdate" runat="server" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="chchfrom" runat="server" TargetControlID="txtchfromdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtchtodate" runat="server" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="chchto" runat="server" TargetControlID="txtchtodate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-1">
                    <input type="button" value="Add" class="searchbutton" onclick="AddCh()" />
                </div>
            </div>
             <div class="row">
            <table id="tblchlist" style="width: 100%; border-collapse: collapse">
                <tr id="tblchlistheader">
                    <th class="GridViewHeaderStyle" align="left">S.No.</th>
                    <th class="GridViewHeaderStyle" align="left">Charge Name</th>
                    <th class="GridViewHeaderStyle" align="left">Charge Amount</th>
                    <th class="GridViewHeaderStyle" align="left">From Date</th>
                    <th class="GridViewHeaderStyle" align="left">To Date</th>
                    <th class="GridViewHeaderStyle" align="left">Remove</th>
                </tr>
            </table>
        </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSave" value="Save" onclick="SaveData();" tabindex="26" class="searchbutton" />
            <input type="button" id="btnUpdate" value="Update" onclick="UpdateData();" tabindex="27" style="display: none" class="searchbutton" />

            <input type="button" id="btnClear" value="Clear" onclick="clearform();" tabindex="27" class="searchbutton" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">No of Record   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:DropDownList ID="ddlnoofrecord" runat="server" Font-Bold="true">
                            <asp:ListItem Value="5">5</asp:ListItem>
                            <asp:ListItem Value="10">10</asp:ListItem>
                            <asp:ListItem Value="20">20</asp:ListItem>
                            <asp:ListItem Value="50">50</asp:ListItem>
                            <asp:ListItem Value="100">100</asp:ListItem>
                            <asp:ListItem Value="500">500</asp:ListItem>
                            <asp:ListItem Value="1000">1000</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlSearchState" runat="server" ClientIDMode="Static" class="ddlSearchState chosen-select" onchange="bindSearchCity(this.value);"  >
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlSearchCity" runat="server" ClientIDMode="Static" CssClass="ddlSearchCity chosen-select">
                            <asp:ListItem Value="">-Select City-</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <asp:DropDownList ID="ddlSearchGender" runat="server">
                            <asp:ListItem Value="">-Select Gender-</asp:ListItem>
                            <asp:ListItem Value="Male">Male</asp:ListItem>
                            <asp:ListItem Value="Female">Female</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlsearchtype" runat="server">
                            <asp:ListItem Value="0">-Select Search Type-</asp:ListItem>
                            <asp:ListItem Value="NAME">Name</asp:ListItem>
                            <asp:ListItem Value="PhlebotomistID">Phelebo Code</asp:ListItem>
                            <asp:ListItem Value="Mobile">Mobile</asp:ListItem>
                            <asp:ListItem Value="Email">Email</asp:ListItem>
                            <asp:ListItem Value="PanNo">PAN No</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtsearchvalue" runat="server" />
                    </div>
                    <div class="col-md-1">
                        <input type="button" value="Search" class="searchbutton" onclick="searchitem(1)" />
                    </div>
                    <div class="col-md-1">
                        <input type="button" value="Excel" class="searchbutton" onclick="searchitemexcel()" />
                    </div>
                    <div class="col-md-1">
                        <input type="button" value="Pending Profile Pic" class="searchbutton" onclick="searchitem(0)" />
                    </div>
                </div>
            </div>
            <div class="row">
            <div style="height: 200px; overflow: auto;">
                <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                    <tr id="triteheader">
                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                        <td class="GridViewHeaderStyle" style="width: 30px;">Select</td>
                        <td class="GridViewHeaderStyle">Phelebo Code</td>
                        <td class="GridViewHeaderStyle">Phelebo Name</td>
                        <td class="GridViewHeaderStyle">User Name</td>
                        <td class="GridViewHeaderStyle">DOB</td>
                        <td class="GridViewHeaderStyle">Gender</td>
                        <td class="GridViewHeaderStyle">Mobile</td>
                        <td class="GridViewHeaderStyle">Email</td>
                        <td class="GridViewHeaderStyle">Qualification</td>
                        <td class="GridViewHeaderStyle">Device Id</td>
                        <td class="GridViewHeaderStyle">Phelbo Source</td>
                        <td class="GridViewHeaderStyle">Active</td>
                    </tr>
                </table>
            </div>
        </div>
             </div>

    </div>
    <div id="Approve_popup" style="display: none;">
        <div style="background-color: #000; opacity: 0.7; z-index: 99999; position: fixed; left: 0; top: 0; height: 100%; width: 100%;"></div>
        <div style="background-color: #e9ddde; z-index: 100000; position: absolute; left: 25%; top: 25%; height: 250px; width: 350px; border: 1px solid #ccc; overflow: auto;">
            <div class="Purchaseheader"><span id="Span1">Approve Phelebotomist Profile </span></div>
            <img src="../../App_Images/Close.png" alt="" style="width: 30px; height: 25px; position: absolute; right: 0px; top: -3px; cursor: pointer" onclick="HideApprovePopup();" />
            <div>
                <div class="row">
                    <div class="col-md-4">
                        <img src="../../App_Images/NoimagePhelebo.jpg" id="PPImage"  alt="" runat="server" style="height: 150px; width: 150px; margin-left: 100px" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-10"></div>
                    <div class="col-md-3">
                        <input type="button" id="Button1" value="Approve" class="searchbutton" onclick="Approval()" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        jQuery(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            jQuery('[id*=ddlState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=ddlCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('#txtName').keyup(function () {
                this.value = this.value.toUpperCase();
            });
          
        });
        getStateSearchable = function () {
            
        }
    </script>
    <script type="text/javascript">
        function showApproval(Pheleboid, ProfilePicsID) {
            $('#<%=lblProfile_ID.ClientID%>').text(ProfilePicsID);
            serverCall('PhelebotomistMaster.aspx/BindProfilePic',{ ProfilePicsID: ProfilePicsID },function (result) {
                    if (result == '') {
                        $('#<%=PPImage.ClientID%>').attr("src", "../../App_Images/NoimagePhelebo.jpg");
                 }
                 else {
                     $('#<%=PPImage.ClientID%>').attr("src", result);
                 }
             })
             $('#Approve_popup').show();
         }
         function HideApprovePopup() {
             $('#Approve_popup').hide();
         }
         function Approval() {
             var Profile_ID = $('#<%=lblProfile_ID.ClientID%>').text();
             serverCall('PhelebotomistMaster.aspx/ApprovalProfile',
                 { Profile_ID: Profile_ID },
                 function (result) {
                     if (result == "-1") {
                         toast("Error", "Your Session Expired...Please Login Again", "");
                     }
                     else if (result == "1") {
                         searchitem(0);
                         toast("Success", "Phelebo Profile Pic Successfully Approved", "");
                         HideApprovePopup();
                     }
                     else {
                         toast("Error", "Please Try Again Later", "");
                     }
                 })
         }
         function searchitemexcel() {
             serverCall('PhelebotomistMaster.aspx/GetDataExcel',
                 { searchtype: $('#<%=ddlsearchtype.ClientID%>').val() , searchvalue: $('#<%=txtsearchvalue.ClientID%>').val() , NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val(), SearchState: $('#<%=ddlSearchState.ClientID%>').val() , SearchCity:  $('#<%=ddlSearchCity.ClientID%>').val() , SearchGender:  $('#<%=ddlSearchGender.ClientID%>').val()  },
                 function (result) {
                     ItemData = result;
                     if (ItemData == "false") {
                         toast("Error", "No Item Found");
                     }
                     else {
                         window.open('../common/ExportToExcel.aspx');
                     }
                 })
         }

         function searchitem(IsDeactivatePP) {
             $('#tblitemlist tr').slice(1).remove();
            if ($.trim($('#<%=txtsearchvalue.ClientID%>').val()) != "" && $('#<%=ddlsearchtype.ClientID%>').val() == 0) {
                 toast("Error", "Please Select Search Type");
                 $('#<%=ddlsearchtype.ClientID%>').focus();
                 return;
             }
             serverCall('PhelebotomistMaster.aspx/GetData',
                 { searchtype: $('#<%=ddlsearchtype.ClientID%>').val(), searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(), NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val(), SearchState: $('#<%=ddlSearchState.ClientID%>').val(), SearchCity: $('#<%=ddlSearchCity.ClientID%>').val(), SearchGender: $('#<%=ddlSearchGender.ClientID%>').val(), IsDeactivatePP: IsDeactivatePP },
                 function (result) {
                 if (result != "") {
                     ItemData = jQuery.parseJSON(result);
                     if (ItemData.length == 0) {
                         toast("Info", "No Item Found", "");
                     }
                     else {
                         for (var i = 0; i <= ItemData.length - 1; i++) {
                             var mydata = [];
                             mydata.push("<tr style='background-color:bisque;'>");
                             mydata.push('<td class="GridViewLabItemStyle"  id="" >'); mydata.push(i + 1); mydata.push('</td>');
                             if (IsDeactivatePP == "0") {
                                 mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showApproval('); mydata.push(ItemData[i].PhlebotomistID); mydata.push(','); mydata.push(ItemData[i].ProfilePicID); mydata.push(')"></td>');
                             }
                             else {
                                 mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><input type="button" value="Select" style="cursor:pointer;" onclick="showdetailtoupdate(this)" /></td>');
                             }
                             mydata.push('<td class="GridViewLabItemStyle"  id="tdPheleboCode" >'); mydata.push(ItemData[i].PhlebotomistID); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle"  id="tdPheleboName" >'); mydata.push(ItemData[i].NAME); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle"  id="tdUserName" >'); mydata.push(ItemData[i].UserName); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle" id="tdDOB">'); mydata.push(ItemData[i].Age); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle" id="tdGender">'); mydata.push(ItemData[i].Gender); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle" id="tdMobile">'); mydata.push(ItemData[i].Mobile); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle" id="tdEmail">'); mydata.push(ItemData[i].Email); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle" id="tdQualification">'); mydata.push(ItemData[i].Qualification); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle" id="tdDeviceId">'); mydata.push(ItemData[i].DeviceID); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle" id="tdPhelboSource">'); mydata.push(ItemData[i].PhelboSource); mydata.push('</td>');
                             mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].Status); mydata.push('</td>');
                             mydata.push('<td style="display:none;" id="tdPheleboid">'); mydata.push(ItemData[i].PhlebotomistID); mydata.push('</td>');
                             mydata.push("</tr>");
                             mydata = mydata.join("");
                             $('#tblitemlist').append(mydata);
                         }
                     }
                    }
                    else {
                         toast('Error','Error',"");
                     }
                 })
                 }
                 function bindCity() {
                     var StateId = $("#<%=ddlState.ClientID %>").val();
                 $("#<%=ddlCity.ClientID %> option").remove();
                 var ddlCity = $("#<%=ddlCity.ClientID %>");
                 var stateCollection = [];
                 $('#ddlState :checked').each(function (i) {
                     stateCollection[i] = $(this).val();
                 })
                 StateId = stateCollection.join(",")
                 serverCall('PhelebotomistMaster.aspx/bindCity',
                     { StateId: StateId },
                     function (result) {
                         CityData = jQuery.parseJSON(result);
                         if (CityData.length > 0) {
                           
                             ddlCity.bindMultipleSelect({ data: JSON.parse(result), valueField: 'ID', textField: 'City', controlID: $("#<%=ddlCity.ClientID %>") });

                         }
                         jQuery('[id*=ddlCity]').multipleSelect({
                             includeSelectAllOption: true,
                             filter: true, keepOpen: false
                         });
                     })
             }
        function bindSearchCity(StateId) {
            $("#<%=ddlSearchCity.ClientID %> option").remove();
            var ddlSearchCity = $("#<%=ddlSearchCity.ClientID %>");
            
            jQuery("#ddlSearchCity").trigger('chosen:updated');
            ddlSearchCity.append($("<option></option>").val("").html("-Select City-"));
            jQuery("#ddlSearchCity").trigger('chosen:updated');
            serverCall('PhelebotomistMaster.aspx/bindCity',
                { StateId: StateId },
                function (result) {
                   var CityData = jQuery.parseJSON(result);
                    for (i = 0; i < CityData.length; i++) {

                        ddlSearchCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                    }
                    jQuery('#ddlSearchCity').trigger('chosen:updated');
                });

        }
         function showdetailtoupdate(ctrl) {
             $('#btnSave').hide();
             $('#btnUpdate').show();
             var Pheleboid = $(ctrl).closest("tr").find('#tdPheleboid').html();
             serverCall('PhelebotomistMaster.aspx/BindSavePhelebotomist',
                 { Pheleboid: Pheleboid },
                 function (result) {
                     PhelebotomistData = jQuery.parseJSON(result);
                     if (PhelebotomistData[0].ProfilePics == '') {
                         $('#<%=PheleboProfile.ClientID%>').attr("src", "../../App_Images/NoimagePhelebo.jpg");
                     }
                     else {
                         $('#<%=PheleboProfile.ClientID%>').attr("src", PhelebotomistData[0].ProfilePics);
                     }
                     $('#<%=lblEmployee_ID.ClientID%>').text(Pheleboid);
                     $('#<%=txtName.ClientID%>').val(PhelebotomistData[0].NAME);
                     $('#<%=txtDOB.ClientID%>').val(PhelebotomistData[0].Age);
                     $('#<%=ddlGender.ClientID%>').val(PhelebotomistData[0].Gender);
                     $('#<%=txtMobile.ClientID%>').val(PhelebotomistData[0].Mobile);
                     $('#<%=txt_Phone.ClientID%>').val(PhelebotomistData[0].Other_Contact);
                     $('#<%=txtEmail.ClientID%>').val(PhelebotomistData[0].Email);
                     $('#<%=txtAddress.ClientID%>').val(PhelebotomistData[0].P_Address);
                     $('#<%=txtCity.ClientID%>').val(PhelebotomistData[0].P_City);
                     $('#<%=txtPincode.ClientID%>').val(PhelebotomistData[0].P_Pincode);
                     $('#<%=txtFather.ClientID%>').val(PhelebotomistData[0].FatherName);
                     $('#<%=txtMother.ClientID%>').val(PhelebotomistData[0].MotherName);
                     $('#<%=cmgBloodGroup.ClientID%>').val(PhelebotomistData[0].BloodGroup);
                     $('#<%=txtqualification.ClientID%>').val(PhelebotomistData[0].Qualification);
                     $('#<%=txtVehicleNumber.ClientID%>').val(PhelebotomistData[0].Vehicle_Num);
                     $('#<%=txtDrivingLicence.ClientID%>').val(PhelebotomistData[0].DrivingLicence);
                     $('#<%=txtPAN.ClientID%>').val(PhelebotomistData[0].PanNo);
                     $('#<%=ddlDocumentType.ClientID%>').val(PhelebotomistData[0].DucumentType);
                     $('#<%=txtDocumentNo.ClientID%>').val(PhelebotomistData[0].DucumentNo);
                     $('#<%=txtStartTime.ClientID%>').val(PhelebotomistData[0].JoiningDate);
                     $('#<%=txtDeviceid.ClientID%>').val(PhelebotomistData[0].DeviceID);
                     $('#<%=txtUserName.ClientID%>').val(PhelebotomistData[0].UserName);
                     $('#<%=txtPassword.ClientID%>').val(PhelebotomistData[0].Password);
                     $('#<%=ddlPhelboSource.ClientID%>').val(PhelebotomistData[0].PhelboSource);
                     var State = PhelebotomistData[0].StateId.split(',')
                     $('#<%=ddlState.ClientID%>').val(State);
                     $('#<%=ddlState.ClientID%>').multipleSelect('refresh');

                     setTimeout(function () {
                         bindCity();
                     }, 1000)
                     setTimeout(function () {
                         var City = PhelebotomistData[0].CityId.split(',')
                         $('#<%=ddlCity.ClientID%>').val(City);
                         jQuery('#ddlCity').trigger('chosen:updated');
                     }, 3000)
                     setTimeout(function () {
                         $('#ddlCity').multipleSelect('refresh');
                     }, 3500)
                 });
                 $('#tblchlist tr').slice(1).remove();
                 serverCall('PhelebotomistMaster.aspx/BindChData',
                     { Pheleboid: Pheleboid },
                     function (result) {
                         ItemData = jQuery.parseJSON(result);
                         for (var i = 0; i <= ItemData.length - 1; i++) {
                             var id = ItemData[i].ChargeID;
                             var mydata = [];
                             mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); mydata.push(id); mydata.push('>');
                             mydata.push('<td  align="left" >'); mydata.push(parseFloat(i + 1)); mydata.push('</td>');
                             mydata.push('<td  align="left" id="tdchname">'); mydata.push(ItemData[i].ChargeName); mydata.push('</td>');
                             mydata.push('<td  align="left" id="tdchamt">'); mydata.push(ItemData[i].ChargeAmount); mydata.push('</td>');
                             mydata.push('<td  align="left" id="tdchfrom">'); mydata.push(ItemData[i].fromdate); mydata.push('</td>');
                             mydata.push('<td  align="left" id="tdchto">'); mydata.push(ItemData[i].todate); mydata.push('</td>');
                             mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow1(this)"/></td>');
                             mydata.push('</tr>');
                             mydata = mydata.join("");
                             $('#tblchlist').append(mydata);
                         }
                     })
             }
        function Validation() {
            if ($.trim($("#<%=txtName.ClientID%>").val()) == "") {
                toast("Error", "Please Entre Name.", "");
                $("#<%=txtName.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtAddress.ClientID%>").val()) == "") {
                toast("Error", "Please Entre Address.", "");
                $("#<%=txtAddress.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtCity.ClientID%>").val()) == "") {
                toast("Error", "Please Entre City.", "");
                $("#<%=txtCity.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtMobile.ClientID%>").val()) == "") {
                toast("Error", "Please Entre Mobile.", "");
                $("#<%=txtMobile.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=ddlDocumentType.ClientID%>").val()) == "") {
                toast("Error", "Please Select Document Type.", "");
                $("#<%=ddlDocumentType.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtDocumentNo.ClientID%>").val()) == "") {
                toast("Error", "Please Entre Document No.", "");
                $("#<%=txtDocumentNo.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=ddlState.ClientID%>").val()) == "") {
                toast("Error", "Please Select State.", "");
                $("#<%=ddlState.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=ddlCity.ClientID%>").val()) == "") {
                toast("Error", "Please Select City.", "");
                $("#<%=ddlCity.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtUserName.ClientID%>").val()) == "") {
                toast("Error", "Please Entre User Name.", "");
                $("#<%=txtUserName.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtPassword.ClientID%>").val()) == "") {
                toast("Error", "Please Entre Pasaword.", "");
                $("#<%=txtPassword.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=ddlPhelboSource.ClientID%>").val()) == "") {
                toast("Error", "Please Select Phelbo Source.", "");
                $("#<%=ddlPhelboSource.ClientID%>").focus();
                return false;
            }
        }
        function PhelebotomistMaster() {
            var objPhelebotomist = new Object();
            if ($('#<%=lblEmployee_ID.ClientID%>').text() != "")
                objPhelebotomist.PhelebotomistId = $('#<%=lblEmployee_ID.ClientID%>').text();
            else
                objPhelebotomist.PhelebotomistId = 0;
            objPhelebotomist.NAME = $('#<%=txtName.ClientID%>').val();
            if ($('#<%=chkIsactive.ClientID%>').is(':checked')) {
                objPhelebotomist.IsActive = "1";
            }
            else {
                objPhelebotomist.IsActive = "0";
            }
            objPhelebotomist.Age = $('#<%=txtDOB.ClientID%>').val();
            objPhelebotomist.Gender = $('#<%=ddlGender.ClientID%>').val();
            objPhelebotomist.Mobile = $('#<%=txtMobile.ClientID%>').val();
            objPhelebotomist.Other_Contact = $('#<%=txt_Phone.ClientID%>').val();
            objPhelebotomist.Email = $('#<%=txtEmail.ClientID%>').val();
            objPhelebotomist.FatherName = $('#<%=txtFather.ClientID%>').val();
            objPhelebotomist.MotherName = $('#<%=txtMother.ClientID%>').val();
            objPhelebotomist.P_Address = $('#<%=txtAddress.ClientID%>').val();
            objPhelebotomist.P_City = $('#<%=txtCity.ClientID%>').val();
            objPhelebotomist.P_Pincode = $('#<%=txtPincode.ClientID%>').val();
            objPhelebotomist.BloodGroup = $('#<%=cmgBloodGroup.ClientID%>').val();
            objPhelebotomist.Qualification = $('#<%=txtqualification.ClientID%>').val();
            objPhelebotomist.Vehicle_Num = $('#<%=txtVehicleNumber.ClientID%>').val();
            objPhelebotomist.DrivingLicence = $('#<%=txtDrivingLicence.ClientID%>').val();
            objPhelebotomist.PanNo = $('#<%=txtPAN.ClientID%>').val();
            objPhelebotomist.DucumentType = $('#<%=ddlDocumentType.ClientID%>').val();
            objPhelebotomist.DucumentNo = $('#<%=txtDocumentNo.ClientID%>').val();
            objPhelebotomist.JoiningDate = $('#<%=txtStartTime.ClientID%>').val();
            objPhelebotomist.DeviceID = $('#<%=txtDeviceid.ClientID%>').val();
            objPhelebotomist.UserName = $('#<%=txtUserName.ClientID%>').val();
            objPhelebotomist.Password = $('#<%=txtPassword.ClientID%>').val();
            return objPhelebotomist;
        }
        function clearform() {
            $('#<%=lblEmployee_ID.ClientID%>').text('');
            $('#<%=txtName.ClientID%>,#<%=txtDOB.ClientID%>,#<%=txtMobile.ClientID%>,#<%=txt_Phone.ClientID%>').val('');
            $('#<%=ddlGender.ClientID%>').val('Male');
            $('#<%=txtEmail.ClientID%>,#<%=txtFather.ClientID%>,#<%=txtMother.ClientID%>,#<%=txtAddress.ClientID%>,#<%=txtCity.ClientID%>').val('');            
            $('#<%=cmgBloodGroup.ClientID%>').val('0');
            $('#<%=txtPincode.ClientID%>,#<%=txtqualification.ClientID%>,#<%=txtVehicleNumber.ClientID%>,#<%=txtDrivingLicence.ClientID%>,#<%=txtPAN.ClientID%>').val('');           
            $('#<%=ddlDocumentType.ClientID%>').val(0);
            $('#<%=txtDocumentNo.ClientID%>,#<%=txtStartTime.ClientID%>,#<%=txtDeviceid.ClientID%>,#<%=txtUserName.ClientID%>,#<%=txtPassword.ClientID%>').val('');        
            $('#ddlCity option').remove();
            $('#ddlCity').multipleSelect("refresh");
            $('#<%=ddlState.ClientID%>').val('');
            $('#<%=ddlState.ClientID%>').multipleSelect('refresh');
            $('#<%=ddlPhelboSource.ClientID%>').val('');
            $('#<%=PheleboProfile.ClientID%>').attr("src", "../../App_Images/NoimagePhelebo.jpg");
            $('#btnSave').show();
            $('#btnUpdate').hide();
            $('#tblchlist tr').slice(1).remove();
        }
        function GetChargeData() {
            var dataIm = new Array();
            $('#tblchlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "tblchlistheader") {
                    var objIM = new Object();
                    objIM.ChargeID = id;
                    objIM.ChargeAmount = $(this).closest("tr").find("#tdchamt").text();
                    objIM.FromDate = $(this).closest("tr").find("#tdchfrom").text();
                    objIM.ToDate = $(this).closest("tr").find("#tdchto").text();
                    dataIm.push(objIM);
                }
            });
            return dataIm;
        }
        function SaveData() {
            jQuery('#<%=lblEmployee_ID.ClientID%>').text('');
            if (Validation() == false) {
                return false;
            }
            jQuery('#btnSave').attr('disabled', true).val("Submitting...");
            var resultPhelebotomistMaster = PhelebotomistMaster();
            var phlebocharge = GetChargeData();
            serverCall('PhelebotomistMaster.aspx/SavePhelebotomist',
                { obj: resultPhelebotomistMaster, CityStateId: $('#<%=ddlCity.ClientID%>').val(), PhelboSource: $('#<%=ddlPhelboSource.ClientID%>').val(), phlebochargedata: phlebocharge },
                 function (result) {
                     if (result == "1") {
                         toast("Success", "Record Saved Successfully", "");
                         clearform();
                     }
                     else if (result == "2") {
                         toast("Error", "User name already Exists", "");
                         $('#<%=txtUserName.ClientID%>').focus()
                     }
                     else {
                         toast("Error", 'Error...', "");
                     }
                     jQuery('#btnSave').attr('disabled', false).val("Save");
                 })
         }
         function GetData() {
             serverCall('PhelebotomistMaster.aspx/GetData',
                 {},
                 function (result) {
                     PheleboData = jQuery.parseJSON(result);
                     var output = $('#tb_phelebotomistmaster').parseTemplate(PheleboData);
                     $('#div_Phelebo').html(output);
                 })
         }

         function UpdateData() {
             if (Validation() == false) {
                 return;
             }
             jQuery('#btnUpdate').attr('disabled', true).val("Submitting...");
             var resultPhelebotomistMaster = PhelebotomistMaster();
             var phlebocharge = GetChargeData();
             serverCall('PhelebotomistMaster.aspx/UpdatePhelebotomist',
                 { obj: resultPhelebotomistMaster, CityStateId: $('#<%=ddlCity.ClientID%>').val(), PhelboSource: $('#<%=ddlPhelboSource.ClientID%>').val(), phlebochargedata: phlebocharge },
                function (result) {
                    if (result == "1") {
                        toast("Success", "Record Update Successfully", "");
                        clearform();
                        searchitem(1);
                    }
                    else if (result == "2") {
                        toast("Error", "User name already Exists", "");
                        $('#<%=txtUserName.ClientID%>').focus()
                    }
                    else {
                        toast("Error", 'Error...', "");
                    }
                    jQuery('#btnUpdate').attr('disabled', false).val("Update");
                })
         }
        function ResetDeviceId() {
            serverCall('PhelebotomistMaster.aspx/ResetDeviceId',
                { PhelebotomistId: $('#<%=lblEmployee_ID.ClientID%>').text() },
                 function (result) {
                     if (result == "1") {
                         $('#<%=txtDeviceid.ClientID%>').val('');
                         searchitem(1);
                     }
                     else {
                         toast("Error", 'Error', "");
                     }
                 })
             }
        function AddCh() {
            if ($('#<%=ddlcharge.ClientID%>').val() == "0") {
                toast("Error", "Please Select Charge", "");
                $('#<%=ddlcharge.ClientID%>').focus();
                return;
            }
            if ($('#<%=txtchfromdate.ClientID%>').val() == "") {
                toast("Error", "Please Select From Date", "");
                $('#<%=txtchfromdate.ClientID%>').focus();
                return;
            }
            if ($('#<%=txtchtodate.ClientID%>').val() == "") {
                toast("Error", "Please Select To Date", "");
                $('#<%=txtchtodate.ClientID%>').focus();
                return;
            }
            var id = $('#<%=ddlcharge.ClientID%>').val();
            if ($('table#tblchlist').find('#' + id).length > 0) {
                toast("Error", "Data Already Added", "");
                return;
            }
            var a = $('#tblchlist tr').length - 1;
            var mydata = [];
            mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); mydata.push(id); mydata.push('>');
            mydata.push('<td  align="left" >'); mydata.push(parseFloat(a + 1)); mydata.push('</td>');
            mydata.push('<td  align="left" id="tdchname">'); mydata.push($('#<%=ddlcharge.ClientID%> option:selected').text().split('@')[0].trim()); mydata.push('</td>');
            mydata.push('<td  align="left" id="tdchamt">'); mydata.push($('#<%=ddlcharge.ClientID%> option:selected').text().split('@')[1].trim()); mydata.push('</td>');
            mydata.push('<td  align="left" id="tdchfrom">'); mydata.push($('#<%=txtchfromdate.ClientID%>').val()); mydata.push('</td>');
            mydata.push('<td  align="left" id="tdchto">'); mydata.push($('#<%=txtchtodate.ClientID%>').val()); mydata.push('</td>');
            mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow1(this)"/></td>');
            mydata.push('</tr>');
            mydata = mydata.join("");
            $('#tblchlist').append(mydata);
            $('#<%=ddlcharge.ClientID%>').prop('selectedIndex', 0);
            $('#<%=txtchfromdate.ClientID%>,#<%=txtchtodate.ClientID%>').val('');
        }
        function deleterow1(itemid) {
            var table = document.getElementById('tblchlist');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
        }
    </script>



</asp:Content>

