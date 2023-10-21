<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="TATPendingDashBoard.aspx.cs" Inherits="Design_DashBoard_TATPendingDashBoard" %>

<%--<!DOCTYPE html>--%>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>


    <form id="form1" runat="server">
        
         <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div> 
          <Ajax:ScriptManager ID="sm1" runat="server" EnablePageMethods="true">
          
         </Ajax:ScriptManager>
        <%--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
           
       

          <script src="../../Scripts/jquery-3.1.1.min.js" type="text/javascript"></script>
         <script src="js/all.min.js" type="text/javascript"></script>
        <script src="../../Scripts/Common.js"></script>

        <link href="../Mobile/bootstrap/css/bootstrap.min.css" rel="stylesheet" />

        <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
        <link href="css/style.css" rel="stylesheet" type="text/css">
        <link href="css/css.css" rel="stylesheet" type="text/css">
        <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
        <%: Scripts.Render("~/bundles/WebFormsJs") %>
       <%: Scripts.Render("~/bundles/Chosen") %>
         <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>

        <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
  --%> 
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
           
          <script src="../../Scripts/jquery-3.1.1.min.js" type="text/javascript"></script>
         <script src="js/all.min.js" type="text/javascript"></script>
        <script src="../../Scripts/Common.js"></script>
        
        <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
        <link href="css/style.css" rel="stylesheet" type="text/css">
        <link href="css/css.css" rel="stylesheet" type="text/css">
        <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
      
       <%: Scripts.Render("~/bundles/Chosen") %>
        <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>    
        <script src="../../Scripts/jquery.blockUI.js"></script>
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
                 $('.chosen-container').css('width', '230px');
             });


   </script>
        <script src="https://canvasjs.com/assets/script/jquery.canvasjs.min.js"></script>
        <style>
            body {
                background-color: #EEEEEE;
            }

            .MyDiv {
                top: -19%;
                height: 70px;
                width: 70px;
                text-align: center;
                left: 15px;
                position: absolute;
                color: #fff;
                font-size: 35px;
                padding-top: 12px;
                box-shadow: 1px 2px 9px #000;
            }

            .MyContentDiv {
                background-color: #fff;
                padding: 15px;
                box-shadow: 5px 5px 5px #ccc;
                height: 90px;
                text-align: right;
            }
            
            .MyContentDiv1 {
                background-color: #fff;
                padding: 15px;
                box-shadow: 5px 5px 5px #ccc;
                height: 200px;
                text-align: right;
            }
            .Mytext {
                margin-left: 30px;
                font-size: 16px;
            }

            .MytextData {
                font-size: 16px;
                opacity: 0.9;
            }

             .MytextData_red {
                font-size: 16px;
                opacity: 0.9;
                color:red;
                font-weight:bold;
            }
             .MytextData_green {
                font-size: 16px;
                opacity: 0.9;
                color:green;
                font-weight:bold;
            }
             .MytextData_black {
                font-size: 16px;
                opacity: 0.9;
                color:black;
            }

            .toSpace {
                margin-top: 20px;
            }

            html, body {
                height: 100%;
                font-family: 'Roboto', sans-serif;
                font-weight: 400;
                background: #eeeeee !important;
            }

            .MyContentDivNew {
                background-color: #fff;
                padding: 15px;
                box-shadow: 5px 5px 5px #ccc;
                height: 126px;
                text-align: right;
            }

            .ms-parent .multiselect-container {
                width: 200px;
            }

            .mid-width.wrapItems .multiselect-container > li > a {
                white-space: normal;
            }
        </style>
       <style>
           .banner{
  text-align: center;
  max-width: 100vw;
  margin: 0 0 3rem;
  padding: 1rem,0;
  max-height: 40px;
}

marquee{
  padding: 10px;
  color: orangered;
  text-transform: uppercase;
  font-size: 20px;
  font-family: 'Anton', sans-serif;
}


       </style>
        <div class="container-fluid">
           
 <nav class="navbar navbar-fixed-top" style="background-color:#fff">
  <div class="container-fluid">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="#"></a>
    </div>
    <div>
      <div class="collapse navbar-collapse" id="myNavbar">
        <ul class="nav navbar-nav" style="font-size:18px">
          <li><a href="#section1"><i class="fa fa-address-book"></i>&nbsp;&nbsp;All Data Count</a></li>
          <li><a href="#section2"><i class="fa fa-chart-pie"></i>&nbsp;&nbsp;Pie Chart</a></li>
         <%-- <li><a href="#section3"><i class="fa fa-chart-bar"></i>&nbsp;&nbsp;Sample Graph</a></li>--%>
<%--           <li><a href="#section4"><i class="fa fa-digital-tachograph" style="display:none;"></i>&nbsp;&nbsp;Machine Breakdown</a></li>--%>
             <li><a href="#section5"><i class="fa fa-user-md"></i>&nbsp;&nbsp;Pending List</a></li>
              <li><a href="TATPendingNew.aspx"><i class="fa fa-clock" ></i>&nbsp;&nbsp;TAT Pending List</a></li>
          
        </ul>
      </div>
    </div>
  </div>
