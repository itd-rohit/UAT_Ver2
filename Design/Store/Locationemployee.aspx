<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Locationemployee.aspx.cs" Inherits="Design_Store_Locationemployee" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 


        <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

     
     <div id="Pbody_box_inventory" style="width:1304px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>Location Details</b>  
                        </td>
                    </tr>
                    </table>
                </div>
              </div>
             <div id="makerdiv" >

             <div class="POuter_Box_Inventory" style="width:1300px;">
               <div class="content">
                  <div class="Purchaseheader">
                     Location Details</div>

                   <table width="99%" >
                      
                       <tr>
                           <td> State :</td>
                           <td>
                               <asp:DropDownList ID="ddlstate" runat="server" Width="300px" onchange="bindcentertype()"></asp:DropDownList>
                               
                           </td>

                           <td>
                               Centre Type :</td>
                           <td>
                                <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server" ClientIDMode="Static" onchange="bindCentre()"></asp:ListBox>
                           </td>

                           <td>Centre :</td>
                           <td>

                                                <asp:ListBox ID="lstCentre" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server" ClientIDMode="Static" onchange="bindlocation();"></asp:ListBox>
                           </td>

                           
                       </tr>
                       <tr>
                            <td> Location :</td>
                           <td>

                                                <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple" Width="300px" runat="server" ClientIDMode="Static" onchange="SearchRecords();"></asp:ListBox>
                           </td>
                          </tr>
                       
                       
                       
                       
                       
                       </table>
                   </div>
                 </div>



                   <div class="POuter_Box_Inventory" style="width:1300px;">
               <div class="content">
                  <div class="Purchaseheader">
                     Account Details</div>

                   <table width="99%" >
                      
                       <tr>
                           <td> Center :</td>
                           <td>
                               <asp:DropDownList ID="ddlcenter" runat="server" Width="300px"></asp:DropDownList>
                               
                           </td>

                           <td>
                               Employee :</td>
                           <td>
                                 <asp:DropDownList ID="ddlemployee" runat="server" Width="300px"></asp:DropDownList>
                           </td>

                           <td>  &nbsp;</td>
                           <td>

                                        <input type="button" value="Save" class="searchbutton" onclick="existingdata();" id="btnsave" />
                           </td>

                           
                       </tr>
                      
                       
                       
                       
                       </table>



                     


                   </div>
                 </div>




                   <div class="POuter_Box_Inventory" style="width:1300px;">
               <div class="content">
                  <div class="Purchaseheader">
                     Added Item</div>
                   <div style="width:100%;max-height:200px;overflow:auto;">
                   <table id="tblQuotation" style="border-collapse:collapse">

                                     <tr id="trquuheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle">Location id</td>
                                           <td class="GridViewHeaderStyle">Location Name</td>
                                        <td class="GridViewHeaderStyle">center id</td>
                                          <td class="GridViewHeaderStyle">center Name</td>
                                        <td class="GridViewHeaderStyle">Employee id</td>
                                          <td class="GridViewHeaderStyle">Employee Name</td>
                                        <td class="GridViewHeaderStyle">created byid</td>
                                           <td class="GridViewHeaderStyle">created byName</td>
                                        <td class="GridViewHeaderStyle">create date</td>
                                       
                                       
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                          
                                     </tr>
                                 </table> 
                   </div>
                   </div>
                      </div>  

               
               

         </div>


          <script type="text/javascript">
              $(document).ready(function () {
                  bindtabledata();
              });



              function bindtabledata() {
                  $.ajax({
                      url: "Locationemployee.aspx/getitemdetailtoadd",
                      data: '{createdby:"1"}', // parameter map 
                      type: "POST", // data has to be Posted    	        
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      async: false,
                      dataType: "json",
                      success: function (result) {
                          var ItemData = jQuery.parseJSON(result.d);

                          if (ItemData.length == 0) {
                              showerrormsg("No Item Found");
                              $.unblockUI();

                          }
                          else {
                              $("#tblBody").empty();
                              $('#tblQuotation tr').slice(1).remove();
                              for (var i = 0; i <= ItemData.length - 1; i++) {
                                  var a = $('#tblQuotation tr').length - 1;
                                  var mydata = '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">';
                                  mydata += '<td  id="itemid" style="display:none;">' + ItemData[i].id + '</td>';
                                  mydata += '<td id="serial_number" class="order" >' + (i + 1) + '</td>';
                                  mydata += '<td id="locationid"  >' + ItemData[i].locationid + '</td>';
                                  mydata += '<td id="locationid"  >' + ItemData[i].location + '</td>';
                                  mydata += '<td  id="centerid" >' + ItemData[i].centerid + '</td>';
                                  mydata += '<td  id="centerid" >' + ItemData[i].centre + '</td>';
                                  mydata += '<td  id="employeeid">' + ItemData[i].employeeid + '</td>';
                                  mydata += '<td  id="centerid" >' + ItemData[i].name1 + '</td>';
                                  mydata += '<td  id="created_by">' + ItemData[i].created_by + '</td>';
                                  mydata += '<td  id="centerid" >' + ItemData[i].name + '</td>';
                                  mydata += '<td  id="created_date" >' + ItemData[i].created_date + '</td>';
                                  //mydata += '<td  id="tdMajorUnitId" style="display:none;">' + ItemData[i].MajorUnitId + '</td>';
                                  //mydata += '<td  id="tdMinorUnitId" style="display:none;">' + ItemData[i].MinorUnitId + '</td>';
                                  mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';


                                  mydata += '</tr>';

                                  $('#tblQuotation').append(mydata);
                              }
                          }

                      }
                  });

              }
