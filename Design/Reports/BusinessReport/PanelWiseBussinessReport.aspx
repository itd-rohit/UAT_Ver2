<%@ Page ClientIDMode="Static"  Language="C#" AutoEventWireup="true" CodeFile="PanelWiseBussinessReport.aspx.cs" Inherits="Design_OPD_PanelWiseBussinessReport" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
    <link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 
    </head>
    <body >
         <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
  <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
    <asp:ScriptReference Path="~/Scripts/PostReportScript.js" />
</Scripts>
</Ajax:ScriptManager>
    <script type="text/javascript">
        jQuery(function () {
            jQuery('[id*=<%=lstpanellist.ClientID%>]').multipleSelect({
             includeSelectAllOption: true,
             filter: true, keepOpen: false
            });
            jQuery('[id*=<%=lstCentreList.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=<%=lstpaneltype.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            jQuery('[id*=<%=lstfeildboy.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
     });
        </script>
    <style type="text/css">
        .multiselect
        {
            width: 100%;
        }

        .ajax__calendar .ajax__calendar_container
        {
            z-index: 9999;
        }
    </style> 
     <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory" style="text-align: center">
			<b>Panel Wise Bussiness Report</b>
			<asp:Label  ID="lblMsg" runat="server"></asp:Label>
      <%--  <Ajax:ScriptManager ID="sc1" runat="server">           
		</Ajax:ScriptManager>--%>
		</div>
    <div class="POuter_Box_Inventory" style="text-align: left">
    <div id="PatientDetails">		 
		 <div class="row" style="margin-top: 0px;">
		 <div class="col-md-28" >
            <div class="content">
                 <div class="row" style="margin-top: 0px;">
		 <div class="col-md-28" >
              <div class="row">
		  <div class="col-md-6">
			   <label class="pull-left">Date From</label>
			  <b class="pull-right">:</b>
		   </div>		  
                  <div class="col-md-8">
                       <asp:TextBox ID="txtFromDate" runat="server" Width="210px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </div>
                   <div class="col-md-4">
			   <label class="pull-left">To</label>
			  <b class="pull-right">:</b>
		   </div>		  
                  <div class="col-md-4">
                        <asp:TextBox ID="txtToDate" runat="server" Width="210px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </div>
                  </div>
             <div class="row">
		  <div class="col-md-6">
			   <label class="pull-left">Panel Type</label>
			  <b class="pull-right">:</b>
		   </div>		  
                  <div class="col-md-8">
                         <asp:ListBox ID="lstpaneltype"  CssClass="multiselect" SelectionMode="Multiple"  Width="80%" runat="server" ClientIDMode="Static"></asp:ListBox>   

                      </div>
                 
                  </div>
             <div class="row">
                   <div class="col-md-6">
			   <label class="pull-left">Centre</label>
			  <b class="pull-right">:</b>
		   </div>		  
                  <div class="col-md-8">
                      <asp:ListBox ID="lstCentreList"  CssClass="multiselect" SelectionMode="Multiple"  Width="80%" runat="server" ClientIDMode="Static"></asp:ListBox>   

                      </div>
             </div>
              <div class="row">
                   <div class="col-md-6">
			   <label class="pull-left">Panel</label>
			  <b class="pull-right">:</b>
		   </div>		  
                  <div class="col-md-8">
                     <asp:ListBox ID="lstpanellist"  CssClass="multiselect" SelectionMode="Multiple"  Width="80%" runat="server" ClientIDMode="Static"></asp:ListBox> 

                      </div>
             </div>
              <div class="row">
                   <div class="col-md-6">
			   <label class="pull-left">Feild Boy</label>
			  <b class="pull-right">:</b>
		   </div>		  
                  <div class="col-md-8">
                      <asp:ListBox ID="lstfeildboy"   CssClass="multiselect" SelectionMode="Multiple"  Width="80%" runat="server" ClientIDMode="Static"></asp:ListBox> 

                      </div>
             </div>
               <div class="row">
                   <div class="col-md-6">
			   <label class="pull-left">Panel Pay Mode</label>
			  <b class="pull-right">:</b>
		   </div>		  
                  <div class="col-md-8">
                     <asp:RadioButtonList ID="chkPaymentMode" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                                    <asp:ListItem>Cash</asp:ListItem>
                                    <asp:ListItem>Credit</asp:ListItem>
                                    <asp:ListItem>Rolling Advance</asp:ListItem>
                                    <asp:ListItem Selected="True">All</asp:ListItem>
                                </asp:RadioButtonList>
                      </div>
             </div>
               <div class="row">
                   <div class="col-md-6">
			   <label class="pull-left">Panel Pay Mode</label>
			  <b class="pull-right">:</b>
		   </div>		  
                  <div class="col-md-12" >
                  <asp:RadioButtonList ID="rbtnReportType" runat="server" RepeatColumns="7" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                    <asp:ListItem Value="0" Selected="True">Summary</asp:ListItem>
                                    <asp:ListItem Value="1">Detail</asp:ListItem>
                                    <asp:ListItem Value="2">Detail 1</asp:ListItem>
                                    <asp:ListItem Value="%M-%y" >MonthWise</asp:ListItem>
                                    <asp:ListItem Value="3">Monthly (Gr Amt)</asp:ListItem>
                                    <asp:ListItem Value="4">Monthly (Net Amt)</asp:ListItem>
                                    
                                </asp:RadioButtonList>
                      </div>
             </div>
             </div>
             </div>
               
            </div>
        </div>
         </div>
        </div>
        <div class="Outer_Box_Inventory" style="text-align: center; width: 99.6%">
            <asp:Button ID="btnSearch" Visible="false" runat="server" Text="PDF Report" class="ItDoseButton"  Width="150px" OnClick="btnSearch_Click" />

            <asp:Button ID="Button1" runat="server" Text="Excel Report" class="ItDoseButton"  Width="150px" OnClick="Button1_Click" />
        </div>
    </div>
      

         </div>
</form>
</body>
</html>

