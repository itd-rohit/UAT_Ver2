<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ILCRegistration.aspx.cs" Inherits="Design_Quality_ILCRegistration" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
       
     <%:Scripts.Render("~/bundles/JQueryUIJs") %>
     <%:Scripts.Render("~/bundles/Chosen") %>
     <%:Scripts.Render("~/bundles/MsAjaxJs") %>
     <%:Scripts.Render("~/bundles/JQueryStore") %>
      <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
	  <script src="http://malsup.github.io/jquery.blockUI.js"></script>
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
                          <b>ILC Registration</b>  

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
                        <td width="60%" valign="top">
                            <table width="100%">
                                <tr>
                        <td style="font-weight: 700">
                            Select Centre :
                        </td>

                        <td> <asp:DropDownList class="ddlprocessinglab chosen-select chosen-container" ID="ddlprocessinglab" runat="server" style="width:450px;" onchange="getilclab()" ></asp:DropDownList>

                        

                        </td>

                       
                    </tr>

                                <tr>
                                     <td style="font-weight: 700">
                            Sin No/Visit ID :
                        </td>

                        <td>
                            <asp:TextBox ID="txtsearch" runat="server" Width="150px" />
                        &nbsp; &nbsp; &nbsp;
                            <input type="button" id="btnsearch" value="Search" class="searchbutton" onclick="SearchNow()" />
                                &nbsp; &nbsp; &nbsp;
                              <input type="button" value="Register" class="savebutton" id="btnsave" style="display:none;" onclick="savenow()" />
                        </td>
                                </tr>

                                   <tr>
                                    <td colspan="2">
                                         <table width="80%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;"  >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Not Registered</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Registered
                        
                    </td>
                    
                    
                </tr>
            </table>
                                        </td>
                                       </tr>
                                <tr>
                                    <td colspan="2">
  <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
                                            <table id="tbltest" style="width: 99%; border-collapse: collapse; text-align: left;">



                                                <tr id="trheadtest">
                                                     <td class="GridViewHeaderStyle" style="width: 50px;">Sr No.</td>
                                                     <td class="GridViewHeaderStyle" style="width: 150px;">Patient Name</td>
                                                     <td class="GridViewHeaderStyle" style="width: 150px;">Age/Gender</td>
                                                     <td class="GridViewHeaderStyle" style="width: 80px;">VisitID</td>
                                                     <td class="GridViewHeaderStyle" style="width: 80px;">SinNo</td>
                                                     <td class="GridViewHeaderStyle" >Test Name</td>
                                                     <td class="GridViewHeaderStyle"  style="width:50px;">Parameter</td>
                                                     <td class="GridViewHeaderStyle" style="width: 20px;"></td>
                                                    </tr>
                                                </table>
      </div>



                                    </td>
                                </tr>
                            </table>

                        </td>
                         <td width="1%">

                        </td>
                        <td width="39%" valign="top">

                            <table width="100%">
                                <tr>
                                    <td style="font-weight: 700">
                                        Current Month/Year :
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlcurrentmonth" runat="server" Width="100px"></asp:DropDownList>&nbsp;&nbsp;
                                        <asp:TextBox ID="txtcurrentyear" runat="server" ReadOnly="true" Width="50px"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="font-weight: 700">
                                        Select ILC Lab :
                                    </td>
                                    <td>
                                         <asp:DropDownList class="ddlilclab chosen-select chosen-container" ID="ddlilclab" runat="server" style="width:300px;" onchange="getparameterlist()" ></asp:DropDownList>
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <table width="80%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: white;"  >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Not Registered</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Registered                      
                    </td>
                    
                    
                </tr>                                         
            </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">

                                        <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
                                            <table id="tbl" style="width: 99%; border-collapse: collapse; text-align: left;">



                                                <tr id="trheader">
                                                    <td class="GridViewHeaderStyle" style="width: 50px;">Sr No.</td>
                                                    <td class="GridViewHeaderStyle" style="width: 120px;">Test Type</td>
                                                    <td class="GridViewHeaderStyle" >Parameter Name</td>
                                                     <td class="GridViewHeaderStyle" style="width: 120px;">New SINNo</td>
                                                    <td class="GridViewHeaderStyle" style="width: 50px;">Add Parameter</td>
                                                     <td class="GridViewHeaderStyle" style="width: 30px;">SeqNo.</td>
                                                </tr>
                                              
                                            </table>
                                            <div style="text-align:right">
                                            <input type="button" id="btnadd" style="display:none" class="searchbutton" value="Add New" onclick="openAddParameter()" />
                                                </div>
                                        </div>
                                    </td>

                                </tr>
                            </table>

                        </td>
                    </tr>

                    
                    </table>
                </div>
                
                </div>

          <div class="POuter_Box_Inventory" id="disp1" style="width:1300px;display:none;font-size:20px;background-color:white;font-weight:bold;text-align:center;">
             
             
         <asp:Panel ID="pnladdparameter" runat="server" style="display:none">
             <div class="POuter_Box_Inventory" style="width:700px;background-color:whitesmoke">
                 <div class="Purchaseheader">Map Parameter</div>
                 <table id="tbladdparameter">
                     <tr id="tbltrheader">
                         <td class="GridViewHeaderStyle" style="width:20px">Sr No.</td>
                         <td class="GridViewHeaderStyle" style="width:100px">TestType</td>
                         <td class="GridViewHeaderStyle" style="width:100px">Parameter</td>
                         <td class="GridViewHeaderStyle" style="width:100px">ILC Lab</td>
                         <td class="GridViewHeaderStyle" style="width:300px">Centre</td>    
                         <td class="GridViewHeaderStyle" style="width:10px">#</td>                             
                     </tr>
                 </table>
                 <input type="button" id="btnAddParameter" value="Add" class="searchbutton" onclick="addtest()" />
                  <input type="button" id="btnclose" value="Close" class="searchbutton" onclick="closepopup()" />                
             </div>
         </asp:Panel>
         <asp:Button ID="Button1" runat="server" style="display:none" />
         <cc1:ModalPopupExtender ID="modelpopupaddparameter" runat="server" TargetControlID="Button1" PopupControlID="pnladdparameter" BackgroundCssClass="filterPupupBackground"></cc1:ModalPopupExtender>
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


             

             
              getilclab();
              $('#btnadd').hide();

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

          </script>

      <script type="text/javascript">
          function getilcdata() {            
              var dataIm = new Array();
              $('#tbladdparameter tr').each(function () {
                  var id = $(this).closest("tr").attr("id");
                  if (id != "tbltrheader") {
                      debugger;
                      if ($(this).closest("tr").find('#ddlILCType option:selected').val() == 0) {
                          showerrormsg('please select ILC Lab Type');
                          return;
                      }
                      var ILCData = new Object();                    
                      ILCData.ProcessingLabID = $(this).closest("tr").find('#ProcessingLabID').html();
                      ILCData.ProcessingLabName = $(this).closest("tr").find('#ProcessingLabName').html();
                      ILCData.ILCLabTypeID = $(this).closest("tr").find('#ddlILCType option:selected').val();
                      ILCData.ILCLabType = $(this).closest("tr").find('#ddlILCType option:selected').text();
                      ILCData.ILCLabID = $(this).closest("tr").find('#ddlcentre_' + $(this).closest("tr").find('#TestID').html() + ' option:selected').val();
                      ILCData.ILCLabName = $(this).closest("tr").find('#ddlcentre_' + $(this).closest("tr").find('#TestID').html() + ' option:selected').text();
                      ILCData.TestType = $(this).closest("tr").find('#TestType').html();
                      ILCData.TestID = $(this).closest("tr").find('#TestID').html();
                      ILCData.TestName = $(this).closest("tr").find('#TestName').html();
                      ILCData.Rate = $(this).closest("tr").find("#Rate").html();
                      ILCData.AcceptablePer = $(this).closest("tr").find("#AcceptablePer").html();
                      ILCData.CMonth = $(this).closest("tr").find("#CurrentMonth").html();
                      ILCData.CYear = $(this).closest("tr").find("#CurrentYear").html();
                      dataIm.push(ILCData);
                  }
              });
              return dataIm;
          }
          function addtest() {           
              var ilcdata = getilcdata();
              if (ilcdata == "") {
                  return;
              }
              //$.blockUI();
              $.ajax({
                  url: "ILCRegistration.aspx/SaveData",
                  async: false,
                  data: JSON.stringify({ ilcdata: ilcdata }),
                  type: "POST", // data has to be Posted    	        
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  success: function (result) {
                      debugger;
                      //$.unblockUI();
                      var save = result.d;
                      if (save == "1") {
                          showmsg("Parameter Added Successfully");                         
                          closepopup();
                          getilclab();
                          getparameterlist();
                      }
                      else {
                          showerrormsg(save);
                         
                      }
                  },
                  error: function (xhr, status) {
                      //$.unblockUI()
                      showerrormsg("Some Error Occure Please Try Again..!");

                      console.log(xhr.responseText);
                  }
              });

          }
          function BindCentre(ctrl, TestID) {
              if ($(ctrl).val() == 0) {
                  showerrormsg('please select ILC Lab Type');
                  return;
              }
                  $.ajax({
                      url: "ILCRegistration.aspx/BindLabCentre",
                      async: false,
                      data: JSON.stringify({ Type: $(ctrl).val() }),
                      contentType: "application/json; charset=utf-8",
                      type: "POST", // data has to be Posted 
                      timeout: 120000,
                      dataType: "json",
                      success: function (result) {
                                                 
                          var data = result.d;
                          if (data.length == 0)
                              return;
                                                  
                          var centrelist = data.split('$');
                          var centrelen = centrelist.length;
                          $('#ddlcentre_' + TestID + ' option').remove();
                          $('#tbladdparameter tr').each(function (index) {
                              if (index > 0) {
                                  var a = "";
                                  var testid = $(this).find('#TestID').html();
                                  if (testid == TestID) {                                   
                                      var htmlddl = $(this).find('#ddlcentre_' + testid);
                                      for (var i = 0; i < centrelen; i++) {
                                          a += '<option value=' + centrelist[i].split('|')[0] + '>' + centrelist[i].split('|')[1] + '</option>';
                                      }
                                      htmlddl.append(a);
                                  }                                 
                              }
                          });                                                                    
                      }
                  });              
          }
          function openAddParameter() {           
              var check = 0;
              var parameterid = "";
              $('#tbl tr').each(function () {
                  if ($(this).attr("id") != "trheader" && $(this).find('#chkaddparameter').is(':checked')) {
                      check = 1;
                      parameterid += $(this).find('#parameterid').html() + ',';
                  }
              });
              if (check == 0) {
                  showerrormsg('please select parameter to add');
                  return;
              }
              if (parameterid != "")
                  getparameter(parameterid);            
              
          }
          function closepopup() {
              $('#disp1').hide();
              $find("<%=modelpopupaddparameter.ClientID%>").hide();
          }
          function getparameter(parameterid) {             
              $('#tbladdparameter tr').slice(1).remove();          
              //$.blockUI();

              jQuery.ajax({
                  url: "ILCRegistration.aspx/getparametercentre",
                  data: '{ TestID: "' + parameterid + '",ILCLab:"' + $('[id$=ddlilclab]').val() + '"}',
                  async: false,
                  type: "POST",
                  timeout: 120000,
                  contentType: "application/json; charset=utf-8",
                  dataType: "json",
                  success: function (result) {
                      PanelData = jQuery.parseJSON(result.d);                     
                      if (PanelData == "") {
                          //$.unblockUI();
                          showerrormsg('No Record found');
                          return;
                      }
                      for (var i = 0; i <= PanelData.length - 1; i++) {
                          debugger;
                          var centre = PanelData[i].centre.split('$');
                          var centrelen=centre.length;
                          var mydata = '<tr style="background-color:white;" class="GridViewItemStyle" id=' + PanelData[i].TestID + '>';

                          mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';
                          mydata += '<td align="left" id="TestType">' + PanelData[i].TestType + '</td>';
                         
                          mydata += '<td align="left" id="TestName">' + PanelData[i].TestName + '</td>';
                          mydata += '<td align="left" >';
                          mydata += '<select id="ddlILCType" onchange="BindCentre(this,' + PanelData[i].TestID + ');">'                       
                          if (PanelData[i].ILCLabType == "OutHouse Lab") {
                              mydata += '<option value="1" selected="selected">OutHouse Lab</option>';
                              mydata += '<option value="2">OutSource ILC Lab</option>';
                          }
                          else {
                              mydata += '<option value="1" >OutHouse Lab</option>';
                              mydata += '<option value="2" selected="selected">OutSource ILC Lab</option>';
                          }
                          mydata += '</select></td>';

                          mydata += '<td align="left" id="tdcentre">';
                          mydata += '<select id="ddlcentre_' + PanelData[i].TestID + '" style="width:300px">';
                          //for (var a = 0; a < centrelen; a++) {
                          //    if (PanelData[i].ILCLabName == centre[a].split('|')[1]) {
                          //        mydata += '<option value=' + centre[a].split('|')[0] + ' selected="selected">' + centre[a].split('|')[1] + '</option>';
                          //    }
                          //    else {
                          //        mydata += '<option value=' + centre[a].split('|')[0] + '>' + centre[a].split('|')[1] + '</option>';
                          //    }
                          //}
                          mydata += '<option value=' + PanelData[i].ILCLabID + '>' + PanelData[i].ILCLabName + '</option>';
                          mydata += '</select></td>';                     
                          mydata += '<td><input type="checkbox" checked="checked" disabled="false" id="chkaddpar"></td>'
                          mydata += '<td align="left" id="TestID" style="display:none;">' + PanelData[i].TestID + '</td>';
                          mydata += '<td align="left" id="Rate" style="display:none;">' + PanelData[i].Rate + '</td>';
                          mydata += '<td align="left" id="CurrentMonth" style="display:none;">' + PanelData[i].CurrentMonth + '</td>';
                          mydata += '<td align="left" id="CurrentYear" style="display:none;">' + PanelData[i].CurrentYear + '</td>';
                          mydata += '<td align="left" id="Fequency" style="display:none;">' + PanelData[i].Fequency + '</td>';
                          mydata += '<td align="left" id="AcceptablePer" style="display:none;">' + PanelData[i].AcceptablePer + '</td>';
                          mydata += '<td align="left" id="ProcessingLabID" style="display:none;">' + PanelData[i].ProcessingLabID + '</td>';
                          mydata += '<td align="left" id="ProcessingLabName" style="display:none;">' + PanelData[i].ProcessingLabName + '</td>';
                          mydata += '</tr>';
                          $('#tbladdparameter').append(mydata);
                          $('#disp1').show();
                          $find("<%=modelpopupaddparameter.ClientID%>").show();
                        
                      }
                      //$.unblockUI();


                  },
                  error: function (xhr, status) {
                      //$.unblockUI();
                      alert("Error ");
                  }
              });
          }

        function getilclab() {

            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();

            jQuery('#<%=ddlilclab.ClientID%> option').remove();
            $("#<%=ddlilclab.ClientID%>").trigger('chosen:updated');
            $('#tbl tr').slice(1).remove();
            if (processingcentre != "0") {


               
                     jQuery.ajax({
                         url: "ILCRegistration.aspx/bindilc",
                         data: '{processingcentre:"' + processingcentre + '"}',
                         type: "POST",
                         timeout: 120000,
                         async: false,
                         contentType: "application/json; charset=utf-8",
                         dataType: "json",
                         success: function (result) {
                             CentreLoadListData = jQuery.parseJSON(result.d);
                             if (CentreLoadListData.length == 0) {
                                 showerrormsg("No ILC Lab Found");
                             }

                             jQuery("#<%=ddlilclab.ClientID%>").append(jQuery('<option></option>').val("0").html("Select ILC Lab"));
                             for (i = 0; i < CentreLoadListData.length; i++) {

                                 jQuery("#<%=ddlilclab.ClientID%>").append(jQuery('<option></option>').val(CentreLoadListData[i].labid).html(CentreLoadListData[i].labname));
                             }

                             $("#<%=ddlilclab.ClientID%>").trigger('chosen:updated');





                         },
                         error: function (xhr, status) {
                             alert("Error ");
                         }
                     });
                 
             }
        }

        function getparameterlist() {

            $('#btnadd').hide();
            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();
            var ilclab = $('#<%=ddlilclab.ClientID%>').val();
            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();
            $('#tbl tr').slice(1).remove();

            if (processingcentre != "0" && ilclab != "0") {
                //$.blockUI();

                jQuery.ajax({
                    url: "ILCRegistration.aspx/getparameterlist",
                    data: '{ processingcentre: "' + processingcentre + '",ilclab:"' + ilclab + '",regisyearandmonth:"' + regisyearandmonth + '"}',
                    type: "POST",
                    timeout: 120000,
                  
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        PanelData = jQuery.parseJSON(result.d);
                        if (PanelData.length === 0) {
                            //$.unblockUI();
                            return;
                        }
                        for (var i = 0; i <= PanelData.length - 1; i++) {

                            var color = "white";
                            if (PanelData[i].regisid != "") {
                                color = "lightgreen";
                            }
                            var mydata = '<tr style="background-color:' + color + ';" class="GridViewItemStyle" id=' + PanelData[i].TestID + '>';

                            mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';
                            mydata += '<td align="left" id="TestType">' + PanelData[i].TestType + '</td>';
                            mydata += '<td align="left" id="TestName">' + PanelData[i].TestName + '</td>';
                            mydata += '<td align="left" id="NewSinNo">' + PanelData[i].newbarcode + '</td>';
                            mydata += '<td align="left" >';
                            if (PanelData[i].newbarcode != "")
                                mydata += '<input type="checkbox" id="chkaddparameter"/>';
                            mydata += '</td>';

                            mydata += '<td align="left" id="SquenceNo">' + PanelData[i].SquenceNo + '</td>';
                            mydata += '<td align="left" id="parameterid" style="display:none;">' + PanelData[i].TestID + '</td>';
                            mydata += '<td align="left" id="regisid" style="display:none;">' + PanelData[i].regisid + '</td>';
                            mydata += '</tr>';
                            $('#tbl').append(mydata);

                            $('#btnadd').show();
                        }
                        //$.unblockUI();


                    },
                    error: function (xhr, status) {
                        //$.unblockUI();
                        alert("Error ");
                    }
                });


            }
        }


        function SearchNow() {

            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();
            var searchvalue = $('#<%=txtsearch.ClientID%>').val();

            if (processingcentre == "0") {
                showerrormsg("Please Select Processing Centre");
                return;
            }

            if (searchvalue == "") {
                showerrormsg("Please Enter Sin no or VisitID");
                $('#<%=txtsearch.ClientID%>').focus();
                return;
            }
            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();
            $('#tbltest tr').slice(1).remove();
            //$.blockUI();

            jQuery.ajax({
                url: "ILCRegistration.aspx/getpatientdata",
                data: '{ processingcentre: "' + processingcentre + '",searchvalue:"' + searchvalue + '",regisyearandmonth:"' + regisyearandmonth + '"}',
                type: "POST",
                timeout: 120000,
               
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    PanelData = jQuery.parseJSON(result.d);
                    if (PanelData.length === 0) {
                        showerrormsg("No Data Found");
                        //$.unblockUI();
                        $('#btnsave').hide();
                        return;
                    }
                    $('#btnsave').show();
                    for (var i = 0; i <= PanelData.length - 1; i++) {

                        var color = 'bisque';
                        if (PanelData[i].savedid != '') {
                            color = 'lightgreen';
                        }

                        var mydata = '<tr style="background-color:' + color + ';" class="GridViewItemStyle" id=' + PanelData[i].test_id + '>';

                        mydata += '<td  align="left" >' + parseFloat(i + 1) + '</td>';
                        mydata += '<td align="left" id="PName">' + PanelData[i].PName + '</td>';
                        mydata += '<td align="left" id="PDetail">' + PanelData[i].PDetail + '</td>';
                        mydata += '<td align="left" id="LedgerTransactionNo">' + PanelData[i].LedgerTransactionNo + '</td>';
                        mydata += '<td align="left" id="barcodeno">' + PanelData[i].barcodeno + '</td>';
                        mydata += '<td align="left" id="itemname">' + PanelData[i].itemname + '</td>';
                        if (PanelData[i].ReportType == "1") {
                            mydata += '<td class="GridViewLabItemStyle"  id="tddetail1" title="Click To View Parameter" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>';
                        }
                        else {
                            mydata += '<td class="GridViewLabItemStyle"  id="tddetail1" ></td>';
                        }

                     //   if (PanelData[i].savedid == '') {
                            mydata += '<td align="left" id="selectme"><input type="checkbox" id="chk" onclick="seeme1(this)" /></td>';
                        //}
                        //else {
                        //    mydata += '<td align="left" id="selectme"></td>';
                        //}
                        mydata += '<td align="left" id="itemid" style="display:none;">' + PanelData[i].itemid + '</td>';
                        mydata += '<td align="left" id="ReportType" style="display:none;">' + PanelData[i].ReportType + '</td>';
                        mydata += '<td align="left" id="MapType" style="display:none;">' + PanelData[i].MapType + '</td>';
                        mydata += '<td align="left" id="ILCLabID" style="display:none;">' + PanelData[i].ILCLabID + '</td>';
                        mydata += '<td align="left" id="SquenceNo" style="display:none;">' + PanelData[i].SquenceNo + '</td>';
                        mydata += '</tr>';
                        $('#tbltest').append(mydata);

                    }
                    //$.unblockUI();


                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    alert("Error ");
                }
            });

           
        }

    </script>

    <script type="text/javascript">
        function showdetail(ctrl) {

            var id = $(ctrl).closest('tr').attr("id");
            if ($('table#tbltest').find('#ItemDetail' + id).length > 0) {
                $('table#tbltest tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();
            //$.blockUI();

            $.ajax({
                url: "ILCRegistration.aspx/BindTestParameter",
                data: '{test_id:"' + id + '",regisyearandmonth:"' + regisyearandmonth + '"}', // parameter map      
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Data Found");
                        //$.unblockUI();

                    }
                    else {
                        $(ctrl).attr("src", "../../App_Images/minus.png");
                        var mydata = "<div style='width:100%;max-height:275px;overflow:auto;'><table style='width:100%' cellpadding='0' cellspacing='0'>";
                        mydata += '<tr id="trheader" style="background-color:maroon;color:white;font-weight:bold;">';
                        mydata += '<td  style="width:20px;">#</td>';
                        mydata += '<td>Parameter Name</td>';
                        mydata += '<td>Result</td>';
                        mydata += '<td>MinValue</td>';
                        mydata += '<td>MaxValue</td>';
                        mydata += '<td>Unit</td>';
                        mydata += '<td>Method</td>';
                        mydata += '<td>#</td>';
                       


                        for (var i = 0; i <= ItemData.length - 1; i++) {

                            var color = '#a0a2e4';
                            if (ItemData[i].savedid != '') {
                                color = '#70e2b3;';
                            }


                            mydata += "<tr style='background-color:" + color + "' class='" + id + "' id='" + ItemData[i].LabObservation_ID + "'>";
                            mydata += '<td >' + parseInt(i + 1) + '</td>';



                            mydata += '<td >' + ItemData[i].LabObservationName + '</td>';
                            mydata += '<td >' + ItemData[i].value + '</td>';
                            mydata += '<td  >' + ItemData[i].minvalue + '</td>';
                            mydata += '<td  >' + ItemData[i].maxvalue + '</td>';
                           
                            mydata += '<td  >' + ItemData[i].readingformat + '</td>';

                            mydata += '<td  >' + ItemData[i].method + '</td>';
                          
                            if (ItemData[i].investigation_id != "0" && ItemData[i].savedid == '' && ItemData[i].mapid!="") {
                                mydata += '<td  ><input type="checkbox" id="chp" onclick="seeme(this)" class="chp"/></td>';
                            }
                            else {
                                mydata += '<td  ></td>';
                            }
                            mydata += '<td id="tdinv" style="display:none;">' + ItemData[i].investigation_id + '</td>';
                            mydata += "</tr>";




                        }
                        mydata += "</table><div>";

                        var newdata = '<tr class="ItemDetail" id="ItemDetail' + id + '"><td colspan="8">' + mydata + '</td></tr>';

                        $(newdata).insertAfter($(ctrl).closest('tr'));


                        //$.unblockUI();

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    //$.unblockUI();

                }
            });


        }

        function getdata() {
            var dataIm = new Array();

            $('#tbltest tr').each(function () {
                if ($(this).attr("id") != "trheadtest" && $(this).find("#chk").is(':checked') && $(this).attr("class") != "ItemDetail") {
                    var ProData = new Object();
                    ProData.TestID = $(this).attr("id");
                    ProData.InvestigationID = "0";
                    ProData.MapType = $(this).find("#MapType").html();
                    ProData.ILCLabID = $(this).find("#ILCLabID").html();                   
                    dataIm.push(ProData);

                }
            });

            $('.chp').each(function () {
                if ($(this).is(':checked')) {
                    var classname = $(this).closest('tr').attr("class");
                    var ProData = new Object();
                    ProData.TestID = classname;
                    ProData.InvestigationID = $(this).closest('tr').find('#tdinv').html().trim()
                    ProData.MapType = $('#' + classname).find("#MapType").html();
                    ProData.ILCLabID = $('#' + classname).find("#ILCLabID").html();                   
                    dataIm.push(ProData);

                    
                }
            });
        


            return dataIm;
        }

       

        function savenow() {
            var datatosave = getdata();
           
          
            if (datatosave.length == 0 ) {
                showerrormsg("Please Select Test To Register");
                return;
            }

            var regisyearandmonth = $('#<%=ddlcurrentmonth.ClientID%>').val() + "#" + $('#<%=txtcurrentyear.ClientID%>').val();
          
            //$.blockUI();
            $.ajax({
                url: "ILCRegistration.aspx/saveregister",
                data: JSON.stringify({ datatosave: datatosave,  regisyearandmonth: regisyearandmonth }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    //$.unblockUI();
                    if (result.d.split('#')[0] == "1") {
                        showmsg("ILC Register Successfully..!");

                        SearchNow();
                        getparameterlist();

                    }
                    else {
                        showerrormsg(result.d.split('#')[1]);
                    }

                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });
            
        }
    </script>


    <script type="text/javascript">
        function seeme(ctrl) {
            if ($(ctrl).is(':checked')) {
                var classname = $(ctrl).closest('tr').attr('class');
                if ($('#' + classname).find('#chk').is(':checked')) {
                    $(ctrl).prop('checked', false);
                    showerrormsg("Investigation Already Selected..");
                    return;

                }
            }
        }
        function seeme1(ctrl) {
            if ($(ctrl).is(':checked')) {
                var classname = $(ctrl).closest('tr').attr('id');
                $('.' + classname).find('#chp').prop('checked', false);
            }
        }

    </script>
</asp:Content>

