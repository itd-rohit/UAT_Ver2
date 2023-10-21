<%@ Page  Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true"  CodeFile="NewTicket.aspx.cs" Inherits="Design_Support_NewTicket"  %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <%: Scripts.Render("~/bundles/JQueryStore") %>
    


    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>New Support Query</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" >
                Submit New Issue
            </div>


            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Category </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCategory" runat="server" onchange="DLBindQueries();"></asp:DropDownList>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Predefind Queries </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlQueries" runat="server"></asp:DropDownList>
                </div>
            </div>


            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Subject </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtSub" runat="server" MaxLength="50" CssClass="requiredField"></asp:TextBox>
                </div>
            </div>
               <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Email </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="70" ></asp:TextBox>
                </div>
            </div>

            <div class="row" style="display: none">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Main Head </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtMainHead" runat="server" MaxLength="50" CssClass="requiredField"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Detail </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDetail" runat="server" TextMode="MultiLine" Style="margin: 0px; width: 382px; height: 100px;" CssClass="requiredField"></asp:TextBox>
                </div>
            </div>

            <div class="row"  id="divClient">
                <div class="col-md-3">&nbsp;
                </div>
                <div class="col-md-3 trShowClient" style="display:none">
                    <label class="pull-left"> Client </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 trShowClient" style="display:none">
                    <asp:DropDownList ID="ddlPcc" CssClass="chosen-select" runat="server" ></asp:DropDownList>
                    
                </div>
                 
                <div class="col-md-3 trShowBarcodeNo" style="display:none">
                    <label class="pull-left"> BarCode No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 trShowBarcodeNo" style="display:none"> <asp:TextBox ID="txtVialId" runat="server" MaxLength="15"></asp:TextBox></div>
                <div class="col-md-3"><asp:HiddenField ID="hfPccId" runat="server" Value="0" /></div>
            </div>
                     
            <div class="row" id="divLabNo">
                 <div class="col-md-3">&nbsp;
                </div>
                <div class="col-md-3 trShowLabNo" style="display:none">
                    <label class="pull-left">Visit No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 trShowLabNo" style="display:none">
                    <asp:TextBox ID="txtRegMo" runat="server" ></asp:TextBox>
                </div>
                 <div class="col-md-3 trShowTestCode" style="display:none">
                    <label class="pull-left">Test </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 trShowTestCode" style="display:none">
                    <asp:DropDownList ID="ddlinvestigation" runat="server" CssClass="chosen-select" ></asp:DropDownList>
                    <asp:HiddenField ID="hfinvid" runat="server" />
                </div>
            </div>

            <div class="row" id="trShowTestCode" style="display:none">
                 <div class="col-md-3">&nbsp;
                </div>
               
                <div class="col-md-13">&nbsp</div>
            </div>
            <div class="row" style="display: none">
                  <div class="col-md-3">&nbsp;
                </div>
                <div class="col-md-3">
                    <label class="pull-left"> User </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddluser" runat="server"></asp:DropDownList>
                    <asp:HiddenField ID="hfUserID" runat="server" Value="0" />
                </div>
                <div class="col-md-13">&nbsp</div>
            </div>
            <div class="row" id="trShowRole" style="display:none">
                  <div class="col-md-3">&nbsp;
                </div>
                <div class="col-md-3">
                    <label class="pull-left"> Role </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlrole" runat="server"></asp:DropDownList>
                    <asp:HiddenField ID="hfRoleID" runat="server" Value="0" />
                </div>
                <div class="col-md-13">&nbsp</div>
            </div>


            

            <div class="row" id="trShowCentre" style="display:none">
                  <div class="col-md-3">&nbsp;
                </div>
                <div class="col-md-3">
                    <label class="pull-left"> Center </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCenter" runat="server"></asp:DropDownList>
                    <asp:HiddenField ID="hfCenter" runat="server" Value="0" />
                </div>
                <div class="col-md-13">&nbsp</div>
            </div>
            <div class="row" style="display: none">
                 <div class="col-md-3">&nbsp;
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Attachment</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:FileUpload ID="fu_file" Multiple="Multiple" runat="server" />
                </div>
                <div class="col-md-13">&nbsp</div>
            </div>         
        </div>
    <div class="POuter_Box_Inventory" style="text-align: center;">


        <button id="btnSubmit" type="button" value="Submit" onclick="InsertNewTik()">Submit</button>&nbsp;
        <asp:Button ID="btnAttachment" runat="server" Text="Add Attachment" OnClientClick="OpenPopup(); return false;" />
        <asp:HiddenField ID="hdFileID" runat="server" />
    </div>
         <div class="POuter_Box_Inventory" style=" text-align: center;">
             <div class="Purchaseheader">
                Search Your Old Issue
            </div>
             <div class="POuter_Box_Inventory" style="text-align: center;">
                  <div class="row">
                       <div class="col-md-3">&nbsp;
                </div>
               <div class="col-md-2">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-2">
                             <asp:TextBox ID="txtFromDate" runat="server"  />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                           </div>
                      <div class="col-md-1"></div>
                       <div class="col-md-2">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-2">
                           <asp:TextBox ID="txtToDate" runat="server" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                           </div>
                       <div class="col-md-1"></div>
                      <div class="col-md-2">
                    <label class="pull-left">Status</label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-3">
                            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="chosen-select"></asp:DropDownList>    
                           </div>
                      <div class="col-md-2">
                          <input type="button"  value="Search" id="btnSearch" onclick="bindOldTicket()" />
                         
                          </div>
                  </div>
                 


            <div class="row" style="height:300px;overflow: scroll;" >
                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" style="border-collapse: collapse; width: 100%;" id="tblTicket">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Issue No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 230px;">Category Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 230px;">Subject</th>                         
                            <th class="GridViewHeaderStyle" scope="col" style="width: 230px;">EmailID</th>  
                            <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Raised Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 180px;">Raised By</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Status</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">IsRead</th>
                        </tr>
                    </thead>
                    <tbody >
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
    <script type="text/javascript">
        $(function () {
            
        });
        function bindStatus() {
            serverCall('NewTicket.aspx/bindStatus', {  }, function (response) {               
                jQuery('#ddlStatus').bindDropDown({ defaultValue: 'All', data: JSON.parse(response).StatusData, valueField: 'ID', textField: 'STATUS', isSearchAble: true, selectedValue: 1 });

                jQuery('#ddlCategory').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response).CategoryData, valueField: 'ID', textField: 'CategoryName', isSearchAble: true });
                jQuery('#ddlPcc').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response).ClientData, valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true });
                jQuery('#ddlinvestigation').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response).InvData, valueField: 'ID', textField: 'Typename', isSearchAble: true, selectedValue: 1 });

            }, '', false);
            
        }
             </script>
    <script type="text/javascript">
        
        function bindOldTicket() {
            serverCall('NewTicket.aspx/searchOldTicket', { fromDate: $("#txtFromDate").val(), toDate: $("#txtToDate").val(), statusID: $("#ddlStatus").val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    TicketData(jQuery.parseJSON($responseData.responseDetail));
                }
                else {
                    toast("Error", $responseData.response);
                }
            });
        }

        function TicketData($responseResult) {
            jQuery("#tblTicket tbody").empty();
            for (var i = 0; i < $responseResult.length; i++) {
                var $row = [];
                $row.push('<tr>');
                $row.push('<td>'); $row.push((i + 1)); $row.push('</td>');
                $row.push('<td>'); $row.push($responseResult[i]["TicketID"]); $row.push('</td>');
                $row.push('<td id="tdCategoryName" Style="text-align:left">'); $row.push($responseResult[i]["CategoryName"]); $row.push('</td>');
                $row.push('<td Style="text-align:left">'); $row.push($responseResult[i]["Subject"]); $row.push('</td>');
                $row.push('<td Style="text-align:left">'); $row.push($responseResult[i]["EmailID"]); $row.push('</td>');
                $row.push('<td Style="text-align:left">'); $row.push($responseResult[i]["dtAdd"]); $row.push('</td>');
                $row.push('<td Style="text-align:left">'); $row.push($responseResult[i]["EmpName"]); $row.push('</td>');
                $row.push('<td Style="text-align:left">'); $row.push($responseResult[i]["Status"]); $row.push('</td>');
                $row.push('<td Style="text-align:left">'); $row.push($responseResult[i]["IsRead"]); $row.push('</td>');
                $row.push('</tr>');
                $row = $row.join("");
                jQuery("#tblTicket tbody").append($row);
            }
        }
    </script>
    <script type="text/javascript">

        function validation() {
            if ($("#<%=ddlCategory.ClientID%>").val() == '0') {
                toast("Error", "Please Select Category");
                $("#<%=ddlCategory.ClientID%>").focus();
                return false;
            }
            if ($("#<%=ddlQueries.ClientID%>").val() == '') {
                toast("Error", "Please Select Predefind Queries");
                $("#<%=ddlQueries.ClientID%>").focus();
                return false;
            }
            if ($.trim( $("#<%=txtSub.ClientID%>").val()) == '') {
                toast("Error", "Please Enter Subject");
                $("#<%=txtSub.ClientID%>").focus();
                return false;
            }

            // if ($("#<%=txtMainHead.ClientID%>").val() == '') {
            // toast("Error","Please Enter Main Haid");
            // return false;
            // }

            if ($("#<%=txtDetail.ClientID%>").val() == '') {
                toast("Error", "Please Enter Details");
                $("#<%=txtDetail.ClientID%>").focus();
                return false;
            }
            if ($(".trShowClient").hasClass("Mandatory") == true && $("#ddlPcc").val() == '') {
                toast("Error", "Please Select Client");
                $("#<%=ddlPcc.ClientID%>").focus();
                return false;
            }
            if ($(".trShowBarcodeNo").hasClass("Mandatory") == true && $("#<%=txtVialId.ClientID%>").val() == '') {
                toast("Error", "Please Enter Barcode No.");
                $("#<%=txtVialId.ClientID%>").focus();
                return false;
            }
            if ($(".trShowLabNo").hasClass("Mandatory") == true && $("#<%=txtRegMo.ClientID%>").val() == '') {
                toast("Error", "Please Enter Visit No.");
                $("#<%=txtRegMo.ClientID%>").focus();
                return false;
            }
            if ($(".trShowTestCode").hasClass("Mandatory") == true && $("#<%=ddlinvestigation.ClientID%>").val() == '') {
                toast("Error", "Please Select Test");
                $("#<%=ddlinvestigation.ClientID%>").focus();
                return false;
            }
            return true;
        }
        function InsertNewTik() {
            if (!validation()) {
                return false;
            }
            var ddlValue = $("#<%=ddlCategory.ClientID%>").val();
            var _CategoryID = ddlValue.split('@')[0].split('#')[0];
            var _Query = $("#<%=ddlQueries.ClientID%>").val();
            var _Subject = $("#<%=txtSub.ClientID%>").val();
            var _MainHead = $("#<%=txtMainHead.ClientID%>").val();
            var _Details = $("#<%=txtDetail.ClientID%>").val();
            var _Client = $("#<%=ddlPcc.ClientID%>").val();
            var _Role = $("#<%=ddlrole.ClientID%>").val();
            var _User = $("#<%=ddluser.ClientID%>").val();
            var _Centre = $("#<%=ddlCenter.ClientID%>").val();
            var _Barcode = $("#<%=txtVialId.ClientID%>").val();
            var _LabNo = $("#<%=txtRegMo.ClientID%>").val();
            var _LabCode = $("#<%=ddlinvestigation.ClientID%>").val();
            var _Email = $("#<%=txtEmail.ClientID%>").val();

            var hfRoleID = $("#<%=hfRoleID.ClientID%>").val() == "" ? "0" : $("#<%=hfRoleID.ClientID%>").val();
            var hfCenter = $("#<%=hfCenter.ClientID%>").val() == "" ? "0" : $("#<%=hfCenter.ClientID%>").val();
            var hfPccId = $("#<%=hfPccId.ClientID%>").val() == "" ? "0" : $("#<%=hfPccId.ClientID%>").val();
            var hfUserID = $("#<%=hfUserID.ClientID%>").val() == "" ? "0" : $("#<%=hfUserID.ClientID%>").val();
            var hfinvid = $("#<%=hfinvid.ClientID%>").val();
            var hdFileID = $("#<%=hdFileID.ClientID%>").val() == "" ? "" : $("#<%=hdFileID.ClientID%>").val();
            // var QueryID = $("#<%=ddlQueries.ClientID%>").val() == "" ? "" : $("#<%=ddlQueries.ClientID%>").val();

            var IsShowVisitNo = $("#<%=ddlCategory.ClientID%>").val().split('@')[0].split('#')[4];
            var IsShowBarcodeNumber = $("#<%=ddlCategory.ClientID%>").val().split('@')[0].split('#')[3];
            serverCall('NewTicket.aspx/Save', { CategoryID: _CategoryID, Query: _Query, Subject: _Subject, MainHead: _MainHead, Details: _Details, Client: _Client, Role: _Role, User: _User, Centre: _Centre, Barcode: _Barcode, LabNo: _LabNo, LabCode: _LabCode, hfRoleID: hfRoleID, hfCenter: hfCenter, hfPccId: hfPccId, hfUserID: hfUserID, hfinvid: hfinvid, hdFileID: hdFileID, IsShowVisitNo: IsShowVisitNo, IsShowBarcodeNumber: IsShowBarcodeNumber,Email:_Email }, function (response) {
              var  $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);
                    clear();
                    TicketData(jQuery.parseJSON($responseData.responseDetail));
                }
                else {
                    toast("Error", $responseData.response);
                    return;
                }              
            });          
        }
        function clear() {
            $("#txtSub,#txtDetail,#txtRegMo,#txtMainHead,#txtVialId,#txtEmail").val("");
            $("#ddlCategory,#ddlinvestigation,#ddlPcc").prop('selectedIndex', 0);
            $("#ddlCategory,#ddlinvestigation,#ddlPcc").chosen("destroy").chosen({ width: '100%' });
            $("#hfRoleID,#hfCenter,#hfPccId,#hfUserID,#hfinvid,#hdFileID").val("");
            DLBindQueries();
        }
    </script>
    <script type="text/javascript">

        function OpenPopup() {
            var FileName = "";
            if ($('#<%=hdFileID.ClientID%>').val() == "") {
                FileName = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                FileName = $('#<%=hdFileID.ClientID%>').val();
            }
            $('#<%=hdFileID.ClientID%>').val(FileName);
               
            fancyBoxOpen('SupportAttachment.aspx?FileName=' + FileName);
                     
        }
        function fancyBoxOpen(href) {
            jQuery.fancybox({
                maxWidth: 796,
                maxHeight: 300,
                fitToView: false,
                width: '90%',
                height: '85%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
        );
        }
        $(function () {
            var config =
                {
                    '.chosen-select': {},
                    '.chosen-select-deselect': { allow_single_deselect: true },
                    '.chosen-select-no-single': { disable_search_threshold: 10 },
                    '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                    '.chosen-select-width': { width: "95%" }
                }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            $("#ddlCategory").chosen("destroy").chosen({ width: '100%' });
            $("#ddlPcc,#ddlinvestigation").chosen("destroy").chosen({ width: '100%' });
            bindStatus();
            //DLBindQueries();
            BindUsers(0);
                      
            $('#<%=hfPccId.ClientID%>').val($('#<%=ddlPcc.ClientID%> option:selected').val());
            $("#<%=ddlPcc.ClientID%>").chosen().change(function () {
                $('#<%=hfPccId.ClientID%>').val($('#<%=ddlPcc.ClientID%> option:selected').val());
            });
            $('#<%=hfinvid.ClientID%>').val($('#<%=ddlinvestigation.ClientID%> option:selected').val());
            $("#<%=ddlinvestigation.ClientID%>").chosen().change(function () {
                $('#<%=hfinvid.ClientID%>').val($('#<%=ddlinvestigation.ClientID%> option:selected').val());
            });
            $('#<%=hfRoleID.ClientID%>').val($('#<%=ddlrole.ClientID%> option:selected').val());
            $("#<%=ddlrole.ClientID%>").change(function () {
                $('#<%=hfRoleID.ClientID%>').val($('#<%=ddlrole.ClientID%>').val());
                BindUsers($('#<%=hfRoleID.ClientID%>').val())
            });
            $('#<%=hfUserID.ClientID%>').val($('#<%=ddluser.ClientID%> option:selected').val());
            $("#<%=ddluser.ClientID%>").change(function () {
                $('#<%=hfUserID.ClientID%>').val($('#<%=ddluser.ClientID%> option:selected').val());
            });
            $('#<%=hfCenter.ClientID%>').val($('#<%=ddlCenter.ClientID%> option:selected').val());
            $("#<%=ddlCenter.ClientID%>").change(function () {
                $('#<%=hfCenter.ClientID%>').val($('#<%=ddlCenter.ClientID%> option:selected').val());
            });
            $("#<%=ddlQueries.ClientID%>").change(function () {
                $('#<%=txtMainHead.ClientID%>').removeAttr("disabled");
                if ($('#<%=ddlQueries.ClientID%> option:selected').val() != "") {
                    serverCall('Services/Support.asmx/GetQueryDescription', { QueryId: $('#<%=ddlQueries.ClientID%> option:selected').val() }, function (response) {
                        if (response != "") {
                            var $responseData = JSON.parse(response);
                            $('#txtSub,#txtDetail').val('');
                            
                            if ($responseData != "") {
                                $('#<%=txtSub.ClientID%>').val($('#<%=ddlQueries.ClientID%> option:selected').text());
                                $('#<%=txtDetail.ClientID%>').val($responseData[0].Detail);
                                $('#<%=txtMainHead.ClientID%>').val($responseData[0].MainHead);
                                $('#<%=txtMainHead.ClientID%>').attr("disabled", true);
                            }
                        }
                    });
                }
                else {
                    $('#<%=txtSub.ClientID%>').val('');
                    $('#<%=txtDetail.ClientID%>').val('');
                    $('#<%=txtMainHead.ClientID%>').val('');
                }
            });
        });

        jQuery("#txtEmail").on("blur", function () {
            debugger;
            if (jQuery('#txtEmail').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtEmail').val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    jQuery('#txtEmail').focus();
                    return false;
                }
            }
        });


        function BindUsers(RoleID) {
            serverCall('NewTicket.aspx/GetUsers', { RoleId: RoleID }, function (response) {
                $("#<%=ddluser.ClientID%>").bindDropDown({ defaultValue: 'Select User', data: JSON.parse(response), valueField: 'Employee_ID', textField: 'NAME', isSearchAble: true });                               
            });           
        }
        function BindQuery(ID) {
            serverCall('NewTicket.aspx/BindQueries', { CategoryID: ID.split('@')[0].split('#')[0] }, function (response) {
                $("#<%=ddlQueries.ClientID%>").bindDropDown({ defaultValue: 'Select Query', data: JSON.parse(response), valueField: 'Id', textField: 'Subject', isSearchAble: true });                
            });           
        }
        function DLBindQueries() {
            $("#txtSub,#txtDetail,#txtRegMo,#txtMainHead,#txtVialId").val("");
            $("#ddlinvestigation,#ddlPcc").prop('selectedIndex', 0);
            $("#ddlCategory,#ddlinvestigation,#ddlPcc").chosen("destroy").chosen({ width: '100%' });
            $("#hfRoleID,#hfCenter,#hfPccId,#hfUserID,#hfinvid,#hdFileID").val("");
            var ddlValue = $("#<%=ddlCategory.ClientID%>").val();
             BindQuery(ddlValue);           
                
             $(".trShowClient,.trShowBarcodeNo,.trShowLabNo,.trShowTestCode").removeClass("Mandatory");
             $(".trShowClient,.trShowBarcodeNo,.trShowLabNo,.trShowTestCode").hide();
             $("#ddlPcc,#txtVialId,#txtRegMo,#ddlinvestigation").removeClass("requiredField");
             if (ddlValue.split('@')[0].split('#')[0] != "0") {
                 
                 if (ddlValue.split('@')[0].split('#')[1] == "1")
                 {
                    
                     $(".trShowClient").show();
                     if (ddlValue.split('@')[1].split('#')[0] == "1") {
                         $(".trShowClient").addClass('Mandatory');
                         $("#ddlPcc").addClass("requiredField");
                     }
                 }
                 
                 if (ddlValue.split('@')[0].split('#')[4] == "1") {
                     $(".trShowBarcodeNo").show();
                    
                     if (ddlValue.split('@')[1].split('#')[3] == "1") {
                         $(".trShowBarcodeNo").addClass('Mandatory');
                         $("#txtVialId").addClass("requiredField");
                     }
                 }
                 if (ddlValue.split('@')[0].split('#')[5] == "1") {
                     $(".trShowLabNo").show();
                     if (ddlValue.split('@')[1].split('#')[4] == "1") {
                         $(".trShowLabNo").addClass('Mandatory');
                         $("#txtRegMo").addClass("requiredField");
                     }
                 }
                 if (ddlValue.split('@')[0].split('#')[6] == "1") {
                     $(".trShowTestCode").show(); 
                     if (ddlValue.split('@')[1].split('#')[5] == "1") {
                         $(".trShowTestCode").addClass('Mandatory');
                         $("#ddlinvestigation").addClass("requiredField");
                     }
                   
                 }
                 if (ddlValue.split('@')[1].split('#')[0] == "1" || ddlValue.split('@')[0].split('#')[4] == "1")
                     $("#divClient").show();
                 else
                     $("#divClient").hide();
                 if (ddlValue.split('@')[0].split('#')[6] == "1" || ddlValue.split('@')[0].split('#')[5] == "1")
                     $("#divLabNo").show();
                 else
                     $("#divLabNo").hide();
                 
             }
         }
    </script>
</asp:Content>

