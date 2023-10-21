<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DosData.aspx.cs" Inherits="Design_Master_DosData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
     <%: Scripts.Render("~/bundles/WebFormsJs") %>
</head>
<body>
    <form id="form1" runat="server">
    <asp:HiddenField ID="hdnvalue" runat="server" Value="150#5#test" />
       <div id="Hearder_Container" style="height:32px;"> 
                     <div id="headerdiv"  style="height:50px; overflow:auto;">
                         <table id="Table1" style="width: 99%; border-collapse: collapse;" class="tb_grdLabSearch">
        <tr id="Tr1" >
            <td class="GridViewHeaderStyle" style="width:30px;">S.No</td>
            <td class="GridViewHeaderStyle" style="width:150px;">Location Name</td>
            <td class="GridViewHeaderStyle" style="width:60px;">TestCode</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Department Name</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Investigation Name</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Machine Name</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Method</td>
              <td class="GridViewHeaderStyle" style="width:100px;">In_Out_House</td>
             
            <td class="GridViewHeaderStyle" style="width:100px;">DeliveryDate</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Process Lab</td>
          
            <td class="GridViewHeaderStyle" style="width:100px;display:none;" >OutSourceLab</td>
          <th class="GridViewHeaderStyle" scope="col" style="width:100px;">DayType </th>
<td class='GridViewHeaderStyle'  style='width:260px;'> Technician Proccessing </td>
    <td class="GridViewHeaderStyle processing"  style="width: 100px;">Processing days   </td>
     <td class="GridViewHeaderStyle delivery"  style="width: 100px;">Delivery   </td>
             <td class="GridViewHeaderStyle"  style="width: 80px;">Booking cutoff </td>
            <td class="GridViewHeaderStyle"  style="width: 80px;">SRA cutoff </td>
            <td class="GridViewHeaderStyle"  style="width: 80px;">Reporting cutoff </td>

            </tr>
        </table>
                         </div>
           </div>
        
            
<div id="Receipt_div" style="height:450px; overflow:auto;" >


    <table id="tbltesttat" style="width: 99%; border-collapse: collapse;" class="tb_grdLabSearch">
        <tr id="header" >
            <td class="GridViewHeaderStyle" style="width:30px;">S.No</td>
            <td class="GridViewHeaderStyle" style="width:150px;">Location Name</td>
            <td class="GridViewHeaderStyle" style="width:60px;">TestCode</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Department Name</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Investigation Name</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Machine Name</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Method</td>
            <td class="GridViewHeaderStyle" style="width:100px;">In_Out_House</td>
           <td class="GridViewHeaderStyle" style="width:100px;">DeliveryDate</td>
            <td class="GridViewHeaderStyle" style="width:100px;">Process Lab</td>
            
            <td class="GridViewHeaderStyle" style="width:100px;display:none">OutSourceLab</td>
          <th class="GridViewHeaderStyle" scope="col" style="width:100px;">DayType </th>
<td class='GridViewHeaderStyle'  style='width:260px;'> Technician Processing </td>
    <td class="GridViewHeaderStyle processing"  style="width: 100px;">Processing days   </td>
     <td class="GridViewHeaderStyle delivery"  style="width: 100px;">Delivery   </td>
            <td class="GridViewHeaderStyle"  style="width: 80px;">Booking cutoff </td>
            <td class="GridViewHeaderStyle"  style="width: 80px;">SRA cutoff </td>
            <td class="GridViewHeaderStyle"  style="width: 80px;">Reporting cutoff </td>

            </tr>
        </table>
