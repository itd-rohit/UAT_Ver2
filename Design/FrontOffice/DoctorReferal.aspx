<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DoctorReferal.aspx.cs" Inherits="Design_FrontOffice_DoctorReferal" EnableEventValidation="false" MasterPageFile="~/Design/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript">

        function openPopupRef(btnName) {
            buttonName = document.getElementById(btnName).value;
            window.open('../FrontOffice/AddReferalDoctorPopup.aspx?BTN=' + buttonName, null, 'left=250, top=100, height=510, width=842, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            return false;
        }



        function showme() {
            $find("<%=m1.ClientID%>").show();
            $('#<%=txtnewdegree.ClientID%>').css('background-color', 'white');
            $('#<%=txtnewdegree.ClientID%>').focus();
        }

        function savenewdegree() {
            if ($.trim($('#<%=txtnewdegree.ClientID%>').val()) == "") {
                $('#<%=txtnewdegree.ClientID%>').css('background-color', 'pink');
                $('#<%=txtnewdegree.ClientID%>').focus();
                return;
            }
            serverCall('AddReferalDoctorPopup.aspx/savenewdegree', { degree: $('#<%=txtnewdegree.ClientID%>').val() }, function (result) {
                    $find("<%=m1.ClientID%>").hide();
                    $("#ddlDegree").append($("<option></option>").val(result).html($('#<%=txtnewdegree.ClientID%>').val()));
                    $("#ddlDegree").val(result);

                    $('#<%=txtnewdegree.ClientID%>').val('');
                $modelUnBlockUI(function () { });
            });
    }

    function opensplpopup() {
        $find("<%=m2.ClientID%>").show();
        $('#<%=txtspecil.ClientID%>').css('background-color', 'white');
        $('#<%=txtspecil.ClientID%>').focus();
    }
        function savenewspecil() {

            if ($.trim($('#<%=txtspecil.ClientID%>').val()) == "") {
                $('#<%=txtspecil.ClientID%>').css('background-color', 'pink');
                $('#<%=txtspecil.ClientID%>').focus();
                return;
            }
            serverCall('AddReferalDoctorPopup.aspx/savenewspecil', { special:  $('#<%=txtspecil.ClientID%>').val() }, function (result) {
               $find("<%=m2.ClientID%>").hide();
               $("#ddlSpecial").append($("<option></option>").val($('#<%=txtspecil.ClientID%>').val()).html($('#<%=txtspecil.ClientID%>').val()));
               $("#ddlSpecial").val($('#<%=txtspecil.ClientID%>').val());
               $('#<%=txtspecil.ClientID%>').val('');
               $modelUnBlockUI(function () { });
            });

        }


    

    </script>


    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Doctor Referal</b><br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Doctor
            </div>
            <div class="row">
                <div class="col-md-3">
                     <asp:CheckBox ID="chkSearchIsActive" runat="server" Text="Search Only Active" Checked="true" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    Centre Name :
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCenter" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    Doctor Name :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDoctorName" runat="server"  MaxLength="100"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">Mobile No. :
                </div>
                 <div class="col-md-5">
                     <asp:TextBox ID="txtMobileNo" MaxLength="10" runat="server"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbMobileNo" runat="server" TargetControlID="txtMobileNo" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-3">Doctor Type :
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddldoctortype" runat="server" onchange="showvisit()" Enabled="false">
                    <asp:ListItem Value="Refer Doctor" Selected="True">Refer Doctor</asp:ListItem>
                    <asp:ListItem Value="PolyClinic Doctor">PolyClinic Doctor</asp:ListItem>
                        </asp:DropDownList>
                </div>
            </div>
            <div class="row" style="text-align:center">
                <asp:Button ID="btnSearch" ClientIDMode="Static" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="searchbutton" />
				<asp:Button ID="btnReport" ClientIDMode="Static" runat="server" Text="Excel Report" OnClick="btnReport_Click" CssClass="searchbutton" />
                <input id="btnDocRef" class="searchbutton" onclick="openPopupRef('btnDocRef');" type="button" value="New" />
            </div>
         

        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Doctor
            </div>

            <asp:GridView ID="grdInv" runat="server" AutoGenerateColumns="False" AllowPaging="True"
                CssClass="GridViewStyle"
                PageSize="20" Width="1180px" OnPageIndexChanging="grdInv_PageIndexChanging" OnSelectedIndexChanged="grdInv_SelectedIndexChanged" OnRowCommand="grdInv_RowCommand">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>

                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px"/>
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Doctor Name">
                        <ItemTemplate>
                            <%#Eval("Name")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                        <ItemStyle CssClass="GridViewItemStyle" Width="300px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Mobile">
                        <ItemTemplate>
                            <%#Eval("Mobile")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Degree">
                        <ItemTemplate>
                            <%#Eval("Degree")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="IsActive">
                        <ItemTemplate>
                            <%#Eval("Active")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Refer Share">
                        <ItemTemplate>
                            <%#Eval("isReferal")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Refer Master Share">
                        <ItemTemplate>
                            <%#Eval("ReferMasterShare")%>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Mobile" Visible="False">
                        <ItemTemplate>
                            <%#Eval("Mobile")%>
                            <asp:Label ID="lblinfo" runat="server" Visible="false" Text='<%# Container.DataItemIndex+1 %>'></asp:Label>
                            <asp:Label ID="lblTitle" runat="server" Visible="false" Text='<%#Eval("Title") %>'></asp:Label>
                            <asp:Label ID="lblname" runat="server" Visible="false" Text='<%#Eval("Name") %>'></asp:Label>
                            <asp:Label ID="lblPhone" runat="server" Visible="false" Text='<%#Eval("Phone1") %>'></asp:Label>
                            <asp:Label ID="LblStreet_Name" runat="server" Visible="false" Text='<%#Eval("Street_Name") %>'></asp:Label>
                            <asp:Label ID="lblmobile" runat="server" Visible="false" Text='<%#Eval("Mobile") %>'></asp:Label>
                            <asp:Label ID="lblSpecialization" runat="server" Visible="false" Text='<%#Eval("Specialization") %>'></asp:Label>
                            <asp:Label ID="lblDegree" runat="server" Visible="true" Text='<%#Eval("Degree") %>'></asp:Label>
                            <asp:Label ID="lblDoctorID" runat="server" Visible="False" Text='<%#Eval("Doctor_ID") %>'>'</asp:Label>

                            <asp:Label ID="lblIsVisible" runat="server" Visible="false" Text='<%#Eval("IsVisible") %>'></asp:Label>
                            <asp:Label ID="lblClinicName" runat="server" Visible="False" Text='<%#Eval("ClinicName") %>'>'</asp:Label>

                            <asp:Label ID="lblPhone2" runat="server" Visible="False" Text='<%#Eval("Phone2") %>'>'</asp:Label>
                            <asp:Label ID="lblEmail" runat="server" Visible="False" Text='<%#Eval("Email") %>'>'</asp:Label>
                            <asp:Label ID="lblActive" runat="server" Visible="false" Text='<%#Eval("IsActive") %>'></asp:Label>
                           
                           

                            <asp:Label ID="lblDoctorCode" runat="server" Visible="false" Text='<%#Eval("DoctorCode") %>'></asp:Label>
                             <asp:Label ID="lblStateID" runat="server" Visible="false" Text='<%#Eval("State") %>'></asp:Label>
                            <asp:Label ID="lblCityID" runat="server" Visible="false" Text='<%#Eval("City") %>'></asp:Label>
                            <asp:Label ID="lblLocalityID" runat="server" Visible="false" Text='<%#Eval("Locality") %>'></asp:Label>
                            <asp:Label ID="lblZoneID" runat="server" Visible="false" Text='<%#Eval("ZoneID") %>'></asp:Label>
                            <asp:Label ID="lblReferShare" runat="server" Visible="false" Text='<%#Eval("isReferal") %>'></asp:Label>
                            <asp:Label ID="lblReferMaster" runat="server" Visible="false" Text='<%#Eval("ReferMasterShare") %>'></asp:Label>
                            <asp:Label ID="lblPRO" runat="server" Visible="false" Text='<%#Eval("PROID") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                   
                   
                  
                    <asp:TemplateField HeaderText="DocType" Visible="false">
                        <ItemTemplate>
                            <%#Eval("DocType") %>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                    <asp:CommandField HeaderText="Edit" SelectText="Edit" ShowSelectButton="True">

                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                    </asp:CommandField>
                    <asp:TemplateField>
                        <HeaderTemplate>Centre Mapping</HeaderTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkCentreMapping" CommandName="CentreMapping" CommandArgument='<%#Eval("Doctor_ID") %>' runat="server">Centre Mapping</asp:LinkButton>
                        </ItemTemplate>
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        <ItemStyle CssClass="GridViewItemStyle" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>


        </div>
    </div>

    <asp:Panel ID="pnlSave" runat="server" Style="display: none;" Height="441px" Width="331px">
        <div class="Purchaseheader" id="Div1" runat="server">
            Add New Doctor
        </div>
        <div class="row">
            <div class="col-md-3">
                Doctor Name :
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="txtDocName" runat="server" Width="250px"></asp:TextBox>
            </div>
            <div class="col-md-3">
                Phone :
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="txtPhone" runat="server" Width="250px" MaxLength="100"></asp:TextBox>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">Address :
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="txtAddress" runat="server" Width="250px" MaxLength="200" Height="40px" TextMode="MultiLine"></asp:TextBox>
            </div>
            <div class="col-md-3">DateOfBirth :
            </div>
            <div class="col-md-5"><asp:TextBox ID="txtDob" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtDob" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
            </div>
        </div>
         <div class="row">
            <div class="col-md-3">Anniversary :
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="txtAnniversary" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calAnniversary" runat="server" TargetControlID="txtAnniversary" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
            </div>
            <div class="col-md-3">Area Name :
            </div>
            <div class="col-md-5"><asp:DropDownList ID="ddlArea" runat="server" Width="254px">
                </asp:DropDownList>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">Mobile :
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="txtMobile" runat="server"
                        Height="16px" MaxLength="100" Width="134px"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
            </div>
            <div class="col-md-3">
                Specialization :
            </div>
            <div class="col-md-5">
                <asp:DropDownList ID="ddlSpecialization" runat="server" Width="254px">
                    </asp:DropDownList>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">
                Doctor Referal :
            </div>
            <div class="col-md-5">
                <asp:DropDownList ID="ddlRefrelDoctor" runat="server" TabIndex="7"
                        Width="254px">
                    </asp:DropDownList>
            </div>
        </div>
        <div class="row">
        <div class="filterOpDiv">
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" Width="65px" ValidationGroup="Save" OnClick="btnSave_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false" CssClass="ItDoseButton" Width="55px" />
        </div>
        </div>
    </asp:Panel>

   

    <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;"></asp:Button>

    <asp:Panel ID="pnlUpdate" runat="server" Width="600px" Style="display: none; height:320px;" >
        <div style="width: 600px; background: url(../../App_Images/patter.jpg); border: 1px solid black; height:320px;">
                <div class="Purchaseheader">Doctor Detail</div>
                <div class="row" style="display: none">
                    <div class="col-md-4" >
                        Doctor Type :
                    </div>
                    <div class="col-md-8">
                        <asp:DropDownList ID="ddldoctorgroup" runat="server" AutoPostBack="true" >
                                <asp:ListItem Value="Refer Doctor">Refer Doctor</asp:ListItem>
                                <asp:ListItem Value="PolyClinic Doctor">PolyClinic Doctor</asp:ListItem>
                            </asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4" style= "color: red">
                        DoctorCode:
                    </div>
                    <div class="col-md-8" >
                        <asp:TextBox ID="txtDocCode" runat="server"  MaxLength="20" ClientIDMode="Static"
                        TabIndex="1"></asp:TextBox>

                     <asp:Label ID="lblDoctor_ID" runat="server"   ClientIDMode="Static"
                        style="display:none"></asp:Label>
                    </div>
                </div>
            <div class="row">
                 <div class="col-md-4" style= "color: red">
                     Name :
                         </div>
                    <div class="col-md-8">
                          <asp:DropDownList ID="cmbTitle" runat="server" TabIndex="1"
                                ToolTip="Select Title" Width="50px">
                                <asp:ListItem></asp:ListItem>
                                <asp:ListItem>Dr.</asp:ListItem>
                                <asp:ListItem>Mr.</asp:ListItem>
                                <asp:ListItem>Ms.</asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtUpdateDocName" runat="server" MaxLength="100"
                                TabIndex="2" Width="125px" ClientIDMode="Static"></asp:TextBox>
                        </div>
                 <div class="col-md-4">ClinicName:
                         </div>
                    <div class="col-md-8"><asp:TextBox ID="txtClinicName"
                                runat="server" MaxLength="20" TabIndex="3" ></asp:TextBox>
                        </div>
            </div>
            <div class="row">
                 <div class="col-md-4">Email :
                         </div>
                    <div class="col-md-8">
                        <asp:TextBox ID="txtEmail" runat="server" ClientIDMode="Static" MaxLength="50" TabIndex="4"></asp:TextBox>
                        </div>
                 <div class="col-md-4">Address :
                         </div>
                    <div class="col-md-8"><asp:TextBox ID="txtAdd" runat="server"  MaxLength="20"
                        TabIndex="5"  TextMode="MultiLine"></asp:TextBox>
                        </div>
            </div>
            <div class="row">
                 <div class="col-md-4">Phone :
                         </div>
                    <div class="col-md-8">
                        <asp:TextBox ID="txtPhone2"
                            runat="server"  MaxLength="20" TabIndex="6" ClientIDMode="Static"></asp:TextBox>

                 <cc1:FilteredTextBoxExtender ID="ftbPhone2" runat="server" TargetControlID="txtPhone2" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </div>
                <div class="col-md-6"><asp:CheckBox ID="chkRefershare" runat="server"  Text="Refer Share" ClientIDMode="Static"/>
                         </div>
                <div class="col-md-6"><asp:CheckBox ID="ChkRefersharemaster" runat="server" Text="Refer Master" ClientIDMode="Static"/></div>
            </div>
            <div class="row">
                 <div class="col-md-4" style="color: Red">Mobile :
                         </div>
                    <div class="col-md-8">
                        <asp:TextBox ID="txtxtUpdateMobile" runat="server" MaxLength="10" TabIndex="7"  ClientIDMode="Static"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbUpdateMobile" runat="server" FilterType="Numbers" TargetControlID="txtxtUpdateMobile" />
                        </div>
                 <div class="col-md-4">
                     Specialization:
                         </div>
                    <div class="col-md-8">
                        <asp:DropDownList ID="ddlSpecial" runat="server" TabIndex="8" Width="120px" ClientIDMode="Static">
                                </asp:DropDownList>
                                <input type="button" value="AddNew" onclick="opensplpopup()" class="searchbutton"/>
                        </div>
            </div>
            <div class="row">
                 <div class="col-md-4">Degree :
                         </div>
                    <div class="col-md-8">
                        <asp:DropDownList ID="ddlDegree" runat="server"  Width="120px" TabIndex="9" ClientIDMode="Static">
                            </asp:DropDownList>
                            <input type="button" value="AddNew" onclick="showme()" class="searchbutton" />
                        </div>
                 <div class="col-md-4"><asp:CheckBox ID="chkActive" runat="server" Text="IsActive" ClientIDMode="Static" />
                         </div>
                   
            </div>
            <div class="row">
                 <div class="col-md-4">
                     State :
                         </div>
                    <div class="col-md-8">
                        <asp:DropDownList ID="ddlState" runat="server" ClientIDMode="Static" onchange="bindCity()" TabIndex="10" >
                            </asp:DropDownList>
                        </div>
                 <div class="col-md-4">City :
                         </div>
                    <div class="col-md-8"> <asp:DropDownList ID="ddlCity" runat="server" ClientIDMode="Static" onchange="bindZone()" TabIndex="11" >
                            </asp:DropDownList>
                        </div>
            </div>
            <div class="row">
                 <div class="col-md-4">Zone :
                         </div>
                    <div class="col-md-8">
                         <asp:DropDownList ID="ddlZone" runat="server" ClientIDMode="Static" onchange="bindLocality()" TabIndex="12" >
                            </asp:DropDownList>
                        </div>
                 <div class="col-md-4">Locality :
                         </div>
                    <div class="col-md-8"><asp:DropDownList ID="ddlLocality" runat="server" ClientIDMode="Static" TabIndex="13" >
                            </asp:DropDownList>
                        </div>
            </div>
             <div class="row">
                  <div class="col-md-4" >
                 PRO :
            </div>
            <div class="col-md-8">
                <asp:DropDownList ID="ddlPRO" runat="server" CssClass="chosen-select" TabIndex="12" ClientIDMode="Static">
                                        </asp:DropDownList></div>
                 </div>
            <div class="row" style="text-align:center">
                <input id="btnUpdateDoc" type="button" value="Update" tabindex="14" onclick="updateDoctor()" class="savebutton"/>
                <asp:Button ID="btnItemCancel" runat="server" CausesValidation="false" CssClass="resetbutton" Text="Cancel"  />
            </div>
        </div>

        
        

        <asp:Panel ID="mypanel" runat="server" Style="background-color: navajowhite; border: 1px solid black; display: none;" Width="300px">
            <div class="row">
                <div class="col-md-8">
                    <strong>Degree :</strong>
                </div>
                <div class="col-md-16">
                    <asp:TextBox ID="txtnewdegree" runat="server"  MaxLength="200"></asp:TextBox>
                </div>
            </div>
            <div class="row" style="text-align:center">
                <input type="button" value="Save" onclick="savenewdegree()" />
                <asp:Button ID="hideme" runat="server" Text="Close" />
            </div>
        </asp:Panel>



        <cc1:ModalPopupExtender ID="m1" runat="server" CancelControlID="hideme" TargetControlID="Button2"
            BackgroundCssClass="filterPupupBackground" PopupControlID="mypanel">
        </cc1:ModalPopupExtender>
        <asp:Button ID="Button2" Style="display: none;" runat="server" />


        <asp:Panel ID="Panel1" runat="server" Style="background-color: navajowhite; border: 1px solid black; display: none;" Width="400px">
            <div class="row">
                <div class="col-md-8"><strong>Specialization  :</strong> 
                </div>
                 <div class="col-md-16"><asp:TextBox ID="txtspecil" runat="server" MaxLength="100"></asp:TextBox>
                </div>
            </div>
           <div class="row" style="text-align:center">
            <input type="button" value="Save" onclick="savenewspecil()"  />
            <asp:Button ID="Button3" runat="server" Text="Close" />
           </div>
          
        </asp:Panel>

        <cc1:ModalPopupExtender ID="m2" runat="server" CancelControlID="Button3" TargetControlID="Button2"
            BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1">
        </cc1:ModalPopupExtender>

    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server"
        CancelControlID="btnItemCancel"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate"
        PopupDragHandleControlID="dragUpdate" BehaviorID="mpeCreateGroup">
    </cc1:ModalPopupExtender>




    <asp:Button ID="Button1" Style="display: none;" runat="server" />

    <script type="text/javascript">
        $(document).ready(function () {
            var MaxLength = 200;
            $("#<% =txtAdd.ClientID %> ").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#<% =txtAdd.ClientID %>").bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });
    </script>
    <script type="text/javascript">
        function updateDoctor() {
            $("#lblMsg").text("");
            if (jQuery.trim($("#txtDocCode").val()) == '') {
                $("#lblMsg").text("Please Enter Doctor Code");
                $("#txtDocCode").focus();
                return;
            }
            if (jQuery.trim($("#txtUpdateDocName").val()) == '') {
                $("#lblMsg").text("Please Enter Doctor Name ");
                $("#txtUpdateDocName").focus();
                return;
            }
            if ($("#txtxtUpdateMobile").val().length == 0) {
                $("#lblMsg").text("Please Enter Mobile No.");
                $("#txtxtUpdateMobile").focus();
                return;
            }

            if (jQuery.trim($("#txtxtUpdateMobile").val()) != "" && $("#txtxtUpdateMobile").val().length < 10) {
                $("#lblMsg").text("Enter a valid Mobile No.");
                $("#txtxtUpdateMobile").focus();
                return;
            }
            if ($('#<%=txtEmail.ClientID%>').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test($('#<%=txtEmail.ClientID%>').val())) {
                    $("#lblMsg").text('Please provide a valid email address');
                    $('#<%=txtEmail.ClientID%>').focus();
                    return;
                }
            }




         //  if ($("#<%=ddlState.ClientID%>").val() == "0") {
         //      $("#lblMsg").text("Please Select State");
         //      $("#ddlState").focus();
         //      return;
         //  }
         //  if ($("#<%=ddlCity.ClientID%>").val() == "0" || $("#<%=ddlCity.ClientID%>").val() == null) {
         //      $("#lblMsg").text("Please Select City");
         //      $("#ddlCity").focus();
         //      return;
         //  }
         //  if ($("#<%=ddlZone.ClientID%>").val() == "0" || $("#<%=ddlZone.ClientID%>").val() == null) {
         //      $("#lblMsg").text("Please Select Zone");
         //      $("#ddlZone").focus();
         //      return;
         //  }
         //  if ($("#<%=ddlLocality.ClientID%>").val() == "0" || $("#<%=ddlLocality.ClientID%>").val() == null) {
         //      $("#lblMsg").text("Please Select Locality");
         //      $("#ddlLocality").focus();
         //      return;
         //  }
            $("#btnUpdateDoc").attr('disabled', 'true');



            var Specialization = "";
            if ($("#<%=ddlSpecial.ClientID%>").val() != "0")
                Specialization = $("#<%=ddlSpecial.ClientID%> option:selected").text();

            var Degree = "";
            if ($("#<%=ddlDegree.ClientID%>").val() != "0")
                Degree = $("#<%=ddlDegree.ClientID%> option:selected").text();


            var doctype = $('#<%=ddldoctortype.ClientID%>').val();
            var visitday = "";
            var GroupID = "0";

            var IsActive = $("#chkActive").is(':checked') ? 1 : 0;
            var $ReferShare = $("#chkRefershare").is(':checked') ? 1 : 0;
            var $ReferMaster = $("#ChkRefersharemaster").is(':checked') ? 1 : 0;
            serverCall('DoctorReferal.aspx/updateDoctor', { Title: $("#<%=cmbTitle.ClientID%>").val(), Name: jQuery.trim($("#<%=txtUpdateDocName.ClientID %>").val()), Phone1: $("#<%=txtPhone2.ClientID %>").val(), Mobile: $("#<%=txtxtUpdateMobile.ClientID %>").val(), Street_Name: $("#<%=txtAdd.ClientID %>").val(), Specialization: Specialization, DocCode: $("#<%=txtDocCode.ClientID%>").val(), Email: $("#<%=txtEmail.ClientID%>").val(), ClinicName: $("#<%=txtClinicName.ClientID%>").val(), Degree: Degree, doctype: doctype, visitday: visitday, GroupID: GroupID, StateID: $("#<%=ddlState.ClientID%>").val(), CityID: $("#<%=ddlCity.ClientID%>").val(), ZoneID: $("#<%=ddlZone.ClientID%>").val(), LocalityID: $("#<%=ddlLocality.ClientID%>").val(), Doctor_ID: $("#<%=lblDoctor_ID.ClientID%>").text(), IsActive: IsActive, ReferShare: $ReferShare, ReferMaster: $ReferMaster, PRO: $("#<%=ddlPRO.ClientID%>").val() }, function (result) {
                var resultDate = JSON.parse(result);
                $("#btnUpdateDoc").removeAttr("disabled");
                    if (resultDate.status) {
                        toast("Success",'Record Updated Successfully','');
                        $find('mpeCreateGroup').hide();
                        $("#<%=btnSearch.ClientID%>").click();
                    }
                    else if (resultDate.response == "Error") {
                        toast("Error", resultDate.response, '');
                    }
                    else if (resultDate.response.split('#')[0] == "0" || resultDate.response.split('#')[0] == "1") {
                        toast("Info", resultDate.response.split('#')[1], '');

                    }
            });
        }
    </script>
        <script type="text/javascript">
            function bindCity(con) {
                $("#ddlCity option").remove();
                $("#ddlZone option").remove();
                $("#ddlLocality option").remove();
                serverCall('../Common/Services/CommonServices.asmx/bindCity', { StateID: $('#<%=ddlState.ClientID%>').val() }, function (result) {
                    cityData = jQuery.parseJSON(result);
                    if (cityData.length == 0) {
                        $('#<%=ddlCity.ClientID%>').append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < cityData.length; i++) {
                            $('#<%=ddlCity.ClientID%>').append($("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                        }
                       
                        bindZone();
                    }
                    $modelUnBlockUI(function () { });
            });
        }
            function bindZone() {
                $("#ddlZone option").remove();
                $("#ddlLocality option").remove();
                serverCall('../Common/Services/CommonServices.asmx/bindZone', { CityID: $("#ddlCity").val() }, function (result) {
                zoneData = jQuery.parseJSON(result);
                if (zoneData.length == 0) {
                    $("#ddlZone").append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    $("#ddlZone").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < zoneData.length; i++) {
                        $("#ddlZone").append($("<option></option>").val(zoneData[i].ZoneID).html(zoneData[i].Zone));
                    }
                }
                $modelUnBlockUI(function () { });
                 bindLocality();
                });
            }
            function bindLocality() {
                $("#ddlLocality option").remove();
                serverCall('../Common/Services/CommonServices.asmx/bindLocalityByZone', { ZoneID: $("#ddlZone").val() }, function (result) {
                 localityData = jQuery.parseJSON(result);
                 if (localityData.length == 0) {
                     $("#ddlLocality").append($("<option></option>").val("0").html("---No Data Found---"));
                 }
                 else {
                     $("#ddlLocality").append($("<option></option>").val("0").html("Select"));
                     for (i = 0; i < localityData.length; i++) {
                         $("#ddlLocality").append($("<option></option>").val(localityData[i].ID).html(localityData[i].NAME));
                     }
                 }
                 $modelUnBlockUI(function () { });
                });
            }
    </script>


</asp:Content>
