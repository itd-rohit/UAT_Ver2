<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomecollectionSearch.aspx.cs" Inherits="Design_HomeCollection_HomecollectionSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />

     <script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>
    <link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <style type="text/css">
        #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            width: 1285px;
            left: 1%;
            top: 12%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 5px;
            background-color: #d7edff;
            border-radius: 5px;
        }

        #popup_box4 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 100px;
            width: 430px;
            background-color: #d7edff;
            left: 25%;
            top: 15%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            border-radius: 5px;
        }


        #popup_box2 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 200px;
            width: 600px;
            background-color: #d7edff;
            left: 25%;
            top: 15%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            border-radius: 5px;
        }
    </style>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>





    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Home Collection Search</strong>
        </div>

        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-2">
                    <asp:DropDownList ID="ddldateop" runat="server">
                        <asp:ListItem Value=" hc.EntryDateTime ">Entry Date</asp:ListItem>
                        <asp:ListItem Value=" hc.AppDateTime " selected="true">App Date</asp:ListItem>
                        <asp:ListItem Value=" hc.CurrentStatusDate ">Last Status</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-1">
                    <label class="pull-left">
                        From
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtfromdate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtFromTime" runat="server"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                                AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                                ControlExtender="mee_txtFromTime"
                                ControlToValidate="txtFromTime"
                                InvalidValueMessage="*">
                            </cc1:MaskedEditValidator>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                        To
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>

                </div>
                <div class="col-md-2">
                    <input type="button" value="More Filter" onclick="showmore()" style="font-weight: 700; cursor: pointer; display: none;" />
               
                    <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                                AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                                InvalidValueMessage="*">
                            </cc1:MaskedEditValidator>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                        Mobile No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtmobile" runat="server" AutoCompleteType="Disabled" MaxLength="10"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtmobile">
                    </cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Preboooking No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtprebookingid" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                </div>
            </div>
            <div class="row" id="more" runat="server">
                <div class="col-md-3">
                    <label class="pull-left">State   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlstate" runat="server" onchange="bindCity()" class="ddlstate chosen-select chosen-container"></asp:DropDownList>

                </div>

                <div class="col-md-2">
                    <label class="pull-left">City   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlcity" runat="server" onchange="bindLocality()" class="ddlcity chosen-select chosen-container"></asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Area   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlarea" runat="server" TabIndex="11" onchange="bindpincode()" class="ddlarea chosen-select chosen-container"></asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <label class="pull-left">Pincode   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtpincode" runat="server" MaxLength="6"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers" TargetControlID="txtpincode">
                    </cc1:FilteredTextBoxExtender>
                </div>
            </div>

            <div class="row more">
                <div class="col-md-3">
                    <label class="pull-left">Drop Location   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlcentre" runat="server" TabIndex="11" class="ddlcentre chosen-select chosen-container"></asp:DropDownList>
                </div>

                <div class="col-md-2">
                    <label class="pull-left">Phelbo   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlphelbo" runat="server" TabIndex="11" class="ddlphelbo chosen-select chosen-container"></asp:DropDownList>

                </div>
                <div class="col-md-2">
                    <label class="pull-left">Patient Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtpname" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Route   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:DropDownList ID="ddlRoute" runat="server" TabIndex="11" class="ddlphelbo chosen-select chosen-container"></asp:DropDownList>

                </div>
            </div>

            <div class="row" style="text-align: center">
                <input type="button" value="Search" class="searchbutton" onclick="searchdata('')" />

                <input type="button" value="Export To Excel" class="searchbutton" onclick="GetReportExcel()" />
            </div>


        </div>



        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: white; cursor: pointer;"
                        onclick="searchdata('Pending')">
                    </div>
                    <div class="col-md-2">Pending</div>

                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: deepskyblue; cursor: pointer;"
                        onclick="searchdata('DoorLock')">
                    </div>
                    <div class="col-md-2">DoorLock</div>
                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: mediumpurple; cursor: pointer;"
                        onclick="searchdata('RescheduleRequest')">
                    </div>
                    <div class="col-md-3">Reschedule Request</div>

                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink; cursor: pointer;"
                        onclick="searchdata('CancelRequest')">
                    </div>


                    <div class="col-md-3">Cancel Request</div>
                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightblue; cursor: pointer;"
                        onclick="searchdata('Rescheduled')">
                    </div>
                    <div class="col-md-2">Rescheduled</div>

                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: yellow; cursor: pointer;"
                        onclick="searchdata('CheckIn')">
                    </div>
                    <div class="col-md-2">CheckIn</div>
                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen; cursor: pointer;"
                        onclick="searchdata('Completed')">
                    </div>
                    <div class="col-md-2">Completed</div>

                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: aqua; cursor: pointer;"
                        onclick="searchdata('BookingCompleted')">
                    </div>
                    <div class="col-md-3">BookingCompleted</div>
                    <div class="col-md-1" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: hotpink; cursor: pointer;"
                        onclick="searchdata('Canceled')">
                    </div>
                    <div class="col-md-1">Canceled</div>

                </div>

            </div>
        <div class="row">
            <div style="max-height: 380px; overflow: auto;">

                <table id="tbl" style="width: 100%; border-collapse: collapse; text-align: left;">



                    <tr id="trheader">
                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                        <td class="GridViewHeaderStyle" style="width: 80px;">CreateDate</td>
                        <td class="GridViewHeaderStyle" style="width: 80px;">CreateBy</td>
                        <td class="GridViewHeaderStyle" style="width: 80px;">AppDate</td>
                        <td class="GridViewHeaderStyle">PrebookingID</td>
                        <td class="GridViewHeaderStyle">VisitNo</td>
                        <td class="GridViewHeaderStyle">MobileNo</td>
                        <td class="GridViewHeaderStyle">PatientName</td>
                        <td class="GridViewHeaderStyle">City</td>
                        <td class="GridViewHeaderStyle">Area</td>
                        <td class="GridViewHeaderStyle">Pincode</td>
                        <td class="GridViewHeaderStyle">Phelbo</td>
                        <td class="GridViewHeaderStyle">Phelbo Mo</td>
                        <td class="GridViewHeaderStyle">Phelbo Source</td>
                        <td class="GridViewHeaderStyle">DropLocation</td>
                        <td class="GridViewHeaderStyle">Status</td>

                        <td class="GridViewHeaderStyle">VisitId</td>
                        <td class="GridViewHeaderStyle">Phelbo Type</td>



                    </tr>
                </table>
            </div>
        </div>
        </div>



    </div>
    <div id="popup_box1" Style="width:97%;">
        <img src="../../App_Images/Close.ico" onclick="unloadPopupBox()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />

        <div class="POuter_Box_Inventory" style="width: 100%;">

            <div class="Purchaseheader" style="text-align: center">
                Home Collection Detail
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Current Status  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3" style="background-color: bisque">
                    <span id="crstatus"></span>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Last Update At  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="crstatusdate"></span>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">PrebookingID </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3" style="background-color: bisque">
                    <span id="spPrebookingID"></span>
                    <span id="spPrebookingapp" style="display: none;"></span>
                    <span id="spphelbotomistid" style="display: none;"></span>
                    <span id="spphelbotomistname" style="display: none;"></span>
                    <span id="spcancelremarks" style="display: none;"></span>
                    <span id="spuhid" style="display: none;"></span>
                    <span id="spPrebookingrequestdate" style="display: none;"></span>
                    <span id="spPrebookingrequestedremarks" style="display: none;"></span>
                    <span id="spPrebookingRouteName" style="display: none;"></span>
                    <span id="spPrebookingDropLocation" style="display: none;"></span>
                </div>
                 <div class="col-md-2">
                <input type="button" value="View Log" style="font-weight: bold; cursor: pointer; float: right;" onclick="openlogbox(this)" />

                 </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Patient Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10" style="background-color: bisque">
                    <span id="sbpname"></span>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Mobile </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3" style="background-color: bisque">
                    <span id="sbmobile"></span>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">State  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="spstate"></span>
                </div>

                <div class="col-md-2">
                    <label class="pull-left">City  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="spcity"></span>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Area  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="sparea"></span>
                </div>

            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Pincode  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="sppincode"></span>

                </div>
                <div class="col-md-2">
                    <label class="pull-left">LandMark  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="splandmark"></span>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Route  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="spnRoute"></span>
                   
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Address  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-21" style="background-color: bisque">
                    <span id="spaddress"></span>
                </div>


            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Remarks  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10" style="background-color: bisque">
                    <span id="spremarks"></span>
                </div>

                <div class="col-md-3 HappyCodeDown">
                    <label class="pull-left">Happy Code </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3  HappyCodeDown" style="background-color: bisque;">
                     <%  if (UserInfo.RoleID.ToString() != "253")
                        {%>
                    <span title="Click To View Happy Delivery Code" id="btcode" style="cursor: pointer; float: right; font-weight: bold; background-color: blue; color: white;" onclick="viewcode(this)">Show Happy Code</span>
                    <% }%>
                    <span id="spid" style="display: none;"></span>

                    <span onclick="hidecode(this)" title="Click To Hide Happy Delivery Code" style="display: none; float: right; cursor: pointer; font-weight: bold; background-color: black; color: white;" id="spcode"></span>

                </div>

            </div>
            <div class="row" id="trcancel" style="display: none;">
                <div class="col-md-2">
                    <label class="pull-left">Cancel Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="spcanceldate"></span>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Cancel Reason  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="spcancelreason"></span>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">Cancel By  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="background-color: bisque">
                    <span id="spcancelby"></span>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <input type="button" value="Show Not available Data" id="btnget" style="font-weight: bold; cursor: pointer;" onclick="openmyavailable()" />
            </div>

            <div class="row">
                <table id="detailtable1" style="width: 100%; border-collapse: collapse; text-align: left; font-weight: bold;">
                    <tr id="tr1">
                        <td class="GridViewHeaderStyle">Entry Date</td>
                        <td class="GridViewHeaderStyle">Entry By</td>
                        <td class="GridViewHeaderStyle">Appointment Date</td>
                        <td class="GridViewHeaderStyle">UHID</td>
                        <td class="GridViewHeaderStyle">Age/Gender</td>
                        <td class="GridViewHeaderStyle">AlternateMobileo </td>
                        <td class="GridViewHeaderStyle">ReferDoctor</td>
                        <td class="GridViewHeaderStyle">Client</td>
                        <td class="GridViewHeaderStyle">SourceofCollection </td>
                        <td class="GridViewHeaderStyle">VIP</td>
                    </tr>
                </table>
            </div>
            <div class="row">
                <table id="detailtable2" style="width: 100%; border-collapse: collapse; text-align: left; font-weight: bold;">
                    <tr id="tr2">
                        <td class="GridViewHeaderStyle">Phelbotomist</td>
                        <td class="GridViewHeaderStyle">PhelboMobile</td>
                        <td class="GridViewHeaderStyle">Centre</td>
                        <td class="GridViewHeaderStyle">CheckInDate </td>
                        <td class="GridViewHeaderStyle">CompletedDate</td>
                        <td class="GridViewHeaderStyle">BookingDate</td>
                        <td class="GridViewHeaderStyle">VisitID</td>
                        <td class="GridViewHeaderStyle">HardCopy</td>
                        <td class="GridViewHeaderStyle">PhelboRating</td>
                        <td class="GridViewHeaderStyle">PatientRating</td>
                    </tr>
                </table>
            </div>
            <div class="row">
                <table id="detailtable3" style="width: 100%; border-collapse: collapse; text-align: left; font-weight: bold;">
                    <tr id="tr3">
                        <td class="GridViewHeaderStyle">Phelbo Feedback</td>
                        <td class="GridViewHeaderStyle">Patient Feedback</td>
                        <td class="GridViewHeaderStyle">Images</td>
                    </tr>
                </table>
            </div>
            <div class="row">
                <div class="Purchaseheader" style="text-align: center">
                    Test Detail <span id="sptotal" style="float: right;"></span>
                </div>
                <div class="row">
                    <div style="width: 100%; overflow: auto; height: 150px;">
                        <table id="detailtable4" style="width: 100%; border-collapse: collapse; text-align: left; font-weight: bold;">
                            <tr id="tr4">
                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                <td class="GridViewHeaderStyle">Item ID</td>
                                <td class="GridViewHeaderStyle">Item Name</td>
                                <td class="GridViewHeaderStyle">Item Type</td>
                                <td class="GridViewHeaderStyle">Rate</td>
                                <td class="GridViewHeaderStyle">Disc Amt</td>
                                <td class="GridViewHeaderStyle">Net Amt</td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="row">
                    <div id="action" style="width: 100%; text-align: center; display: none;">
                        <% if (UserInfo.RoleID != 253)
                           { %>
                        <input type="button" value="Cancel" class="resetbutton" onclick="cancelme()" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    
                    <input type="button" class="savebutton" value="Edit" onclick="editappointment()" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    
                    <input type="button" value="Reschedule" class="searchbutton" onclick="resheduleappointment()" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <% } %>
                    </div>
                </div>
                <div class="row">
                    <div id="actionc" style="width: 100%; text-align: center; display: none;">
                        <input type="button" value="Reschedule" class="searchbutton" onclick="resheduleappointment()" />
                    </div>
                </div>
            </div>
            </div>
        </div>

            <div id="popup_box4">
                <img src="../../App_Images/Close.ico" onclick="unloadPopupBox4()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />
                <div class="Purchaseheader">
                    Cancel Appointment
                </div>
                <div class="row">
                    <b>PreBookingID&nbsp;&nbsp;:</b>&nbsp;<input type="text" id="txtcancelpre" readonly="readonly" style="font-weight: bold; border: 0px; color: maroon; background-color: #d7edff;" /><br />
                    <b>AppointmentDate&nbsp;&nbsp;:</b>&nbsp;<input type="text" id="txtcancelpre2" readonly="readonly" style="font-weight: bold; border: 0px; color: maroon; background-color: #d7edff;" /><br />
                    <b>Cancel Reason :</b>&nbsp;<input type="text" style="width: 300px;" maxlength="200" id="txtcancelreason" />
                </div>
                <div class="row" style="text-align: center">
                    <input type="button" value="Cancel" class="resetbutton" onclick="cancelappnow()" />

                </div>
            </div>

            <div id="popup_box2">
                <img src="../../App_Images/Close.ico" onclick="unloadPopupBox1()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />

                <div class="POuter_Box_Inventory" style="width: 600px;" id="Div1">
                    <div class="Purchaseheader">
                        Reschedule Appointment
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">Prebooking ID   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:Label ID="lbhcidre" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">Appointment Date Time   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:Label ID="lbappdatere" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">Requested Date   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:Label ID="lbrequestdate" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">Remarks   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:Label ID="lbrequestedremarks" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">Route   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:Label ID="lbrequestedroute" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">DropLocation</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:Label ID="lbrequesteddroplocation" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">Phlebotomist Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:DropDownList ID="ddlphlebonew" runat="server" Width="300px" onchange="getslot()"></asp:DropDownList>
                            <asp:Label ID="lbphlebore" runat="server" Font-Bold="true" ForeColor="Maroon" Style="display: none;"></asp:Label>
                            <asp:Label ID="lbphleboreid" runat="server" Font-Bold="true" ForeColor="Maroon" Style="display: none;"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">New Appointment Date Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-18">
                            <asp:TextBox ID="txtappdatere" runat="server" ReadOnly="true" onchange="getslot()"></asp:TextBox>&nbsp;&nbsp;
                         <cc1:CalendarExtender runat="server" ID="CalendarExtender1" TargetControlID="txtappdatere" Format="dd-MMM-yyyy" PopupButtonID="txtappdatere" />
                            <asp:DropDownList ID="ddlapptimere" runat="server" Width="100px"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <input type="button" value="Reschedule" class="savebutton" onclick="RescheduleNow()" />
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
                });

            </script>

            <script type="text/javascript">
                var roleid = '<%=roleid%>';
                $(function () {
                    bindroute();
                });
                function bindCity(con) {
                    bindroute();
                    jQuery('#<%=ddlcity.ClientID%> option').remove();
                            jQuery('#<%=ddlarea.ClientID%> option').remove();
                            $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                            $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');
                    serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: jQuery('#<%=ddlstate.ClientID%>').val() }, function (result) {
                       
                        if (result != "null") {
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
                        }
                                $('#<%=ddlcity.ClientID%>').trigger('chosen:updated');
                            });


                        }

                        function bindLocality() {

                            jQuery('#<%=ddlarea.ClientID%> option').remove();
                            $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');
                            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: $('#<%=ddlcity.ClientID%>').val() }, function (result) {
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
                                $('#<%=ddlarea.ClientID%>').trigger('chosen:updated');
                            });
                            bindphelbo();
                        }
                function bindpincode() {
                    jQuery('#<%=txtpincode.ClientID%>').val('');
                    serverCall('customercare.aspx/bindpincode', { LocalityID: $('#<%=ddlarea.ClientID%>').text() }, function (result) {
                        pincode = result;
                        if (pincode == "") {
                            jQuery('#<%=txtpincode.ClientID%>').val('').attr('readonly', false);
                        }

                        else {
                            jQuery('#<%=txtpincode.ClientID%>').val(pincode).attr('readonly', true);
                        }
                    });
                    bindcentre();

                }
               function bindcentre() {

                   jQuery('#<%=ddlcentre.ClientID%> option').remove();
                   $('#<%=ddlcentre.ClientID%>').trigger('chosen:updated');
                   serverCall('HomecollectionSearch.aspx/bindcentre', { areaid: $('#<%=ddlarea.ClientID%>').val() }, function (result) {
                       localityData = jQuery.parseJSON(result);
                       if (localityData.length == 0) {
                           jQuery('#<%=ddlcentre.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Drop Location Found---"));
                       }

                       else {
                           jQuery('#<%=ddlcentre.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                           for (i = 0; i < localityData.length; i++) {
                               jQuery('#<%=ddlcentre.ClientID%>').append(jQuery("<option></option>").val(localityData[i].droplocationid).html(localityData[i].centre));
                        }
                    }
                       $('#<%=ddlcentre.ClientID%>').trigger('chosen:updated');
                   });                 
                   bindphelbo();
                   bindroute();
               }
                function bindphelbo() {
                    jQuery('#<%=ddlphelbo.ClientID%> option').remove();
                    $('#<%=ddlphelbo.ClientID%>').trigger('chosen:updated');
                    serverCall('HomecollectionSearch.aspx/bindphelbo', { Cityid: $('#<%=ddlcity.ClientID%>').val(), areaid: jQuery('#<%=ddlarea.ClientID%>').val() }, function (result) {
                        localityData = jQuery.parseJSON(result);
                        if (localityData.length == 0) {
                            jQuery('#<%=ddlphelbo.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Phelbo Found---"));
                        }

                        else {
                            jQuery('#<%=ddlphelbo.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < localityData.length; i++) {
                                jQuery('#<%=ddlphelbo.ClientID%>').append(jQuery("<option></option>").val(localityData[i].PhlebotomistID).html(localityData[i].name));
                            }
                        }
                        $('#<%=ddlphelbo.ClientID%>').trigger('chosen:updated');
                    });
                }
                function bindroute() {
                    jQuery('#<%=ddlRoute.ClientID%> option').remove();
                     $('#<%=ddlRoute.ClientID%>').trigger('chosen:updated');
                    serverCall('HomecollectionSearch.aspx/bindroute', {}, function (result) {
                         localityData = jQuery.parseJSON(result);
                         if (localityData.length == 0) {
                             jQuery('#<%=ddlRoute.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Phelbo Found---"));
                        }

                        else {
                            jQuery('#<%=ddlRoute.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < localityData.length; i++) {
                                jQuery('#<%=ddlRoute.ClientID%>').append(jQuery("<option></option>").val(localityData[i].RouteID).html(localityData[i].Route));
                            }
                        }
                        $('#<%=ddlRoute.ClientID%>').trigger('chosen:updated');
                    });
                }
            </script>
            <script type="text/javascript">
                function searchdata(status) {
                    $('#tbl tr').slice(1).remove();
                    serverCall('HomecollectionSearch.aspx/getdata', { fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: jQuery('#<%=txttodate.ClientID%>').val(), stateId: $('#<%=ddlstate.ClientID%>').val(), cityid: $('#<%=ddlcity.ClientID%>').val(), areaid: $('#<%=ddlarea.ClientID%>').val(), pincode: $('#<%=txtpincode.ClientID%>').val(), centre: $('#<%=ddlcentre.ClientID%>').val(), phelbo: $('#<%=ddlphelbo.ClientID%>').val(), mobileno: $('#<%=txtmobile.ClientID%>').val(), pname: $('#<%=txtpname.ClientID%>').val(), status: status, dateoption: $('#<%=ddldateop.ClientID%>').val(), prebookingno: $('#<%=txtprebookingid.ClientID%>').val(), route: $('#<%=ddlRoute.ClientID%>').val(), fromtime: $('#<%=txtFromTime.ClientID%>').val(), totime: $('#<%=txtToTime.ClientID%>').val() }, function (result) {

                                ItemData = jQuery.parseJSON(result);
                                if (ItemData.length == 0) {

                                    toast("Info", "No Home Collection Data Found");
                                }
                                else {
                                    for (var i = 0; i <= ItemData.length - 1; i++) {
                                        var color = "";
                                        if (ItemData[i].cstatus == "Pending") {
                                            color = "white";
                                        }
                                        if (ItemData[i].cstatus == "CheckIn") {
                                            color = "yellow";
                                        }
                                        if (ItemData[i].cstatus == "Completed") {
                                            color = "lightgreen";
                                        }
                                        if (ItemData[i].cstatus == "BookingCompleted") {
                                            color = "aqua";
                                        }
                                        if (ItemData[i].cstatus == "Canceled") {
                                            color = "hotpink";
                                        }
                                        if (ItemData[i].cstatus == "Rescheduled") {
                                            color = "lightblue";
                                        }
                                        if (ItemData[i].cstatus == "DoorLock") {
                                            color = "deepskyblue";
                                        }
                                        if (ItemData[i].cstatus == "RescheduleRequest") {
                                            color = "mediumpurple";
                                        }
                                        if (ItemData[i].cstatus == "CancelRequest") {
                                            color = "pink";
                                        }
                                        var $mydata = [];
                                        $mydata.push("<tr style='background-color:");$mydata.push(color);$mydata.push(";' id='");$mydata.push(ItemData[i].prebookingid);$mydata.push("'>");
                                        if (roleid != '253') {
                                            $mydata.push('<td class="GridViewLabItemStyle"  id="srno">');$mydata.push(parseInt(i + 1));$mydata.push('&nbsp;&nbsp;<img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail1(this)" /></td>');
                                        }
                                        else {
                                            $mydata.push('<td class="GridViewLabItemStyle"  id="srno">');$mydata.push(parseInt(i + 1));$mydata.push('</td>');
                                        }
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="createdate" style="font-weight:bold;">');$mydata.push(ItemData[i].EntryDateTime);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="createby" style="font-weight:bold;">');$mydata.push(ItemData[i].EntryByName);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="appdate" style="font-weight:bold;">');$mydata.push(ItemData[i].appdate);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="prebookingid" style="font-weight:bold;">');$mydata.push(ItemData[i].prebookingid);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="LedgertransactionNo" style="font-weight:bold;">'); $mydata.push(ItemData[i].LedgertransactionNo); $mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="Mobile" style="font-weight:bold;">');$mydata.push(ItemData[i].Mobile);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="patientname" style="font-weight:bold;">');$mydata.push(ItemData[i].patientname);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="state" style="display:none;">');$mydata.push(ItemData[i].state);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="city" style="font-weight:bold;">');$mydata.push(ItemData[i].city);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="locality">');$mydata.push(ItemData[i].locality);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="pincode" style="font-weight:bold;">');$mydata.push(ItemData[i].pincode);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="phleboname" style="font-weight:bold;">');$mydata.push(ItemData[i].phleboname);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="phlebomobile" style="font-weight:bold;">');$mydata.push(ItemData[i].PMobile);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="phlebotype" style="font-weight:bold;">');$mydata.push(ItemData[i].PhelboSource);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="centre">');$mydata.push(ItemData[i].centre);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="cstatus" style="font-weight:bold;">');$mydata.push(ItemData[i].cstatus);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="visitid" style="font-weight:bold;">');$mydata.push(ItemData[i].visitid);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="phlebotype" style="font-weight:bold;">');$mydata.push(ItemData[i].PhelboType);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="patient_id" style="display:none;">');$mydata.push(ItemData[i].Patient_ID);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="age" style="display:none;">');$mydata.push(ItemData[i].age);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="gender" style="display:none;">');$mydata.push(ItemData[i].gender);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="patientrating" style="display:none;">');$mydata.push(ItemData[i].patientrating);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="PatientFeedback" style="display:none;">');$mydata.push(ItemData[i].PatientFeedback);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="phelborating" style="display:none;">');$mydata.push(ItemData[i].phelborating);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="phelbofeedback" style="display:none;">');$mydata.push(ItemData[i].phelbofeedback);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="bookeddate" style="display:none;">');$mydata.push(ItemData[i].bookeddate);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="checkindatetime" style="display:none;">');$mydata.push(ItemData[i].checkindatetime);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="vip" style="display:none;">');$mydata.push(ItemData[i].vip);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="HardCopyRequired" style="display:none;">');$mydata.push(ItemData[i].HardCopyRequired);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="Alternatemobileno" style="display:none;">');$mydata.push(ItemData[i].Alternatemobileno);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="Client" style="display:none;">');$mydata.push(ItemData[i].Client);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="SourceofCollection" style="display:none;">');$mydata.push(ItemData[i].SourceofCollection);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="doctor" style="display:none;">');$mydata.push(ItemData[i].doctor);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="finaldonedate" style="display:none;">');$mydata.push(ItemData[i].finaldonedate);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="currentstatus" style="display:none;">');$mydata.push(ItemData[i].cstatus);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="currentstatusdate" style="display:none;">');$mydata.push(ItemData[i].currentstatusdate);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="filename" style="display:none;">');$mydata.push(ItemData[i].filename);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="House_No" style="display:none;">');$mydata.push(ItemData[i].House_No);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="landmark" style="display:none;">');$mydata.push(ItemData[i].landmark);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="VerificationCode" style="display:none;">');$mydata.push(ItemData[i].VerificationCode);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="canceldate" style="display:none;">');$mydata.push(ItemData[i].canceldatetime);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="cancelreason" style="display:none;">');$mydata.push(ItemData[i].CancelReason);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="cancelby" style="display:none;">');$mydata.push(ItemData[i].cancelbyname);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="cancelremarks" style="display:none;">');$mydata.push(ItemData[i].cancelremarks);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="PhlebotomistID" style="display:none;">');$mydata.push(ItemData[i].PhlebotomistID);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="requestdate" style="display:none;">');$mydata.push(ItemData[i].requestdate);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="requestedremarks" style="display:none;">');$mydata.push(ItemData[i].requestedremarks);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="RouteName" style="display:none;">');$mydata.push(ItemData[i].RouteName);$mydata.push('</td>');
                                        $mydata.push('<td class="GridViewLabItemStyle"  id="Remarks" style="display:none;">');$mydata.push(ItemData[i].Remarks);$mydata.push('</td>');
                                        $mydata.push("</tr>");
                                        $mydata=$mydata.join("");
                                        $('#tbl').append($mydata);
                                    }
                                }
                            });
                        }

                        function showdetail(ctrl) {
                            var id = $(ctrl).closest('tr').attr("id");
                            if ($('table#tbl').find('#ItemDetail' + id).length > 0) {
                                $('table#tbl tr#ItemDetail' + id).remove();
                                $(ctrl).attr("src", "../../App_Images/plus.png");
                                return;
                            }
                            serverCall('homecollectionsearch.aspx/BindItemDetail', { prebookingid: id }, function (result) {
                                ItemData = jQuery.parseJSON(result);
                                if (ItemData.length == 0) {

                                }
                                else {
                                    $(ctrl).attr("src", "../../App_Images/minus.png");
                                    var $mydata=[];
                                    $mydata.push("<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0'>");
                                    $mydata.push('<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">');
                                    $mydata.push('<td  style="width:20px;">#</td>');
                                    $mydata.push('<td>Item ID</td>');
                                    $mydata.push('<td>Item Name</td>');
                                    $mydata.push('<td>Item Type</td>');
                                    $mydata.push('<td>Rate</td>');
                                    $mydata.push('<td>DiscAmt</td>');
                                    $mydata.push('<td>NetAmt</td>');
                                    for (var i = 0; i <= ItemData.length - 1; i++) {
                                        var $mydata1=[];
                                        $mydata1.push("<tr style='background-color:azure;' id='");$mydata1.push(ItemData[i].stockid);$mydata1.push("'>");
                                        $mydata1.push('<td>');$mydata1.push(parseInt(i + 1));$mydata1.push('</td>');
                                        $mydata1.push('<td>');$mydata1.push(ItemData[i].itemid);$mydata1.push('</td>');
                                        $mydata1.push('<td>');$mydata1.push(ItemData[i].itemname);$mydata1.push('</td>');
                                        $mydata1.push('<td>');$mydata1.push(ItemData[i].itemtype);$mydata1.push('</td>');
                                        $mydata1.push('<td>');$mydata1.push(ItemData[i].rate);$mydata1.push('</td>');
                                        $mydata1.push('<td>');$mydata1.push(ItemData[i].discamt);$mydata1.push('</td>');
                                        $mydata1.push('<td>');$mydata1.push(ItemData[i].netamt);$mydata1.push('</td>');
                                        $mydata1.push("</tr>");
                                        $mydata=$mydata1.join("");
                                    }
                                    $mydata.push("</table><div>");
                                    var newdata=[];
                                    newdata.push('<tr id="ItemDetail');newdata.push(id);newdata.push('"><td colspan="19">');newdata.push($mydata.join(""));newdata.push('</td></tr>');
                                    $(newdata.join("")).insertAfter($(ctrl).closest('tr'));

                                }
                            });
           
                        }
                        function showdetail1(ctrl) {
                            if ($(ctrl).closest('tr').find("#currentstatus").text() == "Pending" || $(ctrl).closest('tr').find("#currentstatus").text() == "DoorLock" || $(ctrl).closest('tr').find("#currentstatus").text() == "RescheduleRequest" || $(ctrl).closest('tr').find("#currentstatus").text() == "CancelRequest" || $(ctrl).closest('tr').find("#currentstatus").text() == "Rescheduled") {
                                $('#action').show();
                            }
                            else {
                                $('#action').hide();
                            }
                            if ($(ctrl).closest('tr').find("#currentstatus").text() == "Canceled") {
                                $('#actionc').show();
                            }
                            else {
                                $('#actionc').hide();
                            }
                            $('#maindetail').css('background-color', $(ctrl).closest('tr').css("background-color"));
                            $('#crstatus').html($(ctrl).closest('tr').find("#currentstatus").text());
                            $('#crstatusdate').html($(ctrl).closest('tr').find("#currentstatusdate").text());
                            $('#spPrebookingID').html($(ctrl).closest('tr').find("#prebookingid").text());
                            $('#spPrebookingapp').html($(ctrl).closest('tr').find("#appdate").text());
                            $('#spphelbotomistid').html($(ctrl).closest('tr').find("#PhlebotomistID").text());
                            $('#spphelbotomistname').html($(ctrl).closest('tr').find("#phleboname").text());
                            $('#spPrebookingrequestdate').html($(ctrl).closest('tr').find("#requestdate").text());
                            $('#spPrebookingrequestedremarks').html($(ctrl).closest('tr').find("#requestedremarks").text());
                            $('#spPrebookingRouteName').html($(ctrl).closest('tr').find("#RouteName").text());
                            $('#spPrebookingDropLocation').html($(ctrl).closest('tr').find("#centre").text());
                            $('#spcancelremarks').html($(ctrl).closest('tr').find("#cancelremarks").text());
                            $('#spuhid').html($(ctrl).closest('tr').find("#patient_id").text());
                            $('#sbpname').html($(ctrl).closest('tr').find("#patientname").text());
                            $('#sbmobile').html($(ctrl).closest('tr').find("#Mobile").text());
                            $('#spstate').html($(ctrl).closest('tr').find("#state").text());
                            $('#spcity').html($(ctrl).closest('tr').find("#city").text());
                            $('#sparea').html($(ctrl).closest('tr').find("#locality").text());
                            $('#sppincode').html($(ctrl).closest('tr').find("#pincode").text());
                            $('#spaddress').html($(ctrl).closest('tr').find("#House_No").text());
                            $('#spremarks').html($(ctrl).closest('tr').find("#Remarks").text());
                            $('#splandmark').html($(ctrl).closest('tr').find("#landmark").text());
                            $('#spnRoute').html($(ctrl).closest('tr').find("#RouteName").text());
                            $('#spcode').html($(ctrl).closest('tr').find("#VerificationCode").text());
                            $('#spcode').hide();
                            $('#btcode').show();
                            $('#spid').html($(ctrl).closest('tr').find("#prebookingid").text());
                            if ($(ctrl).closest('tr').find("#currentstatus").text() == "Canceled") {
                                $('#trcancel').show();
                                $('#spcanceldate').html($(ctrl).closest('tr').find("#canceldate").text());
                                $('#spcancelreason').html($(ctrl).closest('tr').find("#cancelreason").text());
                                $('#spcancelby').html($(ctrl).closest('tr').find("#cancelby").text());
                            }
                            else {
                                $('#trcancel').hide();
                                $('#spcanceldate').html('');
                                $('#spcancelreason').html('');
                                $('#spcancelby').html('');
                            }

                            $('#detailtable1 tr').slice(1).remove();
                            var mydata = [];
                            mydata.push('<tr style="background-color: blanchedalmond;">');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#createdate").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#createby").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#appdate").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#patient_id").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#age").text());mydata.push('/');mydata.push($(ctrl).closest('tr').find("#gender").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#Alternatemobileno").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#doctor").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#Client").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#SourceofCollection").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push(($(ctrl).closest('tr').find("#vip").text() == "1" ? 'Yes' : 'No'));mydata.push('</td>');
                            mydata.push('</tr>');
                            $('#detailtable1').append(mydata.join(""));

                            mydata = [];
                            $('#detailtable2 tr').slice(1).remove();
                            mydata.push('<tr style="background-color: blanchedalmond;">');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#phleboname").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#phlebomobile").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#centre").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#checkindatetime").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#bookeddate").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#finaldonedate").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#visitid").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push(($(ctrl).closest('tr').find("#HardCopyRequired").text() == "1" ? 'Yes' : 'No'));mydata.push('</td>');

                            mydata.push('<td class="GridViewLabItemStyle" style="background-color: gray;" >');
                            for (var a = 1; a <= $(ctrl).closest('tr').find("#phelborating").text() ; a++) {
                                mydata.push('<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>');
                            }
                            mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle" style="background-color: gray;" >');
                            for (var a = 1; a <= $(ctrl).closest('tr').find("#patientrating").text() ; a++) {
                                mydata.push('<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>');
                            }
                            mydata.push('</td>');
                            mydata.push('</tr>');
                            $('#detailtable2').append(mydata.join(""));

                            mydata = [];
                            $('#detailtable3 tr').slice(1).remove();
                            mydata.push('<tr style="background-color: blanchedalmond;">');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#phelbofeedback").text());mydata.push('</td>');
                            mydata.push('<td class="GridViewLabItemStyle">');mydata.push($(ctrl).closest('tr').find("#PatientFeedback").text());mydata.push('</td>');

                            mydata.push('<td class="GridViewLabItemStyle">');
                            if ($(ctrl).closest('tr').find("#filename").text() != "") {
                                for (var c = 0; c <= $(ctrl).closest('tr').find("#filename").text().split(',').length - 1; c++) {
                                    mydata.push('<img onclick="openmyimage(\'');mydata.push($(ctrl).closest('tr').find("#filename").text().split(',')[c].split('#')[0]);mydata.push('\')" style="cursor:pointer;" src="../../App_Images/view.gif" title="');mydata.push($(ctrl).closest('tr').find("#filename").text().split(',')[c].split('#')[1]);mydata.push('"/>&nbsp;&nbsp;');
                                }
                            }
                            mydata.push('</td>');
                            mydata.push('</tr>');
                            $('#detailtable3').append(mydata.join());
                            $('#detailtable4 tr').slice(1).remove();
                            serverCall('homecollectionsearch.aspx/BindItemDetail', { prebookingid: $(ctrl).closest('tr').attr("id") }, function (result) {
                                ItemData = jQuery.parseJSON(result);
                                var total = 0;
                                if (ItemData.length == 0) {
                                    toast("Info", "No Item Found");
                                }
                                else {
                                    var mydata = [];
                                    for (var i = 0; i <= ItemData.length - 1; i++) {
                                        var $mydata = [];
                                        $mydata.push("<tr style='background-color:blanchedalmond;'>");
                                        $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(parseInt(i + 1) );$mydata.push('</td>');
                                        $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].itemid);$mydata.push('</td>');
                                        $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].itemname);$mydata.push('</td>');
                                        $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].itemtype);$mydata.push('</td>');
                                        $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].rate);$mydata.push('</td>');
                                        $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].discamt);$mydata.push('</td>');
                                        $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].netamt);$mydata.push('</td>');
                                        $mydata.push("</tr>");
                                        total = total + Number(ItemData[i].netamt);
                                        $mydata = $mydata.join("");
                                        $('#detailtable4').append($mydata);
                                    }                  
                                }
                                $('#sptotal').html("Payment Mode : " + ItemData[0].paymentmode + "   Total Amount : " + total + "   ");
                            });          
                            $('#popup_box1').fadeIn("slow");
                            $("#Pbody_box_inventory").css({
                                "opacity": "0.5"
                            });
                        }
                        function viewcode(ctrl) {

                            $(ctrl).hide('slow');
                            $("#spcode").show('slow');
                            serverCall('HomeCollectionHistory.aspx/SaveCodeLog', { pid: $('#spPrebookingID').html() }, function (result) {
                            });

                           
                        }
                        function hidecode(ctrl) {
                            $(ctrl).hide('slow');
                            $("#btcode").show('slow');
                           
                        }
                        function unloadPopupBox() {
                            $('#popup_box1').fadeOut("slow");
                            $("#Pbody_box_inventory").css({
                                "opacity": "1"
                            });
                        }
                        function showmore() {
                            $('.more').toggle('slow');
                        }
                        function GetReportExcel() {
                            serverCall('HomecollectionSearch.aspx/exporttoexcel', { fromdate: $('#<%=txtfromdate.ClientID%>').val(), todate: $('#<%=txttodate.ClientID%>').val(), stateId: $('#<%=ddlstate.ClientID%>').val(), cityid: $('#<%=ddlcity.ClientID%>').val(), areaid: $('#<%=ddlarea.ClientID%>').val(), pincode: $('#<%=txtpincode.ClientID%>').val(), centre: $('#<%=ddlcentre.ClientID%>').val(), phelbo: $('#<%=ddlphelbo.ClientID%>').val(), mobileno: $('#<%=txtmobile.ClientID%>').val(), pname: $('#<%=txtpname.ClientID%>').val(), dateoption: $('#<%=ddldateop.ClientID%>').val(), prebookingno: $('#<%=txtprebookingid.ClientID%>').val() }, function (result) {
                ItemData = result;
                if (ItemData == "false") {
                    toast("Info", "No Item Found");
                }
                else {
                    window.open('../common/ExportToExcel.aspx');
                }
            });         
        }
        function openlogbox(ctrl) {
            openmypopup("HomeCollectionLog.aspx?prebookingid=" + $('#spPrebookingID').html());
        }
        function openmypopup(href) {
            var width = '720px';
            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '500px',
                'min-height': '500px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
        function openmyimage(id) {
            openmypopup("ViewHCImage.aspx?id=" + id);
        }
        function unloadPopupBox4() {
            $('#popup_box4').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
            $("#popup_box1").css({
                "opacity": "1"
            });
        }
        function cancelme() {
            $('#txtcancelpre').val($('#spPrebookingID').html());
            $('#txtcancelpre2').val($('#spPrebookingapp').html());
            $('#txtcancelreason').val($('#spcancelremarks').html());
            $('#popup_box4').fadeIn("slow");
            $("#popup_box1").css({
                "opacity": "0.5"
            });
            $("#Pbody_box_inventory").css({
                "opacity": "0"
            });
        }
        function cancelappnow() {
            if ($('#txtcancelreason').val() == "") {
                toast("Error", "Please Enter Cancel Reason");
                return;
            }
            serverCall('HomeCollection.aspx/CancelAppointment', { appid: $('#txtcancelpre').val(), reason: $('#txtcancelreason').val() }, function (result) {
                if (result == "1") {
                    toast("Success", "Appointment Cancel");
                    $('#popup_box4').fadeOut("slow");
                    $("#popup_box1").css({
                        "opacity": "1"
                    });
                    $("#Pbody_box_inventory").css({
                        "opacity": "1"
                    });
                    unloadPopupBox();
                    searchdata('');
                }
            });          
        }
        function openmypopup1(href) {
            var width = '1300px';

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '900px',
                'min-height': '900px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
        function editappointment() {
            openmypopup1('HomeCollection.aspx?UHID=' + $('#spuhid').html() + '&prebookingid=' + $('#spPrebookingID').html() + '&type=1');
        }
            </script>
            <script type="text/javascript">
                function unloadPopupBox1() {
                    $('#popup_box2').fadeOut("slow");
                    $("#Pbody_box_inventory").css({
                        "opacity": "0.5"
                    });
                    $("#popup_box1").css({
                        "opacity": "1"
                    });
                }
                function resheduleappointment() {
                    var prebookingid = $('#spPrebookingID').html();
                    var phelbotomistid = $('#spphelbotomistid').html();
                    var appdate = $('#spPrebookingapp').html();
                    $('#<%=lbrequestdate.ClientID%>').text($('#spPrebookingrequestdate').html());
                            $('#<%=lbrequestedremarks.ClientID%>').text($('#spPrebookingrequestedremarks').html());
                            $('#<%=lbrequestedroute.ClientID%>').text($('#spPrebookingRouteName').html());
                            $('#<%=lbrequesteddroplocation.ClientID%>').text($('#spPrebookingDropLocation').html());
                            $('#<%=lbhcidre.ClientID%>').text(prebookingid);
                            $('#<%=lbappdatere.ClientID%>').text(appdate);
                            $('#<%=lbphleboreid.ClientID%>').text(phelbotomistid);
                            $('#<%=lbphlebore.ClientID%>').text($('#spphelbotomistname').html());
                            $('#<%=txtappdatere.ClientID%>').val(appdate.split(' ')[0]);
                            $('#popup_box2').fadeIn("slow");
                            $("#popup_box1").css({
                                "opacity": "0.5"
                            });
                            $("#Pbody_box_inventory").css({
                                "opacity": "0"
                            });
                            getphelbotomist();
                            getslot();
                        }
                        function getphelbotomist() {
                            jQuery('#<%=ddlphlebonew.ClientID%> option').remove();
                            serverCall('HomeCollection.aspx/getphelbotomistlist', { prebookingid: $('#<%=lbhcidre.ClientID%>').text() }, function (result) {
                                centreData = $.parseJSON(result);
                                for (i = 0; i < centreData.length; i++) {
                                    jQuery("#<%=ddlphlebonew.ClientID%>").append(jQuery("<option></option>").val(centreData[i].PhlebotomistID).html(centreData[i].Name));

                                }
                                if ($("#<%=ddlphlebonew.ClientID%> option[value='" + $('#<%=lbphleboreid.ClientID%>').text() + "']").length > 0) {
                                    jQuery("#<%=ddlphlebonew.ClientID%>").val($('#<%=lbphleboreid.ClientID%>').text());
                                }
                                else {
                                    jQuery("#<%=ddlphlebonew.ClientID%>").append(jQuery("<option></option>").val($('#<%=lbphleboreid.ClientID%>').text()).html($('#<%=lbphlebore.ClientID%>').text()));
                                    jQuery("#<%=ddlphlebonew.ClientID%>").val($('#<%=lbphleboreid.ClientID%>').text());
                                }
                            });                  
                        }
                        function getslot() {
                            jQuery('#<%=ddlapptimere.ClientID%> option').remove();
                            serverCall('HomeCollection.aspx/getslot', { prebookingid: $('#<%=lbhcidre.ClientID%>').text(), appdate: $('#<%=txtappdatere.ClientID%>').val(), phelbotomist: $('#<%=ddlphlebonew.ClientID%>').val(), oldphelbo: $('#<%=lbphleboreid.ClientID%>').text() }, function (result) {
                                centreData = $.parseJSON(result);
                                jQuery("#<%=ddlapptimere.ClientID%>").append(jQuery("<option></option>").val("0").html("Select Slot"));
                                for (i = 0; i < centreData.length; i++) {
                                    if (parseInt(centreData[i].isbooked) == 0) {
                                        jQuery("#<%=ddlapptimere.ClientID%>").append(jQuery("<option></option>").val(centreData[i].Timeslot).html(centreData[i].Timeslot));
                                    }
                                    else {
                                        jQuery("#<%=ddlapptimere.ClientID%>").append(jQuery("<option disabled></option>").val(centreData[i].Timeslot).html(centreData[i].Timeslot));

                                    }

                                }

                            });                            
                        }
                function RescheduleNow() {
                    if ($('#<%=ddlapptimere.ClientID%>').val() == "0") {
                        $('#<%=ddlapptimere.ClientID%>').focus();
                        toast("Error", "Please Select Appointment Time");
                        return;
                    }
                    savereschedule($('#<%=lbhcidre.ClientID%>').text(), $('#<%=txtappdatere.ClientID%>').val(), $('#<%=ddlapptimere.ClientID%>').val(), $('#<%=ddlphlebonew.ClientID%>').val());
                }
                function savereschedule(prebookingid, appdate, apptime, phelbotomistid) {
                    serverCall('HomeCollection.aspx/RescheduleNow', { prebookingid: prebookingid, appdate: appdate, apptime: apptime, phelbotomistid: phelbotomistid }, function (result) {
                        if (result == "1") {
                            toast("Success", "Appointment Rescheduled ");
                            $('#popup_box2').fadeOut("slow");

                            $("#popup_box1").css({
                                "opacity": "1"
                            });
                            $("#Pbody_box_inventory").css({
                                "opacity": "1"
                            });
                            unloadPopupBox();
                            searchdata('');
                        }
                        else {
                            toast("Error", result);
                        }
                    });
                }
                function openmypopup1(href) {
                    var width = '1110px';
                    $.fancybox({
                        'background': 'none',
                        'hideOnOverlayClick': true,
                        'overlayColor': 'gray',
                        'width': width,
                        'height': '500px',
                        'min-height': '500px',
                        'autoScale': false,
                        'autoDimensions': false,
                        'transitionIn': 'elastic',
                        'transitionOut': 'elastic',
                        'speedIn': 6,
                        'speedOut': 6,
                        'href': href,
                        'overlayShow': true,
                        'type': 'iframe',
                        'opacity': true,
                        'centerOnScroll': true,
                        'onComplete': function () {
                        },
                        afterClose: function () {
                        }
                    });

                }
                function openmyavailable() {
                    openmypopup1("HomeCollectionNALog.aspx?prebookingid=" + $('#spPrebookingID').html());

                }
            </script>
</asp:Content>

