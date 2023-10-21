<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SMSConfigurationMasterNew.aspx.cs" Inherits="Design_Master_SMSConfigurationMasterNew" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>SMS Configuration Master</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory " style="text-align: center">
            <div class="row  ">
                <div class="col-md-1 GridViewHeaderStyle">
                    S.No.
                </div>
                <div class="col-md-4 GridViewHeaderStyle">
                    Module
                </div>
                <div class="col-md-4 GridViewHeaderStyle">
                    Screen
                </div>
                <div class="col-md-2 GridViewHeaderStyle">
                    SMSTrigger
                </div>
                <div class="col-md-4 GridViewHeaderStyle">
                    ToWhom
                </div>
                <div class="col-md-3 GridViewHeaderStyle">
                    TagType
                </div>
                <div class="col-md-1 GridViewHeaderStyle">
                    Client
                </div>
                <div class="col-md-3 GridViewHeaderStyle">
                    SMSType
                </div>
                <div class="col-md-1 GridViewHeaderStyle">
                    Active
                </div>
                <div class="col-md-1 GridViewHeaderStyle">
                    View
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    1.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_1">Radiology Appointment</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_1">New Appointment</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_1" runat="server" onclick="$activeDeactiveToWhom($(this),1,'Patient')" />Patient
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_1" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),1)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_1" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,1)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    New Appointment
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_1" runat="server" onclick="$activeDeactiveSMS($(this),1)" />
                </div>
                <div class="col-md-1">
                    <img id="imgView_1" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,1)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    2.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_2">Radiology Appointment</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_2">Appointment Cancel</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_2" runat="server" onclick="$activeDeactiveToWhom($(this),2,'Patient')" />Patient
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_2" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),2)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_2" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,2)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    App Cancel
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_2" runat="server" onclick="$activeDeactiveSMS($(this),2)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_2" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,2)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    3.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_3">Radiology Appointment</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_3">ReShcedule Appointment</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_3" runat="server" onclick="$activeDeactiveToWhom($(this),3,'Patient')" />Patient
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_3" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),3)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_3" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,3)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    App ReShcedule
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_3" runat="server" onclick="$activeDeactiveSMS($(this),3)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_3" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,3)" />
                </div>
            </div>


            <div class="row">
                <div class="col-md-1 ">
                    4.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_4">Home Collection</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_4">Home Collection</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_4" runat="server" onclick="$activeDeactiveToWhom($(this),4,'Patient')" />Patient
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_4" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),4)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_4" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,4)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Home Collectio
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_4" runat="server" onclick="$activeDeactiveSMS($(this),4)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_4" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,4)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    5.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_5">OPD Consultation</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_5">OPD Booking</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_5" runat="server" onclick="$activeDeactiveToWhom($(this),5,'Patient')" />Patient
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_5" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),5)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_5" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,5)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    OPD Booking
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_5" runat="server" onclick="$activeDeactiveSMS($(this),5)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_5" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,5)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    6.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_6">Front Office</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_6">Registration</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_6" runat="server" onclick="$activeDeactiveToWhom($(this),6,'Patient')" />Patient<asp:CheckBox ID="chkClient_6" runat="server" onclick="$activeDeactiveToWhom($(this),6,'Client')" />Client
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_6" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),6)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_6" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,6)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Welcome SMS
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_6" runat="server" onclick="$activeDeactiveSMS($(this),6)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_6" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,6)" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-1 ">
                    7.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_7">Front Office</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_7">Registration</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkEmployee_7" runat="server" onclick="$activeDeactiveToWhom($(this),7,'Employee')" />Employee
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_7" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),7)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_7" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,7)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Cash O/S SMS
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_7" runat="server" onclick="$activeDeactiveSMS($(this),7)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_7" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,7)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    8.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_8">Front Office</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_8">Discount</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkEmployee_8" runat="server" onclick="$activeDeactiveToWhom($(this),8,'Employee')" />Employee
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_8" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),8)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_8" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,8)" />
                </div>

               <div class="col-md-3" style="text-align: left">
                    Discount Approval SMS
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_8" runat="server" onclick="$activeDeactiveSMS($(this),8)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_8" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,8)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    9.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_9">Front Office</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_9">Payment Collection</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_9" runat="server" onclick="$activeDeactiveToWhom($(this),9,'Patient')" />Patient
                </div>
                <div class="col-md-3" style="text-align: left">

                    <asp:ListBox ID="lstTagType_9" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),9)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_9" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,9)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Payment Collection SMS
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_9" runat="server" onclick="$activeDeactiveSMS($(this),9)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_9" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,9)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    10.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_10">Front Office</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_10">Payment Collection - Refund</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_10" runat="server" onclick="$activeDeactiveToWhom($(this),10,'Patient')" />Patient
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_10" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),10)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_10" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,10)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Refund SMS
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_10" runat="server" onclick="$activeDeactiveSMS($(this),10)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_10" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,10)" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1 ">
                    11.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_11">Front Office</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_11">Tiny SMS</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_11" runat="server" onclick="$activeDeactiveToWhom($(this),11,'Patient')" />Patient<asp:CheckBox ID="chkClient_11" runat="server" onclick="$activeDeactiveToWhom($(this),11,'Client')" />Client<%--<asp:CheckBox ID="chkDoctor_11" runat="server" onclick="$activeDeactiveToWhom($(this),11,'Doctor')" />Doctor--%>
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_11" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),11)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_11" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,11)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Tiny SMS Bill
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_11" runat="server" onclick="$activeDeactiveSMS($(this),11)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_11" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,11)" />
                </div>
            </div>



                        <div class="row">
                <div class="col-md-1 ">
                    12.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_12">Front Office</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_12">Tiny SMS</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_12" runat="server" onclick="$activeDeactiveToWhom($(this),12,'Patient')" />Patient<asp:CheckBox ID="chkClient_12" runat="server" onclick="$activeDeactiveToWhom($(this),12,'Client')" />Client<asp:CheckBox ID="chkDoctor_12" runat="server" onclick="$activeDeactiveToWhom($(this),12,'Doctor')" />Doctor
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_12" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),12)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_12" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,12)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Tiny SMS Lab Report
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_12" runat="server" onclick="$activeDeactiveSMS($(this),12)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_12" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,12)" />
                </div>
            </div>


                        <div class="row">
                <div class="col-md-1 ">
                    13.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_13">Laboratory</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_13">Approval SMS</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_13" runat="server" onclick="$activeDeactiveToWhom($(this),13,'Patient')" />Patient<%--<asp:CheckBox ID="chkClient_13" runat="server" onclick="$activeDeactiveToWhom($(this),13,'Client')" />Client<asp:CheckBox ID="chkDoctor_13" runat="server" onclick="$activeDeactiveToWhom($(this),13,'Doctor')" />Doctor--%>
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_13" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),13)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_13" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,13)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Online Website SMS
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_13" runat="server" onclick="$activeDeactiveSMS($(this),13)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_13" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,13)" />
                </div>
            </div>


                        <div class="row">
                <div class="col-md-1 ">
                    14.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnModule_14">Sample Management</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="spnScreen_14">Sample Rejection</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_14" runat="server" onclick="$activeDeactiveToWhom($(this),14,'Patient')" />Patient<asp:CheckBox ID="chkClient_14" runat="server" onclick="$activeDeactiveToWhom($(this),14,'Client')" />Client<asp:CheckBox ID="chkDoctor_14" runat="server" onclick="$activeDeactiveToWhom($(this),14,'Doctor')" />Doctor
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_14" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),14)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_14" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,14)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Sample Rejection
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_14" runat="server" onclick="$activeDeactiveSMS($(this),14)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_14" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,14)" />
                </div>
            </div>
             <div class="row">
                <div class="col-md-1 ">
                    15.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span1">Sample Management</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span2">Critical</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <%--<asp:CheckBox ID="chkPatient_15" runat="server" onclick="$activeDeactiveToWhom($(this),14,'Patient')" />Patient--%><asp:CheckBox ID="chkClient_15" runat="server" onclick="$activeDeactiveToWhom($(this),15,'Client')" />Client<asp:CheckBox ID="chkDoctor_15" runat="server" onclick="$activeDeactiveToWhom($(this),15,'Doctor')" />Doctor
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_15" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),15)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_15" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,15)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    Critical value
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_15" runat="server" onclick="$activeDeactiveSMS($(this),15)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_15" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,15)" />
                </div>
            </div>
             <div class="row">
                <div class="col-md-1 ">
                    16.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span3">Sample Management</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span4">TAT Delay ( manual )</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Manual
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkPatient_16" runat="server" onclick="$activeDeactiveToWhom($(this),16,'Patient')" />Patient<asp:CheckBox ID="chkClient_16" runat="server" onclick="$activeDeactiveToWhom($(this),16,'Client')" />Client<asp:CheckBox ID="chkDoctor_16" runat="server" onclick="$activeDeactiveToWhom($(this),16,'Doctor')" />Doctor
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_16" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),16)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_16" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,16)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                    TAT Delay
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_16" runat="server" onclick="$activeDeactiveSMS($(this),16)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_16" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,16)" />
                </div>
            </div>
             <div class="row">
                <div class="col-md-1 ">
                    17.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span5">Invoicing</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span6">Payment Approval</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkClient_17" runat="server" onclick="$activeDeactiveToWhom($(this),17,'Client')" />Client
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_17" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),17)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_17" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,17)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                   Payment Approval
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_17" runat="server" onclick="$activeDeactiveSMS($(this),16)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_17" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,17)" />
                </div>
            </div>
              <div class="row">
                <div class="col-md-1 ">
                    18.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span7">Invoicing</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span8">Payment Rejection</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkClient_18" runat="server" onclick="$activeDeactiveToWhom($(this),18,'Client')" />Client
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_18" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),18)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_18" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,18)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                   Payment Rejection
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_18" runat="server" onclick="$activeDeactiveSMS($(this),16)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_18" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,18)" />
                </div>
            </div>
             <div class="row">
                <div class="col-md-1 ">
                    19.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span9">Invoicing</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span10">Credit limit exceed</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkClient_19" runat="server" onclick="$activeDeactiveToWhom($(this),19,'Client')" />Client
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_19" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),19)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_19" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,19)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                  Credit limit exceed
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_19" runat="server" onclick="$activeDeactiveSMS($(this),19)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_19" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,19)" />
                </div>
            </div>
             <div class="row">
                <div class="col-md-1 ">
                    20.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span11">Invoicing</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span12">Invoice generation SMS</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkClient_20" runat="server" onclick="$activeDeactiveToWhom($(this),20,'Client')" />Client
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_20" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),20)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_20" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,20)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                  Invoice generation SMS
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_20" runat="server" onclick="$activeDeactiveSMS($(this),20)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_20" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,20)" />
                </div>
            </div>
             <div class="row">
                <div class="col-md-1 ">
                    21.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span13">Invoicing</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span14">Bulk settlement</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Realtime
                </div>
                <div class="col-md-4" style="text-align: left">
                    <asp:CheckBox ID="chkClient_21" runat="server" onclick="$activeDeactiveToWhom($(this),21,'Client')" />Client
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_21" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),21)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="imgClient_21" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,21)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                 Bulk settlement
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_21" runat="server" onclick="$activeDeactiveSMS($(this),21)"/>
                </div>
                <div class="col-md-1">
                    <img id="imgView_21" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,21)" />
                </div>
            </div>           
            <div class="row">
                <div class="col-md-1 ">
                    22.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span16">Sample Management</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span17">Daily Collection</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-2" style="text-align: left">  <asp:CheckBox ID="chkClient_22" runat="server" onclick="$activeDeactiveToWhom($(this),22,'Employee')" />Employee</div>
                     <div class="col-md-2" style="text-align: left">
                   <asp:TextBox ID="chkClient_22_date" runat="server" />
                     <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="chkClient_22_date" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
               
                <div class="col-md-3" style="text-align:left">
                   
                <asp:TextBox ID="emp_cntct" runat="server" placeholder="Phone No" MaxLength="10" />
                   
                  <%--  <asp:ListBox ID="lstTagType_22" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),22)"></asp:ListBox>--%>
                </div>
                <div class="col-md-1">
                    <%--<img id="img1" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,22)" />--%>
                </div>
                <div class="col-md-3" style="text-align: left">
                 Daily Collection
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_22" runat="server" onclick="$activeDeactiveSMS($(this),22)"/>
                </div>
                <div class="col-md-1">
                    <img id="img2" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,22)" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-1 ">
                    23.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span15">Sample Management</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span18">Client Daily Business</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-2" style="text-align: left">
                    <asp:CheckBox ID="chkClient_23" runat="server" onclick="$activeDeactiveToWhom($(this),23,'Client')" />Client
                </div>
                <div class="col-md-2" style="text-align:left">
                    <asp:TextBox ID="chkClient_23_date" runat="server" />
                     <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="chkClient_23_date" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3" style="text-align: left">
                    <asp:ListBox ID="lstTagType_23" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),23)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="img3" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,23)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                 Client Daily Business
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="chkActive_23" runat="server" onclick="$activeDeactiveSMS($(this),23)"/>
                </div>
                <div class="col-md-1">
                    <img id="img4" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,23)" />
                </div>
            </div>
              <div class="row">
                <div class="col-md-1 ">
                    24.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span19">Result Entry</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span20">Report Approval</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-4" style="text-align: left">  <asp:CheckBox ID="chkPatient_24" runat="server" onclick="$activeDeactiveToWhom($(this),24,'Patient')" />Patient</div>
                
               
                <div class="col-md-3" style="text-align:left">
                   
                   
                    <asp:ListBox ID="lstTagType_24" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),24)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="img5" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,24)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                 Report Approval
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="CheckBox2" runat="server" onclick="$activeDeactiveSMS($(this),24)"/>
                </div>
                <div class="col-md-1">
                    <img id="img6" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,24)" />
                </div>
            </div>
             <div class="row">
                <div class="col-md-1 ">
                    25.
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span21">Result Entry</span>
                </div>
                <div class="col-md-4" style="text-align: left">
                    <span id="Span22">Report Approval Within TAT</span>
                </div>
                <div class="col-md-2" style="text-align: left">
                    Schedule
                </div>
                <div class="col-md-4" style="text-align: left">  <asp:CheckBox ID="chkPatient_25" runat="server" onclick="$activeDeactiveToWhom($(this),25,'Patient')" />Patient</div>
                     
               
                <div class="col-md-3" style="text-align:left">
                   
                   
                    <asp:ListBox ID="lstTagType_25" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="$saveTagType($(this).val().toString(),25)"></asp:ListBox>
                </div>
                <div class="col-md-1">
                    <img id="img1" alt="View" src="../../App_Images/edit.png" style="cursor: pointer" onclick="$addClient(this,25)" />
                </div>
                <div class="col-md-3" style="text-align: left">
                 Report Approval Within TAT
                </div>
                <div class="col-md-1">
                    <asp:CheckBox ID="CheckBox3" runat="server" onclick="$activeDeactiveSMS($(this),25)"/>
                </div>
                <div class="col-md-1">
                    <img id="img7" alt="View" src="../../App_Images/View.gif" style="cursor: pointer" onclick="$view(this,25)" />
                </div>
            </div>
        </div>
    </div>

    <div id="divSmsView" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 50%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-16" style="text-align: left">
                            <h4 class="modal-title">SMS View</h4>
                        </div>
                        <div class="col-md-8" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeSMSView()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Template</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:TextBox ID="txtTemplate" runat="server" CssClass="requiredField" TextMode="MultiLine" Width="500px" Height="60px"></asp:TextBox>
                            <span id="spnSMSID" style="display: none"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Active Columns</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <span id="spnActiveColumns"></span>
                        </div>
                    </div>
                    <div class="row" style="display: none" id="divSQL">
                        <div class="col-md-5">
                            <label class="pull-left">SQL Query</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:TextBox ID="txtSQLQuery" runat="server" CssClass="requiredField" TextMode="MultiLine" Width="500px" Height="60px"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <input type="button" id="btnPopUpSave" value="Save" onclick="$saveSMSTemp()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div id="divClient" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 50%;">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-16" style="text-align: left">
                            <h4 class="modal-title">Client View</h4>
                        </div>
                        <div class="col-md-8" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeClientiew()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left"><b>Module</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnModule"></span>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"><b>Screen</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnScreen"></span>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">TagClient</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:DropDownList ID="ddlTagClient" runat="server" class="ddlTagClient chosen-select chosen-container" onchange="$bindClient()"></asp:DropDownList>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left"><span id="spnSaveType"></span>Client</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <asp:ListBox ID="lstClient" CssClass="multiselect " SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>

                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <input type="button" id="btnClient" value="Save" onclick="$saveClient()" />
                        </div>
                    </div>
                    <div class="Purchaseheader divShow" style="display: none"><span id="spnType"></span></div>
                   
                    <div class="row divShow" style="display: none">
                        <div class="col-md-24" style="width: 100%; max-height: 250px; overflow: auto;">
                            <table id="tblSMSClientList" rules="all" border="1" style="border-collapse: collapse;" class="GridViewStyle">
                                <thead>
                                    <tr id="Header">
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 30px">S.No.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px">
                                            <input type="checkbox" class="chlAll" onclick="$selectAll(this)" /></th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 620px">Client</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row divShow" style="text-align: center; display: none">
                        <div class="col-md-24">
                            <input type="button" id="btnRemove" value="Remove Discard" onclick="$removeDiscard()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $selectAll = function (rowID) {
            if ($(rowID).is(':checked')) 
                $(".chkInd").prop('checked', 'checked');
            else 
                $(".chkInd").prop('checked', false);
        }
        $closeSMSView = function () {
            jQuery('#divSmsView').hideModel();
        }
        $closeClientiew = function () {
            jQuery('#divClient').closeModel();
        }
        $bindModule = function () {
            serverCall('SMSConfigurationMasterNew.aspx/bindModule', {}, function (response) {
                var $SMSConfig = JSON.parse(response);
                if ($SMSConfig.status) {
                    var $SMSClient = jQuery.parseJSON($SMSConfig.ActiveSMSClient);
                    $SMSConfig = jQuery.parseJSON($SMSConfig.response);
                    for (var i = 0; i < $SMSConfig.length ; i++) {
                        var $SMSClientResponse = jQuery.grep($SMSClient, function (value) {
                            return value.SmsConfigurationID == $SMSConfig[i].ID;
                        });
                        if ($SMSClientResponse.length > 0) {
                            for (var k = 0; k < $SMSClientResponse.length; k++) {
                                $('#lstTagType_' + $SMSConfig[i].ID).find(":checkbox[value='" + $SMSClientResponse[k].type1ID + "']").attr("checked", "checked");                               
                                $("[id*=lstTagType_" + $SMSConfig[i].ID + "] option[value='" + $SMSClientResponse[k].type1ID + "']").attr("selected", 1);                              
                                $('#lstTagType_' + $SMSConfig[i].ID).multipleSelect("refresh");
                            }
                        }
                        if ($SMSConfig[i].IsActive == "1")
                            jQuery('#chkActive_' + $SMSConfig[i].ID).prop('checked', 'checked');
                        else
                            jQuery('#chkActive_' + $SMSConfig[i].ID).prop('checked', false);

                        if ($SMSConfig[i].ID == "1") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "2") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "3") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "4") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "5") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }

                        else if ($SMSConfig[i].ID == "6") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);

                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "7") {
                            if ($SMSConfig[i].IsEmployee == "1")
                                jQuery('#chkEmployee_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkEmployee_' + $SMSConfig[i].ID).prop('checked', false);
                        }

                        else if ($SMSConfig[i].ID == "8") {
                            if ($SMSConfig[i].IsEmployee == "1")
                                jQuery('#chkEmployee_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkEmployee_' + $SMSConfig[i].ID).prop('checked', false);
                        }

                        else if ($SMSConfig[i].ID == "9") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }

                        else if ($SMSConfig[i].ID == "10") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }

                        else if ($SMSConfig[i].ID == "11") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                            if ($SMSConfig[i].IsEmployee == "1")
                                jQuery('#chkEmployee_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkEmployee_' + $SMSConfig[i].ID).prop('checked', false);
                        }

                        else if ($SMSConfig[i].ID == "12") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                            if ($SMSConfig[i].IsDoctor == "1")
                                jQuery('#chkDoctor_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkDoctor_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "13") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "14") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                            if ($SMSConfig[i].IsDoctor == "1")
                                jQuery('#chkDoctor_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkDoctor_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "15") {
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                            if ($SMSConfig[i].IsDoctor == "1")
                                jQuery('#chkDoctor_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkDoctor_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "16") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                            if ($SMSConfig[i].IsDoctor == "1")
                                jQuery('#chkDoctor_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkDoctor_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "17") {
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "18") {
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "19") {
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "20") {
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "21") {
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "22") {
                            if ($SMSConfig[i].IsEmployee == "1") {
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                                jQuery('#emp_cntct').val($SMSConfig[i].Phone);
                            }
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "23") {
                            if ($SMSConfig[i].IsClient == "1")
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkClient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "24") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                        else if ($SMSConfig[i].ID == "25") {
                            if ($SMSConfig[i].IsPatient == "1")
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', 'checked');
                            else
                                jQuery('#chkPatient_' + $SMSConfig[i].ID).prop('checked', false);
                        }
                    }
                }
            })
        };
        $(function () {
            if ('<%=UserInfo.ID%>' == "1") {
                $('#divSQL').show();
            }
            else {
                $('#divSQL').hide();
            }
            $bindModule();
            for (var i = 1; i <= 25; i++) {
                $("#lstTagType_" + i).multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            }
                     
        $('[id*=lstClient]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
        
        });
    </script>
    <script type="text/javascript">
        $(document).keypress(function (e) {
            if (e.keyCode === 27) {
                alert('1');
            }
        });
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                alert('1');
                if (jQuery('#divSmsView').is(':visible')) {
                    alert('1');
                    $closeSMSView();
                }


            }
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        $saveTagType = function (TagType, SmsConfigurationID) {
            serverCall('SMSConfigurationMasterNew.aspx/saveTagType', { TagTypeID: TagType, SmsConfigurationID: SmsConfigurationID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response, '');
                }
                else {
                    toast('Error', $responseData.response, '');
                }
            });
        }
        $activeDeactiveSMS = function (chkvalue, SmsConfigurationID) {
            var msg = "DeActivate"; var Active = 0;
            if ($(chkvalue).is(':checked')) {
                msg = "Activate";
                Active = 1;
            }          
            $confirmationBox("".concat('Do You want to ', msg, " SMS<br/><br/><b>Module :", $("#spnModule_" + SmsConfigurationID).text(), "</b><br/><b>Screen :", $("#spnScreen_" + SmsConfigurationID).text()), 2, Active, SmsConfigurationID, '', '');
        }
        $activeDeactiveToWhom = function (chkvalue, SmsConfigurationID, savingType) {
            var msg = "DeActivate"; var Active = 0;
            if ($(chkvalue).is(':checked')) {
                msg = "Activate";
                Active = 1;
            }
            $confirmationBox("".concat('Do You want to ', msg, " SMS<br/><br/><b>Module :", jQuery("#spnModule_" + SmsConfigurationID).text(), "</b><br/><b>Screen :", $("#spnScreen_" + SmsConfigurationID).text()), 3, Active, SmsConfigurationID, '', savingType);
        }
        $view = function (rowID, SmsConfigurationID) {
            serverCall('SMSConfigurationMasterNew.aspx/bindSMSTemplate', { ID: SmsConfigurationID }, function (response) {
                var $SMSConfigDetail = JSON.parse(response);
                jQuery("#spnSMSID").text(SmsConfigurationID);
                jQuery("#txtTemplate").val($SMSConfigDetail[0].Template);
                jQuery("#spnActiveColumns").text($SMSConfigDetail[0].ActiveColumns);
                if ($SMSConfigDetail[0].SMSTrigger == "Schedule" && '<%=UserInfo.ID%>' == 1)
                    jQuery("#divSQL").show();
                else 
                    jQuery("#divSQL").hide();
                if ('<%=UserInfo.ID%>' != 1) 
                    jQuery("#txtSQLQuery").val($SMSConfigDetail[0].SQLQuery);
                jQuery('#divSmsView').showModel();
            });
        }
        $addClient = function (rowID, SmsConfigurationID) {
            jQuery('#ddlTagClient').prop('selectedIndex', 0);
            jQuery('#ddlTagClient').chosen('destroy').chosen();
            jQuery('.divShow').hide();
            jQuery('#spnModule').text($("#spnModule_" + SmsConfigurationID).text());
            jQuery('#spnScreen').text($("#spnScreen_" + SmsConfigurationID).text());
            jQuery('#tblSMSClientList tr').slice(1).remove();
            jQuery("#spnSMSID").text(SmsConfigurationID);
            $bindTagClient();
            jQuery('#divClient').showModel();
        }
        $bindTagClient = function () {
            serverCall('SMSConfigurationMasterNew.aspx/bindClientType', {SmsConfigurationID:jQuery("#spnSMSID").text()}, function (response) {
                jQuery("#ddlTagClient").bindDropDown({ data: JSON.parse(response).CentreType, valueField: 'ID', textField: 'type1', isSearchAble: true, defaultValue: "Select", showDataValue: '' });
            });
        };
        $bindSMSClientList = function ($SMSClient) {
            jQuery('#tblSMSClientList tr').slice(1).remove();
            if ($SMSClient != null) {
                for (var i = 0; i < $SMSClient.length ; i++) {
                    var $myData = [];
                    $myData.push('<tr  class="GridViewItemStyle">');
                    $myData.push('<td style="text-align:left" id="tdSNo">'); $myData.push(parseInt(i + 1)); $myData.push('</td>');
                    $myData.push('<td style="text-align:left" id="tdSelect">'); $myData.push('<input type="checkbox" class="chkInd" id="chkClientID_'); $myData.push($SMSClient[i].Panel_ID); $myData.push('"'); $myData.push('/></td>');
                    $myData.push('<td style="text-align:left" id="tdCompany_Name">'); $myData.push($SMSClient[i].Company_Name); $myData.push('</td>');
                    $myData.push('<td style="text-align:left;display:none" id="tdClientID">'); $myData.push($SMSClient[i].Panel_ID); $myData.push('</td>');
                    $myData.push('</tr>');
                    $myData = $myData.join("");
                    jQuery("#tblSMSClientList tbody").append($myData);
                }
            }
            if (jQuery("#tblSMSClientList").find('tbody tr').length > 0)
                jQuery(".divShow").show();
            else
                jQuery(".divShow").hide();
        };
        $bindClient = function () {
            jQuery('#lstClient option').remove();
            jQuery('#lstClient').multipleSelect("refresh");
            jQuery('.chlAll').prop('checked', false);
            serverCall('SMSConfigurationMasterNew.aspx/bindClient', { CentreType1ID: $("#ddlTagClient option:selected").val(), SmsConfigurationID: $("#spnSMSID").text() }, function (response) {
                jQuery("#lstClient").bindMultipleSelect({ data: JSON.parse(response).client, valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery("#lstClient"), isClearControl: '' });
                jQuery('#tblSMSClientList tr').slice(1).remove();
                var $SMSClient = JSON.parse(response);                            
                $bindSMSClientList(jQuery.parseJSON($SMSClient.bindClient));
                if (JSON.parse(response).isActivatedTypeID > 0) {
                    jQuery("#btnClient").val('Discard Client');
                    jQuery("#spnType").text('Discard Client Details');
                    jQuery("#btnRemove").val('Remove Discard');
                    jQuery("#spnSaveType").text('Discard ');
                }
                else {
                    jQuery("#btnClient").val('Activate Client');
                    jQuery("#spnType").text('Activate Client Details');
                    jQuery("#btnRemove").val('Remove Activate');
                    jQuery("#spnSaveType").text('Activate ');
                }              
            });
        }
        $removeDiscard = function () {
            if (jQuery(".chkInd").is(':checked').length == 0) {
                toast('Error', 'Please Select Client', '');
                return;
            }
            var AllClientID = [];
            jQuery("#tblSMSClientList").find('tbody tr').each(function () {
                var clientID = jQuery(this).closest('tr').find('#tdClientID').text();
                if (jQuery(this).closest('tr').find('#chkClientID_' + clientID).is(':checked')) {
                    AllClientID.push(clientID);
                }
            });
            if (AllClientID.length == 0) {
                toast('Error', 'Please Select Client', '');
                return;
            }
            var clients = AllClientID.toString();
            $confirmationBox("".concat('Do You want to ', $("#btnRemove").val(), " Client"), 1, clients, $("#spnSMSID").text(), $("#ddlTagClient").val(), $("#btnRemove").val());
        }
    </script>
    <script type="text/javascript">
        $saveClient = function () {
            if ($("#ddlTagClient").val() == "0") {
                toast('Error', 'Please Select TagClient', '');
                jQuery("#ddlTagClient").focus();
                return;
            }
            var ClientID = $("#lstClient").val().toString();
            if (ClientID == "") {
                toast('Error', 'Please Select Client', '');
                jQuery("#lstClient").focus();
                return;
            }
            serverCall('SMSConfigurationMasterNew.aspx/saveClient', { ClientID: ClientID, CentreType1ID: jQuery("#ddlTagClient").val(), SavingType: $("#btnClient").val(), SmsConfigurationID: $("#spnSMSID").text() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response, '');
                    $clearControl();
                    $bindSMSClientList(jQuery.parseJSON($responseData.bindClientActDis));                                                              
                }
                else
                    toast('Error', $responseData.response, '');
            });
        }
        $clearControl = function () {
            jQuery('#ddlTagClient').prop('selectedIndex', 0);
            jQuery('#ddlTagClient').chosen('destroy').chosen();
            jQuery('#lstClient option').remove();
            jQuery('#lstClient').multipleSelect("refresh");
            jQuery('#tblSMSClientList tr').slice(1).remove();            
        }
    </script>
    <script type="text/javascript">
        $confirmationBox = function (contentMsg, type, TagTypeID, SMSConfigurationID, CentreType1ID, savingType) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: contentMsg,
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '480px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            $confirmationAction(type, TagTypeID, SMSConfigurationID, CentreType1ID, savingType);
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction(type, SMSConfigurationID, savingType);
                        }
                    },
                }
            });
        }
        $confirmationAction = function ($type, TagTypeID, SMSConfigurationID, CentreType1ID, savingType) {
            debugger;
            if ($type == 0) {
                serverCall('SMSConfigurationMasterNew.aspx/saveTagType', { TagTypeID: TagTypeID, SmsConfigurationID: SMSConfigurationID }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status)
                        toast('Success', $responseData.response, '');
                    else 
                        toast('Error', $responseData.response, '');
                });
            }
            else if ($type == 1) {
                serverCall('SMSConfigurationMasterNew.aspx/removeClient', { ClientID: TagTypeID, CentreType1ID: CentreType1ID, SavingType: savingType, SmsConfigurationID: SMSConfigurationID }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast('Success', $responseData.response, '');
                        $clearControl();
                        $bindSMSClientList(jQuery.parseJSON($responseData.bindClientActDis));
                        jQuery('.chlAll').prop('checked', false);
                    }
                    else
                        toast('Error', $responseData.response, '');
                });
            }
            else if ($type == 2) {
                serverCall('SMSConfigurationMasterNew.aspx/activeDeactiveSMS', { Active: TagTypeID, SmsConfigurationID: SMSConfigurationID, chkClient_22_date: $('#chkClient_22_date').val(), chkClient_23_date: $('#chkClient_23_date').val() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) 
                        toast('Success', $responseData.response, '');
                    else 
                        toast('Error', $responseData.response, '');
                });
            }
            else if ($type == 3) {
                serverCall('SMSConfigurationMasterNew.aspx/activeDeactiveToWhom', { Active: TagTypeID, SmsConfigurationID: SMSConfigurationID, savingType: savingType, Phone: $('#emp_cntct').val() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status)
                        toast('Success', $responseData.response, '');
                    else 
                        toast('Error', $responseData.response, '');
                });
            }
        }
        $clearAction = function (type, SMSConfigurationID, savingType) {
            if (type == 2) {
                if ($("#chkActive_" + SMSConfigurationID).is(':checked'))
                    $("#chkActive_" + SMSConfigurationID).prop('checked', false);
                else
                    $("#chkActive_" + SMSConfigurationID).prop('checked', 'checked');
            }
            if (type == 3) {
                if (savingType == "Patient") {
                    if ($("#chkPatient_" + SMSConfigurationID).is(':checked')) 
                        $("#chkPatient_" + SMSConfigurationID).prop('checked', false);
                    else 
                        $("#chkPatient_" + SMSConfigurationID).prop('checked', 'checked');
                }
                else if (savingType == "Doctor") {
                    if ($("#chkDoctor_" + SMSConfigurationID).is(':checked')) 
                        $("#chkDoctor_" + SMSConfigurationID).prop('checked', false);                    
                    else 
                        $("#chkDoctor_" + SMSConfigurationID).prop('checked', 'checked');                    
                }
                else if (savingType == "Client") {
                    if ($("#chkClient_" + SMSConfigurationID).is(':checked')) 
                        $("#chkClient_" + SMSConfigurationID).prop('checked', false);                    
                    else 
                        $("#chkClient_" + SMSConfigurationID).prop('checked', 'checked');                   
                }
                else if (savingType == "Employee") {
                    if ($("#chkEmployee_" + SMSConfigurationID).is(':checked')) 
                        $("#chkEmployee_" + SMSConfigurationID).prop('checked', false);                    
                    else 
                        $("#chkEmployee_" + SMSConfigurationID).prop('checked', 'checked');                   
                }
            }
        }
        $saveSMSTemp = function () {
            if ($("#txtTemplate").val() == "") {
                toast('Error', 'Please Enter Template', '');
                $("#txtTemplate").focus();
                return;
            }
          //  if ($("#txtSQLQuery").val() == "" && '<%=UserInfo.ID%>' == 1) {
                //toast('Error', 'Please Enter SQLQuery', '');
                //$("#txtSQLQuery").focus();
                //return;
          //  }
            serverCall('SMSConfigurationMasterNew.aspx/saveSMSTemplate', { ID: $("#spnSMSID").text(), Template: $("#txtTemplate").val(), SQLQuery: $("#txtSQLQuery").val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response, '');
                }
                else {
                    toast('Error', $responseData.response, '');
                }
                $closeSMSView();
            });
        }
    </script>
</asp:Content>

