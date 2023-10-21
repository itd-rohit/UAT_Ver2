<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Manage_isNabl.aspx.cs" Inherits="Design_Investigation_Manage_isNabl" Title="Untitled Page" %>
<%@ Register Src="~/Design/UserControl/CentreLoadType.ascx" TagPrefix="uc1" TagName="CentreLoadType" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
     <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
        <%: Scripts.Render("~/bundles/Chosen") %>
 <%--Search--%>   
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
          $('.chosen-container').css('width', '230px');
      });
      var PatientData = "";
      function Search() {
          $('#IsNable').val('0');
          $.ajax({

              url: "../Lab/Services/ItemMaster.asmx/GetNablInvestigations",
              data: '{ CentreId: "' + $("#ddlCentre").val() + '",CategoryId:"' + $("#<%=ddlCategory.ClientID %>").val() + '",SubCategoryId: "' + $("#<%=ddlSubCategory.ClientID %>").val() + '"}', // parameter map
              type: "POST", // data has to be Posted    	        
              contentType: "application/json; charset=utf-8",
              timeout: 120000,
              dataType: "json",
              success: function (result) {

                  PatientData = $.parseJSON(result.d);
                  if (PatientData.length != 0) {
                      $("#btnSave").show();

                  }
                  else
                      $("#btnSave").hide();

                  var output = $('#tb_InvestigationItems').parseTemplate(PatientData);

                  $('#div_InvestigationItems').html(output);



                  //      $('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
                  if ($("#<%=ddlSubCategory.ClientID %>").val() == 'All') {
                      $('#tb_grdLabSearch tr').hide();
                      $("#chkheader").hide();
                  }

                  tabfunc();
              },
              error: function (xhr, status) {
                  alert("Error ");

                  window.status = status + "\r\n" + xhr.responseText;
              }
          });

      }



      function Getsubcategory() {

          $("#<%=ddlSubCategory.ClientID %> option").remove();
          var ddlSubCategory = $("#<%=ddlSubCategory.ClientID %>");
          ddlSubCategory.attr("disabled", true);
          $.ajax({

              url: "../Lab/Services/ItemMaster.asmx/Getsubcategory",
              data: '{ CategoryId: "' + $("#<%=ddlCategory.ClientID %>").val() + '"}', // parameter map
              type: "POST", // data has to be Posted    	        
              contentType: "application/json; charset=utf-8",
              timeout: 120000,
              dataType: "json",
              success: function (result) {

                  PatientData = $.parseJSON(result.d);
                  if (PatientData.length == 0) {
                      ddlSubCategory.append($("<option></option>").val("0").html("---No Data Found---"));
                  }
                  else {
                      for (i = 0; i < PatientData.length; i++) {
                          ddlSubCategory.append($("<option></option>").val(PatientData[i].SubcategoryID).html(PatientData[i].Name));
                      }
                  }
                  ddlSubCategory.append($("<option></option>").val("All").html("All"));

                  ddlSubCategory.attr("disabled", false);

                  Search();
              },
              error: function (xhr, status) {
                  alert("Error ");
                  ddlSubCategory.attr("disabled", false);
                  window.status = status + "\r\n" + xhr.responseText;
              }
          });



      };




   </script>
   <%--TableFunctions--%>
 <script type="text/javascript">
     function tabfunc() {

         $("#chkheader").click(function () {
             //$("#tb_grdLabSearch tr").find("#chk").attr("checked",$(this).attr("checked"));
             if ($('#chkheader').is(':checked')) { $('input[type="checkbox"]').prop('checked', true); }
             else { $('input[type="checkbox"]').prop('checked', false); }
         });



     }

 </script>  
 <script type="text/javascript">
     $(document).ready(function () {

         Search();
     });

 </script>
 <%--Filtering--%>
 <script type="text/javascript">
     $(document).ready(function () {
         $("#txtTestname").keyup(function () {
             var val = $(this).val();
             var len = $(this).val().length;

             if (val != "" || ($("#<%=ddlSubCategory.ClientID %>").val() == 'All'))
                 $("#chkheader").hide();
             else
                 $("#chkheader").show();

             $("#tb_grdLabSearch tr").hide();
             $("#tb_grdLabSearch tr:first").show();

             var searchtype = $("#<%=rblsearchtype.ClientID%>").find('input[checked]').val();

             if (searchtype == "0") {

                 $("#tb_grdLabSearch tr").find("td:eq(" + 2 + ") ").filter(function () {
                     if (val == "" && ($("#<%=ddlSubCategory.ClientID %>").val() == 'All')) {
                         return $(this).parent('tr').find(':checkbox').attr('checked');
                     }
                     else {
                         if ($(this).text().substring(0, len).toLowerCase() == val.toLowerCase() || $(this).parent('tr').find(':checkbox').attr('checked'))
                             return $(this);
                     }

                 }).parent('tr').show();

             }
             else {
                 $("#tb_grdLabSearch tr").find("td:eq(" + 2 + ") ").filter(function () {
                     if (val == "" && ($("#<%=ddlSubCategory.ClientID %>").val() == 'All')) {
                         return $(this).parent('tr').find(':checkbox').attr('checked');
                     }
                     else {
                         if ($(this).text().toLowerCase().match(val.toLowerCase()) || $(this).parent('tr').find(':checkbox').attr('checked'))
                             return $(this);
                     }

                 }).parent('tr').show();
             }



         });
     });
    </script>
        <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <%--durga msg changes--%>
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
   <div id="body_box_inventory" style="width: 1285px; height: 630px;" >
    <div class="Outer_Box_Inventory" style="width: 1275px; " >
    <div class="content">
    <div style="text-align:center;">
    <b>Manage Delivery Days</b></div>
     <br />
     <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
   </div>
   </div>
   <div class="Outer_Box_Inventory" style="width: 1280px;" >
    <div class="Purchaseheader">Search criteria</div>
                 <div>
                <uc1:CentreLoadType runat="server" ID="CentreLoadType" />
                 </div>
                  <div class="Outer_Box_Inventory" style="width: 1275px;border:none; "  > 
                    <table id="TBMain" border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 28px;">
                       <tr>
                            <td align="right" style="width: 130px; text-align: right;font-weight:bold;">
                                Centre:&nbsp;</td>
                            <td align="left" style="width: 20px; text-align: left">
                                <asp:DropDownList ID="ddlCentre" class="ddlCentre chosen-select chosen-container" runat="server" ClientIDMode="Static" onchange="Search();">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 70px; text-align: right;font-weight:bold;">
                               Category:&nbsp;
                            </td>
                            <td style="width: 20px;">
                               <asp:DropDownList ID="ddlCategory" runat="server" onchange="Getsubcategory()" CssClass="ItDoseDropdownbox"
                                    Width="229px" > </asp:DropDownList></td>
                            <td style="width: 70px; text-align: right;font-weight:bold;">
                                SubCategory :&nbsp; 
                            </td>
                            <td style="width: 20px; text-align: left">
                             <asp:DropDownList ID="ddlSubCategory" runat="server" onchange="Search()" CssClass="ItDoseDropdownbox"
                                    Width="228px" > </asp:DropDownList>                                  
                            </td>
                           <td></td><td></td>
                                                </tr>
                            <tr> 
                            <td style="width: 50px; text-align: right;font-weight:bold;">
                               Test Name:&nbsp;
                            </td>
                            <td style="width: 20px; text-align: left">    
                             <input id="txtTestname" type="text" style="width: 222px"  class="1"/>                          </td>
                           <td style="width: 12%; height: 24px;" align="right">
                                Search By Name:&nbsp;
                                
                            </td>
                            <td style="width: 21%; height: 24px;" align="left" valign="middle">
                                <asp:RadioButtonList ID="rblsearchtype" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True" Value="0">By First Name</asp:ListItem>
                                    <asp:ListItem Value="1">In Between</asp:ListItem>
                                </asp:RadioButtonList></td>
                        </tr>
                    </table> 
                          <table><tr>
           <td style="font-weight:bold;text-align: right;width:130px;">Upload Logo :&nbsp;</td>
           <td>
               <select id="IsNable" onchange="GetLogo();">
                   <option value="0">--select--</option>
                   <option value="1">NABL</option>
                   <option value="2">CAP</option>
                   <option value="3">NABH</option>
               </select>&nbsp;<input type="file" id="imgInp" />
               <input type="button" value="Upload" id="btnlogosave" onclick="UploadLogo();" />
           </td>
                              <td><span id="spnDefaultLogo" style="color:red;font-weight:bold;cursor:pointer;display:none;">View Logo</span></td>
                                <td  style="text-align:left;width:24%">
                            <div>
                                <span id="spanLogo" style="position: absolute; display: none;">
                                    <img id="logoshow" alt=""/>
                                </span>                              
                            </div>
                        </td>
              </tr></table>
        </div>
        <div class="Outer_Box_Inventory" style="width: 1275px; text-align:center"  >
        <input id="btnSearch" type="button" value="Search"  onclick="Search();" class="ItDoseButton" style="width:60px; display:none;"   />
        </div>
       <div class="Outer_Box_Inventory" style="width: 1275px; "  > 
        <div id="div_InvestigationItems"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;">
                
            </div>
        </div>
        
        </div>
        
        <div class="Outer_Box_Inventory" style="width: 1275px; text-align:center"  >
        <input id="btnSave" type="button" value="Save"  onclick="save();" class="ItDoseButton" style="width:60px; display:none;"   />
        </div>
        
        
      
   </div>
   
      <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Sub category</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:350px;">DayType</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> <input id="chkheader" type="checkbox"  /></th>
	       

