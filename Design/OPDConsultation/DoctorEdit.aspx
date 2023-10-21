<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master"
    MaintainScrollPositionOnPostback="true" CodeFile="DoctorEdit.aspx.cs" Inherits="Design_FrontOffice_DoctorEdit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="../Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>
                      Edit  DOCTOR REGISTRATION</b><br />
                    <asp:Label ID="lblerrmsg" runat="server" Font-Bold="true" ForeColor="#FF0033"></asp:Label>&nbsp;</div>
           
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Doctor Details </div>
            <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left"> Doctor Name  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-1 ">
                     
                            <asp:DropDownList ID="cmbTitle" runat="server" CssClass="inputbox4" TabIndex="1"
                                ToolTip="select  gender" >
                                <asp:ListItem>Dr.</asp:ListItem>
                            </asp:DropDownList>
               </div> <div class="col-md-4 ">
                            <asp:TextBox ID="txtName" runat="server" CssClass="inputbox3"  MaxLength="100"
                                TabIndex="2" ></asp:TextBox></div>
                  <div class="col-md-3 ">
			   <label class="pull-left"> ConsultationFee    </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                 
                    <asp:TextBox ID="txtfee" runat="server" CssClass="inputbox2"  MaxLength="20"
                        TabIndex="4"></asp:TextBox><span style="font-size: 8pt; color: #54a0c0; font-family: Verdana"></span>
            </div>
                 <div class="col-md-3 ">
			   <label class="pull-left">  Department   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                        <asp:DropDownList ID="cmbDept" runat="server" CssClass="inputcombobox" TabIndex="7" > </asp:DropDownList></div>
            </div>
           <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">  Phone   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
           
                    <asp:TextBox ID="txtPhone1"
                            runat="server" CssClass="inputbox2"  MaxLength="20" TabIndex="3" ></asp:TextBox></div>
               <div class="col-md-3 ">
			   <label class="pull-left">  Mobile   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                   
                    <asp:TextBox ID="TxtMobileNo" runat="server" CssClass="inputbox2"  MaxLength="20"
                        TabIndex="4"></asp:TextBox></div>
               <div class="col-md-3 ">
			   <label class="pull-left">  Specialization   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                   <asp:DropDownList ID="ddlSpecial" runat="server" CssClass="inputcombobox" TabIndex="6"
                         >
                    </asp:DropDownList>
           </div>
           </div>
             <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">  Address   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                    <asp:TextBox ID="txtAdd" runat="server" CssClass="inputbox2" MaxLength="50"
                        TabIndex="5" TextMode="MultiLine"></asp:TextBox></div>

                                <div class="col-md-3 ">
			   <label class="pull-left">  Centre   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                   <asp:DropDownList ID="ddlCentreAccess" runat="server" CssClass="inputcombobox" TabIndex="6"
                         >
                    </asp:DropDownList>
           </div>
 </div>
</div>
       <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                OPD Schedule Details</div>
            <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">  Days   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-7 ">
                  
                        <asp:CheckBox ID="chkMon" runat="server" Height="11px" TabIndex="8" Text="Mon"  />
                        <asp:CheckBox ID="chkTues" runat="server" Height="11px" TabIndex="9" Text="Tues"
                             />
                        <asp:CheckBox ID="chkWed" runat="server" Height="11px" TabIndex="10" Text="Wed"  />
                        <asp:CheckBox ID="chkThur" runat="server" Height="11px" TabIndex="11" Text="Thur"/>
                        <asp:CheckBox ID="chkFri" runat="server" Height="11px" TabIndex="12" Text="Fri"  />
                        <asp:CheckBox ID="chkSat" runat="server" Height="11px" TabIndex="13" Text="Sat" />
                        <asp:CheckBox ID="chkSun" runat="server" Height="11px" TabIndex="14" Text="Sun"  />
           </div></div>
            <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">  Start Time   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                  <asp:ScriptManager ID="ScriptManger1" runat="Server">
