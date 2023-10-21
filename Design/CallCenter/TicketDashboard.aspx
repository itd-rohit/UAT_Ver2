<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="TicketDashboard.aspx.cs" Inherits="Design_CallCenter_TicketDashboard" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">   
<script src="../../Scripts/datatables.min.js"></script> 
   <%-- <%: Scripts.Render("~/bundles/JQueryUIJs") %>--%>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>     
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
      <script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
     <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>     
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
     <style type="text/css">
         .GridViewHeaderStyle {
             height: 25px;
         }

         .GridViewLabItemStyle {
             height: 25px;
         }

         td.details-control {
             background: url('../../App_Images/details_open.png') no-repeat center center;
             cursor: pointer;
         }

         tr.shown td.details-control {
             background: url('../../App_Images/details_close.png') no-repeat center center;
         }

         .no-padding {
             padding: 0px;
         }

         #tbl_Reply tbody th, #tbl_Reply tbody td {
             padding: 1px 10px;
         }

         table.dataTable thead th {
             font-size: 12px;
             font-weight: normal!important;
         }

         table.dataTable tbody td {
             font-size: 11px;
         }
     </style>     
    <div id="Pbody_box_inventory" style="width: 1304px; margin: 2px; min-height:500px;"> 
      <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">
            <b>Ticket DashBoard </b>
            <br />            
            </div>
          <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;padding-bottom: 10px;">
          <table style="width:100%;border-collapse:collapse" >
                    <tr>
                                    <td colspan="6">
                                        &nbsp;&nbsp;
                                    </td>
                                </tr>
                    <tr>
<td style="text-align: right; font-weight: 700;width:20%">From Date :&nbsp;</td>
                        <td style="width:10%;text-align:left">   <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></td>
                        <td style="text-align: right; font-weight: 700;width:10%">To Date :&nbsp;&nbsp;</td>
                        <td style="text-align:left;width:10%">
                             <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="text-align:right;width:10%; font-weight: 700;">Use select center Filter:</td>
                        <td style="text-align:left;width:10%"><input type="checkbox" id="chkcenterfilter" /> </td>
                    </tr>
                  <tr>
                                    <td colspan="6">
                                        &nbsp;&nbsp;
                                    </td>
                                </tr>
                    <tr>
<td style="text-align: center; font-weight: 700;" colspan="6">
    <input type="button" value="Search" class="searchbutton" onclick="searchTicket()" id="btnSearch" />

