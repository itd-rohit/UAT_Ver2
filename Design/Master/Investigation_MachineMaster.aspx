<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Investigation_MachineMaster.aspx.cs" Inherits="Design_Master_Investigation_MachineMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
         <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
       <div id="Pbody_box_inventory" style="width:1300px;">
                <div class="POuter_Box_Inventory" style="text-align: center;width:1300px;">

                    <b>&nbsp;Investigation Mapping Master</b>&nbsp;
                 

                </div>
             <div class="POuter_Box_Inventory" style="width:1300px;">
                    <div class="Purchaseheader">
                        Add Details&nbsp;
                    </div>

                 <table style="width:99%">
                     <tr>
                         <td style="font-weight:bold;text-align:right">
                             Department :
                         </td>
                         <td>
                             <asp:DropDownList ID="ddlDept" runat="server" Width="200px" class="ddltype  chosen-select chosen-container" onchange="BindInvestigation();"></asp:DropDownList>
                         </td>
                         <td style="font-weight:bold;text-align:right">
                             Investigation :
                         </td>
                         <td>
                              <asp:DropDownList ID="ddlInvestigation" runat="server" Width="200px" class="ddlInvestigation  chosen-select chosen-container" onchange="SearchData();"></asp:DropDownList>
                         </td>
                         <td></td>
                     </tr>
                     <tr>
                         <td style="font-weight:bold;text-align:right">
                             Centre :
                         </td>
                         <td>
                             <asp:DropDownList ID="ddlcentre" runat="server" Width="200px" class="ddlcentre  chosen-select chosen-container"></asp:DropDownList>
                         </td>
                         <td style="font-weight:bold;text-align:right">
                             Machine :
                         </td>
                         <td>
                              <asp:DropDownList ID="ddlMachine" runat="server" Width="200px" class="ddlMachine  chosen-select chosen-container"></asp:DropDownList>
                         </td>
                           <td>
                               <input type="button" id="btnsave" class="savebutton"  value="Save" onclick="savedata()" />
                           </td>
                     </tr>
                     </table>
                 </div>

           <div class="content" style="max-height:300px;overflow:scroll">
               <table style="width:99%" id="tblinvmachine" cellspacing="0" class="GridViewStyle">
                   <tr id="invheader">
                       <th class="GridViewHeaderStyle" scope="col" align="left">S.No.</th>
                       <th class="GridViewHeaderStyle" scope="col" align="left">InvestigationName</th>
                        <th class="GridViewHeaderStyle" scope="col" align="left">Centre</th>
                       <th class="GridViewHeaderStyle" scope="col" align="left">MachineName</th>
                      
                       <th class="GridViewHeaderStyle" scope="col" align="left">colour</th>
                   </tr>
               </table>
           </div>
           </div>
    <script type="text/javascript">
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
            BindDept();
          
           
        });

        function BindDept() {
            $modelBlockUI();
            var ddldept = $("#<%=ddlDept.ClientID %>");
             $("#<%=ddlDept.ClientID %> option").remove();
            $.ajax({

                url: "Investigation_MachineMaster.aspx/binddept",
                data: '{}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $modelUnBlockUI();
                    }
                    else {
                        ddldept.append($("<option></option>").val("0").html("Select Dept"));
                        for (i = 0; i < PanelData.length; i++) {

                            ddldept.append($("<option></option>").val(PanelData[i]["SubcategoryID"]).html(PanelData[i]["NAME"]));
                        }
                    }
                    ddldept.trigger('chosen:updated');
                    $modelUnBlockUI();
                    BindInvestigation();
                },
                error: function (xhr, status) {
                    ddldept.trigger('chosen:updated');
                    window.status = status + "\r\n" + xhr.responseText;
                    $modelUnBlockUI();
                }
            });

        }


        function BindInvestigation() {
            $modelBlockUI();
            var ddlInvestigation = $("#<%=ddlInvestigation.ClientID %>");
            $("#<%=ddlInvestigation.ClientID %> option").remove();
             $.ajax({

                 url: "Investigation_MachineMaster.aspx/BindInvestigation",
                 data: '{Dept:"'+$('#<%=ddlDept.ClientID%> option:selected').val()+'"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PanelData = $.parseJSON(result.d);
                     if (PanelData.length == 0) {
                         $modelUnBlockUI();
                     }
                     else {
                          ddlInvestigation.append($("<option></option>").val("0").html("Select Investigation"));
                         for (i = 0; i < PanelData.length; i++) {

                             ddlInvestigation.append($("<option></option>").val(PanelData[i]["Investigation_ID"]).html(PanelData[i]["NAME"]));
                         }
                     }
                     ddlInvestigation.trigger('chosen:updated');
                     $modelUnBlockUI();
                     SearchData();
                 },
                 error: function (xhr, status) {
                     ddlInvestigation.trigger('chosen:updated');
                     window.status = status + "\r\n" + xhr.responseText;
                     $modelUnBlockUI();
                 }
             });

        }

        function savedata() {
            if ($('#<%=ddlInvestigation.ClientID%>').val() == "0") {
                showerrormsg('Please select Investigation..');
                return;
            }
            if ($('#<%=ddlcentre.ClientID%>').val() == "0") {
                showerrormsg('Please select centre..');
                return;
            }
            if ($('#<%=ddlMachine.ClientID%>').val() == "0") {
                showerrormsg('Please select machine..');
                return;
            }
                $.ajax({
                    url: "Investigation_MachineMaster.aspx/SaveData",
                    data: '{InvestigationID:"' + $('#<%=ddlInvestigation.ClientID%> option:selected').val() + '",CentreID:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '",MachineID:"' + $('#<%=ddlMachine.ClientID%> option:selected').val() + '"}', // parameter map
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",

                    success: function (result) {
                        PanelData = $.parseJSON(result.d);
                        if (PanelData == "1") {
                           
                            showmsg("Record Saves successfully..!");
                            $('#<%=ddlDept.ClientID%>').val('0');
                            $('#<%=ddlDept.ClientID%>').trigger('chosen:updated');
                            SearchData();
                        }
                        else {
                           
                            showerrormsg(PanelData);
                        }
                    },
                    error: function (xhr, status) {
                        showerrormsg(xhr.responseText);
                    }
                });
           
        }

        function SearchData() {
            $('#tblinvmachine tr').slice(1).remove();
            $.ajax({
                url: "Investigation_MachineMaster.aspx/SearchData",
                data: '{Investigationid:"' + $('#<%=ddlInvestigation.ClientID%>').val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        showerrormsg("No Record Found.!");
                    }
                    else {
                        for (i = 0; i < PanelData.length; i++) {
                            var myData = "<tr id='" + PanelData[i].ID+ "'>";
                            myData += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                            myData += '<td class="GridViewLabItemStyle">' + PanelData[i].Name + '</td>';
                            myData += '<td class="GridViewLabItemStyle">' + PanelData[i].Centre + '</td>';
                            myData += '<td class="GridViewLabItemStyle">' + PanelData[i].MachineName + '</td>';
                          
                            myData += '<td class="GridViewLabItemStyle">' + PanelData[i].colour + '</td>';
                            $('#tblinvmachine').append(myData);
                        }
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
            $(".alert").delay(2000).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>
</asp:Content>

