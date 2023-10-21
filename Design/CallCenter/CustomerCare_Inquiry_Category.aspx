<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" ValidateRequest="false" EnableEventValidation="false" AutoEventWireup="true" CodeFile="CustomerCare_Inquiry_Category.aspx.cs" Inherits="Design_CallCenter_CustomerCare_Inquiry_Category" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>

  <style type="text/css">
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
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
      
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 1300px;">
        <asp:HiddenField ID="hdncategoryID" runat="server" />
        <div class="POuter_Box_Inventory" style="width: 1296px;text-align: center;">
           
                <b>Customer Care Employee </b>
                
          
        </div>
       <div class="POuter_Box_Inventory" style="width: 1296px">
               <table  style="width:100%" frame="box">
            <tr> <asp:TextBox ID="TextBox1" runat="server"  Width="100px"  style="display:none;"></asp:TextBox>
              

            </tr>
            <tr>
                <td style="width:200px;" >&nbsp;</td>
                <td style="width:200px;" ><strong>Enquiry SubCategory :</strong>  </td>
                        <td style="text-align:left">
                            <asp:Label ID="lblCategory" runat="server" Text=""  style="font-size:large;font:bold"></asp:Label>
                           <asp:Label ID="lblSubCategoryID" runat="server" Text="" style="display:none"></asp:Label>
                           
                        </td>
                <td style="text-align:left;"> 
                 
                </td>
            </tr>
            
        </table>
           </div>
        <div class="POuter_Box_Inventory" style="width: 1296px">         
                <table style="width: 100%;" frame="box">
                   
                    <tr>
                        
                   
                         <td style="text-align: right; font-weight: 700;width:16%">
               <input id="btnMoreFilter" type="button" onclick="moreFilterSearch()" value="More Filter" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer" />

                    </td>
                        <td style="text-align: right; font-weight: 700;display:none" class="MoreFilter">CentreType:&nbsp;
                        </td>
                        <td > 
                            <asp:ListBox ID="lstCentreType" runat="server"   CssClass="multiselect"   SelectionMode="Multiple" Width="200px" ClientIDMode="Static"></asp:ListBox>
                        </td>


                        <td style="text-align: right; font-weight: 700;display:none" class="MoreFilter"> Zone :&nbsp;
                        </td>
                        <td >
                            <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="200px" ClientIDMode="Static" onchange="bindState()"></asp:ListBox>
                        </td>
                        <td style="text-align: right; font-weight: 700;display:none" class="MoreFilter"> State :&nbsp;
                        </td>
                        <td >
                            <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="250px" ClientIDMode="Static"></asp:ListBox>
                        </td>
                        <td class="MoreFilter" style="display:none">
                                                <input id="btnsearch" type="button" value="Search" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer" />

                        </td>
                    </tr>
                </table>
               <table style="width: 100%;" frame="box">
                   
                    <tr>
                        
                   
                         <td style="text-align: right; font-weight: 700;width:16%">
                Set Default Employee:

                    </td>
                        <td  style="text-align: right; font-weight: 700;" >Level 1:&nbsp;
                        </td>
                        <td id="defaultlevel1" onclick="defaultOpenPopup('Level1')" style="width: 280px;background: #fff;height: 26px; border: 1px solid #ccc;"> 
                        </td>
                        <td  style="text-align: right; font-weight: 700;" > Level 2:&nbsp;
                        </td>
                        <td id="defaultlevel2" onclick="defaultOpenPopup('Level2')" style="width: 280px;background: #fff;height: 26px; border: 1px solid #ccc;">
                        </td>
                        <td style="text-align: right; font-weight: 700;" > Level 3:&nbsp;
                        </td>
                        <td id="defaultlevel3" onclick="defaultOpenPopup('Level3')" style="width: 280px;background: #fff;height: 26px; border: 1px solid #ccc;">
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1296px;margin-top:10px;" >
          <div id="divCenterSearchOutput"  style="text-align:center; height:460px;overflow-y:scroll; ">
                
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
 
    </div>

     <asp:Panel ID="paneldata" runat="server" BackColor="#EAF3FD" BorderStyle="None" style="display:none;z-index:99999; border:1px solid #000;" >
        <div class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>   
                    <td>Tag Employee at :&nbsp;<span id="lblLable"></span></td>                    
                    <td  style="text-align:right">      
                        <img id="btnclosepopup" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="closePopUp()" />  
                    </td>                    
                </tr>
        </table>
      </div>
         <div style="width: 780px; padding:10px;">
             <table style="width:99%;border-collapse:collapse"> 
                 <tr>

                     <td colspan="4" style="text-align:center">
                         <asp:Label ID="lblPopUpError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                     </td>
                 </tr>
                                   <tr>
                                       <td><b>  Name : </b> &nbsp;</td>
                                       <td>
                                       <asp:TextBox ID="txtName" runat="server" Width="226px" ClientIDMode="Static" />
                                            <input type="hidden" id="hdnempid" />
                                            <input type="hidden" id="hdEnquiryID" />                                      
                                       </td> 
                                        <td><b>Reopen Ticket :&nbsp;</b></td>
                                       <td>
                                       <asp:CheckBox ID="chkReopenTicket" runat="server" ClientIDMode="Static" />
                                       </td>                                      
                                   </tr>
                         <tr>
                                       <td> <b> Mobile No. : </b> &nbsp;</td>
                                       <td>
                                        <asp:TextBox ID="txtMobile" runat="server" CssClass="ItDoseTextinputText" Width="168px" AutoCompleteType="Disabled"  MaxLength="10" onkeyup="showlength()" disabled   ></asp:TextBox>&nbsp;&nbsp;<a href="#" id="editmobile" onclick="EditMode(this,'txtMobile')">Edit</a>
                                           <a href="#" id="mobilecancel" onclick="CancelMode(this,'txtMobile')" style="display:none;">Cancel</a>
                                           <input type="hidden" id="IsEditMobile" value="0" />
                                            <input type="hidden" id="oldmobile" value="" />
                             &nbsp;&nbsp;<span id="molen" style="font-weight:bold;"></span>
                            <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobile" >
                            </cc1:FilteredTextBoxExtender>
                                       </td> 
                                        <td>
                                        <b>   Email ID :</b>   
                                        </td>
                                       <td>
                                        <asp:TextBox  ID="txtemail" runat="server"  Width="168px" AutoCompleteType="Disabled" MaxLength="50" onkeypress="this.value = this.value.toLowerCase();" disabled   ></asp:TextBox>&nbsp;&nbsp;<a href="#" id="editemail" onclick="EditMode(this,'txtemail')">Edit</a><a href="#" id="emailcancel" onclick="CancelMode(this,'txtemail')" style="display:none;">Cancel</a>
                                       <input type="hidden" id="IsEditEmail" value="0" />
                                            <input type="hidden" id="oldemail" value="" />
                                            </td>                                      
                                   </tr>
                           <tr>
                                       <td> <b> Zone :</b> &nbsp;</td>
                                       <td>
                                       <asp:ListBox ID="ddlZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="230px" ClientIDMode="Static" onchange="bindEmpState()"></asp:ListBox>                                                                        
                                       </td> 
                                        <td>
                                         <b> State :</b> 
                                        </td>
                                       <td>
                                         <asp:ListBox ID="ddlState" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static" onchange="bindEmpCity()"></asp:ListBox>
                                       </td>                                      
                                   </tr>
                         <tr>
                                       <td><b> City : </b> &nbsp;</td>
                                       <td>
                                      <asp:ListBox ID="ddlCity" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static" onchange="bindEmpCenter()"></asp:ListBox>
                                       </td> 
                                        <td>
                                        <b> Centre :</b> 
                                        </td>
                                       <td>
                                        <asp:ListBox ID="ddlCentre" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>
                                       </td>                                      
                                   </tr>
                                <tr>
                                       <td class="hideCCLevel2"><b> Email(Cc) Level2 :&nbsp;</b> </td>
                                       <td class="hideCCLevel2">
 <asp:CheckBox ID="chkEmailCCLevel2" runat="server" ClientIDMode="Static" />                                       </td> 
                                        <td class="hideCCLevel3">
                                        <b> Email(Cc) Level3 :&nbsp; </b> 
                                        </td >
                                       <td class="hideCCLevel3">
 <asp:CheckBox ID="chkEmailCCLevel3" runat="server" ClientIDMode="Static" />                                       </td>                                      
                                   </tr>
                                  
                               </table>
             </div>
          <div style="text-align:center; margin-bottom:10px; ">
                 <input type="button" class="searchbutton" onclick="Save()" id="btnsave" value="Save"/>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <input type="button" class="searchbutton" onclick="AddNew()" id="btnAddNew" value="Clear"/>
                  </div>
                  
         <div style="text-align:center; margin-bottom:10px; ">
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


