<%@ Page Language="C#" ClientIDMode="Static" AutoEventWireup="true" CodeFile="DocShareStatus.aspx.cs" Inherits="Design_DocAccount_DocShareStatus" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
         <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
         <%: Scripts.Render("~/bundles/WebFormsJs") %>
    
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <form id="form1" runat="server">
         
  
   <div id="Pbody_box_inventory" style="width:786px">
        <Ajax:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="POuter_Box_Inventory" style="text-align: center;width:780px">
            <b>Change Doctor Share Status</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="width:780px">
            <div class="Purchaseheader">
                &nbsp;
            </div>
       <table style="width:100%; border-collapse:collapse" border="0">         
                <tr>
                    <td colspan="2" style="text-align:center">
                         <asp:Label ID="Label1" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>                                         
              <tr>
                  <td>
                      Doctor :&nbsp;
                  </td>
                  <td>
                        <input type="hidden" id="theHidden" />
                      <input id="txtDoctor" size="50"  />
                  </td>
              </tr>
               <tr>
                  <td>
                      Refer Share :&nbsp;
                  </td>
                  <td>
                        <input type="checkbox" id="chkReferShare" />
                  </td>
              </tr>
              <tr>
                    <td colspan="2" style="text-align:center">
                         <input type="button" id="btnUpdateReferShare" value="Update" onclick="ReferShare();" 
                        class="savebutton" />
                    </td>
                </tr>
              </table>
            </div>
    </div>
        <script type="text/javascript">
            jQuery(function () {
                jQuery("#txtDoctor")
                        .bind("keydown", function (event) {
                            if (event.keyCode === $.ui.keyCode.TAB &&
                        $(this).autocomplete("instance").menu.active) {
                                event.preventDefault();
                            }
                            jQuery("#lblMsg").text('');
                            jQuery("#theHidden").val('');
                        })
                      .autocomplete({
                          autoFocus: true,
                          source: function (request, response) {
                              jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=DoctorShareStatus", {
                                  DoctorName: extractLast(request.term)
                              }, response);
                          },
                          search: function () {
                              var term = extractLast(this.value);
                              if (term.length < 2) {
                                  return false;
                              }
                          },
                          focus: function () {
                              return false;
                          },
                          select: function (event, ui) {
                              jQuery("#theHidden").val(ui.item.value);
                              this.value = ui.item.label;
                              return false;
                          },
                      });

            });
        
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }
            function ReferShare() {
                jQuery("#lblMsg").text('');
                if (jQuery.trim(jQuery("#theHidden").val()) == "" || jQuery.trim(jQuery("#theHidden").val()) == 0) {
                    jQuery("#lblMsg").text('Please Select Doctor');
                    jQuery("#txtDoctor").focus();
                    return;
                }
                jQuery("#btnUpdateReferShare").attr('disabled', true).val("Submitting...");
                
                var ReferShare = 0;
                if (jQuery('#chkReferShare').is(':checked'))
                    ReferShare = 1;
                PageMethods.UpdateDocStatus(jQuery('#theHidden').val(),ReferShare, onSucessDocStatus, onFailureDocStatus);
            }
            function onSucessDocStatus(result) {
                if (result == 1) {
                    jQuery("#lblMsg").text('Record Updated Successfully ');
                }
                else {
                    jQuery("#lblMsg").text('Error');
                }
                jQuery("#btnUpdateReferShare").attr('disabled', false).val("Update");
            }
            function onFailureDocStatus(result) {

            }
            </script>
    </form>
</body>
</html>
