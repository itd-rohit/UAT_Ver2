<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HistoSampleCorrection.aspx.cs" Inherits="Design_Lab_HistoSampleCorrection" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
  
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <style type="text/css">
        #plo span{color:maroon;}
    </style>

         <div class="alert fade" style="position:absolute;left:50%;border-radius:15px;">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
     <Ajax:ScriptManager ID="sm1" runat="server" />
     <div id="Pbody_box_inventory" style="width:900px" >
     <div class="POuter_Box_Inventory"  style="width:900px" >
          <div class="content" style="text-align: center;">
                <b>Change Doctor and Sample Info For HistoCyto</b>
                <br />
              <asp:Label ID="lbmsg" CssClass="ItDoseLblError" runat="server"></asp:Label>
                </div>
         </div>

          <div class="POuter_Box_Inventory"  style="width:900px" >
                 <div class="Purchaseheader">Search Data</div>
          <div class="content" style="text-align: center;">
              <table width="99%">
                  <tr>
                      <td style="text-align: right"><b>Sin No/Visit ID :&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtbarcodeno" runat="server" placeholder="Enter SIN No OR Visit ID"></asp:TextBox>
                      </td>
                  </tr>
                  <tr>
                      <td style="text-align: right">&nbsp;</td>
                      <td style="text-align: left">
                          &nbsp;</td>
                  </tr>
                  <tr>
                      <td style="text-align: right">&nbsp;</td>
                      <td style="text-align: left">
                  <input type="button"  onclick="getdata()" value="Search Patient" class="searchbutton" /></td>
                  </tr>
                  <tr>
                      <td style="text-align: right">&nbsp;</td>
                      <td style="text-align: left">
                          &nbsp;</td>
                  </tr>
                  <tr>
                      <td style="text-align: right; font-weight: 700;">Test Name :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                      <td style="text-align: left">
                         <asp:DropDownList ID="ddltest" runat="server" Width="200px" onchange="getdatatestwise()"></asp:DropDownList></td>
                  </tr>
              </table>
              </div> </div>
                <div class="POuter_Box_Inventory"  style="width:900px" >
                     <div class="Purchaseheader">Search Detail</div>
              <div id="plo" style="width:900px;display:none;" class="content" >
                  <table width="99%">
                         <tr>
                          <td>
                              <b>SIN No:
                          </b>
                          </td>
                          <td style="font-weight: 700">
                              <span id="sinno"></span>
                          </td>
                          <td style="font-weight: 700">Slide No:</td>
                          <td style="font-weight: 700"><span id="slidenumber"></span></td>
                          <td style="font-weight: 700">&nbsp;</td>
                          <td style="font-weight: 700">Visit No:</td>
                          <td colspan="2" style="font-weight: 700">
                              <span id="visitno"></span>
                          </td>
                      </tr>
                      <tr>
                          <td>
                              <b>Patient Name:
                          </b>
                          </td>
                          <td style="font-weight: 700">
                              <span id="pname"></span>
                          </td>
                          <td style="font-weight: 700" colspan="4">Age/Gender:</td>
                          <td colspan="2" style="font-weight: 700">
                              <span id="pinfo"></span>
                          </td>
                      </tr>

                      <tr>
                          <td><b>Test Name:</b></td>
                          <td colspan="7" style="font-weight: 700">
                              <span id="testname"></span>
                          </td>
                      </tr>
                      <tr>
                          <td><b>Booking Centre:</b></td>
                          <td colspan="7" style="font-weight: 700">
                              <span id="bcentre"></span></td>
                      </tr>
                      <tr>
                          <td><b>Processing Centre:</b></td>
                          <td colspan="7" style="font-weight: 700">
                              <span id="pcentre"></span></td>
                      </tr>
                      <tr>
                          <td><b></b></td>
                          <td colspan="7">
                            <span id="testid" style="display:none;"></span>  </td>
                      </tr>
                      <tr>
                          <td><b>Specimen Type:</b></td>
                          <td colspan="7">
                             <input id="txtspecimentype" type="text" placeholder="Enter Specimen Type" style="width:200px;"  /></td>
                      </tr>
                      <tr>
                          <td colspan="2" style="height: 29px"><b>No of Container:&nbsp;
                             </b>
                             <select id="ddlnoofsp" style="font-weight: bold"><option>0</option>
                                   <option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>
                                   <option>6</option><option>7</option><option>8</option><option>9</option></select></td>
                          <td colspan="5" style="height: 29px">
                              <strong>No of Slides:</strong>&nbsp;
                               <select id="ddlnoofsli"><option>0</option>
                                   <option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>
                                   <option>6</option><option>7</option><option>8</option><option>9</option></select></td>
                          <td style="height: 29px">
                              <strong>No of Block:</strong>
                               <select id="ddlnoofblock"><option>0</option>
                                   <option>1</option><option>2</option><option>3</option><option>4</option><option>5</option>
                                   <option>6</option><option>7</option><option>8</option><option>9</option></select></td>
                      </tr>
                      <tr>
                          <td><b>Performing Doctor:</b></td>
                          <td colspan="7">
                               <select class="performingdoc" id="performingdocid" style="width:250px;"> </select>
                          </td>
                      </tr>

                  </table>
              </div>
                   

                      <div id="divsave" style="width:900px;display:none;text-align:center" class="content" >
                          <input type="button" value="Save" class="savebutton" onclick="savedata()" />
                          </div>
              </div>
         </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=txtbarcodeno.ClientID%>').focus();
            tablefuncation();
            $("#<%= txtbarcodeno.ClientID%>").keydown(
               function (e) {
                   var key = (e.keyCode ? e.keyCode : e.charCode);
                   if (key == 13) {
                       e.preventDefault();
                       if ($.trim($('#<%=txtbarcodeno.ClientID%>').val()) != "") {
                           
                           getdata();
                        }



                    }

                });
            });

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
        function getdata() {
            if ($('#<%=txtbarcodeno.ClientID%>').val() == "") {
                showerrormsg("Please Enter Sin No or Visit ID");
                $('#<%=txtbarcodeno.ClientID%>').focus();
                return;
            }
            var dropdown = $("#<%=ddltest.ClientID%>");
            $("#<%=ddltest.ClientID%> option").remove();
            $modelBlockUI();
            $.ajax({
                url: "HistoSampleCorrection.aspx/getdatatestonly",
                data: '{sinno:"' + $('#<%=txtbarcodeno.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var pdata = $.parseJSON(result.d);
                    if (pdata.length == 0) {
                        clearform();
                        $('#plo').hide();
                        $('#divsave').hide();
                        showerrormsg("Wrong Sin No or Visit ID");
                        $('#<%=txtbarcodeno.ClientID%>').val('');
                        $('#<%=txtbarcodeno.ClientID%>').focus();
                        $modelUnBlockUI();
                        return;
                    }
                    for (i = 0; i < pdata.length; i++) {
                        dropdown.append($("<option></option>").val(pdata[i].test_id).html(pdata[i].name));
                    }
                    $modelUnBlockUI();
                    getdatatestwise();
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    StatusOFReport = "";
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
           
        }

        function getdatatestwise() {
            $modelBlockUI();
            $.ajax({
                url: "HistoSampleCorrection.aspx/getdata",
                data: '{sinno:"' + $('#<%=ddltest.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var pdata = $.parseJSON(result.d);
                    if (pdata.length == 0) {
                        clearform();
                        $('#plo').hide();
                        $('#divsave').hide();
                        showerrormsg("Wrong Sin No or Visit ID");
                        $('#<%=txtbarcodeno.ClientID%>').val('');
                        $('#<%=txtbarcodeno.ClientID%>').focus();
                        $modelUnBlockUI();
                        return;
                    }
                    clearform();
                    $('#plo').show();
                    $('#pname').html(pdata[0].PName);
                    $('#testname').html(pdata[0].testname);
                    $('#pinfo').html(pdata[0].Age + "/" + pdata[0].Gender);
                    $('#bcentre').html(pdata[0].BookingCentre);
                    $('#pcentre').html(pdata[0].ProcessingCentre);
                    $('#sinno').html(pdata[0].BarcodeNo);
                    $('#visitno').html(pdata[0].LedgerTransactionNo);
                    $('#txtspecimentype').val(pdata[0].SampleTypeName);
                    $('#performingdocid').val(pdata[0].HistoCytoPerformingDoctor);
                    var histonumber = pdata[0].HistoCytoSampleDetail;
                    $("#ddlnoofsp").val(histonumber.split('^')[0]);
                    $("#ddlnoofsli").val(histonumber.split('^')[1]);
                    $("#ddlnoofblock").val(histonumber.split('^')[2]);
                    $('#testid').html(pdata[0].Test_ID);
                    $('#slidenumber').html(pdata[0].slidenumber);
                    if (pdata[0].Result_Flag == "0") {
                        $('#divsave').show();
                    }
                    else {
                        $('#divsave').hide();
                    }
                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    StatusOFReport = "";
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function tablefuncation() {
            var dropdown = $(".performingdoc");
            $(".performingdoc option").remove();
            dropdown.append($("<option></option>").val("0").html("Select Doctor"));
            $.ajax({
                url: "HistoSampleCorrection.aspx/getdoclist",
                data: '{ }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                    if (PanelData.length > 0) {
                        for (i = 0; i < PanelData.length; i++) {
                            dropdown.append($("<option></option>").val(PanelData[i].employeeid).html(PanelData[i].Name));
                        }
                    }

                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

            
        }

        function clearform() {
            $('#plo').hide();
            $('#pname').html('');
            $('#testname').html('');
            $('#pinfo').html('');
            $('#bcentre').html('');
            $('#pcentre').html('');
            $('#sinno').html('');
            $('#visitno').html('');
            $('#txtspecimentype').val('');
            $('#performingdocid').val('0');
            var histonumber = "0^0^0";
            $("#ddlnoofsp").val(histonumber.split('^')[0]);
            $("#ddlnoofsli").val(histonumber.split('^')[1]);
            $("#ddlnoofblock").val(histonumber.split('^')[2]);
            $('#testid').html('');
            $('#divsave').hide();
            $('#slidenumber').html('');
        }

        function savedata() {
            if ($('#txtspecimentype').val() == "") {
                showerrormsg("Please Enter Specimen Type");
                $('#txtspecimentype').focus();
                return;
            }
            if ($('#performingdocid').val() == "0") {
                showerrormsg("Please Select Performing Doctor");
                $('#performingdocid').focus();
                return;
            }
            if ($('#ddlnoofsp').val() == "0") {
                showerrormsg("Please Select No of Container");
                $('#ddlnoofsp').focus();
                return;
            }
            if ($('#ddlnoofsli').val() == "0") {
                showerrormsg("Please Select No of Slides");
                $('#ddlnoofsli').focus();
                return;
            }
            if ($('#ddlnoofblock').val() == "0") {
                showerrormsg("Please Select No of Block");
                $('#ddlnoofblock').focus();
                return;
            }
            var samplerec = $('#ddlnoofsp').val() + "^" + $('#ddlnoofsli').val() + "^" + $('#ddlnoofblock').val();
            $modelBlockUI();
            $.ajax({
                url: "HistoSampleCorrection.aspx/savedata",
                data: '{ testid:"' + $('#testid').html() + '",specimen:"' + $('#txtspecimentype').val() + '",doc:"' + $('#performingdocid').val() + '",sampleinfo:"' + samplerec + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: true,
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Record Saved Sucessfully.!");
                        clearform();
                        $("#<%=ddltest.ClientID%> option").remove();
                        $('#<%=txtbarcodeno.ClientID%>').val('');
                        $('#<%=txtbarcodeno.ClientID%>').focus();
                    }
                    else {
                        showerrormsg(result.d);
                    }
                    $modelUnBlockUI();

                },
                error: function (xhr, status) {
                    //  alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>
</asp:Content>

