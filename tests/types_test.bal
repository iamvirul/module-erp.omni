// Copyright (c) 2025, ERP Omni Module
// Test cases for canonical record types

import ballerina/test;

@test:Config {}
function testAddressRecord() {
    Address address = {
        street1: "123 Main St",
        street2: "Suite 100",
        city: "New York",
        stateProvince: "NY",
        postalCode: "10001",
        country: "US"
    };
    
    test:assertEquals(address.street1, "123 Main St", msg = "Street1 mismatch");
    test:assertEquals(address.city, "New York", msg = "City mismatch");
    test:assertEquals(address.country, "US", msg = "Country mismatch");
}

@test:Config {}
function testContactDetails() {
    ContactDetails contact = {
        email: "test@example.com",
        phone: "+1-555-0100",
        mobile: "+1-555-0101"
    };
    
    test:assertEquals(contact.email, "test@example.com", msg = "Email mismatch");
    test:assertEquals(contact.phone, "+1-555-0100", msg = "Phone mismatch");
}

@test:Config {}
function testCustomerRecord() {
    Customer customer = {
        id: "CUST-001",
        name: "Acme Corporation",
        displayName: "Acme Corp",
        billingAddress: {
            street1: "456 Business Ave",
            city: "San Francisco",
            postalCode: "94102",
            country: "US"
        },
        contactDetails: {
            email: "billing@acme.com",
            phone: "+1-555-0200"
        },
        taxId: "12-3456789",
        customerType: "ENTERPRISE",
        paymentTerms: "NET30",
        currency: "USD",
        active: true
    };
    
    test:assertEquals(customer.id, "CUST-001", msg = "Customer ID mismatch");
    test:assertEquals(customer.name, "Acme Corporation", msg = "Customer name mismatch");
    test:assertEquals(customer.currency, "USD", msg = "Currency mismatch");
    test:assertTrue(customer.active, msg = "Customer should be active");
}

@test:Config {}
function testVendorRecord() {
    Vendor vendor = {
        id: "VEND-001",
        name: "Supplier Inc",
        address: {
            street1: "789 Supply St",
            city: "Chicago",
            postalCode: "60601",
            country: "US"
        },
        contactDetails: {
            email: "orders@supplier.com"
        },
        currency: "USD"
    };
    
    test:assertEquals(vendor.id, "VEND-001", msg = "Vendor ID mismatch");
    test:assertEquals(vendor.name, "Supplier Inc", msg = "Vendor name mismatch");
}

@test:Config {}
function testPurchaseOrderItem() {
    PurchaseOrderItem item = {
        lineNumber: 1,
        sku: "WIDGET-001",
        description: "Premium Widget",
        quantity: 100,
        unitOfMeasure: "EA",
        unitPrice: 25.50,
        taxRate: 8.5,
        taxAmount: 216.75,
        lineTotal: 2550.00,
        discount: 50.00
    };
    
    test:assertEquals(item.lineNumber, 1, msg = "Line number mismatch");
    test:assertEquals(item.sku, "WIDGET-001", msg = "SKU mismatch");
    test:assertEquals(item.quantity, 100.0d, msg = "Quantity mismatch");
    test:assertEquals(item.unitPrice, 25.50d, msg = "Unit price mismatch");
    test:assertEquals(item.lineTotal, 2550.00d, msg = "Line total mismatch");
}

@test:Config {}
function testPurchaseOrder() {
    Vendor vendor = {
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
    };
    
    PurchaseOrderItem item = {
        lineNumber: 1,
        sku: "ITEM-001",
        quantity: 10,
        unitPrice: 100.00,
        lineTotal: 1000.00
    };
    
    PurchaseOrder po = {
        id: "PO-001",
        poNumber: "PO-2025-001",
        orderDate: "2025-01-15",
        currency: "USD",
        vendor: vendor,
        items: [item],
        subtotal: 1000.00,
        grandTotal: 1000.00,
        status: "DRAFT"
    };
    
    test:assertEquals(po.id, "PO-001", msg = "PO ID mismatch");
    test:assertEquals(po.poNumber, "PO-2025-001", msg = "PO number mismatch");
    test:assertEquals(po.status, "DRAFT", msg = "Status mismatch");
    test:assertEquals(po.items.length(), 1, msg = "Items count mismatch");
    test:assertEquals(po.grandTotal, 1000.00d, msg = "Grand total mismatch");
}