</script>
          <script type="text/javascript">
         
             

             $(function () {

                 $('[id*=lstCentre]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });


                 $('[id*=lstCentreType]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
                 $('[id*=lstlocation]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });


                 bindcentertype();


             });



             function bindcentertype() {
                 jQuery('#<%=lstCentreType.ClientID%> option').remove();
                  jQuery('#lstCentreType').multipleSelect("refresh");
                  $.ajax({
                      url: "Locationemployee.aspx/bindcentertype",
                      data: '{}',
                      type: "POST",
                      contentType: "application/json; charset=utf-8",
                      timeout: 120000,
                      dataType: "json",
                      async: false,
                      success: function (result) {
                          bindCentre();
                          typedata = jQuery.parseJSON(result.d);
                          for (var a = 0; a <= typedata.length - 1; a++) {
                              jQuery('#lstCentreType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));
                          }

                          jQuery('[id*=lstCentreType]').multipleSelect({
                              includeSelectAllOption: true,
                              filter: true, keepOpen: false
                          });
                      },
                      error: function (xhr, status) {
                      }
                  });
              }


              function deleterow(itemid) {
                  var table = document.getElementById('tblQuotation');
                
                  $("tr").click(function () {
                      var txt = $(this).find("td").first().text();
                    

                      jQuery.ajax({
                          url: "Locationemployee.aspx/removerow",
                          data: '{id: "' + txt + '"}',
                          type: "POST",
                          contentType: "application/json; charset=utf-8",
                          timeout: 120000,
                          dataType: "json",
                          async: false,
                          success: function (result) {
                              var centreData = jQuery.parseJSON(result.d);
                             
                          },
                          error: function (xhr, status) {
                              alert("Error ");
                          }
                      });




                  });
                  table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                  $('td.order').text(function (i) {

                      // returning the sum of i + 1 to compensate for
                      // JavaScript's zero-indexing:
                      return i + 1;
                  });

              }

            function bindCentre() {
                 var StateID = $('#<%=ddlstate.ClientID%>').val();

                 if (StateID == "0") {
                     showerrormsg("Please Select State.!");
                     return;
                 }

            
                 var TypeId = jQuery('#lstCentreType').val();
                 var ZoneId = "";
                 var cityId = "";
                 jQuery('#<%=lstCentre.ClientID%> option').remove();
                 jQuery('#lstCentre').multipleSelect("refresh");

                 jQuery.ajax({
                     url: "Locationemployee.aspx/bindCentre",
                     data: '{TypeId: "' + TypeId + '",ZoneId: "' + ZoneId + '",StateID: "' + StateID + '",cityid: "' + cityId + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     async: false,
                     success: function (result) {
                         var centreData = jQuery.parseJSON(result.d);
                         for (i = 0; i < centreData.length; i++) {
                             jQuery("#lstCentre").append(jQuery("<option></option>").val(centreData[i].CentreID).html(centreData[i].Centre));
                         }
                         $('[id*=lstCentre]').multipleSelect({
                             includeSelectAllOption: true,
                             filter: true, keepOpen: false
                         });
                     },
                     error: function (xhr, status) {
                         alert("Error ");
                     }
                 });


                 bindlocation();
            }



             function bindlocation() {

                 var StateID = jQuery('#lstState').val();

                 var StateID = $('#<%=ddlstate.ClientID%>').val();

            if (StateID == "0") {
                showerrormsg("Please Select State.!");
            }

            var TypeId = jQuery('#lstCentreType').val();
            var ZoneId = "";
            var cityId = "";

            var centreid = jQuery('#lstCentre').val();
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");

            jQuery.ajax({
                url: "Locationemployee.aspx/bindlocation",
                data: '{centreid:"' + centreid + '",StateID:"' + StateID + '",TypeId:"' + TypeId + '",ZoneId:"' + ZoneId + '",cityId:"' + cityId + '"}',
                type: "POST",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var centreData = jQuery.parseJSON(result.d);
                    for (i = 0; i < centreData.length; i++) {
                        jQuery("#lstlocation").append(jQuery("<option></option>").val(centreData[i].LocationID).html(centreData[i].Location));
                    }
                    $('[id*=lstlocation]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });

        }
         
         </script>

           <script type="text/javascript">

               function existingdata() {
                   debugger;
                   var StateID = jQuery('#lstState').val();
                   var TypeId = jQuery('#lstCentreType').val();
                   var center = jQuery('#lstCentre').val();
                   var location = jQuery('#lstlocation').val();
                   jQuery.ajax({
                       url: "Locationemployee.aspx/SearchRecords",
                       data: '{centreid:"' + center + '",StateID:"' + $('#<%=ddlstate.ClientID%>').val() + '",TypeId:"' + TypeId + '",locationid:"' + location + '"}',
                       type: "POST",
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       dataType: "json",

                       success: function (result) {
                           ItemData = jQuery.parseJSON(result.d);
                           if (ItemData.length == 0) {
                               savedata();


                           }
                           else {
                               var r = confirm("These Location are already Exist !! do you want to remove ??");
                               if (r == true) {
                                   removemultipledata();
                                   savedata();
                               } else {
                                   clearForm();
                                   showmsg("Please Remove Existing location");

                               }




                           }
                       }
                   });



               }



               function removemultipledata() {
                   var location = jQuery('#lstlocation').val();
                   jQuery.ajax({
                       url: "Locationemployee.aspx/updatemultiRecords",
                       data: '{locationid:"' + location + '"}',
                       type: "POST",
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       dataType: "json",

                       success: function (result) {
                         
                          
                       }
                    });

               }


                </script>
           <script type="text/javascript">
               function savedata() {


                  
                   debugger;
                   var quotationdata = getquotationdata();
                
                   if (validation() == false) {
                       return;
                   }


                   $("#btnsave").attr('disabled', true).val("Submiting...");
                 //  $.blockUI();
                   $.ajax({
                       url: "Locationemployee.aspx/Savelocationempdata",
                       data: JSON.stringify({ quotationdata: quotationdata }),
                       type: "POST", // data has to be Posted    	        
                       contentType: "application/json; charset=utf-8",
                       timeout: 120000,
                       dataType: "json",
                       success: function (result) {
                           $.unblockUI();
                           var save = result.d;
                           
                           if (save.split('#')[0] == "1") {
                               bindtabledata();
                               $('#btnsave').attr('disabled', false).val("Save");
                               clearForm();
                               showmsg("Data Save successfully");
                            
                             



                           }
                           
                       },
                       error: function (xhr, status) {
                           showerrormsg("Some Error Occure Please Try Again..!");
                           $('#btnsave').attr('disabled', false).val("Save");
                           console.log(xhr.responseText);
                           alert(xhr.responseText);
                       }
                   });
               }

               function clearForm() {
               
                
                   $('#<%=ddlstate.ClientID%>').prop('selectedIndex', 0);
                   $('#<%=ddlcenter.ClientID%>').prop('selectedIndex', 0);
                   $('#<%=ddlemployee.ClientID%>').prop('selectedIndex', 0);
                   bindcentertype();
                 
                  
               }

               function validation() {
                   if ($('#<%=ddlstate.ClientID%>').val() == "0") {
                       showerrormsg("Please Select State..!");
                       $('#<%=ddlstate.ClientID%>').focus();
                       return false;
                   }

                   if ($('#<%=ddlcenter.ClientID%>').val() == "0") {
                       showerrormsg("Please Select center..!");
                       $('#<%=ddlcenter.ClientID%>').focus();
                       return false;
                   }

                   if ($('#<%=ddlemployee.ClientID%>').val() == "0") {
                       showerrormsg("Please Select Employee..!");
                       $('#<%=ddlemployee.ClientID%>').focus();
                       return false;
                   }

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

                

 </script>



         <script type="text/javascript">
             function getquotationdata() {
                
                 var allselect = new Array();
              
                 var dataIm = new Array();
                 var objQuotation = new Object();
                 var centerid = jQuery('#<%=ddlcenter.ClientID%>').val();
                 var empid = jQuery('#<%=ddlemployee.ClientID%>').val();
                 var x = document.getElementById("lstlocation");
                 for (var i = 0; i < x.options.length; i++) {
                     if (x.options[i].selected == true) {
                         allselect.push(x.options[i].value);
                         objQuotation.location = x.options[i].value;
                         objQuotation.center = centerid;
                         objQuotation.employeeid = empid;

                         dataIm.push(objQuotation);
                         objQuotation = new Object();
                        
                     }
                 }

                 return dataIm;

                
             }



             function getMultipleSelectedValue() {
                
             }

                 </script>



          <script type="text/javascript">

           function SearchRecords() {
                 var StateID = jQuery('#lstState').val();
                 var TypeId = jQuery('#lstCentreType').val();
                 var center = jQuery('#lstCentre').val();
                 var location = jQuery('#lstlocation').val();


                
              
                 jQuery.ajax({
                     url: "Locationemployee.aspx/SearchRecords",
                     data: '{centreid:"' + center + '",StateID:"' + $('#<%=ddlstate.ClientID%>').val() + '",TypeId:"' + TypeId + '",locationid:"' + location + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                   
                     success: function (result) {
                         ItemData = jQuery.parseJSON(result.d);
                         if (ItemData.length == 0) {
                             showerrormsg("No Location Found With This Centre");
                             $.unblockUI();
                           

                         }
                         else {
                             $("#tblBody").empty();
                             $('#tblQuotation tr').slice(1).remove();
                             for (var i = 0; i <= ItemData.length - 1; i++) {
                                 var a = $('#tblQuotation tr').length - 1;
                                 var mydata = '<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">';
                                 mydata += '<td  id="itemid" style="display:none;">' + ItemData[i].id + '</td>';
                                 mydata += '<td id="serial_number" class="order" >' + (i + 1) + '</td>';
                                 mydata += '<td id="locationid"  >' + ItemData[i].locationid + '</td>';
                                 mydata += '<td id="locationid"  >' + ItemData[i].location + '</td>';
                                 mydata += '<td  id="centerid" >' + ItemData[i].centerid + '</td>';
                                 mydata += '<td  id="centerid" >' + ItemData[i].centre + '</td>';
                                 mydata += '<td  id="employeeid">' + ItemData[i].employeeid + '</td>';
                                 mydata += '<td  id="centerid" >' + ItemData[i].name1 + '</td>';
                                 mydata += '<td  id="created_by">' + ItemData[i].created_by + '</td>';
                                 mydata += '<td  id="centerid" >' + ItemData[i].name + '</td>';
                                 mydata += '<td  id="created_date" >' + ItemData[i].created_date + '</td>';
                                 //mydata += '<td  id="tdMajorUnitId" style="display:none;">' + ItemData[i].MajorUnitId + '</td>';
                                 //mydata += '<td  id="tdMinorUnitId" style="display:none;">' + ItemData[i].MinorUnitId + '</td>';
                                 mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';


                                 mydata += '</tr>';

                                 $('#tblQuotation').append(mydata);
                             }
                         }

                     }
                 });
             }
</script>
         
         </asp:Content>

