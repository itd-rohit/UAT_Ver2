<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="UpdateHCPatient.aspx.cs" Inherits="Design_HomeCollection_UpdateHCPatient" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
        
     
      <%: Scripts.Render("~/bundles/Chosen") %>
     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <style type="text/css">

        #popup_box1 {
            display: none; /* Hide the DIV */
            position: fixed;
            _position: absolute; /* hack for internet explorer 6 */
            width: 800px;
            left: 10%;
            top: 12%;
            z-index: 100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
            /* additional features, can be omitted */
            border: 2px solid #ff0000;
            padding: 5px;
            background-color: #d7edff;
            border-radius: 5px;
        }
    </style>
    

   

     <div id="Pbody_box_inventory" >
          <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager> 
            <div class="POuter_Box_Inventory" style="text-align:center;">
           
                <strong>Home Collection Patient Edit</strong> 
                </div>
         <div class="POuter_Box_Inventory" >
                <div class="row">
                    <div class="col-md-3"></div>
                <div class="col-md-2">
                    <label class="pull-left">
                        Mobile No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                     <asp:TextBox ID="txtmobilesearch" runat="server" AutoCompleteType="Disabled" MaxLength="10" onkeyup="showlength()" CssClass="requiredField"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtmobilesearch">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-1">
                         <input type="button" value="Search" class="searchbutton" onclick="getpdetail()" /></div>
                         <div class="col-md-1">
                            <input type="button" value="Cancel" class="resetbutton" onclick="cancelme()" />

                     </div>
              
          
                
              
                  </div>
              </div>
           <div class="POuter_Box_Inventory 1" >
           
                 <div class="Purchaseheader">
                      <div class="row">
                           <div class="col-md-4">
                               Patient List
                           </div>
                          <div class="col-md-1" style="width: 15px;height:15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: papayawhip;">

                              </div>
                          <div class="col-md-3">
                              Not Registered
                          </div>
                          <div class="col-md-1" style="width: 15px;height:15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">

                          </div>
                           <div class="col-md-2">
                               Registered
                           </div>
                      </div>
                        
                 </div>
                <div  style="max-height:400px;overflow:auto;">
                    <div class="row">
                    <table id="tbl" style="width:100%;border-collapse:collapse;text-align:left;">
                  <thead>
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Log</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        <td class="GridViewHeaderStyle" >UHID</td>
                                        <td class="GridViewHeaderStyle" >Patient Name</td>
                                        <td class="GridViewHeaderStyle" >Age</td>
                                        <td class="GridViewHeaderStyle">Gender</td>
                                        <td class="GridViewHeaderStyle">MobileNo</td>
                                        <td class="GridViewHeaderStyle">Area</td>
                                        <td class="GridViewHeaderStyle">City</td>
                                        <td class="GridViewHeaderStyle">State</td> 
                                        <td class="GridViewHeaderStyle">Pincode</td>
                                        <td class="GridViewHeaderStyle">Reg.Date</td>
                                        <td class="GridViewHeaderStyle">LastHCStatus</td>

                                       
                            </tr></thead>
                            </table>
                  </div>
                </div>
                    </div>


            <div class="POuter_Box_Inventory 1" style="display:none;" id="mm">
           
                <div class="Purchaseheader">Update Patient Detail</div>
                  <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">
                        Mobile No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtnewmobile" runat="server" ReadOnly="true" Enabled="false">

                            </asp:TextBox>
                    </div>
                       <div class="col-md-2">
                    <label class="pull-left">
                        UHID
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtpatientid" runat="server" ReadOnly="true" Enabled="false"></asp:TextBox>
                    </div>
               </div>

                <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">
                        Patient Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">

                   
                    <asp:DropDownList ID="ddltitle" runat="server"  onchange="AutoGender()" TabIndex="4"></asp:DropDownList></div>
                     <div class="col-md-3">

                              <asp:TextBox ID="txtpatientname" CssClass="checkSpecialCharater_forPname requiredField" runat="server"  style="text-transform:uppercase;" TabIndex="5"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">
                        Age<asp:RadioButton ID="rdAge" runat="server" Checked="True" onclick="setdobop1(this)"  GroupName="rdDOB"  />
                    </label>
                    <b class="pull-right">:</b>
                    </div>
                      <div class="col-md-5">	
                          <asp:TextBox  ID="txtAge"  runat="server" onkeyup="getdob()" style="width:33%;float:left" onlynumber="5" AutoCompleteType="Disabled"  CssClass="requiredField"  MaxLength="3" TabIndex="6"  placeholder="Years"   />
                                 <cc1:filteredtextboxextender ID="Filteredtextboxextender6" runat="server" FilterType="Numbers" TargetControlID="txtAge">
                                </cc1:filteredtextboxextender>
                         
                             <asp:TextBox  ID="txtAge1" runat="server" onkeyup="getdob()" style="width:33%;float:left" onlynumber="5" AutoCompleteType="Disabled"  CssClass="requiredField"   MaxLength="2" TabIndex="7"  placeholder="Months"    />
                                 <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender7" runat="server" FilterType="Numbers" TargetControlID="txtAge1">
                                </cc1:FilteredTextBoxExtender>
                             
                             <asp:TextBox  ID="txtAge2" runat="server" onkeyup="getdob()" style="width:33%;float:left" onlynumber="5" AutoCompleteType="Disabled" CssClass="requiredField"   MaxLength="2" TabIndex="8" placeholder="Days"   />
                                 <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender8" runat="server" FilterType="Numbers" TargetControlID="txtAge2">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                       <div class="col-md-2">
                           DOB <asp:RadioButton ID="rdDOB" runat="server"    GroupName="rdDOB" onclick="setdobop(this)"  />
                           <label class="pull-left">
                               </label>
                    <b class="pull-right">:</b>
                    </div>

                     <div class="col-md-2">
                         <asp:TextBox ID="txtdob" onclick="getdob()" ReadOnly="true" runat="server"  Enabled="false"></asp:TextBox>
                     </div>
                        <div class="col-md-2">
                    <label class="pull-left">
                        Gender
                    </label>
                    <b class="pull-right">:</b>
                </div>
                      <div class="col-md-2">
                          <asp:DropDownList ID="ddlGender" runat="server" CssClass="ItDoseDropdownbox" onchange="resetitem1();" >
                                     <asp:ListItem Value="Male">Male</asp:ListItem>
                                     <asp:ListItem Value="Female">Female</asp:ListItem>
                                   <asp:ListItem Value=""></asp:ListItem>
                                 </asp:DropDownList>
                      </div>
