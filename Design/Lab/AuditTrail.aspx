<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AuditTrail.aspx.cs" Inherits="Design_Lab_AuditTrail" %>



<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
   
<Ajax:ScriptManager id="ScriptManager1" runat="server"></Ajax:ScriptManager>
                    
 <div id="Pbody_box_inventory" >
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align:center;">    
    <b>Audit Trail Report</b><br /><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />      
    </div>
    </div> 
    
    <div class="POuter_Box_Inventory">
          <div class="Purchaseheader">
              Search</div>
    <div class="content"> 
        <table style="width: 956px">
            <tr>
                <td style="width: 136px; text-align: right;">
                    <b>Centre :</b></td>
                <td colspan="3">
                     <asp:DropDownList ID="ddlcentre" runat="server" class="ddlcentre  chosen-select chosen-container" Width="400px" >
                              </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="width: 136px; text-align: right;">
                    <b>Date From :</b></td>
                <td style="width: 250px">
                   <asp:TextBox ID="txtFormDate"  runat="server"  Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtFormDate" />
                </td>
                <td style="width: 250px;text-align:right; font-weight: 700;">
                    To Date :&nbsp; </td>
                 <td style="width: 250px;">
                   <asp:TextBox ID="txtToDate"    runat="server"   Width="100px"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtToDate" />
                </td>
            </tr>
            <tr>
                <td style="width: 136px; text-align: right;">
                    <b>
                   <asp:Label ID="lblLabNo" Text="Visit No" runat="server"></asp:Label>&nbsp;:</b></td>
                <td style="width: 250px">
                     <asp:TextBox ID="txtLabNo" runat="server"></asp:TextBox></td>
                <td style="width: 250px;text-align:right;">
                  </td>
                 <td style="width: 250px;">
                 <div id="spid" style="display:none;"><asp:CheckBox ID="chkdue" runat="server" Text=" Due Only"  /></div>  </td>
            </tr>
            <tr>
                <td style="width: 136px; text-align: right;">
                    &nbsp;</td>
                <td colspan="3">
                    &nbsp;</td>
            </tr>
   
        </table>
    </div>
    
    </div> 
    
     <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">
        Report Type</div>
    <div class="content"> 
        <asp:RadioButtonList ID="rbtnSelect" runat="server" RepeatDirection="Horizontal" style="font-weight: 700" RepeatColumns="5">
            
            <asp:ListItem Value="1" Selected="True">Patient Demographic</asp:ListItem>
              <asp:ListItem Value="4">Doctor Data</asp:ListItem>
             <asp:ListItem Value="2" >Booking Edit</asp:ListItem>
            
            <asp:ListItem Value="3">Lab Data</asp:ListItem>
        
           <asp:ListItem Value="5">Report Not Approval Data</asp:ListItem>
              <asp:ListItem Value="6">Lab Observation Range Data</asp:ListItem>
                <asp:ListItem Value="7">Item Rate Data</asp:ListItem>
        </asp:RadioButtonList>&nbsp;</div>
    </div> 
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align: center">    
    <asp:Button ID="btnSave" runat="server" CssClass="searchbutton" Text="Search" OnClick="btnSave_Click" /></div>    
    </div>
    </div> 

    
    <script type="text/javascript">


        var centreid = '<%=UserInfo.Centre%>';

        $(document).ready(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
           
        });


       
    </script>

     </asp:Content>

