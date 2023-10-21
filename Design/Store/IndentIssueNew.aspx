<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IndentIssueNew.aspx.cs" Inherits="Design_Store_IndentIssueNew" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <title></title>
     <style type="text/css">
        .selected {
            background-color:aqua !important;
           border:2px solid black;
        }
          .added {
            background-color:#b1ff88 !important;
           border:2px dotted black;
        }

         .reject {
             background-color:#90EE90 !important;  
         }
    </style>
</head>
<body>
     <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>

   
   <form id="form1" runat="server">
      <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>


    <div id="Pbody_box_inventory" style="width:1254px;min-height:500px;">
         
          <div class="POuter_Box_Inventory" style="width:1250px;">
            <div class="content">

                <table width="99%">

                    <tr>
                        <td><b>Issue Item Against indent</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong>Indent No :</strong>&nbsp;&nbsp;<asp:TextBox ID="txtindentno" runat="server" ReadOnly="true"></asp:TextBox></td>
                        <td><table width="100%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>New</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: white;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Pending</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Close</td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Reject</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Partial</td>

                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: aqua;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Selected</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #b1ff88;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Added</td>
                </tr>
            </table></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                          

                           
                           
                            Current Location : <asp:Label ID="lblcurrentlocation" runat="server" Font-Bold="true"></asp:Label>
                            &nbsp;&nbsp;&nbsp;
                            Indent From : <asp:Label ID="lblfromlocation" runat="server" Font-Bold="true"></asp:Label>
                            <asp:TextBox ID="lblcurrentlocationid" runat="server" style="display:none;"></asp:TextBox>
                             <asp:TextBox ID="lbltolocationid" runat="server" style="display:none;"></asp:TextBox>
                             <asp:TextBox ID="lbltopanelid" runat="server" style="display:none;"></asp:TextBox>
                            
                      

                            <input type="button" value="Reset" onclick="location.reload()" style="float:right;color:white;" class="resetbutton" />
                            
                        </td>
                    </tr>

                   
                    </table>
                </div>


              </div>


         <div class="POuter_Box_Inventory" style="width:1250px;">
            <div class="content">
                <table style="width:100%"> 

                    <tr>
                        <td style="width:55%">
                            <div style="width:99%;max-height:375px;overflow:auto;">
                <table id="tblitemlist" style="width:99%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                         <td class="GridViewHeaderStyle" >ItemID</td>
                                          <td class="GridViewHeaderStyle" >Item Name</td>
                                          <td class="GridViewHeaderStyle" >Unit</td>
                                         <%-- <td class="GridViewHeaderStyle" >Request Qty</td>--%>
                                          <td class="GridViewHeaderStyle" >Approved Qty</td>
                                          <td class="GridViewHeaderStyle" >Receive Qty </td>
                                          <td class="GridViewHeaderStyle" >Issue Qty </td>
                                          <td class="GridViewHeaderStyle" >Rejected Qty</td>
                                          <td class="GridViewHeaderStyle" >Issue Qty</td>
                                          <td class="GridViewHeaderStyle" >Available Qty</td>
                                          
                                          <td class="GridViewHeaderStyle">Reject</td>
                                        
                                       
                                        
                                     
                        </tr>
                </table>

                </div>
                        </td>
                      
                        <td style="width:45%" valign="top">
                          
                          <asp:TextBox ID="txtbarcodeno" autocomplete="off" runat="server" Width="236px" placeholder="Scan Barcode For Quick Issue" BackColor="lightyellow" style="border:1px solid red;" Font-Bold="true"></asp:TextBox>

                            <br />
                            <br />

                          <div style='width:99%;max-height:275px;overflow:auto;'><table id="tbl1" style='width:99%' cellpadding='0' cellspacing='0' rules="all" frame="box" border="1" >
                       <tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;" >
                        <td  style="width:20px;">#</td>
                       
                       <td>Batch Number</td>
                           <td>Barcode No</td>
                        <td>Expiry<br /> Date</td>
                        <td>Available<br /> Qty </td>
                        <td>Unit</td>
                        <td>Issue<br /> Qty</td>
                       <td>Issue</td>
                           </tr>
                              </table>
                              </div>
                          
                          </td>
                    </tr>
                </table>
                </div>
             </div>


          <div class="POuter_Box_Inventory" style="width:1250px;">
            <div class="content">
                <div  style='width:99%;max-height:275px;overflow:auto;'>

                <table  id="mytable"  style='width:99%' cellpadding='0' cellspacing='0'> 

                   
                        <tr id="tr11" style="background-color:lightslategray;color:white;font-weight:bold;">
                        <td  style="width:20px;">#</td>
                            <td  >ItemID</td>
                        <td  >Item Name</td>
                        <td  >Barcode No</td>
                            <td >Batch Number</td>
                            <td>Expiry Date</td>
                             <td>Unit Price</td>
                            <td >Issue Qty</td>
                            <td >Total Amt</td>
                             <td >Remove</td>
                         </tr>
                       
                    </table>
                    </div>

                <br />
                <div style="width:99%;text-align:center;" id="trme">
           
               
                  <strong>Total Amount:</strong>  &nbsp;
                <asp:TextBox ID="txttotal" runat="server" ReadOnly="true" Width="150px"></asp:TextBox>
                  &nbsp;  &nbsp;
                <input type="button" value="Issue All" class="savebutton" onclick="saveall()" style="display:none;" id="btnsave" /></div>
                </div>
        </div>
    </form>

    <script type="text/javascript">
        function showmsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', '#04b076');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }

        $(document).ready(function () {
            bindindentdata();
        });


        $(function () {
            $("#<%= txtbarcodeno.ClientID%>").keydown(
                 function (e) {
                     var key = (e.keyCode ? e.keyCode : e.charCode);
                     if (key == 13) {
                         e.preventDefault();
                         if ($.trim($('#<%=txtbarcodeno.ClientID%>').val()) != "") {

                           searchitem();
                       }



                   }

               });
          });


        function bindindentdata() {

            
            $('#tblitemlist tr').slice(1).remove();
            $.ajax({
                url: "IndentRePrint.aspx/BindItemDetail",
                data: '{IndentNo:"' + $('#<%=txtindentno.ClientID%>').val() + '",locationid:"' + $('#<%=lblcurrentlocationid.ClientID%>').val() + '"}', // parameter map      
                  type: "POST",
                  timeout: 120000,
                 
                  contentType: "application/json; charset=utf-8",
                  dataType: "json",
                  success: function (result) {
                      ItemData = jQuery.parseJSON(result.d);

                      if (ItemData.length == 0) {
                          showerrormsg("No Item Found");
                          

                      }
                      else {

                          for (var i = 0; i <= ItemData.length - 1; i++) {
                              var mydata = '';
                              mydata += "<tr style='background-color:" + ItemData[i].Rowcolor + ";' id='" + ItemData[i].itemid + "'>";


                              mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                              mydata += '<td  style="font-weight:bold;" id="tditemid1">' + ItemData[i].itemid + '</td>';
                              mydata += '<td class="GridViewLabItemStyle">';

                              if (precise_round(ItemData[i].AblQty, 5) > 0 && (ItemData[i].Status == 'New' || ItemData[i].Status == 'Partial Issue' || ItemData[i].Status == 'Pending') && parseFloat(ItemData[i].ReqQty) > parseFloat(ItemData[i].PendingQty)) {
                                  mydata += '<a style="cursor:pointer;font-weight:bold;color:blue;" onclick="showmystock(this)">' + ItemData[i].itemname + '<a>';
                              }
                              else {
                                  mydata += ItemData[i].itemname;
                              }
                              mydata += '</td>';
                              mydata += '<td class="GridViewLabItemStyle">' + ItemData[i].minorunitname + '</td>';
                              //mydata += '<td  class="GridViewLabItemStyle" id="reqqty1" style="font-weight:bold;">' + precise_round(ItemData[i].ReqQty, 5) + '</td>';
                              mydata += '<td  class="GridViewLabItemStyle" id="reqqty" style="font-weight:bold;">' + precise_round(ItemData[i].ApprovedQty, 5) + '</td>';
                              mydata += '<td  class="GridViewLabItemStyle" id="recqty" style="font-weight:bold;">' + precise_round(ItemData[i].ReceiveQty, 5) + '</td>';
                              mydata += '<td  class="GridViewLabItemStyle" id="penqty" style="font-weight:bold;">' + precise_round(ItemData[i].PendingQty, 5) + '</td>';
                              mydata += '<td  class="GridViewLabItemStyle" id="rejqty" style="font-weight:bold;">' + precise_round(ItemData[i].RejectQty, 5) + '</td>';
                              mydata += '<td  class="GridViewLabItemStyle" id="ablqty" style="font-weight:bold;">' + precise_round(ItemData[i].StockINHand, 5) + '</td>';
                              if (precise_round(ItemData[i].AblQty, 5) == 0) {
                                  mydata += '<td title="Stock Unavailable"  class="GridViewLabItemStyle" id="ablqty" style="font-weight:bold;">' + precise_round(ItemData[i].AblQty, 5) + '&nbsp;<span style="background-color:red;color:white;">Not in Stock</span></td>';
                              }
                              else {
                                  mydata += '<td  class="GridViewLabItemStyle" id="ablqty" style="font-weight:bold;">' + precise_round(ItemData[i].AblQty, 5) + '</td>';
                              }

                              mydata += '<td class="GridViewLabItemStyle" >';
                              if (ItemData[i].Status == 'New' || ItemData[i].Status == 'Partial Issue') {
                                  mydata += '<input  class="mydel" type="text" style="width:65px;" id="txtrejectqty" placeholder="Reject Qty" onkeyup="showme(this);" />&nbsp;&nbsp;<input  class="mydel" type="text" style="width:100px;" id="txtrejectreason" placeholder="Reject Reason" />&nbsp;&nbsp; <img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="rejectme(this)"  class="mydel" />';
                              }
                              mydata += '</td>';
                              mydata += '<td  style="display:none;" id="tditemid">' + ItemData[i].itemid + '</td>';
                              mydata += '<td  style="display:none;" id="tdid">' + ItemData[i].id + '</td>';
                              mydata += '<td  style="display:none;" id="tdMinorUnitInDecimal">' + ItemData[i].MinorUnitInDecimal + '</td>';
                              mydata += "</tr>";
                              $('#tblitemlist').append(mydata);
                          }


                          

                      }

                  },
                  error: function (xhr, status) {
                      alert(xhr.responseText);
                      

                  }
              });

          }
        function showme(ctrl) {

            if ($(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "0") {

                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }
              //if ($(ctrl).val().indexOf(".") != -1) {
              //    $(ctrl).val($(ctrl).val().replace('.', ''));
              //}
              if ($(ctrl).val().indexOf(" ") != -1) {
                  $(ctrl).val($(ctrl).val().replace(' ', ''));
              }

              var nbr = $(ctrl).val();
              var decimalsQty = nbr.replace(/[^.]/g, "").length;
              if (parseInt(decimalsQty) > 1) {
                  $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
              }

              // alert($(ctrl).closest("tr").find("#txttddisc").text());

              if ($(ctrl).val().length > 1) {
                  if (isNaN($(ctrl).val() / 1) == true) {
                      $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                  }
              }


              if (isNaN($(ctrl).val() / 1) == true) {
                  $(ctrl).val('');

                  return;
              }
              else if ($(ctrl).val() < 0) {
                  $(ctrl).val('');

                  return;
              }


              var reqqty = parseFloat($(ctrl).closest('tr').find('#reqqty').html());
              var recqty = parseFloat($(ctrl).closest('tr').find('#recqty').html());
              var rejqty = parseFloat($(ctrl).closest('tr').find('#rejqty').html());
              var penqty = parseFloat($(ctrl).closest('tr').find('#penqty').html());
              
              var total = reqqty - recqty - rejqty;
              if (parseFloat($(ctrl).val()) > parseFloat(total)) {
                  showerrormsg("Can Not Reject More Then Request Qty.!");
                  $(ctrl).val(total);
                  return;
              }

          }
          function precise_round(num, decimals) {
              return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
          }



          function rejectme(ctrl) {

              var rejctqty = $(ctrl).closest('tr').find('#txtrejectqty').val();
              var rejctreason = $(ctrl).closest('tr').find('#txtrejectreason').val();

              if (rejctqty == '' || rejctqty == '0') {

                  showerrormsg("Please Enter Reject Qty");
                  $(ctrl).closest('tr').find('#txtrejectqty').focus();
                  return;
              }
              if (rejctreason == '') {

                  showerrormsg("Please Enter Reject Reason");
                  
                  return;
              }

              $(ctrl).closest('tr').find('#txtrejectqty').hide();
              $(ctrl).closest('tr').find('#txtrejectreason').hide();
              $(ctrl).closest('tr').find('.mydel').hide();

              $(ctrl).closest('tr').addClass("reject");
           
             
              
              $.ajax({
                  url: "IndentIssueNew.aspx/RejectIndent",
                  data: '{IndentNo:"' + $('#<%=txtindentno.ClientID%>').val() + '",id:"' + $(ctrl).closest('tr').find('#tdid').html() + '",rejectqty:"' + rejctqty + '",Reason:"' + rejctreason + '"}', // parameter map      
                  type: "POST",
                  timeout: 120000,
               
                  contentType: "application/json; charset=utf-8",
                  dataType: "json",
                  success: function (result) {
                      
                      ItemData = result.d;


                      showmsg("Indent Item Rejected.!");
                     // bindindentdata();

                  },
                  error: function (xhr, status) {

                      alert(xhr.responseText);
                      

                  }
              });
          }
          </script>


    <script type="text/javascript">
        function showmystock(ctrl) {
            var tr = $(ctrl).closest('tr');
            $("#tblitemlist tr").removeClass("selected");

            tr.addClass("selected");

            showinnerstock(ctrl,"");
            
        }


      



    </script>


    <script type="text/javascript">

        function showinnerstock(ctrl, stockid) {

           
            if (stockid != "") {
                if ($('table#mytable').find('#' + stockid).length > 0) {
                    showerrormsg("Stock Already Added");

                    return;
                }
            }

            var itemid = $(ctrl).closest('tr').find('#tditemid').html();

            $('#tbl1 tr').slice(1).remove();

            var reqqty = parseFloat($(ctrl).closest('tr').find('#reqqty').html());
            var recqty = parseFloat($(ctrl).closest('tr').find('#recqty').html());
            var rejqty = parseFloat($(ctrl).closest('tr').find('#rejqty').html());
            var penqty = parseFloat($(ctrl).closest('tr').find('#penqty').html());
            //var total = reqqty - recqty - rejqty - penqty;
            var total = reqqty - penqty - rejqty;
            if (parseFloat(total) == 0) {
                return;
            }
           

            var locationid = $('#<%=lblcurrentlocationid.ClientID%>').val();
            
            $.ajax({
                url: "IndentIssueNew.aspx/GetStockIndent",
                data: '{itemid:"' + itemid + '",locationid:"' + locationid + '",stockid:"' + stockid + '"}', // parameter map      
                type: "POST",
                timeout: 120000,
               
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        showerrormsg("Stock Not Avilable");
                        $(ctrl).prop('checked', false);
                        
                        return;

                    }
                    else {

                        



                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "";
                            mydata += "<tr style='background-color:" + ItemData[i].Rowcolor + ";' id='" + ItemData[i].StockID + "'>";
                            mydata += '<td>' + parseInt(i + 1) + '</td>';
                            mydata += '<td id="tdbatchnumber">' + ItemData[i].BatchNumber + '</td>';
                            mydata += '<td id="tdbarcodeno">' + ItemData[i].barcodeno + '</td>';
                            mydata += '<td id="tdexpiry">' + ItemData[i].ExpiryDate + '</td>';
                           
                                mydata += '<td id="tdavlqty"  style="text-align:center;font-weight:bold;">' + precise_round(ItemData[i].AvailQty, 5) + '</td>';
                            
                                mydata += '<td>' + ItemData[i].MinorUnit + '</td>';

                                if (precise_round(ItemData[i].AvailQty, 5) >= precise_round(total, 5)) {
                                    mydata += '<td><input type="text" style="width:65px;" id="txtissueqty" placeholder="Issue Qty" onkeyup="showme1(this);"  value="' + precise_round(total, 5) + '" /></td>';
                                }
                                else {
                                    mydata += '<td><input type="text" style="width:65px;" id="txtissueqty" placeholder="Issue Qty" onkeyup="showme1(this);" /></td>';
                                }
                            
                            mydata += '<td><img id="mm" src="../../App_Images/Post.gif" style="cursor:pointer;" onclick="issuesingleitem(this)" /></td>';
                            mydata += '<td id="tdreqqty" style="display:none;">' + precise_round(total, 5) + '</td>';
                            mydata += '<td id="tditemid" style="display:none;">' + ItemData[i].ItemID + '</td>';
                           
                            mydata += '<td id="tditemname" style="display:none;">' + ItemData[i].ItemName + '</td>';

                            mydata += '<td id="tdMajorUnitInDecimal" style="display:none;">' + ItemData[i].MajorUnitInDecimal + '</td>';

                            mydata += '<td id="tdMinorUnitInDecimal" style="display:none;">' + ItemData[i].MinorUnitInDecimal + '</td>';
                            mydata += '<td id="tdMinorUnitInDecimal" style="display:none;">' + ItemData[i].MinorUnitInDecimal + '</td>';
                            mydata += '<td id="tdunitprice" style="display:none;">' + ItemData[i].UnitPrice + '</td>';
                            mydata += "</tr>";



                            $('#tbl1').append(mydata);
                        }
                       
                        if (stockid != "" && precise_round(ItemData[0].AvailQty, 5) >= precise_round(total, 5)) {
                            issuesingleitem($('#tbl1 tr').eq(1).find('#mm'));

                            $('#<%=txtbarcodeno.ClientID%>').focus();
                        }
                      
                        $('#tbl1 tr').eq(1).find('#txtissueqty').focus();

                        

                        $('#<%=txtbarcodeno.ClientID%>').val('');
                    }



                },
                error: function (xhr, status) {

                    alert(xhr.responseText);
                    

                }
            });
        }


        function showme1(ctrl) {

            if ($(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "" || $(ctrl).closest('tr').find('#tdMinorUnitInDecimal').html() == "0") {

                if ($(ctrl).val().indexOf(".") != -1) {
                    $(ctrl).val($(ctrl).val().replace('.', ''));
                }
            }


            //if ($(ctrl).val().indexOf(".") != -1) {
            //    $(ctrl).val($(ctrl).val().replace('.', ''));
            //}
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            // alert($(ctrl).closest("tr").find("#txttddisc").text());

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }


            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');

                return;
            }


            var avlqty = parseFloat($(ctrl).closest('tr').find('#tdavlqty').html());
           

            var reqqty = parseFloat($(ctrl).closest('tr').find('#tdreqqty').html());
           

         
         
            if (parseFloat($(ctrl).val()) > parseFloat(reqqty)) {
                showerrormsg("Can Not Issue More Then Requested Qty.!");
                $(ctrl).val('');
                return;
            }
            if (parseFloat($(ctrl).val()) > parseFloat(avlqty)) {
                showerrormsg("Can Not Issue More Then Avilable Qty.!");
                $(ctrl).val(avlqty);
                return;
            }

          

        }

        function issuesingleitem(ctrl) {
            if ($(ctrl).closest('tr').find('#txtissueqty').val() == "0" || $(ctrl).closest('tr').find('#txtissueqty').val() == "") {
                $(ctrl).closest('tr').find('#txtissueqty').focus();
                showerrormsg('Please Enter Issue Qty');
                return;
            }
            

            var indentno = $('#<%=txtindentno.ClientID%>').val();
            var itemid = $(ctrl).closest('tr').find('#tditemid').html();
            var stockid = $(ctrl).closest('tr').attr('id');
            var issueqty = $(ctrl).closest('tr').find('#txtissueqty').val();
          
            var batchnumber = $(ctrl).closest('tr').find('#tdbatchnumber').html();
            var barcodeno = $(ctrl).closest('tr').find('#tdbarcodeno').html();
            var expirydate = $(ctrl).closest('tr').find('#tdexpiry').html();
            var itemname = $(ctrl).closest('tr').find('#tditemname').html();
            var unitprice = $(ctrl).closest('tr').find('#tdunitprice').html();
            
            if ($('table#mytable').find('#' + stockid).length > 0) {
                showerrormsg("Stock Already Added");
                
                return;
            }
            var unitpricefinal = Number(unitprice) * Number(issueqty);
            var a = $('#mytable tr').length - 1;
            var mydata = "";
            mydata += "<tr style='background-color:white;' id='" + stockid + "' class='" + itemid + "'>";
            mydata += '<td>' + parseInt(a + 1) + '</td>';
            mydata += '<td id="tditemid1">' + itemid + '</td>';
            mydata += '<td id="tditemname">' + itemname + '</td>';
            mydata += '<td id="tdbarcodeno">' + barcodeno+ '</td>';
            mydata += '<td id="tdbatchnumber">' + batchnumber + '</td>';
            mydata += '<td id="tdexpiry">' + expirydate + '</td>';
            mydata += '<td id="tdunitpricefinal">' + precise_round(unitprice,5) + '</td>';
            
            mydata += '<td id="tdissueqty">' + precise_round(issueqty, 5) + '</td>';
            mydata += '<td id="tdunitpricetotal">' + precise_round(unitpricefinal, 5) + '</td>';
            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
            mydata += '<td id="tdindentno" style="display:none;">' + indentno + '</td>';
            mydata += '<td id="tditemid" style="display:none;">' + itemid + '</td>';
            

            mydata += "</tr>";


          
            $('#mytable').append(mydata);

            $('#btnsave').show();

            $('#tbl1 tr').slice(1).remove();

            var tr = $('table#tblitemlist').find("#" + itemid);
            tr.removeClass("selected");
            tr.addClass("added");
            tr.find('.mydel').hide();
            tr.find('#penqty').html(parseFloat(tr.find('#penqty').html()) + precise_round(issueqty, 5));
            calculatetotal();
            
        }


        function calculatetotal() {

            var finalamt = 0;
            $('#mytable tr').each(function () {

                if ($(this).attr('id') != 'tr11') {

                    var net = Number($(this).find('#tdunitpricetotal').html());
                    finalamt = finalamt + net;

                }
            });
            $('#<%=txttotal.ClientID%>').val(precise_round(finalamt, 5));



        }
        function searchitem() {

            
            $.ajax({
                url: "IndentIssueNew.aspx/getitemidfrombarcode",
                data: '{barcodeno:"' + $('#<%=txtbarcodeno.ClientID%>').val() + '",locationid:"' + $('#<%=lblcurrentlocationid.ClientID%>').val() + '"}', // parameter map      
                type: "POST",
                timeout: 120000,
               
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    $('#<%=txtbarcodeno.ClientID%>').val('');
                    ItemData = result.d;
                    if (ItemData == "") {
                        showerrormsg("Incorrect barcode.!");
                        
                    }
                    else {
                        
                        if ($('table#tblitemlist').find("#" + ItemData.split('#')[0]).length > 0) {
                           
                          


                            var tr = $('table#tblitemlist').find("#" + ItemData.split('#')[0]);
                            $("#tblitemlist tr").removeClass("selected");
                            tr.addClass("selected");



                            showinnerstock(tr, ItemData.split('#')[1]);

                         

                        }
                        else {
                            showerrormsg("Item Not Found in This Indent!");
                        }
                    }
                   

                },
                error: function (xhr, status) {

                    alert(xhr.responseText);
                    

                }
            });

        }

        function deleterow(itemid1) {

            var issueqty = $(itemid1).closest('tr').find("#tdissueqty").html();
            var itemid = $(itemid1).closest('tr').find("#tditemid").html();
         
            var tr = $('table#tblitemlist').find("#" + itemid);
          


            tr.find('#penqty').html(parseFloat(tr.find('#penqty').html()) - precise_round(issueqty, 5));



            var table = document.getElementById('mytable');
            table.deleteRow(itemid1.parentNode.parentNode.rowIndex);

          
            if ($('table#mytable').find("." + itemid).length == 0) {
              
                tr.removeClass("selected");
                tr.removeClass("added");
            }

            var count = $('#mytable tr').length;
            if (count == 0 || count == 1) {
                $('#btnsave').hide();
            }


            calculatetotal();
        }


    </script>



    <script type="text/javascript">

        function getissuedata() {

        

                var dataindent = new Array();
                $('#mytable tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "tr11") {


                        var objindentMaster = new Object();
                        objindentMaster.IndentNo = $(this).closest('tr').find('#tdindentno').html();
                        objindentMaster.itemid = $(this).closest('tr').find('#tditemid').html();
                        objindentMaster.stockid = $(this).closest('tr').attr('id');
                        objindentMaster.issueqty = $(this).closest('tr').find('#tdissueqty').html();
                        objindentMaster.BarcodeNo = $(this).closest('tr').find('#tdbarcodeno').html();

                        dataindent.push(objindentMaster);
                    }
                });

                return dataindent;

            }

        function saveall() {
            var count = $('#mytable tr').length;
            if (count == 0 || count == 1) {
                showerrormsg("Please Select Item To Issue.!");
            }
            var store_SaveIndentdetail = getissuedata();
            
            $.ajax({
                url: "IndentIssueNew.aspx/IssueItem",
                data: JSON.stringify({ IssueDetailData: store_SaveIndentdetail }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
               
                success: function (result) {
                    
                    if (result.d.split('#')[0] == "1") {
                        showmsg("Indent Issue Successfully..!");
                       
                        window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + result.d.split('#')[1]);
                        window.open('IndentIssueReceipt.aspx?Type=2&IndentNo=' + result.d.split('#')[2]);
                        clearForm();
                        

                    }
                    else {
                        showerrormsg(result.d.split('#')[1]);
                    }

                },
                error: function (xhr, status) {
                    
                    showerrormsg(xhr.responseText);
                }
            });
        }

        function clearForm() {

            $('#tbl1 tr').slice(1).remove();
            $('#mytable tr').slice(1).remove();
            $('#btnsave').hide();
            bindindentdata();
        }
    </script>
      <script type="text/javascript">

          function hideme(res) {
              $('#trme').hide();
              $('#trme').html('');


              showerrormsg(res);
          }
    </script>

</body>
</html>
