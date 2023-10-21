<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PrePrintedBarcode.aspx.cs" Inherits="Design_Lab_PrePrintedBarcode" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Print Barcode</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div id="div_printBarcode">
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">


                <table>

                    <tr>

                        <td style="width: 200px">Suffix :
               <input id="txtsuffix" style="width: 70px" readonly="readonly" type="text" />
                        </td>
                        <td style="width: 200px">Last No : 
                <input id="txtLastNo" readonly="readonly" style="width: 100px" type="text" />

                        </td>
                        <td style="width: 300px;">No of Barcode : 
               <input id="txtnoofbarcode" style="width: 100px" type="text" />
                        </td>
                        <td style="width: 550px;">Duplicate Copy
                            <asp:TextBox ID="txtDuplicateCopy" Text="1" runat="server" Style="width: 30px;" />
                            <asp:DropDownList ID="ddlSize" runat="server">
                                <asp:ListItem Value="1" Text="4x1"></asp:ListItem>
                                <asp:ListItem Value="2" Text="2x1"></asp:ListItem>

                            </asp:DropDownList>
                            <asp:DropDownList ID="ddlColor" runat="server">
                                <asp:ListItem Value="Red" Text="Red"></asp:ListItem>
                                <asp:ListItem Value="Green" Text="Green"></asp:ListItem>
                                <asp:ListItem Value="Orange" Text="Orange"></asp:ListItem>
                                <asp:ListItem Value="Blue" Text="Blue"></asp:ListItem>
                                <asp:ListItem Value="Purple" Text="Purple"></asp:ListItem>
                                <asp:ListItem Value="Gray" Text="Gray"></asp:ListItem>

                            </asp:DropDownList>
                            <input type="button" class="submit" value="Print Barcode" style="margin-left: 15px;" onclick="SaveBarcode();" name="submit" />
                            <input type="submit" id="btnbarcode" value="New Series" onclick="NewSeriesBarcode();" name="submit" />

                        </td>
                    </tr>
                    <tr style="display: none">
                        <td colspan="4">
                            <input type="text" id="txtprefix1" />
                            <input type="text" id="txtprefix2" />
                            <input type="text" id="txtprefix3" />
                        </td>
                    </tr>

                </table>


            </div>



           
        </div>
    </div>
    <script type="text/javascript">

        jQuery.fn.ForceNumericOnly =
function () {
    return this.each(function () {
        jQuery(this).keydown(function (e) {
            var key = e.charCode || e.keyCode || 0;
            // allow backspace, tab, delete, enter, arrows, numbers and keypad numbers ONLY
            // home, end, period, and numpad decimal
            return (
                key == 8 ||
                key == 9 ||
                key == 13 ||
                key == 46 ||
                key == 110 ||
                key == 190 ||
                (key >= 35 && key <= 40) ||
                (key >= 48 && key <= 57) ||
                (key >= 96 && key <= 105));
        });
    });
};
        $(document).ready(function () {
            jQuery("#txtLastNo").ForceNumericOnly();
            jQuery("#txtnoofbarcode").ForceNumericOnly();
            getBarcode();
            jQuery("#txtsuffix").css({ 'background-color': '#b4b4b4' });
            jQuery("#txtLastNo").css({ 'background-color': '#b4b4b4' });

        });

        function SaveBarcode() {
            var MaxID = $("#txtLastNo").val();
            var DuplicateCopy = $('[id$=txtDuplicateCopy]').val().trim();
            var Size = $('[id$=ddlSize]').val();
            var Color = $('[id$=ddlColor]').val();


            var NoofBarcode = $("#txtnoofbarcode").val();
            if (NoofBarcode == "" || MaxID == "") {
                alert("Please enter no of barcode");
                return;
            }


            var balbarcode = 100000 - parseInt(MaxID);
            var bal = parseInt(MaxID) + parseInt(NoofBarcode);
            if (parseInt(bal) > 100000) {
                alert("Please first use " + balbarcode + " Barcode for next series..");
                return;
            }


            //window.open('PrintBarcodeData.aspx?Suffix=' + $("#txtsuffix").val() + '&LastNo=' + MaxID + '&NoOfBarcode=' + NoofBarcode + '&suffix1=' + $("#txtprefix1").val() + '&suffix2=' + $("#txtprefix2").val() + '&suffix3=' + $("#txtprefix3").val() + '&DuplicateCopy=' + DuplicateCopy + '&Size=' + Size + '&Color=' + Color + '');
 window.open('http://report.atulaya.com/Atulaya/Design/Lab/PrintBarcodeData.aspx?Suffix=' + $("#txtsuffix").val() + '&LastNo=' + MaxID + '&NoOfBarcode=' + NoofBarcode + '&suffix1=' + $("#txtprefix1").val() + '&suffix2=' + $("#txtprefix2").val() + '&suffix3=' + $("#txtprefix3").val() + '&DuplicateCopy=' + DuplicateCopy + '&Size=' + Size + '&Color=' + Color + '');            
  window.location.href=window.location.href;
          
        }

        function NewSeriesBarcode() {
            $.ajax({
                url: "PrePrintedBarcode.aspx/NewSeriesBarcode",
                data: '{ Suffix: "' + $("#txtsuffix").val() + '",LastNo:"' + $("#txtLastNo").val() + '",NoOfBarcode:"' + $("#txtnoofbarcode").val() + '"}', // parameter map       
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData == '1') {

                        alert('New Series Generated..');
                        //  getBarcode();
                    }

                },
                error: function (xhr, status) {

                    alert("Please Contact to ItDose Support Team");

                }
            });
        }

        function getBarcode() {


            $modelBlockUI();
            $.ajax({
                url: "PrePrintedBarcode.aspx/getBarcode",
                data: '{}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData[0].MaxID != null) {
                        $("#txtsuffix").val(PanelData[0].Prefix);
                        $("#txtLastNo").val(PanelData[0].MaxID);
                        $("#txtprefix1").val(PanelData[0].Prefix1);
                        $("#txtprefix2").val(PanelData[0].Prefix2);
                        $("#txtprefix3").val(PanelData[0].Prefix3);
                        $("#btnbarcode").hide();
                    }
                    else {
                        $("#btnbarcode").show();
                        $("#<%=lblMsg.ClientID%>").text("Please generate new series..");
                    }

                    $modelUnBlockUI();

                },
                error: function (xhr, status) {
                    $("#btnbarcode").show();
                    $("#<%=lblMsg.ClientID%>").text("Please generate new series..");
                    window.status = status + "\r\n" + xhr.responseText;
                    $modelUnBlockUI();
                }
            });
        }
        function Clear() {
            $("#txtsuffix").val('');
            $("#txtLastNo").val('');
            $("#txtprefix1").val('');
            $("#txtprefix2").val('');
            $("#txtprefix3").val('');
            $("#txtnoofbarcode").val('');
            $("#<%=lblMsg.ClientID%>").text('');
        }



    </script>

</asp:Content>

