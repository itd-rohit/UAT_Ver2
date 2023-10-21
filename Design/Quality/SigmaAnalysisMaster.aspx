<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SigmaAnalysisMaster.aspx.cs" Inherits="Design_Quality_SigmaAnalysisMaster" %>
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
     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
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
                          <b>Sigma Analysis Total Allowable Error (CLIA) Master</b>  

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
                            Department :</td>

                        <td>
                              <asp:DropDownList ID="ddldepartment" runat="server"  Width="450px" class="ddldepartment chosen-select" onchange="binddataall()"  ></asp:DropDownList></td>

                        <td style="font-weight: 700">
                            Test :</td>

                         <td>
                            <asp:ListBox ID="lsttestname" CssClass="multiselect" SelectionMode="Multiple" Width="607px" runat="server" ClientIDMode="Static" onchange="bindallparameter()"></asp:ListBox></td>
                     </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Parameter :</td>

                        <td colspan="3">
                            <asp:ListBox ID="lstparameter" CssClass="multiselect" SelectionMode="Multiple" Width="700px" runat="server" ClientIDMode="Static" ></asp:ListBox>
                          &nbsp;&nbsp;&nbsp;
                        <input type="button" value="Add" onclick="Addme()" class="searchbutton" />
                             &nbsp;&nbsp;&nbsp;
                            <input type="button" value="Reset" onclick="clearForm()" class="resetbutton" />
                             &nbsp;&nbsp;&nbsp;
                                <input type="button" value="Export To Excel" onclick="exporttoexcel()" class="searchbutton" />
                             &nbsp;&nbsp;&nbsp;
                             <input type="button" value="Save" onclick="saveme()" class="savebutton" id="btnsave" style="display:none;" />
                        </td>

                     </tr>
                    </table>
                </div>
                 </div>
             <div class="POuter_Box_Inventory" style="width:1300px;">
               <div class="content">

             <div class="Purchaseheader">
                    
                  <table>
                <tr>
                 
                     <td>Data List</td>
                     <td> &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                          &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
                     </td>
                    <td>Saved Data</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>New Data</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:lemonchiffon;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                   
                    
                </tr>
            </table>
                  
                  </div>
             <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
           <table id="tbl" style="width:99%;border-collapse:collapse;text-align:left;">


                   <thead>
                        <tr id="trheader">
                                        <td class="GridViewHeaderStyle" style="width:50px;">Sr No.</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;"><input type="checkbox" id="chhead" onclick="checkall(this)" /> </td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle">ParameterID</td>
                                        <td class="GridViewHeaderStyle">ParameterName</td>
                                         <td class="GridViewHeaderStyle" style="width:185px">
                                           Total Allowable Error (CLIA)
                                            <input type="text" id="txtaccepthead" placeholder="Allowable Error" style="width:95px;" onkeyup="showmehead(this)" name="t1" />
                                        </td>      
                            </tr>
                       </thead>
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
          

             $('[id=<%=lsttestname.ClientID%>]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
             $('[id=<%=lstparameter.ClientID%>]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
            jQuery("#tbl").tableHeadFixer({});
        });

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

        function binddataall() {
            jQuery('#<%=lsttestname.ClientID%> option').remove();
            jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");

            var department = $('#<%=ddldepartment.ClientID%>').val();
            if (department != "0") {
                $.blockUI();
                jQuery.ajax({
                    url: "SigmaAnalysisMaster.aspx/bindtest",
                    data: '{ department: "' + department + '"}',
                    type: "POST",
                    timeout: 120000,
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        CentreLoadListData = jQuery.parseJSON(result.d);


                        for (i = 0; i < CentreLoadListData.length; i++) {

                            jQuery("#<%=lsttestname.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].type_id).html(CentreLoadListData[i].typename));
                        }
                        $('[id=<%=lsttestname.ClientID%>]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });


                        $.unblockUI();

                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        $.unblockUI();
                    }
                });
            }
        }

        function bindallparameter() {

            jQuery('#<%=lstparameter.ClientID%> option').remove();
            jQuery('#<%=lstparameter.ClientID%>').multipleSelect("refresh");

            var test = $('#<%=lsttestname.ClientID%>').val();
            if (test != "") {
                $.blockUI();
                jQuery.ajax({
                    url: "SigmaAnalysisMaster.aspx/bindparameter",
                    data: '{ test: "' + test + '"}',
                    type: "POST",
                    timeout: 120000,
                   
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        CentreLoadListData = jQuery.parseJSON(result.d);


                        for (i = 0; i < CentreLoadListData.length; i++) {

                            jQuery("#<%=lstparameter.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].LabObservation_ID).html(CentreLoadListData[i].name));
                        }


                        $('[id=<%=lstparameter.ClientID%>]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });


                        $.unblockUI();

                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        $.unblockUI();
                    }
                });
            }
        }


    </script>

    <script type="text/javascript">

        function Addme() {
            var test = $('#<%=lstparameter.ClientID%>').val();
            if (test == "") {
                showerrormsg("Please Select Parameter...!");
                $('#<%=lstparameter.ClientID%>').focus();
                return;
            }
            $.blockUI();
            $('#tbl tr').slice(1).remove();
            jQuery.ajax({
                url: "SigmaAnalysisMaster.aspx/getalldata",
                data: '{ labobservationid: "' + $('#<%=lstparameter.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length === 0) {
                        $.unblockUI();
                        $('#btnsave').hide();
                        return;
                    }
                    $('#btnsave').show();
                    for (var i = 0; i <= PanelData.length - 1; i++) {
                        var color = 'lemonchiffon';
                        if (PanelData[i].savedid != "0") {
                            color = 'lightgreen';
                        }
                        var mydata = '<tr style="background-color:' + color + ';" class="GridViewItemStyle" id=' + PanelData[i].labObservation_ID + ' name="">';
                        mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';
                        mydata += '<td><input type="checkbox" id="ch"/></td>';
                        if (PanelData[i].savedid != "0") {
                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterownew(this)"/></td>';
                        }
                        else {
                            mydata += '<td></td>';
                        }
                        mydata += '<td align="left" id="parameterid">' +  PanelData[i].labObservation_ID + '</td>';
                        mydata += '<td align="left" id="parametername">' +  PanelData[i].name + '</td>';
                        mydata += '<td align="left" id="aceept"><input type="text" style="width:95px" id="txtaceept" value="' + PanelData[i].CLIA + '" name="t1" onkeyup="showmechild(this)"/></td>';
                        mydata += '<td align="left" id="savedid" style="display:none;">' +  PanelData[i].savedid + '</td>';
                        mydata += '</tr>';

                        $('#tbl').append(mydata);
                    }
                }
            });


           

            //$('#<%=ddldepartment.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            //$("#<%=lsttestname.ClientID%> option:selected").prop("selected", false);
           // jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");
           // jQuery('#<%=lstparameter.ClientID%> option').remove();
            //jQuery('#<%=lstparameter.ClientID%>').multipleSelect("refresh");
            $.unblockUI();

        }

      
        function deleterownew(itemid) {
            if (confirm("Do You Want To Delete This Data?")) {
                var id = $(itemid).closest('tr').find('#savedid').text();

                $.blockUI();
                jQuery.ajax({
                    url: "SigmaAnalysisMaster.aspx/deletedata",
                    data: '{ id: "' + id + '"}',
                    type: "POST",
                    timeout: 120000,
                  
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        $.unblockUI();
                        showmsg("Data Deleted..");
                        Addme();
                    },


                    error: function (xhr, status) {
                        alert("Error ");
                        $.unblockUI();
                    }
                });


            }
        }
    </script>

    <script type="text/javascript">
        function showmehead(ctrl) {

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

            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#chhead').prop('checked', true);
            }
            else {
                $(ctrl).closest('tr').find('#chhead').prop('checked', false);
            }
            checkall($(ctrl).closest('tr').find('#chhead'));
            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");
            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });
        }

        function showmechild(ctrl) {

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

            if ($(ctrl).val().length > 0) {
                $(ctrl).closest('tr').find('#ch').prop('checked',true);
            }
            else
            {
                $(ctrl).closest('tr').find('#ch').prop('checked', false);
            }


          
        }


        function clearForm() {
            $('#btnsave').hide();
            $('#<%=ddldepartment.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            jQuery('#<%=lsttestname.ClientID%> option').remove();
            jQuery('#<%=lsttestname.ClientID%>').multipleSelect("refresh");
            jQuery('#<%=lstparameter.ClientID%> option').remove();
            jQuery('#<%=lstparameter.ClientID%>').multipleSelect("refresh");
            $('#tbl tr').slice(1).remove();
            $('#txtaccepthead').val('');
        }

        function checkall(ctrl) {
            if ($(ctrl).is(':checked')) {
                $('#tbl tr').each(function () {

                    if ($(this).closest("tr").attr("id") != "trheader") {
                        $(this).closest("tr").find('#ch').prop('checked',true);
                    }
                });
            }
            else {
                $('#tbl tr').each(function () {

                    if ($(this).closest("tr").attr("id") != "trheader") {
                        $(this).closest("tr").find('#ch').prop('checked', false);
                    }
                });
            }
        }

        
    </script>
    <script type="text/javascript">

        function saveme() {
            var SigmaData = [];
            $('#tbl tr').each(function () {
                if ($(this).closest("tr").attr("id") != "trheader" && $(this).closest("tr").find('#ch').is(':checked')) {
                    var objectdata = new Object();
                    objectdata.LabObservationID = $(this).closest("tr").attr("id");
                    objectdata.LabObservationName = $(this).closest("tr").find("#parametername").text();
                    objectdata.CLIA = $(this).closest("tr").find("#txtaceept").val();
                    objectdata.SavedID = $(this).closest("tr").find("#savedid").text();
                    SigmaData.push(objectdata);
                }
            });

            if (SigmaData.length == 0) {
                showerrormsg("Please Select Data To Save");
            }

            $.blockUI();
            $.ajax({
                url: "SigmaAnalysisMaster.aspx/SaveData",
                data: JSON.stringify({ SigmaData: SigmaData }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    var save = result.d;
                    if (save == "1") {
                        showmsg("Record Saved Successfully");

                        Addme();
                    }
                    else {
                        showerrormsg(save);

                        // console.log(save);
                    }
                },
                error: function (xhr, status) {
                    $.unblockUI()
                    showerrormsg("Some Error Occure Please Try Again..!");

                    console.log(xhr.responseText);
                }
            });
        }

        function exporttoexcel() {

            jQuery.ajax({
                url: "SigmaAnalysisMaster.aspx/exporttoexcel",
                data: '{}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    if (result.d == "false") {
                        showerrormsg("No Item Found");
                        $.unblockUI();
                    }
                    else {
                        window.open('../Common/exporttoexcel.aspx');
                        $.unblockUI();
                    }

                },


                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
    </script>
</asp:Content>

