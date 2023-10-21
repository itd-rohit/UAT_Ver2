<%@ Page  Language="C#" AutoEventWireup="true" CodeFile="ServiceWiseCollectionReport.aspx.cs" Inherits="Design_OPD_ServiceWiseCollectionReport" %>
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
         <div class="POuter_Box_Inventory" style="text-align: center;" >

            <b>ServiceWise Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory" id="divcentre" runat="server">
            <div class="Purchaseheader">
                Search Criteria
            </div>
             <div class="row">
                <div class="col-md-3">From Bill Date :</div>
                   <div class="col-md-3">  <asp:TextBox ID="txtFromDate" runat="server" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                 <div class="col-md-3"></div>
                  <div class="col-md-3">To Bill Date :</div>
                 <div class="col-md-3"> <asp:TextBox ID="txtToDate" runat="server" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
</div> <div class="col-md-8"></div>
                 </div>
             <div class="row">
                <div class="col-md-3">Bill No. :</div>
                 <div class="col-md-3"> <asp:TextBox ID="txtBillNo" runat="server" /></div>
                 </div>
            </div>
            <div class="POuter_Box_Inventory" runat="server" id="divclient">
             <div class="Purchaseheader">
             <div class="row">
                <div class="col-md-24"><asp:CheckBox ID="chkCentres" runat="server" Text="Client/Panel" onclick="SelectAllCentres()" /></div>
                 </div>
                 </div>
                 <div class="row">
                 <div class="col-md-24"> <div style="overflow: scroll; height: 100px;text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chlCentres" runat="server" RepeatColumns="5" RepeatDirection="Horizontal" CssClass="chkCentre">
                            </asp:CheckBoxList>
                        </div></div>
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
            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="searchbutton" OnClick="btnSearch_Click"  OnClientClick="return validate()"/>
            </div>
    </div>
        </div>

   
    <script type="text/javascript">
        function validate() {
            if ($(".chkCentre input[type=checkbox]:checked").length == 0) {
                $("#lblMsg").text('Please Select Centre');
                return false;
            }
            else
                return true;
        }
        function SelectAllCentres() {
            var chkBoxList = document.getElementById('<%=chlCentres.ClientID %>');
            var chkBoxCount = chkBoxList.getElementsByTagName("input");
            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkCentres.ClientID %>').checked;
            }
        }

    </script>

</form>
</body>
</html>

