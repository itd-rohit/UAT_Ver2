<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="LocaltionMaster.aspx.cs" Inherits="Design_Master_LocaltionMaster" MasterPageFile="~/Design/DefaultHome.master"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        
            <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
  
 
  <div id="Pbody_box_inventory" style="width:98%;">
          
      <div id="Div1" style="width:99.8%;">
        <div class="POuter_Box_Inventory" style="width:99.7%;" >
            <div class="content" style="margin-left:500px; width:99.7%;">
              <b>Location Master</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            </div>
              <div class="POuter_Box_Inventory" style="width:99.7%;" >
                  <div class="Purchaseheader">State</div>
            <div class="content" style="text-align: center; width:99.7%;" class="POuter_Box_Inventory" >
        <table style="width:100%;">
           <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700; width: 214px;">Business Zone :&nbsp;</td>
                <td style="text-align: left"> 
                    <asp:DropDownList ID="ddlStBussinessZone" runat="server" Width="189px" ClientIDMode="Static" onchange="bindStateFromBussinessZone('LocalityState')"></asp:DropDownList>
                </td>
               
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700;">State:&nbsp;</td>
                <td style="text-align: left"><asp:TextBox ID="txtState" runat="server" MaxLength="50" Width="185px"></asp:TextBox></td>
               
                <td></td>
            </tr>
            
            <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right">&nbsp;</td>
                <td style="text-align: left">
