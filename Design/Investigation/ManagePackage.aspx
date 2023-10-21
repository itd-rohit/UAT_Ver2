<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ManagePackage.aspx.cs" Inherits="Design_Investigation_ManagePackage"  %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
      <script src="../../Scripts/jquery.tablednd.js" type="text/javascript"></script>  
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
            $('.chosen-container').css('width', '230px');
        });
		
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
                var i=0;

                var content = '<table border="0" cellspacing="1" cellpadding="1" class="toolTip"><tr><td bgcolor="' + fg + '">';
                content = content + '<table border="0" cellspacing="1" cellpadding="1"> ';

                if (data.length <= 5) {
                    for (i = 0; i < data.length; i++)
                    {
                        if (!fg) fg = "#000000";
                        if (!bg) bg = "#ffffff";
                        content = content + '<tr><td bgcolor="#dcdcdc">';
                        content = content + '<font face="sans-serif" color="' + fg + '" size="-1">' + eval(i + 1) + ') ' + data[i] + '&nbsp;&nbsp;';
                        content = content + '</font></td></tr>';
                    }
                }
                else
                {

                    for (i = 0; i < data.length; ) {
                        if (!fg) fg = "#000000";
                        if (!bg) bg = "#ffffff";
                        content = content + '<tr bgcolor="#dcdcdc">';
                        content = content + '<td bgcolor="#dcdcdc"><font face="sans-serif" color="' + fg + '" size="-1">' + eval(i + 1) + ') ' + data[i] + '&nbsp;&nbsp;</font></td>';

                        if (i + 1 < data.length)
                        {
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

                if (msg == "")
                {
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
         function SavePackageOrdering() {
             
             var PackageOrder = "";
             $("#tbl_GetPackageList tr").each(function () {
                 if ($(this).closest("tr").prop("id") != "Header") {
                     PackageOrder += $(this).closest("tr").prop("id") + '#';
                 }
             });
             if (PackageOrder == "") {
                 alert("Try Again Later");
                 return;
             }
             $.ajax({
                 url: "ManagePackage.aspx/SavePackageOrdering",
                 data: '{PackageOrder: "' + PackageOrder + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     var pac = result.d;
                     if (pac == "-1") {
                         alert("Your Session Expired...Pleas Login Again");
                         return;
                     }
                     else if (pac == "0") {
                         alert("Something Went Wrong..Please Try Again Later");
                         return;
                     }
                     else {
                         GetPackageList();
                         alert('Package Ordering Saved Successfully');
                     }
                 },
                 error: function (xhr, status) {
                     alert("Please contact to Admin");
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
     </script>
    <script type="text/javascript">
        $(function () {
            $("#ChkInActive").click(function () {
                clearform(); 
                GetPackageList();
            });                 
            $("#btnSaveInvestigation").hide();
            GetPackageList();
        });
        

        </script>
   
    <script type="text/javascript">
        var URl = "";
        var InvestigationID = "";
        var ItemID = "";
        var ReportTypeNo = ""; 
        function ShowPackageDetail(PackageTitle, Rate, TestCode, PackageID, CreatedBy, CreatedOn, ItemID, IsActive, ShowInReport, FromAge, ToAge, Gender,BaseRate) {
            //nirmal
            document.getElementById('chkNewInv').checked = false;
            // document.getElementById('flInvestigationDetails').style.visibility = 'visible';
            $('#flInvestigationDetails').show();
            document.getElementById('<%=txtPackageTitle.ClientID %>').value = PackageTitle;
            document.getElementById('<%=txtRate.ClientID %>').value = Rate;
            document.getElementById('<%=txtTestCode.ClientID %>').value = TestCode; 
            document.getElementById('<%=txtBaseRate.ClientID %>').value = BaseRate; 
            document.getElementById('<%=txtFromage.ClientID %>').value = FromAge; 
            document.getElementById('<%=txtToage.ClientID %>').value = ToAge;
            document.getElementById('<%=ddlGender.ClientID %>').value = Gender;
           
            $('#<%=lblPackageID.ClientID %>').html(PackageID);         
            $('#<%=lblCreatedBy.ClientID %>').html(CreatedBy); 
            $('#<%=lblCreatedOn.ClientID %>').html(CreatedOn);
            $('#<%=lblItemID.ClientID %>').html(ItemID);
            $("#div_PackageNameHead").html("Package Name :" + PackageTitle);
            $("#div_PackageNameHead").css("display", "");
            $("#div_PackageNameHead").css("color", "green");
            if (IsActive == "1") {
                document.getElementById('<%=chkIsActive.ClientID %>').checked = true;
            }
            else {
                document.getElementById('<%=chkIsActive.ClientID %>').checked = false;
            }
            if (ShowInReport == "1") {
                document.getElementById('<%=chkShowInReport.ClientID %>').checked = true;
             }
             else {
                 document.getElementById('<%=chkShowInReport.ClientID %>').checked = false;
             }
            SearchInv();
        }
        function GetPackageList() {
            try {
                var InActive = $("#ChkInActive").is(':checked') ? 0 : 1;
                

                var OrderBy = "plm.name";

                $.ajax({
                    url: "ManagePackage.aspx/GetPackageList",
                    data: '{OrderBy: "' + OrderBy + '",Status:"' + InActive + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async:false,
                    success: function (result) {
                       
                        PackageData = jQuery.parseJSON(result.d);
                        
                        var output = $('#tb_GetPackageList').parseTemplate(PackageData);
                        $('#div_GetPackageList').html(output);

                        $('#div_GetPackageList').html(output);
                        $("#tbl_GetPackageList").tableDnD({
                            onDragClass: "GridViewDragItemStyle"
                        });
                        $('#tbl_GetPackageList tr:even').addClass("GridViewAltItemStyle");

                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            catch (e) {
                console.log(e);
                alert(e);
            }
        }
         </script>
   
  
   
    <div id="toolTipLayer" style="position:absolute; visibility: hidden;left:0;right:0"></div>
    <div id="Pbody_box_inventory" style="width: 97%; text-align: left;">
        <div class="POuter_Box_Inventory" style="width: 99.6%;">
            <cc1:ToolkitScriptManager runat="server" ID="sc"></cc1:ToolkitScriptManager>
            <div class="content">
                <div style="text-align: center;">
                    <b>Package Manager<br />
                    </b>
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%; text-align: left;height:615px">
            <div class="Purchaseheader">Package Detail</div>
            <div style="height: 380px; width: 99.6%;" class="content">
                <table cellpadding="0" cellspacing="0" style="height: 330px; width: 99.6%;">
                    <tr style="width: 99.6%">
                        <td colspan="9" style="height: 22px">
                            <input id="chkNewInv" type="checkbox" onclick="hideShowPackage()" />New Package
                            <input id="ChkInActive" type="checkbox" />In-Active 
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
                        <td colspan="9" style="height: 22px">
                            <div id="div_PackageNameHead" style="font-size: medium; font-weight: bold;"></div>
                        </td>

                    </tr>
                    <tr style="vertical-align: top;">
                        <td width="30%" style="vertical-align: top">
                            <fieldset class="f1" style="Height: 500px">
                                <legend class="lgd">Avail Package</legend>
                                <script type="text/javascript">
                                    $(document).ready(function () {
                                        $("#myInput").on("keyup", function () {
                                            var value = $(this).val().toLowerCase();
                                            $("#tbl_GetPackageList tr").filter(function () {
                                                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                                            });
                                        });
                                    });
                                    </script>
                                <input id="myInput" type="text" placeholder="Search.." /><br /><br />
                                 <div id="div_GetPackageList" style="max-height:480px;overflow-y: auto; overflow: auto;"></div>
                            </fieldset>
                            <div class="clear:both">&nbsp;</div>
                          &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; 
                             <input type="button" value="Save Package Ordering" class="ItDoseButton" id="btnSavePackageOrdering" onclick="SavePackageOrdering();"/>
                            
                        </td>

                        <td style="width:20%; vertical-align: top">
                            <fieldset class="f1" style="height: 500px; vertical-align: top;">
                                <legend class="lgd">Description</legend>
                                <table style="width: 100%; height: 277px;">
                                    <tr>
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Name:</label><asp:TextBox ID="txtPackageTitle" runat="server"  MaxLength="100" Width="150px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">From Age (In Days):</label>
                                            <asp:TextBox ID="txtRate" style="display:none"  runat="server"  MaxLength="100" Width="150px"></asp:TextBox>
                                            <asp:TextBox ID="txtFromage" runat="server" MaxLength="5"  Width="150px"  Text="0" ClientIDMode="Static"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="ftbFromAge" runat="server" TargetControlID="txtFromage" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                         <label class="labelForTag" style="width: 100px">To Age (In Days):</label>
                                            <asp:TextBox ID="txtToage" runat="server" MaxLength="5"   Width="150px"  Text="70000" ClientIDMode="Static"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="ftbToAge" runat="server" TargetControlID="txtToage" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td>
                                             <label class="labelForTag" style="width: 100px">Gender:</label>
                                            <asp:DropDownList ID="ddlGender" runat="server" Width="150px">
                                                <asp:ListItem Value="B" Text="Both"></asp:ListItem>
                                                <asp:ListItem Value="M" Text="Male"></asp:ListItem>
                                                <asp:ListItem Value="F" Text="Female"></asp:ListItem>
                                            </asp:DropDownList>
                                             </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Code:</label><asp:TextBox ID="txtTestCode" runat="server" Width="150px"  MaxLength="100"></asp:TextBox></td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Base Rate:</label><asp:TextBox ID="txtBaseRate" runat="server" Width="150px"  MaxLength="100"></asp:TextBox>
                                             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" TargetControlID="txtBaseRate"  >
                            </cc1:FilteredTextBoxExtender>
                                        </td>
                                    </tr>
                                      <tr style="display:none;">
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Created By:</label><asp:Label ID="lblCreatedBy" runat="server" ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr style="display:none;">
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Created On:</label><asp:Label ID="lblCreatedOn" runat="server" ></asp:Label>
                                        </td>
                                    </tr>
                                     <tr style="display:none;">
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Updated By:</label><asp:Label ID="lblUpdatedBy" runat="server" ></asp:Label>
                                        </td>
                                    </tr>
                                     <tr style="display:none;">
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Updated On:</label><asp:Label ID="lblUpdatedOn" runat="server" ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Item ID :</label><asp:Label ID="lblItemID" runat="server" ></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 100px">Package ID :</label><asp:Label ID="lblPackageID" runat="server" ></asp:Label>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td valign="top">
                                            <asp:CheckBox ID="chkIsActive" runat="server"  Text="Is-Active" ForeColor="Red"></asp:CheckBox>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td valign="top">
                                            <asp:CheckBox ID="chkShowInReport" runat="server"  Text="Show In Report" ForeColor="Red"></asp:CheckBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" style="text-align:center;">
                                            
                                             <input id="btnSaveNewPackage" type="button" class="ItDoseButton" value="Save Package" onclick="SaveNewPackage();"  style="display:none;"/>
                                        </td>

                                    </tr>
                                </table>
                            </fieldset>
                        </td>
                       
                        <td style="width: 50%; vertical-align: top" id="tdInvDetails">
                            <div class="f1" style="height: 500px; vertical-align: top;" id="flInvestigationDetails">
                            
                                <legend class="lgd">Investigation Details</legend>
                                <table style="width: 100%">
                                    <tr>
                                        <td valign="top">
                                            <label class="labelForTag" style="width: 110px">Investigation :</label><asp:DropDownList ID="ddlAddInv" runat="server" CssClass="chosen-select" Width="230px"></asp:DropDownList>
                                            <img id="img_AddInv" alt="Add Investigation" src="../../App_Images/Post.gif" onclick="AddInvestigation()" />
                                        </td>
                                        <td>
                                            <label class="labelForTag" style="width: 100px">Package :</label><asp:DropDownList ID="ddAddPackage" runat="server" CssClass="chosen-select" Width="225px"></asp:DropDownList>
                                            <img id="img_AddPackage" alt="Add Package" src="../../App_Images/Post.gif" onclick="AddPackage()" /></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" colspan="2">
                                            <div id="div_InvestigationItems" style="max-height:435px;overflow-y: auto; overflow: auto;"></div>
                                        </td>
                                      
                                    </tr>
                                     
                                </table>
                           <%-- </fieldset>--%>
                                </div>
                             <input id="btnSaveInvestigation" type="button" class="ItDoseButton" value="Save" onclick="SaveRequest()" style="width:100px;"/>
                        </td>
                          
                    </tr>
                </table>
            </div>
        </div>
        <script type="text/javascript">
            function hideShowPackage() {
                clearform();
                if ($("#chkNewInv").is(':checked')) {
                    $("#btnSaveNewPackage").show();
                    $("#btnSaveInvestigation").hide();
                    $("#flInvestigationDetails").hide();
                    document.getElementById('<%=chkShowInReport.ClientID %>').checked = true;
                    document.getElementById('<%=chkIsActive.ClientID%>').checked = true;
                   numbertestcode();
                    $("#txtFromage").val(0);
                    $("#txtToage").val(70000);
                   
                }
                else {
                    $("#btnSaveNewPackage").hide();                   
                    $("#flInvestigationDetails").show();
                    document.getElementById('<%=chkShowInReport.ClientID %>').checked = true;
                    document.getElementById('<%=chkIsActive.ClientID%>').checked = true;

                }
            }
			function numbertestcode() {
                $.ajax({
                    url: "ManagePackage.aspx/testcodenumber", // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    asylc:false,
                    success: function (result) {
                        var pac = result.d;
                        $("#ContentPlaceHolder1_txtTestCode").val(pac);
                        
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            
        </script>
    </div>

     <script id="tb_GetPackageList" type="text/html">
        <table cellspacing="0" rules="all" border="1" id="tbl_GetPackageList"  style="border-collapse:collapse; cursor: move;width:99.6%" >
		<tr id="Header" class="nodrop">
			<th class="exporttoexcelheader" scope="col" style="width:20px;">S.No.</th>
            <th class="exporttoexcelheader" scope="col" style="width:70px;display:none;">Item ID</th>
            <th class="exporttoexcelheader" scope="col" style="width:70px;display:none;">Package ID</th>
            <th class="exporttoexcelheader" scope="col" style="width:70px;display:none;">Test Code</th>
            <th class="exporttoexcelheader" scope="col" style="width:200px;">Package</th>  
			<th class="exporttoexcelheader" scope="col" style="width:50px;">Detail</th>
            <th class="exporttoexcelheader" scope="col" style="width:50px;">Rate</th> 
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
<td class="exporttoexcel"><#=j+1#></td>
<td id="td3"  class="exporttoexcel" style="text-align:left;display:none; font: 12px arial, sans-serif"><#=objRow.ItemID#></td>
<td id="td6"  class="exporttoexcel" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.PlabID#></td> 
<td id="td4"  class="exporttoexcel" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.TestCode#></td> 
<td id="td5"  class="exporttoexcel" style="text-align:left;font: 12px arial, sans-serif""><#=objRow.TestCode#> ~ <#=objRow.NAME#></td>
<td class="exporttoexcel" style="text-align:left;cursor:pointer;"><img id="img1" src="../../App_Images/Post.gif"   
    onclick="ShowPackageDetail('<#=objRow.NAME#>','<#=objRow.Rate#>','<#=objRow.TestCode#>','<#=objRow.PlabID#>','<#=objRow.CreatedBy#>','<#=objRow.CreatedOn#>','<#=objRow.ItemID#>','<#=objRow.IsActive#>','<#=objRow.ShowInReport#>','<#=objRow.FromAge#>','<#=objRow.ToAge#>','<#=objRow.Gender#>','<#=objRow.BaseRate#>')" /></td>
<td class="exporttoexcel" style="text-align:left;cursor:pointer;"><img id="img2" src="../../App_Images/view.gif" onclick="openmeRate('<#=objRow.ItemID#>')"></td>
</tr>

            <#}#>

        </table>    
    </script>
    <script id="tb_InvestigationItems" type="text/html">
        <table cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"  style="border-collapse:collapse; cursor: move;width:99.6%" >
		<tr id="Tr1" class="nodrop">
			<th class="exporttoexcelheader" scope="col" style="width:20px;">S.No.</th>
            <th class="exporttoexcelheader" scope="col" style="width:200px;display:none;">Package ID</th>
            <th class="exporttoexcelheader" scope="col" style="width:200px;display:none;">Investigation ID</th>
			<th class="exporttoexcelheader" scope="col" style="width:200px;">Investigation</th>
            <th class="exporttoexcelheader" scope="col" style="width:10px;text-align:center">Sample Collect</th>
            <th class="exporttoexcelheader" scope="col" style="width:10px;text-align:center">Print Separate</th>
			<th class="exporttoexcelheader" scope="col" style="width:50px;text-align:center">Remove</th> 
</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=objRow.Investigation_Id#>"  onMouseOver='show("<#=objRow.ParameterName#>");' onMouseOut="toolTip()"  >
<td class="exporttoexcel"><#=j+1#></td>
<td id="td2"  class="exporttoexcel" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.PlabId#></td>
<td id="td1"  class="exporttoexcel" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.Investigation_Id#></td>
<td id="td_PLabID"  class="exporttoexcel" style="text-align:left;font: 12px arial, sans-serif"><#=objRow.Investigation#></td>
                        <td id="td8"  class="exporttoexcel" style="text-align:center;">
                            <#if(objRow.SampleDefinedPackage=="1"){#>
                            <input type="checkbox" id="chksampledefined" checked="checked" />
                            <#}else{#>
                              <input type="checkbox" id="chksampledefined" />
                            <#}#>
                        </td>
                        <td id="td7"  class="exporttoexcel" style="text-align:center;">
                            <#if(objRow.PrintSeprate=="1"){#>
                            <input type="checkbox" id="chkPrintSeprate" checked="checked" />
                            <#}else{#>
                              <input type="checkbox" id="chkPrintSeprate" />
                            <#}#>
                        </td>
<td class="exporttoexcel" style="cursor:pointer;text-align:center"><img id="imgRmv" src="../../App_Images/Post.gif"   onclick="RemoveInvestigation('<#=objRow.Investigation_Id#>')" /></td>
</tr>

            <#}#>

     </table>    
    </script>
      <script type="text/javascript">
          function SaveRequest() {

              if ($('#<%=lblPackageID.ClientID %>').html() == "") {
                alert("Please Select the Package");
            }

            if ($.trim($("#<%=txtPackageTitle.ClientID%>").val()) == "") {
                alert('Please Enter Package Name');
                $("#<%=txtPackageTitle.ClientID%>").focus();
                return;
            }
            if ($.trim($("#<%=txtFromage.ClientID%>").val()) == "") {
                alert('Please Enter From Age');
                $("#<%=txtFromage.ClientID%>").focus();
                return;
            }
            if ($.trim($("#<%=txtToage.ClientID%>").val()) == "" || $.trim($("#<%=txtToage.ClientID%>").val()) == "0") {
                alert('Please Enter To Age');
                $("#<%=txtToage.ClientID%>").focus();
                return;
            }
            if ((parseFloat($("#<%=txtFromage.ClientID%>").val())) > (parseFloat($("#<%=txtToage.ClientID%>").val()))) {
                alert('Please Enter Valid To Age');
                $("#<%=txtToage.ClientID%>").focus();
                return;
            }
              if ($.trim($("#<%=txtTestCode.ClientID%>").val()) == "") {
                  alert('Please Enter Test Code');
                  $("#<%=txtTestCode.ClientID%>").focus();
                 return;
             }

              $("#btnSaveInvestigation").attr('disabled', 'disabled').val('Submitting...');
            var ObsOrder = "";
            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).closest("tr").prop("id") != "Tr1") {
                    ObsOrder += $(this).closest("tr").prop("id") + '#';
                }
            });
            if (ObsOrder == "") {
                alert("Try Again Later");
                $("#btnSaveInvestigation").removeAttr('disabled').val('Save');
                return;
            }
            var IsActive = $("#<%= chkIsActive.ClientID %>").is(':checked') ? 1 : 0;


            var ShowInReport = $("#<%= chkShowInReport.ClientID %>").is(':checked') ? 1 : 0;

            var PrintSeprateData = "";
            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).closest("tr").prop("id") != "Tr1") {
                    if ($(this).closest("tr").find("#chkPrintSeprate").is(":checked")) {
                        PrintSeprateData += $(this).closest("tr").prop("id") + '_1#';
                    }
                    else {
                        PrintSeprateData += $(this).closest("tr").prop("id") + '_0#';
                    }
                }
            });

            var sampledefinedata = "";
            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).closest("tr").prop("id") != "Tr1") {
                    if ($(this).closest("tr").find("#chksampledefined").is(":checked")) {
                        sampledefinedata += $(this).closest("tr").prop("id") + '_1#';
                    }
                    else {
                        sampledefinedata += $(this).closest("tr").prop("id") + '_0#';
                    }
                }
            });
            var BaseRate = ($('#<%=txtBaseRate.ClientID %>').val() == '' ? '0' : $('#<%=txtBaseRate.ClientID %>').val());
            $.ajax({
                url: "ManagePackage.aspx/SaveOrdering",
                data: '{PackageID: "' + $('#<%=lblPackageID.ClientID %>').html() + '",ObsData:"' + ObsOrder + '",PackageName:"' + $("#<%=txtPackageTitle.ClientID %>").val() + '",ItemID:"' + $("#<%=lblItemID.ClientID %>").html() + '",IsActive:"' + IsActive + '",Rate:"' + $("#<%=txtRate.ClientID %>").val() + '",Code:"' + $("#<%=txtTestCode.ClientID %>").val() + '",ShowInReport:"' + ShowInReport + '",PrintSeprateData:"' + PrintSeprateData + '",FromAge:"' + $("#<%=txtFromage.ClientID%>").val() + '" ,ToAge:"' + $("#<%=txtToage.ClientID%>").val() + '", Gender:"' + $('#<%=ddlGender.ClientID%>').val() + '",sampledefinedata:"' + sampledefinedata + '",BaseRate:"' + BaseRate + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "-1") {
                        alert("Your Session Expired...Pleas Login Again");
                        
                       
                    }
                    else if (result.d == "-3") {
                        alert("Package Code Already Exist");


                    }
                    else if (result.d == "0") {
                        alert("Something Went Wrong..Please Try Again Later");
                        
                       
                    }
                    else if (result.d == "1") {
                        GetPackageList();
                        SearchInv();
                       
                        alert('Record Saved Successfully');
                    }
                    $("#btnSaveInvestigation").removeAttr('disabled').val('Save');
                },
                error: function (xhr, status) {
                    alert("Please contact to Admin");
                    $("#btnSaveInvestigation").removeAttr('disabled').val('Save');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        </script>
    <script type="text/javascript">
        function AddPackage() {
            if ($("#<%=ddAddPackage.ClientID%>").val() == "") {
                alert("Please Select the Package");
                return;
            }
            $.ajax({
                url: "ManagePackage.aspx/AddPackage",
                data: '{PackageID: "' + $("#<%=lblPackageID.ClientID%>").html() + '",NewPackageID:"' + $("#<%=ddAddPackage.ClientID%>").val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "-1") {
                        alert("Your Session Expired...Pleas Login Again");
                        return;
                    }
else if (result.d.split('#')[0] == "-0") {
                        alert(result.d.split('#')[1]);
                        return;
                    }
                    else if (result.d == "0") {
                        alert("Something Went Wrong..Please Try Again Later");
                        return;
                    }
                    else if (result.d == "1") {
                        
                        SearchInv();
                    }
                },
                error: function (xhr, status) {
                    alert("Please contact to Admin");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function RemoveInvestigation(InvestigationID) {
            $.ajax({
                url: "ManagePackage.aspx/RemoveInvestigation",
                data: '{PackageID: "' + $("#<%=lblPackageID.ClientID%>").html() + '",InvestigationID:"' + InvestigationID + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "-1") {
                        alert("Your Session Expired...Pleas Login Again");
                        return;
                    }
                    else if (result.d == "0") {
                        alert("Something Went Wrong..Please Try Again Later");
                        return;
                    }
                    else if (result.d == "1") {
                        
                        SearchInv();
                    }
                },
                error: function (xhr, status) {
                    alert("Please contact to Admin");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function AddInvestigation() {
            if ($("#<%=ddlAddInv.ClientID%>").val() == "") {
                alert("Please Select the Investigation");
                return;
            }
            $.ajax({
                url: "ManagePackage.aspx/AddInvestigation",
                data: '{PackageID: "' + $("#<%=lblPackageID.ClientID %>").html() + '",InvestigationID:"' + $("#<%=ddlAddInv.ClientID%>").val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "-1") {
                        alert("Your Session Expired...Pleas Login Again");
                        return;
                    }
else if (result.d.split('#')[0] == "-0") {
                        alert(result.d.split('#')[1]);
                        return;
                    }
                    else if (result.d == "2") {
                        alert(" Investigation Already Added");
                        return;
                    }
                    else if (result.d == "0") {
                        alert("Something Went Wrong..Please Try Again Later");
                        return;
                    }
                    else if (result.d == "1") {
                       
                        SearchInv();
                    }
                },
                error: function (xhr, status) {
                    alert("Please contact to Admin");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>
     <script type="text/javascript">
         function SearchInv() {
             try {
                 $.ajax({
                     url: "ManagePackage.aspx/SearchInvestigation",
                     data: '{PackageID: "' + $('#<%=lblPackageID.ClientID %>').html() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                        // if (PatientData.length > 0) {
                        $("#btnSaveInvestigation").show();
                        //}
                        // else {
                        //      $("#btnSaveInvestigation").hide();
                        // }
                        var output = $('#tb_InvestigationItems').parseTemplate(PatientData);

                        $('#div_InvestigationItems').html(output);

                        //$('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");

                        $('#div_InvestigationItems').html(output);
                        $("#tb_grdLabSearch").tableDnD({
                            onDragClass: "GridViewDragItemStyle"
                        });
                        $('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        // window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            catch (e) {
                console.log(e);
                alert(e);
            }
         }
         function clearform() {

             $('#<%=txtPackageTitle.ClientID%>').val('');
             $('#<%=txtRate.ClientID%>').val('');
             $('#<%=txtFromage.ClientID%>').val('');
             $('#<%=txtToage.ClientID%>').val('');
             $('#<%=ddlGender.ClientID%>').val('B');
              $('#<%=txtTestCode.ClientID%>').val('');
             $('#<%=txtBaseRate.ClientID%>').val('');
             $("#<%=lblPackageID.ClientID%>").html('');
             $("#<%=lblCreatedBy.ClientID%>").html('');
             $("#<%=lblCreatedOn.ClientID%>").html('');
             $("#<%=lblItemID.ClientID%>").html('');
             $("#div_PackageNameHead").html('');
             $('#div_InvestigationItems').html('');
         }
        </script>
     <script type="text/javascript">
         function SaveNewPackage() {

             if ($.trim($("#<%=txtPackageTitle.ClientID%>").val()) == "") {
                alert('Please Enter Package Name');
                $("#<%=txtPackageTitle.ClientID%>").focus();
               return;
           }
           if ($.trim($("#<%=txtFromage.ClientID%>").val()) == "") {
                alert('Please Enter From Age');
                $("#<%=txtFromage.ClientID%>").focus();
                return;
            }
            if ($.trim($("#<%=txtToage.ClientID%>").val()) == "" || $.trim($("#<%=txtToage.ClientID%>").val()) == "0") {
                alert('Please Enter To Age');
                $("#<%=txtToage.ClientID%>").focus();
                return;
            }
            if ((parseFloat($("#<%=txtFromage.ClientID%>").val())) > (parseFloat($("#<%=txtToage.ClientID%>").val()))) {
                alert('Please Enter Valid To Age');
                $("#<%=txtToage.ClientID%>").focus();
                return;
            }
             if ($.trim($("#<%=txtTestCode.ClientID%>").val()) == "") {
                 alert('Please Enter Test Code');
                 $("#<%=txtTestCode.ClientID%>").focus();
                return;
            }
             $("#btnSaveNewPackage").attr('disabled', 'disabled').val('Submitting...');
            var ShowInReport = $("#<%= chkShowInReport.ClientID %>").is(':checked') ? 1 : 0;
            var BaseRate = ($('#<%=txtBaseRate.ClientID %>').val() == '' ? '0' : $('#<%=txtBaseRate.ClientID %>').val());
            $.ajax({
                url: "ManagePackage.aspx/SaveNewPackage",
                data: '{PackageName: "' + $("#<%=txtPackageTitle.ClientID%>").val() + '",Rate:"' + $("#<%=txtRate.ClientID%>").val() + '",TestCode:"' + $("#<%=txtTestCode.ClientID%>").val() + '",ShowInReport:"' + ShowInReport + '",FromAge:"' + $("#<%=txtFromage.ClientID%>").val() + '",ToAge:"' + $('#<%=txtToage.ClientID%>').val() + '",Gender:"' + $('#<%=ddlGender.ClientID%>').val() + '",BaseRate:"' + BaseRate + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async:false,
                success: function (result) {
                    var pac = result.d;
                    if (pac == "-1") {
                        alert("Your Session Expired...Pleas Login Again");
                        
                    }
                    else if (pac == "0") {
                        alert("Something Went Wrong..Please Try Again Later");
                        
                    }
                    else if (pac == "-2") {
                        alert("Package Name Already Exist..Please Create Package With Another Name");
                       
                    }
                    else if (pac == "-3") {
                        alert("Package Code Already Exist");

                    }
                    else {
                        $("#<%=lblPackageID.ClientID%>").html(pac.split('#')[1]);
                        $("#<%=lblItemID.ClientID%>").html(pac.split('#')[0]);
                        $("#btnSaveNewPackage").hide();
                        document.getElementById('chkNewInv').checked = false;
                        //  document.getElementById('flInvestigationDetails').style.visibility = 'visible';
                        $('#flInvestigationDetails').show();
                        alert('Package Created Successfully');
                        clearform();
                        GetPackageList();

                       
                    }
                    $("#btnSaveNewPackage").removeAttr('disabled').val('Save Package');
                },
                error: function (xhr, status) {
                    alert("Please contact to Admin");
                    $("#btnSaveNewPackage").removeAttr('disabled').val('Save Package');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }




         function openmeRate(itemid) {
             var url = "PackageRateMaster.aspx?itemid=" + itemid;
             window.open(url, '_blank', "");
         }

        </script>
</asp:Content>
