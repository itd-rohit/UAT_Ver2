<%@ Page Language="C#"  AutoEventWireup="true" EnableEventValidation="false"  
CodeFile="ItemWiseRateList.aspx.cs" Inherits="Design_EDP_ItemWiseRateList"  %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 <!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" /> 
  <webopt:BundleReference ID="BundleReference5" runat="server" Path="~/App_Style/chosen.css" />
<link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    </head>
    <body >
    
    <form id="form1" runat="server">


     <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
    <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />

</Scripts>
</Ajax:ScriptManager>
 <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory"  style="text-align:center;"><div class="row"><div class="col-md-24"><b>Item Wise Panel Rate List</b></div> </div>  </div>
     <div class="POuter_Box_Inventory"  style="text-align:center;">
          
   <div class="POuter_Box_Inventory" style="display:none;">
    <div class="Purchaseheader">  Search criteria</div>
       <div class="row">
           <div class="col-md-4"><b>Test Code :&nbsp;</b> </div> 
           <div class="col-md-8"><asp:TextBox ID="txtTestCode" runat="server" CssClass="mytextbox" placeholder="Enter Test Code To Search"></asp:TextBox> </div> 
           <div class="col-md-4"><input type="button" value="Search" class="searchbutton" onclick="SearchData();" /> </div> 
       </div>                
            </div>
   
   <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">  Search criteria</div>
         <div class="row">
             <div class="col-md-3">
                 <label class="pull-left">Sub Group </label>
                                <b class="pull-right">:</b>
             </div>
             <div class="col-md-4">
                  <asp:DropDownList ID="ddlDepartment0" runat="server" class="ddlDepartment0  chosen-select" onchange="Getsubcategory()" > </asp:DropDownList>
             </div>
              <div class="col-md-3">
                  <label class="pull-left">Billing Category </label>
                                <b class="pull-right">:</b>
             </div>
             <div class="col-md-4">
                 <asp:DropDownList ID="ddlbillcategory" runat="server" class="ddlbillcategory  chosen-select" onchange="GetDepartmentItem()"> </asp:DropDownList>
             </div>
             <div class="col-md-3">
                  <label class="pull-left">Department </label>
                                <b class="pull-right">:</b>
             </div>
             <div class="col-md-4">
                 <asp:DropDownList ID="ddlDepartment" runat="server" class="ddlDepartment  chosen-select" onchange="GetDepartmentItem()"></asp:DropDownList>
             </div>
             <div class="col-md-3"></div>
             </div>
              <div class="row">
              
              <div class="col-md-3"><label class="pull-left">Item Name </label>
                                <b class="pull-right">:</b></div>
             <div class="col-md-4"> <asp:DropDownList ID="ddlItem" runat="server"  class="ddlItem  chosen-select" onchange="Search()"></asp:DropDownList>
             </div>
                   <div class="col-md-3"><label class="pull-left">Set Rate </label>
                                <b class="pull-right">:</b> </div>
             <div class="col-md-4">
                 <input id="txtAllRate" style="text-align:center;" type="text" class="numbersOnly"  placeholder="Enter Rate" />
            </div>
                   <div class="col-md-3" style="display:none"> <label class="pull-left">Set MRP Rate </label>
                                <b class="pull-right">:</b> </div>

             <div class="col-md-4" style="display:none"> 
                 <input id="txtallmrp" style="text-align:center;" type="text" class="numbersOnly" placeholder="Enter MRP"  />
                 </div>
                   <div class="col-md-3">Tagged PUP : <asp:CheckBox ID="chkTaggedPUP" runat="server" /></div>
                   </div>
        </div> 
        <div class="POuter_Box_Inventory" style="text-align:center">
            <div class="row"><div class="col-md-24">
        <input id="btnSave" type="button" value="Save"  onclick="SaveRate();" class="searchbutton" style="display:none;"   />
        <asp:Button ID="btnExcelExport" runat="server" class="searchbutton" Text="Export To Excel" BackColor="White" OnClick="btnExcelExport_Click" style="display:none;"/>

            <input type="button" value="Export To Excel" class="searchbutton" onclick="getexcelreport();" style="display:none;"/>
                  </div> </div>
        </div>
       <div class="POuter_Box_Inventory"> 
           <div id="div_InvestigationItems"  style="max-height:800px; overflow-y:auto; overflow-x:hidden;"> </div>
        </div>
        
        </div> 
        
        </div> 
   
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Panel ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Item ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:220px;">Client Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Rate</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Client Display Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Item Code</th>
		        <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">MRP Rate</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">
			<input id="chkheader" type="checkbox"  onclick='ckhall();' /></th>
	       

