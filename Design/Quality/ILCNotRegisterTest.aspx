<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ILCNotRegisterTest.aspx.cs" Inherits="Design_Quality_ILCNotRegisterTest" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
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
                          <b>ILC Map Non Register Test</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
                  </div>


          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td style="font-weight: 700">
                            Month/Year :</td>

                        <td>
                            <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="100px"></asp:DropDownList>&nbsp;&nbsp;
                                        <asp:TextBox ID="txtcurrentyear" runat="server" ReadOnly="true" Width="50px"></asp:TextBox></td>
                        <td style="font-weight: 700">
                            &nbsp;</td>
                        <td  >
                            &nbsp;</td>
                     </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Processing Lab
                            :</td>

                        <td>
                            <asp:DropDownList ID="ddlprocessinglab" onchange="getmydata()" class="ddlprocessinglab chosen-select chosen-container" Width="435px" runat="server"></asp:DropDownList>

                        </td>
                        <td style="font-weight: 700">
                            ILC Lab
                            :</td>
                        <td  >
                          <asp:DropDownList ID="ddllabtype" runat="server" class="ddllabtype chosen-select chosen-container" Width="160" onchange="bindilclab()">
                              <asp:ListItem Value="1">OutHouse Lab</asp:ListItem>
                               <asp:ListItem Value="2">OutSource ILC Lab</asp:ListItem>
                          </asp:DropDownList>
                       
                           <asp:CheckBox ID="chkAllCentre" runat="server" Text="All Centre" ToolTip="Check For All Outhouse" onclick="bindilclab()" style="font-weight: 700"   />
                        
                            <asp:DropDownList class="ddlilclab chosen-select chosen-container" ID="ddlilclab" runat="server" style="width:325px;"></asp:DropDownList>

                        </td>
                     </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Department :</td>

                        <td>
                              <asp:DropDownList ID="ddldepartment" runat="server"  Width="435px" class="ddldepartment chosen-select" onchange="binddataall()"  ></asp:DropDownList></td>

                        <td style="font-weight: 700">
                            Test :</td>

                         <td>
                            <asp:ListBox ID="lsttestname" CssClass="multiselect" SelectionMode="Multiple" Width="590px" runat="server" ClientIDMode="Static" onchange="bindallparameter()"></asp:ListBox></td>
                     </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Parameter :</td>

                        <td colspan="3">
                            <asp:ListBox ID="lstparameter" CssClass="multiselect" SelectionMode="Multiple" Width="700px" runat="server" ClientIDMode="Static" ></asp:ListBox>
                          &nbsp;&nbsp;&nbsp;
                        <input type="button" value="Add" onclick="Addme()" class="searchbutton" />
                             &nbsp;&nbsp;&nbsp;
                            <input type="button" value="Reset" onclick="clearForm()" class="resetbutton" />
                             &nbsp;&nbsp;&nbsp;
                                <input type="button" value="Export To Excel" onclick="exporttoexcel()" class="searchbutton" />
                             &nbsp;&nbsp;&nbsp;
                             <input type="button" value="Save" onclick="saveme()" class="savebutton" id="btnsave" style="display:none;" />
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
                    <td>Saved Data</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>New Data</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:lemonchiffon;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                   
                    
                </tr>
            </table>
                  
                  </div>
                     <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
           <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">


                  
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle">Processing Lab</td>
                                        <td class="GridViewHeaderStyle" style="width:130px">ILC Lab Type</td>
                                        <td class="GridViewHeaderStyle">ILC Lab</td>
                                        <td class="GridViewHeaderStyle" style="width:100px">TestType</td>
                                        <td class="GridViewHeaderStyle">ParameterID</td>
                                        <td class="GridViewHeaderStyle">ParameterName</td>
                             <td class="GridViewHeaderStyle" style="width:85px">
                                            Accept ability(%)
                                            <input type="text" id="txtaccepthead" placeholder="Acceptability(%)" style="width:96px;display:none;" onkeyup="showme2(this)" name="t4" />
                                        </td>
                                        <td class="GridViewHeaderStyle" style="width:85px">
                                            Rate
                                            <input type="text" id="txtratehead" placeholder="Rate For All" style="width:80px" onkeyup="showme2(this)" name="t1" />
                                        </td>

                             <td class="GridViewHeaderStyle" title="Month" style="width:85px">
                                 Month
                                        </td>
                                        <td class="GridViewHeaderStyle" title="Year" style="width:85px">
                                           Year
                                        </td>
                            </tr>
                       </table>
                       </div>
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


            $('[id=<%=lsttestname.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id=<%=lstparameter.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


            bindcentre();
            // GetAllDate();
        });

        function bindcentre() {


            $.ajax({
                url: "ILCNotRegisterTest.aspx/bindCentre",
                data: '{}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    centreData = $.parseJSON(result.d);
                    jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val("0").html("Select Processing Lab"));
                     for (i = 0; i < centreData.length; i++) {
                         jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val(centreData[i].centreid).html(centreData[i].centre));
                     }

                     $("#<%=ddlprocessinglab.ClientID%>").trigger('chosen:updated');
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

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



         function binddataall() {

             jQuery('#<%=lsttestname.ClientID%> option').remove();
             jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");

             var department = $('#<%=ddldepartment.ClientID%>').val();
             if (department != "0") {
                 jQuery.ajax({
                     url: "ILCNotRegisterTest.aspx/bindtest",
                     data: '{ department: "' + department + '"}',
                     type: "POST",
                     timeout: 120000,
                     async: false,
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     success: function (result) {
                         CentreLoadListData = jQuery.parseJSON(result.d);


                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=lsttestname.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].type_id).html(CentreLoadListData[i].typename));
                         }


                         $('[id=<%=lsttestname.ClientID%>]').multipleSelect({
                             includeSelectAllOption: true,
                             filter: true, keepOpen: false
                         });




                     },
                     error: function (xhr, status) {
                         alert("Error ");
                     }
                 });
             }


         }

         function bindilclab() {
             var all = "0";
             if ($('#<%=chkAllCentre.ClientID%>').is(':checked')) {
                 all = "1";
             }

             var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();

             jQuery('#<%=ddlilclab.ClientID%> option').remove();
             $("#<%=ddlilclab.ClientID%>").trigger('chosen:updated');

             if (processingcentre != "0") {


                 var department = $('#<%=ddllabtype.ClientID%>').val();
                 if (department != "0") {
                     jQuery.ajax({
                         url: "ILCNotRegisterTest.aspx/bindilc",
                         data: '{ department: "' + department + '",processingcentre:"' + processingcentre + '",all:"' + all + '"}',
                         type: "POST",
                         timeout: 120000,
                         async: false,
                         contentType: "application/json; charset=utf-8",
                         dataType: "json",
                         success: function (result) {
                             CentreLoadListData = jQuery.parseJSON(result.d);
                             if (CentreLoadListData.length === 0) {
                                 showerrormsg("No " + $('#<%=ddllabtype.ClientID%> option:selected').text() + " Found");
                             }

                             jQuery("#<%=ddlilclab.ClientID%>").append(jQuery('<option></option>').val("0").html("Select " + $('#<%=ddllabtype.ClientID%> option:selected').text()));
                             for (i = 0; i < CentreLoadListData.length; i++) {

                                 jQuery("#<%=ddlilclab.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].centreid).html(CentreLoadListData[i].centre));
                             }

                             $("#<%=ddlilclab.ClientID%>").trigger('chosen:updated');





                         },
                         error: function (xhr, status) {
                             alert("Error ");
                         }
                     });
                 }
             }

         }



        function bindallparameter() {

            jQuery('#<%=lstparameter.ClientID%> option').remove();
              jQuery('#<%=lstparameter.ClientID%>').multipleSelect("refresh");

              var test = $('#<%=lsttestname.ClientID%>').val();
              if (test != "") {
                  jQuery.ajax({
                      url: "ILCNotRegisterTest.aspx/bindparameter",
                      data: '{ test: "' + test + '"}',
                      type: "POST",
                      timeout: 120000,
                      async: false,
                      contentType: "application/json; charset=utf-8",
                      dataType: "json",
                      success: function (result) {
                          CentreLoadListData = jQuery.parseJSON(result.d);


                          for (i = 0; i < CentreLoadListData.length; i++) {

                              jQuery("#<%=lstparameter.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].LabObservation_ID).html(CentreLoadListData[i].name));
                        }


                        $('[id=<%=lstparameter.ClientID%>]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });




                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
        }

        </script>



    <script type="text/javascript">
        function getmydata() {
            bindilclab();
            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();

            $('#tbl tr').slice(1).remove();

            if (processingcentre != "0") {
                $.blockUI();

                jQuery.ajax({
                    url: "ILCNotRegisterTest.aspx/getalldata",
                    data: '{ processingcentre: "' + processingcentre + '",month:"' + $('#<%=ddlcurrentmonth.ClientID%>').val() + '",year:"' + $('#<%=txtcurrentyear.ClientID%>').val() + '"}',
                    type: "POST",
                    timeout: 120000,

                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        PanelData = jQuery.parseJSON(result.d);
                        if (PanelData.length === 0) {
                            $.unblockUI();
                            return;
                        }


                        for (var i = 0; i <= PanelData.length - 1; i++) {


                            var id = PanelData[i].TestID + "_" + PanelData[i].TestType;





                            var mydata = '<tr style="background-color:lightgreen;" class="GridViewItemStyle" id=' + id + ' name="' + PanelData[i].id + '">';

                            mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';
                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownew(this)"/></td>';
                            mydata += '<td align="left" id="ddlprocessinglabname">' + PanelData[i].ProcessingLabName + '</td>';
                            mydata += '<td align="left" id="ddllabtypename">' + PanelData[i].ILCLabType + '</td>';
                            mydata += '<td align="left" id="ddlilclabname">' + PanelData[i].ILCLabName + '</td>';
                            mydata += '<td align="left" id="testtype">' + PanelData[i].TestType + '</td>';
                            mydata += '<td align="left" id="parameteridshow">' + PanelData[i].TestID + '</td>';
                            mydata += '<td align="left" id="parametername">' + PanelData[i].TestName + '</td>';
                            if (PanelData[i].TestType == "Observation") {
                                mydata += '<td align="left" id="aceept"><input type="text" style="width:85px" id="txtaceept" name="t4" onkeyup="showme1(this)" value="' + PanelData[i].AcceptablePer + '"/></td>';
                            }
                            else {
                                mydata += '<td align="left" id="aceept"><input type="text" style="width:85px;display:none;" id="txtaceept" name="t4" onkeyup="showme1(this)" value="' + PanelData[i].AcceptablePer + '"/></td>';
                            }
                            mydata += '<td align="left" id="rate"><input type="text" style="width:80px" id="txtrate" name="t1" onkeyup="showme1(this)" value="' + PanelData[i].Rate + '"/></td>';
                            mydata += '<td align="left" id="tdmonth" class="' + PanelData[i].CMonth + '">' + PanelData[i].CMonthName + '</td>';
                            mydata += '<td align="left" id="tdyear">' + PanelData[i].CYear + '</td>';
                          

                            mydata += '<td align="left" id="ddlprocessinglabid" style="display:none;">' + PanelData[i].ProcessingLabID + '</td>';
                            mydata += '<td align="left" id="ddllabtypeid" style="display:none;">' + PanelData[i].ILCLabTypeID + '</td>';
                            mydata += '<td align="left" id="ddlilclabid" style="display:none;">' + PanelData[i].ILCLabID + '</td>';
                            mydata += '<td align="left" id="parameterid" style="display:none;">' + PanelData[i].TestID + '</td>';

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

        }

        function exporttoexcel() {
            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();
            jQuery.ajax({
                url: "ILCNotRegisterTest.aspx/exporttoexcel",
                data: '{ processingcentre: "' + processingcentre + '",month:"' + $('#<%=ddlcurrentmonth.ClientID%>').val() + '",year:"' + $('#<%=txtcurrentyear.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d == "false") {
                        showerrormsg("No Item Found");
                        $.unblockUI();
                    }
                    else {
                        window.open('../Common/exporttoexcel.aspx');
                        $.unblockUI();
                    }

                },


                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

    </script>



    <script type="text/javascript">

        function Addme() {

            var centreid = $('#<%=ddlprocessinglab.ClientID%>').val();
            if (centreid == "0") {
                showerrormsg("Please Select Processing Lab");
                return;
            }

            var length = $('#<%=ddlilclab.ClientID%> > option').length;
             if (length == 0) {
                 showerrormsg("Please Select ILC Lab");
                 $('#<%=ddlilclab.ClientID%>').focus();
                return false;
            }



            if ($('#<%=ddlilclab.ClientID%>').val() == "0") {
                showerrormsg("Please Select ILC Lab");
                return;
            }

            var test = $('#<%=lstparameter.ClientID%>').val();
            if (test == "") {
                showerrormsg("Please Select Parameter...!");
                $('#<%=lstparameter.ClientID%>').focus();
                 return;
             }




             $('#<%=ddlprocessinglab.ClientID%> > option:selected').each(function () {

                var ddlprid = $(this).val();
                var ddlprname = $(this).text();
                $('#<%=lstparameter.ClientID%> > option:selected').each(function () {

                     var a = $('#tbl tr').length - 1;
                     var id = ddlprid + "_" + $(this).val() + "_" + $(this).text().split('#')[1];
                     var testtype = $(this).text().split('#')[1];
                     var param = $(this).val();
                     var paramnmae = $(this).text().split('#')[0];
                     if ($('table#tbl').find('#' + id).length == 0) {



                         var mydata = '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id=' + id + ' name="">';

                         mydata += '<td  align="left" >' + parseFloat(a + 1) + '</td>';
                         mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
                         mydata += '<td align="left" id="ddlprocessinglabname">' + ddlprname + '</td>';
                         mydata += '<td align="left" id="ddllabtypename">' + $('#<%=ddllabtype.ClientID%> option:selected').text() + '</td>';
                         mydata += '<td align="left" id="ddlilclabname">' + $('#<%=ddlilclab.ClientID%> option:selected').text() + '</td>';
                         mydata += '<td align="left" id="testtype">' + testtype + '</td>';
                         mydata += '<td align="left" id="parameteridshow">' + param + '</td>';
                         mydata += '<td align="left" id="parametername">' + paramnmae + '</td>';
                         if (testtype == "Observation") {
                             mydata += '<td align="left" id="aceept"><input type="text" style="width:85px" id="txtaceept" name="t4" onkeyup="showme1(this)" value="10"/></td>';
                         }
                         else {
                             mydata += '<td align="left" id="aceept"><input type="text" style="width:85px;display:none;" id="txtaceept" name="t4" onkeyup="showme1(this)" value="0"/></td>';
                         }
                         mydata += '<td align="left" id="rate"><input type="text" style="width:80px" id="txtrate" name="t1" onkeyup="showme1(this)"/></td>';
                         mydata += '<td align="left" id="tdmonth" class="' + $('#<%=ddlcurrentmonth.ClientID%>').val() + '">' + $('#<%=ddlcurrentmonth.ClientID%> option:selected').text() + '</td>';


                         mydata += '<td align="left" id="tdyear">' + $('#<%=txtcurrentyear.ClientID%>').val() + '</td>';

                         mydata += '<td align="left" id="ddlprocessinglabid" style="display:none;">' + ddlprid + '</td>';
                         mydata += '<td align="left" id="ddllabtypeid" style="display:none;">' + $('#<%=ddllabtype.ClientID%>').val() + '</td>';
                         mydata += '<td align="left" id="ddlilclabid" style="display:none;">' + $('#<%=ddlilclab.ClientID%>').val() + '</td>';
                         mydata += '<td align="left" id="parameterid" style="display:none;">' + param + '</td>';

                         mydata += '</tr>';

                         $('#tbl').append(mydata);

                     }
                 });

             });
             $('#btnsave').show();
             
            
             $('#<%=ddlprocessinglab.ClientID%>').attr("disabled", true).trigger('chosen:updated');
            $("#<%=ddllabtype.ClientID%>").attr("disabled", true).trigger('chosen:updated');
            $("#<%=ddlilclab.ClientID%>").attr("disabled", true).trigger('chosen:updated');
            //$('#<%=ddldepartment.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            $("#<%=lsttestname.ClientID%> option:selected").prop("selected", false);
            jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=lstparameter.ClientID%> option').remove();
            jQuery('#<%=lstparameter.ClientID%>').multipleSelect("refresh");
            $.unblockUI();






        }

        function deleterow(itemid) {
            var table = document.getElementById('tbl');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);


            var count = $('#tbl tr').length;
            if (count == 0 || count == 1) {
                $('#btnsave').hide();
            }
        }

        function deleterownew(itemid) {
            if (confirm("Do You Want To Delete This Data?")) {
                var id = $(itemid).closest('tr').attr('name');




                jQuery.ajax({
                    url: "ILCNotRegisterTest.aspx/deletedata",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        showmsg("Data Deleted..");
                        var table = document.getElementById('tbl');
                        table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                    },


                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });


            }
        }




        function clearForm() {
            $('#btnsave').hide();
            jQuery('#<%=ddlprocessinglab.ClientID%>').prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated')
            
             $("#<%=ddllabtype.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
             $("#<%=ddlilclab.ClientID%>").attr("disabled", false).trigger('chosen:updated');

             jQuery('#<%=ddlilclab.ClientID%> option').remove();
             $("#<%=ddlilclab.ClientID%>").trigger('chosen:updated');
             // bindilclab();
             $('#<%=ddldepartment.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
             jQuery('#<%=lsttestname.ClientID%> option').remove();
             jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");
             jQuery('#<%=lstparameter.ClientID%> option').remove();
             jQuery('#<%=lstparameter.ClientID%>').multipleSelect("refresh");

             $('#tbl tr').slice(1).remove();

             $('#txtratehead').val('');
           
           

             $('#<%=chkAllCentre.ClientID%>').prop("checked", false);
        }
           
    </script>


    <script type="text/javascript">


        function getilcdata() {

            var dataIm = new Array();
            $('#tbl tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trheader") {
                    var ILCData = new Object();
                    ILCData.SavedID = $(this).closest("tr").attr("name");
                    ILCData.ProcessingLabID = $(this).closest("tr").find('#ddlprocessinglabid').html();
                    ILCData.ProcessingLabName = $(this).closest("tr").find('#ddlprocessinglabname').html();
                    ILCData.ILCLabTypeID = $(this).closest("tr").find('#ddllabtypeid').html();
                    ILCData.ILCLabType = $(this).closest("tr").find('#ddllabtypename').html();
                    ILCData.ILCLabID = $(this).closest("tr").find('#ddlilclabid').html();
                    ILCData.ILCLabName = $(this).closest("tr").find('#ddlilclabname').html();
                    ILCData.TestType = $(this).closest("tr").find('#testtype').html();
                    ILCData.TestID = $(this).closest("tr").find('#parameterid').html();
                    ILCData.TestName = $(this).closest("tr").find('#parametername').html();
                    ILCData.Rate = $(this).closest("tr").find("#txtrate").val();
                    ILCData.AcceptablePer = $(this).closest("tr").find("#txtaceept").val();
                    ILCData.CMonth = $(this).closest("tr").find("#tdmonth").attr("class");
                    ILCData.CYear = $(this).closest("tr").find("#tdyear").html();
                    dataIm.push(ILCData);
                }
            });


            return dataIm;
        }



        function validation() {

            var centreid = $('#<%=ddlprocessinglab.ClientID%>').val();
             if (centreid == "0") {
                 showerrormsg("Please Select Processing Lab");
                 return;
             }

             var length = $('#<%=ddlilclab.ClientID%> > option').length;
            if (length == 0) {
                showerrormsg("Please Select ILC Lab");
                $('#<%=ddlilclab.ClientID%>').focus();
                return false;
            }

            if ($('#<%=ddlilclab.ClientID%>').val() == "0") {
                 showerrormsg("Please Select ILC Lab");
                 return;
             }
             var count = $('#tbl tr').length;
             if (count == 0 || count == 1) {
                 showerrormsg("Please Select Parameter  ");

                 return false;
             }

             var sn = 0;
             $('#tbl tr').each(function () {
                 var id = $(this).closest("tr").attr("id");
                 if (id != "trheader") {
                     var rate = $(this).find('#txtrate').val() == "" ? 0 : parseFloat($(this).find('#txtrate').val());


                     if (rate == 0) {
                         sn = 1;
                         $(this).find('#txtrate').focus();
                         return;
                     }
                 }
             });

             if (sn == 1) {
                 showerrormsg("Please Enter Rate ");
                 return false;
             }

            



             return true;
         }

        function saveme() {

            if (validation() == false) {
                return;
            }

            var ilcdata = getilcdata();


            $.blockUI();
            $.ajax({
                url: "ILCNotRegisterTest.aspx/SaveData",
                data: JSON.stringify({ ilcdata: ilcdata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    var save = result.d;
                    if (save == "1") {
                        showmsg("Record Saved Successfully");

                        clearForm();
                    }
                    else {
                        showerrormsg(save);

                        // console.log(save);
                    }
                },
                error: function (xhr, status) {
                    $.unblockUI()
                    showerrormsg("Some Error Occure Please Try Again..!");

                    console.log(xhr.responseText);
                }
            });

        }
    </script>


    <script type="text/javascript">
        function showme1(ctrl) {

            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            // alert($(ctrl).closest("tr").find("#txttddisc").text());

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }


            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');

                return;
            }


            if ($(ctrl).attr('id') == "txtFequency") {
                if ($(ctrl).val() == '') {
                    $(ctrl).val('');


                }

                else if ($(ctrl).val() < 1) {
                    $(ctrl).val('1');


                }
                else if ($(ctrl).val() > 12) {
                    $(ctrl).val('12');


                }

            }

        }
        function setbottom(ctrl) {

            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");
            $('select[name="' + name + '"]').each(function () {
                $(this).val(val);
            });
        }

        function showme2(ctrl) {

            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            // alert($(ctrl).closest("tr").find("#txttddisc").text());

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }


            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');

                return;
            }

            if ($(ctrl).attr('id') == "txtFequencyhead") {
                if ($(ctrl).val() == '') {
                    $(ctrl).val('');


                }

                else if ($(ctrl).val() < 1) {
                    $(ctrl).val('1');


                }
                else if ($(ctrl).val() > 12) {
                    $(ctrl).val('12');


                }

            }


            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");
            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });
        }

    </script>

</asp:Content>

