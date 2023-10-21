<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CAPQCMaster.aspx.cs" Inherits="Design_Quality_CAPQCMaster" %>

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
                          <b>CAP PT Program Master</b>  

                            
                        </td>
                    </tr>
                    </table>
                </div>
              </div>

            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <table width="99%">
                    <tr>
                        <td style="font-weight: 700; color: #FF0000;">CAP Program Name :</td>
                        <td><asp:TextBox ID="txtprogramname" runat="server" Width="150px" />

                            <asp:TextBox ID="txtprogrameid" runat="server" style="display:none;" />
                        </td>
                        <td style="font-weight: 700; color: #FF0000;">Program Description :</td>
                        <td><asp:TextBox ID="txtdisc" runat="server" Width="350px" />
                            &nbsp;  <span style="color: #FF0000">  <strong>No of Days for Result :</strong></span>
                             <asp:TextBox ID="txtnoofdays" runat="server"  AutoCompleteType="Disabled" CssClass="ItDoseTextinputText" Width="50px" MaxLength="2" TabIndex="6" placeholder="Days" />
             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers" TargetControlID="txtnoofdays">
                            </cc1:FilteredTextBoxExtender>


                        </td>
                    </tr>

                   <tr>
        <td style="font-weight: 700" >Department :</td>

        <td colspan="3">

               <asp:DropDownList ID="ddldepartment" runat="server"  Width="200px" class="ddldepartment chosen-select" onchange="binddataall()"  ></asp:DropDownList> 
            <strong>&nbsp; <span style="color: #FF0000">Test :</span>&nbsp; </strong><asp:ListBox ID="lsttestname" CssClass="multiselect" SelectionMode="Multiple" Width="500px" runat="server" ClientIDMode="Static" ></asp:ListBox>
       
                                     <input type="button" value="Add" onclick="Addme()" class="searchbutton" /> &nbsp;<input class="resetbutton" type="button" value="Reset" onclick="    resetme()" /></td>

    </tr>


                    <tr>

        <td style="font-weight: 700" colspan="4">
             <div class="TestDetail" style="margin-top: 5px; max-height: 200px; overflow: auto; width: 100%;">
            <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">
                 <tr id="tblheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle">Program Name</td>
                                        
                                        <td class="GridViewHeaderStyle">Description</td>
                                        <td class="GridViewHeaderStyle">Department</td>
                                        <td class="GridViewHeaderStyle">TestID</td>
                                        <td class="GridViewHeaderStyle">TestName</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                     </tr>
            </table>
                 </div>
        </td>

    </tr>


                     <tr>
        <td style="font-weight: 700; text-align: center;"  colspan="4">

            <input type="button" value="Save" class="savebutton" id="btnsave" style="display:none;" onclick="saveme()" />

             <input type="button" value="Update" class="savebutton" id="btnupdate" style="display:none;" onclick="updateme()" />
            
           
        </td>

    </tr>



                </table>
                </div>
                </div>



           <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="Purchaseheader">Program List
                    &nbsp;&nbsp;&nbsp;<input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()"  />
                </div>
                 <div class="TestDetail" style="margin-top: 5px; max-height: 200px; overflow: auto; width: 100%;">
            <table id="tbl1" style="width:99%;border-collapse:collapse;text-align:left;">
                 <tr id="tblheader1">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle">Program Name</td>
                                        <td class="GridViewHeaderStyle">No of Days(Result)</td>
                                        <td class="GridViewHeaderStyle">Description</td>
                                        <td class="GridViewHeaderStyle">Test</td>
                                        <td class="GridViewHeaderStyle">EntryDate</td>
                                        <td class="GridViewHeaderStyle">EntryBy</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">Edit</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
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
           

            $('[id=lsttestname]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            SearchRecords();
        });

        function binddataall() {

            jQuery('#<%=lsttestname.ClientID%> option').remove();
             jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");

             var department = $('#<%=ddldepartment.ClientID%>').val();
             if (department != "0") {
                 jQuery.ajax({
                     url: "CAPQCMaster.aspx/bindtest",
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

    </script>

    <script type="text/javascript">

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


        function Addme() {

            if ($('#<%=txtprogramname.ClientID%>').val() == "") {
                showerrormsg("Please Enter Program Name");
                $('#<%=txtprogramname.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtdisc.ClientID%>').val() == "") {
                showerrormsg("Please Enter Program Description");
                $('#<%=txtdisc.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtnoofdays.ClientID%>').val() == "" || $('#<%=txtnoofdays.ClientID%>').val() == "0") {
                showerrormsg("Please Enter No of Days For Result");
                $('#<%=txtnoofdays.ClientID%>').focus();
                return;
            }

            var test = $('#<%=lsttestname.ClientID%>').val();
            if (test == "") {
                showerrormsg("Please Select Test...!");
                $('#<%=lsttestname.ClientID%>').focus();
                return;
            }


            $.blockUI();
            $('#<%=lsttestname.ClientID%> > option:selected').each(function () {

                var a = $('#tbl tr').length - 1;


                var testid = $(this).val().split('#')[0];
                var LabObservationID = $(this).val().split('#')[1];
                var testname = $(this).text();
                if ($('table#tbl').find('#' + testid).length == 0) {
                    var mydata = '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id=' + testid + ' name="0">';

                    mydata += '<td  align="left" >' + parseFloat(a + 1) + '</td>';

                    mydata += '<td align="left" id="programname">' + $('#<%=txtprogramname.ClientID%>').val() + '</td>';
                    mydata += '<td align="left" id="programdisc">' + $('#<%=txtdisc.ClientID%>').val() + '</td>';
                    mydata += '<td align="left" id="department">' + $('#<%=ddldepartment.ClientID%> option:selected').text() + '</td>';

                    mydata += '<td align="left" id="testid">' + testid + '</td>';
                    mydata += '<td align="left" id="testname">' + testname + '</td>';


                    mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
                    mydata += '<td align="left" id="departmentid" style="display:none;">' + $('#<%=ddldepartment.ClientID%> option:selected').val() + '</td>';
                    mydata += '<td align="left" id="LabObservationID" style="display:none;">' + LabObservationID + '</td>';
                    mydata += '<td align="left" id="ISNew" style="display:none;">1</td>';
                    mydata += '<td align="left" id="savedid" style="display:none;"></td>';
                    mydata += '</tr>';

                    $('#tbl').append(mydata);


                }
                else {
                    showerrormsg(testname + "  Already Added ");
                    $.unblockUI();
                }

            });
            if ($("#<%=txtprogrameid.ClientID%>").val() == "") {
                $('#btnsave').show();
            }
            $("#<%=txtprogramname.ClientID%>").attr("disabled", true);

            $("#<%=txtdisc.ClientID%>").attr("disabled", true);
            $("#<%=txtnoofdays.ClientID%>").attr("disabled", true);
            $("#<%=lsttestname.ClientID%> option:selected").prop("selected", false);
            jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");

            $.unblockUI();
        }


        function resetme() {

            $("#<%=txtprogramname.ClientID%>").attr("disabled", false).val("");
            $("#<%=txtdisc.ClientID%>").attr("disabled", false).val("");
            $("#<%=txtnoofdays.ClientID%>").attr("disabled", false).val("");
            $("#<%=lsttestname.ClientID%> option:selected").prop("selected", false);
            $('#<%=ddldepartment.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            jQuery('#<%=lsttestname.ClientID%> option').remove();
            jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");
           

           
            $('#tbl tr').slice(1).remove();
            $("#<%=txtprogrameid.ClientID%>").val("");

            $('#btnsave').hide();
            $('#btnupdate').hide();

            delitemid = "";
        }


        function deleterow(itemid) {
            var table = document.getElementById('tbl');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);


            var count = $('#tbl tr').length;
            if (count == 0 || count == 1) {
                $('#btnsave').hide();
            }




        }


    </script>


    <script type="text/javascript">

        function getprodata() {

            var dataIm = new Array();
            $('#tbl tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "tblheader") {
                    var ProData = new Object();

                   
                    ProData.ProgramID = Number($(this).closest("tr").attr("name"));
                    ProData.ProgramName = $('#<%=txtprogramname.ClientID%>').val();
                    ProData.ResultWithin = $('#<%=txtnoofdays.ClientID%>').val()
                    
                    ProData.ProgramDiscription = $('#<%=txtdisc.ClientID%>').val();
                    ProData.DepartmentID = $(this).closest("tr").find('#departmentid').html();
                    ProData.DepartmentName = $(this).closest("tr").find('#department').html();
                    ProData.InvestigationID = $(this).closest("tr").find('#testid').html();
                    ProData.InvestigationName = $(this).closest("tr").find('#testname').html();
                    ProData.LabObservationID = $(this).closest("tr").find('#LabObservationID').html();

                   

                    ProData.ISNew = $(this).closest("tr").find('#ISNew').html();



                    dataIm.push(ProData);
                }
            });


            return dataIm;
        }

        function saveme() {

            if ($('#<%=txtprogramname.ClientID%>').val() == "") {
                 showerrormsg("Please Enter Program Name");
                 $('#<%=txtprogramname.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtdisc.ClientID%>').val() == "") {
                showerrormsg("Please Enter Program Description ");
                 $('#<%=txtdisc.ClientID%>').focus();
                return;
            }



            var a = $('#tbl tr').length;
            if (a == 1) {
                showerrormsg("Please Add Test..!");
                return;
            }


            


            var prodata = getprodata();
            $.blockUI();
            $.ajax({
                url: "CAPQCMaster.aspx/savedata",
                data: JSON.stringify({ prodata: prodata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {
                        resetme();
                        showmsg("Program Saved Successfully");
                        SearchRecords();
                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    console.log(xhr.responseText);
                }
            });


        }

    </script>

    <script type="text/javascript">

        function SearchRecords() {
            $('#tbl1 tr').slice(1).remove();
            $.blockUI();
            jQuery.ajax({
                url: "CAPQCMaster.aspx/SearchRecords",
                data: '{}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        PanelData = jQuery.parseJSON(result.d);
                        if (PanelData.length == 0) {
                            $.unblockUI();
                            return;
                        }


                        for (var i = 0; i <= PanelData.length - 1; i++) {








                            var mydata = '<tr style="background-color:lightgreen;" class="GridViewItemStyle" id=' + PanelData[i].ProgramID + '>';

                            mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';


                            mydata += '<td align="left" id="ProgramName" style="font-weight:bold;">' + PanelData[i].ProgramName + '</td>';
                            mydata += '<td align="left" id="ResultWithin">' + PanelData[i].ResultWithin + '</td>';
                            mydata += '<td align="left" id="Description">' + PanelData[i].Description + '</td>';
                            mydata += '<td align="left" id="InvestigationName">' + PanelData[i].InvestigationName + '</td>';
                            mydata += '<td align="left" id="EntryDate">' + PanelData[i].EntryDate + '</td>';
                            mydata += '<td align="left" id="EntryBy">' + PanelData[i].EntryByName + '</td>';
                            mydata += '<td><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="showdata(this)"/></td>';
                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownew(this)"/></td>';
                            mydata += '</tr>';

                            $('#tbl1').append(mydata);





                        }
                        $.unblockUI();


                    },
                    error: function (xhr, status) {
                        $.unblockUI();
                        alert("Error ");
                    }
                });



        }


        function deleterownew(itemid) {
            if (confirm("Do You Want To Delete This Program?")) {
                var id = $(itemid).closest('tr').attr('id');


                $.blockUI();

                jQuery.ajax({
                    url: "CAPQCMaster.aspx/deleteprogram",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,

                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        showmsg("Program Deleted..");
                        var table = document.getElementById('tbl1');
                        table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                        $.unblockUI();
                    },


                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });


            }
        }



        function showdata(ctrl) {
            var id = $(ctrl).closest('tr').attr('id');

            $('#tbl tr').slice(1).remove();
            $.blockUI();
            jQuery.ajax({
                url: "CAPQCMaster.aspx/SearchRecordsProgram",
                data: '{ programid: "' + id + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $.unblockUI();
                        return;
                    }


                    $("#<%=txtprogrameid.ClientID%>").val(PanelData[0].ProgramID);
                    $('#<%=txtprogramname.ClientID%>').val(PanelData[0].ProgramName);
                    $('#<%=txtdisc.ClientID%>').val(PanelData[0].Description);
                    $('#<%=txtnoofdays.ClientID%>').val(PanelData[0].ResultWithin);

                 
                    $('#btnsave').hide();
                    $('#btnupdate').show();
                    for (var i = 0; i <= PanelData.length - 1; i++) {








                        var mydata = '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id=' + PanelData[i].InvestigationID + ' name="' + PanelData[i].ProgramID + '">';

                        mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';

                        mydata += '<td align="left" id="programname">' + PanelData[i].ProgramName + '</td>';
                      
                        mydata += '<td align="left" id="programdisc">' + PanelData[i].Description + '</td>';
                        mydata += '<td align="left" id="department">' + PanelData[i].DepartmentName + '</td>';

                        mydata += '<td align="left" id="testid">' + PanelData[i].InvestigationID + '</td>';
                        mydata += '<td align="left" id="testname">' + PanelData[i].InvestigationName + '</td>';




                        mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterowold(this)"/></td>';
                        mydata += '<td align="left" id="departmentid" style="display:none;">' + PanelData[i].DepartmentID + '</td>';
                        mydata += '<td align="left" id="LabObservationID" style="display:none;">' + PanelData[i].LabObservationID + '</td>';
                        mydata += '<td align="left" id="ISNew" style="display:none;">0</td>';
                        mydata += '<td align="left" id="savedid" style="display:none;">' + PanelData[i].id + '</td>';
                        mydata += '</tr>';

                        $('#tbl').append(mydata);





                    }
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert("Error ");
                }
            });



        }

        var delitemid = "";
        function deleterowold(itemid) {
            var table = document.getElementById('tbl');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

            delitemid += $(itemid).closest('tr').find('#savedid').html() + ",";


        }

        function exporttoexcel() {

            jQuery.ajax({
                url: "CAPQCMaster.aspx/exporttoexcel",
                data: '{}',
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



        function updateme() {

            if ($('#<%=txtprogramname.ClientID%>').val() == "") {
                showerrormsg("Please Enter Program Name");
                $('#<%=txtprogramname.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtdisc.ClientID%>').val() == "") {
                showerrormsg("Please Enter Description");
                $('#<%=txtdisc.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtnoofdays.ClientID%>').val() == "" || $('#<%=txtnoofdays.ClientID%>').val() == "0") {
                showerrormsg("Please Enter No of Days For Result");
                $('#<%=txtnoofdays.ClientID%>').focus();
                return;
            }

            var a = $('#tbl tr').length;
            if (a == 1) {
                showerrormsg("Please Add Test..!");
                return false;
            }


            var prodata = getprodata();
            $.blockUI();
            $.ajax({
                url: "CAPQCMaster.aspx/updatedata",
                data: JSON.stringify({ prodata: prodata, delitemid: delitemid }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {
                        resetme();
                        showmsg("Program Updated Successfully");
                        SearchRecords();
                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    console.log(xhr.responseText);
                }
            });


        }

    </script>
</asp:Content>

