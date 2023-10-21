serverCall = function( url, data, callback, params, global, AuthorizationToken ) {
    var dParams = {};
    dParams.isReturn = false;
    if (global == null)
        global = true;
    $.extend(dParams, params);
    var ajaxCall = $.ajax({
        beforeSend: function (xhr) {
            xhr.setRequestHeader("AuthorizationToken", AuthorizationToken);
        },
        url: url,
        data: JSON.stringify(data),
        type: 'POST',
        async: true,
        isReturn: dParams.isReturn,
        dataType: 'json',
        global: global,
        contentType: 'application/json; charset=utf-8',
        success: function (response)
        { callback(response.d === undefined ? response : response.d); },
        error: function (request, status, error) {
            if (request.status != 401) {
                if (!String.isNullOrEmpty(request.responseText))
                    alert(request.responseText);
            }
            $modelUnBlockUI();
        }
    });
    if (dParams.isReturn)
        return ajaxCall;
}
$.fn.showModel = function (params) {
    this.each(function (index, elem) {
        elem.style.display = 'block';
    });
};
$.fn.closeModel = function (params) {
    this.each(function (index, elem) {
        elem.style.display = 'none';
    });
};
$.fn.openModel = function (params) {
    this.each(function (index, elem) {
        elem.style.display = 'block';
    });
};
$.fn.hideModel = function (params) {
    this.each(function (index, elem) {
        elem.style.display = 'none';
    });
};
$.fn.customFixedHeader = function (params) {
    $(this).bind('scroll', function () {
        var translate = 'translate(0,' + this.scrollTop + 'px)';
        this.querySelector('thead').style.transform = translate;
    });
};
$.fn.entireTrim = function () {
    this.forEach(function (o) {
        Object.keys(o).forEach(function (key) {
            o[key] = typeof o[key] === 'string' ? o[key].trim() : o[key];
        });
    });
};
$.fn.bindDropDown = function (params) {
    try {
        var elem = this.empty();
        if (params.defaultValue != null) {
            var defaultDataValues = 0;
            if (params.defaultDataValue != null)
                defaultDataValues = params.defaultDataValue;
            elem.append($('<option />').val(defaultDataValues).text(params.defaultValue));
        }
        $.each(params.data, function (index, data) {
            var dataAttr = {};
            if (params.dataAttr) {
                dataAttr = data;
                Object.keys(this).filter(function (i) { if (params.dataAttr.indexOf(i) < 0) { delete dataAttr[i]; } });
            }


            elem.append($(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]).attr('data-value', params.showDataValue === undefined ? "" : JSON.stringify(data)));
        });
        if (params.selectedValue != null && params.selectedValue != '' && params.selectedValue != undefined) {
            $(elem).val(params.selectedValue);

        }
        if (params.isSearchAble) {
            $(elem).chosen("destroy").chosen({ width: '100%' });
        }
    } catch (e) {
        console.error(e.stack);
    }
};
$(document).ajaxStart(function (event, jqxhr, settings) {

}).ajaxSend(function (e, xhr, opts) {
    var unBlocksURL = [
            'Common/Services/CommonServices.asmx/GetTestList',
            'Common/CommonJsonData.aspx',
            'Lab/showreading.aspx',
            'Lab/DeltaCheck.aspx',
            'CommonServices.asmx/getClientBalanceAmt',
            'CommonServices.asmx/ConvertCurrency',
            'CommonServices.asmx/GetConversionFactor',
            'CommonServices.asmx/getConvertCurrecncy',
            'CommonServices.asmx/bindPaymentMode',
            'Master/EstimateRateNew.aspx',
            'DirectGRN.aspx/SearchItem',
            'ManageApprovalStore.aspx/SearchEmployee',
    ];
    var temp = opts.url.split('/');
    var requestedURl = temp.length > 1 ? (temp[temp.length - 2] + '/' + temp[temp.length - 1].split('?')[0]) : temp[0];

    if ($.inArray(requestedURl, unBlocksURL) == -1) {
        $modelBlockUI();
    }
}).ajaxError(function (e, xhr, opts) {
    $modelUnBlockUI();
    if (xhr.status == 401) {
        modelAlert('Session Time Out !!!', function () { window.location.href = '../../Design/Default.aspx'; });
    }
    if (!opts.isReturn)
        $modelUnBlockUI();
}).ajaxSuccess(function (e, xhr, opts) {
    if (!opts.isReturn)
        $modelUnBlockUI();
}).ajaxComplete(function (e, xhr, opts) {
    if (!opts.isReturn)
        $modelUnBlockUI();
}).ajaxStop(function (e, xhr, opts) {
});
var previewCountDigit = function (e, callback) {
    $('#tooltip' + e.target.id).addClass('visible');
    $('#tooltip' + e.target.id + ' span').text('Count: ' + e.target.value.length);
    callback(e);
};
var $commonJsInit = function (callback) {
    $('input[onlyNumber]').keypress(function (e) {
        $commonJsNumberValidation(e);
    });
    $('input[onlyNumber]').keydown(function (e) {
        $commonJsPreventDotRemove(e);
    });

    $('input[onlyText]').keypress(function (e) {
        $commonJsTextValidation(e);
    });
    $('input[onlyTextNumber]').keypress(function (e) {
        $commonJsAlphaNumberValidation(e);
    });
    addModelEvent();
    callback(true);
};
var $commonJSToolTipInit = function () {
    MarcTooltips.add("[data-title]", "Count: 0", {
        position: "up", align: "left", onFocus: !0, onClick: !0
    });
};
var $commonJsTextValidation = function (e) {
    if (e.target.value.length == e.target.getAttribute('onlyText'))
        e.preventDefault();
    var inputValue = (e.which) ? e.which : e.keyCode;
    var $allowCharsCode = String.isNullOrEmpty(e.target.getAttribute('allowCharsCode')) == true ? [] : e.target.getAttribute('allowCharsCode').split(',').map(Number);
    if ($allowCharsCode.indexOf(inputValue) > -1)
        return true;
    if (inputValue == 8)
        return true;
    if (inputValue == 94 || inputValue == 96)
        e.preventDefault();
    if (inputValue == 32 && e.target.selectionStart == 0)
        e.preventDefault();
    if (!(inputValue >= 65 && inputValue <= 122) && (inputValue != 32 && inputValue != 0)) {
        e.preventDefault();
    }
};
var $commonJsAlphaNumberValidation = function (e) {
    var regex = new RegExp("^[a-zA-Z0-9\b]+$");
    if (e.target.value.length == e.target.getAttribute('onlyTextNumber'))
        e.preventDefault();
    var key = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    if (!regex.test(key))
        e.preventDefault();
};
var $commonJsNumberValidation = function (e, callback) {
    var $onlynumber = e.target.getAttribute('onlynumber');
    if (e.target.value == '0')
        e.target.value = '';
    var inputValue = (e.which) ? e.which : e.keyCode;
    if (e.target.value.length == $onlynumber && inputValue != 8 && inputValue != 0 && inputValue != 9)
        e.preventDefault();
    var $allowCharsCode = String.isNullOrEmpty(e.target.getAttribute('allowCharsCode')) == true ? [] : e.target.getAttribute('allowCharsCode').split(',').map(Number);
    if ($allowCharsCode.indexOf(inputValue) > -1)
        return true;
    if (inputValue != 8 && inputValue != 0 && inputValue != 9 && inputValue != 46 && (inputValue < 48 || inputValue > 57))
        e.preventDefault();
    var $decimalPlace = e.target.getAttribute('decimalPlace');
    var indexOfDecimal = e.target.value.indexOf('.');

    if ($decimalPlace != null) {
        
        if (indexOfDecimal != -1 && inputValue == 46)
            e.preventDefault();
        else if (indexOfDecimal != -1 && inputValue != 8 && inputValue != 0 && inputValue != 9) {
            if (e.target.selectionStart > indexOfDecimal)
                if (e.target.value.substr(e.target.value.indexOf('.') + 1, e.target.value.length).length == $decimalPlace)
                    e.preventDefault();
        }
    }
    else if (inputValue == 46)
        e.preventDefault();
    var $maxvalue = e.target.getAttribute('max-value');
    var evalue = parseFloat(e.target.value.slice(0, e.target.selectionStart) + e.key + e.target.value.slice(e.target.selectionStart + Math.abs(0)));
    if ($maxvalue != null)
        if ((evalue > parseFloat($maxvalue)))
            e.preventDefault();
        else if ((evalue == parseFloat($maxvalue)) && inputValue == 46)
            e.preventDefault();
    if ($.isFunction(callback))
        callback(e);
}
var $commonJsPreventDotRemove = function (e, callback) {
    var inputValue = (e.which) ? e.which : e.keyCode;
    if (inputValue == 46)
        e.preventDefault();
    var indexOfDecimal = e.target.value.indexOf('.');
    if (indexOfDecimal < 0) {
        if ($.isFunction(callback))
            callback(e);
        else
            return true;
    }
    var typeIndex = e.target.selectionStart;
    if (inputValue == 8 && typeIndex == (indexOfDecimal + 1) && (e.target.value.substr(indexOfDecimal + 1, e.target.value.length).length > 0)) {
        e.preventDefault();
    }
    else {
        if ($.isFunction(callback))
            callback(e);
        else
            return true;
    }
}
function addModelEvent() {
    $('div[model-target]').each(function (index, elem) {
        document.getElementById(this.getAttribute('model-target')).onclick = function () {
            elem.style.display = 'block';
        }
        this.getElementsByClassName('close')[0].onclick = function () { elem.style.display = "none"; };
    })
    $('input[type=button][data-dismiss],button[data-dismiss]').each(function (index, elem) {
        elem.onclick = function () {
            document.getElementById(this.getAttribute('data-dismiss')).style.display = 'none';
        }
    });
}
$.fn.getPropValues = function (callback) {
    var inputTextControl = $(this).find('input[type=text][prop]');
    var $modelValues = {};
    $(inputTextControl).each(function (index, elem) {
        $modelValues[this.attributes['prop'].value] = this.value;
    });
    var selectControl = $(this).find('select[prop]');
    $(selectControl).each(function (index, elem) {
        if (this.selectedIndex >= 0)
            $modelValues[this.attributes['prop'].value] = { value: this.value, text: this.options[this.selectedIndex].text };
        else
            $modelValues[this.attributes['prop'].value] = { value: '', text: '' };
    });
    var inputRadioControl = $(this).find('input[type=radio][prop]');
    $(inputRadioControl).each(function (index, elem) {
        this.checked == true ? $modelValues[this.attributes['prop'].value] = this.value : '';
    });
    callback($modelValues);
}
$.fn.setPropValues = function (params) {
    try {
        var $parentElem = this;
        var $modelValues = params.data;
        $(Object.keys($modelValues)).each(function (index, elem) {
            $($($parentElem).find('[prop=' + this + ']')).each(function () {
                if (this.type === 'text')
                    this.value = $modelValues[elem];
                if (this.type === 'select-one') {
                    this.value = $modelValues[elem];
                    if ($modelValues[elem]!==undefined)
                        this.value == '' ? $(this.options).filter(function () { return this.text == $modelValues[elem] })[0].selected = true : '';
                }
                if (this.type === 'radio')
                    this.value == $modelValues[elem] ? this.checked = true : '';
            });
        });
        if (params.success != undefined || params.success != null)
            params.success(true)
    } catch (e) {
        console.error(e.stack)
        if (params.error != undefined || params.error != null)
            params.success(false, e.stack)
    }
}
Array.prototype.unique = function () {
    var tmp = {}, out = [];
    for (var i = 0, n = this.length; i < n; ++i) {
        if (!tmp[this[i]]) { tmp[this[i]] = true; out.push(this[i]); }
    }
    return out;
}
String.isNullOrEmpty = function (value) {
    try {
        return (!value || typeof (value) == 'Object' || value == null || value == undefined || value.trim() == "" || value.length == 0);
    } catch (e) {
        return false;
    }
}
function precise_round(num, decimals) {
    return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
}
String.prototype.toCamelCase = function () {
    return this.replace(/^([A-Z])|\s(\w)/g, function (match, p1, p2, offset) {
        if (p2) return p2.toUpperCase();
        return p1.toLowerCase();
    });
};
String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
};
function modelConfirmation(headerText, message, actionButtonText, cancelButtonText, callback, data) {
    if (!data)
        data = {};
    var dialogDiv = [];
    dialogDiv.push( "<div id='alertConfirmModel' class='modal fade'><div class='modal-dialog' style='width:30%;margin-left:40%'><div style='min-width:300px' class='modal-content'>");
    if (!String.isNullOrEmpty(headerText) && !data.isAlert) {
        dialogDiv.push("<div class='modal-header'><h4 style='color:red' class='modal-title'>");
        dialogDiv.push(headerText);
        dialogDiv.push("</h4></div>");
    }
    if (!String.isNullOrEmpty(headerText) && data.isAlert) {
        dialogDiv.push("<div style='padding: 10px;' class='modal-header'><h4 style='color:red' class='modal-title'>");
        dialogDiv.push(headerText);
        dialogDiv.push("</h4></div>");
    }
    if (data.isAlert) {
        dialogDiv.push("<div style='text-align: center;padding: 0px;margin-left: 20px;margin-right: 20px;' class='modal-body'><p style='font-weight: bold;' id='alertConfirmMessage'>");
        dialogDiv.push(message); dialogDiv.push("</p></div>");
    }
    else {
        dialogDiv.push("<div style='text-align: center;margin-left: 20px;margin-right: 20px;' class='modal-body'><p style='font-weight: bold;' id='alertConfirmMessage'>");
        dialogDiv.push(message);
        dialogDiv.push("</p></div>");
    }
    if (data.isAlert)
        dialogDiv.push("<div style='text-align:center;padding: 12px;' class='modal-footer'>");
    else
        dialogDiv.push("<div style='text-align:center' class='modal-footer'>");
    if (!String.isNullOrEmpty(actionButtonText)) {
        if (data.isAlert) {
            dialogDiv.push("<input id='alertConfirmOkButtonText' style='width:65px' class='btn ItDoseButton'  type='button' value='");
            dialogDiv.push(actionButtonText);
            dialogDiv.push("'/>");
        }
        else {
            dialogDiv.push("<input id='alertConfirmOkButtonText' class='btn ItDoseButton'  type='button' value='");
            dialogDiv.push(actionButtonText);
            dialogDiv.push("'/>");
        }
    }
    if (!String.isNullOrEmpty(cancelButtonText)) {
        dialogDiv.push("<input id='alertConfirmCloseButtonText' class='btn ItDoseButton'  type='button' value='");
        dialogDiv.push(cancelButtonText);
        dialogDiv.push("'/>");
    }
    dialogDiv.push("</div></div></div></div>");
    $blockDiv = $('.blockDiv');
    $blockDiv.remove();
    var blockDiv = document.createElement('Div');
    blockDiv.id = 'blockDiv';
    blockDiv.className = 'blockDiv';
    document.body.appendChild(blockDiv);
    document.getElementById('blockDiv').innerHTML = dialogDiv.join("");
    document.getElementById('alertConfirmModel').style.display = 'block';
    (document.getElementById('alertConfirmOkButtonText') != null) ? document.getElementById('alertConfirmOkButtonText').focus() : '';
    document.getElementById('alertConfirmModel').onclick = function (e) {
        if (e.target.id === 'alertConfirmCloseButtonText') {
            document.getElementById('alertConfirmModel').style.display = 'none';
            callback(false);
        }
        else if (e.target.id === 'alertConfirmOkButtonText') {
            document.getElementById('alertConfirmModel').style.display = 'none';
            callback(true);
        }
    }
    document.body.onkeydown = function (evt) {
        var inputValue = (evt.which) ? evt.which : evt.keyCode;
        if (inputValue === 27) {
            if (document.getElementById('alertConfirmModel')!==null) {
                document.getElementById('alertConfirmModel').style.display = 'none';
                callback(false);
            }
        }
        if (inputValue === 13) {
            if (document.getElementById('alertConfirmModel')!==null) {
                //document.getElementById('alertConfirmModel').style.display = 'none';
                //callback(true);
            }
        }
    }
}
function modelAlert(message, callback) {
    modelConfirmation('Alert !!', message, 'Ok', null, function (response) {
        if (callback!==undefined)
            callback(response);
    }, { isAlert: true });
}

