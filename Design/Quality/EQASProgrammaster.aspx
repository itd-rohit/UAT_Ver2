<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EQASProgrammaster.aspx.cs" Inherits="Design_Quality_EQASProgrammaster" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
</head>
<body>
         <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript" src="http://malsup.github.io/jquery.blockUI.js"></script>
      <form id="form1" runat="server">
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:1300000"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width:1204px;height:550px;">

         <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>EQAS Provider Program Master</b>  
                            <br />
                            <strong>EQAS Provider :</strong>&nbsp;&nbsp; <asp:DropDownList ID="ddlprovider" style="width:250px;" runat="server" ></asp:DropDownList>

                            
                        </td>
                    </tr>
                    </table>
                </div>


              </div>


         <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content">
<table width="99%">
    <tr>
        <td style="font-weight: 700" class="required">Program Name :</td>

        <td><asp:TextBox ID="txtprogramename" runat="server"  Width="200px" MaxLength="200"  onblur="checkduplicateprogramname(this)" />
            <asp:TextBox ID="txtprogrameid" runat="server" style="display:none;" />
        </td>

        <td style="font-weight: 700" class="required">
            Rate :
        </td>

        <td>
             <asp:TextBox ID="txtrate" runat="server" Width="92px" AutoCompleteType="Disabled" MaxLength="5" TabIndex="3"></asp:TextBox>
                            
                            <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtrate">
                            </cc1:FilteredTextBoxExtender>
        </td>
    </tr>
    <tr>
        <td style="font-weight: 700" class="required">Age/Gender For Registration :</td>

        <td>
            <asp:TextBox ID="txtAge"  runat="server"  AutoCompleteType="Disabled" CssClass="ItDoseTextinputText" Width="50px" MaxLength="3" TabIndex="6" placeholder="Years"  />
              <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txtAge">
                            </cc1:FilteredTextBoxExtender>
          

           
            &nbsp;
             <asp:DropDownList ID="ddlGender" runat="server" CssClass="ItDoseDropdownbox"  Width="120px">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                              
                            </asp:DropDownList>


          


        &nbsp; <strong>&nbsp;Frequency in Month :  </strong>


                <asp:TextBox ID="txtfrequency" runat="server"  AutoCompleteType="Disabled" CssClass="ItDoseTextinputText" Width="50px" MaxLength="2" TabIndex="6" placeholder="Month" />
              <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" TargetControlID="txtfrequency">
                            </cc1:FilteredTextBoxExtender>

      

        </td>

        <td style="font-weight: 700" class="required" colspan="2">
            No of Days for Result :


                <asp:TextBox ID="txtnoofdays" runat="server"  AutoCompleteType="Disabled" CssClass="ItDoseTextinputText" Width="50px" MaxLength="2" TabIndex="6" placeholder="Days" />
             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers" TargetControlID="txtnoofdays">
                            </cc1:FilteredTextBoxExtender>
              </td>

    </tr>
    <tr>
        <td style="font-weight: 700" >Department :</td>

        <td colspan="3">

               <asp:DropDownList ID="ddldepartment" runat="server"  Width="200px" class="ddldepartment chosen-select" onchange="binddataall()"  ></asp:DropDownList> 
            <strong>&nbsp; Test :&nbsp; </strong><asp:ListBox ID="lsttestname" CssClass="multiselect" SelectionMode="Multiple" Width="500px" runat="server" ClientIDMode="Static" ></asp:ListBox>
       
                                     <input type="button" value="Add" onclick="Addme()" class="searchbutton" /> &nbsp;<input class="resetbutton" type="button" value="Reset" onclick="resetme()" /></td>

    </tr>
    <tr>
        <td style="font-weight: 700" colspan="4">
             <div class="TestDetail" style="margin-top: 5px; max-height: 200px; overflow: auto; width: 100%;">
            <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">
                 <tr id="tblheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                       
                                        <td class="GridViewHeaderStyle">Program Name</td>
                                        <td class="GridViewHeaderStyle">Rate</td>
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

         <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content">
                <div class="Purchaseheader">Program List
                    &nbsp;&nbsp;&nbsp;<input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()"  />
                </div>
                 <div class="TestDetail" style="margin-top: 5px; max-height: 200px; overflow: auto; width: 100%;">
            <table id="tbl1" style="width:99%;border-collapse:collapse;text-align:left;">
                 <tr id="tblheader1">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle">Program Name</td>
                                        <td class="GridViewHeaderStyle">Rate</td>
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
    </form>

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
            SearchRecords();

            $('[id=lsttestname]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

           


            

           
           

        });

        function binddataall() {

            jQuery('#<%=lsttestname.ClientID%> option').remove();
             jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");

             var department = $('#<%=ddldepartment.ClientID%>').val();
             if (department != "0") {
                 jQuery.ajax({
                     url: "EQASProgrammaster.aspx/bindtest",
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

            if ($('#<%=txtprogramename.ClientID%>').val() == "") {
                showerrormsg("Please Enter Program Name");
                $('#<%=txtprogramename.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtrate.ClientID%>').val() == "" || $('#<%=txtrate.ClientID%>').val() == "0") {
                showerrormsg("Please Enter Rate of Program");
                $('#<%=txtrate.ClientID%>').focus();
                return;
            }

            var test = $('#<%=lsttestname.ClientID%>').val();
            if (test == "") {
                showerrormsg("Please Select Test...!");
                $('#<%=lsttestname.ClientID%>').focus();
                 return;
            }
           

            ////$.blockUI();
            $('#<%=lsttestname.ClientID%> > option:selected').each(function () {

                var a = $('#tbl tr').length - 1;

                
                var testid = $(this).val().split('#')[0];
                var LabObservationID = $(this).val().split('#')[1];
                var testname = $(this).text();
                if ($('table#tbl').find('#' + testid).length == 0) {
                    var mydata = '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id=' + testid + ' name="">';

                    mydata += '<td  align="left" >' + parseFloat(a + 1) + '</td>';
                   
                    mydata += '<td align="left" id="programname">' + $('#<%=txtprogramename.ClientID%>').val() + '</td>';
                    mydata += '<td align="left" id="rate">' + $('#<%=txtrate.ClientID%>').val() + '</td>';
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
                    ////$.unblockUI();
                }

            });
            if ($("#<%=txtprogrameid.ClientID%>").val() == "") {
                $('#btnsave').show();
            }
            $("#<%=txtprogramename.ClientID%>").attr("disabled", true);
           
            $("#<%=txtrate.ClientID%>").attr("disabled", true);
            $("#<%=lsttestname.ClientID%> option:selected").prop("selected", false);
            jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");
           
            ////$.unblockUI();
        }


        function resetme() {

            $("#<%=txtprogramename.ClientID%>").attr("disabled", false).val("");
            $("#<%=txtrate.ClientID%>").attr("disabled", false).val("");
            $("#<%=lsttestname.ClientID%> option:selected").prop("selected", false);
            $('#<%=ddldepartment.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            jQuery('#<%=lsttestname.ClientID%> option').remove();
            jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");
            $("#<%=txtAge.ClientID%>").val("");
         
            $("#<%=txtfrequency.ClientID%>").val("");
            $("#<%=txtnoofdays.ClientID%>").val("");
            $("#<%=ddlGender.ClientID%>").val("Male");
           
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

                    ProData.EQASProviderID = $('#<%=ddlprovider.ClientID%>').val();
                    ProData.ProgramID = Number($(this).closest("tr").attr("name"));
                    ProData.ProgramName = $('#<%=txtprogramename.ClientID%>').val();
                    ProData.Rate = $('#<%=txtrate.ClientID%>').val();
                    ProData.DepartmentID = $(this).closest("tr").find('#departmentid').html();
                    ProData.DepartmentName = $(this).closest("tr").find('#department').html();
                    ProData.InvestigationID = $(this).closest("tr").find('#testid').html();
                    ProData.InvestigationName = $(this).closest("tr").find('#testname').html();
                    ProData.LabObservationID = $(this).closest("tr").find('#LabObservationID').html();
                    
                    ProData.Frequency = $('#<%=txtfrequency.ClientID%>').val();
                    ProData.ResultWithin = $('#<%=txtnoofdays.ClientID%>').val();
                    ProData.Age = $('#<%=txtAge.ClientID%>').val();
                    ProData.Gender = $('#<%=ddlGender.ClientID%>').val();

                    ProData.ISNew = $(this).closest("tr").find('#ISNew').html();
                    


                    dataIm.push(ProData);
                }
            });


            return dataIm;
        }


        function saveme() {

            if ($('#<%=txtprogramename.ClientID%>').val() == "") {
                showerrormsg("Please Enter Program Name");
                $('#<%=txtprogramename.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtrate.ClientID%>').val() == "" || $('#<%=txtrate.ClientID%>').val() == "0") {
                showerrormsg("Please Enter Rate of Program");
                $('#<%=txtrate.ClientID%>').focus();
                return;
            }

           

            var a = $('#tbl tr').length;
            if (a == 1) {
                showerrormsg("Please Add Test..!");
                return;
            }


            var age = $('#<%=txtAge.ClientID%>').val();
            if (Number(age) <= 0 || Number(age) >= 105) {
                showerrormsg("Please Enter Correct Age for Registration");
                $('#<%=txtAge.ClientID%>').focus();
                return;
            }

            var frequency = $('#<%=txtfrequency.ClientID%>').val();
            if (Number(frequency) < 1 || Number(frequency) > 12) {
                showerrormsg("Please Enter Correct Frequency");
                $('#<%=txtfrequency.ClientID%>').focus();
                return;
            }


            var noofdays = $('#<%=txtnoofdays.ClientID%>').val();
            if (Number(noofdays) == 0) {
                showerrormsg("Please Enter Correct No of days for result");
                $('#<%=txtnoofdays.ClientID%>').focus();
                return;
            }


            var prodata = getprodata();
            ////$.blockUI();
            $.ajax({
                url: "EQASProgrammaster.aspx/savedata",
                data: JSON.stringify({ prodata: prodata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    ////$.unblockUI();
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
                    ////$.unblockUI();
                    console.log(xhr.responseText);
                }
            });


        }

        function SearchRecords() {
            $('#tbl1 tr').slice(1).remove();
                ////$.blockUI();
                jQuery.ajax({
                    url: "EQASProgrammaster.aspx/SearchRecords",
                    data: '{ eqasproviderid: "' + $('#<%=ddlprovider.ClientID%>').val() + '"}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        PanelData = jQuery.parseJSON(result.d);
                        if (PanelData.length == 0) {
                            ////$.unblockUI();
                            return;
                        }


                        for (var i = 0; i <= PanelData.length - 1; i++) {


                            





                            var mydata = '<tr style="background-color:lightgreen;" class="GridViewItemStyle" id=' + PanelData[i].ProgramID + '>';

                            mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';
                          
                           
                            mydata += '<td align="left" id="ProgramName" style="font-weight:bold;">' + PanelData[i].ProgramName + '</td>';
                            mydata += '<td align="left" id="Rate">' + PanelData[i].Rate + '</td>';
                            mydata += '<td align="left" id="InvestigationName">' + PanelData[i].InvestigationName + '</td>';
                            mydata += '<td align="left" id="EntryDate">' + PanelData[i].EntryDate + '</td>';
                            mydata += '<td align="left" id="EntryBy">' + PanelData[i].EntryByName + '</td>';
                            mydata += '<td><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="showdata(this)"/></td>';
                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownew(this)"/></td>';
                            mydata += '</tr>';

                            $('#tbl1').append(mydata);

                           



                        }
                        ////$.unblockUI();


                    },
                    error: function (xhr, status) {
                        ////$.unblockUI();
                        alert("Error ");
                    }
                });

            

        }

        function deleterownew(itemid) {
            if (confirm("Do You Want To Delete This Program?")) {
                var id = $(itemid).closest('tr').attr('id');


                ////$.blockUI();

                jQuery.ajax({
                    url: "EQASProgrammaster.aspx/deleteprogram",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,
                  
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        showmsg("Program Deleted..");
                        var table = document.getElementById('tbl1');
                        table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                        ////$.unblockUI();
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
            ////$.blockUI();
            jQuery.ajax({
                url: "EQASProgrammaster.aspx/SearchRecordsProgram",
                data: '{ programid: "' + id + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        ////$.unblockUI();
                        return;
                    }


                    $("#<%=txtprogrameid.ClientID%>").val(PanelData[0].ProgramID);
                    $('#<%=txtprogramename.ClientID%>').val(PanelData[0].ProgramName);
                    $('#<%=txtrate.ClientID%>').val(PanelData[0].Rate);

                    $('#<%=txtAge.ClientID%>').val(PanelData[0].Age);
                    $('#<%=ddlGender.ClientID%>').val(PanelData[0].Gender);
                    $('#<%=txtfrequency.ClientID%>').val(PanelData[0].Frequency);
                    $('#<%=txtnoofdays.ClientID%>').val(PanelData[0].ResultWithin);
                    $('#btnsave').hide();
                    $('#btnupdate').show();
                    for (var i = 0; i <= PanelData.length - 1; i++) {








                        var mydata = '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id=' + PanelData[i].InvestigationID + ' name="' + PanelData[i].ProgramID + '">';

                        mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';

                        mydata += '<td align="left" id="programname">' + PanelData[i].ProgramName + '</td>';
                        mydata += '<td align="left" id="rate">' + PanelData[i].Rate + '</td>';
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
                    ////$.unblockUI();


                },
                error: function (xhr, status) {
                    ////$.unblockUI();
                    alert("Error ");
                }
            });



        }



        function updateme() {

            if ($('#<%=txtprogramename.ClientID%>').val() == "") {
                showerrormsg("Please Enter Program Name");
                $('#<%=txtprogramename.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtrate.ClientID%>').val() == "" || $('#<%=txtrate.ClientID%>').val() == "0") {
                showerrormsg("Please Enter Rate of Program");
                $('#<%=txtrate.ClientID%>').focus();
                return;
            }



            var a = $('#tbl tr').length;
            if (a == 1) {
                showerrormsg("Please Add Test..!");
                return false;
            }



            var age = $('#<%=txtAge.ClientID%>').val();
            if (Number(age) <= 0 || Number(age) >= 105) {
                showerrormsg("Please Enter Correct Age for Registration");
                $('#<%=txtAge.ClientID%>').focus();
                return;
            }

            var frequency = $('#<%=txtfrequency.ClientID%>').val();
            if (Number(frequency) < 1 || Number(frequency) > 12) {
                showerrormsg("Please Enter Correct Frequency");
                $('#<%=txtfrequency.ClientID%>').focus();
                return;
            }


            var noofdays = $('#<%=txtnoofdays.ClientID%>').val();
            if (Number(noofdays) == 0) {
                showerrormsg("Please Enter Correct No of days for result");
                $('#<%=txtnoofdays.ClientID%>').focus();
                return;
            }

            var prodata = getprodata();
            ////$.blockUI();
            $.ajax({
                url: "EQASProgrammaster.aspx/updatedata",
                data: JSON.stringify({ prodata: prodata, delitemid: delitemid }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    ////$.unblockUI();
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
                    ////$.unblockUI();
                    console.log(xhr.responseText);
                }
            });


        }


        var delitemid = "";
        function deleterowold(itemid) {
            var table = document.getElementById('tbl');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

            delitemid += $(itemid).closest('tr').find('#savedid').html() + ",";


        }



        function checkduplicateprogramname(ctrl) {
        
            var programname = $(ctrl).val();

            if ($.trim(programname) != "") {

                $.ajax({
                    url: "EQASProgrammaster.aspx/checkduplicateprogramname",
                    data: '{programid:"' + $('#<%=txtprogrameid.ClientID%>').val() + '",programname:"' + programname + '",labid:"'+$('#<%=ddlprovider.ClientID%>').val()+'"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        ItemData = result.d;
                     
                        if (ItemData != "0") {
                            $(ctrl).val('');
                            $(ctrl).focus();
                            showerrormsg('This Program Name Already Exist.!');
                        }

                    },
                    error: function (xhr, status) {

                        ////$.unblockUI();

                    }
                });
            }
        }
    </script>
  <script type="text/javascript">
    

          function exporttoexcel() {

              jQuery.ajax({
                  url: "EQASProgrammaster.aspx/exporttoexcel",
                  data: '{ eqasproviderid: "' + $('#<%=ddlprovider.ClientID%>').val() + '",eqasprovidername: "' + $('#<%=ddlprovider.ClientID%> option:selected').text() + '"}',
                  type: "POST",
                  timeout: 120000,
                  async: false,
                  contentType: "application/json; charset=utf-8",
                  dataType: "json",
                  success: function (result) {
                      if (result.d == "false") {
                          showerrormsg("No Item Found");
                          ////$.unblockUI();
                      }
                      else {
                          window.open('../Common/exporttoexcel.aspx');
                          ////$.unblockUI();
                      }

                  },


                  error: function (xhr, status) {
                      alert("Error ");
                  }
              });
          }
      

  </script>

</body>
</html>
