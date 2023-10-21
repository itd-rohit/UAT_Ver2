<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CashOutstandingMaster.aspx.cs" Inherits="Design_Master_CashOutstandingMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />


   


    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>


    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    
    <div id="Pbody_box_inventory" style="width: 1306px;">
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">

           
              
                   <b> Cash Outstanding Master  <b/>
               
           

        </div>


        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader" >
                Cash Outstanding Master  &nbsp; &nbsp; 
            </div>
            <table width="99%">
                <tr>
                    <td class="required" >Centre :</td>
                    <td style="text-align: left">
                        <asp:ListBox ID="lstCenter" CssClass="multiselect" SelectionMode="Multiple" Width="225px" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>

                    <td class="required">Employee :</td>
                    <td>

                        <asp:ListBox ID="lstEmployee" CssClass="multiselect" SelectionMode="Multiple" Width="225px" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>


                </tr>
                <tr>
                    <td class="required">Max Outstanding Amt. :</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtoutstandingamt" runat="server" onkeyup="setitOutstanding(this);" Width="225px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbtxtoutstandingamt" runat="server" FilterType="Numbers,Custom" ValidChars="." TargetControlID="txtoutstandingamt">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td class="required">Max Bill (%) :</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtmaxbill" runat="server" Width="225px" onkeyup="setitOutstandingPer(this);"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="Filtxtmaxbill" runat="server" FilterType="Numbers,Custom" ValidChars="." TargetControlID="txtmaxbill">
                        </cc1:FilteredTextBoxExtender>
                    </td>

                </tr>
            </table>

        </div>


        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">
            <input type="button" id="butsave" class="searchbutton" value="Save" onclick="SaveData()" />
        </div>



        <div class="POuter_Box_Inventory" style="width: 1300px;">
           
                <div class="Purchaseheader">
                    Cash Outstanding Detail
                </div>

                <div style="width: 99%; max-height: 375px; overflow: auto;">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">

                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle">Center</td>
                            <td class="GridViewHeaderStyle" style="width: 200px;">Employee</td>
                            <td class="GridViewHeaderStyle" style="width: 114px;">Max Outstanding Amount</td>
                            <td class="GridViewHeaderStyle">Max Bil(%)</td>
                            <td class="GridViewHeaderStyle">Create By</td>
                            <td class="GridViewHeaderStyle">Create Date</td>
                             <td class="GridViewHeaderStyle">Action </td>
                            <td class="GridViewHeaderStyle">Remove </td>
                        </tr>
                    </table>

                

            </div>
        </div>
    </div>
    <script type="text/javascript">


        $(function () {


           
            bindCentre("");
            bindEmployee();
            BindData();

        });


        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }



        function bindCentre() {
            $('#<%=lstCenter.ClientID%> option').remove();
          
            jQuery.ajax({
                url: "CashOutstandingMaster.aspx/bindCentre",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    
                    var centreData = jQuery.parseJSON(result.d);

                    for (i = 0; i < centreData.length; i++) {
                        $('#<%=lstCenter.ClientID%>').append(jQuery("<option></option>").val(centreData[i].Centreid).html(centreData[i].centre));
                    }
                    $('#<%=lstCenter.ClientID%>').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                       
                    });
                   
        
                  

                },
                error: function (xhr, status) {
                     toast("Error", "Error", "");
                }
            });

        }

        function bindEmployee() {
            jQuery('#<%=lstEmployee.ClientID%> option').remove();
            jQuery.ajax({
                url: "CashOutstandingMaster.aspx/bindEmployee",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var EmployeeData = jQuery.parseJSON(result.d);
                    for (i = 0; i < EmployeeData.length; i++) {
                        $('#<%=lstEmployee.ClientID%>').append(jQuery("<option></option>").val(EmployeeData[i].employee_id).html(EmployeeData[i].NAME));
                         }
                         $('#<%=lstEmployee.ClientID%>').multipleSelect({
                             includeSelectAllOption: true,
                             filter: true, keepOpen: false
                         });
                     },
                     error: function (xhr, status) {
                        toast("Error", "Error", "");
                     }
                 });

             }
    </script>

    <script type="text/javascript">
       
        function SaveData() {
            var AllCenter = $('#<%=lstCenter.ClientID%>').val();
            var AllEmployee = $('#<%=lstEmployee.ClientID%>').val();
            var OutstandingAmount = $('#<%=txtoutstandingamt.ClientID%>').val();
            var MaxBill = $('#<%=txtmaxbill.ClientID%>').val();



            if (AllCenter == "" || AllCenter == null) {
                
toast("Info", "Please Select Center", "");
                return;
            }

            if (AllEmployee == "" || AllEmployee == null) {
                
toast("Info", "Please Select Employee", "");
                return;
            }
            if (OutstandingAmount == "" || OutstandingAmount == null || OutstandingAmount == "0") {
                
 toast("Info", "Please Enter Outstanding Amount", "");
                return;
            }

            if (MaxBill == "" || MaxBill == null || MaxBill == "0") {
               
 toast("Info", "Please Enter Max Bill", "");
                return;
            }

            jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
            jQuery.ajax({
                url: "CashOutstandingMaster.aspx/SaveData",
                data: '{ Center: "' + AllCenter + '",Emoployee: "' + AllEmployee + '",MaxOutstandingAmt: "' + OutstandingAmount + '",MaxBill: "' + MaxBill + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        toast("Success", "Record Save Successfully", "");
                        clearform();                                            
                    }
                    else if (result.d == "2") {
                    toast("Info", "Data Already Exist !!", "");
                                                                                                              
                    }
                    else {                      
                        toast("Error", "Something Went Wrong", "");
                      
                        clearform();                        
                    }
                      $modelUnBlockUI();
                      clearform();
                      BindData();
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });



        }

        function clearform() {
            $('#<%=txtoutstandingamt.ClientID%>').val("");
            $('#<%=txtmaxbill.ClientID%>').val("");
            bindCentre();
            bindEmployee();
        }

    </script>


    <script type="text/javascript">
        function BindData() {
          
            jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
            jQuery.ajax({
                url: "CashOutstandingMaster.aspx/BindData",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        jQuery('#tblitemlist tr').slice(1).remove();
                        toast("Info", "No data Found", "");
                       
                        $modelUnBlockUI();
                    }
                    else {
                        jQuery('#tblitemlist tr').slice(1).remove();
                        $modelUnBlockUI();
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var mydata = "<tr style='background-color:#90EE90' >";
                            mydata += '<td id="cshid" style="display:none;" class="GridViewLabItemStyle" >' + ItemData[i].id + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                            mydata += '<td id="center"  class="GridViewLabItemStyle">' + ItemData[i].centre + '</td>';
                            mydata += '<td id="name" class="GridViewLabItemStyle" >' + ItemData[i].name + '</td>';
                            mydata += '<td id="amount" class="GridViewLabItemStyle" >' + ItemData[i].MaxOutstandingAmt + '</td>';
                            mydata += '<td style="display:none;" id="txtamount" class="GridViewLabItemStyle" ><input type="text" style="width: 80px;" onkeyup="setitOutstanding(this);" name="MaxOutstandingAmt" value=' + ItemData[i].MaxOutstandingAmt + '></td>';
                            mydata += '<td id="bill" class="GridViewLabItemStyle" >' + ItemData[i].MaxBill + '</td>';
                            mydata += '<td style="display:none;" id="txtbill" class="GridViewLabItemStyle" ><input type="text" name="MaxBill" style="width: 80px;" onkeyup="setitOutstandingPer(this)" value=' + ItemData[i].MaxBill + '></td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].CreatedBy + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >' + ItemData[i].CreatedDate + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" >  <input type="button" id="btnEdit" class="searchbutton" value="Edit" onclick="EditeData(this)" /> <input style="display:none;" type="button" id="btnUpdate" class="searchbutton" value="Update" onclick="UpdateData(this)" />   <input style="display:none;" type="button" id="btnCancel" class="searchbutton" value="Cancel" onclick="CancelData(this)" /></td>';
                            mydata += '<td id="tdremove"   class="GridViewLabItemStyle"  style="text-align: center"> <a href="javascript:void(0);" onclick="RemoveData(this);"><img class="img_Delete" src="../../App_Images/Delete.gif"  title="Click to Remove Item"/></a></td>';
                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);

                        }


                    }

                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    alert("Error ");
                }
            });

        }






        function setitOutstandingPer(ctrl) {
            var Per = 0;


            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
            }

            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }

            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }


            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('0');

                return;
            }


            if ($(ctrl).val() != "")
                Per = parseInt($(ctrl).val());
            $(ctrl).val(Per);
            if (Per > 100) {
                toast("Info", "Outstanding percentage cannot exceed 100%", "");
               
                $(ctrl).val('0');
                Per = 0
            }
        }


        function setitOutstanding(ctrl) {
            if ($(ctrl).val().indexOf(".") != -1) {
                $(ctrl).val($(ctrl).val().replace('.', ''));
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
                $(ctrl).val('0');

                return;
            }
            if ($(ctrl).val() != "")
                $(ctrl).val(parseInt($(ctrl).val()));
           
        }
    </script>


    <script type="text/javascript">

        function EditeData(ctrl) {
           
            $(ctrl).closest('tr').find('#amount').hide();
            $(ctrl).closest('tr').find('#bill').hide();
            $(ctrl).closest('tr').find('#btnEdit').hide();
            $(ctrl).closest('tr').find('#tdremove').hide();
            $(ctrl).closest('tr').find('#btnUpdate').show();
            $(ctrl).closest('tr').find('#btnCancel').show();
            $(ctrl).closest('tr').find('#txtamount').show();
            $(ctrl).closest('tr').find('#txtbill').show(); 
        }



        function UpdateData(ctrl)
        {
            
         
            var center = $(ctrl).closest('tr').find('#center').text();
            var id = $(ctrl).closest('tr').find('#cshid').text();
            var employee = $(ctrl).closest('tr').find('#name').text();
            var amount = $(ctrl).closest('tr').find('#txtamount input[type="text"]').val();
            
            var bill = $(ctrl).closest('tr').find('#txtbill input[type="text"]').val();


            if (amount == "" || amount == null || amount == "0") {
        
                toast("Error", "Please Enter Outstanding Amount", "");
                return;
            }

            if (bill == "" || bill == null || bill == "0") {
                toast("Error", "Please Enter Max Bill", "");

                return;
            }

         $.ajax({
            url: "CashOutstandingMaster.aspx/UpdateData",
            data: '{id:"' + id + '",maxamount:"' + amount + '",maxbill: "' + bill + '"}',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                ItemData = jQuery.parseJSON(result.d);
                $(ctrl).closest('tr').find('#btnUpdate').hide();
                $(ctrl).closest('tr').find('#txtamount').hide();
                $(ctrl).closest('tr').find('#txtbill').hide();
                $(ctrl).closest('tr').find('#amount').show();
                $(ctrl).closest('tr').find('#bill').show();
                $(ctrl).closest('tr').find('#btnEdit').show();
                
                toast("Success", "Update Successfully", "");
                BindData();
            }
        });
        
  }



        function RemoveData(ctrl)
        {
            var r = confirm("Are you sure you want Remove this record.");
            if (r == true) {
                jQuery.blockUI({ message: 'Please Wait.....\n<img src="<%=ResolveUrl("~/App_Images/Progress.gif")%>" />' });
                var id = $(ctrl).closest('tr').find('#cshid').text();
                $.ajax({
                    url: "CashOutstandingMaster.aspx/RemoveData",
                    data: '{id:"' + id + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1");
                        {
                            toast("Success", "Employee Remove Successfully", "");
                            
                        }
                        BindData();
                        $modelUnBlockUI();
                    },
                    error: function (xhr, status) {
                        $modelUnBlockUI();
                        toast("Error", "Error", "");
                    }
                });
            }
        }


        function CancelData(ctrl)
        {
            $(ctrl).closest('tr').find('#amount').show();
            $(ctrl).closest('tr').find('#bill').show();
            $(ctrl).closest('tr').find('#btnEdit').show();
            $(ctrl).closest('tr').find('#tdremove').show();
            $(ctrl).closest('tr').find('#btnUpdate').hide();
            $(ctrl).closest('tr').find('#btnCancel').hide();
            $(ctrl).closest('tr').find('#txtamount').hide();
            $(ctrl).closest('tr').find('#txtbill').hide();

        }

    </script>


</asp:Content>

