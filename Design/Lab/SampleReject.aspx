<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleReject.aspx.cs" Inherits="Design_Lab_SampleReject" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <Ajax:UpdatePanel ID="up1" runat="server">
        <ContentTemplate>
            <div id="Pbody_box_inventory">
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <div class="row">
                        <div class="col-md-24 ">
                            <b>Reject Sample</b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24 ">
                            <asp:Label ID="lblMsg" runat="server" Style="color: red;" Font-Bold="true"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory">

                    <div class="row">
                        <div class="col-md-4 ">
                            <label class="pull-left">Patient Name   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="lbname" runat="server"></asp:Label></b>
                        </div>
                        <div class="col-md-4 ">
                            <label class="pull-left">Visit No.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="lblabno" runat="server"></asp:Label></b>
                            <asp:Label ID="lblabID" runat="server" Visible="false"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 ">
                            <label class="pull-left">SIN No.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="lbsinno" runat="server"></asp:Label>
                            </b>
                        </div>
                        <div class="col-md-4 ">
                            <label class="pull-left">UHID No.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="lbpid" runat="server"></asp:Label>
                            </b>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-4 ">
                            <label class="pull-left">Select Test  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20 ">
                            <asp:CheckBoxList ID="ddltest" runat="server" AutoPostBack="false" OnSelectedIndexChanged="ddltest_SelectedIndexChanged" RepeatColumns="1" RepeatDirection="Vertical" />
                            <asp:Label ID="lbtestid" runat="server" Visible="false" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-4 ">
                            <label class="pull-left">Sample Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="lbsampletype" runat="server"></asp:Label>
                            </b>
                        </div>
                        <div class="col-md-4 ">
                            <label class="pull-left">Vial Qty.  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="lbsampletype0" runat="server"></asp:Label>
                            </b>
                        </div>
                    </div>

                    <div class="row" style="display: none;">
                        <div class="col-md-4 ">
                            <label class="pull-left">Collected By  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <asp:Label ID="Label4" runat="server"></asp:Label>

                        </div>
                        <div class="col-md-4 ">
                            <label class="pull-left">Collection Date  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <asp:Label ID="Label1" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="row" id="tr1" runat="server" visible="false">
                        <div class="col-md-4 ">
                            <label class="pull-left">Reject Reason </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="lbsampletype1" runat="server"></asp:Label></b>
                        </div>

                        <div class="col-md-4 ">
                            <label class="pull-left">Reject Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="Label2" runat="server"></asp:Label>
                            </b>
                        </div>

                    </div>
                    <div class="row" id="tr2" runat="server" visible="false">
                        <div class="col-md-4 ">
                            <label class="pull-left">Received By </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="lbsampletype2" runat="server"></asp:Label>
                            </b>
                        </div>
                        <div class="col-md-4 ">
                            <label class="pull-left">Received Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 ">
                            <b>
                                <asp:Label ID="Label3" runat="server"></asp:Label>
                            </b>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-4 ">
                            <label class="pull-left">Reject Reason </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20 ">
                            <asp:DropDownList ID="ddlreason" runat="server" OnSelectedIndexChanged="ddlreason_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList></td>

                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-24 ">
                            <label class="pull-left">
                                <asp:RadioButtonList ID="rblRepeatRefund" runat="server" RepeatColumns="2" Visible="false">
                                    <asp:ListItem Value="1" Selected="True">Repeat Sample</asp:ListItem>
                                    <asp:ListItem Value="2">Test Refund</asp:ListItem>
                                </asp:RadioButtonList></label>

                        </div>
                    </div>


                    <div class="row" id="tr" runat="server" visible="false">
                        <div class="col-md-4 ">
                            <label class="pull-left">Reject Reason </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-20 ">
                            <asp:TextBox ID="txtreason" runat="server" Width="386px" placeholder="Enter Rejection Reason"></asp:TextBox>
                        </div>
                    </div>

                </div>
                <div class="POuter_Box_Inventory" style=" text-align: center">
                    <asp:Button ID="btnsave" Text="Reject Sample" runat="server" CssClass="searchbutton" OnClick="btnsave_Click" OnClientClick="return validate();" />
                </div>
            </div>
        </ContentTemplate>
    </Ajax:UpdatePanel>
    <script type="text/javascript">
        function validate() {
            document.getElementById('<%=btnsave.ClientID%>').disabled = true;
            document.getElementById('<%=btnsave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnsave', '');


        }
        $(function () {
            hideDiv();
        });
        hideDiv = function () {
            $("#Pbody_box_inventory").css('margin-top', 0);
        }
    </script>
</asp:Content>

