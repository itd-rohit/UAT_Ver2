jQuery(function () {
    $('#imglogout').click(function (e) {
        e.preventDefault();
        signOutConfirmation(function () { });
    });
    bindMarkAsDefault();
    $('ul.submenus').hide();
    $('.mainMenu .has-sub .mainMenuAnchor').click(function () {
        $(this).next().toggle('fast');
    });
    $('li').click(function (event) {
        event.stopPropagation();
    });
    $('#sidebar-wrapper .sidebar-nav').slimScroll({
        height: '100%',
        width: '100%',
        color: 'black',
    });

    $('.popup-container').slimScroll({
        height: '400px',
        width: '100%',
        color: 'black',
    });
    $('form').click(function () {
        $('#wrapper').removeClass("toggled");
    });
    $commonJSToolTipInit(function () { });
    shortcut.add("Ctrl+D", function () {
        $showRoleModel();
    });
});
var bindMarkAsDefault = function () {
    $('.liRoleDeaprtments').each(function () {
        var array = [['Set As Default', 'markRoleAsDefault(' + this.id + ')']];
        class2context(this.className, 'Menu', array);
    });
}
var browser = whichBrs();
if (browser === 'Internet Explorer') {
    document.onkeydown = function () { return !shouldCancelBackspace(event); }
}
// Every single key press action will call this function.
function shouldCancelBackspace(e) {
    var key;
    if (e) {
        key = e.which ? e.which : e.keyCode;

        if (key == null || (key != 8 && key != 13)) {
            // return when the key is not backspace key. 
            return false;
        }
    }
    else {
        return false;
    }

    if (e.srcElement) {
        // in IE
        tag = e.srcElement.tagName.toUpperCase();
        type = e.srcElement.type;
        readOnly = e.srcElement.readOnly;

        if (type == null) {
            // Type is null means the mouse focus on a non-form field. Disable backspace button
            return true;
        } else {
            type = e.srcElement.type.toUpperCase();
        }

    }
    else {
        // in FF
        tag = e.target.nodeName.toUpperCase();
        type = (e.target.type) ? e.target.type.toUpperCase() : "";
    }
    // we don't want to cancel the keypress (ever) if we are in an input/text area
    if (tag == 'INPUT' || type == 'TEXT' || type == 'TEXTAREA') {
        if (readOnly == true) // if the field has been dsabled, disbale the back space button
            return true;
        if (((tag == 'INPUT' && type == 'RADIO') || (tag == 'INPUT' && type == 'CHECKBOX')) && (key == 8 || key == 13)) {
            return true; // the mouse is on the radio button/checkbox, disbale the backspace button
        }
        return false;
    }
    // if we are not in one of the above things, then we want to cancel (true) if backspace
    return (key == 8 || key == 13);
}
function whichBrs() {
    var agt = navigator.userAgent.toLowerCase();
    if (agt.indexOf("opera") != -1) return 'Opera';
    if (agt.indexOf("staroffice") != -1) return 'Star Office';
    if (agt.indexOf("webtv") != -1) return 'WebTV';
    if (agt.indexOf("beonex") != -1) return 'Beonex';
    if (agt.indexOf("chimera") != -1) return 'Chimera';
    if (agt.indexOf("netpositive") != -1) return 'NetPositive';
    if (agt.indexOf("phoenix") != -1) return 'Phoenix';
    if (agt.indexOf("firefox") != -1) return 'Firefox';
    if (agt.indexOf("safari") != -1) return 'Safari';
    if (agt.indexOf("skipstone") != -1) return 'SkipStone';
    if (agt.indexOf("msie") != -1) return 'Internet Explorer';
    if (agt.indexOf("netscape") != -1) return 'Netscape';
    if (agt.indexOf("mozilla/5.0") != -1) return 'Mozilla';

    if (agt.indexOf('\/') != -1) {
        if (agt.substr(0, agt.indexOf('\/')) != 'mozilla') {
            return navigator.userAgent.substr(0, agt.indexOf('\/'));
        } else
            return 'Netscape';
    } else if (agt.indexOf(' ') != -1)
        return navigator.userAgent.substr(0, agt.indexOf(' '));
    else
        return navigator.userAgent;
}
window.history.forward();

function showLISMenu(e) {
    var wrapper = $('#wrapper');
    var className = 'toggled';

    wrapper.toggleClass(className);
    if (!wrapper.hasClass(className))
        $('ul.submenus').hide();
    //    $(e.target).attr('data-title', 'Click To Close Menu');
    //else
    //    $(e.target).attr('data-title', 'Click To Open Menu');
    e.stopPropagation();
}

$showRoleModel = function () {
    var divRoleModel = $('#divRoleModel');
    divRoleModel.showModel();
    divRoleModel.find('.chosen-search-input').val('').focus()
};

var searchRole = function (e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    var sortedRoles = [];
    if (e.target.value.length >= 1)
        sortedRoles = $('.popup-container').find("ul li").hide().find("a p:contains('" + e.target.value.toUpperCase() + "')").closest('li').show();
    else
        $('.popup-container').find("ul li").show()


    if (code == 13) {
        if (sortedRoles.length > 0) {
            eval($(sortedRoles[0]).find('a').attr('href'));
        }
    }
}
function signOutConfirmation() {
    modelConfirmation('Sign Out Confirmation ?', 'Are you Sure To Sign Out ?', 'Continue', 'Cancel', function (response) {
        if (response)
            __doPostBack('ctl00$imglogout', '');
    });
}