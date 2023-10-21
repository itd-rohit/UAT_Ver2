<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Appointmentreport.aspx.cs" Inherits="Appointmentreport" Title="Untitled Page" %>
<%--<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>--%>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
     <link href="../../App_Style/toastrsample.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
      <script type="text/javascript">   
          $(function(){
             
          });
          function GetMacAddress()
          {
              //This function requires following option to be enabled without prompting
              //In Internet Options for IE 5.5 and up
              //Tab Security (Local Internet Sites)
              //Custom Level button
              //"Initialize and script ActiveX control not marked as safe." option enabled
              try
              {
                  var locator = new ActiveXObject("WbemScripting.SWbemLocator");
                  var service = locator.ConnectServer(".");

                  //Get properties of the network devices with an active IP address
                  var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration" +
                  " WHERE IPEnabled=TRUE");

                  var e = new Enumerator(properties);

                  //Take first item from the list and return MACAddress
                  var p = e.item(0);
              }
              catch (exception) {
                  alert('Add your domain to Trusted Sites.');
                  
              }
    
              return p.MACAddress;
          }
function CheckBoxListSelect1(Chk,chl)
{ 
       var chh=document.getElementById(Chk).value;
      
       
          
       
       var chkBoxList = chl;
       
       var chkBoxCount= chkBoxList.getElementsByTagName("input");
        
               for(var i=0;i<chkBoxCount.length;i++)
        {
            chkBoxCount[i].checked = document.getElementById(Chk).checked;
        }
       
}
     
    </script>
<script type="text/javascript">

</script>
<div id="Pbody_box_inventory">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Appointment Report</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        </div>
         <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
            <table style="width: 927px; float:left;">
                    <tr>
                    <td>From Date</td>
                    <td>: <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server"  Width="100px"></asp:TextBox>
                <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
</td>
                    <td></td>
                    <td>To Date</td>
                    <td><asp:TextBox ID="txtToDate" CssClass="ItDoseTextinputText" runat="server" Width="100px"></asp:TextBox>
                <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
                    </td>
                    </tr>
                <tr>
                    <td>Phlebo
                    </td>
                    <td>: 
                    <asp:DropDownList ID="ddlhomevisit" runat="server" Width="153px"></asp:DropDownList>
                    </td>
                    <td>
                    </td>
                    <td>Only Cancel
                    </td>
                    <td>: <asp:CheckBox ID="iscancel" runat="server" Text="Only For Cancel" />
                    </td>
                </tr>
                <tr>
                    <td>Panel
                    </td>
                    <td>: <asp:DropDownList ID="ddlpanel" runat="server" Width="153px">
                    <asp:ListItem value="ALL" Selected="true">ALL</asp:ListItem>
                    <asp:ListItem value="00">Panel</asp:ListItem>
                    <asp:ListItem Value="78" >Standard</asp:ListItem>
                    </asp:DropDownList>
                    </td>
                    <td>
                    </td>
                    <td>Date Type
                    </td>
                    <td>: <asp:DropDownList ID="ddlDateType" runat="server">
                    <asp:ListItem Selected="true" Value="lad.AppointmentDate">Appointment Date</asp:ListItem>
                    <asp:ListItem Value="lad.DateEnrolled">Booking Date</asp:ListItem>
                    </asp:DropDownList>
                    </td>
                </tr>
                    </table>
        </div>
         </div>
        <div class="POuter_Box_Inventory">
         <div class="Purchaseheader">
         <input id="chkCentre" type="checkbox"  value="Users"  onclick="CheckBoxListSelect1('chkCentre',document.getElementById('<%=chklstCenter.ClientID %>'))"  />Select Centre :</div>
            <div class="content" style="text-align: left;">
             <table><tr><td>
              <asp:CheckBoxList ID="chklstCenter" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
              </td>
                        </tr>
               </table>
            </div>
            </div>
       <div class="POuter_Box_Inventory">
       
            <div class="POuter_Box_Inventory">
       <div class="Purchaseheader">Report Formate :</div>
            <div class="content" style="text-align: left;">
             <table>
                        <tr>
                            <td colspan="5">
                             <asp:RadioButtonList ID="rblReportFormat" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="Excel" Selected="True">Excel</asp:ListItem>
                                </asp:RadioButtonList>
                             </td>
                        </tr>
               </table>
            </div>
            </div>
            <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
           
                 <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Width="60px" Text="Search"
                    OnClick="btnSearch_Click" /> 
                <input type="button" value="Click" onclick="click1()" />
                     </div>
        </div>
       
</div>
</div>

<script type="text/javascript">
    function click1()
    {
        toast('Warning','POuter_Box_Inventory','');
    }
</script>
    </asp:Content>