@test:Config {}
function testPaymentTerms() {
    PaymentTerms terms = {
        terms: "NET30",
        dueDays: 30,
        discountPercentage: 2.0,
        discountDays: 10
    };
    
    test:assertEquals(terms.terms, "NET30", msg = "Terms mismatch");
    test:assertEquals(terms.dueDays, 30, msg = "Due days mismatch");
    test:assertEquals(terms.discountPercentage, 2.0d, msg = "Discount percentage mismatch");
}

@test:Config {}
function testInvoice() {
    Customer customer = {
        id: "C-001",
        name: "Test Customer",
        billingAddress: {
            street1: "123 Customer St",
            city: "Seattle",
            postalCode: "98101",
            country: "US"
        },
        contactDetails: {},
        currency: "USD"
    };
    
    InvoiceItem item = {
        lineNumber: 1,
        sku: "PROD-001",
        quantity: 5,
        unitPrice: 200.00,
        lineTotal: 1000.00
    };
    
    PaymentTerms paymentTerms = {
        terms: "NET30",
        dueDays: 30
    };
    
    Invoice invoice = {
        id: "INV-001",
        invoiceNumber: "INV-2025-001",
        invoiceDate: "2025-01-15",
        currency: "USD",
        customer: customer,
        items: [item],
        subtotal: 1000.00,
        grandTotal: 1000.00,
        amountDue: 1000.00,
        amountPaid: 0.0,
        paymentTerms: paymentTerms,
        status: "DRAFT"
    };
    
    test:assertEquals(invoice.id, "INV-001", msg = "Invoice ID mismatch");
    test:assertEquals(invoice.invoiceNumber, "INV-2025-001", msg = "Invoice number mismatch");
    test:assertEquals(invoice.status, "DRAFT", msg = "Status mismatch");
    test:assertEquals(invoice.amountDue, 1000.00d, msg = "Amount due mismatch");
}

@test:Config {}
function testProduct() {
    Product product = {
        id: "PROD-001",
        sku: "WIDGET-PRO",
        name: "Professional Widget",
        description: "High-quality professional widget",
        category: "Electronics",
        unitPrice: 299.99,
        unitOfMeasure: "EA",
        active: true,
        taxCategory: "TAXABLE"
    };
    
    test:assertEquals(product.id, "PROD-001", msg = "Product ID mismatch");
    test:assertEquals(product.sku, "WIDGET-PRO", msg = "SKU mismatch");
    test:assertEquals(product.name, "Professional Widget", msg = "Name mismatch");
    test:assertEquals(product.unitPrice, 299.99d, msg = "Unit price mismatch");
    test:assertTrue(product.active, msg = "Product should be active");
}

@test:Config {}
function testCustomFieldsInRecords() {
    Customer customer = {
        id: "C-002",
        name: "Custom Fields Test",
        billingAddress: {
            street1: "123 Test St",
            city: "Test City",
            postalCode: "12345",
            country: "US"
        },
        contactDetails: {},
        currency: "USD",
        customFields: {
            "salesRep": "John Doe",
            "region": "West",
            "accountManager": "Jane Smith"
        }
    };
    
    test:assertEquals(customer.customFields["salesRep"], "John Doe", msg = "Custom field mismatch");
    test:assertEquals(customer.customFields["region"], "West", msg = "Custom field mismatch");
    test:assertEquals(customer.customFields.length(), 3, msg = "Custom fields count mismatch");
}
