<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorReferalCentreMapping.aspx.cs" Inherits="Design_FrontOffice_DoctorReferalCentreMapping" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        
           
  
 
  <div id="Pbody_box_inventory" >
          <div class="POuter_Box_Inventory" >
<div class="content" style="text-align:center; ">   
<b>Doctor - Centre Mapping</b>&nbsp;<br />
<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
   
</div>
</div>
      <div class="POuter_Box_Inventory" >
            <div class="row" style="text-align:center">
              <strong>Doctor Name :  &nbsp;&nbsp; </strong>  &nbsp;<asp:Label ID="lblDoctorName" runat="server" ></asp:Label> 
              <asp:Label ID="lblDoctorID" runat="server" style="display:none;"></asp:Label>
            </div>
          </div>
      <div class="POuter_Box_Inventory">
          <div class="row" style="text-align:center">
              <div class="col-md-24">
                  <strong>Centre Name :  &nbsp;&nbsp; </strong>
                  <input id="txtCentreName" style="width:280px;" class="ItDoseTextinputText" autocomplete="off" tabindex="6"/>
              </div>
          </div>
          <div class="row" id="centrelist" style="display:none;position:absolute;z-index: 10000;">
            <table id="centrelisttable" width="100%" border="1" frame="box" rules="all">
            <tr id="Tr1"  style="height:25px;font-weight:bold;background-color:gray;color:white;">
                <td width="20px">Select</td>
                <td width="100px">Centre Code</td>
                <td width="60px">Centre</td>
                <td width="50px">State</td>
                <td width="50px">City</td>
            </tr>
            </table>
          </div>
        <div class="Outer_Box_Inventory" > 
        <div id="div_InvestigationItems"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;width:1340px">
                
            </div>
        </div>
          <div class="POuter_Box_Inventory">
               <div class="row" style="text-align:center;">
                   <input type="button" id="btnRemove" value="Remove" onclick="RemoveRecord()" tabindex="9" class="savebutton" />
                     <input type="button" value="Cancel" onclick="clearForm()" class="resetbutton" style="display:none;" />
                   </div>
                 </div>
   
   
  </div>
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"   style="border-collapse:collapse; width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Centre Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">State</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">City</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;text-align:left;">Remove</th> 
	
	       

</tr>
<#  var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
<tr id="<#=j+1#>" style="background-color:white;">
<td class="GridViewLabItemStyle"><#=j+1#></td> 
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.CentreCode#></td>
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.Centre#></td>
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.State#></td>     
<td class="GridViewLabItemStyle" style="width:400px;"><#=objRow.City#></td> 
<td class="GridViewLabItemStyle" style="width:400px;">
    <span id="lblCentreID_<#=j+1#>" style="width:400px;display:none;"><#=objRow.CentreID#></span>
    <input id="chkRemove" type="checkbox"/></td>
