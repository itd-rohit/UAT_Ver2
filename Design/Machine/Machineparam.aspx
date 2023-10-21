<%--<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Machineparam.aspx.cs" Inherits="Design_Machine_Machineparam" %>--%>

<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Machineparam.aspx.cs"  Inherits="Design_Machine_Machineparam" Title="Machineparam" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <%--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">--%>
  
    <script>
        $(document).ready(function () {
            //alert('its working');
            $.ajax({
                url: "Machineparam.aspx/getMachineinfo",
                data: '',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                   // $("#DropDownList2").Empty();
                    var storedata = $.parseJSON(result.d);
                    var ddl = document.getElementById("<%=DropDownList2.ClientID %>");
                    var option = document.createElement("OPTION");
                    option.innerHTML ="--Select Test--";
                    option.value =0;
                    ddl.options.add(option);
                    for (var i = 0; i <= storedata.length - 1; i++)
                    {
                       //  alert(storedata[i].Name);
                       
                        var option = document.createElement("OPTION");
                        option.innerHTML = storedata[i].Name;
                        option.value = storedata[i].LabObservation_ID;
                        ddl.options.add(option);
                    }
                   
                   // alert(result.d);
                },
                error: function (xhr, status) {
                    //window.status = status + "\r\n" + xhr.responseText;
                }

                });
        });
        function Update()
        {
           // alert("Hello");
            var txt1 = $("#<%=paramId.ClientID %>").val();
            var txt2 = $("#<%=DropDownList2.ClientID %>").val();
            console.log(txt1 + " " + txt2);
            $.ajax({
                url: "Machineparam.aspx/UpdateInfo",
                data: '{txt1:"' + txt1 + '",txt2:"' + txt2 + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                   // console.log(result.d);
                    alert(result.d);
                },
                error: function (result) {
                    alert(result.d);
                    //window.status = status + "\r\n" + xhr.responseText;
                }

            });
        }
    </script>
    <style>
        .column {
    float: left;
    width:16%;
   height:600px;  overflow: scroll;
}
.column1 {
    float: left;
    width:82%;
     height:400px;  overflow: scroll;
}
.column2{
    margin-top:5px;
    float: left;
    width:82%;
    
}
.column3{
    margin-top:5px;
    float: left;
    width:82%;
     height:170px;
}
.Subcolumn1{
    float: left;
    width:50%;
    
}
.column4{
 
    float: left;
   
    
}
/* Clear floats after the columns */
.row:after {
    content: "";
    display: table;
    clear: both;
}
.grid_scroll
{
    overflow: auto;
    height: 500px;
    border: solid 1px orange;
    height:200px;
    width: 800px;
}



.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    padding-top: 100px; /* Location of the box */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}

/* Modal Content */
.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width:50%;
}

