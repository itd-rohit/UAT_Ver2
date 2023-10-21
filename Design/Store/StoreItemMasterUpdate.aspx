<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StoreItemMasterUpdate.aspx.cs" Inherits="Design_Store_StoreItemMasterUpdate" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    
    
     <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
     
     <asp:UpdatePanel ID="up" runat="server">
         <ContentTemplate>
     <div id="Pbody_box_inventory" >
          <div id="Div1" >

         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

          <div class="POuter_Box_Inventory" style="text-align:center">
            
                          <b>Store Item Master Update</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                       
              </div>
          <div class="POuter_Box_Inventory" >
               <div class="Purchaseheader">Item Details</div>
                     <div class="row" >
	  <div class="col-md-3 " >
			   <label class="pull-left"> Search Item   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " >
			   <asp:TextBox ID="txtitemsearch" runat="server"  placeholder="Enter ItemName here" style="text-transform:capitalize;">

                                           </asp:TextBox>	 		 
		   </div>
                         <div class="col-md-3 " >
			   <asp:Button ID="btnsaearch" runat="server" CssClass="searchbutton" Text="Search" OnClick="btnsaearch_Click" />
                                             		 
		   </div>
                                               
                     </div>     
                        
                                <div class="row" >

                                <asp:GridView Width="99%" ID="grditem" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                                    <Columns>
                                         <asp:TemplateField HeaderText="Sr.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex + 1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                                        <asp:BoundField DataField="ItemName" HeaderText="Item Name" />
                                        <asp:BoundField DataField="MachineName" HeaderText="Machine Name" />
                                        <asp:BoundField DataField="ManufactureName" HeaderText="Manufacture Name" />
                                        <asp:BoundField DataField="PackSize" HeaderText="Pack Size" />
                                        <asp:BoundField DataField="CatalogNo" HeaderText="CatalogNo" />
                                        <asp:BoundField DataField="MajorUnitName" HeaderText="Purchase Unit" />
                                        <asp:BoundField DataField="MinorUnitName" HeaderText="Consume Unit" />
                                        <asp:BoundField DataField="GSTNTax" HeaderText="GSTN Tax" />
                                        <asp:BoundField DataField="Expdatecutoff" HeaderText="Expdatecutoff" />
                                        <asp:BoundField DataField="HsnCode" HeaderText="Hsn Code" />
                                        <asp:TemplateField HeaderText="Edit">                                        
                                        <ItemTemplate>
                                                <asp:Label ID="lbitemid" Visible="false" runat="server" Text='<%# Bind("itemid") %>'></asp:Label>
                                                <asp:Label ID="lbItemName" Visible="false" runat="server" Text='<%# Bind("ItemName") %>'></asp:Label>
                                                <asp:Label ID="lbMachineID" Visible="false" runat="server" Text='<%# Bind("MachineID") %>'></asp:Label>
                                                <asp:Label ID="lbManufactureID" Visible="false" runat="server" Text='<%# Bind("ManufactureID") %>'></asp:Label>
                                                <asp:Label ID="lbMajorUnitId" Visible="false" runat="server" Text='<%# Bind("MajorUnitId") %>'></asp:Label>
                                                <asp:Label ID="lbMinorUnitId" Visible="false" runat="server" Text='<%# Bind("MinorUnitId") %>'></asp:Label>
                                                <asp:Label ID="lbConverter" Visible="false" runat="server" Text='<%# Bind("Converter") %>'></asp:Label>
                                                <asp:Label ID="lbGSTNTax" Visible="false" runat="server" Text='<%# Bind("GSTNTax") %>'></asp:Label>
                                                <asp:Label ID="lbExpdatecutoff" Visible="false" runat="server" Text='<%# Bind("Expdatecutoff") %>'></asp:Label>
                                                <asp:Label ID="lbHsnCode" Visible="false" runat="server" Text='<%# Bind("HsnCode") %>'></asp:Label>
                                                <asp:Label ID="lbPackSize" Visible="false" runat="server" Text='<%# Bind("PackSize") %>'></asp:Label>
                                                <asp:Label ID="lbissuemultiplier" Visible="false" runat="server" Text='<%# Bind("IssueMultiplier") %>'></asp:Label>
                                                <asp:Label ID="lbCatalogNo" Visible="false" runat="server" Text='<%# Bind("CatalogNo") %>'></asp:Label>
                                                <asp:Label ID="lbitemidgroup" Visible="false" runat="server" Text='<%# Bind("itemidgroup") %>'></asp:Label>
                                                <asp:ImageButton ID="btn" runat="server" ImageUrl="~/App_Images/edit.png" OnClick="btn_Click" />                       
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>


                                    <FooterStyle BackColor="White" ForeColor="#000066" />
                                    <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                    <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                    <RowStyle ForeColor="#000066" />
                                    <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                                    <SortedAscendingCellStyle BackColor="#F1F1F1" />
                                    <SortedAscendingHeaderStyle BackColor="#007DBB" />
                                    <SortedDescendingCellStyle BackColor="#CAC9C9" />
                                    <SortedDescendingHeaderStyle BackColor="#00547E" />

                                </asp:GridView>

                                    </div>
                           
                  
              </div>

          </div>

          
              </div>

        


    <asp:Panel ID="panelemp"  runat="server" style="width:910px;background-color:wheat;display:none;">
         <div class="POuter_Box_Inventory">
             
                <div class="Purchaseheader">Edit Item Details</div>
             <div class="row" style="text-align:center">
                 
                           <asp:Label ID="lbmsg1" runat="server" Font-Bold="true" ForeColor="Red">

                           </asp:Label>
                      
                   </div>

                   <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">Item Name  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                           <asp:TextBox ID="txtitemidedit" runat="server"></asp:TextBox>

                           <asp:Label ID="lbitemidedit" runat="server" Visible="false"></asp:Label>
                             <asp:Label ID="lbitemidgroupedit" Visible="false" runat="server" ></asp:Label>
                       </div>
                   </div>

                   <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">Machine  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                          <asp:DropDownList ID="ddlmachine" runat="server"  />
                       </div>
                   </div>
                 <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">Manufacture  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                           <asp:DropDownList ID="ddlmanufacture" runat="server" />
                       </div>
                   </div>
                            <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">Pack Size  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                           <asp:TextBox ID="txtpacksize" runat="server"  />
                       </div>
                   <div class="col-md-3">
                           <label class="pull-left">CataLog No  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                           <asp:TextBox ID="txtcatalogno" runat="server"  />
                       </div>
                   
                            </div>
                 
                   <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">Puchase Unit  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                            <asp:DropDownList ID="ddlpurchaseunit" runat="server"  />
                       </div>
                   <div class="col-md-3">
                           <label class="pull-left">Consume Unit  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                           <asp:DropDownList ID="ddlconsumeunit" runat="server"  />

                       </div>
                   
                            </div>
                 
                      <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">GSTNTax  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                            <asp:TextBox ID="txtgstntax" runat="server" /><span style="font-size:10px;font-style:italic;color:red">Quotation Tax and Pending PI Will Auto Update</span>
                            <asp:TextBox ID="txtgstntaxold" runat="server" ReadOnly="true" Visible="false" />
                       </div>
                   <div class="col-md-3">
                           <label class="pull-left">Expdatecutoff  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                          <asp:TextBox ID="txtExpdatecutoff" runat="server"  />
                       </div>
                   
                            </div>
                    
                     <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">Converter  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                           <asp:TextBox ID="txtConverter" runat="server"  />
                             <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender3" runat="server" FilterType="Numbers,Custom" TargetControlID="txtConverter" ValidChars=".">
                                </cc1:FilteredTextBoxExtender>
                       </div>
                   <div class="col-md-3">
                           <label class="pull-left">HsnCode   </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                          <asp:TextBox ID="txtHsnCode" runat="server" />
                       </div>
                   
                            </div>
                  
             <div class="row">
                       <div class="col-md-3">
                           <label class="pull-left">Issue Multiplier  </label>
			   <b class="pull-right">:</b>
		                 </div>
                          
                       
                       <div class="col-md-5">
                           <asp:TextBox ID="txtissuemultiplier" runat="server" Width="120px" />
                            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender4" runat="server" FilterType="Numbers" TargetControlID="txtissuemultiplier">
                                </cc1:FilteredTextBoxExtender>
                       
                       </div>
                  </div>
                    

                   <div class="row">
                       <div class="col-md-3" style="text-align: right">

                           <asp:Button ID="btnupdate" runat="server" CssClass="savebutton" Text="Update" OnClick="btnupdate_Click" />&nbsp;&nbsp;
                       </div>
                        <div class="col-md-3" style="text-align: left">&nbsp;&nbsp;<asp:Button ID="btnclosefa" runat="server" CssClass="resetbutton" Text="Close" /></div>
                   </div>
               

                  
             </div>
    </asp:Panel>


      <cc1:ModalPopupExtender ID="mode" runat="server"   TargetControlID="Button1" BackgroundCssClass="filterPupupBackground" PopupControlID="panelemp"  CancelControlID="btnclosefa">
      </cc1:ModalPopupExtender>

      <asp:Button ID="Button1" runat="server" style="display:none;" />
     </ContentTemplate>
     </asp:UpdatePanel>
 </asp:Content>