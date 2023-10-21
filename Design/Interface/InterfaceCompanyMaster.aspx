<%@ Page Language="C#"  MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="InterfaceCompanyMaster.aspx.cs" Inherits="Design_Interface_InterfaceCompanyMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">



    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>


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

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div id="divCompany">
            <div class="POuter_Box_Inventory">
                <div class="row" style="text-align: center">
                    <b>Interface Company Master</b>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Company Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtCompanyName" runat="server" Style="text-transform: uppercase" MaxLength="10" CssClass="requiredField" />
                    </div>
                    <div class="col-md-5">
                        <em><span style="font-size: 7.5pt; color: #0000ff;">(Max. 10 Characters)</span></em>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">API User Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtAPIUserName" runat="server"  MaxLength="20" pattern="^[A-Za-z_-][A-Za-z0-9_-]$" CssClass="requiredField"/>
                    </div>
                    <div class="col-md-5">
                        <em><span style="font-size: 7.5pt; color: #0000ff;">(Max. 20 Characters)</span></em>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-5">
                        <input type="checkbox" id="chkIsWorkOrderIDCreate" /><span><strong>Visit No. Generate in LIS</strong></span>
                    </div>
                    <div class="col-md-5">
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
                        <input type="checkbox" id="chkAllowPrint" /><span><strong>Confirmation Required to Generate PDF of Lab Report</strong></span>
                    </div>

