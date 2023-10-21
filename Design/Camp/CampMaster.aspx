<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CampMaster.aspx.cs" Inherits="Design_Camp_CampMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .ajax__tab_xp .ajax__tab_header .ajax__tab_tab {
            height: 24px !important;
        }
    </style>  
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Camp Creation Master</b>
            <br />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <cc1:TabContainer ID="tabContainer" runat="server" Width="99%" ActiveTabIndex="0" Font-Size="Larger" OnClientActiveTabChanged="clientActiveTabChanged">
                        <cc1:TabPanel runat="server" HeaderText="CampNameCreationMaster" ID="tabPanelPatientinfo" Width="99%" BackColor="#cccccc" Font-Size="Larger">
                        </cc1:TabPanel>
                        <cc1:TabPanel runat="server" HeaderText="FreeCampTestMaster" ID="tabSetOf20TestMaster" Width="99%" BackColor="#cccccc" Font-Size="Larger">
                        </cc1:TabPanel>
                        
                    </cc1:TabContainer>

                </div>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <iframe id="iframeReport" name="iframeReport" src="" style="position: fixed; top: 93px; left: 0px; background-color: #FFFFFF; display: none;"
                        frameborder="0" enableviewstate="true"></iframe>
                </div>
            </div>
        </div>
    </div>
     <script type="text/javascript">
         jQuery(function () {
             getCamp(0, 1);
         });
         function clientActiveTabChanged(sender, args) {
             var selectedTab = sender.get_tabs()[sender.get_activeTabIndex()]._tab;
             var tabText = selectedTab.childNodes[0].childNodes[0].childNodes[0].innerHTML;
             getCamp(sender.get_activeTabIndex(), 1);
         }
         function getCamp(activeTabIndex, type) {
             var PageUrl = "";
             switch (activeTabIndex) {
                 case 0:
                     {
                         PageUrl = "CampNameCreationMaster.aspx";
                         break;
                     }
                 case 1:
                     {
                         PageUrl = "FreeCampTestMaster.aspx";
                         break;
                     }
                 
             }
             document.getElementById("iframeReport").src = PageUrl;
             document.getElementById("iframeReport").style.width = "100%";
             document.getElementById("iframeReport").style.height = "100%";
             document.getElementById("iframeReport").style.display = "";
         }
    </script>
</asp:Content>


