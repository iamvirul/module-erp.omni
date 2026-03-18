# ERP Omni Module - Canonical Data Model for ERP Systems

## Overview

The `erp.omni` module provides a **Canonical Data Model (CDM)** and **Unified Interface** for Enterprise Resource Planning (ERP) systems. It decouples business logic from vendor-specific APIs (SAP, NetSuite, Microsoft Dynamics, Odoo, etc.) by providing standardized record types, a unified client interface, and transformation utilities.

## Key Components

### 1. Canonical Records (`types.bal`)

Standard business objects that represent data consistently across all ERP systems:

- **`PurchaseOrder`** - Purchase order with header and line items
- **`Invoice`** - Invoice with payment terms and items
- **`Customer`** - Customer entity with unified address and contact details
- **`Vendor`** - Vendor/supplier entity
- **`Product`** - Product/inventory item
- **`Address`** - Standardized address structure
- **`ContactDetails`** - Unified contact information
- **`PaymentTerms`** - Payment terms for invoices

### 2. Abstract ErpClient Interface (`client.bal`)

A unified client object that defines standard methods for ERP operations:

**Purchase Order Operations:**
- `createPurchaseOrder()` - Create a new PO
- `getPurchaseOrder()` - Retrieve a PO by ID
- `updatePurchaseOrder()` - Update an existing PO
- `deletePurchaseOrder()` - Delete/cancel a PO
- `listPurchaseOrders()` - List POs with filtering

**Invoice Operations:**
- `createInvoice()` - Create a new invoice
- `getInvoice()` - Retrieve an invoice by ID
- `updateInvoice()` - Update an existing invoice
- `deleteInvoice()` - Delete/void an invoice
- `listInvoices()` - List invoices with filtering

**Customer, Vendor, and Product Operations:**
- Similar CRUD operations for each entity type

### 3. Custom Error Types (`types.bal`)

Categorized error types for robust error handling:

- **`ErpError`** - Base error type
- **`AuthenticationError`** - Authentication/authorization failures
- **`RateLimitError`** - Rate limiting or quota exceeded
- **`SchemaMismatchError`** - Data validation or schema mismatch
- **`NotFoundError`** - Resource not found
- **`ConnectionError`** - Network or connectivity issues
- **`VendorApiError`** - Vendor-specific API errors
- **`TransformationError`** - Data transformation errors
- **`ValidationError`** - Business logic validation errors

### 4. Transformer Templates (`transformers.bal`)

Patterns and utilities for converting between vendor-specific formats and canonical records:

**Template Functions:**
- `transformToPurchaseOrder()` - Convert vendor JSON to canonical PurchaseOrder
- `transformFromPurchaseOrder()` - Convert canonical PurchaseOrder to vendor JSON
- `transformToInvoice()` - Convert vendor JSON to canonical Invoice
- `transformFromInvoice()` - Convert canonical Invoice to vendor JSON
- `transformToCustomer()` - Convert vendor JSON to canonical Customer
- `transformFromCustomer()` - Convert canonical Customer to vendor JSON

**Utility Functions:**
- `validateRequiredFields()` - Validate required fields in vendor data
- `getStringOrDefault()` - Safely extract string values from JSON
- `getDecimalOrDefault()` - Safely extract decimal values from JSON
- `getIntOrDefault()` - Safely extract integer values from JSON
- `getBooleanOrDefault()` - Safely extract boolean values from JSON
- `createTransformationMetadata()` - Create metadata for tracking transformations
- `wrapWithMetadata()` - Wrap canonical records with metadata

**Example Implementations:**
- `transformSapToPurchaseOrder()` - SAP-specific transformer example
- `transformPurchaseOrderToSap()` - Reverse SAP transformer example

## Usage Examples

### Implementing a Vendor-Specific Client

```ballerina
import ballerina/http;

// SAP-specific implementation
public client class SapErpClient {
    *ErpClient;
    
    private final http:Client sapClient;
    
    public function init(string baseUrl, string apiKey) returns error? {
        self.sapClient = check new (baseUrl, {
            auth: {
                token: apiKey
            }
        });
    }
    
    remote function createPurchaseOrder(PurchaseOrder purchaseOrder) returns string|ErpError {
        // Transform canonical PO to SAP format
        json|TransformationError sapPo = transformPurchaseOrderToSap(purchaseOrder);
        if sapPo is TransformationError {
            return sapPo;
        }
        
        // Call SAP API
        json|http:ClientError response = self.sapClient->post("/purchaseorders", sapPo);
        if response is http:ClientError {
            return error ConnectionError("Failed to create PO in SAP", response);
        }
        
        // Extract and return SAP's internal ID
        string poId = getStringOrDefault(response, "PurchaseOrderID");
        return poId;
    }
    
    remote function getPurchaseOrder(string id) returns PurchaseOrder|ErpError {
        // Call SAP API
        json|http:ClientError response = self.sapClient->get(string `/purchaseorders/${id}`);
        if response is http:ClientError {
            return error NotFoundError(string `PO ${id} not found in SAP`, response);
        }
        
        // Transform SAP response to canonical format
        PurchaseOrder|TransformationError po = transformSapToPurchaseOrder(response);
        return po;
    }
    
    // Implement other methods...
}
```

