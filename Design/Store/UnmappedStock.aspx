<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="UnmappedStock.aspx.cs" Inherits="Design_Store_UnmappedStock" %>

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
     <%: Scripts.Render("~/bundles/JQueryStore") %>

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

     
     <div id="Pbody_box_inventory" style="width:1304px;">

         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

           <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Mapped / UnMapped Stock
                             
                            
                          </b>  
                        </td>


                    </tr>
                    <tr>
                        <td style="padding-left:250px;">
                             <strong>Current Location :</strong>&nbsp;   <asp:DropDownList  style="width:400px;text-align:left;" class="ddllocation chosen-select chosen-container" ID="ddllocation" runat="server" ></asp:DropDownList>
                     
                            &nbsp;<asp:DropDownList ID="ddltype" runat="server" >
                                <asp:ListItem Value="">All</asp:ListItem>
                                 <asp:ListItem Value="Mapped">Mapped</asp:ListItem>
                                 <asp:ListItem Value="UnMapped">UnMapped</asp:ListItem>
                            </asp:DropDownList>               
                   &nbsp;<input type="button" value="Search" class="savebutton" onclick="SearchData('');" id="Button1" />&nbsp;<input type="button" value="Get Excel" class="searchbutton" onclick="GetReport();" id="btnsave" /></td>
                    </tr>
                    </table>
                </div>


              </div>
         

          

                 <div class="POuter_Box_Inventory" style="width:1300px; text-align:center;">
               <div class="content">
                  
                                                 <table width="60%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Mapped</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Not Mapped</td>
                  
                    
                </tr>
            </table>
                                         </div>
                     </div>


         <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Stock Detail</div>

                <div style="width:99%;max-height:330px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                     
                                         
                                        <td class="GridViewHeaderStyle" style="width:30px;">SrNo</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">CatalogNo</td>
                                        <td class="GridViewHeaderStyle">BatchNumber</td>
                                        <td class="GridViewHeaderStyle">BarcodeNo</td>
                                        <td class="GridViewHeaderStyle">ExpiryDate</td>
                                        <td class="GridViewHeaderStyle">InhandQty</td>
                                        
                                        
                                        <td class="GridViewHeaderStyle">Unit</td>
                                        
                                        <td class="GridViewHeaderStyle">UnitPrice</td>
                                        <td class="GridViewHeaderStyle">Mapping</td>
                                        <td class="GridViewHeaderStyle">PI</td>

                       
                                        
                        </tr>
                </table>

                   
                </div></div>
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

        function SearchData(type) {
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
            $('#tblitemlist tr').slice(1).remove();
            $.blockUI();
            $.ajax({
                url: "UnmappedStock.aspx/SearchData",
                data: '{locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '",type:"' + $('#<%=ddltype.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                   

                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Stock Found");
                        $.unblockUI();
                      
                    }
                    else {

                        for (var i = 0; i <= ItemData.length - 1; i++) {

                            var mydata = "<tr style='background-color:" + ItemData[i].rowcolor + ";' id='trbody' class='tr_clone'>";
                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i+1)+ '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].Itemname1 + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].CatalogNo + '</td>';
                            
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].BatchNumber + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].BarcodeNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].ExpiryDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  >' + precise_round(ItemData[i].InhandQty,5) + ' </td>';
                            mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].MinorUnitName + ' </td>';
                            
                            mydata += '<td class="GridViewLabItemStyle"  >' + precise_round(ItemData[i].UnitPrice,5) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].Mapped_UnMapped + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[i].IsPIItem + '</td>';
                            

                            $('#tblitemlist').append(mydata);
                        }
                        $.unblockUI();
                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });

        }

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function GetReport() {

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



            $.blockUI();
            $.ajax({
                url: "UnmappedStock.aspx/GetReport",
                data: '{locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '",type:"'+$('#<%=ddltype.ClientID%>').val()+'"}',
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
</asp:Content>

