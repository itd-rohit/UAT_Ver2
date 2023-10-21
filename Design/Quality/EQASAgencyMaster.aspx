<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EQASAgencyMaster.aspx.cs" Inherits="Design_Quality_EQASAgencyMaster" %>

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
                          <b>EQAS Provider(Agency)</b>  

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
                         <td style="font-weight: 700; color: #FF0000;">EQAS Provider :</td>
                         <td><asp:TextBox ID="txteqaslabname" runat="server" Width="400px" />
                             <asp:TextBox ID="txteqaslabid" runat="server" style="display:none;" />

                         </td>
                         <td style="font-weight: 700">Address :</td>
                         <td><asp:TextBox ID="txteqaslabaddress" runat="server" Width="500px" /></td>
                    </tr>
                    <tr>
                         <td style="font-weight: 700">Contact No :</td>
                         <td><asp:TextBox ID="txtcontactno" runat="server" Width="150px" /></td>
                         <td style="font-weight: 700">Contact Person Name :</td>
                         <td><asp:TextBox ID="txtcontactname" runat="server" Width="250px" /></td>
                    </tr>
                    <tr>
                         <td style="font-weight: 700">Email Address :</td>
                         <td><asp:TextBox ID="txtemailaddress" runat="server" Width="150px" /></td>
                         <td style="font-weight: 700">&nbsp;</td>
                         <td>&nbsp;</td>
                    </tr>
                    <tr>
                         <td style="font-weight: 700;">Renew Date :</td>
                         <td> <asp:TextBox ID="txtrenewdate" runat="server" Width="150px" ReadOnly="true"></asp:TextBox>
                        <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtrenewdate" PopupButtonID="txtrenewdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                             &nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="chactive" Checked="true" runat="server" Font-Bold="true" Text="Active" style="color: #FF0000" />

                         </td>
                         <td style="font-weight: 700;">Document :
                             </td>
                         <td> 
    <cc1:AsyncFileUpload ID="file1" runat="server" OnUploadedComplete = "file1_UploadedComplete" OnClientUploadComplete="uploadComplete" />
                             <asp:TextBox ID="txtfilename" runat="server" style="display:none;"></asp:TextBox>
                         </td>
                    </tr>
                    <tr>
                         <td style="font-weight: 700; text-align: center;" colspan="4">
                             <input type="button" value="Save" class="savebutton" onclick="savelab()" id="btnsave"/>
                              <input type="button" value="Update" class="savebutton" onclick="updatelab()" id="btnupdate" style="display:none;"/>
                             &nbsp;&nbsp;
                             <input type="button" value="Reset" class="resetbutton" onclick="reset()"/>

                         </td>
                    </tr>
                    </table>
                </div>
                </div>




            <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div  style="width:1295px; max-height:400px;overflow:auto;">
                   <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        <td class="GridViewHeaderStyle">EQAS Provider Name</td>
                                        <td class="GridViewHeaderStyle">Address</td>
                                        <td class="GridViewHeaderStyle">Contact No</td>
                                        <td class="GridViewHeaderStyle">Contact Person Name</td>
                                         <td class="GridViewHeaderStyle">Email</td>

                                        <td class="GridViewHeaderStyle">Renew Date</td>
                                        <td class="GridViewHeaderStyle">Document</td>
                                        <td class="GridViewHeaderStyle">Status</td>
                                        <td class="GridViewHeaderStyle">EntryDate</td>
                                        <td class="GridViewHeaderStyle">EntryBy</td>
                                        <td class="GridViewHeaderStyle">UpdateDate</td>
                                        <td class="GridViewHeaderStyle">UpdateBy</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Edit</td>
                                         <td class="GridViewHeaderStyle" style="width: 50px;">Program</td>
                                     </tr>
                                 </table></div>
                </div>
              </div>
         </div>


    <script type="text/javascript">

        $(document).ready(function () {

            binddata();

        });

        function uploadComplete(sender) {

            $("#<%=txtfilename.ClientID%>").val('*');
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



        function reset() {
            $('#btnupdate').hide();
            $('#btnsave').show();

            $('#<%=txteqaslabname.ClientID%>').val('');
            $('#<%=txteqaslabaddress.ClientID%>').val('');
            $('#<%=txtemailaddress.ClientID%>').val('');
            $('#<%=txtcontactname.ClientID%>').val('');
            $('#<%=txtcontactno.ClientID%>').val('');
            $('#<%=txtrenewdate.ClientID%>').val('');

            $("#<%=txtfilename.ClientID%>").text("");
            $('input[type="file"]').each(function () { $("#" + this.id).val(""); });

            $('#<%=chactive.ClientID%>').prop('checked', true);
            $('#<%=txteqaslabid.ClientID%>').val('');
        }




        function savelab() {

            if ($('#<%=txteqaslabname.ClientID%>').val() == "") {
                $('#<%=txteqaslabname.ClientID%>').focus();
                showerrormsg("Please Enter EQAS Provider Name");
                return;
            }

            if ($('#<%=txtrenewdate.ClientID%>').val() == "") {
                //$('#<%=txtrenewdate.ClientID%>').focus();
                //showerrormsg("Please Select  Renew Date");
                //return;
            }
            if ($('#<%=txtfilename.ClientID%>').val() == "") {

                //showerrormsg("Please Upload  Document");
                //return;
            }
            var IsActive = "0";

            if (($('#<%=chactive.ClientID%>').prop('checked') == true)) {
                IsActive = "1";
            }

            if (IsActive == "0") {

                showerrormsg("Please Check Active CheckBox For First Time EQAS Provider Creation");
                $('#<%=chactive.ClientID%>').focus();
                return;
            }

            //$.blockUI();
            $.ajax({
                url: "EQASAgencyMaster.aspx/savedata",
                data: '{ labname:"' + $('#<%=txteqaslabname.ClientID%>').val() + '",labaddress:"' + $('#<%=txteqaslabaddress.ClientID%>').val() + '",contactno:"' + $('#<%=txtcontactno.ClientID%>').val() + '",contactpername:"' + $('#<%=txtcontactname.ClientID%>').val() + '",renewdate:"' + $('#<%=txtrenewdate.ClientID%>').val() + '",IsActive:"' + IsActive + '",emailaddress:"' + $('#<%=txtemailaddress.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    if (result.d == "1") {
                        reset();
                        showmsg("Save Successfully");
                        binddata();
                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    console.log(xhr.responseText);
                }
            });

        }
        function updatelab() {

            if ($('#<%=txteqaslabname.ClientID%>').val() == "") {
                $('#<%=txteqaslabname.ClientID%>').focus();
                showerrormsg("Please Enter EQAS Provider Name");
                return;
            }

            if ($('#<%=txtrenewdate.ClientID%>').val() == "") {
                //$('#<%=txtrenewdate.ClientID%>').focus();
                //showerrormsg("Please Select Renew Date");
                //return;
            }

            var IsActive = "0";

            if (($('#<%=chactive.ClientID%>').prop('checked') == true)) {
                IsActive = "1";
            }



            //$.blockUI();
            $.ajax({
                url: "EQASAgencyMaster.aspx/updatedata",
                data: '{labid:"' + $('#<%=txteqaslabid.ClientID%>').val() + '", labname:"' + $('#<%=txteqaslabname.ClientID%>').val() + '",labaddress:"' + $('#<%=txteqaslabaddress.ClientID%>').val() + '",contactno:"' + $('#<%=txtcontactno.ClientID%>').val() + '",contactpername:"' + $('#<%=txtcontactname.ClientID%>').val() + '",renewdate:"' + $('#<%=txtrenewdate.ClientID%>').val() + '",IsActive:"' + IsActive + '",emailaddress:"' + $('#<%=txtemailaddress.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    //$.unblockUI();
                    if (result.d == "1") {
                        reset();
                        showmsg("Update Successfully");
                        binddata();
                    }
                    else {
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    //$.unblockUI();
                    console.log(xhr.responseText);
                }
            });

        }

        function binddata() {

            //$.blockUI();
            $('#tblitemlist tr').slice(1).remove();
            $.ajax({
                url: "EQASAgencyMaster.aspx/binddata",
                data: '{}',
                type: "POST",
                timeout: 120000,

                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No EQAS Provider Found");
                        //$.unblockUI();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:lightgreen;' id='" + ItemData[i].EqasProviderID + "'>";
                            mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EqasProviderName">' + ItemData[i].EqasProviderName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EqasProviderAddress">' + ItemData[i].EqasProviderAddress + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="ContactNo">' + ItemData[i].ContactNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="ContactPersonname">' + ItemData[i].ContactPersonname + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EmailAddress">' + ItemData[i].EmailAddress + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="RenewDate">' + ItemData[i].RenewDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="MOUDocument"><a style="font-weight:bold;" target="_blank" href="EQASDocument/' + ItemData[i].Document + '">' + ItemData[i].Document + '</a></td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="IsActive">' + ItemData[i].IsActive + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EntryDate">' + ItemData[i].EntryDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EntryByName">' + ItemData[i].EntryByName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="UpdateDate">' + ItemData[i].UpdateDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="UpdateByName">' + ItemData[i].UpdateByName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="tddetail2" ><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="showdetailtoupdate(this)" /></td>';

                            mydata += '<td class="GridViewLabItemStyle"  id="tddetail2" align="center" style="background-color:red;"><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="openprogramepage(this)" /></td>';

                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                        }
                        //$.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    //$.unblockUI();

                }
            });
        }


        function showdetailtoupdate(ctrl) {

            $('#<%=txteqaslabid.ClientID%>').val($(ctrl).closest("tr").attr('id'));
            $('#<%=txteqaslabname.ClientID%>').val($(ctrl).closest("tr").find('#EqasProviderName').html());
            $('#<%=txteqaslabaddress.ClientID%>').val($(ctrl).closest("tr").find('#EqasProviderAddress').html());
            $('#<%=txtemailaddress.ClientID%>').val($(ctrl).closest("tr").find('#EmailAddress').html());
            
            $('#<%=txtcontactname.ClientID%>').val($(ctrl).closest("tr").find('#ContactPersonname').html());
            $('#<%=txtcontactno.ClientID%>').val($(ctrl).closest("tr").find('#ContactNo').html());
            $('#<%=txtrenewdate.ClientID%>').val($(ctrl).closest("tr").find('#RenewDate').html());
            if ($(ctrl).closest("tr").find('#IsActive').html() == "Active") {
                $('#<%=chactive.ClientID%>').prop('checked', true);
            }
            else {
                $('#<%=chactive.ClientID%>').prop('checked', false);
            }

            $('#btnsave').hide();
            $('#btnupdate').show();
        }




        function openprogramepage(ctrl) {
            openmypopup("EQASProgrammaster.aspx?eqasprovider=" + $(ctrl).closest("tr").attr('id'));
            
        }



        function openmypopup(href) {
            var width = '1250px';

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'min-height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
        </script>
</asp:Content>

