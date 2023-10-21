<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DeltaCheck.aspx.cs" Inherits="Design_Mobile_DeltaCheck" %>
<%@ Import Namespace="System.Data" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="show" runat="server">
      <table class="table datalatable">
                                             <thead>
                                                <tr>
                                                    <th class="col-lg-5 col-md-5 col-sm-5 col-xs-5">Booking Date</th>
                                                    <th class="col-lg-3 col-md-3 col-sm-3 col-xs-3">Value</th>
                                                    <th class="col-lg-2 col-md-2 col-sm-2 col-xs-2">Min</th>
                                                    <th class="col-lg-2 col-md-2 col-sm-2 col-xs-2">Max</th>

                                                </tr>
                                              </thead>
                                            <tbody>
                                                <% if(dt.Rows.Count>0) { %>
                                                <% foreach (DataRow dr in dt.Rows) { %>
      
                                               <tr>
                                                    <td colspan="4" style="padding:0;" >
                                                     <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 delta-row" style="<% if(getTags_Flag(dr["Value"].ToString(),dr["MinValue"].ToString(),dr["MaxValue"].ToString(),"")!="")
                                                        { 
                                                            %>
                                                               background-color:#FB6B5B;
                                                                <%

                                                        }else{%>
                                                             background-color:white;
                                                            <%} %>
                                                            ">

                                                           <div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 delta-bokingdate"><%=dr["BookingDate"].ToString() %></div>
                                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 delta-value"><%=dr["Value"].ToString() %></div>
                                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 delta-min"><%=dr["MinValue"].ToString() %></div>
                                                    <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 delta-max"><%=dr["MaxValue"].ToString() %></div>
                                                     </div>
                                                        
                                                         
                                                    </td>
                                               </tr>
                                                <%}%>
                                                <%} else{%>
                                                 <tr>
                                                    <td colspan="4" style="padding:0;" >
                                                 <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 delta-norecord">
                                                     Record Not Found !
                                                 </div>
                                                        </td>
                                                     </tr>
                                                <%} %>
                                           </tbody>
                                        </table>
    </form>
</body>
</html>
