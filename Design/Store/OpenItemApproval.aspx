<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OpenItemApproval.aspx.cs" Inherits="Design_Store_OpenItemApproval" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <title></title>
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript">
        var approvaltypemaker = '<%=approvaltypemaker %>';
        var approvaltypechecker = '<%=approvaltypechecker %>';
        var approvaltypeapproval = '<%=approvaltypeapproval %>';
        var itemid = '<%=itemgorupid %>';

        $(function () {
            bindata();

        });

        function bindata() {

            $('#tblitemlist tr').slice(1).remove();

            serverCall('OpenItemApproval.aspx/BindSavedManufacture', { itemid: itemid }, function (response) {
                ItemData = jQuery.parseJSON(response);


                for (var i = 0; i <= ItemData.length - 1; i++) {
                    var $mydata = [];
                    $mydata.push("<tr style='background-color:");$mydata.push(ItemData[i].rowcolor); $mydata.push(";'>");
                    $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail3" >');
                    if (ItemData[i].ApprovalStatus == "0" && approvaltypechecker == "1") {
                        $mydata.push('<img src="../../App_Images/Checked.png" style="cursor:pointer;height:30px;width:50px" onclick="checkme(this)" />');
                    }
                    $mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail4" >');
                    if (ItemData[i].ApprovalStatus == "1" && approvaltypeapproval == "1") {
                        $mydata.push('<img src="../../App_Images/Approved.jpg" style="cursor:pointer;height:30px;width:50px" onclick="approveme(this)" />');
                    }
                    $mydata.push('</td>');
                    $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdmanuname">');$mydata.push(ItemData[i].typename); $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdmanuname">');$mydata.push(ItemData[i].ManufactureName); $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdcatlog">');$mydata.push(ItemData[i].CatalogNo); $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdmachinename">');$mydata.push(ItemData[i].MachineName); $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdpunitname">');$mydata.push(ItemData[i].MajorUnitName); $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdConverter">');$mydata.push(precise_round(ItemData[i].Converter, 5)); $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdpacksize">');$mydata.push(ItemData[i].PackSize); $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdcounitname">' );$mydata.push(ItemData[i].MinorUnitName); $mydata.push('</td>');
                    $mydata.push('<td  align="left" id="tdIssueMultiplier">');$mydata.push(ItemData[i].IssueMultiplier); $mydata.push('</td>');

                    $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail31" >');

                    if (ItemData[i].barcodeoption == "2" && ItemData[i].BarcodeGenrationOption == "1") {
                        $mydata.push('<img src="../../App_Images/folder.gif" style="cursor:pointer;" onclick="openbarcodemap(this)" />');
                    }
                    $mydata.push('</td>');

                    $mydata.push('<td  id="tditemid"   style="display:none;">');$mydata.push( ItemData[i].ItemId); $mydata.push('</td>');
                    $mydata.push('</tr>');
                    $mydata = $mydata.join("");
                    $('#tblitemlist').append($mydata);
                }
                
                });

            

            }

        function openbarcodemap(ctrl) {
            var groupid = $(ctrl).closest('tr').find("#tditemid").html();

            openmypopup("ItemBarcodeMapping.aspx?itemid=" + groupid);
        }


        function openmypopup(href) {
            var width = '700px';

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

        

         function checkme(ctrl) {

             var id = $(ctrl).closest("tr").find('#tditemid').html();
             serverCall('StoreItemMaster.aspx/SetStatus', { itemId: id, Status: 1 }, function (response) {
                 ItemData = response;
                 toast("Success", "Item checked Sucessfully");
                 bindata();
             });           
         }
        function approveme(ctrl) {
            var id = $(ctrl).closest("tr").find('#tditemid').html();
            serverCall('StoreItemMaster.aspx/SetStatus', { itemId: id, Status: 2 }, function (response) {
                ItemData = response;
                toast("Success", "Item Approved Sucessfully");
                bindata();
            });            
        }

        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
    </script>
</head>
<body>

    <form id="form1" runat="server">
        
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-10 ">
                    </div>

                    <div class="col-md-2" style="width: 25px;height: 20px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;"></div>
                    <div class="col-md-2">Created</div>
                    <div class="col-md-2" style="width: 25px;height: 20px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;"></div>
                    <div class="col-md-2">Checked</div>
                    <div class="col-md-2" style="width: 25px;height: 20px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;"></div>
                    <div class="col-md-2">Approved</div>
                </div>
                <div class="row">
                    <div class="col-md-24 ">
                        <div style="overflow: auto; height: 200px;">
                            <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                                <tr id="triteheader">

                                    <td class="GridViewHeaderStyle" style="width: 30px;">Check</td>
                                    <td class="GridViewHeaderStyle" style="width: 30px;">Approve</td>

                                    <td class="GridViewHeaderStyle">Item Name</td>
                                    <td class="GridViewHeaderStyle">Manufacture Company</td>
                                    <td class="GridViewHeaderStyle">Catalog No.</td>
                                    <td class="GridViewHeaderStyle">Machine Name</td>
                                    <td class="GridViewHeaderStyle">Purchased Unit</td>
                                    <td class="GridViewHeaderStyle">Converter</td>
                                    <td class="GridViewHeaderStyle">Pack Size</td>
                                    <td class="GridViewHeaderStyle">Consumption Unit</td>
                                    <td class="GridViewHeaderStyle">Issue Multiplier</td>
                                    <td class="GridViewHeaderStyle" style="width: 30px;" title="Map Barcode With Item">Barcode</td>

                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
