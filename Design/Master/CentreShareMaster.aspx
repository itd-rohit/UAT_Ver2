<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master"  AutoEventWireup="true" CodeFile="CentreShareMaster.aspx.cs" Inherits="Design_DocAccount_CentreShareMaster" ValidateRequest="false"%>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<%--     <script  src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../JavaScript/jquery.extensions.js" type="text/javascript"></script>--%> 
     <%-- <script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>--%>
   <%-- <script type="text/javascript" src="../../scripts/jquery.multiple.select.js"></script>--%>
  <%--  <link href="../../scripts/multiple-select.css" rel="stylesheet" />--%>
       <%-- <link href="../../combo-select-master/chosen.css" rel="stylesheet" type="text/css"/>--%>
   <%-- <script src="../../combo-select-master/chosen.jquery.js" type="text/javascript"></script>--%>
   <%--      <script type="text/javascript" src="../../JavaScript/fancybox/jquery.easing-1.3.pack.js"></script>--%>
    <%-- <script type="text/javascript" src="../../JavaScript/fancybox/jquery.fancybox-1.3.4.pack.js"></script>--%>
    <%-- <script type="text/javascript" src="../../JavaScript/fancybox/jquery.fancybox-1.3.4.js"></script>--%>
     <%--<script type="text/javascript" src="../../JavaScript/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>--%>
     <%--<link href="../../JavaScript/fancybox/jquery.fancybox-1.3.4.css"  rel="stylesheet" type="text/css" />--%>
      