</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=objRow.SubCategoryID#>|<#=objRow.Type_ID#>" >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="SubCategoryID"  class="GridViewLabItemStyle"><#=objRow.DeptName#></td>
<td id="InvName" class="GridViewLabItemStyle" Style="width:200px"><#=objRow.InvName#></td>
<td id="isNABL" class="GridViewLabItemStyle" Style="width:650px">
<input id="rdNA"  type="radio" name="radio<#=j+1#>" value="0"  style="cursor:pointer;" <#if(objRow.isNABL=="0"){#>checked="checked"<#}#>/>NA &nbsp;
<input id="rdNABH" type="radio" name="radio<#=j+1#>" value="3" text="NABH" style="cursor:pointer;" <#if(objRow.isNABL=="3"){#>checked="checked"<#}#>/>NABH &nbsp;
<input id="rdNABL" type="radio" name="radio<#=j+1#>" value="1" style="cursor:pointer;" <#if(objRow.isNABL=="1"){#>checked="checked"<#}#>/>NABL &nbsp;
<input id="Radio1" type="radio" name="radio<#=j+1#>" value="2" text="CAP" style="cursor:pointer;" <#if(objRow.isNABL=="2"){#>checked="checked"<#}#>/> CAP &nbsp;
<input id="rdCAP" type="radio" name="radio<#=j+1#>" value="5" text="NABL+CAP" style="cursor:pointer;" <#if(objRow.isNABL=="5"){#>checked="checked"<#}#>/> NABL+CAP &nbsp;    
<input id="rdNABLH" type="radio" name="radio<#=j+1#>" value="4" text="NABH+NABL" style="cursor:pointer;" <#if(objRow.isNABL=="4"){#>checked="checked"<#}#>/>NABH+NABL &nbsp;
<input id="Radio3" type="radio" name="radio<#=j+1#>" value="7" text="NABH+CAP" style="cursor:pointer;" <#if(objRow.isNABL=="7"){#>checked="checked"<#}#>/>NABH+CAP &nbsp;
<input id="Radio2" type="radio" name="radio<#=j+1#>" value="6" text="NABH+NABL+CAP" style="cursor:pointer;" <#if(objRow.isNABL=="6"){#>checked="checked"<#}#>/>NABH+NABL+CAP &nbsp;
</td>

