<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="RequiredFieldMaster.aspx.cs" Inherits="Design_Investigation_RequiredFieldMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   
   <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
      

     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

    <div id="Pbody_box_inventory" style="width:1204px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
            
      <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align:center;font-weight:bold;height:35px;">
                Required Field Master
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
          </div>

          <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content">
                  <div class="Purchaseheader">Add Field</div>

                <table width="99%">
                    <tr>
                        <td style="text-align: right; font-weight: 700">Field Name :&nbsp;&nbsp; </td>
                          <td><asp:TextBox ID="txtFieldname" runat="server" Width="200px"  style="text-transform:uppercase;"/><asp:TextBox ID="txtid" runat="server" style="display:none;" /> </td>
                          <td style="text-align: right; font-weight: 700">Input Type :&nbsp;&nbsp;</td>
                          <td><asp:DropDownList ID="ddlinputtype" runat="server" Width="200px" onchange="showdropdown()">
                              <asp:ListItem Value="0">Select</asp:ListItem>
                              <asp:ListItem Value="TextBox">TextBox</asp:ListItem>
                              <asp:ListItem Value="DropDownList">DropDownList</asp:ListItem>
                              <asp:ListItem Value="CheckBox">CheckBox</asp:ListItem>
                                 <asp:ListItem Value="Date">Date</asp:ListItem>
                              </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="text-align: right; font-weight: 700" valign="top"><input type="checkbox" onclick="showunit()" id="uncheck" />Unit :&nbsp;&nbsp;</td>
                          <td style="font-weight: 700">
                              <div id="myunit">

                              <asp:TextBox ID="txtunit" runat="server" Width="200px" placeholder="Enter Unit Option" style="text-transform:uppercase;"></asp:TextBox>&nbsp;<input type="button" value="Add" onclick="entertextindropdown()" style="color:white;background-color:blue;font-weight:bold;" /><input type="button" value="Clear" onclick="cleardata()" style="color:white;background-color:red;font-weight:bold;" /> <br />
                              <asp:ListBox ID="ddlunit" runat="server" Width="204px" Height="70px"></asp:ListBox></div>

                          </td>
                          <td style="text-align: right; font-weight: 700">&nbsp;</td>
                          <td width="450px;"> <div id="myoption">

                              <asp:TextBox ID="txtddvalue" runat="server" Width="200px" placeholder="Enter DropDown Option" style="text-transform:uppercase;"></asp:TextBox>&nbsp;<input type="button" value="Add" onclick="entertextindropdownoption()" style="color:white;background-color:blue;font-weight:bold;" /><input type="button" value="Clear" onclick="cleardataoption()" style="color:white;background-color:red;font-weight:bold;" /> <br />
                              <asp:ListBox ID="ddldropdownoption" runat="server" Width="204px" Height="70px"></asp:ListBox></div></td>
                    </tr>
                  
                </table>
                </div>
              </div>

           <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align:center;" >
                <input type="button" value="Save" id="btn" class="savebutton" onclick="savedata()" />&nbsp;&nbsp;

                <input type="button" value="Reset" class="resetbutton" onclick="clearform()" />
                </div>
               </div>

        <div class="POuter_Box_Inventory" style="width:1200px;">
            <div class="content" style="text-align:center;" >
                <div style="width:99%;height:300px;overflow:auto;">

                <table id="tb_ItemList" style="width:99%;border-collapse:collapse">

                      <tr id="header" style="height:22px;">
                                        <td class="GridViewHeaderStyle" style="width:50px;" align="left">Sr No.</td>
                                        <td class="GridViewHeaderStyle"  align="left">Field Name</td>
                                        <td class="GridViewHeaderStyle" align="left">Unit</td>
                                        <td class="GridViewHeaderStyle" align="left">InputType</td>
                                       <td class="GridViewHeaderStyle" align="left">DropDown Value</td>
                                        <td class="GridViewHeaderStyle" align="left">EntryDate</td>
                                        <td class="GridViewHeaderStyle" align="left">EnteredBy</td>
                                         <td class="GridViewHeaderStyle" align="left">UpdateDate</td>
                                        <td class="GridViewHeaderStyle" align="left">UpdateBy</td>
                                     
                                         <td class="GridViewHeaderStyle" >Select</td>
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
        $(function () {
            $('#<%=txtFieldname.ClientID%>').focus();
            $('#myunit').find(':input').prop('disabled', true);
            $('#myoption').hide();
            binddata();
            
            $("#<%= txtunit.ClientID%>").keydown(
                     function (e) {
                         var key = (e.keyCode ? e.keyCode : e.charCode);

                         if (key == 13) {
                             entertextindropdown();
                         }
                     });

            $("#<%= txtddvalue.ClientID%>").keydown(
                    function (e) {
                        var key = (e.keyCode ? e.keyCode : e.charCode);

                        if (key == 13) {
                            entertextindropdownoption();
                        }
                    });
        });

        function showunit() {

            if ($('#uncheck').is(':checked')) {
                $('#myunit').find(':input').prop('disabled', false);
                $('#<%=txtunit.ClientID%>').focus();
            }
            else {
                $('#myunit').find(':input').prop('disabled', true);
            }
        }
        function entertextindropdown() {
     

            if ($('#<%=txtFieldname.ClientID%>').val() == "") {
                showerrormsg("Please Enter Field Name");
                $('#<%=txtFieldname.ClientID%>').focus();
                return;
            }


            if ($('#<%=txtunit.ClientID%>').val() == "") {
                showerrormsg("Please Enter Text To Add");
                $('#<%=txtunit.ClientID%>').focus();
                return;
            }

            var t = $("#<%=ddlunit.ClientID%> option[value='" + $('#<%=txtunit.ClientID%>').val().toUpperCase() + "']").length;
            if (t == "1") {
                showerrormsg("Option Already Added");
                $('#<%=txtunit.ClientID%>').focus();
                return;
            }


           
            $("#<%=ddlunit.ClientID%>").append($("<option></option>").val($('#<%=txtunit.ClientID%>').val().toUpperCase()).html($('#<%=txtunit.ClientID%>').val().toUpperCase()));
            $('#<%=txtunit.ClientID%>').val('');
            $('#<%=txtunit.ClientID%>').focus();
        }

        function cleardata() {
            $('#<%=ddlunit.ClientID%> option').remove();
            $('#<%=txtunit.ClientID%>').val('');
            $('#<%=txtunit.ClientID%>').focus();
        }

        function entertextindropdownoption() {


            if ($('#<%=txtFieldname.ClientID%>').val() == "") {
                showerrormsg("Please Enter Field Name");
                $('#<%=txtFieldname.ClientID%>').focus();
                return;
            }


            if ($('#<%=txtddvalue.ClientID%>').val() == "") {
                showerrormsg("Please Enter Text To Add");
                $('#<%=txtddvalue.ClientID%>').focus();
                return;
            }

            var t = $("#<%=ddldropdownoption.ClientID%> option[value='" + $('#<%=txtddvalue.ClientID%>').val().toUpperCase() + "']").length;
            if (t == "1") {
                showerrormsg("Option Already Added");
                $('#<%=txtddvalue.ClientID%>').focus();
                return;
            }



            $("#<%=ddldropdownoption.ClientID%>").append($("<option></option>").val($('#<%=txtddvalue.ClientID%>').val().toUpperCase()).html($('#<%=txtddvalue.ClientID%>').val().toUpperCase()));
            $('#<%=txtddvalue.ClientID%>').val('');
            $('#<%=txtddvalue.ClientID%>').focus();
        }

        function cleardataoption() {
            $('#<%=ddldropdownoption.ClientID%> option').remove();
            $('#<%=txtddvalue.ClientID%>').val('');
            $('#<%=txtddvalue.ClientID%>').focus();
        }

        function showdropdown() {

            if ($('#<%=ddlinputtype.ClientID%>').val()=="DropDownList") {
                $('#myoption').show();
                $('#<%=txtddvalue.ClientID%>').focus();
            }
            else {
                $('#myoption').hide();
            }
        }

        function savedata() {

            if ($('#<%=txtFieldname.ClientID%>').val() == "") {
                showerrormsg("Please Enter Field Name");
                $('#<%=txtFieldname.ClientID%>').focus();
                return;
            }

            if ($('#<%=ddlinputtype.ClientID%>').val() == "0") {
                showerrormsg("Please Select Input Type");
                $('#<%=ddlinputtype.ClientID%>').focus();
                return;
            }

            if ($('#uncheck').is(':checked') && $('#<%=ddlunit.ClientID%> option').length == 0) {
                showerrormsg("Please Enter Option For Unit");
                $('#<%=txtunit.ClientID%>').focus();
                return;
            }

            if ($('#<%=ddlinputtype.ClientID%>').val() == "DropDownList" && $('#<%=ddldropdownoption.ClientID%> option').length == 0) {
                showerrormsg("Please Enter DropDown Option Text");
                $('#<%=txtddvalue.ClientID%>').focus();
                return;
            }

            var IsUnit = "0";
            if ($('#uncheck').is(':checked')) {
                IsUnit = "1";
            }
            var Unit = getunitdata();
            var DropDownOption = getdropdowndata();
            $modelBlockUI();

            $.ajax({
                url: "RequiredFieldMaster.aspx/savecompletedata",
                data: '{FieldName:"' + $('#<%=txtFieldname.ClientID%>').val() + '",id:"' + $('#<%=txtid.ClientID%>').val() + '",InputType:"' + $('#<%=ddlinputtype.ClientID%>').val() + '",IsUnit:"' + IsUnit + '",Unit:"' + Unit + '",DropDownOption:"' + DropDownOption + '"}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    resultdata=$.parseJSON(result.d);

                    if (resultdata == "2") {
                        showerrormsg("Field Name Alreday Saved.!");
                        $modelUnBlockUI();
                        return;
                    }
                    else if (resultdata == "3") {
                        showerrormsg("Field Name Alreday Used By Another Field.!");
                        $modelUnBlockUI();
                        return;
                    }
                    else if (resultdata == "1") {
                        showmsg("Data Saved Sucessfully.!");
                        clearform();
                        binddata();
                        $modelUnBlockUI();
                        return;

                    }
                    else if (resultdata == "4") {
                        showmsg("Data Updated Sucessfully.!");
                        clearform();
                        binddata();
                        $modelUnBlockUI();
                        return;

                    }
                    else {
                        showerrormsg(resultdata);
                        $modelUnBlockUI();
                        return;
                    }

                },
                error: function (xhr, status) {
                    $modelUnBlockUI();

                }

            });
        }
        function getunitdata() {
            var data = "";

            $('#ContentPlaceHolder1_ddlunit option').each(function () {
                data += this.value + "|";
            });

            return data;

        }
        function getdropdowndata() {
            var data = "";

            $('#ContentPlaceHolder1_ddldropdownoption option').each(function () {
                data += this.value + "|";
            });

            return data;
        }
        function clearform() {
            
            $('#<%=txtid.ClientID%>').val('');
            $('#<%=txtFieldname.ClientID%>').val('');
            $('#myunit').find(':input').prop('disabled', true);
            $('#myoption').hide();
            $('#<%=ddlunit.ClientID%> option').remove();
            $('#<%=txtunit.ClientID%>').val('');
            $('#<%=ddldropdownoption.ClientID%> option').remove();
            $('#<%=txtddvalue.ClientID%>').val('');
            $('#<%=txtFieldname.ClientID%>').focus();
            $('#btn').val("Save");
            $('#uncheck').prop('checked', false);
            $('#ContentPlaceHolder1_ddlinputtype').val("0");
            showunit();
            showdropdown();

        }

        function binddata() {
            $('#tb_ItemList tr').slice(1).remove();
            $.ajax({
                url: "RequiredFieldMaster.aspx/binddata",
                data: '{}',
                type: "POST",
                timeout: 120000,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    TestData = $.parseJSON(result.d);
                    if (TestData.length == 0) {

                        return;
                    }
                    else {

                        for (var i = 0; i <= TestData.length - 1; i++) {

                            var mydata = "<tr id='" + TestData[i].id + "'  style='background-color:lightgoldenrodyellow;height:21px;'>";
                            mydata += '<td align="left" class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                            mydata += '<td align="left" id="tdfieldname" class="GridViewLabItemStyle" style="font-weight:bold;">' + TestData[i].fieldname + '</td>';
                            mydata += '<td align="left" class="GridViewLabItemStyle" style="font-weight:bold;" >' + TestData[i].unit + '</td>';
                            mydata += '<td align="left" id="tdinputtype" class="GridViewLabItemStyle" style="font-weight:bold;" >' + TestData[i].inputtype + '</td>';
                            mydata += '<td align="left" id="tddropdownoption" class="GridViewLabItemStyle" style="font-weight:bold;" >' + TestData[i].dropdownoption + '</td>';
                            mydata += '<td align="left" class="GridViewLabItemStyle" >' + TestData[i].Entrydate + '</td>';
                            mydata += '<td align="left" class="GridViewLabItemStyle" >' + TestData[i].EnteredBy + '</td>';
                            mydata += '<td align="left" class="GridViewLabItemStyle" >' + TestData[i].Updatedate + '</td>';
                            mydata += '<td align="left" class="GridViewLabItemStyle" >' + TestData[i].updateby + '</td>';
                            mydata += '<td align="left" id="tdisunit" class="GridViewLabItemStyle" style="display:none;">' + TestData[i].isunit + '</td>';
                            mydata += '<td align="left" id="tdunit" class="GridViewLabItemStyle" style="display:none;" >' + TestData[i].unit + '</td>';
                           
                            mydata += '<td align="left" class="GridViewLabItemStyle" style="text-align:center;"><img src="../../App_Images/view.gif" style="cursor:pointer;" ';
                            mydata += 'onclick="showcompletedata(this)"/></td>';
                          
                            mydata += "</tr>";
                            $('#tb_ItemList').append(mydata);

                        }

                    }


                },
                error: function (xhr, status) {
                    $modelUnBlockUI();

                }

            });
        }


        function showcompletedata(ctrl) {
            clearform();
            
            $('#ContentPlaceHolder1_txtid').val($(ctrl).closest('tr').attr('id'));
            $('#ContentPlaceHolder1_txtFieldname').val($(ctrl).closest('tr').find('#tdfieldname').html());
            $('#ContentPlaceHolder1_ddlinputtype').val($(ctrl).closest('tr').find('#tdinputtype').html());
            if ($(ctrl).closest('tr').find('#tdisunit').html() == "1") {
                $('#uncheck').prop('checked', true);
               
                for (var a = 0; a <= $(ctrl).closest('tr').find('#tdunit').html().split('|').length-1; a++) {
                    $("#<%=ddlunit.ClientID%>").append($("<option></option>").val($(ctrl).closest('tr').find('#tdunit').html().split('|')[a].toUpperCase()).html($(ctrl).closest('tr').find('#tdunit').html().split('|')[a].toUpperCase()));
                }

            }
            else {
                $('#uncheck').prop('checked', false);
            }

            if ($(ctrl).closest('tr').find('#tddropdownoption').html() != "") {
                for (var a = 0; a <= $(ctrl).closest('tr').find('#tddropdownoption').html().split('|').length - 1; a++) {
                    $("#<%=ddldropdownoption.ClientID%>").append($("<option></option>").val($(ctrl).closest('tr').find('#tddropdownoption').html().split('|')[a].toUpperCase()).html($(ctrl).closest('tr').find('#tddropdownoption').html().split('|')[a].toUpperCase()));
                 }
            }
            $('#btn').val("Update");
            showunit();
            showdropdown();


            
        }

    </script>
</asp:Content>