</div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left"></label>
                        <b class="pull-right"></b>
                    </div>
                    <div class="col-md-21">
                        <input type="checkbox" id="chkLetterHead" /><span><strong>LetterHead in Lab Report</strong></span>
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
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <input type="button" value="Save" class="searchbutton" onclick="Save()" />
                    <input type="hidden" id="hdnId" value="0" />
                </div>

            </div>
            <div id="divMapping" style="display: none;">
                <div class="POuter_Box_Inventory">
                    <div class="row" style="text-align: center">
                      <b> Interface Company Mapping</b> 
                    </div>
                </div>
                <div class="POuter_Box_Inventory">

                    <div class="Purchaseheader">Company Detail</div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Company Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblCompanyName" runat="server" Style="text-transform: uppercase"></asp:Label>
                            <asp:Label ID="lblCompanyID" runat="server"  style="display:none"></asp:Label>
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


                </div>
                <div class="POuter_Box_Inventory">
                    <div id="divTaggedCentre" style="display: none;">
                        <div class="Purchaseheader">Tagged Centres</div>
                        <table id="tblTaggedCentres" width="60%" style="margin-left: 50px;">
                            <tr>
                                <th class="GridViewHeaderStyle">Business Zone</th>
                                <th class="GridViewHeaderStyle">State</th>
                                <th class="GridViewHeaderStyle">Centre Type</th>
                                <th class="GridViewHeaderStyle">Centre</th>
                                <th class="GridViewHeaderStyle">Centre ID Interface</th>
                                <th class="GridViewHeaderStyle">Centre Code Interface</th>
                            </tr>
                        </table>
                    </div>


                    <div class="Purchaseheader">Centre Tagging</div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Business Zone</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBusinessZone" class="ddlBusinessZone chosen-select" onchange="BindState();" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">State</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlState" class="ddlState chosen-select" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Centre Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCentretype" class="ddlCentreType chosen-select" onchange="BindCentre();" runat="server"></asp:DropDownList>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Centre</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCentre" class="ddlCentre chosen-select" onchange="BindPUP();" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" id="trPUP" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">PUP</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPUP" class="ddlPUP chosen-select" onchange="SetPanelId();" runat="server"></asp:DropDownList>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Centre ID Interface</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCentreIdInterface" runat="server" ReadOnly="true" Style="background-color: #f1f1f1;"> </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Centre Code Interface</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCentreCodeInterface" runat="server"> </asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <input type="button" value="Save" class="searchbutton" onclick="SaveMapping()" />
                </div>
            </div>
        </div>


        <script type="text/javascript">

            function Save() {
                $('#lblCompanyID').text('');
                var CompanyName = $('[id$=txtCompanyName]').val().trim();
                var APIUserName = $('[id$=txtAPIUserName]').val().trim();
                var IsWorkOrderIDCreate = $('[id$=chkIsWorkOrderIDCreate]').prop('checked') ? "1" : "0";
                var IsPatientIDCreate = $('[id$=chkIsPatientIDCreate]').prop('checked') ? "1" : "0";
                var AllowPrint = $('[id$=chkAllowPrint]').prop('checked') ? "1" : "0";
                var IsLetterHead = $('[id$=chkLetterHead]').prop('checked') ? "1" : "0";
                var IsBarCodeRequired = $('[id$=chkBarCodeRequired]').is(':checked') ? "1" : "0";
                var ItemIDAsItdose = $('[id$=chkItemIDAsItdose]').is(':checked') ? "1" : "0";
                
                if (CompanyName == "") {
                    toast('Error', 'Enter Company Name');
                    $('[id$=txtCompanyName]').focus();
                    return;
                }

                if (APIUserName == "") {
                    toast('Error', 'Enter API User Name');
                    $('[id$=txtAPIUserName]').focus();
                    return;
                }

                var data = new Array();
                var obj = new Object();
                obj.CompanyName = CompanyName.toUpperCase();
                obj.APIUserName = APIUserName.toUpperCase();
                obj.IsWorkOrderIDCreate = IsWorkOrderIDCreate;
                obj.IsPatientIDCreate = IsPatientIDCreate;
                obj.AllowPrint = AllowPrint;
                obj.IsLetterHead = IsLetterHead;
                obj.IsBarCodeRequired = IsBarCodeRequired;
                obj.ItemIDAsItdose = ItemIDAsItdose;
                var PassWordArr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
                var APIPassword = '';
                for (var i = 0; i < 20; i++) {
                    var min = 0;
                    var max = 25;
                    var random = Math.floor(Math.random() * (+max - +min)) + +min;
                    APIPassword = APIPassword + PassWordArr[random];
                }
                obj.APIPassword = APIPassword;

                data.push(obj);
                serverCall('InterfaceCompanyMaster.aspx/Save', { data: data }, function (response) {
                    var retMsg = response.split('#');
                    if (retMsg[0] == "1") {
                        $('[id$=lblCompanyName]').text(CompanyName);
                        $('#lblCompanyID').text(retMsg[1]);
                        $('[id$=lblAPIUserName]').text(APIUserName);
                        $('[id$=lblAPIPassword]').text(APIPassword);
                        $('#divMapping').show();
                        $('#divCompany').hide();
                    } else if (retMsg[0] == "-1") {
                        toast('Error', 'Company Name, API User Name Already Exists !');

                    } else {
                        toast('Error', 'Some Error Occured');
                        $('#divMapping').hide();
                        $('#divCompany').show();
                    }

                });

            }


            function SaveMapping() {
                var data = new Array();
                var obj = new Object();
                obj.CompanyName = $('[id$=lblCompanyName]').text();
                obj.CompanyID = $('#lblCompanyID').text();
                obj.APIUserName = $('[id$=lblAPIUserName]').text();
                obj.CentreId_Interface = $('[id$=txtCentreIdInterface]').val().trim();
                obj.CentreId = $('[id$=ddlCentre]').val().split('#')[0];
                obj.CentreCode_Interface = $('[id$=txtCentreCodeInterface]').val().trim();
                data.push(obj);

                var CentreId = $('[id$=ddlCentre]').val().split('#')[0];
                if (CentreId == "") {
                     toast('Error','Please select centre !');
                    return;
                }

                if ($('[id$=txtCentreIdInterface]').val().trim() == "") {
                     toast('Error','Centre ID Interface cannot be blank !');
                    return;
                }
                serverCall('InterfaceCompanyMaster.aspx/SaveMapping', { data: data }, function (response) {
                  
                    if (response == "-1") {
                         toast('Error','Centre Id Interface Already exists by this API Company Name');
                        $('#divMapping').show();
                        $('#divCompany').hide();

                    }
                    else if (response == "0") {
                        toast('Error', 'Error');
                    }
                    else if (response == "1") {
                        ShowMapping();
                        var AddEntry = confirm('Centre Tagged Successfully ! Do you want to tag more centres ?');
                        if (AddEntry) {
                            ClearTagging();
                        } else {
                            window.location.reload();
                        }
                    }
                });
               
            }

            function ShowMapping() {
                var $rowID = [];
                $rowID.push('<tr>');
                $rowID.push('<td class="GridViewItemStyle">');$rowID.push($('[id$=ddlBusinessZone] option:selected').text());$rowID.push('</td>');
                $rowID.push('<td class="GridViewItemStyle">');$rowID.push($('[id$=ddlState] option:selected').text());$rowID.push('</td>');
                $rowID.push('<td class="GridViewItemStyle">');$rowID.push($('[id$=ddlCentretype] option:selected').text());$rowID.push('</td>');
                $rowID.push('<td class="GridViewItemStyle">');$rowID.push($('[id$=ddlCentre] option:selected').text());$rowID.push('</td>');
                $rowID.push('<td class="GridViewItemStyle">');$rowID.push($('[id$=txtCentreIdInterface]').val());$rowID.push('</td>');
                $rowID.push('<td class="GridViewItemStyle">');$rowID.push($('[id$=txtCentreCodeInterface]').val());$rowID.push('</td>');
                $rowID = $rowID.join("");
                $('#tblTaggedCentres').append($rowID);
                $('#divTaggedCentre').show();
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

            function ClearAll() {
                $('[id$=txtCompanyName]').val('');
                $('[id$=txtAPIUserName]').val('');
                $('[id$=chkIsWorkOrderIDCreate]').prop('checked', false);
                $('[id$=chkIsPatientIDCreate]').prop('checked', false);
                $('[id$=chkAllowPrint]').prop('checked', false);
            }
        </script>
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
                $('.chosen-container').css('width', '260px');
            });

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
                    serverCall('InterfaceCompanyMaster.aspx/BindCentre', { StateId: StateId,CentreType:CentreType }, function (response) {
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
        </script>
</asp:Content>
