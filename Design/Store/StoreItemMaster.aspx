<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StoreItemMaster.aspx.cs" Inherits="Design_Store_StoreItemMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />


    <%: Scripts.Render("~/bundles/JQueryStore") %>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Store Item Master</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center" id="makerdiv">

            
                <div class="Purchaseheader">
                    Item Detail
                </div>


                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left ">Category Type   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8 ">
                        <asp:DropDownList ID="ddlcategorytype" ClientIDMode="Static" runat="server" TabIndex="1" CssClass="requiredField" onchange="bindsubcategory()"></asp:DropDownList>

                    </div>
                    <div class="col-md-3 ">
                        <% if (UserInfo.RoleID == 177)
                           {
                        %>
                        <img src="../../App_Images/Reload.jpg" onclick="bindcategory()" style="cursor: pointer;" />&nbsp;&nbsp;
                                <input type="button" class="myButton" value="Add New" onclick="openmypopup('AddCategoryType.aspx')" />
                        <%} %>
                        <a id="various2" style="display: none">Ajax</a>&nbsp; 
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left">Item Name  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6 ">
                        <asp:TextBox ID="txtitemname" TabIndex="4" CssClass="requiredField" runat="server" Style="text-transform: capitalize" ClientIDMode="Static"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left">Sub Category Type   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8 ">
                        <asp:DropDownList ID="ddlsubcategorytype" ClientIDMode="Static" runat="server" TabIndex="2" CssClass="requiredField" onchange="binditemcategory()">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 ">
                        <% if (UserInfo.RoleID == 177)
                           {%>
                        <img src="../../App_Images/Reload.jpg" onclick="bindsubcategory()" style="cursor: pointer;" />&nbsp;&nbsp;
                                <input type="button" class="myButton" value="Add New" onclick="openmypopup('AddSubCategoryType.aspx')" />&nbsp; 
                            <%} %>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left">Item Description  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6 ">
                        <asp:TextBox ID="txtDesc" runat="server" CssClass="textbox" MaxLength="500" TabIndex="5" TextMode="SingleLine"></asp:TextBox>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left">Item Type</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8 ">
                        <asp:DropDownList ID="ddlitemType" ClientIDMode="Static" TabIndex="3" runat="server" CssClass="requiredField">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 ">
                        <% if (UserInfo.RoleID == 177)
                           {%>
                        <img src="../../App_Images/Reload.jpg" onclick="binditemcategory()" style="cursor: pointer;" />&nbsp;&nbsp;
                                <input type="button" class="myButton" value="Add New" onclick="openmypopup('AddItemGroup.aspx')" />&nbsp;
                                <%} %>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left">Item Code  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6 ">
                        <span id="itemid" style="display: none;"></span>
                        <asp:TextBox ID="txtItemCode" runat="server"  Style="text-transform: uppercase" TabIndex="6" MaxLength="25"></asp:TextBox>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left">HSN Code</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2 ">
                        <asp:TextBox ID="txthsn" runat="server" CssClass="requiredField" Style="text-transform: uppercase" TabIndex="7"></asp:TextBox>
                    </div>
                    <div class="col-md-9 ">
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left">GST Tax %  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-1 ">
                        <asp:TextBox ID="txtamount" runat="server" CssClass="requiredField NumOnly" TabIndex="9"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers,Custom" TargetControlID="txtamount" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left">Temperature  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2 ">
                        <asp:TextBox ID="txttemp" runat="server" CssClass="textbox" TabIndex="10">
                        </asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left">Item Specification</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-11 ">
                        <asp:TextBox ID="txtspec" runat="server" CssClass="textbox" MaxLength="1000" TabIndex="5" TextMode="SingleLine"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left">Make and Model No.</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-11 ">
                        <asp:TextBox ID="txtmakeandmodel" runat="server" CssClass="textbox" MaxLength="1000" TabIndex="5" TextMode="SingleLine"></asp:TextBox>
                    </div>
                     <div class="col-md-10 ">
                                            <asp:CheckBox ID="chissuefifo" onclick="checkbarcodeoption()" runat="server" Text="Issue In FIFO Order" ToolTip="Check if Issue in First In First Out Order" Checked="true" />
                          </div>
                </div>
                <div class="row">
                    
                    <div class="col-md-3 ">
                        <label class="pull-left">Barcode Option </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3 ">
                        <asp:DropDownList ID="ddlbarcodeoption" runat="server" CssClass="requiredField">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1">Stock Wise</asp:ListItem>
                            <asp:ListItem Value="2">Item Wise</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4 ">
                        <label class="pull-left">Barcode Generation Option  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3 ">
                        <asp:DropDownList ID="ddlbarcodegertationoption" runat="server">
                            <asp:ListItem Value="2">System Generated</asp:ListItem>
                            <asp:ListItem Value="1">Self</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3 ">
                        <asp:CheckBox ID="chexpirable" runat="server" Text="IsExpirable" Font-Bold="true" onclick="showexoption()" />
                    </div>
                    <div class="col-md-3 ">
                        <label class="pull-left">Expiry date cutoff:</label>
                    </div>
                    <div class="col-md-2 ">
                        <asp:TextBox ID="txtExpdatecutoff" runat="server" CssClass="textbox NumOnly" MaxLength="3" TabIndex="8" Enabled="false"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtExpdatecutoff">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-1 ">
                        <label class="pull-left">Days  </label>
                    </div>
                </div>


            
            <div class="Purchaseheader">
                Manufacture Detail
                      <input type="button" id="autocon" value="Reagent Items Mapping to Test" style="display: none; font-weight: bold; cursor: pointer; width: 316px; background-color: #fffa90;" class="myButton" onclick="openautoconsume()" />
                <span id="st" style="color: red; font-weight: bold; display: none;">Auto Consumed</span>
            </div>
            <div class="row" >

                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left">Manufacture</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6 ">
                        <asp:DropDownList ID="ddlmanu" CssClass="requiredField" runat="server"></asp:DropDownList>
                    </div>
                    <div class="col-md-1 ">
                        <% if (UserInfo.RoleID == 177)
                           { %>
                        <img src="../../App_Images/plus.png" style="cursor: pointer"  onclick="openmypopup('AddManufacture.aspx')" />
                        <%} %>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Catalog No.</label>
                        <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-3 ">
                        <asp:TextBox ID="txtcatalogno" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Machine  </label>
                        <b class="pull-right">:</b>
                    </div>
					
                    <div class="col-md-6 ">
                        <asp:DropDownList ID="ddlmachine" runat="server"></asp:DropDownList>
                    </div>
					<div class="col-md-1 ">
                        
                        <img src="../../App_Images/plus.png" style="cursor: pointer"  onclick="openmacpopup()" />
                        
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 ">
                        <label class="pull-left">Purchased Unit</label>
                        <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-2 ">
                        <asp:DropDownList ID="ddlpunit" CssClass="requiredField" runat="server"></asp:DropDownList>
                    </div>
                    <div class="col-md-1 ">
                        <% if (UserInfo.RoleID == 177)
                           { %>
                        <img src="../../App_Images/plus.png" style="cursor: pointer" onclick="openmypopup('AddUnit.aspx')" />
                        <%} %>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Converter</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-1 ">
                        <asp:TextBox ID="txtconverter" runat="server" Text="1"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender3" runat="server" FilterType="Numbers,Custom" TargetControlID="txtconverter" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">Pack Size </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-1 ">
                        <asp:TextBox ID="txtpacksize" runat="server" Text="1"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Consumption Unit</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2 ">
                        <asp:DropDownList ID="ddlcounit" CssClass="requiredField" runat="server"></asp:DropDownList>
                    </div>
                    <div class="col-md-1 ">
                        <% if (UserInfo.RoleID == 177)
                           { %>
                        <img src="../../App_Images/plus.png" style="cursor: pointer" onclick="openmypopup('AddUnit.aspx')" />
                        <%} %>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">IssueMultiplier</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtissuemulti" runat="server" Text="0"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender4" runat="server" FilterType="Numbers" TargetControlID="txtissuemulti">
                        </cc1:FilteredTextBoxExtender>
                    </div>
                    <div class="col-md-1 ">
                        <img src="../../App_Images/ButtonAdd.png" style="cursor: pointer;" id="imgAddManufacture" alt="Manufacture" onclick="addManufacture()" />
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-24 ">
                      
                                    <table id="tblmanufacture" style="width: 100%; border-collapse: collapse">
                                        <tr id="trmanuheader">
                                            <td class="GridViewHeaderStyle" style="width: 20px;">Active</td>
                                            <td class="GridViewHeaderStyle">Manufacture Company</td>
                                            <td class="GridViewHeaderStyle">Catalog No.</td>
                                            <td class="GridViewHeaderStyle">Machine Name</td>
                                            <td class="GridViewHeaderStyle">Purchased Unit</td>
                                            <td class="GridViewHeaderStyle">Converter</td>
                                            <td class="GridViewHeaderStyle">Pack Size</td>
                                            <td class="GridViewHeaderStyle">Consumption Unit</td>
                                            <td class="GridViewHeaderStyle">Issue Multiplier</td>
                                        </tr>
                                    </table>
                                
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-24" style="text-align: center">
                        <input type="button" value="Save" class="savebutton" onclick="savenewitem();" id="btnsave" />
                        <input type="button" value="Update" class="savebutton" onclick="updateitem();" id="btnupdate" style="display: none;" />
                        <input type="button" value="Reset" class="resetbutton" onclick="clearForm();" />
                    </div>
                </div>
            </div>


        </div>

        <div class="POuter_Box_Inventory" style="text-align: center" id="Div1">
            <div id="Div2">
                <div class="Purchaseheader">
                    Item Detail
                </div>
                <div class="row" >
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-24 ">
                                <table style="width:100%">
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No of Record:&nbsp;&nbsp;</td>
                                        <td>
                                            <asp:DropDownList ID="ddlnoofrecord" runat="server" Width="80" Font-Bold="true">
                                                <asp:ListItem Value="5">5</asp:ListItem>
                                                <asp:ListItem Value="10">10</asp:ListItem>
                                                <asp:ListItem Value="20">20</asp:ListItem>
                                                <asp:ListItem Value="50">50</asp:ListItem>
                                                <asp:ListItem Value="100">100</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlsearchtypedropdown" runat="server" onchange="setcontrolforsearch()">
                                                <asp:ListItem Value="0">Select
                                                </asp:ListItem>
                                                <asp:ListItem Value="sm.CategoryTypeID">Category Type
                                                </asp:ListItem>
                                                <asp:ListItem Value="sm.SubCategoryTypeID">SubCategory Type
                                                </asp:ListItem>
                                                <asp:ListItem Value="sm.ItemGroupId">Item Group
                                                </asp:ListItem>
                                                <asp:ListItem Value="sm.ManufactureID">Manufacture
                                                </asp:ListItem>
                                                <asp:ListItem Value="sm.MachineId">Machine
                                                </asp:ListItem>

                                            </asp:DropDownList>
                                        </td>
                                        <td style="text-align: left">
                                            <asp:DropDownList ID="ddlcategorysearch" ClientIDMode="Static" runat="server" CssClass="textbox"
                                                Width="250px">
                                                <asp:ListItem Value="0">Select</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlsearchtype" runat="server">
                                                <asp:ListItem Value="sm.typename">Item Name</asp:ListItem>
                                                <asp:ListItem Value="sm.HSNCode">Hsn Code</asp:ListItem>
                                                <asp:ListItem Value="sm.ApolloItemCode">Item Code</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="text-align: left">
                                            <asp:TextBox ID="txtsearchvalue" runat="server" Width="140px" />
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlapptype" runat="server">
                                                <asp:ListItem Value="">App Type</asp:ListItem>
                                                <asp:ListItem Value="0">Maked</asp:ListItem>
                                                <asp:ListItem Value="1">Checked</asp:ListItem>
                                                <asp:ListItem Value="2">Approved</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <input type="button" value="Search" class="searchbutton" onclick="searchitem()" />
                                        </td>
                                        <td>
                                            <input type="button" value="Excel" class="searchbutton" onclick="searchitemexcel()" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24 ">
                                <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;"></td>
                                        <td class="GridViewHeaderStyle" style="width: 30px;">Select</td>
                                        <td class="GridViewHeaderStyle">Category Type</td>
                                        <td class="GridViewHeaderStyle">Sub Category Type</td>
                                        <td class="GridViewHeaderStyle">Item Type</td>
                                        <td class="GridViewHeaderStyle">Item Name</td>
                                        <td class="GridViewHeaderStyle">HSN Code</td>
                                        <td class="GridViewHeaderStyle">Item Code</td>
                                        <td class="GridViewHeaderStyle">GST Tax</td>
                                        <td class="GridViewHeaderStyle">Expirable</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center" id="Div3">
            <div id="Div4">
                <div class="row" >
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-24 ">
                                <asp:Panel ID="paneldetail" runat="server" BackColor="#EAF3FD" BorderStyle="None" Style="display: none;">
                                    <div class="POuter_Box_Inventory" style="width: 100%">
                                        <div class="content" style="text-align: center; width: 100%;">
                                            <strong>Auto Consume Item</strong><br />
                                            <table width="100%">
                                                <tr>
                                                    <td><strong>Test/Parameter:</strong>
                                                        <asp:DropDownList CssClass="textbox" ID="ddlinv" runat="server" Width="300px" />&nbsp;&nbsp;
                                                    </td>
                                                    <td><strong>Center:</strong>
                                                        <asp:DropDownList ID="ddlcentermapping" CssClass="textbox" runat="server" onchange="machine();"></asp:DropDownList>&nbsp;&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <strong>Machine:</strong>
                                                        <asp:DropDownList ID="ddllabmachine" CssClass="textbox" runat="server" Width="200px" />&nbsp;&nbsp;
                           <input type="button" value="Add" class="myButton" onclick="additemingrid()" />
                                                    </td>

                                                    <td>&nbsp;</td>
                                                </tr>

                                                <tr>
                                                    <td colspan="2">
                                                        <table width="99%" id="detailtable" cellpadding="1" rules="all" border="1" style="border-collapse: collapse">

                                                            <tr style="height: 25px; font-weight: bold; background-color: #965720; color: white;" id="header">
                                                                <td width="8%">S.No.</td>
                                                                <td width="40%">Test/Parameter</td>
                                                                <td width="12%">Type</td>
                                                                <td width="10%">Machine</td>
                                                                <td width="8%">Qty</td>
                                                                <td width="20%">Unit</td>
                                                                <td width="2%">#</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <input type="button" value="Save" class="myButton" onclick="saveconsumedata()" />&nbsp;&nbsp;
                           <input type="button" value="Close" class="myButton" onclick="closepopup()" />&nbsp;&nbsp;
                           <asp:Button ID="btnclose" runat="server" Text="Close" CssClass="myButton" Style="display: none;" /></td>
                                                </tr>

                                            </table>

                                        </div>
                                    </div>
                                </asp:Panel>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="btnclose" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="paneldetail">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button1" runat="server" Style="display: none;" />

    <script type="text/javascript">
        var approvaltypemaker = '<%=approvaltypemaker %>';
        var approvaltypechecker = '<%=approvaltypechecker %>';
        var approvaltypeapproval = '<%=approvaltypeapproval %>';
        $(document).ready(function () {
            bindcategory();
            $('#<%=ddlsubcategorytype.ClientID%>').append($("<option></option>").val("0").html("Select"));
                $('#<%=ddlitemType.ClientID%>').append($("<option></option>").val("0").html("Select"));
                bindManufacture();
                bindunit();
                bindmachine();
                if (approvaltypemaker == "1") {
                    $('#makerdiv').show();
                }
                else {
                    $('#makerdiv').show();
                }
            });
            function bindcategory() {
                $('#<%=ddlcategorytype.ClientID%> option').remove();
                serverCall('Services/StoreCommonServices.asmx/bindcategory', {}, function (response) {
                    var $ddlcategorytype = $('#<%=ddlcategorytype.ClientID%>');
                    $ddlcategorytype.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name' });
                });
                }
        function bindsubcategory() {
            $('#<%=ddlsubcategorytype.ClientID%> option').remove();
            serverCall('Services/StoreCommonServices.asmx/bindsubcategory', { categoryid: $('#<%=ddlcategorytype.ClientID%>').val() }, function (response) {
                var $ddlsubcategorytype = $('#<%=ddlsubcategorytype.ClientID%>');
                $ddlsubcategorytype.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name' });
            });

        }
        function binditemcategory() {
            $('#<%=ddlitemType.ClientID%> option').remove();
            serverCall('Services/StoreCommonServices.asmx/binditemtype', { subcategoryid: $('#<%=ddlsubcategorytype.ClientID%>').val() }, function (response) {
                var $ddlitemType = $('#<%=ddlitemType.ClientID%>');
                $ddlitemType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name' });
            });

        }
            function bindManufacture() {
                var ddlManufacturingCompany = $('[id$=ContentPlaceHolder1_ddlmanu]');
                ddlManufacturingCompany.empty();
                serverCall('Services/StoreCommonServices.asmx/bindManufacture', {}, function (response) {
                    ddlManufacturingCompany.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME' });
                });
            }

            function bindunit() {
                var ddlPurchaseUnit = $('[id$=ContentPlaceHolder1_ddlpunit]');
                var ddlConsumptionUnit = $('[id$=ContentPlaceHolder1_ddlcounit]');
                ddlPurchaseUnit.empty();
                ddlConsumptionUnit.empty();
                serverCall('Services/StoreCommonServices.asmx/bindunit', {}, function (response) {
                    ddlPurchaseUnit.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME' });
                    ddlConsumptionUnit.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME' });
                });
            }
            function bindmachine() {
                var ddlMachineName = $('[id$=ContentPlaceHolder1_ddlmachine]');
                ddlMachineName.empty();
                serverCall('Services/StoreCommonServices.asmx/bindmachine', {}, function (response) {
                    ddlMachineName.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME' });
                });
            }



            function openmypopup(href) {
                var width = '1200px';
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
            }
            
           
            function addManufacture() {

                if ($('#<%=ddlmanu.ClientID%>').val() == "0") {
                    toast("Error", "Please Select  Manufacture", "");
                    $('#<%=ddlmanu.ClientID%>').focus();
                    return;
                }
                if ($('#<%=ddlpunit.ClientID%>').val() == "0") {
                    toast("Error", "Please Select  Purchased Unit", "");
                    $('#<%=ddlpunit.ClientID%>').focus();
                    return;
                }
                if ($('#<%=ddlcounit.ClientID%>').val() == "0") {
                    toast("Error", "Please Select  Consumption Unit", "");
                    $('#<%=ddlcounit.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtpacksize.ClientID%>').val() == "") {
                    toast("Error", "Please Enter Pack Size", "");
                    $('#<%=txtpacksize.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtconverter.ClientID%>').val() == "") {
                    toast("Error", "Please Enter Converter", "");
                    $('#<%=txtconverter.ClientID%>').focus();
                    return;
                }
                var id = $('#<%=ddlmanu.ClientID%>').val() + "_" + $('#<%=txtcatalogno.ClientID%>').val() + "_" + $('#<%=ddlmachine.ClientID%>').val() + "_" + $('#<%=ddlpunit.ClientID%>').val() + "_" + $('#<%=txtpacksize.ClientID%>').val() + "_" + $('#<%=ddlcounit.ClientID%>').val();
                if ($('table#tblmanufacture').find('#' + id).length > 0) {
                    toast("Error", "Data Already Added", "");
                    return;
                }

                var macname = $('#<%=ddlmachine.ClientID%>').val() == "1" ? '' : $('#<%=ddlmachine.ClientID%> option:selected').text();


                var $mydata = [];
                $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push(id); $mydata.push("'>");
                $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/><input type="checkbox" id="ChkActivate" checked="checked" style="display:none;"/></td>');
                $mydata.push('<td  align="left" id="tdmanuname">'); $mydata.push($('#<%=ddlmanu.ClientID%> option:selected').text()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdcatlog">'); $mydata.push($('#<%=txtcatalogno.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdmachinename">'); $mydata.push(macname); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdpunitname">'); $mydata.push($('#<%=ddlpunit.ClientID%> option:selected').text()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdconverter">'); $mydata.push($('#<%=txtconverter.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdpacksize">'); $mydata.push($('#<%=txtpacksize.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdcounitname">'); $mydata.push($('#<%=ddlcounit.ClientID%> option:selected').text()); $mydata.push('</td>');
                $mydata.push('<td  align="left" id="tdIssueMultiplier">'); $mydata.push($('#<%=txtissuemulti.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  id="tdmanu"    style="display:none;">'); $mydata.push($('#<%=ddlmanu.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  id="tdmachine" style="display:none;">'); $mydata.push($('#<%=ddlmachine.ClientID%>').val()); $mydata.push('</td>');
                $mydata.push('<td  id="tdpunit"   style="display:none;">'); $mydata.push($('#<%=ddlpunit.ClientID%>').val().split('#')[0]); $mydata.push('</td>');
                $mydata.push('<td  id="tdcunit"   style="display:none;">'); $mydata.push($('#<%=ddlcounit.ClientID%>').val().split('#')[0]); $mydata.push('</td>');
                $mydata.push('<td  id="tdMajorUnitInDecimal"   style="display:none;">'); $mydata.push($('#<%=ddlpunit.ClientID%>').val().split('#')[1]); $mydata.push('</td>');
                $mydata.push('<td  id="tdMinorUnitInDecimal"   style="display:none;">'); $mydata.push($('#<%=ddlcounit.ClientID%>').val().split('#')[1]); $mydata.push('</td>');
                $mydata.push('<td  id="tditemidmain"   style="display:none;">0</td>');
                $mydata.push('</tr>');
                $mydata = $mydata.join("");
                $('#tblmanufacture').append($mydata);




                clearmanudata();
            }
            function deleterow(itemid) {
                var table = document.getElementById('tblmanufacture');
                table.deleteRow(itemid.parentNode.parentNode.rowIndex);
            }

    </script>

    <script type="text/javascript">
        function validation() {
            if ($('#<%=ddlcategorytype.ClientID%> option:selected').val() == "0") {
                toast("Error", "Please Select  Category Type", "");
                $('#<%=ddlcategorytype.ClientID%>').focus();
                return false;

            }
            if ($('#<%=ddlsubcategorytype.ClientID%> option:selected').val() == "0") {
                toast("Error", "Please Select  SubCategory Type", "");
                $('#<%=ddlsubcategorytype.ClientID%>').focus();
                return false;


            }
            if ($('#<%=ddlitemType.ClientID%> option:selected').val() == "0") {
                toast("Error", "Please Select  Item Type", "");
                $('#<%=ddlitemType.ClientID%>').focus();
                return false;

            }
            if ($('#<%=txtitemname.ClientID%>').val().trim() == "") {
                toast("Error", "Please Select  Item Name", "");
                $('#<%=txtitemname.ClientID%>').focus();
                return false;

            }
            if ($('#<%=txthsn.ClientID%>').val() == "") {
                toast("Error", "Please Enter  HSN Code", "");
                $('#<%=txthsn.ClientID%>').focus();
                return false;

            }
            if ($('#<%=txtamount.ClientID%>').val() == "") {
                toast("Error", "Please Select  GST Tax %", "");
                $('#<%=txtamount.ClientID%>').focus();
                return false;

            }
            if ($('#<%=ddlbarcodeoption.ClientID%>').val() == "0") {
                toast("Error", "Please Select Barcode Option", "");
                $('#<%=ddlbarcodeoption.ClientID%>').focus();
                return false;

            }
            var count = $('#tblmanufacture tr').length;
            if (count == 0 || count == 1) {
                toast("Error", "Please Add Manufacture", "");
                $('#imgAddManufacture').focus();
                return false;
            }

            return true;
        }
        function StoreItemMaster() {
            var dataIm = new Array();
            $('#tblmanufacture tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "trmanuheader") {
                    var objitemMaster = new Object();
                    objitemMaster.ItemID = $(this).closest("tr").find("#tditemidmain").html();;
                    objitemMaster.CategoryTypeID = $('#<%=ddlcategorytype.ClientID%>').val();
                    objitemMaster.SubCategoryTypeID = $('#<%=ddlsubcategorytype.ClientID%>').val();
                    objitemMaster.SubCategoryID = $('#<%=ddlitemType.ClientID%>').val();
                    objitemMaster.TypeName = $('#<%=txtitemname.ClientID%>').val();
                    objitemMaster.Description = $('#<%=txtDesc.ClientID%>').val();
                    objitemMaster.Specification = $('#<%=txtspec.ClientID%>').val();
                    objitemMaster.MakeandModelNo = $('#<%=txtmakeandmodel.ClientID%>').val();
                    objitemMaster.ClientItemCode = $('#<%=txtItemCode.ClientID%>').val();
                    objitemMaster.HsnCode = $('#<%=txthsn.ClientID%>').val();
                    if ($('#<%=txtExpdatecutoff.ClientID%>').val() == "") {
                        objitemMaster.Expdatecutoff = "0";
                    }
                    else {
                        objitemMaster.Expdatecutoff = $('#<%=txtExpdatecutoff.ClientID%>').val();
                    }
                    objitemMaster.GSTNTax = $('#<%=txtamount.ClientID%>').val();
                    objitemMaster.TemperatureStock = $('#<%=txttemp.ClientID%>').val();

                    if ($(this).closest("tr").find("#ChkActivate").prop('checked') == true) {
                        objitemMaster.IsActive = "1";
                    }
                    else {
                        objitemMaster.IsActive = "0";
                    }
                    if ($('#<%=chexpirable.ClientID%>').prop('checked') == true) {
                        objitemMaster.IsExpirable = "1";
                    }
                    else {
                        objitemMaster.IsExpirable = "0";
                    }
                    objitemMaster.ManufactureID = $(this).closest("tr").find("#tdmanu").html();
                    objitemMaster.ManufactureName = $(this).closest("tr").find("#tdmanuname").html();
                    objitemMaster.CatalogNo = $(this).closest("tr").find("#tdcatlog").html();
                    if ($(this).closest("tr").find("#tdmachine").html() == "0") {
                        objitemMaster.MachinId = "0";
                        objitemMaster.MachinName = "";
                    }
                    else {
                        objitemMaster.MachinId = $(this).closest("tr").find("#tdmachine").html();
                        objitemMaster.MachinName = $(this).closest("tr").find("#tdmachinename").html();
                    }

                    objitemMaster.MajorUnitId = $(this).closest("tr").find("#tdpunit").html();
                    objitemMaster.MajorUnitName = $(this).closest("tr").find("#tdpunitname").html();
                    objitemMaster.Converter = $(this).closest("tr").find("#tdconverter").html();
                    objitemMaster.PackSize = $(this).closest("tr").find("#tdpacksize").html();
                    objitemMaster.MinorUnitId = $(this).closest("tr").find("#tdcunit").html();
                    objitemMaster.MinorUnitName = $(this).closest("tr").find("#tdcounitname").html();
                    objitemMaster.MajorUnitInDecimal = $(this).closest("tr").find("#tdMajorUnitInDecimal").html();
                    objitemMaster.MinorUnitInDecimal = $(this).closest("tr").find("#tdMinorUnitInDecimal").html();
                    if ($('#itemid').html() == "") {
                        objitemMaster.ItemIDGroup = "0";
                    }
                    else {
                        objitemMaster.ItemIDGroup = $('#itemid').html();
                    }
                    objitemMaster.IssueMultiplier = $(this).closest("tr").find("#tdIssueMultiplier").html() == "" ? 0 : parseInt($(this).closest("tr").find("#tdIssueMultiplier").html());
                    objitemMaster.BarcodeOption = $('#<%=ddlbarcodeoption.ClientID%>').val();
                    objitemMaster.BarcodeGenrationOption = $('#<%=ddlbarcodegertationoption.ClientID%>').val();
                    if ($('#<%=chissuefifo.ClientID%>').prop('checked') == true) {
                        objitemMaster.IssueInFIFO = "1";
                    }
                    else {
                        objitemMaster.IssueInFIFO = "0";
                    }
                    dataIm.push(objitemMaster);
                }
            });
            return dataIm;
        }
        function savenewitem() {
            if (validation() == false) {
                return;
            }
            var itemdata = StoreItemMaster();
            var consumedata = getconsumedata();
            $("#btnsave").attr('disabled', true).val("Submiting...");
            serverCall('StoreItemMaster.aspx/SaveItemMaster', { StoreItemMaster: itemdata, consumedata: consumedata }, function (response) {
               
                if (response.split('#')[0] == "1") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    clearForm();
                    toast("Success", "Record Saved Successfully", "");
                    searchitem();
                }
                else {
                    toast("Error", response.split('#')[1], "");
                    $('#btnsave').attr('disabled', false).val("Save");
                }
            });
        }

        function getconsumedata() {
            var tempData1 = [];
            $('#detailtable tr').each(function () {
                if ($(this).attr("id") != "header") {
                    var conmaster = [];
                    conmaster[0] = $(this).find('#itid').html();
                    conmaster[1] = $(this).find('#itname').html();
                    conmaster[2] = $(this).find('#ittype').html();
                    conmaster[3] = $(this).find('#invqty').val();
                    conmaster[3] = $(this).find('#invqty').val();
                    conmaster[5] = $(this).find('#macid').html();
                    conmaster[6] = $(this).find('#macname').html();
                    tempData1.push(conmaster);
                }
            });
            return tempData1;
        }
        function clearForm() {
            $('#duplicateitem').html('');
            $('#btnsave').show();
            $('#btnupdate').hide();
            $('#itemid').html('');
            $('#<%=chexpirable.ClientID%>').prop('checked', false);
            $('#<%=chissuefifo.ClientID%>').prop('checked', false);
            $('#<%=ddlbarcodeoption.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddlbarcodegertationoption.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddlcategorytype.ClientID%>').prop('selectedIndex', 0);
            $('#<%=ddlbarcodeoption.ClientID%>').prop("disabled", false);
            $('#<%=chexpirable.ClientID%>').prop("disabled", false);
            bindsubcategory();
            $('#<%=ddlsubcategorytype.ClientID%>').prop('selectedIndex', 0);
            binditemcategory();
            $('#<%=ddlitemType.ClientID%>,#<%=ddlinv.ClientID%>,#<%=ddlcentermapping.ClientID%>,#<%=ddllabmachine.ClientID%>').prop('selectedIndex', 0);
            $('#<%=txtitemname.ClientID%>,#<%=txtDesc.ClientID%>,#<%=txtspec.ClientID%>,#<%=txtmakeandmodel.ClientID%>,#<%=txtItemCode.ClientID%>,#<%=txtamount.ClientID%>,#<%=txthsn.ClientID%>,#<%=txtExpdatecutoff.ClientID%>,#<%=txttemp.ClientID%>').val("");
            clearmanudata();
            $('#tblmanufacture tr').slice(1).remove();
            $('#detailtable tr').slice(1).remove();

            $('#<%=chissuefifo.ClientID%>').prop('checked', true);
            checkbarcodeoption();
        }
        function clearmanudata() {
            $('#<%=txtcatalogno.ClientID%>').val("");
            $('#<%=ddlmachine.ClientID%>,#<%=ddlmanu.ClientID%>,#<%=ddlpunit.ClientID%>,#<%=ddlcounit.ClientID%>').prop('selectedIndex', 0);
            $('#<%=txtpacksize.ClientID%>,#<%=txtconverter.ClientID%>').val("1");
            $('#<%=txtissuemulti.ClientID%>').val("0");
        }
    </script>
    <script type="text/javascript">
        function searchitem() {
           // clearForm();
            $('#tblitemlist tr').slice(1).remove();
           
            serverCall('StoreItemMaster.aspx/SearchData', { searchtype: $('#<%=ddlsearchtype.ClientID%>').val(), searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(), Category: $('#<%=ddlsearchtypedropdown.ClientID%>').val(), CategoryType: $('#<%=ddlcategorysearch.ClientID%>').val(), NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val(), AppType: $('#<%=ddlapptype.ClientID%>').val() }, function (response) {
                   
                        var $ReqData = JSON.parse(response);
                        if ($ReqData.length == 0) {
                            toast("Error", "No Item Found..!", "");
                        }
                        else {
                            for (var i = 0; i <= $ReqData.length - 1; i++) {
                                var $mydata = [];
                                $mydata.push("<tr style='background-color:bisque;'>");
                                $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/view.GIF" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetailinner(this)" /></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><input type="button" value="Select" style="cursor:pointer;" onclick="showdetailtoupdate(this)" /></td>');
                                $mydata.push('<td class="GridViewLabItemStyle"  id="tdcatename" >'); $mydata.push($ReqData[i].CategoryTypeName); $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle" id="tdsubcatname">'); $mydata.push($ReqData[i].SubCategoryTypeName); $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle" id="tditemgroupname">'); $mydata.push($ReqData[i].itemgroupName); $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle" id="tditemname">'); $mydata.push($ReqData[i].ItemName); $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle" id="tdhsncode">'); $mydata.push($ReqData[i].hsncode);
                                $mydata.push('<td class="GridViewLabItemStyle" id="tdapolloitemcode">'); $mydata.push($ReqData[i].apolloitemcode); $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle" id="tdgsttax">'); $mydata.push($ReqData[i].GSTNTax); $mydata.push('</td>');
                                $mydata.push('<td class="GridViewLabItemStyle" >'); $mydata.push($ReqData[i].Expirable); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdcatid">'); $mydata.push($ReqData[i].CategoryTypeID); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdsubcatid">'); $mydata.push($ReqData[i].SubCategoryTypeID); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tditemgroupid">'); $mydata.push($ReqData[i].SubCategoryID); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tditemid">'); $mydata.push($ReqData[i].itemidgroup); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tddesc">'); $mydata.push($ReqData[i].description); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdspeci">'); $mydata.push($ReqData[i].specification); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdmakeandmodel">'); $mydata.push($ReqData[i].MakeandModelNo); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdtemp">'); $mydata.push($ReqData[i].TemperatureStock); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdday">'); $mydata.push($ReqData[i].Expdatecutoff); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdactive">'); $mydata.push($ReqData[i].isactive); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdtdIsExpirable">'); $mydata.push($ReqData[i].IsExpirable); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdBarcodeOption">'); $mydata.push($ReqData[i].BarcodeOption); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdBarcodeGenrationOption">'); $mydata.push($ReqData[i].BarcodeGenrationOption); $mydata.push('</td>');
                                $mydata.push('<td style="display:none;" id="tdIssueInFIFO">'); $mydata.push($ReqData[i].IssueInFIFO); $mydata.push('</td>');
                                $mydata.push("</tr>");
                                $mydata = $mydata.join("");
                                jQuery('#tblitemlist').append($mydata);
                            }
                        }
                    });
                
            }

            function checkme(ctrl) {
                var id = $(ctrl).closest("tr").find('#tditemid').html();
                serverCall('StoreItemMaster.aspx/SetStatus', { itemId: id, Status: 1 }, function (response) {
                    toast("Success", "Item checked Sucessfully...!", "");
                    searchitem();
                });
            }
