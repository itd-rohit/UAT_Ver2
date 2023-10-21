<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" CodeFile="FileManager.aspx.cs" Inherits="Design_EDP_FileManager" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript">
        function showDirectory() {
            //document.all.TextBox1.value=  window.showModalDialog("browseDirectory.aspx",'jain',"dialogHeight: 560px; dialogWidth: 360px; edge: Raised; center: Yes; help: Yes; resizable: Yes; status: No;");   

            //var serverLoc='<%=Server.MapPath("~/Design") %>';
            //alert(serverLoc);
            var val = window.showModalDialog("browseDirectory.aspx", 'view', "dialogHeight: 480px; dialogWidth: 340px; edge: Raised; center: Yes; help: Yes; resizable: Yes; status: No;");

            if (val != undefined)
                document.getElementById('<%=txtNfile.ClientID %>').value = val;


        return false;
    }

    </script>

    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>File Management</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
<div class="col-md-3"></div>
                <div class="col-md-2">
<label class="pull-left">Menu Name   </label>
                    <b class="pull-right">:</b>
                   
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlMenu" runat="server" CssClass="ddlMenu chosen-select chosen-container" />
                </div>
                <div class="col-md-6">
                    <asp:Button ID="btnFile" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnFile_Click" OnClientClick="return searchDisable()"/>
                    <asp:Button ID="btnmnu" runat="server" CssClass="ItDoseButton" Text="New Menu" style="display:none" />
                    <asp:Button ID="btnNewFile" runat="server" CssClass="ItDoseButton" Text="New Files" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Files Detail
            </div>
            <div class="row">
                <div class="col-md-24">
                    <asp:GridView ID="grdFile" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowCommand="grdFile_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="FileName" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("DispName") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Description" HeaderStyle-Width="350px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Description")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Menu" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("MenuName")%>
                                    <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>' Visible="False"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Display Order" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtOrder" Text='<%#Container.DataItemIndex+1 %>' runat="server"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:ButtonField CommandName="AEdit" HeaderText="Edit" Text="Edit" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <asp:Button ID="btnSaveFileOrder" Text="Save" OnClick="btnSaveManuPriority_Click" CssClass="ItDoseButton" runat="server" Visible="false"></asp:Button>
                </div>
            </div>
        </div>
    </div>

    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" />
    </div>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Update File Details
        </div>
        <div class="row">
            <div class="col-md-7">
                <label>
                    FileName :</label>
            </div>
            <div class="col-md-17">
                <asp:Label ID="lblFileName" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;<asp:Label
                    ID="lblFileId" runat="server" Visible="False"></asp:Label><br />
            </div>
        </div>
        <div class="row">
            <div class="col-md-7">
                <label>
                    Description :</label>
            </div>
            <div class="col-md-17">
                <asp:TextBox ID="txtDesc" runat="server" CssClass="ItDoseLabel" TextMode="MultiLine" Width="265px"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-7">
                <label>
                    MenuName :</label>
            </div>
            <div class="col-md-17">
                <asp:DropDownList ID="ddlMenu1" runat="server" CssClass="ItDoseLabel" Width="270px"></asp:DropDownList>
            </div>
        </div>
        <div class="row">
            <div class="col-md-24">
                <asp:RadioButton ID="rdbActive" runat="server" Text="Active" GroupName="a" Checked="True" />
                <asp:RadioButton ID="rdbNonActive" runat="Server" Text="Non-Active" GroupName="a" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-24">
                <div class="filterOpDiv">
                    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                        Text="Save" ValidationGroup="Save" Width="65px" />&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                        Text="Cancel" Width="55px" />
                </div>
            </div>
        </div>


    </asp:Panel>

    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server"
        CancelControlID="btnCancel"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnlmnu" runat="server" CssClass="pnlFilter" Style="display: none;width:340px">
        <div class="Purchaseheader"  >
            New Menu
        </div>
        <div class="row">
            <div class="col-md-5">
                <label class="pull-left">Menu   </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-19">
                <asp:TextBox ID="txtNMenu" runat="server" Font-Bold="true" MaxLength="30" CssClass="requiredField"></asp:TextBox>
            </div>
        </div>





        <div class="filterOpDiv">
            <div class="row">
                <div class="col-md-14"></div>
                <div class="col-md-10">
                    <asp:Button ID="btnSaveMnu" runat="server" CssClass="ItDoseButton" OnClick="btnSaveMnu_Click" OnClientClick="return ValidateMenu()"
                        Text="Save" />&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btnCancelMnu" runat="server" CausesValidation="false" CssClass="ItDoseButton"
            Text="Cancel" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server"
        CancelControlID="btnCancelMnu"
        DropShadow="true"
        TargetControlID="btnmnu"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlmnu"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>


    <asp:Panel ID="pnlNfile" runat="server" CssClass="pnlFileFilter" Style="display: none; width: 560px">
        <div class="Purchaseheader" id="Div2" runat="server">
            File Details
        </div>
        
            <div class="row">
                <div class="col-md-5">
                    <label class="pull-left">
                        Menu</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-19">
                    <asp:DropDownList ID="ddlNfile" runat="server"  CssClass="requiredField ddlNfile chosen-select chosen-container"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                     <label class="pull-left">File Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-19">
                    <asp:TextBox ID="txtdispName"  runat="server" CssClass="requiredField"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                     <label class="pull-left">
                        URL</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-17">
                    <asp:TextBox ID="txtNfile" runat="server" Font-Bold="true" CssClass="requiredField"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <a href="javascript:void(0);" onclick="showDirectory();">
                        <img src="../../App_Images/view.GIF" style="border: none;" /></a>
                </div>
            </div>
            <div class="row">
                <div class="col-md-5">
                     <label class="pull-left">Description</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-19">
                    <asp:TextBox ID="txtFDesc" runat="server"  height="80px" TextMode="MultiLine" CssClass="requiredField"></asp:TextBox>
                </div>
            </div>
             <div class="row">
                 <div class="col-md-5">
                      <label class="pull-left">URL</label>
                    <b class="pull-right">:</b>

                     </div>
                   <div class="col-md-19">
                       /Design/Purchase/FileName.aspx
                       </div>
                 </div>
            <%--<asp:ImageButton ID="imgView" runat="server" ImageUrl="~/Design/Purchase/Image/view.GIF"  OnClientClick="showDirectory();"  />--%>
           
            <div class="row">
                <div class="col-md-24">
                    <div class="filterOpDiv">
                        <asp:Button ID="btnFileSave" runat="server" CssClass="ItDoseButton" OnClick="btnFileSave_Click" OnClientClick="return validateFileSave()"
                            Text="Save"  />&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="btnFileCancel" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                            Text="Cancel" />
                    </div>
                </div>
            </div>
    </asp:Panel>

    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server"
        CancelControlID="btnFileCancel"
        DropShadow="true"
        TargetControlID="btnNewFile"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlNfile"
        PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>
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

 $(this).find('.chosen-container').css({width: "100%"});

});
 validateFileSave = function () {
     if ($("#ddlNfile").val() == "0") {
         toast("Error", "Please Select Menu", "");
         $("#ddlNfile").focus();

         return false;
     }
     if ($.trim( $("#txtdispName").val()) == 0) {
         toast("Error", "Please Enter File Name  ", "");
         $("#txtdispName").focus();
         return false;
     }

     if ($.trim( $("#txtNfile").val()) == 0) {
         toast("Error", "Please Enter URL  ", "");
         $("#txtNfile").focus();
         return false;
     }
     if ($.trim($("#txtFDesc").val()) == 0) {
         toast("Error", "Please Enter Description  ", "");
         $("#txtFDesc").focus();
         return false;
     }
     document.getElementById('<%=btnFileSave.ClientID%>').disabled = true;
     document.getElementById('<%=btnFileSave.ClientID%>').value = 'Submitting...';
     __doPostBack('ctl00$ContentPlaceHolder1$btnFileSave', '');
 }
 ValidateMenu = function () {
     if ($.trim($("#txtNMenu").val()) == "") {
         toast("Error", "Please Enter Menu Name", "");
         $("#txtNMenu").focus();

         return false;
     }
     document.getElementById('<%=btnSaveMnu.ClientID%>').disabled = true;
         document.getElementById('<%=btnSaveMnu.ClientID%>').value = 'Submitting...';
         __doPostBack('ctl00$ContentPlaceHolder1$btnSaveMnu', '');

     }
 searchDisable = function () {
            document.getElementById('<%=btnFile.ClientID%>').disabled = true;
            document.getElementById('<%=btnFile.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnFile', '');
        }
</script>
</asp:Content>
