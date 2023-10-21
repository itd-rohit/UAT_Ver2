<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CollectionReport.aspx.cs" Inherits="Design_OPD_CollectionReport" MasterPageFile="~/Design/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">           
     
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
                 PageUrl="CollectionReportNew.aspx";
             }
             else if (activeTabIndex == 1) {
                 PageUrl = "CollectionReportClient.aspx";                 
             }
             //else if (activeTabIndex == 2) {
             //    PageUrl = "CollectionReportItemWise.aspx";
             //}
             else if (activeTabIndex == 2) {
                 PageUrl = "CollectionReportDept.aspx";
             }
             //else if (activeTabIndex == 4) {
             //    PageUrl = "CollectionReportCentre.aspx";
             //}
             //else if (activeTabIndex == 5) {
             //    PageUrl = "CollectionReportDoctor.aspx";
             //}
             //else if (activeTabIndex == 6) {
             //    PageUrl = "CollectionReportReceiptWise.aspx";
             //}
             //else if (activeTabIndex == 7) {
             //    PageUrl = "SettlementReport.aspx";
             //}
             else if (activeTabIndex == 3) {
                 PageUrl = "OutStandingReport.aspx";
             }
             else if (activeTabIndex == 4) {
                 PageUrl = "MobileWallletCollectionReport.aspx";
             }
             else if (activeTabIndex == 5) {
                 PageUrl = "SSHReport.aspx";
             }
             document.getElementById("iframeReport").src = PageUrl;
             document.getElementById("iframeReport").style.width = "100%";
             document.getElementById("iframeReport").style.height = "100%";
             document.getElementById("iframeReport").style.display = "";
         }

    </script>
    
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Collection Report</b>
            <br />
         
        </div>  
         <div class="POuter_Box_Inventory" >
            <div class="row">
                <div class="col-md-24">                    
                <cc1:TabContainer ID="TabContainer1" runat="server" Width="99%"    ActiveTabIndex="0" Font-Size="Larger"   OnClientActiveTabChanged="clientActiveTabChanged" >
                              <cc1:TabPanel runat="server" HeaderText="User Wise" ID="tabPanelUser" Width="99%" BackColor="#cccccc" Font-Size="Larger"   >                 
                </cc1:TabPanel>
                               <cc1:TabPanel runat="server" HeaderText="Client Wise" ID="tabPanelClient" BackColor="#cccccc" Width="99%" Font-Size="Larger"  >                  
                </cc1:TabPanel>
<%--                     <cc1:TabPanel runat="server" HeaderText="ItemWise" ID="tabPanelItem" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>--%>
                     <cc1:TabPanel runat="server" HeaderText="Department Wise" ID="tabDepartment" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                    <%-- <cc1:TabPanel runat="server" HeaderText="Centre Wise" ID="TabPanelCentre" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     <cc1:TabPanel runat="server" HeaderText="Doctor Wise" ID="TabPanelDoctor" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                    <cc1:TabPanel runat="server" HeaderText="Receipt Wise" ID="TabPanelReceipt" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                      <cc1:TabPanel runat="server" HeaderText="Settlement Report" ID="TabPanelSettlement" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>--%>
                    <cc1:TabPanel runat="server" HeaderText="OutStanding Report" ID="TabPanelOutstanding" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                      <cc1:TabPanel runat="server" HeaderText="Mobile Wallet Report" ID="TabPanel1" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     <%-- <cc1:TabPanel runat="server" HeaderText="SSH Report" ID="TabPanel2" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>--%>
            </cc1:TabContainer>
                    </div>
                </div>
             <div class="row">
                 <div class="col-md-24">
                     <iframe id="iframeReport" name="iframeReport" src="" style="position: fixed; top: 93px;
                         left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"> </iframe>
                 </div>
             </div>
            </div>                                                                            
</asp:Content>
