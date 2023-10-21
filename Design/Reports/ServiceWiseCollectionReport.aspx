<%@ Page Language="C#"  AutoEventWireup="true"  CodeFile="ServiceWiseCollectionReport.aspx.cs" EnableEventValidation="false" Inherits="Design_OPD_ServiceWiseCollectionReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/CentreLoad.ascx" TagName="wuc_CentreLoad" TagPrefix="uc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
<link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 

    </head>
    <body >
    
         <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
    <asp:ScriptReference Path="~/Scripts/PostReportScript.js" />
</Scripts>
</Ajax:ScriptManager>
    
        <div class="POuter_Box_Inventory" style="text-align: center; ">

            <b>Service Wise Collection Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-4">From Bill Date<label class="pull-right"> :</label></div>
                <div class="col-md-4">  <asp:TextBox ID="txtFromDate" runat="server" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                <div class="col-md-4">To Bill Date<label class="pull-right"> :</label></div>
                <div class="col-md-4"> <asp:TextBox ID="txtToDate" runat="server"  />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
            </div>
             <div class="row">
                <div class="col-md-4">Bill No.<label class="pull-right"> :</label></div>
                 
                 <div class="col-md-4"><asp:TextBox ID="txtBillNo" runat="server" /></div>
                 <div class="col-md-4"></div>
                 <div class="col-md-12"> <asp:CheckBox ID="chiscancel" runat="server" Text="Include Cancel Bill" Font-Bold="true" />
                        &nbsp;&nbsp;
                        <asp:CheckBox ID="chkPreBooking" runat="server" Text="Only Pre Booking Data" />

                        &nbsp;&nbsp;
                        <asp:CheckBox ID="chkhomecollection" runat="server" Text="Only Home Collection Data" /></div>
             </div>
            <div class="row">
                <div class="col-md-4">Service<label class="pull-right"> :</label></div>
                <div class="col-md-8"><asp:ListBox ID="ddlItem" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
                    </div>
                </div>
             <div class="row" style="display:none">
                <div class="col-md-4"><label class="pull-right">Refer Doctor :</label></div>
                 <div class="col-md-4"> <asp:ListBox ID="ddlItem0" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox></div>
             </div>

            <div class="Purchaseheader">
                Centre Search &nbsp; &nbsp; 
            </div>
            <uc1:wuc_CentreLoad ID="CentreInfo" runat="server" />
            <asp:HiddenField ID="hdnCenterIds" runat="server" />
            <asp:HiddenField ID="hdnSearchData" runat="server" />
            <asp:HiddenField ID="HiddenField1" runat="server" />
            <asp:HiddenField ID="HiddenField2" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; ">
             <div class="row">
                <div class="col-md-24">
            <asp:Button ID="btnReport" runat="server" CssClass="searchbutton" OnClientClick="return getReport();" Text="Report" OnClick="btnReport_Click" />
                    </div>
                 </div>
        </div>
        <div class="POuter_Box_Inventory">
             <div class="row">
                <div class="col-md-6"><asp:CheckBox ID="chkAll" ClientIDMode="Static" runat="server" Text="ALL" onclick="checkAll(this)" /></div>
                 <div class="col-md-6"><asp:CheckBox ID="chkDefaultAll" runat="server" Text="Default Check" ClientIDMode="Static" onclick="checkDefaultAll(this)" Checked="true" /></div>
                 </div>
             <div class="row">
                <div class="col-md-24">
                    <asp:CheckBoxList ID="chkDetail" CssClass="chkColumnsDetail" runat="server" ClientIDMode="Static"  RepeatDirection="Horizontal" RepeatColumns="8" RepeatLayout="Table" ></asp:CheckBoxList>
                    </div>
                 </div>
        </div>

    <script type="text/javascript">
        $(function () {
            $('[id=ddlItem]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=ddlItem0]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });
        function getReport() {
            
            if ($(".chk input[type=checkbox]:checked").length == 0) {
                alert('Please Select Report Column');
                return false;
            }
            var CentreID = '';
            var SelectedLaength = $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                CentreID += $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',')[i] + ',';
            }

            var ZoneId = '';
            var SelectedLengthZone = $('#lstZone').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLengthZone - 1; i++) {
                ZoneId += $('#lstZone').multipleSelect("getSelects").join().split(',')[i] + ',';
            }

            var StateId = '';
            var SelectedLengthState = $('#lstState').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLengthState - 1; i++) {
                StateId += $('#lstState').multipleSelect("getSelects").join().split(',')[i] + ',';
            }

            var CityId = '';
            var SelectedLengthCity = $('#lstCity').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLengthCity - 1; i++) {
                CityId += $('#lstCity').multipleSelect("getSelects").join().split(',')[i] + ',';
            }


            if (CentreID == ',') {
                alert('Please Select Centre...!');
                return false;
            }
            var itemid = $('#ddlItem').val();
            var doctorid = $('#ddlItem0').val();

            $('[id$=hdnCenterIds]').val(CentreID);
            $('[id$=HiddenField1]').val(itemid);
            $('[id$=HiddenField2]').val(doctorid);
            $('[id$=hdnSearchData]').val(ZoneId + '#' + StateId + '#' + CityId + '#' + CentreID);
        }

        function OpenReport() {
            var SearchData = $('[id$=hdnSearchData]').val();

            bindBusinessZoneWiseState(SearchData.split('#')[0].substring(0, SearchData.split('#')[0].length - 1));
            bindBusinessZoneAndStateWiseCity(SearchData.split('#')[0].substring(0, SearchData.split('#')[0].length - 1), SearchData.split('#')[1].substring(0, SearchData.split('#')[1].length - 1));
             bindBusinessZoneAndStateAndCityWiseCentre(SearchData.split('#')[0].substring(0, SearchData.split('#')[0].length - 1), SearchData.split('#')[1].substring(0, SearchData.split('#')[1].length - 1), SearchData.split('#')[2].substring(0, SearchData.split('#')[2].length - 1));
            $('.chkColumnsDetail input[type="checkbox"]').each(function () {
                $(this).parent().addClass('chk');            
                if($(this).val().split('#')[1]=="1")
                    $(this).parent().addClass('chk chkDefault');
                else
                    $(this).parent().addClass('chk');

            });
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var SearchData = $('[id$=hdnSearchData]').val();
            var Zones = '';
            var State = '';
            var Cities = '';
            var Centres = '';

            $('#lstZone').next().find('input[type=checkbox]').each(function () {
                if (SearchData.split('#')[0].split(',').indexOf($(this).val()) != -1) {
                    $(this).prop('checked', true);
                    Zones += $(this).closest('label').text();
                }
            });

            $('#lstState').next().find('input[type=checkbox]').each(function () {
                if (SearchData.split('#')[1].split(',').indexOf($(this).val()) != -1) {
                    $(this).prop('checked', true);
                    State += $(this).closest('label').text();
                }
            });


            $('#lstCity').next().find('input[type=checkbox]').each(function () {
                if (SearchData.split('#')[2].split(',').indexOf($(this).val()) != -1) {
                    $(this).prop('checked', true);
                    Cities += $(this).closest('label').text();
                }
            });

            $('#lstCentreLoadList').next().find('input[type=checkbox]').each(function () {
                if (SearchData.split('#')[3].split(',').indexOf($(this).val()) != -1) {
                    $(this).prop('checked', true);
                    Centres += $(this).closest('label').text();
                }
            });

            $('#lstZone').next().find('.ms-choice').find('span').html(Zones);
            $('#lstState').next().find('.ms-choice').find('span').html(State);
            $('#lstCity').next().find('.ms-choice').find('span').html(Cities);
            $('#lstCentreLoadList').next().find('.ms-choice').find('span').html(Centres);


        });
        function checkAll(rowId) {
            if ($(rowId).is(':checked')) {
                $("#chkDefaultAll").prop('checked', false);
                $(".chk input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $("#chkDefaultAll [type=checkbox]").prop('checked', 'checked');
                $(".chk [type=checkbox]").prop('checked', false);
                $(".chkDefault input[type=checkbox],#chkDefaultAll").prop('checked', 'checked');
            }
        }

        function checkDefaultAll(rowId) {
            if ($(rowId).is(':checked')) {
                $("#chkAll").prop('checked', false);
                $(".chk [type=checkbox]").prop('checked', false);
                $(".chkDefault input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $(".chk [type=checkbox]").prop('checked', false);
                $("#chkAll").prop('checked', 'checked');
                $(".chk input[type=checkbox]").prop('checked', 'checked');
                // $(".chkDefault [type=checkbox]").prop('checked', false);
            }
        }

        
    </script>
</form>
</body>
</html>

