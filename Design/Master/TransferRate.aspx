<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="TransferRate.aspx.cs" Inherits="Design_EDP_TransferRate" Title="Transfer Rate" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
<link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 

    </head>
    <body >
    
    <form id="form1" runat="server">


     <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

</Scripts>
</Ajax:ScriptManager>
       
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center;">
                    <b>Transfer Panel Rate List</b> <br /> <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />             
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: left;">
            <div class="row">
                <div class="col-md-4"> <strong class="pull-right">Source Panel:</strong></div>
                <div class="col-md-4"> <asp:DropDownList ID="ddlSPanel" class="ddlSPanel chosen-select" runat="server" onchange="getpaneldetail(this.value);"> </asp:DropDownList></div>
                <div class="col-md-4"> <img src="../../App_Images/TRY6_25.gif" style="height: 40px;" /></div>
                <div class="col-md-4"> <label class="pull-right">Target Panel:</label></div>
                <div class="col-md-4"><asp:DropDownList ID="ddlTPanel" runat="server" class="ddlTPanel chosen-select"  onchange="getDisc();"> </asp:DropDownList></div>
            </div>
            <div class="row"><div class="col-md-4"></div>
                <div class="col-md-20"><label id="lblrattetype" style="color:red" runat="server"></label></div>
            </div>
             <div class="row">
                <div class="col-md-4"><label class="pull-right">Filter By :</label> </div>
                 <div class="col-md-20">  <asp:RadioButtonList ID="rdolFilter" runat="server" RepeatColumns="2" onchange="SwitchFilter();">
                                <asp:ListItem Value="2" Text="Department" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Billing Category"></asp:ListItem>

                            </asp:RadioButtonList></div>                
                 </div>
             <div class="row" id="trDept">
                <div class="col-md-4"><label class="pull-right">Department:</label></div>
                 <div class="col-md-20"> <asp:DropDownList ID="ddlDepartment" class="ddlDepartment chosen-select" runat="server"  Visible="false"></asp:DropDownList>
                      <div class="POuter_Box_Inventory">
                                <div class="Purchaseheader">
                                    <asp:CheckBox ID="chkDeptAll" runat="server" Text="Select All Department" onclick="SelectAll();" />
                                </div>
                                <div id="" style="overflow: scroll; height: 180px;">
                                    <asp:CheckBoxList ID="chlDept" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" CssClass="chkCentre"></asp:CheckBoxList>
                                </div>
                            </div>

                 </div>                
                 </div>
             <div class="row" id="trBilling">
                <div class="col-md-4"><label class="pull-right">Billing Category:</label> </div>
                  <div class="col-md-4"><asp:DropDownList ID="ddlbillcategory" class="ddlbillcategory chosen-select" runat="server" onchange="Search()">
                            </asp:DropDownList></div>
                 </div>
            <div class="row">
                <div class="col-md-4"><label class="pull-right">Change Rate(%):</label></div>
                 <div class="col-md-2">   <asp:DropDownList ID="ddlCalc" class="ddlCalc chosen-select" runat="server">
                                <asp:ListItem Value="-">-</asp:ListItem>
                                <asp:ListItem Value="+">+</asp:ListItem>
                            </asp:DropDownList>
                     </div>
                     <div class="col-md-2">
                            <asp:TextBox ID="txtRate" runat="server" onkeyup="validatePer()" ClientIDMode="Static" AutoCompleteType="Disabled">0</asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbRate" runat="server" TargetControlID="txtRate" FilterType="Numbers"></cc1:FilteredTextBoxExtender></div>
                

            </div>
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-20"> <asp:RadioButtonList ID="rdoType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="All" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Zero Rate Only" Value="0"></asp:ListItem>
                            </asp:RadioButtonList></div>               
            </div>
               <div class="row" style="display: none;">
                <div class="col-md-12">Group:  <asp:DropDownList ID="ddlSGroup" runat="server" class="ddlSGroup chosen-select" AutoPostBack="True" OnSelectedIndexChanged="ddlSGroup_SelectedIndexChanged"
                                Width="164px">
                            </asp:DropDownList> </div>               
                   <div class="col-md-12">Group: <asp:DropDownList ID="ddlTGroup" runat="server" class="ddlTGroup chosen-select" AutoPostBack="True" OnSelectedIndexChanged="ddlTGroup_SelectedIndexChanged"
                                Width="240px">
                            </asp:DropDownList> </div>               
            </div>
            <div class="row" style="vertical-align: middle; text-align: left">              
                <div class="col-md-24" style="text-align: center;">
                    <asp:Button ID="btnRate" runat="server" class="searchbutton" Text="Transfer Rates" OnClick="btnRate_Click" OnClientClick="return validateRate()" />
                </div>
            </div>
        </div>
         
    <script type="text/javascript">

        $(document).ready(function () {
            $(function () {
                $('#divMasterNav').hide();

                var config = {
                    '.chosen-select': {},
                    '.chosen-select-deselect': { allow_single_deselect: true },
                    '.chosen-select-no-single': { disable_search_threshold: 10 },
                    '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                    '.chosen-select-width': { width: "95%" }
                }
                for (var selector in config) {
                    $(selector).chosen(config[selector]);
                }
            });
        });
        function getpaneldetail(panelid) {
            serverCall('TransferRate.aspx/getpaneldetail', { PanelID: panelid }, function (response) {
                $('#lblrattetype').html('RateType:- ' + response);
            });
        }
    </script>
    <script type="text/javascript">
        function validatePer() {
            if ($.trim($("#txtRate").val()) > 100) {
                $("#lblMsg").text('Please Enter valid Change Rate(%)');
                $("#txtRate").val('');
                $("#txtRate").focus();
                return;
            }
        }
        function validateRate() {
            if ($.trim($("#txtRate").val()) == "") {
                $("#lblMsg").text('Please Enter valid Change Rate(%)');
                $("#txtRate").val('');
                $("#txtRate").focus();
                return false;
            }
            var Ok = confirm('Are you sure to Transfer Rate?');
            if (Ok) {
                document.getElementById('<%=btnRate.ClientID%>').disabled = true;
                document.getElementById('<%=btnRate.ClientID%>').value = 'Submitting...';
                __doPostBack('btnRate', '');
            }
            else {
                document.getElementById('<%=btnRate.ClientID%>').disabled = false;
                document.getElementById('<%=btnRate.ClientID%>').value = 'Transfer Rates';
                return false;
            }
        }
        function SelectAll() {
            var chkBoxList = document.getElementById('<%=chlDept.ClientID %>');
            var chkBoxCount = chkBoxList.getElementsByTagName("input");
            for (var i = 0; i < chkBoxCount.length; i++) {
                chkBoxCount[i].checked = document.getElementById('<%=chkDeptAll.ClientID %>').checked;
                 }
             }
             function getDisc() {
                 if ($("#<%=rdoType.ClientID%>").find(":checked").val() == "1") {
                return;
            }
            $('#<%=txtRate.ClientID%>').val('');
            PageMethods.getDisc($('#<%=ddlTPanel.ClientID%>').val(), onSuccessgetDisc, OnfailuregetDisc);
        }
        function onSuccessgetDisc(result) {
            $('#<%=txtRate.ClientID%>').val(result);
        }
        function OnfailuregetDisc() {
            $('#<%=txtRate.ClientID%>').val('');
        }

        function SwitchFilter() {
            var opt = $('[id$=rdolFilter] input:checked').val();
            if (opt == "1") {
                $('#trDept').hide();
                $('#trBilling').show();
                $('#ContentPlaceHolder1_ddlbillcategory_chosen').css('width', '240px');
            }
            else if (opt == "2") {
                $('#trDept').show();
                $('#trBilling').hide();
            }
        }
    </script>
</form>
</body>
</html>

