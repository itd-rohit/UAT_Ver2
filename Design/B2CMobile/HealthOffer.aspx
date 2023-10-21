<%@ Page Title="" Language="C#" AutoEventWireup="true"
    CodeFile="HealthOffer.aspx.cs" Inherits="Design_PROApp_HealthOffer" %>

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
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Mobile App B2C Health Offer</b><br />
                <asp:Label ID="lblImageId" runat="server" Text="" CssClass="ItDoseLblError" Style="display: none"></asp:Label>
                <asp:HiddenField ID="HiddenField1" runat="server" />

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Mobile App B2C Health Offer
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Help Content
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Header Image   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:FileUpload ID="FileUpload1" accept="image/*" runat="server" />

                        </div>
                        <div class="col-md-6">
                            <asp:Label ID="lblImage" runat="server" Visible="false" CssClass="ItDoseLblError"></asp:Label>
                            <asp:Image ID="imgHeader" Visible="false" runat="server" Width="300px" Height="100px" />
                            <img id="imgHeader1" style="display: none; height: 100px; width: 200px" src="" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-6">
                            <asp:CheckBox ID="chkActive" runat="server" /><label for="chkActive">IsActive</label>
                            <asp:Label ID="lblid" runat="server"></asp:Label>
                        </div>
                    </div>

                    <div class="row" style="text-align: center">
                        <asp:Button ID="btnsave" class="savebutton" runat="server" Text="Save " Width="120" OnClick="btnsave_Click" />
                    </div>
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
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 110px;">Image</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 400px;">Active</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Date</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Edit</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <input id="Save" class="searchbutton" type="button" value="Save Ordering" />
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
                SearchHelpdata();
                $("#Save").click(function () {
                    saveHealthOfferOrdering();
                });
                $("#gvImage").tableDnD({
                    onDragClass: "GridViewDragItemStyle"
                });
            });
            function chngcur() {
                document.body.style.cursor = 'pointer';
            }
            function chngcurmove() {
                document.body.style.cursor = 'move';
            }
            function saveHealthOfferOrdering() {
                var HTOrder = "";
                var temp = "";
                $("#tb_grdLabSearch > tbody > tr").not(':first').each(function () {
                    temp = $(this).attr('id');
                    HTOrder += temp + '|';
                });
                serverCall('HealthOffer.aspx/saveHealthOfferOrdering', { HTOrder: HTOrder }, function (response) {
                    if (response != "") {
                        if (response == '1') {
                            Tostsuccess('Record updated SuccessFully');
                            SearchHelpdata();
                        }
                    }
                });
            }
            function SearchHelpdata() {
                var symbol = "";
                jQuery('#tb_grdLabSearch tbody').html('');
                serverCall('HealthOffer.aspx/ImageDataList', { Id: 0 }, function (response) {
                    if (response != "") {
                        var $responseData = JSON.parse(response);
                        if ($responseData != null) {
                            for (var i = 0; i < $responseData.length; i++) {
                                var $appendText = [];
                                $appendText.push('<tr class="GridViewItemStyle" id="'); $appendText.push($responseData[i].ID); $appendText.push('">');
                                $appendText.push('<td> '); $appendText.push(i + 1); $appendText.push('</td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push('<img src="../Purchase/Image/view.GIF" onclick="showLogo(this)" style="courser:pointer" imagepath="'); $appendText.push($responseData[i].Image); $appendText.push('"/></td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].IsActive); $appendText.push('</td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].Entrydate); $appendText.push('</td>');
                                $appendText.push('<td  style="font-weight:bold;">'); $appendText.push('<img src="../Purchase/Image/edit.png" style="cursor:pointer;" onclick="GetDataForEdit(this);" imagepath="'); $appendText.push($responseData[i].Image); $appendText.push('"/></td>');
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
            function clearform() {
                $("#<%=FileUpload1.ClientID%>").val("");
                $("#<%=lblid.ClientID %>").val("");
                document.getElementById('<%=chkActive.ClientID %>').checked = false;
            }
            function GetDataForEdit(el) {
                document.getElementById('<%=btnsave.ClientID %>').value = "Update";
             $("#<%=HiddenField1.ClientID %>").val($(el).closest('tr').attr('id'));
             $('#imgHeader1').attr('src', $(el).attr('imagepath'));
             $('#imgHeader1').show();
             var IsActive = $(el).closest('tr').find('td:eq(2)').text()
             if (IsActive == "Yes") {
                 document.getElementById('<%=chkActive.ClientID %>').checked = true;
             }
             else {
                 document.getElementById('<%=chkActive.ClientID %>').checked = false;
             }
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
