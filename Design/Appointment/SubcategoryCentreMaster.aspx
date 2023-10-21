<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" CodeFile="SubcategoryCentreMaster.aspx.cs" Inherits="Design_Master_SubcategoryCentreMaster" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server"> 
     
    <script src="../../Scripts/jquery.tablednd.js" type="text/javascript"></script>  
    <script type="text/javascript">
      
        $(document).ready(function () {
           // UserValidate();
            SearchDepartment();
                 
        });
    </script>
    <script type="text/javascript">
        function AddDepartment() {           
            if ($('[id$=ddlSubGroups]').val() == "") {
                toast("Error", "Please Select the Department", "");                
                return;
            }
            serverCall('SubcategoryCentreMaster.aspx/AddDepartment', { CentreID: $('[id$=ddlcenter]').val(), SubCategoryID: $('[id$=ddlSubGroups]').val()}, function (response) {
                if (response == "-1") {                    
                    toast("Error", "Your Session Expired...Pleas Login Again", "");
                    return;
                }
                else if (response == "2") {
                    toast("Error", "Please Select the Department", "");                 
                    return;
                }              
                else if (response == "0") {
                    toast("Error", "Something Went Wrong..Please Try Again Later", "");                    
                    return;
                }
                else {
                    SearchDepartment();
                    toast("Success", "Save Successfully", "");
                }
            });            
        }


        function SearchDepartment() {
            try {
                serverCall('SubcategoryCentreMaster.aspx/SearchDepartment', { CentreID: $('[id$=ddlcenter]').val() }, function (response) {                   
                    PatientData = eval('[' + response + ']');                  
                        if (PatientData.length > 0) {
                            $("#btnSave").show();
                        }
                        else {
                            $("#btnSave").hide();
                        }
                        var output = $('#tb_InvestigationItems').parseTemplate(PatientData);

                        $('#div_InvestigationItems').html(output);
                        $('#div_InvestigationItems').html(output);
                        $("#tb_grdLabSearch").tableDnD({
                            onDragClass: "GridViewDragItemStyle"
                        });
                        $('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");                    
                });          
            }
            catch (e) {
                console.log(e);
                alert(e);
            }
        }    
        function UserValidate() {          
            serverCall('../Lab/Services/LabBooking.asmx/ValidateUser', {}, function (response) {
                var $response = JSON.parse(response);                   
                if (!$response.status) {
                    toast("Error", " Invalid User !!! ", "");
                    window.location.href = window.location.href;                    
                }             
            });           
        }
        function SaveRequest() {
            //UserValidate();                     
            var DeptOrder = "";
            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).closest("tr").attr("id") != "Header") {
                    DeptOrder += $(this).closest("tr").attr("id") + '#';
                }
            });
            if (DeptOrder == "") {
                toast("Error", "Try Again Later", "");                
                return;
            }           
            serverCall('SubcategoryCentreMaster.aspx/SaveOrdering', { CentreID: $('[id$=ddlcenter]').val(), DeptOrder: DeptOrder }, function (response) {
                if (response == "-1") {
                    toast("Error", "Your Session Expired...Pleas Login Again", "");                    
                    return;
                }
                else if (response == "0") {                    
                    toast("Error", "Something Went Wrong..Please Try Again Later", "");
                    return;
                }
                else {
                    SearchDepartment();
                    toast("Success", "Save Successfully", "");
                }
            });           
        }



        function RemoveDepartment(SubCategoryIdID) {
            serverCall('SubcategoryCentreMaster.aspx/RemoveDepartment', { CentreID: $('[id$=ddlcenter]').val(), SubCategoryIdID: SubCategoryIdID }, function (response) {
                if (response == "-1") {
                    toast("Error", "Your Session Expired...Pleas Login Again", "");                    
                    return;
                }
                else if (response == "0") {
                    toast("Error", "Something Went Wrong..Please Try Again Later", "");                    
                    return;
                }
                else {
                    toast("Success", "Remove Successfully", "");
                    SearchDepartment();                    
                }
            });           
        }
    </script>

    
    

    <script id="tb_InvestigationItems" type="text/html">
        <table cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"  style="border-collapse:collapse; cursor: move;width:75%" >
		<tr id="Header" class="nodrop">
			<th class="exporttoexcelheader" scope="col" style="width:20px;">S.No</th>
            <th class="exporttoexcelheader" scope="col" style="width:200px;">Department</th>           
			<th class="exporttoexcelheader" scope="col" style="width:50px;text-align:center">Remove</th> 
        </tr>

       <#
     	var sum = 0;
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j];                         
            #>   <# sum += parseFloat(objRow.MRP); #>
          
            
 <tr  id="<#=objRow.SubcategoryID#>" >
<td class="exporttoexcel"><#=j+1#></td>
<td id="td2>" class="exporttoexcel" style="text-align:left;display:none;font: 12px arial, sans-serif"><#=objRow.SubcategoryID#></td>
<td id="td1"  class="exporttoexcel" style="text-align:left;font: 12px arial, sans-serif"><#=objRow.SubCategoryName#></td>
<td class="exporttoexcel" style="cursor:pointer;text-align:center">
    <img id="imgRmv" src="../../App_Images/Delete.gif"   onclick="RemoveDepartment('<#=objRow.SubcategoryID#>')" /></td>
</tr>
      
            <#}#>               
     </table>    
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                <div style="text-align: center">
                    <b>Centre Department Master</b><br />
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                </div>
                    </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row" style="text-align: left">

                <div class="col-md-24" style="padding-left: 10px;">
                    Center:<asp:DropDownList ID="ddlcenter"  runat="server" Width="286px" onchange="SearchDepartment();" >
                    </asp:DropDownList>

                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Mapped Department
            </div>

            <div style="padding-left: 10px;">
                Department:<asp:DropDownList ID="ddlSubGroups" runat="server" Width="273px" CssClass="ItDoseDropdownbox">
                </asp:DropDownList>

                <input id="btnAdd" class="ItDoseButton" type="button" value="Map Department" onclick="AddDepartment()"/>

            </div>

            <div id="div_mapobservation" style="display: none">
            </div>
            <div class="POuter_Box_Inventory" style="width: 99.6%;">
                <div id="div_InvestigationItems" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="width: 99.6%; padding-top: 2px; padding-bottom: 2px; text-align: center;">
                <input id="btnSave" class="ItDoseButton" type="button" value="Save Ordering" onclick="SaveRequest()" />
            </div>

        </div>
    </div>



</asp:Content>
