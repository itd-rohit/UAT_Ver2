<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="UpdateClientShare.aspx.cs" Inherits="Design_Invoicing_UpdateClientShare" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">




    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Update Client Share </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-2">
                    <label class="pull-left">Visit No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtVisitNo" runat="server" CssClass="requiredField"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    <input type="button" id="btnSave" class="savebutton" value="Save" onclick="saveClientShare()" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-2">
                </div>
                <div class="col-md-12">
                    <span style="color: #0000ff; font-size: 7.5pt">Note :Multiple visit no. with comma separated.No single quote required with multiple LabNo</span>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-2">
                   <label class="pull-left">  Upload Excel</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:FileUpload ID="fuExcel" runat="server" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnUpload" runat="server" OnClick="btnUpload_Click" Text="Upload Excel" CssClass="savebutton" OnClientClick="return validateUpload();" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-2">
                </div>
                <div class="col-md-10">
                    <span style="color: #0000ff; font-size: 7.5pt">Note :Excel data with header LabNo.No single quote required with LabNo in excel data</span>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function saveClientShare() {
            if (jQuery.trim(jQuery('#txtVisitNo').val()) == "") {
                toast('Error', "Please Enter Visit No.");
                jQuery('#txtVisitNo').focus();
                return;
            }
            serverCall('UpdateClientShare.aspx/ClientShare', { VisitNo: jQuery.trim(jQuery('#txtVisitNo').val()) }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    jQuery('#txtVisitNo').val('');
                    toast('Success', $responseData.response);
                }
                else {
                    toast('Error', $responseData.response);
                    jQuery('#txtVisitNo').focus();
                }
            });
        }
    </script>
    <script type="text/javascript">
        function validateUpload() {

            if ($("#fuExcel")[0].files.length == 0) {
                toast('Error', 'Please Select File');
                $("#fuExcel").focus();
                return false;
            }
            var file = $('#fuExcel').val();
            if (!(/\.(xlsx|xls)$/i).test(file)) {
                toast('Error', 'Please upload valid excel file .xlsx, .xls only');
                $(file).val('');
                return false;
            }

            document.getElementById('<%=btnUpload.ClientID%>').disabled = true;
            document.getElementById('<%=btnUpload.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnUpload', '');

        }
    </script>
</asp:Content>

