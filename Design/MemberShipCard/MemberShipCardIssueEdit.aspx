<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MemberShipCardIssueEdit.aspx.cs" Inherits="Design_MemberShipCard_MemberShipCardIssueEdit" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script> 
    <style type="text/css">
        #divdetail {
            display: none;
            position: fixed;
            _position: absolute;
            height: 500px;
            width: 920px;
            left: 10%;
            top: 10%;
            z-index: 100;
            margin-left: 15px;
            border: 2px solid #ff0000;
            padding: 5px;
            background-color: #d7edff;
            border-radius: 5px;
        }

        #divoldpatient {
            display: none;
            position: fixed;
            _position: absolute;
            height: 300px;
            width: 820px;
            left: 10%;
            top: 10%;
            z-index: 100;
            margin-left: 15px;
            border: 2px solid #ff0000;
            padding: 5px;
            background-color: #d7edff;
            border-radius: 5px;
        }
    </style>   
        <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style=" text-align: center;">
          <div class="row">
              <div class="col-md-24">
                  <b>Membership Card Edit</b>
              </div>
          </div>                          
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-4 required" style="text-align:right"><strong>Card No :</strong></div>
                <div class="col-md-6"><asp:TextBox id="txtCardNo" Width="300px" runat="server" autocomplete="off" maxlength="20" /> </div>
                <div class="col-md-14" style="text-align:left"><input type="button" value="Search" class="searchbutton" onclick="search()" /></div>
            </div>           
        </div>
        <div class="POuter_Box_Inventory">
           <div class="row">
               <div class="col-md-3" style="font-weight: bold;">Card Name :</div>
               <div class="col-md-3" style="color: blue;"><span id="spnCardName" style="color: blue;"></span></div>
               <div class="col-md-3">Card Amount :</div>
               <div class="col-md-3"><span id="spcardamount" style="color: blue;"></span></div>
               <div class="col-md-3">No. of Dependant :</div>
               <div class="col-md-3"><span id="spnodependant" style="color:blue;"></span></div>
               <div class="col-md-3">Expiry Date :</div>
               <div class="col-md-3"><span id="spexpirydate" style="color: blue;"></span></div>
           </div>
              <div class="row" style="display:none">
               <div class="col-md-4">Card Type :</div>
                  <div class="col-md-24"> <span id="spnCardType" style="color:blue;"></span>
                            <span id="spnSavingCardType" style="color: blue;display:none"></span>
                            <span id="spnMembershipCardNo" style="color: blue;display:none"></span>
                            <span id="spnMembershipCardID" style="color: blue;display:none"></span>
                            <span id="spnCentreID" style="color: blue;display:none"></span>
                           <span id="spnFamilyMemberGroupID" style="color: blue;display:none"></span> </div>
                   </div>                         
        </div>
           <div class="POuter_Box_Inventory hideControl" style="display:none" >
              <div class="Purchaseheader">
                  <div class="row">
                      <div class="col-md-24">Member Detail</div>
                  </div>                                     
            </div>
               <div class="row">
                   <div class="col-md-24">
                        <table id="tblMembership" style="width: 1300px; border-collapse: collapse">

                       <tr id="famheader">
                                        
                                        <td class="GridViewHeaderStyle" style="text-align:left">Mobile No.</td>
                                        <td class="GridViewHeaderStyle" style="text-align:left">Family Relation</td>                                      
                                        <td class="GridViewHeaderStyle" style="text-align:left">Title</td>
                                        <td class="GridViewHeaderStyle" style="text-align:left">Patient Name</td>
                                        <td class="GridViewHeaderStyle" style="text-align:left">UHID</td>
                                        <td class="GridViewHeaderStyle" style="text-align:left">Gender</td>
                                        <td class="GridViewHeaderStyle" style="text-align:left">Age</td>
                                        <td class="GridViewHeaderStyle" style="text-align:left">DOB</td>                         
                                        <td class="GridViewHeaderStyle" style="text-align:left">Address</td>                                                                 
                                        <td class="GridViewHeaderStyle" style="text-align:left;width:20px" >Remove</td>
                                        
                       </tr>
                       </table>
                   </div>
               </div>
       

              </div>

           <div class="POuter_Box_Inventory hideControl" style="display:none" >                                     
            <div class="Purchaseheader">
                    Dependant Member
                     </div>
               <div class="row">
                   <div class="col-md-24">
                        <table id="tbldependent" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="trh">
                         <td class="GridViewHeaderStyle" style="width:50px;">S.No.</td>
                         <td class="GridViewHeaderStyle" style="width:120px;">Mobile No.</td>
                         <td class="GridViewHeaderStyle" style="width:120px;">UHID</td>
                         <td class="GridViewHeaderStyle" style="width:270px;">Patient Name</td>
                         <td class="GridViewHeaderStyle" style="width:10px;">&nbsp;</td>
                         <td class="GridViewHeaderStyle" style="width:160px;">Age</td>
                         <td class="GridViewHeaderStyle" style="width:10px;">&nbsp;</td>
                         <td class="GridViewHeaderStyle" style="width:100px;">DOB</td>
                         <td class="GridViewHeaderStyle" style="width:100px;">Gender</td>
                         <td class="GridViewHeaderStyle" style="width:100px;">Relation</td>
                         
                    </tr>
                </table>
                   </div>
               </div>
               
                </div>
             
                  <div class="POuter_Box_Inventory hideControl" style="display:none;text-align:center" >

          <div class="row">
              <div class="col-md-24">
                   <input type="button" value="Save" class="savebutton" onclick="savedata()" id="btnSave" />
                &nbsp;&nbsp;&nbsp;
                <input type="button" value="Cancel" class="resetbutton" onclick="clearall()" />
              </div>
          </div>                          
        </div>
        <div id="divoldpatient">
        <img src="../../App_Images/Close.ico" onclick="unloadoldbox()" style="position: absolute; right: -20px; top: -20px; width: 36px; height: 36px; cursor: pointer;" title="Close" alt="" />
        <div class="Purchaseheader">Old Patient</div>
            <div class="row">
                <div class="col-md-24">
                     <table id="tbloldpatient" style="width: 99%; border-collapse: collapse; text-align: left;">



            <tr id="tr1">
                <td class="GridViewHeaderStyle" style="width: 50px;">Select</td>
                <td class="GridViewHeaderStyle">UHID</td>
                <td class="GridViewHeaderStyle">Patient Name</td>

                <td class="GridViewHeaderStyle">Age</td>
                <td class="GridViewHeaderStyle">Gender</td>
                <td class="GridViewHeaderStyle">Mobile</td>
                <td class="GridViewHeaderStyle">Reg Date</td>
            </tr>
        </table>
                </div>
            </div>       
    </div>
