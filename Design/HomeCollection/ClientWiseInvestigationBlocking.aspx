<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ClientWiseInvestigationBlocking.aspx.cs" Inherits="Design_EDP_ClientWiseInvestigationBlocking" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <div class="alert fade" style="position: absolute; left: 40%;top:15%; border-radius: 15px; z-index: 11111">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 1304px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
           
                <table width="99%">
                    <tr>
                        <td align="center">
                            <asp:Label ID="llheader" runat="server" Text="Client Wise Item Mapping" Font-Size="16px" Font-Bold="true"></asp:Label></td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label></td>
                    </tr>
                </table>

           
        </div>
        <div class="Outer_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
               Select Option&nbsp;
            </div>

            <table style="width: 750px; margin: 0 auto;">
                <tr>
                    <td style="width:200px;">Client Name :</td>
                    <td style="width:300px;">
                        <asp:DropDownList ID="ddlClientName" CssClass="chosen-select" ClientIDMode="Static" runat="server" Width="400px"></asp:DropDownList>
                    </td>
                    <td style="width:100px; text-align:left;">
                       
                    </td>

                </tr>
                <tr>
                    <td style="width:200px;">Select Test :</td>
                    <td style="width:300px;">
                        <asp:DropDownList ID="ddlinvestigation" CssClass="chosen-select" ClientIDMode="Static" runat="server" Width="400px"></asp:DropDownList>
                    </td>
                    <td style="width:100px; text-align:left;">
                        &nbsp;</td>

                </tr>

               

                <tr style="display:none;">
                    <td style="width:200px;">Rate Selection :</td>
                    <td style="" colspan="2">
                        <asp:DropDownList ID="ddlRateSelection" CssClass="chosen-select" ClientIDMode="Static" runat="server" Width="400px">
                             <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                             <asp:ListItem  Text="Normal Rate"  Selected="True"  Value="NormalRate"></asp:ListItem>
                             <asp:ListItem  Text="Schedule Rate" Value="ScheduleRate"></asp:ListItem>
                             <asp:ListItem  Text="Normal and Schedule Rate" Value="NormalAndScheduleRate"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    

                </tr>

                <tr>
                    <td style="width:200px;"></td>
                    <td style="" colspan="2">
                          <asp:TextBox ID="txtPriority" runat="server" Width="92px" AutoCompleteType="Disabled" MaxLength="4"  TabIndex="3" style="display:none;"></asp:TextBox>
                            &nbsp;&nbsp;
                        <%--<span style="color:red; font-style: italic;">* if Not Entered Default Display Order Will Set</span>--%>
                        <input type="button" id="btnRemoveDiscount" value="Add" class="searchbutton" onclick="Save();" style="width: 65px;" />
                            <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtPriority">
                            </cc1:FilteredTextBoxExtender>
                    </td>                   
                </tr>

            </table>

        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader" style="width: 1295px;">
                Test List  

              <%-- &nbsp; <span style="color:red; font-style: italic;">* You Can Swap List then Press Save Display Order Button to change Display Order</span>

                <input type="button" value="Display Order" class="savebutton" onclick="saveme()" />--%>
            </div>
            <div class="content" style="overflow: auto; height: 500px; width:98%;">
                   <div id="divsmsOutput">
                
            </div>
      
            </div>


              <asp:Button ID="btnDefault" runat="server" Style="display:none" OnClientClick="JavaScript: return false;"/>
    <cc1:ModalPopupExtender ID="mpClientRate" runat="server"
                            DropShadow="true" TargetControlID="btnDefault"   CancelControlID="imgCloseClientRate" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlClientRate"    BehaviorID="mpClientRate">
                        </cc1:ModalPopupExtender>  
    <asp:Panel ID="pnlClientRate" runat="server" Style="display: none;width:930px; height:484px; " CssClass="pnlVendorItemsFilter"> 
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>     
                         <td style="text-align:center">
                             <span style="font-weight:bold;color:red;">Total Record:&nbsp;</span><span id="testRatecount"  style="font-weight:bold;color:red;"></span>
                         </td>                       
                    <td  style="text-align:right">      
                        <img id="imgCloseClientRate" runat="server" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="closeClientRate()" />  
                    </td>                    
                </tr>
            </table>   
      </div>
              <table style="width: 100%;border-collapse:collapse">   
                  <tr>
                      <td style="width:12%;text-align:right">
                          Test Code :&nbsp;
                      </td>
                       <td style="text-align:left;width:88%;">
                           <table style="width:100%">
                               <tr>
                                   <td style="text-align:left;width:20%;">
                                        <b> <asp:Label id="lblTestCode" runat="server" ClientIDMode="Static" ></asp:Label></b>
                                   </td>
                                   <td style="text-align:right;width:20%;">
                                        Centre Type :&nbsp;
                                   </td>
                                   <td style="text-align:left;width:60%;">
                                        <asp:DropDownList ID="ddlCentreType" runat="server" onchange="show('')" ClientIDMode="Static" Width="180px"></asp:DropDownList>
                                         </td>
                               </tr>
                           </table>
                       
                      </td>
                  </tr> 
                  <tr>
                      <td style="width:12%;text-align:right">
                          Test Name :&nbsp;
                      </td>
                        <td style="text-align:left;width:88%;">
                          <b><asp:Label id="lblTestName" runat="server" ClientIDMode="Static" ></asp:Label></b>
                            <asp:Label id="lblItemID" runat="server" ClientIDMode="Static"   style="display:none" ></asp:Label>
                      </td>
                  </tr>  
                            
                  <tr>
                      <td colspan="2">
           <div class="POuter_Box_Inventory" style="width: 920px; text-align: center">
            <div id="DefaultOutput" style="max-height: 374px; overflow-y: auto; overflow-x: hidden;">
                <table id="tblClientRate" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                    <thead>
                        <tr id="headerClientRate">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align: left">Client Code</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 360px; text-align: left">Client Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: right">Rate</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: right">ScheduleRate</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 120px; text-align: center">From Date</th>
                             <th class="GridViewHeaderStyle" scope="col" style="width: 120px; text-align: center">To Date</th>
                        </tr>
                    </thead>
                </table>
                
            </div><div id="PagerDiv1" style="display:none;background-color:white;width:99%;padding-left:7px;">

              </div>
            </div>                
                      </td>
                  </tr> 
                  <tr>
                      <td style="text-align:center" colspan="2">
                          <input type="button" id="btnClientRate" value="Cancel" onclick="closeClientRate()" />
                         
                      </td>
                  </tr>                  
                </table>       
    </asp:Panel>



        </div>


        <script id="tb_sms" type="text/html">  
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tbl_sms" width="100%" >
		<tr id="Header">
			<th class="GridViewHeaderStyle" style="width:40px;text-align:left;" >S.No.</th>
            <th class="GridViewHeaderStyle" style="width:60px; text-align:left;" >TestCode</th>
            <th class="GridViewHeaderStyle" style="width:200px;text-align:left;">Test Name</th>   
            <th class="GridViewHeaderStyle" style="width:120px;text-align:left;display:none;">Display Order</th>
            <th class="GridViewHeaderStyle" style="width:166px;text-align:left;display:none;">Rate Selection</th>                 
            <th class="GridViewHeaderStyle" style="width:80px;text-align:left;">CreatedOn</th> 
            <th class="GridViewHeaderStyle" style="width:100px;text-align:left;">CreatedBy</th>
            <th class="GridViewHeaderStyle" style="width:80px;text-align:left;">UpdatedOn</th>
            <th class="GridViewHeaderStyle" style="width:100px;text-align:left;">UpdatedBy</th>          
			<th class="GridViewHeaderStyle" style="width:40px;text-align:left;">Status</th> 
            <th class="GridViewHeaderStyle" style="width:50px;text-align:left;">Change</th> 
            <th class="GridViewHeaderStyle" style="width:30px;text-align:center;display:none;">View</th>
         </tr>

       <#
              var dataLength=SmsData.length; 
              var objRow;  
        for(var j=0;j<dataLength;j++)
        { 
            var array=[];
        objRow = SmsData[j];  
            #>
<tr id="<#=objRow.ID#>" <# if(objRow.IsActive=="0")
    {
    #>
     style="background:#ea9191"
    <#}#>
     >
    <td class="GridViewLabItemStyle"><#=j+1#>
       <%--<input type="checkbox" id="ch" onclick="checkme(this)" />--%>
    </td>
<td class="GridViewLabItemStyle" style="text-align:left;" id="tdTestCode"><#=objRow.TestCode#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;" id="tdTestName"><#=objRow.typename#></td>
     <td class="GridViewLabItemStyle" style="text-align:left;display:none;">
         <input type="text" id="txtpri" style="width:60px;" value="<#=objRow.TestPriority#>"  disabled="disabled"  onkeyup="showme2(this)"/>
         <input type="button" value="Save" style="cursor:pointer;display:none;" id="btnss" onclick="savepri(this)"  />
     </td>
    <td class="GridViewLabItemStyle" style="text-align:left;display:none;">
        <select id="ddltblRateSelection"  disabled="disabled" style="Width:126px" class="cltblRateSelection_<#=j+1#>">
            <option  value="0">Select</option>
            <option  value="NormalRate">Normal Rate</option>
            <option  value="ScheduleRate">Schedule Rate</option>
            <option  value="NormalAndScheduleRate">Normal and Schedule Rate</option>
        </select>        
         <input type="button" value="Save" style="cursor:pointer;display:none;" id="btnRateSelection" onclick="saveRateSelection(this)"  />
     </td>
    <td class="GridViewLabItemStyle" id="tdRateSelectionID" style="text-align:left;display:none"><#=objRow.RateSelectionID#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.dtEntry#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.CreatedBy#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.UpdateDate#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.UpdatedBy#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.STATUS#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><a href="#" onclick="ChangeStatus(<#=objRow.ChangeStatus#>,<#=objRow.ID#>,<#=objRow.ItemID#>,'<#=objRow.ClientName#>','<#=objRow.RateSelection#>')"> <#=objRow.Actions#></a></td>
    <td class="GridViewLabItemStyle" style="display:none;" id="ClientName"><#=objRow.ClientName#></td>
    <td class="GridViewLabItemStyle" style="display:none;" id="ItemID"><#=objRow.ItemID#></td>
    <td class="GridViewLabItemStyle" style="display:none;" id="tdID"><#=objRow.ID#></td>
    <td class="GridViewLabItemStyle"  id="tdView" style="display:none;"><img src="../../App_Images/view.GIF" alt="" style="cursor:pointer" onclick="viewRate(this,'')" /> </td>
</tr> 
  <#}#>

</table> 
             
           
    </script> 
        <script type="text/javascript">
            var SmsData = "";
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
                Bind();
                $('#<%=ddlClientName.ClientID%>').change(function () {
                    Bind();
                });               
            });
            function showme2(ctrl) {
                if ($(ctrl).val().indexOf(" ") != -1) {
                    $(ctrl).val($(ctrl).val().replace(' ', ''));
                }
                var nbr = $(ctrl).val();
                var decimalsQty = nbr.replace(/[^.]/g, "").length;
                if (parseInt(decimalsQty) > 1) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
                // alert($(ctrl).closest("tr").find("#txttddisc").text());
                if ($(ctrl).val().length > 1) {
                    if (isNaN($(ctrl).val() / 1) == true) {
                        $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                    }
                }
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val('');
                    return;
                }
                else if ($(ctrl).val() < 0) {
                    $(ctrl).val('');

                    return;
                }

               
            }

            function checkme(ctrl) {
                if ($(ctrl).is(':checked')) {
                    $('#tbl_sms tr').each(function () {
                        if ($(this).attr("id") != "Header" && $(this).find("#ch").is(':checked')) {
                            $(this).closest('tr').find('#txtpri').prop('disabled', true);
                            $(this).find("#ch").prop('checked', false);
                            $(this).find("#btnss").hide();
                           
                            $(this).closest('tr').find('#ddltblRateSelection').prop('disabled', true);                           
                            $(this).find("#btnRateSelection").hide();
                            
                        }
                    });
                    $(ctrl).prop('checked', true);
                    $(ctrl).closest('tr').find('#txtpri').prop('disabled', false);
                    $(ctrl).closest('tr').find("#btnss").show();

                    $(ctrl).closest('tr').find('#ddltblRateSelection').prop('disabled', false);
                    $(ctrl).closest('tr').find("#btnRateSelection").show();
                }
                else {
                    $(ctrl).closest('tr').find('#txtpri').prop('disabled', true);
                    $(ctrl).closest('tr').find("#btnss").hide();
                    $(ctrl).closest('tr').find('#ddltblRateSelection').prop('disabled', true);
                    $(ctrl).closest('tr').find("#btnRateSelection").hide();
                }
            }
            function Bind() {
                var ClientName = $('#<%=ddlClientName.ClientID%> option:selected').text();
                if (ClientName == '') {
                    showerrormsg('Please Select Client Name....!');
                    return;
                }
                jQuery.ajax({
                    url: "ClientWiseInvestigationBlocking.aspx/BindList",
                    data: '{ ClientName: "' + ClientName + '" }',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        SmsData = $.parseJSON(result.d);
                        if (SmsData.length == 0) {                           
                            jQuery('#divsmsOutput').empty();
                            showerrormsg('Record Not Found...!');
                            return;
                        }
                        var output = jQuery('#tb_sms').parseTemplate(SmsData);
                        jQuery('#divsmsOutput').html(output);
                        jQuery("#tbl_sms tr").each(function () {
                            if (jQuery(this).attr('id') != "Header") {
                                var RateSelection = $(this).closest('tr').find("#tdRateSelectionID").text();
                                $(this).closest('tr').find("#ddltblRateSelection").val(RateSelection);
                            }
                        });
                        //jQuery("#tbl_sms").tableDnD({
                        //    onDragClass: "GridViewDragItemStyle"
                        //});
                    },
                    error: function (data) {

                    }
                });
            }

            function ChangeStatus(Status, ID, ItemID, ClientName, RateSelection) {
                jQuery.ajax({
                    url: "ClientWiseInvestigationBlocking.aspx/Update",
                    data: '{ status: "' + Status + '",ID: "' + ID + '",ItemID:"' + ItemID + '",ClientName:"' + ClientName + '",RateSelection:"' + RateSelection + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg('status changed successfully ..!');
                            Bind();
                        }
                        if (result.d == "2") {
                            showerrormsg('This item already Active ..!');
                        }
                    },
                    error: function (xhr, status) {
                        showerrormsg("Some Error Occur Please Try Again..!");
                    }
                });
            }

            function Save() {

                var ItemID = $('#<%=ddlinvestigation.ClientID%>').val();
                if (ItemID == "0") 
                {
                    showerrormsg("Please Select Investigation");
                    $('#<%=ddlinvestigation.ClientID%>').focus();
                    return;
                }
                if ($('#<%=ddlRateSelection.ClientID%>').val() == 0) {
                    showerrormsg("Please Select Rate Selection");
                    $('#<%=ddlRateSelection.ClientID%>').focus();
                    return;
                }
                var priority = $('#<%=txtPriority.ClientID%>').val();
                if (priority == "" || priority == "0") {
                    priority = "9999";
                }

                jQuery.ajax({
                    url: "ClientWiseInvestigationBlocking.aspx/Save",
                    data: '{ ItemID: "' + ItemID + '",ClientName: "' + $('#<%=ddlClientName.ClientID%> option:selected').text() + '",priority:"' + priority + '",RateSelection:"' + $('#<%=ddlRateSelection.ClientID%>').val() + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg('Record Saved successfully ..!');
                            Bind();
                        }
                        if (result.d == "2") {
                            showerrormsg("This item already exists..!");
                        }
                    },
                    error: function (xhr, status) {
                        showerrormsg("Some Error Occur Please Try Again..!");
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

            function BindDetals(ID, ItemID, ClientName) {

                jQuery.ajax({
                    url: "ClientWiseInvestigationBlocking.aspx/BindDetals",
                    data: '{ ItemID:"' + ItemID + '",ClientName:"' + ClientName + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        Data = $.parseJSON(result.d);
                        for (var i = 0; i <= Data.length - 1; i++) {
                            var mydata = "<tr  class=" + ID + "  style='text-align:left;background: #fff;'>";
                            mydata += '<td class="GridViewLabItemStyle">&nbsp;</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + Data[i].TestCode + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + Data[i].typename + ' </td>'; 
                            mydata += '<td class="GridViewLabItemStyle">' + Data[i].dtEntry + ' </td>';
                            mydata += '<td class="GridViewLabItemStyle">' + Data[i].CreatedBy + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + Data[i].UpdateDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + Data[i].UpdatedBy + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + Data[i].STATUS + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">&nbsp;</td>';

                            mydata += '</tr>';

                            $(mydata).insertAfter($('#' + ID));
                            $('#' + ID).find('#Open').hide();
                            $('#' + ID).find('#Close').show();
                        }

                    },
                    error: function (data) {

                    }
                });
            }

            function RemoveDetals(ID, ItemID) {
                $('#tbl_sms').find('.' + ID).remove();
                $('#' + ID).find('#Open').show();
                $('#' + ID).find('#Close').hide();
            }
            function saveme() {
                var dataPLO = new Array();
                jQuery("#tbl_sms tr").each(function () {
                    if (jQuery(this).attr('id') != "Header") {
                        var objPLO = new Object();
                        objPLO.ClientName = jQuery(this).find('#ClientName').html();
                        objPLO.ItemID = jQuery(this).find('#ItemID').html();
                        dataPLO.push(objPLO);
                    }                       
                });
                jQuery.ajax({
                    url: "ClientWiseInvestigationBlocking.aspx/SavePriority",
                    data: JSON.stringify({ dataPLO:dataPLO}),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg('Priority Saved successfully ..!');
                            Bind();
                        }
                        else {
                            showerrormsg(result.d);
                        }
                    },
                    error: function (xhr, status) {
                        showerrormsg("Some Error Occur Please Try Again..!");
                    }
                });
            }
        </script>

        <script type="text/javascript">          
            function savepri(ctrl) {
                var pri = $(ctrl).closest('tr').find('#txtpri').val();
                var itemid = $(ctrl).closest('tr').find('#ItemID').html();
                var clientname = $(ctrl).closest('tr').find('#ClientName').html();              
                if (pri == "" || pri == "0") {
                    $(ctrl).closest('tr').find('#txtpri').focus();
                    showerrormsg("Please Enter Proper Priority");
                    return;
                }
                jQuery.ajax({
                    url: "ClientWiseInvestigationBlocking.aspx/SavePrioritySingle",
                    data: JSON.stringify({ pri: pri, itemid: itemid, clientname: clientname }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg('Priority Saved successfully ..!');
                            Bind();
                        }
                        else {
                            showerrormsg(result.d);
                        }
                    },
                    error: function (xhr, status) {
                        showerrormsg("Some Error Occur Please Try Again..!");
                    }
                });
            }
        </script>
        <script type="text/javascript">
            function saveRateSelection(rowID) {
                var tblRateSelection = $(rowID).closest('tr').find('#ddltblRateSelection').val();            
                if (tblRateSelection ==0) {
                    $(rowID).closest('tr').find('#ddltblRateSelection').focus();
                    showerrormsg("Please Select RateSelection");
                    return;
                }
                var OldRateSelectionID=  $(rowID).closest('tr').find('#tdRateSelectionID').text();
                if (OldRateSelectionID == tblRateSelection) {
                    $(rowID).closest('tr').find('#ddltblRateSelection').focus();
                    showerrormsg("Please Select Different RateSelection");
                    return;
                }
                $(rowID).closest('tr').find('#btnRateSelection').attr('disabled', 'disabled')
                jQuery.ajax({
                    url: "ClientWiseInvestigationBlocking.aspx/SaveRateSelection",
                    data: JSON.stringify({ ID: $(rowID).closest('tr').find('#tdID').text(), RateSelection: tblRateSelection }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg('RateSelection Saved successfully ..!');
                            Bind();
                        }
                        else {
                            showerrormsg(result.d);
                        }
                        $(rowID).closest('tr').find('#btnRateSelection').removeAttr('disabled');
                    },
                    error: function (xhr, status) {
                        showerrormsg("Some Error Occur Please Try Again..!");
                    }
                });
            }
        </script>
    </div>
    <style>
        #tbl_sms th, #tbl_sms td {
            padding-top: 8px;
            padding-bottom: 8px;
        }
    </style>  

    <script type="text/javascript">
        var _PageNo = 0;
        var _PageSize = 50;
        var testcount = 0;

        function viewRate(rowID, pageno) {
           jQuery("#ddlCentreType").val('6');
            if (pageno == "")
                _PageNo = 0;
            else
                _PageNo = pageno;
            
            jQuery("#tblClientRate tr:not(#headerClientRate)").remove();
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            jQuery('#lblItemID').text($(rowID).closest('tr').find("#ItemID").text());
            jQuery('#lblTestCode').text($(rowID).closest('tr').find("#tdTestCode").text());
           jQuery('#lblTestName').text($(rowID).closest('tr').find("#tdTestName").text());

            PageMethods.bindClientRate(_PageNo, _PageSize, $(rowID).closest('tr').find("#ItemID").text(),jQuery("#ddlCentreType option:selected").text(), onSucessClientRate, onFailureClientRate, pageno);
        }
        function onSucessClientRate(result, pageno) {


            var ClientRateData = jQuery.parseJSON(result);
if (ClientRateData == null || ClientRateData=="") {
jQuery('#lblMsg').text('No Record Found');
$find('mpClientRate').show();$('#testRatecount').html(0);$('#PagerDiv1,#tblClientRate').hide();
jQuery.unblockUI();
return;
}
jQuery('#lblMsg').text('');
            
            if (ClientRateData != null) {
                if (jQuery('#tblClientRate tr').length > 0)
                    jQuery('#tblClientRate').css('display', 'block');              
            
            if (pageno == "") {
                _PageNo = ClientRateData[0].totalRow / _PageSize;
                testcount = parseInt(ClientRateData[0].totalRow);
                $('#testRatecount').html(testcount);
            }
            
            for (var i = 0; i < ClientRateData.length; i++) {
                if (i == 0) {
                    jQuery('#lblTestCode').text(ClientRateData[0].ItemCode);
                    jQuery('#lblTestName').text(ClientRateData[0].ItemName);
                    jQuery('#lblItemID').text(ClientRateData[0].ItemID);
                   
                }
                var $append = [];
                $append.push("<tr >");
           
                if (pageno == "") {
                    $append.push('<td class="GridViewLabItemStyle" >'); $append.push(parseInt(i + 1));
                }
                else {
                    $append.push('<td class="GridViewLabItemStyle" >'); $append.push(parseInt(i + pageno * _PageSize + 1));
                }


                $append.push('</td>');
                $append.push('<td class="GridViewLabItemStyle"  style="text-align:left">'); $append.push(ClientRateData[i].ClientCode); $append.push('</td>');
                $append.push('<td class="GridViewLabItemStyle"  style="text-align:left">'); $append.push(ClientRateData[i].ClientName); $append.push('</td>');
                $append.push('<td class="GridViewLabItemStyle"  style="text-align:right;">'); $append.push(ClientRateData[i].Rate); $append.push('</td>');
                $append.push('<td class="GridViewLabItemStyle"  style="text-align:right;">'); $append.push(ClientRateData[i].ScheduleRate); $append.push('</td>');
                $append.push('<td class="GridViewLabItemStyle"  style="text-align:left">'); $append.push(ClientRateData[i].FromDate); $append.push('</td>');
                $append.push('<td class="GridViewLabItemStyle"  style="text-align:left">'); $append.push(ClientRateData[i].ToDate); $append.push('</td>');
                $append.push("</tr>");
                $append = $append.join("");
                jQuery('#tblClientRate').append($append);


            }
            if (pageno == "") {
                var $append = [];
                jQuery('#PagerDiv1').html('');
                if (_PageNo > 1 && _PageNo < 50) {

                    for (var j = 0; j < _PageNo; j++) {
                        var me = parseInt(j) + 1;

                        $append.push('<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="show(\'');
                        $append.push(j); $append.push('\');" >'); $append.push(me); $append.push('</a>');
                    }
                }
                else if (_PageNo > 50) {

                    for (var j = 0; j < 50; j++) {
                        var me = parseInt(j) + 1;

                        $append.push('<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="show(\'');
                        $append.push(j); $append.push('\');" >'); $append.push(me); $append.push('</a>');
                    }
                    $append.push('&nbsp;&nbsp;<select onchange="shownextrecord()" id="myddl">');
                    $append.push('<option value="Select">Select Page</option>');
                    for (var j = 50; j < _PageNo; j++) {
                        var me = parseInt(j) + 1;

                        $append.push('<option value=" ');
                        $append.push(j); $append.push('">');
                        $append.push(me); $append.push('</option>');

                    }
                    $append.push("</select>");
                }
                $append = $append.join("");
                jQuery('#PagerDiv1').append($append);


                $('#PagerDiv1,#tblClientRate').show();
                $find('mpClientRate').show();
                }
            }
            jQuery.unblockUI();
        }

        function onFailureClientRate() {
            jQuery.unblockUI();
        }
        function closeClientRate() {
            jQuery('#divClientRate').html('');
            $find('mpClientRate').hide();
        }
        function show(pageno) {
            if (pageno == "")
                _PageNo = 0;
            else
                _PageNo = pageno;
            jQuery("#tblClientRate tr:not(#headerClientRate)").remove();
            PageMethods.bindClientRate(_PageNo, _PageSize, jQuery('#lblItemID').text(), jQuery("#ddlCentreType option:selected").text(), onSucessClientRate, onFailureClientRate, pageno);
        }
        function shownextrecord() {
            var mm = $('#myddl option:selected').val();
            if (mm != "Select") {
                show(mm);
            }
        }
    </script>
</asp:Content>

