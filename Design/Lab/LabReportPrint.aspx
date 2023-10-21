<%@ Page Title="Lab Report Dispatch" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LabReportPrint.aspx.cs" Inherits="Design_Lab_LabReportPrint" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
         <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
      <%: Scripts.Render("~/bundles/MsAjaxJs") %>
      <%: Scripts.Render("~/bundles/Chosen") %>
    <div class="alert fade" style="position:absolute;left:50%;border-radius:15px;">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
     <Ajax:ScriptManager ID="sm1" runat="server" />
      <div id="Pbody_box_inventory" style="width:1200px" >
     <div class="POuter_Box_Inventory"  style="width:1200px" >
          <div class="content" style="text-align: center;">
                <b>Lab Report Printing</b>
                <br />
              <asp:Label ID="lbmsg" CssClass="ItDoseLblError" runat="server"></asp:Label>
                </div>
         <div class="content"  style="width:1190px">
        <table style="width:100%">
            <tr>
            <td width="55%" valign="top">
                <table width="100%" frame="box">
          <tr>
              <td  style="color:maroon; font-weight: 700;">
                  <strong>Centre:</strong></td>
              <td colspan="3">  

                  <asp:DropDownList ID="ddlcentre" runat="server" Width="300px" class="ddlcentre chosen-select chosen-container"></asp:DropDownList>
              </td>
                    </tr>
          <tr>
              <td  style="color:maroon; font-weight: 700;">Date Option:</td>
              <td colspan="3">  

                  <asp:DropDownList ID="ddldateoption" runat="server" Width="300px">
                      <asp:ListItem Value="1">Approved Date</asp:ListItem>
                       <asp:ListItem Value="2">Registration Date</asp:ListItem>
                  </asp:DropDownList>
              </td>
                    </tr>
          <tr>
              <td  style="color:maroon"><b>From Date:</b></td>
              <td>  <asp:TextBox ID="dtFrom" runat="server" ReadOnly="true" Width="170px"></asp:TextBox>
                                <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                        TargetControlID="dtFrom"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtFrom" /></td>
              <td style="color:maroon">  <b>To Date:</b></td>
              <td>    <asp:TextBox ID="dtTo" runat="server" ReadOnly="true" Width="117px"></asp:TextBox>
                                <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                        TargetControlID="dtTo"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtTo" /></td></tr>
             <tr> <td style="color:maroon; font-weight: 700;"><b><asp:DropDownList ID="ddlsearchop" runat="server">
                          <asp:ListItem Value="lt.LedgerTransactionNo">Lab No</asp:ListItem>
                           <asp:ListItem Value="lt.pname">Patient Name</asp:ListItem>
                           
                      </asp:DropDownList>
                  </b></td>
                 <td><asp:TextBox ID="txtlabno" runat="server" Width="171px"></asp:TextBox></td>
                 <td style="color:maroon; font-weight: 700;">Status:</td>
                 <td>
                     <asp:DropDownList ID="ddlstatus" runat="server" Width="120">
                         <asp:ListItem Value="Authenticated">Approved</asp:ListItem>
                         <asp:ListItem Value="Printed">Printed</asp:ListItem>
                         <asp:ListItem Value="All">All</asp:ListItem>
                     </asp:DropDownList>
                 </td>
          </tr>
             <tr> <td colspan="4" style="text-align: center">
                  <input type="button"  onclick="getdata()" value="Search Patient" class="searchbutton" /></td>
          </tr>
      </table>