function loaddata(a) {
 $('#<%=ddlsubcategorytype.ClientID%>').val(a);
binditemcategory();
}
function loaddata1(a) {
 $('#<%=ddlitemType.ClientID%>').val(a);
}
            function searchitemexcel() {
                serverCall('StoreItemMaster.aspx/SearchDataExcel', { searchtype: $('#<%=ddlsearchtype.ClientID%>').val(), searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(), Category: $('#<%=ddlsearchtypedropdown.ClientID%>').val(), CategoryType: $('#<%=ddlcategorysearch.ClientID%>').val() }, function (response) {
                var save = response;
                if (save == "false") {
                    toast("Error", "No Item Found", "");
                }
                else {
                    window.open('../common/ExportToExcel.aspx');
                }
            });
        }
        function showdetail(ctrl) {
            var itemid = $(ctrl).closest("tr").find('#tditemid').html();
            openmypopup('ShowItemDetail.aspx?itemid=' + itemid);
        }
		function openmacpopup() {
                window.open("../Master/MachineMaster.aspx", '_blank');
                return false;
            }
			
			
        function showdetailtoupdate(ctrl) {
          
           // clearForm();
            $('#btnsave').hide();
            $('#btnupdate').show();
            $('#itemid').html($(ctrl).closest("tr").find('#tditemid').html());
            $('#<%=ddlcategorytype.ClientID%>').val($(ctrl).closest("tr").find('#tdcatid').html());
            bindsubcategory();
            setTimeout(function () { loaddata($(ctrl).closest("tr").find('#tdsubcatid').html()) }, 1000);
           // $('#<%=ddlsubcategorytype.ClientID%>').val($(ctrl).closest("tr").find('#tdsubcatid').html());
            
            setTimeout(function () { loaddata1($(ctrl).closest("tr").find('#tditemgroupid').html()) }, 2000);
           // $('#<%=ddlitemType.ClientID%>').val($(ctrl).closest("tr").find('#tditemgroupid').html());
            $('#<%=txtitemname.ClientID%>').val($(ctrl).closest("tr").find('#tditemname').html());
            $('#<%=txtDesc.ClientID%>').val($(ctrl).closest("tr").find('#tddesc').html());
            $('#<%=txtspec.ClientID%>').val($(ctrl).closest("tr").find('#tdspeci').html());
            $('#<%=txtmakeandmodel.ClientID%>').val($(ctrl).closest("tr").find('#tdmakeandmodel').html());
            $('#<%=txthsn.ClientID%>').val($(ctrl).closest("tr").find('#tdhsncode').html());
            $('#<%=txtItemCode.ClientID%>').val($(ctrl).closest("tr").find('#tdapolloitemcode').html());
            $('#<%=txtamount.ClientID%>').val($(ctrl).closest("tr").find('#tdgsttax').html());
            $('#<%=txttemp.ClientID%>').val($(ctrl).closest("tr").find('#tdtemp').html());
            if ($(ctrl).closest("tr").find('#tdIssueInFIFO').html() == "1") {
                $('#<%=chissuefifo.ClientID%>').prop('checked', true);
            }
            else {
                $('#<%=chissuefifo.ClientID%>').prop('checked', false);
            }
            if ($(ctrl).closest("tr").find('#tdtdIsExpirable').html() == "1") {
                $('#<%=chexpirable.ClientID%>').prop('checked', true);
            }
            else {
                $('#<%=chexpirable.ClientID%>').prop('checked', false);
            }
            checkbarcodeoption();
            $('#<%=ddlbarcodeoption.ClientID%>').val($(ctrl).closest("tr").find('#tdBarcodeOption').html());
            $('#<%=txtExpdatecutoff.ClientID%>').val($(ctrl).closest("tr").find('#tdday').html());
            $('#<%=ddlbarcodegertationoption.ClientID%>').val($(ctrl).closest("tr").find('#tdBarcodeGenrationOption').html());
            $('#tblmanufacture tr').slice(1).remove();        
           serverCall('StoreItemMaster.aspx/BindSavedManufacture', { itemid: $('#itemid').html() }, function (response) {              
                    var $ReqData = JSON.parse(response);
                    if ($ReqData.length == 0) {
                        toast("Error", "No Item Found", "");
                    }
                    else {
                        for (var i = 0; i <= $ReqData.length - 1; i++) {
                            var id = $ReqData[i].ManufactureID + "_" + $ReqData[i].MajorUnitId + "_" + $ReqData[i].MinorUnitId + "_" + $ReqData[i].MultipiyFactor;
                            var $mydata = [];
                            $mydata.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id='); $mydata.push(id); $mydata.push("'>");
                            $mydata.push('<td>');
                            if ($ReqData[i].isactive == "1") {
                                $mydata.push('<input type="checkbox" id="ChkActivate" checked="checked"/>');
                            }
                            else {
                                $mydata.push('<input type="checkbox" id="ChkActivate" />');
                            }
                            $mydata.push('</td>');
                            $mydata.push('<td  align="left" id="tdmanuname">'); $mydata.push($ReqData[i].ManufactureName); $mydata.push('</td>');
                            $mydata.push('<td  align="left" id="tdcatlog">'); $mydata.push($ReqData[i].CatalogNo); $mydata.push('</td>');
                            $mydata.push('<td  align="left" id="tdmachinename">'); $mydata.push($ReqData[i].MachineName); $mydata.push('</td>');
                            $mydata.push('<td  align="left" id="tdpunitname">'); $mydata.push($ReqData[i].MajorUnitName); $mydata.push('</td>');
                            $mydata.push('<td  align="left" id="tdconverter">'); $mydata.push(precise_round($ReqData[i].converter, 5)); $mydata.push('</td>');
                            $mydata.push('<td  align="left" id="tdpacksize">'); $mydata.push($ReqData[i].MultipiyFactor); $mydata.push('</td>');
                            $mydata.push('<td  align="left" id="tdcounitname">'); $mydata.push($ReqData[i].MinorUnitName); $mydata.push('</td>');
                            $mydata.push('<td  align="left" id="tdIssueMultiplier">'); $mydata.push($ReqData[i].IssueMultiplier); $mydata.push('</td>');
                            $mydata.push('<td  id="tdmanu"    style="display:none;">'); $mydata.push($ReqData[i].ManufactureID); $mydata.push('</td>');
                            $mydata.push('<td  id="tdmachine" style="display:none;">'); $mydata.push($ReqData[i].MachineID); $mydata.push('</td>');
                            $mydata.push('<td  id="tdpunit"   style="display:none;">'); $mydata.push($ReqData[i].MajorUnitId); $mydata.push('</td>');
                            $mydata.push('<td  id="tdcunit"   style="display:none;">'); $mydata.push($ReqData[i].MinorUnitId); $mydata.push('</td>');
                            $mydata.push('<td  id="tditemidmain"   style="display:none;">'); $mydata.push($ReqData[i].ItemId); $mydata.push('</td>');
                            $mydata.push('<td  id="tdMajorUnitInDecimal"   style="display:none;">'); $mydata.push($ReqData[i].MajorUnitInDecimal); $mydata.push('</td>');
                            $mydata.push('<td  id="tdMinorUnitInDecimal"   style="display:none;">'); $mydata.push($ReqData[i].MinorUnitInDecimal); $mydata.push('</td>');
                            $mydata.push("</tr>");
                            $mydata = $mydata.join("");
                            jQuery('#tblmanufacture').append($mydata);
                        }
                    }
                });
            
            
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
    </script>
    <script type="text/javascript">
        function updateitem() {
            if (validation() == false) {
                return;
            }
            var itemdata = StoreItemMaster();
            var consumedata = getconsumedata();
            $("#btnupdate").attr('disabled', true).val("Updating...");
            serverCall('StoreItemMaster.aspx/UpdateItemMaster', { itemdata: itemdata, consumedata: consumedata }, function (response) {
                var save = response;
                if (save.split('#')[0] == "1") {
                    $('#btnupdate').attr('disabled', false).val("Update");
                    clearForm();
                    toast("Success", "Item Updated...!", "");
                    searchitem();
                }
                else {
                    toast("Error", $responseData.response, "");
                    $('#btnupdate').attr('disabled', false).val("Update");
                }
            });
        }
    </script>
    <script type="text/javascript">
        function openautoconsume() {
            bindtestandparameter();
            $find('<%=ModalPopupExtender1.ClientID%>').show();
            }
            function bindtestandparameter() {
                $('#<%=ddlinv.ClientID%> option').remove();
                serverCall('Services/StoreCommonServices.asmx/bindtestandparameter', {}, function (response) {
                    var $ddlinv = $('#<%=ddlinv.ClientID%>');
                    $ddlinv.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'invid', textField: 'typename' });
                });
                }
                function additemingrid() {
                    if ($('#<%=ddlinv.ClientID%> option:selected').val() == "0") {
                toast("Error", "Please Select Test/Parameter..!", "");
                $('#<%=ddlinv.ClientID%> option:selected').focus();
                return;
            }
            var a = $('#detailtable tr').length - 1;

            var $mydata = [];
            $mydata.push('<tr id='); $mydata.push($('#<%=ddlinv.ClientID%> option:selected').val()); $mydata.push('style="height:25px;background-color:lightgoldenrodyellow" >');
            $mydata.push('<td>'); $mydata.push(parseFloat(a + 1)); $mydata.push('</td>');
            $mydata.push('<td id="itname" align="left">'); $mydata.push($('#<%=ddlinv.ClientID%> option:selected').html().split('#')[0]); $mydata.push('</td>');
            $mydata.push('<td id="ittype" align="left">'); $mydata.push($('#<%=ddlinv.ClientID%> option:selected').html().split('#')[1]); $mydata.push('</td>');
            $mydata.push('<td id="macname" align="left">'); $mydata.push($('#<%=ddllabmachine.ClientID%> option:selected').html()); $mydata.push('</td>');
            $mydata.push('<td><input type="text" id="invqty" style="width:90%;text-align:right;"  onkeyup="numonly(this);"/></td>');
            $mydata.push('<td id="itunit" align="left">Per Test</td>');
            $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterowauto(this)"/></td>');
            $mydata.push('<td id="itid" style="display:none;">'); $mydata.push($('#<%=ddlinv.ClientID%> option:selected').val()); $mydata.push('</td>');
            $mydata.push('<td id="macid" style="display:none;">'); $mydata.push($('#<%=ddllabmachine.ClientID%> option:selected').val()); $mydata.push('</td>');
            $mydata.push('</tr>');;
            $mydata = $mydata.join("");
            jQuery('#detailtable').append($mydata);
        }

        function deleterowauto(itemid) {
            var table = document.getElementById('detailtable');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);
        }

        function numonly(ctr) {
            ctr.value = ctr.value.replace(/[^0-9\.]/g, '');
        }
        function saveconsumedata() {
            var a = $('#detailtable tr').length;
            if (a == "1") {
                jAlert("Please Add Test/Parameter To Save");
                return;
            }
            var sn = 0;
            $('#detailtable tr').each(function () {
                var rate = $(this).find('#invqty').val();
                if (rate == "") {
                    sn = 1;
                    $(this).find('#invqty').focus();
                    return false;
                }
            });
            if (sn == 1) {
                toast("Error", "Please enter the Qty..!", "");
                return false;
            }
            $find('<%=ModalPopupExtender1.ClientID%>').hide();
        }
        function closepopup() {
            if ($('#btnsave').css('display') == 'none') {
                $find('<%=ModalPopupExtender1.ClientID%>').hide();
                document.getElementById('<%=ddlinv.ClientID %>').selectedIndex = 0;
                document.getElementById('<%=ddllabmachine.ClientID %>').selectedIndex = 0;
            }
            else {
                $find('<%=ModalPopupExtender1.ClientID%>').hide();
                $("#detailtable").find("tr:gt(0)").remove();
                document.getElementById('<%=ddlinv.ClientID %>').selectedIndex = 0;
                document.getElementById('<%=ddllabmachine.ClientID %>').selectedIndex = 0;
            }
        }
        function getmyconsume() {
            $("#detailtable").find("tr:gt(0)").remove();
            document.getElementById('<%=ddlinv.ClientID %>').selectedIndex = 0;
                document.getElementById('<%=ddllabmachine.ClientID %>').selectedIndex = 0;
                var _temp = [];
                _temp.push(serverCall('StoreItemMaster.aspx/getconsumeitemlist', { itemid: $('#itemid').html() }, function (response) {
                    jQuery.when.apply(null, _temp).done(function () {
                        var $ReqData = JSON.parse(response);
                        if ($ReqData.length == 0) {
                            $('#st').hide();
                        }
                        else {
                            for (var i = 0; i <= $ReqData.length - 1; i++) {

                                var $mydata = [];
                                $mydata.push('<tr id='); $mydata.push($ReqData[a].inv_parameter_id); $mydata.push(' style="height:25px;background-color:lightgoldenrodyellow" >');
                                $mydata.push('<td>'); $mydata.push(parseFloat(a + 1)); $mydata.push('</td>');
                                $mydata.push('<td id="itname" align="left">'); $mydata.push($ReqData[a].inv_parameter_name); $mydata.push('</td>');
                                $mydata.push('<td id="ittype" align="left">'); $mydata.push($ReqData[a].inv_parameter_type); $mydata.push('</td>');
                                $mydata.push('<td id="macname" align="left">'); $mydata.push($ReqData[a].labmachinename); $mydata.push('</td>');
                                $mydata.push('<td><input type="text" id="invqty" style="width:90%;text-align:right;"  onkeyup="numonly(this);" value="'); $mydata.push($ReqData[a].quantity); $mydata.push('"/></td>');;
                                $mydata.push('<td id="itunit" align="left">'); $mydata.push($ReqData[a].unit); $mydata.push(' Per Test</td>');
                                $mydata.push('<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterowauto(this)"/></td>');
                                $mydata.push('<td id="itid" style="display:none;">'); $mydata.push($ReqData[a].inv_parameter_id); $mydata.push('</td>');
                                $mydata.push('<td id="macid" style="display:none;">'); $mydata.push($ReqData[a].labmachineid); $mydata.push('</td>');
                                $mydata.push('</tr>');
                                $mydata = $mydata.join("");
                                jQuery('#detailtable').append($mydata);
                                $('#st').show();
                            }
                        }

                    });
                }));
            }
            function setcontrolforsearch() {
                jQuery('#<%=ddlcategorysearch.ClientID%> option').remove();
                serverCall('StoreItemMaster.aspx/bindalldatatosearch', { type: $('#<%=ddlsearchtypedropdown.ClientID%>').val() }, function (response) {
                    var $ddlcat = $('#<%=ddlcategorysearch.ClientID%>');
                    $ddlcat.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME' });
                });
            }
            function showdetailinner(ctrl) {
                var groupid = $(ctrl).closest('tr').find("#tditemid").html();
                openmypopup("OpenItemApproval.aspx?itemgroupid=" + groupid);
            }
            function checkbarcodeoption() {
                if ($('#<%=chissuefifo.ClientID%>').prop('checked') == true) {
                $('#<%=ddlbarcodeoption.ClientID%>').val('1');
                $('#<%=ddlbarcodegertationoption.ClientID%>').prop('selectedIndex', 0);
                $('#<%=ddlbarcodeoption.ClientID%>').prop("disabled", true);
                $('#<%=chexpirable.ClientID%>').prop("disabled", true);
                $('#<%=chexpirable.ClientID%>').prop('checked', true);
                showexoption();
            }
            else {
                $('#<%=chexpirable.ClientID%>').prop('checked', false);
                showexoption();
                $('#<%=ddlbarcodeoption.ClientID%>').prop('selectedIndex', 0);
                $('#<%=ddlbarcodegertationoption.ClientID%>').prop('selectedIndex', 0);
                $('#<%=ddlbarcodeoption.ClientID%>').prop("disabled", false);
                $('#<%=chexpirable.ClientID%>').prop("disabled", false);
            }
        }
        function showexoption() {
            if ($('#<%=chexpirable.ClientID%>').prop('checked') == true) {
                $('#<%=txtExpdatecutoff.ClientID%>').prop("disabled", false);
            }
            else {
                $('#<%=txtExpdatecutoff.ClientID%>').prop("disabled", true);
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
            $("#txtitemname")
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

                          var _temp = [];
                          _temp.push(serverCall('StoreItemMaster.aspx/bindolditemname', { itemname: extractLast(request.term) }, function (responsenew) {
                              jQuery.when.apply(null, _temp).done(function () {
                                  response($.map(jQuery.parseJSON(responsenew), function (item) {
                                      return {
                                          label: item.itemnamegroup,
                                          value: item.itemidgroup
                                      }
                                  }))
                              });
                          },'',false));
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
</asp:Content>

