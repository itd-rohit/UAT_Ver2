<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UploadExcel.aspx.cs" Inherits="Design_Store_UploadExcel" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">

            <div class="POuter_Box_Inventory">

                <div class="row" style="text-align: center">

                    <div class="col-md-24">
                        <asp:Label ID="llheader" runat="server" Text="Import Excel Data" Font-Size="16px" Font-Bold="true"></asp:Label></td>

                    </div>
                </div>

                <div class="row" style="text-align: center">

                    <div class="col-md-24">
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
                    </div>
                </div>


            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Upload Excel
                </div>
                <div class="row">

                    <div class="col-md-3">
                        <label class="pull-left">Upload Excel   </label>
                        <b class="pull-right">:</b>

                    </div>

                    <div class="col-md-8">
                        <asp:FileUpload ID="fpData" runat="server" />
                    </div>
                    <div class="col-md-13">
                        <span class="required">* Excel Must Be in Proper Format As Downloaded From Software</span>

                    </div>
                </div>
                <div class="row" style="text-align: center">

                    <div class="col-md-24">
                        <asp:Button ID="btnsave" runat="server" CssClass="searchbutton" OnClick="btnsave_Click" Text="Upload" />

                        <asp:Button ID="btnsave1" runat="server" CssClass="savebutton" Visible="false" OnClick="btnsave1_Click" Text="Save To Database" />
                    </div>
                </div>

            </div>


            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Data           
                </div>
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
            </div>
        </div>
       
    </form>
</body>
</html>
