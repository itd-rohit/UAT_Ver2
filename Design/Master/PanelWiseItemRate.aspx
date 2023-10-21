<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="PanelWiseItemRate.aspx.cs" Inherits="Design_EDP_PanelWiseItemRate"  %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 <!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" /> 

    </head>
    <body >
    
    <form id="form1" runat="server">


     <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
     <asp:ScriptReference Path="~/Scripts/toastr.min.js" />

</Scripts>
</Ajax:ScriptManager>
 <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory" style="text-align:center;" >    
  <div class="row">
      <div class="col-md-24">
          <b>Client Wise Item Rate List</b>
      </div>
  </div>               
   </div>
   <div class="POuter_Box_Inventory" >
    <div class="Purchaseheader"> 
        Search criteria</div>
       <div class="row">
           <div  class="col-md-3"><label class="pull-left">Group </label>
                                <b class="pull-right">:</b> </div>
           <div  class="col-md-4"><asp:DropDownList ID="DdlGroup" runat="server" CssClass="ItDoseDropdownbox" onchange="PanelRequest();" ></asp:DropDownList></div>
           <div  class="col-md-3"><label class="pull-left">Client </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-4"> <asp:DropDownList ID="ddlPanel" CssClass="ItDoseDropdownbox" onchange="Search()" runat="server"> </asp:DropDownList></div>
                  <div  class="col-md-3"><label class="pull-left">Item Group </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-4"> <asp:DropDownList ID="ddlCategory" runat="server" onchange="Getsubcategorygroup()" > </asp:DropDownList></div>
           <div  class="col-md-3"></div>
       </div>          
         <div class="row">
    
           <div  class="col-md-3"><label class="pull-left">SubGroup </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-4"> <asp:DropDownList ID="ddlSubCategorygroup" runat="server" onchange="Getsubcategory()" > </asp:DropDownList></div>
           <div  class="col-md-3"><label class="pull-left">SubCategory </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-4"><asp:DropDownList ID="ddlSubCategory" runat="server" onchange="Search()" > </asp:DropDownList></div>
           <div  class="col-md-3"><label class="pull-left">Test Name </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-4"> <input id="txtTestname" type="text"/></div>
              <div  class="col-md-3"></div>
       </div>
       <div class="row">
          
           <div  class="col-md-3"><label class="pull-left">Rate </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-2"> <asp:TextBox ID="txtmyrate" runat="server" onkeyup="updatetablerate()" />
                                <cc1:FilteredTextBoxExtender ID="ftbMyrate" runat="server" TargetControlID="txtmyrate" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                               </div>
           <div  class="col-md-2"></div>
           <div  class="col-md-3" style="display:none"><label class="pull-left">MRP Rate </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-2" style="display:none"> <asp:TextBox ID="txtmymrprate" runat="server" onkeyup="updatetablemrprate()" />
                <cc1:FilteredTextBoxExtender ID="ftbmymrprate" runat="server" TargetControlID="txtmymrprate" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
           </div>
           
            <div  class="col-md-3"><label class="pull-left">Search By Name </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-7"> <asp:RadioButtonList ID="rblsearchtype" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True" Value="0">By First Name</asp:ListItem>
                                    <asp:ListItem Value="1">In Between</asp:ListItem>
                                </asp:RadioButtonList></div>
       </div>
          <div class="row">
           <div  class="col-md-3"><label class="pull-left">Billing Category </label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-4"> <asp:DropDownList ID="ddlbillcategory" runat="server" onchange="Search()"> </asp:DropDownList></div>
           <div  class="col-md-3"><label class="pull-left"> Tagged PUP</label>
                                <b class="pull-right">:</b></div>
           <div  class="col-md-4"> <asp:CheckBox ID="chkTaggedPUP" runat="server" /></div>
       </div>
         <div class="row" style="text-align:center"><div class="col-md-20"> 
             <input id="btnSearch" type="button" value="Search"  onclick="Search();" class="ItDoseButton" style="width:60px;"   />
              <input id="btnSave" type="button" value="Save"  onclick="save();" class="ItDoseButton" style="width:60px; display:none;"   />
             </div>
             <div class="col-md-4">
              <input id="btnexcel" type="button" value="ExportToExcel"  onclick="exporttoexcel();" class="ItDoseButton" style="width:100px;"   />
                                                    </div> </div>
        </div>
      
       
       
       <div class="POuter_Box_Inventory"  > 
            <div class="row"><div class="col-md-24">
        <div id="div_InvestigationItems"  style="max-height:250px; overflow-y:auto; overflow-x:hidden;">
                
            </div>
        </div>   
                 </div>
        </div>                     
  
            </div>            
       
   
   <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:100%">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Category</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">SubCategory</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Test Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:340px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Rate</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">Panel Display Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">ItemCode</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width:90px;display:none">MRPRate</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> <input id="chkheader" type="checkbox"  onclick='ckhall();' /></th>
	       

