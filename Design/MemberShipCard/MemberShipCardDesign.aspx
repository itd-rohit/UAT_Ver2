<%@ Page Language="C#"   AutoEventWireup="true" CodeFile="MemberShipCardDesign.aspx.cs" Inherits="Design_OPD_MemberShipCard_MemberShipCardDesign" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">



<html xmlns="http://www.w3.org/1999/xhtml" >
<head>

    <script src="../../JavaScript/jquery-1.3.2.min.js"></script>
    
    <title>Membership Card</title>
    <script>
        $(document).ready(function () {
            window.print();
        });

    </script>
  <style type='text/css'>

.lblAdd{
  font-size: 7px;
font-family : Eras Demi ITC;
      font-style: normal;
      
}
.lblHealthCard{
  font-size: 10px;
font-family : Eras Demi ITC;
      font-style: normal;
      
}
    .lblName{
  font-size: 12px;
  font-family : Tahoma;
  font-style: normal;
      
}       
        .lblNameMembers{
  font-size: 9px;
  font-family : Tahoma;
  font-style: normal;
      
}       
        .lblCardDiamond{
  font-size: 10.5px;
  font-family : Vivaldi;
  font-style: normal;
      
}   
                .lblCardGold{
  font-size: 14px;
  font-family : Vivaldi;
  font-style: normal;
      
}   
                        .lblCardSilver{
 font-size: 10px;
font-family : Eras Demi ITC;
      font-style: normal;
      
}   
    </style>
    </head>
<body >
   <asp:PlaceHolder runat="server" ID="phUserInfoBox" />
         
     
     
</body>
</html>



