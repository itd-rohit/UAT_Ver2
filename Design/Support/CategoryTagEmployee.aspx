<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master"   EnableEventValidation="true" AutoEventWireup="true" CodeFile="CategoryTagEmployee.aspx.cs" Inherits="Design_Support_CategoryTagEmployee" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     
  
   
   
 
  <style type="text/css" >
      .hide {
          display: none;
      }

      .multiselect {
          width: 100%;
      }

      .GridViewLabItemStyle {
          border: solid 1px #C6DFF9;
          padding-left: 3px;
          font-size: 8.0pt;
          height: 35px;
          background-color: #fff;
      }

      .GridViewHeaderStyle {
          height: 30px;
      }

      .level {
          background: #dbf786;
          font-size: 12px;
          padding: 6px;
          border-radius: 10px;
      }

          
  </style>

    <div id="Pbody_box_inventory" >
       <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="false"   EnablePageMethods="true">  

</Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:HiddenField ID="hdncategoryID" runat="server" />
                <b>Customer Care Employee </b>
                
          
        </div>
       <div class="POuter_Box_Inventory" >
             <div class="row">
                <div class="col-md-8">
                </div>
                <div class="col-md-3">
                      <label class="pull-left">Enquiry Categoty  </label>
                    <b class="pull-right">:</b>
                   
                </div>
                 <div class="col-md-8">
                     <asp:Label ID="lblCategory" runat="server" Text=""  style="font-size:large;font:bold"></asp:Label>
                           <asp:Label ID="lblSubCategoryID" runat="server" Text="" style="display:none"></asp:Label>
                </div>

                  </div>

              
           </div>



        <div class="POuter_Box_Inventory" >   
            
            <div class="row" style="display:none">
                <div class="col-md-3">
                                   <input id="btnMoreFilter" type="button" onclick="moreFilterSearch()" value="More Filter" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer" />

                </div>
                <div class="col-md-3 MoreFilter" style="display:none">
                    CentreType
                    </div>
               
             <div class="col-md-3">
                            <asp:ListBox ID="lstCentreType" runat="server"   CssClass="multiselect"   SelectionMode="Multiple" ></asp:ListBox>
                 </div>   

                 <div class="col-md-3 MoreFilter" style="display:none">
                    Zone
                    </div>
                  <div class="col-md-3">
                     <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" runat="server"   onchange="bindState()"></asp:ListBox>

                      </div>
                 <div class="col-md-3 MoreFilter" style="display:none">
                    State
                    </div>
                  <div class="col-md-3">
                                                  <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server"  ></asp:ListBox>

                 </div>
                 <div class="col-md-3 MoreFilter" style="display:none">
                                                                     <input id="btnsearch" type="button" value="Search" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer" />

                     </div>
                  </div>
                <div class="row" >
                <div class="col-md-3">
                     <label class="pull-left">Set Default Employee</label>
                    <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                     <label class="pull-left">Level 1</label>
                    <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-5" id="defaultlevel1" onclick="defaultOpenPopup('Level1')" style="background: #fff;height: 26px; border: 1px solid #ccc;">
                         </div>

                     <div class="col-md-2">
                     <label class="pull-left">Level 2</label>
                    <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-5" id="defaultlevel2" onclick="defaultOpenPopup('Level2')" style="background: #fff;height: 26px; border: 1px solid #ccc;">
                     </div>
                     <div class="col-md-2">
                     <label class="pull-left">Level 3</label>
                    <b class="pull-right">:</b>
                    </div>

                     <div class="col-md-5" id="defaultlevel3" onclick="defaultOpenPopup('Level3')" style="background: #fff;height: 26px; border: 1px solid #ccc;">
                     </div>
                     </div>
              
        </div>
        <div class="POuter_Box_Inventory" >
          <div id="divCenterSearchOutput"  style="text-align:center; height:460px;overflow-y:scroll; ">
                
            </div>
     </div> 
 </div>
        <script id="tb_centerList" type="text/html">  
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tbl_centerList" width="99%" >
		<tr>
			<th class="GridViewHeaderStyle" style="width:50px;" >S.No.</th>
            <th class="GridViewHeaderStyle" style="width:300px; text-align:left;" >Centre Name</th>
            <th class="GridViewHeaderStyle" style="width:300px;">Level1</th>
			<th class="GridViewHeaderStyle" style="width:300px;">Level2</th>
            <th class="GridViewHeaderStyle" style="width:300px;">Level3</th> 
         </tr>
       <#
              var dataLength=PatientData.length;           
              var objRow;            
        for(var j=0;j<dataLength;j++)
        { 
        objRow = PatientData[j];             
            #>
<tr>
    <td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.Centre#></td>

      
<td class="GridViewLabItemStyle" onclick="OpenPopup('Level1','<#=objRow.Level1ID#>','<#=objRow.CentreID#>')">   
    <# if(objRow.Level1ID!='' && objRow.Level1ID!=null)
    {
      
 for(var k=0;k<objRow.Level1ID.split(',').length;k++)
  {#>
 <span  id="Level1@<#=objRow.CentreID#>@<#=objRow.Level1ID.split(',')[k]#>" class="level"><#=objRow.Level1.split(',')[k]#></span>
 <#}
     
     }#> 
     </td>                
  

    
    
   
<td class="GridViewLabItemStyle"  onclick="OpenPopup('Level2','<#=objRow.Level2ID#>','<#=objRow.CentreID#>')">
    <# if(objRow.Level2ID!='' && objRow.Level2ID!=null){

     for(var k=0;k<objRow.Level2ID.split(',').length;k++)
        {#>
          <span  id="Level2@<#=objRow.CentreID#>@<#=objRow.Level2ID.split(',')[k]#>" class="level"><#=objRow.Level2.split(',')[k]#></span>      
    <#} }#> </td>                
 


    

    <td class="GridViewLabItemStyle" onclick="OpenPopup('Level3','<#=objRow.Level3ID#>','<#=objRow.CentreID#>')">
        <# if(objRow.Level3ID!='' && objRow.Level3ID!=null){

    for(var k=0;k<objRow.Level3ID.split(',').length;k++)
        {#>
          <span  id="Level3@<#=objRow.CentreID#>@<#=objRow.Level3ID.split(',')[k]#>" class="level"><#=objRow.Level3.split(',')[k]#></span>       
      <#} }#>
   
    </td>

   
</tr>
          
            <#}#>

</table> 
             
           
    </script>
 
   

     <asp:Panel ID="paneldata" runat="server" BackColor="#EAF3FD" BorderStyle="None" style="display:none;z-index:99999; border:1px solid #000;width:64%" >
        <div class="Purchaseheader">
               <div class="row">
                    <div class="col-md-6">
                    <label class="pull-left">Tag Employee at    </label>
                    <b class="pull-right">:</b>
                </div>
                   <div class="col-md-16">
                       <span id="lblLable"></span>
                       </div>
                    <div class="col-md-2" style="text-align:right">
                          <img id="btnclosepopup" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="closePopUp()" /> 
                   </div>
        
      </div> </div>
         
             <div class="row">
                  <div class="col-md-24" style="text-align:center">
                       <asp:Label ID="lblPopUpError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                      </div>
                 </div>
               <div class="row">
              
                <div class="col-md-3">
                    <label class="pull-left">Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10">
                    <asp:TextBox ID="txtName" runat="server"    CssClass="autocomplete" />
                                            <input type="hidden" id="hdnempid" />
                                            <input type="hidden" id="hdEnquiryID" />   
</div>
                   <div class="col-md-3 hide">
                    <label class="pull-left">Reopen Ticket   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 hide">
                     <asp:CheckBox ID="chkReopenTicket" runat="server"  />
                   </div>
                    </div>

               <div class="row">
              
                <div class="col-md-3">
                    <label class="pull-left">Mobile No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                     <asp:TextBox ID="txtMobile" runat="server"  AutoCompleteType="Disabled"  MaxLength="10" onkeyup="showlength()" disabled   ></asp:TextBox></div>
                   <div class="col-md-3"><a href="#" id="editmobile" onclick="EditMode(this,'txtMobile')">Edit</a>
                                           <a href="#" id="mobilecancel" onclick="CancelMode(this,'txtMobile')" style="display:none;">Cancel</a>
                                           <input type="hidden" id="IsEditMobile" value="0" />
                                            <input type="hidden" id="oldmobile" value="" />
                             </div> <div class="col-md-1"><span id="molen" style="font-weight:bold;"></span>
                            <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobile" >
                            </cc1:FilteredTextBoxExtender>
                     </div>

                     <div class="col-md-3">
                    <label class="pull-left">Email ID   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                     <asp:TextBox  ID="txtemail" runat="server"   AutoCompleteType="Disabled" MaxLength="50" onkeypress="this.value = this.value.toLowerCase();" disabled   ></asp:TextBox></div>
                   <div class="col-md-2"><a href="#" id="editemail" onclick="EditMode(this,'txtemail')">Edit</a><a href="#" id="emailcancel" onclick="CancelMode(this,'txtemail')" style="display:none;">Cancel</a>
                                       <input type="hidden" id="IsEditEmail" value="0" />
                                            <input type="hidden" id="oldemail" value="" />

                    </div>

 </div>

                   


              <div class="row" style="display:none;">
              
                <div class="col-md-3">
                    <label class="pull-left">Zone   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:ListBox ID="ddlZone" CssClass="multiselect" SelectionMode="Multiple" runat="server"   onchange="bindEmpState()"></asp:ListBox>                                                                        

                    </div>

                   <div class="col-md-3">
                    <label class="pull-left">State   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="ddlState" CssClass="multiselect" SelectionMode="Multiple"  runat="server"  onchange="bindEmpCity()"></asp:ListBox>

                    </div>
                  </div>
              <div class="row" >
              
                <div class="col-md-3">
                    <label class="pull-left">Centre   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                      <asp:ListBox ID="ddlCentre" CssClass="multiselect" SelectionMode="Multiple"  runat="server" ></asp:ListBox>

                    </div>

                    <div class="col-md-3">
                    <label class="pull-left">   </label>
                    <b class="pull-right"></b>
                </div>
               
                  </div>
         <div class="row" style="display:none;">
             <div class="col-md-3">
                    <label class="pull-left">City   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
              <asp:ListBox ID="ddlCity" CssClass="multiselect" SelectionMode="Multiple"  runat="server"  onchange="bindEmpCenter()" ></asp:ListBox>
         </div>
             </div>
              <div class="row hide" >
              
                <div class="col-md-3 hideCCLevel2">
                    <label class="pull-left">Email(Cc) Level2   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 hideCCLevel2">
                    <asp:CheckBox ID="chkEmailCCLevel2" runat="server"  />

                     </div>
                  <div class="col-md-3 hideCCLevel3">
                    <label class="pull-left">Email(Cc) Level3   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 hideCCLevel3">
                    <asp:CheckBox ID="chkEmailCCLevel3" runat="server" /> 
                    </div>
                   </div>

            
             
                               
            
             <div class="row" style="text-align:center;">
          
                 <input type="button" class="searchbutton" onclick="Save()" id="btnsave" value="Save"/>
             
              <input type="button" class="searchbutton" onclick="AddNew()" id="btnAddNew" value="Clear"/>
                  </div>
                  
         <div class="row" style="text-align:center;">
               <div id="div_empDetail"></div> 
             </div>

           <div id="empautolist"></div>         
                     
    </asp:Panel>
    <asp:Button ID="Button1" runat="server" style="display:none;" />
  <cc1:modalpopupextender ID="modelpopup" runat="server" CancelControlID="btnclosepopup" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="paneldata">
    </cc1:modalpopupextender>

     <script id="sc_EmpDetail" type="text/html">  
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tbl_EmpDetail" width="99%" >
		<tr id="EmpHeader">
			
            <th class="GridViewHeaderStyle" style="width:300px; text-align:left;" >Employee Name</th>
            <th class="GridViewHeaderStyle" style="width:100px;">Mobile No.</th>
			<th class="GridViewHeaderStyle" style="width:140px;">Email ID </th>
            <th class="GridViewHeaderStyle" style="width:30px;">Edit</th> 
            <th class="GridViewHeaderStyle" style="width:30px;">Remove</th> 
         </tr>
       <#
              var dataLength=empData.length;           
              var objRow;            
        for(var j=0;j<dataLength;j++)
        { 
        objRow = empData[j];             
            #>
<tr>
    
    <td class="GridViewLabItemStyle" id="tdEmpName" style="text-align:left;"><#=objRow.EmpName#></td>
    <td class="GridViewLabItemStyle" id="tdMobile" style="text-align:left;"><#=objRow.Mobile#></td>
    <td class="GridViewLabItemStyle" id="tdEmail" style="text-align:left;"><#=objRow.Email#></td>
    <td class="GridViewLabItemStyle" id="tdEmployee_ID" style="text-align:left;display:none"><#=objRow.Employee_ID#></td>

    <td class="GridViewLabItemStyle" id="tdID" style="text-align:left;display:none"><#=objRow.ID#></td>
        
    <td class="GridViewLabItemStyle" id="tdStateID" style="text-align:left;display:none"><#=objRow.StateID#></td>
    <td class="GridViewLabItemStyle" id="tdCityID" style="text-align:left;display:none"><#=objRow.CityID#></td>
    <td class="GridViewLabItemStyle" id="tdBusinessZoneID" style="text-align:left;display:none"><#=objRow.BusinessZoneID#></td>
    <td class="GridViewLabItemStyle" id="tdCentreID" style="text-align:left;display:none"><#=objRow.CentreID#></td>

        <td class="GridViewLabItemStyle" id="tdReopenTicket" style="text-align:left;display:none"><#=objRow.ReopenTicket#></td>
    <td class="GridViewLabItemStyle" id="tdEmailCCLevel2" style="text-align:left;display:none"><#=objRow.EmailCCLevel2#></td>
    <td class="GridViewLabItemStyle" id="tdEmailCCLevel3" style="text-align:left;display:none"><#=objRow.EmailCCLevel3#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;">
        <img src="../../App_Images/edit.png" style="cursor:pointer" onclick="empEdit(this)" /></td>
 <td class="GridViewLabItemStyle" style="text-align:left;">
        <img src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="empRemove(this)" /></td>
</tr>
          
            <#}#>

        </table> 
             
           
    </script>



      <asp:Panel ID="defaultpaneldata" runat="server" BackColor="#EAF3FD" BorderStyle="None" style="display:none;z-index:99999; border:1px solid #000;width:64%" >
        <div class="Purchaseheader">

             <div class="row">
                 <div class="col-md-6">
                    <label class="pull-left">Tag Employee at   </label>
                    <b class="pull-right">:</b>
                </div>
                  <div class="col-md-16">
                      <span id="defaultlblLable"></span>
                      </div>
                  <div class="col-md-2" style="text-align:right">
                       <img id="defaultbtnclosepopup" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="defaultclosePopUp()" />  
</div>
                 </div>
        
      </div>
        
               <div class="row">
                 <div class="col-md-24" style="text-align:center">
                      <asp:Label ID="defaultlblPopUpError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                     </div>
                   </div>
              <div class="row">
                  <div class="col-md-3">
                    <label class="pull-left">Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-10">
                     <asp:TextBox ID="defaulttxtName" runat="server"   />
                                            <input type="hidden" id="defaulthdnempid" />
                                            <input type="hidden" id="defaulthdEnquiryID" />  

                     </div>
                  <div class="col-md-3 hide">
                       <label class="pull-left">Reopen Ticket    </label>
                    <b class="pull-right">:</b>
                      </div>
                  <div class="col-md-5 hide">
                   <asp:CheckBox ID="defaultchkReopenTicket" runat="server"  />
                   </div>
                  </div>
              <div class="row">
                  <div class="col-md-3">
                    <label class="pull-left">Mobile No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                     <asp:TextBox ID="defaulttxtMobile" runat="server"  AutoCompleteType="Disabled"  MaxLength="10" onkeyup="defaultshowlength()" disabled   ></asp:TextBox> </div> <div class="col-md-3"><a href="#" id="defaulteditmobile" onclick="defaultEditMode(this,'defaulttxtMobile')">Edit</a>
                                           <a href="#" id="defaultmobilecancel" onclick="defaultCancelMode(this,'defaulttxtMobile')" style="display:none;">Cancel</a>
                                           <input type="hidden" id="defaultIsEditMobile" value="0" />
                                            <input type="hidden" id="defaultoldmobile" value="" />
                            </div> <div class="col-md-1"><span id="defaultmolen" style="font-weight:bold;"></span>
                            <cc1:FilteredTextBoxExtender ID="defaultfltMobile" runat="server" FilterType="Numbers" TargetControlID="defaulttxtMobile" >
                            </cc1:FilteredTextBoxExtender>

                    </div>
                  <div class="col-md-3">
                    <label class="pull-left">Email ID   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                     <asp:TextBox  ID="defaulttxtemail" runat="server"  AutoCompleteType="Disabled" MaxLength="50" onkeypress="this.value = this.value.toLowerCase();" disabled   ></asp:TextBox></div> <div class="col-md-2"><a href="#" id="defaulteditemail" onclick="defaultEditMode(this,'defaulttxtemail')">Edit</a><a href="#" id="defaultemailcancel" onclick="defaultCancelMode(this,'defaulttxtemail')" style="display:none;">Cancel</a>
                                       <input type="hidden" id="defaultIsEditEmail" value="0" />
                                            <input type="hidden" id="defaultoldemail" value="" />

                  </div>
                   </div>
             <div class="row hide">
                  <div class="col-md-3 defaulthideCCLevel2">
                    <label class="pull-left">Email(Cc) Level2</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3 defaulthideCCLevel2">
                     <asp:CheckBox ID="defaultchkEmailCCLevel2" runat="server"  />
 </div>
                 <div class="col-md-3 defaulthideCCLevel3">
                    <label class="pull-left">Email(Cc) Level3</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3 defaulthideCCLevel3">
                    <asp:CheckBox ID="defaultchkEmailCCLevel3" runat="server"  /> 
                     </div>
                  </div>
             
             
             <div class="row" style="text-align:center;">

                
         
                 <input type="button" class="searchbutton" onclick="defaultSave()" id="defaultbtnsave" value="Save"/>
             
              <input type="button" class="searchbutton" onclick="defaultAddNew()" id="defaultbtnAddNew" value="Clear"/>
                  </div>
                  
        <div class="row" style="text-align:center;">
               <div id="defaultdiv_empDetail" style="overflow-y: scroll;max-height: 263px;"></div> 
             </div>

           <div id="defaultempautolist"></div>         
                     
    </asp:Panel>
    <asp:Button ID="defaultButton1" runat="server" style="display:none;" />
  <cc1:modalpopupextender ID="defaultmodelpopup" runat="server" CancelControlID="defaultbtnclosepopup" TargetControlID="defaultButton1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="defaultpaneldata">
    </cc1:modalpopupextender>



      <script id="defaultsc_EmpDetail" type="text/html">  
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="defaulttbl_EmpDetail" width="99%" >
		<tr id="defaultEmpHeader">
			
            <th class="GridViewHeaderStyle" style="width:300px; text-align:left;" >Employee Name</th>
            <th class="GridViewHeaderStyle" style="width:100px;">Mobile No.</th>
			<th class="GridViewHeaderStyle" style="width:140px;">Email ID </th>
            <th class="GridViewHeaderStyle" style="width:30px;">Edit</th> 
            <th class="GridViewHeaderStyle" style="width:30px;">Remove</th> 
         </tr>
       <#
              var dataLength=empData.length;           
              var objRow;            
        for(var j=0;j<dataLength;j++)
        { 
        objRow = empData[j];             
            #>
<tr>
    
    <td class="GridViewLabItemStyle" id="defaulttdEmpName" style="text-align:left;"><#=objRow.EmpName#></td>
    <td class="GridViewLabItemStyle" id="defaulttdMobile" style="text-align:left;"><#=objRow.Mobile#></td>
    <td class="GridViewLabItemStyle" id="defaulttdEmail" style="text-align:left;"><#=objRow.Email#></td>
    <td class="GridViewLabItemStyle" id="defaulttdEmployee_ID" style="text-align:left;display:none"><#=objRow.Employee_ID#></td>
    <td class="GridViewLabItemStyle" id="defaulttdID" style="text-align:left;display:none"><#=objRow.ID#></td>        
   
    <td class="GridViewLabItemStyle" id="defaulttdReopenTicket" style="text-align:left;display:none"><#=objRow.ReopenTicket#></td>
    <td class="GridViewLabItemStyle" id="defaulttdEmailCCLevel2" style="text-align:left;display:none"><#=objRow.EmailCCLevel2#></td>
    <td class="GridViewLabItemStyle" id="defaulttdEmailCCLevel3" style="text-align:left;display:none"><#=objRow.EmailCCLevel3#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;">
        <img src="../../App_Images/edit.png" style="cursor:pointer" onclick="defaultempEdit(this)" /></td>
 <td class="GridViewLabItemStyle" style="text-align:left;">
        <img src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="defaultempRemove(this)" /></td>
</tr>
          
            <#}#>

</table> 
             
           
    </script>



    <script type="text/javascript">
        var EmpList = [];
        var defaultEmpList = [];
        function closePopUp() {
            EmpList = [];
            $find("<%=modelpopup.ClientID%>").hide();

            jQuery("#btnsave").val('Save');
        }
        function moreFilterSearch() {
            if (jQuery("#btnMoreFilter").val() == "More Filter") {
                jQuery("#btnMoreFilter").val("Hide Filter");
                jQuery(".MoreFilter").show();
                jQuery("#lstCentreType,#lstZone,#lstState").next().show();
                if (jQuery("#lstCentreType option").length == 0)
                    bindcenter();
                if (jQuery("#lstZone option").length == 0)
                    bindZone();

            }
            else {
                jQuery("#btnMoreFilter").val("More Filter");
                jQuery(".MoreFilter").hide();
                jQuery("#lstCentreType,#lstZone,#lstState").next().hide();
            }
            jQuery('#lstCentreType').multipleSelect("uncheckAll");
            jQuery('#lstCentreType').multipleSelect("refresh");
            jQuery('#lstZone').multipleSelect("uncheckAll");
            jQuery('#lstZone').multipleSelect("refresh");
            jQuery("#lstState option").remove();
            jQuery('#lstState').multipleSelect("refresh");
        }
        var EZoneID = 0;
        var EStateID = 0;
        var ECityID = 0;
        var ECenterID = 0;
        jQuery(function () {


            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                //  jQuery(selector).chosen(config[selector]);
            }
            jQuery('[id*=lstZone],[id*=ddlZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstState],[id*=ddlState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=ddlCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery("#lstCentreType,#lstZone,#lstState").next().hide();
            jQuery(".MoreFilter").hide();
            BindData();
            defaultBindData();
            jQuery("#btnsearch").click(function () {
                BindData();
                defaultBindData();
            });

        });

    </script>

    <script type="text/javascript">
        function bindcenter() {
            serverCall('CategoryTagEmployee.aspx/bindCenterType', {  }, function (response) {
                jQuery('#<%=lstCentreType.ClientID%>').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: jQuery('#<%=lstCentreType.ClientID%>') });
            });          
        }
        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#<%=lstZone.ClientID%>').multipleSelect("refresh");
            serverCall('CategoryTagEmployee.aspx/bindBusinessZone', {}, function (response) {
                jQuery('#<%=lstZone.ClientID%>').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: jQuery('#<%=lstZone.ClientID%>') });
            });          
        }
        function bindState() {
            jQuery("#<%=lstState.ClientID%> option").remove();
            jQuery('#<%=lstState.ClientID%>').multipleSelect("refresh");
            if (jQuery("#<%=lstZone.ClientID%>").val() != "") {
                serverCall('CategoryTagEmployee.aspx/bindState', {BusinessZoneID:  jQuery("#<%=lstZone.ClientID%>").val() }, function (response) {
                    jQuery('#<%=lstState.ClientID%>').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: jQuery('#<%=lstState.ClientID%>') });
                });               
            }
        }
    </script>
    <script type="text/javascript">
        function bindEmpZone() {
            jQuery('#ddlZone option').remove();
            jQuery('#ddlZone').multipleSelect("refresh");
            serverCall('CategoryTagEmployee.aspx/bindBusinessZone', { }, function (response) {
                jQuery('#<%=ddlZone.ClientID%>').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: jQuery('#<%=ddlZone.ClientID%>') });
                if (EZoneID == 0) {
                    jQuery('#ddlZone').multipleSelect("setSelects", jQuery("#lstZone").val());
                }
                else {
                    var dataarray = EZoneID.split(",");
                    jQuery('#ddlZone').multipleSelect("setSelects", dataarray);
                }
            });          
        }
        function bindEmpState() {
            jQuery("#<%=ddlState.ClientID%> option").remove();
            jQuery('#<%=ddlState.ClientID%>').multipleSelect("refresh");
            if (jQuery("#<%=ddlZone.ClientID%>").val() != "") {
                serverCall('CategoryTagEmployee.aspx/bindState', { BusinessZoneID: jQuery("#<%=ddlZone.ClientID%>").val().toString() }, function (response) {
                    jQuery('#<%=ddlState.ClientID%>').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: jQuery('#<%=ddlState.ClientID%>') });
                    if (EStateID == 0) {
                        $('#<%=ddlState.ClientID%>').multipleSelect("setSelects", jQuery("#lstState").val());
                    }
                    else {
                        var dataarray = EStateID.split(",");
                        $('#<%=ddlState.ClientID%>').multipleSelect("setSelects", dataarray);
                    }
                });
            }

        }
        function bindEmpCity() {
            jQuery('#ddlCity option').remove();
            jQuery('#ddlCity').multipleSelect("refresh");

            serverCall('CategoryTagEmployee.aspx/bindCity', { StateID: jQuery("#<%=ddlState.ClientID%>").val().toString() }, function (response) {
                jQuery('#<%=ddlCity.ClientID%>').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'City', controlID: jQuery('#<%=ddlCity.ClientID%>') });
                if (ECityID != 0) {
                    var dataarray = ECityID.split(",");
                    jQuery('#<%=ddlCity.ClientID%>').multipleSelect("setSelects", dataarray);
                    }
            });

            
        }
        function bindEmpCenter() {
            jQuery('#<%=ddlCentre.ClientID%> option').remove();
            jQuery('#<%=ddlCentre.ClientID%>').multipleSelect("refresh");
          
            var CityID = jQuery("#<%=ddlCity.ClientID%>").val().toString();
           
            var BusinessZoneID = jQuery("#<%=ddlZone.ClientID%>").val().toString();
           
            serverCall('CategoryTagEmployee.aspx/bindCentre', { CityID: CityID, BusinessZoneID: BusinessZoneID }, function (response) {
                jQuery('#<%=ddlCentre.ClientID%>').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: jQuery('#<%=ddlCentre.ClientID%>') });
                if (ECenterID != 0) {
                    var dataarray = ECenterID.split(",");
                    $('#<%=ddlCentre.ClientID%>').multipleSelect("setSelects", dataarray);
                }

            });

            
        }

    </script>

    <script type="text/javascript">
        function BindData() {
            var CentreID = "";
            var StateID = "";
            CentreID = $('#<%=lstCentreType.ClientID%>').val().toString();
            StateID = $('#<%=lstState.ClientID%>').val().toString();
            serverCall('CategoryTagEmployee.aspx/BindData', { CentrTypeId: CentreID, StateId: StateID, SubCategoryID: jQuery('#<%=lblSubCategoryID.ClientID%>').text() }, function (response) {
                PatientData = $.parseJSON(response);
                if (PatientData.length == 0) {
                    jQuery('#divCenterSearchOutput').empty();
                    return;
                }
                var output = jQuery('#tb_centerList').parseTemplate(PatientData);
                jQuery('#divCenterSearchOutput').html(output);
            });         
        }
    </script>

    <script type="text/javascript">
        function OpenPopup(level, EmpID, CenterID) {
            cleare();
            bindEmpCenter();
            jQuery('#lblLable').html(level);
            $find("<%=modelpopup.ClientID%>").show();
            jQuery('#molen').html('0');
            
           
            
            if (EmpID != "") {
                BindEmpDetail(CenterID, level);

            }
            if (level == "Level1") {
                jQuery(".hideCCLevel2,.hideCCLevel3").show();
            }
            else if (level == "Level2") {
                jQuery(".hideCCLevel2").hide();
                jQuery(".hideCCLevel3").show();
            }
            else if (level == "Level3") {
                jQuery(".hideCCLevel2,.hideCCLevel3").hide();
            }
            jQuery("#<%=chkEmailCCLevel2.ClientID%>,#<%=chkEmailCCLevel3.ClientID%>,#<%=chkReopenTicket.ClientID%>").prop('checked', false);
            
        }


        $(function () {
            $("#<%=txtName.ClientID%>").autocomplete({
                source: function (request, response) {
                    serverCall('CategoryTagEmployee.aspx/SearchEmployee', { query: $("#<%=txtName.ClientID%>").val(), EmpList: EmpList.toString() }, function (result) {
                        var resultStatus = $.parseJSON(result);
                        response(resultStatus);
                    },'',false);

                    
                },
                focus: function () {
                    return false;
                },
                select: function (event, ui) {

                    $("#hdnempid").val(ui.item.value);
                    $("#<%=txtName.ClientID%>").val(ui.item.label);
                    $("#<%=txtMobile.ClientID%>").val(ui.item.Mobile);
                    if (ui.item.Mobile == "" || ui.item.Mobile == "0") {
                        $('#<%=txtMobile.ClientID%>').removeAttr("disabled");
                        $("#IsEditMobile").val("1");
                        $("#editmobile").hide();
                    }
                    else {
                        $('#<%=txtMobile.ClientID%>').attr("disabled", "disabled");
                        $("#IsEditMobile").val("0");
                        $("#editmobile").show();
                    }

                    $("#<%=txtemail.ClientID%>").val(ui.item.Email);
                    if (ui.item.Email == "" || ui.item.Email == "0") {
                        $('#<%=txtemail.ClientID%>').removeAttr("disabled");
                        $("#IsEditEmail").val("1");
                        $("#editemail").hide();
                    }
                    else {
                        $('#<%=txtemail.ClientID%>').attr("disabled", "disabled");
                        $("#IsEditEmail").val("0");
                        $("#editemail").show();
                    }
                    return false;
                },
                appendTo: "#empautolist"

            });
        });
    </script>

    <script type="text/javascript">
        function Save() {
            if ($("#<%=txtName.ClientID%>").val() == "") {
                toast("Error", "Please Enter Name");
                $("#<%=txtName.ClientID%>").focus();
                return;
            }
            if ($("#<%=txtMobile.ClientID%>").val() == "") {
                toast("Error", "Please Enter Mobile");
                $("#<%=txtMobile.ClientID%>").focus();
                return;
            }

            if ($("#<%=txtMobile.ClientID%>").val().length != 10) {
                if ($('#<%=txtMobile.ClientID%>').attr("disabled")) {
                    $('#<%=txtMobile.ClientID%>').removeAttr("disabled");
                    $("#oldmobile").val($('#<%=txtMobile.ClientID%>').val());
                    $("#IsEditMobile").val("1");
                    $("#editmobile").hide();
                    $("#mobilecancel").show();
                }
                toast("Error", "Please Enter Valid Mobile No.");
                $("#<%=txtMobile.ClientID%>").focus();
                return;
            }

            if ($("#<%=txtemail.ClientID%>").val() == "") {
                toast("Error", "Please Enter Email");
                $("#<%=txtemail.ClientID%>").focus();
                return;
            }

            if (!isValidEmailAddress($("#<%=txtemail.ClientID%>").val())) {
                if ($('#<%=txtemail.ClientID%>').attr("disabled")) {
                    $('#<%=txtemail.ClientID%>').removeAttr("disabled");
                    $("#oldemail").val($('#<%=txtemail.ClientID%>').val());
                    $("#IsEditEmail").val("1");
                    $("#editemail").hide();
                    $("#emailcancel").show();
                }
                toast("Error", "Please Enter Vaild Email Address.");
                $("#<%=txtemail.ClientID%>").focus();
                return;
            }

            if ($("#<%=ddlCentre.ClientID%>").val() == null || $("#<%=ddlCentre.ClientID%>").val()=="") {
                toast("Error", "Please Select Centre");
                $("#<%=ddlCentre.ClientID%>").focus();
                return;
            }
            


            $('#btnsave').attr('disabled', 'disabled').val('Submiting...');

            var emp = new Object();
            emp.EmpID = jQuery("#hdnempid").val();
            emp.Name = '';
            emp.Email = jQuery("#<%=txtemail.ClientID%>").val();
            emp.Mobile = jQuery("#<%=txtMobile.ClientID%>").val();
            emp.CenterID = jQuery("#<%=ddlCentre.ClientID%>").val().toString();
            emp.Lavel = jQuery('#lblLable').text();
            emp.SubCategoryID = jQuery("#<%=hdncategoryID.ClientID%>").val();
            emp.IsEditMobile = jQuery("#IsEditMobile").val();
            emp.IsEditEmail = jQuery("#IsEditEmail").val();
            emp.EnquiryID = jQuery("#hdEnquiryID").val();
            emp.ReopenTicket = jQuery("#<%=chkReopenTicket.ClientID%>").is(':checked') ? 1 : 0;
            emp.EmailCCLevel2 = jQuery("#<%=chkEmailCCLevel2.ClientID%>").is(':checked') ? 1 : 0;
            emp.EmailCCLevel3 = jQuery("#<%=chkEmailCCLevel3.ClientID%>").is(':checked') ? 1 : 0;

            serverCall('CategoryTagEmployee.aspx/Save', { obj: emp, CenterID: jQuery("#<%=ddlCentre.ClientID%>").val().toString() }, function (response) {
                jQuery('#btnsave').removeAttr('disabled').val('Save');
                cleare();
                $find("<%=modelpopup.ClientID%>").hide();
                    BindData();
                    toast("Success", "Record Saved Successfully ");
            });

            
        }
        function cleare() {
            jQuery("#hdnempid").val('');
            jQuery("#<%=txtName.ClientID%>,#<%=txtMobile.ClientID%>,#<%=txtemail.ClientID%>").val('');
            jQuery('#ddlZone option').remove();
            jQuery('#ddlZone').multipleSelect("refresh");
            jQuery('#ddlState option').remove();
            jQuery('#ddlState').multipleSelect("refresh");
            jQuery('#ddlCity option').remove();
            jQuery('#ddlCity').multipleSelect("refresh");
            jQuery('#ddlCentre option').remove();
            jQuery('#ddlCentre').multipleSelect("refresh");
            EZoneID = 0;
            EStateID = 0;
            ECityID = 0;
            ECenterID = 0;
            jQuery("#hdEnquiryID").val('');
            jQuery('#mobilecancel,#emailcancel,#div_empDetail').hide()
            EmpList = [];
            jQuery('#div_empDetail').html('');
            jQuery("#lblPopUpError").text('');
            jQuery("#<%=chkReopenTicket.ClientID%>,#<%=chkEmailCCLevel2.ClientID%>,#<%=chkEmailCCLevel3.ClientID%>").prop('checked', false);
        }

        function EditMode(e, ctrl) {

            if (ctrl == "txtMobile") {
                $('#<%=txtMobile.ClientID%>').removeAttr("disabled");
                $("#oldmobile").val($('#<%=txtMobile.ClientID%>').val());
                $("#IsEditMobile").val("1");
                $('#mobilecancel').show();
                $('#editmobile').hide();
            }
            if (ctrl == "txtemail") {
                $('#<%=txtemail.ClientID%>').removeAttr("disabled");
                $("#oldemail").val($('#<%=txtemail.ClientID%>').val());
                $("#IsEditEmail").val("1");
                $('#emailcancel').show();
                $('#editemail').hide();
            }


        }

        function CancelMode(e, ctrl) {
            if (ctrl == "txtMobile") {
                $('#<%=txtMobile.ClientID%>').attr("disabled", "disabled");
                $('#<%=txtMobile.ClientID%>').val($("#oldmobile").val());
                $("#IsEditMobile").val("0");
                $('#mobilecancel').hide();
                $('#editmobile').show();
            }
            if (ctrl == "txtemail") {
                $('#<%=txtemail.ClientID%>').attr("disabled", "disabled");
                 $('#<%=txtemail.ClientID%>').val($("#oldemail").val());
                 $("#IsEditEmail").val("0");
                 $('#emailcancel').hide();
                 $('#editemail').show();
             }
         }

         function showlength() {
             if (jQuery('#<%=txtMobile.ClientID%>').val() != "")
                jQuery('#molen').html($('#<%=txtMobile.ClientID%>').val().length);
            else
                jQuery('#molen').html('');
        }


    </script>
    <script type="text/javascript">
        function AddNew() {
            jQuery("#<%=txtName.ClientID%>,#<%=txtMobile.ClientID%>,#<%=txtemail.ClientID%>").val('');
            jQuery("#<%=txtMobile.ClientID%>,#<%=txtemail.ClientID%>").removeAttr('disabled');
            jQuery("#lblPopUpError").text('');
            jQuery("#molen").text('0');
            jQuery('#btnsave').val('Save');
            jQuery('#hdEnquiryID').val('');
            jQuery("#<%=chkReopenTicket.ClientID%>,#<%=chkEmailCCLevel2.ClientID%>,#<%=chkEmailCCLevel3.ClientID%>").prop('checked', false);
        }
    </script>
      



    <script type="text/javascript">
        function empEdit(rowID) {
            jQuery("#hdnempid").val(jQuery(rowID).closest('tr').find("#tdEmployee_ID").text());
            jQuery("#<%=txtName.ClientID%>").val(jQuery(rowID).closest('tr').find("#tdEmpName").text());
            jQuery("#<%=txtemail.ClientID%>").val(jQuery(rowID).closest('tr').find("#tdEmail").text());
            jQuery("#<%=txtMobile.ClientID%>").val(jQuery(rowID).closest('tr').find("#tdMobile").text());
            if (jQuery(rowID).closest('tr').find("#tdReopenTicket").text() == 1)
                jQuery("#<%=chkReopenTicket.ClientID%>").prop('checked', 'checked');
            else
                jQuery("#<%=chkReopenTicket.ClientID%>").prop('checked', false);
            if (jQuery(rowID).closest('tr').find("#tdEmailCCLevel2").text() == 1)
                jQuery("#<%=chkEmailCCLevel2.ClientID%>").prop('checked', 'checked');
            else
                jQuery("#<%=chkEmailCCLevel2.ClientID%>").prop('checked', false);
            if (jQuery(rowID).closest('tr').find("#tdEmailCCLevel3").text() == 1)
                jQuery("#<%=chkEmailCCLevel3.ClientID%>").prop('checked', 'checked');
            else
                jQuery("#<%=chkEmailCCLevel3.ClientID%>").prop('checked', false);

            if (jQuery("#<%=txtMobile.ClientID%>").val() == "" || jQuery("#<%=txtMobile.ClientID%>").val() == "0") {
                jQuery('#<%=txtMobile.ClientID%>').removeAttr("disabled");
                jQuery("#IsEditMobile").val("1");
                jQuery("#editmobile").hide();
            }

            else {
                jQuery('#<%=txtMobile.ClientID%>').attr("disabled", "disabled");
                jQuery("#IsEditMobile").val("0");
                jQuery("#editmobile").show();
            }

            if (jQuery("#<%=txtemail.ClientID%>").val() == "" || jQuery("#<%=txtemail.ClientID%>").val() == "0") {
                jQuery('#<%=txtemail.ClientID%>').removeAttr("disabled");
                jQuery("#IsEditEmail").val("1");
                jQuery("#editemail").hide();
            }
            else {
                jQuery('#<%=txtemail.ClientID%>').attr("disabled", "disabled");
                jQuery("#IsEditEmail").val("0");
                jQuery("#editemail").show();
            }
            jQuery('#hdEnquiryID').val(jQuery(rowID).closest('tr').find("#tdID").text());
            //  jQuery('#hdnID').val(jQuery(rowID).closest('tr').find("#tdID").text());
            EZoneID = jQuery(rowID).closest('tr').find("#tdBusinessZoneID").text() + ",";
            EStateID = jQuery(rowID).closest('tr').find("#tdStateID").text() + ",";
            ECityID = jQuery(rowID).closest('tr').find("#tdCityID").text() + ",";
            ECenterID = jQuery(rowID).closest('tr').find("#tdCentreID").text() + ",";
            jQuery('#molen').html($('#<%=txtMobile.ClientID%>').val().length);
            var dataarray = ECenterID.split(",");
            $('#<%=ddlCentre.ClientID%>').multipleSelect("setSelects", dataarray);

            jQuery('#btnsave').val('Update');
        }
        function empRemove(rowID) {
            var ID = jQuery(rowID).closest('tr').find("#tdID").text();
            var Employee_ID = jQuery(rowID).closest('tr').find("#tdEmployee_ID").text();
            var CentreID = jQuery(rowID).closest('tr').find("#tdCentreID").text();

            serverCall('CategoryTagEmployee.aspx/removeTagEmployeeDetail', { ID: ID }, function (response) {
                if (response == "1") {
                    jQuery("#lblPopUpError").text('Removed Successfully');
                    jQuery(rowID).closest('tr').remove();
                    EmpList.splice($.inArray(Employee_ID, EmpList), 1);



                    var empHide = "".concat(jQuery("#lblLable").text(), '@', CentreID, '@', Employee_ID);
                    //console.log(empHide);


                    jQuery('span[id="' + empHide + '"]').text('').removeClass('level');


                }
                else {
                    jQuery("#lblPopUpError").text('Error..');
                }
            });

            
        }
        function BindEmpDetail(CentreID, Level) {
            serverCall('CategoryTagEmployee.aspx/BindTagEmployeeDetail', { CenterID: CentreID, Level: Level, SubCategoryID: $('#<%=lblSubCategoryID.ClientID%>').text() }, function (response) {
                empData = $.parseJSON(response);
                if (empData.length == 0) {
                    jQuery('#div_empDetail').empty();
                    return;
                }
                var output = jQuery('#sc_EmpDetail').parseTemplate(empData);
                jQuery('#div_empDetail').html(output);
                jQuery('#div_empDetail').show();
                jQuery('#tbl_EmpDetail tr').each(function () {
                    var id = $(this).attr("id");
                    if (id != "EmpHeader") {
                        EmpList.push($(this).find('#tdEmployee_ID').text());
                    }


                });
            });
           


        }
    </script>

    <script type="text/javascript">
        function defaultOpenPopup(level) {

            jQuery('#defaultlblLable').html(level);
            $find("<%=defaultmodelpopup.ClientID%>").show();
            jQuery('#defaultmolen').html('0');

            defaultBindEmpDetail(0, level);

            if (level == "Level1") {
                jQuery(".defaulthideCCLevel2,.defaulthideCCLevel3").show();
            }
            else if (level == "Level2") {
                jQuery(".defaulthideCCLevel2").hide();
                jQuery(".defaulthideCCLevel3").show();
            }
            else if (level == "Level3") {
                jQuery(".defaulthideCCLevel2,.defaulthideCCLevel3").hide();
            }
            jQuery("#defaultchkEmailCCLevel2,#defaultchkEmailCCLevel3,#defaultchkReopenTicket").prop('checked', false);

            $('#<%=defaulttxtMobile.ClientID%>').removeAttr("disabled");
            $("#defaultIsEditMobile").val("1");
            $("#defaulteditmobile").hide();

            $('#<%=defaulttxtemail.ClientID%>').removeAttr("disabled");
            $("#defaultIsEditEmail").val("1");
            $("#defaulteditemail").hide();
            $('#<%=defaulttxtName.ClientID%>').focus();
        }

        function defaultclosePopUp() {
            defaultEmpList = [];
            $find("<%=defaultmodelpopup.ClientID%>").hide();
            jQuery("#defaultbtnsave").val('Save');
        }

        function defaultEditMode(e, ctrl) {
            if (ctrl == "defaulttxtMobile") {
                $('#<%=defaulttxtMobile.ClientID%>').removeAttr("disabled");
                $("#defaultoldmobile").val($('#<%=defaulttxtMobile.ClientID%>').val());
                $("#defaultIsEditMobile").val("1");
                $('#defaultmobilecancel').show();
                $('#defaulteditmobile').hide();
            }
            if (ctrl == "defaulttxtemail") {
                $('#<%=defaulttxtemail.ClientID%>').removeAttr("disabled");
                $("#defaultoldemail").val($('#<%=defaulttxtemail.ClientID%>').val());
                $("#defaultIsEditEmail").val("1");
                $('#defaultemailcancel').show();
                $('#defaulteditemail').hide();
            }


        }

        function defaultCancelMode(e, ctrl) {
            if (ctrl == "defaulttxtMobile") {
                $('#<%=defaulttxtMobile.ClientID%>').attr("disabled", "disabled");
                $('#<%=defaulttxtMobile.ClientID%>').val($("#defaultoldmobile").val());
                $("#defaultIsEditMobile").val("0");
                $('#defaultmobilecancel').hide();
                $('#defaulteditmobile').show();
            }
            if (ctrl == "defaulttxtemail") {
                $('#<%=defaulttxtemail.ClientID%>').attr("disabled", "disabled");
                $('#<%=defaulttxtemail.ClientID%>').val($("#defaultoldemail").val());
                $("#defaultIsEditEmail").val("0");
                $('#defaultemailcancel').hide();
                $('#defaulteditemail').show();
            }
        }

        function defaultshowlength() {
            if (jQuery('#<%=defaulttxtMobile.ClientID%>').val() != "")
                jQuery('#defaultmolen').html($('#<%=defaulttxtMobile.ClientID%>').val().length);
            else
                jQuery('#defaultmolen').html('');
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $(".ms-parent").hide();
            $("#<%=defaulttxtName.ClientID%>").autocomplete({
                source: function (request, response) {

                    serverCall('CategoryTagEmployee.aspx/SearchEmployee', { query: $("#<%=defaulttxtName.ClientID%>").val(), EmpList: defaultEmpList.toString() }, function (result) {
                        var resultData =  $.parseJSON(result);
                        response(resultData);
                    },'',false);
                    
                },
                focus: function () {
                    return false;
                },
                select: function (event, ui) {
                    $("#defaulthdnempid").val(ui.item.value);
                    $("#<%=defaulttxtName.ClientID%>").val(ui.item.label);
                    $("#<%=defaulttxtMobile.ClientID%>").val(ui.item.Mobile);
                    if (ui.item.Mobile == "" || ui.item.Mobile == "0") {
                        $('#<%=defaulttxtMobile.ClientID%>').removeAttr("disabled");
                        $("#defaultIsEditMobile").val("1");
                        $("#defaulteditmobile").hide();
                    }
                    else {
                        $('#<%=defaulttxtMobile.ClientID%>').attr("disabled", "disabled");
                        $("#defaultIsEditMobile").val("0");
                        $("#defaulteditmobile").show();
                    }

                    $("#<%=defaulttxtemail.ClientID%>").val(ui.item.Email);
                    if (ui.item.Email == "" || ui.item.Email == "0") {
                        $('#<%=defaulttxtemail.ClientID%>').removeAttr("disabled");
                        $("#defaultIsEditEmail").val("1");
                        $("#defaulteditemail").hide();
                    }
                    else {
                        $('#<%=defaulttxtemail.ClientID%>').attr("disabled", "disabled");
                        $("#defaultIsEditEmail").val("0");
                        $("#defaulteditemail").show();
                    }
                    return false;
                },
                appendTo: "#defaultempautolist"

            });
        });
    </script>
      <script type="text/javascript">
          function defaultSave() {
              if ($("#<%=defaulttxtName.ClientID%>").val() == "") {
                  toast("Error", "Please Enter Name");
                  $("#<%=defaulttxtName.ClientID%>").focus();
                  return;
              }
              if ($("#<%=defaulttxtMobile.ClientID%>").val() == "") {
                  toast("Error", "Please Enter Mobile");
                  $("#<%=defaulttxtMobile.ClientID%>").focus();
                  return;
              }
              if ($("#<%=defaulttxtMobile.ClientID%>").val().length != 10) {
                  if ($('#<%=defaulttxtMobile.ClientID%>').attr("disabled")) {
                      $('#<%=defaulttxtMobile.ClientID%>').removeAttr("disabled");
                      $("#defaultoldmobile").val($('#<%=defaulttxtMobile.ClientID%>').val());
                      $("#defaultIsEditMobile").val("1");
                      $("#defaulteditmobile").hide();
                      $("#defaultmobilecancel").show();
                  }
                  toast("Error", "Please Enter Valid Mobile No.");
                  $("#<%=defaulttxtMobile.ClientID%>").focus();
                  return;
              }

              if ($("#<%=defaulttxtemail.ClientID%>").val() == "") {
                  toast("Error", "Please Enter Email");
                  $("#<%=defaulttxtemail.ClientID%>").focus();
                  return;
              }

              if (!isValidEmailAddress($("#<%=defaulttxtemail.ClientID%>").val())) {
                  if ($('#<%=defaulttxtemail.ClientID%>').attr("disabled")) {
                      $('#<%=defaulttxtemail.ClientID%>').removeAttr("disabled");
                      $("#defaultoldemail").val($('#<%=defaulttxtemail.ClientID%>').val());
                      $("#defaultIsEditEmail").val("1");
                      $("#defaulteditemail").hide();
                      $("#defaultemailcancel").show();
                  }
                  toast("Error", "Please Enter Vaild Email Address.");
                  $("#<%=defaulttxtemail.ClientID%>").focus();
                  return;
              }



              $('#defaultbtnsave').attr('disabled', 'disabled').val('Submiting...');

              var emp = new Object();
              emp.EmpID = jQuery("#defaulthdnempid").val();
              emp.Name = jQuery("#<%=defaulttxtName.ClientID%>").val();
              emp.Email = jQuery("#<%=defaulttxtemail.ClientID%>").val();
              emp.Mobile = jQuery("#<%=defaulttxtMobile.ClientID%>").val();
              emp.Lavel = jQuery('#defaultlblLable').text();
              emp.SubCategoryID = jQuery("#<%=hdncategoryID.ClientID%>").val();
              emp.IsEditMobile = jQuery("#defaultIsEditMobile").val();
              emp.IsEditEmail = jQuery("#defaultIsEditEmail").val();
              emp.EnquiryID = jQuery("#defaulthdEnquiryID").val();
              emp.ReopenTicket = jQuery("#defaultchkReopenTicket").is(':checked') ? 1 : 0;
              emp.EmailCCLevel2 = jQuery("#defaultchkEmailCCLevel2").is(':checked') ? 1 : 0;
              emp.EmailCCLevel3 = jQuery("#defaultchkEmailCCLevel3").is(':checked') ? 1 : 0;

              serverCall('CategoryTagEmployee.aspx/DefaultSave', { Data: emp }, function (response) {
                  jQuery('#defaultbtnsave').removeAttr('disabled').val('Save');
                  defaultcleare();
                  $find("<%=defaultmodelpopup.ClientID%>").hide();
                      defaultBindData();
                      toast("Success", "Record Saved Successfully ");
              });            
          }
          function defaultcleare() {
              jQuery("#defaulthdnempid").val('');
              jQuery("#<%=defaulttxtName.ClientID%>,#<%=defaulttxtMobile.ClientID%>,#<%=defaulttxtemail.ClientID%>").val('');
              jQuery("#defaulthdEnquiryID").val('');
              jQuery('#defaultmobilecancel,#defaultemailcancel,#defaultdiv_empDetail').hide();
              defaultEmpList = [];
              jQuery('#defaultdiv_empDetail').html('');
              jQuery("#defaultlblPopUpError").text('');
              jQuery("#defaultchkReopenTicket,#defaultchkEmailCCLevel2,#defaultchkEmailCCLevel3").prop('checked', false);
          }
          function defaultAddNew() {
              jQuery("#defaulttxtName,#defaulttxtMobile,#defaulttxtemail").val('');
              jQuery("#defaulttxtMobile,#defaulttxtemail").removeAttr('disabled');
              jQuery('#defaulteditmobile,#defaulteditemail').hide()
              jQuery("#defaultlblPopUpError").text('');
              jQuery("#defaultmolen").text('0');
              jQuery('#defaultbtnsave').val('Save');
              jQuery('#defaulthdEnquiryID').val('');
              jQuery("#defaultchkReopenTicket,#defaultchkEmailCCLevel2,#defaultchkEmailCCLevel3").prop('checked', false);
          }

    </script>

    <script type="text/javascript">
        function defaultempEdit(rowID) {
            jQuery("#defaulthdnempid").val(jQuery(rowID).closest('tr').find("#defaulttdEmployee_ID").text());
            jQuery("#<%=defaulttxtName.ClientID%>").val(jQuery(rowID).closest('tr').find("#defaulttdEmpName").text());
            jQuery("#<%=defaulttxtemail.ClientID%>").val(jQuery(rowID).closest('tr').find("#defaulttdEmail").text());
            jQuery("#<%=defaulttxtMobile.ClientID%>").val(jQuery(rowID).closest('tr').find("#defaulttdMobile").text());
            if (jQuery(rowID).closest('tr').find("#defaulttdReopenTicket").text() == 1)
                jQuery("#defaultchkReopenTicket").prop('checked', 'checked');
            else
                jQuery("#defaultchkReopenTicket").prop('checked', false);
            if (jQuery(rowID).closest('tr').find("#defaulttdEmailCCLevel2").text() == 1)
                jQuery("#defaultchkEmailCCLevel2").prop('checked', 'checked');
            else
                jQuery("#defaultchkEmailCCLevel2").prop('checked', false);
            if (jQuery(rowID).closest('tr').find("#defaulttdEmailCCLevel3").text() == 1)
                jQuery("#defaultchkEmailCCLevel3").prop('checked', 'checked');
            else
                jQuery("#defaultchkEmailCCLevel3").prop('checked', false);

            if (jQuery("#<%=defaulttxtMobile.ClientID%>").val() == "" || jQuery("#<%=defaulttxtMobile.ClientID%>").val() == "0") {
                jQuery('#<%=defaulttxtMobile.ClientID%>').removeAttr("disabled");
                jQuery("#defaultIsEditMobile").val("1");
                jQuery("#defaulteditmobile").hide();
            }

            else {
                jQuery('#<%=defaulttxtMobile.ClientID%>').attr("disabled", "disabled");
                jQuery("#defaultIsEditMobile").val("0");
                jQuery("#defaulteditmobile").show();
            }

            if (jQuery("#<%=defaulttxtemail.ClientID%>").val() == "" || jQuery("#<%=defaulttxtemail.ClientID%>").val() == "0") {
                jQuery('#<%=defaulttxtemail.ClientID%>').removeAttr("disabled");
                jQuery("#defaultIsEditEmail").val("1");
                jQuery("#defaulteditemail").hide();
            }
            else {
                jQuery('#<%=defaulttxtemail.ClientID%>').attr("disabled", "disabled");
                jQuery("#defaultIsEditEmail").val("0");
                jQuery("#defaulteditemail").show();
            }
            jQuery('#defaulthdEnquiryID').val(jQuery(rowID).closest('tr').find("#defaulttdID").text());
            jQuery('#defaultmolen').html($('#<%=defaulttxtMobile.ClientID%>').val().length);

            jQuery('#btnsave').val('Update');
        }
        function defaultempRemove(rowID) {
            var ID = jQuery(rowID).closest('tr').find("#defaulttdID").text();
            var Employee_ID = jQuery(rowID).closest('tr').find("#defaulttdEmployee_ID").text();

            serverCall('CategoryTagEmployee.aspx/defaultremoveTagEmployeeDetail', { ID: ID }, function (response) {
                if (response == "1") {
                    jQuery("#defaultlblPopUpError").text('Removed Successfully');
                    jQuery(rowID).closest('tr').remove();
                    defaultEmpList.splice($.inArray(Employee_ID, EmpList), 1);
                    defaultBindData();
                    var empHide = "".concat(jQuery("#defaultlblLable").text(), '@', Employee_ID);
                    jQuery('span[id="' + empHide + '"]').text('').removeClass('level');
                }
                else {
                    jQuery("#defaultlblPopUpError").text('Error..');
                }
            });        
        }
        function defaultBindEmpDetail(CentreID, Level) {
            serverCall('CategoryTagEmployee.aspx/defaultBindTagEmployeeDetail', { CenterID: CentreID, Level: Level, SubCategoryID: $('#<%=lblSubCategoryID.ClientID%>').text() }, function (response) {
                empData = $.parseJSON(response);
                if (empData.length == 0) {
                    jQuery('#defaultdiv_empDetail').empty();
                    return;
                }
                var output = jQuery('#defaultsc_EmpDetail').parseTemplate(empData);
                jQuery('#defaultdiv_empDetail').html(output);
                jQuery('#defaultdiv_empDetail').show();
                jQuery('#defaulttbl_EmpDetail tr').each(function () {
                    var id = $(this).attr("id");
                    if (id != "defaultEmpHeader") {
                        defaultEmpList.push($(this).find('#defaulttdEmployee_ID').text());
                    }
                });
            });           
        }
    </script>

      <script type="text/javascript">
          function defaultBindData() {
              serverCall('CategoryTagEmployee.aspx/defaultBindData', { SubCategoryID: $('#<%=lblSubCategoryID.ClientID%>').text() }, function (response) {

                  PatientData = $.parseJSON(response);
                  //    console.log(PatientData);
                  $('#defaultlevel1,#defaultlevel2,#defaultlevel3').html('');
                  if (PatientData[0].Level1ID != '' && PatientData[0].Level1ID != null) {
                      for (var k = 0; k < PatientData[0].Level1ID.split(',').length; k++) {
                          if (k <= 1) {
                              $('#defaultlevel1').append('<span style="margin-left: 5px;" id="Level1@' + PatientData[0].Level1ID.split(',')[k] + '" class="level">' + PatientData[0].Level1.split(',')[k] + '</span>');

                          }
                          if (k >= 2 && k == 2) {
                              $('#defaultlevel1').append('<span style="margin-left: 5px;" id="Level1" class="level">More...</span>');
                          }

                      }
                  }


                  if (PatientData[0].Level2ID != '' && PatientData[0].Level2ID != null) {
                      for (var k = 0; k < PatientData[0].Level2ID.split(',').length; k++) {
                          if (k <= 1) {
                              $('#defaultlevel2').append('<span style="margin-left: 5px;" id="Level2@' + PatientData[0].Level2ID.split(',')[k] + '" class="level">' + PatientData[0].Level2.split(',')[k] + '</span>');

                          }
                          if (k >= 2 && k == 2) {
                              $('#defaultlevel2').append('<span style="margin-left: 5px;" id="Level2" class="level">More...</span>');
                          }
                      }
                  }

                  if (PatientData[0].Level3ID != '' && PatientData[0].Level3ID != null) {
                      for (var k = 0; k < PatientData[0].Level3ID.split(',').length; k++) {
                        
                          if (k <= 1) {
                              $('#defaultlevel3').append('<span style="margin-left: 5px;" id="Level3@' + PatientData[0].Level3ID.split(',')[k] + '" class="level">' + PatientData[0].Level3.split(',')[k] + '</span>');

                          }
                          if (k >= 2 && k == 2) {
                              $('#defaultlevel3').append('<span style="margin-left: 5px;" id="Level3" class="level">More...</span>');
                          }
                      }
                  }
              });
              
          }
    </script>
    <script type="text/javascript">
        function isValidEmailAddress(emailAddress) {
            var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
            return pattern.test(emailAddress);
        }

    </script>
  <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
 <script type="text/javascript" src="../../scripts/jquery.multiple.select.js"></script>
</asp:Content>

