<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="coupon_master.aspx.cs" Inherits="Design_Coupon_coupon_master" EnableEventValidation="false" EnableViewState="true" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    <style type="text/css">
        .multiselect {
            width: 100%;
        }

        .GridCommonTemp {
            display: none;
        }
    </style>
  
     <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Coupon Master</b>
        </div>
        <div class="POuter_Box_Inventory" id="makerdiv">
            <div class="Purchaseheader">
                Centre/PUP Search 
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Business Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rl" runat="server" RepeatDirection="Horizontal" onchange="bindcenter1();">
                        <asp:ListItem Value="0" Selected="True">All</asp:ListItem>
                        <asp:ListItem Value="COCO">COCO</asp:ListItem>
                        <asp:ListItem Value="FOFO">FOFO</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Business Zone   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" ></asp:ListBox>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">State  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox onchange="bindtagprocessingtab()" ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server" ></asp:ListBox>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstType" CssClass="multiselect" SelectionMode="Multiple" runat="server"  onchange="bindcenter()"></asp:ListBox>

                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Tag Processing Lab   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="lsttagprocessinglab" class="lsttagprocessinglab chosen-select chosen-container" runat="server"  onchange="bindcenter()"></asp:DropDownList>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Centre </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstCentreLoadList" CssClass="multiselect" SelectionMode="Multiple" runat="server"  onchange="bindcenterinner($(this).val().toString())"></asp:ListBox>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Centre/PUP </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstCentreLoadListinner" CssClass="multiselect" SelectionMode="Multiple" runat="server" ></asp:ListBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Coupon Entry &nbsp; &nbsp; 
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Coupon Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtCouponName" runat="server" MaxLength='50' CssClass="requiredField"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Coupon Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <select id="ListCouponType" runat="server"></select>
                </div>
                <div class="col-md-1">
                    <input type="button" id="buttype" class="searchbutton" runat="server" value="New" onclick="ptype()" />
                   
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Coupon Category    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <select id="ListCouponCategory" runat="server">
                    </select>
                </div>
                <div class="col-md-1">
                    <input type="button" id="butcategory" class="searchbutton" runat="server" value="New" onclick="pcategory()" />
                    <asp:Button ID="butpccategory" class="searchbutton" runat="server" Style="display: none;"></asp:Button>
                   
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtentrydatefrom" runat="server" CssClass="requiredField" />
                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
               <div class="col-md-2"> </div>
                    <div class="col-md-3">
                        <label class="pull-left">To Date   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:TextBox ID="txtentrydateto" runat="server" CssClass="requiredField"/>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                 <div class="col-md-2"> </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblFileName" runat="server" Style="display: none;"></asp:Label>
                        <span style="font-weight: bold; display: none;" id="spnAttachment"><a href="javascript:void(0)" onclick="showuploadbox()" class="hyFileName" style="color: blue;"><b>Upload Document</b> </a></span>

                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Multiple Coupon Apply in a Booking   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <asp:CheckBox ID="chkmulticoupon"  runat="server" Checked="false" onclick="setMultiCoupon()"/>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">for Multiple Patient   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-1">
                        <asp:CheckBox ID="chkMultiplePatient" runat="server" Checked="false" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">for One Time Patient   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-1">
                        <asp:CheckBox ID="chkOneTimePatient"  runat="server" Checked="false" onclick="setOneTimePatient()"/>
                    </div>
                      <div class="col-md-6">
                        <label class="pull-left">One Coupon and One Mobile multiple billing   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-1">
                        <asp:CheckBox ID="chkOneCouponOneMobile"  runat="server" Checked="false" onclick="setOneCouponOneMobile()"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">WEEKEND   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:CheckBox ID="chkWeekEnd" onclick="setWeekEnd()"  runat="server" Checked="false" />
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">HappyHours   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-1">
                        <asp:CheckBox ID="chkHappyHours" onclick="setHappyHours()"  runat="server" Checked="false" />
                    </div>
                      <div class="col-md-3 tdWeekEndHappyHours" style="display:none">
                        <label class="pull-left">Days Applicable   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-13 tdWeekEndHappyHours" style="display:none">
                        <asp:CheckBoxList ID="chklDaysApplicable" RepeatDirection="Horizontal" RepeatLayout="Table" runat="server" >
                            <asp:ListItem Text="Sun" Value="Sun"></asp:ListItem>
                            <asp:ListItem Text="Mon" Value="Mon"></asp:ListItem>
                            <asp:ListItem Text="Tue" Value="Tue"></asp:ListItem>
                            <asp:ListItem Text="Wed" Value="Wed"></asp:ListItem>
                            <asp:ListItem Text="Thu" Value="Thu"></asp:ListItem>
                            <asp:ListItem Text="Fri" Value="Fri"></asp:ListItem>
                            <asp:ListItem Text="Sat" Value="Sat"></asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Min Billing Amount   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtminbooking" Text="0" runat="server" MaxLength='50'  onkeyup="showme(this);"></asp:TextBox>
                    </div>                
                    <div class="col-md-2">
                        <input type="radio" name="user_cat" value="1" checked="checked" onclick="showdiv();" />Total Bill 
                    </div>                  
                    <div class="col-md-3">
                        <input type="radio" name="user_cat" value="2" onclick="hidediv(); " />Testwise Bill
                    </div>
                </div>

                <div class="row trtotalbil">
                    <div class="col-md-3">
                        <label class="pull-left">Discount Amount </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtdisamt" runat="server" Text="0" MaxLength='50'  onkeyup="showme(this);"></asp:TextBox>
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">Discount % </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <asp:TextBox ID="txtdisper" runat="server" Text="0"  MaxLength="3" onkeyup="showme(this);"></asp:TextBox>
                    </div>
                </div>
                <div class="row trtestbill">
                    <div class="col-md-3">
                        <label class="pull-left">Department </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:ListBox ID="lstdepartment" CssClass="multiselect " SelectionMode="Multiple" runat="server"  onchange="bindtest($(this).val())"></asp:ListBox>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Test </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:ListBox ID="lsttest" CssClass="multiselect " SelectionMode="Multiple" runat="server" ></asp:ListBox>
                    </div>
                    <div class="col-md-3">
                        <input type="button" id="btnadd" class="searchbutton" value="Add" onclick="Addrow();" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <input type="radio" name="issuefor" value="1" checked="checked" onclick="checkissue();" />
                        All 
                          <input type="radio" name="issuefor" value="2" onclick="checkissue();" />
                        UHID 
                        <asp:TextBox ID="txtuhid" runat="server" Width="500px" placeholder="Enter UHID Seprate by Comma(,) or Upload Excel"></asp:TextBox>
                        <input type="radio" name="issuefor" value="3" onclick="checkissue();" />
                        Mobile 
                        <asp:TextBox ID="txtmobile" runat="server" AutoCompleteType="Disabled" Width="500px" TabIndex="3" placeholder="Enter Mobile Seprate by Comma(,) or Upload Excel"></asp:TextBox>
                        <span id="molen" style="font-weight: bold;"></span>
                        <input type="radio" name="issuefor" value="4" onclick="checkissue();" />
                        UHID With Coupon
                                <input type="radio" name="issuefor" value="5" onclick="checkissue();" />
                        Mobile With Coupon
                        <input type="radio" name="issuefor" value="6" onclick="checkissue();" />
                        Mobile With Coupon ( issue to patient separately)
                    </div>
                </div>
                <div class="row" id="mydiv2" style="display: none;">
                    <div class="col-md-24">
                        <a id="A211" href="ExcelFormat/excelformatvaluewithcouponuhid.xlsx" style="display: none;">Download Format Coupon With UHID</a>
                        <a id="A212" href="ExcelFormat/excelformatvaluewithcouponmobile.xlsx" style="display: none;">Download Format Coupon With Mobile</a>
                        <asp:Label ID="lblcowith" runat="server" Style="display: none;"></asp:Label>
                        <input type="button" value="Upload Coupon With Value" class="searchbutton" id="bntuploadexceltwo" />

                        &nbsp;&nbsp;
    
                            <span id="exceladded1" style="font-weight: bold; background-color: red; color: white;"></span>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12">
                        <asp:CheckBoxList ID="chkapplicable" runat="server" RepeatDirection="Horizontal" Font-Bold="true">
                            <asp:ListItem Value="1" Text="Work Order" Selected="True"> </asp:ListItem>
                            <asp:ListItem Value="2" Text="Website"></asp:ListItem>
                            <asp:ListItem Value="3" Text="PreBooking"></asp:ListItem>
                            <asp:ListItem Value="4" Text="HomeCollection"></asp:ListItem>
                        </asp:CheckBoxList>
                    </div>
                    <div class="col-md-12" id="mytd" style="display: none;">
                        <a id="A11" href="ExcelFormat/excelformatvaluemobile.xlsx" style="display: none;">Download Format For Mobile</a>
                        <a id="A12" href="ExcelFormat/excelformatvalueuhid.xlsx" style="display: none;">Download Format For UHID</a>
                        <asp:Label ID="lbtypelabel" runat="server" Style="display: none;"></asp:Label>
                        <input type="button" value="Upload" class="searchbutton" id="btnuploadexcel" />

                        &nbsp;&nbsp;
                            <span id="exceladded" style="font-weight: bold; background-color: red; color: white;"></span>
                    </div>
                </div>



            </div>
            <div class="POuter_Box_Inventory  trtestbill">
                <div class="Purchaseheader">
                    Add Test &nbsp; &nbsp; 
                </div>

                <div style="width: 100%;">
                    <table id="Testtable" style="border-collapse: collapse; width: 100%;">
                        <thead>
                            <tr id="tr1">
                                <td id="ttestcode" class="GridViewHeaderStyle" style="width: 350px;">Test Code</td>
                                <td id="ttestname" class="GridViewHeaderStyle" style="width: 350px;">Test Name</td>
                                <td id="tdepartment" class="GridViewHeaderStyle" style="width: 350px;">Department</td>
                                <td id="tddiscountper" class="GridViewHeaderStyle" style="width: 350px;">
                                    <input type="text" id="txtdiscperhead" placeholder="Disc % All" style="width: 80px" onkeyup="showme2(this)" name="t1" />
                                </td>
                                <td id="tddiscountamt" class="GridViewHeaderStyle" style="width: 350px;">
                                    <input type="text" id="txtdiscamthead" placeholder="Disc Amt All" style="width: 80px" onkeyup="showme2(this)" name="t2" /></td>
                                <td id="taction" class="GridViewHeaderStyle" style="width: 150px;">Action</td>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <div id="paging" style="float: right; margin-right: 1px;">
                    <input id="Prevbut" type="button" style="width: 10px; text-align: center" value="<" />
                    Page:<input id="txt_CurrentPage" type="text" style="width: 20px;" value="1" readonly="readonly" />of
              <label id="Tpage" for="myalue"></label>
                    <%--<span id="Tpage">10</span>--%>
                    <input id="Nextbut" type="button" style="width: 10px; text-align: center" value=">" />
                </div>
            </div>

             <div id="divCouponType" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 40%;max-width:42%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Coupon Type</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeCouponType()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
                          <div class="row">
		  <div class="col-md-6">
			   <label class="pull-left">Coupon Type</label>
			  <b class="pull-right">:</b>
		   </div>
                               <div class="col-md-14">
                                   <asp:TextBox ID="txtpcoupontype" runat="server" MaxLength="50" CssClass="requiredField"></asp:TextBox>
                                   </div>
             </div>
              <div class="row" style="text-align:center">
                   <input id="btncoupontypesave" type="button" value="Save" onclick="Savecoupontype()" class="searchbutton" />
                                        <button type="button"  onclick="$closeCouponType()">Close</button>
                  </div>
            
            </div>
        </div>
      </div>

  </div>

          
          <div id="divCouponCategory" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 40%;max-width:42%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Coupon Category</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeCouponCategory()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
                          <div class="row">
		  <div class="col-md-7">
			   <label class="pull-left">Coupon Category</label>
			  <b class="pull-right">:</b>
		   </div>
                               <div class="col-md-14">
                                   <asp:TextBox ID="txtpcouponcategory" runat="server" MaxLength="50" CssClass="requiredField"></asp:TextBox>
                                   </div>
             </div>
              <div class="row" style="text-align:center">
                   <input id="btnSaveCouponCategory" type="button" value="Save" onclick="Savecouponcategory()" class="searchbutton" />
                                        <button type="button"  onclick="$closeCouponCategory()">Close</button>
                  </div>
            
            </div>
        </div>
      </div>

  </div>

           
            <div class="POuter_Box_Inventory" id="mydiv1">
                <div class="Purchaseheader">
                    Add Coupon Code: &nbsp; &nbsp; 
                </div>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                <div>
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td>
                                <input type="text" id="txtlistcode" maxlength="50" style="width: 400px" />
                                <label id="lblfile" style="color: red; font-size: 12px;"><i>* Enter Coupon Code Seprated by Comma(,) Or Download Excel and Fill It and Press Upload Button</i> </label>
                            </td>
                            <td><a id="forfile" href="ExcelFormat/excelformat.xlsx">Download Format</a>
                            </td>
                            <td>
                                <asp:Label ID="lbfilename" runat="server" Style="display: none;"></asp:Label>
                                <input type="button" value="Upload" class="searchbutton" id="btnuploadfile" /><%--onclick="showuploadboxfile()"--%>                              
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style=" text-align: center;">
                    <input type="button" value="Save" class="searchbutton" onclick="savedata();" id="btnsave" />
                    <span id="fileadded" style="font-weight: bold; background-color: red; color: white;"></span>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content">
                    <div class="Purchaseheader">
                        All Coupons
                    </div>
                    <div style="width: 100%; max-height: 200px; overflow: auto;">
                        <table id="tblcoupon" style="border-collapse: collapse; width: 100%; max-height: 200px; overflow: auto;">

                            <tr id="trquuheader">
                                <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                <td class="GridViewHeaderStyle" style="width: 120px; cursor: pointer;" onclick="sortTable(1)">Coupon Name
                                &nbsp;<img src="../../App_Images/down_arrow.png" />
                                </td>
                                <td class="GridViewHeaderStyle" style="width: 120px; cursor: pointer;" onclick="sortTable(2)">Coupon Type
                                &nbsp;<img src="../../App_Images/down_arrow.png" />
                                </td>
                                <td class="GridViewHeaderStyle" style="width: 120px; cursor: pointer;" onclick="sortTable(3)">Coupon Category
                                &nbsp;<img src="../../App_Images/down_arrow.png" />
                                </td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Valid From</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Valid To</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Min. Limit</td>
                                <td class="GridViewHeaderStyle" style="width: 80px;">Issue For</td>
                                <td class="GridViewHeaderStyle" style="width: 120px; cursor: pointer;" onclick="sortTable(7)">Applicable
                                  &nbsp;<img src="../../App_Images/down_arrow.png" />
                                </td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Discount Amt.</td>
                                <td class="GridViewHeaderStyle" style="width: 20px;">Discount(%)</td>
                                <%--  <td class="GridViewHeaderStyle" style="width:120px;">Applicable</td>--%>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Multiple Coupon Apply </td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Multiple Patient Coupon </td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">One Time Coupon </td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">WeekEnd / HappyHours </td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Days </td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">View Center/PUP</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">View Test</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">View Coupon</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Status</td>
                                <td class="GridViewHeaderStyle" style="width: 120px;">Change Status</td>
                                <td class="GridViewHeaderStyle" style="width: 20px;">#</td>


                            </tr>
                        </table>
                    </div>
                </div>
            </div>

        </div>       
     <div id="divCouponCentre" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 40%;max-width:42%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Coupon Centre Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeCouponCentre()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
                          <div style="width: 100%; max-height: 400px; overflow: auto;">
                                <div class="row">
                             <div class="col-md-6">
			   <label class="pull-left"> Search Centre</label>
			  <b class="pull-right">:</b>
		   </div>
                <div class="col-md-14">
                     <asp:TextBox ID="txtcentresearch" runat="server" placeholder="Enter Centre Name"/>
                    </div>
                                      </div>
           <div class="row">
                <table id="viewcenter" style="width: 100%; border-collapse: collapse; text-align: left;">
                    <tr>
                        <td class="GridViewHeaderStyle" style="width: 20px;">Center
                            <span style="margin-left: 100px;">Total Center : 
                                <asp:Label ID="lbltotalcountcentre" runat="server"></asp:Label></span>
                        </td>
                    </tr>

                </table>
