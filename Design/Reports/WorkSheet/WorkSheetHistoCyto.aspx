<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="WorkSheetHistoCyto.aspx.cs" Inherits="Design_Lab_WorkSheetHistoCyto" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 


    </head>
    <body >
    
         <form id="form1" runat="server">
        
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  

</Ajax:ScriptManager>
  
    <Ajax:UpdatePanel ID="up" runat="server">
        <ContentTemplate>     
     <div class="POuter_Box_Inventory">
         <div class="content" style="text-align: center;">
                <b>Work Sheet HistoCyto</b>
             <br />
             <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
                </div>
        

          <div class="POuter_Box_Inventory">
      
             <div class="row">
                 <div class="col-md-3" style="text-align:right"><b>From Date:</b></div>
                <div class="col-md-5"> <asp:TextBox ID="dtFrom" runat="server"  Width="100px"></asp:TextBox>
                              
                                <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                        TargetControlID="dtFrom"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtFrom" /></div>
                 <div class="col-md-3" style="text-align:right"><b>To Date:</b></div>
                 <div class="col-md-5"><asp:TextBox ID="dtTo" runat="server"  Width="100px"></asp:TextBox>
                             
                                <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                        TargetControlID="dtTo"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtTo" /></div>          
                <div class="col-md-3" style="text-align:right">status:   </div>
                    <div class="col-md-5"><asp:DropDownList ID="ddltype" runat="server" Width="104px">
                         <asp:ListItem Value="Slided">Pending</asp:ListItem>
                           <asp:ListItem Value="SlideComplete">Complete</asp:ListItem>
                     </asp:DropDownList></div>   
                 </div>    
              </div>       
               <div class="POuter_Box_Inventory">
          <div class="row">
              <div class="col-md-3" ><asp:RadioButtonList ID="rblreportformat" runat="server" RepeatDirection="Horizontal">
                  <asp:ListItem Value="1" Selected="True">Pdf</asp:ListItem>
                  <asp:ListItem Value="2">Excel</asp:ListItem>
                                    </asp:RadioButtonList> </div>
                <div class="col-md-20" style="color:maroon; text-align: center;"> <asp:Button ID="btnsearch" runat="server" Text="Get Report" Font-Bold="true" Width="90" OnClick="btnsearch_Click" style="text-align: center"/></div>
              </div>
                 
       
         </div>     

</ContentTemplate>
    </Ajax:UpdatePanel>
</form>
</body>
</html>

