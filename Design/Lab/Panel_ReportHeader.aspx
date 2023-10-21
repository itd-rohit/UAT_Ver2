<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Panel_ReportHeader.aspx.cs" Inherits="Design_Centre_Panel_ReportHeader" Title="Untitled Page" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center">
                <b>Manage Report Header</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
          
        </div>
    <div>
         
        <table style="width: 953px">
    
            <tr>
                <td align="right" style="width: 126px; height: 12px" valign="middle" class="ItDoseLabel">
                    Center:&nbsp;
                </td>
                <td align="left"  style="width: 334px; height: 12px" valign="middle"><asp:DropDownList ID="ddlCentre" runat="server" CssClass="ItDoseDropdownbox"
                        Width="376px" AutoPostBack="True" OnSelectedIndexChanged="ddlCentre_SelectedIndexChanged">
                </asp:DropDownList></td>
                <td align="right"  style="font-size: 8pt; width: 111px; height: 12px"
                    valign="middle">
                    Top Margin:&nbsp;
                    </td>
                <td align="left"  style="font-weight: bold;height: 12px; width: 377px;" valign="middle">
                    <asp:TextBox ID="txtTopMargin" runat="server" Text="0"></asp:TextBox>px</td>
            </tr>
            <tr>
                <td align="right" style="width: 126px; height: 13px" valign="middle" class="ItDoseLabel">
                    Panel:&nbsp;
                </td>
                <td align="left"  style="width: 334px; height: 13px" valign="middle">
                    <asp:DropDownList ID="ddlPanel" runat="server" CssClass="ItDoseDropdownbox"
                        Width="376px" AutoPostBack="True" OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged" >
                    </asp:DropDownList>  <asp:CheckBox ID="chkAll" runat="server" Text="All" Width="129px" AutoPostBack="True" OnCheckedChanged="chkAll_CheckedChanged"  /></td>
                <td align="right"  style="font-size: 8pt; width: 111px; color: #000000;
                    font-family: Verdana; height: 13px; text-align: left;" valign="middle">
                    &nbsp; &nbsp; &nbsp; &nbsp; Left Margin:</td>
                <td align="left"  style="font-weight: bold; height: 13px; width: 377px;" valign="middle">
                    <asp:TextBox ID="txtLeftMargin" runat="server" Text="0"></asp:TextBox>px</td>
            </tr>
            </table>
                        
      <div class="Outer_Box_Inventory" style="width: 962px">
          <div class="Purchaseheader">
              New Lab-Observation</div>
             
          <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
              <tr>
                  <td align="center" class="ItDoseLabel" style="width: 67%; " valign="TOP">
                      <%--<CE:Editor runat="server" ID="txtLimit" 
        ShowBottomBar="false" UseFontTags="true"  BreakElement="Br" AutoConfigure="Simple" ThemeType="Office2007" ></CE:Editor>--%>
                      <ckeditor:ckeditorcontrol ID="txtLimit"  BasePath="~/ckeditor" runat="server"   EnterMode="BR" Height="200px" Width="780px"></ckeditor:ckeditorcontrol>

                  </td>
                  <td align="Left" class="ItDoseLabel" style="width: 100%" valign="Top">
                  <div style=" max-height:300px;overflow:auto;">
                  <%for (int i = 0; i<dt.Columns.Count; i++)
                    {
                         %>
                         <%=(i+1) %>  &nbsp;<%=Util.GetString(dt.Columns[i].ColumnName) %>
                    <br />
                    <%}%>
                  </div>
                  </td>
              </tr>
              <tr>
                  <td align="center" class="ItDoseLabel" style="width: 67%; height: 24px; "
                      valign="middle">
                      <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" Width="56px" />
                      &nbsp;&nbsp;
                  </td>
                  <td align="center" class="ItDoseLabel" style="width: 87%; height: 24px" valign="middle">
                  </td>
              </tr>
              <tr style="font-size: 10pt; font-family: Arial">
                  <td align="right" class="ItDoseLabel" style="width: 67%" valign="middle">
                  </td>
                  <td align="right" class="ItDoseLabel" style="width: 87%" valign="middle">
                  </td>
              </tr>
          </table>
      </div>
      </div>
</div>            
  


</asp:Content>

