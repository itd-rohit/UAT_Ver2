
<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineGroup.aspx.cs" Inherits="Design_Machine_MachineGroup" Title="MachineGroup" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>

    <div id="Pbody_box_inventory">
	 <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
                 <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
           </div>
		   <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Machine Group</b>
			<asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
           </div>

 <div class="POuter_Box_Inventory">
     <div class="Purchaseheader">
                        Basic Information&nbsp;
                    </div>
                        <div class="row">
                            <div class="col-md-24">
							     <div class="col-md-6">
								</div>
                                <div class="col-md-3" style="color: maroon; font-weight: bold;text-align:right">
                                    Machine Name:
                                </div>
                                <div class="col-md-5">
                                      <asp:TextBox ID="txtName" runat="server" Width="223px"></asp:TextBox>
                                     <asp:HiddenField ID="txtID" runat="server"></asp:HiddenField>
                                </div>
                               
                               
                                <div class="col-md-2">
                                   <asp:Button ID="btnsave" runat="server" OnClick="btnsave_Click" Text="Save" Width="133px" />   
                                </div>
                                <div class="col-md-6">
								</div>

                            </div>
                        </div>
             
             
                    
                
                      <div class="row">
                          <div class="col-md-3"></div>
                      <div class="col-md-18"  height: 500px;">
                            <div class="POuter_Box_Inventory" style="text-align: center;width:500px;">

            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"                      
                    OnPageIndexChanging="GridView1_PageIndexChanging" TabIndex="10" width="1000px"
                    CssClass="GridViewStyle" PageSize="20" 
                    EnableModelValidation="True"  style="background-color:#D7EDFF;" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                  
                        <Columns>
                        
                            <asp:BoundField DataField="ID" HeaderText="ID" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="130px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="Name" >
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px"/>
                            </asp:BoundField> 
                             
                             <asp:CommandField ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Select" />
                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="ID" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                            </ItemTemplate>

                                        </asp:TemplateField>
                          
                            
                        </Columns>                        
                    </asp:GridView>

        </div>
                      
                          </div>
                          <div class="col-md-3"></div>
                          </div>
                
          </div>
     </div>
        
       
      








</asp:Content>



