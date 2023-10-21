<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientImageDelete.aspx.cs" Inherits="Design_Lab_PatientImageDelete" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
      <%: Scripts.Render("~/bundles/MsAjaxJs") %>
      <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript">
        var PatientData = "";
        function SearchPatientImage() {
            $.ajax({
                url: "PatientImageDelete.aspx/SearchPatientImage",
                data: '{Barcode : "' + $("#<%=txtBarcode.ClientID %>").val().trim() + '",FromDate:"' + $('[id$=dtFrom]').val() + '",ToDate:"' + $('[id$=dtTo]').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    PatientData = $.parseJSON(result.d);
                    if (PatientData.length == 0) {
                        $('#divInvestigation').html('');
                        $("#<%=lblMsg.ClientID %>").text('No Record Found');
                        $('[id$=txtBarcode]').val('');
                        return;
                    }
                    else {
                        $('#divInvestigation').html('');
                        $('[id$=txtBarcode]').val('');
                        var output = $('#tb_SearchInvestigation').parseTemplate(PatientData);
                        $('#divInvestigation').html(output);
                        $("#<%=lblMsg.ClientID %>").text('');
                    }
                },
                error: function (xhr, status) {
                    alert('Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

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
        function DeleteImage(ctr) {
            $(ctr).val('Deleting.....');
            $(ctr).css('color', 'red');
            var TestId = $(ctr).closest('tr').find('#tdtestid').text();
            if (TestId != null && TestId != "") {
                $.ajax({
                    url: "PatientImageDelete.aspx/DeleteImage",
                    data: '{TestId : "' + TestId + '"}', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg('Record delete successfully.');
                            return;
                        }
                        if (result.d == "0") {
                            showmsg('Record not delete');
                            return;
                        }
                       
                    }
                   
                });
            }
        }
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 900px">
        <div class="POuter_Box_Inventory" style="width: 894px">
            <div class="content" style="text-align: center;">
                <b>Patient Image Delete </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 892px">
            <div class="Purchaseheader">
                Patient Image Search Critaria
            </div>
            <div class="content" style="text-align: left">
                <table width="100%">
                    <tr>
                        <td>
                            <label class="labelForTag">From Date :</label>
                        </td>
                         <td><asp:TextBox ID="dtFrom" CssClass="ItDoseTextinputText" runat="server"  Width="100px"></asp:TextBox>
                <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="dtFrom" TargetControlID="dtFrom" />
</td>
                        <%--<td>
                            <asp:TextBox ID="dtFrom" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                TargetControlID="dtFrom"
                                Format="dd-MMM-yyyy"
                                PopupButtonID="imgdtFrom" />
                            <asp:Image ID="imgdtFrom" runat="server" ImageUrl="~/App_Themes/Images/ew_calendar.gif" />
                        </td>--%>
                        <td style="width: 189px">
                            <label class="labelForTag">To Date :</label>
                        </td>

                        <td><asp:TextBox ID="dtTo" CssClass="ItDoseTextinputText" runat="server" Width="100px"></asp:TextBox>
                <cc1:calendarextender ID="Calendarextender1" runat="server" Format="dd-MMM-yyyy" PopupButtonID="dtTo" TargetControlID="dtTo" />
                    </td>

                        <%--<td>
                            <asp:TextBox ID="dtTo" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                TargetControlID="dtTo"
                                Format="dd-MMM-yyyy"
                                PopupButtonID="imgdtTo" />
                            <asp:Image ID="imgdtTo" runat="server" ImageUrl="~/App_Themes/Images/ew_calendar.gif" />
                        </td>--%>
                    </tr>
                    <tr>
                        <td style="width: 189px">
                            <label class="labelForTag">BarCode :</label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtBarcode" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 893px;">
            <input type="button" id="btnsearch" class="ItDoseButton" value="Search" onclick="return SearchPatientImage();" />
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.7%">
            <div id="divInvestigation">
            </div>
        </div>
    </div>

     <script id="tb_SearchInvestigation" type="text/html"  >
        <table class="GridViewStyle" cellspacing="0"  id="tb_SearchInvestigations" 
    style="border-collapse:collapse; width:100%;">
	 <tr id="Header">    
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Patinet Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">LabNo.</th>  
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">BarCodeNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Investgation Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Delete</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;"></th>
     </tr>
<#       
 
 var dataLength=PatientData.length;
 window.status="Total Records Found :"+ dataLength;
 var objRow; 
        
        for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j]; 
            #>
<tr  style="width:100%;" > 
<td class="GridViewLabItemStyle"><#=j+1#></td> 

      <td class="GridViewLabItemStyle"><#=objRow.PatientName#></td>
      <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.LabNo#></td>
      <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.BarCodeNo#></td>
      <td class="GridViewLabItemStyle"><#=objRow.Investigationname#></td>
      <td class="GridViewLabItemStyle" style="text-align:center">
          <input type="button" onclick="return DeleteImage(this);" id="btndelete" value="Delete" class="ItDoseButton" />
      </td>
     <td  class="GridViewLabItemStyle" id="tdtestid" style="display:none;" ><#=objRow.Test_ID#></td>
              

 </tr>
  <#}#>
</table>    
    </script>
</asp:Content>

