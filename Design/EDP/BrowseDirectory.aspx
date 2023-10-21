<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BrowseDirectory.aspx.cs" Inherits="BrowseDirectory" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <base target="_self"></base>
		<title >Borwse Directory</title>
    	<style>
		    .errorMsg{FONT-SIZE: 8.25pt; COLOR: red; FONT-FAMILY: Verdana, Arial; TEXT-DECORATION: none }
			.hilite { BACKGROUND-COLOR: #dfe5ff }
			.nohilite { BACKGROUND-COLOR: #ffffff }
			.text { FONT-SIZE: 8.25pt; COLOR: black; FONT-FAMILY: Verdana, Arial; TEXT-DECORATION: none }
			.tableOutlineWt { BORDER-RIGHT: #cccccc 1px solid; BORDER-TOP: #666666 1px solid; MARGIN-TOP: 0px; OVERFLOW: auto; BORDER-LEFT: #333333 1px solid; PADDING-TOP: 0px; BORDER-BOTTOM: #cccccc 1px solid }
		</style>
</head>
<body>
    <form id="form1" runat="server">
    <script language=javascript>
    <!--
    function SelectAndClose()
		{
		    txtValue = document.getElementById('_browseTextBox');
		    
		    
		      var serverLoc='<%=Server.MapPath("~/Design").Replace(@"\",@"\\") %>';
      //       alert(serverLoc);
         serverLoc="/Design"+txtValue.value.replace(serverLoc,"");
         
		    window.returnValue = serverLoc.replace(/\\\\/g,'/');
		    window.close();
		    return true;
		}
		
		
    -->
    </script>
        <div>
            <table width="100%" border="0">
                <tr>
                    <td>
                        <span class="text"><b>Browse directories:</b></span></td>
                </tr>

               <tr>
                    <td><asp:Label ID="error" runat="server" CssClass="errorMsg" ></asp:Label>
                       </td>
                </tr>
                <tr style="display:none;">
                    <td>
                        <asp:TextBox ID="_browseTextBox" runat="server" CssClass="toolbar" Width="300px" />
                        <asp:ImageButton ID="_browseButton" ImageUrl="Images/Go.gif" runat="server" OnClick="_browseButton_Click" style="display:none;" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="tableOutlineWt" style="width: 313px; height: 371px; background-color: white">
                            <table cellspacing="0" cellpadding="4" width="100%" bgcolor="#ffffff" border="0">
                                <tr>
                                    <td>
                                        
                                            <asp:TreeView ID="TreeView1" runat="server" Height="349px" ImageSet="XPFileExplorer"
                                                NodeIndent="15" Width="300px" style="overflow:auto;">
                                                <ParentNodeStyle Font-Bold="False" />
                                                <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                                                <SelectedNodeStyle BackColor="#B5B5B5" Font-Underline="False" HorizontalPadding="0px"
                                                    VerticalPadding="0px" />
                                                <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black" HorizontalPadding="2px"
                                                    NodeSpacing="0px" VerticalPadding="2px" />
                                                <LeafNodeStyle ImageUrl="~/Design/Purchase/Image/aspx_file.gif" />
                                            </asp:TreeView>
                                       
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                 <tr>
                    <td align=left>
                        
                     
                        <asp:ImageButton ID="_selectButton" ImageUrl="~/Design/Purchase/Image/Hide.gif" OnClientClick="SelectAndClose();"
                            runat="server" />
                    </td>
                </tr>
            </table>
          
        </div>
    </form>
</body>
</html>
