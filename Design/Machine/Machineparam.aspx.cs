using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI.HtmlControls;
//using System.Web.UI.HtmlControls.HtmlGenericControl;

public partial class Design_Machine_Machineparam : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            machine();
            adddropdown();
        }
    }

    private void machine()
    {
   
        string str = "SELECT MachineID FROM " + AllGlobalFunction.MachineDB + ".mac_machinemaster";
        DataTable dt = StockReports.GetDataTable(str);
        ddlmachine.DataSource = dt;
        ddlmachine.DataBind();
    }

    public void adddropdown()
    {
        //string str = "SELECT Name,LabObservation_ID FROM machost_apollo.Test_Master ";
 string str = "SELECT   Concat(NAME,'_',LabObservation_ID) Name,LabObservation_ID  FROM " + AllGlobalFunction.MachineDB + ".Test_Master";
              
 DataTable dt = StockReports.GetDataTable(str);
        int i = 0;
        if (dt.Rows.Count > 0)
        {
                
                DropDownList2.DataSource = dt;
              
                DropDownList2.DataTextField = "Name";
                DropDownList2.DataValueField = "LabObservation_ID";
               DropDownList2.DataBind();
               DropDownList2.Items.Insert(0, new ListItem("--Select Test--", "--Select Test--"));
             
               
        }
    }
    
    protected void ddlmachine_RowCommand(object sender, GridViewCommandEventArgs e)
    {
       
        string MachineId = e.CommandArgument.ToString();
       // Response.Write(MachineId);
        //Response.End();
        HiddenField1.Value = MachineId;
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT MPM.`MACHINEID`,MPM.`Machine_ParamID`,MPM.`Machine_Param`,MPM.`AssayNo`,MPM.`RoundUpTo`,IF(MPM.`IsOrderable`=1,'TRUE','FALSE') AS IsOrderable,mpm.`Decimalcalc`,  ");
        sb.Append("  (SELECT GROUP_CONCAT(lom.LabObservation_id,'=>',lom.name SEPARATOR ', ' ) FROM " + AllGlobalFunction.MachineDB + ".Test_Master lom INNER JOIN " + AllGlobalFunction.MachineDB + ".`mac_param_master` pm   ");
        sb.Append("  ON pm.`LabObservation_id`=lom.`LabObservation_id` WHERE pm.`Machine_ParamID`=mpm.`Machine_ParamID`   ");
        sb.Append("  GROUP BY pm.`Machine_ParamID`)  Test FROM " + AllGlobalFunction.MachineDB + ".`mac_machineparam` mpm WHERE mpm.`MACHINEID`='" + MachineId + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
       // Response.Write(dt.Rows.Count);
       // Response.End();
        //if (dt.Rows.Count > 0)
        //{
            GridView1.DataSource = dt.DefaultView;
            GridView1.DataBind();
        //}
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getMachineinfo()
    {
       // string str = "SELECT MachineID FROM " + AllGlobalFunction.MachineDB + ".mac_machinemaster";
        string str = "SELECT Name,LabObservation_ID FROM " + AllGlobalFunction.MachineDB + ".Test_Master";
        DataTable dt = StockReports.GetDataTable(str);
        //ddlmachine.DataSource = dt;
       // ddlmachine.DataBind();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateInfo(string txt1,string txt2)
    {
        
        string str = "UPDATE "+ AllGlobalFunction.MachineDB +" mac_param_master SET `LabObservation_id`='" + txt2 + "' WHERE `Machine_ParamID`='" + txt1 + "'";
        //return Newtonsoft.Json.JsonConvert.SerializeObject(str);
      
        bool outss = StockReports.ExecuteDML(str.ToString());
       // string reslt = StockReports.ExecuteScalar(str.ToString());
       return Newtonsoft.Json.JsonConvert.SerializeObject(outss.ToString());
        //if (outss == true)
        //{
        //    return Newtonsoft.Json.JsonConvert.SerializeObject("1");
        //}
        //else
        //{
        //    return Newtonsoft.Json.JsonConvert.SerializeObject("0");
        //}
       
    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        
        //int rowIndex = Convert.ToInt32(e.CommandArgument);
 
       // GridViewRow row = GridView1.Rows[rowIndex];
       // string name = (row.FindControl("Label1") as Label).ToString();
        //Response.Write(name.ToString());
        //Response.End();
        string MachineId = e.CommandArgument.ToString();
        paramId.Value = MachineId;
        string str = "SELECT LabObservation_ID,NAME FROM " + AllGlobalFunction.MachineDB + ".Test_Master WHERE LabObservation_ID IN(SELECT LabObservation_id FROM " + AllGlobalFunction.MachineDB + ".`mac_param_master` WHERE Machine_ParamID='" + MachineId + "')";
        DataTable dt = StockReports.GetDataTable(str);
        
        GridView2.DataSource = dt;
        GridView2.DataBind();
       // HiddenField1.Value = " ";
        //Response.Write(MachineId);
    }
    public void getTestGrid(string macid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT MPM.`MACHINEID`,MPM.`Machine_ParamID`,MPM.`Machine_Param`,MPM.`AssayNo`,MPM.`RoundUpTo`,IF(MPM.`IsOrderable`=1,'TRUE','FALSE') AS IsOrderable,mpm.`Decimalcalc`,  ");
        sb.Append("  (SELECT GROUP_CONCAT(lom.LabObservation_id,'=>',lom.name SEPARATOR ', ' ) FROM " + AllGlobalFunction.MachineDB + ".Test_Master lom INNER JOIN " + AllGlobalFunction.MachineDB + ".`mac_param_master` pm   ");
        sb.Append("  ON pm.`LabObservation_id`=lom.`LabObservation_id` WHERE pm.`Machine_ParamID`=mpm.`Machine_ParamID`   ");
        sb.Append("  GROUP BY pm.`Machine_ParamID`)  Test FROM " + AllGlobalFunction.MachineDB + ".`mac_machineparam` mpm WHERE mpm.`MACHINEID`='" + macid + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        // Response.Write(dt.Rows.Count);
        // Response.End();
        //if (dt.Rows.Count > 0)
        //{
        GridView1.DataSource = dt.DefaultView;
        GridView1.DataBind();
    }

    public void getTestName(string id)
    {
        string str = "SELECT LabObservation_ID,NAME FROM " + AllGlobalFunction.MachineDB + ".Test_Master WHERE LabObservation_ID IN(SELECT LabObservation_id FROM " + AllGlobalFunction.MachineDB + ".`mac_param_master` WHERE Machine_ParamID='" + id + "')";
        DataTable dt = StockReports.GetDataTable(str);

        GridView2.DataSource = dt;
        GridView2.DataBind();
    }

    protected void Button3_ServerClick(object sender, EventArgs e)
    {
        if (paramId.Value != "")
        {
            string str = "INSERT INTO " + AllGlobalFunction.MachineDB + ".`mac_param_master` (Machine_ParamID,LabObservation_id) VALUES('" + paramId.Value + "','" + DropDownList2.SelectedValue + "')";

            bool outss = StockReports.ExecuteDML(str);
            // Response.Write(str + " " + outss);
            //Response.End();
            if (outss)
            {
                getTestGrid(HiddenField1.Value);
                getTestName(paramId.Value);
            }
            else
            {

            }
        }
        else {
            ScriptManager.RegisterStartupScript(this,GetType(),"","alert('Please Select the Machine_ParamID');",true);
        }
    }
    protected void GridView2_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "Jscript2", "alert('Are you sure you want to delete this record!');", true);
        string TestId = e.CommandArgument.ToString();
       // paramId.Value = MachineId;
        //rmvtest.Value = TestId;
        //HiddenField1.Value = TestId;
        string str = "DELETE FROM " + AllGlobalFunction.MachineDB + ".`mac_param_master` WHERE Machine_ParamID='" + paramId.Value + "' AND LabObservation_id='" + TestId + "'";

        bool outss = StockReports.ExecuteDML(str);
        
        if (outss)
        {
         
            getTestGrid(HiddenField1.Value);
            getTestName(paramId.Value);
        }
        else
        {

        }

    }

    protected void Unnamed_ServerClick(object sender, EventArgs e)
    {
        //Response.Write(HiddenField2.Value);
        //Response.End();
        if (HiddenField2.Value == "Save")
        {
            if (f_param_id.Value != "" && f_macid.Value != "")
            {
                string ordervlu = "0";
                if (f_Order.Checked)
                { ordervlu = "1"; }
                else
                {
                    ordervlu = "0";
                }
                string str = "INSERT INTO " + AllGlobalFunction.MachineDB + ". `mac_machineparam` (Machine_ParamID,MACHINEID,Machine_Param,Suffix,AssayNo,RoundUpTo,IsOrderable,MinLength,Decimalcalc) VALUES ('" + f_param_id.Value + "','" + f_macid.Value + "','" + f_alias.Value + "','" + f_suffix.Value + "','" + f_assay.Value + "','" + f_round.Value + "','" + ordervlu + "','" + f_minlen.Value + "','" + f_multip.Value + "')";
                bool outss = StockReports.ExecuteDML(str);
                //Response.Write(str + " " + outss);
                // Response.End();
                if (outss)
                {
                    getTestGrid(HiddenField1.Value);
                    getTestName(paramId.Value);
                }
                else
                {

                }
            }
            else
            {

                
                //ScriptManager.RegisterStartupScript(this, GetType(), "", "alert('All fields are required');", true);
            }
        }
        else
        {
            string ordervlu = "0";
            if (f_Order.Checked)
            { ordervlu = "1"; }
            else
            {
                ordervlu = "0";
            }
            string str = "UPDATE " + AllGlobalFunction.MachineDB + ". `mac_machineparam` SET Machine_Param='" + f_alias.Value + "',Suffix='" + f_suffix.Value + "',AssayNo='" + f_alias.Value + "',RoundUpTo='" + f_round.Value + "',IsOrderable='" + ordervlu + "',MinLength='" + f_minlen.Value + "',Decimalcalc='" + f_multip.Value + "' WHERE Machine_ParamID='" + f_param_id.Value + "' and MACHINEID='" + f_macid.Value + "' ";
            bool outss = StockReports.ExecuteDML(str);
            //Response.Write(str + " " + outss);
            // Response.End();
            if (outss)
            {
                getTestGrid(HiddenField1.Value);
                getTestName(paramId.Value);
            }
        }


    }
    protected void btn_addMachin_ServerClick(object sender, EventArgs e)
    {
        Response.Redirect("MachineMaster.aspx");
    }
}