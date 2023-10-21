<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HomeCollectionDelayTatMapping.aspx.cs" Inherits="Design_HomeCollection_HomeCollectionDelayTatMapping" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
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

    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <asp:HiddenField ID="hdncategoryID" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align:center">         
                    <b>Home Collection Delay Tat Time Master </b>                                                    
        </div>
              
        <div class="POuter_Box_Inventory">         
               
             <div id="divLeveltimeData" style="overflow:auto; height:75px">                 
                
                   </div>
            </div>
            <div class="POuter_Box_Inventory">
           <div class="Purchaseheader">
                <b>Home Collection Delay Tat Mapping With Centre </b></div>
                
          
     
                <div class="row" style="display:none;">
                    <div class="col-md-3">
               <input id="btnMoreFilter" type="button" onclick="moreFilterSearch()" value="More Filter" style="font-weight:bold;padding:5px;border-radius:10px;background-color:maroon;color:white;cursor:pointer;display:none;" />

                    </div>
                    <div class="col-md-3" style="display:none" >
                        <label class="pull-left"><b>Business Type</b></label>
			                <b class="pull-right">:</b>
                    </div>
                    <div class="MoreFilter col-md-3" >
                     
                    </div>                   
                </div>
           
                <div class="row">
                    <div class="col-md-4">
                           <asp:RadioButtonList ID="rlBusinessType" runat="server" RepeatDirection="Horizontal" onchange="clearControl();" style="font-weight: 700">
                            <asp:ListItem Value="0" Selected="True">All</asp:ListItem>
                            <asp:ListItem Value="COCO">COCO</asp:ListItem>
                            <asp:ListItem Value="FOFO">FOFO</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                    <div style="font-weight: 700;" class="MoreFilter col-md-2">
                        <label class="pull-left"><b>Zone</b></label>
			                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:ListBox ID="lstBusinessZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </div>
                    <div class="MoreFilter col-md-2">
                        <label class="pull-left"><b>State</b></label>
			                <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-5" >
                        <asp:ListBox onchange="bindtagprocessingtab()" ID="lstStateData" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </div>
                    <div style="font-weight: 700;" class="MoreFilter col-md-2">
                        <label class="pull-left"><b>Type</b></label>
			                <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:ListBox ID="lstType" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" ></asp:ListBox>
                    </div>
                </div>
                <div class="row">
                <div class="col-md-2"></div>
                <div class="MoreFilter col-md-4">
                         <label class="pull-left"><b>Tag Processing Lab </b></label>
			                <b class="pull-right">:</b>
                    </div>
                        <div class="MoreFilter col-md-5" >
                        <asp:DropDownList ID="lstTagprocessingLab" class="lstTagprocessingLab chosen-select" runat="server" ClientIDMode="Static" ></asp:DropDownList>
                    </div>
                <div class="col-md-1"></div>
                    <div class="MoreFilter col-md-3" style="text-align: left">
                        <input id="btnsearch" type="button" value="Search" class="searchbutton" />
                    </div>
            </div>
                <div class="row">
                    <div class="Purchaseheader">
                        <b>Set Default Employee</b>
                        </div>
                       </div> 
                    <div class="row">
                        <div class="col-md-4"></div>
                        <div class="col-md-2">
                            <label class="pull-left"><b>Level 1</b></label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" id="defaultlevel1" onclick="defaultOpenPopup('Level1')" style="background: #fff;height: 26px; border: 1px solid #ccc;"> 
                        </div>
                        <div class="col-md-2" >
                            <label class="pull-left"><b>Level 2</b></label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" id="defaultlevel2" onclick="defaultOpenPopup('Level2')" style="background: #fff;height: 26px; border: 1px solid #ccc;">
                        </div>
                        <div class="col-md-2" style="text-align: right; font-weight: 700;" >
                            <label class="pull-left"><b>Level 3</b></label>
			                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4" id="defaultlevel3" onclick="defaultOpenPopup('Level3')" style="background: #fff;height: 26px; border: 1px solid #ccc;">
                        </div>
                    </div>
                   </div>
        
        <div class="POuter_Box_Inventory" >
          <div id="divCenterSearchOutput"  style="text-align:center; height:460px;overflow-y:scroll; ">
                
            </div>
     </div> 

      
 
    </div>

     <asp:Panel ID="paneldata" runat="server" BackColor="#EAF3FD" BorderStyle="None" style="display:none;z-index:99999; border:1px solid #000;width:740px" >
        <div class="Purchaseheader">
        
                <div class="row">   
                    <div class="col-md-6">
                            <label class="pull-left"><b>Tag Employee at </b></label>
			                <b class="pull-right">:</b></div> 
                        <div class="col-md-1">
                        <span id="lblLable"></span></div>                    
                    <div class="col-md-17"  style="text-align:right">      
                        <img id="btnclosepopup" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;"  onclick="closePopUp()" />  
                    </div>                    
                </div>
      </div>
      
                 <div class="row">

                     <div class="col-md-24">
                         <asp:Label ID="lblPopUpError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                     </div>
                    </div>
                                   <div class="row">
                                       <div class="col-md-4">
                                            <label class="pull-left"><b>Name</b></label>
			                                <b class="pull-right">:</b>
                                         </div>
                                       <div class="col-md-14">
                                       <asp:TextBox ID="txtName" runat="server" ClientIDMode="Static"  MaxLength="50" CssClass="requiredField"/>
                                            <input type="hidden" id="hdnempid" />
                                            <input type="hidden" id="hdEnquiryID" />                                      
                                       </div> 
                                                                            
                                   </div>
                         <div class="row">
                                       <div class="col-md-4">
                                           <label class="pull-left"><b>Mobile No.</b></label>
			                                <b class="pull-right">:</b>
                                            </div>
                                       <div class="col-md-5">
                                        <asp:TextBox ID="txtMobile" runat="server" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"  MaxLength="10" onkeyup="showlength()" disabled   ></asp:TextBox>
                                           <a href="#" id="mobilecancel" onclick="CancelMode(this,'txtMobile')" style="display:none;">Cancel</a>
                                           <input type="hidden" id="IsEditMobile" value="0" />
                                            <input type="hidden" id="oldmobile" value="" />
                                            <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtMobile" >
                                            </cc1:FilteredTextBoxExtender></div> 
                                            <div class="col-md-1">
                                                <span id="molen" style="font-weight:bold;"></span>
                                                </div>
                             
                           
                                       
                                                                           
                                   </div>
         <div class="row">
                          
                                       <div class="col-md-4">
                                           <label class="pull-left"><b>Zone</b></label>
			                                <b class="pull-right">:</b>
                                        </div>
                                       <div class="col-md-8">
                                       <asp:ListBox ID="ddlZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindEmpState()"></asp:ListBox>                                                                        
                                       </div> 
                                        <div class="col-md-4">
                                        <label class="pull-left"><b>State</b></label>
			                                <b class="pull-right">:</b>
                                        </div>
                                       <div class="col-md-8">
                                         <asp:ListBox ID="ddlState" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindEmpCity()"></asp:ListBox>
                                       </div>                                      
                                   </div>
          
                         <div class="row">
                                       <div class="col-md-4">
                                           <label class="pull-left"><b>City</b></label>
			                                <b class="pull-right">:</b>
                                       </div>
                                       <div class="col-md-8">
                                      <asp:ListBox ID="ddlCity" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindEmpCenter()"></asp:ListBox>
                                       </div> 
                                        <div class="col-md-4">
                                        <label class="pull-left"><b>Centre</b></label>
			                                <b class="pull-right">:</b>
                                        </div>
                                       <div class="col-md-8">
                                        <asp:ListBox ID="ddlCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                                       </div>                                      
                                   </div>
                                
                                  
            
          <div class="row" style="text-align:center">
                 <input type="button" class="searchbutton" onclick="Save()" id="btnsave" value="Save"/>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <input type="button" class="searchbutton" onclick="AddNew()" id="btnAddNew" value="Clear"/>
                  </div>
                  
         <div class="row">
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



    <td class="GridViewLabItemStyle" style="text-align:left;">
        <img src="../../App_Images/edit.png" style="cursor:pointer" onclick="empEdit(this)" /></td>
 <td class="GridViewLabItemStyle" style="text-align:left;">
        <img src="../../App_Images/Delete.gif" style="cursor:pointer" onclick="empRemove(this)" /></td>
