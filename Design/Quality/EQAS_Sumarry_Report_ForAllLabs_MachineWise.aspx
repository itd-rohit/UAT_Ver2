<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EQAS_Sumarry_Report_ForAllLabs_MachineWise.aspx.cs" Inherits="Design_Quality_EQAS_Sumarry_Report_ForAllLabs_MachineWise" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

  
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

    
   

     <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>

     <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>

   

     
      
         
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
         </Ajax:ScriptManager> 
      <div id="Pbody_box_inventory" >
              <div class="POuter_Box_Inventory" style="text-align:center">
            
                          <b>EQAS Summary Report Machine Wise for All Lab</b>  

                            
                  </div>

           <div class="POuter_Box_Inventory">
            <div class="row">
            <div class="col-md-3 ">

			   <label class="pull-left"> Machine   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-7 ">
                            
                            <asp:DropDownList ID="ddlmachine"  CssClass="ddlmachine chosen-select chosen-container"  runat="server"></asp:DropDownList>
                          </div>
                <div class="col-md-3 " style="display:none">

			   <label class="pull-left">Processing Lab   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 " style="display:none">
                   
                             <asp:DropDownList ID="ddlcentretype" runat="server" onchange="bindcentre()" style="display:none;">
                             </asp:DropDownList>
                            

                           

                            <asp:DropDownList ID="ddlprocessinglab" style="display:none;" runat="server"></asp:DropDownList>
                       </div></div>
                     <div class="row">
            <div class="col-md-3 ">

			   <label class="pull-left"> From Date   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-2 ">
                           

                        <asp:TextBox ID="txtFromDate" runat="server"  />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                  
               </div>  <div class="col-md-1 "></div>
                           <div class="col-md-2 ">

			   <label class="pull-left">To Date  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-2 ">   
                       
                        <asp:TextBox ID="txtToDate" runat="server" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                       
                   
                           </div>
