<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="QCValueEntry.aspx.cs" Inherits="Design_Quality_QCValueEntry" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
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
                          <b>QC Parameter Value Entry</b>  

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
                         <td style="font-weight: 700">Centre :</td>
                          <td><asp:DropDownList ID="ddlprocessinglab" runat="server" class="ddlprocessinglab chosen-select chosen-container" Width="380" onchange="bindcontrol()">
 
                          </asp:DropDownList></td>
                          <td style="font-weight: 700">Control/Lot Number :</td>
                         <td>
                              <asp:DropDownList ID="ddlcontrol" runat="server" class="ddlcontrol chosen-select chosen-container" Width="425" >
                           
                          </asp:DropDownList>
                         </td>

                         <td>
                              <strong>Entry Date :</strong></td>

                         <td>
                              <asp:TextBox ID="txtfromdate" runat="server" Width="80" ReadOnly="true" ></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                          </td>

                    </tr>
                   
                    <tr>
                         <td style="font-weight: 700" colspan="6" align="center">

                            
                             <input type="button" value="Show Parameter" class="searchbutton" onclick="showreading()" />&nbsp;&nbsp;
                               <input type="button" value="Reset" class="resetbutton" onclick="resetme()" />&nbsp;&nbsp;


                             <input type="button" value="Save Value" class="savebutton" onclick="saveme()" style="display:none;" id="btnupdate" />
                         </td>
                       
                    </tr>
                </table>
                </div>
              </div>
           <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                  <div  style="width:1295px; max-height:350px;overflow:auto;">
                         <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="trheader">
                     <td class="GridViewHeaderStyle" style="width: 40px;">Sr.No</td>
                          <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                          <td class="GridViewHeaderStyle" style="width:150px;">LabObservation ID</td>
                        <td class="GridViewHeaderStyle">LabObservation Name</td>
                          <td class="GridViewHeaderStyle" width="100px">Level 1</td>
                          <td class="GridViewHeaderStyle"  width="100px">Level 2</td>
                            <td class="GridViewHeaderStyle"  width="100px">Level 3</td>
                        </tr>
                             </table>
                             
                </div>
               </div>
               </div>
         </div>

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

        $(document).ready(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }


            bindcontrol();

        });
        function bindcontrol() {

            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
             jQuery('#<%=ddlcontrol.ClientID%> option').remove();
             $('#<%=ddlcontrol.ClientID%>').trigger('chosen:updated');

             if (labid != "0" && labid != null) {


                 //$.blockUI();
                 $.ajax({
                     url: "QCReport.aspx/bindcontrol",
                     data: '{labid: "' + labid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Control Found");
                         }

                         jQuery("#<%=ddlcontrol.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Control"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlcontrol.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].controlid).html(CentreLoadListData[i].controlname));
                         }

                         $("#<%=ddlcontrol.ClientID%>").trigger('chosen:updated');





                         //$.unblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                         //$.unblockUI();
                     }
                 });
             }
         }



         


    </script>

    <script type="text/javascript">
        function showreading() {
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
            var controlid = $('#<%=ddlcontrol.ClientID%>').val();
          
            var fromdate = $('#<%=txtfromdate.ClientID%>').val();

            if (labid == "0" && labid == null) {
                showerrormsg("Please Select Centre");
                return;
            }

            if (controlid == "0" || controlid == null) {
                showerrormsg("Please Select Control/Lot Number");
                return;
            }
            if (fromdate == "") {
                showerrormsg("Please Select Entry Date");
                return;
            }

            $('#tblitemlist tr').slice(1).remove();

            //$.blockUI();
            $.ajax({
                url: "QCValueEntry.aspx/showreading",
                data: '{labid:"' + labid + '",controlid:"' + controlid + '",fromdate:"' + fromdate + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        $('#btnupdate').hide();
                       


                    }
                    for (i = 0; i < ItemData.length; i++) {

                        var color = "lightgreen";
                       

                        var mydata = "<tr style='background-color:" + color + ";' id='" + ItemData[i].LabObservation_ID + "'>";
                        mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1);
                        mydata += '</td>';
                        mydata += '<td class="GridViewLabItemStyle"><input type="checkbox" id="ch" title="Check To Save Value"  onclick="checkforreason(this)"   /></td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_ID"  style="font-weight:bold;">' + ItemData[i].LabObservation_ID + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_Name" style="font-weight:bold;">' + ItemData[i].LabObservation_Name + '</td>';
                        if (ItemData[i].levelid.indexOf('1') != -1) {
                            mydata += '<td class="GridViewLabItemStyle"  id="level1"  ><input type="text" id="txtvaluelevel1" style="width:90px;"/></td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle"  id="level1"  ><input type="text" id="txtvaluelevel1" disabled="disabled"  style="width:90px;"/></td>';
                        }
                        if (ItemData[i].levelid.indexOf('2') != -1) {
                            mydata += '<td class="GridViewLabItemStyle"  id="level2"  ><input type="text" id="txtvaluelevel2" style="width:90px;"/></td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle"  id="level2"  ><input type="text" id="txtvaluelevel2" disabled="disabled"  style="width:90px;"/></td>';
                        }
                        if (ItemData[i].levelid.indexOf('3') != -1) {
                            mydata += '<td class="GridViewLabItemStyle"  id="level3"  ><input type="text" id="txtvaluelevel3" style="width:90px;"/></td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle"  id="level3"  ><input type="text" id="txtvaluelevel3" disabled="disabled"  style="width:90px;"/></td>';
                        }
                      
                       
                      
                     
                        //if (ItemData[i].RCA != "") {
                        //    mydata += '<td align="left"  ><img id="RCAImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openrca(this)"/></td>';
                        //}
                        //else {
                        //    mydata += '<td align="left"  ><img id="RCAImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openrca(this)"/></td>';
                        //}

                        //if (ItemData[i].CorrectiveAction != "") {
                        //    mydata += '<td align="left" ><img id="CorrectiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openca(this)"/></td>';
                        //}
                        //else {
                        //    mydata += '<td align="left" ><img id="CorrectiveActionImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openca(this)"/></td>';
                        //}

                        //if (ItemData[i].PreventiveAction != "") {
                        //    mydata += '<td align="left" ><img id="PreventiveActionImg" src="../../App_Images/Redplus.png" style="cursor:pointer;" onclick="openpa(this)"/></td>';
                        //}
                        //else {
                        //    mydata += '<td align="left"><img id="PreventiveActionImg" src="../../App_Images/ButtonAdd.png" style="cursor:pointer;" onclick="openpa(this)"/></td>';
                        //}
                       

                        mydata += '<td class="GridViewLabItemStyle"  id="centreid"  style="display:none;">' + labid + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="controlid"  style="display:none;">' + ItemData[i].controlid + '</td>';
                        mydata += '<td class="GridViewLabItemStyle"  id="LabObservation_ID"  style="display:none;">' + ItemData[i].LabObservation_ID + '</td>';
                        //mydata += '<td class="GridViewLabItemStyle"  id="LevelID"  style="display:none;">' + ItemData[i].LevelID + '</td>';
                        //mydata += '<td class="GridViewLabItemStyle"  id="id"  style="display:none;">' + ItemData[i].id + '</td>';
                        //mydata += '<td id="RCA" style="display:none;">' + ItemData[i].RCA + '</td>';
                        //mydata += '<td id="CorrectiveAction" style="display:none;">' + ItemData[i].CorrectiveAction + '</td>';
                        //mydata += '<td id="PreventiveAction" style="display:none;">' + ItemData[i].PreventiveAction + '</td>';

                        //mydata += '<td class="GridViewLabItemStyle"  id="updatereason"  style="display:none;"></td>';




                        mydata += "</tr>";
                        $('#btnupdate').show();
                    
                        $('#tblitemlist').append(mydata);


                    }

                    $("#<%=ddlprocessinglab.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                   
                    $("#<%=ddlcontrol.ClientID%>").attr("disabled", true).trigger('chosen:updated');
                    $("#<%=txtfromdate.ClientID%>").attr("disabled", true);
                  

                    //$.unblockUI();


                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });
        }


        function checkforreason(ctrl) {
            if ($(ctrl).prop('checked') == true) {
                $(ctrl).closest('tr').css('background-color', 'aqua');

            }
            else {


                $(ctrl).closest('tr').css('background-color', 'lightgreen');
            }
        }


        function getparameterlist() {
            var dataIm = new Array();
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trheader" && $(this).closest('tr').find('#ch').prop('checked') == true) {
                    for (var a = 1; a <= 3; a++) {
                        var objcontroldata = new Object();
                        objcontroldata.CentreId = $('#<%=ddlprocessinglab.ClientID%>').val();
                        objcontroldata.ControlID = $('#<%=ddlcontrol.ClientID%>').val();
                        objcontroldata.ControlName = $('#<%=ddlcontrol.ClientID%> option:selected').text().split('#')[0].trim();
                        objcontroldata.LotNumber = $('#<%=ddlcontrol.ClientID%> option:selected').text().split('#')[1].trim();
                    

                        objcontroldata.LabObservation_ID = $(this).closest('tr').find('#LabObservation_ID').html();
                        objcontroldata.LabObservation_Name = $(this).closest('tr').find('#LabObservation_Name').html();
                        
                        objcontroldata.LevelID = a;
                        objcontroldata.Level = "Level" + a;
                        var id = "#txtvaluelevel" + a;
                        objcontroldata.Reading = $(this).closest('tr').find(id).val();
                        objcontroldata.EntryDate = $('#<%=txtfromdate.ClientID%>').val();
                       
                        dataIm.push(objcontroldata);
                    }
                }
            });
            return dataIm;

        }


        function saveme() {

            var sn = 0;

            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trheader" && $(this).closest('tr').find('#ch').prop('checked') == true) {



                    if ($(this).find('#txtvaluelevel1').val() == "" && $(this).find('#txtvaluelevel1').prop('disabled') == false) {
                        sn = 1;
                        $(this).find('#txtvaluelevel1').focus();
                        return;
                    }

                }
            });
            if (sn == 1) {
                showerrormsg("Please Enter Value ");
                return;
            }

            var sn1 = 0;

            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trheader" && $(this).closest('tr').find('#ch').prop('checked') == true) {



                    if ($(this).find('#txtvaluelevel2').val() == "" && $(this).find('#txtvaluelevel2').prop('disabled') == false) {
                        sn1 = 1;
                        $(this).find('#txtvaluelevel2').focus();
                        return;
                    }

                }
            });
            if (sn1 == 1) {
                showerrormsg("Please Enter Value ");
                return;
            }

            var sn2 = 0;

            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trheader" && $(this).closest('tr').find('#ch').prop('checked') == true) {



                    if ($(this).find('#txtvaluelevel3').val() == "" && $(this).find('#txtvaluelevel3').prop('disabled') == false) {
                        sn2 = 1;
                        $(this).find('#txtvaluelevel3').focus();
                        return;
                    }

                }
            });
            if (sn2 == 1) {
                showerrormsg("Please Enter Value ");
                return;
            }

            var datatosave = getparameterlist();

            if (datatosave.length == 0) {
                showerrormsg("Please Select Data");
                return;
            }


            //$.blockUI();
            $.ajax({
                url: "Qcvalueentry.aspx/SaveData",
                data: JSON.stringify({ controldata: datatosave }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    var save = result.d;
                    if (save == "1") {
                        showmsg("Record Saved Successfully");

                        resetme();

                    }
                    else {
                        showerrormsg(save);

                        // console.log(save);
                    }
                },
                error: function (xhr, status) {
                    //$.unblockUI()
                    showerrormsg("Some Error Occure Please Try Again..!");

                    console.log(xhr.responseText);
                }
            });
        }

        function resetme() {    
            $("#<%=ddlprocessinglab.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
            $("#<%=ddlcontrol.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
            $("#<%=txtfromdate.ClientID%>").val('').attr("disabled", false);
            $('#tblitemlist tr').slice(1).remove();
            $('#btnupdate').hide();
        }
    </script>
</asp:Content>

