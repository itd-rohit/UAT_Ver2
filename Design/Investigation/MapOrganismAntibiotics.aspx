<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MapOrganismAntibiotics.aspx.cs" Inherits="Design_Investigation_MapOrganismAntibiotics" Title="Untitled Page" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 
        <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>

<Ajax:ScriptManager ID="sm1" runat="server" />
  <div id="body_box_inventory" style="width: 992px;text-align:left;" >
    <div class="Outer_Box_Inventory" style="width: 986px;">
    <div class="content">
    <div style="text-align:center;">
    <b>Organism and Antibiotics Relation<br />
    </b>
    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />    </div>
   </div>
   </div>
      <div class="Outer_Box_Inventory" style="width: 987px; ">
    <div class="Purchaseheader">
        Select Organism</div>
        <table style="width: 953px">
            <tr>
                <td align="right" style="width: 126px; height: 12px" valign="middle" class="ItDoseLabel">
                </td>
                <td align="left"  style="width: 334px; height: 12px" valign="middle">
                    </td>
                <td align="right"  style="font-size: 8pt; width: 111px; height: 12px"
                    valign="middle">
                    </td>
                <td align="left"  style="height: 12px; width: 377px;" valign="middle">
                    </td>
            </tr>
            <tr>
                <td align="right" style="width: 126px; height: 13px" valign="middle" class="ItDoseLabel">
                    Organism:</td>
                <td align="left"  style="width: 334px; height: 13px" valign="middle">
                    <asp:DropDownList ID="ddlOrganism" runat="server" CssClass="ItDoseDropdownbox" onchange="BindObsGrid()"
                         Width="376px"   >
                    </asp:DropDownList></td>
                <td align="right"  style="font-size: 8pt; width: 111px; color: #000000;
                    font-family: Verdana; height: 13px; text-align: left;" valign="middle">
        
                                           
                        </td>
                <td align="left"  valign="middle">
                
                </td>
            </tr>
                  
            <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="height: 14px; text-align: center;" valign="middle" class="ItDoseLabel" colspan="4">
                    &nbsp;</td>
            </tr>
        </table>
    </div>
      <div class="Outer_Box_Inventory" style="width: 988px; ">
    <div class="Purchaseheader">
        Mapped Antibiotics</div>
        
        <div style="padding-left:10px;">
        Map Antibiotics:<asp:DropDownList ID="ddlObservation" runat="server" Width="273px"    CssClass="ItDoseDropdownbox">
            </asp:DropDownList> 
<%--            <asp:Button ID="btnAdd" runat="server" Text="Add Now"   CssClass="ItDoseButton"  /> 
--%>     
           <asp:Button ID="btnNewObs" runat="server" Text="New Observation" CssClass="ItDoseButton" style="display:none" /> 
                  <input id="btnAdd" type="button"  value="Map Antibiotics"  onclick="AddObs()"/>
                        <input id="btnAddNewObs" type="button"  value="Create New Antibiotics"  onclick="AddNewObs()"/>

        </div>
        </div>
         <div class="Outer_Box_Inventory" style="width: 988px; "  > 
        <div id="div_InvestigationItems"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;">
                
            </div>
        </div>
         <div class="Outer_Box_Inventory" style="width: 988px; padding-top:2px;padding-bottom:2px; text-align:center; ">
<%--        <asp:Button ID="btnSave" Text="Save Mapping" runat="server"  CssClass="ItDoseButton"  />
--%>        <input id="btnSave" type="button"  value="Save Mapping"/>
        </div>
   
   </div>

    <%--code for adding new observation START--%>

      <asp:Panel ID="pnlNewObs" runat="server" CssClass="pnlVendorItemsFilter" Style="display:none; width:400px;" Width="287px" >
    <div class="Purchaseheader" id="Div4" runat="server">
        New Observation</div>
    <div class="content" > 
      Add Observation:  <asp:TextBox ID="txtObservation" runat="server" Width="200px"  CssClass="ItDoseTextinputText" ></asp:TextBox>&nbsp;<br /> &nbsp; &nbsp;&nbsp; &nbsp;Short Name:
        <asp:TextBox ID="txtObsShortName" runat="server" Width="200px"  CssClass="ItDoseTextinputText" ></asp:TextBox>      
     <br /> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;Suffix:  <asp:TextBox ID="txtObsSuffix" runat="server" Width="200px"  CssClass="ItDoseTextinputText" ></asp:TextBox>      
     <br /> &nbsp; &nbsp; &nbsp;
        <asp:CheckBox ID="chkIsCulture" runat="server"  Visible="false"  Text="IsCultureReport"/> 
        <asp:CheckBox ID="chkObsAnylRpt" runat="server"  Visible="false" Text="Show in Patient Report"/> 
    </div>
   <div class="filterOpDiv" >
