<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MenuMasterNew.aspx.cs" Inherits="Design_EDP_MenuMasterNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Menu Master</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Menu </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtMenuName" MaxLength="20" runat="server"></asp:TextBox>
                    <span id="spnMenuID" style="display: none">0</span>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Select Image </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:FileUpload runat="server" ID="fileUpload" onchange="previewFile()" />

                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnResizeImage" runat="server" Text="ResizeImage" OnClick="btnResizeImage_Click" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Image Preview </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:Image ID="imgPreview" runat="server" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-3">
                    <label class="pull-left">Default Image </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1">
                    <input type="checkbox" id="chkDefaultImage" name="DefaultImage" />
                </div>
                <div class="col-md-3">
                    <asp:Image ID="imgDefault" runat="server" src="data:image/jpg;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAASCAYAAABfJS4tAAAABGdBTUEAALGPC/xhBQAABGlJREFUOE+NVG1Mm1UUvi3jI6AOM7KhiP8MBtwmYSgOREaFjYQREFQQCAwiji+ZlekgsI6vOGUa0USFKMSNjVJGJvgRNhYV1wEOWtqCfLSFAm1pKeVlpS0tBXo8L7KNMZze9Ml93nPO+7z3Puf2MgiO8G5ZhauT8yHXHcwVFyaTuDAJcWIwiSODQXY4EII/wkBOAMga8lVA2IHY7IRY7XayjNy6ZmeYGQzKaGcU9xzwGiXhvYqKaLEW3pRoIE2khHckaij4awY+GNFAyagWzkhnoQJRJdNBpWwWypGfHtNCEebZWJczqIYMsQqSRCqIlxqA9cfokG8Ox5NE9U31Jo0tQMRntdcC4hJqg95IbngpMbkhJDG1ITQpuSEsKXUdhzZA81AEnQ/GuiBE4OuJ9S+kZzXG3xgxRvPHwCfq6PskXqjsypQbIDgzu9GVkEjcqTfi6U3wQu65JbY5T3NvLyfyTGrfxEhCt9TuEx7xEUkaUHXlTixCWO57Le6E7KU93zwAgGm32x/bGt/uOXtUP5DcK4NnWYcrSbpI3cWeNAErj92ykxD/rS90Uub8Ds1Cx559e9weJs75TeFyYkwnPnZLDr608NuD6q5TSjNEbiN8VWPczV8wT0tsAFV19ZX/JXxSOifO6huH5yJQOHtI01WqWoLD2wj3UMZPRlcBJlYA+DKFPpTFWt8Rj8dz6AfAltwbHIXCpVimF+cINoTzhjVdZ9RLEPVu4X1W3Jhf9hMuWo1yyyqoLCtgRLOb2n+8REuJzSsxfP1iE1KnO9K0cKlcL84XTPyz4nwULpt5UJg/b2wdw9UqlpZh3rYKSEE1Ty0XcTiJQ0ZrjwjtKfm6tuiuMHp8GoULhA8R7pw1HeHfttglRisK2+4Jz+mpxrafuqXWNRBY7HBxYES7PzjYjxanm3ef8GYrsO37OgF2ts0uSgdwhSNrAGqcDQgTovXq9W7hzNzyFHIh+t6Nc/mVn2l7mLwhcCpFj+9acXxT8xwJ8WuhbC9f1ty+eaF/UNF8a0DdLpCorkuG1c3Xfh0q/7ymo0epHWwVSKbO94pUdX+K1WVXfpHtDQl6Fb/hsN68/o3m3TluEXlsHp7j5zc8c3NjkhRXR5Lp7EgynJkkw5FJMne5P5qCeT/kaXTMFeGx85Gsp57YnfxKWoH7h+OUgD5u6+c4TaS+yZ4yQdjxvGZ8yef//MP+rebEqE50jBaOOFJFEoXKjtxpM2T9LtKxe4c7zyoo3hdKQ/O3MybuxVkzt2XOwv1Bb+G2UTgjLs+Zmy9hvEFr4n6lXuR+Om3glk0amgrHdO258oXlpB6ZzScktJzECWcCU/onpdl4XRYOzwAHr8Szch3UTMzBN5Pz8N00Bd8rKbigouA8ogF53dQ8fKnQQ/W4bv0aPYVXaP6QGtIHlBZWTT3/yV2Pn1zf1QF2hbd/wlsl/tGx5wJiYqtfjHmtOghxEBES+yAOYozO03WBWB9wNLZ6f3TcOV9W5MdeHh7FXp4eUX8DLU7l7o6y8nQAAAAASUVORK5CYII=" alt="" />

                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-21">
                    <em><span style="color: #0000ff; font-size: 9.5pt">1. Image Size :2-4 KB</span></em>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-21">
                    <em><span style="color: #0000ff; font-size: 9.5pt">2. Image Type:png,jpg,gif</span></em>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-21">
                    <em><span style="color: #0000ff; font-size: 9.5pt">3.Max Dimension:32px*32px</span></em>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Actual Image </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-15">
                    <asp:Image ID="imgActualImg" runat="server" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <asp:TextBox ID="txtBase" runat="server" Style="display: none"></asp:TextBox>
                    
                    
                    <input type="button" id="btnsave" value="Save" onclick="saveMenu()" />
                    <input type="button" id="btnCancel" value="Cancel" onclick="Cancel()" />
                </div>

            </div>
        </div>
    </div>
    <script type="text/javascript">
        function previewFile() {
            var preview = document.querySelector('#<%=imgActualImg.ClientID %>');
            var file = document.querySelector('#<%=fileUpload.ClientID %>').files[0];
            var reader = new FileReader();
            reader.onloadend = function () {
                preview.src = reader.result;
                $("#txtBase").val(reader.result);
            }
            if (file) {
                reader.readAsDataURL(file);
            } else {
                preview.src = "";
            }
        }
        saveMenu = function () {
            if ($('#txtMenuName').val() == "") {
                toast("Error", "Please Enter Menu Name");
                $('#txtMenuName').focus();
                return;
            }
            var DefaultImage = $("#chkDefaultImage").is(":checked") ? 1 : 0;

            var byteData ="";
            if (DefaultImage == 0) {
                if ($.trim($('#imgPreview').attr('src')).length == "0") {
                    toast("Error", "Please Resize Image");
                    $('#btnResizeImage').focus();
                    return;
                }

                byteData = $('#imgPreview').attr('src');
            }
            else {
                byteData = $('#imgDefault').attr('src');
            }


            serverCall('MenuMasterNew.aspx/SaveMenu', { id: $('#spnMenuID').text(), MenuName: $('#txtMenuName').val(), imageData: byteData }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response);
                    clearform();
                }
                else {
                    toast("Error", $responseData.response);
                }
            });
        }
        function clearform() {
            $('#spnMenuID').text('0');
            $('#txtBase,#txtMenuName').val('');
            $('#imgPreview,#imgActualImg').attr('src', '');
            $("#chkDefaultImage").prop("checked", true)
        }
        
        function imgPreviewShow() {

            $('#imgPreview').show();
        }
    </script>
</asp:Content>