</div>
            </div>
              <div class="row" style="text-align:center">
                 
                                        <button type="button"  onclick="$closeCouponCentre()">Close</button>
                  </div>
            
            </div>
        </div>
      </div>

  </div>
     <div id="divTest" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 40%;max-width:42%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Coupon Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeTest()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
                          <div style="width: 100%; max-height: 400px; overflow: auto;">
                                <div class="row">
                             <table id="viewtest" style="width: 100%; border-collapse: collapse; text-align: center; height: 87px;">
                    <tr>
                        <td class="GridViewHeaderStyle" style="width: 20px;">Test</td>
                        <td class="GridViewHeaderStyle" style="width: 20px;">Disc%</td>
                        <td class="GridViewHeaderStyle" style="width: 20px;">Disc Amt</td>
                    </tr>
                </table>
</div>
            </div>
              <div class="row" style="text-align:center">
                 
                                        <button type="button"  onclick="$closeTest()">Close</button>
                  </div>
            
            </div>
        </div>
      </div>

  </div>    
     <div id="divType" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 40%;max-width:42%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Coupon Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeType()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
                          <div style="width: 100%; max-height: 400px; overflow: auto;">
                                <div class="row">
                            <table id="viewtype" style="width: 100%; border-collapse: collapse; text-align: center;">
                    <tr>
                        <td class="GridViewHeaderStyle">Issue Type</td>
                        <td class="GridViewHeaderStyle">Issue For</td>
                    </tr>
                </table>
</div>
            </div>
              <div class="row" style="text-align:center">
                 
                                        <button type="button"  onclick="$closeType()">Close</button>
                  </div>
            
            </div>
        </div>
      </div>

  </div>      
     <div id="divTypewithData" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 40%;max-width:42%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Coupon Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeTypewithData()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
                          <div style="width: 100%; max-height: 400px; overflow: auto;">
                                <div class="row">
                            <table id="viewtypewithdata" style="width: 100%; border-collapse: collapse; text-align: center; height: 87px;">
                    <tr>
                        <td class="GridViewHeaderStyle">Coupon Code</td>
                        <td class="GridViewHeaderStyle">Issue Type</td>
                        <td class="GridViewHeaderStyle">Issue For</td>
                    </tr>
                </table>
</div>
            </div>
              <div class="row" style="text-align:center">
                 
                                        <button type="button"  onclick="$closeTypewithData()">Close</button>
                  </div>
            
            </div>
        </div>
      </div>

  </div>              
     <div id="divCoupanCode" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 40%;max-width:42%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Coupon Detail</h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeCoupon()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
     	<div class="modal-body" >
                          <div style="width: 100%; max-height: 400px; overflow: auto;">
                                <div class="row">
                             <div class="col-md-8">
			   <label class="pull-left"> Search Coupon Code</label>
			  <b class="pull-right">:</b>
		   </div>
                <div class="col-md-14">
                     <asp:TextBox ID="txtcouponsearch" runat="server" placeholder="Enter Coupon Code"  />
                    </div>
                                      </div>
           <div class="row">
                <table id="tblcouponcode" style="width: 100%; border-collapse: collapse; text-align: center;">
                    <tr>
                        <td class="GridViewHeaderStyle" style="width: 20px; text-align: left;">Couoan Code      <span style="margin-left: 100px;">Total Coupon : 
                        <asp:Label ID="lbltotalcount" runat="server"></asp:Label></span></td>

                    </tr>
                </table>
