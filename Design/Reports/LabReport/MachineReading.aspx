<%@ Page Title="" Language="C#" AutoEventWireup="true"
    CodeFile="MachineReading.aspx.cs" Inherits="Design_Machine_MachineReading" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" /> 
    <link href="../../../App_Style/multiple-select.css" rel="stylesheet" />
    </head>
    <body >     
       <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
    <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

</Scripts>
</Ajax:ScriptManager>  
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Machine Data</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        </div>
        <div class="POuter_Box_Inventory" id="div1" runat="server">
            <div class="row">
                <div class="col-md-3"> Machine Id:&nbsp;</div>
                <div class="col-md-4"> <asp:DropDownList ID="ddlMachine" runat="server" CssClass="ItDoseDropdownbox">
                            </asp:DropDownList></div>
                <div class="col-md-3">Sample Id:</div>
                <div class="col-md-4"> <asp:TextBox ID="txtSampleID" runat="server" CssClass="ItDoseTextinputText"  /></div>
                <div class="col-md-3">Show only:</div>
                <div class="col-md-4"><asp:DropDownList ID="ddlType" runat="server" CssClass="ItDoseDropdownbox">
                                <asp:ListItem>--Select--</asp:ListItem>
                                <asp:ListItem Value="1">Synced Data</asp:ListItem>
                                <asp:ListItem Value="0">Pending Data</asp:ListItem>
                            </asp:DropDownList></div>
            </div>
            <div class="row">
							   <div class="col-md-3"><label>Booking Center :</label></div>
                    <div class="col-md-4"> <asp:ListBox ID="ddlcenter"  CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox> 
                         <asp:HiddenField ID="hdnCentre" runat="server"  />
                        </div>
                        <div class="col-md-3"><label>Test Center :</label></div>
                    <div class="col-md-4"> <asp:ListBox ID="lstCentre"  CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox> 
                         <asp:HiddenField ID="hdnCentre1" runat="server"  />
                        </div>
                     </div>
             <div class="row">
                <div class="col-md-3"> Date From:&nbsp;</div>
                  <div class="col-md-4">  <asp:TextBox ID="txtfromdate" runat="server" class="filterdate" />
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender></div>
                  <div class="col-md-3"> Date To:</div>
                  <div class="col-md-4">  <asp:TextBox ID="txttodate" runat="server"  class="filterdate" />
                        <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txttodate" PopupButtonID="txttodate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender></div>
                      <div class="col-md-3"> Page Size:</div>
                  <div class="col-md-4">  <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="ItDoseDropdownbox">
                                <asp:ListItem Value="20">20</asp:ListItem>
                                <asp:ListItem Value="40">40</asp:ListItem>
                                <asp:ListItem Value="60">60</asp:ListItem>
                                <asp:ListItem Value="80">80</asp:ListItem>
                                <asp:ListItem Value="100">100</asp:ListItem>
                                <asp:ListItem Value="All">All</asp:ListItem>
                            </asp:DropDownList></div>
           
                </div>
            <div class="row">
                   <div class="col-md-3">Report Format :</div>
                 <div class="col-md-5"><asp:RadioButtonList ID="rblreporttype" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Value="1" Selected="True">Pdf</asp:ListItem>
                <asp:ListItem Value="2">Excel</asp:ListItem>
                                  </asp:RadioButtonList> </div>
             
                </div>                                  
                         
                           
                      
        </div>
        <div class="POuter_Box_Inventory"  id="div2" runat="server">
            <div class="row" style="text-align: center;">
                <div class="col-md-4"> <asp:CheckBox ID="chkNotRegistred" runat="server" Text="Not Registred Patients Only" /></div>
                 <div class="col-md-8"></div>
                <div class="col-md-4">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                    OnClick="btnSearch_Click" /></div>
                    <div class="col-md-4">
               <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Get Report" Width="60px" OnClick="btnReport_Click"  />
                &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
                    </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory"  id="div3" runat="server">
            <div class="Purchaseheader">
                Search Result
            </div>
            <%--style="height:440px; overflow:auto;" --%>
            <div style="overflow:scroll;height:300px">
                <asp:GridView ID="grdSearch" runat="server" Width="100%" AllowSorting="True" AutoGenerateColumns="False"
                    CssClass="GridViewStyle" EnableModelValidation="True" OnRowDataBound="grdSearch_RowDataBound"
                    OnPageIndexChanging="grdSearch_PageIndexChanging">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" Height="18px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sample ID">
                            <ItemTemplate>
                                <%#Eval("LabNo") %>
                                <asp:Label ID="lblSync" runat="server" Text='<%#Eval("isSync") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Machine Param ID">
                            <ItemTemplate>
                                <asp:Label ID="lblMachine_ParamID" runat="server" Text='<%#Eval("Machine_ParamID") %>'></asp:Label>
                                <%--<a href="javascript:void(0);" onclick="getMachineParam('<%#Eval("MACHINE_ID") %>','<%#Eval("Machine_ParamID") %>');" 
                                title="Click for Test Mapping"><%#Eval("Machine_ParamID") %></a>--%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Param Alias">
                            <ItemTemplate>
                                <asp:Label ID="lblAlias" runat="server" Text='<%#Eval("machine_param") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Machine">
                            <ItemTemplate>
                                <asp:Label ID="lblMACHINE_ID" runat="server" Text='<%#Eval("MACHINE_ID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reading">
                            <ItemTemplate>
                                <asp:Label ID="lblReading" runat="server" Text='<%#Eval("Reading") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("dtEntry") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
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
           <script type="text/javascript">
               $(function () {
                   
                   $("#Pbody_box_inventory").css('margin-top', 0);
                   $('[id$=ddlcenter]').multipleSelect({
                       includeSelectAllOption: true,
                       filter: true, keepOpen: false
                   });

                   $("#Pbody_box_inventory").css('margin-top', 0);
                   $('[id$=lstCentre]').multipleSelect({
                       includeSelectAllOption: true,
                       filter: true, keepOpen: false
                   });
                   if ($('#hdnCentre').val() != '') {
                       var data = [];
                       data = $('#hdnCentre').val();
                   }


                   if ($('#hdnItemId').val() != '') {
                       var data1 = [];
                       data1 = $('[id$=hdnItemId]').val();
                   }

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
                   jQuery('#ddlcenter').trigger('chosen:updated');
                   jQuery('#lstCentre').trigger('chosen:updated');
               });
           </script>
</form>
</body>
</html>