</td>
                    </tr>
                </table>
               </div>
          <div class="POuter_Box_Inventory ticketStatus" style="width: 1300px; text-align: center;display:none">

           <div id="div_Ticket" style="border: 1px solid #ccc;text-align:center;  width:49%; height:400px; max-height:500px; overflow:auto; float:left;">
                
            </div>
              <div id="div_TicketGraph" style="text-align:center;  width:50%; height:500px; overflow:hidden; float:left;">
                
            </div>
                </div>
        
          <div id="dialog">
                <table id="datatable1" class="table stripe cell-border" style="width:1300px; display:none;" >
                    <thead>
                        <tr style="background-color: rgb(159, 180, 197);">
                            <th style="width: 36px;"></th>
                            <th style="height: 30px; width: 70px; text-align: center">Ticket No.</th>

                            <th style="width: 62px; text-align: center">Status</th>
                            <th style="width: 120px; text-align: center">Group</th>
                            <th style="width: 120px; text-align: center">Category</th>

                            <th style="width: 120px; text-align: center">SubCategory</th>

                            <th style="width: 150px; text-align: center">Subject</th>

                            <th style="width: 300px; text-align: center">Query</th>
                            

                            <th style="width: 150px; text-align: center">SIN No.</th>

                            <th style="width: 150px; text-align: center">UHID No.</th>

                            <th style="width: 100px; text-align: center">Raised Location</th>

                            <th style="width: 220px; text-align: center">Test Name</th>

                            <th style="width: 80px; text-align: center">Raised By</th>

                            <th style="width: 80px; text-align: center">Raised Date</th>
                             <th style="width: 80px; text-align: center">ResolvedBy</th>
                            
                              <th style="width: 90px; text-align: center">TAT Time</th>
                        </tr>
                    </thead>
                </table>
         <table id="datatable" class="table stripe cell-border" style="width:1300px; display:none;" >
                    <thead>
                        <tr style="background-color: rgb(159, 180, 197);">
                            <th style="width: 36px;"></th>
                            <th style="height: 30px; width: 70px; text-align: center">Ticket No.</th>
                            <th style="width: 62px; text-align: center">Status</th>
                            <th style="width: 120px; text-align: center">Group</th>
                            <th style="width: 120px; text-align: center">Category</th>
                            <th style="width: 120px; text-align: center">SubCategory</th>
                            <th style="width: 150px; text-align: center">Subject</th>
                            <th style="width: 300px; text-align: center">Query</th>
                            <th style="width: 150px; text-align: center">SIN No.</th>
                            <th style="width: 150px; text-align: center">UHID No.</th>
                            <th style="width: 100px; text-align: center">Raised Location</th>
                            <th style="width: 220px; text-align: center">Test Name</th>
                            <th style="width: 80px; text-align: center">Raised By</th>

                            <th style="width: 80px; text-align: center">Raised Date</th>
                            <th style="width: 90px; text-align: center">Elapsed Time</th>
                        </tr>
                    </thead>
                </table>
        </div>

        <script id="sc_TicketCount" type="text/html">
    <table class="tbTicketCount" cellspacing="0" rules="all" border="1" id="tb_TicketCount"
    style="width:100%; border-collapse:collapse;">
        <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Status</th>                     
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Count</th>
            
		</tr>
             </thead>
        <#
        var dataLength=TicketStatusData.length;
       
        var objRow;           
        for(var j=0;j<dataLength;j++)
        {
        objRow = TicketStatusData[j];
        #>
                    <tr id="<#=j+1#>" >
                    <td class="GridViewLabItemStyle"><#=j+1#> </td>                                           
                    <td class="GridViewLabItemStyle" id="tdTestCode" style="width:80px;" ><#=objRow.Status#></td>
                    <td class="GridViewLabItemStyle" id="tdTestName" style="width:40px;" ><a href="#" onclick="getdataList('<#=objRow.Status#>')"><#=objRow.StatusCount#></a></td>
                                    
                    </tr>
        <#}
        #>       
     </table>
    </script>
         <div id="divReplyOutput" style="display:none;" >
                
            </div>
        <script id="tb_Reply" type="text/html"> 
            <div class="slider">
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tbl_Reply" width="100%" >
		<tr>
			<th class="GridViewHeaderStyle" style="width:40px;" >S.No.</th>
            <th class="GridViewHeaderStyle" style="width:110px; text-align:center;" >Replied By</th>
            <th class="GridViewHeaderStyle" style="width:100px;">Reply DateTime</th>            
            <th class="GridViewHeaderStyle" style="width:70px;">Attachment</th>          
			<th class="GridViewHeaderStyle" style="width:380px;">Description</th>
              <th class="GridViewHeaderStyle" style="width:300px;text-align:left;">TAT Time</th>
             
         </tr>

       <#
              var dataLength=ReplyData.length;
            
              var objRow;  
            
        for(var j=0;j<dataLength;j++)
        { 
var array=0;
        objRow = ReplyData[j];
         if(objRow.Files!='' && objRow.Files!=null){
           array = objRow.Files.split(",");
            }    
            #>
<tr>
    <td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.EmpName#></td>
    <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.dtEntry#></td>    
    <td class="GridViewLabItemStyle" style="text-align:center;">
<# 
         for(var i=0; i < array.length; i++){#> 
        <div style="margin-bottom: 10px;"><a class="im" url=" <#=array[i].split("#")[1]#>" style="cursor: pointer" href="../Lab/DownloadAttachment.aspx?FileName= <#=array[i].split("#")[0]#>&Type=3&FilePath=<#=array[i].split("#")[1]#>" target="_blank">
                                <img src="../../App_Images/attachment.png" />
                 <#=array[i].split("#")[0]#>
                              </a></div>
        <#}
 #>
    </td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.Answer#></td>
  <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.TATTime#></td>
</tr> 
  <#}#>

</table> 
            </div>  
           
    </script>
    </div>

   
  
    <script type="text/javascript">
        function getdataList(Status) {
            var Isfilter = 0;
            if ($('#chkcenterfilter').prop("checked") == true)
                Isfilter = "1";
            else
                Isfilter = "0";
            $.ajax({
                url: "TicketDashboard.aspx/GetIssueList",
                data: JSON.stringify({ Status: Status, fromDate: $('#<%=txtFromDate.ClientID%>').val(), toDate: $('#<%=txtToDate.ClientID%>').val(), Isfilter: Isfilter }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (data) {
                    var res = $.parseJSON(data.d);
                    var table = $('#datatable').DataTable();
                    var table1 = $('#datatable1').DataTable();
                    if (Status == "Resolved") {
                        $('#datatable').hide();
                        $('#datatable1').show();
                        table.destroy()
                        table1.destroy();
                        table1 = $('#datatable1').DataTable({
                            "scrollY": "300px",
                            "scrollX": true,
                            data: res,
                            "language": {
                                "info": "Showing _START_ to _END_ of _TOTAL_ records",
                                "infoEmpty": "Showing 0 to 0 of 0 entries",
                                "infoFiltered": "(filtered from _MAX_ total records)",
                                "infoPostFix": "",
                                "thousands": ",",
                                "lengthMenu": "Show _MENU_ records",
                                "loadingRecords": "Loading...",
                                "processing": "Processing...",
                                "search": "Search:",
                                "zeroRecords": "No matching records found",
                                "paginate": {
                                    "first": "First",
                                    "last": "Last",
                                    "next": "Next",
                                    "previous": "Previous"
                                },
                                "aria": {
                                    "sortAscending": ": activate to sort column ascending",
                                    "sortDescending": ": activate to sort column descending"
                                }
                            },
                            deferRender: true,
                            columns: [
                                {
                                    "class": 'details-control',
                                    "orderable": false,
                                    "data": null,
                                    "defaultContent": ''
                                },
                                {
                                    data: "ID", "bSearchable": true,
                                    bSortable: true,
                                    mRender: function (data, type, row) {
                                        attach = parseInt(row.Attachment) > 0 ? ' <img src="../../App_Images/attachment.png" style="width:16px;" />' : '';
                                        return '' + attach + '&nbsp;&nbsp;<a href="#"  style="curser:pointer;font-size: 18px;text-decoration: none;" >' + data + '</a> '
                                    }
                                },
                                //{ 'data': 'ID', "orderable": "true" },
                                { 'data': 'Status', "orderable": "true" },
                                   { 'data': 'GroupName', "orderable": "true" },
                                { 'data': 'CategoryName', "orderable": "true" },
                                { 'data': 'SubCategoryName', "orderable": "true" },
                                { 'data': 'Subject', "orderable": "true" },
                                { 'data': 'Message', "orderable": "true" },
                                 { 'data': 'VialId', "orderable": "true" },
                                 { 'data': 'RegNo', "orderable": "true" },
                                 { 'data': 'Centre', "orderable": "true" },
                                 { 'data': 'typeName', "orderable": "true" },
                                 { 'data': 'EmpName', "orderable": "true" },
                                 { 'data': 'dtAdd', "orderable": "true" },
                                  { 'data': 'ResolvedBy', "orderable": "true" },
                                 { 'data': 'ResolvedDate', "orderable": "true" },
                            ]
                        });
                        $('#dialog').dialog('open');
                        table1.columns.adjust().draw();
                        //$('#datatable1 tbody').off('click', 'td.details-control'); 
                        $('#datatable1 tbody').on('click', 'td.details-control', function () {
                            var tr = $(this).closest('tr');
                            var row = table1.row(tr);
                            if (row.child.isShown()) {
                                // This row is already open - close it
                                $('div.slider', row.child()).slideUp(function () {
                                    row.child.hide();
                                    tr.removeClass('shown');
                                });
                            }
                            else {
                                // Open this row
                                row.child(format(row.data()), 'no-padding').show();
                                tr.addClass('shown');
                                $('div.slider', row.child()).slideDown();
                            }
                        });
                    }
                    else {
                        $('#datatable1').hide();
                        $('#datatable').show();
                        table.destroy()
                        table1.destroy();
                        table = $('#datatable').DataTable({
                            "scrollY": "300px",
                            "scrollX": true,
                            data: res,
                            "language": {
                                "info": "Showing _START_ to _END_ of _TOTAL_ records",
                                "infoEmpty": "Showing 0 to 0 of 0 entries",
                                "infoFiltered": "(filtered from _MAX_ total records)",
                                "infoPostFix": "",
                                "thousands": ",",
                                "lengthMenu": "Show _MENU_ records",
                                "loadingRecords": "Loading...",
                                "processing": "Processing...",
                                "search": "Search:",
                                "zeroRecords": "No matching records found",
                                "paginate": {
                                    "first": "First",
                                    "last": "Last",
                                    "next": "Next",
                                    "previous": "Previous"
                                },
                                "aria": {
                                    "sortAscending": ": activate to sort column ascending",
                                    "sortDescending": ": activate to sort column descending"
                                }
                            },
                            deferRender: true,
                            columns: [
                                {
                                    "class": 'details-control',
                                    "orderable": false,
                                    "data": null,
                                    "defaultContent": ''
                                },
                                {
                                    data: "ID", "bSearchable": true,
                                    bSortable: true,
                                    mRender: function (data, type, row) {

                                        attach = parseInt(row.Attachment) > 0 ? ' <img src="../../App_Images/attachment.png" style="width:16px;" />' : '';
                                        return '' + attach + '&nbsp;&nbsp;<a href="#"  style="curser:pointer;font-size: 18px;text-decoration: none;" >' + data + '</a> '
                                    }
                                },
                                //{ 'data': 'ID', "orderable": "true" },
                                { 'data': 'Status', "orderable": "true" },
                                   { 'data': 'GroupName', "orderable": "true" },
                                { 'data': 'CategoryName', "orderable": "true" },
                                { 'data': 'SubCategoryName', "orderable": "true" },
                                { 'data': 'Subject', "orderable": "true" },
                                { 'data': 'Message', "orderable": "true" },

                                 { 'data': 'VialId', "orderable": "true" },
                                 { 'data': 'RegNo', "orderable": "true" },
                                 { 'data': 'Centre', "orderable": "true" },
                                 { 'data': 'typeName', "orderable": "true" },
                                 { 'data': 'EmpName', "orderable": "true" },
                                 { 'data': 'dtAdd', "orderable": "true" },
                                 { 'data': 'ElapsedTime', "orderable": "true" }
                            ]
                        });
                        $('#dialog').dialog('open');
                        table.columns.adjust().draw();
                        //$('#datatable tbody').off('click', 'td.details-control'); 
                        $('#datatable tbody').on('click', 'td.details-control', function () {
                            var tr = $(this).closest('tr');
                            var row = table.row(tr);
                            // console.log('callinit');
                            if (row.child.isShown()) {
                                // This row is already open - close it
                                $('div.slider', row.child()).slideUp(function () {
                                    row.child.hide();
                                    tr.removeClass('shown');
                                });
                            }
                            else {
                                // Open this row
                                row.child(format(row.data()), 'no-padding').show();
                                tr.addClass('shown');
                                $('div.slider', row.child()).slideDown();
                            }
                        });
                    }
                }
            });

        }

        function format(d) {
            BindReplyes(d.ID);
            var data = $('#divReplyOutput').html();
            return data;

        }

    </script>

    <script type="text/javascript">
        function BindReplyes(TicketID) {

            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            jQuery.ajax({
                url: "AnswerTicket.aspx/GetReply",
                data: '{ TicketId: "' + TicketID + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    ReplyData = $.parseJSON(result.d);

                    jQuery('#divReplyOutput').html('');
                    var output = jQuery('#tb_Reply').parseTemplate(ReplyData);
                    jQuery('#divReplyOutput').html(output);

                    jQuery.unblockUI();
                },
                error: function (xhr, status) {
                    jQuery.unblockUI();

                }
            });


        }
    </script>
     <script type="text/javascript">
         jQuery(document).ready(function () {
             $("#dialog").dialog({
                 autoOpen: false,
                 modal: true,
                 height: 500,
                 width: 1300,
                 open: function () {
                     jQuery('.ui-widget-overlay').bind('click', function () {
                         jQuery('#dialog').dialog('close');
                     })
                 }
             });
         });

    </script>

     <script type="text/javascript">
         jQuery(function () {
             google.charts.load("current", { packages: ['corechart'] });
             $("#btnSearch").trigger('click');
             //searchTicket();
         });
         function searchTicket() {
             var Isfilter = 0;
             if ($('#chkcenterfilter').prop("checked") == true)
                 Isfilter = "1";
             else
                 Isfilter = "0";
             jQuery.ajax({
                 url: "TicketDashboard.aspx/bindTicketStatusCount",
                 data: '{ fromDate:"' + $('#<%=txtFromDate.ClientID%>').val() + '",toDate:"' + $('#<%=txtToDate.ClientID%>').val() + '",Isfilter:"' + Isfilter + '"}', // parameter map 
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     TicketStatusData = jQuery.parseJSON(result.d);
                     if (TicketStatusData != null) {
                         var output = $('#sc_TicketCount').parseTemplate(TicketStatusData);
                         jQuery('#div_Ticket').html(output);
                         jQuery('.ticketStatus').show();
                         jQuery('#tb_TicketCount tr:even').addClass("GridViewAltItemStyle");
                         drawChart(TicketStatusData);
                     }
                     else {
                         jQuery('#div_Ticket').html('');
                         jQuery('.ticketStatus').hide();
                     }
                 },
                 error: function (xhr, status) {
                 }
             });
         }

    </script>
      
  <script type="text/javascript">
      var data;
      var chart;
      function drawChart(Jsondata) {
          data = new google.visualization.DataTable();
          data.addColumn('string', 'word');
          data.addColumn('number', 'count');

          for (var i = 0; i < Jsondata.length; i++) {
              data.addRow([Jsondata[i].Status, Jsondata[i].StatusCount]);
          }

          var options = {
              title: "Ticket",

              backgroundColor: '#d7edff',
              legend: 'none',
              pieSliceText: 'label',
              title: 'Ticket',
              pieStartAngle: 100,
          };
          chart = new google.visualization.PieChart(document.getElementById("div_TicketGraph"));
          chart.draw(data, options);
          google.visualization.events.addListener(chart, 'select', selectHandler);

      }
      function selectHandler(event) {

          var selection = chart.getSelection()[0];
          if (selection) {
              var status = data.getValue(selection.row, 0);
              getdataList(status);

          }

      }
  </script>
    <script type="text/javascript">
        $(document).on("mouseenter", "a.im", function (e) {
            //console.log('call');
            var url = $(this).attr("url");

            var ext = url.substring(url.lastIndexOf(".") + 1);
            if (ext != "doc" && ext != "docx") {
                openpopup(url)
            }
        });
        function openpopup(FilePath) {
            window.open('image.aspx?FilePath=' + FilePath, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
        }
    </script>
    <link href="../../App_Style/jquery.dataTables.min.css" rel="stylesheet" />

</asp:Content>

 

