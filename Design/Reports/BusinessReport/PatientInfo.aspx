<%@ Page  Language="C#" AutoEventWireup="true" CodeFile="PatientInfo.aspx.cs" Inherits="Design_OPD_PatientInfo" Title="Patient Information Report" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 

    </head>
    <body >
    
         <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
    <asp:ScriptReference Path="~/Scripts/CheckboxSearch.js" />
</Scripts>
</Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Patient Information Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory" runat="server" id="divcentre">
            <div class="Purchaseheader">
                  <div class="row">
                      <div class="col-md-24"> Centre <asp:CheckBox ID="chkCentres" runat="server" Text="Select All Centers" onclick="SelectAll('Centre')" /></div>
                  </div>
               
            </div> 
             <div class="row">
           <div id="" style="overflow:scroll; height:100px;" class="col-md-24">
             <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>                       
               </div>
                 </div>
             </div>
         <div class="POuter_Box_Inventory" runat="server" id="divdept">
            <div class="Purchaseheader">
                <div class="row">
                      <div class="col-md-24">
                Department <asp:CheckBox ID="chkAllDept" runat="server" Text="Select All Department" onclick="SelectAll('Dept')" ClientIDMode="Static"/>
                          </div>
                    </div>
            </div> 
              <div class="row">
           <div id="Div1" style="overflow:scroll; height:120px;" class="col-md-24">
             <asp:CheckBoxList ID="chkDept" runat="server" RepeatColumns="7" RepeatDirection="Horizontal" CssClass="chkDepartment"></asp:CheckBoxList>                       
               </div>
                  </div>
             </div>
        <div class="POuter_Box_Inventory"  runat="server" id="divuser">           
           <div class="row">   
               <div class="col-md-12">
                     <asp:RadioButtonList ID="rbtReportType" AutoPostBack="false" runat="server" RepeatDirection="Horizontal" onchange="ReportType()" ClientIDMode="Static">                                  
                                <asp:ListItem Value="0" Selected="True">Summary(Patient List Without Test)</asp:ListItem>                                
                                <asp:ListItem Value="1">Detail(Patient List With Test)</asp:ListItem>                                
                                </asp:RadioButtonList>
               </div>
              <div class="col-md-12">
                   <asp:CheckBox ID="chkOnlyDue" runat="server" Text="Only Due Patient" />
                                <asp:CheckBox ID="chkOnlyDiscount" runat="server" Text="Only Discount Patient" />
              </div>
               </div>
             <div class="row">   
               <div class="col-md-3">From Date : </div>
            
                   <div class="col-md-3"> <asp:TextBox ID="txtFromDate" runat="server" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                 <div class="col-md-3">Time :<asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="80px" ToolTip="Enter Time" />
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99:99" runat="server" MaskType="Time"
                            TargetControlID="txtFromTime" AcceptAMPM="false">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator></div>
                   <div class="col-md-3">To Date :</div>                 
                   <div class="col-md-3"> <asp:TextBox ID="txtToDate" runat="server" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                 <div class="col-md-3">Time :
                        <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="80px" ToolTip="Enter Time"
                            TabIndex="4" />
                        <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99:99" runat="server" MaskType="Time"
                            TargetControlID="txtToTime" AcceptAMPM="false">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator> </div>
                   <div class="col-md-12"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Text="PDF" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Excel" Value="2" ></asp:ListItem>
                        </asp:RadioButtonList></div>
                  </div>                         
              
             </div>                             
       <div class="POuter_Box_Inventory" style="text-align: center;"  runat="server" id="divsave">
        <div class="row">   
               <div class="col-md-24">
            <asp:Button ID="btnPDFReport" runat="server" Text="Report" CssClass="searchbutton" OnClick="btnPDFReport_Click"/>  
                   </div>
            </div>          
        </div>

    
     <script type="text/javascript"> 
         $(function () {
             ReportType();
         });
         function SelectAll(Type) {
             if (Type == "Centre") {
                 var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
                 }
             }
             else {
                 var chkBoxList = document.getElementById('<%=chkDept.ClientID %>');
                 var chkBoxCount = chkBoxList.getElementsByTagName("input");
                 for (var i = 0; i < chkBoxCount.length; i++) {
                     chkBoxCount[i].checked = document.getElementById('<%=chkAllDept.ClientID %>').checked;
                 }
             }
        }
         function ReportType() {
             if ($("#rbtReportType input[type=radio]:checked").val() == "2") {
                 $("#chkAllDept").prop('checked', false).attr('disabled', 'disabled');
                 $(".chkDepartment input[type=checkbox]").prop('checked', false).attr('disabled', 'disabled');
             }
             else {
                 $("#chkAllDept").prop('checked', false).removeAttr('disabled');
                 $(".chkDepartment input[type=checkbox]").removeAttr('disabled');
             }
         }

 </script>
</form>
</body>
</html>

