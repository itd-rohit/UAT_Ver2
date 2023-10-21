<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" 
MaintainScrollPositionOnPostback="true" CodeFile="InvTemplate.aspx.cs" Inherits="Design_Investigation_InvTemplate" Title="Text Templates"
 enableEventValidation="false" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    
    <%: Scripts.Render("~/bundles/Chosen") %>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Create Investigation Template<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Investigation&nbsp;
            </div>
            <table style="width: 953px">
                <tr>
                    <td align="right" style="width: 126px;" valign="middle">
                        <div id="dtDept" runat="server">
                            Department :&nbsp;
                        </div>
                    </td>
                    <td align="left" style="width: 334px; height: 12px" valign="middle">
                        <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="ItDoseDropdownbox"
                            Width="376px" AutoPostBack="True" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged">
                        </asp:DropDownList></td>
                    <td align="right" style="font-size: 8pt; width: 111px; height: 12px"
                        valign="middle"></td>
                    <td align="left" style="height: 12px; width: 377px;" valign="middle"></td>
                </tr>
                <tr>
                    <td align="right" style="width: 126px; height: 13px" valign="middle">Investigation :&nbsp;</td>
                    <td align="left" style="width: 334px; height: 13px" valign="middle">
                        <asp:DropDownList ID="ddlInvestigation" runat="server" CssClass="ItDoseDropdownbox"
                            Width="376px" AutoPostBack="True" OnSelectedIndexChanged="ddlInvestigation_SelectedIndexChanged">
                        </asp:DropDownList></td>
                    <td align="right" style="font-size: 8pt; width: 111px; color: #000000; font-family: Verdana; height: 13px; text-align: left;"
                        valign="middle"></td>
                    <td align="left" style="font-weight: bold; height: 13px; width: 377px;" valign="middle"></td>
                </tr>
                <tr>
                    <td align="right" style="width: 126px; height: 13px" valign="middle">Available&nbsp;Templates&nbsp;:&nbsp;</td>
                    <td align="left" colspan="3" valign="middle">
                        <asp:GridView ID="grdTemplate" runat="server" AutoGenerateColumns="False"
                            CssClass="GridViewStyle" OnRowCommand="grdTemplate_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Temp_Head" HeaderText="Template Name">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Investigation" HeaderText="Investigation">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Reject">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandArgument='<%#Eval("Template_ID") %>'
                                            CommandName="Reject" ImageUrl="~/App_Images/Delete.gif" />

                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="False" CommandArgument='<%# Eval("Template_ID") %>'
                                            CommandName="vEdit" ImageUrl="~/App_Images/edit.png" />

                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr style="font-size: 10pt; font-family: Arial">
                    <td align="right" style="height: 14px; text-align: center;" valign="middle" colspan="4">&nbsp;</td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                New Lab-Observation
            </div>
            <table style="width: 100%" border="0">
                <tr style="display:none">
                    <td align="left" style="width: 13%;" valign="middle" colspan="2">
                        
                         Observation Name :
                 <asp:DropDownList ID="ddlLabObservation" class="ddlLabObservation  chosen-select chosen-container" onchange="getLabObsID();" Width="235px" runat="server">
                 </asp:DropDownList>
                        &nbsp;&nbsp;&nbsp;
                        Observation ID :&nbsp;
                         <asp:Label ID="lblLabObsID" runat="server"></asp:Label>     
                         &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
                        <input type="button" value="Create New Observation" class="savebutton" onclick="ShowDialog(true);" />                  
                    </td>
                   
                </tr>
                <tr>
                    <td align="right" style="width: 13%" valign="middle">Template Name :&nbsp;
                    </td>
                    <td align="right" style="width: 87%; text-align: left" valign="middle">
                        <asp:TextBox ID="txtTemplate" Width="300px" runat="Server" CssClass="ItDoseTextinputText" Visible="true" AutoCompleteType="Disabled"></asp:TextBox>
                      
                    </td>
                </tr>
                   <tr>
                    <td align="right" style="width: 13%" valign="middle">Gender :&nbsp;
                    </td>
                    <td align="right" style="width: 87%; text-align: left" valign="middle">
                   <asp:RadioButtonList ID="rblgender" Width="200px" runat="server" RepeatDirection="Horizontal">
                                     <asp:ListItem Value="B" Selected="True">Both</asp:ListItem>
                                    <asp:ListItem Value="M">Male</asp:ListItem>
                                     <asp:ListItem Value="F">Female</asp:ListItem> </asp:RadioButtonList>

                    </td>
                </tr>
                 <tr>
                    <td align="right" style="width: 13%" valign="top">
                    </td>
                    <td align="right" style="width: 100%; text-align: left" valign="middle">
                        <span style="color: red;">Note:- Font type : Verdana and Font size : 14 &nbsp;</span>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 13%" valign="top">Template Desc :&nbsp;
                    </td>
                    <td align="right" style="width: 100%; text-align: left" valign="middle">


                        <CKEditor:CKEditorControl ID="txtLimit" BasePath="~/ckeditor" runat="server" EnterMode="BR" Height="200px" Width="780px"></CKEditor:CKEditorControl>

                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 13%;" valign="middle" colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td align="right" style="width: 13%;" valign="middle"></td>
                    <td align="right" style="width: 87%; text-align: left;" valign="middle">
                        <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" Width="56px" />
                        &nbsp;&nbsp;
                         <asp:CheckBox ID="chkDefault" runat="server" Text="Set This Template as Default Template" /></td>
                </tr>
                <tr style="font-size: 10pt; font-family: Arial">
                    <td align="right" style="width: 13%;" valign="middle"></td>
                    <td align="right" style="width: 87%;" valign="middle"></td>
                </tr>
            </table>
        </div>
        <div id="output"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <div id="dialog" class="web_dialog">
            <table style="width: 100%;height:80px; border: 0px;" cellpadding="3" cellspacing="0" id="tblModifyState">  
            <tr>  
                <td class="web_dialog_title">Create New Obseravtion</td>  
                <td class="web_dialog_title align_right"><a id="btnClose" onclick="HideDialog(true);" style="cursor:pointer;">Close</a></td>  
            </tr>  
            <tr>
                <td style="text-align:right">
                     Add Observation :&nbsp;
                </td>
                <td>
                    <asp:TextBox ID="txtObservation" runat="server" Width="200px"   MaxLength="100"  ></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align:right">
                    Short Name :&nbsp;
                </td>
                <td>
                     <asp:TextBox ID="txtObsShortName" runat="server" Width="200px"  MaxLength="20"  ></asp:TextBox>  
                </td>
            </tr>
            <tr>
                <td style="text-align:right">
                    Suffix :&nbsp;
                    </td>
                <td>
                    <asp:TextBox ID="txtObsSuffix" runat="server" Width="200px"  MaxLength="10"  ></asp:TextBox> 
                </td>
                </tr>
            <tr>
                 <td style="text-align:right">
                    <asp:CheckBox ID="chkIsCulture" runat="server"  Text="IsCultureReport"/>
                </td>
                <td>
                    <asp:CheckBox ID="chkObsAnylRpt" runat="server" Text="Show in Patient Report"/>
                </td>
            </tr>
            <tr>
                <td style="text-align:right">
                    Round Off :&nbsp;
                </td>
                <td>
                    <asp:DropDownList ID="ddlRoundOff"  runat="server">
                    <asp:ListItem Value="0">0</asp:ListItem>
                    <asp:ListItem  Value="1">1</asp:ListItem>
                    <asp:ListItem  Value="2" Selected="True">2</asp:ListItem>
                    <asp:ListItem  Value="3">3</asp:ListItem>
                    <asp:ListItem  Value="4">4</asp:ListItem>
                    <asp:ListItem  Value="5">5</asp:ListItem>
                    <asp:ListItem  Value="6">6</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="text-align:right">
                    Master Gender :&nbsp;
                </td>
                <td>
                    <asp:DropDownList ID="ddlGender2" runat="server" >
         <asp:ListItem Value="B">Both</asp:ListItem>
        <asp:ListItem Value="M">Male</asp:ListItem>
         <asp:ListItem Value="F">Female</asp:ListItem>
        </asp:DropDownList>
                     <asp:CheckBox ID="chkIPrintSeparateOBS" Text="Print Separate" runat="server" /> 
                </td>
            </tr>
               <tr>
               <td>
                   <asp:CheckBox ID="chkPrintLabReport" Text="Print Lab Report" Checked="true" runat="server" />
               </td>
               <td>
                   <asp:CheckBox ID="chkAllowDubBooking" Text="Allow Duplicate Booking" runat="server" />
               </td>
           </tr>
               <tr>  
                <td  style="text-align: center;">
                     <input type="button" value="Save " class="savebutton"  onclick="AddnewObservation();" style="width:90px;" />     
                     </td>  
                <td  style="text-align: center;"> 
                    <input type="button" value="Cancel" class="savebutton"  onclick=" HideDialog(true);" style="width:90px;" /></td>  
            </tr> 
        </table>

        </div>
        <script type="text/javascript">

            $(function () {

                var Investigation_ID = '<%=InvestigationID %>';
          if (Investigation_ID != "0") {
              $('#ctl00_ddlUserName').hide();
              $('.Hider').hide();
          }
          else {


              $('#ctl00_ddlUserName').show();
              $('.Hider').show();
          }


      });</script>
        <script type="text/javascript">
            $(document).ready(function () {
                BindLabObs();
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
            function BindLabObs() {
                ddlLabOBs = $("#<%=ddlLabObservation.ClientID %>");
                $("#<%=ddlLabObservation.ClientID %> option").remove();               
                $.ajax({
                    url: "InvTemplate.aspx/BindLabObs",                   
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        LabObsData = jQuery.parseJSON(result.d);
                        if (LabObsData.length > 0) {
                            for (i = 0; i < LabObsData.length; i++) {
                                ddlLabOBs.append($("<option></option>").val(LabObsData[i].LabObservation_ID).html(LabObsData[i].Name));
                            }
                        }
                        $("#<%=ddlLabObservation.ClientID %>").trigger('chosen:updated');
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
            function getLabObsID() {
                $('#<%=lblLabObsID.ClientID%>').html('{' + $('#<%=ddlLabObservation.ClientID%>').val() + '}');
         }
        </script>
        <script type="text/javascript">
            $("#btnClose").click(function (e) {
                HideDialog();
                e.preventDefault();
            });
            function HideDialog() {
                $("#overlay").hide();
                $("#dialog").fadeOut(300);
            }
            function ShowDialog(modal, Type) {
clearData();
                $("#overlay").show();
                $("#dialog").fadeIn(300);
                if (modal) {
                    $("#overlay").unbind("click");
                }
                else {
                    $("#overlay").click(function (e) {
                        HideDialog();
                    });
                }
            }
            function AddnewObservation() {

                var RoundOff = jQuery('#<%=ddlRoundOff.ClientID %>').val();

                 if (jQuery.trim(jQuery("#<%=txtObservation.ClientID%>").val()) == "") {
                     alert("Observation Name Cannot be Blank");
                     jQuery("#<%=txtObservation.ClientID%>").focus();
             return;
         }


         if (jQuery("#<%=txtObsSuffix.ClientID%>").val().length > 6) {
                     alert("Suffix Length Cannot Be More Then 6");
                     jQuery("#<%=txtObsSuffix.ClientID%>").focus();
             return;
         }


         var IsCulture = jQuery("#<%=chkIsCulture.ClientID %>").is(':checked') ? 1 : 0;
                 var ObsAnylRpt = jQuery("#<%=chkObsAnylRpt.ClientID %>").is(':checked') ? 1 : 0;
                 var PrintSeparate = jQuery("#<%=chkIPrintSeparateOBS.ClientID %>").is(':checked') ? 1 : 0;
                 var PrintInLab = jQuery("#<%=chkPrintLabReport.ClientID %>").is(':checked') ? 1 : 0;
                 var AllowDubB = jQuery("#<%=chkAllowDubBooking.ClientID %>").is(':checked') ? 1 : 0;

                 jQuery.ajax({
                     url: "Services/MapInvestigationObservation.asmx/SaveNewObservation",
                     data: '{ ObsName: "' + jQuery("#<%=txtObservation.ClientID %>").val() + '",ShortName: "' + jQuery("#<%=txtObsShortName.ClientID %>").val() + '",Suffix: "' + jQuery("#<%=txtObsSuffix.ClientID %>").val() + '",IsCulture: "' + IsCulture + '",ObsAnylRpt: "' + ObsAnylRpt + '",RoundOff:"' + jQuery("#<%=ddlRoundOff.ClientID %>").val() + '",Gender:"' + jQuery("#<%=ddlGender2.ClientID %>").val() + '",PrintSeparate:"' + PrintSeparate + '",PrintInLabReport:"' + PrintInLab + '",AllowDuplicateBooking:"' + AllowDubB + '"}', // parameter map
             type: "POST",
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             dataType: "json",
             success: function (result) {
                 resData = jQuery.parseJSON(result.d);
                 if (resData == '0') {
                     alert('Observation Already Exist');
                     return;
                 }
                 if (resData != "Error") {
                     clearData();
                     BindLabObs();
                     HideDialog();
                 }
                 else {
                     alert('Error Occured....!');
                     return;
                 }

             },
             error: function (xhr, status) {
                 alert("Error ");
             }
         });
     }
function clearData() {
                jQuery("#<%=txtObservation.ClientID %>,#<%=txtObsShortName.ClientID %>,#<%=txtObsSuffix.ClientID %>").val('');
                jQuery("#<%=chkIsCulture.ClientID %>,#<%=chkObsAnylRpt.ClientID %>,#<%=chkIPrintSeparateOBS.ClientID %>").prop('checked', false);
                jQuery("#<%=ddlRoundOff.ClientID %>,#<%=ddlGender2.ClientID %>").prop('selectedIndex', 0);
            }
        </script>
        <style type="text/css">  
        .web_dialog_overlay  
        {  
            position: fixed;  
            top: 0;  
            right: 0;  
            bottom: 0;  
            left: 0;  
            height: 100%;  
            width: 100%;  
            margin: 0;  
            padding: 0;  
            background: #000000;  
            opacity: 0.65;  
            filter: alpha(opacity=15);  
            -moz-opacity: .15;  
            z-index: 101;  
            display: none;  
        }  
        .web_dialog  
        {  
            display: none;  
            position: fixed;             
            top: 50%;  
            left: 50%;  
            margin-left: -190px;  
            margin-top: -100px;  
            background-color: #ffffff;  
            border: 2px solid #336699;  
            padding: 0px;  
            z-index: 102;  
            font-family: Verdana;  
            font-size: 10pt;  
        }  
        .web_dialog_title  
        {  
            border-bottom: solid 2px #336699;  
            background-color: #336699;  
            padding: 4px;  
            color: White;  
            font-weight: bold;  
        }  
        .web_dialog_title a  
        {  
            color: White;  
            text-decoration: none;  
        }  
        .align_right  
        {  
            text-align: right;  
        }  
    </style> 
</asp:Content>

