<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="RouteMaster.aspx.cs" Inherits="Design_HomeCollection_RouteMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
   Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
   <link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
   <style type="text/css">
      .multiselect{width:100%;}
   </style>
   <div id="Pbody_box_inventory" >
      <Ajax:ScriptManager runat="server" ID="sc"></Ajax:ScriptManager>
      <div class="POuter_Box_Inventory">
          <div class="row">
              <div class="col-md-10"></div>
              <div class="col-md-4"><b>Route Master</b></div>
          </div>
      </div>
      <div class="POuter_Box_Inventory" >
         <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-3">
               <label class="pull-left">Business Zone</label>
               <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:DropDownList ID="ddlZone" runat="server" class="ddlZone chosen-select" ClientIDMode="Static" onchange="bindState()"></asp:DropDownList>
            </div>
            <div class="col-md-3"></div>
            <div class="col-md-2">
               <label class="pull-left">State</label>
               <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:DropDownList ID="ddlState" runat="server" ClientIDMode="Static" class="ddlState chosen-select" onchange="bindCity(this.value);"></asp:DropDownList>
            </div>
         </div>
         <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-3">
               <label class="pull-left">City</label>
               <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:DropDownList ID="ddlCity" runat="server" class="ddlCity chosen-select" ClientIDMode="Static" ></asp:DropDownList>
            </div>
            <div class="col-md-3"></div>
            <div class="col-md-2">
               <label class="pull-left">Route</label>
               <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:TextBox ID="txt_Route" runat="server" CssClass="requiredField" ></asp:TextBox>
               <asp:Label ID="lblRoute" runat="server" style="display:none"></asp:Label>
               <asp:CheckBox ID="chkIsActive" runat="server" Text="IsActive" Checked="true"  style="font-weight:bold" />
            </div>
         </div>
      </div>
      <div class="POuter_Box_Inventory" style="text-align:center;">
         <div class="col-md-10">
         </div>
         <div class="col-md-2">
            <input type="button" id="btnSave" value="Save" runat="server" onclick="SaveRecord()" tabindex="9" class="savebutton" />
            <input type="button" id="btnUpdate" value="Update" runat="server" onclick="UpdateRecord()" tabindex="9" style="display:none" class="savebutton" />
         </div>
         <div class="col-md-2">
            <input type="button" value="Cancel" onclick="clearData()" class="resetbutton" />
         </div>
      </div>
      <div class="POuter_Box_Inventory" style="text-align: center;">
      
            <div class="Purchaseheader">
               <div class="row">
                  <div class="col-md-1"></div>
                  <div class="col-md-3">
                      <label class="pull-left">No of Record</label>
			            <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-2">
                     <asp:DropDownList ID="ddlnoofrecord" runat="server" Font-Bold="true">
                        <asp:ListItem Value="50">50</asp:ListItem>
                        <asp:ListItem Value="100">100</asp:ListItem>
                        <asp:ListItem Value="200">200</asp:ListItem>
                        <asp:ListItem Value="500">500</asp:ListItem>
                        <asp:ListItem Value="1000">1000</asp:ListItem>
                        <asp:ListItem Value="2000">2000</asp:ListItem>
                     </asp:DropDownList>
                  </div>
                  <div class="col-md-4">
                     <asp:DropDownList ID="ddlSearchState" runat="server" ClientIDMode="Static" class="ddlSearchState chosen-select" onchange="bindSearchCity(this.value);"></asp:DropDownList>
                  </div>
                  <div class="col-md-4">
                     <asp:DropDownList ID="ddlSearchCity" runat="server" class="ddlSearchCity chosen-select" ClientIDMode="Static" >
                        <asp:ListItem Value="">--Select City--</asp:ListItem>
                     </asp:DropDownList>
                  </div>
                  <div class="col-md-3">
                     <asp:TextBox ID="txtsearchvalue" runat="server" placeholder="Route" />
                  </div>
                  <div class="col-md-2">
                     <input type="button" value="Search" class="searchbutton" onclick="searchitem()" />
                  </div>
                  <div class="col-md-2">
                     <input type="button" value="Excel" class="searchbutton" onclick="searchitemexcel()" />
                  </div>
                  <div class="col-md-3"></div>
               </div>
            </div>
            <div style="height: 200px; overflow: auto;">
               <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                  <tr id="triteheader">
                     <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                     <td class="GridViewHeaderStyle" style="width: 30px;">Select</td>
                     <td class="GridViewHeaderStyle">Root Name</td>
                     <td class="GridViewHeaderStyle">Business Zone</td>
                     <td class="GridViewHeaderStyle">State</td>
                     <td class="GridViewHeaderStyle">City</td>
                     <td class="GridViewHeaderStyle">Status</td>
                  </tr>
               </table>
           
         </div>
     </div>
   </div>
