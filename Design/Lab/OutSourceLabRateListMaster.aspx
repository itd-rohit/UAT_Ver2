<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true"
    CodeFile="OutSourceLabRateListMaster.aspx.cs" Inherits="Design_Lab_OutSourceLabRateListMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
   
    <link href="../../App_Style/chosen.css" rel="stylesheet" type="text/css" />

    <style>
        div#div_Department.vertical {
            width: 25%;
            height: 400px;
            background: #ffffff;
            float: left;
            overflow-y: auto;
            border-right: solid 1px gray;
        }

        div#div_Lab.vertical {
            margin-left: 25%;
            height: 400px;
            background: #ffffff;
            overflow-y: auto;
        }


        div#div_Department.horizontal {
            height: 150px;
            background: #ffffff;
            overflow-y: auto;
        }

        div#div_Lab.horizontal {
            height: 300px;
            background: #ffffff;
            overflow-y: auto;
        }

        .ht_clone_top_left_corner, .ht_clone_bottom_left_corner, .ht_clone_left, .ht_clone_top {
            z-index: 0;
        }
        /* The Modal (background) */
        
       

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
        .handsontable .htDimmed {
            color: #000000;
        }
    </style>


    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" AsyncPostBackErrorMessage="Error...">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Outsource Test Master</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <div class="row">
                    <div class="col-md-24">
                        Search Option<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Centre </label>
			  <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" CssClass="ddlCentre chosen-select requiredField"  runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To OutSource Lab </label>
			  <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlOutSourceLab" CssClass="ddlOutSourceLab chosen-select requiredField"  runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3"><label class="pull-left">Department </label>
			  <b class="pull-right">:</b></div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDepartment" class="ddlItem chosen-select"  runat="server"></asp:DropDownList></div>
            </div>
            <div class="row">
                <div class="col-md-3"><label class="pull-left">Investigation </label>
			  <b class="pull-right">:</b></div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlItem" class="ddlItem chosen-select" runat="server"></asp:DropDownList></div>
                <div class="col-md-8">
                    <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="BindDepartmentTable();" />
                </div>
                <div class="col-md-8" style="display: none">
                    <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" Class="rblClass">
                        <asp:ListItem Selected="True" Value="Lab">Lab Wise</asp:ListItem>
                        <asp:ListItem Value="Item">Item Wise</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>



        </div>
         <div class="POuter_Box_Inventory">
            <div id="div_Department" class="vertical"></div>
            <div id="div_Lab" class="vertical"></div>
            <div id="div_Item" class="vertical"></div>
            <div style="padding: 20px; float: right">
                <input id="btnSave" type="button" value="Save" class="" onclick="SaveRateListMaster('Save');"  disabled />
                <input id="btnRemove" type="button" value="Remove"  onclick="SaveRateListMaster('Remove');"  disabled />
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var PatientData = '';
        var RateListData = '';
        var hot2;
        var modal = "";
        var span = "";
        var currentRow = 1;
        $(function () {
            $('#div_Department,#div_Lab').show();
            $('#div_Item').hide();
        });
        function BindItemRateListTable() {
            $('#div_Department,#div_Lab,#div_Item').html('');

            RateListData = '';
            
            serverCall('OutSourceLabRateListMaster.aspx/BindItemRateListTable', { CentreID: $("#<%=ddlCentre.ClientID %>").val(), CentreName: $("#<%=ddlCentre.ClientID %>").find(':selected').text(), InvestigationID: $("#<%=ddlItem.ClientID %>").val(), Investigation: $("#<%=ddlItem.ClientID %>").find(':selected').text() }, function (response) {
                RateListData = jQuery.parseJSON(response);
                if (RateListData == "-1") {
                    $('#btnSave').attr("disabled", "disabled");
                    $('#btnRemove').attr("disabled", "disabled");
                   
                    toast("Error", "Your Session Expired.... Please Login Again", "");
                    return;
                }
                if (RateListData.length == 0) {
                    $('#btnSave').attr("disabled", "disabled");
                    $('#btnRemove').attr("disabled", "disabled");

                    toast("info", "No Record Found", "");
                    return;

                }
                else {
                    var data = RateListData,
                     container2 = document.getElementById('div_Item'),
                     hot2 = new Handsontable(container2, {
                         data: RateListData,
                         colHeaders: [
                            "Centre", "Lab Name", "Investigation", "Rate", "TAT Type", "TAT", "Attachment Required", "Other Test", "Select"
                         ],
                         readOnly: true,
                         columns: [
                              { data: 'CentreName' },
                              { data: 'LabName' },
                         { data: 'Investigation' }, { data: 'OutsourceRate', readOnly: false },
                          {
                              data: 'TATType',
                              type: 'dropdown',
                              source: ['Hours', 'Days'],
                              width: 80,
                              readOnly: false

                          },
                          { data: 'TAT', readOnly: false },
                           {
                               data: 'IsFileRequired',
                               type: 'checkbox',
                               checkedTemplate: '1',
                               uncheckedTemplate: '0',
                               readOnly: false
                           },
                              { data: 'OtherTest', renderer: safeHtmlRenderer },
                         {
                             data: 'IsDefault',
                             type: 'checkbox',
                             checkedTemplate: '1',
                             uncheckedTemplate: '0',
                             readOnly: false
                         }],
                         stretchH: "all",
                         fixedColumnsLeft: 1,
                         autoWrapRow: false,
                         fillHandle: false,
                         rowHeaders: true,
                     });
                    $('#btnSave,#btnRemove').removeAttr("disabled");
                }
            });


           
         }
         function BindDepartmentTable() {
             if ($("#<%=ddlCentre.ClientID %>").val() == "0") {
                 toast("Error", "Please Select Centre", "");
                return;
            }
             if ($('#<%= rblType.ClientID %>').find(":checked").val() == "Lab") {
                 $('#div_Department').show();
                 $('#div_Lab').show();
                 $('#div_Item').hide();
                 if ($("#<%=ddlOutSourceLab.ClientID %>").val() == "") {
                     toast("Error", "Please Select Lab", "");
                     return;
                 }
             }
             else {
                 $('#div_Department').hide();
                 $('#div_Lab').hide();
                 $('#div_Item').show();
                 if ($("#<%=ddlItem.ClientID %>").val() == "ALL") {
                     toast("Error", "Please Select Investigation", "");
                     return;
                 }
                 else {
                     BindItemRateListTable();
                 }

             }
             $('#div_Department,#div_Lab').html('');
        
             serverCall('OutSourceLabRateListMaster.aspx/BindDepartmentTable', { DepartmentID: $("#<%=ddlDepartment.ClientID %>").val(), InvestigationID: $("#<%=ddlItem.ClientID %>").val() }, function (response) {
                 PatientData = jQuery.parseJSON(response);

                 if (PatientData == "-1") {
                     toast("Error", "Your Session Expired.... Please Login Again", "");
                     return;
                 }
                 if (PatientData.length == 0) {
                     toast("Info", "No Record Found", "");
                     return;
                 }
                 else {
                     $("#<%=lblMsg.ClientID %>").text('');
                     var data = PatientData,
                      container1 = document.getElementById('div_Department'),
                      hot1;

                     hot1 = new Handsontable(container1, {
                         data: PatientData,
                         colHeaders: [
                              "Select", "Department"
                         ],
                         readOnly: true,
                         columns: [
                         { data: 'ObservationType_ID', renderer: safeHtmlRenderer },
                         { data: 'Name' }
                         ],
                         stretchH: "all",
                         autoWrapRow: false,
                         fillHandle: {
                             direction: 'vertical'
                         },
                         rowHeaders: true,
                         readOnly: true,
                     });
                     BindRateListTable(PatientData[0].ObservationType_ID);
                 }
             });       
     }
     function BindRateListTable(DepartmentID) {
         if ($('#<%= rblType.ClientID %>').find(":checked").val() == "Lab") {
             $('#div_Department').show();
             $('#div_Lab').show();
             $('#div_Item').hide();
             if ($("#<%=ddlOutSourceLab.ClientID %>").val() == "") {
                 toast("Error", "Please Select Lab", "");
                 return;
             }
         }
         else {
             $('#div_Department').hide();
             $('#div_Lab').hide();
             $('#div_Item').show();
             if ($("#<%=ddlItem.ClientID %>").val() == "ALL") {
                 toast("Error", "Please Select Investigation", "");
                 return;
             }
             else {

             }
         }
         $('#div_Lab').html('');
        
         serverCall('OutSourceLabRateListMaster.aspx/BindRateListTable', { CentreID: $("#<%=ddlCentre.ClientID %>").val(), CentreName: $("#<%=ddlCentre.ClientID %>").find(':selected').text(), DepartmentID: DepartmentID, LabID: $("#<%=ddlOutSourceLab.ClientID %>").val(), LabName: $("#<%=ddlOutSourceLab.ClientID %>").find(':selected').text(), InvestigationID: $("#<%=ddlItem.ClientID %>").val() }, function (response) {
             RateListData = jQuery.parseJSON(response);
             if (RateListData == "-1") {
                 $('#btnSave,#btnRemove').attr("disabled", "disabled");
                 toast("Error", "Your Session Expired.... Please Login Again", "");
                 return;
             }
             if (RateListData.length == 0) {
                 $('#btnSave,#btnRemove').attr("disabled", "disabled");
                 toast("Info", "No Record Found", "");
                 return;
             }
             else {
                 
                 var data = RateListData,
                  container2 = document.getElementById('div_Lab'),
                  hot2 = new Handsontable(container2, {
                      data: RateListData,
                      colHeaders: [
                         "Centre", "Lab Name", "Investigation", "Rate", "TAT Type", "TAT", "Attachment Required", "Other Test", "Select"
                      ],
                      readOnly: true,
                      columns: [
                           { data: 'CentreName' },
                           { data: 'LabName' },
                      { data: 'Investigation' },

                      {
                          data: 'OutsourceRate',
                          
                          validator: function (value, callback) {
                              var numberRegex = /^(?:[0-9]\d*|)$/;
                              if (value.length > 6 || numberRegex.test(value) == false) {
                                  toast("Error", "Rate Length Should be Less Than or Equal to 6 Digit only Takes Number.");
                                  this.instance.setDataAtCell(this.row, this.col, '',null);
                              }
                              callback(true)
                          },
                          readOnly: false
                      },
                       {
                           data: 'TATType',
                           type: 'dropdown',
                           source: ['Hours', 'Days'],
                           width: 80,
                           readOnly: false

                       },
                       {
                           data: 'TAT',
                           validator: function (value, callback) {
                               var numberRegex = /^(?:[0-9]\d*|)$/;
                               if (value.length > 10 || numberRegex.test(value) == false) {
                                   toast("Error", "TAT Length Should be Less Than or Equal to 10 Digit only Takes Number.");
                                   this.instance.setDataAtCell(this.row, this.col, '', null);
                               }
                               callback(true)
                           },
                           readOnly: false
                       },
                        {
                            data: 'IsFileRequired',
                            type: 'checkbox',
                            checkedTemplate: '1',
                            uncheckedTemplate: '0',
                            readOnly: false
                        },
                           { data: 'OtherTest', renderer: safeHtmlRenderer1 },

                       //{  renderer: CheckCellValue },
                      {
                          data: 'IsDefault',
                          type: 'checkbox',
                          checkedTemplate: '1',
                          uncheckedTemplate: '0',
                          readOnly: false
                      }
                      ],
                      stretchH: "all",
                      //manualColumnFreeze: true,
                      fixedColumnsLeft: 1,
                      autoWrapRow: false,

                      fillHandle: false,
                      rowHeaders: true,
                  });
                 $('#btnSave,#btnRemove').removeAttr("disabled");
                 $('').removeAttr("disabled");
             }
         });       
     }

     function safeHtmlRenderer1(instance, td, row, col, prop, value, cellProperties) {

         var d = RateListData[row].othercount;
         if (d == 0) {
             td.innerHTML = '<a style="font-weight:bold;" href="javascript:void(0);"  onclick="PickRowData1(' + row + ');">Add Other Test </a>';
         }
         else {
             td.innerHTML = '<a style="font-weight:bold;color:red;" href="javascript:void(0);"  onclick="PickRowData1(' + row + ');">Add Other Test </a>';
         }
         return td;
     }

     function PickRowData1(rowindex) {
         var a = RateListData[rowindex].Investigation_Id;
         var b = RateListData[rowindex].LabID;
         var c = RateListData[rowindex].CentreID;


         window.open("MapOutSourceLabWithOther.aspx?Investigation_Id=" + a + "&LabID=" + b + "&BookingCentreID=" + c, '', 'left=150, top=100, height=450, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
     }

     function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {
         var escaped = Handsontable.helper.stringify(value);
         td.innerHTML = '<a href="javascript:void(0);"  onclick="PickRowData(' + value + ');"> <img  src="../../App_Images/Post.gif" style="border-style: none" alt="">     </a>';
         return td;
     }
     function setHidden(instance, td, row, col, prop, value, cellProperties) {
         td.hidden = true;
         return td;
     }
     function PickRowData(rowIndex) {
         $("#div_Department tr > td").css("background", "#ffffff");
         $("#div_Department tr:nth-child(" + (rowIndex + 1) + ") > td").css("background", "rgb(189, 245, 245)");
         BindRateListTable(PatientData[rowIndex].ObservationType_ID);
     }
     function CheckCellValue(instance, td, row, col, prop, value, cellProperties) {
         cellProperties.editor = 'text';

         td.innerHTML = value;
         return td;
     }

  

     function SaveRateListMaster(Type) {
        
         serverCall('OutSourceLabRateListMaster.aspx/SaveRateList', { data: RateListData, Type: Type }, function (response) {
             var TestData = jQuery.parseJSON(response);
             if (TestData == "-1") {
                 $('#btnSave,#btnRemove').attr("disabled", "disabled");
                 toast("Error", "Your Session Expired...Please Login Again", "");
                 return;
             }
             else if (TestData == "1") {
               if(Type=="Save")
                 toast("Success", "Record Saved Successfully", "");
               else
                 toast("Success", "Record Remove Successfully", "");
                 return;
             }
             else {
                 $('#btnSave,#btnRemove').attr("disabled", "disabled");
                 toast("Error", "Record Not Save", "");
                 return;
             }
         });

         

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
        });
    </script>
</asp:Content>