</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
<tr id="<#=j+1#>"  style="background-color:White;">
<td class="GridViewLabItemStyle" style="text-align:center;" ><#=j+1#></td>
<td id="<#=objRow.Panel_ID#>"  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Panel_ID#></td>
<td id="<#=objRow.ItemID#>"  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.ItemID#></td>
<td id="<#=objRow.PanelName#>"  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.PanelName#></td>

<td class="GridViewLabItemStyle"  Style="width:70px; text-align:right" id="txt_Rate" >
<input style="text-align:right;" id="txt_Rate<#=j+1#>" <#if(objRow.SpecialFlag==1){#>disabled="disabled"<#}#> type="text" value="<#=objRow.Rate#>" width="50px" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);"/><span id="lblRate" Style="width:50px;"><#=objRow.Rate#></span>
</td>
<td class="GridViewLabItemStyle" style="text-align:left;"><input style="text-align:center;" id="txt_DisplayName<#=j+1#>" <#if(objRow.SpecialFlag==1){#>disabled="disabled"<#}#> type="text" value="<#=objRow.ItemDisplayname#>"  onkeyup="splcharval(this);" onblur="splcharval(this);" /><span id="lbldisplayname" ><#=objRow.ItemDisplayName#></span></td>
<td class="GridViewLabItemStyle" style="text-align:center;"><input style="text-align:center;" id="txt_Itemcode<#=j+1#>" <#if(objRow.SpecialFlag==1){#>disabled="disabled"<#}#> type="text" value="<#=objRow.ItemCode#>"  onkeyup="splcharval(this);" onblur="splcharval(this);" /><span id="lblItemcode" ><#=objRow.ItemCode#></span></td>
  <td class="GridViewLabItemStyle" Style="width:70px; text-align:right;display:none" ><input style="text-align:right;" class="mrp" id="txt_mrprate<#=j+1#>" <#if(objRow.SpecialFlag==1){#>disabled="disabled"<#}#> type="text" tabindex="-1" value="<#=objRow.erate#>"  onkeyup="txtRateVal(this);" onblur="txtRateVal(this);" style="width:100px;" /><span id="spmrprate" ><#=objRow.erate#></span></td>
<td class="GridViewLabItemStyle" style="text-align:center;"><input style="text-align:center;" id="chk_Itemcode<#=j+1#>"  type="checkbox" onclick="alterRate('<#=j+1#>');" <#if(objRow.chk=="checked"){#>checked="checked" <#}#>/></td>



