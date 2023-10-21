<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TemporaryPhelebotomist.aspx.cs" Inherits="Design_HomeCollection_TemporaryPhelebotomist" %>

<!DOCTYPE html>

<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
     <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

  
 <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
  


<style>
body {
  font-family: Arial, Helvetica, sans-serif;
  background-color: black;
}

* {
  box-sizing: border-box;
}

/* Add padding to containers */
.container {
  padding: 16px;
  background-color: white;
}

/* Full-width input fields */
.txt_css {
  width: 94%;
  padding: 10px;
  margin: 0px 0 1px 0;
  display: inline-block;
  border: none;
  background: #f1f1f1;
  border-radius:8px;
  font-style: italic;
  font-size:16px;
}
    .multiselect {
          width: 94%;
         
  margin: 0px 0 10px 0;
  background: #f1f1f1;
  border-radius:8px;
   font-style: italic;
  font-size:16px;
  
    }
    .form-control {
         
  border-radius:8px;
   font-style: italic;
  font-size:16px;
    }
    .form-control {
         width: 94%;
  padding: 10px;
  margin: 0px 0 10px 0;
  display: inline-block;
  border: none;
  background: #f1f1f1;
    }
    .ms-choice {
         width: 94%;
  padding: 10px;
  margin: 0px 0 10px 0;
  display: inline-block;
  border: none;
  background: #f1f1f1;
   font-style: italic;
  font-size:16px;
    }

.txt_css:focus {
  background-color: #ddd;
  outline: none;
}

/* Overwrite default styles of hr */
hr {
  border: 1px solid #f1f1f1;
  margin-bottom: 25px;
}

/* Set a style for the submit button */
.registerbtn {
   background-color: #4CAF50;
  color: white;
  padding: 12px 20px;
  margin: 8px 0;
  margin-left:4%;
  margin-right:2%;
  border: none;
  cursor: pointer;
  width: 20%;
  opacity: 0.9;
  border-radius: 10px;
}
.OtpBtn {
  background-color: #4CAF50;
  color: white;
  padding: 12px 20px;
  margin: 8px 0;
  
  margin-right:2%;
  border: none;
  cursor: pointer;
  width: 20%;
  opacity: 0.9;
  border-radius: 10px;
}

.registerbtn:hover {
  opacity: 1;
}
.OtpBtn:hover {
  opacity: 1;
}

/* Add a blue text color to links */
a {
  color: dodgerblue;
}

/* Set a grey background color and center the text of the "sign in" section */
.signin {
  background-color: #f1f1f1;
  text-align: center;
}
    .cls_age {
        width:30%;
    }

    .row {
    margin-top:3px;
    
    }
