<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="DiscountMaster.aspx.cs" Inherits="Design_Master_DiscountMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     <style type="text/css" >
        .multiselect {
            width: 100%;
        }
        .compareDateColor {
             background-color: #90EE90;
         }

         .auto-style1 {
             width: 30%;
         }
         .auto-style2 {
             text-align: center;
         }
    </style>
    
     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           
        </Ajax:ScriptManager>
     <div id="Pbody_box_inventory" style="width:1300px;">
        
        <div class="POuter_Box_Inventory" style="text-align: center;width:1300px;">
            <b>Discount Master<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;width:1300px;">
            <div class="Purchaseheader">
                Manage Discount
            </div>
            <table style="border-collapse: collapse; width: 100%">
                <tr>
                    <td style="text-align: right; width: 20%">Discount Type :&nbsp;
                    </td>
                    <td style="text-align: left; " class="auto-style1">
                        <asp:Label ID="lblID" runat="server" style="display:none" ></asp:Label>
                        <asp:TextBox ID="txtDiscountName" runat="server" MaxLength="50"></asp:TextBox>
                       <input type="hidden" id="hdndiscountid" value="" />
                    </td>
                    <td style="text-align: right; width: 20%">Discount Per.(%):&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtDiscountPer" runat="server" MaxLength="10"  onkeyup="this.value = chkValidateCon(this.value, 0, 100,0)" onkeypress="return checkNumericDecimal(event,this);"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbDiscountPer" runat="server" TargetControlID="txtDiscountPer" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">From Validity Date :&nbsp;
                    </td>
                    <td style="text-align: left; " class="auto-style1">
                        <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right; width: 20%">To Validity Date :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">From Age(In Year) :&nbsp;
                    </td>
                    <td style="text-align: left; " class="auto-style1">
                        <asp:TextBox ID="txtFromAge" runat="server" MaxLength="3" onblur='chkAge()' onkeyup='this.value = chkValidateCon(this.value, 0, 110,1)'></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbFromAge" runat="server" TargetControlID="txtFromAge" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="text-align: right; width: 20%">To Age (In Year) :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtToAge" runat="server" MaxLength="3" onblur='chkAge()' onkeyup='this.value =chkValidateCon(this.value, 0, 110,1)'></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbToAge" runat="server" TargetControlID="txtToAge" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 20%">Gender :&nbsp;
                    </td>
                    <td style="text-align: left; " class="auto-style1">
                    <asp:DropDownList ID="ddlGender" runat="server"    >
                        <asp:ListItem Text="Both" Selected="True" Value="B"></asp:ListItem>
                        <asp:ListItem Text="Male" Value="M"></asp:ListItem>
                        <asp:ListItem Text="Female" Value="F"></asp:ListItem>
                    </asp:DropDownList>
                    </td>
                    <td style="text-align: right; width: 20%">Disc Share Type :&nbsp;</td>
                    <td style="text-align: left; width: 30%">
                        <asp:DropDownList ID="ddlsharetype" runat="server"><asp:ListItem Value="0">Client Share</asp:ListItem><asp:ListItem Value="1">Client Share</asp:ListItem></asp:DropDownList> </td>
                </tr>
               
                <tr>
                    <td style="text-align: right; width: 20%">&nbsp;</td>
                    <td style="text-align: left; " class="auto-style1">
                       <asp:CheckBox ID="chall" runat="server" Font-Bold="true" Text="Applicable For All" onclick="showcentre()" Checked="true" /></td>
                    <td style="text-align: right; width: 20%">&nbsp;</td>
                    <td style="text-align: left; width: 30%">
                        &nbsp;</td>
                </tr>
               
                <tr>
                    <td colspan="4" class="auto-style2">

                        <table width="100%" id="centretag" style="display:none;">
                             <tr>
                    <td style="text-align: right; " colspan="4">
            <div class="Purchaseheader">
                Centre Tagging
            </div>
                    </td>
                </tr>
                          <tr>
                    <td style="text-align: right; width: 20%">Zone :&nbsp;</td>
                    <td style="text-align: left; width: 30%">
                         <%--<asp:DropDownList ID="ddlBusinessZone" runat="server" Width="240px" onchange="bindstate()"></asp:DropDownList>--%>
                        <asp:ListBox ID="ddlBusinessZone" runat="server" CssClass="multiselect" SelectionMode="Multiple"  Height="25px"  Width="260px" onchange="bindstate()"></asp:ListBox>
                    </td>
                    <td style="text-align: right; width: 20%">State :&nbsp;</td>
                    <td style="width: 30%" align="left">
                        <input type="hidden" id="hdnstate" value="" />
                         <asp:ListBox ID="lstStateList" runat="server" CssClass="multiselect" SelectionMode="Multiple"  Height="25px"  Width="260px" onchange="bindcenterList()"></asp:ListBox>
                    </td>
                </tr>

                             <tr>
                    <td style="text-align: right; width: 20%">Centre Type :&nbsp;</td>
                    <td style="width: 30%" align="left" >
                         <input type="hidden" id="hdcentretype" value="" />
                         <%--<asp:DropDownList ID="ddlBusinessZone" runat="server" Width="240px" onchange="bindstate()"></asp:DropDownList>--%>
                        <asp:ListBox ID="ddlcentretype" runat="server" CssClass="multiselect" SelectionMode="Multiple"  Height="25px"  Width="260px" onchange="bindcenterList()"></asp:ListBox>
                    </td>

                                 </tr>
                <tr>
                      <td style="text-align: right; width: 20%">Centre :&nbsp;</td>
                    <td style="width: 30%" align="left">
                        <input type="hidden" id="hdncenter" value="" />
                        <asp:ListBox ID="lstCenterList" runat="server" CssClass="multiselect" SelectionMode="Multiple" Height="25px" Width="260px" onchange="bindpanel()"></asp:ListBox>                     
                    </td>
                      <td style="text-align: right; width: 20%">Rate Type :&nbsp;</td>
                    <td style="width: 30%" align="left">
                        <input type="hidden" id="hdnpanel" value="" />
                      <asp:ListBox ID="lstPanellist" runat="server" CssClass="multiselect" SelectionMode="Multiple" Height="25px" Width="260px"></asp:ListBox>                       
                    </td>
                </tr>
                        </table>
                        <input type="button" id="btnAdd" value="Save" onclick="addDiscount();" class="savebutton" /></td>
                </tr>


                
                


                
            
            </table>

             <div class="POuter_Box_Inventory" style="width:1299px;text-align:center" >
                <table>
                    <tr>
                    <td style="text-align: center;">
                            &nbsp;</td>
                    <td style="text-align: right;">
                            <strong>Discount Type:</strong> 
                    </td>
                    <td style="text-align: center;">
                            <asp:DropDownList ID="ddlname" runat="server" Width="200px"></asp:DropDownList>
                    </td>
                    <td style="text-align: left;">
                            <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal" style="font-weight: 700">
                                <asp:ListItem Value="1" Selected="True">Centre List</asp:ListItem>
                                <asp:ListItem Value="2" >Test List</asp:ListItem>
                            </asp:RadioButtonList>


                    </td>

                    <td>
                         <input type="button" value="Get Data" class="searchbutton" onclick="getdata()" />
                    </td>
                </tr>
                </table>
            </div>
            <div id="CampOutput" style="max-height: 200px; overflow-y: auto; overflow-x: hidden;">
                <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                    <tr id="DiscountHeader">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 200px; text-align: center">S.No</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 200px; text-align: center">Discount Name</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: center">Discount Per.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 90px; text-align: center">From Date</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 90px; text-align: center">To Date</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: center">From Age</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: center">To Age</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 80px; text-align: center">Gender</th>                  
                        <th class="GridViewHeaderStyle" scope="col" style="width: 260px; text-align: center">Panel</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: center">Remove</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: center">View</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: center">Add Item</th>

                    </tr>
                </table>
            </div>
        </div>      
    
         <div class="POuter_Box_Inventory" style="margin-top:10px;width:1300px;" >
         <div id="div_InvestigationItems"  style="text-align:center">
                
            </div>
     </div> 

         <asp:Button ID="btnHideSin" runat="server" Style="display:none" />
         <cc1:ModalPopupExtender ID="mpSinInfo" runat="server" CancelControlID="btnCancelSinInfo"
                            DropShadow="true" TargetControlID="btnHideSin" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlSinDisplay"  OnCancelScript="closeViewPanel()"  BehaviorID="mpSinInfo">
                        </cc1:ModalPopupExtender>          
    </div>
     <asp:Panel ID="pnlSinDisplay" runat="server" Style="display: none;width:830px; " CssClass="pnlVendorItemsFilter">   
    <div class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>   
                    <td> Discount Name :&nbsp;<span id="viewDiscoutname"></span></td>                    
                    <td  style="text-align:right">      
                        <img id="btnCancelSinInfo" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" />  
                    </td>                    
                </tr>
        </table>
      </div>
    <div id="divSendSampleDetail" style="overflow:auto; height:500px"></div> 
    </asp:Panel>

     <asp:Button ID="btnhiddenAddItem" runat="server" Style="display:none" />
    <cc1:ModalPopupExtender ID="AddItem" runat="server"
                            DropShadow="true" TargetControlID="btnhiddenAddItem" CancelControlID="closeAddItem" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlItemDisplay"  OnCancelScript="CloseAddItem()"  BehaviorID="AddItem">
                        </cc1:ModalPopupExtender>  
    <asp:Panel ID="pnlItemDisplay" runat="server" Style="display: none;width:800px; height:485px; " CssClass="pnlVendorItemsFilter">
            <input type="hidden" id="itemdiscountid" value="" />
            
            
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr> 
                    <td> Discount Name :&nbsp;<span id="itemdiscountname"></span></td>                   
                    <td  style="text-align:right">      
                        <img id="closeAddItem" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" />  
                    </td>
                    
                </tr>
            </table>   

      </div>
              <table style="width: 100%;border-collapse:collapse">
                  <tr>
                  <td style="width:100%;vertical-align:top" >
                   
                     <table style="width:99%"> 
                                   <tr>
                                       <td> Department :&nbsp;</td>
                                       <td>
                                            <asp:DropDownList ID="ddlDepartment" onchange="GetItems(this)" runat="server" 
                                    Width="340px"  class="ddlDepartment chosen-select"></asp:DropDownList></td>                                      
                                   </tr>
                                
                                  
                               </table>
                                  
                           </td>
                      </tr>

                  <tr>
                      <td>
            <div id="div_items" style="text-align:center; max-height:200px;overflow-y:scroll;">
                
            </div>
                 <div style="text-align:center; ">
                 <input type="button" class="ItDoseButton" onclick="saveItem()" id="btnsaveItem" style="display:none1;" value="Add"/>
                  </div>
                      </td>
                  </tr>

                     <tr>
                      <td>
            <div id="div_items1"   style="text-align:center; max-height:200px; overflow-y:scroll;">
                
            </div>
                  
                      </td>
                  </tr>
                </table>    
       
    </asp:Panel>
    <script id="tb_Items" type="text/html" >
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tbl_items" style="border-collapse:collapse; width:100%;" >
		<tr id="itemheader">
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Test Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:170px;">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;"> <input type="checkbox" onchange="checkall(this)" id="chkall"/></th>   
</tr>
       <#      
              var itemdataLength=itemData.length;
           
              var objRow;   
        for(var j=0;j<itemdataLength;j++)
        {
        objRow = itemData[j];        
            #>
 <tr>                                      
     <td class="GridViewLabItemStyle"><#=j+1#></td>
     <td id="td3" class="GridViewLabItemStyle" align="left"><#=objRow.TestCode#></td>     
     <td id="td4" class="GridViewLabItemStyle" align="left"><#=objRow.ItemName#></td>
     <td id="td5" class="GridViewLabItemStyle"> <input type="checkbox" class="itemCheckbox" value="<#=objRow.ItemID#>"/></td>    
     
</tr>
            <#}#>
     </table>    
    </script>
    <script id="tb_Items1" type="text/html" >
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="TableItem" style="border-collapse:collapse; width:100%;" >
		<tr>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;padding: 5px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;padding: 5px;" align="left">Department Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;padding: 5px;" align="left">Test Code</th>          
			<th class="GridViewHeaderStyle" scope="col" style="width:300px;padding: 5px;" align="left">Item Name</th>
            
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;padding: 5px;"> <img id="Img6" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" onclick="RemoveItemAll(<#=itemData1[0].DiscountID#>)" /></th>
           
        </tr>
       <#      
              var itemdataLength=itemData1.length;
          
              var objRow;   
        for(var j=0;j<itemdataLength;j++)
        {
        objRow = itemData1[j];        
            #>
             <tr>                                      
                 <td class="GridViewLabItemStyle srno"><#=j+1#></td>
                 <td id="td9" class="GridViewLabItemStyle" align="left"><#=objRow.Department#></td> 
                 <td id="td6" class="GridViewLabItemStyle" align="left"><#=objRow.TestCode#></td>     
                 <td id="td7" class="GridViewLabItemStyle" align="left"><#=objRow.ItemName#></td>
                 <%--<td id="td8" class="GridViewLabItemStyle"><#=objRow.DiscountName#></td>--%>    
                 <td align="center" class="GridViewLabItemStyle"><img id="Img4" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" onclick="RemoveItem(<#=objRow.ItemID#>,<#=objRow.DiscountID#>,this)" /></td>           
            </tr>
            <#}#>
     </table>    
    </script>
    <script id="tb_InvestigationItems" type="text/html" >
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" style="border-collapse:collapse; width:100%;" >
         <tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col">Discount Name</th>
             <th class="GridViewHeaderStyle" scope="col">DiscShareType</th>
			<th class="GridViewHeaderStyle" scope="col">Disc(%)</th>	
            <th class="GridViewHeaderStyle" scope="col">From Date</th>	
            <th class="GridViewHeaderStyle" scope="col">To Date</th>	
            <th class="GridViewHeaderStyle" scope="col">From Age</th>	
             <th class="GridViewHeaderStyle" scope="col">To Age</th>	
             <th class="GridViewHeaderStyle" scope="col">Gender</th>
             <th class="GridViewHeaderStyle" scope="col" >CreatedBy</th>
             <th class="GridViewHeaderStyle" scope="col">CreatedDate</th>
             <th class="GridViewHeaderStyle" scope="col">LastUpdateBy</th>
               <th class="GridViewHeaderStyle" scope="col">LastUpdateDate</th>
           <%--  <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Panel</th>--%>	
            <th class="GridViewHeaderStyle" scope="col">Edit</th>		
           
            <th class="GridViewHeaderStyle" scope="col">View</th>
             <th class="GridViewHeaderStyle" scope="col">Add Item</th>
              <th class="GridViewHeaderStyle" scope="col">Remove</th>	
</tr>
       <#      
              var dataLength=PatientData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j];        
            #>
            <tr id="tr_<#=j+1#>">                                      
     <td class="GridViewLabItemStyle"><#=j+1#></td>
     <td id="tdDiscountName"  class="GridViewLabItemStyle"><#=objRow.DiscountName#></td>
                <td id="td18"  class="GridViewLabItemStyle"><#=objRow.DiscShareType#></td>
     <td id="tdCentreCode" class="GridViewLabItemStyle"><#=objRow.DiscountPercentage#></td>
     <td id="tdCentre" class="GridViewLabItemStyle"><#=objRow.FromDate#></td>
     <td id="tdState"  class="GridViewLabItemStyle"><#=objRow.ToDate#></td>
     <td id="tdCity"  class="GridViewLabItemStyle"><#=objRow.FromAge#></td>
     <td id="tdAge"  class="GridViewLabItemStyle"><#=objRow.ToAge#></td>
     <td id="tdGender"  class="GridViewLabItemStyle"><#=objRow.Gender#></td>
                <td id="td8"  class="GridViewLabItemStyle"><#=objRow.createdby#></td>
                <td id="td12"  class="GridViewLabItemStyle"><#=objRow.createddate#></td>
                <td id="td16"  class="GridViewLabItemStyle"><#=objRow.Updatename#></td>
                <td id="td17"  class="GridViewLabItemStyle"><#=objRow.Updatedate#></td>
     <td align="center" class="GridViewLabItemStyle"><img id="Img2" alt="1" src="../../App_Images/edit.png"  style="cursor:pointer;" onclick="ShowDetail('<#=objRow.DiscountID#>')" /></td>
   
     <td align="center" class="GridViewLabItemStyle"><img id="Img1" alt="View" src="../../App_Images/view.gif"  style="cursor:pointer;" onclick="viewSampleDetail(<#=objRow.DiscountID#>,'<#=objRow.DiscountName#>')" /></td>
     <td align="center" class="GridViewLabItemStyle"><img id="Img3" alt="Add" src="../../App_Images/plus.png"  style="cursor:pointer;" onclick="ViewAddItem(<#=objRow.DiscountID#>,'<#=objRow.DiscountName#>',this)" /></td>
                  <td align="center" class="GridViewLabItemStyle"><img id="<#=objRow.Id#>#<#=objRow.Id#>#tr_<#=j+1#>" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" onclick="RemoveData(this)" /></td>
     <td id="tdID"  class="GridViewLabItemStyle" style="display:none"><#=objRow.DiscountID#></td>
</tr>
            <#}#>
     </table>    
    </script>
    <script id="tb_Panel" type="text/html" >
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="PanelTable" style="border-collapse:collapse; width:100%;" >
		<tr>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Zone</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">State</th>
            	<th class="GridViewHeaderStyle" scope="col" style="width:120px;">CentreType</th>
            	<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Code</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:300px;">Rate Type</th>
             <td align="center" scope="col" class="GridViewHeaderStyle"style="width:80px;">Remove</td>           
        </tr>
       <#      
        var PanelDetailLenght=PanelDetail.length;        
        var objRow;   
        for(var j=0;j<PanelDetailLenght;j++)
        {
        objRow = PanelDetail[j];        
            #>
            <tr>                                      
     <td class="GridViewLabItemStyle srno"><#=j+1#></td>
     <td id="td10" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.BusinessZoneName#></td>     
     <td id="td11" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.state#></td>
                 <td id="td1" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.CentreType#></td>
                 <td id="td2" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Centre#></td>
      <td id="td13" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Panel_Code#></td>     
     <td id="td14" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Company_Name#></td>
      <td id="td15" class="GridViewLabItemStyle" style="text-align:center;"><img id="Img5" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" onclick="RemovePanel(<#=objRow.DiscountID#>,<#=objRow.PanelId#>,this)" /></td>     
     
    
     
</tr>
            <#}#>
     </table>    
    </script>

    <script type="text/javascript">
         function ViewAddItem(DiscountID,DiscountName, e) {
             bindDepartment();
             $("#itemdiscountid").val(DiscountID);
             $("#itemdiscountname").text(DiscountName);
             
             GetDiscountItems();
             $find('AddItem').show();
         }
         function CloseAddItem() {
             $('#div_items').html('');
             $('#div_items1').html('');
             $("#itemdiscountid").val('');
             $find('AddItem').hide();
         }

        
         function clearItem() {
             $("#ddlInvestigation").val('');
         }

         function bindDepartment() {
             PageMethods.bindDepartment(onSuccessDepartment);
             
         }
         function onSuccessDepartment(result) {
             jQuery("#ddlDepartment option").remove();
             if (result.length > 0) {
                 var DepartmentData = jQuery.parseJSON(result);
                 jQuery('#ddlDepartment').append($("<option></option>").val("0").html("All"));
                 for (i = 0; i < DepartmentData.length; i++) {
                     jQuery('#ddlDepartment').append(jQuery("<option></option>").val(DepartmentData[i].SubCategoryID).html(DepartmentData[i].NAME));
                 }
             }
             
         }
         function GetItems(e) {
             $('#div_items').html('');
             var subcategoryID = jQuery("#ddlDepartment option:selected").val();
             if (subcategoryID == "0") {
                 $('#btnsaveItem').show();
                 return;
             }
             $.ajax({
                 url: "DiscountMaster.aspx/binditems",
                 data: '{SubCategoryId:"' + subcategoryID + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     itemData = jQuery.parseJSON(result.d);
                     if (itemData.length != 0) {
                         var output = $('#tb_Items').parseTemplate(itemData);
                         $('#div_items').html(output);
                        // $("#div_items").scrollTop($('#div_items').prop('scrollHeight'));
                         $('#div_items').scrollTop(0);
                         $('#btnsaveItem').show();
                     }
                     else {
                         $('#btnsaveItem').hide();
                     }
                 },
                 error: function (xhr, status) {
                     alert("Error ");
                 }
             });

         }

         function GetDiscountItems() {
             var DiscountID = $("#itemdiscountid").val();
             $.ajax({
                 url: "DiscountMaster.aspx/GetDiscountItems",
                 data: '{DiscountID:"' + DiscountID + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     itemData1 = jQuery.parseJSON(result.d);
                     if (itemData1.length != 0) {
                         var output = $('#tb_Items1').parseTemplate(itemData1);
                         $('#div_items1').html(output);
                        // $("#div_items1").scrollTop($('#div_items1').prop('scrollHeight'));
                         $('#div_items1').scrollTop(0);
                     }
                 },
                 error: function (xhr, status) {
                     alert("Error ");
                 }
             });

         }

         function checkall(e) {

             if ($(e).prop("checked") == true) {
                 $('.itemCheckbox').prop('checked', true);
             }
             if ($(e).prop("checked") == false) {
                 $('.itemCheckbox').prop('checked', false);
             }

         }

         function saveItem() {
             var dataItem = new Array();
             var obj = new Object();
             $('#tbl_items > tbody > tr').each(function (i, el) {
                 if ($(this).find("input[type=checkbox]").prop("checked") == true) {
                     obj.ID = 0;
                     obj.ItemID = $(this).find("input[type=checkbox]").val();
                     obj.DiscountID = $("#itemdiscountid").val();
                     dataItem.push(obj);
                     obj = new Object();
                 }
             });
             var DepartmentID = jQuery("#ddlDepartment option:selected").val();
             var DiscountID = $("#itemdiscountid").val();
             jQuery("#btnsaveItem").attr('disabled', 'disabled').val('Adding...');
             $.ajax({
                 type: "POST",
                 url: "DiscountMaster.aspx/saveItem",
                 data: "{ItemDetail:'" + JSON.stringify(dataItem) + "',DepartmentID:'" + DepartmentID + "',DiscountID:'" + DiscountID + "'}",
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (result) {
                      
                     if (result.d == "1") {
                         $("#btnsaveItem").removeAttr('disabled').val('Add');
                         GetDiscountItems();
                     }
                 },
                 failure: function (response) {

                 }
             });

         }

         function RemoveItem(ItemID, DiscountID,event) {

             $.ajax({
                 url: "DiscountMaster.aspx/RemoveItem",
                 data: '{DiscountID:"' + DiscountID + '",ItemID:"' + ItemID + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {

                     if (result.d == "1") {
                         $(event).closest('tr').remove();
                         addSerialNumber("TableItem");

                        // $('#div_items1').html('');
                         //GetDiscountItems();
                     }
                 },
                 failure: function (response) {

                 }
             });


         }

         function RemoveItemAll(DiscountID) {

             $.ajax({
                 url: "DiscountMaster.aspx/RemoveItemAll",
                 data: '{DiscountID:"' + DiscountID + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {

                     if (result.d == "1") {
                         $('#TableItem tr').slice(1).remove();
                        
                        

                         // $('#div_items1').html('');
                         //GetDiscountItems();
                     }
                 },
                 failure: function (response) {

                 }
             });


         }

         RemoveItemAll
    </script>
    <script type="text/javascript">
         $(window).on("load", function () {
             $.ready.then(function () {
                 SearchData();
             });
         })
         function ShowDetail(DiscountID) {
             $.ajax({
                 url: "DiscountMaster.aspx/ShowDetail",
                 data: '{DiscountID:"' + DiscountID + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     PatientData = jQuery.parseJSON(result.d);
                     $("#<%=lblID.ClientID %>").html(PatientData[0].Id);
                     $("#<%=txtDiscountName.ClientID %>").val(PatientData[0].DiscountName);                     
                     $('#hdndiscountid').val(PatientData[0].DiscountID);
                     $("#<%=txtDiscountPer.ClientID %>").val(PatientData[0].DiscountPercentage);
                     $("#<%=txtFromDate.ClientID %>").val(PatientData[0].FromDate);
                     $("#<%=txtToDate.ClientID %>").val(PatientData[0].ToDate);
                     $("#<%=txtFromAge.ClientID %>").val(PatientData[0].FromAge);
                     $("#<%=txtToAge.ClientID %>").val(PatientData[0].ToAge);
                     $("#<%=ddlGender.ClientID %>").val(PatientData[0].Gender);
                     $("#<%=ddlsharetype.ClientID%>").val(PatientData[0].DiscShareType);
                     if (PatientData[0].PanelID != "0") {
                         $('#chall').prop("checked", false);
                         showcentre();
                         $('#<%= ddlBusinessZone.ClientID%>').multipleSelect("setSelects", PatientData[0].BusinessZoneID.split(','));
                         $("#hdnstate").val(PatientData[0].StateID);
                         $("#hdnpanel").val(PatientData[0].PanelID);
                         $("#hdncenter").val(PatientData[0].CentreID);
                         $("#hdcentretype").val(PatientData[0].Type1ID);
                         $('#<%= lstStateList.ClientID%>').multipleSelect("setSelects", PatientData[0].StateID.split(','));
                         $('#<%= lstCenterList.ClientID%>').multipleSelect("setSelects", PatientData[0].CentreID.split(','));
                         $('#<%= lstPanellist.ClientID%>').multipleSelect("setSelects", PatientData[0].PanelID.split(','));
                         $('#<%= ddlcentretype.ClientID%>').multipleSelect("setSelects", PatientData[0].Type1ID.split(','));
                         

                     }
                     else {
                         $('#chall').prop("checked", true);
                         showcentre();
                     }
                     $("#btnAdd").val('Update');
                 },
                 error: function (xhr, status) {
                     alert("Error ");
                 }
             });
         }
         function viewSampleDetail(DiscountID, DiscoutName) {
             if(DiscoutName!='')
                 $('#viewDiscoutname').text(DiscoutName);

             $.ajax({
                 url: "DiscountMaster.aspx/viewSampleData",
                 data: '{DiscountID:"' + DiscountID + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PanelDetail = jQuery.parseJSON(result.d);
                     if (PanelDetail.length != 0) {
                         var output = $('#tb_Panel').parseTemplate(PanelDetail);
                         $('#divSendSampleDetail').html(output);
                         $("#divSendSampleDetail").scrollTop($('#div_items').prop('scrollHeight'));
                     }
                 },
                 error: function (xhr, status) {
                     window.status = status + "\r\n" + xhr.responseText;
                 }

             });

             $find('mpSinInfo').show();
         }
         function closeViewPanel() {
             $('#div_items').html('');
             $("#itemdiscountid").val('');
         }

         function RemovePanel(DiscountID, PanelID,event) {
             
             $.ajax({
                 url: "DiscountMaster.aspx/RemovePanel",
                 data: '{DiscountID:"' + DiscountID + '",PanelID:"' + PanelID + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     if (result.d == "1") {
                         $(event).closest('tr').remove();
                         //$('#divSendSampleDetail').html('');
                         addSerialNumber("PanelTable")
                         //viewSampleDetail(DiscountID,'');
                     }
                 },
                 failure: function (response) {

                 }
             });


         }
         </script> 
    <script type="text/javascript">
          function SearchData() {
              $.ajax({
                  url: "DiscountMaster.aspx/Search",
                  data: {},
                  type: "POST", // data has to be Posted    	        
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  success: function (result) {
                      debugger;
                      PatientData = jQuery.parseJSON(result.d);
                      if (PatientData.length > 0) {
                          var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                          $('#div_InvestigationItems').html(output);
                      }
                  },
                  error: function (xhr, status) {
                      alert("Error ");
                  }
              });

          }
          function RemoveData(rowID) {
              if (confirm("Are you sure you want to delete?")) {
                  $.ajax({
                      url: "DiscountMaster.aspx/Remove",
                      data: '{ ID: "' + $(rowID).closest('tr').find('#tdID').text() + '"}',
                      type: "POST",
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      dataType: "json",
                      success: function (result) {
                          if (result.d == 1) {
                              alert('Record Removed Successfully');
                              SearchData();
                          }
                      },
                      error: function (xhr, status) {
                          alert("Error ");
                      }
                  });
              }
              return false;




          }
    </script>
    <script type="text/javascript">

        jQuery(function () {
            jQuery('[id*=lstCentreList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });

        function changeDiscountName() {
            var DiscountName = $("#txtDiscountName").val();
            if (jQuery('#tbSelected tr:not(#DiscountHeader)').length > 0) {
                $(".clDiscountName").text(DiscountName);
            }
        }
        function changeDiscountPer() {
            var DiscountPer = $("#txtDiscountPer").val();
            if (jQuery('#tbSelected tr:not(#DiscountHeader)').length > 0) {
                $(".clDiscountPer").text(DiscountPer);
            }
        }
        function chkAge() {
            if (jQuery("#txtFromAge").val() != "" && jQuery("#txtToAge").val() != "") {

                if (parseFloat(jQuery("#txtFromAge").val()) > parseFloat(jQuery("#txtToAge").val())) {
                    jQuery("#txtToAge").focus();
                    jQuery("#lblMsg").text('From Age Can Not Greater Then To Age');
                    jQuery("#txtToAge").val('');
                    return;
                }
            }
        }
        function chkValidateCon(value, min, max, con) {

            if (parseInt(value) > max) {
                if (con == 0)
                    alert("Discount Percentage can not Greater then 100");
                else
                    alert("Age can not Greater then 110");
                return "";
            }


            else return value;
        }
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function checkNumericDecimal(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            if (sender.value == 0) {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }


            return true;
        }
        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
        }
    </script>
    <script type="text/javascript">
      
        function addDiscount() {
            jQuery("#lblMsg").text('');
            if (jQuery.trim(jQuery("#txtDiscountName").val()) == "") {
                jQuery("#txtDiscountName").focus();
                jQuery("#lblMsg").text('Please Enter Discount Name');
                return;
            }
            if (jQuery.trim(jQuery("#txtDiscountPer").val()) == "" || jQuery.trim(jQuery("#txtDiscountPer").val()) == 0) {
                jQuery("#txtDiscountPer").focus();
                jQuery("#lblMsg").text('Please Enter Discount Percentage');
                return;
            }

            if (jQuery.trim(jQuery("#txtFromDate").val()) == "") {
                jQuery("#txtFromDate").focus();
                jQuery("#lblMsg").text('Please Enter From Validity Date');
                return;
            }
            if (jQuery.trim(jQuery("#txtToDate").val()) == "") {
                jQuery("#txtToDate").focus();
                jQuery("#lblMsg").text('Please Enter To Validity Date');
                return;
            }
         
            var startDate = new Date($('#<%= txtFromDate.ClientID%>').val());
            var endDate = new Date($('#<%= txtToDate.ClientID%>').val());           
            if (endDate < startDate) {
                $('#<%= txtToDate.ClientID%>').focus();
                jQuery("#lblMsg").text('to date cannot be less than from date');
                return;
            }

            if (jQuery.trim(jQuery("#txtFromAge").val()) == "") {
                jQuery("#txtFromAge").focus();
                jQuery("#lblMsg").text('Please Enter From Age');
                return;
            }
            if (jQuery.trim(jQuery("#txtToAge").val()) == "") {
                jQuery("#txtToAge").focus();
                jQuery("#lblMsg").text('Please Enter To Age');
                return;
            }
            if (parseInt(jQuery.trim(jQuery("#txtFromAge").val())) > parseInt(jQuery.trim(jQuery("#txtToAge").val()))) {
                jQuery("#txtToAge").focus();
                jQuery("#lblMsg").text('From Age Can Not Greater Then To Age');
                return;
            }
            if ($('#<%=chall.ClientID%>').is(":checked") == false) {
                var ZoneSelectedLaength = jQuery('#ddlBusinessZone').multipleSelect("getSelects").length;

                if (ZoneSelectedLaength == 0) {
                    jQuery("#ddlBusinessZone").focus();
                    jQuery("#lblMsg").text('Please Select Zone');
                    return;
                }

                var StateSelectedLaength = jQuery('#lstStateList').multipleSelect("getSelects").length;

                if (StateSelectedLaength == 0) {
                    jQuery("#lstStateList").focus();
                    jQuery("#lblMsg").text('Please Select State');
                    return;
                }
                var centerSelectedLaength = jQuery('#lstCenterList').multipleSelect("getSelects").length;

                if (centerSelectedLaength == 0) {
                    jQuery("#lstCenterList").focus();
                    jQuery("#lblMsg").text('Please Select Center');
                    return;
                }

                var PanelSelectedLaength = jQuery('#lstPanellist').multipleSelect("getSelects").length;

                if (PanelSelectedLaength == 0) {
                    jQuery("#lstPanellist").focus();
                    jQuery("#lblMsg").text('Please Select Panel');
                    return;
                }
            }
            else {
                jQuery("#lstPanellist option").remove();
            }
            var DiscountItem = new Array();
            var obj = new Object();
            $('#tbl_items > tbody > tr').each(function (i, el) {

                obj.ID = 0;
                obj.ItemID = $(this).find("input[type=checkbox]").val();
                obj.DiscountID = $("#itemdiscountid").val();
                dataItem.push(obj);
                obj = new Object();
            });
            btnval = jQuery("#btnAdd").val();
            
            if(btnval=="Save")
                jQuery("#btnAdd").attr('disabled', 'disabled').val('saving...');
            else
                jQuery("#btnAdd").attr('disabled', 'disabled').val('updating...');
 
            var obj = new Object();
            obj.DiscountID = $('#hdndiscountid').val();
            obj.DiscountName = $("#txtDiscountName").val();
            obj.Id = $("#lblID").text();
            obj.DiscountPer = $("#txtDiscountPer").val();
            obj.FromDate = $("#txtFromDate").val();
            obj.ToDate = $("#txtToDate").val();
            obj.FromAge = $("#txtFromAge").val();
            obj.ToAge = $("#txtToAge").val();
            obj.Gender = $("#ddlGender").val();
            obj.DiscShareType = $("#ddlsharetype").val();


          
            $.ajax({
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                url: "DiscountMaster.aspx/saveDiscount",
                data: "{Record:'" + JSON.stringify(obj) + "',Panel:'" + $("#lstPanellist").val() + "'}",
                success: function (Record) {
                    if (Record.d == "3") {
                        $('#lblMsg').text(" Discount Name already Exist");
                        SearchData();
                        if (btnval == "Save")
                            $("#btnAdd").removeAttr('disabled').val('Save');
                        else
                            $("#btnAdd").removeAttr('disabled').val('Update');
                    }
                    if (Record.d == "1") {
                        $('#lblMsg').text(" Record Saved Successfully");
                        cleare();
                        SearchData();
                        $("#btnAdd").removeAttr('disabled').val('Save');
                    }                  
                  
                },
                Error: function (textMsg) {
                    $('#lblMsg').text("Error: " + Error);
                  
                    if (btnval == "Save")
                        $("#btnAdd").removeAttr('disabled').val('Save');
                    else
                        $("#btnAdd").removeAttr('disabled').val('Update');
                }
            });
        }

        function cleare() {
            jQuery('#tbSelected,#tb_ItemList').hide();
            jQuery("#tbSelected tr:not(#DiscountHeader)").remove();

            jQuery('#txtDiscountName').val('').removeAttr('disabled');           
            jQuery("#lstStateList option").remove();
            jQuery("#lstStateList").multipleSelect('refresh');
            jQuery("#lstPanellist option").remove();
            jQuery("#lstPanellist").multipleSelect('refresh');

            jQuery("#lstCenterList option").remove();
            jQuery("#lstCenterList").multipleSelect('refresh');

            $("#hdnstate").val('');
            $("#hdnpanel").val('');
            $("#hdncenter").val('');

            $("#lblID").text(''); 
            $('#<%= txtFromAge.ClientID%>').val('');
            $('#<%= txtToAge.ClientID%>').val('');
            $('#<%= txtDiscountPer.ClientID%>').val('');
            $('#<%= ddlBusinessZone.ClientID%>').multipleSelect("setSelects", []);           
            $('#<%= ddlBusinessZone.ClientID%>').val('').trigger('chosen:updated');
           
        }
           </script>  
    <script type="text/javascript">
        //function bindCentre() {
        //    jQuery("#lstCentreList option").remove();
        //    jQuery("#lstCentreList").multipleSelect('refresh');
        //    if (jQuery("#ddlBusinessZone").val() != "0") {
        //        PageMethods.bindCentre(jQuery("#ddlBusinessZone").val(), onSuccessCallback, OnfailureCallback);

        //    }
        //    else {
        //    }
        //}
        function bindstate() {
            
            jQuery("#lstStateList option").remove();
            jQuery("#lstStateList").multipleSelect('refresh');
            var selectedZone = $("#ddlBusinessZone").val();
            if (jQuery("#ddlBusinessZone").val() != "0") { 
                $.ajax({
                    type: "POST",
                    dataType: 'json',
                    contentType: "application/json; charset=utf-8",
                    url: "DiscountMaster.aspx/bindstate",
                    data: '{"BusinessZoneID":"' + selectedZone + '"}',//
                    success:onSuccessCallback1,
                    error:OnfailureCallback1 // some error
                });
            }
            else {

            }
        }


       



        function bindcenterList() {
            jQuery("#lstCenterList option").remove();
            jQuery("#lstCenterList").multipleSelect('refresh');
            if (jQuery("#lstStateList").val() != "0") {
                var StateID = $("#lstStateList").val();
                var type = $("#ddlcentretype").val();
                $.ajax({
                    type: "POST",
                    dataType: 'json',
                    contentType: "application/json; charset=utf-8",
                    url: "DiscountMaster.aspx/bindCentreMaster",
                    data: '{"StateID":"' + StateID + '",typeID:"' + type + '"}',//
                    success: onSuccessCenter,
                    error: OnfailureCenter // some error
                });

            }
            else {

            }
        }
        function bindpanel() {
            jQuery("#lstPanellist option").remove();
            jQuery("#lstPanellist").multipleSelect('refresh');
            if (jQuery("#lstCenterList").val() != "0") {
                var CenterID = $("#lstCenterList").val();
                $.ajax({
                    type: "POST",
                    dataType: 'json',
                    contentType: "application/json; charset=utf-8",
                    url: "DiscountMaster.aspx/bindpanel",
                    data: '{"CenterID":"' + CenterID + '"}',//
                    success: onSuccessCallback2,
                    error: function () { alert('error'); } // some error
                });
                
            }
            else {

            }
        }
      

        function onSuccessCenter(result) {
            if (result.d.length > 0) {

                var CentreData = jQuery.parseJSON(result.d);
                if (CentreData.length == 0) {

                    jQuery('#<%=lstCenterList.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {

                    for (i = 0; i < CentreData.length; i++) {
                        jQuery('#<%=lstCenterList.ClientID%>').append(jQuery("<option></option>").val(CentreData[i].CentreID).html(CentreData[i].Centre));
                    }
                    jQuery('[id*=lstCenterList]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });

                }

                var selectedcenter = $("#hdncenter").val();
                console.log(selectedcenter);
                if (selectedcenter.length > 0)
                    $('#<%= lstCenterList.ClientID%>').multipleSelect("setSelects", selectedcenter.split(','));

            }

        }
        function OnfailureCenter(error) {


        }

        function onSuccessCallback1(result) {            
            if (result.d.length > 0) {
               
                var CentreData = jQuery.parseJSON(result.d);
                if (CentreData.length == 0) {

                    jQuery('#<%=lstStateList.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }
                else {

                    for (i = 0; i < CentreData.length; i++) {
                        jQuery('#<%=lstStateList.ClientID%>').append(jQuery("<option></option>").val(CentreData[i].id).html(CentreData[i].state));
                    }
                    jQuery('[id*=lstStateList]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });

                }

                var selectedState = $("#hdnstate").val();                
                if(selectedState.length>0)
                    $('#<%= lstStateList.ClientID%>').multipleSelect("setSelects", selectedState.split(','));
               
            }

        }
        function OnfailureCallback1(error) {


        }
        function onSuccessCallback2(result) {
 
             if (result.d.length > 0)
            {
            //  alert('1');
            var CentreData = jQuery.parseJSON(result.d);
            if (CentreData.length == 0) {
                jQuery('#<%=lstPanellist.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
                for (i = 0; i < CentreData.length; i++) {
                    jQuery('#<%=lstPanellist.ClientID%>').append(jQuery("<option></option>").val(CentreData[i].Panel_ID).html(CentreData[i].Company_Name));
                }
                jQuery('[id*=lstPanellist]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });

            }
                 var selectedPanel = $("#hdnpanel").val();
                 if (selectedPanel.length > 0)
                     $('#<%= lstPanellist.ClientID%>').multipleSelect("setSelects", selectedPanel.split(','));
           }
        }
        function OnfailureCallback2(error) {
        }
        
    </script> 
    <script type="text/javascript">
        $('[id*=lstPanellist],[id*=lstStateList],[id*=ddlBusinessZone],[id*=lstCenterList],[id*=ddlcentretype]').multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });

        var addSerialNumber = function (container) {            
            $('#' + container + ' >tbody > tr').each(function (index) {               
                var num = index + 1;               
                $(this).find('.srno').html(num-1);
                
            });
        };
    </script>


  <%--  Durga--%>
    <script type="text/javascript">

        function showcentre()
        {
            if ($('#<%=chall.ClientID%>').is(":checked")) {
                $('#centretag').hide();
            }
            else {
                $('#centretag').show();
            }
        }

        function getdata() {
            if ($('#<%=ddlname.ClientID%>').val() == "0") {
                alert("Please Select Dicount Type");
                $('#<%=ddlname.ClientID%>').focus();
                return;
            }
            var checked_radio = $("[id*=rd] input:checked");
            var value = checked_radio.val();

            $.ajax({
                type: "POST",
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                url: "DiscountMaster.aspx/getcompletedata",
                data: '{"DicountID":"' + $('#<%=ddlname.ClientID%>').val() + '",type:"' + value + '"}',//
                success: function (result) {
                    PatientDataGross = $.parseJSON(result.d);
                    if (PatientDataGross == "1") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {
                        alert("No Data Found");
                    }
                  
                },
                error: function () { alert('error'); } // some error
            });
        }
    </script>
</asp:Content>

