<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TestCentreMapping.aspx.cs" Inherits="Design_Investigation_TestCentreMapping" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        
            <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
   
      <div id="body_box_inventory" style="width: 1100px; height: 618px;" >
    <div class="Outer_Box_Inventory" style="width: 1096px;text-align:center; " >
  
  
    <b>Processing Lab Test Mapping</b><br />
     
         <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>&nbsp;</div>
  
  
   <div class="Outer_Box_Inventory" style="width: 1096px;" >
    <div class="Purchaseheader"> 
        Search criteria</div>
               
                      <table id="TBMain" border="0"  style="width: 100%; border-collapse:collapse">
                        <tr>
                        <td style="width: 12%;text-align:right" >
                               Booking Centre :&nbsp;
                            </td>
                            <td style="width: 21%" >
                               <asp:DropDownList ID="ddlCentre" runat="server" CssClass="ItDoseDropdownbox" Width="230px"  ></asp:DropDownList></td>
                            <td style="width: 9%;text-align:right" >
                               Department :&nbsp;
                            </td>
                            <td style="width: 38%" >
                                <asp:DropDownList ID="ddlDepartment" CssClass="ItDoseDropdownbox"  runat="server" Width="230px">
                                </asp:DropDownList></td>
                        </tr>
                        <tr>
                        <td style="width: 12%;text-align:right" >
                               Test Name :&nbsp;
                            </td>
                            <td style="width: 21%" >
                                     <input id="txtTestname" type="text" style="width: 222px"  />
                            </td>
                            <td style="width: 9%;text-align:right" >
                                &nbsp;</td>
                            <td style="width: 38%" >
                                <div style="text-align:center;font-style:italic;font-weight:bold;cursor:pointer;" onclick="SetTestCentre();">Set All Test Centre</div>

                              </td>
                        </tr>
                        </table>

               
       </div>

             <div class="Outer_Box_Inventory" style="width: 1096px; text-align:center;">
                 <input id="btnSearch"  class="ItDoseButton"  type="button" value="Search" onclick="search();" />
                 </div>
            <div class="Outer_Box_Inventory" style="width: 1096px; "  > 
        <div id="div_InvestigationItems"  style="max-height:430px; overflow-y:auto; overflow-x:hidden;">
                
            </div>
        </div>
            <div class="Outer_Box_Inventory" style="width: 1096px; text-align:center;display:none" id="divTestCentre">
                 <input id="btnSave"  class="ItDoseButton"  type="button" value="Save" onclick="saveLabTestCentre();" />
                 </div>
          </div>
      <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle " cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse; width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Investigation</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">
                <asp:DropDownList ID="DropDownList1" CssClass="mm1" runat="server" onchange="setall1()" ></asp:DropDownList>
			</th>
	<th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">
        <asp:DropDownList ID="DropDownList2" CssClass="mm2" runat="server" onchange="setall2()" ></asp:DropDownList>
			</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">
                <asp:DropDownList ID="DropDownList3" CssClass="mm3" runat="server" onchange="setall3()" ></asp:DropDownList>
			</th>		       
</tr>
             <#      
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j];        
            #>
                  <tr id="<#=j+1#>" >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.TypeName#></td>
<td class="GridViewLabItemStyle cltdTestCentreCon1">
    <asp:DropDownList ID="ddlTestCentre1" CssClass="ddlTestCentre1" runat="server" onchange="getTestCentre1(this);" ></asp:DropDownList>
     <span id="span_TestCentre" style="display:none;"><#=objRow.Test_Centre#></span>
     <span id="spnTestCentreCon1" style="display:none"  class="clTestCentreCon1"  ><#=objRow.TestCentre1#></span>
   
     
     <span id="span_Investigation" style="display:none;"><#=objRow.Type_ID#></span>
     <span id="span_BookingCentre" style="display:none;"><#=BookingCentre#></span>

</td>

  <td class="GridViewLabItemStyle">
    <asp:DropDownList ID="ddlTestCentre2" CssClass="ddlTestCentre2" runat="server" onchange="getTestCentre2(this);"></asp:DropDownList>    
      <span id="span_TestCentre1" style="display:none;"><#=objRow.Test_Centre2#></span>
      
      <span id="spnTestCentreCon2" style="display:none" class="clTestCentreCon2" ><#=objRow.TestCentre2#></span>
</td>     
      <td class="GridViewLabItemStyle">
    <asp:DropDownList ID="ddlTestCentre3" CssClass="ddlTestCentre3" runat="server" onchange="getTestCentre3(this);"></asp:DropDownList>  
          <span id="span_TestCentre2" style="display:none;"><#=objRow.Test_Centre3#></span> 
         
          <span id="spnTestCentreCon3" style="display:none" class="clTestCentreCon2" ><#=objRow.TestCentre3#></span>
