<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UploadCoupon.aspx.cs" Inherits="Design_Coupon_UploadCoupon" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />


</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />

            </Scripts>
        </Ajax:ScriptManager>


        <div id="Pbody_box_inventory" style="margin-top: 0px">
            <div class="POuter_Box_Inventory" style="text-align: center">

                <b>Add Coupon Code From Excel</b>
                <br />

                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">

                    <div class="col-md-3">
                        <label class="pull-left">Select File  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <cc1:AsyncFileUpload ID="file1" runat="server"  ClientIDMode="Static"/>

                    </div>
                    <div class="col-md-6">
                        <asp:Button ID="btnupload" runat="server" CssClass="savebutton" OnClick="btnupload_Click" Text="Upload" OnClientClick="return validate()" />
                    </div>

                    <div class="row">

                        <div style="width: 100%; max-height: 300px; overflow: auto;">

                            <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False"
                                CellPadding="4" Style="width: 99%; text-align: left;" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px">

                                <Columns>
                                    <asp:BoundField DataField="coupon_code" HeaderText="Coupon Code" ItemStyle-Width="150px">
                                        <ItemStyle Width="150px"></ItemStyle>
                                    </asp:BoundField>
                                </Columns>
                                <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                                <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" HorizontalAlign="Left" />
                                <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                                <RowStyle BackColor="White" ForeColor="#330099" />
                                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                                <SortedAscendingCellStyle BackColor="#FEFCEB" />
                                <SortedAscendingHeaderStyle BackColor="#AF0101" />
                                <SortedDescendingCellStyle BackColor="#F6F0C0" />
                                <SortedDescendingHeaderStyle BackColor="#7E0000" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <script type="text/javascript">
            function validate() {

                var con = 0;
                var label = document.getElementById("<%=lblMsg.ClientID%>");
                var validFilesTypes = ["xlsx", "xls"];
                if (jQuery("#file1_ctl02").val() == "") {
                    label.innerHTML = 'Please Select File to Upload';
                    jQuery("#file1_ctl02").focus();
                    con = 1;
                    return false;
                }
                var extension = jQuery('#file1_ctl02').val().split('.').pop().toLowerCase();
                if (jQuery.inArray(extension, validFilesTypes) == -1) {
                    label.innerHTML = "Invalid File. Please upload a File with" +
             " extension:\n\n" + validFilesTypes.join(", ");

                    con = 1;
                    return false;
                }

                if (con == 1) {
                    return false;
                }
                else {
                    document.getElementById('<%=btnupload.ClientID%>').disabled = true;
                    document.getElementById('<%=btnupload.ClientID%>').value = 'Uploading...';
                    __doPostBack('btnupload', '');

                }
            }
        </script>

    </form>


</body>
</html>
