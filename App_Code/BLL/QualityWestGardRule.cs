using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for QualityWestGardRule
/// </summary>
public class QualityWestGardRule
{
	public QualityWestGardRule()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static string ApplyWestGardRule(string reading, string BaseMeanvalue, string BaseSDvalue, string BaseCVPercentage,DataTable dtoldvalue,string centreid,string machineid,string LabObservation_ID,string levelid,string controlid,MySqlConnection con)
    {
        StringBuilder sb=new StringBuilder();
        sb.Append(" SELECT rulename,ruleaction,checklevel FROM ( ");
        sb.Append(" SELECT rulename,ruleaction,checklevel FROM `qc_westgradruleapplicable` WHERE isactive=1 AND isdefault=0 AND");
        sb.Append(" centreid=" +centreid + " AND machineid='" +machineid + "' ");
        sb.Append(" AND `LabObservation_ID`=" + LabObservation_ID + " and  ruleaction<>'Off'");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT rulename,ruleaction,checklevel FROM `qc_westgradruleapplicable` WHERE isdefault=1 AND isactive=1 and  ruleaction<>'Off' ) t GROUP BY rulename");
        DataTable dtruledata = MySqlHelper.ExecuteDataset(con, CommandType.Text,sb.ToString()).Tables[0];

        if(dtruledata.Rows.Count==0)
        {
            return  "Pass##0";
        }

        string statusandrule = "Pass##0";
        float value = Util.GetFloat(reading);
        float basemean = Util.GetFloat(BaseMeanvalue);

       

        float sdplus1 = basemean + Util.GetFloat(BaseSDvalue);
        float sdminus1 = basemean - Util.GetFloat(BaseSDvalue);


        float sdplus2 = basemean + (Util.GetFloat(BaseSDvalue) * 2);
        float sdminus2 = basemean - (Util.GetFloat(BaseSDvalue) * 2);

        float sdplus3 = basemean + (Util.GetFloat(BaseSDvalue) * 3);
        float sdminus3 = basemean - (Util.GetFloat(BaseSDvalue) * 3);

        // Rule 1

