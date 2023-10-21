<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateSalesIndent.aspx.cs" Inherits="Design_Store_CreateSalesIndent" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

    

      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:150px;"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width:1304px;">
         
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Create Indent</b>  
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                          <b><asp:RadioButtonList ID="rdoIndentType" runat="server" Width="100px" onchange="setIndentType();" RepeatDirection="Horizontal">
                              <asp:ListItem Text="SI" Value="SI" Selected="True"></asp:ListItem>
                              <asp:ListItem Text="PI" Value="PI"></asp:ListItem>
                             </asp:RadioButtonList></b>  
                        </td>
                    </tr>
                    </table>
                </div>


              </div>

        
        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Indent Detail</div>

                <table width="100%">
                    <tr>
                        <td>
                            Current Location :
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlfromlocation" runat="server" style="width:404px;" onchange="bindindenttolocation()"></asp:DropDownList>
                        </td>
                        <td>Indent Location :</td>
                        <td>
                             <asp:DropDownList ID="ddltolocation" runat="server" style="width:404px;"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Search Option :</td>
                        <td>
                            <asp:RadioButtonList ID="rdsearchoption" runat="server" RepeatDirection="Horizontal" style="font-weight: 700" >
                                <asp:ListItem Text="By First Name" Value="0" >
                                    
                                </asp:ListItem>
                                 <asp:ListItem Text="In Between" Value="1" Selected="True">
                                    
                                </asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td class="required" style="display: none">Expected Date :</td>
                        <td>
                            <asp:TextBox ID="txtexpecteddate" runat="server" Width="82" TabIndex="-1" Style="display: none"></asp:TextBox>

                                    <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtexpecteddate" Format="dd-MMM-yyyy" runat="server">
                                    </cc1:CalendarExtender>
                                      

                        </td>
                    </tr>
                    <tr>
                        <td>
                            Category :</td>
                        <td>
                            <asp:DropDownList ID="ddlcategorytype" ClientIDMode="Static" runat="server" TabIndex="1" CssClass="textbox" 
                                    Width="206px">
                                </asp:DropDownList>
                           </td>
                        <td class="required">&nbsp;</td>
                        <td>
                              &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            Item :</td>
                        <td>
 <div class="ui-widget" style="display: inline-block;">
 
 
  <input id="txtitem" style="width:400px;text-transform:uppercase;" /></div>
 
  </td>
                         <td>
                            Issue Multiplier :</td>
                        <td>

 <asp:Label ID="txtIssueMultiplier" runat="server"></asp:Label>

 
  </td>
                        <td colspan="2">

                             <strong><span class="sp1" style="display:none;">Buget Amount:</span></strong>
                            <asp:Label class="sp1" runat="server" ID="lbbugetamount" Font-Bold="true" ForeColor="Red"></asp:Label>
                            <strong><span class="sp1" style="display:none;">Month Amount:</span> </strong> 
                            <asp:Label runat="server" class="sp1" ID="lbmonthamount" Font-Bold="true" ForeColor="Red"></asp:Label>
                              <strong><span class="sp1" style="display:none;">PI Amount:</span> </strong> 
                            <asp:Label runat="server" class="sp1" ID="lbmonthamountPI" Font-Bold="true" ForeColor="Red"></asp:Label>
                              <strong><span class="sp1" style="display:none;">SI Amount:</span> </strong> 
                            <asp:Label runat="server" class="sp1" ID="lbmonthamountSI" Font-Bold="true" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    </table>
                </div>
            </div>
        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div style="width:99%;max-height:250px;overflow:auto;">
                <table id="tblTemp" style="width:99%;border-collapse:collapse;text-align:left;">   
                    <tr>
                       <td style="width:300px;"><B>Item Name :</B></td>
                       <td><asp:Label ID="lblItemName" runat="server"></asp:Label></td>                      
                       <td style="font-weight: 700">Buffer Percentage :</td>                      
                       <td style="color: #FF0000">
                           <asp:Label ID="lbbufferper" runat="server" style="font-weight: 700"></asp:Label>
                        </td>                      
                    </tr>
                     <tr style="display:none;">
                        <td style="width:300px;"><B>Indent No :</B></td>
                       <td><asp:Label ID="lblIndentNo" runat="server"></asp:Label></td>                      
                       <td>&nbsp;</td>                      
                       <td>&nbsp;</td>                      
                    </tr>
                    <tr style="display:none;">
                        <td style="width:300px;"><B>From Rights :</B></td>
                       <td><asp:Label ID="lblFromRights" runat="server"></asp:Label></td>                      
                       <td>&nbsp;</td>                      
                       <td>&nbsp;</td>                      
                    </tr>
                    <tr style="display:none;">
                        <td style="width:300px;"><B>Item ID :</B></td>
                       <td><asp:Label ID="lblItemID" runat="server"></asp:Label> <asp:Label ID="lbisdecimalallowed" runat="server"></asp:Label></td>                      
                       <td>&nbsp;</td>                      
                       <td>&nbsp;</td>                      
                    </tr>
                     <tr style="display:none;">
                        <td style="width:300px;"><B>Item Group ID :</B></td>
                       <td><asp:Label ID="lblItemGroupID" runat="server"></asp:Label></td>                      
                       <td>&nbsp;</td>                      
                       <td>&nbsp;</td>                      
                    </tr>   
                    <tr>
                        <td style="width:300px;"><B>Manufacturer :</B></td>
                       <td><asp:DropDownList ID="ddlManufacturer" runat="server"  Width="500Px" onchange="bindTempData('Machine');"></asp:DropDownList></td>                      
                       <td style="font-weight: 700">Average Consumption :</td>                      
                       <td style="color: #FF0000">
                           <asp:Label ID="lbavgcon" runat="server" style="font-weight: 700"></asp:Label>
                       </td>                      
                    </tr> 
                     <tr>
                        <td style="width:300px;"><B>Machine :</B></td>
                       <td><asp:DropDownList ID="ddlMachine" runat="server" Width="500Px" onchange="bindTempData('PackSize');"></asp:DropDownList></td>                            
                       <td style="font-weight: 700">Wastage Percentage :</td>                            
                       <td style="color: #FF0000"> <asp:Label ID="lbwastper" runat="server" style="font-weight: 700"></asp:Label></td>                            
                    </tr> 
                     <tr>
                        <td style="width:300px;"><B>Pack Size :</B></td>
                       <td><asp:DropDownList ID="ddlPackSize" runat="server" Width="500Px" onchange="setDataAfterPackSize();" ></asp:DropDownList></td>                              
                       <td style="font-weight: 700">In Hand Qty :</td>                              
                       <td style="color: #FF0000">
                           <asp:Label ID="lbinhandqty" runat="server" style="font-weight: 700"></asp:Label>
                         </td>                              
                    </tr> 
                     <tr>
                        <td style="width:300px;"><B>Qty :</B></td>
                      <td><asp:TextBox ID="txtQty" runat="server" Width="80px"  onkeyup="showme(this)"  ></asp:TextBox> 
                          <cc1:FilteredTextBoxExtender id="ftbe" runat="server" targetcontrolid="txtQty" filtertype="Numbers,Custom" validchars="123456789." />
                        &nbsp;
                          <asp:Label ID="lblMinorUnitName" runat="server"></asp:Label>

                          <br />
                          <span class="auto-style1">* For SI Qty Will be Consumption Unit and For PI Qty Will be Purchased Unit </span>
                          <span style="color:red;" id="spnIssueMultiplier"></span>
                      </td>                      
                      <td style="font-weight: 700"><span id="mysi">Last Indent Pending Qty :</span></td>                      
                      <td style="color: #FF0000">
                           <asp:Label ID="lbindentpending" runat="server" style="font-weight: 700"></asp:Label>

                          <span class="sp1" style="display:none;font-size:10px;">(Current Month)</span>
                         </td>                      
                    </tr> 
                     <tr>
                       <td colspan="3" style="text-align:center;">
                           
                          <input type="button" id="btnAddItem" class="w3-btn w3-ripple" value="✔&nbsp;&nbsp;Add Item" style="cursor:pointer;font-weight:bold;" onclick="AddItemFromTemp();" />&nbsp;&nbsp;
                       </td>                                        
                       <td style="text-align:center;">
                           
                           &nbsp;</td>                                        
                    </tr>              
                </table>

                </div>
                <div style="width:99%;max-height:250px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                     
                                        <td class="GridViewHeaderStyle" style="width:20px">Sr.No.</td>
                                       <td class="GridViewHeaderStyle">Category</td>
                                       <td class="GridViewHeaderStyle">Issue Multiplier</td>
                                       <td class="GridViewHeaderStyle">ItemID</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                            <td class="GridViewHeaderStyle" id="expected">Qut Expected Date</td>
                                      
                                        <td class="GridViewHeaderStyle" title="Stock In Hand Qty">InHand Qty</td>   
                                        
                                        <td class="GridViewHeaderStyle" id="pp">Pending Receive Qty</td>
                                        <td class="GridViewHeaderStyle">Qty</td>
                                        <td class="GridViewHeaderStyle">Checked Qty</td>
                                        <td class="GridViewHeaderStyle">Approved Qty</td>
                            <td class="GridViewHeaderStyle">Lab Required Date</td>
                                        <td class="GridViewHeaderStyle">Unit</td>
                                        <td class="GridViewHeaderStyle">Item Type</td>
                                        <td class="GridViewHeaderStyle">Item Code</td>
                                        <td class="GridViewHeaderStyle">Hsn Code</td>   
                                           
                        <td class="GridViewHeaderStyle showrate" >Rate</td>
                        <td class="GridViewHeaderStyle showrate1" style="display:none;">Disc %</td>
                        <td class="GridViewHeaderStyle showrate1" style="display:none;">IGST %</td>
                          <td class="GridViewHeaderStyle showrate1" style="display:none;">CGST %</td>
                          <td class="GridViewHeaderStyle showrate1" style="display:none;">SGST %</td>
                         
                        <td class="GridViewHeaderStyle showrate1" style="display:none;">Unit Price</td>
                           <td class="GridViewHeaderStyle showrate" style="display:none;">Net Amt</td>
                     
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                        </tr>
                </table>

                </div>
                <br />
                <span class="required">Remarks :</span> <asp:TextBox ID="txtnarration" Width="434px" MaxLength="200" runat="server"></asp:TextBox>  
                


                &nbsp;&nbsp;
                <asp:TextBox ID="txtcheckercomment" placeholder="Checker Comment" ReadOnly="true" style="display:none;" class="checkedQty" runat="server" Width="200" MaxLength="150" />
                
                <br />
                
                <span class="sp1"  style="display:none;font-weight:bold;">Total PI Amount:</span> <span id="sptotalamount" class="sp1" style="display:none;font-weight:bold;"></span>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <br />
               <span id="spnReject" style="display:none;">Rejection Reason : <asp:TextBox ID="txtRejectionReason" Width="461px" MaxLength="200" runat="server"></asp:TextBox>   </span>            
              
                <span id="spdeleted"></span>
                </div>
            </div>


        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content" style="text-align:center;">               
                  <input type="button" id="btnSave" class="w3-btn w3-ripple" value="✔&nbsp;&nbsp;Save" style="cursor:pointer;font-weight:bold;display:none;" onclick="saveindent();" />
                  <input type="button" id="btnReset" class="w3-btn w3-ripple" value="X&nbsp;&nbsp;Reset" style="display:none;cursor:pointer;background-color:#ff6a00;font-weight:bold;" onclick="clearForm();" />
                  <input type="button" id="btnCheck" class="w3-btn w3-ripple" value="✔&nbsp;&nbsp;Check" style="display:none;cursor:pointer;font-weight:bold;background-color:#008CBA;" onclick="MakeAction('Check');" />
                  <input type="button" id="btnApprove" class="w3-btn w3-ripple" value="✔&nbsp;&nbsp;Approve" style="cursor:pointer;font-weight:bold;display:none;" onclick="MakeAction('Approve');" />                  
                  <input type="button" id="btnReject" class="w3-btn w3-ripple" value="X&nbsp;&nbsp;Reject" style="display:none;cursor:pointer;background-color:#f44336;font-weight:bold;" onclick="MakeAction('Reject');" />                 
                </div>
             </div>
        </div>

    <asp:Panel ID="pnl" runat="server" style="display:none;border:1px solid;" BackColor="aquamarine" Width="1100px" >

       
                 <div class="Purchaseheader">
                     Old Indent Detail
                      </div>
         <div style="width:99%;max-height:375px;overflow:auto;">
                <table id="Table1" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="tr1">
                                        
                                        <td class="GridViewHeaderStyle">Indent Type</td>
                                        <td class="GridViewHeaderStyle">Indent Date</td>
                                        <td class="GridViewHeaderStyle">Indent No</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">Indent To Loccation</td>
                                        <td class="GridViewHeaderStyle">ReqQty</td>
                                        <td class="GridViewHeaderStyle">Unit</td>
                                        <td class="GridViewHeaderStyle">ReceiveQty</td>
                                        <td class="GridViewHeaderStyle">RejectQty</td>
                                        <td class="GridViewHeaderStyle">IndentSendBy</td>
                                        <td class="GridViewHeaderStyle">ExpectedDate</td>          
                                     
                                       
                                        
                                     
                        </tr>
                </table>

                </div>

                <center><asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" /> </center>
              
    </asp:Panel>

     <cc1:ModalPopupExtender ID="modelpopup1" runat="server"   TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl" CancelControlID="btncloseme">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button2" runat="server" style="display:none" />

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

        var showrate = "0";
        var ActionType = '<%=ActionType%>';
        $(document).ready(function () {


           
            showrateoption();
            $('#expected').hide();


        });

        var myindentno = '<%=Util.GetString(Request.QueryString["IndentNo"])%>';
        function bindindenttolocation() {
           
            if ($('#<%=ddlfromlocation.ClientID%>').val() == "0") {
                $("#<%=ddltolocation.ClientID%> option").remove();
                $("#<%=ddltolocation.ClientID%>").append($("<option></option>").val("0").html("Select To Location"));
                return;
            }
            var dropdown = $("#<%=ddltolocation.ClientID%>");
            $("#<%=ddltolocation.ClientID%> option").remove();
            $.ajax({
                url: "CreateSalesIndent.aspx/bindindenttolocation",
                data: '{fromlocation:"' + $('#<%=ddlfromlocation.ClientID%>').val() + '",myindentno:"' + myindentno + '",IndentType:"' + $("#<%=rdoIndentType.ClientID%>").find(":checked").val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
              
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        dropdown.append($("<option></option>").val("0").html("--No Location Found--"));
                    }
                    else {
                        if (PanelData.length > 1) {
                            dropdown.append($("<option></option>").val("0").html("Select To Location"));
                        }
                        for (i = 0; i < PanelData.length; i++) {
                            dropdown.append($("<option></option>").val(PanelData[i].locationid).html(PanelData[i].location));
                        }

                        if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "PI") {
                            $('#<%=lbbugetamount.ClientID%>').html(precise_round(PanelData[0].BudgetAmount, 5));
                            
                            $('#<%=lbmonthamountPI.ClientID%>').html(precise_round(PanelData[0].MonthIndentAmount, 5));
                            $('#<%=lbmonthamountSI.ClientID%>').html(precise_round(PanelData[0].MonthIndentAmountSI, 5));
                            var tot=parseFloat($('#<%=lbmonthamountPI.ClientID%>').html()) + parseFloat($('#<%=lbmonthamountSI.ClientID%>').html())
                            $('#<%=lbmonthamount.ClientID%>').html(precise_round(tot, 5));
                            
                        }
                        else {
                            $('#<%=lbbugetamount.ClientID%>').html('');
                            $('#<%=lbmonthamount.ClientID%>').html('');
                            $('#<%=lbmonthamountPI.ClientID%>').html('');
                            $('#<%=lbmonthamountSI.ClientID%>').html('');
                        }
                    }
                  

                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function split(val) {
            return val.split(/,\s*/);
        }
        function extractLast(term) {


            return split(term).pop();
        }
        $(function () {
            $("#txtitem")
                      .bind("keydown", function (event) {
                          if (event.keyCode === $.ui.keyCode.TAB &&
                              $(this).autocomplete("instance").menu.active) {
                              event.preventDefault();
                          }

                      })
                      .autocomplete({
                          autoFocus: true,
                          source: function (request, response) {

                             
                              $.ajax({
                                  url: "CreateSalesIndent.aspx/SearchItem",
                                  data: '{itemname:"' + extractLast(request.term) + '",locationidfrom:"' + $('#<%=ddlfromlocation.ClientID%>').val() + '", locationidto:"' + $('#<%=ddltolocation.ClientID%>').val() + '",itemcate:"'+$('#<%=ddlcategorytype.ClientID%>').val()+'", IndentType:"' + $("#<%=rdoIndentType.ClientID%>").find(":checked").val() + '",searchoption:"' + $("#<%=rdsearchoption.ClientID%>").find(":checked").val() + '"}',
                                  contentType: "application/json; charset=utf-8",
                                  type: "POST", // data has to be Posted 
                                  timeout: 120000,
                                  dataType: "json",
                                  async: true,
                                  success: function (result) {
                                      response($.map(jQuery.parseJSON(result.d), function (item) {
                                          return {
                                              label: item.ItemNameGroup,
                                              value: item.ItemIDGroup,
                                              label1:item.IssueMultiplier
                                          }
                                      }))


                                  },
                                  error: function (xhr, status) {
                                      showerrormsg(xhr.responseText);
                                  }
                              });
                          },
                          search: function () {
                              // custom minLength

                              var term = extractLast(this.value);
                              if (term.length < 2) {
                                  return false;
                              }
                          },
                          focus: function () {
                              // prevent value inserted on focus
                              return false;
                          },
                          select: function (event, ui) {


                              this.value = '';

                              setTempData(ui.item.value, ui.item.label,ui.item.label1);
                             //AddItem(ui.item.value);

                              return false;
                          },


                      });

           
          //  bindindenttolocation();
            
        });

        var pendingpoqty = "";
      
        function AddItemFromTemp() {

           
            if ($('#<%=ddlManufacturer.ClientID%>').val() == "") {
                showerrormsg("Please Select Manufacturer...!");
                $('#<%=ddlManufacturer.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlMachine.ClientID%>').val() == "") {
                showerrormsg("Please Select Machine...!");
                $('#<%=ddlMachine.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlPackSize.ClientID%>').val() == "") {
                showerrormsg("Please Select PackSize...!");
                $('#<%=ddlPackSize.ClientID%>').focus();
                return;
            }
            if ($('#<%=lblItemID.ClientID%>').html() == "") {
                showerrormsg("Please Select Item...!");
                $('#txtitem').focus();
                return;
            }
            if ($('#<%=txtQty.ClientID%>').val() == "") {
                showerrormsg("Please Enter Qty...!");
                $('#<%=txtQty.ClientID%>').focus();
                 return;
            }
            if ($('#<%=txtQty.ClientID%>').val() == "0") {
                showerrormsg("Please Enter Qty...!");
                $('#<%=txtQty.ClientID%>').focus();
                return;
            }
            var IssueMultiplier = $("#<%=ddlPackSize.ClientID %>").val().split('#')[0];
            if (parseFloat(IssueMultiplier) > 0) {
                if ((parseFloat($("#<%= txtQty.ClientID%>").val()) % parseFloat(IssueMultiplier)) == 0) {
                   
                }
                else {
                    showerrormsg('Quantity should be muliple of  ' + IssueMultiplier + ' ..!');
                    $("#<%= txtQty.ClientID%>").val('');
                    return;
                    }

            }

            // formula
            if (ApplyFormula == "1") {
                if (QtyFormula() == false) {
                    return;
                }
            }
            pendingpoqty = $('#ContentPlaceHolder1_lbindentpending').html();
           
            AddItem($('#<%=lblItemID.ClientID%>').html(), $('#<%=txtQty.ClientID%>').val());

            clearTempData();
        }
        function AddItem(itemid, Qty) {
            if ($('#<%=ddlfromlocation.ClientID%>').val() == "0") {
                 showerrormsg("Please Select Current Location");
                 $('#<%=ddlfromlocation.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddltolocation.ClientID%>').val() == "0") {
                showerrormsg("Please Select Indent Location");
                $('#<%=ddltolocation.ClientID%>').focus();
                 return;
             }
           
            // $.blockUI();

             $.ajax({
                 url: "CreateSalesIndent.aspx/SearchItemDetail",
                 data: '{itemid:"' + itemid + '",curlocation:"' + $('#<%=ddlfromlocation.ClientID%>').val() + '",IndentType:"' + $("#<%=rdoIndentType.ClientID%>").find(":checked").val() + '"}',
                type: "POST",
                timeout: 120000,
           
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    if (result.d == "-1") {
                       // $.unblockUI();
                        $('#txtitem').focus();
                        $('#<%=ddlfromlocation.ClientID%>').prop("disabled", true);
                        $('#<%=ddltolocation.ClientID%>').prop("disabled", true);
                        $('#<%=ddlcategorytype.ClientID%>').prop("disabled", true);
                        showerrormsg("Indent Already Raised For This Item ");
                        showoldindentdata(itemid);
                        return;
                    }
                    if (result.d == "-2") {
                       // $.unblockUI();
                        $('#txtitem').focus();
                        $('#<%=ddlfromlocation.ClientID%>').prop("disabled", true);
                        $('#<%=ddltolocation.ClientID%>').prop("disabled", true);
                        $('#<%=ddlcategorytype.ClientID%>').prop("disabled", true);
                         showerrormsg("PI Already Created. PO Pending For This Item ");
                         showoldindentdata(itemid);
                         return;
                    }
                    if (result.d == "-3") {
                      //  $.unblockUI();
                        $('#txtitem').focus();
                        $('#<%=ddlfromlocation.ClientID%>').prop("disabled", true);
                        $('#<%=ddltolocation.ClientID%>').prop("disabled", true);
                        $('#<%=ddlcategorytype.ClientID%>').prop("disabled", true);
                         showerrormsg("PO Already Created. GRN Not Received ");
                         //showoldindentdata(itemid);
                         return;
                    }

                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Item Found");
                       // $.unblockUI();


                    }
                    else {
                        if ($('table#tblitemlist').find('#' + ItemData[0].itemid).length > 0) {
                            showerrormsg("Item Already Added");
                           // $.unblockUI();
                            return;
                        }
                        addDataToTable(ItemData, Qty, 'New');
                       // clearTempData();
                       // $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                  //  $.unblockUI();

                }
            });
        }

        function checkApprovedQty(ctrl,Qty)
        {

          

            if ($(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "" || $(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "0") {

                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }


            if (isNaN($(ctrl).val()))
            {
                showerrormsg('Only Numeric Value Allowed...!');
                $(ctrl).val('0');
                return false;               
            }
            else if ( parseFloat($(ctrl).val())>parseFloat(Qty)) {
                showerrormsg(' Quantity can not be greated than Max Quantity...!');
                $(ctrl).val('0');
                return false;
            }
            var qty = parseFloat($(ctrl).val());
            var unitprice = parseFloat($(ctrl).closest('tr').find('#tdUnitPrice').html());
            var netamount = qty * unitprice;
            $(ctrl).closest('tr').find('#tdNetAmount').html(netamount);
            calculatetotal();
            
        }

        function addDays(n) {
            var t = new Date();
            t.setDate(t.getDate() + n);
            var month = "0" + (t.getMonth() + 1);
            var date = "0" + t.getDate();
            month = month.slice(-2);
            date = date.slice(-2);
            var date = date + "/" + month + "/" + t.getFullYear();
            return date;
        }
        function addDataToTable(ItemData, Qty, NewOrEdit) {


            var a = $('#tblitemlist tr').length - 1;
            for (var i = 0; i < ItemData.length; i++) {
                var UCID = i + '' + new Date().getMilliseconds();
                var getdate = addDays(ItemData[i].ExpectedDay);

                if (precise_round(ItemData[i].Rate, 5) == 0 && $("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "PI") {

                     showerrormsg("Please Enter Quotation Rate For This Item");
                     return false;
                 }
                 if (NewOrEdit == 'Edit') {
                     Qty = ItemData[i].ReqQty;
                 }
                 var ApprovedQty = ItemData[i].ApprovedQty;
                 if (ApprovedQty == undefined) {
                     ApprovedQty = '0';
                 }

                 var checkedQty = ItemData[i].checkedQty;
                 if (checkedQty == undefined) {
                     checkedQty = '0';
                 }

                 var maxQty = Qty;
                 var mydata = "<tr style='background-color:bisque;' id='" + ItemData[i].itemid + "' >";
                 mydata += '<td class="GridViewLabItemStyle">' + parseFloat(a + 1) + '</td>';

                 mydata += '<td class="GridViewLabItemStyle" id="tditemcategory">' + ItemData[i].categorytypename + '</td>';
                  mydata += '<td class="GridViewLabItemStyle" id="tditemcategory">' + ItemData[i].IssueMultiplier + '</td>';
                 mydata += '<td  id="tditemid1" style="font-weight:bold;">' + ItemData[i].itemid + '</td>';
                 mydata += '<td class="GridViewLabItemStyle" id="tditemname">' + ItemData[i].typename + '</td>';

                 if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "PI") {
                    mydata += '<td class="GridViewLabItemStyle" id="date" style="font-weight:bold;">' + getdate + '</td>';
                }
                mydata += '<td class="GridViewLabItemStyle" id="tdInhandQty" title="Stock In Hand Qty">' + precise_round(ItemData[i].InhandQty, 5) + '</td>';

                


                if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "PI") {
                    if (NewOrEdit == "New") {
                        mydata += '<td class="GridViewLabItemStyle" id="tdpendingpiqty">' + pendingpoqty + '</td>';
                    }
                    else {
                        mydata += '<td class="GridViewLabItemStyle" id="tdpendingpiqty">' + ItemData[i].LastPendingQty + '</td>';
                    }
                }
                else {
                    if (NewOrEdit == "New") {
                        mydata += '<td class="GridViewLabItemStyle" id="tdpendingpiqty">' + pendingpoqty + '</td>';
                    }
                    else {
                        mydata += '<td class="GridViewLabItemStyle" id="tdpendingpiqty">' + ItemData[i].LastPendingQty + '</td>';
                    }
                }
                mydata += '<td align="left" id="tdQuantity"><input type="text"  style="width:60px" id="txtQuantity" onkeyup="showme(this);" class="qty" value="' + Qty + '"  /></td>';

                if (checkedQty == "0") {
                    mydata += '<td align="left" id="tdApprovedQuantity"><input type="text"  style="width:60px" id="txtcheckedQuantity" onkeyup="checkApprovedQty(this,' + maxQty + ')" class="checkedQty" value="' + Qty + '" readonly="readonly" /></td>';
                }
                else {
                    mydata += '<td align="left" id="tdApprovedQuantity"><input type="text"  style="width:60px" id="txtcheckedQuantity" onkeyup="checkApprovedQty(this,' + maxQty + ')" class="checkedQty" value="' + checkedQty + '" readonly="readonly" /></td>';
                }


                if (ApprovedQty == "0") {
                    mydata += '<td align="left" id="tdApprovedQuantity"><input type="text"  style="width:60px" id="txtApprovedQuantity" onkeyup="checkApprovedQty(this,' + maxQty + ')" class="ApprovedQuantity" value="' + checkedQty + '" readonly="readonly" /></td>';
                }
                else {
                    mydata += '<td align="left" id="tdApprovedQuantity"><input type="text"  style="width:60px" id="txtApprovedQuantity" onkeyup="checkApprovedQty(this,' + maxQty + ')" class="ApprovedQuantity" value="' + ApprovedQty + '" readonly="readonly" /></td>';
                }

                mydata += '<td align="left" id="tdexpectedday"><input type="text" value="' + ItemData[i].ExpectedDateToShow + '" id="txtGridExpectedDate' + UCID + '"  maxlength="100" data-title="Enter Expected Date"/> </td>';


                mydata += '<td class="GridViewLabItemStyle" id="tdminorunitname">' + ItemData[i].MinorUnitName + '</td>';
                mydata += '<td class="GridViewLabItemStyle" id="tditemgroupname">' + ItemData[i].itemgroup + '</td>';
                mydata += '<td class="GridViewLabItemStyle" id="tdapolloitemcode">' + ItemData[i].apolloitemcode + '</td>';
                mydata += '<td class="GridViewLabItemStyle" id="tdHsnCode">' + ItemData[i].HsnCode + '</td>';
              
                mydata += '<td class="GridViewLabItemStyle showrate" id="tdrate" >' + precise_round(ItemData[i].Rate, 5) + '</td>';
                mydata += '<td class="GridViewLabItemStyle showrate1" id="tddiscper" style="display:none;">' + precise_round(ItemData[i].DiscountPer, 5) + '</td>';
                mydata += '<td class="GridViewLabItemStyle showrate1" id="tdTaxPerIGST" style="display:none;">' + precise_round(ItemData[i].TaxPerIGST, 5) + '</td>';
                mydata += '<td class="GridViewLabItemStyle showrate1" id="tdTaxPerCGST" style="display:none;">' + precise_round(ItemData[i].TaxPerCGST, 5) + '</td>';
                mydata += '<td class="GridViewLabItemStyle showrate1" id="tdTaxPerSGST" style="display:none;">' + precise_round(ItemData[i].TaxPerSGST, 5) + '</td>';

                var qty = Qty;

                if (checkedQty != "0") {
                    qty = checkedQty;
                }
                if (ApprovedQty != "0") {
                    qty = ApprovedQty;
                }
               
                var rate = ItemData[i].Rate;
                var discper = ItemData[i].DiscountPer;
                var IGST = ItemData[i].TaxPerIGST;
                var CGST = ItemData[i].TaxPerCGST;
                var SGST = ItemData[i].TaxPerSGST;

                var Tax = IGST == 0 ? (CGST + SGST) : IGST;

                var discountAmout = precise_round((rate * discper * 0.01), 5);
                var ratedisc = precise_round((rate - discountAmout), 5);
                var tax = precise_round((ratedisc * Tax * 0.01), 5);
                var ratetaxincludetax = precise_round((ratedisc + tax), 5);

                var NetAmount = ratetaxincludetax * parseFloat(qty);
                mydata += '<td class="GridViewLabItemStyle showrate1" id="tdUnitPrice" style="display:none;">' + precise_round(ratetaxincludetax, 5) + '</td>';
                mydata += '<td class="GridViewLabItemStyle showrate" id="tdNetAmount" style="display:none;">' + precise_round(NetAmount, 5) + '</td>';
              
                mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
                mydata += '<td  style="display:none;" id="tdconverter">' + ItemData[i].PackSize + '</td>';
                mydata += '<td  style="display:none;" id="tdminorunitname">' + ItemData[i].MinorUnitName + '</td>';
                mydata += '<td style="display:none;" id="tditemid">' + ItemData[i].itemid + '</td>';
                mydata += '<td style="display:none;" id="tdmajorunitid">' + ItemData[i].MajorUnitId + '</td>';
                mydata += '<td style="display:none;" id="tdminorunitid">' + ItemData[i].MinorUnitId + '</td>';
                mydata += '<td style="display:none;" id="tdmanufaid">' + ItemData[i].ManufactureID + '</td>';
                mydata += '<td style="display:none;" id="tdmacid">' + ItemData[i].MachineID + '</td>';
                mydata += '<td style="display:none;" id="tdIssueMultiplier">' + ItemData[i].IssueMultiplier + '</td>';


                mydata += '<td style="display:none;" id="tdisdecimalallowed">' + ItemData[i].isdecimalallowed + '</td>';
                mydata += '<td style="display:none;" id="tdvendorid">' + ItemData[i].vendorid + '</td>';
                mydata += '<td style="display:none;" id="tdVendorStateId">' + ItemData[i].VendorStateId + '</td>';
                mydata += '<td style="display:none;" id="tdVednorStateGstnno">' + ItemData[i].VednorStateGstnno + '</td>';

               

              


                mydata += "</tr>";
                a = parseFloat(a) + 1;
                $('#tblitemlist').append(mydata);
                if (ItemData[i].deactiveitem != "") {
                    $('#spdeleted').html("<br/>Removed Item :" + ItemData[i].deactiveitem);
                    $('#spdeleted').css('background-color', 'maroon').css('color','white');
                }
               
               
                calculatetotal();
                if (showrate == "1") {
                    $('.showrate').show();
                }
                else {
                    $('.showrate').hide();
                }
                jQuery("#txtGridExpectedDate" + UCID).datepicker({
                    dateFormat: "dd-M-yy",
                    changeMonth: true,
                    changeYear: true, yearRange: "-20:+0",
                    minDate: new Date()
                }).attr('readonly', 'readonly');
            }
            $('#txtitem').focus();
            $('#<%=ddlfromlocation.ClientID%>').prop("disabled", true);
            $('#<%=ddltolocation.ClientID%>').prop("disabled", true);
            $('#<%=ddlcategorytype.ClientID%>').prop("disabled", true);

           
        }


        function calculatetotal() {

            var finalamt = 0;
            $('#tblitemlist tr').each(function () {

                if ($(this).attr('id') != 'triteheader') {

                    var net = $(this).find("#tdNetAmount").html() == "" ? 0 : parseFloat($(this).find("#tdNetAmount").html());
                    finalamt = finalamt + net;

                }
            });
           
            $('#sptotalamount').html(precise_round(finalamt, 5));


        }
        function showoldindentdata(itemid) {
         //   $('#   tr').slice(1).remove();           
            $.ajax({
                url: "CreateSalesIndent.aspx/showoldindentdata",
                data: '{itemid:"' + itemid + '",curlocation:"' + $('#<%=ddlfromlocation.ClientID%>').val() + '",IndentType:"' + $("#<%=rdoIndentType.ClientID%>").find(":checked").val() + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                      //  showerrormsg("No Item Found");
                      //  $.unblockUI();


                    }
                    else {

                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:yellow;height:35px;font-weight:bold;'>";
                        
                            mydata += '<td class="GridViewLabItemStyle" >' + $("#<%=rdoIndentType.ClientID%>").find(":checked").val() + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].IndentDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].IndentNo + '</td>'; 
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ItemName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].IndentToLoccation + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + precise_round(ItemData[i].ReqQty,5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].MinorUnitName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + precise_round(ItemData[i].ReceiveQty,5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + precise_round(ItemData[i].RejectQty,5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].IndentSendBy + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ExpectedDate + '</td>';
                            

                            mydata += "</tr>";


                            $('#Table1').append(mydata);

                        }

                        $find("<%=modelpopup1.ClientID%>").show();


                    }

                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                }
            });
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function showme(ctrl) {
         
            if ($('#<%=lbisdecimalallowed.ClientID%>').html() == "" || $('#<%=lbisdecimalallowed.ClientID%>').html() == "0") {
              
                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }
         
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

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function deleterow(itemid) {

           


            var table = document.getElementById('tblitemlist');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);



            calculatetotal();

           

        }

       
    </script>

    <script type="text/javascript">

        function clearForm() {
           
            if ($("#<%=lblIndentNo.ClientID %>").html() != '') {
              
                $('#<%=ddlfromlocation.ClientID%>').prop("disabled", true);
                $('#<%=ddltolocation.ClientID%>').prop("disabled", true);
                $('#<%=ddlcategorytype.ClientID%>').prop("disabled", true);
            }
            else {
                parent.jQuery.fancybox.close();
                $('#<%=ddlfromlocation.ClientID%>').prop('selectedIndex', 0);
                $('#<%=ddlfromlocation.ClientID%>').prop("disabled", false);
                $('#<%=ddltolocation.ClientID%>').prop("disabled", false);
                $('#<%=ddlcategorytype.ClientID%>').prop("disabled", false);
                $('#<%=ddlcategorytype.ClientID%>').prop('selectedIndex', 0);
               
            }
        
           
            $('#<%=lbbugetamount.ClientID%>').html('');
            $('#<%=lbmonthamount.ClientID%>').html('');
            $('#<%=lbmonthamountPI.ClientID%>').html('');
            $('#<%=lbmonthamountSI.ClientID%>').html('');
            bindindenttolocation();

            $('#tblitemlist tr').slice(1).remove();
            $('#txtitem').val('');
            $('#<%=txtexpecteddate.ClientID%>').val('');
            $('#<%=txtnarration.ClientID%>').val('');

            $('#sptotalamount').html('');
            clearTempData();
        }
        function clearTempData() { 
            $("#<%=ddlManufacturer.ClientID %> option").remove();
            $("#<%=ddlMachine.ClientID %> option").remove();
            $("#<%=ddlPackSize.ClientID %> option").remove();
            $("#<%=lblItemID.ClientID %>").html('');
            $("#<%=lbisdecimalallowed.ClientID %>").html('');
            
            $("#<%=lblItemGroupID.ClientID %>").html('');
            $("#<%=lblItemName.ClientID %>").html('');
            $("#<%=txtIssueMultiplier.ClientID %>").html('');
            $("#<%=lblMinorUnitName.ClientID %>").html('');
          //  $("#<%=lblIndentNo.ClientID %>").html('');
            $("#<%=txtQty.ClientID %>").val('');

            $('#<%=lbinhandqty.ClientID%>').html('');
            $('#<%=lbbufferper.ClientID%>').html('');
            $('#<%=lbavgcon.ClientID%>').html('');
            $('#<%=lbwastper.ClientID%>').html('');
            $('#<%=lbindentpending.ClientID%>').html('');
        }


        function validation() {

            if ($('#<%=ddlfromlocation.ClientID%>').val() == "0") {
                showerrormsg("Please Select From Location");
                $('#<%=ddlfromlocation.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddltolocation.ClientID%>').val() == "0") {
                showerrormsg("Please Select To Location");
                $('#<%=ddltolocation.ClientID%>').focus();
                return false;
            }


            if ($('#<%=txtnarration.ClientID%>').val() == "") {
                showerrormsg("Please Enter narration");
                $('#<%=txtnarration.ClientID%>').focus();
                return false;
            }




            var count = $('#tblitemlist tr').length;
            if (count == 0 || count == 1) {
                showerrormsg("Please Select Item  ");
                $('#txtitem').focus();
                return false;
            }

            var sn11 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var qty = $(this).find('#txtQuantity').val() == "" ? 0 : parseFloat($(this).find('#txtQuantity').val());


                    if (qty == 0) {
                        sn11 = 1;
                        $(this).find('#txtQuantity').focus();
                        return;
                    }
                }
            });

            if (sn11 == 1) {
                showerrormsg("Please Enter Qty ");
                return false;
            }


            var sn11111 = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var qty = $(this).find('.hasDatepicker').val() == ""


                    if ($(this).find('.hasDatepicker').val() == "") {
                        sn11111 = 1;
                        $(this).find('.hasDatepicker').focus();
                        return;
                    }
                }
            });

            if (sn11111 == 1) {
                showerrormsg("Please Select Lab Required Date ");
                return false;
            }

            var sn111 = 0; var mu = 0;
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                    var qty =parseFloat($(this).find('#txtQuantity').val());
                    var multiplier = $(this).find('#tdIssueMultiplier').html();

                    if (parseFloat(multiplier) > 0 && parseFloat(qty) % parseFloat(multiplier) != 0) {
                        sn111 = 1;
                        $(this).find('#txtQuantity').focus();
                        $(this).find('#txtQuantity').val('');
                        mu = multiplier;
                        return;
                    }
                }
            });

            if (sn111 == 1) {
                showerrormsg("Indent Quantity Must Be Divisible of " + mu);
                return false;
            }



           



            return true;
        }

        function getstore_SaveIndentdetail() {

            var dataindent = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {
                   
                    var objindentMaster = new Object();
                    objindentMaster.IndentNo = $("#<%=lblIndentNo.ClientID %>").html();
                    objindentMaster.ItemId = id;
                    objindentMaster.ItemName = $(this).closest('tr').find('#tditemname').html();
                    objindentMaster.FromPanelId = $('#<%=ddlfromlocation.ClientID%>').val().split('#')[1];
                    objindentMaster.FromLocationID = $('#<%=ddlfromlocation.ClientID%>').val().split('#')[0];
                    objindentMaster.ToPanelID = $('#<%=ddltolocation.ClientID%>').val().split('#')[1];
                    objindentMaster.ToLocationID = $('#<%=ddltolocation.ClientID%>').val().split('#')[0];
                    objindentMaster.ReqQty = $(this).closest('tr').find('#txtQuantity').val();
                    objindentMaster.MinorUnitID = $(this).closest('tr').find('#tdminorunitid').html();
                    objindentMaster.MinorUnitName = $(this).closest('tr').find('#tdminorunitname').html();
                    objindentMaster.Narration = $('#<%=txtnarration.ClientID%>').val().replace(/[&\/\\#,+()$~%.'":*?<>{}]/g, '');
                    objindentMaster.ExpectedDate = $(this).closest('tr').find('.hasDatepicker').val();
                    objindentMaster.IndentType = $("#<%=rdoIndentType.ClientID%>").find(":checked").val();
                    objindentMaster.FromRights = $("#<%=lblFromRights.ClientID %>").html();
                    objindentMaster.Rate = $(this).closest('tr').find('#tdrate').html();
                    objindentMaster.DiscountPer = $(this).closest('tr').find('#tddiscper').html();
                    objindentMaster.TaxPerIGST = $(this).closest('tr').find('#tdTaxPerIGST').html();
                    objindentMaster.TaxPerCGST = $(this).closest('tr').find('#tdTaxPerCGST').html();
                    objindentMaster.TaxPerSGST = $(this).closest('tr').find('#tdTaxPerSGST').html();
                    objindentMaster.ApprovedQty = $(this).closest('tr').find('#txtApprovedQuantity').val();
                    objindentMaster.CheckedQty = $(this).closest('tr').find('#txtcheckedQuantity').val();
                    objindentMaster.NetAmount = $(this).closest('tr').find('#tdNetAmount').html();
                    objindentMaster.UnitPrice = $(this).closest('tr').find('#tdUnitPrice').html();
                    objindentMaster.Vendorid = $(this).closest('tr').find('#tdvendorid').html();
                    objindentMaster.VendorStateId = $(this).closest('tr').find('#tdVendorStateId').html();
                    objindentMaster.VednorStateGstnno = $(this).closest('tr').find('#tdVednorStateGstnno').html();

                    objindentMaster.MaxQty = $(this).closest('tr').find('#txtQuantity').val();







                    dataindent.push(objindentMaster);
                }
            });

            return dataindent;

        }

        function saveindent() {

            if (validation() == false) {
                return;
            }
            var monthlimit = true;
            var netamount = 0;
            if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "PI") {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        netamount = parseFloat(netamount) + parseFloat($(this).closest('tr').find('#tdNetAmount').html());
                    }
                });


                var total = parseFloat(netamount) + parseFloat($('#<%=lbmonthamount.ClientID%>').html());
                if (parseFloat(total) > parseFloat($('#<%=lbbugetamount.ClientID%>').html())) {

                    if (confirm("Indent Amount Exceed Budget Amount \n Do You Want To Continue?")) {
                        monthlimit = true;

                    }
                    else {
                        monthlimit = false;
                    }
                }
            }
            if (monthlimit == false) {
                return;
            }

            var store_SaveIndentdetail = getstore_SaveIndentdetail();
          
           // console.log(store_SaveIndentdetail);
            //console.log(st_nmstock);

           // $.blockUI();
            $.ajax({
                url: "CreateSalesIndent.aspx/saveindent",
                data: JSON.stringify({ store_SaveIndentdetail: store_SaveIndentdetail }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
            
                success: function (result) {
                   // $.unblockUI();
                    if (result.d.split('#')[0] == "1") {

                        showmsg("Indent Saved Successfully..!");                       
                        if ($('#<%=lblIndentNo.ClientID%>').html() != '') {                           
                            location.reload(true);
                        }
                        else {
                            window.open('IndentReceipt.aspx?IndentNo=' + result.d.split('#')[1]);
                            clearForm();                           
                        }

                    }
                    else {
                        showerrormsg(result.d.split('#')[1]);
                    }

                },
                error: function (xhr, status) {
                  //  $.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });

        }

     

        function showrateoption() {

            $.ajax({
                url: "CreateSalesIndent.aspx/checkshowrate",
                data: JSON.stringify({ IndentType: $("#<%=rdoIndentType.ClientID%>").find(":checked").val(), ActionType: ActionType }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    showrate = result.d;

                    if (showrate == "1") {
                        $('.showrate').show();
                    }
                    else {
                        $('.showrate').hide();
                    }

                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                }
              });
        }
        function setIndentType() {
            

            if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "PI") {
                $('.sp1').show();
                $('#mysi').html('Pending PO Qty :');
                $('#pp').text('Pending PO Qty');
                $('#expected').show();


            }
            else {
                $('.sp1').hide();
                $('#mysi').html('Last Indent Pending Qty :');
                $('#pp').text('Pending To Receive Qty');

                $('#expected').hide();

            }

            showrateoption();
            clearForm();
        }
        function setTempData(ItemGroupID, ItemGroupName, IssueMultiplier) {
            $('#<%=lblItemGroupID.ClientID%>').html(ItemGroupID);
            $('#<%=lblItemName.ClientID%>').html(ItemGroupName);
            $('#<%=txtIssueMultiplier.ClientID%>').html(IssueMultiplier);
           // $('#tblTemp').show();
            bindTempData('Manufacturer');
        }
        function setDataAfterPackSize() {
            if ($("#<%=ddlPackSize.ClientID %>").val() != '') {
                var IssueMultiplier = $("#<%=ddlPackSize.ClientID %>").val().split('#')[0];
                if (IssueMultiplier == '0') {
                    IssueMultiplier = '';
                }
                else {
                    $("#spnIssueMultiplier").html('* in multiple of ' + IssueMultiplier);
                }
                $("#<%=lblItemID.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[2]);

                if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "SI") {
                    $("#<%=lblMinorUnitName.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[1] + ' ( Consumption Unit )');
                }
                else {
                    $("#<%=lblMinorUnitName.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[1] + ' ( Purchased Unit )');
                }

                $("#<%=lbisdecimalallowed.ClientID %>").html($("#<%=ddlPackSize.ClientID %>").val().split('#')[3]);


                $("#<%=txtQty.ClientID %>").focus();
            }
            else {
                $("#spnIssueMultiplier").html('');
                $("#<%=lblMinorUnitName.ClientID %>").html('');
            }


            binditemindentdata($("#<%=lblItemID.ClientID %>").html(),$('#<%=ddlfromlocation.ClientID%>').val().split('#')[0]);
        }
        function bindTempData(bindType) {
            if (bindType == 'Manufacturer') {
                bindManufacturer($('#<%=lblItemGroupID.ClientID%>').html());
            }
            else if (bindType == 'Machine') {
                bindMachine($('#<%=lblItemGroupID.ClientID%>').html(), $("#<%=ddlManufacturer.ClientID %>").val());
            }
            else if (bindType == 'PackSize') {
                bindPackSize($('#<%=lblItemGroupID.ClientID%>').html(), $("#<%=ddlManufacturer.ClientID %>").val(), $("#<%=ddlMachine.ClientID %>").val());
            }
        }
        function bindManufacturer(ItemIDGroup) {
            $("#<%=ddlManufacturer.ClientID %> option").remove(); 
            $("#<%=ddlMachine.ClientID %> option").remove();
            $("#<%=ddlPackSize.ClientID %> option").remove(); 
            locationidfrom = $('#<%=ddlfromlocation.ClientID%>').val().split('#')[0];
            $.ajax({
                url: "CreateSalesIndent.aspx/bindManufacturer",
                data: JSON.stringify({ locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, IndentType: $("#<%=rdoIndentType.ClientID%>").find(":checked").val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    var tempData = $.parseJSON(result.d);
                    console.log(tempData);
                    if (tempData.length > 1) {
                        $("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val('').html('Select Manufacturer'));
                    }
                    for (var i = 0; i < tempData.length; i++) {
                        $("#<%=ddlManufacturer.ClientID %>").append($("<option></option>").val(tempData[i].ManufactureID).html(tempData[i].ManufactureName));
                    }
                    if (tempData.length == 1) {
                        bindMachine(ItemIDGroup, tempData[0].ManufactureID);
                    }
                    else {
                        $("#<%=ddlManufacturer.ClientID %>").focus();
                    }
                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                }
            });
        }
        function bindMachine(ItemIDGroup, ManufactureID) {
            $("#<%=ddlMachine.ClientID %> option").remove(); 
            $("#<%=ddlPackSize.ClientID %> option").remove(); 
            locationidfrom = $('#<%=ddlfromlocation.ClientID%>').val().split('#')[0];
            $.ajax({
                url: "CreateSalesIndent.aspx/bindMachine",
                data: JSON.stringify({ locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, IndentType: $("#<%=rdoIndentType.ClientID%>").find(":checked").val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    var tempData = $.parseJSON(result.d);
                    if (tempData.length > 1) {
                        $("#<%=ddlMachine.ClientID %>").append($("<option></option>").val('').html('Select Machine'));
                    }
                    for (var i = 0; i < tempData.length; i++) {
                        $("#<%=ddlMachine.ClientID %>").append($("<option></option>").val(tempData[i].MachineID).html(tempData[i].MachineName));
                    }
                    if (tempData.length == 1) {
                        bindPackSize(ItemIDGroup, ManufactureID, tempData[0].MachineID);
                    }                    
                    else {
                        $("#<%=ddlMachine.ClientID %>").focus();
                    }
                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                }
            });
        }
        function bindPackSize(ItemIDGroup, ManufactureID, MachineID) {
            locationidfrom = $('#<%=ddlfromlocation.ClientID%>').val().split('#')[0];
            $("#<%=ddlPackSize.ClientID %> option").remove();  
            $.ajax({
                url: "CreateSalesIndent.aspx/bindPackSize",
                data: JSON.stringify({ locationidfrom: locationidfrom, ItemIDGroup: ItemIDGroup, ManufactureID: ManufactureID, MachineID: MachineID, IndentType: $("#<%=rdoIndentType.ClientID%>").find(":checked").val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    var tempData = $.parseJSON(result.d);
                    if (tempData.length > 1) {
                        $("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val('').html('Select Pack Size'));
                    }
                    for (var i = 0; i < tempData.length; i++) {
                        $("#<%=ddlPackSize.ClientID %>").append($("<option></option>").val(tempData[i].PackValue).html(tempData[i].PackSize));
                    }
                    if (tempData.length == 1) {
                        setDataAfterPackSize();
                        $("#<%=txtQty.ClientID %>").focus();
                    }
                    else if (tempData.length == 0 || tempData.length > 0) {
                        $("#<%=ddlPackSize.ClientID %>").focus();                        
                        } 
                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                }
            });
        }
        function checkValidQty() {            
            var IssueMultiplier = $("#<%=ddlPackSize.ClientID %>").val().split('#')[0];
            if (parseFloat(IssueMultiplier) > 0) {
                if ((parseFloat($("#<%= txtQty.ClientID%>").val()) % parseFloat(IssueMultiplier)) == 0) {                  
                    AddItemFromTemp();
                    }
                else {                   
                        showerrormsg('Quantity should be muliple of  ' + IssueMultiplier + ' ..!');
                        $("#<%= txtQty.ClientID%>").val('');
                    }

                }
        }
        $(function () {            
            $("#<%= txtQty.ClientID%>").keydown(
                function (e) {
                    var key = (e.keyCode ? e.keyCode : e.charCode);
                    if (key == 13) {
                        e.preventDefault();
                        AddItemFromTemp();
                    }
                    else if (key == 9) {
                        e.preventDefault();
                        AddItemFromTemp();
                    }
                });
            loadDataFromIndentNo();
        });

        function loadDataFromIndentNo() {
            var tempData = <%=IndentData%>;
            if (tempData.length==0) {
                $('#btnSave,#btnReset').show();
                bindindenttolocation();
                return;
            }
            var IndentAllData = tempData ;

            console.log(IndentAllData);
            if (IndentAllData.length == 0) {
                showerrormsg('Item Rejected Of That Indent...!');
                parent.jQuery.fancybox.close();                
            }
            if (IndentAllData.length > 0) {
                $("#masterheaderid,#mastertopcorner,#btncross,#btnfeedback,#ContentPlaceHolder1_rdoIndentType").hide();
                $(':radio[value="' + IndentAllData[0].IndentType + '"]').attr('checked', 'checked');
                $("#<%=ddlfromlocation.ClientID%>").val(IndentAllData[0].FromLocationID + '#' + IndentAllData[0].FromPanelId);
               
                $("#<%=lblIndentNo.ClientID %>").html(IndentAllData[0].IndentNo);
                setIndentType();

                $('#<%=txtcheckercomment.ClientID%>').val(IndentAllData[0].checkercomment);
                addDataToTable(IndentAllData,'0','Edit');
                $("#<%=txtnarration.ClientID%>").val(IndentAllData[0].Narration);
                $("#<%=txtexpecteddate.ClientID%>").val(IndentAllData[0].ExpectedDateToShow); 
                $("#<%=ddlcategorytype.ClientID%>").val(IndentAllData[0].categorytypeID); 
                
                if (IndentAllData[0].IndentType == "PI") {
                    var TotalRigthsPI = IndentAllData[0].TotalRigthsPI;
                    if (TotalRigthsPI == null) {
                        TotalRigthsPI = '';
                    }
                    var AlreadyActionPerformed = IndentAllData[0].ActionType;                    
                    var IsMakerFound = -1;
                    var IsCheckerFound = -1;
                    var IsApprovalFound = -1;
                    IsMakerFound = TotalRigthsPI.indexOf('Maker');
                    IsCheckerFound = TotalRigthsPI.indexOf('Checker');
                    IsApprovalFound = TotalRigthsPI.indexOf('Approval');
                    if (AlreadyActionPerformed == 'Maker') {                       
                        if (IsMakerFound >= 0) {
                            $('#btnSave').show();
                            $('#btnReject').hide();
                        }
                        if (IsCheckerFound >= 0) {
                            $('#btnCheck,#btnReject').show();
                            $("#spnReject").show();
                            $("#<%=lblFromRights.ClientID %>").html('Checker');
                            $(".checkedQty").prop('readonly', false);

                            $('#<%=txtcheckercomment.ClientID%>').show();
                          
                        }

                        if (IsApprovalFound < 1) {
                          //  $('#btnSave,#btnReset,#btnCheck,#btnApprove,#btnReject').hide();
                        }
                    }
                    else if (AlreadyActionPerformed == 'Checker') {
                        if (IsApprovalFound >= 0) {
                            $('#btnApprove,#btnReject').show();
                            $("#<%=lblFromRights.ClientID %>").html('Approval');
                            $("#txtitem").prop('disabled', true);
                            $("#tblTemp").hide();
                            $("#spnReject").show();
                            $(".ApprovedQuantity").prop('readonly', false);
                            $('#<%=txtcheckercomment.ClientID%>').show();
                        }
                        else {
                            $('#btnSave,#btnReset,#btnCheck,#btnApprove,#btnReject').hide();
                        }
                    }
                    else if (AlreadyActionPerformed == 'Approval') {
                        $('#btnSave,#btnReset,#btnApprove,#btnReject').hide();
                        $("#txtitem").prop('disabled', true);
                        $("#tblTemp").hide();
                    }                   
                }
                else if (IndentAllData[0].IndentType == "SI") {
                    var TotalRigthsSI = IndentAllData[0].TotalRigthsSI;
                    if (TotalRigthsSI == null) {
                        TotalRigthsSI = '';
                    }
                    var AlreadyActionPerformed = IndentAllData[0].ActionType;                    
                    var IsMakerFound=-1;
                    var IsCheckerFound=-1;
                    var IsApprovalFound=-1;
                    IsMakerFound = TotalRigthsSI.indexOf('Maker');
                    IsCheckerFound = TotalRigthsSI.indexOf('Checker');
                    IsApprovalFound = TotalRigthsSI.indexOf('Approval'); 
                    if (AlreadyActionPerformed == 'Maker') {
                        if (IsMakerFound >= 0) {
                           $('#btnSave').show();
                            $('#btnReject').hide();
                        }                        
                        if (IsCheckerFound >= 0) {
                            $('#btnReject,#btnCheck').show();
                            $("#spnReject").show();
                            $("#<%=lblFromRights.ClientID %>").html('Checker');    
                            $(".checkedQty").prop('readonly', false);
                            $('#<%=txtcheckercomment.ClientID%>').show();
                        }
                        if (IsApprovalFound < 1) {
                          //  $('#btnSave,#btnReset,#btnCheck,#btnApprove,#btnReject').hide();
                        }
                    }
                    else if (AlreadyActionPerformed == 'Checker') {
                        if (IsApprovalFound >= 0) {
                            $('#btnApprove,#btnReject').show();
                            $("#<%=lblFromRights.ClientID %>").html('Approval');
                            $("#txtitem").prop('disabled', true);
                            $("#tblTemp").hide();
                            $("#spnReject").show();
                            $(".ApprovedQuantity").prop('readonly', false);
                            $('#<%=txtcheckercomment.ClientID%>').show();
                        }
                        else {
                            $('#btnSave,#btnReset,#btnCheck,#btnApprove,#btnReject').hide();
                        }
                    }
                    else if (AlreadyActionPerformed == 'Approval') {
                        $('#btnSave,#btnReset,#btnApprove,#btnReject').hide();
                        $("#txtitem").prop('disabled', true);
                        $("#tblTemp").hide();
                    }
                }
                else {
                    $('#btnSave,#btnReset,#btnCheck,#btnApprove,#btnReject').hide();
                }
            }
            
        }
        function MakeAction(ButtonActionType) {
            try{

                var RejectionReason = $('#<%=txtRejectionReason.ClientID%>').val();
                if (RejectionReason == '' && ButtonActionType == 'Reject') {
                    showerrormsg('Please Enter Rejection Reason...!');
                    $('#<%=txtRejectionReason.ClientID%>').focus();
                    return;
                }
              
                var store_SaveIndentdetail = getstore_SaveIndentdetail();
                var monthlimit = true;
                var netamount = 0;
                if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "PI") {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {
                        if (ButtonActionType == "Check") {
                            var aa=parseFloat($(this).closest('tr').find('#tdUnitPrice').html()) * parseFloat($(this).closest('tr').find('#txtcheckedQuantity').val());
                            netamount = parseFloat(netamount) + parseFloat(aa);
                        }
                        else if (ButtonActionType == "Approve") {
                            var aa = parseFloat($(this).closest('tr').find('#tdUnitPrice').html()) * parseFloat($(this).closest('tr').find('#txtApprovedQuantity').val());
                            netamount = parseFloat(netamount) + parseFloat(aa);
                        }
                    }
                });


                var total = parseFloat(netamount) + parseFloat($('#<%=lbmonthamount.ClientID%>').html());
                if (parseFloat(total) > parseFloat($('#<%=lbbugetamount.ClientID%>').html())) {

                    if (confirm("Indent Amount Exceed Budget Amount \n Do You Want To Continue?")) {
                        monthlimit = true;

                    }
                    else {
                        monthlimit = false;
                    }
                }
            }
            if (monthlimit == false) {
                return;
            }

            var checkercomment = $('#<%=txtcheckercomment.ClientID%>').val();
           // $.blockUI();

                $.ajax({
                    url: "CreateSalesIndent.aspx/MakeAction",
                    data: JSON.stringify({ store_SaveIndentdetail: store_SaveIndentdetail, ButtonActionType: ButtonActionType, RejectionReason: RejectionReason, checkercomment: checkercomment }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                       // $.unblockUI();
                        if (result.d == 'success') {
                            showmsg('Indent ' + ButtonActionType + ' SuccessFully...!');
                            if (ButtonActionType == 'Reject') {
                                parent.jQuery.fancybox.close();
                            }
                            else {
                              window.parent.searchdata();
                                //parent.jQuery.fancybox.close();
                           
                                location.reload(true);
                            }
                        }
                        else {                        
                            showerrormsg(result.d);
                        }                   
                    },
                    error: function (xhr, status) {                  
                       // $.unblockUI();
                        var err = eval("(" + xhr.responseText + ")");
                        showerrormsg(err.Message);
                    }
                });
            }
            catch(e)
            {
               // $.unblockUI();
            }
        }
    </script>


    <script type="text/javascript">
        var ApplyFormula = '<%=ApplyFormula%>';
        function binditemindentdata(itemid, locationid) {

            $.ajax({
                url: "CreateSalesIndent.aspx/bindoldindentdata",
                data: '{itemid:"' + itemid + '",locationid:"' + locationid + '",IndentType:"' + $("#<%=rdoIndentType.ClientID%>").find(":checked").val() + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                      //  showerrormsg("No Item Found");
                      //  $.unblockUI();


                    }
                    else {

                        $('#<%=lbinhandqty.ClientID%>').html(ItemData[0].InhandQty);
                        $('#<%=lbbufferper.ClientID%>').html(ItemData[0].BufferPercentage);
                        $('#<%=lbavgcon.ClientID%>').html(ItemData[0].AverageConsumption);
                        $('#<%=lbwastper.ClientID%>').html(ItemData[0].WastagePercentage);
                        $('#<%=lbindentpending.ClientID%>').html(ItemData[0].LastPendingQty);
                       


                    }

                },
                error: function (xhr, status) {
                    showerrormsg(xhr.responseText);
                }
            });
        }
        

        function QtyFormula() {

            var InhandQty = $('#<%=lbinhandqty.ClientID%>').html();
            var BufferPercentage = $('#<%=lbbufferper.ClientID%>').html();
            var AverageConsumption = $('#<%=lbavgcon.ClientID%>').html();
            var WastagePercentage = $('#<%=lbwastper.ClientID%>').html();
            var LastPendingQty = $('#<%=lbindentpending.ClientID%>').html();
            var ReqQty = $('#<%=txtQty.ClientID%>').val();


            var bufferamt = (parseInt(AverageConsumption) * parseInt(BufferPercentage)) / 100;
            var wastamt = (parseInt(AverageConsumption) * parseInt(WastagePercentage)) / 100;

            var totalplus = parseInt(AverageConsumption) + parseInt(bufferamt) + parseInt(wastamt);
            var totalminus = parseInt(InhandQty) + parseInt(LastPendingQty);

            var calculatedqty = parseInt(totalplus) - parseInt(totalminus);
           
            if (calculatedqty == 0) {
                return true;
            }

            if (parseFloat(ReqQty) > parseFloat(calculatedqty)) {
                showerrormsg("Maximum Order Qty Should Be :- " + calculatedqty);
                return false;
            }
            return true;

           
        }
    </script>
     <style>
    .w3-btn,.w3-button{border:none;display:inline-block;padding:8px 16px;vertical-align:middle;overflow:hidden;text-decoration:none;color:inherit;background-color:#4CAF50;color: white;text-align:center;cursor:pointer;white-space:nowrap}
.w3-btn:hover{box-shadow:0 8px 16px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19)}

         .auto-style1 {
             color: #FF0066;
         }

    </style>   
</asp:Content>

