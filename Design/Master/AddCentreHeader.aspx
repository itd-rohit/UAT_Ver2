<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddCentreHeader.aspx.cs" Inherits="Design_Master_AddCentreHeader" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />


    <title>Centre Header</title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager1" runat="server">
            </Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>
                    <asp:Label ID="lblHeder" Font-Bold="true" runat="server"></asp:Label>
                    <asp:Label ID="lblCentreID" Visible="false" runat="server"></asp:Label>
                </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: left;">

                <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-4 ">
                                <label class="pull-left">Centre Name   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-20">
                                <asp:Label ID="lb" runat="server"></asp:Label>

                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 ">
                                <label class="pull-left">Centre Header  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:FileUpload ID="fuHeader" runat="server" />

                            </div>
                            <div class="col-md-3">
                                <asp:CheckBox ID="chkHeader" ToolTip="Check if Show Header" Text="Show Header" runat="server" />
                            </div>
                            
                            <div class="col-md-3">
                                <asp:CheckBox ID="chkDefaultHeader" ToolTip="Check if Default Header" Text="Default Header" runat="server" />
                            </div>
                            <div class="col-md-4">
                                <span id="spnDefaultHeader">View Default Header</span>
                            </div>

                            <div class="col-md-4">
                                <span id="spanHeader" style="position: absolute; display: none;">
                                    <asp:Image runat="server" ID="imgDefaultHeader" Width="100%" />
                                </span>
                            </div>
                             <div class="col-md-4"></div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 ">
                                <label class="pull-left">Centre Footer  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:FileUpload ID="fuFooter" runat="server" />

                            </div>
                            <div class="col-md-3">
                                <asp:CheckBox ID="chkFooter" ToolTip="Check if Show Footer" Text="Show Footer" runat="server" />
                            </div>
                            <div class="col-md-3">
                               <asp:CheckBox ID="chkDefaultFooter" ToolTip="Check if Default Footer" Text="Default Footer" runat="server" />
                            </div>
                            <div class="col-md-4">
                               <span id="spnDefaultFooter">View Default Footer</span>
                            </div>

                            <div class="col-md-4">
                                <span id="spanFooter" style="position: absolute; display: none;">
                                        <asp:Image runat="server" ID="imgDefaultFooter" Width="100%" />
                                    </span>
                            </div>
                             <div class="col-md-4"></div>
                        </div>


                    </div>

                 </div>   
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <asp:Button ID="btnSave" OnClientClick="validate()" OnClick="btnSave_Click" runat="server" Text="Save "  />

                </div>

                <div class="POuter_Box_Inventory" style="text-align: center;" id="div_HeaderFooter" runat="server" visible="false">

                     <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-12 ">
                                <label class="pull-left">Centre Header Image</label>
                               
                            </div>
                            <div class="col-md-12">
                                <label class="pull-left">Centre Footer Image</label>

                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 ">
                                  <asp:Image runat="server" ID="imgHeader" Width="100%" />
                                </div>

                            <div class="col-md-12 ">
                                <asp:Image runat="server" ID="imgFooter" Width="100%" />
                                </div>
 </div>

                        </div>

                         </div>


                    
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
