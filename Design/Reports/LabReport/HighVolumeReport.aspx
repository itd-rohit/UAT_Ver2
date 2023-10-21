<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HighVolumeReport.aspx.cs" Inherits="Design_OPD_HighVolumeReport" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" /> 

    </head>
    <body >     
       <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
</Scripts>
</Ajax:ScriptManager>
    <div class="POuter_Box_Inventory">
    <div class="row" style="text-align:center;"> 
        <div class="col-md-24">
    <b>High Volume Test Report</b>&nbsp;<br />
         <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>  </div>    
   </div>
   <div class="POuter_Box_Inventory" id="div1" runat="server"> 
       <div class="Purchaseheader">
    Search Criteria
    </div>     
          <div class="row">
           <div class="col-md-4">Department Name:</div>
                <div class="col-md-4">  <asp:DropDownList ID="ddlDepartment" runat="server"></asp:DropDownList>
               </div>
               <div class="col-md-4">Panel Name:</div>
              <div class="col-md-4"><asp:DropDownList ID="ddlPanel" runat="server" ></asp:DropDownList></div>
              </div>
       <div class="row">
           <div class="col-md-4"> Booking Center Name:  <asp:CheckBox ID="chCentres" runat="server" onclick="SelectAll('Centre')" /></div>
           <div class="col-md-20" style="height:100px;overflow:scroll;border:double">
               <asp:CheckBoxList ID="chkCentre" runat="server"   RepeatDirection="Horizontal" RepeatColumns="6" TextAlign="Right" ></asp:CheckBoxList>
           </div></div>
       <div class="row">
           <div class="col-md-4">Test Center Name:  <asp:CheckBox ID="chCentresTests" runat="server" onclick="SelectAllTest('Centre')" /></div>
           <div class="col-md-20" style="height:100px;overflow:scroll;border:double">
               <asp:CheckBoxList ID="chCentresTest" runat="server"   RepeatDirection="Horizontal" RepeatColumns="6" TextAlign="Right" ></asp:CheckBoxList>
           </div></div>
         <div class="row">
                <div class="col-md-4"> <span class="filterdate">From Date :</span> </div>
                <div class="col-md-3">
                      <asp:TextBox ID="txtfromdate" runat="server"  class="filterdate" />
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                </div>
                <div class="col-md-4"> <span class="filterdate">To Date :</span> </div>
                <div class="col-md-3">
                     <asp:TextBox ID="txttodate" runat="server"  class="filterdate" />
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                </div>
            </div>
        <div class="row">
           <div class="col-md-4">Report Type:</div>
              <div class="col-md-8"><asp:RadioButtonList ID="rbtReportType" runat="server" Height="33px"   RepeatDirection="Horizontal">
   <asp:ListItem  Text="Summary" Value="1" Selected="True" ></asp:ListItem>
   <asp:ListItem  Text="Detailed" Value="2" ></asp:ListItem>
   
   </asp:RadioButtonList></div>
            </div>       
    </div>          
        <div class="POuter_Box_Inventory" id="div2" runat="server" >
             <div class="row" style="text-align:center;" >
                     <div class="col-md-4"><asp:RadioButtonList ID="rblReportformat" runat="server" RepeatDirection="Horizontal">
   <asp:ListItem  Text="Pdf" Value="1" Selected="True" ></asp:ListItem>
   <asp:ListItem  Text="Excel" Value="2" ></asp:ListItem>
   
   </asp:RadioButtonList></div>
                 <div class="col-md-16">
                 <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton"  Text="Report" OnClick="btnSearch_Click"  /></div>

                  <div class="col-md-4"></div>
        </div>                           
   </div>
      <script type="text/javascript">
     
          function SelectAll(Type) {
              if (Type == "Centre") {
                  var chkBoxList = document.getElementById('<%=chkCentre.ClientID %>');
                var chkBoxCount = chkBoxList.getElementsByTagName("input");
                for (var i = 0; i < chkBoxCount.length; i++) {
                    chkBoxCount[i].checked = document.getElementById('<%=chCentres.ClientID %>').checked;
                }
            }          
          }
          function SelectAllTest(Type) {
              if (Type == "Centre") {
                  var chkBoxList = document.getElementById('<%=chCentresTest.ClientID %>');
                  var chkBoxCount = chkBoxList.getElementsByTagName("input");
                  for (var i = 0; i < chkBoxCount.length; i++) {
                      chkBoxCount[i].checked = document.getElementById('<%=chCentresTests.ClientID %>').checked;
                }
            }
        }
    </script>
</form>
</body>
</html>
