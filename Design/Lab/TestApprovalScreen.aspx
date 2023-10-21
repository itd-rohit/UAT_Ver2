<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TestApprovalScreen.aspx.cs" Inherits="Design_Lab_TestApprovalScreen" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <style type="text/css">
        #aa:link {
            color: blue;
            font-size: 15px;
            font-weight:bold;
            padding:5px;
        }
      
        #aa:hover, #aa:active {
            color: red;
            font-size: 15px;
            font-weight:bold;
              padding:5px;
        }
    </style>
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>  
 <div id="Pbody_box_inventory" style="width:1204px;">
              <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align: center;">
                <b>Test Approval Screen</b>
                </div>
              </div>

     <div id="m1" runat="server">

      <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align: center;">
                <div class="Purchaseheader">Search</div>
                <table width="100%">
                    <tr>
                        <td style="text-align: left; "> <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                         
                               <asp:TextBox ID="txtFromTime" runat="server" Width="70px"></asp:TextBox>
                                 <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                                                             AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                                                            
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                                        ControlExtender="mee_txtFromTime"
                                        ControlToValidate="txtFromTime"
                                        InvalidValueMessage="*"  >
                                 </cc1:MaskedEditValidator></td>
                        <td style="text-align: left; "><asp:TextBox ID="txtToDate"  CssClass="ItDoseTextinputText"  runat="server" ReadOnly="true"  Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                            
                            
                              <asp:TextBox ID="txtToTime" runat="server" Width="70px"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">                        
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                        ControlExtender="mee_txtToTime"  ControlToValidate="txtToTime"  
                                        InvalidValueMessage="*"  >
                                </cc1:MaskedEditValidator></td>
                        <td style="text-align: left; font-weight: 700">Centre:</td>
                        <td style="text-align: left; font-weight: 700">
                        <asp:DropDownList ID="ddlCentreAccess" class="ddlcentreAccess  chosen-select chosen-container" Width="300px" runat="server">
                            <asp:ListItem Value="ALL">ALL</asp:ListItem>
                        </asp:DropDownList>

                        </td>

                        <td style="text-align: left; font-weight: 700">Department:</td>

                        <td style="text-align: left; font-weight: 700">

                        <asp:DropDownList ID="ddlDepartment" class="ddlDepartment  chosen-select chosen-container"  Width="225px" runat="server">
                        </asp:DropDownList>
                              </td>
                        <td><input id="btnSearch" type="button" value="Search"  class="searchbutton" onclick="SearchData();"/></td>

                    </tr>
                </table>
                </div>
          </div>

     <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align: center;">
                  <div class="Purchaseheader">Pending List 
                       <span style="color:red;">&nbsp;&nbsp;&nbsp;Total Pending:&nbsp;</span><span id="totalcount" style="color:red">0</span></div>
               <div style="width:99%;overflow:auto;height:410px;">
                                
                <table style="width:99%"  cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                    <tr id="saheader" style="height:20px;">  
			        <th class="GridViewHeaderStyle" scope="col" style="width:5%;text-align:left;font-size:13px;">S.No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:15%;text-align:left;font-size:13px;">State</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:20%;text-align:left;font-size:13px;">City</th>
			        <th class="GridViewHeaderStyle" scope="col" style="width:42%;text-align:left;font-size:13px;">Centre</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:18%;text-align:center;font-size:13px;">Pending For Approval</th> 
			   
			

