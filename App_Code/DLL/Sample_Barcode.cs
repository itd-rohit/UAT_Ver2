using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Sample_Barcode
/// </summary>
public class Sample_Barcode
{
	public Sample_Barcode()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public int InvestigationID { get; set; }
    public string InvestigationName { get; set; }
    public int SampleTypeID { get; set; }
    public string SampleTypeName { get; set; }
    public string BarcodeNo { get; set; }
    public int IsSNR { get; set; }
    public string HistoCytoSampleDetail { get; set; }
}