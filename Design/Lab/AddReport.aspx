<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AddReport.aspx.cs" Inherits="Design_Lab_AddReport" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" style=" vertical-align: top; margin: -0px">
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Add Report
            </div>
            <div class="row">
                <div class="col-md-24 col-xs-24" style="text-align: center">
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 col-xs-24">
                    <label class="pull-left">Test   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-12">
                    <asp:DropDownList ID="ddlTests" runat="server" AutoPostBack="True"  OnSelectedIndexChanged="ddlTests_SelectedIndexChanged"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3 col-xs-24">
                    <label class="pull-left">Select File   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10 col-xs-24">
                    <asp:FileUpload ID="fu_Upload" runat="server"  />
                </div>
                <div class="col-md-5 col-xs-24">
                    <asp:Button ID="btnSave" runat="server" Text="Upload" OnClick="btnSave_Click"  CssClass="savebutton" OnClientClick="return validate()" />
                   
                </div>
            </div>
            <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-21">
                        <em><span style="color: #0000ff; font-size: 9.5pt">1. (Only .pdf files is allowed)</span></em>
                    </div>
                </div>
            <div class="row">
                <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                    CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 100%;" OnRowCommand="grvAttachment_RowCommand">
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
                                <a target="_self" href='DownloadAttachment.aspx?FileName=<%# Eval("AttachedFile")%>&Type=1&FilePath=<%# Eval("FileUrl")%>'><%# Eval("AttachedFile")%></a>
                                <asp:Label ID="lblPath" Visible="false" runat="server" Text='<%# Eval("FileUrl")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded By" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="dtEntry" HeaderText="Date" ItemStyle-Width="100px" />
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
        function validate() {
            var con = 0;
            var validFilesTypes = [ "pdf"];
            if (jQuery("#fu_Upload").val() == '') {
                toast('Error', 'Please Select File to Upload');
                jQuery("#fu_Upload").focus();
                con = 1;
                return false;
            }
            var extension = jQuery('#fu_Upload').val().split('.').pop().toLowerCase();
            if (jQuery.inArray(extension, validFilesTypes) == -1) {
                toast('Error', "Invalid File. Please upload a File with extension:\n\n" + validFilesTypes.join(", "));
                con = 1;
                return false;
            }
            
            if (con == 1) {
                return false;
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                    document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
                }

            }
            function bindMessage(msg, type) {
                toast(type, msg);

            }

        </script>
</asp:Content>

