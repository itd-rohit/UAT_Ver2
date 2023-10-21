<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="WestgardRuleMaster.aspx.cs" Inherits="Design_Quality_WestgardRuleMaster" %>
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
    <style type="text/css">
          .chosen-container {width:270px  !important;}

            .selected {
            background-color:aqua !important;
           border:2px solid black;
        }
        
        .imge {
            height: 30px;
            width: 40px;
        }
        
    </style>
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
                          <b>Westgrad Rule Master</b>  

                            <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                    </table>
                </div>
              </div>


              <div class="POuter_Box_Inventory" style="width:1300px;">

               <div class="Purchaseheader">Apply Type</div>
                <div class="content">
                    <table style="width:99%">

                        <tr>
                            <td width="15%">
                                <asp:RadioButtonList id="rdappytype" runat="server" RepeatDirection="Horizontal" style="font-weight: 700" onchange="setapplyType();">
                                    <asp:ListItem value="1" Selected="True">Default</asp:ListItem>
                                    <asp:ListItem value="0">Specific</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>

                            <td id="tdcentre" style="display:none;">
                              <b>Centre :</b>  <asp:DropDownList ID="ddlprocessinglab" runat="server" class="ddlprocessinglab chosen-select chosen-container" Width="270" onchange="bindmachine()"></asp:DropDownList>
                                &nbsp;<b> Machine :</b>
                                <asp:DropDownList ID="ddlmachine" runat="server" class="ddlmachine chosen-select chosen-container" Width="270" onchange="bindparameter()"> 
                                </asp:DropDownList> 
                                &nbsp;<b> Parameter :</b>

                                 <asp:DropDownList ID="ddlparameter" runat="server" class="ddlmachine chosen-select chosen-container" Width="270" onchange="getdata()"> 
                                </asp:DropDownList> 
                            </td>
                        </tr>
                    </table>
                    </div>
                  </div>
               <div class="POuter_Box_Inventory" style="width:1300px;">

               <div class="Purchaseheader">Rule Detail</div>
                <div class="content">
                   
             
                <table width="49%" style="float:left;border:1px solid;" id="tbl">
                      <tr id="1-2s">
                        <td width="100px"><input type="button" id="btn12s" value="1-2s" style="font-weight:bold;cursor:pointer;width:70px;" onclick="getruledata('1-2s',this)" />
                        
                        </td>
                        <td width="60px">
                            <img class="imge" src="../../App_Images/Approved.jpg" style="display:none;"  />
                        </td>
                        <td>
                           <asp:RadioButtonList ID="rd12s"  class="myradio" runat="server" RepeatDirection="Horizontal">
                               <asp:ListItem Value="Fail">Fail</asp:ListItem>
                               <asp:ListItem Value="Warn">Warn</asp:ListItem>
                               <asp:ListItem Value="Off" Selected="True">Off</asp:ListItem>
                           </asp:RadioButtonList>
                        </td>

                          <td>
                                  <input type="checkbox" checked="checked" id="CheckLevel" /><strong>Warn if Level2 Available
                        </strong>
                          </td>
                        
                    </tr>

                      <tr id="1-3s">
                        <td><input type="button" id="btn13s" value="1-3s" style="font-weight:bold;cursor:pointer;width:70px;" onclick="getruledata('1-3s', this)" /> </td>
                        <td>     <img class="imge" src="../../App_Images/Approved.jpg" style="display:none;"  /></td>
                        <td>
                           <asp:RadioButtonList ID="rd13s"  class="myradio" runat="server" RepeatDirection="Horizontal">
                                 <asp:ListItem Value="Fail">Fail</asp:ListItem>
                               <asp:ListItem Value="Warn">Warn</asp:ListItem>
                               <asp:ListItem Value="Off" Selected="True">Off</asp:ListItem>
                           </asp:RadioButtonList>
                        </td>
                          <td></td>
                        
                    </tr>

                      <tr id="2-2s">
                        <td><input type="button" id="btn22s" value="2-2s" style="font-weight:bold;cursor:pointer;width:70px;" onclick="getruledata('2-2s', this)" /> </td>
                        <td>      <img class="imge" src="../../App_Images/Approved.jpg" style="display:none;"  /></td>
                        <td>
                           <asp:RadioButtonList ID="rd22s"  class="myradio" runat="server" RepeatDirection="Horizontal">
                                 <asp:ListItem Value="Fail">Fail</asp:ListItem>
                               <asp:ListItem Value="Warn">Warn</asp:ListItem>
                               <asp:ListItem Value="Off" Selected="True">Off</asp:ListItem>
                           </asp:RadioButtonList>
                        </td>
                           <td></td>
                    </tr>

                      <tr id="R-4s">
                        <td><input type="button" id="btnR4s" value="R-4s" style="font-weight:bold;cursor:pointer;width:70px;" onclick="getruledata('R-4s', this)" /> </td>
                        <td>      <img class="imge" src="../../App_Images/Approved.jpg" style="display:none;"  /></td>
                        <td>
                           <asp:RadioButtonList ID="rdR4s"  class="myradio" runat="server" RepeatDirection="Horizontal">
                                 <asp:ListItem Value="Fail">Fail</asp:ListItem>
                               <asp:ListItem Value="Warn">Warn</asp:ListItem>
                               <asp:ListItem Value="Off" Selected="True">Off</asp:ListItem>
                           </asp:RadioButtonList>
                        </td>
                           <td></td>
                    </tr>

                      <tr id="8-x">
                        <td><input type="button" id="btn8x" value="8-x" style="font-weight:bold;cursor:pointer;width:70px;"  onclick="getruledata('8-x', this)" /> </td>
                        <td>      <img class="imge" src="../../App_Images/Approved.jpg" style="display:none;"  /></td>
                        <td>
                           <asp:RadioButtonList ID="rd8x"  class="myradio" runat="server" RepeatDirection="Horizontal">
                                 <asp:ListItem Value="Fail">Fail</asp:ListItem>
                               <asp:ListItem Value="Warn">Warn</asp:ListItem>
                               <asp:ListItem Value="Off" Selected="True">Off</asp:ListItem>
                           </asp:RadioButtonList>
                        </td>
                           <td></td>
                    </tr>

                      <tr id="10-x">
                        <td><input type="button" id="btn10x"  value="10-x" style="font-weight:bold;cursor:pointer;width:70px;" onclick="getruledata('10-x', this)" /> </td>
                        <td>      <img class="imge" src="../../App_Images/Approved.jpg" style="display:none;"  /></td>
                        <td>
                           <asp:RadioButtonList ID="rd10x"  class="myradio" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="Fail">Fail</asp:ListItem>
                               <asp:ListItem Value="Warn">Warn</asp:ListItem>
                               <asp:ListItem Value="Off" Selected="True">Off</asp:ListItem>
                           </asp:RadioButtonList>
                        </td>
                           <td></td>
                    </tr>
                    </table>
                <table width="49%" style="float:right;background-color:white;border:1px solid;display:none;" id="tbl1">
                    <tr>
                         <td style="width:50%;padding:10px;text-align:justify;" valign="top">
                            <span id="spnruleinfo"></span>
                        </td>
                        <td valign="top">
                            <img   id="imagerule" alt="" />
                        </td>
                    </tr>
                    </table>
                    </div>
            </div>

           <div class="POuter_Box_Inventory" style="width:1300px;">

              
                <div class="content" style="text-align:center;">
                    <input type="button" value="Save" class="savebutton" onclick="saverule()" />

                    <input type="button" value="Reset" class="resetbutton" onclick="resetrule()" />
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

            getdata();
            bindmachine();

        });

        function bindmachine() {
            var labid = $('#<%=ddlprocessinglab.ClientID%>').val();
             jQuery('#<%=ddlmachine.ClientID%> option').remove();
             $('#<%=ddlmachine.ClientID%>').trigger('chosen:updated');

             if (labid != "0" && labid != null) {


                 //$.blockUI();
                 $.ajax({
                     url: "WestgardRuleMaster.aspx/bindmachine",
                     data: '{labid: "' + labid + '"}',
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,

                     dataType: "json",
                     success: function (result) {

                         CentreLoadListData = $.parseJSON(result.d);
                         if (CentreLoadListData.length == 0) {
                             showerrormsg("No Machine Found");
                         }

                         jQuery("#<%=ddlmachine.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Machine"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlmachine.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].MacID).html(CentreLoadListData[i].machinename));
                         }

                         $("#<%=ddlmachine.ClientID%>").trigger('chosen:updated');





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

        function bindparameter() {
            var macid = $('#<%=ddlmachine.ClientID%>').val();
            jQuery('#<%=ddlparameter.ClientID%> option').remove();
            $('#<%=ddlparameter.ClientID%>').trigger('chosen:updated');

            if (macid != "0" && macid != null) {


                //$.blockUI();
                $.ajax({
                    url: "WestgardRuleMaster.aspx/bindparameter",
                    data: '{macid: "' + macid + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,

                    dataType: "json",
                    success: function (result) {

                        CentreLoadListData = $.parseJSON(result.d);
                        if (CentreLoadListData.length == 0) {
                            showerrormsg("No Parameter Found");
                        }

                        jQuery("#<%=ddlparameter.ClientID%>").append(jQuery('<option></option>').val("0").html("Select Parameter"));
                         for (i = 0; i < CentreLoadListData.length; i++) {

                             jQuery("#<%=ddlparameter.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].LabObservation_ID).html(CentreLoadListData[i].PatameterName));
                         }

                         $("#<%=ddlparameter.ClientID%>").trigger('chosen:updated');





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

        function getruledata(rulename,ctrl) {

            //$.blockUI();
           
            $.ajax({
                url: "WestgardRuleMaster.aspx/getruledata",
                data: '{rulename:"' + rulename + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {

                        //$.unblockUI();

                    }
                    else {
                       
                        $('#spnruleinfo').html(ItemData[0].ruleinfo);
                        $('#imagerule').attr("src", ItemData[0].ruleimage);
                        //$.unblockUI();
                        $("#tbl tr").removeClass("selected");
                        $(ctrl).closest('tr').addClass('selected');
                        $('#tbl1').show();

                    }

                },
                error: function (xhr, status) {

                    //$.unblockUI();

                }
            });
        }
   
        function resetcentre() {

            $("#<%=ddlprocessinglab.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
            $('#<%=ddlmachine.ClientID%> option').remove();
            $("#<%=ddlmachine.ClientID%>").prop('selectedIndex', 0).attr("disabled", false).trigger('chosen:updated');
            $('#<%=ddlparameter.ClientID%> option').remove();
            $('#<%=ddlparameter.ClientID%>').attr("disabled", false).trigger('chosen:updated');
        }

        function setapplyType() {

            if ($("#<%=rdappytype.ClientID%>").find(":checked").val() == "1") {
                $('#tdcentre').hide();
                resetcentre();
                getdata();
             

            }
            else {
                $('#tdcentre').show();
                $('#tbl tr').each(function () {
                    $(this).closest("tr").find('.imge').hide();
                    $(this).closest("tr").find("#CheckLevel").prop('checked', true);
                    $(this).closest("tr").find('.myradio').find("input[value='Off']").prop("checked", true);
                });
                resetcentre();
            }
        }


        function resetrule() {
            $("#tbl tr").removeClass("selected");
            $('#tbl1').hide();
            $('#spnruleinfo').html('');
            $('#imagerule').attr("src", '');
            $('#<%=rdappytype.ClientID %>').find("input[value='1']").prop("checked", true);
            
            
            setapplyType();
        }

        function getdatatosave() {

            var dataIm = new Array();
            $('#tbl tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != null) {
                   
                    var objcontroldata = new Object();
                    objcontroldata.IsDefault = $("#<%=rdappytype.ClientID%>").find(":checked").val();
                    if ($("#<%=rdappytype.ClientID%>").find(":checked").val() == "0") {
                        objcontroldata.CentreID = $('#<%=ddlprocessinglab.ClientID%>').val();
                        objcontroldata.MachineID = $('#<%=ddlmachine.ClientID%>').val();
                        objcontroldata.LabObservation_ID = $('#<%=ddlparameter.ClientID%>').val();
                    }
                    else {
                        objcontroldata.CentreID = "0";
                        objcontroldata.MachineID = "";
                        objcontroldata.LabObservation_ID = "0";
                    }
                    objcontroldata.RuleName = id;
                    objcontroldata.RuleAction = $(this).closest("tr").find(".myradio").find(":checked").val();
                    if (id == '1-2s') {
                        objcontroldata.CheckLevel = $(this).closest("tr").find("#CheckLevel").prop('checked') == true ? 1 : 0;
                    }
                    else {
                        objcontroldata.CheckLevel = 0;
                    }
                    dataIm.push(objcontroldata);
                }
            });

           
            return dataIm;
        }

        function saverule() {

            if ($("#<%=rdappytype.ClientID%>").find(":checked").val() == "0" && $('#<%=ddlprocessinglab.ClientID%>').val() == "0") {
                showerrormsg("Please Select Centre");
                return;
            }

            if ($("#<%=rdappytype.ClientID%>").find(":checked").val() == "0" && $('#<%=ddlmachine.ClientID%>').val() == "0") {
                showerrormsg("Please Select Machine");
                return;
            }

            if ($("#<%=rdappytype.ClientID%>").find(":checked").val() == "0" && $('#<%=ddlparameter.ClientID%>').val() == "0") {
                showerrormsg("Please Select Parameter");
                return;
            }
            var ruledata = getdatatosave();
          
            //$.blockUI();
            $.ajax({
                url: "WestgardRuleMaster.aspx/SaveData",
                data: JSON.stringify({ ruledata: ruledata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    var save = result.d;
                    if (save == "1") {
                        showmsg("Record Saved Successfully");

                        getdata();

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


        function getdata() {
            //$.blockUI();
            $.ajax({
                url: "WestgardRuleMaster.aspx/getdata",
                data: '{isdefault:"' + $("#<%=rdappytype.ClientID%>").find(":checked").val() + '",centreid:"' + $('#<%=ddlprocessinglab.ClientID%>').val() + '",machineid:"' + $('#<%=ddlmachine.ClientID%>').val() + '",parameterid:"' + $('#<%=ddlparameter.ClientID%>').val() + '"}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        $('#tbl tr').each(function () {
                            $(this).closest("tr").find('.imge').hide();
                            $(this).closest("tr").find("#CheckLevel").prop('checked', true);
                            $(this).closest("tr").find('.myradio').find("input[value='Off']").prop("checked", true);
                        });
                       
                        //$.unblockUI();

                    }
                    else {

                      
                        for (i = 0; i < ItemData.length; i++) {

                            $('#' + ItemData[i].rulename).closest("tr").find('.myradio').find("input[value='" + ItemData[i].ruleaction + "']").prop("checked", true);
                            if (ItemData[i].ruleaction != "Off") {
                                $('#' + ItemData[i].rulename).closest("tr").find('.imge').show();
                            }
                            else {
                                $('#' + ItemData[i].rulename).closest("tr").find('.imge').hide();
                            }
                           
                            if (ItemData[i].checklevel == "1") {
                                $('#' + ItemData[i].rulename).closest("tr").find("#CheckLevel").prop('checked', true);
                            }
                            else {
                                $('#' + ItemData[i].rulename).closest("tr").find("#CheckLevel").prop('checked', false);
                            }
                        }

                        //$.unblockUI();
                    }

                },
                error: function (xhr, status) {

                    //$.unblockUI();

                }
            });
        }
    </script>
</asp:Content>

