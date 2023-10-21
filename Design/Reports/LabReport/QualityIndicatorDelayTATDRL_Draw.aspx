<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QualityIndicatorDelayTATDRL_Draw.aspx.cs" Inherits="Design_Lab_QualityIndicatorDelayTATDRL_Draw" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
  
    <script src="../../Scripts/jquery-3.1.1.js"></script>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
     <script type="text/javascript">
         google.load("visualization", "1", { packages: ["columnchart"] });
         google.setOnLoadCallback(drawChart);
         function drawChart() {
             var data1 = '<%=jsonstring%>';

             var json = $.parseJSON(data1);
            

             var arr = [['Month', '<%=headding1%>', '<%=headding2%>']]

            $.each(json, function (index, value) {
                arr.push([value.Month, parseInt(value.Val), value.Val_Per]);

            });

            var data = google.visualization.arrayToDataTable(arr);


            var options = {
                title: '<%=headding3%>',
                hAxis: { title: 'Month', titleTextStyle: { color: 'red' } },
                width: 1020, height: 500, is3D: true

            };


            var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
            chart.draw(data, options);

             
        }
    </script>
<style>
#divData td {
border:1px solid #000;
border-left: 0px solid #000;
    border-top: 0px solid;
}
#divData{
border:0px solid #000;
border-left: 1px solid #000;
    border-top: 1px solid;
}
</style>
</head>
<body>
    <form id="form1" runat="server">
   <div style="margin-left:10%;margin-top:5%;" runat="server" id="div_contain">
       <div runat="server" style="text-align:center; width:90%;margin-bottom:30px;  font-size:13px" id="divData"></div>

        <div id="chart_div" runat="server" style="width:90%;  text-align:center;" ></div>
       <b>Review Comments: Delay TAT quality indicator needs to be monitor in more streangent and target for te next 6 months fixed as <3.0%
</b>
       </div>
    
    </form>
</body>
</html>
