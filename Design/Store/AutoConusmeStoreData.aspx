<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AutoConusmeStoreData.aspx.cs" Inherits="Design_Store_AutoConusmeStoreData" %>

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
                          <b>Auto Consume Store Item</b>  
                        </td>
                    </tr>
                    </table>
                </div>


              </div>

         <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Location Detail</div>

                <table width="100%">

                     <tr>
                        <td style="font-weight: 700">From Date:</td>
                        <td>
                             <asp:TextBox ID="txtFromDate" runat="server" Width="90px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="font-weight: 700">To Date:</td>
                        <td>
                             <asp:TextBox ID="txtToDate" runat="server" Width="90px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                      
                       <td style="text-align: right; font-weight: 700">Location :&nbsp; </td>
                      <td>  <asp:DropDownList ID="ddllocation" runat="server" style="width:350px;" class="ddllocation chosen-select chosen-container"></asp:DropDownList>
                      </td> 
                         <td  style="text-align: right; font-weight: 700">
                             Machine :</td>
                             :<td>
                             <asp:DropDownList ID="ddlmachine" runat="server" class="ddlmachine chosen-select chosen-container" width="150px"></asp:DropDownList>
                         </td>
                         <td>     
                         <input type="button" value="Search Item" class="searchbutton" onclick="searchitem()" /><input type="button" value="Reset" onclick="resetme()" class="resetbutton" /></td>

                    </tr>


                   
                  
                </table>
                </div>
             </div>
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Item Detail</div>

                <div style="width:99%;max-height:380px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                     
                                        <th class="GridViewHeaderStyle"  style="width:20px;">S.No</th>
                                       
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                       
			                            <td class="GridViewHeaderStyle">Issue Date</td>
                                        <td class="GridViewHeaderStyle">Batch Number</td>
                                        <td class="GridViewHeaderStyle">Expiry Date</td>
                                        <td class="GridViewHeaderStyle">Barcode No</td>
	                                    <td class="GridViewHeaderStyle">Current Stock Qty</td>
                         <td class="GridViewHeaderStyle">Event</td>
                         <td class="GridViewHeaderStyle">Barcodeno</td>
                        <td class="GridViewHeaderStyle">Calculated Qty</td>
                        
                                        <td class="GridViewHeaderStyle" style="display:none;"><input type="text" name="consumeremarks" onkeyup="showme2(this)"  placeholder="All Consume Remarks" maxlength="180" /></td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;"><input type="checkbox" onclick="checkall(this)"  /></td>
                       
                                       
                        </tr>
                </table>

                    <center>
                        <input type="button" class="savebutton" onclick="savealldata()" id="btnsave" style="display:none;" value="Save" />
                    </center>
                </div></div>
              </div>
        </div>


       <asp:Panel ID="OnlineFilterOLD" runat="server" Style="display: none;">
            <div class="POuter_Box_Inventory" style="width: 1200px; background-color: papayawhip">
                <div class="Purchaseheader">
                    Detail
                </div>
                <div class="content" style="text-align: center; overflow:scroll;height:400px" >
                    <table id="Table1" style="width:99%;border-collapse:collapse;text-align:left;">
                        <tr id="tr1">

                            <th class="GridViewHeaderStyle" style="width: 20px;">S.No</th>

                            <td class="GridViewHeaderStyle">Booking Centre</td>

                            <td class="GridViewHeaderStyle">Visit ID</td>
                            <td class="GridViewHeaderStyle">UHID</td>
                            <td class="GridViewHeaderStyle">Patient Name</td>
                            <td class="GridViewHeaderStyle">Age</td>
                            <td class="GridViewHeaderStyle">Gender</td>
                            <td class="GridViewHeaderStyle">Test Name</td>
                            <td class="GridViewHeaderStyle">Consume Type</td>
                            <td class="GridViewHeaderStyle">Event</td>
                            <td class="GridViewHeaderStyle">EventDate</td>



                        </tr>
                </table>


                    <table width="99%" >
                        
                        <tr>
                            <td align="center">
                                
                               
                              
                                <asp:Button ID="btnCloseOnlinePOPUP" CssClass="resetbutton" Text="Close" runat="server" />
                            </td>
                        </tr>
                    </table>

                    
                </div>
            </div>
        </asp:Panel>



                 <cc1:ModalPopupExtender ID="ModalPopupOnlineFilter" runat="server" CancelControlID="btnCloseOnlinePOPUP" TargetControlID="btnCloseOnlinePOPUP"
        BackgroundCssClass="filterPupupBackground" PopupControlID="OnlineFilterOLD">
    </cc1:ModalPopupExtender>


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

        function openmypopup(href) {
            var width = '1100px';

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
    </script>

    <script type="text/javascript">
      


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

              var fromdate = $('#<%=txtFromDate.ClientID%>').val();
              var todate = $('#<%=txtToDate.ClientID%>').val();

            
          
            $.blockUI();
        
            $.ajax({
                url: "AutoConusmeStoreData.aspx/SearchData",
                data: '{locationid:"' + $('#<%=ddllocation.ClientID%>').val() + '",fromdate:"' + fromdate + '",todate:"' + todate + '",macid:"' + $('#<%=ddlmachine.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Auto Consume Data Found");
                        $('#tblitemlist tr').slice(1).remove();
                        $.unblockUI();
                        $('#btnsave').hide();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            if ($('table#tblitemlist').find('#' + ItemData[i].stockid).length > 0) {
                                showerrormsg("Item Already Added. Please Increase Qty.");
                                $.unblockUI();
                                return;
                            }
                            var mydata = "<tr style='background-color:bisque;' id='" + ItemData[i].stockid + "'>";

                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tditemname">' + ItemData[i].itemname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdstockdate">' + ItemData[i].stockdate + '</td>';

                            mydata += '<td class="GridViewLabItemStyle" id="tdbatchnumber" >' + ItemData[i].batchnumber + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdexpirydate" >' + ItemData[i].ExpiryDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdbarcodeno" >' + ItemData[i].barcodeno + '</td>';



                            mydata += '<td id="Balance" title="Stock Qty Show in Software"><span id="spbal" style="font-weight:bold;">' + precise_round(ItemData[i].InHandQty, 5) + '</span>';
                            mydata += '&nbsp;<span style="font-weight:bold;color:red;" >' + ItemData[i].minorunit + '</span></td>';

                            mydata += '<td class="GridViewLabItemStyle" id="tdEventtypeName">' + ItemData[i].EventtypeName + '</td>';

                            mydata += '<td class="GridViewLabItemStyle" id="tdbarcodeno" style="font-weight:bold;">' + ItemData[i].barcodelist + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" title="Enter Consume Qty">';
                            mydata += '&nbsp;<span style="font-weight:bold;color:white;background-color:blue;padding:2px;" id="totalqty">' + ItemData[i].TotalUsedQty + '</span>&nbsp;&nbsp;';
                            mydata += '<input type="text" id="txtconsumeqty" style="width:70px;" onkeyup="showme(this)" />';
                            mydata += '&nbsp;<span style="font-weight:bold;color:red;">' + ItemData[i].minorunit + '</span></td>';


                            mydata += '<td class="GridViewLabItemStyle" style="display:none;"><input type="text" placeholder="Consume Remarks" maxlength="180" id="txtconsumeremarks" name="consumeremarks"/></td>';
                            mydata += '<td class="GridViewLabItemStyle" ><input type="checkbox" id="chk"   /></td>';

                            mydata += '<td style="display:none;" id="tdlocationid">' + ItemData[i].locationid + '</td>';
                            mydata += '<td style="display:none;" id="tdpanelid">' + ItemData[i].panel_id + '</td>';
                            mydata += '<td style="display:none;" id="tdItemID">' + ItemData[i].itemid + '</td>';
                            mydata += '<td style="display:none;" id="tdisdecimalallowed">' + ItemData[i].MinorUnitInDecimal + '</td>';
                            mydata += '<td style="display:none;" id="tdIsExpirable">' + ItemData[i].IsExpirable + '</td>';
                            mydata += '<td style="display:none;" id="tdconid">' + ItemData[i].conid + '</td>';

                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);


                            $('#btnsave').show();

                        }
                      
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });

        }
        function showme2(ctrl) {


            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");

            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });


        }

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }

        function showme(ctrl) {

            if ($(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "" || $(ctrl).closest('tr').find('#tdisdecimalallowed').html() == "0") {

                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }
            //if ($(ctrl).val().indexOf(".") != -1) {
            //    $(ctrl).val($(ctrl).val().replace('.', ''));
            //}
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            // alert($(ctrl).closest("tr").find("#txttddisc").text());

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }


            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }

            if (parseFloat($(ctrl).val()) > parseFloat($(ctrl).closest('tr').find('#spbal').html())) {

                showerrormsg("Consume Qty Can't Greater Then Current Stock Qty");
                $(ctrl).val($(ctrl).closest('tr').find('#spbal').html());
                return;
            }
            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#chk').prop('checked', true)
            }
            else {
                $(ctrl).closest('tr').find('#chk').prop('checked', false)
            }

        }





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


        function validation() {

            var che = "true";
            var a = $('#tblitemlist tr').length;
            if (a == 1) {
                showerrormsg("Please Search Item..!");
                return false;
            }
            if (a > 0) {
                $('#tblitemlist tr').each(function () {
                    if ($(this).attr("id") != "triteheader" && $(this).find("#chk").is(':checked') && ($(this).find("#txtconsumeqty").val() == "" || $(this).find("#txtconsumeqty").val() == "0")) {
                        $(this).find("#txtconsumeqty").focus();
                        showerrormsg("You have not Entered Qty");
                        che = "false";
                        return false;

                    }
                });
            }
            if (che == "false") {
                return false;
            }

            return true;
        }

    </script>

    <script type="text/javascript">

        function getcompletedataadj() {
            var tempData = [];

            $('#tblitemlist tr').each(function () {

                if ($(this).attr("id") != "triteheader") {
                    if ($(this).find("#chk").is(':checked')) {

                        var Itemmaster = [];
                        Itemmaster[0] = $(this).find('#tdlocationid').html();
                        Itemmaster[1] = $(this).find('#tdpanelid').html();
                        Itemmaster[2] = $(this).attr("id");
                        Itemmaster[3] = $(this).find('#txtconsumeqty').val();
                        Itemmaster[4] = $(this).find('#tdItemID').html();
                        Itemmaster[5] = $(this).find('#txtconsumeremarks').val();
                        Itemmaster[6] = $(this).find('#tdIsExpirable').html();
                        Itemmaster[7] = $(this).find('#tdexpirydate').html();
                        Itemmaster[8] = $(this).find('#tdconid').html();

                        tempData.push(Itemmaster);
                    }
                }
            });

            return tempData;
        }


        function savealldata() {
            if (validation() == true) {

                var mydataadj = getcompletedataadj();
                if (mydataadj.length == 0) {
                    showerrormsg("Please Select Item To Save");
                    return;
                }
                $.ajax({
                    url: "Autoconusmestoredata.aspx/saveconsume",
                    data: JSON.stringify({ mydataadj: mydataadj }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            showmsg("Stock Consume Successfully..!");
                            $('#tblitemlist tr').slice(1).remove();
                            resetme();

                        }
                        else {
                            showerrormsg(result.d);
                        }

                    },
                    error: function (xhr, status) {
                        showerrormsg(xhr.responseText);
                    }
                });


            }
        }


        function viewbarcodedetail(ctrl) {
            var id = $(ctrl).closest('tr').find('#tdconid').html();


            $.blockUI();

            $.ajax({
                url: "AutoConusmeStoreData.aspx/getdetail",
                data: '{ID:"' + id + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Detail Found");
                        $('#Table1 tr').slice(1).remove();
                        $.unblockUI();
                      

                    }
                    else {
                        $('#Table1 tr').slice(1).remove();
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                          
                            var mydata = "<tr style='background-color:cyan;'>";

                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].BookingCentre + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].visitid + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].patient_id + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].pname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].age + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].gender + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].InvName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].LabConsumeType + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].EventtypeName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].EntryDate + '</td>';
                            
                            mydata += "</tr>";
                            $('#Table1').append(mydata);


                         

                        }
                        $find("<%=ModalPopupOnlineFilter.ClientID%>").show();
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

