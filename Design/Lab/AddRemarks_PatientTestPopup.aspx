<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddRemarks_PatientTestPopup.aspx.cs" Inherits="Design_Lab_AddRemarks_PatientTestPopup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<style type="text/css">
    .auto-style1 {
        font-size: 9pt;
        font-family: Verdana, Arial, sans-serif, sans-serif;
        width: 196px;
        height: 20px;
    }

    .auto-style2 {
        width: 256px;
        height: 20px;
    }

    .auto-style3 {
        width: 200px;
        height: 20px;
    }

    .auto-style4 {
        width: 268px;
        height: 20px;
    }
</style>
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
<script src="../../Scripts/jquery-3.1.1.min.js"></script>
<script src="../../Scripts/Common.js"></script>
<script src="../../Scripts/toastr.min.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>

</head>
<body>
    <form id="form1" runat="server">
      
            <div id="Pbody_box_inventory" style="vertical-align:top;margin:-0px">
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    
                            <b>Add New Remarks</b>
                        
                        <br />
                        <div style="text-align: left;">
                            <b>Test Name : &nbsp;<asp:Label ID="lblTestName" runat="server"></asp:Label></b>
                            &nbsp;
                        </div>
                    </div>            
                <div class="POuter_Box_Inventory" style="text-align: center; ">                   
                    <input id="btnAdd" type="button" value="Add Remark" style="cursor: pointer; " onclick="ShowTemplate()" />
                    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdPatientremarks"
                        style="width: 800px; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="display: none;">ID</th>
                                <th class="GridViewHeaderStyle" scope="col">S.No.</th>
                                <th class="GridViewHeaderStyle" scope="col">Date</th>                               
                                <th class="GridViewHeaderStyle" scope="col">User Name</th>
                                <th class="GridViewHeaderStyle" scope="col">Remarks</th>
                                <th class="GridViewHeaderStyle" scope="col">Show Online</th>
                                <th class="GridViewHeaderStyle" scope="col">Add</th>
                                <th class="GridViewHeaderStyle" scope="col">Remove</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr id="tr_Data">
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    <table id="tblAddRemark">
                        <tr id="tr_input">
                            <td id="td_Date"><%=CurrentDataTimeDisp %></td>                         
                            <td id="td_UserName"><%=UserName %></td>
                            <td id="td_Remarks">
                                <input type="text" id="txtRamrks" style="display: none;" />
                                <asp:DropDownList ID="ddlRemarks" runat="server" onchange="setRemarks();">
                                    <asp:ListItem Value="Sample Rejected" Text="Sample Rejected"></asp:ListItem>
                                    <asp:ListItem Value="Others" Text="Others"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td id="td_ShowOnLine">
                                <input id="chkRemarks" type="checkbox" name="chkRemarks" />Show Online</td>
                            <td>
                                <img src="../../App_Images/save.png" onclick="SavePatientRemarks(this);" width="25px" height="25px" alt="Save" style="cursor: pointer;" /></td>
                        </tr>
                    </table>
                </div>
               
            </div>
          
    </form>
       <script type="text/javascript">
           $(function () {
               var Offline = '<%=Offline%>';
            if (Offline == '1') {
                $('#chkRemarks').attr('checked', 'disabled');
                $('#chkRemarks').attr('disabled', 'disabled');
            }
            else {
                $('#chkRemarks').removeAttr('disabled');
                $('#chkRemarks').removeAttr('disabled');
            }
            GetRemarks();
            $('#tblAddRemark').hide();
        });
        function GetRemarks() {
            var lastRow = $('#tb_grdPatientremarks tbody tr#tr_Data').html();
            $('#tb_grdPatientremarks tr').slice(1).remove();
            var TestID = '<%=TestID%>';
           var Offline = '<%=Offline%>';

           serverCall('AddRemarks_PatientTestPopup.aspx/GetRemarks', { TestID: TestID, Offline: Offline }, function (response) {
               RemarksData = JSON.parse(response);
               for (var i = 0; i <= RemarksData.length - 1; i++) {
                   var $mydata = [];
                   $mydata.push("<tr>");
                   $mydata.push("<td>" + (RemarksData.length - (i)) + "</td>");
                   $mydata.push("<td>");
                   $mydata.push(RemarksData[i].DATE); $mydata.push("</td>");
                   
                   $mydata.push("<td>");
                   $mydata.push(RemarksData[i].UserName); $mydata.push("</td>");
                   $mydata.push("<td style='text-align:left'>");
                   $mydata.push(RemarksData[i].Remarks); $mydata.push("</td>");
                   $mydata.push("<td>");
                   $mydata.push(RemarksData[i].ShowOnline); $mydata.push("</td>");
                   $mydata.push("<td></td>");
                   $mydata.push("<td><img src='../../App_Images/cancel2.png' onclick='DeleteRemarks(");
                   $mydata.push(RemarksData[i].ID);
                   $mydata.push(");' width='25px' height='25px' alt='Save' style='cursor: pointer;' /></td>");
                   $mydata.push("</tr>");
                   $mydata = $mydata.join("");
                   $('#tb_grdPatientremarks').prepend($mydata);
               }
               var $mydata = [];
               $mydata.push('<tr id="tr_Data">');
               $mydata.push(lastRow); $mydata.push('</tr>');
               $mydata = $mydata.join("");
               $('#tb_grdPatientremarks').append($mydata);
               $('#tblAddRemark').hide();
           });
       }
       function SavePatientRemarks(val) {
           var TestID = '<%=TestID%>';
           var Remarks;
           if ($('#<%=ddlRemarks.ClientID%>').val() == "Others") {
               Remarks = $('#txtRamrks').val();
               if (Remarks == '') {
                   toast("Error", "Please Enter Remarks", "");
                   return;
               }
           }
           else {
               Remarks = $('#tblAddRemark tr#tr_input').find('#ddlRemarks').val();
           }
           var VisitNo = '<%=VisitNo%>';
           var ShowOnline = 0;
           $('#<%=ddlRemarks.ClientID%>').val('Sample Rejected');
           if ($('#tblAddRemark tr#tr_input').find('#chkRemarks').prop('checked'))
               ShowOnline = 1;
           var Offline = '<%=Offline%>';

           var _temp = [];
           _temp.push(serverCall('AddRemarks_PatientTestPopup.aspx/SavePatientRemarks', { TestID: TestID, Remarks: Remarks, VisitNo: VisitNo, ShowOnline: ShowOnline, Offline: Offline }, function (response) {
               $.when.apply(null, _temp).done(function () {
                   var $responseData = JSON.parse(response);
                   if ($responseData.status) {
                       toast("Success", $responseData.response, "");
                       $('#txtRamrks').hide();
                       GetRemarks();
                   }
                   else {
                       $('#tblAddRemark').show();
                       toast("Error", $responseData.response, "");
                   }
               });
           }));
       }
       function DeleteRemarks(ID) {
           var _temp = [];
           _temp.push(serverCall('AddRemarks_PatientTestPopup.aspx/DeleteRemarks', { ID: ID }, function (response) {
               $.when.apply(null, _temp).done(function () {
                   var $responseData = JSON.parse(response);
                   if ($responseData.status) {
                       toast("Success", $responseData.response, "");
                       $('#txtRamrks').hide();
                       GetRemarks();
                   }
                   else {
                       toast("Error", $responseData.response, "");
                   }
               });
           }));
       }
       function setRemarks() {
           $('#txtRamrks').val('');
           if ($('#<%=ddlRemarks.ClientID%>').val() == "Others") {
               $('#txtRamrks').show();
               $('#txtRamrks').focus();
           }
           else {
               $('#txtRamrks').hide();
           }
       }
       function ShowTemplate() {
           $('#tblAddRemark').show();
       }
    </script>
</body>
</html>