<style type="text/css">
    .multiselect {
        width: 100%;
    }
    .searchbutton {
    cursor: pointer;
    background-color: blue;
    font-weight: bold;
    color: white;
    padding: 5px;
    border-radius: 5px;
    font-size: 15px;
}
</style>
    <script type="text/javascript">
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
        });
        </script>
     <script type="text/javascript">
         function getItem()
         {
            // alert('ok');
             if ($('#<%=ddlbusinessunit.ClientID %>').val() == "")
             {
                 alert("Please select Business Unit..");
                 return;
             }
             if ($('#<%=ddlDepartment.ClientID %>').val() == "") {
                 alert("Please select Department..");
                 return;
             }
             //$.blockUI();
             $.ajax({ 
                 url: "CentreShareMaster.aspx/GetItems",
                 data: '{ Department: "' + $('#<%=ddlDepartment.ClientID %>').val() + '",BusinessUnit: "' + $('#<%=ddlbusinessunit.ClientID %>').val() + '",TestType: "' + $('#<%=ddltesttype.ClientID %>').val() + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                    // alert(result);
                     if (result=="")
                     {
                         $("#txtdocshare").attr({value:''});
                         $("#Save,.td_share,#tb_grdLabSearch" ).hide();
                         //$.unblockUI();
                         //$.growlUI('Notification !!!', 'No Records Found');
      
                     }
                     else
                     {
                         PatientData = $.parseJSON(result.d);
                        // PatientData = JSON.parse(result);
                       //  PatientData= eval('['+result+']');
                         var dataLength = PatientData.length;
                         var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                         $('#div_InvestigationItems').html(output);
                         $(".td_share,#Save").show();
                         $("#txtdocshare").val('');
                         //$.unblockUI();
                         tablefunc();             
                     }
                 },
                 error: function (xhr, status) {
                     alert("Error... ");     
                     //$.unblockUI();
                     window.status=status + "\r\n" + xhr.responseText;
                 }
             });
         }
    </script>
    <script type="text/javascript">
        $(function () {
        $("#txtshareper").bind('keyup', function () {
            $('#tb_grdLabSearch tr').find("#DefaultInHousePer").find(":text").val($("#txtshareper").val());
            $('#tb_grdLabSearch tr').find("#DefaultInHouseAmt").find(":text").val('0');
            $("#txtshareAmt").val("0");
        });
        });
        $(function () {
            $("#txtshareAmt").bind('keyup', function () {
                $('#tb_grdLabSearch tr').find("#DefaultInHouseAmt").find(":text").val($("#txtshareAmt").val());
                $('#tb_grdLabSearch tr').find("#DefaultInHousePer").find(":text").val('0');
                $("#txtshareper").val("0");
            });
        });
        $(function () {
            $("#txtouthouseper").bind('keyup', function () {
                $('#tb_grdLabSearch tr').find("#DefaultOutHousePer").find(":text").val($("#txtouthouseper").val());
                $('#tb_grdLabSearch tr').find("#DefaultOutHouseAmt").find(":text").val('0');
                $("#txtouthouseAmt").val("0");
            });
        });
        $(function () {
            $("#txtouthouseAmt").bind('keyup', function () {
                $('#tb_grdLabSearch tr').find("#DefaultOutHouseAmt").find(":text").val($("#txtouthouseAmt").val());
                $('#tb_grdLabSearch tr').find("#DefaultOutHousePer").find(":text").val('0');
                $("#txtouthouseper").val("0");
            });
        });
        $(function () {
            $("#txtoutsourceper").bind('keyup', function () {
                $('#tb_grdLabSearch tr').find("#DefaultOutSourcePer").find(":text").val($("#txtoutsourceper").val());
                $('#tb_grdLabSearch tr').find("#DefaultOutSourceAmt").find(":text").val('0');
                $("#txtoutsourceAmt").val("0");
            });
        });
        $(function () {
            $("#txtoutsourceAmt").bind('keyup', function () {
                $('#tb_grdLabSearch tr').find("#DefaultOutSourceAmt").find(":text").val($("#txtoutsourceAmt").val());
                $('#tb_grdLabSearch tr').find("#DefaultOutSourcePer").find(":text").val('0');
                $("#txtoutsourceper").val("0");
            });
        });
        </script>
        <script type="text/javascript">
     function tablefunc()
{
$("#tb_grdLabSearch tr").hover(
function () {
$(this).attr('PrevColor',$(this).css('background-color'));
$(this).css('background-color','#BCEE68');
},
function () {
$(this).css('background-color',$(this).attr('PrevColor')) ;
}
);
     } 
            </script>
        <script type="text/javascript">
            var _PageSize = $("#txtpagesize").val();
            var _PageCount = "0";
            var _StartIndex = "0";
            var _EndIndex = _PageSize;
           
      
 
    function saveAll() {
        if ($('#<%=ddlbusinessunit.ClientID %>').val() == "") {
            alert("Please select Business Unit..");
            return;
        }
        var Shareper = $("#txtshareper").val();
        var ShareAmt = $("#txtshareAmt").val();
        if (Shareper > 100 )
        {
            alert("Share Percentage cannot be greater than 100.");
        return;
        }
        //$.blockUI();
     $.ajax({ 
    url: "CentreShareMaster.aspx/SaveAll",
    data: '{ Department: "' + $('#<%=ddlDepartment.ClientID %>').val() + '",BusinessUnit: "' + $('#<%=ddlbusinessunit.ClientID %>').val() + '",Shareper: "' + Shareper + '",ShareAmt: "' + ShareAmt + '"}', // parameter map
    type: "POST", // data has to be Posted    	        
    contentType: "application/json; charset=utf-8",
    timeout: 120000,
    dataType: "json",
    success: function (result) { 
        if (result.d=="1")
        {
            //$.unblockUI();
            alert("Record Saved Successfully..");
        }
        else
        {
        }
    },
    error: function (xhr, status) {
        alert("Error... ");     
             
        window.status=status + "\r\n" + xhr.responseText;
    }
     });
}   
</script>
    <script type="text/javascript">
       
        function txtInHousePer(count)
        {
            if ($("#txt_InHouseAmt" + count).val() != "0")
            {
                $("#txt_InHouseAmt" + count).val("0");
            }
        }

        function txtInHouseAmt(count)
        {
            if ($("#txt_InHousePer" + count).val() != "0")
            {
                $("#txt_InHousePer" + count).val("0");
            }
        }

        function Validate() {
            if ($("#<%=ddlDepartment.ClientID %>").val() == "ALL") {
                $('.div_Search').hide();
                $("#SaveALL").show();
                $('#div_InvestigationItems').html('');
                $("#Save").hide();
             } else {
                $('.div_Search').show();
                $("#SaveALL").hide();
             }
         }
        </script>
    <script type="text/javascript">
        var _PageSize = $("#txtpagesize").val();
        var _PageCount = "0";
        var _StartIndex = "0";
        var _EndIndex = _PageSize;
           
            
        function save() {
            if ($("#txtshareper").val() > 100) {
                alert("Share Percentage cannot be greater than 100.");
                //$.unblockUI();
                return;
            }
            var str = "";
            var table = document.getElementById("tb_grdLabSearch");
            var Count = table.rows.length;
            for (var i = 1; i < Count; i++) {
                var ItemID = document.getElementById('tb_grdLabSearch').rows[i].cells[1].id;
                var DefaultDocShare = $("#txt_InHousePer" + document.getElementById('tb_grdLabSearch').rows[i].cells[0].innerText).val();
                var DefaultDocShareAmt = $("#txt_InHouseAmt" + document.getElementById('tb_grdLabSearch').rows[i].cells[0].innerText).val();
                if (DefaultDocShare != '' && isNaN(DefaultDocShare)) {
                    alert("Please Enter Only Numeric Value...");
                    return;
                }
                if (DefaultDocShareAmt != '' && isNaN(DefaultDocShareAmt)) {
                    alert("Please Enter Only Numeric Value...");
                    return;
                }
                str += ItemID + '#' + DefaultDocShare + '#' + DefaultDocShareAmt +  '$';

            }
            $.ajax({
                url: "CentreShareMaster.aspx/Save",
                data: '{ count: "' + (Count - 1) + '",str: "' + str + '",Department: "' + $('#<%=ddlDepartment.ClientID %>').val() + '",BusinessUnit: "' + $('#<%=ddlbusinessunit.ClientID %>').val() + '"}', // parameter map
                    //data: '{ Department: "' + $('#<%=ddlDepartment.ClientID %>').val() + '",BusinessUnit: "' + $('#<%=ddlbusinessunit.ClientID %>').val() + '",Shareper: "' + Shareper + '",ShareAmt: "' + ShareAmt + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            //$.unblockUI();
                            alert("Record Saved Successfully ");
                            //ClearForm();
                        }
                        else {
                            alert("Record Not Saved ");
                            //$.unblockUI();
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error... ");

                        window.status = status + "\r\n" + xhr.responseText;
                    }
            });
            }
 </script>
     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
           </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">


            <b>Centre Share Master</b>
            <br />
             <table style="width:100%;border-collapse:collapse;text-align:center">
                <tr style="text-align:center">
                    <td style="width:40%">
                        &nbsp;
                    </td>
                    <td  colspan="4" style="width:30%">
                    </td>
                     <td style="width:30%">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">
              <div class="Purchaseheader">
        Search Criteria&nbsp;</div>
               
        <table style="width:100%;border-collapse:collapse">
             <tr>
                    <td colspan="4" style="text-align:center">
                        &nbsp;&nbsp;
                        </td>

                 </tr>
        </table>
        <table style="width:100%;border-collapse:collapse">
            <tr>
                <td style="text-align:right;width:15%">
                    Business Unit :&nbsp;
                </td>
                 <td style="text-align:left;width:30%">
                     <table style="width:100%;border-collapse:collapse">
                         <tr>
                             <td>
                                 <asp:DropDownList ID="ddlbusinessunit" runat="server"  Width="340px" class="ddlPanel chosen-select" onchange="getPanelShare()"></asp:DropDownList>
                             </td>
                             <td>
                                 <input type="button" id="Button2" value="Copy Share" class="searchbutton" onclick="showPopUp()" style="display:none" />
                             </td>
                         </tr>
          
                     </table>
          
            <tr>
                <td style="text-align:right;width:15%">
                    Department :&nbsp;</td>
                 <td style="text-align:left;width:30%">
                    <asp:DropDownList ID="ddlDepartment" runat="server"  onchange="Validate();"
                                    Width="340px"  class="ddlDepartment chosen-select"></asp:DropDownList></td>
                <td style="text-align:left;display:none;" colspan="2" >
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="chkNotSetRate" />Not Set Rate</td>
            </tr>
                      <tr>
                <td style="text-align:right;width:15%">
                    InHouse/OutSource :&nbsp;</td>
                 <td style="text-align:left;width:30%">
                     <asp:DropDownList ID="ddltesttype" runat="server" 
                                    Width="340px" class="ddltesttype chosen-select">
                                    <asp:ListItem>All</asp:ListItem>
                                    <asp:ListItem>InHouse</asp:ListItem>
                                    <asp:ListItem>OutHouse</asp:ListItem>
                                    <asp:ListItem>OutSource</asp:ListItem>
                                </asp:DropDownList>
                   </td>
                <td style="text-align:left;display:none;" colspan="2" >
                   </td>
            </tr>
            <tr  class="td_share" >
                           <td style="text-align:right;width:15%">
                            Share% :&nbsp; </td>
                             <td style="text-align:left;width:30%">
                         
                             <input id="txtshareper" type="text"  style="width:100px; "  />
                                  <td style="text-align:right;width:10%">
                             Share Amt. :&nbsp;</td>
                <td style="text-align:left;width:45%">
                     <input id="txtshareAmt" type="text"  style="width:100px; "  />
                            </td>
                        </tr>
                     
                       </table>
    </div>
          <div id="div_Search" class="Outer_Box_Inventory div_Search" style="width: 99.6%; text-align:center;">
                         <input type="button" id="Button1" style="cursor:pointer; " value="Search Share" onclick="getItem()" class="searchbutton"/>
                   </div>
       <div class="Outer_Box_Inventory" style="width: 1300px; "> 
        <div id="div_InvestigationItems"  style="max-height:450px; overflow-y:auto; overflow-x:hidden; width: 1300px;">
                
            </div>
           <div style="display:none;">
          Page Size
                
          <input type="text" id="txtpagesize" value="" />
         </div>

        </div>
          <div class="Outer_Box_Inventory" style="width: 1300px; text-align:center"  >
        <input id="Save" type="button" value="Save"  onclick="save();" class="searchbutton" style="width:60px; display:none;"   />
                <input id="SaveALL" type="button" value="SaveAll"  onclick="saveAll();" class="searchbutton" style="width:90px; display:none;"   />
        </div>
  <script id="tb_InvestigationItems" type="text/html" style="border:none;">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="width:1300px;border-collapse:collapse;border:none;width:100%;" >
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:290px;">Business Unit</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Department</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:290px;">Item Name</th>
			 <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Rate</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Share Per.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Share Amt.</th>
            
								
