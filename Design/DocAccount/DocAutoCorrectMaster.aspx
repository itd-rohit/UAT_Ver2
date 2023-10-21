<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static"
    CodeFile="~/Design/DocAccount/DocAutoCorrectMaster.aspx.cs" Inherits="Design_DocAccount_DocShareMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
  
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
   
     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
   
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Auto Correct Master </b>                    
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>            
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-12" style="font-weight:bold">
                     <asp:RadioButtonList ID="rblSearchType" runat="server"  RepeatDirection="Horizontal">
                <asp:ListItem Selected="True" Text="Set Auto Correct" Value="1"></asp:ListItem>
            </asp:RadioButtonList>
                </div>
                <div class="col-md-6">
                    <input type="button" style="display:none" value="Transfer Doctor Share" class="searchbutton" onclick="showPopUp()"/>
                </div>
                <div class="col-md-6">
                              <input type="button" style="display:none" value="Change Doctor Share Status" class="searchbutton" onclick="showPopUpStatus()"/>
                    </div>
            </div>            <div class="row">
                          <cc1:TabContainer ID="TabContainer1" runat="server" Width="99%" Height="485px"   ActiveTabIndex="0" Font-Size="Larger"   OnClientActiveTabChanged="clientActiveTabChanged" >
                              <cc1:TabPanel runat="server" HeaderText="Department" ID="tabPanelDepartment" Width="99%" BackColor="#cccccc" Font-Size="Larger"  Height="480px"  >
                    <ContentTemplate>
                        <table style="width: 100%; border-collapse: collapse;">
                             
                            <tr >
                                <td>
                                   <b> Department :&nbsp;</b>
                                <asp:DropDownList ID="ddlDept" runat="server" Width="200px" class="chosen-select" onchange="bindDepartment()"></asp:DropDownList>
                                  
                                </td>
                                  <td  id="trDocCategory">
                                   <b> City :&nbsp;</b>
                                    <asp:DropDownList ID="ddlDocCategory" runat="server" class="chosen-select" Width="200px" onchange="bindDepartment()">
                                          <%--<asp:ListItem Text="With In NCR" Value="0"></asp:ListItem>
                                          <asp:ListItem Text="OutSide NCR" Value="1"></asp:ListItem>--%>
                                    </asp:DropDownList>
                                     
                                      
                                </td>
                                <td style="display:none" id="trDeptDoc">
                                   <b> Doctor :&nbsp;</b>
                                
                                    <asp:DropDownList ID="ddlDeptDoctor" runat="server" class="chosen-select" Width="200px" onchange="bindDepartment()"></asp:DropDownList>
                                </td>
                            </tr>
                             
                            <tr>
                                <td  colspan="2">
                                     <div id="DeptShareOutput" style="max-height: 380px; overflow-x: auto; text-align: center">
            </div>
                                </td>
                            </tr>
                          
                            <tr>
                                <td style="text-align:center" colspan="2">
                                     <input type="button" id="btnDepartment" style="display:none" value="Save" onclick="DepartmentSave();"
                        class="savebutton" />
                                </td>
                            </tr>
                        </table>

                         </ContentTemplate>
                </cc1:TabPanel>
            </cc1:TabContainer>
                </div>
        </div>  </div>
        <asp:Button ID="Button1" runat="server" style="display:none;" />
  <cc1:modalpopupextender ID="modelTranferShare" runat="server" CancelControlID="btnClosePopUp" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlTranferShare" BehaviorID="modelTranferShare">
    </cc1:modalpopupextender>

         <asp:Panel ID="pnlTranferShare" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none; width: 580px; max-height: 520px;">
        <div class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>   
                       <td style="text-align:left">
                          <b> Doctor Share Transfer</b>
                       </td>              
                    <td  style="text-align:right">      
                        <img id="btnClosePopUp" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="closePopUp('0')" />  
                    </td>                    
                </tr>
        </table>
             </div>
            <table style="width:100%; border-collapse:collapse" border="0">         
                <tr>
                    <td colspan="2" style="text-align:center">
                         <asp:Label ID="lblPopUpMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>                                         
                <tr>                                      
                    <td  style="text-align:right">   
                      <b>  From Doctor :&nbsp;</b>
                        </td>
                    <td style="text-align:left">
                        <asp:DropDownList ID="ddlFromDocShare" runat="server" class="ddlFromDocShare chosen-select" Width="200px" ></asp:DropDownList>
                    </td>
                    </tr>
                <tr>                             
                    <td colspan="2" style="text-align:center">
                         <img src="../../App_Images/down_arrow.png" alt=""  style="height:26px" />
                        </td>                                    
                          </tr> 
                 <tr>                   
                    <td  style="text-align:right">   
                        <b>To Doctor :&nbsp;</b>
                        </td>
                    <td style="text-align:left">
                        <asp:DropDownList ID="ddlToDocShare" runat="server" class="ddlToDocShare chosen-select" Width="200px" ></asp:DropDownList>
                    </td>
                    </tr>
                <tr>
                    <td colspan="2" style="text-align:center">
                         <input type="button" id="btnTransferShare" value="Save" onclick="transferShare();" 
                        class="savebutton" />
                    </td>
                </tr>
                </table>
             </asp:Panel>
  

    <script type="text/javascript">
        jQuery(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }


        });
            </script>  
    <script id="tb_DeptShareDetail" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_DeptShareSearch"
    style="width:755px;border-collapse:collapse;text-align:center">
            <thead>
		<tr id="trDeptHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Auto Key</th>            
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">Auto Description</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;"></th>
</tr>
                 </thead>
       <#
             
              var objRow;
        for(var j=0;j<DeptData.length;j++)
        {
        objRow = DeptData[j];
            #>
                    <tr id="<#=j+1#>">
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td  class="GridViewLabItemStyle" ><input id="txtAutoKey"  type="text" value="<#=objRow.AutoKey#>" style="width:150px;" /></td>
<td class="GridViewLabItemStyle" id="tdID"  style="width:40px;display:none;text-align:left" ><#=objRow.ID#> </td>   
<td class="GridViewLabItemStyle"><input id="txtAutoDescription"  type="text" value="<#=objRow.AutoDescription#>" style="width:500px;" /></td>
<td><img src="../../App_Images/Delete.gif" style="border-style: none;cursor:pointer;" onclick="RemoveAutoCorrect(<#=objRow.ID#>)" /></td>
</tr>
            <#}#>
            <tr id="tradd">
<td class="GridViewLabItemStyle"></td>
<td  class="GridViewLabItemStyle" ><input id="txtaddkey"  type="text" style="width:150px;" /></td>
<td class="GridViewLabItemStyle" id="td1"  style="width:40px;display:none;text-align:left" ></td>   
<td class="GridViewLabItemStyle"><input id="txtaddKeyDescription"  type="text" style="width:500px;" /></td>
<td><img src="../../App_Images/ButtonAdd.png" style="border-style: none;cursor:pointer;" onclick="AddAutoCorrect()" /></td>

</tr>
     </table>
    </script>
    <script id="tb_ItemShareDetail" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_ItemShareSearch"
    style="width:890px;border-collapse:collapse;text-align:center">
            <thead>
		<tr id="trItemHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Test Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:390px;">Item</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Amount(Rs.)</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:180px;">Percentage %</th>
</tr>
                 </thead>
       <#
             
              var objRow;
        for(var j=0;j<ItemData.length;j++)
        {
        objRow = ItemData[j];
            #>
                    <tr >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="tdTestCode"  class="GridViewLabItemStyle"><#=objRow.TestCode#></td>
<td id="tdTypeName"  class="GridViewLabItemStyle" style="text-align:left"><#=objRow.TypeName#></td>
<td class="GridViewLabItemStyle" id="tdItemID"  style="width:40px;display:none;text-align:left" ><#=objRow.ItemID#>
<td class="GridViewLabItemStyle"><input id="txtItemShareAmt"  class="ItDoseTextinputNum clItemShareAmt" type="text" onkeypress="return checkForSecondDecimal(this,event)" value="<#=objRow.DocShareAmt#>" style="width:90px;" onkeyup="CheckDocShareAmt(this,'Item');" />Rs.</td>
<td class="GridViewLabItemStyle"><input id="txtItemSharePer"  class="ItDoseTextinputNum clItemSharePer" type="text" onkeypress="return checkForSecondDecimal(this,event)" value="<#=objRow.DocSharePer#>" style="width:90px;" onkeyup="CheckDocSharePer(this,'Item');" />%</td>

</tr>
            <#}#>
     </table>
    </script>
    <script type="text/javascript">
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function CheckDocSharePer(Per, filterType) {

            if (jQuery(Per).val().charAt(0) == "0") {
                jQuery(Per).val(Number(jQuery(Per).val()));
            }
            if (jQuery(Per).val().match(/[^0-9\.]/g)) {
                jQuery(Per).val() = jQuery(Per).val().replace(/[^0-9\.]/g, '');
                jQuery(Per).val(Number(jQuery(Per).val()));
                return;
            }
            if (jQuery(Per).val() > 100) {
                alert('Please Enter Valid Percentage');
                jQuery(Per).val(0);
                return;
            }
            if (filterType == "Item") {
                jQuery(Per).closest('tr').find('#txtItemShareAmt').val('');

            }
            if (jQuery(Per).val().indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = jQuery(Per).val().indexOf(".");
                if (valIndex > "0") {
                    if (jQuery(Per).val().length - (jQuery(Per).val().indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        jQuery(Per).val(jQuery(Per).val().substring(0, (jQuery(Per).val().length - 1)));
                        return false;
                    }
                }
            }
            if (jQuery(Per).val() == 0) {
                jQuery(Per).val(0);
                return;
            }
        }
        function CheckDocShareAmt(Per, filterType) {
            if (jQuery(Per).val().charAt(0) == "0") {
                jQuery(Per).val(Number(jQuery(Per).val()));
            }
            if (jQuery(Per).val().match(/[^0-9\.]/g)) {
                jQuery(Per).val() = jQuery(Per).val().replace(/[^0-9\.]/g, '');
                jQuery(Per).val(Number(jQuery(Per).val()));
                return;
            }
            if (filterType == "Item") {
                jQuery(Per).closest('tr').find('#txtItemSharePer').val('');

            }
            if (jQuery(Per).val().indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = jQuery(Per).val().indexOf(".");
                if (valIndex > "0") {
                    if (jQuery(Per).val().length - (jQuery(Per).val().indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        jQuery(Per).val(jQuery(Per).val().substring(0, (jQuery(Per).val().length - 1)));
                        return false;
                    }
                }
            }
            if (jQuery(Per).val() == 0) {
                jQuery(Per).val(0);
                return;
            }
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            bindDepartment();
            bindDoctorReferal('0');
        });
        function RemoveAutoCorrect(id) {
            serverCall('DocAutoCorrectMaster.aspx/RemoveAutoCorrect', { id: id }, function (response) {
                $responseData = JSON.parse(response);
                if ($responseData == "1") {
                    jQuery("#lblMsg").text('Record Remove Successfully');
                    bindDepartment();
                }
                else {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }
            });
        }
        function AddAutoCorrect() {
            var SubcategoryID = jQuery("#ddlDept").val();
            var AutoKey = jQuery("#txtaddkey").val();
            var AutoDescription = jQuery("#txtaddKeyDescription").val();
            if (AutoKey != '' && AutoDescription != '') {
                serverCall('DocAutoCorrectMaster.aspx/SaveAutoCorrect', { SubcategoryID: SubcategoryID, AutoKey: AutoKey, AutoDescription: AutoDescription }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData == "1") {
                        jQuery("#lblMsg").text('Record Saved Successfully');
                        jQuery("#txtaddkey").val('');
                        jQuery("#txtaddKeyDescription").val('');
                        bindDepartment();
                    }
                    else {
                        jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
            else {
                alert(" Auto Key And Auto Description Not Be Blank ");
            }
        }
        function bindDepartment() {

            if (jQuery("#rblSearchType input[type=radio]:checked").val() == "1")
                if (jQuery("#ddlDept").val())
                    PageMethods.getAutoKey(jQuery("#ddlDept").val(), onSucessDept, onFailureDept);
                else {
                    jQuery("#DeptShareOutput").html('');
                    jQuery("#DeptShareOutput").hide();
                }
               
            else {
                if (jQuery("#ddlDeptDoctor").val() != "0" && jQuery("#ddlDept").val())
                    PageMethods.getAutoKey(jQuery("#ddlDept").val(), onSucessDept, onFailureDept);
                else {
                    jQuery("#DeptShareOutput").html('');
                    jQuery("#DeptShareOutput").hide();
                }
            }

        }
        function onSucessDept(result) {
            DeptData = jQuery.parseJSON(result);
            if (DeptData != null) {
                jQuery('#ddlDepartment').append(jQuery("<option></option>").val("0").html('Select'));
                for (i = 0; i < DeptData.length; i++) {
                    jQuery('#ddlDepartment').append(jQuery("<option></option>").val(DeptData[i].SubCategoryID).html(DeptData[i].Name));
                }
                jQuery('#ddlDepartment').trigger('chosen:updated');
                jQuery("#DeptShareOutput").html(jQuery("#tb_DeptShareDetail").parseTemplate(DeptData));
                jQuery("#DeptShareOutput").show();
                jQuery("#tb_DeptShareSearch").tableHeadFixer({
                });
            }
            else {
                jQuery("#DeptShareOutput").html('');
                jQuery("#DeptShareOutput").hide();
            }
        }
        function onFailureDept(result) {

        }
        function bindDoctorReferal(con) {
            if (con == 0) {
                jQuery('#ddlItemDoctor option').remove();
                jQuery('#ddlDeptDoctor option').remove();
                jQuery('#ddlItemDoctor,#ddlDeptDoctor').trigger('chosen:updated');
            }
            else if (con == 1) {
                jQuery('#ddlFromDocShare option').remove();
                jQuery('#ddlToDocShare option').remove();
                jQuery('#ddlFromDocShare,#ddlToDocShare').trigger('chosen:updated');
            }
            PageMethods.getDoctorReferal(onSucessDoctorReferal, onFailureDoctorReferal, con);
        }
        function onSucessDoctorReferal(result, con) {
            docReferal = jQuery.parseJSON(result);
            if (docReferal != null) {
                if (con == 0) {
                    jQuery('#ddlItemDoctor,#ddlDeptDoctor').append(jQuery("<option></option>").val("0").html('Select'));
                    for (i = 0; i < docReferal.length; i++) {
                        jQuery('#ddlItemDoctor').append(jQuery("<option></option>").val(docReferal[i].Doctor_ID).html(docReferal[i].Name));
                        jQuery('#ddlDeptDoctor').append(jQuery("<option></option>").val(docReferal[i].Doctor_ID).html(docReferal[i].Name));
                    }
                    jQuery('#ddlItemDoctor,#ddlDeptDoctor').trigger('chosen:updated');
                }
                else {
                    jQuery('#ddlFromDocShare,#ddlToDocShare').append(jQuery("<option></option>").val("0").html('Select'));
                    for (i = 0; i < docReferal.length; i++) {
                        jQuery('#ddlFromDocShare').append(jQuery("<option></option>").val(docReferal[i].Doctor_ID).html(docReferal[i].Name));
                        jQuery('#ddlToDocShare').append(jQuery("<option></option>").val(docReferal[i].Doctor_ID).html(docReferal[i].Name));
                    }
                    jQuery('#ddlFromDocShare,#ddlToDocShare').trigger('chosen:updated');
                }

            }
        }
        function onFailureDoctorReferal(result) {

        }
          </script>
    <script type="text/javascript">
        function bindItem() {            
            if (jQuery("#rblSearchType input[type=radio]:checked").val() == "1") {
                if (jQuery("#ddlDepartment").val() != "0") {
                    $modelBlockUI();
                    PageMethods.getItem(jQuery("#rblSearchType input[type=radio]:checked").val(), jQuery("#ddlDepartment").val(), 0, jQuery("#ddlcategory").val(), jQuery("#ddlPanelItem").val(),jQuery("#ddlItemDocCategory").val() ,onSucessItem, onFailureDept);
                }
                else {
                    jQuery("#ItemShareOutput").html('');
                    jQuery("#ItemShareOutput,#btnItem").hide();
                }
            }
            else {
                if (jQuery("#ddlDepartment").val() != "0" && jQuery("#ddlItemDoctor").val() != 0) {
                    $modelBlockUI();
                    PageMethods.getItem(jQuery("#rblSearchType input[type=radio]:checked").val(), jQuery("#ddlDepartment").val(), jQuery("#ddlItemDoctor").val(), jQuery("#ddlcategory").val(), jQuery("#ddlPanelItem").val(),'', onSucessItem, onFailureDept);

                }
                else {
                    jQuery("#ItemShareOutput").html('');
                    jQuery("#ItemShareOutput,#btnItem").hide();
                }
            }
        }
        function onSucessItem(result) {
            ItemData = jQuery.parseJSON(result);
            if (ItemData != null) {
                jQuery("#ItemShareOutput").html(jQuery("#tb_ItemShareDetail").parseTemplate(ItemData));
                jQuery("#ItemShareOutput,#btnItem").show();
                jQuery("#tb_ItemShareSearch").tableHeadFixer({
                });
            }
            else {
                jQuery("#ItemShareOutput").html('');
                jQuery("#ItemShareOutput,#btnItem").hide();
            }
            $modelUnBlockUI();
        }
        function onFailureDept(result) {
            $modelUnBlockUI();
        }
    </script>
    <script type="text/javascript">
        function DepartmentSave() {
            jQuery("#lblMsg").text('');
            jQuery("#btnDepartment").attr('disabled', true).val("Submitting...");
           
            var data = new Array();
            jQuery("#tb_DeptShareSearch tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "trDeptHeader") {
                    if (jQuery(this).find('#txtDeptSharePer').val() > 0) {
                        var obj = new Object();
                        obj.Subcategory_ID = jQuery.trim(jQuery(this).find('#tdSubCategoryID').text());
                        obj.DocSharePer = jQuery.trim(jQuery(this).find('#txtDeptSharePer').val());
                        obj.SearchType = jQuery("#rblSearchType input[type=radio]:checked").val();
                        if (jQuery("#rblSearchType input[type=radio]:checked").val() == "1") {
                            obj.Doctor_ID = 0;
                        }
                        else {
                            obj.Doctor_ID = jQuery("#ddlDeptDoctor").val();
                        }
                        obj.PanelID = jQuery("#ddlDept").val();
                        obj.DocCategory = jQuery("#ddlDocCategory").val();
                        data.push(obj);
                    }
                }
            });
            if (data.length > 0) {

                serverCall('DocShareMaster.aspx/SaveDocDepartmentShare', { Data: data  }, function (response) {
                    $responseData = JSON.parse(response);


                
                    if ($responseData == "1") {
                            toast("Success", "Record Saved Successfully", "");
                            
                        }
                        else {
                            toast("Error", "Error occurred, Please contact administrator", "");
                         
                        }
                        jQuery('#btnDepartment').attr('disabled', false).val("Save");
                       
                    
                });
            }
            else {
                jQuery("#btnDepartment").attr('disabled', false).val("Save");
                if (jQuery("#rblSearchType input[type=radio]:checked").val() == "2") {
                    jQuery("#lblMsg").text('Please Select Doctor');
                    jQuery("#ddlDeptDoctor").focus();
                }
                
                return;
            }
        }
        function ItemSave() {
            jQuery("#lblMsg").text('');
            jQuery("#btnItem").attr('disabled', true).val("Submitting...");

            var data = new Array();
            jQuery("#tb_ItemShareSearch tr").each(function () {
                var id = jQuery(this).closest("tr").attr("id");
                if (id != "trItemHeader") {
                    if (jQuery.trim(jQuery(this).find('#txtItemShareAmt').val()) > 0 || jQuery.trim(jQuery(this).find('#txtItemSharePer').val()) > 0) {
                        var obj = new Object();
                        obj.ItemID = jQuery.trim(jQuery(this).find('#tdItemID').text());
                        if (jQuery.trim(jQuery(this).find('#txtItemSharePer').val()) > 0 && jQuery.trim(jQuery(this).find('#txtItemShareAmt').val()) > 0) {
                            obj.DocSharePer = jQuery.trim(jQuery(this).find('#txtItemSharePer').val());
                            obj.DocShareAmt = 0;
                        }
                        else if (jQuery.trim(jQuery(this).find('#txtItemSharePer').val()) > 0) {
                            obj.DocSharePer = jQuery.trim(jQuery(this).find('#txtItemSharePer').val());
                            obj.DocShareAmt = 0;

                        }
                        else if (jQuery.trim(jQuery(this).find('#txtItemShareAmt').val()) > 0) {
                            obj.DocShareAmt = jQuery.trim(jQuery(this).find('#txtItemShareAmt').val());
                            obj.DocSharePer = 0;
                        }
                        obj.SearchType = jQuery("#rblSearchType input[type=radio]:checked").val();
                        if (jQuery("#rblSearchType input[type=radio]:checked").val() == "1") {
                            obj.Doctor_ID = 0;
                        }
                        else {
                            obj.Doctor_ID = jQuery("#ddlItemDoctor").val();
                        }
                        obj.PanelID = jQuery("#ddlPanelItem").val();
                        obj.Subcategory_ID = jQuery('#ddlDepartment').val();
                        obj.DocCategory = jQuery("#ddlItemDocCategory").val();
                        data.push(obj);
                    }
                }
            });
            if (data.length > 0) {

                serverCall('DocShareMaster.aspx/SaveDocItemShare', { Data: data }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData == "1") {
                        jQuery("#lblMsg").text('Record Saved Successfully');
                    }
                    else {
                        jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                    jQuery('#btnItem').attr('disabled', false).val("Save");
                });
            }
            else {
                jQuery("#btnItem").attr('disabled', false).val("Save");
                jQuery("#lblMsg").text('Please Select Item');
                return;
            }
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            bindDocType('0');
            jQuery(".chosen-container").each(function (i, elem) {
                if (jQuery(elem).width() == 0) {
                    jQuery(elem).width("200px");
                }
            });
        });
        function bindDocType(type) {
            var tabIndex = $find("TabContainer1"); //AdvOrBasicSearch is name of tabContainer
            var Index = tabIndex._activeTabIndex;
            getDoc(tabIndex._activeTabIndex, type);
        }

        function getDoc(activeTabIndex, type) {
            jQuery("#lblMsg").text('');
            if (activeTabIndex == 1) {
                if (jQuery("#rblSearchType input[type=radio]:checked").val() == "1") {
                    jQuery(".trItemDoc").hide();
                    jQuery(".trItemDocCategory").show();
                    
                }
                else {
                    jQuery(".trItemDoc").show();
                    jQuery(".trItemDocCategory").hide();
                }
                jQuery("#ddlItemDoctor,#ddlDepartment,#ddlcategory,#ddlPanelItem").prop('selectedIndex', 0);
                jQuery('#ddlItemDoctor,#ddlDepartment,#ddlcategory,#ddlPanelItem').trigger('chosen:updated');
                bindItem();
            }
            else {
                if (jQuery("#rblSearchType input[type=radio]:checked").val() == "1") {
                    jQuery("#trDeptDoc").hide();
                    jQuery("#trDocCategory").hide();
                    
                }
                else {
                    jQuery("#trDeptDoc").show();
                    jQuery("#trDocCategory").hide();
                }
                jQuery("#ddlDept").prop('selectedIndex', 0);
                jQuery('#ddlDept').trigger('chosen:updated');
                jQuery("#ddlDeptDoctor").prop('selectedIndex', 0);
                jQuery('#ddlDeptDoctor').trigger('chosen:updated');
               
                bindDepartment();
            }
            jQuery('#txtItemAmt,#txtItemPer').val('');
        }

    </script>
    <script type="text/javascript">
        function clientActiveTabChanged(sender, args) {
            var selectedTab = sender.get_tabs()[sender.get_activeTabIndex()]._tab;
            var tabText = selectedTab.childNodes[0].childNodes[0].childNodes[0].innerHTML;
            getDoc(sender.get_activeTabIndex(), 1);
        }
    </script>
    <script type="text/javascript">
        function showPopUp() {
            $find("<%=modelTranferShare.ClientID%>").show();
            bindDoctorReferal('1');
        }
        function closePopUp(con) {
            if(con==0)
                $find("<%=modelTranferShare.ClientID%>").hide();
           
        }
        function transferShare() {
            jQuery('#lblPopUpMsg').text('');
            if (jQuery('#ddlFromDocShare').val() == "0") {
                jQuery('#lblPopUpMsg').text('Please Select From Doctor');
                jQuery('#ddlFromDocShare').focus();
                return;
            }
            if (jQuery('#ddlToDocShare').val() == "0") {
                jQuery('#lblPopUpMsg').text('Please Select To Doctor');
                jQuery('#ddlToDocShare').focus();
                return;
            }
            if (jQuery('#ddlFromDocShare').val() == jQuery('#ddlToDocShare').val()) {
                jQuery('#lblPopUpMsg').text('From Doctor and To Doctor can not be same');
                jQuery('#ddlToDocShare').focus();
                return;
            }
            PageMethods.transferDocShare(jQuery('#ddlFromDocShare').val(), jQuery('#ddlToDocShare').val(), onSucessDocShareTransfer, onFailureDocShareTransfer);
        }
        function onSucessDocShareTransfer(result) {
            if (result == 1) {
                jQuery("#lblMsg").text('Doctor Share Saved Successfully ');
                $find("<%=modelTranferShare.ClientID%>").hide();
            }
            else if (result == 2) {
                jQuery('#lblPopUpMsg').text('From Doctor and To Doctor can not be same');
            }
            else if (result == 3) {
                jQuery('#lblPopUpMsg').text('From Doctor Share not found ');
            }
        }
        function onFailureDocShareTransfer(result) {

        }
    
    
        function showPopUpStatus() {
            fancyBoxOpen('DocShareStatus.aspx');

        }
       
        function fancyBoxOpen(href) {
            jQuery.fancybox({
                maxWidth: 796,
                maxHeight: 300,
                fitToView: false,
                width: '90%',
                height: '85%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
        );

        }
    </script>

    <script type="text/javascript">
        function fillItemAmt(amt) {
            jQuery(".clItemShareAmt").val(jQuery(amt).val());
            jQuery(".clItemSharePer").val('0');
        }
        function fillItemPer(per) {
            if (jQuery(per).val() > 100) {
                alert('Please Enter Valid Percentage');
                jQuery(per).val(0);
                jQuery(".clItemSharePer").val('0');
                return;
            }
            jQuery(".clItemShareAmt").val('0');
            jQuery(".clItemSharePer").val(jQuery(per).val());
        }
    </script>
    <style type="text/css">
        .ajax__tab_xp .ajax__tab_header .ajax__tab_tab 
{
    height: 20px !important;
}
    </style>
</asp:Content>
