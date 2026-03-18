// Copyright (c) 2025, ERP Omni Module
// Transformer Templates and Utilities for Vendor-Specific Mapping

import ballerina/time;

// ============================================================================
// TRANSFORMER FUNCTION TEMPLATES
// ============================================================================

// Template function for transforming vendor-specific JSON to canonical PurchaseOrder
// Implementers should create vendor-specific versions of this function
// 
// + vendorData - The vendor-specific JSON data
// + sourceSystem - The name of the source ERP system (e.g., "SAP", "NetSuite")
// + return - Canonical PurchaseOrder or TransformationError
public isolated function transformToPurchaseOrder(json vendorData, string sourceSystem) returns PurchaseOrder|TransformationError {
    // Template implementation - should be overridden by vendor-specific transformers
    return error TransformationError(string `Transformer not implemented for ${sourceSystem}`);
}

// Template function for transforming canonical PurchaseOrder to vendor-specific format
// 
// + purchaseOrder - The canonical purchase order
// + targetSystem - The target ERP system (e.g., "SAP", "NetSuite")
// + return - Vendor-specific JSON or TransformationError
public isolated function transformFromPurchaseOrder(PurchaseOrder purchaseOrder, string targetSystem) returns json|TransformationError {
    // Template implementation - should be overridden by vendor-specific transformers
    return error TransformationError(string `Transformer not implemented for ${targetSystem}`);
}

// Template function for transforming vendor-specific JSON to canonical Invoice
// 
// + vendorData - The vendor-specific JSON data
// + sourceSystem - The name of the source ERP system
// + return - Canonical Invoice or TransformationError
public isolated function transformToInvoice(json vendorData, string sourceSystem) returns Invoice|TransformationError {
    // Template implementation - should be overridden by vendor-specific transformers
    return error TransformationError(string `Transformer not implemented for ${sourceSystem}`);
}

// Template function for transforming canonical Invoice to vendor-specific format
// 
// + invoice - The canonical invoice
// + targetSystem - The target ERP system
// + return - Vendor-specific JSON or TransformationError
public isolated function transformFromInvoice(Invoice invoice, string targetSystem) returns json|TransformationError {
    // Template implementation - should be overridden by vendor-specific transformers
    return error TransformationError(string `Transformer not implemented for ${targetSystem}`);
}

// Template function for transforming vendor-specific JSON to canonical Customer
// 
// + vendorData - The vendor-specific JSON data
// + sourceSystem - The name of the source ERP system
// + return - Canonical Customer or TransformationError
public isolated function transformToCustomer(json vendorData, string sourceSystem) returns Customer|TransformationError {
    // Template implementation - should be overridden by vendor-specific transformers
    return error TransformationError(string `Transformer not implemented for ${sourceSystem}`);
}

// Template function for transforming canonical Customer to vendor-specific format
// 
// + customer - The canonical customer
// + targetSystem - The target ERP system
// + return - Vendor-specific JSON or TransformationError
public isolated function transformFromCustomer(Customer customer, string targetSystem) returns json|TransformationError {
    // Template implementation - should be overridden by vendor-specific transformers
    return error TransformationError(string `Transformer not implemented for ${targetSystem}`);
}

// ============================================================================
// UTILITY FUNCTIONS FOR TRANSFORMERS
// ============================================================================

// Creates transformation metadata for tracking data lineage
// 
// + sourceSystem - The source ERP system name
// + sourceVersion - The API version of the source system
// + transformerId - Identifier of the transformer function
// + return - TransformationMetadata record
public isolated function createTransformationMetadata(string sourceSystem, string sourceVersion, string transformerId) returns TransformationMetadata {
    return {
        sourceSystem: sourceSystem,
        sourceVersion: sourceVersion,
        transformedAt: time:utcNow(),
        transformerId: transformerId
    };
}

// Wraps a canonical record with transformation metadata
// 
// + payload - The canonical record (PurchaseOrder, Invoice, Customer, etc.)
// + metadata - The transformation metadata
// + return - CanonicalRecord with metadata
public isolated function wrapWithMetadata(anydata payload, TransformationMetadata metadata) returns CanonicalRecord {
    return {
        metadata: metadata,
        payload: payload
    };
}

// Validates that required fields are present in vendor data
// 
// + vendorData - The vendor-specific JSON data
// + requiredFields - Array of required field names
// + return - ValidationError if any required field is missing, otherwise ()
public isolated function validateRequiredFields(json vendorData, string[] requiredFields) returns ValidationError? {
    if vendorData !is map<json> {
        return error ValidationError("Vendor data must be a JSON object");
    }
    
    foreach string fieldName in requiredFields {
        json fieldValue = vendorData[fieldName];
        if fieldValue is () {
            return error ValidationError(string `Required field '${fieldName}' is missing or null`);
        }
    }
    return ();
}

// Safely extracts a string value from JSON with a default
// 
// + data - The JSON data
// + fieldName - The field name to extract
// + defaultValue - Default value if field is missing or null
// + return - The extracted string value or default
public isolated function getStringOrDefault(json data, string fieldName, string defaultValue = "") returns string {
    if data !is map<json> {
        return defaultValue;
    }
    
    json fieldValue = data[fieldName];
    if fieldValue is string {
        return fieldValue;
    }
    return defaultValue;
}

