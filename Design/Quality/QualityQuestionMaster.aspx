<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="QualityQuestionMaster.aspx.cs" Inherits="Design_Quality_QualityQuestionMaster" %>
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

     <style type="text/css">

        #popup_box1 { 
    display:none; /* Hide the DIV */
    position:fixed;  
    _position:absolute; /* hack for internet explorer 6 */  
    height:400px;  
    width:1100px;  
    background:#FFFFFF;  
    left: 5%;
    top: 15%;
    z-index:100; /* Layering ( on-top of others), if you have lots of layers: I just maximized, you can change it yourself */
    margin-left: 15px;  
    
    /* additional features, can be omitted */
    border:2px solid #ff0000;      
    padding:15px;  
    font-size:14px;  
    -moz-box-shadow: 10px 10px pink;
    -webkit-box-shadow: 10px 10px pink;
    box-shadow: 10px 10px pink;
    border-radius:5px;
}
    </style> 


      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
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
                          <b>Quality Question Master</b>  

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
                        <td style="font-weight: 700;width:200px;">
                            QC Type :</td>
                        <td style="font-weight:bold;">
                             <input type="checkbox" id="chilc" name="mych"/>ILC &nbsp;&nbsp;
                            <input type="checkbox" id="cheqas" name="mych" />EQAS &nbsp;&nbsp;
                            <input type="checkbox" id="chqc" name="mych" />QC &nbsp;&nbsp;
                            <input type="checkbox" id="chcap" name="mych" />CAP &nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700;width:200px;">
                            Type :</td>
                        <td style="font-weight:bold;">
                           <input type="checkbox" id="chrca" name="mych" />RCA &nbsp;&nbsp;
                            <input type="checkbox" id="chca" name="mych" />Corrective Action &nbsp;&nbsp;
                            <input type="checkbox" id="chpa" name="mych" />Preventive Action &nbsp;&nbsp;
                         
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700;width:200px;">
                           Question Head :
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlquestionhead" runat="server" Width="400px"  class="ddlquestionhead chosen-select"></asp:DropDownList>
                            &nbsp;&nbsp;
                            <input type="button" value="Add" class="searchbutton" onclick="addhead()" />
                         
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Question :</td>
                        <td>
                              <asp:TextBox ID="txtquestion" runat="server" Width="700px" MaxLength="200">
                            </asp:TextBox>
                             <asp:TextBox ID="txtquestionid" runat="server" style="display:none;">
                            </asp:TextBox>
                            </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700">
                            Answer Type :</td>
                        <td>
                            <asp:DropDownList id="ddlanswercategory" onchange="addcategory();" runat="server">
                                 <asp:ListItem value="0">Select Answer Type</asp:ListItem>
                                 <asp:ListItem value="radio">Radio Button</asp:ListItem>
                                 <asp:ListItem value="checkbox">Check Box</asp:ListItem>
                                 <asp:ListItem value="text">Short Answer</asp:ListItem>
                             </asp:DropDownList> 

                        </td>
                    </tr>

                    <tr>
                        <td style="font-weight: 700;width:200px;">Answer Option:</td>
                        <td >

                        <div style="height:100px;overflow:auto;width:525px;">
                            <table id="tblanswer" frame="box" rules="all" border="1" style="border-collapse:collapse;background-color:lightyellow;" cellpadding="5" cellspacing="5" >
                                
                            </table>
                               </div>
                        </td>
                    </tr>
                </table>
                </div>
             </div>

          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content" style="text-align:center">
                <input type="button" value="Save" class="savebutton" onclick="saveme()" id="btnsave" />&nbsp;&nbsp;
                <input type="button" value="Update" class="savebutton" style="display:none;" onclick="updateme()" id="btnupdate" />&nbsp;&nbsp;
                <input type="button" value="Reset" class="resetbutton" onclick="resetmenow()" />
                </div>
              </div>


          <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div style="height:240px;overflow:auto;">
                     <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        <td class="GridViewHeaderStyle">QC Type</td>
                                        <td class="GridViewHeaderStyle">Type</td>
                                        <td class="GridViewHeaderStyle">Question</td>
                                        <td class="GridViewHeaderStyle">Answer</td>
                                        <td class="GridViewHeaderStyle">Entry Date</td>
                                        <td class="GridViewHeaderStyle">Entry By</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Edit</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;"></td>
                                     </tr>
                                 </table>
                    </div>
                </div>
              </div>
         </div>


    <div id="popup_box1">
            <img src="../../App_Images/Close.ico" onclick="unloadPopupBox()" style="position:absolute;right:-20px;top:-20px;width:36px;height:36px;cursor:pointer;" title="Close" alt="close" />
             
            <div class="POuter_Box_Inventory" style="width:1100px;background-color:papayawhip;">
              <div class="Purchaseheader">
                  Add New Qustion Head
            </div>
             <table  style="width:100%;border-collapse:collapse">
                 <tr>

                     <td>
                         <span style="font-weight:bold;color:maroon">Question Head :</span>  </td> 
