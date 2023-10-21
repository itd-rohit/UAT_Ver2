<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="LabReport.aspx.cs" Inherits="Design_Reports_LabReport_LabReport" %>

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
                 PageUrl = "LabInvestigationAnalysisReport.aspx";
             }
             else if (activeTabIndex == 1) {
                 PageUrl = "LabObservationAnalysisReport.aspx";
             }
             else if (activeTabIndex == 2) {
                 PageUrl = "InvCountProcessing.aspx";
             }
             else if (activeTabIndex == 3) {
                 PageUrl = "InfectionControlReportNew.aspx";
             }
             else if (activeTabIndex == 4) {
                 PageUrl = "QualityIndicatorDelayTAT.aspx";
             }
             else if (activeTabIndex == 5) {
                 PageUrl = "QualityIndicatorDelayTATDRL.aspx";
             }
            
             else if (activeTabIndex == 6) {
                 PageUrl = "OutSourceLabSampleCollectionReport.aspx";
             }
             else if (activeTabIndex == 7) {
                 PageUrl = "HighVolumeReport.aspx";
             }
             else if (activeTabIndex == 8) {
                 PageUrl = "SampleRejectionReport.aspx";
             }
             else if (activeTabIndex == 9) {
                 PageUrl = "LabAbnormalReport.aspx";
             }
             else if (activeTabIndex == 10) {
                 PageUrl = "MachineReading.aspx";
             }
             else if (activeTabIndex == 11) {
                 PageUrl = "Graph.aspx";
             }
             else if (activeTabIndex == 12) {
                 PageUrl = "TATReport.aspx";
             }
             else if (activeTabIndex == 13) {
                 PageUrl = "PendingList.aspx";
             }
             else if (activeTabIndex == 14) {
                 PageUrl = "ReRunTestReport.aspx";
             }
             else if (activeTabIndex == 15) {
                 PageUrl = "DeptWisePendingList.aspx";
             }
             else if (activeTabIndex == 16) {
                 PageUrl = "TATReportGraph.aspx";
             }
			 else if (activeTabIndex == 17) {
                 PageUrl = "PatientReportRegister.aspx";
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
            <b>Lab Report</b>
            <br />
         
        </div>  
         <div class="POuter_Box_Inventory" >
            <div class="row" >
                <div class="col-md-24">                    
                <cc1:TabContainer ID="TabContainer1"  runat="server"   ActiveTabIndex="0" Font-Size="Larger"   OnClientActiveTabChanged="clientActiveTabChanged" >                                                       
                     <cc1:TabPanel runat="server" HeaderText="Investigation Analysis" ID="tabPanelItem" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     <cc1:TabPanel runat="server" HeaderText="LabObservation Analysis" ID="tabDepartment" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     <cc1:TabPanel runat="server" HeaderText="Test Count" ID="TabPanelCentre" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     <cc1:TabPanel runat="server" HeaderText="Infection Control" ID="TabPanelDoctor" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                    <cc1:TabPanel runat="server" HeaderText="1.Quality Indicator" ID="TabPanelReceipt" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     <cc1:TabPanel runat="server" HeaderText="2.Quality Indicator" ID="TabPanel5" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     
                   <cc1:TabPanel runat="server" HeaderText="OutSource Lab" ID="TabPanel1" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                    <cc1:TabPanel runat="server" HeaderText="High Volume" ID="TabPanel2" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                       <cc1:TabPanel runat="server" HeaderText="Sample Rejection" ID="TabPanel3" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                    <cc1:TabPanel runat="server" HeaderText="Abnormal Value" ID="TabPanel4" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     <cc1:TabPanel runat="server" HeaderText="MachineReading" ID="TabPanelSettlement" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                          <cc1:TabPanel runat="server" HeaderText="DeshBoard(Graph)" ID="TabPanel6" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                      <cc1:TabPanel runat="server" HeaderText="TAT Report" ID="TabPanel7" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                      <cc1:TabPanel runat="server" HeaderText="Pending List" ID="TabPanel8" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                    <cc1:TabPanel runat="server" HeaderText="ReRun Test" ID="TabPanel9" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                     <cc1:TabPanel runat="server" HeaderText="Technician Pending List" ID="TabPanel10" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
                      <cc1:TabPanel runat="server" HeaderText="TAT Graph" ID="TabPanel11" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
				<cc1:TabPanel runat="server" HeaderText="PatientReportRegister" ID="TabPanel12" BackColor="#cccccc" Width="99%" Font-Size="Larger"   >                    
                </cc1:TabPanel>
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

