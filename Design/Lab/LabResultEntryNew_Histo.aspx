<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LabResultEntryNew_Histo.aspx.cs" Inherits="Design_Lab_LabResultEntryNew_Histo" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %> 
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    
    
  
    <webopt:BundleReference ID="BundleReference5" runat="server" Path="~/App_Style/css" /> 
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css"  />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css"  />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />

    

    <title>Histo Result Entry</title>

   
      <style type="text/css">
           .light-modal-content {
            width:60% !important;
        }
          .auto-style1
          {
              color: #333;
              font-size: 9pt;
              font-family: Verdana, Arial, sans-serif, sans-serif;
              cursor: pointer;
              font-weight: bold;
             
          }
          .ui-dialog {
              width:800px !important;
              height:600px !important;
          }
          #divimgpopup {
                height:600px !important;
          }
      </style>
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
    <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>
    <script type="text/javascript" src="//code.jquery.com/jquery-migrate-3.0.0.js"></script>
    <script type="text/javascript" src="../../Scripts/cropzee.js"></script>
   
    <form id="form1" runat="server">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
         <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
        <div id="Pbody_box_inventory" style="width:1210px;margin: 5px !important">
  <div id="div_HistoReporting"   class="POuter_Box_Inventory" style="width:1210px;">
            <div class="content" style="width:1210px;">
                

                <table style="width:1200px;">
                   
                    <tr>
                        <td colspan="2"><div class="Purchaseheader" > <div class="DivInvName" style="color:Black; cursor: pointer;font-weight:bold;"> </div> </div></td>
                    </tr>
                    <tr>
                        <td valign="top" width="400px" style="word-break: break-all">
                            <table style="width:100%">
                   
                    
                   
                        <tr><td class="auto-style2">Patient Name:</td><td><asp:Label ID="lbpatient" runat="server" style="font-weight: 700"></asp:Label></td>  </tr>
                        <tr><td class="auto-style2">Age/Gender:</td><td><asp:Label ID="lbage" runat="server" style="font-weight: 700"></asp:Label></td>  </tr>
                        <tr><td class="auto-style2">Biopsy No:</td><td><asp:Label ID="lbsecno" runat="server" style="font-weight: 700"></asp:Label></td>  </tr>
                        <tr> <td class="auto-style2">Visit ID:</td><td><asp:Label ID="labno" runat="server" style="font-weight: 700"></asp:Label></td>  </tr>
                        <tr> <td class="auto-style2">SIN No:</td><td><asp:Label ID="lbbarcde" runat="server" style="font-weight: 700"></asp:Label></td>  </tr>
                         <tr> <td class="auto-style2">Test Name:</td><td><asp:Label ID="lbtestname" runat="server" style="font-weight: 700"></asp:Label></td>  </tr>
                                <tr><td class="auto-style2" style="vertical-align: baseline;">Slides and Blocks:</td><td>
                             <asp:DataGrid ID="tblslides" runat="server" Width="100%">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center"/>
                                 <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                             </asp:DataGrid>
                                                                            </td>
                                </tr>
                                
                         <tr><td class="auto-style2">Previous Visit IDs:</td><td><asp:Label ID="lblOldVisitID" runat="server" style="font-weight: 700"></asp:Label></td></tr>
                                <tr><td class="auto-style2">Sample Info:</td><td><asp:Label ID="lbtestname0" runat="server" style="font-weight: 700"></asp:Label></td>  </tr>
                  
                                </table>

                             
                            <br />
                             <div class="Purchaseheader">Template  &nbsp;&nbsp; <input type="checkbox" id="favonly" onclick="gethistotemplate()" /><span style="color:red;">Favourite Template Only</span> </div>
                            <table width="100%">
                                <tr>
                                    <td> Gross</td><td><select id="ddlGrossing" style="width:250px"></select>&nbsp;<input style="font-weight:bold;color:blue" type="button" value=">>" onclick="getTemplateHisto('Grossing')" /></td>
                                </tr>
                                <tr>
                                    <td> Microscopy</td><td><select id="ddlMicroscopic" style="width:250px"></select>&nbsp;<input style="font-weight:bold;color:blue" type="button" value=">>" onclick="getTemplateHisto('Microscopic')" /></td>
                                </tr>
                                <tr>
                                    <td>Impression</td><td> <select id="ddlImpression" style="width:250px"></select>&nbsp;<input style="font-weight:bold;color:blue" type="button" value=">>" onclick="getTemplateHisto('Impression')" /></td>
                                </tr>
                            </table>
                              
                          <br />
                              <input id="pop" type="button" style="color:white;font-weight:bold;background-color:blue;cursor:pointer;" value="Patient Info"  onclick="openmypopup()" />
                             <input id="pop2" type="button" style="color:white;font-weight:bold;background-color:blue;cursor:pointer;display:none;" value="History"  onclick="openmypopup1()" />


                             <input type="button" value="View Doc" style="background-color:red;color:white;cursor:pointer;font-weight:bold" onclick="openpopup6()" />
                            <input type="button" value="View Remarks" style="background-color:#673AB7;color:white;cursor:pointer;font-weight:bold" onclick="openpopup7()" />
                            <br />
                              <br />

                            <input type="button" style="color:white;font-weight:bold;background-color:#8a0707;cursor:pointer;width:153px;" value="Immuno Chemistry" onclick="openmypopup2()" />
                          <br />
                              <div class="Purchaseheader">Clinical History::</div>
                            <asp:TextBox ID="txtclinicalhistory" runat="server" style="resize:none;" TextMode="MultiLine" Height="146px" Width="356px"></asp:TextBox>
                            

                        </td>
                        <td style="border:1px solid black;width:800px;">

                                 <div>
                 <div class="Purchaseheader">Specimen::

                     <asp:TextBox ID="txtspecimen" runat="server" Width="350px" BackColor="Pink" ></asp:TextBox>
                   

                     

                   

                     <input type="button" value="Close" onclick="closeme()" style="background-color:red;color:white;font-weight:bold;cursor:pointer;float:right" />
                 </div>
                                     </div>
                               <div style="height:550px;overflow:auto;">
                                   <div>
                 <div class="Purchaseheader">Gross   <input type="button" title="Save As Favourite" onclick="opentemplate('Gross')" value="Save As Template" style="background-color:blue;color:white;font-weight:bold;float:right;cursor:pointer;" /> </div>
                            <ckeditor:ckeditorcontrol ID="txtHistoDatagross"   BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="750" Height="70" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol>

                 </div>
       <div >
                 <div class="Purchaseheader">Microscopic <input type="button" title="Save As Favourite" onclick="opentemplate('Microscopic')" value="Save As Template" style="background-color:blue;color:white;font-weight:bold;float:right;cursor:pointer;" /></div>
                            <ckeditor:ckeditorcontrol ID="txtHistoDatamicro"  BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="750" Height="70" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol>

                 </div>
       <div >
                
            <table style="width:99%">
                <tr>
                    <td> <div class="Purchaseheader">Final Impression / Diagnosis <input title="Save As Favourite" type="button" onclick="opentemplate('Impression')" value="Save As Template" style="background-color:blue;color:white;font-weight:bold;float:right;cursor:pointer;" /></div></td>
                      <td> <div class="Purchaseheader">Advice / Comment</div></td>
                </tr>
                                           <tr>
                                               <td valign="top">
                            <ckeditor:ckeditorcontrol ID="txtHistoDatafinal"  BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="580" Height="70" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol></td>
                                               <td valign="top">
                            <asp:TextBox ID="txtcomment" runat="server" style="width:180px;height:137px;resize:none;" TextMode="MultiLine"></asp:TextBox>
                                                    </td>
                                           </tr>
                                       </table>
                 </div>

                                   <div >
                 <div class="Purchaseheader">Image Upload</div>
                                       <table style="width:99%">
                                           <tr>
                                               <td valign="top"> <ckeditor:ckeditorcontrol ID="txtimage"  BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="500" Height="175" Toolbar="Source|Bold|Italic|Underline|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|FontSize|"></ckeditor:ckeditorcontrol></td>
                                               <td valign="top"> 
                                                
                                                   <%--<-- Start  For Upload Image to without Flash(13/Jan/2021) --/>--%>

                                                
               


						<div style="display:none;">
						 <div id="imgCanvas" class="image-previewer" data-cropzee="cropzee-input" ></div>
						 </div>
                        
                        <p>
                           <%-- <input type="file" name="file_upload1" id="file_upload1" />--%>
							 <input id="cropzee-input" type="file" name="" />
                           
                            
                        </p>

                
                 
                                                   
						<%--<-- END --/>--%>


                                               <%--  <input type="file" name="file_upload" id="file_upload"  />--%>
                                                   <%--<br />
                                                   <span style="color:red;font-size:13px;">* Install Flash Player To Upload Image</span>--%>

                                                  
                                                   <asp:Button ID="btnAdobeReader" runat="server" Text="Download Flash Player" OnClick="btnAdobeReader_Click" style="display:none;" />

                                               </td>
                                           </tr>
                                       </table>
                           

                 </div>