/* The Close Button */
.close {
    color: #aaaaaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}

.close:hover,
.close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
}
    </style>
    <div id="Pbody_box_inventory" style="width:80%">
        <div class="POuter_Box_Inventory" style="text-align: center;width:100%">


            <b>Machine Mapping<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>


        </div>
        <%-- Patient's registration--%>
        <div class="POuter_Box_Inventory" style="width:100%">
            <div class="Purchaseheader">
                Basic Information
            </div>
            <div class="row">
  <div class="column">
      <asp:GridView ID="ddlmachine" runat="server" AutoGenerateColumns="False" OnRowCommand="ddlmachine_RowCommand"  Width="30px" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical" Style="width:100px;height: 600px; overflow: auto; ">
                            <AlternatingRowStyle BackColor="#DCDCDC" />
          
                            <Columns>
                                
                                <asp:TemplateField HeaderText="MachineId">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkMachineId" runat="server" Text='<%#Eval("MachineId") %>'  CommandArgument='<%#Eval("MachineId") %>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <%--<asp:TemplateField  HeaderText="Machine Name">
                                    <ItemTemplate>
                                        <asp:label ID="lblMachinName" runat="server"  Text='<%#Eval("MachineName") %>' ></asp:label>
                                    </ItemTemplate>
                                </asp:TemplateField>--%>
                            </Columns>
                            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
                            <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#F1F1F1" />
                            <SortedAscendingHeaderStyle BackColor="#0000A9" />
                            <SortedDescendingCellStyle BackColor="#CAC9C9" />
                            <SortedDescendingHeaderStyle BackColor="#000065" />
                        </asp:GridView></div>
  <div class="column1">
      <asp:GridView ID="GridView1" AutoGenerateColumns="false" runat="server" BackColor="#DEBA84"  BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" OnRowCommand="GridView1_RowCommand">
          <Columns>
               <asp:TemplateField HeaderText="Machine_ParamID">
                  <ItemTemplate>
                      <asp:LinkButton ID="lnkMachineId1" runat="server" Text='<%#Eval("Machine_ParamID") %>'  CommandArgument='<%#Eval("Machine_ParamID") %>' ></asp:LinkButton>
                 
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="MACHINEID">
                  <ItemTemplate>
                 
                       <asp:Label ID="Label1" runat="server" Text='<%# Bind("MACHINEID") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
              
              <asp:TemplateField HeaderText="Machine_Param">
                  <ItemTemplate>
                 
                      <asp:Label ID="Label2" runat="server" Text='<%# Bind("Machine_Param") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="AssayNo">
                  <ItemTemplate>
                 
                      <asp:Label ID="Label3" runat="server" Text='<%# Bind("AssayNo") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="RoundUpTo">
                  <ItemTemplate>
                  
                      <asp:Label ID="Label4" runat="server" Text='<%# Bind("RoundUpTo") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="IsOrderable">
                  <ItemTemplate>
                      <asp:Label ID="Label5" runat="server" Text='<%# Bind("IsOrderable") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Decimalcalc">
                  <ItemTemplate>
                       <asp:Label ID="Label6" runat="server" Text='<%# Bind("Decimalcalc") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField HeaderText="Test">
                  <ItemTemplate>                 
<asp:Label ID="Label7" runat="server" Text='<%# Bind("Test") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
          </Columns>
                            <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
                            <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
                            <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
                            <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
                            <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#FFF1D4" />
                            <SortedAscendingHeaderStyle BackColor="#B95C30" />
                            <SortedDescendingCellStyle BackColor="#F1E5CE" />
                            <SortedDescendingHeaderStyle BackColor="#93451F" />
                        </asp:GridView>
  </div>
                 <div class="column2">
      <input type="button" id="myBtn" value="Add Param" tabindex="21" class="savebutton"/>
      <input type="button" id="mymodify" value="Modify Param" tabindex="21" class="savebutton"/>
                     
  </div>
                <div class="column3">
                    <div class="Purchaseheader">
                Param Mapping
            </div>
      <div class="Subcolumn1">
          <asp:HiddenField ID="HiddenField1" runat="server" />
          <input type="text" style="width:200px" runat="server" id="paramId" readonly="readonly"  />
         <%-- <select id="DropDownList2" runat="server" style="width:200px" ></select>--%>
          <asp:DropDownList ID="DropDownList2" runat="server" style="width:200px"></asp:DropDownList>

  <input type="button" id="Button3" value="Add" onserverclick="Button3_ServerClick" runat="server" tabindex="21" class="savebutton" style="padding:0"/>
      </div>
      <div class="Subcolumn1">
        <%--  <input type="text" id="rmvtest" runat="server" readonly="readonly" style="width:200px"/>
          <asp:DropDownList ID="DropDownList1" runat="server" style="width:200px"></asp:DropDownList>
  <input type="button" id="Button4" value="Remove" tabindex="21" runat="server" onserverclick="Button4_ServerClick" class="savebutton" style="padding:0"/>--%>
     <asp:GridView ID="GridView2" AutoGenerateColumns="false" runat="server" BackColor="#DEBA84"  BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" OnRowCommand="GridView2_RowCommand" >
          <Columns>
               
               <asp:TemplateField HeaderText="LabObservation_ID">
                  <ItemTemplate>
                      <asp:LinkButton ID="lnkMachineId1" runat="server" Text='<%#Eval("LabObservation_ID") %>' CommandArgument='<%#Eval("LabObservation_ID") %>' OnClientClick="return confirm('Are you sure you want to delete this?');" ></asp:LinkButton>                 
                  </ItemTemplate>
              </asp:TemplateField>
             <asp:TemplateField HeaderText="Test Name">
                  <ItemTemplate>
                 
                       <asp:Label ID="Label1" runat="server" Text='<%# Bind("NAME") %>'></asp:Label>
                  </ItemTemplate>
              </asp:TemplateField>
          </Columns>
                            <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
                            <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
                            <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
                            <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
                            <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#FFF1D4" />
                            <SortedAscendingHeaderStyle BackColor="#B95C30" />
                            <SortedDescendingCellStyle BackColor="#F1E5CE" />
                            <SortedDescendingHeaderStyle BackColor="#93451F" />
                        </asp:GridView>

         <%-- <table>
              <tr><th>TEST NAME</th></tr>
              <tbody id="testinfoid" runat="server"></tbody>
          </table>--%>
      </div>
  </div>
                <div class="column4">
      <input type="button" id="btn_addMachin" runat="server" onserverclick="btn_addMachin_ServerClick" value="Add Machine" style="width:100px" tabindex="21" />
     
                    
  </div>
                <div id="myModal" class="modal">

  <!-- Modal content -->
  <div class="modal-content">
      
    <span class="close">&times;</span>
   
