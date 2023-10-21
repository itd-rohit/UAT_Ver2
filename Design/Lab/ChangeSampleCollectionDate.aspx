<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ChangeSampleCollectionDate.aspx.cs" Inherits="Design_Lab_ChangeSampleCollectionDate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
  <link href="//netdna.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" rel="stylesheet">
<script src="//netdna.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.8.4/moment.min.js"></script>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/css/bootstrap-timepicker.min.css" rel="stylesheet"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-timepicker/0.5.2/js/bootstrap-timepicker.min.js" type="text/javascript"></script>
     <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
     <div id="Pbody_box_inventory" style="width:1300px;">
                <div class="POuter_Box_Inventory" style="text-align: center;width:1300px;">

                    <b>&nbsp; Change Sample Collection Date </b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

                </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
                    <div class="Purchaseheader">
                        Search&nbsp;
                    </div>
              
               <table style="width:99%">
                   <tr>
                       <td style="text-align: right"><b>Visit No : </b></td>
                        <td Width="50px;"> <asp:TextBox ID="txtvisitno" runat="server" ></asp:TextBox>
                             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers,LowercaseLetters, UppercaseLetters"  TargetControlID="txtvisitno" />
                        </td>
                        <td>  <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="GetData();" /> </td>
                        <td></td>
                       </tr>
                  
                  
                   </table>


              <br />
              <br />
              <table id="tblpatient" style="width:99%">
                  <tr>
                     <td align="right"><b> Patient Name : </b></td>
                      <td align="left"><asp:Label ID="lblname" runat="server"></asp:Label></td>
                      <td align="right"><b> Age : </b></td>
                       <td align="left"><asp:Label ID="lblage" runat="server"></asp:Label></td>
                      <td align="right"><b> Gender : </b></td>
                       <td align="left"><asp:Label ID="lblgender" runat="server"></asp:Label></td>
                        <td align="right"><b> Panel : </b></td>
                       <td align="left"><asp:Label ID="lblpanel" runat="server"></asp:Label></td>
                       <td align="right"><b> Center : </b></td>
                       <td align="left"><asp:Label ID="lblcenter" runat="server"></asp:Label></td>
                    </tr>
                        <tr>
                    
                      
                  </tr>


              </table>
              </div>



         <div class="TestDetail" style="margin-top: 5px; max-height: 505px; overflow: scroll; width: 100%;">
                                            <table id="tbItemList" style="width: 99%; border-collapse: collapse">
                                                <tr id="header">
                                                    <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                                    <td class="GridViewHeaderStyle" style="width: 50px; text-align: center">Sin No</td>
                                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Test</td>
                                                     <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Sample Collection Date</td>
                                                             <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Department Receive Date</td>
                                                    <td class="GridViewHeaderStyle" style="width: 100px; text-align: center">Action</td>

                                                </tr>
                                            </table>
                                        </div>


         <div id="dvsetdate">

            <b> Change Sample Date Time : </b> <input type='text' id="txtdate"  class='setmydate' name='setmydate' style='width: 135px;'   />
             <input type="text" id="txttime" class="timepicker input-small"/>
    <span class="add-on">
        <i class="icon-time"></i>
    </span>
