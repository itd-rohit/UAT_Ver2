<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MapMicroMaster.aspx.cs" Inherits="Design_Investigation_MapMicroMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
    
    <script type="text/javascript">
        var id='<%=id%>' ;
        var typeid = '<%=typeid%>';

        function searchremaingdata() {
            $modelBlockUI();
            var searchtype = $("#<%=rdobservation.ClientID%>").find(":checked").val();
            var ddlpro = $('#<%=ddlavilableitem.ClientID%>');
            ddlpro.empty();
            $.ajax({
                url: "../Lab/Services/LabCulture.asmx/getunmappeddata",
                data: '{ searchtype:"' + searchtype + '",masterid:"'+id+'"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async:false,
                 success: function (result) {
                     PatientData = jQuery.parseJSON(result.d);
                    
                     for (var a = 0; a <= PatientData.length - 1; a++) {
                         ddlpro.append($("<option></option>").val(PatientData[a].id).html(PatientData[a].NAME));
                     }
                     $modelUnBlockUI();
                 },
                 error: function (xhr, status) {
                     $modelUnBlockUI();
                 }
             });
        }


        function searchsaveddata() {
            $modelBlockUI();
            var searchtype = $("#<%=rdobservation.ClientID%>").find(":checked").val();
            var ddlpro = $('#<%=ddlsaveditem.ClientID%>');
            ddlpro.empty();
            $.ajax({
                url: "../Lab/Services/LabCulture.asmx/getsaveddata",
                data: '{ searchtype:"' + searchtype + '",masterid:"' + id + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);

                    for (var a = 0; a <= PatientData.length - 1; a++) {
                        ddlpro.append($("<option></option>").val(PatientData[a].mapid).html(PatientData[a].name));
                    }
                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                }
            });
        }

        $(document).ready(function () {
            bindlist();
        });

        function bindlist() {
            searchremaingdata();
            searchsaveddata();
        }

        function additem() {
            $modelBlockUI();
            if ($('#<%=ddlavilableitem.ClientID%>').attr('selectedIndex') == -1) {
                $('#<%=lblMsg.ClientID%>').html("Please Select Item To Add");
                return;
            }
            var breakpoint = "";
            var searchtype = $("#<%=rdobservation.ClientID%>").find(":checked").val();

            var mapid = getnewvalue();
         
            $.ajax({
                url: "../Lab/Services/LabCulture.asmx/savemapping",
                data: JSON.stringify({ typeid: typeid, masterid: id, maptypeid: searchtype, mapmasterid: mapid, breakpoint: breakpoint }), // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     if (result.d == "1") {
                         $('#<%=lblMsg.ClientID%>').html("Item Tagged Sucessfully..!");
                         searchremaingdata();
                         searchsaveddata();
                     }
                     $modelUnBlockUI();
                 },
                  error: function (xhr, status) {
                     // alert(xhr.responseText);
                      //window.status = status + "\r\n" + xhr.responseText;
                      $modelUnBlockUI();
                  }
              });
        }

        function removeitem() {
            $modelBlockUI();
            if ($('#<%=ddlsaveditem.ClientID%>').attr('selectedIndex') == -1) {
                $('#<%=lblMsg.ClientID%>').html("Please Select Item To Remove");
                $modelUnBlockUI();
                return;
            }
            var mapid = getmapvalue();
            var searchtype = $("#<%=rdobservation.ClientID%>").find(":checked").val();
            $.ajax({
                url: "../Lab/Services/LabCulture.asmx/deletemapping",
                data: JSON.stringify({ mapid: mapid, maptypeid: searchtype }), // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        $('#<%=lblMsg.ClientID%>').html("Item Remove Sucessfully..!");
                        searchremaingdata();
                        searchsaveddata();
                    }
                    $modelUnBlockUI();
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                }
             });

        }

        function getmapvalue() {
            var tempData = [];
          

            var selected = $("[id*=ContentPlaceHolder1_ddlsaveditem] option:selected");
            selected.each(function () {
                tempData.push($(this).val());
            });
            return tempData;
        }

        function getnewvalue() {
            var tempData = [];
            var selected = $("[id*=ContentPlaceHolder1_ddlavilableitem] option:selected");
            selected.each(function () {
                tempData.push($(this).val());
            });
            return tempData;
        }
    </script>

      <div id="Pbody_box_inventory" style="width:1000px;">
        <div class="POuter_Box_Inventory" style="width:1000px;" >
            <div class="content" style="text-align: center; width:1000px;">
                <b>MicroBiology Maste Mapping</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            </div>
            <div class="POuter_Box_Inventory" style="width:1000px;" >
                <div class="content" style="text-align: center; width:1000px;">
                    <table width="100%">
                        <tr>
                            <td style="text-align: right" width="45%"><asp:Label ID="lbname" runat="server" Font-Bold="true"></asp:Label></td>
                            <td style="width: 10px">:</td>
                             <td style="text-align: left"><asp:Label ID="lbtext" runat="server" Font-Bold="true"></asp:Label></td>
                        </tr>
                         <tr>
                            <td style="text-align: right;font-weight:bold;" width="45%">Code</td>
                            <td style="width: 10px">:</td>
                             <td style="text-align: left"><asp:Label ID="lblCode" runat="server" Font-Bold="true"></asp:Label></td>
                        </tr>
                    </table>
                    </div>
                </div>
            <div class="POuter_Box_Inventory" style="width:1000px;" >
                <div class="content" style="text-align: center; width:1000px;">
                 
                    <asp:RadioButtonList ID="rdobservation" runat="server" RepeatDirection="Horizontal" onchange="bindlist()">
                        
                          <asp:ListItem Value="6" Selected="True">Organism To Antibiotic</asp:ListItem>
                          <asp:ListItem Value="4" >Antibiotic Group To Antibiotic</asp:ListItem>
                    </asp:RadioButtonList>
                  

                </div>
                </div>

           <div class="POuter_Box_Inventory" style="width:1000px;" >
                <div class="content" style="text-align: center; width:1000px;">
                    <table style="width:98%">
                        <tr>
                            <td width="45%" align="left"><strong>Mapped Item</strong></td>
                            <td width="10%" align="center"></td>
                            <td width="45%" align="left"><strong>UnMapped Item</strong></td>
                        </tr>
                        <tr>
                            <td width="45%">
                                <asp:ListBox ID="ddlsaveditem" runat="server" Width="100%" Height="300px" SelectionMode="Multiple"></asp:ListBox>
                            </td>
                            <td width="10%" align="center">
                                 <img src="../../App_Images/TRY6_26.gif" onclick="additem()" alt="Add" style="cursor:pointer;" title="Tag Selected Item"/>
                               
                              
                                <br />
                                 <br />
                                <img src="../../App_Images/TRY6_25.gif" onclick="removeitem()" alt="Remove" style="width:44px;cursor:pointer;" title="Remove Selected Item" />
                               
                            </td>
                            <td width="45%">
                                  <asp:ListBox ID="ddlavilableitem" SelectionMode="Multiple" runat="server" Width="100%" Height="300px" ></asp:ListBox>
                            </td>
                        </tr>
                    </table>
                    </div>
               </div>
          </div>
</asp:Content>