<input type="checkbox" class="chkState" id="chkState" checked="checked" />Active
                  
                </td>
               
                <td>&nbsp;</td>
            </tr>
             <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right">&nbsp;</td>
                <td style="text-align: left">
                   <input type="button" value="Save" class="savebutton"  onclick="SaveState();" id="btnSaveState" style="width:100px;" />     
                     <input type="button" value="Modify" class="savebutton"  onclick=" ShowDialog(true,'State');" id="Button2" style="width:95px;" />    
                                
                              
           <div id="output"></div>  
    <div id="overlay" class="web_dialog_overlay"></div>  
    <div id="dialog" class="web_dialog"> 
          <table style="width: 100%;display:none; height:80px; border: 0px;" cellpadding="3" cellspacing="0" id="tblModifyState">  
            <tr>  
                <td class="web_dialog_title">Modify State</td>  
                <td class="web_dialog_title align_right"><a id="btnClose" onclick="HideDialog(true);" style="cursor:pointer;">Close</a></td>  
            </tr>  
            <tr>  
                <td> </td>  
                <td> </td>  
            </tr>  
            <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>Business Zone </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMBusinessZone" runat="server" Width="189px" ClientIDMode="Static" onchange="bindModifyState('State')"></asp:DropDownList>
                </td>  
            </tr>  
              <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>State </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMState" runat="server" Width="189px" ClientIDMode="Static" onchange="FillStateModificationData();"></asp:DropDownList>
                </td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>Modify State </b></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;"><asp:TextBox ID="txtMState" runat="server" Width="185px"></asp:TextBox></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>Modify Business Zone </b></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;"> <asp:DropDownList ID="ddlModifyBusinessZone" runat="server" Width="189px" ClientIDMode="Static" ></asp:DropDownList></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;">
                     <asp:CheckBox ID="chkMState" runat="server" Text="Active" />
                </td>  
            </tr>  
              
             
            <tr>  
                <td  style="text-align: center;">
                     <input type="button" value="Update " class="savebutton"  onclick="ModifyState();" style="width:90px;" />     
                     </td>  
                <td  style="text-align: center;"> 
                    <input type="button" value="Cancel" class="savebutton"  onclick=" HideDialog(true);" style="width:90px;" /></td>  
            </tr>  
        </table>    
        
            <table style="width: 100%;display:none; height:80px; border: 0px;" cellpadding="3" cellspacing="0" id="tblModifyCity">  
            <tr>  
                <td class="web_dialog_title">Modify City</td>  
                <td class="web_dialog_title align_right"><a id="A1" onclick="HideDialog(true);" style="cursor:pointer;">Close</a></td>  
            </tr>  
            <tr>  
                <td> </td>  
                <td> </td>  
            </tr>  
            <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>Business Zone </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMCBusinessZone" runat="server" Width="189px" ClientIDMode="Static" onchange="bindModifyState('City')"></asp:DropDownList>
                </td>  
            </tr>  
              <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>State </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMCState" runat="server" Width="189px" ClientIDMode="Static" onchange="bindModifyCity('City')" ></asp:DropDownList>
                </td>  
            </tr>
                  <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>City </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMCCity" runat="server" Width="189px" ClientIDMode="Static" onchange="FillCityModificationData();"></asp:DropDownList>
                </td>  
            </tr> 
                <tr>
                <td colspan="2" style="padding-left: 15px;"><b>Modify City </b></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;"><asp:TextBox ID="txtMCCity" runat="server" Width="185px"></asp:TextBox></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;">
                     <asp:CheckBox ID="chkMCCity" runat="server" Text="Active" />
                </td>  
            </tr>  
              
             
            <tr>  
                <td  style="text-align: center;">
                     <input type="button" value="Update " class="savebutton"  onclick="ModifyCity();" style="width:90px;" />     
                     </td>  
                <td  style="text-align: center;"> 
                    <input type="button" value="Cancel" class="savebutton"  onclick=" HideDialog(true);"  style="width:90px;" /></td>  
            </tr>  
        </table>    
                 <table style="width: 100%;display:none; height:80px; border: 0px;" cellpadding="3" cellspacing="0" id="tblModifyZone">  
            <tr>  
                <td class="web_dialog_title">Modify Zone</td>  
                <td class="web_dialog_title align_right"><a id="A2" onclick="HideDialog(true);" style="cursor:pointer;">Close</a></td>  
            </tr>  
            <tr>  
                <td> </td>  
                <td> </td>  
            </tr>  
            <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>Business Zone </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMZBusinessZone" runat="server" Width="189px" ClientIDMode="Static" onchange="bindModifyState('Zone')"></asp:DropDownList>
                </td>  
            </tr>  
              <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>State </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMZState" runat="server" Width="189px" ClientIDMode="Static" onchange="bindModifyCity('Zone')" ></asp:DropDownList>
                </td>  
            </tr>
                  <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>City </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMZCity" runat="server" Width="189px" ClientIDMode="Static" onchange="bindModifyZone();"></asp:DropDownList>
                </td>  
            </tr>
                     <tr>  
                <td colspan="2" style="padding-left: 15px;"><b>Zone </b></td>  
            </tr>  
              
            <tr>  
                <td colspan="2" style="padding-left: 15px;">  
                   <asp:DropDownList ID="ddlMZZone" runat="server" Width="189px" ClientIDMode="Static" onchange="FillZoneModificationData();"></asp:DropDownList>
                </td>  
            </tr>  
                     <tr>
                <td colspan="2" style="padding-left: 15px;"><b>Modify City </b></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;"><asp:TextBox ID="txtMZone" runat="server" Width="185px"></asp:TextBox></td>  
            </tr>
              <tr>  
                <td colspan="2" style="padding-left: 15px;">
                     <asp:CheckBox ID="chkMZone" runat="server" Text="Active" />
                </td>  
            </tr>  
              
             
            <tr>  
                <td  style="text-align: center;">
                     <input type="button" value="Update " class="savebutton"  onclick="ModifyZone();" style="width:90px;" />     
                     </td>  
                <td  style="text-align: center;"> 
                    <input type="button" value="Cancel" class="savebutton"  onclick=" HideDialog(true);" style="width:90px;" /></td>  
            </tr>  
        </table>
             </td>
                </tr>
                </table>
         
                
        </div>
            <div class="POuter_Box_Inventory" style="width:99.7%;" >
                  <div class="Purchaseheader">City</div>
            <div class="content" style="text-align: center; width:99.7%;" class="POuter_Box_Inventory" >
        <table style="width:100%;">
            <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700;">City:&nbsp;</td>
                <td style="text-align: left"><asp:TextBox ID="txtCity" runat="server" MaxLength="50" Width="185px"></asp:TextBox></td>
               
                <td></td>
            </tr>
             <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700; width: 214px;">Business Zone :&nbsp;</td>
                <td style="text-align: left"> 
                    <asp:DropDownList ID="ddlCityBusinessZone" runat="server" Width="189px" ClientIDMode="Static" onchange="bindStateFromBussinessZone('SearchingCityState')"></asp:DropDownList>
                </td>
               
                <td></td>
            </tr>
            
             <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right; font-weight: 700;">State:&nbsp;</td>
                <td style="text-align: left">

                  <asp:DropDownList ID="ddlCityState" Width="200px" runat="server"></asp:DropDownList>
                </td>
               
                <td>&nbsp;</td>
            </tr>
            <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right">&nbsp;</td>
                <td style="text-align: left">

                   <asp:CheckBox ID="chkCity" runat="server" Checked="true" Text="Active" />
                </td>
               
                <td>&nbsp;</td>
            </tr>
             <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right">&nbsp;</td>
                <td style="text-align: left">
                   <input type="button" value="Save" class="savebutton"  onclick="SaveCity();" id="btnSaveCity" style="width:100px;" />
                      <input type="button" value="Modify" class="savebutton"  onclick=" ShowDialog(true, 'City');"  style="width:95px;" /> 
                </td>               
                <td>&nbsp;</td>
            </tr>
            
          </table>
            </div>
                
        </div>
          <div class="POuter_Box_Inventory" style="width:99.7%;" >
                  <div class="Purchaseheader">Zone</div>
            <div class="content" style="text-align: center; width:99.7%;" class="POuter_Box_Inventory" >
        <table style="width:100%;">
            <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700;">Zone:&nbsp;</td>
                <td style="text-align: left"><asp:TextBox ID="txtZone" runat="server" MaxLength="50" Width="185px"></asp:TextBox></td>
               
                <td></td>
            </tr>
            
             <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700; width: 214px;">Business Zone :&nbsp;</td>
                <td style="text-align: left"> 
                    <asp:DropDownList ID="ddlZoneBusinessZone" runat="server" Width="189px" ClientIDMode="Static" onchange="bindStateFromBussinessZone('SearchingZoneState')"></asp:DropDownList>
                </td>
               
                <td></td>
            </tr>
             <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right; font-weight: 700;">State:&nbsp;</td>
                <td style="text-align: left">

                  <asp:DropDownList ID="ddlZoneState" Width="200px" runat="server" onchange="bindCity('ZoneCity',this.value);"></asp:DropDownList>
                </td>
               
                <td>&nbsp;</td>
            </tr>
             <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right; font-weight: 700;">City:&nbsp;</td>
                <td style="text-align: left">

                  <asp:DropDownList ID="ddlZoneCity" Width="200px" runat="server"></asp:DropDownList>
                </td>
               
                <td>&nbsp;</td>
            </tr>
            <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right">&nbsp;</td>
                <td style="text-align: left">

                   <asp:CheckBox ID="chkZone" runat="server" Checked="true" Text="Active" />
                </td>
               
                <td>&nbsp;</td>
            </tr>
             <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right">&nbsp;</td>
                <td style="text-align: left">
                   <input type="button" value="Save" class="savebutton"  onclick="SaveZone();" id="btnSaveZone" style="width:100px;" />
                    <input type="button" value="Modify" class="savebutton"  onclick="ShowDialog(true, 'Zone');"  style="width:95px;" />
                </td>               
                <td>&nbsp;</td>
            </tr>
            
          </table>
            </div>
                
        </div>
        <div class="POuter_Box_Inventory" style="width:99.7%;" >
                  <div class="Purchaseheader">Locality</div>
            <div class="content" style="text-align: center; width:99.7%;" class="POuter_Box_Inventory" >
        <table style="width:100%;">
            <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700; width: 214px;">Locality:&nbsp;</td>
                <td style="text-align: left"><asp:TextBox ID="txtLocality" MaxLength="50" runat="server" Width="185px"></asp:TextBox></td>
               
                <td></td>
            </tr>
            
             <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700; width: 214px;">Business Zone :&nbsp;</td>
                <td style="text-align: left"> 
                    <asp:DropDownList ID="ddlBusinessZone" runat="server" Width="189px" ClientIDMode="Static" onchange="bindStateFromBussinessZone('LocalityState')"></asp:DropDownList>
                </td>
               
                <td></td>
            </tr>
             <tr>
                 <td><asp:TextBox ID="txtLocalityID" runat="server" Width="189px" style="display:none;"></asp:TextBox>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right; font-weight: 700; width: 214px;">State:&nbsp;</td>
                <td style="text-align: left">

                  <asp:DropDownList ID="ddlLocalityState"  Width="200px" runat="server" onchange="bindCity('Locality',this.value);"></asp:DropDownList>
                </td>
               
                <td>&nbsp;</td>
            </tr>
             <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right; font-weight: 700; width: 214px;">City:&nbsp;</td>
                <td style="text-align: left">

                  <asp:DropDownList ID="ddlLocalityCity" Width="200px" runat="server" onchange="bindZone();"></asp:DropDownList>
                </td>
               
                <td>&nbsp;</td>
            </tr>
            <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right; font-weight: 700; width: 214px;">Zone:&nbsp;</td>
                <td style="text-align: left">

                  <asp:DropDownList ID="ddlLocalityZone" Width="200px" runat="server"></asp:DropDownList>
                </td>
               
                <td>&nbsp;</td>
            </tr>
            <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right; width: 214px;">&nbsp;</td>
                <td style="text-align: left">

                   <asp:CheckBox ID="chkLocality" runat="server" Checked="true" Text="Active" />
                </td>
               
                <td>&nbsp;</td>
            </tr>
             <tr>
                 <td>&nbsp;</td>
                <td style="width: 198px">&nbsp;</td>
                <td style="text-align: right; width: 214px;">&nbsp;</td>
                <td style="text-align: left">
                   <input type="button" value="Save" class="savebutton" onclick="SaveLocality();" id="btnSaveLocality" style="width:195px;" />
                     <input type="button" value="Update" class="savebutton" onclick="UpdateLocality();" id="btnUpdateLocality" style="width:195px;display:none;" />
                    
                </td>               
                <td>&nbsp;</td>
            </tr>
            
          </table>
            </div>
                
        </div>
            <div class="POuter_Box_Inventory" style="width:99.7%;" >
                  <div class="Purchaseheader">Search Criteria</div>
            <div class="content" style="text-align: center; width:99.7%;" class="POuter_Box_Inventory" >
                <table style="width:100%;border-collapse:collapse">
    <tr>
        <td style="text-align:right;font-weight: 700;">
            Business Zone :&nbsp;
        </td>
        <td style="text-align:left;">
            <asp:DropDownList ID="ddlSBussinessZone" runat="server" Width="160px" ClientIDMode="Static" onchange="bindStateFromBussinessZone('SearchingState')" Height="21px"></asp:DropDownList>
        </td>
        <td style="text-align:right;font-weight: 700;">
            State :&nbsp;
        </td>
         <td style="text-align:left;">
            <asp:DropDownList ID="ddlSState" runat="server" Width="160px" ClientIDMode="Static" onchange="bindSCity()" Height="21px"></asp:DropDownList>
        </td>
        <td style="text-align:right;font-weight: 700;">
             City :&nbsp;
        </td>
        <td style="text-align:left;">
             <asp:DropDownList ID="ddlSCity" runat="server" Width="160px" ClientIDMode="Static" Height="21px" ></asp:DropDownList>
        </td>
        <td style="text-align:left;">
           <input type="button" value="Search" class="savebutton" onclick="GetLocalityData();" id="btnLocalitySearch" style="width:95px;" />
        </td>
    </tr>    
