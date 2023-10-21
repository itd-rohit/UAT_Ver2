<%@ Page Title="" Language="C#" MasterPageFile="~/Design/Mobile/Mobile.master"  AutoEventWireup="true" CodeFile="MachineEntry.aspx.cs" Inherits="Design_Mobile_MachineEntry" %>
<%--<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
   
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

        <link href="bootstrap/js/jquery.wait-overlay.css" rel="stylesheet" />
    <script src="bootstrap/js/jquery.wait-overlay.js"></script>
    <script src="bootstrap/js/knockout-3.4.2.js"></script>
 <%--    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>--%>
     
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <%--<Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>--%>

    <div class="container pagecontainer MachineEntry">
        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pageheader">
            
            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 heading">Result Entry</div>
            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8 nopadding Userdetl">
                <div class="row">
                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"> 
                    SIN NO.
            </div>
                 <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8"> 
                     <span  data-bind="text: BarcodeNo"> </span>
            </div>
                    </div>
                <div class="row">
                  <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4"> 
                    PName.
            </div>
                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8"> 
                    <span  data-bind="text: PName"></span>
            </div>
                </div>
                <div class="row">
                  <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">  
                    Age/Gender.
            </div>
                 <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                  <span  data-bind="text: Age_Gender"></span>
            </div>
            </div>
            </div>
        </div>

        <div class="datacontainer" data-bind="visible: people().length > 0">
            <div class="row tableScreen">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 table-div" id="PatientDataOutput"> 
                     <div class="panel panel-success"> 
                           <input type="hidden" id="testid" value="" />  
                       <table class="table entrytable" id="EntryTable">
                           <thead>
                               <tr>
                                   <th class="col-lg-7 col-md-7 col-sm-7 col-xs-6">Test</th>
                                   <th class="col-lg-3 col-md-3 col-sm-3 col-xs-3">Value</th>
                                   <th class="col-lg-3 col-md-3 col-sm-3 col-xs-3">Ref.int.</th>

                               </tr>
                           </thead>
                           <tbody>
                                <tr> 
                                    <td colspan="3" style="padding:0;" data-bind="foreach: people"> 
                                        <!-- ko if: Inv=='1' -->  
                                                                                    
                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 TestName-box">
                                             <!-- ko if: LabObservationName.indexOf('RERUN') -->
                                                 <h3 class="col-xs-8 TestName-title" data-bind="text: LabObservationName" style="color:#F781D8"></h3> 
                                                 <!-- /ko -->
                                            <!-- ko ifnot:LabObservationName.indexOf('RERUN') -->
                                             <h3 class="col-xs-8 TestName-title" data-bind="text: LabObservationName"></h3> 
                                             <!-- /ko --> 
                                             <!-- ko if:$parent.RerunStatus()=='Pending' || $parent.RerunStatus()=='ReRun' || $parent.RerunStatus()=='Tested' || $parent.RerunStatus()=='Machine Data' --> 
                                            
                                            <input id="btnrerun" type="button" value="ReRun" data-bind="attr:{'Test_ID':PLIID,'LedgerTransactionNo':LabNo}" class="btn btn-default  col-xs-4 ReRun" />
                                    <!-- /ko --> 
                                        </div>
                                             
                                          <!-- /ko -->
                                  <!-- ko if: Inv!='1' &&  Inv!='3' &&  Inv!='4' -->                                                               
                                     <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 row-box">                                         
                                         <!-- ko if: LabObservationName!='Comments' -->                                          
                                         <!-- ko if:Value=='HEAD' -->
                                          <div class="row">                                             
                                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 TestName"><b> <span data-bind="text: LabObservationName"></span></b></div>
                                              </div>
                                          <!-- /ko -->
                                           <!-- ko if:Value!='HEAD' -->
                                         <div class="row">                                             
                                        <div class="col-lg-7 col-md-7 col-sm-7 col-xs-6 TestName"><span data-bind="text: LabObservationName"></span></div>
                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 Value Formula">                                           
                                            <input type="text" class="inputvalue" style="width:80%;"   data-bind="value: Value, attr: { 'id': LabObservation_ID,'minval':MinValue,'maxval':MaxValue }" />&nbsp;<span class="ValueStatus"> </span>
                                            <input id="hdnInv" type="hidden" data-bind="value: Inv" />
                                            <input id="hdnFormula" type="hidden"  data-bind="value: Formula" />
                                            <input id="hdnisCulture" type="hidden"   />
                                             <input id="hdnflag" type="hidden"  data-bind="value: Flag "  />
                                            <input id="hdnLabObservation_ID" type="hidden"  data-bind="value: LabObservation_ID"/>
                                             <input id="hdnInvestigation_ID" type="hidden"  data-bind="value: Investigation_ID "/>
                                            
                                          
                                        </div>
                                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-3 Average"> <span data-bind="text: MinValue"></span> - <span data-bind="text: MaxValue"></span> <span data-bind="text: ReadingFormat"></span></div>
                                        </div>
                                        <div class="row">
                                        <div class="col-lg-7 col-md-7 col-sm-7 col-xs-6 MethodName">Method : <span data-bind="text: Method"></span></div>
                                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 MachRead">Mac : <span data-bind="text: MacReading"></span></div>
                                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-3 Delta"><a href="#" class="deltalink" ="1" data-bind="attr:{'PLIID':PLIID,'LabObservation_ID':LabObservation_ID,'tuch':1}"><img src="images/delta.png" style="width:20px;" /> </a> </div>
                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 delta-data" style="display:none;">
                                      
                                            </div>                                            
                                             <!-- ko if: Description!='Comments' --> 
                                            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 row-coment">Comments : <span data-bind="text: Description"></span></div>
                                             <!-- /ko -->
                                        </div>
                                     <!-- /ko -->
                                       <!-- /ko -->

                                       <!-- ko if: LabObservationName=='Comments' -->    
                                         <div class="row Comments-row">
                                         <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 Comments">Coments</div>
                                         <div class="col-lg-9 col-md-9 col-sm-9 col-xs-9 CommentsInput"><input type="text" style="width:100%;" data-bind="value: Value" /></div>
                                        
                                       </div>
                                        <!-- /ko -->
                               
                                </div> 
                               <!-- /ko -->
                                    </td>
                                </tr>

                           </tbody>
                       </table>
                   </div>
                </div> 
            </div>
            <div class="row">
            <ul class="pager">
            <li class="previous"><a href="#" data-bind="click: previous, enable: hasPrevious">Previous</a></li>
                <li class="Print">
                    <a data-bind="attr:{'href':PdfUrl}" target="_blank">
                                        <img src="../../App_Images/print.gif" style="border-style: none" alt=""/></a>
                </li>
            <li class="next"><a href="#" data-bind="click: next, enable: hasNext"">Next</a></li>
            </ul>
            </div>
           <%-- <div class="row Result-Entry">
                <div class=" col-md-3 col-sm-3 col-xs-3">
                    <input id="btnSaveLabObs" type="button" value="Save" class="btn btn-default " onclick="Save();" style="display:none;" />
                </div>
                <div class=" col-md-3 col-sm-3 col-xs-3">
                    <input id="btnApprovedLabObs" type="button" value="Approved" class="btn btn-default "  onclick="Approved();" style="display:none;" />
                    <input id="btnNotApproveLabObs" type="button" value="NotApproved" class="btn btn-default " onclick="NotApproved();" style="display:none;" />
                </div>
                <div class=" col-md-3 col-sm-3 col-xs-3">
                    <input id="btnholdLabObs" type="button" value="Hold" class="btn btn-default " onclick="Hold()" style="display:none;" />
                    <input id="btnUnholdLabObs" type="button" value="UnHold" class="btn btn-default " onclick="UnHold();" style="display:none;" />
                </div>
                <div class=" col-md-3 col-sm-3 col-xs-3">
                    <input id="btnForwardLabObs" type="button" value="Forward" class="btn btn-default " onclick="Forward()" style="display:none;"  />
                    <input id="btnUnForwardLabObs" type="button" value="UnForward" class="btn btn-default " onclick="UnForward()" style="display:none;" />
                </div>
            </div>--%>
             <div class="row Result-Entry">
                <div class=" col-md-12 col-sm-12 col-xs-12" style="text-align:center; padding:0;">
                    <input id="btnSaveLabObs" type="button" value="Save" class="btn btn-default " onclick="Save();" style="display:none;" />
                  <%                  
                    if (ApprovalId == "")
                    { %>                           
            <%}
              else
                    {
                        if (ApprovalId == "1" || ApprovalId == "3" || ApprovalId == "4")
                        {%>
                    <input id="btnApprovedLabObs" type="button" value="Approved" class="btn btn-default "  onclick="Approved();" style="display:none;" />
                    <input id="btnholdLabObs" type="button" value="Hold" class="btn btn-default " onclick="Hold()" style="display:none;" />
                     <% if (ApprovalId == "4" || ApprovalId == "3")
                   {%>
                    <input id="btnNotApproveLabObs" type="button" value="Not Approved" class="btn btn-default " onclick="NotApproved();" style="display:none;" />
                
                   <%if (ApprovalId == "4")
                  { 
                  %>
                    <input id="btnUnholdLabObs" type="button" value="UnHold" class="btn btn-default " onclick="UnHold();" style="display:none;" />
                     <% }
                   }
                        }
                if (ApprovalId == "2" || ApprovalId == "3" || ApprovalId == "4")
                        {%>
                    <input id="btnForwardLabObs" type="button" value="Forward" class="btn btn-default " onclick="Forward()" style="display:none;"  />
                      <%}
                        %>
                    <input id="btnUnForwardLabObs" type="button" value="UnForward" class="btn btn-default " onclick="UnForward()" style="display:none;" />
                    <%

                    }%>
                </div>
            </div>
            
        </div>
         <div class="datacontainer" data-bind="visible: people().length <= 0" >
            <div class="row tableScreen">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 table-div">                     
                <div class="panel panel-success" style="text-align: center; min-height: 250px;background: #f2f2f2 !important; padding-top: 10%;">
                       
                   </div>
                    
                </div> 
            </div>
           
        </div>


    <div class="modal fade" id="forwordModal" role="dialog">
        <div class="vertical-alignment-helper">
  <div class="modal-dialog vertical-align-center">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title" >Forword Test</h4>
      </div>
      <div class="modal-body forword">
       
           <div class="row select-box">
          <div class="col-md-3 col-sm-3 col-xs-4">Select Test:</div>
          <div class="col-md-9 col-sm-9 col-xs-8"><asp:DropDownList ID="ddltest" runat="server" CssClass="form-control" Width="100%" onchange="bindcenter()"></asp:DropDownList></div>
            </div>
               <div class="row select-box">
                <div class="col-md-3 col-sm-3 col-xs-4">Select Centre:</div>
          <div class="col-md-9 col-sm-9 col-xs-8"><asp:DropDownList ID="ddlcentre" CssClass="form-control" runat="server" Width="100%" onchange="binddoctoforward()"></asp:DropDownList></div>
           </div>
                <div class="row select-box">
                <div class="col-md-3 col-sm-3 col-xs-4">Forward To:</div>
          <div class="col-md-9 col-sm-9 col-xs-8"><asp:DropDownList ID="ddlforward" CssClass="form-control" runat="server" Width="100%"></asp:DropDownList></div>
           </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" onclick="Forwardme()">Forword</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
