<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pro_master.aspx.cs" Inherits="Design_OPD_pro_master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript" >
    
    function enableTextBox()
     {
  
 
        if (document.getElementById('<%=cbcredit.ClientID %>').checked == true)
     {
            document.getElementById('<%=txtcredit.ClientID %>').style.display = '';
            }
        else
         {   
         document.getElementById('<%=txtcredit.ClientID %>').style.display ="none";
         alert("tick the iscreditlimit"); 
      }
              
    }

</script>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
<link href="../../App_Style/AppStyle.css"  rel="stylesheet" type="text/css" />
    <title>Doctor Referral Details</title>
</head>

   
<body>
     <form id="DocRefpopup" runat="server"> 
     <div id="Pbody_box_inventory" style="width: 871px" >
    <div class="POuter_Box_Inventory" style="width: 864px" id="DIV1" onclick="return DIV1_onclick()" >
 
    <div style="text-align:center;">
    <b>PRO MASTER</b></div>
     <div style="text-align:center;">
         <Ajax:ScriptManager id="ScriptManager1" runat="server"></Ajax:ScriptManager>
         <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>&nbsp;</div>
   </div>
   
      
    <div class="POuter_Box_Inventory" style="text-align: center; width: 864px;">
    <div class="Purchaseheader">
        PRO Details &nbsp;</div>
        <table style="width: 100%">
            <tr>
                <td align="right" style="width: 16%; height: 26px;" valign="middle" class="ItDoseLabel">
                   Name:
                </td>
               
                
                <td align="left"  style="width: 21%; height: 26px;" valign="middle">
                    <span class="text2"><strong><span style="color: #54a0c0"></span></strong><span style="font-size: 8pt"> <asp:DropDownList ID="cmbTitle" runat="server" CssClass="inputbox4" TabIndex="1"
                            ToolTip="select  gender" Width="66px">
                        
                        </asp:DropDownList>
                        <asp:TextBox ID="txtproName" runat="server" CssClass="inputbox3"  MaxLength="100"
                            TabIndex="2" Width="147px"></asp:TextBox></span></span></td>
                <td align="right"  style="width: 20%; font-size: 10pt; height: 26px; text-align: right;"
                    valign="middle">
                    DateOfBirth:&nbsp;</td>
                <td align="left"  style="width: 34%; height: 26px;" valign="middle">
                    <span style="font-size: 8pt; color: #54a0c0; font-family: Verdana">
                        <asp:TextBox ID="txtDOB" runat="server" Width="147px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtDOB" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </span></td>
                   
            </tr>
            <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">
                   Username:&nbsp;
                </td>
                <td align="left" style="width: 21%" valign="middle">
                    <asp:TextBox ID="txtusername"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="9" Width="217px"></asp:TextBox></td>
                            
                            <td align="right"  style="width: 20%; text-align: right;" valign="middle">
                                Password:&nbsp;
                </td>
                <td align="left"  style="width: 34%;" valign="middle">
                    <asp:TextBox ID="txtpassword"
                            runat="server" CssClass="inputbox2" MaxLength="10" TabIndex="10" Width="217px"></asp:TextBox></td>
                            
           </tr>
            <tr>
                <td align="right" class="ItDoseLabel" style="width: 16%; height: 34px;" valign="middle">
                    Gender:</td>
                <td align="left" style="width: 21%; height: 34px" valign="middle">
                    &nbsp;<asp:DropDownList ID="ddlgender" runat="server" Width="206px" TabIndex="3">
                        <asp:ListItem Selected="True">MALE</asp:ListItem>
                        <asp:ListItem>FEMALE</asp:ListItem>
                    </asp:DropDownList></td>
                
                
                <td align="right" style="font-size: 10pt; width: 20%; height: 34px; text-align: right"
                    valign="middle">
                   Designation:
                </td>
                <td align="left" style="width: 34%; height: 34px" valign="middle">
                    &nbsp;<asp:TextBox ID="txtdesignation" runat="server" MaxLength="70" TabIndex="4"></asp:TextBox></td>
                
            </tr>
           
             <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">
                    IsCreditLimit:&nbsp;
                </td>
                <td align="left" style="width: 21%" valign="middle">
               
