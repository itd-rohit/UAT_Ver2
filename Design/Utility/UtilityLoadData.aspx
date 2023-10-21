<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UtilityLoadData.aspx.cs" Inherits="Design_Utility_UtilityLoadData" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">  
     
  
  <link href="../../App_Style/AppStyle.css" rel="stylesheet" type="text/css" /> 
      
    <title></title>
       
    <style type="text/css">
        input[type="submit"] {
            background-color: maroon; 
            padding: 5px;
            border-radius: 8px;
            -ms-border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

            input[type="submit"]:hover {
                background-color: yellow;
                color: black;
            }
        .auto-style2 {
            width: 125px;
        }
        </style>
</head>
<body>
         <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
       <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
          <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory">
    <div class="row">
    <div class="col-md-24" style="text-align:center;">
    <b>Utility Load Data</b><br />
         <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033" CssClass="ItDoseLblError"></asp:Label>&nbsp;</div>
   </div>
   </div>
   <div class="POuter_Box_Inventory">
    <div class="Purchaseheader"> 
        Search Criteria</div>
       <div class="row">
           <div class="col-md-4"><b class="pull-right">From Date:</b> </div>
           <div class="col-md-8"> <asp:TextBox ID="txtfromdate" Width="200px" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtfromdate" PopupButtonID="txtfromdate" Format="dd-MMM-yyyy" runat="server">
                                </cc1:CalendarExtender></div>
           <div class="col-md-4"><b class="pull-right">To Date:</b></div>
           <div class="col-md-8"><asp:TextBox ID="txttodate" Width="200px" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="ToDateCal" PopupButtonID="txttodate" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender></div>            
       </div>       
   </div>
       <div  class="POuter_Box_Inventory"  style="text-align:center;">
           <div class="row">
              <div class="col-md-24">
                   <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="savebutton" OnClick="btnSave_Click"/>               
                  </div>
           </div></div>
       </div>
    </form>
</body>
</html>
