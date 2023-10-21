<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="~/Design/Lab/UploadSRFNo.aspx.cs" Inherits="Design_Lab_SampleCollection" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
     <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24 ">
                    <b>Upload SRF No</b>
                    <asp:Label ID="lblMsg" runat="server"></asp:Label>
                </div>
            </div>
           
        </div>
           <div class="POuter_Box_Inventory" id="SearchFilteres">
            <div class="Purchaseheader">
                Upload SRF No
                 <asp:LinkButton ID="lnk" runat="server" OnClick="lnk_Click" Text="Log Out" style="float:right;" Font-Bold="true" Visible="false"/>
            </div>
            <div class="row">
                 <div class="col-md-3 ">
                     </div>
                <div class="col-md-6 ">
                   <asp:LinkButton ID="lnk1" runat="server" Text="Download Sample File" OnClick="lnk1_Click" ></asp:LinkButton>
                </div>
                <div class="col-md-3 ">
                     Select File:
                </div>
              <div class="col-md-4 ">
                     <asp:FileUpload ID="file1" runat="server" />
                </div>
                <div class="col-md-6 ">
                       <asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click"  style="cursor:pointer;padding:5px;color:white;background-color:blue;font-weight:bold;"  />
                     <asp:Button ID="btnsave" runat="server" Text="Save To DataBase" OnClick="btnsave_Click" style="cursor:pointer;padding:5px;color:white;background-color:blue;font-weight:bold;" />
                </div>
                <div class="col-md-3 ">
                     
                </div>
            </div>


        </div>
          <div class="POuter_Box_Inventory" id="Div2">
           <div class="content" style="height:420px;width:100%;overflow:scroll;">
           <table width="100%">
            <tr>
                <td align="center">
                    <asp:GridView Width="90%" ID="grd" runat="server" BackColor="#CCCCCC" BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2" ForeColor="Black" AutoGenerateColumns="False" OnRowDataBound="grd_RowDataBound" >
                        <Columns>
                             <asp:TemplateField HeaderText="Select" ControlStyle-ForeColor="Blue">
                                  <ItemTemplate>
                              <asp:CheckBox ID="chk" Checked="true" runat="server" />
                                        <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>

<ControlStyle ForeColor="Blue"></ControlStyle>
                            </asp:TemplateField> 
                            <asp:BoundField DataField="BarcodeNo" HeaderText="BarcodeNo" />
                             <asp:BoundField DataField="SRFNo" HeaderText="SRFNo" /> 
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
    </div>
</asp:Content>