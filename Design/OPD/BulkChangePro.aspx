<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BulkChangePro.aspx.cs" Inherits="Design_OPD_BulkChangePro" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style>
        div#divPatient.vertical {
            width: 75%;
            height: 400px;
            background: #ffffff;
            float: left;
            overflow-y: auto;
            border-right: solid 1px gray;
        }

        div#divInvestigation.vertical {
            margin-left: 75%;
            height: 400px;
            background: #ffffff;
            overflow-y: auto;
        }

        .ht_clone_top_left_corner, .ht_clone_bottom_left_corner, .ht_clone_left, .ht_clone_top {
            z-index: 0;
        }
        /* The Modal (background) */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 999; /* Sit on top */
            padding-top: 50px; /* Location of the box */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }

        /* Modal Content */
        .modal-content {
            position: relative;
            background-color: #fefefe;
            margin: auto;
            padding: 0;
            border: 1px solid #888;
            width: 80%;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
            -webkit-animation-name: animatetop;
            -webkit-animation-duration: 0.4s;
            animation-name: animatetop;
            animation-duration: 0.4s;
        }

        /* Add Animation */
        @-webkit-keyframes animatetop {
            from {
                top: -300px;
                opacity: 0;
            }

            to {
                top: 0;
                opacity: 1;
            }
        }

        @keyframes animatetop {
            from {
                top: -300px;
                opacity: 0;
            }

            to {
                top: 0;
                opacity: 1;
            }
        }

        /* The Close Button */
        .close {
            color: white;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

            .close:hover,
            .close:focus {
                color: #000;
                text-decoration: none;
                cursor: pointer;
            }

        .modal-header {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }

        .modal-body {
            padding: 2px 16px;
        }

        .modal-footer {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }
        /*for color
    */


        .handsontable .htDimmed {
            color: #000000;
        }

        #div_Save {
            width: 252px;
        }

        .auto-style1 {
            width: 335px;
        }
    </style>

    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery.Jcrop.css" />
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/uploadify.css" />
    <webopt:BundleReference ID="BundleReference6" runat="server" Path="~/Content/css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <webopt:BundleReference ID="BundleReference8" runat="server" Path="~/App_Style/ResultEntryCSS.css" />
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/ResultEntry") %>




    <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackErrorMessage="Error...">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 1275px">
        <div class="POuter_Box_Inventory" style="width: 1272px">

            <div class="Purchaseheader">
                Search Option
             &nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

            </div>
            <div class="content" id="div_Search">
                
                Centre :
                <asp:DropDownList ID="ddlCentreAccess" Width="250px" runat="server" class="ddlCentreAccess chosen-select"></asp:DropDownList>
                Source Pro :
                <asp:DropDownList ID="ddlSourceProMaster" Width="250px" runat="server" class="ddlSourceProMaster chosen-select"></asp:DropDownList>

                <input id="btnSearch" type="button" value="Search" class="ItDoseButton" onclick="getMappedProRecord();" />


            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1272px">
            <div id="divPatient" class="vertical">
                  <table class="GridViewStyle" style="width: 100%;" id="tblbindMappingRecord">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" style="width: 30px;">Sq.No.</th>
                            <th class="GridViewHeaderStyle" style="width: 30px;">Check </th>
                            <th class="GridViewHeaderStyle" style="display: none;">rid </th>
                            <th class="GridViewHeaderStyle">Name</th>
                        </tr>

                    </thead>
                    <tbody>
                    </tbody>



                </table>

            </div>
            
            <div style="padding: 10px; float: left; width: 90%;">
                <table style="width: 99%">
                    <tr>
                        <td id="div_Save" style="width: 26%">
                            <asp:DropDownList ID="ddlTargetProMaster" Width="250px" runat="server" class="ddlTargetProMaster chosen-select"></asp:DropDownList>
                            &nbsp; 

                <input id="btnSave" type="button" value="Update" class="ItDoseButton" onclick="SubmitMappingRecord();" style="width: 70px; height: 25px;" />
                        </td>
                        <td style="width: 50%">
                            <input id="btnReset" type="button" value="Reset" class="ItDoseButton" onclick="ClearForm();" style="width: 70px; height: 25px;" />

                        </td>
                    </tr>
                </table>

            </div>
        </div>
    </div>

    <script type="text/javascript">


        function ClearForm() {

            window.local.reload();
        }


        function getMappedProRecord() {


            if ($("#<%=ddlCentreAccess.ClientID%>").val() == "Centre") {
                modelAlert("Please Select Centre.")
                return false;
            }


            if ($("#<%=ddlSourceProMaster.ClientID%>").val() == "Source Pro") {
                modelAlert("Please Select Pro.")
                return false;
            }

            serverCall('BulkChangePro.aspx/getMappedProDetails', {CentreID: $("#<%=ddlCentreAccess.ClientID %>").val(), ProId: $("#<%=ddlSourceProMaster.ClientID%>").val() }, function (response) {
                var data = JSON.parse(response);
                $('#tblbindMappingRecord tbody').empty();
                var count = 0;
                $.each(data, function (i, item) {
                    var Ischecked = '';
                    if (item.CheckStatus == "1") {
                        Ischecked = "checked";
                    }
                    var rows = "<tr> <td class='GridViewStyle'>" + ++count + "</td>   <td class='GridViewStyle' id='txtCheckBox'><input type='checkbox'  " + Ischecked + "  name='allCheckBox'  /> </td> <td class='GridViewStyle' id='rid' style='display:none;' >" + item.panel_id + "</td>  <td class='GridViewStyle' id='company_name'>" + item.company_name + "</td>   </tr>";
                    $('#tblbindMappingRecord tbody').append(rows);
                });

            });

        }


        function SubmitMappingRecord() {

            var count = 0;
            var mapped_array = [];
            $("#tblbindMappingRecord input[type=checkbox]:checked").each(function () {
                var row = $(this).closest("tr")[0];
                mapped_array.push({ "panel_id": row.cells[2].innerText })

                count++;
            });

            if (count == 0) {
                modelAlert("Please Check At least one record.")
                return false;
            }

            if ($("#<%=ddlTargetProMaster.ClientID%>").val() == "Target Pro") {
                modelAlert("Please Select Target Pro.")
                return false;
            }

            serverCall('BulkChangePro.aspx/InsertUpdateMappedRecord', { TargetProId: $("#<%=ddlTargetProMaster.ClientID%>").val(), Mapped_list: JSON.stringify(mapped_array) }, function (response) {
                var resData = JSON.parse(response);

                if (resData.status) {

                    modelAlert('Mapping Successfully.', function () {
                        window.location.reload()
                    })

                }
                else {
                    modelAlert(resData.Msg)
                }

            });


        }


    </script>

</asp:Content>
