<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CopyItemfromLocation.aspx.cs" Inherits="Design_Store_CopyItemfromLocation" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
      <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
 <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

     <div id="Pbody_box_inventory" style="width:1304px;">
              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Copy Mapped Item From Location</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
          <div class="POuter_Box_Inventory" style="width:1300px;">
              <div class="content">
                <div class="Purchaseheader">Location Details</div>
                  <table width="100%">
                     
                      <tr>
                          <td style="font-weight: 700">From Location Name :</td>
                          <td>
                              <asp:DropDownList ID="ddlpanel" runat="server" Width="650px" class="ddlpanel chosen-select chosen-container"></asp:DropDownList>
                          &nbsp;&nbsp;

                              <input type="button" value="Search" class="searchbutton" onclick="searchme()" />

                              &nbsp;&nbsp;

                               <input type="button" value="Copy Item" id="btn" style="display:none;" class="savebutton" onclick="saveme()" />

                          </td>
                      </tr>
                     
                      <tr>
                          <td style="font-weight: 700">To Location Name :</td>
                          <td>
                              <asp:ListBox ID="lstlocationto" CssClass="multiselect " SelectionMode="Multiple" Width="650px" runat="server" ClientIDMode="Static"></asp:ListBox></td>
                      </tr>
                  </table>
                  </div>
              </div>


         <div class="POuter_Box_Inventory" style="width:1300px;">
           <div class="content">
               <div style="max-height:400px;overflow:auto;">
                 <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        
                                        <td class="GridViewHeaderStyle">Item Category</td>
                                        <td class="GridViewHeaderStyle">Item Subcategory</td>
                                        <td class="GridViewHeaderStyle">ItemName</td>
                                       <td class="GridViewHeaderStyle">Manufacture</td>
                                         <td class="GridViewHeaderStyle">Machine</td>
                                         <td class="GridViewHeaderStyle">PackSize</td>
                                         <td class="GridViewHeaderStyle">CatalogNo</td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;"><input type="checkbox" id="chheader" class="mmc" onclick="checkall(this)" /></td>
                                        
                                     </tr>
                                 </table></div>
               </div>
                </div>
              
      </div>



    <script type="text/javascript">

        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }

        $(document).ready(function () {
            $('#<%=lstlocationto.ClientID%>').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


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


        function checkall(ctr) {
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {

                    if ($(ctr).is(":checked")) {

                        $(this).find('#chk').attr('checked', true);
                    }
                    else {
                        $(this).find('#chk').attr('checked', false);
                    }


                }
            });
        }
        function searchme() {

            if ($('#<%=ddlpanel.ClientID%>').val() == "0") {
                showerrormsg("Please Select Location");

                $('#<%=ddlpanel.ClientID%>').focus();
                return;
            }

            $('#tblitemlist tr').slice(1).remove();
            $.blockUI();
            jQuery.ajax({
                url: "CopyItemfromLocation.aspx/SearchRecords",
                data: '{locationid:"' + $('#<%=ddlpanel.ClientID%>').val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        $('#btn').hide();
                        showerrormsg("No Item Mapped With This Location");
                        $.unblockUI();
                        $('#<%=ddlpanel.ClientID%>').focus();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:palegreen;' id='" + ItemData[i].LedgerTransactionID + "'>";

                            mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "</td>";
                            mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].SubCategoryTypeName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].Name + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].Typename + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ManufactureName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].MachineName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].PackSize + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].CatalogNo + '</td>';
                            
                            mydata += '<td class="GridViewLabItemStyle"><input type="checkbox" id="chk" class="mmc" /></td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"  id="tdlocationid">' + ItemData[i].locationid + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"  id="tditemid" >' + ItemData[i].itemid + '</td>';

                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                            $('#btn').show();
                        }
                        $.unblockUI();
                    }
                },
                error: function (xhr, status) {
                    showerrormsg("Error ");
                    $.unblockUI();
                }
            });
        }

        function saveme() {
            var testid = "";
            var locationidfrom = "";
            $('#tblitemlist tr').each(function () {
                if ($(this).attr('id') != "triteheader") {

                    if ($(this).find("#chk").is(":checked")) {

                        testid += $(this).find('#tditemid').text() + ",";
                        locationidfrom = $(this).find('#tdlocationid').text();
                    }



                }
            });
            if (testid == "") {

                showerrormsg("Please Select Item");
                return;
            }

            var locationidto = $('#<%=lstlocationto.ClientID%>').val();

            if (locationidto == "") {
                showerrormsg("Please Select To Location");
                return;
            }
            $.blockUI();
            jQuery.ajax({
                url: "CopyItemfromLocation.aspx/savedata",
                data: '{locationidfrom:"' + locationidfrom + '",locationidto:"' + locationidto + '",testid:"' + testid + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {

                    if (result.d == "1") {
                        showmsg("Data Copy Sucessfully");

                        $('.mmc').prop('checked', false);
                    }
                    else {
                        showerrormsg(result.d);
                    }
                    $.unblockUI();

                },
                error: function (xhr, status) {
                    showerrormsg("Error ");
                    $.unblockUI();
                }
            });


        }
    </script>
</asp:Content>

