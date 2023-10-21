<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CallCentreQuestion.aspx.cs" Inherits="Design_CallCenter_CallCentreQuestion" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <style type="text/css">
        #callCategoryType {
            height: 30px;
            width: 175px;
        }

        #header {
            border-top: darkblue;
            border-left: darkblue;
            border-right: darkblue;
            height: 27px;
            width: 355px;
        }

        .cateTextbox {
            border-top: darkblue;
            border-left: darkblue;
            border-right: darkblue;
            height: 20px;
            width: 300px;
        }

        /*.catetype {
            width: 18px;height: 18px;
        }*/

        #headertable {
            margin-left: 100px;
        }

        #bindcategory {
            margin-left: 100px;
        }

        .categorytypeselect {
            width: 20px;
        }

        #btnSave {
            margin-left: 100px;
        }
    </style>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 1000px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 995px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td align="center" colspan="8">
                            <asp:Label ID="llheader" runat="server" Text="Feed Back Question Master" Font-Size="20px" Font-Bold="true"></asp:Label>
                            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="div_Patientinfo">
            <div class="POuter_Box_Inventory" style="width: 995px;">
                <div class="content">
                    <div class="Purchaseheader">
                        Create New Question
                    </div>
                </div>
                <table id="headertable">
                    <tr>
                        <td style="font-weight: bold;">Question</td>
                        <td>
                            <input type="text" id="header" placeholder="Write Question" />
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">Answer Type</td>
                        <td>
                            <select id="callCategoryType" onchange="refreshcategory();">
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold;">Tagged</td>
                        <td>
                            <table>
                                <thead>
                                    <tr style="color: black;">
                                        <td width="30px;">
                                            <input type="checkbox" style="width: 18px; height: 18px;" class="ads_Checkbox" name="callcenterchkbox" value="0" />
                                        </td>
                                        <td width="40px;">
                                            <strong style="font-size: 15px;" id="Strong1">Patient</strong>
                                        </td>
                                        <td width="40px;" align="right">
                                            <input type="checkbox" style="width: 18px; height: 18px;" class="ads_Checkbox" name="callcenterchkbox" value="1" />
                                        </td>
                                        <td width="40px"><strong style="font-size: 15px;">Doctor</strong></td>
                                        <td width="40px" align="right">
                                            <input type="checkbox" style="width: 18px; height: 18px;" class="ads_Checkbox" name="callcenterchkbox" value="2" />
                                        </td>
                                        <td width="40px;"><strong style="font-size: 15px;">PUP</strong>   </td>
                                        <td width="40px;" align="right">
                                            <input type="checkbox" style="width: 18px; height: 18px;" class="ads_Checkbox" name="callcenterchkbox" value="3" />
                                        </td>
                                        <td><strong style="font-size: 15px;">PCC</strong>   </td>
                                    </tr>
                                </thead>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="button" onclick="addCategory()" value="Add" class="btn btn-info" />
                        </td>
                    </tr>
                </table>
                <table id="bindcategory">
                    <tbody id="adddcat">
                    </tbody>
                    <tbody id="addLinearSearch"></tbody>
                </table>
                <table>
                    <tr>
                        <td>
                            <input id="btnSave" type="button" value="Save" class="searchbutton" onclick="SaveQuestion();" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 995px;">
            <table>
                <thead>
                    <tr style="color: black;">
                        <td width="30px;">
                            <input type="radio" style="width: 18px; height: 18px;" onclick="ChangeCallBy();" checked="checked" name="callcenterRadio" value="0" />
                        </td>
                        <td width="40px;">
                            <strong style="font-size: 15px;" id="patient">Patient</strong>

                        </td>
                        <td width="40px;" align="right">
                            <input type="radio" style="width: 18px; height: 18px;" onclick="ChangeCallBy();" name="callcenterRadio" value="1" />
                        </td>
                        <td width="40px"><strong style="font-size: 15px;">Doctor</strong></td>
                        <td width="40px" align="right">
                            <input type="radio" style="width: 18px; height: 18px;" onclick="ChangeCallBy();" name="callcenterRadio" value="2" />
                        </td>
                        <td width="40px;"><strong style="font-size: 15px;">PUP</strong>   </td>
                        <td width="40px;" align="right">
                            <input type="radio" style="width: 18px; height: 18px;" onclick="ChangeCallBy();" name="callcenterRadio" value="3" />
                        </td>
                        <td><strong style="font-size: 15px;">PCC</strong>   </td>
                    </tr>
                </thead>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 995px;">
            <div class="content">
                <div class="Purchaseheader">
                    FeedBack Option
                </div>
                <table>
                    <tbody id="feedbackId">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            BindCateDropDown();
            var radioselect = $('input[name=callcenterRadio]:checked').val();
            BindFeedBack(radioselect);
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        });
        function BindCateDropDown() {
            $.ajax({
                type: "POST",
                url: "CallCentreQuestion.aspx/BindCateDropDown",
                data: '{}',
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                Asyc: false,
                success: function (result) {
                    var ResultData = $.parseJSON(result.d);
                    $('#callCategoryType').append($("<option></option>").val("0").html("---select---"));
                    if (ResultData.length > 0) {
                        for (var i = 0; i < ResultData.length; i++) {
                            $('#callCategoryType').append('<option value="' + ResultData[i].Category_Type + '">' + ResultData[i].Category + '</option>');
                        }
                    }
                    else {
                        showerrormsg("No record found");
                    }
                }
            });
        }
        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        var si = 1;
        function addCategory() {
            if ($('#callCategoryType').val() == "radio1") {
                var selectCate = $('#callCategoryType :selected').val();
                if (selectCate != "0") {
                    $('#addLinearSearch').html('');
                    $('#addLinearSearch').append('<tr>' +
                        '<td><select id="lennearsc1"><option value="0">0</option><option value="1">1</option></select></td>' +
                        '<td><select id="lennearsc2"><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option></select></td>' +
                        '');
                }
                else {
                    showerrormsg("Please select Category");
                }
            }
            else {
                var s = si++;
                var selectCate = $('#callCategoryType :selected').val();
                if (selectCate != "0") {
                    $('#adddcat').append('<tr class="adddesigtr"><td class="categorytypeselect"><input placeholder="' + (selectCate == 'select' ? s : 'Short answer text') + '" disabled="disabled" class="catetype"  style="' + (selectCate == "text" ? "border-top: darkblue;border-left: darkblue;border-right: darkblue;height: 20px;width: 300px;" : "width: 18px;height: 18px;") + '" type="' + selectCate + '"/></td><td class="cetgoryTypeName"><input placeholder="Option" class="cateTextbox" style="' + (selectCate == "text" ? "display:none" : "display:block") + '" type="text"/></td><td><span style="cursor:pointer;" onclick="DeleteRow(this);">Delete</span></td></tr>');
                }
                else {
                    showerrormsg("Please select Category");
                }
            }
        }
        function refreshcategory() {
            $('#adddcat').html('');
            $('#addLinearSearch').html('');
        }
        function SaveQuestion() {
            var final = '';
            $('.ads_Checkbox:checked').each(function () {
                var values = $(this).val() + ",";
                final += values;
            });
            var checkbocselect = final.substring(0, final.length - 1);
            if (checkbocselect == "") {
                showerrormsg("please select tagged");
                return;
            }
            var question = $('#header').val();
            var category = $('#callCategoryType').val();
            var data = [];
            var typename = "";
            var type = "";
            if (category == "radio1") {
                type = $('#lennearsc1').val() + "#";
                typename = $('#lennearsc2').val() + "#";
            }
            else {
                $("#adddcat").find('tr').each(function (rowIndex, r) {
                    //var cols = {};
                    //cols.Type = $(this).find(".catetype").attr('type');
                    //cols.Name = $(this).find(".cateTextbox").val();
                    //data.push(cols);
                    type = type + $(this).find(".catetype").attr('type') + "#";
                    typename = typename + $(this).find(".cateTextbox").val() + "#";
                });
            }
            if (question == "") {
                showerrormsg("Please wrtie feedback  question");
                return false;
            }
            if (category == "0") {
                showerrormsg("Please select category");
                return false;
            }
            if (type == "" || typename == "") {
                showerrormsg("Please add feedback option");
                return false;
            }
            $('#btnSave').attr('disabled', 'disabled').val('Submiting...');
            $.ajax({
                url: "../CallCenter/Services/OldPatientData.asmx/SaveData",
                data: JSON.stringify({ checkbocselect: checkbocselect, question: question, category: category, Type: type.substring(0, type.length - 1), TypeName: typename.substring(0, typename.length - 1) }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Successfully saved");
                        refreshcategory();
                        $('#header').val('');
                        $('#callCategoryType').val(0);
                        $('#btnSave').attr('disabled', false).val("Save");
                        ChangeCallBy();
                    }
                    if (result.d == "0") {
                        showerrormsg("Reocrd not saved");
                    }
                },
                error: function (xhr, status) {
                    // alert('Error!!!');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function DeleteRow(btndel) {
            if (typeof (btndel) == "object") {
                $(btndel).closest("tr").remove();
            } else {
                return false;
            }
        }
        function BindFeedBack(callBy) {
            var request = { callType: callBy };
            $.ajax({
                type: "POST",
                url: "FeedBackForm.aspx/GetFeedBackData",
                data: JSON.stringify(request),
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                Asyc: false,
                success: function (result) {
                    $('#feedbackId').html('');
                    var ResultData = $.parseJSON(result.d);
                    if (ResultData.length > 0) {
                        $('#feedbackId').html('');
                        for (var i = 0; i < ResultData.length; i++) {
                            // console.log("*" + ResultData[i].ID);
                            if (ResultData[i].CallType == callBy) {
                                $('#feedbackId').append('<tr>' +
                                    '<td class="fdId" style="display:none;">' + ResultData[i].ID + '</td><td class="QuestionAnswer"><b>' + ResultData[i].Question + '</b><span  onclick="DeleteFeedBack(' + ResultData[i].ID + ')" style="margin-left: 10px;cursor:pointer;"><img  src="../../App_Images/Delete.gif"/></span></td>' +
                                '</tr>');
                                var TypeName = ResultData[i].TypeName.split("#");
                                var Type = ResultData[i].Type.split("#");
                                var ID = ResultData[i].ID;
                                if (ResultData[i].Category == "radio1") {
                                    $('#feedbackId').append('<table><tr id="bindLeneardata_' + ID + '"></tr></table>');
                                    for (var k = parseInt(Type[0]) ; k <= parseInt(TypeName[0]) ; k++) {
                                        $('#bindLeneardata_' + ID).append('<td><span style="font-weight: bold;margin-left: 9px;">' + k + '</span><br/><input name="' + ResultData[i].ID + '" style="width: 18px;height: 18px;" disabled="disabled" type="radio" value="' + Type[0] + '-' + TypeName[0] + '/' + k + '" class="fl" /></td>');
                                    }
                                }
                                else {
                                    if (Type[0] == "select") {
                                        $('#feedbackId').append('<tr><td><select id="fl_' + ID + '" class="fl" style="width:180px;height:25px;"><option value="Choose">---Choose---</option></select></td></tr>');
                                    }
                                    for (var j = 0; j < TypeName.length; j++) {
                                        if (Type[j] == "select") {
                                            $('#fl_' + ID).append('<option value="' + TypeName[j] + '">' + TypeName[j] + '</option>');
                                        }
                                        else {
                                            $('#feedbackId').append('<tr><td>' +
                                                '<input name="' + ResultData[i].ID + '" disabled="disabled" style="' + (Type[j] == "text" ? "border-top: darkblue;border-left: darkblue;border-right: darkblue;height: 20px;width: 300px;" : "width: 18px;height: 18px;") + '" type="' + Type[j] + '" value="' + TypeName[j] + '" class="fl" /><span>' + TypeName[j] + '</span></td>' +
                                        '</tr>');
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        showerrormsg("No record found");
                    }
                }
            });
        }
        function ChangeCallBy() {
            var radioselect = $('input[name=callcenterRadio]:checked').val();
            BindFeedBack(radioselect);
        }
        function DeleteFeedBack(ID) {
            $.ajax({
                url: "CallCentreQuestion.aspx/DeleteFeedOption",
                data: JSON.stringify({ ID: ID }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        alert("Feed Option deleted successfully...!");
                        ChangeCallBy();
                    }
                    if (result.d == "0") {
                        showerrormsg("Not deleted try again...!");
                        return;
                    }
                    if (result.d == "2") {
                        showerrormsg("Some Error...!");
                        return;
                    }
                }
            });
        }
    </script>
</asp:Content>

