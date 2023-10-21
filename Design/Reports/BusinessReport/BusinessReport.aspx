<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BusinessReport.aspx.cs" Inherits="Design_Reports_BusinessReport_BusinessReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <style type="text/css">
         .ajax__tab_xp .ajax__tab_header .ajax__tab_tab {
             height: 20px !important;
         }
    </style>
     <script type="text/javascript">
         jQuery(function () {
             getcollectionReport(0, 1);

         });
         function clientActiveTabChanged(sender, args) {
             var selectedTab = sender.get_tabs()[sender.get_activeTabIndex()]._tab;
             var tabText = selectedTab.childNodes[0].childNodes[0].childNodes[0].innerHTML;
             getcollectionReport(sender.get_activeTabIndex(), 1);
         }
         function getcollectionReport(activeTabIndex, type) {
             var PageUrl = "";
             if (activeTabIndex == 0) {
                 PageUrl = "PatientInfo.aspx";
             }
             else if (activeTabIndex == 1) {
                 PageUrl = "BusinessReportClient.aspx";
             }
            
             else if (activeTabIndex == 2) {
                 PageUrl = "BusinessReportDoctor.aspx";
             }
             else if (activeTabIndex == 3) {
                 PageUrl = "BusinessReportDept.aspx";
             }
             else if (activeTabIndex == 4) {
                 PageUrl = "RefundReport.aspx";
             }
             //else if (activeTabIndex == 4) {
             //    PageUrl = "BusinessReportItemWise.aspx";
             //}
             else if (activeTabIndex == 5) {
                 PageUrl = "UserBy_Discount_Report.aspx";
             }
             //else if (activeTabIndex == 6) {
             //    PageUrl = "ServiceWiseCollectionReport.aspx";
             //}
             //else if (activeTabIndex == 7) {
             //    PageUrl = "../BillWiseCollectionReport.aspx";
             //}
        

             else if (activeTabIndex == 6) {
                 PageUrl = "BusinessReportCumulative.aspx";
             }
           
             else if (activeTabIndex == 7) {
                 PageUrl = "RefundReport.aspx";
             }
             //else if (activeTabIndex == 9) {
             //    PageUrl = "BusinessReportUser.aspx";
             //}

             //else if (activeTabIndex == 6) {
             //    PageUrl = "RefundReport.aspx";
             //}


             //else if (activeTabIndex == 4) {
                // PageUrl = "RefundReport.aspx";
             //}


             //else if (activeTabIndex == 11) {
             //    PageUrl = "MISExcel.aspx";
             //}
             //else if (activeTabIndex == 12) {
             //    PageUrl = "PanelWiseBussinessReport.aspx";
             //}
             document.getElementById("iframeReport").src = PageUrl;
             document.getElementById("iframeReport").style.width = "100%";
             document.getElementById("iframeReport").style.height = "100%";
             document.getElementById("iframeReport").style.display = "";
         }

    </script>      
       <div id="Pbody_box_inventory">  
        <Ajax:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Business Report Report</b>
            <br />
         
        </div>  
         <div class="POuter_Box_Inventory" >
            <div class="row" >
                <div class="col-md-24">                    
                <cc1:TabContainer ID="TabContainer1" runat="server" Width="99%"    ActiveTabIndex="0" Font-Size="Larger"   OnClientActiveTabChanged="clientActiveTabChanged" >
                              <cc1:TabPanel runat="server" HeaderText="Patient  Info" ID="tabPanelPatientinfo" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
                         <cc1:TabPanel runat="server" HeaderText="Client Wise Business" ID="tabPanel4" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
                 
                           <cc1:TabPanel runat="server" HeaderText="Doctor Wise Business" ID="tabPanel5" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
                        <cc1:TabPanel runat="server" HeaderText="Department Wise Business" ID="tabPanel7" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
                     <cc1:TabPanel runat="server" HeaderText="Refund Report" ID="tabPanel1" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
                    <cc1:TabPanel runat="server" HeaderText="Discount  Report" ID="tabPanel8" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
<%--                    <cc1:TabPanel runat="server" HeaderText="Item Wise Business" ID="tabPanel8" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel> --%>
                   
                 <%--   <cc1:TabPanel runat="server" HeaderText="Service wise collection" ID="tabPanel2" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
                    <cc1:TabPanel runat="server" HeaderText="Bill wise collection" ID="tabPanel3" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>--%>
		    <cc1:TabPanel runat="server" HeaderText="Business Cumulative Report" ID="tabPanel6" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
		<%--
		  <cc1:TabPanel runat="server" HeaderText="User Wise Business" ID="tabPanel9" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>--%>
                    		  
                      <%--<cc1:TabPanel runat="server" HeaderText="MIS(Excel) Graph" ID="tabPanel11" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
                <cc1:TabPanel runat="server" HeaderText="Panel Wise Bussiness" ID="tabPane18" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>--%>
            </cc1:TabContainer>
                   
                    </div>
                </div>
             <div class="row">
                 <div class="col-md-24">
                     <iframe id="iframeReport" name="iframeReport" src="" style="position: fixed; top: 120px;
                         left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"> </iframe>
                 </div>
             </div>
            </div>
           </div>
</asp:Content>

