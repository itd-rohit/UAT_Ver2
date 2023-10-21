<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="UploadExpncesDoc.aspx.cs" Inherits="Design_PettyCash_UploadExpncesDoc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
    <link rel="Shortcut Icon" href="~/App_Images/itdose.ICO" type="image/x-icon" />
</head>
<body>
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <asp:Panel ID="pnlView" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">Upload Document</div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Select File</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:Label ID="lblupl" runat="server" Style="display: none;"></asp:Label>
                            <asp:Label ID="lblIsView" runat="server" Visible="false"></asp:Label>
                            <asp:FileUpload ID="fu_Upload" runat="server" Style="width: 202px;" />
                            <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload" ForeColor="Red"
                                ErrorMessage="*"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server" ValidationGroup="fUpload" ForeColor="Red"
                                ControlToValidate="fu_Upload" Display="Dynamic"
                                ErrorMessage=""
                                ValidationExpression="[a-zA-Z\\].*(.doc|.DOC|.docx|.DOCX|.pdf|.PDF|.jpg|.JPG|.png|.PNG|.gif|.GIF|.jpeg|.JPEG|.xlsx)$"></asp:RegularExpressionValidator>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSave" runat="server" Text="Upload" OnClick="btnSave_Click" OnClientClick="return validate()" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-21">
                            <em><span style="color: #0000ff; font-size: 9.5pt">1. (Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed)</span></em>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-21">
                            <em><span style="color: #0000ff; font-size: 9.5pt">2. Maximum file size upto 10 MB.</span></em>
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <div class="POuter_Box_Inventory" style="text-align: center">

                <div class="row">
                    <div class="col-md-24" style="text-align: center">
                        <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                            CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 99%;" OnRowDataBound="grvAttachment_RowDataBound" OnRowCommand="grvAttachment_RowCommand" EnableModelValidation="True">
                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/App_Images/Delete.gif" runat="server" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="25px" />
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <a target="_self" href='../Lab/DownloadAttachment.aspx?FileName=<%# Eval("FileUrl")%>&Type=5&FilePath=<%# Eval("FilePath")%>'><%# Eval("FileName")%></a>
                                        <asp:Label ID="lblPath" runat="server" Text='<%# Eval("FilePath")%>' Style="display: none;"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded By" ItemStyle-Width="150px">
                                    <ItemStyle Width="150px"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="dtEntry" HeaderText="Date" ItemStyle-Width="100px">
                                    <ItemStyle Width="100px"></ItemStyle>
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="View">

                                    <ItemTemplate>
                                        <%--  <%# Container.DataItemIndex + 1 %>--%>
                                        <asp:ImageButton ImageUrl="../../App_Images/view.GIF" runat="server" OnClientClick='<%#  Eval("ID", "viewDocument({0}); return false;") %>' CausesValidation="false" />

                                        <asp:Label ID="lblFileURL" runat="server" Text='<%# Eval("FileUrl")%>' Style="display: none;"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"
                                HorizontalAlign="Left" />
                            <EditRowStyle BackColor="#999999" />
                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            function validate() {
                var con = 0;
                var validFilesTypes = ["doc", "docx", "pdf", "jpg", "png", "gif", "jpeg", "xlsx", "JPG"];
                if (jQuery("#fu_Upload").val() == '') {
                    toast('Error', 'Please Select File to Upload');
                    jQuery("#fu_Upload").focus();
                    con = 1;
                    return false;
                }
                var extension = jQuery('#fu_Upload').val().split('.').pop().toLowerCase();
                if (jQuery.inArray(extension, validFilesTypes) == -1) {
                    toast('Error', "Invalid File. Please upload a File with" +
             " extension:\n\n" + validFilesTypes.join(", "));

                    con = 1;
                    return false;
                }
                var maxFileSize = 10485760; // 10MB -> 10 * 1024 * 1024
                var fileUpload = jQuery('#fu_Upload');
                if (fileUpload[0].files[0].size > maxFileSize) {
                    con = 1;
                    toast('Error', "You can Upload Only 10 MB File");
                    return false;

                }
                if (con == 1) {
                    return false;
                }
                else {
                    document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                    document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                    __doPostBack('btnSave', '');

                }

            }
            function bindMessage(msg, type) {
                toast(type, msg);

            }
            function viewDocument(ID) {

                serverCall('UploadExpncesDoc.aspx/EncryptDocument', { ID: ID }, function (response) {
                    $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        PostQueryString($responseData, '../Lab/ViewDocument.aspx');
                    }
                });
            }
            function viewDocument1(id) {

            }
        </script>
    </form>
</body>
</html>