</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=j+1#>" 
                                         style="background-color:<#=objRow.CategoryName#>;">
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="<#=objRow.CategoryID#>"  class="GridViewLabItemStyle"><#=objRow.CategoryName#></td>
<td id="<#=objRow.SubCategoryId#>"  class="GridViewLabItemStyle"><#=objRow.SubCategoryName#></td>
 <td id="<#=objRow.ItemID#>"  class="GridViewLabItemStyle" Style="width:200px;text-align:center;"><#=objRow.TestCode#></td>
<td id="<#=objRow.ItemID#>"  class="GridViewLabItemStyle" Style="width:200px"><#=objRow.TypeName#></td>
<td class="GridViewLabItemStyle"  Style="width:70px; text-align:right"   > 
<input id="txt_Rate<#=j+1#>" type="text" value="<#=objRow.Rate#>" <#if(objRow.SpecialFlag==1){#>disabled="disabled"<#}#> style="width:100px;text-align:right" class="rtx" onkeyup="txtRateVal(this);" onblur="txtRateVal(this);"/> 
<span id="lblRate" Style="width:50px;"><#=objRow.Rate#></span>
</td>
<td class="GridViewLabItemStyle" ><input id="txt_DisplayName<#=j+1#>" <#if(objRow.SpecialFlag==1){#>disabled="disabled"<#}#> type="text" tabindex="-1" value="<#=objRow.ItemDisplayName#>"  onkeyup="splcharval(this);" onblur="splcharval(this);" /><span id="lbldisplayname" ><#=objRow.ItemDisplayName#></span></td>
<td class="GridViewLabItemStyle" ><input id="txt_Itemcode<#=j+1#>" <#if(objRow.SpecialFlag==1){#>disabled="disabled"<#}#> type="text" tabindex="-1" value="<#=objRow.ItemCode#>"  onkeyup="splcharval(this);" onblur="splcharval(this);" /><span id="lblItemcode" ><#=objRow.ItemCode#></span></td>
                        <td class="GridViewLabItemStyle" Style=" text-align:right;display:none"><input id="txt_mrprate<#=j+1#>" <#if(objRow.SpecialFlag==1){#>disabled="disabled"<#}#> type="text" tabindex="-1" value="<#=objRow.ERate#>" class="mrtx"  onkeyup="txtRateVal(this);" onblur="txtRateVal(this);" style="width:100px;text-align:right" /><span id="spmrprate" ><#=objRow.ERate#></span></td>
<td class="GridViewLabItemStyle"  ><input id="chk_Itemcode<#=j+1#>" type="checkbox" tabindex="-1" onclick="alterRate('<#=j+1#>');" class="ch" /></td>


