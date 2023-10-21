<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CAPResultUpload.aspx.cs" Inherits="Design_Quality_CAPResultUpload" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
    <title></title>

   
</head>
<body>
    <form id="form1" runat="server">
      
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width:904px;height:450px;">

         <div class="POuter_Box_Inventory" style="width:900px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>CAP Result Upload</b>
                            <br />
                           <asp:Label ID="lb" runat="server" style="font-weight: 700; color: #FF0000" />
                            
                        </td>
                    </tr>
                    </table>
                </div>


              </div>


        <div class="POuter_Box_Inventory" style="width:900px;">
            <div class="content">
                <table>
                    <tr>
                        <td style="font-weight: 700">Processing Lab :</td>
                        <td><asp:DropDownList ID="ddlprocessinglab" runat="server" Width="300px"></asp:DropDownList></td>
                         <td style="font-weight: 700">
                             Shipment No:
                        </td>
                        <td>
                          <asp:DropDownList ID="ddlshipmentno" runat="server" Width="300px"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700">Program :</td>
                        <td><asp:DropDownList ID="ddlcapprogrm" runat="server" Width="300px"></asp:DropDownList></td>
                         <td style="font-weight: 700" colspan="2">
                             &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700" valign="top">Upload :</td>
                        <td colspan="3">
                             <asp:FileUpload ID="fu_Upload" runat="server"   />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="btnSave" runat="server" Text="Upload" CssClass="savebutton" onclick="btnSave_Click"    ValidationGroup="fUpload"  />&nbsp;&nbsp;&nbsp;
    <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="fu_Upload" ValidationGroup="fUpload" ForeColor="Red"
        ErrorMessage="Please Select File"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server"   ValidationGroup="fUpload" ForeColor="Red" 
ControlToValidate="fu_Upload" Display="Dynamic" 
ErrorMessage="Only PDF File Allowed"
ValidationExpression="[a-zA-Z\\].*(.pdf|.PDF)$"></asp:RegularExpressionValidator>
        <asp:Label ID="Label1" runat="server" ForeColor="Red" Text="<br/>Note:- <br/>1. Only .pdf files is allowed.<br/>2. Maximum file size upto 10 MB."></asp:Label>

                        </td>
                        
                    </tr>
                </table>
                </div>
            </div>

           <div class="POuter_Box_Inventory" style="width:900px;">
            <div class="content">
                <asp:GridView ID="grd" Width="90%" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4"  OnRowCommand="grd_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Sr.No">
                           
                            <ItemTemplate>
                              <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View Result">
                           
                            <ItemTemplate>


                                <a target="_blank" href='CAPResult/<%# Eval("filename")%>'>View CAP Result</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="EntryDate" HeaderText="EntryDate" />
                        <asp:BoundField DataField="EntryByName" HeaderText="Entry By" />
                        <asp:TemplateField HeaderText="Remove">
                            
                            <ItemTemplate>
                                 <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/App_Images/Delete.gif" runat="server" OnClientClick="return confirm('Are you sure you want to delete this result?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
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
        </form>
</body>
</html>