<%--        <asp:Button ID="btnAddObs" runat="server" CssClass="ItDoseButton" Text="Save" ValidationGroup="vg_NewObs"   />
--%>          <input id="btnAddObs" type="button" value="Save" onclick="AddnewObservation()"/>
        <asp:Button ID="btnCancelObs" runat="server" CssClass="ItDoseButton" Text="Cancel" CausesValidation="false" />
    </div>
         
    </asp:Panel>

   <cc1:ModalPopupExtender ID="mpeNewObs" runat="server"
    CancelControlID="btnCancelObs"
    DropShadow="true"
    TargetControlID="btnNewObs" 
    BackgroundCssClass="filterPupupBackground"
    PopupControlID="pnlNewObs"
    PopupDragHandleControlID="Div4" >
</cc1:ModalPopupExtender> 


  <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;">
		<tr class="nodrop">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">OrganismName</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">AntiBiotics Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">DefaultReading</th>	
	        <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Remove</th>
</tr>

       <#    
              var dataLength=obsData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = obsData[j];
        
            #>
                    <tr id="<#=objRow.LabObservation_ID#>"  >
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><#=j+1#></td>
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><#=objRow.OrganismName#></td>
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><#=objRow.ObsName#></td>
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><input id="txtDefaultReading" type="text" value="<#=objRow.DefaultReading#>" /></td>

