<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="VendorMaster.aspx.cs" Inherits="Design_Store_VendorMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <%: Scripts.Render("~/bundles/JQueryStore") %>




    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Supplier Master</b>
            <span id="spnError"></span>
        </div>
        <div id="makerdiv">
            <div class="POuter_Box_Inventory">
                
                <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('1')">
                    Supplier Detail
                </div>

            </div>
            <div class="POuter_Box_Inventory" id="tab1" >

                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Supplier Name   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtVendorName" runat="server" ClientIDMode="Static" CssClass="requiredField TextDecoration"></asp:TextBox>
                        <span id="vendorid" style="display: none;"></span>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Supplier Code  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtSupplierCode" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Supplier Type   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:DropDownList ID="ddlsuppliertype" CssClass="requiredField" runat="server">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="Capex">Capex</asp:ListItem>
                            <asp:ListItem Value="Opex">Opex</asp:ListItem>
                            <asp:ListItem Value="Both">Both</asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-2 ">
                        <asp:CheckBox ID="ChkActivate" runat="server" Checked="True" ForeColor="Red" Text="Active" Style="font-weight: 700" />
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Supplier Category   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:DropDownList ID="ddlsupplier" CssClass="requiredField" runat="server"></asp:DropDownList>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Organization Type  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:DropDownList ID="ddlSupplierOrganizationType" CssClass="requiredField" runat="server"></asp:DropDownList>
                    </div>


                </div>

                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">House No/Office No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtHouseNoOfficeNo" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Street/Building/Loc</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtStreetBuildingLocality" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Country  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:DropDownList ID="ddlCountry" runat="server"></asp:DropDownList>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">State  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:DropDownList ID="ddlState" runat="server"></asp:DropDownList>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Pin Code  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtPin" runat="server" MaxLength="6"> </asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender4" runat="server" FilterType="Numbers" TargetControlID="txtPin" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Landline  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtLandline" runat="server"></asp:TextBox>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Fax No.

                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtFaxNo" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Email Id   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtEmailID" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Website  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <span style="color: red" id="errmsg">
                            <asp:TextBox ID="txtWebsite" runat="server"></asp:TextBox></span>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Oracle Vendor Code  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtOracleVendorCode" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left ">Oracle Vendor Site   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4 ">
                        <asp:TextBox ID="txtOracleCustomerSite" runat="server"></asp:TextBox>
                    </div>


                </div>




            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('2')">
                    Concern Person Details
                </div>
            </div>
           
            <div class="tab " id="tab2" >
                 <div class="POuter_Box_Inventory" >
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Primary Contact  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtPrimaryContactPerson" CssClass="requiredField" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Designation   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtDesignationp" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Mobile No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtMobileNop" runat="server" MaxLength="10"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers" TargetControlID="txtMobileNop" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Email Id   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtEmailIdp" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Secondary Contact   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtSecondaryContactPerson" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Designation   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtDesignations" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Mobile No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtMobileNos" MaxLength="10" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender3" runat="server" FilterType="Numbers" TargetControlID="txtMobileNos" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Email Id   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtEmailIds" runat="server"></asp:TextBox>
                        </div>
                    </div>
                </div>

            </div>
        

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('3')">
                Statutory/MSME/PAN Registration Information
            </div>
            </div>
            <div class="tab" id="tab3" >
               <div class="POuter_Box_Inventory" >
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">TAN No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtCINNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">PF Registartion No.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtPFRegistartionNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Name on PAN Card   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtNameonPANCard" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">PAN Card No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtPANCardNo" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">ROC No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtROCNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">ESI Registration No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtESIRegistrationNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">ISO Certification No.   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtISOCertificationNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Valid Upto   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtISOCertificationNoValidUpto" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtISOCertificationNoValidUpto" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left">Pollution control Board Certification No.   </label>

                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtPollutioncontrolBoardCertificationNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Valid Upto   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtPollutioncontrolBoardCertificationNoValidUpto" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtPollutioncontrolBoardCertificationNoValidUpto" runat="server" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3 ">
                            <asp:CheckBox ID="chMSMERegistration" runat="server" Text="MSME Registration:" onclick="setmsme(this)" />
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtmsmeregistrationno" runat="server" Enabled="false"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Valid Upto   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtmsmeregistrationnoValidUpto" runat="server" Enabled="false"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtISOCertificationNoValidUpto0_CalendarExtender" TargetControlID="txtmsmeregistrationnoValidUpto" Format="dd-MMM-yyyy" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>

            </div>
       

        <div id="Div2" class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('4')">
                Bank Details
            </div>
 </div>
            <div class="tab" id="tab4">
                 <div class="POuter_Box_Inventory" >
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Bank 1   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtBanker1" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Branch   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtBranchBanker1" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Bank Accounts No.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtBankAccountsNoBanker1" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">RTGS/IFSC Code   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtRTGSIFSCCodeBanker1" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Address  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtAddress1Banker1" runat="server" placeholder="Address1"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtAddress2Banker1" runat="server" placeholder="Address2"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtcityBanker1" runat="server" placeholder="City"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtstateBanker1" runat="server" placeholder="State"></asp:TextBox>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left">Banker2 </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtBanker2" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Branch   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtBranchBanker2" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left">Bank Accounts No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtBankAccountsNoBanker2" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">RTGS/IFSC Code   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtRTGSIFSCCodeBanker2" runat="server"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Address   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtAddress1Banker2" runat="server" placeholder="Address1"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtAddress2Banker2" runat="server" placeholder="Address2"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtcityBanker2" runat="server" placeholder="City"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtstateBanker2" runat="server" placeholder="State"></asp:TextBox>
                        </div>

                    </div>


                </div>

            </div>
        

        <div  class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('5')">
                Financial Details
            </div>
             </div>
            <div class="tab" id="tab5" >
                <div class="POuter_Box_Inventory" >
                    <div class="row">
                        <div class="col-md-2 ">
                            <asp:DropDownList ID="ddlyear" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-4 ">
                            <asp:TextBox ID="txttrunover" runat="server" placeholder="Annual turnover in Lacks"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers,Custom" TargetControlID="txttrunover" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-2 ">
                             <input type="button" value="Add" onclick="addfidetail()" style="font-weight: bold; cursor: pointer;" />
                            </div>
                         <div class="col-md-2 ">
                             </div>
                         <div class="col-md-14 ">
                             <table id="tableFinancial" style="width: 100%; border-collapse: collapse">

                                <tr id="tableFinancialheader">
                                    <th class="GridViewHeaderStyle" align="left">S.No.</th>
                                    <th class="GridViewHeaderStyle" align="left">Financial Year</th>
                                    <th class="GridViewHeaderStyle" align="left">Annual turnover in Lacks</th>
                                    <th class="GridViewHeaderStyle" align="left">Remove</th>
                                </tr>
                            </table>
                             </div>
                    </div>
                    
                </div>

            </div>
       

        <div  class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('6')">
                GST Details
            </div>
             </div>
            <div class="tab" id="tab6" >
                <div class="POuter_Box_Inventory" >
                    <div class="row">
                        <div class="col-md-3 ">
                            <asp:DropDownList ID="ddlstategstn" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-4 ">
                            <asp:TextBox ID="txtaddressgstn" runat="server" placeholder="Address"></asp:TextBox>
                        </div>
                        <div class="col-md-4 ">
                             <asp:TextBox ID="txtgstno" runat="server" placeholder="GSTN No"></asp:TextBox>
                            </div>
                        <div class="col-md-1 ">
                             <input type="button" value="Add" onclick="addgstdetail()" style="font-weight: bold; cursor: pointer;" />
                            </div>
                         <div class="col-md-12 ">
                            <table id="tableGst" style="width: 100%; border-collapse: collapse">
                                <tr id="tableGstheader">
                                    <th class="GridViewHeaderStyle" align="left">S.No.</th>
                                    <th class="GridViewHeaderStyle" align="left">State</th>
                                    <th class="GridViewHeaderStyle" align="left">Address</th>
                                    <th class="GridViewHeaderStyle" align="left">GSTN No.</th>
                                    <th class="GridViewHeaderStyle" align="left">Remove</th>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                </div>
            </div>
        <div  class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('7')">
                Term &amp; Conditions
            </div>
             </div>
            <div class="tab" id="tab7" >
                <div class="POuter_Box_Inventory" >
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Payment Terms   
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2 ">
                            <asp:TextBox runat="server" TextMode="MultiLine" ID="txtPaymentTerms" Height="40px" Width="110px"></asp:TextBox>
                        </div>
                        <div class="col-md-2 ">
                            <label class="pull-left ">Taxes   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2 ">
                            <asp:TextBox runat="server" TextMode="MultiLine" ID="txttaxes" Height="40px" Width="110px"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Delivery Terms </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2 ">
                            <asp:TextBox runat="server" TextMode="MultiLine" ID="txtdeliverytems" Height="40px" Width="110px"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Vendor To Notes  </label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-2 ">
                            <asp:TextBox runat="server" TextMode="MultiLine" ID="txtvendortonotes" Height="40px" Width="110px"></asp:TextBox>
                        </div>
                        <div class="col-md-2 ">
                            <label class="pull-left ">Credit Limit   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2 ">
                            <asp:TextBox ID="txtCreditLimit" MaxLength="2" runat="server" placeholder="Months"></asp:TextBox>
                        </div>
                    </div>

                </div>

            </div>
      

        <div  class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('9')">
                Login and Auto PO Close Detail
            </div>
            </div>
            <div class="tab" id="tab9" >
                <div  class="POuter_Box_Inventory">
                    <div class="row">
                        <div class="col-md-4 ">
                            <asp:CheckBox runat="server" ID="chloginrequired" Text="Is Login Required"  Font-Bold="true"></asp:CheckBox>
                        </div>
                        <div class="col-md-2 ">
                            <label class="pull-left ">User Name   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:TextBox runat="server" ID="txtusername" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-2 ">
                            <label class="pull-left ">Password  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 ">
                            <asp:TextBox runat="server" TextMode="Password" ID="txtpassword" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Confirm Password   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox runat="server" TextMode="Password" ID="txtcpassword" MaxLength="20"></asp:TextBox>
                        </div>
                        </div>
                        <div class="row">
                        <div class="col-md-3 ">
                            <asp:CheckBox runat="server" ID="chlautorejectpo" Text="Auto Close PO" Font-Bold="true" ></asp:CheckBox>
                        </div>
                        <div class="col-md-4 ">
                            <label class="pull-left ">Close PO After (In Days)  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2 ">
                            <asp:TextBox runat="server" ID="txtrejectionday"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender5" runat="server" FilterType="Numbers" TargetControlID="txtrejectionday" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>

                </div>

            </div>
       


        <div  class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('8')">
                Add Document
            </div>
             </div>
            <div class="tab" id="tab8" >
                <div  class="POuter_Box_Inventory">
                 <div class="row">
                <div class="col-md-24" style="text-align:center">
                    
                            <input type="button" value="Add Document" class="searchbutton" onclick="uploaddocument();" id="btnupdate1" />
                       
                </div>
                     </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align:center">
            <div class="row" >
                <div class="col-md-24">
                    
                            <input type="button" value="Save" class="savebutton" onclick="savenewitem();" id="btnsave" />
                            <input type="button" value="Update" class="savebutton" onclick="updateitem();" id="btnupdate" style="display: none;" />
                            <input type="button" value="Reset" class="resetbutton" onclick="clearForm();" />
                        </div>
                    </div>
                </div>

            
   

    </div>

                   
        <div class="POuter_Box_Inventory" style="text-align: center">

            <div class="row" >
                <div class="Purchaseheader" style="cursor: pointer;">
                    <table>
                        <tr>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No. of Record:&nbsp;&nbsp;</td>
                            <td>
                                <asp:DropDownList ID="ddlnoofrecord" runat="server" Width="80" Font-Bold="true">
                                    <asp:ListItem Value="5">5</asp:ListItem>
                                    <asp:ListItem Value="10">10</asp:ListItem>
                                    <asp:ListItem Value="20">20</asp:ListItem>
                                    <asp:ListItem Value="50">50</asp:ListItem>
                                    <asp:ListItem Value="100">100</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Created</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Checked</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>Approved</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>


    <div class="POuter_Box_Inventory" style="text-align: center">
        <div id="Div11" class="POuter_Box_Inventory">
            <div class="row" style="margin-top: 0px;">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3 ">
                            <label class="pull-left ">Supplier Category</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:DropDownList ID="ddlsuppliersearch" ClientIDMode="Static" runat="server" CssClass="textbox">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 ">
                            <label class="pull-left ">Organization Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 ">
                            <asp:DropDownList ID="ddlSupplierOrganizationTypesearch" ClientIDMode="Static" runat="server" CssClass="textbox">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 ">
                            <asp:DropDownList ID="ddlserchtype" runat="server">
                                <asp:ListItem Value="vm.SupplierName">Supplier Name</asp:ListItem>
                                <asp:ListItem Value="im.SupplierCode">Supplier Code</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 ">
                            <asp:TextBox ID="txtsearchvalue" runat="server" />
                        </div>
                        <div class="col-md-2 ">
                            <label class="pull-left ">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2 ">
                            <asp:DropDownList ID="ddlstatus" ClientIDMode="Static" runat="server" CssClass="textbox">
                                <asp:ListItem Value="">All</asp:ListItem>
                                <asp:ListItem Value="0">Created</asp:ListItem>
                                <asp:ListItem Value="1">Checked</asp:ListItem>
                                <asp:ListItem Value="2">Approved</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-2 ">
                            <input type="button" value="Search" class="searchbutton" onclick="searchitem()" />
                            <input type="button" value="Excel" class="searchbutton" onclick="searchitemexcel()" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24 ">
                            <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                                <tr id="triteheader">
                                    <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                    <td class="GridViewHeaderStyle" style="width: 30px;">Select</td>
                                    <td class="GridViewHeaderStyle" style="width: 30px;">Check</td>
                                    <td class="GridViewHeaderStyle" style="width: 30px;">Approve</td>
                                    <td class="GridViewHeaderStyle">Supplier Category</td>
                                    <td class="GridViewHeaderStyle">Supplier Name</td>
                                    <td class="GridViewHeaderStyle">Supplier Code</td>
                                    <td class="GridViewHeaderStyle">Supplier Type</td>
                                    <td class="GridViewHeaderStyle">Address</td>
                                    <td class="GridViewHeaderStyle">Primary Contact</td>
                                    <td class="GridViewHeaderStyle">Contact No</td>
                                    <td class="GridViewHeaderStyle">Email</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>



    <script type="text/javascript">

        var approvaltypemaker = '<%=approvaltypemaker %>';
        var approvaltypechecker = '<%=approvaltypechecker %>';
        var approvaltypeapproval = '<%=approvaltypeapproval %>';

        var currentTab = 1;
        $(document).ready(function () {

            $('.tab').hide();

            if (approvaltypemaker == "1") {
                $('#makerdiv').show();
            }
            else {
                $('#makerdiv').hide();
            }

        });

        function showhide(n) {
            $('#tab' + n).slideToggle("fast");



        }

        function nextPrev(n) {
            $('.tab').hide();
            $('#tab' + n).show();

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
        function addfidetail() {

            if ($('#<%=txttrunover.ClientID%>').val() == "") {
                toast("Error", "Please Enter TurnOver", "");
                $('#<%=txttrunover.ClientID%>').focus();
                return;
            }

            var id = $('#<%=ddlyear.ClientID%>').val() + "_" + $('#<%=txttrunover.ClientID%>').val();

            if ($('table#tableFinancial').find('#' + id).length > 0) {
                toast("Error", "Data Already Added", "");

                return;
            }

            var a = $('#tableFinancial tr').length - 1;

            var $mydata = [];
            $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle id='); $mydata.push(id); $mydata.push("'>");
            $mydata.push('<td  align="left" >'); $mydata.push(parseFloat(a + 1)); $mydata.push('</td>');
            $mydata.push('<td  align="left" id="tdyear">'); $mydata.push($('#<%=ddlyear.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdtrunover">'); $mydata.push($('#<%=txttrunover.ClientID%>').val()); $mydata.push('</td>');
            $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow1(this)"/></td>');

            $mydata.push("</tr>");

            $mydata = $mydata.join("");
            jQuery('#tableFinancial').append($mydata);

            $('#<%=ddlyear.ClientID%>').prop('selectedIndex', 0);
                $('#<%=txttrunover.ClientID%>').val('');


        }

        function deleterow1(itemid) {
            var table = document.getElementById('tableFinancial');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

        }

        function addgstdetail() {

            if ($('#<%=txtgstno.ClientID%>').val() == "") {
                    toast("Error", "Please Enter GSTN No.", "");
                    $('#<%=txtgstno.ClientID%>').focus();
                    return;
                }
                if ($('#<%=ddlstategstn.ClientID%>').val() == "0") {
                    toast("Error", "Please Select State For GSTN No.", "");
                    $('#<%=ddlstategstn.ClientID%>').focus();
                    return;
                }
                var id = $('#<%=ddlstategstn.ClientID%>').val() + "_" + $('#<%=txtgstno.ClientID%>').val();

                if ($('table#tableGst').find('#' + id).length > 0) {
                    toast("Error", "Data Already Added", "");
                    return;
                }

                var a = $('#tableGst tr').length - 1;

                var $mydata = [];

                $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push(id); $mydata.push('>');

                $mydata.push('<td  align="left" >'); $mydata.push(parseFloat(a + 1)); $mydata.push('</td>');
                $mydata.push('<td align="left" id="tdstategstn">'); $mydata.push($('#<%=ddlstategstn.ClientID%> option:selected').text()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdaddressgstn">'); $mydata.push($('#<%=txtaddressgstn.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdgstn">'); $mydata.push($('#<%=txtgstno.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdstategstnid" style="display:none;">'); $mydata.push($('#<%=ddlstategstn.ClientID%>').val()); $mydata.push('</td>');

                $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow2(this)"/></td>');


                $mydata.push('</tr>');
                $mydata = $mydata.join("");
                jQuery('#tableGst').append($mydata);

                $('#<%=ddlstategstn.ClientID%>').prop('selectedIndex', 0);
                $('#<%=txtgstno.ClientID%>').val('');
                $('#<%=txtaddressgstn.ClientID%>').val('');


            }

            function deleterow2(itemid) {
                var table = document.getElementById('tableGst');
                table.deleteRow(itemid.parentNode.parentNode.rowIndex);

            }

    </script>


    <script type="text/javascript">

        function validation() {

            if ($('#<%=txtVendorName.ClientID%>').val() == "") {
                    toast("Error", "Please Select  Supplier Name", "");
                    $('#<%=txtVendorName.ClientID%>').focus();
                    return false;
                }
                if ($('#<%=ddlsuppliertype.ClientID%>').val() == "0") {
                    toast("Error", "Please Select  Supplier Type", "");


                    $('#<%=ddlsuppliertype.ClientID%>').focus();
                        return false;
                    }



                    if ($('#<%=txtEmailID.ClientID%>').val().length > 0) {
                    var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

                    if (!filter.test($('#<%=txtEmailID.ClientID%>').val())) {
                        toast("Error", "Please provide valid email address", "");
                        $('#<%=txtEmailID.ClientID%>').focus();
                        return false;
                    }
                }
                if ($('#<%=txtEmailIdp.ClientID%>').val().length > 0) {
                    var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

                    if (!filter.test($('#<%=txtEmailIdp.ClientID%>').val())) {
                        toast("Error", "Please provide valid email address", "");
                        $('#<%=txtEmailIdp.ClientID%>').focus();
                        return false;
                    }
                }
                if ($('#<%=txtEmailIds.ClientID%>').val().length > 0) {
                    var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

                    if (!filter.test($('#<%=txtEmailIds.ClientID%>').val())) {
                        toast("Error", "Please provide valid email address", "");
                        $('#<%=txtEmailIds.ClientID%>').focus();
                        return false;
                    }
                }

                if ($('#<%=ddlsupplier.ClientID%>').val() == "0") {
                    toast("Error", "Please Select Supplier Category", "");

                    $('#<%=ddlsupplier.ClientID%>').focus();
                    return false;
                }
                if ($('#<%=ddlSupplierOrganizationType.ClientID%>').val() == "0") {
                    toast("Error", "Please Select  Organization Type", "");


                    $('#<%=ddlSupplierOrganizationType.ClientID%>').focus();
                        return false;
                    }





                    if ($('#<%=txtPrimaryContactPerson.ClientID%>').val() == "") {
                    toast("Error", "Please  Enter Primary Contact Person", "");

                    showhide('2');
                    $('#<%=txtPrimaryContactPerson.ClientID%>').focus();
                    return false;
                }




                if (($('#<%=chloginrequired.ClientID%>').prop('checked') == true) && $('#<%=txtusername.ClientID%>').val() == "") {
                    toast("Error", "Please Enter UserName", "");
                    showhide('9');
                    $('#<%=txtusername.ClientID%>').focus();
                    return false;
                }

                if (($('#<%=chloginrequired.ClientID%>').prop('checked') == true) && $('#<%=txtpassword.ClientID%>').val() == "") {
                    toast("Error", "Please Enter Password", "");
                    showhide('9');
                    $('#<%=txtpassword.ClientID%>').focus();
                    return false;
                }

                if (($('#<%=chloginrequired.ClientID%>').prop('checked') == true) && $('#<%=txtpassword.ClientID%>').val() != $('#<%=txtcpassword.ClientID%>').val()) {
                    toast("Error", "Password Not Matched", "");
                    showhide('9');
                    $('#<%=txtpassword.ClientID%>').focus();
                    return false;
                }

                if (($('#<%=chlautorejectpo.ClientID%>').prop('checked') == true) && $('#<%=txtrejectionday.ClientID%>').val() == "") {
                    toast("Error", "Please Enter PO Close After Day", "");
                    showhide('9');
                    $('#<%=txtrejectionday.ClientID%>').focus();
                    return false;
                }


                if (($('#<%=chMSMERegistration.ClientID%>').prop('checked') == true) && $('#<%=txtmsmeregistrationno.ClientID%>').val() == "") {
                    toast("Error", "Please Enter MSME Registration No.", "");
                    showhide('3');
                    $('#<%=txtmsmeregistrationno.ClientID%>').focus();
                    return false;
                }

                if (($('#<%=chMSMERegistration.ClientID%>').prop('checked') == true) && $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').val() == "") {
                    toast("Error", "Please Select  MSME Registration Valid Date", "");
                    showhide('3');
                    $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').focus();
                    return false;
                }

                return true;
            }

            function VendorMaster() {



                var objVendormaster = new Object();
                if ($('#vendorid').html() == "") {
                    objVendormaster.SupplierID = "0";
                }
                else {
                    objVendormaster.SupplierID = $('#vendorid').html();
                }


                objVendormaster.SupplierName = $('#<%=txtVendorName.ClientID%>').val();
                    objVendormaster.SupplierCode = $('#<%=txtSupplierCode.ClientID%>').val();
                    objVendormaster.SupplierType = $('#<%=ddlsuppliertype.ClientID%>').val();
                    objVendormaster.SupplierCategory = $('#<%=ddlsupplier.ClientID%>').val();
                    objVendormaster.OrganizationType = $('#<%=ddlSupplierOrganizationType.ClientID%>').val();
                    objVendormaster.HouseNo = $('#<%=txtHouseNoOfficeNo.ClientID%>').val();
                    objVendormaster.Street = $('#<%=txtStreetBuildingLocality.ClientID%>').val();
                    objVendormaster.Country = $('#<%=ddlCountry.ClientID%>').val();
                    objVendormaster.State = $('#<%=ddlState.ClientID%>').val();
                    objVendormaster.PinCode = $('#<%=txtPin.ClientID%>').val();
                    objVendormaster.Landline = $('#<%=txtLandline.ClientID%>').val();
                    objVendormaster.FaxNo = $('#<%=txtFaxNo.ClientID%>').val();
                    objVendormaster.EmailId = $('#<%=txtEmailID.ClientID%>').val();
                    objVendormaster.Website = $('#<%=txtWebsite.ClientID%>').val();

                    objVendormaster.PrimaryContactPerson = $('#<%=txtPrimaryContactPerson.ClientID%>').val();
                    objVendormaster.PrimaryContactPersonDesignation = $('#<%=txtDesignationp.ClientID%>').val();
                    objVendormaster.PrimaryContactPersonMobileNo = $('#<%=txtMobileNop.ClientID%>').val();
                    objVendormaster.PrimaryContactPersonEmailId = $('#<%=txtEmailIdp.ClientID%>').val();

                    objVendormaster.SecondaryContactPerson = $('#<%=txtSecondaryContactPerson.ClientID%>').val();
                    objVendormaster.SecondaryContactPersonDesignation = $('#<%=txtDesignations.ClientID%>').val();
                    objVendormaster.SecondaryContactPersonMobileNo = $('#<%=txtMobileNos.ClientID%>').val();
                    objVendormaster.SecondaryContactPersonEmailId = $('#<%=txtEmailIds.ClientID%>').val();



                    objVendormaster.CINNo = $('#<%=txtCINNo.ClientID%>').val();
                    objVendormaster.PFRegistartionNo = $('#<%=txtPFRegistartionNo.ClientID%>').val();
                    objVendormaster.NameonPANCard = $('#<%=txtNameonPANCard.ClientID%>').val();
                    objVendormaster.PANCardNo = $('#<%=txtPANCardNo.ClientID%>').val();
                    objVendormaster.ROCNo = $('#<%=txtROCNo.ClientID%>').val();
                    objVendormaster.ESIRegistrationNo = $('#<%=txtESIRegistrationNo.ClientID%>').val();
                    objVendormaster.ISOCertificationNo = $('#<%=txtISOCertificationNo.ClientID%>').val();
                    objVendormaster.ISOValidUpto = $('#<%=txtISOCertificationNoValidUpto.ClientID%>').val();;
                    objVendormaster.PollutioncontrolBoardCertificationNo = $('#<%=txtPollutioncontrolBoardCertificationNo.ClientID%>').val();
                    objVendormaster.PollutionValidUpto = $('#<%=txtPollutioncontrolBoardCertificationNoValidUpto.ClientID%>').val();



                    objVendormaster.Bank1 = $('#<%=txtBanker1.ClientID%>').val();
                    objVendormaster.Bank1Branch = $('#<%=txtBranchBanker1.ClientID%>').val();
                    objVendormaster.Bank1AccountsNo = $('#<%=txtBankAccountsNoBanker1.ClientID%>').val();
                    objVendormaster.Bank1IFSCCode = $('#<%=txtRTGSIFSCCodeBanker1.ClientID%>').val();
                    objVendormaster.Bank1Address1 = $('#<%=txtAddress1Banker1.ClientID%>').val();
                    objVendormaster.Bank1Address2 = $('#<%=txtAddress2Banker1.ClientID%>').val();
                    objVendormaster.Bank1City = $('#<%=txtcityBanker1.ClientID%>').val();
                    objVendormaster.Bank1State = $('#<%=txtstateBanker1.ClientID%>').val();

                    objVendormaster.Bank2 = $('#<%=txtBanker2.ClientID%>').val();
                    objVendormaster.Bank2Branch = $('#<%=txtBranchBanker2.ClientID%>').val();
                    objVendormaster.Bank2AccountsNo = $('#<%=txtBankAccountsNoBanker2.ClientID%>').val();
                    objVendormaster.Bank2IFSCCode = $('#<%=txtRTGSIFSCCodeBanker2.ClientID%>').val();
                    objVendormaster.Bank2Address1 = $('#<%=txtAddress1Banker2.ClientID%>').val();
                    objVendormaster.Bank2Address2 = $('#<%=txtAddress2Banker2.ClientID%>').val();
                    objVendormaster.Bank2City = $('#<%=txtcityBanker2.ClientID%>').val();
                    objVendormaster.Bank2State = $('#<%=txtstateBanker2.ClientID%>').val();


                    objVendormaster.PaymentTerms = $('#<%=txtPaymentTerms.ClientID%>').val();
                    objVendormaster.Taxes = $('#<%=txttaxes.ClientID%>').val();
                    objVendormaster.DeliveryTerms = $('#<%=txtdeliverytems.ClientID%>').val();
                    objVendormaster.VendorToNotes = $('#<%=txtvendortonotes.ClientID%>').val();
                    objVendormaster.CreditLimit = $('#<%=txtCreditLimit.ClientID%>').val();
                    if (($('#<%=ChkActivate.ClientID%>').prop('checked') == true)) {
                        objVendormaster.IsActive = "1";
                    }
                    else {
                        objVendormaster.IsActive = "0";
                    }

                    if (($('#<%=chloginrequired.ClientID%>').prop('checked') == true)) {
                        objVendormaster.IsLoginRequired = "1";
                        objVendormaster.LoginUserName = $('#<%=txtusername.ClientID%>').val();
                objVendormaster.LoginPassword = $('#<%=txtpassword.ClientID%>').val();
            }
            else {
                objVendormaster.IsLoginRequired = "0";
                objVendormaster.LoginUserName = "";
                objVendormaster.LoginPassword = "";
            }

            if (($('#<%=chlautorejectpo.ClientID%>').prop('checked') == true)) {
                        objVendormaster.IsAutoRejectPO = "1";
                        objVendormaster.AutoRejectPOAfterDays = $('#<%=txtrejectionday.ClientID%>').val();

            }
            else {
                objVendormaster.IsAutoRejectPO = "0";
                objVendormaster.AutoRejectPOAfterDays = "0";
            }



            if (($('#<%=chMSMERegistration.ClientID%>').prop('checked') == true)) {
                        objVendormaster.IsMSMERegistration = "1";
                        objVendormaster.MSMERegistrationNo = $('#<%=txtmsmeregistrationno.ClientID%>').val();
                objVendormaster.MSMERegistrationValidDate = $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').val();




            }
            else {
                objVendormaster.IsMSMERegistration = "0";
                objVendormaster.MSMERegistrationNo = "";
                objVendormaster.MSMERegistrationValidDate = "";
            }


            objVendormaster.OracleVendorCode = $.trim(jQuery("#<%=txtOracleVendorCode.ClientID %>").val());
                    objVendormaster.OracleVendorSite = $.trim(jQuery("#<%=txtOracleCustomerSite.ClientID %>").val());



                    return objVendormaster;
                }

                function VendorFinanceDetail() {

                    var dataIm = new Array();

                    $('#tableFinancial tr').each(function () {
                        var id = $(this).closest("tr").attr("id");
                        if (id != "tableFinancialheader") {
                            var objIM = new Object();
                            if ($('#vendorid').html() == "") {
                                objIM.SupplierID = "0";
                            }
                            else {
                                objIM.SupplierID = $('#vendorid').html();
                            }
                            objIM.Supplier = $('#<%=txtVendorName.ClientID%>').val();
                    objIM.FinancialYear = $(this).closest("tr").find("#tdyear").html();
                    objIM.AnnualTurnover = $(this).closest("tr").find("#tdtrunover").html();


                    dataIm.push(objIM);
                }

            });

            return dataIm;
        }

        function VendorGSTNDetail() {

            var dataIm = new Array();

            $('#tableGst tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "tableGstheader") {
                    var objIM = new Object();
                    if ($('#vendorid').html() == "") {
                        objIM.SupplierID = "0";
                    }
                    else {
                        objIM.SupplierID = $('#vendorid').html();
                    }
                    objIM.Supplier = $('#<%=txtVendorName.ClientID%>').val();
                    objIM.StateID = $(this).closest("tr").find("#tdstategstnid").html();
                    objIM.State = $(this).closest("tr").find("#tdstategstn").html();
                    objIM.GST_No = $(this).closest("tr").find("#tdgstn").html();
                    objIM.Address = $(this).closest("tr").find("#tdaddressgstn").html();



                    dataIm.push(objIM);
                }

            });

            return dataIm;
        }

        function savenewitem() {
            if (validation() == false) {
                return;
            }
            var vendormaster = VendorMaster();
            var vendorfidetail = VendorFinanceDetail();
            var vendorgstndetail = VendorGSTNDetail();

            if (vendorgstndetail.length == 0) {
                showhide('6');
                toast("Error", "Please Select  State and GSTN Detail", "");
                return;
            }
            $("#btnsave").attr('disabled', true).val("Submiting...");
            serverCall('VendorMaster.aspx/SaveVendorMaster', { vendormaster: vendormaster, vendorfidetail: vendorfidetail, vendorgstndetail: vendorgstndetail, filename: filename }, function (response) {
                var save = response;
                if (save.split('#')[0] == "1") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    clearForm();
                    toast("Success", "Vendor Created...!", "");
                    searchitem();
                }
                else {
                    toast("Error", save.split('#')[1], "");
                    $('#btnsave').attr('disabled', false).val("Save");
                    if (save.split('#')[0] == "2") {
                        $('#<%=txtPANCardNo.ClientID%>').focus();
                }
            }
            });
    }

    function clearForm() {
        filename = "";
        $('#vendorid').html('');
        $('#btnsave').show();
        $('#btnupdate').hide();
        // $('#btnupdate1').hide();
        $('#<%=ChkActivate.ClientID%>').prop('checked', true);
            $("#makerdiv").find("input[type=text]").val("");
            $("#ContentPlaceHolder1_ddlsupplier").prop('selectedIndex', 0);
            $("#<%=ddlsuppliertype.ClientID%>").prop('selectedIndex', 0);
            $("#ContentPlaceHolder1_ddlSupplierOrganizationType").prop('selectedIndex', 0);
            $("#ContentPlaceHolder1_ddlState").prop('selectedIndex', 0);
            $("#ContentPlaceHolder1_ddlCountry").prop('selectedIndex', 0);
            $("#ContentPlaceHolder1_ddlyear").prop('selectedIndex', 0);
            $("#ContentPlaceHolder1_ddlstategstn").prop('selectedIndex', 0);

            $('#tableFinancial tr').slice(1).remove();
            $('#tableGst tr').slice(1).remove();
            $('.tab').hide();

            $('#<%=txtpassword.ClientID%>').val('');
            $('#<%=txtcpassword.ClientID%>').val('');

            $('#<%=chlautorejectpo.ClientID%>').prop('checked', false);

            $('#<%=chloginrequired.ClientID%>').prop('checked', false);

            $('#<%=chMSMERegistration.ClientID%>').prop('checked', false);



            $('#<%=txtmsmeregistrationno.ClientID%>').attr("disabled", true);
            $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').attr("disabled", true);
        }



    </script>


    <script type="text/javascript">

        function searchitem() {
            clearForm();
            $modelBlockUI();
            $('#tblitemlist tr').slice(1).remove();
            var _temp = [];
            _temp.push(serverCall('VendorMaster.aspx/SearchData', { searchtype: $('#<%=ddlserchtype.ClientID%>').val(), searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(), SupplierCategory: $('#<%=ddlsuppliersearch.ClientID%>').val(), OrganizationType: $('#<%=ddlSupplierOrganizationTypesearch.ClientID%>').val(), Status: $('#<%=ddlstatus.ClientID%>').val(), NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val() }, function (response) {
                     jQuery.when.apply(null, _temp).done(function () {
                         var $ReqData = JSON.parse(response);
                         if ($ReqData.length == 0) {;
                             toast("Error", "No Item Found..!", "");
                             $modelUnBlockUI();
                         }
                         else {
                             for (var i = 0; i <= $ReqData.length - 1; i++) {

                                 var $mydata = [];
                                 $mydata.push("<tr style='background-color:"); $mydata.push($ReqData[i].rowcolor); $mydata.push("'>");
                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/view.GIF" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><input type="button" value="Select" style="cursor:pointer;" onclick="showdetailtoupdate(this)" /></td>');
                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail3" >');

                                 if ($ReqData[i].ApprovalStatus == "0" && approvaltypechecker == "1") {
                                     $mydata.push('<img src="../../App_Images/Checked.png" style="cursor:pointer;height:30px;width:50px" onclick="checkme(this)" />');
                                 }
                                 $mydata.push('</td>');


                                 $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail4" >');
                                 if ($ReqData[i].ApprovalStatus == "1" && approvaltypeapproval == "1") {
                                     $mydata.push('<img src="../../App_Images/Approved.jpg" style="cursor:pointer;height:30px;width:50px" onclick="approveme(this)" />');
                                 }
                                 $mydata.push('</td>');


                                 $mydata.push('<td class="GridViewLabItemStyle"  >'); $mydata.push($ReqData[i].SupplierCategoryName); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].SupplierName); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].SupplierCode); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" id="SupplierType" >'); $mydata.push($ReqData[i].SupplierType); $mydata.push('</td>');


                                 var add = $ReqData[i].HouseNo + " " + $ReqData[i].Street + " " + $ReqData[i].State + $ReqData[i].PinCode;

                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push(add); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].PrimaryContactPerson); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].PrimaryContactPersonMobileNo); $mydata.push('</td>');
                                 $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push($ReqData[i].PrimaryContactPersonEmailId); $mydata.push('</td>');


                                 $mydata.push('<td style="display:none;" id="SupplierID">'); $mydata.push($ReqData[i].SupplierID); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="SupplierName">'); $mydata.push($ReqData[i].SupplierName); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="SupplierCode">'); $mydata.push($ReqData[i].SupplierCode); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="SupplierCategory">'); $mydata.push($ReqData[i].SupplierCategory); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="OrganizationType">'); $mydata.push($ReqData[i].OrganizationType); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="HouseNo">'); $mydata.push($ReqData[i].HouseNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Street">'); $mydata.push($ReqData[i].Street); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Country">'); $mydata.push($ReqData[i].Country); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="State">'); $mydata.push($ReqData[i].State); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="PinCode">'); $mydata.push($ReqData[i].PinCode); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Landline">'); $mydata.push($ReqData[i].Landline); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="FaxNo">'); $mydata.push($ReqData[i].FaxNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="EmailId">'); $mydata.push($ReqData[i].EmailId); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Website">'); $mydata.push($ReqData[i].Website); $mydata.push('</td>');

                                 $mydata.push('<td style="display:none;" id="PrimaryContactPerson">'); $mydata.push($ReqData[i].PrimaryContactPerson); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="PrimaryContactPersonDesignation">'); $mydata.push($ReqData[i].PrimaryContactPersonDesignation); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="PrimaryContactPersonMobileNo">'); $mydata.push($ReqData[i].PrimaryContactPersonMobileNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="PrimaryContactPersonEmailId">'); $mydata.push($ReqData[i].PrimaryContactPersonEmailId); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="SecondaryContactPerson">'); $mydata.push($ReqData[i].SecondaryContactPerson); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="SecondaryContactPersonDesignation">'); $mydata.push($ReqData[i].SecondaryContactPersonDesignation); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="SecondaryContactPersonMobileNo">'); $mydata.push($ReqData[i].SecondaryContactPersonMobileNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="SecondaryContactPersonEmailId">'); $mydata.push($ReqData[i].SecondaryContactPersonEmailId); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="CINNo">'); $mydata.push($ReqData[i].CINNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="PFRegistartionNo">'); $mydata.push($ReqData[i].PFRegistartionNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="NameonPANCard">'); $mydata.push($ReqData[i].NameonPANCard); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="PANCardNo">'); $mydata.push($ReqData[i].PANCardNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="ROCNo">'); $mydata.push($ReqData[i].ROCNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="ESIRegistrationNo">'); $mydata.push($ReqData[i].ESIRegistrationNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="ISOCertificationNo">'); $mydata.push($ReqData[i].ISOCertificationNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="ISOValidUpto">'); $mydata.push($ReqData[i].ISOValidUpto); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="PollutioncontrolBoardCertificationNo">'); $mydata.push($ReqData[i].PollutioncontrolBoardCertificationNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="PollutionValidUpto">'); $mydata.push($ReqData[i].PollutionValidUpto); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank1">'); $mydata.push($ReqData[i].Bank1); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank1Branch">'); $mydata.push($ReqData[i].Bank1Branch); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank1AccountsNo">'); $mydata.push($ReqData[i].Bank1AccountsNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank1IFSCCode">'); $mydata.push($ReqData[i].Bank1IFSCCode); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank1Address1">'); $mydata.push($ReqData[i].Bank1Address1); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank1Address2">'); $mydata.push($ReqData[i].Bank1Address2); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank1City">'); $mydata.push($ReqData[i].Bank1City); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank1State">'); $mydata.push($ReqData[i].Bank1State); $mydata.push('</td>');


                                 $mydata.push('<td style="display:none;" id="Bank2">'); $mydata.push($ReqData[i].Bank2); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank2Branch">'); $mydata.push($ReqData[i].Bank2Branch); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank2AccountsNo">'); $mydata.push($ReqData[i].Bank2AccountsNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank2IFSCCode">'); $mydata.push($ReqData[i].Bank2IFSCCode); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank2Address1">'); $mydata.push($ReqData[i].Bank2Address1); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank2Address2">'); $mydata.push($ReqData[i].Bank2Address2); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank2City">'); $mydata.push($ReqData[i].Bank2City); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Bank2State">'); $mydata.push($ReqData[i].Bank2State); $mydata.push('</td>');


                                 $mydata.push('<td style="display:none;" id="PaymentTerms">'); $mydata.push($ReqData[i].PaymentTerms); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="Taxes">'); $mydata.push($ReqData[i].Taxes); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="DeliveryTerms">'); $mydata.push($ReqData[i].DeliveryTerms); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="VendorToNotes">'); $mydata.push($ReqData[i].VendorToNotes); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="CreditLimit">'); $mydata.push($ReqData[i].CreditLimit); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="IsActive">'); $mydata.push($ReqData[i].IsActive); $mydata.push('</td>');

                                 $mydata.push('<td style="display:none;" id="IsLoginRequired">'); $mydata.push($ReqData[i].IsLoginRequired); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="LoginUserName">'); $mydata.push($ReqData[i].LoginUserName); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="LoginPassword">'); $mydata.push($ReqData[i].LoginPassword); $mydata.push('</td>');

                                 $mydata.push('<td style="display:none;" id="IsAutoRejectPO">'); $mydata.push($ReqData[i].IsAutoRejectPO); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="AutoRejectPOAfterDays">'); $mydata.push($ReqData[i].AutoRejectPOAfterDays); $mydata.push('</td>');

                                 $mydata.push('<td style="display:none;" id="IsMSMERegistration">'); $mydata.push($ReqData[i].IsMSMERegistration); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="MSMERegistrationNo">'); $mydata.push($ReqData[i].MSMERegistrationNo); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="MSMERegistrationValidDate">'); $mydata.push($ReqData[i].MSMERegistrationValidDate); $mydata.push('</td>');

                                 $mydata.push('<td style="display:none;" id="OracleVendorCode">'); $mydata.push($ReqData[i].OracleVendorCode); $mydata.push('</td>');
                                 $mydata.push('<td style="display:none;" id="OracleVendorSite">'); $mydata.push($ReqData[i].OracleVendorSite); $mydata.push('</td>');

                                 $mydata.push("</tr>");

                                 $mydata = $mydata.join("");
                                 jQuery('#tblitemlist').append($mydata);

                             }
                         }

                     });
                 }));
             }

             function searchitemexcel() {
                 $modelBlockUI();
                 serverCall('VendorMaster.aspx/SearchDataExcel', { searchtype: $('#<%=ddlserchtype.ClientID%>').val(), searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(), SupplierCategory: $('#<%=ddlsuppliersearch.ClientID%>').val(), OrganizationType: $('#<%=ddlSupplierOrganizationTypesearch.ClientID%>').val(), Status: $('#<%=ddlstatus.ClientID%>').val(), NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val() }, function (response) {
                    var save = response;
                    if (save == "false") {
                        toast("Error", "No Item Found", "");
                        $modelUnBlockUI();

                    }
                    else {
                        window.open('../common/ExportToExcel.aspx');
                        $modelUnBlockUI();

                    }
                });
            }

            function checkme(ctrl) {
                var id = $(ctrl).closest("tr").find('#SupplierID').html();
                $modelBlockUI();
                serverCall('VendorMaster.aspx/SetStatus', { itemId: id, Status: 1 }, function (response) {
                    toast("Success", "Vendor checked Sucessfully...!", "");
                    searchitem();
                });
                $modelUnBlockUI();
            }

            function approveme(ctrl) {
                var id = $(ctrl).closest("tr").find('#SupplierID').html();

                var OracleVendorCode = $(ctrl).closest("tr").find('#OracleVendorCode').html();
                var OracleVendorSite = $(ctrl).closest("tr").find('#OracleVendorSite').html();

                if (OracleVendorCode == "") {
                  //  toast("Error","Please Entre oracle vendor code for this Supplier");
                  //  return false;
                }

                if (OracleVendorSite == "") {
                  //  toast("Error", "Please entre oracle vendor site for this Supplier");
                  //  return false;
                }

               

                serverCall('VendorMaster.aspx/SetStatus', { itemId: id, Status: 2 }, function (response) {
                    toast("Success", "Vendor Approved Sucessfully", "");
                    searchitem();
                });
                
            }


            function showdetailtoupdate(ctrl) {
              
                clearForm();

                $('#btnsave').hide();
                $('#btnupdate').show();
                //$('#btnupdate1').show();
                $('#vendorid').html($(ctrl).closest("tr").find('#SupplierID').html());


                $('#<%=txtOracleVendorCode.ClientID%>').val($(ctrl).closest("tr").find('#OracleVendorCode').html());
                    $('#<%=txtOracleCustomerSite.ClientID%>').val($(ctrl).closest("tr").find('#OracleVendorSite').html());

                    $('#<%=txtVendorName.ClientID%>').val($(ctrl).closest("tr").find('#SupplierName').html());
                    $('#<%=ddlsuppliertype.ClientID%>').val($(ctrl).closest("tr").find('#SupplierType').html());

                    $('#<%=txtSupplierCode.ClientID%>').val($(ctrl).closest("tr").find('#SupplierCode').html());
                    $('#<%=ddlsupplier.ClientID%>').val($(ctrl).closest("tr").find('#SupplierCategory').html());
                    $('#<%=ddlSupplierOrganizationType.ClientID%>').val($(ctrl).closest("tr").find('#OrganizationType').html());
                    $('#<%=txtHouseNoOfficeNo.ClientID%>').val($(ctrl).closest("tr").find('#HouseNo').html());
                    $('#<%=txtStreetBuildingLocality.ClientID%>').val($(ctrl).closest("tr").find('#Street').html());
                    $('#<%=ddlCountry.ClientID%>').val($(ctrl).closest("tr").find('#Country').html());
                    $('#<%=ddlState.ClientID%>').val($(ctrl).closest("tr").find('#State').html());
                    $('#<%=txtPin.ClientID%>').val($(ctrl).closest("tr").find('#PinCode').html());
                    $('#<%=txtLandline.ClientID%>').val($(ctrl).closest("tr").find('#Landline').html());
                    $('#<%=txtFaxNo.ClientID%>').val($(ctrl).closest("tr").find('#FaxNo').html());
                    $('#<%=txtEmailID.ClientID%>').val($(ctrl).closest("tr").find('#EmailId').html());
                    $('#<%=txtWebsite.ClientID%>').val($(ctrl).closest("tr").find('#Website').html());

                    $('#<%=txtPrimaryContactPerson.ClientID%>').val($(ctrl).closest("tr").find('#PrimaryContactPerson').html());
                    $('#<%=txtDesignationp.ClientID%>').val($(ctrl).closest("tr").find('#PrimaryContactPersonDesignation').html());
                    $('#<%=txtMobileNop.ClientID%>').val($(ctrl).closest("tr").find('#PrimaryContactPersonMobileNo').html());
                    $('#<%=txtEmailIdp.ClientID%>').val($(ctrl).closest("tr").find('#PrimaryContactPersonEmailId').html());

                    $('#<%=txtSecondaryContactPerson.ClientID%>').val($(ctrl).closest("tr").find('#SecondaryContactPerson').html());
                    $('#<%=txtDesignations.ClientID%>').val($(ctrl).closest("tr").find('#SecondaryContactPersonDesignation').html());
                    $('#<%=txtMobileNos.ClientID%>').val($(ctrl).closest("tr").find('#SecondaryContactPersonMobileNo').html());
                    $('#<%=txtEmailIds.ClientID%>').val($(ctrl).closest("tr").find('#SecondaryContactPersonEmailId').html());



                    $('#<%=txtCINNo.ClientID%>').val($(ctrl).closest("tr").find('#CINNo').html());
                    $('#<%=txtPFRegistartionNo.ClientID%>').val($(ctrl).closest("tr").find('#PFRegistartionNo').html());
                    $('#<%=txtNameonPANCard.ClientID%>').val($(ctrl).closest("tr").find('#NameonPANCard').html());
                    $('#<%=txtPANCardNo.ClientID%>').val($(ctrl).closest("tr").find('#PANCardNo').html());
                    $('#<%=txtROCNo.ClientID%>').val($(ctrl).closest("tr").find('#ROCNo').html());
                    $('#<%=txtESIRegistrationNo.ClientID%>').val($(ctrl).closest("tr").find('#ESIRegistrationNo').html());
                    $('#<%=txtISOCertificationNo.ClientID%>').val($(ctrl).closest("tr").find('#ISOCertificationNo').html());
                    $('#<%=txtISOCertificationNoValidUpto.ClientID%>').val($(ctrl).closest("tr").find('#ISOValidUpto').html());
                    $('#<%=txtPollutioncontrolBoardCertificationNo.ClientID%>').val($(ctrl).closest("tr").find('#PollutioncontrolBoardCertificationNo').html());
                    $('#<%=txtPollutioncontrolBoardCertificationNoValidUpto.ClientID%>').val($(ctrl).closest("tr").find('#PollutionValidUpto').html());



                    $('#<%=txtBanker1.ClientID%>').val($(ctrl).closest("tr").find('#Bank1').html());
                    $('#<%=txtBranchBanker1.ClientID%>').val($(ctrl).closest("tr").find('#Bank1Branch').html());
                    $('#<%=txtBankAccountsNoBanker1.ClientID%>').val($(ctrl).closest("tr").find('#Bank1AccountsNo').html());
                    $('#<%=txtRTGSIFSCCodeBanker1.ClientID%>').val($(ctrl).closest("tr").find('#Bank1IFSCCode').html());
                    $('#<%=txtAddress1Banker1.ClientID%>').val($(ctrl).closest("tr").find('#Bank1Address1').html());
                    $('#<%=txtAddress2Banker1.ClientID%>').val($(ctrl).closest("tr").find('#Bank1Address2').html());
                    $('#<%=txtcityBanker1.ClientID%>').val($(ctrl).closest("tr").find('#Bank1City').html());
                    $('#<%=txtstateBanker1.ClientID%>').val($(ctrl).closest("tr").find('#Bank1State').html());

                    $('#<%=txtBanker2.ClientID%>').val($(ctrl).closest("tr").find('#Bank2').html());
                    $('#<%=txtBranchBanker2.ClientID%>').val($(ctrl).closest("tr").find('#Bank2Branch').html());
                    $('#<%=txtBankAccountsNoBanker2.ClientID%>').val($(ctrl).closest("tr").find('#Bank2AccountsNo').html());
                    $('#<%=txtRTGSIFSCCodeBanker2.ClientID%>').val($(ctrl).closest("tr").find('#Bank2IFSCCode').html());
                    $('#<%=txtAddress1Banker2.ClientID%>').val($(ctrl).closest("tr").find('#Bank2Address1').html());
                    $('#<%=txtAddress2Banker2.ClientID%>').val($(ctrl).closest("tr").find('#Bank2Address2').html());
                    $('#<%=txtcityBanker2.ClientID%>').val($(ctrl).closest("tr").find('#Bank2City').html());
                    $('#<%=txtstateBanker2.ClientID%>').val($(ctrl).closest("tr").find('#Bank2State').html());


                    $('#<%=txtPaymentTerms.ClientID%>').val($(ctrl).closest("tr").find('#PaymentTerms').html());
                    $('#<%=txttaxes.ClientID%>').val($(ctrl).closest("tr").find('#Taxes').html());
                    $('#<%=txtdeliverytems.ClientID%>').val($(ctrl).closest("tr").find('#DeliveryTerms').html());
                    $('#<%=txtvendortonotes.ClientID%>').val($(ctrl).closest("tr").find('#VendorToNotes').html());
                    $('#<%=txtCreditLimit.ClientID%>').val($(ctrl).closest("tr").find('#CreditLimit').html());
                    if ($(ctrl).closest("tr").find('#IsActive').html() == "1") {
                        $('#<%=ChkActivate.ClientID%>').prop('checked', true);
                    }
                    else {
                        $('#<%=ChkActivate.ClientID%>').prop('checked', false);
                    }

                    if ($(ctrl).closest("tr").find('#IsLoginRequired').html() == "1") {
                        $('#<%=chloginrequired.ClientID%>').prop('checked', true);
                        $('#<%=txtusername.ClientID%>').val($(ctrl).closest("tr").find('#LoginUserName').html());
                        $('#<%=txtpassword.ClientID%>').val($(ctrl).closest("tr").find('#LoginPassword').html());
                        $('#<%=txtcpassword.ClientID%>').val($(ctrl).closest("tr").find('#LoginPassword').html());

                    }
                    else {
                        $('#<%=chloginrequired.ClientID%>').prop('checked', false);
                        $('#<%=txtusername.ClientID%>').val('');
                        $('#<%=txtpassword.ClientID%>').val('');
                        $('#<%=txtcpassword.ClientID%>').val('');
                    }

                    if ($(ctrl).closest("tr").find('#IsAutoRejectPO').html() == "1") {
                        $('#<%=chlautorejectpo.ClientID%>').prop('checked', true);
                        $('#<%=txtrejectionday.ClientID%>').val($(ctrl).closest("tr").find('#AutoRejectPOAfterDays').html());


                    }
                    else {
                        $('#<%=chlautorejectpo.ClientID%>').prop('checked', false);
                        $('#<%=txtrejectionday.ClientID%>').val('');

                    }


                    if ($(ctrl).closest("tr").find('#IsMSMERegistration').html() == "1") {
                        $('#<%=chMSMERegistration.ClientID%>').prop('checked', true);
                        $('#<%=txtmsmeregistrationno.ClientID%>').val($(ctrl).closest("tr").find('#MSMERegistrationNo').html());
                        $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').val($(ctrl).closest("tr").find('#MSMERegistrationValidDate').html());

                        $('#<%=txtmsmeregistrationno.ClientID%>').attr("disabled", false);
                        $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').attr("disabled", false);


                    }
                    else {
                        $('#<%=chMSMERegistration.ClientID%>').prop('checked', false);
                        $('#<%=txtmsmeregistrationno.ClientID%>').val('');
                        $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').val('');
                        $('#<%=txtmsmeregistrationno.ClientID%>').attr("disabled", true);
                        $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').attr("disabled", true);
                    }
                    showhide('2');
                    showhide('3');
                    showhide('6');

                    $('#tableFinancial tr').slice(1).remove();

                    var _temp = [];
                    _temp.push(serverCall('VendorMaster.aspx/BindFinData', { vendorid: $('#vendorid').html() }, function (response) {
                        jQuery.when.apply(null, _temp).done(function () {
                            var $ReqData = JSON.parse(response);
                            for (var i = 0; i <= $ReqData.length - 1; i++) {
                                var id = $ReqData[i].financialyear + "_" + $ReqData[i].AnnualTurnover;
                                var $mydata = [];
                                $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push(id); $mydata.push("'>");
                                $mydata.push('<td  align="left" >'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                                $mydata.push('<td  align="left" id="tdyear">'); $mydata.push($ReqData[i].financialyear); $mydata.push('</td>');
                                $mydata.push('<td  align="left" id="tdtrunover">'); $mydata.push($ReqData[i].AnnualTurnover); $mydata.push('</td>');
                                $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow1(this)"/></td>');
                                $mydata.push("</tr>");

                                $mydata = $mydata.join("");
                                jQuery('#tableFinancial').append($mydata);
                            }
                        });
                    }));

                    $('#tableGst tr').slice(1).remove();

                    //    var _temp = [];
                    _temp.push(serverCall('VendorMaster.aspx/BindgstnData', { vendorid: $('#vendorid').html() }, function (response) {
                        jQuery.when.apply(null, _temp).done(function () {
                            var $ReqData = JSON.parse(response);
                            for (var i = 0; i <= $ReqData.length - 1; i++) {
                                var id = $ReqData[i].financialyear + "_" + $ReqData[i].AnnualTurnover;
                                var $mydata = [];
                                $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push(id); $mydata.push("'>");
                                $mydata.push('<td  align="left" >'); $mydata.push(parseInt(i + 1)); $mydata.push('</td>');
                                $mydata.push('<td  align="left" id="tdstategstn">'); $mydata.push($ReqData[i].state); $mydata.push('</td>');
                                $mydata.push('<td  align="left" id="tdaddressgstn">'); $mydata.push($ReqData[i].address); $mydata.push('</td>');
                                $mydata.push('<td  align="left" id="tdgstn">'); $mydata.push($ReqData[i].gst_no); $mydata.push('</td>');
                                $mydata.push('<td  align="left" id="tdstategstnid" style="display:none;" >'); $mydata.push($ReqData[i].stateid); $mydata.push('</td>');
                                $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow2(this)"/></td>');
                                $mydata.push("</tr>");

                                $mydata = $mydata.join("");
                                jQuery('#tableGst').append($mydata);
                            }
                        });
                    }));

                   
                }





    </script>


    <script type="text/javascript">
        function updateitem() {

            if (validation() == false) {
                return;
            }

            var OracleVendorCode = $("#<%=txtOracleVendorCode.ClientID%>").val();
            var OracleVendorSite = $("#<%=txtOracleCustomerSite.ClientID%>").val();

            if (OracleVendorCode == "") {
                alert("Please entre oracle vendor code.");
                $("#<%=txtOracleVendorCode.ClientID%>").focus();
                return false;
            }

            if (OracleVendorSite == "") {
                alert("Please entre oracle vendor site");
                $("#<%=txtOracleCustomerSite.ClientID%>").focus();
                return false;
            }

            var vendormaster = VendorMaster();
            var vendorfidetail = VendorFinanceDetail();
            var vendorgstndetail = VendorGSTNDetail();
            if (vendorgstndetail.length == 0) {
                toast("Error", "Please Enter State and GSTN Detail", "");
                showhide('6');
                return;
            }
            $("#btnupdate").attr('disabled', true).val("Submiting...");

            serverCall('VendorMaster.aspx/UpdateVendorMaster', { vendormaster: vendormaster, vendorfidetail: vendorfidetail, vendorgstndetail: vendorgstndetail }, function (response) {
                var save = response;
                if (save.split('#')[0] == "1") {
                    $('#btnupdate').attr('disabled', false).val("Update");
                    clearForm();
                    toast("Success", "Vendor Updated", "");
                    searchitem();
                }
                else {
                    toast("Error", $responseData.response, "");
                    if (save.split('#')[0] == "2") {
                        $('#<%=txtPANCardNo.ClientID%>').focus();
                    }
                    $('#btnupdate').attr('disabled', false).val("Update");
                }
            });


        }

    function showdetail(ctrl) {
        var vendorid = $(ctrl).closest("tr").find('#SupplierID').html();
        openmypopup('ShowvendoridDetail.aspx?vendorid=' + vendorid);
    }




    function openmypopup(href) {
        var width = '1100px';

        $.fancybox({
            'background': 'none',
            'hideOnOverlayClick': true,
            'overlayColor': 'gray',
            'width': width,
            'height': '800px',
            'autoScale': false,
            'autoDimensions': false,
            'transitionIn': 'elastic',
            'transitionOut': 'elastic',
            'speedIn': 6,
            'speedOut': 6,
            'href': href,
            'overlayShow': true,
            'type': 'iframe',
            'opacity': true,
            'centerOnScroll': true,
            'onComplete': function () {
            },
            afterClose: function () {
            }
        });
    }
    var filename = "";
    function uploaddocument() {
        var vendorid = $('#vendorid').html().trim();


        if (vendorid == "") {
            if (filename == "") {
                filename = Math.floor((Math.random() * 10000) + 1);
            }

        }

        openmypopup('AddFileSupplier.aspx?vendorid=' + vendorid + '&filename=' + filename);

    }
    </script>

    <script type="text/javascript">
        function setmsme(ctrl) {

            if ($(ctrl).is(':checked')) {

                $('#<%=txtmsmeregistrationno.ClientID%>').attr("disabled", false);
                    $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').attr("disabled", false);


                }
                else {
                    $('#<%=txtmsmeregistrationno.ClientID%>').attr("disabled", true);
                    $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').attr("disabled", true);

                    $('#<%=txtmsmeregistrationno.ClientID%>').val('');
                    $('#<%=txtmsmeregistrationnoValidUpto.ClientID%>').val('');
                }
            }

    </script>
</asp:Content>

