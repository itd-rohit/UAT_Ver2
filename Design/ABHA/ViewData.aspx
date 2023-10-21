<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewData.aspx.cs" Inherits="Design_ABHA_ViewData" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ipad.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CPOE_AddToFavorites.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {            
            ViewData();
        });

        function ViewData() {

            serverCall('Service/ABHAM3Services.asmx/ViewData', {  }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    var data1 = JSON.parse(responseData.response);
                    console.log(data1);
                    BindData(data1); 

                } else {


                }

            });

        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <cc1:ToolkitScriptManager ID="sc" runat="server">
            </cc1:ToolkitScriptManager>

            <div id="divAppendData">
            </div>

        </div>
    </form>

    <script type="text/javascript">
        function BindData(data) {


            var row = "";
            var HsData = $.grep(data.entry, function (element) {
                return element.resource.resourceType === "Organization";
            }, false);

            console.log(HsData);
            if (HsData != null && HsData.length > 0) {//or category.name!==undefined


                row += '<div class="POuter_Box_Inventory" style="">';
                //row += ' <div class="Purchaseheader">' + HsData[0].resource.resourceType + '</div>';

                row += '  <div class="row">';
                row += '   <div class="col-md-24" style="font-size: 20px;text-align: center;">';
                row += '      <label id="lblFacility">' + HsData[0].resource.name + '</label></br>';
                row += '      <label id="lblAddress">' + HsData[0].resource.address[0].line[0] + '</label>';
                row += '  </div> ';
                row += ' </div>';
                row += '</div>';


            }

            var PatData = $.grep(data.entry, function (element) {
                return element.resource.resourceType === "Patient";
            }, false);
            if (PatData != null && PatData.length > 0) {
                // Patient Demographical

                row += '<div class="POuter_Box_Inventory" style="">';
                row += '  <div class="row Purchaseheader">';
                row += '     <div class="col-md-3">';
                row += '       <label class="pull-left">Name : ' + PatData[0].resource.name[0].text + '</label>';
                row += '   </div>';
                row += ' </div>';
                row += '</div>';

            }

            var PatData = $.grep(data.entry, function (element) {
                return element.resource.resourceType === "Composition";
            }, false);

            if (PatData != null && PatData.length > 0) {

                row += '<div class="POuter_Box_Inventory" style="height: 60px;background-color: #ebebeb;">';

                row += '  <div class="row">';

                row += '     <div class="col-md-8" style="font-size: 18px;">';
                row += '       <label class="pull-left">Document :' + PatData[0].resource.title + '</label>';
                row += '   </div>';

                row += '     <div class="col-md-7" style="font-size: 18px;">';
                row += '       <label class="pull-left">Date :' + strToDate(PatData[0].resource.date) + '</label>';
                row += '   </div>';

                row += '     <div class="col-md-6" style="font-size: 18px;">';
                row += '       <label class="pull-left">Author :' + HsData[0].resource.name + '</label>';
                row += '   </div>';

                row += '     <div class="col-md-3" style="font-size: 18px;">';
                row += '       <label class="pull-left">Status :' + PatData[0].resource.status + '</label>';
                row += '   </div>';
                row += ' </div>';


                row += '</div>';

                row += '<div class="POuter_Box_Inventory" style="">';

                $.each(PatData[0].resource.section, function (i, item) {

                    row += '<div class="POuter_Box_Inventory" style="">';
                    row += '  <div class="row Purchaseheader">';
                    row += '     <div class="col-md-24">';
                    row += '       <label class="pull-left">' + item.title + '#' + item.code.coding[0].display + '</label>';
                    row += '   </div>';
                    row += ' </div>';
                    var count = 0;
                    var MximumRow = item.entry.length;
                    $.each(item.entry, function (i, sitem) {
                        var DataSection = $.grep(data.entry, function (element) {
                            return element.fullUrl === sitem.reference;
                        }, false);

                        if (count == 0) {

                            row += '  <div>';
                            row += '     <div class="col-md-24">';
                            row += '       <label class="pull-left">' + DataSection[0].resource.resourceType + '</label>';
                            row += '   </div>';
                            row += ' </div>';

                            row += '  <table class="FixedHeader" id="tbl" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">';
                            row += '   <thead>';
                            row += '    <tr>';

                            if (DataSection[0].resource.resourceType == "AllergyIntolerance") {
                                row += '<th class="GridViewHeaderStyle">Category</th>';
                                row += '<th class="GridViewHeaderStyle">Item</th>';
                                row += '<th class="GridViewHeaderStyle">Criticality</th>';
                                row += '<th class="GridViewHeaderStyle">Clinical Status</th>';
                                row += '<th class="GridViewHeaderStyle">Verification Status</th>';
                                row += ' <th class="GridViewHeaderStyle">Onset String</th>';
                                row += ' <th class="GridViewHeaderStyle">Additional Info</th>';

                            } else if (DataSection[0].resource.resourceType == "Observation") {
                                row += '<th class="GridViewHeaderStyle">Date</th>';
                                row += '<th class="GridViewHeaderStyle">Item</th>';
                                row += '<th class="GridViewHeaderStyle">Status</th>';
                                row += '<th class="GridViewHeaderStyle">Value</th>';


                            } else if (DataSection[0].resource.resourceType == "MedicationRequest") {
                                row += '<th class="GridViewHeaderStyle">Date</th>';
                                row += '<th class="GridViewHeaderStyle">Item</th>';
                                row += '<th class="GridViewHeaderStyle">Status</th>';
                                row += '<th class="GridViewHeaderStyle">Dosing Instruction</th>';
                                row += '<th class="GridViewHeaderStyle">Additional Info.</th>';
                            }
                            else if (DataSection[0].resource.resourceType == "DocumentReference") {


                                row += '<th class="GridViewHeaderStyle">Title</th>';
                                row += '<th class="GridViewHeaderStyle" style="display:none">Data</th>';
                                row += '<th class="GridViewHeaderStyle">View</th>';
                            }
                            else if (DataSection[0].resource.resourceType == "Procedure") {


                                row += '<th class="GridViewHeaderStyle">Date</th>';
                                row += '<th class="GridViewHeaderStyle">Item</th>';
                                row += '<th class="GridViewHeaderStyle">Status</th>';
                                row += '<th class="GridViewHeaderStyle">Complication</th>';

                            }
                            else if (DataSection[0].resource.resourceType == "CarePlan") {

                                row += '<th class="GridViewHeaderStyle">Period</th>';
                                row += '<th class="GridViewHeaderStyle">Title</th>';
                                row += '<th class="GridViewHeaderStyle">Description</th>';
                                row += '<th class="GridViewHeaderStyle">Note</th>';

                            }
                            else if (DataSection[0].resource.resourceType == "Appointment") {

                                row += '<th class="GridViewHeaderStyle">Appointment Date</th>';
                                row += '<th class="GridViewHeaderStyle">Status</th>';
                                row += '<th class="GridViewHeaderStyle">Description</th>';
                                row += '<th class="GridViewHeaderStyle">participant</th>';

                            }
                            else if (DataSection[0].resource.resourceType == "DiagnosticReport") {

                                row += '<th class="GridViewHeaderStyle">Issued Date</th>';
                                row += '<th class="GridViewHeaderStyle">Item</th>';
                                //row += '<th class="GridViewHeaderStyle">Conclusion</th>';
                                row += '<th class="GridViewHeaderStyle">Observation</th>';
                                row += '<th class="GridViewHeaderStyle">Performer</th>';

                            }
                            else {
                                row += '<th class="GridViewHeaderStyle" style="">Date</th>';
                                row += '<th class="GridViewHeaderStyle">Item</th>';
                                row += '<th class="GridViewHeaderStyle">Status</th>';
                                row += ' <th class="GridViewHeaderStyle">Additional Info</th>';
                            }


                            row += '</tr> </thead> ';

                            row += ' <tbody> ';

                        }



                        if (DataSection[0].resource.resourceType == "Condition") {

                            row += ' <tr>';
                            row += '<td class="GridViewItemStyle" style=""></td>';

                            row += '<td class="GridViewItemStyle">';

                            $.each(DataSection[0].resource.category[0].coding, function (idx2, val2) {
                                row += '<label class="pull-left">' + val2.display + ':' + val2.code + '</label> </br> ';
                            });
                            row += '</td>';
                            row += '<td class="GridViewItemStyle">';
                            $.each(DataSection[0].resource.severity.coding, function (idx2, val2) {
                                row += '<label class="pull-left">' + val2.display + ':' + val2.code + '</label></br>  ';
                            });
                            row += '</td>';
                            row += ' <td class="GridViewItemStyle">' + DataSection[0].resource.code.text + '</td>';
                            row += '</tr>  ';
                        }

                        if (DataSection[0].resource.resourceType == "AllergyIntolerance") {

                            row += ' <tr>';
                            row += '<td class="GridViewItemStyle" style="">' + DataSection[0].resource.category.join(','); +'</td>';
                            row += '<td class="GridViewItemStyle">';

                            $.each(DataSection[0].resource.code.coding, function (idx2, val2) {
                                row += ' <label class="pull-left">' + val2.display + '</label> </br> ';
                            });
                            row += '</td>';

                            row += '<td class="GridViewItemStyle" style="">' + DataSection[0].resource.criticality; +'</td>';
                            row += '<td class="GridViewItemStyle">';
                            $.each(DataSection[0].resource.clinicalStatus.coding, function (idx2, val2) {
                                row += ' <label class="pull-left">' + (idx2 + 1) + '. ' + val2.display + '</label> </br> ';
                            });
                            row += '</td>';
                            if (DataSection[0].resource.hasOwnProperty('verificationStatus')) {
                                row += '<td class="GridViewItemStyle">';
                                $.each(DataSection[0].resource.verificationStatus.coding, function (idx2, val2) {
                                    row += ' <label class="pull-left">' + (idx2 + 1) + '. ' + val2.display + '</label> </br>';
                                });
                                row += '</td>';

                            } else {
                                row += '<td class="GridViewItemStyle">';
                                row += '</td>';

                            }

                            row += ' <td class="GridViewItemStyle"> ' + DataSection[0].resource.onsetString; +'</td>';
                            if (DataSection[0].resource.hasOwnProperty('note')) {
                                row += ' <td class="GridViewItemStyle"> ' + DataSection[0].resource.note[0].text; +'</td>';
                            } else {
                                row += ' <td class="GridViewItemStyle"> </td>';
                            }



                            row += '</tr>  ';
                        }

                        if (DataSection[0].resource.resourceType == "Observation") {
                            console.log(DataSection)
                            row += ' <tr>';
                            row += '<td class="GridViewItemStyle" style="">' + strToDate(DataSection[0].resource.effectiveDateTime) + '</td>';
                            row += '<td class="GridViewItemStyle">';
                            row += ' <label class="pull-left">' + DataSection[0].resource.code.text; + '</label> </br> ';

                            row += '</td>';
                            row += '<td class="GridViewItemStyle" style="">' + DataSection[0].resource.status; +'</td>';

                            if (DataSection[0].resource.hasOwnProperty('valueQuantity')) {

                                row += '<td class="GridViewItemStyle">';
                                row += ' <label class="pull-left">' + DataSection[0].resource.valueQuantity.value + ' ' + DataSection[0].resource.valueQuantity.unit + '</label> </br> ';

                                row += '</td>';

                            } else if (DataSection[0].resource.hasOwnProperty('valueString')) {
                                row += '<td class="GridViewItemStyle">';
                                row += ' <label class="pull-left">' + DataSection[0].resource.valueString + '</label> </br> ';

                                row += '</td>';

                            }

                            row += '</tr>  ';
                        }

                        if (DataSection[0].resource.resourceType == "MedicationRequest") {

                            debugger;
                            row += ' <tr>';
                            row += '<td class="GridViewItemStyle" style="">' + strToDate(DataSection[0].resource.authoredOn) + '</td>';

                            if (DataSection[0].resource.hasOwnProperty('medicationReference')) {
                                var MedReff = $.grep(data.entry, function (element) {
                                    return element.fullUrl === DataSection[0].resource.medicationReference.reference;
                                }, false);

                                if (MedReff[0].resource.code.hasOwnProperty('text')) {
                                    row += '<td class="GridViewItemStyle">';
                                    row += ' <label class="pull-left">' + MedReff[0].resource.code.text; + '</label> </br>';

                                    row += '</td>';
                                } else {
                                    row += '<td class="GridViewItemStyle">';
                                    $.each(MedReff[0].resource.code.coding, function (idx2, val2) {
                                        row += ' <label class="pull-left">' + (idx2 + 1) + '. ' + val2.display + '</label>  </br>';
                                    });

                                    row += '</td>';
                                }
                            } else if (DataSection[0].resource.hasOwnProperty('medicationCodeableConcept')) {
                                row += '<td class="GridViewItemStyle">';
                                row += ' <label class="pull-left">' + DataSection[0].resource.medicationCodeableConcept.text; + '</label>';

                                row += '</td>';
                            }
                            row += '<td class="GridViewItemStyle" style="">' + DataSection[0].resource.status; +'</td>';


                            row += '<td class="GridViewItemStyle">';
                            $.each(DataSection[0].resource.dosageInstruction, function (idx2, val2) {
                                row += ' <label class="pull-left">' + (idx2 + 1) + '. ' + val2.text + '</label> <br>';
                            });
                            row += '</td>';

                            if (DataSection[0].resource.hasOwnProperty('reasonReference')) {
                                $.each(DataSection[0].resource.reasonReference, function (idx2, val2) {

                                    var MedReff = $.grep(data.entry, function (element) {
                                        return element.fullUrl === val2.reference;
                                    }, false);

                                    row += '<td class="GridViewItemStyle">';
                                    row += ' <label class="pull-left">' + (idx2 + 1) + '. ' + MedReff[0].resource.code.text; + '</label> </br>';

                                    row += '</td>';

                                });

                            } else {
                                row += '<td class="GridViewItemStyle">';

                                row += '</td>';

                            }

                            row += '</tr>  ';
                        }

                        if (DataSection[0].resource.resourceType == "DocumentReference") {


                            $.each(DataSection[0].resource.content, function (idx2, val2) {
                                row += ' <tr>';
                                row += '<td class="GridViewItemStyle" >' + (idx2 + 1) + '. ' + val2.attachment.title + '</td>';
                                row += '<td class="GridViewItemStyle" style="display:none">';
                                row += ' <label class="pull-left" id="lblAttachedData">' + val2.attachment.data + '</label> </br> ';

                                row += '</td>';
                                row += '<td class="GridViewItemStyle" style=""><input type="button"  value="View File" onclick="ViewPDF(this)"></td>';

                                row += '</tr>  ';
                            });


                        }

                        if (DataSection[0].resource.resourceType == "Procedure") {

                            row += ' <tr>';
                            row += '<td class="GridViewItemStyle" >' + strToDate(DataSection[0].resource.performedDateTime) + '</td>';
                            row += '<td class="GridViewItemStyle">';
                            $.each(DataSection[0].resource.code.coding, function (idx2, val2) {
                                row += ' <label class="pull-left">' + val2.display + '</label> </br>';
                            });
                            row += '</td>';

                            row += '<td class="GridViewItemStyle" >' + DataSection[0].resource.status + '</td>';

                            row += '<td class="GridViewItemStyle">';
                            $.each(DataSection[0].resource.complication, function (idx2, val2) {
                                $.each(val2.coding, function (idx, val) {
                                    row += ' <label class="pull-left">' + val.display + '</label> </br>';
                                });
                            });
                            row += '</td>';

                            row += '</tr>  ';


                        }

                        if (DataSection[0].resource.resourceType == "CarePlan") {

                            row += ' <tr>';
                            row += '<td class="GridViewItemStyle">';
                            
                            row += ' <label class="pull-left"> From :' + strToDate(DataSection[0].resource.period.start) + '</label> </br>';
                            row += ' <label class="pull-left"> To ' + strToDate(DataSection[0].resource.period.end) + '</label> </br>';

                            row += '</td>'; 
                            row += '<td class="GridViewItemStyle">';
                            row += ' <label class="pull-left">' + DataSection[0].resource.title + '</label> </br>';

                            row += '</td>';

                            row += '<td class="GridViewItemStyle" >' + DataSection[0].resource.description + '</td>';

                            row += '<td class="GridViewItemStyle">';
                            $.each(DataSection[0].resource.note, function (idx2, val2) {
                                row += ' <label class="pull-left">' + (idx2 + 1) + '. ' + val2.text + '</label> </br>';
                            });
                            row += '</td>';

                            row += '</tr>  ';

                        }
                        if (DataSection[0].resource.resourceType == "Appointment") {

                            row += ' <tr>';
                            row += '<td class="GridViewItemStyle">';

                            row += ' <label class="pull-left"> From :' + strToDate(DataSection[0].resource.start) + '</label> </br>';
                            row += ' <label class="pull-left"> To ' + strToDate(DataSection[0].resource.end) + '</label> </br>';

                            row += '</td>';
                            row += '<td class="GridViewItemStyle">';
                            row += ' <label class="pull-left">' + DataSection[0].resource.description + '</label> </br>';

                            row += '</td>';

                            row += '<td class="GridViewItemStyle" >' + DataSection[0].resource.status + '</td>';

                            row += '<td class="GridViewItemStyle">';
                            $.each(DataSection[0].resource.participant, function (idx2, val2) {
                                row += ' <label class="pull-left">' + (idx2 + 1) + '. ' + val2.actor.display + '</label> </br>';
                            });
                            row += '</td>';

                            row += '</tr>  ';

                        }
                        else if (DataSection[0].resource.resourceType == "DiagnosticReport") {


                            row += ' <tr>';
                            row += '<td class="GridViewItemStyle">';
                            row += ' <label class="pull-left">' + strToDate(DataSection[0].resource.issued) + '</label> </br>';
                           

                            row += '</td>';
                            row += '<td class="GridViewItemStyle">';
                            row += ' <label class="pull-left">' + DataSection[0].resource.code.text + '</label> </br>';
                            row += '</td>';
                            //row += '<td class="GridViewItemStyle">';
                            //row += ' <label class="pull-left">' + DataSection[0].resource.conclusion + '</label> </br>';
                            //row += '</td>';
                            row += '<td class="GridViewItemStyle">';
                            $.each(DataSection[0].resource.result, function (idx2, val2) {

                                var MedReff = $.grep(data.entry, function (element) {
                                    return element.fullUrl === val2.reference;
                                }, false); 
                                row += '<label class="pull-left">' + (idx2 + 1) + '.  ' + MedReff[0].resource.code.text + ' : ' + MedReff[0].resource.valueString + '</label> </br>';
                                 
                            });
                            row += '</td>';

                            row += '<td class="GridViewItemStyle">';
                            //$.each(DataSection[0].resource.result, function (idx2, val2) {

                            //    var MedReff = $.grep(data.entry, function (element) {
                            //        return element.fullUrl === val2.reference;
                            //    }, false);
                            //    $.each(MedReff[0].resource.performer, function (idx, val) {
                            //        row +=' <label class="pull-left">' + (idx2 + 1) + '.  ' + val.display + '</label> </br>';
                            //    });
                            //});


                            var MedReff = $.grep(data.entry, function (element) {
                                return element.fullUrl === DataSection[0].resource.result[0].reference;
                            }, false);
                            $.each(MedReff[0].resource.performer, function (idx, val) {
                                row += ' <label class="pull-left">' + (idx + 1) + '.  ' + val.display + '</label> </br>';
                            });
                            row += '</td>';


                            row += '</tr>  ';


                            $.each(DataSection[0].resource.media, function (idx2, val2) {

                                var MedReff = $.grep(data.entry, function (element) {
                                    return element.fullUrl === val2.link.reference;
                                }, false);
                               
                                row += ' <tr>';
                                row += '<td class="GridViewItemStyle"colspan="3" >' + (idx2 + 1) + '. ' + val2.link.display + '</td>';
                                row += '<td class="GridViewItemStyle" style="display:none">'; 
                                row += ' <label class="pull-left" id="lblAttachedData">' + MedReff[0].resource.content.data + '</label> </br>'; 
                                row += '</td>';
                                row += '<td class="GridViewItemStyle" style=""><input type="button"  value="View File" onclick="ViewPDF(this)"></td>';

                                row += '</tr>  ';
                            });



                        }


                        count = count + 1;

                        if (count == MximumRow) {
                            row += ' </tbody>';
                            row += '</table>';
                        }

                    });


                    row += ' </div>';



                });






                row += '</div>';


            }


            $("#divAppendData").append(row);
        }





        function strToDate(dtStr) {
            if (!dtStr) return null


            var theDate = new Date(dtStr).toLocaleString();

            var d = new Date(dtStr);
            // month is 0-based, that's why we need dataParts[1] - 1

            return dateObject = theDate;
        }


        function ViewPDF(RowID) {

            var data = $(RowID).closest('tr').find("#lblAttachedData").text();

            serverCall('Service/ABHAM3Services.asmx/SetSession', { SessionName: "Base64String", SessionVal: data }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status) {
                    window.open(responseData.response);
                } else {
                }

            });

        }
    </script>
</body>
</html>