function modelBlock(message, callback) {
    modelConfirmation(null, message, null, null, function (response) {
        if (callback != undefined)
            callback(response);
    });
}
function requestQuerystring(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}
function makeDragAble() {
    var draggable = $('.modal-header'); //element 

    draggable.on('mousedown', function (e) {
        var dr = $('.modal-body').addClass("drag").css("cursor", "move");
        height = dr.outerHeight();
        width = dr.outerWidth();
        debugger;
        max_left = dr.parent().offset().left + dr.parent().parent().parent().width() - dr.width();
        max_top = dr.parent().offset().top + dr.parent().parent().parent().height() - dr.height();
        min_left = dr.parent().offset().left;
        min_top = dr.parent().offset().top;

        ypos = dr.offset().top + height - e.pageY,
        xpos = dr.offset().left + width - e.pageX;
        $(document.body).on('mousemove', function (e) {
            var itop = e.pageY + ypos - height;
            var ileft = e.pageX + xpos - width;

            if (dr.hasClass("drag")) {
                if (itop <= min_top) { itop = min_top; }
                if (ileft <= min_left) { ileft = min_left; }
                if (itop >= max_top) { itop = max_top; }
                if (ileft >= max_left) { ileft = max_left; }
                dr.offset({ top: itop, left: ileft });
            }
        }).on('mouseup', function (e) {
            dr.removeClass("drag");
        });
    });
}
$.fn.parseTemplate = function (data) {
    var str = (this).html();
    var _tmplCache = {}
    var err = "";
    try {
        var func = _tmplCache[str];
        if (!func) {
            var strFunc =
            "var p=[],print=function(){p.push.apply(p,arguments);};" +
                        "with(obj){p.push('" +
            str.replace(/[\r\t\n]/g, " ")
               .replace(/'(?=[^#]*#>)/g, "\t")
               .split("'").join("\\'")
               .split("\t").join("'")
               .replace(/<#=(.+?)#>/g, "',$1,'")
               .split("<#").join("');")
               .split("#>").join("p.push('")
               + "');}return p.join('');";

            //alert(strFunc);
            func = new Function("obj", strFunc);
            _tmplCache[str] = func;
        }
        return func(data);
    } catch (e) { err = e.message; }
    return "< # ERROR: " + err.toString() + " # >";
}
var $modelBlockUI = function () {
    var loader = '<img id="imgCustomJSLoader" style="width:100px;height:100px" alt="loading...." src="data:image/gif;base64,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">';

    var dialogDiv = [];
    dialogDiv.push("<div id='modelBlockUI' style='padding-top: 215px;' class='modal fade'><div class='modal-dialog'><div style='width: 250px;margin: 0 auto;' class=''>");
    dialogDiv.push("<div style='text-align: center;color: red' class='modal-body'><p style='font-weight: bold;' >");
    dialogDiv.push(loader); dialogDiv.push("</p></div>");
    dialogDiv.push("</div></div></div>");
    $blockDiv = $('.blockDiv');
    $blockDiv.remove();
    var blockDiv = document.createElement('Div');
    blockDiv.id = 'blockDiv';
    blockDiv.className = 'blockDiv';
    document.body.appendChild(blockDiv);
    document.getElementById('blockDiv').innerHTML = dialogDiv.join("");
    document.getElementById('modelBlockUI').style.display = 'block';
}
var $modelUnBlockUI = function () {
    try {
        document.getElementById('modelBlockUI').style.display = 'none';
        $blockDiv = $('.blockDiv');
        $blockDiv.remove();
    } catch (e) {

    }
}
$toggleWindow = function (elem) {
    if ((document.fullScreenElement && document.fullScreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) {
        if (document.documentElement.requestFullScreen) {
            document.documentElement.requestFullScreen();
        } else if (document.documentElement.mozRequestFullScreen) {
            document.documentElement.mozRequestFullScreen();
        } else if (document.documentElement.webkitRequestFullScreen) {
            document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    } else {
        if (document.cancelFullScreen) {
            document.cancelFullScreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        }
    }
}
var _toggleWindow = function (_document) {
    if ((_document.fullScreenElement && _document.fullScreenElement !== null) || (!_document.mozFullScreen && !_document.webkitIsFullScreen)) {
        if (_document.documentElement.requestFullScreen) {
            _document.documentElement.requestFullScreen();
        } else if (_document.documentElement.mozRequestFullScreen) {
            _document.documentElement.mozRequestFullScreen();
        } else if (_document.documentElement.webkitRequestFullScreen) {
            _document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    } else {
        if (_document.cancelFullScreen) {
            _document.cancelFullScreen();
        } else if (_document.mozCancelFullScreen) {
            _document.mozCancelFullScreen();
        } else if (_document.webkitCancelFullScreen) {
            _document.webkitCancelFullScreen();
        }
    }
}
var toastOptions = {
    "closeButton": true,
    "debug": false,
    "newestOnTop": true,
    "progressBar": true,
    "positionClass": "toast-top-center",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "2000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
};
var toastOptionsNotification = {
  "closeButton": false,
  "debug": false,
  "newestOnTop": false,
  "progressBar": true,
  "positionClass": "toast-bottom-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
};
function toast(ErrorType, displayMessage, title) {
    toastr.clear();
    if (ErrorType === "Error")
        var notify = toastr.error(title, displayMessage, toastOptions);
    else if (ErrorType === "Success")
        var notify = toastr.success(title, displayMessage, toastOptions);
    else if (ErrorType === "Info")
        var notify = toastr.info(title, displayMessage, toastOptions);
    else if (ErrorType === "Warning")
        var notify = toastr.warning(title, displayMessage, toastOptions);
    var $notifyContainer = $('#toast-container').closest('.toast-top-center');
    if ($notifyContainer) {
        var windowHeight = $(window).height() - 90;
        $notifyContainer.css("margin-top", windowHeight / 2);
    }
};
function toastNotification(ErrorType, displayMessage, title) {
    toastr.clear();
    if (ErrorType === "Error")
        var notify = toastr.error(title, displayMessage, toastOptionsNotification);
    else if (ErrorType === "Success")
        var notify = toastr.success(title, displayMessage, toastOptionsNotification);
    else if (ErrorType === "Info")
        var notify = toastr.info(title, displayMessage, toastOptionsNotification);
    else if (ErrorType === "Warning")
        var notify = toastr.warning(title, displayMessage, toastOptionsNotification);
    var $notifyContainer = $('#toast-container').closest('.toast-top-center');
    if ($notifyContainer) {
        var windowHeight = $(window).height() - 90;
        $notifyContainer.css("margin-top", windowHeight / 2);
    }
};
var addShortCutOptions = { 'type': 'keydown', 'propagate': true, 'target': document };
$(function ($) {
    $commonJsInit(function () {
        try {
            shortcut.add("Enter", function () {
                if (document.activeElement.tagName === 'button' || document.activeElement.type === 'button' || document.activeElement.type === 'submit')
                    $(document.activeElement);//.click();
            }, addShortCutOptions);
        } catch (e) {
        }
    });
});
(function ($) {
    $.fn.progressbar = function (options) {
        var opts = $.extend({}, options);
        return this.each(function () {
            var $this = $(this);
            var $ul = $('<ul>').attr('class', 'progressbar');
            var currentIdx = -1
            $.each(opts.steps, function (index, value) {
                var $li = $('<li>').html(value.replace('@', '').replace('~', ''));
                $li.css('width', (100 / opts.steps.length) - 1 + '%');
                if (value.indexOf('@') > -1) {
                    $li.addClass('current');
                    currentIdx = index;
                }
                if (value.indexOf('~') > -1) {
                    $li.addClass('fail');
                }
                $ul.append($li);
            });
            for (var i = 0; i < currentIdx; i++) {
                $($ul.find('li')[i]).addClass('done');
            }
            $this.append($ul);
        });
    };
})(jQuery);
$.fn.bindListBox = function (params) {
    try {
        var elem = this.empty();    
        $.each(params.data, function (index, data) {
            var dataAttr = {};
            if (params.dataAttr) {
                dataAttr = data;
                Object.keys(this).filter(function (i) { if (params.dataAttr.indexOf(i) < 0) { delete dataAttr[i]; } });
            }
            elem.append($(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]));
        });             
    } catch (e) {
        console.error(e.stack);
    }
};
$encryptQueryStringData = function (encryptText, callback) {
    if (encryptText != "") {
        serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: encryptText.trim() }, function (response) {
            callback(response);
        });
    }
}
$fancyBoxOpen = function (href) {
    jQuery.fancybox({
        fitToView: true,
        href: href,
        autoSize: true,
        closeClick: false,
        openEffect: 'none',
        closeEffect: 'none',
        'type': 'iframe'
    }
);
};
$.fn.bindMultipleSelect = function (params) {
    try {
        var elem = this.empty();
        if (params.isClearControl != null) {
            params.controlID.empty();
            params.controlID.multipleSelect("refresh");
        }
        if (params.defaultValue != null) {
            var defaultDataValues = 0;
            if (params.defaultDataValue != null)
                defaultDataValues = params.defaultDataValue;
            elem.append($('<option />').val(defaultDataValues).text(params.defaultValue));
        }

        $.each(params.data, function (index, data) {
            var dataAttr = {};
            var option = $(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]).attr('data-value', params.showDataValue === undefined ? "" : JSON.stringify(data));
            $(params.customAttr).each(function (i, d) { $(option).attr(d, data[d]); });
            elem.append(option);

        });


        if (params.selectedValue != null && params.selectedValue != '' && params.selectedValue != undefined) {
            $(elem).val(params.selectedValue);

        }
        params.controlID.multipleSelect({
            includeSelectAllOption: true,
            filter: true, keepOpen: false
        });
    } catch (e) {
        console.error(e.stack);
    }
};
var alphabetsArray = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];


