<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientSampleinfoPopup.aspx.cs" Inherits="Design_OPD_PatientSampleinfoPopup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>

    <style type="text/css">
        .auto-style5 {
            font-size: 9pt;
            font-family: Verdana, Arial, sans-serif, sans-serif;
            width: 196px;
            height: 19px;
        }

        .auto-style6 {
            width: 256px;
            height: 19px;
        }

        .auto-style7 {
            width: 200px;
            height: 19px;
        }

        .auto-style8 {
            width: 268px;
            height: 19px;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="Pbody_box_inventory" style="width: 836px;vertical-align:top;margin:-0px">
                <div class="POuter_Box_Inventory" style="width: 830px; text-align: center;">


                    <b>Sample Information</b>

                    <div style="text-align: center;">

                        <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>&nbsp;
                    </div>
                </div>

                <div class="POuter_Box_Inventory" style="text-align: center; width: 830px;">

                    <table style="width: 100%">
                        <tr>
                            <td colspan="4">
                                <div class="Purchaseheader">Sample Info</div>
                            </td>
                        </tr>

                        <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                            <td align="right" style="width: 196px;" valign="middle" class="ItDoseLabel">Visit No.:&nbsp;
                            </td>
                            <td align="left" style="width: 256px" valign="middle">
                                <asp:Label ID="lblLabNo" runat="server" Text="Label" Width="217px"></asp:Label>
                            </td>

                            <td align="right" style="width: 200px; text-align: right;" valign="middle">Sample Type :&nbsp;
                            </td>
                            <td align="left" style="width: 268px;" valign="middle">
                                <asp:Label ID="lblSampleType" runat="server" Text="Label" Width="217px"></asp:Label></td>
                        </tr>
                        <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                            <td align="right" style="width: 196px;" valign="middle" class="ItDoseLabel">Patient Name :&nbsp;</td>
                            <td align="left" style="width: 256px" valign="middle">
                                <asp:Label ID="lblPatientName" runat="server" Text="Label" Width="217px"></asp:Label>
                            </td>

                            <td align="right" style="width: 200px; text-align: right;" valign="middle">Age / Sex :&nbsp; </td>
                            <td align="left" style="width: 268px;" valign="middle">
                                <asp:Label ID="lblAge" runat="server" Text="Label" Width="217px"></asp:Label></td>
                        </tr>
                        <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                            <td align="right" valign="middle" class="ItDoseLabel" style="width: 196px">Phone/Mobile :&nbsp;
                            </td>
                            <td align="left" valign="middle" style="width: 256px">
                                <asp:Label ID="lblMobile" runat="server" Text="" Width="217px"></asp:Label></td>
                            <td align="right" valign="middle" style="width: 200px">Department :&nbsp;</td>
                            <td align="left" valign="middle" style="width: 268px">
                                <asp:Label ID="lblDepartment" runat="server" Text="" Width="217px"></asp:Label></td>
                        </tr>
                        <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                            <td align="right" style="width: 196px;" valign="middle" class="ItDoseLabel">Refer Doctor :&nbsp;
                            </td>
                            <td align="left" style="width: 256px" valign="middle">
                                <asp:Label ID="lblRefDoctor" runat="server" Width="217px" Text=""></asp:Label>
                            </td>
                            <td align="right" style="width: 200px; text-align: right;" valign="middle">PCC Code :&nbsp;</td>
                            <td align="left" style="width: 268px;" valign="middle">
                                <div id="Div1">
                                    <asp:Label ID="lblpanel" runat="server" Width="217px" Text=""></asp:Label>&nbsp;
                                </div>
                            </td>
                        </tr>
                        <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif;">
                            <td align="right" style="width: 196px; vertical-align: top;" valign="middle" class="ItDoseLabel">Comments :&nbsp;
                            </td>
                            <td align="left" style="width: 256px" valign="middle">
                                <asp:Label ID="lblComments" runat="server" Width="217px" Text=""></asp:Label>
                            </td>
                            <td align="right" style="width: 200px; text-align: right;" valign="middle">SIN :&nbsp;</td>
                            <td align="left" style="width: 268px;" valign="middle">
                                <asp:Label ID="lblVial" runat="server" Width="217px" Text=""></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="vertical-align: top;" valign="middle" class="auto-style5">
                                <asp:HyperLink ID="hlAttachment" runat="server" Style="font-weight: 700">View Attachments</asp:HyperLink>
                            </td>
                            <td align="left" valign="middle" class="auto-style6">&nbsp;
                            </td>
                            <td align="right" style="text-align: right;" valign="middle" class="auto-style7">DOB :&nbsp;</td>
                            <td align="left" valign="middle" class="auto-style8">
                                <asp:Label ID="llbob" runat="server"></asp:Label>
                                &nbsp;                                               
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <div class="Purchaseheader">Required Fields</div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" style="padding-left: 15px;">
                                <asp:GridView ID="grdrequiredfile" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">

                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="Field Name" DataField="FieldName" />
                                        <asp:BoundField DataField="FieldValue" HeaderText="FieldValue" />
                                    </Columns>
                                    <FooterStyle BackColor="White" ForeColor="#000066" />
                                    <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                                    <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                    <RowStyle ForeColor="#000066" />
                                    <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                                    <SortedAscendingCellStyle BackColor="#F1F1F1" />
                                    <SortedAscendingHeaderStyle BackColor="#007DBB" />
                                    <SortedDescendingCellStyle BackColor="#CAC9C9" />
                                    <SortedDescendingHeaderStyle BackColor="#00547E" />
                                </asp:GridView>
                            </td>

                        </tr>
                        <tr>

                            <td colspan="4"></td>
                        </tr>
                    </table>



                </div>
                <div class="POuter_Box_Inventory" style="text-align: center; width: 830px;">

                    <div class="Purchaseheader">Test List</div>
                    <div style="width: 100%; height: 250px; overflow-y: scroll;">
                        <asp:GridView ID="grdTestDetails" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:BoundField DataField="Name" HeaderText="Investigation Name" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="HomeCollectionDate" HeaderText="Sample Drawn Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="WorkOrderBy" HeaderText="Work Order By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="SegratedDate" HeaderText="Registration Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="SampleCollector" HeaderText="Registered By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="SampleReceiveDate" HeaderText="Received Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="SampleReceivedBy" HeaderText="Received By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />

                                <asp:BoundField DataField="RejectDate" HeaderText="Rejected Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="RejectUser" HeaderText="Rejected By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="RejectionReason" HeaderText="Sample Rejected Reason" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ResultEnteredDate" HeaderText="Result Entered Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ResultEnteredName" HeaderText="Result Entered By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ApprovedDate" HeaderText="Approved Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />

                                <asp:BoundField DataField="ApprovedName" HeaderText="Approved By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ApprovedDoneBy" HeaderText="Approved Login By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="HoldByName" HeaderText="Hold By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Hold_Reason" HeaderText="Hold Reason" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                 <asp:BoundField DataField="printby" HeaderText="Printed By" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>


            </div>

        </div>
    </form>
</body>
</html>
