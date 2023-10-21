<%@ Control Language="C#" AutoEventWireup="true" CodeFile="InvoiceSearch.ascx.cs" ClientIDMode="Static" Inherits="Design_UserControl_InvoiceSearch" %>

<table style="width: 100%; border-collapse: collapse">
    <tr class="trType">
        <td style="text-align: right; width: 20%">Business Zone :&nbsp;</td>
        <td style="text-align: left; width: 30%">
            <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" Width="280px" class="ddlBusinessZone chosen-select">
            </asp:DropDownList>
        </td>
        <td style="text-align: right; width: 20%">State :&nbsp;</td>
        <td style="text-align: left; width: 30%">
            <asp:DropDownList ID="ddlState" runat="server" Width="190px" onchange="bindPanel()" class="ddlState chosen-select">
            </asp:DropDownList>
            &nbsp;
                       <input style="font-weight: bold;" type="button" value="More Filter" class="ItDoseButton" id="btnMoreFilter" onclick="showSearch();" />
        </td>
    </tr>
</table>
<div class="divSearchInfo" style="display: none;" id="divSearch">
    <div style="width: 1300px; background-color: papayawhip;">
        <div class="Purchaseheader">
            Search Option
        </div>
        <table style="width: 100%; border-collapse: collapse">
            <tr>
                <td style="text-align: right; width: 20%">City :&nbsp;</td>
                <td style="text-align: left; width: 30%">
                    <asp:TextBox ID="txtCity" runat="server" Width="274px"></asp:TextBox>

                </td>
                <td style="text-align: right; width: 20%">&nbsp;</td>
                <td style="text-align: left; width: 30%">
                    <asp:DropDownList ID="ddlCity" runat="server" Width="280px" class="ddlCity chosen-select">
                    </asp:DropDownList>&nbsp;&nbsp;<input style="font-weight: bold;" type="button" value="Back" class="ItDoseButton" onclick="hideSearch();" />

                    &nbsp;&nbsp;<input style="font-weight: bold;" type="button" value="Search" class="ItDoseButton" onclick="bindPanel()" />

                </td>
            </tr>
        </table>
    </div>
</div>
<table style="width: 100%; border-collapse: collapse">
    <tr>
        <td style="text-align: right; width: 20%">Client Name :&nbsp;</td>
        <td style="width: 30%">
            <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="360px"></asp:ListBox>
            <span style="color: red">*</span></td>
        <td style="text-align: right; width: 20%;">&nbsp;</td>
        <td style="text-align: left; width: 30%;">&nbsp;</td>
    </tr>
</table>
 <script type="text/javascript">
     $(function () {
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
    </script>

 <script type="text/javascript">
     jQuery(function () {
         jQuery('[id*=lstPanel]').multipleSelect({
             includeSelectAllOption: true,
             filter: true, keepOpen: false
         });
     });
     function showSearch() {
         jQuery('.divSearchInfo').slideToggle("slow", "linear");
         jQuery('#divSearch').show();
         jQuery('#btnMoreFilter').hide();
         jQuery("#ddlCity_chosen,#ddlPanelCity_chosen").width("190px");
     }
     function hideSearch() {
         jQuery('.divSearchInfo').slideToggle("slow", "linear");
         jQuery('#divSearch').hide();
         jQuery('#btnMoreFilter').show();
     }
     function bindState() {
         jQuery("#lblMsg").text('');
         jQuery("#ddlState option").remove();
         jQuery("#ddlCity").find("option:gt(0)").remove();
         jQuery('#ddlCity,#ddlState').trigger('chosen:updated');
         jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            if (jQuery("#ddlBusinessZone").val() != 0)
                CommonServices.bindState(jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
        }
        function onSucessState(result) {
            var stateData = jQuery.parseJSON(result);

            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
            if (stateData.length > 0) {
                jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("All"));
            }
            for (i = 0; i < stateData.length; i++) {
                jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
            }
            jQuery('#ddlState').trigger('chosen:updated');
            if ($("#ddlCity option[value='-1']").length == 0)
                jQuery("#ddlCity").append(jQuery("<option></option>").val("-1").html("All"));
        }
        function onFailureState() {

        }

        
    </script>
<script type="text/javascript">
    jQuery(function () {
        jQuery('#txtCity').bind("keydown", function (event) {
            if (event.keyCode === jQuery.ui.keyCode.TAB &&
                jQuery(this).autocomplete("instance").menu.active) {
                event.preventDefault();
            }
            if (jQuery("#ddlBusinessZone").val() == "0") {
                showerrormsg("Please Select BusinessZone");
                jQuery("#ddlBusinessZone").focus();
                jQuery('#txtCity').val('');
                return;
            }
            if (jQuery("#ddlState").val() == "0") {
                showerrormsg("Please Select State");
                jQuery("#ddlState").focus();
                jQuery('#txtCity').val('');
                return;
            }
        })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=bindCity", {
                          BusinessZoneID: jQuery("#ddlBusinessZone").val(),
                          StateID: jQuery("#ddlState").val(),
                          CityName: request.term
                      }, response);
                  },
                  search: function () {
                      // custom minLength                    
                      var term = this.value;
                      if (term.length < 3) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {
                      if ($("#ddlCity option[value='" + ui.item.value + "']").length == 0) {
                          jQuery("#ddlCity").append(jQuery("<option></option>").val(ui.item.value).html(ui.item.label));
                          jQuery('#ddlCity').trigger('chosen:updated');
                      }
                      else {
                          showerrormsg("City Already Added");
                      }
                      jQuery('#txtCity').val('');
                      return false;
                  },
              });
    });
</script>