var $modelBlockUIMaster = function () {
    var loader = '<img id="imgCustomJSLoaderMaster" style="width:100px;height:100px" alt="loading...." src="../App_Images/loader.gif">';
    var dialogDivMaster = [];
    dialogDivMaster.push("<div id='modelBlockUIMaster' style='padding-top: 215px;' class='modal fade'><div class='modal-dialog'><div style='width: 250px;margin: 0 auto;' class=''>");
    dialogDivMaster.push("<div style='text-align: center;color: red' class='modal-body'><p style='font-weight: bold;' >");
    dialogDivMaster.push(loader); dialogDivMaster.push("</p></div>");
    dialogDivMaster.push("</div></div></div>");
    $blockDivMaster = $('.blockDivMaster');
    $blockDivMaster.remove();
    var blockDivMaster = document.createElement('Div');
    blockDivMaster.id = 'blockDivMaster';
    blockDivMaster.className = 'blockDivMaster';
    document.body.appendChild(blockDivMaster);
    document.getElementById('blockDivMaster').innerHTML = dialogDivMaster.join("");
    document.getElementById('modelBlockUIMaster').style.display = 'block';
}
var $modelUnBlockUIMaster = function () {
    try {
        document.getElementById('modelBlockUIMaster').style.display = 'none';
        $blockDivMaster = $('.blockDivMaster');
        $blockDivMaster.remove();
    } catch (e) {

    }
}