</table>
                </div>
                </div>          
          <input type="button" value="Mapping" class="ItDoseButton" id="btnmapping" style="display:none;" />
                     <input type="button" value="Update" class="ItDoseButton" onclick="updatemasterdata()" id="btnupdate" style="display:none;" />

           <div class="POuter_Box_Inventory" style="width:99.7%;" >
                  <div class="Purchaseheader">Master Detail</div>
            <div class="content" style="text-align: center; width:99.7%; ">

                <div id ="div_InvestigationItems" class="content" style="overflow:scroll;height:360px;width:98%;">
  
</div>

                </div></div>
         </div>
          <div class="Outer_Box_Inventory" style="width: 99.6%; "  > 
      
        </div>
         
   
   
  </div>
    <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"   style="border-collapse:collapse; width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Locality Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10%;">State</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10%;">City</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Zone</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">Active</th>
 <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Created By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Created On</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Updated By</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Select</th>
           
            
	
	       

</tr>
<#  var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
<tr>
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="width:10%;"><#=objRow.Name#></td>
<td class="GridViewLabItemStyle" style="width:10%;"><#=objRow.state#></td>
<td class="GridViewLabItemStyle" style="width:10%;"><#=objRow.City#></td>     
<td class="GridViewLabItemStyle" style="width:10%;"><#=objRow.Zone#></td>
<td class="GridViewLabItemStyle" style="width:10%;"><#=objRow.Active#></td>
<td class="GridViewLabItemStyle" style="width:10%;"><#=objRow.CreatedBy#></td>
<td class="GridViewLabItemStyle" style="width:10%;"><#=objRow.CreatedOn#></td>
 <td class="GridViewLabItemStyle" style="width:10%;"><#=objRow.UpdatedBy#></td>
    <td class="GridViewLabItemStyle" style="width:20%;text-align:center;" >
        <img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="FillData('<#=objRow.ID#>','<#=objRow.Name#>','<#=objRow.StateID#>','<#=objRow.CityID#>','<#=objRow.ZoneID#>','<#=objRow.Active#>','<#=objRow.BusinessZoneID#>');" />

    </td>
