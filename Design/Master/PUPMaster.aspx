<%@ Page ClientIDMode="Static" Language="C#"  EnableEventValidation="false"  MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PUPMaster.aspx.cs" Inherits="Design_Master_PUPMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/PostReportScript") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <b>Panel Master<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:Label ID="lblEnrollID" runat="server" Style="display: none" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">
            <div class="Purchaseheader">
                Manage PUP
            </div>

            <div class="row">
                <div class="col-md-6">
                    <fieldset style="vertical-align: top">
                        <legend style="font-weight: bold; vertical-align: top">Search Centre</legend>
                        <div class="row">
                            <div class="col-md-24 ">
                                <asp:HiddenField runat="server" ID="hdfempid" />
                                <asp:TextBox ID="txtSearch" runat="server" OnKeyUp="Click(this);" placeholder="Search Centre"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-24">
                                <asp:ListBox ID="listPUP" runat="server" class="navList" onChange="loadDetail(this.value);"
                                    Height="400px"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24" style="text-align: center">
                                <input type="button" value="Export To Excel" onclick="getExcelData();" />
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="col-md-18" style="margin-left: -16px;">
                    <fieldset style="vertical-align: top;">
                        <legend style="font-weight: bold">
                            <input id="chkNewInv" type="checkbox" checked="checked" />
                            Create New PUP</legend>
                        <div class="row">
                            <div class="col-md-4 ">
                                <label class="pull-left">Type   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlType1" runat="server" onchange="selectPatientType()">
                                </asp:DropDownList>

                                <asp:Label ID="lblPanelID" runat="server" Style="display: none;"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Patient Type  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 ">
                                <asp:DropDownList ID="ddlPanelGroup" onchange="ChangePUP();" runat="server">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">PUP Name  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtPUPName" MaxLength="50" CssClass="requiredField" runat="server" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">PUP Code</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 ">
                                <asp:TextBox ID="txtPUPCode" runat="server" MaxLength="10"></asp:TextBox>
                            </div>
                            <div class="col-md-4 ">
                                <asp:CheckBox ID="chkemp" runat="server" Text="Panel Login" Style="font-weight: 700" />
                            </div>
                            <div class="col-md-4">
                                <asp:CheckBox ID="isActive" ForeColor="Red" runat="server" Text="Active" Style="font-weight: 700" Checked="true" />
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="Purchaseheader">
                                    Address Detail
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Address</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAddress" MaxLength="50" CssClass="requiredField" runat="server" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">LandLine No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtLandline" runat="server" MaxLength="10"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftblandline" runat="server" TargetControlID="txtLandline" FilterType="Numbers"></cc1:FilteredTextBoxExtender>

                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Mobile No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtMobile" runat="server" MaxLength="10"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </div>


                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Country</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlCountry" runat="server" CssClass="requiredField" onchange="$onCountryChange()">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Business Zone</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="$onBusinessZoneChange(this.value)" CssClass="requiredField">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">State</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlState"  onchange="$onStateChange(this.value)"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">City</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlCity" runat="server" onchange="$onCityChange(this.value)" >
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">City Zone</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlZone" runat="server" onchange="$onZoneChange(this.value)" >
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Locality</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlLocality" runat="server" >
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="Purchaseheader">
                                    Type
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Payment Mode</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlPaymentMode" runat="server" onchange="getPaymentCon();chkRollindAdvance();">
                                    <asp:ListItem Value="Cash">Cash</asp:ListItem>
                                    <asp:ListItem Value="Credit">Credit</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Print At Centre</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="text-align: left">
                                <asp:DropDownList ID="ddlPrintAtCentre" runat="server">
                                </asp:DropDownList>
                            </div>
				 <div class="col-md-5">
                     
					 <button  onclick="$showManualDocumentMaster()" id="btnMaualDocument" type="button" style="width:100%" ><span id="spnDocumentMaualCounts"  class="badge badge-grey"></span><b>Client Document Upload</b> </button>					
				 <%--<button onclick="$showManualDocumentMaster()" id="Button1" type="button" style="width:100%" ><span id="Span1"  class="badge badge-grey"></span><b>Manual Upload</b> </button>					
				--%>
                      
			 </div>	
                               <div id="divDocumentMaualMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 50%;">
			<div class="modal-header">
                <div class="row">
                          <div class="col-md-12" style="text-align:left">
                             <h4 class="modal-title">Documents Manual Upload</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
			Press esc or click<button type="button" class="closeModel" onclick="$closePatientManualDocModel()" aria-hidden="true">&times;</button>to close</span></em></div>
                         </div>								
			</div>
			<div class="modal-body">
                <div class="row">
						 <div class="col-md-5">
                             <label class="pull-left">Document Type</label>
                    <b class="pull-right">:</b>
                             </div>
                    <div class="col-md-19">
                         <select id="ddlDocumentType" style="width:60%" class="requiredField"></select>
                         </div>
                     </div>
                <div class="row">
						 <div class="col-md-5">
                              <label class="pull-left">Select File</label>
                    <b class="pull-right">:</b>
                             </div>
                     <div class="col-md-15">
                         <input type="file" id="fileManualUpload" class="custom-file-input"/>
                         </div>
                     <div class="col-md-4">
                         <input type="button" id="btnMaualUpload" value="Upload Files" onclick="$saveMaualDocument()" /> 
                         </div>
                    </div>
                <div class="row">
                    <div class="col-md-24">
                <progress id="fileProgress" style="display: none" max="100" value="50" data-label="50% Complete">
                    <span class="value" style="width:50%;"></span>
                </progress>
                        </div>
                    </div>
                 <div class="row">
                      <div class="col-md-24">
                          <em><span style="color: #0000ff; font-size: 9.5pt">1. (Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed)</span></em>
                          </div>
                    </div>
                <div class="row">
                    <div class="col-md-24">
                        <em><span style="color: #0000ff; font-size: 9.5pt">2. Maximum file size upto 10 MB.</span></em>
                         </div>
                    </div>
				
                <div id="divManualUpload" style="overflow:auto">							  
							</div>   
                 <div class="row">
                    <div class="col-md-24">            
                            <table id="tblMaualDocument"  border="1" style="border-collapse: collapse;" class="GridViewStyle">
							<thead>
								<tr id="trManualDocument">
                                    <th class="GridViewHeaderStyle" >&nbsp;</th>	
					                <th class="GridViewHeaderStyle" >Document Type</th>	
                                    <th class="GridViewHeaderStyle" >Document Name</th>	
                                    <th class="GridViewHeaderStyle" >Uploaded By</th>
                                    <th class="GridViewHeaderStyle" >Date</th>
                                    <th class="GridViewHeaderStyle" >View</th>									
								</tr>
							</thead>
							<tbody></tbody>
						</table>
                        </div>
                    </div>
			</div>			
		</div>
	</div>
