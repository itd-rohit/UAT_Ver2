<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddManufacture.aspx.cs" Inherits="Design_Store_AddManufacture" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
         <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
         <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
         <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
         <%: Scripts.Render("~/bundles/WebFormsJs") %>
         <%: Scripts.Render("~/bundles/JQueryUIJs") %>
         <%: Scripts.Render("~/bundles/MsAjaxJs") %>
         <%: Scripts.Render("~/bundles/JQueryStore") %>

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
        function savedata() {
            if ($('#<%=txtname.ClientID%>').val() == "") {
                showerrormsg("Please Enter Name..!");
                return;
            }
            var active = "0";
            if ($('#<%=ChkActivate.ClientID%>').is(':checked')) {
                active = "1";
            }
            
            $.ajax({
                url: "AddManufacture.aspx/savedata",
                data: '{name:"' + $('#<%=txtname.ClientID%>').val().toUpperCase() + '",active:"' + active + '",con:"' + $('#<%=txtconper.ClientID%>').val() + '",add:"' + $('#<%=txtaddress1.ClientID%>').val() + '",add2:"' + $('#<%=txtaddress2.ClientID%>').val() + '",add3:"' + $('#<%=txtaddress3.ClientID%>').val() + '",ph:"' + $('#<%=txtphone.ClientID%>').val() + '",mo:"' + $('#<%=txtmobile.ClientID%>').val() + '",fax:"' + $('#<%=txtfax.ClientID%>').val() + '",  country:"' + $('#<%=txtcountry.ClientID%>').val() + '",  city:"' + $('#<%=txtcity.ClientID%>').val() + '",  pincode:"' + $('#<%=txtpincode.ClientID%>').val() + '",  dlno:"' + $('#<%=txtdlno.ClientID%>').val() + '",  tinno:"' + $('#<%=txttinno.ClientID%>').val() + '",  email:"' + $('#<%=txtemail.ClientID%>').val() + '"}', // parameter map       
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    showmsg(" Record Succesfully Saved ...!")                  
                  if (result.d == "0") {
                        showerrormsg('Error...');
                    }
                  else {                    
                      var data = $.parseJSON(result.d)
                      window.parent.$('select[id="ContentPlaceHolder1_ddlmanu"]').append('<option value="' + data.ManuFactureID + '" >' + data.ManuFactureName + '</option>');
                      location.reload();
                  }
                   
                    location.reload();

                },
                error: function (xhr, status) {


                }


            });
        }
        function checkduplicate() {
            if ($('#<%=txtname.ClientID%>').val() != '') {
                $.ajax({
                    url: "AddManufacture.aspx/checkduplicate",
                    data: '{Name:"' + $('#<%=txtname.ClientID%>').val() + '",ID:"' + $('#itemid').html() + '"}',
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d != "0") {
                            $('#duplicateitem').html('Duplicate');
                            $('#duplicateitem').css('color', 'red');
                            $('#<%=txtname.ClientID%>').val('');
                            $('#<%=txtname.ClientID%>').focus();
                        }
                        else {
                            $('#duplicateitem').html('');
                        }
                    },
                    error: function (xhr, status) {
                        //alert(xhr.responseText);
                    }
                });




            }
        }
    </script>

      <script type="text/javascript">

          function split(val) {
              return val.split(/,\s*/);
          }
          function extractLast(term) {


              return split(term).pop();
          }
          $(function () {
              $("#txtname")
                    // don't navigate away from the field on tab when selecting an item
                    .bind("keydown", function (event) {
                        if (event.keyCode === $.ui.keyCode.TAB &&
                            $(this).autocomplete("instance").menu.active) {
                            event.preventDefault();
                        }

                    })
                    .autocomplete({
                        autoFocus: true,
                        source: function (request, response) {
                            $.ajax({
                                url: "AddManufacture.aspx/bindolditemname",
                                data: '{itemname:"' + extractLast(request.term) + '"}',
                                contentType: "application/json; charset=utf-8",
                                type: "POST", // data has to be Posted 
                                timeout: 120000,
                                dataType: "json",
                                async: true,
                                success: function (result) {
                                    response($.map(jQuery.parseJSON(result.d), function (item) {
                                        return {
                                            label: item.itemnamegroup,
                                            value: item.itemidgroup
                                        }
                                    }))


                                },
                                error: function (xhr, status) {
                                    showerrormsg(xhr.responseText);
                                }
                            });
                        },
                        search: function () {
                            // custom minLength

                            var term = extractLast(this.value);
                            if (term.length < 2) {
                                return false;
                            }
                        },
                        focus: function () {
                            // prevent value inserted on focus
                            return false;
                        },
                        select: function (event, ui) {


                            this.value = '';

                            // setdata(ui.item.value, ui.item.label);
                            // AddItem(ui.item.value);

                            return false;
                        },

                    });
          });


    </script>
