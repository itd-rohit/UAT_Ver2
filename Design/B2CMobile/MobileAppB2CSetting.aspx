<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MobileAppB2CSetting.aspx.cs" Inherits="Design_B2CMobile_MobileAppB2CSetting" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top:-42px;">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js"/>

            </Scripts>
        </Ajax:ScriptManager>

        <div id="Pbody_box_inventory" >
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Mobile App B2C Setting</b>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Mobile App B2C Setting</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Login Logo   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <input type="file" id="uploadfile" accept="image/*" onchange="getimage(this)" />
                        <a href="#" onclick="showLogo()">View Logo</a>
                        <input type="hidden" id="hdnSource3" value="" />
                        <input type="hidden" id="imgshow" value="" />
                        <br />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Theme Color  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="color" id="headcolor" name="head" class="cp" style="width: 196px"
                            value="#e66465" />
                    </div>
                    <div class="col-md-4">
                        <input type="checkbox" id="poweredby" value="1" style="margin-left: -2px;" /><label for="poweredby">Show Powered By </label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <span id="message" style="color: red"></span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Welcome Content   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <input type="text" id="txtWelcomeContent" style="" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Login Content 1   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <input type="text" id="txtLoginContent1" style="" />
                    </div>
                    <%--<div class="col-md-3" style="display: none;">
                    <label class="pull-left">Login Content 2 </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display: none;">
                    <input type="text" id="txtLoginContent2" style="width: 200px; display: none;" />
                </div>--%>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">LabReport Path </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <input type="text" id="txtLabReportPath" /><br />
                        <span style="color: blue; font-size: 11px;"><em>Ex : http://{IP}:{Port}/HostName/Design/Lab/LabReportNew.aspx?PHead=1&amp;TestID=</em></span>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Helpline No. 24x7 </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtHelpline24x7" maxlength="10" style="width: 200px" />
                    </div>
                </div>
                <div class="row" style="text-align: center;">
                    <input type="button" value="Save " class="savebutton" onclick="savedata()" style="width: 150px" /></td>
                </div>
            </div>
        </div>
        <input type="hidden" id="IDHidden" value="0" />
        <div id="myModal1" class="modal" style="display: none; position: fixed; zindex: 1; padding-top: 150px; left: 0; top: 50px; width: 100%; height: 100%; overflow: auto; background-color: rgb(0,0,0); background-color: rgba(0,0,0,0.4);">
            <!-- Modal content -->
            <div class="modal-content" style="background-color: #fefefe; margin: auto; padding: 20px; border: 1px solid #888; width: 50%;">
                <span class="close" style="color: #aaaaaa; float: right; font-size: 28px; font-weight: bold;">&times;</span>
                <div>
                    <div style="max-height: 400px; overflow: auto;">
                        <div id="div2" style="border: 1px solid; padding: 30px">
                            <table id="Table1" cellspacing="0" border="0" style="border-collapse: collapse; width: 50%">
                                <tr>
                                    <td style="border: none">
                                        <img alt="Not found" id="imgshowmodal" />
                                    </td>

                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(document).ready(function () {
                BindData();
            })
            function getimage(obj) {
                // $("#message").html('Login Logo size : 1640 x 856 pixels');
                if (obj.files && obj.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var img = new Image();
                        img.src = e.target.result;
                        img.onload = function () {
                            // if ((this.height >= 840 && this.height <= 860) && (this.width >= 1600 && this.width <= 1650)) {
                            document.getElementById('imgshow').value = e.target.result;
                            document.getElementById('hdnSource3').value = obj.value.substring((obj.value.lastIndexOf("\\")) + 1);
                            $("#imgshowmodal").attr('src', e.target.result);
                        }
                    }
                    reader.readAsDataURL(obj.files[0]);
                }
            }
            function savedata() {
                var type = '0';
                if ($('#poweredby').prop('checked')) {
                    type = 1;
                }
                var ar = new Array();
                var obj = new Object();
                obj.PoweredBy = type;
                obj.ThemeColor = $("#headcolor").val();
                obj.Appid = $('#IDHidden').val();
                obj.FileName = $("#hdnSource3").val();
                obj.LoginLogo = $("#imgshow").val();
                obj.LoginContent1 = $("#txtLoginContent1").val();
                obj.LoginContent2 = $("#txtLoginContent2").val();
                obj.LabReportPath = $("#txtLabReportPath").val();
                obj.WelcomeContent = $("#txtWelcomeContent").val();
                obj.Helpline24x7 = $("#txtHelpline24x7").val();
                ar.push(obj);
                serverCall('MobileAppB2CSetting.aspx/SaveData', { data: ar }, function (response) {
                    BindData();
                    toast("Success", response, "");
                });

            }
            function BindData() {
                $('#tbSelected tbody').html('');
                serverCall('MobileAppB2CSetting.aspx/BindData', {}, function (response) {
                    if (response != "") {
                        var ItemData = jQuery.parseJSON(response);
                        $('#IDHidden').val(ItemData[0].ID);
                        $("#headcolor").val(ItemData[0].Color);
                        $("#txtLoginContent1").val(ItemData[0].WelcomeText);
                        $("#txtLoginContent2").val(ItemData[0].HeaderTest);
                        $("#txtLabReportPath").val(ItemData[0].LabReportPath);
                        $("#txtWelcomeContent").val(ItemData[0].WelcomeContent);
                        if (ItemData[0].IsShowPoweredBy == "Yes")
                            $("#poweredby").attr("checked", true);
                        $("#LoginLogo").text();
                        $("#ThemeColor").text(ItemData[0].Color);
                        $("#ThemeColor").css("background-color", ItemData[0].Color)
                        $("#ShowPoweredBy").text(ItemData[0].IsShowPoweredBy);
                        $("#LoginContent1").text(ItemData[0].WelcomeText);
                        $("#LoginContent2").text(ItemData[0].HeaderTest);
                        $("#LabReportPath").text(ItemData[0].LabReportPath);
                        $("#txtHelpline24x7").val(ItemData[0].HelpLineNo24x7);
                        $("#imgshowmodal").attr('src', ItemData[0].Logo);
                    }

                });

            }
            function showLogo() {
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
