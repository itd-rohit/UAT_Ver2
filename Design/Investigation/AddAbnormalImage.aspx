<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddAbnormalImage.aspx.cs" Inherits="Design_Investigation_AddAbnormalImage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
       <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">

            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Add Abnormal Image</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>


            <div class="POuter_Box_Inventory">

                <table style="width: 100%; border-collapse: collapse">

                    <tr>
                        <td style="text-align: center" colspan="4">&nbsp;</td>
                    </tr>


                    <tr>
                        <td style="text-align: center">&nbsp;</td>
                        <td  style="text-align:right">Name :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddllabobservation" runat="server" />
                            <asp:RequiredFieldValidator InitialValue="0" ID="Req_ID" Display="Static"
                                ValidationGroup="fUpload" runat="server" ControlToValidate="ddllabobservation"
                                Text="Select Observation" ErrorMessage="ErrorMessage"></asp:RequiredFieldValidator>
                        </td>
                        <td style="text-align: center">&nbsp;</td>
                    </tr>


                    <tr>
                        <td style="text-align: center">&nbsp;</td>
                        <td style="text-align:right">Image :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:FileUpload ID="file1" runat="server" />

                            <asp:RequiredFieldValidator ID="rfvFileUpload" runat="server" ControlToValidate="file1" ValidationGroup="fUpload"
                                ErrorMessage="Select File"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="DocumentUploadExpressionValidator" runat="server" ValidationGroup="fUpload"
                                ControlToValidate="file1" Display="Dynamic"
                                ErrorMessage="<br/>Only .jpg.,png,.gif,.jpeg files is allowed."
                                ValidationExpression="[a-zA-Z\\].*(.jpg|.JPG|.png|.PNG|.gif|.GIF|.jpeg|.JPEG)$"></asp:RegularExpressionValidator>

                        </td>
                        <td style="text-align: center">&nbsp;</td>
                    </tr>


                    <tr>
                        <td style="text-align: center" colspan="4">
                            <asp:Button runat="server" ID="btnsave" Text="Save" OnClick="btnsave_Click" ValidationGroup="fUpload" />
                            <asp:Button runat="server" ID="btnUpdate" Text="Update" OnClick="btnUpdate_Click" ValidationGroup="fUpload" Visible="false" />


                        </td>
                    </tr>





                </table>
            </div>
           
       <div class="POuter_Box_Inventory" >

          
               <div style="width: 890px; height: 300px; overflow: scroll;">
                    <table style="width: 100%; border-collapse: collapse">
                       <tr>
                           <td align="center">
                               <asp:GridView ID="mygrd" runat="server" AutoGenerateColumns="False" EnableModelValidation="True" CssClass="GridViewStyle" Width="518px" OnSelectedIndexChanged="mygrd_SelectedIndexChanged">
                                   <Columns>
                                       <asp:TemplateField HeaderText="ID">
                                           <EditItemTemplate>
                                               <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("labobservation_id") %>'></asp:TextBox>
                                           </EditItemTemplate>
                                           <ItemTemplate>

                                               <asp:Label ID="Label1" runat="server" Text='<%# Bind("labobservation_id") %>'></asp:Label>
                                               <asp:Label Visible="false" ID="Label5" runat="server" Text='<%# Bind("abnormalimage") %>'></asp:Label>
                                           </ItemTemplate>
                                           <HeaderStyle CssClass="GridViewHeaderStyle" />
                                           <ItemStyle CssClass="GridViewItemStyle" />
                                       </asp:TemplateField>
                                       <asp:TemplateField HeaderText="Name">
                                           <EditItemTemplate>
                                               <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                                           </EditItemTemplate>
                                           <ItemTemplate>
                                               <asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                                           </ItemTemplate>
                                           <HeaderStyle CssClass="GridViewHeaderStyle" />
                                           <ItemStyle CssClass="GridViewItemStyle" />
                                       </asp:TemplateField>
                                       <asp:TemplateField HeaderText="Image">

                                           <ItemTemplate>
                                               <asp:Image ID="myimg" runat="server" Height="80px" Width="80px" ImageUrl='<%# Bind("img") %>' />
                                           </ItemTemplate>
                                           <HeaderStyle CssClass="GridViewHeaderStyle" />
                                           <ItemStyle CssClass="GridViewItemStyle" />
                                       </asp:TemplateField>
                                       <asp:TemplateField HeaderText="Delete">
                                           <ItemStyle CssClass="GridViewItemStyle" />
                                           <HeaderStyle CssClass="GridViewHeaderStyle" />
                                           <ItemTemplate>
                                               <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                                   Text="Delete"></asp:LinkButton>
                                           </ItemTemplate>

                                       </asp:TemplateField>
                                   </Columns>

                               </asp:GridView>
                           </td>
                       </tr>
                   </table>
               </div>
           
       </div>

       
        </div>
    </form>
</body>
</html>
