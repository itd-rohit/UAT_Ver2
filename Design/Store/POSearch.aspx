<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="POSearch.aspx.cs" Inherits="Design_Store_POSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
     <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryStore") %>
         <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
     <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            <Services>
                <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
                <Ajax:ServiceReference Path="Services/StoreCommonServices.asmx" />
            </Services>
        </Ajax:ScriptManager>
     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

     <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Purchase Order Search</b>
             <asp:Label ID="lblMessage" runat="server" CssClass="ItDoseLblError"  />
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="display: none;" id="hideDetail" >
            <div  id="divSearch">
                <div class="Purchaseheader">
                      Search Option
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                           <div class="col-md-3 ">
                              <label class="pull-left ">City:   </label>
                                <b class="pull-right">:</b>
                               </div>
                            <div class="col-md-3 ">
                                 <asp:TextBox ID="txtCity" runat="server" ></asp:TextBox>
                            </div>
                            <div class="col-md-3 ">
                               </div>
                            <div class="col-md-3 ">
                                 <asp:ListBox ID="lstCity" CssClass="multiselect " SelectionMode="Multiple"  runat="server"></asp:ListBox>
                            </div>
                             <div class="col-md-3 ">
                             <input style="font-weight: bold;" type="button" value="Back" class="ItDoseButton" onclick="hideSearch();" />
                             </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
          <div class="POuter_Box_Inventory"  id="Div1" >
            <div  id="div2">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                           <div class="col-md-3 ">
                                <label class="pull-left ">From Date:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4 ">
                                   <asp:TextBox ID="txtFromDate" runat="server" />
                                 <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                 <input id="Button2" class="ItDoseButton" onclick="showhide();" style="font-weight: bold;display:none;" type="button" value="More Filter" />
                              </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">To Date:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4 ">
                                    <asp:TextBox ID="txtToDate" runat="server"  />
                                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                              </div>
                              <div class="col-md-3 ">
                                <label class="pull-left ">Vendor:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-6 ">
                                   <asp:ListBox ID="lstVendor" runat="server" CssClass="multiselect " SelectionMode="Multiple" ></asp:ListBox>
                              </div>
                            </div>
                          <div class="row">
                           <div class="col-md-3 ">
                                <label class="pull-left ">PO No:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4 ">
                                   <asp:TextBox ID="txtPoNo" runat="server" MaxLength="30" />
                                  </div>
                               <div class="col-md-3 ">
                                <label class="pull-left ">Order Type:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-2 ">
                                    <asp:DropDownList ID="ddlOrderType" runat="server"  >
                             <asp:ListItem Value="0">Select</asp:ListItem>
                             <asp:ListItem Value="1">Normal</asp:ListItem>
                             <asp:ListItem Value="2">Urgent</asp:ListItem>                                           
                             </asp:DropDownList>
                                  </div>
                              <div class="col-md-2 ">
                                  <asp:DropDownList ID="ddlaction" runat="server" >
                              <asp:ListItem Value="">Action Type</asp:ListItem>
                              <asp:ListItem Value="Maker">Prepared</asp:ListItem>
                                <asp:ListItem Value="Checker">Validate</asp:ListItem>
                                <asp:ListItem Value="Approval">Approved</asp:ListItem>
                          </asp:DropDownList>
                              </div>
                                 <div class="col-md-3 ">
                                <label class="pull-left ">Maker Name:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-6 ">
                                  <asp:DropDownList ID="ddlusername" runat="server" class="ddlusername chosen-select chosen-container" ></asp:DropDownList>
                                  </div>
                            </div>
                        </div>
                    </div>
                </div>
             </div>

            <div class="POuter_Box_Inventory"  id="Div3" >
            <div  id="div4">
                <div class="Purchaseheader">
                      Location Filter
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                         <div class="col-md-3 ">
                                <label class="pull-left ">Centre Type:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                  <asp:ListBox ID="lstCentreType" CssClass="multiselect " SelectionMode="Multiple"  runat="server" onchange="bindlocation()"></asp:ListBox>
                                  </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Zone:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                  <asp:ListBox ID="lstZone" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                                  </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">State:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-6">
                                  <asp:ListBox ID="lstState" CssClass="multiselect " SelectionMode="Multiple" runat="server" onchange="bindlocation()"></asp:ListBox>
                                  </div>
                            </div>
                        <div  class="row">
                              <div class="col-md-3 ">
                                <label class="pull-left ">Location:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                 <asp:ListBox ID="lstlocation" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
                                  </div>
                            </div>
                        </div>
                        </div>
                   <div class="row" style="display:none">
                    <div class="col-md-24">
                        <div class="row">
                         <div class="col-md-3 ">
                                <label class="pull-left ">Category Type:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                  <asp:ListBox ID="lstCategoryType" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                                  </div>
                            <div class="col-md-3 ">
                                <label class="pull-left ">Manufacture:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                   <asp:ListBox ID="lstManufacture" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                                  </div>
                            </div>
                        <div  class="row" style="display:none">
                              <div class="col-md-3 ">
                                <label class="pull-left ">Sub Category Type:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                  <asp:ListBox ID="lstSubCategory" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                                  </div>
                             <div class="col-md-3 ">
                                <label class="pull-left ">Machine:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                   <asp:ListBox ID="lstMachine" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                                  </div>
                            </div>
                            <div  class="row" style="display:none">
                              <div class="col-md-3 ">
                                <label class="pull-left ">Item Type:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                  <asp:ListBox ID="lstItemType" CssClass="multiselect " SelectionMode="Multiple" runat="server"></asp:ListBox>
                                  </div>
                             <div class="col-md-3 ">
                                <label class="pull-left ">Item:   </label>
                                <b class="pull-right">:</b>
                               </div>
                              <div class="col-md-4">
                                   <asp:ListBox ID="lstItemGroup" runat="server" CssClass="multiselect " SelectionMode="Multiple" ></asp:ListBox>
                                  </div>
                            </div>
                         <div  class="row" style="display:none">
                              <div class="col-md-24 ">
                         <input id="btnMoreFilter" class="ItDoseButton" onclick="showSearch();" style="font-weight: bold;display:none;" type="button" value="More Filter" />
                        </div>
                             </div>
                              </div>
                        </div>
                    </div>
                </div>
           <div class="POuter_Box_Inventory" style="text-align: center;"  id="Div5" >
            <div  id="div6">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                         <div class="col-md-24 ">
                               <input type="button" id="btnSearch" value="Search" class="searchbutton" onclick="searchData('0')" /><span id="bal"></span>
                             </div>
                            </div>
                        </div>
                    </div>
                </div>
               </div>
          <div class="POuter_Box_Inventory" style="text-align: center;"  id="Div8" >
             <div class="content" style="display:none;position:absolute;z-index: 10000;" id="myDetail">
               <table style="width:100%">
                   <tr>
                      <td>
                          <table style="width:99%;border-collapse: collapse" id="Table1"   cellpadding="1" rules="all" border="1">

                              <tr style="height:30px;font-weight:bold;background-color:#965720;color:white;">
                                  <td>S.No.</td>
                                  <td>Item Name</td>
                                  <td>Manufacture</td>
                                  <td>Machine</td>
                                  <td>OrderedQty</td>
                                  <td>UnitPrice</td>
                                  <td>DiscPer</td>
                                  <td>NetAmount</td>
                              </tr>
                          </table>
                      </td>
                   </tr>
                   
               </table>
                
            </div>    
              </div>
             <div class="POuter_Box_Inventory" style="text-align: center;"  id="Div7" >
                  <table  style="margin-left:120px;width:80%"">
                        <tr style="height:28px;">
                               <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #FFFFFF;"  onclick="searchData('1')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Open</td>
                                 <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;"   onclick="searchData('2')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Approved</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #3399FF;"   onclick="searchData('3')"">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Reject</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#f5b738;"   onclick="searchData('4')"">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                PO Closed By User</td>
                            
                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#CC99FF;"   onclick="searchData('5')"">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                PO Closed By System</td>
                                  <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#00FFFF;"   onclick="searchData('6')"">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Partial GRN</td>
                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #B0C4DE;"   onclick="searchData('7')"">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                           
                                <td>
                                Full GRN</td>
                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #44A3AA;"   onclick="searchData('8')"">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                           
                                <td>
                                Auto Mail</td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #FFC0CB;"   onclick="searchData('9')"">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                           
                                <td>
                                Auto Mail Fail</td>
                           
                        </tr>
                    </table>
              </div>
           <div class="POuter_Box_Inventory" >  
               <div style="height:320px;overflow:scroll;width:99%">
                <table id="tbl_POSearch" class="GridViewStyle" cellpadding="1" rules="all" border="1" style="border-collapse: collapse;width:99%"> 
                   
                </table>  
              </div>   
             </div>
          <asp:Button ID="Button1" runat="server" style="display:none;"/>
        <cc1:ModalPopupExtender ID="modelMail" runat="server" CancelControlID="Button4" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlMail">
    </cc1:ModalPopupExtender> 

     <asp:Panel ID="Panel1" runat="server" BackColor="#EAF3FD" BorderStyle="None" width="400px" style="display:none;" >
         <div class="Purchaseheader">Vendor Comment</div>
          <br />
         <span id="mmcomment" style="font-weight:bold;padding-left:10px;background-color:white;"></span>
         <br />
          <br />
      <center>  <asp:Button ID="Button51" runat="server" Text="Close" CssClass="resetbutton" /></center>
         </asp:Panel>
     <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="Button51" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1">
    </cc1:ModalPopupExtender> 


           <asp:Panel ID="pnlMail" runat="server" BackColor="#EAF3FD" BorderStyle="None" width="500px" style="display:none;" >
        
        <div class="POuter_Box_Inventory" style="width:100%">         
            <div  class="Purchaseheader">        <strong>Purchase Order Mail Sending</strong><br /></div>
               <table style="width:100%;border-collapse:collapse">
                   <tr>
                       <td  style="text-align:right">Vendor :&nbsp;</td>
                       <td style="text-align:left" >
                           <asp:Label ID="lblVenderName" runat="server" Font-Bold="true" />
                       </td>
                   </tr>

                    <tr>
                       <td style="text-align:right">PO No. :&nbsp;</td>
                       <td style="text-align:left">
                            <asp:Label ID="lblPONumber" runat="server"  Font-Bold="true" />
                            
                       </td>
                   </tr>
                   <tr>
                       <td style="text-align:right">Mail :&nbsp;</td>
                       <td style="text-align:left"><asp:TextBox ID="txtVendoeMailID" runat="server"  Width="380px" /><span style="color:red">*</span>
                         
                       </td>
                   </tr>
                   <tr>
                       <td style="text-align:right">CC :&nbsp;</td>
                       <td style="text-align:left"><asp:TextBox ID="txtCC" runat="server" Width="380px" ></asp:TextBox><span style="color:red">*</span></td>
                   </tr>
                   <tr>
                       <td style="text-align:right">Bcc :&nbsp;</td>
                       <td style="text-align:left"><asp:TextBox ID="txtBCC" runat="server" Width="380px" ></asp:TextBox></td>
                   </tr>
                    <tr>
                       <td colspan="2" style="text-align:center"><input type="button" id="btnVendorSendMail" value="Send Mail" onclick="sendMail()" class="savebutton" />
                            &nbsp;<asp:Button ID="Button4" runat="server" Text="Close" CssClass="resetbutton" /></td>
                   </tr>
               </table>                           
        </div>        
    </asp:Panel>
         <cc1:ModalPopupExtender ID="modelClose" runat="server" CancelControlID="btnPopUpClose" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlClose"></cc1:ModalPopupExtender>

                <asp:Panel ID="pnlClose" runat="server" BackColor="#EAF3FD" BorderStyle="None" width="420px" style="display:none;" >         
        <div class="POuter_Box_Inventory" style="width:100%">    
             <div  class="Purchaseheader">         
                <strong>Purchase Order Close</strong><br /></div>
              <table style="width:100%;border-collapse:collapse">

                  <tr>
                      <td colspan="2" style="font-weight:bold;color:red;">
                          PI will Also Close For This PO
                      </td>
                  </tr>
                  <tr>
                      <td style="text-align:right">
                          PO No. :&nbsp;
                      </td>                     
                      <td style="text-align:left" >
                          <asp:Label ID="lblClosePONo" runat="server" Font-Bold="true"></asp:Label>
                           <asp:Label ID="lblIndentNo" runat="server" style="display:none"></asp:Label>
                          </td>
                  </tr>
                   <tr>
                       <td style="text-align:right">Close Reason :&nbsp;</td>
                       <td style="text-align:left" ><asp:TextBox ID="txtPOCloseReason" runat="server" TextMode="MultiLine" Width="250px" MaxLength="140" />
                           <asp:Label ID="lblPurchaseOrderID" runat="server" style="display:none;" />
                       </td>
                   </tr>
                    <tr>
                       <td colspan="2" style="text-align:center"><input type="button" id="btnPOClose" value="Save" onclick="closePO()" class="savebutton" />
                            &nbsp;<asp:Button ID="btnPopUpClose" runat="server" Text="Close" CssClass="resetbutton" /></td>
                   </tr>
               </table>                        
        </div>     
    </asp:Panel>
         <cc1:ModalPopupExtender ID="modalEditPO" runat="server" CancelControlID="btnPopupEdit" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlEditPO"></cc1:ModalPopupExtender>
              <asp:Panel ID="pnlEditPO" runat="server" BackColor="#EAF3FD" BorderStyle="None" width="980px" style="display:none;height:400px;overflow:scroll;">        
        <div class="POuter_Box_Inventory" style="width:98%"> 
             <div  class="Purchaseheader">        
                <strong>Purchase Order Edit</strong><br /></div>
            
                PO No. :&nbsp; <asp:Label ID="lblPONo" runat="server" Font-Bold="True"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblErrorPOEdit" CssClass="ItDoseLblError" runat="server" ></asp:Label>
               <table style="width:98%" id="tblEditPO">                  
                   <tr id="header"  style="font-weight:bold;background-color:#965720;color:white;" >
                      <td>S.No.</td>
                      <td>Item Name</td>                                         
                      <td>Machine Name </td> 
                      <td>Mf. Name</td> 
                      <td>PackSize</td> 
                      <td>CatalogNo.</td>
                      <td>Purchase Unit</td>   
                      <td>Qty.</td>
                      <td>UnitPrice</td>                     
                      <td>Amount</td>
                      <td>GRN Qty.</td>
                       </tr>                     
               </table>             
                <div style="text-align:center;">
                    <input type="button" value="Save" onclick="saveEditPO()" id="btnSaveEditPO" class="savebutton" />
                            &nbsp;<asp:Button ID="btnPopupEdit" runat="server" Text="Close" CssClass="resetbutton" />              
            </div>
        </div>       
    </asp:Panel>    
     <cc1:ModalPopupExtender ID="modelRejectPO" runat="server" CancelControlID="btnReject" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlReject">
    </cc1:ModalPopupExtender>

                  <asp:Panel ID="pnlReject" runat="server" BackColor="#EAF3FD" BorderStyle="None" width="1020px" style="display:none;height:400px;overflow:scroll;">        
        <div class="POuter_Box_Inventory" style="width:98%"> 
             <div  class="Purchaseheader">        
                <strong>Purchase Order Rejection</strong><br /></div>
             <span style="font-weight:bold;color:red;"> Rejected Item will Show on PI to PO Screen
                        
                      </span>

          <%--  <span style="font-weight:bold;color:red;font-style:italic;font-size:10px;float:right;">
                Single Item Purchase Order Can't Reject from Here Please Close PO&nbsp;&nbsp;
            </span>--%>
            <br />
                PO No. :&nbsp; <asp:Label ID="lblRejectPO" runat="server" Font-Bold="True"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <span  style="background-color:#90EE90;font-weight:bold" >&nbsp;&nbsp;&nbsp;&nbsp;Free&nbsp;Test&nbsp;&nbsp;&nbsp;&nbsp;</span>
            <asp:Label ID="lblRejectPOID" CssClass="ItDoseLblError" runat="server" style="display:none" ></asp:Label>
               <table style="width:98%" id="tblRejectPO">                  
                   <tr id="RejectHeader"  style="font-weight:bold;background-color:#965720;color:white;" >
                      <td style="width:20px">S.No.</td>
                      <td>Item Name</td>                                         
                      <td>Machine Name </td> 
                      <td>Mf. Name</td> 
                      <td>PackSize</td> 
                      <td>CatalogNo.</td>
                      <td>Purchase Unit</td>   
                      <td>Qty.</td>
                      <td>UnitPrice</td>                     
                      <td>Amount</td>
                      <td>GRN Qty.</td>
                       </tr>                     
               </table>             
                <div style="text-align:center;">
                    <table style="width:100%;border-collapse:collapse">
                        <tr>
                            <td style="width:50%;text-align:left" class="required">
                                Reject Reason :&nbsp;<asp:TextBox ID="txtPORejectReason" runat="server"  MaxLength="50" Width="280px" /><span style="color:red">*</span>
                            </td>
                            <td style="width:50%;text-align:left">
                                 <input type="button" value="Reject" onclick="saveRejectPO()" id="btnRejectPO" class="savebutton" />
                            &nbsp;<asp:Button ID="btnReject" runat="server" Text="Close" CssClass="resetbutton" />   
                            </td>
                        </tr>
                    </table>                                               
            </div>
        </div>       
    </asp:Panel>

         <asp:Panel ID="pnlReject1" runat="server" BackColor="#EAF3FD" BorderStyle="None" width="400px" style="display:none;" >       
        <div class="POuter_Box_Inventory" style="width:100%">
             <div  class="Purchaseheader">    
                <strong>Purchase Order Rejection</strong><br /></div>
               <table style="width:100%;">
                   <tr>
                       <td>Reject Reason :&nbsp;</td>
                       <td style="text-align:left">
                       <asp:Label ID="lblRejectPONo" runat="server"  Font-Bold="true" />
                            <asp:Label ID="lblRejectPurchaseOrderID" runat="server"  style="display:none" />
                       </td>
                   </tr>
                   <tr>
                       <td>Reject Reason :&nbsp;</td>
                       <td style="text-align:left"><asp:TextBox ID="txtPORejectReason1" runat="server" TextMode="MultiLine" Width="250px" />
                           
                       </td>
                   </tr>
                    <tr>
                       <td colspan="2"><input type="button" id="btnrejectPO1" value="Reject" onclick="rejectPO()" class="ItDoseButton" />
                            &nbsp;<asp:Button ID="btnCancelReject" runat="server" Text="Close" CssClass="ItDoseButton" /></td>
                   </tr>
               </table>                       
        </div>        
    </asp:Panel>
 </div>


       

     <%--  All Bind --%>
    <script type="text/javascript">
        var approve = '<%=approve %>';
        var edit = '<%=edit %>';
        var limitperpo = '<%=limitperpo %>';
        var closeAfterapp = '<%=closeAfterapp %>';
        var editAfterapp = '<%=editAfterapp%>'; var rejectAfterAppBeforeClose = '<%=rejectAfterAppBeforeClose%>';
        var poeditfull = '<%=poeditfull%>';

        jQuery(function () {
            jQuery('[id*=lstCentreType],[id*=lstCategoryType],[id*=lstManufacture],[id*=lstZone],[id*=lstSubCategory],[id*=lstMachine],[id*=lstState],[id*=lstItemType],[id*=lstItemGroup],[id*=lstCity],[id*=lstVendor]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id=lstlocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindcentertype();
            bindZone();
            bindVendor();
        });
        function bindcentertype() {

            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindTypeLoad', {}, function (response) {
                var $ddlCtype = $('#<%=lstCentreType.ClientID%>');
                $ddlCtype.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'id', textField: 'type1', controlID: $("#lstCentreType"), isClearControl: '' });
            });
        }

        function bindZone() {

            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                var $ddlZone = $('#<%=lstZone.ClientID%>');
                    $ddlZone.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZone"), isClearControl: '' });
                });
        }

        jQuery('#lstZone').on('change', function () {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            var BusinessZoneID = $(this).val().toString();

            bindState(BusinessZoneID);
        });
        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
            jQuery('#lstState').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    var $ddlState = $('#<%=lstState.ClientID%>');
                    $ddlState.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstState"), isClearControl: '' });
                });
            }
        }
        function bindCategoryType() {
            jQuery('#<%=lstCategoryType.ClientID%> option').remove();
            jQuery('#lstCategoryType').multipleSelect("refresh");
            serverCall('Services/StoreCommonServices.asmx/bindcategory', {}, function (response) {
                var $ddlCat = $('#<%=lstCategoryType.ClientID%>');
                $ddlCat.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', controlID: $("#lstCategoryType"), isClearControl: '' });
            });
        }

        jQuery('#lstCategoryType').on('change', function () {
            jQuery('#<%=lstItemType.ClientID%> option').remove();
            jQuery('#lstSubCategory').multipleSelect("refresh");
            var CategoryTypeID = $(this).val().toString();
            bindSubCategory(CategoryTypeID);
        });

        function bindSubCategory(CategoryTypeID) {
            if (CategoryTypeID != "") {
                jQuery('#<%=lstSubCategory.ClientID%> option').remove();
                jQuery('#lstSubCategory').multipleSelect("refresh");
                serverCall('Services/StoreCommonServices.asmx/bindsubcategory', { categoryid: CategoryTypeID }, function (response) {
                    var $ddlSCat = $('#<%=lstSubCategory.ClientID%>');
                    $ddlSCat.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', controlID: $("#lstSubCategory"), isClearControl: '' });
                });
            }

        }

        jQuery('#lstSubCategory').on('change', function () {
        jQuery('#<%=lstItemType.ClientID%> option').remove();
        jQuery('#lstItemType').multipleSelect("refresh");
        var SubCategoryID = $(this).val().toString();

        bindItemType(SubCategoryID);
        });


        function bindItemType(SubCategoryID) {
            if (SubCategoryID != "") {
                jQuery('#<%=lstItemType.ClientID%> option').remove();
                jQuery('#lstItemType').multipleSelect("refresh");
                serverCall('Services/StoreCommonServices.asmx/binditemtype', { subcategoryid: SubCategoryID }, function (response) {
                    var $ddlItemType = $('#<%=lstItemType.ClientID%>');
                    $ddlItemType.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', controlID: $("#lstItemType"), isClearControl: '' });
                });
            }
        }

        jQuery('#lstItemType').on('change', function () {
            jQuery('#<%=lstItemGroup.ClientID%> option').remove();
            jQuery('#lstItemGroup').multipleSelect("refresh");
            var ItemTypeID = $(this).val().toString();
            bindItemGroup(ItemTypeID);
        });


        function bindItemGroup(ItemTypeID) {

            if (ItemTypeID != "") {
                jQuery('#<%=lstItemGroup.ClientID%> option').remove();
                jQuery('#lstItemGroup').multipleSelect("refresh");
                serverCall('BudgetIndent.aspx/bindItemGroup', { SubcategoryID: ItemTypeID }, function (response) {
                    var $ddlItemG = $('#<%=lstItemGroup.ClientID%>');
                    $ddlItemG.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemIDGroup', textField: 'ItemNameGroup', controlID: $("#lstItemGroup"), isClearControl: '' });
                });
            }
        }

        function bindManufacture() {
            jQuery('#<%=lstManufacture.ClientID%> option').remove();
            jQuery('#lstManufacture').multipleSelect("refresh");

            serverCall('Services/StoreCommonServices.asmx/bindManufacture', {}, function (response) {
                var $ddlMan = $('#<%=lstManufacture.ClientID%>');
                $ddlMan.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', controlID: $("#lstManufacture"), isClearControl: '' });
            });

        }

        function bindMachine() {
            jQuery('#<%=lstMachine.ClientID%> option').remove();
            jQuery('#lstMachine').multipleSelect("refresh");
            serverCall('Services/StoreCommonServices.asmx/bindmachine', {}, function (response) {
                var $ddlMac = $('#<%=lstMachine.ClientID%>');
                $ddlMac.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', controlID: $("#lstMachine"), isClearControl: '' });
            });

        }
    
        function bindVendor() {
            jQuery('#<%=lstVendor.ClientID%> option').remove();
            jQuery('#lstVendor').multipleSelect("refresh");
            serverCall('Services/StoreCommonServices.asmx/bindsupplier', {}, function (response) {
                var $ddlven = $('#<%=lstVendor.ClientID%>');
                $ddlven.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'supplierid', textField: 'suppliername', controlID: $("#lstVendor"), isClearControl: '' });
            });
        }
    </script>

      <%--  City Search --%>
     <script type="text/javascript">
         function showmsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', '#04b076');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         function showerrormsg(msg) {
             $('#msgField').html('');
             $('#msgField').append(msg);
             $(".alert").css('background-color', 'red');
             $(".alert").removeClass("in").show();
             $(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
         jQuery(function () {


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


             jQuery('#txtCity').bind("keydown", function (event) {
                 if (event.keyCode === jQuery.ui.keyCode.TAB &&
                     jQuery(this).autocomplete("instance").menu.active) {
                     event.preventDefault();
                 }
                 if (jQuery('#lstState').multipleSelect("getSelects").join() == "") {
                     toast("Error", "Please Select State..!", "");
                     jQuery('#lstState').focus();
                     jQuery('#txtCity').val('');
                     return;
                 }
             })
                   .autocomplete({
                       autoFocus: true,
                       source: function (request, response) {
                           jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=bindCityWithState", {
                               StateID: jQuery('#lstState').multipleSelect("getSelects").join(),
                               CityName: request.term
                           }, response);
                       },
                       search: function () {
                           // custom minLength                    
                           var term = this.value;
                           if (term.length < 3) {
                               return false;
                           }
                       },
                       focus: function () {
                           // prevent value inserted on focus
                           return false;
                       },
                       select: function (event, ui) {
                           if (jQuery("#lstCity option[value='" + ui.item.value + "']").length == 0) {
                               jQuery("#lstCity").append(jQuery("<option></option>").val(ui.item.value).html(ui.item.label));
                               jQuery('#lstCity').find(":checkbox[value='" + ui.item.value + "']").attr("checked", "checked");
                               jQuery("#lstCity option[value='" + ui.item.value + "']").attr("selected", 1);
                               jQuery('#lstCity').multipleSelect("refresh");
                           }
                           else {
                               toast("Error", "City Already Added..!", "");
                           }
                           jQuery('#txtCity').val('');
                           return false;
                       },
                   });
         });
    </script>

      <%--  Search PO--%>
     <script type="text/javascript">
         function searchData(con) {

             jQuery("#btnSearch").attr('disabled', 'disabled').val('Searching...');
             if (con == 0)
                 $modelBlockUI();

             var CentreType = jQuery('#lstCentreType').multipleSelect("getSelects").join();
             var CategoryType = jQuery('#lstCategoryType').multipleSelect("getSelects").join();
             var Manufacture = jQuery('#lstManufacture').multipleSelect("getSelects").join();
             var ZoneID = jQuery('#lstZone').multipleSelect("getSelects").join();
             var SubCategory = jQuery('#lstSubCategory').multipleSelect("getSelects").join();
             var Machine = jQuery('#lstMachine').multipleSelect("getSelects").join();
             var StateID = jQuery('#lstState').multipleSelect("getSelects").join();
             var ItemType = jQuery('#lstItemType').multipleSelect("getSelects").join();
             var ItemIDGroup = jQuery('#lstItemGroup').multipleSelect("getSelects").join();
             var CityID = jQuery('#lstCity').multipleSelect("getSelects").join();
             var VendorID = jQuery('#lstVendor').multipleSelect("getSelects").join();

             var ddlaction = $('#<%=ddlaction.ClientID%>').val();
             var location = jQuery('#<%=lstlocation.ClientID%>').multipleSelect("getSelects").join();


             serverCall('POSearch.aspx/bindData', {CentreType:CentreType ,CategoryType: CategoryType,Manufacture:Manufacture,ZoneID:ZoneID,SubCategory:SubCategory,Machine: Machine,StateID:StateID,ItemType:ItemType,ItemIDGroup:ItemIDGroup,FromDate:jQuery('#txtFromDate').val(),ToDate:jQuery('#txtToDate').val(),CityID:CityID,VendorID:VendorID,PONo:jQuery('#txtPoNo').val(),POType:jQuery('#ddlOrderType option:selected').text(),POStatus:con,Maker:$('#<%=ddlusername.ClientID%>').val(),ddlaction:ddlaction,location:location}, function (response) {
                 $('#tbl_POSearch').empty();
                    
                 if (response != "") {
                     POData = jQuery.parseJSON(response);
                     var $mydata = [];

                     $mydata.push('<thead><tr id="header" style="font-size:large;">');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">S.No.</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" style="width:70px;">View Item</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" style="width: 150px;" scope="col">PO No.</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col;" style="display:none">PO Subject</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">Location</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">Vendor</td>');                       
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">PO Type</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">Status</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" style="width: 110px;" scope="col">Raised Date</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">Gross Amt.</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">Net Amt.</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">Action Type</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col">Next Action</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" style="display:none;" scope="col">View</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col" style="width: 30px;">Print</td>');
                   
                     if (editAfterapp == "1") {
                         $mydata.push('<td class="GridViewHeaderStyle" scope="col" style="width: 30px;">Qty Edit</td>');
                     }

                     if (closeAfterapp == "1") {
                         $mydata.push('<td class="GridViewHeaderStyle" scope="col" style="width: 30px;">PO Close</td>');
                     }
                     if (rejectAfterAppBeforeClose == "1") {
                         $mydata.push('<td class="GridViewHeaderStyle" scope="col" style="width: 30px;">PO Reject</td>');
                     }
                     if (poeditfull == "1") {
                         $mydata.push('<td class="GridViewHeaderStyle" scope="col" style="width: 30px;">Full Edit</td>');
                     }
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col" style="width: 30px;text-align:center;" >Vendor Comment</td>');
                     $mydata.push('<td class="GridViewHeaderStyle" scope="col" style="width: 30px;">Mail</td>');
                     $mydata.push('</tr></thead>');

                     $mydata = $mydata.join("");
                     jQuery('#tbl_POSearch').append($mydata);


                     var grossamt = 0, discamt = 0, netamt = 0, taxamt = 0;
                     for (var a = 0; a <= POData.length - 1; a++) {

                         grossamt = grossamt + parseFloat(POData[a].GrossTotal);
                         netamt = netamt + parseFloat(POData[a].NetTotal);

                         discamt = discamt + parseFloat(POData[a].DiscountOnTotal);
                         taxamt = taxamt + parseFloat(POData[a].TaxAmount);

                         var total = "GrossAmt: <b>" + grossamt + " </b>DiscAmt: <b>" + discamt + " </b>TaxAmt: <b>" + taxamt + "</b> NetAmt: <b>" + netamt + "</b>";

                         var $mydata1 = [];


                         $mydata1.push('<tr id=');  $mydata1.push(POData[a].PurchaseOrderID);  $mydata1.push('style="height:30px;background-color:');  $mydata1.push(POData[a].rowColor);  $mydata1.push('" >');
                             
                         $mydata1.push('<td>');  $mydata1.push(parseFloat(a + 1));
                         if (POData[a].re != "") {
                             $mydata1.push('<img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="openpoam(\'' + POData[a].PurchaseOrderNo + '\')" /><br/><span style="background-color:red;color:white;cursor:pointer;" onclick="showerrormsg(\'' + POData[a].remsg + '\');">');  $mydata1.push(POData[a].re);  $mydata1.push('</span>');
                         }
                         $mydata1.push('</td>');
                            
                         $mydata1.push('<td class="GridViewLabItemStyle"  id="tdPODetail" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showPODetail(this)" />');
                         if (POData[a].VendorInvoice != "") {
                             $mydata1.push('<br/><input type="button" value="Invoice" style="cursor:pointer;"    onclick="openme(\'' + POData[a].VendorInvoice + '\');"   />');
                         }


                         $mydata1.push('</td>');

                         $mydata1.push('<td>'); $mydata1.push( POData[a].PurchaseOrderNo); $mydata1.push('</td>');
                         $mydata1.push('<td style="display:none">'); $mydata1.push( POData[a].Subject); $mydata1.push('</td>');
                         $mydata1.push('<td>'); $mydata1.push( POData[a].Location); $mydata1.push('</td>');
                         $mydata1.push('<td>'); $mydata1.push( POData[a].SupplierName); $mydata1.push('</td>');                        
                         $mydata1.push('<td>'); $mydata1.push( POData[a].POType); $mydata1.push('</td>');
                         $mydata1.push('<td>'); $mydata1.push( POData[a].POStatusType); $mydata1.push('</td>');
                         $mydata1.push('<td>'); $mydata1.push( POData[a].RaisedDate); $mydata1.push('</td>');
                         $mydata1.push('<td  style="text-align:right;">'); $mydata1.push( POData[a].GrossTotal); $mydata1.push('</td>');
                         $mydata1.push('<td  style="text-align:right;">'); $mydata1.push( POData[a].NetTotal); $mydata1.push('</td>');

                         if (POData[a].ActionType == "Maker") {
                             $mydata1.push('<td class="GridViewLabItemStyle" style="background-color:white;font-weight:bold;" >Prepared</td>');
                         }
                         else if (POData[a].ActionType == "Checker") {
                             $mydata1.push('<td class="GridViewLabItemStyle" style="background-color:aqua;font-weight:bold;" >Validated</td>');
                         }
                         else {
                             $mydata1.push('<td class="GridViewLabItemStyle" style="background-color:palegreen;font-weight:bold;">Approved</td>');
                         }
                         if (POData[a].POStatus != "3") {
                             if (POData[a].ActionType == "Maker") {
                                 var aaa = "Checker";
                                 $mydata1.push('<td title="Pending For Check" class="GridViewLabItemStyle" style="background-color:aqua;font-weight:bold;" ><input style="font-weight:bold;cursor:pointer;" type="button" value="Validate" onclick="editData(this,\'' + aaa + '\',\'' + POData[a].IsDirectPO + '\')"  /> </td>');
                             }
                             else if (POData[a].ActionType == "Checker") {
                                 var aaa = "Approval";

                                 if (Number(POData[a].NetTotal) > Number(limitperpo)) {
                                     $mydata1.push('<td  title="Pending For Approve"  class="GridViewLabItemStyle" style="background-color:red;font-weight:bold;color:white" >Limit Exceed </td>');
                                 }
                                 else {
                                     $mydata1.push('<td  title="Pending For Approve"  class="GridViewLabItemStyle" style="background-color:palegreen;font-weight:bold;" ><input style="font-weight:bold;cursor:pointer;" type="button" value="Approval"  onclick="editData(this,\'' + aaa + '\',\'' + POData[a].IsDirectPO + '\')" /> </td>');
                                 }
                             }
                             else {
                                 $mydata1.push('<td title="Approval Done"  class="GridViewLabItemStyle"></td>');
                             }
                         }
                         else {
                             $mydata1.push('<td title="Reject Reason"  class="GridViewLabItemStyle">');  $mydata1.push(POData[a].RejectReason);  $mydata1.push('</td>');
                         }                                                      
                            
                         $mydata1.push('<td  align="center">');
                         if (POData[a].POStatus == '2' || POData[a].POStatus == '5') {
                             $mydata1.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printPO(\'' + POData[a].PurchaseOrderID + '\',\'' + POData[a].DeliveryAddress + '\');"/>');

                         }
                         $mydata1.push('</td>');
                       
                         if (editAfterapp == "1") {
                             $mydata1.push('<td  align="center">');
                             if (POData[a].POStatus == '2') {
                                 $mydata1.push('<img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="popupEditPO(\'' + POData[a].PurchaseOrderID + '\',\'' + POData[a].NetTotal + '\',\'' + POData[a].PurchaseOrderNo + '\',\'' + POData[a].IndentNo + '\');" />');
                             }
                             $mydata1.push('</td>');
                         }
                         if (closeAfterapp == "1") {
                             $mydata1.push('<td  align="center">');
                             if ( POData[a].POStatus == '2') {
                                 $mydata1.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="popupClosePO(\'' + POData[a].PurchaseOrderID + '\',\'' + POData[a].PurchaseOrderNo + '\',\'' + POData[a].IndentNo + '\');" />');
                             }
                             $mydata1.push('</td>');
                         }
                         if (rejectAfterAppBeforeClose == "1") {
                             $mydata1.push('<td  align="center">');
                             if ( POData[a].POStatus == '2') {
                                 $mydata1.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="popupRejectPO(\'' + POData[a].PurchaseOrderID + '\',\'' + POData[a].PurchaseOrderNo + '\',\'' + POData[a].IndentNo + '\');" />');
                             }
                            
                             $mydata1.push('</td>');
                         }
                         if (poeditfull == "1") {
                             $mydata1.push('<td  align="center">');
                             if (POData[a].POStatus == '2') {
                                 $mydata1.push('<img src="../../App_Images/edit.png" style="cursor:pointer;" onclick="openpofulledit(\'' + POData[a].PurchaseOrderNo + '\');" />');
                             }
                           
                             $mydata1.push('</td>');
                         }
                         $mydata1.push('<td class="GridViewLabItemStyle" style="text-align:center;"  > ');
                         if (POData[a].vendorcomment != "") {
                             $mydata1.push('<img title="'); $mydata1.push(POData[a].vendorcomment); $mydata1.push('" src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showcomment(\'' + POData[a].vendorcomment + '\')" /> ');
                         }
                             
                         $mydata1.push('</td>');


                         if (POData[a].POStatus == '2' && POData[a].POStatus != '4' && POData[a].POStatus != '5') {
                             $mydata1.push('<td align="center"><img src="../../App_Images/gmail.png" style="cursor:pointer;height:14px" onclick="popupMail(\'' + POData[a].PurchaseOrderID + '\',\'' + POData[a].VendorID + '\',\'' + POData[a].SupplierName + '\',\'' + POData[a].PurchaseOrderNo + '\',\'' + POData[a].VendorMailID + '\',\'' + POData[a].DeliveryAddress + '\');"/></td>');

                         }
                         else {
                             $mydata1.push('<td align="center"></td>');

                         }
                         $mydata1.push('<td style="display:none;" id="tdIsDirectPO">' + POData[a].IsDirectPO + '</td>');
                         $mydata1.push('<td style="display:none;" id="tdPurchaseOrderID">' + POData[a].PurchaseOrderID + '</td>');
                         $mydata1.push('</tr>');

                         $mydata1 = $mydata1.join("");
                         jQuery('#tbl_POSearch').append($mydata1);



                     }
                     jQuery("#tbl_POSearch").tableHeadFixer({
                     });

                 }
                 else {
                        
                     toast("Error", "No Data Found..!", "");
                     jQuery("#lblError").text('No Record Found');
                     jQuery("#div_POSearch").hide();
                 }
                 jQuery("#btnSearch").removeAttr('disabled').val('Search');

             });
             $modelUnBlockUI();

         }
         function openpoam(ponumber) {
             window.open("POAmendedView.aspx?PONumber=" + ponumber, null, 'left=50, top=100, height=500, width=1220, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no')
         }
         function openme(invoice) {

             window.open("../Store/VendorPortal/AddFile.aspx?Type=2&Filename=" + invoice, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no')
         }

         function showcomment(comment) {

             $('#mmcomment').html(comment);
             $find('<%=ModalPopupExtender1.ClientID%>').show();
             
         }
         function hideDetailDiv() {
             jQuery('#myDetail').hide();
         }
         function editData(ctrl, type, IsDirectPO) {
             var href = "";
             if (IsDirectPO == "1") {
                 href = 'DirectPO.aspx?POID=' + $(ctrl).closest('tr').attr("id") + '&ActionType=' + type;
             }
             else {
                 href = 'POAgainstPI.aspx?POID=' + $(ctrl).closest('tr').attr("id") + '&ActionType=' + type;
             }
             $.fancybox({
                 maxWidth: 1500,
                 maxHeight: 800,
                 fitToView: false,
                 width: '100%',
                 height: '100%',
                 href: href,
                 autoSize: false,
                 closeClick: false,
                 openEffect: 'none',
                 closeEffect: 'none',
                 'type': 'iframe',
                 afterClose: function () {
                     searchData('0');
                 }
             });
         }
              </script>
        <script type="text/javascript">
            function showPODetail(rowID) {               
                var id = jQuery(rowID).closest('tr').attr("id");              
                if (jQuery('table#tbl_POSearch').find('#ItemDetail' + id).length > 0) {
                    jQuery('table#tbl_POSearch tr#ItemDetail' + id).remove();
                    jQuery(rowID).attr("src", "../../App_Images/plus.png");
                    return;
                }
                var PurchaseOrderID = jQuery(rowID).closest('tr').find("#tdPurchaseOrderID").text();

                serverCall('POSearch.aspx/bindPODetail', { PurchaseOrderID: PurchaseOrderID }, function (response) {

                    Podata = jQuery.parseJSON(response);
                    if (Podata.length == 0) {
                        toast("Error", "No Data Found..!", "");
                    }
                    else {
                        jQuery(rowID).attr("src", "../../App_Images/minus.png");
                        var $mydata = [];

                        $mydata.push("<div style='width:99%;max-height:275px;overflow:auto;'><table style='width:99%' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>");
                        $mydata.push('<tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;">');
                        $mydata.push('<td  style="width:20px;">S.No.</td>');
                        $mydata.push('<td>Item Name</td>');
                        $mydata.push('<td>Manufacture Name</td>');
                        $mydata.push('<td>Machine Name</td>');
                        $mydata.push('<td>Ord. Qty.</td>');
                        $mydata.push('<td>Ord. Free Qty.</td>');
                        $mydata.push('<td>Chk. Qty.</td>');
                        $mydata.push('<td>Chk. Free Qty.</td>');
                        $mydata.push('<td>App. Qty.</td>');
                        $mydata.push('<td>App. Free Qty.</td>');
                        $mydata.push('<td>UnitPrice</td>');
                        $mydata.push('<td>Disc.(%)</td>');
                        $mydata.push('<td>Net Amt.</td>');
                        $mydata.push('<td style="text-align:center;">Vendor Comment</td>');
                           
                        for (var a = 0; a <= Podata.length - 1; a++) {

                           $mydata.push('<tr  style="height:30px;background-color:lightgoldenrodyellow" id='); $mydata.push(Podata[a].PurchaseOrderDetailID ); $mydata.push('>');
                           $mydata.push('<td>'); $mydata.push(parseFloat(a + 1) ); $mydata.push('</td>');
                           $mydata.push('<td>'); $mydata.push(Podata[a].ItemName ); $mydata.push('</td>');
                           $mydata.push('<td>'); $mydata.push(Podata[a].ManufactureName ); $mydata.push('</td>');
                           $mydata.push('<td>'); $mydata.push(Podata[a].MachineName ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].OrderedQty ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].OrderedFreeQty ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].CheckedQty ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].CheckedFreeQty ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].ApprovedQty ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].ApprovedFreeQty ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].UnitPrice ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].DiscountPercentage ); $mydata.push('</td>');
                           $mydata.push('<td style="text-align:right">'); $mydata.push(Podata[a].NetAmount ); $mydata.push('</td>');
                           $mydata.push('<td  style="text-align:center;"  > ');
                            if (Podata[a].vendorcommentitem != "") {
                               $mydata.push('<img title="'); $mydata.push(Podata[a].vendorcommentitem ); $mydata.push('" src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showcomment(\''); $mydata.push(Podata[a].vendorcommentitem ); $mydata.push('\')" /> ');
                            }

                           $mydata.push('</td>');
                           $mydata.push('</tr>');
                        }
                        $mydata.push("</table></div>");
                        $mydata = $mydata.join("");

                        var newdata = '<tr id="ItemDetail' + id + '"><td></td><td colspan="16">' + $mydata + '</td></tr>';

                        $(newdata).insertAfter($(rowID).closest('tr'));
                    }
                });
            }
            function Showmailinfo(mail) {
                alert(mail);
            }
        </script>
        <script type="text/javascript">
            function popupApprovePO(PurchaseOrderID) {

                serverCall('POSearch.aspx/approvePO', { PurchaseOrderID: PurchaseOrderID }, function (response) {
                    if (response == "1")
                        searchData("2");
                    else
                        alert("Error Occur PO Not Approved..!");
                });
            }
            </script>

    <%--  Mail PO--%>
    <script type="text/javascript">
            function popupMail(PurchaseOrderID, vendorID, VendorName, PurchaseOrderNo, VendorMailID, DeliveryAddress) {
		if((DeliveryAddress != "") && (DeliveryAddress.trim() != "(),") ) {
			$find('<%=modelMail.ClientID%>').show();
	                jQuery('#lblPONumber').html(PurchaseOrderNo);
	                jQuery('#lblPurchaseOrderID').html(PurchaseOrderID);
	                jQuery('#lblVenderName').html(VendorName);
                	jQuery('#txtVendoeMailID').val(VendorMailID);
		} else {
			alert('Address is left empty. Please fill up your address first to get the report.');
			return false;
		}
        	        
            }
            function sendMail() {
                if (jQuery('#txtVendoeMailID').val() == "") {
                    alert("Please Enter EmailID..!");
                    jQuery('#txtVendoeMailID').focus();
                    return;
                }

                jQuery("#btnVendorSendMail").attr('disabled', 'disabled').val('Sending...');

                serverCall('POSearch.aspx/EmailReport', { PurchaseOrderID: jQuery('#lblPurchaseOrderID').html(),VendorEmailID: jQuery('#txtVendoeMailID').val(),vendorName: jQuery('#lblVenderName').html(),emailCC: jQuery('#txtCC').val(), emailBcc: jQuery('#txtBCC').val() }, function (response) {
                    if (response == "1") {
                        alert("Email Send Successfully");
                    }
                    else {
                        alert("Email Send Successfully");
                    }
                    jQuery("#btnVendorSendMail").removeAttr('disabled').val('Send');
                    $find('<%=modelMail.ClientID%>').hide();
                });
            
            
            }
       
        function printPO(PurchaseOrderID,DeliveryAddress) {
		
            if ((DeliveryAddress != "") &&  (DeliveryAddress.trim() != "(),")) {
		
                serverCall('POSearch.aspx/encryptPurchaseOrderID', { ImageToPrint: "1",PurchaseOrderID: PurchaseOrderID}, function (response) {
                    var result1 = jQuery.parseJSON(response);
                    window.open('POReport.aspx?ImageToPrint=' + result1[0] + '&POID=' + result1[1]);
                });

            }else {

                alert('Address is left empty. Please fill up your address first to get the report.');
                return false;
            }
        }
       
            </script>
  <%--  Close PO--%>
    <script type="text/javascript">
            function popupClosePO(PurchaseOrderID, PurchaseOrderNo, IndentNo) {
                jQuery('#lblClosePONo').html(PurchaseOrderNo);
                jQuery('#lblPurchaseOrderID').html(PurchaseOrderID);
                jQuery('#lblIndentNo').html(IndentNo);
                $find('<%=modelClose.ClientID%>').show();

            }
            function closePO() {
                if (jQuery('#<%=txtPOCloseReason.ClientID%>').val() == "") {
                    alert("Please Enter Close Reason..!");
                    jQuery('#<%=txtPOCloseReason.ClientID%>').focus();
                    return;
                }

                jQuery("#btnPOClose").attr('disabled', 'disabled').val('Submitting...');

                serverCall('POSearch.aspx/closePO', { PurchaseOrderID: jQuery('#lblPurchaseOrderID').html(),closeReason: jQuery('#txtPOCloseReason').val(),IndentNo:jQuery('#lblIndentNo').html()}, function (response) {
                    if (response == "1") {
                        $find('<%=modelClose.ClientID%>').hide();
                        jQuery('#lblClosePONo,#lblPurchaseOrderID,#lblIndentNo').html('');
                        jQuery('#txtPOCloseReason').val('');
                        searchData('0');
                    }
                    else if (response == "2") {
                        alert("PO Already Closed");
                    }
                    else {
                        alert("Error Occur PO Not Close..!");
                    }
                    jQuery("#btnPOClose").removeAttr('disabled').val('Close');
                });
            
            }
        </script>

      <%--  Edit PO--%>
    <script type="text/javascript">
        function popupEditPO(PurchaseOrderID, NetTotal, PONo, IndentNo) {
            $find('<%=modalEditPO.ClientID%>').show();
            jQuery('#lblPONo').text(PONo);
            jQuery('#lblPurchaseOrderID').text(PurchaseOrderID);
            jQuery("#tblEditPO").find("tr:gt(0)").remove();
   
            serverCall('POSearch.aspx/bindPOEditDetail', { PurchaseOrderID: PurchaseOrderID,IndentNo: IndentNo}, function (response) {
                var mynet = 0;
                var PODetail = jQuery.parseJSON(response);
            
                for (var a = 0; a <= PODetail.length - 1; a++) {
                    var appendText = [];
                    appendText.push("<tr  style='background-color:lightgoldenrodyellow'>");
                    appendText.push('<td id="tdID" >' + parseFloat(a + 1) + '');
                    appendText.push(" <input type='checkbox'  id='chkEditPO' >");
                    appendText.push('</td>');
                    appendText.push('<td >' + PODetail[a].ItemName + '</td>');
                    appendText.push('<td >' + PODetail[a].MachineName + '</td>');
                    appendText.push('<td >' + PODetail[a].ManufactureName + '</td>');
                    appendText.push('<td >' + PODetail[a].PackSize + '</td>');
                    appendText.push('<td >' + PODetail[a].CatalogNo + '</td>');
                    appendText.push('<td >' + PODetail[a].MajorUnitName + '</td>');
                    appendText.push("<td > <input type='text' id='txtApprovedQty' style='width:60px;text-align:right' value='" + PODetail[a].ApprovedQty + "' onchange='chkEditPo(this)' onkeyup='editNetAmt(this)' onkeypress='return checkForSecondDecimal(this,event);'/></td>");
                    appendText.push("<td style='text-align:right' id='tdUnitPrice'> " + PODetail[a].UnitPrice + "</td>");              
                    appendText.push("<td style='text-align:right'><span id='spnNetAmt'> " + PODetail[a].NetAmount + "</span></td>");
                    appendText.push('<td id="tdGRNQty" style="text-align:right">' + PODetail[a].GRNQty + '</td>');
                    appendText.push('<td id="tdApprovedQty" style="display:none;">' + PODetail[a].ApprovedQty + '</td>');
                    appendText.push("<td  id='tdPurchaseOrderID' style='display:none;'> " + PODetail[a].PurchaseOrderID + "</td>");
                    appendText.push("<td  id='tdItemID' style='display:none;'> " + PODetail[a].ItemID + "</td>");
                    appendText.push("<td  id='tdPurchaseOrderDetailID' style='display:none;'> " + PODetail[a].PurchaseOrderDetailID + "</td>");
                    appendText.push("<td  id='tdMajorUnitInDecimal' style='display:none;'> " + PODetail[a].MajorUnitInDecimal + "</td>");
                    appendText.push("<td  id='tdIndentNo' style='display:none;'> " + IndentNo + "</td>");
                    appendText.push("</tr>");
                    appendText = appendText.join(" ");
                    jQuery('#tblEditPO').append(appendText);                        
                }
             });
        }
        function chkEditPo(rowID) {
            jQuery(rowID).closest('tr').css("background-color", "lightgoldenrodyellow"); ;
            var ApprovedQty = jQuery(rowID).closest('tr').find("#txtApprovedQty").val();
            if (isNaN(ApprovedQty) || ApprovedQty == "")
                ApprovedQty = 0;
            if (parseFloat(jQuery(rowID).closest('tr').find("#tdGRNQty").text()) > parseFloat(ApprovedQty)) {
                jQuery(rowID).closest('tr').find("#txtApprovedQty").val(jQuery(rowID).closest('tr').find("#tdApprovedQty").text());
                ApprovedQty = jQuery(rowID).closest('tr').find("#txtApprovedQty").val();

                alert('Qty Cannot Less then GRN Quantity');
                // jQuery("#lblErrorPOEdit").text('Qty Cannot Less then GRN Quantity');
                jQuery(rowID).closest('tr').find("#txtApprovedQty").focus();
            }
            if (parseFloat(jQuery(rowID).closest('tr').find("#tdApprovedQty").text()) < parseFloat(ApprovedQty)) {
                jQuery(rowID).closest('tr').find("#txtApprovedQty").val(jQuery(rowID).closest('tr').find("#tdApprovedQty").text());
                ApprovedQty = jQuery(rowID).closest('tr').find("#txtApprovedQty").val();

                alert('You Can not Increase Approved Quantity');
                // jQuery("#lblErrorPOEdit").text('Qty Cannot Less then GRN Quantity');
                jQuery(rowID).closest('tr').find("#txtApprovedQty").focus();
            }
            if (parseFloat(jQuery(rowID).closest('tr').find("#tdApprovedQty").text()) != parseFloat(jQuery(rowID).closest('tr').find("#txtApprovedQty").val())) {
                jQuery(rowID).closest('tr').find("#chkEditPO").prop('checked', 'checked');
            }
            else {
                jQuery(rowID).closest('tr').find("#chkEditPO").prop('checked', false);

            }
        }
        function editNetAmt(rowID) {
            jQuery("#lblErrorPOEdit").text("");
            var ApprovedQty = jQuery(rowID).closest('tr').find("#txtApprovedQty").val();
            if (isNaN(ApprovedQty) || ApprovedQty == "")
                ApprovedQty = 0;

            var NetAmt = parseFloat(ApprovedQty) * parseFloat(jQuery(rowID).closest('tr').find("#tdUnitPrice").text());
            jQuery(rowID).closest('tr').find("#spnNetAmt").text(NetAmt);           

        }
        function saveEditPO() {
            var validateQty = 0;
            jQuery('#tblEditPO tr').each(function () {
                if ($(this).attr('id') != 'header' && jQuery(this).find('#chkEditPO').is(':checked') ) {
                    if (jQuery(this).find('#txtApprovedQty').val() == "" || jQuery(this).find('#txtApprovedQty').val() == 0) {
                        alert('Please Enter Valid Qty.')
                        jQuery(this).find('#txtApprovedQty').focus();
                        validateQty = 1;
                        return;
                    }
                }

            });
            if (validateQty == 1) {
                return;
            }
            var poItemDetail = getcompletedata();
          
            if (poItemDetail.length == 0) {
                alert('Please Select Item to Edit')
                return;
            }
            jQuery("#btnSaveEditPO").attr('disabled', 'disabled').val('Submitting...');
            var PurchaseOrderID = jQuery('#lblPurchaseOrderID').text();

            serverCall('POSearch.aspx/POEdit', { POItemData: poItemDetail, PurchaseOrderID: PurchaseOrderID}, function (response) {
                if (response == "1") {
                    $find('<%=modalEditPO.ClientID%>').hide();
                    alert("PO Updated Successfully");
                    searchData('0');
                }
                else if (response == "2") {
                    alert('Already Closed');
                }
                else if (response == "0") {
                    alert('Error..');
                }
                else if (response.indexOf("$") != -1) {
                    var titleText = response.split('$')[1];
                    jQuery('#tblEditPO tbody tr:eq(' + response.split('$')[0] + ')').find('#txtApprovedQty').focus();
                    jQuery('#tblEditPO tbody tr:eq(' + response.split('$')[0] + ')').css("background-color", "#FF0000");
                    jQuery('#tblEditPO tbody tr:eq(' + response.split('$')[0] + ')').attr('title', titleText);
                }
                    
                else {
                    var titleText = response.split('#')[1];
                    jQuery('#tblEditPO tbody tr:eq(' + response.split('#')[0] + ')').find('#txtApprovedQty').focus();
                    jQuery('#tblEditPO tbody tr:eq(' + response.split('#')[0] + ')').css("background-color", "#FF0000");
                    jQuery('#tblEditPO tbody tr:eq(' + response.split('#')[0] + ')').attr('title', titleText);
                }
                jQuery("#btnSaveEditPO").removeAttr('disabled').val('Save');
            });
        }


        function getcompletedata() {
            var POEditData = [];
            jQuery('#tblEditPO tr').each(function () {
                if ($(this).attr('id') != 'header' &&  jQuery(this).find('#chkEditPO').is(':checked')) {
                    var POItemData = [];
                    POItemData[0] = jQuery(this).find('#tdItemID').html();
                    POItemData[1] = jQuery(this).find('#txtApprovedQty').val();
                    POItemData[2] = jQuery(this).find('#tdPurchaseOrderID').text();
                    POItemData[3] = jQuery(this).find('#tdPurchaseOrderDetailID').text();
                    POItemData[4] = jQuery(this).find('#tdUnitPrice').text();
                    POItemData[5] = jQuery(this).find('#tdIndentNo').text();
                    POItemData[6] = jQuery(this).find('#tdApprovedQty').text();
                    POItemData[7] = jQuery.trim( jQuery(this).find('#tdID').text());
                    POEditData.push(POItemData);
                }
            });

            return POEditData;

        }
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;

            if (jQuery(sender).closest('tr').find("#tdMajorUnitInDecimal").text() == "0") {
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            else {
                if ((charCode != 46 && sender.value.indexOf('.') != -1) && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            }
            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            if (charCode == '46' && jQuery(sender).closest('tr').find("#tdMajorUnitInDecimal").text() == "0") {
                return false;
            }
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;

        }
      </script>

<%--  Reject PO--%>
    <script type="text/javascript">    
        function saveRejectPO() {
            if (jQuery.trim(jQuery('#txtPORejectReason').val()) == "") {
                alert("Please Enter Reject Reason");
                jQuery('#txtPORejectReason').focus();
                return;
            }
            var validateQty = 0;
            jQuery('#tblRejectPO tr').each(function () {
                if ($(this).attr('id') != 'RejectHeader' && jQuery(this).find('#chkRejectPO').is(':checked')) {
                    if (jQuery(this).find('#txtRejectQty').val() == "" || jQuery(this).find('#txtRejectQty').val() == 0) {
                        alert('Please Enter Valid Qty.')
                        jQuery(this).find('#txtRejectQty').focus();
                        validateQty = 1;
                        return;
                    }
                }
            });
            if (validateQty == 1) {
                return;
            }
            var poItemDetail = getRejectedData();
            if (poItemDetail.length == 0) {
                alert('Please Select Item to Reject')
                return;
            }
            jQuery("#btnRejectPO").attr('disabled', 'disabled').val('Submitting...');
            var PurchaseOrderID = jQuery('#lblRejectPOID').text();

            serverCall('POSearch.aspx/rejectPO', {  POItemData: poItemDetail, PurchaseOrderID: PurchaseOrderID,RejectReason:jQuery.trim(jQuery('#txtPORejectReason').val()) }, function (response) {
                if (response == "1") {
                    $find('<%=modelRejectPO.ClientID%>').hide();
                    alert("PO Updated Successfully");
                    searchData('0');
                }
                else if (response == "0") {
                    alert('Error..');
                }
                else if (response.indexOf("$") != -1) {
                    var titleText = response.split('$')[1];
                    jQuery('#tblRejectPO tbody tr:eq(' + response.split('$')[0] + ')').find('#txtApprovedQty').focus();
                    jQuery('#tblRejectPO tbody tr:eq(' + response.split('$')[0] + ')').css("background-color", "#FF0000");
                    jQuery('#tblRejectPO tbody tr:eq(' + response.split('$')[0] + ')').attr('title', titleText);
                }
                else {
                    var titleText = response.split('#')[1];
                    jQuery('#tblRejectPO tbody tr:eq(' + response.split('#')[0] + ')').find('#txtApprovedQty').focus();
                    jQuery('#tblRejectPO tbody tr:eq(' + response.split('#')[0] + ')').css("background-color", "#FF0000");
                    jQuery('#tblRejectPO tbody tr:eq(' + response.split('#')[0] + ')').attr('title', titleText);
                }
                jQuery("#btnRejectPO").removeAttr('disabled').val('Reject');
            });

        }
         

            function openpofulledit(PurchaseOrderNo) {
                var href = "POEditAdmin.aspx?ponumber=" + PurchaseOrderNo;
                $.fancybox({
                    maxWidth: 1500,
                    maxHeight: 800,
                    fitToView: false,
                    width: '100%',
                    height: '100%',
                    href: href,
                    autoSize: false,
                    closeClick: false,
                    openEffect: 'none',
                    closeEffect: 'none',
                    'type': 'iframe',
                    afterClose: function () {
                        searchData('0');
                    }
                });
            }
            function popupRejectPO(PurchaseOrderID, PurchaseOrderNo, IndentNo) {
            $find('<%=modelRejectPO.ClientID%>').show();
                jQuery('#lblRejectPO').text(PurchaseOrderNo);
                jQuery('#lblRejectPOID').text(PurchaseOrderID);
                jQuery("#tblRejectPO").find("tr:gt(0)").remove();
                jQuery('#txtPORejectReason').val('');

                serverCall('POSearch.aspx/bindPORejectDetail', { PurchaseOrderID: PurchaseOrderID }, function (response) {
                    var mynet = 0;
                    var PORejectDetail = jQuery.parseJSON(response);

                    for (var a = 0; a <= PORejectDetail.length - 1; a++) {
                        var appendText = [];
                        appendText.push("<tr ");
                        if(PORejectDetail[a].IsFree=="1") 
                            appendText.push("style='background-color:#90EE90'>");
                        else
                            appendText.push("style='background-color:lightgoldenrodyellow'>");
                        appendText.push('<td id="tdID" >' + parseFloat(a + 1) + '');
                
                        appendText.push(" <input type='checkbox'  id='chkRejectPO'  >");
                
                        appendText.push('</td>');
                        appendText.push('<td >' + PORejectDetail[a].ItemName + '</td>');
                        appendText.push('<td >' + PORejectDetail[a].MachineName + '</td>');
                        appendText.push('<td >' + PORejectDetail[a].ManufactureName + '</td>');
                        appendText.push('<td >' + PORejectDetail[a].PackSize + '</td>');
                        appendText.push('<td >' + PORejectDetail[a].CatalogNo + '</td>');
                        appendText.push('<td >' + PORejectDetail[a].MajorUnitName + '</td>');

                        appendText.push("<td > <input type='text' id='txtRejectQty' style='width:60px;text-align:right' value='" + PORejectDetail[a].RejectQty + "' onchange='chkRejectPo(this)' onkeypress='return checkForSecondDecimal(this,event);'/></td>");
                        appendText.push("<td  style='text-align:right' id='tdUnitPrice'> " + PORejectDetail[a].UnitPrice + "</td>");
                        appendText.push("<td  style='text-align:right'><span id='spnNetAmt'> " + PORejectDetail[a].NetAmount + "</span></td>");
                        appendText.push('<td  id="tdGRNQty" style="text-align:right">' + PORejectDetail[a].GRNQty + '</td>');
                        appendText.push("<td  id='tdApprovedQty' style='display:none;'> " + PORejectDetail[a].ApprovedQty + "</td>");
                        appendText.push("<td  id='tdPurchaseOrderID' style='display:none;'> " + PORejectDetail[a].PurchaseOrderID + "</td>");
                        appendText.push("<td  id='tdRejectQty' style='display:none;'> " + PORejectDetail[a].RejectQty + "</td>");
                        appendText.push("<td  id='tdItemID' style='display:none;'> " + PORejectDetail[a].ItemID + "</td>");
                        appendText.push("<td  id='tdPurchaseOrderDetailID' style='display:none;'> " + PORejectDetail[a].PurchaseOrderDetailID + "</td>");
                        appendText.push("<td  id='tdMajorUnitInDecimal' style='display:none;'> " + PORejectDetail[a].MajorUnitInDecimal + "</td>");
                        appendText.push("<td  id='tdIndentNo' style='display:none;'> " + IndentNo + "</td>");
                        appendText.push("<td  id='tdIsFree' style='display:none;'> " + PORejectDetail[a].IsFree + "</td>");
                        appendText.push("</tr>");
                        appendText = appendText.join(" ");
                        jQuery('#tblRejectPO').append(appendText);
                    }
                 });
        }
        function chkRejectPo(rowID) {
            if(jQuery(rowID).closest('tr').find("#tdIsFree").text()=="0")
                jQuery(rowID).closest('tr').css("background-color", "lightgoldenrodyellow");
            else
                jQuery(rowID).closest('tr').css("background-color", "#90EE90");

            var RejectQty = jQuery(rowID).closest('tr').find("#txtRejectQty").val();
            if (isNaN(RejectQty) || RejectQty == "")
                RejectQty = 0;
            if (parseFloat(jQuery(rowID).closest('tr').find("#tdRejectQty").text()) < parseFloat(RejectQty)) {
                jQuery(rowID).closest('tr').find("#txtRejectQty").val(jQuery(rowID).closest('tr').find("#tdRejectQty").text());
                RejectQty = jQuery(rowID).closest('tr').find("#txtRejectQty").val();
                alert('Reject Qty Cannot Greater then GRN Quantity Minus Approved Quantity');
                jQuery(rowID).closest('tr').find("#tdRejectQty").focus();
            }
            
            if ((parseFloat(jQuery(rowID).closest('tr').find("#tdRejectQty").text()) != parseFloat(jQuery(rowID).closest('tr').find("#txtRejectQty").val())) && (RejectQty>0)) {
                jQuery(rowID).closest('tr').find("#chkRejectPO").prop('checked', 'checked');
            }
            else {
                jQuery(rowID).closest('tr').find("#chkRejectPO").prop('checked', false);

            }
        }
        function RejectNetAmt(rowID) {

        }
        function getRejectedData() {
            var PORejectData = [];
            jQuery('#tblRejectPO tr').each(function () {
                if ($(this).attr('id') != 'RejectHeader' && jQuery(this).find('#chkRejectPO').is(':checked')) {
                    var POItemData = [];
                    POItemData[0] = jQuery(this).find('#tdItemID').html();
                    POItemData[1] = jQuery(this).find('#txtRejectQty').val();
                    POItemData[2] = jQuery(this).find('#tdPurchaseOrderID').text();
                    POItemData[3] = jQuery(this).find('#tdPurchaseOrderDetailID').text();
                    POItemData[4] = jQuery(this).find('#tdUnitPrice').text();
                    POItemData[5] = jQuery(this).find('#tdIndentNo').text();
                    POItemData[6] = jQuery(this).find('#tdRejectQty').text();
                    POItemData[7] = jQuery.trim(jQuery(this).find('#tdID').text());
                    PORejectData.push(POItemData);
                }
            });

            return PORejectData;

        }

        function showhide() {

            $('.t1').slideToggle("fast");
        }

    </script>

    <script type="text/javascript">

        function bindlocation() {
            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
            var cityId = "";

            var centreid = "";
            jQuery('#<%=lstlocation.ClientID%> option').remove();
            jQuery('#lstlocation').multipleSelect("refresh");
           
            serverCall('MappingStoreItemWithCentre.aspx/bindlocation', { centreid:centreid,StateID:StateID,TypeId:TypeId,ZoneId:ZoneId,cityId:cityId}, function (response) {
                var $ddlloc = $('#<%=lstlocation.ClientID%>');
                $ddlloc.bindMultipleSelect({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocation"), isClearControl: '' });
            });
                
        }
    </script>
</asp:Content>

