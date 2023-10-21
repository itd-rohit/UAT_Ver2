<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddUnit.aspx.cs" Inherits="Design_Store_AddUnit" %>

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
            var AllowDecimalValue = $('#<%=chkAllowDecimalValue.ClientID%>').is(':checked') ? 1 : 0;
            $.ajax({
                url: "AddUnit.aspx/saveunit",
                data: '{name:"' + $('#<%=txtname.ClientID%>').val() + '",AllowDecimalValue :"' + AllowDecimalValue + '" }', // parameter map       
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    showmsg(" Record Successfully Saved ...!")
                    $('#<%=txtname.ClientID%>').val('')                     
                    var data = $.parseJSON(result.d)
                    window.parent.$('select[id="ContentPlaceHolder1_ddlpunit"]').append('<option value="' + data.UnitID + '" >' + data.UnitName + '</option>');
                    window.parent.$('select[id="ContentPlaceHolder1_ddlcounit"]').append('<option value="' + data.UnitID + '" >' + data.UnitName + '</option>');
                    location.reload();
                },
                error: function (xhr, status) {


                }


            });
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
                              url: "AddUnit.aspx/bindolditemname",
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
       
    <div id="" style="width: 600px; margin: 0 auto;">
        <div class="" style="width: 500px">
            <div class="content" style="text-align: center;">
                <b>Store Unit Master</b>
                <br /><asp:Label id="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
        </div>
        
        <div class="" style="width: 600px">

            <div class="content" style="width: 500px;    margin: 0 auto;">
               
              <table width="90%">

                  <tr>
                      <td style="text-align: center" colspan="4">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                            <strong>Name:</strong></td>
                      <td style="text-align: left">
                           <div class="ui-widget" style="display: inline-block;">
                          <asp:TextBox ID="txtname" runat="server" Width="217px" CssClass="textbox" style='text-transform:uppercase' />
                               </div>
                             <asp:TextBox ID="txtId" runat="server" Visible="false" CssClass="textbox"></asp:TextBox></td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center">
                           &nbsp;</td>
                      <td class="auto-style1">
                           Active:</td>
                      <td style="text-align: left">
                        <asp:CheckBox ID="ChkActivate" runat="server" Checked="True"
                                 />&nbsp;&nbsp;&nbsp;&nbsp;AllowDecimalValue :&nbsp;<asp:CheckBox ID="chkAllowDecimalValue" runat="server" 
                               />
                           </td>
                      <td style="text-align: center">
                           &nbsp;</td>
                  </tr>
                  
                
                  <tr>
                      <td style="text-align: center" colspan="4">
                           <input type="button" value="Save" onclick="savedata()" class="savebutton" runat="server" id="btnsave" />
                      <asp:Button  runat="server" ID="btnUpdate"  Visible="false" Text="Update" OnClick="btnUpdate_Click" class="savebutton" />
                      
                           
                      </td>
                  </tr>
                  
                
                 
                  
                
              </table>
            </div>
        </div>
       <div class="" style="width: 500px">

            <div class="content" style="width: 500px;">
                <div style="width:550px;height:300px;overflow:scroll;">
                <table width="100%">
                     <tr>
                      <td align="center" >
                          <asp:GridView ID="mygrd" runat="server" AutoGenerateColumns="False" EnableModelValidation="True" CssClass="GridViewStyle1 gradient-style" Width="480px" OnSelectedIndexChanged="mygrd_SelectedIndexChanged">
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
                                  <asp:TemplateField HeaderText="Name" HeaderStyle-Width="220px">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                                        
                                      </ItemTemplate>
                                      <HeaderStyle CssClass="GridViewHeaderStyle" />
                                      <ItemStyle CssClass="GridViewItemStyle" />
                                  </asp:TemplateField>
                                  <asp:TemplateField HeaderText="AllowDecimalValue" HeaderStyle-Width="120px">
                                      <EditItemTemplate>
                                          <asp:TextBox ID="txtAllowDecimalValue" runat="server" Text='<%# Bind("AllowDecimalValue") %>'></asp:TextBox>
                                      </EditItemTemplate>
                                      <ItemTemplate>
                                          <asp:Label ID="lblAllowDecimalValue" runat="server" Text='<%# Bind("AllowDecimalValue") %>'></asp:Label>
                                        
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
                              </Columns>
                                      
                          </asp:GridView></td>
                  </tr>
                </table></div>
            </div>
        </div>

    </div>
 
    </form>
    
</body>
</html>
