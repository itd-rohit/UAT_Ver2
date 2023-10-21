<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="FamilyPackageMaster.aspx.cs" Inherits="Design_Investigation_FamilyPackageMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

     
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>

    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

     <style type="text/css" >
        .multiselect {
            width: 100%;
        }
        .compareDateColor {
             background-color: #90EE90;
         }

         </style>
    
     <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;text-align:center">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           
        </Ajax:ScriptManager>
    


    
     <div id="Pbody_box_inventory" style="width:900px;">
        <div class="POuter_Box_Inventory" style="width:900px;" >
            <div class="content" style="text-align: center; width:900px;">
                <b>Family Package Master</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            </div>



              <div class="POuter_Box_Inventory" style="width:900px;" >
                  
            <div class="content" style=" width:890px; ">
                 <table style="width:99%;">
            <tr>
                <td style="font-weight: 700; text-align: right;">Package Name :&nbsp;&nbsp;</td>
                 <td style="text-align: left"><asp:TextBox ID="txtpackagename" runat="server" Width="200px" style="text-transform:uppercase;" /> </td>
                 <td style="font-weight: 700">Package Code :</td>
                <td><asp:TextBox ID="txtpackcode" runat="server" Width="130px" style="text-transform:uppercase;" /><asp:TextBox ID="txtpackid" runat="server" Width="130px" style="text-transform:uppercase;display:none;" />  </td>
                </tr>
            <tr>
                <td style="font-weight: 700; text-align: right;">&nbsp;</td>
                 <td style="text-align: left">&nbsp;</td>
                 <td>&nbsp;</td>
                </tr>
                     </table>
 <div class="Purchaseheader">Add No of Member</div>
