// Copyright (c) 2025, ERP Omni Module
// Canonical Data Model (CDM) for ERP Systems

import ballerina/time;

// ============================================================================
// CORE CANONICAL RECORDS
// ============================================================================

// Represents a unified address structure across all ERP systems
public type Address record {|
    string street1;
    string? street2 = ();
    string city;
    string? stateProvince = ();
    string postalCode;
    string country; // ISO 3166-1 alpha-2 code (e.g., "US", "GB")
|};

// Represents unified contact details
public type ContactDetails record {|
    string? email = ();
    string? phone = ();
    string? mobile = ();
    string? fax = ();
|};

// Represents a customer entity across ERP systems
public type Customer record {|
    string id; // Canonical customer ID
    string name;
    string? displayName = ();
    Address billingAddress;
    Address? shippingAddress = ();
    ContactDetails contactDetails;
    string? taxId = (); // VAT/Tax registration number
    string? customerType = (); // e.g., "RETAIL", "WHOLESALE", "ENTERPRISE"
    string? paymentTerms = (); // e.g., "NET30", "NET60", "COD"
    string currency; // ISO 4217 currency code (e.g., "USD", "EUR")
    boolean active = true;
    map<string> customFields = {}; // Vendor-specific extensions
|};

// Represents a vendor/supplier entity
public type Vendor record {|
    string id; // Canonical vendor ID
    string name;
    string? displayName = ();
    Address address;
    ContactDetails contactDetails;
    string? taxId = ();
    string? paymentTerms = ();
    string currency;
    boolean active = true;
    map<string> customFields = {};
|};

// Represents a line item in a purchase order
public type PurchaseOrderItem record {|
    int lineNumber;
    string sku; // Stock Keeping Unit
    string? description = ();
    decimal quantity;
    string? unitOfMeasure = (); // e.g., "EA", "KG", "LB"
    decimal unitPrice;
    decimal? taxRate = (); // Tax rate as percentage (e.g., 10.5 for 10.5%)
    decimal? taxAmount = ();
    decimal lineTotal; // quantity * unitPrice
    decimal? discount = (); // Discount amount
    string? deliveryDate = (); // Expected delivery date (ISO 8601)
    map<string> customFields = {};
|};

// Represents a purchase order header
public type PurchaseOrder record {|
    string id; // Canonical PO ID
    string poNumber; // Human-readable PO number
    string orderDate; // ISO 8601 date format
    string? expectedDeliveryDate = ();
    string currency; // ISO 4217 currency code
    Vendor vendor;
    PurchaseOrderItem[] items;
    decimal subtotal;
    decimal? totalTax = ();
    decimal? totalDiscount = ();
    decimal grandTotal;
    string status; // e.g., "DRAFT", "SUBMITTED", "APPROVED", "RECEIVED", "CANCELLED"
    string? shippingMethod = ();
    Address? deliveryAddress = ();
    string? notes = ();
    map<string> customFields = {};
|};

// Represents payment terms for an invoice
public type PaymentTerms record {|
    string terms; // e.g., "NET30", "NET60", "DUE_ON_RECEIPT"
    int? dueDays = (); // Number of days until payment is due
    string? dueDate = (); // Explicit due date (ISO 8601)
    decimal? discountPercentage = (); // Early payment discount
    int? discountDays = (); // Days within which discount applies
|};

// Represents an invoice line item
public type InvoiceItem record {|
    int lineNumber;
    string sku;
    string? description = ();
    decimal quantity;
    string? unitOfMeasure = ();
    decimal unitPrice;
    decimal? taxRate = ();
    decimal? taxAmount = ();
    decimal lineTotal;
    decimal? discount = ();
    string? relatedPoLineNumber = (); // Link to PO line item
    map<string> customFields = {};
|};

// Represents an invoice
public type Invoice record {|
    string id; // Canonical invoice ID
    string invoiceNumber; // Human-readable invoice number
    string invoiceDate; // ISO 8601 date format
    string currency;
    Customer? customer = (); // For sales invoices
    Vendor? vendor = (); // For purchase invoices (vendor bills)
    InvoiceItem[] items;
    decimal subtotal;
    decimal? totalTax = ();
    decimal? totalDiscount = ();
    decimal grandTotal;
    decimal amountDue;
    decimal amountPaid = 0.0;
    PaymentTerms paymentTerms;
    string status; // e.g., "DRAFT", "SENT", "PAID", "OVERDUE", "VOID"
    string? relatedPoId = (); // Link to related PurchaseOrder
    string? notes = ();
    map<string> customFields = {};
|};

// Represents a product/item in inventory
public type Product record {|
    string id; // Canonical product ID
    string sku;
    string name;
    string? description = ();
    string? category = ();
    decimal? unitPrice = ();
    string? unitOfMeasure = ();
    boolean active = true;
    string? taxCategory = ();
    map<string> customFields = {};
|};

// ============================================================================
// CUSTOM ERROR TYPES
// ============================================================================

// Base error type for all ERP-related errors
public type ErpError distinct error;

// Authentication or authorization failures
public type AuthenticationError distinct ErpError;

// Rate limiting or quota exceeded errors
public type RateLimitError distinct ErpError;

// Data validation or schema mismatch errors
public type SchemaMismatchError distinct ErpError;

// Resource not found errors
public type NotFoundError distinct ErpError;

// Network or connectivity errors
public type ConnectionError distinct ErpError;

// Vendor-specific API errors
public type VendorApiError distinct ErpError;

// Data transformation errors
public type TransformationError distinct ErpError;

// Business logic validation errors
public type ValidationError distinct ErpError;

// ============================================================================
// TRANSFORMATION METADATA
// ============================================================================

// Metadata for tracking data transformations
public type TransformationMetadata record {|
    string sourceSystem; // e.g., "SAP", "NetSuite", "Dynamics", "Odoo"
    string sourceVersion; // API version
    time:Utc transformedAt;
    string transformerId; // Identifier of the transformer function
    map<string> sourceFields = {}; // Original field mappings for audit
|};

// Wrapper for canonical records with transformation metadata
public type CanonicalRecord record {|
    TransformationMetadata metadata;
    anydata payload; // The actual canonical record (PurchaseOrder, Invoice, etc.)
|};