        if (dtruledata.Select("rulename='1-2s'").Length == 1)
        {
            if ((value >= sdplus2 && value <= sdplus3) || (value <= sdminus2 && value >= sdminus3))
            {
                if (dtruledata.Select("rulename='1-2s'")[0]["checklevel"].ToString() == "1" && levelid=="1")
                {
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM `qc_control_centre_mapping` WHERE centreid=" + centreid + " AND machineid='" + machineid + "' AND `LabObservation_ID`=" + LabObservation_ID + " AND levelid=2 and controlid='" + controlid + "'")) > 0)
                    {
                        statusandrule = "Warn#1-2s#0";
                    }
                    else
                    {
                        if (dtruledata.Select("rulename='1-2s'")[0]["ruleaction"].ToString() == "Fail")
                        {
                            statusandrule = "Fail#1-2s#1";
                        }
                        else
                        {
                            statusandrule = "Warn#1-2s#0";
                        }
                    }
                }
                else
                {
                    if (dtruledata.Select("rulename='1-2s'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#1-2s#1";
                    }
                    else
                    {
                        statusandrule = "Warn#1-2s#0";
                    }
                }
            }
        }

        // Rule 2

        if (dtruledata.Select("rulename='1-3s'").Length == 1)
        {
            if (value >= sdplus3 || value <= sdminus3)
            {
                if (dtruledata.Select("rulename='1-3s'")[0]["ruleaction"].ToString() == "Fail")
                {
                    statusandrule = "Fail#1-3s#1";
                }
                else
                {
                    statusandrule = "Warn#1-3s#0";
                }
            }
        }

      
        if (dtoldvalue.Rows.Count > 0)
        {
            float lastvalue = Util.GetFloat(dtoldvalue.Rows[0]["reading"]);
            // Rule 3

            if (dtruledata.Select("rulename='2-2s'").Length == 1)
            {
                if (value >= sdplus2 && lastvalue >= sdplus2)
                {
                    if (dtruledata.Select("rulename='2-2s'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#2-2s#1";
                    }
                    else
                    {
                        statusandrule = "Warn#2-2s#0";
                    }


                }
                if (value <= sdminus2 && lastvalue <= sdminus2)
                {
                    if (dtruledata.Select("rulename='2-2s'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#2-2s#1";
                    }
                    else
                    {
                        statusandrule = "Warn#2-2s#0";
                    }

                }
            }
            // Rule 4

            if (dtruledata.Select("rulename='R-4s'").Length == 1)
            {
                if (value >= sdplus2 && lastvalue <= sdminus2)
                {
                    if (dtruledata.Select("rulename='R-4s'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#R-4s#1";
                    }
                    else
                    {
                        statusandrule = "Warn#R-4s#0";
                    }
                }

                if (value <= sdminus2 && lastvalue >= sdplus2)
                {
                    if (dtruledata.Select("rulename='R-4s'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#R-4s#1";
                    }
                    else
                    {
                        statusandrule = "Warn#R-4s#0";
                    }
                }
            }
            
        }


        //Rule 5

        if (dtruledata.Select("rulename='8-x'").Length == 1)
        {
            if (dtoldvalue.Rows.Count >= 7)
            {
                float lastvalue1 = Util.GetFloat(dtoldvalue.Rows[0]["reading"]);
                float lastvalue2 = Util.GetFloat(dtoldvalue.Rows[1]["reading"]);
                float lastvalue3 = Util.GetFloat(dtoldvalue.Rows[2]["reading"]);
                float lastvalue4 = Util.GetFloat(dtoldvalue.Rows[3]["reading"]);
                float lastvalue5 = Util.GetFloat(dtoldvalue.Rows[4]["reading"]);
                float lastvalue6 = Util.GetFloat(dtoldvalue.Rows[5]["reading"]);
                float lastvalue7 = Util.GetFloat(dtoldvalue.Rows[6]["reading"]);

                if (value >= basemean && lastvalue1 >= basemean && lastvalue2 >= basemean && lastvalue3 >= basemean && lastvalue4 >= basemean && lastvalue5 >= basemean && lastvalue6 >= basemean && lastvalue7 >= basemean)
                {
                    if (dtruledata.Select("rulename='8-x'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#8-x#1";
                    }
                    else
                    {
                        statusandrule = "Warn#8-x#0";
                    }
                   
                }

                if (value <= basemean && lastvalue1 <= basemean && lastvalue2 <= basemean && lastvalue3 <= basemean && lastvalue4 <= basemean && lastvalue5 <= basemean && lastvalue6 <= basemean && lastvalue7 <= basemean)
                {
                    if (dtruledata.Select("rulename='8-x'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#8-x#1";
                    }
                    else
                    {
                        statusandrule = "Warn#8-x#0";
                    }
                }

            }
        }

        //Rule 6

        if (dtruledata.Select("rulename='10-x'").Length == 1)
        {
            if (dtoldvalue.Rows.Count == 10)
            {
                float lastvalue1 = Util.GetFloat(dtoldvalue.Rows[0]["reading"]);
                float lastvalue2 = Util.GetFloat(dtoldvalue.Rows[1]["reading"]);
                float lastvalue3 = Util.GetFloat(dtoldvalue.Rows[2]["reading"]);
                float lastvalue4 = Util.GetFloat(dtoldvalue.Rows[3]["reading"]);
                float lastvalue5 = Util.GetFloat(dtoldvalue.Rows[4]["reading"]);
                float lastvalue6 = Util.GetFloat(dtoldvalue.Rows[5]["reading"]);
                float lastvalue7 = Util.GetFloat(dtoldvalue.Rows[6]["reading"]);
                float lastvalue8 = Util.GetFloat(dtoldvalue.Rows[7]["reading"]);
                float lastvalue9 = Util.GetFloat(dtoldvalue.Rows[8]["reading"]);

                if (value >= basemean && lastvalue1 >= basemean && lastvalue2 >= basemean && lastvalue3 >= basemean && lastvalue4 >= basemean && lastvalue5 >= basemean && lastvalue6 >= basemean && lastvalue7 >= basemean && lastvalue8 >= basemean && lastvalue9 >= basemean)
                {
                    if (dtruledata.Select("rulename='10-x'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#10-x#1";
                    }
                    else
                    {
                        statusandrule = "Warn#10-x#0";
                    }
                    
                }

                if (value <= basemean && lastvalue1 <= basemean && lastvalue2 <= basemean && lastvalue3 <= basemean && lastvalue4 <= basemean && lastvalue5 <= basemean && lastvalue6 <= basemean && lastvalue7 <= basemean && lastvalue8 <= basemean && lastvalue9 <= basemean)
                {
                    if (dtruledata.Select("rulename='10-x'")[0]["ruleaction"].ToString() == "Fail")
                    {
                        statusandrule = "Fail#10-x#1";
                    }
                    else
                    {
                        statusandrule = "Warn#10-x#0";
                    }
                }



            }
        }


        return statusandrule;
    }
    
}