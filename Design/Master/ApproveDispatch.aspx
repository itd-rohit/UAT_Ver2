<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ApproveDispatch.aspx.cs" Inherits="Design_Lab_ApproveDispatch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
  
    <style type="text/css">
        .uploadify {
            position: relative;
            margin-bottom: 1em;
            margin-left: 40%;
            margin-top: -40px;
            z-index: 999;
        }

        #MainInfoDiv {
            height: 480px !important;
        }

        #divimgpopup {
            height: 600px !important;
        }

        .ReRun {
            background-color: #F781D8;
        }

        tr.FullRowColorInRerun td {
            background-color: #F781D8!important;
        }

        tr.FullRowColorInCancelByInterface td {
            background-color: #abb54c;
        }

        #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 300px;
            background: #FFFFFF;
            left: 400px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }

        #popup_box3 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 300px;
            background: #FFFFFF;
            left: 150px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }

        #divunapproved {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            height: 300px;
            width: 600px;
            background: #FFFFFF;
            left: 400px;
            top: 150px;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            margin-left: 15px;
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 15px;
            font-size: 15px;
            -moz-box-shadow: 0 0 5px #ff0000;
            -webkit-box-shadow: 0 0 5px #ff0000;
            box-shadow: 0 0 5px #ff0000;
        }



        .handsontableInputHolder {
            z-index: 1000;
        }

        .handsontable.autocompleteEditor {
            border: 1px solid #AAAAAA;
            box-shadow: 10px 10px 15px #AAAAAA;
            background-color: white;
            min-width: 600px;
        }

            .handsontable.autocompleteEditor.handsontable {
                padding-right: 0px;
            }


        .autocompleteEditor .wtHolder {
            min-width: 600px;
        }


        .autocompleteEditor .htCore {
            border: none !important;
            -webkit-box-shadow: none !important;
            box-shadow: none !important;
            min-width: 600px !important;
        }

        .autocompleteEditor .ht_clone_top, .autocompleteEditor .ht_clone_left {
            display: none;
        }
        .auto-style1 {
            width: 20px;
        }
        .auto-style2 {
            height: 41px;
        }
    </style>
    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server" AsyncPostBackErrorMessage="Error...">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" >
            <div class="content" style="text-align: center;">
                <b>Approve Dispatch</b>
            </div>
            <div class="Purchaseheader">
                Search Option
             &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblTotalPatient" ForeColor="Red" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="row">
                  <div class="col-md-8 ">
                          <asp:DropDownList ID="ddlSearchType" CssClass="chosen-select" runat="server" Width="150px">
                        <asp:ListItem Value="pli.BarcodeNo">Barcode No.</asp:ListItem>
                        <asp:ListItem Value="lt.Patient_ID">Patient ID</asp:ListItem>
                        <asp:ListItem Value="pli.LedgerTransactionNo" Selected="True">Lab No</asp:ListItem>
                        <asp:ListItem Value="pm.PName">Patient Name</asp:ListItem>
                    </asp:DropDownList>
                     
                      <asp:TextBox ID="txtSearchValue" runat="server" Width="250px"></asp:TextBox>
                      </div>
                 <div class="col-md-8 ">
                       <b style="padding-left: 37px;">Department: </b>
                
                      <asp:DropDownList ID="ddlDepartment" CssClass="chosen-select" Width="250px" runat="server">
                    </asp:DropDownList>
                      </div>
                 <div class="col-md-4 ">
                     <asp:CheckBox ID="chkPanel0" runat="server" onClick="BindTest();" Text="Test :" style="font-weight: 700;padding-left: 127px;" />
                      </div>
                 <div class="col-md-4 ">
                                           