</tr>
                    </table></div>
                </div>
         </div>
    </div>

     <div id="m2" style="display:none;" runat="server">
           <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align: center;">
         <asp:Label ID="lb" runat="server" ForeColor="Red" Font-Size="Larger" Font-Bold="true">You Are Not Authorized to Access This Page</asp:Label>
                </div>
               </div>
     </div>

 </div>
    


    <script type="text/javascript">


        $(document).ready(function () {
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
            BindCentre();
        });


        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }

        function BindCentre() {
          





            var ddlDoctor = $("#<%=ddlCentreAccess.ClientID %>");






            $("#<%=ddlCentreAccess.ClientID %> option").remove();




            $.ajax({

                url: "MachineResultEntry.aspx/bindAccessCentre",
                data: '{}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                    }
                    else {
                        ddlDoctor.append($("<option></option>").val("ALL").html("ALL"));
                        for (i = 0; i < PanelData.length; i++) {

                            ddlDoctor.append($("<option></option>").val(PanelData[i]["CentreID"]).html(PanelData[i]["Centre"]));
                        }
                    }
                    ddlDoctor.trigger('chosen:updated');

                  
                },
                error: function (xhr, status) {
                    //alert("Error ");

                    ddlDoctor.trigger('chosen:updated');

                    
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }
            

        function SearchData() {
            $('#tb_ItemList tr').slice(1).remove();
            $("#btnSearch").attr('disabled', 'disabled').val('Searching...');
            $modelBlockUI();
            jQuery.ajax({
                url: "TestApprovalScreen.aspx/binddata",
                data: '{FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",TimeTo:"' + $("#<%=txtToTime.ClientID%>").val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    if (TestData == "-1") {
                        $('#totalcount').html('0');
                         $("#btnSearch").removeAttr('disabled').val('Search');
                         $modelUnBlockUI();
                         alert('Your Session Expired.... Please Login Again');
                         var url = "../Default.aspx";
                         $(location).attr('href', url);
                         return;
                     }
                    

                    if (TestData.length == 0) {
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        $('#totalcount').html('0');
                        showerrormsg("No Pending List Found");
                        $modelUnBlockUI();
                        return;
                    }
                    else {
                        var a = 0;
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        $modelUnBlockUI();

                        for (var i = 0; i <= TestData.length - 1; i++) {


                            a = a + parseInt(TestData[i].Pending);
                            var mydata = "<tr id='" + TestData[i].CentreID + "'  style='background-color:lemonchiffon;height:25px;'>";
                            mydata += '<td class="GridViewLabItemStyle" align="left" style="font-size:12px;">' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" align="left" style="font-size:12px;"><b>' + TestData[i].State + '</b></td>';
                            mydata += '<td class="GridViewLabItemStyle" align="left" style="font-size:12px;"><b>' + TestData[i].City + '</b></td>';
                            mydata += '<td class="GridViewLabItemStyle" align="left" style="font-size:12px;"><b>' + TestData[i].centre + '</b></td>';
                            mydata += '<td class="GridViewLabItemStyle" align="centre"><a id="aa" title="Click To View List" href="javascript:void(0)" onclick="openresultentry(this)" >' + TestData[i].Pending + '</a></td>';
                           

                            mydata += '<td id="fromdate" style="display:none;">' + $("#<%=txtFormDate.ClientID %>").val() + '</td>';
                            mydata += '<td id="fromtime" style="display:none;">' + $("#<%=txtFromTime.ClientID %>").val() + '</td>';
                            mydata += '<td id="todate"   style="display:none;">' + $("#<%=txtToDate.ClientID %>").val() + '</td>';
                            mydata += '<td id="totime"   style="display:none;">' + $("#<%=txtToTime.ClientID %>").val() + '</td>';
                            mydata += '<td id="centre"   style="display:none;">' + TestData[i].CentreID + '</td>';
                            mydata += '<td id="department" style="display:none;">' + $("#<%=ddlDepartment.ClientID%>").val() + '</td>';
                            mydata += "</tr>";
                            $('#tb_ItemList').append(mydata);
                        }
                        $('#totalcount').html(a);
                    }

                },
                error: function (xhr, status) {

                }

            });

        }

        function openresultentry(ctrl) {       
            var fromdate =$(ctrl).closest("tr").find('#fromdate').text();
            var fromtime = $(ctrl).closest("tr").find('#fromtime').text();
            var todate = $(ctrl).closest("tr").find('#todate').text();
            var totime = $(ctrl).closest("tr").find('#totime').text();
            var centre = $(ctrl).closest("tr").find('#centre').text();
            var department = $(ctrl).closest("tr").find('#department').text();
            
             $(ctrl).css("background-color", "lightgreen");
            window.open("MachineResultEntry.aspx?fromdate=" + fromdate + "&fromtime=" + fromtime + "&todate=" + todate + "&totime=" + totime + "&centre=" + centre + "&department=" + department);
        }

      
    </script>
</asp:Content>