</nav>    

              <div class="row" style="margin-top: 100px;margin-left:50px;">
                  <img src="<%=Request.Url.Scheme %>://<%=Request.Url.Host %>:<%=Request.Url.Port %>/<%=Request.Url.AbsolutePath.Split('/')[1] %>/App_Images/homebtnn.png" onclick="gotohome()" alt="" style="cursor: pointer;" title="Back To Home" />

                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                  <img src="<%=Request.Url.Scheme %>://<%=Request.Url.Host %>:<%=Request.Url.Port %>/<%=Request.Url.AbsolutePath.Split('/')[1] %>/App_Images/excelexport.gif" onclick="excelreport()" alt="" style="cursor: pointer;" title="Download Excel" />


                   &nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;  &nbsp;&nbsp;&nbsp;
                  <b> Centre :</b> <asp:ListBox ID="lstCentre" CssClass="multiselect" SelectionMode="Multiple" Width="300px" runat="server" ClientIDMode="Static"></asp:ListBox>
     
                 <b> Date :</b>
                  <asp:TextBox id="txtdate" runat="server" Width="100" ReadOnly="true" />
                   <cc1:CalendarExtender ID="FromdateCal" TargetControlID="txtdate" PopupButtonID="txtdate" Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                  &nbsp;&nbsp;
                  <input type="button" style="cursor:pointer;font-weight:bold;background-color: blue;color: white" value="Search" onclick="bindTotalCount()" />

                  

                  </div>
            <section class="banner" id="banner">
              <div class="marquee-container">
                <marquee behavior="scroll" direction="left" scrollamount="8" loop="infinite"><span style="color: #F04524;">&#9728;</span>Repeated Test is greater than 2%.</marquee>
              </div>
            </section>


            <div id="section1" class="container-fluid">

            <div class="row" style="margin-top: 30px;">
                <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid orange">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #FEA01C 31%, #FC9208 69%);">
                           <i class="fas fa-vials"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-primary text-uppercase">
                            <span  onclick="totalcount1()" >RegTestCount</span> 
                            <span class="MytextData timer count-title count-number" id="Spantotalpatientcount">0</span>
                             <br />
                            Total Tests
                                <br />
                            <span class="MytextData timer count-title count-number" id="spTotalSample">0</span>
                        </div>
                    </div>

                </div>

                <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #5AB25E">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #5AB25E 31%, #54AD58 69%);">
                            <i class="fas fa-edit"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-success text-uppercase">
                            <span  onclick="totalcount2()">Amendment Report</span>
                                <br />
                            <span class="MytextData_red" >Count:<span id="spAmendmentSample">0</span></span><br />
                             <i class="fa fa-bell amndreport" style="color: red;font-size:24px"></i><span class="MytextData_green" >Per:<span id="spAmendmentSample_Per">0</span></span>
                        </div>
                    </div>

                </div>

                <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #23C4D8">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #23C4D8 31%, #0FB6CB 69%);">
                           <i class="fas fa-sync-alt"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-info text-uppercase">
                         <span  onclick="totalcount3()"  >Repeated Tests</span>
                             
                                <br />
                               <span class="MytextData_red" >Count:<span id="spRepeatedSample">0</span></span><br />
                             <i class="fa fa-bell repeatreport" style="color: red;font-size:24px"></i> <span class="MytextData_green" >Per:<span id="spRepeatedSample_Per">0</span></span>
                           
                        </div>
                    </div>

                </div>

                <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #EC4B48">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #EC4B48 31%, #E8413D 69%);">
                            <i class="fas fa-times-circle"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-warning text-uppercase">
                           <span  onclick="totalcount4()" >Rejected Tests Reg.</span>
    
                                <br />
                             <span class="MytextData_red" >Count:<span id="spRejectedSample">0</span></span><br />
                             <span class="MytextData_green" >Per:<span id="spRejectedSample_Per">0</span></span>
                           
                        </div>
                    </div>

                </div>
            </div>



            <div class="row" style="margin-top: 30px;">
                <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv"  style="border: 1px solid #fb1cfe">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #fb1cfe 31%, #f808fc 69%);">
                            <i class="fa fa-exclamation-triangle"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-primary text-uppercase">
                          <span  onclick="totalcount5()">Abnormal Test</span>     
                                <br />
                            <span class="MytextData_red" >Count:<span id="spAbnormalSample">0</span></span><br />
                             <span class="MytextData_green" >Per:<span id="spAbnormalSample_Per">0</span></span>
                            
                        </div>
                    </div>

                </div>

                <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #1223f5">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #1223f5 31%, #0d13e4 69%);">
                            <i class="fa fa-bell"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-success text-uppercase">
                           <span  onclick="totalcount6()" >Critical Report</span>    
                         
                                <br />
                             <span class="MytextData_red" >Count:<span id="spCriticalSample">0</span></span><br />
                             <span class="MytextData_green" >Per:<span id="spCriticalSample_Per">0</span></span>
                           
                        </div>
                    </div>

                </div>

               <%-- <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #d3ea18">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #d3ea18 31%, #d3e006 69%);">
                         <i class="fa fa-font"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-info text-uppercase">
                           Auto validate Report
                                <br />
                             <span class="MytextData_red" >Count:<span id="spAutoApprovedSample">0</span></span><br />
                             <span class="MytextData_green" >Per:<span id="spAutoApprovedSample_Per">0</span></span>
                           
                        </div>
                    </div>

                </div>--%>

                <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #FEA01C">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #FEA01C 31%, #FC9208 69%);">
                            <i class="fa fa-ambulance"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-success text-uppercase">
                         <span  onclick="totalcount7()"  >OutSource Test </span>    
                           
                                <br />
                             <span class="MytextData_red" >Count:<span id="spOutsourceTest">0</span></span><br />
                             <span class="MytextData_green" >Per:<span id="spOutsourceTest_Per">0</span></span>
                            
                        </div>
                    </div>

                </div>

                <%--<div class="col-md-3" style="position: relative;display:none">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #bc23d8">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #bc23d8 31%, #a50fcb 69%);">
                            <i class="fas fa-hourglass-half"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-warning text-uppercase" >
                           <%--SRA TO APPROVE(< 6HR)
                            Sample Recived in  Deptwise
                                 <br />
                             <span class="MytextData_red" >Count:<span id="spTAT">0</span></span><br />
                             <span class="MytextData_green" >Per:<span id="spTAT_Per">0</span></span>
                            
                        </div>
                    </div>

                </div>--%>
                <div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #bc23d8">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #bc23d8 31%, #a50fcb 69%);">
                            <i class="fa fa-hospital"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-warning text-uppercase" >
                      <span  onclick="totalcount8()"  >Inhouse Test</span>    
                         
                                 <br />
                           <span class="MytextData_red" >Count:<span id="spInhousetest">0</span></span>
                        </div>
                    </div>

                </div>
            </div>
            <div class="row" style="margin-top: 30px;">

                  <%--<div class="col-md-3" style="position: relative; display:none">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #a50fcb">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #d3ea18 31%, #d3e006 69%);">
                            <i class="fas fa-hourglass-half"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-warning text-uppercase" >
                           Sra Count Patient
                                 <br />
                            <span class="MytextData_red" >Count: <a href="#"><span id="spTATPracessingthree" onclick="return ViewSraReport();">0</span></a></span><br />
                               <i class="fa fa-bell sraapprove" style="color: red;font-size:24px" onclick="return ViewSraReport();"></i><span class="MytextData_green" >Per:
                             <a href="../Lab/TATReport.aspx" target="_blank" > <span class="MytextData" id="spTATPracessingthree_Per">0</span></a>
                             </span>
                           
                        </div>
                    </div>

                </div>--%>

                 

               
                  <%--<div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #1223f5">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #1223f5 31%, #0d13e4 69%);">
                            <i class="fas fa-hourglass-half"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-success text-uppercase" style="font-size:14px">
                            Booking to Appr.(<6Hrs)
                                <br />
                            <span class="MytextData_red" >Count:<span id="spRegSra6Hr">0</span></span><br />
                              <i class="fa fa-bell Bookintoapprove" style="color: red;font-size:24px"></i><span class="MytextData_green" >Per:<span id="spRegSra6Hr_Per">0</span></span>
                            
                        </div>
                    </div>

                </div>--%>
                

              <%--<div class="col-md-3" style="position: relative;">
                    <div class="col-md-12 MyContentDiv" style="border: 1px solid #23C4D8">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #23C4D8 31%, #0FB6CB 69%);">
                            <i class="fa fa-ticket-alt"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-warning text-uppercase" >
                         Ticket Raised
                                 <br />
                           <a href="#" onclick="return ViewTicket();"> <span class="MytextData" id="spTicketraised">0</span></a>
                        </div>
                    </div>

                </div>--%>
                
   
                      <div class="col-md-3" style="position: relative;">
					  <div class="col-md-12 MyContentDiv" style="border: 1px solid #bc23d8">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #23C4D8 31%, #0FB6CB 69%);">
                            <i class="far fa-pause-circle"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-success text-uppercase" style="font-size:14px">
                          <span  onclick="totalcount9()" >Onhold Test</span>    
                       
                                <br />
                            <span class="MytextData_red" >Count:<span id="spOnholdCount">0</span></span><br />
                            <span class="MytextData_green" >Per:<span id="spOnholdPer">0</span></span>
                            
                        </div>
						</div>
                    </div>
                <div class="col-md-3" style="position: relative;">
                      <div class="col-md-12 MyContentDiv" style="border: 1px solid #bc23d8">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #23C4D8 31%, #0FB6CB 69%);">
                            <i class="far fa-pause-circle"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-success text-uppercase" style="font-size:14px">
                           <span  onclick="totalcount10()"  >Reg Patient</span>    
                        
                                <br />
                            <span class="MytextData_red" >Count:<span id="spOnRegCount">0</span></span><br />
                          <!--  <span class="MytextData_green" >Per:<span id="spOnRegPer">0</span></span> -->
                            
                        </div>
						 </div>
                    </div>
                     <div class="col-md-3" style="position: relative;">
                      <div class="col-md-12 MyContentDiv" style="border: 1px solid #bc23d8">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #23C4D8 31%, #0FB6CB 69%);">
                            <i class="far fa-pause-circle"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-success text-uppercase" style="font-size:14px">
                          <span  onclick="totalcount11()" >NET SALE</span>    
                          
                                <br />
                            <span class="MytextData_red"> AMOUNT:<span id="spOnNetSale">0</span></span><br />
                          <!--  <span class="MytextData_green" >Per:<span id="spOnRegPer">0</span></span> -->
                            
                        </div>
						 </div>
                    </div>
 <div class="col-md-3" style="position: relative;">
                      <div class="col-md-12 MyContentDiv" style="border: 1px solid #bc23d8">
                        <div class="MyDiv" style="background: linear-gradient(90deg, #23C4D8 31%, #0FB6CB 69%);">
                            <i class="far fa-pause-circle"></i>
                        </div>
                        <div class="Mytext text-xs font-weight-bold text-success text-uppercase" style="font-size:14px">
                               <span  onclick="totalcount12()" >DiscountedTest</span>    
                           
                                <br />
                            <span class="MytextData_red" >Count:<span id="Discounttest">0</span></span><br />
                          <!--  <span class="MytextData_green" >Per:<span id="spOnRegPer">0</span></span> -->
                            
                        </div>
						 </div>
                    </div>
                  

               
            </div>
          
           <div class="row" style="margin-top: 30px;">
                  
               
                  
					 
                  </div>
            <div class="row" style="margin-top: 30px;display:none">
               <input type="text" id="search" placeholder="live search" style="float:right;border:2px solid #FFBA01;width:300px" />
            </div>
              <div class="row">
                 

                <div class="col-md-24">
                    <div class="white-box">
                        <table class="table table-striped" id="tblDepartment">
                            <thead>
                                <tr>
                                    <th>CENTRE</th>
                                    <th>TOTAL TESTS</th>
                                    <th>AMENDMENT REPORT</th>
                                    <th>REPEATED TESTS</th>
                                    <th>REJECTED TESTS Reg.</th>
                                    <th>ABNORMAL TEST</th>
                                    <th>CRITICAL REPORT</th>
                                    <th>AUTO VALIDATE REPORT</th>
                                    <th>SRA TO APPROVE (Within 3Hr)</th>
                                    <th>SRA TO APPROVE (Morethan 3Hr)</th>
                                    
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>


        </div>
                </div>
            <div id="section2" class="container-fluid">

            <div class="row" style="margin-top: 30px;">
                <div class="col-md-24">
                    <div class="white-box">
                        <h2 style="color:lawngreen;font-family:serif"><b>Graph based on the above Parameters.</b></h2>
                        <input type="radio" id="rdDaily" name="graphBtn" value="dailyData" onclick="bindDataWklyMonthly()" />
                          <label for="html">Daily</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         <input type="radio" id="rdWeekly" name="graphBtn" value="weeklyData" onclick="bindDataWklyMonthly()" />
                          <label for="html">Weekly</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <input type="radio" id="rdMonthly" name="graphBtn" value="monthlyData"  onclick="bindDataWklyMonthly()" />
                          <label for="css">Monthly</label>
                   </div>
                </div>
            </div>
            <div class="row" style="margin-top: 2px;">
               <div>
                   <div class="col-sm-6">
                       <label>Sample Count</label>
                   </div>
                   <div class="col-sm-6">
                       <label>Sample Percentage</label>
                       
                   </div>
               </div>
                <div class="col-md-12">
                    <div class="col-sm-6">
                        <div id="PiechartContainer1" style="height: 400px; width: 100%;"></div>
                    </div>
                    <div class="col-sm-6">
                        <div id="PiechartContainer2" style="height: 400px; width: 100%;"></div>
                    </div>
               
                    
               </div> 
           </div>
                  <div class="row" style="margin-top: 30px;">
                <div class="col-md-24">
                    <div class="white-box">
                        
                         <fieldset>
                        <legend><h4 style="color:red;font-family:serif"><b>Graph Analysis:</b></h4></legend>
                        <input type="radio" id="rdDailydata" name="graphBtn1" value="DailyData" onclick="bindDataParamsWise();" checked />
                          <label for="html">Daily</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         <input type="radio" id="rdWeeklyData" name="graphBtn1" value="WeeklyData" onclick="bindDataParamsWise();" />
                          <label for="html">Weekly</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <input type="radio" id="rdMonthlyData" name="graphBtn1" value="MonthlyData"  onclick="bindDataParamsWise();" />
                          <label for="css">Monthly</label>
                              </fieldset>
                   </div>
                </div>
                   
                <div class="col-md-24">
                    <div class="white-box">
                       
                        <fieldset>
                        <legend> <h4 style="color:red;font-family:serif"><b>Quality Indicator: </b></h4></legend>
                        <input type="radio" id="rdamendment" name="graphBtn2" value="AmendmentReport" onclick="bindDataParamsWise();"  />
                          <label for="html">AMENDMENT REPORT</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         <input type="radio" id="rdrepeated" name="graphBtn2" value="RepeatedTests" onclick="bindDataParamsWise();" checked />
                          <label for="html">REPEATED TESTS</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <input type="radio" id="rdrejected" name="graphBtn2" value="RejectedTests"  onclick="bindDataParamsWise();" />
                          <label for="css">REJECTED TESTS</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                         <input type="radio" id="rdabnormal" name="graphBtn2" value="AbnormalTest" onclick="bindDataParamsWise();"  />
                          <label for="html">ABNORMAL TEST</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                         <input type="radio" id="rdcriitical" name="graphBtn2" value="CriticalReport" onclick="bindDataParamsWise();" />
                          <label for="html">CRITICAL REPORT</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <%-- <input type="radio" id="rdautovalidate" name="graphBtn2" value="AutoValidateReport"  onclick="bindDataParamsWise();" />
                          <label for="css">AUTO VALIDATE REPORT</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />

                        <input type="radio" id="rdsratoapprove" name="graphBtn2" value="SraToApprove(<3HR)" onclick="bindDataParamsWise();"  />
                          <label for="html">SRA TO APPROVE(< 3HR)</label>&nbsp;&nbsp;--%>
                         <input type="radio" id="rdoutsource" name="graphBtn2" value="OutsourceTest" onclick="bindDataParamsWise();" />
                          <label for="html">OUTSOURCE TEST</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                          <input type="radio" id="rdinhouse" name="graphBtn2" value="InhouseTest"  onclick="bindDataParamsWise();" />
                          <label for="css">INHOUSE TEST</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                             <input type="radio" id="rdampleload" name="graphBtn2" value="SampleLoad"  onclick="bindDataParamsWise();" />
                          <label for="css">SAMPLE LOAD</label>
                          </fieldset>
                   </div>
                </div>
                       <div class="row" style="margin-top: 2px;">
                <div class="col-md-3">
               <div id="Div1" style="height: 400px; width: 100%;"></div>
               </div> 
                <div class="col-md-6">
               <div id="ContainerAllParams" style="height: 400px; width: 100%;"></div>
               </div> 
                <div class="col-md-3">
               <div id="Div2" style="height: 400px; width: 100%;"></div>
               </div> 
           </div>
            </div>

                    </div>
            <div id="section3" class="container-fluid" style="display:none;">
            <div class="row" style="margin-top: 30px;">
                <div class="col-md-24">
                    <div class="white-box">
                        <h2 style="color:orangered;font-family:serif"><b>Sample load Graph</b></h2>
                        </div></div>
            </div>
           <div class="row" style="margin-top: 2px;">
              
             <%--  <div class="col-md-4">
               <div id="chartContainer1" style="height: 300px; width: 100%;"></div>
               </div> --%>
                <div class="col-md-6">
               <div id="chartContainer2" style="height: 300px; width: 100%;"></div>
               </div> 
               <div class="col-md-6">
               <div id="chartContainer" style="height: 300px; width: 100%;"></div>
               </div> 
           </div>
                </div>
            <div id="section4" class="container-fluid" style="display:none;">
             <div class="row" style="margin-top: 30px;">
                <div class="col-md-12">
                    <div class="white-box" style="width:50%">
                        <table class="table table-striped" id="tblMachineBreakdown" >
                            <thead>
                                <tr>
                                    <th style="font-weight:bold;color:forestgreen;font-size:24px;font-family:serif">Machine BreakDown</th>
                                    
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>


        </div>
                </div>
            <div id="section5" class="container-fluid">

           <div class="row" style="margin-top: 30px;">
               <div class="row" style="margin-top: 30px;">
                <div class="col-md-24">
                    <div class="white-box">
                        <h2 style="color:Red;font-family:serif;font-size:24px"><b>Pending List</b></h2>
                   </div>
                </div>

                <div class="col-md-24">
                    <div class="white-box">
                        <table class="table table-striped" id="tblPendingList">
                            <thead>
                                <tr>
                                    <th>Department</th>
                                    <th>Pending Test Count</th>
                                    <th>Pending Test Percentage</th>
                                   
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>

