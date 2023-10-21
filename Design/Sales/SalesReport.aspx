<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SalesReport.aspx.cs" Inherits="Design_PRO_SetPROTarget" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../JavaScript/jquery-1.7.1.min.js"></script>
    <script src="../../JavaScript/jquery.extensions.js" type="text/javascript"></script>
     <script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>
      <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
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
                    if (result.d == "1") {
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

    <div id="body_box_inventory" style="width: 1200px;">
        <div class="POuter_Box_Inventory" style="width: 1200px;">
            <div class="content" style="text-align: center; width: 1200px;">
                <b>Sales Report</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" Style="display: block; height: 14px;" />
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1200px;">
            <div class="content" style="text-align: left; width: 1200px;">
                <table cellpadding="0" cellspacing="0" style="width: 99%">
                    <tr>
                        <td style="text-align: right; height: 22px;">Target Year :&nbsp;</td>
                        <td style="height: 22px">
                            <asp:DropDownList ID="ddlYear" runat="server" Width="100px">
                               
                             <%--   <asp:ListItem Value="2014-2015">2014-2015</asp:ListItem>
                                <asp:ListItem Value="2015-2016">2015-2016</asp:ListItem>
                                <asp:ListItem Value="2016-2017">2016-2017</asp:ListItem>--%>
                                <asp:ListItem Value="2017-2018">2017-2018</asp:ListItem>
                                 <asp:ListItem Value="2018-2019">2018-2019</asp:ListItem>
                               
                            </asp:DropDownList></td>
                        <td style="height: 22px"><%--To Year :--%></td>
                        <td style="height: 22px">
                         
                    </tr>
                  
                    <tr>
                        <td style="text-align: right">PRO Name :&nbsp;</td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlPanel" style='display:none;' runat="server" Width="296px"></asp:DropDownList>
							 <asp:DropDownList ID="ddlSubCatgeory"   runat="server">
                </asp:DropDownList>
							</td>
							  
                    </tr>
                  

                </table>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1200px;">
            <div class="content" style="text-align: left; width: 1200px; padding-left: 280px;">
                <input type="button" id="btnsearch" value="Export to Excel" style="font-size:14px;" onclick="Search(1)" class="button" />

                 <input type="button" id="Button1" value="Report" style="font-size:14px;" onclick="Search(2)" class="button" />
               
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1200px;">
            <div class="content" style="text-align: center; width: 1200px;">
                <div id="mydiv" style="width: 99%; height: 360px; overflow: scroll;">
                    <table id="tbtargetdata" width="75%" class="GridViewStyle" cellpadding="0" cellspacing="0"></table>
                    <%--<asp:Label ID="lblTotal" runat="server" Text="" Style="margin-left: 25%; font-size: 14px; font-weight: bold;"></asp:Label>--%>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
GetData();
        });
		function GetData() {
          
            jQuery.ajax({
                url: "SalesReport.aspx/BindSubCategory",
                data: '{}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    debugger
                    var Data = jQuery.parseJSON(result.d);
                    var DistinctDesignation = new Array();
                    var TempDesgination = '';
                    var CurrentDesgnition = '';

                    var lookup = {};
                    var items = jQuery.parseJSON(result.d);
                    var result = [];

                    for (var item, i = 0; item = items[i++];) {
                        var name = item.Designation;

                        if (!(name in lookup)) {
                            lookup[name] = 1;
                            result.push(name);
                        }
                    }
                    DistinctDesignation = result;


                    //for (var i = 0; i < Data.length; i++) {
                    //    CurrentDesgnition = Data[i].Designation;
                    //    if (CurrentDesgnition != TempDesgination) {

                    //        DistinctDesignation.push(Data[i].Designation);                            
                    //    }
                    //    TempDesgination = CurrentDesgnition;
                    //}
                    for (i = 0; i < DistinctDesignation.length; i++) {
                        var selectControl = $('#<%=ddlSubCatgeory.ClientID%>');
                        var EmployeesGRP = jQuery('<optgroup/>', {
                            label: DistinctDesignation[i]
                        }).appendTo(selectControl);
                        for (var k = 0; k < Data.length; k++) {
                            if (DistinctDesignation[i] == Data[k].Designation) {
                                $('#<%=ddlSubCatgeory.ClientID%>').append(jQuery("<option></option>").val(Data[k].Employee_Id).html(Data[k].Name));
                            }
                        }
                    }
                  
                },
                error: function (xhr, status) {
                    alert("Error ");
                    $('[id$=ddlSubSubCatgeory]').attr("disabled", false);
                }
            });
        }

        function Search(Type)
        {
            $modelBlockUI();
            debugger
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
                $.ajax({
                    url: "SalesReport.aspx/Search",
                    async: true,
                    data: JSON.stringify({ Year: Year, PanelId: Panel, PanelName: PanelName,Type:Type }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            if (Type == "1") {
                                $('[id$=lblMsg]').html();
                                window.open('../Common/ExportToExcel.aspx');
                            }
                            else {
                                window.open('../Common/Commonreport.aspx');
                            }
                        }
                        else {
                            $('[id$=lblMsg]').html("No Record Found !");
                        }
                        $modelUnBlockUI();
                    }
                });

            }


        }
    </script>
</asp:Content>