</td>
                  </tr>
             <#}#>
        </table>
          </script>
    <script type="text/javascript">
        

        var PatientData = '';
        var BookingCentre = '';
        function search() {
            $modelBlockUI();
            BookingCentre = $("#<%=ddlCentre.ClientID %>").val();
            $.ajax({
                url: "Services/MapInvestigationObservation.asmx/getTestCentre",
                data: '{ BookingCentre: "' + BookingCentre + '",Department:"' + $('#<%=ddlDepartment.ClientID%>').val() + '",TestName:"' + $('#txtTestname').val() + '"}', // parameter map
                type: "POST",        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    if (PatientData != null) {
                        var output = $('#tb_InvestigationItems').parseTemplate(PatientData);

                        $('#div_InvestigationItems').html(output);
                        $('#divTestCentre').show();
                    }
                    else {
                        $('#divTestCentre').hide();
                    }
                    $("#tb_grdLabSearch tr #ContentPlaceHolder1_ddlTestCentre1").each(function () {
                        $(this).val($(this).closest('tr').find("#span_TestCentre").text());
                       
                    });
                    $("#tb_grdLabSearch tr #ContentPlaceHolder1_ddlTestCentre2").each(function () {
                        $(this).val($(this).closest('tr').find("#span_TestCentre1").text());
                    });
                    $("#tb_grdLabSearch tr #ContentPlaceHolder1_ddlTestCentre3").each(function () {
                        $(this).val($(this).closest('tr').find("#span_TestCentre2").text());
                    });
                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    alert("Error ");
                }
            });
        }
        function saveTestCentre(ctrl) {
            $modelBlockUI();       
            $.ajax({
                url: "Services/MapInvestigationObservation.asmx/SaveTestCentre",
                data: '{ BookingCentre: "' + BookingCentre + '",Investigation_ID:"' + $(ctrl).closest('tr').find("#span_Investigation").text() + '",TestCentre:"' + $(ctrl).closest('tr').find("#ContentPlaceHolder1_ddlTestCentre1").val() + '",TestCentre1:"' + $(ctrl).closest('tr').find("#ContentPlaceHolder1_ddlTestCentre2").val() + '",TestCentre2:"' + $(ctrl).closest('tr').find("#ContentPlaceHolder1_ddlTestCentre3").val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {                    
                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    alert("Error ");
                }
            });
        }
        function SetTestCentre() {
            window.open("TestCentreMappingPopup.aspx");
        };
        function setall1() {
            $('.ddlTestCentre1').val($('.mm1').val());
           
            $('#tb_grdLabSearch tr').each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    var ddlTestCentre = $.trim($(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre1').val());
                    var spnTestCentre = $.trim($(this).closest('tr').find('#span_TestCentre').html());
                   
                    if ((ddlTestCentre != spnTestCentre)) {
                        $(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre1').css("background-color", "#FDE76D");
                        $.trim($(this).closest('tr').find('#spnTestCentreCon1').html('1'));
                    }
                    else {
                        $.trim($(this).closest('tr').find('#spnTestCentreCon1').html('0'));
                        $(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre1').css("background-color", "#FFFFFF");
                    }
                }
            });
        }
        function setall2() {
            $('.ddlTestCentre2').val($('.mm2').val());

            $('#tb_grdLabSearch tr').each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    var ddlTestCentre = $.trim($(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre2').val());
                    var spnTestCentre = $.trim($(this).closest('tr').find('#span_TestCentre1').html());

                    if ((ddlTestCentre != spnTestCentre)) {
                        $(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre2').css("background-color", "#FDE76D");
                        $.trim($(this).closest('tr').find('#spnTestCentreCon2').html('1'));
                    }
                    else {
                        $.trim($(this).closest('tr').find('#spnTestCentreCon2').html('0'));
                        $(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre2').css("background-color", "#FFFFFF");
                    }
                }
            });
        }
        function setall3() {
            $('.ddlTestCentre3').val($('.mm3').val());

            $('#tb_grdLabSearch tr').each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                if (id != "Header") {
                    var ddlTestCentre = $.trim($(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre3').val());
                    var spnTestCentre = $.trim($(this).closest('tr').find('#span_TestCentre2').html());

                    if ((ddlTestCentre != spnTestCentre)) {
                        $(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre3').css("background-color", "#FDE76D");
                        $.trim($(this).closest('tr').find('#spnTestCentreCon3').html('1'));
                    }
                    else {
                        $.trim($(this).closest('tr').find('#spnTestCentreCon3').html('0'));
                        $(this).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre3').css("background-color", "#FFFFFF");
                    }
                }
            });
        }

         </script>
    <script type="text/javascript">
        function saveLabTestCentre() {
            $("#btnSave").attr('disabled', 'disabled').val('Submitting...');
                var dataTest = new Array();
                var ObjTest = new Object();
                jQuery("#tb_grdLabSearch tr").each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if (id != "Header") {
                        if ((jQuery.trim($rowid.find("#spnTestCentreCon1").html()) == "1") || (jQuery.trim($rowid.find("#spnTestCentreCon2").html()) == "1") || (jQuery.trim($rowid.find("#spnTestCentreCon3").html()) == "1")) {
                            ObjTest.BookingCentre = $("#<%=ddlCentre.ClientID %>").val();
                            ObjTest.Investigation_ID = jQuery.trim($rowid.find("#span_Investigation").html());
                            ObjTest.TestCentre1 = jQuery(this).closest('tr').find("#ContentPlaceHolder1_ddlTestCentre1").val();
                            ObjTest.TestCentre2 = jQuery(this).closest('tr').find("#ContentPlaceHolder1_ddlTestCentre2").val();
                            ObjTest.TestCentre3 = jQuery(this).closest('tr').find("#ContentPlaceHolder1_ddlTestCentre3").val();
                            ObjTest.AllInvestigation_ID = "".concat("'", jQuery.trim($rowid.find("#span_Investigation").html()), "'");
                            dataTest.push(ObjTest);
                            ObjTest = new Object();
                        }
                    }

               
                });
            
            if (dataTest.length > 0) {

                $.ajax({
                    url: "TestCentreMapping.aspx/SaveTestCentre",
                    data: JSON.stringify({ testCentre: dataTest }),
                    type: "POST",        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            alert('Record Saved Successfully');
                            $(".clTestCentreCon1,.clTestCentreCon2,.clTestCentreCon3").text('0');
                            $('.ddlTestCentre1,.ddlTestCentre2,.ddlTestCentre3').css('background-color', '');
                        }
                        else {
                            alert('Error..');
                        }
                        $("#btnSave").removeAttr('disabled').val('Save');
                    },
                    error: function (xhr, status) {
                        $("#btnSave").removeAttr('disabled').val('Save');
                    }
                });
            }
            else {
                alert('Please Select Investigation');
                $("#btnSave").removeAttr('disabled').val('Save');
            }
        }
    </script>
    <script type="text/javascript">
        function getTestCentre1(rowID) {
            var ddlTestCentre = $.trim($(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre1').val());
            var spnTestCentre = $.trim($(rowID).closest('tr').find('#span_TestCentre').html());
           

            if ((ddlTestCentre != spnTestCentre)) {
                $(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre1').css("background-color", "#FDE76D");
                $.trim($(rowID).closest('tr').find('#spnTestCentreCon1').html('1'));
            }
            else {
                $.trim($(rowID).closest('tr').find('#spnTestCentreCon1').html('0'));
                $(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre1').css("background-color", "#FFFFFF");
            }
           
        }
        function getTestCentre2(rowID) {
            var ddlTestCentre = $.trim($(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre2').val());
            var spnTestCentre = $.trim($(rowID).closest('tr').find('#span_TestCentre1').html());

            if ((ddlTestCentre != spnTestCentre)) {
                $(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre2').css("background-color", "#FDE76D");
                $.trim($(rowID).closest('tr').find('#spnTestCentreCon2').html('1'));
            }
            else {
                $.trim($(rowID).closest('tr').find('#spnTestCentreCon2').html('0'));
                $(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre2').css("background-color", "#FFFFFF");
            }
            
        }
        function getTestCentre3(rowID) {
            var ddlTestCentre = $.trim($(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre3').val());
            var spnTestCentre = $.trim($(rowID).closest('tr').find('#span_TestCentre2').html());

            if ((ddlTestCentre != spnTestCentre)) {
                $(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre3').css("background-color", "#FDE76D");
                $.trim($(rowID).closest('tr').find('#spnTestCentreCon3').html('1'));
            }
            else {
                $.trim($(rowID).closest('tr').find('#spnTestCentreCon3').html('0'));
                $(rowID).closest('tr').find('#ContentPlaceHolder1_ddlTestCentre3').css("background-color", "#FFFFFF");
            }
           
        }
    </script>
</asp:Content>