</div>

<div class="modal fade" id="holdmodel" role="dialog">
        <div class="vertical-alignment-helper">
  <div class="modal-dialog vertical-align-center">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title" >Hold Test</h4>
      </div>
      <div class="modal-body Hold">
       
           <div class="row select-box">
          <div class="col-md-12 col-sm-12 col-xs-12">Remarks</div>
          <div class="col-md-12 col-sm-12 col-xs-12">
              <textarea id="txtHoldRemarks" cols="10" rows="10" style="width:100%" ></textarea>
          </div>
            </div>
               
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" onclick="Holdme()">Hold</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
            </div>
</div>

<div class="modal fade" id="notapprovedmodel" role="dialog">
  <div class="vertical-alignment-helper">
  <div class="modal-dialog vertical-align-center">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title" >Not Approved Remarks</h4>
      </div>
      <div class="modal-body Hold">
       
           <div class="row select-box">
          <div class="col-md-12 col-sm-12 col-xs-12">Remarks</div>
          <div class="col-md-12 col-sm-12 col-xs-12">
              <textarea id="txtNotApprovedRemarks" cols="10" rows="10" style="width:100%" ></textarea>
          </div>
            </div>
               
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" onclick="NotApproveSave()">Save</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
            </div>
</div>

<div class="modal fade" id="Criticalmodel" role="dialog">
        <div class="vertical-alignment-helper">
  <div class="modal-dialog vertical-align-center">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title" >Result Entry</h4>
      </div>
      <div class="modal-body msgCritical">
           
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" onclick="CriticalSave()">Yes</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
            </div>
