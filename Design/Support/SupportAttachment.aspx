<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="SupportAttachment.aspx.cs" Inherits="Design_Support_SupportAttachment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
</head>
<body>
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
             <asp:Panel ID="pnlView" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Upload File</div>
                <div class="row" style="text-align: center;">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label><br />
                </div>

                <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                        Select File:
                    </div>
                    <div class="col-md-8">
                        <asp:FileUpload ID="fu_Upload" runat="server" />
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
                <div class="row" style="text-align: center;">
                    <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                        CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 99%;" OnRowCommand="grvAttachment_RowCommand" EnableModelValidation="True">
                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                        <Columns>

                            <asp:TemplateField HeaderText="Remove">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/App_Images/Delete.gif" runat="server" />

                                </ItemTemplate>
                                <HeaderStyle Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="File Name">
                                <ItemTemplate>
                                    <a target="_new" href='../../Design/Lab/DownloadAttachment.aspx?FileName=<%# Eval("AttachedFile")%>&Type=6&&FilePath=<%# Eval("FileUrl")%>&IsSupport=1'><%# Eval("AttachedFile")%></a>
                                    <asp:Label ID="lblPath" Visible="false" runat="server" Text='<%# Eval("FileUrl")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="dtEntry" HeaderText="Date" ItemStyle-Width="150px">


                                <ItemStyle Width="100px"></ItemStyle>
                            </asp:BoundField>


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
        <script type="text/javascript">
            $(function () {
                $("#masterheaderid,#mastertopcorner,#btncross,#btnfeedback,#rdoIndentType,#divMasterNav").hide();

                $("#Pbody_box_inventory").css('margin-top', 0);
            });
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

        </script>

    </form>
</body>
</html>
