<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="Doctor_Booking.aspx.cs" Inherits="Design_Master_Doctor_Booking" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                     <b>Temp Doctor Registration<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">
            <div  class="Purchaseheader" runat="server">
                Search Criteria
            </div>
             <div class="row">
               
                <div class="col-md-2">From Date :</div>
                <div class="col-md-2">   <asp:TextBox ID="txtFromDate" runat="server"  />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                <div class="col-md-2">To Date :</div>
                <div class="col-md-2"> <asp:TextBox ID="txtToDate" runat="server" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
                 <div class="col-md-2">Centre :</div>
                 <div class="col-md-6"><asp:DropDownList ID="ddlCentre" runat="server" class="ddlCentre  chosen-select chosen-container" ></asp:DropDownList></div>
                 <div class="col-md-2"> <input type="button" id="btnSearch"  class="searchbutton" value="Search" onclick="searchDoc()" /></div>
                </div>
            </div>
              <div class="POuter_Box_Inventory" style="text-align: center;display:none;" id="div_DocOutput">
                  <div class="row">
                      <div class="col-md-24">
            <table  style="width: 100%; border-collapse:collapse" id="myTable">
                <tr >
                    <td colspan="4">
                        <div id="DocSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                                              
                    </td>
                </tr>
            </table>
                          </div>
                  </div>
</div>
<div class="POuter_Box_Inventory" style="text-align: center;">
    <div class="row">
                      <div class="col-md-24">
        <input type="button" value="Save" id="btnSave" onclick="SaveDoc()" class="searchbutton"
                            style="display: none;width:100px" />&nbsp;&nbsp;&nbsp;
    <input type="button" value="Remove" id="btnRemove" onclick="RemoveDoc()" class="searchbutton"
                            style="display: none;width:100px" />
                          </div>

    </div>
        </div>

