<%@ Page Title="" Language="C#" AutoEventWireup="true"
    CodeFile="HealthTips.aspx.cs" Inherits="Design_PROApp_HealthTips" %>

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
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align:center">
                <b>Mobile App B2C Health Tips</b>
                <asp:Label ID="lblImageId" runat="server" Visible="false" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Health Tips
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Content Header  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txtheader" runat="server" Width="300px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Content Text   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">
                        <asp:TextBox ID="txttext" onkeydown="return (event.keyCode!=13);" runat="server" Width="500px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Header Image  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-9">

                        <input type="file" id="uploadfile" accept="image/*" onchange="getimage(this)" />
                        <input type="hidden" id="hdnSource3" value="" />
                        <input type="hidden" id="imgshow" value="" />
                    </div>
                    <div class="col-md-9">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
                            <asp:Label ID="lblImage" runat="server" Visible="false" CssClass="ItDoseLblError"></asp:Label>

                        <img id="imgid" style="width: 300px; height: 100px; display: none" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-9">
                        <asp:CheckBox ID="chkActive" runat="server" />
                        <label for="chkActive">IsActive</label>
                        <asp:Label ID="lblid" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input id="Button1" type="button" onclick="savedata()" class="savebutton" style="width: 120px" value="Save " />
                </div>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Search Result</div>
                <div id="row" style="text-align: center">
                    <div class="col-md-24">
                        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
                            style="width: 99%; border-collapse: collapse; cursor: move;">
                            <thead>
                                <tr id="Header" class="nodrop">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">S.No</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 110px;" align="left">Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 400px;">Content</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">TipsImage</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Active</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Entry Date</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="Outer_Box_Inventory" style="width: 99.6%; text-align: center;">
                <input type="hidden" id="hiddenId" value="0" />
                <input id="Save" type="button" class="searchbutton" value="Save Ordering" />
            </div>
        </div>
        <div id="myModal1" class="modal" style="display: none; position: fixed; zindex: 1; padding-top: 150px; left: 0; top: 50px; width: 100%; height: 100%; overflow: auto; background-color: rgb(0,0,0); background-color: rgba(0,0,0,0.4);">
            <!-- Modal content -->
            <div class="modal-content" style="background-color: #fefefe; margin: auto; padding: 20px; border: 1px solid #888; width: 24%;">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="close" style="color: #aaaaaa; float: right; font-size: 28px; font-weight: bold;" onclick="close()">&times;</span>
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
        
        <script type="text/javascript">
            var modal = '';
            $(document).ready(function () {
                ImageData();
                $("#Save").click(function () {
                    saveHealthOrdering();
                });
            });
            function getimage(obj) {
                if (obj.files && obj.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('imgshow').value = e.target.result;
                        document.getElementById('hdnSource3').value = obj.value.substring((obj.value.lastIndexOf("\\")) + 1);
                    }
                    reader.readAsDataURL(obj.files[0]);
                }
            }
            function ImageData() {
                var symbol = "";
                jQuery('#tb_grdLabSearch tbody').html('');
                serverCall('HealthTips.aspx/ImageData', { Id: 0 }, function (response) {
                    if (response != "") {
                        var $responseData = JSON.parse(response);
                        if ($responseData != null) {
                            for (var i = 0; i < $responseData.length; i++) {
                                var $appendText = [];
                                $appendText.push('<tr class="GridViewItemStyle" id="'); $appendText.push($responseData[i].ID); $appendText.push('">');
                                $appendText.push('<td> '); $appendText.push(i + 1); $appendText.push('</td>');
                                $appendText.push('<td>'); $appendText.push($responseData[i].Name); $appendText.push('</td>');
                                $appendText.push('<td >'); $appendText.push($responseData[i].TipsContent); $appendText.push('</td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push('<img src="../Purchase/Image/view.GIF" onclick="showLogo(this)" style="courser:pointer" imagepath="'); $appendText.push($responseData[i].TipsImage); $appendText.push('"/></td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].IsActive); $appendText.push('</td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].Entrydate); $appendText.push('</td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push('<img src="../Purchase/Image/edit.png" style="cursor:pointer;" onclick="Editdata(this);">'); $appendText.push('</td>');
                                $appendText.push("</tr>");
                                $appendText = $appendText.join("");
                                jQuery('#tb_grdLabSearch tbody').append($appendText);
                            }
                            $("#tb_grdLabSearch").tableDnD({
                                onDragClass: "GridViewDragItemStyle"
                            });
                        }
                    }
                });
            };
            function saveHealthOrdering() {
                var HTOrder = "";
                var temp = "";
                $("#tb_grdLabSearch > tbody > tr").not(':first').each(function () {
                    temp = $(this).attr("id");
                    HTOrder += temp + '|';
                });
                serverCall('HealthTips.aspx/saveHealthOrdering', { HTOrder: HTOrder }, function (response) {
                    if (response != "") {
                        if (response == '1') {
                            toast("Success", "Record Saved SuccessFully", '');
                            ImageData();
                        }
                    }
                    
                });
            }
            function savedata() {
                if ($("#hdnSource3").val() == "") {                   
                    toast("Error", "Please select image", '');
                    return;
                }
                //$.blockUI();
                var ar = new Array();
                var obj = new Object();
                obj.Id = $("#hiddenId").val();
                obj.FileName = $("#hdnSource3").val();
                obj.Image = $("#imgshow").val();
                obj.HeaderText = $("#<%=txtheader.ClientID %>").val();
                obj.Content = $("#<%=txttext.ClientID %>").val();
                obj.IsActive = $("#<%=chkActive.ClientID %>").prop('checked') ? 1 : 0;
                ar.push(obj);
                serverCall('HealthTips.aspx/SaveData', {data: ar  }, function (response) {
                    if (response != "") {
                        toast("Success", response, '');
                        ImageData()
                        $("#hdnSource3").val('');
                        $("#imgshow").val('');
                        $("#uploadfile").val('');
                    }
                });
            }
            function Editdata(id) {
                $("#imgid").hide();
                serverCall('HealthTips.aspx/ImageData', {Id:$(id).closest('tr').attr('id')  }, function (response) {
                    if (response != "") {
                        PatientData = JSON.parse(response);
                        $("#hiddenId").val(PatientData[0].ID);
                        $("#<%=txtheader.ClientID %>").val(PatientData[0].Name);
                        $("#<%=txttext.ClientID %>").val(PatientData[0].TipsContent);
                        if (PatientData[0].IsActive == "Yes")
                            $("#poweredby").attr("checked", true);
                        $("#<%=chkActive.ClientID %>").prop('checked', true);
                        $("#imgid").attr('src', PatientData[0].TipsImage);
                        $("#hdnSource3").val(PatientData[0].TipsImage);
                        $("#imgid").show();
                    }
                });

        };
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
