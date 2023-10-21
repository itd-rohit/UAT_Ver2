<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="QualityIndicatorDelayTAT.aspx.cs" Inherits="Design_Lab_QualityIndicatorDelayTAT" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/jquery-ui.css" /> 

    </head>
    <body > <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
</Scripts>
</Ajax:ScriptManager>

              <div class="POuter_Box_Inventory">
                  <div class="row" style="text-align:center">
                      <div class="col-md-24"> <b>Rerun Report</b> <br />
                            <asp:Label ID="lbmsg" runat="server" ForeColor="Red" Font-Bold="true" /> 
                          <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                      </div>                   
                  </div>          
                  </div>

           <div class="POuter_Box_Inventory" id="div1" runat="server">
                 <div class="row">
                      <div class="col-md-4">Report Type :</div>
                      <div class="col-md-20" style=" background-color:#fff038;text-align:left"> <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem style="display:none;" Value="1" >Quality Indicator Delay TAT</asp:ListItem>
                                <asp:ListItem style="display:none;" Value="2">Quality Indicator -Sample Rejections</asp:ListItem>
                                <asp:ListItem Selected="True" Value="3">Quality Indicator - Sample Rerun</asp:ListItem>
                                
                            </asp:RadioButtonList></div>
                     </div>
               <div class="row">
                      <div class="col-md-4"> Department :</div> 
                   <div class="col-md-4"> <asp:DropDownList ID="ddlDeparment"  runat="server" class="ddlDeparment chosen-select chosen-container" >
                             </asp:DropDownList></div>
                    <div class="col-md-4" style="text-align:right">Month/Year :</div>                    
                   <div class="col-md-1">From:</div>
                       <div class="col-md-3">
                       
                             <asp:DropDownList ID="ddlfrommonth" runat="server" >
                                  <asp:ListItem Selected="True" Value="1">January</asp:ListItem>
                                  <asp:ListItem Value="2">February</asp:ListItem>
                                  <asp:ListItem Value="3">March</asp:ListItem>
                                  <asp:ListItem Value="4">April</asp:ListItem>
                                  <asp:ListItem Value="5">May</asp:ListItem>
                                  <asp:ListItem Value="6">June</asp:ListItem>
                                  <asp:ListItem Value="7">July</asp:ListItem>
                                  <asp:ListItem Value="8">August</asp:ListItem>
                                  <asp:ListItem Value="9">September </asp:ListItem>
                                  <asp:ListItem Value="10">October </asp:ListItem>
                                  <asp:ListItem Value="11">November</asp:ListItem>
                                  <asp:ListItem Value="12">December</asp:ListItem>
                                 


                             </asp:DropDownList>&nbsp;&nbsp;
                       </div>
                         <div class="col-md-1">
                            To: </div>
                       <div class="col-md-3"><asp:DropDownList ID="ddlTomonth" runat="server" >
                                  <asp:ListItem  Selected="True" Value="1">January</asp:ListItem>
                                  <asp:ListItem Value="2">February</asp:ListItem>
                                  <asp:ListItem Value="3">March</asp:ListItem>
                                  <asp:ListItem Value="4">April</asp:ListItem>
                                  <asp:ListItem Value="5">May</asp:ListItem>
                                  <asp:ListItem Value="6">June</asp:ListItem>
                                  <asp:ListItem Value="7">July</asp:ListItem>
                                  <asp:ListItem Value="8">August</asp:ListItem>
                                  <asp:ListItem Value="9">September </asp:ListItem>
                                  <asp:ListItem Value="10">October </asp:ListItem>
                                  <asp:ListItem Value="11">November</asp:ListItem>
                                  <asp:ListItem Value="12">December</asp:ListItem>
                                 


                             </asp:DropDownList>&nbsp;&nbsp;
                             </div>
                               <div class="col-md-4">
                                        <asp:DropDownList ID="ddlyear" runat="server" >
                                            <asp:ListItem Value="2017">2017</asp:ListItem>
                                            <asp:ListItem Value="2018">2018</asp:ListItem>
                                            <asp:ListItem Value="2019">2019</asp:ListItem>
                                            <asp:ListItem Value="2020">2020</asp:ListItem>
                                            <asp:ListItem Value="2021">2021</asp:ListItem>
                                            <asp:ListItem Value="2022">2022</asp:ListItem>
                                            <asp:ListItem Value="2023">2023</asp:ListItem>
                                        </asp:DropDownList>
                   </div>
                   </div>
               </div>
                <div class="POuter_Box_Inventory" id="div2" runat="server">
               <div class="row" style="font-weight: 700; text-align: center;">
<div class="col-md-24">  <input type="button" value="Get Report" class="searchbutton" onclick="summaryreport()" /></div>
               </div>          
               </div>        

  
    <script type="text/javascript">

        $(function () {
           
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

        function summaryreport() {
            if ($('#<%=ddlDeparment.ClientID%>').val() == "0") {            
                toast("Error", 'Please Select Department..!', "");
                return false;
            }
            
            if ( parseInt($('#<%=ddlfrommonth.ClientID%>').val()) >  parseInt($('#<%=ddlTomonth.ClientID%>').val())) {                
                toast("Error", 'Please Select Valid From and To Month..!', "");
                return false;
            }
           
            var Val ="".concat($('#<%=rd.ClientID%> input:checked').val(),'_', $('#<%=ddlDeparment.ClientID%>').val(), '_' , $('#<%=ddlyear.ClientID%>').val() , '_' , $('#<%=ddlfrommonth.ClientID%>').val() , '_' , $('#<%=ddlTomonth.ClientID%>').val());
            window.open("QualityIndicatorDelayTAT_Print.aspx?Val=" + Val);
        }
    </script>

</form>
</body>
</html>