<td>
                         <asp:TextBox ID="txtquestionhead" runat="server" Width="400px" MaxLength="100"></asp:TextBox>

    <asp:TextBox ID="txtquestionheadid" runat="server" style="display:none;" />
                       
                     </td>
                     


                 </tr>
                 <tr>
                     <td colspan="2" align="center">
                         <input type="button" value="Save" class="savebutton" onclick="savequestionhead()" id="btnsavequestionhead" />
                         &nbsp
                         <input type="button" value="Update" class="savebutton" onclick="updatequestionhead()" id="btnupdatequestionhead" style="display:none;" />

                     </td>
                 </tr>
                <tr>
                    <td colspan="2">
                         <div  style="width:1100px; max-height:100px;overflow:auto;">
                   <table id="tbloldheaddata" style="width:99%;border-collapse:collapse;text-align:left;">
                                     
                                 </table></div>

                    </td>
                </tr>

                
                 </table>
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


            bindquestionhead('0');
            bindquestiondata();

        });

        function bindquestionhead(type) {

            jQuery('#<%=ddlquestionhead.ClientID%> option').remove();
            $('#<%=ddlquestionhead.ClientID%>').trigger('chosen:updated');
                $.blockUI();
                $.ajax({
                    url: "QualityQuestionMaster.aspx/bindquestionhead",
                    data: '{}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,

                    dataType: "json",
                    success: function (result) {

                        CentreLoadListData = $.parseJSON(result.d);
                        if (CentreLoadListData.length == 0) {
                          
                            jQuery("#<%=ddlquestionhead.ClientID%>").append(jQuery('<option></option>').val("0").html("No Question Head Found Please Add"));
                            $("#<%=ddlquestionhead.ClientID%>").trigger('chosen:updated');
                            $.unblockUI();
                            return;
                        }

                        jQuery("#<%=ddlquestionhead.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Question Head"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlquestionhead.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].id).html(CentreLoadListData[i].QuestionHead));
                         }

                        if (type === "1") {
                            $('#<%=ddlquestionhead.ClientID%>').find('option:contains("' + $('#<%=txtquestionhead.ClientID%>').val() + '")').attr("selected", true);
                            $('#<%=txtquestionhead.ClientID%>').val('');
                        }
                         $("#<%=ddlquestionhead.ClientID%>").trigger('chosen:updated');
                         $.unblockUI();
                     },
                     error: function (xhr, status) {
                         //  alert(status + "\r\n" + xhr.responseText);
                         window.status = status + "\r\n" + xhr.responseText;
                         $.unblockUI();
                     }
                 });
             
        }


    </script>

    <script type="text/javascript">


        function addhead() {


            $('#popup_box1').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.5"
            });
            $('#<%=txtquestionhead.ClientID%>').val('');
            $("#Pbody_box_inventory :input").attr("disabled", true);
            bindquestionheadall();
            $('#btnsavequestionhead').show();
            $('#btnupdatequestionhead').hide();
        }

        function unloadPopupBox() {
            $('#popup_box1').fadeOut("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "1"
            });
            $("#Pbody_box_inventory :input").attr("disabled", false);
           
        }


        function savequestionhead() {
            if ($('#<%=txtquestionhead.ClientID%>').val() == "") {
                $('#<%=txtquestionhead.ClientID%>').focus();
                showerrormsg("Please Enter Question Head");
                return;
            }
            $.blockUI();
            $.ajax({
                url: "QualityQuestionMaster.aspx/SaveQuestionHead",
                data: JSON.stringify({ questionhead: $('#<%=txtquestionhead.ClientID%>').val() }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {

                        showmsg("Question Head Saved Successfully");
                        bindquestionhead('1');
                        unloadPopupBox();
                        


                    }
                    else if (result.d == "2") {

                        showerrormsg("Question Head Already Exist Please Enter New Question Head");

                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    console.log(xhr.responseText);
                }
            });

        }

        function updatequestionhead() {
            if ($('#<%=txtquestionhead.ClientID%>').val() == "") {
                  $('#<%=txtquestionhead.ClientID%>').focus();
                showerrormsg("Please Enter Question Head");
                return;
            }
            $.blockUI();
            $.ajax({
                url: "QualityQuestionMaster.aspx/UpdateQuestionHead",
                data: JSON.stringify({ questionhead: $('#<%=txtquestionhead.ClientID%>').val(),questionheadid: $('#<%=txtquestionheadid.ClientID%>').val() }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {

                        showmsg("Question Head Update Successfully");
                        bindquestionhead('1');
                        unloadPopupBox();



                    }
                    else if (result.d == "2") {

                        showerrormsg("Question Head Already Exist Please Enter New Question Head");

                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    console.log(xhr.responseText);
                }
            });

        }
       


        function bindquestionheadall() {

            $('#tbloldheaddata tr').remove();
            $.blockUI();
            jQuery.ajax({
                url: "QualityQuestionMaster.aspx/bindquestionheadall",
                data: '{}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $.unblockUI();
                        return;
                    }
                    var mydata = "";
                    mydata += '<tr id="trheader">';

                    mydata += '<td class="GridViewHeaderStyle">#</td>';
                    mydata += '<td class="GridViewHeaderStyle">Question Head</td>';
                    mydata += '<td class="GridViewHeaderStyle">Entry Date</td>';
                    mydata += '<td class="GridViewHeaderStyle">Entry By</td>';
                    mydata += '<td class="GridViewHeaderStyle">Edit</td>';
                    mydata += '</tr>';


                    $('#tbloldheaddata').append(mydata);

                    for (var i = 0; i <= PanelData.length - 1; i++) {

                        var mydata = '<tr style="background-color:lightgreen;" class="GridViewItemStyle" id=' + PanelData[i].id + '>';
                        mydata += '<td align="left" id="id" style="font-weight:bold;">' +parseInt(i+1) + '</td>';
                        mydata += '<td align="left" id="QuestionHead" style="font-weight:bold;">' + PanelData[i].QuestionHead + '</td>';
                        mydata += '<td align="left" id="EntryDate" style="font-weight:bold;">' + PanelData[i].EntryDate + '</td>';
                        mydata += '<td align="left" id="EntryByName" style="font-weight:bold;">' + PanelData[i].EntryByName + '</td>';
                        mydata += '<td><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="edithead(this)"/></td>';
                        mydata += '</tr>';

                        $('#tbloldheaddata').append(mydata);


                    }
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert("Error ");
                }
            });

        }

        function edithead(ctrl) {
            $('#btnsavequestionhead').hide();
            $('#btnupdatequestionhead').show();
            $('#<%=txtquestionhead.ClientID%>').val($(ctrl).closest('tr').find('#QuestionHead').html());
            $('#<%=txtquestionheadid.ClientID%>').val($(ctrl).closest('tr').attr('id'));
        }

    </script>
    <script type="text/javascript">


        function addcategory() {
            $('#tblanswer tr').remove();
            if ($('#<%=ddlanswercategory.ClientID%>').val() != "0") {
                $.blockUI();

                if ($('#<%=ddlanswercategory.ClientID%>').val() == "radio") {
                    var mydata = "<tr>";
                   
                    mydata += "<td><input type='radio' disabled='disabled'/></td>";
                    mydata += "<td><input type='text' style='width:400px' maxlength='100' class='mytxt'/></td>";
                    mydata += "<td><img src='../../App_Images/ButtonAdd.png' style='cursor:pointer;' onclick='addme(this);'/></td>";
                    mydata += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deleterow(this)'/></td>";
                    mydata += "</tr>";
                    $('#tblanswer').append(mydata);
                }

                else if ($('#<%=ddlanswercategory.ClientID%>').val() == "checkbox") {
                    var mydata = "<tr>";
                   
                    mydata += "<td><input type='checkbox' disabled='disabled'/></td>";
                    mydata += "<td><input type='text' style='width:400px' maxlength='100' class='mytxt'/></td>";
                    mydata += "<td><img src='../../App_Images/ButtonAdd.png' style='cursor:pointer;' onclick='addme(this);'/></td>";
                    mydata += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deleterow(this)' /></td>";
                    mydata += "</tr>";
                    $('#tblanswer').append(mydata);
                }

                else if ($('#<%=ddlanswercategory.ClientID%>').val() == "text") {
                    var mydata = "<tr>";
                  
                    
                    mydata += "<td><input type='text' style='width:400px' maxlength='400' disabled='disabled' class='mytxt' value='Short Answer' /></td>";
                  
                    mydata += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deleterow(this)'/></td>";
                    mydata += "</tr>";
                    $('#tblanswer').append(mydata);
                }
                $.unblockUI();
            }
        }

        function addme(ctrl) {
            var $tr = $(ctrl).closest("tr");
            var $clone = $tr.clone();
            $clone.find(':text').val('');
            $tr.after($clone);
        }

        function deleterow(ctrl) {
            $(ctrl).closest("tr").remove();
        }

        function resetmenow() {
            jQuery('#<%=ddlquestionhead.ClientID%>').prop('selectedIndex', 0).trigger('chosen:updated');
            $('#<%=txtquestion.ClientID%>').val('');
            $('#<%=ddlanswercategory.ClientID%>').val('0');
            $('#tblanswer tr').remove();
            $('#btnsave').show();
            $('#btnupdate').hide();
            $('#<%=txtquestionid.ClientID%>').val('');

            $('input[name="mych"]').each(function () {
                this.checked = false;
            });
           
        }
    </script>

    <script type="text/javascript">

        function getquestiondata() {
            var dataIm = new Array();
            $('#tblanswer tr').each(function () {
                var QData = new Object();
                QData.QuestionHeadID = $('#<%=ddlquestionhead.ClientID%>').val();
                QData.Question = $('#<%=txtquestion.ClientID%>').val();
                QData.AnswerType = $('#<%=ddlanswercategory.ClientID%>').val();
                QData.AnswerOption = $(this).closest("tr").find('.mytxt').val();
                

                QData.RCA = $('#chrca').is(':checked') ? 1 : 0;
                QData.CorrectiveAction = $('#chca').is(':checked') ? 1 : 0;
                QData.PreventiveAction = $('#chpa').is(':checked') ? 1 : 0;
                QData.ILC = $('#chilc').is(':checked') ? 1 : 0;
                QData.EQAS = $('#cheqas').is(':checked') ? 1 : 0;
                QData.QC = $('#chqc').is(':checked') ? 1 : 0;
                QData.CAP = $('#chcap').is(':checked') ? 1 : 0;

                QData.QuestionID = $('#<%=txtquestionid.ClientID%>').val();

                dataIm.push(QData);
            });
            return dataIm;
        }

        function saveme() {
            if (!$('#chilc').is(':checked') && !$('#cheqas').is(':checked') && !$('#chqc').is(':checked') && !$('#chcap').is(':checked')) {
                $('#chilc').focus();
                showerrormsg("Please Select Atleast 1 QC Type");
                return;
            }
        
            if (!$('#chrca').is(':checked') && !$('#chca').is(':checked') && !$('#chpa').is(':checked')) {
                $('#chrca').focus();
                showerrormsg("Please Select Atleast 1 Type");
                return;
            }
           
            if ($('#<%=ddlquestionhead.ClientID%>').val() == "0") {
                showerrormsg("Please Select Question Head");
                $('#<%=ddlquestionhead.ClientID%>').focus();
                return;
            }
           
            if ($('#<%=txtquestion.ClientID%>').val() == "") {
                showerrormsg("Please Enter Question");
                $('#<%=txtquestion.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlanswercategory.ClientID%>').val() == "0") {
                showerrormsg("Please Select Answer Category");
                $('#<%=ddlanswercategory.ClientID%>').focus();
                return;
            }

            if ($('#tblanswer tr').length == 0) {
                showerrormsg("Please Add Answer..!");
                return;
            }
            var ans = 0;
            $('#tblanswer tr').each(function () {
                if ($(this).closest("tr").find('.mytxt').val() == "") {
                    ans = 1;
                    $(this).closest("tr").find('.mytxt').focus();
                    return;
                }
            });

            if (ans == 1) {
                showerrormsg("Please Enter Answer Option..!");
                return;
            }

            var questiondata = getquestiondata();


            if (questiondata.length == 0) {
                showerrormsg("Please Select Answer Category");
                return;
            }

            $.blockUI();
            $.ajax({
                url: "QualityQuestionMaster.aspx/SaveQuestion",
                data: JSON.stringify({ questiondata: questiondata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {

                        showmsg("Quality Question Saved Successfully");
                        resetmenow();
                        bindquestiondata()
                      
                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    console.log(xhr.responseText);
                }
            });
        }
    </script>

    <script type="text/javascript">

        function bindquestiondata() {
            $('#tblitemlist tr').slice(1).remove();
            $.blockUI();
            jQuery.ajax({
                url: "QualityQuestionMaster.aspx/bindquestionall",
                data: '{}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        $.unblockUI();
                        return;
                    }
                  


                    var QuestionHead = "";
                    var total = 1;
                    for (var i = 0; i <= PanelData.length - 1; i++) {

                        var mydata = "";
                        if (QuestionHead != PanelData[i].QuestionHead) {

                            mydata += '<tr style="background-color:gray;color:white;"><td colspan="3"></td><td colspan="6" style="font-weight:bold;">';
                            mydata +="("+total+") "+ PanelData[i].QuestionHead;
                            mydata += '</td></tr>';
                            total++;
                        }

                        mydata += '<tr style="background-color:lightyellow;" class="GridViewItemStyle" id=' + PanelData[i].questionid + '>';
                        mydata += '<td align="left" id="id" style="font-weight:bold;">' + parseInt(i + 1) + '</td>';
                        mydata += '<td align="left" id="qctype" style="font-weight:bold;">';
                        if (PanelData[i].ilc == "1")
                            mydata += 'ILC ';
                        if (PanelData[i].eqas == "1")
                            mydata += ', EQAS ';
                        if (PanelData[i].qc == "1")
                            mydata += ', QC ';
                        if (PanelData[i].cap == "1")
                            mydata += ', CAP';

                        mydata += '</td>';

                        mydata += '<td align="left" id="type" style="font-weight:bold;">';
                        if (PanelData[i].rca == "1")
                            mydata += 'RCA ';
                        if (PanelData[i].CorrectiveAction == "1")
                            mydata += ', CorrectiveAction ';
                        if (PanelData[i].PreventiveAction == "1")
                            mydata += ', PreventiveAction ';
                       
                        mydata += '</td>';

                      
                        mydata += '<td align="left" id="question" style="font-weight:bold;">' + PanelData[i].question + '</td>';
                        mydata += '<td align="left" id="answer" style="font-weight:bold;">';
                        if (PanelData[i].answertype == "radio") {
                            for (var c = 0; c <= PanelData[i].answeroption.split(',').length-1; c++) {
                                mydata += '<input type="radio" disabled="disabled" >' + PanelData[i].answeroption.split(',')[c];
                            }
                        }
                        else if (PanelData[i].answertype == "checkbox")
                        {
                            for (var c = 0; c <= PanelData[i].answeroption.split(',').length-1; c++) {
                                mydata += '<input type="checkbox" disabled="disabled" >' + PanelData[i].answeroption.split(',')[c];
                            }
                        }
                        else if (PanelData[i].answertype == "text") {
                            mydata += 'Short Answer';
                        }

                        mydata += '</td>';

                        mydata += '<td align="left" id="EntryDate" style="font-weight:bold;">' + PanelData[i].EntryDate + '</td>';
                        mydata += '<td align="left" id="EntryByName" style="font-weight:bold;">' + PanelData[i].EntryByName + '</td>';
                        mydata += '<td><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="editthis(this)"/></td>';
                        mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deletethis(this)"/></td>';

                        mydata += '<td align="left" id="QuestionHeadid" style="display:none;">' + PanelData[i].QuestionHeadid + '</td>';
                        mydata += '<td align="left" id="answertype" style="display:none;">' + PanelData[i].answertype + '</td>';
                        mydata += '<td align="left" id="answeroption" style="display:none;">' + PanelData[i].answeroption + '</td>';
                        mydata += '<td align="left" id="rca" style="display:none;">' + PanelData[i].rca + '</td>';
                        mydata += '<td align="left" id="CorrectiveAction" style="display:none;">' + PanelData[i].CorrectiveAction + '</td>';
                        mydata += '<td align="left" id="PreventiveAction" style="display:none;">' + PanelData[i].PreventiveAction + '</td>';
                        mydata += '<td align="left" id="ilc" style="display:none;">' + PanelData[i].ilc + '</td>';
                        mydata += '<td align="left" id="eqas" style="display:none;">' + PanelData[i].eqas + '</td>';
                        mydata += '<td align="left" id="qc" style="display:none;">' + PanelData[i].qc + '</td>';
                        mydata += '<td align="left" id="cap" style="display:none;">' + PanelData[i].cap + '</td>';
                        mydata += '</tr>';

                        $('#tblitemlist').append(mydata);
                        QuestionHead = PanelData[i].QuestionHead;

                    }
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert("Error ");
                }
            });
        }

        function deletethis(ctrl) {

            if (confirm("Do You Want To Delete This Question?")) {
                $.blockUI();
                jQuery.ajax({
                    url: "QualityQuestionMaster.aspx/deletequestion",
                    data: '{questionid:"' + $(ctrl).closest('tr').attr('id') + '"}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        $.unblockUI();
                        if (result.d == "1") {
                            $(ctrl).closest('tr').remove();
                        }



                    },
                    error: function (xhr, status) {
                        $.unblockUI();
                        alert("Error ");
                    }
                });
            }
        }

        function editthis(ctrl) {
            $('#<%=txtquestionid.ClientID%>').val($(ctrl).closest('tr').attr('id'));
            $('#<%=txtquestion.ClientID%>').val($(ctrl).closest('tr').find('#question').html());
            $('#<%=ddlquestionhead.ClientID%>').val($(ctrl).closest('tr').find('#QuestionHeadid').html()).trigger('chosen:updated');
            $('#<%=ddlanswercategory.ClientID%>').val($(ctrl).closest('tr').find('#answertype').html());



            if ($(ctrl).closest('tr').find('#answertype').html() == "radio") {
                $('#tblanswer tr').remove();
                for (var c = 0; c <= $(ctrl).closest('tr').find('#answeroption').html().split(',').length - 1; c++) {
                    var mydata = "<tr>";

                    mydata += "<td><input type='radio' disabled='disabled'/></td>";
                    mydata += "<td><input type='text' style='width:400px' maxlength='100' class='mytxt' value='" + $(ctrl).closest('tr').find('#answeroption').html().split(',') [c]+ "'/></td>";
                    mydata += "<td><img src='../../App_Images/ButtonAdd.png' style='cursor:pointer;' onclick='addme(this);'/></td>";
                    mydata += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deleterow(this)'/></td>";
                    mydata += "</tr>";
                    $('#tblanswer').append(mydata);
                }


            }

            else if ($(ctrl).closest('tr').find('#answertype').html() == "checkbox") {
                $('#tblanswer tr').remove();
                for (var c = 0; c <= $(ctrl).closest('tr').find('#answeroption').html().split(',').length - 1; c++) {
                    var mydata = "<tr>";

                    mydata += "<td><input type='checkbox' disabled='disabled'/></td>";
                    mydata += "<td><input type='text' style='width:400px' maxlength='100' class='mytxt' value='" + $(ctrl).closest('tr').find('#answeroption').html().split(',')[c] + "'/></td>";
                    mydata += "<td><img src='../../App_Images/ButtonAdd.png' style='cursor:pointer;' onclick='addme(this);'/></td>";
                    mydata += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deleterow(this)'/></td>";
                    mydata += "</tr>";
                    $('#tblanswer').append(mydata);
                }
            }
            else if ($(ctrl).closest('tr').find('#answertype').html() == "text") {
                $('#tblanswer tr').remove();
                var mydata = "<tr>";
                mydata += "<td><input type='text' style='width:400px' maxlength='400' disabled='disabled' class='mytxt' value='Short Answer' /></td>";
                mydata += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deleterow(this)'/></td>";
                mydata += "</tr>";
                $('#tblanswer').append(mydata);
            }



            if ($(ctrl).closest('tr').find('#ilc').html() == "1") {
                $('#chilc').prop("checked", true);
            }
            else {
                $('#chilc').prop("checked", false);
            }

            if ($(ctrl).closest('tr').find('#eqas').html() == "1") {
                $('#cheqas').prop("checked", true);
            }
            else {
                $('#cheqas').prop("checked", false);
            }

            if ($(ctrl).closest('tr').find('#qc').html() == "1") {
                $('#chqc').prop("checked", true);
            }
            else {
                $('#chqc').prop("checked", false);
            }

            if ($(ctrl).closest('tr').find('#cap').html() == "1") {
                $('#chcap').prop("checked", true);
            }
            else {
                $('#chcap').prop("checked", false);
            }

            if ($(ctrl).closest('tr').find('#rca').html() == "1") {
                $('#chrca').prop("checked", true);
            }
            else {
                $('#chrca').prop("checked", false);
            }

            if ($(ctrl).closest('tr').find('#CorrectiveAction').html() == "1") {
                $('#chca').prop("checked", true);
            }
            else {
                $('#chca').prop("checked", false);
            }

            if ($(ctrl).closest('tr').find('#PreventiveAction').html() == "1") {
                $('#chpa').prop("checked", true);
            }
            else {
                $('#chpa').prop("checked", false);
            }
            $('#btnsave').hide();
            $('#btnupdate').show();
        }
    </script>



    <script type="text/javascript">
        function updateme() {
            if (!$('#chilc').is(':checked') && !$('#cheqas').is(':checked') && !$('#chqc').is(':checked') && !$('#chcap').is(':checked')) {
                $('#chilc').focus();
                showerrormsg("Please Select Atleast 1 QC Type");
                return;
            }

            if (!$('#chrca').is(':checked') && !$('#chca').is(':checked') && !$('#chpa').is(':checked')) {
                $('#chrca').focus();
                showerrormsg("Please Select Atleast 1 Type");
                return;
            }


            if ($('#<%=ddlquestionhead.ClientID%>').val() == "0") {
                showerrormsg("Please Select Question Head");
                $('#<%=ddlquestionhead.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtquestion.ClientID%>').val() == "") {
                showerrormsg("Please Enter Question");
                $('#<%=txtquestion.ClientID%>').focus();
                return;
            }
            if ($('#<%=ddlanswercategory.ClientID%>').val() == "0") {
                showerrormsg("Please Select Answer Category");
                $('#<%=ddlanswercategory.ClientID%>').focus();
                return;
            }

            if ($('#tblanswer tr').length == 0) {
                showerrormsg("Please Add Answer..!");
                return;
            }
            var ans = 0;
            $('#tblanswer tr').each(function () {
                if ($(this).closest("tr").find('.mytxt').val() == "") {
                    ans = 1;
                    $(this).closest("tr").find('.mytxt').focus();
                    return;
                }
            });

            if (ans == 1) {
                showerrormsg("Please Enter Answer Option..!");
                return;
            }

            var questiondata = getquestiondata();


            if (questiondata.length == 0) {
                showerrormsg("Please Select Answer Category");
                return;
            }

            $.blockUI();
            $.ajax({
                url: "QualityQuestionMaster.aspx/UpdateQuestion",
                data: JSON.stringify({ questiondata: questiondata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {

                        showmsg("Quality Question Update Successfully");
                        resetmenow();
                        bindquestiondata()

                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    console.log(xhr.responseText);
                }
            });
        }
    </script>
</asp:Content>