</tr> 
<#}#> 
        </table>
          
          </script>   
    <script type="text/javascript">
        $(document).ready(function () {

            bindState();
            var ddlZoneCity = $("#<%=ddlZoneCity.ClientID %>");
            $("#<%=ddlZoneCity.ClientID %> option").remove();
            ddlZoneCity.append($("<option></option>").val("").html("--Select---"));
            var ddlLocalityCity = $("#<%=ddlLocalityCity.ClientID %>");
            $("#<%=ddlLocalityCity.ClientID %> option").remove();
            ddlLocalityCity.append($("<option></option>").val("").html("--Select---"));
            var ddlLocalityZone = $("#<%=ddlLocalityZone.ClientID %>");
            $("#<%=ddlLocalityZone.ClientID %> option").remove();
            ddlLocalityZone.append($("<option></option>").val("").html("--Select---"));

        });
        function bindState() {
            var ddlCityState = $("#<%=ddlCityState.ClientID %>");
            $("#<%=ddlCityState.ClientID %> option").remove();
            ddlCityState.append($("<option></option>").val("").html("--Select---"));

            var ddlZoneState = $("#<%=ddlZoneState.ClientID %>");
            $("#<%=ddlZoneState.ClientID %> option").remove();
            ddlZoneState.append($("<option></option>").val("").html("--Select---"));

            var ddlLocalityState = $("#<%=ddlLocalityState.ClientID %>");
            $("#<%=ddlLocalityState.ClientID %> option").remove();
            ddlLocalityState.append($("<option></option>").val("").html("--Select---")); 
            $.ajax({
                url: "LocaltionMaster.aspx/bindState",
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    StateData = jQuery.parseJSON(result.d);
                    if (StateData.length > 0) {
                        for (i = 0; i < StateData.length; i++) {
                          //  ddlCityState.append($("<option></option>").val(StateData[i].ID).html(StateData[i].State));
                           // ddlZoneState.append($("<option></option>").val(StateData[i].ID).html(StateData[i].State));
                          //  ddlLocalityState.append($("<option></option>").val(StateData[i].ID).html(StateData[i].State));
                        }
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

        function bindCity(ddlType, StateID) {
            var ddlCity = "";
            if (ddlType == "ZoneCity") {
                ddlCity = $("#<%=ddlZoneCity.ClientID %>");
                $("#<%=ddlZoneCity.ClientID %> option").remove();
                ddlCity.append($("<option></option>").val("").html("--Select---"));
            }
            else {
                ddlCity = $("#<%=ddlLocalityCity.ClientID %>");
                $("#<%=ddlLocalityCity.ClientID %> option").remove();
                ddlCity.append($("<option></option>").val("").html("--Select---"));
              var ddlZone = $("#<%=ddlLocalityZone.ClientID %>");
                $("#<%=ddlLocalityZone.ClientID %> option").remove();
                ddlZone.append($("<option></option>").val("").html("--Select---"));
            }

            $.ajax({
                url: "LocaltionMaster.aspx/bindCity",
                data: '{ StateID:"' + StateID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    if (CityData.length > 0) {
                        for (i = 0; i < CityData.length; i++) {
                            ddlCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function bindZone() {
            var CityID = $("#<%=ddlLocalityCity.ClientID %> option:selected").val();
            var StateID = $("#<%=ddlLocalityState.ClientID %> option:selected").val();
            var ddlZone = $("#<%=ddlLocalityZone.ClientID %>");
            $("#<%=ddlLocalityZone.ClientID %> option").remove();
            ddlZone.append($("<option></option>").val("").html("--Select---"));
            $.ajax({
                url: "LocaltionMaster.aspx/bindZone",
                data: '{ StateID:"' + StateID + '",CityID:"' + CityID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    ZoneData = jQuery.parseJSON(result.d);
                    if (ZoneData.length > 0) {
                        for (i = 0; i < ZoneData.length; i++) {
                            ddlZone.append($("<option></option>").val(ZoneData[i].ZoneID).html(ZoneData[i].Zone));
                        }
                    }
                    $('#<%= ddlLocalityZone.ClientID%>').prop("disabled", false);

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

        function SaveState() {
            if ($('#<%= ddlStBussinessZone.ClientID%>').val() == "0") {
                alert("Please Select Bussiness Zone");
                return;
            }
            if ($('#<%= txtState.ClientID%>').val() == '') {
                alert('Please Enter State Name');
                return false;
            }
            var IsActive = '0';
            if ($('#chkState').is(':checked')) {
                IsActive = '1';
            }
            $.ajax({
                url: "LocaltionMaster.aspx/SaveState",
                data: '{ State:"' + $('#<%= txtState.ClientID%>').val() + '",IsActive:"' + IsActive + '",BusinessZoneID:"' + $('#<%= ddlStBussinessZone.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    DataResult = jQuery.parseJSON(result.d);
                    if (DataResult == '1') {
                        alert('Record Saved');
                        clearform();
                        bindState();
                    }
                    if (DataResult == '2') {
                        alert('State Already Exist.');
                        clearform();
                        bindState();
                    }
                   if (DataResult == '0') {
                        alert('Record Not Saved');
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

        function SaveCity() {
            if ($('#<%= txtCity.ClientID%>').val() == '') {
                alert('Please Enter City Name');
                return false;
            }
            if ($("#<%=ddlCityBusinessZone.ClientID %> option:selected").val() == '0') {
                alert('Please Select Business Zone');
                return false;
            }
            if ($("#<%=ddlCityState.ClientID %> option:selected").val() == '') {
                alert('Please Select State');
                return false;
            }
            var IsActive = '0';
            if ($('#<%= chkCity.ClientID%>').is(':checked')) {
                IsActive = '1';
            }
            $.ajax({
                url: "LocaltionMaster.aspx/SaveCity",
                data: '{ City:"' + $('#<%= txtCity.ClientID%>').val() + '",StateID:"' + $("#<%=ddlCityState.ClientID %> option:selected").val() + '",IsActive:"' + IsActive + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    DataResult = jQuery.parseJSON(result.d);
                    if (DataResult == '1') {
                        alert('Record Saved');
                        clearform();
                    }
                    else {
                        alert('Record Not Saved');
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function SaveZone() {
            if ($('#<%= txtZone.ClientID%>').val() == '') {
                alert('Please Enter Zone Name');
                return false;
            }
            if ($("#<%=ddlZoneBusinessZone.ClientID %> option:selected").val() == '0') {
                alert('Please Select Business Zone');
                return false;
            }
            if ($("#<%=ddlZoneState.ClientID %> option:selected").val() == '') {
                alert('Please Select State');
                return false;
            }
            if ($("#<%=ddlZoneCity.ClientID %> option:selected").val() == '') {
                alert('Please Select City');
                return false;
            }
            var IsActive = '0';
            if ($('#<%= chkZone.ClientID%>').is(':checked')) {
                IsActive = '1';
            }
            $.ajax({
                url: "LocaltionMaster.aspx/SaveZone",
                data: '{ Zone:"' + $('#<%= txtZone.ClientID%>').val() + '",StateID:"' + $("#<%=ddlZoneState.ClientID %> option:selected").val() + '",CityID:"' + $("#<%=ddlZoneCity.ClientID %> option:selected").val() + '",IsActive:"' + IsActive + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    DataResult = jQuery.parseJSON(result.d);
                    if (DataResult == '1') {
                        alert('Record Saved');
                        clearform();
                    }
                    else {
                        alert('Record Not Saved');
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function SaveLocality() {
            if ($('#<%= txtLocality.ClientID%>').val() == '') {
                alert('Please Enter Locality Name');
                return false;
            }
            if ($("#<%=ddlBusinessZone.ClientID %> option:selected").val() == '0') {
                alert('Please Select Business Zone');
                return false;
            }
            if ($("#<%=ddlLocalityState.ClientID %> option:selected").val() == '') {
                alert('Please Select State');
                return false;
            }
            if ($("#<%=ddlLocalityCity.ClientID %> option:selected").val() == '') {
                alert('Please Select City');
                return false;
            }
            if ($("#<%=ddlLocalityZone.ClientID %> option:selected").val() == '') {
                alert('Please Select Zone');
                return false;
            }
            var IsActive = '0';
            if ($('#<%= chkLocality.ClientID%>').is(':checked')) {
                IsActive = '1';
            }
            $.ajax({
                url: "LocaltionMaster.aspx/SaveLocality",
                data: '{ Locality:"' + $('#<%= txtLocality.ClientID%>').val() + '",ZoneID:"' + $('#<%= ddlLocalityZone.ClientID%>').val() + '",StateID:"' + $("#<%=ddlLocalityState.ClientID %> option:selected").val() + '",CityID:"' + $("#<%=ddlLocalityCity.ClientID %> option:selected").val() + '",IsActive:"' + IsActive + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    DataResult = jQuery.parseJSON(result.d);
                    if (DataResult == '1') {
                        alert('Record Saved');
                        clearform();
                    }
                    else {
                        alert('Record Not Saved');
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function UpdateLocality() {
            if ($('#<%= ddlBusinessZone.ClientID%>').val() == "0") {
                alert("Please Select Bussiness Zone");
                return;
            }
            var IsActive = '0';
            if ($('#<%= chkLocality.ClientID%>').is(':checked')) {
                IsActive = '1';
            }
            $.ajax({
                url: "LocaltionMaster.aspx/UpdateLocality",
                data: '{ LocalityID:"' + $('#<%= txtLocalityID.ClientID%>').val() + '",Locality:"' + $('#<%= txtLocality.ClientID%>').val() + '",ZoneID:"' + $('#<%= ddlLocalityZone.ClientID%>').val() + '",StateID:"' + $("#<%=ddlLocalityState.ClientID %> option:selected").val() + '",CityID:"' + $("#<%=ddlLocalityCity.ClientID %> option:selected").val() + '",IsActive:"' + IsActive + '",BusinessZoneID:"' + $("#<%=ddlBusinessZone.ClientID %> option:selected").val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    DataResult = jQuery.parseJSON(result.d);
                    if (DataResult == '1') {
                        alert('Record Updated');
                        clearform();
                        GetLocalityData();
                    }
                    else {
                        alert('Record Not Updated');
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function GetLocalityData() {
            if ($('#<%= ddlSBussinessZone.ClientID%>').val()=="0") {
                alert("Please Select Bussiness Zone");
                return;
            }
            if ($('#<%= ddlSState.ClientID%>').val() == "" || $('#<%= ddlSState.ClientID%>').val()=="0") {
                alert("Please Select State");
                return;
            }
            if ($('#<%= ddlSCity.ClientID%>').val() == "" || $('#<%= ddlSCity.ClientID%>').val() == "0") {
                alert("Please Select City");
                return;
            }
            
            clearform();
 $modelBlockUI();
            $.ajax({
                url: "LocaltionMaster.aspx/GetLocality",
                data: '{ StateID: "' + $('#<%= ddlSState.ClientID%>').val() + '",BusinessZoneID: "' + $('#<%= ddlSBussinessZone.ClientID%>').val() + '",CityID: "' + $('#<%= ddlSCity.ClientID%>').val() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                    $('#div_InvestigationItems').html(output);
  $modelUnBlockUI();
                },
                error: function (xhr, status) {
  $modelUnBlockUI();
                    alert("Error ");
                }
            });
        }
        function FillData(LocalityID, Locality, StateID, CityID, ZoneID, Active, BusinessZoneID) {
            debugger;
            document.getElementById('btnUpdateLocality').style.display = '';
            document.getElementById('btnSaveLocality').style.display = 'none';
            $('#<%= ddlBusinessZone.ClientID%>').val(BusinessZoneID);
            bindStateFromBussinessZone('LocalityState');
            $('#<%= ddlLocalityState.ClientID%>').val(StateID);
            $('#<%= txtLocalityID.ClientID%>').val(LocalityID);
            $('#<%= ddlLocalityState.ClientID%>').val(StateID);
            bindCity('Locality', StateID);
            $('#<%= ddlLocalityCity.ClientID%>').val(CityID);
            bindZone();
            $('#<%= ddlLocalityZone.ClientID%>').val(ZoneID);
            $('#<%= txtLocality.ClientID%>').val(Locality);
            $('#<%= ddlLocalityZone.ClientID%>').val(ZoneID);
          //  $('#<%= ddlLocalityZone.ClientID%>').prop("disabled", true);
            if (Active == 'Yes') {               
                $('#<%=chkLocality.ClientID %>').attr('checked', true)
            }
            else {
                $('#<%=chkLocality.ClientID %>').removeAttr('checked')
            }           
        }
        function clearform() {
            $(':text').val('');
            $('#<%= ddlCityBusinessZone.ClientID%>').val("0");
            $('#<%= ddlZoneBusinessZone.ClientID%>').val("0");
            $('#<%= ddlStBussinessZone.ClientID%>').val("0");
            $('#<%= ddlBusinessZone.ClientID%>').val("0");
            $('#<%= ddlCityState.ClientID%>').val("");
            $('#<%= ddlZoneCity.ClientID%>').val("");
            $('#<%= ddlZoneState.ClientID%>').val("");
            $('#<%= ddlLocalityState.ClientID%>').val("");
            $('#<%= ddlLocalityCity.ClientID%>').val("");
            $('#<%= ddlLocalityZone.ClientID%>').val("");
        }
        function bindStateFromBussinessZone(Type) {
            debugger;
            var ddlState;
            var BusinessZoneID;
            if (Type == 'LocalityState') {
                ddlState = $("#<%=ddlLocalityState.ClientID %>");
                $("#<%=ddlLocalityState.ClientID %> option").remove();
                BusinessZoneID = $("#<%=ddlBusinessZone.ClientID %>").val();
            }
            else if (Type == 'SearchingCityState') {
                ddlState = $("#<%=ddlCityState.ClientID %>");
                $("#<%=ddlCityState.ClientID %> option").remove();
                BusinessZoneID = $("#<%=ddlCityBusinessZone.ClientID %>").val();
            }
            else if (Type == 'SearchingZoneState') {
                ddlState = $("#<%=ddlZoneState.ClientID %>");
                $("#<%=ddlZoneState.ClientID %> option").remove();
                BusinessZoneID = $("#<%=ddlZoneBusinessZone.ClientID %>").val();
                }
            else if (Type == 'SearchingState') {               
               ddlState = $("#<%=ddlSState.ClientID %>");
               $("#<%=ddlSState.ClientID %> option").remove();
               BusinessZoneID = $("#<%=ddlSBussinessZone.ClientID %>").val();
            }
            ddlState.append($("<option></option>").val("").html("--Select---"));
            $.ajax({
                url: "../Common/Services/CommonServices.asmx/bindState",
                data: '{CountryID:0, BusinessZoneID: "' + BusinessZoneID + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    StateData = jQuery.parseJSON(result.d);
                    if (StateData.length > 0) {
                        for (i = 0; i < StateData.length; i++) {
                            ddlState.append($("<option></option>").val(StateData[i].ID).html(StateData[i].State));
                        }
                    }
                   // $("#<%=ddlSCity.ClientID %> option").remove();
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function bindSCity(ddlType, StateID) {
            var ddlCity = $("#<%=ddlSCity.ClientID %>");
                $("#<%=ddlSCity.ClientID %> option").remove();
                ddlCity.append($("<option></option>").val("").html("--Select---"));                     
            $.ajax({
                url: "../Common/Services/CommonServices.asmx/bindCityFromBusinessZone",              
                data: '{ StateID: "' + $("#<%=ddlSState.ClientID %>").val() + '",BusinessZoneID: "' + $("#<%=ddlSBussinessZone.ClientID %>").val() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    if (CityData.length > 0) {
                        for (i = 0; i < CityData.length; i++) {
                            ddlCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
       
    </script>  
    <script type="text/javascript">
        $("#btnClose").click(function (e) {
            HideDialog();
            e.preventDefault();
        });
        function HideDialog() {
            $("#overlay").hide();
            $("#dialog").fadeOut(300);
        }
        function ShowDialog(modal, Type) {
            if (Type == 'State') {
               if( $('#<%= chkMState.ClientID%>').is(':checked'))
                $('#<%=chkMState.ClientID %>').removeAttr('checked');
                $('#tblModifyState').show();
                $('#tblModifyCity').hide();
                $('#tblModifyZone').hide();
              
            }            
            else if (Type == 'City') {
                if ($('#<%= chkMCCity.ClientID%>').is(':checked'))
                $('#<%=chkMCCity.ClientID %>').removeAttr('checked');
                $('#tblModifyState').hide();
                $('#tblModifyCity').show();
                $('#tblModifyZone').hide();
             }
            else if (Type == 'Zone') {
                if ($('#<%= chkMZone.ClientID%>').is(':checked'))
                     $('#<%=chkMZone.ClientID %>').removeAttr('checked');
                $('#tblModifyState').hide();
                $('#tblModifyCity').hide();
                $('#tblModifyZone').show();
            }
            $("#overlay").show();
            $("#dialog").fadeIn(300);
            if (modal) {
                $("#overlay").unbind("click");
            }
            else {
                $("#overlay").click(function (e) {
                    HideDialog();
                });
            }
        }
        function bindModifyState(Type) {
            var ddlState;
            var BusinessZoneID;
            if(Type=='State'){
                ddlState = $("#<%=ddlMState.ClientID %>");
                $("#<%=ddlMState.ClientID %> option").remove();  
                BusinessZoneID = $("#<%=ddlMBusinessZone.ClientID %>").val();
                $("#<%=ddlModifyBusinessZone.ClientID %>").val(BusinessZoneID);
            }
            else if (Type == 'City') {
                ddlState = $("#<%=ddlMCState.ClientID %>");
                $("#<%=ddlMCState.ClientID %> option").remove();
                BusinessZoneID = $("#<%=ddlMCBusinessZone.ClientID %>").val();
            }
            else if (Type == 'Zone') {
                ddlState = $("#<%=ddlMZState.ClientID %>");
                $("#<%=ddlMZState.ClientID %> option").remove();
                $("#<%=ddlMZCity.ClientID %> option").remove();
                BusinessZoneID = $("#<%=ddlMZBusinessZone.ClientID %>").val();
            }
            ddlState.append($("<option></option>").val("").html("--Select---"));
            $.ajax({
                url: "LocaltionMaster.aspx/bindAllState",
                data: '{ BusinessZoneID: "' + BusinessZoneID + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    StateData = jQuery.parseJSON(result.d);
                    if (StateData.length > 0) {
                        for (i = 0; i < StateData.length; i++) {
                            ddlState.append($("<option></option>").val(StateData[i].ID).html(StateData[i].State));
                        }
                        
                    }
                    if (Type == 'State') {
                        $('#<%= txtMState.ClientID%>').val('');
                    }
                    else if (Type == 'City') {
                        $('#<%= txtMCCity.ClientID%>').val('');
                        $("#<%=ddlMCCity.ClientID %> option").remove();  
                    }
                    else if (Type == 'Zone') {
                        $('#<%= txtMZone.ClientID%>').val('');
                        $("#<%=ddlMZZone.ClientID %> option").remove();
                    }
                    
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function FillStateModificationData()
        {
            if ($('#<%=ddlMState.ClientID%> option:selected').text() == "--Select---") {
                $('#<%=txtMState.ClientID%>').val('');
            }
            else {
                $('#<%=txtMState.ClientID%>').val($('#<%=ddlMState.ClientID%> option:selected').text());
            }
            if ($('#<%= ddlMState.ClientID%>').val().split('#')[1] == '1') {
                $('#<%=chkMState.ClientID %>').attr('checked', true);
             }
             else {
                $('#<%=chkMState.ClientID %>').removeAttr('checked');
             }
        }
        function ModifyState() {
                if ($('#<%= ddlMBusinessZone.ClientID%>').val() == "0") {
                     alert("Please Select Bussiness Zone");
                     return;
                }
                if ($('#<%= ddlMState.ClientID%>').val() == "") {
                     alert("Please Select State");
                     return;
                 }
                 if ($('#<%= txtMState.ClientID%>').val() == '') {
                     alert('Please Enter State Name');
                     return false;
                 }
            if ($('#<%= ddlModifyBusinessZone.ClientID%>').val() == "0") {
                alert("Please Select Modify Bussiness Zone");
                return;
            }
            var IsActive = '0';
            if ($('#<%= chkMState.ClientID%>').is(':checked')) {
                     IsActive = '1';
                 }
                 $.ajax({
                     url: "LocaltionMaster.aspx/UpdateState",
                     data: '{ State:"' + $('#<%= txtMState.ClientID%>').val() + '",IsActive:"' + IsActive + '",StateID:"' + $('#<%= ddlMState.ClientID%>').val().split('#')[0] + '",BusinessZone:"' + $('#<%= ddlModifyBusinessZone.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    DataResult = jQuery.parseJSON(result.d);
                    if (DataResult == '1') {
                        alert('Record Saved');
                        clearform();
                        $('#<%= txtMState.ClientID%>').val('');
                        $('#<%= ddlMBusinessZone.ClientID%>').val('0');
                        $('#<%= ddlModifyBusinessZone.ClientID%>').val('0');
                        $("#<%=ddlMState.ClientID %> option").remove();
                        HideDialog();
                    }
                    if (DataResult == '0') {
                        alert('Record Not Saved');
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });       
        }
        function ModifyCity() {
            if ($('#<%= ddlMCBusinessZone.ClientID%>').val() == "0") {
                alert("Please Select Bussiness Zone");
                return;
            }
            if ($('#<%= ddlMCState.ClientID%>').val() == "") {
                alert("Please Select State");
                return;
            }
            if ($('#<%= ddlMCCity.ClientID%>').val() == "") {
                alert("Please Select City");
                return;
            }
            if ($('#<%= txtMCCity.ClientID%>').val() == '') {
                alert('Please Enter City Name');
                return false;
            }
            var IsActive = '0';
            if ($('#<%= chkMCCity.ClientID%>').is(':checked')) {
                IsActive = '1';
            }
            $.ajax({
                url: "LocaltionMaster.aspx/UpdateCity",
                data: '{ City:"' + $('#<%= txtMCCity.ClientID%>').val() + '",IsActive:"' + IsActive + '",CityID:"' + $('#<%= ddlMCCity.ClientID%>').val().split('#')[0] + '"}', // parameter map 
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         DataResult = jQuery.parseJSON(result.d);
                         if (DataResult == '1') {
                             alert('Record Saved');
                             clearform();
                             $('#<%= txtMCCity.ClientID%>').val('');
                        $('#<%= ddlMCBusinessZone.ClientID%>').val('0');
                        $("#<%=ddlMCState.ClientID %> option").remove();
                        HideDialog();
                    }
                    if (DataResult == '0') {
                        alert('Record Not Saved');
                    }
                },
                     error: function (xhr, status) {
                         alert("Error ");
                     }
                 });
        }
        function bindModifyCity(Type) {
            var ddlCity;
            var StateID;
            if (Type == 'City') {
                ddlCity = $("#<%=ddlMCCity.ClientID %>");
                $("#<%=ddlMCCity.ClientID %> option").remove();
                StateID = $("#<%=ddlMCState.ClientID %>").val().split('#')[0];
            }
            else if (Type == 'Zone') {
                ddlCity = $("#<%=ddlMZCity.ClientID %>");
                $("#<%=ddlMZCity.ClientID %> option").remove();
                $("#<%=ddlMZZone.ClientID %> option").remove();
                StateID = $("#<%=ddlMZState.ClientID %>").val().split('#')[0];
            }
            ddlCity.append($("<option></option>").val("").html("--Select---"));
            $.ajax({
                url: "LocaltionMaster.aspx/bindAllCity",
                data: '{ StateID:"' + StateID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    if (CityData.length > 0) {
                        for (i = 0; i < CityData.length; i++) {
                            ddlCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                        }
                    }
                    if (Type == 'City') {
                        $('#<%= txtMCCity.ClientID%>').val('');
                    }
                    if (Type == 'Zone') {
                        $('#<%= txtMZone.ClientID%>').val('');
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function FillCityModificationData() {
            if ($('#<%=ddlMCCity.ClientID%> option:selected').text() == "--Select---") {
                $('#<%=txtMCCity.ClientID%>').val('');
            }
            else {
                $('#<%=txtMCCity.ClientID%>').val($('#<%=ddlMCCity.ClientID%> option:selected').text());
            }
            if ($('#<%= ddlMCCity.ClientID%>').val().split('#')[1] == '1') {
                $('#<%=chkMCCity.ClientID %>').attr('checked', true);
            }
            else {
                $('#<%=chkMCCity.ClientID %>').removeAttr('checked');
            }
        }
        function bindModifyZone() {
            var CityID = $("#<%=ddlMZCity.ClientID %> option:selected").val();
            var StateID = $("#<%=ddlMZState.ClientID %> option:selected").val();
            var ddlZone = $("#<%=ddlMZZone.ClientID %>");
            $("#<%=txtMZone.ClientID %>").val('');
            $("#<%=ddlMZZone.ClientID %> option").remove();
            ddlZone.append($("<option></option>").val("").html("--Select---"));
            $.ajax({
                url: "LocaltionMaster.aspx/bindAllZone",
                data: '{ StateID:"' + StateID.split('#')[0] + '",CityID:"' + CityID.split('#')[0] + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    ZoneData = jQuery.parseJSON(result.d);
                    if (ZoneData.length > 0) {
                        for (i = 0; i < ZoneData.length; i++) {
                            ddlZone.append($("<option></option>").val(ZoneData[i].ZoneID).html(ZoneData[i].Zone));
                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function FillZoneModificationData() {
            if ($('#<%=ddlMZZone.ClientID%> option:selected').text() == "--Select---") {
                $('#<%=txtMZone.ClientID%>').val('');
            }
            else {
                $('#<%=txtMZone.ClientID%>').val($('#<%=ddlMZZone.ClientID%> option:selected').text());
            }
            if ($('#<%= ddlMZZone.ClientID%>').val().split('#')[1] == '1') {
                $('#<%=chkMZone.ClientID %>').attr('checked', true);
            }
            else {
                $('#<%=chkMZone.ClientID %>').removeAttr('checked');
            }
        }
        function ModifyZone() {
            if ($('#<%= ddlMZBusinessZone.ClientID%>').val() == "0") {
                alert("Please Select Bussiness Zone");
                return;
            }
            if ($('#<%= ddlMZState.ClientID%>').val() == "") {
                alert("Please Select State");
                return;
            }
            if ($('#<%= ddlMZCity.ClientID%>').val() == "") {
                alert("Please Select City");
                return;
            }
            if ($('#<%= ddlMZZone.ClientID%>').val() == "") {
                alert("Please Select Zone");
                return;
            }
            if ($('#<%= txtMZone.ClientID%>').val() == '') {
                alert('Please Enter Zone Name');
                return false;
            }
            var IsActive = '0';
            if ($('#<%= chkMZone.ClientID%>').is(':checked')) {
                IsActive = '1';
            }
            $.ajax({
                url: "LocaltionMaster.aspx/UpdateZone",
                data: '{ Zone:"' + $('#<%= txtMZone.ClientID%>').val() + '",IsActive:"' + IsActive + '",ZoneID:"' + $('#<%= ddlMZZone.ClientID%>').val().split('#')[0] + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    DataResult = jQuery.parseJSON(result.d);
                    if (DataResult == '1') {
                        alert('Record Saved');
                        clearform();
                        $('#<%= txtMCCity.ClientID%>').val('');
                             $('#<%= ddlMCBusinessZone.ClientID%>').val('0');
                             $("#<%=ddlMCState.ClientID %> option").remove();
                             HideDialog();
                         }
                         if (DataResult == '0') {
                             alert('Record Not Saved');
                         }
                     },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
    </script> 
    <style>
    #tb_grdLabSearch tr:hover {
            background-color:yellowgreen;
            font-weight: bold; 
            color:red;
            font-size:xx-large;
        } 
    
        </style>
    <style type="text/css">  
        .web_dialog_overlay  
        {  
            position: fixed;  
            top: 0;  
            right: 0;  
            bottom: 0;  
            left: 0;  
            height: 100%;  
            width: 100%;  
            margin: 0;  
            padding: 0;  
            background: #000000;  
            opacity: .15;  
            filter: alpha(opacity=15);  
            -moz-opacity: .15;  
            z-index: 101;  
            display: none;  
        }  
        .web_dialog  
        {  
            display: none;  
            position: fixed;  
            width: 220px;
            top: 50%;  
            left: 50%;  
            margin-left: -190px;  
            margin-top: -100px;  
            background-color: #ffffff;  
            border: 2px solid #336699;  
            padding: 0px;  
            z-index: 102;  
            font-family: Verdana;  
            font-size: 10pt;  
        }  
        .web_dialog_title  
        {  
            border-bottom: solid 2px #336699;  
            background-color: #336699;  
            padding: 4px;  
            color: White;  
            font-weight: bold;  
        }  
        .web_dialog_title a  
        {  
            color: White;  
            text-decoration: none;  
        }  
        .align_right  
        {  
            text-align: right;  
        }  
    </style> 

</asp:Content>

