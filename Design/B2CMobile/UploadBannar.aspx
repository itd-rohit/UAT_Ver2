<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="UploadBannar.aspx.cs"
    Inherits="Design_Master_UploadBannar" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top: -42px;">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                 <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
            </Scripts>
        </Ajax:ScriptManager>


        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Configure Banner</b>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Banner Details
                </div>
                <div class="POuter_Box_Inventory">
                    <table id="tbSelected" border="1" style="border-collapse: collapse; width: 100%;" class="exporttoexcel">
                        <thead>
                            <tr id="DiscountHeader" class="exporttoexcelheader">
                                <th style="width: 10%; text-align: Left">S.No</th>
                                <th style="width: 45%; text-align: left; display: none;">ShowOrder</th>
                                <th style="width:  30%; text-align: left">Banner</th>
                                <th style="width: 20%; text-align: left">Remove</th>
                                <th style="width: 10%; text-align: left">
                                    <input type="checkbox" id="chkal" onclick="chkall()" />
                                    Active</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <input id="Save" type="button" class="resetbutton" style="width: 120px" value="Save Ordering" />
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Upload Banner   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <span id="message" style="color: red"></span>
                        <input type="file" id="uploadfile" accept="image/*" onchange="getimage(this)" />

                        <input type="hidden" id="hdnSource3" value="" />
                        <input type="hidden" id="imgshow" value="" />
                    </div>
                    <div class="col-md-4">
                        <input type="button" value="Upload Banner " class="savebutton" onclick="savedata()" style="width: 150px" />
                    </div>
                </div>

            </div>
            <div id="myModal1" class="modal" style="display: none; position: fixed; z-index: 1; padding-top: 150px; left: 0; top: 50px; width: 100%; height: 100%; overflow: auto; background-color: rgb(0,0,0); background-color: rgba(0,0,0,0.4);">
                <!-- Modal content -->
                <div class="modal-content" style="background-color: #fefefe; margin: auto; padding: 20px; border: 1px solid #888; width: 50%;">
                    <span class="close" style="color: #aaaaaa; float: right; font-size: 28px; font-weight: bold;" onclick="close()">&times;</span>
                    <div>
                        <div style="max-height: 400px; overflow: auto;">
                            <div id="div2" style="border: 1px solid; padding: 30px">
                                <table id="Table1" cellspacing="0" border="0" style="border-collapse: collapse; width: 50%">
                                    <tr>
                                        <td style="border: none">
                                            <img alt="Not found" id="imgshowmodal" style="width: 200px; height: 100px" />
                                        </td>

                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            var modal = '';
            $(document).ready(function () {
                BindData();
                modal = document.getElementById("myModal1");
                $("#Save").click(function () {
                    saveBannerOrdering();
                });
            })
            function chkall() {
                if ($("#chkal").prop('checked')) {
                    $("#tbSelected :checkbox").prop('checked', 'checked');
                }
                else {
                    $("#tbSelected :checkbox").prop('checked', false);
                }

            }
            function getimage(obj) {
                //  $("#message").html('Banner image size : 1640 x 856 pixels <br/>');
                if (obj.files && obj.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {

                        var img = new Image();
                        img.src = e.target.result;
                        img.onload = function () {

                            document.getElementById('imgshow').value = e.target.result;
                            document.getElementById('hdnSource3').value = obj.value.substring((obj.value.lastIndexOf("\\")) + 1);
                        }
                    }
                    reader.readAsDataURL(obj.files[0]);
                }
            }
            function savedata() {
                if ($("#hdnSource3").val() == "") {
                    toast("Error", "Please select Banner image", '');
                    return;
                }
                //$("#message").html('Banner image size : 1640 x 856 pixels ');
                var ar = new Array();
                var obj = new Object();
                obj.Id = 0;
                obj.FileName = $("#hdnSource3").val();
                obj.Bannerimg = $("#imgshow").val();
                ar.push(obj);
                serverCall('UploadBannar.aspx/SaveData', { data: ar }, function (response) {
                    toast("Success", response, "");
                    BindData();
                    $("#hdnSource3").val('');
                    $("#imgshow").val('');
                    $("#uploadfile").val('');


                });
            }
            function chngcur() {
                document.body.style.cursor = 'pointer';
            }
            function chngcurmove() {
                document.body.style.cursor = 'move';
            }
            function deletetable(element) {
                var s = confirm("Are you sure want to delete banner");
                if (!s)
                    return;
                var id = $(element).closest("tr").find("td:eq(1)").text();
                serverCall('UploadBannar.aspx/DeleteImage', { ID: id }, function (response) {
                    toast("Success", response, "");
                    BindData();
                });
            }
            function saveBannerOrdering() {
                var InvOrder = "";
                $("#tbSelected tbody tr").each(function () {
                    var a = $(this).find(':checkbox').prop('checked') ? 1 : 0;
                    InvOrder += $(this).attr('id') + '#' + a + '|';
                });
                serverCall('UploadBannar.aspx/SaveBannerOrdering', { InvOrder: InvOrder }, function (response) {
                    if (response == '1') {
                        toast("Success", 'Order Saved SuccessFully', "");                       
                        BindData();
                    }
                });
            }
            function BindData() {
                $('#tbSelected tbody').html('');
                serverCall('UploadBannar.aspx/BindData', {}, function (response) {
                    if (response != '') {
                        var ItemData = jQuery.parseJSON(response);
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var $appendText = [];
                            $appendText.push('<tr id='); $appendText.push(ItemData[i].ID); $appendText.push('><td class="GridViewLabItemStyle" onmouseover="chngcurmove()" id="srno" style="border: solid 1px #66838c;">'); $appendText.push(parseInt(i + 1)); $appendText.push('</td>');//
                            $appendText.push('<td class="GridViewLabItemStyle"onmouseover="chngcurmove()" hidden>'); $appendText.push(ItemData[i].ID); $appendText.push('</td>');
                            $appendText.push('<td class="GridViewLabItemStyle" onmouseover="chngcurmove()" style="border: solid 1px #66838c;display:none;">'); $appendText.push(ItemData[i].ShowOrder); $appendText.push('</td>');
                            $appendText.push('<td class="GridViewLabItemStyle" onmouseover="chngcurmove()" style="border: solid 1px #66838c;"><img src="../Purchase/Image/view.GIF" onclick="showLogo(this)" style="courser:pointer" imagepath="'); $appendText.push(ItemData[i].Image); $appendText.push('" /></td>');
                            $appendText.push('<td class="GridViewLabItemStyle" onmouseover="chngcurmove()" style="border: solid 1px #66838c;"><img src="../Purchase/Image/Delete.gif" onclick="deletetable(this)" /></td>');
                            if (ItemData[i].IsActive == "1")
                                $appendText.push('<td class="GridViewLabItemStyle" onmouseover="chngcurmove()" style="border: solid 1px #66838c;"><input id="chk" type="checkbox" checked="checked" /></td>');
                            else
                                $appendText.push('<td class="GridViewLabItemStyle" onmouseover="chngcurmove()" style="border: solid 1px #66838c;"><input id="chk" type="checkbox"  /></td>');
                            $appendText.push("</tr>");

                            $appendText = $appendText.join("");
                            $('#tbSelected tbody').append($appendText);
                        }
                        $("#tbSelected").tableDnD
                      ({
                          onDragClass: "GridViewDragItemStyle",
                          onDragStart: function (table, row) {
                          }
                      });
                    }

                });
            }
            function showLogo(el) {
                $("#imgshowmodal").attr('src', $(el).attr('imagepath'));
                var modal = document.getElementById("myModal1");
                var span = document.getElementsByClassName("close");
                span.onclick = function () {
                    modal.style.display = "none";
                }
                // When the user clicks anywhere outside of the modal, close it
                window.onclick = function (event) {
                    if (event.target == modal) {
                        modal.style.display = "none";
                    }
                }
                modal.style.display = "block";
            }

        </script>
        <script>
            // Get the modal
            var modal = document.getElementById("myModal1");
            // Get the <span> element that closes the modal
            var span = document.getElementsByClassName("close")[0];
            // When the user clicks on <span> (x), close the modal
            span.onclick = function () {
                modal.style.display = "none";
            }
            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        </script>
    </form>
</body>
</html>


