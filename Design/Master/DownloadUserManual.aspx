<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DownloadUserManual.aspx.cs" Inherits="Design_Master_OutSourceTestToOtherLab" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />


    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 1304px;">
        <div class="POuter_Box_Inventory" style="width: 1300px">
            <div class="content" style="text-align: center;">
                <b>Download User Manual</b>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                
            </div>
            <div class="content" style="text-align: left;font-weight:bold">
                <div class="Purchaseheader1">
                <label>User Manual</label>
            </div>
                <table width="50%">
                    <tr>
                       <td>
                           <a id="B2BUserManual" visible="false" runat="server" href="../../UserManual/B2B Manual.pdf" download>
                           B2B User Manual
                           </a>
                       </td>
                    </tr>
                    <tr>
                       <td><a id="CCUserManual"  visible="false"  runat="server"  href="../../UserManual/CC Manual.pdf" download>
                           CC User Manual
                           </a></td>
                    </tr>
                    <tr>
                       <td><a id="FCUserManual"  visible="false"  runat="server"  href="../../UserManual/FC Manual.pdf" download>
                           FC User Manual
                           </a></td>
                    </tr>
                   
                    <tr>
                       <td><a id="UserManualLaboratory"  visible="false"  runat="server"  href="../../UserManual/Laboratory.pdf" download>
                           Laboratory
                           </a></td>
                    </tr>
                    <tr>
                       <td><a id="UserManualFrontOffice"  visible="false"  runat="server"  href="../../UserManual/Front Office.pdf" download>
                           Front Office
                           </a></td>
                    </tr>
                     <tr>
                       <td><a id="UserManualLaboratoryMaster"  visible="false"  runat="server"  href="../../UserManual/Laboratory Master.pdf" download>
                           Laboratory Master
                           </a></td>
                    </tr>
                     <tr>
                       <td><a id="UserManualAccounts"  visible="false"  runat="server"  href="../../UserManual/User Manual Accounts.pdf" download>
                           User Manual Accounts
                           </a></td>
                    </tr>

                </table>
            </div>

             <div class="content" style="text-align: left;font-weight:bold">
                <div class="Purchaseheader1">
                <label>Video Link</label>
            </div>
                <table width="50%">
                    <tr>
                       <td>
                           <a id="Account" visible="false" runat="server" href="https://mega.nz/file/1xEGSSLQ#pY_rOjgq007MGtyCABS4VCf58IEFB9I2mRysdFonAJk" download target="_blank">
                           Account 
                           </a>
                       </td>
                    </tr>
                    <tr>
                       <td><a id="Laboratory"  visible="false"  runat="server"  href="https://mega.nz/file/kgEXxbiK#Qy_zWw1bPaKJSvq_lgm1c_04yhJACMgehUirRe6KFUo" download target="_blank">
                           Laboratory
                           </a></td>
                    </tr>
                    <tr>
                       <td><a id="Laboratorymaster"  visible="false"  runat="server"  href="https://mega.nz/file/FwlyiKZL#xbdBBz6ybZzwS9ep22JdnsE2ohrQ_emdP9uSoV0Zeqc" download target="_blank">
                           Laboratory Master
                           </a></td>
                    </tr>
                    <tr>
                       <td><a id="Registration"  visible="false"  runat="server"  href="https://mega.nz/file/JhNghS6C#4vW9S2pETwLyWdPi_nFvrqv6QKbKX8c1kQbyZWftXv0" download target="_blank">
                           Registration
                           </a></td>
                    </tr>

                     <tr>
                       <td><a id="SampleManagement"  visible="false"  runat="server"  href="https://mega.nz/file/El8ixY5b#CAO_kGJwc8grbV60BUVt-9v6KqZgGS3VggmH5tJx_J8" download target="_blank">
                           Sample Management
                           </a></td>
                    </tr>
                   
                </table>
            </div>
        </div>

      
    </div>
    <script type="text/javascript">


        $(document).ready(function () {
            //function DownloadUserManual() {
            //    if ($("#ddlType1 option:selected").text() == "CC")
            //        $("#hrfDownloadUserManual").attr("href", "../../UserManual/CC Manual.pdf");
            //    else if ($("#ddlType1 option:selected").text() == "B2B")
            //        $("#hrfDownloadUserManual").attr("href", "../../UserManual/B2B Manual.pdf");
            //    else if ($("#ddlType1 option:selected").text() == "FC")
            //        $("#hrfDownloadUserManual").attr("href", "../../UserManual/FC Manual.pdf");
            //    else
            //        alert('No User Manual Found');
            //}

        });


       

    </script>


</asp:Content>

