<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="UploadDocument.aspx.cs" Inherits="Design_CallCenter_UploadDocument" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" style="width: 784px">
        <div class="POuter_Box_Inventory" style="width: 780px;text-align:center">
            <div class="Purchaseheader">Upload Attachment</div>
           
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label><br />

            <table style="width:100%;border-collapse:collapse">
                <tr>
                    <td style="width:20%;text-align:right">
                        <strong>Select File :&nbsp;</strong>
                    </td>
                    <td style="width:30%;text-align:left">
                        <asp:FileUpload ID="fu_Upload" runat="server" />
                    </td>
                    <td style="width:50%;text-align:left">
                   <asp:Button ID="btnSave" runat="server" Text="Upload" CssClass="savebutton" OnClick="btnSave_Click"  OnClientClick="return validate();"/>

                    </td>
                </tr>
                <tr>
                    <td style="width:20%">
                        &nbsp;
                    </td>
                    <td colspan="2" style="text-align:left">
                        <em ><span style="color: #0000ff; font-size: 9.5pt">
                      1. (Only .doc,.docx,.pdf,.jpg.,png,.gif,.jpeg files is allowed)</span></em>
                    </td>
                </tr>
                <tr>
                    <td style="width:20%">
                        &nbsp;</td>
                    <td colspan="2" style="text-align:left">
                         <em ><span style="color: #0000ff; font-size: 9.5pt">2. Maximum file size upto 2 MB.</span></em></td>
                </tr>
            </table>
                       <table style="width:100%;border-collapse:collapse">    
                           <tr>
                               <td>

                               
                <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                    CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 99%;" OnRowCommand="grvAttachment_RowCommand" EnableModelValidation="True">
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
                                <a target="_self" href='../Lab/DownloadAttachment.aspx?FileName=<%# Eval("AttachedFile")%>&Type=3&FilePath=<%# Eval("FileUrl")%>'><%# Eval("AttachedFile")%></a>
                                <asp:Label ID="lblPath" runat="server" Text='<%# Eval("AttachedFile")%>' Style="display: none;"></asp:Label>


                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded By" ItemStyle-Width="150px">
                            <ItemStyle Width="150px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="dtEntry" HeaderText="Date" ItemStyle-Width="100px">


                            <ItemStyle Width="100px"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField />


                    </Columns>
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"
                        HorizontalAlign="Left" />
                    <EditRowStyle BackColor="#999999" />
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                </asp:GridView>

                                   </td>
                           </tr>
                            </table>
            </div>
       
    </div>
    <script type="text/javascript">

        $(function () {
            $('<%= fu_Upload.ClientID %>').change(function () {
                alert('');
                //because this is single file upload I use only first index
                var f = this.files[0]
               
                //here I CHECK if the FILE SIZE is bigger than 8 MB (numbers below are in bytes)
                if (f.size > 8388608 || f.fileSize > 8388608) {
                    //show an alert to the user
                    alert("Allowed file size exceeded. (Max. 8 MB)")

                    //reset file upload control
                    this.value = null;
                }
            })
        });

        function validate() {
            var con = 0;
            var label = document.getElementById("<%=lblMsg.ClientID%>");
            var validFilesTypes = ["doc", "docx", "pdf", "jpg", "png", "gif", "jpeg"];
            if (jQuery("#fu_Upload").val() == '') {
                label.innerHTML ='Please Select File to Upload';
                jQuery("#fu_Upload").focus();
                con = 1;
                return false;
            }
            var extension = jQuery('#fu_Upload').val().split('.').pop().toLowerCase();
            if (jQuery.inArray(extension, validFilesTypes) == -1) {
                label.innerHTML = "Invalid File. Please upload a File with" +
         " extension:\n\n" + validFilesTypes.join(", ");

                con = 1;
                return false;
            }
            var maxFileSize = 2097152; // 2MB -> 2 * 1024 * 1024
            var fileUpload = jQuery('#fu_Upload');
            if (fileUpload[0].files[0].size > maxFileSize) {
                con = 1;
                label.innerHTML = "You can Upload Only 2 MB File";
                return false;

            }
            if (con == 1) {
                return false;
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Uploading...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

            }


        }
    </script>
</asp:Content>


