// Copyright (c) 2025, ERP Omni Module
// Test cases for transformer utilities

import ballerina/test;
import ballerina/time;

@test:Config {}
function testValidateRequiredFieldsSuccess() {
    json testData = {
        "field1": "value1",
        "field2": "value2",
        "field3": 123
    };
    
    ValidationError? result = validateRequiredFields(testData, ["field1", "field2", "field3"]);
    test:assertTrue(result is (), msg = "Validation should pass for all required fields present");
}

@test:Config {}
function testValidateRequiredFieldsMissing() {
    json testData = {
        "field1": "value1",
        "field2": "value2"
    };
    
    ValidationError? result = validateRequiredFields(testData, ["field1", "field2", "field3"]);
    test:assertTrue(result is ValidationError, msg = "Validation should fail for missing field");
    
    if result is ValidationError {
        test:assertTrue(result.message().includes("field3"), msg = "Error message should mention missing field");
    }
}

@test:Config {}
function testValidateRequiredFieldsNull() {
    json testData = {
        "field1": "value1",
        "field2": ()
    };
    
    ValidationError? result = validateRequiredFields(testData, ["field1", "field2"]);
    test:assertTrue(result is ValidationError, msg = "Validation should fail for null field");
}

@test:Config {}
function testValidateRequiredFieldsInvalidType() {
    json testData = "not an object";
    
    ValidationError? result = validateRequiredFields(testData, ["field1"]);
    test:assertTrue(result is ValidationError, msg = "Validation should fail for non-object data");
}

@test:Config {}
function testGetStringOrDefault() {
    json testData = {
        "name": "John Doe",
        "email": "john@example.com",
        "nullField": ()
    };
    
    string name = getStringOrDefault(testData, "name");
    test:assertEquals(name, "John Doe", msg = "Should extract string value");
    
    string email = getStringOrDefault(testData, "email", "default@example.com");
    test:assertEquals(email, "john@example.com", msg = "Should extract string value");
    
    string missing = getStringOrDefault(testData, "missing", "default");
    test:assertEquals(missing, "default", msg = "Should return default for missing field");
    
    string nullField = getStringOrDefault(testData, "nullField", "default");
    test:assertEquals(nullField, "default", msg = "Should return default for null field");
}

@test:Config {}
function testGetDecimalOrDefault() {
    json testData = {
        "price": 99.99,
        "quantity": 10,
        "discount": 5.5,
        "nullField": ()
    };
    
    decimal price = getDecimalOrDefault(testData, "price");
    test:assertEquals(price, 99.99d, msg = "Should extract decimal value");
    
    decimal quantity = getDecimalOrDefault(testData, "quantity");
    test:assertEquals(quantity, 10.0d, msg = "Should convert int to decimal");
    
    decimal missing = getDecimalOrDefault(testData, "missing", 0.0);
    test:assertEquals(missing, 0.0d, msg = "Should return default for missing field");
}

@test:Config {}
function testGetIntOrDefault() {
    json testData = {
        "count": 42,
        "total": 100,
        "nullField": ()
    };
    
    int count = getIntOrDefault(testData, "count");
    test:assertEquals(count, 42, msg = "Should extract int value");
    
    int missing = getIntOrDefault(testData, "missing", 0);
    test:assertEquals(missing, 0, msg = "Should return default for missing field");
    
    int nullField = getIntOrDefault(testData, "nullField", -1);
    test:assertEquals(nullField, -1, msg = "Should return default for null field");
}

@test:Config {}
function testGetBooleanOrDefault() {
    json testData = {
        "active": true,
        "verified": false,
        "nullField": ()
    };
    
    boolean active = getBooleanOrDefault(testData, "active");
    test:assertTrue(active, msg = "Should extract true value");
    
    boolean verified = getBooleanOrDefault(testData, "verified");
    test:assertFalse(verified, msg = "Should extract false value");
    
    boolean missing = getBooleanOrDefault(testData, "missing", true);
    test:assertTrue(missing, msg = "Should return default for missing field");
}

@test:Config {}
function testCreateTransformationMetadata() {
    TransformationMetadata metadata = createTransformationMetadata("SAP", "v1.0", "sap-transformer");
    
    test:assertEquals(metadata.sourceSystem, "SAP", msg = "Source system mismatch");
    test:assertEquals(metadata.sourceVersion, "v1.0", msg = "Source version mismatch");
    test:assertEquals(metadata.transformerId, "sap-transformer", msg = "Transformer ID mismatch");
    
    time:Utc currentTime = time:utcNow();
    decimal timeDiff = time:utcDiffSeconds(currentTime, metadata.transformedAt);
    test:assertTrue(timeDiff < 1.0d, msg = "Timestamp should be recent");
}

