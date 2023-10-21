<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="Fieldboy_Master.aspx.cs" Inherits="Design_Master_Fieldboy_Master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        
            <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
  
 <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
<style type="text/css">
    .multiselect{width:100%;}
    

</style>
  <div id="Pbody_box_inventory" >
      <Ajax:ScriptManager runat="server" ID="sc"></Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align:center; ">
   
<b>Field boy Master</b>&nbsp;<br />
<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
   

</div>
      <div class="POuter_Box_Inventory" >
          

                <table style="width:100%;border-collapse:collapse" >
                  <tr><td style="text-align:right"><b>Name :&nbsp;</b></td>
                      <td><asp:TextBox ID="txtName" runat="server" Width="240px" MaxLength="50" ></asp:TextBox>
                      </td>
                       <td style="text-align:right"><b>Age :&nbsp;</b></td>
                       <td><asp:TextBox ID="txtAge" runat="server" Width="60px" MaxLength="3" ></asp:TextBox>
                         </td>
                       <td style="text-align:right"><b>Mobile :&nbsp;</b> </td>
                       <td><asp:TextBox ID="txtMobile" runat="server" Width="130px" MaxLength="10" ></asp:TextBox>
                           
                       </td>
                       
                       </tr>
                    <tr><td style="text-align:right"><b>Address :&nbsp;</b></td>
                      <td><asp:TextBox ID="txtAddress" runat="server" Width="240px" MaxLength="200" ></asp:TextBox></td>
                       <td style="text-align:right"><b>Business Zone :&nbsp;</b></td>
                       <td>
                           <asp:ListBox ID="lstBusinessZone" runat="server"  CssClass="multiselect"   SelectionMode="Multiple" Width="260px"></asp:ListBox>
                        </td>
                       <td style="text-align:right"><b>State :&nbsp;</b></td>
                       <td><asp:DropDownList ID="ddlState" runat="server" Width="136px" onchange="bindCity();"></asp:DropDownList> </td>
                       
                       </tr>
                    <tr><td style="text-align:right"><b>City :&nbsp;</b> </td>
                      <td> <asp:DropDownList ID="ddlCity" runat="server" Width="136px" ></asp:DropDownList> </td>
                       <td style="text-align:right"><b>HomeCollection :&nbsp;</b></td>
                       <td>
                           <asp:CheckBox ID="chkHomeCollection" runat="server"  Checked="true"  /> 
                            </td>
                       <td style="text-align:right"><b><%--ID :--%>&nbsp;</b> </td>
                    <td><asp:Label ID="lblID" runat="server" style="display:none"></asp:Label>
                        <asp:Label ID="lblStateID" runat="server"  Style="display:none"></asp:Label>
                        <asp:CheckBox ID="chkIsActive" runat="server" Text="IsActive" Checked="true" ForeColor="#FF3333" /> 
                    </td>
                       
                       </tr>
                </table>

               
               
              </div> 
        
       
          <div class="POuter_Box_Inventory" style="text-align:center;">
              
                   <input type="button" id="btnSave" value="Save" onclick="SaveRecord()" tabindex="9" class="savebutton" />
                     <input type="button" value="Cancel" onclick="clearData()" class="resetbutton" />
                  
                 </div>
         <div class="Outer_Box_Inventory"  > 
        <div id="div_InvestigationItems"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;">
                
            </div>
             </div>
   
   
  </div>
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"   style="border-collapse:collapse; width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px">Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:110px">Mobile</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:180px">Address</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px">State</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px">City</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px">HomeCollection</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px">Select</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">Map Zone</th>
	
	       

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
<td class="GridViewLabItemStyle" style=""><#=objRow.NAME#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.Age#></td>
<td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Mobile#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.Address#></td> 
<td class="GridViewLabItemStyle" style=""><#=objRow.state#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.City#></td>
 <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.HomeCollection#></td>
