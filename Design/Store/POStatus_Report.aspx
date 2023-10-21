<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="POStatus_Report.aspx.cs" Inherits="Design_Store_POStatus_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
 <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
 <%: Scripts.Render("~/bundles/MsAjaxJs") %>
 <%: Scripts.Render("~/bundles/Chosen") %>
 <%: Scripts.Render("~/bundles/JQueryUIJs") %>
       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
               <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
<script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
<style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>
 
        <style>
        div#divPatient.vertical {
            width: 40%;
            height: 400px;
            background: #ffffff;
            float: left;
            overflow-y: auto;
            border-right: solid 1px gray;
        }

        div#divInvestigation.vertical {
            margin-left: 40%;
            height: 400px;
            background: #ffffff;
            overflow-y: auto;
        }


        div#divPatient.horizontal {
            height: 600px;
            background: #ffffff;
            overflow-y: auto;
        }

        div#divInvestigation.horizontal {
            height: 300px;
            background: #ffffff;
            overflow-y: auto;
        }


        .ht_clone_top_left_corner, .ht_clone_bottom_left_corner, .ht_clone_left, .ht_clone_top {
            z-index: 0;
        }

        .ajax__calendar .ajax__calendar_container {
            z-index: 9999;
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
            width: 40%;
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
            height:100px;
        }

        .modal-footer {
            padding: 2px 16px;
            background-color: #5cb85c;
            color: white;
        }

        .handsontable .htDimmed {
            color: #000000;
        }

       
        .handsontableInput
        {
            /*width:150px !important;*/
            max-width:150px !important;
        }
        .handsontableEditor, autocompleteEditor, handsontable, listbox{
             /*width:200px;*/
             max-width:200px;
        }

        #divimgpopup
        {
                height: 984px;
    min-height: 134px;
    width: auto;
    width: 400px;
    padding: 10px;
        }
        .ui-dialog-title
        {
            font-weight: bold;
        }
        .ui-dialog
        {
                display: block;
                position: absolute;
                outline: 0px;
                height: 300px;
                padding: 10px;
                width: 500px;
                top: 0px;
                left: 514.5px;
                z-index: 9999;
                background-color: whitesmoke;
                 box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
            
        }
        .ui-icon-closethick
        {
            float:right;
        }

            .Lock {
                background-color:#3399FF;
            }
            .Open {
                background-color:#baf467;
            }
            .outstanding {
                background-color:#f85353;
            }

                .Lock:hover, .Open:hover {
                    background-color:#E7E8EF;
                }

                .FixedHeader {
            position: absolute;
        
        }
            .currentRow {
                font-weight:bold;
            }

    </style>
   


    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>

        <div id="Pbody_box_inventory" style="width: 1275px">


             <div class="POuter_Box_Inventory" style="width: 1272px;text-align:center">
                 <b>POD Status Report</b>
              <br />
            
</div>
      <div class="POuter_Box_Inventory" style="width: 1272px">
            <div class="Purchaseheader">
               POD Status Report
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
          <table style="width: 100%;border-collapse:collapse">
                <tr  >
                   <td style="text-align:right;width:20%">
                       POD Number :&nbsp;</td>
                    <td style="text-align:left;width:20%">
                               <asp:TextBox runat="server" ID="txt_Ponumber"></asp:TextBox>

                        </td>
                  
               </tr>
           
              </table>
             
             </div> 
           <div class="POuter_Box_Inventory" style="width: 1272px;text-align:center">
            <input type="button" id="btnSearch" class="searchbutton" onclick="searchLedger()" value="Search" />
            &nbsp;&nbsp;
  <a onclick="exportReport()" class="searchbutton" id="btnexportReport" style="display:none">Report
                  <img src="../../App_Images/xls.png" width="22" style="cursor:pointer;text-align:center" />
              </a>
              
          

          
          </div>
      <div class="POuter_Box_Inventory" style="text-align: center;width: 1272px">
            <div class="Purchaseheader">
                Details
            </div>
            <table  style="width: 100%; border-collapse:collapse" id="myTable">
                <tr >
                    <td colspan="4">
                          <div id="all_data" runat="server"></div>
                        <br />
                       
                    </td>
                </tr>
            </table>
        </div>
        
   

          </div>  
    


     
     <script type="text/javascript">
         var modal = "";
         var span = "";

           
    </script>
     <script type="text/javascript">
         jQuery(function () {
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

             jQuery('#ddlBusinessZone').trigger('chosen:updated');
             jQuery(function () {
                 jQuery('[id*=lstPanel]').multipleSelect({
                     includeSelectAllOption: true,
                     filter: true, keepOpen: false
                 });
             });
         });
       
   </script>
     <script type="text/javascript">
         function searchLedger() {
           

             var PODNumber = $('#<%=txt_Ponumber.ClientID%>').val();
            
             jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

             // var PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();

             jQuery.ajax({
                 url: "POStatus_Report.aspx/searchPODStatus",
                 data: '{PODNumber:"' + PODNumber + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                    var LedgerData = result.d;
                     if (LedgerData != null) {
                        

                         jQuery('#LedgerSearchOutput,#btnexportReport').show();
                         $('#<%=all_data.ClientID%>').html(LedgerData);
                        
                     }
                     else {
                         jQuery('#LedgerSearchOutput').html('');
                         jQuery('#LedgerSearchOutput,#btnexportReport').hide();

                     }
                     jQuery.unblockUI();
                 },
                 error: function (xhr, status) {
                     jQuery('#LedgerSearchOutput').html('');
                     jQuery('#LedgerSearchOutput').hide();
                     jQuery.unblockUI();

                 }
             });
         }
         function showerrormsg(msg) {
             jQuery('#msgField').html('');
             jQuery('#msgField').append(msg);
             jQuery(".alert").css('background-color', 'red');
             jQuery(".alert").removeClass("in").show();
             jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
            </script>
            
<script type="text/javascript">
    function exportReport() {

        $("#tb_ItemList").remove(".noExl").table2excel({
            name: "PO Status Report ",
            filename: "POStatusReport ", //do not include extension
            exclude_inputs: false
        });
    }
    </script>
  

</asp:Content>
