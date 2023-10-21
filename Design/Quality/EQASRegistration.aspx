<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EQASRegistration.aspx.cs" Inherits="Design_Quality_EQASRegistration" %>

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
	   <script type="text/javascript" src="http://malsup.github.io/jquery.blockUI.js"></script>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:1300000"><%--durga msg changes--%>
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
                          <b>EQAS Registration</b>  

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
                            Processing Lab
                            :</td>

                        <td>
                            
  <asp:DropDownList ID="ddlprocessinglab" runat="server" class="ddlprocessinglab chosen-select chosen-container" Width="380" onchange="bindprogram()">
                           
                          </asp:DropDownList>
                           

                            
                        </td>

                         <td style="font-weight: 700">
                             EQAS Program :
                         </td>
                         <td>
                             <asp:DropDownList ID="ddleqasprogram" runat="server" class="ddleqasprogram chosen-select chosen-container" Width="280" onchange="bindprogramdetail('0')">
                           
                          </asp:DropDownList>
                         </td>

                          <td style="font-weight: 700">
                                        Current Month/Year :
                                    </td>

                         <td>
                              <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="100px"></asp:DropDownList>&nbsp;&nbsp;
                                        <asp:TextBox ID="txtcurrentyear" runat="server" ReadOnly="true" Width="50px"></asp:TextBox>
                         </td>
                     </tr>

                     <tr>
                        <td style="font-weight: 700">
                            <strong>Program Name :</strong></td>

                        <td>
                            
                             <asp:TextBox ID="txtprogrmname" runat="server" Width="300px" ReadOnly="true"></asp:TextBox>
                           

                            
                        </td>

                         <td style="font-weight: 700">
                             Program No. :</td>
                         <td colspan="3">
                            <asp:TextBox ID="txtprogramnumber" runat="server"></asp:TextBox>
                         &nbsp; <strong>Cycle No. :</strong>
                             <asp:TextBox ID="txtcycleno" runat="server" Width="100px"></asp:TextBox>
                         &nbsp; <strong>Age :</strong>
                               <asp:TextBox ID="txtage" runat="server" Width="50px" ReadOnly="true"></asp:TextBox>

                             &nbsp; <strong>Gender :</strong>
                               <asp:TextBox ID="txtgender" runat="server" Width="60px" ReadOnly="true"></asp:TextBox>
                         </td>

                     </tr>

                     <tr>
                        <td style="font-weight: 700">
                            Test Detail :</td>

                        <td colspan="5">

                            <table width="99%">
                    <tr>
                        <td width="45%" >
                               <table width="30%">
                <tr>
                    
                    
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>&nbsp;&nbsp;Not Registered</td>
                    
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>&nbsp;&nbsp;Registered</td>
                    
                </tr>
            </table>
                        <div style="width:100%;overflow:auto;max-height:400px;">
                        <table id="tbl">
                            
                        </table>   
                        </div>    
                        
                        </td>

                     </tr>
                     <tr>
                        <td style="font-weight: 700; text-align: center;" colspan="6">

                               <input type="button" value="New Specimen" class="searchbutton" onclick="bindprogramdetail('1')" id="btnnew" style="display:none;" />
                          
                            &nbsp;&nbsp;&nbsp;

                        <input type="button" value="Save" class="savebutton" onclick="savedata()" id="btnsave" style="display:none;" />
                            
                            &nbsp;&nbsp;
                            <input type="button" value="Reset" class="resetbutton" onclick="resetdata()" />    
                        
                        </td>

                     </tr>
                    </table>
                </div>
               </div>
          </div>


        <div class="POuter_Box_Inventory" id="disp1" style="width:1300px;display:none;color:red;font-size:20px;background-color:white;font-weight:bold;text-align:center;">
             
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
         

             bindprogram();

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



         function bindprogram() {
             $('#tbl tr').remove();

             var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
             jQuery('#<%=ddleqasprogram.ClientID%> option').remove();
             $('#<%=ddlprocessinglab.ClientID%>').trigger('chosen:updated');
             
             if (labid != "0" && labid !=null) {


                 //$.blockUI();
                 $.ajax({
                     url: "EQASRegistration.aspx/bindprogram",
                     data: '{labid: "' + labid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No EQAS Program Mapped with Lab");
                         }

                         jQuery("#<%=ddleqasprogram.ClientID%>").append(jQuery('<option></option>').val("0").html("Select EQAS Program"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddleqasprogram.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].ProgramID).html(CentreLoadListData[i].ProgramName));
                         }

                         $("#<%=ddleqasprogram.ClientID%>").trigger('chosen:updated');





                         //$.UNblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                         //$.UNblockUI();
                     }
                 });
             }
         }





        function bindprogramdetail(type) {
            $('#tbl tr').remove();
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var programid = $('#<%=ddleqasprogram.ClientID%>').val();
             if (programid == "0") {
                 return;
             }
             var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();
             //$.blockUI();
             $.ajax({
                 url: "EQASRegistration.aspx/bindprogramdata",
                 data: '{programid: "' + programid + '",regisyearandmonth:"' + regisyearandmonth + '",labid:"' + labid + '",type:"' + type + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,

                 dataType: "json",
                 success: function (result) {
                     PanelData = $.parseJSON(result.d);
                     var programname = "";
                     var co = 0;

                    
                     for (i = 0; i < PanelData.length; i++) {
                         co = parseInt(co + 1);
                         var mydata = "";
                         if (programname != PanelData[i].programname) {

                             mydata = "<tr style='background-color:white' id='trheader'><td colspan='9' style='font-weight:bold;'>ProgramID:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].programid + "</span>&nbsp;ProgramName:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].programname + "</span>&nbsp;Rate:<span style='background-color:aquamarine'>" + PanelData[i].rate + "</span>&nbsp;ResultWithin:<span style='background-color:aquamarine'>" + PanelData[i].ResultWithin + "</span>&nbsp;Frequency:<span style='background-color:aquamarine'>" + PanelData[i].Frequency + "</span></td></tr>";


                             mydata += "<tr id='trheader1'><td class='GridViewHeaderStyle'>Sr.No</td><td class='GridViewHeaderStyle'>Department</td><td class='GridViewHeaderStyle'>Test</td><td class='GridViewHeaderStyle'>Reg.Date</td><td class='GridViewHeaderStyle'>VisitID</td><td class='GridViewHeaderStyle'>Sin No</td><td class='GridViewHeaderStyle'>#</td><td class='GridViewHeaderStyle'>Program No</td><td class='GridViewHeaderStyle'>Cycle No</td></tr>";

                             programname = PanelData[i].programname;
                             co = 1;

                             $('#<%=txtprogrmname.ClientID%>').val(programname);
                             $('#<%=txtage.ClientID%>').val(PanelData[i].Age);
                             $('#<%=txtgender.ClientID%>').val(PanelData[i].Gender);
                             
                         }
                         if (PanelData[i].savedid == "0") {
                             mydata += '<tr style="background-color:bisque;" class="GridViewItemStyle" id="' + PanelData[i].investigationid + '">';
                             $('#btnsave').show();
                         }
                         else {
                             mydata += '<tr style="background-color:lightgreen;" class="GridViewItemStyle" id="' + PanelData[i].investigationid + '">';
                         }
                         mydata += '<td  align="left" >' + co + '</td>';


                         mydata += '<td align="left" id="departmentname">' + PanelData[i].departmentname + '</td>';
                         mydata += '<td align="left" id="investigationname">' + PanelData[i].investigationname + '</td>';
                         mydata += '<td align="left" id="regdate" style="width:80px;">' + PanelData[i].regdate + '</td>';
                         mydata += '<td align="left" id="regdate" style="width:80px;">' + PanelData[i].LedgerTransactionNo + '</td>';
                         mydata += '<td align="left" id="barcodeno" style="width:80px;">' + PanelData[i].barcodeno + '</td>';
                         if (PanelData[i].savedid == "0") {
                             mydata += '<td align="centre" style="width:50px;"><input type="checkbox" id="chk" disabled="disabled" checked="checked" /></td>';
                         }
                         else {
                             mydata += '<td align="centre" style="width:50px;"><img src="../../App_Images/print.gif" style="cursor:pointer" onclick="openpopup5(\'' + PanelData[i].LedgerTransactionNo + '\')" /><input type="checkbox" id="chk" style="display:none;"/></td>';
                         }
                        
                             mydata += '<td align="left" >' + PanelData[i].ProgramNo + '</td>';
                        
                       
                      
                             mydata += '<td align="left"> ' + PanelData[i].CycleNo + '</td>';
                       
                         

                         mydata += '<td align="left" id="DepartmentID" style="display:none;">' + PanelData[i].DepartmentID + '</td>';
                         mydata += '<td align="left" id="LabObservationID" style="display:none;">' + PanelData[i].LabObservationID + '</td>';
                         mydata += '<td align="left" id="itemid" style="display:none;">' + PanelData[i].itemid + '</td>';
                         mydata += '<td align="left" id="itemname" style="display:none;">' + PanelData[i].TypeName + '</td>';
                         mydata += '<td align="left" id="itemcode" style="display:none;">' + PanelData[i].TestCode + '</td>';
                         mydata += '<td align="left" id="reportype" style="display:none;">' + PanelData[i].ReportType + '</td>';
                         mydata += '<td align="left" id="programid" style="display:none;">' + PanelData[i].programid + '</td>';
                         mydata += '<td align="left" id="programname" style="display:none;">' + PanelData[i].programname + '</td>';


                         mydata += '</tr>';

                         $('#tbl').append(mydata);

                         if (PanelData[PanelData.length - 1].LedgerTransactionNo != "") {
                             $('#btnnew').show();
                         }
                         else {
                             $('#btnnew').hide();
                         }

                         if (type == "1") {
                             $('#btnsave').show();
                         }

                        
                     }

                     //$.UNblockUI();
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                     //$.UNblockUI();
                 }
             });

        }


        function openpopup5(labno) {

            window.open("../Lab/BarCodeReprint.aspx?LabID=" + labno);
        }
    </script>

    <script type="text/javascript">

        function resetdata() {
            $('#<%=ddlprocessinglab.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            $('#<%=ddleqasprogram.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            $('#<%=txtprogramnumber.ClientID%>').val('');
            $('#<%=txtprogrmname.ClientID%>').val('');
            $('#<%=txtcycleno.ClientID%>').val('');
            $('#<%=txtage.ClientID%>').val('');
            $('#<%=txtgender.ClientID%>').val('');
            $('#tbl tr').remove();
            $('#btnsave').hide();
        }


       


        function savedata() {
            if ($('#<%=txtprogrmname.ClientID%>').val() == "") {
                showerrormsg("Please Select Program To Save");
                return;
            }

            if ($('#<%=txtprogramnumber.ClientID%>').val() == "") {
                showerrormsg("Please Enter ProgramNo");
                $('#<%=txtprogramnumber.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtcycleno.ClientID%>').val() == "") {
                showerrormsg("Please Enter CycleNo");
                $('#<%=txtcycleno.ClientID%>').focus();
                return;
            }


           

            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();

            var programname = $('#<%=txtprogrmname.ClientID%>').val();
            var programno = $('#<%=txtprogramnumber.ClientID%>').val();
            var cycleno = $('#<%=txtcycleno.ClientID%>').val();

          
            var ledgertransaction = f_ledgertransaction();
            var PLOdata = patientlabinvestigationopd();

            if (PLOdata == "") {
                showerrormsg("Please Select Test To Register");
                return;
            }

            //$.blockUI();
            $.ajax({
                url: "EQASRegistration.aspx/saveregister",
                data: JSON.stringify({LTData: ledgertransaction, PLO: PLOdata, regisyearandmonth: regisyearandmonth, programname: programname, programno: programno, cycleno: cycleno }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    //$.UNblockUI();
                    if (result.d.split('#')[0] == "1") {
                        showmsg("EQAS Register Successfully with visit ID " + result.d.split('#')[1].split('_')[1]);

                        bindprogramdetail('0');

                    }
                    else {
                        showerrormsg(result.d.split('#')[1]);
                    }

                },
                error: function (xhr, status) {
                    //$.UNblockUI();
                    showerrormsg(xhr.responseText);
                }
            });
        }
    </script>



    <script type="text/javascript">


       
        



        function f_ledgertransaction() {



            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if ($('#<%=txtage.ClientID%>').val() != "") {
                ageyear = $('#<%=txtage.ClientID%>').val();
            }

            age = ageyear + " Y " + agemonth + " M " + ageday + " D ";
            var Title = "";

            if ($('#<%=txtgender.ClientID%>').val() == "Male") {
                Title = "Mr.";
            }
            else {
                Title = "Mrs.";
            }

            var objLT = new Object();
            objLT.PName = Title + $('#<%=txtprogrmname.ClientID%>').val() + " " + $('#<%=txtprogramnumber.ClientID%>').val() + " " + $('#<%=txtcycleno.ClientID%>').val();
            objLT.Age = age;
            objLT.Gender = $('#<%=txtgender.ClientID%>').val();
            objLT.TypeOfTnx = "OPD-LAB";
            objLT.NetAmount = 0;
            objLT.GrossAmount = 0;
            objLT.IsCredit = 0;
            objLT.DiscountApprovedByID = "0";
            objLT.Remarks = "EQAS Registration";
            objLT.Panel_ID = 78;
            objLT.PanelName = "Standard";
            objLT.Doctor_ID = "1";
            objLT.DoctorName = "SELF";
            objLT.ReferLab = 0;
            objLT.VIP = "0";
            objLT.CentreID = $('#<%=ddlprocessinglab.ClientID%>').val();
            objLT.Adjustment = 0;
            objLT.PRO = 0;
            objLT.CreditPRO = 0;
            objLT.HomeVisitBoyID = "0";
            objLT.PatientSource = "WalkIn";
            objLT.PatientType = "Walk-In";
            objLT.VisitType = "Center Visit";
            objLT.DiscountPending = "0";
            objLT.DiscountOnTotal = 0;
            objLT.DiscountID = 0;
            objLT.IsInvoice = "0";
            objLT.showBalanceAmt = "0";
            objLT.CentreName = $('#<%=ddlprocessinglab.ClientID%> option:selected').text();
            objLT.ApolloOneDiscount = 0;
            objLT.DiscountType = "0";
            objLT.PatientTypeID = "1";
            objLT.PreBookingID = 0;
            objLT.TempDoctor_ID = "0";
            objLT.Type1ID = 0;
            objLT.IsCouponEntry = 0;
            objLT.IsDiscountApproved = 0;
            objLT.PineLabID = "0";

            return objLT;
        }


        function patientlabinvestigationopd() {
            var dataPLO = new Array();

            $('#tbl tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trheader" && id != "trheader1" && $(this).find("#chk").is(':checked')) {
                    var objPLO = new Object();
                    objPLO.ItemId = $(this).closest("tr").find("#itemid").html();
                    objPLO.ItemName = $.trim($(this).closest("tr").find("#investigationname").html());
                    objPLO.TestCode = $(this).closest("tr").find("#itemcode").html();
                    objPLO.InvestigationName = $.trim($(this).closest("tr").find("#investigationname").html());
                    objPLO.PackageName = $(this).closest("tr").find("#programname").html();
                    objPLO.PackageCode = $(this).closest("tr").find("#programid").html();

                    objPLO.Investigation_ID = $(this).closest("tr").attr('id');
                    objPLO.IsPackage = "0";
                    objPLO.SubCategoryID = $(this).closest("tr").find("#DepartmentID").html();

                    var ageindays = parseInt($('#<%=txtage.ClientID%>').val()) * 365 + parseInt(0) * 30 + parseInt(0);
                    objPLO.AgeInDays = ageindays;
                    objPLO.Gender = $('#<%=txtgender.ClientID%>').val();


                    objPLO.Rate = 0;
                    objPLO.DiscountByLab = 0;
                    objPLO.DiscountAmt = 0;
                    objPLO.Amount = 0;
                    objPLO.CouponAmt = 0;
                    objPLO.SBICardAmt = 0;
                    objPLO.ISSBIDiscByLab = 0;
                    objPLO.Quantity = "1";
                    objPLO.IsRefund = "0";
                    objPLO.IsReporting = 1;
                    objPLO.ReportType = $(this).closest("tr").find("#reportype").html();
                    objPLO.CentreID = $('#<%=ddlprocessinglab.ClientID%>').val();
                    objPLO.TestCentreID = "0";
                    objPLO.IsSampleCollected = "S";
                    objPLO.SampleBySelf = "1";
                    objPLO.isUrgent = "0";
                    objPLO.IsScheduleRate = 0;
                    objPLO.ApolloOneFreeTest = 0;
                    objPLO.ItemID_Interface = $(this).closest("tr").find("#LabObservationID").html();
                    dataPLO.push(objPLO);
                }
            });

            return dataPLO;
        }

    </script>


</asp:Content>