</div>
        </div>
          </div>

            <div id="section6" class="container-fluid">

           <div class="row" style="margin-top: 30px;">
               <div class="row" style="margin-top: 30px;">
                <div class="col-md-24">
                    <div class="white-box">
                        <h2 style="color:Red;font-family:serif;font-size:24px"><b>Sample Received In Deptwise List</b></h2>
                   </div>
                </div>

                <div class="col-md-24">
                    <div class="white-box">
                        <table class="table table-striped" id="tblPendingListDept">
                            <thead>
                                <tr>
                                    <th>Department</th>
                                    <th>Sample Received Test Count</th>
                                    <th>Sample Received Test Percentage</th>
                                   
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>

</div>
        </div>
          </div>

            <div id="section7" class="container-fluid">

           <div class="row" style="margin-top: 30px;">
               <div class="row" style="margin-top: 30px;">
                <div class="col-md-24">
                    <div class="white-box">
                        <h2 style="color:Red;font-family:serif;font-size:24px"><b>Sra Count Patient List</b></h2>
                   </div>
                </div>

                <div class="col-md-24">
                    <div class="white-box">
                        <table class="table table-striped" id="tblPendingListSra">
                            <thead>
                                <tr>
                                    <th>Department</th>
                                    <th>Sra Test Count</th>
                                    <th>Sra Test Percentage</th>
                                   
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>