</style>


    <script type="text/javascript">

        jQuery(function () {


            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }

            jQuery('[id*=ddlState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


            jQuery('[id*=ddlCity]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

             $('#txtName').keyup(function () {
                this.value = this.value.toUpperCase();
            });



        });

    </script>

    <script type="text/javascript">

        function bindCity() {
            var ddlCity = "";
            var StateId = $("#<%=ddlState.ClientID %>").val();
             ddlCity = $("#<%=ddlCity.ClientID %>");
            $("#<%=ddlCity.ClientID %> option").remove();

            serverCall('TemporaryPhelebotomist.aspx/bindCity',
                { StateId:  (StateId).toString()  },
                function (result) {
                    CityData = jQuery.parseJSON(result);
                    if (CityData.length > 0) {
                        for (i = 0; i < CityData.length; i++) {
                            ddlCity.append($("<option></option>").val(CityData[i].ID).html(CityData[i].City));
                        }
                        //ddlCity.bindDropDown({ defaultValue: '', data: JSON.parse(result), valueField: 'ID', textField: 'City', isSearchAble: true });
                    }
                    jQuery('[id*=ddlCity]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                })
        }
       

        function SaveData() {
            

             if (Validation() == false) {

                 return false;
             }

             jQuery('#btnSave').attr('disabled', true).val("Submitting...");


             var resultPhelebotomistMaster = PhelebotomistMaster();
           

             jQuery.ajax({
                 url: "TemporaryPhelebotomist.aspx/SavePhelebotomist",

                 data: JSON.stringify({ obj: resultPhelebotomistMaster, CityStateId: $('#<%=ddlCity.ClientID%>').val(), Otp: $('#<%=txtOtp.ClientID%>').val() }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {

                     if (result.d == "1") {
                         alert("Record Saved Successfully");

                         clearform();



                     }
                     else if (result.d == "2") {
                         alert("OTP Is Invalid");
                     }

                     else {
                         alert('Error...',"");
                     }
                     jQuery('#btnSave').attr('disabled', false).val("Save");
                 },
                 error: function (xhr, status) {
                     jQuery('#btnSave').attr('disabled', false).val("Save");
                 }
             });
        }



        function GenerateOtp() {


            
            if ($.trim($("#<%=txtMobile.ClientID%>").val()) == "") {
                alert("Please Entre Mobile.");
                $("#<%=txtMobile.ClientID%>").focus();

                return false;
            }
            jQuery('#btnOtp').attr('disabled', true).val("Sending...");


            


            jQuery.ajax({
                url: "TemporaryPhelebotomist.aspx/GenerateOTP",

                data: JSON.stringify({ MobileNo: $('#<%=txtMobile.ClientID%>').val() }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {

                     if (result.d == "1") {
                         alert("OTP Sent Successfully On Your Mobile no.");
                         leave = 300;
                         
                         $('#spn_otp').css("color","Black");
                         $('#span_expiryTimecont').css("color", "Red");

                         CounterTimer();

                         jQuery('#btnOtp').attr('disabled', false).val("Resend OTP");


                     }

                     else {

                         alert('Error...',"");
                         $('#spn_otp').css("color", "White");
                         $('#span_expiryTimecont').css("color", "White");
                       
                         jQuery('#btnOtp').attr('disabled', false).val("Generate OTP");
                     }
                    
                 },
                 error: function (xhr, status) {
                     $('#spn_otp').css("color", "White");
                     $('#span_expiryTimecont').css("color", "White");
                     jQuery('#btnOtp').attr('disabled', false).val("Generate OTP");
                 }
             });
         }


        function Validation() {



            if ($.trim($("#<%=txtName.ClientID%>").val()) == "") {
                alert("Please Entre Name.");
                $("#<%=txtName.ClientID%>").focus();

                   return false;
            }

            if ($.trim($("#<%=ddDay.ClientID%>").val()) == "0") {
                alert("Please Select Day Of Age.");
                $("#<%=ddDay.ClientID%>").focus();

                return false;
            }
            if ($.trim($("#<%=ddMonth.ClientID%>").val()) == "0") {
                alert("Please Select Moth Of Age.");
                $("#<%=ddMonth.ClientID%>").focus();

                return false;
            }
            if ($.trim($("#<%=ddYear.ClientID%>").val()) == "0") {
                alert("Please Select Year Of Age.");
                $("#<%=ddYear.ClientID%>").focus();

                return false;
            }
            if ($.trim($("#<%=txtCity.ClientID%>").val()) == "") {
                alert("Please Entre City.");
                $("#<%=txtCity.ClientID%>").focus();

                return false;
            }

               if ($.trim($("#<%=txtAddress.ClientID%>").val()) == "") {
                alert("Please Entre Address.");
                $("#<%=txtAddress.ClientID%>").focus();

                return false;
               }


           
            if ($.trim($("#<%=txtMobile.ClientID%>").val()) == "") {
                alert("Please Entre Mobile.");
                $("#<%=txtMobile.ClientID%>").focus();

                return false;
            }
            if ($.trim($("#<%=ddlDocumentType.ClientID%>").val()) == "") {
                alert("Please Select Document Type.");
                $("#<%=ddlDocumentType.ClientID%>").focus();

                return false;
            }
            if ($.trim($("#<%=txtDocumentNo.ClientID%>").val()) == "") {
                alert("Please Entre Document No.");
                $("#<%=txtDocumentNo.ClientID%>").focus();

                return false;
            }
            if ($.trim($("#<%=ddlState.ClientID%>").val()) == "") {
                alert( "Please Select Work-Area State.");
                $("#<%=ddlState.ClientID%>").focus();

                return false;
            }
            if ($.trim($("#<%=ddlCity.ClientID%>").val()) == "") {
                alert( "Please Select Work-Area City.");
                $("#<%=ddlCity.ClientID%>").focus();

                return false;
            }

            if ($.trim($("#<%=txtOtp.ClientID%>").val()) == "") {
                alert( "Please Entre OTP.");
                $("#<%=txtOtp.ClientID%>").focus();

                return false;
            }
           


        }

        function PhelebotomistMaster() {
            var objPhelebotomist = new Object();
                objPhelebotomist.PhelebotomistId = 0;
                objPhelebotomist.NAME = $('#<%=txtName.ClientID%>').val();
            objPhelebotomist.IsActive = "1";
            objPhelebotomist.Age = $('#<%=ddDay.ClientID%>').val() + '-' + $('#<%=ddMonth.ClientID%>').val() + '-' + $('#<%=ddYear.ClientID%>').val();  //'24-may-1994'; 
            objPhelebotomist.Gender = $('#<%=ddlGender.ClientID%>').val();
            objPhelebotomist.Mobile = $('#<%=txtMobile.ClientID%>').val();
            objPhelebotomist.Other_Contact = '';
            objPhelebotomist.Email = $('#<%=txtEmail.ClientID%>').val();
            objPhelebotomist.FatherName = '';
            objPhelebotomist.MotherName = '';
              
              
              
              
              
              objPhelebotomist.P_Address = $('#<%=txtAddress.ClientID%>').val();
            objPhelebotomist.P_City = $('#<%=txtCity.ClientID%>').val();
              objPhelebotomist.P_Pincode = $('#<%=txtPincode.ClientID%>').val();
              objPhelebotomist.BloodGroup = "";
              objPhelebotomist.Qualification = '';
              objPhelebotomist.Vehicle_Num = $('#<%=txtVehicleNumber.ClientID%>').val();
              objPhelebotomist.DrivingLicence = $('#<%=txtDrivingLicence.ClientID%>').val();
              objPhelebotomist.PanNo = '';
              objPhelebotomist.DucumentType = $('#<%=ddlDocumentType.ClientID%>').val();
              objPhelebotomist.DucumentNo = $('#<%=txtDocumentNo.ClientID%>').val();
              objPhelebotomist.JoiningDate = "";

              objPhelebotomist.UserName = "";
              objPhelebotomist.Password = "";

              



              return objPhelebotomist;
          }

          function clearform() {

              
            $('#<%=txtName.ClientID%>').val('');
              $('#<%=ddDay.ClientID%>').val(0);
              $('#<%=ddMonth.ClientID%>').val(0);
              $('#<%=ddYear.ClientID%>').val(0);
           
            $('#<%=ddlGender.ClientID%>').val('Male');
            $('#<%=txtMobile.ClientID%>').val('');
           
            $('#<%=txtEmail.ClientID%>').val('');
            $('#<%=txtCity.ClientID%>').val('');
            
            $('#<%=txtAddress.ClientID%>').val('');
           

            $('#<%=txtPincode.ClientID%>').val('');
           
           
            $('#<%=txtVehicleNumber.ClientID%>').val('');
            $('#<%=txtDrivingLicence.ClientID%>').val('');
            
            $('#<%=ddlDocumentType.ClientID%>').val(0);
              $('#<%=txtDocumentNo.ClientID%>').val('');
              $('#<%=txtOtp.ClientID%>').val('');
            

            $('#ddlCity option').remove();
            $('#ddlCity').multipleSelect("refresh");

            $('#<%=ddlState.ClientID%>').val('');
              $('#<%=ddlState.ClientID%>').multipleSelect('refresh');


              $('#spn_otp').css("color", "White");
              $('#span_expiryTimecont').css("color", "White");

           jQuery('#btnOtp').attr('disabled', false).val("Generate OTP");
           


            $('#btnSave').show();
           

        }


        $(document).ready(function () {
            //called when key is pressed in textbox
            $('#<%=txtMobile.ClientID%>').keypress(function (e) {
                //if the letter is not digit then display error and don't type anything
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    //display error message
                   
                    return false;
                }
            });

            $('#<%=txtPincode.ClientID%>').keypress(function (e) {
                //if the letter is not digit then display error and don't type anything
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    //display error message

                    return false;
                }
            });

        
        });


    </script>
    <script type="text/javascript">
        var intv = setInterval(CounterTimer, 1000);
        var leave = 0;
        function CounterTimer() {
           
            if (leave != "") {
                var day = Math.floor(leave / (60 * 60 * 24))
                var hour = Math.floor(leave / 3600) - (day * 24)
                var minute = Math.floor(leave / 60) - (day * 24 * 60) - (hour * 60)
                var second = Math.floor(leave) - (day * 24 * 60 * 60) - (hour * 60 * 60) - (minute * 60)

                hour = hour < 10 ? "0" + hour : hour;
                minute = minute < 10 ? "0" + minute : minute;
                second = second < 10 ? "0" + second : second;

                var remain = minute + ":" + second;
                leave = leave - 1;
               
                $('#span_expiryTimecont').html(remain);
                
            }
        }
</script>

</head>
<body style="background-color:#dcdcdc">

<form runat="server" >
  <div class="container" style="">
    <h1 style="text-align:center">Phelebotomist Authentication</h1>
    
    <hr>
      <div class="row">
       <div class="col-md-6">
    <label for="Name"><b>Name<b style="color:red">*</b></b></label>
    <input type="text" class="txt_css" runat="server" id="txtName" tabindex="1"  name="Name" >
</div>
      <div class="col-md-6">
    <label for="text" style="width:69%"><b>Age<b style="color:red">*</b></b></label>
        
               <asp:DropDownList ID="ddDay" TabIndex="3" style=" width:31%;"  runat="server" class="form-control" ToolTip="Select Day" >
                   <asp:ListItem Value="0">Day</asp:ListItem>
                   <asp:ListItem Value="01">01</asp:ListItem>
                   <asp:ListItem Value="02">02</asp:ListItem>
                   <asp:ListItem Value="03">03</asp:ListItem>
                   <asp:ListItem Value="04">04</asp:ListItem>
                   <asp:ListItem Value="05">05</asp:ListItem>
                   <asp:ListItem Value="06">06</asp:ListItem>
                   <asp:ListItem Value="07">07</asp:ListItem>
                   <asp:ListItem Value="08">08</asp:ListItem>
                   <asp:ListItem Value="09">09</asp:ListItem>
                   <asp:ListItem Value="10">10</asp:ListItem>
                   <asp:ListItem Value="11">11</asp:ListItem>
                   <asp:ListItem Value="12">12</asp:ListItem>
                   <asp:ListItem Value="13">13</asp:ListItem>
                   <asp:ListItem Value="14">14</asp:ListItem>
                   <asp:ListItem Value="15">15</asp:ListItem>
                   <asp:ListItem Value="16">16</asp:ListItem>
                   <asp:ListItem Value="17">17</asp:ListItem>
                   <asp:ListItem Value="18">18</asp:ListItem>
                   <asp:ListItem Value="19">19</asp:ListItem>
                   <asp:ListItem Value="20">20</asp:ListItem>
                   <asp:ListItem Value="21">21</asp:ListItem>
                   <asp:ListItem Value="22">22</asp:ListItem>
                   <asp:ListItem Value="23">23</asp:ListItem>
                   <asp:ListItem Value="24">24</asp:ListItem>
                   <asp:ListItem Value="25">25</asp:ListItem>
                   <asp:ListItem Value="26">26</asp:ListItem>
                   <asp:ListItem Value="27">27</asp:ListItem>
                   <asp:ListItem Value="28">28</asp:ListItem>
                   <asp:ListItem Value="29">29</asp:ListItem>
                   <asp:ListItem Value="30">30</asp:ListItem>
                   <asp:ListItem Value="31">31</asp:ListItem>
                          </asp:DropDownList>
       
           <asp:DropDownList ID="ddMonth" TabIndex="3" style=" width:31%;"  runat="server" class="form-control" ToolTip="Select Month" >
                   <asp:ListItem Value="0">Month</asp:ListItem>
                   <asp:ListItem Value="Jan">Jan</asp:ListItem>
                   <asp:ListItem Value="Feb">Feb</asp:ListItem>
                   <asp:ListItem Value="Mar">Mar</asp:ListItem>
                   <asp:ListItem Value="Apr">Apr</asp:ListItem>
                   <asp:ListItem Value="May">May</asp:ListItem>
                   <asp:ListItem Value="May">June</asp:ListItem>
                   <asp:ListItem Value="July">July</asp:ListItem>
                   <asp:ListItem Value="Aug">Aug</asp:ListItem>
                   <asp:ListItem Value="Sept">Sept</asp:ListItem>
                   <asp:ListItem Value="Oct">Oct</asp:ListItem>
                   <asp:ListItem Value="Nov">Nov</asp:ListItem>
                   <asp:ListItem Value="Des">Des</asp:ListItem>
                  
                          </asp:DropDownList>

           <asp:DropDownList ID="ddYear" TabIndex="3" style=" width:31%;"  runat="server" class="form-control" ToolTip="Select Day" >
                   <asp:ListItem Value="0">Year</asp:ListItem>
                   <asp:ListItem Value="1970">1970</asp:ListItem>
                   <asp:ListItem Value="1971">1971</asp:ListItem>
                   <asp:ListItem Value="1972">1972</asp:ListItem>
                   <asp:ListItem Value="1973">1973</asp:ListItem>
                   <asp:ListItem Value="1974">1974</asp:ListItem>
                   <asp:ListItem Value="1975">1975</asp:ListItem>
                   <asp:ListItem Value="1976">1976</asp:ListItem>
                   <asp:ListItem Value="1977">1977</asp:ListItem>
                   <asp:ListItem Value="1978">1978</asp:ListItem>
                   <asp:ListItem Value="1979">1979</asp:ListItem>
                   <asp:ListItem Value="1980">1980</asp:ListItem>
                   <asp:ListItem Value="1981">1981</asp:ListItem>
                   <asp:ListItem Value="1982">1982</asp:ListItem>
                   <asp:ListItem Value="1983">1983</asp:ListItem>
                   <asp:ListItem Value="1984">1984</asp:ListItem>
                   <asp:ListItem Value="1985">1985</asp:ListItem>
                   <asp:ListItem Value="1986">1986</asp:ListItem>
                   <asp:ListItem Value="1987">1987</asp:ListItem>
                   <asp:ListItem Value="1988">1988</asp:ListItem>
                   <asp:ListItem Value="1989">1989</asp:ListItem>
                   <asp:ListItem Value="1990">1990</asp:ListItem>
                   <asp:ListItem Value="1991">1991</asp:ListItem>
                   <asp:ListItem Value="1992">1992</asp:ListItem>
                   <asp:ListItem Value="1993">1993</asp:ListItem>
                   <asp:ListItem Value="1994">1994</asp:ListItem>
                   <asp:ListItem Value="1995">1995</asp:ListItem>
                   <asp:ListItem Value="1996">1996</asp:ListItem>
                   <asp:ListItem Value="1997">1997</asp:ListItem>
                   <asp:ListItem Value="1998">1998</asp:ListItem>
                   <asp:ListItem Value="1999">1999</asp:ListItem>
                   <asp:ListItem Value="2000">2000</asp:ListItem>
                   <asp:ListItem Value="2001">2001</asp:ListItem>
                   <asp:ListItem Value="2002">2002</asp:ListItem>
                   <asp:ListItem Value="2003">2003</asp:ListItem>
                   <asp:ListItem Value="2004">2004</asp:ListItem>
                   <asp:ListItem Value="2005">2005</asp:ListItem>
                          </asp:DropDownList>
          
         </div>
          
          </div>

          <div class="row">
      <div class="col-md-6">
    <label for="Gender"><b>Gender<b style="color:red">*</b></b></label> 
           <asp:DropDownList ID="ddlGender" TabIndex="3"  runat="server" class="form-control" ToolTip="Gender" >
                           <asp:ListItem Value="Male"></asp:ListItem>
                           <asp:ListItem Value="Female"></asp:ListItem></asp:DropDownList>
    
          </div> 
              <div class="col-md-6">
    <label for="Name"><b>City<b style="color:red">*</b></b></label>
    <input type="text" class="txt_css" runat="server" id="txtCity" tabindex="1" name="txtCity" >
</div>
              </div>
        <div class="row">
      <div class="col-md-6">
    <label for="Email"><b>Address<b style="color:red">*</b></b></label>
      
    <input type="text" class="txt_css" runat="server" id="txtAddress" name="txtAddress" >
          </div> <div class="col-md-6">
    <label for="Name"><b>Pincode</b></label>


    <input type="text" class="txt_css" runat="server" id="txtPincode" maxlength="6"  name="txtPincode" >
</div>
              </div>

         <div class="row">
      <div class="col-md-6">
    <label for="Email"><b>Mobile<b style="color:red">*</b></b></label>
      
    <input type="text" class="txt_css"  runat="server" maxlength="10" id="txtMobile" name="txtMobile" >
          </div> <div class="col-md-6">
    <label for="Name"><b>Email</b></label>
    <input type="text" class="txt_css" runat="server" id="txtEmail"  name="txtEmail" >
</div>
              </div>

 
    

      <div class="row">
      <div class="col-md-6">
    <label for="Email"><b>Document Type<b style="color:red">*</b></b></label>
      
       <asp:DropDownList ID="ddlDocumentType" class="form-control" runat="server" TabIndex="19" ToolTip="Select Document Type" >
                    <asp:ListItem Text="-Select Document-" Value=""></asp:ListItem>
                             <asp:ListItem Value="PAN No"></asp:ListItem>
                           <asp:ListItem Value="Aadhar Card No"></asp:ListItem>
                           <asp:ListItem Value="Vehicle No"></asp:ListItem>
                            <asp:ListItem Value="Driving Licence No"></asp:ListItem>
                             <asp:ListItem Value="Passport No"></asp:ListItem>
                        </asp:DropDownList>
          </div> <div class="col-md-6">
    <label for="Name"><b>Document No<b style="color:red">*</b></b></label>
    <input type="text" class="txt_css" runat="server" id="txtDocumentNo"  name="Pincode" >
</div>
              </div>

      <div class="row">
      <div class="col-md-6">
    <label for="Email"><b>Work-Area State<b style="color:red">*</b></b></label>
      
<asp:ListBox ID="ddlState" CssClass="multiselect" SelectionMode="Multiple" runat="server" onchange="bindCity();" ClientIDMode="Static" ></asp:ListBox>
          </div> <div class="col-md-6">
    <label for="Name"><b>Work-Area City<b style="color:red">*</b></b></label>
      <asp:ListBox ID="ddlCity"  CssClass="multiselect" SelectionMode="Multiple"  runat="server" ClientIDMode="Static" ></asp:ListBox>
</div>
              </div>
      <div class="row">
      <div class="col-md-6">
    <label for="Email"><b>Vehicle No</b></label>
      
  <input type="text" class="txt_css" runat="server" id="txtVehicleNumber"  name="txtVehicleNumber" >
          </div> <div class="col-md-6">
    <label for="Name"><b>Driving License No</b></label>
    <input type="text" class="txt_css" runat="server" id="txtDrivingLicence" name="txtDrivingLicence" >
</div>
              </div>

          


      <div class="row">
          <div class="col-md-12">
               
              <input type="button" style="width:21%" class="OtpBtn" id="btnOtp" onclick="GenerateOtp();" value="Generate OTP"/>
      <input type="text" class="txt_css" runat="server" id="txtOtp" placeholder="OTP" style="width:14%;" name="OTP" >
              <span id="spn_otp" style="font-weight:bold;color:white; font-size: 9px; " >OTP Expired in </span>
              <span id="span_expiryTimecont" style="font-weight:bold;color:white; " >00:00</span>
                 
              
              <input type="button"  class="registerbtn" id="btnSave" onclick="SaveData();" style="position:absolute" value="Save"/>
      
          </div>
              </div>
    
  </div>
  

</form>

</body>
</html>
