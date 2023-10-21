<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="TATReportGraph.aspx.cs" Inherits="Design_EDP_TATReportGraph" %>
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
</Scripts>
</Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center;">
                <b>TAT Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                        </div>
        </div> 
        
         <div class="POuter_Box_Inventory">
             <div class="Purchaseheader">
   Graph Report
    </div>
             <div class="row">
                 <div class="col-md-4">From Date : </div>
                 <div class="col-md-4"><asp:TextBox ID="txtfromdate" runat="server"></asp:TextBox>
                      <cc1:CalendarExtender runat="server" ID="ce_dtfrom"  TargetControlID="txtfromdate"  Format="dd-MMM-yyyy" PopupButtonID="txtfromdate" />
                 </div>
                  <div class="col-md-4"><label class="pull-right">To Date :</label></div>
                  <div class="col-md-4"><asp:TextBox ID="txttodate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="CalendarExtender1" TargetControlID="txttodate"  Format="dd-MMM-yyyy" PopupButtonID="txttodate" />
                  </div>
                  <div class="col-md-4"></div>
             </div>
            
                 <div class="Purchaseheader">
                      <div class="row">
                     <div class="col-md-24">
                <asp:CheckBox ID="chkAllCentre" runat="server" Text="Select All Centre" CssClass="ItDoseCheckbox" />
                         </div>
            </div></div>
             <div class="row">
                   <div class="col-md-24"><asp:CheckBoxList ID="ChlCenters" runat="server" CssClass="ItDoseCheckboxlist"
                        RepeatColumns="10" RepeatDirection="Horizontal" >
                    </asp:CheckBoxList></div>
                 </div>
            
                 <div class="Purchaseheader">  <div class="row">
                     <div class="col-md-24">
                <asp:CheckBox ID="chkAllDepartment" runat="server" Text="Select All Department" CssClass="ItDoseCheckbox" />
                         </div>
            </div>
                 </div>
               <div class="row">
                   <div class="col-md-24"> <asp:CheckBoxList ID="cbDepatment" runat="server" CssClass="ItDoseCheckboxlist"
                        RepeatColumns="10" RepeatDirection="Horizontal" > </asp:CheckBoxList></div>
                   </div>
             </div>
              <div class="POuter_Box_Inventory">
                  <div class="row">
                      <div class="col-md-4"><label class="pull-right">Type Of Report :</label> </div>
                   <div class="col-md-8"><asp:RadioButtonList ID="rptype" runat="server" AutoPostBack="true" RepeatDirection="Horizontal" OnSelectedIndexChanged="rptype_SelectedIndexChanged">
                                      <asp:ListItem Value="1" Text="Department Wise" Selected="True"></asp:ListItem>
                                      <asp:ListItem Value="2" Text="Test Wise"></asp:ListItem>
             
                                      </asp:RadioButtonList></div>
                         <div class="col-md-4">
                  <asp:Button ID="btnshowtest" runat="server" Text="Show Test" OnClick="btnshowtest_Click"/></div>
                      </div>
                 
                       <div class="Purchaseheader">  <div class="row">
                     <div class="col-md-24">
                <asp:CheckBox ID="chkalltest" runat="server" Text="Select All Test" CssClass="ItDoseCheckbox" />
                         </div>
            </div>
                 </div>
                   <div class="row" style="overflow:scroll;height:100px">
                      <div class="col-md-4">
        <asp:CheckBoxList ID="cblTest" runat="server" CssClass="ItDoseCheckboxlist"
                        RepeatColumns="10" RepeatDirection="Horizontal" >
                    </asp:CheckBoxList>
                          </div>
                    
        </div>
      </div>
        
           <div class="POuter_Box_Inventory" style="text-align:center;">
    
    
<asp:Button ID="Button1" runat="server" Text="Show TAT" OnClick="Button1_Click" />
    </div>
               <script type="text/javascript">
                
                       $("#<%=chkAllCentre.ClientID %>").click(function () {
                 $('#<%=ChlCenters.ClientID %> :checkbox').prop('checked', $(this).prop('checked'));
             });

             $("#<%=chkAllDepartment.ClientID %>").click(function () {
                 $('#<%=cbDepatment.ClientID %> :checkbox').prop('checked', $(this).prop('checked'));
             });
                   $("#<%=chkalltest.ClientID %>").click(function () {
                       $('#<%=cblTest.ClientID %> :checkbox').prop('checked', $(this).prop('checked'));
                   });
    </script>
</form>
</body>
</html>

