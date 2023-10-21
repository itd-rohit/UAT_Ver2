<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDPhoneBookingSearch.aspx.cs" Inherits="Design_FrontOffice_OPDPhoneBookingSearch" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ID="Content1">
     <link rel="stylesheet" href="jquery.autocomplete.css" type="text/css"/>

   

     <script  src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>
 
   <link href="../../JavaScript/jquery-ui-1.7.3.custom/css/ui-lightness/jquery-ui-1.7.3.custom.css" rel="Stylesheet" type="text/css" /> 
      <script type="text/javascript" src="../../js/TimePicker/jquery.ui.timepicker.js"></script>
     <link href="../../js/TimePicker/jquery.ui.timepicker.css" rel="stylesheet" type="text/css" />
 <script type="text/javascript" src="../../JavaScript/json2.js"></script>

    
  

 <script src="../../scripts/jquery-1.4.1.min.js" type="text/javascript"></script>

<script src="../../scripts/jquery.autocomplete.js" type="text/javascript"></script>   
    <script type="text/javascript" language="javascript" src="../Common/Search.js"></script>
         <script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"> </script>
      <script type="text/javascript" src="../../JavaScript/jquery.alerts-1.1/jquery.alerts.js"></script>    
       <script type="text/javascript" language="javascript" src="../../JavaScript/jquery-ui-1.7.3.custom/js/jquery-ui-1.7.3.custom.min.js"></script> 


    <script type="text/javascript">
        function AutoGender() {
            var ddltitle = document.getElementById('<%=ddltitle.ClientID%>');

             var ddltxt = ddltitle.options[ddltitle.selectedIndex].value;
             if (ddltxt == "Mrs." || ddltxt == "Miss." || ddltxt == "Baby." || ddltxt == "Ms." || ddltxt == "Smt.")

                 document.getElementById('<%=ddlGender.ClientID%>').value = "Female";

        else

            document.getElementById('<%=ddlGender.ClientID%>').value = "Male";

    }
    </script>
     <ajax:scriptmanager ID="ScriptManager1" runat="server">
        </ajax:scriptmanager>
        <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../Purchase/Image/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
      <Ajax:UpdatePanel ID="mm" runat="server">
          <ContentTemplate> 
               <div id="Pbody_box_inventory" style="width:1200px;">
        <div class="POuter_Box_Inventory" style="height:45px;width:1200px;">
            <div class="content" style="text-align: center; height:50px;">
                <b><asp:Label ID="llheader" runat="server" Text="OPD Consultation/Appointment Search"></asp:Label></b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
               
            

              
            </div>
        </div>

                     <div class="POuter_Box_Inventory" style="width:1200px;">
                         <table width="100%">
                             <tr>
                                 <td align="right">From Date :&nbsp;</td>
                                  <td align="left"><asp:TextBox ID="txtfromdate" runat="server" Width="100px"></asp:TextBox>

                                       <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy"  PopupButtonID="txtfromdate" TargetControlID="txtfromdate">
                        </cc1:CalendarExtender>
                                  </td>
                                  <td align="right">To Date :&nbsp;</td>
                                  <td align="left"><asp:TextBox ID="txttodate" runat="server"  Width="100px"></asp:TextBox>
                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"  PopupButtonID="txttodate" TargetControlID="txttodate">
                        </cc1:CalendarExtender>
                                  </td>
                             </tr>
                             <tr>
                             <td align="right">Doctor :&nbsp;</td>
                             <td align="left"><asp:DropDownList ID="ddldoctor" runat="server"></asp:DropDownList></td>
                            <td align="right">Pname :&nbsp;</td>
                             <td align="left"><asp:TextBox ID="txtpname" runat="server"></asp:TextBox></td></tr>
                             <tr>
                                <td align="right">Mobile :&nbsp;</td>
                                 <td align="left"><asp:TextBox ID="txtmobile" runat="server"  Width="100px"></asp:TextBox></td>
                                  <td align="right">Status :&nbsp;</td>
                                 <td><asp:DropDownList ID="ddlstatus" runat="server">
                                     <asp:ListItem Value="0">Register</asp:ListItem>
                                       <asp:ListItem Value="1">NotRegister</asp:ListItem>
                                       <asp:ListItem Value="2">Canceled</asp:ListItem>
                                     </asp:DropDownList></td>

                             </tr>

                             <tr>
                                 <td colspan="4" align="center"><asp:Button ID="btnsearch" runat="server" Text="Search Appointment" OnClick="btnsearch_Click" /></td>
                             </tr>
                         </table>
                        </div>

                     <div class="POuter_Box_Inventory" style="width:1200px;">
                         <asp:GridView ID="grdapp" runat="server" Width="99%" AutoGenerateColumns="False" EnableModelValidation="True" BackColor="#CCCCCC" BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2" ForeColor="Black" OnRowCommand="grdapp_RowCommand" DataKeyNames="app_id" OnRowDataBound="grdapp_RowDataBound">
                             
                             <Columns>
                                <asp:TemplateField HeaderText="S.No">
                   <ItemTemplate>
                       <%# Container.DataItemIndex+1 %>
                   </ItemTemplate>
                 
               </asp:TemplateField>
                                 <asp:BoundField DataField="pname" HeaderText="Pname" />
                                 <asp:BoundField DataField="age" HeaderText="Age" />
                                 <asp:BoundField DataField="gender" HeaderText="Gender" />
                                 <asp:BoundField DataField="mobile" HeaderText="Mobile" />
                                 <asp:BoundField DataField="dname" HeaderText="Doctor" />
                                 <asp:BoundField DataField="appdate" HeaderText="AppDate" />
                                 <asp:BoundField DataField="apptime" HeaderText="AppTime" />
                                 <asp:BoundField DataField="status" HeaderText="Status" />
                                 <asp:TemplateField HeaderText="Cancel App">
                 
                   <ItemTemplate> 
                       <asp:ImageButton ID="imbRemove" ToolTip="Cancel App" runat="server" ImageUrl="~/Design/Purchase/Image/Delete.gif"
                           CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                           <%--<asp:Label ID="lbllabType" runat="server" Text='<%# Eval("Type") %>' Visible="false"/>--%>
                   </ItemTemplate>
               </asp:TemplateField>
                                   <asp:TemplateField HeaderText="Edit Booking">
                 
                   <ItemTemplate> 
                       <asp:ImageButton ID="imbRemove1" ToolTip="Edit Booking" runat="server" ImageUrl="~/Design/Purchase/Image/edit.png"
                           CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="editbooking" />
                           <asp:Label ID="lblpid" runat="server" Text='<%# Eval("patient_id") %>' Visible="false"/>
                   </ItemTemplate>
               </asp:TemplateField>
                                   <asp:TemplateField HeaderText="Cancel Booking">
                 
                   <ItemTemplate> 
                       <asp:ImageButton ID="imbRemove2" ToolTip="Cancel Booking" runat="server" ImageUrl="~/Design/Purchase/Image/Delete.gif"
                           CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="cancelbooking" />
                           <asp:Label ID="labno" runat="server" Text='<%# Eval("LedgerTransactionNO") %>' Visible="false"/>
                   </ItemTemplate>

               </asp:TemplateField>

                             </Columns>
                             
                             <FooterStyle BackColor="#CCCCCC" />
                             <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                             <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />
                             <RowStyle BackColor="White" />
                             <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                             
                         </asp:GridView>
                         </div>
              

         <%--  <Triggers>
        <Ajax:PostBackTrigger ControlID="btnExport" />
    </Triggers>--%>

