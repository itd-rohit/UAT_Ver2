<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HomeCollection.aspx.cs" Inherits="Design_HomeCollection_HomeCollection" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <style type="text/css">
        #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 460px;
            /*width: 1180px;*/
            left: 1%;
            top: 5%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            margin-right: 15px;
            /* additional features, can be omitted d7edff*/
            border: 2px solid #ff0000;
            padding: 5px;
            background-color: #eaf3fd;
            border-radius: 5px;
            background-image:url(../../App_Images/patter.jpg) !important;
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

        #popup_box3 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 400px;
            background-color: white;
            left: 25%;
            top: 15%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
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

        #popup_box5 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 750px;
            background-color: #d7edff;
            left: 15%;
            top: 15%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            border-radius: 5px;
        }


        #popup_box6 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 250px;
            width: 1110px;
            background-color: #e8d4ea;
            left: 1%;
            top: 15%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            border-radius: 5px;
        }

        #popup_box7 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            width: 610px;
            background-color: #ececec;
            left: 20%;
            top: 15%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            border-radius: 5px;
        }

        #slottable tr:not(:first-child) td:hover {
            background: #a7d4ea !important;
        }

        #slottable {
            box-shadow: 0 4px 10px 0 rgba(0,0,0,0.2), 0 4px 20px 0 rgba(0,0,0,0.19);
            border: 1px solid #ccc;
        }

        .lastthreevisit {
            position: fixed;
            bottom: 0px;
            left: 30px;
            z-index: 1;
            text-align: center;
            display: none;
            /*width:1200px;*/
        }

        .mylast3visit {
            display: none;
            border: solid 4px #006699;
            background-color: #DEDEDE;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }

        .btnopenlast3 {
            display: block;
            padding: 2px;
            margin: 0 auto;
            background-color: #006699;
            color: #FFFFFF;
            font-size: 14px;
            cursor: pointer;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            border-bottom-right-radius: 10px;
            border-bottom-left-radius: 10px;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }
        .containeritemsuggestion {
            position: fixed;
            top: 23px;
            right: 0%;
            z-index: 1;
            text-align: center;
            display: none;
            width: 400px;
        }
        .feedbacksuggestion {
            display: none;
            border: solid 4px #006699;
            background-color: #DEDEDE;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }

        a.button-slidesuggest {
            display: block;
            width: 120px;
            padding: 2px;
            margin: 0 auto;
            background-color: #006699;
            color: #FFFFFF;
            font-size: 14px;
            width: 160px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            border-bottom-right-radius: 10px;
            border-bottom-left-radius: 10px;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }

        .container {
            position: fixed;
            bottom: 0px;
            right: 0px;
            z-index: 1;
            text-align: center;
            display: none;
        }

        .feedback {
            display: none;
            border: solid 4px #006699;
            background-color: #DEDEDE;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }

        a.button-slide {
            display: block;
            width: 120px;
            padding: 2px;
            margin: 0 auto;
            background-color: maroon;
            color: #FFFFFF;
            font-size: 14px;
            width: 160px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            border-bottom-right-radius: 10px;
            border-bottom-left-radius: 10px;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }

        .conPackageDetail {
            position: fixed;
            top: 23px;
            left: 23%;
            z-index: 1;
            text-align: center;
            display: none;
        }

        .divPackageRecommended {
            display: none;
            border: solid 4px #006699;
            background-color: #DEDEDE;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }

        a.button-slidepackageRecommended {
            display: block;
            padding: 2px;
            margin: 0 auto;
            background-color: maroon;
            color: #FFFFFF;
            font-size: 14px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            border-bottom-right-radius: 10px;
            border-bottom-left-radius: 10px;
            -webkit-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            -moz-box-shadow: 0 1px 5px rgba(0,0,0,0.75);
            box-shadow: 0 1px 5px rgba(0,0,0,0.75);
        }

        #tblPackageSuggestion tr:hover {
            background-color: #90EE90;
            cursor: pointer;
        }
    </style>
</head>

<body>
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="sm1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Lab/Services/LabBooking.asmx" />
            </Services>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory" style="height: 560px;">
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-2">
                        <label class="pull-left">UHID</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="txtpatientid" runat="server" Font-Bold="true" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Patient Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="txtpatienttitle" runat="server" Font-Bold="true" /><asp:Label ID="txtpatientname" runat="server" Font-Bold="true" />
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">Age</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="txtpatientage" runat="server" Font-Bold="true" />
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-2">
                        <label class="pull-left">DOB</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="txtpatientDOB" runat="server" Font-Bold="true" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Gender</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="txtpatientgender" runat="server" Font-Bold="true" />
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Mobile</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="txtmobileno" runat="server" Font-Bold="true" />
                    </div>
                </div>
                <div class="row" style="display: none;">
                    <asp:Label ID="txtageyear" runat="server" Font-Bold="true" />
                    <asp:Label ID="txtagemonth" runat="server" Font-Bold="true" />
                    <asp:Label ID="txtagedays" runat="server" Font-Bold="true" />
                    <asp:Label ID="txttotaldays" runat="server" Font-Bold="true" />
                    <asp:Label ID="txtddob" runat="server" Font-Bold="true" />
                    <asp:Label ID="txtemail" runat="server" Font-Bold="true" />
                    <asp:Label ID="txtLatitude" runat="server" Font-Bold="true" />
                    <asp:Label ID="txtLongitude" runat="server" Font-Bold="true" />
                    <asp:Label ID="txtLatitudehc" runat="server" Font-Bold="true" Text="0" />
                    <asp:Label ID="txtLongitudehc" runat="server" Font-Bold="true" Text="0" />
                </div>
                <div class="row ">
                    <div class="col-md-24 Purchaseheader">
                        <div class="col-md-5">
                            Address&nbsp;&nbsp;<asp:CheckBox ID="chedit" runat="server" Text="Update Address" onclick="setcontrol(this)" />
                        </div>
                        <div class="col-md-10">
                            <asp:CheckBox ID="ch" runat="server" Enabled="False" Font-Bold="true" onclick="setcontrolhc(this)" Text="Home Collection Address Same As Permanent Address" Checked="true" Style="color: #0000FF" />
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lbhomecollectiondatetime" runat="server" Font-Bold="true" ForeColor="Red" />
                        </div>
                    </div>
                </div>
                <div class="row ">
                    <div class="col-md-2">
                        <label class="pull-left">Address</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtpatientaddress" runat="server" Enabled="false" CssClass="requiredField" />
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">State</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlstate" Enabled="false" runat="server" onchange="bindCity()" CssClass="requiredField"></asp:DropDownList>
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">City</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlcity" Enabled="false" runat="server" onchange="bindLocality()" CssClass="requiredField"></asp:DropDownList>
                    </div>
                </div>
                <div class="row ">

                    <div class="col-md-2">
                        <label class="pull-left">Area</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:DropDownList ID="ddlarea" Enabled="false" onchange="bindpincode()" runat="server" CssClass="requiredField"></asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Pincode</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtpincode" Enabled="false" runat="server" MaxLength="6" CssClass="requiredField"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtpincode">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                </div>

                <div class="row ">

                    <div class="col-md-2">
                        <label class="pull-left">Landmark</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtpatientlandmark" runat="server" Enabled="false" />
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">Email ID</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtpatientemailid" runat="server" Enabled="false" />
                    </div>
                    <div class="col-md-5">
                        <input type="button" value="Appointment Not Booked" style="background-color: maroon; color: white; font-weight: bold; cursor: pointer; float: right;" onclick="opennotbookedbox()" />

                    </div>
                </div>


                <div class="row trhomecollection" style="display: none;">
                    <div class="col-md-2">
                        <label class="pull-left">Address</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtpatientaddresshc" runat="server" />
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">State</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlstatehc" onchange="bindCity1()" runat="server"></asp:DropDownList>
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">City</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlcityhc" onchange="bindLocality1()" runat="server"></asp:DropDownList>

                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Area</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlareahc" onchange="bindpincode1()" runat="server"></asp:DropDownList>
                    </div>
                </div>


                <div class="row trhomecollection" style="display: none;">
                    <div class="col-md-2">
                        <label class="pull-left">Pincode</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtpincodehc" runat="server" MaxLength="6"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtpincodehc">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Landmark</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtpatientlandmarkhc" runat="server" />
                    </div>
                </div>
            </div>



            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align: center">
                    <asp:Label ID="lbmsg" runat="server" Font-Bold="true" ForeColor="Red" />
                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left">Appointment Date  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2 ">
                        <asp:TextBox ID="dtFrom" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calAppDate" TargetControlID="dtFrom" Format="dd-MMM-yyyy" PopupButtonID="dtFrom" />
                    </div>
                    <div class="col-md-2 ">
                        <input type="button" value="Search Slot" class="searchbutton" onclick="searchslot('', '', '', '', '1')" />
                    </div>
                    <div class="col-md-4 ">
                        <label class="pull-left ">Drop Location (Centre)  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddldroplocation" runat="server" />
                    </div>
                    <div class="col-md-2 ">
                        <label class="pull-left ">Route  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:Label ID="lbroute" runat="server" Font-Bold="true" />
                    </div>
                    <div class="col-md-4">
                        <asp:Label ID="lbroute1" runat="server" Font-Bold="true" Style="display: none;" />
                        <asp:DropDownList ID="ddlroute" runat="server" onchange="getmyslot()"></asp:DropDownList>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-24 Purchaseheader">
                        <div class="row">
                            <div class="col-md-1" style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #5694dc;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </div>
                            <div class="col-md-6">
                                Selected Patient Pending
                            </div>

                            <div class="col-md-1" style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: darkgray;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </div>
                            <div class="col-md-6">Other Patient Pending</div>

                            <div class="col-md-1" style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </div>
                            <div class="col-md-6">Completed</div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="slotdiv" style="width: 100%; overflow: auto; height: 370px;">
                <table id="slottable" frame="box" rules="all">
                </table>
            </div>
        </div>

        <div id="popup_box1">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />

            <div class="POuter_Box_Inventory" id="appdiv">
                <div class="Purchaseheader" style="text-align: center">
                    Book Slot
                </div>

                <div class="hcrequest" style="width: 99%; background-color: aqua;"></div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left"><b>Phlebotomist Name</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-10">
                        <asp:Label ID="txtPhlebotomistname" runat="server" Font-Bold="true" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left"><b>App Date Time</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:Label ID="txtappdate" runat="server" Font-Bold="true" />&nbsp;<asp:Label ID="txtapptime" runat="server" Font-Bold="true" />
                        <asp:Label ID="txtPhlebotomistid" runat="server" Style="display: none;" />
                        <asp:Label ID="txtoldprebookingid" runat="server" Style="display: none;" />
                        <asp:Label ID="txtendtime" runat="server" Style="display: none;" />
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left"><b>Refered Doctor</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <%-- <div class="ui-widget" style="display: inline-block;">--%>
                        <input id="txtReferDoctor" tabindex="9" value="SELF" class="checkSpecialCharater requiredField" />
                        <input type="hidden" id="hftxtReferDoctor" value="1" />
                        <%-- </div>--%>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtOtherDoctor" placeholder="Doctor Name" runat="server" Style="display: none;"></asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="pull-left"><b>Alternate Mobile No.</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtaltmobileno" runat="server" MaxLength="10" CssClass="requiredField" AutoCompleteType="Disabled"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers" TargetControlID="txtaltmobileno">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left"><b>Source Of Collection</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlsourceofcollection" runat="server" CssClass="requiredField" ClientIDMode="Static">
                            <%--<asp:ListItem Value="">Select</asp:ListItem>
                            <asp:ListItem Value="INBOUND CALL">INBOUND CALL</asp:ListItem>
                            <asp:ListItem Value="PRE BOOKING">PRE BOOKING</asp:ListItem>
                            
                            <asp:ListItem Value="MARKETING">MARKETING</asp:ListItem>
                            <asp:ListItem Value="WHATS APP">WHATS APP</asp:ListItem>
                            <asp:ListItem Value="EMAIL">EMAIL</asp:ListItem>
                            <asp:ListItem Value="LIVE CHAT">LIVE CHAT</asp:ListItem>
                            <asp:ListItem Value="HANG UP CALL">HANG UP CALL</asp:ListItem>
                            <asp:ListItem Value="OUTBOUND CALL">OUTBOUND CALL</asp:ListItem>
                            <asp:ListItem Value="CALL DROP">CALL DROP</asp:ListItem>
                            <asp:ListItem Value="HC CONFIRMATION">HC CONFIRMATION</asp:ListItem>
                            <asp:ListItem Value="CUSTOMER CALL TO PCC">CUSTOMER CALL TO PCC</asp:ListItem>
                            <asp:ListItem Value="ZOHO">ZOHO</asp:ListItem>--%>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left"><b>Remarks</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtremarks" runat="server" MaxLength="200"></asp:TextBox>
                    </div>
                    <div class="col-md-2" style="display:none">
                        <label class="pull-left"><b>Client</b></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" style="display:none">
                        <asp:DropDownList ID="ddlclient" runat="server" CssClass="requiredField">
                            <asp:ListItem Value="">Select Client</asp:ListItem>
                            <asp:ListItem Value="Sugar">Sugar</asp:ListItem>
                            <asp:ListItem Value="Home Care">Home Care</asp:ListItem>
                            <asp:ListItem Value="Other"></asp:ListItem>
                            <asp:ListItem Value="Just Dial">Just Dial</asp:ListItem>
                            <asp:ListItem Value="Ask Apollo">Ask Apollo</asp:ListItem>
                            <asp:ListItem Value="ITC SUGAR">ITC SUGAR </asp:ListItem>
                            <asp:ListItem Value="24*7">24*7</asp:ListItem>
                        </asp:DropDownList>

                         </div>
                     <div class="col-md-3">
                    <label class="pull-left"><b>Payment Mode</b></label>
                    <b class="pull-right">:</b>
                          </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlpaymentmode" runat="server" CssClass="requiredField">
                                            <asp:ListItem Value="">Select Payment Mode</asp:ListItem>
                                            <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                           <asp:ListItem Value="Credit Card">Credit Card</asp:ListItem>
										   <asp:ListItem Value="Debit Card">Debit Card</asp:ListItem>
										   <asp:ListItem Value="Online Payment">Online Payment</asp:ListItem>
										   <asp:ListItem Value="Mobile Wallet">Mobile Wallet</asp:ListItem>
                                            <asp:ListItem Value="Credit" disabled>Credit</asp:ListItem>
                                        </asp:DropDownList>

                         </div>
                    <div class="col-md-3">
                        <label class="pull-left"><b>Address</b></label>
                    <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                         <asp:TextBox ID="txtaddress" runat="server" MaxLength="200"></asp:TextBox>
                    </div>
                 </div>

                  <div class="row">
                     <div class="col-md-2">
                 <input type="checkbox" id="chvip" /><strong> VIP</strong>
                          </div>
                       <div class="col-md-4">
                 <input type="checkbox" id="chkisPediatric" /><strong> Pediatric Patient</strong>
                          </div>
                      
                         <div class="col-md-6">
                             <input type="checkbox" id="chHardCopyRequired" /><strong>Hard copy of report required</strong>
                             </div>
                       <div class="col-md-2">
                           <input type="checkbox" id="chreceipt" checked="checked" style="display: none;" /><%--<strong>Send Receipt on Mobile </strong>--%>

                       </div>
                       <div class="col-md-4">
                           <asp:DropDownList ID="ddlphlebocharge" runat="server"></asp:DropDownList>
                       </div>
                       <div class="col-md-4">
                    <label class="pull-left"><b>Total Amount To Pay</b></label>
                    <b class="pull-right">:</b>
                          </div>
                         <div class="col-md-2">
                             <asp:TextBox ID="txtTotalAmount" runat="server" ClientIDMode="Static" ReadOnly="true" ></asp:TextBox>
                             </div>

                      <div class="col-md-2">
                          <span class="covidch" style="display: none; font-weight: bold;">Covid HC Charge :</span>
                      </div>
                        <div class="col-md-2">
                             <asp:TextBox Style="display: none;" class="covidch" ID="txtcovidcharge" runat="server" ClientIDMode="Static" Width="96"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender3" runat="server" FilterType="Numbers" TargetControlID="txtcovidcharge">
                                        </cc1:FilteredTextBoxExtender>
                        </div>
                      </div>

                </div>
             <div class="POuter_Box_Inventory">
                 <div class="row" style="margin-top: 0px;">
                     <div style="padding-right: 0px;" class="col-md-8">
							<label class="pull-left">                       
                                 <input id="rblSearchType_1" onclick="clearItem()" value="1" name="rblSearchType" checked="checked" type="radio" />
                                                    <b>By Test Name</b><input id="rblSearchType_0" onclick="clearItem()" value="0" name="rblSearchType" type="radio" />
                                                    <b>By Test Code</b><input id="rblSearchType_2" onclick="clearItem()" value="2" name="rblSearchType" type="radio" />
                                                    <b>InBetween</b>
                                </label>

                            </div>	
                     <div class="col-md-2">
                      <button style="width: 100%; padding: 0px;" class="label label-important" type="button"><b>Count :</b><span id="testcount" style="font-size: 14px; font-weight: bold;" class="badge badge-grey">0</span></button>
                           </div>
                         <div class="col-md-4">
                          <span style="font-weight: bold; color: red; font-size: 11px;">Home Collection Charge :&nbsp;</span><span id="spdeliverycharge" style="font-weight: bold; color: red; font-size: 11px;">0</span>
                 </div>
                      <div class="col-md-10">
                          <div class="row" id="divDiscountBy">
                  <div class="col-md-7">
				   <label class="pull-left">Discount Amt.</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
				<asp:TextBox ID="txtDiscountAmt" runat="server"  placeholder="Disc Amt" ClientIDMode="Static"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbDiscountAmt" runat="server" FilterType="Numbers" TargetControlID="txtDiscountAmt" Enabled="True"></cc1:FilteredTextBoxExtender>
				
                </div>
				 <div class="col-md-7">
                      <label id="lblPaymentType" class="pull-left">Discount in %</label>
								<b class="pull-right">:</b>				   
				</div>
				<div class="col-md-5">
                     <asp:TextBox ID="txtDiscountPer" runat="server" placeholder="Disc Per" ClientIDMode="Static"></asp:TextBox>
                                                        <cc1:FilteredTextBoxExtender ID="ftbDiscountPer" runat="server" FilterType="Numbers" TargetControlID="txtDiscountPer" Enabled="True"></cc1:FilteredTextBoxExtender>				
				</div>

                               <div class="col-md-7">
                      <label id="Label1" class="pull-left">Coupon Amount</label>
								<b class="pull-right">:</b>				   
				</div>
				<div class="col-md-5">
                     <asp:TextBox ID="txtCouponAmt" Value="0" runat="server" placeholder="Disc Per" ClientIDMode="Static"></asp:TextBox>
                                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Numbers" TargetControlID="txtDiscountPer" Enabled="True"></cc1:FilteredTextBoxExtender>				
				</div>
			</div>
                          </div>

                     <%--Coupon start--%>
                     <div class="col-md-10">


                          <div class="row">
                       <div class="col-md-5">
                         <label class="pull-left">  Coupon Code </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-5">
                                                    <asp:TextBox ID="txtCouponNo" runat="server" /> 
                                                    <span id="spnCouponID" style="display:none;"  class="CouponSpan" />
                                                    </div>
                                                  <div class="col-md-3">
                                                      <input type="button" id="btnCouponOTP"  value="Get OTP" style="font-weight:bold;cursor:pointer;display:none;" onclick="$getCouponOTP()" />
                                                     <input type="button" id="btnCouponOTPResend" value="Resend OTP" style="font-weight:bold;cursor:pointer;display:none" onclick="$resendCouponOTP()" />
                                                      </div>
                                                <div class="col-md-5">
                                                    <asp:TextBox ID="txtCouponOTP" runat="server" placeholder="Enter OTP" Visible="false" ></asp:TextBox>
                                                    <asp:TextBox ID="txtUniqueID" runat="server" style="display:none;" />
                                                    </div>
                                                 <div class="col-md-3">
                                                     <input type="button" id="btnValidate" value="Validate" style="font-weight:bold;cursor:pointer;" onclick="$validateCoupon()" />
                                                 </div>
                                                <div class="col-md-3">
                                                    <input type="button" value="Cancel" style="font-weight:bold;cursor:pointer;" onclick="$cancelCoupon()" />
                                                    <span id="spncouponCode" style="display:none;" class="couponspan" />
                                                    </div>
                                                </div>

                                            <div class="row clDivCoupon" style="display:none;">
                       <div class="col-md-3">
                         <label class="pull-left">  Coupon Name </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-5">
                                                     <span id="spnCouponName" class="couponspan"></span>
                                                    </div>
                                                <div class="col-md-3">
                         <label class="pull-left">  Type </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-5">
                                                    <span id="spnCouponType" class="couponspan"></span>
                                                </div>
                                                <div class="row clDivCoupon" style="display:none;">
                       <div class="col-md-3">
                         <label class="pull-left">  Category </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-5">
                                                    <span id="spnCouponCategory" class="couponspan"></span>
</div>
                                                     <div class="col-md-3">
                         <label class="pull-left">  Valid Date </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-5">
                                                    <span id="spnCouponExpiry" class="couponspan" ></span>
</div>
                                                    </div>
                                                </div>
                                                  <div class="row clDivCoupon" style="display:none;">
                       <div class="col-md-3">
                         <label class="pull-left">  Min Bill Amt </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-5">
                                                    <span id="spnCouponMinBookingAmount" style="font-weight:bold;" class="couponspan"></span>
                                                    </div>
                                                      <div class="col-md-3">
                         <label class="pull-left">  Applicable Type </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-5">
                                                    <span id="spnCouponIssueType" style="font-weight:bold;" class="couponspan"></span>
                                                    </div>
                                                      </div>
                                                <div class="row clDivCoupon" style="display:none;">
                       <div class="col-md-3">
                         <label class="pull-left">  Disc Apply For </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-5">
                                                    <span id="spnCouponDiscFor" style="font-weight:bold;" class="couponspan"></span>
                                                    </div>
                                                     <div class="col-md-3">
                         <label class="pull-left">  Disc(%) </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-2">
                                                    <span id="spnCouponDisc" style="font-weight:bold;" class="couponspan"></span>
                                                    </div>
                                                    <div class="col-md-3">
                         <label class="pull-left">  Disc(Amt) </label>
								<b class="pull-right">:</b>
                           </div>
                                                <div class="col-md-2">
                                                     <span id="spnCouponDiscAmt" style="font-weight:bold;" class="couponspan"></span>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <input type="button" style="cursor:pointer;" onclick="viewitemlist()" id="imgviewtest" value="View Item" />
                                                        </div>
                                                    </div>
                                            <div class="row">
                                            <div style="width:100%;max-height:100px;overflow:auto">                                         
                                            <table  id="tblCouponDetail" style="display:none;width: 100%; border-collapse: collapse">
                                                <tr id="trCoupon">
                                                    <td class="GridViewHeaderStyle">Coupon Code</td>
                                                    <td class="GridViewHeaderStyle">Coupon Name</td>
                                                    <td class="GridViewHeaderStyle">Type</td>
                                                    <td class="GridViewHeaderStyle">Category</td>
                                                    <td class="GridViewHeaderStyle">Valid Date</td>
                                                    <td class="GridViewHeaderStyle">Min Bill</td>
                                                    <td class="GridViewHeaderStyle">Disc. On</td>
                                                    <td class="GridViewHeaderStyle">Disc. %</td>
                                                    <td class="GridViewHeaderStyle">Disc. Amt.</td>
                                                    <td class="GridViewHeaderStyle">Used Amt.</td>
                                                    <td class="GridViewHeaderStyle">Item</td>
                                                </tr>
                                            </table>
                                                 </div>
                                                </div>


                     </div>


                     <%--coupan end--%>


</div>	
                  <div class="row" style="margin-top: 0px;">
                     <div style="padding-right: 0px;" class="col-md-8">
                          <input type="hidden" id="theHidden" />
                                                        <input id="ddlInvestigation" size="40" tabindex="19" />
                         </div>
                      <div class="col-md-6">                         
                               <b>Total Amt.: </b><span id="amtcount" style="font-weight: bold;">0</span>
                              <b>Disc.: </b> <asp:Label ID="lbdisamt" runat="server" Style="font-weight: 700" ClientIDMode="Static" ForeColor="Red" />
                          <span id="spnTotalDiscountAmount" style="display:none"></span>
                          </div>
                       <div class="col-md-10">
                           <div class="row" id="divDiscountReason">
                  <div class="col-md-7">
				  <label class="pull-left">Discount By</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-17">
                    <asp:DropDownList ID="ddlDiscAppby" runat="server"  onchange="resetitemreadonly()" ClientIDMode="Static"></asp:DropDownList>
                				</div>				 			
			</div>    
                       </div>             
                </div>                    
                   <div class="row" style="margin-top: 0px;">
                      <div class="col-md-14">
					<div style=" height: 125px; overflow-y: auto; overflow-x: hidden;">
                        <div class="TestDetail" style="margin-top: 5px; max-height: 105px; overflow: auto; width: 100%;">
                                                        <table id="tb_ItemList" style="width: 99%; border-collapse: collapse">
                                                            <tr id="theader">
                                                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                                                <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Code</td>
                                                                <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Item</td>
                                                                <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">View</td>
                                                                <td class="GridViewHeaderStyle" style="width: 20px; text-align: center">DOS</td>
                                                                <td class="GridViewHeaderStyle" style="width: 40px; text-align: center">MRP</td>
                                                                <td class="GridViewHeaderStyle" style="width: 40px; text-align: center">Rate</td>
                                                                <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Disc.</td>
                                                                <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Amt.</td>
                                                                <th class="GridViewHeaderStyle" style="width: 50px; text-align: center">IsUrgent</th>
                                                                <td style="display: none;"></td>
                                                            </tr>
                                                        </table>
                                                    </div>

                        </div>
                          </div>
                        <div class="col-md-10">
                            <div class="col-md-7">
				   <label class="pull-left">Discount Reason</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-17">
					<asp:TextBox ID="txtDiscReason" runat="server"  placeholder="Discount Reason" ClientIDMode="Static" />
				</div>	
                            </div>
                        </div>
                 <div class="row" style="text-align:center">
                     <input type="button" value="Book Slot" onclick="BookSlot()" class="savebutton" id="btnSave" />
                     <input type="button" value="Update Appointment" onclick="UpdateSlot()" class="savebutton" id="btnupdate" style="display: none;" />
                 </div>               
            </div>
            <div class="POuter_Box_Inventory" style=" display: none;" id="appdiv1">
                <div class="Purchaseheader">
                     <div class="row">
                         <div class="col-md-5">
                             Appointment List
                         </div>
                         <div class="col-md-1" style="width: 15px;height:15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #5694dc;">

                         </div>
                         <div class="col-md-4">
                             Selected Patient Pending
                             </div>
                         <div class="col-md-1" style="width: 15px;height:15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: darkgray;">

                             </div>
                         <div class="col-md-4">Other Patient Pending</div>

                         <div class="col-md-1" style="width: 15px;height:15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">

                         </div>
                         <div class="col-md-2">Completed</div>
                         <div class="col-md-1" style="width: 15px;height:15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;"></div>
                         <div class="col-md-2">Cancel</div>
                     </div>
                    
                </div>
                <div class="row">
                <div style="max-height: 100px; overflow: auto;">
                    <table id="tblolddata" style="width: 99%; border-collapse: collapse; text-align: left;">
                    </table>
                     </div>
                </div>
            </div>
            <div class="lastthreevisit">
                <div class="mylast3visit">
                    <img src="../../App_Images/Close.png" style="cursor: pointer; width: 25px; right: -15px; position: absolute; top: -19px;" onclick="hidelast3visit();" />
                    <table id="tbllastthreevisit" style="border-collapse: collapse; text-align: left;">
                        
                    </table>
                </div>
                <span class="btnopenlast3" onclick="openlastvisit()" title="Click To View">Last 3 Appointment's of  <span id="pname" style="color: cyan;"></span></span>
            </div>
            <div class="containeritemsuggestion">
                <div class="feedbacksuggestion" style="text-align: center">
                    <table style="width: 99%; border-collapse: collapse;">
                        <tr>
                            <td style="text-align: center; width: 90%; font-weight: bold; color: blue; font-size: 20px; font-family: Cambria;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Promotional Test           
                            </td>
                            <td style="text-align: right; width: 9%;">
                                <img src="../../App_Images/Close.png" style="cursor: pointer; width: 25px; float: right;" onclick="hideSuggestionItemTest();" /></td>
                        </tr>
                    </table>
                    <div style="overflow: auto; height: 180px; background-color: papayawhip;">
                        <table id="tblitemSuggection" style="width: 99%; border-collapse: collapse; font-size: 11px;">
                            <tr>
                                <td class="GridViewHeaderStyle" style="text-align: left; width: 5px; font-size: 11px;">S.No.</td>
                                <td class="GridViewHeaderStyle" style="text-align: left; width: 45px; font-size: 11px;">Selected Test Name</td>
                                <td class="GridViewHeaderStyle" style="text-align: left; width: 10px; font-size: 11px;">Selected Test Code</td>
                                <td class="GridViewHeaderStyle" style="text-align: left; width: 45px; font-size: 11px;">Promotional Test Name</td>
                                <td class="GridViewHeaderStyle" style="text-align: left; width: 10px; font-size: 11px;">Promotional Test Code</td>
                                <td class="GridViewHeaderStyle" style="text-align: left; width: 10px; font-size: 11px;">Rate</td>
                            </tr>
                        </table>
                    </div>

                </div>
                <a href="#" class="button-slidesuggest" onclick="showSuggestionItemTest()">Promotional Test</a>
            </div>
            <div class="container">
                <div class="feedback" style="text-align: center">
                    <table style="width: 99%; border-collapse: collapse;">
                        <tr>
                            <td style="text-align: center; width: 90%; font-weight: bold; color: blue; font-size: 20px; font-family: Cambria;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Suggested Test             
                            </td>
                            <td style="text-align: right; width: 9%;">
                                <img src="../../App_Images/Close.png" style="cursor: pointer; width: 25px; float: right;" onclick="hideSuggestionTest();" /></td>
                        </tr>
                    </table>
                    <div style="overflow: auto; height: 180px; background-color: papayawhip;">
                        <table id="tblSuggection" style="width: 99%; border-collapse: collapse;">
                            <tr>
                                <td class="GridViewHeaderStyle" style="text-align: center; width: 5px;">S.No.</td>
                                <td class="GridViewHeaderStyle" style="text-align: center; width: 40px;">Date</td>
                                <td class="GridViewHeaderStyle" style="text-align: center; width: 45px;">Test Name</td>
                                <td class="GridViewHeaderStyle" style="text-align: center; width: 10px;">Status</td>
                            </tr>
                        </table>
                    </div>

                </div>
                <a href="#" class="button-slide" onclick="showSuggestionTest()">Suggested Test</a>
            </div>
            <div class="conPackageDetail">
                <div class="divPackageRecommended" style="text-align: center">
                    <table style="width: 99%; border-collapse: collapse;">
                        <tr>
                            <td style="text-align: center; width: 90%; font-weight: bold; color: blue; font-size: 20px; font-family: Cambria;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recommended Package             
                            </td>
                            <td style="text-align: right; width: 9%;">
                                <img src="../../App_Images/Close.png" style="cursor: pointer; width: 25px; float: right;" onclick="hideRecommendedPackage();" /></td>
                        </tr>
                    </table>
                    <div style="overflow: scroll; height: 230px; background-color: papayawhip;">
                        <table id="tblPackageSuggestion" style="width: 99%; border-collapse: collapse; font-size: 11px;" border="1">
                            <tr>
                                <th style="text-align: left; width: 5px; font-size: 11px;">S.No.</th>
                                <th style="text-align: left; width: 5px; font-size: 11px;">Suggested Package</th>
                                <th style="text-align: left; width: 5px; font-size: 11px;">Rate</th>
                            </tr>
                        </table>
                    </div>
                </div>
                <a href="#" class="button-slidepackageRecommended" onclick="showRecommendedPackage()">Recommended Package</a>
            </div>
        </div>
        <div id="popup_box2">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox1()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />

            <div class="POuter_Box_Inventory" style="width: 600px;" id="Div1">
                <div class="Purchaseheader">
                    Reschedule Appointment
                </div>
                  <div class="row">
                       <div class="col-md-8">
                        <label class="pull-left">Prebooking ID   </label>
                        <b class="pull-right">:</b>
                    </div>
                      <div class="col-md-14">
                           <asp:Label ID="lbhcidre" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
                      </div>
                  </div>
                 <div class="row">
                       <div class="col-md-8">
                        <label class="pull-left">Appointment Date Time   </label>
                        <b class="pull-right">:</b>
                    </div>
                      <div class="col-md-14">
                          <asp:Label ID="lbappdatere" runat="server" Font-Bold="true" ForeColor="Maroon"></asp:Label>
</div>
                  </div>
                <div class="row">
                       <div class="col-md-6">
                        <label class="pull-left">Phlebotomist Name   </label>
                        <b class="pull-right">:</b>
                    </div>
                      <div class="col-md-18">
                          <asp:DropDownList ID="ddlphlebonew" runat="server"  onchange="getslot()"></asp:DropDownList>
                            <asp:Label ID="lbphlebore" runat="server" Font-Bold="true" ForeColor="Maroon" Style="display: none;"></asp:Label>
                            <asp:Label ID="lbphleboreid" runat="server" Font-Bold="true" ForeColor="Maroon" Style="display: none;"></asp:Label>
</div>
                  </div>

                <div class="row">
                       <div class="col-md-6">
                        <label class="pull-left">New Appointment Date Time   </label>
                        <b class="pull-right">:</b>
                    </div>
                      <div class="col-md-8">
                          <asp:TextBox ID="txtappdatere" runat="server" ReadOnly="true"  onchange="getslot()"></asp:TextBox> 
                         <cc1:CalendarExtender runat="server" ID="CalendarExtender1" TargetControlID="txtappdatere" Format="dd-MMM-yyyy" PopupButtonID="txtappdatere" /> </div>
                          <div class="col-md-8">  <asp:DropDownList ID="ddlapptimere" runat="server" ></asp:DropDownList>
                               </div>
</div>
                  </div>
            <div class="row" style="text-align:center">
                 <input type="button" value="Reschedule" class="savebutton" onclick="RescheduleNow()" />
                </div>
               
            
        </div>
        <div id="popup_box3">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox3()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />
            <div id="showpopupmsg" style="height: 290px; overflow: auto;"></div>
        </div>

        <div id="popup_box4">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox4()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />
            <div class="Purchaseheader">
                Cancel Appointment
            </div>
            <div class="row">
                 <div class="col-md-4">
                        <label class="pull-left">PreBookingID   </label>
                        <b class="pull-right">:</b>
                    </div>
                <div class="col-md-10">
                    <input type="text" id="txtcancelpre" readonly="true" style="font-weight: bold; border: 0px; color: maroon; background-color: #d7edff;" />
                </div>
            </div>
             <div class="row">
                 <div class="col-md-4">
                        <label class="pull-left">AppointmentDate   </label>
                        <b class="pull-right">:</b>
                    </div>
                <div class="col-md-10">
                    <input type="text" id="txtcancelpre2" readonly="true" style="font-weight: bold; border: 0px; color: maroon; background-color: #d7edff;" />
                     </div>

                  </div>
                     <div class="row">
                 <div class="col-md-4">
                        <label class="pull-left">Cancel Reason   </label>
                        <b class="pull-right">:</b>
                    </div>
                <div class="col-md-20">
                    <input type="text"  maxlength="200" id="txtcancelreason" />
                    </div>

                  </div>
           
           <div class="row" style="text-align:center">
                <input type="button" value="Cancel" class="resetbutton" onclick="cancelappnow()" />
               <input type="text" id="txtcancelpre1"  readonly="true" style="display:none;" />
           </div>
        </div>
        <div id="popup_box5">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox5()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />
            <div class="Purchaseheader">
                Phlebotomist Profile
            </div>
             
            <div style="width: 100%">
                  <div class="row">
                       <img id="phimg" style="width: 100px; height: 100px" alt="" />
                  </div>

                 <div class="row">
                  <div class="col-md-4">
                        <label class="pull-left">Name   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phname"></span>
                     </div>
                      <div class="col-md-4">
                        <label class="pull-left">Joining Date   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phjndate"></span>
                         </div>
                    </div>

                <div class="row">
                  <div class="col-md-4">
                        <label class="pull-left">Gender   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phgender"></span>
</div>
                    <div class="col-md-4">
                        <label class="pull-left">DOB   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phdob"></span>
</div>
                    </div>

                 <div class="row">
                  <div class="col-md-4">
                        <label class="pull-left">Mobile   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phmobile"></span>
</div>
 <div class="col-md-4">
                        <label class="pull-left">Email   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phemail"></span>
</div>
                     </div>

                  <div class="row">
                  <div class="col-md-4">
                        <label class="pull-left">Address   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-20">
                         <span id="phaddress"></span>
                         </div>
                      </div>

                 <div class="row">
                  <div class="col-md-4">
                        <label class="pull-left">Blood Group   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phbg"></span>
  </div>
                     <div class="col-md-4">
                        <label class="pull-left">Qualification   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phqualification"></span>
  </div>
</div>


                          <div class="row">
                  <div class="col-md-4">
                        <label class="pull-left">Vehicle Number   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phvn"></span>
                         </div>
                     <div class="col-md-4">
                        <label class="pull-left">Driving Licence   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phdl"></span>
  </div>
 </div>

                          <div class="row">
                  <div class="col-md-4">
                        <label class="pull-left">PAN No.   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="phpan"></span>
                         </div>
                     <div class="col-md-4">
                        <label class="pull-left">WorkCity   </label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-8">
                         <span id="pncity"></span>
  </div>
                               </div>
               
            </div>
        </div>
        <div id="popup_box6">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox6()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />

            <div class="POuter_Box_Inventory" style="width: 1100px; background-color: papayawhip">
                <div class="Purchaseheader" style="text-align: center;">
                    Home Collection Address
                </div>
                <div class="row" style="text-align: center;">
                    <div style="overflow: scroll; height: 220px; background-color: papayawhip;">
                        <table id="oldPatientTable" width="99%" cellpadding="0" rules="all" border="1" frame="box">
                            <tr id="myHeader" style="text-align: left;">
                                <td class="GridViewHeaderStyle">Select</td>
                                <td class="GridViewHeaderStyle">Address</td>
                                <td class="GridViewHeaderStyle">Area</td>
                                <td class="GridViewHeaderStyle">City</td>
                                <td class="GridViewHeaderStyle">State</td>
                                <td class="GridViewHeaderStyle">Pincode</td>
                                <td class="GridViewHeaderStyle">Landmark</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="popup_box7">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox7()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" />

            <div class="POuter_Box_Inventory" style="width: 606px;">
                <div class="Purchaseheader" style="text-align: center;">
                    Home Collection Not Booked Reason
                </div>
                 <div class="row">
                     <div class="col-md-4 ">
                        <label class="pull-left">Remarks   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-20 ">
                         <asp:TextBox ID="txtnotbookedremarks" runat="server"  MaxLength="200" CssClass="required"></asp:TextBox>
                    </div>
                     </div>
                <div class="row">
                     <div class="col-md-24 " style="text-align:center">
                         <input type="button" value="Save Reason" onclick="savenotbookedreason()" class="savebutton" />
                     </div>
                </div>               
            </div>
        </div>


            <div id="divCouponItemDetail" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 70%;max-width:72%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Coupon Item Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeCouponItemDetail()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
             <table id="tblCouponTest" style="width: 100%; border-collapse: collapse;text-align: center;height:87px;">
                    <tr>
                        <td class="GridViewHeaderStyle" align="left">Test</td>
                        <td class="GridViewHeaderStyle">Disc%</td>
                        <td class="GridViewHeaderStyle">Disc Amt</td>
                         <td class="GridViewHeaderStyle">Applied Disc Amt</td>
                    </tr>
                </table>
             </div>
            <div class="modal-footer">				
				<button type="button"  onclick="$closeCouponItemDetail()">Close</button>
			</div>
        </div>
      </div>
         </div>


    </form>

    <script type="text/javascript">
        $(function () {
            $("#masterheaderid,#mastertopcorner,#btncross,#btnfeedback,#rdoIndentType,#divMasterNav").hide();
            $("#Pbody_box_inventory").css('margin-top', '10px');
        });
        $(function () {
            getAgeset($('#<%=txtpatientDOB.ClientID%>').text(), new Date());
            bindcollsource();
        });
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
            $('#<%=txtageyear.ClientID%>').text(years);
            $('#<%=txtagemonth.ClientID%>').text(months);
            $('#<%=txtagedays.ClientID%>').text(days);
            $('#<%=txtpatientage.ClientID%>').text(age);

            var ageindays = parseInt(years) * 365 + parseInt(months) * 30 + parseInt(days);
            $('#<%=txttotaldays.ClientID%>').text(ageindays);
        }             
    </script>
    <script type="text/javascript">
        function openmypopup(ctrl1, address, phelbo, time, phelboname, endtime) {
            if ($('#<%=ch.ClientID%>').is(':checked') && $('#<%=txtpatientaddress.ClientID%>').val() == "") {
                toast("Error","Please Enter Proper Address");
                return;
            }
            if ($('#<%=ch.ClientID%>').is(':checked') == false && $('#<%=txtpatientaddresshc.ClientID%>').val() == "") {
                toast("Error", "Please Enter Proper Address");
                return;
            }
            var now = new Date(Date.now());
            var appdatenow = new Date($('#dtFrom').val() + " " + time)
            var future = false;
            if (Date.parse(now) < Date.parse(appdatenow)) {
                future = true;
            }
            if (future == false) {
                toast("Error", "You can't Book Appoinment for this time");
                $('#appdiv').hide();
            }
            else {
                $('#appdiv').show();
            }
            if (mypreidnew != "") {
                editmyapp(mypreidnew);
            }
            $('#txtaltmobileno,#txtDiscountAmt,#txtDiscountPer,#txtDiscReason,#txtremarks').val('');
            $('#ddlsourceofcollection,#ddlclient,#ddlDiscAppby').prop('selectedIndex', 0);
            $('#chvip,#chHardCopyRequired').prop('checked', false);
            $('#<%=txtappdate.ClientID%>').text($('#<%=dtFrom.ClientID%>').val());
            $('#txtaddress').val(address);
            $('#<%=txtapptime.ClientID%>').text(time);
            $('#<%=txtPhlebotomistname.ClientID%>').text(phelboname);
            $('#<%=txtPhlebotomistid.ClientID%>').text(phelbo);
            $('#<%=txtendtime.ClientID%>').text(endtime);
            resetitem();
            openme();
            bindphcharge(phelbo, $('#<%=dtFrom.ClientID%>').val());
            $('#ddlInvestigation').focus();
            bindoldappdata(phelbo, $('#<%=dtFrom.ClientID%>').val() + " " + time);
            bindlastthreevisit();
            showsuggestivetest();         
            bindapptype();                       
        }
        function bindphcharge(phid, appdate) {
            $("#<%=ddlphlebocharge.ClientID%> option").remove();
            serverCall('HomeCollection.aspx/getphelbotomistcharge', { phid: phid, appdate: appdate }, function (result) {
                centreData = $.parseJSON(result);
                for (i = 0; i < centreData.length; i++) {
                    jQuery("#<%=ddlphlebocharge.ClientID%>").append(jQuery("<option></option>").val(centreData[i].chargeamount).html(centreData[i].chargename));
                }
            });
        }
        function openme() {
            $('#popup_box1').fadeIn("slow");
            
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
            bindhcrequestdata();
            // $("#Pbody_box_inventory :input").attr("disabled", true);
        }
        function unloadPopupBox() {
            $('#popup_box1').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
            var freeslot = $('#<%=txtappdate.ClientID%>').text() + " " + $('#<%=txtapptime.ClientID%>').text();
            var phelboid = $('#<%=txtPhlebotomistid.ClientID%>').text();
            //  $("#Pbody_box_inventory :input").attr("disabled", false);
            searchslot('', '', freeslot, phelboid, '1');       
            showHideDiscType();
            $('#txtReferDoctor').val('SELF');
            $('#hftxtReferDoctor').val('1');
            $('#<%=txtremarks.ClientID%>').val('');
            $('#<%=txtOtherDoctor.ClientID%>').val('').hide();
            $('.containeritemsuggestion').hide();
            $('#tblitemSuggection tr').slice(1).remove();
            $('.lastthreevisit,.mylast3visit,.conPackageDetail,#btnupdate').hide();
            $('#btnSave,#discountdiv').show();
            $('#ddlInvestigation').prop('readonly', false);
            $('.deletemydata').show();
            if (mypreid != "") {
                parent.jQuery.fancybox.close();
            }
        }
    </script>
    <script type="text/javascript">
        function setcontrolhc(ctrl) {
            if ($(ctrl).is(':checked')) {
                $('.trhomecollection').hide();
                jQuery('#<%=ddlstatehc.ClientID%>').prop('selectedIndex', 0)
                jQuery('#<%=ddlcityhc.ClientID%> option').remove();
                jQuery('#<%=ddlareahc.ClientID%> option').remove();
                jQuery('#<%=txtpincodehc.ClientID%>,#<%=txtpatientaddresshc.ClientID%>,#<%=txtpatientlandmarkhc.ClientID%>').val('');
            }
            else {
                $('.trhomecollection').show();
                jQuery('#<%=ddlstatehc.ClientID%>').prop('selectedIndex', 0);
                jQuery('#<%=txtpincodehc.ClientID%>,#<%=txtpatientaddresshc.ClientID%>').val('');
                getoldhomecollectionaddress();
            }
        }
        function setcontrol(ctrl) {
            if ($(ctrl).is(':checked')) {
                jQuery('#<%=ddlstate.ClientID%>').prop('disabled', false);
                jQuery('#<%=ddlcity.ClientID%>').prop('disabled', false);
                jQuery('#<%=ddlarea.ClientID%>').prop('disabled', false);
                jQuery('#<%=txtpincode.ClientID%>').prop('disabled', false);
                jQuery('#<%=txtpatientaddress.ClientID%>').prop('disabled', false);
                jQuery('#<%=txtpatientlandmark.ClientID%>').prop('disabled', false);
                jQuery('#<%=txtpatientemailid.ClientID%>').prop('disabled', false);
            }
            else {
                jQuery('#<%=ddlstate.ClientID%>').prop('disabled', true);
                jQuery('#<%=ddlcity.ClientID%>').prop('disabled', true);

                jQuery('#<%=ddlarea.ClientID%>').prop('disabled', true);
                jQuery('#<%=txtpincode.ClientID%>').prop('disabled', true);
                jQuery('#<%=txtpatientaddress.ClientID%>').prop('disabled', true);
                jQuery('#<%=txtpatientlandmark.ClientID%>').prop('disabled', true);
                jQuery('#<%=txtpatientemailid.ClientID%>').prop('disabled', true);
            }
        }
    </script>
    <script type="text/javascript">
        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {
            return split(term).pop();
        }
        function extractLast1(term) {
            rblSearchType = $('input:radio[name=rblSearchType]:checked').val();
            var length = $('#<%=ddldroplocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error","Select Rate Drop Location");
                $('#<%=ddldroplocation.ClientID%>').focus();
            }
            return split(term).pop();
        }
        function iseven(val) {
            if ($('#rblSearchType_0').is(':checked')) {
                return true;
            }
            else if (val % 2 === 0 || val == 3) { return true; }
            else { return false; }
        }
        function clearItem() {
            $("#ddlInvestigation").val('');
        }
        $(function () {
            var discountType = "";        
            $("#ddlInvestigation")
              .bind("keydown", function (event) {
                  if (event.keyCode === $.ui.keyCode.TAB &&
                      $(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
                  discountType = '';
              })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      $.getJSON("../Common/CommonJsonData.aspx?cmd=GetTestList", {
                          ReferenceCodeOPD: $("#<%=ddldroplocation.ClientID%>").val().split('#')[2],
                          SearchType: $('input:radio[name=rblSearchType]:checked').val(),
                          CentreCode: $('#<%=ddldroplocation.ClientID%>').val().split('#')[0],
                          Gender: $("#txtpatientgender").text(),
                          DOB: $('#txtpatientDOB').text(),
                          Panel_Id: $("#<%=ddldroplocation.ClientID%>").val().split('#')[1],
                          PanelType: $("#<%=ddldroplocation.ClientID%>").val().split('#')[3],
                          DiscountTypeID: discountType,
                          TestName: extractLast1(request.term),                       
                          MemberShipCardNo: '',
                          ReferenceCodeOPD1: '78',
                          ReferenceCodeOPD2: '78',
                          DeptID: '',
                          DoctorID: '0',
                          CentreID: $('#<%=ddldroplocation.ClientID%>').val().split('#')[0]

                      }, response);
                  },
                  search: function () {
                      // custom minLength                    
                      var term = extractLast1(this.value);
                      //if (iseven(term.length) == false) {
                      //    return false;
                      //}
                  },
                  focus: function () {
                      return false;
                  },
                  select: function (event, ui) {
                      this.value = '';
                      var mydisc = ui.item.DiscPer;
                      serverCall('HomeCollection.aspx/CheckHomeCollectionAllowed',
                { itemid: ui.item.value },
                 function (result) {
                     if (result == "0") {
                         toast("Error", ui.item.label + " is not available for Home Collection");
                     }
                     else {
                         AddItem(ui.item.value, ui.item.type, ui.item.Rate, mydisc);
                         bindsuggestionitemwise(ui.item.value);

                     }
                 });                   
                      return false;
                  },
              });
        });
          var testcount = 0;
          var totalamt = 0;
          var InvList = [];
          var itemwisedic = 0;
          function AddItem(itemid, type, Rate, DiscPer) {
              if (itemid == '') {
                  toast("Error","Please select investigation...");
                  return false;
              }
              var addedtest = "";            
              $('#tb_ItemList tr').each(function () {
                  var id = $(this).closest("tr").attr("id");
                  if (id != "header") {
                      addedtest += $(this).closest("tr").attr("id") + "_" + $(this).closest("tr").find("#tdispackage").text() + ",";
                  }
              });
              serverCall('../Lab/Services/LabBooking.asmx/GetitemRate', { ItemID: itemid, type: type, Rate: Rate.split('#')[0], addedtest: addedtest, centreID: $('#<%=ddldroplocation.ClientID%>').val().split('#')[0], DiscPer: DiscPer, DeliveryDate: "", MRP: 0, IsCopayment: 0, panelid: $('#<%=ddldroplocation.ClientID%>').val().split('#')[1], MembershipCardNo: '', IsSelfPatient: 0, UHIDNo: '', ReferenceCodeOPD: '78', LMPWeek: '0', Gender: 'Male' }, function (result) {
              
                  TestData = $.parseJSON(result);
                  if (TestData.length == 0) {
                      alert('No Record Found..!');
                      return;
                  }
                  else {
                      var inv = TestData[0].Investigation_Id;
                      for (var i = 0; i < (inv.split(',').length) ; i++) {
                          if ($.inArray(inv.split(',')[i], InvList) != -1) {
                              toast("Error", "item Already in List..!");
                              return;
                          }
                      }
                      for (var i = 0; i < (inv.split(',').length) ; i++) {
                          InvList.push(inv.split(',')[i]);
                      }

                      if (TestData[0].subcategoryid == "18") {
                          toast("Error", "Family Package Not Allowed..!");
                          return;
                      }
                      testcount = parseInt(testcount) + 1;
                      $('#testcount').html(testcount);
                      var $mydata = [];

                      $mydata.push("<tr id='" + TestData[0].ItemID + "' class='GridViewItemStyle' style='background-color:lemonchiffon'>");
                      $mydata.push('<td class="inv" id='); $mydata.push(TestData[0].Investigation_Id); $mydata.push('><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif" class="deletemydata"/></a></td>');
                      $mydata.push('<td id="tdTestCode" style="font-weight:bold;">'); $mydata.push(TestData[0].testCode); $mydata.push('</td>');
                      $mydata.push('<td id="tditemname" style="font-weight:bold;">'); $mydata.push(TestData[0].typeName); $mydata.push('</td>');

                      $mydata.push('<td style="text-align:center;">');
                      if (TestData[0].SampleRemarks != "") {
                          $mydata.push('<a href="javascript:void(0);" onclick="viewremarks(\''); $mydata.push(TestData[0].SampleRemarks); $mydata.push('\',\''); $mydata.push(type); $mydata.push('\');"><img src="../../App_Images/view.gif"/></a>');
                      }
                      $mydata.push("</td>");
                      $mydata.push('<td style="text-align:center;"><a  href="javascript:void(0);"  onclick="$viewDOS(\''); $mydata.push(TestData[0].Investigation_Id); $mydata.push('\',\''); $mydata.push($('#<%=ddldroplocation.ClientID%>').val().split('#')[0] ); $mydata.push('\',\'' ); $mydata.push(type); $mydata.push('\');"><img src="../../App_Images/view.gif"/></a></td>');
                      $mydata.push('<td id="tdMRP" class="paymenttd" style="text-align:right">'); $mydata.push(TestData[0].MRP); $mydata.push('</td>');
                      $mydata.push('<td id="tdrate" class="paymenttd" style="text-align:right">'); $mydata.push(TestData[0].Rate); $mydata.push('</td>');
                      $mydata.push('<td id="tddisc" class="paymenttd">');                     
                      $mydata.push('<input id="txttddisc" type="text" class="ItDoseTextinputNum"  style="width:50px;" value="'); $mydata.push(TestData[0].DiscAmt); $mydata.push('" onkeyup="setitemwisediscount(this);" readonly="readonly"/>');
                     
                      $mydata.push('</td>');                     
                      $mydata.push('<td id="tdamt" class="paymenttd"><input type="text" style="width:50px;" class="ItDoseTextinputNum" id="txtnetamt" value="'); $mydata.push(TestData[0].Amount); $mydata.push('" readonly="readonly"/></td>');
                      $mydata.push('<td id="tdispackage"    style="display:none;">'); $mydata.push(TestData[0].ispackage); $mydata.push('</td>');
                      $mydata.push('<td id="tdisreporting" style="display:none;">'); $mydata.push(TestData[0].reporting); $mydata.push('</td>');
                      $mydata.push('<td id="tdsubcategoryid" style="display:none;">'); $mydata.push(TestData[0].subcategoryid); $mydata.push('</td>');
                      $mydata.push('<td id="tdeporttype" style="display:none;">'); $mydata.push(TestData[0].reporttype); $mydata.push('</td>');
                      $mydata.push('<td id="tdGenderInvestigate" style="display:none;">'); $mydata.push(TestData[0].GenderInvestigate); $mydata.push('</td>');
                      $mydata.push('<td id="tdSample" style="display:none;">'); $mydata.push(TestData[0].Sample); $mydata.push('</td>');
                      $mydata.push('<td id="tdrequiredattachment" style="display:none;">'); $mydata.push(TestData[0].RequiredAttachment); $mydata.push('</td>');
                      $mydata.push('<td id="tdRequiredFields" style="display:none;">'); $mydata.push(TestData[0].RequiredFields); $mydata.push('</td>');
                      $mydata.push('<td id="tdbaserate" style="font-weight:bold;text-align: center;display:none;">'); $mydata.push(TestData[0].baserate ); $mydata.push('</td>');
                      $mydata.push('<td id="tddeptinterpretaion" style="font-weight:bold;text-align: center;display:none;">'); $mydata.push(TestData[0].deptinterpretaion); $mydata.push('</td>');

                      $mydata.push('<td id="tdIsScheduleRate" style="font-weight:bold;text-align: center;display:none;">'); $mydata.push(Rate.split('#')[1]); $mydata.push('</td>');


                      $mydata.push('<td id="tdDiscountApplicable"    style="display:none;">'); $mydata.push(TestData[0].DiscountApplicable); $mydata.push('</td>');
                      $mydata.push("<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsUrgent'  autocomplete='off' type='checkbox'  class='ItDoseTextinputNum'  style='padding:2px'  /></td>");
                      $mydata.push("</tr>");
                      $mydata = $mydata.join("");
                      jQuery('#tb_ItemList').append($mydata);
                  

                      sumtotal();
                      bindSuggestionPackage();
                      //  CouponCancel();
                      $(".TestDetail").scrollTop($('.TestDetail').prop('scrollHeight'));
                      //EmployeeDiscount();
                  }
              });             
        }
        function $viewDOS(investigationid, centerid, type) {
            fancyBoxOpen('../Master/DosData.aspx?investigationid=' + investigationid + '&centerid=' + centerid + '&type=' + type + '&IsUrgent=0');
        }
        function fancyBoxOpen(href) {
            jQuery.fancybox({
                maxWidth: 1350,
                maxHeight: 500,
                fitToView: false,
                width: '90%',
                height: '85%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
        );

        }

        function viewremarks(remarks, type) {
            var mm = "";
            if (type == "Test") {
                mm = "<h3>Test Details</h3>";
                // mm += "<br/>";
                mm += remarks;
            }
            else {
                mm = "<h3>Package Inclussions</h3>";
                //  mm += "<br/>";
                for (var i = 0; i < (remarks.split(',').length) ; i++) {
                    mm += remarks.split(',')[i];
                    mm += "<br/>";
                }
            }

            $('#showpopupmsg').html(mm);

            $('#popup_box3').fadeIn("slow");
            $("#popup_box1").css({
                "opacity": "0.5"
            });

        }

        function unloadPopupBox3() {
            $('#popup_box3').fadeOut("slow");
            $("#popup_box1").css({
                "opacity": "1"
            });

        }

        
        function sumtotal() {
            var net = 0; totalamt = 0; disc = 0;
            var packagecount = 0;
            var c = 0;
            $('#tb_ItemList tr').each(function () {
                var id = $(this).attr("id");
                if (id != "theader") {
                    if ($(this).find('#tdDiscountApplicable').text() == "0") {//tdispackage
                        packagecount = 1;
                    }
                    if (packagecount == "1") {
                        try {
                            if ($('#ddlDiscAppby').val() == "0") {
                                $('#txtDiscountAmt,#txtDiscountPer').prop('readonly', true);
                            }
                            else if ($('#ddlDiscAppby').val().split('#')[3] == "0") {
                                $('#txtDiscountAmt,#txtDiscountPer').prop('readonly', true);
                            }
                            else if ($('#ddlDiscAppby').val().split('#')[3] == "1") {
                                $('#txtDiscountAmt,#txtDiscountPer').prop('readonly', false);
                            }
                        }
                        catch (e)
                        { }
                    }
                    else {
                        $('#txtDiscountAmt,#txtDiscountPer').prop('readonly', false);
                    }
                   
                    
                    totalamt = parseInt(totalamt) + parseFloat($(this).find('#tdrate').text());
                    $('#amtcount').html(totalamt);
                  
                    if (parseInt($('#amtcount').html()) < 500) {

                        if ($.inArray("7", InvList) != -1 && $.inArray("8", InvList) != -1) {
                            $('#spdeliverycharge').html('100');
                        }
                        else {
                            $('#spdeliverycharge').html('50');
                        }


                    }
                    else {
                        $('#spdeliverycharge').html('0');
                    }
                    // Covid Test Charges
                    var stateid = $('#ch').is(':checked') ? $('#ddlstate').val() : $('#ddlstatehc').val();

                    if (stateid == "17" && ($.inArray("2411", InvList) != -1 || $.inArray("2410", InvList) != -1 || $.inArray("2417", InvList) != -1 || $.inArray("2446", InvList) != -1 || $.inArray("2462", InvList) != -1 || $.inArray("2461", InvList) != -1 || $.inArray("2468", InvList) != -1 || $.inArray("2478", InvList) != -1 || $.inArray("2388", InvList) != -1)) {
                        $('.covidch').show();
                        $('#<%=txtcovidcharge.ClientID%>').val('');
                    }
                    else {
                        $('.covidch').hide();
                        $('#<%=txtcovidcharge.ClientID%>').val('');
                    }

                    net = net + parseFloat($(this).find("#txtnetamt").val());

                    $('#txtTotalAmount').val(net);




                    if (Number($(this).find("#txttddisc").val()) > 0)
                    { itemwisedic = 1; }
                    disc = disc + Number($(this).find("#txttddisc").val());
                    $('#<%=lbdisamt.ClientID%>').text(disc);
                    if (disc == "0") {
                        $('#txtDiscountAmt,#txtDiscountPer').val('');
                    }



                }
            });

            if (disc == 0) {
                itemwisedic = 0;
            }
            var count = $('#tb_ItemList tr').length;
            if (count == 0 || count == 1) {
                $('#amtcount').html('0');
                $('#spdeliverycharge').html('0');
                $('.covidch').hide();
                $('#<%=txtcovidcharge.ClientID%>').val('');
                $('#txtTotalAmount').val('0');



                itemwisedic = 0;
                $('#<%=lbdisamt.ClientID%>').text('0');

            }
        }
        function setitemwisediscount(ctrl) {
            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
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
            if ($('#<%=txtDiscountAmt.ClientID%>').val().length > 0 && $('#<%=txtDiscountAmt.ClientID%>').val() != 0) {
                toast("Error","Discount Amount already Given");
                $(ctrl).val('0');
                return;
            }
            if ($('#<%=txtDiscountPer.ClientID%>').val().length > 0 && $('#<%=txtDiscountPer.ClientID%>').val() != 0) {
                toast("Error","Discount Per already Given");
                $(ctrl).val('0');
                return;
            }
            if ($(ctrl).val() == "") {
                //  $(ctrl).val('0');
            }
            var disc = Number($(ctrl).val());
            var rate = $(ctrl).closest("tr").find("#tdrate").text();
            if (parseFloat(disc) > parseFloat(rate)) {
                $(ctrl).val(rate);
                disc = rate;
            }
            $(ctrl).closest("tr").find("#txtnetamt").val((parseFloat(rate) - parseFloat(disc)));
            sumtotal();
        }



        function showHideDiscType() {
            //1 Employee Wise //0 Discount Type Wise
            


            resetitem();



        }

function resetitem() {


    InvList = [];//Empty Inv List
    $('#testcount,#amtcount,#spdeliverycharge').html('0');
    $('.covidch').hide();
    $('#<%=txtcovidcharge.ClientID%>').val('');
    testcount = 0;
    totalamt = 0;
    $('#tb_ItemList tr').slice(1).remove();
    $('#txtTotalAmount').val('0');
    $('#ddlInvestigation').val('');
    $('#<%=lbdisamt.ClientID%>').text('0');
            itemwisedic = 0;

        }

        function bindcollsource() {

            jQuery("#ddlsourceofcollection option").remove();
            serverCall('HomeCollection.aspx/bindcollsource', {  }, function (response) {
                var $ddlApprovedBy = jQuery('#ddlsourceofcollection');
                $ddlApprovedBy.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Source' });
            });

              // LabBooking.getdiscountapproval($('#<%=ddldroplocation.ClientID%>').val().split('#')[0], onSucessDiscountApproval, onFailureDiscountApproval);
          }
        function bindapptype() {
            
            jQuery("#ddlDiscAppby option").remove();
            serverCall('../Lab/Services/LabBooking.asmx/getDiscountApproval', { centreID: $('#<%=ddldroplocation.ClientID%>').val().split('#')[0] }, function (response) {
                var $ddlApprovedBy = jQuery('#ddlDiscAppby');
                $ddlApprovedBy.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'value', textField: 'label' });
            });

           // LabBooking.getdiscountapproval($('#<%=ddldroplocation.ClientID%>').val().split('#')[0], onSucessDiscountApproval, onFailureDiscountApproval);
        }
        function onSucessDiscountApproval(result) {
            discountApprovalData = $.parseJSON(result);
            if (discountApprovalData.length == 0) {
                $("#ddlDiscAppby").append($("<option></option>").val("0").html("--No Discount Approval Type--"));
            }
            else {
                $("#ddlDiscAppby").append($("<option></option>").val("0").html("Discount Approved By"));
                for (i = 0; i < discountApprovalData.length; i++) {
                    if (discountApprovalData[i].value.split('#')[0] != '1168') {
                        $("#ddlDiscAppby").append($("<option></option>").val(discountApprovalData[i].value).html(discountApprovalData[i].label));
                    }
                }
            }
        }
        function onFailureDiscountApproval(result) {

        }
        function deleteItemNode(row) {
            testcount = parseInt(testcount) - 1;
            $('#testcount').html(testcount);
            var $tr = $(row).closest('tr');
            var RmvInv = $tr.find('.inv').attr("id").split(',');
            var len = RmvInv.length;
            InvList.splice($.inArray(RmvInv[0], InvList), len);
            row.closest('tr').remove();
            sumtotal();
            bindSuggestionPackage();
            //EmployeeDiscount();
            //  CouponCancel();
        }      
        function onFailureDiscount(result) {

        }
        $(function () {
            $("#<%=txtDiscountPer.ClientID%>").keyup(
            function (e) {
                if (itemwisedic == 1) {
                    toast("Error","Item Wise Discount Amount already Given");
                    $('#<%=txtDiscountPer.ClientID%>').val('');
                    return;
                }
                if ($('#<%=txtDiscountAmt.ClientID%>').val() != -1) {
                    $('#<%=txtDiscountAmt.ClientID%>').val($('#<%=txtDiscountAmt.ClientID%>').val().replace('.', ''));
                }
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key != 9) {
                    if (isNaN($('#<%=txtDiscountPer.ClientID%>').val() / 1) == true) {
                        return;
                    }
                    if ($('#<%=txtDiscountAmt.ClientID%>').val().length > 0 && $('#<%=txtDiscountAmt.ClientID%>').val() >= 0) {
                        toast("Error","Discount Amount already Given");
                        $('#<%=txtDiscountPer.ClientID%>').val('');
                        return;
                    }
                    var total = parseFloat($('#amtcount').html());
                    var disper = parseFloat($('#<%=txtDiscountPer.ClientID%>').val());
                    if (disper > 100) {
                        toast("Error","Discount Percent can't greater then 100%");
                        var final = 0;
                        $('#txtTotalAmount').val(final);
                        $('#<%=txtDiscountPer.ClientID%>').val('100');
                        $('#<%=lbdisamt.ClientID%>').text(total);
                        return;
                    }
                    if (isNaN(disper / 1) == true) {
                        $('#txtTotalAmount').val(total);
                        $('#txtTotalAmount1').val(Number($('#txtTotalAmount').val()));
                        $('#<%=lbdisamt.ClientID%>').text('0');
                        return;
                    }
                    var disval = (total * disper) / 100;
                    disval = Math.round(disval);
                    var final = total - disval;
                    itemwisedic = 0;
                    $('#txtTotalAmount').val(final);
                    $('#<%=lbdisamt.ClientID%>').text(disval);
                }
            });
            $("#<%=txtDiscountAmt.ClientID%>").keyup(
           function (e) {
               if (itemwisedic == 1) {
                   toast("Error","Item Wise Discount Amount already Given");
                   $('#<%=txtDiscountAmt.ClientID%>').val('');
                   return;
               }
               var key = (e.keyCode ? e.keyCode : e.charCode);
               if (key != 9) {
                   if (isNaN($('#<%=txtDiscountPer.ClientID%>').val() / 1) == true) {
                       return;
                   }
                   if ($('#<%=txtDiscountPer.ClientID%>').val().length > 0) {
                       if ($('#<%=txtDiscountPer.ClientID%>').val() != "0") {
                           toast("Error","Discount Percent already Given");
                           $('#<%=txtDiscountAmt.ClientID%>').val('');
                           return;
                       }
                       else {
                           $('#<%=txtDiscountPer.ClientID%>').val('');
                       }
                   }
                   var total = parseFloat($('#amtcount').html());
                   var disper = parseFloat($('#<%=txtDiscountAmt.ClientID%>').val());
                   if (disper > total) {
                       toast("Error","Discount Amount can't greater then total amount");
                       var final = 0;
                       $('#txtTotalAmount').val(final);
                       $('#<%=txtDiscountAmt.ClientID%>').val(total);
                       $('#<%=lbdisamt.ClientID%>').text(total);
                       return;
                   }
                   if (isNaN(disper / 1) == true) {
                       $('#txtTotalAmount').val(total);
                       $('#txtTotalAmount1').val(Number($('#txtTotalAmount').val()));
                       $('#<%=lbdisamt.ClientID%>').text('0');
                       return;
                   }
                   var final = total - disper;
                   itemwisedic = 0;
                   $('#txtTotalAmount').val(final);
                   $('#<%=lbdisamt.ClientID%>').text(disper);
               }
           });
        });
    </script>
    <script type="text/javascript">
        function GetDataToSave() {
            var rowNum = 1;
            var amtValue = 0;
            var dataIm = new Array();
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "theader") {
                    var ProData = new Object();

                    ProData.Title = $('#<%=txtpatienttitle.ClientID%>').text();
                    ProData.Patient_ID = $('#<%=txtpatientid.ClientID%>').text();
                    ProData.PName = $('#<%=txtpatientname.ClientID%>').text();
                    ProData.Mobile = $('#<%=txtmobileno.ClientID%>').text();
                    ProData.Email = $('#<%=txtpatientemailid.ClientID%>').val()
                    ProData.DOB = $('#<%=txtddob.ClientID%>').text();
                    ProData.Age = $('#<%=txtpatientage.ClientID%>').text();
                    ProData.AgeYear = $('#<%=txtageyear.ClientID%>').text();
                    ProData.AgeMonth = $('#<%=txtagemonth.ClientID%>').text();
                    ProData.AgeDays = $('#<%=txtagedays.ClientID%>').text();
                    ProData.TotalAgeInDays = $('#<%=txttotaldays.ClientID%>').text();
                    ProData.Gender = $('#<%=txtpatientgender.ClientID%>').text();
                    ProData.VIP = $('#chvip').is(':checked') ? 1 : 0;
                    if ($('#<%=ch.ClientID%>').is(':checked')) {

                        ProData.House_No = $('#txtaddress').val(); //$('#<%=txtpatientaddress.ClientID%>').val();
                        ProData.LocalityID = $('#<%=ddlarea.ClientID%>').val();
                        ProData.Locality = $('#<%=ddlarea.ClientID%> option:selected').text();
                        ProData.CityID = $('#<%=ddlcity.ClientID%>').val();
                        ProData.City = $('#<%=ddlcity.ClientID%> option:selected').text();
                        ProData.StateID = $('#<%=ddlstate.ClientID%>').val();
                        ProData.State = $('#<%=ddlstate.ClientID%> option:selected').text();
                        ProData.Pincode = $('#<%=txtpincode.ClientID%>').val();
                        ProData.Landmark = $('#<%=txtpatientlandmark.ClientID%>').val();

                    }
                    else {

                        ProData.House_No = $('#<%=txtpatientaddresshc.ClientID%>').val();
                        ProData.LocalityID = $('#<%=ddlareahc.ClientID%>').val();
                        ProData.Locality = $('#<%=ddlareahc.ClientID%> option:selected').text();
                        ProData.CityID = $('#<%=ddlcityhc.ClientID%>').val();
                        ProData.City = $('#<%=ddlcityhc.ClientID%> option:selected').text();
                        ProData.StateID = $('#<%=ddlstatehc.ClientID%>').val();
                        ProData.State = $('#<%=ddlstatehc.ClientID%> option:selected').text();
                        ProData.Pincode = $('#<%=txtpincodehc.ClientID%>').val();
                        ProData.Landmark = $('#<%=txtpatientlandmarkhc.ClientID%>').val();
                    }

                    ProData.PreBookingCentreID = $('#<%=ddldroplocation.ClientID%>').val().split('#')[0];
                    ProData.Panel_ID = $('#<%=ddldroplocation.ClientID%>').val().split('#')[1];
                    ProData.GrossAmt = $(this).closest("tr").find('#tdrate').html();
                    
                    if (Number($('#<%=lbdisamt.ClientID%>').text()) > 0) {
                        if (Number($(this).closest("tr").find("#txttddisc").val()) > 0) {
                            ProData.DiscAmt = $(this).closest("tr").find('#txttddisc').val();
                            ProData.NetAmt = $(this).closest("tr").find('#txtnetamt').val();
                        }
                        else {
                            var discper = (parseFloat($('#<%=lbdisamt.ClientID%>').text()) * 100) / parseFloat($('#amtcount').html())
                            discper = Math.round(discper);
                            var amt = (parseFloat($(this).closest("tr").find("#tdrate").html()) * parseFloat(discper)) / 100;

                            if ($('#tb_ItemList tr').length - 1 == rowNum) {
                                var amtSecondLast = parseFloat(amtValue).toFixed(0);
                                var amtDiscfinalAmt = parseFloat($('#<%=lbdisamt.ClientID%>').text()).toFixed(0);
                                var amtDiff = parseFloat(amtDiscfinalAmt) - parseFloat(amtSecondLast);
                                ProData.DiscAmt = parseInt(parseFloat(amtDiff).toFixed(0));
                            }
                            else {
                                ProData.DiscAmt = parseInt(parseFloat(amt).toFixed(0));
                            }
                            ProData.NetAmt = parseFloat($(this).closest("tr").find("#tdrate").html()) - parseInt(parseFloat(ProData.DiscAmt).toFixed(0));
                            amtValue += parseInt(parseFloat(amt).toFixed(0));
                        }
                    }
                    else {
                        ProData.DiscAmt = $(this).closest("tr").find('#txttddisc').val();
                        ProData.NetAmt = $(this).closest("tr").find('#txtnetamt').val();
                    }
                    if (Number($('#<%=lbdisamt.ClientID%>').text()) > 0) {
                        ProData.DiscountTypeID = 0;
                    }
                    else {
                        ProData.DiscountTypeID = '-1';
                    }

                    if ( Number($('#<%=lbdisamt.ClientID%>').text()) > 0) {
                        ProData.DiscAppBy = $('#<%=ddlDiscAppby.ClientID%> option:selected').text();
                        ProData.DiscAppByID = $('#<%=ddlDiscAppby.ClientID%>').val().split('#')[0];
                        ProData.DiscReason = $('#<%=txtDiscReason.ClientID%>').val();
                    }
                    
                    ProData.AdrenalinEmpID = 0;                   
                    ProData.ItemId = $(this).closest("tr").attr("id");
                    ProData.ItemName = $(this).closest("tr").find('#tditemname').html();
                    ProData.Rate = $(this).closest("tr").find('#tdrate').html();
                    ProData.MRP = $(this).closest("tr").find('#tdMRP').html();
                    ProData.TestCode = $(this).closest("tr").find('#tdTestCode').html();
                    ProData.SubCategoryID = $(this).closest("tr").find('#tdsubcategoryid').html();
                    if ($("#hftxtReferDoctor").val() == "") {
                        ProData.DoctorID = "1";
                        ProData.RefDoctor = "SELF";
                    }
                    else {
                        ProData.DoctorID = $("#hftxtReferDoctor").val();
                        ProData.RefDoctor = $('#txtReferDoctor').val().split('#')[0];
                    }
                    ProData.OtherDoctor = $('#<%=txtOtherDoctor.ClientID%>').val();
                    ProData.Remarks = $('#<%=txtremarks.ClientID%>').val();
                    ProData.isUrgent = $(this).closest("tr").find("#chkIsUrgent").is(':checked') ? 1 : 0;
                    ProData.isPediatric = $("#chkisPediatric").is(':checked') ? 1 : 0;
                    dataIm.push(ProData);
                    rowNum += 1;
                }
            });
            return dataIm;
        }
        function BookSlot() {
            if ($('#hftxtReferDoctor').val() == "2" && $('#<%=txtOtherDoctor.ClientID%>').val() == "") {
                $('#<%=txtOtherDoctor.ClientID%>').focus();
                toast("Error","Please Enter Other Doctor");
                return;
            }

           // if ($('#<%=txtaltmobileno.ClientID%>').val() == "") {
             //   $('#<%=txtaltmobileno.ClientID%>').focus();
               // toast("Error","Please Enter Alternate Mobile No");
           //     return;
            //}
           // if ($('#<%=ddlclient.ClientID%>').val() == "") {
           //     $('#<%=ddlclient.ClientID%>').focus();
           //     toast("Error","Please Select Client");
           //     return;
          //  }
            if ($('#<%=ddlpaymentmode.ClientID%>').val() == "") {
                $('#<%=ddlpaymentmode.ClientID%>').focus();
                toast("Error","Please Select Payment Mode");
                return;
            }
            if ($('#<%=ddlsourceofcollection.ClientID%>').val() == "") {
                $('#<%=ddlsourceofcollection.ClientID%>').focus();
                toast("Error","Please Select Source Of Collection");
                return;
            }
            var count = $('#tb_ItemList tr').length;
            if (count == 0 || count == 1) {
                toast("Error","Please Select Test");
                $('#ddlInvestigation').focus();
                return false;
            }
            if (parseFloat($('#lbdisamt').text()) > 0  && parseFloat($('#txtCouponAmt').text()) == 0 ) {
                if ($('#ddlDiscAppby').val() == 0) {
                    toast("Error", "Please Select Discount By");
                    $('#ddlDiscAppby').focus();
                    return;
                }
                if ($.trim($('#txtDiscReason').val()) == "") {
                    toast("Error", "Please Enter Discount Reason");
                    $('#txtDiscReason').focus();
                    return;
                }
            }
            var tablecount = jQuery('#tblCouponDetail tr').length;
            var oldcouponID = "";
            if (Number(tablecount) > 1) {
                jQuery('#tblCouponDetail tr').each(function () {
                    var id = jQuery(this).closest("tr").attr("id");
                    if (id != "trCoupon") {
                        oldcouponID += id + "#";
                    }
                });
            }
            var datatosave = GetDataToSave();

            if (datatosave.length == 0) {
                toast("Error","Please Select Test");
                $('#ddlInvestigation').focus();
                return false;
            }

            var stateid = $('#ch').is(':checked') ? $('#ddlstate').val() : $('#ddlstatehc').val();
            if (stateid == "17" && ($.inArray("2411", InvList) != -1 || $.inArray("2410", InvList) != -1 || $.inArray("2417", InvList) != -1 || $.inArray("2446", InvList) != -1 || $.inArray("2462", InvList) != -1 || $.inArray("2461", InvList) != -1 || $.inArray("2468", InvList) != -1 || $.inArray("2478", InvList) != -1 || $.inArray("2388", InvList) != -1) && $('#<%=txtcovidcharge.ClientID%>').val() == "") {
                $('#<%=txtcovidcharge.ClientID%>').focus();
                toast("Error","Please Enter Covid Home Collection Charges");
                return;
            }

            var PhelebotomistId = $('#<%=txtPhlebotomistid.ClientID%>').text();
            var Phelebotomistname = $('#<%=txtPhlebotomistname.ClientID%>').text();
            var AppDateTime = $('#<%=txtappdate.ClientID%>').text() + " " + $('#<%=txtapptime.ClientID%>').text();
            var updatepatient = $('#<%=chedit.ClientID%>').is(':checked') ? 1 : 0;
            var HardCopyRequired = $('#chHardCopyRequired').is(':checked') ? 1 : 0;
            var ReceiptRequired = $('#chreceipt').is(':checked') ? 1 : 0;
            var ispermanetaddress = $('#<%=ch.ClientID%>').is(':checked') ? 1 : 0;
            var Latitude = 0;
            var Longitude = 0;
            if (ispermanetaddress == 1) {
                Latitude = $('#<%=txtLatitude.ClientID%>').text();
                Longitude = $('#<%=txtLongitude.ClientID%>').text();
            }
            else {
                Latitude = $('#<%=txtLatitudehc.ClientID%>').text();
                Longitude = $('#<%=txtLongitudehc.ClientID%>').text();
            }

            var Alternatemobileno = $('#<%=txtaltmobileno.ClientID%>').val();
            var Client = $('#<%=ddlclient.ClientID%>').val();
            var Paymentmode = $('#<%=ddlpaymentmode.ClientID%>').val();
            var SourceofCollection = $('#<%=ddlsourceofcollection.ClientID%>').val();
            var emailidpcc = $('#<%=ddldroplocation.ClientID%>').val().split('#')[4];
            var centrename = $('#<%=ddldroplocation.ClientID%> option:selected').text();
            var Route = $('#<%=lbroute.ClientID%>').text();
            var RouteID = $('#<%=lbroute1.ClientID%>').text();
            var deliverych = $('#spdeliverycharge').html();

            if (stateid == "17" && ($.inArray("2411", InvList) != -1 || $.inArray("2410", InvList) != -1 || $.inArray("2417", InvList) != -1 || $.inArray("2446", InvList) != -1 || $.inArray("2462", InvList) != -1 || $.inArray("2461", InvList) != -1 || $.inArray("2468", InvList) != -1 || $.inArray("2478", InvList) != -1 || $.inArray("2388", InvList) != -1)) {
                deliverych = $('#<%=txtcovidcharge.ClientID%>').val();
            }
            var oldprebookingid = $('#txtoldprebookingid').text();
            var phelboshare = $('#<%=ddlphlebocharge.ClientID%>').val();
            serverCall('HomeCollection.aspx/savedata',
                { datatosave: datatosave, AppDateTime: AppDateTime, updatepatient: updatepatient, HardCopyRequired: HardCopyRequired, PhlebotomistID: PhelebotomistId, Latitude: Latitude, Longitude: Longitude, ispermanetaddress: ispermanetaddress, ReceiptRequired: ReceiptRequired, Alternatemobileno: Alternatemobileno, Client: Client, Paymentmode: Paymentmode, SourceofCollection: SourceofCollection, Phelebotomistname: Phelebotomistname, emailidpcc: emailidpcc, centrename: centrename, RouteName: Route, RouteID: RouteID, deliverych: deliverych, endtime: $('#<%=txtendtime.ClientID%>').text(), oldprebookingid: oldprebookingid, hcrequestid: hcrequestid, followupcallid: followupcallid, phelboshare: phelboshare, oldcouponID: oldcouponID },
                 function (result) {
                     if (result == "1") {
                         toast("Success", "Home Collection Booked");
                         resetitem();
                         unloadPopupBox();

                     }
                     else {
                         toast("Error", result);
                     }
                 });           
        }
    </script>

    <script type="text/javascript">
        function bindoldappdata(philboid, appdatettime) {
            $('#tblolddata tr').remove();
            $('#appdiv1').hide();
            serverCall('HomeCollection.aspx/SearchRecords', { philboid: philboid, appdatettime: appdatettime }, function (result) {
                if (result.split('#')[0] == "-1") {

                    toast("Error", "This slot is temporarily occupied.<br/> Occupied By :-  " + result.split('#')[1].split('^')[0] + " <br/>Occupied From :- " + result.split('#')[1].split('^')[1]);
                    $('#popup_box1').fadeOut("slow");
                    $("#Pbody_box_inventory").css({
                        "opacity": "1"
                    });
                    return;
                }
                PanelData = jQuery.parseJSON(result);
                if (PanelData.length == 0) {


                    return;
                }
                var $mydata = [];
                $mydata.push('<tr id="trheader">');

                $mydata.push('<td class="GridViewHeaderStyle">PrebookingID</td>');
                $mydata.push('<td class="GridViewHeaderStyle">App DateTime</td>');
                $mydata.push('<td class="GridViewHeaderStyle">Patient Name</td>');
                $mydata.push('<td class="GridViewHeaderStyle">Age/Gender</td>');
                $mydata.push('<td class="GridViewHeaderStyle">Mobile</td>');
                $mydata.push('<td class="GridViewHeaderStyle">Address</td>');
                $mydata.push('<td class="GridViewHeaderStyle">Area</td>');
                $mydata.push('<td class="GridViewHeaderStyle">Pincode</td>');
                $mydata.push('<td class="GridViewHeaderStyle">Test</td>');
                $mydata.push('<td class="GridViewHeaderStyle">GrossAmt</td>');
                $mydata.push('<td class="GridViewHeaderStyle">DiscAmt</td>');
                $mydata.push('<td class="GridViewHeaderStyle">NetAmt</td>');
                $mydata.push('<td class="GridViewHeaderStyle" title="Edit">Edit</td>');
                $mydata.push('<td class="GridViewHeaderStyle" title="Reschedule">RS</td>');
                $mydata.push('<td class="GridViewHeaderStyle">Cancel</td>');

                $mydata.push('</tr>');
                $mydata = $mydata.join("");
                jQuery('#tblolddata').append($mydata);
                for (var i = 0; i <= PanelData.length - 1; i++) {
                    var rowcolor = PanelData[i].rowcolor;
                    var $mydata = [];
                    if (PanelData[i].Patient_ID == $('#<%=txtpatientid.ClientID%>').text()) {
                            $mydata.push('<tr style="background-color:' + rowcolor + ';" class="GridViewItemStyle" id=' + PanelData[i].prebookingid + '>');
                        }
                        else {
                            $mydata.push('<tr style="background-color:darkgray;" class="GridViewItemStyle" id=' + PanelData[i].prebookingid + '>');
                        }

                        $mydata.push('<td align="left" id="prebookingid" style="font-weight:bold;">' + PanelData[i].prebookingid + '</td>');
                        $mydata.push('<td align="left" id="appdatetime" style="font-weight:bold;">' + PanelData[i].appdatetime + '</td>');
                        $mydata.push('<td align="left" id="pname1" style="font-weight:bold;">' + PanelData[i].pname + '</td>');
                        $mydata.push('<td align="left" id="pinfo">' + PanelData[i].pinfo + '</td>');
                        $mydata.push('<td align="left" id="mobile">' + PanelData[i].mobile + '</td>');
                        $mydata.push('<td align="left" id="house_no" style="font-weight:bold;">' + PanelData[i].house_no + '</td>');
                        $mydata.push('<td align="left" id="locality" style="font-weight:bold;">' + PanelData[i].locality + '</td>');
                        $mydata.push('<td align="left" id="pincode" style="font-weight:bold;">' + PanelData[i].pincode + '</td>');
                        $mydata.push('<td align="left" id="testname">' + PanelData[i].testname + '</td>');
                        $mydata.push('<td align="left" id="rate">' + PanelData[i].rate + '</td>');
                        $mydata.push('<td align="left" id="discamt">' + PanelData[i].discamt + '</td>');
                        $mydata.push('<td align="left" id="netamt">' + PanelData[i].netamt + '</td>');

                        if ((PanelData[i].status == "Pending" || PanelData[i].status == "Rescheduled") && PanelData[i].Patient_ID == $('#<%=txtpatientid.ClientID%>').text()) {
                            if (roleid != 253) {
                                $mydata.push('<td title="Click To Edit"><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="editapp(\'' + PanelData[i].prebookingid + '\')"/></td>');

                                $mydata.push('<td title="Click To Reschedule"><img src="../../App_Images/reload.jpg" style="cursor:pointer;" onclick="Reschedule(this)"/></td>');
                                $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="cancelapp(this)"/></td>');
                            }
                        }
                        else {
                            $mydata.push('<td></td>');
                            $mydata.push('<td></td>');
                            $mydata.push('<td></td>');
                        }
                        $mydata.push('<td align="left" id="philboid" style="display:none;">' + philboid + '</td>');
                        $mydata.push('<td align="left" id="appdatettime" style="display:none;">' + appdatettime + '</td>');
                        $mydata.push('</tr>');
                        $mydata = $mydata.join("");
                        jQuery('#tblolddata').append($mydata);
                    }
                $('#appdiv1').show();
            });
            
        }


        function bindlastthreevisit() {
            $('#tbllastthreevisit tr').remove();
            
            serverCall('HomeCollection.aspx/GetLastThreeVisit', { uhid: $('#<%=txtpatientid.ClientID%>').text() }, function (result) {
                PanelData = jQuery.parseJSON(result);
                if (PanelData.length == 0) {
                    $('#pname').html('');
                    $(".lastthreevisit").hide();
                    return;
                }

                var labno = "";
                var newdata = "";
                var mydata = "<tr>";
                var c = 0;
                var co = 1;
                var amt1 = 0; var amt2 = 0; var amt3 = 0;
                var PhelboRating = 0; var PatientRating = 0;
                var PatientFeedback = ''; var PhelboFeedback = '';

                $('#pname').html($('#txtpatienttitle').text() + $('#txtpatientname').text() + "      (" + $('#txtmobileno').text() + ")");

                for (var i = 0; i <= PanelData.length - 1; i++) {

                    if (labno != PanelData[i].prebookingid) {

                        if (c == 1) {
                            mydata += '<tr style="background-color:#61a4e6;color:white;font-weight:bold;"><td>Total</td><td>' + amt1 + '</td><td>' + amt2 + '</td><td>' + amt3 + '</td></tr>';
                            mydata += newdata;
                            mydata += '</table></div></td>';
                            amt1 = 0; amt2 = 0; amt3 = 0;
                            c = 0;
                        }
                        mydata += '<td  valign="top" style="padding:2px;">';
                        mydata += '<div id="lastvisit' + co + '">';
                        mydata += '<table style="border:1px solid blue;border-radius:10px;box-shadow:0px 0px 5px blue;"><tr>';
                        mydata += '<td align="center" colspan="4" style="font-weight:bold;background-color:#61a4e6;color:white;font-size:11px;">' + co + ') App Date :' + PanelData[i].appdate + ' PrebookingID :' + PanelData[i].prebookingid + '</td></tr>';

                        mydata += '<tr id="trheader" style="background-color: #61a4e6;color:white;">';
                        mydata += '<td style="font-weight:bold;font-size:11px">Test Name</td>';
                        mydata += '<td style="font-weight:bold;font-size:11px">Rate</td>';
                        mydata += '<td style="font-weight:bold;font-size:11px">Disc Amt.</td>';
                        mydata += '<td style="font-weight:bold;font-size:11px">Amt.</td>';
                        mydata += '</tr>';

                        labno = PanelData[i].prebookingid;
                        c = 1;
                        co = co + 1;
                    }
                    if (PanelData[i].isconfirm == "0") {
                        mydata += '<tr style="background-color:lemonchiffon;">';
                    }
                    else {
                        mydata += '<tr style="background-color:lightgreen;">';
                    }

                    mydata += '<td align="left"  style="font-weight:bold;font-size:10px">' + PanelData[i].ItemName + '</td>';
                    mydata += '<td align="left"  style="font-weight:bold;font-size:10px">' + PanelData[i].Rate + '</td>';
                    mydata += '<td align="left"  style="font-weight:bold;font-size:10px">' + PanelData[i].DiscAmt + '</td>';
                    mydata += '<td align="left"  style="font-weight:bold;font-size:10px">' + PanelData[i].NetAmt + '</td>';

                    amt1 = amt1 + parseInt(PanelData[i].Rate);
                    amt2 = amt2 + parseInt(PanelData[i].DiscAmt);
                    amt3 = amt3 + parseInt(PanelData[i].NetAmt);
                    mydata += '</tr>';
                    newdata = "";
                    if (PanelData[i].PhelboRating != "") {
                        newdata += '<tr style="background-color:#e07a7a;color:white;"><td colspan="4">';
                        newdata += 'PhelboRating :';
                        for (var a = 1; a <= PanelData[i].PhelboRating; a++) {
                            newdata += '<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>';
                        }
                        newdata += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp';
                        newdata += 'PatientRating : ';
                        for (var a = 1; a <= PanelData[i].PatientRating; a++) {
                            newdata += '<img src="../../App_Images/star.png" style="height:15px;width:15px;"/>';
                        }
                        newdata += '</td></tr>';
                    }
                    if (PanelData[i].PhelboFeedback != "") {
                        newdata += '<tr style="background-color:#e07a7a;color:white;"><td colspan="4">';
                        newdata += 'Phelbo Feedback : ' + PanelData[i].PhelboFeedback;
                        newdata += '</td></tr>';
                    }
                    if (PanelData[i].PatientFeedback != "") {
                        newdata += '<tr style="background-color:#e07a7a;color:white;"><td colspan="4">';
                        newdata += 'Patient Feedback : ' + PanelData[i].PatientFeedback;
                        newdata += '</td></tr>';
                    }


                }
                if (c == 1) {
                    mydata += '<tr style="background-color:#61a4e6;color:white;font-weight:bold;"><td>Total</td><td>' + amt1 + '</td><td>' + amt2 + '</td><td>' + amt3 + '</td></tr>';
                    mydata += newdata;

                    mydata += '</table></div></td>';
                    amt1 = 0; amt2 = 0; amt3 = 0;
                    c = 0;
                }

                mydata += '</tr>';
                $('#tbllastthreevisit').append(mydata);
                $(".lastthreevisit").show();
                $(".mylast3visit").slideToggle("slow");

            });
            
        }

        function unloadPopupBox4() {
            $('#popup_box4').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });

            openme();

        }


        function cancelappnow() {
            if ($('#txtcancelreason').val() == "") {
                toast("Error", "Please Enter Cancel Reason");
                return;
            }
            serverCall('HomeCollection.aspx/CancelAppointment',{ appid: $('#txtcancelpre').val(), reason: $('#txtcancelreason').val() },function (result) {
                     if (result == "1") {
                         toast("Success", "Appointment Cancel");
                         $('#popup_box4').fadeOut("slow");
                         $("#Pbody_box_inventory").css({
                             "opacity": "1"
                         });
                         openme();
                         bindoldappdata($('#txtcancelpre1').val(), $('#txtcancelpre2').val());
                     }
                 });
        }
        function cancelapp(ctrl) {

            $('#popup_box1').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
            $('#txtcancelpre').val($(ctrl).closest('tr').find('#prebookingid').html());
            $('#txtcancelpre1').val($(ctrl).closest('tr').find('#philboid').html());
            $('#txtcancelpre2').val($(ctrl).closest('tr').find('#appdatettime').html());
            $('#popup_box4').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
        }
        function Reschedule(ctrl) {
            $('#popup_box1').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
            $('#<%=lbhcidre.ClientID%>').text($(ctrl).closest('tr').find('#prebookingid').html());
            $('#<%=lbappdatere.ClientID%>').text($(ctrl).closest('tr').find('#appdatettime').html());
            $('#<%=lbphlebore.ClientID%>').text($('#<%=txtPhlebotomistname.ClientID%>').text());
            $('#<%=lbphleboreid.ClientID%>').text($(ctrl).closest('tr').find('#philboid').html());
            $('#<%=txtappdatere.ClientID%>').val($(ctrl).closest('tr').find('#appdatettime').html().split(' ')[0]);
            $('#<%=lbappdatere.ClientID%>').text($(ctrl).closest('tr').find('#appdatettime').html());
            $('#popup_box2').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
            $("#Pbody_box_inventory :input").attr("disabled", true);
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

                jQuery("#<%=ddlphlebonew.ClientID%>").val($('#<%=lbphleboreid.ClientID%>').text());
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

        function unloadPopupBox1() {
            $('#popup_box2').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
            openme();
        }
        function RescheduleNow() {
            if ($('#<%=ddlapptimere.ClientID%>').val() == "0") {
                $('#<%=ddlapptimere.ClientID%>').focus();
                toast("Error","Please Select Appointment Time");
                return;
            }
            savereschedule($('#<%=lbhcidre.ClientID%>').text(), $('#<%=txtappdatere.ClientID%>').val(), $('#<%=ddlapptimere.ClientID%>').val(), $('#<%=ddlphlebonew.ClientID%>').val(), '1');
        }

        function savereschedule(prebookingid, appdate, apptime, phelbotomistid, type) {
            serverCall('HomeCollection.aspx/RescheduleNow',
                { prebookingid: prebookingid, appdate: appdate, apptime: apptime, phelbotomistid: phelbotomistid },
                 function (result) {
                     if (result == "1") {
                         toast("Success", "Appointment Rescheduled");
                         if (type == '1') {
                             unloadPopupBox1();
                             unloadPopupBox();
                         }
                         else {
                             searchslot('', '', '', '', '1');
                         }
                     }
                     else {
                         toast("Error", result);
                     }

                 });
            
        }

    </script>


    <script type="text/javascript">
        var roleid = '<%=roleid%>';
        var bookedmultipleslot = '<%=bookedmultipleslot%>';
        function searchslot(aid, pcode, freeslot, phelboid, changedroplocation) {
            var areaid = ""; var pincode = "";
            if ($('#<%=ch.ClientID%>').is(':checked')) {
                areaid = $('#<%=ddlarea.ClientID%>').val();
                pincode = $('#<%=txtpincode.ClientID%>').val();
            }
            else {
                areaid = $('#<%=ddlareahc.ClientID%>').val();
                pincode = $('#<%=txtpincodehc.ClientID%>').val();
            }
            if (aid != "" && pcode != "") {
                areaid = aid;
                pincode = pcode;
            }

            if (areaid == "0" || areaid == null) {
                toast("Error", "Please Select Area");
                return;
            }

            if (pincode == "") {
                toast("Error", "Please Enter Pincode");
                return;
            }
            $('#<%=lbmsg.ClientID%>').text('');
            $('#slottable tr').remove();
            serverCall('HomeCollection.aspx/bindslot',
                { areaid: areaid, pincode: pincode, fromdate: $('#<%=dtFrom.ClientID%>').val(), freeslot: freeslot, phelboid: phelboid },
                 function (result) {
                     if (result.split('#')[0] == "1") {
                         toast("Error", result.split('#')[1]);
                         return;
                     }
                     var $mydata = [];
                     SlotData = jQuery.parseJSON(result);
                     $('#<%=lbroute.ClientID%>').text(SlotData[0].route.split('@')[0]);
                     $('#<%=lbroute1.ClientID%>').text(SlotData[0].route.split('@')[1]);
                     if (changedroplocation == '1') {
                         jQuery('#<%=ddldroplocation.ClientID%> option').remove();
                         for (var gg = 0; gg <= SlotData[0].centreid.split('$').length - 1; gg++) {
                             jQuery('#<%=ddldroplocation.ClientID%>').append(jQuery("<option></option>").val(SlotData[0].centreid.split('$')[gg].split('^')[0]).html(SlotData[0].centreid.split('$')[gg].split('^')[1]));
                         }
                     }

                     var col = [];
                     $mydata.push('<tr id="header" style="background:-webkit-gradient(linear, 0 0, 0 100%, from(white), to(lightgray));font-weight:bold;height:35px;">');
                     for (var i = 0; i < SlotData.length; i++) {
                         for (var key in SlotData[i]) {
                             if (col.indexOf(key) === -1) {
                                 if (key == "PhlebotomistID" || key == "route" || key == "centreid" || key == "centre") {
                                     $mydata.push('<td style="display:none;">'); $mydata.push(key.split('#')[0]); $mydata.push('</td>');
                                 }
                                 else {
                                     $mydata.push('<td>'); $mydata.push(key); $mydata.push('</td>');
                                 }
                                 col.push(key);
                             }
                         }
                     }


                     $mydata.push('</tr>');
                     for (var i = 0; i < SlotData.length; i++) {
                         $mydata.push('<tr id="'); $mydata.push(SlotData[i].PhlebotomistID.split('#')[0]); $mydata.push('" style="height:40px;">');
                         for (var j = 0; j < col.length; j++) {

                             if (col[j] == "PhlebotomistID") {
                                 $mydata.push('<td style="display:none;">'); $mydata.push(SlotData[i][col[j]].split('#')[0]); $mydata.push('</td>');
                             }
                             else if (col[j] == "route" || col[j] == "centreid" || col[j] == "centre") {
                                 $mydata.push('<td style="display:none;">'); $mydata.push(SlotData[i][col[j]]); $mydata.push('</td>');
                             }


                             else if (col[j] == "PhlebotomistName") {
                                 if (SlotData[i].PhlebotomistID.split('#')[2] == "0") {
                                     $mydata.push('<td title="Click To View Profile" onclick="showphelboprofile(\''); $mydata.push(SlotData[i].PhlebotomistID.split('#')[0]); $mydata.push('\')" style="font-weight:bold;background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));cursor:pointer;">'); $mydata.push(SlotData[i][col[j]]); $mydata.push('</td>');
                                 }
                                 else {
                                     $mydata.push('<td title="Click To View Profile" onclick="showphelboprofile(\''); $mydata.push(SlotData[i].PhlebotomistID.split('#')[0]); $mydata.push('\')" style="font-weight:bold;background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(pink));cursor:pointer;">'); $mydata.push(SlotData[i][col[j]]); $mydata.push('</td>');
                                 }
                             }
                             else {


                                 if (SlotData[i][col[j]] != null) {

                                     var mm = SlotData[i][col[j]];
                                     if (bookedmultipleslot == 1 && mm.split('~').length < 4) {
                                         $mydata.push('<td ondrop="drop(event,\''); $mydata.push(SlotData[i].PhlebotomistID.split('#')[0]); $mydata.push('\',\''); $mydata.push(col[j]); $mydata.push('\')" ondragover="allowDrop(event)"  colspan="'); $mydata.push(SlotData[i].PhlebotomistID.split('#')[1]); $mydata.push('"  style="cursor:pointer; background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));" onclick="openmypopup(this,\''); $mydata.push($('#txtpatientaddress').val()); $mydata.push('\',\''); $mydata.push(SlotData[i].PhlebotomistID.split('#')[0]); $mydata.push('\',\''); $mydata.push(col[j]); $mydata.push('\',\''); $mydata.push(SlotData[i].PhlebotomistName); $mydata.push('\',\''); $mydata.push(SlotData[i].PhlebotomistID.split('#')[1]); $mydata.push('\')" >');
                                     }
                                     else {

                                         $mydata.push('<td colspan="'); $mydata.push(SlotData[i].PhlebotomistID.split('#')[1]); $mydata.push('" style="background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));"  >');

                                     }

                                     for (var c = 0; c <= mm.split('~').length - 1; c++) {
                                         if (mm.split('~')[c].split('#')[10] == "1") {
                                             $mydata.push('<div   id="div_' + mm.split('~')[c].split('#')[6] + '"');
                                             if (mm.split('~')[c].split('#')[5] == "0" && mm.split('~')[c].split('#')[0] != $('#<%=txtpatientid.ClientID%>').text()) {
                                                 $mydata.push('style="background-color:darkgray;color:white;padding:5px;margin:5px;"')
                                             }
                                             else if (mm.split('~')[c].split('#')[5] == "1") {
                                                 $mydata.push('style="background-color:lightgreen;color:black;padding:5px;margin:5px;"  ');
                                             }

                                             var divtitle = "PrebookingId: " + mm.split('~')[c].split('#')[6] + String.fromCharCode(13) + "Address: " + mm.split('~')[c].split('#')[2] + String.fromCharCode(13) + "Mobile: " + mm.split('~')[c].split('#')[3] + String.fromCharCode(13) + "IsVip: " + mm.split('~')[c].split('#')[7] + String.fromCharCode(13) + "HardCopyRequired: " + mm.split('~')[c].split('#')[8] + String.fromCharCode(13) + "NetAmount: " + mm.split('~')[c].split('#')[11];
                                             $mydata.push('title="'); $mydata.push(divtitle); $mydata.push('" >');


                                             $mydata.push(mm.split('~')[c].split('#')[1]); $mydata.push("<br/>"); $mydata.push(mm.split('~')[c].split('#')[9]); $mydata.push("<br/>Rs. "); $mydata.push(mm.split('~')[c].split('#')[11]);
                                             $mydata.push('</div>');
                                         }
                                         else {

                                             $mydata.push('<img src="../../App_Images/slotbooked.png"/>');
                                         }


                                     }
                                     $mydata.push('</td>');

                                     j = j + (Number(SlotData[i].PhlebotomistID.split('#')[1]) - 1);
                                 }
                                 else {

                                     $mydata.push('<td ondrop="drop(event,\''); $mydata.push(SlotData[i].PhlebotomistID.split('#')[0]); $mydata.push('\',\''); $mydata.push(col[j]); $mydata.push('\')" ondragover="allowDrop(event)" title="Click To Book Appointment ('); $mydata.push(SlotData[i].PhlebotomistName); $mydata.push(')" style="cursor:pointer; background:-webkit-gradient(linear, 0 0, 0 100%, from(#f8f8f8), to(#eaeaea));" onclick="openmypopup(this,\''); $mydata.push($('#txtpatientaddress').val()); $mydata.push('\',\''); $mydata.push(SlotData[i].PhlebotomistID.split('#')[0]); $mydata.push('\',\''); $mydata.push(col[j]); $mydata.push('\',\''); $mydata.push(SlotData[i].PhlebotomistName); $mydata.push('\',\''); $mydata.push(SlotData[i].PhlebotomistID.split('#')[1]); $mydata.push('\')" colspan="'); $mydata.push(SlotData[i].PhlebotomistID.split('#')[1]); $mydata.push('" >');
                                     $mydata.push('</td>');
                                     j = j + (Number(SlotData[i].PhlebotomistID.split('#')[1]) - 1);

                                 }


                             }
                         }

                         $mydata.push('</tr>');
                     }

                     $mydata = $mydata.join("");
                     jQuery('#slottable').append($mydata);
                 });
        }
function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev, phelboid, timeslot) {
    if (confirm("Do You want To Reschedule?")) {
        ev.preventDefault();
        var data = ev.dataTransfer.getData("text");
        savereschedule(data.split('_')[1], $('#<%=dtFrom.ClientID%>').val(), timeslot, phelboid, '2');
    }

}
    </script>


    <script type="text/javascript">
        function bindCity() {
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            jQuery('#<%=txtpincode.ClientID%>').val('');
            serverCall('HomeCollection.aspx/bindCity',
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
                 });
        }

        function bindLocality() {

            jQuery('#<%=ddlarea.ClientID%> option').remove();
            jQuery('#<%=txtpincode.ClientID%>').val('');
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity',
                { CityID: jQuery('#<%=ddlcity.ClientID%>').val() },
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
                 });
            bindroute();
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
                     searchslot('', '', '', '', '1');
                 });
        }
        function bindCity1() {
            jQuery('#<%=ddlcityhc.ClientID%> option').remove();
            jQuery('#<%=ddlareahc.ClientID%> option').remove();
            jQuery('#<%=txtpincodehc.ClientID%>').val('');
            serverCall('HomeCollection.aspx/bindCity',{ StateID: jQuery('#<%=ddlstatehc.ClientID%>').val() },function (result) {
              cityData = jQuery.parseJSON(result);
              if (cityData.length == 0) {
                  jQuery('#<%=ddlcityhc.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
              }
              else {
                  jQuery('#<%=ddlcityhc.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                  for (i = 0; i < cityData.length; i++) {
                      jQuery('#<%=ddlcityhc.ClientID%>').append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                  }
              }
          });
        }
          function bindLocality1() {            
              jQuery('#<%=ddlareahc.ClientID%> option').remove();
              jQuery('#<%=txtpincodehc.ClientID%>').val('');
              serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity',
                { CityID: jQuery('#<%=ddlcityhc.ClientID%>').val() },
                 function (result) {
                     localityData = jQuery.parseJSON(result);
                     if (localityData.length == 0) {
                         jQuery('#<%=ddlareahc.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Area Found---"));
                    }

                    else {
                        jQuery('#<%=ddlareahc.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                        for (i = 0; i < localityData.length; i++) {
                            jQuery('#<%=ddlareahc.ClientID%>').append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                        }
                    }
                 });           
            bindroute1();
        }
        function bindpincode1() {           
            jQuery('#<%=txtpincodehc.ClientID%>').val('');
            serverCall('customercare.aspx/bindpincode',
                { LocalityID: jQuery('#<%=ddlareahc.ClientID%>').val() },
                 function (result) {
                     pincode = result;
                     if (pincode == "") {
                         jQuery('#<%=txtpincodehc.ClientID%>').val('').attr('readonly', false);
                           }

                           else {
                               jQuery('#<%=txtpincodehc.ClientID%>').val(pincode).attr('readonly', true);
                               searchslot('', '', '', '', '1');
                           }
                 });            
               }
    </script>
    <script type="text/javascript">
        $(function () {
            $("#txtReferDoctor")
                    // don't navigate away from the field on tab when selecting an item
                    .bind("keydown", function (event) {
                        if (event.keyCode === $.ui.keyCode.TAB &&
                            $(this).autocomplete("instance").menu.active) {
                            event.preventDefault();
                        }
                    })
                    .autocomplete({
                        autoFocus: true,
                        source: function (request, response) {
                            $.getJSON("../Common/CommonJsonData.aspx?cmd=ReferDoctor", {
                                docname: extractLast(request.term), centreid: $('#<%=ddldroplocation.ClientID%> option:selected').val().split('#')[0]
                            }, response);
                        },
                        search: function () {
                            var term = extractLast(this.value);
                            if (term.length < 2) {
                                return false;
                            }
                        },
                        focus: function () {
                            return false;
                        },
                        response: function (event, ui) {
                            if (!ui.content.length) {
                                $("#txtReferDoctor").val('');
                            }
                        },
                        open: function () {
                            $("#txtReferDoctor").attr('rel', 0);
                        },
                        close: function () {
                            if ($("#txtReferDoctor").attr('rel') != '0')
                                $("#txtReferDoctor").val('');
                        },
                        change: function (event, ui) {
                            if (ui.item == null) {
                                $("#txtReferDoctor").val('');
                                return;
                            }
                            if (ui.item.label != $("#txtReferDoctor").val()) {
                                $("#txtReferDoctor").val('');
                            }
                        },
                        select: function (event, ui) {
                            $("#hftxtReferDoctor").val(ui.item.value);
                            this.value = ui.item.label;
                            if (ui.item.value == "2") {
                                // showNewDocPOP();
                                $('#<%=txtOtherDoctor.ClientID%>').show();

                                $('#<%=txtOtherDoctor.ClientID%>').focus();
                                this.value = ui.item.label;
                            }
                            else {
                                $('#<%=txtOtherDoctor.ClientID%>').hide();

                                $('#<%=txtOtherDoctor.ClientID%>').val('');
                            }
                            return false;
                        },
                    });
        });
    </script>
    <script type="text/javascript">
        function bindroute() {            
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            serverCall('HomeCollection.aspx/bindroute',
                { cityid: jQuery('#<%=ddlcity.ClientID%>').val() },
                 function (result) {
                     localityData = jQuery.parseJSON(result);
                     if (localityData.length == 0) {
                         jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Route Found---"));
                    }

                    else {
                        jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val("0").html("Change Route"));
                        for (i = 0; i < localityData.length; i++) {
                            jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val(localityData[i].routeid).html(localityData[i].Route));
                        }
                    }
                 });          
        }
        function bindroute1() {            
            jQuery('#<%=ddlroute.ClientID%> option').remove();
            serverCall('HomeCollection.aspx/bindroute',
                { cityid: jQuery('#<%=ddlcityhc.ClientID%>').val() },
                 function (result) {
                     localityData = jQuery.parseJSON(result);
                     if (localityData.length == 0) {
                         jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Route Found---"));
                    }
                    else {
                        jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val("0").html("Change Route"));
                        for (i = 0; i < localityData.length; i++) {
                            jQuery('#<%=ddlroute.ClientID%>').append(jQuery("<option></option>").val(localityData[i].routeid).html(localityData[i].Route));
                        }
                    }
                 });                
        }
        function getmyslot() {
            if (jQuery('#<%=ddlroute.ClientID%>').val() != "0") {
                searchslot(jQuery('#<%=ddlroute.ClientID%>').val().split('#')[1], jQuery('#<%=ddlroute.ClientID%>').val().split('#')[2], '', '', '0');
            }
        }
        function openlastvisit() {
            $(".mylast3visit").slideToggle("slow");
        }
        function hidelast3visit() {
            $(".mylast3visit").slideToggle("slow");
        }
    </script>
    <script type="text/javascript">
        function bindsuggestionitemwise(itemid) {
            if (itemid == "" || itemid == null) {
                return false;
            }
            serverCall('../Lab/Lab_PrescriptionOPD.aspx/bindPromotionlTest',
                { ItemID: itemid, PanelID: $("#<%=ddldroplocation.ClientID%>").val().split('#')[1], CentreID: $('#<%=ddldroplocation.ClientID%>').val().split('#')[0] },
                 function (result) {
                     suggestionData = $.parseJSON(result);
                     if (suggestionData.length > 0) {
                         for (var i = 0; i <= suggestionData.length - 1; i++) {
                             var sugtestname = (suggestionData[i].TestName.split('~')[1] == undefined) ? suggestionData[i].TestName : suggestionData[i].TestName.split('~')[1];
                             var $promotionalTest = [];
                             $promotionalTest.push('<tr style="background-color:aqua; cursor:pointer;"');
                             $promotionalTest.push('onclick="$fillSelectedTest(\''); $promotionalTest.push($responseData[i].TestCode); $promotionalTest.push('\');" >');
                             $promotionalTest.push('<td style="text-align:left;">'); $promotionalTest.push(i + 1);
                             $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push($responseData[i].SelectedTestName);
                             $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push($responseData[i].SelectedTestCode);
                             $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push(sugtestname);
                             $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push($responseData[i].TestCode);
                             $promotionalTest.push('</td><td style="text-align:left;">'); $promotionalTest.push($responseData[i].rate);
                             $promotionalTest.push('</td></tr>');
                             $promotionalTest = $promotionalTest.join("");
                             jQuery('#tblitemSuggection').append($promotionalTest);
                         }
                         $('.containeritemsuggestion').show();
                         $(".button-slidesuggest").click();
                     }
                 });
        }
        function showSuggestionItemTest() {
            $(".feedbacksuggestion").slideToggle("slow");
        }
        function hideSuggestionItemTest() {
            $(".feedbacksuggestion").slideToggle("slow");
        }
        function showsuggestivetest() {
            serverCall('HomeCollection.aspx/showoldtest',
                { pid: $('#<%=txtpatientid.ClientID%>').text() },
                 function (result) {
                     $('#tblSuggection tr').slice(1).remove();
                     suggestionData = $.parseJSON(result);
                     if (suggestionData.length > 0) {
                         for (var i = 0; i <= suggestionData.length - 1; i++) {
                             var $suggestionData=[];
                             var sugtestname = (suggestionData[i].TestName.split('~')[1] == undefined) ? suggestionData[i].TestName : suggestionData[i].TestName.split('~')[1]; var suggestionRowData = '<tr '
                             if (suggestionData[i].STATUS == 'High') {
                                 $suggestionData.push(' style="background-color:pink; cursor:pointer; "');
                             }
                             else if (suggestionData[i].STATUS == 'Low') {
                                 $suggestionData.push(' style="background-color:yellow; cursor:pointer; "');
                             }
                             $suggestionData.push(' onclick="fillTestName(\''); $suggestionData.push(sugtestname); $suggestionData.push('\');" ><td style="text-align:center;">'); $suggestionData.push((i + 1)); $suggestionData.push(' </td>');
                             $suggestionData.push('<td style="text-align:center;">'); $suggestionData.push(suggestionData[i].DATE); $suggestionData.push(' </td>');
                             $suggestionData.push('<td style="text-align:center;">'); $suggestionData.push(sugtestname); $suggestionData.push(' </td>');
                             $suggestionData.push('<td style="text-align:center;">'); $suggestionData.push(suggestionData[i].STATUS); $suggestionData.push(' </td>');
                             $suggestionData.push('</tr>');
                             $suggestionData = $suggestionData.join("");
                             $('#tblSuggection').append($suggestionData);
                         }
                         $('.container').show();
                         $(".button-slide").click();
                     }
                 });           
        }
        function showSuggestionTest() {
            $(".feedback").slideToggle("slow");
        }
        function hideSuggestionTest() {
            $(".feedback").slideToggle("slow");
        }
        function fillTestName(testNameData) {
            $('#rblSearchType_2').prop('checked', 'checked');
            $("#ddlInvestigation").val(testNameData.trim());
            $('#ddlInvestigation').autocomplete('search');
            $("#ddlInvestigation").focus();
        }
        $fillSelectedTest = function (testName) {
            jQuery("rblSearchType_2").prop("checked", true);
            jQuery("#ddlInvestigation").val(testName);
            jQuery("#ddlInvestigation").focus();
            jQuery('#ddlInvestigation').autocomplete('search');
            jQuery("#ddlInvestigation").focus(function () {
                jQuery(this).autocomplete("search");
            });
        }

        function bindTestPackage(testNameData) {
            jQuery('#rblsearchtype_2').prop('checked', 'checked');
            jQuery("#ddlInvestigation").val(testNameData.trim());
            jQuery('#ddlInvestigation').autocomplete('search');
            jQuery("#ddlInvestigation").focus();
            resetitem();
            jQuery('#tblPackageSuggestion tr').slice(1).remove();
            jQuery('.conPackageDetail').hide();
        }

        function bindSuggestionPackage() {
            var referenceCodeOPD = $('#<%=ddldroplocation.ClientID%>').val().split('#')[2];

            var TestId = '';
            if (jQuery('#tb_ItemList tr').length > 3) {
                jQuery('#tb_ItemList tr').each(function (index) {
                    if (index > 0) {
                        TestId += jQuery(this)[0].id + ",";
                    }
                });
                TestId = TestId.substring(0, (TestId.length - 1));
                var TotalAmount = $('#<%=txtTotalAmount.ClientID%>').text();

                serverCall('HomeCollection.aspx/RecommendedPackage', { TestId: TestId, referenceCodeOPD: referenceCodeOPD, TotalAmount: TotalAmount  }, function (result) {
                    var data = jQuery.parseJSON(result);
                    if (data.length > 0) {
                        jQuery('#tblPackageSuggestion tr').slice(1).remove();
                        for (var i = 0; i < data.length; i++) {
                            var mydata = [];
                            mydata.push('<tr onclick="bindTestPackage(\''); mydata.push(data[i].Name); mydata.push('\');"> ');
                            mydata.push('<td  valign="top" style="font-weight:bold;">'); mydata.push((i + 1)); mydata.push('</td>');
                            mydata.push('<td  valign="top" style="font-weight:bold;">'); mydata.push(data[i].Name); mydata.push(' ');
                            mydata.push('<span class="spnTooltip">');
                            mydata.push('<table style="border: 1px solid black;width:360px;border-collapse: collapse;">');
                            for (var j = 0; j < data[i].ItemDetail.split('##').length; j++) {
                                if (j == 0) {
                                    mydata.push('<tr >');
                                    mydata.push('<td style="border: 1px solid black;font-weight: bold;text-align: left;" class="GridViewHeaderStyle">S.No.</td>');
                                    mydata.push('<td style="border: 1px solid black;font-weight: bold;text-align: left;" class="GridViewHeaderStyle">Item Name</td>');
                                    mydata.push('</tr >');
                                }
                                mydata.push('<tr >');
                                mydata.push('<td style="border: 1px solid black;background-color:lemonchiffon;text-align: left;">');mydata.push((j + 1) );mydata.push('  </td>');
                                mydata.push('<td style="border: 1px solid black;background-color:lemonchiffon;text-align: left;">');mydata.push(data[i].ItemDetail.split('##')[j] );mydata.push('</td>');
                                mydata.push('</tr >');

                            }
                            mydata.push('</table >');
                            mydata.push('</span>');
                            mydata.push('</td>');
                            mydata.push('<td valign="top" style="font-weight:bold;">');mydata.push(data[i].Rate);mydata.push('</td>');
                            mydata.push('</tr>');
                            mydata = mydata.join("");
                            jQuery('#tblPackageSuggestion').append(mydata);
                        }
                        $('.conPackageDetail').show();
                        $(".button-slidepackageRecommended").click();
                    }
                    else {
                        $('.conPackageDetail').hide();
                    }
                });                
            }
            else {
                $('.conPackageDetail').hide();
            }
        }
        function hideRecommendedPackage() {
            jQuery(".divPackageRecommended").slideToggle("slow");
        }
        function showRecommendedPackage() {
            jQuery(".divPackageRecommended").slideToggle("slow");
        }
        $(function () {
            $('#tblPackageSuggestion tr').hover(function () {
                $(this).addClass('hover');
            }, function () {
                $(this).removeClass('hover');
            });
        });
    </script>
    <script type="text/javascript">
        function editapp(prebookingid) {
            serverCall('HomeCollection.aspx/LoadEditData', { prebookingid: prebookingid }, function (result) {
                var data = jQuery.parseJSON(result);
                if (data.length > 0) {
                    $('#txtPhlebotomistname').text(data[0].phelboname);
                    $('#txtoldprebookingid').text(data[0].prebookingid);
                    $('#txtappdate').text(data[0].appdate);
                    $('#txtapptime').text(data[0].apptime);
                    $('#txtPhlebotomistid').text(data[0].PhlebotomistID);
                    $('#txtaltmobileno').val(data[0].Alternatemobileno);
                    $('#ddlsourceofcollection').val(data[0].SourceofCollection);
                    $('#ddlclient').val(data[0].Client);
                    $('#ddlpaymentmode').val(data[0].Paymentmode);
                    $('#txtremarks').val(data[0].Remarks);
                    $('#txtReferDoctor').val(data[0].ReferedDoctor);
                    $('#hftxtReferDoctor').val(data[0].DoctorID);
                    if ($('#hftxtReferDoctor').val() == "2") {
                        $('#txtOtherDoctor').val(data[0].OtherDoctor);
                        $('#txtOtherDoctor').show();
                    }
                    if (data[0].VIP == "1") {
                        $('#chvip').prop('checked', true);
                    }
                    else {
                        $('#chvip').prop('checked', false);
                    }
                    if (data[0].HardCopyRequired == "1") {
                        $('#chHardCopyRequired').prop('checked', true);
                    }
                    else {
                        $('#chHardCopyRequired').prop('checked', false);
                    }

                    for (i = 0; i < data.length; i++) {
                        AddItem(data[i].ItemId, data[i].itemtype, data[i].Rate, data[i].discper);
                    }
                    $('#btnSave,#discountdiv').hide();
                    $('#btnupdate').show();
                }
                else {                       
                }            
            });                   
        }
        function GetDataToSaveEdit() {
            var rowNum = 1;
            var amtValue = 0;
            var dataIm = new Array();
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "theader") {
                    var ProData = new Object();
                    ProData.GrossAmt = $(this).closest("tr").find('#tdrate').html();
                    if (Number($('#<%=lbdisamt.ClientID%>').text()) > 0) {
                        if (Number($(this).closest("tr").find("#txttddisc").val()) > 0) {
                            ProData.DiscAmt = $(this).closest("tr").find('#txttddisc').val();
                            ProData.NetAmt = $(this).closest("tr").find('#txtnetamt').val();
                        }
                        else {
                            var discper = (parseFloat($('#<%=lbdisamt.ClientID%>').text()) * 100) / parseFloat($('#amtcount').html())
                            discper = Math.round(discper);
                            var amt = (parseFloat($(this).closest("tr").find("#tdrate").html()) * parseFloat(discper)) / 100;

                            if ($('#tb_ItemList tr').length - 1 == rowNum) {
                                var amtSecondLast = parseFloat(amtValue).toFixed(0);
                                var amtDiscfinalAmt = parseFloat($('#<%=lbdisamt.ClientID%>').text()).toFixed(0);
                                var amtDiff = parseFloat(amtDiscfinalAmt) - parseFloat(amtSecondLast);
                                ProData.DiscAmt = parseInt(parseFloat(amtDiff).toFixed(0));
                            }
                            else {
                                ProData.DiscAmt = parseInt(parseFloat(amt).toFixed(0));
                            }
                            ProData.NetAmt = parseFloat($(this).closest("tr").find("#tdrate").html()) - parseInt(parseFloat(ProData.DiscAmt).toFixed(0));
                            amtValue += parseInt(parseFloat(amt).toFixed(0));
                        }
                    }
                    else {
                        ProData.DiscAmt = $(this).closest("tr").find('#txttddisc').val();
                        ProData.NetAmt = $(this).closest("tr").find('#txtnetamt').val();
                    }
                    ProData.ItemId = $(this).closest("tr").attr("id");
                    ProData.ItemName = $(this).closest("tr").find('#tditemname').html();
                    ProData.Rate = $(this).closest("tr").find('#tdrate').html();
                    ProData.TestCode = $(this).closest("tr").find('#tdTestCode').html();
                    ProData.SubCategoryID = $(this).closest("tr").find('#tdsubcategoryid').html();
                    if ($("#hftxtReferDoctor").val() == "") {
                        ProData.DoctorID = "1";
                        ProData.RefDoctor = "SELF";
                    }
                    else {
                        ProData.DoctorID = $("#hftxtReferDoctor").val();
                        ProData.RefDoctor = $('#txtReferDoctor').val().split('#')[0];
                    }
                    ProData.OtherDoctor = $('#<%=txtOtherDoctor.ClientID%>').val();
                    ProData.Remarks = $('#<%=txtremarks.ClientID%>').val();
                    ProData.MRP = $(this).closest("tr").find('#tdMRP').html();
                    dataIm.push(ProData);
                    rowNum += 1;
                }
            });
            return dataIm;
        }
        function UpdateSlot() {
            if ($('#hftxtReferDoctor').val() == "2" && $('#<%=txtOtherDoctor.ClientID%>').val() == "") {
                $('#<%=txtOtherDoctor.ClientID%>').focus();
                toast("Error","Please Enter Other Doctor");
                return;
            }

          //  if ($('#<%=txtaltmobileno.ClientID%>').val() == "") {
              //  $('#<%=txtaltmobileno.ClientID%>').focus();
            //    toast("Error","Please Enter Alternate Mobile No");
                //return;
            //}
           // if ($('#<%=ddlclient.ClientID%>').val() == "") {
           //     $('#<%=ddlclient.ClientID%>').focus();
           //     toast("Error","Please Select Client");
           //     return;
           // }
            if ($('#<%=ddlpaymentmode.ClientID%>').val() == "") {
                $('#<%=ddlpaymentmode.ClientID%>').focus();
                toast("Error","Please Select Payment Mode");
                return;
            }
            if ($('#<%=ddlsourceofcollection.ClientID%>').val() == "") {
                $('#<%=ddlsourceofcollection.ClientID%>').focus();
                toast("Error","Please Select Source Of Collection");
                return;
            }
            var count = $('#tb_ItemList tr').length;
            if (count == 0 || count == 1) {
                toast("Error","Please Select Test");
                $('#ddlInvestigation').focus();
                return false;
            }
            var datatosave = GetDataToSaveEdit();
            if (datatosave.length == 0) {
                toast("Error","Please Select Test");
                $('#ddlInvestigation').focus();
                return false;
            }
            var stateid = $('#ch').is(':checked') ? $('#ddlstate').val() : $('#ddlstatehc').val();
            if (stateid == "17" && ($.inArray("2411", InvList) != -1 || $.inArray("2410", InvList) != -1 || $.inArray("2417", InvList) != -1 || $.inArray("2446", InvList) != -1 || $.inArray("2462", InvList) != -1 || $.inArray("2461", InvList) != -1 || $.inArray("2468", InvList) != -1 || $.inArray("2478", InvList) != -1 || $.inArray("2388", InvList) != -1) && $('#<%=txtcovidcharge.ClientID%>').val() == "") {
                $('#<%=txtcovidcharge.ClientID%>').focus();
                toast("Error","Please Enter Covid Home Collection Charges");
                return;
            }


            var HardCopyRequired = $('#chHardCopyRequired').is(':checked') ? 1 : 0;
            var VIP = $('#chvip').is(':checked') ? 1 : 0;


            var prebookingid = $('#txtoldprebookingid').text();
            var Alternatemobileno = $('#<%=txtaltmobileno.ClientID%>').val();
            var Client = $('#<%=ddlclient.ClientID%>').val();
            var Paymentmode = $('#<%=ddlpaymentmode.ClientID%>').val();
            var SourceofCollection = $('#<%=ddlsourceofcollection.ClientID%>').val();
            var deliverych = $('#spdeliverycharge').html();
            if (stateid == "17" && ($.inArray("2002", InvList) != -1 || $.inArray("2010", InvList) != -1)) {
                deliverych = $('#<%=txtcovidcharge.ClientID%>').val();
            }
            var Phelebotomistname = $('#<%=txtPhlebotomistname.ClientID%>').text();
            serverCall('HomeCollection.aspx/updatedata', { datatosave: datatosave, VIP: VIP, HardCopyRequired: HardCopyRequired, Alternatemobileno: Alternatemobileno, Client: Client, Paymentmode: Paymentmode, SourceofCollection: SourceofCollection, prebookingid: prebookingid, deliverych: deliverych, Phelebotomistname: Phelebotomistname }, function (result) {
                if (result == "1") {
                    toast("Success","Home Collection Updated");
                    resetitem();
                    if (mypreid == "") {
                        unloadPopupBox();
                    }
                    else {
                        parent.jQuery.fancybox.close();
                        parent.gethistory();
                    }


                }
                else {
                    toast("Error",result);
                }
            });        
        }
    </script>
    <script type="text/javascript">
        var mypreid = '<%=Util.GetString(Request.QueryString["prebookingid"])%>';
        var mypreidnew = '<%=Util.GetString(Request.QueryString["prebookingidnew"])%>';
        $(function () {

            if (mypreid != "") {
                openme();
                editapp(mypreid);
            }
        });
        function unloadPopupBox5() {
            $('#popup_box5').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
        }
        function showphelboprofile(phelboid) {
            serverCall('HomeCollection.aspx/showphelbotprofile', { phelboid: phelboid }, function (result) {
                var data = jQuery.parseJSON(result);
                $('#phname').html(data[0].NAME);
                $('#phmobile').html(data[0].mobile);
                $('#phemail').html(data[0].email);
                $('#phdob').html(data[0].dob);
                $('#phaddress').html(data[0].address);
                $('#phjndate').html(data[0].joiningdate);
                $('#phpan').html(data[0].panno);
                $('#pncity').html(data[0].workingcity);
                $('#phvn').html(data[0].Vehicle_num);
                $('#phdl').html(data[0].DrivingLicence);
                $('#phbg').html(data[0].bloodgroup);
                $('#phqualification').html(data[0].Qualification);
                $('#phgender').html(data[0].gender);
                if (data[0].ProfilePics == '') {
                    $('#phimg').attr('src', '../../App_Images/NoimagePhelebo.jpg');
                }
                else {
                    $('#phimg').attr('src', data[0].ProfilePics);
                }

            });                        
            $('#popup_box5').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
        }
    </script>
    <script type="text/javascript">
        function getoldhomecollectionaddress() {
            $('#oldPatientTable tr').slice(1).remove();
            serverCall('HomeCollection.aspx/GetOldHomeCollectionAddress', { pid: $('#<%=txtpatientid.ClientID%>').text() }, function (result) {
                var data = jQuery.parseJSON(result);
                if (data.length == 0) {                  
                    return;
                }
                for (var i = 0; i <= data.length - 1; i++) {
                    var $mydata = [];
                    $mydata.push("<tr  style='text-align:left;background-color:#c9e493;'>");
                    $mydata.push('<td><input type="button" value="Select" onclick="showoldpatientdata(this);" class="savebutton" /></td>');
                    $mydata.push('<td id="address">');$mydata.push(data[i].address);$mydata.push('</td>');
                    $mydata.push('<td id="locality">');$mydata.push(data[i].locality);$mydata.push('</td>');
                    $mydata.push('<td id="City">');$mydata.push(data[i].City);$mydata.push('</td>');
                    $mydata.push('<td id="State">');$mydata.push(data[i].State);$mydata.push('</td>');
                    $mydata.push('<td id="pincode">');$mydata.push(data[i].pincode);$mydata.push('</td>');
                    $mydata.push('<td id="Landmark" >');$mydata.push(data[i].Landmark);$mydata.push('</td>');
                    $mydata.push('<td id="LocalityID"     style="display:none;">');$mydata.push(data[i].LocalityID);$mydata.push('</td>');
                    $mydata.push('<td id="cityid"      style="display:none;">');$mydata.push(data[i].cityid);$mydata.push('</td>');
                    $mydata.push('<td id="stateid"   style="display:none;">');$mydata.push(data[i].stateid);$mydata.push('</td>');
                    $mydata.push('<td id="Latitude"   style="display:none;">');$mydata.push(data[i].Latitude);$mydata.push('</td>');
                    $mydata.push('<td id="Longitude"   style="display:none;">');$mydata.push(data[i].Longitude);$mydata.push('</td>');
                    $mydata.push('</tr>');
                    $mydata = $mydata.join("");
                    $('#oldPatientTable').append($mydata);                       
                }
                $('#popup_box6').fadeIn("slow");
                $("#Pbody_box_inventory").css({
                    "opacity": "0.5"
                });
            });         
        }
        function showoldpatientdata(ctrl) {
            $('#<%=txtLatitudehc.ClientID%>').val($(ctrl).closest('tr').find('#Latitude').text());
            $('#<%=txtLongitudehc.ClientID%>').val($(ctrl).closest('tr').find('#Longitude').text());
            $('#<%=ddlstatehc.ClientID%>').val($(ctrl).closest('tr').find('#stateid').text());
            bindCity1();
            $('#<%=ddlcityhc.ClientID%>').val($(ctrl).closest('tr').find('#cityid').text());
            bindLocality1();
            $('#<%=ddlareahc.ClientID%>').val($(ctrl).closest('tr').find('#LocalityID').text());;
            $('#<%=txtpatientlandmarkhc.ClientID%>').val($(ctrl).closest('tr').find('#Landmark').text());
            $('#<%=txtpincodehc.ClientID%>').val($(ctrl).closest('tr').find('#pincode').text());
            $('#<%=txtpatientaddresshc.ClientID%>').val($(ctrl).closest('tr').find('#address').text());
            unloadPopupBox6();
        }
        function unloadPopupBox6() {
            $('#popup_box6').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
        }
    </script>

    <script type="text/javascript">
        $(function () {
            $("#<%=txtpincode.ClientID%>").keydown(
             function (e) {
                 var key = (e.keyCode ? e.keyCode : e.charCode);
                 if (key == 13) {
                     e.preventDefault();
                     getareafrompincode();
                 }
             });
            $("#<%=txtpincodehc.ClientID%>").keydown(
             function (e) {
                 var key = (e.keyCode ? e.keyCode : e.charCode);
                 if (key == 13) {
                     e.preventDefault();
                     getareafrompincodehc();
                 }

             });
        });
        function getareafrompincode() {
            if ($("#<%= txtpincode.ClientID%>").val().trim() == "") {
                return;
            }
            if ($("#<%= txtpincode.ClientID%>").val().length < 6) {
                return;
            }          
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            serverCall('HomeCollection.aspx/getareafrompincode', { pincode: $('#<%=txtpincode.ClientID%>').val(),CityID:jQuery('#<%=ddlcity.ClientID%>').val()  }, function (result) {
                localityData = jQuery.parseJSON(result);
                if (localityData.length == 0) {
                    jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Area Found---"));
                    }
                    else {

                        for (i = 0; i < localityData.length; i++) {
                            jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                        }
                    }
            });           
        }
        function getareafrompincodehc() {
            if ($("#<%= txtpincodehc.ClientID%>").val().trim() == "") {
                return;
            }
            if ($("#<%= txtpincodehc.ClientID%>").val().length < 6) {
                return;
            }
            jQuery('#<%=ddlareahc.ClientID%> option').remove();           
            serverCall('HomeCollection.aspx/getareafrompincode', { pincode: $('#<%=txtpincodehc.ClientID%>').val(), CityID: jQuery('#<%=ddlcityhc.ClientID%>').val() }, function (result) {
                localityData = jQuery.parseJSON(result);
                if (localityData.length == 0) {
                    jQuery('#<%=ddlareahc.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Area Found---"));
                    }

                    else {

                        for (i = 0; i < localityData.length; i++) {
                            jQuery('#<%=ddlareahc.ClientID%>').append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                        }
                    }
            });          
        }
    </script>
    <script type="text/javascript">
        function opennotbookedbox() {
            $('#popup_box7').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
            $('#<%=txtnotbookedremarks.ClientID%>').val('').focus();
        }
        function unloadPopupBox7() {
            $('#popup_box7').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
        }
        function savenotbookedreason() {
            if ($('#<%=txtnotbookedremarks.ClientID%>').val() == "") {
                toast("Error","Please Enter Reason");
                $('#<%=txtnotbookedremarks.ClientID%>').focus();
                return;
            }
            serverCall('HomeCollection.aspx/savenotbookedreason', { uhid: $('#<%=txtpatientid.ClientID%>').val(), mobileno: jQuery('#<%=txtmobileno.ClientID%>').text(),address:$('#<%=txtpatientaddress.ClientID%>').val(),areaid:$('#<%=ddlarea.ClientID%>').val(),cityid: $('#<%=ddlcity.ClientID%>').val() ,stateid: $('#<%=ddlstate.ClientID%>').val() ,pincode: $('#<%=txtpincode.ClientID%>').val(),reason:$('#<%=txtnotbookedremarks.ClientID%>').val() }, function (result) {
                if (result == "1") {                      
                    toast("Success","Reason Saved Sucessfully");
                    unloadPopupBox7();
                    parent.jQuery.fancybox.close();
                }
                else {
                    toast("Error",result);                      
                }
            });                      
        }
    </script>
    <script type="text/javascript">
        function editmyapp(prebookingid) {
            serverCall('HomeCollection.aspx/LoadEditDataOnlyTest', { prebookingid: prebookingid  }, function (result) {
                var data = jQuery.parseJSON(result);
                if (data.length > 0) {
                    $('#txtoldprebookingid').text(data[0].prebookingid);
                    $('#ddlpaymentmode').val(data[0].Paymentmode);
                    $('#txtremarks').val(data[0].Remarks);
                    $('#txtReferDoctor').val(data[0].ReferedDoctor);
                    $('#hftxtReferDoctor').val(data[0].DoctorID);
                    if ($('#hftxtReferDoctor').val() == "2") {
                        $('#txtOtherDoctor').val(data[0].OtherDoctor);
                        $('#txtOtherDoctor').show();
                    }
                    if (data[0].VIP == "1") {
                        $('#chvip').prop('checked', true);
                    }
                    else {
                        $('#chvip').prop('checked', false);
                    }                  
                        for (i = 0; i < data.length; i++) {
                            AddItem(data[i].ItemId, data[i].itemtype, data[i].Rate, data[i].discper);
                        }
                        $('#btnSave').show();
                        $('#btnupdate').hide();
                        $("#discountdiv").hide();
                        $('#ddlInvestigation').prop('readonly', true);
                        $('.deletemydata').hide();                      
                    }
                    else {
                        
                    }
            });         
        }
    </script>
    <script type="text/javascript">
        var hcrequestid = "<%=Util.GetString(Request.QueryString["hcrequestid"])%>";
        var followupcallid = "<%=Util.GetString(Request.QueryString["followupcallid"])%>";
        function bindhcrequestdata() {
            var mobileno = $('#<%=txtmobileno.ClientID%>').text();
            if (hcrequestid != "") {
                serverCall('Customercare.aspx/bindhcrequestdata', { hcrequestid: hcrequestid, mobileno: mobileno }, function (result) {
                    hcrequestdatajson = jQuery.parseJSON(result);
                    if (hcrequestdatajson.length == 0) {
                        $('.hcrequest').html('');
                    }
                    else {
                        var $mydata = [];
                        $mydata.push("<table style='width:99%;'><tr><td colspan='8' style='text-align:center;font-weight:bold;'><div class='Purchaseheader'>Home Collection Request From WhatsApp</div></td></tr><tr>");
                        $mydata.push('<td style="font-weight:bold;">MobileNo : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].mobileno);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">UHID : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Patient_id);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">Name : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Pname);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">Age/Gender : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Age);$mydata.push('/');$mydata.push(hcrequestdatajson[0].Gender);$mydata.push('</td></tr>');
                        $mydata.push('<tr><td style="font-weight:bold;">Address : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Address);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">Pincode : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Pincode);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">Test : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Test);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">HCDate : </td>');
                        if (hcrequestdatajson[0].filename != "") {
                            $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Homecollectiondatetime);$mydata.push('>&nbsp;&nbsp;&nbsp;<a target="_blank" href="');$mydata.push(hcrequestdatajson[0].filename);$mydata.push('">View File</a></td>');
                        }
                        else {
                            $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Homecollectiondatetime);$mydata.push('</td>');
                        }
                        $mydata.push('</tr></table>');
                        $mydata = $mydata.join("");
                        jQuery('.hcrequest').append($mydata);                       
                    }
                });              
            }
            if (followupcallid != "") {
                serverCall('Customercare.aspx/bindfollowdata', { followupcallid: followupcallid, mobileno: mobileno }, function (result) {
                    hcrequestdatajson = jQuery.parseJSON(result);
                    if (hcrequestdatajson.length == 0) {
                        $('.hcrequest').html('');
                    }
                    else {
                        var $mydata = [];
                        $mydata.push("<table style='width:99%;'><tr><td colspan='8' style='text-align:center;font-weight:bold;'><div class='Purchaseheader'>Home Collection Request From FollowUp Call</div></td></tr><tr>");
                        $mydata.push('<td style="font-weight:bold;">MobileNo : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].mobileno);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">UHID : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Patient_id);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">Name : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Pname);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">Age/Gender : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Age);$mydata.push('/');$mydata.push(hcrequestdatajson[0].Gender);$mydata.push('</td></tr>');
                        $mydata.push('<tr><td style="font-weight:bold;">Address : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Address);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">Pincode : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Pincode);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">Test : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Test);$mydata.push('</td>');
                        $mydata.push('<td style="font-weight:bold;">HCDate : </td>');
                        $mydata.push('<td style="font-weight:bold;">');$mydata.push(hcrequestdatajson[0].Homecollectiondatetime);$mydata.push('</td>');
                        $mydata.push('</tr></table>');
                        $mydata = $mydata.join("");
                        jQuery('.hcrequest').append($mydata);                       
                    }
                });               
            }
        }
    </script>



     <script type="text/javascript">
         $getCouponOTP = function () {
             if (Number(jQuery('#spnTotalDiscountAmount').text() > 0)) {
                 toast('Error', "Please Remove Discount Before Apply Coupon");
                 return;
             }
             if (jQuery('#txtCouponNo').val() == "") {
                 jQuery('#txtCouponNo').focus();
                 toast('Error', "Please Enter Coupon No.");
                 return;
             }
             if (jQuery('#txtMobileNo').val() == "") {
                 jQuery('#txtMobileNo').focus();
                 toast('Error', "Please Enter Mobile No to Get OTP");
                 return;
             }
             if (jQuery('#txtMobileNo').val().length != 10) {
                 jQuery('#txtMobileNo').focus();
                 toast('Error', "Please Enter 10 digit Mobile No to Get OTP");
                 return;

             }
             if (jQuery('#txtPName').val() == "") {
                 jQuery('#txtPName').focus();
                 toast('Error', "Please Enter Patient Name");
                 return;
             }
             var count = jQuery('#tb_ItemList tr').length;
             if (count == 0 || count == 1) {
                 toast('Error', "Please Select Test To Apply Coupon");
                 jQuery('#txtInvestigationSearch').focus();
                 jQuery('#txtCouponNo').val('');
                 return false;
             }
             var subcate = "0";
             jQuery('#tb_ItemList tr').each(function () {
                 var id = jQuery(this).closest("tr").attr("id");
                 if (id != "header" && jQuery(this).closest("tr").find("#tdDiscountApplicable").html() == "0") {
                     subcate = "1";
                 }
             });
             var itemid = "";
             jQuery('#tb_ItemList tr').each(function () {
                 if (jQuery(this).closest("tr").attr("id") != "theader") {
                     itemid += jQuery(this).closest("tr").attr("id") + ",";
                 }
             });
             if (jQuery('table#tblCouponDetail').find('.' + jQuery('#txtCouponNo').val()).length > 0) {
                 jQuery('#txtCouponNo').val('');
                 toast('Error', "Coupon Already Added");
                 jQuery('#txtCouponOTP').val('');
                 jQuery('#txtUniqueID').val('');
                 return;
             }
             var tablecount = jQuery('#tblCouponDetail tr').length;
             var oldcouponID = "";
             if (Number(tablecount) > 1) {
                 jQuery('#tblCouponDetail tr').each(function () {
                     var id = jQuery(this).closest("tr").attr("id");
                     if (id != "trCoupon") {
                         oldcouponID += id + "#";
                     }
                 });
             }
             serverCall("HomeCollection.aspx/ValidateCoupanGetOTP", { CouponNo: jQuery('#txtCouponNo').val(), mobileno: jQuery('#txtMobileNo').val(), PatientName: jQuery('#txtPName').val(), Panelid: jQuery('#ddlPanel').val(), uhid:'', itemid: itemid, tablecount: tablecount, bookingamt: jQuery('#txtNetAmount').val(), oldcouponID: oldcouponID, ispackage: subcate }, function (response) {
                 var $responseData = JSON.parse(response);
                 if ($responseData.status) {
                     toast('Success', "OTP Send to Mobile No.");
                     jQuery('#txtCouponOTP').focus();
                     jQuery('#txtUniqueID').val($responseData.response);
                     //  jQuery('#btnCouponOTP').hide();
                     // jQuery('#btnCouponOTPResend').show();
                     jQuery('#txtCouponNo').prop('readonly', true);
                 }
                 else {
                     toast('Error', $responseData.response);
                 }
             });
         }
         $resendCouponOTP = function () {
             serverCall("HomeCollection.aspx/resendOTPCoupan", { CouponNo: jQuery('#txtCouponNo').val(), mobileno: jQuery('#txtMobileNo').val(), PatientName: jQuery('#txtPName').val(), uniqueid: jQuery('#txtUniqueID').val() }, function (response) {
                 var $responseData = JSON.parse(response);
                 if ($responseData.status) {
                     toast('Success', "OTP Resend To Mobile No");
                     jQuery('#txtCouponOTP').focus();
                     // jQuery('#btnCouponOTP').hide();
                     // jQuery('#btnCouponOTPResend').show();
                     jQuery('#txtCouponNo').prop('readonly', true);
                 }
                 else {
                     toast('Error', $responseData.response);
                 }
             });

         }
         $validateCoupon = function () {
             if (Number(jQuery('#spnTotalDiscountAmount').text() > 0)) {
                 toast('Error', "Please Remove Discount Before Apply Coupon");
                 return;
             }

             //if (jQuery('#txtPName').val() == "") {
             //    jQuery('#txtPName').focus();
             //    toast('Error', "Please Enter Patient Name");
             //    return;
             //}
             var count = jQuery('#tb_ItemList tr').length;
             if (count == 0 || count == 1) {
                 toast('Error', "Please Select Test To Apply Coupon");
                 jQuery('#ddlInvestigation').focus();
                 jQuery('#txtCouponNo').val('');
                 return false;
             }

             if (Number(jQuery('#spnTotalDiscountAmount').text() > 0)) {
                 toast('Error', "Please Remove Discount Before Apply Coupon");
                 return;
             }
             if (jQuery('#txtCouponNo').val() == "") {
                 jQuery('#txtCouponNo').focus();
                 toast('Error', "Please Enter Coupon No.");
                 return;
             }
             //if (jQuery('#txtMobileNo').val() == "") {
             //    jQuery('#txtMobileNo').focus();
             //    toast('Error', "Please Enter Mobile No to Get OTP");
             //    return;
             //}
             //if (jQuery('#txtMobileNo').val().length != 10) {
             //    jQuery('#txtMobileNo').focus();
             //    toast('Error', "Please Enter 10 digit Mobile No to Get OTP");
             //    return;

             //}
             //if (jQuery('#txtPName').val() == "") {
             //    jQuery('#txtPName').focus();
             //    toast('Error', "Please Enter Patient Name");
             //    return;
             //}
             var count = jQuery('#tb_ItemList tr').length;
             if (count == 0 || count == 1) {
                 toast('Error', "Please Select Test To Apply Coupon");
                 jQuery('#txtInvestigationSearch').focus();
                 jQuery('#txtCouponNo').val('');
                 return false;
             }
             var subcate = "0";
             jQuery('#tb_ItemList tr').each(function () {
                 var id = jQuery(this).closest("tr").attr("id");
                 if (id != "header" && jQuery(this).closest("tr").find("#tdDiscountApplicable").html() == "0") {
                     subcate = "1";
                 }
             });
             var itemid = "";
             jQuery('#tb_ItemList tr').each(function () {
                 if (jQuery(this).closest("tr").attr("id") != "theader") {
                     itemid += jQuery(this).closest("tr").attr("id") + ",";
                 }
             });
             if (jQuery('table#tblCouponDetail').find('.' + jQuery('#txtCouponNo').val()).length > 0) {
                 jQuery('#txtCouponNo').val('');
                 toast('Error', "Coupon Already Added");
                 jQuery('#txtCouponOTP').val('');
                 jQuery('#txtUniqueID').val('');
                 return;
             }
             var tablecount = jQuery('#tblCouponDetail tr').length;
             var oldcouponID = "";
             if (Number(tablecount) > 1) {
                 jQuery('#tblCouponDetail tr').each(function () {
                     var id = jQuery(this).closest("tr").attr("id");
                     if (id != "trCoupon") {
                         oldcouponID += id + "#";
                     }
                 });
             }

             jQuery('.clDivCoupon').hide();
             jQuery('.couponspan').html('');

             serverCall("HomeCollection.aspx/ValidateCoupanGetOTP", { CouponNo: jQuery('#txtCouponNo').val(), mobileno: jQuery('#txtmobileno').html(), PatientName: '', Panelid: jQuery("#<%=ddldroplocation.ClientID%>").val().split('#')[1], uhid: '', itemid: itemid, tablecount: tablecount, bookingamt: jQuery('#amtcount').html(), oldcouponID: oldcouponID, ispackage: subcate }, function (response) {
             var $responseData = JSON.parse(response);
                 if ($responseData.status) {
                     serverCall("HomeCollection.aspx/ValidateCoupan", { CouponNo: jQuery('#txtCouponNo').val(), Panelid: jQuery("#<%=ddldroplocation.ClientID%>").val().split('#')[1], OTP: '', uniqueid: '' }, function (response) {
                         var $responseData = JSON.parse(response);
                         if ($responseData.status) {
                             CouponDetails = jQuery.parseJSON($responseData.response);
                             if (CouponDetails.length == 0) {
                                 toast('Error', "Coupon Not Found");
                                 return;
                             }
                             else {
                                 //check Expiry
                                 var expiry = new Date(CouponDetails[0].validTo + " 23:59:59");
                                 var currentdate = new Date();
                                 if (currentdate > expiry) {
                                     toast('Error', "Coupan is Expired !!");
                                     return;
                                 }
                                 //check coupon code used or not
                                 if (CouponDetails[0].LedgerTransactionNo != "") {
                                     toast('Error', "Coupon is Used for Visit No " + CouponDetails[0].LedgerTransactionNo + " !!");
                                     return;
                                 }
                                 //check used or not
                                 if (CouponDetails[0].isused == "1") {
                                     toast('Error', "Coupon is Used !!");
                                     return;
                                 }
                                 //Check Mobile
                                 if (CouponDetails[0].Issuetype == "Mobile") {
                                     if (jQuery('#txtMobileNo').val() != CouponDetails[0].Mobile) {
                                         toast('Error', "Coupon is Not Valid For This Mobile No.");
                                         return;
                                     }
                                 }
                                 //check UHID
                                 if (CouponDetails[0].Issuetype == "UHID") {
                                     if (jQuery('#txtUHIDNo').val() != CouponDetails[0].UHID) {
                                         toast('Error', "Coupan is Not Valid For This UHID No");
                                         return;
                                     }
                                 }
                                 if (Math.round(CouponDetails[0].MinBookingAmount) > 0) {
                                     if (Math.round(CouponDetails[0].MinBookingAmount) > Math.round(jQuery('#txtTotalAmount').val())) {
                                         toast('Error', "Coupan is Valid For Minimum  " + CouponDetails[0].MinBookingAmount);
                                         return;
                                     }
                                 }
                                 if (jQuery('table#tblCouponDetail').find('.' + CouponDetails[0].Coupancode).length > 0) {
                                     jQuery('#txtCouponNo').val('');
                                     toast('Error', "Coupon Already Added");
                                     jQuery('#txtCouponOTP').val('');
                                     jQuery('#txtUniqueID').val('');
                                     return;
                                 }
                                 if (jQuery('table#tblCouponDetail tr').length > 1) {
                                     if (CouponDetails[0].IsMultipleCouponApply == 0) {
                                         toast('Error', "This Coupon not Applicable With Multiple");
                                         return;
                                     }
                                     if (jQuery('#tblCouponDetail tr:last').find('#ismultiplecoupon').text() == "0") {
                                         toast('Error', "Previous Coupon not Applicable With Multiple");
                                         return;
                                     }
                                 }
                                 var subcate = "0";
                                 jQuery('#tb_ItemList tr').each(function () {
                                     var id = jQuery(this).closest("tr").attr("id");
                                     if (id != "theader" && jQuery(this).closest("tr").find("#tdDiscountApplicable").html() == "0") {
                                         subcate = "1";
                                     }
                                 });
                                 if (CouponDetails[0].Applicable == 'Total Bill' && subcate == "1") {
                                     toast('Error', "Package Not Allowed with Total Bill Coupon");
                                     return;
                                 }
                                 toast('Success', "Coupon is valid");
								   jQuery('#txtDiscountAmt,#txtDiscountPer').hide();
                                 jQuery('#txtCouponNo,#txtCouponOTP,#txtUniqueID').val('');
                                 jQuery("#spnCouponName").text(CouponDetails[0].coupanName);
                                 jQuery("#spnCouponType").text(CouponDetails[0].CoupanType);
                                 jQuery("#spnCouponCategory").text(CouponDetails[0].coupanCategory);
                                 jQuery("#spnCouponExpiry").text(CouponDetails[0].validTo);
                                 jQuery("#spnCouponMinBookingAmount").text(CouponDetails[0].MinBookingAmount);
                                 jQuery("#spnCouponIssueType").text(CouponDetails[0].Issuetype);
                                 if (CouponDetails[0].Applicable == 'Total Bill') {
                                     jQuery("#spnCouponDisc").text(CouponDetails[0].DiscountPercentage);
                                     jQuery("#spnCouponDiscAmt").text(CouponDetails[0].DiscountAmount);
                                     jQuery('#imgviewtest').hide();
                                 }
                                 else {
                                     jQuery("#spnCouponDisc,#spnCouponDiscAmt").text('0');
                                     jQuery('#imgviewtest').show();
                                 }
                                 jQuery("#spnCouponDiscFor").text(CouponDetails[0].Applicable);
                                 jQuery("#spncouponCode").text(CouponDetails[0].Coupancode);
                                 jQuery("#spnCouponID").text(CouponDetails[0].CoupanId);
                                 jQuery('#txtInvestigationSearch').prop('readonly', true);
                                 //jQuery('#btnCouponOTP').show();
                                 jQuery('#txtCouponNo').prop('readonly', false);
                                 jQuery(".deletemydata,.btnInvestigationDelete,#btnCouponOTPResend").hide();
                                 var total1 = 0;
                                 jQuery('#tb_ItemList tr').each(function () {
                                     var id = jQuery(this).closest("tr").attr("id");
                                     if (id != "theader" && jQuery(this).closest("tr").find("#tdDiscountApplicable").html() != "0") {
                                         total1 = Number(total1) + Number(jQuery(this).closest("tr").find("#txtnetamt").val());
                                        // alert(jQuery(this).closest("tr").find("#txtnetamt").val());
                                     }
                                 });
                                 var totalco = parseInt(jQuery('#txtCouponAmt').val());
                                 if (isNaN(totalco))
                                     totalco = 0;
                                 var total = Number(total1) - Number(totalco);
                                 var couponamt = 0;
                                 var totalCouponAmt = 0;
                                 if (jQuery('#spnCouponDiscFor').text() == "Total Bill") {
                                     if (jQuery("#spnCouponDisc").text() != "0" && jQuery("#spnCouponDisc").text() != "") {
                                         couponamt = total * jQuery("#spnCouponDisc").text() * 0.01;
                                         totalCouponAmt = Math.round(couponamt) + Math.round(totalco);
                                     }
                                     if (jQuery("#spnCouponDiscAmt").text() != "0" && jQuery("#spnCouponDiscAmt").text() != "") {
                                         couponamt = Math.round(jQuery("#spnCouponDiscAmt").text());
                                         if (Math.round(couponamt) >= Math.round(total)) {
                                             couponamt = total;
                                         }
                                         totalCouponAmt = Math.round(couponamt) + Math.round(totalco);
                                     }

                                     jQuery('#txtCouponAmt').val(totalCouponAmt);
                                     var $totalPaidAmount = 0;
                                     jQuery('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
                                     var $netAmount = jQuery('#amtcount').html(); //(jQuery('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtPayByPatientFinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));
                                     jQuery('#txtPaidAmount').val(precise_round($totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                                    jQuery('#txtBlanceAmount').val(precise_round(($netAmount - ($totalPaidAmount) - Number(jQuery('#txtAppAmount').val()) - Number(jQuery('#txtCouponAmt').val())), '<%=Resources.Resource.BaseCurrencyRound%>'));
                                   //  jQuery('#lbdisamt').val(precise_round(($netAmount - ($totalPaidAmount) - Number(jQuery('#txtAppAmount').val()) - Number(jQuery('#txtCouponAmt').val())), '<%=Resources.Resource.BaseCurrencyRound%>'));
                                     var totaldiscount =Number(jQuery('#txtCouponAmt').val());
                                     $('#<%=lbdisamt.ClientID%>').text(totaldiscount);
                                     $('#txtTotalAmount').val($netAmount - totaldiscount);
                                  //  $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });
                                    serverCall('HomeCollection.aspx/getCouponAmt', { couponAmt: parseFloat(couponamt).toFixed(0) }, function (responseCouponAmt) {
                                        var $Tr = [];
                                        $Tr.push("<tr style='background-color:bisque;' id='"); $Tr.push(CouponDetails[0].CoupanId); $Tr.push("' class='"); $Tr.push(CouponDetails[0].Coupancode); $Tr.push("' >");
                                        $Tr.push('<td class="GridViewLabItemStyle" id="tdCoupanCode">'); $Tr.push(CouponDetails[0].Coupancode); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" id="tdCoupanName">'); $Tr.push(CouponDetails[0].coupanName); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[0].CoupanType); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[0].coupanCategory); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[0].validTo); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" style="text:align:right">'); $Tr.push(CouponDetails[0].MinBookingAmount); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[0].Applicable); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(CouponDetails[0].DiscountPercentage); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(CouponDetails[0].DiscountAmount); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(parseFloat(couponamt).toFixed(0)); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdCouponAmt">'); $Tr.push(responseCouponAmt); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" id="tdCouponType" style="display:none;">'); $Tr.push(CouponDetails[0].CouponType); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="ismultiplecoupon">'); $Tr.push(CouponDetails[0].IsMultipleCouponApply); $Tr.push('</td>');
                                        $Tr.push('<td class="GridViewLabItemStyle" ></td>');
                                        $Tr.push("</tr>");
                                        $Tr = $Tr.join("");
                                        jQuery('#tblCouponDetail').append($Tr);
                                        jQuery('#tblCouponDetail').show();
                                    }, '', false);
                                }
                                else {
                                    var dataIm = new Array();
                                    jQuery('#tb_ItemList tr').each(function () {
                                        var id = jQuery(this).closest("tr").attr("id");
                                        if (id != "theader") {
                                            var mydata = new Array();
                                            mydata[0] = jQuery(this).closest("tr").attr("id");
                                            mydata[1] = jQuery(this).closest("tr").find("#txtnetamt").val();
                                            mydata[2] = jQuery("#spnCouponID").text();
                                            dataIm.push(mydata);
                                        }
                                    });
                                    serverCall('HomeCollection.aspx/getcouponitemdisc', { dataIm: dataIm }, function (response) {
                                        var $responseData = JSON.parse(response);
                                        if ($responseData.status) {
                                            if ($responseData.response == "0") {
                                                toast('Error', "Coupan is Not Valid For These Items");
                                            }
                                            else {
                                                var TotalCouponData = ($responseData.response);
                                                var couponamt = parseFloat(TotalCouponData.split('#')[0]).toFixed(0);
                                                if (Math.round(couponamt) >= Math.round(total)) {
                                                    couponamt = parseFloat(total).toFixed(0);
                                                }
                                                totalCouponAmt = Math.round(couponamt) + Math.round(totalco);

                                                jQuery('#txtCouponAmt').val(totalCouponAmt);

                                                var $totalPaidAmount = 0;
                                                jQuery('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
                                              //  var $netAmount = (jQuery('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtPayByPatientFinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));
                                                var $netAmount = jQuery('#amtcount').html();
                                                jQuery('#txtPaidAmount').val(precise_round($totalPaidAmount, '<%=Resources.Resource.BaseCurrencyRound%>'));
                                                jQuery('#txtBlanceAmount').val(precise_round(($netAmount - ($totalPaidAmount) - Number(jQuery('#txtAppAmount').val()) - Number(jQuery('#txtCouponAmt').val())), '<%=Resources.Resource.BaseCurrencyRound%>'));

                                                var totaldiscount = Number(jQuery('#txtCouponAmt').val());
                                                $('#<%=lbdisamt.ClientID%>').text(totaldiscount);
                                                 $('#txtTotalAmount').val($netAmount - totaldiscount);
                                              //  $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });

                                                serverCall('HomeCollection.aspx/getCouponAmt', { couponAmt: couponamt }, function (responseCouponAmt) {
                                                    var $Tr = [];
                                                    $Tr.push("<tr style='background-color:bisque;' id='"); $Tr.push(CouponDetails[0].CoupanId); $Tr.push("' class='"); $Tr.push(CouponDetails[0].Coupancode); $Tr.push("' >");
                                                    $Tr.push('<td class="GridViewLabItemStyle" id="tdCoupanCode">'); $Tr.push(CouponDetails[0].Coupancode); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" id="tdCoupanName">'); $Tr.push(CouponDetails[0].coupanName); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[0].CoupanType); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[0].coupanCategory); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[0].validTo); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(CouponDetails[0].MinBookingAmount); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle">'); $Tr.push(CouponDetails[0].Applicable); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">0</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">0</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" style="text-align:right">'); $Tr.push(couponamt); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" id="tditem" style="display:none;">'); $Tr.push(TotalCouponData); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" style="display:none;" id="tdCouponAmt">'); $Tr.push(responseCouponAmt); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" id="tdCouponType" style="display:none;">'); $Tr.push(CouponDetails[0].CouponType); $Tr.push('</td>');
                                                    $Tr.push('<td class="GridViewLabItemStyle" ><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="viewitemlist(this)"/></td>');
                                                    $Tr.push("</tr>");
                                                    $Tr = $Tr.join("");
                                                    jQuery('#tblCouponDetail').append($Tr);
                                                    jQuery('#tblCouponDetail').show();
                                                }, '', false);
                                            }
                                        }
                                        else {
                                            toast('Error', $responseData.response);
                                        }
                                    });
                                }

                            }
                        }
                        else {
                            toast('Error', $responseData.response);

                        }
                    });
                }
                else {
                    toast('Error', $responseData.response);
                }
            });


        }
        $cancelCoupon = function () {
            $clearCouponData();
        }
        $clearCouponData = function () {
		 jQuery('#txtDiscountAmt,#txtDiscountPer').show();
            jQuery('#tblCouponDetail tr').slice(1).remove();
            jQuery('#tblCouponDetail,.clDivCoupon,#imgviewtest,#btnCouponOTPResend').hide();
            jQuery('#txtCouponNo,#txtCouponOTP,#txtUniqueID').val('');
           
            jQuery('.couponspan').html('');
            jQuery('#txtCouponNo').prop('readonly', false);
            jQuery('#txtInvestigationSearch').prop('readonly', false);
            jQuery(".deletemydata").show();//,#btnCouponOTP
            jQuery('#txtCouponNo').prop('readonly', false);

            jQuery('#txtCouponAmt').val(0);
            var $netAmount =jQuery('#amtcount').html();  //(jQuery('#ddlPanel').val().split('#')[20] == "1" ? parseFloat(jQuery('#txtPayByPatientFinal').val()) : parseFloat(jQuery('#txtNetAmount').val()));
                  var totaldiscount =Number(jQuery('#txtCouponAmt').val());
                                     $('#<%=lbdisamt.ClientID%>').text(totaldiscount);
			jQuery('#txtBlanceAmount').val($netAmount);
			 jQuery('#txtTotalAmount').val($netAmount);
            $showConversionAmt("add", jQuery("#ddlCurrency"), function () { });
            jQuery('.btnInvestigationDelete').show();
            // var couponIDRow = parseInt(<%=Resources.Resource.BaseCurrencyID%>) + parseInt(15);
            // jQuery('#divPaymentDetails').find('#' + couponIDRow).remove();
            // jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=15]').next().remove();
            // jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=15]').remove();

        }
         function viewitemlist(ctrl) {
             serverCall('HomeCollection.aspx/bindtestmodal', { CouponID: jQuery(ctrl).closest('tr').attr('id') }, function (response) {
                 var $responseData = JSON.parse(response);
                 if ($responseData.status) {
                     if (jQuery.parseJSON($responseData.response).length == 0) {
                         toast('Error', "No test Found");
                     }
                     else {
                         jQuery('#tblCouponTest tr').slice(1).remove();
                         var ItemData = jQuery.parseJSON($responseData.response);
                         var itemwisedata = jQuery(ctrl).closest('tr').find('#tditem').text().split('#');
                         for (var i = 0; i <= ItemData.length - 1; i++) {
                             var $Tr = [];
                             $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                             $Tr.push('<td  id="mtest" align="left">'); $Tr.push(ItemData[i].typename); $Tr.push('</td>');
                             $Tr.push('<td  id="mtestdisper">'); $Tr.push(ItemData[i].discper); $Tr.push('</td>');
                             $Tr.push('<td  id="mtestdisamt">'); $Tr.push(ItemData[i].discamount); $Tr.push('</td>');
                             var isapp = "";
                             for (var j = 1; j < itemwisedata.length; j++) {
                                 if ((itemwisedata[j].split('^')[0] == ItemData[i].itemId)) {
                                     $Tr.push('<td  id="mtestdisamt">'); $Tr.push(itemwisedata[j].split('^')[1]); $Tr.push('</td>');
                                     isapp = "1";
                                 }
                             }
                             if (isapp == "") {
                                 $Tr.push('<td  id="mtestdisamt">0</td>');
                             }
                             $Tr.push('</tr>');
                             $Tr = $Tr.join("");
                             jQuery('#tblCouponTest').append($Tr);
                         }
                         jQuery("#divCouponItemDetail").showModel();
                     }
                 }
                 else {
                     toast('Error', $responseData.response);
                 }
             });

         }
         $closeCouponItemDetail = function () {
             jQuery('#tblCouponTest tr').slice(1).remove();
             jQuery("#divCouponItemDetail").hideModel();
         }



         $showConversionAmt = function (con, elem, callback) {
             if (con == "remove")
                 jQuery("#ddlCurrency").val('<%= Resources.Resource.BaseCurrencyID%>');
                     var _temp = [];
                     var blanceAmount = jQuery("#txtBlanceAmount").val();
                     var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
                     _temp = [];
                     _temp.push(serverCall('../Common/Services/CommonServices.asmx/getConvertCurrecncy', { countryID: 14, Amount: $blanceAmount }, function (CurrencyData) {
                         jQuery.when.apply(null, _temp).done(function () {
                             var $convertedCurrencyData = JSON.parse(CurrencyData);
                             jQuery('#spnCFactor').text($convertedCurrencyData.ConversionFactor);
                             jQuery('#spnConversion_ID').text($convertedCurrencyData.Converson_ID);
                             jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round($convertedCurrencyData.ConversionFactor, jQuery("#ddlCurrency option:selected").data("value").Round), ' ', jQuery('#spnBaseNotation').text()));
                             jQuery('#spnBlanceAmount').text("".concat($convertedCurrencyData.BaseCurrencyAmount, ' ', jQuery('#ddlCurrency option:selected').text()));

                             if (jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=4]').length == 0) {
                                 jQuery('input[type=checkbox][name=paymentMode]').prop('checked', false);
                                 var selectedPaymentModeOnCurrency = jQuery('#divPaymentDetails').find('.' + jQuery("#ddlCurrency").val());
                                 jQuery(selectedPaymentModeOnCurrency).each(function (index, elem) {
                                     jQuery('#divPaymentMode').find('input[type=checkbox][name=paymentMode][value=' + jQuery(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', 'checked');
                                 });

                             }
                             if (con == "remove") {
                                 if (jQuery('#tb_ItemList').find('tr:not(#theader)').length == 0) {
                                     jQuery('#tblPaymentDetail tr').slice(1).remove();
                                     $getPaymentMode("1", function () { });
                                     jQuery('#txtCurrencyRound').val('0');
                                 }
                             }
                             callback(true);
                         })
                     }));

                 };


    </script>


</body>
</html>
