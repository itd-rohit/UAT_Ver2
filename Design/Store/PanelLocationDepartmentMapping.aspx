<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PanelLocationDepartmentMapping.aspx.cs" Inherits="Design_Store_PanelLocationDepartmentMapping" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
<%--     <%: Scripts.Render("~/bundles/JQueryStore") %>--%>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
     <script type="text/javascript">
         $(document).ready(function () {
             BindPanel();
             BindDepartment();

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

         function BindPanel() {
             var dddl_Panel = $('#<%=ddlPanel.ClientID%>');
            
             dddl_Panel.empty();
            $.ajax({
                url: "PanelLocationDepartmentMapping.aspx/BindPanel",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",

                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length > 0) {
                        dddl_Panel.append($("<option></option>").val(0).html("Select Panel"));
                        for (var i = 0; i < PanelData.length; i++) {

                            dddl_Panel.append($("<option></option>").val(PanelData[i].Panel_ID).html(PanelData[i].Company_Name));
                        }
                    }
                    $('#<%=ddlPanel.ClientID%>').trigger("chosen:updated");
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
         }

         function Bindlocation() {
             var dddl_ddlLocation = $('#<%=ddlLocation.ClientID%>');

             dddl_ddlLocation.empty();
              $.ajax({
                  url: "PanelLocationDepartmentMapping.aspx/Bindlocation",
                  data: '{PanelID:"' + $('#<%=ddlPanel.ClientID%>').val() + '"}',
                  type: "POST",
                  contentType: "application/json; charset=utf-8",

                  timeout: 120000,
                  dataType: "json",
                  async: false,
                  success: function (result) {
                      PanelData = jQuery.parseJSON(result.d);
                      if (PanelData.length > 0) {
                          dddl_ddlLocation.append($("<option></option>").val(0).html("Select location"));
                          for (var i = 0; i < PanelData.length; i++) {

                              dddl_ddlLocation.append($("<option></option>").val(PanelData[i].LocationID).html(PanelData[i].Location));
                          }
                      }
                      else {
                          dddl_ddlLocation.append($("<option></option>").val(0).html("No Data found"));
                      }
                      BindData();
                      $('#<%=ddlLocation.ClientID%>').trigger("chosen:updated");
                  },
                  error: function (xhr, status) {
                      window.status = status + "\r\n" + xhr.responseText;
                  }
              });
          }

       
         function BindDepartment() {
             var ddl_dept = $('#<%=ddlDept.ClientID%>');
             ddl_dept.empty();
             $.ajax({
                 url: "PanelLocationDepartmentMapping.aspx/BindDepartment",
                 data: '{}',
                  type: "POST",
                  contentType: "application/json; charset=utf-8",

                  timeout: 120000,
                  dataType: "json",
                  async: false,
                  success: function (result) {
                      PanelData = jQuery.parseJSON(result.d);
                      if (PanelData.length > 0) {
                          ddl_dept.append($("<option></option>").val(0).html("Select Dept"));
                          for (var i = 0; i < PanelData.length; i++) {

                              ddl_dept.append($("<option></option>").val(PanelData[i].SubcategoryID).html(PanelData[i].Name));
                          }
                      }
                      $("#ddl_dept").trigger("chosen:updated");
                  },
                  error: function (xhr, status) {
                      window.status = status + "\r\n" + xhr.responseText;
                  }
              });
         }

        function BindData() {
            $('#tb_ItemList tr').slice(1).remove();
            $.ajax({
                url: "PanelLocationDepartmentMapping.aspx/BindData",
                data: '{PanelID:"' + $('#<%=ddlPanel.ClientID%>').val() + '",LocationID:"' + $('#<%=ddlLocation.ClientID%>').val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",

                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length > 0) {

                        for (var i = 0; i < PanelData.length; i++) {
                            var mydata = "<tr id='" + PanelData[i].Panel_ID + "' '>";
                            mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "";
                           
                            mydata += '<td class="GridViewLabItemStyle">' + PanelData[i].Company_Name + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + PanelData[i].Location + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + PanelData[i].Name + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none" id="td_SubcategoryID">' + PanelData[i].SubcategoryID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none" id="td_Panel_ID">' + PanelData[i].Panel_ID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"><img id="imgremove" src="../../App_Images/Delete.gif" onclick="Remove(this);" /></td>';

                            mydata += "</tr>";
                            $('#tb_ItemList').append(mydata);
                        }
                    }
                    else {
                        showerrormsg('No record found..')
                        $('#tb_ItemList tr').slice(1).remove();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

         function getdata() {
             var data = new Array();
             data[0] = $('#<%=ddlPanel.ClientID%>').val();
             data[1] = $('#<%=ddlLocation.ClientID%>').val();
             data[2] = $('#<%=ddlDept.ClientID%>').val()
             return data;
         }

         function saveData() {
             var mydata = getdata();
             if (mydata[0] == "0") {
                 showerrormsg('Please select Panel');
                 return;
             }
             if (mydata[1] == "0") {
                 showerrormsg('Please select Location');
                 return;
             }
             if (mydata[2] == "0") {
                 showerrormsg('Please select Department');
                 return;
             }
             $.ajax({
                 url: "PanelLocationDepartmentMapping.aspx/saveData",
                 data: JSON.stringify({ Searchdata: mydata }),
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     PanelData = result.d;
                     if (PanelData == "1") {
                         showmsg('Department Mapped successfully');
                         BindData();
                     }
                     else {
                         showerrormsg(PanelData);
                     }
                    
                 },
                 error: function (xhr, status) {
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function showmsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', '#04b076');
             $(".alert").removeClass("in").show();
             $(".alert").delay(5000).addClass("in").fadeOut(3000);
         }
         function showerrormsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', 'red');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function Remove(ctrl) {
             var Deptid = $(ctrl).closest('tr').find('#td_SubcategoryID').html();
             var Panelid = $(ctrl).closest('tr').find('#td_Panel_ID').html();
             $.ajax({
                 url: "PanelLocationDepartmentMapping.aspx/Remove",
                 data: '{DeptID:"' + Deptid + '",Panelid:"' + Panelid + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     PanelData = result.d;
                     if (PanelData == "1") {
                         showmsg('Department removed successfully..!');
                        
                     }
                     else {
                         showerrormsg('Department not removed....try again..!');
                     }
                     BindData();
                 },
                 error: function (xhr, status) {
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function GetReport() {
             $.blockUI();
             $.ajax({
                 url: "PanelLocationDepartmentMapping.aspx/GetReport",
                 data: '{}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = result.d;

                    if (ItemData == "false") {
                        showerrormsg("No Item Found");
                        $.unblockUI();
                    }
                    else {
                        window.open('../common/ExportToExcel.aspx');
                        $.unblockUI();
                    }
                },
                error: function (xhr, status) {
                    $.unblockUI();
                }
            });
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width:1304px;">
        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Store Location Department Mapping</b>  
                            
                        </td>
                    </tr>
                    </table>
                </div>


              </div>
        <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="100%">
                    <tr>
                        <td >Centre :</td>
                        <td align="left">
                            <asp:DropDownList ID="ddlPanel" Width="325px" onchange="Bindlocation()" class="ddlPanel chosen-select chosen-container" runat="server" ></asp:DropDownList>
                        </td>
                        <td>Location :</td>
                        <td align="left">
                            <asp:DropDownList ID="ddlLocation" Width="290px" onchange="BindData()" runat="server" class="ddlLocation chosen-select chosen-container" ></asp:DropDownList>
                        </td>
                        <td>
                            Department :
                        </td>
                        <td align="left">
                            <asp:DropDownList ID="ddlDept" Width="250px" runat="server" class="ddlDept chosen-select chosen-container" ></asp:DropDownList>
                        </td>
                        <td>
                             <input id="btnsave" type="button" value="Save" class="searchbutton"  onclick="saveData()" />
                            <input type="button" id="btnexport" class="searchbutton" onclick="GetReport();" value="Export To Excel" />
                        </td>
                    </tr>
                    </table>
                </div>
            </div>
         <div class="POuter_Box_Inventory" style="width:1304px;">
           <div class="Purchaseheader" style="width:1300px;">
              Record
               
            </div>
             
            <div class="content" style="overflow:scroll;height:400px">
               
                <table style="width:99%;border-collapse:collapse"   id="tb_ItemList" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle"  style="width:30px">Sr.No.</td>
                        <td class="GridViewHeaderStyle"  style="width:30px">Panel Name</td>
                         <td class="GridViewHeaderStyle"  style="width:100px">Location Name</td> 
                        <td class="GridViewHeaderStyle"  style="width:70px">Department Name</td>
                               
                        <td class="GridViewHeaderStyle"  style="width:30px">Remove Dept</td>
                        </tr>
                    </table>
                     
              </div>
             </div>
        </div>
</asp:Content>

