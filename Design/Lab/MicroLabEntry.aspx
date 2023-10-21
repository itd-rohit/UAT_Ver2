<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MicroLabEntry.aspx.cs" Inherits="Design_Lab_MicroLabEntry" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Microbiology Culture MicroScopy,Plating and Incubation </b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="vertical-align: top; margin-left: -18px; margin-right: -20px">
                <div class="col-md-24">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-3" style="color: maroon; font-weight: bold;">
                                    Entry Type:
                                </div>
                                <div class="col-md-3">
                                    <asp:DropDownList ID="ddltype" runat="server">
                                        <asp:ListItem Value="Microscopic">Microscopy</asp:ListItem>
                                        <asp:ListItem Value="Plating">Plating</asp:ListItem>
                                        <asp:ListItem Value="Incubation">Incubation</asp:ListItem>
                                        <asp:ListItem Value="ALL">ALL</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-3" style="color: maroon; font-weight: bold;">
                                    From Date:
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="dtFrom" runat="server" ReadOnly="true"></asp:TextBox>
                                    <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                        TargetControlID="dtFrom"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtFrom" />
                                </div>
                                <div class="col-md-3" style="color: maroon; font-weight: bold;">
                                    To Date:
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="dtTo" runat="server" ReadOnly="true"></asp:TextBox>

                                    <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                        TargetControlID="dtTo"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtTo" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-3" style="color: maroon; font-weight: bold;">
                                    Visit No.:
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtvisitno" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-3" style="color: maroon; font-weight: bold;">
                                    SIN No.:
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtsinno" runat="server"></asp:TextBox>
                                </div>
                                 <div class="col-md-3" style="text-align: center">
                            <input id="btnSearch" type="button" class="searchbutton" value="Search" onclick="searchdata('')" />
                        </div>
                            </div>
                        </div>
                       
                        <div class="row" style="color: maroon; font-weight: bold; text-align: center;">
                            <table>
                                <tr>
                                    <td style="background-color: lightyellow; width: 50px; border: 1px solid black; cursor: pointer;" onclick="searchdata('Pending')"></td>
                                    <td><b>Pending</b></td>
                                    <td style="background-color: pink; width: 50px; border: 1px solid black; cursor: pointer;" onclick="searchdata('Microscopic')"></td>
                                    <td><b>Microscopic</b></td>
                                    <td style="background-color: lightgreen; width: 50px; border: 1px solid black; cursor: pointer;" onclick="searchdata('Plating')"></td>
                                    <td><b>Plating</b></td>
                                    <td style="background-color: #ff00ff; width: 50px; border: 1px solid black; cursor: pointer;" onclick="searchdata('Incubation')"></td>
                                    <td><b>Incubation</b></td>
                                </tr>
                            </table>
                        </div>
                        <div class="row">
                            <div class="Purchaseheader">
                                Search Result&nbsp;&nbsp;&nbsp; <span style="color: red;">Total Patient:</span>
                                <asp:Label ID="lblTotalPatient" Text="0" runat="server" Font-Bold="true" ForeColor="Red"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div id="PatientLabSearchOutput" style="height: 360px; overflow: scroll;">
                                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" width="99%">
                                    <tr id="trheader">
                                        <th class="GridViewHeaderStyle" scope="col" align="left">S.No</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">VisitNo</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">SIN No</th>
										 <th class="GridViewHeaderStyle" scope="col" align="left">Culture No</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">Patient Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">Test Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">Sample Receiving Date and Time</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left"><input type="checkbox" onclick="call()" id="hd" /></th>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-12" style="display:none">
                        <div class="row">
                                <div class="col-md-5" style="color: maroon; font-weight: bold">
                                    Patient Name:
                                </div>
                                <div class="col-md-7" style="font-weight: bold">
                                    <span id="Patinetname"></span>
                                    <span id="sptestid" style="display: none"></span>
                                </div>
                        </div>
                        <div class="row">
                                <div class="col-md-5" style="color: maroon; font-weight: bold">
                                    Age:
                                </div>
                                <div class="col-md-7" style="font-weight: bold">
                                    <span id="Age"></span>
                                </div>
                                <div class="col-md-5" style="color: maroon; font-weight: bold">
                                    Gender:
                                </div>
                                <div class="col-md-7" style="font-weight: bold">
                                    <span id="Gender"></span>
                                </div>
                        </div>
                        <div class="row">
                                <div class="col-md-5" style="color: maroon; font-weight: bold">
                                    Visit No:
                                </div>
                                <div class="col-md-7" style="font-weight: bold">
                                    <span id="VisitNo"></span>
                                </div>
                                <div class="col-md-5" style="color: maroon; font-weight: bold">
                                    SIN No:
                                </div>
                                <div class="col-md-7" style="font-weight: bold">
                                    <span id="SINNo"></span>
                                </div>
                            

                        </div>
                        <div class="row">
                            <div class="col-md-5" style="color: maroon; font-weight: bold">
                                Test Name:
                            </div>
                            <div class="col-md-19" style="font-weight: bold">
                                <span id="TestName"></span>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-5" style="color: maroon; font-weight: bold">
                                Sample Type:
                            </div>
                            <div class="col-md-7" style="font-weight: bold">
                                <span id="SampleType"></span>
                            </div>
                            <div class="col-md-5" style="color: maroon; font-weight: bold">
                                Party Name:
                            </div>
                            <div class="col-md-7" style="font-weight: bold">
                                <span id="PanelName"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-7" style="color: maroon; font-weight: bold">
                                Sample Col. Date:
                            </div>
                            <div class="col-md-5" style="font-weight: bold">
                                <span id="SCDate"></span>
                            </div>
                            <div class="col-md-7" style="color: maroon; font-weight: bold">
                                Sample Rec. Date:
                            </div>
                            <div class="col-md-5" style="font-weight: bold">
                                <span id="SRDate"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5" style="color: maroon; font-weight: bold">
                                Status:
                            </div>
                            <div class="col-md-7" style="font-weight: bold">
                                <span id="Status"></span>
                            </div>
                            <div class="col-md-7" style="color: maroon; font-weight: bold">
                                Last Status Date:
                            </div>
                            <div class="col-md-5" style="font-weight: bold">
                                <span id="StatusDate"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5" style="color: maroon; font-weight: bold">
                                Client:
                            </div>
                            <div class="col-md-19" style="font-weight: bold">
                                <span id="ClientName"></span>
                            </div>
                        </div>
                        <div class="row">
                            <div id="tableMicroScopic" style="display: none;">
                                <div class="Purchaseheader">MicroScopy Detail</div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-7" style="font-weight: bold;">
                                            MicroScopy
                                        </div>
                                        <div class="col-md-15" style="font-weight: bold;">
                                            <asp:DropDownList ID="ddlmicroscopy" runat="server">
                                                <asp:ListItem Value=""></asp:ListItem>
                                                <asp:ListItem Value="Wet Mount">Wet Mount</asp:ListItem>
                                                <asp:ListItem Value="Gram Stain">Gram Stain</asp:ListItem>
                                                <asp:ListItem Value="AFB">AFB Stain</asp:ListItem>
                                                <asp:ListItem Value="Other">Other</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-7" style="font-weight: bold;">
                                            Observation
                                        </div>
                                        <div class="col-md-15" style="font-weight: bold;">
                                            <asp:TextBox ID="txtcomment" runat="server" placeholder="Enter MicroScopy Comment" MaxLength="400"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" style="width: 99%; height: 320px; overflow: auto;">
                                    <table style="width: 99%" cellspacing="0" id="tb_ItemList" class="GridViewStyle">
                                        <tr id="saheader" style="height: 20px;">
                                            <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left; font-size: 13px;">S.No.</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="width: 60%; text-align: left; font-size: 13px;">Observation</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="width: 20%; text-align: left; font-size: 13px;">Value</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="width: 15%; text-align: left; font-size: 13px;">Unit</th>

                                        </tr>
                                    </table>
                                </div>
                                <div class="row" style="text-align: center">
                                    <input id="btnsavemic" type="button" value="Save" class="savebutton" onclick="savemicdata()" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div id="tablePlating" style="display: none;">
                                <div class="Purchaseheader">Plating Detail</div>
                                <div class="row">
                                    <div class="col-md-24" style="font-weight: bold;">
                                        <div class="col-md-5">
                                            Comment:
                                        </div>
                                        <div class="col-md-17" style="font-weight: bold;">
                                            <asp:TextBox ID="txtplatecomment" runat="server" Width="400px" MaxLength="400" placeholder="Enter Plating Comment"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24" style="font-weight: bold;">
                                        <div class="col-md-5">
                                            No of Plate:
                                        </div>
                                        <div class="col-md-17" style="font-weight: bold;">
                                            <asp:DropDownList ID="ddlnoofplate" runat="server" onchange="showplatenumber()" Width="50px">
                                                <asp:ListItem Value="0">0</asp:ListItem>
                                                <asp:ListItem Value="1">1</asp:ListItem>
                                                <asp:ListItem Value="2">2</asp:ListItem>
                                                <asp:ListItem Value="3">3</asp:ListItem>
                                                <asp:ListItem Value="4">4</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" style="height: 100px;">
                                    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="platenumber">
                                        <tr id="phead">
                                            <th class="GridViewHeaderStyle" scope="col" align="left" width="50px">Sr.No.</th>
                                            <th class="GridViewHeaderStyle" scope="col" align="left" width="150px">Plate Number</th>
                                        </tr>
                                    </table>
                                </div>
                                <div class="row" style="text-align: center">
                                    <input id="btnsavepating" type="button" value="Save" class="savebutton" onclick="saveplatdata()" />
                                </div>

                            </div>
                        </div>
                        <div class="row">
                            <div id="tableincubation" style="display: none;">
                                <div class="Purchaseheader">Incubation Detail</div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-7" style="font-weight: bold;">
                                            Incubation Period:
                                        </div>
                                        <div class="col-md-15">
                                            <asp:DropDownList ID="ddlIncubationperiod" runat="server" Width="100">
                                                <asp:ListItem Value=""></asp:ListItem>
                                                <asp:ListItem Value="12">12 Hours</asp:ListItem>
                                                <asp:ListItem Value="24">24 Hours</asp:ListItem>
                                                <asp:ListItem Value="48">48 Hours</asp:ListItem>
                                                <asp:ListItem Value="168">7 Days</asp:ListItem>
                                                <asp:ListItem Value="360">15 Days</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-7" style="font-weight: bold;">
                                            Batch/Rack No.:
                                        </div>
                                        <div class="col-md-15">
                                            <asp:TextBox ID="txtbatch" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-7" style="font-weight: bold;">
                                            Incubation Comment:
                                        </div>
                                        <div class="col-md-15">
                                            <asp:TextBox ID="txtinbcomment" runat="server" Width="400px" placeholder="Enter Incubation Comment" MaxLength="400"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" style="text-align: center">
                                    <input id="btnIncubation" type="button" value="Save" class="savebutton" onclick="saveIncubation()" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div id="tableAll" style="display: none;">
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-12">
                                            <div class="Purchaseheader">MicroScopy</div>
                                            <div class="row" style="display: none;">
                                                <asp:DropDownList ID="ddlmicroscopysaveddata" runat="server">

                                                    <asp:ListItem Value="Wet Mount">Wet Mount</asp:ListItem>
                                                    <asp:ListItem Value="Gram Stain">Gram Stain</asp:ListItem>
                                                    <asp:ListItem Value="AFB">AFB</asp:ListItem>
                                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                            <div class="row" style="display: none;">
                                                <asp:TextBox ID="txtcommentsaved" runat="server" MaxLength="400"></asp:TextBox>
                                            </div>
                                            <div class="row" style="width: 99%; height: 250px; overflow: auto;">
                                                <table style="width: 99%" cellspacing="0" id="tb_ItemList1" class="GridViewStyle">
                                                    <tr id="saheader1" style="height: 20px;">
                                                        <th class="GridViewHeaderStyle" scope="col" style="width: 5%; text-align: left; font-size: 13px;">S.No.</th>
                                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50%; text-align: left; font-size: 13px;">Observation</th>
                                                        <th class="GridViewHeaderStyle" scope="col" style="width: 30%; text-align: left; font-size: 13px;">Value</th>
                                                        <th class="GridViewHeaderStyle" scope="col" style="width: 15%; text-align: left; font-size: 13px;">Unit</th>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <div class="Purchaseheader">Plating</div>
                                            <div class="row">
                                                <div class="col-md-24">
                                                    <div class="col-md-5" style="text-align: center;">
                                                        Comment:
                                                    </div>
                                                    <div class="col-md-19" style="font-weight: bold;">
                                                        <asp:TextBox ID="txtplatecommentsaved" runat="server" Width="65%" MaxLength="400"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-24">
                                                    <div class="col-md-5" style="text-align: center;">
                                                        No of Plate:
                                                    </div>
                                                    <div class="col-md-19">
                                                        <asp:DropDownList ID="ddlnoofplatesaved" runat="server" onchange="showplatenumbersaved()" Width="50px">

                                                            <asp:ListItem Value="1">1</asp:ListItem>
                                                            <asp:ListItem Value="2">2</asp:ListItem>
                                                            <asp:ListItem Value="3">3</asp:ListItem>
                                                            <asp:ListItem Value="4">4</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height: 95px; overflow: auto;">
                                                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="platenumbersaved">
                                                    <tr id="phead1">
                                                        <th class="GridViewHeaderStyle" scope="col" align="left" width="50px">Sr.No.</th>
                                                        <th class="GridViewHeaderStyle" scope="col" align="left" width="150px">Plate Number</th>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="Purchaseheader">Incubation</div>
                                            <div class="row">
                                                <div class="col-md-24">
                                                    <div class="col-md-10" style="font-weight: bold;">
                                                        Incubation Period:
                                                    </div>
                                                    <div class="col-md-14">
                                                        <asp:DropDownList ID="ddlIncubationperiodsaved" runat="server" Width="80">

                                                            <asp:ListItem Value="12">12 Hours</asp:ListItem>
                                                            <asp:ListItem Value="24">24 Hours</asp:ListItem>
                                                            <asp:ListItem Value="48">48 Hours</asp:ListItem>
                                                            <asp:ListItem Value="168">7 Days</asp:ListItem>
                                                            <asp:ListItem Value="360">15 Days</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-24">
                                                    <div class="col-md-10" style="font-weight: bold;">
                                                        Batch/Rank No:
                                                    </div>
                                                    <div class="col-md-14">
                                                        <asp:TextBox ID="txtbatchsaved" runat="server" Width="40%"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-24">
                                                    <div class="col-md-10" style="font-weight: bold;">
                                                        Comment:
                                                    </div>
                                                    <div class="col-md-14">
                                                        <asp:TextBox ID="txtinbcommentsaved" runat="server" Width="60%" placeholder="Enter Incubation Comment" MaxLength="400"></asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-7" style="font-weight: bold">
                                            MicroScopy Done By:
                                        </div>
                                        <div class="col-md-5">
                                            <asp:Label ID="lbmdoneby" runat="server"></asp:Label>
                                        </div>

                                        <div class="col-md-7" style="font-weight: bold">
                                            Done Date:
                                        </div>
                                        <div class="col-md-5">
                                            <asp:Label ID="lbmdonedate" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-7" style="font-weight: bold">
                                            Plating Done By:
                                        </div>
                                        <div class="col-md-5">
                                            <asp:Label ID="lbpladoby" runat="server"></asp:Label>
                                        </div>

                                        <div class="col-md-7" style="font-weight: bold">
                                            Done Date:
                                        </div>
                                        <div class="col-md-5">
                                            <asp:Label ID="lbpladodate" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-7" style="font-weight: bold">
                                            Incubation Done By:
                                        </div>
                                        <div class="col-md-5">
                                            <asp:Label ID="lbinby" runat="server"></asp:Label>
                                        </div>
                                        <div class="col-md-7" style="font-weight: bold">
                                            Done Date:
                                        </div>
                                        <div class="col-md-5">
                                            <asp:Label ID="lbindate" runat="server"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" style="text-align:center;">
                                    <input id="btnupdatealldate" type="button" value="Update" class="savebutton" onclick="updatealldata()" />
                                </div>


                            </div>



                        </div>



                    </div>
                    
                </div>
            </div>

        </div>

         <div style="text-align:center">
              <input id="btnfinalsave" type="button" value="CultureStart" class="savebutton" onclick="savefinaldata()" />
         </div>          
    </div>

    <select size="4" style="position: absolute; max-height: 100px; overflow: auto; display: none;" class="helpselect" onkeyup="addtotext1(this,event)" ondblclick="addtotext(this)">
    </select>

    <%-- Search and View data--%>
    <script type="text/javascript">
        var mouseX;
        var mouseY;
        $(document).mousemove(function (e) {
            mouseX = e.pageX;
            mouseY = e.pageY;
        });


        function addtotext(obj) {

            var id = $(obj).attr("id");
            var mm = id.split('_')[1];
            $('.' + mm).val($(obj).val());
            $('.' + mm).focus();

            $('.helpselect').hide();
            $('.helpselect').removeAttr("id");
        }

        function addtotext1(obj, event) {
            if (event.keyCode == 13) {
                var id = $(obj).attr("id");
                var mm = id.split('_')[1];
                $('.' + mm).val($(obj).val());
                $('.' + mm).focus();

                $('.helpselect').hide();
                $('.helpselect').removeAttr("id");
            }
        }


        call = function () {
            if ($('#hd').prop('checked') == true) {
                $('#tb_grdLabSearch tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "trheader") {
                        $(this).closest("tr").find('#mmchk').prop('checked', true);
                    }
                });
            }
            else {
                $('#tb_grdLabSearch tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "trheader") {
                        $(this).closest("tr").find('#mmchk').prop('checked', false);
                    }
                });
            }
        }
        function $getdata() {
            debugger;
                var culturedata = new Array();
                $('#tb_grdLabSearch tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "trheader") {

                        var plo = new Object();
                        plo.Test_ID = $(this).closest("tr").find('#Test_ID').html();
                        plo.LedgerTransactionNo = $(this).closest("tr").find('#trlabno').html();
                        plo.BacrodeNo = $(this).closest("tr").find('#trbarcodeno').html();
                        culturedata.push(plo);
                    }
                });

                return culturedata;
            
        }
        function savefinaldata() {
            var $data = $getdata();
            if ($data.length == 0) {
                toast("Error", "Please select checkbox to start culture", "");
                return;
            }
            serverCall('MicroLabEntry.aspx/savefinaldata', { data: $data }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                    searchdata();
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
        function _showhideList(help, ctr) {


            if ($('.helpselect').css('display') == 'none') {

                var ddlDoctor = $(".helpselect");
                $(".helpselect option").remove();

                for (i = 0; i < help.split('|').length; i++) {

                    ddlDoctor.append($("<option></option>").val(help.split('|')[i]).html(help.split('|')[i]));
                }


                $('.helpselect').css({ 'top': parseInt(mouseY) + 16, 'left': parseInt(mouseX) - 100 }).show();
                $('.helpselect').attr("id", "help_" + ctr);
                $('.helpselect :first-child').attr('selected', true);
            } else {
                $(".helpselect option").remove();
                $('.helpselect').hide();
                $('.helpselect').removeAttr("id");
                $('.helpselect').prop('selectedIndex', 0);
            }

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
        function searchdata(type) {
            $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            $('#tb_grdLabSearch tr').slice(1).remove();


            var searchdata = searchingvalues(type);
            clearform();
            $modelBlockUI();
            $.ajax({
                url: "MicroLabEntry.aspx/SearchData",
                data: JSON.stringify({ searchdata: searchdata }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    if (TestData == "-1") {
                        $modelUnBlockUI();
                        $('#btnSearch').removeAttr('disabled').val('Search');
                        showerrormsg("Your Session Has Been Expired! Please Login Again");
                        return;
                    }
                    if (TestData.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').html('0');

                    }
                    else {
                        $('#<%=lblTotalPatient.ClientID%>').text(TestData.length);
                        for (var i = 0; i <= TestData.length - 1; i++) {
                            var mydata = "<tr  id='" + TestData[i].Test_ID + "'  style='cursor:pointer;background-color:" + TestData[i].rowcolor + ";height:25px;'>";//onclick='showdetail(this)' title='Please Click To Proceed'
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;">' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="trlabno" >' + TestData[i].LedgerTransactionNo + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="trbarcodeno">' + TestData[i].BarcodeNo + '</td>';
							mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="trbarcodeno">' + TestData[i].Cultureno + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="trpname">' + TestData[i].PName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="trtestname">' + TestData[i].Name + '</td>';
                            mydata += '<td style="display:none;" id="trSampleTypeName">' + TestData[i].SampleTypeName + '</td>';
                            mydata += '<td style="display:none;" id="trPanelName">' + TestData[i].PanelName + '</td>';
                            mydata += '<td style="display:none;" id="trAge">' + TestData[i].Age + '</td>';
                            mydata += '<td style="display:none;" id="trGender">' + TestData[i].Gender + '</td>';
                            mydata += '<td style="display:none;" id="trSampleCollectionDate">' + TestData[i].SampleCollectionDate + '</td>';
                            mydata += '<td style="GridViewLabItemStyle;" id="trSampleReceiveDate">' + TestData[i].SampleReceiveDate + '</td>';
                            mydata += '<td style="display:none;" id="trCultureStatusDate">' + TestData[i].CultureStatusDate + '</td>';
                            mydata += '<td style="display:none;" id="trCultureStatus">' + TestData[i].CultureStatus + '</td>';
                            mydata += '<td style="display:none;" id="trreportstatus">' + TestData[i].reportstatus + '</td>';

                            mydata += '<td style="display:none;" id="Test_ID">' + TestData[i].Test_ID + '</td>';
                            mydata += '<td style="display:none;" id="Investigation_ID">' + TestData[i].Investigation_ID + '</td>';
                            mydata += '<td style="display:none;" id="AgeInDays">' + TestData[i].AgeInDays + '</td>';
                            mydata += '<td><input type="checkbox" id="mmchk"/></td>';
                            mydata += "</tr>";
                            $('#tb_grdLabSearch').append(mydata);

                        }

                    }
                    $('#btnSearch').removeAttr('disabled').val('Search');
                    $modelUnBlockUI();

                },
                error: function (xhr, status) {
                    $('#btnSearch').removeAttr('disabled').val('Search');

                }
            });
        }



        function searchingvalues(type) {

            var dataPLO = new Array();
            dataPLO[0] = $('#<%=ddltype.ClientID%>').val();
            dataPLO[1] = $('#<%=dtFrom.ClientID%>').val();
            dataPLO[2] = $('#<%=dtTo.ClientID%>').val();
            dataPLO[3] = $('#<%=txtvisitno.ClientID%>').val();
            dataPLO[4] = $('#<%=txtsinno.ClientID%>').val();
            dataPLO[5] = type;
            return dataPLO;
        }
        var control = "";

        function showdetail(ctrl) {
            control = ctrl;
            $('#Patinetname').html($(ctrl).find('#trpname').html());
            $('#Age').html($(ctrl).find('#trAge').html());
            $('#TestName').html($(ctrl).find('#trtestname').html());
            $('#SCDate').html($(ctrl).find('#trSampleCollectionDate').html());
            $('#SRDate').html($(ctrl).find('#trSampleReceiveDate').html());
            $('#SampleType').html($(ctrl).find('#trSampleTypeName').html());
            $('#PanelName').html($(ctrl).find('#trPanelName').html());
            $('#Gender').html($(ctrl).find('#trGender').html());
            $('#Status').html($(ctrl).find('#trCultureStatus').html());
            $('#StatusDate').html($(ctrl).find('#trCultureStatusDate').html());
            $('#VisitNo').html($(ctrl).find('#trlabno').html());
            $('#SINNo').html($(ctrl).find('#trbarcodeno').html());
            $('#ClientName').html($(ctrl).find('#trPanelName').html());
            $('#sptestid').html($(ctrl).attr("id"));

            if ($(ctrl).find('#trCultureStatus').html() == "") {
                $('#tableMicroScopic').show();
                $('#tablePlating').hide();
                $('#tableincubation').hide();
                $('#tableAll').hide();

                getMicroScopyData($(ctrl).find('#Investigation_ID').html(), $(ctrl).find('#trlabno').html(), $(ctrl).find('#trbarcodeno').html(), $(ctrl).find('#trGender').html(), $(ctrl).find('#AgeInDays').html(), $(ctrl).attr("id"));
            }
            else if ($(ctrl).find('#trCultureStatus').html() == "Microscopic") {
                $('#tableMicroScopic').hide();
                $('#tablePlating').show();
                $('#tableincubation').hide();
                $('#tableAll').hide();
            }
            else if ($(ctrl).find('#trCultureStatus').html() == "Plating") {
                $('#tableMicroScopic').hide();
                $('#tablePlating').hide();
                $('#tableincubation').show();
                $('#tableAll').hide();
            }
            else if ($(ctrl).find('#trCultureStatus').html() == "Incubation") {
                getsaveddata();


                getMicroScopyDataaftersaved($(ctrl).find('#Investigation_ID').html(), $(ctrl).find('#trlabno').html(), $(ctrl).find('#trbarcodeno').html(), $(ctrl).find('#trGender').html(), $(ctrl).find('#AgeInDays').html(), $(ctrl).attr("id"));


                $('#tableMicroScopic').hide();
                $('#tablePlating').hide();
                $('#tableincubation').hide();
                $('#tableAll').show();
                if ($(ctrl).find('#trreportstatus').html() == "saved") {
                    $('#btnupdatealldate').hide();
                }
                else {
                    $('#btnupdatealldate').show();
                }

            }
        }



        function getMicroScopyData(invid, labno, barcodeno, Gender, AgeInDays, testid) {
            $('#tb_ItemList tr').slice(1).remove();
            $.ajax({
                url: "MicroLabEntry.aspx/getMicroScopyData",
                data: '{invid:"' + invid + '",LabNo:"' + labno + '",barcodeno:"' + barcodeno + '",Gender:"' + Gender + '",AgeInDays:"' + AgeInDays + '",Test_id:"' + testid + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {

                    ObsData = $.parseJSON(result.d);

                    var a = 1;
                    for (var i = 0; i <= ObsData.length - 1; i++) {

                        var mydata = "";
                        if (ObsData[i].MICROSCOPY == "1") {
                            mydata = "<tr style='background-color:lightyellow;height:25px;'>";
                            mydata += '<td class="GridViewLabItemStyle">' + a + '</td>';

                            if (ObsData[i].value == 'HEAD') {
                                mydata += '<td class="GridViewLabItemStyle" id="labObservationName" style="font-weight:bold;font-size:13px;" >' + ObsData[i].labObservationName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" style="font-weight:bold;color:green;border:0px;font-style:italic;font-size:13px;background-color:lightyellow;" type="text" value=' + ObsData[i].value + ' readonly="true"/></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" value="" style="display:none;" /></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" id="labObservationName" style="font-weight:bold;padding-left:20px;font-size:12px;" >' + ObsData[i].labObservationName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" type="text" value="" style="width:80%" class=' + ObsData[i].labObservation_ID + ' />';

                                if (ObsData[i].help != "") {
                                    mydata += '<img id="imghelp" onclick="_showhideList(\'' + ObsData[i].help + '\',\'' + ObsData[i].labObservation_ID + '\')" src="../../App_Images/question_blue.png" />';
                                }

                                mydata += '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" style="width:80%"  value="' + ObsData[i].Unit + '" /></td>';
                            }



                            mydata += '<td style="display:none;" id="labObservation_ID">' + ObsData[i].labObservation_ID + '</td>';

                            mydata += "</tr>";
                            a++;
                        }
                        else {
                            mydata = "<tr style='display:none;'>";
                            mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="labObservationName" >' + ObsData[i].labObservationName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" type="text" value="" style="width:80%" />';
                            mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" style="width:80%"   /></td>';
                            mydata += '<td  id="labObservation_ID">' + ObsData[i].labObservation_ID + '</td>';

                        }
                        $('#tb_ItemList').append(mydata);

                    }


                },
                error: function (xhr, status) {
                    $('#btnsavemic').removeAttr('disabled').val('Save');

                }
            });
        }



        function clearform() {
            $('#Patinetname').html('');
            $('#Age').html('');
            $('#TestName').html('');
            $('#SCDate').html('');
            $('#SRDate').html('');
            $('#SampleType').html('');
            $('#PanelName').html('');
            $('#Gender').html('');
            $('#Status').html('');
            $('#StatusDate').html('');
            $('#VisitNo').html('');
            $('#SINNo').html('');
            $('#sptestid').html('');
            $('#tableMicroScopic').hide();
            $('#tablePlating').hide();
            $('#tableincubation').hide();
            $('#tableAll').hide();

            clearformcontrol();

        }

        function clearformcontrol() {
            $('#platenumber tr').slice(1).remove();

            $('#<%=txtbatch.ClientID%>').val('');
            $('#<%=txtbatchsaved.ClientID%>').val('');

            $('#<%=txtcomment.ClientID%>').val('');
            $('#<%=txtcommentsaved.ClientID%>').val('');

            $('#<%=txtplatecomment.ClientID%>').val('');
            $('#<%=txtplatecommentsaved.ClientID%>').val('');

            $('#<%=txtinbcomment.ClientID%>').val('');
            $('#<%=txtinbcommentsaved.ClientID%>').val('');

            $('#<%=ddlIncubationperiod.ClientID%>,#<%=ddlIncubationperiodsaved.ClientID%>,#<%=ddlmicroscopy.ClientID%>,#<%=ddlmicroscopysaveddata.ClientID%>,#<%=ddlnoofplate.ClientID%>,#<%=ddlnoofplatesaved.ClientID%>').prop('selectedIndex', 0);
        }
    </script>

    <%-- MicroScopic Data Save--%>
    <script type="text/javascript">
        function savemicdata() {


            var datatosave = datatosavemicroscopy();
            $('#btnsavemic').attr('disabled', 'disabled').val('Saving...');
            $.ajax({
                url: "MicroLabEntry.aspx/SaveMicroScopicdata",
                data: JSON.stringify({ datatosave: datatosave }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = result.d;
                    if (TestData == "-1") {
                        $modelUnBlockUI();
                        $('#btnsavemic').removeAttr('disabled').val('Save');
                        showerrormsg("Your Session Has Been Expired! Please Login Again");
                        return;
                    }
                    $('#btnsavemic').removeAttr('disabled').val('Save');
                    if (TestData == "1") {

                        showmsg("MicroScopic Saved..!");
                        $('#tableMicroScopic').hide();
                        $('#tablePlating').show();
                        $('#tableincubation').hide();
                        $('#tableAll').hide();
                        clearformcontrol();
                    }
                    else {
                        showerrormsg(TestData);
                    }


                },
                error: function (xhr, status) {
                    $('#btnsavemic').removeAttr('disabled').val('Save');

                }
            });
        }

        function datatosavemic() {

            var dataPLO = new Array();
            dataPLO[0] = $('#sptestid').html();
            dataPLO[1] = $('#VisitNo').html();
            dataPLO[2] = $('#SINNo').html();
            dataPLO[3] = $('#<%=ddlmicroscopy.ClientID%>').val();
            dataPLO[4] = $('#<%=txtcomment.ClientID%>').val();
            return dataPLO;
        }

        function datatosavemicroscopy() {

            var dataantibiotic = new Array();
            $('#tb_ItemList tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "saheader") {

                    var plo = new Object();

                    plo.Test_ID = $('#sptestid').html();
                    plo.LabObservation_ID = $(this).closest("tr").find('#labObservation_ID').html();
                    plo.LabObservationName = $(this).closest("tr").find('#labObservationName').html();
                    plo.Value = $(this).closest("tr").find('#txtvalue').val();
                    plo.ReadingFormat = $(this).closest("tr").find('#txtunit').val();
                    plo.Reporttype = "Preliminary 1";
                    plo.LedgerTransactionNo = $('#VisitNo').html();
                    plo.BarcodeNo = $('#SINNo').html();
                    dataantibiotic.push(plo);
                }
            });

            return dataantibiotic;
        }


    </script>


    <%-- Plating Data Save--%>
    <script type="text/javascript">
        function showplatenumber() {

            $('#platenumber tr').slice(1).remove();

            for (var a = 1; a <= $('#<%=ddlnoofplate.ClientID%>').val() ; a++) {
                var mydata = "<tr id='" + a + "'  style='cursor:pointer;background-color:lightgreen;height:25px;'>";
                mydata += '<td class="GridViewLabItemStyle"  width="50px">' + a + '</td>';
                mydata += '<td class="GridViewLabItemStyle" width="150px"><input class="plno" type="text" style="width:150px"/></td>';
                mydata += "</tr>";
                $('#platenumber').append(mydata);
            }
        }

        function saveplatdata() {
            if ($('#<%=ddlnoofplate.ClientID%>').val() == "0") {
                showerrormsg("Please Select No of Plat ");
                $('#<%=ddlnoofplate.ClientID%>').focus();
                return;
            }


            var sn = 0;
            $('#platenumber tr').each(function () {
                if ($(this).attr("id") != "phead") {
                    var plno = $(this).find('.plno').val().trim();
                    if (plno == "") {
                        sn = 1;
                        $(this).find('.plno').focus();
                        return false;
                    }
                }
            });

            if (sn == 1) {
                showerrormsg("Please Enter Plate Number ");
                return false;
            }


            var datatosave = datatosaveplate();
            $('#btnsavepating').attr('disabled', 'disabled').val('Saving...');
            $.ajax({
                url: "MicroLabEntry.aspx/SavePlatingdata",
                data: JSON.stringify({ datatosave: datatosave }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = result.d;
                    if (TestData == "-1") {
                        $modelUnBlockUI();
                        $('#btnsavepating').removeAttr('disabled').val('Save');
                        showerrormsg("Your Session Has Been Expired! Please Login Again");
                        return;
                    }
                    $('#btnsavepating').removeAttr('disabled').val('Save');
                    if (TestData == "1") {

                        showmsg("Plating Saved..!");
                        $('#tableMicroScopic').hide();
                        $('#tablePlating').hide();
                        $('#tableincubation').show();
                        $('#tableAll').hide();
                        clearformcontrol();
                    }
                    else {
                        showerrormsg(TestData);
                    }


                },
                error: function (xhr, status) {
                    $('#btnsavepating').removeAttr('disabled').val('Save');

                }
            });


        }


        function datatosaveplate() {

            var dataPLO = new Array();
            dataPLO[0] = $('#sptestid').html();
            dataPLO[1] = $('#VisitNo').html();
            dataPLO[2] = $('#SINNo').html();
            dataPLO[3] = $('#<%=ddlnoofplate.ClientID%>').val();
            dataPLO[4] = $('#<%=txtplatecomment.ClientID%>').val();

            var platenumber = "";
            $('#platenumber tr').each(function () {
                if ($(this).attr("id") != "phead") {
                    platenumber += $(this).find('.plno').val().trim() + "#";
                }
            });
            dataPLO[5] = platenumber;
            return dataPLO;
        }

    </script>



    <%-- Incubation Data Save--%>
    <script type="text/javascript">
        function saveIncubation() {
            if ($('#<%=ddlIncubationperiod.ClientID%>').val() == "") {
                showerrormsg("Please Select Incubation Period ");
                $('#<%=ddlIncubationperiod.ClientID%>').focus();
                return;
            }


            var datatosave = datatosaveincu();
            $('#btnIncubation').attr('disabled', 'disabled').val('Saving...');
            $.ajax({
                url: "MicroLabEntry.aspx/SaveIncubationdata",
                data: JSON.stringify({ datatosave: datatosave }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = result.d;
                    if (TestData == "-1") {
                        $modelUnBlockUI();
                        $('#btnIncubation').removeAttr('disabled').val('Save');
                        showerrormsg("Your Session Has Been Expired! Please Login Again");
                        return;
                    }
                    $('#btnIncubation').removeAttr('disabled').val('Save');
                    if (TestData == "1") {

                        showmsg("Incubation Saved..!");
                        $('#tableMicroScopic').hide();
                        $('#tablePlating').hide();
                        $('#tableincubation').hide();
                        clearformcontrol();
                        getsaveddata();
                        getMicroScopyDataaftersaved($(control).find('#Investigation_ID').html(), $(control).find('#trlabno').html(), $(control).find('#trbarcodeno').html(), $(control).find('#trGender').html(), $(control).find('#AgeInDays').html(), $(control).attr("id"));
                        $('#tableAll').show();
                    }
                    else {
                        showerrormsg(TestData);
                    }


                },
                error: function (xhr, status) {
                    $('#btnIncubation').removeAttr('disabled').val('Save');

                }
            });
        }


        function datatosaveincu() {

            var dataPLO = new Array();
            dataPLO[0] = $('#sptestid').html();
            dataPLO[1] = $('#VisitNo').html();
            dataPLO[2] = $('#SINNo').html();
            dataPLO[3] = $('#<%=ddlIncubationperiod.ClientID%>').val();
            dataPLO[4] = $('#<%=txtbatch.ClientID%>').val();
            dataPLO[5] = $('#<%=txtinbcomment.ClientID%>').val();
            return dataPLO;
        }
    </script>


    <%-- OLD Data Search and Update--%>
    <script type="text/javascript">






        function getsaveddata() {

            $.ajax({
                url: "MicroLabEntry.aspx/GetSavedData",
                data: '{testid:"' + $('#sptestid').html() + '"}', // parameter map 
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = $.parseJSON(result.d);

                    $('#ContentPlaceHolder1_ddlmicroscopysaveddata').val(TestData[0].MicroScopic);
                    $('#ContentPlaceHolder1_txtcommentsaved').val(TestData[0].MicroScopicComment);
                    $('#ContentPlaceHolder1_txtplatecommentsaved').val(TestData[0].PlatingComment);
                    $('#ContentPlaceHolder1_ddlnoofplatesaved').val(TestData[0].NoofPlate);
                    $('#<%=lbmdoneby.ClientID%>').text(TestData[0].MicroScopicDoneBy);
                    $('#<%=lbmdonedate.ClientID%>').text(TestData[0].MicroScopicDate);
                    $('#<%=lbpladoby.ClientID%>').text(TestData[0].PlatingDoneBy);
                    $('#<%=lbpladodate.ClientID%>').text(TestData[0].PlatingDate);


                    $('#<%=lbinby.ClientID%>').text(TestData[0].IncubationDoneBy);
                    $('#<%=lbindate.ClientID%>').text(TestData[0].IncubationDate);
                    $('#<%=txtinbcommentsaved.ClientID%>').val(TestData[0].IncubationComment);
                    $('#<%=txtbatchsaved.ClientID%>').val(TestData[0].IncubationBatch);
                    $('#<%=ddlIncubationperiodsaved.ClientID%>').val(TestData[0].IncubationPeriod);

                    $('#platenumbersaved tr').slice(1).remove();
                    for (var c = 0; c <= TestData[0].PlateNumber.split('#').length - 1 ; c++) {
                        var mydata = "<tr id='" + parseInt(c + 1) + "'  style='cursor:pointer;background-color:lightgreen;height:25px;'>";
                        mydata += '<td class="GridViewLabItemStyle"  width="50px">' + parseInt(c + 1) + '</td>';
                        mydata += '<td class="GridViewLabItemStyle" width="150px"><input class="plno" type="text" style="width:150px" value="' + TestData[0].PlateNumber.split('#')[c] + '"/></td>';
                        mydata += "</tr>";
                        $('#platenumbersaved').append(mydata);
                    }
                },
                error: function (xhr, status) {
                    $('#btnsavemic').removeAttr('disabled').val('Search');

                }
            });
        }


        function getMicroScopyDataaftersaved(invid, labno, barcodeno, Gender, AgeInDays, testid) {
            $('#tb_ItemList1 tr').slice(1).remove();
            $.ajax({
                url: "MicroLabEntry.aspx/getMicroScopyDataaftersave",
                data: '{invid:"' + invid + '",LabNo:"' + labno + '",barcodeno:"' + barcodeno + '",Gender:"' + Gender + '",AgeInDays:"' + AgeInDays + '",Test_id:"' + testid + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {

                    ObsData = $.parseJSON(result.d);

                    var a = 1;
                    for (var i = 0; i <= ObsData.length - 1; i++) {

                        var mydata = "";
                        if (ObsData[i].MICROSCOPY == "1") {
                            mydata = "<tr style='background-color:lightyellow;height:25px;'>";
                            mydata += '<td class="GridViewLabItemStyle">' + a + '</td>';

                            if (ObsData[i].value == 'HEAD') {
                                mydata += '<td class="GridViewLabItemStyle" id="labObservationName" style="font-weight:bold;font-size:13px;" >' + ObsData[i].labObservationName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" style="font-weight:bold;color:green;border:0px;font-style:italic;font-size:13px;background-color:lightyellow;width:65px;" type="text" value=' + ObsData[i].value + ' readonly="true"/></td>';
                                mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" value=""  style="display:none;width:40px;" /></td>';
                            }
                            else {
                                mydata += '<td class="GridViewLabItemStyle" id="labObservationName" style="font-weight:bold;padding-left:10px;font-size:12px;" >' + ObsData[i].labObservationName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" value="' + ObsData[i].value + '" type="text" value="" style="width:65px;" class=' + ObsData[i].labObservation_ID + ' />';

                                if (ObsData[i].help != "") {
                                    mydata += '<img id="imghelp" onclick="_showhideList(\'' + ObsData[i].help + '\',\'' + ObsData[i].labObservation_ID + '\')" src="../../App_Images/question_blue.png" />';
                                }

                                mydata += '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" style="width:40px;"  value="' + ObsData[i].Unit + '" /></td>';
                            }



                            mydata += '<td style="display:none;" id="labObservation_ID">' + ObsData[i].labObservation_ID + '</td>';

                            mydata += "</tr>";
                            a++;
                        }
                        else {
                            mydata = "<tr style='display:none;'>";
                            mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1) + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="labObservationName" >' + ObsData[i].labObservationName + '</td>';
                            mydata += '<td class="GridViewLabItemStyle" id="value"><input id="txtvalue" type="text" value="" style="width:80%" />';
                            mydata += '<td class="GridViewLabItemStyle" id="Unit"><input type="text" id="txtunit" style="width:80%"   /></td>';
                            mydata += '<td  id="labObservation_ID">' + ObsData[i].labObservation_ID + '</td>';

                        }
                        $('#tb_ItemList1').append(mydata);

                    }


                },
                error: function (xhr, status) {
                    $('#btnsavemic').removeAttr('disabled').val('Save');

                }
            });
        }



        function showplatenumbersaved() {

            $('#platenumbersaved tr').slice(1).remove();

            for (var a = 1; a <= $('#<%=ddlnoofplatesaved.ClientID%>').val() ; a++) {
                var mydata = "<tr id='" + a + "'  style='cursor:pointer;background-color:lightgreen;height:25px;'>";
                mydata += '<td class="GridViewLabItemStyle"  width="50px">' + a + '</td>';
                mydata += '<td class="GridViewLabItemStyle" width="150px"><input class="plno" type="text" style="width:150px"/></td>';
                mydata += "</tr>";
                $('#platenumbersaved').append(mydata);
            }
        }


        function datatosavemicroscopyaftersave() {

            var dataantibiotic = new Array();
            $('#tb_ItemList1 tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "saheader1") {

                    var plo = new Object();

                    plo.Test_ID = $('#sptestid').html();
                    plo.LabObservation_ID = $(this).closest("tr").find('#labObservation_ID').html();
                    plo.LabObservationName = $(this).closest("tr").find('#labObservationName').html();
                    plo.Value = $(this).closest("tr").find('#txtvalue').val();
                    plo.ReadingFormat = $(this).closest("tr").find('#txtunit').val();
                    plo.Reporttype = "Preliminary 1";
                    plo.LedgerTransactionNo = $('#VisitNo').html();
                    plo.BarcodeNo = $('#SINNo').html();
                    dataantibiotic.push(plo);
                }
            });

            return dataantibiotic;
        }

        function updatealldata() {

            var datatosave = datatosavemicroscopyaftersave();
            if ($('#<%=ddlnoofplatesaved.ClientID%>').val() == "0") {
                showerrormsg("Please Select No of Plat ");
                $('#<%=ddlnoofplatesaved.ClientID%>').focus();
                return;
            }


            var sn = 0;
            $('#platenumbersaved tr').each(function () {
                if ($(this).attr("id") != "phead1") {
                    var plno = $(this).find('.plno').val().trim();
                    if (plno == "") {
                        sn = 1;
                        $(this).find('.plno').focus();
                        return false;
                    }
                }
            });

            if (sn == 1) {
                showerrormsg("Please Enter Plate Number ");
                return false;
            }

            var datatoupdate = getdatatoupdate();
            $('#btnupdatealldate').attr('disabled', 'disabled').val('Updating...');
            $.ajax({
                url: "MicroLabEntry.aspx/UpdateAllData",
                data: JSON.stringify({ datatoupdate: datatoupdate, datatosave: datatosave }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = result.d;
                    if (TestData == "-1") {
                        $modelUnBlockUI();
                        $('#btnupdatealldate').removeAttr('disabled').val('Update');
                        showerrormsg("Your Session Has Been Expired! Please Login Again");
                        return;
                    }
                    $('#btnupdatealldate').removeAttr('disabled').val('Update');
                    if (TestData == "1") {

                        showmsg("Record Updated..!");
                        clearform();
                        searchdata('');
                    }
                    else {
                        showerrormsg(TestData);
                    }


                },
                error: function (xhr, status) {
                    $('#btnupdatealldate').removeAttr('disabled').val('Update');

                }
            });
        }

        function getdatatoupdate() {
            var dataPLO = new Array();
            dataPLO[0] = $('#sptestid').html();
            dataPLO[1] = $('#<%=ddlmicroscopysaveddata.ClientID%>').val();
            dataPLO[2] = $('#<%=txtcommentsaved.ClientID%>').val();
            dataPLO[3] = $('#<%=ddlnoofplatesaved.ClientID%>').val();
            dataPLO[4] = $('#<%=txtplatecommentsaved.ClientID%>').val();

            var platenumber = "";
            $('#platenumbersaved tr').each(function () {
                if ($(this).attr("id") != "phead1") {
                    platenumber += $(this).find('.plno').val().trim() + "#";
                }
            });
            dataPLO[5] = platenumber;
            dataPLO[6] = $('#<%=ddlIncubationperiodsaved.ClientID%>').val();
            dataPLO[7] = $('#<%=txtbatchsaved.ClientID%>').val();
            dataPLO[8] = $('#<%=txtinbcommentsaved.ClientID%>').val();
            return dataPLO;
        }
    </script>
</asp:Content>

