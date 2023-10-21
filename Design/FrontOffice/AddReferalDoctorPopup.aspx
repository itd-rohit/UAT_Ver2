<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddReferalDoctorPopup.aspx.cs" Inherits="Design_FrontOffice_AddReferalDoctorPopup" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />  
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/Chosen") %>
    <title>Doctor Referal Details</title>
    <style type="text/css">
        .inputbox2 {
        }
    </style>
</head>
<body >
          <%: Scripts.Render("~/bundles/WebFormsJs") %>
     <form id="DocRefpopup" runat="server"> 
     <div id="Pbody_box_inventory" style="width: 816px" >
    <div class="POuter_Box_Inventory" style="width: 810px" >   
    <div style="text-align:center;">
    <b>REFERRING DOCTOR REGISTRATION</b></div>
     <div style="text-align:center;">
         <Ajax:ScriptManager id="ScriptManager1" runat="server"></Ajax:ScriptManager>
         <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033" ClientIDMode="Static"></asp:Label>&nbsp;</div>  
   </div>      
    <div class="POuter_Box_Inventory clsclear" style="width: 810px;">
    <div class="Purchaseheader">
        Doctor Details &nbsp;</div>
        <div class="row" style="display:none">
            <div class="col-md-4">
                Doctor Type :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="ddldoctortype" runat="server" CssClass="chosen-select" onchange="showvisit()">
                    <asp:ListItem Value="Refer Doctor" Selected="True">Refer Doctor</asp:ListItem>
                    <asp:ListItem Value="PolyClinic Doctor">PolyClinic Doctor</asp:ListItem>
                    </asp:DropDownList>
            </div>
        </div>
        <div class="row" style="display:none">
            <div class="col-md-4" style="color:Red" > 
                Doctor Code :
            </div>
            <div class="col-md-8">
                <asp:TextBox ID="txtDocCode" runat="server"  MaxLength="20" ClientIDMode="Static"
                        TabIndex="1" ></asp:TextBox>
            </div>
            
        </div>
        <div class="row">
            <div class="col-md-4" style="color:Red;" >
                Name :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="cmbTitle" runat="server" CssClass="chosen-select requiredField"  TabIndex="1"
                            ToolTip="Select Title" Width="50px">
                       
                        <asp:ListItem>Dr.</asp:ListItem>
                        <asp:ListItem>Mr.</asp:ListItem>
                         <asp:ListItem>Ms.</asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox ID="txtName" runat="server"   MaxLength="100" ClientIDMode="Static" CssClass="checkSpecialCharater requiredField"
                            TabIndex="2" Width="195px"></asp:TextBox>
            </div>
             <div class="col-md-4">
                 Clinic Name :
            </div>
            <div class="col-md-8">
                <asp:TextBox ID="txtclinicName"
                            runat="server"  MaxLength="20" TabIndex="3" ></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4">
                 Email :
            </div>
            <div class="col-md-8">
                <asp:TextBox ID="txtEmail" runat="server" ClientIDMode="Static" MaxLength="50" TabIndex="4" ></asp:TextBox>
            </div>
             <div class="col-md-4">
                 Address :
            </div>
            <div class="col-md-8">
                <asp:TextBox ID="txtAdd" runat="server"  MaxLength="20"
                        TabIndex="5"  TextMode="MultiLine"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4">
                Phone :
            </div>
            <div class="col-md-8">
                <asp:TextBox ID="txtPhone2"
                            runat="server"  MaxLength="10" TabIndex="6"></asp:TextBox>
                 <cc1:FilteredTextBoxExtender ID="ftbPhone2" runat="server" TargetControlID="txtPhone2" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
            </div>
               <div class="col-md-6"><asp:CheckBox ID="chkRefershare" runat="server"  Text="Refer Share" ClientIDMode="Static"/>
                         </div>
                <div class="col-md-6"><asp:CheckBox ID="ChkRefersharemaster" runat="server" Text="Refer Master" ClientIDMode="Static"/></div>
        </div>
        <div class="row">
            <div class="col-md-4" style="color:red">
                Mobile :
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="TxtMobileNo" runat="server" CssClass="requiredField" ClientIDMode="Static" 
                       onblur="checkduplicate()" TabIndex="7"  MaxLength="10" ></asp:TextBox>
                
            </div>
                <div class="col-md-2">
                    <asp:Label runat="server" Text="" ID="lblmblLen" ForeColor="Red" Font-Bold="true"></asp:Label>
                </div>
             <div class="col-md-4">
                 Specialization :
            </div>
            <div class="col-md-8">
                 <asp:DropDownList ID="ddlSpecial" runat="server" CssClass="chosen-select "  TabIndex="8" ClientIDMode="Static"
                            Width="190px" ></asp:DropDownList>
                                <input type="button" value="AddNew" onclick="opensplpopup()" class="searchbutton"/>
            </div>
        </div>
         <div class="row">
            <div class="col-md-4">
                 Degree :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="ddlDegree" runat="server" CssClass="chosen-select " Width="190px" ClientIDMode="Static" TabIndex="9">
                      </asp:DropDownList>
                      <input type="button" value="AddNew" onclick="showme()" class="searchbutton"/>
            </div>
             <div class="col-md-4" style="color:red">
                 State :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="ddlState" CssClass="requiredField chosen-select" runat="server" onchange="$bindCity()" TabIndex="10" ClientIDMode="Static"></asp:DropDownList>
            </div>
        </div>
         <div class="row">
            <div class="col-md-4" style="color:red">
                City :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="ddlCity" runat="server" CssClass="requiredField chosen-select" ClientIDMode="Static" TabIndex="11" onchange="$onCityChange(this.value)" >
                      </asp:DropDownList>
            </div>
             <div class="col-md-4" style="color:red">
                 Zone :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="ddlZone" runat="server" CssClass="requiredField chosen-select" onchange="$onZoneChange(this.value)" TabIndex="12" ClientIDMode="Static">
                                        </asp:DropDownList>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4" style="color:red">
                Locality :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="ddlLocality" CssClass="requiredField chosen-select" runat="server" ClientIDMode="Static" TabIndex="13">
                                        </asp:DropDownList>
            </div>
             <div class="col-md-4" >
                 PRO :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="ddlPRO" runat="server" CssClass="chosen-select"  TabIndex="12" ClientIDMode="Static">
                                        </asp:DropDownList></div>
        </div>
        <div class="row" style="text-align:center">
            <input id="btnSaveDoc" type="button" value="Save" tabindex="14" class="savebutton"/>
        </div>         
