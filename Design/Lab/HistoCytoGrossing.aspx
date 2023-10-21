<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="HistoCytoGrossing.aspx.cs" Inherits="Design_Lab_HistoCytoGrossing" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>

    <webopt:BundleReference ID="BundleReference10" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />

    <%: Scripts.Render("~/bundles/ResultEntry") %>

  
    <div id="Pbody_box_inventory">
          <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>HistoCyto Grossing And Sliding </b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="vertical-align: top; margin-left: -18px; margin-right: -20px">
                <div class="col-md-24">
                    <div class="col-md-10">

                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-5" style="color: maroon; font-weight: bold;">
                                    Status:
                                </div>
                                <div class="col-md-7">
                                    <asp:DropDownList ID="ddltype" runat="server">
                                        <asp:ListItem Value="Assigned">Assigned</asp:ListItem>
                                        <asp:ListItem Value="Grossed">Grossed</asp:ListItem>
                                        <asp:ListItem Value="Slided">Slided</asp:ListItem>
                                        <asp:ListItem Value="SlideComplete">Complete</asp:ListItem>
                                        <%--   <asp:ListItem Value="ALL">ALL</asp:ListItem>--%>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-5" style="color: maroon; font-weight: bold; display: none;">
                                    Doctor:
                                </div>
                                <div class="col-md-7">
                                    <asp:DropDownList ID="ddldoctor" runat="server" Width="132" Enabled="true" Visible="False"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">

                                <div class="col-md-5" style="color: maroon; font-weight: bold;">
                                    From Date:
                                </div>
                                <div class="col-md-7">
                                    <asp:TextBox ID="dtFrom" runat="server" ReadOnly="true"></asp:TextBox>
                                    <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                        TargetControlID="dtFrom"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="dtFrom" />
                                </div>
                                <div class="col-md-5" style="color: maroon; font-weight: bold;">
                                    To Date:
                                </div>
                                <div class="col-md-7">
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

                                <div class="col-md-5" style="color: maroon; font-weight: bold;">
                                    Visit No:
                                </div>
                                <div class="col-md-7">
                                    <asp:TextBox ID="txtvisitno" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-5" style="color: maroon; font-weight: bold;">
                                    SIN No:
                                </div>
                                <div class="col-md-7">
                                    <asp:TextBox ID="txtsinno" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">

                                <div class="col-md-5" style="color: maroon; font-weight: bold;">
                                    Biopsy No:
                                </div>
                                <div class="col-md-7">
                                    <asp:TextBox ID="txtslideno" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-5" style="color: maroon; font-weight: bold;">
                                    Department:
                                </div>
                                <div class="col-md-7">
                                    <asp:DropDownList ID="ddldepartment" runat="server"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row" style="color: maroon; text-align: center">
                            <input id="btnSearch" type="button" class="searchbutton" value="Search" onclick="searchdata('')" />
                        </div>

                        <div class="row">
                            <table>
                                <tr>
                                    <td style="background-color: lightyellow; width: 50px; border: 1px solid black; cursor: pointer;" onclick="searchdata('Assigned')"></td>
                                    <td><b>Assigned</b></td>
                                    <td style="background-color: pink; width: 50px; border: 1px solid black; cursor: pointer;" onclick="searchdata('Grossed')"></td>
                                    <td><b>Grossed</b></td>
                                    <td style="background-color: lightgreen; width: 50px; border: 1px solid black; cursor: pointer;" onclick="searchdata('Slided')"></td>
                                    <td><b>Slided</b></td>
                                    <td style="background-color: #ff00ff; width: 50px; border: 1px solid black; cursor: pointer;" onclick="searchdata('SlideComplete')"></td>
                                    <td><b>Completed</b></td>
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
                            <div id="PatientLabSearchOutput" style="height: 350px; overflow: scroll;">
                                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch">
                                    <tr id="trheader">
                                        <th class="GridViewHeaderStyle" scope="col" align="left">S.No</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">VisitNo</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">SIN No</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">Biopsy No</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">Patient Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">Test Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">Sample Collection Date and Time</th>
                                        <th class="GridViewHeaderStyle" scope="col" align="left">Sample Receiving Date and Time</th>
                                    </tr>
                                </table>
                            </div>

                        </div>
                    </div>
                    <div class="col-md-14">
                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    Patient Name:
                                </div>
                                <div class="col-md-12" style="color: black; font-weight: bold;">
                                    <span id="Patinetname"></span>
                                </div>
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    Visit No:
                                </div>
                                <div class="col-md-4" style="color: black; font-weight: bold;">
                                    <span id="VisitNo"></span><span id="pid" style="display: none;"></span>
                                    <span id="sptestid" style="display: none"></span>
                                    <span id="spreop" style="color: red;"></span>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    Age:
                                </div>
                                <div class="col-md-4" style="color: black; font-weight: bold;">
                                    <span id="Age"></span>
                                </div>
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    Gender:
                                </div>
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    <span id="Gender" style="font-weight: bold; color: black"></span>
                                </div>
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                 SIN No:   
                                </div>
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    <span id="SINNo" style="color: black;"></span>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    Status:
                                </div>
                                <div class="col-md-4" style="color: black; font-weight: bold;">
                                    <span id="Status"></span>
                                </div>
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    Biopsy No:
                                </div>
                                <div class="col-md-4" style="color: black; font-weight: bold;">
                                    <span id="SlideNo" style="color: black;"></span>
                                </div>
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    SpecimentType:
                                </div>
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    <span id="SampleType"></span>
                                </div>
                            </div>
                        </div>
                             <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    Party Name:
                                </div>
                                <div class="col-md-12" style="color: black; font-weight: bold;">
                                  <span id="PanelName"></span>
                                </div>
                              
                               
                                <div class="col-md-8" style="color: maroon; font-weight: bold;">
                                   
                                </div>
                               
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                    Test Name:
                                </div>
                                <div class="col-md-16" style="color: black; font-weight: bold;">
                                    <span id="TestName"></span>
                                </div>
                         
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                   
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                   Sample Info:
                                </div>
                                <div class="col-md-14" style="color: black; font-weight: bold;">
                                    <span id="sampleinfo"></span>
                                </div>
                                <div class="col-md-6" style="color: maroon; font-weight: bold;">
                                    <input type="button" value="View Doc" style="background-color: red; color: white; cursor: pointer; font-weight: bold; float: right;" onclick="openpopup6()" />
                                    <input type="button" value="View Remarks" style="background-color: #673AB7; color: white; cursor: pointer; font-weight: bold; float: right;" onclick="    openpopup7()" />
                                </div>
                               
                            </div>
                        </div>
                        <div class="row" style="display: none;">
                            <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                Sample Col. Date:
                            </div>
                            <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                <span id="SCDate"></span>
                            </div>
                            <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                Sample Rec. Date:
                            </div>
                            <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                <span id="SRDate"></span>
                            </div>
                        </div>
                        <div class="row" style="display: none;">
                            <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                Status:
                            </div>
                            <div class="col-md-4" style="color: maroon; font-weight: bold;">
                            </div>
                            <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                Last Status Date:
                            </div>
                            <div class="col-md-4" style="color: maroon; font-weight: bold;">
                                <span id="StatusDate"></span>
                            </div>
                        </div>
                        <div class="row">

                            <div id="tableGrossing" style="display: none;">
                                <div class="Purchaseheader">Grossing Detail</div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-8" style="font-weight: bold">
                                            No. of Casset/Block:
                                        </div>
                                        <div class="col-md-3" style="font-weight: bold">
                                            <select id="noofblock" style="font-weight: 700">
                                                <option selected="selected"></option>
                                                <option>1</option>
                                                <option>2</option>
                                                <option>3</option>
                                                <option>4</option>
                                                <option>5</option>
                                                <option>6</option>
                                                <option>7</option>
                                                <option>8</option>
                                                <option>9</option>
                                                <option>10</option>
                                                <option>11</option>
                                                <option>12</option>
                                                <option>13</option>
                                                <option>14</option>
                                                <option>15</option>
                                                <option>16</option>
                                                <option>17</option>
                                                <option>18</option>
                                                <option>19</option>
                                                <option>20</option>
                                                <option>21</option>
                                                <option>22</option>
                                                <option>23</option>
                                                <option>24</option>
                                                <option>25</option>
                                                <option>26</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6" style="font-weight: bold">
                                            Start From:
                                        </div>
                                        <div class="col-md-3" style="font-weight: bold">
                                            <select id="stfrom" style="font-weight: 700">
                                                <option selected="selected"></option>
                                                <option>A</option>
                                                <option>B</option>
                                                <option>C</option>
                                                <option>D</option>
                                                <option>E</option>
                                                <option>F</option>
                                                <option>G</option>
                                                <option>H</option>
                                                <option>I</option>
                                                <option>J</option>
                                                <option>K</option>
                                                <option>L</option>
                                                <option>M</option>
                                                <option>N</option>
                                                <option>O</option>
                                                <option>P</option>
                                                <option>Q</option>
                                                <option>R</option>
                                                <option>S</option>
                                                <option>T</option>
                                                <option>U</option>
                                                <option>V</option>
                                                <option>W</option>
                                                <option>X</option>
                                                <option>Y</option>
                                                <option>Z</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <input type="button" id="makegross" value="Make" style="font-weight: bold; cursor: pointer" onclick="makeblock()" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div id="divgrossed" style="height: 155px; overflow: scroll;">
                                        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" width="99%">
                                            <tr id="header">
                                                <th class="GridViewHeaderStyle" scope="col">S.No</th>
                                                <th class="GridViewHeaderStyle" scope="col">Biopsy No</th>
                                                <th class="GridViewHeaderStyle" scope="col">Block ID</th>
                                                <th class="GridViewHeaderStyle" scope="col">Comment</th>
                                                <th class="GridViewHeaderStyle" scope="col">#</th>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="Purchaseheader">Gross </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-4">
                                            Template :
                                        </div>
                                        <div class="col-md-12">
                                            <select id="ddlGrossing"></select>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="button" value="Use Template" onclick="getTemplateHisto()" style="cursor: pointer; font-weight: bold; background-color: aqua;" />
                                        </div>
                                    </div>

                                </div>
                                <div class="row">
                                    <CKEditor:CKEditorControl ID="txtHistoDatagross" BasePath="~/ckeditor" runat="server" EnterMode="BR" Width="750" Height="90" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|Font|FontSize|"></CKEditor:CKEditorControl>
                                </div>
                                <div class="row" style="text-align: center">
                                    <input type="button" value="Save Grossing" class="savebutton" id="btnsave" onclick="savedata()" />

                                    <input type="button" style="display: none;" value="Print Gross Label" class="resetbutton" id="btnprint" onclick="printdata()" />
                                </div>
                            </div>


                        </div>

                        <div class="row">
                            <div id="tableSliding" style="display: none;">
                                <div class="Purchaseheader">Sliding Detail</div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-6" style="font-weight: bold;">
                                            Select Block
                                        </div>
                                        <div class="col-md-10" style="font-weight: bold;">
                                            <select id="noofblockslide" style="font-weight: 700; width: 150px;">
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-6" style="font-weight: bold;">
                                            No of Slides
                                        </div>
                                        <div class="col-md-12">
                                            <select id="stfromslide" style="font-weight: 700" name="D1">
                                                <option selected="selected"></option>
                                                <option>1</option>
                                                <option>2</option>
                                                <option>3</option>
                                                <option>4</option>
                                                <option>5</option>
                                                <option>6</option>
                                                <option>7</option>
                                                <option>8</option>
                                                <option>9</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="button" id="Button1" value="Make" style="font-weight: bold; cursor: pointer" onclick="makeslides()" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div id="div1" style="height: 200px; overflow: scroll;">
                                        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table2" width="99%">
                                            <tr id="headerslide">
                                                <th class="GridViewHeaderStyle" scope="col">S.No</th>
                                                <th class="GridViewHeaderStyle" scope="col">Biopsy No</th>
                                                <th class="GridViewHeaderStyle" scope="col">Block ID</th>
                                                <th class="GridViewHeaderStyle" scope="col">Slide No</th>
                                                <th class="GridViewHeaderStyle" scope="col">Comment</th>
                                                <th class="GridViewHeaderStyle" scope="col"></th>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div class="row" style="text-align: center">
                                    <input type="button" value="Save Sliding" class="savebutton" id="Button2" onclick="savedataslide()" />
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div id="tableAll" style="display: none;">
                                <div class="Purchaseheader">Grossing and Sliding Detail</div>
                                <div class="row" id="1">
                                    <div class="col-md-24">
                                        <div class="col-md-5">
                                            No. of Block:<select id="noofblocksaved" style="font-weight: 700" name="D2">
                                                <option selected="selected"></option>
                                                <option>1</option>
                                                <option>2</option>
                                                <option>3</option>
                                                <option>4</option>
                                                <option>5</option>
                                                <option>6</option>
                                                <option>7</option>
                                                <option>8</option>
                                                <option>9</option>
                                                <option>10</option>
                                                <option>11</option>
                                                <option>12</option>
                                                <option>13</option>
                                                <option>14</option>
                                                <option>15</option>
                                                <option>16</option>
                                                <option>17</option>
                                                <option>18</option>
                                                <option>19</option>
                                                <option>20</option>
                                                <option>21</option>
                                                <option>22</option>
                                                <option>23</option>
                                                <option>24</option>
                                                <option>25</option>
                                                <option>26</option>
                                            </select>
                                        </div>
                                        <div class="col-md-5">
                                            Start From:<select id="stfromgrosssaved" style="font-weight: 700" name="D3">
                                                <option selected="selected"></option>
                                                <option>A</option>
                                                <option>B</option>
                                                <option>C</option>
                                                <option>D</option>
                                                <option>E</option>
                                                <option>F</option>
                                                <option>G</option>
                                                <option>H</option>
                                                <option>I</option>
                                                <option>J</option>
                                                <option>K</option>
                                                <option>L</option>
                                                <option>M</option>
                                                <option>N</option>
                                                <option>O</option>
                                                <option>P</option>
                                                <option>Q</option>
                                                <option>R</option>
                                                <option>S</option>
                                                <option>T</option>
                                                <option>U</option>
                                                <option>V</option>
                                                <option>W</option>
                                                <option>X</option>
                                                <option>Y</option>
                                                <option>Z</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <input type="button" id="Button3" value="Make" style="font-weight: bold; cursor: pointer" onclick="makeblocksaved()" /></td>
                                        </div>
                                        <div class="col-md-5">
                                            Select Block:
                                            <select id="noofblockslidesaved" style="font-weight: 700; width: 100px;" onchange="getdetaildatablock()"></select>
                                        </div>
                                        <div class="col-md-5">
                                            No of Slides:<select id="stfromslidesaved" style="font-weight: 700" name="D1">
                                                <option selected="selected"></option>
                                                <option>1</option>
                                                <option>2</option>
                                                <option>3</option>
                                                <option>4</option>
                                                <option>5</option>
                                                <option>6</option>
                                                <option>7</option>
                                                <option>8</option>
                                                <option>9</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <input type="button" id="Button4" value="Make" style="font-weight: bold; cursor: pointer" onclick="makeslidessaved()" />
                                        </div>
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-12">
                                            <div id="div2" style="height: 155px; overflow: scroll;">
                                                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table3" width="99%">
                                                    <tr id="Tr1">
                                                        <th class="GridViewHeaderStyle" scope="col">S.No</th>
                                                        <th class="GridViewHeaderStyle" scope="col">Biopsy No</th>
                                                        <th class="GridViewHeaderStyle" scope="col">Block ID</th>
                                                        <th class="GridViewHeaderStyle" scope="col">Comment</th>
                                                        <th class="GridViewHeaderStyle" scope="col">#</th>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <div id="div3" style="height: 155px; overflow: scroll;">
                                                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table4" width="99%">
                                                    <tr id="Tr2">
                                                        <th class="GridViewHeaderStyle" scope="col">S.No</th>
                                                        <th class="GridViewHeaderStyle" scope="col">Biopsy No</th>
                                                        <th class="GridViewHeaderStyle" scope="col">Block ID</th>
                                                        <th class="GridViewHeaderStyle" scope="col">Slide No</th>
                                                        <th class="GridViewHeaderStyle" scope="col">Comment</th>
                                                        <th class="GridViewHeaderStyle" scope="col"></th>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="Purchaseheader">
                                        Gross
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-24">
                                        <div class="col-md-4" style="font-weight: bold;">
                                            Template :
                                        </div>
                                        <div class="col-md-12">
                                            <select id="ddlGrossing1" style="width: 400px"></select>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="button" value="Use Template" onclick="getTemplateHisto1()" style="cursor: pointer; font-weight: bold; background-color: aqua;" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <CKEditor:CKEditorControl ID="Ckeditorcontrol1" BasePath="~/ckeditor" runat="server" Width="750" Height="90" EnterMode="BR" Toolbar="Source|Bold|Italic|Underline|Strike|-|NumberedList|BulletedList|Outdent|Indent|-|JustifyLeft|JustifyCenter|JustifyRight|JustifyBlock|Font|FontSize|"></CKEditor:CKEditorControl>
                                </div>
                                <div class="row" style="text-align: center;">
                                    <%    if (ApprovalId == "4")
                                          {%>

                                    <input type="button" value="Save Data" class="savebutton" id="Button5" onclick="savecompletedata()" />
                                    <% }%>

                                    <input type="button" value="Mark Complete" class="savebutton" id="Button8" onclick="markcomplete()" />


                                    <input type="button" value="Print Gross Label" class="resetbutton" id="Button6" onclick="printdata()" />

                                    <input type="button" value="Print Slide Label" class="searchbutton" id="Button7" onclick="printdata1()" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>



    <%-- Search and View data--%>

    <script type="text/javascript">
        function openpopup6() {
            var labno = $('#VisitNo').html();
            if (labno == "") {
                toast("Error", "Please Search Patient", "");
                return;
            }
            var href = "../Lab/AddFileRegistration.aspx?labno=" + labno;
            fancyboxopen(href)
        }

        function openpopup7() {
            var labno = $('#VisitNo').html();
            if (labno == "") {
                toast("Error", "Please Search Patient", "");
                return;
            }
            serverCall('PatientLabSearch.aspx/PostRemarksData', { TestID: $('#sptestid').html(), TestName: $('#TestName').html(), VisitNo: labno }, function (response) {
                $responseData = JSON.parse(response);
                var href = "../Lab/AddRemarks_PatientTestPopup.aspx?TestID=" + $responseData.TestID + "&TestName='" + $responseData.TestName + "&VisitNo=" + $responseData.VisitNo;

                fancyboxopen(href);
            });
        }
        function fancyboxopen(href) {
            $.fancybox({
                maxWidth: 860,
                maxHeight: 800,
                fitToView: false,
                width: '80%',
                height: '70%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
       );
        }
        var ApprovalId = '<%=ApprovalId%>';

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
            $('#tableGrossing').hide();
            $('#tableSliding').hide();
            $('#tableAll').hide();
            // $modelBlockUI();
            $.ajax({
                url: "HistoCytoGrossing.aspx/SearchData",
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
                        toast("Error", "Your Session Has Been Expired! Please Login Again", "");
                        return;
                    }
                    if (TestData.length == 0) {
                        $('#<%=lblTotalPatient.ClientID%>').html('0');

                        }
                        else {
                            $('#<%=lblTotalPatient.ClientID%>').text(TestData.length);
                            for (var i = 0; i <= TestData.length - 1; i++) {
                                var mydata = "<tr onclick='showdetail(this)' title='Please Click To Proceed' id='" + TestData[i].Test_ID + "'  style='cursor:pointer;background-color:" + TestData[i].rowcolor + ";height:25px;'>";
                                mydata += '<td class="GridViewLabItemStyle">' + parseInt(i + 1);
                                if (TestData[i].isreslide.split('#')[0] == "1") {
                                    mydata += '<img src="../../App_Images/Received.png" style="cursor:pointer;" onclick="showmsg(\'ReSlide Option : ' + TestData[i].isreslide.split('#')[1] + '\')" title="ReSlide Option : ' + TestData[i].isreslide.split('#')[1] + '">';
                                }
                                mydata += '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="trlabno" >' + TestData[i].LedgerTransactionNo + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="trbarcodeno">' + TestData[i].BarcodeNo + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" style="font-weight:bold;" id="trslidenumber">' + TestData[i].slidenumber + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="trpname">' + TestData[i].PName + '</td>';
                                mydata += '<td class="GridViewLabItemStyle" id="trtestname">' + TestData[i].Name + '</td>';
                                mydata += '<td style="display:none;" id="trSampleTypeName">' + TestData[i].SampleTypeName + '</td>';
                                mydata += '<td style="display:none;" id="trsampleinfo">' + TestData[i].SampleInfo + '</td>';
                                mydata += '<td style="display:none;" id="trAge">' + TestData[i].Age + '</td>';
                                mydata += '<td style="display:none;" id="trPanelName">' + TestData[i].PanelName + '</td>';
                                mydata += '<td style="display:none;" id="trGender">' + TestData[i].Gender + '</td>';
                                mydata += '<td style="GridViewLabItemStyle" id="trSampleCollectionDate">' + TestData[i].SampleCollectionDate + '</td>';
                                mydata += '<td style="GridViewLabItemStyle" id="trSampleReceiveDate">' + TestData[i].SampleReceiveDate + '</td>';
                                mydata += '<td style="display:none;" id="trCultureStatusDate">' + TestData[i].CultureStatusDate + '</td>';
                                mydata += '<td style="display:none;" id="trCultureStatus">' + TestData[i].HistoCytoStatus + '</td>';
                                mydata += '<td style="display:none;" id="trreportstatus">' + TestData[i].reportstatus + '</td>';
                                mydata += '<td style="display:none;" id="trpid">' + TestData[i].patient_id + '</td>';
                                mydata += '<td style="display:none;" id="trsubcate">' + TestData[i].subcategoryid + '</td>';
                                mydata += '<td style="display:none;" id="trisreslide">' + TestData[i].isreslide.split('#')[1] + '</td>';

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
                dataPLO[5] = $('#<%=txtslideno.ClientID%>').val();
                dataPLO[6] = $('#<%=ddldepartment.ClientID%>').val();
                dataPLO[7] = $('#<%=ddldoctor.ClientID%>').val();
                dataPLO[8] = type;
                return dataPLO;
            }


            function showdetail(ctrl) {

                $('#Patinetname').html($(ctrl).find('#trpname').html());
                $('#Age').html($(ctrl).find('#trAge').html());
                $('#PanelName').html($(ctrl).find('#trPanelName').html());
                $('#TestName').html($(ctrl).find('#trtestname').html());
                $('#SCDate').html($(ctrl).find('#trSampleCollectionDate').html());
                $('#SRDate').html($(ctrl).find('#trSampleReceiveDate').html());
                $('#SampleType').html($(ctrl).find('#trSampleTypeName').html());
                $('#sampleinfo').html($(ctrl).find('#trsampleinfo').html());
                $('#Gender').html($(ctrl).find('#trGender').html());
                $('#Status').html($(ctrl).find('#trCultureStatus').html());
                $('#StatusDate').html($(ctrl).find('#trCultureStatusDate').html());
                $('#VisitNo').html($(ctrl).find('#trlabno').html());

                if ($(ctrl).find('#trisreslide').html() != "") {
                    $('#spreop').html("(" + $(ctrl).find('#trisreslide').html() + ")");
                }
                else {
                    $('#spreop').html("");
                }
                $('#pid').html($(ctrl).find('#trpid').html());
                $('#SINNo').html($(ctrl).find('#trbarcodeno').html());
                $('#SlideNo').html($(ctrl).find('#trslidenumber').html());
                $('#sptestid').html($(ctrl).attr("id"));
                $('#Button5').show();
                if ($('#ContentPlaceHolder1_ddltype').val() != "ALL") {

                    if ($(ctrl).find('#trCultureStatus').html() == "Assigned") {
                        $('#tableGrossing').show();
                        $('#tableSliding').hide();
                        $('#tableAll').hide();

                        if ($(ctrl).find('#trsubcate').html() == "4") {
                            $('#tableGrossing').hide();
                            $('#tableSliding').show();
                            $('#noofblockslide option').remove();
                            $('#noofblockslide').append($("<option></option>").val('-').html('-'));
                        }
                    }
                    else if ($(ctrl).find('#trCultureStatus').html() == "Grossed") {
                        $('#tableGrossing').hide();
                        $('#tableSliding').show();
                        $('#tableAll').hide();
                        getblockdetail($(ctrl).attr("id"));
                    }
                    else if ($(ctrl).find('#trCultureStatus').html() == "Slided") {
                        $('#tableGrossing').hide();
                        $('#tableSliding').hide();
                        $('#tableAll').show();
                        $modelBlockUI();
                        getgrossdetail($(ctrl).attr("id"));
                        getblockdetailsaved($(ctrl).attr("id"));
                        $modelUnBlockUI();

                        if (ApprovalId != "4") {
                            $("#1 :input").attr("disabled", true);
                            $("#noofblockslidesaved").attr("disabled", false);
                        }

                    }
                    else if ($(ctrl).find('#trCultureStatus').html() == "SlideComplete") {
                        $('#tableGrossing').hide();
                        $('#tableSliding').hide();
                        $('#tableAll').show();
                        $modelBlockUI();
                        getgrossdetail($(ctrl).attr("id"));
                        getblockdetailsaved($(ctrl).attr("id"));
                        $modelUnBlockUI();
                        ApprovalId = "1";
                        $('#Button5').hide();
                        if (ApprovalId != "4") {
                            $("#1 :input").attr("disabled", true);
                            $("#noofblockslidesaved").attr("disabled", false);
                        }

                    }
                }
                else {
                    $('#tableGrossing').hide();
                    $('#tableSliding').hide();
                    $('#tableAll').show();
                    $modelBlockUI();
                    getgrossdetail($(ctrl).attr("id"));
                    getblockdetailsaved($(ctrl).attr("id"));
                    $modelUnBlockUI();
                }

            }

            function clearform() {
                $('#Patinetname').html('');
                $('#Age').html('');
                $('#PanelName').html('');
                $('#TestName').html('');
                $('#SCDate').html('');
                $('#SRDate').html('');
                $('#SampleType').html('');
                $('#sampleinfo').html('');
                $('#Gender').html('');
                $('#Status').html('');
                $('#StatusDate').html('');
                $('#VisitNo').html('');
                $('#spreop').html('');
                $('#pid').html('');
                $('#SINNo').html('');
                $('#SlideNo').html('');
                $('#sptestid').html('');

                $('#noofblock,#stfrom,#ddlGrossing,#noofblockslide,#stfromslide,#noofblocksaved,#stfromgrosssaved,#noofblockslidesaved,#stfromslidesaved').prop('selectedIndex', 0);
                $("#Table1").find("tr:not(:first)").remove();
                $("#Table2").find("tr:not(:first)").remove();
                $("#Table3").find("tr:not(:first)").remove();
                $("#Table4").find("tr:not(:first)").remove();
                var objEditor = CKEDITOR.instances['<%=Ckeditorcontrol1.ClientID%>'];
            objEditor.setData('');
            var objEditor = CKEDITOR.instances['<%=txtHistoDatagross.ClientID%>'];
               objEditor.setData('');

           }


    </script>

    <%-- Grossing --%>
    <script type="text/javascript">
        function makeblock() {
            if ($('#sptestid').html() == '') {
                toast("Error", "Please Select Patient..!", "");
                return;
            }
            if ($('#noofblock').val() == '') {
                toast("Error", "Please Select No of Block..!", "");
                $('#noofblock').focus();
                return;
            }
            if ($('#stfrom').val() == '') {
                toast("Error", "Please Select Start From..!", "");
                $('#stfrom').focus();
                return;
            }

            $("#Table1").find("tr:not(:first)").remove();
            for (var a = 0; a < parseInt($('#noofblock').val()) ; a++) {


                var a = $('#Table1 tr').length - 1;
                var mydata = '<tr style="background-color:white;height:30px;" id=' + $('#SlideNo').html() + '_' + parseFloat(a + 1) + '>';
                mydata += '<td>' + parseFloat(a + 1) + '</td>';
                mydata += '<td id="labno" align="left">' + $('#SlideNo').html() + '</td>';
                mydata += '<td id="BlockID" align="left">' + nextChar($('#stfrom').val(), a) + '</td>';
                mydata += '<td id="comment"><input type="text" id="txtcomment" style="width:100px;"/></td>';

                mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/></td>';

                mydata += '</tr>';
                $('#Table1').append(mydata);

            }
        }

        function nextChar(c, no) {
            return String.fromCharCode(c.charCodeAt(0) + parseInt(no));
        }

        function deleterow(itemid) {
            var table = document.getElementById('Table1');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

        }

        function getcompletedataadj() {
            var tempData = [];
            $('#Table1 tr').each(function () {
                if ($(this).attr("id") != "header") {
                    var itemmaster = [];
                    itemmaster[0] = $("#sptestid").html();
                    itemmaster[1] = $(this).find("#labno").html();
                    itemmaster[2] = $(this).find("#BlockID").html();
                    itemmaster[3] = $(this).find("#txtcomment").val();
                    var Gross = "";
                    var objEditor = CKEDITOR.instances['<%=txtHistoDatagross.ClientID%>'];
                    Gross = objEditor.getData();
                    if (Gross.trim() == "null" || Gross.trim() == "<br />") {
                        Gross = "";
                    }

                    itemmaster[4] = Gross;
                    itemmaster[5] = $("#pid").html();;
                    itemmaster[6] = $("#VisitNo").html();;
                    itemmaster[7] = $("#SampleType").html();;
                    tempData.push(itemmaster);
                }
            });
            return tempData;
        }

        function savedata() {
            if ($('#Table1 tr').length == "1" || $('#Table1 tr').length == 0) {
                toast("Error", "Please Select Block..!", "");
                $('#makegross').focus();
                return;
            }

            var mydataadj = getcompletedataadj();

            $.ajax({
                url: "histocytogrossing.aspx/savegrossdata",
                data: JSON.stringify({ mydataadj: mydataadj }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 130000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        toast("Success", "Block Saved Successfully..!", "");
                        $('#tableGrossing').hide();
                        $('#tableSliding').show();
                        $('#tableAll').hide();
                        getblockdetail($("#sptestid").html());
                    }
                    else {
                        toast("Error", result.d, "");
                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });


        }


    </script>

    <%--Sliding--%>
    <script type="text/javascript">
        function getblockdetail(testid) {
            $('#noofblockslide option').remove();
            $('#noofblockslide').append($("<option></option>").val('').html(''));
            $.ajax({
                url: "HistoCytoGrossing.aspx/getdetailblock",
                data: '{testid:"' + testid + '" }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 130000,
                dataType: "json",
                success: function (result) {
                    PatientDataGross = $.parseJSON(result.d);
                    if (PatientDataGross.length == 0) {
                        $('#noofblockslide').append($("<option></option>").val('-').html('-'));
                    }
                    for (var a = 0; a < PatientDataGross.length; a++) {
                        $('#noofblockslide').append($("<option></option>").val(PatientDataGross[a].blockid).html(PatientDataGross[a].value));

                    }
                },
                error: function (xhr, status) {
                    $modelUnBlockUI();
                    StatusOFReport = "";
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function makeslides() {
            if ($('#sptestid').html() == '') {
              
                toast("Error", "Please Select Patient..!", "");
                return;
            }
            if ($('#noofblockslide').val() == '') {
                toast("Error", "Please Select Block..!", "");
                $('#noofblockslide').focus();
                return;
            }
            if ($('#stfromslide').val() == '') {
                toast("Error", "Please Select No of Slides From..!", "");
                $('#stfromslide').focus();
                return;
            }
            $("#Table2").find("tr:not(:first)").remove();
            for (var a = 0; a < parseInt($('#stfromslide').val()) ; a++) {


                var a = $('#Table2 tr').length - 1;
                var mydata = '<tr style="background-color:white;height:30px;" id=' + $('#SlideNo').html() + '_' + $('#noofblockslide').val() + '_' + parseFloat(a + 1) + '>';
                mydata += '<td>' + parseFloat(a + 1) + '</td>';
                mydata += '<td id="labno" align="left">' + $('#SlideNo').html() + '</td>';
                mydata += '<td id="BlockID" align="left">' + $('#noofblockslide option:selected').val() + '</td>';
                mydata += '<td id="slideno" align="left">' + parseFloat(a + 1) + '</td>';
                mydata += '<td id="comment"><input type="text" id="txtcomment" style="width:100px;"/></td>';
                mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow1(this)"/></td>';
                mydata += '</tr>';
                $('#Table2').append(mydata);

            }
        }
        function deleterow1(itemid) {
            var table = document.getElementById('Table2');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

        }

        function getcompletedataslides() {
            var tempData = [];
            $('#Table2 tr').each(function () {
                if ($(this).attr("id") != "headerslide") {
                    var itemmaster = [];
                    itemmaster[0] = $("#sptestid").html();
                    itemmaster[1] = $(this).find("#labno").html();
                    itemmaster[2] = $(this).find("#BlockID").html();
                    itemmaster[3] = $(this).find("#slideno").html();
                    itemmaster[4] = $(this).find("#txtcomment").val();

                    tempData.push(itemmaster);
                }
            });
            return tempData;
        }
        function savedataslide() {
            if ($('#Table2 tr').length == "1" || $('#Table2 tr').length == 0) {
                toast("Error", "Please Make Slides..!", "");
                $('#Button1').focus();
                return;
            }

            var mydataadj = getcompletedataslides();

            $.ajax({
                url: "HistoCytoGrossing.aspx/savedataslide",
                data: JSON.stringify({ mydataadj: mydataadj }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 130000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {


                        if ($('#noofblockslide option:selected').val() != $('#noofblockslide option:last-child').val()) {
                         
                            toast("Error", "First Block's Slides Saved Successfully Move To Next..!", "");
                            $('#noofblockslide option:selected').next().prop('selected', 'selected');
                            $("#Table2").find("tr:not(:first)").remove();
                            $("#stfromslide").prop('selectedIndex', 0);
                            $('#Button1').focus();
                        }
                        else {
                            toast("Success", "All Slides Saved Successfully..!", "");
                            $('#tableGrossing').hide();
                            $('#tableSliding').hide();
                            $('#tableAll').show();
                            $modelBlockUI();
                            getgrossdetail($('#sptestid').html());
                            getblockdetailsaved($('#sptestid').html());
                            $modelUnBlockUI();

                        }
                    }
                    else {
                        alert(result.d);
                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });

        }
    </script>


    <%--Grossing and Sliding--%>
    <script type="text/javascript">
        function getgrossdetail(testid) {

            $.ajax({
                url: "HistoCytoGrossing.aspx/getgrossdetail",
                data: JSON.stringify({ testid: testid }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    TestData = $.parseJSON(result.d);
                    $("#Table3").find("tr:not(:first)").remove();

                    for (var a = 0; a <= TestData.length - 1; a++) {
                        var a = $('#Table3 tr').length - 1;
                        var mydata = '<tr style="background-color:white;height:30px;" id=' + TestData[a].labno + '_' + parseFloat(a + 1) + '>';
                        mydata += '<td>' + parseFloat(a + 1) + '</td>';
                        mydata += '<td id="labno" align="left">' + TestData[a].labno + '</td>';
                        mydata += '<td id="BlockID" align="left">' + TestData[a].blockid + '</td>';


                        if (ApprovalId != "4") {
                            mydata += '<td>' + TestData[a].blockcomment + '</td>';
                        }
                        else {

                            mydata += '<td id="comment"><input type="text" id="txtcomment" style="width:100px;" value="' + TestData[a].blockcomment + '"/></td>';
                        }


                        if (ApprovalId != "4") {
                            mydata += '<td></td>';
                        }
                        else {

                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow2(this)"/></td>';
                        }
                        mydata += '</tr>';
                        $('#Table3').append(mydata);
                    }
                    var objEditor = CKEDITOR.instances['<%=Ckeditorcontrol1.ClientID%>'];
                    objEditor.setData(TestData[0].grosscomment);




                },
                error: function (xhr, status) {


                }
            });
        }
        function deleterow2(itemid) {
            var table = document.getElementById('Table3');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

        }

        function makeblocksaved() {
            if ($('#sptestid').html() == '') {
             
                toast("Error", "Please Select Patient..!", "");
                return;
            }
            if ($('#noofblocksaved').val() == '') {
             
                toast("Error", "Please Select No of Block..!", "");
                $('#noofblocksaved').focus();
                return;
            }
            if ($('#stfromgrosssaved').val() == '') {
             
                toast("Error", "Please Select Start From..!", "");
                $('#stfromgrosssaved').focus();
                return;
            }

            $("#Table3").find("tr:not(:first)").remove();
            for (var a = 0; a < parseInt($('#noofblocksaved').val()) ; a++) {


                var a = $('#Table3 tr').length - 1;
                var mydata = '<tr style="background-color:white;height:30px;" id=' + $('#SlideNo').html() + '_' + parseFloat(a + 1) + '>';
                mydata += '<td>' + parseFloat(a + 1) + '</td>';
                mydata += '<td id="labno" align="left">' + $('#SlideNo').html() + '</td>';
                mydata += '<td id="BlockID" align="left">' + nextChar($('#stfromgrosssaved').val(), a) + '</td>';
                mydata += '<td id="comment"><input type="text" id="txtcomment" style="width:100px;"/></td>';
                mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow2(this)"/></td>';
                mydata += '</tr>';
                $('#Table3').append(mydata);

            }
        }

        function getblockdetailsaved(testid) {
            $('#noofblockslidesaved option').remove();

            $.ajax({
                url: "HistoCytoGrossing.aspx/getdetailblock",
                data: '{testid:"' + testid + '" }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 130000,
                dataType: "json",
                success: function (result) {
                    PatientDataGross = $.parseJSON(result.d);
                    if (PatientDataGross.length == 0) {
                        $('#noofblockslidesaved').append($("<option></option>").val('-').html('-'));
                    }
                    for (var a = 0; a < PatientDataGross.length; a++) {
                        $('#noofblockslidesaved').append($("<option></option>").val(PatientDataGross[a].blockid).html(PatientDataGross[a].value));

                    }
                    getdetaildatablock();
                },
                error: function (xhr, status) {

                    StatusOFReport = "";
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


        }


        function getdetaildatablock() {
            var blockid = $('#noofblockslidesaved').val();
            var testid = $('#sptestid').html();
            $.ajax({
                url: "HistoCytoGrossing.aspx/getdetaildatablock",
                data: '{testid:"' + testid + '",blockid:"' + blockid + '" }', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 130000,
                dataType: "json",
                success: function (result) {
                    PatientDataGross1 = $.parseJSON(result.d);

                    $("#Table4").find("tr:not(:first)").remove();

                    for (var a = 0; a <= PatientDataGross1.length - 1; a++) {
                        var mydata = '<tr style="background-color:white;height:30px;" id=' + PatientDataGross1[a].labno + '_' + PatientDataGross1[a].blockid + '_' + PatientDataGross1[a].slideno + '>';
                        mydata += '<td>' + parseFloat(a + 1);

                        if (PatientDataGross1[a].reslide == "1") {
                            mydata += '<img src="../../App_Images/Received.png" style="cursor:pointer;" onclick="showmsg(\'ReSlide Option : ' + PatientDataGross1[a].reslideoption + '\')" title="ReSlide Option : ' + PatientDataGross1[a].reslideoption + '">';
                        }

                        mydata += '</td>';
                        mydata += '<td id="labno" align="left">' + PatientDataGross1[a].labno + '</td>';
                        mydata += '<td id="BlockID" align="left">' + PatientDataGross1[a].blockid + '</td>';
                        mydata += '<td id="slideno" align="left">' + PatientDataGross1[a].slideno + '</td>';
                        if (ApprovalId != "4") {
                            mydata += '<td>' + PatientDataGross1[a].slidecomment + '</td>';
                        }
                        else {
                            mydata += '<td id="comment"><input type="text" id="txtcomment" style="width:100px;" value="' + PatientDataGross1[a].slidecomment + '"/></td>';
                        }


                        if (ApprovalId != "4") {
                            mydata += '<td></td>';
                        }
                        else {
                            mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow3(this)"/></td>';
                        }
                        mydata += '</tr>';
                        $('#Table4').append(mydata);
                    }
                },
                error: function (xhr, status) {


                    window.status = status + "\r\n" + xhr.responseText;
                }
            });


        }

        function deleterow3(itemid) {
            var table = document.getElementById('Table4');
            table.deleteRow(itemid.parentNode.parentNode.rowIndex);

        }

        function makeslidessaved() {
            if ($('#sptestid').html() == '') {
             
                toast("Error", "Please Select Patient..!", "");
                return;
            }
            if ($('#noofblockslidesaved').val() == '') {
           
                toast("Error", "Please Select Block..!", "");
                $('#noofblockslidesaved').focus();
                return;
            }
            if ($('#stfromslidesaved').val() == '') {
            
                toast("Error", "Please Select No of Slides From..!", "");
                $('#stfromslidesaved').focus();
                return;
            }
            $("#Table4").find("tr:not(:first)").remove();
            for (var a = 0; a < parseInt($('#stfromslidesaved').val()) ; a++) {


                var a = $('#Table4 tr').length - 1;
                var mydata = '<tr style="background-color:white;height:30px;" id=' + $('#SlideNo').html() + '_' + $('#noofblockslidesaved').val() + '_' + parseFloat(a + 1) + '>';
                mydata += '<td>' + parseFloat(a + 1) + '</td>';
                mydata += '<td id="labno" align="left">' + $('#SlideNo').html() + '</td>';
                mydata += '<td id="BlockID" align="left">' + $('#noofblockslidesaved option:selected').val() + '</td>';
                mydata += '<td id="slideno" align="left">' + parseFloat(a + 1) + '</td>';
                mydata += '<td id="comment"><input type="text" id="txtcomment" style="width:100px;"/></td>';
                mydata += '<td><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow1(this)"/></td>';
                mydata += '</tr>';
                $('#Table4').append(mydata);

            }
        }

        function printdata() {
            window.open("HistoGrossLabel.aspx?testid=" + $('#sptestid').html() + "&labno=" + $('#VisitNo').html());
        }
        function printdata1() {
            window.open("HistoSlidesLabel.aspx?testid=" + $('#sptestid').html() + "&labno=" + $('#VisitNo').html());
        }
        function savecompletedata() {
            if ($('#Table3 tr').length == "1" || $('#Table3 tr').length == 0) {
              
                toast("Error", "Please Select Block..!", "");
                return;
            }
            if ($('#Table4 tr').length == "1" || $('#Table4 tr').length == 0) {
             
                toast("Error", "Please Make Slides..!", "");

                return;
            }
            var mydataadj = getcompletedataadjsaved();
            var mydataadj1 = getcompletedataslidessaved();


            $.ajax({
                url: "HistoCytoGrossing.aspx/savecompletedata",
                data: JSON.stringify({ mydataadj: mydataadj, mydataadj1: mydataadj1 }),
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 130000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {


                        if ($('#noofblockslidesaved option:selected').val() != $('#noofblockslidesaved option:last-child').val()) {
                            toast("Info", "First Block's Slides Saved Successfully Move To next..!", "");
                            $('#noofblockslidesaved option:selected').next().prop('selected', 'selected');
                            $("#Table4").find("tr:not(:first)").remove();
                            $("#stfromslidesaved").prop('selectedIndex', 0);

                        }
                        else {
                            toast("Success", "All Slides Saved Successfully..!", "");
                            $('#tableGrossing').hide();
                            $('#tableSliding').hide();
                            $('#tableAll').show();
                            $modelBlockUI();
                            getgrossdetail($('#sptestid').html());
                            getblockdetailsaved($('#sptestid').html());
                            $modelUnBlockUI();

                        }
                    }
                    else {
                        alert(result.d);
                    }

                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });

        }

        function getcompletedataadjsaved() {
            var tempData = [];
            $('#Table3 tr').each(function () {
                if ($(this).attr("id") != "Tr1") {
                    var itemmaster = [];
                    itemmaster[0] = $("#sptestid").html();
                    itemmaster[1] = $(this).find("#labno").html();
                    itemmaster[2] = $(this).find("#BlockID").html();
                    itemmaster[3] = $(this).find("#txtcomment").val();
                    var Gross = "";
                    var objEditor = CKEDITOR.instances['<%=Ckeditorcontrol1.ClientID%>'];
                        Gross = objEditor.getData();
                        if (Gross.trim() == "null" || Gross.trim() == "<br />") {
                            Gross = "";
                        }

                        itemmaster[4] = Gross;
                        itemmaster[5] = $("#pid").html();;
                        itemmaster[6] = $("#VisitNo").html();;
                        itemmaster[7] = $("#SampleType").html();;
                        tempData.push(itemmaster);
                    }
                });
                return tempData;
            }

            function getcompletedataslidessaved() {
                var tempData = [];
                $('#Table4 tr').each(function () {
                    if ($(this).attr("id") != "Tr2") {
                        var itemmaster = [];
                        itemmaster[0] = $("#sptestid").html();
                        itemmaster[1] = $(this).find("#labno").html();
                        itemmaster[2] = $(this).find("#BlockID").html();
                        itemmaster[3] = $(this).find("#slideno").html();
                        itemmaster[4] = $(this).find("#txtcomment").val();

                        tempData.push(itemmaster);
                    }
                });
                return tempData;
            }

            function markcomplete() {
                var testid = $("#sptestid").html();
                $.ajax({
                    url: "HistoCytoGrossing.aspx/markcomplete",
                    data: JSON.stringify({ testid: testid }),
                    contentType: "application/json; charset=utf-8",
                    type: "POST", // data has to be Posted 
                    timeout: 130000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            toast("Info", "Grossing and Sliding Complete Ready For Result Entry.!", "");
                          
                            clearform();
                            $('#tableGrossing').hide();
                            $('#tableSliding').hide();
                            $('#tableAll').hide();

                        }
                        else {
                         
                            toast("Error", result.d, "");
                        }

                    },
                    error: function (xhr, status) {
                        alert(xhr.responseText);
                    }
                });
            }


    </script>

    <script type="text/javascript">


        $(document).ready(function () {
            gethistotemplate();

        });

        function gethistotemplate() {

            var _val = "";
            $('#ddlGrossing option').remove();
            $('#ddlGrossing1 option').remove();

            $('#ddlGrossing').append($("<option></option>").val("0").html("Select"));
            $('#ddlGrossing1').append($("<option></option>").val("0").html("Select"));
            $.ajax({


                url: "LabResultEntrynew_Histo.aspx/LoadSpecimenTemplate",
                data: '{favonly:"0"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var template_list = $.parseJSON(result.d);

                    for (var k = 0; k < template_list.length; k++) {

                        if (template_list[k].Gross == "1") {
                            $('#ddlGrossing').append('<option value="' + template_list[k].Template_ID + '">' + template_list[k].Template_Name + '</option>');
                            $('#ddlGrossing1').append('<option value="' + template_list[k].Template_ID + '">' + template_list[k].Template_Name + '</option>');

                        }
                    }


                },
                error: function (xhr, status) {
                    //alert("Error.... ..");
                    //window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }

        function getTemplateHisto() {
            var _val = $('#ddlGrossing').val();

            $.ajax({

                url: "LabResultEntrynew_Histo.aspx/getTemplateHisto",
                data: '{Template_ID:"' + _val + '",Type:"Grossing"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    var template_list = $.parseJSON(result.d);
                    if (template_list.length == 1) {


                        var objEditor = CKEDITOR.instances['<%=txtHistoDatagross.ClientID%>'];
                        objEditor.setData(template_list[0].Template);


                    }

                },
                error: function (xhr, status) {
                    //  alert("Error.... ..");
                    //window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function getTemplateHisto1() {
            var _val = $('#ddlGrossing1').val();

            $.ajax({

                url: "LabResultEntrynew_Histo.aspx/getTemplateHisto",
                data: '{Template_ID:"' + _val + '",Type:"Grossing"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {

                    var template_list = $.parseJSON(result.d);
                    if (template_list.length == 1) {


                        var objEditor = CKEDITOR.instances['<%=Ckeditorcontrol1.ClientID%>'];
                            objEditor.setData(template_list[0].Template);


                        }

                    },
                    error: function (xhr, status) {
                        //  alert("Error.... ..");
                        //window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
    </script>
    </span>

</asp:Content>

