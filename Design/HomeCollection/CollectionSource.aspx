<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CollectionSource.aspx.cs" Inherits="Design_HomeCollection_CollectionSource" %>
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
              <div class="col-md-4"><b>Collection Source Master</b></div>
          </div>
      </div>
      
         <div class="row">
            
            <div class="col-md-3"></div>
            <div class="col-md-5">
               <label class="pull-left">Collection Source</label>
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
                  <div class="col-md-3" style="display:none;">
                      <label class="pull-left">No of Record</label>
			            <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-2" style="display:none;">
                     <asp:DropDownList ID="ddlnoofrecord" runat="server" Font-Bold="true">
                        <asp:ListItem Value="50">50</asp:ListItem>
                        <asp:ListItem Value="100">100</asp:ListItem>
                        <asp:ListItem Value="200">200</asp:ListItem>
                        <asp:ListItem Value="500">500</asp:ListItem>
                        <asp:ListItem Value="1000">1000</asp:ListItem>
                        <asp:ListItem Value="2000">2000</asp:ListItem>
                     </asp:DropDownList>
                  </div>
                  <div class="col-md-3">
                     <asp:TextBox ID="txtsearchvalue" runat="server" placeholder="Route" />
                  </div>
                  <div class="col-md-2">
                     <input type="button" value="Search" class="searchbutton" onclick="searchitem()" />
                  </div>
                  <div class="col-md-2">
                     <%--<input type="button" value="Excel" class="searchbutton" onclick="searchitemexcel()" />--%>
                  </div>
                  <div class="col-md-3"></div>
               </div>
            </div>
            <div style="height: 200px; overflow: auto;">
               <table id="tblitemlist" style="width: 100%; border-collapse: collapse; text-align: left;">
                  <tr id="triteheader">
                     <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                     <td class="GridViewHeaderStyle" style="width: 30px;">Select</td>
                     <td class="GridViewHeaderStyle">Source Name</td>
                  </tr>
               </table>
           
         </div>
     </div>
   </div>
<script type = "text/javascript" >
  function SaveRecord() {
  var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;

 
  if ($("#<%=txt_Route.ClientID %>").val() == "") {
      toast("Error", "Please Entre Source Name","");
    $("#<%=txt_Route.ClientID %>").focus();
    return;
  }

  $("#btnSave").attr('disabled', 'disabled').val('Submitting...');

  serverCall('CollectionSource.aspx/SaveRecord', {
     Source: $("#<%=txt_Route.ClientID %>").val(),
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
          searchitem();

      } else if (result == "2") {
          toast("Error", "Duplicate Collection Source Name", "");
      } else {
        toast("Error","Please Try Again Later","");

      }
    })
}



function UpdateRecord() {
  var IsActive = $('#<%=chkIsActive.ClientID %>').is(':checked') ? 1 : 0;

 
  if ($("#<%=txt_Route.ClientID %>").val() == "") {
    alert("Please Entre Collection Source Name");
    $("#<%=txt_Route.ClientID %>").focus();
    return;
  }

  var RouteId = $("#<%=lblRoute.ClientID %>").text();

  $("#btnUpdate").attr('disabled', 'disabled').val('Submitting...');
  serverCall('CollectionSource.aspx/UpdateRecord',
      {
          SourceId: RouteId,
          Source: $("#<%=txt_Route.ClientID %>").val(),
          IsActive: IsActive
      },
      function (result) {
          if (result == "-1") {

              $("#<%=lblRoute.ClientID %>").text('');
                    toast("Error","Your Session Expired...Please Login Again","");
                } else if (result == "1") {
                    clearData();
                    toast("Success", "Record Update Successfully", "");
                    searchitem();

                } else if (result == "2") {
                    toast("Error","Duplicate Collection Source Name","");
                } else {
                    toast("Error","Please Try Again Later","");

                }
      })
}








function searchitem() {
    $('#tblitemlist tr').slice(1).remove();
    serverCall('CollectionSource.aspx/GetData',
        {
            searchvalue: $('#<%=txtsearchvalue.ClientID%>').val(),
            NoofRecord: $('#<%=ddlnoofrecord.ClientID%>').val(),
           
        }, function (result) {
                ItemData = jQuery.parseJSON(result);
                if (ItemData.length == 0) {
                    toast("Error","No Record Found");
                } else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var mydata = [];
                        mydata.push("<tr style='background-color:bisque;'>");
                        mydata.push('<td class="GridViewLabItemStyle"  id="" >');mydata.push(i + 1);mydata.push('</td>');
                        mydata.push('<td class="GridViewLabItemStyle"  id="tddetail2" ><input type="button" value="Select" style="cursor:pointer;" onclick="ShowDetail(');mydata.push(ItemData[i].ID);mydata.push(',\'');mydata.push(ItemData[i].Source);mydata.push('\',');mydata.push(ItemData[i].IsActive);mydata.push(',\'');mydata.push('\')" /></td>');
                        mydata.push('<td class="GridViewLabItemStyle"  id="tdRouteName" >');mydata.push(ItemData[i].Source);mydata.push('</td>');
                        mydata.push("</tr>");
                        mydata = mydata.join("");
                        $('#tblitemlist').append(mydata);
                    }
                }
        })

}



    function ShowDetail(Routeid, Route, IsActive) {
  $("#<%=btnUpdate.ClientID %>").show();
  $("#<%=btnSave.ClientID %>").hide();
  $("#<%=lblRoute.ClientID %>").text(Routeid);
  
  $("#<%=txt_Route.ClientID %>").val(Route);
  if (IsActive == "1") {
    $('#<%=chkIsActive.ClientID %>').prop('checked', 'checked');
  } else {
    $('#<%=chkIsActive.ClientID %>').prop('checked', false);
  }
}

function clearData() {
  $("#<%=lblRoute.ClientID %>").text('');
  $("#<%=txt_Route.ClientID %>").val('');
  $("#<%=btnUpdate.ClientID %>").hide();
  $("#<%=btnSave.ClientID %>").show();
  $('#<%=chkIsActive.ClientID %>').prop('checked', 'checked');
}

</script>
</asp:Content>