<table style="width:99%;">
            <tr>
                <td style="font-weight: 700; text-align: right;">No of Person :&nbsp;&nbsp;</td>
                 <td style="text-align: left">
                     <asp:DropDownList ID="txtqty" runat="server" Width="50px">
                         <asp:ListItem>1</asp:ListItem>
                            <asp:ListItem>2</asp:ListItem>
                            <asp:ListItem>3</asp:ListItem>
                            <asp:ListItem>4</asp:ListItem>
                            <asp:ListItem>5</asp:ListItem>
                            <asp:ListItem>6</asp:ListItem>
                            <asp:ListItem>7</asp:ListItem>
                            <asp:ListItem>8</asp:ListItem>
                          <asp:ListItem>8</asp:ListItem>
                            <asp:ListItem>9</asp:ListItem>
                            <asp:ListItem>10</asp:ListItem>
                     </asp:DropDownList>
                     
                       
                    
                 </td>
                  <td style="font-weight: 700; text-align: right;">From Age(YRS) :&nbsp;&nbsp;</td>
                  <td style="text-align: left"><asp:TextBox ID="txtfromage" runat="server" Width="50px"></asp:TextBox> 
                       <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtfromage" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                  </td>
                <td style="font-weight: 700; text-align: right;">To Age(YRS) :&nbsp;&nbsp;</td>
                  <td style="text-align: left"><asp:TextBox ID="txttoage" runat="server" Width="50px"></asp:TextBox>
                           <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txttoage" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                  </td>
                  <td style="font-weight: 700; text-align: right;">Gender :&nbsp;&nbsp;</td>
                <td style="text-align: left">
                    <asp:DropDownList ID="ddlgender" runat="server">
                        <asp:ListItem>Both</asp:ListItem>
                        <asp:ListItem>Male</asp:ListItem>
                        <asp:ListItem>Female</asp:ListItem>
                    </asp:DropDownList>
                </td>
               
                </tr>
            <tr>
                <td style="font-weight: 700; text-align: right;">Test :&nbsp;&nbsp;</td>
                 <td style="text-align: left" colspan="6">
                    
                     <asp:ListBox ID="lsttest" runat="server" CssClass="multiselect" SelectionMode="Multiple" Height="25px" Width="600px"  ></asp:ListBox> </td>
                <td style="text-align: left">
                  </td>
               
                </tr>

     <tr>
                <td style="font-weight: 700; text-align: right;">Discount% :&nbsp;&nbsp;</td>
                 <td style="text-align: left" colspan="6">
                    
                    
                    <asp:TextBox runat="server" ID="txtDiscPer" MaxLength="3" style="width:60px;" Text="100" ></asp:TextBox>
                      <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtDiscPer" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                    </td>
               
                </tr>
      <tr>
                <td style="font-weight: 700; text-align: right;">&nbsp;&nbsp;</td>
                 <td style="text-align: left" colspan="6">
                     <input type="button" value="Add" class="searchbutton" onclick="addtogrid()" />
                   </td>
               
                </tr>
            <tr>
                <td style="font-weight: 700; text-align: right;">&nbsp;</td>
                 <td style="text-align: left">&nbsp;</td>
                 <td>&nbsp;</td>
                </tr>
                     </table>

                <div class="Purchaseheader">Added Members</div>
                  <table id="tb_ItemList"  style="width:99%;border-collapse:collapse">
                                    <tr id="header">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;text-align:left;display:none;">No of Person</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;text-align:left">From Age</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;text-align:left">To Age</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;text-align:left">Gender</td>
                                        <td class="GridViewHeaderStyle" style="text-align:left">Test</td>
                                        <td class="GridViewHeaderStyle" style="text-align:left">Disc%</td>
                                        <td class="GridViewHeaderStyle" style="width: 20px;">Remove</td>
                                        
                                       
                                   </tr>
                                </table>
                </div>
                 
                 
             
                       

                        
                        
                  

                  </div>

         <div class="POuter_Box_Inventory" style="width:900px;" >
                   <div class="content" style="text-align: center; width:900px;">

                       <input type="button" value="Save" class="savebutton" onclick="savedata()" id="btnsave" />
                       <input type="button" value="Update" class="savebutton" onclick="updatedata()" id="btnupdate" style="display:none;" />
                      
                       </div>
             </div>

           <div class="POuter_Box_Inventory" style="width:900px;" >
               
                <div class="Purchaseheader">Saved Family Package</div>
                   <div class="content" style="text-align: center; width:890px;">
                           <table id="tblsaveddata"  style="width:99%;border-collapse:collapse">
                           <tr id="myheader">
                               <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                        <td class="GridViewHeaderStyle" style="width: 200px;text-align:left">Family Package Name</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;text-align:left">Package Code</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;text-align:left">Entry Date</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;text-align:left">Entry By</td>
                                        <td class="GridViewHeaderStyle" style="width: 100px;text-align:center">View Detail</td>
                                      
                           </tr>
                       </table>
                       </div>
               </div>
         </div>


    <script type="text/javascript">

        $(document).ready(function () {
            $('#<%=txtpackagename.ClientID%>').focus();
            bindtest();
            bindolddata();
           
        });


        function bindolddata() {

            $modelBlockUI();
            $('#tblsaveddata tr').slice(1).remove();

            $.ajax({
                type: "POST",
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                url: "FamilyPackageMaster.aspx/bindolddata",
                data: '{}',//
                success: function (result) {


                    var TestData1 = jQuery.parseJSON(result.d);

                    for (i = 0; i < TestData1.length; i++) {
                        var mydata = "<tr id='" + TestData1[i].itemid + "'  style='background-color:white;'>";
                        mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                     
                        mydata += '<td class="GridViewLabItemStyle" align="left" style="font-weight:bold;">' + TestData1[i].typename + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" align="left">' + TestData1[i].testcode + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" align="left">' + TestData1[i].EntryDate + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" align="left">' + TestData1[i].EntryBy + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;"><img src="../../App_Images/view.gif" style="cursor:pointer;" ';
                        mydata += 'onclick="viewdetail(\'' + TestData1[i].itemid + '\',\'' + TestData1[i].typename + '\',\'' + TestData1[i].testcode + '\')"/></td>';
                        mydata += "</tr>";
                        $('#tblsaveddata').append(mydata);
                    }

                    

                    $modelUnBlockUI();
                },

                error: function (xhr, status) {
                    $modelUnBlockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }


        function viewdetail(itemid,typename,testcode) {
            $('#<%=txtpackagename.ClientID%>').val(typename);
            $('#<%=txtpackcode.ClientID%>').val(testcode);
            $('#<%=txtpackid.ClientID%>').val(itemid);

            $('#btnsave').hide();
            $('#btnupdate').show();
            $modelBlockUI();
            $('#tb_ItemList tr').slice(1).remove();

            $.ajax({
                type: "POST",
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                url: "FamilyPackageMaster.aspx/binditemdetail",
                data: '{itemid:"'+itemid+'"}',//
                success: function (result) {


                    var TestData2 = jQuery.parseJSON(result.d);

                    for (i = 0; i < TestData2.length; i++) {
                        var mydata = "<tr id='" + parseInt(i+1) + "' class='GridViewItemStyle' style='background-color:lemonchiffon;font-weight:bold;'>";
                        mydata += "<td id='tdsrno' >" + parseInt(i + 1) + "</td>";
                        mydata += "<td id='tdnoofmember' style='display:none;'>" + TestData2[i].no_of_person + "</td>";
                        mydata += "<td id='tdfromage'>" + TestData2[i].fromage + "</td>";
                        mydata += "<td id='tdtoage'>" + TestData2[i].toage + "</td>";
                        mydata += "<td id='tdgender'>" + TestData2[i].gender + "</td>";
                        mydata += "<td id='tdtestname'>" + TestData2[i].testname + "</td>";
                        mydata += "<td id='tdtestname'>" + TestData2[i].DiscountPer + "</td>";
                        mydata += '<td align="centre"><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif"/></a></td>';
                        mydata += "<td id='tdtestid' style='display:none;'>" + TestData2[i].testlist + "</td>";
                        mydata += "<td id='tdpackname' style='display:none;'>" + typename + "</td>";
                        $('#tb_ItemList').append(mydata);
                    }



                    $modelUnBlockUI();
                },

                error: function (xhr, status) {
                    $modelUnBlockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

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
      

        function bindtest() {

            $modelBlockUI();
            $("#ContentPlaceHolder1_lsttest option").remove();
           // $("#ContentPlaceHolder1_lsttest").multipleSelect('refresh');


            $.ajax({
                type: "POST",
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                url: "FamilyPackageMaster.aspx/bindtest",
                data: '{}',//
                success: function (result) {


                    var TestData = jQuery.parseJSON(result.d);

                    for (i = 0; i < TestData.length; i++) {
                        jQuery('#<%=lsttest.ClientID%>').append(jQuery("<option></option>").val(TestData[i].itemid).html(TestData[i].typename));
                    }
                 
                    $('#ContentPlaceHolder1_lsttest').multipleSelect({

                        filter: true, keepOpen: false
                    });

                    $modelUnBlockUI();
                },

                error: function (xhr, status) {
                    $modelUnBlockUI();
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


        }

        function validation() {

            if ($('#<%=txtpackagename.ClientID%>').val() == "") {
                showerrormsg("Please Enter Package Name");
                $('#<%=txtpackagename.ClientID%>').focus();
                return false;
            }


          

            if ($('#<%=txtfromage.ClientID%>').val() == "") {
                showerrormsg("Please Enter From Age");
                $('#<%=txtfromage.ClientID%>').focus();
                return false;
            }

            if (parseInt($('#<%=txtfromage.ClientID%>').val()) > 100) {
                showerrormsg("From Age Can't Greater Then 100");
                $('#<%=txtfromage.ClientID%>').focus();
                return false;
            }

            if ($('#<%=txttoage.ClientID%>').val() == "") {
                showerrormsg("Please Enter To Age");
                $('#<%=txttoage.ClientID%>').focus();
                return false;
            }
            if (parseInt($('#<%=txttoage.ClientID%>').val())>100) {
                showerrormsg("To Age Can't Greater Then 100");
                $('#<%=txttoage.ClientID%>').focus();
                return false;
            }
            if (parseInt($('#<%=txtfromage.ClientID%>').val()) > parseInt($('#<%=txttoage.ClientID%>').val())) {
                showerrormsg("From Age Can't Greater To Age");
                $('#<%=txtfromage.ClientID%>').focus();
                return false;
            }

            var count = $('#<%=lsttest.ClientID%> option:selected').length;

            if (count == 0) {
                showerrormsg("Please Select Test");
                $('#<%=lsttest.ClientID%>').focus();
                 return false;
            }
            return true;
        }


        function addtogrid() {
            if (validation()) {
                $modelBlockUI();

                for (var a = 0; a < $('#<%=txtqty.ClientID%>').val() ; a++) {
                    var count = $('#tb_ItemList tr').length;

                    var mydata = "<tr id='" + count + "' class='GridViewItemStyle' style='background-color:lemonchiffon;font-weight:bold;'>";
                    mydata += "<td id='tdsrno' >" + count + "</td>";
                    mydata += "<td id='tdnoofmember' style='display:none;'>1</td>";
                    mydata += "<td id='tdfromage'>" + $('#<%=txtfromage.ClientID%>').val() + "</td>";
                    mydata += "<td id='tdtoage'>" + $('#<%=txttoage.ClientID%>').val() + "</td>";
                    mydata += "<td id='tdgender'>" + $('#<%=ddlgender.ClientID%>').val() + "</td>";
                    mydata += "<td id='tdtestname'>" + $('.ms-choice > span').text() + "</td>";
                    mydata += "<td id='tdDescPer' >" + $('[id$=txtDiscPer]').val().trim() + "</td>";
                    mydata += '<td align="centre"><a href="javascript:void(0);" onclick="deleteItemNode($(this));"><img src="../../App_Images/Delete.gif"/></a></td>';
                    mydata += "<td id='tdtestid' style='display:none;'>" + $('#<%=lsttest.ClientID%>').val() + "</td>";
                   
                    mydata += "<td id='tdpackname' style='display:none;'>" + $('#<%=txtpackagename.ClientID%>').val() + "</td>";
                    $('#tb_ItemList').append(mydata);
                }
                clearform();
                $modelUnBlockUI();
            }
        }

        function clearform() {

            $('#<%=txtqty.ClientID%>').val('1');
            $('#<%=txtfromage.ClientID%>').val('');
            $('#<%=txttoage.ClientID%>').val('');
            $('#<%=ddlgender.ClientID%>').prop('selectedIndex', 0);
    
          
            bindtest();
            $('#<%=txtfromage.ClientID%>').focus();
        }


        function deleteItemNode(row) {
          

          
            row.closest('tr').remove();
            var a = 1;
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "header") {

                    $(this).closest("tr").attr("id", a);
                    $(this).closest("tr").find('#tdsrno').text(a);
                    a++;

                }
            });

        }

        function savedata() {

            if ($('#<%=txtpackagename.ClientID%>').val() == "") {
                showerrormsg("Please Enter Package Name");
                $('#<%=txtpackagename.ClientID%>').focus();
                return;
            }


            var count = $('#tb_ItemList tr').length;

            if (count == 0 || count == 1) {
                showerrormsg("Please Add Member");
                return;
            }
           
            var datatosaved = getdatatosave();
            $('#btnsave').attr('disabled', true).val("Saving..");
            $.ajax({
                url: "FamilyPackageMaster.aspx/savealldata",
                data: JSON.stringify({ datatosaved: datatosaved}),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    var save = result.d;
                    if (save== "1") {

                        $('#btnsave').attr('disabled', false).val("Save");
                        clearFormall();
                        showmsg("Record Saved..!");
                        bindolddata();
                       

                    }
                    else {
                        showerrormsg(save);
                        $('#btnsave').attr('disabled', false).val("Save");
                        
                    }
                },
                error: function (xhr, status) {
                    showerrormsg("Some Error Occure Please Try Again..!");
                    $('#btnsave').attr('disabled', false).val("Save");
                    console.log(xhr.responseText);
                }
            });
        }

        

        function updatedata() {

            if ($('#<%=txtpackagename.ClientID%>').val() == "") {
                 showerrormsg("Please Enter Package Name");
                 $('#<%=txtpackagename.ClientID%>').focus();
                return;
            }


            var count = $('#tb_ItemList tr').length;

            if (count == 0 || count == 1) {
                showerrormsg("Please Add Member");
                return;
            }
        
            var datatosaved = getdatatosave();
            $('#btnupdate').attr('disabled', true).val("Updating..");
            $.ajax({
                url: "FamilyPackageMaster.aspx/updatealldata",
                data: JSON.stringify({ datatosaved: datatosaved }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    var save = result.d;
                    if (save == "1") {

                        $('#btnupdate').attr('disabled', false).val("Update");
                        clearFormall();
                        showmsg("Record Updated..!");
                        bindolddata();

                    }
                    else {
                        showerrormsg(save);
                        $('#btnupdate').attr('disabled', false).val("Update");

                    }
                },
                error: function (xhr, status) {
                    showerrormsg("Some Error Occure Please Try Again..!");
                    $('#btnsave').attr('disabled', false).val("Save");
                    console.log(xhr.responseText);
                }
            });
        }

        function getdatatosave() {

            var datarequired = new Array();
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "header") {
                    var objRequ = new Object();
                    objRequ.ItemName = $('#<%=txtpackagename.ClientID%>').val();
                    objRequ.TestCode = $('#<%=txtpackcode.ClientID%>').val();
                    objRequ.ItemID = $('#<%=txtpackid.ClientID%>').val()
                    objRequ.SubCategoryID = "18";
                    objRequ.No_Of_Person = $(this).closest("tr").find('#tdnoofmember').text();
                    objRequ.FromAge = $(this).closest("tr").find('#tdfromage').text();
                    objRequ.ToAge = $(this).closest("tr").find('#tdtoage').text();
                    objRequ.Gender = $(this).closest("tr").find('#tdgender').text();
                    objRequ.TestList = $(this).closest("tr").find('#tdtestid').text();
                    objRequ.TestName = $(this).closest("tr").find('#tdtestname').text();
                    objRequ.DescPer = $(this).closest("tr").find('#tdDescPer').text();
                    datarequired.push(objRequ);
                }
            }
            );

            return datarequired;
        }

        function clearFormall() {

            $('#<%=txtpackagename.ClientID%>').val('');
            $('#<%=txtpackcode.ClientID%>').val('');
            $('#<%=txtpackid.ClientID%>').val('');
            
            $('#tb_ItemList tr').slice(1).remove();
            $('#<%=txtpackagename.ClientID%>').focus();
            $('#btnsave').show();
            $('#btnupdate').hide();
        }
    </script>
</asp:Content>