</div>

       <div >
           <table width="100%" frame="box">
               <tr>
                   <td style="display:none;">  <asp:RadioButtonList ID="rdtype" runat="server" RepeatDirection="Horizontal" Font-Bold="true" onclick="setmydata()">
                    <asp:ListItem Value="0" Selected="True">Final</asp:ListItem>
                    <asp:ListItem Value="1">Pending</asp:ListItem>

                </asp:RadioButtonList></td>
                   <td style="display:none;">  <asp:DropDownList ID="ddlpending" runat="server" Width="200px" Enabled="false"></asp:DropDownList></td>

                   <td align="left">
                       <input id="btnaddreport" type="button" value="Add Report" onclick="AddReport();" class="auto-style1" />

                        <input id="btnGrossApprove" type="button" value="Save Report" class="auto-style1" onclick="SaveReport('0');"
                            
                            <%   if (approved == "1")
                  {  %>
                     disabled="disabled" 
                <%}%> /> &nbsp;

                        <% if(isApproval=="3" || isApproval=="4")
              { %>
                  
                  <input id="btnApproveReport" type="button" value="Approved" class="auto-style1" onclick="FinalDone('1');" 
                    <% 
                  if (approved == "1")
                  {  %>
                     disabled="disabled" style="color:red;"
                <%}%>
                      />   &nbsp;
                          <%if(approved=="0")
           {%> 
                        <input id="btnforward" type="button" value="Forward" class="auto-style1" onclick="Forward();" style="background-color:red;color:white;"  /> 
                        <input id="btnSlideAgain" type="button" value="ReSlide" class="auto-style1" onclick="reslide();" style="background-color:blue;color:white;"  /> 
                       <input id="Button5" type="button" value="Special Stain" class="auto-style1" onclick="reslide();" style="background-color:blue;color:white;"  /> 
  <%}%>
           <%if(approved=="1")
           {%>
            
            <input type="button" id="btnnotapp" value="Not Approved" class="auto-style1" onclick="NotApproved();" /> 
           <b> 
           <%} }%>


               

                  <input id="btnGrossReport" onclick="printhisto();" type="button" value="Report" class="auto-style1" /> 
                
                   <input id="chkheader" type="checkbox"  checked="checked"/><strong>Header</strong> 

                   </td>
               </tr>

           </table>
              
         
          
                
      
                
          

                </div>

                        </td>
                    </tr>
                </table>
                <table>





                  
                    </table>


            </div>
    
        </div>
            </div>

         <div id="popup_box" style="background-color:lightgreen;height:80px;text-align:center;width:340px;">
    <div id="showpopupmsg"></div>
             <br />
             <input type="button" class="searchbutton" value="Yes" onclick="printme()" />
              <input type="button" class="resetbutton" value="No" onclick="unloadPopupBox()" />
    </div>

       <%-- <div id="divimgpopup" >--%>
     
      <asp:HiddenField ID="X" runat="server" />
      <asp:HiddenField ID="Y" runat="server" />
      <asp:HiddenField ID="W" runat="server" />
      <asp:HiddenField ID="H" runat="server" />
     <%-- <div id="imgpopup">
      
      </div><br />
     <input type="button" value="Crop & Add" onclick="crop();" />
     <input type="button" value="Close" onclick="closeme11();" />
     </div>
--%>


         <asp:Button ID="Button1" runat="server" style="display:none;" />

    
    <asp:Panel ID="Panel3" runat="server" BackColor="#EAF3FD" style="width:400px;border:2px solid maroon;display:none;"  >
        <div id="tableSliding" >
                     <div class="Purchaseheader">Sliding Detail</div>
                          <table style="width:100%" frame="box">
                   <tr>
                       <td width="80%">