</div>
    <script type="text/javascript">
        var List = []; var relationPush = [];
        function search() {
            
           
            $('#tblMembership tr').slice(1).remove();
            $('#tbldependent tr').slice(1).remove();
            if ($('#<%=txtCardNo.ClientID%>').val() == "") {
                $('#<%=txtCardNo.ClientID%>').focus();
                toast("Info", "Please Enter Card No.", "");
                return;
            }
            serverCall('MemberShipCardIssueEdit.aspx/bindMembershipCard', { CardNo: $('#<%=txtCardNo.ClientID%>').val() }, function (response) {                
                var $responseData = JSON.parse(response);
                if ($responseData.response.length == "0") {
                    $('#btnaddnew').hide();
                    toast("Info", "No MemberShip Found", "");
                    $('#<%=txtCardNo.ClientID%>').val('');
                        return;
                    }
                var MembershipData = $.parseJSON($responseData.response);
                if (MembershipData.length == 0) {
                    $('#btnaddnew').hide();
                    toast("Info", "No MemberShip Found", "");
                    $('#txtCardNo').val('');
                }
                else {
                    relationPush = [];
                    $('#btnaddnew').show();
                    var totalDept = 0;
                    for (var i = 0; i <= MembershipData.length - 1; i++) {
                        if (i == 0) {
                            $('#spnCardName').text(MembershipData[0].MembershipCardName);

                            $('#spcardamount').text(MembershipData[0].MembershipCardAmount);
                            $('#spnodependant').text(MembershipData[0].MembershipCardDependent);
                            $('#spexpirydate').text(MembershipData[0].ValidTo);
                            $('#spnCardType').text(MembershipData[0].CardType);
                            $('#spnSavingCardType').text(MembershipData[0].SavingCardType);
                            $('#spnMembershipCardNo').text(MembershipData[0].MembershipCardNo);
                            $('#spnMembershipCardID').text(MembershipData[0].MembershipCardID);
                            $('#spnCentreID').text(MembershipData[0].CentreID);
                            $('#spnFamilyMemberGroupID').text(MembershipData[0].FamilyMemberGroupID);
                            totalDept = MembershipData[0].MembershipCardDependent;
                        }
                        var ListID = "";
                        if (MembershipData[i].mobile == "") {
                            ListID = "".concat(MembershipData[i].mobile, "_", i);
                        }
                        else {
                            ListID = "".concat(MembershipData[i].mobile, "_", MembershipData[i].patient_id);
                        }
                        List.push(ListID);
                        relationPush.push(MembershipData[i].familymemberrelation);
                        var mydata = [];
                        if (MembershipData[i].FamilyMemberIsPrimary == "1") {
                            mydata.push("<tr class='GridViewItemStyle' style='text-align:left;background-color:lightblue;height:50px' id='"); mydata.push(MembershipData[i].patient_id); mydata.push("' >");
                        }
                        else {
                            mydata.push("<tr class='GridViewItemStyle' style='text-align:left;background-color:lightyellow;height:50px' id='"); mydata.push(MembershipData[i].patient_id); mydata.push("' >");
                        }
                        mydata.push('<td id="tdmobile" style="font-weight:bold;">'); mydata.push(MembershipData[i].mobile); mydata.push('</td>');
                        mydata.push('<td id="tdpatientfamilyrelation">'); mydata.push(MembershipData[i].familymemberrelation); mydata.push('</td>');
                        mydata.push('<td id="tdpatientfamilygroupid" style="display:none">'); mydata.push(MembershipData[i].FamilyMemberGroupID); mydata.push('</td>');
                        mydata.push('<td id="tdpatienttitle">'); mydata.push(MembershipData[i].title); mydata.push('</td>');
                        mydata.push('<td id="tdpatientname">'); mydata.push(MembershipData[i].pname); mydata.push('</td>');
                        mydata.push('<td id="tdpatientid" style="font-weight:bold;">'); mydata.push(MembershipData[i].patient_id); mydata.push('</td>');
                        mydata.push('<td id="tdgender" style="font-weight:bold;">'); mydata.push(MembershipData[i].gender); mydata.push('</td>');
                        mydata.push('<td id="tdage">'); mydata.push(MembershipData[i].age); mydata.push('</td>');
                        mydata.push('<td id="tddob">'); mydata.push(MembershipData[i].dob); mydata.push('</td>');
                        mydata.push('<td id="tdhouse_no">'); mydata.push(MembershipData[i].house_no); mydata.push('</td>');

                        if (MembershipData[i].FamilyMemberIsPrimary == "1") {
                            mydata.push('<td class="GridViewLabItemStyle"> <img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deletePrimaryMemberRow(this)"/></td>');

                        }
                        else {
                            mydata.push('<td class="GridViewLabItemStyle"> <img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleteMemberRow(this)"/></td>');
                        }
                        mydata.push('<td id="tdageyear" style="display:none;">'); mydata.push(MembershipData[i].ageyear); mydata.push('</td>');
                        mydata.push('<td id="tdagemonth" style="display:none;">'); mydata.push(MembershipData[i].agemonth); mydata.push('</td>');
                        mydata.push('<td id="tdagedays" style="display:none;">'); mydata.push(MembershipData[i].agedays); mydata.push('</td>');
                        mydata.push('<td id="tdIsNew" style="display:none;">0</td>');
                        mydata.push('<td id="tdListID" style="display:none;">'); mydata.push(ListID); mydata.push('</td>');
                        mydata.push('<td id="tdMembershipCardNo" style="display:none;">'); mydata.push(MembershipData[i].MembershipCardNo); mydata.push('</td>');
                        mydata.push('<td id="tdMembershipCardID" style="display:none;">'); mydata.push(MembershipData[i].MembershipCardID); mydata.push('</td>');
                        mydata.push('</tr>');
                        mydata = mydata.join("");
                        $('#tblMembership').append(mydata);


                    }
                    totalDept = totalDept - (MembershipData.length - 1);
                    for (var a = 1; a <= Number(totalDept) ; a++) {
                        var $mydata = [];
                        $mydata.push('<tr style="background-color:lightgreen;" class="GridViewItemStyle">');
                        $mydata.push('<td  align="left" id="srnn">'); $mydata.push(parseFloat(a)); $mydata.push('</td>');
                        $mydata.push('<td  align="left" > <input  id="txtMobileNo_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' maxlength="10"  onkeyup="showoldpatient(this,event);"  style="width:120px;" /> </td>');
                        $mydata.push('<td  align="left" > <input  id="txtUHID_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onkeyup="showoldpatientbyuhid(this,event);" style="width:120px;"  />  <input id="txtUHIDOLD_'); $mydata.push(a); $mydata.push('"'); $mydata.push('  style="display:none;" />  </td>');
                        $mydata.push('<td  align="left" ><select id="ddlTitle_'); $mydata.push(a); $mydata.push('"'); $mydata.push('  class="ddlTitle" onchange="$onTitleChangenew(this.value,' + a + ')" style="width:80px;"></select>');
                        $mydata.push('<input type="text" id="txtPName_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' checkSpecialCharater" autocomplete="off"  style="text-transform:uppercase;width:200px;"  onlyText="50" maxlength="50"  /></td>');
                        $mydata.push('<td align="left"><input type="radio"  checked="checked" name="DeptAge_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onclick="setAge(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push('id="rdoAge_'); $mydata.push(a); $mydata.push('"/> </td>'); $mydata.push('<td><input type="text"  id="txtAge_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onkeyUp="getdobDept(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push(' style="width:50px;float:left" onlynumber="5"  max-value="120"  autocomplete="off"  maxlength="3"    placeholder="Years"/><input type="text" id="txtAge1_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onkeyUp="getdobDept(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push(' style="width:60px;float:left" onlynumber="5"   max-value="12"  autocomplete="off"  maxlength="2"  placeholder="Months"/><input type="text" id="txtAge2_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onkeyUp="getdobDept(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push(' style="width:50px;float:left"  onlynumber="5"  max-value="30"  autocomplete="off"  maxlength="2"   placeholder="Days"/></td>');
                        $mydata.push('<td align="left"><input type="radio"  name="DeptAge_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onclick="setDOB(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push('id="rdoDOB_'); $mydata.push(a); $mydata.push('"/> </td>'); $mydata.push('<td><input type="text" class="txtdobDept" disabled="disabled" id="txtDOB_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' style="width:100px;float:left" onlynumber="5"  maxlength="11" autocomplete="off" "/></td>');
                        $mydata.push('<td><select id="ddlGender_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' disabled><option value="Male">Male</option><option value="Female">Female</option><option value=""></option></select></td>');
                        $mydata.push('<td><select id="ddlrelation_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' ><option value="0">Select</option><option value="Father">Father</option>  <option value="Mother">Mother</option>  <option value="Husband">Husband</option>  <option value="Wife">Wife</option>  <option value="Son">Son</option>  <option value="Daughter">Daughter</option>  <option value="Relative">Relative</option>  <option value="Uncle">Uncle</option>  <option value="Aunty">Aunty</option>  <option value="Sister">Sister</option>  <option value="Brother">Brother</option>  <option value="Spouse">Spouse</option>  <option value="Self">Self</option></select></td>');


                        $mydata = $mydata.join("");
                        $('#tbldependent').append($mydata);
                        getDOBDept(a);
                    }
                    $bindSpecialCharater();
                    bindTitle();
                    $('.hideControl').show();
                }
            });         
        }
        function showoldpatientbyuhid(ctrl, event) {
            var id = $(ctrl).closest('tr').find('#srnn').text();
            var keyCode = (event.keyCode ? event.keyCode : event.charCode);
            if ($(ctrl).val().length > 0 && keyCode == 13) {
                bindoldpatient($(ctrl).val(), '0', 'UHID', id);
            }
        }
        function getDOBDept(row) {


            jQuery("#txtDOB_" + row).datepicker({
                dateFormat: "dd-M-yy",
                changeMonth: true,
                maxDate: new Date,
                changeYear: true, yearRange: "-100:+0",
                onSelect: function (value, ui) {
                    var today = new Date();
                    //  var dob = new Date(value);
                    var dob = value;
                    getAgeDept(dob, today, row);
                }
            });
        }
        function getAgeDept(birthDate, ageAtDate, row) {
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
            jQuery("#txtAge_" + row).val(years);
            jQuery("#txtAge1_" + row).val(months);
            jQuery("#txtAge2_" + row).val(days);

        }
        function getdobDept(ctrl, row) {
            if (jQuery(ctrl).val().charAt(0) == "0") {
                jQuery(ctrl).val(Number(jQuery(ctrl).val()));
            }
            if (jQuery(ctrl).val().match(/[^0-9]/g)) {
                jQuery(ctrl).val(jQuery(ctrl).val().replace(/[^0-9]/g, ''));
                jQuery(ctrl).val(Number(jQuery(ctrl).val()));
                return;
            }
            var age = "";
            var ageyear = "0";
            var agemonth = "0";
            var ageday = "0";
            if (jQuery("#txtAge_" + row).val() != "") {
                if (jQuery("#txtAge_" + row).val() > 110) {
                    toast("Info", "Please Enter Valid Age in Years", "");
                    jQuery("#txtAge_" + row).val('');
                }
                ageyear = jQuery("#txtAge_" + row).val();
            }
            if (jQuery("#txtAge1_" + row).val() != "") {
                if (jQuery("#txtAge1_" + row).val() > 12) {
                    toast("Info", "Please Enter Valid Age in Months", "");
                    jQuery("#txtAge1_" + row).val('');
                }
                agemonth = jQuery("#txtAge1_" + row).val();

            }
            if (jQuery("#txtAge2_" + row).val() != "") {
                if (jQuery("#txtAge2_" + row).val() > 30) {
                    toast("Info", "Please Enter Valid Age in Days", "");
                    jQuery("#txtAge2_" + row).val('');
                }
                ageday = jQuery("#txtAge2_" + row).val();
            }
            var d = new Date(); // today!
            if (ageday != "")
                d.setDate(d.getDate() - ageday);
            if (agemonth != "")
                d.setMonth(d.getMonth() - agemonth);
            if (ageyear != "")
                d.setFullYear(d.getFullYear() - ageyear);
            var m_names = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
            var yyyy = d.getFullYear();
            var MM = d.getMonth();
            var dd = d.getDate();
            var xxx = "".concat(minTwoDigits(dd), "-", m_names[MM], "-", yyyy);
            jQuery("#txtDOB_" + row).val(xxx);

        }
        var bindTitle = function () {
            serverCall('../Common/Services/CommonServices.asmx/bindTitleWithGender', {}, function (response) {
                var $ddlTitle = $('.ddlTitle');
                $ddlTitle.bindDropDown({ data: JSON.parse(response), valueField: 'gender', textField: 'title' });               
            });
        }
        var $onTitleChangenew = function (gender, id) {
            var $gender = jQuery('#ddlGender_' + id).val();
            if (String.isNullOrEmpty(gender) || gender == 'UnKnown') {
                jQuery('#ddlGender_' + id).val("").prop('disabled', false);
            }
            else {
                jQuery('#ddlGender_' + id).val(gender).prop('disabled', true);
            }
        }      
        function setAge(ctrl, row) {

            if (jQuery('#rdoAge_' + row).is(':checked')) {
                jQuery("#txtDOB_" + row).attr("disabled", true);
                jQuery("#txtAge_" + row).attr("disabled", false);
                jQuery("#txtAge1_" + row).attr("disabled", false);
                jQuery("#txtAge2_" + row).attr("disabled", false);
            }
        }
        function setDOB(ctrl, row) {
            if (jQuery('#rdoDOB_' + row).is(':checked')) {
                jQuery('#txtDOB_' + row).attr("disabled", false);
                jQuery("#txtAge_" + row).attr("disabled", true);
                jQuery("#txtAge1_" + row).attr("disabled", true);
                jQuery("#txtAge2_" + row).attr("disabled", true);


            }
        }
        function showoldpatient(ctrl, event) {
            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
            }
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
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
          

            var keyCode = ('which' in event) ? event.which : event.keyCode;
           
            var id = $(ctrl).closest('tr').find('#srnn').text();
        
            if ($(ctrl).val().length == 10 && (keyCode == 13 || keyCode == 9)) {
                bindoldpatient($(ctrl).val(), '0', 'Mobile', id);
            }
        }
        function unloadoldbox() {
            $('#divoldpatient').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
        }
        function minTwoDigits(n) {
            return (n < 10 ? '0' : '') + n;
        }               
        function bindoldpatient(searchvalue, type, setype, trid) {
            $('#tbloldpatient tr').slice(1).remove();
            $modelBlockUI();
            var data = { MobileNo: '', Patient_ID: '', PName: '', FromRegDate: '', ToRegDate: '', MemberShipCardNo: '' };
            if (setype == "UHID") {
                data.Patient_ID = searchvalue;
            }
            else {
                data.MobileNo = searchvalue;
            }          
            serverCall('../Lab/Services/LabBooking.asmx/BindOldPatient', { searchdata: data }, function (result) {
                var OLDPatientData = jQuery.parseJSON(result.d);
                if (OLDPatientData.length > 0) {
                    for (var i = 0; i <= OLDPatientData.length - 1; i++) {
                        var mydata = [];
                        mydata.push('<tr style="background-color:lightgreen;" class="GridViewItemStyle">');
                        mydata.push('<td  align="left" ><input type="button" value="Select" onclick="setmypatient(this,'); mydata.push(type); mydata.push(','); mydata.push(trid); mydata.push(')"/></td>');
                        mydata.push('<td  align="left" id="Patient_ID">'); mydata.push(OLDPatientData[i].patient_id); mydata.push('</td>');
                        mydata.push('<td  align="left" >'); mydata.push(OLDPatientData[i].title); mydata.push(OLDPatientData[i].pname); mydata.push('</td>');
                        mydata.push('<td  align="left" >'); mydata.push(OLDPatientData[i].age); mydata.push('</td>');
                        mydata.push('<td  align="left" id="gender">'); mydata.push(OLDPatientData[i].gender); mydata.push('</td>');
                        mydata.push('<td  align="left" id="mobile">'); mydata.push(OLDPatientData[i].mobile); mydata.push('</td>');
                        mydata.push('<td  align="left" >'); mydata.push(OLDPatientData[i].visitdate); mydata.push('</td>');
                        mydata.push('<td  align="left" style="display:none;" id="title">'); mydata.push(OLDPatientData[i].title); mydata.push('</td>');
                        mydata.push('<td  align="left" style="display:none;" id="PName">'); mydata.push(OLDPatientData[i].pname); mydata.push('</td>');
                        mydata.push('<td  align="left" style="display:none;" id="ageYear">'); mydata.push(OLDPatientData[i].ageyear); mydata.push('</td>');
                        mydata.push('<td  align="left" style="display:none;" id="ageMonth">'); mydata.push(OLDPatientData[i].agemonth); mydata.push('</td>');
                        mydata.push('<td  align="left" style="display:none;" id="ageDays">'); mydata.push(OLDPatientData[i].agedays); mydata.push('</td>');
                        mydata.push('<td  align="left" style="display:none;" id="olddob">'); mydata.push(OLDPatientData[i].dob); mydata.push('</td>');
                        mydata.push('<td  align="left" style="display:none;" id="oldpincode">'); mydata.push(OLDPatientData[i].pincode); mydata.push('</td>');
                        mydata.push('<td  align="left" style="display:none;" id="oldhouseno">'); mydata.push(OLDPatientData[i].house_no); mydata.push('</td>');
                        mydata = mydata.join("");
                        $('#tbloldpatient').append(mydata);
                    }
                    $('#divoldpatient').fadeIn("slow");
                    $("#Pbody_box_inventory").css({
                        "opacity": "0.5"
                    });
                }
                else {
                    toast("Info", "No Patient Found", "");
                }               
            });      
        }
        function setmypatient(ctrl, type, trid) {
            if (type == "1") {
               
            }
            else {

                if ($('#txtUHID').val() == $(ctrl).closest("tr").find('#Patient_ID').text()) {
                    unloadoldbox();
                    toast("Info", "Same Patient Selected As Primary Member", "");
                    return;
                }
                var c = 0;
                $('#tbldependent tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "trh") {
                        var ss = $(this).closest('tr').find('#srnn').text();
                        if (trid != ss) {
                            if ($('#txtUHID_' + ss).val() == $(ctrl).closest("tr").find('#Patient_ID').text()) {
                                c = 1;
                                return;
                            }
                        }
                    }
                });
                if (c == 1) {
                    unloadoldbox();
                    toast("Info", "Same Patient Selected In Dependant List", "");
                    
                    return;
                }
                $('#txtUHID_' + trid).val($(ctrl).closest("tr").find('#Patient_ID').text()).attr('disabled', true);
                $('#txtUHIDOLD_' + trid).val($(ctrl).closest("tr").find('#Patient_ID').text());
                $('#txtMobileNo_' + trid).val($(ctrl).closest("tr").find('#mobile').text()).prop('disabled', true);
                $("#ddlTitle_" + trid + " option:contains(" + $(ctrl).closest("tr").find('#title').text() + ")").attr('selected', 'selected');
                $('#ddlTitle_' + trid).attr('disabled', true);
                $('#txtPName_' + trid).val($(ctrl).closest("tr").find('#PName').text()).attr('disabled', true);
                $('#txtAge_' + trid).val($(ctrl).closest("tr").find('#ageYear').text()).attr('disabled', true);
                $('#txtAge1_' + trid).val($(ctrl).closest("tr").find('#ageMonth').text()).attr('disabled', true);
                $('#txtAge2_' + trid).val($(ctrl).closest("tr").find('#ageDays').text()).attr('disabled', true);
                $('#ddlGender_' + trid).val($(ctrl).closest("tr").find('#gender').text()).attr('disabled', true);
                $('#rdoAge_' + trid).prop("checked", true);
                $('#txtDOB_' + trid).val($(ctrl).closest("tr").find('#olddob').text()).attr('disabled', true);
                $('#rdoAge_' + trid).attr("disabled", true);
                $('#rdoDOB_' + trid).attr("disabled", true);
                unloadoldbox();
            }
        }
        
    </script>
        <script type="text/javascript">
            function removeMember(rowID, IsPrimaryMember, contentMsg) {
                jQuery.confirm({
                    title: 'Confirmation!',
                    content: contentMsg,
                    animation: 'zoom',
                    closeAnimation: 'scale',
                    useBootstrap: false,
                    opacity: 0.5,
                    theme: 'light',
                    type: 'red',
                    typeAnimated: true,
                    boxWidth: '420px',
                    buttons: {
                        'confirm': {
                            text: 'Yes',
                            useBootstrap: false,
                            btnClass: 'btn-blue',
                            action: function () {
                                confirmationMemberAction(rowID, IsPrimaryMember);
                            }
                        },
                        somethingElse: {
                            text: 'No',
                            action: function () {
                                clearMemberAction();
                            }
                        },
                    }
                });
            }
            function confirmationMemberAction(rowID, IsPrimaryMember) {
                var familyGroupID = $(rowID).closest("tr").find("#tdpatientfamilygroupid").text();
                var UHID = $(rowID).closest("tr").find("#tdpatientid").text();
                var MobileNo = $(rowID).closest("tr").find("#tdmobile").text();
                var table = document.getElementById('tblMembership');
                var ListID = $(rowID).closest("tr").find("#tdListID").text();
                var MembershipCardNo = $(rowID).closest("tr").find("#tdMembershipCardNo").text();

                serverCall('MemberShipCardIssueEdit.aspx/RemoveMember', { familyGroupID: familyGroupID, UHID: UHID, IsPrimaryMember: IsPrimaryMember, MembershipCardNo: MembershipCardNo }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", $responseData.response, "");

                        table.deleteRow(rowID.parentNode.parentNode.rowIndex);
                        if (IsPrimaryMember == 0) {
                            List.splice($.inArray(ListID, List), 1);

                            $('#tbldependent tr').slice(1).remove();
                            var totalDept = $('#spnodependant').text();

                            var MembershipHeader = jQuery("#tblMembership").find('tr:not(#famheader)').length - 1;

                            var totalDept = totalDept - MembershipHeader;
                            for (var a = 1; a <= Number(totalDept) ; a++) {
                                var $mydata = [];
                                $mydata.push('<tr style="background-color:lightgreen;" class="GridViewItemStyle">');
                                $mydata.push('<td  align="left" id="srnn">'); $mydata.push(parseFloat(a)); $mydata.push('</td>');
                                $mydata.push('<td  align="left" > <input  id="txtMobileNo_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' maxlength="10"  onkeyup="showoldpatient(this,event);"  style="width:120px;" /> </td>');
                                $mydata.push('<td  align="left" > <input  id="txtUHID_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onkeyup="showoldpatientbyuhid(this,event);" style="width:120px;"  />  <input id="txtUHIDOLD_'); $mydata.push(a); $mydata.push('"'); $mydata.push('  style="display:none;" />  </td>');
                                $mydata.push('<td  align="left" ><select id="ddlTitle_'); $mydata.push(a); $mydata.push('"'); $mydata.push('  class="ddlTitle" onchange="$onTitleChangenew(this.value,' + a + ')" style="width:80px;"></select>');
                                $mydata.push('<input type="text" id="txtPName_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' checkSpecialCharater" autocomplete="off"  style="text-transform:uppercase;width:200px;"  onlyText="50" maxlength="50"  /></td>');
                                $mydata.push('<td align="left"><input type="radio"  checked="checked" name="DeptAge_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onclick="setAge(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push('id="rdoAge_'); $mydata.push(a); $mydata.push('"/> </td>'); $mydata.push('<td><input type="text"  id="txtAge_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onkeyUp="getdobDept(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push(' style="width:50px;float:left" onlynumber="5"  max-value="120"  autocomplete="off"  maxlength="3"    placeholder="Years"/><input type="text" id="txtAge1_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onkeyUp="getdobDept(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push(' style="width:60px;float:left" onlynumber="5"   max-value="12"  autocomplete="off"  maxlength="2"  placeholder="Months"/><input type="text" id="txtAge2_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onkeyUp="getdobDept(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push(' style="width:50px;float:left"  onlynumber="5"  max-value="30"  autocomplete="off"  maxlength="2"   placeholder="Days"/></td>');
                                $mydata.push('<td align="left"><input type="radio"  name="DeptAge_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' onclick="setDOB(this,'); $mydata.push(a); $mydata.push(')"'); $mydata.push('id="rdoDOB_'); $mydata.push(a); $mydata.push('"/> </td>'); $mydata.push('<td><input type="text" class="txtdobDept" disabled="disabled" id="txtDOB_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' style="width:100px;float:left" onlynumber="5"  maxlength="11" autocomplete="off" "/></td>');
                                $mydata.push('<td><select id="ddlGender_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' disabled><option value="Male">Male</option><option value="Female">Female</option><option value=""></option></select></td>');
                                $mydata.push('<td><select id="ddlrelation_'); $mydata.push(a); $mydata.push('"'); $mydata.push(' ><option value="0">Select</option><option value="Father">Father</option>  <option value="Mother">Mother</option>  <option value="Husband">Husband</option>  <option value="Wife">Wife</option>  <option value="Son">Son</option>  <option value="Daughter">Daughter</option>  <option value="Relative">Relative</option>  <option value="Uncle">Uncle</option>  <option value="Aunty">Aunty</option>  <option value="Sister">Sister</option>  <option value="Brother">Brother</option>  <option value="Spouse">Spouse</option>  <option value="Self">Self</option></select></td>');

                                $mydata = $mydata.join("");
                                $('#tbldependent').append($mydata);
                                getDOBDept(a);
                            }
                            $bindSpecialCharater();
                            bindTitle();
                        }
                        else {
                            Resetme();
                        }
                    }
                    else {
                        toast("Error", $responseData.response, "");
                    }
                    if (IsPrimaryMember == 1) {
                        Resetme();
                    }
                });             
            }
            function clearMemberAction() {

            }
            function Resetme() {
                window.location.reload();
            }
            function deleteMemberRow(rowID) {
                var Patient_ID = $(rowID).closest("tr").find("#tdpatientid").text();
                removeMember(rowID, 0, 'Are you sure to Remove Member ?</br></br> UHID No. :<b> ' + Patient_ID + '</b></br></br>');
            }
            function deletePrimaryMemberRow(rowID) {
                var Patient_ID = $(rowID).closest("tr").find("#tdpatientid").text();
                removeMember(rowID, 1, 'Are you sure to Remove Primary Member ?</br></br> UHID No. :<b> ' + Patient_ID + '</b></br></br>');
            }
            function patientmaster() {
                var dataPM = new Array();

                $('#tbldependent tr').each(function () {
                    if ($(this).closest("tr").attr("id") != "trh") {
                        var ss = $(this).closest('tr').find('#srnn').text();
                        if ($.trim($('#txtMobileNo_' + ss).val()) != "") {
                            var ageyear = "0";
                            var agemonth = "0";
                            var ageday = "0";
                            if ($('#txtAge_' + ss).val() != "") {
                                ageyear = $('#txtAge_' + ss).val();
                            }
                            if ($('#txtAge1_' + ss).val() != "") {
                                agemonth = $('#txtAge1_' + ss).val();
                            }
                            if ($('#txtAge1_' + ss).val() != "") {
                                ageday = $('#txtAge2_' + ss).val();
                            }
                            if (ageyear == "")
                                ageyear = 0;
                            if (agemonth == "")
                                agemonth = 0;
                            if (ageday == "")
                                ageday = 0;
                            age = "".concat(ageyear, " Y ", agemonth, " M ", ageday, " D ");
                            var ageindays = parseInt(ageyear) * 365 + parseInt(agemonth) * 30 + parseInt(ageday);
                            var objPM = new Object();
                            objPM.Patient_ID = $('#txtUHIDOLD_' + ss).val();
                            objPM.Title = $('#ddlTitle_' + ss + ' option:selected').text();
                            objPM.PName = $('#txtPName_' + ss).val();
                            objPM.Mobile = $('#txtMobileNo_' + ss).val();
                            objPM.Age = age;
                            objPM.AgeYear = ageyear;
                            objPM.AgeMonth = agemonth;
                            objPM.AgeDays = ageday;
                            objPM.TotalAgeInDays = ageindays;
                            objPM.DOB = $('#txtDOB_' + ss).val();
                            objPM.Gender = $('#ddlGender_' + ss).val();
                            if ($('#rdoDOB_' + ss).is(':checked'))
                                objPM.IsDOBActual = 1;
                            else
                                objPM.IsDOBActual = 0;
                            objPM.FamilyMemberIsPrimary = 0;
                            objPM.FamilyMemberRelation = $('#ddlrelation_' + ss + ' option:selected').val();
                            objPM.CentreID = $('#spnCentreID').text();
                            objPM.StateID = "0";
                            objPM.CityID = "0";
                            objPM.localityid = "0";
                            objPM.IsOnlineFilterData = 0;
                            objPM.IsDuplicate = 0;
                            objPM.PinCode = "0";
                            objPM.House_No = '';
                            objPM.Street_Name = "";
                            dataPM.push(objPM);
                        }
                    }
                });
                return dataPM;

            }
            function $validation() {

                var c = 0;
                $('#tbldependent tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "trh") {
                        var ss = $(this).closest('tr').find('#srnn').text();
                        if ($.trim($('#txtMobileNo_' + ss).val()) != "") {
                            if ($.trim($('#txtMobileNo_' + ss).val()) == "") {
                                c = 1;
                                $('#txtMobileNo_' + ss).focus();
                                return;
                            }
                            if ($.trim($('#txtPName_' + ss).val()) == "") {
                                c = 2;
                                $('#txtPName_' + ss).focus();
                                return;
                            }
                            if ($.trim($('#txtAge_' + ss).val()) == "" && $.trim($('#txtAge1_' + ss).val()) == "" && $.trim($('#txtAge2_' + ss).val()) == "") {
                                c = 3;
                                $('#txtAge_' + ss).focus();
                                return;
                            }
                            if ($('#ddlGender_' + ss).val() == "") {
                                c = 4;
                                $('#ddlGender_' + ss).focus();
                                return;
                            }
                            if ($('#ddlrelation_' + ss).val() == "0") {
                                c = 5;
                                $('#ddlrelation_' + ss).focus();
                                return;
                            }
                            relationPush.push($('#ddlrelation_' + ss).val());
                        }
                    }
                });
                if (c == 1) {
                    toast("Info", "Please Enter Dependant Mobile No.", "");
                    return false;
                }
                if (c == 2) {
                    toast("Info", "Please Enter Dependant Name", "");
                    return false;
                }
                if (c == 3) {
                    toast("Info", "Please Enter Dependant Age", "");
                    return false;
                }
                if (c == 4) {
                    toast("Info", "Please Enter Dependant Gender", "");
                    return false;
                }
                if (c == 5) {
                    toast("Info", "Please Select Dependant Relation", "");
                    return false;
                }
                if ($.grep(relationPush, function (elem) {
                return elem === "Father";
                }).length > 1) {
                    toast("Error", "Please Enter Valid Dependent Relation", "");
                    return false;
                }
                if ($.grep(relationPush, function (elem) {
                    return elem === "Mother";
                }).length > 1) {
                    toast("Error", "Please Enter Valid Dependent Relation", "");
                    return false;
                }
                if ($.grep(relationPush, function (elem) {
                    return elem === "Husband";
                }).length > 1) {
                    toast("Error", "Please Enter Valid Dependent Relation", "");
                    return false;
                }

                if ($.grep(relationPush, function (elem) {
                    return elem === "Wife";
                }).length > 1) {
                    toast("Error", "Please Enter Valid Dependent Relation", "");
                    return false;
                }
                return true;
            }
            function savedata() {
                if ($validation() == false) {
                    return;
                }
                var pmdata = patientmaster();
                $("#btnSave").attr('disabled', true).val("Submiting...");
                serverCall('MemberShipCardIssueEdit.aspx/savedata', { PatientData: pmdata, FamilyMemberGroupID: $('#spnFamilyMemberGroupID').text() }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $('#btnSave').attr('disabled', false).val("Save");
                        clearall();
                        toast("Success", "MemberShip Card Updated Successfully", "");
                    }
                    else {
                        toast("Error", $responseData.response, "");
                        $('#btnSave').attr('disabled', false).val("Save");
                    }
                });                               
            }
            function clearall() {
                clearme();                                            
            }
            function clearme() {
                $('#spnCardType,#spcardamount,#spnodependant,#spexpirydate,#spnCardName,#spnSavingCardType,#spnMembershipCardNo,#spnMembershipCardID').html('');
                $('#tbldependent tr').slice(1).remove();
                $('.hideControl').hide();
            }
            jQuery(function () {
                $bindSpecialCharater();

            });
            $bindSpecialCharater = function () {
                jQuery(".checkSpecialCharater").keypress(function (e) {
                    var keynum
                    var keychar
                    var numcheck
                    if (window.event) {
                        keynum = e.keyCode
                    }
                    else if (e.which) {
                        keynum = e.which
                    }
                    keychar = String.fromCharCode(keynum)
                    formatBox = document.getElementById(jQuery(this).val().id);
                    strLen = jQuery(this).val().length;
                    strVal = jQuery(this).val();
                    hasDec = false;
                    e = (e) ? e : (window.event) ? event : null;
                    if (e) {
                        var charCode = (e.charCode) ? e.charCode :
                                        ((e.keyCode) ? e.keyCode :
                                        ((e.which) ? e.which : 0));
                        if ((charCode == 45)) {
                            for (var i = 0; i < strLen; i++) {
                                hasDec = (strVal.charAt(i) == '-');
                                if (hasDec)
                                    return false;
                            }
                        }
                        if (charCode == 46) {
                            for (var i = 0; i < strLen; i++) {
                                hasDec = (strVal.charAt(i) == '.');
                                if (hasDec)
                                    return false;
                            }
                        }
                        if (charCode == 47) {
                            for (var i = 0; i < strLen; i++) {
                                hasDec = (strVal.charAt(i) == '/');
                                if (hasDec)
                                    return false;
                            }
                        }
                    }
                    //List of special characters you want to restrict || keychar == "/"
                    if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                        return false;
                    else
                        return true;
                });

            }
    </script>

</asp:Content>