<input id='btnUpdate' type='button' value='Update' class='searchbutton' onclick='UpdateData(this);' />

         </div>

         </div>

     <script type="text/javascript">
         $(function () {
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

             $('#dvsetdate').hide();
             $('#tblpatient').hide();
         });


         $('.timepicker').timepicker({
             template: 'dropdown',
             showInputs: false,
             showSeconds: false
         });

         $('.setmydate').datepicker({
             dateFormat: "dd-M-yy ",
             changeMonth: true,
             changeYear: true, yearRange: "-20:+0"

         }).attr('readonly', 'readonly');
         function showmsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', '#04b076');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function showerrormsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', 'red');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
    </script>


     <script type="text/javascript">
         function GetData() {
             if ($('#<%=txtvisitno.ClientID%>').val() == "") {
                 showerrormsg("Please Fill Sin No :");
                 $('#tbItemList tr').slice(1).remove();
                 $('#tblpatient').hide();
                 return;
             }
             $modelBlockUI();
             $('#<%=txtvisitno.ClientID%>').attr("disabled", true);
            $.ajax({
                url: "ChangeSampleCollectionDate.aspx/GetData",
                data: '{ VisitNo: "' + $('#<%=txtvisitno.ClientID%>').val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
        
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        $('#tbItemList tr').slice(1).remove();
                        $('#tblpatient').hide();
                        $('#dvsetdate').hide();
                        showerrormsg("No Data Found");
                        $('#<%=txtvisitno.ClientID%>').attr("disabled", false);
                        $('#<%=txtvisitno.ClientID%>').val("");
                        $modelUnBlockUI();
                    }
                    else {
                        $('#dvsetdate').show();
                        $('#tblpatient').show();
                        $modelUnBlockUI();
                        $('#<%=txtvisitno.ClientID%>').attr("disabled", false);
                        $('#tbItemList tr').slice(1).remove();
                        $('#<%=lblname.ClientID%>').text(ItemData[0].pname);
                        $('#<%=lblage.ClientID%>').text(ItemData[0].Age);
                        $('#<%=lblgender.ClientID%>').text(ItemData[0].Gender);
                        $('#<%=lblpanel.ClientID%>').text(ItemData[0].PanelName);
                        $('#<%=lblcenter.ClientID%>').text(ItemData[0].Centre);
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                           
                            var mydata = "<tr >";
                            mydata += '<td >' + parseInt(i + 1) + '</td>';
                            mydata += '<td id="barcode">' + ItemData[i].BarcodeNo + '</td>';
                            mydata += '<td id="testname">' + ItemData[i].Itemname + '</td>';
                            mydata += '<td class="sampledate">' + ItemData[i].sampledate + '</td>';
                            mydata += '<td class="DeptReceive" >' + ItemData[i].sampleReceivedate + '</td> '
                            mydata += '<td class="testid" style="display:none;">' + ItemData[i].Test_id + '</td> '
                            if (ItemData[i].Approved == "0") {
                                mydata += '<td class="GridViewLabItemStyle"><input type="checkbox" name="samplechk" value=' + ItemData[i].Test_id + '>    &nbsp;   </td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle"></td>';

                            }
                         
                            $('#tbItemList').append(mydata);
                        }
                       
                    }

                },
                error: function (xhr, status) {
                    alert("Error ");
                    $('#<%=txtvisitno.ClientID%>').attr("disabled", false);
                    $modelUnBlockUI();
                }
            });
         }



         function UpdateData(ctrl) {

             debugger;

             if ($(ctrl).closest('tr').find("input[name='setmydate']").val() == "")
             {
                 showerrormsg(" Please fill Sample Collection Date ");
                 return;
             }
             if ($('#txtdate').val() == "" || $('#txtdate').val() == null) {
                 showerrormsg("Please Set Sample date");
                 return;
             }

             if ($('#txttime').val() == "" || $('#txttime').val() == null) {
                 showerrormsg("Please Set Sample Time");
                 return;
             }

             var checkedValues = $("input[name='samplechk']:checked", "#tbItemList").map(function () {
                 return $(this).val();
             }).get();
             if (checkedValues.length == 0) {
                 showerrormsg("Please select minimum one option");
                 return;
             }
             var setdate = $('#txtdate').val() + $('#txttime').val();
             setdate = new Date(setdate).toLocaleDateString();
             var dataIm = new Array();
             var objsample = new Object();
             $('#tbItemList tr').each(
                function () {
                    var row = $(this);
                    if (row.find('input[name="samplechk"]').is(':checked')) {

                        var currentsampledate = $('#txtdate').val() + $('#txttime').val();
                        currentsampledate = new Date(currentsampledate).getTime();

                        var Deptreceivetime = row.find('td:eq(4)').text();
                        if (Deptreceivetime == "") {
                            Deptreceivetime = new Date().getTime();
                        }
                        else {
                            Deptreceivetime = new Date(row.find('td:eq(4)').text()).getTime();
                        }
                        if (Deptreceivetime >= currentsampledate) {
                            objsample.sampledate = new Date($('#txtdate').val() + $('#txttime').val());
                            objsample.testid = row.find('td:eq(5)').text();
                            dataIm.push(objsample);
                            objsample = new Object();
                        }
                        else {

                            showerrormsg("Sample date less or equal to Departmet Receive date");
                            return;
                        }
                    }
                   
                    return dataIm;
                });

             if (dataIm.length > 0) {

                 $.ajax({
                     url: "ChangeSampleCollectionDate.aspx/UpdateData",
                     data: JSON.stringify({ objSampledetails: dataIm }), // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == "1") {
                             showmsg("Update successfully");
                             $modelUnBlockUI();
                             $('#dvsetdate').hide();
                             GetData();
                         }
                         else {
                             showerrormsg("somthing went wrong");
                             $modelUnBlockUI();
                             $('#dvsetdate').hide();
                         }
                     }
                 });
             }
            

         }

       
        



         </script>
</asp:Content>

