<%@ Page Title="" Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InterpretationMapping.aspx.cs" Inherits="Design_Investigation_InterpretationMapping" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 
     
      <div id="Pbody_box_inventory">
      
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        <Services>                          
            <Ajax:ServiceReference Path="Services/MapInvestigationObservation.asmx" />  
        </Services>  
     

        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Interpretation Mapping<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" >

              <table style="width: 100%; border-collapse: collapse">
                <tr >
            
                    <td style="text-align:right">
                        From
                        Centre :&nbsp;
                    </td>
                     <td style="text-align:left">
                       <asp:DropDownList ID="ddlCentre" runat="server"  Width="220px"></asp:DropDownList>
                    </td>
                    <td rowspan="3" style="text-align:center">
                        <img src="../../App_Images/TRY6_25.gif" style="height:60px" s />
                        
                    </td>
                     <td style="text-align:right">
                         To
                        Centre :&nbsp;
                    </td>
                     <td style="text-align:left">
                        <asp:DropDownList ID="ddlMappingCentre" runat="server"  Width="220px"></asp:DropDownList>
                    </td>
                    </tr>
                  <tr >
            
                    <td style="text-align:right">
                        From
                        Machine :&nbsp;
                    </td>
                     <td style="text-align:left">
                       <asp:DropDownList ID="ddlMachine" runat="server"  Width="220px"></asp:DropDownList>
                    </td>
                     <td style="text-align:right">
                         To
                        Machine :&nbsp;
                    </td>
                     <td style="text-align:left">
                        <asp:DropDownList ID="ddlMappingMachine" runat="server"  Width="220px"></asp:DropDownList>
                    </td>
                    </tr>
                  <tr >
            
                    <td style="text-align:right">
                        Department :&nbsp;
                    </td>
                     <td style="text-align:left">
                       <asp:DropDownList ID="ddlDepartment" runat="server"  Width="220px"></asp:DropDownList>
                    </td>
                     <td style="text-align:left">
                        &nbsp;
                    </td>
                     <td style="text-align:left">
                        &nbsp;
                    </td>
                    </tr>
                    </table>
            </div>
           <div class="POuter_Box_Inventory" style="text-align: center;">
               <input type="button" id="btnSave" class ="ItDoseButton" value="Save" onclick="saveInter()" />
               </div>
          </div>
    <script type="text/javascript">
        function saveInter() {
            $("#lblMsg").text('');
            if ($("#ddlCentre").val() == "0") {
                $("#lblMsg").text('Please Select From Centre');
                $("#ddlCentre").focus();
                return;
            }
            if ($("#ddlMappingCentre").val() == "0") {
                $("#lblMsg").text('Please Select To Centre');
                $("#ddlMappingCentre").focus();
                return;
            }
            if ($("#ddlMachine").val() == "0") {
                $("#lblMsg").text('Please Select To Machine');
                $("#ddlMachine").focus();
                return;
            }
            if ($("#ddlMappingMachine").val() == "0") {
                $("#lblMsg").text('Please Select To Machine');
                $("#ddlMappingMachine").focus();
                return;
            }
            if ($("#ddlCentre").val() == $("#ddlMappingCentre").val()) {
                $("#lblMsg").text('From Centre and To Centre Can not be Same');
                $("#ddlMappingCentre").focus();
                return;
            }
            if ($("#ddlMachine").val() == $("#ddlMappingMachine").val()) {
                $("#lblMsg").text('From Machine and To Machine Can Not be Same');
                $("#ddlMappingMachine").focus();
                return;
            }
            var Ok = confirm('Are you sure?');
            if (Ok)  {
                $("#btnSave").attr('disabled', 'disabled').val('Submitting...');

                MapInvestigationObservation.mappingInterpretation($("#ddlCentre").val(), $("#ddlMappingCentre").val(), $("#ddlMachine").val(), $("#ddlMappingMachine").val(), $("#ddlDepartment").val(), onSuccessCallback, OnfailureCallback);


            }

        }

        function onSuccessCallback(Result) {
            if (Result == "1") {
                $("#lblMsg").text('Record Saved Successfully');
            }
            else {
                $("#lblMsg").text('Error..');
            }
            $("#btnSave").removeAttr('disabled').val('Save');
            $("#ddlCentre,#ddlMappingCentre,#ddlMachine,#ddlMappingMachine,#ddlDepartment").prop('selectedIndex', 0);
           
        }
        function OnfailureCallback(error) {
            $("#lblMsg").text('Error..');
            $("#btnSave").removeAttr('disabled').val('Save');
           
        }
    </script>
</asp:Content>

