<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QualityQuestionAnswer.aspx.cs" Inherits="Design_Quality_QualityQuestionAnswer" %>

<!DOCTYPE html>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
</head>
<body>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
   
    <form id="form1" runat="server">
   <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>

    <div id="Pbody_box_inventory" style="width:1204px;height:550px;">
     <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align:center;">
                <table style="width:99%">
                   <tr>

                       <td width="40%">
                           <asp:Label ID="lbheader" runat="server" Font-Bold="true"></asp:Label>
                       </td>

                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid;background-color: lightpink;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td style="font-weight: 700">&nbsp;&nbsp;New</td>
                    
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid;background-color: lightgreen;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td style="font-weight: 700">&nbsp;&nbsp;Saved</td>

                     
                       <td width="40%">
                           <asp:Label ID="lbold" runat="server" Font-Bold="true" ForeColor="Maroon" />
                       </td>
                       
                    
                </tr>
                      </table>

                
                </div>
         </div>

        <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content">
                  <div style="height:450px;overflow:auto;">
                <table id="tbldata" style="width:99%;border-collapse:collapse;" rules="all" frame="box" border="1" cellspacing="5" cellpadding="5">
                    
                </table>
                      </div>
                </div>
            </div>
        <% if (Util.GetString(Request.QueryString["isapp"]) == "")
    
    {%>
         <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align:center;">
                <input type="button" value="Save" class="savebutton" onclick="savemeplease()" />

                &nbsp;&nbsp;
                <input type="button" value="Remove CheckList" class="resetbutton" onclick="removechecklist()" />
                 </div>
             </div>
        <%} %>
    </div>
    </form>

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

            getalldata();
        });
        function getalldata() {
            $('#tbldata tr').remove();
            var type = '<%=Util.GetString(Request.QueryString["type"])%>';
            var qctype = '<%=Util.GetString(Request.QueryString["qctype"])%>';
            var savedid = '<%=Util.GetString(Request.QueryString["macdataid"])%>';
            $.blockUI();
            jQuery.ajax({
                url: "QualityQuestionAnswer.aspx/bindquestionall",
                data: '{type:"' + type + '",qctype:"' + qctype + '",savedid:"' + savedid + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length == 0) {
                        showerrormsg("No "+type+" Check List Found For "+qctype);
                        $.unblockUI();
                        return;
                    }



                    var QuestionHead = "";
                    var Questionsaved = "";
                    var total = 1;
                    for (var i = 0; i <= PanelData.length - 1; i++) {

                        var mydata = "";
                        if (QuestionHead != PanelData[i].QuestionHead) {

                            mydata += '<tr style="background-color:gray;color:white;" id="qhead"><td colspan="3" style="font-weight:bold;" >';
                            mydata += "(" + total + ") " + PanelData[i].QuestionHead;
                            mydata += '</td></tr>';
                            total++;
                        }

                        mydata += '<tr style="background-color:lightyellow;" class="GridViewItemStyle" id=' + PanelData[i].questionid + '>';
                        mydata += '<td align="left" id="id" style="font-weight:bold;">' + parseInt(i + 1) + '</td>';
                       


                        mydata += '<td align="left" id="question" style="font-weight:bold;">' + PanelData[i].question + '</td>';
                        if (PanelData[i].ansid == "0") {
                            mydata += '<td align="left" id="answer" style="font-weight:bold;background-color:lightpink;width:300px;" id="ans" >';
                        }
                        else {
                            Questionsaved = "Last Saved on : " +PanelData[i].lastsaveddate +" By : " + PanelData[i].lastsavedby;
                            mydata += '<td align="left" id="answer" style="font-weight:bold;background-color:lightgreen;width:300px;" id="ans" >';
                        }
                        if (PanelData[i].answertype == "radio") {
                            for (var c = 0; c <= PanelData[i].answeroption.split(',').length - 1; c++) {
                                if (PanelData[i].savedanswer == PanelData[i].answeroption.split(',')[c]) {
                                    mydata += '<input checked="checked" type="radio" name="' + PanelData[i].questionid + '" value="' + PanelData[i].answeroption.split(',')[c] + '">' + PanelData[i].answeroption.split(',')[c];
                                }
                                else {
                                    mydata += '<input type="radio" name="' + PanelData[i].questionid + '" value="' + PanelData[i].answeroption.split(',')[c] + '">' + PanelData[i].answeroption.split(',')[c];
                                }
                            }
                        }
                        else if (PanelData[i].answertype == "checkbox") {
                            for (var c = 0; c <= PanelData[i].answeroption.split(',').length - 1; c++) {
                                mydata += '<input type="checkbox" value="' + PanelData[i].answeroption.split(',')[c] + '">' + PanelData[i].answeroption.split(',')[c];
                            }
                        }
                        else if (PanelData[i].answertype == "text") {
                            mydata += '<input type="text" style="width:295px;" maxlength="100" class="mytxt"/>';
                        }

                        mydata += '</td>';
                        mydata += '<td align="left" id="answertype" style="display:none;">' + PanelData[i].answertype + '</td>';
                        mydata += '<td align="left" id="ansid" style="display:none;">' + PanelData[i].ansid + '</td>';
                        mydata += '<td align="left" id="savedanswer" style="display:none;">' + PanelData[i].savedanswer + '</td>';
                        mydata += '</tr>';

                        $('#tbldata').append(mydata);

                        
                        QuestionHead = PanelData[i].QuestionHead;

                    }

                    $('#<%=lbold.ClientID%>').text(Questionsaved);
                    $.unblockUI();


                },
                error: function (xhr, status) {
                    $.unblockUI();
                    alert("Error ");
                }
            });
        }
    </script>

    <script type="text/javascript">
        function QuestionAnswerData() {

            var dataIm = new Array();
            $('#tbldata tr').each(function () {
                if ($(this).closest("tr").attr('id') != "qhead") {
                    var QData = new Object();
                    QData.QuestionID = $(this).closest("tr").attr('id');
                    QData.Question = $(this).closest("tr").find('#question').html();
                    QData.AnswerType = $(this).closest("tr").find('#answertype').html();
                    if (QData.AnswerType == "radio") {
                        QData.Answer = $('input[name="' + QData.QuestionID + '"]:checked').val();
                    }
                    else if (QData.AnswerType == "checkbox") {
                        var answer = "";
                        $('#' + QData.QuestionID).find(':checkbox').each(function () {
                            if ($(this).is(":checked")) {
                                answer += $(this).val() + ",";
                            }
                        });

                        QData.Answer = answer;

                    }
                    else if (QData.AnswerType == "text") {
                        QData.Answer = $(this).closest("tr").find('.mytxt').val();
                    }
                    QData.Type = '<%=Util.GetString(Request.QueryString["type"])%>';
                    QData.QCType = '<%=Util.GetString(Request.QueryString["qctype"])%>';
                    QData.SavedID = '<%=Util.GetString(Request.QueryString["macdataid"])%>';
                    if (QData.Answer != "" && QData.Answer != null) {
                        dataIm.push(QData);
                    }
                }
               
            });
            return dataIm;

        }
        function savemeplease() {
            if ($('#tbldata tr').length == 0) {
                showerrormsg("Nothing to Save Please Add CheckList..!");
                return;
            }

            var questiondata = QuestionAnswerData();


            if (questiondata.length == 0) {
                showerrormsg("Nothing to Save Please Add CheckList..!");
                return;
            }

            $.blockUI();
            $.ajax({
                url: "QualityQuestionAnswer.aspx/SaveQuestionAnswer",
                data: JSON.stringify({ questiondata: questiondata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $.unblockUI();
                    if (result.d == "1") {

                        showmsg("Quality CheckList Saved Successfully");
                        getalldata();

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

        function removechecklist() {

            if (confirm("Do you want to remove checklist?")) {
                $.blockUI();
                var Type = '<%=Util.GetString(Request.QueryString["type"])%>';
                var QCType = '<%=Util.GetString(Request.QueryString["qctype"])%>';
                var SavedID = '<%=Util.GetString(Request.QueryString["macdataid"])%>';
                $.ajax({
                    url: "QualityQuestionAnswer.aspx/RemoveQuestionAnswer",
                    data: JSON.stringify({ Type: Type, QCType: QCType, SavedID: SavedID }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        $.unblockUI();
                        if (result.d == "1") {

                            showmsg("Quality CheckList Removed Successfully");
                            getalldata();

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
        }
    </script>

</body>
</html>
