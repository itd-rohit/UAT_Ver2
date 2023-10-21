<%@ Page Title="" Language="C#" AutoEventWireup="true"
    CodeFile="Aboutus.aspx.cs" Inherits="Design_PROApp_Aboutus" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top:-42px">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Mobile App B2C Aboutus</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <asp:Label ID="lblImageId" runat="server" Visible="false" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Image Details
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Header Image   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:FileUpload ID="FileUpload1" accept="image/*" runat="server" />

                    </div>
                    <div class="col-md-6">

                        <asp:Label ID="lblImage" runat="server" Visible="false" CssClass="ItDoseLblError"></asp:Label>
                        <asp:Image ID="imgHeader" Visible="false" runat="server" Width="300px" Height="100px" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Bottom Text    </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">

                        <asp:TextBox ID="txttext" onkeydown="return (event.keyCode!=13);" runat="server" Width="410px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-10">
                        <asp:CheckBox ID="chkActive" runat="server" /><label for="chkActive">IsActive</label>

                        <asp:Label ID="lblid" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <asp:Button ID="btnsave" runat="server" Text="Save" CssClass="savebutton" OnClick="btnsave_Click" Width="100px" Style="margin-left: -142px;" />
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Search Result</div>
                <div>
                    <asp:GridView runat="server" ID="gvImage" AutoGenerateColumns="false" Width="100%" DataKeyNames="ID" OnSelectedIndexChanged="gvImage_SelectedIndexChanged">
                        <Columns>
                            <asp:TemplateField HeaderText="Sr.No" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="50px">
                                <ItemTemplate>
                                    <center>
                                    <asp:Label ID="lblImgId" runat="server" Text='<%#Container.DataItemIndex+1%>'></asp:Label>
                                </center>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Image" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <center>
                                    <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("HeaderImage") %>' Height="80px" Width="100px" />
                                </center>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Content" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <asp:Label ID="lblcontent" runat="server" Text='<%# Eval("ButtomText") %>'></asp:Label>
                                    <asp:TextBox ID="txtRecordID" Style="display: none;" runat="server" Text='<%# Eval("ID") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IsActive" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <asp:Label ID="lblActive" runat="server" Text='<%# Eval("IsActive") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                                <ItemTemplate>
                                    <center>
                                    <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Entrydate") %>'></asp:Label>
                                </center>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:CommandField ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="50px" HeaderText="Select" />
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="lblImageId" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="Outer_Box_Inventory">
                <asp:Button ID="btnBindGrid" runat="server" OnClick="btnBindGrid_Click" Style="display: none;" />
                <input id="Save" type="button" value="Save Ordering" style="display: none;" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Header Details    
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Content Header   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">

                        <asp:TextBox ID="txtheader1" runat="server" Width="290px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Content Text   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtContent" onkeydown="return (event.keyCode!=13);" runat="server" Width="492px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-10">
                        <asp:CheckBox ID="chkAct" runat="server" /><label for="chkAct">IsActive</label>
                        <asp:Label ID="Label2" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <asp:Button ID="btnsave1" runat="server" CssClass="savebutton" Text="Save" OnClick="btnsave1_Click" Width="100px" />
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Search Result</div>
                <asp:GridView runat="server" ID="gvImage1" AutoGenerateColumns="false" Width="99.6%" DataKeyNames="ID" OnSelectedIndexChanged="gvImage1_SelectedIndexChanged">
                    <Columns>
                        <asp:TemplateField HeaderText="Sr.No" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="50px">
                            <ItemTemplate>
                                <center>
                                    <asp:Label ID="lblImgId" runat="server" Text='<%#Container.DataItemIndex+1%>'></asp:Label>
                                </center>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Header" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                            <ItemTemplate>
                                <asp:Label ID="lblAclblnametive" runat="server" Text='<%# Eval("HeaderText") %>'></asp:Label>
                                <asp:TextBox ID="txtRecordID" Style="display: none;" runat="server" Text='<%# Eval("ID") %>'></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Content" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                            <ItemTemplate>
                                <asp:Label ID="lblcontent" runat="server" Text='<%# Eval("Content") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IsActive" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                            <ItemTemplate>
                                <asp:Label ID="lblActive" runat="server" Text='<%# Eval("IsActive") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="100px">
                            <ItemTemplate>
                                <center>
                                    <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Entrydate") %>'></asp:Label>
                                </center>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="50px" HeaderText="Select" />
                        <asp:TemplateField Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lblImageId" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                            </ItemTemplate>

                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;">
                <input id="Save1" type="button" value="Save Ordering" class="searchbutton" />
                <asp:Button ID="btnBindGrid1" runat="server" OnClick="btnBindGrid1_Click" Style="display: none;" />
            </div>

        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                $('#<%=gvImage.ClientID%>').tableDnD({
                    onDragClass: "GridViewDragItemStyle"
                });
                $('#<%=gvImage1.ClientID%>').tableDnD({
                    onDragClass: "GridViewDragItemStyle"
                });
                // SearchHelpdata();
                $("#Save").click(function () {
                    saveAboutUsImageOrdering();
                });
                $("#Save1").click(function () {
                    saveAboutUsHeaderOrdering();
                });
            });
            function saveAboutUsImageOrdering() {
                var HTOrder = "";
                var temp = "";
                $("#<%=gvImage.ClientID%> > tbody > tr").not(':first').each(function () {
                    temp = $(this).find("input[type='text']").val();
                    HTOrder += temp + '|';
                });
                serverCall('Aboutus.aaspx/saveAboutUsImageOrdering', { HTOrder: HTOrder }, function (response) {
                    if (response == '1') {
                        toast("Success", 'Record Saved Successfully', '');
                        //alert();
                        $("#<%=btnBindGrid.ClientID%>").click();
                    }
                });
            }
            function saveAboutUsHeaderOrdering() {
                var HTOrder = "";
                var temp = "";
                $("#<%=gvImage1.ClientID%> > tbody > tr").not(':first').each(function () {
                        temp = $(this).find("input[type='text']").val();
                        HTOrder += temp + '|';
                    });
                    serverCall('Aboutus.aspx/saveAboutUsHeaderOrdering', { HTOrder: HTOrder }, function (response) {
                        if (response == '1') {

                            toast("Success", 'Record Saved Successfully', '');
                            $("#<%=btnBindGrid1.ClientID%>").click();
                    }
                });
            }
        </script>
    </form>
</body>
</html>
