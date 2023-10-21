

<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="NFAReport.aspx.cs" Inherits="Design_Store_NFAReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>


    
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

     <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width:1300px">
        <div class="POuter_Box_Inventory" style="width:1300px">
            <div class="content" style="text-align:center">
                <b>NFA Report</b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" Visible="false"></asp:Label>
            </div>
        </div>
       <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Location Detail</div>

                <table width="100%">
                  
                    <tr>
                        <td style=" font-weight: 700">From Date :&nbsp;&nbsp;</td>
                        <td >  
                            <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                           &nbsp;&nbsp; <strong>To Date :
                            <asp:TextBox ID="txttodate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                            </strong> </td>
                       
                        <td style=" font-weight: 700">Location&nbsp; :</td>
                        <td colspan="2" >
                            <asp:DropDownList ID="ddllocation" class="ddllocation chosen-select chosen-container" runat="server" style="width:400px;" onchange="getindentno()"></asp:DropDownList> 

                           </td>
                        <td>
                            &nbsp;</td>
                       
                    </tr>
                  
                    <tr>
                        <td style=" font-weight: 700">Vendor :</td>
                        <td >  
                           <asp:DropDownList ID="ddlsupplier" runat="server" class="ddlsupplier chosen-select chosen-container" Width="400px" >

                           </asp:DropDownList>

                                </td>
                       
                        <td style=" font-weight: 700">Indent No :</td>
                        <td >
                            <asp:DropDownList ID="txtindentno" runat="server" class="txtindentno chosen-select chosen-container" Width="200px"></asp:DropDownList>

                            &nbsp;&nbsp;
                            <asp:CheckBox ID="ch" runat="server" Text="Pending PI Only" Font-Bold="true"  onclick="getindentno()" />

                          
                        </td>
                        <td style=" font-weight: 700">&nbsp;</td>
                        <td>
                            &nbsp;</td>
                       
                    </tr>
                  
                    <tr>
                        <td style=" font-weight: 700">&nbsp;</td>
                        <td >  
                            &nbsp;</td>
                       
                        <td style=" font-weight: 700">&nbsp;</td>
                        <td >
                            &nbsp;</td>
                        <td style=" font-weight: 700">&nbsp;</td>
                        <td>
                            &nbsp;</td>
                       
                    </tr>
                    <tr>
                       
                      <td colspan="6" style="text-align: center">  <input type="button" value="Get Report" class="searchbutton" onclick="searchitem()" /></td>
                       
                    </tr>
                    </table>
                </div>
             </div>
        </div>

    <script type="text/javascript">
        function getindentno() {


            var labid = $('#<%=ddllocation.ClientID%>').val();
            jQuery('#<%=txtindentno.ClientID%> option').remove();
            $('#<%=txtindentno.ClientID%>').trigger('chosen:updated');

            if (labid != "0" && labid != null) {
                var pendingpionly = $("#<%=ch.ClientID%>").is(':checked') ? 1 : 0;
               
                $.blockUI();
                $.ajax({
                    url: "NFAreport.aspx/bindindentno",
                    data: '{locationid: "' + labid + '",fromdate:"' + $('#<%=txtFromDate.ClientID%>').val() + '",todate:"' + $('#<%=txttodate.ClientID%>').val() + '",pendingpionly:"' + pendingpionly + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,

                    dataType: "json",
                    success: function (result) {

                        CentreLoadListData = $.parseJSON(result.d);
                        if (CentreLoadListData.length == 0) {
                            showerrormsg("No Indent No Found With in Selected Date Range");
                        }

                        jQuery("#<%=txtindentno.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Indent No"));
                        for (i = 0; i < CentreLoadListData.length; i++) {

                            jQuery("#<%=txtindentno.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].IndentNo).html(CentreLoadListData[i].IndentNo));
                        }

                        $("#<%=txtindentno.ClientID%>").trigger('chosen:updated');





                        $.unblockUI();
                    },
                    error: function (xhr, status) {
                        //  alert(status + "\r\n" + xhr.responseText);
                        window.status = status + "\r\n" + xhr.responseText;
                        $.unblockUI();
                    }
                });
            }
        }


        

    </script>

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

        function searchitem() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("No Location Found For Current User..!");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                showerrormsg("Please Select Location");
                $('#<%=ddllocation.ClientID%>').focus();
                return;
            }


            $.ajax({
                url: "NFAreport.aspx/GetReportPDF",
                data: '{fromdate:"' + $('#<%=txtFromDate.ClientID%>').val() + '",todate:"' + $('#<%=txttodate.ClientID%>').val() + '",LocationID:"' + $('#<%=ddllocation.ClientID%>').val() + '",supplierid:"' + $('#<%=ddlsupplier.ClientID%>').val() + '",indentno:"' + $('#<%=txtindentno.ClientID%>').val() + '"}',
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
                        window.open('Report/commonreportstore.aspx');
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }

        </script>
        </asp:Content>
   