<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StorageDeviceMaster.aspx.cs" Inherits="Design_SampleStorage_StorageDeviceMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
   Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   <script type="text/javascript">
       function ConfirmOnDelete(item, type) {
           var msg = "";
           if (type == "1") {
               msg = "Are you sure to deactive : " + item + "?";
           }
           else {
               msg = "Are you sure to active : " + item + "?";
           }
           if (confirm(msg) == true)
               return true;
           else
               return false;
       }


       function showDialog() {
           var racknumber = $('#<%=txtnoofrack.ClientID%>').val();
          var deviceid = $('#<%=txtId.ClientID%>').val();

          if (racknumber == "0" || racknumber == "") {

              alert("Please Enter Rack Number");
              return;
          }
          var count = $('#tb_ItemList tr').length;
          var aa = parseInt(count) - 1;

          if (parseInt(racknumber) != aa) {
              $('#tb_ItemList tr').slice(1).remove();
          }

          var count1 = $('#tb_ItemList tr').length;
          if (count1 == 1) {
              $('#tb_ItemList tr').slice(1).remove();

              for (var a = 1; a <= parseInt($('#<%=txtnoofrack.ClientID%>').val()) ; a++) {
                  var $mydata = [];
                  $mydata.push('<tr>');
                  $mydata.push('<td id="srno">'); $mydata.push(a); $mydata.push('</td>');
                  $mydata.push('<td id="rackno">'); $mydata.push(a); $mydata.push('</td>');
                  $mydata.push('<td id="quan"><input type="text"  onkeyup="setitemwisediscount(this);" id="txtquantity" style="width:50px;"/></td>');
                  $mydata.push('<td id="tray"><select onchange="showme(this);" class="mmc" id="ddltray" style="width:120px;"></select></td>');
                  $mydata.push('<td><span id="mac"><span></td>');
                  $mydata.push("</tr>");
                  $mydata = $mydata.join("");
                  jQuery('#tb_ItemList').append($mydata);
              }

              tablefunction();
          }
          $find("<%=modelopdpatient.ClientID%>").show();

      }

      function addmenow() {
          if (isNaN($('#ssd').val() / 1) == true) {
              $('#ssd').val('');
              $('#tb_ItemList tr').each(function () {
                  var id = $(this).closest("tr").attr("id");
                  if (id != "header") {
                      $(this).closest("tr").find("#txtquantity").val('');


                  }
              });
              return;
          }
          $('#tb_ItemList tr').each(function () {
              var id = $(this).closest("tr").attr("id");
              if (id != "header") {
                  $(this).closest("tr").find("#txtquantity").val($('#ssd').val());


              }
          });
      }
      function setitemwisediscount(ctrl) {
          if (isNaN($(ctrl).val() / 1) == true) {
              $(ctrl).val('');

              return;
          }
      }
      function setmenow() {
          $('#tb_ItemList tr').each(function () {
              var id = $(this).closest("tr").attr("id");
              if (id != "header") {

                  $(this).closest("tr").find("#ddltray").val($('#ddltrayhead').val());
                  if ($('#ddltrayhead').val() == "0") {

                      $(this).closest("tr").find('#mac').html('');
                  }
                  else {
                      var cc = "Capacity:" + $('#ddltrayhead').val().split('#')[1] + " Expiry:" + $('#ddltrayhead').val().split('#')[2] + " Sample Type:" + $('#ddltrayhead').val().split('#')[3];

                      $(this).closest("tr").find('#mac').html(cc);
                  }
              }
          });
      }

      function showme(ctrl) {
          var av = $(ctrl).closest("tr").find('#ddltray option:selected').val();
          if (av == "0") {

              $(ctrl).closest("tr").find('#mac').html('');
          }
          else {
              var cc = "Capacity:" + av.split('#')[1] + " Expiry:" + av.split('#')[2] + " Sample Type:" + av.split('#')[3];

              $(ctrl).closest("tr").find('#mac').html(cc);
          }


      }

      function tablefunction() {
          var ddlDoctor = $(".mmc");
          $(".mmc option").remove();
          serverCall('StorageDeviceMaster.aspx/bindTray', {}, function (result) {
            PanelData = $.parseJSON(result);
            if (PanelData.length == 0) {
            }
            else {
                
                ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'id', textField: 'trayname', isSearchAble: true });
            }

          })
          //$.ajax({
          //    url: "StorageDeviceMaster.aspx/bindTray",
          //    data: '{}', // parameter map
          //    type: "POST", // data has to be Posted    	        
          //    contentType: "application/json; charset=utf-8",
          //    timeout: 120000,
          //    dataType: "json",
          //    success: function (result) {
          //        PanelData = $.parseJSON(result.d);
          //        if (PanelData.length == 0) {
          //        }
          //        else {
          //            ddlDoctor.append($("<option></option>").val("0").html("Select"));
          //            for (i = 0; i < PanelData.length; i++) {
          //                ddlDoctor.append($("<option></option>").val(PanelData[i]["id"]).html(PanelData[i]["trayname"]));
          //            }
          //        }

          //    },
          //    error: function (xhr, status) {

          //        window.status = status + "\r\n" + xhr.responseText;
          //    }
          //});
      }
      function getdata() {
          var dataPLO = new Array();
          $('#tb_ItemList tr').each(function () {
              var id = $(this).closest("tr").attr("id");
              if (id != "header") {
                  var val = $('#<%=txtId.ClientID%>').val() + "#" + $(this).closest("tr").find("#rackno").text() + "#" + $(this).closest("tr").find("#txtquantity").val() + "#" + $(this).closest("tr").find('#ddltray').val().split('#')[0];
                  dataPLO.push(val);
              }


          });

          return dataPLO;

      }

      function savemenow() {
          if (validation() == true) {
              var mydatatosave = getdata();
              alert(mydatatosave);
          }
      }

      function validation() {
          var count = $('#tb_ItemList tr').length;

          if (count == 0 || count == 1) {
              toast('Error', 'Please Enter Valid No of Rack', '');
              return false;
          }

          var sn = 0;
          $('#tb_ItemList tr').each(function () {
              var id = $(this).closest("tr").attr("id");
              if (id != "header") {
                  if ($(this).closest("tr").find("#ddltray").val() == "0") {
                      sn = 1;
                      $(this).find('#ddltray').focus();
                      return false;
                  }
              }
          });

          if (sn == 1) {
              toast("Error","Please Select Tray","");
              return false;
          }

          var sn1 = 0;
          $('#tb_ItemList tr').each(function () {
              var id = $(this).closest("tr").attr("id");
              if (id != "header") {
                  if ($(this).closest("tr").find("#txtquantity").val() == "0" || $(this).closest("tr").find("#txtquantity").val() == "") {
                      sn1 = 1;
                      $(this).find('#txtquantity').focus();
                      return false;
                  }
              }
          });

          if (sn1 == 1) {
              toast("Error","Please Enter Tray Quantity","");
              return false;
          }
          return true;
      }

      //function showmsg(msg) {
      //    $('#msgField').html('');
      //    $('#msgField').append(msg);
      //    $(".alert").css('background-color', '#04b076');
      //    $(".alert").removeClass("in").show();
      //    $(".alert").delay(1500).addClass("in").fadeOut(1000);
      //}
      //function showerrormsg(msg) {
      //    $('#msgField').html('');
      //    $('#msgField').append(msg);
      //    $(".alert").css('background-color', 'red');
      //    $(".alert").removeClass("in").show();
      //    $(".alert").delay(1500).addClass("in").fadeOut(1000);
      //}
   </script>
   <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111">
      <%--durga msg changes--%>