</div>
            </div>
              <div class="row" style="text-align:center">
                 
                                        <button type="button"  onclick="$closeCoupon()">Close</button>
                  </div>
            
            </div>
        </div>
      </div>

  </div>

       
    <script type="text/javascript">
        var approvaltypemaker = '<%=approvaltypemaker %>';
        var approvaltypereject = '<%=approvaltypereject %>';
        var approvaltypestatuschange = '<%=approvaltypestatuschange %>';        
        $(function () {
            if (approvaltypemaker == "1") {
                $('#makerdiv').show();
            }
            else {
                $('#makerdiv').hide();
            }
            checkissue();
            Bindtabledata();
            Current_PageNumber = 1;
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            $('[id*=lstCentreLoadList],[id*=lstCentreLoadListinner],[id*=lstZone],[id*=lstState],[id*=lstdepartment],[id*=lsttest]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindZone();
            binddepartment();
            showdiv();
            var data = $('#chkapplicable').find("tr").eq(0).find("td").eq(0).html();
            data = data.replace(data, "Applicable : " + data);
            $('#chkapplicable').find("tr").eq(0).find("td").eq(0).html(data);

        });
        function Savecoupontype() {
            var coupontype = $('#<%=txtpcoupontype.ClientID%>').val();
            if (coupontype != "") {
                serverCall('coupon_master.aspx/InsertCtype', { CouponType: coupontype }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        $('#<%=txtpcoupontype.ClientID%>').val('');
                        jQuery('#ListCouponType').append($("<option></option>").val($responseData.ID).html(coupontype));
                        jQuery('#ListCouponType').val($responseData.ID);
                        $("#ListCouponType").trigger('chosen:updated');
                        toast('Sucess', "Coupon Type saved successfully.");
                        jQuery('#divCouponType').hideModel();
                    }
                });              
            }
            else {
                toast('Error', "Please Enter Coupon Type");
            }           
        }
        $closeCouponType = function () {
            $('#<%=txtpcoupontype.ClientID%>').val('');
            jQuery('#divCouponType').hideModel();
        }

            function Savecouponcategory() {
                var couponcategory = $('#<%=txtpcouponcategory.ClientID%>').val();
                if (couponcategory != "") {
                    serverCall('coupon_master.aspx/InsertCCategory', { Couponcategory: couponcategory }, function (response) {
                        var $responseData = JSON.parse(response);
                        if ($responseData.status) {
                            jQuery('#ListCouponCategory').append($("<option></option>").val($responseData.ID).html(couponcategory));
                            jQuery('#ListCouponCategory').val($responseData.ID);
                            $("#ListCouponCategory").trigger('chosen:updated');
                            $('#<%=txtpcouponcategory.ClientID%>').val('');
                            toast('Sucess', "Coupon category saved successfully.");
                            
                            jQuery("#divCouponCategory").hideModel();
                        }
                    });
                   
                }
                else {
                    toast('Error', "Please Enter Coupon category");
                    $('#<%=txtpcouponcategory.ClientID%>').focus();
                }
            }
        function bindZone() {
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                BusinessZoneID = jQuery.parseJSON(response);
                for (i = 0; i < BusinessZoneID.length; i++) {
                    jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                }
                $('[id*=lstZone]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        }
            $('#lstZone').on('change', function () {
                jQuery('#<%=lstState.ClientID%> option').remove();
                jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
                jQuery('#<%=lstCentreLoadListinner.ClientID%> option').remove();
                jQuery('#lstState').multipleSelect("refresh");
                jQuery('#lstCity').multipleSelect("refresh");
                jQuery('#lstCentreLoadList').multipleSelect("refresh");
                jQuery('#lstCentreLoadListinner').multipleSelect("refresh");
                var BusinessZoneID = $(this).val();
                bindBusinessZoneWiseState(BusinessZoneID.toString());
            });
            function bindcenter1() {
                bindcenter();
            }
            function bindcenterinner(centreid) {
                var btype = $('#<%=rl.ClientID%> input:checked').val();
                jQuery('#<%=lstCentreLoadListinner.ClientID%> option').remove();
                jQuery('#lstCentreLoadListinner').multipleSelect("refresh");
                if (centreid != "") {
                    serverCall('coupon_master.aspx/bindCentreLoadinner', { centreid: centreid,btype:btype }, function (response) {
                        CentreLoadListData = jQuery.parseJSON(response);
                        jQuery('#lstCentreLoadListinner').html('');
                        var CenterData = '';
                        for (i = 0; i < CentreLoadListData.length; i++) {
                            CenterData += CentreLoadListData[i].CentreID + ',';
                            jQuery("#lstCentreLoadListinner").append(jQuery('<option></option>').val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                        }
                        CenterData = CenterData.substring(0, CenterData.length - 1);
                        jQuery('[id*=lstCentreLoadListinner]').multipleSelect({
                            includeSelectAllOption: true,
                            filter: true, keepOpen: false
                        });
                    });                    
                }
            }
        function bindcenter() {
            var btype = $('#<%=rl.ClientID%> input:checked').val();
            jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
            jQuery('#lstCentreLoadList').multipleSelect("refresh");
            jQuery('#<%=lstCentreLoadListinner.ClientID%> option').remove();
            jQuery('#lstCentreLoadListinner').multipleSelect("refresh");
            var tagprocessinglab = jQuery('#<%=lsttagprocessinglab.ClientID%>').val().toString();
            serverCall('coupon_master.aspx/bindCentreLoad', { Type1: jQuery('#<%=lstType.ClientID%>').val().toString(), btype: btype, StateID: jQuery('#<%=lstState.ClientID%>').val().toString(), ZoneId: jQuery('#<%=lstZone.ClientID%>').val().toString(), tagprocessinglab: tagprocessinglab }, function (response) {
                CentreLoadListData = jQuery.parseJSON(response);
                jQuery('#lstCentreLoadList').html('');
                var CenterData = '';
                for (i = 0; i < CentreLoadListData.length; i++) {
                    CenterData += CentreLoadListData[i].CentreID + ',';
                    jQuery("#lstCentreLoadList").append(jQuery('<option></option>').val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                }
                CenterData = CenterData.substring(0, CenterData.length - 1);
                jQuery('[id*=lstCentreLoadList]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        }
        function bindtagprocessingtab() {
            var btype = $('#<%=rl.ClientID%> input:checked').val();
            jQuery('#<%=lsttagprocessinglab.ClientID%> option').remove();
            $("#<%=lsttagprocessinglab.ClientID%>").trigger('chosen:updated');
            jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
            jQuery('#lstCentreLoadList').multipleSelect("refresh");
            jQuery('#<%=lstCentreLoadListinner.ClientID%> option').remove();
            jQuery('#lstCentreLoadListinner').multipleSelect("refresh");
            var StateID = jQuery('#<%=lstState.ClientID%>').val().toString();
            var TypeId = jQuery('#<%=lstType.ClientID%>').val().toString();
            var ZoneId = jQuery('#<%=lstZone.ClientID%>').val().toString();
            serverCall('coupon_master.aspx/bindtagprocessinglabLoad', { Type1: TypeId, btype: btype, StateID: StateID, ZoneId: ZoneId }, function (response) {
                CentreLoadListData = jQuery.parseJSON(response);
                jQuery('#lstCentreLoadList').html('');
                var CenterData = '';
                jQuery("#lsttagprocessinglab").append(jQuery('<option></option>').val("-1").html("Select"));
                jQuery("#lsttagprocessinglab").append(jQuery('<option></option>').val("0").html("ALL"));
                for (i = 0; i < CentreLoadListData.length; i++) {
                    CenterData += CentreLoadListData[i].CentreID + ',';
                    jQuery("#lsttagprocessinglab").append(jQuery('<option></option>').val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                }
                CenterData = CenterData.substring(0, CenterData.length - 1);
                $("#<%=lsttagprocessinglab.ClientID%>").trigger('chosen:updated');
            });
        }
        function bindBusinessZoneWiseState(BusinessZoneID) {
            if (BusinessZoneID != "") {
                serverCall('../Common/Services/CommonServices.asmx/bindBusinessZoneWiseState', { BusinessZoneID: BusinessZoneID }, function (response) {
                    stateData = jQuery.parseJSON(response);
                    for (i = 0; i < stateData.length; i++) {
                        jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                    }
                    jQuery('[id*=lstState]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });

            }

        }
        function bindtype() {
            serverCall('coupon_master.aspx/bindtypedb', {}, function (response) {
                typedata = jQuery.parseJSON(response);
                for (var a = 0; a <= typedata.length - 1; a++) {
                    $('#lstType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].TEXT));
                }

                $('[id*=lstType]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });


        }
        function bindBusinessZoneAndStateAndCityWiseCentre(BusinessZoneID, StateID) {
            if (StateID != "") {
                serverCall('coupon_master.aspx/bindCentreLoad', { BusinessZoneID: BusinessZoneID, StateID: StateID }, function (response) {
                    CentreLoadListData = jQuery.parseJSON(response);
                    for (i = 0; i < CentreLoadListData.length; i++) {
                        jQuery("#lstCentreLoadList").append(jQuery("<option></option>").val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Centre));
                    }
                    jQuery('[id*=lstCentreLoadList]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });

            }

        }
            function binddepartment() {
                
                jQuery('#<%=lstdepartment.ClientID%> option').remove();
                jQuery('#lstdepartment').multipleSelect("refresh");
                serverCall('coupon_master.aspx/binddepartmenttype', { }, function (response) {
                    typedata = jQuery.parseJSON(response);
                    for (var a = 0; a <= typedata.length - 1; a++) {
                        $('#lstdepartment').append($("<option></option>").val(typedata[a].subcategoryid).html(typedata[a].NAME));
                    }
                    $('[id*=lstdepartment]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });                
            }
        function bindcoupontype() {
            serverCall('coupon_master.aspx/bindcoupontypedb', {  }, function (response) {               
                $('#<%=ListCouponType.ClientID%>').html('');
                $('#<%=ListCouponType.ClientID%>').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'CoupanType', isSearchAble: true });               
            });               
    }

        
        function bindcouponcategory() {
            serverCall('coupon_master.aspx/bindcouponcategorydb', {  }, function (response) {
                $('#<%=ListCouponCategory.ClientID%>').html('');
                $('#<%=ListCouponCategory.ClientID%>').bindDropDown({defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'CoupanCategory', isSearchAble: true });             
            });
            
        }

        
        function bindtest(v) {
            jQuery('#<%=lsttest.ClientID%> option').remove();
            jQuery('#lsttest').multipleSelect("refresh");
            var testvalue = v;
            var ftestvalue = testvalue[0].split('#');
            if (v != "") {
                serverCall('coupon_master.aspx/bindtest', { scid: ftestvalue[0] }, function (response) {
                    stateData = jQuery.parseJSON(response);
                    for (i = 0; i < stateData.length; i++) {
                        jQuery("#lsttest").append(jQuery("<option></option>").val(stateData[i].itemid).html(stateData[i].typename));
                    }
                    jQuery('[id*=lsttest]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                });
               
            }
        }
    </script>
    <script type="text/javascript">
        function showme(ctrl) {
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');
                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }
        }
        function showme1(ctrl) {
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');
                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }
            if ($(ctrl).attr('id') == "txtdiscper") {
                $(ctrl).closest('tr').find('#txtdiscamt').val('');
                if ($(ctrl).val() > 100) {
                    $(ctrl).val('100');
                }
            }
            if ($(ctrl).attr('id') == "txtdiscamt") {
                $(ctrl).closest('tr').find('#txtdiscper').val('');

            }
        }
        function showme2(ctrl) {
            if ($(ctrl).val().indexOf(" ") != -1) {
                $(ctrl).val($(ctrl).val().replace(' ', ''));
            }
            var nbr = $(ctrl).val();
            var decimalsQty = nbr.replace(/[^.]/g, "").length;
            if (parseInt(decimalsQty) > 1) {
                $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
            }
            if ($(ctrl).val().length > 1) {
                if (isNaN($(ctrl).val() / 1) == true) {
                    $(ctrl).val($(ctrl).val().substring(0, $(ctrl).val().length - 1));
                }
            }
            if (isNaN($(ctrl).val() / 1) == true) {
                $(ctrl).val('');

                return;
            }
            else if ($(ctrl).val() < 0) {
                $(ctrl).val('');
                return;
            }
            if ($(ctrl).attr('id') == "txtdiscperhead") {
                $(ctrl).closest('tr').find('#txtdiscamthead').val('');
                var name = "t2";
                $('input[name="' + name + '"]').each(function () {
                    $(this).val('');
                });
                if ($(ctrl).val() > 100) {
                    $(ctrl).val('100');
                }
            }
            if ($(ctrl).attr('id') == "txtdiscamthead") {
                $(ctrl).closest('tr').find('#txtdiscperhead').val('');
                var name = "t1";
                $('input[name="' + name + '"]').each(function () {
                    $(this).val('');
                });

            }

            var val = $(ctrl).val();
            var name = $(ctrl).attr("name");
            $('input[name="' + name + '"]').each(function () {
                $(this).val(val);
            });
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function hidediv() {
            $('.trtotalbil').hide();
            $('.trtestbill').show();
            binddepartment();
            jQuery('#<%=lsttest.ClientID%> option').remove();
            jQuery('#lsttest').multipleSelect("refresh");
            jQuery('#<%=lsttest.ClientID%>').multipleSelect("enable");
            jQuery('#<%=lstdepartment.ClientID%>').multipleSelect("enable");
        }
        function showdiv() {
            $('.trtotalbil').show();
            $('.trtestbill').hide();
            jQuery('#<%=lsttest.ClientID%>').multipleSelect("disable");
            jQuery('#<%=lstdepartment.ClientID%>').multipleSelect("disable");
        }

    </script>
    <script type="text/javascript">
        var count = 1;
        function savedata() {
            if ((JSON.stringify($('#lstZone').val()) == '[]')) {
                toast('Error', "Please Select Zone ");
                $('#lstZone').focus();
                return;
            }
            if ((JSON.stringify($('#lstState').val()) == '[]')) {
                toast('Error', "Please Select state");
                $('#lstState').focus();
                return;
            }
            if ((JSON.stringify($('#lstCentreLoadListinner').val()) == '[]')) {
                toast('Error', "Please Select Center/PUP ");
                $('#lstCentreLoadListinner').focus();
                return;
            }
            if ($('#<%=txtCouponName.ClientID%>').val() == "") {
                toast('Error', "Please Enter CouponName ");
                $('#<%=txtCouponName.ClientID%>').focus();
                return;
            }
            if ($('#<%=ListCouponType.ClientID%> option:selected').val() == "0") {
                toast('Error', "Please Select CouponType ");
                $('#<%=ListCouponType.ClientID%>').focus();
                return;
            }
            if ($('#<%=ListCouponCategory.ClientID%> option:selected').val() == "0") {
                toast('Error', "Please Select CouponCategory ");
                $('#<%=ListCouponCategory.ClientID%>').focus();
                return;
            }
            if ($('#<%=txtentrydatefrom.ClientID%>').val() == "") {
                toast('Error', "Please Enter from date ");
                $('#<%=txtentrydatefrom.ClientID%>').focus();
                return;
            }
            if ($('#<%=txtentrydateto.ClientID%>').val() == "") {
                toast('Error', "Please Enter to date ");
                $('#<%=txtentrydateto.ClientID%>').focus();
                return;
            }
            var StartDate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var EndDate = $('#<%=txtentrydateto.ClientID%>').val();
            var eDate = new Date(EndDate);
            var sDate = new Date(StartDate);
            if (StartDate != '' && EndDate != '' && sDate > eDate) {
                toast('Error', "Please ensure that the End Date is greater than or equal to the Start Date.");
                return false;
            }
            if ($('#<%=txtminbooking.ClientID%>').val() == "") {
                $('#<%=txtminbooking.ClientID%>').val("0");
            }
            if ($('#<%=txtdisper.ClientID%>').val() != "" && $('#<%=txtdisper.ClientID%>').val() != "0") {
                if ($('#<%=txtdisper.ClientID%>').val() > 100) {
                    toast('Error', "Please Enter discount percent less than 100.");
                    $('#<%=txtdisper.ClientID%>').focus();
                    return;
                }
            }
            if ($("input[name='issuefor']:checked").val() != "4" && $("input[name='issuefor']:checked").val() != "5") {
                if ($('#<%=lbfilename.ClientID%>').text() == "" && $('#fileadded').html() == "") {
                    if ($('#txtlistcode').val() == "") {
                        toast('Error', "Please Enter Coupon code. ");
                        $('#txtlistcode').focus();
                        return;
                    }
                }
            }

            if ($("input[name='issuefor']:checked").val() == "2" && $('#txtuhid').val() == "" && $('#<%=lbtypelabel.ClientID%>').text() == "") {
                toast('Error', "Please Enter UHID or Upload Excel");
                $('#txtuhid').focus();
                return;
            }

            if ($("input[name='issuefor']:checked").val() == "3" && $('#txtmobile').val() == "" && $('#<%=lbtypelabel.ClientID%>').text() == "") {

                toast('Error', "Please Enter Mobile No or Upload Excel");
                $('#txtuhid').focus();
                return;
            }
            if ($("input[name='issuefor']:checked").val() == "4" && $('#<%=lblcowith.ClientID%>').text() == "") {
                toast('Error', "Please  Upload Excel");
                return;
            }
            if ($("input[name='issuefor']:checked").val() == "5" && $('#<%=lblcowith.ClientID%>').text() == "") {
                toast('Error', "Please  Upload Excel");
                return;
            }
            if ($("#chkMultiplePatient").is(':checked') && $("#chkOneTimePatient").is(':checked')) {
                toast('Error', "You can not check for multiple patient and for one time patient at once");
                return;
            }
            var nn = '0';
            if ($("input[name='user_cat']:checked").val() == "2") {

                if ($('#<%=txtdisamt.ClientID%>').val() == "" && $('#<%=txtdisper.ClientID%>').val() == "") {
                    toast('Error', "Please Enter discount amount.");
                    $('#<%=txtdisamt.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtdisamt.ClientID%>').val() == "0" && $('#<%=txtdisper.ClientID%>').val() == "") {
                    toast('Error', "Please Enter discount percent.");
                    $('#<%=txtdisamt.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtdisamt.ClientID%>').val() == "" && $('#<%=txtdisper.ClientID%>').val() == "0") {
                    toast('Error', "Please Enter discount amount.");
                    $('#<%=txtdisamt.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtdisamt.ClientID%>').val() == "") {
                    $('#<%=txtdisamt.ClientID%>').val('0');
                }
                if ($('#<%=txtdisper.ClientID%>').val() == "") {
                    $('#<%=txtdisper.ClientID%>').val('0');
                }
                var dataIm = new Array();
                $('[id$=Testtable]').find('tr').each(function (index) {
                    if (index > 0) {
                        var obj = new Object();
                        var Centres = $('#lstCentreLoadListinner').val().toString();
                        var departments = $('#lstdepartment').val().toString();
                        obj.fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
                        obj.todate = $('#<%=txtentrydateto.ClientID%>').val();
                        obj.minimumamount = $('#<%=txtminbooking.ClientID%>').val();
                        obj.billtype = "2";
                        obj.centers = Centres;
                        obj.discountpercent = $("#Testtable").find("tr").eq(index).find('#txtdiscper').val() == "" ? 0 : $("#Testtable").find("tr").eq(index).find('#txtdiscper').val();
                        obj.discountamount = $("#Testtable").find("tr").eq(index).find('#txtdiscamt').val() == "" ? 0 : $("#Testtable").find("tr").eq(index).find('#txtdiscamt').val();
                        if (obj.discountpercent == 0 && obj.discountamount == 0) {
                            nn = '1';
                        }
                        obj.subcategoryids = $("#Testtable").find("tr").eq(index).find("td").eq(2)[0].attributes[0].nodeValue;
                        obj.items = $("#Testtable").find("tr").eq(index).find("td").eq(1)[0].attributes[0].nodeValue;
                        obj.CouponName = $('#<%=txtCouponName.ClientID%>').val();
                        obj.TempId = $('#lblFileName').text();
                        obj.CoupanCode = $('#txtlistcode').val();
                        obj.CouponTypeId = $('#<%=ListCouponType.ClientID%>').val();
                        obj.CouponType = $('#<%=ListCouponType.ClientID%> option:selected').text();
                        obj.CouponCategoryId = $('#<%=ListCouponCategory.ClientID%>').val();
                        obj.CouponCategory = $('#<%=ListCouponCategory.ClientID%> option:selected').text();
                        obj.DaysApplicable = "";
                        var issuetype = "";
                        if ($("input[name='issuefor']:checked").val() == "1")
                            issuetype = "ALL";
                        else if ($("input[name='issuefor']:checked").val() == "2")
                            issuetype = "UHID";
                        else if ($("input[name='issuefor']:checked").val() == "3")
                            issuetype = "Mobile";
                        else if ($("input[name='issuefor']:checked").val() == "4")
                            issuetype = "UHIDWithCoupan";
                        else if ($("input[name='issuefor']:checked").val() == "5")
                            issuetype = "MobileWithCoupan";
                        else if ($("input[name='issuefor']:checked").val() == "6")
                            issuetype = "OneCoupanOneMobile";
                        obj.issuefor = issuetype;
                        obj.UHID = $('#<%=txtuhid.ClientID%>').val();
                        obj.Mobile = $('#<%=txtmobile.ClientID%>').val();
                        var selectedValues = "";
                        $("[id*=chkapplicable] input:checked").each(function () {
                            selectedValues += $(this).val() + ",";
                        });

                        obj.ApplicableFor = selectedValues;
                        if ($("#chkmulticoupon").is(":checked")) {
                            obj.IsmultipleCouponApply = 1;
                        } else {
                            obj.IsmultipleCouponApply = 0;
                        }
                        obj.IsMultiplePatientCoupon = $("#chkMultiplePatient").is(':checked') ? 1 : 0;
                        obj.IsOneTimePatientCoupon = $("#chkOneTimePatient").is(':checked') ? 1 : 0;
                        dataIm.push(obj);
                    }
                });
                if (nn == "1") {
                    toast('Error', "Please Enter discount amount or discount per in item table.");
                    return;
                }
            }
            if ($("input[name='user_cat']:checked").val() == "1") {
                if ($('#<%=txtdisamt.ClientID%>').val() == "") {
                    $('#<%=txtdisamt.ClientID%>').val('0');
                }
                if ($('#<%=txtdisper.ClientID%>').val() == "") {
                    $('#<%=txtdisper.ClientID%>').val('0');
                }
                if ($('#<%=txtdisamt.ClientID%>').val() == "0" && $('#<%=txtdisper.ClientID%>').val() == "0") {
                    toast('Error', "Please Enter discount or Discount %");
                    $('#<%=txtdisamt.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtdisamt.ClientID%>').val() == "0" && $('#<%=txtdisper.ClientID%>').val() == "") {
                    toast('Error', "Please Enter discount percent.");
                    $('#<%=txtdisamt.ClientID%>').focus();
                    return;
                }
                if ($('#<%=txtdisamt.ClientID%>').val() == "" && $('#<%=txtdisper.ClientID%>').val() == "0") {
                    toast('Error', "Please Enter discount amount.");
                    $('#<%=txtdisamt.ClientID%>').focus();
                    return;
                }
                var Centres = $('#lstCentreLoadListinner').val().toString();
                var departments = "";
                var dataIm = new Array();
                var obj = new Object();
                obj.fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
                obj.todate = $('#<%=txtentrydateto.ClientID%>').val();
                obj.minimumamount = $('#<%=txtminbooking.ClientID%>').val();
                obj.discountpercent = $('#<%=txtdisper.ClientID%>').val();
                obj.discountamount = $('#<%=txtdisamt.ClientID%>').val();
                obj.billtype = "1";
                obj.centers = Centres;
                obj.subcategoryids = departments;
                obj.TempId = $('#lblFileName').text();
                obj.CoupanCode = $('#txtlistcode').val();
                obj.CouponName = $('#<%=txtCouponName.ClientID%>').val();
                obj.CouponTypeId = $('#<%=ListCouponType.ClientID%>').val();
                obj.CouponType = $('#<%=ListCouponType.ClientID%> option:selected').text();
                obj.CouponCategoryId = $('#<%=ListCouponCategory.ClientID%>').val();
                obj.CouponCategory = $('#<%=ListCouponCategory.ClientID%> option:selected').text();
                var issuetype = "";
                if ($("input[name='issuefor']:checked").val() == "1")
                    issuetype = "ALL";
                else if ($("input[name='issuefor']:checked").val() == "2")
                    issuetype = "UHID";
                else if ($("input[name='issuefor']:checked").val() == "3")
                    issuetype = "Mobile";
                else if ($("input[name='issuefor']:checked").val() == "4")
                    issuetype = "UHIDWithCoupan";
                else if ($("input[name='issuefor']:checked").val() == "5")
                    issuetype = "MobileWithCoupan";
                else if ($("input[name='issuefor']:checked").val() == "6")
                    issuetype = "OneCoupanOneMobile";
                obj.issuefor = issuetype;
                obj.UHID = $('#<%=txtuhid.ClientID%>').val();
                obj.Mobile = $('#<%=txtmobile.ClientID%>').val();
                obj.items = "";
                var selectedValues = "";
                $("[id*=chkapplicable] input:checked").each(function () {
                    selectedValues += $(this).val() + ",";
                });
                obj.ApplicableFor = selectedValues;
                if ($("#chkmulticoupon").is(":checked")) {
                    obj.IsmultipleCouponApply = 1;
                } else {
                    obj.IsmultipleCouponApply = 0;
                }
                obj.IsMultiplePatientCoupon = $("#chkMultiplePatient").is(':checked') ? 1 : 0;
                obj.IsOneTimePatientCoupon = $("#chkOneTimePatient").is(':checked') ? 1 : 0;
                obj.WeekEnd = $("#chkWeekEnd").is(':checked') ? 1 : 0;
                obj.HappyHours = $("#chkHappyHours").is(':checked') ? 1 : 0;
                var DaysApplicable = "";
                if ($("#chkWeekEnd").is(':checked') || $("#chkHappyHours").is(':checked')) {
                    $("#chklDaysApplicable input:checked").each(function () {
                        DaysApplicable += $(this).val() + ",";
                    });
                }
                obj.DaysApplicable = DaysApplicable;
                var OneCouponOneMobileMultipleBilling=$("#chkOneCouponOneMobile").is(':checked') ? 1 : 0;
                obj.OneCouponOneMobileMultipleBilling = OneCouponOneMobileMultipleBilling;
                if (OneCouponOneMobileMultipleBilling == "1")
                    obj.IsMultiplePatientCoupon = 1;
                dataIm.push(obj);
            }

            $("#btnsave").attr('disabled', true).val("Saving..");
            var filename = $('#<%=lbfilename.ClientID%>').text();
            var filenametype = $('#<%=lbtypelabel.ClientID%>').text();
            var filenametypewithcoupon = $('#<%=lblcowith.ClientID%>').text();
            serverCall('coupon_master.aspx/Savecoupon', { Allitem: dataIm, filename: filename, filenametype: filenametype, filenametypewithcoupon: filenametypewithcoupon }, function (response) {
                var save = response;

                if (save.split('#')[0] == "1") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    $('#lblFileName').text('');
                    clearForm();
                    Bindtabledata();
                    toast('Sucess', "Data Save successfully");
                    window.location.reload();
                }
                if (save.split('#')[0] == "2") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    toast('Error', "Coupon Name already Exist !!");
                    $('#txtCouponName').focus();
                }
                if (save.split('#')[0] == "8") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    toast('Error', "Coupon Not Added With Excel Please Upload Again or Enter Coupon Code !!");
                    $('#<%=lbfilename.ClientID%>').text('');
                        $('#fileadded').html('');
                    }
                if (save.split('#')[0] == "13") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    toast('Error', "Coupon Issue Type Not Added With Excel Please Upload Again or Enter Issue For !!");
                    $('#<%=lbtypelabel.ClientID%>').text('');
                        $('#exceladded').html('');
                    }
                if (save.split('#')[0] == "14") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    toast('Error', "Coupon Code With Data is Not Added With Excel Please Upload Again !!");
                    $('#<%=lbtypelabel.ClientID%>').text('');
                        $('#exceladded').html('');
                    }
                if (save.split('#')[0] == "3") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    toast('Error', "Coupon code already Exist in " + save.split('#')[1] + " !!");
                }
                if (save.split('#')[0] == "11") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    toast('Error', save.split('#')[1]);
                }
                if (save.split('#')[0] == "12") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    toast('Error', save.split('#')[1]);
                }

                if (save.split('#')[0] == "0") {
                    $('#btnsave').attr('disabled', false).val("Save");
                    toast('Error', save.split('#')[1]);
                }

            });
           
        }
            function Addrow() {
                if ($('#txtdisper').val() > 100) {
                      toast('Error',"Please enter discount percent less than 100 ");
                      $('#txtdisper').focus();
                      return;
                  }
                  if ((JSON.stringify($('#lstdepartment').val()) == '[]')) {
                      toast('Error',"Please Select department ");
                      $('#lstZone').focus();
                      return;
                  }
                  if ((JSON.stringify($('#lsttest').val()) == '[]')) {
                      toast('Error',"Please Select test ");
                      $('#lstZone').focus();
                      return;
                  }
                  var dname = [], tname = [], tcode = [], itemid = [], did = [];
                  var tests = $('#lsttest').val();
                  var html = '';
                  var ExistItems = new Array();
                  $('[id$=Testtable]').find('tr').each(function (index) {
                      if (index > 0) {
                          ExistItems.push($(this).find('#hdnItemId').val());
                      }
                  });
                  for (i = 0; i < tests.length; i++) {
                      if (ExistItems.indexOf(tests[i].split('#')[0]) == -1) {
                          html += "<tr id=" + (i + 1) + " style='background-color:lemonchiffon;' class='GridViewItemStyle GridCommonTemp'>";
                          html += "<td>" + tests[i].split('#')[2] + "</td>";
                          html += "<td value=" + tests[i].split('#')[0] + ">" + tests[i].split('#')[3] + " <input type='hidden' id='hdnItemId' value='" + tests[i].split('#')[0] + "'></td>";
                          html += "<td value=" + tests[i].split('#')[1] + ">" + tests[i].split('#')[4] + "</td>";
                          html += "<td><input type='text' MaxLength='3' id='txtdiscper' style='width:80px'  onkeyup='showme1(this)' name='t1' /></td>";
                          html += "<td><input type='text' MaxLength='5' id='txtdiscamt' style='width:80px'  onkeyup='showme1(this)' name='t2'  /></td>";
                          html += "<td><img src='../../App_Images/Delete.gif' style='cursor:pointer;' onclick='deletetestr(" + (i + 1) + ")'></td>";
                          html += '</tr>';
                      }
                  }
                  $('#Testtable tbody').append(html);
                  count++;
                  var pagesize = 5;
                  var totalrecord = $('#Testtable tr').length - 1;
                  var totalpage = Math.ceil(totalrecord / pagesize);
                  $('#Tpage').text(totalpage);
                  $(".GridCommonTemp").hide();
                  var currPage = parseInt($("#txt_CurrentPage").val());
                  for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                      $("#Testtable").find("tr").eq(i).show();
                  }
              }
              function deletetestr(v) {
                  $('#' + v).remove();
                 var pagesize = 5;
                  var totalrecord = $('#Testtable tr').length - 1;
                  var totalpage = Math.ceil(totalrecord / pagesize);
                  $('#Tpage').text(totalpage);
                  $(".GridCommonTemp").hide();
                  var currPage = parseInt($("#txt_CurrentPage").val());
                  for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                      $("#Testtable").find("tr").eq(i).show();
                  }
              }
              
              function clearForm() {
                  $('#txtentrydatefrom,#txtentrydateto,#txtminbooking,#txtdisper,#txtdisamt,#txtCouponName,#txtminbooking').val("");
                  jQuery('#lstCentreLoadList').multipleSelect("refresh");
                  jQuery('#lstCentreLoadListinner').multipleSelect("refresh");
                  bindZone();
                  binddepartment();
              }
            function Nextclick() {
                var totalrecord = $('#Testtable tr').length - 1;
                var pagesize = 5;
                var totalpage = Math.ceil(totalrecord / pagesize);
                $('#Tpage').text(totalpage);
                if (parseInt($("#txt_CurrentPage").val()) < totalpage)
                    $("#txt_CurrentPage").val(parseInt($("#txt_CurrentPage").val()) + 1);
                else if (parseInt($("#txt_CurrentPage").val()) == totalpage)
                    $("#txt_CurrentPage").val(totalpage);
                $(".GridCommonTemp").hide();
                var currPage = parseInt($("#txt_CurrentPage").val());
                for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                    $("#Testtable").find("tr").eq(i).show();
                }
            }
            function Prevclick() {
                var totalrecord = $('#Testtable tr').length - 1;
                var pagesize = 5;
                var totalpage = Math.ceil(totalrecord / pagesize);
                $('#Tpage').text(totalpage);
                if (parseInt($("#txt_CurrentPage").val()) > 1)
                    $('#txt_CurrentPage').val(parseInt($('#txt_CurrentPage').val()) - 1);
                else if (parseInt($("#txt_CurrentPage").val()) == 1)
                    $('#txt_CurrentPage').val('1');
                $(".GridCommonTemp").hide();
                var currPage = parseInt($("#txt_CurrentPage").val());
                for (var i = ((currPage - 1) * pagesize) + 1; i <= (currPage * pagesize) ; i++) {
                    $("#Testtable").find("tr").eq(i).show();
                }

            }
    </script>
    <script type="text/javascript">
        $(function () {
            bindcoupontype();
            bindcouponcategory();
            bindtype();
            $('#<%=txtdisamt.ClientID%>').bind('blur', function () {
                if ($('#<%=txtdisper.ClientID%>').val() == "" || $('#<%=txtdisper.ClientID%>').val() != "0") {
                    $('#<%=txtdisper.ClientID%>').val("0");
                }
                if ($('#<%=txtdisamt.ClientID%>').val() == "") {
                    $('#<%=txtdisamt.ClientID%>').val("0");
                }
            });
            $('#<%=txtdisper.ClientID%>').bind('blur', function () {
                if ($('#<%=txtdisamt.ClientID%>').val() == "" || $('#<%=txtdisamt.ClientID%>').val() != "0") {
                    $('#<%=txtdisamt.ClientID%>').val("0");
                }
                if ($('#<%=txtdisper.ClientID%>').val() == "") {
                    $('#<%=txtdisper.ClientID%>').val("0");
                    }
            });
            $('#<%=txtentrydatefrom.ClientID%>').bind('blur', function () {
                var StartDate = $('#<%=txtentrydatefrom.ClientID%>').val();
                var EndDate = $('#<%=txtentrydateto.ClientID%>').val();
                var eDate = new Date(EndDate);
                var sDate = new Date(StartDate);
                if (StartDate != '' && StartDate != '' && sDate > eDate) {
                    toast('Error',"Please ensure that the End Date is greater than or equal to the Start Date.");
                    return false;
                }
            });
            $('#<%=txtentrydateto.ClientID%>').bind('blur', function () {
                var StartDate = $('#<%=txtentrydatefrom.ClientID%>').val();
                var EndDate = $('#<%=txtentrydateto.ClientID%>').val();
                var eDate = new Date(EndDate);
                var sDate = new Date(StartDate);
                if (StartDate != '' && StartDate != '' && sDate > eDate) {
                    toast('Error',"Please ensure that the End Date is greater than or equal to the Start Date.");
                    return false;
                }
            });
            $('#<%=txtdisper.ClientID%>').bind('blur', function () {
                if ($('#<%=txtdisper.ClientID%>').val() > 100) {
                    toast('Error',"Please enter discount percent less than 100 ");
                    $('#<%=txtdisper.ClientID%>').focus();
                        return;
                    }
            });
            $('.form-control').bind('blur', function () {
                $(this).parent().next('li').find('.form_helper_show').removeClass("form_helper_show").addClass('form_helper');
            });
            $('#Tpage').text("1");
            $('#Nextbut').click(function () {
                Nextclick();
            });
            $('#Prevbut').click(function () {
                Prevclick();
            });
            $('#txtdisamt').keyup(function (e) {
                $('#txtdisper').val("0");
            });
            $('#txtdisamt').keydown(function (e) {
                $('#txtdisper').val("0");
            });
            $('#<%=txtdisper%>').keyup(function (e) {
                $('#<%=txtdisamt.ClientID%>').val("0");
            });
            $('#<%=txtdisper%>').keydown(function (e) {
                $('#<%=txtdisamt.ClientID%>').val("0");
            });
        });
        function Bindtabledata() {
            serverCall('coupon_master.aspx/bindtable', {  }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error',"No Coupon Found");
                }
                else {
                    $('#tblcoupon tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        if (ItemData[i].isactive == 'Active') {
                            $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');//#ff6a00
                        }
                        else {
                            $Tr.push('<tr style="background-color:#ff6a00;" class="GridViewItemStyle" id="tblBody">');//#ff6a00
                        }
                        $Tr.push('<td id="serial_number" class="order" >'); $Tr.push( (i + 1)); $Tr.push('</td>');
                        $Tr.push('<td id="coupanname">'); $Tr.push( ItemData[i].coupanname); $Tr.push('</td>');
                        $Tr.push('<td id="coupantype">' ); $Tr.push( ItemData[i].coupantype ); $Tr.push('</td>');
                        $Tr.push('<td id="coupancategory">' ); $Tr.push( ItemData[i].coupancategory); $Tr.push('</td>');
                        $Tr.push('<td id="validfrom">'); $Tr.push( ItemData[i].validfrom); $Tr.push( '</td>');
                        $Tr.push('<td id="validto">' ); $Tr.push( ItemData[i].validto); $Tr.push('</td>');
                        $Tr.push('<td id="minbookingamount">' ); $Tr.push( ItemData[i].minbookingamount); $Tr.push('</td>');
                        if (ItemData[i].issuetype == "ALL") {
                            $Tr.push('<td id="issuefor">'); $Tr.push( ItemData[i].issuetype ); $Tr.push( '</td>');
                        }
                        else if (ItemData[i].issuetype == "UHID" || ItemData[i].issuetype == "Mobile") {
                            $Tr.push('<td id="issuefor">'); $Tr.push( ItemData[i].issuetype); $Tr.push( '&nbsp;&nbsp;<img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="viewtype(' + ItemData[i].coupanid + ')"/></td>');
                        }
                        else {
                            $Tr.push('<td id="issuefor">'); $Tr.push( ItemData[i].issuetype); $Tr.push('&nbsp;&nbsp;<img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="viewtypewithdata(' + ItemData[i].coupanid + ')"/></td>');
                        }
                        $Tr.push('<td id="TYPE" >'); $Tr.push(ItemData[i].TYPE); $Tr.push('</td>');
                        $Tr.push('<td id="discountamount"  >'); $Tr.push(ItemData[i].discountamount); $Tr.push('</td>');
                        $Tr.push('<td id="discountpercentage"  >'); $Tr.push(ItemData[i].discountpercentage); $Tr.push('</td>');
                        $Tr.push('<td id="IsMultipleCouponApply" >'); $Tr.push(ItemData[i].IsMultipleCouponApply); $Tr.push('</td>');
                        $Tr.push('<td id="IsMultiplePatientCoupon" >'); $Tr.push(ItemData[i].MultiplePatientCoupon); $Tr.push('</td>');
                        $Tr.push('<td id="IsOneTimePatientCoupon" >'); $Tr.push(ItemData[i].OneTimePatientCoupon); $Tr.push('</td>');
                        $Tr.push('<td>'); $Tr.push( ItemData[i].WeekEnd); $Tr.push('</td>');
                        $Tr.push('<td>'); $Tr.push(ItemData[i].DaysApplicable); $Tr.push('</td>');
                        $Tr.push('<td id="vcen"><img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="viewcenter('); $Tr.push(ItemData[i].coupanid); $Tr.push(')"/></td>');
                        if (ItemData[i].TYPE != "Total Bill") {
                            $Tr.push('<td id="vtest"><img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="viewtest('); $Tr.push(ItemData[i].coupanid); $Tr.push(')"/></td>');
                        }
                        else {
                            $Tr.push('<td id="vtest"></td>');
                        }
                        $Tr.push('<td id="vtest"><img src="../../App_Images/View.gif" style="cursor:pointer;" onclick="ViewCouponCode('); $Tr.push(ItemData[i].coupanid); $Tr.push(')"/></td>');
                        $Tr.push('<td id="isactive"><b>'); $Tr.push(ItemData[i].isactive); $Tr.push('<b></td>');
                        if (approvaltypestatuschange == "1") {
                            if (ItemData[i].isactive == 'Active') {
                                $Tr.push('<td><input type="button" value="Deactive" class="savebutton" onclick="UpdateStatus('); $Tr.push(ItemData[i].coupanid); $Tr.push(',0)"/></td>');
                            }
                            else {
                                $Tr.push('<td><input type="button" value="Active" class="savebutton" onclick="UpdateStatus('); $Tr.push(ItemData[i].coupanid); $Tr.push(',1)"/></td>');
                            }
                        }
                        else {
                            $Tr.push('<td></td>');
                        }
                        if (ItemData[i].LedgertransactionNo == "" && approvaltypereject == "1" && ItemData[i].Approved == "0") {
                            $Tr.push('<td id="vdel"><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="Deleterow('); $Tr.push(ItemData[i].coupanid); $Tr.push(","); $Tr.push(ItemData[i].coupantypeid); $Tr.push(');" /></td>');
                        }
                        else {
                            $Tr.push('<td id="vdel"></td>');
                        }
                        $Tr.push('<td  id="itemid" style="display:none;">'); $Tr.push(ItemData[i].coupanid); $Tr.push('</td>');
                        $Tr.push('<td id="ctt" style="display:none;">'); $Tr.push(ItemData[i].ctt); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#tblcoupon').append($Tr);
                    }
                }
            });
            
        }
        function Deleterow(itemid, type) {
            var table = document.getElementById('tblcoupon');
            var r = confirm("Are you sure Delete this item !!");
            if (r == true) {
                serverCall('coupon_master.aspx/removerow', { id: itemid,Type:type }, function (response) {
                    var save = response;
                    if (save.split('#')[0] == "1") {
                        Bindtabledata();
                        toast('Sucess', "Delete Coupon Successfully");
                    }
                });
                
            }
        }
    </script>
    <script type="text/javascript">
        function viewtest(couponID) {
            serverCall('coupon_master.aspx/bindtestmodal', { CouponID: couponID}, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error',"No test Found");
                }
                else {
                    $('#viewtest tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="mtest" align="left">'); $Tr.push(ItemData[i].typename); $Tr.push('</td>');
                        $Tr.push('<td  id="mtestdisper">'); $Tr.push(ItemData[i].discper); $Tr.push('</td>');
                        $Tr.push('<td  id="mtestdisamt">'); $Tr.push(ItemData[i].discamount); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#viewtest').append($Tr);
                    }
                    $("#divTest").showModel();
                }

            });
            
        }
        function viewcenter(couponID) {
            serverCall('coupon_master.aspx/bindcentermodal', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error', "No center Found");
                }
                else {
                    $('#viewcenter tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].Centre); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#viewcenter').append($Tr);
                    }

                    $('#divCouponCentre').showModel();
                    $('#<%=lbltotalcountcentre.ClientID%>').text(ItemData.length);
                }
            });
            
        }
        function viewtypewithdata(couponID) {
            serverCall('coupon_master.aspx/bindtypemodalwithdata', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error',"No Data Found");
                }
                else {
                    $('#viewtypewithdata tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].coupancode); $Tr.push('</td>');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].issuetype); $Tr.push('</td>');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].issuevalue); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#viewtypewithdata').append($Tr);
                    }
                    
                    $('#divTypewithData').showModel();
                   
                }
            });
           
        }
        function viewtype(couponID) {
            serverCall('coupon_master.aspx/bindtypemodal', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error',"No Data Found");
                }
                else {
                    $('#viewtype tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].type); $Tr.push('</td>');
                        $Tr.push('<td  id="center">'); $Tr.push(ItemData[i].value); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#viewtype').append($Tr);
                    }

                    $('#divType').showModel();                    
                }

            });
            
        }

        function ViewCouponCode(couponID) {
            serverCall('CouponMasterApproval.aspx/BindCouponCodeModal', { CouponID: couponID }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast('Error',"No center Found");
                }
                else {
                    $('#tblcouponcode tr').slice(1).remove();
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $Tr = [];
                        $Tr.push('<tr style="background-color:lemonchiffon;" class="GridViewItemStyle" id="tblBody">');
                        $Tr.push('<td  id="center" style="text-align:left;">'); $Tr.push(ItemData[i].coupancode); $Tr.push('</td>');
                        $Tr.push('</tr>');
                        $Tr = $Tr.join("");
                        $('#tblcouponcode').append($Tr);
                    }
                    jQuery("#divCoupanCode").showModel();
                 
                    $('#<%=lbltotalcount.ClientID%>').text(ItemData.length);
                    }

            });
            
        }
        $closeCoupon = function () {
            jQuery("#divCoupanCode").hideModel();
            $('#tblcouponcode tr').slice(1).remove();
        }
        $closeCouponCentre = function () {
            $('#divCouponCentre').hideModel();
            $('#viewcenter tr').slice(1).remove();
        }
        $closeTypewithData = function () {
            $('#divTypewithData').hideModel();
            $('#viewtypewithdata tr').slice(1).remove();
        }
        $closeType = function () {
            $('#divType').hideModel();
          
        }
        $closeTest = function () {
            $('#divTest').hideModel();
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divCouponCategory').is(':visible')) {
                    $closeCouponCategory();
                }
                else if (jQuery('#divCoupanCode').is(':visible')) {
                    $closeCoupon();
                }
                else if (jQuery('#divCouponType').is(':visible')) {
                    $closeCouponType();
                }
                else if (jQuery('#divCouponCentre').is(':visible')) {
                    $closeCouponCentre();
                }

                else if (jQuery('#divTypewithData').is(':visible')) {
                    $closeTypewithData();
                }
                else if (jQuery('#divType').is(':visible')) {
                    $closeType();
                }
                else if (jQuery('#divTest').is(':visible')) {
                    $closeTest();
                }
            }
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
    </script>
    <script type="text/javascript">
        function pcategory() {
           
            jQuery("#divCouponCategory").showModel();
        }
        $closeCouponCategory = function () {
            jQuery("#divCouponCategory").hideModel();
            jQuery("#txtpcouponcategory").val('');
        }
        function ptype() {           
            jQuery('#divCouponType').showModel();
        }
        function showuploadbox() {
            var FileName = "";
            if ($('#<%=lblFileName.ClientID%>').text() == "") {
                FileName = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                FileName = $('#<%=lblFileName.ClientID%>').text();
            }
            $('#<%=lblFileName.ClientID%>').text(FileName);
            fancyBoxOpen('../Master/UploadDocument.aspx?FileName=' + FileName);
        }
        function fancyBoxOpen(href) {
            jQuery.fancybox({
                maxWidth: 796,
                maxHeight: 300,
                fitToView: false,
                width: '90%',
                height: '85%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            }
        );
        }
    </script>
    <script type="text/javascript">
        function checkissue() {
            if ($("input[name='issuefor']:checked").val() == "2") {
                $('#txtuhid,#txtmobile').val("");
                $('#molen').html('');
                $('#mytd,#mydiv1,#A12,#txtuhid').show();
                $('#mydiv2,#A11,#A211,#A212,#txtmobile').hide();
            }
            else if ($("input[name='issuefor']:checked").val() == "3") {
                $('#molen').html('');
                $('#txtuhid,#txtmobile').val("");
                $('#mytd,#mydiv1,#A11,#txtmobile').show();
                $('#mydiv2,#A12,#A211,#A212,#txtuhid').hide();
            }
            else if ($("input[name='issuefor']:checked").val() == "4") {
                $('#molen').html('');
                $('#txtuhid,#txtmobile').val("");               
                $('#mytd,#mydiv1,#A11,#A12,#A212,#txtuhid,#txtmobile').hide();
                $('#mydiv2,#A211').show();
            }
            else if ($("input[name='issuefor']:checked").val() == "5") {
                $('#molen').html('');
                $('#txtuhid,#txtmobile').val("");
                $('#mytd,#mydiv1,#A11,#A12,#A211,#txtuhid,#txtmobile').hide();
                $('#mydiv2,#A212').show();
            }
            else {
                $('#molen').html('');
                $('#txtuhid,#txtmobile').val("");
                $('#mytd,#mydiv2,#A11,#A12,#A211,#A212,#txtuhid,#txtmobile').hide();
                $('#mydiv1').show();
            }
        }
function showlength() {
    if ($('#<%=txtmobile.ClientID%>').val() != "") {
        $('#molen').html($('#<%=txtmobile.ClientID%>').val().length);
    }
    else {
        $('#molen').html('');
    }
    if ($.trim($('#<%=txtmobile.ClientID%>').val()) == "123456789") {
        toast('Error',"Please Enter Valid Mobile No.");
        $('#<%=txtmobile.ClientID%>').val('');
        $('#molen').html('');
        return;
    }
    if ($.trim($('#<%=txtmobile.ClientID%>').val()).charAt(0) == "0") {
        toast('Error',"Please Enter Valid Mobile No.");
        $('#<%=txtmobile.ClientID%>').val('');
        $('#molen').html('');
        return;
    }
}



var callblurFunc = false;
var rblSearchType = 0;
$(function () {
    $("#<%= txtmobile.ClientID%>").on('blur', function () {
                if ($("#<%= txtmobile.ClientID%>").val().length == 10 && callblurFunc == false) {
                    searchpatientbymobile();
                }
            });

            $("#<%= txtmobile.ClientID%>").keydown(
               function (e) {
                   var key = (e.keyCode ? e.keyCode : e.charCode);
                   if (key == 13) {
                       e.preventDefault();
                       searchpatientbymobile();
                   }
                   else if (key == 9) {
                       searchpatientbymobile();

                   }
               });


            $("#<%= txtuhid.ClientID%>").on('blur', function () {
                if ($("#<%= txtuhid.ClientID%>").val().length == 10 && callblurFunc == false) {
                     searchpatientbyuhid();
                 }
             });

            $("#<%= txtuhid.ClientID%>").keydown(
               function (e) {
                   var key = (e.keyCode ? e.keyCode : e.charCode);
                   if (key == 13) {
                       e.preventDefault();
                       searchpatientbyuhid();
                   }
                   else if (key == 9) {
                       searchpatientbyuhid();

                   }
               });
        });
        function searchpatientbymobile() {
            serverCall('coupon_master.aspx/BindOldPatient', { searchmobile: $("#<%= txtmobile.ClientID%>").val() }, function (response) {
                OLDPatientData = response;
                if (OLDPatientData == 0) {
                    toast('Error',"Mobile No. is not valid");
                    $("#<%= txtmobile.ClientID%>").val("");
                     }
                     else {
                         toast('Error', "mobile no. is valid");
                     }
            });
            
        }


        function searchpatientbyuhid() {
            serverCall('coupon_master.aspx/BindOldPatientuhid', { searchuhid: $("#<%= txtuhid.ClientID%>").val() }, function (response) {
                OLDPatientData = response;
                if (OLDPatientData == 0) {
                    toast('Error',"UHID No. is not valid");
                    $("#<%= txtuhid.ClientID%>").val("");
                }
                else {
                    toast('Error', "UHID no. is valid");
                }
            });                 
        }
    </script>
    <script type="text/javascript">

        function sortTable(n) {
            var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
            table = document.getElementById("tblcoupon");
            switching = true;
            // Set the sorting direction to ascending:
            dir = "asc";
            /* Make a loop that will continue until
            no switching has been done: */
            while (switching) {
                // Start by saying: no switching is done:
                switching = false;
                rows = table.getElementsByTagName("tr");
                /* Loop through all table rows (except the
                first, which contains table headers): */
                for (i = 1; i < (rows.length - 1) ; i++) {
                    // Start by saying there should be no switching:
                    shouldSwitch = false;
                    /* Get the two elements you want to compare,
                    one from current row and one from the next: */
                    x = rows[i].getElementsByTagName("td")[n];
                    y = rows[i + 1].getElementsByTagName("td")[n];
                    /* Check if the two rows should switch place,
                    based on the direction, asc or desc: */
                    if (dir == "asc") {
                        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                            // If so, mark as a switch and break the loop:
                            shouldSwitch = true;
                            break;
                        }
                    } else if (dir == "desc") {
                        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                            // If so, mark as a switch and break the loop:
                            shouldSwitch = true;
                            break;
                        }
                    }
                }
                if (shouldSwitch) {
                    /* If a switch has been marked, make the switch
                    and mark that a switch has been done: */
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                    // Each time a switch is done, increase this count by 1:
                    switchcount++;
                } else {
                    /* If no switching has been done AND the direction is "asc",
                    set the direction to "desc" and run the while loop again. */
                    if (switchcount == 0 && dir == "asc") {
                        dir = "desc";
                        switching = true;
                    }
                }
            }
        }
    </script>
    <script type="text/javascript">
        function UpdateStatus(itemid, status) {
            serverCall('coupon_master.aspx/UpdateStatus', { id: itemid,status:status }, function (response) {
                var save = response;
                if (save.split('#')[0] == "1") {
                    Bindtabledata();
                    toast('Sucess', " Coupon Active Successfully");
                }
                if (save.split('#')[0] == "0") {
                    Bindtabledata();
                    toast('Sucess', " Coupon DeActive Successfully");
                }
            });
            
        }
    </script>

    <script type="text/javascript">
        $(function () {
            $('#txtcentresearch').keyup(function () {
                var search = $(this).val();
                $('#viewcenter tr:not(:first)').hide();
                var len = $('#viewcenter tr:not(:first) td:nth-child(1):contains("' + search + '")').length;
                if (len > 0) {
                    $('#viewcenter tr:not(.notfound) td:contains("' + search + '")').each(function () {
                        $(this).closest('tr').show();
                    });
                }
            });
            $('#txtcouponsearch').keyup(function () {
                var search = $(this).val();
                $('#tblcouponcode tr:not(:first)').hide();
                var len = $('#tblcouponcode tr:not(:first) td:nth-child(1):contains("' + search + '")').length;
                if (len > 0) {
                    $('#tblcouponcode tr:not(.notfound) td:contains("' + search + '")').each(function () {
                        $(this).closest('tr').show();
                    });
                }
            });
        });
        // Case-insensitive searching (Note - remove the below script for Case sensitive search )
        $.expr[":"].contains = $.expr.createPseudo(function (arg) {
            return function (elem) {
                return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
            };
        });
    </script>
    <script type="text/javascript">
        document.querySelector('#btnuploadfile').onclick = function () {
            var filename = "";
            if ($('#<%=lbfilename.ClientID%>').text() == "") {
                filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                filename = $('#<%=lbfilename.ClientID%>').text();
            }
            $('#<%=lbfilename.ClientID%>').text(filename);
            var popup = window.open('../Coupon/UploadCoupon.aspx?Filename=' + filename, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');

            popup.onbeforeunload = function () {
                $('#fileadded').html("Coupon Added");
            }
        };
        document.querySelector('#btnuploadexcel').onclick = function () {
            var filename = "";
            if ($('#<%=lbtypelabel.ClientID%>').text() == "") {
                filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                filename = $('#<%=lbtypelabel.ClientID%>').text();
            }
            $('#<%=lbtypelabel.ClientID%>').text(filename);
            var issuetype = "";
            if ($("input[name='issuefor']:checked").val() == "1")
                issuetype = "ALL";
            else if ($("input[name='issuefor']:checked").val() == "2")
                issuetype = "UHID";
            else
                issuetype = "Mobile";
            var popup = window.open('../Master/UploadCouponType.aspx?Filename=' + filename + '&issuetype=' + issuetype, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            popup.onbeforeunload = function () {
                $('#exceladded').html("Type Added");
            }
        };
        document.querySelector('#bntuploadexceltwo').onclick = function () {
            var filename = "";
            if ($('#<%=lblcowith.ClientID%>').text() == "") {
                filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                filename = $('#<%=lblcowith.ClientID%>').text();
            }
            $('#<%=lblcowith.ClientID%>').text(filename);
            var issuetype = "";
            if ($("input[name='issuefor']:checked").val() == "4")
                issuetype = "UHID";
            else if ($("input[name='issuefor']:checked").val() == "5")
                issuetype = "Mobile";
            var popup = window.open('../Master/UploadCouponTypeOne.aspx?Filename=' + filename + '&issuetype=' + issuetype, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            popup.onbeforeunload = function () {
                $('#exceladded1').html("Coupon Added");

            }
        };
        function checkfile() {
            serverCall('coupon_master.aspx/checkfilesaved', { filename: $('#<%=lbfilename.ClientID%>').text() }, function (response) {
                if (response != "0") {
                }
                else {
                    $('#fileadded').html('');
                }
            });
           
        }
        function selMultiplePatient() {
            if ($("#chkMultiplePatient").is(':checked')) {
                $("#chkOneTimePatient,#chkmulticoupon,#chkWeekEnd,#chkHappyHours,#chkOneTimePatient,#chkOneCouponOneMobile").prop('checked', false);
                $("input[name='issuefor']").attr('disabled', 'disabled');
                $('input[name="issuefor"][value=1]').prop('checked', true);
                checkissue();
            }
            else {
                $("#chkOneTimePatient,#chkmulticoupon,input[name='issuefor']").removeAttr('disabled');
            }
            uncheckDays();
            $(".tdWeekEndHappyHours").hide();
        }
        function selOneTimePatient() {
            if ($("#chkOneTimePatient").is(':checked')) {
                $("#chkMultiplePatient,#chkmulticoupon,#chkWeekEnd,#chkHappyHours,#chkOneTimePatient,#chkOneCouponOneMobile").prop('checked', false);
                $("input[name='issuefor']").attr('disabled', 'disabled');
                $('input[name="issuefor"][value=1]').prop('checked', true);
                checkissue();
            }
            else {
                $("#chkMultiplePatient,#chkmulticoupon,input[name='issuefor']").removeAttr('disabled');
            }
            uncheckDays();
            $(".tdWeekEndHappyHours").hide();
        }
        function selMultipleCoupon() {
            if ($("#chkmulticoupon").is(':checked')) {
                $("#chkMultiplePatient,#chkOneTimePatient,#chkWeekEnd,#chkHappyHours,#chkOneTimePatient,#chkOneCouponOneMobile").prop('checked', false);

                $("input[name='issuefor']").removeAttr('disabled');
                $('input[name="issuefor"][value=1]').prop('checked', true);
                checkissue();
            }
            else {
                $("#chkMultiplePatient,#chkOneTimePatient,input[name='issuefor']").removeAttr('disabled');
            }
            uncheckDays();
            $(".tdWeekEndHappyHours").hide();
        }
        setWeekEnd = function () {
            if ($("#chkWeekEnd").is(':checked')) {
                $("#chkMultiplePatient,#chkOneTimePatient,#chkmulticoupon,#chkHappyHours,#chkOneCouponOneMobile").prop('checked', false);
                $(".tdWeekEndHappyHours").hide();
                $("input[name='issuefor']").attr('disabled', 'disabled');
                $('input[name="issuefor"][value=1]').prop('checked', true);
                checkissue();
            }
            else {
                $(".tdWeekEndHappyHours").hide();
                $("#chkMultiplePatient,#chkOneTimePatient,input[name='issuefor']").removeAttr('disabled');
            }
            uncheckDays();
        }
        setHappyHours = function () {
            if ($("#chkHappyHours").is(':checked')) {
                $("#chkMultiplePatient,#chkOneTimePatient,#chkmulticoupon,#chkWeekEnd,#chkOneCouponOneMobile").prop('checked', false);
                $(".tdWeekEndHappyHours").show();
                $("input[name='issuefor']").attr('disabled', 'disabled');
                $('input[name="issuefor"][value=1]').prop('checked', true);
                checkissue();
            }
            else {
                $(".tdWeekEndHappyHours").hide();
                $("#chkMultiplePatient,#chkOneTimePatient,input[name='issuefor']").removeAttr('disabled');
            }
            uncheckDays();
        }
        uncheckDays = function () {
            $("#chklDaysApplicable input[type=checkbox]").prop('checked', false);
            $('input[name="issuefor"]').removeAttr('disabled');
        }
        setOneCouponOneMobile = function () {
            if ($("#chkOneCouponOneMobile").is(':checked')) {
                $("#chkmulticoupon,#chkMultiplePatient,#chkOneTimePatient,#chkWeekEnd,#chkHappyHours").prop('checked', false);
                $("#chklDaysApplicable input[type=checkbox]").prop('checked', false);
                $('input[name="issuefor"][value=6]').prop('checked', true);
                $('input[name="issuefor"]').attr('disabled', 'disabled');
            }
            else {
                $('input[name="issuefor"]').removeAttr('disabled');
            }
            $(".tdWeekEndHappyHours").hide();
        }
        setOneTimePatient = function () {
            if ($("#chkOneTimePatient").is(':checked')) {
                $("#chkmulticoupon,#chkMultiplePatient,#chkOneCouponOneMobile,#chkWeekEnd,#chkHappyHours").prop('checked', false);
                $("#chklDaysApplicable input[type=checkbox]").prop('checked', false);

            }
            $('input[name="issuefor"]').removeAttr('disabled');
            $(".tdWeekEndHappyHours").hide();
        }
        setMultiCoupon = function () {
            if ($("#chkmulticoupon").is(':checked')) {
                $("#chkOneCouponOneMobile,#chkWeekEnd,#chkHappyHours").prop('checked', false);
                $("#chklDaysApplicable input[type=checkbox]").prop('checked', false);
            }
            $('input[name="issuefor"]').removeAttr('disabled');
            $(".tdWeekEndHappyHours").hide();
        }
    </script>
</asp:Content>

