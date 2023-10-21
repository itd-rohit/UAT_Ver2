using System;

/// <summary>
/// Summary description for PurchaseOrder
/// </summary>
public class PurchaseOrder
{
    public PurchaseOrder()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    //PurchaseOrder
    public string PurchaseOrderNo { get; set; }
    public int PurchaseOrderID { get; set; }
    public string Subject { get; set; }
    public int VendorID { get; set; }
    public string VendorName { get; set; }
    public int CreatedByID { get; set; }
    public string CreatedByName { get; set; }
    public DateTime CheckedDate { get; set; }
    public int CheckedByID { get; set; }
    public string CheckedByName { get; set; }
    public DateTime ApprovedDate { get; set; }
    public int ApprovedByID { get; set; }
    public string AppprovedByName { get; set; }
    public int Status { get; set; }
    public string StatusName { get; set; }
    public int LocationID { get; set; }
    public string IndentNo { get; set; }
    public int VendorStateId { get; set; }
    public string VendorGSTIN { get; set; }
    public string VendorAddress { get; set; }
    public int VendorLogin { get; set; }
    public string POType { get; set; }
    public int IsDirectPO { get; set; }
    public string ActionType { get; set; }
    //PurchaseOrderDetail
    public int ItemID { get; set; }
    public string ItemName { get; set; }
    public int ManufactureID { get; set; }
    public string ManufactureName { get; set; }
    public string CatalogNo { get; set; }
    public int MachineID { get; set; }
    public string MachineName { get; set; }
    public int MajorUnitId { get; set; }
    public string MajorUnitName { get; set; }
    public string PackSize { get; set; }
    public decimal OrderedQty { get; set; }
    public decimal CheckedQty { get; set; }
    public decimal ApprovedQty { get; set; }
    public decimal GRNQty { get; set; }
    public decimal Rate { get; set; }
    public decimal TaxAmount { get; set; }
    public decimal DiscountAmount { get; set; }
    public decimal DiscountPercentage { get; set; }
    public decimal NetAmount { get; set; }
    public decimal UnitPrice { get; set; }
    public int IsFree { get; set; }
    public decimal TaxPer { get; set; }
    public int tableSNo { get; set; }
    //PurchaseOrderTax
    public string TaxName { get; set; }
    public decimal Percentage { get; set; }
    public decimal TaxAmt { get; set; }

    public decimal TaxPerCGST { get; set; }
    public decimal TaxPerIGST { get; set; }
    public decimal TaxPerSGST { get; set; }

    public string Warranty { get; set; }
    public string NFANo { get; set; }
    public string Termandcondition { get; set; }
}
