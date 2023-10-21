<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Customercare.aspx.cs" Inherits="Design_HomeCollection_Customercare" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>

    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <style type="text/css">
        /* Style the tab */
        div.tab {
            overflow: hidden;
            border: 1px solid #ccc;
            height: 35px;
        }

            /* Style the buttons inside the tab */
            div.tab .tablinks {
                background-color: inherit;
                float: left;
                border: none;
                outline: none;
                cursor: pointer;
                padding: 7px 16px;
                transition: 0.3s;
                font-size: 17px;
            }

                /* Change background color of buttons on hover */
                div.tab .tablinks:hover {
                    background-color: #5258ff;
                    color: white;
                }

                /* Create an active/current tablink class */
                div.tab .tablinks.active {
                    background-color: blue;
                    color: white;
                }

        /* Style the tab content */
        .tabcontent {
            display: none;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-top: none;
            margin-left: -10px;
            width:100%
        }
    </style>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">         
                <div class="row">
                    <div class="col-md-9"></div>
                    <div class="col-md-6">
                        <b>Customer Care Managment</b>
                    </div>
                </div>
            </div>
       

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal" Style="font-weight: 700">
                        <asp:ListItem Value="0" Selected="True">Patient</asp:ListItem>
                        <%-- <asp:ListItem Value="1" Enabled="false">Doctor</asp:ListItem>
                                <asp:ListItem Value="2" Enabled="false">PUP</asp:ListItem>
                                <asp:ListItem Value="3" Enabled="false">PCC</asp:ListItem>--%>
                    </asp:RadioButtonList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left"><b>Mobile No.</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" id="patient">
                    <asp:TextBox ID="txtmobile" runat="server" AutoCompleteType="Disabled" MaxLength="10" onkeyup="showlength()" CssClass="requiredField"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtmobile">
                    </cc1:FilteredTextBoxExtender>

                   
                </div>
                <div class="col-md-2">
                     <span id="molen" style="font-weight: bold;"></span>
                </div>
                <div class="col-md-3">
                    <input type="button" value="Clear" class="resetbutton" onclick="clearall()" />
                </div>
            </div>


            <table id="tblpdetail" border="1" frame="box" rules="all" style="background-color: #f3f2cf; width: 99%">
            </table>
        </div>
        <div class="div_Patientinfo" style="display: none;">
            <div class="POuter_Box_Inventory">
                <div class="tab" style="background-color: #00FFFF;">
                   <%-- <input id="tab1" class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Lab Report" onclick="openTab(event, 'LabReport')" />--%>
                    <input id="tab2" class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Home Collection" onclick="openTab(event, 'HomeCollection')" />
                   <%-- <input id="tab3" class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Estimate" onclick="openTab(event, 'Estimate')" />
                    <input id="tab4" class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Feed Back" onclick="openTab(event, 'FeedBack')" />
                    <input id="tab5" class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Misc.Call" onclick="openTab(event, 'MiscCall')" />
                    <input id="tab6" class="tablinks" style="font-weight: bold; border-right: 1px solid silver;" type="button" value="Nearby Centre" onclick="openTab(event, 'NearByPCC')" />
                    <input id="tab7" class="tablinks" style="font-weight: bold; display: none;" type="button" value="Ticket" onclick="openTab(event, 'Ticket')" />
                    <input id="tab8" class="tablinks" style="display: none; font-weight: bold; border-right: 1px solid silver;" type="button" value="Marketing Calls" onclick="openTab(event, 'MarketingCall')" />--%>
                </div>


                <div id="LabReport" class="tabcontent">
                </div>

                <div id="HomeCollection" class="tabcontent">
                </div>
                <div id="Estimate" class="tabcontent">
                </div>
                <div id="FeedBack" class="tabcontent">
                </div>
                <div id="Ticket" class="tabcontent">
                    <h3>Ticket</h3>
                </div>
                <div id="MiscCall" class="tabcontent">
                </div>
                <div id="NearByPCC" class="tabcontent">
                </div>
                <div id="MarketingCall" class="tabcontent">
                </div>
            </div>
        </div>


    </div>
    <asp:Button ID="Button1" runat="server" Style="display: none;" />
    <asp:Panel ID="panelold" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="background-color: papayawhip">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-3">
                        Old Patient
                    </div>
                    <div class="col-md-5" style="display:none">
                        <span style="background-color: papayawhip;">Old Patient</span>
                    </div>
                </div>
            </div>
            <div  style="text-align: center;">
                <div style="overflow: scroll; max-height: 320px; background-color: papayawhip;">
                    <table id="oldPatientTable" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                        <tr id="myHeader" style="text-align: left;">
                            <td class="GridViewHeaderStyle">Select</td>
                            <td class="GridViewHeaderStyle">UHID</td>
                            <td class="GridViewHeaderStyle">Patient Name</td>
                            <td class="GridViewHeaderStyle">DOB</td>
                            <td class="GridViewHeaderStyle">Age</td>
                            <td class="GridViewHeaderStyle">Gender</td>
                            <td class="GridViewHeaderStyle">Mobile</td>
                            <td class="GridViewHeaderStyle">Area</td>
                            <td class="GridViewHeaderStyle">City</td>
                            <td class="GridViewHeaderStyle">State</td>
                            <td class="GridViewHeaderStyle">Pincode</td>
                            <td class="GridViewHeaderStyle">Reg.Date</td>
                            <td class="GridViewHeaderStyle">Last HC</td>
                        </tr>
                    </table>



                    <table id="tblOnlinePatient2" width="99%" cellpadding="0" rules="all" border="1" frame="box" style="display: none;">
                        <tr id="Tr2" style="text-align: left;">
                            <td class="GridViewHeaderStyle" style="width: 60px;">Select</td>
                            <td class="GridViewHeaderStyle">UHID</td>
                            <td class="GridViewHeaderStyle">Patient Name</td>
                            <td class="GridViewHeaderStyle">Age</td>
                            <td class="GridViewHeaderStyle">Gender</td>
                            <td class="GridViewHeaderStyle">Mobile</td>
                            <td class="GridViewHeaderStyle">Status</td>
                        </tr>
                    </table>




                    <asp:Button ID="btncloseopd" runat="server" Text="Close" CssClass="resetbutton" />

                    <input type="button" value="Register New Patient With Same Mobile" class="savebutton" onclick="opennewpatient()" id="btnmoresearch" />
                    <%-- &nbsp;&nbsp;&nbsp;
                   <input type="button" value="More Search" class="savebutton" onclick="finemorepatient()" id="btnmoresearch" />--%>
                </div>
            </div>


            <div class="hcrequest" style="width: 99%; background-color: aqua;"></div>


        </div>
    </asp:Panel>


    <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd" OnCancelScript="clearOldpatient()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelold">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="OnlineFilterOLD" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                Online Patient Detail
            </div>
            <div class="content" style="text-align: center;">
                <div style="overflow: scroll; height: 220px; background-color: papayawhip;">
                    <table id="tblOnlinePatient1" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                        <tr id="Tr1" style="text-align: left;">
                            <td class="GridViewHeaderStyle" style="width: 60px;">Select</td>
                            <td class="GridViewHeaderStyle">UHID</td>
                            <td class="GridViewHeaderStyle">Patient Name</td>
                            <td class="GridViewHeaderStyle">Age</td>
                            <td class="GridViewHeaderStyle">Gender</td>
                            <td class="GridViewHeaderStyle">Mobile</td>
                            <td class="GridViewHeaderStyle">Status</td>
                        </tr>
                    </table>

                    <input type="button" value="Close" class="resetbutton" onclick="closemeplease()" />
                    <asp:Button ID="btnCloseOnlinePOPUP" runat="server" Text="Close" CssClass="resetbutton" Style="display: none;" />
                    <input type="button" value="Register New Patient With Same Mobile" class="savebutton" onclick="opennewpatient1()" id="Button2"  style="display:none"/>
                </div>
            </div>
        </div>
    </asp:Panel>

    <cc1:ModalPopupExtender ID="ModalPopupOnlineFilter" runat="server" CancelControlID="btnCloseOnlinePOPUP" OnCancelScript="clearOldOnlinepatient()" TargetControlID="btnCloseOnlinePOPUP"
        BackgroundCssClass="filterPupupBackground" PopupControlID="OnlineFilterOLD">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlsavedata" runat="server" Style="display: none;">

        <div class="POuter_Box_Inventory" style="background-color: papayawhip;">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-5">
                        New Patient Detail
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left"><b>Mobile No.</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtnewmobile" runat="server" MaxLength="10" ReadOnly="true" CssClass="requiredField"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtnewmobile">
                    </cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-4">
                    <label class="pull-left"><b>Patient ID</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <span id="spnPatientId" runat="server"></span>
                </div>



            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left"><b>Patient Name</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddltitle" runat="server" onchange="AutoGender()" TabIndex="4"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtpatientname" CssClass="checkSpecialCharater_forPname requiredField" runat="server" Style="text-transform: uppercase;" TabIndex="5"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left"><b>Age</b></label>
                    <b class="pull-right">:</b>
                    <asp:RadioButton ID="rdAge" runat="server" Checked="True" onclick="setdobop1(this)" GroupName="rdDOB" />
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtAge" runat="server" onkeyup="getdob()" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText requiredField" MaxLength="3" TabIndex="6" placeholder="Years" />
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender6" runat="server" FilterType="Numbers" TargetControlID="txtAge">
                    </cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtAge1" runat="server" onkeyup="getdob()" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText requiredField" MaxLength="2" TabIndex="7" placeholder="Months" />
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender7" runat="server" FilterType="Numbers" TargetControlID="txtAge1">
                    </cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtAge2" runat="server" onkeyup="getdob()" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText requiredField" MaxLength="2" TabIndex="8" placeholder="Days" />
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender8" runat="server" FilterType="Numbers" TargetControlID="txtAge2">
                    </cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left"><b>DOB</b></label>
                    <b class="pull-right">:</b>
                    <asp:RadioButton ID="rdDOB" runat="server" GroupName="rdDOB" onclick="setdobop(this)" />

                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtdob" onclick="getdob()" ReadOnly="true" runat="server" Enabled="false"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left"><b>Gender</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddlGender" runat="server" onchange="resetitem1();" CssClass="requiredField">
                        <asp:ListItem Value="Male">Male</asp:ListItem>
                        <asp:ListItem Value="Female">Female</asp:ListItem>
                        <asp:ListItem Value=""></asp:ListItem>
                    </asp:DropDownList>
                </div>

            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">City</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                     <select id="ddlCountry"  data-title="Select Country" ></select>   
                </div>
                <div class="col-md-3">
                    <label class="pull-left">House No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtpaddress" runat="server" TabIndex="10"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlstate" runat="server" onchange="bindCity()" CssClass="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">City</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlcity" runat="server" onchange="bindLocality()" CssClass="requiredField"></asp:DropDownList>
                </div>
                
            </div>

            <div class="row">

                <div class="col-md-3">
                    <label class="pull-left">Area</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlarea" runat="server" TabIndex="11" onchange="bindpincode()" CssClass="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <img src="../../App_Images/plus.png" style="cursor: pointer"  onclick="window.open('HomeCollectionLocationMaster.aspx');resetme()" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Pin Code</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtpincode" runat="server" MaxLength="6" CssClass="requiredField"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers" TargetControlID="txtpincode">
                    </cc1:FilteredTextBoxExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Email ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtemail" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Landmark</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtlandmark" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="row" style="text-align:center">


               
                    <input type="button" value="Save For Misc Call" onclick="saveformisccall()" class="savebutton" id="btnSaveformisc" style="display:none" />
               
                    <input type="button" value="Register New Patient " onclick="Addme()" class="searchbutton" id="btnSave" />
               
                    
					   <%--<asp:Button ID="btnclose" runat="server" Text="Close"   CssClass="resetbutton" />--%>
                   <input type="button" value="Close" id="btnclose" onclick="resetme();" class="resetbutton" />
               


            </div>



            <div class="hcrequest" style="width: 99%; background-color: aqua;"></div>
        </div>
    </asp:Panel>


    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="btnclose" TargetControlID="btnCloseOnlinePOPUP"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlsavedata">
    </cc1:ModalPopupExtender>


    <cc1:ModalPopupExtender ID="modelCallDetail" runat="server" CancelControlID="btnCloseCallDetail" OnCancelScript="clearCallDetail()" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlCallDetail">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnlCallDetail" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
            <div class="Purchaseheader">
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: center; width: 40%">Call Details &nbsp;:<span id="spnCallDetailNo" style="font-weight: bold"></span>
                        </td>

                    </tr>
                </table>
            </div>
            <div class="content" style="text-align: center;">
                <div style="overflow: scroll; height: 220px; background-color: papayawhip;">

                    <table id="tblCallDetail" width="99%" cellpadding="0" rules="all" border="1" frame="box" style="display: none;">
                        <tr id="trCallDetail" style="text-align: left;">
                            <td class="GridViewHeaderStyle" style="width: 30px">S.No.</td>
                            <td class="GridViewHeaderStyle" style="width: 130px">Call DateTime</td>
                            <td class="GridViewHeaderStyle" style="width: 130px">Reason Of Call</td>
                            <td class="GridViewHeaderStyle" style="width: 130px">Attendent</td>
                            <td class="GridViewHeaderStyle" style="width: 520px">Remarks</td>

                        </tr>
                    </table>
                    <asp:Button ID="btnCloseCallDetail" runat="server" Text="Close" CssClass="resetbutton" />
                </div>
            </div>
        </div>
    </asp:Panel>


    <script type="text/javascript">
        clearCallDetail = function () {

            jQuery('#tblCallDetail tr').slice(1).remove();
        }
        var $onCountryChange = function (selectedCountryID) {
            $bindState(selectedCountryID, "1", function (selectedStateID) {
            });
        }
        var $bindState = function (CountryID, con, callback) {
            var $ddlState = jQuery('#ddlState');
            jQuery('#ddlState,#ddlCity,#ddlArea').find('option').remove();
            jQuery('#ddlState,#ddlCity,#ddlArea').chosen("destroy");
            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: CountryID, BusinessZoneID: 0 }, function (response) {
                if (con == 0)
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: jQuery('#ddlCentre').val().split('#')[3] });
                else
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });

                callback($ddlState.val());
            });
        }
        function showlength() {
            if ($('#<%=txtmobile.ClientID%>').val() != "") {
                      $('#molen').html($('#<%=txtmobile.ClientID%>').val().length);
                  }
                  else {
                      $('#molen').html('');
                  }
                  if ($.trim($('#<%=txtmobile.ClientID%>').val()) == "123456789") {
                      toast("Error", "Please Enter Valid Mobile No.");
                      $('#<%=txtmobile.ClientID%>').val('');
                      $('#molen').html('');
                      return;
                  }
                  if ($.trim($('#<%=txtmobile.ClientID%>').val()).charAt(0) == "0") {
                      toast("Error", "Please Enter Valid Mobile No.");
                      $('#<%=txtmobile.ClientID%>').val('');
                      $('#molen').html('');
                      return;
                  }

              }

    </script>



    <script type="text/javascript">

        $(function () {
            
            bindCountry();
            AutoGender();
            $("#ContentPlaceHolder1_txtdob").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var today = new Date();
                    //  var dob = new Date(value);
                    var dob = value;
                    getAge(dob, today);
                }
            });

            $("#<%= txtmobile.ClientID%>").keydown(
                    function (e) {
                        var key = (e.keyCode ? e.keyCode : e.charCode);
                        if (key == 13) {
                            e.preventDefault();


                            searcholdpatientbymobile();



                        }
                        else if (key == 9) {


                            searcholdpatientbymobile();



                        }
                    });
               });

        function bindCountry() {
            var $ddlCountry = jQuery('#ddlCountry');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: '0', StateID: '0', CityID: '0', IsStateBind: 1, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0, IsCityBind: 0, IsLocality: 0 }, function (response) {
               // if (con == 1) {
                    $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: '14', showDataValue: 1 });
                //}
            });
        }

               function AutoGender() {
                   var ddltitle = $('#<%=ddltitle.ClientID%>').val();
                   var Gender = $('#<%=ddlGender.ClientID%>').val();
                   if (ddltitle == "Mr." || ddltitle == "Master." || ddltitle == "Baba.")
                       $('#<%=ddlGender.ClientID%>').val("Male").attr('disabled', 'disabled');
                   else if (ddltitle == "Mrs." || ddltitle == "Miss." || ddltitle == "Ms." || ddltitle == "Smt." || ddltitle == "Baby." || ddltitle == "W/O")
                       $('#<%=ddlGender.ClientID%>').val("Female").attr('disabled', 'disabled');
                   else if (ddltitle == "Dr." || ddltitle == "B/O" || ddltitle == "C/O")
                       $('#<%=ddlGender.ClientID%>').val("").removeAttr('disabled');
                   else
                       $('#<%=ddlGender.ClientID%>').val("Male").removeAttr('disabled');

       }

       function getAge(birthDate, ageAtDate) {
           var daysInMonth = 30.436875; // Days in a month on average.
           // var dob = new Date(birthDate);
           //shat 05.10.17
           var dateSplit = birthDate.split("-");
           var dob = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);
           //
           var aad;
           if (!ageAtDate) aad = new Date();
           else aad = new Date(ageAtDate);
           var yearAad = aad.getFullYear();
           var yearDob = dob.getFullYear();
           var years = yearAad - yearDob; // Get age in years.
           dob.setFullYear(yearAad); // Set birthday for this year.
           var aadMillis = aad.getTime();
           var dobMillis = dob.getTime();
           if (aadMillis < dobMillis) {
               --years;
               dob.setFullYear(yearAad - 1); // Set to previous year's birthday
               dobMillis = dob.getTime();
           }
           var days = (aadMillis - dobMillis) / 86400000;
           var monthsDec = days / daysInMonth; // Months with remainder.
           var months = Math.floor(monthsDec); // Remove fraction from month.
           days = Math.floor(daysInMonth * (monthsDec - months));
           $('#<%=txtAge.ClientID%>').val(years);
                   $('#<%=txtAge1.ClientID%>').val(months);
                   $('#<%=txtAge2.ClientID%>').val(days);

               }

               function setdobop(ctrl) {
                   if ($(ctrl).is(':checked')) {
                       $('#<%=txtdob.ClientID%>').attr("disabled", false);
                       $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').attr("disabled", true);
                       jQuery('#<%=txtdob.ClientID%>').addClass('requiredField');
                       jQuery('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').removeClass('requiredField');
            }
        }
        function setdobop1(ctrl) {
            if ($(ctrl).is(':checked')) {
                $('#<%=txtdob.ClientID%>').attr("disabled", true);
                $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').attr("disabled", false);
                jQuery('#<%=txtdob.ClientID%>').removeClass('requiredField');
                jQuery('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').addClass('requiredField');
            }
        }




        function getdob() {
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if ($('#<%=txtAge.ClientID%>').val() != "") {
                if ($('#<%=txtAge.ClientID%>').val() > 110) {
                    toast("Error", "Please Enter Valid Age in Years");
                    $('#<%=txtAge.ClientID%>').val('');
                }
                ageyear = $('#<%=txtAge.ClientID%>').val();
            }
            if ($('#<%=txtAge1.ClientID%>').val() != "") {
                if ($('#<%=txtAge1.ClientID%>').val() > 12) {
                    toast("Error", "Please Enter Valid Age in Months");
                    $('#<%=txtAge1.ClientID%>').val('');
                }
                agemonth = $('#<%=txtAge1.ClientID%>').val();

            }
            if ($('#<%=txtAge2.ClientID%>').val() != "") {
                if ($('#<%=txtAge2.ClientID%>').val() > 30) {
                    toast("Error", "Please Enter Valid Age in Days");
                    $('#<%=txtAge2.ClientID%>').val('');
                }
                ageday = $('#<%=txtAge2.ClientID%>').val();
            }
            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);
            var m_names = new Array("Jan", "Feb", "Mar",
                                    "Apr", "May", "Jun", "Jul", "Aug", "Sep",
                                    "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            $('#ContentPlaceHolder1_txtdob').val(xxx);


        }
        function minTwoDigits(n) {
            return (n < 10 ? '0' : '') + n;
        }


        function bindCity(con) {

            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindCity',
                { StateID: jQuery('#<%=ddlstate.ClientID%>').val() },
                function (result) {
                    cityData = jQuery.parseJSON(result);
                    if (cityData.length == 0) {
                        jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                    }
                    else {
                        jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                        for (i = 0; i < cityData.length; i++) {
                            jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                        }
                    }
                })
            }

            function bindLocality() {

                jQuery('#<%=ddlarea.ClientID%> option').remove();
                   serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity',

                        //{ CityID:  jQuery('#<%=ddlcity.ClientID%>').val()},
                        { CityID: jQuery('#<%=ddlcity.ClientID%>').val() > 0 ? jQuery('#<%=ddlcity.ClientID%>').val() : 1 },
                       function (result) {
                           localityData = jQuery.parseJSON(result);
                           if (localityData.length == 0) {
                               jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Area Found---"));
                           }

                           else {
                               jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                               for (i = 0; i < localityData.length; i++) {
                                   jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                               }
                           }

                       })

                   }

                   function bindpincode() {

                       jQuery('#<%=txtpincode.ClientID%>').val('');
                   serverCall('customercare.aspx/bindpincode',
                       { LocalityID: jQuery('#<%=ddlarea.ClientID%>').val() },
                       function (result) {
                           pincode = result;
                           if (pincode == "") {
                               jQuery('#<%=txtpincode.ClientID%>').val('').attr('readonly', false);
                           }

                           else {
                               jQuery('#<%=txtpincode.ClientID%>').val(pincode).attr('readonly', true);
                           }

                       })
                   }




                   function searcholdpatientbymobile() {

                       if ($("#<%= txtmobile.ClientID%>").val().trim() == "") {
                       return;
                   }
                   if ($("#<%= txtmobile.ClientID%>").val().length < 10) {
                       return;
                   }
                   bindoldpatient('0');
               }

               function bindoldpatient(type) {
                   blockSearch('Searching Local...........!');
                   oldPatientSearch(type);
               }


               function oldPatientSearch(type) {


                   jQuery("#oldPatientTable tr:not(#myHeader)").remove();
                   $('#tblOnlinePatient1 tr').slice(1).remove();

                   var searchdata = $("#<%= txtmobile.ClientID%>").val().trim();
            serverCall('Customercare.aspx/BindOldPatient', { searchdata: searchdata },
                function (result) {
                    OLDPatientData = $.parseJSON(result);
                    if (OLDPatientData.length == 0) {
                        jQuery('#tblpdetail tr').remove();
                        BindOldPatientFromOnlineFilterPHR(searchdata, 'Main');
                        return;
                    }
                    else {
                        for (var i = 0; i <= OLDPatientData.length - 1; i++) {
                            var color = 'papayawhip';
                            if (OLDPatientData[i].lasthcstatus != '') {
                                color = '#c9e493';
                            }
                            var mydata = [];
                            mydata.push("<tr id='"); mydata.push(OLDPatientData[i].Patient_id); mydata.push("' style='text-align:left;background-color:"); mydata.push(color); mydata.push(";'>");
                            mydata.push('<td><input type="button" value="Select" onclick="showoldpatientdata(this);" class="savebutton" /></td>');
                            mydata.push('<td id="Patient_id">'); mydata.push(OLDPatientData[i].Patient_id); mydata.push('</td>');
                            mydata.push('<td id="NAME">'); mydata.push(OLDPatientData[i].NAME); mydata.push('</td>');
                            mydata.push('<td id="DOB">'); mydata.push(OLDPatientData[i].dob); mydata.push('</td>');
                            mydata.push('<td id="Age">'); mydata.push(getAgeset(OLDPatientData[i].dob, new Date())); mydata.push('</td>');
                            mydata.push('<td id="Gender">'); mydata.push(OLDPatientData[i].Gender); mydata.push('</td>');
                            mydata.push('<td id="Mobile">'); mydata.push(OLDPatientData[i].Mobile); mydata.push('</td>');
                            mydata.push('<td id="Locality" >'); mydata.push(OLDPatientData[i].Locality); mydata.push('</td>');
                            mydata.push('<td id="City">'); mydata.push(OLDPatientData[i].City); mydata.push('</td>');
                            mydata.push('<td id="State" >'); mydata.push(OLDPatientData[i].State); mydata.push('</td>');
                            mydata.push('<td id="Pincode">'); mydata.push(OLDPatientData[i].Pincode); mydata.push('</td>');
                            mydata.push('<td id="visitdate">'); mydata.push(OLDPatientData[i].visitdate); mydata.push('</td>');
                            mydata.push('<td id="lasthcstatus">'); mydata.push(OLDPatientData[i].lasthcstatus); mydata.push('</td>');
                            mydata.push('<td id="house_no"     style="display:none;">'); mydata.push(OLDPatientData[i].house_no); mydata.push('</td>');
                            mydata.push('<td id="localityid"      style="display:none;">'); mydata.push(OLDPatientData[i].localityid); mydata.push('</td>');
                            mydata.push('<td id="cityid"   style="display:none;">'); mydata.push(OLDPatientData[i].cityid); mydata.push('</td>');
                            mydata.push('<td id="stateid"   style="display:none;">'); mydata.push(OLDPatientData[i].stateid); mydata.push('</td>');
                            mydata.push('<td id="Email"   style="display:none;">'); mydata.push(OLDPatientData[i].Email); mydata.push('</td>');
                            mydata.push('<td id="LastCall"  style="display:none;">'); mydata.push(OLDPatientData[i].LastCall); mydata.push('</td>');
                            mydata.push('<td id="ReasonofCall"    style="display:none;">'); mydata.push(OLDPatientData[i].ReasonofCall); mydata.push('</td>');
                            mydata.push('<td id="ReferDoctor"     style="display:none;">'); mydata.push(OLDPatientData[i].ReferDoctor); mydata.push('</td>');
                            mydata.push('<td id="Source"     style="display:none;">'); mydata.push(OLDPatientData[i].Source); mydata.push('</td>');
                            mydata.push('</tr>');
                            mydata = mydata.join("");
                            $('#oldPatientTable').append(mydata);



                        }
                        bindhcrequestdata();

                        $find("<%=modelopdpatient.ClientID%>").show();


                    }
                })

            }


            function getAgeset(birthDate, ageAtDate) {
                var daysInMonth = 30.436875; // Days in a month on average.
                // var dob = new Date(birthDate);
                //shat 05.10.17
                var dateSplit = birthDate.split("-");
                var dob = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);
                //
                var aad;
                if (!ageAtDate) aad = new Date();
                else aad = new Date(ageAtDate);
                var yearAad = aad.getFullYear();
                var yearDob = dob.getFullYear();
                var years = yearAad - yearDob; // Get age in years.
                dob.setFullYear(yearAad); // Set birthday for this year.
                var aadMillis = aad.getTime();
                var dobMillis = dob.getTime();
                if (aadMillis < dobMillis) {
                    --years;
                    dob.setFullYear(yearAad - 1); // Set to previous year's birthday
                    dobMillis = dob.getTime();
                }
                var days = (aadMillis - dobMillis) / 86400000;
                var monthsDec = days / daysInMonth; // Months with remainder.
                var months = Math.floor(monthsDec); // Remove fraction from month.
                days = Math.floor(daysInMonth * (monthsDec - months));
                var age = years + " Y " + months + " M " + days + " D ";

                return age;

            }

            function CreateOldPatientOnlineFilter() {
                var oldfilter = new Array();
                oldfilter[0] = $('#<%=txtmobile.ClientID%>').val();
                   oldfilter[1] = '';
                   oldfilter[2] = '';
                   oldfilter[3] = '';
                   oldfilter[4] = ''
                   oldfilter[5] = ''
                   return oldfilter;
               }
               var tempDataToAppend;
               function BindOldPatientFromOnlineFilterPHR(searchdata, Type) {
                   blockSearch('Searching Online...........!');

                   tempDataToAppend = '';
                   /*serverCall('../Lab/Lab_PrescriptionOPD.aspx/OnlineFilter',
                       { searchdata: CreateOldPatientOnlineFilter() },
                       function (result) {
                           //console.log(result);
                           OnlinePatientData = $.parseJSON(result);
                           if (OnlinePatientData != null) {
                               if (OnlinePatientData.length > 0) {
                                   for (var i = 0; i <= OnlinePatientData.length - 1; i++) {
                                       var UHID = OnlinePatientData[i].uhid;
                                       var FirstName = OnlinePatientData[i].firstName;
                                       FirstName = (FirstName == null) ? "" : FirstName;
                                       var MiddleName = OnlinePatientData[i].middleName;
                                       MiddleName = (MiddleName == null) ? "" : MiddleName;
                                       var LastName = OnlinePatientData[i].lastName;
                                       LastName = (LastName == null) ? "" : LastName;
                                       var Gender = OnlinePatientData[i].gender;
                                       if (Gender == null) {
                                           Gender = "MALE";
                                       }
                                       Gender = (Gender.toUpperCase() == "MALE") ? "Male" : "Female";
                                       var Title = (Gender.toUpperCase() == "MALE") ? "Mr." : "Ms.";
                                       var FullName = Title + '' + FirstName + ' ' + MiddleName + ' ' + LastName;
                                       var Age = OnlinePatientData[i].age;
                                       var MobileNumber = OnlinePatientData[i].mobileNumber;
                                       var data = UHID + '|' + FullName + '|' + Age + '|' + Gender + '|' + MobileNumber;
                                       var FromType = 'PHR';
                                       if (Type == "Main") {
                                           FromType = Type;
                                       }
                                       var mydata = [];
                                       mydata.push("<tr style='text-align:left;background-color:#d8e8e6;'>");
                                       mydata.push( '<td><input type="button" value="Select"  class="savebutton"  onclick="showoldonlinepatientdata(\'');mydata.push(FromType);mydata.push('\',\'');mydata.push(data);mydata.push('\');" /></td>');
                                       mydata.push( '<td>');mydata.push(UHID);mydata.push('</td>');
                                       mydata.push( '<td>');mydata.push(FullName);mydata.push('</td>');
                                       mydata.push( '<td>');mydata.push(Age);mydata.push('</td>');
                                       mydata.push( '<td>');mydata.push(Gender);mydata.push('</td>');
                                       mydata.push( '<td id="Mobile">');mydata.push(MobileNumber);mydata.push('</td>');
                                       mydata.push( '<td>Online</td>');
                                       if (Type == "Main") {
                                           //PNameMob[i] = FullName;
                                           $('#tblOnlinePatient1').append(mydata);*/
                   //$find("<%=ModalPopupOnlineFilter.ClientID%>").show();
            /*}
            mydata = mydata.join("");
            $('#tblOnlinePatient').append(mydata);
        }
    }
}
if ($('#tblOnlinePatient1 tr').length <= 1) {
    toast("Error","No Patient Found..!");*/
            //$find("<%=ModalPopupExtender1.ClientID%>").show();
            //$('#<%=txtnewmobile.ClientID%>').val($('#<%=txtmobile.ClientID%>').val());
            //bindhcrequestdata();

            /*}

        })*/



            //new popup if no patient found
            toast("Error", "No Patient Found..!");
            $find("<%=ModalPopupExtender1.ClientID%>").show();
            $('#<%=txtnewmobile.ClientID%>').val($('#<%=txtmobile.ClientID%>').val());
            bindhcrequestdata();
        }





        function clearOldpatient() {
            callblurFunc = false;
            jQuery("#oldPatientTable tr:not(#myHeader)").remove();
            jQuery('#tblOnlinePatient2 tr').slice(1).remove();
        }

        function clearOldOnlinepatient() {
            jQuery('#tblOnlinePatient1 tr').slice(1).remove();
        }

        function blockSearch(displayMessage) {
            //jQuery.blockUI({
            //    css: {
            //        border: 'none',
            //        padding: '15px',
            //        backgroundColor: '#4CAF50',
            //        '-webkit-border-radius': '10px',
            //        '-moz-border-radius': '10px',
            //        color: '#fff',
            //        fontWeight: 'bold',
            //        fontSize: '16px',
            //        fontfamily: 'initial',
            //        'z-index': '111111',
            //    },
            //    message: displayMessage
            //});
        }


        function showoldpatientdata(ctrl) {

            jQuery('#tblpdetail tr').remove();


            var mydata = [];
            mydata.push('<tr style="font-weight: bold">');
            mydata.push('<td>UHID :</td><td style="color:maroon;" id="Patientuhid">'); mydata.push($(ctrl).closest('tr').find('#Patient_id').text()); mydata.push('</td>');
            mydata.push('<td>Patient Name :</td><td style="color:maroon;" id="Patientname">'); mydata.push($(ctrl).closest('tr').find('#NAME').text()); mydata.push('</td>');
            mydata.push('<td>Age :</td><td style="color:maroon;">'); mydata.push($(ctrl).closest('tr').find('#Age').text()); mydata.push('</td>');
            mydata.push('<td>Gender :</td><td style="color:maroon;">'); mydata.push($(ctrl).closest('tr').find('#Gender').text()); mydata.push('</td>');
            mydata.push('</tr>');
            mydata.push('<tr style="font-weight: bold">');
            mydata.push('<td>Mobile :</td><td style="color:maroon;" id="Patientmobile">'); mydata.push($(ctrl).closest('tr').find('#Mobile').text()); mydata.push('</td>');
            mydata.push('<td>Email :</td><td style="color:maroon;" id="PatientEmail" colspan="3">'); mydata.push($(ctrl).closest('tr').find('#Email').text()); mydata.push('</td>');
            mydata.push('<td>DOB :</td><td style="color:maroon;" id="PatientDOB">'); mydata.push($(ctrl).closest('tr').find('#DOB').text()); mydata.push('</td>');
            mydata.push('</tr>');
            mydata.push('<tr style="font-weight: bold">');
            mydata.push('<td>Area :</td><td style="color:maroon;">'); mydata.push($(ctrl).closest('tr').find('#Locality').text()); mydata.push('</td>');
            mydata.push('<td>City :</td><td style="color:maroon;">'); mydata.push($(ctrl).closest('tr').find('#City').text()); mydata.push('</td>');
            mydata.push('<td>State :</td><td style="color:maroon;">'); mydata.push($(ctrl).closest('tr').find('#State').text()); mydata.push('</td>');
            mydata.push('<td>Pincode :</td><td style="color:maroon;">'); mydata.push($(ctrl).closest('tr').find('#Pincode').text()); mydata.push('</td>');
            mydata.push('</tr>');
            mydata.push('<tr style="font-weight: bold">');
            mydata.push('<td>Last Call :</td><td style="color:maroon;" colspan="2">'); mydata.push($(ctrl).closest('tr').find('#LastCall').text()); mydata.push('</td>');
            mydata.push('<td>Reason of Call :</td><td style="color:maroon;" colspan="4">'); mydata.push($(ctrl).closest('tr').find('#ReasonofCall').text()); mydata.push('</td>');
            mydata.push('</tr>');
            mydata.push('<tr style="display:none;" id="trpdetail">');
            mydata.push('<td>AreaID</td><td id="AreaID">'); mydata.push($(ctrl).closest('tr').find('#localityid').text()); mydata.push('</td>');
            mydata.push('<td>cityid</td><td id="cityid">'); mydata.push($(ctrl).closest('tr').find('#cityid').text()); mydata.push('</td>');
            mydata.push('<td>stateid</td><td id="stateid">'); mydata.push($(ctrl).closest('tr').find('#stateid').text()); mydata.push('</td>');
            mydata.push('<td></td><td></td>');
            mydata.push('</tr>');


            mydata = mydata.join("")
            $('#tblpdetail').append(mydata);

            serverCall('Customercare.aspx/BindOldPatientHomeCollectionData',
                { searchdata: $(ctrl).closest('tr').find('#Patient_id').text() },
                function (result) {
                    OLDPatientData1 = $.parseJSON(result);
                    if (OLDPatientData1.length > 0) {
                        var mydata1 = [];

                        mydata1.push('<tr title="Last Home Collection Status" style="font-weight: bold;background-color: #5694dc;color: aquamarine;">');
                        mydata1.push('&nbsp;&nbsp;&nbsp;');
                        mydata1.push('<td colspan="8"><span style="    background-color: blue;color: white;">Last HC Status </span>&nbsp;&nbsp; PrebookingID : <span style="color:white;">');
                        mydata1.push(OLDPatientData1[0].prebookingid); mydata1.push('</span>&nbsp;&nbsp;&nbsp;&nbsp;  AppDate : <span style="color:white;">');
                        
                        mydata1.push(OLDPatientData1[0].appdate); mydata1.push('</span>&nbsp;&nbsp;&nbsp;&nbsp;Status : <span style="color:white;">');
                       
                        mydata1.push(OLDPatientData1[0].currentstatus); mydata1.push('</span>');
                        if (OLDPatientData1[0].PhelboRating != "0") {
                            mydata1.push('&nbsp;&nbsp;&nbsp;PhelboRating :');
                           
                            for (var a = 1; a <= OLDPatientData1[0].PhelboRating; a++) {
                                mydata1.push('<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>');
                            }
                        }
                        if (OLDPatientData1[0].PatientRating != "0") {
                            mydata1.push('&nbsp;&nbsp;&nbsp;PatientRating :');
                           
                            for (var a = 1; a <= OLDPatientData1[0].PatientRating; a++) {
                                mydata1.push('<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>');
                            }
                        }
                        mydata1.push('<br/>&nbsp;&nbsp;<input type="button" value="HC History" onclick="viewhchistory(\''); mydata1.push($(ctrl).closest('tr').find('#Patient_id').text()); mydata1.push('\')" title="Click To View History" style="cursor:pointer;font-weight:bold;"/>');
                        if (OLDPatientData1[0].visitid != "") {
                           
                            mydata1.push('<span style="margin-left: 33px">VisitID : <span style="color:white;">'); mydata1.push(OLDPatientData1[0].visitid); mydata1.push('</span></span>');
                        }
                        mydata1.push('</td></tr>');
                        mydata1 = mydata1.join("");
                        $('#tblpdetail').append(mydata1);
                    }
                })




            $find("<%=modelopdpatient.ClientID%>").hide();

            $('.div_Patientinfo').show();
            $('.tab').show();
            $('#tab1').show();
            $('#tab2').show();
            $('#tab3').show();
            $('#tab4').show();
            $('#tab5').show();
            $('#tab6').show();
            clearalltab();
        }


        function viewhchistory(pid) {
            openmypopup('HomeCollectionHistory.aspx?UHID=' + pid);
        }
        getCallDetail = function (rowID) {
            PageMethods.getCallDetail($('#Patientmobile').text(), onSuccessCallDetail, OnfailureCallDetail, $('#Patientmobile').text());
        }
        onSuccessCallDetail = function (result, MobileNo) {
            var $responseData = JSON.parse(result);
            if ($responseData.status) {
                CallDetail = jQuery.parseJSON($responseData.responseDetail);
                if (CallDetail != null) {
                    $('#spnCallDetailNo').text(MobileNo);
                    for (var i = 0; i <= CallDetail.length - 1; i++) {

                        var $myData = [];
                        $myData.push("<tr >");
                        $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(i + 1); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:left">'); $myData.push(CallDetail[i].CallDateTime); $myData.push('</td>');

                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:left">'); $myData.push(CallDetail[i].Call_Type); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:left">'); $myData.push(CallDetail[i].UserName); $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:left">'); $myData.push(CallDetail[i].Remarks); $myData.push('</td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        jQuery('#tblCallDetail').append($myData);

                    }
                    jQuery('#tblCallDetail').show();
                    $find("<%=modelCallDetail.ClientID%>").show();

                }

            }
            else {
                toast("Error", $responseData.response);
            }
            //$.unblockUI();


        }
        OnfailureCallDetail = function (result) {
            //$.unblockUI();
        }
    </script>
    <script type="text/javascript">
        function validation() {
            if ($('#<%=txtnewmobile.ClientID%>').val().length == 0) {
                toast("Error", "Please Enter Valid Mobile No.");
                $('#<%=txtnewmobile.ClientID%>').focus();
                       return false;
                   }
                   if ($('#<%=txtnewmobile.ClientID%>').val().length > 10) {
                toast("Error", "Please Enter Mobile No.");
                $('#<%=txtnewmobile.ClientID%>').focus();
                       return false;
                   }


                   if ($('#<%=txtpatientname.ClientID%>').val().trim().length == 0) {
                toast("Error", "Please Enter Patient Name");
                $('#<%=txtpatientname.ClientID%>').focus();
                       return false;
                   }

                   if ($('#<%=txtdob.ClientID%>').val().length == 0) {
                toast("Error", "Please Enter DOB");
                $('#<%=txtdob.ClientID%>').focus();
                       return false;

                   }

                   var ageyear = "";
                   var agemonth = "";
                   var ageday = "";
                   if ($('#<%=txtAge.ClientID%>').val() != "") {
                       ageyear = $('#<%=txtAge.ClientID%>').val();
                   }
                   if ($('#<%=txtAge1.ClientID%>').val() != "") {
                agemonth = $('#<%=txtAge1.ClientID%>').val();
                   }
                   if ($('#<%=txtAge2.ClientID%>').val() != "") {
                ageday = $('#<%=txtAge2.ClientID%>').val();
                   }
                   if (ageyear == "" && agemonth == "" && ageday == "") {
                       toast("Error", "Please Enter Patient Age");
                       $('#<%=txtAge.ClientID%>').focus();
                       return false;
                   }
                   if ($('#<%=ddlGender.ClientID%>').val() == "") {
                toast("Error", "Please Select Patient Gender");
                $('#<%=ddlGender.ClientID%>').focus();
                       return false;
                   }


                   if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                toast("Error", "Please Select State");
                $('#<%=ddlstate.ClientID%>').focus();
                       return;
                   }

                   var length = $('#<%=ddlcity.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "Please Select City");
                $('#<%=ddlcity.ClientID%>').focus();
                       return false;
                   }

                   if ($('#<%=ddlcity.ClientID%>').val() == "0") {
                toast("Error", "Please Select City");
                $('#<%=ddlcity.ClientID%>').focus();
                       return;
                   }


                   var length1 = $('#<%=ddlarea.ClientID%> > option').length;
            if (length1 == 0) {
                toast("Error", "Please Select Area");
                $('#<%=ddlarea.ClientID%>').focus();
                       return false;
                   }

                   if ($('#<%=ddlarea.ClientID%>').val() == "0") {
                toast("Error", "Please Select Area");
                $('#<%=ddlarea.ClientID%>').focus();
                       return;
                   }

                   if ($('#<%=txtpincode.ClientID%>').val().length == 0) {
                toast("Error", "Please Enter Pin Code ");
                $('#<%=txtpincode.ClientID%>').focus();
                       return false;
                   }
                   if ($('#<%=txtpincode.ClientID%>').val().length < 6) {
                toast("Error", "Please Enter Valid Pin Code ");
                $('#<%=txtpincode.ClientID%>').focus();
                       return false;
                   }

                   if ($('#<%=txtemail.ClientID%>').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test($('#<%=txtemail.ClientID%>').val())) {
                           toast("Error", 'Incorrect Email ID');
                           $('#<%=txtemail.ClientID%>').focus();
                           return false;
                       }
                   }
                   return true;
               }

               function patientmaster() {
                   debugger;
                   var age = "";
                   var ageyear = "0";
                   var agemonth = "0";
                   var ageday = "0";
                   if ($('#<%=txtAge.ClientID%>').val() != "") {
                       ageyear = $('#<%=txtAge.ClientID%>').val();
                   }
                   if ($('#<%=txtAge1.ClientID%>').val() != "") {
                agemonth = $('#<%=txtAge1.ClientID%>').val();
                   }
                   if ($('#<%=txtAge2.ClientID%>').val() != "") {
                ageday = $('#<%=txtAge2.ClientID%>').val();
                   }
                   age = ageyear + " Y " + agemonth + " M " + ageday + " D ";

                   var ageindays = parseInt(ageyear) * 365 + parseInt(agemonth) * 30 + parseInt(ageday);


                   var objPM = new Object();
                   objPM.Patient_ID = "";
                   objPM.Title = $('#<%=ddltitle.ClientID%>').val();
                   objPM.PName = $('#<%=txtpatientname.ClientID%>').val();
            objPM.House_No = $('#<%=txtpaddress.ClientID%>').val();
            objPM.Street_Name = "";
            objPM.Locality = $('#<%=ddlarea.ClientID%> option:selected').text();
                   objPM.City = $("#<%=ddlcity.ClientID%> option:selected").text();
            if ($('#<%=txtpincode.ClientID%>').val() != "") {
                objPM.PinCode = $('#<%=txtpincode.ClientID%>').val();
                   }
                   else {
                       objPM.PinCode = "0";
                   }
                   objPM.State = $("#<%=ddlstate.ClientID%> option:selected").text();
                   objPM.Country = jQuery('#ddlCountry option:selected').text();
                   objPM.CountryID = jQuery('#ddlCountry').val();
            objPM.Phone = "";
            objPM.Mobile = $('#<%=txtnewmobile.ClientID%>').val();
                   objPM.Email = $('#<%=txtemail.ClientID%>').val();
            objPM.Street_Name = $('#<%=txtlandmark.ClientID%>').val();
            objPM.Age = age;
            objPM.AgeYear = ageyear;
            objPM.AgeMonth = agemonth;
            objPM.AgeDays = ageday;
            objPM.TotalAgeInDays = ageindays;
            objPM.DOB = $('#<%=txtdob.ClientID%>').val();
                   objPM.Gender = $("#<%=ddlGender.ClientID%> option:selected").text();
            objPM.CentreID = "1";
            objPM.StateID = $('#<%=ddlstate.ClientID%>').val();
                   objPM.CityID = $('#<%=ddlcity.ClientID%>').val();
            objPM.localityid = $('#<%=ddlarea.ClientID%>').val();
            objPM.IsOnlineFilterData = 0;
            objPM.IsDuplicate = 0;
            //
            objPM.IsDOBActual = 0;
            if ($('#<%=rdDOB.ClientID%>').is(':checked')) {
                       objPM.IsDOBActual = 1;
                   }
                   objPM.EmployeeID = "";
                   objPM.Relation = "";
                   objPM.UniqueKey = "";
                   if ($('#<%=spnPatientId.ClientID%>').html() != "") {
                       objPM.Patient_ID_Interface = $('#<%=spnPatientId.ClientID%>').html();
                   }
                   else {
                       objPM.Patient_ID_Interface = "";
                   }

                   return objPM;
               }

               function Addme() {

                   if (validation()) {


                       var patientdata = patientmaster();
                       console.log(patientdata)
                       $("#btnSave").attr('disabled', true).val("Submiting...");
                       serverCall('Customercare.aspx/SaveNewPatient',
                           { PatientDatamain: patientdata },
                           function (result) {
                               var save = result;
                               $('#btnSave').attr('disabled', false).val("Register New Patient");

                               if (save == "1") {
                                   toast("Success", "Patient Registered");
                                   resetme();
                                   bindoldpatient("0");
                               }
                               else {
                                   toast("Error", save);
                                   $('#btnSave').attr('disabled', false).val("Register New Patient");
                               }

                           })

                   }
               }

               function resetme() {
                   $('#<%=spnPatientId.ClientID%>').html('');
                   $('#<%=ddlstate.ClientID%>').prop('selectedIndex', 0);
                   jQuery('#<%=ddlarea.ClientID%> option').remove();
                   jQuery('#<%=ddlcity.ClientID%> option').remove();
                   var mobile = $('#<%=txtnewmobile.ClientID%>').val();
                   $("input[type=text]").val("");
                   $('#<%=txtmobile.ClientID%>').val(mobile);
                   $find("<%=ModalPopupExtender1.ClientID%>").hide();
               }



               function openTab(evt, tabName) {
                   var i, tabcontent, tablinks;
                   tabcontent = document.getElementsByClassName("tabcontent");
                   for (i = 0; i < tabcontent.length; i++) {
                       tabcontent[i].style.display = "none";
                   }
                   tablinks = document.getElementsByClassName("tablinks");
                   for (i = 0; i < tablinks.length; i++) {
                       tablinks[i].className = tablinks[i].className.replace(" active", "");
                   }
                   if (tabName == "LabReport") {
                       var radioselect = $('#<%=rd.ClientID %> input:checked').val();
                if (radioselect == "0") {
                    if ($('#Patientmobile').text() == "") {
                        toast("Error", "Please Select Patient");
                        return;
                    }
                }
                if (radioselect == "1") {
                    if ($('#ddlDoctor').val() == "" || $('#ddlDoctor').val() == "0" || $('#ddlDoctor').val() == null) {
                        toast("Error", "Please Select Doctor");
                        return;
                    }
                }
                if (radioselect == "2") {
                    if ($('#ddlPanel').val() == "" || $('#ddlPanel').val() == "0" || $('#ddlPanel').val() == null) {
                        toast("Error", "Please Select Panel");
                        return;
                    }
                }
                if (radioselect == "3") {
                    if ($('#ddlPccCentre').val() == "" || $('#ddlPccCentre').val() == "0" || $('#ddlPccCentre').val() == null) {
                        toast("Error", "Please Select PCC");
                        return;
                    }
                }
                var callBy = "Patient";

                $('#LabReport').html('');
                $('#LabReport').append('<iframe id="LabReportiframe" src="DeltaCheckMobile.aspx?' + $('#Patientmobile').text() + '&' + callBy + '&' + radioselect + '&' + $('#Patientname').text() + '""  style="width: 102%;height:350px;"></iframe>');
                document.getElementById(tabName).style.display = "block";
                evt.currentTarget.className += " active";
            }
            else if (tabName == "HomeCollection") {
                if ($('#Patientmobile').text() == "") {
                    toast("Error", "Please Select Patient");
                    return;
                }
                var radioselect = $('#<%=rd.ClientID %> input:checked').val();
                var callBy = "";
                if (radioselect == "0") {
                    callBy = "Patient";
                }
                if (radioselect == "1") {
                    callBy = "Doctor";
                }
                if (radioselect == "2") {
                    callBy = "PUP";
                }
                if (radioselect == "3") {
                    callBy = "PCC";
                }

                var PName = $("#Patientname").text();
                //var pEmail = $('#EmailId').text();
                //$('#HomeCollection').html('');
                //$('#HomeCollection').append('<iframe id="LabReportiframe" src="HomeCollection.aspx?UHID=' + $('#Patientuhid').text() + '"  style="width:1295px;height:350px;"></iframe>');
                //document.getElementById(tabName).style.display = "block";
                evt.currentTarget.className += " active";

                var hcrequestid = "<%=Util.GetString(Request.QueryString["appid"])%>";
                var followupcallid = "<%=Util.GetString(Request.QueryString["callid"])%>";
                if (hcrequestid != "") {

                    openmypopup('HomeCollection.aspx?UHID=' + $('#Patientuhid').text() + '&hcrequestid=' + hcrequestid);
                }
                else if (followupcallid != "") {
                    openmypopup('HomeCollection.aspx?UHID=' + $('#Patientuhid').text() + '&followupcallid=' + followupcallid);
                }
                else {
                    openmypopup('HomeCollection.aspx?UHID=' + $('#Patientuhid').text());
                }

            }
            else if (tabName == "Estimate") {

                var radioselect = $('input[name=callcenterRadio]:checked').val();
                if (radioselect == "0") {
                    if ($('#Patientmobile').text() == "") {
                        toast("Error", "Please Select Patient");
                        return;
                    }
                }
                if (radioselect == "1") {
                    if ($('#ddlDoctor').val() == "" || $('#ddlDoctor').val() == "0" || $('#ddlDoctor').val() == null) {
                        toast("Error", "Please Select Doctor");
                        return;
                    }
                }
                if (radioselect == "2") {
                    if ($('#ddlPanel').val() == "" || $('#ddlPanel').val() == "0" || $('#ddlPanel').val() == null) {
                        toast("Error", "Please Select Panel");
                        return;
                    }
                }
                if (radioselect == "3") {
                    if ($('#ddlPccCentre').val() == "" || $('#ddlPccCentre').val() == "0" || $('#ddlPccCentre').val() == null) {
                        toast("Error", "Please Select PCC");
                        return;
                    }
                }
                var callBy = "";
                if (radioselect == "0") {
                    callBy = "Patient";
                }
                else if (radioselect == "1") {
                    callBy = "Doctor";
                }
                else if (radioselect == "2") {
                    callBy = "PUP";
                }
                else if (radioselect == "3") {
                    callBy = "PCC";
                }
                var callById = $("#oldptId").text();
                var PName = $("#ptdname").text();

                if ($('#tblpdetail tr').length > 0) {
                    $('#Estimate').html('');

                    $('#Estimate').append('<iframe id="estimateiframe" src="../../Design/master/EstimateRate.aspx?UHID=' + $('#Patientuhid').text() + '"   style="width: 1325px;height:400px;"></iframe>');
                }
                else {
                    $('#Estimate').html('');

                    $('#Estimate').append('<iframe id="estimateiframe" src="../../Design/master/EstimateRate.aspx?MobileNo=' + $('#<%=txtmobile.ClientID%>').val() + '"   style="width: 1325px;height:400px;"></iframe>');
                }
                // $('#Estimate').append('<iframe id="estimateiframe" src="../../Design/master/EstimateRate.aspx?' + $('#Patientmobile').text() + '&' + callBy + '&' + callById + '&' + PName + '"  style="width: 1325px;height:400px;"></iframe>');
                document.getElementById(tabName).style.display = "block";
                evt.currentTarget.className += " active";
            }
            else if (tabName == "FeedBack") {
                var radioselect = $('input[name=callcenterRadio]:checked').val();
                if (radioselect == "0") {
                    if ($('#Patientmobile').text() == "") {
                        toast("Error", "Please Select Patient");
                        return;
                    }
                }
                if (radioselect == "1") {
                    if ($('#ddlDoctor').val() == "" || $('#ddlDoctor').val() == "0" || $('#ddlDoctor').val() == null) {
                        toast("Error", "Please Select Doctor");
                        return;
                    }
                }
                if (radioselect == "2") {
                    if ($('#ddlPanel').val() == "" || $('#ddlPanel').val() == "0" || $('#ddlPanel').val() == null) {
                        toast("Error", "Please Select Panel");
                        return;
                    }
                }
                if (radioselect == "3") {
                    if ($('#ddlPccCentre').val() == "" || $('#ddlPccCentre').val() == "0" || $('#ddlPccCentre').val() == null) {
                        toast("Error", "Please Select PCC");
                        return;
                    }
                }
                var callBy = "";
                if (radioselect == "0") {
                    callBy = "Patient";
                }
                if (radioselect == "1") {
                    callBy = "Doctor";
                }
                if (radioselect == "2") {
                    callBy = "PUP";
                }
                if (radioselect == "3") {
                    callBy = "PCC";
                }
                var callById = $("#oldptId").text();
                var PName = $("#ptdname").text();
                var pEmail = $('#EmailId').text();
                var centreID = $('#lstCentre').val();
                $('#FeedBack').html('');
                $('#FeedBack').append('<iframe id="estimateiframe" src="../../Design/CallCenter/FeedbackForm.aspx?' + $('#Patientmobile').text() + '&' + callBy + '&' + callById + '&' + PName + '&' + pEmail + '&' + centreID + '"  style="width: 1325px;height:400px;"></iframe>');
                document.getElementById(tabName).style.display = "block";
                evt.currentTarget.className += " active";
            }
            else if (tabName == "MiscCall") {


                $('#MiscCall').html('');

                if ($('#tblpdetail tr').length > 0) {
                    $('#MiscCall').append('<iframe id="MiscCallIframe" src="../../Design/CustomerCare/MiscellaneousCall.aspx?UHID=' + $('#Patientuhid').text() + '"  style="width: 1290px;height:350px;"></iframe>');
                }
                else {
                    $('#MiscCall').append('<iframe id="MiscCallIframe" src="../../Design/CustomerCare/MiscellaneousCall.aspx?MobileNo=' + $('#<%=txtmobile.ClientID%>').val() + '"  style="width: 1290px;height:350px;"></iframe>');
                }
                document.getElementById(tabName).style.display = "block";
                evt.currentTarget.className += " active";

            }
            else if (tabName == "NearByPCC") {
                $('#NearByPCC').html('');
                if ($('#tblpdetail tr').length > 0) {
                    $('#NearByPCC').append('<iframe id="MiscCallIframe" src="../../Design/CustomerCare/NearByPCC.aspx?UHID=' + $('#Patientuhid').text() + '"  style="width: 1290px;height:350px;"></iframe>');
                }
                else {
                    $('#NearByPCC').append('<iframe id="MiscCallIframe" src="../../Design/CustomerCare/NearByPCC.aspx?MobileNo=' + $('#<%=txtmobile.ClientID%>').val() + '"  style="width: 1290px;height:350px;"></iframe>');
                }
                document.getElementById(tabName).style.display = "block";
                evt.currentTarget.className += " active";
            }
            else if (tabName == "MarketingCall") {
                $('#MarketingCall').html('');
                $('#MarketingCall').append('<iframe id="MarketingIframe" src="MarketingCalls.aspx?' + $('#Patientmobile').text() + '&' + callBy + '&' + radioselect + '&' + $('#Patientname').text() + '""  style="width: 1290px;height:350px;"></iframe>');
                document.getElementById(tabName).style.display = "block";
                evt.currentTarget.className += " active";

            }

}


