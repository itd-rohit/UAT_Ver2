<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CheckCompanyName.aspx.cs" Inherits="Design_Lab_CheckCompanyName" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
</head>
<body>
    <div id="show" runat="server">
        <table cellspacing="0" style="width: 500px; font-family: Cambria; font-size: 18px;color:red;" rules="all" frame="box" border="1">
            <tr style="background-color: #AEB6CB; font-weight: bold;">
                <td>This test is canceled from <b id="binddata"> </b>. Report will not generate for this test.</td>
            </tr>




        </table>
    </div>

</body>
</html>
<script>
    $(function () {
        debugger;
        var cname = '<%=Request.QueryString["CName"].ToString()%>';
        $('#binddata').html('');
        $('#binddata').append(cname);
    });
</script>