<%--      <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>--%>
   </div>
   <Ajax:ScriptManager ID="ScriptManager1" runat="server">
   </Ajax:ScriptManager>
   <Ajax:UpdateProgress ID="updateProgress" runat="server">
      <ProgressTemplate>
         <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading
                            <img src="../../App_Images/progress_bar.gif" />
            </span>
         </div>
      </ProgressTemplate>
   </Ajax:UpdateProgress>
   
      <ContentTemplate>
         <div id="Pbody_box_inventory">
         <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>&nbsp;Sample Storage Device Master</b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
         </div>
         <div class="POuter_Box_Inventory ">
            <div class="Purchaseheader">
               Add Details&nbsp;
            </div>
               <div class="row">
                  <div class="col-md-3">
                     <label class="pull-left">Business Zone</label>
			         <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-5">
                     <asp:DropDownList ID="ddlBusinessZone" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlBusinessZone_SelectedIndexChanged">
                     </asp:DropDownList>
                  </div>
                   <div class="col-md-3">
                       <label class="pull-left">State</label>
			            <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-5">
                     <asp:DropDownList ID="ddlState" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlState_SelectedIndexChanged">
                     </asp:DropDownList>
                  </div>
                   <div class="col-md-3">
                       <label class="pull-left">City</label>
			            <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-5">
                     <b>
                        <asp:DropDownList ID="ddlCity" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCity_SelectedIndexChanged" >
                        </asp:DropDownList>
                     </b>
                  </div>
               </div>
                <div class="row">
                    <div class="col-md-3">

                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <asp:Button ID="Button2" Text="Search" runat="server" OnClick="btnsearch_Click" CssClass="searchbutton" />
                    </div>
                </div>
               <div class="row">
                   <div class="col-md-3">
                        <label class="pull-left">Centre</label>
			            <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-5">
                     <asp:DropDownList ID="ddlcentre" runat="server" />
                     <asp:RequiredFieldValidator ID="r8" runat="server" ControlToValidate="ddlcentre" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" InitialValue="0" ValidationGroup="save"></asp:RequiredFieldValidator>
                  </div>
                  <div class="col-md-3">
                        <label class="pull-left">Storage Type</label>
			            <b class="pull-right">:</b>
                  </div>
                  <div class="col-md-5">
                     <asp:DropDownList ID="ddlstoragetype" runat="server" />
                     <%--<asp:RequiredFieldValidator ID="r2" runat="server" ControlToValidate="ddlstoragetype" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" InitialValue="0" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                  </div>
               </div>
               <div class="row">
                   <div class="col-md-3">
                     <label class="pull-left">Department</label>
			         <b class="pull-right">:</b>
                    </div>
                   <div class="col-md-21">
                        <asp:CheckBoxList ID="ddldepartment" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" BorderStyle="Solid" BorderWidth="1" />
                   </div>
               </div>
               <div class="row">
                   <div class="col-md-3">
                       <label class="pull-left">Device Name</label>
			            <b class="pull-right">:</b>
                   </div>
                  <div class="col-md-5">
                     <asp:TextBox ID="txtdeptname" runat="server" Style="text-transform: uppercase;" CssClass="requiredField"></asp:TextBox>
                    <%-- <asp:RequiredFieldValidator ID="r7" runat="server" ControlToValidate="txtdeptname" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                  </div>
                   <div class="col-md-3">
                       <label class="pull-left">Manufacture Name</label>
			            <b class="pull-right">:</b>
                   </div>
                  <div class="col-md-5">
                     <asp:TextBox ID="txtmfname" runat="server" Style="text-transform: uppercase;"  CssClass="requiredField"></asp:TextBox>
                   <%--  <asp:RequiredFieldValidator ID="r9" runat="server" ControlToValidate="txtmfname" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                  </div>
                    <div class="col-md-3">
                       <label class="pull-left">Model Number</label>
			            <b class="pull-right">:</b>
                   </div>
                  <div class="col-md-5">
                     <asp:TextBox ID="txtmodelno" runat="server" Style="text-transform: uppercase;"  CssClass="requiredField"></asp:TextBox>
                  </div>
               </div>
               <div class="row">
                  <div class="col-md-3">
                       <label class="pull-left">No of Rack</label>
			            <b class="pull-right">:</b>
                   </div>
                  <div class="col-md-5">
                     <asp:TextBox ID="txtnoofrack" runat="server" Style="text-transform: uppercase;"  CssClass="requiredField"></asp:TextBox>
                     <cc1:FilteredTextBoxExtender ID="Filteredtextboxextender1" runat="server" FilterType="Numbers" TargetControlID="txtnoofrack">
                     </cc1:FilteredTextBoxExtender>
                    <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtnoofrack" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                  </div>
                  <div class="col-md-3">
                       <label class="pull-left">Serial Number</label>
			            <b class="pull-right">:</b>
                   </div>
                  <div class="col-md-5">
                     <asp:TextBox ID="txtserialno" runat="server" Style="text-transform: uppercase;"  CssClass="requiredField"></asp:TextBox>
                     <%--<asp:RequiredFieldValidator ID="r10" runat="server" ControlToValidate="txtserialno" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                  </div>
                  <div class="col-md-3">
                     <asp:CheckBox ID="chkActive" runat="server" Checked="true" style="font-weight: 700" Text="Active" TextAlign="right" />
                  </div>
                  <div class="col-md-5">
                   <%--  <asp:RequiredFieldValidator ID="r11" runat="server" ControlToValidate="txtmodelno" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>--%>
                  </div>
               </div>
               <div class="row">
                   <div class="col-md-11">
                   </div>
                   <div class="col-md-3">
                     <asp:Button ID="btnSave" runat="server" CssClass="savebutton" OnClick="btnSave_Click" Text="Save" ValidationGroup="save" />
                     <asp:Button ID="btnUpdate" runat="server" CssClass="savebutton" OnClick="Unnamed_Click" Text="Update" ValidationGroup="save" />
                     <asp:Button ID="btn" runat="server" CssClass="searchbutton"  Text="Load Rack"  OnClientClick="showDialog(); return false;" style="display:none;" />
                   </div>
               </div>
               <div style="border-collapse: collapse;display:none">
                  <div class="row">
                     <div class="col-md-1" style="text-align: right; font-weight: 700;"></div>
                     <div class="col-md-1">
                     </div>
                     <div class="col-md-1">
                         &nbsp;
                     </div>
                     <div class="col-md-1">
                         &nbsp;
                     </div>
                     <div class="col-md-1">
                         &nbsp;
                     </div>
                     <div class="col-md-1">
                         &nbsp;
                     </div>
                  </div>
                  <div class="row">
                     <div class="col-md-4 text-right">
                          <b>&nbsp;</b>
                     </div>
                     <div class="col-md-4">
                        &nbsp;
                     </div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                  </div>
                  <div class="row">
                      <div class="col-md-4 text-right">
                          <b>&nbsp;</b>
                      </div>
                     <div class="col-md-1">
                        &nbsp;
                     </div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                  </div>
                  <div class="row">
                      <div class="col-md-1">
                          &nbsp;
                      </div>
                     <div class="col-md-1">
                        &nbsp;
                     </div>
                     <div class="col-md-2">
                        <asp:TextBox ID="txtId" runat="server" style="display:none;" />
                     </div>
                     <div class="col-md-1"></div>
                     <div class="col-md-1"></div>
                     <div class="col-md-1"></div>
                  </div>
                  <div class="row">
                      <div class="col-md-1 text-right">
                          &nbsp;
                      </div>
                     <div class="col-md-1">
                        &nbsp;
                     </div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                  </div>
                  <div class="row">
                      <div class="col-md-4"><b>&nbsp;</b></div>
                     <div class="col-md-1">
                        &nbsp;
                     </div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                  </div>
                  <div class="row">
                      <div class="col-md-4">
                          &nbsp;
                      </div>
                     <div class="col-md-1">
                        &nbsp;
                     </div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                  </div>
                  <div class="row">
                      <div class="col-md-4">
                          &nbsp;
                      </div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                  </div>
                  <div class="row">
                      <div class="col-md-1">
                          &nbsp;
                      </div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                     <div class="col-md-1">&nbsp;</div>
                  </div>
                  <div class="row">
                  </div>
               </div>
            </div>
            <div class="POuter_Box_Inventory">
               <div class="Purchaseheader">
                  Device List&nbsp;
               </div>
                <div class="row" style="display:none">
                    <div class="col-md-6">
                        <label class="pull-left">Search By Name</label>
			            <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-12">
                            <asp:TextBox ID="txtsearch" runat="server"></asp:TextBox>
                            &nbsp;&nbsp;
                            <asp:Button ID="btnsearch" Text="Search" runat="server" OnClick="btnsearch_Click" CssClass="searchbutton" />
                    </div>
                </div>
                <div class="row">
                    <div style="overflow: scroll; height: 250px;">
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowDeleting="GridView1_RowDeleting" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDataBound="GridView1_RowDataBound" Width="99%" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Centre">
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("centre") %>'></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Storage Type">
                                <ItemTemplate>
                                    <asp:Label ID="Label411" runat="server" Text='<%# Bind("StorageType") %>'></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Device Name">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("name") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lbname" runat="server" Text='<%# Bind("name") %>'></asp:Label>
                                    <asp:Label ID="lbid" runat="server" Text='<%# Bind("id") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lbcentreid" runat="server" Text='<%# Bind("centreid") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lbdeptid" runat="server" Text='<%# Bind("departmentid") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("isactive") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lbmfby" runat="server" Text='<%# Bind("ManufactureName") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lbmodel" runat="server" Text='<%# Bind("ModelNumber") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lbseri" runat="server" Text='<%# Bind("SerialNumber") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lbnorack" runat="server" Text='<%# Bind("NumberOfRack") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lbstorate" runat="server" Text='<%# Bind("StorageTypeID") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="No of Rack">
                                <ItemTemplate>
                                    <asp:Label ID="Label4111" runat="server" Text='<%# Bind("NumberOfRack") %>'></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Model No">
                                <ItemTemplate>
                                    <asp:Label ID="Label41" runat="server" Text='<%# Bind("ModelNumber") %>'></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Created By">
                                <ItemTemplate>
                                    <asp:Label ID="Labweffel41" runat="server" Text='<%# Bind("CreatedBy") %>'></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Created On">
                                <ItemTemplate>
                                    <asp:Label ID="Labfewfel41" runat="server" Text='<%# Bind("CreatedOn") %>'></asp:Label>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="status" HeaderText="Status" />
                                <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                        Text="Select"></asp:LinkButton>
                                </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ChangeStatus" Visible="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Delete"
                                        Text="Deactive"></asp:LinkButton>
                                </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                            <RowStyle ForeColor="#000066" HorizontalAlign="Left" />
                            <SelectedRowStyle BackColor="Pink" Font-Bold="True" />
                        </asp:GridView>
                    </div>
                </div>
            </div>
         </div>
         <asp:Panel ID="pnl" runat="server" style="display:none;">
            <div class="POuter_Box_Inventory" style="background-color:papayawhip">
               <div class="Purchaseheader">
                  Rack
               </div>
               <div style="height:250px;overflow:auto;">
                  <div id="tb_ItemList" class="col-md-24" style="background-color:White;border-color:#CCCCCC;border-width:1px;border-style:None;border-collapse:collapse;margin-left:10px;">
                     <div id="header" class="row" style="color:White;background-color:#006699;font-weight:bold;">
                        <div class="col-md-1 text-left">
                           S.No.
                        </div>
                        <div class="col-md-5 text-left">
                           RackNo
                        </div>
                        <div class="col-md-4 text-left">
                           <input type="text" id="ssd" onkeyup="addmenow()" placeholder="Tray Qty"  />
                        </div>
                        <div class="col-md-5 text-left">
                           <select id="ddltrayhead" class="mmc" onchange="setmenow()"></select>
                        </div>
                        <div class="col-md-9 text-left" >
                            Tray Detail
                        </div>
                     </div>
                  </div>
               </div>
               <center>
                  <input type="button" value="Save" class="savebutton" onclick="savemenow()" />
                  <asp:Button ID="btncloseopd" runat="server" Text="Close" CssClass="resetbutton" />
               </center>
            </div>
         </asp:Panel>
         <cc1:ModalPopupExtender ID="modelopdpatient" runat="server" CancelControlID="btncloseopd"  TargetControlID="Button1"
            BackgroundCssClass="filterPupupBackground" PopupControlID="pnl">
         </cc1:ModalPopupExtender>
         <asp:Button ID="Button1" runat="server"  style="display:none;" />
      </ContentTemplate>
   
</asp:Content>