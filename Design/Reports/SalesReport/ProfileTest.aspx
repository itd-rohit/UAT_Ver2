<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ProfileTest.aspx.cs" Inherits="Design_SalesDiagnostic_ProfileTest" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../JavaScript/jquery.extensions.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>
    <link href="../../combo-select-master/chosen.css" rel="stylesheet" type="text/css" />
    <script src="../../combo-select-master/chosen.jquery.js" type="text/javascript"></script>
    
    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; text-align: center">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
         <style>
             [type=text] {
                 padding: 3px 0px;
                 text-align: center;
                 display: inline-block;
                 border: 1px solid #ccc;
                 border-radius: 4px;
                 box-sizing: border-box;
             }

             .alertify-notifier .ajs-message.ajs-warning {
                 color: white;
                 font-weight: bold;
                 background-color: red;
             }

             .alertify-notifier .ajs-message.ajs-success {
                 color: white;
                 font-weight: bold;
                 background-color: green;
             }

             .myTable {
                 border-collapse: collapse;
                 width: 100%;
             }

                 .myTable th, .myTable td {
                     text-align: left;
                     padding: 8px;
                 }

                 .myTable td {
                     background-color: white;
                 }

                 .myTable th {
                     background-color: #008CBA;
                     color: white;
                 }

             .btn {
                 background-color: #008CBA;
                 border: none; /* Remove borders */
                 color: white; /* Add a text color */
                 padding: 6px 20px; /* Add some padding */
                 cursor: pointer;
             }

             .auto-style2 {
                 width: 327px;
             }

             .auto-style3 {
                 height: 20px;
             }
         </style>
    <script type="text/jscript"  >
        //browser detection
        var agt = navigator.userAgent.toLowerCase();
        var is_major = parseInt(navigator.appVersion);
        var is_minor = parseFloat(navigator.appVersion);

        var is_nav = ((agt.indexOf('mozilla') != -1) && (agt.indexOf('spoofer') == -1)
                    && (agt.indexOf('compatible') == -1) && (agt.indexOf('opera') == -1)
                    && (agt.indexOf('webtv') == -1) && (agt.indexOf('hotjava') == -1));
        var is_nav4 = (is_nav && (is_major == 4));
        var is_nav6 = (is_nav && (is_major == 5));
        var is_nav6up = (is_nav && (is_major >= 5));
        var is_ie = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));
