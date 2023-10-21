<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SearchEmployeeInfo.aspx.cs" Inherits="Design_CallCenter_SearchEmployeeInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/Chosen") %>
    <style>
        #PatientLabSearchOutput {
            height: 300px;
        }

        #allcheck .chosen-container {
            width: 140px!important;
        }
    </style>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="width: 1296px; text-align: center;">
            <b>Search Directory</b>
            <asp:Label ID="lblTicketID" runat="server" ClientIDMode="Static" Style="display: none"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>
            <div class="row">
                <div class="col-md-3" id="allcheck">
                    <asp:DropDownList ID="ddlSearchType" CssClass="chosen-select chosen-container" runat="server" Width="50px">
                        <asp:ListItem Value="All"> All</asp:ListItem>
                        <asp:ListItem Value="ed.EmployeeName"> Name</asp:ListItem>
                        <asp:ListItem Value="ed.EmployeeCode">EmployeeCode</asp:ListItem>
                        <asp:ListItem Value="ed.MobileNo">Mobile</asp:ListItem>
                        <asp:ListItem Value="ed.ExtensionNo">ExtensionNo</asp:ListItem>
                        <asp:ListItem Value="ed.Designation"> Designation</asp:ListItem>
                        <asp:ListItem Value="ed.emailid"> Emailid</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtsearchvalue" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-2">Centre :</div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlCentre" class="ddlcentreAccess chosen-select chosen-container" Width="150px" runat="server">
                    </asp:DropDownList>
                </div>
                <div class="col-md-6">
                    <input type="button" value="Search" class="searchbutton" onclick="SearchDetailData()" />
                </div>
            </div>
            <br />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Employee Detail&nbsp;&nbsp;&nbsp;                 
            </div>
            <div id="PatientLabSearchOutput">
                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblAreaDetails" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr id="trHeader">
                            <td class="GridViewHeaderStyle" scope="col" style="top: 10px!important; padding: 5px;">Sr.No</td>
                            <td class="GridViewHeaderStyle" scope="col" style="top: 100px!important; padding: 5px;">Centre</td>
                            <td class="GridViewHeaderStyle" scope="col" style="top: 10px!important; padding: 5px;">Employee Name</td>
                            <td class="GridViewHeaderStyle" scope="col" style="top: 10px!important; padding: 5px;">Employee Code</td>
                            <td class="GridViewHeaderStyle" scope="col" style="top: 80px!important; padding: 5px;">Mobile No</td>
                            <td class="GridViewHeaderStyle" scope="col" style="top: 80px!important; padding: 5px;">EmailId</td>
                            <td class="GridViewHeaderStyle" scope="col" style="top: 80px!important; padding: 5px;">ExtensionNo</td>
                            <td class="GridViewHeaderStyle" scope="col" style="top: 80px!important; padding: 5px;">Designation</td>
                            <td class="GridViewHeaderStyle" scope="col" style="top: 80px!important; width: 120px; padding: 5px;">Action</td>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            getCentre();

            function isNumberKey(evt) {
                var charCode = (evt.which) ? evt.which : event.keyCode;
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                } else {
                    return true;
                }
            }
            $('.Mobile').keyup(function () {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            });
            $(".Mobile").on('keypress keyup', function (e) {
                //if the letter is not digit then display error and don't type anything
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    return false;
                }
            });

            $(".emailid").on('blur', function (e) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery(this).val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    jQuery(this).val("");
                }
            });
        });

        function getCentre() {
            serverCall('../CallCenter/CallCenterPincodeArea.aspx/GetCentre', {}, function (response) {
                AreaData = jQuery.parseJSON(response);
                if (AreaData.length == 0) {
                    $('#ddlCentre').append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    $('#ddlCentre').html('');
                    $('#ddlCentre').append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < AreaData.length; i++) {

                        $('#ddlCentre').append($("<option></option>").val(AreaData[i].CentreID).html(AreaData[i].Centre));
                    }
                }
                $('.chosen-container').css('width', '323px');
                $('#ddlCentre').trigger('chosen:updated');
            });
        }
        function SearchDetailData() {
            $('#btnSearch').attr('disabled', true).val("Searching...");
            var arr = new Array();
            var request = {
                SearchType: $('#<%=ddlSearchType.ClientID %>').val(),
                SearchValue: $('#<%=txtsearchvalue.ClientID %>').val(),
                CentreID: $('#<%=ddlCentre.ClientID %>').val()
            };
            arr.push(request);
            serverCall('../CallCenter/SearchEmployeeInfo.aspx/SearchReceiptData', { query: arr }, function (response) {
                $('#btnSearch').attr('disabled', false).val("Search");
                var ResultData = $.parseJSON(response);
                if (ResultData.length > 0) {
                    jQuery('#tblAreaDetails tbody').html('');
                    for (var i = 0; i < ResultData.length; i++) {
                        var $temp = [];
                        $temp.push('<tr>');
                        $temp.push('<td class="GridViewLabItemStyle"><input type="hidden" value='); $temp.push(ResultData[i].SNo); $temp.push('>'); $temp.push(parseInt(i + 1)); $temp.push('</td>');
                        $temp.push('<td class="GridViewLabItemStyle">'); $temp.push(ResultData[i].Centre); $temp.push('</td>');
                        $temp.push('<td class="GridViewLabItemStyle">'); $temp.push(ResultData[i].EmployeeName); $temp.push('</td>');
                        $temp.push('<td class="GridViewLabItemStyle">'); $temp.push(ResultData[i].EmployeeCode); $temp.push('</td>');
                        $temp.push('<td class="GridViewLabItemStyle">'); $temp.push(ResultData[i].MobileNo); $temp.push('</td>');
                        $temp.push('<td class="GridViewLabItemStyle">'); $temp.push(ResultData[i].emailid); $temp.push('</td>');
                        $temp.push('<td class="GridViewLabItemStyle">'); $temp.push(ResultData[i].ExtensionNo); $temp.push('</td>');
                        $temp.push('<td class="GridViewLabItemStyle">'); $temp.push(ResultData[i].Designation); $temp.push('</td>');
                        $temp.push('<td class="GridViewLabItemStyle"><input type="button" onclick="EditTabledata(this)" value="Edit" /> <input class="canceledit" type="button" onclick="Canceledit(this)" value="cancel" style="display:none"></td>');
                        $temp.push('</tr>');
                        $temp = $temp.join("");
                        jQuery('#tblAreaDetails tbody').append($temp);
                    }
                    $("#tblAreaDetails").tableHeadFixer();
                }
                else {
                    jQuery('#tblAreaDetails tbody').html('');
                    toast("Error", 'No record found', "");
                }
            });
        }
        function EditTabledata(element) {
            if ($(element).val() == "Edit") {
                var le = $(element).closest("tr").find("td").length - 1;
                $(element).closest("tr").find("td").each(function (index) {
                    if (index > 1) {
                        if (index < le) {
                            var $temp = [];
                            $temp.push('<input type="text"  value="')
                            $temp.push($(element).closest("tr").find(this).text())
                            $temp.push('" style="width:100%;padding:2px" />')
                            $temp = $temp.join("");
                            $(this).html($temp)
                        }
                    }
                })
                $(element).val('Update');
                $(element).closest("tr").find('td .canceledit').show();
            }
            else if ($(element).val() == "Update") {
                var id = 0;
                var arr = Array();
                var Obj = new Object();

                if (validatemail($(element).closest("tr").find('td:eq(5) input').val()) == "1") {
                    toast("Error", "Please enter valid email id", "");
                    return;
                }
                var mobile = $(element).closest("tr").find('td:eq(4) input').val();
                if (isNaN(mobile.trim()) == true || mobile.trim()=="" || mobile.trim().length != 10) {
                    toast("Error", "Please enter valid mobile no", "");
                    return;
                }
                id = $(element).closest("tr").find('td:eq(0) input').val()
                Obj.EmployeeName = $(element).closest("tr").find('td:eq(2) input').val();
                Obj.EmployeeCode = $(element).closest("tr").find('td:eq(3) input').val();
                Obj.MobileNo = mobile;
                Obj.EmailId = $(element).closest("tr").find('td:eq(5) input').val();
                Obj.ExtensionCode = $(element).closest("tr").find('td:eq(6) input').val();
                Obj.Designation = $(element).closest("tr").find('td:eq(7) input').val();
                Obj.CentreCode = "";
                arr.push(Obj);

                serverCall('../CallCenter/InterComMaster.aspx/Update', { data: arr, ID: id }, function (response) {
                    var res = response;
                    if (res == "1") {
                        toast("Success", "Saved Successfully!!!", "");
                        Canceledit(element);
                        $(element).val('Edit');
                    } else {
                        toast("Error", res, "");
                    }
                });

            }
        }
        function Canceledit(element) {
            var le = $(element).closest("tr").find("td").length - 1;
            $(element).closest("tr").find("td").each(function (index) {
                if (index > 1) {
                    if (index < le) {
                        $(this).html($(this).find('input').val())
                    }
                }

            })
            $(element).prev("input[type='button']").val('Edit');
            $(element).closest("tr").find('td .canceledit').hide();
        }       
        function validatemail(email) {
            if (email.length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(email)) {
                    con = 1;
                    return con;
                }
            }
        }
    </script>
</asp:Content>