<%--Default Employee Start--%>
      <asp:Panel ID="defaultpaneldata" runat="server" BackColor="#EAF3FD" BorderStyle="None" style="display:none;z-index:99999; border:1px solid #000;" >
        <div class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr>   
                    <td>Tag Employee at :&nbsp;<span id="defaultlblLable"></span></td>                    
                    <td  style="text-align:right">      
                        <img id="defaultbtnclosepopup" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="defaultclosePopUp()" />  
                    </td>                    
                </tr>
        </table>
      </div>
         <div style="width: 780px; padding:10px;">
             <table style="width:99%;border-collapse:collapse"> 
                 <tr>

                     <td colspan="4" style="text-align:center">
                         <asp:Label ID="defaultlblPopUpError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                     </td>
                 </tr>
                                   <tr>
                                       <td><b>  Name : </b> &nbsp;</td>
                                       <td>
                                       <asp:TextBox ID="defaulttxtName" runat="server" Width="226px" ClientIDMode="Static" />
                                            <input type="hidden" id="defaulthdnempid" />
                                            <input type="hidden" id="defaulthdEnquiryID" />                                      
                                       </td> 
                                        <td><b>Reopen Ticket :&nbsp;</b></td>
                                       <td>
                                       <asp:CheckBox ID="defaultchkReopenTicket" runat="server" ClientIDMode="Static" />
                                       </td>                                      
                                   </tr>
                         <tr>
                                       <td> <b> Mobile No. : </b> &nbsp;</td>
                                       <td>
                                        <asp:TextBox ID="defaulttxtMobile" runat="server" CssClass="ItDoseTextinputText" Width="168px" AutoCompleteType="Disabled"  MaxLength="10" onkeyup="defaultshowlength()" disabled   ></asp:TextBox>&nbsp;&nbsp;<a href="#" id="defaulteditmobile" onclick="defaultEditMode(this,'defaulttxtMobile')">Edit</a>
                                           <a href="#" id="defaultmobilecancel" onclick="defaultCancelMode(this,'defaulttxtMobile')" style="display:none;">Cancel</a>
                                           <input type="hidden" id="defaultIsEditMobile" value="0" />
                                            <input type="hidden" id="defaultoldmobile" value="" />
                             &nbsp;&nbsp;<span id="defaultmolen" style="font-weight:bold;"></span>
                            <cc1:FilteredTextBoxExtender ID="defaultfltMobile" runat="server" FilterType="Numbers" TargetControlID="defaulttxtMobile" >
                            </cc1:FilteredTextBoxExtender>
                                       </td> 
                                        <td>
                                        <b>   Email ID :</b>   
                                        </td>
                                       <td>
                                        <asp:TextBox  ID="defaulttxtemail" runat="server"  Width="168px" AutoCompleteType="Disabled" MaxLength="50" onkeypress="this.value = this.value.toLowerCase();" disabled   ></asp:TextBox>&nbsp;&nbsp;<a href="#" id="defaulteditemail" onclick="defaultEditMode(this,'defaulttxtemail')">Edit</a><a href="#" id="defaultemailcancel" onclick="defaultCancelMode(this,'defaulttxtemail')" style="display:none;">Cancel</a>
                                       <input type="hidden" id="defaultIsEditEmail" value="0" />
                                            <input type="hidden" id="defaultoldemail" value="" />
                                            </td>                                      
                                   </tr>                         
                                <tr>
                                       <td class="defaulthideCCLevel2"><b> Email(Cc) Level2 :&nbsp;</b> </td>
                                       <td class="defaulthideCCLevel2">
                                        <asp:CheckBox ID="defaultchkEmailCCLevel2" runat="server" ClientIDMode="Static" /></td> 
                                        <td class="defaulthideCCLevel3">
                                        <b> Email(Cc) Level3 :&nbsp; </b> 
                                        </td >
                                       <td class="defaulthideCCLevel3">
                                        <asp:CheckBox ID="defaultchkEmailCCLevel3" runat="server" ClientIDMode="Static" /> </td>                                      
                                   </tr>
                                  
                               </table>
             </div>
          <div style="text-align:center; margin-bottom:10px; ">
                 <input type="button" class="searchbutton" onclick="defaultSave()" id="defaultbtnsave" value="Save"/>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <input type="button" class="searchbutton" onclick="defaultAddNew()" id="defaultbtnAddNew" value="Clear"/>
                  </div>
                  
         <div style="text-align:center; margin-bottom:10px; ">
               <div id="defaultdiv_empDetail"></div> 
             </div>

           <div id="defaultempautolist"></div>         
                     
    </asp:Panel>
    <asp:Button ID="defaultButton1" runat="server" style="display:none;" />
  <cc1:modalpopupextender ID="defaultmodelpopup" runat="server" CancelControlID="defaultbtnclosepopup" TargetControlID="defaultButton1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="defaultpaneldata">
    </cc1:modalpopupextender>
