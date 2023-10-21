<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowRerun.aspx.cs" ClientIDMode="Static" Inherits="Design_Mobile_ShowRerun" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

</head>
<body>
    <form id="form1" runat="server">


        <div class="modal fade" id="ReRunModel" role="dialog">
            <div class="vertical-alignment-helper">
                <div class="modal-dialog vertical-align-center">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h5 class="modal-title">Rerun ::
                                <asp:Label ID="lbtestname" runat="server"></asp:Label>
                            </h5>
                            
                        </div>

                        <div class="modal-body" style="padding-top:0;">
                            <div class="row"> 
                           <div class="col-xs-12 col-md-12 col-lg-12 col-sm-12 nopadding">
                            <div class="panel panel-success">
                            <table class="table table-hover" id="RerunTable">
                                <thead>
                                    <tr>

                                        <th>Sr.No</th>
                                        <th>Parameter</th>
                                        <th>Value</th>
                                        <th>
                                            <input id="chkall" type="checkbox" onchange="checkall(this)" /></th>


                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (int row = 0; row <= datatable.Rows.Count - 1; row++)
                                       { %>
                                    <tr>
                                        <td><%=row+1 %></td>
                                        <td class="Name"><%=datatable.Rows[row]["Name"].ToString()%></td>
                                        <td class="Value"><%=datatable.Rows[row]["value"].ToString()%>
                                            <input type="hidden" value="<%=datatable.Rows[row]["labObservation_ID"].ToString()%>" class="labObservation_ID"  />
                                             <input type="hidden" value="<%=datatable.Rows[row]["BarCodeNo"].ToString()%>" class="BarCodeNo"  />
                                            
                                        </td>
                                        <td class="chk">
                                            <input type="checkbox" class="ch" /></td>

                                    </tr>
                                    <%} %>
                                </tbody>
                            </table>
                                     </div>
                         
                                </div>
                        <div class="col-xs-12 col-md-12 col-lg-12 col-sm-12 nopadding">&nbsp;&nbsp;Resion: <input type="text" value=""  id="resion" style="width:80%;" /></div>  
                                </div>
                        </div>
                        <div class="modal-footer">
                           
                            <button type="button" class="btn btn-primary" onclick="SaveRerun()">Save</button>
                            <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>


    <script type="text/javascript">
        $(function () {
            $('#ReRunModel').modal('show');

        });
        function checkall(e) {

            if ($(e).prop("checked") == true) {              
                $('.ch').prop('checked', true);
            }
            if ($(e).prop("checked") == false) {
                $('.ch').prop('checked', false);
            }

        }
        function SaveRerun()
        {
            var dataItem = new Array();
            var obj = new Object();
            $('#RerunTable > tbody > tr').each(function (i, el) {
                obj = new Object();
                if ($(this).find("input[type=checkbox]").prop("checked") == true) {                     
                    obj.Chk = true;
                    obj.Name = $(this).find(".Name").text();
                    obj.Value = $(this).find(".Value").text();
                    obj.labObservation_ID = $(this).find('.labObservation_ID').val();
                    obj.BarCodeNo = $(this).find('.BarCodeNo').val();
                    dataItem.push(obj);   
                }
            });
            var resion = $('#resion').val();
            if (dataItem == '') {
                $("#msgtitle").html("ReRun");
                $('#massage').html('Please Select Parameter To Rerun !');
                $('#msgModal').modal('show');
                return;
            }
            if (resion == '') {
                $("#msgtitle").html("ReRun");
                $('#massage').html('Please Enter Reason!');
                $('#msgModal').modal('show');
                return;
            }
            var TestID = '<%=Request.QueryString["TestID"].ToString() %>';
            $.ajax({
                type: "POST",
                url: "ShowRerun.aspx/Save", 
                data: "{ItemDetail:'" + JSON.stringify(dataItem) + "',resion:'" + resion + "',TestID:'" + TestID + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    if (result.d == "1") {
                        $("#msgtitle").html("ReRun");
                        $('#massage').html('Test Rerun Success!');
                        $('#msgModal').modal('show');
                        $('#ReRunModel').modal('hide');
                    }
                },
                failure: function (response) {
                    $("#msgtitle").html("ReRun");
                    $('#massage').html(response.Message);
                    $('#msgModal').modal('show');
                }
            });
        }
    </script>





</body>
</html>
