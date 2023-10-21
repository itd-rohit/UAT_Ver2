<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="InvCountProcessing.aspx.cs" Inherits="Design_OPD_Default" %>

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
     <ajax:scriptmanager ID="ScriptManager2" runat="server">
        </ajax:scriptmanager>
        <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../../../App_Images/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
      <Ajax:UpdatePanel ID="mm" runat="server">
          <ContentTemplate>     
<div class="POuter_Box_Inventory">
<div class="content" style="text-align:center;">   
<b>Test Count(Processing) Report </b>&nbsp;<br />
<asp:Label id="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

</div> 
</div>
<div class="POuter_Box_Inventory" >
        <div class="row" >
            <div class="col-md-8">From Date:: <asp:TextBox ID="txtfromdate" runat="server" Width="100px" />
                <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
    TargetControlID="txtfromdate" Format="dd-MMM-yyyy" PopupButtonID="txtfromdate" /> </div>
            <div class="col-md-8"> To Date::<asp:TextBox ID="txttodate" runat="server" Width="100px" />
                <cc1:CalendarExtender runat="server" ID="CalendarExtender1"
    TargetControlID="txttodate"
    Format="dd-MMM-yyyy"
    PopupButtonID="txttodate" /> </div>
             <div class="col-md-8">
             <asp:RadioButtonList ID="rblcentreType" runat="server" RepeatDirection="Horizontal">
                 <asp:ListItem Value="0" Selected="True">Registration centre</asp:ListItem>
                 <asp:ListItem Value="1">Processing centre</asp:ListItem>
             </asp:RadioButtonList>
         </div>
            </div>
     <div class="row" >
            <%--
			<div class="col-md-8">Department::<asp:DropDownList ID="ddldepartment" runat="server" Width="150px"></asp:DropDownList></div>
         <div class="col-md-8">Centre::<asp:DropDownList ID="ddlcentre" runat="server" Width="150px"></asp:DropDownList></div>
			--%>
			
			 <div class="col-md-8">Department::<asp:ListBox ID="ddldepartment" CssClass="multiselect"  ClientIDMode="Static" SelectionMode="Multiple" runat="server" onchange="binddept()" ></asp:ListBox>
                                <asp:HiddenField ID="hdnItemId" runat="server"  /></div>
			 <div class="col-md-8">Center::<asp:ListBox ID="ddlcentre"  CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindcentre()"></asp:ListBox> 
                         <asp:HiddenField ID="hdnCentre" runat="server"  /> </div>
             <div class="col-md-8"></div>
         </div>
    <div class="row"  style="text-align:center" >
            <div class="col-md-24"> <asp:Button ID="btnsearch" runat="server" Text="Get Report" OnClick="btnsearch_Click" Font-Bold="true" />
                &nbsp;&nbsp;&nbsp; <asp:Button ID="btnExport" OnClick="btnExport_Click" runat="server" Text="Export To Excel" Font-Bold="true"  />
                &nbsp;&nbsp;&nbsp; <asp:Button ID="btnPdf" OnClick="btnPdf_Click" runat="server" Text="Export To Pdf" Font-Bold="true"  />
            </div>
        </div>  
    </div>

        <div class="POuter_Box_Inventory" >
            <div class="row"> <div class="col-md-24">
            <table style="width:100%">
                <tr>
                    <td>
                        <div style="height:300px;overflow:scroll;">
                            <asp:GridView ID="grd" Width="100%" runat="server" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True" ShowFooter="true"  >
                                 <FooterStyle BackColor="#006699"  Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                <RowStyle ForeColor="#000066" HorizontalAlign="Left" />
                                <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                            </asp:GridView>
                        </div>
                    </td>
                </tr>
            </table></div>
                </div>
            </div>
      
        
              </ContentTemplate>

           <Triggers>
        <Ajax:PostBackTrigger ControlID="btnExport" />
    </Triggers>
      </Ajax:UpdatePanel> 
	  
	  
	  
	  
	  <script type="text/javascript">
         $(function () {
             BindInvestigations(0);
            $("#Pbody_box_inventory").css('margin-top', 0);
			
			 $('[id$=ddlDepartment]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });  

			$('[id$=ddlcenter]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
			
                      
            
			 
           

         
             

             if ($('#hdnCentre').val() != '') {
                 var data = [];
                 data = $('#hdnCentre').val();
             }

             
             if ($('#hdnItemId').val() != '') {
                 var data1 = [];
                 data1 = $('[id$=hdnItemId]').val();
             }             
         
             var config = {
                 '.chosen-select': {},
                 '.chosen-select-deselect': { allow_single_deselect: true },
                 '.chosen-select-no-single': { disable_search_threshold: 10 },
                 '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                 '.chosen-select-width': { width: "95%" }
             }
             for (var selector in config) {
                 $(selector).chosen(config[selector]);
             }
             jQuery('#ddlDepartment').trigger('chosen:updated');
             jQuery('#ddlcenter').trigger('chosen:updated');          
          });
		 
		 </script>
	  
	  
</form>
</body>
</html>

