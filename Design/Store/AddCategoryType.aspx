<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddCategoryType.aspx.cs" Inherits="Design_Store_AddCategoryType" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <%: Scripts.Render("~/bundles/WebFormsJs") %>


    <script type="text/javascript">
$(function () {
          $("#masterheaderid,#mastertopcorner,#btncross,#btnfeedback,#rdoIndentType,#divMasterNav").hide();
                
                $("#Pbody_box_inventory").css('margin-top', 0);
 });
        function savedata() {

            if ($('#<%=txtname.ClientID%>').val() == "") {
                toast("Error", "Please Enter Name..!");
                $('#<%=txtname.ClientID%>').focus();
                return;
            }
            var active = "0";
            if ($('#<%=ChkActivate.ClientID%>').is(':checked')) {
                active = "1";

            }
            serverCall('AddCategoryType.aspx/savegroup', { name: $('#<%=txtname.ClientID%>').val(), active: active, Code: $('#<%=txtCode.ClientID%>').val(), Description: $('#<%=txtDescription.ClientID%>').val() }, function (response) {
                var data = $.parseJSON(response)
                if (data.success == "1") {
                    window.parent.$('select[id="ddlcategorytype"]').append('<option value="' + data.ID + '" >' + data.Name + '</option>');
                    toast("Success", " Record Succesfully Saved")

                    location.reload();

                }


                if (response == "0") {

                    toast("Error", "Category Name is Already Exist");

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

                          serverCall('AddCategoryType.aspx/bindolditemname', {itemname: extractLast(request.term) }, function (responseResult) {
                              response($.map(jQuery.parseJSON(responseResult), function (item) {
                                  return {
                                      label: item.itemnamegroup,
                                      value: item.itemidgroup
                                  }
                              }))
                          },'',false);


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

    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Category Type Master</b>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" >
                <div class="row">
                    <div class="col-md-4 ">
                        <label class="pull-left ">CategoryType Code  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6 ">
                        <asp:TextBox ID="txtCode" runat="server" MaxLength="20" />

                    </div>
                    <div class="col-md-4 ">
                        <label class="pull-left ">CategoryType Name  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6 ">
                        <asp:TextBox ID="txtname" runat="server" Style='text-transform: capitalize'  CssClass="requiredField"/>
                        <asp:TextBox ID="txtId" runat="server" Visible="false"></asp:TextBox>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-4 ">
                        <label class="pull-left ">Description  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6 ">
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="280px" Height="60px" />
                    </div>

                    <div class="col-md-4 ">
                        <label class="pull-left ">Status  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6 ">
                        <asp:CheckBox ID="ChkActivate" runat="server" Checked="True"
                            Text="Active" />
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="row" style="text-align: center">
                    <div class="col-md-24 ">
                        <input type="button" runat="server" value="Save" onclick="savedata()" id="Button1" class="savebutton" />
                        <asp:Button runat="server" ID="btnUpdate" Visible="false" Text="Update" class="savebutton" OnClick="btnUpdate_Click" />
                    </div>
</div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center">

                    <div class="row" style="text-align: center">
                        <div class="col-md-24 ">



                            <asp:GridView ID="mygrd" runat="server" AutoGenerateColumns="False" EnableModelValidation="True" CssClass="GridViewStyle1 gradient-style" Width="100%" OnSelectedIndexChanged="mygrd_SelectedIndexChanged">
                                <Columns>
                                    <asp:TemplateField HeaderText="ID">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("CategoryTypeID") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("CategoryTypeID") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="CategoryTypeCode">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtCategorycode" runat="server" Text='<%# Bind("CategoryTypeCode") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("CategoryTypeCode") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="CategoryTypeName">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("CategoryTypeName") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("CategoryTypeName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Description">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtDescription" runat="server" Text='<%# Bind("Description") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="Label5" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Status") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
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

                            </asp:GridView>

                        </div>
                    </div>
                
            </div>
        </div>
    </form>
</body>
</html>
