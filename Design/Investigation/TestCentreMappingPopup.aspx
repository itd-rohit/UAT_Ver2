<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestCentreMappingPopup.aspx.cs" Inherits="Design_Investigation_TestCentreMappingPopup" %>

<!DOCTYPE html>
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
      
            <div id="body_box_inventory" >
                <div class="POuter_Box_Inventory" style="text-align: center;">
                   
                       
                            <asp:Label runat="server" ID="lblHeader" style="font-weight:bold;" Text="Set Test Centre"></asp:Label><br />
                            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                            
                        </div>
                   
                   
                        <div class="POuter_Box_Inventory"  runat="server" style="text-align: left; ">
                            <div style="width: 435px;text-align:right">
                                <asp:Label ID="lblBookingCentre" runat="server" Text="Booking Centre :&nbsp;" Width="200px"></asp:Label>
                                <asp:DropDownList ID="ddlCentre" runat="server" Width="200px"></asp:DropDownList>
                               </div>
                             <div style="width: 435px;text-align:right">
                                <asp:Label ID="lblTestCentre" runat="server" Text="Test Centre1 :&nbsp;" Width="200px"></asp:Label>
                                <asp:DropDownList ID="ddlTestCentre" runat="server" Width="200px"></asp:DropDownList>
                               </div>
                            <div style="width: 435px;text-align:right">
                                <asp:Label ID="Label1" runat="server" Text="Test Centre2 :&nbsp;" Width="200px"></asp:Label>
                                <asp:DropDownList ID="ddlTestCentre2" runat="server" Width="200px"></asp:DropDownList>
                               </div>
                            <div style="width: 435px;text-align:right">
                                <asp:Label ID="Label2" runat="server" Text="Test Centre3 :&nbsp;" Width="200px"></asp:Label>
                                <asp:DropDownList ID="ddlTestCentre3" runat="server" Width="200px"></asp:DropDownList>
                               </div>
                          <div style="text-align:center;">
                            
                              <asp:Button id="txtSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="txtSave_Click"></asp:Button>
                               </div>
                                 
                            
                        </div>
                        

                    </div>
               
            
    </form>
</body>
</html>