</div>

                  <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">
                        House No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-3">
                           <asp:TextBox ID="txtpaddress" runat="server"  TabIndex="10"></asp:TextBox>
                       </div>

                       <div class="col-md-2">
                    <label class="pull-left">
                        State
                    </label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-3">
                           <asp:DropDownList ID="ddlstate" runat="server"  onchange="bindCity('-1')" CssClass="requiredField"></asp:DropDownList>  
                           </div>

                      <div class="col-md-2">
                    <label class="pull-left">
                        City
                    </label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-3">
                           <asp:DropDownList ID="ddlcity" runat="server"  onchange="bindLocality('-1','-1')" CssClass="requiredField"></asp:DropDownList>
                           </div>
                       <div class="col-md-2">
                    <label class="pull-left">
                        Area
                    </label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-3">
                           <asp:DropDownList ID="ddlarea" runat="server" TabIndex="11" onchange="bindpincode()" CssClass="requiredField"></asp:DropDownList>
                      </div>

                       </div>

                 <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">
                        Pin Code
                    </label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-3">
                           <asp:TextBox ID="txtpincode" runat="server"  MaxLength="6" CssClass="requiredField"></asp:TextBox> 
                                 <cc1:filteredtextboxextender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers" TargetControlID="txtpincode">
                                </cc1:filteredtextboxextender>
                           </div>

                      <div class="col-md-2">
                    <label class="pull-left">
                        Email ID
                    </label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-3">
                           <asp:TextBox ID="txtemail" runat="server" ></asp:TextBox>

                           </div>

                      <div class="col-md-2">
                    <label class="pull-left">
                        Landmark
                    </label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-3">
                           <asp:TextBox ID="txtlandmark" runat="server" ></asp:TextBox>
                           </div>
                     </div>

                <div class="row" style="text-align:center">
                    <input type="button" value="Update Patient" onclick="Updateme()" class="savebutton" id="btnSave" />
                </div>               
                </div>
               
          </div>   
     <div id="popup_box1">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox()" style="position:absolute;right:-20px;top:-20px;width:36px;height:36px;cursor:pointer;" title="Close" />
                <div class="POuter_Box_Inventory" style="width:780px;">

                 <div class="Purchaseheader">
               Patient Edit Log
            </div>

                    <div style="width:100%;overflow:auto;height:250px;">
                 <table id="detailtable1" style="width:100%;border-collapse:collapse;text-align:left;font-weight:bold;">
                         <tr id="tr4">
                              <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                              <td class="GridViewHeaderStyle" >UHID</td>
                              <td class="GridViewHeaderStyle" >Update Date</td>
                              <td class="GridViewHeaderStyle">Field Name</td> 
                              <td class="GridViewHeaderStyle">Old Value</td>     
                              <td class="GridViewHeaderStyle">New Value</td>  
                              <td class="GridViewHeaderStyle">Update By</td>  
                                  
                             </tr>
                       </table>
                </div>

         </div>
         </div>
           <script type="text/javascript">
           $(function () {
               AutoGender();
               $("#ContentPlaceHolder1_txtdob").datepicker({
                   dateFormat: "dd-M-yy",
                   changeMonth: true,
                   maxDate: new Date,
                   changeYear: true, yearRange: "-100:+0",
                   onSelect: function (value, ui) {
                       var today = new Date();
                       //  var dob = new Date(value);
                       var dob = value;
                       getAge(dob, today);
                   }
               });

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


               $("#<%= txtmobilesearch.ClientID%>").keydown(
           function (e) {
               var key = (e.keyCode ? e.keyCode : e.charCode);
               if (key == 13) {
                   e.preventDefault();


                   getpdetail();



               }
               else if (key == 9) {


                   getpdetail();



               }
           });
               jQuery("#tbl").tableHeadFixer({

               });
           });
           function showlength() {
               if ($('#<%=txtmobilesearch.ClientID%>').val() != "") {
                   $('#molen').html($('#<%=txtmobilesearch.ClientID%>').val().length);
               }
               else {
                   $('#molen').html('');
               }
               if ($.trim($('#<%=txtmobilesearch.ClientID%>').val()) == "123456789") {
                   toast("Error","Please Enter Valid Mobile No.");
                   $('#<%=txtmobilesearch.ClientID%>').val('');
                   $('#molen').html('');
                   return;
               }
               if ($.trim($('#<%=txtmobilesearch.ClientID%>').val()).charAt(0) == "0") {
                   toast("Error","Please Enter Valid Mobile No.");
                   $('#<%=txtmobilesearch.ClientID%>').val('');
                   $('#molen').html('');
                   return;
               }

           }

          
           

        </script>

    <script type="text/javascript">
        function AutoGender() {
            var ddltitle = $('#<%=ddltitle.ClientID%>').val();
              var Gender = $('#<%=ddlGender.ClientID%>').val();
            if (ddltitle == "Mr." || ddltitle == "Master." || ddltitle == "Baba.")
                $('#<%=ddlGender.ClientID%>').val("Male").attr('disabled', 'disabled');
            else if (ddltitle == "Mrs." || ddltitle == "Miss." || ddltitle == "Ms." || ddltitle == "Smt." || ddltitle == "Baby." || ddltitle == "W/O")
                $('#<%=ddlGender.ClientID%>').val("Female").attr('disabled', 'disabled');
            else if (ddltitle == "Dr." || ddltitle == "B/O" || ddltitle == "C/O")
                $('#<%=ddlGender.ClientID%>').val("").removeAttr('disabled');
            else
                $('#<%=ddlGender.ClientID%>').val("Male").removeAttr('disabled');

}

        function getAge(birthDate, ageAtDate) {
            var daysInMonth = 30.436875; // Days in a month on average.
            // var dob = new Date(birthDate);
            //shat 05.10.17
            var dateSplit = birthDate.split("-");
            var dob = new Date(dateSplit[1] + " " + dateSplit[0] + ", " + dateSplit[2]);
            //
            var aad;
            if (!ageAtDate) aad = new Date();
            else aad = new Date(ageAtDate);
            var yearAad = aad.getFullYear();
            var yearDob = dob.getFullYear();
            var years = yearAad - yearDob; // Get age in years.
            dob.setFullYear(yearAad); // Set birthday for this year.
            var aadMillis = aad.getTime();
            var dobMillis = dob.getTime();
            if (aadMillis < dobMillis) {
                --years;
                dob.setFullYear(yearAad - 1); // Set to previous year's birthday
                dobMillis = dob.getTime();
            }
            var days = (aadMillis - dobMillis) / 86400000;
            var monthsDec = days / daysInMonth; // Months with remainder.
            var months = Math.floor(monthsDec); // Remove fraction from month.
            days = Math.floor(daysInMonth * (monthsDec - months));
            $('#<%=txtAge.ClientID%>').val(years);
            $('#<%=txtAge1.ClientID%>').val(months);
            $('#<%=txtAge2.ClientID%>').val(days);

        }

        function setdobop(ctrl) {
            if ($(ctrl).is(':checked')) {
                $('#<%=txtdob.ClientID%>').attr("disabled", false);
                $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').attr("disabled", true);
                $('#<%=txtdob.ClientID%>').addClass('requiredField');
                $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').removeClass('requiredField');
            }
        }
        function setdobop1(ctrl) {
            if ($(ctrl).is(':checked')) {
                $('#<%=txtdob.ClientID%>').attr("disabled", true);
                $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').attr("disabled", false);
                $('#<%=txtdob.ClientID%>').removeClass('requiredField');
                $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').addClass('requiredField');
            }
        }




        function getdob() {
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if ($('#<%=txtAge.ClientID%>').val() != "") {
                if ($('#<%=txtAge.ClientID%>').val() > 110) {
                    toast("Error","Please Enter Valid Age in Years");
                    $('#<%=txtAge.ClientID%>').val('');
                }
                ageyear = $('#<%=txtAge.ClientID%>').val();
            }
            if ($('#<%=txtAge1.ClientID%>').val() != "") {
                if ($('#<%=txtAge1.ClientID%>').val() > 12) {
                    toast("Error","Please Enter Valid Age in Months");
                    $('#<%=txtAge1.ClientID%>').val('');
                }
                agemonth = $('#<%=txtAge1.ClientID%>').val();

            }
            if ($('#<%=txtAge2.ClientID%>').val() != "") {
                if ($('#<%=txtAge2.ClientID%>').val() > 30) {
                    toast("Error","Please Enter Valid Age in Days");
                    $('#<%=txtAge2.ClientID%>').val('');
                }
                ageday = $('#<%=txtAge2.ClientID%>').val();
            }
            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);
            var m_names = new Array("Jan", "Feb", "Mar",
    "Apr", "May", "Jun", "Jul", "Aug", "Sep",
    "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = minTwoDigits(dd) + "-" + m_names[MM] + "-" + yyyy;
            $('#ContentPlaceHolder1_txtdob').val(xxx);


        }
        function minTwoDigits(n) {
            return (n < 10 ? '0' : '') + n;
        }
        function bindCity(con) {
            jQuery('#<%=ddlcity.ClientID%> option').remove();
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: jQuery('#<%=ddlstate.ClientID%>').val() }, function (result) {
                cityData = jQuery.parseJSON(result);
                if (cityData.length == 0) {
                    jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("No City Found"));
                }
                else {
                    jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < cityData.length; i++) {
                        jQuery('#<%=ddlcity.ClientID%>').append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                    }
                    if (con != -1) {
                        $("#<%=ddlcity.ClientID%>").val(con);
                    }

                }
            });             
        }
        function bindLocality(con,cityID) {
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            if (cityID == -1)
                cityID = jQuery('#<%=ddlcity.ClientID%>').val();
            serverCall('../Common/Services/CommonServices.asmx/bindLocalityByCity', { CityID: cityID }, function (result) {
                localityData = jQuery.parseJSON(result);
                if (localityData.length == 0) {
                    jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("---No Area Found---"));
                }
                else {
                    jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val("0").html("Select"));
                    for (i = 0; i < localityData.length; i++) {
                        jQuery('#<%=ddlarea.ClientID%>').append(jQuery("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                    }
                    if (con != -1) {
                        $("#<%=ddlarea.ClientID%>").val(con);
                    }
                }
            });
        }
        function bindpincode() {
            jQuery('#<%=txtpincode.ClientID%>').val('');
            serverCall('customercare.aspx/bindpincode', { LocalityID: CancelReason }, function (result) {
                pincode = result;
                if (pincode == "") {
                    jQuery('#<%=txtpincode.ClientID%>').val('').attr('readonly', false);
                }
                else {
                    jQuery('#<%=txtpincode.ClientID%>').val(pincode).attr('readonly', true);
                }
            });
        }
    </script>
    <script type="text/javascript">
        function getpdetail() {

            $('#tbl tr').slice(1).remove();

            var searchdata = $("#<%= txtmobilesearch.ClientID%>").val().trim();
            if (searchdata == "") {
                toast("Error","Please Enter Mobile No.");
                $("#<%= txtmobilesearch.ClientID%>").focus();
                return;
            }
            if (searchdata.length < 10) {
                toast("Error","Incorrect  Mobile No.");
                $("#<%= txtmobilesearch.ClientID%>").focus();
                return;
            }         
            serverCall('UpdateHCPatient.aspx/BindOldPatient', { searchdata: searchdata }, function (result) {
                OLDPatientData = $.parseJSON(result);
                if (OLDPatientData.length == 0) {                     
                    $('#tbl tr').slice(1).remove();
                    toast("Error","No Patient Found");
                    return;
                }
                else {
                    for (var i = 0; i <= OLDPatientData.length - 1; i++) {
                        var color = '';
                        if (OLDPatientData[i].isreg == "0") {
                            color = 'papayawhip';
                        }
                        else {
                            color = 'lightgreen';
                        }
                        var $mydata = [];
                        $mydata.push("<tr id='"); $mydata.push(OLDPatientData[i].Patient_id); $mydata.push("' style='text-align:left;background-color:"); $mydata.push(color); $mydata.push(";'>");
                        if (OLDPatientData[i].iseditd == "0") {
                            $mydata.push('<td align="center"></td>');
                        }
                        else {
                            $mydata.push('<td align="center"><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="openviewbox(this)" /></td>');
                        }
                        if (OLDPatientData[i].isreg == "0") {
                            $mydata.push('<td><input type="button" value="Select" onclick="showoldpatientdata(this);" class="savebutton" /></td>');
                        }
                        else {
                            $mydata.push('<td><input type="button" value="Select" onclick="showoldpatientdata(this);" class="searchbutton" /></td>');
                        }
                        $mydata.push('<td id="Patient_id">'); $mydata.push(OLDPatientData[i].Patient_id); $mydata.push('</td>');
                        $mydata.push('<td id="NAME">'); $mydata.push(OLDPatientData[i].NAME); $mydata.push('</td>');
                        $mydata.push('<td id="Age">'); $mydata.push(OLDPatientData[i].Age); $mydata.push('</td>');
                        $mydata.push('<td id="Gender">'); $mydata.push(OLDPatientData[i].Gender); $mydata.push('</td>');
                        $mydata.push('<td id="Mobile">'); $mydata.push(OLDPatientData[i].Mobile); $mydata.push('</td>');
                        $mydata.push('<td id="Locality" >'); $mydata.push(OLDPatientData[i].Locality); $mydata.push('</td>');
                        $mydata.push('<td id="City">'); $mydata.push(OLDPatientData[i].City); $mydata.push('</td>');
                        $mydata.push('<td id="State" >'); $mydata.push(OLDPatientData[i].State); $mydata.push('</td>');
                        $mydata.push('<td id="Pincode">'); $mydata.push(OLDPatientData[i].Pincode); $mydata.push('</td>');
                        $mydata.push('<td id="visitdate">'); $mydata.push(OLDPatientData[i].visitdate); $mydata.push('</td>');
                        $mydata.push('<td id="lasthcstatus">'); $mydata.push(OLDPatientData[i].lasthcstatus); $mydata.push('</td>');
                        $mydata.push('<td id="house_no"     style="display:none;">'); $mydata.push(OLDPatientData[i].house_no); $mydata.push('</td>');
                        $mydata.push('<td id="localityid"      style="display:none;">'); $mydata.push(OLDPatientData[i].localityid); $mydata.push('</td>');
                        $mydata.push('<td id="cityid"   style="display:none;">'); $mydata.push(OLDPatientData[i].cityid); $mydata.push('</td>');
                        $mydata.push('<td id="stateid"   style="display:none;">'); $mydata.push(OLDPatientData[i].stateid); $mydata.push('</td>');
                        $mydata.push('<td id="Email"   style="display:none;">'); $mydata.push(OLDPatientData[i].Email); $mydata.push('</td>');
                        $mydata.push('<td id="LastCall"  style="display:none;">'); $mydata.push(OLDPatientData[i].LastCall); $mydata.push('</td>');
                        $mydata.push('<td id="ReasonofCall"    style="display:none;">'); $mydata.push(OLDPatientData[i].ReasonofCall); $mydata.push('</td>');
                        $mydata.push('<td id="ReferDoctor"     style="display:none;">'); $mydata.push(OLDPatientData[i].ReferDoctor); $mydata.push('</td>');
                        $mydata.push('<td id="Source"     style="display:none;">'); $mydata.push(OLDPatientData[i].Source); $mydata.push('</td>');
                        $mydata.push('<td id="pname"     style="display:none;">'); $mydata.push(OLDPatientData[i].pname); $mydata.push('</td>');
                        $mydata.push('<td id="title"     style="display:none;">'); $mydata.push(OLDPatientData[i].title); $mydata.push('</td>');
                        $mydata.push('<td id="DOB"     style="display:none;">'); $mydata.push(OLDPatientData[i].DOB); $mydata.push('</td>');
                        $mydata.push('<td id="AgeYear"     style="display:none;">'); $mydata.push(OLDPatientData[i].AgeYear); $mydata.push('</td>');
                        $mydata.push('<td id="AgeMonth"     style="display:none;">'); $mydata.push(OLDPatientData[i].AgeMonth); $mydata.push('</td>');
                        $mydata.push('<td id="AgeDays"     style="display:none;">'); $mydata.push(OLDPatientData[i].AgeDays); $mydata.push('</td>');
                        $mydata.push('<td id="isreg"     style="display:none;">'); $mydata.push(OLDPatientData[i].isreg); $mydata.push('</td>');
                        $mydata.push('<td id="Street_Name"     style="display:none;">'); $mydata.push(OLDPatientData[i].Street_Name); $mydata.push('</td>');                          
                        $mydata.push('</tr>');
                        $mydata = $mydata.join("");
                        $('#tbl').append($mydata);
                    }                       
                }
            });           
        }
        function showoldpatientdata(ctrl) {
            if ($(ctrl).closest('tr').find('#isreg').text() == "0") {                
                $('#<%=txtnewmobile.ClientID%>').val($(ctrl).closest('tr').find('#Mobile').text());
                $('#<%=txtpatientid.ClientID%>').val($(ctrl).closest('tr').find('#Patient_id').text());
                $('#<%=ddltitle.ClientID%>').val($(ctrl).closest('tr').find('#title').text());
                $('#<%=rdAge.ClientID%>').prop("checked", true);
                $('#<%=txtAge.ClientID%>,#<%=txtAge1.ClientID%>,#<%=txtAge2.ClientID%>').attr("disabled", false);
                $('#<%=txtdob.ClientID%>').attr("disabled", true);
                $("#<%=txtpatientname.ClientID%>").val($(ctrl).closest('tr').find('#pname').text());
                $("#<%=txtpincode.ClientID%>").val($(ctrl).closest('tr').find('#Pincode').text());
                $("#<%=txtdob.ClientID%>").val($(ctrl).closest('tr').find('#DOB').text());
                $("#<%=txtAge.ClientID%>").val($(ctrl).closest('tr').find('#AgeYear').text());
                $("#<%=txtAge1.ClientID%>").val($(ctrl).closest('tr').find('#AgeMonth').text());
                $("#<%=txtAge2.ClientID%>").val($(ctrl).closest('tr').find('#AgeDays').text());
                $("#<%=txtemail.ClientID%>").val($(ctrl).closest('tr').find('#Email').text());
                $("#<%=txtpaddress.ClientID%>").val($(ctrl).closest('tr').find('#house_no').text());
                $("#<%=ddlGender.ClientID%>").val($(ctrl).closest('tr').find('#Gender').text());
                $("#<%=ddlstate.ClientID%>").val($(ctrl).closest('tr').find('#stateid').text());
                $('#<%=txtlandmark.ClientID%>').val($(ctrl).closest('tr').find('#Street_Name').text()); 
                bindCity($(ctrl).closest('tr').find('#cityid').text());
                
                bindLocality($(ctrl).closest('tr').find('#localityid').text(), $(ctrl).closest('tr').find('#cityid').text());
                //$("#<%=ddlarea.ClientID%>").val();
                $('.1').slideToggle("slow");           
            }
            else {
                toast("Error","Patient Registered.Please Contact to IT Team");
            }
        }
        function cancelme() {
            if ($('#mm').is(':hidden')) {
                $('#tbl tr').slice(1).remove();
                $('#<%=txtmobilesearch.ClientID%>').val('');
                $('#molen').html('');
            }
            else {
                $('.1').slideToggle("slow");
            }
        }
    </script>

    <script type="text/javascript">
        function validation() {
            if ($('#<%=txtnewmobile.ClientID%>').val().length == 0) {
                toast("Error","Please Enter Valid Mobile No.");
                $('#<%=txtnewmobile.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtnewmobile.ClientID%>').val().length > 10) {
                toast("Error","Please Enter Mobile No.");
                $('#<%=txtnewmobile.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtpatientname.ClientID%>').val().trim().length == 0) {
                toast("Error","Please Enter Patient Name");
                $('#<%=txtpatientname.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtdob.ClientID%>').val().length == 0) {
                toast("Error","Please Enter DOB");
                $('#<%=txtdob.ClientID%>').focus();
                return false;
            }
            var ageyear = "";
            var agemonth = "";
            var ageday = "";
            if ($('#<%=txtAge.ClientID%>').val() != "") {
                ageyear = $('#<%=txtAge.ClientID%>').val();
            }
            if ($('#<%=txtAge1.ClientID%>').val() != "") {
                agemonth = $('#<%=txtAge1.ClientID%>').val();
            }
            if ($('#<%=txtAge2.ClientID%>').val() != "") {
                ageday = $('#<%=txtAge2.ClientID%>').val();
            }
            if (ageyear == "" && agemonth == "" && ageday == "") {
                toast("Error","Please Enter Patient Age");
                $('#<%=txtAge.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlGender.ClientID%>').val() == "") {
                toast("Error","Please Select Patient Gender");
                $('#<%=ddlGender.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                toast("Error","Please Select State");
                $('#<%=ddlstate.ClientID%>').focus();
                return;
            }
            var length = $('#<%=ddlcity.ClientID%> > option').length;
            if (length == 0) {
                toast("Error","Please Select City");
                $('#<%=ddlcity.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlcity.ClientID%>').val() == "0") {
                toast("Error","Please Select City");
                $('#<%=ddlcity.ClientID%>').focus();
                return;
            }
            var length1 = $('#<%=ddlarea.ClientID%> > option').length;
            if (length1 == 0) {
                toast("Error","Please Select Area");
                $('#<%=ddlarea.ClientID%>').focus();
                return false;
            }
            if ($('#<%=ddlarea.ClientID%>').val() == "0") {
                toast("Error","Please Select Area");
                $('#<%=ddlarea.ClientID%>').focus();
                return;
            }
            if ($('#<%=txtpincode.ClientID%>').val().length == 0) {
                toast("Error","Please Enter Pin Code ");
                $('#<%=txtpincode.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtpincode.ClientID%>').val().length < 6) {
                toast("Error","Please Enter Valid Pin Code ");
                $('#<%=txtpincode.ClientID%>').focus();
                return false;
            }
            if ($('#<%=txtemail.ClientID%>').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test($('#<%=txtemail.ClientID%>').val())) {
                    toast("Error",'Incorrect Email ID');
                    $('#<%=txtemail.ClientID%>').focus();
                    return false;
                }
            }
            return true;
        }
        function patientmaster() {
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if ($('#<%=txtAge.ClientID%>').val() != "") {
                ageyear = $('#<%=txtAge.ClientID%>').val();
            }
            if ($('#<%=txtAge1.ClientID%>').val() != "") {
                agemonth = $('#<%=txtAge1.ClientID%>').val();
            }
            if ($('#<%=txtAge2.ClientID%>').val() != "") {
                ageday = $('#<%=txtAge2.ClientID%>').val();
            }
            age = ageyear + " Y " + agemonth + " M " + ageday + " D ";
            var ageindays = parseInt(ageyear) * 365 + parseInt(agemonth) * 30 + parseInt(ageday);
            var objPM = new Object();
            objPM.Patient_ID = $('#<%=txtpatientid.ClientID%>').val();
            objPM.Title = $('#<%=ddltitle.ClientID%>').val();
            objPM.PName = $('#<%=txtpatientname.ClientID%>').val();
            objPM.House_No = $('#<%=txtpaddress.ClientID%>').val();
            objPM.Street_Name = "";
            objPM.Locality = $('#<%=ddlarea.ClientID%> option:selected').text();
            objPM.City = $("#<%=ddlcity.ClientID%> option:selected").text();
            if ($('#<%=txtpincode.ClientID%>').val() != "") {
                objPM.PinCode = $('#<%=txtpincode.ClientID%>').val();
            }
            else {
                objPM.PinCode = "0";
            }
            objPM.State = $("#<%=ddlstate.ClientID%> option:selected").text();
            objPM.Country = "INDIA";
            objPM.Phone = "";
            objPM.Mobile = $('#<%=txtnewmobile.ClientID%>').val();
            objPM.Email = $('#<%=txtemail.ClientID%>').val();
            objPM.Street_Name = $('#<%=txtlandmark.ClientID%>').val();
            objPM.Age = age;
            objPM.AgeYear = ageyear;
            objPM.AgeMonth = agemonth;
            objPM.AgeDays = ageday;
            objPM.TotalAgeInDays = ageindays;
            objPM.DOB = $('#<%=txtdob.ClientID%>').val();
            objPM.Gender = $("#<%=ddlGender.ClientID%> option:selected").text();
            objPM.CentreID = "1";
            objPM.StateID = $('#<%=ddlstate.ClientID%>').val();
            objPM.CityID = $('#<%=ddlcity.ClientID%>').val();
            objPM.localityid = $('#<%=ddlarea.ClientID%>').val();
            objPM.IsOnlineFilterData = 0;
            objPM.IsDuplicate = 0;
            objPM.IsDOBActual = 0;
            if ($('#<%=rdDOB.ClientID%>').is(':checked')) {
                objPM.IsDOBActual = 1;
            }
            objPM.EmployeeID = "";
            objPM.Relation = "";
            objPM.UniqueKey = "";
            return objPM;
        }
        function Updateme() {
            if (validation()) {
                var patientdata = patientmaster();
                $("#btnSave").attr('disabled', true).val("Updating...");
                serverCall('UpdateHCPatient.aspx/UpdatePatient', { PatientDatamain: patientdata }, function (result) {
                    var save = result;
                    $('#btnSave').attr('disabled', false).val("Update Patient");
                    if (save == "1") {
                        toast("Success", "Patient Data Updated");
                        resetme();
                        cancelme();
                        $('#<%=txtmobilesearch.ClientID%>').val(patientdata.Mobile);
                        getpdetail();
                    }
                    else {
                        toast("Error", save);
                        $('#btnSave').attr('disabled', false).val("Update Patient");
                    }
                });
            }
        }
        function resetme() {
            $('#<%=ddlstate.ClientID%>').prop('selectedIndex', 0);
            jQuery('#<%=ddlarea.ClientID%> option').remove();
            jQuery('#<%=ddlcity.ClientID%> option').remove();          
            $("input[type=text]").val("");
            $('#molen').html('');
        }
        function openviewbox(ctrl) {          
            $('#detailtable1 tr').slice(1).remove();
            serverCall('UpdateHCPatient.aspx/BindLog', { patient_id: $(ctrl).closest('tr').find("#Patient_id").text() }, function (result) {
                ItemData = jQuery.parseJSON(result);
                var total = 0;
                if (ItemData.length == 0) {
                    toast("Error", "No Item Found");
                }
                else {                  
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $mydata = [];
                         $mydata.push("<tr style='background-color:blanchedalmond;'>");
                         $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(parseInt(i + 1));$mydata.push('</td>');
                         $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].Patient_ID);$mydata.push('</td>');
                         $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].UpdateDate);$mydata.push('</td>');
                         $mydata.push('<td  class="GridViewLabItemStyle" style="font-weight:bold;">');$mydata.push(ItemData[i].FieldName);$mydata.push('</td>');
                         $mydata.push('<td  class="GridViewLabItemStyle" style="font-weight:bold;">');$mydata.push(ItemData[i].OldValue);$mydata.push('</td>');
                         $mydata.push('<td  class="GridViewLabItemStyle" style="font-weight:bold;">');$mydata.push(ItemData[i].NewValue);$mydata.push('</td>');
                         $mydata.push('<td  class="GridViewLabItemStyle">');$mydata.push(ItemData[i].UpdateByName);$mydata.push('</td>');
                         $mydata.push("</tr>");
                         $mydata = $mydata.join("");
                         $('#detailtable1').append($mydata);
                    }                   
                }
            });           
            $('#popup_box1').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });          
        }
        function unloadPopupBox() {
            $('#popup_box1').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
        }       
    </script>       
</asp:Content>

