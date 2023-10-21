<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TransferMachineRanges.aspx.cs" 
Inherits="Design_Investigation_TransferMachineRanges" Title="Machine Reference Range Master"
MasterPageFile="~/Design/DefaultHome.master"%>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>

<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>

    


    <asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>  
        
    <script type="text/javascript">
        function show()
        {
            if(confirm('r u sure?'))
            {
                window.location.replace('../Design/TransferMachineRanges.aspx');
            }
        }        
    </script>
     <div class="alert fade" style="position: absolute; left: 50%; border-radius: 15px;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width:1300px">
    <div style="float: left; width: 1296px; height: 40px;" id="div1" class="POuter_Box_Inventory">
    <div style="text-align: center" class="content">
        <span style="font-size: 16pt"><b><span style="font-size: 12pt">Machine Reference Ranges Transfer</span></b> 
            <br />
    <br />
        </span>
    
    </div></div>
    <br />
    
    <div id="SearchDiv" class="POuter_Box_Inventory" style="width: 1296px; height: 152px">
       
        <span style="font-size: 16pt">&nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
            
            <span
            style="font-size: 14pt">From Centre Machine<strong> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
&nbsp; &nbsp; &nbsp;
                
                                                </strong>To Centre Machine</span></span><br />
        <br />
    <div id="column1" style="float:left; width: 43%;">    &nbsp;Centre: &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;<asp:DropDownList id="ddlCentreSource" runat="server" Width="230px" class="ddlCentreSource chosen-select" ></asp:DropDownList><br />
        <br />
        &nbsp;Machine Name:&nbsp;
        <asp:DropDownList id="ddlMacSource" runat="server" Width="228px" class="ddlMacSource chosen-select">
    </asp:DropDownList>
    </div >
    <div></div>
    
    <div id="column2" style="float:right; width: 42%;">
      Centre: &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
      <asp:DropDownList id="ddlCentreTarget" runat="server" Width="230px"  class="ddlCentreTarget chosen-select">
      </asp:DropDownList><br />
        <br />
      Machine Name:
    <asp:DropDownList id="ddlMacTarget" runat="server" Width="228px"  class="ddlMacTarget chosen-select" > </asp:DropDownList>

    </div><br />
     
        <asp:Button ID="btntrnsfr" runat="server" Height="35px" Text=">>" Width="80px" class="searchbutton" OnClick="btntrnsfr_Click" /><br />
        <br />
        <br />
        <br />
    </div>
         <script type="text/javascript">
             $(document).ready(function () {


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
             });
    </script>
    </asp:Content>   
    
