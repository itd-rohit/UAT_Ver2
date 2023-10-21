<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowInvComment.aspx.cs" Inherits="Design_Lab_ShowInvComment" %>

<!DOCTYPE html>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />

    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <Ajax:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading
                        <img src="../../App_Images/Progress.gif" alt="" /></span>
                </div>
            </ProgressTemplate>
        </Ajax:UpdateProgress>
        <Ajax:UpdatePanel ID="mm" runat="server">
            <ContentTemplate>
                <div id="Pbody_box_inventory" style="width: 1106px; vertical-align: top;margin:-0px">
                    <div class="POuter_Box_Inventory" style="width: 1100px;">
                        <div class="row">
                            <div class="col-md-24">
                                <strong>
                                    <center> <asp:Label ID="lb" runat="server" Font-Bold="true" Text="Investigation Comment"></asp:Label> </center>
                                </strong>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <strong>
                                    <center>
           
                  <asp:Label ID="Label1" runat="server" Font-Bold="true" ForeColor="Red"></asp:Label></center>
                                </strong>
                            </div>
                        </div>
                    </div>
                    <div class="POuter_Box_Inventory" style="width: 1100px;">

                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Comment  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-21">
                                <asp:DropDownList ID="ddl" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddl_SelectedIndexChanged" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24 col-xs-24">
                                <CKEditor:CKEditorControl ID="CKEditorControl1" BasePath="~/ckeditor" runat="server" Height="300" Width="1090"></CKEditor:CKEditorControl>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24 col-xs-24" style="text-align: center">
                                <asp:Button ID="btn" runat="server" Text="Save Comment" OnClick="btn_Click" Font-Bold="true" Style="cursor: pointer;" />
                            </div>
                        </div>
                    </div>
            </ContentTemplate>


        </Ajax:UpdatePanel>
    </form>
</body>
</html>
