<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="LISMaster.aspx.cs" Inherits="Design_Master_LISMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>LIS Master</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                LIS Details
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Receipt Format</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:GridView ID="grdPatientReceiptFormat" CssClass="GridViewStyle" runat="server" AutoGenerateColumns="False" Width="99%" EnableModelValidation="True">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Patient Receipt Format" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:RadioButton ID="rbReportFormat" runat="server" GroupName="ReportFormat" onclick="rdoPatientReceipt(this);" />
                                    <asp:Label ID="lblFormatName" runat="server" Text='<%# Bind("FormatName") %>'></asp:Label>
                                    <asp:Label ID="lblURL" Visible="false" runat="server" Text='<%# Bind("URL") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View" HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hypPatientReceipt" runat="server" ImageUrl="../../App_Images/view.GIF" Target="_blank"
                                        NavigateUrl='<%# Eval("FormatURL") %>'></asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                    </asp:GridView>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Lab Report Format</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:GridView ID="grdLabReportFormat" CssClass="GridViewStyle" runat="server" AutoGenerateColumns="False" Width="99%" EnableModelValidation="True">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Lab Report Format" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:RadioButton ID="rbReportFormat" runat="server" GroupName="ReportFormat" onclick="rdoLabReport(this);" />
                                    <asp:Label ID="lblFormatName" runat="server" Text='<%# Bind("FormatName") %>'></asp:Label>
                                    <asp:Label ID="lblURL" Visible="false" runat="server" Text='<%# Bind("URL") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View" HeaderStyle-Width="30px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hypLabReport" runat="server" ImageUrl="../../App_Images/view.GIF" Target="_blank"
                                        NavigateUrl='<%# Eval("FormatURL") %>'></asp:HyperLink>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                    </asp:GridView>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">ApplicationName</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtapplicationname" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">ClientFullName</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtClientFullName" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">RemoteLink</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtRemoteLink" runat="server"></asp:TextBox>
                </div>
            </div>
            <div class="row">


                <div class="col-md-4">
                    <label class="pull-left">RemoteLinkApplicable</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtRemoteLinkApplicable" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">ApplicationURLReportPathName</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtApplicationURLReportPathName" runat="server"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <label class="pull-left">Document Drive Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlDocumentDriveName" runat="server" CssClass="requiredField">
                        <asp:ListItem Value="0" Selected="True">Select</asp:ListItem>
                        <asp:ListItem Value="C">C</asp:ListItem>
                        <asp:ListItem Value="D">D</asp:ListItem>
                        <asp:ListItem Value="E">E</asp:ListItem>
                        <asp:ListItem Value="F">F</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">

                <div class="col-md-4">
                    <label class="pull-left">BaseCurrencyID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtBaseCurrencyID" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">BaseCurrencyNotation</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtBaseCurrencyNotation" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">BaseCurrencyRound</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtBaseCurrencyRound" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="row">

                 <div class="col-md-4">
                    <label class="pull-left">PayTM</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtPayTM" runat="server"></asp:TextBox>
                </div>
                

                <div class="col-md-4">
                    <label class="pull-left">ClientEmail</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtClientEmail" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">ClientImagePath</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtClientImagePath" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                
                <div class="col-md-4">
                    <label class="pull-left">ClientLogo</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtClientLogo" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">ClientNameShowInApplication</label><b class="pull-right">:</b>

                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtClientNameShowInApplication" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">ClientWebSite</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtClientWebSite" runat="server"></asp:TextBox>
                </div>
            </div>
            <div class="row">

                
                <div class="col-md-4">
                    <label class="pull-left">ConcentFormApplicable</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">

                    <asp:TextBox ID="txtConcentFormApplicable" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">ConcentFormOpen</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtConcentFormOpen" runat="server"></asp:TextBox>
                    <em style="font-size: x-small">1 After Select Item, 2  After Item Save</em>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">DefaultCountry</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDefaultCountry" runat="server"></asp:TextBox>
                </div>
            </div>


            

            <div class="row">


                
                <div class="col-md-4">
                    <label class="pull-left">DefaultFooter</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDefaultFooter" runat="server"></asp:TextBox>

                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Show Patient Photo </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:RadioButtonList ID="rblPatientPhoto" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                        <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>


                <div class="col-md-4">
                    <label class="pull-left">DefaultHeader</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDefaultHeader" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">DiagnosticName</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDiagnosticName" runat="server"></asp:TextBox>

                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">SRA Required </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:RadioButtonList ID="rblSRARequired" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                        <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>

                <div class="col-md-4">
                    <label class="pull-left">DocumentDriveIPAddress</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDocumentDriveIPAddress" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">DocumentFolderName</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDocumentFolderName" runat="server"></asp:TextBox>

                </div>
            </div>

            <div class="row">




                <div class="col-md-4">
                    <label class="pull-left">DocumentPath</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDocumentPath" runat="server"></asp:TextBox>
                </div>

            </div>

            <div class="row">


                <div class="col-md-4">
                    <label class="pull-left">EmailSignature</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtEmailSignature" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">EmailURLLink</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtEmailURLLink" runat="server"></asp:TextBox>

                </div>
            </div>

            <div class="row">

                <div class="col-md-4">
                    <label class="pull-left">OldPatientLink</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtOldPatientLink" runat="server"></asp:TextBox>
                </div>


                <div class="col-md-4">
                    <label class="pull-left">FromEmailid</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtFromEmailid" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">HiQPdfSerialNumber</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtHiQPdfSerialNumber" runat="server"></asp:TextBox>

                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">PanelInvoiceTDS</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtPanelInvoiceTDS" runat="server"></asp:TextBox>
                </div>


                <div class="col-md-4">
                    <label class="pull-left">LabReportPath</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtLabReportPath" runat="server"></asp:TextBox>

                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">OPDHomeCollection</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtOPDHomeCollection" runat="server"></asp:TextBox>
                    <em style="font-size: x-small">0 for No,1 for yes</em>
                </div>

                <div class="col-md-4">
                    <label class="pull-left">LinkURL</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtLinkURL" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">LedgerReportDate</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtLedgerReportDate" runat="server"></asp:TextBox>
                    <em style="font-size: x-small">SRADate,Date</em>
                </div>
            </div>

            <div class="row">



                <div class="col-md-4">
                    <label class="pull-left">LocalLink</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtLocalLink" runat="server"></asp:TextBox>

                </div>
                <div class="col-md-4">
                    <label class="pull-left">TinySMSReturnURL</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtTinySMSReturnURL" runat="server"></asp:TextBox>

                </div>

                <div class="col-md-4">
                    <label class="pull-left">DummyWaterMark</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDummyWaterMark" runat="server"></asp:TextBox>

                </div>

            </div>

            <div class="row">


                <div class="col-md-4">
                    <label class="pull-left">LocalLinkApplicable</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtLocalLinkApplicable" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">MemberShipCardApplicable</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtMemberShipCardApplicable" runat="server"></asp:TextBox>

                </div>
                 <div class="col-md-4">
                    <label class="pull-left">TinySMSFooter</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtTinySMSFooter" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="row">


                <div class="col-md-4">
                    <label class="pull-left">MemberShipCardNoAutoGenerate</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtMemberShipCardNoAutoGenerate" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">MobileAppFooter</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtMobileAppFooter" runat="server"></asp:TextBox>

                </div>
                <div class="col-md-4">
                    <label class="pull-left">ReportURL</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtReportURL" runat="server"></asp:TextBox>
                </div>
            </div>


           

            

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Email Configuration Details
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">EmailID</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtEmailID" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">EmailPassword</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtEmailPassword" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">EmailDisplayName</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtEmailDisplayName" runat="server"></asp:TextBox>

                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Port</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtPort" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">HostName</label><b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtHostName" runat="server"></asp:TextBox>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Cache Time Out Details
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">CountryCacheTimeOut</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlCountryCacheTimeOut" runat="server">
                            <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="120" Text="120 min"></asp:ListItem>
                            <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                            <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        </asp:DropDownList>

                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">StateCacheTimeOut</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlStateCacheTimeOut" runat="server">

                            <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="120" Text="120 min"></asp:ListItem>
                            <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                            <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        </asp:DropDownList>


                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">CityCacheTimeOut</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlCityCacheTimeOut" runat="server">
                            <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="120" Text="120 min"></asp:ListItem>
                            <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                            <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        </asp:DropDownList>

                    </div>


                </div>
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">LocalityCacheTimeOut</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlLocalityCacheTimeOut" runat="server">
                            <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="120" Text="120 min"></asp:ListItem>
                            <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                            <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">BankCacheTimeOut</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlBankCacheTimeOut" runat="server">
                            <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="120" Text="120 min"></asp:ListItem>
                            <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                            <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">CurrencyCacheTimeOut</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:DropDownList ID="ddlCurrencyCacheTimeOut" runat="server">
                            <asp:ListItem Value="60" Text="60 min" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="120" Text="120 min"></asp:ListItem>
                            <asp:ListItem Value="180" Text="180 min"></asp:ListItem>
                            <asp:ListItem Value="240" Text="240 min"></asp:ListItem>
                        </asp:DropDownList>

                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="row">
                    <div class="col-md-24">
                        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="return chkLIS();" />
                    </div>
                </div>

            </div>
        </div>
        <script type="text/javascript">

            function rdoPatientReceipt(rb) {
                var gv = document.getElementById("<%=grdPatientReceiptFormat.ClientID%>");
            var rbs = gv.getElementsByTagName("input");
            var row = rb.parentNode.parentNode;
            for (var i = 0; i < rbs.length; i++) {
                if (rbs[i].type == "radio") {
                    if (rbs[i].checked && rbs[i] != rb) {
                        rbs[i].checked = false;
                        break;
                    }
                }
            }
        }
        function rdoLabReport(rb) {
            var gv = document.getElementById("<%=grdLabReportFormat.ClientID%>");
            var rbs = gv.getElementsByTagName("input");
            var row = rb.parentNode.parentNode;
            for (var i = 0; i < rbs.length; i++) {
                if (rbs[i].type == "radio") {
                    if (rbs[i].checked && rbs[i] != rb) {
                        rbs[i].checked = false;
                        break;
                    }
                }
            }
        }
        </script>
        <script type="text/javascript">
            function chkLIS() {
                if ($.trim($("#ddlDocumentDriveName").val()) == "0") {
                    $("#lblMsg").text('Please Select Document Drive Name');
                    $("#ddlDocumentDriveName").focus();
                    return false;
                }
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

        }
        </script>
</asp:Content>