### Using the Client

```ballerina
public function main() returns error? {
    // Initialize SAP client
    SapErpClient sapClient = check new ("https://api.sap.com", "your-api-key");
    
    // Create a purchase order
    PurchaseOrder newPo = {
        id: "",
        poNumber: "PO-2025-001",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-1001",
            name: "Acme Supplies Inc.",
            address: {
                street1: "123 Main St",
                city: "New York",
                postalCode: "10001",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [
            {
                lineNumber: 1,
                sku: "WIDGET-001",
                description: "Premium Widget",
                quantity: 100,
                unitPrice: 25.50,
                lineTotal: 2550.00
            }
        ],
        subtotal: 2550.00,
        grandTotal: 2550.00,
        status: "DRAFT"
    };
    
    // Create in SAP
    string|ErpError poId = sapClient->createPurchaseOrder(newPo);
    if poId is ErpError {
        // Handle error
        return poId;
    }
    
    // Retrieve the created PO
    PurchaseOrder|ErpError retrievedPo = sapClient->getPurchaseOrder(poId);
    if retrievedPo is PurchaseOrder {
        // Use the PO
    }
}
```

### Creating Custom Transformers

```ballerina
// NetSuite-specific transformer
public isolated function transformNetSuiteToPurchaseOrder(json nsData) returns PurchaseOrder|TransformationError {
    // Validate required fields
    ValidationError? validationResult = validateRequiredFields(nsData, ["tranId", "tranDate", "currency"]);
    if validationResult is ValidationError {
        return error TransformationError(validationResult.message(), validationResult);
    }
    
    // Extract vendor
    json vendorData = nsData["entity"];
    if vendorData is () {
        return error TransformationError("Vendor information is missing");
    }
    
    Vendor vendor = {
        id: getStringOrDefault(vendorData, "internalId"),
        name: getStringOrDefault(vendorData, "entityId"),
        address: {
            street1: getStringOrDefault(vendorData, "billAddr1"),
            city: getStringOrDefault(vendorData, "billCity"),
            postalCode: getStringOrDefault(vendorData, "billZip"),
            country: getStringOrDefault(vendorData, "billCountry")
        },
        contactDetails: {},
        currency: getStringOrDefault(nsData, "currency")
    };
    
    // Extract line items
    json itemsData = nsData["item"];
    PurchaseOrderItem[] items = [];
    
    if itemsData is json[] {
        int lineNum = 1;
        foreach json itemData in itemsData {
            decimal quantity = getDecimalOrDefault(itemData, "quantity");
            decimal rate = getDecimalOrDefault(itemData, "rate");
            
            PurchaseOrderItem item = {
                lineNumber: lineNum,
                sku: getStringOrDefault(itemData, "item"),
                description: getStringOrDefault(itemData, "description"),
                quantity: quantity,
                unitPrice: rate,
                lineTotal: quantity * rate
            };
            items.push(item);
            lineNum = lineNum + 1;
        }
    }
    
    // Calculate totals
    decimal subtotal = getDecimalOrDefault(nsData, "subtotal");
    decimal total = getDecimalOrDefault(nsData, "total");
    
    PurchaseOrder purchaseOrder = {
        id: getStringOrDefault(nsData, "internalId"),
        poNumber: getStringOrDefault(nsData, "tranId"),
        orderDate: getStringOrDefault(nsData, "tranDate"),
        currency: getStringOrDefault(nsData, "currency"),
        vendor: vendor,
        items: items,
        subtotal: subtotal,
        grandTotal: total,
        status: getStringOrDefault(nsData, "status", "DRAFT")
    };
    
    return purchaseOrder;
}
```

## Architecture Benefits

1. **Decoupling** - Business logic is independent of vendor-specific APIs
2. **Consistency** - Uniform data structures across all ERP systems
3. **Maintainability** - Changes to vendor APIs only affect transformers
4. **Testability** - Easy to mock and test with canonical records
5. **Extensibility** - Add new ERP vendors without changing core logic
6. **Type Safety** - Ballerina's type system ensures data integrity
7. **Error Handling** - Categorized errors for better error management

## Best Practices

1. **Implement all ErpClient methods** for each vendor
2. **Use transformation metadata** to track data lineage
3. **Handle vendor-specific fields** using the `customFields` map
4. **Validate data** before transformation
5. **Use appropriate error types** for different failure scenarios
6. **Document vendor-specific quirks** in transformer implementations
7. **Test transformers** with real vendor data samples

## Extension Points

- Add new canonical record types for additional business objects
- Extend existing records with optional fields
- Create vendor-specific error subtypes
- Implement batch operation methods
- Add caching and retry logic in client implementations
