<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Utility.aspx.cs" Inherits="Design_OPD_Utility" %>

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
      <%: Scripts.Render("~/bundles/confirmMinJS") %>
	<script src="../../ckeditor/ckeditor.js"></script>
       <script type="text/javascript" src="../../Scripts/TimePicker/jquery.ui.timepicker.js"></script>
      <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
      <link href="../../Scripts/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
   
   
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
            margin-left: 68%;
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
        .searchbutton {
    cursor: pointer;
    background-color: blue;
    font-weight: bold;
    color: white;
    padding: 5px;
    border-radius: 5px;
    font-size: 15px;
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
            $('#div_Save').hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
           
            $("#div_Search").hide();
            $("#div_SearchDetail").show();
            $("#div_SearchDetail").html('From Date : ' + $("#<%=txtFormDate.ClientID %>").val() + ', ToDate : ' + $("#<%=txtToDate.ClientID %>").val());

            serverCall('Utility.aspx/PatientSearch', { FromDate:  $("#<%=txtFormDate.ClientID %>").val() ,ToDate: $("#<%=txtToDate.ClientID %>").val() ,SearchType: $("#<%=ddlSearchType.ClientID %>").val() ,FromLabNo: $("#<%=txtFromLabNo.ClientID %>").val() ,ToLabNo: $("#<%=txtToLabNo.ClientID%>").val() ,CentreID: $("#<%=ddlCentreAccess.ClientID%>").val() ,PanelID: $("#<%=ddlSourcePanel.ClientID%>").val() }, function (response) {
                 PatientData = $.parseJSON(response);
                    if (PatientData == "-1") {
                       
                        $("#div_Search").show();
                        $("#div_SearchDetail").hide();
                        $("#div_Save").hide();
                        toast("Error", "Your Session Expired.... Please Login Again", "");
                        return;
                    }
                    if (PatientData.length == 0) {
                      
                        $("#div_Search").show();
                        $("#div_SearchDetail").hide();
                        $("#div_Save").hide();
                      
                        toast("Info", "No Record Found", "");
                        return;
                    }
                    else {
                        $("#div_SearchDetail").show();
                        $('#div_Save').show();
                        $("#<%=lblMsg.ClientID %>").text('');
                        GetAmount('', '');
                        var
                         data = PatientData,
                         container1 = document.getElementById('divPatient'),
                         hot1;

                        hot1 = new Handsontable(container1, {
                            data: PatientData,
                            colHeaders: [
                           //  "Show", "Reg. Date", "Lab No.", "Patient Name", "Age/Sex", "Net Amt", "Received Amt", '<input id="chk_All" type="checkbox" onclick="chkall(this.id)" />'
                            
                             "Show", "Reg. Date", "Lab No.","Patient Name","Age/Sex","Net Amt","Received Amt",'<input type="button" class="searchbutton" value="+"  id="btnselectall"  onclick="chkall()" /><input type="button" class="searchbutton" value="-"  id="btnunselectall"  onclick="Unchkall()" />'
                           //  "Show", "Reg. Date", "Lab No.", "Patient Name", "Age/Sex", "Net Amt", "Received Amt", '<img id="img2" src="../Purchase/Image/ButtonAdd.png" onclick="chkall()" /><img id="img2" src="../Purchase/Image/minusnew.jpg" onclick="Unchkall()"  />'
                            ],
                            
                            
                            //
                            readOnly: true,
                            columns: [
                            { data: 'LabNo', renderer: safeHtmlRenderer },
                            { data: 'RegDate' },
                            { data: 'LabNo' },
                            { data: 'PName' },
                            { data: 'AgeGender' },
                            { data: 'NetAmt' },
                            { data: 'RecAmt' },
                            { data: 'LabNo', renderer: safeHtmlRenderer1 }
                            ],
                            stretchH: "all",
                            fixedColumnsLeft: 1,
                            autoWrapRow: false,
  renderAllRows: true,
                            fillHandle: false,
                            rowHeaders: true,
                        });
                       
                    }
            });
        }
        function chkall() {
            for (var i = 0; i < PatientData.length; i++) {
               // alert('ok');
                var inp = document.getElementById('chk_' + i);
                inp.checked = true;
            }
        }
        function Unchkall()
        {
            for (var i = 0; i < PatientData.length; i++) {
               // alert('ok');
                var inp = document.getElementById('chk_' + i);
                inp.checked = false;
            }
        }
       
        function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            //escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
            td.innerHTML = '<a href="javascript:void(0);"  onclick="PickRowData(' + row + ');"> <img  src="../../App_Images/Post.gif" style="border-style: none" alt="">     </a>';
            return td;
        }
        function safeHtmlRenderer1(instance, td, row, col, prop, value, cellProperties) {
            var escaped = Handsontable.helper.stringify(value);
            td.innerHTML = '<input id="chk_' + row + '" type="checkbox"/>';
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
            GetAmount(PatientData[rowIndex].LabNo, PatientData[rowIndex].PanelID);
        }
        function GetAmount(LabNo, PanelID) {
            
            $('#divInvestigation').html('');
            serverCall('Utility.aspx/GetAmount', {FromDate:  $("#<%=txtFormDate.ClientID %>").val() ,ToDate: $("#<%=txtToDate.ClientID %>").val() ,SearchType: $("#<%=ddlSearchType.ClientID %>").val() ,FromLabNo: $("#<%=txtFromLabNo.ClientID %>").val() ,ToLabNo: $("#<%=txtToLabNo.ClientID%>").val() ,CentreID: $("#<%=ddlCentreAccess.ClientID%>").val() ,PanelID: $("#<%=ddlSourcePanel.ClientID%>").val(), LabNo: LabNo }, function (response) {
                ItemData = $.parseJSON(response);
                if (ItemData.length != 0) {
                    $('#<%=lblnewrate.ClientID%>').text("Old Amount :"+ItemData[0].OldAmount);
                    $('#<%=lbloldrate.ClientID%>').text("  New Amount :" + ItemData[0].NewRate);
                    $('#<%=ldldiff.ClientID%>').text("  Difference Amount :" + ItemData[0].Diff);
                }
            });
       }
        function SearchItemDetail(LabNo, PanelID) {
            
            $('#divInvestigation').html('');
            serverCall('Utility.aspx/SearchItemDetail', { LabNo: LabNo, PanelID: $("#<%=ddlSourcePanel.ClientID %>").val() }, function (response) {
                ItemData = $.parseJSON(response);
           

                    if (ItemData == "-1") {
                        $('#btnSaveLabObs').attr("disabled", "disabled");
                        toast("Error", "Your Session Expired.... Please Login Again", "");
                        return;
                    }
                    if (ItemData.length == 0) {
                        $('#btnSaveLabObs').attr("disabled", "disabled");
                       
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        return;
                    }
                    else {
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
            });
        }
        function SaveTesting() {
            var i;
            var Selectedpatient = "";
            for (i = 0; i < PatientData.length; i++) {
                var inp = document.getElementById('chk_' + i);
                if (inp.checked == true) {
                    Selectedpatient = Selectedpatient + PatientData[i].LabNo+",";
                }
            }
            serverCall('Utility.aspx/SaveNewPanelRatesUtility', { FromDate: $("#<%=txtFormDate.ClientID %>").val() ,ToDate:  $("#<%=txtToDate.ClientID %>").val() ,CentreID: $("#<%=ddlCentreAccess.ClientID %>").val() ,SourcePanelID:  $("#<%=ddlSourcePanel.ClientID %>").val() ,TargetPanelID:  $("#<%=ddlTargetPanel.ClientID %>").val() ,Selectedpatient:  Selectedpatient  }, function (result) {
               
                        if (result == "-1") {
                            toast("Error", "Your Session Expired...Please Login Again", "");
                          
                            return;
                        } else if (result == "-2") {
                            toast("Error", "Please select the Patient", "");

                            return;
                        }
                        else if (result == "0") {
                            toast("Error", "Please contact to Admin", "");
                          
                            return;
                        }
                        else if (result == "1") {
                            toast("Success", "Record Saved Successfully", "");
                            PatientSearch();
                            return;
                        } else {
                           
                            alert(result);
                            $('#div_ZeroRate').show();
                            $('#div_ZeroRate').html('Please Update the Rate for : ' + result);
                           
                            return;
                        }
            });
        }
        function SaveChangePanel22() {
            if ($("#<%=ddlCentreAccess.ClientID %>").val() == "Centre") {
                toast("Info", "Please Select Centre...", "");
                    return;
                }
                if ($("#<%=ddlSourcePanel.ClientID %>").val() == "Source Panel") {
                    toast("Info", "Please Select Source Panel...", "");
                    return;
                }
                if ($("#<%=ddlTargetPanel.ClientID %>").val() == "Target Panel") {
                  
                    toast("Info", "Please Select Target Panel...", "");
                    return;
                }
            serverCall('Utility.aspx/SaveNewPanelRates', {  FromDate: $("#<%=txtFormDate.ClientID %>").val() ,ToDate: $("#<%=txtToDate.ClientID %>").val() ,CentreID: $("#<%=ddlCentreAccess.ClientID %>").val() ,SourcePanelID:  $("#<%=ddlSourcePanel.ClientID %>").val() ,TargetPanelID:  $("#<%=ddlTargetPanel.ClientID %>").val() }, function (result) {
          

                    if (result == "-1") {
                        toast("Info", "Your Session Expired...Please Login Again", "");
                      
                        return;
                    }
                    else if (result == "0") {
                        toast("Info", "Please contact to Admin", "");
                       
                        return;
                    }
                    else if (result == "1") {
                        toast("Success", "Record Saved Successfully", "");
                      
                        PatientSearch();
                        return;
                    } else {
                        alert(result);
                        $('#div_ZeroRate').show();
                        $('#div_ZeroRate').html('Please Update the Rate for : ' + result);
                        
                        return;
                    }
            });
        }
        function ClearForm() {
            $("#div_SearchDetail").html('');
            $("#div_Search").show();
            $("#div_Save").hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
            $('#div_ZeroRate').html('');
            $('#<%=lblnewrate.ClientID%>').text('');
            $('#<%=lbloldrate.ClientID%>').text('');
            $('#<%=ldldiff.ClientID%>').text('');
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader" style="text-align:center">
                International Utility
             &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

            </div>
            <div class="row" id="div_Search">
                <div class="col-md-3"><label class="pull-right">From Date :</label></div>
                <div class="col-md-3">
                     <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" ></asp:TextBox>
                <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                </div>
                <div class="col-md-3 "><label class="pull-right">To Date :</label> </div>
                <div class="col-md-3"> <asp:TextBox ID="txtToDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" ></asp:TextBox>
                <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
               </div>
                <div class="col-md-3">
                <asp:DropDownList ID="ddlCentreAccess"  runat="server" style="display:none"></asp:DropDownList></div>
                 <div class="col-md-3"> <input id="btnSearch" type="button" value="Search" class="ItDoseButton" onclick="PatientSearch();" /> </div>
               
                <div class="col-md-6" style="display: none;">
                    <asp:DropDownList ID="ddlSearchType" CssClass="ItDoseDropdownbox" runat="server" Width="100px">
                        <asp:ListItem Value="lt.LedgertransactionNo" Selected="True">Lab No</asp:ListItem>
                        <asp:ListItem Value="plo.BarcodeNo">BarcodeNo</asp:ListItem>
                    </asp:DropDownList>
                    <asp:TextBox ID="txtFromLabNo" CssClass="ItDoseTextinputText" runat="server" MaxLength="15" Width="110px"></asp:TextBox>
                    &nbsp;-<asp:TextBox ID="txtToLabNo" CssClass="ItDoseTextinputText" runat="server" MaxLength="15" Width="110px"></asp:TextBox>
                     
             <%--   Source Panel :--%>
                <asp:DropDownList ID="ddlSourcePanel" Width="250px" runat="server"  style="display:none;"></asp:DropDownList>
                </div>
            </div>
            <div id="div_SearchDetail" style="font-weight: bold; font-family: Cambria; background-color: wheat; font-size: medium;" >
            </div>
            <div id="div_ZeroRate" style="font-weight:bold font-family: Cambria; background-color: lightblue; font-size: medium; display: none;">
            </div>
        </div>
        <div class="POuter_Box_Inventory">


            <div id="divPatient" class="vertical" style="width:950px;"></div>
            <div id="divInvestigation" class="vertical" align="left" style="" ></div>
            <div style="padding: 10px; float: left; width: 90%;">
                <table style="width: 99%">
                    <tr>
                        <td id="div_Save" style="width:25%">
                            <asp:DropDownList ID="ddlTargetPanel" Width="250px" runat="server"  style="display:none;"></asp:DropDownList>
                            &nbsp; 

             
                        </td>
                        <td  style="width:25%">
                           
                               <input id="btnSave" type="button" value="Save" class="searchbutton" onclick="SaveTesting();" style="width: 70px; height: 25px;" />
                            <input id="btnReset" type="button" value="Reset" class="searchbutton" onclick="ClearForm();" style="width: 70px; height: 25px;" />

                        </td>
                        <td style="width:50%;font-size:12px;font-weight:bold;color:red;">
                             <asp:Label ID="lbloldrate" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Label ID="lblnewrate" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Label ID="ldldiff" runat="server"></asp:Label>
                        </td>
                    </tr>
                </table>
                
            </div>
        </div>
    </div>
</asp:Content>