<div class="POuter_Box_Inventory" style="width:100%">
            <div class="Purchaseheader">
              Machine Param  Basic Information
            </div>
  </div>
      <asp:HiddenField ID="HiddenField2" runat="server" />
     <table>
         <tr>
             <td><label for="usr">MachineID:</label></td>
             <td> <input type="text" class="form-control" id="f_macid" runat="server" readonly="readonly"/></td>
         </tr>
          <tr>
             <td> <label for="usr">Machine Param ID:</label></td>
             <td> <input type="text" class="form-control" id="f_param_id" runat="server"/></td>
         </tr>
          <tr>
             <td>  <label for="usr">Param Alias:</label></td>
             <td>  <input type="text" class="form-control" id="f_alias" runat="server"/></td>
         </tr>
         <tr>
             <td>  <label for="usr">Suffix:</label></td>
             <td>  <input type="text" class="form-control" id="f_suffix" runat="server"/></td>
         </tr>
          <tr>
             <td>  <label for="usr"> Assay No:</label></td>
             <td>  <input type="text" class="form-control" id="f_assay" runat="server"/></td>
         </tr>
         <tr>
             <td>  <label for="usr"> Round Upto:</label></td>
             <td>  <input type="text" class="form-control" id="f_round" value="1" runat="server"/></td>
         </tr>
         <tr>
             <td> <label for="usr"> is Orderable:</label></td>
             <td>  <input type="checkbox"  value="1" id="f_Order" runat="server"/></td>
         </tr>
          <tr>
             <td>  <label for="usr">  Multiple:</label></td>
             <td>  <input type="text" class="form-control" id="f_multip" value="1" runat="server"/></td>
         </tr>
         <tr>
             <td>  <label for="usr"> Min Length:</label></td>
             <td>   <input type="text" class="form-control" id="f_minlen" value="0" runat="server"/></td>
         </tr>
     </table>
      
   
     <div class="form-group">
         <input type="button" id="btn_save" value="Save"  onserverclick="Unnamed_ServerClick" runat="server" tabindex="21" class="savebutton" style="padding:0"/>
     
    </div>
      
</div>