</tr>
             <#
            var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;
             for(var j=0;j<PatientData.length;j++)
           <%--  for(var j=0;j<30;j++)--%>
            {                       
                objRow = PatientData[j];         
            #>
                 <tr id="tr_<#=objRow.ItemID#>">
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="<#=objRow.ItemID#>"  class="GridViewLabItemStyle"><#=objRow.BusinessUnit#></td>
  <td id="Td3"  class="GridViewLabItemStyle"><#=objRow.Department#></td>
<td id="Td1"  class="GridViewLabItemStyle"><#=objRow.ItemName#></td>
<td id="Td2"  class="GridViewLabItemStyle"></td>
<td id="DefaultInHousePer" class="GridViewLabItemStyle"><input id="txt_InHousePer<#=j+1#>" type="text" value="<#=objRow.PerShare#>" style="width:75px;"  onkeyup="txtInHousePer('<#=j+1#>');"  />%</td>
<td id="DefaultInHouseAmt" class="GridViewLabItemStyle">Rs.<input id="txt_InHouseAmt<#=j+1#>" type="text" value="<#=objRow.AmountShare#>" style="width:75px;"  onkeyup="txtInHouseAmt('<#=j+1#>');" /></td>
 
</tr>
            <#} #>   
                                     
     </table> 
    
  <table>
       
     </table> 
     
       
    </script>

   
</asp:Content>

