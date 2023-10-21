<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InvTemplate_Word.aspx.cs" Inherits="Design_PACS_InvTemplate_Word" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript">    

    function WriteToFile(data, name) {
        //************************************************************
        //This will create local file on client PC with Required Data
        //************************************************************
        try {
            var fso = new ActiveXObject("Scripting.FileSystemObject");
            var s = fso.CreateTextFile("C:\\RIS\\" + name + ".txt", true);
            s.WriteLine(data);
            s.Close();
        }
        catch (e) { }
   }

    function loadTemplate() {
        //************************************************************
        //Changing name=Template, may stop MS Word integration- Deepak
        //************************************************************
        var investigation_id = $('#<%=ddlInvestigation.ClientID %>').val();

        if(investigation_id!="")
        WriteToFile(investigation_id, "Template");
        
    }
 
       function openRadiologyTemp() {
           var link = "ris:OpenForm?Type=Templates&Weblink=<%=Request.Url.Scheme %>://<%=Request.Url.Host %>:<%=Request.Url.Port %>/<%=Request.Url.AbsolutePath.Split('/')[1] %>/RIS.asmx";
           window.location = link;
       } 
    

</script>


<div id="Pbody_box_inventory" style="text-align:left;" >
    <div class="POuter_Box_Inventory">
    <div class="row">
    <div class="col-md-24" style="text-align:center;">
    <b>Create Investigation Template<br />
    </b>
    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />    </div>
   </div>
   </div>
      
    <div class="POuter_Box_Inventory" style="width: 962px;display:none; ">
    <div class="Purchaseheader">
        Select Investigation&nbsp;</div>
        <table style="width: 953px">            
            <tr>
                <td align="right" style="width: 126px; height: 13px" valign="middle" class="ItDoseLabel">
                    Investigation</td>
                <td align="left"  style="width: 334px; height: 13px" valign="middle">
                    <asp:DropDownList ID="ddlInvestigation" runat="server" CssClass="ItDoseDropdownbox"
                        Width="376px" >
                    </asp:DropDownList></td>
                <td align="right"  style="font-size: 8pt; width: 111px; color: #000000;
                    font-family: Verdana; height: 13px; text-align: left;" valign="middle">
                    <input id="btnLoad" type="button" value="Load Template" onclick="loadTemplate();" /></td>
                <td align="left"  style="font-weight: bold; height: 13px; width: 377px;" valign="middle">
                </td>
            </tr>
            <tr>
                <td align="right" class="ItDoseLabel" style="width: 126px; height: 13px" valign="middle">
                    &nbsp;</td>
                <td align="left" colspan="3" valign="middle">
                    &nbsp;</td>
            </tr>
            
        </table>
    </div>
    <div class="row" style="text-align:center">
        <div class="col-md-24">
            <input id="Button1" type="button" value="Radiology Templates" onclick="openRadiologyTemp();" />           
        </div>
    </div>
         
      </div>
 
  </asp:Content>


