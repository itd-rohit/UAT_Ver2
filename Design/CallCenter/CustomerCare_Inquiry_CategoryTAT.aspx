<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="CustomerCare_Inquiry_CategoryTAT.aspx.cs" Inherits="Design_CallCenter_CustomerCare_Inquiry_CategoryTAT" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
  
 
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    
   
     <div id="Pbody_box_inventory" style="width:1234px" >
           <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>

     <div class="POuter_Box_Inventory"  style="width:1230px;text-align:center" >
      <b>  Customer Care Enquiry </b>
       
                             </div>
     <div class="POuter_Box_Inventory"  style="width:1230px" >
        <table  style="width:100%;border-collapse:collapse">
          
            <tr>
                <td style="width:120px">&nbsp;</td>
                <td style="width:260px;text-align:right"><strong>Enquiry SubCategory :&nbsp;</strong>  </td>
                        <td >
                            <asp:TextBox ID="txtSubCategoryID" ClientIDMode="Static" runat="server" style="display:none;"  Width="30px"></asp:TextBox>
                           
                            <asp:Label ID="lblInqSubCategory" runat="server" Style="font-size:large"></asp:Label>
                            <asp:TextBox ID="txtType" ClientIDMode="Static" runat="server" style="display:none;"  Width="80px"></asp:TextBox>
                        </td>
                <td>   
                </td>
            </tr>
            
        </table>
        
           

    </div>
        
 
     <div class="POuter_Box_Inventory" style="text-align: left;width: 1230px;">
        
              <div id="divEnqueryDetail" style="overflow:auto; height:300px">                 
 
                  <table border="1" id="mtable" style="width:80%;border-collapse:collapse" class="GridViewStyle">
                <thead>
                
                </thead>
                <tbody>
                    
            </tbody>
        </table>  

              </div>  
             
              </div>
     <div class="POuter_Box_Inventory" style="text-align: center;width: 1230px;">
     <input type="button" value="Save" id="btnSave"  class="searchbutton"  onclick="saveEnquery()" /> 
          </div>  

         </div>  
    <script type="text/javascript">

        jQuery(function () {
            bindCustomerCareEnquery();
        });

        function bindCustomerCareEnquery() {
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

            jQuery('#mtable thead,#mtable tbody').html('');
            PageMethods.bindEnquery(jQuery("#txtSubCategoryID").val(), jQuery("#txtType").val(), onSuccessEnquery, OnfailureEnquery);
        }


        function onSuccessEnquery(result) {
            var tbl_body = ""; var tbl_head = "";
            var tbl_hrow = "";
            var data = jQuery.parseJSON(result);
            var count = 0;
            jQuery.each(data, function () {
                var tbl_row = "";
                jQuery.each(this, function (k, v) {
                    if (k == 'Name' || k == 'ID' || k == 'InqueryType') {
                        if (k == 'ID') {
                            tbl_row += "<td class='GridViewLabItemStyle' style='display: none;'>" + v + "</td>";
                        }

                        else if (k == 'Name') {
                            tbl_row += "<td class='GridViewLabItemStyle' style='width:180px'>" + v + "</td>";
                        }
                        else if (k == 'InqueryType') {
                            tbl_row += "<td class='GridViewLabItemStyle' style='display: none;'>" + v + "</td>";
                        }
                        else {
                            tbl_row += "<td class='GridViewLabItemStyle' style='width:60px;text-align:right'>" + v + "</td>";
                        }
                    }
                    else {
                        if (v == null)
                            v = '#';
                        var enqueryLimit = v.split('#');

                        tbl_row += "<td class='GridViewLabItemStyle'><input type='text' style='width:70px' id='" + k.substr(k.indexOf('#') + 1) + "' class='" + k.substr(k.indexOf('#') + 1) + "' value='" + enqueryLimit[0] + "'/><b>Min</b></td>";
                    }
                    if (k == 'Name') {
                        count = count + 1;
                    }
                    if (count == 1) {
                        if (k == 'Name' || k == 'ID' || k == 'InqueryType') {
                            if (k == 'ID') {
                                tbl_hrow += "<td style='width:150px; display: none;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                            else if (k == 'Name') {
                                tbl_hrow += "<td style='width:180px;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                            else if (k == 'InqueryType') {
                                tbl_hrow += "<td style='width:180px;display: none' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                            else {
                                tbl_hrow += "<td style='width:60px;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                        }
                        else {
                            tbl_hrow += "<td style='width:80px;' class='GridViewHeaderStyle " + k.substr(k.indexOf('#') + 1) + "'>" + k + "</td>";
                        }
                    }
                });

                tbl_body += "<tr>" + tbl_row + "</tr>";
            });
            tbl_head = "<tr>" + tbl_hrow + "</tr>";
            jQuery("#mtable thead").html(tbl_head);
            jQuery("#mtable tbody").html(tbl_body);

            jQuery.unblockUI();

        }
        function OnfailureEnquery(result) {
            jQuery.unblockUI();

        }
    </script>
    <script type="text/javascript">
        function saveEnquery() {
            
            var data = {
                level : []
            }

            jQuery("#mtable tbody").find('tr').each(function (key, val) {
                if (jQuery(this).closest("tr").find(".Level1").val().trim() != "")
                    data.level.push($('.Level1', this).val());
                if (jQuery(this).closest("tr").find(".Level2").val().trim() != "")
                    data.level.push($('.Level2', this).val());
                if (jQuery(this).closest("tr").find(".Level3").val().trim() != "")
                    data.level.push($('.Level3', this).val());
            });
            
            if (data.level.length == 0) {
                showerrormsg('Please Enter Response Minute');
                return;
            }
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

            var dataItem = new Array();
            var item = new Object();
            jQuery("#mtable tbody").find('tr').each(function (key, val) {
                var $tds = jQuery(this).find('td');
                item.InqType = $tds.eq(0).text();
                item.Name = $tds.eq(1).text();
                item.Lavel1 = jQuery(this).closest("tr").find(".Level1").val().trim();
                item.Lavel2 = jQuery(this).closest("tr").find(".Level2").val().trim();
                item.Lavel3 = jQuery(this).closest("tr").find(".Level3").val().trim();
                dataItem.push(item);
                item = new Object();


            });
            if (dataItem.length > 0) {
                jQuery.ajax({
                    type: "POST",
                    url: "CustomerCare_Inquiry_CategoryTAT.aspx/SaveEnquery",
                    data: "{EnqueryDetail:'" + JSON.stringify(dataItem) + "',SubCategoryID:'" + jQuery('#txtSubCategoryID').val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        if (result['d'] == "1") {
                            showerrormsg('Record Saved Successfully');
                        }
                        else {
                            showerrormsg('Error');
                        }
                        jQuery.unblockUI();
                        dataItem.splice(0, dataItem.length);
                    },
                    failure: function (response) {
                        showerrormsg('Error');
                        jQuery.unblockUI();
                    }
                });
            }
            else {
                
                dataItem.splice(0, dataItem.length);
                jQuery.unblockUI();
            }

        }
    </script>

    <script type="text/javascript">

        jQuery('body').on('keydown', 'input.testValue', function (e) {
            // Allow: backspace, delete, tab, escape, enter and .
            if (jQuery.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
                // Allow: Ctrl+A, Command+A
                (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                // Allow: home, end, left, right, down, up
                (e.keyCode >= 35 && e.keyCode <= 40)) {
                // let it happen, don't do anything
                return;
            }
            // Ensure that it is a number and stop the keypress
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                e.preventDefault();
            }
        });
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>


</asp:Content>