// Safely extracts a decimal value from JSON with a default
// 
// + data - The JSON data
// + fieldName - The field name to extract
// + defaultValue - Default value if field is missing or null
// + return - The extracted decimal value or default
public isolated function getDecimalOrDefault(json data, string fieldName, decimal defaultValue = 0.0) returns decimal {
    if data !is map<json> {
        return defaultValue;
    }
    
    json fieldValue = data[fieldName];
    if fieldValue is decimal {
        return fieldValue;
    }
    if fieldValue is int {
        return <decimal>fieldValue;
    }
    if fieldValue is float {
        return <decimal>fieldValue;
    }
    return defaultValue;
}

// Safely extracts an integer value from JSON with a default
// 
// + data - The JSON data
// + fieldName - The field name to extract
// + defaultValue - Default value if field is missing or null
// + return - The extracted integer value or default
public isolated function getIntOrDefault(json data, string fieldName, int defaultValue = 0) returns int {
    if data !is map<json> {
        return defaultValue;
    }
    
    json fieldValue = data[fieldName];
    if fieldValue is int {
        return fieldValue;
    }
    return defaultValue;
}

// Safely extracts a boolean value from JSON with a default
// 
// + data - The JSON data
// + fieldName - The field name to extract
// + defaultValue - Default value if field is missing or null
// + return - The extracted boolean value or default
public isolated function getBooleanOrDefault(json data, string fieldName, boolean defaultValue = false) returns boolean {
    if data !is map<json> {
        return defaultValue;
    }
    
    json fieldValue = data[fieldName];
    if fieldValue is boolean {
        return fieldValue;
    }
    return defaultValue;
}

// ============================================================================
// EXAMPLE TRANSFORMER IMPLEMENTATION (SAP)
// ============================================================================

// Example: SAP-specific transformer for PurchaseOrder
// This demonstrates the pattern that implementers should follow
// 
// + sapData - SAP-specific JSON data
// + return - Canonical PurchaseOrder or TransformationError
public isolated function transformSapToPurchaseOrder(json sapData) returns PurchaseOrder|TransformationError {
    // Validate required fields
    ValidationError? validationResult = validateRequiredFields(sapData, ["PurchaseOrder", "PurchaseOrderDate", "Currency"]);
    if validationResult is ValidationError {
        return error TransformationError(validationResult.message(), validationResult);
    }

    // Extract vendor information
    if sapData !is map<json> {
        return error TransformationError("SAP data must be a JSON object");
    }
    
    json vendorData = sapData["Supplier"];
    if vendorData is () {
        return error TransformationError("Supplier information is missing");
    }

    Vendor vendor = {
        id: getStringOrDefault(vendorData, "SupplierID"),
        name: getStringOrDefault(vendorData, "SupplierName"),
        address: {
            street1: getStringOrDefault(vendorData, "Street"),
            city: getStringOrDefault(vendorData, "City"),
            postalCode: getStringOrDefault(vendorData, "PostalCode"),
            country: getStringOrDefault(vendorData, "Country")
        },
        contactDetails: {},
        currency: getStringOrDefault(sapData, "Currency")
    };

    // Extract line items
    json itemsData = sapData["Items"];
    PurchaseOrderItem[] items = [];
    
    if itemsData is json[] {
        int lineNum = 1;
        foreach json itemData in itemsData {
            decimal quantity = getDecimalOrDefault(itemData, "Quantity");
            decimal unitPrice = getDecimalOrDefault(itemData, "UnitPrice");
            
            PurchaseOrderItem item = {
                lineNumber: lineNum,
                sku: getStringOrDefault(itemData, "MaterialNumber"),
                description: getStringOrDefault(itemData, "Description"),
                quantity: quantity,
                unitPrice: unitPrice,
                lineTotal: quantity * unitPrice
            };
            items.push(item);
            lineNum = lineNum + 1;
        }
    }

    // Calculate totals
    decimal subtotal = 0.0;
    foreach PurchaseOrderItem item in items {
        subtotal = subtotal + item.lineTotal;
    }

    PurchaseOrder purchaseOrder = {
        id: getStringOrDefault(sapData, "PurchaseOrder"),
        poNumber: getStringOrDefault(sapData, "PurchaseOrder"),
        orderDate: getStringOrDefault(sapData, "PurchaseOrderDate"),
        currency: getStringOrDefault(sapData, "Currency"),
        vendor: vendor,
        items: items,
        subtotal: subtotal,
        grandTotal: subtotal,
        status: getStringOrDefault(sapData, "Status", "DRAFT")
    };

    return purchaseOrder;
}

// Example: Transform canonical PurchaseOrder to SAP format
// 
// + purchaseOrder - Canonical purchase order
// + return - SAP-specific JSON or TransformationError
public isolated function transformPurchaseOrderToSap(PurchaseOrder purchaseOrder) returns json|TransformationError {
    json[] sapItems = [];
    
    foreach PurchaseOrderItem item in purchaseOrder.items {
        json sapItem = {
            "MaterialNumber": item.sku,
            "Description": item.description ?: "",
            "Quantity": item.quantity,
            "UnitPrice": item.unitPrice,
            "UnitOfMeasure": item.unitOfMeasure ?: "EA"
        };
        sapItems.push(sapItem);
    }

    json sapPo = {
        "PurchaseOrder": purchaseOrder.poNumber,
        "PurchaseOrderDate": purchaseOrder.orderDate,
        "Currency": purchaseOrder.currency,
        "Status": purchaseOrder.status,
        "Supplier": {
            "SupplierID": purchaseOrder.vendor.id,
            "SupplierName": purchaseOrder.vendor.name,
            "Street": purchaseOrder.vendor.address.street1,
            "City": purchaseOrder.vendor.address.city,
            "PostalCode": purchaseOrder.vendor.address.postalCode,
            "Country": purchaseOrder.vendor.address.country
        },
        "Items": sapItems
    };

    return sapPo;
}