</asp:ScriptManager>
                    <asp:TextBox ID="txtHr1" runat="server" CssClass="inputbox3" MaxLength="2" TabIndex="15" Width="50px"
                        ></asp:TextBox><asp:TextBox ID="txtMin1" runat="server" CssClass="inputbox3" Width="50px"
                            MaxLength="2" TabIndex="16"></asp:TextBox><asp:DropDownList ID="cmbAMPM1" Width="60px"
                                runat="server" CssClass="inputcombobox" TabIndex="17" >
                                <asp:ListItem>AM</asp:ListItem>
                                <asp:ListItem>PM</asp:ListItem>
                            </asp:DropDownList>
                    <cc1:filteredtextboxextender id="FilteredTextBoxExtender1" runat="server" FilterType="Custom,Numbers"  TargetControlID="txtHr1"></cc1:filteredtextboxextender>
                    <cc1:filteredtextboxextender id="FilteredTextBoxExtender2" runat="server" FilterType="Custom,Numbers"  TargetControlID="txtMin1"></cc1:filteredtextboxextender>
               </div>
                <div class="col-md-3 ">
			   <label class="pull-left">  End Time   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                 
                    <asp:TextBox ID="txtHr2" runat="server" CssClass="inputbox3" MaxLength="2" TabIndex="18" Width="50px"
                       ></asp:TextBox><asp:TextBox ID="txtMin2" runat="server" CssClass="inputbox3" Width="50px"
                            MaxLength="2" TabIndex="19" ></asp:TextBox><asp:DropDownList ID="cmbAMPM2" Width="60px"
                                runat="server" CssClass="inputcombobox" TabIndex="20" >
                                <asp:ListItem>AM</asp:ListItem>
                                <asp:ListItem>PM</asp:ListItem>
                            </asp:DropDownList>
                    <cc1:filteredtextboxextender id="FilteredTextBoxExtender3" runat="server" FilterType="Custom,Numbers"   TargetControlID="txtHr2"></cc1:filteredtextboxextender>
                    <cc1:filteredtextboxextender id="FilteredTextBoxExtender4" runat="server" FilterType="Custom,Numbers"   TargetControlID="txtMin2"></cc1:filteredtextboxextender>
              </div></div>
            <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left"> Duration /Patient   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                      
                        <asp:DropDownList ID="ddlduration" runat="server" TabIndex="22" Width="50px">
                            <asp:ListItem>5</asp:ListItem>
                            <asp:ListItem>10</asp:ListItem>
                            <asp:ListItem>15</asp:ListItem>
                            <asp:ListItem>20</asp:ListItem>
                            <asp:ListItem>25</asp:ListItem>
                            <asp:ListItem>30</asp:ListItem>
                            <asp:ListItem>35</asp:ListItem>
                            <asp:ListItem>40</asp:ListItem>
                            <asp:ListItem>45</asp:ListItem>
                            <asp:ListItem>50</asp:ListItem>
                            <asp:ListItem>60</asp:ListItem>
                            <asp:ListItem></asp:ListItem>
                        </asp:DropDownList>
                        IN Minutes <asp:Button ID="btntimings" runat="server" CssClass="input_butt4" OnClick="btntimings_Click" style="float:right;"
                        TabIndex="23" Text="Add Timings" />
              </div>
                 <div class="col-md-3 ">
			   <label class="pull-left">  Room No  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 ">
                        <asp:TextBox ID="txtRoomNo" runat="server" CssClass="inputbox3"
                        TabIndex="21" ></asp:TextBox>
              </div></div>
          <div class="row" style="text-align:center">
           
                    <asp:GridView ID="grdTime" runat="server" AutoGenerateColumns="False" CssClass="profile1"
                        OnRowDeleting="grdTime_RowDeleting" Width="348px" Height="54px">
                        <Columns>
                            <asp:BoundField DataField="Day" HeaderText="Days" />
                            <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                            <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                            <asp:BoundField DataField="AvgTime" HeaderText="AvgTime" />
                            <asp:CommandField ShowDeleteButton="True" />
                        </Columns>
                        <HeaderStyle CssClass="gridHeader2" />
                        <AlternatingRowStyle CssClass="profile2" />
                    </asp:GridView>
                
           </div>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="row" style="text-align:center">
            <asp:Button ID="btnSave" runat="server" CssClass="input_butt1" OnClick="btnSave_Click"
                    TabIndex="24" Text="Save" />
                </div>
           </div>
        </div>
  </asp:Content>