<td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Status#></td>

    
<td class="GridViewLabItemStyle" style="text-align:center"><img id="img1" src="../../App_Images/Post.gif"   onclick="ShowDetail('<#=objRow.FeildBoyID#>')" style="cursor:pointer;"/></td>
<td class="GridViewLabItemStyle" style="display:none;"></td>
</tr> 
<#}#> 
        </table>
          
          </script>  
    <script type="text/javascript">
        $(function () {
            $('[id*=lstBusinessZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
         </script>  
    <script type="text/javascript">
        $(function () {        
            GetData();
        });
        function ShowDetail(_ID) {            
            $.ajax({
                url: "Fieldboy_Master.aspx/ShowDetail",
                data: '{_ID:"' + _ID + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async:false,
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    $("#<%=lblID.ClientID %>").html(PatientData[0].FeildBoyID);
                    $("#<%=txtName.ClientID %>").val(PatientData[0].NAME);
                    $("#<%=txtAge.ClientID %>").val(PatientData[0].Age);
                    $("#<%=txtMobile.ClientID %>").val(PatientData[0].Mobile);
                    $("#<%=txtAddress.ClientID %>").val(PatientData[0].Address);

                                                          
                    bindBusinessZone(1);
                    bindSelectedZone(PatientData[0].FeildBoyID);

                  
                    var BusinessZoneID = $('#lstBusinessZone').multipleSelect("getSelects").join();
                    
                    bindBusinessZoneWiseState(BusinessZoneID);

                    $("#<%=ddlState.ClientID %>").val(PatientData[0].StateID);
                    bindCity();
                    $("#<%=ddlCity.ClientID %>").val(PatientData[0].CityID);
                   
                    

                     if (PatientData[0].IsActive == "1") {
                         $('#<%=chkIsActive.ClientID %>').prop('checked', 'checked');
                    }
                    else {
                         $('#<%=chkIsActive.ClientID %>').prop('checked', false);
                     }
                    
                    if (PatientData[0].HomeCollection == "1") {
                        $('#<%=chkHomeCollection.ClientID %>').prop('checked', 'checked');
                    }
                    else {
                        $('#<%=chkHomeCollection.ClientID %>').prop('checked', false);
                    }
                    $("#btnSave").val('Update');
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });


        }
        function bindSelectedZone(FieldBoyID) {
            $.ajax({
            url: "Fieldboy_Master.aspx/bindSelectedBusinessZone",
            data: '{FieldBoyID:"' + FieldBoyID + '"}', // parameter map
            type: "POST", // data has to be Posted    	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            async: false,
            success: function (result) {
                selectedZoneData = jQuery.parseJSON(result.d);
               
                if (selectedZoneData.length > 0) {
                    for (var i = 0; i < selectedZoneData.length; i++) {
                        $('#lstBusinessZone').find(":checkbox[value='" + selectedZoneData[i].ZoneID + "']").attr("checked", "checked");
                        $("[id*=lstBusinessZone] option[value='" + selectedZoneData[i].ZoneID + "']").attr("selected", 1);
                        $('#lstBusinessZone').multipleSelect("refresh");
                    }
                }

            },
            error: function (xhr, status) {
                alert("Error ");
            }

        });
        }

        function SaveRecord() {
            var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;
           
            if ($.trim($("#<%=txtName.ClientID %>").val()) == "") {
                alert("Please Enter Field Boy Name");
                $("#<%=txtName.ClientID %>").focus();
                return;
            }
            if ($("#<%=txtAge.ClientID %>").val() == "") {
                alert("Please Enter Age");
                $("#<%=txtAge.ClientID %>").focus();
                return;
            }
            if ($("#<%=txtMobile.ClientID %>").val() == "") {
                alert("Please Enter Mobile No.");
                $("#<%=txtMobile.ClientID %>").focus();
                return;
            }
            var ItemData = '';
            var SelectedLaength = $('#lstBusinessZone').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                ItemData += $('#lstBusinessZone').multipleSelect("getSelects").join().split(',')[i] + '#';
            }


            if (ItemData == "#") {
                alert('Please Select Business Zone');
                $("#btnSave").removeAttr('disabled').val('Save');
                return;
            }
            if ($("#<%=ddlState.ClientID %>").val() == "0" || $("#<%=ddlState.ClientID %>").val()==null) {
                alert("Please Select State");
                $("#<%=ddlState.ClientID %>").focus();
                return;
            }
            if ($("#<%=ddlCity.ClientID %>").val() == "0" || $("#<%=ddlCity.ClientID %>").val() == null) {
                alert("Please Select City");
                $("#<%=ddlCity.ClientID %>").focus();
                return;
            }                       
            if ($("#btnSave").val() == "Save") {
                $("#<%=lblID.ClientID %>").text('');
            }        
            var HomeCollection = $('#<%=chkHomeCollection.ClientID %>').is(':checked') ? 1 : 0;
            $("#btnSave").attr('disabled', 'disabled').val('Submitting...');
            
            $.ajax({
                url: "Fieldboy_Master.aspx/SaveRecord",
                data: '{ ID:"' + $("#<%=lblID.ClientID %>").text() + '",Name:"' + $("#<%=txtName.ClientID %>").val() + '",Age:"' + $("#<%=txtAge.ClientID %>").val() + '",Mobile:"' + $("#<%=txtMobile.ClientID %>").val() + '",Address:"' + $("#<%=txtAddress.ClientID %>").val() + '",StateID:"' + $("#<%=ddlState.ClientID %>").val() + '",CityID:"' + $("#<%=ddlCity.ClientID %>").val() + '",IsActive:"' + IsActive + '",ItemData:"' + ItemData + '",HomeCollection:"' + HomeCollection + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "-1") {
                        clearform();
                        $("#<%=lblID.ClientID %>").text('');                        
                        alert("Your Session Expired...Please Login Again");                    
                    }
                    else if (result.d == "1") {
                        clearform();
                         alert("Record Saved Successfully");
                        GetData();                       
                    }
                    else if (result.d == "2") {
                        alert("Duplicate Name");                      
                    }
                    else {                    
                        alert("Please Try Again Later");
                       
                    }
                   if( $("#<%=lblID.ClientID %>").text()=="")
                       $("#btnSave").removeAttr('disabled').val('Save');
                   else
                       $("#btnSave").removeAttr('disabled').val('Update');
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function GetData() {
             
            $.ajax({

                url: "Fieldboy_Master.aspx/GetData",
                data: '{}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                    $('#div_InvestigationItems').html(output);

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function BindState() {

            $("#<%=ddlState.ClientID %> option").remove();
           
            $.ajax({
                url: "Fieldboy_Master.aspx/BindState",
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    StateData = jQuery.parseJSON(result.d);
                    if (StateData.length > 0) {
                        for (i = 0; i < StateData.length; i++) { 
                            $("#<%=ddlState.ClientID %>").append($("<option></option>").val(StateData[i].ID).html(StateData[i].State));
                        }
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            }); 
        }
       
        function clearData() {
            clearform();
            $("#<%=lblID.ClientID %>").text('');
            $("#btnSave").val('Save');
        }
        function clearform() {
            $('#txtName,#txtAge,#txtMobile,#txtAddress').val('');

            bindBusinessZone(0);
           // $("#<%=ddlState.ClientID %>").val($("#lblStateID").text());
           // bindCity();
           
             
           // $("#<%=ddlCity.ClientID %> option").remove();
            $('#<%=chkIsActive.ClientID %>').prop('checked', 'checked');
            $("#<%=lblID.ClientID %>").text('');
            $('#<%=chkHomeCollection.ClientID %>').prop('checked', 'checked');
         }
    </script>
    <script type="text/javascript">
        function bindCity() {
            jQuery('#<%=ddlCity.ClientID%> option').remove();
           
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindCity",
                data: '{ StateID: "' + jQuery('#<%=ddlState.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    cityData = jQuery.parseJSON(result.d);
                    if (cityData.length == 0) {
                        jQuery('#<%=ddlCity.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("Select"));
                        for (i = 0; i < cityData.length; i++) {
                            jQuery('#<%=ddlCity.ClientID%>').append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                        }

                       
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    jQuery('#<%=ddlCity.ClientID%>').attr("disabled", false);
                }
            });
        }
        $(function () {
            bindBusinessZone(0);
        });
        function bindBusinessZone(con) {
            jQuery('#<%=lstBusinessZone.ClientID%> option').remove();
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZone",
                data: '{}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    BusinessZoneData = jQuery.parseJSON(result.d);
                    if (BusinessZoneData.length == 0) {
                        jQuery('#<%=lstBusinessZone.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < BusinessZoneData.length; i++) {
                            jQuery('#<%=lstBusinessZone.ClientID%>').append(jQuery("<option></option>").val(BusinessZoneData[i].BusinessZoneID).html(BusinessZoneData[i].BusinessZoneName));
                        }
                        $('[id*=lstBusinessZone]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                        if (con == 0)
                            getCentreBusinessZone();
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    jQuery('#<%=lstBusinessZone.ClientID%>').attr("disabled", false);
                }

            });
        }

        function getCentreBusinessZone() {
            $.ajax({
                url: "../Common/Services/CommonServices.asmx/getCentreBusinessZone",
                data: '{}', 
                type: "POST",       
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    
                    CentreBusinessZone = jQuery.parseJSON(result.d);
                    $('#lstBusinessZone').find(":checkbox[value=" + CentreBusinessZone + "]").attr("checked", "checked");
                    $("[id*=lstBusinessZone] option[value=" + CentreBusinessZone + "]").attr("selected", 1);
                    $('#lstBusinessZone').multipleSelect("refresh");
                  
                   
                    bindBusinessZoneWiseState(CentreBusinessZone);
                },
                error: function (xhr, status) {
                    alert("Error ");
                }

            });


            jQuery("#<%=txtAge.ClientID %>").on("input", function () {
                if ($("#<%=txtAge.ClientID %>").val() > 120) {
                     toast("Error", 'Max Age Should be Less Than 120 Years');
                     jQuery('#txtAge').focus();
                     $("#<%=txtAge.ClientID %>").focus();
                    $("#<%=txtAge.ClientID %>").val('120')
                return false;

            }
             });


        }
        
    </script>
    <script type="text/javascript">
       
        $(function () {           
            $('#lstBusinessZone').on('change', function () {
                var BusinessZoneID = $(this).val();
                bindBusinessZoneWiseState(BusinessZoneID);
            });                    
        });
        function bindBusinessZoneWiseState(BusinessZoneID) {
            jQuery("#ddlState option").remove();
            jQuery("#ddlCity option").remove();
           
            if (BusinessZoneID != "") {
                jQuery.ajax({
                    url: "Fieldboy_Master.aspx/bindBusinessZoneWiseState",
                    data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        stateData = jQuery.parseJSON(result.d);
                        if (stateData.length == 0) {
                            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
                            for (i = 0; i < stateData.length; i++) {
                                jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                            }
                            // bindZone();
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        jQuery("#ddlState").attr("disabled", false);
                    }

                });
            }

        }
    </script>
</asp:Content>


