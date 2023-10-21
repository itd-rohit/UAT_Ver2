<%@ Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="AddPanelAttachment.aspx.cs" Inherits="Design_Lab_AddPanelAttachment" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 <!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" /> 
     <webopt:BundleReference ID="BundleReference5" runat="server" Path="~/App_Style/chosen.css" />
<link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

    </head>
    <body >
    
    <form id="form1" runat="server">


     <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

</Scripts>
</Ajax:ScriptManager>

        <div class="POuter_Box_Inventory" style="text-align:center">
            <div class="row">
                <div class="col-md-24"> <b>Download Rate List </b>
                            <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>              
            </div>
        </div>
                    <div class="POuter_Box_Inventory">
                        <div class="row">
                            <div class="col-md-4">Panel : </div> 
                             <div class="col-md-12"> <asp:DropDownList ID="ddlPanel" runat="server" CssClass="ItDoseDropdownbox"
                                TabIndex="1" Width="300px">
                            </asp:DropDownList> </div> 
                             <div class="col-md-8">  <asp:LinkButton ID="LinkButton1" runat="server" Text="Download RateList File" OnClientClick="DownloadRateList()" Style="float: left;"></asp:LinkButton></div>

                        </div>              
                        </div>
            <div class="POuter_Box_Inventory">
                <div class="content" style="height: 420px; width: 99%; overflow: scroll;">
                    <table width="100%">
                        <tr>
                            <td align="center">
                                <asp:GridView Width="90%" ID="grd" runat="server" BackColor="#CCCCCC" BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2" ForeColor="Black" AutoGenerateColumns="False" OnRowDataBound="grd_RowDataBound">
                                    <Columns>
                                        <asp:TemplateField HeaderText="SNo." ControlStyle-ForeColor="Blue">
                                            <ItemTemplate>
                                               <%-- <asp:CheckBox ID="chk" Checked="true" runat="server" />--%>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ControlStyle ForeColor="Blue"></ControlStyle>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="ItemId" HeaderText="ItemId" />
                                        <asp:BoundField DataField="testcode" HeaderText="Test Code" />
                                        <asp:BoundField DataField="BillingCategory" HeaderText="Billing Category" />
                                        <asp:BoundField DataField="ItemName" HeaderText="NAME" />
                                        <asp:BoundField DataField="Rate" HeaderText="Rate" />
                                        
                                    </Columns>
                                    <FooterStyle BackColor="#CCCCCC" />
                                    <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />
                                    <RowStyle BackColor="White" />
                                    <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                                    <SortedAscendingCellStyle BackColor="#F1F1F1" />
                                    <SortedAscendingHeaderStyle BackColor="#808080" />
                                    <SortedDescendingCellStyle BackColor="#CAC9C9" />
                                    <SortedDescendingHeaderStyle BackColor="#383838" />
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
      
          <%--Loading Panel--%>
    <asp:HiddenField ID="hdnNoProgress" runat="server" Value="0" />
    <div id="Background2" class="Background" style="display: none">
    </div>
    <div id="Progress2" class="Loading" style="display: none;">
        <img src="../../App_Images/Progress.gif" />&nbsp;&nbsp;
        Please wait...
    </div>
    <%--Loading Panel--%>

        <script>
 $(document).ready(function () {
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


            function DownloadRateList() {
                debugger

                var PanelId = $('[id$=ddlPanel]').val();
                var PanelName = $('[id$=ddlPanel] option:selected').text();

                if (PanelId == "0") {
                    alert('Please select panel!');
                    return;
                }

                try {
                    serverCall('AddPanelAttachment.aspx/DownloadRateList', { PanelId: PanelId, PanelName: PanelName }, function (response) {
                        window.open("../Common/ExportToExcelWithoutHead.aspx");

                    });
                }
                catch (e) {
                    toast("Error", "Error has occurred Record Not saved", "");
                    $("#btnSave").attr('disabled', false);
                }

            }
        </script>
         <script>

             window.onbeforeunload = function () {

                 if ($('[id$=hdnNoProgress]').val() == '0') {
                     ShowProgress();
                 }
                 else
                     $('[id$=hdnNoProgress]').val('0');

             }
             // Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(pageLoaded);
             function pageLoaded() {
                 HideProgress();
             }
             function ShowProgress() {

                 $('[id$=Background2]').css('display', '');
                 $('[id$=Progress2]').css('display', '');

             }

             function HideProgress() {

                 $('[id$=Background2]').css('display', 'none');
                 $('[id$=Progress2]').css('display', 'none');
             }
             function SetHiddenFieldValue() {
                 $('[id$=hdnNoProgress]').val('1');
             }

    </script>
        <style>
            .Background {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            background-color: gray;
            filter: alpha(opacity=222);
            opacity: 0.4;
            z-index: 999;
        }

        .Loading {
            background-color: transparent;
            position: fixed;
            top: 55%;
            left: 45%;
            width: 150px;
            height: 45px;
            border: 0px solid #ccc;
            text-align: center;
            vertical-align: middle;
            padding-top: 10px;
            font-family: Arial;
            font-size: 12px;
            z-index: 9999;
        }
        </style>
</form>
</body>
</html>



