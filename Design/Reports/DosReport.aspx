<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DosReport.aspx.cs" Inherits="Design_Reports_DosReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <style type="text/css">
        .selected {
            background-color: aqua !important;
            border: 2px solid black;
        }
    </style>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Dos Report</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
          
                <div class="row" style="margin-top: 0px;">
                    <div class="col-md-21">
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left">Centre   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 ">
                                <asp:DropDownList ID="ddlcentretype" runat="server" ClientIDMode="Static" class="ddlcentretype  chosen-select chosen-container" onchange="$bindcentre()">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-5">
                                <asp:ListBox ID="ddlcentre" runat="server" ClientIDMode="Static" class="ddlcentre  chosen-select chosen-container" ></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Department   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:DropDownList ID="ddldepartment" ClientIDMode="Static" runat="server" class="ddldepartment chosen-select chosen-container" onchange="$binditem()" />
                            </div>
                            <div class="col-md-3">
                               
                            </div>
                            <div class="col-md-8">
                            </div>
                        </div>
                      
                        </div>
                        <div class="row" style="text-align: center">
                          
                           
                        </div>

                    
                </div>
          
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
             <input type="button" value="Export To Excel" class="searchbutton" onclick="getdataexcel()" />
            </div>
         <div class="POuter_Box_Inventory">
            <div class="row" style="height: 180px; overflow-y: auto; overflow-x: auto;">
                 <div class="col-md-3">
                     <asp:CheckBox ID="chkAll" ClientIDMode="Static" runat="server" Text="ALL" onclick="checkAll(this)" /><br/>
                      <asp:CheckBox ID="chkDefaultAll" runat="server" Text="Default Check" ClientIDMode="Static" onclick="checkDefaultAll(this)" Checked="true" />
                </div>
                <div class="col-md-21">
                     <div style="overflow: scroll; height: 180px;text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chlfield" CssClass="chkColumnsDetail" ClientIDMode="Static" runat="server" RepeatColumns="5" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                </div>
           </div>
             </div>

    </div>
     <script type="text/javascript">
         function checkAll(rowId) {
             if ($(rowId).is(':checked')) {
                 $("#chkDefaultAll").prop('checked', false);
                 $(".chk input[type=checkbox]").prop('checked', 'checked');
             }
             else {
                 $("#chkDefaultAll [type=checkbox]").prop('checked', 'checked');
                 $(".chk [type=checkbox]").prop('checked', false);
                 $(".chkDefault input[type=checkbox],#chkDefaultAll").prop('checked', 'checked');
             }
         }

         function checkDefaultAll(rowId) {
             if ($(rowId).is(':checked')) {
                 $("#chkAll").prop('checked', false);
                 $(".chk [type=checkbox]").prop('checked', false);
                 $(".chkDefault input[type=checkbox]").prop('checked', 'checked');
             }
             else {
                 $(".chk [type=checkbox]").prop('checked', false);
                 $("#chkAll").prop('checked', 'checked');
                 $(".chk input[type=checkbox]").prop('checked', 'checked');
                 // $(".chkDefault [type=checkbox]").prop('checked', false);
             }
         }
         function getFieldlist() {
             var fldList = "";
             $("[id*=chlfield] input:checked").each(function () {
                 fldList = fldList == "" ? $(this).val().split('#')[0] : fldList + "," + $(this).val().split('#')[0];
             });
             return (fldList);
         }
         function getdataexcel() {
             var FldList = getFieldlist();
             var centreid = $('#ddlcentre').val();
             if (centreid == "") {
                 toast("Error", "Please Select Centre", "");
                 return;
             }
             if (FldList == "") {
                 toast("Error", "Please Select fields", "");
                 return;
             }

             serverCall('DosReport.aspx/searchdataexcel', {  centreid: centreid,  departmentid: $('#ddldepartment').val(), FldList: FldList }, function (response) {
                 $responseData = $.parseJSON(response);
                 if ($responseData.status) {
                     if ($responseData.response == 1) {
                         window.open('../common/ExportToExcel.aspx');
                     }
                     else {
                         toast("Error", $responseData.response, "");
                         return;
                     }
                 }
                 else {
                     toast("Error", $responseData.response, "");
                     return;
                 }

             });


         }
         jQuery(function () {
            
             var config = {
                 '.chosen-select': {},
                 '.chosen-select-deselect': { allow_single_deselect: true },
                 '.chosen-select-no-single': { disable_search_threshold: 10 },
                 '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                 '.chosen-select-width': { width: "95%" }
             }
             for (var selector in config) {
                 jQuery(selector).chosen(config[selector]);
             }
             
         });
      var $bindcentre = function () {
            var $ddlPanel = $('#ddlcentre');
            serverCall('DosReport.aspx/bindCentre', { TypeId: $('#ddlcentretype').val() }, function (response) {
                $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'centreid', textField: 'centre', selectedValue: '<%=UserInfo.Centre%>', isSearchAble: true });

            });
        }
 </script>
</asp:Content>

