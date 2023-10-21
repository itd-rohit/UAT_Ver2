<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StoreItemAutoConsumeMaster.aspx.cs" Inherits="Design_Store_StoreItemAutoConsumeMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <style type="text/css">
        .selected {
            background-color:aqua !important;
           border:2px solid black;
        }

          </style>
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
                          <b>Store Item Auto Consume Master</b>  
                        </td>
                    </tr>
                    </table>
                </div>


              </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" ></div>

                <table width="100%">
                    <tr>
                        <td style="font-weight: 700">
                            Store Item :
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlstoreitem" runat="server" Width="600px" class="ddllocation chosen-select chosen-container" onchange="binddata()" />

                            <asp:TextBox ID="txtid" runat="server" style="display:none;" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>

         <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Auto Consume Detail</div>

                <table>
                    <tr>
                        <td>Lab Item Type :</td>
                        <td>
                            <asp:DropDownList ID="ddllabitemtype" runat="server" Width="120" onchange="getitemlist()">
                                <asp:ListItem Value="0">Select</asp:ListItem>
                                 <asp:ListItem Value="1">Investigation</asp:ListItem>
                                  <asp:ListItem Value="2">Observation</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                          Lab Item :</td>
                         
                      <td colspan="5">

                          <asp:DropDownList ID="ddllabitem" runat="server" Width="325">
                              <asp:ListItem Value="0">Select</asp:ListItem>
                          </asp:DropDownList>
                      </td>
                        
                    </tr>
                    <tr>
                        <td>Consumption Type :</td>
                        <td>
                            <asp:DropDownList ID="ddlconsumetype" runat="server" Width="120"></asp:DropDownList>
                        </td>
                        <td>
                            Event Type :</td>
                        
                      <td>
                            <asp:DropDownList ID="ddleventtype" runat="server" Width="180"></asp:DropDownList>
                        </td>
                        <td>
                           Store Item Qty :</td>

                        <td>
                            <asp:TextBox ID="txtstoreitemqty" runat="server" Width="80px" />
                             <cc1:filteredtextboxextender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtstoreitemqty">
                                </cc1:filteredtextboxextender>
                        </td>
                        <td>
                            Inv Max Qty :
                        </td>
                        <td>
                             <asp:TextBox ID="txtinvmaxqty" runat="server" Width="80px" />
                             <cc1:filteredtextboxextender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtinvmaxqty">
                                </cc1:filteredtextboxextender>
                        </td>
                        
                    </tr>
                    <tr>
                        <td colspan="8" style="text-align: center">
                            <input type="button" value="Save" class="savebutton" onclick="saveme()" id="btnsave" />
                              <input type="button" value="Update" class="savebutton" onclick="updateme()" style="display:none;" id="btnupdate"/>
                        </td>
                        
                    </tr>
                </table>
              </div>
             </div>


            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader" >Saved Detail</div>
                   <div style="width: 1295px; height: 200px; overflow: auto;">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle">Store Item</td>
                            <td class="GridViewHeaderStyle">Lab Item Type</td>

                            <td class="GridViewHeaderStyle">Lab Item</td>
                            
                            <td class="GridViewHeaderStyle">Consumption Type</td>
                            <td class="GridViewHeaderStyle">Event Type</td>
                            <td class="GridViewHeaderStyle">Store Item Qty</td>
                            <td class="GridViewHeaderStyle">Inv Max Qty</td>
                            <td class="GridViewHeaderStyle">Entry Date</td>
                            <td class="GridViewHeaderStyle">Entry By</td>
                            <td class="GridViewHeaderStyle" style="width: 20px;">Edit</td>
                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            </tr>
                        </table>
                       </div>

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

            binddata();

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

        function getitemlist() {
            $.blockUI();
            if ($('#<%=ddllabitemtype.ClientID%>').val() == "0") {
                $("#<%=ddllabitem.ClientID%> option").remove();
                $("#<%=ddllabitem.ClientID%>").append($("<option></option>").val("0").html("Select"));
                $('#<%=ddleventtype.ClientID%>').prop('selectedIndex', 0);
                $('#<%=ddleventtype.ClientID%>').attr("disabled", false);
                $.unblockUI();
                return;
            }
            if ($('#<%=ddllabitemtype.ClientID%>').val() == "1") {
                $("#<%=ddllabitem.ClientID%> option").remove();
                $("#<%=ddllabitem.ClientID%>").append($("<option></option>").val("0").html("Select"));
                $('#<%=ddleventtype.ClientID%>').prop('selectedIndex', 0);
                $('#<%=ddleventtype.ClientID%>').attr("disabled", false);
            }
            if ($('#<%=ddllabitemtype.ClientID%>').val() == "2") {
                $("#<%=ddllabitem.ClientID%> option").remove();
                $("#<%=ddllabitem.ClientID%>").append($("<option></option>").val("0").html("Select"));
                $('#<%=ddleventtype.ClientID%>').attr("disabled", true);
                $('#<%=ddleventtype.ClientID%>').val("8");
            }

            $.ajax({
                url: "StoreItemAutoConsumeMaster.aspx/bindalldata",
                data: '{ type:"' + $('#<%=ddllabitemtype.ClientID%>').val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var idata = $.parseJSON(result.d);
                    if (idata.length == 0) {
                        showerrormsg("No Lab Item Found");
                        $.unblockUI();
                        return;
                    }

                    for (var i = 0; i <= idata.length - 1; i++) {
                        $("#<%=ddllabitem.ClientID%>").append($("<option></option>").val(idata[i].id).html(idata[i].name));
                    }

                    $.unblockUI();
                },

                error: function (xhr, status) {
                    $.unblockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
           
        }

       
    </script>

    <script type="text/javascript">

        function validation() {
            if ($('#<%=ddlstoreitem.ClientID%>').val() == "0") {
                showerrormsg("Please Select Store Item");
                return false;
            }
            if ($('#<%=ddllabitemtype.ClientID%>').val() == "0") {
                showerrormsg("Please Select Lab Item Type");
                $('#<%=ddllabitemtype.ClientID%>').focus(); 
                return false;
            }
            if ($('#<%=ddllabitem.ClientID%>').val() == "0") {
                showerrormsg("Please Select Lab Item");
                $('#<%=ddllabitem.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlconsumetype.ClientID%>').val() == "0") {
                showerrormsg("Please Select Consumption Type");
                $('#<%=ddlconsumetype.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddleventtype.ClientID%>').val() == "0") {
                showerrormsg("Please Select Event Type");
                $('#<%=ddleventtype.ClientID%>').focus();
                return false;
            }
            var storeitemqty = ($('#<%=txtstoreitemqty.ClientID%>').val() == "") ? 0 : $('#<%=txtstoreitemqty.ClientID%>').val();

            if (storeitemqty == "0") {
                showerrormsg("Please Enter Store Item Qty");
                $('#<%=txtstoreitemqty.ClientID%>').focus();
                return false;
            }
           

            var storeinvmaxqty = ($('#<%=txtinvmaxqty.ClientID%>').val() == "") ? 0 : $('#<%=txtinvmaxqty.ClientID%>').val();

            if (storeinvmaxqty == "0" && $('#<%=ddlconsumetype.ClientID%>').val() == "3") {
                showerrormsg("Please Enter Inv Max Qty");
                $('#<%=txtinvmaxqty.ClientID%>').focus();
                return false;
            }
            return true;
        }

        function saveme() {
            if (validation() == false) {
                return;
            }


            var storeitemqty = ($('#<%=txtstoreitemqty.ClientID%>').val() == "") ? 0 : $('#<%=txtstoreitemqty.ClientID%>').val();
            var storeinvmaxqty = ($('#<%=txtinvmaxqty.ClientID%>').val() == "") ? 0 : $('#<%=txtinvmaxqty.ClientID%>').val();
            $.ajax({
                url: "StoreItemAutoConsumeMaster.aspx/savealldata",
                data: '{storeitemid:"' + $('#<%=ddlstoreitem.ClientID%>').val() + '",storeitemname:"' + $('#<%=ddlstoreitem.ClientID%> option:selected').text() + '",labitemtype:"' + $('#<%=ddllabitemtype.ClientID%>').val() + '",labitemtypename:"' + $('#<%=ddllabitemtype.ClientID%> option:selected').text() + '",labitemid:"' + $('#<%=ddllabitem.ClientID%>').val() + '",labitemname:"' + $('#<%=ddllabitem.ClientID%> option:selected').text() + '",consumetype:"' + $('#<%=ddlconsumetype.ClientID%>').val() + '",consumetypename:"' + $('#<%=ddlconsumetype.ClientID%> option:selected').text() + '",eventtype:"' + $('#<%=ddleventtype.ClientID%>').val() + '",eventtypename:"' + $('#<%=ddleventtype.ClientID%> option:selected').text() + '",storeitemqty:"' + storeitemqty + '",storeinvmaxqty:"' + storeinvmaxqty + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    if (result.d == "1") {
                        showmsg("Record Saved Sucessfully");
                        clearform();
                        binddata();
                    }
                    else {
                        showerrormsg(result.d);
                    }

                },

                error: function (xhr, status) {
                    $.unblockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


        }

        function clearform() {
            $('#btnsave').show();
            $('#btnupdate').hide();
            $('#<%=ddlstoreitem.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddlstoreitem.ClientID%>').trigger('chosen:updated');
            $('#<%=ddllabitemtype.ClientID%>').prop('selectedIndex', 0);
            getitemlist();
            $('#<%=ddlconsumetype.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddleventtype.ClientID%>').prop('selectedIndex', 0);
            $('#<%=txtstoreitemqty.ClientID%>').val('0');
            $('#<%=txtinvmaxqty.ClientID%>').val('0');
            $('#<%=txtid.ClientID%>').val('');
        }

        function binddata() {

            $.blockUI();
            $('#tblitemlist tr').slice(1).remove();
            $.ajax({
                url: "StoreItemAutoConsumeMaster.aspx/SearchData",
                data: '{storeitemid:"' + $('#<%=ddlstoreitem.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        $.unblockUI();
                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = '<tr style="background-color:#c7ffc0;height:25px" id="' + ItemData[i].id + '">';
                          
                            mydata += '<td class="GridViewLabItemStyle" >' +parseInt(i+1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ItemName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].LabitemTypeName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].LabItemName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].ConsumetypeName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].EventtypeName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdStoreItemQty">' + ItemData[i].StoreItemQty + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="tdInvMaxQty">' + ItemData[i].InvMaxQty + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].EntryByName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].EntryDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" ><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="showontop(this)"/></td>';
                            mydata += '<td class="GridViewLabItemStyle" ><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';

                            mydata += '<td class="GridViewLabItemStyle" style="display:none;" id="tditemid">' + ItemData[i].Itemid + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;" id="tdlabitemtype">' + ItemData[i].LabitemTypeID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;" id="tdlabitemid">' + ItemData[i].LabItemId + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;" id="tdconsumetypeid">' + ItemData[i].ConsumetypeID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="display:none;" id="tdeventtypeid">' + ItemData[i].EventtypeID + '</td>';

                            mydata += "</tr>";
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


        function deleterow(ctrl) {
            if (confirm("Do You Want To Delete?")) {
                $.blockUI();
                $.ajax({
                    url: "StoreItemAutoConsumeMaster.aspx/DeleteData",
                    data: '{id:"' + $(ctrl).closest('tr').attr("id") + '"}',
                    type: "POST",
                    timeout: 120000,

                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            showerrormsg("Data Deleted.!");
                            $.unblockUI();
                            binddata();
                        }
                        else {
                            $.unblockUI();
                            showerrormsg(result.d);
                        }
                    },
                    error: function (xhr, status) {
                        $.unblockUI();
                    }
                });
            }
        
        }



        function showontop(ctrl) {
            $('#btnsave').hide();
            $('#btnupdate').show();
            $("#tblitemlist tr").removeClass("selected");

            $(ctrl).closest('tr').addClass("selected");
            $('#<%=txtid.ClientID%>').val($(ctrl).closest('tr').attr("id"));

            $('#<%=ddlstoreitem.ClientID%>').val($(ctrl).closest('tr').find("#tditemid").html());
            $('#<%=ddlstoreitem.ClientID%>').trigger('chosen:updated');
            $('#<%=ddllabitemtype.ClientID%>').val($(ctrl).closest('tr').find("#tdlabitemtype").html());
            getitemlist();
            $('#<%=ddllabitem.ClientID%>').val($(ctrl).closest('tr').find("#tdlabitemid").html());
            $('#<%=ddlconsumetype.ClientID%>').val($(ctrl).closest('tr').find("#tdconsumetypeid").html());
            $('#<%=ddleventtype.ClientID%>').val($(ctrl).closest('tr').find("#tdeventtypeid").html());
            $('#<%=txtstoreitemqty.ClientID%>').val($(ctrl).closest('tr').find("#tdStoreItemQty").html());
            $('#<%=txtinvmaxqty.ClientID%>').val($(ctrl).closest('tr').find("#tdInvMaxQty").html());

           
        }


        function updateme() {
            if (validation() == false) {
                return;
            }


            var storeitemqty = ($('#<%=txtstoreitemqty.ClientID%>').val() == "") ? 0 : $('#<%=txtstoreitemqty.ClientID%>').val();
            var storeinvmaxqty = ($('#<%=txtinvmaxqty.ClientID%>').val() == "") ? 0 : $('#<%=txtinvmaxqty.ClientID%>').val();
            $.ajax({
                url: "StoreItemAutoConsumeMaster.aspx/updatealldata",
                data: '{storeitemid:"' + $('#<%=ddlstoreitem.ClientID%>').val() + '",storeitemname:"' + $('#<%=ddlstoreitem.ClientID%> option:selected').text() + '",labitemtype:"' + $('#<%=ddllabitemtype.ClientID%>').val() + '",labitemtypename:"' + $('#<%=ddllabitemtype.ClientID%> option:selected').text() + '",labitemid:"' + $('#<%=ddllabitem.ClientID%>').val() + '",labitemname:"' + $('#<%=ddllabitem.ClientID%> option:selected').text() + '",consumetype:"' + $('#<%=ddlconsumetype.ClientID%>').val() + '",consumetypename:"' + $('#<%=ddlconsumetype.ClientID%> option:selected').text() + '",eventtype:"' + $('#<%=ddleventtype.ClientID%>').val() + '",eventtypename:"' + $('#<%=ddleventtype.ClientID%> option:selected').text() + '",storeitemqty:"' + storeitemqty + '",storeinvmaxqty:"' + storeinvmaxqty + '",id:"'+$('#<%=txtid.ClientID%>').val()+'"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    if (result.d == "1") {
                        showmsg("Record Updated Sucessfully");
                        clearform();
                        binddata();
                    }
                    else {
                        showerrormsg(result.d);
                    }

                },

                error: function (xhr, status) {
                    $.unblockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


        }
    </script>
</asp:Content>