<%--Default Employee End--%>


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
   <%-- <td class="GridViewLabItemStyle" id="defaulttdStateID" style="text-align:left;display:none"><#=objRow.StateID#></td>
    <td class="GridViewLabItemStyle" id="defaulttdCityID" style="text-align:left;display:none"><#=objRow.CityID#></td>
    <td class="GridViewLabItemStyle" id="defaulttdBusinessZoneID" style="text-align:left;display:none"><#=objRow.BusinessZoneID#></td>
    <td class="GridViewLabItemStyle" id="defaulttdCentreID" style="text-align:left;display:none"><#=objRow.CentreID#></td>--%>
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
        var EZoneID=0;
        var EStateID = 0;
        var ECityID=0;
        var ECenterID=0;
        jQuery(function () {
           
            
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
            jQuery('[id*=lstZone],[id*=ddlZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstState],[id*=ddlState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstCentreType],[id*=ddlCentre]').multipleSelect({
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
            jQuery.ajax({
                url: "CustomerCare_Inquiry_Category.aspx/bindCenterType",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    typedata = jQuery.parseJSON(result.d);
                    for (i = 0; i < typedata.length; i++) {
                        jQuery('#lstCentreType').append($("<option></option>").val(typedata[i].ID).html(typedata[i].Type1));
                    }
                    jQuery('[id*=lstCentreType]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });

                },
                error: function (xhr, status) {
                }
            });
        }
        function bindZone() {
            jQuery('#lstZone option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZone",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    BusinessZone = jQuery.parseJSON(result.d);
                    for (i = 0; i < BusinessZone.length; i++) {
                        jQuery('#lstZone').append($("<option></option>").val(BusinessZone[i].BusinessZoneID).html(BusinessZone[i].BusinessZoneName));
                    }
                    jQuery('[id*=lstZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {

                }
            });
        }
        function bindState() {
            jQuery("#lstState option").remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (jQuery("#lstZone").val() != "") {
                jQuery.ajax({
                    url: "CustomerCare_Inquiry_Category.aspx/bindState",
                    data: '{ BusinessZoneID: "' + jQuery("#lstZone").val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var stateData = jQuery.parseJSON(result.d);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id*=lstState]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });

                    },
                    error: function (xhr, status) {

                    }

                });
            }
        }
    </script>

    <script type="text/javascript">
        function bindEmpZone() {
            jQuery('#ddlZone option').remove();
            jQuery('#ddlZone').multipleSelect("refresh");
            jQuery.ajax({
                url: "../Common/Services/CommonServices.asmx/bindBusinessZone",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    BusinessZone = jQuery.parseJSON(result.d);
                    for (i = 0; i < BusinessZone.length; i++) {
                        jQuery('#ddlZone').append($("<option></option>").val(BusinessZone[i].BusinessZoneID).html(BusinessZone[i].BusinessZoneName));
                    }
                    jQuery('[id*=ddlZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                    if (EZoneID == 0) {
                      
                        jQuery('#ddlZone').multipleSelect("setSelects", jQuery("#lstZone").val());
                    }
                    else {                        
                        var dataarray = EZoneID.split(",");                         
                        jQuery('#ddlZone').multipleSelect("setSelects", dataarray);
                    }
                    //jQuery("#ddlZone").val(jQuery("#lstZone").val());

                },
                error: function (xhr, status) {

                }
            });
        }
        function bindEmpState() {
            jQuery("#ddlState option").remove();
            jQuery('#ddlState').multipleSelect("refresh");
            if (jQuery("#ddlZone").val() != "") {
                jQuery.ajax({
                    url: "CustomerCare_Inquiry_Category.aspx/bindState",
                    data: '{ BusinessZoneID: "' + jQuery("#ddlZone").val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var stateData = jQuery.parseJSON(result.d);
                        for (i = 0; i < stateData.length; i++) {
                            jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                        }
                        jQuery('[id*=ddlState]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
 
                       
                        if (EStateID == 0) {
                            $('#ddlState').multipleSelect("setSelects", jQuery("#lstState").val());
                        }
                        else {


                            var dataarray = EStateID.split(",");

                            $('#ddlState').multipleSelect("setSelects", dataarray);
                        }
                    },
                    error: function (xhr, status) {

                    }

                });
            }
        }
        function bindEmpCity() {
            jQuery('#ddlCity option').remove();
            jQuery('#ddlCity').multipleSelect("refresh");
            jQuery.ajax({
                url: "CustomerCare_Inquiry_Category.aspx/bindCity",
                data: '{StateID:"' + jQuery('#ddlState').val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    var cityData = jQuery.parseJSON(result.d);
                    for (i = 0; i < cityData.length; i++) {
                        jQuery("#ddlCity").append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                    }

                    $('[id*=ddlCity]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });

                    if (ECityID != 0) {
                        var dataarray = ECityID.split(",");
                        jQuery('#ddlCity').multipleSelect("setSelects", dataarray);
                    }
                     
                },
                error: function (xhr, status) {


                }
            });
        }
        function bindEmpCenter() {
            jQuery('#ddlCentre option').remove();
            jQuery('#ddlCentre').multipleSelect("refresh");
            jQuery.ajax({
                url: "CustomerCare_Inquiry_Category.aspx/bindCentre",
                data: '{CityID:"' + jQuery("#ddlCity").val() + '", BusinessZoneID:"' + jQuery("#ddlZone").val() + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d != null) {
                        var centreData = jQuery.parseJSON(result.d);
                        for (i = 0; i < centreData.length; i++) {
                            jQuery("#ddlCentre").append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                        }

                        jQuery('[id*=ddlCentre]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });

                        if (ECenterID != 0) {
                            var dataarray = ECenterID.split(",");
                            $('#ddlCentre').multipleSelect("setSelects", dataarray);
                        }
                    }
                },
                error: function (xhr, status) {

                }

            });

        }

    </script>

    <script type="text/javascript">
        function BindData() {
            var CentreID = "";
            var StateID = "";
            CentreID = $('#lstCentreType').val();
            StateID = $('#lstState').val();
           
                jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            jQuery.ajax({
                url: "CustomerCare_Inquiry_Category.aspx/BindData",
                data: '{CentrTypeId: "' + CentreID + '", StateId:"' + StateID + '", SubCategoryID:"' + jQuery('#lblSubCategoryID').text() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = $.parseJSON(result.d);
                    if (PatientData.length == 0) {
                        jQuery('#divCenterSearchOutput').empty();
                        return;
                    }
                    var output = jQuery('#tb_centerList').parseTemplate(PatientData);
                    jQuery('#divCenterSearchOutput').html(output);
                    jQuery.unblockUI();
                },
                error: function (xhr, status) {
                    jQuery.unblockUI();
                   
                }
            });


        }
    </script>

    <script type="text/javascript">

        function OpenPopup(level, EmpID, CenterID) {
            cleare();
            jQuery('#lblLable').html(level);
            $find("<%=modelpopup.ClientID%>").show();
            jQuery('#molen').html('0');
          //  EmpSearch();
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
            jQuery("#chkEmailCCLevel2,#chkEmailCCLevel3,#chkReopenTicket").prop('checked', false);
          //  if (EmpID != "") {
               // jQuery.ajax({
               //     url: "CustomerCare_Inquiry_Category.aspx/GetEmpID",
               //     data: '{ID:"' + EmpID + '",Level:"' + level + '",CenterID:"' + CenterID + '"}',
               //     type: "POST",
               //     timeout: 120000,
               //     async: false,
               //     contentType: "application/json; charset=utf-8",
               //     dataType: "json",
               //     success: function (result) {
               //         var Emp = jQuery.parseJSON(result.d);
               //         jQuery("#hdnempid").val(Emp[0].Employee_ID);
               //         jQuery("#<%=txtName.ClientID%>").val(Emp[0].EmpName);
               //         jQuery("#<%=txtemail.ClientID%>").val(Emp[0].Email);
               //         jQuery("#<%=txtMobile.ClientID%>").val(Emp[0].Mobile);

               //         if (Emp[0].Mobile == "" || Emp[0].Mobile == "0") {
               //             $('#<%=txtMobile.ClientID%>').removeAttr("disabled");
               //              $("#IsEditMobile").val("1");
               //              $("#editmobile").hide();
               //          }

               //          else {
               //              $('#<%=txtMobile.ClientID%>').attr("disabled", "disabled");
              //               $("#IsEditMobile").val("0");
              //               $("#editmobile").show();
               //         }

              //          if (Emp[0].Email == "" || Emp[0].Email == "0") {
              //              $('#<%=txtemail.ClientID%>').removeAttr("disabled");
              //               $("#IsEditEmail").val("1");
              //               $("#editemail").hide();
              //           }
              //           else {
             //                $('#<%=txtemail.ClientID%>').attr("disabled", "disabled");
              //               $("#IsEditEmail").val("0");
              //               $("#editemail").show();
              //          }

              //          jQuery('#hdnID').val(Emp[0].ID);
              //          EZoneID = Emp[0].BusinessZoneID + ",";
              //          EStateID = Emp[0].StateID + ",";
              //          ECityID = Emp[0].CityID + ",";
             //           ECenterID = Emp[0].CentreID + ",";
              //          jQuery('#molen').html($('#<%=txtMobile.ClientID%>').val().length);
              //          $('#<%=txtName.ClientID%>').focus();
              //      },
              //      error: function (xhr, status) {


              //      }
              //  });
           // }
          //  else {
                jQuery.ajax({
                    url: "CustomerCare_Inquiry_Category.aspx/GetCenter",
                    data: '{CenterID:"' + CenterID + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var Center = jQuery.parseJSON(result.d);                        
                        EZoneID = Center[0].BusinessZoneID + ",";
                        EStateID = Center[0].StateID + ",";
                        ECityID = Center[0].CityID + ",";
                        ECenterID = Center[0].CentreID + ",";

                        
                            $('#<%=txtMobile.ClientID%>').removeAttr("disabled");
                             $("#IsEditMobile").val("1");
                             $("#editmobile").hide();
                        
                         
                            $('#<%=txtemail.ClientID%>').removeAttr("disabled");
                            $("#IsEditEmail").val("1");
                            $("#editemail").hide();
                            $('#<%=txtName.ClientID%>').focus();
                        

                    },
                     error: function (xhr, status) {


                     }
                 });

            //}

            bindEmpZone();

        }

       
            $(function () {
                $("#<%=txtName.ClientID%>").autocomplete({
                   source: function (request, response) {
                       $.ajax({
                           type: "POST",
                           contentType: "application/json; charset=utf-8",
                           url: "CustomerCare_Inquiry_Category.aspx/SearchEmployee",
                           data: "{'query':'" + $("#<%=txtName.ClientID%>").val() + "',EmpList:'"+EmpList+"'}",
                            dataType: "json",
                            success: function (data) {
                                var result = $.parseJSON(data.d);
                                response(result);
                            },
                            Error: function (results) {
                                alert("Error");
                            }
                        });
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
                           $('#<%=txtMobile.ClientID%>').attr("disabled","disabled");
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
                showerrormsg("Please Enter Name");
                $("#<%=txtName.ClientID%>").focus();
                return;
            }
            if ($("#<%=txtMobile.ClientID%>").val() == "") {
                showerrormsg("Please Enter Mobile");
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
                showerrormsg("Please Enter Valid Mobile No.");
                $("#<%=txtMobile.ClientID%>").focus();
                return;
            }

            if ($("#<%=txtemail.ClientID%>").val() == "") {
                showerrormsg("Please Enter Email");
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
                showerrormsg("Please Enter Vaild Email Address.");
                $("#<%=txtemail.ClientID%>").focus();
                return;
            }

            if ($("#<%=ddlCentre.ClientID%>").val() == "") {
                showerrormsg("Please Select Centre");
                $("#<%=txtemail.ClientID%>").focus();
                return;
            }
          

            $('#btnsave').attr('disabled', 'disabled').val('Submiting...');

            var emp = new Object();           
            emp.EmpID = jQuery("#hdnempid").val();
            emp.Name = jQuery("#<%=txtName.ClientID%>").val();
            emp.Email = jQuery("#<%=txtemail.ClientID%>").val();
            emp.Mobile = jQuery("#<%=txtMobile.ClientID%>").val();
            emp.CenterID = jQuery("#<%=ddlCentre.ClientID%>").val();
            emp.Lavel = jQuery('#lblLable').text();
            emp.SubCategoryID = jQuery("#<%=hdncategoryID.ClientID%>").val(); 
            emp.IsEditMobile = jQuery("#IsEditMobile").val();
            emp.IsEditEmail = jQuery("#IsEditEmail").val();
            emp.EnquiryID = jQuery("#hdEnquiryID").val();
            emp.ReopenTicket = jQuery("#chkReopenTicket").is(':checked') ? 1 : 0;
            emp.EmailCCLevel2 = jQuery("#chkEmailCCLevel2").is(':checked') ? 1 : 0;
            emp.EmailCCLevel3 = jQuery("#chkEmailCCLevel3").is(':checked') ? 1 : 0;
            jQuery.ajax({
                type: "POST",
                url: "CustomerCare_Inquiry_Category.aspx/Save",
                data: "{Data:'" + JSON.stringify(emp) + "',CenterID:'" + jQuery("#<%=ddlCentre.ClientID%>").val() + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    jQuery('#btnsave').removeAttr('disabled').val('Save');
                    cleare();
                    $find("<%=modelpopup.ClientID%>").hide();
                    BindData();
                    showerrormsg("Record Saved Successfully ");
                },
                failure: function (response) {
                    jQuery('#btnsave').removeAttr('disabled').val('Save');
                    showerrormsg("Error occurred, Please contact administrator");
                }
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
             jQuery("#chkReopenTicket,#chkEmailCCLevel2,#chkEmailCCLevel3").prop('checked', false);
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

        //function isValidEmailAddress(emailAddress) {
        //    var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
        //    return pattern.test(emailAddress);
        //}
        //function showerrormsg(msg) {
        //    jQuery('#msgField').html('');
        //    jQuery('#msgField').append(msg);
        //    jQuery(".alert").css('background-color', 'red');
        //    jQuery(".alert").removeClass("in").show();
        //    jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        //}
    </script>
    <script type="text/javascript">
        function AddNew() {
            jQuery("#txtName,#txtMobile,#txtemail").val('');
            jQuery("#txtMobile,#txtemail").removeAttr('disabled');
            jQuery("#lblPopUpError").text('');
            jQuery("#molen").text('0');
            jQuery('#btnsave').val('Save');
            jQuery('#hdEnquiryID').val('');
            jQuery("#chkReopenTicket,#chkEmailCCLevel2,#chkEmailCCLevel3").prop('checked', false);
        }
    </script>
      



    <script type="text/javascript">
        function empEdit(rowID) {
            jQuery("#hdnempid").val(jQuery(rowID).closest('tr').find("#tdEmployee_ID").text());
            jQuery("#<%=txtName.ClientID%>").val(jQuery(rowID).closest('tr').find("#tdEmpName").text());
            jQuery("#<%=txtemail.ClientID%>").val(jQuery(rowID).closest('tr').find("#tdEmail").text());
            jQuery("#<%=txtMobile.ClientID%>").val(jQuery(rowID).closest('tr').find("#tdMobile").text());
            if (jQuery(rowID).closest('tr').find("#tdReopenTicket").text() == 1)
                jQuery("#chkReopenTicket").prop('checked', 'checked');
            else
                jQuery("#chkReopenTicket").prop('checked', false);
            if (jQuery(rowID).closest('tr').find("#tdEmailCCLevel2").text() == 1)
                jQuery("#chkEmailCCLevel2").prop('checked', 'checked');
            else
                jQuery("#chkEmailCCLevel2").prop('checked', false);
            if (jQuery(rowID).closest('tr').find("#tdEmailCCLevel3").text() == 1)
                jQuery("#chkEmailCCLevel3").prop('checked', 'checked');
            else
                jQuery("#chkEmailCCLevel3").prop('checked', false);

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
                  
            jQuery('#btnsave').val('Update');
        }
        function empRemove(rowID) {
            var ID = jQuery(rowID).closest('tr').find("#tdID").text();
            var Employee_ID=  jQuery(rowID).closest('tr').find("#tdEmployee_ID").text();
            var CentreID=  jQuery(rowID).closest('tr').find("#tdCentreID").text();
            
            jQuery.ajax({
                url: "CustomerCare_Inquiry_Category.aspx/removeTagEmployeeDetail",
                data: '{ID: "' + ID + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        jQuery("#lblPopUpError").text('Removed Successfully');
                        jQuery(rowID).closest('tr').remove();                        
                        EmpList.splice($.inArray(Employee_ID, EmpList), 1);
                        
                      

                       var empHide= "".concat(jQuery("#lblLable").text(), '@', CentreID,'@', Employee_ID);
                       //console.log(empHide);
                  
                     
                       jQuery('span[id="' + empHide + '"]').text('').removeClass('level');

                      
                    }
                    else {
                        jQuery("#lblPopUpError").text('Error..');
                    }

                },
                error: function (xhr, status) {


                }
            });
        }
        function BindEmpDetail(CentreID, Level) {
           
            jQuery.ajax({
                url: "CustomerCare_Inquiry_Category.aspx/BindTagEmployeeDetail",
                data: '{CenterID: "' + CentreID + '", Level:"' + Level + '",SubCategoryID:"'+$('#lblSubCategoryID').text()+'"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    empData = $.parseJSON(result.d);
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
                  
                },
                error: function (xhr, status) {
                   

                }
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
            $("#<%=defaulttxtName.ClientID%>").autocomplete({
                  source: function (request, response) {
                      $.ajax({
                          type: "POST",
                          contentType: "application/json; charset=utf-8",
                          url: "CustomerCare_Inquiry_Category.aspx/SearchEmployee",
                          data: "{'query':'" + $("#<%=defaulttxtName.ClientID%>").val() + "',EmpList:'" + defaultEmpList + "'}",
                           dataType: "json",
                           success: function (data) {
                               var result = $.parseJSON(data.d);
                               response(result);
                           },
                           Error: function (results) {
                               alert("Error");
                           }
                       });
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
                showerrormsg("Please Enter Name");
                $("#<%=defaulttxtName.ClientID%>").focus();
                return;
            }
            if ($("#<%=defaulttxtMobile.ClientID%>").val() == "") {
                showerrormsg("Please Enter Mobile");
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
                showerrormsg("Please Enter Valid Mobile No.");
                $("#<%=defaulttxtMobile.ClientID%>").focus();
                return;
            }

            if ($("#<%=defaulttxtemail.ClientID%>").val() == "") {
                showerrormsg("Please Enter Email");
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
                showerrormsg("Please Enter Vaild Email Address.");
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
            jQuery.ajax({
                type: "POST",
                url: "CustomerCare_Inquiry_Category.aspx/DefaultSave",
                data: "{Data:'" + JSON.stringify(emp) + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    jQuery('#defaultbtnsave').removeAttr('disabled').val('Save');
                    defaultcleare();
                    $find("<%=defaultmodelpopup.ClientID%>").hide();
                    defaultBindData();
                    showerrormsg("Record Saved Successfully ");
                },
                failure: function (response) {
                    jQuery('#defaultbtnsave').removeAttr('disabled').val('Save');
                    showerrormsg("Error occurred, Please contact administrator");
                }
            });
        }
        function defaultcleare() {
            jQuery("#defaulthdnempid").val('');
            jQuery("#<%=defaulttxtName.ClientID%>,#<%=defaulttxtMobile.ClientID%>,#<%=defaulttxtemail.ClientID%>").val('');           
            jQuery("#defaulthdEnquiryID").val('');
            jQuery('#defaultmobilecancel,#defaultemailcancel,#defaultdiv_empDetail').hide()
            defaultEmpList = [];
            jQuery('#defaultdiv_empDetail').html('');
            jQuery("#defaultlblPopUpError").text('');
            jQuery("#defaultchkReopenTicket,#defaultchkEmailCCLevel2,#defaultchkEmailCCLevel3").prop('checked', false);
        }
          function defaultAddNew() {
              jQuery("#defaulttxtName,#defaulttxtMobile,#defaulttxtemail").val('');
              jQuery("#defaulttxtMobile,#defaulttxtemail").removeAttr('disabled');
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
            jQuery.ajax({
                url: "CustomerCare_Inquiry_Category.aspx/defaultremoveTagEmployeeDetail",
                data: '{ID: "' + ID + '"}',
                type: "POST",          
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        jQuery("#defaultlblPopUpError").text('Removed Successfully');
                        jQuery(rowID).closest('tr').remove();
                        defaultEmpList.splice($.inArray(Employee_ID, EmpList), 1);

                        defaultBindData();

                        var empHide = "".concat(jQuery("#defaultlblLable").text(),'@', Employee_ID);
                        //console.log(empHide);


                        jQuery('span[id="' + empHide + '"]').text('').removeClass('level');


                    }
                    else {
                        jQuery("#defaultlblPopUpError").text('Error..');
                    }

                },
                error: function (xhr, status) {


                }
            });
        }
        function defaultBindEmpDetail(CentreID, Level) {

            jQuery.ajax({
                url: "CustomerCare_Inquiry_Category.aspx/defaultBindTagEmployeeDetail",
                data: '{CenterID: "' + CentreID + '", Level:"' + Level + '",SubCategoryID:"' + $('#lblSubCategoryID').text() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    empData = $.parseJSON(result.d);
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

                },
                error: function (xhr, status) {


                }
            });


        }
    </script>

      <script type="text/javascript">
          function defaultBindData() {              
              jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
              jQuery.ajax({
                  url: "CustomerCare_Inquiry_Category.aspx/defaultBindData",
                  data: '{SubCategoryID:"' + jQuery('#lblSubCategoryID').text() + '"}',
                  type: "POST", // data has to be Posted    	        
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  success: function (result) {
                      PatientData = $.parseJSON(result.d);
                      console.log(JSON.stringify(PatientData));
                      $('#defaultlevel1,#defaultlevel2,#defaultlevel3').html('');
                     if(PatientData[0].Level1ID != '' && PatientData[0].Level1ID != null)
                     {                        
                         for(var k=0;k<PatientData[0].Level1ID.split(',').length;k++)
                         {
                             if (k <= 1) {
                                 $('#defaultlevel1').append('<span style="margin-left: 5px;" id="Level1@' + PatientData[0].Level1ID.split(',')[k] + '" class="level">' + PatientData[0].Level1.split(',')[k] + '</span>');

                             }
                             if (k >= 2 && k == 2) {
                                 $('#defaultlevel1').append('<span style="margin-left: 5px;" id="Level1" class="level">More...</span>');
                             }
                               
                         }
                     }
                     

                     if (PatientData[0].Level2ID != '' && PatientData[0].Level2ID != null) {
                         for (var k = 0; k < PatientData[0].Level2ID.split(',').length; k++)
                             {
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
                             console.log('print k :' + k);
                             if (k <= 1) {
                                 $('#defaultlevel3').append('<span style="margin-left: 5px;" id="Level3@' + PatientData[0].Level3ID.split(',')[k] + '" class="level">' + PatientData[0].Level3.split(',')[k] + '</span>');

                             }
                             if (k >= 2 && k == 2) {
                                 $('#defaultlevel3').append('<span style="margin-left: 5px;" id="Level3" class="level">More...</span>');
                             }
                         }
                     }
   
                      jQuery.unblockUI();
                  },
                  error: function (xhr, status) {
                      jQuery.unblockUI();

                  }
              });


          }
    </script>
    <script type="text/javascript">
        function isValidEmailAddress(emailAddress) {
            var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
            return pattern.test(emailAddress);
        }
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>
</asp:Content>