<asp:DropDownList ID="ddlinvestigation" class="ddlinvestigation  chosen-select" Width="200px" runat="server">
                        </asp:DropDownList>
                      </div>
                </div>
            <div class="row">
                 <div class="col-md-10 "><b style="padding-left: 119px"> From Date:  </b>
                     <asp:TextBox ID="txtFormDate" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="120"></asp:TextBox>
                <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtFormDate" TargetControlID="txtFormDate" />
                    <asp:TextBox ID="txtFromTime" runat="server" Width="100"></asp:TextBox>
                <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                    AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                </cc1:MaskedEditExtender>
                <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                    ControlExtender="mee_txtFromTime"
                    ControlToValidate="txtFromTime"
                    InvalidValueMessage="*"></cc1:MaskedEditValidator>
                     </div>
                <div class="col-md-10 "> <b>To Date:  </b>
                     
                    <asp:TextBox ID="txtToDate"  CssClass="ItDoseTextinputText"  runat="server" ReadOnly="true"  Width="120px"></asp:TextBox>
							<cc1:calendarextender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" PopupButtonID="txtToDate" TargetControlID="txtToDate" />
							
							
							  <asp:TextBox ID="txtToTime" runat="server" Width="100px"></asp:TextBox>
								<cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
										AcceptAMPM="false" AcceptNegative="None" MaskType="Time">                        
								</cc1:MaskedEditExtender>
								<cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
										ControlExtender="mee_txtToTime"  ControlToValidate="txtToTime"  
										InvalidValueMessage="*"  ></cc1:MaskedEditValidator>
                     </div>
                <div class="col-md-4 ">
                     </div>
                                      		                               
            </div>

            <div class="row">
                <div class="col-md-24 ">
                <table style="width:99%">
                    <tr>
                        <td width="50%" align="right" class="auto-style2"> 
&nbsp;<%--<asp:ImageButton ID="btnimage" runat="server" ImageUrl="../../App_Images/refreshbuttonImg.jpg" style="width: 27px;" OnClientClick="window.location.onload();" />--%><input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="SearchSampleCollection('A');" /></td>
                        <td  width="50%" class="auto-style2">
                            <table align="right">
                    <tr>
                        <td style="font-weight: bold; background-color: #ff0000; border: 1px solid black;cursor:pointer;" onclick="SearchSampleCollection('CH');" class="auto-style1"></td>
                        <td style="font-weight: bold;">Critical High&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="font-weight: bold; background-color: #deb887 ; border: 1px solid black;cursor:pointer;" onclick="SearchSampleCollection('CL');" class="auto-style1"></td>
                        <td style="font-weight: bold;">Critical Low&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="font-weight: bold; background-color: pink; width: 20px; border: 1px solid black;cursor:pointer;" onclick="SearchSampleCollection('H');"></td>
                        <td style="font-weight: bold;">High&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 20px; border: 1px solid black; background-color: yellow; width: 20px;cursor:pointer;" onclick="SearchSampleCollection('L');"></td>
                        <td style="width: 20px; font-weight: bold;">Low&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="font-weight: bold; background-color: white; width: 20px; border: 1px solid black;cursor:pointer;" onclick="SearchSampleCollection('N');"></td>
                        <td style="font-weight: bold;">Normal</td>
                       

                    </tr>
                </table>                           
                    </tr>

                </table>
              
                    </div>  
            </div>

        </div>

        <div class="POuter_Box_Inventory" >
            <div class="row">
                   <div class="col-md-24 ">
            <div id="PagerDiv1" style="display: none; background-color: white; width: 99%; padding-left: 7px;">
            </div>
</div></div>
            <div id="divPatient" class="vertical" style="overflow: auto; height: 350px;"></div>
            <div id="MainInfoDiv" class="vertical" align="center">
                <div class="Purchaseheader">
                    <div class="DivInvName" style="color: Black; cursor: pointer; font-weight: bold;"></div>
                </div>
                <div id="divInvestigation">
                </div>

                <div id="SelectedPatientinfo">
                </div>
                <div style="display: none;">
                    <br />

                </div>
                <div style="padding-top: 2px;" class="btnDiv">
                    <p id="commentbox1"><span id="spInvestigationName" style="font-size: 14px; font-weight: bold; color: red"></span><span id="commentHead1"></span></p>
                    <a id="various2" style="display: none">Ajax</a>
                </div>
                <div>
                </div>

            </div>         
            <div id="divapprove" style="display: none;">
               <div class="row">
                   <div class="col-md-24 ">
                <center>

                    <asp:DropDownList ID="ddlApprove" runat="server" AppendDataBoundItems="True" Style="width: 200px;"></asp:DropDownList>
                
                    <input type="button" id="btnapproved" class="ItDoseButton" onclick="ApproveDispatchAll();" value="Approve & Dispatch" /> &nbsp;&nbsp;
                    <a href="../Lab/MachineResultEntry.aspx" target="_blank" >Result Entry</a>
                </center>
