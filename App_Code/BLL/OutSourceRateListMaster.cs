/// <summary>
/// Summary description for PatientLabObservationOpd
/// </summary>
public class OutSourceRateListMaster
{
    public OutSourceRateListMaster()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    private string _CentreID;
    private string _CentreName;
    private string _LabID;
    private string _LabName;
    private string _Investigation_Id;
    private string _Investigation;
    private string _OutsourceRate;
    private int _IsDefault;
    public string CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public string CentreName { get { return _CentreName; } set { _CentreName = value; } }
    public string LabID { get { return _LabID; } set { _LabID = value; } }
    public string LabName { get { return _LabName; } set { _LabName = value; } }
    public string Investigation_Id { get { return _Investigation_Id; } set { _Investigation_Id = value; } }
    public string Investigation { get { return _Investigation; } set { _Investigation = value; } }
    public string OutsourceRate { get { return _OutsourceRate; } set { _OutsourceRate = value; } }
    public int IsDefault { get { return _IsDefault; } set { _IsDefault = value; } }
    public string TATType { get; set; }
    public string TAT { get; set; }
    public string IsFileRequired { get; set; }
    public int othercount { get; set; }

}