</script>
    <script type="text/jscript"  >

        //tooltip Position
        var offsetX = 0;
        var offsetY = 5;
        var opacity = 100;
        var toolTipSTYLE;

        function initToolTips() {
            if (document.getElementById) {
                toolTipSTYLE = document.getElementById("toolTipLayer").style;
            }
            if (is_ie || is_nav6up) {
                toolTipSTYLE.visibility = "visible";
                toolTipSTYLE.display = "none";
                document.onmousemove = moveToMousePos;
            }
        }
        function moveToMousePos(e) {
            if (!is_ie) {
                x = e.pageX;
                y = e.pageY;
            } else {
                x = event.x + document.body.scrollLeft;
                y = event.y + document.body.scrollTop;
            }

            toolTipSTYLE.left = x + 15 + offsetX + 'px';
            toolTipSTYLE.top = y + offsetY + 'px';
            return true;
        }

        function toolTip(msg, fg, bg) {

            initToolTips();
            if (toolTip.arguments.length < 1) // if no arguments are passed then hide the tootip
            {
                if (is_nav4)
                    toolTipSTYLE.visibility = "hidden";
                else
                    toolTipSTYLE.display = "none";
            }
            else // show
            {
                var data = msg.split('#');
                var i = 0;

                var content = '<table border="0" cellspacing="1" cellpadding="1" class="toolTip"><tr><td bgcolor="' + fg + '">';
                content = content + '<table border="0" cellspacing="1" cellpadding="1"> ';

                if (data.length <= 5) {
                    for (i = 0; i < data.length; i++) {
                        if (!fg) fg = "#000000";
                        if (!bg) bg = "#ffffff";
                        content = content + '<tr><td bgcolor="#dcdcdc">';
                        content = content + '<font face="sans-serif" color="' + fg + '" size="-1">' + eval(i + 1) + ') ' + data[i] + '&nbsp;&nbsp;';
                        content = content + '</font></td></tr>';
                    }
                }
                else {

                    for (i = 0; i < data.length;) {
                        if (!fg) fg = "#000000";
                        if (!bg) bg = "#ffffff";
                        content = content + '<tr bgcolor="#dcdcdc">';
                        content = content + '<td bgcolor="#dcdcdc"><font face="sans-serif" color="' + fg + '" size="-1">' + eval(i + 1) + ') ' + data[i] + '&nbsp;&nbsp;</font></td>';

                        if (i + 1 < data.length) {
                            content = content + '<td bgcolor="#dcdcdc"><font face="sans-serif" color="' + fg + '" size="-1">' + eval(i + 2) + ') ' + data[i + 1] + '&nbsp;&nbsp;</font></td>';
                        }
                        if (i + 1 == data.length) {
                            content = content + '<td bgcolor="#dcdcdc"><font face="sans-serif" color="' + fg + '" size="-1"> &nbsp;&nbsp;</font></td>';
                        }

                        content = content + '</tr>';

                        i = i + 2;
                    }


                }
                content = content + '</table>' +
                '</td></tr></table>';

                if (msg == "") {
                    content = '<table border="0" cellspacing="1" cellpadding="1" class="toolTip"><tr><td bgcolor="' + fg + '">';
                    content = content + '<table border="0" cellspacing="1" cellpadding="1"> ';
                    if (!fg) fg = "#000000";
                    if (!bg) bg = "#ffffff";
                    content = content + '<tr><td bgcolor="#dcdcdc">';
                    content = content + '<font face="sans-serif" color="' + fg + '" size="-1">Text Report or data not available&nbsp;&nbsp;';
                    content = content + '</font></td></tr>';
                    content = content + '</table>' +
              '</td></tr></table>';

                }


                if (is_nav4) {
                    toolTipSTYLE.document.write(msg);
                    toolTipSTYLE.document.close();
                    toolTipSTYLE.visibility = "visible";
                }
                else if (is_ie || is_nav6up) {
                    document.getElementById("toolTipLayer").innerHTML = content;
                    toolTipSTYLE.display = 'block'
                }
            }
        }

        s = '<table width="100%" cellspacing="2" cellpadding="0" border="0">';
        s += '<tr><td><img src="http://upload.wikimedia.org/wikipedia/meta/2/2a/Nohat-logo-nowords-bgwhite-200px.jpg" border="0"/> </td><td valign="top">WikiPedia</td></tr>';
        s += '<tr><td colspan="2" class="Text"><hr/>this is a test for simple tooltip. <br/>You can add text and images to the tooltip</td></tr>';
        s += '</table>'

        function show(msg) {

            toolTip(msg)
        }

        //--></script>
    
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
        var URl = "";
        var InvestigationID = "";
        var ItemID = "";
        var ReportTypeNo = "";
        function ShowInvDetail(NAME, Rate, TestCode, Investigation_Id) {
            debugger
            $("#spnInvName").html("Test Name : " + NAME);
            $("#spnInvName").css("display", "");
            $("#spnInvRate").html("Rate :" + Rate);
            $("#spnInvRate").css("display", "");
            $('#<%=lblInvestigation.ClientID %>').html(Investigation_Id);
            // $("#div_PackageNameHead").css("color", "green");
            SearchObservation();
        }
        function ShowPackageDetail(PackageTitle, Rate, TestCode, PackageID, CreatedBy, CreatedOn, ItemID, IsActive, ShowInReport, FromAge, ToAge, Gender, BaseRate, Inv_ShortName, BillingCategory) {
            //nirmal

            // document.getElementById('flInvestigationDetails').style.visibility = 'visible';
            $('#flInvestigationDetails').show();
            document.getElementById('<%=txtPackageTitle.ClientID %>').value = PackageTitle;
            document.getElementById('<%=txtRate.ClientID %>').value = Rate;
            document.getElementById('<%=txtTestCode.ClientID %>').value = TestCode;
            document.getElementById('<%=txtBaseRate.ClientID %>').value = BaseRate;
            document.getElementById('<%=txtFromage.ClientID %>').value = FromAge;
            document.getElementById('<%=txtToage.ClientID %>').value = ToAge;
            document.getElementById('<%=ddlGender.ClientID %>').value = Gender;
            document.getElementById('<%=txtReportDisplayName.ClientID %>').value = Inv_ShortName;

            $('#<%=ddlBillingCategory.ClientID %>').val(BillingCategory);
            $('#<%=lblPackageID.ClientID %>').html(PackageID);
            $('#<%=lblCreatedBy.ClientID %>').html(CreatedBy);
            $('#<%=lblCreatedOn.ClientID %>').html(CreatedOn);
            $('#<%=lblItemID.ClientID %>').html(ItemID);
            $("#div_PackageNameHead").html("Profile Test : " + PackageTitle);
            $("#div_PackageNameHead").css("display", "");
            $("#spnRate").html("Rate :" + Rate);
            $("#spnRate").css("display", "");
            // $("#div_PackageNameHead").css("color", "green");
            SearchInv();
        }
        function GetPackageList() {
            $.blockUI();
            try {
                var InActive = $("#ChkInActive").is(':checked') ? 0 : 1;
                var OrderBy = "plm.name";
                $.ajax({
                    url: "ProfileTest.aspx/GetPackageList",
                    data: '{}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) { 
                        PackageData = eval('[' + result + ']');
                        $('#DivInv').hide();
                        $('#DivProfile').show();
                        var output = $('#tb_GetPackageList').parseTemplate(PackageData);
                        $('#div_GetPackageList').html(output); 
                        $('#div_GetPackageList').html(output); 
                        $.unblockUI();
                    },
                    error: function (xhr, status) {
                        $.unblockUI();
                        showErrorAlert("Error ");
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            catch (e) {
                $.unblockUI();
                console.log(e);
                showErrorAlert(e);
            }
        }

        function GetInvestigationList() {
            $.blockUI();
            try { 
                $.ajax({
                    url: "ProfileTest.aspx/GetInvestigationList",
                    data: '{}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        PackageData = eval('[' + result + ']');
                        $('#DivInv').show();
                        $('#DivProfile').hide();
                        var output = $('#tb_divInv').parseTemplate(PackageData);
                        $('#divInv').html(output); 
                        $.unblockUI();
                    },
                    error: function (xhr, status) {
                        $.unblockUI();
                        showErrorAlert("Error ");
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            catch (e) {
                $.unblockUI();
                console.log(e);
                showErrorAlert(e);
            }

        }
        function printDiv() {
            debugger
            var divToPrint
            if ($("input[name='A']:checked").val() == "Investigation")
                divToPrint = document.getElementById('tdObsevation');
            else {
                divToPrint = document.getElementById('tdInvDetails');
            }
            if (divToPrint.innerHTML == "") {
                newWin.close();
                return;
            }
            else {
                var newWin = window.open('', 'Print-Window');

                newWin.document.open();

                newWin.document.write('<html><body onload="window.print()">' + divToPrint.innerHTML + '</body></html>');

                newWin.document.close();

                setTimeout(function () { newWin.close(); }, 10);
            }

        }

         </script>
    <%--<div id="toolTipLayer" style="position:absolute; visibility: hidden;left:0;right:0"></div>--%>
    <div id="Pbody_box_inventory" style="width: 97%; text-align: left;">
        <div class="POuter_Box_Inventory" style="width: 99.6%;">
            <cc1:ToolkitScriptManager runat="server" ID="sc"></cc1:ToolkitScriptManager>
            <div class="content">
                <div style="text-align: center;">
                    <b style="font-size: large; font-weight: bold;text-align:center;">Package Investigation<br />
                    </b>
                       <input type="radio" id="rdoPackage" onclick="GetPackageList();" name="A" checked="checked" value="Profile" /><strong>Package</strong>
                       <input type="radio" id="rdoInv" onclick="GetInvestigationList();" name="A" style="margin-left: 20px;" value="Investigation" />
                            <strong>Investigation</strong>
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                     <div style="text-align:right"> 
                           <img src="../../App_Images/print.gif" alt="Export" onclick="printDiv()" style="width: 34px; height: 30px;" />
                    
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="DivProfile" style="width: 99.6%; text-align: left;height:615px">
            <div class="Purchaseheader">Package Investigation</div>
            <div style="height: 380px; width: 99.6%;" class="content">
               
                <table cellpadding="0" cellspacing="0" style="height: 330px; width: 99.6%;">
                    <tr style="width: 99.6%">
                        <td colspan="9">
                           
                            <div style="display: none;">
                                <input type="radio" checked="checked" name="chkSearchType" value="1" />
                                Search By Name
                            <input type="radio" name="chkSearchType" value="2" />
                                Search by Code
                            <asp:TextBox ID="txtSearchInv" placeholder="Type To Search" runat="server" OnKeyUp="Click(this);"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr style="width: 99.6%">
                        <td colspan="9" >
                            
                        </td>

                    </tr>
                    <tr style="vertical-align: top;">
                   <td style="width:45%;vertical-align: top">
                            <fieldset class="f1" style="Height: 500px;">
                                <legend class="lgd">Profile/Test</legend>
                                
                                 <div id="div_GetPackageList" style="max-height:480px;overflow-y: auto; overflow: auto;"></div>
                            </fieldset>
                            &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; 
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>

                       <td style="width:10%;vertical-align: top;display:none">
                            <fieldset class="f1" style="height: 500px; vertical-align: top;">
                                <legend class="lgd">Description</legend>
                                <table style="width: 100%; height: 277px;">
                                    <tr>
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Name:</label><asp:TextBox ID="txtPackageTitle" runat="server"  MaxLength="100" Width="150px"></asp:TextBox>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Billing Category:</label><asp:DropDownList ID="ddlBillingCategory" runat="server" class="ddlBillingCategory  chosen-select chosen-container" Width="150px">
                                                
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Report Display Name:</label>
                                            <asp:TextBox ID="txtReportDisplayName" runat="server"  MaxLength="100" Width="150px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px" >From Age (In Days):</label>
                                            <asp:TextBox ID="txtRate" style="display:none"  runat="server"  MaxLength="100" Width="150px"></asp:TextBox>
                                            <asp:TextBox ID="txtFromage" runat="server" MaxLength="5"  Width="150px"  Text="0" ClientIDMode="Static"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="ftbFromAge" runat="server" TargetControlID="txtFromage" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="auto-style2">
                                         <label class="labelForTag" style="width: 150px">To Age (In Days):</label>
                                            <asp:TextBox ID="txtToage" runat="server" MaxLength="5"   Width="150px"  Text="70000" ClientIDMode="Static"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="ftbToAge" runat="server" TargetControlID="txtToage" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td class="auto-style2">
                                             <label class="labelForTag" style="width: 150px">Gender:</label>
                                            <asp:DropDownList ID="ddlGender" class="ddlGender  chosen-select chosen-container" runat="server" Width="150px">
                                                <asp:ListItem Value="B" Text="Both"></asp:ListItem>
                                                <asp:ListItem Value="M" Text="Male"></asp:ListItem>
                                                <asp:ListItem Value="F" Text="Female"></asp:ListItem>
                                            </asp:DropDownList>
                                             </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Code:</label><asp:TextBox ID="txtTestCode" runat="server" Width="150px"  MaxLength="100"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Base Rate:</label><asp:TextBox ID="txtBaseRate" runat="server" Width="150px"  MaxLength="100"></asp:TextBox>
                                             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" TargetControlID="txtBaseRate"  >
                                             </cc1:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                      <tr style="display:none;">
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Created By:</label><asp:Label ID="lblCreatedBy" runat="server" Width="150px" ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr style="display:none;">
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Created On:</label><asp:Label ID="lblCreatedOn" runat="server" Width="150px" ></asp:Label>
                                        </td>
                                    </tr>
                                     <tr style="display:none;">
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Updated By:</label><asp:Label ID="lblUpdatedBy" runat="server" Width="150px"  ></asp:Label>
                                        </td>
                                    </tr>
                                     <tr style="display:none;">
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Updated On:</label><asp:Label ID="lblUpdatedOn" runat="server"  Width="150px"  ></asp:Label>
                                        </td>
                                    </tr>
                                     <tr style="display:none;">
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Item ID :</label><asp:Label ID="lblItemID" runat="server"  Width="150px" ></asp:Label>
                                        </td>
                                    </tr>
                                     <tr style="display:none;">
                                        <td valign="top" class="auto-style2">
                                            <label class="labelForTag" style="width: 150px">Package ID :</label><asp:Label ID="lblPackageID" runat="server"  Width="150px" ></asp:Label>
                                        </td>
                                    </tr>
                                      <tr style="display:none;">
                                        <td valign="top" class="auto-style2">
                                            <asp:CheckBox ID="chkIsActive" runat="server"  Text="Is-Active" ForeColor="Red"></asp:CheckBox>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td valign="top" class="auto-style2">
                                            <asp:CheckBox ID="chkShowInReport" runat="server"  Text="Show In Report" ForeColor="Red"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            
                                             <input id="btnSaveNewPackage" type="button" class="btn" value="Save Package" onclick="SaveNewPackage();"  style="display:none;"/>
                                        </td>

                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                       
                        <td style="width:45%;vertical-align: top" id="tdInvDetails">
                               <fieldset class="f1" style="height: 500px; vertical-align: top;">
                                <legend class="lgd">Package Inclussions</legend>
                                 <span id="div_PackageNameHead" style="font-size: medium; font-weight: bold;text-align:center;"></span>
                                  <span id="spnRate" style="font-size: medium; font-weight: bold;text-align:center;"></span>
                                <table style="width: 100%">
                                    <tr>
                                        <td valign="top" colspan="2" class="auto-style3">
                                            <div id="div_InvestigationItems" style="max-height:460px;overflow-y: auto; overflow: auto;"></div>
                                             
                                        </td>
                                      
                                    </tr>
                                     
                                </table>
                                   </fieldset>
                        
                        </td>
                          
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="DivInv" style="width: 99.6%; text-align: left;height:615px">
            <div class="Purchaseheader">Investigation-Parameter</div>
            <div style="height: 380px; width: 99.6%;" class="content">
                <table cellpadding="0" cellspacing="0" style="height: 330px; width: 99.6%;">
                 
                    <tr style="width: 99.6%">
                        <td colspan="9" >
                            
                        </td>

                    </tr>
                    <tr style="vertical-align: top;">
                   <td style="width:45%;vertical-align: top">
                            <fieldset class="f1" style="Height: 500px;">
                                <legend class="lgd">Investigations</legend>
                                
                                 <div id="divInv" style="max-height:480px;overflow-y: auto; overflow: auto;"></div>
                            </fieldset>
                            &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; 
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>

                       <td style="display:none">
                           <asp:Label ID="lblInvestigation" runat="server"  Width="150px" ></asp:Label>
                       </td>
                       
                        <td style="width:45%;vertical-align: top" id="tdObsevation">
                               <fieldset class="f1" style="height: 500px; vertical-align: top;">
                                <legend class="lgd">Investigation Inclussions</legend>
                                 <span id="spnInvName" style="font-size: medium; font-weight: bold;text-align:center;"></span>
                                  <span id="spnInvRate" style="font-size: medium; font-weight: bold;text-align:center;"></span>
                                <table style="width: 100%">
                                    <tr>
                                        <td valign="top" colspan="2" class="auto-style3">
                                            <div id="DivObser" style="max-height:460px;overflow-y: auto; overflow: auto;"></div>
                                             
                                        </td>
                                      
                                    </tr>
                                     
                                </table>
                                   </fieldset>
                        
                        </td>
                          
                    </tr>
                </table>
            </div>
        </div>
      
    </div>
  <%-- from Package list--%> 
     <script id="tb_GetPackageList" type="text/html">
        <table cellspacing="0" rules="all" class="myTable" border="1" id="tbl_GetPackageList"  style="border-collapse:collapse; cursor: move;width:99.6%" >
		<tr id="Header" class="nodrop">
			<th class="" scope="col" style="width:20px;">Sr.No.</th>
            <th class="" scope="col" style="width:70px;display:none;">Item ID</th>
            <th class="" scope="col" style="width:70px;display:none;">Package ID</th>
            <th class="" scope="col" style="width:70px;">Test Code</th>
            <th class="" scope="col" style="width:200px;">Package</th> 
             <th class="" scope="col" style="width:70px;">Rate</th> 
			<th class="" scope="col" style="width:50px;">Detail</th> 
</tr>

       <#
       
              var dataLength=PackageData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = PackageData[j];
         
            #>
                    <tr id="<#=objRow.PlabID#>" >
<td class="" style="text-align:center;"><#=j+1#></td>
<td id="td3"  class="" style="text-align:left;display:none; font: 12px arial, sans-serif"><#=objRow.ItemID#></td>
<td id="td6"  class="" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.PlabID#></td> 
<td id="td4"  class="" style="text-align:left;font: 12px arial, sans-serif"><#=objRow.TestCode#></td> 
<td id="td5"  class="" style="text-align:left;font: 12px arial, sans-serif""><#=objRow.NAME#></td>
<td id="td9"  class="" style="text-align:left;font: 12px arial, sans-serif""><#=objRow.Rate#></td>
<td class="" style="text-align:center;cursor:pointer;"><img id="img1" src="../../App_Images/Post.gif"   
    onclick="ShowPackageDetail('<#=objRow.NAME#>','<#=objRow.Rate#>','<#=objRow.TestCode#>','<#=objRow.PlabID#>','<#=objRow.CreatedBy#>','<#=objRow.CreatedOn#>','<#=objRow.ItemID#>','<#=objRow.IsActive#>','<#=objRow.ShowInReport#>','<#=objRow.FromAge#>','<#=objRow.ToAge#>','<#=objRow.Gender#>','<#=objRow.BaseRate#>','<#=objRow.Inv_ShortName#>','<#=objRow.Bill_Category#>')" /></td>
</tr>

            <#}#>

        </table>    
    </script>
    <script id="tb_InvestigationItems" type="text/html">
        <table cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" class="myTable" style="border-collapse:collapse; cursor: move;width:99.6%" >
		<tr id="Tr1" class="nodrop">
			<th class="" scope="col" style="width:20px;">S.No.</th>
             <th class="" scope="col" style="width:70px;">Test Code</th>
            <th class="" scope="col" style="width:200px;display:none;">Package ID</th>
            <th class="" scope="col" style="width:200px;display:none;">Investigation ID</th>
			<th class="" scope="col" style="width:200px;">Investigation-SampleType</th>
            <th class="" scope="col" style="width:70px;">Rate</th>
			
</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=objRow.Investigation_Id#>"  >
<td class="" style="text-align:center;"><#=j+1#></td>
                        <td class="" style="text-align:center;"><#=objRow.TestCode#></td>
<td id="td2"  class="" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.PlabId#></td>
<td id="td1"  class="" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.Investigation_Id#></td>
<td id="td_PLabID"  class="" style="text-align:left;font: 12px arial, sans-serif"><#=objRow.Investigation#></td>
                      
                    
<td class="" style="cursor:pointer;text-align:center"><#=objRow.Rate#></td>
</tr>

            <#}#>

     </table> 
         <div id="divPackageData" style="display:none;overflow: auto; height: 400px;">         
        <table id="exceltable" class="myTable">
        </table>  
        </div>     
    
    </script>
   <%-- to item list--%>
     <%-- from Item list--%> 
      <script id="tb_divInv" type="text/html">
        <table cellspacing="0" rules="all" class="myTable" border="1" id="tbl_divInv"  style="border-collapse:collapse; cursor: move;width:99.6%" >
		<tr id="Tr2" class="nodrop">
			<th class="" scope="col" style="width:20px;">Sr.No.</th>
            <th class="" scope="col" style="width:70px;display:none;">Item ID</th>
            <th class="" scope="col" style="width:70px;">Test Code</th>
            <th class="" scope="col" style="width:200px;">Investigation</th> 
             <th class="" scope="col" style="width:70px;">Rate</th> 
			<th class="" scope="col" style="width:50px;">Detail</th> 
</tr>

       <#
       
              var dataLength=PackageData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = PackageData[j];
         
            #>
                    <tr id="Tr3" >
<td class="" style="text-align:center;"><#=j+1#></td>
<td id="td8"  class="" style="text-align:left;display:none; font: 12px arial, sans-serif"><#=objRow.Investigation_Id#></td>

<td id="td11"  class="" style="text-align:left;font: 12px arial, sans-serif"><#=objRow.TestCode#></td> 
<td id="td12"  class="" style="text-align:left;font: 12px arial, sans-serif""><#=objRow.NAME#></td>
<td id="td13"  class="" style="text-align:left;font: 12px arial, sans-serif""><#=objRow.Rate#></td>
<td class="" style="text-align:center;cursor:pointer;"><img id="img2" src="../../App_Images/Post.gif"   
    onclick="ShowInvDetail('<#=objRow.NAME#>','<#=objRow.Rate#>','<#=objRow.TestCode#>','<#=objRow.Investigation_Id#>')" /></td>
</tr>

            <#}#>

        </table>    
    </script>
    <script id="tb_divObser" type="text/html">
        <table cellspacing="0" rules="all" border="1" id="tbl_divObser" class="myTable" style="border-collapse:collapse; cursor: move;width:99.6%" >
		<tr id="Tr4" class="nodrop">
			<th class="" scope="col" style="width:20px;">S.No.</th>
             <th class="" scope="col" style="width:70px;">Observation</th>
            <th class="" scope="col" style="width:200px;display:none;">Investigation ID</th>
            <th class="" scope="col" style="width:200px;display:none;">Observation ID</th>
			
			
</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="Tr5" >
<td class="" style="text-align:center;"><#=j+1#></td>
                        <td class="" style="text-align:left;"><#=objRow.Parameter#></td>
<td id="td14"  class="" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.Investigation_Id#></td>
<td id="td15"  class="" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.LabObservation_ID#></td>
<%--<td id="td16"  class="" style="text-align:left;font: 12px arial, sans-serif"><#=objRow.Investigation#></td>--%>
</tr>

            <#}#>

     </table> 
         <div id="div1" style="display:none;overflow: auto; height: 400px;">         
        <table id="Table3" class="myTable">
        </table>  
        </div>     
    
    </script>
     <%-- to Obser list--%>
      
    
     <script type="text/javascript">
         function SearchInv() {
             try {
                 $.ajax({
                     url: "ProfileTest.aspx/SearchInvestigation",
                     data: '{PackageID: "' + $('#<%=lblPackageID.ClientID %>').html() + '"}', // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         PatientData = eval('[' + result + ']'); 
                         $("#btnSaveInvestigation").show(); 
                         var output = $('#tb_InvestigationItems').parseTemplate(PatientData); 
                         $('#div_InvestigationItems').html(output); 
                     },
                     error: function (xhr, status) {
                         showErrorAlert("Error ");
                         // window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }
             catch (e) {
                 console.log(e);
                 showErrorAlert(e);
             }
         }

         function SearchObservation() {
             try {
                 $.ajax({
                     url: "ProfileTest.aspx/SearchObservation",
                     data: '{InvID: "' + $('#<%=lblInvestigation.ClientID %>').html() + '"}', // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         PatientData = eval('[' + result + ']');
                         var output = $('#tb_divObser').parseTemplate(PatientData);
                         $('#DivObser').html(output); 
                     },
                     error: function (xhr, status) {
                         showErrorAlert("Error "); 
                     }
                 });
             }
             catch (e) {
                 console.log(e);
                 showErrorAlert(e);
             }
         }
        </script>
</asp:Content>