<script type = "text/javascript" >
  jQuery(function() {
    var config = {
      '.chosen-select': {},
      '.chosen-select-deselect': {
        allow_single_deselect: true
      },
      '.chosen-select-no-single': {
        disable_search_threshold: 10
      },
      '.chosen-select-no-results': {
        no_results_text: 'Oops, nothing found!'
      },
      '.chosen-select-width': {
        width: "95%"
      }
    }
    for (var selector in config) {
      $(selector).chosen(config[selector]);
    }

    jQuery('#ddlZone,#ddlState,#ddlCity').trigger('chosen:updated');


    $('#ContentPlaceHolder1_txt_Route').keyup(function() {
      this.value = this.value.toUpperCase();
    });

  });



function bindState() {

  var ddlState;
  var BusinessZoneID;

  ddlState = $("#<%=ddlState.ClientID %>");
  $("#<%=ddlState.ClientID %> option").remove();
  BusinessZoneID = $("#<%=ddlZone.ClientID %>").val();
  $("#<%=ddlCity.ClientID %> option").remove();
  serverCall('../Common/Services/CommonServices.asmx/bindState', {
      CountryID: 14,
      BusinessZoneID: BusinessZoneID
    },
    function(result) {
      StateData = jQuery.parseJSON(result);
      if (StateData.length > 0) {
        ddlState.bindDropDown({
          defaultValue: '--Select---',
          data: JSON.parse(result),
          valueField: 'ID',
          textField: 'State',
          isSearchAble: true
        });
      }
      jQuery('#ddlState').trigger('chosen:updated');
    })
}


function bindCity(StateId) {
  var ddlCity = "";
  ddlCity = $("#<%=ddlCity.ClientID %>");
  $("#<%=ddlCity.ClientID %> option").remove();
  serverCall('RouteMaster.aspx/bindCity', {
      StateId: StateId
    },
    function(result) {
      CityData = jQuery.parseJSON(result);
      if (CityData.length > 0) {
          ddlCity.bindDropDown({
          defaultValue: '--Select---',
          data: JSON.parse(result),
          valueField: 'ID',
          textField: 'City',
          isSearchAble: true
        });
      }
      jQuery('#ddlCity').trigger('chosen:updated');
    })
}


function SaveRecord() {
  var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;

  if ($("#<%=ddlZone.ClientID %>").val() == "0" || $("#<%=ddlZone.ClientID %>").val() == null) {
    toast("Error","Please Select Zone","");
    $("#<%=ddlZone.ClientID %>").focus();
    return;
  }
  if ($("#<%=ddlState.ClientID %>").val() == "0" || $("#<%=ddlState.ClientID %>").val() == null) {
      toast("Error", "Please Select State","");
    $("#<%=ddlState.ClientID %>").focus();
    return;
  }
  if ($("#<%=ddlCity.ClientID %>").val() == "0" || $("#<%=ddlCity.ClientID %>").val() == null) {
      toast("Error", "Please Select City","");
    $("#<%=ddlCity.ClientID %>").focus();
    return;
  }
  if ($("#<%=txt_Route.ClientID %>").val() == "") {
      toast("Error", "Please Entre Route Name","");
    $("#<%=txt_Route.ClientID %>").focus();
    return;
  }

  $("#btnSave").attr('disabled', 'disabled').val('Submitting...');

  serverCall('RouteMaster.aspx/SaveRecord', {
      ZoneId: $("#<%=ddlZone.ClientID %>").val(),
      StateId: $("#<%=ddlState.ClientID %>").val(),
      CityId: $("#<%=ddlCity.ClientID %>").val(),
      Route: $("#<%=txt_Route.ClientID %>").val(),
      IsActive: IsActive
    },
    function (result) {
        result = jQuery.parseJSON(result);
      if (result == "-1") {

        $("#<%=lblRoute.ClientID %>").text('');
          toast("Error", "Your Session Expired...Please Login Again","");
      } else if (result == "1") {
        $("#<%=txt_Route.ClientID %>").val('');
          toast("Success", "Record Saved Successfully", "");

      } else if (result == "2") {
          toast("Error", "Duplicate Route Name", "");
      } else {
        toast("Error","Please Try Again Later","");

      }
    })
}



function UpdateRecord() {
  var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;

  if ($("#<%=ddlZone.ClientID %>").val() == "0" || $("#<%=ddlZone.ClientID %>").val() == null) {
    alert("Please Select Zone");
    $("#<%=ddlZone.ClientID %>").focus();
    return;
  }
  if ($("#<%=ddlState.ClientID %>").val() == "0" || $("#<%=ddlState.ClientID %>").val() == null) {
    alert("Please Select State");
    $("#<%=ddlState.ClientID %>").focus();
    return;
  }
  if ($("#<%=ddlCity.ClientID %>").val() == "0" || $("#<%=ddlCity.ClientID %>").val() == null) {
    alert("Please Select City");
    $("#<%=ddlCity.ClientID %>").focus();
    return;
  }
  if ($("#<%=txt_Route.ClientID %>").val() == "") {
    alert("Please Entre Route Name");
    $("#<%=txt_Route.ClientID %>").focus();
    return;
  }

  var RouteId = $("#<%=lblRoute.ClientID %>").text();

  $("#btnUpdate").attr('disabled', 'disabled').val('Submitting...');
  serverCall('RouteMaster.aspx/UpdateRecord',
      {
          RouteId: RouteId,
          ZoneId: $("#<%=ddlZone.ClientID %>").val(),
          StateId: $("#<%=ddlState.ClientID %>").val(),
          CityId: $("#<%=ddlCity.ClientID %>").val(),
          Route: $("#<%=txt_Route.ClientID %>").val(),
          IsActive: IsActive
      },
      function (result) {
          if (result == "-1") {

              $("#<%=lblRoute.ClientID %>").text('');
                    toast("Error","Your Session Expired...Please Login Again","");
                } else if (result == "1") {
                    clearData();
                    toast("Success","Record Update Successfully","");

                } else if (result == "2") {
                    toast("Error","Duplicate Route Name","");
                } else {
                    toast("Error","Please Try Again Later","");

                }
      })
}








