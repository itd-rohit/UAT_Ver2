<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="OPD_Result_Remove.aspx.cs" Inherits="Design_EDP_OPD_Result_Remove" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

    
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <script type = "text/javascript">

        function chkSelectAll(objRef) {

            var GridView = objRef.parentNode.parentNode.parentNode;

            var inputList = GridView.getElementsByTagName("input");

            for (var i = 0; i < inputList.length; i++) {
                var row = inputList[i].parentNode.parentNode;

                if (inputList[i].type == "checkbox" && objRef != inputList[i]) {

                    if (objRef.checked) {
                        row.style.backgroundColor = "aqua";
                        inputList[i].checked = true;
                    }
                    else {
                        row.style.backgroundColor = "#C2D69B";
                        inputList[i].checked = false;
                    }
                }
            }
        }

</script> 
 <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align:center" >
           <div class="row">
    <div class="col-md-24">
<span style="font:bold;font-size:large;font-weight:bold"> Remove Result</span><br />
<asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
   </div>  
</div>
        </div>


    <div class="row">
        <div class="col-md-9"></div>
         <div class="col-md-2">Visit No :</div>
         <div class="col-md-4"><asp:TextBox id="txtRecipt" class="requiredField" data-title="Enter Visit No"  runat="server" Width="200px" AutoCompleteType="Disabled" TabIndex="1"></asp:TextBox></div>
        <div class="col-md-4">
            <asp:Button id="btnSearch" tabIndex="2"  onclick="btnSearch_Click" runat="server"   Text="Search" Width="100px"></asp:Button>
            </div>
        <div class="col-md-5"></div>
    </div>
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
            Patient Details&nbsp;</div>
        <div class="row">
             <div class="col-md-6"></div>
                  <div class="col-md-3">Lab No. :</div>
            <div class="col-md-6"><asp:Label ID="lbllabno" runat="server"></asp:Label></div>
            <div class="col-md-3">Lab/Package :</div>
            <div class="col-md-6"> <asp:Label ID="lbltypetnx" runat="server"></asp:Label></div>
 </div>
              <div class="row">
             <div class="col-md-6"></div>
                  <div class="col-md-3">Patient ID :</div>
                  <div class="col-md-6"> <asp:Label ID="lblCRNumber" runat="server"></asp:Label></div>
                  <div class="col-md-3">Patient name</div>
                  <div class="col-md-6"><asp:Label ID="lblName" runat="server"></asp:Label></div>
                  </div>


            <div class="row">
             <div class="col-md-6"></div>
                  <div class="col-md-3">Date Of Birth / Age :</div>
                  <div class="col-md-6"> <asp:Label ID="lblDOB" runat="server"></asp:Label></div>
                  <div class="col-md-3">Amount Paid :</div>
                  <div class="col-md-6"><asp:Label ID="lblAmount" runat="server"></asp:Label></div>
                  </div>

        
            <div class="row">
             <div class="col-md-6"></div>
                  <div class="col-md-3">Doctor :</div>
                  <div class="col-md-6"> <asp:Label ID="lblDoctor" runat="server"></asp:Label></div>
                  <div class="col-md-3">Net AMount :</div>
                  <div class="col-md-6"><asp:Label ID="lblFileType" runat="server"></asp:Label>
                    <asp:Label ID="lblNetAmt" runat="server"  ></asp:Label></div>
                  </div>
        <div class="row">
             <div class="col-md-6"></div>
                  <div class="col-md-3">Type :</div>
                  <div class="col-md-6"> <asp:Label ID="lblType" runat="server"></asp:Label></div>
                  <div class="col-md-3">Company Name :</div>
                  <div class="col-md-6"><asp:Label ID="lblPanel" runat="server"></asp:Label></div>
                  </div>
       
                </div>
    <div class="POuter_Box_Inventory">
  <div class="Purchaseheader">
  Prescribed Investigation
  </div>
 <div class="row" style="text-align:center;overflow:scroll; ">
      <div class="col-md-24">
 <asp:GridView id="grdItemRate" Width="100%" runat="server" CssClass="GridViewStyle" RowStyle-BackColor="#669999"  AutoGenerateColumns="False" OnRowCommand="grdItemRate_RowCommand" OnRowDataBound="grdItemRate_RowDataBound" >
  
  
 <Columns >
 
       
        
                <asp:TemplateField HeaderText="#"  >
                <ItemTemplate>
               
                <%# Container.DataItemIndex+1 %>
                </ItemTemplate> 
                <ItemStyle CssClass="GridViewItemStyle"  />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                </asp:TemplateField>
               
 
 <asp:BoundField DataField="Date" HeaderText="Date">
                <ItemStyle CssClass="GridViewItemStyle"  />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                </asp:BoundField>
 

 <asp:BoundField DataField="ItemName" HeaderText="ItemName" >
                <ItemStyle CssClass="GridViewItemStyle" />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                </asp:BoundField>

 <asp:TemplateField  HeaderText="ItemID" Visible="false"  >
                <ItemTemplate>
                <asp:Label ID="lblItem" runat="server"  Text='<%# Eval("ItemID") %>' ></asp:Label> 
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" /> 
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                </asp:TemplateField>
                
                <asp:TemplateField  HeaderText="TestID"    >
                <ItemTemplate>
                <asp:Label ID="lblTestID" runat="server"  Text='<%# Eval("TestID") %>' ></asp:Label> 
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" /> 
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                </asp:TemplateField>
                
                <asp:TemplateField  HeaderText="Result" Visible="false"  >
                <ItemTemplate>
                <asp:Label ID="lblPrint" runat="server" Text=' <%#Eval("isPrint") %>' Visible="true" />
                <asp:Label ID="lblresult" runat="server" Text=' <%#Eval("Result_Flag") %>' Visible="true" />
                <asp:Label ID="lblapprove" runat="server" Text=' <%#Eval("Approved") %>' Visible="true" />
                <asp:Label ID="lblSampleColl" runat="server" Text=' <%#Eval("IsSampleCollected") %>' Visible="true" />
                <asp:Label ID="lblrowColor" runat="server" Text=' <%#Eval("rowColor") %>' Visible="true" />
                </ItemTemplate>
                <ItemStyle CssClass="GridViewItemStyle" /> 
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                </asp:TemplateField>
                
                
                
                <asp:TemplateField>
                <HeaderTemplate>
                                <asp:CheckBox ID="chkSelectAll" onclick="chkSelectAll(this);" runat="server" />
                            </HeaderTemplate>
               <ItemTemplate>
                <asp:CheckBox ID="chkItem" runat="server" Visible="false" />
                </ItemTemplate> 
                <ItemStyle CssClass="GridViewItemStyle"  />
                <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                </asp:TemplateField> 

</Columns>
</asp:GridView>
<br />
</div>
     </div> 
<div class="row" style="text-align:center;">
    <div class="col-md-24">
    <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click"  Visible="false"/></div>
    </div>
</div>
    </div>
</asp:Content>

