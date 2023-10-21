<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowvendoridDetail.aspx.cs" Inherits="Design_Store_ShowvendoridDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">

            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align: center">
                    <div class="col-md-24">
                        <asp:Label ID="llheader" runat="server" Text="Vendor Detail" Font-Size="16px" Font-Bold="true"></asp:Label>

                    </div>
                </div>
                <div class="row" style="text-align: center">

                    <div class="col-md-24">
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
                    </div>
                </div>


            </div>
            <div class="POuter_Box_Inventory">


                <asp:FormView ID="grd1" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Both" Width="99%">
                    <EditRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                    <FooterStyle BackColor="White" ForeColor="#000066" />
                    <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                    <ItemTemplate>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Supplier Name   </label>
                                <b class="pull-right">:</b>

                            </div>

                            <div class="col-md-8">
                                <%# Eval("SupplierName")%>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Supplier Code  </label>
                                <b class="pull-right">:</b>

                            </div>

                            <div class="col-md-8">
                                <%# Eval("SupplierCode")%>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Supplier Category   </label>
                                <b class="pull-right">:</b>

                            </div>

                            <div class="col-md-8">
                                <%# Eval("SupplierCategoryName")%>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Organization Type  </label>
                                <b class="pull-right">:</b>

                            </div>

                            <div class="col-md-8">
                                <%# Eval("OrganizationTypename")%>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">House No.   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("HouseNo")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Street  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("Street")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Country   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("Country")%>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">State</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("State")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">PinCode  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("PinCode")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Landline   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("Landline")%>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Fax No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("FaxNo")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">EmailId  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("EmailId")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Website   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("Website")%>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">PrimaryContactPerson</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("PrimaryContactPerson")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Designation  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("PrimaryContactPersonDesignation")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Mobile No.   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("PrimaryContactPersonMobileNo")%>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">EmailId</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("PrimaryContactPersonEmailId")%>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Sec.ContactPerson</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("SecondaryContactPerson")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Designation  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("SecondaryContactPersonDesignation")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Mobile No.   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("SecondaryContactPersonMobileNo")%>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">ROC No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("ROCNo")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">ESI Reg. No.  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("ESIRegistrationNo")%>
                            </div>
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">ISOCertificationNo</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("ISOCertificationNo")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Valid Upto  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("ISOValidUpto")%>
                            </div>
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left" title="Pollution Control Board Certification No.">Poll.Cont.BoardCer.No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("PollutioncontrolBoardCertificationNo")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Valid Upto  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("PollutionValidUpto")%>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">MSME Registration</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("IsMSMERegistration")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">MSME Reg. No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("MSMERegistrationNo")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Valid Upto</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("MSMERegistrationValidDate")%>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Bank1</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("Bank1")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank1Branch</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("Bank1Branch")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank1 Acc. No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("Bank1AccountsNo")%>
                            </div>
                        </div>


                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Bank1IFSCCode</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("Bank1IFSCCode")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank1Address1</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("Bank1Address1")%> </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank1Address2</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("Bank1Address2")%> </div>
                        </div>


                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Bank1City</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("Bank1City")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank1State</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("Bank1State")%></div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Bank2</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("Bank2")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank2Branch</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <%# Eval("Bank2Branch")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank2 Acc. No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("Bank2AccountsNo")%></div>
                        </div>


                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Bank2IFSCCode</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("Bank2IFSCCode")%>
                            </div>
                            <div class="col-md-3">

                                <label class="pull-left">Bank2Address1</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("Bank2Address1")%></div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank2Address2</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("Bank2Address2")%></div>
                        </div>


                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">Bank2City</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("Bank2City")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Bank2State</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("Bank2State")%></div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">PaymentTerms</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("PaymentTerms")%>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Taxes</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("Taxes")%></div>
                            <div class="col-md-3">
                                <label class="pull-left">DeliveryTerms</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5"><%# Eval("DeliveryTerms")%></div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">VendorToNotes</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <%# Eval("VendorToNotes")%> </div>
                                     <div class="col-md-3">
                                         <label class="pull-left">CreditLimit</label>
                                         <b class="pull-right">:</b>
                                     </div>
                                <div class="col-md-5"><%# Eval("CreditLimit")%></div>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">CreatedDate</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-4">
                                    <%# Eval("CreatedDate")%>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">CreatedBy</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5"><%# Eval("CreatedBy")%></div>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <label class="pull-left">CheckedDate</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-4">
                                    <%# Eval("CheckedDate")%></div>
                                     <div class="col-md-3">
                                         <label class="pull-left">CheckedBy</label>
                                         <b class="pull-right">:</b>
                                     </div>

                                    <div class="col-md-5"><%# Eval("CheckedBy")%></div>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <label class="pull-left">ApprovedDate</label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-4">
                                        <%# Eval("ApprovedDate")%></div>
                                     <div class="col-md-3">
                                         <label class="pull-left">ApprovedBy</label>
                                         <b class="pull-right">:</b>
                                     </div>
                                        <div class="col-md-5"><%# Eval("ApprovedBy")%></div>
                                    </div>
                    </ItemTemplate>
                    <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                    <RowStyle ForeColor="#000066" />
                </asp:FormView>

                <br />
                <div class="row" style="text-align: center">
                    <div class="col-md-24">
                        <asp:GridView ID="grd" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
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
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <div class="col-md-24">
                        <asp:GridView ID="grd2" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
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
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <div class="col-md-24">
                        <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                            CellPadding="3" Style="width: 99%;" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px">
                            <RowStyle ForeColor="#000066" />
                            <Columns>

                                <asp:TemplateField HeaderText="File Type">
                                    <ItemTemplate>
                                        <asp:Label ID="FileName" runat="server" Text='<%# Bind("FileName") %>'></asp:Label>
                                        <asp:Label ID="lblPath" runat="server" Text='<%# Eval("AttachedFile")%>' Style="display: none;"></asp:Label>

                                    </ItemTemplate>

                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="File Name">
                                    <ItemTemplate>
                                        <a target="_self" href='DownloadAttachement.aspx?FileName=<%# Eval("AttachedFile")%>&FilePath=<%# Eval("AttachedFile")%>'><%# Eval("OriginalFileName")%></a>
                                        <asp:Label ID="OriginalFileName" Visible="false" runat="server" Text='<%# Bind("OriginalFileName") %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>



                            </Columns>
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White"
                                HorizontalAlign="Left" />
                            <SortedAscendingCellStyle BackColor="#F1F1F1" />
                            <SortedAscendingHeaderStyle BackColor="#007DBB" />
                            <SortedDescendingCellStyle BackColor="#CAC9C9" />
                            <SortedDescendingHeaderStyle BackColor="#00547E" />
                        </asp:GridView>
                    </div>
                </div>





            </div>

        </div>
    </form>
</body>
</html>
