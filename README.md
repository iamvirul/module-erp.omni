# ERP Omni - Canonical Data Model for ERP Systems

A Ballerina library providing a **Canonical Data Model (CDM)** and **Unified Interface** for Enterprise Resource Planning (ERP) systems. Decouple your business logic from vendor-specific APIs (SAP, NetSuite, Microsoft Dynamics, Odoo, etc.).

## Features

✅ **Canonical Records** - Standardized business objects (PurchaseOrder, Invoice, Customer, Vendor, Product)  
✅ **Abstract ErpClient** - Unified interface for all ERP operations  
✅ **Transformer Utilities** - Safe JSON extraction and data mapping helpers  
✅ **Custom Error Types** - Categorized errors for robust error handling  
✅ **Type Safety** - Leverages Ballerina's type system for data integrity  
✅ **Extensible** - Easy to add new ERP vendors without changing core logic  

## Installation

Add the dependency to your `Ballerina.toml`:

```toml
[dependencies]
"virul/module_erp.omni" = "0.1.0"
```

Or pull from Ballerina Central:

```bash
bal pull virul/module_erp.omni
```

## Quick Start

### 1. Import the Module

```ballerina
import virul/module_erp.omni;
```

### 2. Implement a Vendor-Specific Client

```ballerina
import ballerina/http;
import virul/module_erp.omni;

public client class SapErpClient {
    *omni:ErpClient;
    
    private final http:Client sapClient;
    
    public function init(string baseUrl, string apiKey) returns error? {
        self.sapClient = check new (baseUrl, {
            auth: {token: apiKey}
        });
    }
    
    remote function createPurchaseOrder(omni:PurchaseOrder po) returns string|omni:ErpError {
        json|omni:TransformationError sapPo = omni:transformPurchaseOrderToSap(po);
        if sapPo is omni:TransformationError {
            return sapPo;
        }
        
        json|http:ClientError response = self.sapClient->post("/purchaseorders", sapPo);
        if response is http:ClientError {
            return error omni:ConnectionError("Failed to create PO", response);
        }
        
        return omni:getStringOrDefault(response, "PurchaseOrderID");
    }
    
    // Implement other methods...
}
```

### 3. Use the Client

```ballerina
public function main() returns error? {
    SapErpClient sapClient = check new ("https://api.sap.com", "your-api-key");
    
    omni:PurchaseOrder newPo = {
        id: "",
        poNumber: "PO-2025-001",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-1001",
            name: "Acme Supplies",
            address: {
                street1: "123 Main St",
                city: "New York",
                postalCode: "10001",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [{
            lineNumber: 1,
            sku: "WIDGET-001",
            quantity: 100,
            unitPrice: 25.50d,
            lineTotal: 2550.00d
        }],
        subtotal: 2550.00d,
        grandTotal: 2550.00d,
        status: "DRAFT"
    };
    
    string poId = check sapClient->createPurchaseOrder(newPo);
}
```

## Core Components

### Canonical Records

- **`PurchaseOrder`** - Purchase order with header and line items
- **`Invoice`** - Invoice with payment terms and items  
- **`Customer`** - Customer entity with address and contact details
- **`Vendor`** - Vendor/supplier entity
- **`Product`** - Product/inventory item

### ErpClient Interface

Provides CRUD operations for:
- Purchase Orders
- Invoices
- Customers
- Vendors
- Products

### Transformer Utilities

- `validateRequiredFields()` - Validate required fields in vendor data
- `getStringOrDefault()` - Safely extract string values from JSON
- `getDecimalOrDefault()` - Safely extract decimal values from JSON
- `getIntOrDefault()` - Safely extract integer values from JSON
- `getBooleanOrDefault()` - Safely extract boolean values from JSON
- `createTransformationMetadata()` - Track data lineage
- `wrapWithMetadata()` - Wrap records with metadata

### Error Types

- `ErpError` - Base error type
- `AuthenticationError` - Auth failures
- `RateLimitError` - Rate limiting
- `SchemaMismatchError` - Data validation errors
- `NotFoundError` - Resource not found
- `ConnectionError` - Network issues
- `VendorApiError` - Vendor-specific errors
- `TransformationError` - Data transformation errors
- `ValidationError` - Business logic validation

## Examples

See the [Module.md](Module.md) file for comprehensive examples including:
- Implementing vendor-specific clients
- Creating custom transformers
- Error handling patterns
- Best practices

## Testing

Run the test suite:

```bash
bal test
```

The module includes 37+ comprehensive test cases covering all components.

## Architecture Benefits

1. **Decoupling** - Business logic independent of vendor APIs
2. **Consistency** - Uniform data structures across all ERP systems
3. **Maintainability** - Vendor API changes only affect transformers
4. **Testability** - Easy to mock and test with canonical records
5. **Extensibility** - Add new vendors without changing core logic
6. **Type Safety** - Ballerina's type system ensures data integrity

## Contributing

Contributions are welcome! Please ensure:
- All tests pass (`bal test`)
- Code follows Ballerina best practices
- New features include tests and documentation

## License

Copyright (c) 2025, ERP Omni Module

## Support

For detailed documentation, see [Module.md](Module.md)

For issues and questions, please open an issue in the repository.
