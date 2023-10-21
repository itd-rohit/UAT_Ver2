<%@ Page Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="UserBy_Discount_Report.aspx.cs" Inherits="Design_OPD_UserBy_Discount_Report" %>

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
            <b>User By Discount Report</b>         
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" id="divcentre" runat="server" >
            <div class="Purchaseheader">
                Searching Criteria
            </div>        
            <div class="row">
                <div class="col-md-2"> From Date : </div>
                 <div class="col-md-2">
                       <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                </div>
                 <div class="col-md-2">Time : </div>
                 <div class="col-md-2"><asp:TextBox ID="txtFromTime" runat="server"/>  
                     <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtFromTime" Mask="99:99:99" MaskType="Time"
                                CultureName="en-gb" ClearMaskOnLostFocus="false" UserTimeFormat="TwentyFourHour" /> </div>
                 <div class="col-md-4"></div>
                 <div class="col-md-2">To Date : </div>
                <div class="col-md-2"> <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender></div>
                 <div class="col-md-2">Time :</div>
                 <div class="col-md-2"><asp:TextBox ID="txtToTime" runat="server"/>
                      <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtToTime" Mask="99:99:99" MaskType="Time"
                                CultureName="en-gb" ClearMaskOnLostFocus="false" UserTimeFormat="TwentyFourHour" />
                 </div>
                <div class="col-md-4"></div>
            </div>  
             <div class="row">
                 <div class="col-md-2">Center :</div>
                 <div class="col-md-4"> <asp:DropDownList ID="ddlcenter" runat="server">
                            </asp:DropDownList></div>
             </div>
             <div class="row"  style="height:300px;overflow-y:scroll;">
                 <div class="col-md-2">Select All User :
                     <asp:CheckBox ID="chkCentres" runat="server" onclick="SelectAll('User')" />
                 </div>
                 <div class="col-md-4"><asp:CheckBoxList ID="cblUser" CssClass="ItDoseCheckbox" Font-Size="8" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="16" /></div>
                 </div>
         
            </div>
      <div class="POuter_Box_Inventory"  runat="server" id="divuser">           
             <div class="row">   
                   <div class="col-md-12"><asp:RadioButtonList ID="rdoReportFormat" runat="server" RepeatDirection="Horizontal" >
                            <asp:ListItem Text="PDF" Selected="True" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Excel" Value="2" ></asp:ListItem>
                        </asp:RadioButtonList></div>
                  </div>                         
              
             </div> 
            <div class="POuter_Box_Inventory" runat="server" style="text-align: center;" id="divsave">
    <div class="row">
        <div class="col-md-24">
             <asp:Button ID="btnPreview" runat="server" Text="Report" OnClick="btnPreview_Click" CssClass="searchbutton" />
        </div>
    </div>
               
            </div>
     
        <script type="text/javascript">
            function SelectAll(Type) {
               
                    var chkBoxList = document.getElementById('<%=cblUser.ClientID %>');
                var chkBoxCount = chkBoxList.getElementsByTagName("input");
                for (var i = 0; i < chkBoxCount.length; i++) {
                    chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked; 
                    }
                


            }
            function CheckTransType() {
                var stat = false;
                var ctrl = document.getElementById("cblColType");
                var arrayOfCheckBoxes = ctrl.getElementsByTagName("input");
                for (var i = 0; i < arrayOfCheckBoxes.length; i++)
                    if (arrayOfCheckBoxes[i].checked)
                        stat = true;
                if (stat == false) {
                    alert('Select Collection Type');
                }
                else {
                    _dopostback(btnPrint);
                }
            }
    </script>

</form>
</body>
</html>