</div>
            <table style="width: 980px; float: left;border-collapse:collapse">
                <tr>
                    <td  style="width: 35Px; height: 200px;" rowspan="1" >
                        <%--<asp:GridView ID="ddlmachine" runat="server" AutoGenerateColumns="False" OnRowCommand="ddlmachine_RowCommand" Height="200px" Width="30px" BackColor="White" BorderColor="#999999" BorderStyle="None" BorderWidth="1px" CellPadding="3" GridLines="Vertical">
                            <AlternatingRowStyle BackColor="#DCDCDC" />
                            <Columns>
                                <asp:TemplateField HeaderText="MachineId">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkMachineId" runat="server" Text='<%#Eval("MachineId") %>'  CommandArgument='<%#Eval("MachineId") %>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <%--<asp:TemplateField  HeaderText="Machine Name">
                                    <ItemTemplate>
                                        <asp:label ID="lblMachinName" runat="server"  Text='<%#Eval("MachineName") %>' ></asp:label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
                            <HeaderStyle BackColor="#000084" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                            <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
                            <SelectedRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#F1F1F1" />
                            <SortedAscendingHeaderStyle BackColor="#0000A9" />
                            <SortedDescendingCellStyle BackColor="#CAC9C9" />
                            <SortedDescendingHeaderStyle BackColor="#000065" />
                        </asp:GridView>--%>
                    </td>
                    <td style="text-align:right;" colspan="2" >
                        <%--<asp:GridView ID="GridView1" AutoGenerateColumns="true" runat="server" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2">
                            <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
                            <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
                            <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
                            <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
                            <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#FFF1D4" />
                            <SortedAscendingHeaderStyle BackColor="#B95C30" />
                            <SortedDescendingCellStyle BackColor="#F1E5CE" />
                            <SortedDescendingHeaderStyle BackColor="#93451F" />
                        </asp:GridView>--%>
                        <%--<table style="text-align:right; height: 18px;">
                           <thead>

                               <th>MachineID</th>
                                <th>Machine_Par</th>
                               <th>Machine_Par</th>
                            <th>Suffix</th>
                             <th>AssayNo</th>
                             <th>RoundUpTo</th>
                             <th>IsOrderable</th>
                            <th>Decimal</th>

                           </thead>
                        </table>--%>
                    </td>
                </tr>
                <tr>
                    <td style="width: 17%;text-align:right" >
                        <span style="color: red ">&nbsp;</span>
                    </td>
                    <td  style="width: 60%">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 17%;text-align:right; height: 18px;" >
                        <span style="color: red; ">&nbsp;</span>
                    </td>
                    <td  colspan="1" style="width: 60%; height: 18px;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td  style="width: 17%;text-align:right">
                        <span style="color: red;">&nbsp;</span>
                    </td>
                    <td  colspan="1" style="width: 60%">
                        &nbsp;</td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">

        </div>


    </div>


<script>
    // Get the modal
    var modal = document.getElementById('myModal');

    // Get the button that opens the modal
    var btn = document.getElementById("myBtn");

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];

    // When the user clicks the button, open the modal 
    btn.onclick = function () {
        modal.style.display = "block";
        var ids = $("#<%=HiddenField1.ClientID%>").val();
        $("#<%=f_macid.ClientID%>").val(ids);
        $("#<%=HiddenField2.ClientID%>").val("Save");
        $("#<%=btn_save.ClientID%>").val("Save");
    }
    mymodify.onclick = function ()
    {
        modal.style.display = "block";
        var ids = $("#<%=HiddenField1.ClientID%>").val();
        $("#<%=f_macid.ClientID%>").val(ids);
        $("#<%=f_param_id.ClientID%>").val($("#<%=paramId.ClientID%>").val());
        $("#<%=HiddenField2.ClientID%>").val("Update");
        $("#<%=btn_save.ClientID%>").val("Update");
        $("#<%=f_param_id.ClientID%>").attr('readonly', 'readonly');

    }
    // When the user clicks on <span> (x), close the modal
    span.onclick = function () {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>




</asp:Content>




