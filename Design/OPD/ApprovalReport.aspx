<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ApprovalReport.aspx.cs" Inherits="Design_OPD_ApprovalReport" Title="Untitled Page" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" language="javascript" src="../../Design/Common/popcalendar.js"></script>
    <script type="text/javascript">
        function SelectAllDoctors() {
            var chkBoxList = document.getElementById('<%=chlDoctors.ClientID %>');

          var chkBoxCount = chkBoxList.getElementsByTagName("input");

          for (var i = 0; i < chkBoxCount.length; i++) {
              chkBoxCount[i].checked = document.getElementById('<%=chkDoctors.ClientID %>').checked;
               }

           }
           function SelectAllTest() {
               var chkBoxList = document.getElementById('<%=chlTest.ClientID %>');

         var chkBoxCount = chkBoxList.getElementsByTagName("input");

         for (var i = 0; i < chkBoxCount.length; i++) {
             chkBoxCount[i].checked = document.getElementById('<%=chkTest.ClientID %>').checked;
               }

           }
        function SelectAllCentre() {
            var chkBoxList = document.getElementById('<%=chlCentre.ClientID %>');

             var chkBoxCount = chkBoxList.getElementsByTagName("input");

             for (var i = 0; i < chkBoxCount.length; i++) {
                 chkBoxCount[i].checked = document.getElementById('<%=chkCentre.ClientID %>').checked;
         }

        }
        function SelectAllDept() {
            var chkBoxList = document.getElementById('<%=chlDept.ClientID %>');

             var chkBoxCount = chkBoxList.getElementsByTagName("input");

             for (var i = 0; i < chkBoxCount.length; i++) {
                 chkBoxCount[i].checked = document.getElementById('<%=chkDept.ClientID %>').checked;
             }

         }
        
    </script>
    <div id="Pbody_box_inventory" style="width: 97%">
        <div class="POuter_Box_Inventory" style="width: 99.6%">
            <div class="content">
                <div style="text-align: center">
                    <b>Lab Approval Report</b><br />
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="content" style="text-align: center">
                <table style="text-align: center; width: 56%; height: 8px;" cellpadding="0" cellspacing="0">
                    <tr>
                        <%--<td style="width: 99px; text-align: left">Date From</td>
                        //priya--%>
                    <td style="width: 99px; text-align: left">  <asp:DropDownList ID="ddldatetype" runat="server" CssClass="ItDoseTextinputText" Width="150px">                           
                                    <asp:ListItem Value="Date(plo.Date)" Selected="True">Registration Date</asp:ListItem>
                            <asp:ListItem Value="Date(plo.ApprovedDate)" >Approve Date</asp:ListItem>
                         <asp:ListItem Value="DATE(`ResultEnteredDate`)" >Result Entry Date</asp:ListItem>
                        
                            
                        </asp:DropDownList></td>
                        <td style="text-align: left; width: 300px;">&nbsp;
                         <uc1:EntryDate ID="FrmDate" runat="server" />
                        </td>
                        <td style="width: 300px; text-align: left"></td>
                        <td style="width: 72px">To</td>
                        <td style="text-align: left; width: 300px;">
                            <uc1:EntryDate id="ToDate" runat="server"></uc1:EntryDate>
                        </td>
                    </tr> 
                </table> 
                <table>
                    <tr>
                        <td>
                            Report Type-I 
                        </td>
                        <td>
                             <asp:RadioButtonList ID="rbtnReportType" runat="server" RepeatDirection="Horizontal"
                                Visible="true">
                                <asp:ListItem Selected="True" Value="0">Summary</asp:ListItem>
                                <asp:ListItem Value="1">Detail</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Report Type-II
                        </td>
                        <td>
                            <asp:DropDownList ID="ddl_type" runat="server" OnSelectedIndexChanged="ddl_type_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Value="0" Selected="True">Doctor Wise & Approved By</asp:ListItem>
                                <asp:ListItem Value="1">Result Enterd By</asp:ListItem>
                                <%--<asp:ListItem Value="2">Technician By</asp:ListItem>--%>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Report Format
                        </td>
                        <td>
                             <asp:RadioButton ID="rdoPDF" runat="server" GroupName="PrintType" Text="PDF" Checked="true" style="display:none;"/>
                            <asp:RadioButton ID="rdoExcel" runat="server" GroupName="PrintType" Text="Excel" Checked="true"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkCentre" runat="server" Text="Centre" onclick="SelectAllCentre()" CssClass="ItDoseCheckbox" /></div>
            <div class="content" style="text-align: left; max-height:120px; overflow: auto;">
                <asp:CheckBoxList ID="chlCentre" runat="server" RepeatColumns="5" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist">
                </asp:CheckBoxList>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkDoctors" runat="server" Text="Users" onclick="SelectAllDoctors()" CssClass="ItDoseCheckbox" /></div>
            <div class="content" style="text-align: left; max-height:170px; overflow: auto;">
                <asp:CheckBoxList ID="chlDoctors" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist">
                </asp:CheckBoxList>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkDept" runat="server" Text="Department" onclick="SelectAllDept()" CssClass="ItDoseCheckbox" /></div>
            <div class="content" style="text-align: left; max-height:120px; overflow: auto;">
                 <asp:CheckBoxList ID="chlDept" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist">
                        </asp:CheckBoxList>
            </div>
        </div> 
        <div class="POuter_Box_Inventory" style="width: 99.6%">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkTest" runat="server" Text="Test" onclick="SelectAllTest()" CssClass="ItDoseCheckbox" /></div>
            <div class="content" style="text-align: left; max-height:120px; overflow: auto;">
                 <asp:CheckBoxList ID="chlTest" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist">
                        </asp:CheckBoxList>
            </div>
        </div>  
         <div class="POuter_Box_Inventory" style="width: 99.6%"> 
            <div class="content" style="text-align: center; max-height: 200px; overflow: auto;">
                 <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click" />
                </div>
            </div>
        </div>  
</asp:Content>

