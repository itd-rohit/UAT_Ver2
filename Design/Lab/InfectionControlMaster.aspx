<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="InfectionControlMaster.aspx.cs" Inherits="Design_Lab_InfectionControlMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width: 1304px;">

        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                            <b>Infection Control Master</b>
                            <br />
                            <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>


        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">


            <%--<div class="Purchaseheader">Report Filter</div>--%>
            <table>
             
                <tr>
                    <td>Investigation:</td>
                    <td>
                        <asp:ListBox ID="ddlInvestigation" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="300px" onchange="bindObservation();"></asp:ListBox>
                    </td>
                    <td>
                    </td>
                   
                </tr>


            </table>
               <table>
             
                <tr>
                    <td width="95px;">

                    </td>
                    <td>
                        <asp:ListBox ID="ddlObservation" runat="server" SelectionMode="Multiple" Width="500px"  Height="250px"></asp:ListBox>
                    </td>
                    <td valign="middle">
                       <input type="button" value="Add >>" onclick="AddObservation();" style="width: 100%;" />
                        <br /><br />
                         <input type="button" value="<< Remove " onclick="RemoveObservation();" />
                    </td>
                    <td>
                         <asp:ListBox ID="ddlSelectedObservation" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="500px" Height="250px"></asp:ListBox>
                    </td>
                   
                </tr>


            </table>



        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;display:none;">

            <input type="button" value="Get Report" class="searchbutton" onclick="getreport()" />
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center; max-height: 500px; overflow-x: auto;">
        </div>

    </div>


    <script type="text/javascript">


        $(function () {
            jQuery('#<%=ddlInvestigation.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
 
            bindInvestigation();
            bindObservation();
            bindExistsObservation()
           
        });

        $(document).ready(function () {
            $modelBlockUI();

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


        function bindInvestigation() {
            $('#<%=ddlInvestigation.ClientID%> option').remove();
            jQuery('#<%=ddlInvestigation.ClientID%>').multipleSelect("refresh");
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            $.ajax({
                url: "InfectionControlMaster.aspx/bindInvestigation",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    data = jQuery.parseJSON(result.d);

                    for (var a = 0; a <= data.length - 1; a++) {
                        jQuery('#<%=ddlInvestigation.ClientID%>').append($("<option></option>").val(data[a].Investigation_Id).html(data[a].NAME));
                    }
                    jQuery('#<%=ddlInvestigation.ClientID%>').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $modelUnBlockUI();
                }
            });
        }

        function bindObservation() {
            $('#<%=ddlObservation.ClientID%> option').remove();
             
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

            var InvestigationId = $('[id$=ddlInvestigation]').val().toString();

              $.ajax({
                  url: "InfectionControlMaster.aspx/bindObservation",
                  data: JSON.stringify({ InvestigationId: InvestigationId }),
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",

                  success: function (result) {
                      data = $.parseJSON(result.d);
                      debugger
                      for (var a = 0; a < data.length ; a++) {
                          $('[id$=ddlObservation]').append("<option value=" + data[a].LabObservation_Id + ">" + data[a].Name + "</option>");
                    }
                   
                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    $modelUnBlockUI();
                }
            });
        }

        

       
    </script>


    <script type="text/javascript">

      

        function AddObservation()
        {
            var LabObservationId = $('[id$=ddlObservation]').val().toString();
            if (LabObservationId == "")
            {
                alert('Kindly select any observation');
                return;
            }

            $.ajax({
                url: "InfectionControlMaster.aspx/AddObservation",
                async: true,
                data: '{LabObservationId:"' + LabObservationId + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        bindExistsObservation();
                    } else {

                        alert('Some error occured !');
                    }
                }
            });
        }


        function bindExistsObservation() {
            $('[id$=ddlSelectedObservation] option').remove();

               jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

              // var InvestigationId = $('[id$=ddlInvestigation]').val().toString();

               $.ajax({
                   url: "InfectionControlMaster.aspx/bindExistsObservation",
                  // data: JSON.stringify({ InvestigationId: InvestigationId }),
                   type: "POST",
                   contentType: "application/json; charset=utf-8",
                   timeout: 120000,
                   dataType: "json",

                   success: function (result) {
                       data = $.parseJSON(result.d);
                       var html = '';
                       for (var a = 0; a < data.length ; a++) {
                           html += "<option value=" + data[a].LabObservation_Id + ">" + data[a].Name + "</option>";
                           
                       }
                       $('[id$=ddlSelectedObservation]').append(html);
                       $modelUnBlockUI();
                   },
                   error: function (xhr, status) {
                       alert(xhr.responseText);
                       $modelUnBlockUI();
                   }
               });
           }


        function RemoveObservation()
        {
            var LabObservationId = $('[id$=ddlSelectedObservation]').val().toString();
            if (LabObservationId == "") {
                alert('Kindly select any observation to remove');
                return;
            }

            $.ajax({
                url: "InfectionControlMaster.aspx/RemoveObservation",
                async: true,
                data: '{LabObservationId:"' + LabObservationId + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        bindExistsObservation();
                    } else {

                        alert('Some error occured !');
                    }
                }
            });
        }
    </script>
</asp:Content>
