 <%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionMappingUpload.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionMappingUpload" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  
   
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    
    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align:center">
                <b>Import Home Collection Mapping</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ></asp:Label>
            </div>
            </div>
        <div class="POuter_Box_Inventory">
            
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left"><b>Zone</b></label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlzone" runat="server"  AutoPostBack="true" OnSelectedIndexChanged="ddlzone_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-2">
                            <label class="pull-left"><b>State </b></label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlstate" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlstate_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left"><b>City  </b></label>
			                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlcity" runat="server" >
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btndownloadexcel" runat="server" OnClick="btndownloadexcel_Click" Text="Download Excel" CssClass="searchbutton" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><b>Upload Excel </b></label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                                  <asp:FileUpload ID="file1" runat="server" style="font-weight: 700" />
                             <asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click" CssClass="searchbutton" />
                                  <asp:Button ID="btnsave" runat="server" Text="Save  Mapping" OnClick="btnsave_Click"  CssClass="savebutton"/>
                        </div>

                    </div>
                  
                </div>
           

           <div class="POuter_Box_Inventory" >
           
                <div style="width:99%;overflow:auto;height:400px;">

                
            <asp:GridView ID="grd" runat="server" BackColor="#CCCCCC" BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2" ForeColor="Black">
                        <Columns>
                           <asp:TemplateField HeaderText="SrNo">
                           
                              <ItemTemplate>
                   <%# Container.DataItemIndex+1 %>
                    </ItemTemplate>
                               </asp:TemplateField>
                            <asp:TemplateField HeaderText="Select">
                                  <ItemTemplate>
                              <asp:CheckBox ID="chk" Checked="true" runat="server" />
                            </ItemTemplate>
                            </asp:TemplateField>
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
      </div>  </div>
       
  </div>
         
</asp:Content>

