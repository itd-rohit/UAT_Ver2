function PostReport(Query, ReportName, Period, ReportPath) {
    var $form = $("<form/>").attr("id", "data_form").attr("name", "data_form").attr("action", ReportPath).attr("method", "post").attr("target", "_blank");
    $("body").append($form);AddParameter($form, "Query", Query);AddParameter($form, "ReportName", ReportName);AddParameter($form, "Period", Period);$form[0].submit();
}
function AddParameter(form, name, value) {
    var $input = $("<input />").attr("type", "hidden").attr("name", name).attr("value", value);
    form.append($input);
}
function PostReportAutoIncrement(Query, ReportName, Period, ReportPath) {
    var $form = $("<form/>").attr("id", "data_form").attr("name", "data_form").attr("action", ReportPath).attr("method", "post").attr("target", "_blank");
    $("body").append($form);AddParameter($form, "Query", Query);AddParameter($form, "ReportName", ReportName);AddParameter($form, "Period", Period);AddParameter($form, "IsAutoIncrement", "1");
    $form[0].submit();
}
function Get$Form(ReportPath)
{
  return $("<form/>").attr("id", "data_form").attr("name", "data_form").attr("action", ReportPath).attr("method", "post").attr("target", "_blank");
}
function PostQueryString($responseData, ReportPath) {
    var PostValue = [];
    $.each($responseData, function (key, value) {
        value = value.split('"').join('\"')
        PostValue.push('<input type="hidden" name="' + key + '" value="' + value + '" />');
    });
    $('<form action="' + ReportPath + '" method="POST" target="_blank">' + PostValue.join("") + '</form>').appendTo($(document.body)).submit();
}
function PostQueryStringSelf($responseData, ReportPath) {
    var PostValue = [];
    $.each($responseData, function (key, value) {
        value = value.split('"').join('\"')
        PostValue.push('<input type="hidden" name="' + key + '" value="' + value + '" />');
    });
    $('<form action="' + ReportPath + '" method="POST" >' + PostValue + '</form>').appendTo($(document.body)).submit();
}
function PostExcelReport(ReportData, ReportName, Period, ReportPath) {
    var $form = $("<form/>").attr("id", "data_form").attr("name", "data_form").attr("action", ReportPath).attr("method", "post").attr("target", "_blank");
    $("body").append($form); AddParameter($form, "ReportData", ReportData); AddParameter($form, "ReportName", ReportName); AddParameter($form, "Period", Period);
    $form[0].submit();
}
$.fn.addHiddenInput = function (key, value) {
    var $input = $('<input type="hidden" name="' + key + '" value="' + value + '" />')
    $input.val(value);
    $(this).append($input);

}
var addData = function (ReportData,keys, prefix) {
  
    for (var key in ReportData) {
        var value = ReportData[key];
        if (!prefix) {
            var nprefix = key;
        } else {
            var nprefix = prefix + '[' + key + ']';
        }
        if (typeof (value) == 'object') {
            addData(value, nprefix);
            continue;
        }
        keys[nprefix] = value;
    }
}
function PostFormData($responseData, ReportPath) {
    var PostValue = [];
 
    var $form = $("<form/>").attr("id", "data_form").attr("name", "data_form").attr("action", ReportPath).attr("method", "post").attr("target", "_blank");
    $("body").append($form);
    $.each($responseData, function (key, value) {
        AddParameter($form, key, value);

    });    
    $form[0].submit();
}