<%--                    <input id="cbcredit" type="checkbox" onclick="enableTextBox();" checked="checked" />--%>
                         <asp:CheckBox ID="cbcredit" runat="server" onclick="enableTextBox();"  checked="true" TabIndex="5" />
                    </td>
                            
                            <td align="right"  style="width: 20%; text-align: right;" valign="middle">
                  phone1 :&nbsp;
                </td>
                
                <td align="left"  style="width: 34%;" valign="middle">
                    <asp:TextBox ID="txtphone1" runat="server" CssClass="inputbox2" MaxLength="10"
                        TabIndex="6" Width="217px" ></asp:TextBox></td>
                            
           </tr>
           
           
           
           
            <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">
                    CreditLimit:&nbsp;
                </td>
                <td align="left" style="width: 21%" valign="middle">
                    <asp:TextBox ID="txtcredit"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="7" Width="217px"  ></asp:TextBox></td>
                            
                            <td align="right"  style="width: 20%; text-align: right;" valign="middle">
                   phone2 :
                </td>
                <td align="left"  style="width: 34%;" valign="middle">
                    <asp:TextBox ID="txtphn2" runat="server" CssClass="inputbox2" MaxLength="10"
                        TabIndex="8" Width="217px" ></asp:TextBox></td>
                            
           </tr>
           
            <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">
                    State:&nbsp;
                </td>
                <td align="left" style="width: 21%" valign="middle">
                    <asp:TextBox ID="txtstate"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="9" Width="217px"></asp:TextBox></td>
                            
                            <td align="right"  style="width: 20%; text-align: right;" valign="middle">
                                Phone3:&nbsp;
                </td>
                <td align="left"  style="width: 34%;" valign="middle">
                    <asp:TextBox ID="txtphone3"
                            runat="server" CssClass="inputbox2" MaxLength="10" TabIndex="10" Width="217px"></asp:TextBox></td>
                            
           </tr>
           
           
           
             <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">
                   EMail :  &nbsp;
                </td>
                <td align="left" valign="middle" colspan="3">
                   <asp:TextBox ID="txtEmail" runat="server" CssClass="inputbox2" MaxLength="100"
                        TabIndex="11" Width="217px"></asp:TextBox>
                        
                        
                      <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="txtEmail" ErrorMessage="Invalid Email Format"></asp:RegularExpressionValidator>  
                                                                                               
                        </td>                         
           </tr>
          
           
             <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">
                       Residence Address :&nbsp;
                </td>
                <td align="left" style="width: 21%" valign="middle">
                    <asp:TextBox ID="txtresidenceaddress"
                            runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="12" Width="217px"></asp:TextBox></td>
                <td align="right"  style="width: 20%; text-align: right;" valign="middle">
                    Mobile :&nbsp;
                </td>
                <td align="left"  style="width: 34%;" valign="middle">
                    <asp:TextBox ID="TxtMobileNo" runat="server" CssClass="inputbox2"
                        TabIndex="13"  MaxLength="10"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="TxtMobileNo" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                    <div id="lblerr"></div>
                        
                        
                        </td>
            </tr>                    
            <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" style="width: 16%;" valign="middle" class="ItDoseLabel">
                 IsActive :&nbsp;
                </td>
                <td align="left" style="width: 21%;" valign="middle" rowspan="2">
                    <asp:CheckBox ID="cbactive" runat="server" TabIndex="14" Checked="True" /></td>             
            </tr>            
            <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" class="ItDoseLabel" style="width: 16%;" valign="middle">
                </td>
                <td align="right" style="width: 20%; text-align: right; display:none" valign="middle">
                        Department :</td>
                <td align="left" style="width: 34%; display:none" valign="middle">
                        <asp:DropDownList ID="cmbDept" runat="server" CssClass="inputcombobox" TabIndex="7"
                            Width="214px">
                        </asp:DropDownList></td>
            </tr>
            <tr style="font-size: 10pt; font-family: Verdana, Arial, sans-serif">
                <td align="right" class="ItDoseLabel" style="width: 16%" valign="middle">
                </td>
                <td align="left" colspan="3" style="text-align: center" valign="middle">
          <%--<asp:Button ID="btnSave1" runat="server" Text="Save" Width="64px" style="display:none"; onclick="btnSave1_Click"/>--%>
                    <%--<input id="btnSaveDoc" type="button" value="button" />--%>
                   <asp:Button ID="btnSaveDoc" runat="server" Text="Save" Width="100px"  OnClick ="btnSaveDoc_Click" TabIndex="15"/></td>
           
       </tr>
        </table>
        &nbsp; &nbsp;&nbsp;&nbsp;
</div>
</div>

     </form>
</body>
</html>