function openmypopup(href) {
    var width = '1200px';

    $.fancybox({
        'background': 'none',
        'hideOnOverlayClick': true,
        'overlayColor': 'gray',
        'width': width,
        'height': '800px',
        'autoScale': false,
        'autoDimensions': false,
        'transitionIn': 'fade',
        'transitionOut': 'fade',
        'speedIn': 6,
        'speedOut': 6,
        'href': href,
        'overlayShow': true,
        'type': 'iframe',
        'opacity': true,
         margin: [50, 10, 50, 10],// top, right, bottom, left
        'centerOnScroll': true,
         
        'onComplete': function () {
        },
        afterClose: function () {
        }
   
    });
}
    </script>

    <script type="text/javascript">
        function resetme_Online() {
            $('#<%=spnPatientId.ClientID%>').html('');
     $('#<%=ddlstate.ClientID%>').prop('selectedIndex', 0);
     jQuery('#<%=ddlarea.ClientID%> option').remove();
     jQuery('#<%=ddlcity.ClientID%> option').remove();
     var mobile = $('#<%=txtnewmobile.ClientID%>').val();
     $("input[type=text]").val("");
     $('#<%=txtmobile.ClientID%>').val(mobile);

         }
         function opennewpatient() {
             $find("<%=modelopdpatient.ClientID%>").hide();
            $find("<%=ModalPopupExtender1.ClientID%>").show();
            resetme_Online();
            $('#<%=txtnewmobile.ClientID%>').val($('#oldPatientTable tr').eq(1).find('#Mobile').text());
            $('#<%=txtpaddress.ClientID%>').val($('#oldPatientTable tr').eq(1).find('#house_no').text());
            $('#<%=ddlstate.ClientID%>').val($('#oldPatientTable tr').eq(1).find('#stateid').text());
            bindCity();
            $('#<%=ddlcity.ClientID%>').val($('#oldPatientTable tr').eq(1).find('#cityid').text());
            bindLocality();
            $('#<%=ddlarea.ClientID%>').val($('#oldPatientTable tr').eq(1).find('#localityid').text());
            $('#<%=txtpincode.ClientID%>').val($('#oldPatientTable tr').eq(1).find('#Pincode').text());

        }
        function showoldonlinepatientdata(main_Online, data_online) {
            $find("<%=ModalPopupOnlineFilter.ClientID%>").hide();
            $find("<%=ModalPopupExtender1.ClientID%>").show();
            var data_details = data_online.split('|');
            $('#<%=spnPatientId.ClientID%>').html(data_details[0]);
            $('#<%=txtnewmobile.ClientID%>').val(data_details[4]);
            $('#<%=txtpatientname.ClientID%>').val(data_details[1].split('.')[1]);
            $('#<%=ddltitle.ClientID%>').val(data_details[1].split('.')[0] + '.');
            $('#<%=ddlGender.ClientID%>').val(data_details[3]);
            $('#<%=txtAge.ClientID%>').val(data_details[2]);
            getdob();

        }

        function opennewpatient1() {
            $('#<%=spnPatientId.ClientID%>').html('');
            $find("<%=ModalPopupOnlineFilter.ClientID%>").hide();
            $find("<%=ModalPopupExtender1.ClientID%>").show();
            $('#<%=txtnewmobile.ClientID%>').val($('#tblOnlinePatient1 tr').eq(1).find('#Mobile').text());
        }

        function closemeplease() {
            $find("<%=ModalPopupOnlineFilter.ClientID%>").hide();
        }



        function validationformics() {
            if ($('#<%=txtnewmobile.ClientID%>').val().length == 0) {
                toast("Error", "Please Enter Valid Mobile No.");
                $('#<%=txtnewmobile.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtnewmobile.ClientID%>').val().length > 10) {
                toast("Error", "Please Enter Mobile No.");
                $('#<%=txtnewmobile.ClientID%>').focus();
                return false;
            }

            if (jQuery('#ddlCountry').val() == "0") {
                toast("Error", "Please Select Country");
                jQuery('#ddlCountry').focus();
                return;
            }

            if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                toast("Error", "Please Select State");
                $('#<%=ddlstate.ClientID%>').focus();
                return;
            }

            var length = $('#<%=ddlcity.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "Please Select City");
                $('#<%=ddlcity.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddlcity.ClientID%>').val() == "0") {
                toast("Error", "Please Select City");
                $('#<%=ddlcity.ClientID%>').focus();
                return;
            }




            if ($('#<%=txtemail.ClientID%>').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test($('#<%=txtemail.ClientID%>').val())) {
                    toast("Error", 'Incorrect Email ID');
                    $('#<%=txtemail.ClientID%>').focus();
                    return false;
                }
            }
            return true;
        }




        function saveformisccall() {

            if (validationformics()) {


                var patientdata = patientmaster();

                $("#btnSaveformisc").attr('disabled', true).val("Submiting...");
                serverCall('Customercare.aspx/SaveNewPatientforMisc',
                    { PatientDatamain: patientdata },
                    function (result) {
                        var save = result;
                        $('#btnSaveformisc').attr('disabled', false).val("Save For Misc Call");

                        if (save == "1") {
                            toast("Success", "Data Saved");
                            resetme();
                            $('.div_Patientinfo').show();
                            $('.tab').show();
                            $('#tab1').hide();
                            $('#tab2').hide();
                            $('#tab3').show();
                            $('#tab4').hide();
                            $('#tab5').show();
                            $('#tab6').show();
                            clearalltab();
                            $('#MiscCall').append('<iframe id="MiscCallIframe" src="../../Design/CustomerCare/MiscellaneousCall.aspx?MobileNo=' + patientdata.Mobile + '"  style="width: 1290px;height:350px;"></iframe>');
                            document.getElementById('MiscCall').style.display = "block";
                            evt.currentTarget.className += " active";
                            $('#tab5').addClass('active');

                        }
                        else {
                            toast("Error", save);
                            $('#btnSaveformisc').attr('disabled', false).val("Save For Misc Call");
                        }

                    })
            }
        }

        function clearalltab() {
            $('#LabReport').html('');
            $('#HomeCollection').html('');
            $('#Estimate').html('');
            $('#FeedBack').html('');
            $('#Ticket').html('');
            $('#MiscCall').html('');
            $('#MarketingCall').html('');
            $('#NearByPCC').html('');


        }

        function clearall() {
            $('#<%=txtmobile.ClientID%>').val('').focus();
            jQuery('#tblpdetail tr').remove();
            $('#molen').html('');
            $('.div_Patientinfo').hide();
            clearalltab();
        }
    </script>

    <script type="text/javascript">

        function bindhcrequestdata() {

            var hcrequestid = "<%=Util.GetString(Request.QueryString["appid"])%>";
            var followupcallid = "<%=Util.GetString(Request.QueryString["callid"])%>";
            var mobileno = $('#<%=txtmobile.ClientID%>').val();

            if (hcrequestid != "") {
                serverCall('Customercare.aspx/bindhcrequestdata',
                    { hcrequestid: hcrequestid, mobileno: mobileno },
                    function (result) {
                        hcrequestdatajson = jQuery.parseJSON(result);

                        if (hcrequestdatajson.length == 0) {
                            $('.hcrequest').html('');
                        }
                        else {
                            var hcrequestdata = [];
                            hcrequestdata.push("<table style='width:99%;'><tr><td colspan='8' style='text-align:center;font-weight:bold;'><div class='Purchaseheader'>Home Collection Request From WhatsApp</div></td></tr><tr>");
                            hcrequestdata.push('<td style="font-weight:bold;">MobileNo : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].mobileno); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">UHID : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Patient_id); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">Name : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Pname); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">Age/Gender : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Age); hcrequestdata.push('/'); hcrequestdata.push(hcrequestdatajson[0].Gender); hcrequestdata.push('</td></tr>');

                            hcrequestdata.push('<tr><td style="font-weight:bold;">Address : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Address); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">Pincode : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Pincode); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">Test : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Test); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">HCDate : </td>');

                            if (hcrequestdatajson[0].filename != "") {
                                hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Homecollectiondatetime); hcrequestdata.push('&nbsp;&nbsp;&nbsp;<a target="_blank" href="'); hcrequestdata.push(hcrequestdatajson[0].filename); hcrequestdata.push('">View File</a></td>');
                            }
                            else {
                                hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Homecollectiondatetime); hcrequestdata.push('</td>');

                            }


                            hcrequestdata.push('</tr></table>');
                            hcrequestdata = hcrequestdata.join("");
                            $('.hcrequest').html(hcrequestdata);
                        }

                    })


            }

            if (followupcallid != "") {
                serverCall('Customercare.aspx/bindfollowdata',
                    { followupcallid: followupcallid, mobileno: mobileno },
                    function (result) {
                        hcrequestdatajson = jQuery.parseJSON(result);

                        if (hcrequestdatajson.length == 0) {
                            $('.hcrequest').html('');
                        }
                        else {
                            var hcrequestdata = [];
                            hcrequestdata.push("<table style='width:99%;'><tr><td colspan='8' style='text-align:center;font-weight:bold;'><div class='Purchaseheader'>Home Collection Request From FollowUp Call</div></td></tr><tr>");
                            hcrequestdata.push('<td style="font-weight:bold;">MobileNo : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].mobileno); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">UHID : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Patient_id); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">Name : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Pname); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">Age/Gender : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Age); hcrequestdata.push('/'); hcrequestdata.push(hcrequestdatajson[0].Gender); hcrequestdata.push('</td></tr>');
                            hcrequestdata.push('<tr><td style="font-weight:bold;">Address : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Address); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">Pincode : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Pincode); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">Test : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Test); hcrequestdata.push('</td>');
                            hcrequestdata.push('<td style="font-weight:bold;">HCDate : </td>');
                            hcrequestdata.push('<td style="font-weight:bold;">'); hcrequestdata.push(hcrequestdatajson[0].Homecollectiondatetime); hcrequestdata.push('</td>');
                            hcrequestdata.push('</tr></table>');

                            hcrequestdata = hcrequestdata.join("");
                            $('.hcrequest').html(hcrequestdata);
                        }

                    })

            }
        }


    </script>
</asp:Content>