</tr>
          
            <#}#>

</table> 
             
           
    </script>


<%--Default Employee Start--%>
      <asp:Panel ID="defaultpaneldata" runat="server" BackColor="#EAF3FD" BorderStyle="None" style="display:none;z-index:99999; border:1px solid #000;width:720px" >
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
        
                 <div class="row">
                     <div class="col-md-3">
                         <asp:Label ID="defaultlblPopUpError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                     </div>
                 </div>
                                   <div class="row">
                                       <div class="col-md-4">
                                           <label class="pull-left"><b>Name</b></label>
			                                <b class="pull-right">:</b>
                                           </div>
                                       <div class="col-md-12">
                                       <asp:TextBox ID="defaulttxtName" runat="server" ClientIDMode="Static"  CssClass="requiredField" MaxLength="50"/>
                                            <input type="hidden" id="defaulthdnempid" />
                                            <input type="hidden" id="defaulthdEnquiryID" />                                      
                                       </div> 
                                                                          
                                   </div>
                         <div class="row">
                                       <div class="col-md-4">
                                           <label class="pull-left"><b>Mobile No.</b></label>
			                                <b class="pull-right">:</b>
                                            </div>
                                       <div class="col-md-5">
                                        <asp:TextBox ID="defaulttxtMobile" runat="server" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"  MaxLength="10" onkeyup="defaultshowlength()" disabled   ></asp:TextBox>
                                           <a href="#" id="defaultmobilecancel" onclick="defaultCancelMode(this,'defaulttxtMobile')" style="display:none;">Cancel</a>
                                           <input type="hidden" id="defaultIsEditMobile" value="0" />
                                            <input type="hidden" id="defaultoldmobile" value="" /> </div> 
                                           <div class="col-md-1">
                             <span id="defaultmolen" style="font-weight:bold;"></span>
                            <cc1:FilteredTextBoxExtender ID="defaultfltMobile" runat="server" FilterType="Numbers" TargetControlID="defaulttxtMobile" >
                            </cc1:FilteredTextBoxExtender>
                                       </div> 
                                                                       
                                   </div>                         
                                
                                  
            
          <div style="text-align:center; margin-bottom:10px; "class="row">
                 <input type="button" class="searchbutton" onclick="defaultSave()" id="defaultbtnsave" value="Save"/>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <input type="button" class="searchbutton" onclick="defaultAddNew()" id="defaultbtnAddNew" value="Clear"/>
                  </div>
                  
         <div style="text-align:center; margin-bottom:10px; "class="row">
               <div id="defaultdiv_empDetail"></div> 
             </div>

           <div id="defaultempautolist"></div>         
                     
    </asp:Panel>
    <asp:Button ID="defaultButton1" runat="server" style="display:none;" />
  <cc1:modalpopupextender ID="defaultmodelpopup" runat="server" CancelControlID="defaultbtnclosepopup" TargetControlID="defaultButton1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="defaultpaneldata">
    </cc1:modalpopupextender>
