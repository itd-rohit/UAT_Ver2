<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BulkChangePanel.aspx.cs" Inherits="Design_OPD_BulkChangePanel" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#div_SearchDetail").hide();
            $("#div_ZeroRate").hide();
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
    <style>
        div#divPatient.vertical
        {
            width: 75%;
            height: 400px;
            background: #ffffff;
            float: left;
            overflow-y: auto;
            border-right: solid 1px gray;
        }

        div#divInvestigation.vertical
        {
            margin-left: 75%;
            height: 400px;
            background: #ffffff;
            overflow-y: auto;
        }

        .ht_clone_top_left_corner, .ht_clone_bottom_left_corner, .ht_clone_left, .ht_clone_top
        {
            z-index: 0;
        }
        /* The Modal (background) */
        .modal
        {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 999; /* Sit on top */
            padding-top: 50px; /* Location of the box */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }

        /* Modal Content */
        .modal-content
        {
            position: relative;
            background-color: #fefefe;
            margin: auto;
            padding: 0;
            border: 1px solid #888;
            width: 80%;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
            -webkit-animation-name: animatetop;
            -webkit-animation-duration: 0.4s;
            animation-name: animatetop;
            animation-duration: 0.4s;
        }

        /* Add Animation */
        @-webkit-keyframes animatetop
        {
            from
            {
                top: -300px;
                opacity: 0;
            }

            to
            {
                top: 0;
                opacity: 1;
            }
        }

        @keyframes animatetop
        {
            from
            {
                top: -300px;
                opacity: 0;
            }

            to
            {
                top: 0;
                opacity: 1;
            }
        }

        /* The Close Button */
        .close
        {
            color: white;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

            .close:hover,
            .close:focus
            {
                color: #000;
                text-decoration: none;
                cursor: pointer;
            }

        .modal-header
        {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }

        .modal-body
        {
            padding: 2px 16px;
        }

        .modal-footer
        {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }
        /*for color
    */


        .handsontable .htDimmed
        {
            color: #000000;
        }

        #div_Save
        {
            width: 252px;
        }
        .auto-style1
        {
            width: 335px;
        }
    </style>
    <script type="text/javascript">
        var PatientData = '';
        var ItemData = '';
        var hot2;
        var modal = "";
        var span = "";
        var currentRow = 1;
        function PatientSearch() {

            UserValidate();
            if (!IsValid) {
                alert(" Invalid Session !!! ");
                window.location.href = window.location.href;
                 return false;
            }
            $('#div_Save').hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
            if ($("#<%=ddlCentreAccess.ClientID %>").val() == "Centre") {
                alert("Please Select Centre...");
                return;
            }
            if ($("#<%=ddlSourcePanel.ClientID %>").val() == "Source Panel") {
                alert("Please Select Source Panel...");
                return;
            }
            $("#div_Search").hide();
            $("#div_SearchDetail").show();
            $("#div_SearchDetail").html('From Date : ' + $("#<%=txtFormDate.ClientID %>").val() + ', ToDate : ' + $("#<%=txtToDate.ClientID %>").val() + ', Centre :' + $("#<%=ddlCentreAccess.ClientID%>").find('option:selected').text() + ', Source Panel :' + $("#<%=ddlSourcePanel.ClientID %>").find('option:selected').text());

           
            $.ajax({
                url: "BulkChangePanel.aspx/PatientSearch",
                data: '{ FromDate: "' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",SearchType:"' + $("#<%=ddlSearchType.ClientID %>").val() + '",FromLabNo:"' + $("#<%=txtFromLabNo.ClientID %>").val() + '",ToLabNo:"' + $("#<%=txtToLabNo.ClientID%>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '",PanelID:"' + $("#<%=ddlSourcePanel.ClientID%>").val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = JSON.parse(result.d);
                    if (PatientData.status == false) {
                        $("#div_Search").show();
                        $("#div_SearchDetail").hide();
                        $("#div_Save").hide();
                        alert('Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (PatientData.response.length == 0) {
                        
                        $("#div_Search").show();
                        $("#div_SearchDetail").hide();
                        $("#div_Save").hide();
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        return;
                    }
                    else {
                        PatientData = PatientData.response;
                        $("#div_SearchDetail").show();
                        $('#div_Save').show();
                        $("#<%=lblMsg.ClientID %>").text('');
                        var
                         data = PatientData,
                         container1 = document.getElementById('divPatient'),
                         hot1;

                        hot1 = new Handsontable(container1, {
                            data: PatientData,
                            colHeaders: [
                              "Show", "Reg. Date", "Lab No.", "Patient Name", "Age/Sex", "Net Amt", "Received Amt", "Select"
                            ],
                            readOnly: true,
                            columns: [
                            { data: 'LabNo', renderer: safeHtmlRenderer },
                            { data: 'RegDate' },
                            { data: 'LabNo' },
                            { data: 'PName' },
                            { data: 'AgeGender' },
                            { data: 'NetAmt' },
                            { data: 'RecAmt' }
                            ],
                            stretchH: "all",
                            fixedColumnsLeft: 1,
                            autoWrapRow: false,

                            fillHandle: false,
                            rowHeaders: true,
                        });
                        
                    }
                },
                error: function (xhr, status) {
                    
                    $("#div_Search").show();
                    $("#div_Save").hide();
                    $('#divPatient').html('');
                    alert('Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        //Ankita_25_05_2020
        var IsValid = true;
        function UserValidate() {
            $.ajax({
                url: "BulkChangePanel.aspx/ValidateUser",
                data: '{}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result == "") {
                        IsValid = false;
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            td.innerHTML = '<a href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> <img  src="../../App_Images/Post.gif" style="border-style: none" alt="">     </a>';
            return td;
        }
        function setHidden(instance, td, row, col, prop, value, cellProperties) {
            td.hidden = true;
            return td;
        }
        function PickRowData(rowIndex) {
            $("#divPatient tr > td").css("background", "#ffffff");
            $("#divPatient tr:nth-child(" + (rowIndex + 1) + ") > td").css("background", "rgb(189, 245, 245)");
            currentRow = rowIndex;
            SearchItemDetail(PatientData[rowIndex].LabNo, PatientData[rowIndex].PanelID);
        }
        function SearchItemDetail(LabNo, PanelID) {
            $('#divInvestigation').html('');
            $.ajax({
                url: "BulkChangePanel.aspx/SearchItemDetail",
                data: '{LabNo:"' + LabNo + '",PanelID:"' + $("#<%=ddlSourcePanel.ClientID %>").val() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {  
                    ItemData = JSON.parse(result.d);
                    if (ItemData.status == false) {
                        $('#btnSaveLabObs').attr("disabled", "disabled");

                        alert('Your Session Expired.... Please Login Again');
                        return;
                    }
                    if (ItemData.response.length == 0) {
                        $('#btnSaveLabObs').attr("disabled", "disabled");
                        
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        return;
                    }
                    else {
                        ItemData = ItemData.response;
                        $("#<%=lblMsg.ClientID %>").text('');
                        var data = ItemData,
                             container2 = document.getElementById('divInvestigation');
                        hot2 = new Handsontable(container2, {
                            data: ItemData,
                            colHeaders: [
                                  "Item Name", "OLD Rate", "New Rate", "Discount"
                            ],
                            columns: [
                             { data: 'ItemName' },
                            { data: 'Amount' },
                            { data: 'NewRate' },
                            { data: 'DiscountPercentage' }
                            ],
                            stretchH: "all",
                            fixedColumnsLeft: 1,
                            autoWrapRow: false,

                            fillHandle: false,
                            rowHeaders: true,
                        });
                        

                    }
                },
                error: function (xhr, status) {
                    
                    $('#divInvestigation').html('');
                    alert('Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function SaveChangePanel() {
            if ($("#<%=ddlCentreAccess.ClientID %>").val() == "Centre") {
                    alert("Please Select Centre...");
                    return;
                }
                if ($("#<%=ddlSourcePanel.ClientID %>").val() == "Source Panel") {
                    alert("Please Select Source Panel...");
                    return;
                }
                if ($("#<%=ddlTargetPanel.ClientID %>").val() == "Target Panel") {
                    alert("Please Select Target Panel...");
                    return;
                }
               
                $.ajax({
                    url: "BulkChangePanel.aspx/SaveNewPanelRates",
                    data: '{ FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate: "' + $("#<%=txtToDate.ClientID %>").val() + '",CentreID: "' + $("#<%=ddlCentreAccess.ClientID %>").val() + '",SourcePanelID: "' + $("#<%=ddlSourcePanel.ClientID %>").val() + '",TargetPanelID: "' + $("#<%=ddlTargetPanel.ClientID %>").val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    if (result.d == "-1") {
                        
                        alert("Your Session Expired...Please Login Again");
                        return;
                    }
                    else if (result.d == "0") {
                        
                        alert("Please contact to Admin");
                        return;
                    }
                    else if (result.d == "1") {

                        alert('Record Saved Successfully');
                        PatientSearch();
                        return;
                    }
                    else {
                        alert(result.d);
                        $('#div_ZeroRate').show();
                        $('#div_ZeroRate').html('Please Update the Rate for : ' + result);

                        return;
                    }
                },
                error: function (xhr, status) {
                    
                    alert("Please contact to Admin");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function ClearForm() {
            $("#div_SearchDetail").html('');
            $("#div_Search").show();
            $("#div_Save").hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 1275px">
        <div class="POuter_Box_Inventory" style="width: 1272px">

            <div class="Purchaseheader">
                Search Option
             &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

            </div>
            <div class="content" id="div_Search">
                Date :&nbsp;
                <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgdtFrom" TargetControlID="txtFormDate" />
                <asp:Image ID="imgdtFrom" runat="server" ImageUrl="../../App_Images/ew_calendar.gif" />

                &nbsp;-
                <asp:TextBox ID="txtToDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgdtTo" TargetControlID="txtToDate" />
                <asp:Image ID="imgdtTo" runat="server" ImageUrl="../../App_Images/ew_calendar.gif" />
                <div style="display: none;">
                    <asp:DropDownList ID="ddlSearchType" CssClass="ItDoseDropdownbox" runat="server" Width="100px">
                        <asp:ListItem Value="lt.LedgertransactionNo" Selected="True">Lab No</asp:ListItem>
                        <asp:ListItem Value="plo.BarcodeNo">BarcodeNo</asp:ListItem>
                    </asp:DropDownList>
                    <asp:TextBox ID="txtFromLabNo" CssClass="ItDoseTextinputText" runat="server" MaxLength="15" Width="110px"></asp:TextBox>
                    &nbsp;-<asp:TextBox ID="txtToLabNo" CssClass="ItDoseTextinputText" runat="server" MaxLength="15" Width="110px"></asp:TextBox>
                </div>
                Centre :
                <asp:DropDownList ID="ddlCentreAccess" Width="250px" runat="server" class="ddlCentreAccess chosen-select"></asp:DropDownList>
                Source Panel :
                <asp:DropDownList ID="ddlSourcePanel" Width="250px" runat="server" class="ddlSourcePanel chosen-select"></asp:DropDownList>

                <input id="btnSearch" type="button" value="Search" class="ItDoseButton" onclick="PatientSearch();" />


            </div>
            <div id="div_SearchDetail" style="font-weight: bold; font-family: Cambria; background-color: wheat; font-size: medium;">
            </div>
            <div id="div_ZeroRate" style="font-weight: bold; font-family: Cambria; background-color: lightblue; font-size: medium; display: none;">
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1272px">


            <div id="divPatient" class="vertical"></div>
            <div id="divInvestigation" class="vertical"></div>
            <div style="padding: 10px; float: left; width: 90%;">
                <table style="width: 99%">
                    <tr>
                        <td id="div_Save" style="width:26%">
                            <asp:DropDownList ID="ddlTargetPanel" Width="250px" runat="server" class="ddlSourcePanel chosen-select"></asp:DropDownList>
                            &nbsp; 

                <input id="btnSave" type="button" value="Save" class="ItDoseButton" onclick="SaveChangePanel();" style="width: 70px; height: 25px;" />
                        </td>
                        <td  style="width:50%">
                            <input id="btnReset" type="button" value="Reset" class="ItDoseButton" onclick="ClearForm();" style="width: 70px; height: 25px;" />

                        </td>
                    </tr>
                </table>
                
            </div>
        </div>
    </div>
</asp:Content>
