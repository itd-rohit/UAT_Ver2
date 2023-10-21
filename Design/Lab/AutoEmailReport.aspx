<%@ Page Title="Auto Email Report" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AutoEmailReport.aspx.cs" Inherits="Design_Lab_AutoEmailReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>   
   <div class="alert fade" style="position:absolute;left:40%;border-radius:15px;z-index:11111"><%--durga msg changes--%>
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
  

        <div class="POuter_Box_Inventory" style="width: 1300px;text-align:center;">
           
                <input type="button" value="Send Auto Email" class="searchbutton" onclick="sendAutoEmailReport();" style="width: 195px;" />
           
        </div>
       
    <script type="text/javascript">
        function sendAutoEmailReport() {
            $modelBlockUI();
            $.ajax({
                url: "AutoEmailReport.aspx/sendAutoEmailReport",
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    $modelUnBlockUI();
                    emailResult = jQuery.parseJSON(result.d);
                    if (emailResult == "1") {
                        alert('Email Send........!');
                    }
                    else {
                        alert('Email Failed........!');
                    }

               },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    alert("Error ");                   
                }
            });
        }
    </script>
</asp:Content>

