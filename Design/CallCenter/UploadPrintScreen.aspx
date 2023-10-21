<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="UploadPrintScreen.aspx.cs" Inherits="Design_CallCenter_UploadDocument" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory" style="width: 884px">
        <div class="POuter_Box_Inventory" style="width: 880px; text-align: center">
            <div class="Purchaseheader">Upload print screen Attachment</div>
           <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label><br />
            <table style="width: 100%; border-collapse: collapse">
                 <tr>                     
                    <td style="width: 50%; text-align: left">                       
                        <canvas  runat="server" ClientIDMode="Static" id="canvas_printSrc" width="875" height="400" style="border: 1px solid #ccc;   background: #ffffff url(../../App_Images/paste-here.gif) no-repeat center center;"></canvas>
                        <asp:HiddenField ID="imageurl" runat="server" ClientIDMode="Static" />
                          <asp:HiddenField ID="IsPaste" runat="server" ClientIDMode="Static" Value="0" />
                    </td>
                </tr>
 
                <tr>                     
                    <td style="width: 50%; text-align: center">
                        <asp:Button ID="btnSave" runat="server" Text="Upload" CssClass="savebutton" OnClick="btnSave_Click" OnClientClick="return validate();" />
                    </td>
                </tr>
               
           
            </table>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td>


                        <asp:GridView ID="grvAttachment" runat="server" AutoGenerateColumns="False"
                            CellPadding="4" ForeColor="#333333" GridLines="None" Style="width: 99%;" OnRowCommand="grvAttachment_RowCommand" EnableModelValidation="True">
                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                            <Columns>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgRemove" ValidationGroup="a" CausesValidation="false" CommandName="Remove" CommandArgument='<%#Eval("ID") %>' ImageUrl="~/App_Images/Delete.gif" runat="server" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="25px" />
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <a target="_self" href='../Lab/DownloadAttachment.aspx?FileName=<%# Eval("AttachedFile")%>&Type=3&FilePath=<%# Eval("FileUrl")%>'><%# Eval("AttachedFile")%></a>
                                        <asp:Label ID="lblPath" runat="server" Text='<%# Eval("AttachedFile")%>' Style="display: none;"></asp:Label>


                                    </ItemTemplate>
                                </asp:TemplateField>


                                <asp:BoundField DataField="UploadedBy" HeaderText="Uploaded By" ItemStyle-Width="150px">
                                    <ItemStyle Width="150px"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="dtEntry" HeaderText="Date" ItemStyle-Width="100px">


                                    <ItemStyle Width="100px"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField />


                            </Columns>
                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White"
                                HorizontalAlign="Left" />
                            <EditRowStyle BackColor="#999999" />
                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                        </asp:GridView>

                    </td>
                </tr>
            </table>
        </div>

    </div>
    <script type="text/javascript">
        (function ($) {
            var defaults;
            $.event.fix = (function (originalFix) {
                return function (event) {
                    event = originalFix.apply(this, arguments);
                    if (event.type.indexOf('copy') === 0 || event.type.indexOf('paste') === 0) {
                        event.clipboardData = event.originalEvent.clipboardData;
                    }
                    return event;
                };
            })($.event.fix);
            defaults = {
                callback: $.noop,
                matchType: /image.*/
            };
            return $.fn.pasteImageReader = function (options) {
                if (typeof options === "function") {
                    options = {
                        callback: options
                    };
                }
                options = $.extend({}, defaults, options);
                return this.each(function () {
                    var $this, element;
                    element = this;
                    $this = $(this);
                    return $this.bind('paste', function (event) {
                        var clipboardData, found;
                        found = false;
                        clipboardData = event.clipboardData;
                        return Array.prototype.forEach.call(clipboardData.types, function (type, i) {
                            var file, reader;
                            if (found) {
                                return;
                            }
                            if (type.match(options.matchType) || clipboardData.items[i].type.match(options.matchType)) {
                                file = clipboardData.items[i].getAsFile();
                                reader = new FileReader();
                                reader.onload = function (evt) {
                                    return options.callback.call(element, {
                                        dataURL: evt.target.result,
                                        event: evt,
                                        file: file,
                                        name: file.name
                                    });
                                };
                                reader.readAsDataURL(file);
                                return found = true;
                            }
                        });
                    });
                });
            };
        })(jQuery);

        $("html").pasteImageReader(function (results) {
            var dataURL, filename;
            filename = results.filename, dataURL = results.dataURL;
            $data.text(dataURL);
            $size.val(results.file.size);
            $type.val(results.file.type);
            $test.attr('href', dataURL); 
            CanvasLoadImage(dataURL)
            $('#imageurl').val(dataURL);
            $('#IsPaste').val("1");
            $('#canvas_printSrc').sketch();
        });

        var $data, $size, $type, $test, $width, $height;
        $(function () {
            $data = $('.data');
            $size = $('.size');
            $type = $('.type');
            $test = $('#test');
            $width = $('#width');
            $height = $('#height');
           

            $('form').submit(function () {
                var PrtSrcCanvas = $('#canvas_printSrc')[0];
                var PrtSrcimage = PrtSrcCanvas.toDataURL();    
                if ( $('#IsPaste').val() =="0") {
                    alert('Image Not Found.');
                    return false;
                }
                else {
                    $('#imageurl').val('');
                    $('#imageurl').val(PrtSrcimage);
                    $('#IsPaste').val("0");                  
                }
            });
        });

        function CanvasLoadImage(img) {
            var prtscrcanvas = document.getElementById('canvas_printSrc');
            context = prtscrcanvas.getContext('2d');
            var b_image = new Image();
            b_image.src = img;
            b_image.onload = function () {
                context.drawImage(
                    b_image,
                    0,
                    0,
                    prtscrcanvas.offsetWidth,
                    prtscrcanvas.offsetHeight
                );
            };
        }

    </script>
</asp:Content>