function searchitem() {
    $('#tblitemlist tr').slice(1).remove();
    serverCall('RouteMaster.aspx/GetData',
        {
            searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(),
            NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val(),
            SearchState: $('#<%=ddlSearchState.ClientID%>').val(),
            SearchCity:  $('#<%=ddlSearchCity.ClientID%>').val()
        }, function (result) {
                ItemData = jQuery.parseJSON(result);
                if (ItemData.length == 0) {
                    toast("Error","No Record Found");
                } else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var mydata = [];
                        mydata.push("<tr style='background-color:bisque;'>");
                        mydata.push('<td class="GridViewLabItemStyle"  id="" >');mydata.push(i + 1);mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><input type="button" value="Select" style="cursor:pointer;" onclick="ShowDetail(');mydata.push(ItemData[i].Routeid);mydata.push(',');mydata.push(ItemData[i].BusinessZoneID);mydata.push(',');mydata.push(ItemData[i].StateID);mydata.push(',');mydata.push(ItemData[i].CityId);mydata.push(',');mydata.push(ItemData[i].IsActive);mydata.push(',\'');mydata.push(ItemData[i].Route);mydata.push('\')" /></td>');
                        mydata.push('<td class="GridViewLabItemStyle"  id="tdRouteName" >');mydata.push(ItemData[i].Route);mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle"  id="tdBusinessZone" >');mydata.push(ItemData[i].BusinessZoneName);mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle"  id="tdState" >');mydata.push(ItemData[i].state);mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" id="tdCity">');mydata.push(ItemData[i].City);mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle" id="tdStatus">'); mydata.push(ItemData[i].Status);mydata.push('</td>');
                        mydata.push("</tr>");
                        mydata = mydata.join("");
                        $('#tblitemlist').append(mydata);
                    }
                }
        })

}


function bindSearchCity(StateId) {
  var ddlSearchCity = "";

  ddlSearchCity = $("#<%=ddlSearchCity.ClientID %>");
  $("#<%=ddlSearchCity.ClientID %> option").remove();

    serverCall('RouteMaster.aspx/bindSearchCity',
        { StateId:StateId},
        function (result) {
            CityData = jQuery.parseJSON(result);
            if (CityData.length > 0) {
                ddlSearchCity.bindDropDown({ defaultValue: '--Select City---', data: JSON.parse(result), valueField: 'ID', textField: 'City', isSearchAble: true });
                jQuery('#ddlSearchCity').trigger('chosen:updated');
            }
        })

}

function ShowDetail(Routeid, BusinessZoneID, StateId, CityId, IsActive, Route) {
  $("#<%=btnUpdate.ClientID %>").show();
  $("#<%=btnSave.ClientID %>").hide();
  $("#<%=lblRoute.ClientID %>").text(Routeid);
  $("#<%=ddlZone.ClientID %>").val(BusinessZoneID);
    bindState();
    setTimeout(function () {
        $("#<%=ddlState.ClientID %>").val(StateId);
        jQuery('#ddlState').trigger('chosen:updated');
    }, 1000)
    setTimeout(function () {
        bindCity(StateId);
    }, 1100)
    setTimeout(function () {
        $("#<%=ddlCity.ClientID %>").val(CityId);
        jQuery('#ddlCity').trigger('chosen:updated');
    },1900)
  
  
  $("#<%=txt_Route.ClientID %>").val(Route);
  if (IsActive == "1") {
    $('#<%=chkIsActive.ClientID %>').prop('checked', 'checked');
  } else {
    $('#<%=chkIsActive.ClientID %>').prop('checked', false);
  }
  jQuery('#ddlZone,#ddlState,#ddlCity').trigger('chosen:updated');
}

function clearData() {
  $("#<%=lblRoute.ClientID %>").text('');
  $("#<%=txt_Route.ClientID %>").val('');
  $("#<%=btnUpdate.ClientID %>").hide();
  $("#<%=btnSave.ClientID %>").show();
  $("#<%=ddlZone.ClientID %>").val(0);
  $("#<%=ddlState.ClientID %> option").remove();
  $("#<%=ddlCity.ClientID %> option").remove();
  $('#ddlZone,#ddlState,#ddlCity').trigger('chosen:updated');
  $('#<%=chkIsActive.ClientID %>').prop('checked', 'checked');
}

</script>
</asp:Content>