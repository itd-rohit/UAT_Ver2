<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TATGraph.aspx.cs" Inherits="Design_Reports_LabReport_TATGraph" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <script src="../../../Scripts/jquery-3.1.1.min.js"></script>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
     <script type="text/javascript">
         google.load("visualization", "1", { packages: ["columnchart"] });
         google.setOnLoadCallback(drawChart);
         function drawChart() {
            
             var data = google.visualization.arrayToDataTable([
          ['TAT', 'TAT Delay'],
          ['TATInTime', <%=headding1%>],
          ['TATBeyondTime', <%=headding2%>],
          ['MasterNotDefined', <%=headding3%>]
             ]);
             var options = {
                 title: '<%=ReportName%>',
                 hAxis: { title: 'Graph', titleTextStyle: { color: 'red' } },
                width: 720, height: 350, is3D: true

            };
             var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div style="margin-left:10%;" runat="server" id="div_contain">
       <div runat="server" style="text-align:left; width:90%;margin-bottom:30px;height:220px;overflow:scroll;  font-size:20px" id="divData"></div>

        <div id="chart_div" style="width:90%;  text-align:center;" ></div>
       </div>
    </form>
</body>
</html>
