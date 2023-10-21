<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddReportLetterHead.aspx.cs" Inherits="Design_Master_AddReportLetterHead" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />


    <title>Centre Header</title>
     <style type="text/css">
         .auto-style1
         {
             height: 17px;
         }
     </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager1" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>
                    <asp:Label ID="lblHeder" Font-Bold="true" runat="server"></asp:Label>
                    <asp:Label ID="lblPanelID" Visible="false" runat="server"></asp:Label>
                </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: left;">


                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td colspan="4" style="font-weight: bold; color: red;" class="auto-style1">Client Name::<asp:Label ID="lb" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right; width: 20%">Letter Head :&nbsp;
                        </td>
                        <td style="text-align: left;width:50%">
                            <asp:FileUpload ID="fuHeader" runat="server" />&nbsp;<asp:CheckBox ID="chkDefaultHeader" ToolTip="Check if Default Header" Text="Default Letter Head" runat="server" />
                            




                        </td>
                        <td style="text-align:right;width:26%">
                          <span id="spnDefaultHeader">View Default Letter Head</span>  
                        </td>
                        <td  style="text-align:left;width:24%">
                            <div>
                                <span id="spanHeader" style="position: absolute; display: none;">
                                    <asp:Image runat="server" ID="imgDefaultHeader"  Width="100%"/>
                                </span>                              
                            </div>
                        </td>
                    </tr>
                   
                    </table>
                 </div>
                  <div class="POuter_Box_Inventory" style="text-align: center;">
                            <asp:Button Font-Bold="true" ID="btnSave" OnClientClick="validate()" OnClick="btnSave_Click" runat="server" Text="Save " Style="cursor: pointer; background-color: maroon; color: white; padding: 5px;" />
                        
                      </div>
                
            <div class="POuter_Box_Inventory" style="text-align: center;" id="div_HeaderFooter" runat="server" visible="false">
                <table style="width:100%;border-collapse:collapse">
                    <tr>
                        <td style="width:50%;text-align:center;border-bottom:2px solid;border-right:2px solid">
                           <b> Letter Head Image</b>
                        </td>                     
                    </tr>
                    <tr>
                        <td style="width:50%;vertical-align:top;border-right:2px solid;">
                        <asp:Image runat="server" ID="imgHeader" Width="100%" />
                        </td>                       
                    </tr>
                </table>
                </div>



        </div>

        <script type="text/javascript">
            function validate() {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('btnSave', '');
            }
            $(function () {
                $("#spnDefaultHeader").mouseover(function () {
                    $("#spanHeader").show();
                });
                $("#spnDefaultHeader").mouseout(function () {
                    $("#spanHeader").hide();
                });
                $("#spnDefaultFooter").mouseover(function () {
                    $("#spanFooter").show();
                });
                $("#spnDefaultFooter").mouseout(function () {
                    $("#spanFooter").hide();
                });
            });

        </script>

    </form>
</body>
</html>
