<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EmployeeAccessReport.aspx.cs" Inherits="Design_EDP_EmployeeAccessReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />

    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>

     <div id="Pbody_box_inventory" style="width: 1275px">
             <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           <Services>
              

           </Services>
        </Ajax:ScriptManager>

         <style>
             .ui-autocomplete {
    max-height: 200px;
    max-width:450px;
    overflow-y: auto;   /* prevent horizontal scrollbar */
    overflow-x: hidden; /* add padding to account for vertical scrollbar */
    z-index:1000 !important;
}
         </style>
             <div class="POuter_Box_Inventory" style="width: 1272px;text-align:center">
                 <b>Employee Access Report  </b>
              <br />

                 </div>
         <div class="POuter_Box_Inventory" style="width: 1272px;text-align:center">
             <table style="width:100%;border-collapse:collapse">
                 <tr>
                     <td  style="text-align:right;width:13%">
                         Employee Name :&nbsp;
                     </td>
                     <td  style="text-align:left;width:20%">
                          <input id="txtEmployee" onkeydown="SearchEmployee();" type="text" style="width:280px" />
                          <input type="hidden" id="hdnEmployeeId" value="0" />

                     </td>
                      <td  style="text-align:right;width:13%">
                          Centre
                         
                     </td>
                      <td  style="text-align:left;width:20%">
                           <input id="txtCentre" onkeydown="SearchCentre();"  style="width:280px" type="text" />
                          <input type="hidden" id="hdnCentreId" value="0" />
                     </td>
                      <td  style="text-align:right;width:13%">
                          Role
                     </td>
                      <td  style="text-align:left;width:20%">
                          <asp:DropDownList ID="ddlRole" runat="server"></asp:DropDownList>
                     </td>
                 </tr>
             </table>
             </div>
         <div class="POuter_Box_Inventory" style="width: 1272px;text-align:center">
             <asp:Button ID="btnReport" runat="server" CssClass="searchbutton" Text="Report" OnClientClick="return Search();" />
              </div>
         </div>
    <script type="text/javascript">
       
        function SearchCentre() {
            $.ajax({
                url: "EmployeeAccessReport.aspx/SearchCentre",
                async: true,
                data: '{Centre:"' + $('[id$=txtCentre]').val() + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    CentreNames = $.parseJSON(result.d);
                    $("[id$=txtCentre]").autocomplete({
                        source: CentreNames,
                        autoFocus: true,
                        select: function (event, ui) {
                            $("[id$=txtCentre]").val(ui.item.label);
                            $('[id$=hdnCentreId]').val(ui.item.value);
                            return false;
                        },
                    });
                },
                error: function (xhr, status) {
                   // alert(xhr.responseText);
                }
            });
        }
        function SearchEmployee() {
            $.ajax({
                url: "EmployeeAccessReport.aspx/SearchEmployee",
                async: true,
                data: '{Employee:"' + $('[id$=txtEmployee]').val() + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    Employees = $.parseJSON(result.d);
                    $("[id$=txtEmployee]").autocomplete({
                        source: Employees,
                        autoFocus: true,
                        select: function (event, ui) {
                            $("[id$=txtEmployee]").val(ui.item.label);
                            $('[id$=hdnEmployeeId]').val(ui.item.value);
                           
                            return false;
                        },
                    });
                },
                error: function (xhr, status) {
                    // alert(xhr.responseText);
                }
            });
        }

        function Search()
        {
            $.ajax({
                url: "EmployeeAccessReport.aspx/Search",
                async: true,
                data: JSON.stringify({EmployeeId:$('#hdnEmployeeId').val(),CentreId:$('#hdnCentreId').val(),RoleId:$('[id$=ddlRole]').val()}),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    window.open('../Common/Commonreport.aspx');
                }
            });

            return false;
        }

       
    </script>
</asp:Content>