</div>
</div>        
    <asp:Panel ID="mypanel" runat="server"  style="background-color:navajowhite;border:1px solid black;display:none;" Width="300px"> 
       <div class="row"    >
           <div class="col-md-8">
               <strong>Degree :</strong> 
           </div>
           <div class="col-md-16">
               <asp:TextBox ID="txtnewdegree" runat="server"  MaxLength="200"></asp:TextBox>
               </div>
       </div>
        <div class="row" style="text-align:center">
            <input type="button" value="Save" onclick="savenewdegree()" />&nbsp;&nbsp;           
            <asp:Button ID="hideme" runat="server" Text="Close" />
        </div>
    </asp:Panel>
      <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="hideme" TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="mypanel">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button2" style="display:none;" runat="server" />
          <asp:Panel ID="Panel1" runat="server"  style="background-color:navajowhite;border:1px solid black;display:none;" Width="400px">
      <div class="row"    >
           <div class="col-md-8">
               <strong>Specialization  :</strong> 
            </div>
          <div class="col-md-16">
              <asp:TextBox ID="txtspecil" runat="server" Width="190px" MaxLength="100"></asp:TextBox>
            </div>
      </div>
     <div class="row" style="text-align:center">
         <input type="button" value="Save" onclick="savenewspecil()" />&nbsp;&nbsp;
         <asp:Button ID="Button3" runat="server" Text="Close" />
     </div>
    </asp:Panel>
           <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="Button3" TargetControlID="Button2"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1">
    </cc1:ModalPopupExtender>
    <asp:Button ID="Button1" style="display:none;" runat="server" />          
 </form>       
 <script  type="text/javascript">
     $(function () {
         $('.numbersOnly').keyup(function () {
             this.value = this.value.replace(/[^0-9\.]/g, '');
         });
     });
     $(function () {
         $('.txtonly').keyup(function () {
             this.value = this.value.replace(/[^A-Z\.\a-z\ ]/g, '');
         });
     });

     function CharTeller() {
         $("#lblmblLen").html(document.getElementById('<%=TxtMobileNo.ClientID%>').value.length);
     }
     $(function () {
         $("#TxtMobileNo").bind('keyup blur ', function () {
             var len = document.getElementById('<%=TxtMobileNo.ClientID%>').value.length;
             document.getElementById("lblmblLen").innerHTML = len;
             if (this.value.match(/[^0-9,-]/g)) {
                 this.value = this.value.replace(/[^0-9,-]/g, '');
                 document.getElementById("lblmblLen").innerHTML = "Enter Only 0-9,-";
             }
         });
     });

     $(function () {
         $("#btnSaveDoc").click(AddNewDoctor);
     });
       
 function AddNewDoctor() {
     $("#lblerrmsg").text("");
     //if (jQuery.trim($("#txtDocCode").val()) == '') {
     //    //$("#lblerrmsg").text("Please Enter Doctor Code");
     //    toast("Error", "Please Enter Doctor Code", '');
     //    $("#txtDocCode").focus();
     //    return;
     //}
     if (jQuery.trim($("#txtName").val()) == '') {
         //$("#lblerrmsg").text("Please Enter Doctor Name ");
         toast("Error", "Please Enter Doctor Name ", '');
         $("#txtName").focus();
         return;
     }
     if ($("#TxtMobileNo").val().length == 0) {
         //$("#lblerrmsg").text("Please Enter Mobile No.");
         toast("Error", "Please Enter Mobile No.", '');
         $("#TxtMobileNo").focus();
         return;
     }

     if (jQuery.trim($("#TxtMobileNo").val()) != "" && $("#TxtMobileNo").val().length < 10) {
         //$("#lblerrmsg").text("Enter a valid Mobile No.");
         toast("Error", "Enter a valid Mobile No.", '');
         $("#TxtMobileNo").focus();
         return;
     }
     if ($('#<%=txtEmail.ClientID%>').val().length > 0) {
         var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
         if (!filter.test($('#<%=txtEmail.ClientID%>').val())) {
             //$("#lblerrmsg").text('Please provide a valid email address');
             toast("Error", 'Please provide a valid email address', '');
             $('#<%=txtEmail.ClientID%>').focus();
             return;
         }
     }
     if ($("#<%=ddlState.ClientID%>").val() == "0") {
         //$("#lblerrmsg").text("Please Select State");
         toast("Error", "Please Select State", '');
         $("#ddlState").focus();
         return;
     }
     if ($("#<%=ddlCity.ClientID%>").val() == "0" || $("#<%=ddlCity.ClientID%>").val()==null ) {
         //$("#lblerrmsg").text("Please Select City");
         toast("Error", "Please Select Zone", '');
         $("#ddlCity").focus();
         return;
     }
     if ($("#<%=ddlZone.ClientID%>").val() == "0" || $("#<%=ddlZone.ClientID%>").val()==null) {
         //$("#lblerrmsg").text("Please Select Zone");
         toast("Error", "Please Select Zone", '');
         $("#ddlZone").focus();
         return;
     }
     if ($("#<%=ddlLocality.ClientID%>").val() == "0" || $("#<%=ddlLocality.ClientID%>").val()==null) {
         //$("#lblerrmsg").text("Please Select Locality");
         toast("Error", 'Please Select Locality', '');
         $("#ddlLocality").focus();
         return;
     }
     $("#btnSaveDoc").attr('disabled', 'true');
    
   
     var Specialization = "";
     if ($("#<%=ddlSpecial.ClientID%>").val() != "0")
         Specialization = $("#<%=ddlSpecial.ClientID%> option:selected").text();

     var Degree = "";
     if ($("#<%=ddlDegree.ClientID%>").val() != "0")
         Degree = $("#<%=ddlDegree.ClientID%> option:selected").text();    

     var doctype = $('#<%=ddldoctortype.ClientID%>').val();
     var visitday = "";
     var GroupID = "0";
     var $ReferShare = $("#chkRefershare").is(':checked') ? 1 : 0;
     var $ReferMaster = $("#ChkRefersharemaster").is(':checked') ? 1 : 0;
     serverCall('Services/Doctor.asmx/AddNewDoctor', { Title: $("#<%=cmbTitle.ClientID%>").val(), Name: jQuery.trim($("#<%=txtName.ClientID %>").val()), Phone1: $("#<%=txtPhone2.ClientID %>").val(), Mobile: $("#<%=TxtMobileNo.ClientID %>").val(), Street_Name: $("#<%=txtAdd.ClientID %>").val(), Specialization: Specialization, DocCode: $("#<%=txtDocCode.ClientID%>").val(), Email: $("#<%=txtEmail.ClientID%>").val(), ClinicName: $("#<%=txtclinicName.ClientID%>").val(), Degree: Degree, doctype: doctype, visitday: visitday, GroupID: GroupID, StateID: $("#<%=ddlState.ClientID%>").val(), CityID: $("#<%=ddlCity.ClientID%>").val(), ZoneID: $("#<%=ddlZone.ClientID%>").val(), LocalityID: $("#<%=ddlLocality.ClientID%>").val(), ReferShare: $ReferShare, ReferMaster: $ReferMaster, PRO: $("#<%=ddlPRO.ClientID%>").val() }, function (result) {
             var resultDate = JSON.parse(result);
             $("#btnSaveDoc").removeAttr("disabled");
             if (resultDate.status) {
                 toast("Success", "Record Saved Successfully", '');
                 clearform();
                 encrypt_Data(resultDate.response);
             }
             else {
                 toast("Error", resultDate.response, '');
             }
             $modelUnBlockUI(function () { });
     });
 };
     function clearform() {
         $('.clsclear').find('input[type="text"],select').val('');
         jQuery("#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
         $('#ddlCity,#ddlZone,#ddlLocality').chosen('destroy');
         $("#ddlDegree,#ddlState,#ddlSpecial").trigger("chosen:updated");

     }
     function checkduplicate() {
         if ($.trim($("#<%=TxtMobileNo.ClientID%>").val()) != '') {
             serverCall('Services/Doctor.asmx/checkduplicatedoctor', {mobile: $.trim($("#<%=TxtMobileNo.ClientID%>").val())  }, function (result) {
                 if (result== "0") {
                     }
                     else {
                         $("#<%=TxtMobileNo.ClientID%>").val('');
                         toast("Info","Mobile No Already Exist..!",'');
                     }
              $modelUnBlockUI(function () { });
             });
         }
     }
 </script>

    <script type="text/javascript">
        function showme() {
            $find("<%=ModalPopupExtender1.ClientID%>").show();
            $('#<%=txtnewdegree.ClientID%>').css('background-color', 'white');
            $('#<%=txtnewdegree.ClientID%>').focus();
        }
        function savenewdegree() {
            if ($('#<%=txtnewdegree.ClientID%>').val() == "") {
                $('#<%=txtnewdegree.ClientID%>').css('background-color', 'pink');
                $('#<%=txtnewdegree.ClientID%>').focus();
                return;
            }
            var dropdown = $("#ddlDegree");
            serverCall('AddReferalDoctorPopup.aspx/savenewdegree', { degree: $('#<%=txtnewdegree.ClientID%>').val() }, function (result) {    
                resultnew = jQuery.parseJSON(result);
                $find("<%=ModalPopupExtender1.ClientID%>").hide();
                if (resultnew.status) {
                    dropdown.append($("<option></option>").val(resultnew.response).html($('#<%=txtnewdegree.ClientID%>').val()));
                    $("#ddlDegree").val(resultnew.response);
                    $('#<%=txtnewdegree.ClientID%>').val('');
                }
             });
        }
        function opensplpopup() {
            $find("<%=ModalPopupExtender2.ClientID%>").show();
             $('#<%=txtspecil.ClientID%>').css('background-color', 'white');
             $('#<%=txtspecil.ClientID%>').focus();
         }
        function savenewspecil() {
            if ($('#<%=txtspecil.ClientID%>').val() == "") {
                $('#<%=txtspecil.ClientID%>').css('background-color', 'pink');
                $('#<%=txtspecil.ClientID%>').focus();
                return;
            }
            var dropdown = $("#ddlSpecial");
            serverCall('AddReferalDoctorPopup.aspx/savenewspecil', { special: $('#<%=txtspecil.ClientID%>').val() }, function (result) {    
                $find("<%=ModalPopupExtender2.ClientID%>").hide();
                resultnew = jQuery.parseJSON(result);
                if (resultnew.status) {
                    dropdown.append($("<option></option>").val($('#<%=txtspecil.ClientID%>').val()).html($('#<%=txtspecil.ClientID%>').val()));
                    $("#ddlSpecial").val($('#<%=txtspecil.ClientID%>').val());
                    $('#<%=txtspecil.ClientID%>').val('');
                }
            });
        }
        function showvisit() {
            if ($('#<%=ddldoctortype.ClientID%> option:selected').val() == "Refer Doctor") {
                $('#mmc').hide();
            }
            else {
                $('#mmc').show();
            }
        }
</script>
     <script type="text/javascript" >
         $(function () {
             var MaxLength = 200;
             $("#<% =txtAdd.ClientID %>").bind("cut copy paste", function (event) {
                 event.preventDefault();
             });
             $("#<% =txtAdd.ClientID %>").bind("keypress", function (e) {
                 // For Internet Explorer  
                 if (window.event) {
                     keynum = e.keyCode
                 }
                     // For Netscape/Firefox/Opera  
                 else if (e.which) {
                     keynum = e.which
                 }
                 keychar = String.fromCharCode(keynum)
                 if (e.keyCode == 39 || keychar == "'") {
                     return false;
                 }

                 if ($(this).val().length >= MaxLength) {

                     if (window.event)//IE
                     {
                         e.returnValue = false;
                         return false;
                     }
                     else//Firefox
                     {
                         e.preventDefault();
                         return false;
                     }

                 }
             });
         });
         </script>
   <script type="text/javascript">
       var $onStateChange = function (selectedStateID) {
           jQuery("#ddlCity,#ddlZone,#ddlLocality").find('option').remove();           
           $bindCity(function () { });
       }
       var $bindCity = function (callback) {
           var $ddlCity = $('#ddlCity');
           jQuery("#ddlCity,#ddlZone,#ddlLocality").find('option').remove();
           serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: $("#ddlState").val() }, function (response) {
               $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true });
               //callback($ddlCity.val());
           });
       }
       var $onCityChange = function (selectedCityID) {
           $('#ddlZone,#ddlLocality').chosen('destroy');
           $bindZone(selectedCityID, function () { });
       }
       var $bindZone = function (CityID, callback) {
           var $ddlZone = $('#ddlZone');
           jQuery("#ddlLocality").find('option').remove();
           serverCall('../Common/Services/CommonServices.asmx/bindZone', { CityID: CityID }, function (response) {
               $ddlZone.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ZoneID', textField: 'Zone', isSearchAble: true });
               callback($ddlZone.val());
           });
       }
       var $onZoneChange = function (selectedZoneID) {
           $bindLocality(selectedZoneID, function () { });
       }
       var $bindLocality = function (ZoneID, callback) {
           var $ddlLocality = $('#ddlLocality');
           jQuery("#ddlLocality").find('option').remove();
           serverCall('../Common/Services/CommonServices.asmx/bindLocalityByZone', { ZoneID: ZoneID }, function (response) {
               $ddlLocality.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
               callback($ddlLocality.val());
           });
       }
      
    </script>
     <script type="text/javascript">
         $(function () {
             $(".checkSpecialCharater").keypress(function (e) {
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
                 formatBox = document.getElementById($(this).val().id);
                 strLen = $(this).val().length;
                 strVal = $(this).val();
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
                 }
                 //List of special characters you want to restrict
                 if (keychar == "#" || keychar == "/" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                     return false;
                 else
                     return true;
             });
         });
         $(function () {
             var config = {
                 '.chosen-select': {},
                 '.chosen-select-deselect': { allow_single_deselect: true },
                 '.chosen-select-no-single': { disable_search_threshold: 10 },
                 '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                 '.chosen-select-width': { width: "100%" }
             }
             for (var selector in config) {
                 $(selector).chosen(config[selector]);
             }

         });

         </script>
    <script type="text/javascript">
        function encrypt_Data(doctor_ID) {
            var doctorID = "";
            serverCall('../Common/Services/CommonServices.asmx/encryptData', { ID: doctor_ID  }, function (result) {                   
              window.open('DoctorReferalCentreMapping.aspx?Doctor_ID=' + mydata + '');
              window.close();
              $modelUnBlockUI(function () { });
            });          

        }
    </script>
</body>
</html>