<div class="col-md-1 "></div>
                          <div class="col-md-3 ">

			   <label class="pull-left">EQAS Program Name  </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5 "> 
                  
                         <asp:DropDownList ID="ddleqasprogram"  CssClass="ddleqasprogram chosen-select chosen-container" runat="server"></asp:DropDownList>
                             </div></div>
 </div>
                    <div class="POuter_Box_Inventory" style="text-align:center">
           
                           
                        <input type="button" value="Get Report" class="searchbutton" onclick="summaryreport()" />
                            &nbsp;&nbsp;&nbsp;&nbsp;
                              <input type="button" value="Export To Excel" class="searchbutton" onclick="exporttoexcel()" />
                      
                </div>
            


          <div class="POuter_Box_Inventory" >
            
                  <div style="width:10%;overflow:auto;height:370px;" id="mydiv">

            <table id="tblItems"   frame="box"  rules="all" >

                </table>
      </div>
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




            //bindilclab();



        });

        function bindcentre() {

            var TypeId = $('#<%=ddlcentretype.ClientID%>').val();
            jQuery('#<%=ddlprocessinglab.ClientID%> option').remove();
            // jQuery('#<%=ddlprocessinglab.ClientID%>').multipleSelect("refresh");
            if (TypeId == "0") {


                return;

            }

          serverCall('EQAS_Sumarry_Report_ForAllLabs_MachineWise.aspx/bindCentre',{TypeId:TypeId},function(response){
              var $ddlprocessinglab = $('#<%=ddlprocessinglab.ClientID%>');
              $ddlprocessinglab.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'centreid', textField: 'centre' });
              $("#<%=ddlprocessinglab.ClientID%>").trigger('chosen:updated');
          });
                   
        }

      

    </script>



    <script type="text/javascript">

        function summaryreport() {

            var progrm = $('#<%=ddleqasprogram.ClientID%>').val();
            var processingcentre = $('#<%=ddlprocessinglab.ClientID%>').val();
            var dtFrom = $('#<%=txtFromDate.ClientID%>').val();
            var dtTo = $('#<%=txtToDate.ClientID%>').val();
            if ($('#<%=ddlmachine.ClientID%>').val() == "0") {
                toast("Error","Please Select Machine","");
                return;
            }
            $('#tblItems tr').remove();
          serverCall('EQAS_Sumarry_Report_ForAllLabs_MachineWise.aspx/Getsummaryreport',{processingcentre:processingcentre,dtFrom:dtFrom,dtTo:dtTo,progrm:progrm,machine:$('#<%=ddlmachine.ClientID%>').val()},function(response){
               
                    

                    if (response == "false") {
                        toast("Error","No Item Found","");
                        $('#tblItems tr').remove();
                       

                    }
                    else {

                        var data = $.parseJSON(response);
                        if (data.length > 0) {
                            var mydata = [];

                            var mydatahead = [];
                            var SlotData = $.parseJSON(response);
                            mydatahead.push('<tr id="header">');


                            var col = [];
                            mydata.push( '<tr id="header">');
                            for (var i = 0; i < SlotData.length; i++) {
                                for (var key in SlotData[i]) {
                                    if (col.indexOf(key) === -1) {
                                        if (key != "Total") {
                                            mydata.push('<th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">');
                                            mydata.push( key.replace('^', ' ').replace('^', ' '));mydata.push( '</th>');
                                        }
                                        else {
                                            mydata.push( '<th style="text-align: left;font-size:12px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;"></th>');
                                        }

                                        col.push(key);
                                    }
                                }
                            }
                            mydata.push( '</tr>');
                            mydatahead.push('<th colspan="'); mydatahead.push( col.length); mydatahead.push('" style="text-align: center;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">EQAS Summary for All Lab</th>');
                            mydatahead.push('</tr>');
                            for (var i = 0; i < SlotData.length - 4; i++) {
                                mydata .push('<tr>');
                                for (var j = 0; j < col.length; j++) {
                                    if (SlotData[i][col[j]] == null || SlotData[i][col[j]] == "null") {
                                        mydata.push(  '<td style="background-color: #fff;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;"></td>');
                                    }
                                    else {
                                        mydata.push(  '<td style="background-color: #fff;color: #000;padding: 2px;text-align: left; font-size: 12px;border:1px solid gray;">'); mydata.push(  SlotData[i][col[j]] ); mydata.push(  '</td>');
                                    }
                                }
                                mydata.push( '</tr>');
                            }

                            for (var i = SlotData.length - 4; i < SlotData.length; i++) {
                                mydata.push('<tr>');
                                for (var j = 0; j < col.length; j++) {
                                    if (SlotData[i][col[j]] == null || SlotData[i][col[j]] == "null") {
                                        mydata.push( '<th style="text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;"></th>');
                                    }
                                    else {
                                        mydata.push('<th style="text-align: left;font-size:15px;background-color: #09f;color: #fff;padding: 2px;border:1px solid gray;">'); mydata.push( SlotData[i][col[j]]); mydata.push('</th>');
                                    }
                                }
                                mydata.push( '</tr>');
                            }
                            mydatahead=mydatahead.join("");
                            mydata=mydata.join("");

                            $('#tblItems').append(mydatahead);
                            $('#tblItems').append(mydata);


                            
                        }
                    }
                


               
            });

        }


        function exporttoexcel() {
            var count = $('#tblItems tr').length;
            if (count == 0 || count == 1) {
                toast("Error","Please Select Data To Export","");
                return;
            }
            //$("#tblItems").table2excel({
            //    name: "EQASSummaryReport",
            //    filename: "EQASSummaryReport", //do not include extension
            //    exclude_inputs: false
            //});

            //window.open('data:application/vnd.ms-excel,' + $('div[id$=mydiv]').html());
            //e.preventDefault();


            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");


            sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('div[id$=mydiv]').html()));

        }

    </script>
</asp:Content>

