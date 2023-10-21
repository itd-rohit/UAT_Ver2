<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="RateTypeMaster.aspx.cs" Inherits="Design_Master_RateTypeMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

 <%: Scripts.Render("~/bundles/MsAjaxJs") %>
 <%: Scripts.Render("~/bundles/Chosen") %>
       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

        <div id="Pbody_box_inventory" >
             <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                           

           </Services>
        </Ajax:ScriptManager>

             <div class="POuter_Box_Inventory" style="text-align:center">
                 <b>Rate Type Master </b>
              <br />
                 <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                 </div>
                 <div class="POuter_Box_Inventory" style="text-align:center">
                 <table style="width: 100%;border-collapse:collapse">
                     <tr>
                                    <td style="text-align: right; width: 14%"><b>Type :&nbsp;</b></td>
                                    <td style="width: 24%;text-align:left">
                                        <asp:DropDownList ID="ddlType" runat="server" Width="190px" class="ddlType chosen-select"  onchange="bindCentre();selectPatientType()">
                                        </asp:DropDownList>
                                       
                                    </td>
                                    <td style="text-align: right; width: 14%">&nbsp; </td>
                                    <td style="width: 20%"> </td>
                                    
                                      
                                    <td style="text-align: right; width: 12%"><b>&nbsp;</b></td>
                                    <td style="width: 16%">&nbsp;</td>
                                </tr>
               <tr>
                   <td style="text-align: right"><b>
                       Centre :&nbsp;</b>
                   </td>
                   <td style="text-align: left" colspan="4">
                       <asp:DropDownList ID="ddlCentre" runat="server" Width="280px"  class="ddlCentre chosen-select" onchange="getRateType()"></asp:DropDownList>
                   </td>
                      
                   
                     <td style="text-align: right">
                       &nbsp;
                   </td>
               </tr>
                     <tr>
   <td style="text-align: right">
   <b>  Rate Type Name :&nbsp;</b>
      </td>
                   <td style="text-align: left" >
                       <asp:TextBox ID="txtRateTypeName" MaxLength="50" AutoCompleteType="Disabled" runat="server" Width="280px" CssClass="requiredField" ></asp:TextBox>
                       </td>
                           <td style="text-align: right; width: 14%"><b>Patient&nbsp;Type&nbsp;:&nbsp;</b> </td>
                                    <td style="width: 20%;text-align: left"> <asp:DropDownList ID="ddlPanelGroup" runat="server" Width="146px">
                                        </asp:DropDownList></td>
                    
                          <td style="text-align: right">
                       &nbsp;
                   </td>
                     <td style="text-align: right">
                       &nbsp;
                   </td>
                     </tr>
                      <tr >
                                    
                                    <td style="text-align: right"><b>Payment&nbsp;Mode&nbsp;:&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:DropDownList ID="ddlPaymentMode" runat="server" Width="146px" onchange="getPaymentCon()" ClientIDMode="Static">
                                            <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                            <asp:ListItem Value="Credit">Credit</asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td style="text-align: right;display:none"><b>Print At Centre :&nbsp;</b></td>
                                     <td style="text-align: left;display:none">

                                        <asp:DropDownList ID="ddlPrintAtCentre" runat="server" ClientIDMode="Static" Width="146px" class="ddlPrintAtCentre chosen-select">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="text-align: right"><b>
                                       Patient Pay To :&nbsp;</b>
                                    </td>
                                     <td style="text-align: left">
                                      <asp:RadioButtonList style="FLOAT: left; font-weight:bold;" ID="rblPatientPayTo" runat="server"  ClientIDMode="Static" RepeatDirection="Horizontal">
                                                     <asp:ListItem Text="Client" Value="Client" Selected="True"></asp:ListItem>
                                                     <asp:ListItem Text="Lab" Value="Lab"></asp:ListItem>
                                                        
                                                         
                                        </asp:RadioButtonList>
                                    </td>
                                </tr>

                                <tr  style="display:none">
                                    <td style="text-align: right"><b>Email&nbsp;Id(Invoice)&nbsp;:&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:TextBox ID="txtEmailInvoice" runat="server" Width="140px"></asp:TextBox></td>
                                    <td style="text-align: right"><b>Email&nbsp;Id(Report)&nbsp;:&nbsp;</b></td>
                                    <td style="text-align: left">
                                        <asp:TextBox ID="txtEmailReport" runat="server" Width="140px"></asp:TextBox></td>
                                    <td style="text-align: right"><b>Report&nbsp;DispatchMode&nbsp;:&nbsp;</b></td>
                                    <td style="text-align: left">
                                        <asp:DropDownList ID="ddlReportDispatchMode" runat="server" ClientIDMode="Static" Width="146px">
                                            <asp:ListItem Value="BOTH">BOTH</asp:ListItem>
                                            <asp:ListItem Value="MAIL">MAIL</asp:ListItem>
                                            <asp:ListItem Value="PRINT">PRINT</asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                      <tr style="display:none">
                                    <td style="text-align: right"><b>Min.&nbsp;Business&nbsp;Commit.&nbsp;:&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:TextBox ID="txtMinBusinessComm" Width="140px" runat="server" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)" ClientIDMode="Static"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbMinBusiness" runat="server" TargetControlID="txtMinBusinessComm" ValidChars=".0123466789"></cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td style="text-align: right"><b>GST TIN :&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:TextBox ID="txtGSTTIN" Width="140px"  runat="server" MaxLength="50"></asp:TextBox></td>
                                    <td style="text-align: right"><b>Invoice&nbsp;Billing&nbsp;Cycle&nbsp;:&nbsp;</b></td>
                                    <td style="text-align: left">
                                        <asp:DropDownList ID="ddlInvoiceBillingCycle" runat="server" Width="146px" ClientIDMode="Static">
                                            <asp:ListItem Text="Weekly" Value="Weekly"></asp:ListItem>
                                            <asp:ListItem Text="15 Days" Value="15 Days"></asp:ListItem>
                                            <asp:ListItem Text="Monthly" Value="Monthly"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr style="display:none">
                                    <td style="text-align: right"><b>Bank Name :&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:DropDownList ID="ddlBankName" runat="server" Width="146px" ClientIDMode="Static" class="ddlBankName chosen-select">
                                        </asp:DropDownList></td>
                                    <td style="text-align: right"><b>Account&nbsp;No.&nbsp;:&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:TextBox ID="txtAccountNo" Width="140px"  runat="server" ClientIDMode="Static" MaxLength="30"></asp:TextBox></td>
                                    <td style="text-align: right"><b>IFSC&nbsp;Code&nbsp;:&nbsp;</b></td>
                                    <td style="text-align: left">
                                        <asp:TextBox ID="txtIFSCCode" Width="140px"  runat="server" ClientIDMode="Static" MaxLength="30"></asp:TextBox></td>
                                </tr>

                                <tr style="display:none">
                                    <td style="text-align: right"><b>Online&nbsp;UserName&nbsp;:&nbsp;</b></td>
                                    <td style="text-align: left">
                                        <asp:TextBox ID="txtOnlineUserName" runat="server" ClientIDMode="Static" MaxLength="30" Width="140px" ></asp:TextBox>
                                    </td>
                                    <td style="text-align: right"><b>Online&nbsp;Password&nbsp;:&nbsp;</b></td>
                                    <td style="text-align: left">
                                        <asp:TextBox ID="txtOnlinePassword" TextMode="Password" runat="server" ClientIDMode="Static" MaxLength="30" Width="140px" ></asp:TextBox></td>
                                    <td style="text-align: right">
                                        <b>Tag&nbsp;Processing&nbsp;Lab&nbsp;:&nbsp; </b></td>
                                    <td style="text-align: left">

                                        <asp:DropDownList ID="ddlTagProcessingLab" runat="server" ClientIDMode="Static" Width="146px" class="ddlTagProcessingLab chosen-select">
                                        </asp:DropDownList>

                                    </td>
                                </tr>

                                <tr >
                                    <td style="text-align: right"><b>Credit&nbsp;Limits&nbsp;:&nbsp;</b></td>
                                     <td style="text-align: left">

                                        <asp:TextBox ID="txtCreditLimit" runat="server" ClientIDMode="Static" Width="140px" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbCreditLimit" runat="server"  ValidChars=".0123456789" TargetControlID="txtCreditLimit" />

                                    </td>
                                    <td style="text-align: right;display:none"><b>Invoice To :&nbsp;</b></td>
                                    <td style="text-align: left;display:none">
                                        <asp:DropDownList ID="ddlInvoiceTo" runat="server"  ToolTip="Select Invoice To" Width="146px" class="ddlInvoiceTo chosen-select">
                                        </asp:DropDownList></td>
                                    <td style="text-align: right">&nbsp;  </td>
                                    <td style="text-align: left">&nbsp;  
                                    </td>
                                </tr>

                                <tr >
                                    <td style="text-align: right"><b>Min&nbsp;Cash&nbsp;in&nbsp;Booking&nbsp;:&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:TextBox ID="txtMinCash" runat="server" Text="0" Width="50px" ClientIDMode="Static" onkeyup="chkMinCash()" onkeypress="return checkForSecondDecimal(this,event)"  />
                                        (In %)
                                            <cc1:FilteredTextBoxExtender ID="ftbMinCash" runat="server" FilterType="Numbers" TargetControlID="txtMinCash" />
                                    </td>
                                    <td style="text-align: right"><b>Referring&nbsp;Rate&nbsp;:&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:DropDownList ID="ddlReferringRate" runat="server" ToolTip="Select Referring Rate of" Width="146px" class="ddlReferringRate chosen-select">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="text-align: right" colspan="2"></td>
                                </tr>
                                <tr style="display:none">
                                <td colspan="3">
                                     <asp:RadioButtonList style="FLOAT: left; font-weight:bold;" ID="Tiretype" runat="server"  ClientIDMode="Static" RepeatDirection="Horizontal">
                                                     <asp:ListItem Text="Tire -1 (Metro City)" Value="Tire-1" Selected="True"></asp:ListItem>
                                                     <asp:ListItem Text="Tire -2 (Cities)" Value="Tire-2"></asp:ListItem>
                                                        <asp:ListItem Text="Tire -3 (Villages)" Value="Tire-3"></asp:ListItem>
                                                         
                                        </asp:RadioButtonList>&nbsp;
                                    </td>
                                    <td> 
                           </td>
                                    <td style="text-align:right;">&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                               <tr style="display:none" >
                                    <td style="text-align: right"><b>Invoice&nbsp;Display&nbsp;Name:&nbsp;</b></td>
                                     <td style="text-align: left">
                                        <asp:TextBox ID="txtInvoiceDisplayName" runat="server" Width="140px"  MaxLength="50"></asp:TextBox>                                       
                                    </td>
                                    <td style="text-align: right"><b>Invoice&nbsp;Display&nbsp;No.&nbsp;:&nbsp;</b></td>
                                    <td style="text-align: left">
                                        <asp:TextBox ID="txtInvoiceDisplayNo" runat="server" maxlength="10" ClientIDMode="Static" Width="140px" ></asp:TextBox>
                                       </td>
                                    <td style="text-align: right"><b>&nbsp;</b>  </td>
                                    <td style="text-align: left">&nbsp;
                                    </td>
                                </tr>
                     <tr>
                                    <td style="text-align: left;display:none" colspan="6">
                                        <b>
                                            <asp:CheckBox ID="chkShowAmtInBooking" ClientIDMode="Static" Checked="true" runat="server" Text="Show Amount In Booking" CssClass="hide" /></b>&nbsp;
                                            <b>
                                                <asp:CheckBox ID="chkReportInterpretation" Checked="true" ClientIDMode="Static" runat="server" Text="Show Report Interpretation" /></b>&nbsp;
                                            <b>
                                                <asp:CheckBox ID="chkHideDisc" ClientIDMode="Static" runat="server" Text="Hide Discount" /></b>&nbsp;
                                          
                                           <span class="Panel"><b>
                                               <asp:CheckBox ID="ChkIsBookingLock" ClientIDMode="Static" runat="server" Text="IsBookingLock" /></b></span>
                                        <span class="Panel"><b>
                                               <asp:CheckBox ID="ChkIsPrintingLock" ClientIDMode="Static" runat="server" Text="IsPrintingLock" /></b></span>
                                        <b>
                                        <asp:CheckBox ID="chkHideReceiptRate" ClientIDMode="Static" runat="server" Text="Hide Receipt Rate" /></b>
                                    </td>




                                </tr>
                     </table>
                 </div>
              <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Save" class="ItDoseButton" id="btnSave" onclick="SaveRateType()" style="font-weight: bold"  />
                   </div>
            </div>

     <script type="text/javascript">
         jQuery(function () {
             getPaymentCon();
             showHide();
             bindtype();
            
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

                 jQuery('#ddlCentre,#ddlBankName').trigger('chosen:updated');
         });
         function bindtype() {
             jQuery('#ddlType option').remove();
             jQuery.ajax({
                 url: "Centremaster.aspx/gettype1",
                 data: '{}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     typedata = jQuery.parseJSON(result.d);
                     for (var a = 0; a <= typedata.length - 1; a++) {
                         jQuery('#ddlType').append(jQuery("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));
                     }


                     jQuery('#ddlType').find('option[value=7]').remove();
                     jQuery('#ddlType').val('1');
                 },
                 error: function (xhr, status) {
                 }
             });
         }
         function getPaymentCon() {
             if (jQuery("#ddlPaymentMode").val() == "Cash") {
                 jQuery("#txtMinCash").removeAttr('disabled');
                 jQuery("#txtCreditLimit").val('0').attr('disabled', 'disabled');

                 jQuery('#<%= rblPatientPayTo.ClientID %> input[type=radio]').removeAttr('disabled');
                 jQuery('#<%= rblPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');

            }
            else {
                 jQuery("#txtMinCash").val('0').attr('disabled', 'disabled');
                 jQuery("#txtCreditLimit").removeAttr('disabled');
                 jQuery('#<%= rblPatientPayTo.ClientID %> input[type=radio]').attr('disabled', 'disabled');
                 jQuery('#<%= rblPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
            }
        }
        function showHide() {
            if (jQuery('#ddlType').val() == '1') {
                jQuery("#ddlPanelGroup").prop('selectedIndex', 2);
            }
            else {
                jQuery("#ddlPanelGroup").prop('selectedIndex', 0);
            }
            
            jQuery("#chkHideDisc,#ChkIsBookingLock,#ChkIsPrintingLock").prop('checked', false);
            
            jQuery("#ddlPaymentMode,#ddlTagProcessingLab,#ddlReportDispatchMode,#ddlInvoiceBillingCycle,#ddlBankName,#ddlPrintAtCentre,#ddlReferringRate,#ddlInvoiceTo").prop('selectedIndex', 0);
            jQuery("#txtEmailInvoice,#txtEmailReport,#txtMinBusinessComm,#txtGSTTIN,#txtAccountNo,#txtIFSCCode,#txtOnlineUserName,#txtOnlinePassword,#txtMinCash,#txtCreditLimit").val('');
            jQuery("#chkShowAmtInBooking,#chkReportInterpretation").prop('checked', true);
            jQuery('#<%= rblPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
        }
         function selectPatientType() {
             if (jQuery("#ddlType option:selected").text() == "PUP") {
                 jQuery("#ddlPanelGroup").val('3');
                 jQuery("#ddlPanelGroup").attr('disabled', 'disabled');

             }
             else if (jQuery("#ddlType option:selected").text() == "HLM") {
                 jQuery("#ddlPanelGroup").val('4');
                 jQuery("#ddlPanelGroup").attr('disabled', 'disabled');

             }
             else {
                 jQuery("#ddlPanelGroup").prop('selectedIndex', 0).attr('disabled', false);
             }

         }
          </script>
    <script type="text/javascript">
        jQuery(function () {
            bindCentre();
            selectPatientType();
        });
        function bindCentre() {
            jQuery("#txtRateTypeName").val('');
            PageMethods.bindCentre($("#ddlType").val(), onSucessCentre, onFailureCentre);
        }
        function onSucessCentre(result) {
            var CentreData = jQuery.parseJSON(result);
            jQuery('#ddlCentre').empty();
            if (CentreData != null) {
                jQuery("#ddlCentre").append(jQuery("<option></option>").val("0").html("Select"));

                for (i = 0; i < CentreData.length; i++) {
                    jQuery("#ddlCentre").append(jQuery("<option></option>").val(CentreData[i].CentreID).html(CentreData[i].Centre));
                }
            }
            jQuery('#ddlCentre').trigger('chosen:updated');
        }
        function onFailureCentre() {

        }

         </script>

    <script type="text/javascript">
        function panelMaster() {
            var dataPanel = new Array();
            var objPanel = new Object();

            objPanel.Company_Name = jQuery.trim(jQuery("#<%=txtRateTypeName.ClientID %>").val()); 
            objPanel.CentreID = jQuery.trim(jQuery("#<%=ddlCentre.ClientID %>").val().split('#')[0]); 
            objPanel.PanelGroup = jQuery("#<%=ddlPanelGroup.ClientID %> option:selected").text();
            objPanel.PanelGroupID = jQuery("#<%=ddlPanelGroup.ClientID %>").val();
            objPanel.TypeID = jQuery.trim(jQuery("#<%=ddlType.ClientID %>").val()); 
            objPanel.Payment_Mode = jQuery.trim(jQuery("#<%=ddlPaymentMode.ClientID %>").val());
            objPanel.PrintAtCentre = jQuery("#<%=ddlPrintAtCentre.ClientID %>").val();
            if (jQuery.trim(jQuery("#<%=ddlPaymentMode.ClientID %>").val()) == "Credit")
                objPanel.PatientPayTo = "Client";
            else
                objPanel.PatientPayTo = $('#rblPatientPayTo input[type=radio]:checked').val();
            objPanel.EmailID = jQuery.trim(jQuery("#<%=txtEmailInvoice.ClientID %>").val());
            objPanel.EmailIDReport = jQuery("#<%=txtEmailReport.ClientID %>").val();
            objPanel.ReportDispatchMode = jQuery("#<%=ddlReportDispatchMode.ClientID %>").val();
            if (jQuery("#<%=txtMinBusinessComm.ClientID %>").val() != "")
                objPanel.MinBusinessCommitment = jQuery("#<%=txtMinBusinessComm.ClientID %>").val();
             else
                objPanel.MinBusinessCommitment = 0;
            objPanel.GSTTin = jQuery("#<%=txtGSTTIN.ClientID %>").val();
            objPanel.InvoiceBillingCycle = jQuery("#<%=ddlInvoiceBillingCycle.ClientID %>").val();
            if (jQuery("#<%=ddlBankName.ClientID %>").val() != "0") {
                objPanel.BankName = jQuery("#<%=ddlBankName.ClientID %> option:selected").text();
                  objPanel.BankID = jQuery("#<%=ddlBankName.ClientID %>").val();
              }
              else {
                  objPanel.BankName = "";
                  objPanel.BankID = 0;
              }
              objPanel.AccountNo = jQuery.trim(jQuery("#<%=txtAccountNo.ClientID %>").val());
            objPanel.IFSCCode = jQuery.trim(jQuery("#<%=txtIFSCCode.ClientID %>").val());
            objPanel.PanelUserID = jQuery.trim(jQuery("#<%=txtOnlineUserName.ClientID %>").val());
            objPanel.PanelPassword = jQuery("#<%=txtOnlinePassword.ClientID %>").val();


             objPanel.TagProcessingLabID = jQuery("#<%=ddlTagProcessingLab.ClientID %>").val();

             if (jQuery("#<%=ddlTagProcessingLab.ClientID %> option:selected").text() == "Self")
                 objPanel.TagProcessingLab = jQuery("#<%=ddlTagProcessingLab.ClientID %> option:selected").text();
            else if (jQuery("#<%=ddlTagProcessingLab.ClientID %>").val() != "0")
                objPanel.TagProcessingLab = jQuery("#<%=ddlTagProcessingLab.ClientID %> option:selected").text();
            else
                objPanel.TagProcessingLab = "";
            
            objPanel.CreditLimit = jQuery.trim(jQuery("#<%=txtCreditLimit.ClientID %>").val());
            objPanel.InvoiceTo = jQuery("#<%=ddlInvoiceTo.ClientID %>").val();
            if (jQuery("#<%=txtMinCash.ClientID %>").val() != "")
                objPanel.MinBalReceive = jQuery("#<%=txtMinCash.ClientID %>").val();
             else
                 objPanel.MinBalReceive = 0;
                                  
             objPanel.ReferenceCode = jQuery("#<%=ddlReferringRate.ClientID %>").val();
             objPanel.ReferenceCodeOPD = jQuery("#<%=ddlReferringRate.ClientID %>").val();
            
            objPanel.Tiretype = $("#Tiretype input[type=radio]:checked").val();
            if ($("#rblCentreSelection input[type=radio]:checked").val() == "FOCO") {
                objPanel.IsInvoice = 1;
                objPanel.InvoiceDisplayName = jQuery.trim(jQuery("#txtInvoiceDisplayName").val());
                objPanel.InvoiceDisplayNo = jQuery.trim(jQuery("#txtInvoiceDisplayNo").val());
            }
            else {
                objPanel.IsInvoice = 0;
                objPanel.InvoiceDisplayName = "";
                objPanel.InvoiceDisplayNo = "";
            }


            
             objPanel.ShowAmtInBooking = jQuery("#<%=chkShowAmtInBooking.ClientID%>").is(':checked') ? 1 : 0;
             objPanel.ReportInterpretation = jQuery("#<%=chkReportInterpretation.ClientID%>").is(':checked') ? 1 : 0;
             objPanel.HideDiscount = jQuery("#<%=chkHideDisc.ClientID%>").is(':checked') ? 1 : 0;
             objPanel.IsBookingLock = jQuery("#<%=ChkIsBookingLock.ClientID%>").is(':checked') ? 1 : 0;
             objPanel.IsPrintingLock = jQuery("#<%=ChkIsPrintingLock.ClientID%>").is(':checked') ? 1 : 0;

             objPanel.SecurityDeposit = 0;
             

             objPanel.HideReceiptRate = jQuery("#<%=chkHideReceiptRate.ClientID%>").is(':checked') ? 1 : 0;                                  
            dataPanel.push(objPanel);
            return dataPanel;
        }
    </script>
    <script type="text/javascript">
        function SaveRateType() {         
            if (ValidateRateType() == "1") {
                return;
            }
            jQuery('#btnSave').attr('disabled', true).val("Submitting...");
            var resultPanel = panelMaster();
            jQuery.ajax({
                url: "RateTypeMaster.aspx/saveRateType",
                data: JSON.stringify({ RateType: resultPanel }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "2") {
                        alert("Rate Type Name Already Exist");
                    }
                    else if (result.d == "1") {
                        alert("Record Saved Successfully");
                        jQuery('#btnSave').attr('disabled', false).val("Save");
                        clearform();
                       
                    }
                    else {
                        alert('Error...');
                    }
                    jQuery('#btnSave').attr('disabled', false).val("Save");
                },
                error: function (xhr, status) {
                    jQuery('#btnSave').attr('disabled', false).val("Save");
                }
            });
        }
        function ValidateRateType() {
            var con = 0;
            jQuery('#<%=lblMsg.ClientID%>').html('');

            
            if (jQuery.trim($('#<%=ddlCentre.ClientID%>').val()) == 0) {
                $('#<%=lblMsg.ClientID%>').html('Please Select Centre');
                $('#<%=ddlCentre.ClientID%>').focus();
                con = 1;
                return con;

            }

            if (jQuery.trim($('#<%=txtRateTypeName.ClientID%>').val()) == "") {
                $('#<%=lblMsg.ClientID%>').html('Please Enter Rate Type Name');
                $('#<%=txtRateTypeName.ClientID%>').focus();
                con = 1;
                return con;

            }
            if ((jQuery('#ddlType1option:selected').text() == "PUP" || (jQuery('#ddlType1option:selected').text() == "PCC")) && (jQuery('#ddlTagProcessingLab option:selected').text() == "Select")) {
                jQuery('#<%=lblMsg.ClientID%>').html('Please Select TagProcessing Lab');
                jQuery('#ddlTagProcessingLab').focus();
                con = 1;
                return con;
            }
            if ((jQuery('#ddlType1option:selected').text() == "HLM" || jQuery('#ddlType1option:selected').text() == "PCC")) {
                if (jQuery.trim($("#txtIFSCCode").val()) == "") {
                    jQuery('#<%=lblMsg.ClientID%>').html('Please Enter IFSC Code');
                    jQuery('#txtIFSCCode').focus();
                    con = 1;
                    return con;
                }

            }

        }
        function clearform() {
            jQuery('#<%=ddlType.ClientID%>').val('1');
            jQuery('#ddlCentre').empty();
            jQuery('#ddlType,#ddlCentre').trigger('chosen:updated');
            jQuery('#ddlPaymentMode,#ddlPrintAtCentre').prop('selectedIndex', 0);
            
            jQuery('#<%= rblPatientPayTo.ClientID %> input[value="Client"]').prop('checked', 'checked');
            jQuery('#<%= rblPatientPayTo.ClientID %> input[type=radio]').removeAttr('disabled');
            
            jQuery('#ddlReportDispatchMode,#ddlInvoiceBillingCycle,#ddlBankName,#dlTagProcessingLab,#ddlInvoiceTo,#ddlReferringRate').prop('selectedIndex', 0);
           

            jQuery('#ddlPrintAtCentre,#ddlReportDispatchMode,#ddlInvoiceBillingCycle,#ddlBankName,#dlTagProcessingLab,#ddlInvoiceTo,#ddlReferringRate').trigger('chosen:updated');

            jQuery('#txtRateTypeName,#txtEmailInvoice,#txtEmailReport,#txtMinBusinessComm,#txtGSTTIN,#txtOnlineUserName,#txtOnlinePassword,#txtCreditLimit,#txtMinCash,#txtInvoiceDisplayName,#txtInvoiceDisplayNo').val('');
            jQuery('#chkHideDisc,#chkIsBookingLock,#chkHideReceiptRate,#ChkIsPrintingLock').prop('checked', false);
            jQuery("#chkShowAmtInBooking,#chkReportInterpretation").prop('checked', true);
            jQuery('#ddlInvoiceTo,#ddlReferringRate,#ddlTagProcessingLab').empty();
            jQuery('#ddlInvoiceTo,#ddlReferringRate,#ddlTagProcessingLab').trigger('chosen:updated');

            bindCentre();
        }
        function getRateType() {
            jQuery('#ddlInvoiceTo,#ddlReferringRate,#ddlTagProcessingLab').empty();
            jQuery('#ddlInvoiceTo,#ddlReferringRate,#ddlTagProcessingLab').trigger('chosen:updated');
            if (jQuery("#ddlCentre").val() == 0) {
                jQuery("#txtRateTypeName").val('');               
            }
            else {
                jQuery("#txtRateTypeName").val(jQuery("#ddlCentre option:selected").text().split('~')[1]);
                jQuery("#ddlTagProcessingLab").append(jQuery("<option></option>").val("0").html("SELF"));
                jQuery("#ddlTagProcessingLab").append(jQuery("<option></option>").val(jQuery("#ddlCentre").val().split('#')[0]).html(jQuery("#ddlCentre option:selected").text().split('~')[1]));
                jQuery('#ddlTagProcessingLab').trigger('chosen:updated');
                bindReferringRate();
            }
        }

        function bindReferringRate() {
            if ($("#ddlCentre").val() != 0)
                PageMethods.bindReferringRate($("#ddlCentre").val().split('#')[1], onSucessRefferRate, onFailureRefferRate);
        }
        function onSucessRefferRate(result) {
            var RefferRate = jQuery.parseJSON(result);
            jQuery('#ddlInvoiceTo,#ddlReferringRate').empty();
            if (RefferRate != null) {
              //  jQuery("#ddlInvoiceTo,#ddlReferringRate").append(jQuery("<option></option>").val("0").html("SELF"));
                jQuery("#ddlReferringRate").append(jQuery("<option></option>").val("0").html("SELF"));
                for (i = 0; i < RefferRate.length; i++) {
                    jQuery("#ddlInvoiceTo").append(jQuery("<option></option>").val(RefferRate[i].Panel_ID).html(RefferRate[i].Company_Name));
                    jQuery("#ddlReferringRate").append(jQuery("<option></option>").val(RefferRate[i].Panel_ID).html(RefferRate[i].Company_Name));
                }
            }
            jQuery('#ddlInvoiceTo,#ddlReferringRate').trigger('chosen:updated');
        }
        function onFailureRefferRate() {

        }
    </script>
</asp:Content>

