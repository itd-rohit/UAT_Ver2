<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HistoImmunoChemistry.aspx.cs" Inherits="Design_Lab_HistoImmunoChemistry" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %> 
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
         <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
       <%: Scripts.Render("~/bundles/WebFormsJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
 
    <title>Immuno Chemistry</title>

    <script type="text/javascript">


        var values = [];
        var PatientData = "";
        var TestID = '<%=TestID %>';
        var LabNo = '<%=LabNo %>';

        $(document).ready(function () {

            var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
            $('#PatientLabSearchOutput').html(output);


            getdata();
            var options = $('#<% = lstlist.ClientID %> option');
            $.each(options, function (index, item) {
                values.push(item.innerHTML);
            });


            $('#<% = txtsearch.ClientID %>').keyup(function (e) {

                var key = (e.keyCode ? e.keyCode : e.charCode);


                if (key == 38 || key == 40) {
                    var index = $('#<% = lstlist.ClientID %>').get(0).selectedIndex;
                    if (key == 38)
                        $('#<% = lstlist.ClientID %> ').attr('selectedIndex', index - 1);
                    else if (key == 40)
                        $('#<% = lstlist.ClientID %> ').attr('selectedIndex', index + 1);

                    $('#<% = txtsearch.ClientID %>').val($('#<% = lstlist.ClientID %> :selected').text());
                }
                else {
                    var filter = $(this).val();
                    if (filter == '') {
                        $('#<% = lstlist.ClientID %> option:nth-child(1)').attr('selected', 'selected');


                        return;
                    }
                    DoListBoxFilter('#<% = lstlist.ClientID %>', '#<% = txtsearch.ClientID %>', "0", filter, values);
                }


            });

        });

        function DoListBoxFilter(listBoxSelector, textbox, searchtype, filter, values) {

           

            var list = $(listBoxSelector);
            var selectBase = '<option value="{0}">{1}</option>';

      

            if (searchtype == "0") {
                for (i = 0; i < values.length; ++i) {

                    var value = values[i].trim();

                  
                      

                    var len = $(textbox).val().length;
                    if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                        list.attr('selectedIndex', i);

                        return;
                    }
                }
            }
         


            $(textbox).focus();

        }

        function addme() {

            if ($("#<%=lstlist.ClientID%>").attr('selectedIndex') == -1) {
                alert("Please Select Item From List");
                return;
            }
            var dup = 0;

            $('#tb_grdLabSearch tr').each(function () {
                if ($(this).attr("id") != "header") {
                    if ($(this).find("#antiname").html() == $('#<%=lstlist.ClientID%> option:selected').text()) {
                        dup = 1;
                        return;
                    }
                }
            });

            if (dup == 1) {
                alert("Antibodies Already In List..!");
                return;
            }
            $('#<%=lstlist.ClientID%> option:selected').text()

            var a = $('#tb_grdLabSearch tr').length - 1;
            var mydata = "<tr style='background-color:#fdf0dc;height:30px;'>";
            mydata += '<td>' + parseFloat(a + 1) + '</td>';
            mydata += '<td id="antiname" align="left">' + $('#<%=lstlist.ClientID%> option:selected').text() + '</td>';
            mydata += '<td id="antiid" align="left" style="display:none;">' + $('#<%=lstlist.ClientID%> option:selected').val() + '</td>';
          
            mydata += ' <td  id="clone"><input class="oobbss1" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="type"><input class="oobbss2" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="result"><input class="oobbss3" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="intensity"><input class="oobbss4" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="pattern"><input class="oobbss5" type="text" style="width:80px;"  />   </td>';
            mydata += '<td  id="percentage"><input class="oobbss6" type="text" style="width:80px;"  />   </td>';
            mydata += '<td><img src="../../Design/Purchase/Image/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';
            mydata += '</tr>';

            $('#tb_grdLabSearch').append(mydata);
        }

        function deleterow(itemid) {
            var table = document.getElementById('tb_grdLabSearch');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

        }

        function closeme() {
            this.close();
        }



        function getcompletedataadj() {

            var comment = "";
            var objEditor = CKEDITOR.instances['<%=txtcomments.ClientID%>'];
            comment = objEditor.getData();

            var tempData = [];
            $('#tb_grdLabSearch tr').each(function () {
                if ($(this).attr("id") != "header") {
                    var itemmaster = [];
                    itemmaster[0] = TestID;
                    itemmaster[1] = LabNo;
                    itemmaster[2] = $(this).find("#antiname").html();
                    itemmaster[3] = $(this).find("#antiid").html();
                    itemmaster[4] = $(this).find(".oobbss1").val();
                    itemmaster[5] = $(this).find(".oobbss2").val();
                    itemmaster[6] = $(this).find(".oobbss3").val();
                    itemmaster[7] = $(this).find(".oobbss4").val();
                    itemmaster[8] = $(this).find(".oobbss5").val();
                    itemmaster[9] = $(this).find(".oobbss6").val();
                    itemmaster[10] = $('#txtinter').val();
                    itemmaster[11] = comment;
                    tempData.push(itemmaster);
                }
            });
            return tempData;
        }



        function savedata() {

            if ($('#tb_grdLabSearch tr').length == "1" || $('#tb_grdLabSearch tr').length == 0) {
                alert("Please Select Antibodies To Save..!");
                return;
            }


            var mydataadj = getcompletedataadj();

            $.ajax({
                url: "HistoImmunoChemistry.aspx/savedata",
                data: JSON.stringify({ mydataadj: mydataadj }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    PanelData = $.parseJSON(result.d);
                    if (PanelData == "1") {
                        alert("Data Saved Successfully..!");
                      
                       // printonly();
                    }
                    else {
                        alert(PanelData);
                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });


        }

        function printonly() {

            if ($('#tb_grdLabSearch tr').length == "1" || $('#tb_grdLabSearch tr').length == 0) {
                alert("Please Select Antibodies To Print..!");             
                return;
            }
            this.close();
            window.open("HistoImmunoData.aspx?testid=" + TestID + "&labno=" + LabNo);
        }

        function getdata() {

            $.ajax({
                url: "HistoImmunoChemistry.aspx/getdata",
                data: '{labno:"' + LabNo + '",testid:"' + TestID + '" }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                  
                    PatientData = $.parseJSON(result.d);
                    var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                    $('#PatientLabSearchOutput').html(output);
                    if (PatientData.length > 0) {
                        $('#txtinter').val(PatientData[0].interpretation);

                     
                    }
                 
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    StatusOFReport = "";
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


        }
        
        $(document).ready(function () {
            $('#<% = lstlist.ClientID %>').keydown(function (e) {

                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 13) {
                    e.preventDefault();
                    var index = $('#<% = lstlist.ClientID %>').get(0).selectedIndex;
                    if (index == -1) {
                        alert('Kindly Select an Investigation');
                        return;
                    }
                 
                    addme();

                    //$('#<% = lstlist.ClientID %> option:nth-child(1)').attr('selected', 'selected');


                }

                else if (key == 38 || key == 40) {
                    var index = $('#<% = lstlist.ClientID %>').get(0).selectedIndex;
                    if (key == 38)
                        $('#<% = lstlist.ClientID %> ').attr('selectedIndex', index);
                    else if (key == 40)
                        $('#<% = lstlist.ClientID %> ').attr('selectedIndex', index);


                }



            });
        });
    
   
 
    </script>
</head>
<body>
    <form id="form1" runat="server">
    
      <div id="Pbody_box_inventory" style="width:1210px;">
  <div id="div_HistoReporting"   class="POuter_Box_Inventory" style="width:1210px;">
            <div class="content" style="width:1210px;">
                

                <table style="width:1200px;">
                   

                    <tr>
                        <td valign="top" width="300px">
                              <div class="Purchaseheader">Search Antibiotic</div>
                            <asp:TextBox ID="txtsearch" runat="server" Width="99%"></asp:TextBox>

                            <br />
                            <br />
                            <asp:ListBox ID="lstlist" runat="server"   Width="99%" Height="464px"/>

                            </td>
                          <td style="width:40px;" valign="top">
                              <br /> <br /> <br /> <br /> <br />
                              <input type="button" value=">>" onclick="addme()" style="font-weight:bold;cursor:pointer;" />
                              </td>
                           <td style="border:1px solid black;width:860px;" valign="top">
                               <table style="width:100%;background-color:white">
                                   <tr>
                                       <td style="text-align:center;font-weight:bold;color:maroon" >
                                           Selected Immuno-HistoChemistry Antibodies
                                           <br />
                                                                                   </td>


                                   </tr>

                                   <tr>
                                       <td>
                                           <div id="PatientLabSearchOutput" style="width:99%;height:219px; overflow:scroll;"></div>
                                          
                                            </td>


                                           </tr>
                                  

                               </table>
                               <br />   <br />
                                 <b>&nbsp;&nbsp;Final Impression :&nbsp;&nbsp;</b>  <input type="text" id="txtinter" style="width:680px" maxlength="490" />
                               <br /><br />
                              <div style="display:none;">
                               <ckeditor:ckeditorcontrol ID="txtcomments"   BasePath="~/ckeditor" runat="server"    EnterMode="BR"  Width="900" Height="150" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|Font|FontSize|"></ckeditor:ckeditorcontrol>
                             </div>
                                 <br />
                               <div style="width:99%;text-align:center;">
                                           <input type="button" value="Close" onclick="closeme()" style="background-color:red;color:white;font-weight:bold;cursor:pointer;"  />
                                           &nbsp;
                                           <input type="button" onclick="savedata()" value="Save" style="background-color:blue;color:white;font-weight:bold;cursor:pointer;" />
                                           &nbsp;
                                           <input type="button" onclick="printonly()" value="Print" style="background-color:blue;color:white;font-weight:bold;cursor:pointer;display:none;" /></div>
                               </td>
                        </tr>
                    </table>
                </div>
      </div>
    </div>


        <script id="tb_PatientLabSearch" type="text/html">
    
    
    
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" width="99%">
		<tr id="header">
			<th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >S.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >IHC Antibody</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Clone</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Staining Result</th>
              <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Intensity</th>
             <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Pattern</th>
            <th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >Percentage</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:left"  >#</th>
         </tr>



       <#
              var dataLength=PatientData.length;
            
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];

            #>
<tr style="background-color:#fdf0dc;height:30px;">


<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" id="antiname"><#=objRow.antiname#></td>
<td class="GridViewLabItemStyle" id="antiid" style="display:none;"><#=objRow.antiid#></td>
<td class="GridViewLabItemStyle" id="clone"><input class="oobbss1" type="text" style="width:80px;" value="<#=objRow.Clone#>" />   </td>
<td class="GridViewLabItemStyle" id="type"><input class="oobbss2" type="text" style="width:80px;" value="<#=objRow.TYPE#>" />   </td>
<td class="GridViewLabItemStyle" id="result"><input class="oobbss3" type="text" style="width:80px;" value="<#=objRow.Result#>" />   </td>
<td class="GridViewLabItemStyle" id="intensity"><input class="oobbss4" type="text" style="width:80px;" value="<#=objRow.Intensity#>" />   </td>
 <td class="GridViewLabItemStyle" id="pattern"><input class="oobbss5" type="text" style="width:80px;" value="<#=objRow.Pattern#>" />   </td>
 <td class="GridViewLabItemStyle" id="percentage"><input class="oobbss6" type="text" style="width:80px;" value="<#=objRow.Percentage#>" />   </td>
<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>
</tr>
         
            

            <#}#>

</table>
           
           
    </script>
    </form>
</body>
</html>