</div>
        </div>
          </div>
             
        

            <div class="modal fade bd-example-modal-lg" id="ModalId" tabindex="-1" role="tablist" aria-labelledby="myLargeModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">

                        <div style="width:100%;max-height:500px;overflow-y:scroll" class="container" >
                            
                               <table class="table table-responsive">
  <thead>
    <tr>
      <th scope="col">S.No</th>
       <th scope="col" style="text-align: center;">Visit No</th>
        <th scope="col" style="text-align: center;">Barcode No</th>
      <th scope="col" style="text-align: center;">Patient Name</th>
      <th scope="col" style="text-align: center;">Test Name</th>
    </tr>
  </thead>
  <tbody   id="tb_ItemList" >
    
    
  </tbody>
</table>
                        
                        </div>
                    </div>
                </div>
            </div>
 

                <script type="text/javascript">


                    function showmsg(msg) {
                        $('#msgField').html('');
                        $('#msgField').append(msg);
                        $(".alert").css('background-color', '#04b076');
                        $(".alert").removeClass("in").show();
                        $(".alert").delay(1500).addClass("in").fadeOut(1000);
                    }
                    function showerrormsg(msg) {
                        $('#msgField').html('');
                        $('#msgField').append(msg);
                        $(".alert").css('background-color', 'red');
                        $(".alert").removeClass("in").show();
                        $(".alert").delay(1500).addClass("in").fadeOut(1000);
                    }

                    function totalcount1() {
                        $('#tb_ItemList tr').slice(1).remove();
                        debugger
                        $('#tb_ItemList').empty();
                        var CentreID = $('[id*=lstCentre]').val();
                        var repat = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata1",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {
                                
                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                         mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }
                    

                    function totalcount2() {
                        $('#tb_ItemList tr').slice(1).remove();
                        $('#tb_ItemList').empty();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata2",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                     

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }



                    function totalcount3() {
                        $('#tb_ItemList tr').slice(1).remove();
                        $('#tb_ItemList').empty();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata3",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }




                    function totalcount4() {
                        $('#tb_ItemList').empty();
                        $('#tb_ItemList tr').slice(1).remove();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata4",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }



                    function totalcount5() {
                        $('#tb_ItemList').empty();
                        $('#tb_ItemList tr').slice(1).remove();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata5",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }



                    function totalcount6() {
                        $('#tb_ItemList').empty();
                        $('#tb_ItemList tr').slice(1).remove();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata6",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }


                    function totalcount7() {
                        $('#tb_ItemList').empty();
                        $('#tb_ItemList tr').slice(1).remove();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata7",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }


                    function totalcount8() {
                        $('#tb_ItemList').empty();
                        $('#tb_ItemList tr').slice(1).remove();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata8",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }


                    function totalcount9() {
                        $('#tb_ItemList').empty();
                        $('#tb_ItemList tr').slice(1).remove();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata9",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }


                    function totalcount10() {
                        $('#tb_ItemList').empty();
                        $('#tb_ItemList tr').slice(1).remove();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata10",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";

                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }


                    function totalcount11() {
                        $('#tb_ItemList tr').slice(1).remove();
                        $('#tb_ItemList').empty();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata11",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    //var mydata = "";
                                    $('#ModalId').modal('show');

                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }

                    function totalcount12() {
                        $('#tb_ItemList tr').slice(1).remove();
                        $('#tb_ItemList').empty();
                        debugger
                        var CentreID = $('[id*=lstCentre]').val();
                        $.ajax({
                            type: "POST", // data has to be Posted    	        
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                            url: "TATPendingDashBoard.aspx/GetPopdata12",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            success: function (result) {

                                TestData = $.parseJSON(result.d);
                                if (TestData.dtPendingDataSra.length == 0) {
                                    showerrormsg("No Data Found");
                                }
                                else {
                                    $('#ModalId').modal('show');
                                    for (var i = 0; i <= TestData.dtPendingDataSra.length - 1; i++) {
                                        debugger
                                        //  pcount = parseInt(pcount) + 1;
                                        var mydata = "<tr id=''  style='background-color:white;'>";
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + parseInt(i + 1) + '</td>';

                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].LedgerTransactionNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].BarcodeNo + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].Pname + '</td>';
                                        mydata += '<td class="GridViewLabItemStyle" style="text-align:center;">' + TestData.dtPendingDataSra[i].TestName + '</td>';
                                        mydata += "</tr>";

                                        $('#tb_ItemList').append(mydata);
                                    }

                                }

                            },
                            error: function (xhr, status) {
                                console.log(status + "\r\n" + xhr.responseText);
                                alert("Something Went Wrong.");
                                window.status = status + "\r\n" + xhr.responseText;

                            }
                        });
                    }






                    $("#search").on("keyup", function () {
                        var value = $(this).val().toLowerCase();
                        $("#tblDepartment tbody tr").filter(function () {
                            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                        });
                    });
            function ViewTicket() {
                var txtDate = $('#<%=txtdate.ClientID%>').val()
                window.open("ViewTicket.aspx?txtDate=" + txtDate, null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

            }
                    function ViewSraReport() {
                        var txtDate = $('#<%=txtdate.ClientID%>').val();
                        var CentreID = $('[id*=lstCentre]').val();
                        window.open("SRAToApprove.aspx?txtDate=" + txtDate + "&CentreID=" + CentreID, null, 'left=150, top=100, height=400, width=850,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

                    }
             
            $(function () {
                $("#banner").hide();
               
                bindCentre();
                
                bindTotalCount();

            });
            function bindCentre() {
                $.ajax({
                    url: "TATPendingDashBoard.aspx/bindCentre",
                    data: '{}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",

                    success: function (result) {
                        CentreID = jQuery.parseJSON(result.d);
                        for (i = 0; i < CentreID.length; i++) {
                            jQuery('#lstCentre').append($("<option></option>").val(CentreID[i].centreid).html(CentreID[i].centre));
                        }
                        $('[id*=lstCentre]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, 
                            selectAll: true
                        });
                       
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
            function weekAndDay(date) {
                var weekday = date.getDay();
                var firstDate = new Date();
                firstDate.setDate(1);
                firstDate.setMonth(date.getMonth());
                firstDate.setFullYear(date.getFullYear());
                var temp = new Date(firstDate.toDateString());
                temp.setMonth(firstDate.getMonth() + 1);
                temp.setDate(temp.getDate() - 1);
                var lastDate = temp;
                var thisWeek = -1;
                for (var i = 0; firstDate.getDate() < lastDate.getDate() ; i++) {

                    if (firstDate.getDate() <= date.getDate() && (firstDate.getDate() + (7 - (firstDate.getDay()))) >= date.getDate())
                    {
                        thisWeek = i;
                        break;
                    }
                    firstDate.setDate(firstDate.getDate() + (7 - (firstDate.getDay() - 1)));

                }
                  var prefixes = ['1st week', '2nd week', '3rd week', '4rth week', '5th week'];
                  return prefixes[thisWeek];

            }

            function ExcelreportDwnldWeekly() {

                var CentreID = $('[id*=lstCentre]').val();
                var radioParameters = $("input[name='graphBtn2']:checked").val();
                $.blockUI();
                $.ajax({
                    url: "TATPendingDashBoard.aspx/ExcelreportDownloadWeekly",
                    data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '",radioParameters:"' + radioParameters + '"}',
                            type: "POST",
                            timeout: 120000,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (result) {
                                ItemData = result.d;

                                if (ItemData == "false") {
                                    alert("Error");
                                    $.unblockUI();


                                }
                                else {
                                    window.open('../common/ExportToExcel.aspx');
                                    $.unblockUI();
                                }

                            },

                            error: function (xhr, status) {

                                $.unblockUI();

                            }
                        });


                    }
                    function ExcelreportDownloadMonthly(values) {
                     
                        var MonthVal = values.getMonth() + 1;
                        var firstDate = new Date();
                        firstDate.setDate(1);
                        firstDate.setMonth(values.getMonth());
                        firstDate.setFullYear(values.getFullYear());
                        var temp = new Date(firstDate.toDateString());
                        temp.setMonth(firstDate.getMonth() + 1);
                        temp.setDate(temp.getDate() - 1);
                        var lastDate = temp;
                        var LastDate = new Date(lastDate).toISOString().split("T")[0];
                        var FirstDate = new Date(firstDate).toISOString().split("T")[0];
                        var CentreID = $('[id*=lstCentre]').val();
                        var radioParameters = $("input[name='graphBtn2']:checked").val();
                       
                        $.blockUI();
                        $.ajax({
                            url: "TATPendingDashBoard.aspx/ExcelreportDownloadMonthly",
                           data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '",radioParameters:"' + radioParameters + '",firstDate:"' + FirstDate + '",lastDate:"' + LastDate + '"}',
                            type: "POST",
                            timeout: 120000,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (result) {
                                ItemData = result.d;

                                if (ItemData == "false") {
                                    alert("Error");
                            $.unblockUI();


                        }
                        else {
                            window.open('../common/ExportToExcel.aspx');
                            $.unblockUI();
                        }

                    },

                    error: function (xhr, status) {

                        $.unblockUI();

                    }
                });


            }

            function bindDataParamsWise() {

                var radioValue = $("input[name='graphBtn1']:checked").val();
                var radioParameters = $("input[name='graphBtn2']:checked").val();
                var CentreID = $('[id*=lstCentre]').val();
               
                $.blockUI();

                $.ajax({
                    url: "TATPendingDashBoard.aspx/bindDataParamsWise",
                    data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",radioValue:"' + radioValue + '",Centreid:"' + CentreID + '",radioParameters:"' + radioParameters + '"}',
                        type: "POST",
                        timeout: 120000,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            var $responseData = JSON.parse(result.d);
                            //var InhouseTestcount = $responseData.dtInhouseTestcount;
                            if ($responseData.status) {
                                if (radioValue == "MonthlyData") {
                                  
                                    //Monthlygraph
                                    var MonthlyData = $responseData.dtCurrentdaydata;
                                   
                                    var dataPoints = [];
                                    
                                    var options = {
                                        animationEnabled: true,
                                        backgroundColor: "#D1D0CE",
                                        theme: "light2",
                                        title: {
                                            text: radioValue + "- " + radioParameters,
                                            fontColor: "black",
                                            fontSize: 20
                                        },
                                        //toolTip: {
                                        //    content: "{x}:{y}"
                                        //},
                                        axisX: {
                                            gridThickness: 0,
                                            tickLength: 0,
                                            lineThickness: 0,
                                            interval: 20,
                                            labelFormatter: function () {
                                                return " ";
                                            }
                                        },
                                        axisY: {
                                            title: "Monthly Count",
                                            titleFontSize: 24
                                        },
                                        dataPointWidth: 30,
                                        data: [
                                                  {
                                                      toolTipContent: "Count:{y}",
                                                      type: "column",
                                                      xValueFormatString: "MMM",
                                                      indexLabel: "{x}",
                                                      indexLabelFontColor: "black",
                                                      indexLabelFontWeight: "bold",
                                                      dataPoints: dataPoints,
                                                      click: function (e) {
                                                          ExcelreportDownloadMonthly(e.dataPoint.x);
                                                      }
                                                  }
                                                   
                                        ]
                                    };


                                    for (var i = 0; i < MonthlyData.length; i++) {
                                       
                                        dataPoints.push({
                                            x: new Date(MonthlyData[i].CreatedDateTime),
                                            y: MonthlyData[i].countdata
                                            //z: ((MonthlyData[i].countdata / InhouseTestcount[0].OuthouseInhouse) * 100).toFixed(2)
                                        });

                                       
                                    }
                                    $("#ContainerAllParams").CanvasJSChart(options);
                                    $.unblockUI();
                                }
                               else if (radioValue == "WeeklyData") {
                                 
                                    //Weekly graph
                                    var MonthlyData = $responseData.dtCurrentdaydata;

                                    var dataPoints = [];
                                    var list = [];
                                    var options = {
                                        animationEnabled: true,
                                        backgroundColor: "#D1D0CE",
                                        theme: "light2",
                                        title: {
                                            text: radioValue + "- " + radioParameters,
                                            fontColor: "black",
                                            fontSize: 20
                                        },
                                        toolTip: {
                                            content: "{x}:{y}"
                                        },
                                        axisX: {
                                            gridThickness: 0,
                                            tickLength: 0,
                                            lineThickness: 0,
                                            interval: 20,
                                            
                                        labelFormatter: function (e) {
                                            return "";
                                        }
                                        },
                                        axisY: {
                                            title: "Weekly Count",
                                            titleFontSize: 24
                                        },
                                        dataPointWidth: 30,
                                        data: [
                                                  {
                                                      toolTipContent: "Count:{y}",
                                                      type: "column",
                                                      xValueFormatString: "MMM",
                                                      indexLabel:"{z}",
                                                      indexLabelFontColor: "black",
                                                      indexLabelFontWeight: "bold",
                                                      dataPoints: dataPoints,
                                                      click: function (e) {
                                                          ExcelreportDwnldWeekly();
                                                      }
                                                  }

                                        ]
                                    };


                                    for (var i = 0; i < MonthlyData.length; i++) {
                                        dataPoints.push({
                                            x: new Date(MonthlyData[i].CreatedDateTime),
                                            y: MonthlyData[i].countdata,
                                            z: weekAndDay(new Date(MonthlyData[i].CreatedDateTime))
                                           // z1: ((MonthlyData[i].countdata / InhouseTestcount[0].OuthouseInhouse) * 100).toFixed(2)
                                        });

                                      
                                    }
                                    $("#ContainerAllParams").CanvasJSChart(options);
                                    $.unblockUI();
                                }
                              else if (radioValue == "DailyData") {
                                    //dailybasisgraph
                                    var dailybasisData = $responseData.dtCurrentdaydata;
                                    var dataPoints = [];

                                    var options2 = {
                                        animationEnabled: true,
                                        backgroundColor: "#D1D0CE",
                                        theme: "light2",
                                        title: {
                                            text: radioValue + "- " + radioParameters,
                                            fontColor: "Black",
                                            fontSize: 20
                                        },
                                        axisX: {
                                            valueFormatString: "DD MMM YYYY",
											//interval: 3,
											//intervalType: "month",
                                        },
                                        axisY: {
                                            title: "Daily Basis Count",
                                            titleFontSize: 24
                                        },
                                        data: [{
                                            type: "line",
                                            lineColor: "green",
                                            yValueFormatString: "#,###.##",
                                            dataPoints: dataPoints
                                        }]
                                    };


                                    for (var i = 0; i < dailybasisData.length; i++) {
                                        dataPoints.push({
                                            x: new Date(dailybasisData[i].CreatedDateTime),
                                            y: dailybasisData[i].countdata
                                        });

                                       

                                    }
                                    if (dailybasisData.length == 0) {
                                        dataPoints.push({
                                            x: new Date('00-00-0000'),
                                            y: 0
                                        });
                                      
                                    }
                                    $("#ContainerAllParams").CanvasJSChart(options2);
                                    $.unblockUI();

                                }
                                else {
                                    $.unblockUI();
                                }
                            }
                        }
                });
                }

            function bindDataWklyMonthly() {
               
                var radioValue = $("input[name='graphBtn']:checked").val();
                var CentreID = $('[id*=lstCentre]').val();
                var dataValues = "";

                if (radioValue == "monthlyData") {
                    dataValues = "Monthly";
                }
                if (radioValue == "weeklyData") {
                    dataValues = "Weekly";
                }
                if (radioValue == "dailyData") {
                    dataValues = "Daily";
                }
                    $.blockUI();

                    $.ajax({
                        url: "TATPendingDashBoard.aspx/bindTotalCountwkly",
                        data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",radioValue:"' + radioValue + '",Centreid:"' + CentreID + '"}',
                        type: "POST",
                        timeout: 120000,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                        var $responseData = JSON.parse(result.d);
                        if ($responseData.status) {
                            var $responseCountData = $responseData.displayCount;
                            //monthly based on the above parameters.
                            var options = {
                                title: {
                                    text: dataValues
                                },
                                data: [{
                                    type: "pie",
                                    startAngle: 45,
                                    showInLegend: "true",
                                    legendText: "{label}",
                                    indexLabelFontColor: "",
                                    indexLabelFontSize: 0,
                                    indexLabelPlacement: "inside",
                                    yValueFormatString: "#,##0.#" % "",
                                    dataPoints: [
                                       // { label: "TOTAL TESTS", y: $responseCountData[0].TotalSample },
                                        { label: "AMENDMENT REPORT", y: $responseCountData[0].AmendmentSample },
                                        { label: "REPEATED TESTS", y: $responseCountData[0].RepeatedSample },
                                        { label: "REJECTED TESTS", y: $responseCountData[0].RejectedSample },
                                        { label: "ABNORMAL TEST", y: $responseCountData[0].AbnormalSample },
                                        { label: "CRITICAL REPORT", y: $responseCountData[0].CriticalSample },
                                       // { label: "AUTO VALIDATE REPORT", y: $responseCountData[0].AutoApprovedSample },
                                       // { label: "SRA TO APPROVE(WITHIN 6HR)", y: $responseCountData[0].TAT },
                                        { label: "OUTSOURCE TEST", y: $responseCountData[0].OutsourceCount }

                                    ]
                                }]

                            };
							var total = ($responseCountData[0].AmendmentSample + $responseCountData[0].RepeatedSample + $responseCountData[0].RejectedSample + $responseCountData[0].AbnormalSample + $responseCountData[0].CriticalSample + $responseCountData[0].AutoApprovedSample + $responseCountData[0].TAT + $responseCountData[0].OutsourceCount) / $responseCountData[0].TotalSample;
							var AMENDMENTREPORTPercentage = Math.round(($responseCountData[0].AmendmentSample / $responseCountData[0].TotalSample) * 100);
							//alert(AMENDMENTREPORT);
							var REPEATEDTESTSPercentage = Math.round(($responseCountData[0].RepeatedSample / $responseCountData[0].TotalSample) * 100);
							var REJECTEDTESTSPercentage = Math.round(($responseCountData[0].RejectedSample / $responseCountData[0].TotalSample) * 100);
							var ABNORMALTESTPercentage = Math.round(($responseCountData[0].AbnormalSample / $responseCountData[0].TotalSample) * 100);
							var CRITICALREPORTPercentage = Math.round(($responseCountData[0].CriticalSample / $responseCountData[0].TotalSample) * 100);
							var AUTOVALIDATEREPORTPercentage = Math.round(($responseCountData[0].AutoApprovedSample / $responseCountData[0].TotalSample) * 100);
							var SRATOAPPROVEPercentage = Math.round(($responseCountData[0].TAT / $responseCountData[0].TotalSample) * 100);
							var OUTSOURCETESTPercentage = Math.round(($responseCountData[0].OutsourceCount / $responseCountData[0].TotalSample) * 100);


							
							var Percentageoptions = {
                                title: {
                                    text: dataValues
                                },
                                data: [{
                                    type: "pie",
                                    startAngle: 45,
                                    showInLegend: "true",
                                    legendText: "{label}",
                                    indexLabelFontColor: "",
                                    indexLabelFontSize: 0,
                                    indexLabelPlacement: "inside",
                                    yValueFormatString: "#,##0.#" % "",
                                    dataPoints: [
                                       // { label: "TOTAL TESTS", y: total },//($responseCountData[0].RepeatedSample / totalSample) * 100)
                                        { label: "AMENDMENT REPORT", y: AMENDMENTREPORTPercentage },
                                        { label: "REPEATED TESTS", y: REPEATEDTESTSPercentage },
                                        { label: "REJECTED TESTS", y: REJECTEDTESTSPercentage },
                            { label: "ABNORMAL TEST", y: ABNORMALTESTPercentage },
                                        { label: "CRITICAL REPORT", y: CRITICALREPORTPercentage },
                   // { label: "AUTO VALIDATE REPORT", y: AUTOVALIDATEREPORTPercentage },
                   // { label: "SRA TO APPROVE(WITHIN 6HR)", y: SRATOAPPROVEPercentage },
                    { label: "OUTSOURCE TEST", y: OUTSOURCETESTPercentage }

                                    ]
                                }]

                            };

                            $("#PiechartContainer1").CanvasJSChart(options);
                            $("#PiechartContainer2").CanvasJSChart(Percentageoptions);
                            $.unblockUI();

                        }
                        else {
                            $.unblockUI();
                        }
                    }
                });
                

            }

                    function ExcelreportDwnld(value) {
                       
                        var CentreID = $('[id*=lstCentre]').val();
                        
                        $.blockUI();
                        $.ajax({
                            url: "TATPendingDashBoard.aspx/ExcelreportMonthwise",
                            data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '",value:"' + value + '"}',
                            type: "POST",
                            timeout: 120000,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (result) {
                                ItemData = result.d;

                                if (ItemData == "false") {
                                    alert("Error");
                                    $.unblockUI();


                                }
                                else {
                                    window.open('../common/ExportToExcel.aspx');
                                    $.unblockUI();
                                }
                                                            
                            },
                                                        
                            error: function (xhr, status) {

                                $.unblockUI();

                            }
                    });


             }
                                                
                   
            function bindTotalCount() {
                var CentreID = $('[id*=lstCentre]').val();
                $.blockUI();
              
                $.ajax({
                    url: "TATPendingDashBoard.aspx/bindTotalCount",
                    data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                    type: "POST",
                    timeout: 120000,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var $responseData = JSON.parse(result.d);
                        if ($responseData.status) {
                            var $responseCountData = $responseData.displayCount;
                            $("#spTotalSample").text($responseCountData[0].TotalSample);
							$("#Spantotalpatientcount").text($responseCountData[0].TotalpatientCount); 
                            $("#Discounttest").text($responseCountData[0].TotalDiscountpatient);
                            
                            var totalSample = $responseCountData[0].TotalSample;
                            var amendmentSample = $responseCountData[0].AmendmentSample;
                            var amendmentPercentage = ((amendmentSample / totalSample) * 100).toFixed(2);
                           
                            $("#spAmendmentSample_Per").text(amendmentPercentage + "%");
                            if (amendmentPercentage > 2.00) {
                                $(".amndreport").show();
                            } else {
                                $(".amndreport").hide();
                            }
                            $("#spAmendmentSample").text(amendmentSample);
                            $("#spRepeatedSample").text($responseCountData[0].RepeatedSample);
                            
                            var RepeatedSample_per = (($responseCountData[0].RepeatedSample / totalSample) * 100).toFixed(2);
                            
                            $("#spRepeatedSample_Per").text(RepeatedSample_per + "%");
                            if (RepeatedSample_per > 2.00) {
                                $("#banner").show();
                                $(".repeatreport").show();
                            }else{
                                $("#banner").hide();
                                $(".repeatreport").hide();
                            }
                            
                            $("#spRejectedSample").text($responseCountData[0].RejectedSample);

                            var RejectedSample_per = (($responseCountData[0].RejectedSample / totalSample) * 100).toFixed(2);

                            $("#spRejectedSample_Per").text(RejectedSample_per + "%");

                            var criticalsample = $responseCountData[0].CriticalSample;
                            var abnormaltest = $responseCountData[0].AbnormalSample;
                            var criticalpercent = ((criticalsample / totalSample) * 100).toFixed(2);
                            var abnormalpercent = ((abnormaltest / totalSample) * 100).toFixed(2);

                            $("#spAbnormalSample").text($responseCountData[0].AbnormalSample);
                            $("#spAbnormalSample_Per").text(abnormalpercent + "%");
                            $("#spCriticalSample").text($responseCountData[0].CriticalSample);
                            $("#spCriticalSample_Per").text(criticalpercent + "%");
                           
                            //var spAutoApprovedSample_per = (($responseCountData[0].AutoApprovedSample / totalSample) * 100).toFixed(2);
                            //$("#spAutoApprovedSample").text($responseCountData[0].AutoApprovedSample);
                            //$("#spAutoApprovedSample_Per").text(spAutoApprovedSample_per + "%");

                            //var spTAT_per = (($responseCountData[0].TAT / totalSample) * 100).toFixed(2);
                            //$("#spTAT").text($responseCountData[0].TAT);
                            //$("#spTAT_Per").text(spTAT_per+"%");

                           
                            //var tatinthree = $responseCountData[0].TAT3Hrs;
                            //var tatthreepercent = ((tatinthree / totalSample) * 100).toFixed(2);
                            //$("#spTATPracessingthree").text(tatinthree);
                            //    $("#spTATPracessingthree_Per").text(tatthreepercent + "%");
                            
                            //    if (tatinthree > 0) {
                            //        $(".sraapprove").show();
                            //    } else {
                            //        $(".sraapprove").hide();
                            //    }
                            
                                $("#spTicketraised").text($responseCountData[0].TicketRaised);

                            $("#spOutsourceTest").text($responseCountData[0].OutsourceCount);
                            var outsourcetest = $responseCountData[0].OutsourceCount;
                            var outsourcepercent = ((outsourcetest / totalSample) * 100).toFixed(2);
                           
                            $("#spOutsourceTest_Per").text(outsourcepercent + "%");

                            
                            $("#spInhousetest").text($responseCountData[0].InhouseTest);
                          
                            var OnholdCount = $responseCountData[0].OnholdCount;
                            var Onholdpercent = ((OnholdCount / totalSample) * 100).toFixed(2);
                            $("#spOnholdCount").text(OnholdCount);
                            $("#spOnholdPer").text(Onholdpercent + "%");
							
			    var OnRegCount = $responseCountData[0].TotalReg;
			    var OnRegpercent = ((OnRegCount / totalSample) * 100).toFixed(2);
                            $("#spOnRegCount").text(OnRegCount);
                            $("#spOnRegPer").text(OnRegpercent + "%");
 
			    var OnNetSale = $responseCountData[0].NetSale;
                            $("#spOnNetSale").text(OnNetSale);

                            var $machineBreakdown = $responseData.dtMachinebreakdown;
                            
                            $('#tblMachineBreakdown tr').slice(1).remove();
                            for (var i = 0; i < $machineBreakdown.length ; i++) {
                                var $mach = [];
                                $mach.push('<tr>');
                                $mach.push('<td style="font-weight-bold;font-size: 16px;font-weight:bold;" >'); $mach.push($machineBreakdown[i].MACHINEID); $mach.push('</td>');
                                $mach.push('</tr>');
                                $mach = $mach.join("");
                                $('#tblMachineBreakdown tbody').append($mach);
                            }


                            var $departmentData = $responseData.displaycentrewise;

                          
                            $('#tblDepartment tr').slice(1).remove();
                            for (var i = 0; i < $departmentData.length ; i++) {
                                var $dept = [];
                                $dept.push('<tr>');
                                $dept.push('<td style="font-weight-bold;font-size: 16px;font-weight:bold;" >'); $dept.push($departmentData[i].Centre); $dept.push('</td>');
                                $dept.push('<td ><span class=" label-default  label-4 label" style="font-size:20px;">'); $dept.push($departmentData[i].TotalSample); $dept.push('</span></td>');
                                $dept.push('<td ><span class=" label-primary  label-4 label" style="font-size:20px;">'); $dept.push((($departmentData[i].AmendmentSample / $departmentData[i].TotalSample)*100).toFixed(2)+"%"); $dept.push('</span></td>');
                                $dept.push('<td ><span class=" label-success  label-4 label" style="font-size:20px;">'); $dept.push((($departmentData[i].RepeatedSample / $departmentData[i].TotalSample)*100).toFixed(2)+"%"); $dept.push('</span></td>');
                                $dept.push('<td ><span class=" label-info  label-4 label" style="font-size:20px;">'); $dept.push((($departmentData[i].RejectedSample / $departmentData[i].TotalSample)*100).toFixed(2)+"%"); $dept.push('</span></td>');
                                $dept.push('<td ><span class=" label-warning  label-4 label" style="font-size:20px;">'); $dept.push((($departmentData[i].AbnormalSample / $departmentData[i].TotalSample)*100).toFixed(2)+"%"); $dept.push('</span></td>');
                                $dept.push('<td ><span class=" label-primary  label-4 label" style="font-size:20px;">'); $dept.push((($departmentData[i].CriticalSample / $departmentData[i].TotalSample)*100).toFixed(2)+"%"); $dept.push('</span></td>');
                                $dept.push('<td ><span class=" label-default  label-4 label" style="font-size:20px;">'); $dept.push((($departmentData[i].AutoApprovedSample / $departmentData[i].TotalSample)*100).toFixed(2)+"%"); $dept.push('</span></td>');
                                $dept.push('<td ><span class=" label-info  label-4 label" style="font-size:20px;">'); $dept.push((($departmentData[i].TAT3hrIn / $departmentData[i].TotalSample)*100).toFixed(2)+"%"); $dept.push('</span></td>');
                                $dept.push('<td ><span class=" label-info  label-4 label" style="font-size:20px;">'); $dept.push((($departmentData[i].TAT3hrOut / $departmentData[i].TotalSample)*100).toFixed(2)+"%"); $dept.push('</span></td>');
                                $dept.push('</tr>');
                                $dept = $dept.join("");
                                $('#tblDepartment tbody').append($dept);
                            }
                            // Pending test departmentwise
                            var $PendingData = $responseData.dtPendingData;
                            var totalSample = $responseCountData[0].TotalSample;
                            
                            var InhouseSampleCount = $responseCountData[0].InhouseTest;
                            $('#tblPendingList tr').slice(1).remove();
                            for (var i = 0; i < $PendingData.length ; i++) {
                                var $pend = [];
                                var $pendingCount = $PendingData[i].DepartmentCount;
                                var $pendingPercent = (($pendingCount / InhouseSampleCount) * 100).toFixed(2);
                                $pend.push('<tr>');
                                $pend.push('<td style="font-weight-bold;font-size: 16px;font-weight:bold;" >'); $pend.push($PendingData[i].Department); $pend.push('</td>');
                                $pend.push('<td ><span class=" label-default  label-4 label" style="font-size:20px;">'); $pend.push($PendingData[i].DepartmentCount); $pend.push('</span></td>');
                                $pend.push('<td ><span class=" label-primary  label-4 label" style="font-size:20px;">'); $pend.push($pendingPercent +"%"); $pend.push('</span></td>');
                                $pend.push('</tr>');
                                $pend = $pend.join("");
                                $('#tblPendingList tbody').append($pend);
                            }

                                //Pending Test Departmetwise Sample

                                var $PendingDataDept = $responseData.dtPendingDataDept;
                                var totalSample = $responseCountData[0].TotalSample;
                            
                                var InhouseSampleCount = $responseCountData[0].InhouseTest;
                                $('#tblPendingListDept tr').slice(1).remove();
                                for (var i = 0; i < $PendingDataDept.length ; i++) {
                                    var $pendDept = [];
                                    var $pendingCountDept = $PendingDataDept[i].DepartmentCount;
                                    var $pendingPercentDept = (($pendingCountDept / InhouseSampleCount) * 100).toFixed(2);
                                    $pendDept.push('<tr>');
                                    $pendDept.push('<td style="font-weight-bold;font-size: 16px;font-weight:bold;" >'); $pendDept.push($PendingDataDept[i].Department); $pendDept.push('</td>');
                                    $pendDept.push('<td ><span class=" label-default  label-4 label" style="font-size:20px;">'); $pendDept.push($PendingDataDept[i].DepartmentCount); $pendDept.push('</span></td>');
                                    $pendDept.push('<td ><span class=" label-primary  label-4 label" style="font-size:20px;">'); $pendDept.push($pendingPercentDept + "%"); $pendDept.push('</span></td>');
                                    $pendDept.push('</tr>');
                                    $pendDept = $pendDept.join("");
                                    $('#tblPendingListDept tbody').append($pendDept);
                                }
                                    //Pending Test Departmetwise Sra

                                    var $PendingDataSra = $responseData.dtPendingDataSra;
                                    var totalSample = $responseCountData[0].TotalSample;
                            
                                    var InhouseSampleCount = $responseCountData[0].InhouseTest;
                                    $('#tblPendingListSra tr').slice(1).remove();
                                    for (var i = 0; i < $PendingDataSra.length ; i++) {
                                        var $pendSra = [];
                                        var $pendingCountSra = $PendingDataSra[i].DepartmentCount;
                                        var $pendingPercentSra = (($pendingCountSra / InhouseSampleCount) * 100).toFixed(2);
                                        $pendSra.push('<tr>'); 
                                        $pendSra.push('<td style="font-weight-bold;font-size: 16px;font-weight:bold;" >'); $pendSra.push($PendingDataSra[i].Department); $pendSra.push('</td>');
                                        $pendSra.push('<td ><span class=" label-default  label-4 label" style="font-size:20px;">'); $pendSra.push($PendingDataSra[i].DepartmentCount); $pendSra.push('</span></td>');
                                        $pendSra.push('<td ><span class=" label-primary  label-4 label" style="font-size:20px;">'); $pendSra.push($pendingPercentSra +"%"); $pendSra.push('</span></td>');
                                        $pendSra.push('</tr>');
                                        $pendSra = $pendSra.join("");
                                        $('#tblPendingListSra tbody').append($pendSra);

                            }

                            //Monthlygraph
                            //var MonthlyData = $responseData.dtMonthdata;
                            //var MonthlyDataPrevOneMonth = $responseData.dtprevonemonth;
                            //var MonthlyDataPrevTwoMonth = $responseData.dtprevTwoMonth;
                            //var dataPoints = [];
                            //var dataPoints1 = [];
                            //var dataPoints2 = [];

                            //var options = {
                            //    animationEnabled: true,
                            //    backgroundColor: "#D1D0CE",
                            //    theme: "light2",
                            //    title: {
                            //        text: "Monthly Basis",
                            //        fontColor: "black"
                            //    },
                            //    toolTip: {
                            //        content: "{x}:{y}"
                            //    },
                            //    axisX: {
                            //        gridThickness: 0,
                            //        tickLength: 0,
                            //        lineThickness: 0,
                            //        labelFormatter: function () {
                            //            return " ";
                            //        }
                            //    },
                            //    axisY: {
                            //        title: "Monthly Count",
                            //        titleFontSize: 24
                            //    },
                                
                            //    data: [
                            //              {
                            //                  type: "column",
                            //                  color: "purple",
                            //                  xValueFormatString: "MMM",
                            //                  indexLabel: "{x}",
                            //                  indexLabelFontColor: "black",
                            //                  indexLabelFontWeight: "bold",
                            //                  dataPoints: dataPoints,
                            //                  click: function (e) {
                            //                      ExcelreportDwnld(1);
                            //                  }
                            //              },
                            //                {
                            //                    type: "column",
                            //                    xValueFormatString: "MMM",
                            //                    indexLabel: "{x}",
                            //                    color: "green",
                            //                    indexLabelFontColor: "black",
                            //                    indexLabelFontWeight: "bold",
                            //                    dataPoints: dataPoints1,
                            //                    click: function (e) {
                            //                        ExcelreportDwnld(2);
                            //                    }
                            //                },
                            //                {
                            //                    type: "column",
                            //                    xValueFormatString: "MMM",
                            //                    indexLabel: "{x}",
                            //                    color: "red",
                            //                    indexLabelFontColor: "black",
                            //                    indexLabelFontWeight: "bold",
                            //                    dataPoints: dataPoints2,
                            //                    click: function (e) {
                            //                        ExcelreportDwnld(3);
                            //                    }
                            //                }
                            //                    ]
                            //                };

                           
                            //                for (var i = 0; i < MonthlyData.length; i++) {
                            //                    dataPoints.push({
                            //                        x: new Date(MonthlyData[i].CreatedDateTime),
                            //                        y: MonthlyData[i].countdata
                            //                    });

                            //                    $("#chartContainer").CanvasJSChart(options);
                            //                }
                            
                            //                for (var i = 0; i < MonthlyDataPrevOneMonth.length; i++) {
                            //                    dataPoints1.push({
                            //                        x: new Date(MonthlyDataPrevOneMonth[i].CreatedDateTime),
                            //                        y: MonthlyDataPrevOneMonth[i].countdata
                            //                    });

                            //                    $("#chartContainer").CanvasJSChart(options);
                            //                }
                            //                for (var i = 0; i < MonthlyDataPrevTwoMonth.length; i++) {
                            //                    dataPoints2.push({
                            //                        x: new Date(MonthlyDataPrevTwoMonth[i].CreatedDateTime),
                            //                        y: MonthlyDataPrevTwoMonth[i].countdata
                            //                    });

                            //                    $("#chartContainer").CanvasJSChart(options);
                            //                }
                            //realtimegraph
                            //var realtimeData = $responseData.dtrealtimedata;
                            //  var dataPoints = [];

                            //  var options1 = {
                            //      animationEnabled: true,
                            //      theme: "light2",
                            //      title: {
                            //          text: "Real Time"
                            //      },
                            //      axisX: {
                            //          valueFormatString: "DD MMM YYYY",
                            //      },
                            //      axisY: {
                            //          title: " Real Time Count",
                            //          titleFontSize: 24
                            //      },
                            //      data: [{
                            //          type: "spline",
                            //          yValueFormatString: "#,###.##",
                            //          dataPoints: dataPoints
                            //      }]
                            //  };

                           
                            //  for (var i = 0; i < realtimeData.length; i++) {
                            //      if (realtimeData[0].CreatedDateTime == null) {
                            //          dataPoints.push({
                            //              x: new Date('00-00-0000'),
                            //              y: 0
                            //          });
                            //      }
                            //      else{
                            //          dataPoints.push({
                            //              x: new Date(realtimeData[i].CreatedDateTime),
                            //              y: realtimeData[i].countdata
                            //          });
                            //      }
                            //      $("#chartContainer1").CanvasJSChart(options1);
                            //}
                              
                             
                            //dailybasisgraph
                        //      var dailybasisData = $responseData.dtCurrentdaydata;
                        //      var dataPoints = [];

                        //      var options2 = {
                        //          animationEnabled: true,
                        //          backgroundColor: "#D1D0CE",
                        //          theme: "light2",
                        //          title: {
                        //              text: "Daily Basis",
                        //              fontColor: "Black"
                        //          },
                        //          axisX: {
                        //              valueFormatString: "DD MMM YYYY",
                        //          },
                        //          axisY: {
                        //              title: "Daily Basis Count",
                        //              titleFontSize: 24
                        //          },
                        //          data: [{
                        //              type: "line",
                        //              lineColor: "green",
                        //              yValueFormatString: "#,###.##",
                        //              dataPoints: dataPoints
                        //          }]
                        //      };


                        //      for (var i = 0; i < dailybasisData.length; i++) {
                        //          dataPoints.push({
                        //              x: new Date(dailybasisData[i].CreatedDateTime),
                        //              y: dailybasisData[i].countdata
                        //          });
                                  
                        //              $("#chartContainer2").CanvasJSChart(options2);
                                 
                        //}
                        //if (dailybasisData.length == 0) {
                        //    dataPoints.push({
                        //        x: new Date('00-00-0000'),
                        //        y: 0
                        //    });
                        //    $("#chartContainer2").CanvasJSChart(options2);
                        //}
                        //bindDataWklyMonthly();
                       // bindDataParamsWise();
                            $.unblockUI();

                        }
                        else {
                            $.unblockUI();
                        }
                    }
                });
            }

          
            function gotohome() {
                window.location.href = "<%=Request.Url.Scheme %>://<%=Request.Url.Host %>:<%=Request.Url.Port %>/<%=Request.Url.AbsolutePath.Split('/')[1] %>/Design/Welcome.aspx";
            }

            function excelreport() {
                var CentreID = $('[id*=lstCentre]').val();
                $.blockUI();
                $.ajax({
                    url: "TATPendingDashBoard.aspx/excelreport",
                    data: '{date:"' + $('#<%=txtdate.ClientID%>').val() + '",Centreid:"' + CentreID + '"}',
                    type: "POST",
                    timeout: 120000,

                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        ItemData = result.d;

                        if (ItemData == "false") {
                            alert("Error");
                            $.unblockUI();

                        }
                        else {
                            window.open('../common/ExportToExcel.aspx');
                            $.unblockUI();

                        }

                    },
                    error: function (xhr, status) {

                        $.unblockUI();

                    }
                });
            }
        
        </script>
          <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
    </form>
</body>
</html>
