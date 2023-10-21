<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="Design_Dashboard_Reports" %>

<%@ Import Namespace="System.Data" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
     <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript" src="jquery.min.js"></script>
    <script type="text/javascript" src="../../JavaScript/jquery-ui.js"></script>

    <script type="text/javascript" src="json2.js"></script>

    <script type="text/javascript" src="jquery.multiple.select.js"></script>
    <link href="multiple-select.css" rel="stylesheet" />
    <style type="text/css">
        .multiselect {
            width: 180px ;
        }
        .ms-drop{ width:400px;}

        .div_chart {
            width: 500px;
            height: 300px;
            border: solid 1px #DDEBF9;
            float: left;
            margin: 3px;
        }

        .divForm {
            width:310px;display: inline-block; padding:5px;
        }
        .divFormHeader { width:100px; display:inline-block; font-weight:bold;
        }
        .divFormContent {
            display:inline-block;
        }
        .divFormContent:before {
    content: ":";
}


        .tbChart table, .tbChart th, .tbChart td {
            border: 1px solid #DDEBF9;
        }

        ul.connectedSortable {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden; min-height:30px; 
  
}

  .connectedSortable li {
    float: left; padding:5px; border:solid 1px gray; cursor:move; margin-right:2px;
}

.connectedSortable li a {
    display: block;
    color: white;
    text-align: center;
    padding: 16px;
    text-decoration: none;
}

