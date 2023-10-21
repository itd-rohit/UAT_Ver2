
<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master"  CodeFile="ViewDoctorDetail.aspx.cs" Inherits="Design_Employee_Registration_ViewDoctorDetail" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript" language="javascript">
function ClickSelectbtn(e,btnName)
    {
        //the purpose of this function is to allow the enter key to 
        //point to the correct button to click.
        if (window.event.keyCode == 13)
        { 
           var btn = document.getElementById(btnName);
           alert(btn);
            if (btn != null)
            { //If we find the button click it
                btn.click();
                event.keyCode = 0
                return false;
            }
        }
   }
</script>
     <div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory" style="text-align:center;">
    <b>Search Doctor Details</b>
     
    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />&nbsp;</div>
   
  </div>
      
    <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">
        Search Criteria</div>
     <div class="row">
         <div class="col-md-3 ">
			   <label class="pull-left"> Doctor Name  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-4 ">
                 <asp:TextBox ID="txtName" runat="server" MaxLength="100" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                        ToolTip="Enter Patient ID"  TabIndex="1"></asp:TextBox></div>
               <div class="col-md-3 ">
			   <label class="pull-left">Department  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-4 ">
                 
                    <asp:DropDownList ID="cmbDept" runat="server" CssClass="ItDoseDropdownbox" TabIndex="2" >
                    </asp:DropDownList></div>
         <div class="col-md-3 ">
			   <label class="pull-left"> Specialization </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-4 ">
                  
                 <asp:DropDownList ID="lstSpecial" runat="server" CssClass="ItDoseDropdownbox" TabIndex="2">
                    </asp:DropDownList></div>
                 <div class="col-md-3">

                       <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" OnClientClick="RestrictDoubleEntry(this);" TabIndex="7"
                        Text="Search"  OnClick="btnSearch_Click" />
                 </div>
                 </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Doctor Details</div>
                   
                   
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"                     
                    OnPageIndexChanging="GridView1_PageIndexChanging" TabIndex="5"
                    CssClass="GridViewStyle" AllowPaging="True" >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                        <asp:TemplateField HeaderText="S.No." >
                        <ItemTemplate>
                        <%# Container.DataItemIndex+1 %>
                        </ItemTemplate> 
                        <ItemStyle CssClass="GridViewItemStyle" Width="30px"/>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px"/>
                        </asp:TemplateField> 
                            <asp:BoundField DataField="Name" HeaderText="Name" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="230px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="230px"/>
                            </asp:BoundField>

                             <asp:BoundField DataField="DID" HeaderText="Doctor_ID" >
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px"/>
                            </asp:BoundField>

                            <asp:BoundField DataField="Specialization" HeaderText="Specialization" >
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Degree" HeaderText="Degree" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="Department" HeaderText="Department" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="130px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="130px"/>
                            </asp:BoundField>
                            <asp:HyperLinkField HeaderText="Edit" Text="Edit" DataNavigateUrlFields="DID,updateFlag" Target="_blank" DataNavigateUrlFormatString="~/Design/OPDConsultation/DoctorEdit.aspx?DID={0}&amp;updateFlag={1}" NavigateUrl="~/Design/FrontOffice/DoctorEdit.aspx" >
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="5px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px"/>
                            </asp:HyperLinkField> 
                            <asp:CommandField HeaderText="Rate" SelectText="Rate" ShowSelectButton="True" >
                               <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:CommandField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:Label ID="lblDID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DID") %>'
                                        Visible="False"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>                        
                    </asp:GridView>
            </div>
           <asp:Panel ID="Panel1" runat="server">  
            <div class="POuter_Box_Inventory" >
                <div class="Purchaseheader">
                    Doctor Charges :</div>                    
        
       <div class="row" style="display:none">        <div class="col-md-5">
                <asp:RadioButton ID="rdbOPD" runat="server" GroupName="a" Text="OPD" Checked="True"  OnCheckedChanged="rdbOPD_CheckedChanged" CssClass="ItDoseCheckboxlistSpl" />&nbsp;
                <asp:RadioButton ID="rdbIPD" runat="server" GroupName="a" Text="IPD" AutoPostBack="True" OnCheckedChanged="rdbIPD_CheckedChanged"  CssClass="ItDoseCheckboxlistSpl"  /></td>
       </div>   </div>
  
           <div class="row">
         <div class="col-md-3 ">
			   <label class="pull-left"> Doctor Name </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                 
                <asp:Label ID="lblDName" runat="server"></asp:Label></div>
                 <div class="col-md-5" >
                    <asp:Button ID="btnView" runat="server" OnClick="btnView_Click" Text="View" CssClass="ItDoseButton" Width="63px" />
            </div>
               
             <div class="col-md-5">
               <asp:Label ID="lblSubCat" runat="server" Text="Visit Type: " Visible="False" CssClass="ItDoseLabel"></asp:Label></div>
                 <div class="col-md-5">
               <asp:DropDownList ID="cmbSubCategory" runat="server" CssClass="ItDoseDropdownbox"  Width="256px" Visible="false">
               </asp:DropDownList></div>
                    
              
           </div>
         </div>
         
      
            <div class="row">
                <div class="col-md-24">
                                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Select">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" runat="server" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="30px"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px"/>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Name" HeaderText="Visit Type" >
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px"/>
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Rate">
                                            <ItemTemplate>
                                                <asp:TextBox ID="txtRate" MaxLength="10" runat="server" Text='<%# Bind("Rate") %>' Width="92px" ></asp:TextBox>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px"/>
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px"/>
                                        </asp:TemplateField>
                                        <asp:TemplateField Visible="False">
                                            <ItemTemplate>
                                                <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'
                                                    Visible="False"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                    </Columns>                                    
                                </asp:GridView>
                </div>
            </div>
        
          <div class="row">
            <div class="col-md-5" style="text-align: center;" ><asp:Button ID="btnSave" runat="server" Text="Save" 
            OnClick="btnSave_Click" CssClass="ItDoseButton" Visible="False" Width="63px" /></div>
          </div>
       </asp:Panel>
                 </div>          
 </asp:Content>