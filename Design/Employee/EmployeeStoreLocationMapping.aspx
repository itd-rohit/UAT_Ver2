<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmployeeStoreLocationMapping.aspx.cs" Inherits="Design_Employee_EmployeeStoreLocationMapping" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server" id="Head1">

         <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     
     

          

         <style type="text/css">
             .auto-style1 {
                 width: 103px;
             }
         </style>
     
     

          

    </head>
<body>
  
   
      <form id="form1" runat="server">
    
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>

 
<Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src=""../../App_Images/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
      <Ajax:UpdatePanel ID="mm" runat="server">
          <ContentTemplate> 
      
       
    <div id="Pbody_box_inventory" style="width:1056px;">

         <div class="POuter_Box_Inventory" style="width:1050px;">
            <div class="row">

                 <div class="col-md-24" style="text-align:center">
                     <b> Map Employee With Store Location</b>
                      </div>
                <div class="col-md-24" style="text-align:center">
                    <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                    </div>

                  <div class="col-md-12" style="text-align:right">
                      <strong>Current Employee :</strong>
                       </div>

                <div class="col-md-12" style="text-align:left">
                    <asp:DropDownList ID="ddlemployee" runat="server" ></asp:DropDownList>
                    </div>
                  </div>
               
               


              </div>

           <div class="POuter_Box_Inventory" style="width:1050px;">
           <div class="row">

                 <div class="col-md-3" >
                     <label class="pull-left">Centre   </label>
                <b class="pull-right">:</b>
                       </div>

               <div  class="col-md-21">
                    <div style="max-height:200px;overflow:auto;">
                            <asp:GridView ID="ddlcentre" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Centre">
                                   
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("centre") %>'></asp:Label>
                                         <asp:Label ID="Label2" runat="server" Text='<%# Bind("centreid") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                            <RowStyle ForeColor="#000066" />
                            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#F1F1F1" />
                            <SortedAscendingHeaderStyle BackColor="#007DBB" />
                            <SortedDescendingCellStyle BackColor="#CAC9C9" />
                            <SortedDescendingHeaderStyle BackColor="#00547E" />
                            </asp:GridView></div>
               </div>
                 </div>
                <div class="row">

                 <div class="col-md-3" >
                     <label class="pull-left"><asp:CheckBox ID="chkPUP" runat="server" Text="SHOW PUP" AutoPostBack="true" OnCheckedChanged="ch_ShowPUP" />   </label>
                <b class="pull-right">:</b>
                       </div>
 </div>

                     <div class="row">

                 <div class="col-md-3" >
                     <asp:CheckBox ID="ch" runat="server" Text="Location :" AutoPostBack="true" OnCheckedChanged="ch_CheckedChanged" />
                      </div>

                          
               <div class="col-md-21" >
                   <div style="max-height:250px;overflow:auto;">
                            <asp:CheckBoxList ID="chlist" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" ></asp:CheckBoxList>

                                </div>
                    </div></div>
                </div>
               
                
              

        <div class="POuter_Box_Inventory" style="width:1050px;text-align:center;">

    <asp:Button ID="btnsave" Text="Save" runat="server" CssClass="savebutton" OnClick="btnsave_Click" />

              
            </div>
           

           
    </div>

               </ContentTemplate>

           
      </Ajax:UpdatePanel> 
    </form>
</body>
</html>

