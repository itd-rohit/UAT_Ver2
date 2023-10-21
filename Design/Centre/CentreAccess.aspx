<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master"  AutoEventWireup="true" CodeFile="CentreAccess.aspx.cs" Inherits="CentreAccess"  %>
<%@ Register Src="~/Design/UserControl/CentreLoad.ascx" TagName="wuc_CentreLoad"
    TagPrefix="uc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

      <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b><asp:Label ID="lblHeder" Font-Bold="true" runat="server"></asp:Label></b><br />

            &nbsp;<asp:Label ID="lblMsg" runat="server" ForeColor="#FF0033"></asp:Label>
            <asp:Label ID="lblCentreID" style="display:none" ClientIDMode="Static" runat="server"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Centre 
            </div>

            <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-4 ">
                                <label class="pull-left">Centre Name   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-20">
                                <span class="text2"><strong><span style="color: #54a0c0"></span></strong><span style="font-size: 8pt">
                            <asp:DropDownList ID="ddlCentreName" runat="server" Width="500px" onchange="getCentreID()" >
                            </asp:DropDownList></span></span>

                            </div>
                        </div>

                        </div>

                </div>


           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Centre Search 
            </div>
        <uc1:wuc_CentreLoad ID="CentreInfo" runat="server" />
            </div>
        

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSave" value="Save" onclick="SaveCentreAccess()" />
            

        </div>
         <div class="POuter_Box_Inventory" style="text-align: center;display:none" id="div_Display">
        <table  style="width: 100%; border-collapse:collapse" >
                <tr >
                    <td colspan="4">
                        <div id="DisSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                                              
                    </td>
                </tr>
            </table>
             </div>
    </div>
    <script type="text/javascript">
        function getCentreID() {
            $("#lblCentreID").text($("#<%=ddlCentreName.ClientID%>").val());
            bindAllCentreAccess();
        }

        function bindCentreAccess() {
            var dataCentreAccess = new Array();
            var ObjCentreAccess = new Object();
            var SelectedLaength = $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                ObjCentreAccess.CentreID = $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',')[i];
                dataCentreAccess.push(ObjCentreAccess);
                ObjCentreAccess = new Object();
            }
            return dataCentreAccess;
        }
        function SaveCentreAccess() {
            var resultCentreAccess = bindCentreAccess();
            if (resultCentreAccess[0].CentreID == "") {
                alert('Please Select Centre');
                return;
            }
            jQuery('#btnSave').attr('disabled', true).val("Submitting...");
            jQuery.ajax({
                url: "CentreAccess.aspx/saveCentreAccess",
                data: JSON.stringify({ CentreAccess: resultCentreAccess, CentreID: $("#lblCentreID").text() }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        alert("Record Saved..!");

                        bindAllCentreAccess();
                    }
                    else {
                        alert('Error...');
                    }
                    jQuery('#btnSave').attr('disabled', false).val("Save");
                },
                error: function (xhr, status) {
                    jQuery('#btnSave').attr('disabled', false).val("Save");
                }
            });
        }
    </script>
    <script type="text/javascript">

        function removeAccess(rowID) {
            var CentreID = $(rowID).closest('tr').find('#tdCentreID').text();
            var AccessCentreID = $(rowID).closest('tr').find('#tdAccessCentreID').text();

            $.ajax({
                url: "CentreAccess.aspx/updateCentreAccess",
                data: '{CentreID:"' + CentreID + '",AccessCentreID:"' + AccessCentreID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        alert('Record Updated Successfully');
                        bindAllCentreAccess();
                    }
                    else if (result.d == "0") {
                        alert('Error..');

                    }


                }

            });
        }
    </script>
    <script id="tb_CentreAccess" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:940px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.
               
			</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Centre</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Access Centre </th>
            
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Remove</th>                     
		</tr>
        <#
        var dataLength=centreAccessData.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = centreAccessData[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle"><#=j+1#>
                        
                    </td>

                   <td class="GridViewLabItemStyle" id="tdCentre" style="width:180px;"><#=objRow.Centre#></td>
                        <td class="GridViewLabItemStyle" id="tdAccessCentre" style="width:180px;"><#=objRow.AccessCentre#></td>
                       <td class="GridViewLabItemStyle" id="tdCentreID" style="width:90px;display:none"><#=objRow.CentreID#></td>
                        <td class="GridViewLabItemStyle" id="tdAccessCentreID" style="width:90px;display:none"><#=objRow.AccessCentreID#></td>
                        <td class="GridViewLabItemStyle" id="tdRemove" style="width:80px;">
                            <img src="../../App_Images/Delete.gif" style="cursor:pointer" id="btnRemove" onclick="removeAccess(this)"  title="Click to Remove"/>
                       
                    </td>
                    </tr>

        <#}

        #>
        
     </table>
    </script>
    <script type="text/javascript">
        $(function () {
            bindAllCentreAccess();
        });
        function bindAllCentreAccess() {
            $('#lblMsg').text('');

            $.ajax({
                url: "CentreAccess.aspx/bindCentreAccess",
                data: '{centreID:"' + $("#lblCentreID").text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    centreAccessData = jQuery.parseJSON(result.d);

                    if (centreAccessData != null && centreAccessData != "") {
                        var output = $('#tb_CentreAccess').parseTemplate(centreAccessData);
                        $('#DisSearchOutput').html(output);
                        $('#DisSearchOutput,#div_Display').show();


                    }
                    else {
                        $('#DisSearchOutput').html();
                        $('#DisSearchOutput,#div_Display').hide();
                        $('#lblMsg').text('Record Not Found');

                    }

                }

            });
        }
         </script>
</asp:Content>

