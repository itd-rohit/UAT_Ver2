<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="DownloadConcentForm.aspx.cs" Inherits="Design_Lab_DownloadConcentForm" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align:center">
                <div class="col-md-24">
                    <b>Download Concent Form </b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; display: none;" id="divData">
            <table class="GridViewStyle" style="width: 100%;" id="tblData">
                <tr>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 40px">S.No.
                    </th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 360px">Investigations
                    </th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 200px">Concent Form
                    </th>
                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px">Download
                    </th>
                </tr>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $modelBlockUI();
            BindData();
        });
        function BindData() {
            serverCall('DownloadConcentForm.aspx/BindData', {}, function (response) {
                $responseData = JSON.parse(response);
                $('#tblData tr').slice(1).remove();
                if ($responseData.length > 0) {
                    $('#divData').show();
                    for (var i = 0; i < $responseData.length; i++) {
                        var html = '';
                        html += '<tr>';
                        html += '<td class="GridViewLabItemStyle">' + (i + 1) + '</td>';
                        html += '<td class="GridViewLabItemStyle">' + $responseData[i].Investigations + '</td>';
                        html += '<td class="GridViewLabItemStyle">' + $responseData[i].ConcernForm + '</td>';
                        html += '<td class="GridViewLabItemStyle" style="text-align:center;"> <a href="' + (location.protocol + '//' + location.host + '<%=Resources.Resource.ApplicationName%>/' + $responseData[i].FileName) + '" download><img src="../../App_Images/down_arrow.png" /></a></td>';
                        html += '</tr>';
                        $('#tblData').append(html);
                    }
               }
                else {
                    $('#divData').hide();
                    toast("Info", "No Record found", "");
                }
               
            });
            $modelUnBlockUI();
        }
    </script>
</asp:Content>