</tr>

            <#}#>

     </table>    
    </script>
   
    <script type="text/javascript">
        function txtRateVal(id) {
            id.value = id.value.replace(/[^0-9]/g, '');
        }
        function splcharval(id) {
            id.value = id.value.replace(/[#|\']/g, '');
        }
        var PanelData = ""
        function PanelRequest() {
            $("#<%=ddlPanel.ClientID %> option").remove();
            var ddlPanel = $("#<%=ddlPanel.ClientID %>");
            ddlPanel.attr("disabled", true);
            try {
                serverCall('../Lab/Services/ItemMaster.asmx/GetPanel', { GroupID: $("#<%=DdlGroup.ClientID %>").val() }, function (response) {
                    PanelData = jQuery.parseJSON(response);
                    if (PanelData.length == 0) {
                        ddlPanel.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < PanelData.length; i++) {
                            ddlPanel.append($("<option></option>").val(PanelData[i].PanelID).html(PanelData[i].Company_Name));
                        }
                    }
                    ddlPanel.attr("disabled", false);
                    Search();
                });
            }
            catch (e) {
                toast("Error", "Error Occured..!", "");
                ddlPanel.attr("disabled", false);
            }
        }
   </script>
   
   
   <script type="text/javascript">
       var PatientData = "";
       function Search() {
           try {
               serverCall('../Lab/Services/ItemMaster.asmx/GetPanelwiseItemRate', { PanelId:  $("#<%=ddlPanel.ClientID %>").val() ,CategoryId: $("#<%=ddlCategory.ClientID %>").val(),SubCategoryId:  $("#<%=ddlSubCategory.ClientID %>").val(),billcategory: $('#<%=ddlbillcategory.ClientID%>').val()  }, function (response) {
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
                    if ($("#<%=ddlSubCategory.ClientID %>").val() == 'All') {
                       $('#tb_grdLabSearch tr').hide();
                       $("#chkheader").hide();
                   }
                });
            }
            catch (e) {
                toast("Error", "Error Occured..!", "");               
            }
       }
       function Getsubcategory() {

           $("#<%=ddlSubCategory.ClientID %> option").remove();
           var ddlSubCategory1 = $("#<%=ddlSubCategory.ClientID %>");
           ddlSubCategory1.attr("disabled", true);

           try {
               serverCall('../Lab/Services/ItemMaster.asmx/Getsubcategorynew', { CategoryId: $("#<%=ddlSubCategorygroup.ClientID %>").val() }, function (response) {
                   PatientData = jQuery.parseJSON(response);
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
                    Search();
                });
            }
            catch (e) {
                toast("Error", "Error Occured..!", "");
                ddlSubCategory1.attr("disabled", false);
            }
       };

       function Getsubcategorygroup() {
           $("#<%=ddlSubCategorygroup.ClientID %> option").remove();
           var ddlSubCategory = $("#<%=ddlSubCategorygroup.ClientID %>");
           ddlSubCategory.attr("disabled", true);

           try {
               serverCall('../Lab/Services/ItemMaster.asmx/Getsubcategorygroup', { CategoryId: $("#<%=ddlCategory.ClientID %>").val() }, function (response) {
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
                    Getsubcategory()
                });
            }
            catch (e) {
                toast("Error", "Error Occured..!", "");
                ddlSubCategory.attr("disabled", false);
            }
       };
       function exporttoexcel() {
           if ($("#<%=ddlPanel.ClientID %>").val() == "-") {
               toast("Error", "Please select client", "");
               return;
           }
           serverCall('PanelWiseItemRate.aspx/searchdataexcel', { PanelID: $("#<%=ddlPanel.ClientID %>").val() }, function (response) {
               $responseData = $.parseJSON(response);
               if ($responseData.status) {
                   if ($responseData.response == 1) {
                       window.open('../common/ExportToExcel.aspx');
                   }
                   else {
                       toast("Error", $responseData.response, "");
                       return;
                   }
               }
               else {
                   toast("Error", $responseData.response, "");
                   return;
               }
           });
       }

   </script>
   <script type="text/javascript">
       $(function () {
$("#Pbody_box_inventory").css('margin-top', 0);
           $("#tb_grdLabSearch :text").hide();
           $('#divMasterNav').hide();
       });
       function ckhall() {
           if ($("#chkheader").is(':checked')) {
               $("#tb_grdLabSearch :checkbox").attr('checked', 'checked');
               $("#tb_grdLabSearch :text").show();
              
               $("#tb_grdLabSearch").find("#lblItemcode,#lbldisplayname,#lblRate,#spmrprate").hide();
           }
           else {
               $("#tb_grdLabSearch :checkbox").attr('checked', false);
               $("#tb_grdLabSearch :text").hide();
               $("#tb_grdLabSearch").find("#lblItemcode,#lbldisplayname,#lblRate,#spmrprate").show();
           }

       }

       function alterRate(ckhid) {
           if ($("#chk_Itemcode" + ckhid).is(':checked')) {
               $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find(":text").show();
               $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find("#lblItemcode,#lbldisplayname,#lblRate,#spmrprate").hide();
           }
           else {
               $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find(":text").hide();
               $("#tb_grdLabSearch").find("tr:eq(" + ckhid + ") ").find("#lblItemcode,#lbldisplayname,#lblRate,#spmrprate").show();
           }

           if ($("#chkheader").is(':checked') == true && $("#chk_Itemcode" + ckhid).is(':checked') == false) {
               $("#chkheader").prop('checked', false);
           }
       }
   </script>
   
   
   <script type="text/javascript">
       function save() {

           $("#btnSave").attr('disabled', true);
           var Itemdata = "";
           $("#tb_grdLabSearch tr").find(':checkbox').filter(':checked').each(function () {

               var id = $(this).closest("tr").attr("id");
               var $rowid = $(this).closest("tr");
               if (id != "Header")
                   Itemdata += $rowid.find("td:eq(" + 3 + ") ").attr("id") + '|' + $rowid.find("td:eq(" + 3 + ") ").html() + '|' + $rowid.find("#txt_Rate" + id).val() + '||' + $rowid.find("#txt_DisplayName" + id).val() + '|' + $rowid.find("#txt_Itemcode" + id).val() + '|' + $rowid.find("#txt_mrprate" + id).val() + "#";

           });
           if (Itemdata == "") {
               alert("Please select an item");
               $("#btnSave").attr('disabled', false);
               return;
           }
           // var TaggedPUP = ($('#<%=chkTaggedPUP.ClientID%>').is(':checked') == true) ? "1" : "0";
           var TaggedPUP = "0";
           //if (confirm('Do You Want To Transfer That Rate To Its Tagged PUP....!') == true) {
           //    TaggedPUP = "1";
           //}

           try {
               serverCall('../Lab/Services/ItemMaster.asmx/SavePanelwiseItemrate', { PanelId: $("#<%=ddlPanel.ClientID %>").val(), ItemData: Itemdata, TaggedPUP: TaggedPUP }, function (response) {
                   if (response == "1") {

                       $('#<%=chkTaggedPUP.ClientID%>').prop("checked", false);
                    //   $('#<%=ddlPanel.ClientID %>,#<%=ddlCategory.ClientID %>,#<%=ddlbillcategory.ClientID %>').prop('selectedIndex', 0);


                      // $("#<%=ddlSubCategorygroup.ClientID %> option").remove();
                     //  $("#<%=ddlSubCategory.ClientID %> option").remove();
                       $("#tb_grdLabSearch tr").remove();
                       $("#txtTestname,#<%=txtmyrate.ClientID %>,#<%=txtmymrprate.ClientID %>").val('');
                       $("#btnSave").hide();
                       toast("Success", "Record Saved Successfully", "");
                       Search();
                   }
                   else {
                       toast("Error", "Record Not Saved", "");
                   }
                   $("#btnSave").attr('disabled', false);
               });
           }
           catch (e) {
               toast("Error", "Error has occurred Record Not saved", "");
               $("#btnSave").attr('disabled', false);
           }
       }
  </script>
   <script type="text/javascript">
       $(function () {
           $("#txtTestname").keyup(function () {
               var val = $(this).val();
               var len = $(this).val().length;

               if (val != "" || ($("#<%=ddlSubCategory.ClientID %>").val() == 'All'))
                   $("#chkheader").hide();
               else
                   $("#chkheader").show();

               $("#tb_grdLabSearch tr").hide();
               $("#tb_grdLabSearch tr:first").show();

               var searchtype = $("#<%=rblsearchtype.ClientID%>").find('input[checked]').val();

               if (searchtype == "0") {

                   $("#tb_grdLabSearch tr").find("td:eq(" + 4 + ") ").filter(function () {
                       if (val == "" && ($("#<%=ddlSubCategory.ClientID %>").val() == 'All')) {
                           return $(this).parent('tr').find(':checkbox').attr('checked');
                       }
                       else {

                           if ($(this).text().substring(0, len).toLowerCase() == val.toLowerCase() || $(this).parent('tr').find(':checkbox').attr('checked'))
                               return $(this);
                       }

                   }).parent('tr').show();

               }
               else {
                   $("#tb_grdLabSearch tr").find("td:eq(" + 3 + ") ").filter(function () {
                       if (val == "" && ($("#<%=ddlSubCategory.ClientID %>").val() == 'All')) {
                           return $(this).parent('tr').find(':checkbox').attr('checked');
                       }
                       else {
                           if ($(this).text().toLowerCase().match(val.toLowerCase()) || $(this).parent('tr').find(':checkbox').attr('checked'))
                               return $(this);
                       }

                   }).parent('tr').show();
               }
           });
       });
   function updatetablerate() {
       var vall = $('#<%=txtmyrate.ClientID%>').val();
           if (vall == "") {
               vall = "0";
           }
           $('#tb_grdLabSearch tr').each(function () {
               if ($(this).attr("id") != "Header" && $(this).find(".ch").is(':checked')) {
                   $(this).find(".rtx").val(vall);
               }
           });
       }
       function updatetablemrprate() {
           var vall = $('#<%=txtmymrprate.ClientID%>').val();
           if (vall == "") {
               vall = "0";
           }
           $('#tb_grdLabSearch tr').each(function () {
               if ($(this).attr("id") != "Header" && $(this).find(".ch").is(':checked')) {
                   $(this).find(".mrtx").val(vall);
               }
           });
       }
    </script>

</form>
</body>
</html>

