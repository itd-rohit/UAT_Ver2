<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="CampEditMaster.aspx.cs" Inherits="Design_Master_CampEditMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div id="Pbody_box_inventory" ">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Camp Edit Master<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">
            <table style="border-collapse: collapse; width: 100%">
                <tr>
                    <td style="text-align: right; width: 20%">Camp Name :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtCampName" runat="server" MaxLength="50"    onkeyup="changeCampName()"></asp:TextBox>
                    </td>
                    <td style="text-align: right; width: 20%">&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">&nbsp;
                    </td>
                </tr>
                
                  <tr>
                    <td style="text-align: center;" colspan="4">
                        <input type="button" id="btnSearch" value="Search" onclick="SearchCamp()" class="ItDoseButton" />
                    </td>
                </tr>
                </table>
            </div>
         <div class="POuter_Box_Inventory" style="text-align: left;">
         <div id="CampOutput" style="max-height: 600px; overflow-y: auto; overflow-x: hidden;">
                <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                    <tr id="campHeader">
                        <th class="GridViewHeaderStyle" scope="col" style="width: 20px; text-align: center">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 360px; text-align: center">Camp Name</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: center">Edit</th>

                    </tr>

                </table>
            </div>
                 </div>
         </div>
    <script type="text/javascript">
        function SearchCamp() {
            PageMethods.bindCamp(jQuery.trim(jQuery("#txtCampName").val()), onCampSuccess, OnCampfailure);

        }
        function onCampSuccess(result) {
            jQuery("#tbSelected tr:not(#campHeader)").remove();
            jQuery('#tbSelected').css('display', 'block');
            var CampData = jQuery.parseJSON(result);
            for (var i = 0; i < CampData.length; i++) {
                var mydata = "<tr id='" + CampData[i].CampID + "' >";
                mydata += '<td class="GridViewItemStyle" id="tdSno">' + (i + 1) + '</td>';
                mydata += '<td class="GridViewItemStyle" id="tdCompany_Name" ><span class="clCampName" >' + CampData[i].Company_Name + '</span></td>';
                mydata += '<td class="GridViewItemStyle" id="tdPanel_ID" style="display:none">' + CampData[i].Panel_ID + '</td>';
                mydata += '<td class="GridViewItemStyle"><img src="../../App_Images/Edit.png" style="cursor:pointer;text:align:center"  onclick="editCamp(this)"/></td>';
                mydata += "</tr>";
                $('#tbSelected').append(mydata);
            }
        }
        function OnCampfailure() {

        }
        function editCamp(rowID) {
            var Panel_ID = jQuery(rowID).closest('tr').find("#tdPanel_ID").text();
            location.href = '../../Design/Master/CampMaster.aspx?Panel_ID=' + Panel_ID + '';
          
        }
    </script>
</asp:Content>