@test:Config {}
function testWrapWithMetadata() {
    PurchaseOrder po = {
        id: "PO-001",
        poNumber: "PO-2025-001",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-001",
            name: "Test Vendor",
            address: {
                street1: "123 St",
                city: "City",
                postalCode: "12345",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [],
        subtotal: 0.0,
        grandTotal: 0.0,
        status: "DRAFT"
    };
    
    TransformationMetadata metadata = createTransformationMetadata("SAP", "v1.0", "test-transformer");
    CanonicalRecord wrapped = wrapWithMetadata(po, metadata);
    
    test:assertEquals(wrapped.metadata.sourceSystem, "SAP", msg = "Metadata source system mismatch");
    test:assertTrue(wrapped.payload is PurchaseOrder, msg = "Payload should be PurchaseOrder");
}

@test:Config {}
function testTransformSapToPurchaseOrderSuccess() {
    json sapData = {
        "PurchaseOrder": "4500000001",
        "PurchaseOrderDate": "2025-01-15",
        "Currency": "USD",
        "Status": "APPROVED",
        "Supplier": {
            "SupplierID": "SUP-001",
            "SupplierName": "Acme Supplies",
            "Street": "123 Supply St",
            "City": "New York",
            "PostalCode": "10001",
            "Country": "US"
        },
        "Items": [
            {
                "MaterialNumber": "MAT-001",
                "Description": "Widget A",
                "Quantity": 100,
                "UnitPrice": 10.50
            },
            {
                "MaterialNumber": "MAT-002",
                "Description": "Widget B",
                "Quantity": 50,
                "UnitPrice": 20.00
            }
        ]
    };
    
    PurchaseOrder|TransformationError result = transformSapToPurchaseOrder(sapData);
    
    test:assertTrue(result is PurchaseOrder, msg = "Should successfully transform SAP data");
    
    if result is PurchaseOrder {
        test:assertEquals(result.poNumber, "4500000001", msg = "PO number mismatch");
        test:assertEquals(result.currency, "USD", msg = "Currency mismatch");
        test:assertEquals(result.status, "APPROVED", msg = "Status mismatch");
        test:assertEquals(result.vendor.name, "Acme Supplies", msg = "Vendor name mismatch");
        test:assertEquals(result.items.length(), 2, msg = "Items count mismatch");
        test:assertEquals(result.items[0].sku, "MAT-001", msg = "First item SKU mismatch");
        test:assertEquals(result.items[0].lineTotal, 1050.00d, msg = "First item total mismatch");
        test:assertEquals(result.subtotal, 2050.00d, msg = "Subtotal mismatch");
    }
}

@test:Config {}
function testTransformSapToPurchaseOrderMissingFields() {
    json sapData = {
        "PurchaseOrder": "4500000001",
        "Currency": "USD"
    };
    
    PurchaseOrder|TransformationError result = transformSapToPurchaseOrder(sapData);
    
    test:assertTrue(result is TransformationError, msg = "Should fail for missing required fields");
}

@test:Config {}
function testTransformSapToPurchaseOrderMissingSupplier() {
    json sapData = {
        "PurchaseOrder": "4500000001",
        "PurchaseOrderDate": "2025-01-15",
        "Currency": "USD"
    };
    
    PurchaseOrder|TransformationError result = transformSapToPurchaseOrder(sapData);
    
    test:assertTrue(result is TransformationError, msg = "Should fail for missing supplier");
}

@test:Config {}
function testTransformPurchaseOrderToSapSuccess() {
    PurchaseOrder po = {
        id: "PO-001",
        poNumber: "PO-2025-001",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-001",
            name: "Test Vendor",
            address: {
                street1: "123 Vendor St",
                city: "Boston",
                postalCode: "02101",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [
            {
                lineNumber: 1,
                sku: "ITEM-001",
                description: "Test Item",
                quantity: 10,
                unitOfMeasure: "EA",
                unitPrice: 100.00,
                lineTotal: 1000.00
            }
        ],
        subtotal: 1000.00,
        grandTotal: 1000.00,
        status: "DRAFT"
    };
    
    json|TransformationError result = transformPurchaseOrderToSap(po);
    
    test:assertTrue(result is json, msg = "Should successfully transform to SAP format");
    
    if result is json {
        test:assertEquals(getStringOrDefault(result, "PurchaseOrder"), "PO-2025-001", msg = "PO number mismatch");
        test:assertEquals(getStringOrDefault(result, "Currency"), "USD", msg = "Currency mismatch");
        test:assertEquals(getStringOrDefault(result, "Status"), "DRAFT", msg = "Status mismatch");
        
        json supplierData = result is map<json> ? result["Supplier"] : ();
        test:assertTrue(supplierData is json, msg = "Supplier data should exist");
        test:assertEquals(getStringOrDefault(supplierData, "SupplierID"), "V-001", msg = "Supplier ID mismatch");
        
        json itemsData = result is map<json> ? result["Items"] : ();
        test:assertTrue(itemsData is json[], msg = "Items should be an array");
    }
}

@test:Config {}
function testTransformToPurchaseOrderNotImplemented() {
    json testData = {"test": "data"};
    
    PurchaseOrder|TransformationError result = transformToPurchaseOrder(testData, "UnknownSystem");
    
    test:assertTrue(result is TransformationError, msg = "Should return error for unimplemented system");
    
    if result is TransformationError {
        test:assertTrue(result.message().includes("UnknownSystem"), msg = "Error should mention system name");
    }
}

@test:Config {}
function testTransformFromPurchaseOrderNotImplemented() {
    PurchaseOrder po = {
        id: "PO-001",
        poNumber: "PO-001",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: {
            id: "V-001",
            name: "Vendor",
            address: {
                street1: "123 St",
                city: "City",
                postalCode: "12345",
                country: "US"
            },
            contactDetails: {},
            currency: "USD"
        },
        items: [],
        subtotal: 0.0,
        grandTotal: 0.0,
        status: "DRAFT"
    };
    
    json|TransformationError result = transformFromPurchaseOrder(po, "UnknownSystem");
    
    test:assertTrue(result is TransformationError, msg = "Should return error for unimplemented system");
}
