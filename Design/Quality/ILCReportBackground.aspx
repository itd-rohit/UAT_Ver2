<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ILCReportBackground.aspx.cs" Inherits="Design_Quality_ILCReportBackground" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
       <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <title></title>
    <style type="text/css">
            #MainImages {
                width: 200px;
                height: 200px;
             }
                 #MainImages img {
                     cursor: pointer;
                     height: 90%;
                 }
            #Fullscreen {
                 width: 100%;
                 display: none;
                 position:fixed;
                 top:0;
                 right:0;
                 bottom:0;
                 left:0;
                
                 background-color:pink;
             }
             #Fullscreen img {
                display: block;
                height: 100%;
                  width: 600px;
                margin: 0 auto;
             }
        </style>

    <script type="text/javascript">
        $(document).ready(function () {
            //your code for stuff should go here
            //  $('#Fullscreen').css('height', $(document).outerWidth() + 'px');
            //for when you click on an image
            $('.myImg').click(function () {
                var src = $(this).attr('src'); //get the source attribute of the clicked image
                $('#Fullscreen img').attr('src', src); //assign it to the tag for your fullscreen div
                $('#Fullscreen').fadeIn();
            });
            $('#Fullscreen').click(function () {
                $(this).fadeOut(); //this will hide the fullscreen div if you click away from the image. 
            });
        });
    </script>
</head>
<body>
    
     <%: Scripts.Render("~/bundles/WebFormsJs") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <form id="form1" runat="server">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width:904px;">
    <div class="POuter_Box_Inventory" style="width:900px;">
            <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>ILC/EQAS Report BackGround</b>  
                            <br />
                            <strong>Current Centre :</strong>&nbsp;&nbsp; <asp:DropDownList ID="ddlcentre" runat="server" ></asp:DropDownList>

                            
                            <br />
                           <asp:Label ID="lb" runat="server" Font-Bold="true" ForeColor="Red" />

                            
                        </td>
                    </tr>
                    </table>
                </div>


              </div>
         <div class="POuter_Box_Inventory" style="width:900px;">
            <div class="content">
                <table width="100%">
                    <tr>
                        <td> Upload New Image :<strong>Max (1653X2339)</strong></td>
                        <td>
                            <asp:FileUpload ID="file" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center"> <asp:Button ID="btn" runat="server" CssClass="savebutton" Text="Upload" OnClick="btn_Click" /></td>
                    </tr>
                    <tr>
                        <td> Current File Path :</td>
                        <td><asp:Label ID="lblfilepath" runat="server" /></td>
                    </tr>
                    <tr>
                        <td> Current File Name :</td>
                        <td><asp:Label ID="lbfilename" runat="server" /></td>
                    </tr>
                    <tr>
                        <td> Current File  :</td>
                        <td>
                            <div id="MainImages">
                                  <asp:Image ID="img" runat="server"  class="myImg"  /> 
                                 </div>
                            <div id="Fullscreen">
                             <img src="" alt="" />
                                </div>
                        </td>
                    </tr>
                </table>

                
                </div>
             </div>
    </div>
    </form>

      <script type="text/javascript">
          $(document).ready(function () {
              //your code for stuff should go here
              //  $('#Fullscreen').css('height', $(document).outerWidth() + 'px');
              //for when you click on an image
              $('.myImg').click(function () {
                  var src = $(this).attr('src'); //get the source attribute of the clicked image
                  $('#Fullscreen img').attr('src', src); //assign it to the tag for your fullscreen div
                  $('#Fullscreen').fadeIn();
              });
              $('#Fullscreen').click(function () {
                  $(this).fadeOut(); //this will hide the fullscreen div if you click away from the image. 
              });
          });
    </script>
</body>
</html>
