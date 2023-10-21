<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CategoryTAT.aspx.cs" Inherits="Design_Support_CategoryTAT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Category TAT</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Add New Category TAT
            </div>
            <div class="row">
                <div class="col-md-10">
                </div>
                <div class="col-md-14">
                    <span id="CatName">
                        <b>Categoty Name :</b>  <%=CategoryName%>
                    </span>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    </div>
                <div class="col-md-3 GridViewHeaderStyle">
                    Name
                    </div>
                <div class="col-md-3 GridViewHeaderStyle">
                    Level-1
                    </div>               
                <div class="col-md-3 GridViewHeaderStyle">
                    Level-2
                    </div>                 
                <div class="col-md-3 GridViewHeaderStyle">
                    Level-3
                    </div>                
                </div>
            <div class="row">
                <div class="col-md-6">
                    </div>
                 <div class="col-md-3">
                     <label class="pull-left">Resolve TAT   </label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-3">
                    <div> <input type="text" id="txtResLevel1" onkeypress="return isNumber(event)" style="width:100px" />&nbsp;Min</div>
                    </div>
               
                 <div class="col-md-3">
                    <div> <input type="text" id="txtResLevel2" onkeypress="return isNumber(event)" style="width:100px"/>&nbsp;Min</div>
                    </div>
                 
                 <div class="col-md-3">
                     <div><input type="text" id="txtResLevel3" onkeypress="return isNumber(event)" style="width:100px"/>&nbsp;Min</div>
                    </div>
                
                </div>
             <div class="row" style="display: none">
                <div class="col-md-6">
                    </div>
                 <div class="col-md-3">
                      <label class="pull-left">Response TAT   </label>
                    <b class="pull-right">:</b>
                     </div>
                  <div class="col-md-3">
                      <input type="text" id="txtRespLevel1" onkeypress="return isNumber(event)" />Min
                      </div>
                  <div class="col-md-3">
                      <input type="text" id="txtRespLevel2" onkeypress="return isNumber(event)" />Min
                      </div>
                  <div class="col-md-3">
                      <input type="text" id="txtRespLevel3" onkeypress="return isNumber(event)" />Min
                      </div>
                 </div>              
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                    <button id="btnSubmit" type="button"  value="Submit" onclick="InsertedTAT()">Submit</button>&nbsp;                                              
            </div>
        </div>
        <script type="text/javascript">
            var CatValue = "";
            $(function () {
                CatValue = '<%=CatID%>';
                GetTATValues('<%=CatID%>')

            });
            function InsertedTAT() {
                if (CatValue == "") {
                    toast("Error", "Please refresh page");
                    return false;
                }

                var Level1Rs = $("#txtResLevel1").val() == '' ? '0' : $("#txtResLevel1").val();
                var Level2Rs = $("#txtResLevel2").val() == '' ? '0' : $("#txtResLevel2").val();
                var Level3Rs = $("#txtResLevel3").val() == '' ? '0' : $("#txtResLevel3").val();

                var Level1Rp = $("#txtRespLevel1").val() == '' ? '0' : $("#txtRespLevel1").val();
                var Level2Rp = $("#txtRespLevel2").val() == '' ? '0' : $("#txtRespLevel2").val();
                var Level3Rp = $("#txtRespLevel3").val() == '' ? '0' : $("#txtRespLevel3").val();
                serverCall('CategoryTAT.aspx/UpdateCategoryTAT', { Id: CatValue, Level1: Level1Rs, Level2: Level2Rs, Level3: Level3Rs, Level1rp: Level1Rp, Level2rp: Level2Rp, Level3rp: Level3Rp }, function (response) {

                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        toast("Success", $responseData.response);
                        GetTATDetail(jQuery.parseJSON($responseData.responseDetail))
                    }
                    else {
                        toast("Error", $responseData.response);
                    }
                });


            }

            function isNumber(evt) {
                evt = (evt) ? evt : window.event;
                var charCode = (evt.which) ? evt.which : evt.keyCode;
                if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
                return true;
            }
            function GetTATDetail(CategaryID) {
                $("#txtResLevel1").val(CategaryID[0]["Level1Resolve"]);
                $("#txtResLevel2").val(CategaryID[0]["Level2Resolve"]);
                $("#txtResLevel3").val(CategaryID[0]["Level3Resolve"]);
                $("#txtRespLevel1").val(CategaryID[0]["Level1Resp"]);
                $("#txtRespLevel2").val(CategaryID[0]["Level2Resp"]);
                $("#txtRespLevel3").val(CategaryID[0]["Level3Resp"]);

            }
            function GetTATValues(CategaryID) {
                serverCall('CategoryTAT.aspx/GetCategoryTAT', { Id: CategaryID }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        GetTATDetail(jQuery.parseJSON($responseData.responseDetail));
                    }
                    else {
                        $("#txtResLevel1,#txtResLevel2,#txtResLevel3,#txtRespLevel1,#txtRespLevel2,#txtRespLevel3").val(0);
                    }

                });

            }
        </script>
</asp:Content>