<asp:Panel ID="mypanel" runat="server"  BackColor="#E1DDE4" style="display:none;border:1px solid black;" Width="500px" Height="100px">
      <div class="Purchaseheader">Cancel Booking</div>
       <table width="90%">
           <tr>
               <td>
                 <strong  >Cancel Reason :</strong>   <asp:TextBox runat="server" ID="txtcancereason" Width="300px"></asp:TextBox>
                   <asp:RequiredFieldValidator ID="rr" runat="server" ControlToValidate="txtcancereason" ErrorMessage="*" ForeColor="Red" Font-Bold="true" ValidationGroup="mm" />
               </td>
           </tr>
       </table>
   
        <center>
           <asp:Button ID="btncancelbooking" runat="server" OnClick="btncancelbooking_Click" Text="Save" ValidationGroup="mm" />
            &nbsp;&nbsp;<asp:Button ID="hideme" runat="server" Text="Close" /></center>
    </asp:Panel>
           <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="hideme" TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="mypanel">
    </cc1:ModalPopupExtender>


    <asp:Button ID="Button2" style="display:none;" runat="server" />



                   <asp:Panel ID="Panel1" runat="server"  BackColor="#E1DDE4" style="display:none;border:1px solid black;" Width="800px">
      <div class="Purchaseheader">Edit Booking</div>
       <table width="90%">
           <tr>
               <td>
                 Patient Name :
                   </td>
                  <td> <asp:DropDownList ID="ddltitle" runat="server" onChange="return AutoGender();"></asp:DropDownList>  
                       <asp:TextBox runat="server" ID="txtpnameedit" Width="200px"></asp:TextBox>
                   <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtpnameedit" ErrorMessage="*" ForeColor="Red" Font-Bold="true" ValidationGroup="mmm" />
               </td>

               <td>Age :
               </td>
               <td><asp:TextBox  ID="txtAge" runat="server"  CssClass="ItDoseTextinputText"  Width="70px" MaxLength="5" TabIndex="4" />
                   <asp:DropDownList
                                ID="ddlAge" runat="server" CssClass="ItDoseDropdownbox" Width="75px">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem>DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="ItDoseDropdownbox" onchange="resetItem();" Width="75px">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                            </asp:DropDownList>
               </td>

             
           </tr>

           <tr>
               <td>
                   Mobile :
               </td>
               <td>
                   <asp:TextBox ID="txtmobileedit" runat="server" Width="100px" MaxLength="10"></asp:TextBox>
               </td>
               <td>
                   Address :
               </td>
               <td><asp:TextBox ID="txtadddressedit" runat="server" Width="200px"></asp:TextBox></td>
           </tr>


           <tr>
               <td>
                   City :
               </td>
               <td><asp:TextBox ID="txtcityedit" runat="server" Width="200px"></asp:TextBox></td>
               <td></td>
               <td></td>
           </tr>
       </table>
   
        <center>
           <asp:Button ID="btnedtbooking" runat="server" OnClick="btnedtbooking_Click" Text="Update" ValidationGroup="mmm" />
            &nbsp;&nbsp;<asp:Button ID="Button3" runat="server" Text="Close" /></center>
    </asp:Panel>
           <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="Button3" TargetControlID="Button11"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1">
    </cc1:ModalPopupExtender>

<asp:Button ID="Button11" style="display:none;" runat="server" />
 </ContentTemplate>
      </Ajax:UpdatePanel> 
</asp:Content>