.connectedSortable li a:hover {
    background-color: #111111;
}

        #showData {
            padding: 2px 4px;
            font: 12px Verdana;
            
        }

        th {
            font-weight: bold;
             background-color:#09f;
        }

    </style>
    

    <div id="container">
        <div id="Pbody_box_inventory" style="width: 1304px;">
            <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
            </cc1:ToolkitScriptManager>
            <div class="POuter_Box_Inventory" style="width: 1300px;">
                <div class="content">
                    <div style="text-align: center;">
                        <b><span id="MainHeader"></span>&nbsp;
                            <asp:Label ID="lblHeader" runat="server" Text="Reports"></asp:Label>
                            <br />
                        </b>
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    </div>
                </div>
            </div>



            <div class="POuter_Box_Inventory" style="width: 1300px;">
                <div class="content">

                    <div class="divForm divReport">
                        <div class="divFormHeader">Report</div>
                        <div class="divFormContent">
                            <asp:DropDownList ID="ddlReport" runat="server" CssClass="ItDoseDropdownbox" onchange="loadForm();" style="width:180px"></asp:DropDownList>
                        </div>
                    </div>

                    <div class="divForm dtFrom">
                        <div class="divFormHeader">From Date</div>
                        <div class="divFormContent">
                            <asp:TextBox ID="dtFrom" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>

                            <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                TargetControlID="dtFrom"
                                Format="yyyy-MM-dd" />

                        </div>
                    </div>
                    <div class="divForm dtTo">
                        <div class="divFormHeader">To Date</div>
                        <div class="divFormContent">
                            <asp:TextBox ID="dtTo" runat="server" CssClass="ItDoseTextinputText"></asp:TextBox>

                            <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                TargetControlID="dtTo"
                                Format="yyyy-MM-dd" />
                        </div>
                    </div>

                    <div class="divForm Centre">
                        <div class="divFormHeader">Centre</div>
                        <div class="divFormContent">

                            <asp:ListBox ID="lblCentre" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>
                        </div>
                    </div>


                    <div class="divForm Panel">
                        <div class="divFormHeader">Client</div>
                        <div class="divFormContent">

                            <asp:ListBox ID="lblPanel" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>


                        </div>
                    </div>


                    <div class="divForm Department">
                        <div class="divFormHeader">Department</div>
                        <div class="divFormContent">

                            <asp:ListBox ID="lblDept" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>

                        </div>
                    </div>

                    <div class="divForm Item">
                        <div class="divFormHeader">Test</div>
                        <div class="divFormContent">

                            <asp:ListBox ID="lblItem" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>


                        </div>
                    </div>

                    <div class="divForm User">
                        <div class="divFormHeader">User</div>
                        <div class="divFormContent">

                            <asp:ListBox ID="lblUser" CssClass="multiselect" SelectionMode="Multiple" runat="server"></asp:ListBox>


                        </div>
                    </div>


                </div>

            </div>


            <div class="Puter_Box_Inventory" style="width:1300px; display: none;">
                Available Columns:
            <ul id="sortable1" class="connectedSortable">
            </ul>
                Selected Columns:
            <ul id="sortable2" class="connectedSortable">
            </ul>
                Group Columns:
            <ul id="sortable3" class="connectedSortable">
            </ul>

                <asp:TextBox ID="txtColumns" runat="server" Style="display: none;"></asp:TextBox>
                <asp:TextBox ID="txtGroup" runat="server" Style="display: none;"></asp:TextBox>

            </div>

            <div class="Outer_Box_Inventory divReport" style="width:1300px;">
                <div class="content" style="text-align: center;">
                    <asp:DropDownList ID="ddlOutput" CssClass="ItDoseDropdownbox" onchange="CheckReturn();" runat="server">

                       
                        <asp:ListItem>Excel</asp:ListItem>
 
                       
                        <asp:ListItem>Inline Report</asp:ListItem>

                    </asp:DropDownList>
                    <asp:Button ID="btnReport" runat="server" OnClientClick="return validateForm();" Text="Show Report" />
                    <asp:Button ID="btnInlineReport" runat="server" OnClientClick="return BindInlineReport();" Text="Show Report" Style="display: none;" />
                    <asp:HiddenField ID="hdnIsInline" runat="server" Value="0" />

                </div>
            </div>


            <div class="Outer_Box_Inventory divReport" style="width:1300px;">
                <div id="showData" class="content" style="text-align: center;">
                </div>
            </div>

        </div>
        <asp:Label ID="lblReport" runat="server" Text=""></asp:Label>
    </div>


    <script type="text/javascript">

        $(document).ready(function () {


            $('.multiselect').multipleSelect({
                filter: true, keepOpen: false
            });
            loadForm();

            $('#__EVENTVALIDATION').val('');
            $('#__VIEWSTATE').val('');



            //$('#container').on("change click", ":input", function (event) {

            //    $('[id$=btnInlineReport]').removeAttr('disabled');
            //    $('[id$=btnInlineReport]').css('color', '#000');
            //});



        });


        function CheckReturn() {

            if ($('[id$=ddlOutput] option:selected').text() == "Inline Report") {
                $('[id$=hdnIsInline]').val('1');
                $('[id$=btnReport]').css('display', 'none');
                $('[id$=btnInlineReport]').css('display', '');

            }
            else {
                $('[id$=hdnIsInline]').val('0');
                $('[id$=btnReport]').css('display', '');
                $('[id$=btnInlineReport]').css('display', 'none');
            }
        }

        function BindInlineReport() {
            $('[id$=btnInlineReport]').prop('disabled', true);
            $('[id$=btnInlineReport]').val('Seaching..');


            $('[id$=showData]').html('');
            var Report = $('[id$=ddlReport] option:selected').text();
            $.ajax({
                url: "Reports.aspx/BindInlineReport",
                async: true,
                data: JSON.stringify({ Report: Report }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var filtr = result.d;
                    var ReportFilters = '';
                    if (filtr.includes("@dtFrom")) {
                        ReportFilters += '@dtFrom~' + $('[id$=dtFrom]').val() + '#';
                    }
                    if (filtr.includes("@dtTo")) {
                        ReportFilters += '@dtTo~' + $('[id$=dtTo]').val() + '#';
                    }

                    if (filtr.includes("@Centre")) {
                        ReportFilters += '@Centre~' + $('[id$=lblCentre]').val().toString() + '#';
                    }
                   
                    if (filtr.includes("@Panel")) {
                        
                        ReportFilters += '@Panel~' + $('[id$=lblPanel]').val().toString() + '#';
                    }
                    if (filtr.includes("@Item")) {

                        ReportFilters += '@Item~' + $('[id$=lblItem]').val().toString() + '#';
                    }
                    if (filtr.includes("@User")) {

                        ReportFilters += '@User~' + $('[id$=lblUser]').val().toString() + '#';
                    }

                    if (ReportFilters.length > 0)
                        ReportFilters = ReportFilters.substring(0, ReportFilters.length - 1);
                    $.ajax({
                        url: "Reports.aspx/GetInlineReport",
                        async: false,
                        data: JSON.stringify({ ReportFilters: ReportFilters }),
                        contentType: "application/json; charset=utf-8",
                        type: "POST", // data has to be Posted 
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            var myData = $.parseJSON(result.d);
                            var col = [];
                            for (var i = 0; i < myData.length; i++) {
                                for (var key in myData[i]) {
                                    if (col.indexOf(key) === -1) {
                                        col.push(key);
                                    }
                                }
                            }

                            var table = document.createElement("table");
                            var tr = table.insertRow(-1);
                            for (var i = 0; i < col.length; i++) {
                                var th = document.createElement("th");
                                th.innerHTML = col[i];
                                tr.appendChild(th);
                            }

                         
                            for (var i = 0; i < myData.length; i++) {

                                tr = table.insertRow(-1);

                                for (var j = 0; j < col.length; j++) {
                                    var tabCell = tr.insertCell(-1);
                                    tabCell.innerHTML = myData[i][col[j]];
                                }
                            }

                       
                            var divContainer = document.getElementById("showData");
                            divContainer.innerHTML = "";
                            divContainer.appendChild(table);

                        }
                    });

                    if ($('[id$=showData]').find('table tr').length > 1) {
                        $('[id$=showData]').find('table').css('background-color', '#fff');
                        $('[id$=showData]').find('table').attr('border', '1');
                        $('[id$=showData]').find('table').css('width', '100%');
                        $('[id$=showData]').find('table').css('text-align', 'left');
                    }
                    else {
                        $('[id$=showData]').html('No Record found !');
                    }
                    $('[id$=btnInlineReport]').removeAttr('disabled');
                    $('[id$=btnInlineReport]').val('Show Report');

                }
            });

            

            return false;
        }

        function validateForm() {
            return true;
        }


        function loadForm() {

            $('.divForm').hide();
            $('.divReport').show();


            $('[id$=showData]').html('');

            if ($('#<%=ddlReport.ClientID%>').val() == '')
                return;
            $.ajax({
                url: "Reports.aspx/getReportInfo",
                data: JSON.stringify({ ReportID: $('#<%=ddlReport.ClientID%>').val() }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 300000,//=30Sec
                dataType: "json",
                success: function (result) {
                    var r = $.parseJSON(result.d);
                    for (var i = 0; i < r[0].Filter.split(',').length ; i++) {
                        $('.' + r[0].Filter.split(',')[i]).show();
                    }
                    //Adding Columns
                    $('#sortable1').empty();
                    for (var i = 0; i < r[0].Columns.split(',').length ; i++) {
                        $('#sortable1').append('<li>' + r[0].Columns.split(',')[i] + '</li>');
                    }
                },
                error: function (xhr, status) {
                }
            });
            
           
            bindPanel();

        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            debugger

            $('.divForm').hide();
            $('.divReport').show();


            $('[id$=showData]').html('');
            var CallFor = GetParameterValues('CallFor');
            if (CallFor != undefined) {
                if (CallFor == "IA") {
                    $('[id$=ddlReport]').val('7');
                    $('#MainHeader').text('Investigation Analysis');
                }
                if (CallFor == "TM") {
                    $('[id$=ddlReport]').val('6');
                    $('#MainHeader').text('Test Master');

                }
                $('[id$=ddlReport]').change();
            }
            function GetParameterValues(param) {
                var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < url.length; i++) {
                    var urlparam = url[i].split('=');
                    if (urlparam[0] == param) {
                        return urlparam[1];
                    }
                }
            }
        });



        function bindPanel() {
            
            


            $.ajax({
                url: "Reports.aspx/bindPanel",
                data: JSON.stringify({ type: $("[id$=ddlReport] option:selected").text() }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 300000,//=30Sec
                dataType: "json",
                success: function (result) {
                   // alert(result.d);
                    debugger;
                    $('[id$=lblPanel] option').remove();
                    var panelData = $.parseJSON(result.d);
                    if (panelData.length == 0) {
                        $('[id$=lblPanel]').append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    for (i = 0; i < panelData.length; i++) {
                       // alert(panelData[i].Panel_ID);
                        $('[id$=lblPanel]').append($("<option></option>").val(panelData[i].Panel_id).html(panelData[i].Company_Name));
                    }
                    jQuery('#<%=lblPanel.ClientID%>').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                }
              });

               
            
        }
       

    </script>
</asp:Content>

