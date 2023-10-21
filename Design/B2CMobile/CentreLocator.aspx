<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="CentreLocator.aspx.cs" Inherits="Design_Master_CentreLocator" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <style type="text/css">
        .webstyle1 {
            width: 150px;
        }

        .webstyle2 {
            width: 156px;
        }

        .jscoin-tabs ul li a {
            background-color: whitesmoke;
            color: black;
        }
    </style>
    <style type="text/css">
        .jscoin-tabs ul.menu > li {
            display: block;
            float: left;
        }
        .jscoin-tabs ul.menu li > a {
            color: #000;
            text-decoration: none;
            display: block;
            text-align: center;
            border: 1px solid #808080;
            padding: 5px 10px 5px 10px;
            margin-right: 5px;
            border-top-left-radius: 5px;
            -moz-border-radius-topleft: 4px;
            -webkit-border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            -moz-border-radius-topright: 4px;
            -webkit-border-top-right-radius: 5px;
            -moz-user-select: none;
            cursor: pointer;
        }

        .jscoin-tabs ul.menu li > div {
            display: none;
            position: absolute;
            width: 100%;
            left: 0;
            margin: -1px 0 0 0;
            z-index: -1;
            text-align: left;
            padding: 0;
        }

            .jscoin-tabs ul.menu li > div > p {
                border: 1px solid #808080;
                padding: 10px;
                margin: 0;
            }

        .jscoin-tabs ul.menu li > a:focus {
            border-bottom: 1px solid #fff;
        }

        .jscoin-tabs ul.menu li:target > a {
            cursor: default;
            border-bottom: 1px solid #fff;
        }

        .jscoin-tabs ul.menu li:target > div {
            display: block;
        }
    </style>
