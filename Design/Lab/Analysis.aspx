<%@ Page Title="Machine Output Analysis" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Analysis.aspx.cs" Inherits="Design_Machine_Analysis" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
     <script type="text/javascript" src="../../JavaScript/jquery-1.3.2.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#<%=chkMachine.ClientID %>').click(function () {

                if ($('[id$=chkMachine]').is(':checked')) {
                    $('input[type="checkbox"]').each(function () {
                        $(this).attr('checked', 'checked');
                    });

                } else {
                    $('input[type="checkbox"]').each(function () {
                        $(this).removeAttr('checked');
                    });
                }

            



            });

        });
    </script>
<div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Machine Output Analysis</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

                   </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
                
              <div>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  From :<asp:TextBox ID="txtFrom" runat="server"></asp:TextBox>
                  <asp:TextBox ID="txtFromTime" runat="server" CssClass="ItDoseTextinputText" Width="75px"></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="ce_dtfrom"
    TargetControlID="txtFrom"
    Format="yyyy-MM-dd"
    PopupButtonID="txtFrom" />

&nbsp;To:<asp:TextBox ID="txtTo" runat="server"></asp:TextBox>
         <asp:TextBox ID="txtToTime" runat="server" CssClass="ItDoseTextinputText" Width="75px"></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="CalendarExtender1"
    TargetControlID="txtTo"
    Format="yyyy-MM-dd"
    PopupButtonID="txtTo" />

            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"  TargetControlID="txtFromTime" Mask="99:99:99" MaskType="Time"
                        CultureName="en-gb" ClearMaskOnLostFocus="false" UserTimeFormat="TwentyFourHour">
        </cc1:MaskedEditExtender>
        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtToTime" Mask="99:99:99" MaskType="Time"
                        CultureName="en-gb" ClearMaskOnLostFocus="false" UserTimeFormat="TwentyFourHour">
        </cc1:MaskedEditExtender>

              &nbsp;&nbsp;
              
              </div>
              

                 <table align="left" cellpadding="0" cellspacing="0" style="width: 878px">
                <tr>
                    <td style="width: 107px; text-align: left">
                        <asp:CheckBox ID="chkMachine" runat="server"  CssClass="ItDoseCheckbox"   Text="Machine" /></td>
                    <td colspan="4" style="width: 400px">
                        <div style="border-right: 1px solid; border-top: 1px solid; overflow: scroll; border-left: 1px solid;
                                width: 768px; border-bottom: 1px solid; height: 100px; text-align: left" id="Div2" >
                            <asp:CheckBoxList ID="chkMachineList" runat="server" CssClass="ItDoseCheckboxlist"
                                    RepeatColumns="4" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            
            </table>

            </div>
        </div>


             <div class="POuter_Box_Inventory" style="text-align:center; ">
              <asp:Button ID="btnReport" runat="server" Text="Report" 
                     onclick="btnReport_Click" />
     </div>  
</div>



</asp:Content>

