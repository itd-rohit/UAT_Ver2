<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ILCResultReject.aspx.cs" Inherits="Design_Quality_ILCResultReject" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
     <%:Scripts.Render("~/bundles/JQueryUIJs") %>
     <%:Scripts.Render("~/bundles/Chosen") %>
     <%:Scripts.Render("~/bundles/MsAjaxJs") %>
     <%:Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
         
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 

      <div id="Pbody_box_inventory" style="width:1304px;">
              <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <table width="99%">
                    <tr>
                        <td align="center">
                          <b>ILC Registration Rejection </b>  

                            &nbsp;<br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
                  </div>

            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="100%">
                    <tr>
                        <td style="font-weight: 700">Select Centre :
                        </td>

                        <td>
                            <asp:DropDownList class="ddlprocessinglab chosen-select chosen-container" ID="ddlprocessinglab" runat="server" Style="width: 400px;" ></asp:DropDownList>



                        </td>



                            <td style="font-weight: 700">Month/Year :</td>

                        <td>
                           
                            <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="100px"></asp:DropDownList>

                            <asp:TextBox ID="txtcurrentyear" ReadOnly="true" runat="server" Width="65px"></asp:TextBox>
                             
                           
                        </td>
                        <td>
                            <input type="button" value="Search" class="searchbutton" onclick="SearchNow()" />

                           


                        </td>
                    </tr>


                    


                </table>
                </div>
                </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
               <div class="content">
                  <div class="Purchaseheader">
                    
                  <table>
                <tr>
                 
                     <td>Data List</td>
                     <td> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                          &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                     </td>
                 <%--   <td>Saved Data</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Rejected Data</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:maroon;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>--%>
                   
                    
                </tr>
            </table>
                  
                  </div>
                     <div class="TestDetail" style="margin-top: 5px; height: 360px; overflow: auto; width: 100%;">
           <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">


                  
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle" style="width:30px;">#</td>
                                        <td class="GridViewHeaderStyle">Processing Lab</td>
                                        <td class="GridViewHeaderStyle">ILC Lab</td>
                                        <td class="GridViewHeaderStyle">Visit ID</td>
                                        <td class="GridViewHeaderStyle">Sin No</td>
                                        <td class="GridViewHeaderStyle">Test Name</td>
                                        <td class="GridViewHeaderStyle">Parameter Name</td>
                           
                            </tr>
                       </table>
                       </div>
                   </div>
              </div>

          <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content" style="text-align: center; height: 30px;">
                <table width="99%">
                    <tr>
                        <td width="45%" >
                               <table width="90%">
                <tr>
                      
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;">
                                &nbsp;&nbsp;</td> <td>&nbsp;Saved Data</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:maroon;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Rejected Data</td>
                    
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #ffc4e7;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Numeric Report</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Text Report</td>
                    
                    
                </tr>
            </table>
                        </td>
                         <td width="55%" align="left"> 
                             <% if(ApprovalId=="7")
                                    
                                {%>
                             &nbsp;&nbsp;
                             <strong>Reject Reason :</strong>&nbsp;&nbsp;
                             <input type="text" id="txtrejectreason" maxlength="100" style="width: 273px" />
                             &nbsp;&nbsp;
                             <input type="button" class="resetbutton" value="Reject" onclick="rejectme()" id="btnsave" style="display: none;" />
                             <%} %>
                            

                         </td>
                    </tr>
                </table>
               
            </div>
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



       
    </script>

    <script type="text/javascript">
        function SearchNow() {
            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();



            if (processingcentre == "0") {
                showerrormsg("Please Select Processing Centre");
                return;
            }

            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();

            $('#tbl tr').slice(1).remove();

            $.blockUI();

            jQuery.ajax({
                url: "ILCResultReject.aspx/getilcresult",
                data: '{ processingcentre: "' + processingcentre + '",regisyearandmonth:"' + regisyearandmonth + '"}',
                type: "POST",
                timeout: 120000,
                
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        showerrormsg("No Data Found");
                        $.unblockUI();
                        return;
                    }


                    for (var i = 0; i <= PanelData.length - 1; i++) {


                        var id = PanelData[i].TestID;


                        var color = "#ffc4e7";
                        if (PanelData[i].LabobservationId == "0") {
                            color = "bisque";
                        }

                        var mydata = '<tr style="background-color:' + color + ';" class="GridViewItemStyle" id=' + PanelData[i].id + '>';

                        mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';
                        if (PanelData[i].isReject == "0") {
                            mydata += '<td align="left" style="background-color:aqua"><input type="checkbox" id="chk"  /></td>';
                        }
                        else {
                            mydata += '<td align="left" style="background-color:maroon;    padding-left: 5px"><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="viewdetail(this)"/></td>';
                        }
                        mydata += '<td align="left" >' + PanelData[i].centre + '</td>';
                      
                            mydata += '<td align="left"  >' + PanelData[i].ilclabname + '</td>';
                        
                        mydata += '<td align="left" id="visitid">' + PanelData[i].LedgerTransactionNO + '</td>';
                        mydata += '<td align="left" >' + PanelData[i].barcodeno + '</td>';

                        if (PanelData[i].isReject == "0") {
                            mydata += '<td align="left" style="background-color:aqua">' + PanelData[i].TestName + '</td>';
                        }
                        else {
                            mydata += '<td align="left"  style="background-color:maroon;color:white;">' + PanelData[i].TestName + '</td>';
                        }


                       
                        mydata += '<td align="left" >' + PanelData[i].ParameterName + '</td>';
                        mydata += '<td align="left" id="test_id" style="display:none;">' + PanelData[i].test_id + '</td>';
                        mydata += '<td align="left" id="RejectByName" style="display:none;">' + PanelData[i].RejectByName + '</td>';
                        mydata += '<td align="left" id="RejectDateTime" style="display:none;">' + PanelData[i].RejectDateTime + '</td>';
                        mydata += '<td align="left" id="RejectReason" style="display:none;">' + PanelData[i].RejectReason + '</td>';
                        mydata += '</tr>';

                        $('#tbl').append(mydata);

                        $('#btnsave').show();



                    }
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert("Error ");
                }
            });
        }

        function viewdetail(ctrl) {
            var msg = "Reject By: " + $(ctrl).closest('tr').find('#RejectByName').html() + "<br/>" + "Reject Date: " + $(ctrl).closest('tr').find('#RejectDateTime').html() + "<br/>" + "Reject Reason: " + $(ctrl).closest('tr').find('#RejectReason').html();
            showerrormsg(msg);
        }

        function rejectme() {

            var dataIm = new Array();
            $('#tbl tr').each(function () {
                if ($(this).attr("id") != "trheader" && $(this).find("#chk").is(':checked')) {
                   
                    dataIm.push($(this).attr("id") + "#" + $(this).find("#test_id").html());
                }

            });

            var ILCResultData = dataIm;
            if (ILCResultData.length == 0) {
                showerrormsg("Please Select Record To Reject");
                return;
            }


            if ($('#txtrejectreason').val() == "") {
                $('#txtrejectreason').focus();
                showerrormsg("Please Enter Reject Reason");
                return;
            }

            $.blockUI();
            $.ajax({
                url: "ILCResultReject.aspx/rejectnow",
               
                data: JSON.stringify({ ILCResultData: ILCResultData, rejectreason: $('#txtrejectreason').val() }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {
                        showmsg("ILC Registration Rejected Successfully..!");

                        SearchNow();

                    }
                    else {
                        showerrormsg(result.d);
                    }


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });

        }
    </script>
</asp:Content>

