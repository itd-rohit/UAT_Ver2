<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="AnswerTicket.aspx.cs" Inherits="Design_Support_AnswerTicket" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">   
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>View Support Ticket # <%=Util.GetString(dt.Rows[0]["IssueCode"]) %></b>
            <br />
            <b style="color: red">
                <asp:Label ID="lblError" runat="server"></asp:Label></b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left"><b>Employee ID</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <%=dt.Rows[0]["EmpId"]%>
                </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Employee Name</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <%=dt.Rows[0]["EmpName"]%>
                </div>
                <div class="col-md-2">
                    <label class="pull-left"><b>Status</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3" id="tdStatus">
                    <%=Util.GetString(dt.Rows[0]["Status"]) %>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left"><b>BarCode No.</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <%=Util.GetString(dt.Rows[0]["VialId"]) %>
                </div>
                <div class="col-md-3">
                    <label class="pull-left"><b>Visit No.</b>  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <%=Util.GetString(dt.Rows[0]["RegNo"]) %>
                </div>
               <div class="col-md-2">
                    <label class="pull-left"><b>Client Code</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <%=Util.GetString(dt.Rows[0]["Panel_Code"]) %>
                </div>

            </div>
            <div class="row">                
                <div class="col-md-3">
                    <label class="pull-left"><b>Date</b>  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <%=Util.GetString(dt.Rows[0]["dtAdd"]) %>
                </div>
              <div class="col-md-3">
                    <label class="pull-left"><b>Subject</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-13">
                    <%=Util.GetString(dt.Rows[0]["Subject"]) %>
                </div>
            </div>          
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left"><b>Detail</b></label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-21">
                    <div class="messBox" style="overflow: auto; max-height: 200px;">
                        <%=dt.Rows[0]["Message"]%>
                    </div>
                </div>
            </div>
        </div>
        <%if (Reply.Rows.Count > 0)
          { %>
        <div class="POuter_Box_Inventory">
            <div class="content" style="padding: 2%;" id="replyBox">
                <%foreach (System.Data.DataRow dr in Reply.Rows)
                  { %>
                <div>
                    <strong style="">
                        <%=Util.GetString(dr["EmpName"] )%><span style="float: right"> Date:&nbsp;<%=Util.GetString(dr["dtEntry"] )%></span></strong>

                    <p style="margin-top: 0px;">
                        <%if (Util.GetString(dr["Panel_ID"]) != "")
                          { %>
                        <span>PCC</span>
                        <%}
                          else
                          { %>
                        <span>SUPPORT</span>
                        <%} %>
                    </p>


                    <p>
                        <p class="messBox" style="overflow: auto; max-height: 200px;">
                            <%=Util.GetString(dr["Answer"])%>
                        </p>
                        <p>
                            <%if (Util.GetString(dr["FileId"]) != "")
                              { %>
                            <%for (int i = 0; i <= Util.GetString(dr["FileId"]).Split(',').Length - 1; i++)
                              {%>
                            <a style="cursor: pointer" href="Download.aspx?FileId=<%=Util.GetString(dr["FileId"]).Split(',')[i] %>" target="_blank">
                                <img src="../../App_Images/attachment.png" alt="" />
                                <%=Util.GetString(dr["FileName"]).Split(',')[i] %></a>
                            <br />
                            <%  } %>


                            <%} %>
                        </p>
                    </p>

                </div>
                <hr />
                <%} %>
            </div>
        </div>
        <%} %>

        <div class="POuter_Box_Inventory" runat="server" id="NotForPcc">

            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Predefind Response   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:DropDownList ID="ddlQueries" runat="server" CssClass="chosen-select"></asp:DropDownList>

                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Reply   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:TextBox ID="txtRply" TextMode="MultiLine" Rows="5" Style="width: 100%; height: 20%" runat="server" Columns="20"></asp:TextBox>
                </div>

            </div>


            <div class="row">
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Upload File   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <asp:FileUpload ID="fu_file" runat="server" />
                </div>

            </div>

            <div style="text-align: center">
                <div id="NotForForward" runat="server" style="display: inline-block">
                    <asp:Button CssClass="ItDoseButton" ID="btnResolved" runat="server" Text="Resolved" OnClick="btnResolved_Click" Visible="false" />
                    <asp:Button CssClass="ItDoseButton" ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
                    
                 <asp:Button ID="btnClose" CssClass="ItDoseButton" runat="server" Text="Close" OnClick="btnClose_Click" Visible="false" />
                </div>
                <div style="display: inline-block">
                    <asp:Button ID="btnForward" CssClass="ItDoseButton" runat="server" Text="Forward" OnClick="btnForward_Click" Visible="false" />
                </div>
                <div id="ForForward" runat="server" style="display: inline-block; margin-bottom: 20px; margin-left: -13%; text-align: left" visible="false">
                    <strong>Forward To role:</strong>
                    <asp:ListBox runat="server" ID="ddlRoles" SelectionMode="Multiple" data-placeholder="Select Role..." Width="310px" CssClass="chosen-select" multiple="true"></asp:ListBox>
                    <asp:HiddenField ID="hdnRoles" runat="server" />
                    <asp:Button ID="btnSaveForward" CssClass="ItDoseButton" runat="server" Text="Save" OnClick="btnSaveForward_Click" />
                    <asp:Button ID="btnCancelForward" CssClass="ItDoseButton" runat="server" Text="Cancel" OnClick="btnCancelForward_Click" />
                </div>
            </div>
        </div>


    </div>

        <script type="text/javascript">
            var id = "";
            var ans = "";
            var UserId = "";

            $(function () {
                $('#mastertopcorner').hide();
                $('#masterheaderid').hide();
                CheckReadStatus('<%=Common.DecryptRijndael(Request.QueryString["TicketId"].Replace(" ", "+"))%>');
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            $("#<%=ddlQueries.ClientID%>").chosen().change(function () {
                if ($('#<%=ddlQueries.ClientID%> option:selected').val() != "") {

                    serverCall('Services/Support.asmx/GetQueryDescription', { QueryId: $('#<%=ddlQueries.ClientID%> option:selected').val() }, function (response) {
                        var $responseData = JSON.parse(response);
                        if (response != "") {
                            $('#<%=txtRply.ClientID%>').val($responseData[0].Detail);
                        }
                    });
                }
                else {

                    $('#<%=txtRply.ClientID%>').val('');
                }
            });

            UserId = '<%=Util.GetString(Session["ID"])%>';
            id = '<%=Util.GetString(Request.QueryString["TicketId"])%>';

            $("#<%=ddlRoles.ClientID%>").chosen().change(function (e, params) {
                $('#<%=hdnRoles.ClientID%>').val($("#<%=ddlRoles.ClientID%>").chosen().val());

           });
        });
       function CheckReadStatus(ItemId) {
           serverCall('Services/Support.asmx/CheckReadStatus', { ItemId: ItemId }, function (response) {
           });



       }
    </script>

</asp:Content>

