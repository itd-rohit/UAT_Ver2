<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PhelboChargeMaster.aspx.cs" Inherits="Design_HomeCollection_PhelboChargeMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
                    
    
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager> 
            <div class="POuter_Box_Inventory" style="text-align:center;">
           
                <strong>Phlebo Visit Charge Master</strong> 
               
                </div>

         <div class="POuter_Box_Inventory" >
          
               
                   <div class="row">
                       <div class="col-md-3"></div>
                       <div class="col-md-3">
                           <label class="pull-left"><b>Charge Name</b></label>
			                                <b class="pull-right">:</b>
                           </div>
                       <div class="col-md-5">
                           <asp:TextBox ID="txtchargename" runat="server" MaxLength="20"  CssClass="requiredField" />
                           <asp:TextBox ID="txtchargeid" runat="server" MaxLength="20" style="display:none;" />
                       </div>
                       <div class="col-md-3">
                           <label class="pull-left"><b>Charge Amount</b></label>
			                                <b class="pull-right">:</b>
                        </div>
                       <div class="col-md-2">
                           <asp:TextBox ID="txtchargeamt" runat="server" MaxLength="4" CssClass="requiredField"/>
                           <cc1:filteredtextboxextender ID="ftbMobileNo" runat="server" FilterType="Numbers" TargetControlID="txtchargeamt">
                                </cc1:filteredtextboxextender>
                       </div>
                       <div class="col-md-4">
                           <input type="button" class="savebutton" value="Save" onclick="savecharge()" id="btnsave" />
                       </div>
                   </div>
                </div>
           

         <div class="POuter_Box_Inventory">
           
                 <table id="tbl" style="width:100%;border-collapse:collapse;text-align:left;">

                        <tr id="trheader">
                             <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                             <td class="GridViewHeaderStyle">Charge Name</td>
                             <td class="GridViewHeaderStyle">Charge Amount</td>
                             <td class="GridViewHeaderStyle">Entry Date</td>
                             <td class="GridViewHeaderStyle">Entry By</td>
                             <td class="GridViewHeaderStyle" style="width: 20px;">Edit</td>
                            </tr>
                     </table>
              
             </div>
        </div>

    <script type="text/javascript">
        $(function () {
            getdata();
        });    
        function getdata() {
            $('#tbl tr').slice(1).remove();
            serverCall('PhelboChargeMaster.aspx/getdata',
                {},
                function (result) {
                    ItemData = jQuery.parseJSON(result);
                    if (ItemData.length == 0) {
                        
                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var color = "lightgreen";
                            var mydata = [];
                            mydata.push("<tr style='background-color:"); mydata.push(color); mydata.push(";' id='"); mydata.push(ItemData[i].ID);mydata.push( "'>");
                            mydata.push( '<td class="GridViewLabItemStyle"   style="font-weight:bold;">');mydata.push( parseInt(i + 1) );mydata.push( '</td>');
                            mydata.push( '<td class="GridViewLabItemStyle"  id="chargename" style="font-weight:bold;">');mydata.push( ItemData[i].ChargeName );mydata.push( '</td>');
                            mydata.push( '<td class="GridViewLabItemStyle"  id="chargeamount" style="font-weight:bold;">');mydata.push(ItemData[i].ChargeAmount );mydata.push('</td>');
                            mydata.push( '<td class="GridViewLabItemStyle"  id="entrydate" style="font-weight:bold;">' );mydata.push( ItemData[i].entrydate);mydata.push( '</td>');
                            mydata.push( '<td class="GridViewLabItemStyle"  id="entrybyname" style="font-weight:bold;">');mydata.push(ItemData[i].EntryByName );mydata.push( '</td>');
                            mydata.push( '<td class="GridViewLabItemStyle"><img src="../../App_Images/view.gif" style="cursor:pointer;" onclick="showdetail1(this)" /></td>');;
                            mydata.push("</tr>");;
                            mydata = mydata.join("")
                            $('#tbl').append(mydata);
                        }                       
                    }
                })
            
        }
        
        function showdetail1(ctrl) {
            clearform();
            $('#<%=txtchargeid.ClientID%>').val($(ctrl).closest('tr').attr("id"));
            $('#<%=txtchargename.ClientID%>').val($(ctrl).closest('tr').find("#chargename").text());
            $('#<%=txtchargeamt.ClientID%>').val($(ctrl).closest('tr').find("#chargeamount").text());
            $('#btnsave').val('Update');

        }

        function clearform() {
            $('#<%=txtchargeid.ClientID%>').val('');
            $('#<%=txtchargename.ClientID%>').val('');
            $('#<%=txtchargeamt.ClientID%>').val('');
            $('#btnsave').val('Save');
        }
        function savecharge() {

            if ($('#<%=txtchargename.ClientID%>').val() == "") {
                toast("Error","Please Enter Charge Name");
                $('#<%=txtchargename.ClientID%>').focus();
                return;
            }

            if ($('#<%=txtchargeamt.ClientID%>').val() == "") {
                toast("Error","Please Enter Charge Amount");
                $('#<%=txtchargeamt.ClientID%>').focus();
                return;
            }
            $('#tbl tr').slice(1).remove();
            serverCall('PhelboChargeMaster.aspx/savedata',
                {
                    chargeid: $('#<%=txtchargeid.ClientID%>').val(),
                    chargename: $('#<%=txtchargename.ClientID%>').val(),
                    chargeamt:  $('#<%=txtchargeamt.ClientID%>').val() 
                },
                function (result) {
                  
                    if (result == "1") {
                        toast("Success", "Record Saved");
                        getdata();
                        clearform();
                    }
                    else {
                        toast("Error", result);
                    }
                })
        }      
    </script>
</asp:Content>