<table width="100%">
     <tr>
                                    <td style="text-align: right; font-weight: 700">Select Option</td>
                                     <td>
                                         <select id="ddloption" style="font-weight: 700;width:150px;" >  
                                             <option value="0">Select Option</option>
                                             <option value="Deep Cut Slide">Deep Cut Slide</option>
                                              <option value="Repeat H & E Stain">Repeat H & E Stain</option>
                                             <option value="Special Stain">Special Stain</option>
                                              <option value="Extra slides">Extra slides</option>
                                              <option value="IHC">IHC</option>
                                         </select>
                                     </td>
                                     <td style="text-align: right; font-weight: 700">&nbsp;</td>
                               </tr>
                               <tr>
                                    <td style="text-align: right; font-weight: 700">Select Block</td>
                                     <td>
                                         <select id="noofblockslidesaved" style="font-weight: 700;width:150px;" >  
                                         </select>
                                     </td>
                                     <td style="text-align: right; font-weight: 700">&nbsp;</td>
                               </tr>
                               <tr>
                                    <td style="text-align: right; font-weight: 700">No of Slides</td>
                                     <td>
                                         <select id="stfromslidesaved" style="font-weight: 700" name="D1"> <option selected="selected"> </option>
                                             <option>1</option> <option>2</option> <option>3</option> <option>4</option> <option>5</option> <option>6</option>
                                              <option>7</option> <option>8</option> <option>9</option>
                                         </select>&nbsp;&nbsp;&nbsp;<input type="button" id="Button2" value="Make" style="font-weight:bold;cursor:pointer" onclick="makeslidessaved()" /></td>
                                     <td style="text-align: left; font-weight: 700">&nbsp;</td>
                               </tr>
                               <tr>
                                    <td colspan="3" style="text-align: left; font-weight: 700">
                                        <div id="div1" style="height:200px;overflow:scroll;">
                                         <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table4" width="99%">
                                            <tr id="headerslide">
			<th class="GridViewHeaderStyle" scope="col" >S.No</th>
            <th class="GridViewHeaderStyle" scope="col" >Sec No</th>
			<th class="GridViewHeaderStyle" scope="col" >Block ID</th>
             <th class="GridViewHeaderStyle" scope="col" >Slide No</th>
			<th class="GridViewHeaderStyle" scope="col" >Comment</th>
			<th class="GridViewHeaderStyle" scope="col" ></th>
         </tr>
              </table>
                                        </div>
                                    </td>
                               </tr>
    <tr>
         <td colspan="3" align="center">
             <input type="button" value="Save Sliding" class="savebutton" id="Button3" onclick="savedataslide()" />
              <input type="button" value="Close" class="resetbutton" id="Button4" onclick="resetdataslide()" />
        </td>
    </tr>

                           </table>
                       </td>

                      

                   </tr>
                   
               </table>
                          </div>
        </asp:Panel>

     <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server"  TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel3">
    </cc1:ModalPopupExtender>
        <asp:Panel ID="pnl" runat="server" BackColor="#EAF3FD" style="width:400px;border:2px solid maroon;display:none;">
               <div class="Purchaseheader">Forward</div>
            <br />
                          <table style="width:100%" frame="box">

                              

                              <tr>
                                  <td align="right"><b>Centre :</b></td><td><asp:DropDownList ID="ddlcentre" runat="server" Width="250px" onchange="binddoctoforward()"></asp:DropDownList></td>
                                 
                              </tr>

                              <tr>
                                  <td align="right"><b>Doctor :</b></td><td><asp:DropDownList ID="ddldoc" runat="server" Width="250px"></asp:DropDownList></td>
                                 
                              </tr>
                              <tr>
                                  <td>
                                      <br />
                                      <br />
                                  </td>
                              </tr>
                              <tr>
                                  <td align="right"><input type="button" value="Forward" onclick="Forwardme()" class="savebutton" /> </td><td><asp:Button ID="btn" runat="server" Text="Close" CssClass="resetbutton" /></td>
                              </tr>
                              </table>
        </asp:Panel>

        <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server"  TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnl"  CancelControlID="btn">
    </cc1:ModalPopupExtender>


            <asp:Panel ID="Panel1" runat="server" BackColor="#EAF3FD" style="width:400px;border:2px solid maroon;display:none;">
               <div class="Purchaseheader">Save Data As Template</div>
                <table width="99%">
                    <tr>
                        <td>Template Type:</td><td><asp:TextBox ID="txttemptype" runat="server" ReadOnly="true"></asp:TextBox> </td>
                    </tr>
                      <tr>
                        <td>Template Name:</td><td><asp:TextBox ID="txttemname" runat="server"></asp:TextBox> </td>
                    </tr>

                    <tr>
                        <td colspan="2" align="center">

                            <input type="button" value="Save" class="savebutton" onclick="savedataastemple()" />
                            <asp:Button Text="Cancel" runat="server" CssClass="resetbutton" ID="cc" />
                        </td>
                    </tr>
                </table>
                </asp:Panel>
        
        <cc1:ModalPopupExtender ID="ModalPopupExtender3" runat="server"  TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1"  CancelControlID="cc">
    </cc1:ModalPopupExtender>



          <div id="deltadiv" style="display:none;position:absolute;">          
        </div>

        <asp:Panel id="pnlnotapproved" runat="server" style="display:none;width:300px;background-color:lightgray;">
        <div class="Purchaseheader">
           Not Approved Remarks
        </div>

        <center>
            <asp:TextBox ID="txtnotappremarks" runat="server" MaxLength="200" Width="250px" placeholder="Enter Not Approved Remarks" style="text-transform:uppercase;" /><br /><br />
            <input type="button" class="savebutton" onclick="NotApprovedFinaly()" value="Not Approved" />&nbsp;&nbsp;
            <asp:Button ID="btnCancelNotapproved" runat="server" CssClass="resetbutton" Text="Cancel" /><br /><br />
        </center>
    </asp:Panel>


       <cc1:ModalPopupExtender ID="mpnotapprovedrecord" runat="server" CancelControlID="btnCancelNotapproved"
                            DropShadow="true" TargetControlID="Button1" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlnotapproved" BehaviorID="mpnotapprovedrecord">
                        </cc1:ModalPopupExtender> 
         <script type="text/javascript">

             // Start  For Upload Image to without Flash(13/jan/2021)
             $(document).ready(function () {
                 editorid = '<%=txtimage.ClientID%>';

            $("#cropzee-input").cropzee({
                startSize: [100, 100, '%'],
            });
        });
        // END

             function opentemplate(type) {
                 var objEditor = CKEDITOR.instances['<%=txtHistoDatagross.ClientID%>'];
                 Gross = objEditor.getData();
                 if (Gross.trim() == "null" || Gross.trim() == "<br />") {
                     Gross = "";
                 }
                 var Microscopic = "";
                 var objEditor1 = CKEDITOR.instances['<%=txtHistoDatamicro.ClientID%>'];
                 Microscopic = objEditor1.getData();
                 if (Microscopic.trim() == "null" || Microscopic.trim() == "<br />") {
                     Microscopic = "";
                 }


                 var Impression = "";
                 var objEditor2 = CKEDITOR.instances['<%=txtHistoDatafinal.ClientID%>'];
                 Impression = objEditor2.getData();
                 if (Impression.trim() == "null" || Impression.trim() == "<br />") {
                     Impression = "";
                 }


                 if (type == "Gross" && Gross == "") {
                     showerrormsg("Please Enter Gross");
                     return;
                 }

                 if (type == "Microscopic" && Microscopic == "") {
                     showerrormsg("Please Enter Microscopic");
                     return;
                 }

                 if (type == "Impression" && Impression == "") {
                     showerrormsg("Please Enter Impression");
                     return;
                 }

                 $('#<%=txttemptype.ClientID%>').val(type);
                 $('#<%=txttemname.ClientID%>').val('');
                 $find("<%=ModalPopupExtender3.ClientID%>").show();
             }

             function savedataastemple() {
                 if ($('#<%=txttemptype.ClientID%>').val() == "") {
                     showerrormsg("Please Enter Template Type");
                     return;
                 }
                 if ($('#<%=txttemname.ClientID%>').val() == "") {
                     showerrormsg("Please Enter Template Name");
                     $('#<%=txttemname.ClientID%>').focus();
                     return;
                 }


                 var Type = $('#<%=txttemptype.ClientID%>').val();
                 var TemplateName = $('#<%=txttemname.ClientID%>').val();

                 var TemplateData="";

                 if (Type == "Gross")
                 {
                    
                     var objEditor = CKEDITOR.instances['<%=txtHistoDatagross.ClientID%>'];
                     TemplateData = objEditor.getData();
                 }
                 if (Type == "Microscopic")
                 {
                     var objEditor = CKEDITOR.instances['<%=txtHistoDatamicro.ClientID%>'];
                     TemplateData = objEditor.getData();
                 }
                 if (Type == "Impression")
                 {
                     var objEditor = CKEDITOR.instances['<%=txtHistoDatafinal.ClientID%>'];
                     TemplateData = objEditor.getData();
                 }
                
                 $.ajax({

                     url: "LabResultEntryNew_Histo.aspx/SaveDataAsTemplate",
                     data: JSON.stringify({ Type: Type, TemplateData: TemplateData, TemplateName: TemplateName }), // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {

                       
                         if (result.d != "1") {
                             showerrormsg("Record not Saved");
                         }
                         else {

                             showmsg("Template Saved");
                             $find("<%=ModalPopupExtender3.ClientID%>").hide();
                             gethistotemplate();



                         }
                       

                     },
                     error: function (xhr, status) {
                         alert(xhr.responseText);
                     }
                 });

                 
             }

             var mouseX;
             var mouseY;
             $(document).mousemove(function (e) {
                 mouseX = e.pageX;
                 mouseY = e.pageY;
             });
             function getme(testid) {
                 var url = "../../Design/Lab/showreading.aspx?TestID=" + testid;
                 $('#deltadiv').load(url);
                 $('#deltadiv').css({ 'top': mouseY, 'left': mouseX }).show();
             }
             function hideme() {
                 $('#deltadiv').hide();
             }

             function LoadInvName(LabNo) {
                 $.ajax({
                     url: "MachineResultEntry.aspx/GetPatientInvsetigationsNameOnly",
                     data: '{ LabNo:"' + LabNo + '"}', // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     async: false,
                     success: function (result) {
                         InvData = result.d;
                         $('.DivInvName').html(InvData);
                         $('.DivInvName').show();
                     },
                     error: function (xhr, status) {
                         // alert("Error.... ");
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }



             function openpopup6() {
                 var labno = $('#labno').html();
                 if (labno == "") {
                     showerrormsg("Please Search Patient");
                     return;
                 }
                 window.open('../Lab/AddFileRegistration.aspx?labno=' + labno, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
             }
             function openpopup7() {
                 var labno = $('#labno').html();
                 if (labno == "") {
                     showerrormsg("Please Search Patient");
                     return;
                 }
                 var TestName = $('#lbtestname').html();                
                 serverCall('LabResultEntryNew_Histo.aspx/PostRemarksData1', { TestID: TestID, TestName: TestName, VisitNo: labno }, function (response) {
                     $responseData = JSON.parse(response);
                     var href = "../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + $responseData.TestID + "&TestName='" + $responseData.TestName + "&VisitNo=" + $responseData.VisitNo;

                     $.fancybox({
                         maxWidth: 860,
                         maxHeight: 800,
                         fitToView: false,
                         width: '65%',
                         height: '70%',
                         href: href,
                         autoSize: false,
                         closeClick: false,
                         openEffect: 'none',
                         closeEffect: 'none',
                         'type': 'iframe'
                     });

                     // window.open("../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + $responseData.TestID + "&TestName='" + $responseData.TestName + "&VisitNo=" + $responseData.VisitNo + "", null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
                 });
              //   var oo = "../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + TestID + "&TestName='" + $('#lbtestname').html() + "&VisitNo=" + labno;
               //  window.open(oo, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

                 //window.open('../Lab/ShowRemarks.aspx?labno=' + labno, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
             }


             var isApproval = '<%=isApproval %>';
             var TestID = '<%=TestID %>';
             var LabNo = '<%=LabNo %>';
             var PatinetID = '<%= PatinetID%>';
             var Year='<%=Year %>';
             var Month = '<%=Month%>';

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

             function unloadPopupBox() {    // TO Unload the Popupbox
                
                 $('#popup_box').fadeOut("slow");
                 $("#Pbody_box_inventory").css({ // this is just for style        
                     "opacity": "1"
                 });
                 //$('#showpopupmsg').html('');
             }


             function printme() {
                 unloadPopupBox();
                 printhisto();
             }
             $(document).ready(function () {


               
                 LoadInvName($('#labno').html());

                 gethistotemplate();


             });



             function gethistotemplate() {

                 var _val = "";
                 $('#ddlGrossing option').remove();
                 $('#ddlMicroscopic option').remove();
                 $('#ddlImpression option').remove();

                 $('#ddlGrossing').append($("<option></option>").val("0").html("Select"));
                 $('#ddlMicroscopic').append($("<option></option>").val("0").html("Select"));
                 $('#ddlImpression').append($("<option></option>").val("0").html("Select"));

                 var favonly = "0";
                 if ($('#favonly').is(':checked'))
                     favonly = '1';

                

                 $.ajax({


                     url: "LabResultEntrynew_Histo.aspx/LoadSpecimenTemplate",
                     data: '{favonly:"' + favonly + '"}', // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         var template_list = $.parseJSON(result.d);

                         for (var k = 0; k < template_list.length; k++) {

                             if (template_list[k].Gross == "1")
                                 $('#ddlGrossing').append('<option value="' + template_list[k].Template_ID + '">' + template_list[k].Template_Name + '</option>');

                             if (template_list[k].MicroScopic == "1")
                                 $('#ddlMicroscopic').append('<option value="' + template_list[k].Template_ID + '">' + template_list[k].Template_Name + '</option>');

                             if (template_list[k].Impression == "1")
                                 $('#ddlImpression').append('<option value="' + template_list[k].Template_ID + '">' + template_list[k].Template_Name + '</option>');

                         }

                         
                     },
                     error: function (xhr, status) {
                         
                         //alert("Error.... ..");
                         //window.status = status + "\r\n" + xhr.responseText;
                     }
                 });

             }

             function getTemplateHisto(type) {
                 var _val = $('#ddl' + type).val();

                 $.ajax({

                     url: "LabResultEntrynew_Histo.aspx/getTemplateHisto",
                     data: '{Template_ID:"' + _val + '",Type:"' + type + '"}', // parameter map
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     async: false,
                     success: function (result) {


                         var template_list = $.parseJSON(result.d);




                         if (template_list.length == 1) {
                             if (type == "Grossing") {

                                 var objEditor = CKEDITOR.instances['<%=txtHistoDatagross.ClientID%>'];
                            //objEditor.setHtml('');
                            objEditor.insertHtml(template_list[0].Template);
                            // objEditor.setData(template_list[0].Template);
                        }
                        else if (type == "Microscopic") {
                            var objEditor = CKEDITOR.instances['<%=txtHistoDatamicro.ClientID%>'];
                            objEditor.insertHtml(template_list[0].Template);
                            //objEditor.setData(template_list[0].Template);
                        }
                        else if (type == "Impression") {
                            var objEditor = CKEDITOR.instances['<%=txtHistoDatafinal.ClientID%>'];
                                objEditor.insertHtml(template_list[0].Template);
                            // objEditor.setData(template_list[0].Template);
                            }

                }

                },
                error: function (xhr, status) {
                  //  alert("Error.... ..");
                    //window.status = status + "\r\n" + xhr.responseText;
                }
            });
    }


  function printhisto() {
        var PHeader = $("#chkheader").is(':checked') ? 1 : 0;
        window.open('labreportnewhisto.aspx?TestID=<%=TestID%>&PHead=' + PHeader + '');
  }


        function SaveReport(type) {
            if (TestID == "")
                return;


            var SpecimenID = "0";
            var SpecimenName = $('#<%=txtspecimen.ClientID%>').val();
            if (SpecimenName == "") {

               // alert("Please Enter Specimen..!");
               // $('#<%=txtspecimen.ClientID%>').focus();
               // return;
            }

            var Detail = "";
            var objEditor5 = CKEDITOR.instances['<%=txtimage.ClientID%>'];
            Detail = objEditor5.getData();
            if (Detail.trim() == "null" || Detail.trim() == "<br />") {
                Detail = "";
            }

            var Gross = "";
            var objEditor = CKEDITOR.instances['<%=txtHistoDatagross.ClientID%>'];
            Gross = objEditor.getData();
            if (Gross.trim() == "null" || Gross.trim() == "<br />") {
                Gross = "";
            }
            var Microscopic = "";
            var objEditor1 = CKEDITOR.instances['<%=txtHistoDatamicro.ClientID%>'];
            Microscopic = objEditor1.getData();
            if (Microscopic.trim() == "null" || Microscopic.trim() == "<br />") {
                Microscopic = "";
            }


            var Impression = "";
            var objEditor2 = CKEDITOR.instances['<%=txtHistoDatafinal.ClientID%>'];
            Impression = objEditor2.getData();
            
            if (Impression.trim() == "null" || Impression.trim() == "<br />" || Impression=="") {
                Impression = "";
                //showerrormsg('Please enter Final Impression');
                //return;
            }
            var Advice = $('#<%=txtcomment.ClientID%>').val();
            var typeofreport = $("#<%=rdtype.ClientID%>").find('input[checked]').val();
            var pendingreason = $('#<%=ddlpending.ClientID%> option:selected').text();
            if (type == "1" && $('#<%=ddlpending.ClientID%>').val() == "0") {
                alert("Please Select Pending Reason..!");
                $('#<%=ddlpending.ClientID%>').focus();
                return;
            }
            var clinicalhistory = $('#<%=txtclinicalhistory.ClientID%>').val().trim();
            if (clinicalhistory == "")
            {
                //showerrormsg('Please enter Clinical History');
                //return;
            }

           
            //alert("hi");
            $.ajax({

                url: "LabResultEntryNew_Histo.aspx/SaveHistoReport",
                data: JSON.stringify({ Test_ID: TestID, LedgerTransactionNo: LabNo, Patient_ID: PatinetID, Specimen_ID: SpecimenID, Specimen_Title: SpecimenName, Detail: Detail, Gross: Gross, Microscopic: Microscopic, Impression: Impression, Advice: Advice,clinicalhistory:clinicalhistory, type: type, typeofreport: typeofreport, pendingreason: pendingreason }), // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "1") {
                        
                        showerrormsg("Record not Saved");
                       
                    }
                    else {
                        
                        $('#showpopupmsg').show();
                        $('#showpopupmsg').html("Report Saved..!<br/>Do You Want To Print Provisional Report?");
                        $('#popup_box').fadeIn("slow");
                        $("#Pbody_box_inventory").css({
                            "opacity": "0.3"
                        });

                       

                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                    
                }
            });



        }


             function NotApproved() {
                 $('#<%=txtnotappremarks.ClientID%>').val('');
                 $find('mpnotapprovedrecord').show();
                 $('#<%=txtnotappremarks.ClientID%>').focus();

                 //resultStatus = "Not Approved";
                 //SaveLabObs();
             }

             function NotApprovedFinaly() {
                 if ($('#<%=txtnotappremarks.ClientID%>').val() == "") {
                     $('#<%=txtnotappremarks.ClientID%>').focus();
                     showerrormsg("Please Enter Not Approved Remarks");
                     return;
                 }
                 $find('mpnotapprovedrecord').hide();
                 FinalDone('0');

             }

             function showerrormsg(msg) {
                 $('#msgField').html('');
                 $('#msgField').append(msg);
                 $(".alert").css('background-color', 'red');
                 $(".alert").removeClass("in").show();
                 $(".alert").delay(1500).addClass("in").fadeOut(1000);
             }

             function FinalDone(Approved) {

                 if (TestID == "")
                     return;


                 var SpecimenID = "0";
                 var SpecimenName = $('#<%=txtspecimen.ClientID%>').val();
            if (SpecimenName == "") {

              //  alert("Please Enter Specimen..!");
              //  $('#<%=txtspecimen.ClientID%>').focus();
              //  return;
            }

            var Detail = "";
            var objEditor5 = CKEDITOR.instances['<%=txtimage.ClientID%>'];
            Detail = objEditor5.getData();
            if (Detail.trim() == "null" || Detail.trim() == "<br />") {
                Detail = "";
            }

            var Gross = "";
            var objEditor = CKEDITOR.instances['<%=txtHistoDatagross.ClientID%>'];
            Gross = objEditor.getData();
            if (Gross.trim() == "null" || Gross.trim() == "<br />") {
                Gross = "";
            }
            var Microscopic = "";
            var objEditor1 = CKEDITOR.instances['<%=txtHistoDatamicro.ClientID%>'];
            Microscopic = objEditor1.getData();
            if (Microscopic.trim() == "null" || Microscopic.trim() == "<br />") {
                Microscopic = "";
            }


            var Impression = "";
            var objEditor2 = CKEDITOR.instances['<%=txtHistoDatafinal.ClientID%>'];
            Impression = objEditor2.getData();
            if (Impression.trim() == "null" || Impression.trim() == "<br />") {
                Impression = "";
                //showerrormsg('Please enter Final Impression');
               // return;

            }
            var Advice = $('#<%=txtcomment.ClientID%>').val();
            var typeofreport = $("#<%=rdtype.ClientID%>").find('input[checked]').val();
                 var pendingreason = $('#<%=ddlpending.ClientID%> option:selected').text();
                 var type = "0";

                 var notapprovalcomment = $.trim($("#<%=txtnotappremarks.ClientID%>").val());

               
                 var clinicalhistory = $('#<%=txtclinicalhistory.ClientID%>').val().trim();    
                 if (clinicalhistory=="")
                 {
                     //showerrormsg('Please Enter Clinical History');
                    // return;
                 }


                
            $.ajax({

                url: "LabResultEntryNew_Histo.aspx/FinalDone",

                data: JSON.stringify({ Test_ID: TestID, LedgerTransactionNo: LabNo, Patient_ID: PatinetID, Specimen_ID: SpecimenID, Specimen_Title: SpecimenName, Detail: Detail, Gross: Gross, Microscopic: Microscopic, Impression: Impression, Advice: Advice,clinicalhistory:clinicalhistory, type: type, typeofreport: typeofreport, pendingreason: pendingreason, Approved: Approved, notapprovalcomment: notapprovalcomment }),


               
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    //con = jQuery.parseJSON(result.d);
                    if (result.d == "0") {
                        showerrormsg("Report finalization can't be done, Kindly do grossing first !");
                        return;
                    }
                    else if (result.d == "1") {
                        
                        if (Approved == "1") {
                            $("#btnApproveReport").attr('disabled', true);
                            $("#btnApproveReport").css('color', 'red');
                            
                            $("#btnGrossApprove").attr('disabled', true);
                            $('#showpopupmsg').show();
                            $('#showpopupmsg').html("Report Approved..!<br/>Do You Want To Print Final Report?");
                            $('#popup_box').fadeIn("slow");
                            $("#Pbody_box_inventory").css({
                                "opacity": "0.3"
                            });
                        }
                        else {
                            showmsg("Report Not Approval Done..!");

                            $('#btnnotapp').hide();
                            $("#btnApproveReport").attr('disabled', false);
                            $("#btnApproveReport").css('color', 'black');
                            $("#btnGrossApprove").attr('disabled', false);
                        }




                    }
                    else {
                        
                        showerrormsg(result.d);
                    }

                },
                error: function (xhr, status) {
                    //alert("Error.... ");
                    
                    $(":input").attr("disabled", false);

                    //window.status = status + "\r\n" + xhr.responseText;
                }

            });


        }

        function openmypopup() {
            var labno = LabNo;
            var testid = TestID;
            window.open('../Lab/PatientSampleinfoPopup.aspx?TestID=' + testid + '&LabNo=' + labno, null, 'left=150, top=100, height=500, width=900, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
        }
        function openmypopup1() {
            var labno = LabNo;
            var testid = TestID;
            window.open('../Lab/SampleCollectionHisto.aspx?TestID=' + testid + '&LabNo=' + labno, null, 'left=50, top=40, height=600, width=1300, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');



        }



        function openmypopup2() {
            var labno = LabNo;
            var testid = TestID;
            window.open('../Lab/HistoImmunoChemistry.aspx?TestID=' + testid + '&LabNo=' + labno, null, 'left=50, top=40, height=600, width=1300, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
        }
        function setmydata() {

            var type = $("#<%=rdtype.ClientID%>").find('input[checked]').val();

            if (type == "0") {
                $("#<%=ddlpending.ClientID%>").attr('selectedIndex', 0);
                $("#<%=ddlpending.ClientID%>").attr('disabled', true);
            }
            else if (type == "1") {
                $("#<%=ddlpending.ClientID%>").attr('selectedIndex', 0);
                $("#<%=ddlpending.ClientID%>").attr('disabled', false);
            }

    }
    function closeme() {
        this.close();
    }

    


    </script>


        <script type="text/javascript">
            var editor1 = "";
            function getCurrentDateData() {
                var d = new Date()
                formattedDate = d.getFullYear() + '' + d.getMonth() + '' + d.getDate() + d.getHours() + d.getMinutes() + d.getSeconds() + '<%=Session["ID"]%>';;
                return formattedDate;

            }
            $(function () {

                editor1 = document.getElementById('<% = txtimage.ClientID%>'); 
                $("#divimgpopup").dialog({
                    title: 'Crop Image',
                    autoOpen: false,
                    modal: true,
                    width: '900',
                    height: '800'

                });
                $("#file_upload").uploadify({
                    'height': 15,
                    'swf': '../../Scripts/uploadify/uploadify.swf',
                    'uploader': '../../Scripts/uploadify/FileUpload.aspx?name=' + getCurrentDateData(),
                    'onUploadSuccess': function (file, data, response) {
                        image = file;
                        ImgTag = '<img id="bigimg" border="0"  src="https://lims.lupindiagnostics.com/LupinImages/HistoUploads/' + Year + '/' + Month + '/' + formattedDate + '_' + file.name + '"  />&nbsp;<br/>';
                        //ImgTag = '<img id="bigimg" border="0"  src="../../HistoUploads/' + Year + '/' + Month + '/' + formattedDate + '_' + file.name + '"  />&nbsp;<br/>';
                        $("#imgpopup").html(ImgTag);
                        $("#divimgpopup").dialog('open');

                        $("#bigimg").Jcrop({

                            onSelect: storeCoords

                        });


                      


                    }
                });
            });

            function storeCoords(c) {

                $('#X').val(c.x);

                $('#Y').val(c.y);

                $('#W').val(c.w);

                $('#H').val(c.h);

            };

            function crop() {

                if ($("#<%=W.ClientID %>").val() == "" || $("#<%=H.ClientID %>").val() == "" || $("#<%=X.ClientID %>").val() == "" || $("#<%=Y.ClientID %>").val() == "") {
                    ImgTag = '<img  src="' + $("#bigimg").attr("src") + '"  />&nbsp;<br/>';
                    var objEditor1 = CKEDITOR.instances['<%=txtimage.ClientID%>'];               
                    objEditor1.insertHtml(ImgTag);
                    $("#divimgpopup").dialog('close');
                    showmsg("Cropped Successfully.");
                }
                else {



                    $.ajax({
                        url: "LabResultEntryNew_Histo.aspx/Crop",
                        data: '{ W: "' + $("#<%=W.ClientID %>").val() + '",H: "' + $("#<%=H.ClientID %>").val() + '",X: "' + $("#<%=X.ClientID %>").val() + '",Y:"' + $("#<%=Y.ClientID %>").val() + '",ImgPath:"' + $("#bigimg").attr("src") + '"}', // parameter map 
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        success: function (result) {

                            ImgTag = '<img  src="../../HistoUploads/' + Year + '/' + Month + '/' + result.d + '"  />&nbsp;<br/>';
                            var objEditor1 = CKEDITOR.instances['<%=txtimage.ClientID%>'];
                            objEditor1.insertHtml(ImgTag);
                            $("#divimgpopup").dialog('close');
                            showmsg("Cropped Successfully.");
                            $("#<%=W.ClientID %>").attr("value", "");
                            $("#<%=H.ClientID %>").attr("value", "");

                        },
                        error: function (xhr, status) {
                            showerrormsg("Error..");
                        }
                    });
                }
            }

            function closeme11() {
                var objEditor1 = CKEDITOR.instances['<%=txtimage.ClientID%>'];
                objEditor1.insertHtml("");
                $("#divimgpopup").dialog('close');
              
            }

        </script>

        <script type="text/javascript">
            function reslide() {
                getblockdetailsaved(TestID);
                $('#ddloption').attr('selectedIndex', 0);
                $find("<%=ModalPopupExtender1.ClientID%>").show();
            }



            function getblockdetailsaved(testid) {
                $('#noofblockslidesaved option').remove();

                $.ajax({
                    url: "LabResultEntryNew_Histo.aspx/getdetailblock",
                    data: '{testid:"' + testid + '" }', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 130000,
                    dataType: "json",
                    success: function (result) {
                        PatientDataGross = $.parseJSON(result.d);
                        if (PatientDataGross.length == 0) {
                            $('#noofblockslidesaved').append($("<option></option>").val('-').html('-'));
                        }
                        for (var a = 0; a < PatientDataGross.length; a++) {
                            $('#noofblockslidesaved').append($("<option></option>").val(PatientDataGross[a].blockid).html(PatientDataGross[a].value));

                        }
                        getdetaildatablock();
                    },
                    error: function (xhr, status) {

                        StatusOFReport = "";
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });


            }


            function getdetaildatablock() {
                var blockid = $('#noofblockslidesaved').val();
                var testid = TestID;
                $.ajax({
                    url: "LabResultEntryNew_Histo.aspx/getdetaildatablock",
                    data: '{testid:"' + testid + '",blockid:"' + blockid + '" }', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 130000,
                    dataType: "json",
                    success: function (result) {
                        PatientDataGross1 = $.parseJSON(result.d);

                        $("#Table4").find("tr:not(:first)").remove();

                        for (var a = 0; a <= PatientDataGross1.length - 1; a++) {
                            var mydata = '<tr style="background-color:white;height:30px;" id=' + PatientDataGross1[a].labno + '_' + PatientDataGross1[a].blockid + '_' + PatientDataGross1[a].slideno + '>';
                            mydata += '<td>' + parseFloat(a + 1) + '</td>';
                            mydata += '<td id="labno" align="left">' + PatientDataGross1[a].labno + '</td>';
                            mydata += '<td id="BlockID" align="left">' + PatientDataGross1[a].blockid + '</td>';
                            mydata += '<td id="slideno" align="left">' + PatientDataGross1[a].slideno + '</td>';
                         
                                mydata += '<td id="comment"><input type="text" id="txtcomment" style="width:100px;" value="' + PatientDataGross1[a].slidecomment + '"/></td>';
                            


                           
                                mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow3(this)"/></td>';
                            
                            mydata += '</tr>';
                            $('#Table4').append(mydata);
                        }
                    },
                    error: function (xhr, status) {


                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });


            }

            function deleterow3(itemid) {
                var table = document.getElementById('Table4');
                table.deleteRow(itemid.parentNode.parentNode.rowIndex);

            }

            function makeslidessaved() {
                if (TestID == '') {
                    showerrormsg("Please Select Patient..!");
                    return;
                }
               

                if ($('#noofblockslidesaved').val() == '') {
                    showerrormsg("Please Select Block..!");
                    $('#noofblockslidesaved').focus();
                    return;
                }
                if ($('#stfromslidesaved').val() == '') {
                    showerrormsg("Please Select No of Slides From..!");
                    $('#stfromslidesaved').focus();
                    return;
                }
                $("#Table4").find("tr:not(:first)").remove();
                for (var a = 0; a < parseInt($('#stfromslidesaved').val()) ; a++) {


                    var a = $('#Table4 tr').length - 1;
                    var mydata = '<tr style="background-color:white;height:30px;" id=' + $('#SlideNo').html() + '_' + $('#noofblockslidesaved').val() + '_' + parseFloat(a + 1) + '>';
                    mydata += '<td>' + parseFloat(a + 1) + '</td>';
                    mydata += '<td id="labno" align="left">' + $('#lbsecno').html() + '</td>';
                    mydata += '<td id="BlockID" align="left">' + $('#noofblockslidesaved option:selected').val() + '</td>';
                    mydata += '<td id="slideno" align="left">' + parseFloat(a + 1) + '</td>';
                    mydata += '<td id="comment"><input type="text" id="txtcomment" style="width:100px;"/></td>';
                    mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow3(this)"/></td>';
                    mydata += '</tr>';
                    $('#Table4').append(mydata);

                }
            }

            function resetdataslide() {
                $find("<%=ModalPopupExtender1.ClientID%>").hide();
               
            }


            function savedataslide() {
                if ($('#Table4 tr').length == "1" || $('#Table4 tr').length == 0) {
                    showerrormsg("Please Make Slides..!");
                    $('#Button2').focus();
                    return;
                }
                if ($('#ddloption').val() == '0') {
                    showerrormsg("Please Select Option..!");
                    $('#ddloption').focus();
                    return;
                }
                var mydataadj = getcompletedataslides();

                $.ajax({
                    url: "LabResultEntryNew_Histo.aspx/savedataslide",
                    data: JSON.stringify({ mydataadj: mydataadj }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 130000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {


                            if ($('#noofblockslidesaved option:selected').val() != $('#noofblockslidesaved option:last-child').val()) {
                                showmsg("First Block's Slides Saved Successfully Move To Next..!");
                                $('#noofblockslidesaved option:selected').next().prop('selected', 'selected');
                                $("#Table4").find("tr:not(:first)").remove();
                                $("#stfromslidesaved").prop('selectedIndex', 0);
                                $('#Button2').focus();
                            }
                            else {
                                showmsg("All Slides Saved Successfully..!");
                                $find("<%=ModalPopupExtender1.ClientID%>").hide();

                            }
                        }
                        else {
                            alert(result.d);
                        }

                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
                    }
                });

            }

            function getcompletedataslides() {
                var tempData = [];
                $('#Table4 tr').each(function () {
                    if ($(this).attr("id") != "headerslide") {
                        var itemmaster = [];
                        itemmaster[0] = TestID;
                        itemmaster[1] = $(this).find("#labno").html();
                        itemmaster[2] = $(this).find("#BlockID").html();
                        itemmaster[3] = $(this).find("#slideno").html();
                        itemmaster[4] = $(this).find("#txtcomment").val();
                        itemmaster[5] = $('#ddloption').val();
                        tempData.push(itemmaster);
                    }
                });
                return tempData;
            }


            function Forward() {

                $("#<%=ddlcentre.ClientID %> option").remove();
                var ddlcentre = $("#<%=ddlcentre.ClientID %>");
                $.ajax({
                    url: "LabResultEntryNew_Histo.aspx/BindCentreToForward",
                    data: '{}', // parameter map 
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {

                        Cdata = $.parseJSON(result.d);
                        for (i = 0; i < Cdata.length; i++) {

                            ddlcentre.append($("<option></option>").val(Cdata[i]["centreid"]).html(Cdata[i]["centre"]));
                        }

                    },
                    error: function (xhr, status) {



                    }
                });

                binddoctoforward();


                $find("<%=ModalPopupExtender2.ClientID%>").show();
            }

            function binddoctoforward() {
                $("#<%=ddldoc.ClientID %> option").remove();
                  var ddlforward = $("#<%=ddldoc.ClientID %>");
                  $.ajax({
                      url: "LabResultEntryNew_Histo.aspx/BindDoctorToForward",
                      data: '{centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    Fdata = $.parseJSON(result.d);
                    for (i = 0; i < Fdata.length; i++) {

                        ddlforward.append($("<option></option>").val(Fdata[i]["employeeid"]).html(Fdata[i]["Name"]));
                    }

                },
                error: function (xhr, status) {



                }
            });
        }

            function Forwardme() {
                var length2 = $('#<%=ddlcentre.ClientID %>  option').length;
                if ($("#<%=ddlcentre.ClientID %> option:selected").val() == "" || length2 == 0) {
                 
                    showerrormsg("Please Select Centre");
                  
                    $("#<%=ddlcentre.ClientID %>").focus();
                return;
            }

            var length3 = $('#<%=ddldoc.ClientID %>  option').length;


                if ($("#<%=ddldoc.ClientID %> option:selected").val() == "" || length3 == 0) {
                    
                    showerrormsg("Please Select Doctor to Forward");
                   
                    $("#<%=ddldoc.ClientID %>").focus();
                return;
            }


                $.ajax({
                    url: "LabResultEntryNew_Histo.aspx/Forward",
                    data: '{ testid: "' + TestID + '",doc: "' + $('#<%=ddldoc.ClientID%> option:selected').val() + '",centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '"}', // parameter map 
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 130000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {

                            showmsg("Forward to " + $('#<%=ddldoc.ClientID%> option:selected').text() + " Sucessfully..!");
                            $find("<%=ModalPopupExtender2.ClientID%>").hide();
                        }
                        else {
                            showerrormsg(result.d);
                        }

                    },
                      error: function (xhr, status) {
                          alert(xhr.responseText);
                      }
                  });
            }

            function AddReport() {
              
                    serverCall('MachineResultEntry.aspx/encryptData', { LedgerTransactionNo: $('#labno').html(), Test_ID: TestID }, function (response) {
                        var $responseData = jQuery.parseJSON(response);
                        window.open('AddReport.aspx?LedgerTransactionNo=' + $responseData.LedgerTransactionNo + '&Test_ID=' + $responseData.Test_ID, '', 'left=150, top=100, height=450, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

                    });
                


               // window.open('AddReport.aspx?LedgerTransactionNo=' + $('#labno').html() + '&Test_ID=' + TestID, '', 'dialogwidth:50;');
            }

        </script>
    </form>
</body>
</html>
