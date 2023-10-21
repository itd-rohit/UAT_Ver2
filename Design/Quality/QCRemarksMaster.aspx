<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="QCRemarksMaster.aspx.cs" Inherits="Design_Quality_QCRemarksMaster" %>
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
       
     <%:Scripts.Render("~/bundles/JQueryUIJs") %>
     <%:Scripts.Render("~/bundles/Chosen") %>
     <%:Scripts.Render("~/bundles/MsAjaxJs") %>
     <%:Scripts.Render("~/bundles/JQueryStore") %>
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
                          <b>QC Remark Master</b>  

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
                        <td style="font-weight: 700" class="required">
                            Type:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlremarkstype" runat="server">
                                <asp:ListItem Value="0">Select</asp:ListItem>
                                <asp:ListItem Value="RCA">RCA</asp:ListItem>
                                <asp:ListItem Value="Corrective Action">Corrective Action</asp:ListItem>
                                <asp:ListItem Value="Preventive Action">Preventive Action</asp:ListItem>
                              
                            </asp:DropDownList>
                        </td>
                         <td style="font-weight: 700" class="required">
                             Remark Title:
                        </td>
                        <td>
                            <asp:TextBox ID="txtremarks" runat="server" Width="500px" MaxLength="100"></asp:TextBox>


                            &nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="chactive" Checked="true" runat="server" Font-Bold="true" Text="Active" style="color: #FF0000" />
                        </td>

                        <td>
                            <asp:TextBox ID="txtid" runat="server" style="display:none;" />
                           
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700" class="required">
                            Remark:</td>
                        <td colspan="3">
                           <ckeditor:ckeditorcontrol ID="txtremarkstext"   BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="750" Height="70" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol>

                    </td>
                         <td>
                            <input type="button" value="Save" class="savebutton" onclick="saveme()" id="btnsave" />
                             &nbsp;<input type="button" value="Update" class="savebutton" onclick="updateme()" id="btnupdate" style="display:none;" />
                        </td>
                    </tr>
                    </table>
                </div>
                </div>


           <div class="POuter_Box_Inventory" style="width:1300px;">
            <div class="content">
                <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
                                            <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">



                                                <tr id="trheadtest">
                                                     <td class="GridViewHeaderStyle" style="width: 50px;">Sr No.</td>
                                                     <td class="GridViewHeaderStyle" style="width: 150px;">Remark Type</td>
                                                     <td class="GridViewHeaderStyle" style="width: 100px;">Remark Title</td>
                                                    <td class="GridViewHeaderStyle">Remark</td>
                                                     <td class="GridViewHeaderStyle" style="width: 50px;">Status</td>
                                                     <td class="GridViewHeaderStyle" style="width: 80px;">Entry Date</td>
                                                     <td class="GridViewHeaderStyle" style="width: 80px;">Entry By</td>
                                                     <td class="GridViewHeaderStyle" style="width: 80px;">Update Date</td>
                                                     <td class="GridViewHeaderStyle" style="width: 80px;">Update By</td>
                                                    <td class="GridViewHeaderStyle" style="width: 20px;">Edit</td>
                                                    </tr>
                                                </table>
      </div>
                </div>
               </div>
         </div>

    <script type="text/javascript">

        $(document).ready(function () {

            SearchNow();

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
        function saveme() {
            if ($('#<%=ddlremarkstype.ClientID%>').val() == "0") {
                $('#<%=ddlremarkstype.ClientID%>').focus();
                showerrormsg("Please Select Remark Type");
                return;

            }

            if ($('#<%=txtremarks.ClientID%>').val().trim() == "") {
                $('#<%=txtremarks.ClientID%>').focus();
                  showerrormsg("Please Enter Remark Title");
                  return;

            }


            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            remarks = objEditor.getData();
            if (remarks.trim() == "null" || remarks.trim() == "<br />") {
                remarks = "";
            }

            if (remarks == "") {
                $('#<%=txtremarkstext.ClientID%>').focus();
                 showerrormsg("Please Enter Remark");
                 return;

             }

            var IsActive = "0";

            if (($('#<%=chactive.ClientID%>').prop('checked') == true)) {
                 IsActive = "1";
             }

             if (IsActive == "0") {

                 showerrormsg("Please Check Active CheckBox For First Time");
                 $('#<%=chactive.ClientID%>').focus();
                return;
            }

            $.blockUI();
            $.ajax({
                url: "QCRemarksMaster.aspx/saveremark",
                data: '{remarktype:"' + $('#<%=ddlremarkstype.ClientID%>').val() + '",remark:"' + $('#<%=txtremarks.ClientID%>').val() + '",IsActive:"' + IsActive + '",remarktext:"' + remarks + '"}', // parameter map    
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    $.unblockUI();
                    if (result.d.split('#')[0] == "1") {
                        showmsg("Remark Saved Successfully..!");
                        $('#<%=txtid.ClientID%>').val('');
                        $('#<%=ddlremarkstype.ClientID%>').val('0');
                        $('#<%=txtremarks.ClientID%>').val('');
                        $('#<%=chactive.ClientID%>').prop('checked', true);
                        var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                        objEditor.setData('');
                        $('#btnsave').show();
                        $('#btnupdate').hide();
                        SearchNow();
                        

                    }
                    else {
                        showerrormsg(result.d.split('#')[1]);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });

        }




        function SearchNow() {

            $.blockUI();
            $('#tblitemlist tr').slice(1).remove();
            $.ajax({
                url: "QCRemarksMaster.aspx/binddata",
                data: '{}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        showerrormsg("No Remark Found");
                        $.unblockUI();

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:lightgreen;' id='" + ItemData[i].id + "'>";
                            mydata += '<td class="GridViewLabItemStyle"  id="srno">' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="RemarksType">' + ItemData[i].RemarksType + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="RemarksTitle">' + ItemData[i].RemarksTitle + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="Remarks">' + ItemData[i].Remarks + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="IsActive">' + ItemData[i].IsActive + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EntryDateTime">' + ItemData[i].EntryDateTime + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="EntryByName">' + ItemData[i].EntryByName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="UpdateDateTime">' + ItemData[i].UpdateDateTime + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="UpdateByName">' + ItemData[i].UpdateByName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"  id="tddetail2" ><img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="showdetailtoupdate(this)" /></td>';
                       
                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                        }
                        $.unblockUI();

                    }

                },
                error: function (xhr, status) {

                    $.unblockUI();

                }
            });
        }


        function showdetailtoupdate(ctrl) {

            $('#<%=txtid.ClientID%>').val($(ctrl).closest("tr").attr('id'));
            $('#<%=ddlremarkstype.ClientID%>').val($(ctrl).closest("tr").find('#RemarksType').html());
            $('#<%=txtremarks.ClientID%>').val($(ctrl).closest("tr").find('#RemarksTitle').html());
            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            objEditor.setData($(ctrl).closest("tr").find('#Remarks').html());
           
             
            if ($(ctrl).closest("tr").find('#IsActive').html() == "Active") {
                  $('#<%=chactive.ClientID%>').prop('checked', true);
            }
            else {
                $('#<%=chactive.ClientID%>').prop('checked', false);
            }

            $('#btnsave').hide();
            $('#btnupdate').show();
        }




        function updateme() {
            if ($('#<%=ddlremarkstype.ClientID%>').val() == "0") {
                 $('#<%=ddlremarkstype.ClientID%>').focus();
                showerrormsg("Please Select Remark Type");
                return;

            }

            if ($('#<%=txtremarks.ClientID%>').val().trim() == "") {
                 $('#<%=txtremarks.ClientID%>').focus();
                showerrormsg("Please Enter Remark");
                return;

            }


            var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
            remarks = objEditor.getData();
            if (remarks.trim() == "null" || remarks.trim() == "<br />") {
                remarks = "";
            }

            if (remarks == "") {
                $('#<%=txtremarkstext.ClientID%>').focus();
                showerrormsg("Please Enter Remark");
                return;

            }

            var IsActive = "0";

            if (($('#<%=chactive.ClientID%>').prop('checked') == true)) {
                IsActive = "1";
            }

           
             $.blockUI();
             $.ajax({
                 url: "QCRemarksMaster.aspx/updateremark",
                 data: '{remarktype:"' + $('#<%=ddlremarkstype.ClientID%>').val() + '",remark:"' + $('#<%=txtremarks.ClientID%>').val() + '",IsActive:"' + IsActive + '",id:"' + $('#<%=txtid.ClientID%>').val() + '",remarktext:"' + remarks + '"}', // parameter map    
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    $.unblockUI();
                    if (result.d.split('#')[0] == "1") {
                        showmsg("Remark Update Successfully..!");
                        $('#<%=txtid.ClientID%>').val('');
                        $('#<%=ddlremarkstype.ClientID%>').val('0');
                        $('#<%=txtremarks.ClientID%>').val('');
                        $('#<%=chactive.ClientID%>').prop('checked', true);
                        var objEditor = CKEDITOR.instances['<%=txtremarkstext.ClientID%>'];
                        objEditor.setData('');
                        $('#btnsave').show();
                        $('#btnupdate').hide();
                        SearchNow();


                    }
                    else {
                        showerrormsg(result.d.split('#')[1]);
                    }

                },
                error: function (xhr, status) {
                    $.unblockUI();
                    showerrormsg(xhr.responseText);
                }
            });

        }

    </script>
</asp:Content>