</head>

<body>

    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

    <form id="form1" runat="server" style="background-color: #e3eff9;">
      
    <div style="width: 800px;min-height:500px; margin: 0 auto;">
        <div class="" style="width: 800px">
            <div class="content" style="text-align: center;">
                <b>Store Manufacture Master</b>
                <br />   <asp:Label id="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
        </div>
        
        <div class="" style="width: 800px">

            <div class="content" style="width: 800px;">
               
              <table  style="width:800px">

                                  
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                            <strong>Name:</strong></td>
                      <td style="text-align: left" colspan="">
                          <div class="ui-widget" style="display: inline-block;">
                          <asp:TextBox ID="txtname" runat="server" style="text-transform:uppercase" CssClass="textbox" onblur="checkduplicate()" />
                              </div>
                     <span id="duplicateitem" style="font-weight: bold;"></span>
                          <asp:TextBox ID="txtId" runat="server" Visible="false" CssClass="textbox" /></td>
                <%--  </tr>
                   <tr>--%>
                    
                      <td class="auto-style1">
                            Contact Person:</td>
                     <td style="text-align: left" colspan="">
                          <asp:TextBox ID="txtconper" runat="server"  CssClass="textbox" /></td>
                     
                  </tr>
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                            DL No:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtdlno" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          Tin No:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txttinno" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          &nbsp;</td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                 
                  
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                            Mobile:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtmobile" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          Phone:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtphone" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          &nbsp;</td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                            Email</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtemail" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          Fax:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtfax" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          &nbsp;</td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                            Address1:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtaddress1" runat="server" CssClass="textbox" /></td>
                      <td style="text-align: left">
                          Address2:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtaddress2" runat="server" CssClass="textbox" /></td>
                      <td style="text-align: left">
                          &nbsp;</td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                            Address3:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtaddress3" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          Country:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtcountry" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          &nbsp;</td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                            City</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtcity" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          Pincode:</td>
                      <td style="text-align: left">
                          <asp:TextBox ID="txtpincode" runat="server" CssClass="textbox"  /></td>
                      <td style="text-align: left">
                          &nbsp;</td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                           Status:</td>
                      <td style="text-align: left" colspan="4">
                        <asp:CheckBox ID="ChkActivate" runat="server" Checked="True"
                                Text="Active" />
                           </td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center" colspan="7">
                           <input type="button" id="btnsave"  runat="server" value="Save" class="savebutton" onclick="savedata()" />
                         <asp:Button  runat="server" ID="btnUpdate" Visible="false" Text="Update" class="savebutton" OnClick="btnUpdate_Click"/>
                      
                      </td>
                  </tr>
                  
                
                 
                  
                
              </table>

                
            </div>
        </div>
        <div class="" style="width: 800px">

            <div class="content" style="width: 800px;">
                <div style="width: 800px;height:300px;overflow:scroll;">
                <table style="width:780px;">
                     <tr>
                      <td align="center" >
                         <asp:GridView ID="mygrd" runat="server" AutoGenerateColumns="False" EnableModelValidation="True" CssClass="GridViewStyle1 gradient-style" Width="100%" OnSelectedIndexChanged="mygrd_SelectedIndexChanged">
                              <Columns>
                                  <asp:TemplateField HeaderText="ID">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("ID") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label1" runat="server" Text='<%# Bind("ID") %>'></asp:Label>
                                      </ItemTemplate>
                                      <HeaderStyle CssClass="GridViewHeaderStyle" />
                                      <ItemStyle CssClass="GridViewItemStyle" />
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Name">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                                      </ItemTemplate>
                                      <HeaderStyle CssClass="GridViewHeaderStyle" />
                                      <ItemStyle CssClass="GridViewItemStyle" />
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Contact Person">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Contact_Person") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label3" runat="server" Text='<%# Bind("Contact_Person") %>'></asp:Label>
                                      </ItemTemplate>
                                      <HeaderStyle CssClass="GridViewHeaderStyle" />
                                      <ItemStyle CssClass="GridViewItemStyle" />
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Contact No">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("mobile") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label4" runat="server" Text='<%# Bind("mobile") %>'></asp:Label>
                                      </ItemTemplate>
                                      <HeaderStyle CssClass="GridViewHeaderStyle" />
                                      <ItemStyle CssClass="GridViewItemStyle" />
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Status">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("Status") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label5" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
                                      </ItemTemplate>
                                      <HeaderStyle CssClass="GridViewHeaderStyle" />
                                      <ItemStyle CssClass="GridViewItemStyle" />
                                  </asp:TemplateField>
                                  
                                     <asp:TemplateField HeaderText="Edit">
                      <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                   <ItemTemplate>
                       <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                           Text="Select"></asp:LinkButton>
                   </ItemTemplate>
                   
               </asp:TemplateField>
       
                                  <asp:TemplateField HeaderText="ADDRESS" Visible="false" >
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("ADDRESS") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label6" runat="server" Text='<%# Eval("ADDRESS") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Address2" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox7" runat="server" Text='<%# Bind("Address2") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label7" runat="server" Text='<%# Bind("Address2") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Address3" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox8" runat="server" Text='<%# Bind("Address3") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label8" runat="server" Text='<%# Bind("Address3") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Phone" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox9" runat="server" Text='<%# Bind("PHONE") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label9" runat="server" Text='<%# Bind("PHONE") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Fax" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox10" runat="server" Text='<%# Bind("FAX") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label10" runat="server" Text='<%# Bind("FAX") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Email" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox11" runat="server" Text='<%# Bind("EMAIL") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label11" runat="server"  Text='<%# Bind("EMAIL") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Country" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox12" runat="server"  Text='<%# Bind("Country") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label12" runat="server" Text='<%# Bind("Country") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="City" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox13" runat="server" Text='<%# Bind("City") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label13" runat="server" Text='<%# Bind("City") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="PinCode" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox14" runat="server" Text='<%# Bind("PinCode") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label14" runat="server" Text='<%# Bind("PinCode") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="DLNO" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox15" runat="server" Text='<%# Bind("DLNO") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label15" runat="server" Text='<%# Bind("DLNO") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="TINNO" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox16" runat="server" Text='<%# Bind("TINNO") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label16" runat="server" Text='<%# Bind("TINNO") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                 <%-- <asp:TemplateField HeaderText="UserID" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox17" runat="server" Text='<%# Bind("UserID") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label17" runat="server"  Text='<%# Bind("UserID") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="EntryDate" Visible="False">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox18" runat="server" Text='<%# Bind("EntryDate") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label18" runat="server" Text='<%# Bind("EntryDate") %>'></asp:Label>
                                      </ItemTemplate>
                                  </asp:TemplateField>--%>
                              </Columns>
                                      
                          </asp:GridView> </td>
                  </tr>
                </table></div>
            </div>
        </div>

    </div>
   
    </form>

</body>
</html>