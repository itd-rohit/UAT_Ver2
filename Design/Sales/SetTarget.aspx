<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetTarget.aspx.cs" Inherits="Design_Store_SetTarget" MasterPageFile="~/Design/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Conten1" runat="server">
   
    <script src="../../scripts/jquery.extensions.js" type="text/javascript"></script>
   <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <link href="../../App_Style/jquery-ui.css" rel="stylesheet" />
    <style type="text/css">
        .NotValid {
            border-bottom-color: red;
            border-bottom-width: 2px;
        }

        .Amt {
            font-weight: bold;
            color: blue;
            font-size: 15px;
        }

        .AmtH {
            font-weight: bold;
            font-size: 15px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#spnTotalCount").text('0');
            //  $(".target").attr("title", "Enter value in Amount Format");
            BindFinancialYear();
            BindFromYear();
            BindFinanceYearList();
            $("#rbtCategory input[type=radio]").bind("click", function () {
                HideControls();

            });
            $("#rbtTargetBy input[type=radio]").bind("click", function () {
                EnableControls();
            });
            $("#txtTestName").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "SetTarget.aspx/SearchTest",
                        data: '{TestName:"' + $("#txtTestName").val() + '"}',
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            Test = jQuery.parseJSON(result.d);
                            response(Test);

                        },
                        Error: function (xhr, status) {
                            alert("Error");
                        }
                    });
                },
                focus: function () {
                    return false;
                },
                select: function (event, ui) {
                    if ($("#rbtCategory input[type=radio]:checked").val() == "2" && $("#tblAnnualTarget tr").length > 2) {
                        BindSalesTargetTest(ui.item.value, ui.item.label)
                    }
                    else {
                        BindSalesTarget(ui.item.value);
                    }
                    $("#txtTestName").val('');
                    $("#txtTestName").focus();
                    return false;
                },
                open: function () {
                    $("#txtTestName").autocomplete('widget').css(
                         { 'overflow-y': 'auto', 'max-height': '250px', 'overflow-x': 'hidden' });
                },
                appendTo: "#empautolist"

            });
        });
        function HideControls() {
            $('#div_AnnualTarget').html('');
            $('#div_AnnualTarget,#dvFinancialYear,#trTestName').hide();
            $("#spnTotalCount").text('0');
        }
        function DivideValue(rowID, Type) {
           // if ($("#rbtTargetBy input[type=radio]:checked").val() == "1") {
                if (Type == "1") {
                    var Class = $(rowID).parent().parent().attr("class");
                    var AnnualTarget = $(rowID).val();
                    var HalfYearlyTarget = precise_round((AnnualTarget / 2), 2);
                    var QuarterlyTarget = precise_round((AnnualTarget / 4), 2);
                    var MonthlyTarget = precise_round((AnnualTarget / 12), 2);
                    $('#tblAnnualTarget').find('.' + Class).find('[id^=txtHalfYearly]').val(HalfYearlyTarget);
                    $('#tblAnnualTarget').find('.' + Class).find('[id^=txtQuarter]').val(QuarterlyTarget);
                    $('#tblAnnualTarget').find('.' + Class).find('[id^=txtMonth]').val(MonthlyTarget);
                }
                else if (Type == "2") {
                    var Class = $(rowID).parent().parent().attr("class");
                    var ControlID = $(rowID).attr("id").split('_')[1];
                    var YearlyAmt = Number($('#tblAnnualTarget').find('.' + Class).find('#txtAnnualTarget_1').val());
                    var HalfYearlyTarget = $(rowID).val();
                    var OtherHalfYearlyTarget = 0;
                    if (parseFloat(YearlyAmt) >= parseFloat(HalfYearlyTarget))
                        OtherHalfYearlyTarget = parseFloat(YearlyAmt) - parseFloat(HalfYearlyTarget);

                    if (ControlID == "1")
                        $('#tblAnnualTarget').find('.' + Class).find('#txtHalfYearlyFormat_2').val(OtherHalfYearlyTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('[id^=txtHalfYearlyFormat]').each(function (j, e) {
                        DivideValueDependent($(e), 2);
                        });

                }
                else if (Type == "3") {
                    var HalfYearlyTarget = 0;
                    var Class = $(rowID).parent().parent().attr("class");
                    var ControlID = $(rowID).attr("id").split('_')[1];
                    var QuarterlyTarget = $(rowID).val();
                    var OtherQuarterTarget = 0;
                    if (ControlID == "1") {
                        OtherQuarterTarget = 0;
                        HalfYearlyTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtHalfYearlyFormat_1').val());
                        if (parseFloat(HalfYearlyTarget) >= parseFloat(QuarterlyTarget))
                            OtherQuarterTarget = parseFloat(HalfYearlyTarget) - parseFloat(QuarterlyTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_2').val(OtherQuarterTarget);
                    }
                    else if (ControlID == "3") {
                        OtherQuarterTarget = 0;
                        HalfYearlyTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtHalfYearlyFormat_2').val());
                        if (parseFloat(HalfYearlyTarget) >= parseFloat(QuarterlyTarget))
                            OtherQuarterTarget = parseFloat(HalfYearlyTarget) - parseFloat(QuarterlyTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_4').val(OtherQuarterTarget);
                    }

                    $('#tblAnnualTarget').find('.' + Class).find('[id^=txtQuarterFormat]').each(function (j, e) {
                        DivideValueDependent($(e), 3);
                    }); 
                }
                else if (Type == "4") {
                    var QuarterTarget = 0;
                    var Class = $(rowID).parent().parent().attr("class");
                    var ControlID = $(rowID).attr("id").split('_')[1];
                    var MonthTarget = $(rowID).val();
                    var OtherMonthTarget = 0;
                    if (ControlID == "1") {
                        OtherMonthTarget = 0;
                        QuarterTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_1').val());
                        if (parseFloat(QuarterTarget) >= parseFloat(MonthTarget))
                            OtherMonthTarget = parseFloat(QuarterTarget) - parseFloat(MonthTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_2').val(parseFloat(OtherMonthTarget)/2);
                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_3').val(parseFloat(OtherMonthTarget) / 2);
                    }
                    else if (ControlID == "2") {
                        OtherMonthTarget = 0;
                        MonthTarget = parseFloat(MonthTarget) + parseFloat($('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_2').val());
                        QuarterTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_1').val());
                        if (parseFloat(QuarterTarget) >= parseFloat(MonthTarget))
                            OtherMonthTarget = parseFloat(QuarterTarget) - parseFloat(MonthTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_3').val(OtherMonthTarget);
                    }
                    else if (ControlID == "4") {
                        OtherMonthTarget = 0;
                        QuarterTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_2').val());
                        if (parseFloat(QuarterTarget) >= parseFloat(MonthTarget))
                            OtherMonthTarget = parseFloat(QuarterTarget) - parseFloat(MonthTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_5').val(parseFloat(OtherMonthTarget) / 2);
                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_6').val(parseFloat(OtherMonthTarget) / 2);
                    }
                    else if (ControlID == "5") {
                        OtherMonthTarget = 0;
                        MonthTarget = parseFloat(MonthTarget) + parseFloat($('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_5').val());
                        QuarterTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_2').val());
                        if (parseFloat(QuarterTarget) >= parseFloat(MonthTarget))
                            OtherMonthTarget = parseFloat(QuarterTarget) - parseFloat(MonthTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_6').val(OtherMonthTarget);
                    }
                    else if (ControlID == "7") {
                        OtherMonthTarget = 0;
                        QuarterTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_3').val());
                        if (parseFloat(QuarterTarget) >= parseFloat(MonthTarget))
                            OtherMonthTarget = parseFloat(QuarterTarget) - parseFloat(MonthTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_8').val(parseFloat(OtherMonthTarget) / 2);
                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_9').val(parseFloat(OtherMonthTarget) / 2);
                    }
                    else if (ControlID == "8") {
                        OtherMonthTarget = 0;
                        MonthTarget = parseFloat(MonthTarget) + parseFloat($('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_8').val());
                        QuarterTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_3').val());
                        if (parseFloat(QuarterTarget) >= parseFloat(MonthTarget))
                            OtherMonthTarget = parseFloat(QuarterTarget) - parseFloat(MonthTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_9').val(OtherMonthTarget);
                    }
                    else if (ControlID == "10") {
                        OtherMonthTarget = 0;
                        QuarterTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_4').val());
                        if (parseFloat(QuarterTarget) >= parseFloat(MonthTarget))
                            OtherMonthTarget = parseFloat(QuarterTarget) - parseFloat(MonthTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_11').val(parseFloat(OtherMonthTarget) / 2);
                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_12').val(parseFloat(OtherMonthTarget) / 2);
                    }
                    else if (ControlID == "11") {
                        OtherMonthTarget = 0;
                        MonthTarget = parseFloat(MonthTarget) + parseFloat($('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_11').val());
                        QuarterTarget = Number($('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_4').val());
                        if (parseFloat(QuarterTarget) >= parseFloat(MonthTarget))
                            OtherMonthTarget = parseFloat(QuarterTarget) - parseFloat(MonthTarget);

                        $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_12').val(OtherMonthTarget);
                    }
                }
            //  }
        }
        function DivideValueDependent(rowID, Type) {
          //  if ($("#rbtTargetBy input[type=radio]:checked").val() == "1") {
                if (Type == "2") {
                    var Class = $(rowID).parent().parent().attr("class");
                    var ControlID = $(rowID).attr("id").split('_')[1];
                    var HalfYearlyTarget = $(rowID).val();
                    var QuarterlyTarget = precise_round((HalfYearlyTarget / 2), 2);
                    var MonthlyTarget = precise_round((HalfYearlyTarget / 6), 2);
                    if (ControlID == "1") {

                        for (var i = 1; i <= 2; i++) {
                            $('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_' + i).val(QuarterlyTarget);
                        }
                        for (var i = 1; i <= 6; i++) {
                            $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_' + i).val(MonthlyTarget);
                        }
                    }
                    else {
                        for (var i = 3; i <= 4; i++) {
                            $('#tblAnnualTarget').find('.' + Class).find('#txtQuarterFormat_' + i).val(QuarterlyTarget);
                        }
                        for (var i = 7; i <= 12; i++) {
                            $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_' + i).val(MonthlyTarget);
                        }
                    }
                }
                else if (Type == "3") {
                    var Class = $(rowID).parent().parent().attr("class");
                    var ControlID = $(rowID).attr("id").split('_')[1];
                    var QuarterTarget = $(rowID).val();
                    var MonthlyTarget = precise_round((QuarterTarget / 3), 2);
                    if (ControlID == "1") {
                        for (var i = 1; i <= 3; i++) {
                            $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_' + i).val(MonthlyTarget);
                        }
                    }
                    else if (ControlID == "2") {
                        for (var i = 4; i <= 6; i++) {
                            $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_' + i).val(MonthlyTarget);
                        }
                    }
                    else if (ControlID == "3") {
                        for (var i = 7; i <= 9; i++) {
                            $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_' + i).val(MonthlyTarget);
                        }
                    }
                    else if (ControlID == "4") {
                        for (var i = 10; i <= 12; i++) {
                            $('#tblAnnualTarget').find('.' + Class).find('#txtMonthFormat_' + i).val(MonthlyTarget);
                        }
                    }
                }
         //   }
        }
        function BindAnnualTarget(rowID) {
            var TargetValue = $(rowID).val();
            $('[id^=txtAnnualTarget_]').val(TargetValue);
            $('[id^=txtAnnualTarget_]').each(function (i, e) {
                DivideValue($(e), 1);
            });
        }
        function BindHalfYearlyTarget(rowID) {
            var TargetValue = $(rowID).val();
            $('[id^=txtHalfYearlyFormat_]').val(TargetValue);
            $('[id^=txtHalfYearlyFormat_]').each(function (i, e) {
                DivideValue($(e), 2);
            });
        }
        function BindQuarterTarget(rowID) {
            var TargetValue = $(rowID).val();
            $('[id^=txtQuarterFormat_]').val(TargetValue);
            $('[id^=txtQuarterFormat_]').each(function (i, e) {
                DivideValue($(e), 3);
            });
        }
        function BindMonthTarget(rowID) {
            var TargetValue = $(rowID).val();
            $('[id^=txtMonthFormat]').val(TargetValue);
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function EnableControls() {
            $('[id^=txtAnnual]:not(.serverDisabled)').attr("disabled", false);
            $('[id^=txtHalfYearly]:not(.serverDisabled)').attr("disabled", false);
            $('[id^=txtQuarter]:not(.serverDisabled)').attr("disabled", false);

            var Value = $("#rbtTargetBy input[type=radio]:checked").val();
            if (Value == "1") {
                $('[id^=txtAnnual]:not(.serverDisabled)').attr("disabled", false);
                $('[id^=txtHalfYearly]:not(.serverDisabled)').attr("disabled", false);
                $('[id^=txtQuarter]:not(.serverDisabled)').attr("disabled", false);
            }
            else if (Value == "2") {
                $('[id^=txtAnnual]:not(.serverDisabled)').attr("disabled", true);
                $('[id^=txtHalfYearly]:not(.serverDisabled)').attr("disabled", false);
                $('[id^=txtQuarter]:not(.serverDisabled)').attr("disabled", false);

            }
            else if (Value == "3") {
                $('[id^=txtAnnual]:not(.serverDisabled)').attr("disabled", true);
                $('[id^=txtHalfYearly]:not(.serverDisabled)').attr("disabled", true);
                $('[id^=txtQuarter]:not(.serverDisabled)').attr("disabled", false);
            }
            else if (Value == "4") {
                $('[id^=txtAnnual]:not(.serverDisabled)').attr("disabled", true);
                $('[id^=txtHalfYearly]:not(.serverDisabled)').attr("disabled", true);
                $('[id^=txtQuarter]:not(.serverDisabled)').attr("disabled", true);
            }
          //  $('.serverDisabled').attr("disabled", true);
        }
        function BindTargetData() {
            if ($("#rbtCategory input[type=radio]:checked").val() == "2") {
                $("#trTestName").show();
                $("#txtTestName").focus();
                $("#spnFormat").text('Note : Value Enter in Countable Format ');
            }
            else if ($("#rbtCategory input[type=radio]:checked").val() == "1") {
                $("#trTestName").hide();
                $("#spnFormat").text('Note : Value Enter in Amount Format ');
            }
            else {
                $("#trTestName").hide();
                $("#spnFormat").text('Note : Value Enter in Countable Format ');
            }
            $("#txtTestName").val('');
            BindSalesTarget(0);
        }
        function wopen(url, txtID, rowID) {
            var MonthTarget = Number($('#' + txtID).val());
            var TargetTypeId = $("#rbtCategory input[type=radio]:checked").val();
            // var FinancialYearId=$("#ddlFinacialYear").val();
            var SalesCategoryID = $(rowID).parent().parent().attr('class');
            var Format = "";
            if ($("#rbtCategory input[type=radio]:checked").val() == "1")
                Format = "Amount";
            else
                Format = "Count";

            var win = window.open(url + '&MonthTarget=' + MonthTarget + '&Format=' + Format + '&TargetTypeId=' + TargetTypeId + '&SalesCategoryID=' + SalesCategoryID, 'popup', 'width=1015, height=600, ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=yes, resizable=no');
            win.resizeTo(1015, 600);
            win.moveTo(10, 100);
            win.focus();
        }
        function DeleteRow(rowID) {
            var rowClass = $(rowID).parent().parent().attr('class');
            $('#tblAnnualTarget').find('.' + rowClass).remove();
            var TotalCount = $.trim($("#spnTotalCount").text());
            $("#spnTotalCount").text((parseFloat(TotalCount) - 1));
        }
        function checkNumeric(e, sender) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function BindSalesTarget(rowID) {
            $("#spnTotalCount").text('0');
         //   $('[id^=txt]').removeClass('serverDisabled');
            $("#spnMsg").text('');
            if ($("#ddlFinacialYear").val() == "0") {
                $("#spnMsg").text('Please Select Proper Financial Year');
                $("#ddlFinacialYear").focus();
                return;
            }
            $.ajax({
                url: "SetTarget.aspx/BindSalesAnnualTarget",
                data: '{SalesCategoryID:"' + $("#rbtCategory input[type=radio]:checked").val() + '",FilterID:"' + rowID + '",FinancialYear:"' + $("#ddlFinacialYear").val() + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    AnnualTarget = jQuery.parseJSON(result.d);
                    if ((AnnualTarget != "") && (AnnualTarget != null)) {
                        var output = $('#sc_AnnualTarget').parseTemplate(AnnualTarget);
                        $('#div_AnnualTarget').html(output);
                        $('#div_AnnualTarget').show();
                        $('#dvFinancialYear').show();
                        EnableControls();
                        $("#spnTotalCount").text('1');
                    }
                    else {
                        $('#div_AnnualTarget').html('');
                        $('#div_AnnualTarget').hide();
                        $('#dvFinancialYear').hide();
                        $("#spnMsg").text('Record Not Found');
                    }
                },
                error: function (xhr, status) {
                    $('#div_AnnualTarget').html('');
                    $('#div_AnnualTarget').hide();
                    $('#dvFinancialYear').hide();
                    $("#spnMsg").text('Error occurred, Please contact administrator');
                }
            });
        }
        function BindSalesTargetTest(rowID, rowName) {
            $("#spnMsg").text('');
            var lastRowClass = $('#tblAnnualTarget tr:last').attr("class");
            var LastSerialNo = $('#tblAnnualTarget tr:last').find('#tdSerialNew').text();
            $('#tblAnnualTarget').find('.' + lastRowClass).each(function (i, e) {

                $("#tblAnnualTarget").append('<tr class=' + rowID + '>' + e.innerHTML + '</tr>');
            });
            $('#tblAnnualTarget').find('.' + rowID).find('#tdSalesCategoryID').text(rowID);
            $('#tblAnnualTarget').find('.' + rowID).find('#tdSalesCategory').text(rowName);
            $('#tblAnnualTarget').find('.' + rowID).find('#tdSerial,#tdSerialNew').text(parseFloat(LastSerialNo) + 1);
            $('#tblAnnualTarget').find('.' + rowID).find('[id^=txt]').val('');

            var TotalCount = $.trim($("#spnTotalCount").text());
          //  alert(TotalCount);
            $("#spnTotalCount").text((parseFloat(TotalCount) + 1));

        }
        function SaveAnnualTarget() {
            $('[id^=txt]').removeClass('NotValid');
            var classes = [];
            $("#tblAnnualTarget tr").not(':first').each(function (i, e) {
                var className = $(e).attr("class");
                if (classes.indexOf(className) < 0)
                    classes.push(className);
            });
            var sTarget = [];
            $(classes).each(function (i, e) {
                var allparents = $('.' + e);
                sTarget.push({
                    m1: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_1', value: Number(allparents.find('#txtHalfYearlyFormat_1').val()) },
                        q: { id: 'txtQuarterFormat_1', value: Number(allparents.find('#txtQuarterFormat_1').val()) },
                        m: { id: 'txtMonthFormat_1', value: Number(allparents.find('#txtMonthFormat_1').val()) }
                    },
                    m2: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_1', value: Number(allparents.find('#txtHalfYearlyFormat_1').val()) },
                        q: { id: 'txtQuarterFormat_1', value: Number(allparents.find('#txtQuarterFormat_1').val()) },
                        m: { id: 'txtMonthFormat_2', value: Number(allparents.find('#txtMonthFormat_2').val()) }
                    },
                    m3: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_1', value: Number(allparents.find('#txtHalfYearlyFormat_1').val()) },
                        q: { id: 'txtQuarterFormat_1', value: Number(allparents.find('#txtQuarterFormat_1').val()) },
                        m: { id: 'txtMonthFormat_3', value: Number(allparents.find('#txtMonthFormat_3').val()) }
                    },
                    m4: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_1', value: Number(allparents.find('#txtHalfYearlyFormat_1').val()) },
                        q: { id: 'txtQuarterFormat_2', value: Number(allparents.find('#txtQuarterFormat_2').val()) },
                        m: { id: 'txtMonthFormat_4', value: Number(allparents.find('#txtMonthFormat_4').val()) }
                    },
                    m5: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_1', value: Number(allparents.find('#txtHalfYearlyFormat_1').val()) },
                        q: { id: 'txtQuarterFormat_2', value: Number(allparents.find('#txtQuarterFormat_2').val()) },
                        m: { id: 'txtMonthFormat_5', value: Number(allparents.find('#txtMonthFormat_5').val()) }
                    },
                    m6: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_1', value: Number(allparents.find('#txtHalfYearlyFormat_1').val()) },
                        q: { id: 'txtQuarterFormat_2', value: Number(allparents.find('#txtQuarterFormat_2').val()) },
                        m: { id: 'txtMonthFormat_6', value: Number(allparents.find('#txtMonthFormat_6').val()) }
                    },
                    m7: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_2', value: Number(allparents.find('#txtHalfYearlyFormat_2').val()) },
                        q: { id: 'txtQuarterFormat_3', value: Number(allparents.find('#txtQuarterFormat_3').val()) },
                        m: { id: 'txtMonthFormat_7', value: Number(allparents.find('#txtMonthFormat_7').val()) }
                    },
                    m8: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_2', value: Number(allparents.find('#txtHalfYearlyFormat_2').val()) },
                        q: { id: 'txtQuarterFormat_3', value: Number(allparents.find('#txtQuarterFormat_3').val()) },
                        m: { id: 'txtMonthFormat_8', value: Number(allparents.find('#txtMonthFormat_8').val()) }
                    },
                    m9: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_2', value: Number(allparents.find('#txtHalfYearlyFormat_2').val()) },
                        q: { id: 'txtQuarterFormat_3', value: Number(allparents.find('#txtQuarterFormat_3').val()) },
                        m: { id: 'txtMonthFormat_9', value: Number(allparents.find('#txtMonthFormat_9').val()) }
                    },
                    m10: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_2', value: Number(allparents.find('#txtHalfYearlyFormat_2').val()) },
                        q: { id: 'txtQuarterFormat_4', value: Number(allparents.find('#txtQuarterFormat_4').val()) },
                        m: { id: 'txtMonthFormat_10', value: Number(allparents.find('#txtMonthFormat_10').val()) }
                    },
                    m11: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_2', value: Number(allparents.find('#txtHalfYearlyFormat_2').val()) },
                        q: { id: 'txtQuarterFormat_4', value: Number(allparents.find('#txtQuarterFormat_4').val()) },
                        m: { id: 'txtMonthFormat_11', value: Number(allparents.find('#txtMonthFormat_11').val()) }
                    },
                    m12: {
                        className: e,
                        a: { id: 'txtAnnualTarget_1', value: Number(allparents.find('#txtAnnualTarget_1').val()) },
                        h: { id: 'txtHalfYearlyFormat_2', value: Number(allparents.find('#txtHalfYearlyFormat_2').val()) },
                        q: { id: 'txtQuarterFormat_4', value: Number(allparents.find('#txtQuarterFormat_4').val()) },
                        m: { id: 'txtMonthFormat_12', value: Number(allparents.find('#txtMonthFormat_12').val()) }
                    }
                })
            });

            $.ajax({
                url: "SetTarget.aspx/SaveFinancialYearTarget",
                data: JSON.stringify({ SalesCategoryID: $("#rbtCategory input[type=radio]:checked").val(), FinancialYear: $("#ddlFinacialYear").val(), SalesTarget: sTarget , TargetSetBy:$("#rbtTargetBy input[type=radio]:checked").val()}),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    IsSuccess = result.d;
                    if (IsSuccess == "1") {
                        $("#spnMsg").text('Target Set Successfully');
                        BindFinanceYearList();
                    }
                    else {
                        $("#spnMsg").text('Target are Not Matched. Sum of Child target should be greater than or equal to Parent target');
                        var TargetValue = [];
                        TargetValue = IsSuccess.replace('"', '').split(',');
                        for (var a = 1; a <= TargetValue.length; a++) {
                            $('#' + TargetValue[a]).addClass('NotValid');
                        }
                    }
                },
                error: function (xhr, status) {
                    $("#spnMsg").text('Error Occurred');
                }
            });
        }
        function BindFinancialYear() {
            $("#ddlFinacialYear option").remove();
            $.ajax({
                url: "SetTarget.aspx/BindFinancialYear",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    FinacialYear = jQuery.parseJSON(result.d);
                    $("#ddlFinacialYear").append($("<option></option>").val('0').html('--Select--'));
                    if ((FinacialYear != "") && (FinacialYear != null)) {
                        for (i = 0; i < FinacialYear.length; i++) {
                            $("#ddlFinacialYear").append($("<option></option>").val(FinacialYear[i].ID).html(FinacialYear[i].FinancialYear));
                        }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function BindFromYear() {
            $("#ddlFromYear option").remove();
            $.ajax({
                url: "SetTarget.aspx/BindFromYear",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    FromYear = jQuery.parseJSON(result.d);
                    $("#ddlFromYear").append($("<option></option>").val('0').html('--Select--'));
                    if ((FromYear != "") && (FromYear != null)) {
                        for (i = 0; i < FromYear.length; i++) {
                            $("#ddlFromYear").append($("<option></option>").val(FromYear[i].Year).html(FromYear[i].Year));
                        }
                        BindFinanceYear(0);
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function BindToYear() {
            var FromYear = $("#ddlFromYear").val();
            $("#ddlToYear option").remove();
            if (FromYear != "0") {
                $.ajax({
                    url: "SetTarget.aspx/BindToYear",
                    data: '{FromYear:"' + FromYear + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        ToYear = jQuery.parseJSON(result.d);
                        if ((ToYear != "") && (ToYear != null)) {
                            for (i = 0; i < ToYear.length; i++) {
                                $("#ddlToYear").append($("<option></option>").val(ToYear[i].Year).html(ToYear[i].Year));
                            }
                            BindFinanceYear(1);
                        }
                    },
                    error: function (xhr, status) {
                    }
                });
            }
        }
        function RemoveFinancialYear(Id) {
            $("#spnErrorMsg").text('');
            $.ajax({
                url: "SetTarget.aspx/DeleteFinancialYear",
                data: '{Id:"' + Id + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    IsSuccess = jQuery.parseJSON(result.d);
                    if (IsSuccess == "1") {
                        $("#spnErrorMsg").text('Financial Year Deleted Successfully');
                        ClearPopupControl();
                        BindFinanceYearList();
                        BindFinancialYear();
                    }
                    else {
                        $("#spnErrorMsg").text('Financial Year Not Deleted');
                    }
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error Occurred');
                }
            });
        }
        function BindFinanceYearList() {
            $.ajax({
                url: "SetTarget.aspx/BindFinancialYearList",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    FinanceYearList = jQuery.parseJSON(result.d);
                    if ((FinanceYearList != "") && (FinanceYearList != null)) {
                        var output = $('#sp_FinancialYear').parseTemplate(FinanceYearList);
                        $('#dvFinancialYearList').html(output);
                        $('#dvFinancialYearList').show();
                    }
                    else {
                        $('#dvFinancialYearList').html('');
                        $('#dvFinancialYearList').hide();
                    }
                },
                error: function (xhr, status) {
                    $('#dvFinancialYearList').html('');
                    $('#dvFinancialYearList').hide();
                }
            });
        }
        function BindFinanceYear(strID) {
            if (strID != "0") {
                if ($("#ddlFromYear").val() == "0") {
                    alert('Please Select Proper From Year');
                    $("#spnFinancialYear").text('');
                    return;
                }
                var FromYear = $("#ddlFromYear").val();
                var ToYear = $("#ddlToYear").val().substring(2, 4);
                $("#spnFinancialYear").text(FromYear + '-' + ToYear);
                $("#spnTotalYear").text(parseFloat(ToYear) - parseFloat(FromYear.substring(2, 4)));
            }
        }
        function SaveFinancialYear() {
            $("#spnErrorMsg").text('');
            $.ajax({
                url: "SetTarget.aspx/SaveFinancialYear",
                data: '{FromYear:"' + $("#ddlFromYear").val() + '",ToYear:"' + $("#ddlToYear").val() + '",FinancialYear:"' + $("#spnFinancialYear").text() + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    IsSuccess = jQuery.parseJSON(result.d);
                    if (IsSuccess == "1") {
                        $("#spnErrorMsg").text('Financial Year Saved Successfully');
                        ClearPopupControl();
                        BindFinanceYearList();
                        BindFinancialYear();
                    }
                    else if (IsSuccess == "2") {
                        $("#spnErrorMsg").text('Financial Year Already Exist');
                    }
                    else {
                        $("#spnErrorMsg").text('Financial Year Not Saved');
                    }
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error Occurred');
                }
            });
        }
        function ClearPopupControl() {
            $("#ddlFromYear").val('0');
            $("#ddlToYear option").remove();
            $("#spnFinancialYear").text('');
            $("#spnTotalYear").text('');
        }
    </script>
    <script id="sc_AnnualTarget" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1"  id="tblAnnualTarget"
	style="width:100%;border-collapse:collapse;">
        
		<tr id="headerTarget">
            <#if($("#rbtCategory input[type=radio]:checked").val()=="2"){#>
              <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Delete</th>
              <#} #> 
			<th class="GridViewHeaderStyle" scope="col" style="width:30px; display:none;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:left;" > <#if(AnnualTarget[0].SalesID=="2"){#> Test Name <#} else{#> Category <#}  #> </th>	
            <th class="GridViewHeaderStyle" scope="col" style="text-align:right;width:226px;" >Annual 
                  <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>
                <span class="AmtH">₹</span>   
                <#} #> : <input id="txtAnnualTargetAll" maxlength="10" class="target <#if(AnnualTarget[0].FinalDisable=="true"){#> serverDisabled <#} #>" onkeypress="return checkNumeric(event,this);" <#if(AnnualTarget[0].FinalDisable=="true"){#>  disabled="disabled" <#} #>  onkeyup="BindAnnualTarget(this)" <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>title="Enter value in Amount format" placeholder="In Amount" <#} else {#> title="Enter value in Count format" placeholder="In Count" <#} #> style="width:100px;" />&nbsp;&nbsp;</th>	
			<th class="GridViewHeaderStyle" scope="col" style="text-align:right;width:255px;" >Half Yearly 
                <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>
                <span class="AmtH">₹</span>
                <#} #> : <input id="txtHalfYearlyTargetAll" maxlength="10" class="target <#if(AnnualTarget[0].HalfYearlyDisable=="true"){#> serverDisabled <#} #>" onkeypress="return checkNumeric(event,this);" <#if(AnnualTarget[0].HalfYearlyDisable=="true"){#>  disabled="disabled" <#} #> onkeyup="BindHalfYearlyTarget(this)" <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>title="Enter value in Amount format" placeholder="In Amount"  <#} else {#> title="Enter value in Count format" placeholder="In Count" <#} #> style="width:100px;" />&nbsp;&nbsp;</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:right;width:232px;" >Quarter 
                <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>
                <span class="AmtH">₹</span>
                <#} #> : <input id="txtQuarterTargetAll" maxlength="10" class="target <#if(AnnualTarget[0].QuarterDisable=="true"){#> serverDisabled <#} #>" onkeypress="return checkNumeric(event,this);" <#if(AnnualTarget[0].QuarterDisable=="true"){#>  disabled="disabled" <#} #> onkeyup="BindQuarterTarget(this)" <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>title="Enter value in Amount format" placeholder="In Amount"  <#} else {#> title="Enter value in Count format" placeholder="In Count" <#} #> style="width:100px;" />&nbsp;&nbsp;</th>  		          	
            <th class="GridViewHeaderStyle" scope="col" colspan="2" style="text-align:right;" >Month 
                <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>
                <span class="AmtH">₹</span>
                <#} #> : <input id="txtMonthTargetAll" maxlength="10" class="target <#if(AnnualTarget[0].MonthDisable=="true"){#> serverDisabled <#} #>" onkeypress="return checkNumeric(event,this);" <#if(AnnualTarget[0].MonthDisable=="true"){#>  disabled="disabled" <#} #> onkeyup="BindMonthTarget(this)" <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>title="Enter value in Amount format" placeholder="In Amount"  <#} else {#> title="Enter value in Count format" placeholder="In Count" <#} #> style="width:100px;" />&nbsp;&nbsp;</th>   
            <th class="GridViewHeaderStyle" scope="col" style=" width:100px;" >Tag Employee</th>    
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">AnnualId</th>  
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">HalfYearlyId</th>  
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">QuarterId</th>  
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">MonthId</th>  
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">SNo</th>  
		</tr>
		<#      
		var dataLength=AnnualTarget.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;  
        var SerialNo=0; 
		for(var j=0;j<dataLength;j++)
		{   
		objRow = AnnualTarget[j];
         var ModeValue=(j+1)%12;
            if(ModeValue==1)
                SerialNo=SerialNo+1;
		#>         

					<tr class="<#=objRow.SalesCategoryID#>"
                        <#if(objRow.IsExist!="0"){#>
                         style="background-color:lightgreen;"
                           <#} #>>

                          <#if($("#rbtCategory input[type=radio]:checked").val()=="2" && objRow.IsAnnualRowSpan=="1"){#>
                          <td class="GridViewLabItemStyle" id="tdDelete" rowspan="<#=objRow.AnnualRowSpan#>" style="width:30px; text-align:center;">
                                <img id="imgDelete" alt="" src="../../App_Images/Delete.gif" onclick="DeleteRow(this);" style="cursor:auto;" />
                                </td>
                         <#}
                        #>  
                         <#if(objRow.IsAnnualRowSpan=="1"){#>
                          <td class="GridViewLabItemStyle" id="tdSerial" rowspan="<#=objRow.AnnualRowSpan#>" style="width:30px; text-align:center; display:none;"><#=SerialNo#></td>
                         <#}
                        #>  
                        <#if(objRow.IsAnnualRowSpan=="1"){#>
                               <td class="GridViewLabItemStyle" id="tdSalesCategory" style="text-align:left;" rowspan="<#=objRow.AnnualRowSpan#>" ><span style="width:100px;word-wrap:break-word;" ><#=objRow.SalesCategory#></span></td>
                        <#}
                        #> 
                         <#if(objRow.IsAnnualRowSpan=="1"){#>
                               <td class="GridViewLabItemStyle" id="tdAnnualFormat" style="text-align:right;width:247px;" rowspan="<#=objRow.AnnualRowSpan#>"><#=objRow.AnnualFormat#>&nbsp;:&nbsp;<input id="txtAnnualTarget_<#=objRow.AnnualID#>" maxlength="10" class="target <#if(objRow.FinalDisable=="true"){#> serverDisabled <#} #>" onkeyup="DivideValue(this,1)" <#if(objRow.FinalDisable=="true"){#>  disabled="disabled" <#} #> value="<#=objRow.AnnualTargetValue#>" <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>title="Enter value in Amount format" placeholder="In Amount"  <#} else {#> title="Enter value in Count format" placeholder="In Count" <#} #> onkeypress="return checkNumeric(event,this);" style="width:100px;" />&nbsp;&nbsp;</td> 
                        <#}
                        #> 
                         <#if(objRow.IsHalfRowSpan=="1"){#>
                            <td class="GridViewLabItemStyle" id="tdHalfYearlyFormat" style="text-align:right;width:266px;" rowspan="<#=objRow.HalfYearlyRowSpan#>"><#=objRow.HalfYearlyFormat#>&nbsp;:&nbsp;<input id="txtHalfYearlyFormat_<#=objRow.HalfYearlyID#>" maxlength="10" class="target <#if(objRow.HalfYearlyDisable=="true"){#> serverDisabled <#} #>" onkeyup="DivideValue(this,2)" <#if(objRow.HalfYearlyDisable=="true"){#>  disabled="disabled" <#} #> value="<#=objRow.HalfYearlyTargetValue#>" <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>title="Enter value in Amount format" placeholder="In Amount"  <#} else {#> title="Enter value in Count format" placeholder="In Count" <#} #> onkeypress="return checkNumeric(event,this);" style="width:100px;" />&nbsp;&nbsp; </td>
                        <#}
                        #>
                         <#if(objRow.IsQuarterRowSpan=="1"){#>
                               <td class="GridViewLabItemStyle" id="tdQuarterFormat" style="text-align:right;width:247px;" rowspan="<#=objRow.QuarterRowSpan#>" ><#=objRow.QuarterFormat#>&nbsp;:&nbsp;<input id="txtQuarterFormat_<#=objRow.QuarterID#>" maxlength="10" class="target <#if(objRow.QuarterDisable=="true"){#> serverDisabled <#} #>" onkeyup="DivideValue(this,3)" <#if(objRow.QuarterDisable=="true"){#>  disabled="disabled" <#} #> value="<#=objRow.QuarterTargetValue#>" <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>title="Enter value in Amount format" placeholder="In Amount"  <#} else {#> title="In Count" placeholder="In Count" <#} #> onkeypress="return checkNumeric(event,this);" style="width:100px;" />&nbsp;&nbsp; </td>
                        <#}
                        #>
                    <td class="GridViewLabItemStyle" id="tdMonthFormat" style="text-align:right;width:103px;" ><#=objRow.MonthFormat#>&nbsp;:&nbsp;</td>  
                    <td class="GridViewLabItemStyle" id="tdMonthTarget" style="text-align:right;width:120px;" rowspan="1" ><input id="txtMonthFormat_<#=objRow.MonthID#>" class="target <#if(objRow.MonthDisable=="true"){#> serverDisabled <#} #>" onkeyup="DivideValue(this,4)" <#if(objRow.MonthDisable=="true"){#> disabled="disabled" <#} #> value="<#=objRow.MonthTargetValue#>" <#if($("#rbtCategory input[type=radio]:checked").val()=="1"){#>title="Enter value in Amount format" placeholder="In Amount" <#} else {#> title="Enter value in Count format" placeholder="In Count" <#} #> onkeypress="return checkNumeric(event,this);" maxlength="10" style="width:100px;" />&nbsp;&nbsp; </td> 
                    <td class="GridViewLabItemStyle" id="tdTagEmployee" style="text-align:center; width:100px;" >
                         <#if(objRow.MonthDisable=="false"){#>
                     <img id="ImgTagEmployee" alt="" src="../../App_Images/View.gif" onclick="wopen('SetMonthwiseTarget.aspx?MonthID=<#=objRow.MonthID#>&FinacialYearID=<#=objRow.FinacialYearID#>','txtMonthFormat_<#=objRow.MonthID#>',this);return false" style="cursor:auto;" />
                         <#}#>
                    </td>   
                    <td class="GridViewLabItemStyle" id="tdAnnualId" style="display:none;"><#=objRow.AnnualID#> </td> 
                    <td class="GridViewLabItemStyle" id="tdHalfYearlyID" style="display:none;"><#=objRow.HalfYearlyID#> </td>
                    <td class="GridViewLabItemStyle" id="tdQuarterID" style="display:none;"><#=objRow.QuarterID#> </td>
                    <td class="GridViewLabItemStyle" id="tdMonthID" style="display:none;"><#=objRow.MonthID#> </td> 
                    <td class="GridViewLabItemStyle" id="tdSalesCategoryID" style="display:none;"><#=objRow.SalesCategoryID#> </td>
                    <td class="GridViewLabItemStyle" id="tdSerialNew" style="display:none;"><#=SerialNo#></td> 
                 </tr>
		<#}        
		#>  
              
	 </table>    
	</script>
    <script id="sp_FinancialYear" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1"  id="tblFianncialYear"
	style="width:100%;border-collapse:collapse;">
		<tr id="TrFinancialYearMaster">
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;" >Financial Year </th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;" >From Date </th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;" >To Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;" >Delete</th>  
		</tr>
		<#       
		var dataLength=FinanceYearList.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		for(var k=0;k<dataLength;k++)
		{       
		objRow = FinanceYearList[k];
		#>         
					<tr>
                    <td class="GridViewLabItemStyle" style="text-align:center;" ><#=k+1#></td>  
                    <td class="GridViewLabItemStyle" id="tdFinancialYear" style="width:100px; text-align:center;"><#=objRow.FinancialYear#> </td> 
                    <td class="GridViewLabItemStyle" id="tdFromDate" style="width:100px; text-align:center;"><#=objRow.FromDate#> </td>
                    <td class="GridViewLabItemStyle" id="tdToDate" style="width:100px; text-align:center;"><#=objRow.ToDate#> </td>
                    <td class="GridViewLabItemStyle" style="width:50px; text-align:center;">
                        <# if(objRow.IsDelete =="1"){#>
                        <img id="imgRemoveFinancialYear" alt="1" src="../../App_Images/Delete.gif" onclick="RemoveFinancialYear(<#=objRow.ID#>)" style="cursor: pointer;" />
                        <#}#>
                    </td> 
                 </tr>     
		<#}        
		#>      
	 </table>    
	</script>
    <div id="Pbody_box_inventory" style="width: 1305px;">
        <Ajax:ScriptManager ID="ScriptManager1" EnablePageMethods="true" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">
            <b>Set Sales Target</b>
            <br />
            <span id="spnMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                Target Details
            </div>
            <div class="Content">
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right; color:blue; font-weight:bold;">Financial Year :&nbsp;
                        </td>
                        <td style="text-align: left;">
                            <select id="ddlFinacialYear" onchange="HideControls()" tabindex="1"></select>
                        </td>
                        <td style="text-align: right; color:blue; font-weight:bold;">Target Set By :</td>
                        <td style="text-align: left;">
                            <asp:RadioButtonList ID="rbtTargetBy" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal" TabIndex="2">
                                <asp:ListItem Selected="True" Value="1">Annualy</asp:ListItem>
                                <asp:ListItem Value="2">Half-Yearly</asp:ListItem>
                                <asp:ListItem Value="3">Quarterly</asp:ListItem>
                                <asp:ListItem Value="4">Monthly</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="text-align: right; color:blue; font-weight:bold;display:none;">Filter Category :</td>
                        <td style="text-align: left; display:none;">
                            <asp:RadioButtonList ID="rbtCategory" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal" TabIndex="3"></asp:RadioButtonList>
                        </td>

                    </tr>
                    <tr>
                        <td style="text-align: right;" colspan="6"><input type="button" id="btnSearch" value="Search" onclick="BindTargetData()" class="searchbutton" tabindex="4" />&nbsp;&nbsp;<asp:Button ID="btnaddFinancialYear" runat="server" Text="Add New Financial Year" class="searchbutton" />&nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr id="trTestName" style="display: none;">
                        <td style="text-align: right; width: 12%">Test Name :&nbsp;
                        </td>
                        <td style="text-align: left;" colspan="5">
                            <input type="text" id="txtTestName" style="width: 500px;" />&nbsp;&nbsp;<span id="spnTotalCountCap" style="font-size:14px; font-weight:bold; color:blue;" >Total Test :</span>&nbsp;<span id="spnTotalCount" style="font-size:14px; font-weight:bold; color:green;" ></span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="dvFinancialYear" style="display: none;">
            <div class="POuter_Box_Inventory" style="width: 1300px;">
                <div class="Purchaseheader">
                    Set Target &nbsp;&nbsp;&nbsp;<span id="spnFormat" class="GridViewLabItemStyle" style="background-color: lightpink; color: black;"> Note : Value Enter in Amount Format</span>
                    &nbsp;&nbsp;&nbsp;<span id="spnInd" class="GridViewLabItemStyle" style="background-color: lightgreen; color: black;"> Light Green Color : Target Already Set </span>
                </div>
                <div id="div_AnnualTarget" style="height: auto; background-color: #FFFFFF; border-style: solid; max-height: 330px; overflow: auto; border-width: 1px; border-color: black; overflow: auto;"></div>
                <br />
            </div>
            <div class="POuter_Box_Inventory" style="width: 1300px;">
                <div class="Content" style="text-align: center;">
                    <input type="button" id="btnSave" value="Save" onclick="SaveAnnualTarget()" class="savebutton" />
                </div>
            </div>
        </div>
    </div>
    <cc1:ModalPopupExtender ID="mpFinancialYearPopup" runat="server"
        DropShadow="true" TargetControlID="btnaddFinancialYear" CancelControlID="closeFinancialYearPopup" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddFinancialYear" OnCancelScript="ClearPopupControl()" BehaviorID="mpFinancialYearPopup">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlAddFinancialYear" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none; width: 460px; max-height: 292px;">
        <div class="Purchaseheader">
            <table style="width: 100%; border-collapse: collapse" border="0">
                <tr>
                    <td>Add Financial Year
                    </td>
                    <td style="text-align: right">
                        <img id="closeFinancialYearPopup" alt="1" src="../../App_Images/Delete.gif" style="cursor: pointer;" />
                    </td>
                </tr>
            </table>
        </div>
        <div style="width: 455px;">
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td colspan="4" style="text-align: center;">
                        <span id="spnErrorMsg" class="ItDoseLblError"></span>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; padding-top: 10px;" align="right">From Year :&nbsp;</td>
                    <td style="width: 20%; padding-top: 10px;" align="left">
                        <select id="ddlFromYear" onchange="BindToYear()" style="width: 100px;"></select>
                    </td>
                    <td style="width: 20%; padding-top: 10px;" align="right">To Year :&nbsp;</td>
                    <td style="width: 30%; padding-top: 10px;" align="left">
                        <select id="ddlToYear" style="width: 100px;" onchange="BindFinanceYear(1)" disabled="disabled"></select>
                    </td>
                </tr>
                <tr>
                    <td style="width: 30%; padding-top: 10px;" align="right">Financial Year :&nbsp;</td>
                    <td style="padding-top: 10px;" align="left">
                        <span id="spnFinancialYear" class="ItDoseLblError"></span>
                    </td>
                    <td style="width: 20%; padding-top: 10px;" align="right">Total Year :&nbsp;</td>
                    <td style="width: 30%; padding-top: 10px;" align="left">
                        <span id="spnTotalYear" class="ItDoseLblError"></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="text-align: center;">
                        <br />
                    </td>
                </tr>
            </table>
        </div>
        <div style="text-align: center; width: 455px;">
            <input type="button" id="btnSaveFinancialYear" value="Save" onclick="SaveFinancialYear()" class="savebutton" />
        </div>
        <div id="dvFinancialYearList" style="max-height: 127px; overflow: auto;"></div>
    </asp:Panel>
</asp:Content>