</tr>

            <#}#>

     </table>    
    </script>
    <script type="text/javascript">

        var regid = '<%=regid%>';
        function txtRateVal(id) {

            id.value = id.value.replace(/[^0-9]/g, '');
        }
        function splcharval(id) {
            id.value = id.value.replace(/[#|\']/g, '');
        }
        function CheckItemSelectedOrNot() {
            var Itemdata = "";
            $("#tb_grdLabSearch tr").find(':checkbox').filter(':checked').each(function () {

                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header")
                    Itemdata += $rowid.find("td:eq(" + 1 + ") ").attr("id") + '|' + $rowid.find("#txt_Rate" + id).val() + '|' + $rowid.find("#txt_DisplayName" + id).val() + '|' + $rowid.find("#txt_DisplayName" + id).val() + '|' + $rowid.find("#txt_Itemcode" + id).val() + '|' + $rowid.find("#txt_mrprate" + id).val() + "#";

            });
            if (Itemdata == "") {
                toast("Info", "Please select an item",'');
                $("#btnSave").attr('disabled', false);
                return false;
            }
            else {
                return true;
            }
        }
        function SaveRate() {
            $("#btnSave").attr('disabled', true);

            var Itemdata = "";
            $("#tb_grdLabSearch tr").find(':checkbox').filter(':checked').each(function () {

                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header")
                    Itemdata += $rowid.find("td:eq(" + 1 + ") ").attr("id") + '|' + $rowid.find("#txt_Rate" + id).val() + '|' + $rowid.find("#txt_DisplayName" + id).val() + '|' + $rowid.find("#txt_DisplayName" + id).val() + '|' + $rowid.find("#txt_Itemcode" + id).val() + '|' + $rowid.find("#txt_mrprate" + id).val() + "#";

            });
            if (Itemdata == "") {
                toast("Info", "Please Select Item", '');
                $("#btnSave").attr('disabled', false);
                return;
            }
            var ItemID = '';
            ItemID = $("#<%=ddlItem.ClientID %>").val() + '#' + $("#<%=ddlItem.ClientID %> option:selected").text();;
            var TaggedPUP = "0";
            if (confirm('Do You Want To Transfer That Rate To Its Tagged PUP....!') == true) {
                TaggedPUP = "1";
            }
            try {
                serverCall('../Lab/Services/ItemMaster.asmx/SaveItemWisePanelRate', { ItemID: ItemID, ItemData: Itemdata, TaggedPUP: TaggedPUP }, function (response) {
                    if (response == "1") {
                        $('#<%=chkTaggedPUP.ClientID%>').prop("checked", false);
                        $("#tb_grdLabSearch tr").remove();
                        $("#btnSave").hide();
                        toast("Success", "Record Saved Successfully", '');
                        $("#txtAllRate").val('');
                        $("#txtallmrp").val('');
                        Search();
                    }
                    else {
                        toast("Error", "Record Not Saved", '');
                    }
                    $("#btnSave").attr('disabled', false);
                });
            } catch (e) {
                toast("Error", "Error has occured Record Not saved ", '');
                $("#btnSave").attr('disabled', false);
            }
        }
  </script>
        <script type="text/javascript">
            function ckhall() {
                if ($("#chkheader").is(':checked')) {
                    $("#tb_grdLabSearch :checkbox").attr('checked', 'checked');
                    $("#tb_grdLabSearch :text").show();
                    $("#tb_grdLabSearch").find("#lblItemcode,#lbldisplayname,#lblRate,#spmrprate").hide();
                }
                else {
                    $("#tb_grdLabSearch :checkbox").removeAttr('checked');
                    $("#tb_grdLabSearch :text").hide();
                    $("#tb_grdLabSearch").find("#lblItemcode,#lbldisplayname,#lblRate,#spmrprate").show();
                }
            }
            var PatientData = "";
            function Search() {
                serverCall('../Lab/Services/ItemMaster.asmx/GetItemWisePanelRate', { ItemID: $("#<%=ddlItem.ClientID %>").val() }, function (response) {
                    PatientData = jQuery.parseJSON(response);
                    if (PatientData.length != 0) {
                        $("#btnSave").show();
                    }
                    else
                        $("#btnSave").hide();

                    var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                    $('#div_InvestigationItems').html(output);
                    $("#tb_grdLabSearch :text").hide();
                    $('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
                  });                              

            }
  </script>
    
<script type="text/javascript">
    function alterRate(ckhid) {
        if ($("#chk_Itemcode" + ckhid).prop('checked')) {
            $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find(":text").show();
            $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find("#lblItemcode,#lbldisplayname,#lblRate,#spmrprate").hide();
        }
        else {
            $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find(":text").hide();
            $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find("#lblItemcode,#lbldisplayname,#lblRate,#spmrprate").show();
        }

        if ($("#chkheader").attr('checked') == true && $("#chk_Itemcode" + ckhid).attr('checked') == false) {
            $("#chkheader").attr('checked', '');
        }
    }
    $(function () {
        $('.numbersOnly').keyup(function () {
            this.value = this.value.replace(/[^0-9\.]/g, '');
        });

        $('.txtonly').keyup(function () {
            this.value = this.value.replace(/[^A-Z\.\a-z\ ]/g, '');
        });
    });
    $(function () {
$("#Pbody_box_inventory").css('margin-top', 0);
        if (regid == "") {
            Getsubcategorygroup();
           // GetDepartmentItem();
        }
        else {
            Search();
        }
        $("#btnSave").hide();

        var ItemID = '';
        var ItemName = '';
        $("#txtAllRate").bind('keyup', function () {
            if (CheckItemSelectedOrNot()) {
                $('#tb_grdLabSearch tr').find("#txt_Rate").find(":text").val($("#txtAllRate").val());
            }
            else {
                this.value = "";
            }
        });
        $("#txtallmrp").bind('keyup', function () {
            if (CheckItemSelectedOrNot()) {
                $('#tb_grdLabSearch tr').find(".mrp").val($("#txtallmrp").val());
            }
            else {
                this.value = "";
            }
        });
    });
    var PatientData = "";
    function GetDepartmentItem() {
        try
        {
            $("#<%=ddlItem.ClientID %> option").remove();
            var ddlItem = $("#<%=ddlItem.ClientID %>");
            ddlItem.attr("disabled", true);
            serverCall('../Lab/Services/ItemMaster.asmx/GetDepartmentWiseItem', { SubCategoryID: $("#<%=ddlDepartment.ClientID %>").val(), billcategory: $("#<%=ddlbillcategory.ClientID %>").val() }, function (response) {
                PatientData = jQuery.parseJSON(response);
                if (PatientData.length == 0) {
                    $("#btnSave").hide();
                    ddlItem.append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < PatientData.length; i++) {
                        ddlItem.append($("<option></option>").val(PatientData[i].ItemID).html(PatientData[i].TypeName));
                    }
                    $("#btnSave").show();
                }
                if ($("#<%=ddlItem.ClientID %>").val() != "0") {
                    Search();
                }
                ddlItem.attr("disabled", false);
                ddlItem.trigger('chosen:updated');
            });
        } catch (e) {
            $("#btnSave").hide();
            toast("Error", "Error ", '');
            ddlItem.attr("disabled", false);
        }       
    }




    function getexcelreport() {
        serverCall('ItemWiseRateList.aspx/setexcelreport', { itemid: $('#<%=ddlItem.ClientID%> option:selected').val(), itemname: $('#<%=ddlItem.ClientID%> option:selected').text() }, function (response) {
            window.open('../../Design/Finanace/ExportToExcel.aspx');
        });
    }

function Getsubcategorygroup() {
    try
    {
        $("#<%=ddlDepartment0.ClientID %> option").remove();
        var ddlSubCategory = $("#<%=ddlDepartment0.ClientID %>");
        ddlSubCategory.attr("disabled", true);

        serverCall('../Lab/Services/ItemMaster.asmx/Getsubcategorygroupnew', { }, function (response) {
            PatientData = jQuery.parseJSON(response);
            if (PatientData.length == 0) {
                ddlSubCategory.append($("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
                for (i = 0; i < PatientData.length; i++) {
                    ddlSubCategory.append($("<option></option>").val(PatientData[i].Displayname).html(PatientData[i].Displayname));
                }
            }
            ddlSubCategory.append($("<option></option>").val("All").html("All"));

            ddlSubCategory.attr("disabled", false);
            ddlSubCategory.trigger('chosen:updated');
            Getsubcategory()
        });
    } catch (e) {
        toast("Error", "Error ", '');
        ddlSubCategory.attr("disabled", false);
    }   
};

    function Getsubcategory() {
        try {
            $("#<%=ddlDepartment.ClientID %> option").remove();
            var ddlSubCategory1 = $("#<%=ddlDepartment.ClientID %>");
            ddlSubCategory1.attr("disabled", true);
            serverCall('../Lab/Services/ItemMaster.asmx/Getsubcategorynew', { CategoryId: $("#<%=ddlDepartment0.ClientID %>").val() }, function (response) {
                var PatientData = jQuery.parseJSON(response);
                if (PatientData.length == 0) {
                    ddlSubCategory1.append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < PatientData.length; i++) {
                        ddlSubCategory1.append($("<option></option>").val(PatientData[i].SubcategoryID).html(PatientData[i].Name));
                    }
                }
                ddlSubCategory1.append($("<option></option>").val("All").html("All"));

                ddlSubCategory1.attr("disabled", false);
                ddlSubCategory1.trigger('chosen:updated');
                GetDepartmentItem();
            });
        } catch (e) {
            toast("Error", "Error ", '');
            ddlSubCategory1.attr("disabled", false);
        }
    };
    function SearchData() {
        var TestCode = $('#<%= txtTestCode.ClientID%>').val();
        if (TestCode == "") {
            toast("Info", 'Please Enter Test Code', '');
            return;
        }

        serverCall('ItemWiseRateList.aspx/SearchItemWithCode', { TestCode: TestCode }, function (response) {
            var TestData = jQuery.parseJSON(response);
            if (TestData.length == 0) {
                toast("Error", "Record Not Found..! ", '');
                $('#tb_grdLabSearch tbody').empty();
                return false;
            }
            else {
                $('#<%=ddlDepartment0.ClientID%>').val(TestData[0].Name);
                Getsubcategory();
                $('#<%=ddlDepartment.ClientID%>').val(TestData[0].SubCategoryID);
                GetDepartmentItem();
                $('#<%=ddlItem.ClientID%>').val(TestData[0].ItemID);
                Search();

            }
        });            
    }
  
    </script> 
    <script type="text/javascript">
        $(document).ready(function () {
            $(function () {
                $('#divMasterNav').hide();
            });
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
    <style>
        [type=text] {
            padding: 3px 0px;
            margin: 0px 0;
            display: inline-block;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
    </style>
</form>
</body>
</html>

