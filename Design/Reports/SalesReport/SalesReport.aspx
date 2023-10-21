<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="SalesReport.aspx.cs" Inherits="Design_PRO_SetPROTarget" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
     <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
<link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 

    </head>
    <body >
         <form id="form1" runat="server">
             <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager2" runat="server">
        <Services>
            <Ajax:ServiceReference Path="~/Lis.asmx" />
        </Services>
          <Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

</Scripts>
    </Ajax:ScriptManager>
    <style type="text/css">
        .button {
            background-color: #569ADA; /* Green */
            border: none;
            color: white;
            padding: 7px 16px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            border-radius: 8px;
        }

        input[type="button"]:hover {
            background-color: #3B0B0B;
        }
    </style>
     
    <script type="text/javascript">

        
        function savedata() {
            var DeleteList = new Array();
            var SaveData = new Array();
            debugger
            $('[id$=tbtargetdata]').find('tr').each(function (index) {
                if (index > 0) {
                    var DelObj = new Object();
                    var ProId = $(this).find('[id$=hdnProId]').val();
                    if (ProId != "0") {
                        DelObj.ProId = ProId;
                        DeleteList.push(DelObj);
                    }

                    var SaveDataObj = new Object();
                    var Money = $(this).find('[id$=txtTargetMoney]').val();
                    SaveDataObj.Year = $('[id$=ddlyearfrom]').val();
                    SaveDataObj.MonthId = $('[id$=ddlmonthfrom]').val();
                    SaveDataObj.MonthName = $('[id$=ddlmonthfrom] option:selected').text();
                    SaveDataObj.ProId = $('[id$=ddlproname]').val();
                    SaveDataObj.panelId = $(this).find('[id$=hdnPanelId]').val();
                    SaveDataObj.ProName = $('[id$=ddlproname] option:selected').text();
                    SaveDataObj.TargetMoney = $(this).find('[id$=txtTargetMoney]').val().trim();
                    if (Money != "")
                        SaveData.push(SaveDataObj);

                }
            });

            $.ajax({
                url: "SetPROTarget.aspx/savetargetdata",
                data: JSON.stringify({ SaveData: SaveData, DeleteList: DeleteList }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result == "1") {
                        bindtargetdata();
                        $('#<%=lblMsg.ClientID%>').html("Target Saved Sucessfully..!");
                    }
                    else {
                        $('#<%=lblMsg.ClientID%>').html("Some Error Occured !");
                    }

                },
                error: function (xhr, status) {

                }
            });
        }





    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Sales Report</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" Style="display: block; height: 14px;" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
               <div class="col-md-3"> <label class="pull-right">Target Year :</label></div>
                <div class="col-md-3"> <asp:DropDownList ID="ddlYear" runat="server" >
                                <asp:ListItem Value="2017-2018">2017-2018</asp:ListItem>
                                 <asp:ListItem Value="2018-2019">2018-2019</asp:ListItem>
                    <asp:ListItem Value="2019-2020">2019-2020</asp:ListItem>
                    <asp:ListItem Value="2020-2021">2020-2021</asp:ListItem>
                               
                            </asp:DropDownList></div>
                 <div class="col-md-3"> <label class="pull-right">Sales Manager :</label></div>
                <div class="col-md-3"><asp:DropDownList ID="ddlPanel" style='display:none;' runat="server" Width="296px"></asp:DropDownList>
							 <asp:DropDownList ID="ddlSubCatgeory"    runat="server" CssClass="ddlSubCatgeory chosen-select">
                </asp:DropDownList></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" >
            <div class="content" style="text-align:center">
                <input type="button" id="btnsearch" value="Export to Excel" style="font-size:14px;" onclick="Search(1)" class="button" />

                 <input type="button" id="Button1" value="Report" style="font-size:14px;" onclick="Search(2)" class="button" />
               
            </div>
        </div>

        <div class="POuter_Box_Inventory" >
            <div class="content" style="text-align: center; ">
                <div id="mydiv" style="width: 99%; height: 360px; overflow: scroll;">
                    <table id="tbtargetdata" width="75%" class="GridViewStyle" cellpadding="0" cellspacing="0"></table>
                    <%--<asp:Label ID="lblTotal" runat="server" Text="" Style="margin-left: 25%; font-size: 14px; font-weight: bold;"></asp:Label>--%>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
GetData();
        });
		function GetData() {
		    serverCall('SalesReport.aspx/BindSubCategory', {}, function (response) {
		        if (response != "") {
		            var Data = $.parseJSON(response);
		            var OptGRp = new Array();
		            for (var i = 0; i < Data.length; i++) {
		                if (OptGRp.indexOf(Data[i].Designation) == -1) {
		                    OptGRp[i] = Data[i].Designation;
		                    html = '<optGroup label="' + OptGRp[i] + '">';
		                    for (var j = 0; j < Data.length; j++) {
		                        if (OptGRp[i] == Data[j].Designation) {
		                            html += '<option value="' + Data[j].Employee_Id + '">' + Data[j].Name + '</option>';

		                        }
		                        html += ' </optGroup>';

		                    }
		                }
		            }
		            $('[id$=ddlSubCatgeory]').append(html);
		        }
            });
        }

        function Search(Type)
        {
           
            var Year = $('[id$=ddlYear]').val();
            var Panel = $('[id$=ddlSubCatgeory]').val();
            var PanelName = $('[id$=ddlSubCatgeory] option:selected').text();
            var ErrMsg = "";

            if(Year == "0")
            {
                ErrMsg+="Please select Target year.\n";
              
            }
            if(Panel == "0")
            {
                ErrMsg+="Please select Panel";
                
            }
           
            //$('[id$=lblMsg]').html(ErrMsg);
            if (ErrMsg.length > 0) {
                alert(ErrMsg);
                return;
            }
            else {
                serverCall('SalesReport.aspx/Search', { Year: Year, PanelId: Panel, PanelName: PanelName,Type:Type}, function (response) {
                    if (response == "1") {
                            if (Type == "1") {
                                $('[id$=lblMsg]').html();
                                window.open('../../Common/ExportToExcel.aspx');
                            }
                            else if(Type == "2") {
                                window.open('../../Common/Commonreport.aspx');
                            }
                        }
                        else {
                            $('[id$=lblMsg]').html("No Record Found !");
                        }
                });

            }
        }
    </script>
</form>
</body>
</html>

