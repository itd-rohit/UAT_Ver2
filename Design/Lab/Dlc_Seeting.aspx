<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Dlc_Seeting.aspx.cs" Inherits="Design_Lab_Dlc_Seeting" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

        <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs")  %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
     <%: Scripts.Render("~/bundles/PostReportScript") %>
    
   
       <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
     <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>
                DLC Setting</b>
                  
        </div>
         </div>

            <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">Search</div>
            <div class="row">

              <div class="col-md-24">
                    <div class="col-md-3">
                        <label class="pull-left">Investigation </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                      <asp:DropDownList ID="ddlInvestigation" runat="server" onChange="getobservationdata(this.value);" class="ddlInvestigation chosen-select"></asp:DropDownList>
                        </div>
                  </div>
                </div>

                
                </div>

    <div class="POuter_Box_Inventory" style="text-align: center">
         <div class="row">
                <div class="col-md-24">
                    <div class="Purchaseheader">
                        Investigation Detail &nbsp;&nbsp;&nbsp; 
                   <span style="font-weight: bold; color: black;">Investigation Name :&nbsp;</span><span id="spninvestigation" style="font-weight: bold; color: white;"></span>
                        <span style="font-weight: bold; color: black;">Investigation ID:&nbsp;</span><span id="spninvid" style="font-weight: bold; color: white;"></span>
                    </div>
                </div>
                <div class="row">
                <div class="col-md-24">
                <div id="PagerDiv1" style="display:none;background-color:white;width:99%;padding-left:7px;">

              </div>
                     </div>
                </div>
            </div>
                <div class="row">
                    <div class="row" style=" height: 460px; overflow-y: auto; overflow-x: hidden;">
                <div class="col-md-24">
                   <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">
                            <td class="GridViewHeaderStyle" style="width: 20px;" >S.No.</td>
                            <td class="GridViewHeaderStyle" style="width: 20px;">Observation Name</td>
                            <td class="GridViewHeaderStyle" style="width: 20px;">LabObservation_ID</td>
                            <%--<td class="GridViewHeaderStyle" style="width: 20px;" >dlcCheck</td>--%>
                            <td class="GridViewHeaderStyle" style="width: 20px;">
                                <input type="checkbox" id="hd" onclick="call()" class="mmc"  />
                                Dlc_check
                              </td>
                             <%--<td class="GridViewHeaderStyle" style="width: 20px;">Change Dlc Status</td>--%>
                         
                           
                        </tr>
                    </table>
                </div>
            </div>
                    </div>
            

           </div>
    <div class="POuter_Box_Inventory">
                <div class="row" >
                <div class="col-md-24" style="text-align: center">
                    <input type="button" id="btnSave" value="Save" class="searchbutton"  onclick="Savedlc()" />
                </div>
            </div>
        </div>
    <script type="text/javascript">


        function getobservationdata(invid) {
            $('#tblitemlist tr').slice(1).remove();
            serverCall('Dlc_Seeting.aspx/GetObservationData', { InvestigationID: invid }, function (response) {

                var $ReqData = JSON.parse(response);
                if ($ReqData.length == 0) {
                    toast("Error", "No Item Found..!", "");
                }

             else   {
                    for (var i = 0; i <= $ReqData.length - 1; i++) {
                        $('#spninvestigation').html($ReqData[i].Name);
                        $('#spninvid').html($ReqData[i].Investigation_Id);
                        var $mydata = [];
                        var j = i+1;
                        $mydata.push("<tr style='background-color:bisque;'>");
                        $mydata.push('<td class="GridViewLabItemStyle" id="Tdsno" style="width: 20px;">'); $mydata.push(j); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdObsName" style="width: 20px;">'); $mydata.push($ReqData[i].ObsName); $mydata.push('</td>');
                        $mydata.push('<td class="GridViewLabItemStyle" id="tdLabObservation_ID" style="width: 20px;">'); $mydata.push($ReqData[i].LabObservation_ID); $mydata.push('</td>');
                        //$mydata.push('<td class="GridViewLabItemStyle" id="tddlcCheck" style="width: 20px;">'); $mydata.push($ReqData[i].dlcCheck);
                        //checkbox


                        $mydata.push('<td class="GridViewLabItemStyle" >');
                        if ($ReqData[i].dlcCheck == "1") {
                            $mydata.push('<input type="checkbox" id="mmchk" checked="true" onchange="checkObservation(this)" class="');
                        }
                        else {
                            $mydata.push('<input type="checkbox" id="mmchk"  onchange="checkObservation(this)" class="');
                        }
                        $mydata.push($ReqData[i].LabObservation_ID);
                        $mydata.push('"/>');
                        $mydata.push('</td>');


                     //   $mydata.push('<td class="GridViewLabItemStyle">');
                     //   if ($ReqData[i].dlcCheck == "1") {
                     //       $mydata.push('<input type="button" value="Deactive" class="savebutton" onclick="UpdateStatus('); $mydata.push($ReqData[i].LabObservation_ID); $mydata.push(','); $mydata.push($ReqData[i].Investigation_Id); $mydata.push(',0)"/>');
                     //   }
                     //   else {
                     //     //  $mydata.push('<td class="GridViewLabItemStyle">');
                     //       $mydata.push('<input type="button" value="Active" class="savebutton" onclick="UpdateStatus('); $mydata.push($ReqData[i].LabObservation_ID); $mydata.push(','); $mydata.push($ReqData[i].Investigation_Id); $mydata.push(',1)"/>');
                     //     //  $mydata.push('</td>');
                     //   }
                     ////   $mydata.push('"/>');
                     //   $mydata.push('</td>');
                     


                       
                                $mydata.push("</tr>");
                                $mydata = $mydata.join("");
                                jQuery('#tblitemlist').append($mydata);
                            }
                }
                                 jQuery("#tblitemlist").tableHeadFixer({
                             });
                 });
              }
       





        function Savedlc() {
            var Itemdata = "";
            var Itemdata1 = "";
            $("#tblitemlist tr").find(':checkbox').filter(':checked').each(function () {

                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header")
                    Itemdata += $rowid.find("td:eq(" + 2 + ") ").html() + '|' + $rowid.find("#tdLabObservation_ID").val() + "#";
                  

            });

            $("#tblitemlist tr").find(':checkbox').filter(':not(:checked)').each(function () {
               
                var id = $(this).closest("tr").attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header")
                    Itemdata1 += $rowid.find("td:eq(" + 2 + ") ").html() + '|' + $rowid.find("#tdLabObservation_ID").val() + "#";
              


            });

           
            //if (Itemdata == "") {
            //    alert("Please select an item");
            //    $("#btnSave").attr('disabled', false);
            //    return;
            //}
            serverCall('Dlc_Seeting.aspx/SaveObservationData', { ItemData: Itemdata, Itemdata1: Itemdata1 }, function (response) {

             
                if (response == "1") {
                    toast("Success", "Record Saved Successfully", "");
                    window.location.reload();
                   
                }
                else {
                    toast("Error", "Record Not Saved", "");
                }
               
            });
        }


        //function UpdateStatus(LabObservation_ID,Investigation_Id, status) {
        //    serverCall('Dlc_Seeting.aspx/UpdateStatus', { LabObservation_ID: LabObservation_ID, status: status }, function (response) {
        //        var save = response;
        //        if (save.split('#')[0] == "1") {
        //            getobservationdata(Investigation_Id);
        //            toast("Success", " Dlc_Check Active Successfully", "");
        //        }
        //        if (save.split('#')[0] == "0") {
        //            getobservationdata(Investigation_Id);
        //            toast("Success", " Dlc_Check DeActive Successfully", "");
                    
        //        }
        //    });

        //}

        
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

     });

     function call() {
         if ($('#hd').prop('checked') == true) {
             $('#tblitemlist tr').each(function () {
                 var id = $(this).closest("tr").attr("id");
                 if (id != "header") {
                     $(this).closest("tr").find('#mmchk').prop('checked', true);
                 }
             });
         }
         else {
             $('#tblitemlist tr').each(function () {
                 var id = $(this).closest("tr").attr("id");
                 if (id != "saheader") {
                     $(this).closest("tr").find('#mmchk').prop('checked', false);
                 }
             });
         }
     }

     function checkObservation(ID) {
         var cls = $(ID).attr("data");
         if ($(ID).prop('checked') == true) {
             $("." + cls).prop("checked", true)
         }
     };




     </script>





 </asp:Content>
