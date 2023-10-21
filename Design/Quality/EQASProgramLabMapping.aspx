<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EQASProgramLabMapping.aspx.cs" Inherits="Design_Quality_EQASProgramLabMapping" %>

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
                          <b>EQAS Program Processing Lab Mapping</b>  

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

                        <td colspan="3">
                             <asp:DropDownList ID="ddlcentretype" runat="server" class="ddlcentretype chosen-select chosen-container"   Width="80px" onchange="bindcentre()">
                             </asp:DropDownList>
                            

                           

                            <asp:ListBox ID="ddlprocessinglab" onchange="getsavedmapping()"  CssClass="multiselect" SelectionMode="Multiple" Width="365px" runat="server"></asp:ListBox>

                        </td>
                     </tr>
                    <tr>
                        <td style="font-weight: 700;">
                            EQAS Provider :</td>

                        <td>
                          <asp:DropDownList ID="ddleqasprovider" runat="server" class="ddleqasprovider chosen-select chosen-container" Width="450" onchange="bindprogram()">
                           
                          </asp:DropDownList>
                       
                        </td>
                        <td style="font-weight: 700; ">
                            EQAS
                            Program :</td>
                        <td   >
                         <asp:ListBox ID="ddleqasprogram" onchange="getprogramdata()" CssClass="multiselect" SelectionMode="Multiple" Width="400px" runat="server"></asp:ListBox>
                            

                        </td>
                     </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Test List :</td>

                        <td colspan="3">
                            <div style="width:100%;overflow:auto;max-height:400px;">
                        <table id="tbl">
                            
                        </table>   
                        </div>
                        </td>
                     </tr>
                    <tr>
                        <td style="font-weight: 700; text-align: center;" colspan="4">
                            
                        <input type="button" value="Save" class="savebutton" onclick="saveme()" />&nbsp;&nbsp;
                            <input type="button" value="Reset" class="resetbutton" onclick="resetme()" />
                        <input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()"  /></td>

                     </tr>
                    </table>
                </div>
                </div>


            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">


                  <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
           <table id="tbl1" style="width:99%;border-collapse:collapse;text-align:left;">


                  
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle">Processing Lab</td>
                                        <td class="GridViewHeaderStyle">EQAS Provider</td>
                                        <td class="GridViewHeaderStyle">EQAS Program</td>
                                        <td class="GridViewHeaderStyle"">Tests</td>
                                        <td class="GridViewHeaderStyle">EntryDate</td>
                                        <td class="GridViewHeaderStyle">EntryBy</td>
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
             $('#<%=ddlprocessinglab.ClientID%>').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });

             $('[id=<%=ddleqasprogram.ClientID%>]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
         
             

             //bindilclab();

          

         });

         function bindcentre() {

             var TypeId = $('#<%=ddlcentretype.ClientID%>').val();
             jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
             jQuery('#<%=ddlprocessinglab.ClientID%>').multipleSelect("refresh");
             if (TypeId == "0") {


                 return;

             }
             //$.blockUI();
             $.ajax({
                 url: "EQASProgramLabMapping.aspx/bindCentre",
                 data: '{TypeId: "' + TypeId + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                
                 dataType: "json",
                 success: function (result) {
                     centreData = $.parseJSON(result.d);
                     for (i = 0; i < centreData.length; i++) {
                         jQuery("#<%=ddlprocessinglab.ClientID%>").append(jQuery("<option></option>").val(centreData[i].centreid).html(centreData[i].centre));
                     }
                     $('[id=<%=ddlprocessinglab.ClientID%>]').multipleSelect({
                         includeSelectAllOption: true,
                         filter: true, keepOpen: false
                     });
                     //$.UNblockUI();
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                     //$.UNblockUI();
                 }
             });
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



         function bindprogram() {
             $('#tbl tr').remove();
             
             var eqasproid = $('#<%=ddleqasprovider.ClientID%>').val();
             jQuery('#<%=ddleqasprogram.ClientID%> option').remove();
             jQuery('#<%=ddleqasprogram.ClientID%>').multipleSelect("refresh");
             if (eqasproid == "0") {


                 return;

             }
             //$.blockUI();
             $.ajax({
                 url: "EQASProgramLabMapping.aspx/bindprogram",
                 data: '{eqasproid: "' + eqasproid + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
               
                 dataType: "json",
                 success: function (result) {
                     centreData = $.parseJSON(result.d);
                     for (i = 0; i < centreData.length; i++) {
                         jQuery("#<%=ddleqasprogram.ClientID%>").append(jQuery("<option></option>").val(centreData[i].programid).html(centreData[i].programname));
                     }
                     $('[id=<%=ddleqasprogram.ClientID%>]').multipleSelect({
                         includeSelectAllOption: true,
                         filter: true, keepOpen: false
                     });
                     //$.UNblockUI();
                 },
                 error: function (xhr, status) {
                     //  alert(status + "\r\n" + xhr.responseText);
                     window.status = status + "\r\n" + xhr.responseText;
                     //$.UNblockUI();
                 }
             });
         }



         function getprogramdata() {

             $('#tbl tr').remove();

             var programid = $('#<%=ddleqasprogram.ClientID%>').val();
             if (programid == "") {
                 return;
             }
             //$.blockUI();
             $.ajax({
                 url: "EQASProgramLabMapping.aspx/bindprogramdata",
                 data: '{programid: "' + programid + '"}',
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

                             mydata = "<tr style='background-color:white'><td colspan='3' style='font-weight:bold;'>ProgramID:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].programid + "</span>&nbsp;ProgramName:&nbsp;<span style='background-color:aquamarine'> " + PanelData[i].programname + "</span>&nbsp;Rate:<span style='background-color:aquamarine'>" + PanelData[i].rate + "</span>&nbsp;ResultWithin:<span style='background-color:aquamarine'>" + PanelData[i].ResultWithin + "</span>&nbsp;Frequency:<span style='background-color:aquamarine'>" + PanelData[i].Frequency + "</span></td></tr>";
                             programname = PanelData[i].programname;
                             co = 1;
                         }

                         mydata += '<tr style="background-color:bisque;" class="GridViewItemStyle" id=>';

                         mydata += '<td  align="left" >' + co + '</td>';


                         mydata += '<td align="left">' + PanelData[i].departmentname + '</td>';
                         mydata += '<td align="left">' + PanelData[i].investigationname + '</td>';
                      




                         mydata += '</tr>';

                         $('#tbl').append(mydata);
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

         </script>


    <script type="text/javascript">
        function resetme() {
            $('#tbl tr').remove();
           
            jQuery('#<%=ddleqasprogram.ClientID%> option').remove();
            jQuery('#<%=ddleqasprogram.ClientID%>').multipleSelect("refresh");
            $('#<%=ddleqasprovider.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            $('#<%=ddlcentretype.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
            jQuery('#<%=ddlprocessinglab.ClientID%>').multipleSelect("refresh");
        }
        function resetmenew() {
            $('#tbl tr').remove();
            jQuery('#<%=ddleqasprogram.ClientID%> option').remove();
            jQuery('#<%=ddleqasprogram.ClientID%>').multipleSelect("refresh");
             $('#<%=ddleqasprovider.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
           
         }

        

        function getmappingdata() {
            var datatosave = "";
            $('#<%=ddlprocessinglab.ClientID%> > option:selected').each(function () {
                var ddlprid = $(this).val();
            

                $('#<%=ddleqasprogram.ClientID%> > option:selected').each(function () {

                    var programid = $(this).val();
                
                    datatosave += ddlprid + "#" + $('#<%=ddleqasprovider.ClientID%>').val() + "#" + programid + "^";
                });

            });
            return datatosave;
        }

        function saveme() {
            var centreid = jQuery('#<%=ddlprocessinglab.ClientID%>').val();
            var eqasproviderid = jQuery('#<%=ddleqasprovider.ClientID%>').val();
            var eqasprogram = jQuery('#<%=ddleqasprogram.ClientID%>').val();

            if (centreid == "") {
                showerrormsg("Please Select Processing Lab");
                return;
            }

            if (eqasproviderid == "0") {
                showerrormsg("Please Select EQAS Provider");
                return;
            }

            if (eqasprogram == "") {
                showerrormsg("Please Select EQAS Program");
                return;
            }



            //$.blockUI();
            $.ajax({
                url: "EQASProgramLabMapping.aspx/saveprogrammapping",
                data: '{data: "' + getmappingdata() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,

                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showmsg("Mapping Saved..!");
                        getsavedmapping();
                        resetmenew();
                    }
                    else {
                        showerrormsg(result.d);
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




        function getsavedmapping() {



            $('#tbl1 tr').slice(1).remove();

            var processinglabid = $('#<%=ddlprocessinglab.ClientID%>').val();
            if (processinglabid == "") {
                return;
            }
            //$.blockUI();
            $.ajax({
                url: "EQASProgramLabMapping.aspx/getprogramlist",
                data: '{processinglabid: "' + processinglabid + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,

                dataType: "json",
                success: function (result) {
                    PanelData = $.parseJSON(result.d);
                  
                    for (i = 0; i < PanelData.length; i++) {
                      
                        var mydata = "";
                        mydata += '<tr style="background-color:lightgreen;" class="GridViewItemStyle" name="' + PanelData[i].id + '" id="' + PanelData[i].programid + '">';
                        mydata += '<td  align="left" >' + parseInt(i + 1) + '</td>';
                        mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownew(this)"/></td>';
                        mydata += '<td align="left">' + PanelData[i].centre + '</td>';
                      
                        mydata += '<td align="left">' + PanelData[i].EqasProviderName + '</td>';
                        mydata += '<td align="left">' + PanelData[i].programname + '</td>';
                        mydata += '<td align="left">' + PanelData[i].testname + '</td>';
                        mydata += '<td align="left">' + PanelData[i].entrydatetime + '</td>';
                        mydata += '<td align="left">' + PanelData[i].entrybyname + '</td>';
                        mydata += '</tr>';

                        $('#tbl1').append(mydata);
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



        function deleterownew(itemid) {
            if (confirm("Do You Want To Delete This Mapping?")) {
                var id = $(itemid).closest('tr').attr('name');




                jQuery.ajax({
                    url: "EQASProgramLabMapping.aspx/deletedata",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {

                        showmsg("Data Deleted..");
                        var table = document.getElementById('tbl1');
                        table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                    },


                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });


            }
        }
    </script>

    <script type="text/javascript">


        function exporttoexcel() {

            var processinglabid = $('#<%=ddlprocessinglab.ClientID%>').val();
            

            jQuery.ajax({
                url: "EQASProgramLabMapping.aspx/exporttoexcel",
                data: '{ processinglabid: "' + processinglabid + '"}',
                  type: "POST",
                  timeout: 120000,
                  async: false,
                  contentType: "application/json; charset=utf-8",
                  dataType: "json",
                  success: function (result) {
                      if (result.d == "false") {
                          showerrormsg("No Item Found");
                          //$.UNblockUI();
                      }
                      else {
                          window.open('../Common/exporttoexcel.aspx');
                          //$.UNblockUI();
                      }

                  },


                  error: function (xhr, status) {
                      alert("Error ");
                  }
              });
          }


  </script>

</asp:Content>

