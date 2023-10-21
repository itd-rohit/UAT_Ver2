<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="ViewInterfaceCompany.aspx.cs" Inherits="Design_Master_ViewInterfaceCompany" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
       <%: Scripts.Render("~/bundles/confirmMinJS") %>
     <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <style type="text/css">
        #showData th {
            background-color: #09f;
            color: #fff;
            padding: 5px;
            border: 1px solid #ccc;
        }

        #showData td {
            background-color: #fff;
            color: #000;
            padding: 5px;
            border: 1px solid #ccc;
            text-align: left;
            font-size: 11px;
        }
    </style>

    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div id="divCompany">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b>View Interface Company</b>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Filter</div>

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Company Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlCompany" class="ddlCompany chosen-select" runat="server"></asp:DropDownList>
                    </div>
                    <div class="col-md-1">
                        <input type="button" value="Search" class="searchbutton" onclick="Search()" /></div>
                    <div class="col-md-1">
                        <input type="button" value="Edit" class="searchbutton" id="btnEdit" style="display: none;" onclick="Edit()" /></div>
                    <div class="col-md-1">
                        <input type="button" value="Remove" class="searchbutton" id="btnRemove" style="display: none;" onclick="Remove()" /></div>
                    <div class="col-md-2">
                        <input type="button" value="Tag More Centre" class="searchbutton" id="btnAddTagging" style="display: none;" onclick="ShowModel()" /></div>
                    <div class="col-md-4">
                        <a style="float: right; font-weight: 600;"
                            href="../../Uploaded Document/PDFDownload.aspx.zip">Download Documents</a>
                    </div>
                </div>
            </div>
            <div id="divSearch" class="POuter_Box_Inventory" style="display: none;">
                <div class="Purchaseheader">Company Detail</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Company Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblCompanyName" runat="server" Style="text-transform: uppercase"></asp:Label>
                        <asp:HiddenField ID="hdnId" runat="server" />
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">API User Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblAPIUserName" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">API Password</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblAPIPassword" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-5">
                        <input type="checkbox" id="chkIsWorkOrderIDCreate" disabled="disabled" /><span><strong>Visit No Generate in LIS</strong></span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-21">
                        <p style="font-weight: 500; color: #000; font-size: 12px; line-height: 0em; opacity: 0.7; padding-left: 20px;">(If you untick the option then same visit number will follow in LIS application)</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-21">
                        <input type="checkbox" id="chkIsPatientIDCreate" /><span><strong>Patient ID Generate in LIS</strong></span>

                    </div>
                    <div class="col-md-5">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-21">
                        <p style="font-weight: 500; color: #000; font-size: 12px; line-height: 0em; opacity: 0.7; padding-left: 20px;">(If you untick the option then same Patient ID will follow in LIS application)</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-21">
                        <input type="checkbox" id="chkAllowPrint" disabled="disabled" /><span><strong>Confirmation Required to Generate PDF of Lab Report</strong></span>
                    </div>


                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-21">
                        <input type="checkbox" id="chkLetterHead" disabled="disabled" /><span><strong>LetterHead in Lab Report</strong></span>
                    </div>


                </div>
                 <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-21">
                        <input type="checkbox" id="chkBarCodeRequired" /><span><strong>Barcode Required </strong></span>
                    </div>

</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-21">
                        <input type="checkbox" id="chkItemIDAsItdose" /><span><strong>ItemID As Itdose </strong></span>
                    </div>

