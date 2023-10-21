<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CashoutstandingManualEmail.aspx.cs" Inherits="Design_Master_CashoutstandingManualEmail" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />


    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>


    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>



    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 1304px;">
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">

           
                    Cash Outstanding Email  &nbsp; &nbsp; 
                
             
        </div>


        
             <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader" >
                Cash Outstanding Email  &nbsp; &nbsp; 
            </div>
            <table width="99%">
                <tr>
                    

                    <td >Employee :</td>
                    <td>

                        <asp:ListBox ID="lstEmployee" CssClass="multiselect" SelectionMode="Multiple" Width="225px" runat="server" ClientIDMode="Static"></asp:ListBox>
                    </td>


                </tr>
                <tr>
                    <td >From Date  :</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtFromDate" runat="server" Width="110px" ></asp:TextBox>
                         <cc1:CalendarExtender runat="server" ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                    </td>
                    <td >To Date :</td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtToDate" runat="server" Width="110px" ></asp:TextBox>
                         <cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                    </td>

                </tr>

                <tr>

                    
                </tr>
            </table>
 </div>
                 <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">
            <input type="button" id="butsave" class="searchbutton" value="Search" onclick="Binddata()" />
                     <table   style="width:35%;border-collapse:collapse;padding-left:500px;">
                        <tr>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            

                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #FFC0CB;" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Not Approved </td>
                                 <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;"  >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Approved</td>
                                  <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#00FFFF;"  >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                 Cancel</td>
                               
                            
                            
                            
                        </tr>
                    </table>
        </div>
       

     



        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="content">
                <div class="Purchaseheader">
                    Cash Outstanding Email Detail
                </div>

                <div style="width: 99%; max-height: 375px; overflow: auto;">
                    <table id="tblitemlist" style="width: 99%; border-collapse: collapse; text-align: left;">
                        <tr id="triteheader">

                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle">Visit No.</td>
                            <td class="GridViewHeaderStyle" style="width: 200px;">Bill No. </td>
                            <td class="GridViewHeaderStyle" style="width: 114px;">Bill Date</td>
                            <td class="GridViewHeaderStyle">Patient Name</td>
                            <td class="GridViewHeaderStyle">Gross Amt.</td>
                            <td class="GridViewHeaderStyle">Discount Amt.</td>
                             <td class="GridViewHeaderStyle">Net Amt. </td>
                            <td class="GridViewHeaderStyle">Outstanding Amt. </td>
                            <td class="GridViewHeaderStyle">Outstanding By </td>
                             <td class="GridViewHeaderStyle">Send Mail </td>
                        </tr>
                    </table>

                </div>

            </div>
        </div>
    </div>


    <script type="text/javascript">
        $(document).ready(function () {
            Binddata();
            bindEmployee();
        });


        function Binddata()
        {
            var AllEmployee = $('#<%=lstEmployee.ClientID%>').val();
            var fromdate = $('#<%=txtFromDate.ClientID%>').val();
            var toDate = $('#<%=txtToDate.ClientID%>').val();    
            $('#tblitemlist tr').slice(1).remove();
            $modelBlockUI();
            $.ajax({
                url: "CashoutstandingManualEmail.aspx/BindData",
                data: '{AllEmployee:"' + AllEmployee + '",fromdate:"' + fromdate + '",toDate:"' + toDate + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);
                  
                    if (TestData.length == 0) {

                        $modelUnBlockUI();
                        showerrormsg("No Data Found..!");
                        return;
                    }
                    else {
                        $modelUnBlockUI();
                        for (var i = 0; i < TestData.length; i++) {

                            var mydata = "<tr id='" + TestData[i].LedgerTransactionNo + "'  style='background-color:" + TestData[i].rowcolor + ";'>";
                            mydata += '<td class="GridViewLabItemStyle">' + (i+1) + '</td>';
                            mydata += '<td id="tdLedgerTransactionNo" class="GridViewLabItemStyle">' + TestData[i].LedgerTransactionNo + '</td>';
                            mydata += '<td id="tdBillNo" class="GridViewLabItemStyle">' + TestData[i].BillNo + '</td>';
                            mydata += '<td id="tdBillDATE" class="GridViewLabItemStyle">' + TestData[i].BillDATE + '</td>';
                            mydata += '<td id="tdPName" class="GridViewLabItemStyle">' + TestData[i].PName + '</td>';
                            mydata += '<td id="tdage" class="GridViewLabItemStyle" style="Display:none;">' + TestData[i].age + '</td>';
                            mydata += '<td id="tdgender" class="GridViewLabItemStyle" style="Display:none;">' + TestData[i].gender + '</td>';
                            mydata += '<td id="tdcentre" class="GridViewLabItemStyle" style="Display:none;">' + TestData[i].centre + '</td>';
                            mydata += '<td id="tdGrossAmount" class="GridViewLabItemStyle">' + TestData[i].GrossAmount + '</td>';
                        
                            mydata += '<td id="tdDiscountOnTotal" class="GridViewLabItemStyle">' + TestData[i].DiscountOnTotal + '</td>';
                            mydata += '<td id="tdNetAmount" class="GridViewLabItemStyle">' + TestData[i].NetAmount + '</td>';
                            mydata += '<td id="tdCashOutstanding" class="GridViewLabItemStyle">' + TestData[i].CashOutstanding + '</td>'; 
                            mydata += '<td id="tdOutstandingEmployeeId" class="GridViewLabItemStyle" style="Display:none;">' + TestData[i].OutstandingEmployeeId + '</td>';
                            mydata += '<td id="tdName" class="GridViewLabItemStyle">' + TestData[i].Name + '</td>';
                            mydata += '<td id="tdsendemail" class="GridViewLabItemStyle" style="Display:none;">' + TestData[i].email + '</td>';
                            if (TestData[i].OutstandingStatus == "0") {
                                mydata += '<td class="GridViewLabItemStyle"><img src="../../App_Images/EmailICON.png" style="cursor:pointer;width:20px;height:20px;" ';
                                mydata += 'onclick="EmailResend(' + TestData[i].LedgerTransactionID + ')"/></td>';
                            }
                            else {
                                mydata += '<td id="tdName" class="GridViewLabItemStyle"></td>'

                            }
                           
                            mydata += "</tr>";
                            $('#tblitemlist').append(mydata);
                        }
                    }
                            


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

       



        function EmailResend(LedgerTransactionID) {
            $.ajax({
                url: "CashoutstandingManualEmail.aspx/SendOutstandingVerificationmail",
                data: '{ LedgerTransactionID:' + LedgerTransactionID + ' }',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showerrormsg("Mail Send Successfully");
                        Binddata();
                    }
                    else if (result.d == "2") {
                        showerrormsg("Email is Empty");
                        Binddata();
                    }
                }
            });

        }




        function bindEmployee() {
            jQuery('#<%=lstEmployee.ClientID%> option').remove();
             jQuery.ajax({
                 url: "CashoutstandingManualEmail.aspx/bindEmployee",
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
                    alert("Error ");
                }
            });

        }

    </script>
</asp:Content>

