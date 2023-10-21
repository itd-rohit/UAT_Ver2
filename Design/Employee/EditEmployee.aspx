<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EditEmployee.aspx.cs" Inherits="Design_Employee_EditEmployee" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
  <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
     <%: Scripts.Render("~/bundles/JQueryStore") %>
    <style type="text/css">
        .web_dialog_overlay {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            background: #000000;
            opacity: .15;
            filter: alpha(opacity=15);
            -moz-opacity: .15;
            z-index: 101;
            display: none;
        }

        .web_dialog {
            display: none;
            position: fixed;
            width: 600px;
            height: 185px;
            top: 50%;
            left: 42%;
            margin-left: -190px;
            margin-top: -100px;
            background-color: #ffffff;
            border: 2px solid #336699;
            padding: 0px;
            z-index: 102;
            font-family: Verdana;
            font-size: 10pt;
        }

        .web_dialog_title {
            border-bottom: solid 2px #336699;
            background-color: #336699;
            padding: 4px;
            color: White;
            font-weight: bold;
        }

            .web_dialog_title a {
                color: White;
                text-decoration: none;
            }

        .align_right {
            text-align: right;
        }
    </style>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Search Employee</b><br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlSearchType" runat="server" CssClass="ddlSearchType chosen-select chosen-container"
                        TabIndex="2">
                        <asp:ListItem Selected="true" Value="Name">Employee Name</asp:ListItem>
                        <asp:ListItem Value="fl.UserName">User Name</asp:ListItem>
                        <asp:ListItem>PCC</asp:ListItem>
                        <asp:ListItem>Sub PCC</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                        ToolTip="Enter Patient ID" TabIndex="1"></asp:TextBox>
                </div>
                <div class="col-md-2">
                    Center&nbsp; :&nbsp;
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlCentre" runat="server"  CssClass="ddlCentre chosen-select chosen-container"
                        TabIndex="2">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    Status :
                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rd" runat="server" RepeatLayout="Table" RepeatDirection="Horizontal" Style="font-weight: 700">
                        <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                        <asp:ListItem Value="0">Deactive</asp:ListItem>
                        <asp:ListItem Value="2">All</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <asp:Button ID="btnSearch" runat="server" CssClass="searchbutton" TabIndex="7"
                    Text="Search" OnClick="btnSearch_Click" />
            </div>

        </div>
        <div id="output"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <div id="dialog" class="web_dialog">
            <table style="width: 100%; border: 0px;" cellpadding="3" cellspacing="0">
                <tr>
                    <td class="web_dialog_title">
                        <asp:Label ID="lblData" runat="server" Text=""></asp:Label></td>
                    <td class="web_dialog_title align_right"><a onclick="HideDialog();" style="cursor: pointer;">Close</a></td>
                </tr>

                <tr>
                    <td colspan="2" style="padding-left: 15px;">
                        <div class="content" style="overflow: scroll; height: 130px;">
                            <table style="width: 99%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                            </table>
                        </div>
                    </td>
                </tr>


            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Employee Details
            </div>

            <div style="margin-top: 5px; max-height: 400px; overflow: scroll; width: 100%;">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False"
                    OnPageIndexChanging="GridView1_PageIndexChanging" TabIndex="10"
                    CssClass="GridViewStyle" PageSize="20" OnRowCommand="GridView1_RowCommand" Style="background-color: #D7EDFF;" Width="0px">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Name" HeaderText="Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="440px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="230px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="UserName" HeaderText="User Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="210px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Mobile" HeaderText="Mobile">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:BoundField>
                        

                        <asp:TemplateField HeaderText="Centre" ItemStyle-HorizontalAlign="Center">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <img src="../../App_Images/view.GIF" src="" style="cursor: pointer" onclick="GetData('Centre_<%#Eval("Employee_ID") %>_<%#Eval("NAME") %>');" />
                            </ItemTemplate>

                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Role" ItemStyle-HorizontalAlign="Center">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <img src="../../App_Images/view.GIF" src="" style="cursor: pointer" onclick="GetData('Role_<%#Eval("Employee_ID") %>_<%#Eval("NAME") %>');" />
                            </ItemTemplate>

                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Active" HeaderText="Active">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Edit">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:Button runat="server" ID="btnedit" Text="Edit" CommandName="Edited" CommandArgument='<%#Eval("Employee_ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                       <asp:BoundField DataField="CreatedDate" HeaderText="Created DateTime" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px"/>
                            </asp:BoundField>
							
                            <asp:BoundField DataField="CreatedBy" HeaderText="Created By" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px"/>
                            </asp:BoundField>
                         <asp:BoundField DataField="DeactivatedDateTime" HeaderText="Deactivated DateTime" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px"/>
                            </asp:BoundField>
                            <asp:BoundField DataField="DeactivatedBy" HeaderText="Deactivated By" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px"/>
                            </asp:BoundField>
                            
                            <asp:BoundField DataField="LastPasswordChangeDateTime" HeaderText="Last Password Change DateTime" >
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px"/>
                            </asp:BoundField>
                           
							 <asp:TemplateField HeaderText="Store Location" ItemStyle-HorizontalAlign="Center">
                                     <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px"/>
                                                <ItemTemplate>
                                                   <img src="../../App_Images/Hide.GIF" style="cursor:pointer" alt="" onclick="openmypopup('<%#Eval("Employee_ID")%>');" />
                                                </ItemTemplate>
                            </asp:TemplateField>

                        <asp:TemplateField HeaderText="Change">
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:Button runat="server" ID="btnActive" Text="Activate" CommandName="Active" CommandArgument='<%#Eval("Employee_ID") %>' Visible='<%#!Util.GetBoolean(Eval("IsActive")) %>' />
                                <asp:Button runat="server" ID="btnInActive" Text="De-Activate" CommandName="InActive" CommandArgument='<%#Eval("Employee_ID") %>' Visible='<%#Util.GetBoolean(Eval("IsActive")) %>' />

                            </ItemTemplate>
                        </asp:TemplateField>


                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        function openmypopup(filename) {
          
            $encryptQueryStringData(filename, function ($returnData) {              
                var href = 'EmployeeStoreLocationMapping.aspx?employeeid=' + $returnData;
                var width = '1100px';
                $.fancybox({
                    'background': 'none',
                    'hideOnOverlayClick': true,
                    'overlayColor': 'gray',
                    'width': width,
                    'height': '800px',
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
            });
            
        }
    </script>
      <script type="text/javascript">
          function doClick(buttonName, e) {
              //the purpose of this function is to allow the enter key to 
              //point to the correct button to click.
              var key;

              if (window.event)
                  key = window.event.keyCode;     //IE
              else
                  key = e.which;     //firefox

              if (key == 13) {
                  //Get the button the user wants to have clicked
                  var btn = document.getElementById(buttonName);
                  if (btn != null) { //If we find the button click it
                      btn.click();
                      event.keyCode = 0
                  }
              }
          }

          function GetData(Data) {
              var EmployeeID = Data.split('_')[1];
              var SearchType = Data.split('_')[0];
              var EmployeeName = Data.split('_')[2];
              $('#tb_ItemList tr').remove();
              serverCall('EditEmployee.aspx/GetData', { EmployeeID: EmployeeID, SearchType: SearchType, EmployeeName: EmployeeName }, function (result) {
                  var $EmpData = $.parseJSON(result);
                  if ($EmpData.length > 0) {
                      for (var i = 0; i <= $EmpData.length - 1; i++) {
                          var $mydata = [];
                          $mydata.push("<tr>");
                          if (SearchType == "Centre") {
                              $mydata.push("<td>"); $mydata.push($EmpData[i].Centre); $mydata.push("</td>");
                          }
                          else {
                              $mydata.push("<td>"); $mydata.push($EmpData[i].RoleName); $mydata.push("</td>");
                          }
                          $mydata.push("</tr>");
                          $mydata = $mydata.join("");
                          jQuery('#tb_ItemList').append($mydata);

                      }
                      ShowDialog();
                      if (SearchType == "Centre") {
                          $('#<%=lblData.ClientID%>').html('Centre Data &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + 'Employee Name : ' + EmployeeName);
                    }
                    else {
                        $('#<%=lblData.ClientID%>').html('Role Data &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + 'Employee Name : ' + EmployeeName);
                    }
                }
                else {
                    toast("Info", 'Record Not Found', '');
                }


            });
        }
        function ShowDialog(modal) {
            $("#overlay").show();
            $("#dialog").fadeIn(300);
            if (modal) {
                $("#overlay").unbind("click");
            }
            else {
                $("#overlay").click(function (e) {
                    HideDialog();
                });
            }
        }

        function HideDialog() {
            $("#overlay").hide();
            $("#dialog").fadeOut(300);
        }
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
            
        });
    </script>
</asp:Content>

