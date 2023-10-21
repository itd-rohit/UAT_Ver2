<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RotateImage.aspx.cs" Inherits="Design_PettyCash_RotateImage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="js/test/jquery.js"></script>
    <script type="text/javascript" src="js/test/jqueryui.js"></script>
    <script type="text/javascript" src="js/test/jquery.mousewheel.min.js"></script>
    <script type="text/javascript" src="js/jquery.iviewer.js"></script>
    <script type="text/javascript">

        var $ = jQuery;
        $(function () {
            var imageSrc = window.location.search.substring(1).split('_')[0] + "/" + window.location.search.substring(1).split('_')[1] + "/" + window.location.search.substring(1).split('_')[2];

            var iv1 = $("#viewer").iviewer({
                src: imageSrc,
                update_on_resize: false,
                zoom_animation: false,
                mousewheel: false,
                onMouseMove: function (ev, coords) { },
                onStartDrag: function (ev, coords) { return false; }, //this image will not be dragged
                onDrag: function (ev, coords) { }
            });

            $("#in").click(function () { iv1.iviewer('zoom_by', 1); });
            $("#out").click(function () { iv1.iviewer('zoom_by', -1); });
            $("#fit").click(function () { iv1.iviewer('fit'); });
            $("#orig").click(function () { iv1.iviewer('set_zoom', 100); });
            $("#update").click(function () { iv1.iviewer('update_container_info'); });

            var iv2 = $("#viewer2").iviewer(
            {
                src: imageSrc.split('=')[1]
            });

            $("#chimg").click(function () {
                iv2.iviewer('loadImage', imageSrc.split('=')[1]);
                return false;
            });

            var fill = false;
            $("#fill").click(function () {
                fill = !fill;
                iv2.iviewer('fill_container', fill);
                return false;
            });
        });
        </script>
    <link rel="stylesheet" href="js/jquery.iviewer.css" />
    <style>
        .viewer {
            width: 99%;
            height: 1000px;
            border: 1px solid black;
            position: relative;
        }

        .wrapper {
            overflow: auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            <%--<span>
                <a id="in" href="#">+</a>
                <a id="out" href="#">-</a>
                <a id="fit" href="#">fit</a>
                <a id="orig" href="#">orig</a>
                <a id="update" href="#">update</a>
            </span>--%>
            <centre>    <div id="viewer" class="viewer" ></div></centre>
            <br />
            <div id="viewer2" class="viewer" style="width: 100%; display: none;"></div>
            <br />
            <%-- <p>
              <a href="#" id="chimg">Change Image</a>
              <a href="#" id="fill">Fill container</a>
            </p>--%>
        </div>
    </form>
</body>
</html>