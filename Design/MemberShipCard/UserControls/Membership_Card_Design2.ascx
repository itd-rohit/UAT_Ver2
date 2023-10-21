<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Membership_Card_Design2.ascx.cs" Inherits="Design_OPD_MemberShipCard_Membership_Card_Design2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">



<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    

        
    <title>Membership Card</title>
 
    </head>
<body >
    <form id="form1" style="width:700px">
     

     <div id="CardFront" style="width:8.75cm; height:5.7cm; float:left; border: medium solid #FF9966; border-collapse: collapse">
         <table  style="width:8.75cm; height:5.7cm"  >
            <tr><td colspan="2" align="center" style="" >
                <asp:Image ID="imgFront" runat="server" Width="250px" Height="50px" />
                </td></tr>
            
              <tr><td align="center">
                  <asp:Image ID="imgBarcode" runat="server" Height="20px" Width="200px" />
                  </td><td align="left" valign="bottom" rowspan="2" width="200" >
                      <br />
                      <asp:Image ID="imgPatient" runat="server" Height="3.2cm" Width="2.8cm"  />
                  </td></tr>
            
             <tr><td valign="middle">
                 <table>
                     <tr><td></td><td></td><td><asp:Label ID="lblCardNo" runat="server"  CssClass="lblName" ></asp:Label></td></tr> <tr></tr>                    
                     <tr><td></td><td></td><td><asp:Label ID="lblName" runat="server" CssClass="lblName" ></asp:Label></td></tr><tr></tr>
                     <tr><td></td><td></td><td><asp:Label ID="lblDiscount" runat="server" CssClass="lblName"></asp:Label></td></tr>
                     <tr><td></td><td></td><td><asp:Label ID="lblValidUpto" runat="server" CssClass="lblName"></asp:Label></td></tr>
                     <tr><td></td><td></td><td><asp:Label ID="lblValidity" runat="server" CssClass="lblName" ></asp:Label></td></tr><tr></tr>
                 </table>              
                 </td></tr>
                          
         </table>
     </div>
       
  <div id="Cardback" style="width:8.75cm; height:5.7cm; float:left; border: medium solid #FF9966; border-collapse: collapse;"">
           <table  style="width:8.75cm; height:4cm" >
                 <tr><td valign="top" align="left" height="35px">

                     <table>
                         <tr>
                    <td align="center" valign="middle" style="width:75px"><asp:Image ID="imgMember1" runat="server" Height="46px" Width="38px"   /></td>
                              <td align="center" valign="middle" style="width:75px"><asp:Image ID="imgMember2" runat="server" Height="46px" Width="38px"  /></td>
                              <td align="center" valign="middle" style="width:75px"><asp:Image ID="imgMember3" runat="server" Height="46px" Width="38px"   /></td>
                              <td align="center" valign="middle" style="width:75px"> <asp:Image ID="imgMember4" runat="server" Height="46px" Width="38px"  /></td>
                              <td align="center" valign="middle" style="width:75px"> <asp:Image ID="imgMember5" runat="server" Height="46px" Width="38px"   /></td>
                              <td align="center" valign="middle" style="width:75px"> <asp:Image ID="imgMember6" runat="server" Height="46px" Width="38px" /></td>
                         </tr>
                        
                     </table>                 
                                                 
                      </td></tr>
                    <tr><td align="left" valign="top" height="25px">
                     <table>
                         <tr>
                             <td></td>
                             <td></td>
                             <td align="left"><asp:Label ID="lblRelation1" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                            <td align="left"><asp:Label ID="lblName1" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                         </tr>
                         <tr>
                             <td></td>
                             <td></td>
                             <td align="left"><asp:Label ID="lblRelation2" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                        <td align="left"><asp:Label ID="lblName2" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                         </tr>
                         <tr>
                             <td></td>
                             <td></td>
                             <td align="left"><asp:Label ID="lblRelation3" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                        <td align="left"><asp:Label ID="lblName3" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                         </tr>
                         <tr>
                             <td></td>
                             <td></td>
                             <td align="left"><asp:Label ID="lblRelation4" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                        <td align="left"><asp:Label ID="lblName4" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                         </tr>
                         <tr>
                             <td></td>
                             <td></td>
                             <td align="left"><asp:Label ID="lblRelation5" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                          <td align="left"><asp:Label ID="lblName5" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                         </tr>
                         <tr>
                             <td></td>
                             <td></td>
                             <td align="left"><asp:Label ID="lblRelation6" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                       <td align="left"><asp:Label ID="lblName6" runat="server" CssClass="lblNameMembers"></asp:Label></td>
                         </tr>
                     </table>                   
                     </td></tr>
               
              
             </table>
      <br />
     
      <table style="vertical-align:bottom" >
          <tr>
              <td style="vertical-align:bottom;font-size: 3px" >
 <asp:Label ID="lblAdd1" CssClass="lblAdd" runat="server"  ForeColor="Red" Text="   GGN CITY      -  "  ></asp:Label>
                  <asp:Label ID="lblAdd11" CssClass="lblAdd" runat="server" ForeColor="#3399FF" Text="   462/7, Jawahar Nagar, New Railway Road,Gurgaon  122001  Ph: 0214 - 6712000 " ></asp:Label>
              </td>
              
          </tr>
          <tr>
              <td style="vertical-align:bottom;font-size: 3px" >
<asp:Label ID="lblAdd2" CssClass="lblAdd" runat="server"  ForeColor="Red" Text="   SEC. 44 GGN -  " ></asp:Label>
                 <asp:Label ID="lblAdd22" CssClass="lblAdd" runat="server" ForeColor="#6699FF" Text="   Plot No. #8 , Institutional Area , Sector 44 , Gurgaon   122002 Ph: 0124 - 6713000" ></asp:Label> 
              </td>
              
          </tr>
        
              <tr>
                  
              <td  align="center" style="vertical-align:top;font-size: 3px" >
                 
       <asp:Label ID="lblWebsite" runat="server"  ForeColor="Red" Text="www.mdrcindia.com" CssClass="lblAdd" ></asp:Label>  
                  <asp:Label ID="Label3" runat="server"  ForeColor="Red" Text="   |   " CssClass="lblAdd" ></asp:Label>
                  <asp:Label ID="lblEmailId" runat="server"  ForeColor="Red" Text="info@mdrcindia.com" CssClass="lblAdd" ></asp:Label>
            
                       </td>
              
          </tr>
         
          
      </table>
      </div>
     </form>
</body>
</html>


