<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PanelLabReportSetting.aspx.cs" Inherits="Design_Master_PanelLabReportSetting" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>

    <style type="text/css">
            #MainImages {
                width: 200px;
                height: 200px;
             }
                 #MainImages img {
                     cursor: pointer;
                     height: 90%;
                 }
            #Fullscreen {
                 width: 100%;
                 display: none;
                 position:fixed;
                 top:0;
                 right:0;
                 bottom:0;
                 left:0;
                
                 background-color:pink;
             }
             #Fullscreen img {
                display: block;
                height: 100%;
                  width: 600px;
                margin: 0 auto;
             }
        </style>

     <div id="Pbody_box_inventory" style="width:1004px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="width:1000px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center" colspan="6"><asp:Label ID="llheader" runat="server" Text="Lab Report Setting" Font-Size="16px" Font-Bold="true"></asp:Label> <br /><asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label></td>
                       
                    </tr>


                    </table>
                </div>


              </div>

          <div class="POuter_Box_Inventory" style="text-align: center;width:1000px;">
	             <div class="Purchaseheader">
	                        Panel Selection                  
	      </div>
	        <div class="content">
                <table width="99%">
                    <tr><td style="font-weight: 700; text-align: right;">Select Panel :&nbsp;&nbsp;&nbsp; </td>
                        <td style="text-align: left"><asp:DropDownList ID="ddlpanel" class="ddlpanel chosen-select chosen-container" onchange="showallvalues()" runat="server" Width="500px"></asp:DropDownList> </td>
                    </tr>
                </table>
                </div>
              </div>




           <div class="POuter_Box_Inventory" style="text-align: center;width:1000px;display:none;" id="setreport">
	             <div class="Purchaseheader">
	                        Set Report                  
	      </div>
	        <div class="content">
                <table width="99%">

                    <tr>
                        <td style="text-align: left; font-weight: 700; width: 85px;">
                            &nbsp;</td>
                        <td style="text-align: left; font-weight: 700; width: 332px;">
                            Report Header Height :
                        </td>
                        <td style="text-align: left; width: 342px;">
                            <asp:TextBox ID="txtReportHeaderHeight" runat="server" Width="80px" MaxLength="3" ></asp:TextBox>&nbsp;
                               <cc1:filteredtextboxextender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtReportHeaderHeight">
                                </cc1:filteredtextboxextender>
                            <asp:RequiredFieldValidator ID="r1" runat="server" ValidationGroup="a" ControlToValidate="txtReportHeaderHeight" ErrorMessage="*" Font-Bold="true" ForeColor="Red"></asp:RequiredFieldValidator>&nbsp;
                             <asp:RangeValidator ID="RangeValidator1" ValidationGroup="a" runat="server" ControlToValidate="txtReportHeaderHeight" MinimumValue="180" MaximumValue="250" ErrorMessage="180-250" Type="Integer" Font-Bold="true" ForeColor="Red"></asp:RangeValidator>
                        </td>
                        <td style="text-align: left" class="required">
                            * Range 180-250</td>
                        <td style="text-align: left">
                            &nbsp;</td>
                    </tr>

                    <tr>
                        <td style="text-align: left; font-weight: 700; width: 85px;">
                            &nbsp;</td>
                        <td style="text-align: left; font-weight: 700; width: 332px;">
                            Report Header X Position :
                        </td>
                        <td style="text-align: left; width: 342px;">
                            <asp:TextBox ID="txtReportHeaderXPosition" runat="server" Width="80px" MaxLength="3"></asp:TextBox>&nbsp;
                               <cc1:filteredtextboxextender ID="Filteredtextboxextender2" runat="server" FilterType="Numbers" TargetControlID="txtReportHeaderXPosition">
                                </cc1:filteredtextboxextender>
                             <asp:RequiredFieldValidator ID="r2" runat="server" ValidationGroup="a" ControlToValidate="txtReportHeaderXPosition" ErrorMessage="*" Font-Bold="true" ForeColor="Red"></asp:RequiredFieldValidator>&nbsp;
                              <asp:RangeValidator ID="RangeValidator2" ValidationGroup="a" runat="server" ControlToValidate="txtReportHeaderXPosition" MinimumValue="20" MaximumValue="25" ErrorMessage="20-25" Type="Integer" Font-Bold="true" ForeColor="Red"></asp:RangeValidator>
                        </td>
                        <td style="text-align: left" class="required">
                            * Range&nbsp;&nbsp;20-25</td>
                        <td style="text-align: left">
                            &nbsp;</td>
                    </tr>

                    <tr>
                        <td style="text-align: left; font-weight: 700; width: 85px;">
                            &nbsp;</td>
                        <td style="text-align: left; font-weight: 700; width: 332px;">
                            Report Header Y Position :</td>
                        <td style="text-align: left; width: 342px;">
                            <asp:TextBox ID="txtReportHeaderYPosition" runat="server" Width="80px" MaxLength="3"></asp:TextBox>&nbsp;
                              <cc1:filteredtextboxextender ID="Filteredtextboxextender3" runat="server" FilterType="Numbers" TargetControlID="txtReportHeaderYPosition">
                                </cc1:filteredtextboxextender>
                             <asp:RequiredFieldValidator ID="r3" runat="server" ValidationGroup="a" ControlToValidate="txtReportHeaderYPosition" ErrorMessage="*" Font-Bold="true" ForeColor="Red"></asp:RequiredFieldValidator>&nbsp;
                             <asp:RangeValidator ID="RangeValidator3" ValidationGroup="a" runat="server" ControlToValidate="txtReportHeaderYPosition" MinimumValue="50" MaximumValue="130" ErrorMessage="50-130" Type="Integer" Font-Bold="true" ForeColor="Red"></asp:RangeValidator>
                        </td>
                        <td style="text-align: left" class="required">
                            * Range&nbsp; 50-130</td>
                        <td style="text-align: left">
                            &nbsp;</td>
                    </tr>

                    <tr>
                        <td style="text-align: left; font-weight: 700; width: 85px;">
                            &nbsp;</td>
                        <td style="text-align: left; font-weight: 700; width: 332px;">
                            Report Footer Height :</td>
                        <td style="text-align: left; width: 342px;">
                            <asp:TextBox ID="txtReportFooterHeight" runat="server" Width="80px" MaxLength="3"></asp:TextBox>&nbsp;
                             <cc1:filteredtextboxextender ID="Filteredtextboxextender4" runat="server" FilterType="Numbers" TargetControlID="txtReportFooterHeight">
                                </cc1:filteredtextboxextender>
                             
                        </td>
                        <td style="text-align: left" class="required">
                            * Range&nbsp; 80-110</td>
                        <td style="text-align: left">
                            &nbsp;</td>
                    </tr>
               
                     <tr>
                        <td style="text-align: left; font-weight: 700; width: 85px;">
                            &nbsp;</td>
                        <td style="text-align: left; font-weight: 700; width: 332px;">
                            Show Signature :</td>
                        <td style="text-align: left; width: 342px;">
                             <asp:DropDownList ID="ddlShowSignature" runat="server"  Width="85px">
                                 <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                 <asp:ListItem Value="0">No</asp:ListItem>
                             </asp:DropDownList>
                        </td>
                        <td style="text-align: left" class="required">
                         </td>
                        <td style="text-align: left">
                            &nbsp;</td>
                    </tr>
     
                    <tr>
                        <td style="text-align: left; font-weight: 700; width: 85px;">
                            &nbsp;</td>
                        <td style="text-align: left; font-weight: 700; width: 332px;">
                            Report BackGround Image :  
                            <br />
                            
                           <br />
                            <asp:Label ID="lbname" runat="server"></asp:Label>
                            <br />  <br />
                            	<asp:FileUpload ID="fuSign" runat="server"/>
                             <br />  <br />
                            <asp:Label ID="lbpath" runat="server"></asp:Label>
                              <br />
                            
                           <br />
                              <asp:Label ID="lblrange" runat="server" CssClass="ItDoseLblError"></asp:Label>
                             <br />
                            
                           <br />
                            <asp:HiddenField ID="HiddenField1" runat="server" /> 
                             <asp:Button ID="btnDownloadLetterHead" runat="server" Text="Download Report Letter Head" OnClick="btnDownloadLetterHead_Click" />
                            
                        </td>
                        
                        <td style="text-align: left; " colspan="2">
                             <div id="MainImages">
                                  <asp:Image ID="img" runat="server"  class="myImg"  /> 
                                 </div>
                            <div id="Fullscreen">
                             <img src="" alt="" />
                                </div></td>
                        <td style="text-align: left">
                            &nbsp;</td>

                    </tr>

                    <tr>
                        <td style="text-align: center; font-weight: 700; " colspan="5">
                              <asp:CheckBox ID="chkWithOutHeader" runat="server" Text="Default Header"></asp:CheckBox> 
                        <asp:Button ID="btn" runat="server" ValidationGroup="a" Text="Save Settings"   class="searchbutton" OnClick="btn_Click" /> 
                        </td>
                    </tr>
                    </table>
                </div>
               </div>
         </div>



    <script type="text/javascript">
        
        $(function () {

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

        $(document).ready(function () {
            //your code for stuff should go here
          //  $('#Fullscreen').css('height', $(document).outerWidth() + 'px');
            //for when you click on an image
            $('.myImg').click(function () {
                var src = $(this).attr('src'); //get the source attribute of the clicked image
                $('#Fullscreen img').attr('src', src); //assign it to the tag for your fullscreen div
                $('#Fullscreen').fadeIn();
            });
            $('#Fullscreen').click(function () {
                $(this).fadeOut(); //this will hide the fullscreen div if you click away from the image. 
            });
        });

        function showallvalues() {
            if ($('#<%=ddlpanel.ClientID%> option:selected').val() == "0") {
                $('#setreport').hide();
                return;
            }

            $.ajax({
                url: "PanelLabReportSetting.aspx/GetAlldata",
                data: '{ panelid:"' + $('#<%=ddlpanel.ClientID%>').val() + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    $('#setreport').show();
                    $('#<%=txtReportHeaderHeight.ClientID%>').val(TestData[0].ReportHeaderHeight);
                    $('#<%=txtReportHeaderXPosition.ClientID%>').val(TestData[0].ReportHeaderXPosition);
                    $('#<%=txtReportHeaderYPosition.ClientID%>').val(TestData[0].ReportHeaderYPosition);
                    $('#<%=txtReportFooterHeight.ClientID%>').val(TestData[0].ReportFooterHeight);
                    $("#<%=img.ClientID%>").attr('src', '../../App_Images/ReportBackGround/' + TestData[0].ReportBackGroundImage);                 
                    $('#<%=ddlShowSignature.ClientID%>').val(TestData[0].ShowSignature);
                  
                    $('#<%=lbname.ClientID%>').text(TestData[0].ReportBackGroundImage);
                    $('#<%=lbpath.ClientID%>').text('App_Images/ReportBackGround/' + TestData[0].ReportBackGroundImage);

                    $('#<%=HiddenField1.ClientID%>').val('App_Images/ReportBackGround/' + TestData[0].ReportBackGroundImage);
                    if (TestData[0].ReportBackGroundImage == "") {
                        $('#<%=btnDownloadLetterHead.ClientID%>').hide();
					 }
					 else {
					     $('#<%=btnDownloadLetterHead.ClientID%>').show();
					 }
                   
                },
                error: function (xhr, status) {
                    console.log(xhr.responseText);
                  
                }
             });
        }

    </script>
</asp:Content>

