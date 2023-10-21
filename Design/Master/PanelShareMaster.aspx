<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="PanelShareMaster.aspx.cs" Inherits="Design_Master_PanelShareMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
           </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Client Share Master</b>
            <br />

        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
              <div class="Purchaseheader">
        Search Criteria&nbsp;</div>
               
        <table style="width:100%;border-collapse:collapse;display:none;">
            <tr>
                <td style="text-align:right;width:20%">
                    State :&nbsp;
                </td>
                 <td style="text-align:left;width:30%">
                    <asp:DropDownList ID="ddlState" runat="server"  Width="160px" onchange="bindCity()"></asp:DropDownList>
                </td>
                <td style="text-align:right;width:20%">
                    City :&nbsp;
                </td>
                 <td style="text-align:left;width:30%">
                     <asp:DropDownList ID="ddlCity" runat="server"  Width="160px"></asp:DropDownList>
                </td>
            </tr>
             <tr>
                    <td colspan="4" style="text-align:center">
                        <input type="button" id="btnSearch" onclick="search()" value="Search"  class="ItDoseButton"/>&nbsp;&nbsp;
                        
                    </td>
                </tr>


        </table>
        <table style="width:100%;border-collapse:collapse">
            <tr>
                <td style="text-align:right;width:20%">
                    Panel :&nbsp;
                </td>
                 <td style="text-align:left;width:30%">
                     <asp:DropDownList ID="ddlPanel" runat="server"  Width="340px" class="ddlPanel chosen-select">
                </asp:DropDownList>
                </td>
                <td style="text-align:right;width:20%">
                    &nbsp;
                </td>
                 <td style="text-align:left;width:30%">
                   &nbsp;
                </td>
            </tr>
           
            <tr>
                <td style="text-align:right;width:20%">
                    Department :&nbsp;</td>
                 <td style="text-align:left;width:30%">
                    <asp:DropDownList ID="ddlDepartment" runat="server" 
                                    Width="340px"  class="ddlDepartment chosen-select"></asp:DropDownList></td>
                <td style="text-align:right;width:20%">
                    &nbsp;</td>
                 <td style="text-align:left;width:30%">
                     &nbsp;</td>
            </tr>
            <tr  class="td_share" style="display:none">
                           <td style="text-align:right;width:20%">
                            Share% :&nbsp; </td>
                             <td style="text-align:left;width:30%">
                         
                           
                            <input id="txtSharePer" type="text"  style="width:70px; " onkeyup="chkPer()"  /> </td>
                 <td style="text-align:right;width:20%">
                              Share Amt. :&nbsp;</td>
                <td style="text-align:left;width:30%">
                                   <input id="txtShareAmt" type="text"  style="width:70px; "  />
                                
                               
                                 
                            </td>
                        </tr>
        </table>
    </div>
    
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnItemSearch" style="cursor:pointer; " value="Search Share" onclick="getItem()" class="ItDoseButton"/>
            </div>

        <div class="POuter_Box_Inventory"  > 
        <div id="div_Item"  >
		
                
            </div>
           <div style="display:none;">
          Page Size
                
          <input type="text" id="txtpagesize" value="" />
         </div>
             </div>
            <div class="POuter_Box_Inventory" style="text-align:center;display:none" id="div_Save" > 
                <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="saveShare()" />
                </div>
       </div>
    <script type="text/javascript">
        function chkPer() {
            if ($.trim( $("#txtSharePer").val()) > 100) {
                alert("Share Percentage cannot be greater than 100.");
                $("#txtSharePer").val('');
                return;
            }
        }
        function showerrormsg(msg) 
		{
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        $(document).ready(function () {
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
            search();
        });
        function bindCity() {
            jQuery("#ddlCity option").remove();

            CommonServices.bindCity(jQuery("#ddlState").val(), onSucessCity)
        }
        function onSucessCity(result) {
            var cityData = jQuery.parseJSON(result);
            if (cityData.length == 0) {
                jQuery("#ddlCity").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
                jQuery("#ddlCity").append(jQuery("<option></option>").val("-1").html("All"));
                for (i = 0; i < cityData.length; i++) {
                    jQuery("#ddlCity").append(jQuery("<option></option>").val(cityData[i].ID).html(cityData[i].City));
                }

            }
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            bindDepartment();
        });
        function bindDepartment() {
            PageMethods.bindDepartment(onSuccessDepartment);
        }
        function onSuccessDepartment(result) {
            var DepartmentData = jQuery.parseJSON(result);

            jQuery('#ddlDepartment').append($("<option></option>").val("0").html("All"));
            for (i = 0; i < DepartmentData.length; i++) {
                jQuery('#ddlDepartment').append(jQuery("<option></option>").val(DepartmentData[i].SubCategoryID).html(DepartmentData[i].NAME));
            }
            jQuery('#ddlDepartment').trigger('chosen:updated');
        }

        function search() {
            if ($("#ddlState").val() == 0) {
               // alert("Please Select State");
                //$("#ddlState").focus();
                //return;
            }
            $("#btnSearch").attr('disabled', '').val('Searching...');
//            PageMethods.bindPanel($("#ddlState").val(), $("#ddlCity").val(), onSuccessPanel, OnfailurePanel);
			            PageMethods.bindPanel(onSuccessPanel, OnfailurePanel);
        }
        function onSuccessPanel(result) {
            var panelData = jQuery.parseJSON(result);
            if (panelData.length == 0) {
                jQuery("#ddlPanel").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }

            jQuery('#ddlPanel').append($("<option></option>").val("0").html(""));
            for (i = 0; i < panelData.length; i++) {
                jQuery('#ddlPanel').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
            }
            jQuery('#ddlPanel').trigger('chosen:updated');

            $("#btnSearch").removeAttr('disabled').val('Search');
        }
        function OnfailurePanel() {
            $("#btnSearch").removeAttr('disabled').val('Search');
        }
     </script>

    <script type="text/javascript">
        function getItem() {
            if (jQuery("#ddlPanel").val() == 0 || $("#ddlPanel").val() == "") {
                showerrormsg('Please Select Client');
                jQuery("#ddlPanel").focus();
                return;
            }
            $("#btnItemSearch").attr('disabled', '').val('Searching...');
            PageMethods.bindPanelShare(jQuery("#ddlPanel").val(), jQuery("#ddlDepartment").val(), onSuccessItem, OnfailureItem);
        }
        function OnfailureItem() {
            $("#btnItemSearch").removeAttr('disabled').val('Search Share');
        }
        var ItemData;
        function onSuccessItem(result) {
            ItemData = jQuery.parseJSON(result);
  $('#div_Item').html('');
  $("#div_Item").removeAttr('style');
            container2 = document.getElementById('div_Item');
            hot2 = new Handsontable(container2, {
                data: ItemData,
                colHeaders: [
                      "Item Name", "Share Per.", "Share Amt."
                ],
                columns: [               
                { data: 'ItemName', width: '680px', readOnly: true },
                { data: 'SharePer', readOnly: false, type: 'numeric', format: '0.00', renderer: CheckCellValue, width: '80px' },
                { data: 'ShareAmt', readOnly: false, type: 'numeric', format: '0.00', width: '80px' }

              
                ],                            
                manualColumnFreeze: true,
                rowHeaders: true,
                autoWrapRow: false,
                fillHandle: false,     
                beforeChange: function (change, source) {
                 
                    //updateFlag(change);
                    
                },                          
                afterChange: function (changes, source) {
                    if (!changes) {
                        return;
                    }
                    var cellProperties = {};
                  //  cellProperties.renderer = updateItem;
                    // chkColumnRender(changes);
                    console.log(changes);
                    var col = changes.indexOf(changes[0][1]);
                    var row = changes[0][0];
                   

                   // var col2 = changes.indexOf(changes[0][2]);
                   // var cell = hot2.getCell(row, col);
                  //  console.log(cell);
                  //  if (changes != null) {                      
                        //if (hot2.getData()[row][col] != '') {
                        //    hot2.getData()[row][col2] = '';
                        //}
                        //else if (hot2.getData()[row][col2] != '') {
                        //    hot2.getData()[row][col] = '';
                        //}
                    //    if (changes[1] == "SharePer") {
                    //        if (changes[3] != "") {
                                
                    //        }
                    //    }
                   // }
                    return cellProperties;
                   
                },
                
                cells: function (row, col, prop) {

                    var cellProperties = {};
                    //cellProperties.renderer = chkColumnRender;
                    return cellProperties;

                },

            });
            hot2.render();
			
			$("#div_Item").attr('style','max-height: 600px;overflow-y: scroll');
			
            $("#div_Save").show();

            $("#btnItemSearch").removeAttr('disabled').val('Search Share');
        }
        function chkColumnRender(instance, td, row, col, prop, value, cellProperties) {
            if (col > 2) {
                console.log(instance.getData()[row][col]);
                if (instance.getData()[row][col] == instance.getData()[row][col + 1]) {

                }
            }
            
        }
       // function chkColumnRender(changes) {
      //      var row = changes[0][0];

            
            //var sharePer = instance.getDataAtCell(row, 1);
            //console.log(sharePer);
            //var shareAmt = instance.getDataAtCell(row, 2);
            //console.log(sharePer);
            //if (shareAmt.innerHTML != "" && sharePer.innerHTML != "") {
            //    sharePer.innerHTML = "";
            //    return td;
            //}
            //return td;
      //  }
        
        
                  
        function AutoNumberRenderer(instance, td, row, col, prop, value, cellProperties) {
            var MyStr = '<span>' + parseInt(row + 1) + '</span>&nbsp;';//td.innerHTML   
            td.innerHTML = MyStr;
            return td;
        }
        function updateItem(changes) {
            var row = changes[0][0];
            if (ItemData[row].SharePer != "" && ItemData[row].ShareAmt != "") {
                console.log(ItemData[row].SharePer);
                console.log(ItemData[row].ShareAmt);
                ItemData[row].ShareAmt = "";
            }
            
            //if (change[0][3].ShareAmt != "" && change[0][3].SharePer != "") {
            //    change[0][3].ShareAmt = "";
            //    return;
            //}
           

            
        }
        function CheckCellValue(instance, td, row, col, prop, value, cellProperties) {
            Handsontable.renderers.NumericRenderer.apply(this, arguments);

            if (value > 100) {
                alert("Share Percentage cannot be greater than 100.");
                value = "";
                td.innerHTML = "";
                ItemData[row].SharePer = "";
            }
            //if (value != '') {

            //    ItemData[row].SharePer = '';
            //}
          
            return td;

        }
        function CheckCellCon(instance, td, row, col, prop, value, cellProperties) {
            Handsontable.renderers.NumericRenderer.apply(this, arguments);

           
            //if (value != '') {

            //    ItemData[row].ShareAmt = '';
            //}

            return td;

        }
        
        
       
</script>

    
    <script type="text/javascript">
        function txtSharePerKeyup(count) {

            if (parseFloat($("#txt_SharePer" + count).val()) > 100) {
                $("#txt_SharePer" + count).val("100");
            }
            if (parseFloat($("#txt_SharePer" + count).val()) < 0) {
                $("#txt_SharePer" + count).val("0");
            }


        }

        function txtShareAmtkeyup(count) {
            if (parsefloat($("#txt_ShareAmt" + count).val()) < 0) {
                $("#txt_ShareAmt" + count).val("0");
            }
        }
        </script>
        <script type="text/javascript">
            function saveShare() {
                jQuery("#btnSave").attr('disabled', 'disabled').val('Submitting...');
                PageMethods.savePanelShare(ItemData, onSuccessShareItem, OnfailureShareItem);


            }
            function onSuccessShareItem(result) {
                jQuery("#btnSave").removeAttr('disabled').val('Save');
                if (result == 1) {
                    alert('Record Saved Successfully');

                  

                }
                else {
                    jQuery("#lblMsg").text('Error');
                }
            }
            function OnfailureShareItem(result) {
                jQuery("#btnSave").removeAttr('disabled').val('Save');
            }
        </script>
</asp:Content>