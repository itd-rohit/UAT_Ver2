<%--<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MachineMaster.aspx.cs" Inherits="Design_Machine_MachineMaster" %>--%>


<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MachineMaster.aspx.cs" Inherits="Design_Machine_MachineMaster" Title="Machinemaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript">

    </script>
    <div id="Pbody_box_inventory">
         <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
         <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Machine Group</b><br />

            <asp:Label ID="Label1" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
              <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>


        </div>
         <div class="POuter_Box_Inventory">
           <div class="Purchaseheader">
                Save Machine Master
            </div>
            <div class="row">
                <div class="col-md-3">
                    Machine ID :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtMachineID" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-3">
                   Machine Name:
                </div>
                <div class="col-md-5">
                   <asp:TextBox ID="txtMachineName" runat="server" ></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">Centre ID:
                </div>
                 <div class="col-md-5">
                     <asp:DropDownList ID="ddlcentre" runat="server" style="margin-left: 0px" >
                            <asp:ListItem Selected="true" Value="1">Select Centre </asp:ListItem>
                        </asp:DropDownList>
                     </div>
                <div class="col-md-3"> Global MachineID: :
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlmachine" runat="server" >
                            <asp:ListItem Selected="true" Value="1">Select MachineName </asp:ListItem>
                        </asp:DropDownList>
                </div>
            </div>
              <div class="row">
                <div class="col-md-3">BachRequest:
                </div>
                 <div class="col-md-5">
                     <asp:DropDownList ID="ddlbacheequest" runat="server" Width="100px">
                            <asp:ListItem Selected="true" Value="0">No</asp:ListItem>
                            <asp:ListItem Value="1">Yes</asp:ListItem>
                        </asp:DropDownList>
                     </div>
                
            </div>
            <div class="row" style="text-align:center">
                <asp:Button ID="btsave" runat="server" Height="21px" OnClick="btsave_Click" Text="Save" Width="161px" />
            </div>
         

        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Machine Master
            </div>
     
     

            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"  width="1350px"                    
                    OnPageIndexChanging="GridView1_PageIndexChanging" TabIndex="10" 
                    CssClass="GridViewStyle" PageSize="20" 
                    EnableModelValidation="True"  style="background-color:#D7EDFF;" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                        <asp:TemplateField HeaderText="S.No." >
                        <ItemTemplate>
                        <%# Container.DataItemIndex+1 %>
                        </ItemTemplate> 
                        <ItemStyle CssClass="GridViewItemStyle"/>
                        <HeaderStyle CssClass="GridViewHeaderStyle"/>
                        </asp:TemplateField> 
                            <asp:BoundField DataField="MachineID" HeaderText="MachineID" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="MachineName" HeaderText="Machine Name" >
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Centreid" HeaderText="CentreID" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                             <asp:BoundField DataField="BatchRequest" HeaderText="BatchRequest" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:BoundField>
                            <asp:BoundField DataField="GroupID" HeaderText="GroupId" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"/>
                            </asp:BoundField>       
                             
                             <asp:CommandField ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Select" />
                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="MachineID" runat="server" Text='<%#Eval("MachineID") %>'></asp:Label>
                                            </ItemTemplate>

                                        </asp:TemplateField>
                          
                            
                        </Columns>                        
                    </asp:GridView>

        </div>


    </div>






</asp:Content>