</div> 
      <div class="ReRunData"></div>
        
    </div>

    <script type="text/javascript">
        var criticalsave = "0";
        var resultStatus = "";
        var magtitle = "";
        var message = "";
        //var MYSampleStatus;
        var SearchType = '<%=SearchType%>';
        var SearchValue = '<%=SearchValue%>';
        var FromDate = '<%=FromDate%>';
        var ToDate = '<%=ToDate%>';
        var CentreID = '<%=CentreID%>';
        var SmpleColl = "<%=SmpleColl%>";
        var TimeFrm = '<%=TimeFrm%>';
        var TimeTo = '<%=TimeTo%>';
        var SampleStatusText = '<%=SampleStatusText%>';
        msgtitle = "Result Entry";
        function AppViewModel() {
            $('body').wait();
            var self = this;
            self.PName = ko.observable();
            self.Age_Gender = ko.observable();
            self.BarcodeNo = ko.observable();
            self.Test_ID = ko.observable();
            self.LedgerTransactionNo = ko.observable();
            self.PdfUrl = ko.observable();
            self.Inv = ko.observable();
            self.Status = ko.observable();
            self.people = ko.observableArray([]);
            self.Allrecord = ko.observableArray([]);
            self.Name = ko.dependentObservable(function () {
                var name;
                ko.utils.arrayForEach(self.people(), function (item) {
                    if (item.Inv == "1") {
                        name = item.LabObservationName;
                    }
                });
                return name;
            }, this)

            $.ajax({
                url: "../Lab/MachineResultEntry.aspx/PatientSearch",
                data: '{ SearchType: "' + SearchType + '",SearchValue:"' + SearchValue + '",FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID:"' + CentreID + '",SmpleColl:"' + SmpleColl + '",Department:"",MachineID:"ALL",ZSM:"' + null + '",TimeFrm:"' + TimeFrm + '",TimeTo:"' + TimeTo + '",isUrgent:"0",InvestigationId:"' + null + '",PanelId:"' + null + '", SampleStatusText:"' + SampleStatusText + '",chremarks:"0",chcomments:"0"}', // parameter map 
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var allPatientData = jQuery.parseJSON(result.d);
                    self.Allrecord(allPatientData);
                    //  console.log(JSON.stringify(allPatientData));
                },
                error: function (xhr, status) {
                    alert('Please Contact to ItDose Support Team');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


            this.pageNumber = ko.observable(parseInt('<%=index%>'));
            this.nbPerPage = 1;
            this.totalPages = ko.computed(function () {
                var div = Math.floor(self.Allrecord().length / self.nbPerPage);
                div += self.Allrecord().length % self.nbPerPage > 0 ? 1 : 0;
                return div - 1;
            });


            this.paginated = ko.computed(function () {
                var first;

                first = self.pageNumber() * self.nbPerPage;

                var data = [];
                data = self.Allrecord.slice(first, first + self.nbPerPage);

                if (data != undefined && data.length > 0) {
                    self.PName(data[0].PName);
                    self.Age_Gender(data[0].Age_Gender);
                    self.BarcodeNo(data[0].BarcodeNo);
                    self.Test_ID(data[0].Test_ID);
                    self.Inv(data[0].Inv);
                    self.Status(data[0].Status);
                    self.RerunStatus=ko.observable('<%=Request.QueryString["SampleStatusText"]%>')


                    self.LedgerTransactionNo(data[0].LedgerTransactionNo);
                    $('#testid').val(data[0].Test_ID);
                    self.PdfUrl("labreportnew.aspx?IsPrev=1&TestID='" + data[0].Test_ID + "',&Phead=0");
                    $.ajax({
                        url: "../Lab/MachineResultEntry.aspx/LabObservationSearch",
                        data: '{LabNo:"' + data[0].LedgerTransactionNo + '",TestID:"' + data[0].Test_ID + '",AgeInDays:' + data[0].AGE_in_Days + ',Gender:"' + data[0].Gender + '",RangeType:"Normal",MachineID:"All",macId:""}',
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {
                            var PatientData = jQuery.parseJSON(result.d);
                            self.people([]);
                            self.people(PatientData); 
 valueChangeColor();

                           // ApplyFormula();
                            if (data[0].Status == "Received")
                                UpdateSampleStatus(self.RerunStatus());
                            else
                                UpdateSampleStatus(data[0].Status);
                           
                           
                        },
                        error: function (xhr, status) {
                            alert('Please Contact to ItDose Support Team');
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }


            });
            this.hasPrevious = ko.computed(function () {
                return self.pageNumber() !== 0;
            });
            this.hasNext = ko.computed(function () {
                return self.pageNumber() !== self.totalPages();
            });
            this.next = function () {
                if (!self.hasNext()) {
                    $("#msgtitle").html(msgtitle);
                    $('#massage').html('Record Not Found !');
                    $('#msgModal').modal('show');
                }
                else {
                    if (self.pageNumber() < self.totalPages()) {
                        self.pageNumber(self.pageNumber() + 1);
                    }
                }
            }

            this.previous = function () {
                if (!self.hasPrevious()) {
                    $("#msgtitle").html(msgtitle);
                    $('#massage').html('Record Not Found !');
                    $('#msgModal').modal('show');
                }
                else {
                    if (self.pageNumber() != 0) {
                        self.pageNumber(self.pageNumber() - 1);
                    }
                }
            }

        }
        var ViewModel = new AppViewModel()
        ko.applyBindings(ViewModel);

    </script>
 
     <script type="text/javascript">

         $(function () {

             $(document).on('keyup', '.inputvalue', function (e) {
                 var ID = $(this).attr("id");
                  
                 $(".Value").removeClass('Formula'); 
                 //$(this).closest(".Value").addClass('Formula');
                 $(this).closest(".row-box").nextAll().find('.Value').addClass('Formula');
                 var helpData = ko.utils.arrayFilter(ViewModel.people(), function (rec) {
                     return (rec.LabObservation_ID == ID);

                 });
                 if (helpData[0].Help != "") {
                     var helpArr = [];
                     var helpDropDown = [];
                     try {
                         helpArr = helpData[0].Help.split('|');
                         for (var i = 0; i < helpArr.length; i++) {
                             var arr = [];
                             arr = helpArr[i].split('#');
                             helpDropDown.push(arr[0]);
                         }
                     }
                     catch (e) {
                     }
                 }
                 if (helpDropDown != undefined) {
                     $(".inputvalue").autocomplete({
                         source: helpDropDown
                     });
                 }
                 setTimeout(function () {
                     //valueChangeColor();
                     ApplyFormula();
                 }, 1000);
                 
              
             });

             $(document).on('click', '.deltalink', function () {
                 var e = this;
                 var tuch = $(e).attr("tuch");
                 var LabObservation_ID = $(e).attr("LabObservation_ID");
                 var PLIID = $(e).attr("PLIID");

                 if (tuch == 1) {
                     var url = "../../Design/Mobile/DeltaCheck.aspx?TestID=" + PLIID + "&LabObservation_ID=" + LabObservation_ID;
                     $(e).closest('.row-box').find('.delta-data').load(url);
                     $(e).attr("tuch", 0)
                     $(e).closest('.row-box').find('.delta-data').fadeToggle(1000);
                 }
                 else {
                     $(e).attr("tuch", 1)
                     $(e).closest('.row-box').find('.delta-data').fadeToggle(1000);
                 }
             });
         });

         function ApplyFormula() {

             $('#EntryTable tr .row-box .Value ').each(function () {
                 var e = this;
                 var Inv = $(e).find("#hdnInv").val();
                 var Formula = $(e).find("#hdnFormula").val();
                 var isCulture = $(e).find("#hdnisCulture").val();
                 var LabObservation_ID = $(e).find("#hdnLabObservation_ID").val();
                 var Value = $(e).find(".inputvalue").val();
                 if (Inv == '0') {
                     $(e).find("#hdnisCulture").val(Formula);
                     isCulture = Formula

                     if (isCulture != '') {

                         $('#EntryTable tr .row-box .Value ').each(function () {
                             var f = this;
                             var fInv = $(f).find("#hdnInv").val()
                             if (fInv == '0') { 
                                 isCulture = isCulture.replace(new RegExp("#" + ($(f).find("#hdnLabObservation_ID").val() + "@"), 'g'), $(f).find(".inputvalue").val()); 
                                 $(e).find("#hdnisCulture").val(isCulture);
                             }
                         });

                         try {
                             Value = Math.round(eval(isCulture) * 100) / 100;
                             if ($(e).hasClass("Formula")) {
                                 $(e).find(".inputvalue").val(Value)
                             }
                         }
                         catch (e) {
                             $(e).find(".inputvalue").val('');
                         }
                         var ans = $(e).find(".inputvalue").val();
                         if ((isNaN(ans)) || (ans == "Infinity") || (ans == 0)) {
                             $(e).find(".inputvalue").val('')
                         }

                     }

                 }
                 ApplyBloodGroupFormula();
                 valueChangeColor();

             });
         }
         var AntiA = "";
         var AntiB = "";
         var ACells = "";
         var BCells = "";
         var OCells = "";
         var AntiD = "";
         function ApplyBloodGroupFormula() {
             $('#EntryTable tr .row-box .Value ').each(function () {
                 var e = this;
                 var Inv = $(e).find("#hdnInv").val();
                 var Formula = $(e).find("#hdnFormula").val();
                 var isCulture = $(e).find("#hdnisCulture").val();
                 var LabObservation_ID = $(e).find("#hdnLabObservation_ID").val();
                 var Value = $(e).find(".inputvalue").val();
                 var Investigation_ID = $(e).find("#hdnInvestigation_ID").val();

                 if (Inv == '0' && Investigation_ID == '25') {


                     if (LabObservation_ID == "1142") {
                         AntiA = Value;
                     }
                     if (LabObservation_ID == "1143") {
                         AntiB = Value;
                     }
                     if (LabObservation_ID == "1144") {
                         ACells = Value;
                     }
                     if (LabObservation_ID == "1145") {
                         BCells = Value;
                     }
                     if (LabObservation_ID == "1146") {
                         OCells = Value;
                     }
                     if (LabObservation_ID == "1141") {
                         AntiD = Value;
                     }


                     //Case +	-	-	+	-	+  (A POSITIVE)
                     if (AntiA == "+" && AntiB == "-" && ACells == "-" && BCells == "+" && OCells == "-" && AntiD == "+") {

                         if (LabObservation_ID == "933") {
                             Value = "A";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "POSITIVE";
                         }
                     }


                         //Case 2 +	-	-	+	-	- (A NEGATIVE)
                     else if (AntiA == "+" && AntiB == "-" && ACells == "-" && BCells == "+" && OCells == "-" && AntiD == "-") {

                         if (LabObservation_ID == "933") {
                             Value = "A";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "NEGATIVE";
                         }
                     }
                         //Case 3 -	+	+	-	-	+ (B POSITIVE)
                     else if (AntiA == "-" && AntiB == "+" && ACells == "+" && BCells == "-" && OCells == "-" && AntiD == "+") {

                         if (LabObservation_ID == "933") {
                             Value = "B";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "POSITIVE";
                         }
                     }
                         //Case 4 -	+	+	-	-	- (B NEGATIVE)
                     else if (AntiA == "-" && AntiB == "+" && ACells == "+" && BCells == "-" && OCells == "-" && AntiD == "-") {

                         if (LabObservation_ID == "933") {
                             Value = "B";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "NEGATIVE";
                         }
                     }
                         //Case 5 +	+	-	-	-	+ (AB POSITIVE)
                     else if (AntiA == "+" && AntiB == "+" && ACells == "-" && BCells == "-" && OCells == "-" && AntiD == "+") {

                         if (LabObservation_ID == "933") {
                             Value = "AB";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "POSITIVE";
                         }
                     }
                         //Case 6 +	+	-	-	-	- (AB NEGATIVE)
                     else if (AntiA == "+" && AntiB == "+" && ACells == "-" && BCells == "-" && OCells == "-" && AntiD == "-") {

                         if (LabObservation_ID == "933") {
                             Value = "AB";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "NEGATIVE";
                         }
                     }
                         //Case 7 -	-	+	+	-	+ (O POSITIVE)
                     else if (AntiA == "-" && AntiB == "-" && ACells == "+" && BCells == "+" && OCells == "-" && AntiD == "+") {

                         if (LabObservation_ID == "933") {
                             Value = "O";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "POSITIVE";
                         }
                     }
                         //Case 8 -	-	+	+	-	- (O NEGATIVE)
                     else if (AntiA == "-" && AntiB == "-" && ACells == "+" && BCells == "+" && OCells == "-" && AntiD == "-") {

                         if (LabObservation_ID == "933") {
                             Value = "O";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "NEGATIVE";
                         }
                     }
                     else {
                         if (LabObservation_ID == "933") {
                             Value = "";
                         }
                         if (LabObservation_ID == "934") {
                             Value = "";
                         }
                     }
                     $(e).find(".inputvalue").val(Value)
                     $(e).find(".inputvalue").change();
                 }
             });
         }




         function valueChangeColor() {
             $('#EntryTable tr .row-box .Value').each(function () {
                 var crl = this;
                 var val = $(crl).find(".inputvalue").val();
                 var min = $(crl).find(".inputvalue").attr("minval");
                 var max = $(crl).find(".inputvalue").attr("maxval");

                 if (parseInt(val) < parseInt(min)) {

                     $(crl).find(".ValueStatus").html("L");
                     $(crl).closest("div").find("#hdnflag").val("Low");
                     $(crl).closest("div").find("#hdnflag").change();
                     $(crl).find(".inputvalue").css('background-color', 'yellow');
                 }
                 else if (parseInt(val) > parseInt(max)) {
                     $(crl).find(".ValueStatus").html("H");
                     $(crl).closest("div").find("#hdnflag").val("High");
                     $(crl).closest("div").find("#hdnflag").change();
                     $(crl).find(".inputvalue").css('background-color', '#ff9797');
                 }
                 else {
                     $(crl).find(".ValueStatus").html("");
                     $(crl).closest("div").find("#hdnflag").val("Normal");
                     $(crl).closest("div").find("#hdnflag").change();
                     $(crl).find(".inputvalue").css('background-color', 'white');
                 }
             });

         }



         function HideAll() {
             $('#btnForwardLabObs,#btnUnForwardLabObs ,#btnApprovedLabObs,#btnNotApproveLabObs,#btnholdLabObs,#btnUnholdLabObs,#btnSaveLabObs').hide();
         }
         function UpdateSampleStatus(Status) {
             HideAll();             
             try {
                 MYSampleStatus = Status;
             }
             catch (e) {
                 MYSampleStatus = "Tested";
             }

             if (MYSampleStatus == "Forwarded") {
                 $('#btnApprovedLabObs').show();
                 $('#btnUnForwardLabObs').show();

             }
             if (MYSampleStatus == "Tested" || MYSampleStatus == "Preliminary report") {
                 $('#btnForwardLabObs').show(); $('#btnApprovedLabObs').show();
             }
             if (MYSampleStatus == "Approved" || MYSampleStatus == "Printed") {
                 $('#btnNotApproveLabObs').show();
             }
             if (MYSampleStatus == "Pending" || MYSampleStatus == "ReRun" || MYSampleStatus == "Tested" || MYSampleStatus == "Machine Data" || MYSampleStatus == "Preliminary report" || MYSampleStatus == "Sample Receive") {
                 $('#btnSaveLabObs').show(); $('#btnApprovedLabObs').show();
             }
             if (MYSampleStatus == "Tested" && MYSampleStatus != "Approved" || MYSampleStatus == "Preliminary report") { }
             if (MYSampleStatus == "Pending" || MYSampleStatus == "ReRun" || MYSampleStatus == "Tested") {
                 $('#btnholdLabObs').show();
             }
             if (MYSampleStatus == "Hold") {
                 $('#btnUnholdLabObs').show(); $('#btnApprovedLabObs').hide();
             }
             if (MYSampleStatus == "UnHold") {
                 $('#btnForwardLabObs,#btnApprovedLabObs,#btnholdLabObs,#btnSaveLabObs').show();
             }

             if (MYSampleStatus == "Un Forward") {
                 $('#btnForwardLabObs,#btnApprovedLabObs,#btnholdLabObs,#btnSaveLabObs').show();
             }
             if (MYSampleStatus == "Not Approved") {
                 $('#btnForwardLabObs,#btnApprovedLabObs,#btnholdLabObs,#btnSaveLabObs').show();
             }
         }


    </script>

    <script type="text/javascript">
        function Save() {
            resultStatus = "Save";
            msgtitle = "Result Entry";
            SaveLabObs();
        }
        function Approved() {
            resultStatus = "Approved";
            msgtitle = "Result Entry";
            SaveLabObs();
        }
        function NotApproved() {
            $('#notapprovedmodel').modal('show');
        }
        function NotApproveSave() {
            if ($.trim($("#txtNotApprovedRemarks").val()) == "") {
                $("#msgtitle").html(msgtitle);
                $('#massage').html('please enter valid Remarks !');              
                $('#msgModal').modal('show');
                return;
            }
            else {
                resultStatus = "Not Approved";
                msgtitle = "Result Entry";
                SaveLabObs();
            }
        }
        function Hold() {
            $('#holdmodel').modal('show');
        }

        function Holdme() {
            resultStatus = "Hold";
            msgtitle = "Result Entry";
            SaveLabObs();

        }
        function UnHold() {
            resultStatus = "UnHold";
            SaveLabObs();
        }
        function CriticalSave() {
            criticalsave = "1";
            $('#Criticalmodel').modal('hide');
            SaveLabObs();
        }

        function SaveLabObs() {
            var HoldRemarks = "";
            var notapprovalcomment = "";
            if (resultStatus == "Hold")
                HoldRemarks = $.trim($("#txtHoldRemarks").val());

            if (resultStatus == "Not Approved")
                notapprovalcomment = $.trim($("#txtNotApprovedRemarks").val());

            var PatientData = ViewModel.people();
	    var IsDefaultSing = '<%=IsDefaultSing%>';
	    var MobileEMINo='<%=Request.QueryString["MobileEMINo"]%>';
            var MobileNo='<%=Request.QueryString["MobileNo"]%>';
            var MobileLatitude='<%=Request.QueryString["MobileLatitude"]%>';
            var MobileLongitude='<%=Request.QueryString["MobileLongitude"]%>';
            $.ajax({
                url: "../Lab/MachineResultEntry.aspx/SaveLabObservationOpdData",
                data: JSON.stringify({ data: PatientData, ResultStatus: resultStatus, ApprovedBy: '<% =UserInfo.ID%>', ApprovalName: '<%= UserInfo.LoginName%>', HoldRemarks: HoldRemarks, criticalsave: criticalsave, notapprovalcomment: notapprovalcomment,macvalue: '1',MachineID_Manual:'0',MobileApproved:'1',IsDefaultSing:IsDefaultSing,MobileEMINo: MobileEMINo, MobileNo: MobileNo, MobileLatitude: MobileLatitude, MobileLongitude: MobileLongitude}),
              type: "POST", // data has to be Posted    	        
              contentType: "application/json; charset=utf-8",
              timeout: 120000,
              dataType: "json",
              success: function (result) {
                  criticalsave = "0";
                  if (result.d.split('@')[0] == 'success') {
                      if (resultStatus != "Save") {
                          UpdateState(resultStatus)
                          UpdateSampleStatus(resultStatus);
                      }                       
                      if (resultStatus == "Save") {
                          $("#msgtitle").html(msgtitle);
                          $('#massage').html('Record saved successfully !');
                          $('body').unwait();
                          $('#msgModal').modal('show');
                          if (ViewModel.pageNumber() !== ViewModel.totalPages()) {
                              ViewModel.pageNumber(ViewModel.pageNumber() + 1)
                          }
                      }
                      if (resultStatus == "Approved") {
                          $("#msgtitle").html(msgtitle);
                          $('#massage').html('Record Approved successfully !');
                          $('body').unwait();
                          $('#msgModal').modal('show');
                          if (ViewModel.pageNumber() !== ViewModel.totalPages()) {
                              ViewModel.pageNumber(ViewModel.pageNumber() + 1)
                          }
                      }

                      if (resultStatus == "Hold") {
                          $("#msgtitle").html(msgtitle);
                          $('#massage').html('Record Holded successfully !');
                          $('body').unwait();
                          $('#holdmodel').modal('hide');
                          $('#msgModal').modal('show');
                          if (ViewModel.pageNumber() !== ViewModel.totalPages()) {
                              ViewModel.pageNumber(ViewModel.pageNumber() + 1)
                          }
                      }
                      if(resultStatus == "Not Approved")
                      {
                          $("#msgtitle").html(msgtitle);
                          $('#massage').html('Record Not Approved successfully !');
                          $('body').unwait();
                          $('#notapprovedmodel').modal('hide');
                          $('#msgModal').modal('show');                           
                      }
                  }
                  else {
                      if (result.d == "Critical") {

                          $('#Criticalmodel .msgCritical').html("Result Has Critical Value..!<br/>Do You Want To Continue..?");
                          $('#Criticalmodel').modal('show');

                      }
                      else {
                          $('#msgModal #msgtitle').html("Result Entry");
                          $('#msgModal #massage').html(result);
                          $('#msgModal').modal('show'); 
                      }
                  }
              },
              error: function (xhr, status) {
                  var err = eval("(" + xhr.responseText + ")");
                  console.log(err);
                  if (err.Message == "Critical") {
                      $('#Criticalmodel .msgCritical').html("Result Has Critical Value..!<br/>Do You Want To Continue..?");
                      $('#Criticalmodel').modal('show');
                  }
                  else {
                      $('#msgModal #msgtitle').html("Result Entry");
                      $('#msgModal #massage').html(err.Message);
                      $('#msgModal').modal('show');
                  } 
              }
          });
      }


      function UpdateState(resultStatus) {
          ko.utils.arrayFilter(ViewModel.Allrecord(), function (item) {
              if (item.PName == ViewModel.PName() && item.Age_Gender == ViewModel.Age_Gender() && item.BarcodeNo == ViewModel.BarcodeNo() && item.Test_ID == ViewModel.Test_ID()) {
                  item.Status = resultStatus;
              }
          });
      }
    </script>

    <script type="text/javascript">
        function UnForward() {
            resultStatus = "Un Forward";
            SaveLabObs();
        }
        function Forward() {
            msgtitle = "Result Entry";
            var TestID = $('#testid').val();
            $("#<%=ddltest.ClientID %> option").remove();
            var ddlTest = $("#<%=ddltest.ClientID %>");
            $.ajax({
                url: "../Lab/MachineResultEntry.aspx/BindTestToForward",
                data: '{ testid: "' + TestID + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    Tdata = $.parseJSON(result.d);
                    for (i = 0; i < Tdata.length; i++) {
                        ddlTest.append($("<option></option>").val(Tdata[i]["test_id"]).html(Tdata[i]["name"]));
                    }
                },
                error: function (xhr, status) {

                }
            });

            $('#forwordModal').modal('show');
            bindcenter();
        }

        function bindcenter() {
            $("#<%=ddlcentre.ClientID %> option").remove();
            var ddlcentre = $("#<%=ddlcentre.ClientID %>");
            $.ajax({
                url: "../Lab/MachineResultEntry.aspx/BindCentreToForward",
                data: '{}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    Cdata = $.parseJSON(result.d);
                    for (i = 0; i < Cdata.length; i++) {
                        ddlcentre.append($("<option></option>").val(Cdata[i]["centreid"]).html(Cdata[i]["centre"]));
                    }
                },
                error: function (xhr, status) {

                }
            });
            binddoctoforward();
        }
        function binddoctoforward() {
            $("#<%=ddlforward.ClientID %> option").remove();
            var ddlforward = $("#<%=ddlforward.ClientID %>");

            $.ajax({
                url: "../Lab/MachineResultEntry.aspx/BindDoctorToForward",
                data: '{centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '"}', // parameter map 
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        // async: false,
                        success: function (result) {

                            Fdata = $.parseJSON(result.d);
                            for (i = 0; i < Fdata.length; i++) {

                                ddlforward.append($("<option></option>").val(Fdata[i]["employeeid"]).html(Fdata[i]["Name"]));
                            }

                        },
                        error: function (xhr, status) {



                        }
                    });
                }

                function Forwardme() {


                    var length1 = $('#<%=ddltest.ClientID %>  option').length;
            if ($("#<%=ddltest.ClientID %> option:selected").val() == "" || length1 == 0) {

                $("#msgtitle").html(msgtitle);
                $('#massage').append('Please Select Test');
                $('#msgModal').modal('show');
                $("#<%=ddltest.ClientID %>").focus();
                        return;
                    }
                    var length2 = $('#<%=ddlcentre.ClientID %>  option').length;
            if ($("#<%=ddlcentre.ClientID %> option:selected").val() == "" || length2 == 0) {


                $("#msgtitle").html(msgtitle);
                $('#massage').append('Please Select Centre');
                $('#msgModal').modal('show');
                $("#<%=ddlcentre.ClientID %>").focus();
                        return;
                    }

                    var length3 = $('#<%=ddlforward.ClientID %>  option').length;


            if ($("#<%=ddlforward.ClientID %> option:selected").val() == "" || length3 == 0) {
                $("#msgtitle").html(msgtitle);
                $('#massage').append('Please Select Doctor to Forward');
                $('#msgModal').modal('show');
                $("#<%=ddlforward.ClientID %>").focus();
                        return;
                    }

                    var MobileEMINo = '<%=Request.QueryString["MobileEMINo"]%>';
                    var MobileNo = '<%=Request.QueryString["MobileNo"]%>';
                    var MobileLatitude = '<%=Request.QueryString["MobileLatitude"]%>';
                    var MobileLongitude = '<%=Request.QueryString["MobileLongitude"]%>';
                    $.ajax({
                        url: "../Lab/MachineResultEntry.aspx/ForwardMe",
                        data: '{testid:"' + $('#<%=ddltest.ClientID%> option:selected').val() + '" ,centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '",forward:"' + $('#<%=ddlforward.ClientID%> option:selected').val() + '",MobileApproved:1,MobileEMINo:"'+ MobileEMINo+'", MobileNo: "'+MobileNo+'", MobileLatitude: "'+MobileLatitude+'", MobileLongitude: "'+MobileLongitude+'"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                //async: false,
                success: function (result) {
                    if (result.d == "1") {
                        $("#msgtitle").html(msgtitle);
                        $('#massage').html("Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text());
                        $('body').unwait();
                        $('#msgModal').modal('show');
                        UpdateState("Forwarded");
                        UpdateSampleStatus("Forwarded");
                        if (ViewModel.pageNumber() !== ViewModel.totalPages()) {
                            ViewModel.pageNumber(ViewModel.pageNumber() + 1)
                        }
                        $('#forwordModal').modal('hide');


                    }
                    else {

                        $("#msgtitle").html(msgtitle);
                        $('#massage').append(result.d);
                        $('body').unwait();
                        $('#msgModal').modal('show');

                    }
                },
                error: function (xhr, status) {



                }
            });

        }
    </script>

    <script type="text/javascript">
        $(document).on('click', '.ReRun', function () {
            var e = this;
            var tid = $(e).attr("Test_ID");
            var LabNo=$(e).attr("LedgerTransactionNo");             
            var href = "ShowRerun.aspx?TestID=" + tid + "&LabNo=" + LabNo;
            $('.ReRunData').load(href);
          
        });
    </script>
  
</asp:Content>

