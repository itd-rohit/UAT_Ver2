<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditObservationDetail.aspx.cs" Inherits="Design_Investigation_EditObservationDetail" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
          <%: Scripts.Render("~/bundles/WebFormsJs") %>

    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
  <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
       
    
    
</head>
<body style="padding:0px 0px 0px 0px;">
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="sm1" runat="server" />
     <div id="Pbody_box_inventory" style="text-align:center;width:1016px;" >
        <div class="POuter_Box_Inventory" style="width:1012px;">
    
    <b>Edit Observation Detail&nbsp;</b>
     <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal">
           <asp:ListItem Selected="True" Value="M">Range for Male</asp:ListItem>
           <asp:ListItem Value="F">Range for Female</asp:ListItem>
       </asp:RadioButtonList> </div>
   
   <div class="POuter_Box_Inventory" style="width:1012px;">
      <div class="Purchaseheader">Observation Details</div>
       <table style="width:100%;border-collapse:collapse">
           <tr>
               <td style="text-align:right">
                   Observation Name :&nbsp;
               </td>
               <td style="text-align:left">
                   <input id="txtObservation"  type="text" style="width:204px" />
               </td>
               <td colspan="2" style="text-align:left">
                   <input id="chkIsCulture" type="checkbox" style="visibility:hidden"  checked="CHECKED" /><input id="chkAnylRpt"  type="checkbox" /> Show in Analysis Report
               </td>
           </tr>
           <tr>
               <td style="text-align:right">
                   Short Name :&nbsp;
               </td>
               <td style="text-align:left">
                   <input id="txtShortName"  type="text" style="width:204px" />
               </td>
                <td colspan="2" style="text-align:left">
                    <input id="chkMaleFemale" type="checkbox" checked="checked" />Range for Male & Female both <input id="chkSetRngForAllInv" type="checkbox" style="display:none;" />
                    </td>
           </tr>
            <tr>
               <td style="text-align:right">
                   Suffix :&nbsp;
                   </td>
                <td style="text-align:left">
                    <input id="txtSuffix"  type="text" style="width:204px" />
                </td>
               <td style="text-align:right">
                    Centre Name  :&nbsp;
                </td>
                <td style="text-align:left">
                     <asp:DropDownList ID="ddlCentre" runat="server"  Width="160px"></asp:DropDownList>
                     <input id="chkAllCentre" type="checkbox" />For All Centre</td>
                </tr>
           <tr>
               <td style="text-align:right">
                   <input id="chkMethod" type="checkbox" checked="CHECKED" />Method Name :&nbsp;
               </td>
               <td style="text-align:left">
                   <input id="txtMethodName"  type="text" style="width:204px" maxlength="70" />
               </td>
               <td style="text-align:right">
                   Machine :&nbsp;
               </td>
               <td style="text-align:left">
                   <asp:DropDownList ID="ddlMac" runat="server" Width="160px"></asp:DropDownList><input type="checkbox" id="ResultTobePrint" checked="checked" />Result to be mandatory
               </td>
           </tr>
           <tr>
               <td style="text-align:right">
                   Round Off :&nbsp;
                   </td>
               <td style="text-align:left">
                   <asp:DropDownList ID="ddlRoundOff"  runat="server">
                    <asp:ListItem Value="0">0</asp:ListItem>
                    <asp:ListItem  Value="1">1</asp:ListItem>
                    <asp:ListItem  Value="2" Selected="True">2</asp:ListItem>
                    <asp:ListItem  Value="3">3</asp:ListItem>
                    <asp:ListItem  Value="4">4</asp:ListItem>
                    <asp:ListItem  Value="5">5</asp:ListItem>
                    <asp:ListItem  Value="6">6</asp:ListItem>
                    <asp:ListItem  Value="-1">-1</asp:ListItem>
                    </asp:DropDownList>
               </td>
             <td style="text-align:right">
                   Master Gender :&nbsp;
               </td>
               <td style="text-align:left">
                   <asp:DropDownList ID="ddlGender2" runat="server"  Width="160px">
         <asp:ListItem Value="B">Booking for Both</asp:ListItem>
        <asp:ListItem Value="M">Booking for Male</asp:ListItem>
         <asp:ListItem Value="F">Booking for Female</asp:ListItem>
        </asp:DropDownList>
               </td>
           </tr>
           <tr>
               <td>
                   <asp:CheckBox ID="chkIPrintSeparateOBS" Text="Print Separate" runat="server" /> 
               </td>
               <td>
                   &nbsp;
               </td>
               <td style="text-align:right">
                   Type :&nbsp;
               </td>
               <td style="text-align:left">
                    <asp:DropDownList ID="ddltype" runat="server"  Width="160px">
                        <asp:ListItem >Normal</asp:ListItem>
                          <asp:ListItem >SI</asp:ListItem>
                           </asp:DropDownList>
               </td>
           </tr>
           <tr>
               <td>
                   <asp:CheckBox ID="chkPrintLabReport" Text="Print Lab Report" runat="server" />
               </td>
               <td>
                   <asp:CheckBox ID="chkAllowDubBooking" Text="Allow Duplicate Booking" runat="server" />
               </td>
                <td colspan="2">
                   <asp:CheckBox ID="chkShowAbnormalAlert" Text="Show Abnormal Alert " runat="server" />&nbsp;&nbsp;
                  <asp:CheckBox ID="chkShowDelta" Text="Show Delta Report " runat="server" />
               </td>
           </tr>
       </table>          
         
      </div>
      <div class="Outer_Box_Inventory" style=" width: 1012px;">
           <div class="Purchaseheader">Observation Ranges</div>
    <div id="div_InvestigationItems"  style="max-height:400px;  overflow-y:auto; overflow-x:auto;text-align:center;">              
            </div>
          <input id="btnSave" type="button"  value="Save Ranges" onclick="SaveObsRanges()"/>
            </div>                                    
    </div>
   
    </form>
   
    <script type="text/javascript">
        var ObsDetail = "";
        var ObsId = '';
        var InvId = '';
        $(function () {
            $(':text').bind('blur', function () {
                this.value = this.value.replace(/[\"#|\']/g, '');
            });
            ObsId = '<%=ObsId %>';
            InvId = '<%=InvId%>';
            GetObsMasterData(ObsId);
            GetObservationDetails(InvId, ObsId);
            $('#<%=rblGender.ClientID%>').click(function () {
                GetObservationDetails(InvId, ObsId);
            });
            $('#<%=ddlMac.ClientID%>').change(function () {
                GetObservationDetails(InvId, ObsId);
            });
            $('#<%=ddlCentre.ClientID%>').change(function () {
                GetObservationDetails(InvId, ObsId);
            });
            $('#<%=ddltype.ClientID%>').change(function () {

                GetObservationDetails(InvId, ObsId);
            });
        });
        function GetObsMasterData(ObsId) {
            $.ajax({
                url: "Services/MapInvestigationObservation.asmx/GetObsMasterData",
                data: '{ObservationID: "' + ObsId + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    ObsMasterData = jQuery.parseJSON(result.d);

                    $('#txtObservation').val(ObsMasterData[0].Name);
                    $('#txtShortName').val(ObsMasterData[0].Shortname);
                    $('#txtSuffix').val(ObsMasterData[0].Suffix);
                    $('#ddlRoundOff').val(ObsMasterData[0].RoundUpto);

                    if (ObsMasterData[0].ShowFlag == '1')
                        $('#chkAnylRpt').prop('checked', true)
                    else
                        $('#chkAnylRpt').prop('checked', false)

                    if (ObsMasterData[0].ResultRequired == '1')
                        $('#ResultTobePrint').prop('checked', true)
                    else
                        $('#ResultTobePrint').prop('checked', false)

                    if (ObsMasterData[0].Culture_flag == '1')
                        $('#chkIsCulture').prop('checked', true)
                    else
                        $('#chkIsCulture').prop('checked', false)
                    $('#ddlGender2').val(ObsMasterData[0].Gender);
                    if (ObsMasterData[0].PrintSeparate == '1')
                        document.getElementById('<%=chkIPrintSeparateOBS.ClientID %>').checked = true;
                    else
                        document.getElementById('<%=chkIPrintSeparateOBS.ClientID %>').checked = false;
                    if(ObsMasterData[0].PrintInLabReport=='1')
                        document.getElementById('<%=chkPrintLabReport.ClientID %>').checked = true;
                    else
                        document.getElementById('<%=chkPrintLabReport.ClientID %>').checked = false;
                    if (ObsMasterData[0].AllowDuplicateBooking == '1')
                        document.getElementById('<%=chkAllowDubBooking.ClientID %>').checked = true;
                      else
                          document.getElementById('<%=chkAllowDubBooking.ClientID %>').checked = false;
                    
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function GetObservationDetails(InvId, ObsId) {
            $.ajax({
                url: "Services/MapInvestigationObservation.asmx/GetObservationDetails",
                data: '{ ObservationID: "' + ObsId + '",InvestigationID: "' + InvId + '",Gender:"' + $('#<%=rblGender.ClientID%> input[type=radio]:checked').val() + '",MacID:"' + $("#<%=ddlMac.ClientID %>").val() + '",MethodName:"' + $("#txtMethodName").val() + '",CentreID:"' + $("#<%=ddlCentre.ClientID %>").val() + '",type:"' + $("#<%=ddltype.ClientID%> option:selected").text() + '" }', // parameter map
                type: "POST", 	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    ObsDetail = jQuery.parseJSON(result.d);
                    var output = $('#tb_InvestigationItems').parseTemplate(ObsDetail);
                    $('#div_InvestigationItems').html(output);                    
                    $("#tb_grdLabSearch tr").find("#imgAdd,#imgRmv").hide();                    
                    $("#tb_grdLabSearch tr:last").find("#imgAdd,#imgRmv").show();
                    tableproperties();                   
                    if (ObsDetail.length == 0) {
                        document.getElementById('<%=chkShowAbnormalAlert.ClientID %>').checked = false;
                        document.getElementById('<%=chkShowDelta.ClientID %>').checked = false;
                        
                        AddnewRow('1', '0');
                        $('#txtMethodName').val("");
                    }
                    else {
                        if (ObsDetail[0].ShowAbnormalAlert == '1')
                            document.getElementById('<%=chkShowAbnormalAlert.ClientID %>').checked = true;
                        else
                            document.getElementById('<%=chkShowAbnormalAlert.ClientID %>').checked = false;

                        if (ObsDetail[0].ShowDeltaReport == '1')
                            document.getElementById('<%=chkShowDelta.ClientID %>').checked = true;
                         else
                            document.getElementById('<%=chkShowDelta.ClientID %>').checked = false;


                        $('#txtMethodName').val(ObsDetail[0].MethodName);
                        if (ObsDetail[0].ShowMethod == '1')
                            $('#chkMethod').prop('checked', true)
                        else
                            $('#chkMethod').prop('checked', false)
                    }
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        };
    </script>
   <script type="text/javascript">
       function tableproperties() {
           $("#tb_grdLabSearch tr").find("#txtToAge,#txtMinReading,#txtMaxReading,#txtMinCritical,#txtMaxCritical").bind('keyup blur', function () {
               this.value = this.value.replace(/[^0-9,-,.]/g, '');
           });
           $("#tb_grdLabSearch tr").find(':text').bind('keyup blur', function () {
               this.value = this.value.replace(/[\"#|\']/g, '');
           });
           $("#tb_grdLabSearch tr").find("#txtMaxReading").blur(function () {
               if (Number(this.value) <= $(this).closest("tr").find("#txtMinReading").val())
                   this.value = '';
           });

           $("#tb_grdLabSearch tr").find("#txtMaxCritical").blur(function () {
               if (Number(this.value) <= $(this).closest("tr").find("#txtMinCritical").val())
                   this.value = '';
           });

       }
       function AddDetail() {

           var count = $("#tb_grdLabSearch tr").length;
           var ToAge = $("#tb_grdLabSearch").find('#tr_' + (count - 1)).find('td:eq(' + 2 + ')').find("#txtToAge").val();
           var frmAge = $("#tb_grdLabSearch").find('#tr_' + (count - 1)).find('td:eq(' + 1 + ')').find("#lblFromAge").text();

           if (ToAge == "") {
               alert('Please enter the Age');
               return;
           }
           var isVisible = $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#txtToAge").is(':visible');

           if (isVisible == true && (Number(ToAge) < Number(frmAge))) {
               alert('ToAge Should be Greater than FromAge');
               return;
           }
           if ($("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#txtMinReading").val() != "" && $("#tb_grdLabSearch tr:last").find('td:eq(' + 4 + ')').find("#txtMaxReading").val()) {
               if (Number($("#tb_grdLabSearch tr:last").find('td:eq(' + 3 + ')').find("#txtMinReading").val()) >= Number($("#tb_grdLabSearch tr:last").find('td:eq(' + 4 + ')').find("#txtMaxReading").val())) {
                   alert('Max Range Should be Greater than MinAge');
                   return;
               }
           }

           if ($("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMinCritical").val() != "" && $("#tb_grdLabSearch tr:last").find('td:eq(' + 6 + ')').find("#txtMaxCritical").val()) {
               if (Number($("#tb_grdLabSearch tr:last").find('td:eq(' + 5 + ')').find("#txtMinCritical").val()) > Number($("#tb_grdLabSearch tr:last").find('td:eq(' + 6 + ')').find("#txtMaxCritical").val())) {
                   alert('Max Critical Should be Greater than MinAge');
                   return;
               }
           }
           $("#tb_grdLabSearch tr:last").find("#imgAdd,#imgRmv").hide();
         
           $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#lblToAge").show();
           $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#lblToAge").text(ToAge);

           $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#txtToAge").hide();
           var frmAgenew = $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#lblToAge").text();
           frmAgenew = Number(frmAgenew) + 1;

           AddnewRow(count, frmAgenew);

       }
       function AddnewRow(count, frmAgenew) {
           var newRow = $('<tr />').attr('id', 'tr_' + count);
           newRow.html('<td class="GridViewLabItemStyle">' + count + '</td><td class="GridViewLabItemStyle"><span id="lblFromAge" >' + frmAgenew + '</span></td><td class="GridViewLabItemStyle"><span id="lblToAge" /><input id="txtToAge" type="text" style="width: 50px" /></td><td class="GridViewLabItemStyle"><input id="txtMinReading" type="text" style="width: 50px" /></td><td class="GridViewLabItemStyle"><input id="txtMaxReading" type="text" style="width: 50px" /></td><td class="GridViewLabItemStyle"><input id="txtMinCritical" type="text" style="width: 50px" /></td><td class="GridViewLabItemStyle"><input id="txtMaxCritical" type="text" style="width: 50px" /></td><td class="GridViewLabItemStyle" style="width:50px;"><input id="txtautoappMin"  style="width:50px;" type="text" value=""/></td><td class="GridViewLabItemStyle" style="width:50px;"><input id="txtautoappMax"  style="width:50px;" type="text" value=""/></td><td class="GridViewLabItemStyle" style="width:50px;"><input id="txtamrmin"  style="width:50px;" type="text" value=""/></td><td class="GridViewLabItemStyle" style="width:50px;"><input id="txtamrmax"  style="width:50px;" type="text" value=""/></td><td class="GridViewLabItemStyle" style="width:50px;"><input id="txtreflexmin"  style="width:50px;" type="text" value=""/></td><td class="GridViewLabItemStyle" style="width:50px;"><input id="txtreflexmax"  style="width:50px;" type="text" value=""/></td><td class="GridViewLabItemStyle"><input id="txtReadingFormat" type="text" style="width: 50px" /></td><td class="GridViewLabItemStyle"><textarea id="txtDisplayReading" style="width: 200px;" /></td><td class="GridViewLabItemStyle"><input id="txtDefaultReading" type="text" style="width: 50px" /></td><td class="GridViewLabItemStyle"><input id="txtAbnormalReading" type="text" style="width: 50px" /></td><td id="imgAdd" class="GridViewLabItemStyle"><img src="../../App_Images/ButtonAdd.png" onclick="AddDetail()" /></td><td id="imgRmv" class="GridViewLabItemStyle"><img src="../../App_Images/Delete.gif" onclick="RmvDetail()" /></td>');
           $("#tb_grdLabSearch").append(newRow);
           tableproperties();
       }
       function RmvDetail() {
           $("#tb_grdLabSearch tr:last").remove();
           // $("#"+rowid).remove();
           $("#tb_grdLabSearch tr:last").find("#imgAdd,#imgRmv").show();
           $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#txtToAge").show();
           $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#lblToAge").hide();
       }
       </script>   
    <script type="text/javascript">
        function SaveObsRanges() {
            var ObsRanges = "";
            var roundOff = $("#ddlRoundOff").val();
            var fromAge = $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#txtToAge").val();
            if (fromAge == "") {
                alert('Age Cannot Be Blank')
                return;
            }
            if ($("#txtSuffix").val().length > 6) {
                alert("Suffix Length Cannot Be More Then 6");
                return;
            }
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#txtToAge").hide();
            $("#tb_grdLabSearch tr:last").find('td:eq(' + 2 + ')').find("#lblToAge").text(fromAge);

            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).closest("tr").prop("id") != "") {
                    var $rowid = $(this).closest("tr");
                    ObsRanges += $rowid.find("#lblFromAge").text() + '|' + $rowid.find("#lblToAge").text() + '|' + $rowid.find("#txtMinReading").val() + '|' + $rowid.find("#txtMaxReading").val() + '|' + $rowid.find("#txtMinCritical").val() + '|' + $rowid.find("#txtMaxCritical").val() + '|' + $rowid.find("#txtReadingFormat").val() + '|' + $rowid.find("#txtDisplayReading").val() + '|' + $rowid.find("#txtDefaultReading").val() + '|' + $rowid.find("#txtAbnormalReading").val() + '|' + $rowid.find("#txtautoappMin").val() + '|' + $rowid.find("#txtautoappMax").val() + '|' + $rowid.find("#txtamrmin").val() + '|' + $rowid.find("#txtamrmax").val() + '|' + $rowid.find("#txtreflexmin").val() + '|' + $rowid.find("#txtreflexmax").val() + '#';
                }
            });

            var ObsId = '<%= Request.QueryString["ObsId"].ToString()%>';
           var IsCriticalhas = "0";         
            if (IsCritical(ObsId)=="1") {
                $("#tb_grdLabSearch tr").each(function () {
                    if ($(this).closest("tr").prop("id") != "") {
                        var $rowid = $(this).closest("tr");
                        if ($rowid.find("#txtMaxCritical").val() == "" || $rowid.find("#txtMaxCritical").val() == "0") {
                            alert('Please Enter Critical Value');
                            IsCriticalhas = "1";
                        }
                    }
                });

               
            }

            if (IsCriticalhas == "1") {
                return;
            }
           
            SaveRanges(ObsRanges);
        }
        function SaveRanges(ObsRanges) {
            $('input').attr('disabled', true);
            var AnylRpt = '0';
            var IsCulture = '0';
            var CheckMethod = '1';
            var MaleFemale = '0';
            var ResultPrint = '0';
            var PrintInLab = '0';
            var AllowDubB = '0';
            var ShowAbnormalAlert = '0';
            var ShowDelta = "0";
            if ($('#chkAnylRpt').is(':checked'))
                AnylRpt = '1';
            if ($('#chkIsCulture').is(':checked'))
                IsCulture = '1';
            var PrintSeparate = '0';

            var urlInfo = '';
            if ($('#chkSetRngForAllInv').is(':checked'))
                urlInfo = "Services/MapInvestigationObservation.asmx/updtObsRanges";
            else
                urlInfo = "Services/MapInvestigationObservation.asmx/updtObsRanges";


            if ($('#chkMethod').is(':checked'))
                CheckMethod = '1';
            else
                CheckMethod = '0';

            if ($('#chkMaleFemale').is(':checked'))
                MaleFemale = '1';
            else
                MaleFemale = '0';


            if ($('#ResultTobePrint').is(':checked'))
                ResultPrint = '1';
            else
                ResultPrint = '0';

            if ($('#<%=chkIPrintSeparateOBS.ClientID %>').is(':checked'))
                PrintSeparate = '1';

            var AllCentre = $('#chkAllCentre').is(':checked') ? 1 : 0;

            if ($('#<%=chkPrintLabReport.ClientID %>').is(':checked'))
                PrintInLab = '1';
            if ($('#<%=chkAllowDubBooking.ClientID %>').is(':checked'))
                AllowDubB = '1';
            if ($('#<%=chkShowAbnormalAlert.ClientID %>').is(':checked'))
                ShowAbnormalAlert = '1';

            if ($('#<%=chkShowDelta.ClientID %>').is(':checked'))
                ShowDelta = '1';
            $.ajax({
                url: "Services/MapInvestigationObservation.asmx/updtObsRanges",
                data: '{ ObservationName: "' + $('#txtObservation').val() + '", ObservationID: "' + ObsId + '",InvestigationID: "' + InvId + '",ObsRangeData:"' + ObsRanges + '",Gender:"' + $('#<%=rblGender.ClientID%> input[type=radio]:checked').val() + '",ShortName: "' + $('#txtShortName').val() + '",Suffix: "' + $('#txtSuffix').val() + '",AnylRpt:"' + AnylRpt + '",IsCulture:"' + IsCulture + '",MacID:"' + $("#<%=ddlMac.ClientID %>").val() + '",RoundOff:"' + $("#<%=ddlRoundOff.ClientID %>").val() + '",MethodName:"' + $('#txtMethodName').val() + '",CheckMethod:"' + CheckMethod + '",MaleFemale:"' + MaleFemale + '",CentreID:"' + $("#<%=ddlCentre.ClientID %>").val() + '",ResultRequired:"' + ResultPrint + '",MasterGender:"' + $("#<%=ddlGender2.ClientID %>").val() + '",PrintSeparate:"' + PrintSeparate + '",Type:"' + $("#<%=ddltype.ClientID%> option:selected").val() + '",AllCentre:"' + AllCentre + '",PrintInLabReport:"' + PrintInLab + '",AllowDuplicateBooking:"' + AllowDubB + '",ShowAbnormalAlert:"' + ShowAbnormalAlert + '",ShowDelta:"' + ShowDelta + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == '1') {
                        alert('Record Saved SuccessFully');
                        $('input').attr('disabled', false);
                    }
                    if (result.d == '0') {
                        alert('Record Not saved');
                        $('input').attr('disabled', false);
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    $('input').attr('disabled', false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }


        function IsCritical(LabObservationID) {
            var val = "0";
            jQuery.ajax({
                url: "EditObservationDetail.aspx/CheckCritical",
                data: '{ LabObservationID: "' + LabObservationID + '" }', // parameter map                     
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async:false,
                success: function (result) {
                    if (result.d == '1') {
                        val= "1";
                    }
                    if (result.d == '0') {
                        val= "0";
                    }
                },
                error: function (xhr, status) {
                    val= "0";
                }
            });
            
            return val;
        }
    </script>

     <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:450px;">
		<tr >
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">From Age</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">To Age</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Min. Reading</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Max. Reading </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Min. Critical</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Max. Critical </th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">AutoApp Min</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">AutoApp Max </th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">AMR Min</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">AMR Max </th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Reflex Min</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Reflex Max </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Unit</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Display Reading</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Default Reading </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Critical Value </th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Add</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;"></th>

			
</tr>
       <#
       
              var dataLength=ObsDetail.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = ObsDetail[j];
        
         
            #>
                    <tr id="tr_<#=j+1#>"  >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="width:50px;"><span id="lblFromAge" ><#=objRow.FromAge#></span></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtToAge"  style="width:50px; display:none;" type="text" value="<#=objRow.ToAge#>"/><span id="lblToAge" ><#=objRow.ToAge#></span></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMinReading"  style="width:50px;" type="text" value="<#=objRow.MinReading#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMaxReading"   style="width:50px;" type="text" value="<#=objRow.MaxReading#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMinCritical"  style="width:50px;" type="text" value="<#=objRow.MinCritical#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtMaxCritical"  style="width:50px;" type="text" value="<#=objRow.MaxCritical#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtautoappMin"  style="width:50px;" type="text" value="<#=objRow.AutoApprovedMin#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtautoappMax"  style="width:50px;" type="text" value="<#=objRow.AutoApprovedMax#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtamrmin"  style="width:50px;" type="text" value="<#=objRow.AMRMin#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtamrmax"  style="width:50px;" type="text" value="<#=objRow.AMRMax#>"/></td>

<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtreflexmin"  style="width:50px;" type="text" value="<#=objRow.reflexmin#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtreflexmax"  style="width:50px;" type="text" value="<#=objRow.reflexmax#>"/></td> 
                                      
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtReadingFormat"  style="width:50px;" type="text" value="<#=objRow.ReadingFormat#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><textarea id="txtDisplayReading"  style="width:200px;"><#=objRow.DisplayReading.replace(new RegExp('<br />', 'g'),'\n')#></textarea></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtDefaultReading"  style="width:50px;" type="text" value="<#=objRow.DefaultReading#>"/></td>
<td class="GridViewLabItemStyle" style="width:50px;"><input id="txtAbnormalReading"  style="width:50px;" type="text" value="<#=objRow.AbnormalValue#>"/></td>

<td id="imgAdd" class="GridViewLabItemStyle" style="width:50px;"><img src="../../App_Images/ButtonAdd.png" onclick="AddDetail();" /></td>
<td id="imgRmv" class="GridViewLabItemStyle" style="width:20px;"><img src="../../App_Images/Delete.gif" onclick="RmvDetail();" /></td>


 <#}#>
 
</tr>

            

     </table>  
 </script>

</body>
</html>
