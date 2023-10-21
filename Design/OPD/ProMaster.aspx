<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProMaster.aspx.cs" Inherits="Design_OPD_ProMaster" MasterPageFile="~/Design/DefaultHome.master" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript" language="javascript">

        function enableTextBox() {
            if (document.getElementById('<%=cbcredit.ClientID %>').checked == true) {
                document.getElementById('<%=txtcredit.ClientID %>').style.display = '';
            }
            else {
                document.getElementById('<%=txtcredit.ClientID %>').style.display = "none";
                alert("tick the iscreditlimit");
            }

        }

    </script>


    <script type="text/javascript">


        function LABEL1_onclick() {

        }


        function openPopupRef(btnName) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.  

            buttonName = document.getElementById(btnName).value;
            window.open('../OPD/pro_master.aspx?BTN=' + buttonName, null, 'left=150, top=100, height=520, width=868, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            //event.keyCode = 0
            return false;
        }
    </script>


    <div id="Pbody_box_inventory" style="text-align: center;">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <b></b><strong>PRO Master<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>





    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
            Search PRO
        </div>
        <div class="content">

            <label class="labelForTag">
                PRO Name :</label>
            <asp:TextBox ID="txtProName1" runat="server" Width="350px"></asp:TextBox>

            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search" CssClass="ItDoseButton" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   
    <input id="btnPro" class="ItDoseButton" onclick="openPopupRef('btnPro');" style="width: 43px"
        type="button" value="New" />

        </div>


        <div class="POuter_Box_Inventory" style="width: 966px">

            <asp:GridView ID="grdInv" runat="server" AutoGenerateColumns="False" AllowPaging="True"
                CssClass="GridViewStyle"
                PageSize="15" OnSelectedIndexChanged="grdInv_SelectedIndexChanged" OnPageIndexChanging="grdInv_PageIndexChanging">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>

                    <asp:TemplateField HeaderText="#">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="PRO Name">
                        <ItemTemplate>
                            <%#Eval("PROName")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="300px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Phone1">
                        <ItemTemplate>
                            <%#Eval("Phone1")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Address">
                        <ItemTemplate>
                            <%#Eval("Address")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="DateOfBirth" HeaderText="DOB" NullDisplayText="NO DOB">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>


                    <asp:BoundField DataField="Phone1" HeaderText="Phone">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>



                    <asp:BoundField DataField="Email" HeaderText="Email">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>



                    <asp:BoundField DataField="Mobile" HeaderText="Mobile">
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:BoundField>

                    <asp:TemplateField HeaderText="Mobile" Visible="False">
                        <ItemTemplate>
                            <%#Eval("Mobile")%>

                            <asp:Label ID="lblname" runat="server" Visible="false" Text='<%#Eval("PROName") %>'></asp:Label>
                            <asp:Label ID="lblPhone" runat="server" Visible="false" Text='<%#Eval("Phone1") %>'></asp:Label>
                              <asp:Label ID="lblusername" runat="server" Visible="false" Text='<%#Eval("Username") %>'></asp:Label>
                              <asp:Label ID="lblpassword" runat="server" Visible="false" Text='<%#Eval("Password") %>'></asp:Label>
                            <asp:Label ID="LblAddress" runat="server" Visible="false" Text='<%#Eval("Address") %>'></asp:Label>
                            <asp:Label ID="lblDateOfBirth" runat="server" Visible="false" Text='<%#Eval("DateOfBirth") %>'></asp:Label>
                            <asp:Label ID="lblmobile" runat="server" Visible="false" Text='<%#Eval("Mobile") %>'></asp:Label>
                            <asp:Label ID="lblDesignation" runat="server" Visible="false" Text='<%#Eval("Designation") %>'></asp:Label>
                            <asp:Label ID="lblPROID" runat="server" Visible="False" Text='<%#Eval("PROID") %>'>'</asp:Label>


                            <asp:Label ID="lblGender" runat="server" Visible="False" Text='<%#Eval("Gender") %>'>'</asp:Label>
                            <asp:Label ID="lblIsCreditLimit" runat="server" Visible="False" Text='<%#Eval("IsCreditLimit") %>'>'</asp:Label>
                            <asp:Label ID="lblCreditLimit" runat="server" Visible="False" Text='<%#Eval("CreditLimit") %>'>'</asp:Label>


                            <asp:Label ID="lblPhone2" runat="server" Visible="False" Text='<%#Eval("Phone2") %>'>'</asp:Label>
                            <asp:Label ID="lblPhone3" runat="server" Visible="False" Text='<%#Eval("Phone3") %>'>'</asp:Label>

                            <asp:Label ID="lblState" runat="server" Visible="False" Text='<%#Eval("State") %>'>'</asp:Label>

                            <asp:Label ID="lblTitle" runat="server" Visible="False" Text='<%#Eval("Title") %>'>'</asp:Label>


                            <asp:Label ID="lblEmail" runat="server" Visible="False" Text='<%#Eval("Email") %>'>'</asp:Label>
                            <asp:Label ID="lblIsActive" runat="server" Visible="False" Text='<%#Eval("IsActive") %>'>'</asp:Label>


                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>

                    <asp:CommandField HeaderText="Edit" SelectText="Edit" ShowSelectButton="True">


                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:CommandField>
                </Columns>
            </asp:GridView>


        </div>

    </div>
    <cc1:ModalPopupExtender ID="MpeUpdate" runat="server"
        CancelControlID="btnCancl"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate"
        PopupDragHandleControlID="dragUpdate">
    </cc1:ModalPopupExtender>


    <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;"></asp:Button>

    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;" Width="800px">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Update Detail
        </div>
       
            <table style="width: 100%">
                <tr>
                    <td align="right" style="width: 16%; height: 26px;" valign="middle" class="ItDoseLabel">Name:
                    </td>
                    <td align="left" style="width: 21%; height: 26px;" valign="middle">
                        <span class="text2"><strong><span style="color: #54a0c0"></span></strong><span style="font-size: 8pt">
                            <asp:DropDownList ID="cmbTitle" runat="server" CssClass="inputbox4" TabIndex="1"
                                ToolTip="select  gender" Width="66px">
                            </asp:DropDownList>
                            <asp:TextBox ID="txtproName" runat="server" CssClass="inputbox3" MaxLength="100"
                                TabIndex="2" Width="147px"></asp:TextBox></span></span></td>
                    <td align="right" style="width: 20%; font-size: 10pt; height: 26px; text-align: right;"
                        valign="middle">DateOfBirth:&nbsp;</td>
                    <td align="left" style="width: 34%; height: 26px;" valign="middle">
                        <span style="font-size: 8pt; color: #54a0c0; font-family: Verdana">

                            <asp:TextBox ID="txtDob" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtDob" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </span></td>

                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">
                   Username:&nbsp;
                </td>
                <td align="left" style="width: 21%" valign="middle">
                    <asp:TextBox ID="txtusername"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="9" Width="217px"></asp:TextBox></td>
                            
                            <td align="right"  style="width: 20%; text-align: right;" valign="middle">
                                Password:&nbsp;
                </td>
                <td align="left"  style="width: 34%;" valign="middle">
                    <asp:TextBox ID="txtpassword"
                            runat="server" CssClass="inputbox2" MaxLength="10" TabIndex="10" Width="217px"></asp:TextBox></td>
                            
           </tr>
                <tr>
                    <td align="right" class="ItDoseLabel" style="width: 16%; height: 34px;" valign="middle">Gender:</td>
                    <td align="left" style="width: 21%; height: 34px" valign="middle">&nbsp;<asp:DropDownList ID="ddlgender" runat="server" Width="206px" TabIndex="3">
                        <asp:ListItem Selected="True">MALE</asp:ListItem>
                        <asp:ListItem>FEMALE</asp:ListItem>
                    </asp:DropDownList></td>
                    <td align="right" style="font-size: 10pt; width: 20%; height: 34px; text-align: right"
                        valign="middle">Designation:
                    </td>
                    <td align="left" style="width: 34%; height: 34px" valign="middle">&nbsp;<asp:TextBox ID="txtdesignation" runat="server" TabIndex="4"></asp:TextBox></td>
                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">IsCreditLimit:&nbsp;
                    </td>
                    <td align="left" style="width: 21%" valign="middle">
                        <asp:CheckBox ID="cbcredit" runat="server" onclick="enableTextBox();" Checked="true" TabIndex="5" />
                    </td>

                    <td align="right" style="width: 20%; text-align: right;" valign="middle">phone1 :&nbsp;
                    </td>

                    <td align="left" style="width: 34%;" valign="middle">
                        <asp:TextBox ID="txtphone1" runat="server" CssClass="inputbox2" MaxLength="20"
                            TabIndex="6" Width="217px"></asp:TextBox></td>

                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">CreditLimit:&nbsp;
                    </td>
                    <td align="left" style="width: 21%" valign="middle">
                        <asp:TextBox ID="txtcredit"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="7" Width="217px"></asp:TextBox></td>

                    <td align="right" style="width: 20%; text-align: right;" valign="middle">phone2 :
                    </td>
                    <td align="left" style="width: 34%;" valign="middle">
                        <asp:TextBox ID="txtphn2" runat="server" CssClass="inputbox2" MaxLength="20"
                            TabIndex="8" Width="217px"></asp:TextBox></td>

                </tr>

                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">State:&nbsp;
                    </td>
                    <td align="left" style="width: 21%" valign="middle">
                        <asp:TextBox ID="txtstate"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="9" Width="217px"></asp:TextBox></td>

                    <td align="right" style="width: 20%; text-align: right;" valign="middle">Phone3:&nbsp;
                    </td>
                    <td align="left" style="width: 34%;" valign="middle">
                        <asp:TextBox ID="txtphone3"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="10" Width="217px"></asp:TextBox></td>
                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">EMail :  &nbsp;
                    </td>
                    <td align="left" valign="middle" colspan="3">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="inputbox2" MaxLength="100"
                            TabIndex="11" Width="217px"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="txtEmail" ErrorMessage="Invalid Email Format"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">Residence Address :&nbsp;
                    </td>
                    <td align="left" style="width: 21%" valign="middle">
                        <asp:TextBox ID="txtresidenceaddress"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="12" Width="217px"></asp:TextBox></td>
                    <td align="right" style="width: 20%; text-align: right;" valign="middle">Mobile :&nbsp;
                    </td>
                    <td align="left" style="width: 34%;" valign="middle">
                        <asp:TextBox ID="TxtMobileNo" runat="server" CssClass="inputbox2"
                            TabIndex="13" MaxLength="50"></asp:TextBox><div id="lblerr"></div>


                    </td>
                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">IsActive :&nbsp;
                    </td>
                    <td align="left" style="width: 21%;" valign="middle" rowspan="2">
                        <asp:CheckBox ID="cbactive" runat="server" TabIndex="14" /></td>

                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" class="ItDoseLabel" style="width: 16%;" valign="middle"></td>
                    <td align="right" style="width: 20%; text-align: right; display: none" valign="middle">Department :</td>
                    <td align="left" style="width: 34%; display: none" valign="middle">
                        <asp:DropDownList ID="cmbDept" runat="server" CssClass="inputcombobox" TabIndex="7"
                            Width="214px">
                        </asp:DropDownList></td>
                </tr>
                <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                    <td align="right" class="ItDoseLabel" style="width: 16%" valign="middle"></td>
                    <td align="left" colspan="3" style="text-align: center" valign="middle">
                        <asp:Button ID="btnUpdatePRO" runat="server" Text="Update" Width="100px" TabIndex="15" OnClick="btnUpdatePRO_Click" />
                        <asp:Button ID="btnCancl" runat="server" Text="Cancel" />
                    </td>


                </tr>
            </table>

       
    </asp:Panel>


</asp:Content>