<td class="GridViewLabItemStyle" style="width:10px;"><input id="chk" type="checkbox" /></td>

</tr>

<#}#>

     </table>    
    </script>
    
   <%--Saving--%> 
     <script type="text/javascript">
         $(function () {
             $('[id*=bindCentre]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });

             $("#spnDefaultLogo").mouseover(function () {
                 $("#spanLogo").show();
             });
             $("#spnDefaultLogo").mouseout(function () {
                 $("#spanLogo").hide();
             });
         });
         function GetLogo() {
             if ($('#IsNable').val() == "0") {
                 showerrormsg("Please select logo type");
                 $('#spnDefaultLogo').hide();
                 return false;
             }
             if ($('#ddlCentre').val() == "" || $('#ddlCentre').val() == null) {
                 showerrormsg("Please select centre");
                 $('#spnDefaultLogo').hide();
                 return false;
             }
             jQuery.ajax({
                 url: "Manage_isNabl.aspx/getLogo",
                 data: '{ CentreID: "' + $('#ddlCentre').val() + '",IsNable:"' + $('#IsNable').val() + '"}',
                 type: "POST",
                 timeout: 120000,
                 async: false,
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 success: function (result) {
                     CentreLoadListData = jQuery.parseJSON(result.d);
                     if (CentreLoadListData.length > 0) {
                         $('#spnDefaultLogo').show();
                         $('#logoshow').attr('src', "");
                         if ($('#IsNable').val() == "1") {
                             if (CentreLoadListData[0].NablLogoPath != "") {
                                 $('#logoshow').attr('src', "../../App_Images" + CentreLoadListData[0].NablLogoPath);
                             }
                             else {
                                 $('#spnDefaultLogo').hide();
                             }
                         }
                         if ($('#IsNable').val() == "2") {
                             if (CentreLoadListData[0].CapLogoPath) {
                                 $('#logoshow').attr('src', "../../App_Images" + CentreLoadListData[0].CapLogoPath);
                             }
                             else {
                                 $('#spnDefaultLogo').hide();
                             }
                         }
                     }
                     else {
                         $('#spnDefaultLogo').hide();
                     }
                 },
                 error: function (xhr, status) {
                     alert("Error ");
                 }
             });
         }
         function UploadLogo() {
             var file = $("#imgInp").get(0).files[0];
             if (file == undefined) {
                 showerrormsg("Please select logo");
                 return false;
             }
             if ($('#IsNable').val() == "0") {
                 showerrormsg("Please select logo type");
                 return false;
             }
             if ($('#ddlCentre').val() == "" || $('#ddlCentre').val() == null) {
                 showerrormsg("Please select centre");
                 return false;
             }
             var filextns = file.name.split('.').pop();
             if (filextns == "txt" || filextns == "EXE" || filextns == "zip" || filextns == "xml" || filextns == "docs" || filextns == "doc" || filextns == "xlsm" || filextns == "xlsx" || filextns == "Pdf") {
                 showerrormsg("File type only Png, Jpg,gif formate!");
                 return false;
             }
             $('#btnlogosave').attr('disabled', true).val("Uploading");
             var r = new FileReader();
             r.onload = function () {
                 var binimage = r.result;
                 $.ajax({
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     url: "Manage_isNabl.aspx/UploadLogo",
                     data: "{ 'Based64BinaryString' :'" + binimage + "','IsNable':'" + $('#IsNable').val() + "','CentreID':'" + $('#ddlCentre').val() + "'}",
                     dataType: "json",
                     success: function (data) {
                         $('#loader').hide();
                         $('#btnlogosave').attr('disabled', false).val("Upload");
                         if (data.d == "1") {
                             showmsg("Logo uploaded");
                             $('#IsNable').val("0");
                             $('#imgInp').val("");
                         }
                         else {
                             showerrormsg("Logo not uploaded please try again");
                         }
                     },
                     error: function (result) {
                         showerrormsg("Some error please try again!");
                     }
                 });
             };
             r.readAsDataURL(file);
         }
         function bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID, CityID, TypeID) {
             $('#IsNable').val('0');
             if (TypeID != "") {
                 jQuery.ajax({
                     url: "Manage_isNabl.aspx/bindCentreLoadType",
                     data: '{ BusinessZoneID: "' + BusinessZoneID + '",StateID: "' + StateID + '",CityID: "' + CityID + '",TypeID:"' + TypeID + '"}',
                     type: "POST",
                     timeout: 120000,
                     async: false,
                     contentType: "application/json; charset=utf-8",
                     dataType: "json",
                     success: function (result) {
                         CentreLoadListData = jQuery.parseJSON(result.d);
                         if (CentreLoadListData.length > 0) {
                             for (i = 0; i < CentreLoadListData.length; i++) {
                                 $("#ddlCentre").append(jQuery("<option></option>").val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                             }
                         }
                         else {
                             $("#ddlCentre").append($("<option></option>").val("0").html("---No Data Found---"));

                         }
                         $('#ddlCentre').trigger('chosen:updated');
                         $('.chosen-container').css('width', '230px');
                     },
                     error: function (xhr, status) {
                         alert("Error ");
                     }
                 });
             }
         }
         function save() {
             $("#btnSave").attr('disabled', true);
             // Itemdata= 0)SubCategoryID|1)InvID|2) 
             var ItemData = "";
             $("#tb_grdLabSearch tr").find('#chk').filter(':checked').each(function () {
                 var $rowid = $(this).closest('tr');
                 ItemData += $rowid.attr("ID") + "|" + $rowid.find("#isNABL").find(":radio:checked").val() + "#";
             });

             if (ItemData == "") {
                 alert("Kindly select an Investigation ");
                 $("#btnSave").attr('disabled', false);
                 return;
             }
             var CentreID = $("#ddlCentre").val();

             if (CentreID == "" || CentreID == null) {
                 alert("Kindly select Centre ");
                 $("#btnSave").attr('disabled', false);
                 return;
             }
             $.ajax({

                 url: "../Lab/Services/ItemMaster.asmx/Save_isNABLInv",
                 data: '{CentreId: "' + CentreID + '",CategoryId:"' + $("#<%=ddlCategory.ClientID %>").val() + '",SubCategoryId: "' + $("#<%=ddlSubCategory.ClientID %>").val() + '", ItemData: "' + ItemData + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "1") {
                         //$("#tb_grdLabSearch tr").remove();
                         $('input[type="checkbox"]').prop('checked', false);
                         alert("Record Saved Successfully");
                     }
                     else {
                         alert("Record Not Saved");
                     }

                     $("#btnSave").attr('disabled', false);
                 },
                 error: function (xhr, status) {
                     alert("Error has occured Record Not saved ");
                     $("#btnSave").attr('disabled', false);
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }
         function showerrormsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', 'red');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function showmsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', '#04b076');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
 </script>

</asp:Content>

