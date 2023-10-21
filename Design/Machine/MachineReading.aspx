<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true"
    CodeFile="MachineReading.aspx.cs" Inherits="Design_Machine_MachineReading" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
function getMachineParam(MachineID,MachineParamID)
{
var objWin=window.open("MachineParam.aspx?MachineID="+MachineID+"&MachineParamID="+MachineParamID);
objWin.focus();
}
    </script>

    <div id="Pbody_box_inventory" style="width:1304px;">
           <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 
        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content" style="text-align: center;">
                <b>Machine Data</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        </div>
        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td>
                            Date From:
                        </td>
                        <td>
                              <asp:TextBox ID="txtentrydatefrom" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                             
                            <cc1:CalendarExtender runat="server" ID="CalendarExtender1" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy" PopupButtonID="txtentrydatefrom" />
                        </td>
                        <td>
                            Date To:
                        </td>
                        <td>
                              <asp:TextBox ID="txtentrydateto" runat="server" Width="100px" ReadOnly="true"></asp:TextBox>
                             
                            <cc1:CalendarExtender runat="server" ID="CalendarExtender2" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy" PopupButtonID="txtentrydateto" />
                        </td>
                        <td>
                            Machine Id:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlMachine" runat="server"  Width="350px">
                            </asp:DropDownList>
                        </td>
                        <td>
                            Sample Id:
                        </td>
                        <td>
                            <asp:TextBox ID="txtSampleID" runat="server" CssClass="ItDoseTextinputText" Width="150px" />
                        </td>
                    </tr>
                   
                    <tr>
                        <td>
                            Show only:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlType" runat="server" CssClass="ItDoseDropdownbox" Width="104px">
                                <asp:ListItem>--Select--</asp:ListItem>
                                <asp:ListItem Value="1">Synced Data</asp:ListItem>
                                <asp:ListItem Value="0">Pending Data</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            Page Size:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="ItDoseDropdownbox" Width="104px">
                                <asp:ListItem Value="20">20</asp:ListItem>
                                <asp:ListItem Value="40">40</asp:ListItem>
                                <asp:ListItem Value="60">60</asp:ListItem>
                                <asp:ListItem Value="80">80</asp:ListItem>
                                <asp:ListItem Value="100">100</asp:ListItem>
                                <asp:ListItem Value="All">All</asp:ListItem>
                            </asp:DropDownList>
                           
                        </td>
                        <td colspan="4">

                         
                            <asp:CheckBox ID="chkNotRegistred" runat="server" Text="Not Registred Patients Only" />
                      
                        </td>
                    </tr>
                </table>
            </div>
              
                         
        </div>
        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content" style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="savebutton" Text="Search" Width="60px"
                    OnClick="btnSearch_Click" />
                &nbsp; &nbsp; &nbsp; &nbsp;<asp:Button ID="btnReport" runat="server" CssClass="searchbutton" Text="Report" Width="60px" OnClick="btnReport_Click"  />
                
            </div>
        </div>
        <div class="POuter_Box_Inventory"  style="width:1300px;">
            <div class="Purchaseheader">
                Search Result
            </div>
            <%--style="height:440px; overflow:auto;" --%>
            <div>
                <asp:GridView ID="grdSearch" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                    CssClass="GridViewStyle" EnableModelValidation="True" OnRowDataBound="grdSearch_RowDataBound"
                    OnPageIndexChanging="grdSearch_PageIndexChanging" Width="99%">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sample ID">
                            <ItemTemplate>
                                <%#Eval("LabNo") %>
                                <asp:Label ID="lblSync" runat="server" Text='<%#Eval("isSync") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Machine Param ID">
                            <ItemTemplate>
                                <asp:Label ID="lblMachine_ParamID" runat="server" Text='<%#Eval("Machine_ParamID") %>'></asp:Label>
                                <%--<a href="javascript:void(0);" onclick="getMachineParam('<%#Eval("MACHINE_ID") %>','<%#Eval("Machine_ParamID") %>');" 
                                title="Click for Test Mapping"><%#Eval("Machine_ParamID") %></a>--%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Param Alias">
                            <ItemTemplate>
                                <asp:Label ID="lblAlias" runat="server" Text='<%#Eval("machine_param") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  HorizontalAlign="Left"/>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Machine">
                            <ItemTemplate>
                                <asp:Label ID="lblMACHINE_ID" runat="server" Text='<%#Eval("MACHINE_ID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reading">
                            <ItemTemplate>
                                <asp:Label ID="lblReading" runat="server" Text='<%#Eval("Reading") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Font-Bold="true" Text='<%#Eval("dtEntry") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left"  />
                        </asp:TemplateField>
                <%--        <asp:TemplateField HeaderText="#">
                            <ItemTemplate>
                                <asp:LinkButton ID="lblAddParam" runat="server" CommandName="AddParam" CommandArgument='<%#Container.DataItemIndex%>'>Add Param</asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>--%>
                    </Columns>
                    <PagerSettings FirstPageText="First Page" LastPageText="Last Page" Position="TopAndBottom"
                        Mode="NumericFirstLast" />
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