</div>
                 <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-21">
                        <p style="font-weight: 500; color: #000; font-size: 12px; line-height: 0em; opacity: 0.7; padding-left: 20px;">(If you untick the option then item mapping required with Company Name in LIS application)</p>
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input type="button" value="Update" id="btnUpdate" style="display: none;" class="searchbutton" onclick="Update()" />
                </div>

                <div class="Purchaseheader">Centre Tagging</div>
                <table id="tblCentreData" style="width: 100%" class="GridViewStyle">
                    <tr>
                        <th class="GridViewHeaderStyle" style="width:30px">S.No.</th>
                        <th class="GridViewHeaderStyle" style="width:100px">Business Zone</th>
                        <th class="GridViewHeaderStyle" style="width:160px">Centre</th>
                        <th class="GridViewHeaderStyle" style="width:160px">Client</th>
                        <th class="GridViewHeaderStyle" style="width:100px">Centre Id Interface</th>
                        <th class="GridViewHeaderStyle" style="width:100px">Centre Code Interface</th>
                        <th class="GridViewHeaderStyle" style="width:30px">Remove</th>
                        <th class="GridViewHeaderStyle" style="width:30px">View Credentials</th>

                    </tr>

                </table>
            </div>

        </div>

    </div>

    <div id="divModel" style="display: none;">
        <div style="position: fixed; top: 0%; left: 0%; width: 100%; height: 100%; background-color: #000; z-index: 999; opacity: 0.7"></div>
        <div style="position: fixed; top: 10%; left: 25%;  background-color: #fff; z-index: 99999">
            <div class="POuter_Box_Inventory" style="width: 715px;">

                <div class="Purchaseheader">Centre Tagging</div>
                <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">Business Zone</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-10">
                        <asp:DropDownList ID="ddlBusinessZone" class="ddlBusinessZone chosen-select" onchange="BindState();" runat="server"></asp:DropDownList>
                    </div>

                </div>
                <div class="row">
                   <div class="col-md-6">
                        <label class="pull-left">State</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-10">
                        <asp:DropDownList ID="ddlState" class="ddlState chosen-select" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                   <div class="col-md-6">
                        <label class="pull-left">Centre Type</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-10">
                        <asp:DropDownList ID="ddlCentretype" class="ddlCentreType chosen-select" onchange="BindCentre();" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                  <div class="col-md-6">
                        <label class="pull-left">Centre</label>
                        <b class="pull-right">:</b>
                    </div>
                   <div class="col-md-10">
                        <asp:DropDownList ID="ddlCentre" class="ddlCentre chosen-select" onchange="BindPUP();" runat="server"></asp:DropDownList>
                    </div>
                </div>

                <div class="row" id="trPUP" style="display: none;">
                   <div class="col-md-6">
                        <label class="pull-left">PUP</label>
                        <b class="pull-right">:</b>
                    </div>
                   <div class="col-md-10">
                        <asp:DropDownList ID="ddlPUP" class="ddlPUP chosen-select" Width="300px" onchange="SetPanelId();" runat="server"></asp:DropDownList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">Centre ID Interface</label>
                        <b class="pull-right">:</b>
                    </div>
                   <div class="col-md-10">
                        <asp:TextBox ID="txtCentreIdInterface" runat="server" ReadOnly="true" Style="background-color: #f1f1f1;"> </asp:TextBox>
                    </div>
                </div>


                <div class="row">
                    <div class="col-md-6">
                        <label class="pull-left">Centre Code Interface</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-10">
                        <asp:TextBox ID="txtCentreCodeInterface" runat="server"> </asp:TextBox>
                    </div>
                </div>


            </div>
            <div class="POuter_Box_Inventory" style=" text-align: center;">
                <input type="button" value="Save" class="searchbutton" onclick="SaveMapping()" />
                <input type="button" value="Close" class="searchbutton" onclick="CloseModal()" />
            </div>
        </div>
    </div>


    <div id="divCredentials" style="display: none;">
        <div style="position: fixed; top: 0%; left: 0%; width: 100%; height: 100%; background-color: #000; z-index: 999; opacity: 0.7"></div>
        <div style="position: fixed; top: 10%; left: 25%;  background-color: #fff; z-index: 99999">
            <div class="POuter_Box_Inventory" style="width: 715px;">

                <div class="Purchaseheader">Credentials</div>
            </div>
            <div class="POuter_Box_Inventory" >

               
                                     
                   <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">User Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-16">
                        <span id="spnUserName">UserName </span>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Password</label>
                        <b class="pull-right">:</b>
                    </div>
                     <div class="col-md-16">
                        <span id="spnPassword">Password</span>
                    </div>
                </div>
                <div class="row">
                   <div class="col-md-5">
                        <label class="pull-left">Interface Client</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-16">
                        <span id="spnClient">InterfaceClient </span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">CentreID Interface</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-16">
                        <span id="spnCentreIDInterface"></span>
                    </div>
                </div>
                <div class="row">
                    &nbsp;
                </div>
                <div class="row">
                     &nbsp;
                </div>

                <div class="row">
                    Booking & Cancellation API
                </div>
                <div class="row" style="text-align: left; color: blue">
                    http://182.18.138.149/itdoselab/API/BookingAPI.aspx
                </div>

                <div class="row">
                    Lab Test Status API 
                </div>
                <div class="row" style="text-align: left; color: blue">
                    http://182.18.138.149/itdoselab/API/LabStatus.aspx
                </div>

                <div class="row">
                    Demographic Change API
                </div>
                <div class="row" style="text-align: left; color: blue">
                    http://182.18.138.149/itdoselab/API/UpdateBookingAPI.aspx
                </div>
                <div class="row">
                    Report Download API 
                </div>
                <div class="row" style="text-align: left; color: blue">
                   http://182.18.138.149/itdoselab/API/LabReport.aspx
                </div>
                <div class="row" style="text-align: center">
                    <input type="button" value="Close" class="searchbutton" onclick="CloseCreModal()" />
                </div>
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
            $('.chosen-container').css('width', '276px');
        });

        function Search() {
            var CompanyName = $('[id$=ddlCompany]').val();
            if (CompanyName == "") {
                toast('Error', 'Please select any company');
            }
            else {
                $('#tblCentreData tr').slice(1).remove();
                serverCall('ViewInterfaceCompany.aspx/Search', { CompanyName: CompanyName }, function (response) {
                    var data = $.parseJSON(response);
                    if (data.length > 0) {
                        $('[id$=hdnId]').val(data[0].ID);
                        $('[id$=lblCompanyName]').text(data[0].CompanyName);
                        $('[id$=lblAPIUserName]').text(data[0].APIUserName);
                        $('[id$=lblAPIPassword]').text(data[0].APIPassword);
                        data[0].IsWorkOrderIDCreate == "1" ? $('[id$=chkIsWorkOrderIDCreate]').prop('checked', true) : $('[id$=chkIsWorkOrderIDCreate]').prop('checked', false);
                        data[0].IsPatientIDCreate == "1" ? $('[id$=chkIsPatientIDCreate]').prop('checked', true) : $('[id$=chkIsPatientIDCreate]').prop('checked', false);
                        data[0].AllowPrint == "1" ? $('[id$=chkAllowPrint]').prop('checked', true) : $('[id$=chkAllowPrint]').prop('checked', false);
                        data[0].IsLetterHead == "1" ? $('[id$=chkLetterHead]').prop('checked', true) : $('[id$=chkLetterHead]').prop('checked', false);
                        data[0].IsBarcodeRequired == "1" ? $('[id$=chkBarCodeRequired]').prop('checked', true) : $('[id$=chkBarCodeRequired]').prop('checked', false);
                        data[0].ItemID_AsItdose == "1" ? $('[id$=chkItemIDAsItdose]').prop('checked', true) : $('[id$=chkItemIDAsItdose]').prop('checked', false);
                        if (data[0].Centre == null) {
                            var html = [];
                            html.push('<tr><td colspan="6" class="GridViewItemStyle" style="text-align:center;background-color:#fff">No Record Found !</td></tr>');
                            html = html.join("");
                            $('#tblCentreData').append(html);
                        } else {
                            for (var i = 0; i < data.length; i++) {
                                var html = [];
                                html.push('<tr>');
                                html.push('<td class="GridViewItemStyle" style="text-align:left;">'); html.push((i + 1)); html.push('</td>');
                                html.push('<td class="GridViewItemStyle" style="text-align:left;">'); html.push(data[i].BusinessZoneName); html.push('</td>');
                                html.push('<td class="GridViewItemStyle" style="text-align:left;">'); html.push(data[i].Centre); html.push('</td>');
                                html.push('<td class="GridViewItemStyle" style="text-align:left;">'); html.push(data[i].Company_Name); html.push('</td>');
                                html.push('<td class="GridViewItemStyle" style="text-align:left;">'); html.push(data[i].CentreId_interface); html.push('</td>');
                                html.push('<td class="GridViewItemStyle" style="text-align:left;">'); html.push(data[i].CentreCode_interface); html.push('</td>');
                                html.push('<td class="GridViewItemStyle" style="text-align:center;"><img src="../../App_Images/Close.png" style="cursor:pointer;;width:25px;height:25px;" onclick="RemoveTagging('); html.push(data[i].CMID); html.push(');" /></td>');
                                html.push('<td class="GridViewItemStyle" style="text-align:center;"><img src="../../App_Images/Remark.jpg"  style="cursor:pointer;;width:25px;height:25px;" onclick="ViewCredentials('); html.push(data[i].CMID); html.push(');" /></td>');
                                html.push('</tr>');
                                html = html.join("");
                                $('#tblCentreData').append(html);
                            }
                        }

                        $('#divSearch,#btnEdit,#btnRemove,#btnAddTagging').show();
                        $('#btnUpdate').hide();
                        $('[id$=chkIsWorkOrderIDCreate],[id$=chkIsPatientIDCreate],[id$=chkAllowPrint],[id$=chkLetterHead],[id$=chkBarCodeRequired],[id$=chkItemIDAsItdose]').attr('disabled', 'disabled');


                    } else {
                        $('#divSearch,#btnEdit,#btnAddTagging,#btnRemove').hide();
                        toast('Error', 'No Record Found');
                    }

                });

            }
        }

        function Edit() {
            $('[id$=chkIsWorkOrderIDCreate],[id$=chkIsPatientIDCreate],[id$=chkAllowPrint],[id$=chkLetterHead],[id$=chkBarCodeRequired],[id$=chkItemIDAsItdose]').removeAttr('disabled');
            $('#btnUpdate').show();
        }

        


        function Update() {

            var IsWorkOrderIDCreate = $('[id$=chkIsWorkOrderIDCreate]').prop('checked') ? "1" : "0";
            var IsPatientIDCreate = $('[id$=chkIsPatientIDCreate]').prop('checked') ? "1" : "0";
            var AllowPrint = $('[id$=chkAllowPrint]').prop('checked') ? "1" : "0";
            var IsLetterHead = $('[id$=chkLetterHead]').prop('checked') ? "1" : "0";
            var IsBarcodeRequired = $('[id$=chkBarCodeRequired]').prop('checked') ? "1" : "0";
            var ItemID_AsItdose = $('[id$=chkItemIDAsItdose]').prop('checked') ? "1" : "0";
            var ID = $('[id$=hdnId]').val();
            serverCall('ViewInterfaceCompany.aspx/Update', { IsWorkOrderIDCreate: IsWorkOrderIDCreate, IsPatientIDCreate: IsPatientIDCreate, AllowPrint: AllowPrint, ID: ID, IsLetterHead: IsLetterHead, IsBarcodeRequired: IsBarcodeRequired, ItemID_AsItdose: ItemID_AsItdose }, function (response) {
                if (response == "1") {

                    toast('Success', 'Updated Succcessfully !');
                    Search();
                }
                else {
                    toast('Error', 'Some Error Occured!');
                }
            });


        }
        function ShowModel() {
            $('#divModel').fadeIn();
        }
        function CloseModal() {
            $('#divModel').fadeOut();
        }

        function RemoveTagging(ID) {
            $confirmationBox('<b>Are you sure, You want to remove tagging ?', ID,"RemoveTagging");           
        }


        function BindState() {
            var BusinessZoneID = $('[id$=ddlBusinessZone]').val();
            $('[id$=ddlState] option').remove();
            $('[id$=ddlState]').trigger('chosen:updated');
            if (BusinessZoneID != "") {
                serverCall('InterfaceCompanyMaster.aspx/BindState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    stateData = jQuery.parseJSON(response);
                    $('[id$=ddlState]').append(jQuery("<option></option>").val("").html(""));
                    for (i = 0; i < stateData.length; i++) {
                        $('[id$=ddlState]').append(jQuery("<option></option>").val(stateData[i].StateId).html(stateData[i].State));
                    }
                    $('[id$=ddlState]').trigger('chosen:updated');
                });

            }
        }

        function BindCentreType() {
            var StateId = $('[id$=ddlState]').val();
            $('[id$=ddlCentreType] option').remove();
            $('[id$=ddlCentreType]').trigger('chosen:updated');
            if (StateId != "") {
                serverCall('InterfaceCompanyMaster.aspx/BindCentreType', { StateId: StateId }, function (response) {
                    CentreType = jQuery.parseJSON(response);
                    for (i = 0; i < CentreType.length; i++) {
                        $('[id$=ddlCentreType]').append(jQuery("<option></option>").val(CentreType[i].Type1ID).html(CentreType[i].Type1));
                    }
                    $('[id$=ddlCentreType]').trigger('chosen:updated');
                });

            }
        }

        function BindCentre() {
            var StateId = $('[id$=ddlState]').val();
            var CentreType = $('[id$=ddlCentretype]').val();
            if (CentreType == "7") {
                $('#trPUP').show();
            } else {
                $('#trPUP').hide();
            }
            $('[id$=ddlCentre] option').remove();
            $('[id$=ddlCentre]').trigger('chosen:updated');
            if (StateId != "" && CentreType != "") {
                serverCall('InterfaceCompanyMaster.aspx/BindCentre', { StateId: StateId, CentreType: CentreType }, function (response) {
                    Centre = jQuery.parseJSON(response);
                    $('[id$=ddlCentre]').append(jQuery("<option></option>").val("").html(""));
                    for (i = 0; i < Centre.length; i++) {
                        $('[id$=ddlCentre]').append(jQuery("<option></option>").val(Centre[i].CentreId).html(Centre[i].Centre));
                    }
                    $('[id$=ddlCentre]').trigger('chosen:updated');
                });
            }
        }
        function BindPUP() {
            var StateId = $('[id$=ddlState]').val();
            var CentreType = $('[id$=ddlCentretype]').val();
            var CentreId = $('[id$=ddlCentre]').val().split('#')[0];

            $('[id$=txtCentreCodeInterface]').val($('[id$=ddlCentre]').val().split('#')[2]);
            if (CentreType == "7") {

                $('[id$=ddlPUP] option').remove();
                $('[id$=ddlPUP]').trigger('chosen:updated');
                if (StateId != "" && CentreType != "") {
                    serverCall('InterfaceCompanyMaster.aspx/BindPUP', { CentreId: CentreId }, function (response) {
                        PUP = jQuery.parseJSON(response);
                        $('[id$=ddlPUP]').append(jQuery("<option></option>").val('').html(''));
                        for (i = 0; i < PUP.length; i++) {
                            $('[id$=ddlPUP]').append(jQuery("<option></option>").val(PUP[i].Panel_Id).html(PUP[i].Company_Name));
                        }
                        $('[id$=ddlPUP]').trigger('chosen:updated');
                    });

                }
            } else {
                $('[id$=txtCentreIdInterface]').val($('[id$=ddlCentre]').val().split('#')[1]);
                $('[id$=txtCentreCodeInterface]').val($('[id$=ddlCentre]').val().split('#')[2]);
            }
        }
        function SetPanelId() {
            $('[id$=txtCentreIdInterface]').val($('[id$=ddlPUP]').val());

        }
        function SaveMapping() {
            var data = new Array();
            var obj = new Object();
            obj.CompanyName = $('[id$=lblCompanyName]').text();
            obj.APIUserName = $('[id$=lblAPIUserName]').text();
            obj.CentreId_Interface = $('[id$=txtCentreIdInterface]').val().trim();
            obj.CentreId = $('[id$=ddlCentre]').val().split('#')[0];
            obj.CentreCode_Interface = $('[id$=txtCentreCodeInterface]').val().trim();
            obj.CompanyID = $('[id$=hdnId]').val();
            data.push(obj);
            var CentreId = $('[id$=ddlCentre]').val().split('#')[0];
            if (CentreId == "") {
                toast('Error', 'Please select centre !');
                return;
            }
            if ($('[id$=txtCentreIdInterface]').val().trim() == "") {
                toast('Error', 'Centre ID Interface cannot be blank !');
                return;
            }
            serverCall('InterfaceCompanyMaster.aspx/SaveMapping', { data: data }, function (response) {
                var retMsg = response;
                if (retMsg == "-1") {
                    toast('Error', 'Centre Id Interface Already exists by this API Company Name');
                    $('#divMapping').show();
                    $('#divCompany').hide();

                } else if (retMsg == "1") {
                    toast('Success', 'Centre Tagged Successfully');
                    Search();
                    CloseModal();

                } else {
                    toast('Error', 'Some Error Occured');
                }
            });
        }
        function ClearTagging() {
            $('[id$=ddlBusinessZone]').val('0');
            $('[id$=ddlBusinessZone]').trigger('chosen:updated');
            $('[id$=ddlCentretype]').val('0');
            $('[id$=ddlCentretype]').trigger('chosen:updated');
            $('[id$=ddlState] option').remove();
            $('[id$=ddlState]').trigger('chosen:updated');
            $('[id$=ddlCentre] option').remove();
            $('[id$=ddlCentre]').trigger('chosen:updated');
            $('[id$=ddlPUP] option').remove();
            $('[id$=ddlPUP]').trigger('chosen:updated');
            $('[id$=txtCentreIdInterface]').val('');
            $('[id$=txtCentreCodeInterface]').val('');
        }
        function ViewCredentials(ID) {
            serverCall('ViewInterfaceCompany.aspx/ViewCredentials', { ID: ID }, function (response) {
                var data = $.parseJSON(response);
                if (data.length > 0) {
                    $('#spnUserName').text(data[0].APIUserName);
                    $('#spnPassword').text(data[0].APIPassword);
                    $('#spnClient').text(data[0].Interface_CentreName);
                    $('#spnCentreIDInterface').text(data[0].CentreID_interface);
                    $('#divCredentials').fadeIn();
                } else {
                    toast('Error', 'No Credentials Found!');
                }

            });


        }
        function CloseCreModal() {
            $('#divCredentials').fadeOut();

        }
        $confirmationBox = function (contentMsg, ID,type) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: contentMsg,
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '480px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            if(type=="RemoveTagging")
                                $RemoveTagging(ID);
                            else
                                $RemoveInterfaceg();
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction();
                        }
                    },
                }
            });
        }
        $clearAction = function () {

        }
        $RemoveTagging = function (ID) {
            serverCall('ViewInterfaceCompany.aspx/RemoveTagging', { ID: ID }, function (response) {
                if (response == "1") {
                    toast('Error', 'Tagging Removed Successfully');
                    Search();
                } else {
                    toast('Error', 'Some Error Occured !');

                }
            });
        }
        $RemoveInterfaceg = function () {
            var ID = $('[id$=hdnId]').val();
            var CompanyName = $('[id$=lblCompanyName]').text();
            serverCall('ViewInterfaceCompany.aspx/Remove', { ID: ID, CompanyName: CompanyName }, function (response) {
                if (response == "1") {
                    toast('Error', 'Interface Company Removed Successfully');
                    window.location.href = "InterfaceCompanyMaster.aspx";
                } else if (response == "-1") {
                    toast('Error', 'Registration has done on this Interface Company, Cannot delete !');
                }
                else {
                    toast('Error', 'Some Error Occured !');

                }
            });
        }
        function Remove() {
            $confirmationBox('<b>Are you sure? you want to remove Interface company ?', 0, "InterfaceRemove");           
        }
    </script>

</asp:Content>
