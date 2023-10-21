<%@ Page Title="" Language="C#" MasterPageFile="~/Design/Mobile/Mobile.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="testApprovalScreen.aspx.cs" Inherits="Design_Mobile_testApprovalScreen" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
       
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <style type="text/css"> 
     .Screen .filterDatemainDiv {
            padding: 0px;
        } 
    </style>    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div class="container pagecontainer Testapproval">
        <%--<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pageheader">Search</div>--%>
        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 pageheader"> 
            <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 heading">Search</div>
            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8 nopadding Userdetl">
                 
                <div class="flipkart-navbar-search smallsearch col-sm-12 col-xs-12">
                <div class="row">
                    <asp:TextBox ID="txtSearchValue" CssClass="flipkart-navbar-input col-xs-10 textbox " runat="server" placeholder="SIN No."></asp:TextBox> 
                    <button type="button" class="flipkart-navbar-button col-xs-2" onclick="SearchBySinNo()">
                        <svg width="15px" height="15px">
                            <path d="M11.618 9.897l4.224 4.212c.092.09.1.23.02.312l-1.464 1.46c-.08.08-.222.072-.314-.02L9.868 11.66M6.486 10.9c-2.42 0-4.38-1.955-4.38-4.367 0-2.413 1.96-4.37 4.38-4.37s4.38 1.957 4.38 4.37c0 2.412-1.96 4.368-4.38 4.368m0-10.834C2.904.066 0 2.96 0 6.533 0 10.105 2.904 13 6.486 13s6.487-2.895 6.487-6.467c0-3.572-2.905-6.467-6.487-6.467 "></path>
                        </svg>
                    </button>
                </div>
            </div>
                 
            </div>
        </div>
       
         <div class="datacontainer">
            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <asp:Label ID="lblerror" ClientIDMode="Static" runat="server" Text=""></asp:Label>
               
            </div>
            <div class="row Screen">
                <div class="col-lg-5 col-md-5 col-sm-12 col-xs-12 filterDatemainDiv">
                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                        <div class="form-group">
                            <label for="concept" class="col-lg-4 col-md-4 col-sm-4 col-xs-12 control-label">Form Date:</label>
                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12 controldiv">
                                <asp:TextBox ID="txtFormDate" CssClass="form-control textbox datepicker" runat="server" ReadOnly="true" style="background-color:#fff;"></asp:TextBox>
                                <asp:HiddenField ID="txtFromTime" runat="server" />
                                <asp:HiddenField ID="txtToTime" runat="server" />
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                        <div class="form-group">
                            <label for="concept" class="col-lg-4 col-md-4 col-sm-4 col-xs-12 control-label">To Date:</label>
                            <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12 controldiv">

                                <asp:TextBox ID="txtToDate" CssClass="form-control textbox datepicker" runat="server" ReadOnly="true" style="background-color:#fff;"></asp:TextBox>
                                
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">

                    <div class="form-group">
                        <label for="concept" class="col-lg-4 col-md-4 col-sm-4 col-xs-12 control-label">Center:</label>
                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12 controldiv">
                            <asp:DropDownList ID="ddlCentreAccess" class="form-control textbox" Width="100%" runat="server"></asp:DropDownList>
                        </div>
                    </div>


                </div>
                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label for="concept" class="col-lg-4 col-md-4 col-sm-4 col-xs-12 control-label">Department:</label>
                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12 controldiv">
                            <asp:DropDownList ID="ddlDepartment" class="form-control textbox" Width="100%" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-12 button-box">
                    <input id="btnSearch" type="button" value="Search" class="btn btn-default submit-btn" onclick="SearchData();" />

                    <%--<input id="btnback" type="button" value="Back" class="btn btn-default submit-btn" onclick="Back();" />--%>
                </div>
            </div>

            <div class="row tableScreen">
                <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">  
                    <div class="panel panel-success">
					<div class="panel-heading">
						<h3 class="panel-title">Total Pending:<span id="totalcount"></span></h3>						 
					</div> 
					<table class="table table-hover" id="tb_ItemList">
						<thead>
							<tr>
								 
								<th>Center</th>
								<th>TestCount</th>
                                <th>PatientCount</th>
                                
								 
							</tr>
						</thead>
						<tbody>
						 
						</tbody>
					</table>
				</div>

                  
                </div>


 
    	 
            </div>
        </div>

       
    </div>

    <script type="text/javascript">
       
        $(function () {
            $(".datepicker").datepicker({ dateFormat: 'dd-M-yy' }); 
       BindCentre();
          
        });

        function BindCentre() {
            var scentre = '<%=Util.GetString(Request.QueryString["scentre"])%>';
            var sCenterID = scentre == 'null' || scentre=='' ? "ALL" : scentre;
            var ddlDoctor = $("#<%=ddlCentreAccess.ClientID %>");
            $("#<%=ddlCentreAccess.ClientID %> option").remove();
           
            $.ajax({ 
                url: "../Lab/MachineResultEntry.aspx/bindAccessCentre",
                data: '{}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    try {
                        PanelData = $.parseJSON(result.d);
                        if (PanelData.length == 0) {
                        }
                        else {
                            ddlDoctor.append($("<option></option>").val("ALL").html("ALL"));
                            for (i = 0; i < PanelData.length; i++) {                              
                                ddlDoctor.append($("<option></option>").val(PanelData[i]["CentreID"]).html(PanelData[i]["Centre"]));
                            }
                           
                        }
                        ddlDoctor.val(sCenterID);                       
                        ddlDoctor.trigger('chosen:updated');
                    }
                    catch (err) {
                        $('#lblerror').text(err.message);
                    }
                    SearchData();

                },
                error: function (xhr, status) {

                    ddlDoctor.trigger('chosen:updated'); 
                    $('#lblerror').text(xhr.responseText);
                     
                }
            });
           
            ddlDoctor.trigger('chosen:updated');
           
        }



         
    </script>



    <script type="text/javascript">
        function SearchData() {           
            $('#tb_ItemList tr ').slice(1).remove();
            $("#btnSearch").attr('disabled', 'disabled').val('Searching...');
            jQuery.ajax({
                url: "../Lab/TestApprovalScreen.aspx/binddata",
                data: '{FromDate:"' + $("#<%=txtFormDate.ClientID %>").val() + '",ToDate:"' + $("#<%=txtToDate.ClientID %>").val() + '",CentreID:"' + $("#<%=ddlCentreAccess.ClientID%>").val() + '",Department:"' + $("#<%=ddlDepartment.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",TimeTo:"' + $("#<%=txtToTime.ClientID%>").val() + '"}',
                type: "POST",
                timeout: 120000,               
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    if (TestData == "-1") {
                        $('#totalcount').html('0');
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        alert('Your Session Expired.... Please Login Again');
                        var url = "login.aspx";
                        $(location).attr('href', url);
                        return;
                    }


                    if (TestData.length == 0) {
                        $("#btnSearch").removeAttr('disabled').val('Search');
                        $('#totalcount').html('0');                       
                        return;
                    }
                    else {
                        var a = 0;
                        $("#btnSearch").removeAttr('disabled').val('Search'); 
                        for (var i = 0; i <= TestData.length - 1; i++) {

                            a = a + parseInt(TestData[i].Pending);
                            var mydata = "<tr  onclick='openresultentry(this)' id='" + TestData[i].CentreID + "'>";                            
                            mydata += '<td data-th="Centre" >' + TestData[i].centre + '</td>';
                            mydata += '<td data-th="Pending For Approval" ><a id="pendingcount" title="Click To View List" href="javascript:void(0)">' + TestData[i].Pending + '</a></td>';
                            mydata += '<td data-th="Pending For Approval" ><a id="pendingcount" title="Click To View List" href="javascript:void(0)">' + TestData[i].PatientCount + '</a></td>';
                            
                            mydata += '<td id="fromdate" style="display:none;">' + $("#<%=txtFormDate.ClientID %>").val() + '</td>';
                            mydata += '<td id="fromtime" style="display:none;">' + $("#<%=txtFromTime.ClientID %>").val() + '</td>';
                            mydata += '<td id="todate"   style="display:none;">' + $("#<%=txtToDate.ClientID %>").val() + '</td>';
                            mydata += '<td id="totime"   style="display:none;">' + $("#<%=txtToTime.ClientID %>").val() + '</td>';
                            mydata += '<td id="centre"   style="display:none;">' + TestData[i].CentreID + '</td>';
                            mydata += '<td id="department" style="display:none;">' + $("#<%=ddlDepartment.ClientID%>").val() + '</td>';
                       
                            mydata += "</tr>";
                            $('#tb_ItemList tbody').append(mydata);
                          
                        }
                        $('#totalcount').html(a);
                    }

                },
                error: function (xhr, status) {
                    $('#lblerror').text(xhr.responseText);
                }

            });

        }

        function openresultentry(ctrl) {
            $('body').wait();
            var fromdate = $(ctrl).closest("tr").find('#fromdate').text();
            var fromtime = $(ctrl).closest("tr").find('#fromtime').text();
            var todate = $(ctrl).closest("tr").find('#todate').text();
            var totime = $(ctrl).closest("tr").find('#totime').text();
            var centre = $(ctrl).closest("tr").find('#centre').text();
            var department = $(ctrl).closest("tr").find('#department').text();
            var sdepartment = $("#<%=ddlDepartment.ClientID%>").val()
            var scentre = $("#<%=ddlCentreAccess.ClientID%>").val();
            setTimeout(function () {              
                window.location.href = "MachineResultEntry.aspx?fromdate=" + fromdate + "&fromtime=" + fromtime + "&todate=" + todate + "&totime=" + totime + "&centre=" + centre + "&department=" + department + "&scentre=" + scentre + "&sdepartment=" + sdepartment + "";
                //$('body').unwait();
            }, 1000);
           
        }

        function SearchBySinNo() {
            console.log('call');
            if ($("#<%=txtSearchValue.ClientID %>").val() == '') {
                $("#msgtitle").html("Result Entry");
                $('#massage').html('Please Enter SinNo !');
                $('#msgModal').modal('show');
                return;
            }
            $('body').wait();                      
                setTimeout(function () {
                    var url = "MachineEntry.aspx?index=0&SearchType=pli.BarcodeNo&SearchValue=" + $("#<%=txtSearchValue.ClientID %>").val() + "&FromDate=" + $("#<%=txtFormDate.ClientID %>").val() + "&ToDate=" + $("#<%=txtToDate.ClientID %>").val() + "&CentreID=ALL&SmpleColl=and pli.isSampleCollected<>'N'&TimeFrm=&TimeTo=&SampleStatusText=All Patient";
                    $(location).attr('href', url);
                    $('body').unwait();
                }, 1000); 
         }

        function Back() {
            $('body').wait();            
            setTimeout(function () {               
                window.location.href = "Dashboard.aspx";
                $('body').unwait();
            }, 1000);
           
        }
    </script>

     
</asp:Content>

