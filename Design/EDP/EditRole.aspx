<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" CodeFile="EditRole.aspx.cs" Inherits="Design_EDP_EditRole" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />




    <%: Scripts.Render("~/bundles/JQueryUIJs") %>

    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript">
        debugger;
        var id;
        var tmppath = "";
        var reader = new FileReader();
        var fileName;
        var contentType;
        var Remove = 0;
        $(document).ready(function () {
            clearform();
            $(document).on('click', ".lnkedit", function () {
                id = $(this).data("id");
                ShowDetails(id);
                //$("#txtUserName").focus();
            });
            $('#fuimg').change(function (event) {
                if (typeof (FileReader) != "undefined") {
                    var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.jpg|.jpeg|.gif|.png|.bmp)$/;
                    $($(this)[0].files).each(function () {
                        var file = $(this);
                        if (regex.test(file[0].name.toLowerCase())) {
                            fileName = file[0].name;
                            contentType = file[0].type;
                            reader.readAsDataURL(file[0]);
                            tmppath = URL.createObjectURL(event.target.files[0]);
                            var imgp = event.target.baseURI;
                            $('#imgPath').val(imgp);
                            $("#Image1").fadeIn("fast").attr('src', tmppath);
                            Remove = 0;re
                        } else {
                            alert(file[0].name + " is not a valid image file.");
                            return false;
                        }
                    });
                } else {
                    alert("This browser does not support HTML5 FileReader.");
                }

            });
        });
        function clearform() {
            $('#imgPath').val('');
            $('#RID').val('');
            $('#txtRole').val('');
            $('#txtColor').val('');
            document.getElementById('Image1').src = '';
            $('#btnsave').val('Save');
            fileName = "";
            contentType = "";
            $("#chkactive").prop("checked", true);
            Remove = 0;
            document.getElementById("btnRemoveImage").disabled = true;
        }
        function Cancel() {
            clearform();
        }
        function ShowDetails(id) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditRole.aspx/GetById",
                data: JSON.stringify({ id: id }),
                dataType: "json",
                success: function (response) {
                    setValues(response);
                }
            });
        }
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
        function Save() {
            var byteData = reader.result;
            var active = 0;
            if (byteData != null)
                byteData = byteData.split(';')[1].replace("base64,", "");
            if ($(chkactive).prop("checked") == true)
                active = 1;
            if ($('#txtRole').val() == "") { showmsg("Please fill role..!"); return; }
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditRole.aspx/Save",
                data: JSON.stringify({ id: $('#RID').val(), role: $('#txtRole').val(), backcolor: $('#txtColor').val(), imagepath: fileName, FBytes: byteData, ContentType: contentType, active: active,remove:Remove }),
                dataType: "json",
                success: function (response) {
                    if (response.d == "Success") {
                        if ($('#RID').val() != "")
                            showmsg("Record Updated..!");
                        else
                            showmsg("Record Saved..!");

                        clearform();
                    }
                    else {
                        showerrormsg("Some Error Occured..!");
                    }
                }
            });
        }
        function RemoveImage() {
            $('#imgPath').val('');
            document.getElementById('Image1').src = '';
            fileName = "";
            contentType = "";
            Remove = 1;
        }
        function setValues(response) {
            RoleData = $.parseJSON(response.d);
            if (response.d != "") {
                $('#RID').val(RoleData[0].ID);
                $('#txtRole').val(RoleData[0].RoleName);
                $('#txtColor').val(RoleData[0].Background);
                document.getElementById('Image1').src = '../..' + RoleData[0].Image;
                if (RoleData[0].Image != "") document.getElementById("btnRemoveImage").disabled = false;
                $('#imgPath').val(RoleData[0].Image);
                $("#chkactive").prop("checked", true)
                fileName = "";
                contentType = "";
                $('#btnsave').val('Update');
            }
        }
        function BindGrid() {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditRole.aspx/BindGrid",
                data: "{}",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: FillJsonXML
            });
            function FillJsonXML(data) {
                RoleData = $.parseJSON(data.d);
                $("#gv").empty();
                if (RoleData.length > 0) {
                    $("#gv").append("<thead><tr><th  class='GridViewHeaderStyle'>Sr.No</th><th  class='GridViewHeaderStyle'>RoleName</th><th style='display:none'>Image</th><th class='GridViewHeaderStyle'>Background</th>"
                    + "<th class='GridViewHeaderStyle'>Select</th></tr></thead>");
                    for (var i = 0; i < RoleData.length; i++) {
                        imgpath = '../..' + RoleData[i].Image;
                        $("#gv").append("<tr><td class='center'>" + (i + 1) + "</td><td class='center'>" + RoleData[i].RoleName + "</td>" +
                               //"<td>" + RoleData[i].Image + "</td>" +
                                "<td style='display:none'><img width='10%' height='5%' src='" + imgpath + "' ></td>" +
                               "<td>" + RoleData[i].Background + "</td>" +
                               "<td><a class='lnkedit' data-id='" + RoleData[i].ID + "' href='javascript:void(0);' title='Edit' class='close' data-dismiss='modal'><img  class='lnkedit' data-id='" + RoleData[i].ID + "' width='35%' height='50%' src='../../App_Images/NewImages/edit-ico.png' style=''></a></td></tr>");
                    }

                }
                else {
                    $("#gv").append("<thead><tr><th>Role List</th></tr></thead>");
                    $("#gv").append("<tr><td>There is No List</td></tr>");
                }
            }
        }

    </script>

    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 900px">

        <div class="POuter_Box_Inventory" style="text-align: center; width: 895px">
            <b>Role Master</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left; width: 895px">
        <div class="row">
            <div class="col-md-6" >
                <label class="labelForPO">
                    Role :</label>
            </div>
            <div class="col-md-5">
                <input id="RID" type="text" style="display: none" />
                <input type="text" value="0" id="txtRole" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <label class="labelForPO">Select Image:</label>
            </div>
            <div class="col-md-5">
                <%--<asp:FileUpload ID="FuImage" runat="server" />--%>
                <input type="file" id="fuimg" />
                <input id="imgPath" style="display: none" />
            </div>
             <div class="col-md-3">
                    <input type="button" id="btnRemoveImage" value="Remove Image" onclick="RemoveImage()" disabled="disabled"/>
                </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <label class="labelForPO">Background Color(#000000) :</label>
            </div>
            <div class="col-md-5">
                <input type="text" value="0" autocomplete="off" id="txtColor" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-9">
                <p style="font-weight: bold; text-align: left">
                    Image Size :10-20 KB,<br />
                    Image Type:png,
                    <br />
                    Max Dimension:32px*32px
                </p>
            </div>
            <div class="col-md-12">
                <img src="" id="Image1" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-5">

                <input type="button" onclick="BindGrid()" value="Search" />
                <input type="button" id="btnsave" value="Save" onclick="Save()" />
                <input type="button" id="btnCancel" value="Cancel" onclick="Cancel()" />
            </div>
            <div class="col-md-3">
                <input type="checkbox" id="chkactive" name="IsActive" />Active
            </div>
        </div>
        </div>


    <div class="POuter_Box_Inventory" style="width: 895px">
        <div class="Purchaseheader"><b>Role List</b></div>
        <div class="row">
            <div class="col-md-24">
                <div class="TestDetail" style="margin-top: 5px; max-height: 500px; overflow: scroll; width: 100%;">
                    <table id="gv" cellspacing="0" rules="all" border="1" style="width: 876px; height: auto; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th class='GridViewHeaderStyle'>Sr.No</th>
                                <th class='GridViewHeaderStyle'>RoleName</th>
                                <th class='GridViewHeaderStyle'>Background</th>
                                <th class='GridViewHeaderStyle' style="display: none">Image</th>

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
</asp:Content>