</div></div>
            </div>
        </div>
    </div>
    <div id="deltadiv" style="display: none; position: absolute;">
    </div>
    <div id="sampledate" style="display: none; position: absolute;"></div>
    <script type="text/javascript">

        var _PageSize = 100;
        var _PageNo = 0;
        $(document).ready(function () {
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
            $('#<%=txtSearchValue.ClientID%>').keypress(function (ev) {
                if (ev.which === 13)
                    SearchSampleCollection('A');
            });
        });
    </script>


    <script type="text/javascript">
        var PatientData = '';
        var LabObservationData = '';
        var _test_id = '';
        var _barcodeno = '';
        var hot2;
        var modal = "";
        var span = "";
        var currentRow = 1;
        var resultStatus = "";
        var criticalsave = "0";
        var macvalue = "0";
        var LedgerTransactionNo = "";
        var MYSampleStatus = "";
        var elt;
        // for image crop
        var Year = '<%=Year %>';
        var Month = '<%=Month %>';
        var image;
        var ImgTag;
        var savedvalue = "";
        var formattedDate;
        //end
        var mouseX;
        var mouseY;


        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });


        function getme(CollectionDate, ReceiveDate, ResultEnterydate, ProvisionalDispatchDate) {           
            $('#trrow').remove();
            var $temp = [];
            $temp.push("<div id='show' >");
            $('#trrow').remove();
            $temp.push("<table id='trrow' cellspacing='0' style='width:550px;font-family:Arial; font-size:12px; '  rules='all' frame='box' border='1' >");
            $temp.push("<tr style='background-color:black;color:white; font-weight:bold;'>");
            $temp.push("<th style='width:200px;text-align:left;'>Sample Collection Date</th>");
            $temp.push("<th style='width:110px;text-align:left;'>Dept. Receive Date </th>");
            $temp.push("<th style='width:110px;text-align:left;'>Result Entry Date</th>");
            $temp.push("<th style='width:110px;text-align:left;'>Provisional Dispatch Date</th>");
            $temp.push("</tr>");
            $temp.push("<tr  style='background-color:#d3d3d3;color:black; font-weight:bold;'>");
            $temp.push("<td style='width:200px;text-align:left;'>"); $temp.push(CollectionDate); $temp.push("</td>");
            $temp.push("<td style='width:200px;text-align:left;'>"); $temp.push(ReceiveDate); $temp.push("</td>");
            $temp.push("<td style='width:200px;text-align:left;'>"); $temp.push(ResultEnterydate); $temp.push("</td>");
            $temp.push("<td style='width:200px;text-align:left;'>"); $temp.push(ProvisionalDispatchDate); $temp.push("</td>");
            $temp.push("</tr>");
            $temp.push("</table>");
            $temp.push("</div>");
            $temp = $temp.join("");
            $('#sampledate').append($temp);
            $('#sampledate').css({ 'top': mouseY, 'left': mouseX }).show();
        }


        function hideme() {

            $('#sampledate').hide();
        }

        $(document).ready(function () {
            // ManageDivHeight();
            $('#MainInfoDiv').hide();
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
            $('#divPatient').removeClass('vertical');
            $('#divPatient').addClass('horizontal');
            // $('#divPatient').css('height', '450px');
            $('#MainInfoDiv').hide();
            $('.btnDiv').hide();
            $('#btnSide').hide();
            $('#btnUpdateBarcodeInfo').show();
                <%}%>

            UpdateSampleStatus();

            modal = document.getElementById('myModal');
            // Get the button that opens the modal

            // Get the <span> element that closes the modal
            span = document.getElementsByClassName("close")[0];
            // When the user clicks on the button, open the modal 
            //btn.onclick = function () {
            //    modal.style.display = "block";
            //}
            // When the user clicks on <span> (x), close the modal
            span.onclick = function () {
                modal.style.display = "none";
            }
            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        });
        function ManageDivHeight() {
            $('#divInvestigation').removeClass('vertical');
            $('#divPatient').removeClass('vertical');
            $('#divInvestigation').addClass('horizontal');
            $('#divPatient').addClass('horizontal');
        }
        function $getSearchData() {            
            var $dataLab = new Array();
            $dataLab.push({
                SearchType: $('#<%=ddlSearchType.ClientID%>').val(),
                SearchValue: $('#<%=txtSearchValue.ClientID%>').val(),
                Department: $('#<%=ddlDepartment.ClientID%>').val(),
                FromDate: $('#<%=txtFormDate.ClientID%>').val(),
                FromTime: $('#<%=txtFromTime.ClientID%>').val(),
                ToDate: $('#<%=txtToDate.ClientID%>').val(),
                ToTime: $('#<%=txtToTime.ClientID%>').val(),
                Investigation: $('#<%=ddlinvestigation.ClientID%> option:selected').val(),
            });
            return $dataLab;
        }
        function UpdateSampleStatus() {
            try {
                MYSampleStatus = elt.options[elt.selectedIndex].text;
            }
            catch (e) {
                MYSampleStatus = "Tested";
            }
            $('.SampleStatus').hide();
            if (MYSampleStatus == "Forwarded") {
                $('#btnApprovedLabObs').show();
                $('#btnUnForwardLabObs').show();

            }

        }

        var
                        data,
                        container1,
                        hot1;

        function SearchSampleCollection(flag) {            
            var _Flag = flag;
            var department = $('#<%=ddlDepartment.ClientID%>').val();
            if (department == 0 && $("#<%=txtSearchValue.ClientID %>").val() == "") {
               
                toast("Error", "Please select department!!", "");              
                return false;
            }    
       
            _PageNo = 0;
                                                                  
            $('#divPatient').show();
            $('#MainInfoDiv').hide();

            $('#btnSave').hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
            $('.demo').attr('disabled', true);
                      
            $("#btnSearch").attr('disabled', 'disabled').val('Search');
            var $searchData = $getSearchData();

            serverCall('ApproveDispatch.aspx/PatientSearch', { searchData: $searchData, PageNo: _PageNo, PageSize: _PageSize, _Flag: _Flag }, function (response) {
                PatientData = JSON.parse(response);
                debugger;
                if (PatientData.status) {
                    
                    if (PatientData.response.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');

                        toast("Info", "No Record Found", "");
                    }
                    else {
                        PatientData = PatientData.response;
                        $("#divapprove").css("display", "block");
                        //UpdateSampleStatus();
                        currentRow = 1;
                        $("#<%=lblMsg.ClientID %>").text('');
                        $('#<%=lblTotalPatient.ClientID%>').text('Total Patient: ' + PatientData.length);
                        $('#btnUpdateBarcodeInfo').attr('disabled', false);
                        _PageNo = PatientData.length / _PageSize;
                        data = PatientData;
                        container1 = document.getElementById('divPatient');
                        hot1 = new Handsontable(container1, {
                            data: PatientData,
                            colHeaders: [
                           "S.No.", "<th><input type='checkbox' name='chkall' id='chkall' onclick='chkUncheck(this);' /></th>", "Patient Info.", "Lab No.", "Barcode No.", "Test Name", "Lab Observation", "Value", "MinValue", "MaxValue", "Unit"
                            ],
                            readOnly: true,
                            currentRowClassName: 'currentRow',
                            columns: [
                            { renderer: AutoNumberRenderer, width: '60px' },
                             { renderer: checkboxcreate },
                             { renderer: pname, width: '160px' },
                              { renderer: labno },
                            { renderer: barcodeno, width: '150px' },
                            { renderer: tooltipfun, width: '140px' },
                            { renderer: Observationname },
                         { renderer: colorfun, width: '140px' },
                         { data: 'MinValue' },
                          { data: 'MaxValue' },
                         { data: 'readingFormat' },

                            //{ data: 'colledate'  },
                            //{ data: 'DATE' },
                            //{ data: 'ResultEnteredDate' },
                            //{ renderer: checkboxcreate },

                            ],

                            stretchH: "all",
                            autoWrapRow: false,
                            manualColumnFreeze: true,
                            fillHandle: false,
                            renderAllRows: true,
                            // rowHeaders: true,

                            cells: function (row, col, prop) {
                                var cellProperties = {};
                                cellProperties.className = PatientData[row].Status;
                                return cellProperties;
                            },
                            beforeChange: function (change, source) {
                                updateRemarks(change);
                            }
                        });

                        hot1.render();
                        //hot1.selectCell(0, 0);
                        $("#btnSearch").removeAttr('disabled').val('Search');


                        //return;
                    }
                    var myval = "";
                    if (_PageNo > 1 && _PageNo < 50) {

                        for (var j = 0; j < _PageNo; j++) {
                            var me = parseInt(j) + 1;
                            myval += '<a id="anch' + me + '" style="padding:2px;font-weight:bold;color:blue;" href="javascript:void(0);" onclick="show(\'' + j + '\');"  >' + me + '</a>';

                        }
                    }
                    else if (_PageNo > 50) {

                        for (var j = 0; j < 50; j++) {
                            var me = parseInt(j) + 1;
                            myval += '<a style="padding:2px;font-weight:bold;" href="javascript:void(0);" onclick="show(\'' + j + '\');"  >' + me + '</a>';

                        }
                        myval += '&nbsp;&nbsp;<select onchange="shownextrecord()" id="myddl">';
                        myval += '<option value="Select">Select Page</option>';
                        for (var j = 50; j < _PageNo; j++) {
                            var me = parseInt(j) + 1;
                            myval += '<option value="' + j + '">' + me + '</option>';

                        }
                        myval += "</select>";
                    }
                }
                else {
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    $('#divPatient').html('');
                    $('#<%=lblTotalPatient.ClientID%>').text('');
                    $('#btnUpdateBarcodeInfo').attr('disabled', true);
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    toast("Error", PatientData.response, "");
                }
             });           
        }

        // test bind
        function BindTest() {
            if (($('#<%=chkPanel0.ClientID%>').prop('checked') == true)) {
                var DepartmentID = $('#<%=ddlDepartment.ClientID%>').val();
                var $ddlInvestigation = $("#<%=ddlinvestigation.ClientID %>");
                $("#<%=ddlinvestigation.ClientID %> option").remove();
                $ddlInvestigation.append($("<option></option>").val("").html(""));
                serverCall('ApproveDispatch.aspx/GetTestMaster', { DepartmentID: DepartmentID }, function (response) {
                    $ddlInvestigation.bindDropDown({ data: JSON.parse(response), valueField: 'testid', textField: 'testname', isSearchAble: true, defaultValue: '', defaultDataValue: '' });
                });
            }
            else {
                $("#ddlinvestigation option").remove();
                $("#ddlinvestigation").trigger('chosen:updated');

            }
        };

        function SearchSampleCollectionpagging(pageno) {          
                         
            $('#divPatient').show();
            $('#MainInfoDiv').hide();
            $('#btnSave').hide();
            $('#divPatient').html('');
            $('#divInvestigation').html('');
            $('.demo').attr('disabled', true);
            var _Flag = 'A';          
          
            $("#btnSearch").attr('disabled', 'disabled').val('Search');
            var $searchData = $getSearchData();
            serverCall('ApproveDispatch.aspx/PatientSearch', { searchData: $searchData, PageNo: _PageNo, PageSize: _PageSize, _Flag: _Flag }, function (response) {
                 PatientData = JSON.parse(response);
                $('.SampleStatus').hide();
                $('.SampleStatus').attr('disabled', true);

                if (PatientData.status) {                   
                    if (PatientData.response.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').text('');
                        $('#btnUpdateBarcodeInfo').attr('disabled', true);
                        $("#btnSearch").removeAttr('disabled').val('Search');                        
                        $('#PagerDiv1').html('');
                        toast("Info", "No Record Found", "");
                    }
                    else {
                        PatientData = PatientData.response;
                        UpdateSampleStatus();
                        currentRow = 1;                        
                        $('#<%=lblTotalPatient.ClientID%>').text('Total Patient: ' + PatientData.length);
                        $('#btnUpdateBarcodeInfo').attr('disabled', false);
                        
                        data = PatientData;
                        container1 = document.getElementById('divPatient');
                        hot1 = new Handsontable(container1, {
                            data: PatientData,
                            colHeaders: [
                     "S.No.", "<th><input type='checkbox' name='chkall' id='chkall' onclick='chkUncheck(this);' /></th>", "Patient Info", "Lab No.", "Barcode No.", "Test Name", "Lab Observation", "Value", "MinValue", "MaxValue", "Unit"
                            ],
                            readOnly: true,
                            currentRowClassName: 'currentRow',
                            //copyPaste: false,
                            columns: [

                            { renderer: AutoNumberRenderer, width: '60px' },
                            { renderer: checkboxcreate },
                            { renderer: pname, width: '150px' },
                            { renderer: labno },
                            { renderer: barcodeno, width: '150px' },
                            { renderer: tooltipfun, width: '140px' },
                            { renderer: Observationname, },
                            { renderer: colorfun, width: '140px' },
                            { data: 'MinValue' },
                            { data: 'MaxValue' },
                            { data: 'readingFormat' },
                        //{ data: 'colledate' },
                            //{ data: 'DATE' },
                            //{ data: 'ResultEnteredDate' },

                            ],
                            stretchH: "all",
                            autoWrapRow: false,
                            manualColumnFreeze: true,
                            fillHandle: false,
                            renderAllRows: true,
                            // rowHeaders: true,
                            cells: function (row, col, prop) {
                                var cellProperties = {};
                                cellProperties.className = PatientData[row].Status;
                                return cellProperties;
                            },
                            beforeChange: function (change, source) {
                                updateRemarks(change);
                            }
                        });
                        hot1.render();
                        hot1.selectCell(0, 0);
                        $("#btnSearch").removeAttr('disabled').val('Search');
                    }
                }
                else {
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    $('#divPatient').html('');
                    $('#<%=lblTotalPatient.ClientID%>').text('');
                    $('#btnUpdateBarcodeInfo').attr('disabled', true);
                    $("#btnSearch").removeAttr('disabled').val('Search');
                    toast("Error", PatientData.response, "");
                }
            });            
        }
        function chkUncheck(ctrl) {
            var morecheckbox = $(ctrl).attr("class");
            if ($(ctrl).is(":checked")) {
                $(".mmchk").attr('checked', true);
            }
            else {

                $(".mmchk").attr('checked', false);
            }
        }
        function show(pageno) {
            SearchSampleCollectionpagging(pageno);
        }
        function shownextrecord() {
            var mm = $('#myddl option:selected').val();
            if (mm != "Select") {
                show(mm);
            }
        }
        function callPatientDetail(PTest_ID, PLeddNo) {
            var href = "../Lab/PatientSampleinfoPopup.aspx?TestID=" + PTest_ID + "&LabNo=" + PLeddNo;
            $.fancybox({
                maxWidth: 860,
                maxHeight: 800,
                fitToView: false,
                width: '80%',
                height: '70%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
            );
        }
        function callShowAttachment(PLeddNo) {
            var href = "../Lab/AddFileRegistration.aspx?labno=" + PLeddNo;
            $.fancybox({
                maxWidth: 860,
                maxHeight: 800,
                fitToView: false,
                width: '80%',
                height: '70%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
            );
        }
        function PatientDetail(instance, td, row, col, prop, value, cellProperties) {
            td.innerHTML = '<img  src="../../App_Images/view.GIF" style="border-style: none;cursor:pointer;" alt="" onclick="callPatientDetail(' + "'" + '' + PatientData[row].Test_ID + "'" + ',' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');">     </a>';
            td.className = PatientData[row].Status;
            return td;
        }
        function ShowAttachment(instance, td, row, col, prop, value, cellProperties) {
            var MyStr1 = "";
            if (PatientData[row].DocumentStatus != "") {               
                MyStr1 = MyStr1 + '<img  src="../../App_Images/attachment.png" style="border-style: none;width:20px;cursor:pointer;" alt="" onclick="callShowAttachment(' + "'" + '' + PatientData[row].LedgerTransactionNo + "'" + ');"></a>';
            }
            td.innerHTML = MyStr1;
            td.className = PatientData[row].Status;
            return td;
        }
        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML   
            if (PatientData[row].SampleLocation != '')
                td.innerHTML = MyStr + '<br/>' + PatientData[row].SampleLocation;
            else
                td.innerHTML = MyStr;			     

            if (((PatientData[row].Status == "Received") || (PatientData[row].Status == "MacData")) && PatientData[row].isrerun == "1") {
                $(td).parent().addClass('FullRowColorInRerun');

            }
            return td;
        }
        function EnableBarcode(instance, td, row, col, prop, value, cellProperties) {
                <%if (Util.GetString(Request.QueryString["cmd"]) == "changebarcode")
                  {%>
                cellProperties.readOnly = false;
            <%}%>
                td.innerHTML = value;
                td.className = PatientData[row].Status;
                return td;
            }
            function PrintreportRenderer(instance, td, row, col, prop, value, cellProperties) {
                if (PatientData[row].Approved == "1") {
                    td.innerHTML = '<a href="labreportnew.aspx?IsPrev=1&TestID=' + PatientData[row].Test_ID + ',&Phead=0" target="_blank" > <img  src="../../App_Images/print.gif" style="border-style: none" alt="">     </a>';
                }
                else {
                    td.innerHTML = '<span>&nbsp;</span>';
                }
                td.className = PatientData[row].Status;
                return td;
            }
            // data: 'PName'
            function pname(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                if (row > 0) {
                    if (PatientData[row].PName != PatientData[row - 1].PName) {
                        td.innerHTML = '<div>' + PatientData[row].PName + '</div>';
                    }
                    else if (PatientData[row].LedgerTransactionNo != PatientData[row - 1].LedgerTransactionNo) {
                        td.innerHTML = '<div>' + PatientData[row].PName + '</div>';
                    }

                    else {
                        td.innerHTML = '<div></div>';
                    }

                }
                else {
                    td.innerHTML = '<div>' + PatientData[row].PName + '</div>';
                }
            }
            function labno(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                if (row > 0) {
                    if (PatientData[row].LedgerTransactionNo != PatientData[row - 1].LedgerTransactionNo) {
                        td.innerHTML = '<div>' + PatientData[row].LedgerTransactionNo + '     </a></div>';//<br /><img title="Old/Previous Report" src="../../App_Images/view.GIF" style="border-style: none;cursor:pointer;"  onclick="OldPatient(\'' + PatientData[row].LedgerTransactionNo + '\');">
                    }

                    else {
                        td.innerHTML = '<div></div>';
                    }

                }
                else {
                    td.innerHTML = '<div>' + PatientData[row].LedgerTransactionNo + '     </a></div>';//<img title="Old/Previous Report" src="../../App_Images/view.GIF" style="border-style: none;cursor:pointer;"  onclick="OldPatient(\'' + PatientData[row].LedgerTransactionNo + '\');">
                }
            }
            function barcodeno(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                if (row > 0) {
                    if (PatientData[row].BarcodeNo != PatientData[row - 1].BarcodeNo) {
                        td.innerHTML = '<div>' + PatientData[row].BarcodeNo + '</div>';
                    }
                    else {
                        td.innerHTML = '<div></div>';
                    }
                }
                else {
                    td.innerHTML = '<div>' + PatientData[row].BarcodeNo + '</div>';
                }
            }
            function OldPatient(LedgertransactionNo) {
                window.open('DoctorPatientLabSearch.aspx?LedgertransactionNO=' + LedgertransactionNo + ' ')
            }
            function checkboxcreate(instance, td, row, col, prop, value, cellProperties) {
                if (row > 0) {
                    if (PatientData[row].test_id != PatientData[row - 1].test_id) {
                        if (PatientData[row].Approved == '0') {
                            var escaped = Handsontable.helper.stringify(value);
                            td.innerHTML = '<input type="checkbox" id="mmchk" class="mmchk"    value="' + PatientData[row].test_id + '"  data="' + PatientData[row].test_id + '" />';
                        }
                    }
                    else {
                        if (PatientData[row].Approved == '0') {
                            var escaped = Handsontable.helper.stringify(value);
                            td.innerHTML = "";//'<input type="checkbox" id="mmchk"    value="' + PatientData[row].test_id + '"  data="' + PatientData[row].test_id + '" />';
                        }
                    }
                }
                else {
                    if (PatientData[row].Approved == '0') {
                        var escaped = Handsontable.helper.stringify(value);
                        td.innerHTML = '<input type="checkbox" id="mmchk" class="mmchk"   value="' + PatientData[row].test_id + '"  data="' + PatientData[row].test_id + '" />';
                    }
                }
                return td;
            }
            function colorfun(instance, td, row, col, prop, value, cellProperties) {
                if (parseFloat(PatientData[row].MinCritical) != 0 && parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinCritical)) {

                    if (parseFloat(PatientData[row].reporttype) == 1) {
                        td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';			
                        td.style.backgroundColor = '#deb887';
                    }
                }
                else if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxCritical) && parseFloat(PatientData[row].MaxCritical) != 0) {
                    if (parseFloat(PatientData[row].reporttype) == 1) {
                        td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
                        td.style.backgroundColor = '#ff0000';
                    }
                }
                else if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue)) {
                    td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
                    td.style.backgroundColor = 'pink';
                }
                else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue)) {
                    td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
                    td.style.backgroundColor = 'yellow';
                }
                else {
                    td.style.backgroundColor = 'White';
                    td.innerHTML = '<a id="anchtool" style="color:black;"   >' + PatientData[row].Value + '</a>';
                }
                return td;
            }
            function Observationname(instance, td, row, col, prop, value, cellProperties) {
                td.innerHTML = '<span style="cursor:pointer;height:100px;width:100px;"  onmouseover="showdelta(' + PatientData[row].test_id + ',' + PatientData[row].LabObservation_ID + ')" onmouseout="hidedelta()"><img style="width:15px;height:15px;" src="../OnlineLab/Images/delta.png"/></span>   <a id="anchtool" style="font-weight:bold;color:black;"   >' + PatientData[row].Test + '</a> ';

                td.style.width = '200px';
                td.style.position = 'relative';
                $(td).addClass(cellProperties.className);
            }
            function showdelta(testid, labobserid) {
                var url = "../../Design/Lab/DeltaCheck.aspx?TestID=" + testid + "&LabObservation_ID=" + labobserid;

                $('#deltadiv').load(url);
                $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
            }
            function hidedelta() {
                $('#deltadiv').hide();
            }

            function tooltipfun(instance, td, row, col, prop, value, cellProperties) {
                var escaped = Handsontable.helper.stringify(value);
                if (row > 0) {
                    if (PatientData[row].InvestigationName != PatientData[row - 1].InvestigationName) {
                        var oldinvestigationname = "";
                        if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))
                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                        else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                        else
                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                        
                        td.style.width = '200px';
                        td.style.position = 'relative';
                        $(td).addClass(cellProperties.className);
                    }
                    else if (PatientData[row].LedgerTransactionNo != PatientData[row - 1].LedgerTransactionNo) {
                        var oldinvestigationname = "";
                        if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))

                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                        else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                        else
                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                        
                        td.style.width = '200px';
                        td.style.position = 'relative';
                        $(td).addClass(cellProperties.className);
                    }
                    else {
                        if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))
                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')"  ></a>';
                        else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')"  ></a>';

                        else
                            td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')"  ></a>';
                        td.style.width = '200px';
                        td.style.position = 'relative';
                        $(td).addClass(cellProperties.className);
                    }
                }
                else {
                    if (parseFloat(PatientData[row].Value) > parseFloat(PatientData[row].MaxValue))
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    else if (parseFloat(PatientData[row].Value) < parseFloat(PatientData[row].MinValue))
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    else
                        td.innerHTML = '<a id="anchtool" style="font-weight:bold;" onmouseover="getme(\'' + PatientData[row].colledate + '\',\'' + PatientData[row].DATE + '\',\'' + PatientData[row].ResultEnteredDate + '\', \'' + PatientData[row].ProvisionalDispatchDate + '\')" onmouseout="hideme()" >' + PatientData[row].InvestigationName + '</a>';
                    td.style.width = '200px';
                    td.style.position = 'relative';
                    $(td).addClass(cellProperties.className);
                }
                return td;
            }

            var rowIndx = "";
            function PickRowData(rowIndex) {
                rowIndx = rowIndex;
                currentRow = rowIndex;
            }
            function PicSelectedRow() {
                PickRowData(rowIndx);
            }
            function PreLabObs() {
                var minRows = 0;
                if (currentRow > minRows) {
                    PickRowData(currentRow - 1);

                }
                else { $('#btnPreLabObs').attr("disabled", true); }
            }
            function NextLabObs() {
                var totalRows = PatientData.length - 1;
                if (totalRows > currentRow) {
                    PickRowData(currentRow + 1);
                }
                else { $('#btnNextLabObs').attr("disabled", true); alert('No more rows available'); }
            }         
            function ApproveDispatchAll() {
                if ($('#<%=ddlApprove.ClientID%>').val() == '0') {                    
                    toast("Error", "Please Select Doctor !!", "");
                    return;
                }
                var test_id = "";
                if ($("input:checkbox[id=mmchk]:checked")) {
                    $("input:checkbox[id=mmchk]:checked").each(function () {
                        test_id += $(this).val() + ',';
                    });
                }
                if (test_id == "") {                    
                    toast("Error", "Please Select Test To Approve & Dispatch", "");
                    return;
                }
                SaveLabObs(test_id);
            }        
        function SaveLabObs(test_id) {
            resultStatus = "Approved"
            serverCall('ApproveDispatch.aspx/SaveLabObservationOpdData', { Testid: test_id, ResultStatus: resultStatus, ApprovedBy: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%>').val() : ''), ApprovalName: (($('#<%=ddlApprove.ClientID%>').length > 0) ? $('#<%=ddlApprove.ClientID%> :selected').text() : '') }, function (response) {
                var $responseData = JSON.parse(response);
                $('.btnDiv').children().attr("disabled", "disabled");
                criticalsave = "0";
                macvalue = "0";
                if ($responseData.status) {
                    toast("Success", "Approved and Dispatched Successfully ...", "");
                    var totalRows = PatientData.length - 1;
                    if (totalRows > currentRow) {
                        PickRowData(currentRow + 1);
                    }
                    else {
                        PickRowData(currentRow);
                    }
                    SearchSampleCollection('A')
                }
                else {
                    toast("Error", "Report not Approved...", "");
                }
            });              
        }       
    </script>
</asp:Content>