<div id="popup_box">
    <div id="showpopupmsg" style="height:290px;overflow:scroll;"></div>    
    <img src="../../App_Images/Close.ico" id="popupBoxClose" onclick="unloadPopupBox()" style="width:30px;" />
        <div id="newdoctor" style="display:none;">
            <br />
            <br />
            Doctor Name::<asp:TextBox ID="txtnewdoctor" MaxLength="100" runat="server" Width="150px" class="checkSpecialCharater"></asp:TextBox>
            <asp:TextBox ID="txtnewDoctorID" style="display:none;" runat="server" ></asp:TextBox>
            <br />
            <br />
            Mobile No::<asp:TextBox ID="txtnewdoctormobile" runat="server" Width="150px" MaxLength="10" style="margin-left:27px;" onkeyup="showlengthTempDocMobile();"></asp:TextBox>
            <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender9" runat="server" FilterType="Numbers" TargetControlID="txtnewdoctormobile">
            </cc1:FilteredTextBoxExtender>
            <br />
            <br />
            Email::&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;<asp:TextBox ID="txtnewdoctoremail" MaxLength="70" Width="150px" runat="server"></asp:TextBox><br />
            <br />
            <br />
            <input type="button" class="savebutton" value="Save" style="width:150px;" onclick="ModifyDoctor()" />
        </div>
    </div>   

    <script type="text/javascript">
        function SaveDoc() {
            if ($(".chkSelect:checked").length == 0) {
                toast("Error",'Please Select to Register Doctor');
                return;
            }
            $("#btnRemove").attr('disabled', true);
            $("#btnSave").attr('disabled', true).val("Submitting...");
            var docData = addDoc();
            if (docData.length > 0) {

                serverCall('Doctor_Booking.aspx/saveDocData', { Data: docData }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", "Record Saved Successfully", "");
                        searchDoc();
                    }
                    else if ($responseData.status == false) {
                        toast("Error", $responseData.ErrorMsg, "");
                    }
                    else {
                        for (var j = 0; j <= saveData.length - 1; j++) {
                            $("#tb_grdSearch tr").each(function () {
                                var id = $(this).closest("tr").attr("id");
                                if (id != "Header") {
                                    var ID = $(this).closest("tr").find('#tdID').html();

                                    if (ID == saveData[j].ID) {
                                        $(this).closest("tr").css("background-color", "#FF0000");
                                        $(this).closest("tr").attr('title', saveData[j].Message);
                                    }
                                }

                            });
                        }
                    }
                    $("#btnSave").attr('disabled', false).val('Save');
                    $("#btnRemove").attr('disabled', false);
                    $modelUnBlockUI(function () { });
                });
            }
            else {
                $("#btnSave").attr('disabled', false).val('Save');
            }


        }

        function RemoveDoc() {
            if ($(".chkSelect:checked").length == 0) {
                toast("Error", "Please Select To Remove", "");
                return
            }
            $("#btnSave").attr('disabled', true);
            $("#btnRemove").attr('disabled', true).val("Submitting...");
            var docData = addDoc();
            if (confirm("Do You Want To Remove Doctor ") == false) {
                return;
            }
            if (docData.length > 0) {

                serverCall('Doctor_Booking.aspx/removeDocData', { Data: docData }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", "Record Remove Successfully", "");
                        searchDoc();
                    }
                    else {
                        toast("Error", $responseData.ErrorMsg, "");
                    }
                    $("#btnRemove").attr('disabled', false).val('Remove');
                    $("#btnSave").attr('disabled', false);
                    $modelUnBlockUI(function () { });
                });
            }
            else {
                $("#btnRemove").attr('disabled', false).val('Remove');
            }
        }
    </script>
      <script type="text/javascript">
          function getSearchData() {
              var Objdata = new Object();
              Objdata.FromDate = $("#txtFromDate").val();
              Objdata.ToDate = $("#txtToDate").val();
              Objdata.CentreID = $("#ddlCentre").val();
              return Objdata;
          }
          var DocData = "";
          function searchDoc() {
              $('#lblMsg').text('');
              var searchdata = getSearchData();
              $("#btnSearch").attr('disabled', true).val("Searching...");

              serverCall('Doctor_Booking.aspx/getDocData', { searchdata: searchdata }, function (response) {

                  DocData = JSON.parse(response);
                  if (DocData.length > 0) {
                      var output = $('#tb_DocSearch').parseTemplate(DocData);
                      $('#DocSearchOutput').html(output);
                      $('#DocSearchOutput,#btnSave,#btnRemove,#div_DocOutput').show();
                  }
                  else {
                      $('#DocSearchOutput').html();
                      $('#DocSearchOutput,#btnSave,#btnRemove,#div_DocOutput').hide();
                      toast("Error", "Record Not Found..!", "");
                  }
                  $("#btnSearch").attr('disabled', false).val("Search");
                  $modelUnBlockUI(function () { });
              });
          }
          function addDoc() {
              var data = new Array();
              $("#tb_grdSearch tr").each(function () {
                  var id = $(this).closest("tr").attr("id");
                  if (id != "Header") {
                      if ($(this).find('#chkSelectSNo').is(':checked')) {
                          var obj = new Object();
                          obj.ID = $(this).find('#tdID').html();
                          obj.Name = $(this).find('#tdDoctorName').html();
                          obj.Mobile = $(this).find('#tdMobile').html();
                          obj.CentreID = $(this).find('#tdCentreID').html();
                          obj.Email = $(this).find('#tdEmail').html();

                          data.push(obj);
                      }

                  }

              });
              return data;
          }
          function showModifyDoctor(ID, Name, Mobile, Email) {
              $('#<%=txtnewDoctorID.ClientID%>,#<%=txtnewdoctor.ClientID%>,#<%=txtnewdoctormobile.ClientID%>,#<%=txtnewdoctoremail.ClientID%>').val('');
              $('#<%=txtnewDoctorID.ClientID%>').val(ID);
              $('#<%=txtnewdoctor.ClientID%>').val(Name);
              $('#<%=txtnewdoctormobile.ClientID%>').val(Mobile);
              $('#<%=txtnewdoctoremail.ClientID%>').val(Email);
              $('#popup_box').css({ height: 'auto', top: '50%', left: '50%', margin: '-' + ($('#popup_box').height() / 2) + 'px 0 0 -' + ($('#popup_box').width() / 2) + 'px' });
              $('#popup_box').fadeIn("slow");

              $('#newdoctor,#popupBoxClose').show();
              $('#showpopupmsg').hide();
          }
          function unloadPopupBox() {    // TO Unload the Popupbox
              $('#showpopupmsg').html('');
              $('#popup_box').fadeOut("slow");
              $("#Pbody_box_inventory").css({ // this is just for style        
                  "opacity": "1"
              });
          }

          function Validation() {
              if ($('#<%=txtnewdoctor.ClientID%>').val() == "") {
                  $('#<%=txtnewdoctor.ClientID%>').css("background-color", "pink");
                  $('#<%=txtnewdoctor.ClientID%>').focus();
                  return false;
              }
              if ($('#<%=txtnewdoctormobile.ClientID%>').val() == "" || $('#<%=txtnewdoctormobile.ClientID%>').val().length != 10) {
                  $('#<%=txtnewdoctormobile.ClientID%>').css("background-color", "pink");
                  $('#<%=txtnewdoctormobile.ClientID%>').focus();
                  if ($('#<%=txtnewdoctormobile.ClientID%>').val().length != 10)
                      toast("Error", 'Incorrect Mobile Number');
                  return false;
              }
              var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
              if (!filter.test($('#<%=txtnewdoctoremail.ClientID%>').val()) && $('#<%=txtnewdoctoremail.ClientID%>').val() != "") {
                  toast("Error", 'Incorrect Email ID');
                  $('#<%=txtnewdoctoremail.ClientID%>').css("background-color", "pink");
                  $('#<%=txtnewdoctoremail.ClientID%>').focus();
                  return false;

              }
              return true;
          }

          function getModifyDoctor() {
              var ObjModify = new Object();
              ObjModify.DoctorID = $('#<%=txtnewDoctorID.ClientID%>').val();
            ObjModify.DoctorName = $('#<%=txtnewdoctor.ClientID%>').val();
            ObjModify.Mobile = $('#<%=txtnewdoctormobile.ClientID%>').val();
            ObjModify.Email = $('#<%=txtnewdoctoremail.ClientID%>').val();
            return ObjModify;
        }

        function ModifyDoctor() {
            if (Validation() == false)
                return;
            var ModifyDoc = getModifyDoctor();
            if (confirm("Do You Want To ModifyDoctor ") == false) {
                return;
            }
            $('#<%=txtnewdoctor.ClientID%>').css("background-color", "white");
              $('#<%=txtnewdoctormobile.ClientID%>').css("background-color", "white");
              $('#<%=txtnewdoctoremail.ClientID%>').css("background-color", "white");


              serverCall('Doctor_Booking.aspx/ModifyDoctor', { ModifyDoctor: ModifyDoc }, function (response) {
                  var $responseData = JSON.parse(response);
                  if ($responseData.status) {
                      unloadPopupBox();
                      toast("Success", "Record Remove Successfully", "");
                      searchDoc();
                  }
                  else {
                      toast("Error", $responseData.ErrorMsg, "");
                  }
                  $modelUnBlockUI(function () { });
              });
          }
      </script>
    <script type="text/javascript">
        function chkAll(rowID) {
            if ($(".chkAll").is(':checked'))
                $(".chkSelect").prop('checked', 'checked');
            else
                $(".chkSelect").prop('checked', false);
        }
        function chkSelect(rowID) {
            if ($(".chkSelect").length == $(".chkSelect:checked").length)
                $(".chkAll").prop("checked", "checked");
            else
                $(".chkAll").prop('checked', false);

        }
    </script>
         <script id="tb_DocSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.             
			</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Doctor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Contact No.</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none">CentreID</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Email</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;"> <input type="checkbox" class="chkAll"  onclick="chkAll(this)" /></th>         
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;"> Merge Doctor</th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;"> Edit </th>                         
		</tr>
        <#
        var dataLength=DocData.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = DocData[j];
        #>
                    <tr id="<#=j+1#>" onmouseout="hideData(this)" onmouseover="showMergeDoctor(this);">
                    <td class="GridViewLabItemStyle"><#=j+1#>
                        
                    </td>

                   
                    <td class="GridViewLabItemStyle" id="tdDoctorName" style="width:120px;"><#=objRow.DoctorName#></td>
                    <td class="GridViewLabItemStyle" id="tdID" style="width:140px;display:none"><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="tdMobile" style="width:140px;"><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle" id="tdCentreID" style="width:140px;display:none"><#=objRow.CentreID#></td>
                    <td class="GridViewLabItemStyle" id="tdEmail" style="width:140px;"><#=objRow.Email#></td>
                    <td class="GridViewLabItemStyle" id="td2" style="width:140px;">
                          <# if(objRow.MergeDoctorName==""){ #>
                         <input type="checkbox" id="chkSelectSNo"  onclick="chkSelect(this)" class="chkSelect" />
                          <# } #>
                    </td>
                    <td class="GridViewLabItemStyle" id="tdMergeDoctor" style="width:100px;"> 
                        <# if(objRow.MergeDoctorName!=""){ #>
                        <div id="MergeDoctorDiv" style="display:none;position:absolute;"> 
                             <table id="MergeDoctorDivtable">
                                 <tr>
                                     <th> This Mobile No. : <#=objRow.Mobile#> is already register with<br />
                                          Dr. <#=objRow.MergeDoctorName#> at Centre : <#=objRow.MergeDoctorCentre#>
                                     </th>
                                 </tr>
                    </table>
                           

                        </div>
                        <input type="button" id="btnMergeDoctor" class="w3-btn w3-ripple" value="&#10004;&nbsp;&nbsp;Merge Doctor"  style="cursor:pointer;" onmouseout="hideData()" onmouseover="showMergeDoctor();" onclick="mergeDoctor('<#=objRow.ID#>,<#=objRow.MergeDoctorID#>,<#=objRow.MergeDoctorName#>')" />
                         <# } #>
                    </td>
                        <td class="GridViewLabItemStyle" id="td1" style="width:140px;">         
                            <input type="button"  class="w3-btn w3-ripple" value="&#9998;&nbsp;&nbsp;Edit Doctor"  style="cursor:pointer;"  onclick="showModifyDoctor('<#=objRow.ID#>', '<#=objRow.DoctorName#>', '<#=objRow.Mobile#>', '<#=objRow.Email#>');" />                                    
                        </td>
                    </tr>

        <#}

        #>
        
     </table>

           
    </script>

    <script type="text/javascript">
        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });
        function showMergeDoctor(rowID) {
            if ($('#tb_grdSearch tr#' + rowID.id).find('#MergeDoctorDiv').text() != "") {
                $('#tb_grdSearch tr#' + rowID.id).removeAttr('title');
                $('#tb_grdSearch tr#' + rowID.id).find('#MergeDoctorDiv').show();
                $('#tb_grdSearch tr#' + rowID.id).find('#MergeDoctorDiv').css({ 'top': mouseY, 'left': mouseX }).show();
            }
        }
        function hideData(rowID) {
            $('#tb_grdSearch tr#' + rowID.id).find('#MergeDoctorDiv').hide();
        }
        function getMergeDoc(TempDocData) {
            var ObjMergeDoc = new Object();
            ObjMergeDoc.TempDocID = TempDocData.split(',')[0];
            ObjMergeDoc.MergeDoctorID = TempDocData.split(',')[1];
            ObjMergeDoc.MergeDoctorName = TempDocData.split(',')[2];
            return ObjMergeDoc;
        }
        function mergeDoctor(TempDocData) {
            var mergeDoc = getMergeDoc(TempDocData)


            serverCall('Doctor_Booking.aspx/mergeDoctor', { MergeDoctor: mergeDoc }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", "Doctor Merged SuccessFully....!", "");
                    searchDoc();
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                $modelUnBlockUI(function () { });
            });
        }

    </script>
 <style>
     #MergeDoctorDivtable {
         border-collapse: collapse;
         width: 100%;
     }

         #MergeDoctorDivtable th, #MergeDoctorDivtable td {
             text-align: left;
             padding: 8px;
         }

         #MergeDoctorDivtable tr:nth-child(even) {
             background-color: #f2f2f2;
         }

         #MergeDoctorDivtable th {
             background-color: #4CAF50;
             color: white;
         }
 </style>
    <style>
        #tb_grdSearch {
            border-collapse: collapse;
            width: 100%;
        }

            #tb_grdSearch th, #tb_grdSearch td {
                text-align: center;
                padding: 8px;
            }

            #tb_grdSearch tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            #tb_grdSearch th {
                background-color: #4CAF50;
                color: white;
            }
    </style>
     <script type="text/javascript">
         $(document).ready(function () {

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
    </script> 
    <style>
        .w3-btn, .w3-button {
            border: none;
            display: inline-block;
            padding: 8px 16px;
            vertical-align: middle;
            overflow: hidden;
            text-decoration: none;
            color: inherit;
            background-color: inherit;
            text-align: center;
            cursor: pointer;
            white-space: nowrap;
        }

            .w3-btn:hover {
                box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
            }
    </style>   
</asp:Content>

