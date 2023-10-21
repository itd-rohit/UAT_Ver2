<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="StockExpiryChange.aspx.cs" Inherits="Design_Store_StockExpiryChange" %>

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
                <b>Stock Expiry Change</b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" Visible="false"></asp:Label>
            </div>
        </div>
       <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Location Detail</div>

                <table width="100%">
                    <tr>
                        <td style="text-align: right; font-weight: 700">Current Location :&nbsp; </td>
                      <td>  <asp:DropDownList ID="ddllocation" class="ddllocation chosen-select chosen-container" runat="server" style="width:400px;"></asp:DropDownList> &nbsp;&nbsp;&nbsp;
                          
                          &nbsp;&nbsp;<input type="button" value="Search Item" class="searchbutton" onclick="searchitem()" />

                          <input type="button" class="savebutton" onclick="savealldata()" id="btnsave" style="display:none;" value="Save" />
                      </td>
                       
                    </tr>
                    </table>
                </div>
             </div>
        
         <div class="POuter_Box_Inventory" style="width: 1300px;">
        <div class="content" style="width: 1300px;">
<div style="height:400px;overflow:scroll;width:99%">
                               <table id="itemgrd"  width="99%" class="GridViewStyle" cellpadding="1" rules="all" border="1" style="border-collapse: collapse">
                                   <tr id="header">
					
                    <th class="GridViewHeaderStyle" scope="col" style="width:25px;">S.No</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">StockID</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Barcodeno</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:250px;">ItemName</th>
                    <th class="GridViewHeaderStyle" scope="col" >Manufacture</th>
                    <th class="GridViewHeaderStyle" scope="col" >Machine</th>
                    <th class="GridViewHeaderStyle" scope="col" >PackSize</th>
                    <th class="GridViewHeaderStyle" scope="col" >HsnCode</th>
                    <th class="GridViewHeaderStyle" scope="col" >CatalogNo</th>
                    <th class="GridViewHeaderStyle" scope="col" >InHand Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Batch Number</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Expiry Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:30px">Select</th>
                    
                   
				</tr>
                               </table>
                           </div>
        </div>
    </div>
        </div>
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
                $("#itemgrd").find("tr:gt(0)").remove();
                $.blockUI();
                $.ajax({
                    url: "StockExpiryChange.aspx/getstockdata",
                    data: '{locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '"}',
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        ItemData = jQuery.parseJSON(result.d);
                        if (ItemData.length == 0) {
                            showerrormsg("No Item Found In Stock");
                            $('#tblitemlist tr').slice(1).remove();
                            $.unblockUI();
                            $('#btnsave').hide();

                        }
                        else {
                            $('#btnsave').show();
                            for (var a = 0; a <= ItemData.length - 1; a++) {
                                var myid = ItemData[a].stockid;
                                var mydata = '<tr style="background-color:bisque;height:50px;" id=' + myid + '>';

                                mydata += '<td>' + parseFloat(a + 1) + '</td>';
                                mydata += '<td  class="GridViewLabItemStyle"  id="StockID">' + ItemData[a].stockid + '</td>';
                                mydata += '<td  class="GridViewLabItemStyle"  id="barcodeno">' + ItemData[a].barcodeno + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[a].itemname + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[a].ManufactureName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle"  >' + ItemData[a].MachineName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" >' + ItemData[a].packsize + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" >' + ItemData[a].HsnCode + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" >' + ItemData[a].CatalogNo + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + ItemData[a].InHandQty + ' ' + ItemData[a].minorunit + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" id="BatchNo" value="' + ItemData[a].batchnumber + '" readonly="readonly"/></td>';
                                mydata += '<td class="GridViewLabItemStyle" ><input type="text" class="datepick" id="txtexpirydate' + myid + '" value="' + ItemData[a].ExpiryDate + '"/></td>';
                                mydata += '<td class="GridViewLabItemStyle" ><input id="chkSelect" type="checkbox"  ></td>';
                                mydata += '</tr>';
                                $('#itemgrd').append(mydata);


                              



                                var date = new Date();
                                var newdate = new Date(date);

                                newdate.setDate(newdate.getDate() + parseInt(ItemData[0].expdatecutoff));

                                var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                           "Aug", "Sep", "Oct", "Nov", "Dec"];

                                var val = newdate.getDate() + "-" + months[newdate.getMonth()] + "-" + newdate.getFullYear();




                                $("#txtexpirydate" + myid).datepicker({
                                    dateFormat: "dd-M-yy",
                                    changeMonth: true,
                                    changeYear: true, yearRange: "-0:+20", minDate: val

                                });


                            }
                            $.unblockUI();
                        }

                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
                    }
                });

            }

            function getcompletedataadj() {
                var tempData = [];
                $('#itemgrd tr').each(function () {
                    if ($(this).attr("id") != "header" && $(this).find("#chkSelect").is(':checked')) {
                        var itemmaster = [];

                        itemmaster[0] = $(this).find("#StockID").html();
                        itemmaster[1] = $(this).find(".datepick").val();
                        itemmaster[2] = $(this).find("#BatchNo").val();
                        tempData.push(itemmaster);
                    }
                });
                return tempData;
            }



            function savealldata() {

                var mydataadj = getcompletedataadj();
                if (mydataadj.length == 0) {
                    showerrormsg("Please Select Item To Save");
                    return;
                }


                $.ajax({
                    url: "StockExpiryChange.aspx/savestock",
                    data: JSON.stringify({ mydataadj: mydataadj }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg("Stock Uploaded Successfully..!");
                            searchitem();

                        }
                        else {
                            showerrormsg(result);
                        }

                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
                    }
                });
            }

                </script>
</asp:Content>