</div>   
                        
                <asp:HiddenField ID="hdnProjectName" runat="server" />
            </div>
                       
                        <div class="row">
                             <div class="col-md-4" >
                                <label class="pull-left">Security Amount</label>
                                 <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" >
                                <asp:TextBox ID="txtMRPPercentage" visible="false" runat="server" Text="0" onkeyup="chkMRPPercentage()" onkeypress="return checkForSecondDecimal(this,event)" />
                                <cc1:FilteredTextBoxExtender ID="ftbMRPPercentage" runat="server" ValidChars=".0123456789" TargetControlID="txtMRPPercentage" />
                                <asp:TextBox ID="txtSecurityAmt" runat="server" Text="0"  MaxLength="10" />
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" ValidChars="0123456789" TargetControlID="txtSecurityAmt" />
                                
                            </div>
                            <div class="col-md-4" >
                                <label class="pull-left">Security Remark</label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4" >
                                <asp:TextBox ID="txtsecremark"  runat="server" MaxLength="300" />
                                </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4 RollingAdvance">
                                <label class="pull-left RollingAdvance">Rolling Advance</label>
                                <b class="pull-right RollingAdvance">:</b>
                            </div>
                            <div class="col-md-4 RollingAdvance" style="text-align: left">
                                <asp:CheckBox ID="chkRollingAdvance" runat="server" />
                            </div>
						</div>
						<div class="row Panel">
                            
                            <div class="col-md-4">
                                <label class="pull-left">Intimation Limit </label>
                                <b class="pull-right">:</b>
                            </div>
                           
                          <%--  <div class="col-md-2"></div>--%>
                            <div  style="display:none;" class="col-md-2">
                                <asp:DropDownList ID="ddlCreditLimitIntimation" runat="server">
                                    <asp:ListItem Text="-" Value="+"></asp:ListItem>
                                    <asp:ListItem Text="+" Value="-" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtCreditLimitIntimation" runat="server" MaxLength="8" AutoCompleteType="Disabled" onkeyup="chkIntimationLock()"></asp:TextBox> 
                                 <cc1:FilteredTextBoxExtender ID="ftbCreditLimitIntimation" runat="server" ValidChars="0123456789" TargetControlID="txtCreditLimitIntimation" /> 

                            </div>
                               <div class="col-md-2"></div>
                            <div class="col-md-4">
                               
                                <label class="pull-left">Reporting/Credit Limit</label>
                                <b class="pull-right">:</b>
                            </div>
                           <%--  <div class="col-md-2"></div>--%>
                             <div style="display:none;" class="col-md-2">
                                 <asp:DropDownList ID="ddlLabreportlimit"  runat="server">
                                    <asp:ListItem Text="-" Value="+"></asp:ListItem>
                                    <asp:ListItem Text="+" Value="-" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
							 <div class="col-md-2">
                                <asp:TextBox ID="txtLabreportlimit" runat="server" MaxLength="8" AutoCompleteType="Disabled" onkeyup="chkReportingLock()"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftCreditLimitReporting" runat="server" ValidChars="0123456789" TargetControlID="txtLabreportlimit" />
                            </div>
                             <div class="col-md-2"></div>
                             <div class="col-md-4">
                               
                                <label class="pull-left">Booking Limit</label>
                                <b class="pull-right">:</b>
                            </div>
                           <%-- <div class="col-md-2"></div>--%>
							<div  style="display:none;" class="col-md-2">
                                
								 <asp:DropDownList ID="ddlCreditLimit" runat="server">
                                    <asp:ListItem Text="-" Value="+"></asp:ListItem>
                                    <asp:ListItem Text="+" Value="-" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                 <asp:TextBox ID="txtCreditLimit" runat="server" MaxLength="8" AutoCompleteType="Disabled" onkeyup="chkBookingLock()"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbCreditLimit" runat="server" ValidChars="0123456789" TargetControlID="txtCreditLimit" />

                            </div>
                           
                        </div>
                        <div class="row Panel">
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                                <asp:CheckBox ID="chkIntimation" runat="server" Text="Show Intimation" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                                <asp:CheckBox ID="ChkIsPrintingLock" runat="server" Text="IsPrintingLock" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                                <asp:CheckBox ID="ChkIsBookingLock" runat="server" Text="IsBookingLock" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Email Id(Invoice)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmailInvoice"   MaxLength="70"   runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Email Id(Report)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmailReport" MaxLength="70" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Report&nbsp;DispatchMode</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlReportDispatchMode" runat="server">
                                    <asp:ListItem Value="BOTH">BOTH</asp:ListItem>
                                    <asp:ListItem Value="MAIL">MAIL</asp:ListItem>
                                    <asp:ListItem Value="PRINT">PRINT</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Min Business Com.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtMinBusinessComm" runat="server" MaxLength="10" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbMinBusiness" runat="server" TargetControlID="txtMinBusinessComm" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">GST TIN</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtGSTTIN" runat="server" MaxLength="15"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Invoice Billing Cycle</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlInvoiceBillingCycle" runat="server">
                                    <asp:ListItem Text="Weekly" Value="Weekly"></asp:ListItem>
                                    <asp:ListItem Text="15 Days" Value="15 Days"></asp:ListItem>
                                    <asp:ListItem Text="Monthly" Value="Monthly" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Bank Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlBankName" runat="server">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Account No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtAccountNo" runat="server" MaxLength="18" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">IFSC Code</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtIFSCCode" runat="server" MaxLength="11" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Online UserName</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtOnlineUserName" runat="server" MaxLength="30"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Online Password</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtOnlinePassword" TextMode="Password" runat="server" MaxLength="30" Width="140px"></asp:TextBox>
                                 <span id="ShowHidePassword" title="Click to Show Password" class="dvShowHidePassword hint--top hint--bounce hint--rounded"
                                    data-hint="Hide" onclick="ShowHidePassword(this.id);"><i class="icon icon-eye-slash"></i>
                                </span>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Tag&nbsp;Processing&nbsp;Lab </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlTagProcessingLab" runat="server" CssClass="requiredField">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Tag&nbsp;Business&nbsp;Unit</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlTagBusinessLab" runat="server" CssClass="requiredField">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Rcpt/TRF/DeptSlip</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="text-align: left;">
                                <asp:ListBox ID="lstReportsOption" Width="160px" runat="server" ClientIDMode="Static" CssClass="multiselect" SelectionMode="Multiple">
                                    <asp:ListItem Value="1">TRF</asp:ListItem>
                                    <asp:ListItem Value="2">Receipt</asp:ListItem>
                                    <asp:ListItem Value="3">Department Slip</asp:ListItem>
                                    <asp:ListItem Value="4">FullyPaid</asp:ListItem>
                                    <asp:ListItem Value="5">TRF  Barcode</asp:ListItem>
                                </asp:ListBox>
                            </div>
                            <div class="col-md-4" style="display: none;">
                                <label class="pull-left">Tag&nbsp;HUB</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="display:none;"><asp:DropDownList ID="ddlHUB" runat="server">
                                </asp:DropDownList></div>
                        </div>
                        <div class="row">
                           
                            <div class="col-md-4">
                                <label class="pull-left">Invoice To</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlInvoiceTo" runat="server" ToolTip="Select Invoice To">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Invoice&nbsp;DisplayName</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtInvoiceDisplayName" runat="server" MaxLength="50"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Other Lab Ref No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:CheckBox ID="chkOtherLabRefNo" runat="server" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Invoice&nbsp;Disp.&nbsp;No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtInvoiceDisplayNo" runat="server" MaxLength="10"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">PROMaping</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlPro" runat="server" ToolTip="Select ProMaping To">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Sales Manager</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlSalesManager" runat="server"></asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Min&nbsp;Cash&nbsp;Booking</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtMinCash" runat="server" Text="0" onkeyup="chkMinCash()" onkeypress="return checkForSecondDecimal(this,event)" />
                                <cc1:FilteredTextBoxExtender ID="ftbMinCash" runat="server" FilterType="Numbers" TargetControlID="txtMinCash" />
                            </div>
                            <div class="col-md-2">
                                (In %)
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Patient&nbsp;Net&nbsp;Rate</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlReferringRate" runat="server" ToolTip="Select Referring Rate of">
                                </asp:DropDownList>
                            </div>
                             <div class="col-md-4">
                                <label class="pull-left">Allow Doctor Share</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                   <asp:CheckBox ID="chkAllowDoctorShare" Checked="true" runat="server" />
                                 <asp:Label ID="lblFileName" runat="server" Style="display: none;"></asp:Label>
                                        <span style="font-weight: bold;"><a href="javascript:void(0)" id="spnAttachmentCon" onclick="showuploadbox()" style="color: blue;"></a></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Creation Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtcreationdt" runat="server"  placeholder="DD-MM-YYYY" ReadOnly="true" runat="server" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">PAN Card No</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtpancard" MaxLength="10" runat="server" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Name As PAN Card</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtpancardname" MaxLength="50" runat="server" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">BarCode Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlBarCodePrintedType" class="requiredField" onchange="$chkBarCodeType()">
                                    <option id="0">Select</option>
                                    <option id="System">System</option>
                                    <option id="PrePrinted">PrePrinted</option>
                                </select>
                            </div>
                            <div class="col-md-4 clBarcodeType" style="display: none">
                                <label class="pull-left">SetOf BarCode</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 clBarcodeType" style="display: none">
                                <select id="ddlSetOfBarCode" class="requiredField">
                                    <option id="Option1">Select</option>
                                    <option id="SampleType">SampleType</option>
                                    <option id="Sequence">Sequence</option>
                                </select>
                            </div>
                            <%--<div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>--%>
                            <div class="col-md-7" style="text-align: left">
                                <asp:CheckBox ID="chkSampleRecollectAfterReject" Checked="true" runat="server" Text="Sample ReCollect After Reject" />
                            </div>
                            <div class="col-md-5" style="text-align: left">
                                <asp:CheckBox ID="chkshowBalanceAmt" Checked="true" runat="server" Text="Show Balance Amount" />
                            </div>
                            <div class="col-md-4" style="text-align: left">
                                <asp:CheckBox ID="chksharing" Checked="true" runat="server" Text="Allow Sharing" />
                            </div>
                            
                        </div>
                        <div class="row InvoiceCreated" style="display:none">
                            <div class="col-md-4">
                                <label class="pull-left">Invoice Created On</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlnvoiceCreatedOn" class="requiredField"  onchange="GetInvoiceType()">
                                    <option value="0">Select</option>
                                    <option value="1">Patient Wise</option>
                                    <option value="2">Monthly Invoice</option>
                                </select>
                            </div>
                            <div class="col-md-4 clsinvoiceHide" style="display: none;margin-left:5px">
                                <select id="ddlInvoiceType" class="requiredField">
                                    <option value="0">Select</option>
                                    <option value="1">Against Invoice</option>
                                    <option value="2">Advance Payment</option>
                                </select>
                            </div>
                        </div>
                        <div class="row clBarcodeType" style="display: none">
                            <div class="col-md-8">
                                <asp:CheckBox ID="chkBarcodePrintedCentreType" runat="server" Text="Barcode Printed Centre Visit" />
                            </div>
                            <div class="col-md-8">
                                <asp:CheckBox ID="chkBarcodePrintedHomeCollectionType" runat="server" Text="Barcode Printed Homecollection Visit" />
                            </div>
                            <div class="col-md-8">
                                <asp:CheckBox ID="chkSampleCollectionOnReg" runat="server" Text="Sample Collection On Registration" />
                            </div>
                        </div>
                        <div class="row" style="display: none" id="trPermanentClose">
                            <div class="col-md-4">
                                <label class="pull-left">Permanent Close</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4" style="text-align: left">
                                <asp:CheckBox ID="chkPermanentClose" runat="server" onclick="PermanentClose()" />
                            </div>
                            <div class="col-md-4 clPermanentClose" style="display: none">
                                <label class="pull-left">Per. Close Date</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4 clPermanentClose" style="display: none">
                                <asp:TextBox ID="txtPermanentCloseDate" runat="server" Width="110px"></asp:TextBox>
                                <cc1:CalendarExtender ID="calPermanentClose" runat="server" TargetControlID="txtPermanentCloseDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"></label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-4"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <asp:CheckBox ID="chkHideReceiptRate" ClientIDMode="Static" runat="server" Text="Hide Receipt Rate" />
                            </div>
                            <div class="col-md-6">
                                <asp:CheckBox ID="chkShowAmtInBooking" Checked="true" runat="server" Text="Hide Amount In Booking" CssClass="hide" />
                            </div>
                            <div class="col-md-6">
                                <%--<asp:CheckBox ID="ChkIsBookingLock" ClientIDMode="Static" runat="server" Text="IsBookingLock" />--%>
                            </div>
                            <div class="col-md-6">
                                <%--<asp:CheckBox ID="ChkIsPrintingLock" ClientIDMode="Static" runat="server" Text="IsPrintingLock" />--%>
                            </div>
                        </div>

                    </fieldset>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" style="margin-left: -190px; width: 100px; margin-top: 7px" id="btnSave" class="ItDoseButton" value="Save" onclick="$savePUP(this);" />
            <input type="button" style="margin-left: -190px; width: 100px; margin-top: 7px; display: none" id="btnUpdate" class="ItDoseButton" value="Update" onclick="$updatePUP(this);" />
            <input type="button" style="width: 100px; margin-top: 7px" value="Cancel" onclick="clearForm()" class="resetbutton" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div id="centreControl" style="width: 99%; display: none;">
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
 &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <input type="button" value="Report Letter Head" class="itdosebtntab" onclick="openme('AddReportLetterHead')" style="font-weight: bold" />
                <input type="button" value="Add Document" class="itdosebtntab" onclick="openme('AddDocument')" style="font-weight: bold" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var $DocumentID = [];
        $(function () {
            $('[id*=lstReportsOption]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $bindCountry(function (callback) {
                $bindBusinessZone();
            });
			 jQuery("#chkRollingAdvance").click(function () {
                    if (jQuery("#chkRollingAdvance").is(':checked') && jQuery("#chkNewInv").is(':checked')) {
                        jQuery("#txtCreditLimitIntimation,#txtLabreportlimit,#txtCreditLimit").val('0');
                    }
                });
        });


        jQuery("#txtAccountNo").on("blur", function () {
         //   debugger;
            if (jQuery('#txtAccountNo').val().length > 0) {
                var filter = /[\!\@\#\$\%\^\&\*\)\(\+\=\.\<\>\{\}\[\]\:\;\'\"\|\~\`\_\-]/g;
                if (filter.test(jQuery('#txtAccountNo').val())) {
                    toast("Error", 'Account No is INVALID', '');
                    jQuery('#txtAccountNo').focus();
                    return false;
                }
            }
        });



        jQuery("#txtIFSCCode").on("blur", function () {
            //   debugger;
            if (jQuery('#txtIFSCCode').val().length > 0) {
                var filter = /[\!\@\#\$\%\^\&\*\)\(\+\=\.\<\>\{\}\[\]\:\;\'\"\|\~\`\_\-]/g;
                if (filter.test(jQuery('#txtIFSCCode').val())) {
                    toast("Error", 'IFSC Code is INVALID', '');
                    jQuery('#txtIFSCCode').focus();
                    return false;
                }
            }
        });


        jQuery("#txtGSTTIN").on("blur", function () {
            //   debugger;
            if (jQuery('#txtGSTTIN').val().length > 0) {
                var filter = /[\!\@\#\$\%\^\&\*\)\(\+\=\.\<\>\{\}\[\]\:\;\'\"\|\~\`\_\-]/g;
                if (filter.test(jQuery('#txtGSTTIN').val())) {
                    toast("Error", 'GST No is INVALID', '');
                    jQuery('#txtGSTTIN').focus();
                    return false;
                }
            }
        });


        




        var $bindCountry = function (callback) {
            var $ddlCountry = jQuery('#ddlCountry');
            serverCall('../Common/Services/CommonServices.asmx/bindStateCityLocality', { CountryID: 0, StateID: 0, CityID: 0, IsStateBind: 0, CentreID: 0, IsCountryBind: 1, IsFieldBoyBind: 0,IsCityBind:1,IsLocality:1 }, function (response) {
                $ddlCountry.bindDropDown({ data: JSON.parse(response).countryData, valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: '<%=Resources.Resource.BaseCurrencyID%>' });
                jQuery('#ddlCountry').val('<%=Resources.Resource.BaseCurrencyID%>').chosen('destroy').chosen();
                callback($ddlCountry.val());
            });

        }
        $bindBusinessZone = function () {
            jQuery("#ddlState,#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
            var $ddlBusinessZone = jQuery('#ddlBusinessZone');
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWithCountry', { CountryID: jQuery('#ddlCountry').val() }, function (response) {
                $ddlBusinessZone.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', isSearchAble: true });
            });
        }
        var $onCountryChange = function () {
            $('#ddlState,#ddlCity,#ddlZone,#ddlLocality').chosen('destroy');
            $bindBusinessZone();
        }
        var $onBusinessZoneChange = function (selectedBusinessZoneID) {
            $('#ddlCity,#ddlZone,#ddlLocality').chosen('destroy');
            $bindState(selectedBusinessZoneID, function () { });
        }
        var $bindState = function (BusinessZoneID, callback) {
            var $ddlState = $('#ddlState');
            jQuery("#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindState', { CountryID: 14, BusinessZoneID: BusinessZoneID }, function (response) {
                $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });
                callback($ddlState.val());
            });
            $("#ddlState .chosen-single").addClass("requiredField");

        }
        var $onStateChange = function (selectedStateID) {
            $('#ddlZone,#ddlLocality').chosen('destroy');
            $bindCity(selectedStateID, function () { });
        }
        var $bindCity = function (StateID, callback) {
            var $ddlCity = $('#ddlCity');
            jQuery("#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: StateID }, function (response) {
                $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });
                callback($ddlCity.val());
            });
        }
        var $onCityChange = function (selectedCityID) {
            $('#ddlZone,#ddlLocality').chosen('destroy');
            $bindZone(selectedCityID, function () { });
        }
        var $bindZone = function (CityID, callback) {
            var $ddlZone = $('#ddlZone');
            jQuery("#ddlLocality").find('option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindZone', { CityID: CityID }, function (response) {
                $ddlZone.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ZoneID', textField: 'Zone', isSearchAble: true });
                callback($ddlZone.val());
            });
        }
        var $onZoneChange = function (selectedZoneID) {
            $bindLocality(selectedZoneID, function () { });
        }
        var $bindLocality = function (ZoneID, callback) {
            var $ddlLocality = $('#ddlLocality');
            jQuery("#ddlLocality").find('option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByZone', { ZoneID: ZoneID }, function (response) {
                $ddlLocality.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
                callback($ddlLocality.val());
            });
        }
        function ShowHidePassword(ID) {
            if (document.getElementById($("#" + ID).prev().attr('id')).type == "password") {
                $("#" + ID).attr("data-hint", "Show");
                $("#" + ID).find("i").removeClass("icon-eye-slash").addClass("icon-eye");
                document.getElementById($("#" + ID).prev().attr('id')).type = "text";
                $("#" + ID).find("i").attr("title", "Click to Hide Password");
                MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            }
            else {
                $("#" + ID).attr("data-hint", "Hide");
                $("#" + ID).find("i").removeClass("icon-eye").addClass("icon-eye-slash");
                document.getElementById($("#" + ID).prev().attr('id')).type = "password";
                $("#" + ID).find("i").attr("title", "Click to Show Password");
                MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            }
        }
    </script>
    <script type="text/javascript">

        var PUPData = "";
        $(function () {
            if ($.trim($("#lblEnrollID").text()) != "") {
                $("#chkNewInv").attr('disabled', 'disabled');
                $("#spnAttachmentCon").text('Show Attachment');
            }
            else {
                $("#spnAttachmentCon").hide();
                getPaymentCon();
            }
            $("#chkNewInv").click(function () {
                chkNew();

                clearform();
                $("#btnUpdate").hide();
                $("#centreControl").hide();
                SetPupName();
            });
            jQuery("#txtcreationdt").datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
               // maxDate: new Date,
                changeYear: true, //yearRange: "-100:+0",
                onSelect: function (value, ui) {
                   
                }
            });
            bindtype1();
            chkNew();
        });

      function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                 if (jQuery('#divDocumentMaualMaters').is(':visible')) {
                    $closePatientManualDocModel();
                }      
            }
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        $closePatientManualDocModel = function () {
            jQuery('#divDocumentMaualMaters').closeModel();
        }


        jQuery("#txtEmailInvoice").on("blur", function () {
            debugger;
            if (jQuery('#txtEmailInvoice').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtEmailInvoice').val())) {
                    toast("Error", 'Incorrect Invoice Email ID', '');
                    jQuery('#txtEmailInvoice').focus();
                    return false;
                }
            }
        });


        jQuery("#txtEmailReport").on("blur", function () {
            debugger;
            if (jQuery('#txtEmailReport').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtEmailReport').val())) {
                    toast("Error", 'Incorrect Report Email ID', '');
                    jQuery('#txtEmailReport').focus();
                    return false;
                }
            }
        });

        function getExcelData() {
            serverCall('PUPMaster.aspx/getExcelData', {}, function (response) {
                var $responseData = JSON.parse(response);
                PostReport($responseData.Query, $responseData.ReportName, "", $responseData.ReportPath);

            });
        }
		function chkRollindAdvance() {
            if (jQuery('#ddlPaymentMode').val() == "Cash") {
                jQuery('#chkRollingAdvance').prop('checked', false);
                jQuery('#chkRollingAdvance').attr('disabled', 'disabled');
            }
            else {
                jQuery('#chkRollingAdvance').removeAttr('disabled');
            }
        }
		function chkBookingLock() {
		    if (jQuery.trim(jQuery("#txtCreditLimit").val()) != "")
		        jQuery("#ChkIsBookingLock").prop('checked', true);
		    else
		        jQuery("#ChkIsBookingLock").prop('checked', false);
		}
		function chkReportingLock() {
		    if (jQuery.trim(jQuery("#txtLabreportlimit").val()) != "")
		        jQuery("#ChkIsPrintingLock").prop('checked', true);
		    else
		        jQuery("#ChkIsPrintingLock").prop('checked', false);
		}
		function chkIntimationLock() {
		    if (jQuery.trim(jQuery("#txtCreditLimitIntimation").val()) != "")
		        jQuery("#chkIntimation").prop('checked', true);
		    else
		        jQuery("#chkIntimation").prop('checked', false);
		}
        function getPaymentCon() {
            if ($("#ddlPaymentMode").val() == "Cash") {
                $("#txtMinCash").val('100').removeAttr('disabled');
                $("#txtCreditLimit").val('0').attr('disabled', 'disabled');
                $('#chkShowAmtInBooking,#chkHideReceiptRate').prop('checked', false);
                jQuery('#chkShowAmtInBooking, label[for="chkShowAmtInBooking"]').hide();
                jQuery('#chkHideReceiptRate, label[for="chkHideReceiptRate"]').hide();
                $('#ddlnvoiceCreatedOn').val('1');
                $('.InvoiceCreated').hide();
				jQuery('.RollingAdvance').hide();
            }
            else {
                $("#txtMinCash").val('0').attr('disabled', 'disabled');
                $("#txtCreditLimit").removeAttr('disabled');
                jQuery('#chkShowAmtInBooking, label[for="chkShowAmtInBooking"]').show();
                jQuery('#chkHideReceiptRate, label[for="chkHideReceiptRate"]').show();
                $('.InvoiceCreated,.RollingAdvance').show();
                $('#ddlnvoiceCreatedOn').val('0');
            }
        }

        function selectPatientType() {
            if ($("#ddlType1 option:selected").text() == "PUP") {
                $("#ddlPanelGroup").val('2');
                //  $("#ddlPanelGroup").attr('disabled', 'disabled');
            }
            else if ($("#ddlType1 option:selected").text() == "HLM") {
                $("#ddlPanelGroup").val('4');
                //     $("#ddlPanelGroup").attr('disabled', 'disabled');
            }
            else {
                $("#ddlPanelGroup").prop('selectedIndex', 0).attr('disabled', false);
            }
        }

        function SetPupName() {
            if ($('#chkNewInv').prop("checked") == true && $("#lblEnrollID").text() == "") {
                $('#txtPUPName').val('');
                if ($("#ddlType1 option:selected").text() == "PUP") {
                    $('#txtPUPName').val('');
                }
                else if ($("#ddlType1 option:selected").text() == "PCC") {

                    $('#txtPUPName').val("PCC");
                }
                else if ($("#ddlType1 option:selected").text() == "HLM") {
                    $('#txtPUPName').val("HLM");
                }
                else if ($("#ddlType1 option:selected").text() == "SL") {
                    $('#txtPUPName').val("SL");
                }
            }
        }
    </script>
    <script type="text/javascript">
        function chkNew() {
            if ($("#chkNewInv").is(':checked')) {
                $("#btnSave").show();
                $('#txtSearch').attr('disabled', 'disabled');
                $("#listPUP").attr('disabled', 'disabled');
            }
            else {
                $("#btnSave").hide();
                $('#txtSearch').val('').removeAttr('disabled');
                $("#listPUP").removeAttr('disabled');
            }
            SetPupName();
        }
        function bindtype1() {
            jQuery('#ddlType1 option').remove();

            serverCall('PUPMaster.aspx/gettype1', {}, function (response) {
                var $responseData = JSON.parse(response);
                for (var a = 0; a <= $responseData.length - 1; a++) {
                    jQuery('#ddlType1').append($("<option></option>").val($responseData[a].ID).html($responseData[a].Type1));
                }
                jQuery('#ddlType1').val('7').attr('disabled', 'disabled');
                selectPatientType();

            });
        }
        var keys = [];
        var values = [];
        var timer = null;
        function Click(ctr) {
            clearTimeout(timer);
            timer = setTimeout(filtCentreData, 200);
        }
        function filtCentreData() {
            $("#listPUP option").attr("selected", null);
            var filter = $('#txtSearch').val();
            if (filter.length > 0) {
                var search = filter.toLowerCase();
                var arr = $.grep(PUPData, function (item) {
                    return item.Company_Name.toLowerCase().indexOf(search) != -1;
                });
                jQuery('#listPUP option').remove();
                for (var i = 0; i < arr.length; i++) {
                    jQuery('#listPUP').append(jQuery("<option></option>").val(arr[i].Panel_ID).html(arr[i].Company_Name));
                }

            }
            else {
                clearform();
                jQuery('#listPUP option').remove();
                for (var i = 0; i < PUPData.length; i++) {
                    jQuery('#listPUP').append(jQuery("<option></option>").val(PUPData[i].Panel_ID).html(PUPData[i].Company_Name));
                }
                $("#listPUP option").removeAttr('selected');

            }
        }
        function DoListBoxFilter(listBoxSelector, textbox, filter, keys, values) {
            var list = $(listBoxSelector);
            values = [];
            keys = [];
            var options = $('#<% = listPUP.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            var selectBase = '<option value="{0}">{1}</option>';
            for (i = 0; i < values.length; ++i) {
                var value = values[i].toLowerCase();
                var len = $(textbox).val().length;
                if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                    var sc = $('#ctl00_ContentPlaceHolder1_listPUP').scrollTop();
                    var news = sc + i;
                    $('#ctl00_ContentPlaceHolder1_listPUP').scrollTop(news);
                    list.attr('selectedIndex', i);
                    return;
                }
            }
        }
        function loadDetail(val) {
            jQuery('#chkNewInv').prop('checked', false);
            jQuery('#btnSave').hide();
            clearform();

            serverCall('PUPMaster.aspx/getPanelData', { PanelID: val }, function (response) {
                var PanelData = JSON.parse(response);
                jQuery("#lblPanelID").text(PanelData[0].Panel_ID);
                if (PanelData[0].IsActive == "1")
                    jQuery("#isActive").prop('checked', 'checked');
                else
                    jQuery("#isActive").prop('checked', false);

                if (PanelData[0].showBalanceAmt == "1")
                    jQuery("#chkshowBalanceAmt").prop('checked', 'checked');
                else
                    jQuery("#chkshowBalanceAmt").prop('checked', false);
                if (PanelData[0].AllowSharing == "1")
                    jQuery("#chksharing").prop('checked', 'checked');
                else
                    jQuery("#chksharing").prop('checked', false);
                
                jQuery("#hdfempid").val(PanelData[0].employee_id);
                if (jQuery("#hdfempid").val() !="" && jQuery("#hdfempid").val() !="0")
                    jQuery("#chkemp").prop('checked', true);
                else
                    jQuery("#chkemp").prop('checked', false);
                if (PanelData[0].ReceiptType != "" && PanelData[0].ReceiptType != undefined) {
                    jQuery('#lstReportsOption').val(PanelData[0].ReceiptType.split(','));
                    jQuery('#lstReportsOption').multipleSelect("refresh");
                }

                jQuery("#txtcreationdt").val(PanelData[0].PanelCreationDt);
                jQuery("#txtpancard").val(PanelData[0].panno);
                jQuery("#txtpancardname").val(PanelData[0].PANCardName);
                jQuery("#txtSecurityAmt").val(PanelData[0].SecurityAmt);
                jQuery("#txtsecremark").val(PanelData[0].SecurityRemark);
                
                jQuery("#txtPUPName").val(PanelData[0].Company_Name);
                jQuery("#txtAddress").val(PanelData[0].Add1);
                jQuery("#txtLandline").val(PanelData[0].Phone);
                jQuery("#txtMobile").val(PanelData[0].Mobile);
                jQuery("#ddlPaymentMode").val(PanelData[0].Payment_Mode);
                getPaymentCon();
                jQuery("#ddlPrintAtCentre").val(PanelData[0].PrintAtCentre);
                jQuery("#txtEmailInvoice").val(PanelData[0].EmailID);
                jQuery("#txtEmailReport").val(PanelData[0].EmailIDReport);
                jQuery("#ddlReportDispatchMode").val(PanelData[0].ReportDispatchMode);
                jQuery("#txtMinBusinessComm").val(PanelData[0].MinBusinessCommitment);
                jQuery("#txtGSTTIN").val(PanelData[0].GSTTin);
                jQuery("#ddlInvoiceBillingCycle").val(PanelData[0].InvoiceBillingCycle);
                jQuery("#ddlBankName").val(PanelData[0].BankID);
                jQuery("#txtAccountNo").val(PanelData[0].AccountNo);
                jQuery("#ddlPanelGroup").val(PanelData[0].PanelGroupID);
                jQuery('#ddlReferringRate').val(PanelData[0].ReferenceCodeOPD);
                jQuery("#txtIFSCCode").val(PanelData[0].IFSCCode);
               // jQuery("#txtCreditLimit").val(PanelData[0].CreditLimit);
                jQuery("#ddlInvoiceTo").val(PanelData[0].InvoiceTo);
                jQuery('#txtOnlineUserName').val(PanelData[0].PanelUserID);
                jQuery('#txtOnlinePassword').val(PanelData[0].PanelPassword);
                jQuery('#txtMinCash').val(PanelData[0].MinBalReceive);
                jQuery('#ddlTagProcessingLab').val(PanelData[0].TagProcessingLabID);
                jQuery('#ddlTagBusinessLab').val(PanelData[0].TagBusinessLabID);
                jQuery('#ddlHUB').val(PanelData[0].TagHUBID);
                jQuery('#ddlSalesManager').val(PanelData[0].SalesManagerID);
                jQuery('#txtPUPCode').val(PanelData[0].Panel_Code);
                var CreditLimit = PanelData[0].CreditLimit;
                if (CreditLimit == "0") {
                    jQuery("#txtCreditLimit").val(CreditLimit);
                    jQuery("#ddlCreditLimit").val("+");
                }
                else if (CreditLimit != "") {
                    var sign = CreditLimit > 0 ? 1 : CreditLimit == 0 ? 0 : -1;
                    jQuery("#txtCreditLimit").val(CreditLimit);
                    if (sign == "-1") {
                        jQuery("#ddlCreditLimit").val("-");
                    }
                    else {
                        jQuery("#ddlCreditLimit").val("+");
                    }
                }
                else {
                    jQuery("#txtCreditLimit").val('');
                }
                var LabReportLimit = PanelData[0].LabReportLimit;
                if (LabReportLimit == "0") {
                    jQuery("#txtLabreportlimit").val(LabReportLimit);
                    jQuery("#ddlLabreportlimit").val("+");
                }
                else if (LabReportLimit != "") {
                    var sign = LabReportLimit > 0 ? 1 : LabReportLimit == 0 ? 0 : -1;
                    jQuery("#txtLabreportlimit").val(LabReportLimit);
                    if (sign == "-1")
                        jQuery("#ddlLabreportlimit").val("-");
                    else
                        jQuery("#ddlLabreportlimit").val("+");
                }
                else {
                    jQuery("#txtLabreportlimit").val('');
                }
                var IntimationLimit = PanelData[0].IntimationLimit;
                if (IntimationLimit == "0") {
                    jQuery("#txtCreditLimitIntimation").val(IntimationLimit);
                    jQuery("#ddlCreditLimitIntimation").val("+");
                }
                else if (IntimationLimit != "") {
                    var sign = IntimationLimit > 0 ? 1 : IntimationLimit == 0 ? 0 : -1;
                    jQuery("#txtCreditLimitIntimation").val(IntimationLimit);
                    if (sign == "-1")
                        jQuery("#ddlCreditLimitIntimation").val("-");
                    else
                        jQuery("#ddlCreditLimitIntimation").val("+");

                }
                else {
                    jQuery("#txtCreditLimitIntimation").val('');
                }

                if (PanelData[0].RollingAdvance == "1")
                    jQuery("#chkRollingAdvance").prop('checked', 'checked');
                else
                    jQuery("#chkRollingAdvance").prop('checked', false);

                if (PanelData[0].IsShowIntimation == "1")
                    jQuery("#chkIntimation").prop('checked', 'checked');
                else
                    jQuery("#chkIntimation").prop('checked', false);

                jQuery('#ddlPro').val(PanelData[0].PROID);
                jQuery("#txtPUPCode").val(PanelData[0].Panel_Code);
                if (PanelData[0].HideRate == "1")
                    jQuery("#chkShowAmtInBooking").prop('checked', 'checked');
                else
                    jQuery("#chkShowAmtInBooking").prop('checked', false);
                if (PanelData[0].ReportInterpretation == "1")
                    jQuery("#chkReportInterpretation").prop('checked', 'checked');
                else
                    jQuery("#chkReportInterpretation").prop('checked', false);

                if (PanelData[0].HideDiscount == "1")
                    jQuery("#chkHideDisc").prop('checked', 'checked');
                else
                    jQuery("#chkHideDisc").prop('checked', false);
                if (PanelData[0].IsBookingLock == "1")
                    jQuery("#ChkIsBookingLock").prop('checked', 'checked');
                else
                    jQuery("#ChkIsBookingLock").prop('checked', false);
                if (PanelData[0].IsPrintingLock == "1")
                    jQuery("#ChkIsPrintingLock").prop('checked', 'checked');
                else
                    jQuery("#ChkIsPrintingLock").prop('checked', false);
                if (PanelData[0].HideReceiptRate == "1")
                    jQuery("#chkHideReceiptRate").prop('checked', 'checked');
                else
                    jQuery("#chkHideReceiptRate").prop('checked', false);
                if (PanelData[0].SampleRecollectAfterReject == "1")
                    jQuery("#chkSampleRecollectAfterReject").prop('checked', 'checked');
                else
                    jQuery("#chkSampleRecollectAfterReject").prop('checked', false);

                jQuery("#txtInvoiceDisplayName").val(PanelData[0].InvoiceDisplayName);
                jQuery("#txtInvoiceDisplayNo").val(PanelData[0].InvoiceDisplayNo);
                if (PanelData[0].IsOtherLabReferenceNo == "1")
                    jQuery('#chkOtherLabRefNo').prop('checked', true);
                else
                    jQuery('#chkOtherLabRefNo').prop('checked', false);
                jQuery("#ddlBarCodePrintedType").val(PanelData[0].BarCodePrintedType);
                if (PanelData[0].BarCodePrintedType == "PrePrinted") {
                    jQuery("#ddlSetOfBarCode").val(PanelData[0].SetOfBarCode);
                    if (PanelData[0].SampleCollectionOnReg == 1)
                        jQuery("#chkSampleCollectionOnReg").prop('checked', 'checked');
                    else
                        jQuery("#chkSampleCollectionOnReg").prop('checked', false);
                   if (PanelData[0].IsAllowDoctorShare == 1)
                        jQuery("#chkAllowDoctorShare").prop('checked', 'checked');
                    else
                        jQuery("#chkAllowDoctorShare").prop('checked', false);


                    if (PanelData[0].BarCodePrintedCentreType == 1)
                        jQuery("#chkBarcodePrintedCentreType").prop('checked', 'checked');
                    else
                        jQuery("#chkBarcodePrintedCentreType").prop('checked', false);

                    if (PanelData[0].BarCodePrintedHomeColectionType == 1)
                        jQuery("#chkBarcodePrintedHomeCollectionType").prop('checked', 'checked');
                    else
                        jQuery("#chkBarcodePrintedHomeCollectionType").prop('checked', false);
                    $(".clBarcodeType").show();
                }
                else {
                    $(".clBarcodeType").hide();
                }
                
                jQuery("#ddlnvoiceCreatedOn").val(PanelData[0].InvoiceCreatedOn)
                jQuery("#ddlInvoiceType").val(PanelData[0].MonthlyInvoiceType);
            
                GetInvoiceType();
                jQuery('#ddlCountry').val(PanelData[0].CountryID).chosen('destroy').chosen();
                jQuery('#ddlBusinessZone').val(PanelData[0].BusinessZoneID).chosen('destroy').chosen();
                $bindState(PanelData[0].BusinessZoneID, function (selectedStateID) {
                    jQuery('#ddlState').val(PanelData[0].StateID).chosen('destroy').chosen();
                    $bindCity(PanelData[0].StateID, function (selectedCityID) {
                        jQuery('#ddlCity').val(PanelData[0].CityID).chosen('destroy').chosen();
                        $bindZone(PanelData[0].CityID, function (selectedZoneID) {
                            $('#ddlZone').val(PanelData[0].ZoneId).chosen('destroy').chosen();
                            $bindLocality(PanelData[0].ZoneId, function (selectedLocalityID) {
                                $('#ddlLocality').val(PanelData[0].LocalityID).chosen('destroy').chosen();
                            });
                        });
                    });
                });


            });
            jQuery("#btnUpdate,#centreControl").show();
        }
        function clearform() {
            jQuery('#lblPanelID').text('');
            jQuery("#hdfempid").val('0');
            jQuery('#txtPUPName,#txtAddress,#txtLandline,#txtMobile').val('');
            jQuery('#txtEmailInvoice,#txtEmailReport,#txtMinBusinessComm,#txtGSTTIN,#txtAccountNo,#txtIFSCCode,#txtOnlineUserName,#txtOnlinePassword,#txtMinCash,#txtCreditLimit,#txtInvoiceDisplayName,#txtInvoiceDisplayNo').val('');
            jQuery('#ddlPaymentMode,#ddlTagProcessingLab,#ddlReportDispatchMode,#ddlInvoiceBillingCycle,#ddlTagBusinessLab').prop('selectedIndex', '0');
            jQuery('#ddlBankName,#ddlPrintAtCentre,#ddlReferringRate,#ddlInvoiceTo,#ddlPro,#ddlBarCodePrintedType').prop('selectedIndex', '0');
            jQuery('#chkHideDisc,#ChkIsBookingLock,#chkHideReceiptRate,#ChkIsPrintingLock,#chkOtherLabRefNo,#chkBarcodePrintedCentreType,#chkBarcodePrintedHomeCollectionType,#chkSampleCollectionOnReg').prop('checked', false);
            jQuery("#chkShowAmtInBooking,#chkReportInterpretation,#chkSampleRecollectAfterReject").prop('checked', true);
            jQuery(".clBarcodeType").hide();
            jQuery("#isActive").prop('checked', 'checked');
        }
        function CreatePanelLogin() {
            if (jQuery("#chkemp").is(':checked') == false) {
                jQuery("#chkemp").prop('checked', false);
                return;
            }
            if (jQuery("#hdfempid").val() != '' && jQuery("#hdfempid").val() != '0') {
                jQuery("#chkemp").prop('checked', true);
                toast('Error', 'Panel login is already created !!', '');
                $('#txtPUPName').focus();
                return;
            }
            if (confirm("Do you want to create panel login !!") == false && jQuery("#chkemp").is(':checked')==false) {
                jQuery("#chkemp").prop('checked', false);
                return;
            }
           
          
            if (jQuery.trim(jQuery("#lblPanelID").text()) == "") {
                jQuery("#chkemp").prop('checked', false);
                toast('Error', 'Please Select Panel to create login !!', '');
                $('#txtPUPName').focus();
                return;
            }
            if (jQuery.trim($('#txtPUPName').val()) == "") {
                jQuery("#chkemp").prop('checked', false);
                toast('Error', 'Enter PUP Name ', '');
                $('#txtPUPName').focus();
                return;
            }
            var resultPanel = panelMaster();

           

            serverCall('PUPMaster.aspx/SaveEmployee', { Panel: resultPanel }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', 'Panel Login created Successfully', '');
                  
                    window.location.reload();
                }
                else {
                    $(btnUpdate).attr('disabled', false).val('Save');
                    toast('Error', $responseData.response, '');
                }
                jQuery("#chkemp").prop('checked', false);
                $modelUnBlockUI(function () { });
            });
        }
        var $savePUP = function (btnSave) {
          
            if (jQuery.trim(jQuery('#txtPUPName').val()) == "") {
                toast('Error', 'Enter PUP Name ', '');
                jQuery('#txtPUPName').focus();
                return;
            }
            if (jQuery('#ddlTagProcessingLab option:selected').text() == "Select") {
                toast('Error', 'Select TagProcessing Lab', '');
                jQuery('#ddlTagProcessingLab').focus();
                return;
            }
            if (jQuery('#ddlTagBusinessLab option:selected').text() == "Select") {
                toast('Error', 'Select TagBusiness Lab', '');
                jQuery('#ddlTagBusinessLab').focus();
                return;
            }
            if (jQuery.trim(jQuery('#ddlCountry').val()) == "0") {
                toast('Error', 'Please select Country ', '');
                jQuery('#ddlCountry').focus();
                return;
            }
            if ($('#ddlBarCodePrintedType').val() == "0") {
                toast('Error', 'Please Select BarCode Type', '');
                jQuery('#ddlBarCodePrintedType').focus();
                return false;
            }
                if ($('#ddlnvoiceCreatedOn').val() == "0") {
                    toast('Error', 'Please Select Invoice Created On', '');
                    jQuery('#ddlnvoiceCreatedOn').focus();
                    return false;
                }
                if (jQuery("#ddlnvoiceCreatedOn").val() == "2" && $('#ddlInvoiceType').val() == "0") {
                    toast('Error', 'Please Select Invoice type', '');
                    jQuery('#ddlInvoiceType').focus();
                    return false;

                }
            
            
            $(btnSave).attr('disabled', true).val('Submitting...');

            var resultPanel = panelMaster();
            //var $patientDocuments = [];
            //jQuery('#tblDocumentMaster tr td#tdDocumentID').each(function () {
            //    if (jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim() != '') {
            //        var $document = {
            //            documentId: this.innerHTML.trim(),
            //            name: jQuery(this.parentNode).find('#btnDocumentName').val(),
            //            data: jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim()
            //        }
            //        $patientDocuments.push($document);
            //    }
            //});

            var DocumentId;
            var tdMaualDocumentID;
            if ($DocumentID[0] != "" && $DocumentID[0] != undefined) {
                DocumentId = $DocumentID[0];
            }
            else {
                DocumentId = -67;
            }

          //  console.log($DocumentID[0]);

            serverCall('PUPMaster.aspx/savePUP', { Panel: resultPanel, DocumentID: DocumentId }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast('Success', 'Record Saved Successfully', '');
                        if ($("#lblEnrollID").text() != "") {
                            window.close();
                        }
                        $(btnSave).attr('disabled', false).val('Save');
                        jQuery('#chkNewInv').prop('checked', true);
                        jQuery('#btnSave,#btnUpdate').hide();
                        clearform();
                        window.location.reload();
                    }
                    else {
                        $(btnSave).attr('disabled', false).val('Save');
                        toast('Error', $responseData.response, '');
                    }
                    $modelUnBlockUI(function () { });
                });

        }

        var $updatePUP = function (btnSave) {
            if (jQuery.trim($('#txtPUPName').val()) == "") {
                toast('Error', 'Enter PUP Name ', '');
                $('#txtPUPName').focus();
                return;
            }
            if (jQuery('#ddlTagProcessingLab option:selected').text() == "Select") {
                toast('Error', 'Select TagProcessing Lab', '');
                jQuery('#ddlTagProcessingLab').focus();
                return;
            }
            if (jQuery('#ddlTagBusinessLab option:selected').text() == "Select" || jQuery('#ddlTagBusinessLab option:selected').text() == "") {
                toast('Error', 'Select TagBusiness Lab', '');
                jQuery('#ddlTagBusinessLab').focus();
                return;
            }
            jQuery('#btnUpdate').attr('disabled', true).val("Submitting...");

            var resultPanel = panelMaster();

            var DocumentId;
            var tdMaualDocumentID;
            if ($DocumentID[0] != "" && $DocumentID[0]!=undefined) {
                DocumentId = $DocumentID[0];
            } 
            else {
                tdMaualDocumentID = $('#tdMaualDocumentID').text();
                if (tdMaualDocumentID != "") {
                    DocumentId = tdMaualDocumentID;
                }
                else {
                    DocumentId = -67;
                }
            }

            serverCall('PUPMaster.aspx/UpdatePUP', { Panel: resultPanel, DocumentID: DocumentId }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', 'Record Updated Successfully', '');
                    jQuery('#btnUpdate').attr('disabled', false).val("Update");
                    jQuery('#chkNewInv').prop('checked', false);
                    jQuery('#btnSave,#btnUpdate').hide();
                    clearform();
                    window.location.reload();
                }
                else {
                    $(btnUpdate).attr('disabled', false).val('Save');
                    toast('Error', $responseData.response, '');
                }
                $modelUnBlockUI(function () { });
            });
        }
        function openme(pagename) {
            if (pagename == "AddDocument") {
                    window.open('../Lab/AddPanelAttachment.aspx?PanelID=' + $('#lblPanelID').html());
            }
            else {
                serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: $('#lblPanelID').html() }, function (response) {
                    window.open(pagename + '.aspx?PanelID=' + response);
                });
            }
        }
    </script>
    <script type="text/javascript">

        function panelMaster() {
            var dataPanel = new Array();
            var objPanel = new Object();
            objPanel.Company_Name = jQuery.trim(jQuery("#txtPUPName").val());
            objPanel.Add1 = jQuery.trim(jQuery("#txtAddress").val());
            objPanel.PanelGroup = jQuery("#ddlPanelGroup option:selected").text();
            objPanel.PanelGroupID = jQuery("#ddlPanelGroup").val()==null ? '0' : jQuery("#ddlPanelGroup").val();
            objPanel.IsActive = jQuery("#isActive").is(':checked') ? 1 : 0;
            objPanel.Mobile = jQuery("#txtMobile").val();
            objPanel.Phone = jQuery("#txtLandline").val();
            objPanel.Payment_Mode = jQuery.trim(jQuery("#ddlPaymentMode").val());
            objPanel.TagProcessingLabID = jQuery("#ddlTagProcessingLab").val();
            objPanel.PROID = jQuery("#ddlPro").val()==null ? '0':jQuery("#ddlPro").val();
            if (jQuery("#ddlTagProcessingLab option:selected").text() == "Self")
                objPanel.TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();
            else if (jQuery("#ddlTagProcessingLab").val() != "0")
                objPanel.TagProcessingLab = jQuery("#ddlTagProcessingLab option:selected").text();
            else
                objPanel.TagProcessingLab = "";
            objPanel.EmailID = jQuery.trim(jQuery("#txtEmailInvoice").val());
            objPanel.EmailIDReport = jQuery("#txtEmailReport").val();
            objPanel.ReportDispatchMode = jQuery("#ddlReportDispatchMode").val();
            if (jQuery("#txtMinBusinessComm").val() != "")
                objPanel.MinBusinessCommitment = jQuery("#txtMinBusinessComm").val();
            else
                objPanel.MinBusinessCommitment = 0;
            objPanel.GSTTin = jQuery("#txtGSTTIN").val();
            objPanel.InvoiceBillingCycle = jQuery("#ddlInvoiceBillingCycle").val();
            if (jQuery("#ddlBankName").val() != "0") {
                objPanel.BankName = jQuery("#ddlBankName option:selected").text();
                objPanel.BankID = jQuery("#ddlBankName").val();
            }
            else {
                objPanel.BankName = "";
                objPanel.BankID = 0;
            }
            objPanel.AccountNo = jQuery.trim(jQuery("#txtAccountNo").val());
            objPanel.IFSCCode = jQuery.trim(jQuery("#txtIFSCCode").val());
            objPanel.LoginID = jQuery.trim(jQuery("#txtOnlineUserName").val());
            objPanel.LoginPassword = jQuery("#txtOnlinePassword").val();
            objPanel.PrintAtCentre = jQuery("#ddlPrintAtCentre").val();
            objPanel.ReferenceCode = jQuery("#ddlReferringRate").val();
            objPanel.ReferenceCodeOPD = jQuery("#ddlReferringRate").val();
            objPanel.InvoiceTo = jQuery("#ddlInvoiceTo").val();
            if (jQuery("#txtMinCash").val() != "")
                objPanel.MinBalReceive = jQuery("#txtMinCash").val();
            else
                objPanel.MinBalReceive = 0;

            if (jQuery.trim(jQuery("#txtCreditLimit").val()) == "")
                objPanel.CreditLimit = 0
            else
                objPanel.CreditLimit = "".concat(jQuery("#ddlCreditLimit").val(), jQuery.trim(jQuery("#txtCreditLimit").val()));

            //objPanel.CreditLimit = "".concat(jQuery("#ddlCreditLimitIntimation").val(), jQuery.trim(jQuery("#txtCreditLimit").val()));
                jQuery.trim(jQuery("#txtCreditLimit").val());
            objPanel.ShowAmtInBooking = jQuery("#chkShowAmtInBooking").is(':checked') ? 1 : 0;
            objPanel.HideRate = jQuery("#chkShowAmtInBooking").is(':checked') ? 1 : 0;
            objPanel.IsBookingLock = jQuery("#ChkIsBookingLock").is(':checked') ? 1 : 0;
            objPanel.IsPrintingLock = jQuery("#ChkIsPrintingLock").is(':checked') ? 1 : 0;
            objPanel.showBalanceAmt = jQuery("#chkshowBalanceAmt").is(':checked') ? 1 : 0;
            objPanel.AllowSharing = jQuery("#chksharing").is(':checked') ? 1 : 0;
            
            objPanel.Panel_Code = jQuery("#txtPUPCode").val();
            objPanel.SavingType = "FOCO";
            if (jQuery.trim(jQuery("#lblPanelID").text()) != "")
                objPanel.Panel_ID = jQuery.trim(jQuery("#lblPanelID").text());
            else
                objPanel.Panel_ID = 0;
            objPanel.HideReceiptRate = jQuery("#chkHideReceiptRate").is(':checked') ? 1 : 0;
            objPanel.EnrollID = jQuery("#lblEnrollID").text();
            if (jQuery.trim(jQuery("#txtInvoiceDisplayName").val()) != "")
                objPanel.InvoiceDisplayName = jQuery("#txtInvoiceDisplayName").val();
            else
                objPanel.InvoiceDisplayName = jQuery.trim(jQuery("#txtPUPName").val());
            objPanel.InvoiceDisplayNo = jQuery("#txtInvoiceDisplayNo").val();
            objPanel.SecurityDeposit = 0;
            if (jQuery.trim(jQuery("#txtMRPPercentage").val()) != "") {
                objPanel.DiscPercent = jQuery("#txtMRPPercentage").val();
            }
            else {
                objPanel.DiscPercent = 0;
            }
            objPanel.TagBusinessLab = jQuery("#ddlTagBusinessLab option:selected").text();
            objPanel.TagBusinessLabID = jQuery("#ddlTagBusinessLab").val() ==null ?'0' : jQuery("#ddlTagBusinessLab").val();
            objPanel.IsOtherLabReferenceNo = jQuery("#chkOtherLabRefNo").is(':checked') ? 1 : 0;

            if ($("#ddlBarCodePrintedType").val() == "PrePrinted") {
                objPanel.BarCodePrintedType = $("#ddlBarCodePrintedType").val();
                objPanel.SampleCollectionOnReg = jQuery("#chkSampleCollectionOnReg").is(':checked') ? 1 : 0;
                objPanel.BarCodePrintedCentreType = jQuery("#chkBarcodePrintedCentreType").is(':checked') ? 1 : 0;
                objPanel.BarCodePrintedHomeColectionType = jQuery("#chkBarcodePrintedHomeCollectionType").is(':checked') ? 1 : 0;
                objPanel.SetOfBarCode = $("#ddlSetOfBarCode").val();
            }
            else {
                objPanel.BarCodePrintedType = $("#ddlBarCodePrintedType").val();
                objPanel.SampleCollectionOnReg = 0;
                objPanel.BarCodePrintedCentreType = 0;
                objPanel.BarCodePrintedHomeColectionType = 0;
                objPanel.SetOfBarCode = "";

            }
            objPanel.CountryID = jQuery('#ddlCountry').val();
            objPanel.CountryName = jQuery('#ddlCountry option:selected').text();
            objPanel.zone = jQuery("#ddlZone option:selected").text();
            objPanel.ZoneID = jQuery("#ddlZone").val()== null ? "0": jQuery("#ddlZone").val();
            objPanel.BusinessZoneID = jQuery.trim(jQuery("#ddlBusinessZone").val());
            objPanel.StateID = jQuery.trim(jQuery("#ddlState").val())=="" ? "0" : jQuery.trim(jQuery("#ddlState").val());
            objPanel.CityID = jQuery.trim(jQuery("#ddlCity").val()) =="" ? "0" : jQuery.trim(jQuery("#ddlCity").val());
            objPanel.LocalityID = jQuery.trim(jQuery("#ddlLocality").val())=="" ? '0' : jQuery.trim(jQuery("#ddlLocality").val());
            objPanel.area = jQuery.trim(jQuery("#ddlLocality option:selected").text());
            objPanel.City = jQuery.trim(jQuery("#ddlCity option:selected").text());
            objPanel.BusinessZone = jQuery.trim(jQuery("#ddlBusinessZone option:selected").text());
            objPanel.State = jQuery.trim(jQuery("#ddlState option:selected").text());
            objPanel.IsAllowDoctorShare = jQuery("#chkAllowDoctorShare").is(':checked') ? 1 : 0;
            objPanel.SampleRecollectAfterReject = jQuery("#chkSampleRecollectAfterReject").is(':checked') ? 1 : 0;
            objPanel.InvoiceCreatedOn = jQuery.trim(jQuery("#ddlnvoiceCreatedOn").val()); 
            if (jQuery.trim(jQuery("#ddlnvoiceCreatedOn").val()) == 1)
                objPanel.MonthlyInvoiceType = 0;
            else
                objPanel.MonthlyInvoiceType = jQuery.trim(jQuery("#ddlInvoiceType").val());
				
			//Rolling Advance
			 if (jQuery("#ddlPaymentMode").val() == "Cash") {
                objPanel.RollingAdvance = 0;
            }
            else {
                objPanel.RollingAdvance = jQuery("#chkRollingAdvance").is(':checked') ? 1 : 0;
            }
			if (jQuery.trim(jQuery("#txtLabreportlimit").val()) == "")
                  objPanel.LabReportLimit = 0
              else
                  objPanel.LabReportLimit = "".concat(jQuery("#ddlLabreportlimit").val(), jQuery.trim(jQuery("#txtLabreportlimit").val()));

            if (jQuery.trim(jQuery("#txtCreditLimitIntimation").val()) == "")
                  objPanel.IntimationLimit = 0
              else
                  objPanel.IntimationLimit = "".concat(jQuery("#ddlCreditLimitIntimation").val(), jQuery.trim(jQuery("#txtCreditLimitIntimation").val()));
			objPanel.IsShowIntimation = jQuery("#chkIntimation").is(':checked') ? 1 : 0;
			objPanel.IsBookingLock = jQuery("#ChkIsBookingLock").is(':checked') ? 1 : 0;
			objPanel.IsPrintingLock = jQuery("#ChkIsPrintingLock").is(':checked') ? 1 : 0;
			if (jQuery("#ddlSalesManager").val() != "" && jQuery("#ddlSalesManager").val() != null) {
			    objPanel.SalesManager = jQuery("#ddlSalesManager").val();
			    objPanel.SalesManagerName = jQuery("#ddlSalesManager option:selected").text();
			}
			else {
			    objPanel.SalesManager = 0;
			    objPanel.SalesManagerName = "";
			}

            if (jQuery("#ddlHUB").val() != "" && jQuery("#ddlHUB").val() != null)
                objPanel.TagHUB = jQuery("#ddlHUB").val();
            else
                objPanel.TagHUB = 0;
            objPanel.EmployeeID = jQuery.trim(jQuery("#hdfempid").val()) == "" ? 0 : jQuery.trim(jQuery("#hdfempid").val());
            objPanel.IsPanelLogin = jQuery("#chkemp").is(':checked') == false ? 0 : 1;
            objPanel.ReceiptType = jQuery.trim(jQuery("#lstReportsOption").val());
            objPanel.CreationDate = jQuery.trim(jQuery("#txtcreationdt").val());
            objPanel.PanNo = jQuery.trim(jQuery("#txtpancard").val());
            objPanel.PANCardName = jQuery.trim(jQuery("#txtpancardname").val());
            objPanel.SecurityAmt = jQuery.trim(jQuery("#txtSecurityAmt").val());
            objPanel.SecurityRemark = jQuery.trim(jQuery("#txtsecremark").val());
            
            
            dataPanel.push(objPanel);
            return dataPanel;
        }
    </script>
    <script type="text/javascript">
        function chkMinCash() {
            if (jQuery.trim($("#txtMinCash").val()) != "") {
                if ($("#txtMinCash").val() > 100) {
                    alert('Please Enter Valid Percentage');
                    $("#txtMinCash").val('0');
                    return;
                }
            }
        }
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
    </script>
    <script type="text/javascript">
        $(function () {
            bindAllPUP();
        });
        function bindAllPUP() {
            jQuery('#listPUP option').remove();
            serverCall('PUPMaster.aspx/bindPUP', {}, function (response) {
                PUPData = JSON.parse(response);
                if (PUPData != '') {
                    for (var i = 0; i < PUPData.length; i++) {
                        jQuery('#listPUP').append(jQuery("<option></option>").val(PUPData[i].Panel_ID).html(PUPData[i].Company_Name));
                    }
                }
            });
        }
        function showuploadbox() {
            var FileName = "";
            if ($.trim($("#lblEnrollID").text()) != "") {
                window.open('../Sales/UploadDocument.aspx?EnrolID=' + '<%=Request.QueryString["EnrolID"]%>', null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
                }
                else {
                    if ($('#<%=lblFileName.ClientID%>').text() == "") {
                        FileName = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
                    }
                    else {
                        FileName = $('#<%=lblFileName.ClientID%>').text();
                }
                $('#<%=lblFileName.ClientID%>').text(FileName);
                    window.open('../Sales/UploadDocument.aspx?FileName=' + FileName, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
                }
            }
            function chkMRPPercentage() {
                if (jQuery.trim($("#txtMRPPercentage").val()) != "") {
                    if (jQuery("#txtMRPPercentage").val() > 100) {
                        showerrormsg('Please Enter Valid Percentage');
                        jQuery("#txtMRPPercentage").val('0');
                    }
                }
            }

            function ChangePUP() {
                if ($('[id$=ddlPanelGroup]').val() == "3") {
                    //$('[id$=btnSave]').attr('disabled', 'disabled');
                }
                else {
                    $('[id$=btnSave]').removeAttr('disabled');
                }
                if ($('#ddlPanelGroup').val() == '9') {
                    jQuery('.RollingAdvance').show();
                    jQuery('#chkRollingAdvance').prop('checked', true);
                    jQuery('#ddlPaymentMode').attr('disabled', false);
                    jQuery('#ddlPaymentMode').val('Credit');
                    jQuery('#ddlPaymentMode').attr('disabled', 'disabled');
                }
                else if ($('#ddlPanelGroup').val() == '8') {
                    jQuery('.RollingAdvance').show();
                    jQuery('#chkRollingAdvance').prop('checked', true);
                    jQuery('#ddlPaymentMode').attr('disabled', false);
                    jQuery('#ddlPaymentMode').val('Cash');
                    jQuery('#ddlPaymentMode').attr('disabled', 'disabled');
                }
                else {
                    jQuery('.RollingAdvance').hide();
                    jQuery('#chkRollingAdvance').prop('checked', false);
                    jQuery('#ddlPaymentMode').attr('disabled', false);
                }
            }
    </script>
    <script type="text/javascript">
        var $chkBarCodeType = function () {
            if ($("#ddlBarCodePrintedType").val() == "System") {
                $(".clBarcodeType").hide();
                $("#chkBarcodePrintedCentreType,#chkBarcodePrintedHomeCollectionType,#chkSampleCollectionOnReg").prop('checked', false);
            }
            else {
                $(".clBarcodeType").show();
            }
        }
        function InvoiceCreatedShowHide() {
            if (jQuery("#ddlPaymentMode").val() == "Credit") {
                // $('.InvoiceCreated').show();
            }
            else {
                // $('#ddlInvoiceType').val('0');
                // jQuery("#ddlnvoiceCreatedOn").val('0')
                // $('.InvoiceCreated').hide();
            }
            $('.InvoiceCreated').show();
        }
        function GetInvoiceType() {
            if (jQuery("#ddlnvoiceCreatedOn").val() == "2") {
                $(".clsinvoiceHide").show();
            }
            else {
                $('#ddlInvoiceType').val('0');
                $(".clsinvoiceHide").hide();
            }

        }
 
     var $bindDocumentMasters = function (callback) {
            serverCall('../Common/Services/ScanDocumentServices.asmx/GetMasterDocuments', { patientID: jQuery('#spnUHIDNo').text() }, function (response) {
                $responseData = JSON.parse(response);
                documentMaster = $responseData.patientDocumentMasters;
                var $template = jQuery('#template_DocumentMaster').parseTemplate(documentMaster);
                jQuery('#documentMasterDiv').html($template);
                jQuery('#ddlDocumentType').bindDropDown({ defaultValue: 'Select', data: documentMaster, valueField: 'ID', textField: 'Name' });

                callback(true);
            });
        }
            var previewImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
            ShowCaptureImageModel = function () {
                jQuery('#camViewer').showModel();
                Webcam.set({
                    width: 320,
                    height: 240,
                    image_format: 'jpeg',
                    jpeg_quality: 90,
                    //force_flash: true
                });
                Webcam.setSWFLocation("../../Scripts/webcamjs/webcam.swf");
                Webcam.attach('#webcam');
            }
            $closeCamViewerModel = function (callback) {
                //Webcam.snap(function (data_uri) {
                jQuery('#camViewer').closeModel();
                document.getElementById('imgPreview').src = previewImage; //'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                Webcam.reset();
                callback();
                // });
            }
            selectImage = function (base64image) {
                base64image = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                $closeCamViewerModel(function () {
                    document.getElementById('imgPatient').src = base64image;
                    jQuery('#spnIsCapTure').text('1');
                });
            }
            showDocumentMaster = function () {
                var $filename = "";
                if (jQuery('#spnFileName').text() == "") {
                    $filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
                }
                else {
                    $filename = jQuery('#spnFileName').text();
                }
                jQuery('#spnFileName').text($filename);
                jQuery('#divDocumentMaters').show();
            }
            $showManualDocumentMaster = function () {
                var $filename = "";
                if (jQuery('#spnFileName').text() == "") {
                    $filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
                }
                else {
                    $filename = jQuery('#spnFileName').text();
                }

                var panelId;
                var oldPatient;
                if ($('#lblPanelID').text()!="") {
                    panelId = $('#lblPanelID').text();
                    oldPatient = 1;
                }
                else{
                    panelId = '';
                    oldPatient = 0;
                }


                jQuery('#spnFileName').text($filename);
                jQuery('#divDocumentMaualMaters').show();
                if (jQuery("#tblMaualDocument tbody tr").length == 0) {
                    serverCall('../Common/Services/CommonServices.asmx/bindmanualDocument', { labno: '', Filename: jQuery('#spnFileName').text(), PatientID: panelId, oldPatientSearch: oldPatient, documentDetailID: 0, isEdit: 0 }, function (response) {
                        var $maualDocument = JSON.parse(response);
                        console.log($maualDocument);
                        $addPatientDocumnet($maualDocument, 0);
                    });
                }
            }
            $addPatientDocumnet = function (maualDocument, oldPatientSearch) {
                for (var i = 0; i < maualDocument.length ; i++) {
                    var $PatientDocumnetTr = [];
                    $PatientDocumnetTr.push("<tr>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>");
                    if (oldPatientSearch == 0)
                        $PatientDocumnetTr.push('<img id="imgMaualDocument" alt="Remove Document" src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="$removeMaualDocument(this)"/>');
                    $PatientDocumnetTr.push("</td><td class='GridViewLabItemStyle' id='tdManualDocumentName'>");
                    $PatientDocumnetTr.push(maualDocument[i].DocumentName); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>"); $PatientDocumnetTr.push('<a target="_blank" onclick="$manualViewDocument(this)"');
                    $PatientDocumnetTr.push($.trim(maualDocument[i].AttachedFile));
                    $PatientDocumnetTr.push('&FilePath=');
                    $PatientDocumnetTr.push($.trim(maualDocument[i].fileurl)); $PatientDocumnetTr.push('"'); $PatientDocumnetTr.push("</a>");
                    $PatientDocumnetTr.push(maualDocument[i].AttachedFile);
                    $PatientDocumnetTr.push("</td><td class='GridViewLabItemStyle'>");
                    $PatientDocumnetTr.push(maualDocument[i].UploadedBy); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle'>");
                    $PatientDocumnetTr.push(maualDocument[i].dtEntry); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle' style='display:none' id='tdMaualAttachedFile'>");
                    $PatientDocumnetTr.push(maualDocument[i].AttachedFile); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push("<td class='GridViewLabItemStyle' style='display:none' id='tdManualFileURL'>");
                    $PatientDocumnetTr.push(maualDocument[i].fileurl); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdMaualID">');
                    $PatientDocumnetTr.push(maualDocument[i].ID); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push('<td class="GridViewLabItemStyle" style="display:none" id="tdMaualDocumentID">');
                    $PatientDocumnetTr.push(maualDocument[i].DocumentID); $PatientDocumnetTr.push("</td>");
                    $PatientDocumnetTr.push('<td class="GridViewLabItemStyle"  style="text-align:center" ><img src="../../App_Images/view.GIF" alt=""  style="cursor:pointer" onclick="$manualViewDocument(this)" /> </td>');
                    $PatientDocumnetTr.push('</tr>');
                    $PatientDocumnetTr = $PatientDocumnetTr.join("");
                    jQuery("#tblMaualDocument tbody").prepend($PatientDocumnetTr);
                }
                jQuery('#spnDocumentMaualCounts').text(jQuery("#tblMaualDocument tr").length - 1);
            };

            $documentNameClick = function (elem, row) {
                jQuery(row.parentNode).find('tr button[type=button]').attr('style', 'width: 100%; text-align: center; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;')
                jQuery('#tblDocumentMaster tr #tdBase64Document').each(function (index, elem) {
                    if (!String.isNullOrEmpty(jQuery(this).text()))
                        jQuery(this).parent().find('button[type=button]').css({ 'backgroundColor': 'LIGHTGREEN', 'background-image': 'none' });
                });
                jQuery(elem).css({ 'backgroundColor': 'antiquewhite', 'background-image': 'none' });
                elem.style.color = 'black';
                var $seletedDocumentID = jQuery(row).find('#tdDocumentID').text();
                jQuery('#spnSelectedDocumentID').text($seletedDocumentID);
                var $scanDocument = jQuery(row).find('#tdBase64Document')[0].innerHTML;
                if ($scanDocument != '')
                    document.getElementById('imgDocumentPreview').src = $scanDocument;
                else {
                    var $patientId = jQuery('#spnUHIDNo').text();
                    if ($patientId != '') {
                        serverCall('../Common/Services/ScanDocumentServices.asmx/GetDocument', { patientId: $patientId, documentName: elem.value }, function (response) {
                            var $responseData = JSON.parse(response);
                            if ($responseData.status)
                                document.getElementById('imgDocumentPreview').src = $responseData.data;
                            else
                                document.getElementById('imgDocumentPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                        });
                    }
                    else
                        document.getElementById('imgDocumentPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                }

            }
            $showScanModel = function () {
                if (jQuery('#spnSelectedDocumentID').text() != '') {
                    serverCall('../Common/Services/ScanDocumentServices.asmx/GetShareScanners', {}, function (response) {
                        var $responseData = JSON.parse(response);
                        if ($responseData.status) {
                            jQuery('#ddlSccaner').bindDropDown({ data: $responseData.data, defaultValue: null, valueField: 'DeviecId', textField: 'Name' });
                        }
                        else
                            modelAlert('Error While Access Scanner');
                    });
                    document.getElementById('imgScanPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                    jQuery('#divScanViewer').showModel();
                }
                else
                    modelAlert('Please Select Document First !!');
            }
            $scanDocument = function (deviceId) {
                serverCall('../Common/Services/ScanDocumentServices.asmx/Scan', { deviceID: deviceId }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status)
                        jQuery('#imgScanPreview').attr('src', 'data:image/jpeg;base64,' + $responseData.data);
                    else
                        modelAlert('Error While Scan');
                });
            }
            $selectScanDocument = function (base64Document) {
                var $selectedDocumentID = jQuery('#spnSelectedDocumentID').text().trim();
                jQuery('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                    if (this.innerHTML.trim() == $selectedDocumentID) {
                        jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML = base64Document;
                        jQuery('#imgDocumentPreview').attr('src', base64Document);
                        jQuery('#divScanViewer').closeModel();
                    }
                });
            }
            $showCaptureModel = function () {
                if (jQuery('#spnSelectedDocumentID').text() != '') {
                    document.getElementById('imgScanPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+XCanHAAAC1BJREFUeNrs3flT01wbxnGhFUT2vcoiZR9AdMQZ///f1QFEZZO9QIvUQilQ1uea3vMeM+lC1b4Pwef7+YEp6clJGnLl3ElLU5VIJB4B+BtVswkA4g2AeAMg3gCINwDiDYB4A8QbAPEGQLwBEG8AxBsA8QaINwDiDYB4AyDeAIg3AOINEG8AxBsA8QZAvAEQbwDEGwDxBog3AOINgHgDIN4AiDcA4g0QbwDEGwDxBkC8ARBvAMQbIN4AiDcA4g2AeAMg3gCINwDiDRBvAMQbAPEGQLwBEG8AxBsg3gCINwDiDYB4AyDeAIg3QLwBEG8AxBsA8QZAvAEQb4B4AyDeAIg3AOINgHgDIN4AiDdAvAEQbwDEGwDxBkC8ARBvgHgDIN4AAizMJnig9vf3V1dXSzR4/Pjx27dvQ6EQ24rRGw/M6elp6QaXOWwo4g2A4hz35/b2NpFIJJPJbDarxxcXF3fO8uXLl6qqqoosXf2o2m9paYlEIhT8D0WV9hi2QvBdXV0tLCycnJzc+5rU19dPT0+TcIpzVMz6+noQsi2ZTGZra4u/CPFGxRweHgZnZQ4ODviLEG9Usjj3/hoOh5ubm3UyfC8rU85pP4KAS2sPT3t7+9jYWHV19e3t7erqajwe/7U/eTjc1NSkU2g7OlxfX5+enh4dHRFa4o37Nzw8rGw/yl3NHhoaUql8c3NTzowNDQ29vb06OhS8nH58fByLxQJ1FgDi/d9ib1D9PLmqrg6FQnfGW22i0WgkEinRpiknlUqtrKxks1k2Nefe+LepIP/+/bv7VUX1nR9N0+Hg5cuXvmxbTZ7JZHyzt7S0vH79WuM8m5rRG/dgeXlZyVQC9XN7e/vOcXtqakpn2m5KIpHY399Pp9M6UtiUp0+fdnV1PXv2zN7N1uFgcnJyfn7+7OyMrU288a9SKV7+O8+Dg4Mu2yq5v379au+f6+ig6artLy4uVAJsbGzs7u6OjY01NzdbwsfHx2dnZ90hAMQbwdLY2Njd3e2yrQFZPzs7O1+8ePHkyRNvwa8hXQlfWFjQUG8JV/g1nivzbEbijSDq7e31lvTKdjQa7enpubq62tvb0zCuM3DlvK2tTUcBnXV/+vRpcXFxZmYmHA7b7GrGAE68ETg6kVZu7XEymVQFHolElG0NyJubmwq2a7mzs6Nsj46O6pT748eP+nVgYEDTa2pqmpqaNCMb84HiyvlfS8l072+r9tZptkK7vr6+trbmzbZJpVJzc3Nqr4Lc+5lTK9RBvBEs3rPr4+Pj1tZWZTgWixVrr9J9aWmpo6Mjm2MT6+rq2JLEG8E77wr/PPO6vLxUUDc2NkrPkk6n7c0w92a4fTwOxBvB4q3AFfVMJnN+fn7nXPaZGXdo4Loa8UYQeT9YWl9f/+PHj3LmUgGvbNfW1uZ3AuKNoFCl7R7rjLrMuTRct7W1uWtyOmlnSxJvBM7FxYVLeFdXl/dKWwkKdl9fnyvvNZizJYk3gsh95qy6unpkZKScr1WMRqPuank8Hs9/Cw3EG4FwcHDgquvm5uaJiQnv5fT8cXtgYOD58+f26+XlJd+pRrwRaMvLy+6LnFpbW9+8edPd3Z3/dpeeevXqle9DrL5vgMKDw4dS/3Ln5+efP3+enJy0cbumpkZV+uDgoEb1bDZ7c3OjKflf27ayslLmlXYQb9yndDo9Nzc3Pj7u/jM0FAppuC7YWDW5xm2yTbzxYJydnc3Ozuq8uqenR8N1wTbX19fxeFzn29TkxBsPzO3tbSwW293dbcnJ/6bUZDLJdXLijYcd8h85bIr/Aq6cPwyBuqcX/2dCvFFJ7osZgoB/AifeqKT+/v6ADOBaDfsuFwQfNwB+ME5PTzc2NlKpVJn3JKm4cDisIkIHmjI/vg7iDYDiHADxBkC8AeINgHgDIN4AiDcA4g2AeP9Vstns0dFRAL+K3Lti5axksTZXV1eanslk+FsT7/+Lra2tLzluJ0skEvo1CJ/2Ozw8XFhY0M+gbTTvipWzksXaaJtr+ubmJvvh7+H/ve9wcnJi/x2tkWR6etoeaEpLS8u9r1t7e3t9fX0APwEe2BUj3igsnU5rJO/v7/dN1zCeSqWUee3N2q3z/1lSNafGpXA4HAqF9EAtu7u71fLR/76HvKurK5lM2gObaDcPUIc9PT21tbXWTLPYvYHcXOfn51ZT2HQ9jsfjdiOxjo4ONbBF61f7emMrdBU8raTvqfyXo8cNDQ0WVLVUe5vR2qiBHutFaYk6Aj7K/cOJ2ltvvhVztALqytZQr0492HZwpbi9dnWlF+6+Gc4rf+OwZ1Kc/6nOzk793N7e9t3LXoF3Xyq6t7dXsMLU3ry+vq5msVjMRv7FxUXrZz1nfn5ez9q9+1T2a8pVjjqcnZ3VA+vBelZs9Hh/f9/uCqjHFiR1qMZ2a24didShkqC9X+usNnZaqypXjxVIa6/HlkwvrYZN1EI1r16RVuD6+trN6FZbK2BtbKIWrYl26PGumK/YtjW0V+e2g1FXdmRRG1uub/aCG4edk9H7T2m8tWR++/bN3a9LU7RHai+fmZnRT+2p2imVYe+I5LS2tk5MTNj4Y1l143xvb69yqB40UYvQoWR0dFTT19bWtBNrqFSHeqDgaWy0kEciEV//doI6NTWlQU9hfv/+vdZN7dWb5tW6abpir6UoPIODg5bh/FOMoaEhrYxemqKoF3t2dqYHbW1tbkZ1pWf1ctRM9ci7d+/sQKOu9LqUT1854CvaXR2hg4U61IxuO0SjUXtWMdZ2UEXjHZyLbZwSiwPxLpf2qg8fPmh3d+OVjU6NjY32FeK2m3pv3FeQ1Zzee/FaTW47vQ2DNsQ56rmurk49K7c2yOcfQWy5GtC8ta7NqxgozLbEvr4+hVALsnjnfwmMntrZ2bG7fP/cS8JhO0wocjajO8YpZr61LUGrtLS0dOcm0pFCSVZjb7ytAMnfOCDeldhS4fDw8LDqSe8UlyL3oMRdfry7aYlmCpKKBferXaDScK1YqjRQ8NQg/5xTHWoFxsfHfT3bgcDOVzXk6lBitYMypn58jbVuqup1KFEVoOOCjaKuH8Vb/WiK5rJDks5NFDaNunpWhw8VL6Vfu7Kt9ddKqnMNvFqTgs1K3Ie84MYB594VoJ3YTsLdOGyDquptDXoax9xZesGByy4s2T5d8MK7RVH5sbpAsxzmuKcUsGLz2nJV8dpRxkpr99RZjma0cdgGwIaGhmK5skV7Y2YVhGbUU+41WgO7OuC7KlGQFQU6k9fq5d971DrRxrSX6atQSmwcMHpXhk4+rW60X8fGxjQiuVFIw2P+pXW3Z7vBTRWyK8i9NCZrZLMLYG7iyMiIPaXOvSOnjy1XwXDjrbvRp1JtebaE+H71nQXYUlSk6KTD96xVEHYlwl2S0NFtO6fYcc1L47xdZdSryO9fgbdg61m11Ev2Hl9KbBwUw5cxVYDGE3tjrOD7NHbJTbEZGhrS/lqsWX6Hj379O0ntkphVrb/9ppH1UPB9qWJLVOM7z0pc/a+NUOx12bOle/vtjcPojd9RZhJqcyrYYcELBH++0//S0n91iaU3Qjmb6Lc3DvFG5WkgValZ5uAGUJwDuBtXzgHiDYB4AyDeAIg3AOINgHgDxBsA8QZAvAEQbwDEGwDxBog3AOINgHgDIN4AiDcA4g0QbwDEGwDxBkC8ARBvAMQbAPEGiDcA4g2AeAMg3gCINwDiDRBvAMQbAPEGQLwBEG8AxBsg3gCINwDiDYB4AyDeAIg3AOINEG8AxBsA8QZAvAEQbwDEGyDeAIg3AOINgHgDIN4AiDdAvAEQbwDEGwDxBkC8ARBvgHgDIN4AiDcA4g2AeAMg3gCIN0C8ARBvAMQbAPEGQLwBFPSPAAMA10pqClMkh7QAAAAASUVORK5CYII=';
                    jQuery('#divDocumentCapture').showModel();
                    Webcam.set({
                        width: 320,
                        height: 240,
                        image_format: 'jpeg',
                        jpeg_quality: 90,
                        //force_flash: true
                    });
                    Webcam.setSWFLocation("../../Scripts/webcamjs/webcam.swf");
                    Webcam.attach('#documentWebCam');
                }
                else
                    modelAlert('Please Select Document First !!');
            }
            $takeProfilePictureSnapShot = function () {
                Webcam.snap(function (data_uri) {
                    jQuery('#imgPreview').attr('src', data_uri);
                    jQuery('#btnSelectImage').show();
                });
            }
            $selectPatientProfilePic = function (base64Image) {
                $closeCamViewerModel(function () {
                    document.getElementById('imgPatient').src = base64Image
                    jQuery('#spnIsCapTure').text('1');
                });
            }
            $takeDocumentSnapShot = function () {
                Webcam.snap(function (data_uri) {
                    jQuery('#imgDocumentSnapPreview').attr('src', data_uri);
                    jQuery('#btnSelectDocumentCapture').show();
                });
            }
            selectDocumentCapture = function (base64Document) {
                var $selectedDocumentID = jQuery('#spnSelectedDocumentID').text().trim();
                jQuery('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                    if (this.innerHTML.trim() == $selectedDocumentID) {
                        jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML = base64Document;
                        jQuery('#imgDocumentPreview').attr('src', base64Document);
                        jQuery('#divDocumentCapture').closeModel();
                    }
                });
                Webcam.reset();
            }
            $closeDocumentCapture = function () {
                jQuery('#divDocumentCapture').closeModel();
                document.getElementById('imgDocumentSnapPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
                Webcam.reset();
            }
            $closePatientDocumentModel = function () {
                $getUpdatedPatientDocuments(function ($responseData) {
                    jQuery('#spnDocumentCounts').text($responseData.length);
                    jQuery('#divDocumentMaters').closeModel();
                });
            }
            $closePatientManualDocModel = function () {
                jQuery('#divDocumentMaualMaters').closeModel();
            }
            $getUpdatedPatientDocuments = function (callback) {
                var $patientDocuments = [];
                jQuery('#tblDocumentMaster tr td#tdDocumentID').each(function () {
                    if (jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim() != '') {
                        var $document = {
                            documentId: this.innerHTML.trim(),
                            name: jQuery(this.parentNode).find('#btnDocumentName').val(),
                            data: jQuery(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim()
                        }
                        $patientDocuments.push($document);
                    }
                });
                callback($patientDocuments);
            }
    
        //ashma
          
            $saveMaualDocument = function () {
                jQuery('#ddlDocumentType').val(16);
                jQuery('#ddlDocumentType').attr('disabled', 'disabled');
                //if (jQuery("#ddlDocumentType").val() == "0") {
                //    toast("Error", "Please Select Document Type", "");
                //    jQuery("#ddlDocumentType").focus();
                //    return;
                //}
                if (jQuery("#fileManualUpload").val() == '') {
                    toast("Error", "Please Select File to Upload", "");
                    jQuery("#fileManualUpload").focus();
                    return;
                }
                var $validFilesTypes = ["doc", "docx", "pdf", "jpg", "png", "gif", "jpeg", "xlsx"];
                var $extension = jQuery('#fileManualUpload').val().split('.').pop().toLowerCase();
                if (jQuery.inArray($extension, $validFilesTypes) == -1) {
                    toast("Error", "".concat("Invalid File. Please upload a File with", " extension:\n\n", $validFilesTypes.join(", ")), "");
                    return;
                }
                var $maxFileSize = 10485760; // 10MB -> 10 * 1024 * 1024  
                var $fileUpload = jQuery('#fileManualUpload');
                if ($fileUpload[0].files[0].size > $maxFileSize) {
                    toast("Error", "You can Upload Only 10 MB File", "");
                    return;
                }
                var $MaualDocumentID = [];
                if (jQuery("#tblMaualDocument").find('tbody tr').length > 0) {
                    jQuery("#tblMaualDocument").find('tbody tr').each(function () {
                        $MaualDocumentID.push(jQuery(this).closest('tr').find("#tdMaualDocumentID").text());
                    });
                }
                if ($MaualDocumentID.length > 0) {
                    if (jQuery.inArray(jQuery("#ddlDocumentType").val(), $MaualDocumentID) != -1) {
                        toast("Error", "Document already Saved", "");
                        return;
                    }
                }


                var panelId;
                var oldPatient;
                if ($('#lblPanelID').text() != "") {
                    panelId = $('#lblPanelID').text();
                    oldPatient = 1;
                }
                else {
                    panelId = -60;
                    oldPatient = 0;
                }

                var formData = new FormData();
                formData.append('file', jQuery('#fileManualUpload')[0].files[0]);
                formData.append('documentID', jQuery('#ddlDocumentType').val());
                formData.append('documentName', jQuery('#ddlDocumentType option:selected').text());
                formData.append('Filename', jQuery('#spnFileName').text());
                formData.append('Patient_ID', panelId);
                formData.append('LabNo', "");
                jQuery.ajax({
                    url: '../../PanelFileUploadHandler.ashx',
                    type: 'POST',
                    data: formData,
                    cache: false,
                    contentType: false,
                    processData: false,
                    success: function (data, status) {
                        $DocumentID.push(data);
                        $("#fileProgress").hide();
                        if (status != 'error') {
                            toast("Success", "Uploaded Successfully", "");
                            var _temp = [];
                            
                            _temp.push(serverCall('../Common/Services/CommonServices.asmx/bindmanualDocument', { labno: '', Filename: jQuery('#spnFileName').text(), PatientID: panelId, oldPatientSearch: oldPatient, documentDetailID: data, isEdit: 0 }, function (response) {
                                jQuery.when.apply(null, _temp).done(function () {
                                    var maualDocument = JSON.parse(response);
                                    $addPatientDocumnet(maualDocument, 0);
                                    jQuery("#fileManualUpload").val('');
                                    jQuery("#ddlDocumentType").prop('selectedIndex', 0);
                                    jQuery('#spnDocumentMaualCounts').text(jQuery("#tblMaualDocument tr").length - 1);
                                });
                            }));
                        }
                    },
                    xhr: function () {
                        var fileXhr = $.ajaxSettings.xhr();
                        if (fileXhr.upload) {
                            $("progress").show();
                            fileXhr.upload.addEventListener("progress", function (e) {
                                if (e.lengthComputable) {
                                    $("#fileProgress").attr({
                                        value: e.loaded,
                                        max: e.total
                                    });
                                }
                            }, false);
                        }
                        return fileXhr;
                    }
                });
              
                
            }
            $removeMaualDocument = function (rowID) {
                serverCall('../Common/Services/CommonServices.asmx/deletePatientDocument', { deletePath: jQuery(rowID).closest('tr').find("#tdManualFileURL").text(), ID: jQuery(rowID).closest('tr').find("#tdMaualID").text() }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        jQuery(rowID).closest('tr').remove();
                        toast("Success", $responseData.response, "");
                        jQuery('#spnDocumentMaualCounts').text(jQuery("#tblMaualDocument tr").length - 1);
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                });
            }
            $manualViewDocument = function (rowID) {
                serverCall('PUPMaster.aspx/manualEncryptDocument', { fileName: jQuery(rowID).closest('tr').find("#tdMaualAttachedFile").text(), filePath: jQuery(rowID).closest('tr').find("#tdManualFileURL").text() }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        PostQueryString($responseData, '../Lab/ViewDocument.aspx');
                    }
                });
            }
        //ashma 
            $bindDocumentMasters(function (callback) {
                jQuery('#ddlDocumentType').val(16);
                jQuery('#ddlDocumentType').attr('disabled', 'disabled');
                $getCentreData("1", function (callback) {
                    $bindSpecialCharater(function (callback) {
                    });
                    $bindOutstandingAmt(function (callback) {
                    });
                    $bindSlide(function (callback) {
                    });
                    $getCurrencyDetails(function (baseCountryID) {
                        $getConversionFactor(baseCountryID, function (CurrencyData) {
                            jQuery('#spnCFactor').text(CurrencyData.ConversionFactor);
                            jQuery('#spnConversion_ID').text(CurrencyData.Converson_ID);
                            jQuery('#spnConvertionRate').text("".concat('1 ', jQuery('#ddlCurrency option:selected').text(), ' = ', precise_round(CurrencyData.ConversionFactor, '<%=Resources.Resource.BaseCurrencyRound%>'), ' ', jQuery('#spnBaseNotation').text()));

                                });
                            });
                        });
          });
    </script>
     <script id="template_DocumentMaster" type="text/html">
		<table cellspacing="0" cellpadding="4" rules="all" border="1"    id="tblDocumentMaster" border="1" style="background-color:White;border-color:Transparent;border-width:1px;border-style:None;width:100%;border-collapse:collapse;">       
				<tr>
					<td style="border:solid 1px transparent"><input type="button"    value="Document Name"  id="Button1" title="" class="btn" style="font-size: 20px;color:white;background-color:#2C5A8B; width:100%;text-align:center; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"></td>					
				</tr>				   
			<#
			 var dataLength=documentMaster.length;        
			 var objRow;    			
				for(var j=0;j<dataLength;j++)
				{
					objRow = documentMaster[j];
				#>          
				<tr id="tr_<#=(j+1)#>">
					<td style="border:solid 1px transparent"><button type="button" value="<#=objRow.Name#>"  id="btnDocumentName" title="<#=objRow.Name#>" class="btnDocumentName" style="width:100%;text-align:center; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" onclick="$documentNameClick(this, this.parentNode.parentNode)">
					   <span style="float: right;font-size: 10px;"  class="badge badge-avilable clSpnDocumentName" ><#=objRow.ExitsCount#></span>  <#=objRow.Name#>
						</button>
						</td>
					<td id="tdDocumentID" class="<#=objRow.ID#>" style="display:none"><#=objRow.ID#>
					</td>
					<td id="tdBase64Document" class="<#=objRow.ID#>" style="display:none"></td>
				</tr>
			<#}#>            
		 </table>    
	</script>  
    
</asp:Content>

