<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="InfectionControlMaster.aspx.cs" Inherits="Design_Lab_InfectionControlMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

   <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
  <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />    
     <%: Scripts.Render("~/bundles/JQueryUIJs") %>    
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                      <b>Infection Control Master</b>
                </div>               
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-2">Investigation:</div>
                <div class="col-md-22"><asp:ListBox ID="ddlInvestigation" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="300px" onchange="bindObservation();"></asp:ListBox></div>               
                </div>
                   <div class="row">
                <div class="col-md-10"> <asp:ListBox ID="ddlObservation" runat="server" SelectionMode="Multiple" Width="500px"  Height="250px"></asp:ListBox></div>
                        <div class="col-md-4"><input type="button" value="Add >>" onclick="AddObservation();" style="width: 100px;" />
                        <br /><br />
                         <input type="button" value="<< Remove " onclick="RemoveObservation();" style="width: 100px;"  /></div>
                        <div class="col-md-10"> <asp:ListBox ID="ddlSelectedObservation" CssClass="multiselect" SelectionMode="Multiple" runat="server" Width="500px" Height="250px"></asp:ListBox></div>
                       </div>                           
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
            
            serverCall('InfectionControlMaster.aspx/bindInvestigation', {}, function (response) {
                var data = $.parseJSON(response);
                for (var a = 0; a <= data.length - 1; a++) {
                    jQuery('#<%=ddlInvestigation.ClientID%>').append($("<option></option>").val(data[a].Investigation_Id).html(data[a].NAME));
                }
                jQuery('#<%=ddlInvestigation.ClientID%>').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        }

        function bindObservation() {
            $('#<%=ddlObservation.ClientID%> option').remove();                      
            var InvestigationId = $('[id$=ddlInvestigation]').val().toString();
            serverCall('InfectionControlMaster.aspx/bindObservation', { InvestigationId: InvestigationId }, function (response) {
                var data = $.parseJSON(response);
                for (var a = 0; a < data.length ; a++) {
                    $('[id$=ddlObservation]').append("<option value=" + data[a].LabObservation_Id + ">" + data[a].Name + "</option>");
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
                toast("Error", "Kindly select any observation to Add", "");              
                return;
            }
            serverCall('InfectionControlMaster.aspx/AddObservation', { LabObservationId: LabObservationId }, function (response) {              
                if (response == "1") {
                    bindExistsObservation();
                    toast("Success", "Added Successfully..!", "");
                }
                else {
                    toast("Error", "Error occured..!", "");
                }
            });         
        }
        function bindExistsObservation() {
            $('[id$=ddlSelectedObservation] option').remove();
            serverCall('InfectionControlMaster.aspx/bindExistsObservation', {}, function (response) {
                var data = $.parseJSON(response);
                var html = '';
                for (var a = 0; a < data.length ; a++) {
                    html += "<option value=" + data[a].LabObservation_Id + ">" + data[a].Name + "</option>";

                }
                $('[id$=ddlSelectedObservation]').append(html);
            });
        }


        function RemoveObservation()
        {
            var LabObservationId = $('[id$=ddlSelectedObservation]').val().toString();
            if (LabObservationId == "") {                
                toast("Error", "Kindly select any observation to remove", "");
                return;
            }
            serverCall('InfectionControlMaster.aspx/RemoveObservation', { LabObservationId: LabObservationId }, function (response) {
                if (response == "1") {
                    bindExistsObservation();
                    toast("Success", "Remove Successfully..!", "");
                } else {
                    toast("Error", "Some Error Occured", "");                  
                }
            });          
        }
    </script>
</asp:Content>