<td class="GridViewLabItemStyle"><img id="imgRmv" src="../Purchase/Image/Delete.gif" onmouseover="chngcur()" /></td>
<#}#>
</tr>

           
     </table>    
    </script>

    <script type="text/javascript">
        $(function () {
            $(':text').bind('keyup', function () {
                this.value = this.value.replace(/[\"#|\']/g, '');
            });

            $("#btnSave").click(function () {
                $('input,select').attr('disabled', true);
                var ObsOrder = "";
                $("#tb_grdLabSearch tr").each(function () {
                    if ($(this).closest("tr").attr("id") != "") {
                        ObsOrder += $(this).closest("tr").attr("id") + '|' + $(this).find('#txtDefaultReading').val() + '#';

                        //    if($(this).closest("tr").children().find("#chkHeader").is(':checked'))
                        //   ObsOrder+='1|';
                        //    else
                        //   ObsOrder+='0|';
                        //    if($(this).closest("tr").children().find("#chkCritical").is(':checked'))
                        //   ObsOrder+='1#';
                        //    else
                        //   ObsOrder+='0#';
                    }
                    //alert(ObsOrder);
                });

                $.ajax({

                    url: "Services/MapOrganismAntibiotics.asmx/SaveMapping",
                    data: '{ OrganismID: "' + $("#<%=ddlOrganism.ClientID %>").val() + '",Order:"' + ObsOrder + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == '1') {
                            alert('Record Saved SuccessFully');
                            clearform();
                            $('input,select').attr('disabled', false);

                        }
                        if (result.d == '0') {
                            alert('Record Not Saved');
                            $('input,select').attr('disabled', false);
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        $('input,select').attr('disabled', false);
                    }
                });

            });
        });
        function BindObsGrid() {
            $.ajax({

                url: "Services/MapOrganismAntibiotics.asmx/GetObservationData",
                data: '{ OrganismID: "' + $("#<%=ddlOrganism.ClientID %>").val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    obsData = jQuery.parseJSON(result.d);
                    var output = $('#tb_InvestigationItems').parseTemplate(obsData);
                    $('#div_InvestigationItems').html(output);
                    $("#tb_grdLabSearch").tableDnD({
                        onDragClass: "GridViewDragItemStyle",
                        onDragStart: function (table, row) {
                        }
                    });
                    tablefunctioning();

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function saveobs(ObsID) {
            $.ajax({

                url: "Services/MapOrganismAntibiotics.asmx/SaveObservation",
                data: '{ OrganismID: "' + $("#<%=ddlOrganism.ClientID %>").val() + '",ObservationId:"' + ObsID + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    alert('Record Saved Successfully');

                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });


        }



function AddObs() {
    var DuplicateObs = '0';
    if ($("#<%=ddlOrganism.ClientID %>").val() == "") {
      DuplicateObs = '1';
      alert('Please Select an Organism');
      return;
  }
  $("#tb_grdLabSearch tr").each(function () {

      if ($(this).closest("tr").attr("id") == $("#<%=ddlObservation.ClientID %>").val()) {
         DuplicateObs = '1';
         alert('Antibiotic already added')
         return;
     }
 });
    if (DuplicateObs != '1') {
        //  addnewrow($("#<%=ddlObservation.ClientID %>").val(), $("#<%=ddlObservation.ClientID %> option:selected").text() )
      saveobs($("#<%=ddlObservation.ClientID %>").val());
      BindObsGrid();
  }
}


function tablefunctioning() {
    $("#tb_grdLabSearch").find("#imgRmv").click(function () {
        if (confirm("Do You Want to Remove Observation") == false) {
            return false;
        }
        RemoveObs($(this).closest("tr").attr("id"));
    });
}


function clearform() {
    $(':text, textarea').val('');
    $('select option:nth-child(1)').attr('selected', 'selected')
    $(".chk").find(':checkbox').attr('checked', '');
    $("#tb_grdLabSearch tr").remove();


}

function RemoveObs(ObsId) {
    $.ajax({
        url: "Services/MapOrganismAntibiotics.asmx/RemoveObservation",
        data: '{ OrganismID: "' + $("#<%=ddlOrganism.ClientID %>").val() + '",ObservationId:"' + ObsId + '"}', // parameter map
        type: "POST", // data has to be Posted    	        
        contentType: "application/json; charset=utf-8",
        timeout: 120000,
        dataType: "json",
        success: function (result) {
            if (result.d == 1) {
                $("#" + ObsId).remove();
                alert('Record Removed Successfully');
            }
        },
        error: function (xhr, status) {
            alert("Error ");
        }
    });
}       
function AddNewObs() {
    if ($("#<%=ddlOrganism.ClientID %>").val() == "") {
          alert('Please Select an Organism');
          return;
      }
      $find('<%=mpeNewObs.ClientID %>').show();
  }
    </script>    
     <script type="text/javascript">
         function AddnewObservation() {

             if ($("#<%=txtObservation.ClientID%>").val() == "") {
                 alert("Observation Name Cannot be Blank");
                 return;
             }

             if ($("#<%=txtObsSuffix.ClientID%>").val().length > 6) {
                 alert("Suffix Lenght Cannot Be More Then 6");
                 return;
             }
             var IsCulture = '0';
             var ObsAnylRpt = '0';
             //if($("#<%=chkIsCulture.ClientID %>").attr('checked'))
             IsCulture = '1';

             //if($("#<%=chkObsAnylRpt.ClientID %>").attr('checked'))
             ObsAnylRpt = '1';
             $.ajax({
                 url: "Services/MapInvestigationObservation.asmx/SaveNewObservation",
                 data: '{ ObsName: "' + $("#<%=txtObservation.ClientID %>").val() + '",ShortName: "' + $("#<%=txtObsShortName.ClientID %>").val() + '",Suffix: "' + $("#<%=txtObsSuffix.ClientID %>").val() + '",IsCulture: "' + IsCulture + '",ObsAnylRpt: "' + ObsAnylRpt + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == '0') {
                         alert('Observation Already Exist');
                         return;
                     }
                     $find('<%=mpeNewObs.ClientID %>').hide();
                     saveobs(result);
                     BindObsGrid();
                     //            addnewrow(result,$("#<%=txtObservation.ClientID %>").val())
                     $("#<%=ddlObservation.ClientID %>").append($("<option></option>").val(result).html($("#<%=txtObservation.ClientID %>").val()));
                     $('#<%=pnlNewObs.ClientID %>').find(':text').val('');
                     $('#<%=pnlNewObs.ClientID %>').find(':checkbox').attr('checked', '');
                 },
                 error: function (xhr, status) {
                     alert("Error ");
                 }
             });
         }

 </script> 
</asp:Content>