</head>
<body style="margin-top: -42px;">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
                <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory" >
            <div class="POuter_Box_Inventory" >
                <div class="content">
                    <div style="text-align: center;">
                        <b>Centre Master<br />
                        </b>
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" runat="server">Centre Locator</div>
                <div style="max-height: 500px; ">
                    <div class="row">
                        <div class="col-md-7">
                            <fieldset class="f1" style="width: 97%; Height: 410px">
                                <legend style="font-weight: bold; vertical-align: top" class="lgd">Search Center</legend>
                                Search By 
                                <input type="radio" checked="checked" name="chkSearchType" value="1" />Name
                            <input type="radio" name="chkSearchType" value="2" />ID
                            <input type="radio" name="chkSearchType" value="3" />Code                                    
                               <asp:DropDownList ID="ddltype4" runat="server" Width="275px" CssClass="ddltype4 chosen-select" Visible="false" onchange="BindList()" disabled="true">
                                   <asp:ListItem Value="Type"> </asp:ListItem>
                                   <asp:ListItem Value="1" Selected="True">Processing Lab</asp:ListItem>
                                   <asp:ListItem Value="2">HUB</asp:ListItem>
                               </asp:DropDownList>
                                <input type="checkbox" id="chkal" onclick="BindList()" /><label for="chkal"> AllowApp</label>
                                <br />
                                <br />
                                <asp:TextBox ID="txtserch" runat="server" Width="94%" placeholder="Search Centre" OnKeyUp="Click(this);"></asp:TextBox>
                                <br />
                                <asp:ListBox ID="ListBox2" runat="server" Style="display: none;"></asp:ListBox>
                                <asp:ListBox ID="listcentre" runat="server" class="navList" onChange="loadDetail(this.value);"
                                    Width="96%" Height="320px"></asp:ListBox>
                            </fieldset>
                        </div>
                        <div class="col-md-1"></div>
                        <div class="col-md-17">
                            <fieldset class="f1" style="width: 97%; Height: 410px">
                                <legend class="lgd" style="font-weight: bold">Update Centre Location</legend>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Centre  </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <b>
                                            <label id="centrename"></label>
                                        </b>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Centre Code </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <b>
                                            <label id="CentreCode"></label>
                                        </b>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Centre ID </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <b>
                                            <label id="Centreid"></label>
                                        </b>
                                    </div>
                                </div>


                                <div class="row">
                                    <div id="Div3" class="Purchaseheader" runat="server">
                                        Centre Location Detail
                                    </div>
                                </div>


                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">GeoLocation </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtGeoLocation" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Mobile (M) </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtMobile" MaxLength="10" runat="server"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" TargetControlID="txtMobile"></cc1:FilteredTextBoxExtender>

                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Mobile (W) </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtWhatsappMobile" MaxLength="10" runat="server"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txtWhatsappMobile"></cc1:FilteredTextBoxExtender>

                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">Allow App </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:DropDownList ID="ddlAlloapp" runat="server" CssClass="ddllocality chosen-select">
                                            <asp:ListItem Value="1">Yes</asp:ListItem>
                                            <asp:ListItem Value="0">No</asp:ListItem>
                                        </asp:DropDownList>

                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Latitude </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtLatitude" runat="server" CssClass="webstyle1"></asp:TextBox>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left">Longitude </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <asp:TextBox ID="txtLongitude" runat="server" CssClass="webstyle1"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="row" style="text-align: center">
                                    <%--<input type="button" value="Save" class="savebutton" id="btnsave" style="display: none; margin-top: 110PX;" onclick="SaveNewCentre()" />--%>

                                    <input type="button" value="Update" class="savebutton" id="btnupdate" style="display: none; margin-top: 50PX; width: 120px" onclick="UpdateCentre()" />

                                </div>
                            </fieldset>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <script type="text/javascript">
            jQuery(function () {
                var config = {
                    '.chosen-select': {},
                    '.chosen-select-deselect': { allow_single_deselect: true },
                    '.chosen-select-no-single': { disable_search_threshold: 10 },
                    '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                    '.chosen-select-width': { width: "80%" }
                }
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
            });
            $('.ui-layout-toggler-north').click(function () {
                $('#chosen_select').toggleClass('hide');
            });
        </script>
        <script type="text/javascript">
            var _CentreID = "";
            $(document).ready(function () {
                BindList();
            });
            function chkNew() {
                if ($('#chkNewInv').is(':checked')) {
                    $('#btnsave').show();
                    $("#<%=txtserch.ClientID %>").attr('disabled', $("#chkNewInv").attr('checked'));
                    $("#<%=listcentre.ClientID %>").attr('disabled', $("#chkNewInv").attr('checked'));
                    $("#<%=ddltype4.ClientID %>").attr('disabled', $("#chkNewInv").attr('checked'));
                }
                else {
                    $('#btnsave').hide();
                    $("#<%=txtserch.ClientID %>").removeAttr('disabled', $("#chkNewInv").attr('checked'));
                $("#<%=listcentre.ClientID %>").removeAttr('disabled', $("#chkNewInv").attr('checked'));
                    $("#<%=ddltype4.ClientID %>").removeAttr('disabled', $("#chkNewInv").attr('checked'));
                }
            }
            function Call(chk) {
                var Url = chk.id + '?CentreID=' + _CentreID.split('$')[0];
                window.open(Url, null, "");
                return false;
            }
            function loadDetail(val) {
                try {
                    val = val.split('$')[0];
                }
                catch (e) {
                    val = val;
                }

                serverCall('CentreLocator.aspx/getdata', { centreid: val }, function (response) {

                    PanelData = jQuery.parseJSON(response);
                    clearform();
                    _CentreID = val;
                    $('#centrename').text(PanelData[0].centre);
                    $('#CentreCode').text(PanelData[0].CentreCode);
                    $('#Centreid').text(PanelData[0].CentreID);
                    $('#<%=txtMobile.ClientID%>').val(PanelData[0].Mobile);
                $('#<%=txtWhatsappMobile.ClientID%>').val(PanelData[0].WhatsAppNo);
                $('#<%=txtLatitude.ClientID%>').val(PanelData[0].Latitude);
                $('#<%=txtLongitude.ClientID%>').val(PanelData[0].Longitude);
                $('#<%=txtGeoLocation.ClientID%>').val(PanelData[0].GeoLocation);
                $('#<%=ddlAlloapp.ClientID%>').val(PanelData[0].AllowApp).chosen('destroy').chosen()

                var CentreID = PanelData[0].CentreID;
                $("#btnupdate").show();

            });
        }
        function clearform() {
            $('#<%=txtMobile.ClientID%>').val('');
            $('#<%=txtWhatsappMobile.ClientID%>').val('');
            $('#<%=txtLatitude.ClientID%>').val('');
            $('#<%=txtLongitude.ClientID%>').val('');
            $('#<%=txtGeoLocation.ClientID%>').val('');
        }
        function UpdateCentre() {
            $('#<%=lblMsg.ClientID%>').html('');
            var chisopdipd = "0";
            serverCall('CentreLocator.aspx/UpdateCentre', { CentreId: _CentreID, MobileNo: $('#<%=txtMobile.ClientID%>').val(), WhatsAppMobileNo: $('#<%=txtWhatsappMobile.ClientID%>').val(), GeoLocation: $('#<%=txtGeoLocation.ClientID%>').val(), Latitude: $('#<%=txtLatitude.ClientID%>').val(), Longitude: $('#<%=txtLongitude.ClientID%>').val(), AllowApp: $('#<%=ddlAlloapp.ClientID%>').val() }, function (response) {

                if (response == "1") {
                    toast("Success", "Record updated SuccessFully", "");
                    window.location.reload();
                }
                else {
                    toast("Error", result, "");

                }

            });
        }
        function BindList() {
            $('#<%=listcentre.ClientID %> option').remove();
            var _listcentre = $('#<%=listcentre.ClientID %>');
            var allowapp = '0';
            if ($("#chkal").prop('checked'))
                var allowapp = '1';
            serverCall('CentreLocator.aspx/BindList', { allowapp: allowapp }, function (response) {
                if (JSON.parse(response).length == 0) {
                    _listcentre.append($("<option></option>").val("0").html("--No Data Found--"));
                    _listcentre.trigger('chosen:updated');
                }
                else
                    _listcentre.bindDropDown({ defaultValue: 'Select ', data: JSON.parse(response), valueField: 'centreid', textField: 'centre', isSearchAble: true });



            });
        }
        </script>
        <script type="text/javascript">
            var keys = [];
            var values = [];
            function DoListBoxFilter(listBoxSelector, filter, keys, values) {
                var list = $(listBoxSelector);
                keys = [];
                values = [];
                var SerchType = $("input[@name='chkSearchType']:checked").val();

                var options = $('#<% =ListBox2.ClientID %> option');
                $.each(options, function (index, item) {
                    keys.push(item.value);
                    values.push(item.innerHTML);
                });
                var selectBase = '<option value="{0}">{1}</option>';
                list.empty();
                for (i = 0; i < values.length; ++i) {
                    var value = "";
                    if (SerchType == "1") {
                        value = values[i].toLowerCase();
                    }
                    else if (SerchType == "2") {
                        var keysArray = keys[i].split('$');
                        value = keysArray[0];
                    }
                    else {
                        var keysArray = keys[i].split('$');
                        value = keysArray[1];
                    }
                    var temp = "";
                    if (value.toLowerCase().indexOf(filter.toLowerCase()) >= 0) {
                        temp = '<option value="' + keys[i] + '">' + values[i] + '</option>';
                        list.append(temp);
                    }
                }
            }
            function Click(ctr) {
                var filter = $(ctr).val().toLowerCase();
                DoListBoxFilter('.navList', filter, keys, values);
            }
        </script>

    </form>
</body>
</html>
