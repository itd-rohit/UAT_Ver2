<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" CodeFile="MakeMenu.aspx.cs" Inherits="Design_EDP_MakeMenu" %>

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
        var RImage = 0;
        var EditImage = "";
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
                            document.getElementById("btnRemoveImage").disabled = false;
                            RImage = 0;
                        } else {
                            toast("Error",file[0].name + " is not a valid image file.");
                            return false;
                        }
                    });
                } else {
                    toast("Error","This browser does not support HTML5 FileReader.");
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
            document.getElementById("btnRemoveImage").disabled = true;
            RImage = 0;
        }
        function Cancel() {
            clearform();
        }
        function ShowDetails(id) {
            serverCall('MakeMenu.aspx/GetById', { id: id }, function (response) {
                setValues(response);
            });
        }
      
        function Save() {
            debugger;
            var byteData = reader.result;
            var active = 0;
            if (byteData != null)
                byteData = byteData.split(';')[1].replace("base64,", "");
            else
                byteData = EditImage;
            if ($(chkactive).prop("checked") == true)
                active = 1;
            if ($('#txtRole').val() == "") { toast("Error", "Please fill menu..!"); return; }
            serverCall('MakeMenu.aspx/Save', { id: $('#RID').val(), role: $('#txtRole').val(), backcolor: $('#txtColor').val(), imagepath: fileName, FBytes: byteData, ContentType: contentType, active: active,RImage:RImage}, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    if ($('#RID').val() != "")
                        toast("Info","Record Updated..!");
                    else
                        toast("Info", "Record Saved..!");

                    clearform();
                }
                else {
                    toast("Error","Some Error Occured..!");
                }
            });
        }
        function setValues(response) {
            RoleData = $.parseJSON(response);
            if (response.d != "") {
                $('#RID').val(RoleData[0].ID);
                $('#txtRole').val(RoleData[0].MenuName);
                $('#txtColor').val(RoleData[0].Priority);
                if (RoleData[0].Image != "" && RoleData[0].Image != null) {
                    document.getElementById('Image1').setAttribute('src', RoleData[0].Image);
                    document.getElementById("btnRemoveImage").disabled = false;
                    EditImage = RoleData[0].Image;
                }
                
                $("#chkactive").prop("checked", true)
                fileName = "";
                contentType = "";
                $('#btnsave').val('Update');
            }
        }
        function RemoveImage() {
            $('#imgPath').val('');
            document.getElementById('Image1').src = '';
            fileName = "";
            contentType = "";
            document.getElementById("btnRemoveImage").disabled = true;
            RImage = 1;
        }
        function BindGrid() {
          
            serverCall('MakeMenu.aspx/BindGrid', {}, function (response) {
                RoleData = $.parseJSON(response);
                $("#gv").empty();
                if (RoleData.length > 0) {
                    $("#gv").append("<thead><tr><th  class='GridViewHeaderStyle'>Sr.No</th><th  class='GridViewHeaderStyle'>MenuName</th><th class='GridViewHeaderStyle'>Priority</th>"
                    + "<th class='GridViewHeaderStyle'>Select</th></tr></thead>");
                    for (var i = 0; i < RoleData.length; i++) {
                        imgpath = '../..' + RoleData[i].Image;
                        $("#gv").append("<tr><td class='center'>" + (i + 1) + "</td><td class='center'>" + RoleData[i].MenuName + "</td>" +
                               "<td>" + RoleData[i].Priority + "</td>" +
                               "<td><img  class='lnkedit' data-id='" + RoleData[i].ID + "'  src='../../App_Images/edit.png' style='cursor:pointer;'></td></tr>");
                    }

                }
                else {
                    $("#gv").append("<thead><tr><th>Role List</th></tr></thead>");
                    $("#gv").append("<tr><td>There is No List</td></tr>");
                }
            });
        }

    </script>

    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory" style="width: 900px">
        <div class="POuter_Box_Inventory" style="text-align: center; width: 895px">
            <b>Menu Master</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left; width: 895px">
            <div class="row">
                <div class="col-md-3">
                    <label class="labelForPO">
                        Menu :</label>
                </div>
                <div class="col-md-5">
                    <input id="RID" type="text" style="display: none" />
                    <input type="text" value="0" id="txtRole" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="labelForPO">Select Image:</label>
                </div>
                <div class="col-md-5">
                    <input type="file" id="fuimg" />
                </div>
                <div class="col-md-3">
                    <input type="button" id="btnRemoveImage" value="Remove Image" onclick="RemoveImage()" disabled="disabled" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="labelForPO">Priority :</label>
                </div>
                <div class="col-md-5">
                    <input type="text" value="0" onlynumber="10" maxlength="3" autocomplete="off" id="txtColor" />
                </div>
                <div class="col-md-5">
                    <asp:Label ID="lblPrOrder" runat="server"></asp:Label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-9">
                    <p style="font-weight: bold; text-align: left">
                        Image Size :2-4 KB,<br />
                        Image Type:png,
                    <br />
                        Max Dimension:32px*32px
                    </p>
                </div>
                <div class="col-md-12">
                    <img src="" id="Image1" width="200px" />
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


        <%-- </div>
    </div>--%>
        <div class="POuter_Box_Inventory" style="width: 895px">
            <div class="Purchaseheader"><b>Menu List</b></div>
            <div class="row">
                <div class="col-md-24">
                    <div class="TestDetail" style="margin-top: 5px; max-height: 500px; overflow: scroll; width: 100%;">
                        <table id="gv" cellspacing="0" rules="all" border="1" style="width: 876px; border-collapse: collapse;">
                            <thead>
                                <tr>
                                    <th class='GridViewHeaderStyle'>Sr.No</th>
                                    <th class='GridViewHeaderStyle'>MenuName</th>
                                    <th class='GridViewHeaderStyle'>Priority</th>
                                    <th class='GridViewHeaderStyle'>Select</th>
                                    <%--<th  class='center'>Image</th>--%>
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