<div class="Purchaseheader">Patient List
            </div>
  <div id="PatientLabSearchOutput" style="height:360px;overflow:scroll;" >
            
            </div>
            </td>

              <td width="45%" valign="top">

                   <table style="width:100%; color: #800000;" frame="box">
                      <tr>
                          <td style="width: 130px"><b>Patient Name:</b></td>
                          <td colspan="3"><b> <span id="pname">

                                          </span></b> </td>
                      </tr>
                      <tr>
                          <td style="width: 130px"><b>Age/Gender:</b></td>
                          <td><b><span id="page">

                                          </span></b></td>
                          <td><b>Lab No:</b></td>
                          <td><b>
                              <span id="plabno">

                                          </span>
                              </b> </td>
                      </tr>
                      <tr>
                          <td style="width: 130px"><b>Reg DateTime:</b></td>
                          <td colspan="3"><b> <span id="pbookdate">

                                          </span></b> </td>
                      </tr>
                      <tr>
                          <td style="width: 130px"><b>Centre Name:</b></td>
                          <td colspan="3"><b>
                               <span id="pcentre">

                                          </span>
                                          </b> </td>
                      </tr>
                  </table>

                <div class="Purchaseheader">Test
                    List</div>
  <div id="PatientLabResultOutput" style="height:378px;overflow:scroll;" >
            
            </div>

                  <br />
                  <center>
                  <input type="button" id="btnprint" value="Print Lab Report" style="display:none;" class="savebutton" onclick="Print()" />
             </center> </td>
                </tr>
        </table>
      
        </div>
         </div>
          </div>
    <script id="tb_PatientLabSearch" type="text/html">
    
    
    
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" width="99%">
		<tr id="header">
			<th class="GridViewHeaderStyle" scope="col" >S.No</th>
             <th class="GridViewHeaderStyle" scope="col" >Centre</th>
            <th class="GridViewHeaderStyle" scope="col" >Reg Datetime</th>
            <th class="GridViewHeaderStyle" scope="col" >LabNo</th>
			<th class="GridViewHeaderStyle" scope="col" >PatientName</th>
			<th class="GridViewHeaderStyle" scope="col" >Age/Sex</th>
			<th class="GridViewHeaderStyle" scope="col" >Panel</th>
            <th class="GridViewHeaderStyle" scope="col" >Ref.Doctor</th>
         </tr>



       <#
              var dataLength=PatientData.length;
            
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];

            #>
<tr style="background-color:<#=objRow.rowcolor#>;height:30px;cursor:pointer" id="<#=objRow.LedgerTransactionNo#>" onclick="getdetail(this)">


<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" id="centreid"><#=objRow.Centre#></td>
    <td class="GridViewLabItemStyle" id="pbookat"><#=objRow.Bookat#></td>
<td class="GridViewLabItemStyle" id="labno" style="font-weight:bold;"><#=objRow.LedgerTransactionNo#></td>
<td class="GridViewLabItemStyle" id="pname1" style="font-weight:bold;"><#=objRow.PName#></td>
<td class="GridViewLabItemStyle" id="page1"><#=objRow.age#>/<#=objRow.gender#></td>
<td class="GridViewLabItemStyle" id="ppanel"><#=objRow.Company_Name#></td>
<td class="GridViewLabItemStyle" id="pdocname"><#=objRow.Name#></td>
<td class="GridViewLabItemStyle" style="display:none;" id="Td1"><#=objRow.rowcolor#></td>
</tr>
         
          

            <#}#>

</table>
           
           
    </script>

    <script id="tb_PatientResultSearch" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" width="99%">
		<tr id="header">
			<th class="GridViewHeaderStyle" scope="col" >S.No</th>
             <th class="GridViewHeaderStyle" scope="col" >Department</th>
            <th class="GridViewHeaderStyle" scope="col" >Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Status</th>
			<th class="GridViewHeaderStyle" scope="col" width="30px;" align="left"><input type="checkbox" id="chhead" style="display:none;" /></th>
		
         </tr>



       <#
              var dataLength=PatientData1.length;
            
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData1[j];

            #>
<tr style="background-color:<#=objRow.rowcolor#>;height:30px;" id="<#=objRow.Test_ID#>" >


