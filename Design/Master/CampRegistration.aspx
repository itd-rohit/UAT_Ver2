<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CampRegistration.aspx.cs" Inherits="Design_Master_CampRegistration" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <%-- <script type="text/javascript" >
        $(function () {
            if ($('#<%=grd.ClientID%>').is(':visible')) {
                var gridHeader = $('#<%=grd.ClientID%>').clone(true);
                $(gridHeader).find("tr:gt(0)").remove();
                $('#<%=grd.ClientID%> tr th').each(function (i) {
                    $("th:nth-child(" + (i + 1) + ")", gridHeader).css('width', ($(this).width()).toString() + "px");
                });
                $("#GHead").append(gridHeader);
                $('#GHead').css('position', 'absolute');
                $('#GHead').css('top', $('#<%=grd.ClientID%>').offset().top);
            }
            
            
        });

</script>--%>
    <script type="text/javascript">

        $(function () {
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
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24 ">
                    <b>Camp Registration </b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Camp Detail
            </div>
            <div class="row">
                <div class="col-md-2 "></div>
                <div class="col-md-3 required">
                    <label class="pull-left">Centre Name </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 ">
                    <asp:DropDownList ID="ddlCentreName" CssClass="ddlCentreName chosen-select requiredField" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-2 "></div>
                <div class="col-md-3 required">
                    <label class="pull-left">Processing Centre </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 ">
                    <asp:DropDownList ID="ddlProcessingCentre" class="ddlProcessingCentre chosen-select requiredField" runat="server"></asp:DropDownList>
                </div>

            </div>
            <div class="row">
                <div class="col-md-2 "></div>
                <div class="col-md-3">
                    <label class="pull-left">Camp Name</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtcampname" runat="server" CssClass="requiredField" MaxLength="100" AutoCompleteType="Disabled" />
                </div>
                <div class="col-md-2 "></div>
                <div class="col-md-3">
                    <label class="pull-left">Camp Coordinator</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtcampcoordinate" MaxLength="70" runat="server" AutoCompleteType="Disabled" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 "></div>
                <div class="col-md-3 ">
                    <label class="pull-left">Camp Address</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-6 ">
                    <asp:TextBox ID="txtadd1" runat="server"  MaxLength="100" AutoCompleteType="Disabled" />
                </div>
                <div class="col-md-2 "></div>
                <div class="col-md-3 ">
                    <label class="pull-left">Contact No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 ">
                    <asp:TextBox ID="txtph1" runat="server"  MaxLength="10" AutoCompleteType="Disabled" />
                    <cc1:FilteredTextBoxExtender ID="ftbPh1" runat="server" TargetControlID="txtph1" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2 "></div>
                <div class="col-md-3 required">
                    <label class="pull-left">Test</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6 ">
                    <asp:DropDownList ID="ddlinvestigation" class="ddlinvestigation chosen-select" runat="server" ></asp:DropDownList>
                </div>
                <div class="col-md-2 "></div>
                <div class="col-md-6 ">
                    <asp:Button OnClick="btnadd_Click" ID="btnadd" runat="server" Text="Add Test" OnClientClick="return addTest()" />
                </div>
            </div>
            <div class="row" style="display: none">
                <div class="col-md-24">
                    <asp:TextBox ID="txtadd2" runat="server"  MaxLength="100" AutoCompleteType="Disabled" />
                    <asp:TextBox ID="txtph2" runat="server"  MaxLength="10" AutoCompleteType="Disabled" />
                    <cc1:FilteredTextBoxExtender ID="ftcPh2" runat="server" TargetControlID="txtph2" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <div class="col-md-24">
                    <div style="max-height: 150px; overflow: scroll;">

                        <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="5" EnableModelValidation="True" Width="800px" OnRowDeleting="grd_RowDeleting" OnRowDataBound="grd_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                        <asp:Label ID="lblItemID" runat="server" Text='<%# Bind("ItemID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Bind("SubCategoryID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblTestCode" runat="server" Text='<%# Bind("TestCode") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblInvestigation_Id" runat="server" Text='<%# Bind("Investigation_Id") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblInvestigationName" runat="server" Text='<%# Bind("InvestigationName") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblIsPackage" runat="server" Text='<%# Bind("IsPackage") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblPackageName" runat="server" Text='<%# Bind("PackageName") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblPackageCode" runat="server" Text='<%# Bind("PackageCode") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblItemName" runat="server" Text='<%# Bind("ItemName") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblReportType" runat="server" Text='<%# Bind("ReportType") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblIsReporting" runat="server" Text='<%# Bind("IsReporting") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField HeaderText="TestName" DataField="ItemName" ItemStyle-Width="400px" ItemStyle-HorizontalAlign="Left" />
                                <asp:TemplateField HeaderText="SampleType" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlSampleType" runat="server" Width="130px"></asp:DropDownList>
                                        <asp:Label ID="lblSampleTypeID" runat="server" Text='<%#Eval("SampleTypeID") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rate" ItemStyle-Width="20px">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtRate" MaxLength="20" runat="server" Text='<%#Eval("Rate") %>' Width="60px" AutoCompleteType="Disabled"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbRate" runat="server" ValidChars="0123456789" TargetControlID="txtRate"></cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Remove" ShowHeader="False" ItemStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="~/App_Images/Delete.gif" CommandName="delete" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                            <RowStyle ForeColor="#000066" />
                            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                        </asp:GridView>

                    </div>

                    <div class="row" style="text-align: center">
                        <div class="col-md-24">
                            <asp:Button ID="btnsave" runat="server" OnClick="btnsave_Click" Text="Save" CssClass="savebutton" OnClientClick="return validateSave();" />
                            <asp:Button ID="btnupdate" Visible="false" runat="server" OnClick="btnupdate_Click" Text="Update" CssClass="savebutton" OnClientClick="return validateUpdate();" />
                            <asp:Button ID="btnCancel" Visible="false" runat="server" OnClick="btnCancel_Click" Text="Cancel" CssClass="resetbutton" OnClientClick="return validateCancel();" />
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Saved Camp
                <asp:TextBox ID="txtDOB" ClientIDMode="Static" runat="server" Style="display: none"></asp:TextBox>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div id="GSaveHead"></div>
                    <div style="max-height: 320px; overflow: scroll;">
                        <asp:GridView ID="grdsave" Width="100%" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="6" EnableModelValidation="True" OnSelectedIndexChanged="grdsave_SelectedIndexChanged" OnRowDeleting="grdsave_RowDeleting" OnRowCommand="grdsave_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                        <asp:Label ID="lblCampId" runat="server" Text='<%# Bind("CampID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblCentreID" runat="server" Text='<%# Bind("CentreID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblCampName" runat="server" Text='<%# Bind("campname") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblTagProcessingLabID" runat="server" Text='<%# Bind("TagProcessingLabID") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Centre Name">
                                    <ItemTemplate>

                                        <asp:Label ID="lblCentreName" runat="server" Text='<%#Eval("CentreName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Processing Centre">
                                    <ItemTemplate>

                                        <asp:Label ID="lblProcessingCentreName" runat="server" Text='<%#Eval("ProcessingCentreName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Camp Name">
                                    <ItemTemplate>

                                        <asp:Label ID="lblCampName1" runat="server" Text='<%#Eval("campname") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Camp Coordinator">
                                    <ItemTemplate>

                                        <asp:Label ID="lblCampCoordinator" runat="server" Text='<%#Eval("CampCoordinator") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Camp Address">
                                    <ItemTemplate>

                                        <asp:Label ID="lblCampAddress1" runat="server" Text='<%#Eval("CampAddress1") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Camp Contact">
                                    <ItemTemplate>

                                        <asp:Label ID="lblCampContact1" runat="server" Text='<%#Eval("CampContact1") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Test">
                                    <ItemTemplate>

                                        <asp:Label ID="lbltestname" runat="server" Text='<%#Eval("testname") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Entry Date">
                                    <ItemTemplate>

                                        <asp:Label ID="lblEntryDateTime" runat="server" Text='<%#Eval("EntryDateTime") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>


                                <asp:CommandField HeaderText="Select" ShowSelectButton="True" ControlStyle-ForeColor="Red">
                                    <ControlStyle ForeColor="Red"></ControlStyle>
                                </asp:CommandField>
                                <asp:CommandField HeaderText="DownloadExcel" ShowDeleteButton="True" DeleteText="Download" ControlStyle-BackColor="Green" ControlStyle-ForeColor="White" />
                                <asp:TemplateField HeaderText="Upload">
                                    <ItemTemplate>
                                        <asp:FileUpload ID="fuAttachment" runat="server" />
                                        <asp:Button ID="btnSave" runat="server" Text="Upload" CommandName="Upload" CssClass="buttonUpload" CommandArgument='<%# Container.DataItemIndex%>' UseSubmitBehavior="false" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                            <RowStyle ForeColor="#000066" HorizontalAlign="Left" />
                            <SelectedRowStyle BackColor="Pink" ForeColor="Black" HorizontalAlign="Left" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-24">
                <asp:Button ID="btnCampHide" runat="server" Style="display: none" OnClick="btnCampHide_Click" ClientIDMode="Static" />
                <asp:Label ID="lblCampRegName" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblShowCampID" runat="server" Style="display: none"></asp:Label>
            </div>
        </div>

    </div>
    <script type="text/javascript">
        function getdob(AgeInYear, AgeInMonth, AgeInDays) {
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if (AgeInYear != "")
                ageyear = AgeInYear;

            if (AgeInMonth != "")
                agemonth = AgeInMonth;

            if (AgeInDays != "")
                ageday = AgeInDays;

            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);
            var m_names = new Array("Jan", "Feb", "Mar",
    "Apr", "May", "Jun", "Jul", "Aug", "Sep",
    "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var DOB = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;

            $("#txtDOB").val(DOB);

        }
        function minTwoDigits(n) {
            return (n < 10 ? '0' : '') + n;
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $(".buttonUpload").click(function () {
                $modelBlockUI();
            });
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(
            function () {
                $modelUnBlockUI();
            });
        });
    </script>
    <script type="text/javascript">
        function addTest() {
            if ($('#<%=ddlinvestigation.ClientID%>').val() == "0") {
                $('#<%=lblMsg.ClientID%>').text('Please Select Test');
                $('#<%=ddlinvestigation.ClientID%>').focus();
                return false;
            }
            else {
                $modelBlockUI();
                document.getElementById('<%=btnadd.ClientID%>').disabled = true;
                document.getElementById('<%=btnadd.ClientID%>').value = 'Adding...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnadd', '');
            }
        }

        function validateUpdate() {
            if (validate()) {
                $modelBlockUI();
                document.getElementById('<%=btnupdate.ClientID%>').disabled = true;
                document.getElementById('<%=btnupdate.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnupdate', '');
            }
            else {
                return false;
            }
        }
        function validate() {
            if ($('#<%=ddlCentreName.ClientID%>').val() == "0") {
                $('#<%=lblMsg.ClientID%>').text('Please Select Centre Name');
                $('#<%=ddlCentreName.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlProcessingCentre.ClientID%>').val() == "0") {
                $('#<%=lblMsg.ClientID%>').text('Please Select Processing Centre');
                $('#<%=ddlProcessingCentre.ClientID%>').focus();
                return false;
            }
            if ($.trim($('#<%=txtcampname.ClientID%>').val()) == "") {
                $('#<%=lblMsg.ClientID%>').text('Please Enter Camp Name');
                $('#<%=txtcampname.ClientID%>').focus();
                return false;
            }
            return true;

        }

        function validateSave() {
            if (validate()) {
                $modelBlockUI();
                document.getElementById('<%=btnsave.ClientID%>').disabled = true;
                document.getElementById('<%=btnsave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnsave', '');
            }
            else {
                return false;
            }
        }
        function validateCancel() {
            $modelBlockUI();
            document.getElementById('<%=btnCancel.ClientID%>').disabled = true;
            document.getElementById('<%=btnCancel.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnCancel', '');


        }
    </script>
    <script type="text/javascript">
        function CampConfirmation(AddedItemName, RemovedItemName) {
            var msg = "";
            var $AddedItemName = []; var $RemovedItemName = [];
            if (AddedItemName != "") {
                $AddedItemName.push("<h3>Added Item from this camp Package</h3>");

                for (var i = 0; i < (AddedItemName.split('##').length) ; i++) {

                    $AddedItemName.push("".concat(i + 1, ". "));
                    $AddedItemName.push(AddedItemName.split('##')[i]);
                    $AddedItemName.push("<br />");
                }

                msg = $AddedItemName.join("");

            }
            if (RemovedItemName != "") {
                $RemovedItemName.push("<h3>Removed Item from this camp Package</h3>");

                for (var i = 0; i < (RemovedItemName.split('##').length) ; i++) {

                    $RemovedItemName.push("".concat(i + 1, ". "));
                    $RemovedItemName.push(RemovedItemName.split('##')[i]);
                    $RemovedItemName.push("<br />");
                }

                msg = "".concat(msg, $RemovedItemName.join(""));

            }

            jQuery.confirm({
                title: 'Confirmation!',
                content: "".concat("Please remove this Packge from camp : <b>", $('#lblCampRegName').text(), "</b> and add a new Package<br/>", msg),
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '520px',
                buttons: {
                    //'confirm': {
                    //    text: 'OK',
                    //    useBootstrap: false,
                    //    btnClass: 'btn-blue',
                    //    action: function () {
                    //        confirmationCampAction();
                    //    }
                    //},
                    somethingElse: {
                        text: 'OK',
                        btnClass: 'btn-blue',
                        action: function () {
                            clearCampAction();
                        }
                    },
                }
            });
        }
        function confirmationCampAction() {
            $("#btnCampHide").click();
        }
        function clearCampAction() {

        }
        function callFunctions() {

        }
        function callBlockFunctions() {
            $modelBlockUI();
        }
    </script>
</asp:Content>

