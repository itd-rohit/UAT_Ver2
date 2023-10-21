<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AbhaFacilityManagment.aspx.cs" Inherits="Design_ABHA_AbhaFacilityManagment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%-- Add content controls here --%>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

    <style>
        .pull-left {
            float: left !important;
            font-weight: bold;
        }

        .lblText {
            float: left;
            color: blue;
            font-size: 15px;
        }
    </style>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center; font-size: 20px;">
            Registration & Auth Section
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; font-size: 16px;" id="divAbhaRadioButtonSection">
            <input type="radio" value="1" id="rdbRegisterHRPHost" name="rdbType" onclick="Switchonclick()" />
            <label for="rdbRegisterHRPHost" style="font-weight: bolder; cursor: pointer;">Add Update Callback URL(Bridge URL)</label>

            <input type="radio" value="2" id="rdbRegisterFacility" name="rdbType" onclick="Switchonclick()" />
            <label for="rdbRegisterFacility" style="font-weight: bolder; cursor: pointer;">Add Update Services</label>

            <input type="radio" value="3" id="rdbFetchFacility" name="rdbType" checked="checked" onclick="Switchonclick()" />
            <label for="rdbFetchFacility" style="font-weight: bolder; cursor: pointer;">Fetch Services Data</label>

        </div>


        <div id="RegisterBridgeUrlSection" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Add & Update Callback URL
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">URL</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-15">
                    <input type="text" id="txtBridgeURL" />
                </div>
                <div class="col-md-3">
                    <input type="button" id="btnRegistercallbackurl" onclick="RegisterCallbackurl()" value="Submit" />
                </div>
            </div>



        </div>

        <div id="divAddAndUpdateServices" class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Add & Update Services
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtID" />
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtName" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlServicesType">
                        <option value="HIP" selected="selected">HIP</option>
                        <option value="HIU">HIU</option>

                    </select>
                </div>


            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Alias</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtAlias" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Status</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlStatus">
                        <option value="true" selected="selected">Active</option>
                        <option value="false">Deactivate</option>

                    </select>
                </div>
            </div>
            <div class="row" style="text-align: center">
                <input type="button" id="btnAddUpdateServices" onclick="AddAndUpdateServices()" value="Submit" />
            </div>
        </div>

        <div id="divFetchServicesSection">
        </div>





    </div>

    <script type="text/javascript">

        function RegisterCallbackurl() {

            var CallBackURl = $("#txtBridgeURL").val();

            $('#btnRegistercallbackurl').attr("disabled", true);

            serverCall('Service/ABHAM2Service.asmx/RegisterCallbackUrl', { URL: CallBackURl }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    modelAlert("URL Register successfully.")
                    Clear();
                    $('#btnRegistercallbackurl').attr("disabled", false);
                } else {

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }

                    $('#btnRegistercallbackurl').attr("disabled", false);
                }

            });
        }



        function AddAndUpdateServices() {

            var id = $("#txtID").val();
            var Name = $("#txtName").val();
            var Type = $("#ddlServicesType").val();
            var Alias = $("#txtAlias").val();
            var Status = $("#ddlStatus").val()

            $('#btnAddUpdateServices').attr("disabled", true);

            serverCall('Service/ABHAM2Service.asmx/AddAndUpdateServices', { ID: id, Name: Name, Type: Type, Alias: Alias, Status: Status }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    modelAlert("Added And Updated successfully.")
                    Clear();
                    $('#btnAddUpdateServices').attr("disabled", false);
                } else {

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }

                    $('#btnAddUpdateServices').attr("disabled", false);
                }

            });
        }



        function Clear() {
            $("#txtID").val("");
            $("#txtName").val("");
            $("#ddlServicesType").val("HIP");
            $("#txtAlias").val("");
            $("#ddlStatus").val("true")
            $("#txtBridgeURL").val("");
            $("#divFetchServicesSection").empty();
        }


        function Switchonclick() {
            Clear();
            var val = $('input[name="rdbType"]:checked').val();
            if (val == 1) {
                $("#RegisterBridgeUrlSection").show();
                $("#divAddAndUpdateServices").hide();
                $("#divFetchServicesSection").hide();
            } else if (val == 2) {
                $("#RegisterBridgeUrlSection").hide();
                $("#divAddAndUpdateServices").show();
                $("#divFetchServicesSection").hide();
            } else if (val == 3) {
                GetServices();
                $("#RegisterBridgeUrlSection").hide();
                $("#divAddAndUpdateServices").hide();
                $("#divFetchServicesSection").show();
            } else {
                $("#RegisterBridgeUrlSection").hide();
                $("#divAddAndUpdateServices").hide();
                $("#divFetchServicesSection").hide();
            }


        }

        function GetServices() {

            serverCall('Service/ABHAM2Service.asmx/GetServices', {}, function (response) {
                var responseData = JSON.parse(response);
                console.log(responseData)
                if (responseData.status) {
                    Clear();
                    BindBridgeData(responseData.response.bridge)
                    BindServicesData(responseData.response.services)
                } else {

                    if (responseData.response.details != null) {
                        modelAlert(responseData.response.details[0].message)
                    } else {
                        modelAlert(responseData.response.message)

                    }
                }

            });
        }


        $(document).ready(function () {
            Switchonclick();

        });

        function BindBridgeData(Data) {


            var divnew = '';

            var color = "";
            var fcolor = "";
            var Status = "";
            if (!Data.blocklisted) {                 
                fcolor = "#176a08";
                Status = "NO";
            } else {                
                Status = "YES";
                fcolor = "#ff0101";
            }
            divnew += '<div  id="divCallbackurl" class="POuter_Box_Inventory"> ';

            divnew += ' <div class="Purchaseheader">  Callback URL  </div> ';

            divnew += ' <div class="row"> ';
            divnew += ' <div class="col-md-2"> <label class="pull-left">ID </label> <b class="pull-right">:</b> </div>';
            divnew += ' <div class="col-md-6" > <label class="lblText">' + Data.id + '</label> </div>';
            divnew += ' <div class="col-md-2"> <label class="pull-left">Name </label> <b class="pull-right">:</b> </div>';
            divnew += ' <div class="col-md-6" > <label class="lblText">' + Data.name + '</label> </div>';
            divnew += ' <div class="col-md-2"> <label class="pull-left">URL </label> <b class="pull-right">:</b> </div>';
            divnew += ' <div class="col-md-6" > <label class="lblText">' + Data.url + '</label> </div>';
            divnew += ' </div> ';

            divnew += ' <div class="row"> ';
            divnew += ' <div class="col-md-2"> <label class="pull-left">BlockListed </label> <b class="pull-right">:</b> </div>';
            divnew += ' <div class="col-md-6" > <label style="font-weight:bolder;color:' + fcolor + '">' + Status + '</label> </div>';
          
            divnew += ' </div> ';

            divnew += ' </div>';


            $("#divFetchServicesSection").append(divnew);
        }


        function BindServicesData(Data) {




            var divnew = '';

            divnew += '<div id="divServices" class="POuter_Box_Inventory"> ';

            divnew += ' <div class="Purchaseheader"> Services  </div> ';

            divnew += '    <table class="FixedHeader" id="tblatesNews" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">';
            divnew += '     <thead>';

            divnew += '   <th class="GridViewHeaderStyle">ID</th>';
            divnew += '   <th class="GridViewHeaderStyle">Name</th>';
            divnew += '   <th class="GridViewHeaderStyle">Type</th>';
            divnew += '  <th class="GridViewHeaderStyle">Status</th>';
            divnew += '     </thead>';

            divnew += '     <tbody>';

            $.each(Data, function (i, item) {
                var color = "";
                var fcolor = "";
                var Status = "";
                if (item.active) {
                    color = "#d3f7d3";
                    fcolor = "#176a08";
                    Status = "Active";
                } else {
                    color = "#f9c8c887";
                    Status = "Deactivated";
                    fcolor = "#ff0101";
                }
                divnew += ' <tr style="background-color:'+color+'"> ';
                divnew += ' <td class="GridViewItemStyle" > <label class="lblText ">' + item.id + '</label> </td>';
                divnew += ' <td class="GridViewItemStyle" > <label class="lblText">' + item.name + '</label> </td>';
                divnew += ' <td class="GridViewItemStyle" > <label class="lblText">' + item.types.toString() + '</label> </td>';
                divnew += ' <td class="GridViewItemStyle" > <label style="color:'+fcolor+';font-weight:bolder">' + Status + '</label> </td>';
                divnew += ' </tr> ';
            });

            divnew += '   </tbody>';
            divnew += ' </table>';

            divnew += ' </div>';


            $("#divFetchServicesSection").append(divnew);


        }








    </script>

</asp:Content>