<td class="GridViewLabItemStyle"><#=j+1#>

    <# if( objRow.STATUS=="Approved & Print")
     {
     #>
    <img src="../../App_Images/print.gif" />
    <#}#>
</td>
<td class="GridViewLabItemStyle" id="dept"><#=objRow.dept#></td>
<td class="GridViewLabItemStyle" id="testname" style="font-weight:bold;"><#=objRow.testname#></td>
<td class="GridViewLabItemStyle" id="STATUS" style="font-weight:bold;"><#=objRow.STATUS#></td>
<td class="GridViewLabItemStyle" id="Td4" >
    <# if(objRow.STATUS=="Approved" || objRow.STATUS=="Approved & Print")
    {
    #>
    <input type="checkbox" id="chk" />
    <#}#>
    </td>
<td class="GridViewLabItemStyle" id="rptype" style="display:none;" ><#=objRow.ReportType#></td>

</tr>
         
            

            <#}#>

</table>

    </script>

    <script type="text/javascript">
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
         });


        var PatientData = "";
        var PatientData1 = "";
        $(document).ready(function () {
            var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
            $('#PatientLabSearchOutput').html(output);

            var output1 = $('#tb_PatientResultSearch').parseTemplate(PatientData1);
            $('#PatientLabResultOutput').html(output1);


        });
        function getdata() {
            $modelBlockUI();
            $.ajax({
                url: "LabReportPrint.aspx/getdata",
                data: '{fromdate:"' + $('#<%=dtFrom.ClientID%>').val() + '",todate:"' + $('#<%=dtTo.ClientID%>').val() + '",labno:"' + $('#<%=txtlabno.ClientID%>').val() + '",searchop:"' + $('#<%=ddlsearchop.ClientID%>').val() + '",status:"' + $('#<%=ddlstatus.ClientID%>').val() + '", centre:"' + $('#<%=ddlcentre.ClientID%>').val() + '",dateoption:"' + $('#<%=ddldateoption.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                // async: false,
                success: function (result) {
                    clearform();
                    $('#PatientLabResultOutput').empty();
                    PatientData = $.parseJSON(result.d);

                    if (PatientData.length == 0) {
                        $('#PatientLabSearchOutput').empty();
                        $('#<%=lbmsg.ClientID%>').html("No Record Found..!");
                        $modelUnBlockUI();
                        return;
                    }
                    var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                    $('#PatientLabSearchOutput').html(output);
                    $('#<%=lbmsg.ClientID%>').html("Total Patient :: " + PatientData.length);

                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    StatusOFReport = "";
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function clearform() {
            $('#PatientLabResultOutput').empty();
            $('#pcentre').html('');
            $('#pbookdate').html('');
            $('#plabno').html('');
            $('#pname').html('');
            $('#page').html('');
            $('#btnprint').hide();
        }

        function getdetail(ctrl) {
            $modelBlockUI();
            clearform();
            $('#pcentre').html($(ctrl).find("#centreid").text());
            $('#pbookdate').html($(ctrl).find("#pbookat").text());
            $('#plabno').html($(ctrl).find("#labno").text());
            $('#pname').html($(ctrl).find("#pname1").text());
            $('#page').html($(ctrl).find("#page1").text());
            // $(ctrl).find("#ppanel").text();
            //$(ctrl).find("#pdocname").text();




            $('#tb_grdLabSearch tr').each(function () {
                if ($(this).attr('id') != "header") {
                    $(this).css("background-color", $(this).find("#Td1").text());
                }
            });
            $(ctrl).css("background-color", "lightblue");


            $.ajax({
                url: "LabReportPrint.aspx/getdetaildata",
                data: '{labno:"' + $(ctrl).find("#labno").text() + '" }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                // async: false,
                success: function (result) {
                    PatientData1 = $.parseJSON(result.d);
                    if (PatientData1.length == 0) {
                        $('#PatientLabResultOutput').empty();
                        $('#<%=lbmsg.ClientID%>').html("No Record Found..!");
                        $modelUnBlockUI();
                        return;
                    }
                    var output = $('#tb_PatientResultSearch').parseTemplate(PatientData1);
                    $('#PatientLabResultOutput').html(output);
                    $('#btnprint').show();
                    $('#<%=lbmsg.ClientID%>').html("Total Test :: " + PatientData1.length);
                    tablefunc();

                },
                error: function (xhr, status) {

                    StatusOFReport = "";
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


            $modelUnBlockUI();
        }

        function Print() {

            var TestID = "";
            var rowid = "";
            var reporttype = '1';
            $("#Table1 tr").find("#chk").filter(':checked').each(function () {
                TestID += $(this).closest('tr').attr('id') + ',';
                rowid += '#' + $(this).closest('tr').attr('id') + ',';
                if ($(this).closest('tr').find('#rptype').text().trim() == "7") {
                    reporttype = "7";
                }

            });



            if (TestID != '') {
                pagename = "labreportnew";
                if (reporttype == "7") {
                    pagename = "labreportnewhisto";
                }


                window.open('../../Design/Lab/' + pagename + '.aspx?TestID=' + TestID + '&Phead=0');
            }
            else {
                if (TestID == "") {
                    showerrormsg("Kindly select Test");
                }
            }
            $("#Table1 tr").find("#chk").attr('checked', false);
            $('#chhead').attr('checked', false);
            if (TestID != "") {
                $(rowid).css('background-color', '#00FFFF');
                $(rowid).find('#STATUS').html('Approved & Print');
                $('#' + $('#plabno').html()).hide();
            }

        }

        function tablefunc() {
            $("#chhead").click(function () {
                $("#Table1 tr").find("#chk").prop("checked", $(this).attr("checked"));

            });
        }
    </script>
</asp:Content>

