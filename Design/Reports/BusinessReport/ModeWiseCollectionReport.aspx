<%@ Page  Language="C#" AutoEventWireup="true" CodeFile="ModeWiseCollectionReport.aspx.cs" Inherits="Design_OPD_ModeWiseCollectionReport" %>
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

            <b>Mode Wise Collection Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <table style="text-align: center; width: 100%;">
                <tr>
                    <td style="width: 20%; text-align: right"> From Bill Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">

                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">To Bill Date :&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                        <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right"> Bill No. :&nbsp;</td>
                     <td style="text-align: left; width: 30%;">

                        <asp:TextBox ID="txtBillNo" runat="server" Width="110px" />
                        
                    </td>
                    <td style="width: 20%; text-align: right">&nbsp;</td>
                    <td style="text-align: left; width: 30%;">
                       <asp:CheckBox ID="chkDeposite" runat="server" Text="Deposite" style="display:none;" /> 

                    </td>
                </tr>
            </table>
            <table style="text-align: center;">
                <tr>
                    <td style="width: 20%; text-align: right">
                        <asp:CheckBox ID="chkCentres" runat="server" Text="Centers" onclick="SelectAllCentres()" /></td>
                    <td colspan="3">
                        <div style="overflow: scroll; height: 366px; width: 1075px; text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chlCentres" CssClass="chkCentre" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="searchbutton" OnClick="btnSearch_Click" OnClientClick="return validate()"/>
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