</div>

    <script type="text/javascript">
        $(document).ready(function () {
            debugger;
            if ($('<%=hdnvalue.ClientID%>').val() != "") {
                BindDosData();
            }
        });

        function BindDosData() {
            var data = $('#<%=hdnvalue.ClientID%>').val();
            $.ajax({
                url: "DosData.aspx/searchdataTAT",
                data: JSON.stringify({ investigationid: data.split('#')[0], centerid: data.split('#')[1], type: data.split('#')[2], isurgent: data.split('#')[3] }), // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    if (TestData.length == 0) {
                        FixHeader();
                        alert('No Record Found..!');
                        return;
                    }
                    else {
                        for (var i = 0; i < TestData.length ; i++) {
                            var delData = (TestData[i].deliverydate == '01-Jan-0001 12:00 AM') ? '' : TestData[i].deliverydate;

                            var mydata = "<tr id='115' class='GridViewItemStyle' style='background-color:lemonchiffon'>";
                            mydata += "<td style='width:30px;' class='GridViewItemStyle'>" + (i + 1) + "</td><td class='GridViewItemStyle' style='width:150px;'>" + TestData[i].LocationName + "</td><td class='GridViewItemStyle' style='width:60px;'>" + TestData[i].TestCode + "</td><td class='GridViewItemStyle' style='width:100px;'>" + TestData[i].DepartmentName + "</td><td class='GridViewItemStyle'  style='width:100px;'>" + TestData[i].InvestigationName + "</td><td class='GridViewItemStyle'  style='width:100px;'>" + TestData[i].MachineName + "</td><td class='GridViewItemStyle'  style='width:100px;'>" + TestData[i].Method + "</td><td class='GridViewItemStyle'  style='width:100px;'>" + TestData[i].In_Out_House + "</td><td class='GridViewItemStyle'  style='width:100px;'>" + delData + "</td><td class='GridViewItemStyle'  style='width:100px;'>" + TestData[i].prolab + "</td><td class='GridViewItemStyle'  style='width:100px;display:none'>" + TestData[i].OutSourceLab + "</td>";
                            mydata += " <td style='width:100px;' class='GridViewItemStyle'>" + TestData[i].DayType + "</td>";
                            mydata += "<td style='width:260x;' id='Td1' class='GridViewLabItemStyle' Style='width:290px;background-color:lightgoldenrodyellow;text-align:center;'> <div  id='div_Weeks_Proc'>";
                            mydata += "<span id='chkSun_Proc'  flag='" + TestData[i].Sun_Proc + "' style='cursor:pointer;' class='" + TestData[i].Sun_Proc.replace('1', 'GridViewDragItemStyle') + "'>Sun, </span> ";
                            mydata += "<span id='chkMon_Proc'  flag='" + TestData[i].Mon_Proc + "' style='cursor:pointer;'  class='" + TestData[i].Mon_Proc.replace('1', 'GridViewDragItemStyle') + "'>Mon, </span> ";
                            mydata += "<span id='chkSun_Proc'  flag='" + TestData[i].Tue_Proc + "' style='cursor:pointer;' class='" + TestData[i].Tue_Proc.replace('1', 'GridViewDragItemStyle') + "'>Tue, </span> ";
                            mydata += "<span id='chkMon_Proc'  flag='" + TestData[i].Wed_Proc + "' style='cursor:pointer;'  class='" + TestData[i].Wed_Proc.replace('1', 'GridViewDragItemStyle') + "'>Wed, </span> ";
                            mydata += "<span id='chkSun_Proc'  flag='" + TestData[i].Thu_Proc + "' style='cursor:pointer;' class='" + TestData[i].Thu_Proc.replace('1', 'GridViewDragItemStyle') + "'>Thu, </span> ";
                            mydata += "<span id='chkMon_Proc'  flag='" + TestData[i].Fri_Proc + "' style='cursor:pointer;'  class='" + TestData[i].Fri_Proc.replace('1', 'GridViewDragItemStyle') + "'>Fri, </span> ";
                            mydata += "<span id='chkSun_Proc'  flag='" + TestData[i].Sat_Proc + "' style='cursor:pointer;' class='" + TestData[i].Sat_Proc.replace('1', 'GridViewDragItemStyle') + "'>Sat </span>   </div></td>";

                            if (TestData[i].testprocessingday == "0")
                            {
                                TestData[i].testprocessingday = "Same";
                            }

                            if (TestData[i].DayType == "Day") {
                                mydata += "<td style='width:100px;'  class='GridViewLabItemStyle processing'>" + TestData[i].testprocessingday + " Days  </td>";
                                $('.delivery').hide();
                                $('.processing').show();
                            }
                            else {
                                $('.delivery').show();
                                $('.processing').hide();
                                mydata += "<td style='width:100px;' id='Td2' class='GridViewLabItemStyle delivery' Style='width:290px;background-color:lightgoldenrodyellow;text-align:center;'> <div  id='div_Weeks_Proc'>";
                                mydata += "<span id='chkSun'  flag='" + TestData[i].Sun + "' style='cursor:pointer;' class='" + TestData[i].Sun.replace('1', 'GridViewDragItemStyle') + "'>Sun, </span> ";
                                mydata += "<span id='chkMon'  flag='" + TestData[i].Mon + "' style='cursor:pointer;' class='" + TestData[i].Mon.replace('1', 'GridViewDragItemStyle') + "'>Mon, </span> ";
                                mydata += "<span id='chkTue'  flag='" + TestData[i].Tue + "' style='cursor:pointer;' class='" + TestData[i].Tue.replace('1', 'GridViewDragItemStyle') + "'>Tue, </span> ";
                                mydata += "<span id='chkWed'  flag='" + TestData[i].Wed + "' style='cursor:pointer;' class='" + TestData[i].Wed.replace('1', 'GridViewDragItemStyle') + "'>Wed, </span> ";
                                mydata += "<span id='chkThu'  flag='" + TestData[i].Thu + "' style='cursor:pointer;' class='" + TestData[i].Thu.replace('1', 'GridViewDragItemStyle') + "'>Thu, </span> ";
                                mydata += "<span id='chkFri'  flag='" + TestData[i].Fri + "' style='cursor:pointer;' class='" + TestData[i].Fri.replace('1', 'GridViewDragItemStyle') + "'>Fri, </span> ";
                                mydata += "<span id='chkSat'  flag='" + TestData[i].Sat + "' style='cursor:pointer;' class='" + TestData[i].Sat.replace('1', 'GridViewDragItemStyle') + "'>Sat </span>   </div></td>";
                               
                            }
                            mydata += "<td  style='width: 80px;'> " + TestData[i].bookingcutoff + "  </td> ";
                            mydata += "<td  style='width: 80px;'> " + TestData[i].sracutoff + "  </td> ";
                            mydata += "<td  style='width: 80px;'> " + TestData[i].reportingcutoff + "  </td> ";
                            mydata += "";
                            mydata += "";
                            mydata += "";
                            $("#tbltesttat").append(mydata);
                            $("#Table1").append(mydata);
                        }
                    }

                    $('.0').text('');
                    FixHeader();
                   
                }
            });


        }


        function FixHeader() {
            $("#Hearder_Container").attr("style", "height:" + $(".tb_grdLabSearch tr:first").height() + "px");
            $("#Hearder_Container").hide();
            $("#Receipt_div").scroll(function () {

                if ($(this).scrollTop() > $(".tb_grdLabSearch tr:first").height()) {
                    $("#Hearder_Container").show();
                    $(document).scrollTop($(document).height());
                }
                else {
                    $("#Hearder_Container").hide();
                }
                $("#headerdiv").scrollLeft($("#Receipt_div").scrollLeft());
            });


            $("#headerdiv").scroll(function () {
                $(this).scrollTop(0)
            });

        };


        </script>
    </form>
</body>
</html>
