<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SetSalesTarget.aspx.cs" Inherits="Design_Sales_SetSalesTarget" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Conten1" runat="server">

    <script src="../../scripts/jquery.extensions.js" type="text/javascript"></script>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <link href="../../App_Style/jquery-ui.css" rel="stylesheet" />

    <style type="text/css">
        .multiselect {
            width: 100%;
        }
    </style>

    <script type="text/javascript">
        z = 0;
        //$(function () {
        //    //  $(".datepicker").datepicker();
        //    $(".CheckDate").datepicker({ dateFormat: 'dd-M-yy' });
        //    $(".dtFrom").datepicker({ dateFormat: 'dd-M-yy' });
        //});
        $(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
        });

        function addfidetail() {
            var $table = $("#tblAreaDetails tbody"),
             lastRow = $table.find("tr:last-child");
            $table.append(lastRow.clone());
            $table.find("tr:last-child").find('#ddlBankName,#txtCheque,.CheckDate,#ddlInvoice').hide();
            $table.find("tr:last-child").find('#txt_AdvAmt').removeAttr('disabled');


            $table.find("tr:last-child").find('.dtFrom').removeClass('hasDatepicker');
            $table.find("tr:last-child").find('.CheckDate').removeClass('hasDatepicker');


            $table.find("tr:last-child").find('.dtFrom').attr("id", "dtFrom0" + z);
            $table.find("tr:last-child").find('.CheckDate').attr("id", "CheckDate0" + z);

            $(".CheckDate").datepicker({ dateFormat: 'dd-M-yy' });
            $(".dtFrom").datepicker({ dateFormat: 'dd-M-yy' });

            z++;
        }
        function deleterow2(itemid) {
            var table = document.getElementById('tblAreaDetails');
            if ($('#tblAreaDetails tr').length > 2) {
                table.deleteRow(itemid.parentNode.parentNode.rowIndex);
            }

        }

        function clearData() {
            //$("#tblAreaDetails").find('.tr_remove:gt(0)').remove();
            $("#tblAreaDetails").empty();
        }




    </script>


    <script type="text/javascript">
        function SaveRecord() {
            var SalesTarget = GetSalesTraget();
            if (SalesTarget == "0") {
                return false;
            }
            $.ajax({
                url: "SetSalesTarget.aspx/SaveTarget",
                data: JSON.stringify({ SalesTarget: SalesTarget }), // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showscuessmsg("Saved Successfully!!!");
                        $('input[type="text"]').val('');
                        clearData();
                        return;
                    }
                    else {
                        showerrormsg(result.d);
                        return "";
                    }
                },
                error: function (xhr, status) {
                    showerrormsg("error");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function GetSalesTraget() {
            var ObsRanges = "";
            var Target = new Array();
            $('#tblAreaDetails tr').each(function (index) {
                if (index > 0) {
                    var Obj = new Object();
                    debugger
                    Obj.ExecutiveID = $(this).find("#spnExecutiveID").text();
                    Obj.Executive = $(this).find("#spnExecutive").text();
                    Obj.April = "April#" + $(this).find("#txt_AprSales").val();
                    Obj.May = "May#" + $(this).find("#txt_MaySales").val();
                    Obj.June = "June#" + $(this).find("#txt_JunSales").val()
                    Obj.July = "July#" + $(this).find("#txt_JulSales").val();
                    Obj.August = "August#" + $(this).find("#txt_AugSales").val();
                    Obj.September = "September#" + $(this).find("#txt_SepSales").val();
                    Obj.October = "October#" + $(this).find("#txt_OctSales").val();
                    Obj.November = "November#" + $(this).find("#txt_NovSales").val();
                    Obj.December = "December#" + $(this).find("#txt_DecSales").val();
                    Obj.January = "January#" + $(this).find("#txt_JanSales").val();
                    Obj.February = "February#" + $(this).find("#txt_FebSales").val();
                    Obj.March = "March#" + $(this).find("#txt_MarSales").val();
                    //var $rowid = $(this).closest("tr");
                    //ObsRanges += $(this).find("#spnExecutiveID").text() + '|' + $(this).find("#spnExecutive").text() + '|' + $(this).find("#txt_AprSales").val() + '|' + $(this).find("#txt_MaySales").val() + '|' + $(this).find("#txt_JunSales").val() + '|' + $(this).find("#txt_JulSales").val() + '|' + $(this).find("#txt_AugSales").val() + '|' + $(this).find("#txt_SepSales").val() + '|' + $(this).find("#txt_OctSales").val() + '|' + $(this).find("#txt_NovSales").val() + '|' + $(this).find("#txt_DecSales").val() + '|' + $(this).find("#txt_JanSales").val() + '|' + $(this).find("#txt_FebSales").val() + '|' + $(this).find("#txt_MarSales").val() + "#";
                    Target.push(Obj);
                }

            });

            if (Target == "") {
                return "0";
            }
            else {
                return Target;
            }


        }

        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showscuessmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'lightgreen');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }

    </script>

    <div id="Pbody_box_inventory" style="width: 1305px;">

        <Ajax:ScriptManager ID="ScriptManager1" EnablePageMethods="true" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">
            <b>Set Sales Target</b>
            <br />
            <asp:Label id="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; text-align: center">
                <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                TargetSet Sales Target Bulk Upload

            </div>
            <div class="Content"></div>

            <div class="POuter_Box_Inventory" style="width: 1296px;">

                <div>
                    <table id="TBMain" style="width: 100%; margin: 0 auto; border-collapse: collapse">
                        <tr>
                            <td style="text-align: right; width: 100px; font-weight: normal;">Financial Year :</td>
                            <td style="text-align: left; width: 100px;">
                                <asp:DropDownList ID="ddlYear" runat="server" CssClass="chosen-select" Width="100px" ClientIDMode="Static">
                                    <asp:ListItem Value="2018-2019">2018-2019</asp:ListItem>
                                    <asp:ListItem Value="2019-2020">2019-2020</asp:ListItem>
                                    <asp:ListItem Value="2020-2021">2020-2021</asp:ListItem>
                                    <asp:ListItem Value="2021-2022">2021-2022</asp:ListItem>
                                    <asp:ListItem Value="2022-2023">2022-2023</asp:ListItem>
                                </asp:DropDownList>
                            </td>

                            <td style="text-align: right; width: 100px">Executives  :</td>
                            <td style="text-align: left; width: 200px">
                                <asp:DropDownList ID="ddlpro" runat="server" CssClass="chosen-select" Width="200px" ClientIDMode="Static"></asp:DropDownList>
                            </td>
                            <td style="text-align: left; width: 200px; font-weight: normal;">
                                <asp:Button ID="btnDownload" runat="server" Text="DownLoad Excel" OnClick="lnk1_Click" Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" />
                            </td>
                            <td style="text-align: left; width: 300px;">
                                <asp:FileUpload ID="file1" runat="server" /><asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click" Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" />
                            </td>
                            <%-- <td style="text-align: left; margin-left: 30px;">
                            <input type="button" id="btnSearch" runat="server" class="searchbutton" clientidmode="Static" value="Search" onclick="Search();" style="margin-left: 30px;" />&nbsp;&nbsp;&nbsp;                           
                            
                        </td>--%>
                        </tr>
                    </table>
                </div>
            </div>
            <div>
                <div class="POuter_Box_Inventory" style="width: 1296px;">
                    <div runat="server" id="tblData" style="max-height: 400px; overflow: auto;">
                        <table width="99%" id="tblAreaDetails"></table>
                    </div>
                </div>
            </div>
            <div class="div_Save" style="display: none">
                <div class="POuter_Box_Inventory" style="width: 1296px;">


                    <div class="content">
                        <%--<div class="Purchaseheader" style="cursor:pointer;" >Amount Details   <span style="margin-left:50%;" ><span style="color:red;">Import Advance Amount(<span style="color:blue;font-size:10px; cursor:pointer"><a class="im" url="imnoImage/AdvanceAmountPaymentBulkUpload.xlsx" style="cursor: pointer" href="imnoImage/AdvanceAmountPaymentBulkUpload.xlsx" target="_blank">Excel Fommat</a></span>)~</span><asp:FileUpload ID="file1" runat="server" /><asp:Button ID="btnupload" runat="server" Text="Upload" OnClick="btnupload_Click"  Style="cursor: pointer; padding: 5px; color: white; background-color: blue; font-weight: bold;" /></span></div>--%>
                        <div id="Div1" runat="server" style="height: 200px; overflow: auto;">
                            <table width="99%">

                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 15px" align="left">Add</th>

                                    <th class="GridViewHeaderStyle" style="width: 150px" align="left">Panel</th>
                                    <th class="GridViewHeaderStyle" style="width: 40px" align="left">Receive Date</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px" align="left">PayMent Mode</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px" align="left">Advance Amount</th>
                                    <th class="GridViewHeaderStyle" style="width: 55px" align="left">Bank Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 55px;" align="left">Cheque/Draft No</th>
                                    <th class="GridViewHeaderStyle" style="width: 55px" align="left">Cheque/Draft Date</th>
                                    <th class="GridViewHeaderStyle" align="left" style="width: 90px">Remarks</th>
                                    <th class="GridViewHeaderStyle" align="left" style="width: 55px">Type</th>
                                    <th class="GridViewHeaderStyle" align="left" style="width: 55px">Invoice No</th>
                                    <th class="GridViewHeaderStyle" align="left" style="width: 55px"></th>
                                </tr>

                                <tr id="tr_dynamic" class="tr_remove">
                                    <td id="td1" style="text-align: center">
                                        <img src="imnoImage/plus.png" style="width: 15px; cursor: pointer" onclick="addfidetail();"></td>

                                    <td id="td3">
                                        <asp:DropDownList ID="ddl_panel" onchange="GetTdsInvoice(this)" Style="width: 99%;" runat="server" CssClass="ItDoseDropdownbox">
                                        </asp:DropDownList></td>
                                    <td id="td4">
                                        <asp:TextBox ID="dtFrom" runat="server" Style="width: 99%;" class="dtFrom" TabIndex="2" ToolTip="Select Joing From Date" ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                    <td id="td5">
                                        <select id="paymentMode" style="width: 99%;" class="paymentMode" onchange="SetMode(this);">
                                            <option value="Cash">Cash </option>
                                            <option value="Cheque">Cheque</option>
                                            <option value="Draft">Draft</option>
                                            <option value="NEFT">NEFT</option>
                                            <option value="PayTM">PayTM</option>
                                        </select></td>
                                    <td id="td6">
                                        <asp:TextBox ID="txt_AdvAmt" runat="server" Style="width: 99%;" CssClass="ItDoseTextinputText" />
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txt_AdvAmt"
                                            ValidChars=".0987654321">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td id="td7">
                                        <asp:DropDownList ID="ddlBankName" class="Bank" Style="width: 99%; display: none;" runat="server">
                                            <asp:ListItem Value="0" Text=""></asp:ListItem>
                                            <asp:ListItem Value="1" Text="CANARA BANK"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="HDFC BANK"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="PNB BANK"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td id="td2">
                                        <asp:TextBox ID="txtCheque" runat="server" Style="width: 99%; display: none;" class="chk" /></td>
                                    <td id="td8" style="text-align: center; width: 50px;">
                                        <asp:TextBox ID="txtCheckDate0" runat="server" Style="width: 99%; display: none;" class="CheckDate" TabIndex="2" ToolTip="Select Joing From Date" ClientIDMode="Static"></asp:TextBox>
                                    </td>
                                    <td id="td9">
                                        <asp:TextBox ID="txt_PaymentRemarks" runat="server" Style="width: 99%;" CssClass="ItDoseTextinputText" /></td>
                                    <td id="td12">
                                        <asp:DropDownList ID="ddlType" onchange="ShowInvoices(this)" Style="width: 99%;" runat="server">
                                            <asp:ListItem Value="0" Text="Deposit"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Credit Note"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Debit Note"></asp:ListItem>
                                            <asp:ListItem Value="3" Text="TDS"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td id="td10">
                                        <asp:DropDownList ID="ddlInvoice" onchange="CalculateTDS(this)" Style="width: 99%; display: none;" runat="server"></asp:DropDownList>
                                    </td>
                                    <td id="td11" style="width: 50px">
                                        <img src="imnoImage/Delete.gif" alt="" style="cursor: pointer;" onclick="deleterow2(this)" /></td>

                                </tr>

                            </table>

                        </div>

                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" id="ActionDiv" runat="server" style="text-align: center; width: 1296px;">
                <input type="button" id="Button1" value="Save" onclick="SaveRecord()" runat="server" tabindex="9" style="cursor: pointer; padding: 5px; width: 150px; color: white; background-color: blue; font-weight: bold;" />
                <input type="button" id="btnUpdate" value="Update" runat="server" onclick="UpdateRecord()" tabindex="9" style="display: none" class="savebutton" />
                <input type="button" value="Cancel" onclick="clearData()" style="cursor: pointer; padding: 5px; color: white; background-color: lightcoral; width: 150px; font-weight: bold;" />
            </div>
        </div>
</asp:Content>

