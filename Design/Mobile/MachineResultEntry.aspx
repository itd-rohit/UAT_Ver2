<%@ Page Title="" Language="C#" MasterPageFile="~/Design/Mobile/Mobile.master" AutoEventWireup="true" CodeFile="MachineResultEntry.aspx.cs" Inherits="Design_Mobile_MachineResultEntry" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />
    <script src="bootstrap/js/jquery.bootpag.js"></script>
<%--    <script type="text/javascript" src="http://botmonster.com/jquery-bootpag/jquery.bootpag.js"></script>--%>

    <link href="bootstrap/data.css" rel="stylesheet" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
    <script src="bootstrap/js/knockout-3.4.2.js"></script>
    <style type="text/css">
        .Screen .filterDatemainDiv {
            padding: 0px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container-fluid pagecontainer MachineSearchResult">
        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pageheader">Search Result Entry</div>
        <div class="datacontainer">
            <div class="row Screen">

                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12" style="margin-top: 10px;">

                    <div class="form-group">
                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 controldiv">
                            <asp:DropDownList ID="ddlSearchType" CssClass="form-control textbox " runat="server" Width="100%">
                                <asp:ListItem Value="pli.BarcodeNo" Selected="True">SIN No.</asp:ListItem>
                                <asp:ListItem Value="lt.Patient_ID">UHID No.</asp:ListItem>
                                <asp:ListItem Value="pli.LedgerTransactionNo">Visit No.</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8 controldiv">
                            <asp:TextBox ID="txtSearchValue" CssClass="form-control textbox " runat="server"></asp:TextBox>
                            <asp:HiddenField ID="txtFromTime" runat="server" />
                            <asp:HiddenField ID="txtToTime" runat="server" />
                            <asp:HiddenField ID="CentreAccess" runat="server" />

                        </div>
                    </div>


                </div>
                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label for="concept" class="col-lg-4 col-md-4 col-sm-4 col-xs-12 control-label">Patient type:</label>
                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12 controldiv">
                            <asp:DropDownList ID="ddlSampleStatus" class="form-control textbox" Width="100%" runat="server">
                                <asp:ListItem Value="  and pli.isSampleCollected<>'N' ">All Patient</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_flag=0  and pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ">Pending</asp:ListItem>
                                <asp:ListItem Value=" and pli.isSampleCollected='S' and pli.Result_flag=0 ">Sample Collected</asp:ListItem>
                                <asp:ListItem Value=" and pli.isSampleCollected='Y' and pli.Result_flag=0 ">Sample Receive</asp:ListItem>
                                <asp:ListItem Value=" and  pli.Result_Flag='0'  and pli.isSampleCollected<>'R'  and (select count(*) from mac_data md where md.Test_ID=pli.Test_ID  and md.reading<>'')>0 ">Machine Data</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_flag=1 and pli.approved=0 and pli.ishold='0'  and pli.isSampleCollected<>'R' ">Tested</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_flag=1 and pli.isForward=1 and pli.Approved=0  and pli.isSampleCollected<>'R' ">Forwarded</asp:ListItem>
                                <asp:ListItem Value=" and pli.Result_flag=0 and pli.isrerun=1 and  pli.isSampleCollected<>'N'  and pli.isSampleCollected<>'R' ">ReRun</asp:ListItem>
                                <asp:ListItem Value=" and pli.Approved=1 and pli.isPrint=0 and pli.isSampleCollected<>'R' ">Approved</asp:ListItem>
                                <asp:ListItem Value=" and pli.isHold='1'  ">Hold</asp:ListItem>
                                <asp:ListItem Value=" and pli.isPrint=1  and pli.isSampleCollected<>'R' ">Printed</asp:ListItem>
                                <asp:ListItem Value=" and pli.isSampleCollected='R'  ">Rejected Sample</asp:ListItem>
                                <%--<asp:ListItem  Value=" and pli.Preliminary='1' and  pli.Approved=0   and pli.isPrint=0  ">Preliminary report</asp:ListItem>--%>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5 col-md-5 col-sm-12 col-xs-12 filterDatemainDiv">
                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                        <div class="form-group">
                            <label for="concept" class="col-lg-4 col-md-4 col-sm-4 col-xs-12 control-label">Form Date:</label>
                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12 controldiv">
                                <asp:TextBox ID="txtFormDate" CssClass="form-control textbox datepicker" Style="background-color: #fff;" runat="server" ReadOnly="true"></asp:TextBox>

                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                        <div class="form-group">
                            <label for="concept" class="col-lg-4 col-md-4 col-sm-4 col-xs-12 control-label">To Date:</label>
                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12 controldiv">

                                <asp:TextBox ID="txtToDate" CssClass="form-control textbox datepicker" Style="background-color: #fff;" runat="server" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-12 button-box">
                    <input id="btnSearch" type="button" value="Search" class="btn btn-default submit-btn" data-bind="click: Search" />
                    <input id="btnback" type="button" value="Back" class="btn btn-default submit-btn" onclick="Back()" />
                </div>
            </div>

            <div class="row tableScreen">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 paging-section ">
                        <div class="page-selection"></div>
                    </div>
                    <div class="datagrid col-lg-12 col-md-12 col-sm-12 col-xs-12" style="padding: 0;">
                        <table class="table-vertical" id="tb_ItemList">
                            <thead>
                                <tr>
                                    <th>S.No</th>
                                    <th>Visit No</th>
                                    <th>SIN No</th>
                                    <th>UHID No</th>
                                    <th>Patient Name</th>
                                    <th>Age/Sex</th>
                                    <th>Test</th>
                                    <th>Status</th>
                                    <th>Print</th>
                                </tr>
                            </thead>
                            <tbody data-bind="foreach: paginated">
                                <tr data-bind="css:Status,attr:{'index':$index(),'SinNo':BarcodeNo,'PName':PName,'Age_Gender':Age_Gender,'LedgerTransactionNo':LedgerTransactionNo,'Test_ID':Test_ID,'Gender':Gender,'AGE_in_Days':AGE_in_Days}">
                                    <td data-th="S.No." data-bind='text:($index()) + 1 '></td>
                                    <td data-th="Visit No"><a href="#" class="row-click" ><b data-bind='text:LedgerTransactionNo'></b></a></td>
                                    <td data-th="SIN No"><b data-bind='text:BarcodeNo'></b></td>
                                    <td data-th="UHID No"><b data-bind='text:Patient_ID'></b></td>
                                    <td data-th="Patient Name"><b data-bind='text:PName'></b></td>
                                    <td data-th="Age/Sex"><b data-bind='text:Age_Gender'></b></td>
                                    <td data-th="Test"><b data-bind='text:Test'></b></td>
                                    <td data-th="Status"><b data-bind='text:Status'></b></td>

                                    <!-- ko if: Approved=='1' -->
                                    <td data-th="Print"><a href="labreportnew.aspx?IsPrev=1&TestID=' + PatientData[i].Test_ID + ',&Phead=0" target="_blank">
                                        <img src="../../App_Images/print.gif" style="border-style: none" alt=""/></a></td>
                                    <!-- /ko -->
                                    <!-- ko if: Approved!='1' -->
                                    <td data-th="Print">&nbsp;</td>
                                    <!-- /ko -->
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 bottom-paging-section ">
                        <div class="page-selection"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript"> 
        var CenterID;
        $(function()
        {
            var _centerID = $("#<%=CentreAccess.ClientID%>").val(); 
            CenterID = (_centerID == '' || _centerID == null) ? "ALL" : _centerID; 
            function AppViewModel() {
                var self = this;
                self.PatientRecord = ko.observableArray([]); 
                this.pageNumber = ko.observable(1);
                this.nbPerPage = 5;
                this.totalPages = ko.computed(function () {
                    var div = Math.floor(self.PatientRecord().length / self.nbPerPage);
                    div += self.PatientRecord().length % self.nbPerPage > 0 ? 1 : 0;
                   
                    return div;
                });

                this.GetModelsByAjax = function () {
                    var SearchType = $("#<%=ddlSearchType.ClientID %>").val();
                    var SearchValue = $("#<%=txtSearchValue.ClientID %>").val();
                    console.log('call');
                    $.ajax({
                        url: "../Lab/MachineResultEntry.aspx/PatientSearch",
                        data: '{ SearchType: "' + SearchType + '",SearchValue:"' + SearchValue + '",FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",CentreID:"' + CenterID + '",SmpleColl:"' + $("#<%=ddlSampleStatus.ClientID%>").val() + '",Department:"",MachineID:"ALL",ZSM:"' + null + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",TimeTo:"' + $("#<%=txtToTime.ClientID%>").val() + '",isUrgent:"0",InvestigationId:"' + null + '",PanelId:"' + null + '", SampleStatusText:"' + $('#<%=ddlSampleStatus.ClientID %> option:selected').text() + '",chremarks:"0",chcomments:"0"}', // parameter map 
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            var PatientData = $.parseJSON(result.d);
                            self.PatientRecord(PatientData);                             
                            $('.page-selection').bootpag({
                                total: self.totalPages(),
                                page: self.pageNumber(),
                                maxVisible: 5,
                                leaps: true,
                                firstLastUse: true,
                                first: '←',
                                last: '→',
                                wrapClass: 'pagination',
                                activeClass: 'active',
                                disabledClass: 'disabled',
                                nextClass: 'next',
                                prevClass: 'prev',
                                lastClass: 'last',
                                firstClass: 'first'
                            }).on("page", function (event, num) {
                       
                                self.pageNumber(num);
                            });

                        }

                    });
                };
            
                self.Search = function () {
                    CenterID = "ALL";
                    $("#<%=CentreAccess.ClientID%>").val(CenterID);
                    this.GetModelsByAjax();
                }

                this.paginated = ko.computed(function () {
                    var pagenum=  self.pageNumber()-1;
                    var first = pagenum * self.nbPerPage;
               
                    return self.PatientRecord.slice(first, first + self.nbPerPage);

                });

                this.GetModelsByAjax();
            
            }
            var ViewModel = new AppViewModel()
            ko.applyBindings(ViewModel);
        });
    </script>


    <script type="text/javascript">
        $(document).ready(function () {
            
            $(".datepicker").datepicker({ dateFormat: 'dd-M-yy' });
            $('#<%=txtSearchValue.ClientID%>').keypress(function (ev) {

                if (ev.which === 13) {
                }
                 
            });
        });
    </script>


 
    <script type="text/javascript"> 
        $(function () {
            $(document).on('click', '.row-click', function () {
                var e = this;
                $('body').wait();
                var PName = $(e).closest("tr").attr("PName");
                var Age_Gender = $(e).closest("tr").attr("Age_Gender");
                var SinNo = $(e).closest("tr").attr("SinNo");
                var CenterID = $("#<%=CentreAccess.ClientID%>").val();
                var index = $(e).closest("tr").attr("index");              
                setTimeout(function () {
                   var url = "MachineEntry.aspx?index=" + index + "&PName=" + PName + "&AgeGender=" + Age_Gender + "&SinNo=" + SinNo + "&SearchType=" + $("#<%=ddlSearchType.ClientID %>").val() + "&SearchValue=" + $("#<%=txtSearchValue.ClientID %>").val() + "&FromDate=" + $("#<%=txtFormDate.ClientID %>").val() + "&ToDate=" + $("#<%=txtToDate.ClientID %>").val() + "&CentreID=" + CenterID + "&SmpleColl=" + $("#<%=ddlSampleStatus.ClientID%>").val() + "&TimeFrm=" + $("#<%=txtFromTime.ClientID%>").val() + "&TimeTo=" + $("#<%=txtToTime.ClientID%>").val() + "&SampleStatusText=" + $('#<%=ddlSampleStatus.ClientID %> option:selected').text() + "";
              $(location).attr('href', url);
               $('body').unwait();
           }, 1000);
            });


        });


   function Back() {
       $('body').wait();
       var fromdate = '<%=Request.QueryString["fromdate"] %>';
            var fromtime = '<%=Request.QueryString["fromtime"] %>';
            var todate = '<%=Request.QueryString["todate"] %>';
            var totime = '<%=Request.QueryString["totime"] %>';
            var centre = '<%=Request.QueryString["centre"] %>';
            var department = '<%=Request.QueryString["department"] %>';
            var scentre = '<%=Request.QueryString["scentre"] %>';
            var sdepartment = '<%=Request.QueryString["sdepartment"] %>';

            setTimeout(function () {

                window.location.href = "testApprovalScreen.aspx?fromdate=" + fromdate + "&fromtime=" + fromtime + "&todate=" + todate + "&totime=" + totime + "&centre=" + centre + "&department=" + department + "&scentre=" + scentre + "&sdepartment=" + sdepartment + "";
                $('body').unwait();
            }, 1000);

        }
    </script>





</asp:Content>