<%--Default Employee End--%>

      <script id="tb_centerList" type="text/html">  
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tbl_centerList" width="100%" >
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
        jQuery(function () {
            bindLevelTime();
        });
        function bindLevelTime() {           
            jQuery('#divLeveltimeData').html('');
            PageMethods.bindDelaycheckin_Master(onSuccessEnquery, OnfailureEnquery);
        }
        function onSuccessEnquery(result) {          
            var data = jQuery.parseJSON(result);         
            var count = 0;
            var tbl_row = [];
            if (data.length > 0) {
                tbl_row.push(" <table border='1'  frame='box' id='mtable' style='width:100%;border-collapse:collapse' class='GridViewStyle'>");
                tbl_row.push(" <thead> ");
                tbl_row.push("<th class='GridViewHeaderStyle' >Level1 Time </th>");
                tbl_row.push("<th class='GridViewHeaderStyle' >Level2 Time </th>");
                tbl_row.push("<th class='GridViewHeaderStyle' >Level3 Time </th>");
                tbl_row.push("<th class='GridViewHeaderStyle' >Edit</th>");
                tbl_row.push(" </thead> ");
                tbl_row.push(" <tbody> ");
                tbl_row.push("<tr>");
                tbl_row.push("<td style='width:60px; text-align: center;' class='GridViewLabItemStyle'><span class='lblTxt' ><b>"); tbl_row.push(data[0].Level1Time); tbl_row.push(" </b></span><input type='text' style='display:none;width: 60px;'   class='clsTxt requiredField' id='txt_level1Time' value="); tbl_row.push(data[0].Level1Time); tbl_row.push(" onkeyup='showmehead(this)' /></td>");
                tbl_row.push("<td style='width:60px; text-align: center;' class='GridViewLabItemStyle'><span class='lblTxt'><b>"); tbl_row.push(data[0].Level2Time); tbl_row.push("</b> </span><input type='text' style='display:none;width: 60px;'  class='clsTxt requiredField' id='txt_level2Time' value="); tbl_row.push(data[0].Level2Time); tbl_row.push(" onkeyup='showmehead(this)' /></td>");
                tbl_row.push("<td style='width:60px; text-align: center;' class='GridViewLabItemStyle'><span class='lblTxt'><b>"); tbl_row.push(data[0].Level3Time); tbl_row.push(" </b></span><input type='text' style='display:none;width: 60px;'  class='clsTxt requiredField' id='txt_level3Time' value=" + data[0].Level3Time + " onkeyup='showmehead(this)' /></td>");
                tbl_row.push("<td style='width:60px; text-align: center;' class='GridViewLabItemStyle'><input class='searchbutton' type='Button'  id='btnEdit' Value='Edit' onclick='EditTime()'  /><input type='Button' style='display:none' class='savebutton'  id='btnUpdate' Value='Update' onclick='UpdateTime(");tbl_row.push(data[0].ID);tbl_row.push(")'  /><input type='Button' style='display:none;margin-left: 10px;' class='resetbutton'  id='btnCencel' Value='Cencel' onclick='Cencel()'  /></td>");
                tbl_row.push("<tr>");
                tbl_row.push(" </tbody> ");
                tbl_row.push(" </table> ");
                tbl_row = tbl_row.join("");
                jQuery("#divLeveltimeData").html(tbl_row);               
            }          
        }
        function showmehead(ctrl) {
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');
                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }           
        }
        function OnfailureEnquery(result) {
          
        }
        function EditTime() {
            $("#btnEdit,.lblTxt").hide();
            $("#btnUpdate,#btnCencel,.clsTxt").show();                                 
        }
        function Cencel() {
            $("#btnEdit,.lblTxt").show();
            $("#btnUpdate,#btnCencel,.clsTxt").hide();
        }
        function UpdateTime(id) {
            if ($("#txt_level1Time").val() == "") {
                toast("Error","Please Enter level1 Time");
                $("#txt_level1Time").focus();
                return;
            }
            if ($("#txt_level2Time").val() == "") {
                toast("Error","Please Enter level2 Time");
                $("#txt_leve21Time").focus();
                return;
            }
            if ($("#txt_level3Time").val() == "") {
                toast("Error","Please Enter level3 Time");
                $("#txt_level3Time").focus();
                return;
            }          
            serverCall('HomeCollectionDelayTatMapping.aspx/UpdateTime',
                { ID: id, Level1Time: $("#txt_level1Time").val(), Level2Time: $("#txt_level2Time").val(), Level3Time: $("#txt_level3Time").val() },
             function (result) {
                 if (result == 1) {
                     toast("Success", 'Update successfully.');
                     bindLevelTime();
                 }
                 else {
                     toast("Error", 'Error');
                 }
             });           
        }
        var EmpList = [];
        var defaultEmpList = [];
        function closePopUp() {
            EmpList = [];
            $find("<%=modelpopup.ClientID%>").hide();
            jQuery("#btnsave").val('Save');
        }
        function moreFilterSearch() {         
            jQuery('#lstBusinessZone').multipleSelect("uncheckAll");
            jQuery('#lstBusinessZone').multipleSelect("refresh");
            jQuery("#lstStateData option").remove();
            jQuery('#lstStateData').multipleSelect("refresh");
            jQuery('#lstType').multipleSelect("uncheckAll");
            jQuery('#lstType').multipleSelect("refresh");

            jQuery('#lstTagprocessingLab option').remove();
            jQuery("#lstTagprocessingLab").trigger('chosen:updated');

            if ($(".chosen-container").width() === 0) {
                $("#lstTagprocessingLab_chosen").css('width', '100%');
                jQuery("#lstTagprocessingLab").trigger('chosen:updated');
            }

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
                jQuery(selector).chosen(config[selector]);
            }
            jQuery('[id*=ddlZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=ddlState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery("#ddlCentre").multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=ddlCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=lstBusinessZone],[id*=lstStateData],[id*=lstType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery("#lstTagprocessingLab").trigger('chosen:updated');
            bindBusinessZone();
            BindData();
            defaultBindData();
            jQuery("#btnsearch").click(function () {
                BindData();
                defaultBindData();
            });

        });

    </script>

    <script type="text/javascript">
        
        
       
    </script>

    <script type="text/javascript">
        function bindEmpZone() {
            jQuery('#ddlZone option').remove();
            jQuery('#ddlZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone',
                {},
                function (result) {
                    BusinessZone = jQuery.parseJSON(result);
                    for (i = 0; i < BusinessZone.length; i++) {
                        jQuery('#ddlZone').append($("<option></option>").val(BusinessZone[i].BusinessZoneID).html(BusinessZone[i].BusinessZoneName));
                    }
                    jQuery('[id*=ddlZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                    if (EZoneID == 0) {

                        jQuery('#ddlZone').multipleSelect("setSelects", jQuery("#lstBusinessZone").val());
                    }
                    else {
                        var dataarray = EZoneID.split(",");
                        jQuery('#ddlZone').multipleSelect("setSelects", dataarray);
                    }
                })
        }
        function bindEmpState() {
            jQuery("#ddlState option").remove();
            jQuery('#ddlState').multipleSelect("refresh");
            if (jQuery("#ddlZone").val() != "") {
                serverCall('HomeCollectionDelayTatMapping.aspx/bindState',
                    { BusinessZoneID:  jQuery("#ddlZone").val().toString() },
            function (result) {
                var stateData = jQuery.parseJSON(result);
                for (i = 0; i < stateData.length; i++) {
                    jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                }
                jQuery('[id*=ddlState]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });


                if (EStateID == 0) {
                    $('#ddlState').multipleSelect("setSelects", jQuery("#lstStateData").val());
                }
                else {


                    var dataarray = EStateID.split(",");

                    $('#ddlState').multipleSelect("setSelects", dataarray);
                }
            })
            }
        }
        function bindEmpCity() {
            jQuery('#ddlCity option').remove();
            jQuery('#ddlCity').multipleSelect("refresh");
            serverCall('HomeCollectionDelayTatMapping.aspx/bindCity',
                {StateID: jQuery('#ddlState').val().toString() },
                function (result) {

                    var cityData = jQuery.parseJSON(result);
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

                })
        }
        function bindEmpCenter() {
            jQuery('#ddlCentre option').remove();
            jQuery('#ddlCentre').multipleSelect("refresh");
            serverCall('HomeCollectionDelayTatMapping.aspx/bindCentre',
                { CityID: jQuery("#ddlCity").val().toString(), BusinessZoneID: jQuery("#ddlZone").val().toString() },
                function (result) {
                    if (result != null) {
                        var centreData = jQuery.parseJSON(result);
                        for (i = 0; i < centreData.length; i++) {
                            jQuery("#ddlCentre").append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                        }

                        jQuery("#ddlCentre").multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });

                        if (ECenterID != 0) {
                            var dataarray = ECenterID.split(",");
                            $('#ddlCentre').multipleSelect("setSelects", dataarray);
                        }
                    }
                })           
        }
    </script>
    <script type="text/javascript">
        function BindData() {
            var CentreID = "";
            var StateID = "";
            CentreID = jQuery('#lstType').val().toString();
            StateID = jQuery('#lstStateData').val().toString();
            serverCall('HomeCollectionDelayTatMapping.aspx/BindData',
                {CentrTypeId:  CentreID.toString() , StateId: StateID.toString() ,TagprocessingLabID: jQuery('#lstTagprocessingLab').val() },
                function (result) {
                    PatientData = $.parseJSON(result);
                    if (PatientData.length == 0) {
                        jQuery('#divCenterSearchOutput').empty();
                        return;
                    }
                    var output = jQuery('#tb_centerList').parseTemplate(PatientData);
                    jQuery('#divCenterSearchOutput').html(output);
                })           
        }
    </script>

    <script type="text/javascript">

        function OpenPopup(level, EmpID, CenterID) {
            cleare();
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
            jQuery("#chkEmailCCLevel2,#chkEmailCCLevel3,#chkReopenTicket").prop('checked', false);
            serverCall('HomeCollectionDelayTatMapping.aspx/GetCenter',
                {CenterID: CenterID },
                function (result) {
                    var Center = jQuery.parseJSON(result);
                    EZoneID = Center[0].BusinessZoneID + ",";
                    EStateID = Center[0].StateID + ",";
                    ECityID = Center[0].CityID + ",";
                    ECenterID = Center[0].CentreID + ",";                  
                })
                    bindEmpZone();

                }
                $(function () {
                    $("#<%=txtName.ClientID%>").autocomplete({
                        source: function (request, response) {
                            serverCall('HomeCollectionDelayTatMapping.aspx/SearchEmployee',
                                { query: $("#<%=txtName.ClientID%>").val(), EmpList: EmpList.toString() },
                                 function (data) {
                                     var result = $.parseJSON(data);
                                     response(result);
                                 }, '', false);
                   },
                    focus: function () {
                        return false;
                    },
                    select: function (event, ui) {
                        $("#hdnempid").val(ui.item.value);
                        $("#<%=txtName.ClientID%>").val(ui.item.label);
                       $("#<%=txtMobile.ClientID%>").val(ui.item.Mobile);                                                             
                       return false;
                   },
                    appendTo: "#empautolist"
                });
            });
    </script>

    <script type="text/javascript">
        function Save() {
            if ($("#<%=txtName.ClientID%>").val() == "") {
                toast("Error","Please Enter Name");
                $("#<%=txtName.ClientID%>").focus();
                return;
            }
            if ($("#<%=txtMobile.ClientID%>").val() == "") {
                toast("Error","Please Enter Mobile");
                $("#<%=txtMobile.ClientID%>").focus();
                return;
            }
            if ($("#<%=txtMobile.ClientID%>").val().length != 10) {
                
                toast("Error","Please Enter Valid Mobile No.");
                $("#<%=txtMobile.ClientID%>").focus();
                return;
            }          
            if ($("#<%=ddlCentre.ClientID%>").val() == "") {
                toast("Error","Please Select Centre");
               
                return;
            }


            $('#btnsave').attr('disabled', 'disabled').val('Submiting...');

            var emp = new Object();
            emp.EmpID = jQuery("#hdnempid").val();
            emp.Name = jQuery("#<%=txtName.ClientID%>").val();
            
            emp.Mobile = jQuery("#<%=txtMobile.ClientID%>").val();
            emp.CenterID = jQuery("#<%=ddlCentre.ClientID%>").val();
            emp.Lavel = jQuery('#lblLable').text();
            
            serverCall('HomeCollectionDelayTatMapping.aspx/Save',
                {Data: JSON.stringify(emp) ,CenterID:jQuery("#<%=ddlCentre.ClientID%>").val().toString() },
                function (result) {
                    jQuery('#btnsave').removeAttr('disabled').val('Save');
                    cleare();
                    $find("<%=modelpopup.ClientID%>").hide();
                    BindData();
                    toast("Success","Record Saved Successfully ");
                })
        }
        function cleare() {
            jQuery("#hdnempid").val('');
            jQuery("#<%=txtName.ClientID%>,#<%=txtMobile.ClientID%>").val('');
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
        function showlength() {
            if (jQuery('#<%=txtMobile.ClientID%>').val() != "")
                jQuery('#molen').html($('#<%=txtMobile.ClientID%>').val().length);
            else
                jQuery('#molen').html('');
        }     
    </script>
    <script type="text/javascript">
        function AddNew() {
            jQuery("#txtName,#txtMobile").val('');
          //  jQuery("#txtMobile,#txtemail").removeAttr('disabled');
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
              //  jQuery('#<%=txtMobile.ClientID%>').removeAttr("disabled");
                //jQuery("#IsEditMobile").val("1");
               // jQuery("#editmobile").hide();
            }

            else {
                jQuery('#<%=txtMobile.ClientID%>').attr("disabled", "disabled");
                //jQuery("#IsEditMobile").val("0");
               // jQuery("#editmobile").show();
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
            var Employee_ID = jQuery(rowID).closest('tr').find("#tdEmployee_ID").text();
            var CentreID = jQuery(rowID).closest('tr').find("#tdCentreID").text();
            serverCall('HomeCollectionDelayTatMapping.aspx/removeTagEmployeeDetail',
                {ID:  ID },
                 function (result) {
                     if (result == "1") {
                         jQuery("#lblPopUpError").text('Removed Successfully');
                         jQuery(rowID).closest('tr').remove();
                         EmpList.splice($.inArray(Employee_ID, EmpList), 1);
                         var empHide = "".concat(jQuery("#lblLable").text(), '@', CentreID, '@', Employee_ID);
                         jQuery('span[id="' + empHide + '"]').text('').removeClass('level');
                     }
                     else {
                         jQuery("#lblPopUpError").text('Error..');
                     }
                 })
            
        }
        function BindEmpDetail(CentreID, Level) {
            serverCall('HomeCollectionDelayTatMapping.aspx/BindTagEmployeeDetail',
                {CenterID: CentreID , Level: Level },
                function (result) {
                    empData = $.parseJSON(result);
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
                })
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
        }
        function defaultclosePopUp() {
            defaultEmpList = [];
            $find("<%=defaultmodelpopup.ClientID%>").hide();
            jQuery("#defaultbtnsave").val('Save');
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
                    serverCall('HomeCollectionDelayTatMapping.aspx/SearchEmployee',
                        { query:  $("#<%=defaulttxtName.ClientID%>").val() , EmpList:  defaultEmpList.toString()  },
                         function (data) {
                             var result = $.parseJSON(data);
                             response(result);
                         }, '', false);
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
              $('#defaultbtnsave').attr('disabled', 'disabled').val('Submiting...');
              var emp = new Object();
              emp.EmpID = jQuery("#defaulthdnempid").val();
              emp.Name = jQuery("#<%=defaulttxtName.ClientID%>").val();
              emp.Mobile = jQuery("#<%=defaulttxtMobile.ClientID%>").val();
              emp.Lavel = jQuery('#defaultlblLable').text();
              emp.SubCategoryID = jQuery("#<%=hdncategoryID.ClientID%>").val();
              emp.IsEditMobile = jQuery("#defaultIsEditMobile").val();
              emp.IsEditEmail = jQuery("#defaultIsEditEmail").val();
              serverCall('HomeCollectionDelayTatMapping.aspx/DefaultSave',
                  { Data: JSON.stringify(emp) },
                  function (result) {
                      jQuery('#defaultbtnsave').removeAttr('disabled').val('Save');
                      defaultcleare();
                      $find("<%=defaultmodelpopup.ClientID%>").hide();
                      defaultBindData();
                      toast("Success", "Record Saved Successfully ");
                  })

          }
        function defaultcleare() {
            jQuery("#defaulthdnempid").val('');
            jQuery("#<%=defaulttxtName.ClientID%>,#<%=defaulttxtMobile.ClientID%>").val('');
            jQuery("#defaulthdEnquiryID").val('');
            jQuery('#defaultmobilecancel,#defaultemailcancel,#defaultdiv_empDetail').hide()
            defaultEmpList = [];
            jQuery('#defaultdiv_empDetail').html('');
            jQuery("#defaultlblPopUpError").text('');
            jQuery("#defaultchkReopenTicket,#defaultchkEmailCCLevel2,#defaultchkEmailCCLevel3").prop('checked', false);
        }
        function defaultAddNew() {
            jQuery("#defaulttxtName,#defaulttxtMobile").val('');
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
            jQuery('#defaulthdEnquiryID').val(jQuery(rowID).closest('tr').find("#defaulttdID").text());
            jQuery('#defaultmolen').html($('#<%=defaulttxtMobile.ClientID%>').val().length);

            jQuery('#btnsave').val('Update');
        }
        function defaultempRemove(rowID) {
            var ID = jQuery(rowID).closest('tr').find("#defaulttdID").text();
            var Employee_ID = jQuery(rowID).closest('tr').find("#defaulttdEmployee_ID").text();
            serverCall('HomeCollectionDelayTatMapping.aspx/defaultremoveTagEmployeeDetail',
                {ID: ID },
                 function (result) {
                     if (result == "1") {
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
                 })
        }
        function defaultBindEmpDetail(CentreID, Level) {
            serverCall('HomeCollectionDelayTatMapping.aspx/defaultBindTagEmployeeDetail',
                {CenterID:  CentreID , Level:Level },
                 function (result) {
                     empData = $.parseJSON(result);
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

                 })
        }
    </script>
      <script type="text/javascript">
          function defaultBindData() {
              serverCall('HomeCollectionDelayTatMapping.aspx/defaultBindData',
                  {},
                   function (result) {
                       PatientData = $.parseJSON(result);

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
                               console.log('print k :' + k);
                               if (k <= 1) {
                                   $('#defaultlevel3').append('<span style="margin-left: 5px;" id="Level3@' + PatientData[0].Level3ID.split(',')[k] + '" class="level">' + PatientData[0].Level3.split(',')[k] + '</span>');

                               }
                               if (k >= 2 && k == 2) {
                                   $('#defaultlevel3').append('<span style="margin-left: 5px;" id="Level3" class="level">More...</span>');
                               }
                           }
                       }
                   })
          }
    </script>
    <script type="text/javascript">
        function isValidEmailAddress(emailAddress) {
            var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
            return pattern.test(emailAddress);
        }      
    </script>
    <script type="text/javascript">
        jQuery(function () {
            bindtype();
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

        });

        function bindtype() {
            PageMethods.bindtypedb(onsucessType, onFailureType);
        }
        function onsucessType(result) {
            var typedata = jQuery.parseJSON(result);
            for (var a = 0; a <= typedata.length - 1; a++) {
                jQuery('#lstType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].TEXT));
            }
            jQuery('[id*=lstType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        }
        function onFailureType(result) {

        }
        function bindBusinessZone() {
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone',{},
                function (result) {
                    var BusinessZoneID = jQuery.parseJSON(result);
                    for (i = 0; i < BusinessZoneID.length; i++) {
                        jQuery('#lstBusinessZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                    }
                    jQuery('[id*=lstBusinessZone]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                })
        }
        jQuery('#lstBusinessZone').on('change', function () {
            jQuery('#<%=lstStateData.ClientID%> option').remove();
            jQuery('#lstStateData').multipleSelect("refresh");
            var BusinessZoneID = $(this).val().toString();
            bindBusinessZoneWiseState(BusinessZoneID);
        });
            function bindBusinessZoneWiseState(BusinessZoneID) {
                if (BusinessZoneID != "") {
                    serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState',{ BusinessZoneID: BusinessZoneID },
                        function (result) {
                            stateData = jQuery.parseJSON(result);
                            for (i = 0; i < stateData.length; i++) {
                                jQuery("#lstStateData").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                            }
                            jQuery('[id*=lstStateData]').multipleSelect({
                                includeSelectAllOption: true,
                                filter: true, keepOpen: false
                            });
                        })
                }
            }
            function bindtagprocessingtab() {
                jQuery('#lstTagprocessingLab option').remove();
                jQuery("#lstTagprocessingLab").trigger('chosen:updated');
                var StateID = jQuery('#lstStateData').val().toString();
                var TypeId = jQuery('#lstType').val().toString();
                var ZoneId = jQuery('#lstBusinessZone').val().toString();
                serverCall('HomeCollectionDelayTatMapping.aspx/bindtagprocessinglabLoad',
                    { Type1: TypeId ,btype: $('#<%=rlBusinessType.ClientID%> input:checked').val() ,StateID:StateID ,ZoneId:ZoneId },
                    function (result) {
                        CentreLoadListData = jQuery.parseJSON(result);

                        var CenterData = '';
                        jQuery("#lstTagprocessingLab").append(jQuery('<option></option>').val("-1").html("Select"));
                        jQuery("#lstTagprocessingLab").append(jQuery('<option></option>').val("0").html("ALL"));
                        for (i = 0; i < CentreLoadListData.length; i++) {
                            CenterData += CentreLoadListData[i].CentreID + ',';
                            jQuery("#lstTagprocessingLab").append(jQuery('<option></option>').val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                        }
                        CenterData = CenterData.substring(0, CenterData.length - 1);
                        jQuery("#lstTagprocessingLab").trigger('chosen:updated');
                    })
                
        }
        function clearControl() {
            jQuery('#lstBusinessZone').multipleSelect("uncheckAll");
            jQuery('#lstBusinessZone').multipleSelect("refresh");
            jQuery("#lstStateData option").remove();
            jQuery('#lstStateData').multipleSelect("refresh");
            jQuery('#lstType').multipleSelect("uncheckAll");
            jQuery('#lstType').multipleSelect("refresh");
            jQuery('#lstTagprocessingLab option').remove();
            jQuery("#lstTagprocessingLab").trigger('chosen:updated');
        }
    </script>
</asp:Content>


