<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportBackGound.aspx.cs" Inherits="Design_Master_ReportBackGound" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
    <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory">
            <div class="row"  style="text-align:center">
                <div class="col-md-24">
                    <b>Panel Report BackGround</b><br />
                    <asp:Label ID="lb" runat="server" Font-Bold="true" ForeColor="Red" />
                </div></div>
                 <div class="row">
                       <div class="col-md-6">
                           <strong>Current Panel :</strong></div>
                           <div class="col-md-12"><asp:DropDownList ID="ddlcentre" runat="server" ></asp:DropDownList></div>
                </div>


              </div>
         <div class="POuter_Box_Inventory">
            <div class="row">
                  <div class="col-md-12">Upload New Image :<strong>Max (1653X2339)</strong></div>
                
                <div class="col-md-12"> <asp:FileUpload ID="file" runat="server" /></div>
</div>
                 <div class="row" style="text-align:center">
                  <div class="col-md-24"> <asp:Button ID="btn" runat="server" CssClass="savebutton" Text="Upload" OnClick="btn_Click" /></div>
                     </div>
 <div class="row">
                  <div class="col-md-12">Current File Path :</div>
     <div class="col-md-12"><asp:Label ID="lblfilepath" runat="server" /></div></div>
      <div class="row">
                  <div class="col-md-12">Current File Name :</div>
         <div class="col-md-12"> <asp:Label ID="lbfilename" runat="server" /></div></div>
           <div class="row">
                  <div class="col-md-12">Current File  :</div>
               <div class="col-md-12">  <div id="MainImages">
                                  <asp:Image ID="img" runat="server"  class="myImg"  /> 
                                 </div>
                            <div id="Fullscreen">
                             <img src="" alt="" />
                                </div></div>
                
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