</tr> 
<#}#> 
        </table>
          
          </script>   
    <script type="text/javascript">
        $(document).ready(function () {
           
        $("#txtCentreName").focus(function () { $(this).select(); });
        });
        function GetData() {
            serverCall('DoctorReferalCentreMapping.aspx/GetData', { DoctorID: $('#<%=lblDoctorID.ClientID%>').html() }, function (result) {
                PatientData = jQuery.parseJSON(result);
                var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                $('#div_InvestigationItems').html(output);
                $modelUnBlockUI(function () { });
            });
        } 
    function clearForm() { 
        $('#div_InvestigationItems').html(''); 
    }
    
    var showId = "";
    $(function () { 
        $('#txtCentreName').keyup( 
            function (e) {

                    var key = (e.keyCode ? e.keyCode : e.charCode);
                    if (key == 38 || key == 40 || key == 13 || key == 9) {
                        $('#txtCentreName').css({ 'border': '' });
                        return;
                    }
                    if ($('#txtCentreName').val() == "") {
                        debugger;
                        $("#centrelisttable tr").remove();
                        return;
                    }
                    $("#centrelisttable").find("tr:gt(0)").remove();
                    var PatientData2;
                    serverCall('DoctorReferalCentreMapping.aspx/GetCentreList', { CentreName: $('#txtCentreName').val() }, function (result) {
                        PatientData2 = $.parseJSON(result);
                        if (PatientData2.length == 0) {
                            $('#centrelist').hide();
                        }
                        else {
                          //  alert(PatientData2.length);
                            for (var a = 0; a <= PatientData2.length - 1; a++) {
                                var mydata1 = [];
                                mydata1.push('<tr id="'); mydata1.push(a); mydata1.push('"style="height:25px;background-color:white">');
                                mydata1.push('<td><a style="color:blue;cursor:pointer;text-decoration: underline;" onclick="AddCentre(\'' + $('#<%=lblDoctorID.ClientID%>').html() + '\',\'' + PatientData2[a].CentreID + '\')">Select</a></td>');
                                mydata1.push('<td id="CentreCode" align="left">'); mydata1.push(PatientData2[a].CentreCode); mydata1.push('</td>');
                                mydata1.push('<td id="Centre" align="left">'); mydata1.push(PatientData2[a].Centre); mydata1.push('</td>');
                                mydata1.push('<td id="State" align="left">'); mydata1.push(PatientData2[a].State); mydata1.push('</td>');
                                mydata1.push('<td id="City" align="left">'); mydata1.push(PatientData2[a].City); mydata1.push('</td>');
                                mydata1.push(' <td id="CentreID" align="left" style="display:none;">'); mydata1.push(PatientData2[a].CentreID); mydata1.push('</td>');
                                mydata1 = mydata1.join();

                                // alert(mydata1);
                                $('#centrelisttable').append(mydata1);
                            }
                            $("#centrelisttable").find("#0").focus();
                            $("#centrelisttable").find("#0").css("background-color", "lightblue");
                            $("#centrelisttable").find("#0").addClass("active");
                            $('#centrelist').show();

                        }
                    $modelUnBlockUI(function () { });
                });


            }
            )
    });

        var myv = 0;
        $(function () {
            var shifted = false;
            $('#txtCentreName').keydown(

                function (e) {
                    shifted = e.shiftKey;

                    $('#centrelisttable tr').each(function () {
                        if ($(this).attr("id") != "header" && $(this).hasClass("active")) {
                            myv = $(this).attr("id");
                        }
                    });

                    var key = (e.keyCode ? e.keyCode : e.charCode);
                    if (key == 38) {

                        $("#centrelisttable").find("#" + myv).css("background-color", "white");
                        $("#centrelisttable").find("#" + myv).removeClass("active");

                        myv--;

                        if (parseFloat(myv) < 0) {
                            myv = 0;
                        }
                        $("#centrelisttable").find("#" + myv).focus();
                        $("#centrelisttable").find("#" + myv).css("background-color", "lightblue");
                        $("#centrelisttable").find("#" + myv).addClass("active");

                    }
                    if (key == 40) {
                        $("#centrelisttable").find("#" + myv).css("background-color", "white");
                        $("#centrelisttable").find("#" + myv).removeClass("active");

                        myv++;
                        var ln = parseFloat($('#centrelisttable tr').length) - 2;
                        if (parseFloat(myv) > ln) {
                            myv = ln - 1;
                        }
                        $("#centrelisttable").find("#" + myv).focus();
                        $("#centrelisttable").find("#" + myv).css("background-color", "lightblue");
                        $("#centrelisttable").find("#" + myv).addClass("active");

                    }

                    if (key == 13) {
                        var myval = $('#txtCentreName').val();

                        if ($("#centrelisttable").find("#" + myv).find("#CentreID").html() != null) {
                            AddCentre($('#<%=lblDoctorID.ClientID%>').html(), $("#centrelisttable").find("#" + myv).find("#CentreID").html());
                          //  $('#txtCentreName').val($("#centrelisttable").find("#" + myv).find("#CentreID").html());
                        }
                        else {
                            AddCentre($('#<%=lblDoctorID.ClientID%>').html(), myval);
                          // $('#txtCentreName').val(myval);
                        }


                        $('#centrelist').hide();
                       // resetItem();
                        $('#ctl00_ContentPlaceHolder1_txtSearch').focus();
                        $('#txtCentreName').css({ 'border': '' });



                    }

                    if (key == 9 && shifted == false) {
                        var myval = $('#txtCentreName').val();

                        if ($("#centrelisttable").find("#" + myv).find("#CentreID").html() != null) {
                            AddCentre($('#<%=lblDoctorID.ClientID%>').html(), $("#centrelisttable").find("#" + myv).find("#CentreID").html());
                          //  $('#txtCentreName').val($("#centrelisttable").find("#" + myv).find("#CentreID").html());
                        }
                        else {
                            AddCentre($('#<%=lblDoctorID.ClientID%>').html(), myval);
                           // $('#txtCentreName').val(myval);
                        }
                        $('#centrelist').hide();
                        //resetItem();
                        $('#ctl00_ContentPlaceHolder1_txtSearch').focus();
                        $('#txtCentreName').css({ 'border': '' });
                        e.preventDefault();
                    }

                    if (key == 9 && shifted == true) {
                        var myval = $('#txtCentreName').val(); 
                        if ($("#centrelisttable").find("#" + myv).find("#CentreID").html() != null) {
                            AddCentre($('#<%=lblDoctorID.ClientID%>').html(), $("#centrelisttable").find("#" + myv).find("#CentreID").html());
                          //  $('#txtCentreName').val($("#centrelisttable").find("#" + myv).find("#CentreID").html());
                        }
                        else {
                            AddCentre($('#<%=lblDoctorID.ClientID%>').html(), myval);
                           // $('#txtCentreName').val(myval);
                        }
                        $('#centrelist').hide();
                        //resetItem(); 
                        $('#txtCentreName').css({ 'border': '' });

                    }
                });
        });
    function hidedoclist() {

            }
            function AddCentre(DoctorID, CentreID) {
                $("#btnUpdate").attr('disabled', true);
                serverCall('DoctorReferalCentreMapping.aspx/AddCentre', { DoctorID: DoctorID, CentreID: CentreID }, function (result) {
                    var resultnew = JSON.parse(result);
                    if (resultnew.status) {
                        $("#centrelisttable").find("tr:gt(0)").remove();
                        $("#centrelist").hide();
                        toast('Success', "Record Saved Successfully..", '');
                        GetData();
                        $('#txtCentreName').val('');
                        $('#txtCentreName').focus();
                        return;
                    }
                    else if (resultnew.response == "Error in CentreID") {
                        $("#btnUpdate").attr('disabled', false);
                        toast("Info", "Your Session Expired...Please Login Again", '');
                        $("#centrelisttable").find("tr:gt(0)").remove();
                        $("#centrelist").hide();
                        return;
                    }
                    else {
                        toast("Error", resultnew.response, '');
                        $("#centrelisttable").find("tr:gt(0)").remove();
                        $("#centrelist").hide();
                        return;
                    }
                });
            }
            function RemoveRecord() {
                $("#btnRemove").attr('disabled', true);
                var Itemdata = "";
                $("#tb_grdLabSearch tr").find("#chkRemove").filter(':checked').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        Itemdata += $rowid.find("#lblCentreID_" + id).html() + "#";
                    }

                });
                if (Itemdata == "") {
                    toast("Info","Please select the Item",'');
                    $("#btnRemove").attr('disabled', false);
                    return;
                }
                serverCall('DoctorReferalCentreMapping.aspx/RemoveRecord', { DoctorID: $('#<%=lblDoctorID.ClientID%>').html(), TestData: Itemdata }, function (result) {
            var resultnew = JSON.parse(result);
            if (resultnew.status) {
                $("#btnRemove").attr('disabled', false);
                toast("Success","Record Removed Successfully",'');
                GetData();
                return;
            }
            else if (resultnew.response == "Error in CentreID") {
                $("#btnRemove").attr('disabled', false);
                toast("Info", "Your Session Expired...Please Login Again", '');
                return;
            }
            //else if (result.d == "2") {
            //    alert("Duplicate Barcode");
            //    return;
            //}
            else {
                $("#btnRemove").attr('disabled', false);
                toast("Error", "Please Try Again Later",'');
                return;
            }
        });
    }
    </script>
</asp:Content>



